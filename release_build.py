#!/usr/bin/env python3
"""Cut a release of the RGS sub-system firmware.

Run it through release_build.bat, which is a thin wrapper.

WHAT IT DOES
    For each project - bootloader, application, bring-up jig - work out what
    the hex file WOULD be called, from that project's own firmware_version.h,
    and look for that name in the project's directory under
    SubSystemFirmware/firmware. Then:

      * the same name is already there  -> skip it. The version has not been
        incremented, so there is nothing new to publish.
      * the target holds a NEWER version -> skip it, and say so. Publishing
        backwards would replace a later image with an earlier one.
      * otherwise                       -> build the default configuration
        and publish it.

    A project that fails to build is reported and the release moves on to the
    next one, so one broken project does not hide the state of the other two.
    Every outcome is listed in a summary at the end, with a reason for anything
    that was not built.

    The EEPROM map is published to SubSystemFirmware/include - which sits
    beside firmware/, not inside it: the map is an interface definition, not a
    build artefact.

WHY THE TARGET DIRECTORY IS THE RECORD
    The published file name carries its own version, so the question "has this
    been released?" is answered by one directory listing. There is no scan of
    source timestamps: the version in firmware_version.h is the thing that
    decides whether a build is wanted, and it is edited by hand precisely when
    a new image is intended. Source newer than the published hex but with the
    version unchanged is NOT silently rebuilt - it is reported as "not
    incremented version", which is the mistake worth hearing about.

WHAT IT DELIBERATELY DOES NOT DO
    - No standalone configurations and no combined bootloader+jig image. The
      only output is one default hex per project.
    - No archive of previous hex files. History is git's job.
    - No copy to the development tree. One destination per artefact.
    - No editing of firmware_version.h. Versions and release-candidate numbers
      are managed by hand; this only reads them.

Replaced release_build.bat's own logic on 2026-10-06. It moved to Python because
the work needs a C header parsed and conditional publishing - which batch can
do, but not safely, and a botched rewrite of a version header is an expensive
kind of bug. It is also easier to move to Linux if the build host ever does.
"""

import os
import re
import shutil
import subprocess
import sys

# ---------------------------------------------------------------- locations

ROOT = os.path.dirname(os.path.abspath(__file__))
SUBSYS = r"C:\SubSystemFirmware"
FIRMWARE = os.path.join(SUBSYS, "firmware")   # the three hex files
INCLUDE = os.path.join(SUBSYS, "include")     # the EEPROM map - NOT under firmware/

MPLAB_BIN = r"C:\Program Files\Microchip\MPLABX\v6.25\mplab_platform\bin"
MAKE_BIN = r"C:\Program Files\Microchip\MPLABX\v6.25\gnuBins\GnuWin32\bin"
PRJ_GEN = os.path.join(MPLAB_BIN, "prjMakefilesGenerator.bat")

COMMON = os.path.join(ROOT, "CommonFiles")

MAP_HEADER = os.path.join(COMMON, "header", "EEpromBlockLabels.h")
MAP_CONVERTER = os.path.join(ROOT, "eeprom_header_to_python.py")
MAP_PYTHON_NAME = "EEpromBlockLabels_h_InPython.py"

# ---------------------------------------------------------------- projects

# name     : MPLAB project directory
# hexstem  : output file stem, per the naming scheme
# dest     : directory under firmware/ that receives it
PROJECTS = [
    {"name": "Bootloader_V2.X", "hexstem": "RGS_PG_bootloader", "dest": "bootloader"},
    {"name": "PuttingGate.X",   "hexstem": "RGS_PG_SubSystem",  "dest": "application"},
    {"name": "RGS_BringUp.X",   "hexstem": "RGS_PG_bringup",    "dest": "bringup"},
]


class ReleaseError(Exception):
    """Anything that should stop the release with a message, not a traceback."""


# ---------------------------------------------------------------- versions

VERSION_FIELDS = ("FIRMWARE_REV_MSB", "FIRMWARE_REV_LSB", "FIRMWARE_REV_MINOR")


