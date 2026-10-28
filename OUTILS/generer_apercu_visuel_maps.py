#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Génère `apercu_maps_visuel.html` : TOUTES les maps rendues visuellement, listées à plat.

Source : apercus/zips/<pack>/maps/*.json + *_vignette.png (produits par OUTILS/restaurer_maps_zip.py).
Une carte apparaît une seule fois (premier pack trouvé). Les noms du catalogue sans rendu visuel
sont listés à part, avec la raison connue.

Usage : python3 OUTILS/generer_apercu_visuel_maps.py
"""
from __future__ import annotations

import html
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SORTIE = ROOT / "apercu_maps_visuel.html"
CATALOGUE = ROOT / "apercu_toutes_les_maps.html"


def cartes() -> dict[str, dict]:
    res: dict[str, dict] = {}
    for j in sorted((ROOT / "apercus" / "zips").glob("*/maps/*.json")):
        cfg = json.loads(j.read_text(encoding="utf-8"))["cfg"]
        asset = cfg["asset"]
        if asset in res:
            continue
        pack_dir = j.parent.parent
        vign = j.with_name(f"{asset}_vignette.png")
        res[asset] = {
            "asset": asset,
            "label": cfg.get("label") or asset,
            "wt": cfg["wt"], "ht": cfg["ht"],
            "page": f"apercus/zips/{pack_dir.name}/maps/{asset}.html",
            "vignette": f"apercus/zips/{pack_dir.name}/maps/{asset}_vignette.png" if vign.is_file() else "",
            "pack": pack_dir.name,
        }
    return res


def noms_catalogue() -> list[str]:
    if not CATALOGUE.is_file():
        return []
    s = CATALOGUE.read_text(encoding="utf-8")
    noms = re.findall(r"<strong>([^<]+)</strong>", s)
    hors = {"maps_branches", "packages_destiny", "intro_halo", "references_dumpasset",
            "references_halcyon", "references_metano", "destiny_cliff_tests"}
    res = set()
    for n in noms:
        n = html.unescape(n).strip()
        if not re.fullmatch(r"[\w .()-]+", n) or n.isdigit() or n in hors:
            continue
        if n.endswith("_pmdo") or n.startswith(("cote_metano", "cotes_")):  # noms de packs ZIP
            continue
        res.add(n)
    return sorted(res)


def main() -> None:
    maps = cartes()
    ordre = sorted(maps.values(), key=lambda m: m["asset"].lower())
    grille = []
    for m in ordre:
        img = (f'<img src="{html.escape(m["vignette"])}" loading="lazy" alt="">' if m["vignette"]
               else '<div class="vide">pas de vignette</div>')
        grille.append(f'<li><a href="{html.escape(m["page"])}" target="_blank">{img}'
                      f'<span>{html.escape(m["label"])}</span></a>'
                      f'<small>{m["wt"]}×{m["ht"]} · {html.escape(m["pack"])}</small></li>')
    rendus = set(maps)
    sans = [n for n in noms_catalogue() if n not in rendus and not n.isdigit()]
    sans_html = "".join(f"<li>{html.escape(n)}</li>" for n in sans)
    SORTIE.write_text(f"""<!doctype html><html lang="fr"><head><meta charset="utf-8">
<title>Toutes les maps — aperçu visuel</title>
<style>
body{{background:#1d1a14;color:#eee;font:14px system-ui,sans-serif;margin:20px}}
a{{color:#ffd76a;text-decoration:none}} small{{color:#aaa;display:block}}
ul.grille{{list-style:none;padding:0;display:flex;flex-wrap:wrap;gap:10px}}
ul.grille li{{width:170px;background:#2a251c;border-radius:6px;padding:6px;text-align:center}}
ul.grille img{{width:150px;height:auto;image-rendering:pixelated;background:#111;max-height:150px;object-fit:contain}}
ul.grille span{{display:block;margin-top:4px;word-break:break-all}}
.vide{{height:80px;line-height:80px;color:#777}}
.sans li{{color:#fb6;margin:2px 0}} .note{{background:#2b2619;border-left:4px solid #ffd76a;padding:8px 12px}}
</style></head><body>
<h1>Toutes les maps — aperçu visuel</h1>
<p class="note"><b>{len(maps)} maps rendues visuellement</b> (moteur natif 8 px, animations incluses),
listées à plat. Cliquez une vignette pour ouvrir la carte.</p>
<ul class="grille">{''.join(grille)}</ul>
<h2>Noms du catalogue sans rendu visuel ({len(sans)})</h2>
<p>Ces maps existent dans le catalogue, mais aucun fichier <code>.rsground</code> de ZIP ne les contient :
elles sont dans des fichiers autonomes des branches, non encore rendues.</p>
<ul class="sans">{sans_html}</ul>
</body></html>""", encoding="utf-8")
    print(f"écrit : {SORTIE.name} — {len(maps)} maps visuelles, {len(sans)} noms sans rendu")


if __name__ == "__main__":
    main()
