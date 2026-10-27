#!/usr/bin/env python3
"""Rend des aperçus ANIMÉS pour les maps générées de la quest PMDO Destiny
(faille spatiale/Palkia, Sinister Woods, monts, donjons, écran-titre…).

Réutilise le moteur fidèle de OUTILS/restaurer_maps_zip.py (tuiles 8 px natives,
animations FrameLength 1/60 s, fonds .dir animés) sur les maps de
bibliotheque_ground/lots/ — hors packs ZIP (déjà couverts par restaurer_maps_zip)
et hors lots café (aperçus dédiés).

Sortie : apercus/destiny/{maps,tilesets,bg}/ + index + stub racine
apercu_maps_destiny_generes.html (listé par la visionneuse).

Usage : .venv/bin/python OUTILS/rendre_apercus_destiny.py [--lots lot1,lot2]
"""
from __future__ import annotations

import argparse
import html
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import restaurer_maps_zip as rz  # noqa: E402

ROOT = HERE.parent
QUEST = ROOT / 'quest_pmd_destiny'
LOTS = ROOT / 'bibliotheque_ground' / 'lots'
OUT = ROOT / 'apercus' / 'destiny'

SKIP_LOTS = {
    'cote_metano_dix_zones_lot2_pmdo', 'cote_metano_dix_zones_pmdo',
    'cote_metano_v2_pmdo', 'cotes_metano_abyss_0812_pmdo', 'cotes_v2_0812_pmdo',
    'mod_metano_expeditions_pmdo_0812',          # packs ZIP — aperçus déjà rendus
    'maps_cafes', 'maps_cafe_spinda', 'reseau_metano_normal_v1',  # aperçus dédiés
}

