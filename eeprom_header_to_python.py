"""
eeprom_header_to_python.py - turn EEpromBlockLabels.h into an importable
Python module, so the Jetson side shares the firmware's names and values
instead of a hand-kept copy that drifts.

    python eeprom_header_to_python.py <EEpromBlockLabels.h> <output.py>

Run by release_build.bat, which always feeds it the copy in
CommonFiles/header - the same copy the firmware in that release was built
from.

Every #define becomes NAME = value, in header order, so each name is defined
before anything uses it. Comments come across as # comments, trailing ones
included, so the header's explanations survive.

It translates only what it can translate exactly, and otherwise stops with an
error naming the line: a macro with arguments, a cast, sizeof, a string, or a
name used before it is defined. A wrong value in the output would be taken by
the Jetson as the truth, so refusing the release is the better failure.

The result is written to a temporary file and IMPORTED before it replaces the
output, so a file that does not load is never published - the previous one is
left untouched instead.
"""

import importlib.machinery
import importlib.util
import keyword
import os
import re
import sys


# One value token at a time. Whitespace is kept so the output reads like the
# header. Integer suffixes (u, U, l, L) are C-only and are dropped.
TOKEN = re.compile(r"""
    (?P<ws>\s+)
  | (?P<hex>0[xX][0-9a-fA-F]+)[uUlL]*
  | (?P<bin>0[bB][01]+)[uUlL]*
  | (?P<dec>[0-9]+)[uUlL]*
  | (?P<name>[A-Za-z_][A-Za-z0-9_]*)
  | (?P<op><<|>>|[-+*/%&|^~()])
""", re.VERBOSE)

# Name directly followed by "(" is a macro with arguments; "NAME (expr)" with a
# space is an ordinary define whose value happens to start with a bracket.
DEFINE = re.compile(r"#\s*define\s+([A-Za-z_][A-Za-z0-9_]*)(\(?)\s*(.*)$")
DIRECTIVE = re.compile(r"#\s*([A-Za-z_]+)\s*(.*)$")


class ConvertError(Exception):
    pass


def fail(line_no, message):
    raise ConvertError("line %d: %s" % (line_no, message))


def split_line(line, in_block):
    """Split one source line into (code, comment, in_block_after).

    comment is None when the line carries no comment at all, and a (possibly
    empty) string when it does - so an empty line inside a block comment still
    comes across as a bare "#", keeping the block's shape."""
    code = []
    comment = []
    had_comment = in_block
    i = 0
    while i < len(line):
        if in_block:
            end = line.find("*/", i)
            if end < 0:
                comment.append(line[i:])
                break
            comment.append(line[i:end])
            i = end + 2
            in_block = False
        else:
            s_line = line.find("//", i)
            s_block = line.find("/*", i)
            starts = [p for p in (s_line, s_block) if p >= 0]
            if not starts:
                code.append(line[i:])
                break
            p = min(starts)
            code.append(line[i:p])
            had_comment = True
            if p == s_line:
                comment.append(line[p + 2:])
                break
            i = p + 2
            in_block = True
    text = " ".join(c.rstrip() for c in comment if c.strip())
    return "".join(code), (text if had_comment else None), in_block


def translate(value, known, line_no):
    """C constant expression -> the same expression in Python."""
    out = []
    pos = 0
    saw_value = False
    while pos < len(value):
        m = TOKEN.match(value, pos)
        if not m:
            fail(line_no, "cannot translate %r in value %r - only numbers, names "
                          "defined above, brackets and + - * / %% << >> & | ^ ~ "
                          "are supported" % (value[pos], value))
        pos = m.end()
        if m.group("ws") is not None:
            out.append(m.group("ws"))
            continue
        saw_value = True
        if m.group("hex") is not None:
            out.append(m.group("hex"))
        elif m.group("bin") is not None:
            out.append(m.group("bin"))
        elif m.group("dec") is not None:
            digits = m.group("dec")
            if len(digits) > 1 and digits[0] == "0":
                # C octal. Python rejects a bare leading zero, so spell it out.
                if any(d not in "01234567" for d in digits):
                    fail(line_no, "%r is not a valid C octal number" % digits)
                out.append("0o" + digits[1:])
            else:
                out.append(digits)
        elif m.group("name") is not None:
            name = m.group("name")
            if name not in known:
                fail(line_no, "uses %r, which is not defined above it in this "
                              "header (a cast, sizeof, or a name from another "
                              "file cannot be translated)" % name)
            out.append(name)
        else:
            op = m.group("op")
            # C integer division truncates; Python's / would give a float.
            out.append("//" if op == "/" else op)
    if not saw_value:
        fail(line_no, "empty value")
    return "".join(out).strip()


def emit_comment(out, text):
    out.append("#" + text if text.startswith(" ") or not text else "# " + text)