def read_version(project_dir):
    """Parse X.Y.Z and the release-candidate number out of firmware_version.h.

    Missing fields are an error rather than a default: a release named from a
    guessed version is worse than one that does not happen.
    """
    path = os.path.join(project_dir, "firmware_version.h")
    if not os.path.isfile(path):
        raise ReleaseError(f"no firmware_version.h in {project_dir}")

    text = open(path, encoding="utf-8", errors="replace").read()

    def field(name, required=True):
        m = re.search(r"^\s*#define\s+" + name + r"\s+(-?\d+)", text, re.M)
        if m:
            return int(m.group(1))
        if required:
            raise ReleaseError(
                f"{os.path.basename(project_dir)}/firmware_version.h has no "
                f"#define {name} - add it, then re-run")
        return 0

    msb, lsb, minor = (field(f) for f in VERSION_FIELDS)

    # Required, NOT defaulted. It was optional-with-zero, which meant that
    # renaming the macro - ReleaseCandidate became FIRMWARE_RC - silently read
    # as "not a candidate" and published three test builds under release
    # names. A missing RC now stops the release instead of being guessed at.
    # Zero is still a perfectly good value; it means "released".
    rc = field("FIRMWARE_RC")
    return msb, lsb, minor, rc


def hex_name(stem, msb, lsb, minor, rc):
    """RGS_PG_thing-X.Y.Z.hex, or -X.Y.Z-rcR.hex for a release candidate.

    A non-zero ReleaseCandidate marks a test build, and the suffix keeps those
    from being mistaken for - or overwriting - a real release.
    """
    name = f"{stem}-{msb}.{lsb}.{minor}"
    if rc:
        name += f"-rc{rc}"
    return name + ".hex"


def version_text(msb, lsb, minor, rc):
    return f"{msb}.{lsb}.{minor}" + (f"-rc{rc}" if rc else "")


def version_key(msb, lsb, minor, rc):
    """Sort key that orders release candidates BEFORE the release they precede.

    rc1 -> rc2 -> final, so 3.6.0-rc1 < 3.6.0-rc2 < 3.6.0: the order those
    names are read in everywhere else. A ReleaseCandidate of 0 means "not a
    candidate at all", which is why it sorts ABOVE any candidate of the same
    X.Y.Z rather than below it.
    """
    return (msb, lsb, minor, 0 if rc else 1, rc)


def parse_hex_version(stem, filename):
    """Recover (msb, lsb, minor, rc) from a published file name.

    Returns None for anything that is not this project's naming scheme, so a
    hex dropped into the directory by hand is never read as a published
    version and never compared against.
    """
    m = re.match(re.escape(stem) + r"-(\d+)\.(\d+)\.(\d+)(?:-rc(\d+))?\.hex$",
                 filename, re.I)
    if not m:
        return None
    msb, lsb, minor, rc = m.groups()
    return int(msb), int(lsb), int(minor), int(rc or 0)


def published(dest_dir, stem):
    """What a target directory already holds.

    Returns (recognised, foreign):
      recognised - [((msb,lsb,minor,rc), filename)] matching the scheme
      foreign    - other .hex names, reported but never used as a version

    Only .hex files are considered. These directories also hold the host
    tooling that loads the image, and that is none of this function's business.
    """
    if not os.path.isdir(dest_dir):
        return [], []

    recognised, foreign = [], []
    for f in sorted(os.listdir(dest_dir)):
        if not os.path.isfile(os.path.join(dest_dir, f)):
            continue
        if not f.lower().endswith(".hex"):
            continue
        v = parse_hex_version(stem, f)
        if v is None:
            foreign.append(f)
        else:
            recognised.append((v, f))
    return recognised, foreign


# ---------------------------------------------------------------- the decision

REASON_SAME = "not incremented version"
REASON_BACKWARDS = "illegal, cannot go backwards"
REASON_FAILED = "build errors"


def decide(entry):
    """Build this project, or not, judged entirely from the target directory.

    Returns (code, reason, foreign) where code is one of:
      "build"     - go ahead
      "same"      - this exact file is already published
      "backwards" - something newer is already published

    reason is a full phrase ready for the summary; foreign lists any .hex in
    the target that does not match the naming scheme.
    """
    want = entry["hex"]
    want_key = version_key(*entry["ver"])
    recognised, foreign = published(entry["dest_dir"], entry["hexstem"])

    if any(f == want for _, f in recognised):
        return "same", f"{REASON_SAME} ({want} is already published)", foreign

    newer = [(v, f) for v, f in recognised if version_key(*v) > want_key]
    if newer:
        v, _f = max(newer, key=lambda x: version_key(*x[0]))
        return ("backwards",
                f"{REASON_BACKWARDS} (target holds {version_text(*v)}, "
                f"this tree asks for {version_text(*entry['ver'])})",
                foreign)

    return "build", "", foreign


