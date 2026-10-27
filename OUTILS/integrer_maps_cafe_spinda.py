#!/usr/bin/env python3
"""Intègre les 4 maps café Spinda de l'utilisateur (poussées dans 3b81aeb)
dans quest_pmd_destiny et génère leurs apercus pour la visionneuse.

Les tilesheets manquants (exports de l'éditeur de l'utilisateur) sont rendus
en blocs gris marqués, avec la liste exacte des fichiers à fournir.

Usage : python3 OUTILS/integrer_maps_cafe_spinda.py
"""
from pathlib import Path
import base64, io, json, struct, sys

from PIL import Image, ImageDraw

R = Path(__file__).resolve().parents[1]
DEST = R / 'quest_pmd_destiny'
MAPS = {
    'caféspindaaccueil': 'Accueil Café Spinda (map utilisateur)',
    'spindacafetest': 'Café Spinda — test (map utilisateur)',
    'spindacaféétage1': 'Café Spinda — étage 1 (map utilisateur)',
    'spindacaféétage1salle2': 'Café Spinda — étage 1 salle 2 (map utilisateur)',
}
SHEET_SRC = {  # sheet -> chemin local (None = manquant)
    'SpindaCafe2': R / 'source/cafe_multietage_v1/references/SpindaCafe2.png',
    'Metano_Town_Cafe_Objects': R / 'source/cafe_multietage_v1/references/Metano_Town_Cafe_Objects.tile',
    'Metano_Inn_Objects': R / 'source/cafe_spinda_revisite_v7/references/Metano_Inn_Objects.tile',
}
TILE = 32  # cellule de grille = 32 px (éditeur PMDO)


def png_of_tilefile(path: Path) -> Image.Image:
    raw = path.read_bytes()
    tile_size, count = struct.unpack('<ii', raw[:8])
    off0 = 8 + count * 16
    ln = struct.unpack('<Q', raw[off0:off0 + 8])[0]
    return Image.open(io.BytesIO(raw[off0 + 8:off0 + 8 + ln])).convert('RGBA')


def load_sheets():
    out, missing = {}, set()
    for name, p in SHEET_SRC.items():
        if p is None or not p.exists():
            missing.add(name)
            continue
        out[name] = (png_of_tilefile(p) if p.suffix == '.tile' else Image.open(p).convert('RGBA'))
    return out, missing


def render(path: Path, sheets: dict, missing: set):
    o = json.load(open(path, encoding='utf-8-sig'))['Object']
    tiles = o['Layers'][0]['Tiles']
    W, H = len(tiles[0]), len(tiles)
    canvas = Image.new('RGBA', (W * TILE, H * TILE), (24, 26, 32, 255))
    used_missing = set()
    for y in range(H):
        for x in range(W):
            for L in o['Layers']:
                cell = L['Tiles'][y][x]
                for blk in cell.get('Layers', []):
                    for fr in blk.get('Frames', []):
                        sh = fr['Sheet']
                        loc = fr['TexLoc']
                        px, py = loc['X'] * TILE, loc['Y'] * TILE
                        if sh in sheets:
                            sheet = sheets[sh]
                            if px + TILE <= sheet.width and py + TILE <= sheet.height:
                                canvas.alpha_composite(sheet.crop((px, py, px + TILE, py + TILE)), (x * TILE, y * TILE))
                        else:
                            used_missing.add(sh)
                            d = ImageDraw.Draw(canvas)
                            d.rectangle([x * TILE, y * TILE, x * TILE + TILE - 1, y * TILE + TILE - 1],
                                        fill=(70, 74, 86, 255), outline=(110, 115, 130, 255))
    return canvas, used_missing, (W, H)


PAGE = """<!doctype html><html lang="fr"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>@@TITRE@@</title><style>
body{margin:0;background:#14161c;color:#e8e8f2;font:15px/1.5 system-ui,sans-serif}
header{padding:18px 24px 8px;max-width:1100px;margin:0 auto}
header h1{margin:0 0 4px;font-size:22px}
.warn{background:#4a2b2b;border:1px solid #a05050;border-radius:8px;padding:10px 14px;margin:8px 0;font-size:13px}
.note{opacity:.75;font-size:13px}
.stage{display:flex;justify-content:center;padding:8px 16px 28px}
.frame{max-width:100%;overflow:auto;border:1px solid #333;border-radius:10px;background:
repeating-conic-gradient(#23252d 0 25%,#2b2e38 0 50%) 0 0/24px 24px}
.frame img{display:block;image-rendering:pixelated;width:min(1600px,180vw);max-width:none}
nav{padding:0 24px 24px;max-width:1100px;margin:0 auto}nav a{color:#8fd3ff}
</style></head><body>
<header><h1>@@TITRE@@</h1>
<div class="warn"><b>Aperçu partiel :</b> tilesheets manquants rendus en blocs gris —
@@MANQUANTS@@. Poussez ces images (mêmes noms) pour la fidélité totale.</div>
<p class="note">Map créée par l'utilisateur (poussée dans « inclus ces map a notre quetes ») ·
<b>runtime_tested : false</b> · tuiles animées (FrameLength 60) rendues image fixe.</p>
</header>
<div class="stage"><div class="frame"><img src="@@IMG@@" alt="@@TITRE@@"></div></div>
<nav><a href="../../apercu_maps_cafe_spinda.html">← Série Café Spinda (4 maps)</a> ·
<a href="../../index.html">← Toutes les maps du pack</a></nav>
</body></html>"""


