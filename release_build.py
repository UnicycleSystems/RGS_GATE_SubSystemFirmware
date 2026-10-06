#!/usr/bin/env python3
"""Cut a release of the RGS sub-system firmware.

Run it through release_build.bat, which is a thin wrapper.

WHAT IT DOES
    For each project - bootloader, application, bring-up jig - build the DEFAULT
    configuration if any source has changed since the last build, name the hex
    from that project's own firmware_version.h, and publish it to its directory
    under SubSystemFirmware/firmware. Then publish the EEPROM map, if it has
    changed, to SubSystemFirmware/include - which sits beside firmware/, not
    inside it: the map is an interface definition, not a build artefact.

WHAT IT DELIBERATELY DOES NOT DO
    - No standalone configurations and no combined bootloader+jig image. The
      only output is one default hex per project.
    - No archive of previous hex files. History is git's job.
    - No copy to the development tree. One destination per artefact.
    - No editing of firmware_version.h. Versions and release-candidate numbers
      are managed by hand; this only reads them.

Replaced release_build.bat's own logic on 2026-10-06. It moved to Python because
the work needs a C header parsed, file timestamps compared across directories,
and conditional publishing - all of which batch can do, but not safely, and a
botched rewrite of a version header is an expensive kind of bug. It is also
easier to move to Linux if the build host ever does.
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

# Shared sources: every project links these, so a change here rebuilds all of
# them. Scanned alongside each project's own directory.
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

# Directories inside a project that are OUTPUT, not source. Excluded from the
# change scan or every build would look like it had changes.
BUILD_DIRS = {"build", "dist", "debug", "disassembly"}


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
    rc = field("ReleaseCandidate", required=False)
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


# ---------------------------------------------------------------- changes

def newest_mtime(root):
    """Most recent modification time under root, ignoring build output."""
    newest = 0.0
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d.lower() not in BUILD_DIRS]
        for f in filenames:
            try:
                t = os.path.getmtime(os.path.join(dirpath, f))
            except OSError:
                continue
            if t > newest:
                newest = t
    return newest


def built_hex_path(project_dir, project_name):
    base = os.path.splitext(project_name)[0]          # "PuttingGate.X" -> ...
    return os.path.join(project_dir, "dist", "default", "production",
                        f"{project_name}.production.hex")


def needs_build(project_dir, project_name):
    """True when any source is newer than the last build output.

    Compares against the hex MPLAB produces, not against what was published:
    the question is whether the build is stale, which is a property of the
    project rather than of the release directory.
    """
    out = built_hex_path(project_dir, project_name)
    if not os.path.isfile(out):
        return True, "no previous build"

    built = os.path.getmtime(out)
    newest = max(newest_mtime(project_dir), newest_mtime(COMMON))
    if newest > built:
        return True, "sources changed"
    return False, "up to date"


# ---------------------------------------------------------------- building

def run(cmd, cwd=None, env=None):
    return subprocess.run(cmd, cwd=cwd, env=env, shell=isinstance(cmd, str),
                          capture_output=True, text=True)


def build(project_dir, project_name):
    """Regenerate the makefiles, then clean-build the default configuration.

    prjMakefilesGenerator first is load-bearing: it rebuilds Makefile-default.mk
    from configurations.xml, which is what stops a stale makefile silently
    building the wrong file list.
    """
    env = dict(os.environ)
    env["PATH"] = MAKE_BIN + os.pathsep + env.get("PATH", "")

    r = run([PRJ_GEN, project_dir], env=env)
    if r.returncode != 0:
        raise ReleaseError(f"makefile generation failed for {project_name}\n"
                           + (r.stdout or "") + (r.stderr or ""))

    r = run("make CONF=default clean build", cwd=project_dir, env=env)
    out = (r.stdout or "") + (r.stderr or "")
    if r.returncode != 0:
        tail = "\n".join(out.splitlines()[-20:])
        raise ReleaseError(f"BUILD FAILED: {project_name}\n{tail}")

    warnings = [l.strip() for l in out.splitlines() if "warning:" in l]
    mem = [l.strip() for l in out.splitlines() if "memory used" in l]
    return warnings, mem


# ---------------------------------------------------------------- publishing

def publish(src, dest_dir, filename):
    """Put one file into a directory that holds only that file.

    If a file of the SAME NAME is already there, stop the whole release. That
    means a build was cut without the version being changed, and quietly
    replacing it would leave two different images that cannot be told apart -
    which has already cost this project a day of confusion. Any OTHER contents
    are deleted: the directory answers "which image?" and must not offer a
    choice.
    """
    os.makedirs(dest_dir, exist_ok=True)
    existing = [f for f in os.listdir(dest_dir)
                if os.path.isfile(os.path.join(dest_dir, f))]

    if filename in existing:
        raise ReleaseError(
            f"{os.path.join(dest_dir, filename)} already exists.\n"
            f"         The version in firmware_version.h has not changed since "
            f"that file was published.\n"
            f"         Bump the version (or the ReleaseCandidate) and re-run. "
            f"Nothing has been published.")

    for f in existing:
        os.remove(os.path.join(dest_dir, f))

    shutil.copy2(src, os.path.join(dest_dir, filename))
    return [f for f in existing]


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
        msb, lsb, minor, rc = read_version(project_dir)
        plan.append({**p, "dir": project_dir,
                     "hex": hex_name(p["hexstem"], msb, lsb, minor, rc),
                     "version": f"{msb}.{lsb}.{minor}" + (f" rc{rc}" if rc else "")})

    print("\nVersions:")
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

    # ---- projects
    built, skipped = [], []
    for e in plan:
        print(f"\n[{e['name']}]")
        do_build, why = needs_build(e["dir"], e["name"])
        if not do_build:
            print(f"  {why} - not rebuilt, nothing published")
            skipped.append(e)
            continue

        print(f"  {why} - building default")
        warnings, mem = build(e["dir"], e["name"])
        print(f"  {len(warnings)} warning(s)")
        for w in warnings:
            print(f"     {w}")
        for m in mem:
            print(f"  {m}")

        src = built_hex_path(e["dir"], e["name"])
        if not os.path.isfile(src):
            raise ReleaseError(f"build produced no hex: {src}")

        dest_dir = os.path.join(FIRMWARE, e["dest"])
        removed = publish(src, dest_dir, e["hex"])
        for r in removed:
            print(f"  removed {r}")
        print(f"  -> {os.path.join(dest_dir, e['hex'])}")
        built.append(e)

    # ---- summary
    print("\n" + "=" * 60)
    print(" Release complete.")
    for e in built:
        print(f"   built     {e['name']:<18} {e['hex']}")
    for e in skipped:
        print(f"   unchanged {e['name']:<18} ({e['hex']} not republished)")
    if not built:
        print("   nothing had changed - no images published")
    print("=" * 60)
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except ReleaseError as exc:
        print(f"\nERROR: {exc}")
        sys.exit(1)
