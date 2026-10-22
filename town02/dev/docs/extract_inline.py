#!/usr/bin/env python3
"""Rattrapage : extrait les appels UI:WaitShowDialogue(...) situés au milieu
d'une ligne (coroutines, commentaires en fin de ligne)."""
import re, sys, json, pathlib

REPO = pathlib.Path(sys.argv[1]); MAP = sys.argv[2]; LUA = sys.argv[3]; PREFIX = sys.argv[4]
START = int(sys.argv[5]) if len(sys.argv) > 5 else 1

lua_path = REPO / f"Data/Script/halcyon/ground/{MAP}/{LUA}"
src_resx = REPO / f"Data/Script/halcyon/ground/{MAP}/strings.resx"
text = lua_path.read_text(encoding="utf-8")

def find_calls(s):
    """retourne les spans (start, end, inner) de UI:WaitShowDialogue(...)"""
    out = []
    for m in re.finditer(r'UI:WaitShowDialogue\(', s):
        # ignorer si commenté : chercher '--' avant sur la même ligne
        ls = s.rfind("\n", 0, m.start()) + 1
        if "--" in s[ls:m.start()]:
            continue
        depth, i, in_str = 1, m.end(), None
        while i < len(s) and depth:
            c = s[i]
            if in_str:
                if c == "\\": i += 2; continue
                if c == in_str: in_str = None
            elif c in "\"'": in_str = c
            elif c == "(": depth += 1
            elif c == ")": depth -= 1
            i += 1
        out.append((m.start(), i, s[m.end():i-1]))
    return out

def split_top(s, sep):
    parts, depth, i, cur, in_str = [], 0, 0, "", None
    while i < len(s):
        c = s[i]
        if in_str:
            cur += c
            if c == "\\": cur += s[i+1]; i += 2; continue
            if c == in_str: in_str = None
            i += 1; continue
        if c in "\"'": in_str = c; cur += c; i += 1; continue
        if c in "([{": depth += 1
        if c in ")]}": depth -= 1
        if depth == 0:
            if sep == ".." and s[i:i+2] == ".." and (i+2 >= len(s) or s[i+2] != "."):
                parts.append(cur); cur = ""; i += 2; continue
            if sep == "," and c == ",":
                parts.append(cur); cur = ""; i += 1; continue
        cur += c; i += 1
    parts.append(cur); return parts

def lua_unquote(s):
    s = s.strip(); body = s[1:-1]; out, i = "", 0
    while i < len(body):
        if body[i] == "\\":
            nxt = body[i+1]
            out += {"n":"\\n","t":"\\t","\\":"\\\\","\"":"\"","'":"'"}.get(nxt, nxt); i += 2
        else: out += body[i]; i += 1
    return out

def is_lit(seg):
    seg = seg.strip()
    return len(seg) >= 2 and seg[0] in "\"'" and seg[-1] == seg[0]

entries, counter, offset = [], START - 1, 0
new = text
for start, end, inner in find_calls(text):
    args = split_top(inner, ",")
    first = args[0].strip(); rest = args[1:]
    if first.startswith("STRINGS:Format(") and first.endswith(")"):
        first = first[len("STRINGS:Format("):-1].strip()
    if first.startswith("STRINGS.MapStrings"): continue
    segs = split_top(first, "..")
    if not any(is_lit(s) for s in segs): continue
    fmt, fargs = "", []
    for seg in segs:
        if is_lit(seg): fmt += lua_unquote(seg)
        else: fmt += "{%d}" % len(fargs); fargs.append(seg.strip())
    counter += 1
    key = f"{PREFIX}_{counter:03d}"
    entries.append((key, fmt))
    call = "UI:WaitShowDialogue(" + ", ".join(
        [f"STRINGS:Format(STRINGS.MapStrings['{key}']" + (", " + ", ".join(fargs) if fargs else "") + ")"]
        + [r.strip() for r in rest]) + ")"
    new = new[:start+offset] + call + new[end+offset:]
    offset += len(call) - (end - start)

lua_path.write_text(new, encoding="utf-8")
def esc(s): return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;")
resx = src_resx.read_text(encoding="utf-8-sig")
blocks = "".join(f'  <data name="{k}" xml:space="preserve">\n    <value>{esc(v)}</value>\n  </data>\n' for k, v in entries)
src_resx.write_text(resx.replace("</root>", blocks + "</root>"), encoding="utf-8")
out = pathlib.Path(f"/home/user/traduction/extract_{PREFIX}_extra.json")
json.dump(dict(entries), out.open("w", encoding="utf-8"), ensure_ascii=False, indent=1)
print(f"{len(entries)} extraits ({PREFIX}_{START:03d}..{PREFIX}_{counter:03d})")
