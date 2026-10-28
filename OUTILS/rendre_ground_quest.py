#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Rend visuellement TOUTES les maps Ground présentes dans quest_pmd_destiny/Data/Ground/.

Utilise le moteur fidèle de OUTILS/restaurer_maps_zip.py (tuiles 8 px natives, animations,
fonds .dir animés) mais lit directement les fichiers de la quest (Content/Tile, Content/BG,
Data/Ground) au lieu d'une archive ZIP. Aucun fichier de la quest n'est modifié.

Sortie : apercus/quest/{maps,tilesets,bg,index.html} + stub racine apercu_maps_quest_ground.html.
Usage : /home/user/venv_apercu/bin/python OUTILS/rendre_ground_quest.py
"""
from __future__ import annotations

import argparse
import html
import json
import sys
import traceback
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import restaurer_maps_zip as rz  # noqa: E402

ROOT = rz.ROOT
QUEST = ROOT / "quest_pmd_destiny"
OUT = ROOT / "apercus" / "quest"
GROUND = QUEST / "Data" / "Ground"


def lien_casse(rg: Path) -> bool:
    """Fichiers de quelques octets contenant seulement un chemin relatif : liens Git non résolus."""
    return rg.stat().st_size < 300 and rg.read_bytes().startswith(b"../")


def main() -> int:
    argp = argparse.ArgumentParser()
    argp.add_argument("--fichiers", nargs="*", help="noms (sans extension) à traiter ; défaut : tous")
    argp.add_argument("--max-mo", type=float, default=0, help="ignorer les fichiers plus gros (Mo)")
    argp.add_argument("--forcer", action="store_true", help="refaire même si déjà rendu")
    a = argp.parse_args()
    maps_dir, tilesets_dir, bg_dir = OUT / "maps", OUT / "tilesets", OUT / "bg"
    for d in (maps_dir, tilesets_dir, bg_dir):
        d.mkdir(parents=True, exist_ok=True)
    tile_cache: dict[str, dict] = {}
    bg_cache: dict[str, tuple] = {}
    warnings_globaux: list[str] = []

    def get_tileset(name: str):
        if name not in tile_cache:
            tiles = rz.read_tile(QUEST / "Content" / "Tile" / f"{name}.tile")
            rz.tile_atlas(tiles).save(tilesets_dir / f"{name}.png")
            tile_cache[name] = tiles
        return tile_cache[name]

    def get_bg(name: str):
        if name not in bg_cache:
            im, w, h, dirs, frames = rz.read_dir(QUEST / "Content" / "BG" / f"{name}.dir")
            im.save(bg_dir / f"{name}.png")
            bg_cache[name] = (im, w, h, frames)
        return bg_cache[name]

    index_rows = []
    echecs = []
    liens_casses = []
    for rg in sorted(GROUND.glob("*.rsground")):
        if a.fichiers and rg.stem not in a.fichiers:
            continue
        if lien_casse(rg):
            liens_casses.append(rg.name)
            continue
        if a.max_mo and rg.stat().st_size > a.max_mo * 1e6:
            continue
        if not a.forcer and (maps_dir / f"{rg.stem}.html").exists():
            continue
        try:
            doc = json.loads(rg.read_text(encoding="utf-8-sig"))
            obj = doc["Object"]
            asset = obj.get("AssetName") or rg.stem
            warn: list[str] = []
            sheets: list[str] = []
            try:
                bg_entries = rz.load_backgrounds(QUEST, obj, warn)
            except ValueError as exc:  # fond .dir incohérent : carte rendue sans fond animé, signalé
                bg_entries = []
                warn.append(f"fond animé non rendu : {exc}")
            data = rz.build_map(doc, sheets, bg_entries, warn)
            for name in sheets:
                get_tileset(name)
            for b in list(bg_entries):
                try:
                    get_bg(b["img"])
                except ValueError as exc:  # fond .dir incohérent : non dessiné, signalé
                    bg_entries.remove(b)
                    warn.append(f"fond « {b['img']} » non rendu : {exc}")
            data["asset"] = asset
            data["label"] = data["label"] or asset
            data["source"] = f"quest_pmd_destiny/Data/Ground/{rg.name}"
            js_cfg = {k: data[k] for k in ("label", "asset", "tile_px", "wt", "ht",
                                           "layers", "markers", "collisions")}
            sheets_src = [f"../tilesets/{s}.png" for s in sheets]
            rows = "".join(
                f'<tr><td>{i}</td><td>{html.escape(L["name"])}</td><td>{L["top"]}</td>'
                f'<td>{L["anim_cells"]}</td></tr>' for i, L in enumerate(data["layers"]))
            sub = (f'Carte Ground native <code>{html.escape(data["source"])}</code> — '
                   f'{data["wt"]}×{data["ht"]} cases de 8 px ({data["wt"]*8}×{data["ht"]*8} px). '
                   'Animations de tuiles en ticks 1/60 s (FrameLength), fonds animés à la cadence du fichier.')
            page = rz.map_page(data["label"], sub, f"quest_pmd_destiny/Data/Ground/{rg.name}",
                               rows, warn, js_cfg, sheets_src, bg_entries)
            (maps_dir / f"{asset}.html").write_text(page, encoding="utf-8")
            (maps_dir / f"{asset}.json").write_text(
                json.dumps({"cfg": js_cfg, "sheets": sheets_src, "bg": bg_entries},
                           separators=(",", ":")), encoding="utf-8")
            try:
                sheet_imgs = [rz.tile_atlas(get_tileset(n)) for n in sheets]
                bg_imgs = {b["img"]: get_bg(b["img"])[0] for b in bg_entries}
                frame = rz.render_frame0(data, sheet_imgs, bg_imgs)
                frame.thumbnail((420, 420))
                frame.save(maps_dir / f"{asset}_vignette.png")
            except Exception as exc:  # noqa: BLE001
                warn.append(f"vignette non générée ({exc})")
            index_rows.append({"asset": asset, "label": data["label"], "wt": data["wt"],
                               "ht": data["ht"], "avert": warn})
            print(f"ok {asset} {data['wt']}x{data['ht']}" + (f" ⚠ {warn}" if warn else ""))
        except Exception as exc:  # noqa: BLE001
            traceback.print_exc()
            echecs.append({"fichier": rg.name, "erreur": str(exc)})
            print(f"ECHEC {rg.name}: {exc}")
    print(f"liens Git non résolus (cible absente) : {liens_casses}")

    # index complet : reconstruit à partir de toutes les cartes présentes (reprises incluses)
    index_rows = []
    for j in sorted(maps_dir.glob("*.json")):
        cfg = json.loads(j.read_text(encoding="utf-8"))["cfg"]
        index_rows.append({"asset": cfg["asset"], "label": cfg["label"], "wt": cfg["wt"], "ht": cfg["ht"]})

    cartes = "".join(
        f'<li><a href="maps/{html.escape(r["asset"])}.html"><img src="maps/{html.escape(r["asset"])}_vignette.png" '
        f'width="140" loading="lazy" alt=""><br>{html.escape(r["label"])}</a> '
        f'<small>{r["wt"]}×{r["ht"]}</small></li>' for r in index_rows)
    (OUT / "index.html").write_text(
        '<!doctype html><html lang="fr"><head><meta charset="utf-8"><title>Maps Ground de la quest</title>'
        '<style>body{background:#1d1a14;color:#eee;font:14px system-ui;margin:20px}'
        'ul{list-style:none;padding:0;display:flex;flex-wrap:wrap;gap:10px}'
        'li{width:160px;background:#2a251c;padding:6px;border-radius:6px;text-align:center}'
        'a{color:#ffd76a}</style></head><body>'
        f'<h1>Maps Ground de la quest ({len(index_rows)} rendues)</h1>'
        f'<p>Rendu natif de chaque fichier <code>quest_pmd_destiny/Data/Ground/*.rsground</code>. '
        f'Échecs : {len(echecs)}.</p><ul>{cartes}</ul></body></html>', encoding="utf-8")
    (ROOT / "apercu_maps_quest_ground.html").write_text(
        '<!doctype html><html lang="fr"><head><meta charset="utf-8"><title>Maps Ground de la quest</title>'
        '<meta http-equiv="refresh" content="0;url=apercus/quest/index.html"></head><body>'
        '<a href="apercus/quest/index.html">Maps Ground de la quest</a></body></html>', encoding="utf-8")
    (OUT / "rapport.json").write_text(json.dumps(
        {"rendues_total": len(index_rows), "echecs_derniere_execution": echecs,
         "liens_casses_derniere_execution": liens_casses},
        ensure_ascii=False, indent=1), encoding="utf-8")
    print(f"TOTAL rendues={len(index_rows)} échecs={len(echecs)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