HI = {'faille_spatiale_entree': 'Faille Spatiale · domaine de Palkia — entrée',
      'faille_spatiale_sanctuaire': 'Faille Spatiale · sanctuaire de Palkia',
      'faille_spatiale_sanctuaire_avant_portail': 'Faille Spatiale · avant le portail',
      'sinister_woods_entree': 'Sinister Woods — entrée',
      'sinister_woods_entree_nuit': 'Sinister Woods — entrée (nuit)',
      'sinister_woods_fin': 'Sinister Woods — fin',
      'sinister_woods_fin_nuit': 'Sinister Woods — fin (nuit)',
      'pmd_destiny_menu_jour': 'Écran-titre PMD Destiny (jour)',
      'pmd_destiny_menu_nuit': 'Écran-titre PMD Destiny (nuit)',
      'waterfall_cave_1': 'Waterfall Cave 1 (town02)'}


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument('--lots', default='')
    args = ap.parse_args()
    only = {x for x in args.lots.split(',') if x}

    (OUT / 'maps').mkdir(parents=True, exist_ok=True)
    (OUT / 'tilesets').mkdir(exist_ok=True)
    (OUT / 'bg').mkdir(exist_ok=True)
    tile_cache: dict = {}
    bg_cache: dict = {}

    def get_tileset(name: str, lotdir: Path):
        if name not in tile_cache:
            for src in (QUEST / 'Content' / 'Tile' / f'{name}.tile',
                        lotdir / 'Content' / 'Tile' / f'{name}.tile'):
                if src.exists():
                    tiles = rz.read_tile(src)
                    rz.tile_atlas(tiles).save(OUT / 'tilesets' / f'{name}.png')
                    tile_cache[name] = tiles
                    return tiles
            raise FileNotFoundError(f'tilesheet « {name} »')
        return tile_cache[name]

    def get_bg(name: str):
        if name not in bg_cache:
            src = QUEST / 'Content' / 'BG' / f'{name}.dir'
            im, w, h, dirs, frames = rz.read_dir(src)
            im.save(OUT / 'bg' / f'{name}.png')
            bg_cache[name] = (im, w, h, frames)
        return bg_cache[name]

    entries = []
    for lotdir in sorted(LOTS.iterdir()):
        lot = lotdir.name
        if lot in SKIP_LOTS or (only and lot not in only):
            continue
        for rp in sorted((lotdir / 'Data' / 'Ground').glob('*.rsground')):
            try:
                doc = json.loads(rp.read_text(encoding='utf-8-sig'))
            except Exception as exc:
                print(f'!! {rp.name} illisible ({exc})')
                continue
            obj = doc['Object']
            asset = obj.get('AssetName') or rp.stem
            warn: list = []
            sheets: list = []
            bg_entries = rz.load_backgrounds(QUEST, obj, warn)
            data = rz.build_map(doc, sheets, bg_entries, warn)
            for name in sheets:
                try:
                    get_tileset(name, lotdir)
                except FileNotFoundError as exc:
                    warn.append(str(exc))
            for b in bg_entries:
                get_bg(b['img'])
            data['asset'] = asset
            data['label'] = data['label'] or asset
            data['source'] = f'lots/{lot}/Data/Ground/{rp.name}'
            data['lot'] = lot

            js_cfg = {k: data[k] for k in ('label', 'asset', 'tile_px', 'wt', 'ht',
                                           'layers', 'markers', 'collisions')}
            sheets_src = [f'../tilesets/{s}.png' for s in sheets
                          if (OUT / 'tilesets' / f'{s}.png').exists()]
            rows = ''.join(
                f'<tr><td>{i}</td><td>{html.escape(L["name"])}</td><td>{L["top"]}</td>'
                f'<td>{L["anim_cells"]}</td></tr>' for i, L in enumerate(data['layers']))
            sub = (f'Carte Ground native <code>{html.escape(data["source"])}</code> — '
                   f'{data["wt"]}×{data["ht"]} cases de 8 px. Animations de tuiles '
                   '(FrameLength, ticks 1/60 s) et fonds animés conservés.')
            page = rz.map_page(data['label'], sub, f'lots/{lot}', rows, warn,
                               js_cfg, sheets_src, bg_entries)
            (OUT / 'maps' / f'{asset}.html').write_text(page, encoding='utf-8')
            (OUT / 'maps' / f'{asset}.json').write_text(
                json.dumps({'cfg': js_cfg, 'sheets': sheets_src, 'bg': bg_entries},
                           separators=(',', ':')), encoding='utf-8')
            sheet_imgs = [rz.tile_atlas(get_tileset(n, lotdir)) for n in sheets
                          if (OUT / 'tilesets' / f'{n}.png').exists()]
            bg_imgs = {b['img']: get_bg(b['img'])[0] for b in bg_entries}
            try:
                frame = rz.render_frame0(data, sheet_imgs, bg_imgs)
                frame.thumbnail((420, 420))
                frame.save(OUT / 'maps' / f'{asset}_vignette.png')
            except Exception as exc:
                warn.append(f'vignette non générée ({exc})')
            n_anim = sum(L['anim_cells'] for L in data['layers'])
            entries.append({'asset': asset, 'label': data['label'], 'lot': lot,
                            'wt': data['wt'], 'ht': data['ht'], 'anim': n_anim,
                            'warn': warn, 'hi': HI.get(asset, '')})
            print(f'   {lot}/{asset} — {data["wt"]}×{data["ht"]}, {n_anim} cases animées')

    # ---- index (galerie) + stub racine
    def card(e):
        tag = f'<p style="color:#ffd76a;margin:4px 0 0;font-size:12px">{html.escape(e["hi"])}</p>' if e['hi'] else ''
        w = ('⚠️ ' + html.escape('; '.join(e['warn'])[:120])) if e['warn'] else ''
        return (f'<div class="card"><a href="maps/{html.escape(e["asset"])}.html">'
                f'<img src="maps/{html.escape(e["asset"])}_vignette.png" '
                f'alt="{html.escape(e["label"])}" loading="lazy"></a>'
                f'<div><b>{html.escape(e["label"])}</b></div>'
                f'<small>{e["wt"]}×{e["ht"]} · {e["anim"]} cases animées · {html.escape(e["lot"])}</small>'
                f'{tag}{w}</div>')

    his = [e for e in entries if e['hi']]
    rest = [e for e in entries if not e['hi']]
    idx = f"""<!doctype html><html lang="fr"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Maps générées Destiny — aperçus animés</title><style>
body{{background:#1d1a14;color:#eee;font:15px/1.5 system-ui,sans-serif;max-width:1200px;margin:18px auto;padding:0 12px}}
a{{color:#ffd76a}} .grid{{display:grid;grid-template-columns:repeat(auto-fill,minmax(230px,1fr));gap:12px}}
.card{{background:#262117;border:1px solid #3a3427;border-radius:8px;padding:8px}}
.card img{{width:100%;image-rendering:pixelated;border:1px solid #000;background:#000}}
h2{{margin-top:26px}} small{{color:#999}}</style></head><body>
<p><a href="../../index.html">← Tous les aperçus</a></p>
<h1>Maps générées Destiny — {len(entries)} cartes rendues depuis les fichiers moteur</h1>
<p>Tuiles natives 8 px, <b>animations conservées</b> (FrameLength ticks 1/60 s), fonds
animés .dir à la cadence du fichier. Sources : <code>bibliotheque_ground/lots/</code>
(builds régénérés, crédités dans <code>CREDITS.md</code>).</p>
<h2>À la une — Faille Spatiale (Palkia) · Sinister Woods · Écran-titre</h2>
<div class="grid">{''.join(card(e) for e in his)}</div>
<h2>Toutes les autres maps</h2>
<div class="grid">{''.join(card(e) for e in rest)}</div>
</body></html>"""
    (OUT / 'index.html').write_text(idx, encoding='utf-8')

    stub = f"""<!doctype html><html lang="fr"><head><meta charset="utf-8">
<title>Maps générées Destiny (Palkia, Sinister Woods…)</title></head>
<body style="font:15px system-ui;background:#1d1a14;color:#eee;padding:24px">
<h1>Maps générées Destiny — {len(entries)} cartes animées</h1>
<p>Faille Spatiale (Palkia), Sinister Woods, monts, donjons, écran-titre PMD Destiny…</p>
<p><a href="apercus/destiny/index.html" style="color:#ffd76a">→ Ouvrir la galerie des aperçus animés</a></p>
<p><a href="index.html" style="color:#ffd76a">← Toutes les maps du pack</a></p></body></html>"""
    (ROOT / 'apercu_maps_destiny_generes.html').write_text(stub, encoding='utf-8')
    print(f'TOTAL : {len(entries)} maps rendues — galerie apercus/destiny/index.html')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
