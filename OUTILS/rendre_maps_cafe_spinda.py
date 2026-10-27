#!/usr/bin/env python3
"""Rend les 4 maps Café Spinda avec leurs VRAIS tilesheets et régénère les apercus.

Sources des sheets (identifiées par empreinte tuile-à-tuile) :
- rooms 600×448 (grille identité) : apercus « Café Spinda · réseau au propre »
  (créations utilisateur — accueil / café à l'étage / salon des croisillons)
- QULBUTOQUESTAND 144×120, SPINDA kiosk 144×104, rido 208×168 :
  collection mobilier_cafe_complet_v1 (créations utilisateur)
- SpindaCafe2, Metano_Town_Cafe_Objects, Metano_Inn_Objects, spinda_cafe_dojo,
  interieur_sans_deco_jour (1), téléchargement (6) : tilesheets du dépôt town02
  (Content/Tile) + références locales — créditées.

Usage : python3 OUTILS/rendre_maps_cafe_spinda.py
"""
from pathlib import Path
import base64, io, json, struct, sys

from PIL import Image

R = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(R / 'OUTILS'))
from importer_tiles_town02 import parse_tile  # noqa: E402

DEST = R / 'quest_pmd_destiny'
EX = Path('/tmp/mobilier_ex')

# nom sheet -> source ('img', chemin) ou ('tile', chemin)
SHEETS = {
    'accueilspindacafé': ('img', '/tmp/apercu_extracts/cafe_spinda_reseau_propre_v1_00.png'),
    'spindacaféétage1': ('img', '/tmp/apercu_extracts/cafe_spinda_reseau_propre_v1_06.png'),
    'chantroom': ('img', '/tmp/apercu_extracts/cafe_spinda_reseau_propre_v1_08.png'),
    'QULBUTOQUESTAND': ('img', str(EX / 'm090_144x120.png')),
    'SPINDA kiosk': ('img', str(EX / 'm075_144x104.png')),
    'rido': ('img', str(EX / 'm028_208x168.png')),
    'SpindaCafe2': ('tile', '/tmp/town02_tiles/SpindaCafe2.tile'),
    'Metano_Town_Cafe_Objects': ('tile', '/tmp/town02_tiles/Metano_Town_Cafe_Objects.tile'),
    'Metano_Inn_Objects': ('tile', str(R / 'source/cafe_spinda_revisite_v7/references/Metano_Inn_Objects.tile')),
    'spinda_cafe_dojo': ('tile', '/tmp/town02_tiles/spinda_cafe_dojo.tile'),
    'interieur_sans_deco_jour (1)': ('tile', '/tmp/town02_tiles/interieur_sans_deco_jour (1).tile'),
    'téléchargement (6)': ('tile', '/tmp/town02_tiles/téléchargement (6).tile'),
}

MAPS = {
    'caféspindaaccueil': 'Accueil du Café Spinda (map utilisateur)',
    'spindacafetest': 'Café Spinda — test (map utilisateur)',
    'spindacaféétage1': 'Café Spinda — étage 1 (map utilisateur)',
    'spindacaféétage1salle2': 'Café Spinda — étage 1 salle 2 · cabaret (map utilisateur)',
}