# ---------------------------------------------------------------- building

def run(cmd, cwd=None, env=None):
    return subprocess.run(cmd, cwd=cwd, env=env, shell=isinstance(cmd, str),
                          capture_output=True, text=True)


def built_hex_path(project_dir, project_name):
    return os.path.join(project_dir, "dist", "default", "production",
                        f"{project_name}.production.hex")


def build(project_dir, project_name):
    """Regenerate the makefiles, then clean-build the default configuration.

    prjMakefilesGenerator first is load-bearing: it rebuilds Makefile-default.mk
    from configurations.xml, which is what stops a stale makefile silently
    building the wrong file list.

    Raises ReleaseError on failure. The caller catches it per project so the
    release can carry on and report the rest.
    """
    env = dict(os.environ)
    env["PATH"] = MAKE_BIN + os.pathsep + env.get("PATH", "")

    r = run([PRJ_GEN, project_dir], env=env)
    if r.returncode != 0:
        raise ReleaseError(f"makefile generation failed\n"
                           + (r.stdout or "") + (r.stderr or ""))

    r = run("make CONF=default clean build", cwd=project_dir, env=env)
    out = (r.stdout or "") + (r.stderr or "")
    if r.returncode != 0:
        tail = "\n".join(out.splitlines()[-20:])
        raise ReleaseError(f"compile/link failed\n{tail}")

    warnings = [l.strip() for l in out.splitlines() if "warning:" in l]
    mem = [l.strip() for l in out.splitlines() if "memory used" in l]
    return warnings, mem


# ---------------------------------------------------------------- publishing

def publish(src, dest_dir, filename):
    """Put one file into a directory that holds only that image.

    Any OTHER .hex is deleted: the directory answers "which image?" and must
    not offer a choice.

    ONLY .hex files are touched. These directories also hold the host tooling
    that loads the image - BringUpTest.py, picprog.py, the settings file - and
    that tooling reads the hex from the directory it lives beside. Sweeping the
    directory clean would delete the very scripts that use it, silently, in the
    middle of a release.

    A file of the same name should have been caught by decide() long before
    this; the guard below is for a logic error, not for normal use.
    """
    os.makedirs(dest_dir, exist_ok=True)
    existing = [f for f in os.listdir(dest_dir)
                if os.path.isfile(os.path.join(dest_dir, f))
                and f.lower().endswith(".hex")]

    if filename in existing:
        raise ReleaseError(
            f"internal: {filename} already in {dest_dir}, which decide() "
            f"should have caught. Nothing published.")

    for f in existing:
        os.remove(os.path.join(dest_dir, f))

    shutil.copy2(src, os.path.join(dest_dir, filename))
    return existing


def publish_if_changed(src, dest_dir, filename):
    """For the EEPROM map: replace only when the content differs.

    Unlike the hex files these have fixed names and are imported by name, so
    there is nothing to collide with - the only question is whether anything
    actually changed.
    """
    os.makedirs(dest_dir, exist_ok=True)
    dest = os.path.join(dest_dir, filename)

    if os.path.isfile(dest):
        if open(src, "rb").read() == open(dest, "rb").read():
            return False
        os.remove(dest)

    shutil.copy2(src, dest)
    return True


# ---------------------------------------------------------------- the release

def generate_map():
    """Convert EEpromBlockLabels.h to its Python mirror, into a temp location.

    Done before anything is built: a header that will not convert should stop
    the release in the first second, not after several minutes of compiling.
    """
    if not os.path.isfile(MAP_HEADER):
        raise ReleaseError(f"{MAP_HEADER} not found")

    tmp = os.path.join(ROOT, MAP_PYTHON_NAME + ".new")
    r = run([sys.executable, MAP_CONVERTER, MAP_HEADER, tmp])
    if r.returncode != 0:
        raise ReleaseError("EEpromBlockLabels.h did not convert:\n"
                           + (r.stdout or "") + (r.stderr or ""))
    return tmp