def main():
    (DEST / 'Data' / 'Ground').mkdir(parents=True, exist_ok=True)
    (R / 'apercus' / 'maps').mkdir(parents=True, exist_ok=True)
    sheets, known_missing = load_sheets()
    all_missing = set()

    for mid, titre in MAPS.items():
        src = R / f'{mid}.rsground'
        (DEST / 'Data' / 'Ground' / f'{mid}.rsground').write_bytes(src.read_bytes())
        img, used_missing, (W, H) = render(src, sheets, known_missing | set())
        all_missing |= used_missing
        buf = io.BytesIO()
        img.save(buf, 'PNG')
        b64 = base64.b64encode(buf.getvalue()).decode()
        page = (PAGE.replace('@@TITRE@@', titre)
                    .replace('@@MANQUANTS@@', ', '.join(f'<code>{m}</code>' for m in sorted(used_missing)) or 'aucun')
                    .replace('@@IMG@@', f'data:image/png;base64,{b64}'))
        (R / 'apercus' / 'maps' / f'{mid}.html').write_text(page, encoding='utf-8')
        print(f'OK {mid}: {W}x{H} cases, sheets manquants: {sorted(used_missing)}')

    cards = ''.join(f'<li style="margin:6px 0"><a href="apercus/maps/{m}.html" style="color:#8fd3ff">{t}</a></li>'
                    for m, t in MAPS.items())
    (R / 'apercu_maps_cafe_spinda.html').write_text(f"""<!doctype html><html lang="fr"><head><meta charset="utf-8">
<title>Maps Café Spinda — créations utilisateur</title></head><body style="font:15px system-ui;background:#14161c;color:#eee;padding:24px">
<h1>Maps Café Spinda — créations utilisateur (4 cartes)</h1>
<p>Maps poussées par l'utilisateur (« inclus ces map a notre quetes »), intégrées à la
quest PMDO Destiny — zone <b>maps_cafe_spinda</b>.</p>
<ul>{cards}</ul>
<p><a href="index.html" style="color:#8fd3ff">← Toutes les maps du pack</a></p></body></html>""",
        encoding='utf-8')

    # zone PMDO
    zdir = DEST / 'Data' / 'Zone'
    zone = {
        'ZoneID': 'maps_cafe_spinda',
        'Title': {'en': 'Spinda Cafe Maps', 'fr': 'Maps Café Spinda'},
        'Subtitle': {'en': "User's spinda cafe maps", 'fr': 'Maps Café Spinda (utilisateur)'},
        'ExtraMaps': [], 'DungeonMaps': [], 'GroundMaps': list(MAPS),
        'Asset': {'Assets': [], 'Params': {}}, 'GroundSkills': [],
        'PickDungeonForTeam': 'false', 'StartMap': 'caféspindaaccueil', 'StartDir': 'Down',
    }
    (zdir / 'maps_cafe_spinda.json').write_text(json.dumps(zone, ensure_ascii=False, indent=2), encoding='utf-8')
    data = json.loads((zdir / 'index.idx').read_text(encoding='utf-8-sig'))
    obj = data['Object']
    obj['maps_cafe_spinda'] = {
        '$type': 'RogueEssence.Data.ZoneEntrySummary, RogueEssence',
        'ExpPercent': 100, 'Level': -1, 'LevelCap': False, 'KeepSkills': False,
        'TeamRestrict': False, 'TeamSize': -1, 'MoneyRestrict': False, 'BagRestrict': -1,
        'KeepTreasure': False, 'BagSize': -1, 'Rescues': 0, 'CountedFloors': 0, 'Rogue': 0,
        'Grounds': list(MAPS), 'Maps': [],
        'Name': {'DefaultText': 'Maps Café Spinda', 'LocalTexts': {'fr': 'Maps Café Spinda'}},
        'Released': True,
        'Comment': "4 maps Café Spinda créées et poussées par l'utilisateur (3b81aeb).",
    }
    (zdir / 'index.idx').write_text(json.dumps(data, ensure_ascii=False, indent=1), encoding='utf-8-sig')
    print(f'zone maps_cafe_spinda créée ({len(obj) - 1} zones)')

    lot_dir = R / 'bibliotheque_ground' / 'lots' / 'maps_cafe_spinda'
    lot_dir.mkdir(parents=True, exist_ok=True)
    (lot_dir / 'lot.json').write_text(json.dumps({
        'lot': 'maps_cafe_spinda',
        'dossier': 'lots/maps_cafe_spinda',
        'titre': 'Maps Café Spinda (4 cartes utilisateur)',
        'description': 'caféspindaaccueil, spindacafetest, spindacaféétage1, spindacaféétage1salle2 — '
                       'créations de l\'utilisateur (commit 3b81aeb). Tilesheets de l\'éditeur partiellement '
                       'manquants (voir liste dans les apercus). runtime_tested: false.',
        'type': 'cartes',
        'map_ids': list(MAPS),
        'tilesheets_manquants': sorted(all_missing),
        'source': 'commit 3b81aeb (racine du dépôt)',
        'taille_go': 0.005,
        'statut': 'intégré (fidélité partielle en attente des tilesheets)',
        'art_approved': False,
    }, ensure_ascii=False, indent=2), encoding='utf-8')
    print('lot enregistré | tilesheets manquants au total:', sorted(all_missing))


if __name__ == '__main__':
    main()
