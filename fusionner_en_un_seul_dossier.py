#!/usr/bin/env python3
"""Optionnel : fusionne les 3 packs de tuiles dans `town02/` en 0.5 seconde si vous souhaitez un seul dossier dans PMDO/MODS/."""
import os, struct, shutil

ROOT = os.path.dirname(os.path.abspath(__file__))
MAIN_TILE = os.path.join(ROOT, "town02", "Content", "Tile")
PACKS = ["town02", "town02_tiles_pack_a", "town02_tiles_pack_b", "town02_tiles_pack_c"]

total_count = 0
bodies = []
for p in PACKS:
    tdir = os.path.join(ROOT, p, "Content", "Tile")
    if not os.path.isdir(tdir):
        continue
    idx_p = os.path.join(tdir, "index.idx")
    if os.path.exists(idx_p):
        raw = open(idx_p, "rb").read()
        total_count += struct.unpack_from("<i", raw, 0)[0]
        bodies.append(raw[4:])
    if p != "town02":
        for fn in os.listdir(tdir):
            if fn.endswith(".tile"):
                shutil.move(os.path.join(tdir, fn), os.path.join(MAIN_TILE, fn))
        shutil.rmtree(os.path.join(ROOT, p), ignore_errors=True)

with open(os.path.join(MAIN_TILE, "index.idx"), "wb") as wf:
    wf.write(struct.pack("<i", total_count))
    for b in bodies:
        wf.write(b)

# Retirer les DependsOn devenus internes dans town02/Mod.xml
mxml = os.path.join(ROOT, "town02", "Mod.xml")
txt = open(mxml, encoding="utf-8").read()
import re
txt = re.sub(r"\s*<RelatedMod>\s*<UUID>A1CE000[123].*?</RelatedMod>", "", txt, flags=re.S)
open(mxml, "w", encoding="utf-8").write(txt)
print(f"FUSION TERMINÉE : 1 seul dossier `town02/` prêt avec {total_count} tilesets indexés !")
