#!/usr/bin/env python3
"""Pilote d'extraction des dialogues codés en dur -> resx MapStrings.
Transforme UI:WaitShowDialogue("...") / UI:ChoiceMenuYesNo("...") en
UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['KEY'], args...))
et génère les entrées EN dans strings.resx.
"""
import re, sys, json, pathlib

REPO = pathlib.Path(sys.argv[1])
MAP = sys.argv[2]          # ex: relic_forest
LUA = sys.argv[3]          # ex: relic_forest_ch_1.lua
PREFIX = sys.argv[4]       # ex: RF1

lua_path = REPO / f"Data/Script/halcyon/ground/{MAP}/{LUA}"
src_resx = REPO / f"Data/Script/halcyon/ground/{MAP}/strings.resx"

text = lua_path.read_text(encoding="utf-8")
lines = text.split("\n")

def split_top(s, sep_chars):
    """split top-level on separator token (.. or ,) respecting quotes/parens/braces"""
    parts, depth, i, cur, n = [], 0, 0, "", len(s)
    in_str = None
    while i < n:
        c = s[i]
        if in_str:
            cur += c
            if c == "\\": cur += s[i+1]; i += 2; continue
            if c == in_str: in_str = None
            i += 1; continue
        if c in "\"'":
            in_str = c; cur += c; i += 1; continue
        if c in "([{": depth += 1
        if c in ")]}": depth -= 1
        if depth == 0:
            if sep_chars == ".." and s[i:i+2] == ".." and (i+2 >= n or s[i+2] != "."):
                parts.append(cur); cur = ""; i += 2; continue
            if sep_chars == "," and c == ",":
                parts.append(cur); cur = ""; i += 1; continue
        cur += c; i += 1
    parts.append(cur)
    return parts

def lua_unquote(s):
    s = s.strip()
    q = s[0]
    body = s[1:-1]
    out, i = "", 0
    while i < len(body):
        if body[i] == "\\":
            nxt = body[i+1]
            out += {"n":"\\n","t":"\\t","\\":"\\\\","\"":"\"","'":"'"}.get(nxt, nxt)
            i += 2
        else:
            out += body[i]; i += 1
    return out

def is_literal(seg):
    seg = seg.strip()
    return len(seg) >= 2 and seg[0] in "\"'" and seg[-1] == seg[0]

entries = []   # (key, en_text)
counter = 0
CALL_RE = re.compile(r'^(\s*)(UI:WaitShowDialogue|UI:ChoiceMenuYesNo)\((.*)\)(\s*)$')

for idx, line in enumerate(lines):
    stripped = line.strip()
    if stripped.startswith("--"):
        continue
    m = CALL_RE.match(line)
    if not m:
        continue
    indent, func, inner, tail = m.groups()
    args = split_top(inner, ",")
    first = args[0].strip()
    rest = args[1:]
    # déballer un éventuel STRINGS:Format(...) existant
    if first.startswith("STRINGS:Format(") and first.endswith(")"):
        first = first[len("STRINGS:Format("):-1].strip()
    segs = split_top(first, "..")
    if not all(is_literal(s) or True for s in segs):
        continue
    # au moins un littéral requis
    if not any(is_literal(s) for s in segs):
        continue
    fmt, fargs = "", []
    for seg in segs:
        if is_literal(seg):
            fmt += lua_unquote(seg)
        else:
            fmt += "{%d}" % len(fargs)
            fargs.append(seg.strip())
    counter += 1
    key = f"{PREFIX}_{counter:03d}"
    entries.append((key, fmt))
    call_args = [f"STRINGS:Format(STRINGS.MapStrings['{key}']" + (", " + ", ".join(fargs) if fargs else "") + ")"] + [r.strip() for r in rest]
    lines[idx] = f"{indent}{func}(" + ", ".join(call_args) + f"){tail.rstrip()}"

lua_path.write_text("\n".join(lines), encoding="utf-8")

# entrées EN dans strings.resx
def esc(s):
    return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;")
resx = src_resx.read_text(encoding="utf-8-sig")
blocks = "".join(f'  <data name="{k}" xml:space="preserve">\n    <value>{esc(v)}</value>\n  </data>\n' for k, v in entries)
resx = resx.replace("</root>", blocks + "</root>")
src_resx.write_text(resx, encoding="utf-8")

json.dump(dict(entries), open(f"/home/user/traduction/extract_{PREFIX}.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print(f"{len(entries)} dialogues extraits -> clés {PREFIX}_001..{PREFIX}_{counter:03d}")