def img_sheet(im: Image.Image) -> dict:
    im = im.convert('RGBA')
    out = {}
    for ty in range(im.height // 8):
        for tx in range(im.width // 8):
            out[(tx, ty)] = im.crop((tx * 8, ty * 8, tx * 8 + 8, ty * 8 + 8))
    return out


def tile_sheet(path: Path) -> dict:
    _, recs = parse_tile(path.read_bytes())
    return {(x, y): Image.open(io.BytesIO(png)).convert('RGBA') for x, y, png in recs}


def encode_tile_pngs(tiles: dict) -> bytes:
    """Écrit un .tile PMDO (tile_size=8) à partir d'une grille de tuiles 8px."""
    keys = sorted(tiles)
    table = bytearray()
    body = bytearray()
    off = 8 + 16 * len(keys)
    for x, y in keys:
        buf = io.BytesIO()
        tiles[(x, y)].save(buf, 'PNG')
        png = buf.getvalue()
        table += struct.pack('<iiQ', x, y, off)
        body += struct.pack('<Q', len(png)) + png
        off += 8 + len(png)
    return struct.pack('<ii', 8, len(keys)) + bytes(table) + bytes(body)


def render(map_path: Path, store: dict) -> Image.Image:
    o = json.load(open(map_path, encoding='utf-8-sig'))['Object']
    tiles0 = o['Layers'][0]['Tiles']
    W, H = len(tiles0), len(tiles0[0])
    canvas = Image.new('RGBA', (W * 8, H * 8), (24, 26, 32, 255))
    for L in o['Layers']:
        for xi, col in enumerate(L['Tiles']):
            for yi, cell in enumerate(col):
                for blk in cell.get('Layers', []):
                    for fr in blk.get('Frames', []):
                        t = store.get(fr['Sheet'], {}).get((fr['TexLoc']['X'], fr['TexLoc']['Y']))
                        if t is not None:
                            canvas.alpha_composite(t, (xi * 8, yi * 8))
    return canvas


PAGE = """<!doctype html><html lang="fr"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>@@TITRE@@</title><style>
body{margin:0;background:#14161c;color:#e8e8f2;font:15px/1.5 system-ui,sans-serif}
header{padding:18px 24px 8px;max-width:1100px;margin:0 auto}
header h1{margin:0 0 4px;font-size:22px}
.note{opacity:.75;font-size:13px}
.stage{display:flex;justify-content:center;padding:8px 16px 28px}
.frame{max-width:100%;overflow:auto;border:1px solid #333;border-radius:10px;background:#3a3028}
.frame img{display:block;image-rendering:pixelated;width:min(1400px,170vw);max-width:none}
nav{padding:0 24px 24px;max-width:1100px;margin:0 auto}nav a{color:#8fd3ff}
</style></head><body>
<header><h1>@@TITRE@@</h1>
<p class="note">Rendu fidèle : room utilisateur 600×448 + sprites posés (kiosques Spinda/Qulbutoké,
scène cabaret, mobilier). Tilesheets : créations utilisateur (mobilier/kiosques) + dépôt
<b>town02</b> (Metano_Town_Cafe_Objects, SpindaCafe2, spinda_cafe_dojo, Metano_Inn_Objects…).
<b>runtime_tested : false</b> · tuiles animées rendues image fixe (frame 1).</p>
</header>
<div class="stage"><div class="frame"><img src="@@IMG@@" alt="@@TITRE@@"></div></div>
<nav><a href="../../apercu_maps_cafe_spinda.html">← Série Café Spinda (4 maps)</a> ·
<a href="../../index.html">← Toutes les maps du pack</a></nav>
</body></html>"""


def main():
    store = {}
    for name, (kind, path) in SHEETS.items():
        store[name] = img_sheet(Image.open(path)) if kind == 'img' else tile_sheet(Path(path))
        print(f'sheet {name}: {len(store[name])} tuiles')

    (R / 'apercus' / 'maps').mkdir(parents=True, exist_ok=True)
    (DEST / 'Content' / 'Tile').mkdir(parents=True, exist_ok=True)

    for mid, titre in MAPS.items():
        img = render(R / f'{mid}.rsground', store)
        img2 = img.resize((img.width * 2, img.height * 2), Image.Resampling.NEAREST)
        buf = io.BytesIO()
        img2.save(buf, 'PNG')
        b64 = base64.b64encode(buf.getvalue()).decode()
        (R / 'apercus' / 'maps' / f'{mid}.html').write_text(
            PAGE.replace('@@TITRE@@', titre).replace('@@IMG@@', f'data:image/png;base64,{b64}'),
            encoding='utf-8')
        print(f'rendu {mid}: {img.width}x{img.height} px natifs')

    # tilesheets dans la quest (noms EXACTS référencés par les maps)
    for name, tiles in store.items():
        (DEST / 'Content' / 'Tile' / f'{name}.tile').write_bytes(encode_tile_pngs(tiles))
    print(f'{len(store)} tilesheets écrits dans quest_pmd_destiny/Content/Tile')

    # index des tuiles
    from importer_tiles_town02 import encode_index, read_string, read_node
    tidx = DEST / 'Content' / 'Tile' / 'index.idx'
    raw = tidx.read_bytes()
    f = io.BytesIO(raw)
    (n,) = struct.unpack('<i', f.read(4))
    nodes = {}
    for _ in range(n):
        nodes[read_string(f)] = read_node(f)
    for name in store:
        p = DEST / 'Content' / 'Tile' / f'{name}.tile'
        b = p.read_bytes()
        count = struct.unpack('<i', b[4:8])[0]
        nodes[f'{name}.tile'] = b[:8 + count * 16]
    tidx.write_bytes(encode_index(nodes))
    print(f'index tuiles: {len(nodes)} tuileries')

    # page de synthèse mise à jour
    cards = ''.join(
        f'<li style="margin:6px 0"><a href="apercus/maps/{m}.html" style="color:#8fd3ff">{t}</a></li>'
        for m, t in MAPS.items())
    (R / 'apercu_maps_cafe_spinda.html').write_text(f"""<!doctype html><html lang="fr"><head><meta charset="utf-8">
<title>Maps Café Spinda — créations utilisateur</title></head><body style="font:15px system-ui;background:#14161c;color:#eee;padding:24px">
<h1>Maps Café Spinda — créations utilisateur (4 cartes)</h1>
<p>Maps poussées par l'utilisateur (« inclus ces map a notre quetes »), intégrées à la
quest PMDO Destiny — zone <b>maps_cafe_spinda</b>. <b>Rendu complet</b> : rooms +
kiosques + mobilier + scène (tilesheets retrouvés dans le dépôt town02 et tes
collections mobilier/kiosques).</p>
<ul>{cards}</ul>
<p><a href="index.html" style="color:#8fd3ff">← Toutes les maps du pack</a></p></body></html>""",
        encoding='utf-8')

    # doc de provenance
    (R / 'bibliotheque_ground' / 'lots' / 'maps_cafe_spinda' / 'TILE_SHEETS.md').write_text(
        """# Tilesheets des maps Café Spinda

| Sheet | Source | Identifiée par |
|---|---|---|
| `accueilspindacafé` | room « Accueil de Spinda » (apercus réseau au propre) | grille identité 75×56 |
| `spindacaféétage1` | room « Café à l'étage » | grille identité 75×56 |
| `chantroom` | room « Salon des croisillons » (cabaret) | grille identité 75×56 |
| `QULBUTOQUESTAND` | kiosque Qulbutoké (collection mobilier_cafe_complet_v1, jour) | empreinte 216/216 |
| `SPINDA kiosk` | kiosque Spinda (collection mobilier_cafe_complet_v1, jour) | empreinte 194/194 |
| `rido` | scène cabaret/rideaux (collection mobilier_cafe_complet_v1, jour) | empreinte 472/472 |
| `SpindaCafe2`, `Metano_Town_Cafe_Objects`, `Metano_Inn_Objects`, `spinda_cafe_dojo` | dépôt **town02** `Content/Tile` | nom + empreinte |
| `interieur_sans_deco_jour (1)`, `téléchargement (6)` | dépôt **town02** `Content/Tile` | nom + empreinte 1600/1585 |

Crédit : mobilier/kiosques = créations utilisateur ; tuiles Metano/Spinda/dojo = dépôt town02
(d'après Halcyon/Palikadude pour les objets Metano — usage interne projet). `runtime_tested : false`.
""", encoding='utf-8')
    print('TILE_SHEETS.md écrit')


if __name__ == '__main__':
    main()