def main():
    print("=" * 60)
    print(" RGS sub-system release build")
    print("=" * 60)

    for path, what in ((SUBSYS, "release tree"), (MPLAB_BIN, "MPLAB X"),
                       (MAKE_BIN, "MPLAB make")):
        if not os.path.isdir(path):
            raise ReleaseError(f"{what} not found: {path}")

    # ---- versions first, so a missing #define stops us before any building
    plan = []
    for p in PROJECTS:
        project_dir = os.path.join(ROOT, p["name"])
        if not os.path.isdir(project_dir):
            raise ReleaseError(f"project not found: {project_dir}")
        ver = read_version(project_dir)
        plan.append({**p,
                     "dir": project_dir,
                     "dest_dir": os.path.join(FIRMWARE, p["dest"]),
                     "ver": ver,
                     "hex": hex_name(p["hexstem"], *ver),
                     "version": version_text(*ver)})

    print("\nVersions in this tree:")
    for e in plan:
        print(f"  {e['name']:<18} {e['version']:<12} -> {e['hex']}")

    # ---- EEPROM map
    print("\n[map] EEpromBlockLabels")
    tmp_py = generate_map()
    changed_h = publish_if_changed(MAP_HEADER, INCLUDE, "EEpromBlockLabels.h")
    changed_py = publish_if_changed(tmp_py, INCLUDE, MAP_PYTHON_NAME)
    os.remove(tmp_py)
    print(f"  EEpromBlockLabels.h   {'updated' if changed_h else 'unchanged'}")
    print(f"  {MAP_PYTHON_NAME}  {'updated' if changed_py else 'unchanged'}")
    map_line = ("updated" if (changed_h or changed_py) else "unchanged")

    # ---- projects. One entry per project, whatever happened to it.
    outcomes = []
    for e in plan:
        print(f"\n[{e['name']}]")
        code, reason, foreign = decide(e)

        for f in foreign:
            print(f"  note: {f} does not match the naming scheme, so it is "
                  f"not read as a published version")

        if code != "build":
            print(f"  NOT BUILT: {reason}")
            outcomes.append((e, code, reason))
            continue

        print(f"  building default -> {e['hex']}")
        try:
            warnings, mem = build(e["dir"], e["name"])
            for w in warnings:
                print(f"     {w}")
            print(f"  {len(warnings)} warning(s)")
            for m in mem:
                print(f"  {m}")

            src = built_hex_path(e["dir"], e["name"])
            if not os.path.isfile(src):
                raise ReleaseError(f"build reported success but produced no "
                                   f"hex at {src}")

            removed = publish(src, e["dest_dir"], e["hex"])
            for r in removed:
                print(f"  removed {r}")
            print(f"  -> {os.path.join(e['dest_dir'], e['hex'])}")
            outcomes.append((e, "built", ""))

        except ReleaseError as exc:
            # Reported, not fatal: the other projects still have something
            # useful to say, and a summary listing two successes and one
            # failure is more informative than stopping at the failure.
            print(f"  NOT BUILT: {REASON_FAILED}")
            print("  " + str(exc).replace("\n", "\n  "))
            outcomes.append((e, "failed", f"{REASON_FAILED} - see "
                                          f"[{e['name']}] above"))

    # ---- summary
    built = [o for o in outcomes if o[1] == "built"]
    bad = [o for o in outcomes if o[1] in ("failed", "backwards")]

    print("\n" + "=" * 60)
    print(" Summary")
    print("=" * 60)
    for e, code, reason in outcomes:
        if code == "built":
            print(f"   BUILT       {e['name']:<18} {e['hex']}")
        else:
            print(f"   not built   {e['name']:<18} {reason}")
    print(f"   EEPROM map  {'':<18} {map_line}")

    if not built:
        print("\n   No images were published.")
    if bad:
        print(f"\n   {len(bad)} project(s) need attention - see the reasons above.")
    print("=" * 60)

    # Nothing built because nothing was incremented is a normal, successful
    # run. A failed build, or a version that went backwards, is not.
    return 1 if bad else 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except ReleaseError as exc:
        print(f"\nERROR: {exc}")
        sys.exit(1)
