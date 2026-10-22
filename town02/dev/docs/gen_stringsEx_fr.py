#!/usr/bin/env python3
"""Génère Strings/stringsEx.fr.resx à partir du strings anglais + dictionnaires FR par tranches."""
import re, sys, json, pathlib
import xml.etree.ElementTree as ET

REPO = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else ".")
SRC = REPO / "Strings/stringsEx.resx"
DST = REPO / "Strings/stringsEx.fr.resx"
TR_DIR = pathlib.Path(__file__).parent / "fr"

src = SRC.read_text(encoding="utf-8-sig")
cut = src.rindex("</resheader>") + len("</resheader>")
head = src[:cut] + "\n"

# clés source dans l'ordre (après les resheaders uniquement)
body = src[cut:]
src_keys = re.findall(r'<data name="([^"]+)"', body)

FR = {}
for f in sorted(TR_DIR.glob("*.json")):
    d = json.loads(f.read_text(encoding="utf-8"))
    dup = set(d) & set(FR)
    if dup: print(f"ATTENTION doublons dans {f.name}: {sorted(dup)[:5]}")
    FR.update(d)

extra = [k for k in FR if k not in src_keys]
if extra:
    raise SystemExit(f"Clés FR inconnues de la source: {extra[:10]}")

def esc(s):
    return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;")

blocks = "".join(
    f'  <data name="{k}" xml:space="preserve">\n    <value>{esc(FR[k])}</value>\n  </data>\n'
    for k in src_keys if k in FR)
DST.write_text(head + blocks + "</root>", encoding="utf-8")
ET.parse(DST)
done = len([k for k in src_keys if k in FR])
print(f"OK : {done}/{len(src_keys)} clés FR, XML valide -> {DST}")
from collections import Counter
c = Counter(k.split('_')[0] for k in src_keys if k not in FR)
print("restant par groupe:", dict(c.most_common()))