def convert(src_path):
    with open(src_path, "rb") as f:
        raw = f.read()
    try:
        text = raw.decode("utf-8")
    except UnicodeDecodeError:
        text = raw.decode("cp1252")

    src_name = os.path.basename(src_path)
    out = [
        "# " + "=" * 74,
        "# GENERATED FILE - DO NOT EDIT BY HAND",
        "#",
        "# Generated from %s by eeprom_header_to_python.py," % src_name,
        "# run as part of release_build.bat. Any change made here is lost at the",
        "# next release: change the .h instead.",
        "# " + "=" * 74,
        "",
    ]

    known = {}          # name -> header line number
    in_block = False
    guard = None
    cond_stack = []     # "guard" or "cplusplus"
    blanks = 0

    for line_no, line in enumerate(text.splitlines(), 1):
        code, comment, in_block = split_line(line, in_block)
        code = code.strip()
        skipping = "cplusplus" in cond_stack

        if not code:
            if skipping:
                continue
            if comment is None:
                blanks += 1
                if blanks <= 2:
                    out.append("")
            else:
                blanks = 0
                emit_comment(out, comment)
            continue

        if code.endswith("\\"):
            fail(line_no, "line continuation is not supported - keep each "
                          "#define on one line")

        if code.startswith("#"):
            d = DIRECTIVE.match(code)
            if not d:
                fail(line_no, "unrecognised directive %r" % code)
            directive, rest = d.group(1), d.group(2).strip()

            if directive == "ifdef" and rest == "__cplusplus":
                cond_stack.append("cplusplus")
                continue
            if directive == "ifndef" and guard is None and not cond_stack:
                cond_stack.append("guard")
                guard = rest
                continue
            if directive == "endif":
                if not cond_stack:
                    fail(line_no, "#endif without a matching #if")
                cond_stack.pop()
                continue
            if skipping:
                continue

            if directive == "define":
                m = DEFINE.match(code)
                if not m:
                    fail(line_no, "malformed #define %r" % code)
                name, paren, value = m.group(1), m.group(2), m.group(3).strip()
                if paren:
                    fail(line_no, "%s is a macro with arguments, which has no "
                                  "Python equivalent" % name)
                if not value:
                    if name == guard:
                        continue            # the include guard itself
                    fail(line_no, "%s is defined with no value" % name)
                if keyword.iskeyword(name):
                    fail(line_no, "%r is a Python keyword and cannot be a "
                                  "Python name" % name)
                if name in known:
                    fail(line_no, "%s is already defined at line %d"
                                  % (name, known[name]))
                expr = translate(value, known, line_no)
                known[name] = line_no
                blanks = 0
                if comment and comment.strip():
                    out.append("%s = %s  # %s" % (name, expr, comment.strip()))
                else:
                    out.append("%s = %s" % (name, expr))
                continue

            fail(line_no, "#%s is not supported - this header should contain "
                          "only #defines" % directive)

        if skipping:
            continue
        fail(line_no, "unexpected C code %r - this header should contain only "
                      "#defines" % code)

    if in_block:
        raise ConvertError("end of file inside a /* */ comment")
    if cond_stack:
        raise ConvertError("end of file with an unclosed #if")
    if not known:
        raise ConvertError("no #defines found")

    while out and out[-1] == "":
        out.pop()
    return "\n".join(out) + "\n", known


def check_import(path, known):
    """Import the generated file and confirm every name loaded as an integer."""
    sys.dont_write_bytecode = True      # no __pycache__ left behind
    loader = importlib.machinery.SourceFileLoader("eeprom_map_check", path)
    spec = importlib.util.spec_from_loader(loader.name, loader)
    module = importlib.util.module_from_spec(spec)
    try:
        loader.exec_module(module)
    except Exception as e:
        raise ConvertError("generated file does not import: %s: %s"
                           % (type(e).__name__, e))
    for name, line_no in known.items():
        v = getattr(module, name, None)
        if not isinstance(v, int) or isinstance(v, bool):
            raise ConvertError("line %d: %s did not evaluate to an integer (%r)"
                               % (line_no, name, v))


def main(argv):
    if len(argv) != 3:
        print("usage: python eeprom_header_to_python.py <EEpromBlockLabels.h> "
              "<output.py>", file=sys.stderr)
        return 2
    src, dst = argv[1], argv[2]
    tmp = dst + ".tmp"
    try:
        body, known = convert(src)
        with open(tmp, "w", encoding="utf-8", newline="\n") as f:
            f.write(body)
        check_import(tmp, known)
        os.replace(tmp, dst)
    except (ConvertError, OSError) as e:
        if os.path.exists(tmp):
            os.remove(tmp)
        print("ERROR: %s: %s" % (src, e), file=sys.stderr)
        return 1
    print("%d names -> %s" % (len(known), dst))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
