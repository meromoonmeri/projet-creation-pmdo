#!/usr/bin/env python3
"""Intègre les 5 maps café (réseau Métano) de l'utilisateur dans quest_pmd_destiny
et génère leurs apercus pour la visionneuse (source/serveur_apercus/serve.py).

Source : source/reseau_metano_normal_v1/build.py → renders/reseau_metano_normal_v1/
(grounds + tilesheets + apercus). Série de l'utilisateur, branche
arena/e39626d2-projet-creation-pmdo. Références tiers (metano_cafe, spinda_cafe,
guild_second_floor, Metano_Town_Normal_Home) NON importées : usage guidé documenté,
pas de tuile native tierce copiée dans la quest.

Usage : python3 OUTILS/integrer_maps_cafes.py
"""
from pathlib import Path
import base64, json

R = Path(__file__).resolve().parents[1]
DEST = R / 'quest_pmd_destiny'
OUT = R / 'renders' / 'reseau_metano_normal_v1'
MAPS = {  # id map : (libellé, suffixe rendu)
    'metano_gen_accueil': ('Accueil du réseau Métano (café)', 'accueil'),
    'metano_gen_cafe': ('Café Métano (réseau, carte générée)', 'cafe'),
    'metano_gen_casino': ('Casino du réseau Métano', 'casino'),
    'metano_gen_salon_bas': ('Salon bas du réseau Métano', 'salon_bas'),
    'metano_gen_salon_haut': ('Salon haut du réseau Métano', 'salon_haut'),
}
SHEETS = {  # id map : fichier tilesheet
    'metano_gen_accueil': 'MetanoGen_accueil.tile',
    'metano_gen_cafe': 'MetanoGen_cafe.tile',
    'metano_gen_casino': 'MetanoGen_casino.tile',
    'metano_gen_salon_bas': 'MetanoGen_salon_bas.tile',
    'metano_gen_salon_haut': 'MetanoGen_salon_haut.tile',
}

PAGE = """<!doctype html><html lang="fr"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>@@TITRE@@</title><style>
body{margin:0;background:#14161c;color:#e8e8f2;font:15px/1.5 system-ui,sans-serif}
header{padding:18px 24px 8px;max-width:1100px;margin:0 auto}
header h1{margin:0 0 4px;font-size:22px}
.note{opacity:.75;font-size:13px}
.stage{display:flex;justify-content:center;padding:8px 16px 28px}
.frame{max-width:100%;overflow:auto;border:1px solid #333;border-radius:10px;background:
repeating-conic-gradient(#23252d 0 25%,#2b2e38 0 50%) 0 0/24px 24px}
.frame img{display:block;image-rendering:pixelated;width:min(1200px,160vw);max-width:none}
nav{padding:0 24px 24px;max-width:1100px;margin:0 auto}
nav a{color:#8fd3ff}
</style></head><body>
<header><h1>@@TITRE@@</h1>
<p class="note">Carte générée par l'utilisateur (série café / réseau Métano, build
<code>reseau_metano_normal_v1</code>) · rendu terrain · <b>runtime_tested : false</b> ·
fidélité animée : tuiles animées présentes dans la map (FrameLength 60), rendu ici image fixe.</p>
<p class="note">Provenance : génération originale de l'utilisateur guidée par des images de référence
(générateur référencé Halcyon Metano_Town_Normal_Home + formes Café Spinda, crédit
<a href="https://github.com/Palikadude/Halcyon" style="color:#8fd3ff">Palikadude/Halcyon</a>) —
aucune tuile native tierce n'est copiée dans la quest.</p>
</header>
<div class="stage"><div class="frame"><img src="@@IMG@@" alt="@@TITRE@@"></div></div>
<nav><a href="../../apercu_maps_cafes.html">← Série café (5 maps)</a> ·
<a href="../../index.html">← Toutes les maps du pack</a></nav>
</body></html>"""


def read_index(raw: bytes) -> dict:
    """Décode Content/Tile/index.idx → {nom: nœud} (cf. OUTILS/importer_tiles_town02.py)."""
    import io, struct, sys
    sys.path.insert(0, str(R / 'OUTILS'))
    from importer_tiles_town02 import read_string, read_node
    f = io.BytesIO(raw)
    (n,) = struct.unpack('<i', f.read(4))
    nodes = {}
    for _ in range(n):
        name = read_string(f)
        nodes[name] = read_node(f)
    return nodes


def main():
    (DEST / 'Data' / 'Ground').mkdir(parents=True, exist_ok=True)
    (DEST / 'Content' / 'Tile').mkdir(parents=True, exist_ok=True)
    (R / 'apercus' / 'maps').mkdir(parents=True, exist_ok=True)

    for mid, (titre, rid) in MAPS.items():
        src = OUT / 'grounds' / f'{mid}.rsground'
        data = src.read_bytes()
        assert data.startswith(b'{'), f'map JSON attendue: {src}'
        (DEST / 'Data' / 'Ground' / f'{mid}.rsground').write_bytes(data)

        tile = OUT / 'tilesheets' / SHEETS[mid]
        (DEST / 'Content' / 'Tile' / SHEETS[mid]).write_bytes(tile.read_bytes())

        png = OUT / 'apercus' / f'MetanoNormal_{rid}_fond_neutre.png'
        b64 = base64.b64encode(png.read_bytes()).decode()
        page = (PAGE.replace('@@TITRE@@', titre)
                    .replace('@@IMG@@', f'data:image/png;base64,{b64}'))
        (R / 'apercus' / 'maps' / f'{mid}.html').write_text(page, encoding='utf-8')
        print(f'OK {mid}: map + tilesheet + apercu')

    # index des tuiles de la quest
    import sys
    sys.path.insert(0, str(R / 'OUTILS'))
    from importer_tiles_town02 import encode_index
    tidx = DEST / 'Content' / 'Tile' / 'index.idx'
    nodes = read_index(tidx.read_bytes())
    for sheet in SHEETS.values():
        if sheet not in nodes:
            tile_bytes = (DEST / 'Content' / 'Tile' / sheet).read_bytes()
            count = int.from_bytes(tile_bytes[4:8], 'little', signed=True)
            nodes[sheet] = tile_bytes[:8 + count * 16]
    tidx.write_bytes(encode_index(nodes))
    print(f'index tuiles: {len(nodes)} tuileries')

    # page de synthèse (nommée apercu_* → listée par la visionneuse)
    cards = ''.join(
        f'<li style="margin:6px 0"><a href="apercus/maps/{m}.html" style="color:#8fd3ff">{t}</a></li>'
        for m, (t, _) in MAPS.items())
    (R / 'apercu_maps_cafes.html').write_text(f"""<!doctype html><html lang="fr"><head><meta charset="utf-8">
<title>Maps café — réseau Métano</title></head><body style="font:15px system-ui;background:#14161c;color:#eee;padding:24px">
<h1>Maps café — réseau Métano (5 cartes)</h1>
<p>Cartes générées par l'utilisateur (série café / casino / salons), intégrées à la
quest PMDO Destiny — zone <b>maps_cafes</b>. Cliquez une map pour son aperçu.</p>
<ul>{cards}</ul>
<p><a href="index.html" style="color:#8fd3ff">← Toutes les maps du pack</a></p></body></html>""",
        encoding='utf-8')

    # zone PMDO (index = dictionnaire JSON ZoneEntrySummary, utf-8-sig)
    zdir = DEST / 'Data' / 'Zone'
    zone = {
        'ZoneID': 'maps_cafes',
        'Title': {'en': 'Cafe Maps (reseau Metano)', 'fr': 'Maps café (réseau Métano)'},
        'Subtitle': {'en': "User's generated cafe network maps",
                     'fr': "Cartes café générées par l'utilisateur"},
        'ExtraMaps': [], 'DungeonMaps': [], 'GroundMaps': list(MAPS),
        'Asset': {'Assets': [], 'Params': {}}, 'GroundSkills': [],
        'PickDungeonForTeam': 'false', 'StartMap': 'metano_gen_cafe', 'StartDir': 'Down',
    }
    (zdir / 'maps_cafes.json').write_text(json.dumps(zone, ensure_ascii=False, indent=2), encoding='utf-8')
    idx_path = zdir / 'index.idx'
    data = json.loads(idx_path.read_text(encoding='utf-8-sig'))
    obj = data['Object']
    obj['maps_cafes'] = {
        '$type': 'RogueEssence.Data.ZoneEntrySummary, RogueEssence',
        'ExpPercent': 100, 'Level': -1, 'LevelCap': False, 'KeepSkills': False,
        'TeamRestrict': False, 'TeamSize': -1, 'MoneyRestrict': False, 'BagRestrict': -1,
        'KeepTreasure': False, 'BagSize': -1, 'Rescues': 0, 'CountedFloors': 0, 'Rogue': 0,
        'Grounds': list(MAPS), 'Maps': [],
        'Name': {'DefaultText': 'Maps café (réseau Métano)',
                 'LocalTexts': {'fr': 'Maps café (réseau Métano)'}},
        'Released': True,
        'Comment': '5 maps café/casino/salons générées par l\'utilisateur (générateur reseau_metano_normal_v1).',
    }
    idx_path.write_text(json.dumps(data, ensure_ascii=False, indent=1), encoding='utf-8-sig')
    print(f'zone maps_cafes créée ({len(obj) - 1} zones)')

    # lot bibliothèque
    lot_dir = R / 'bibliotheque_ground' / 'lots' / 'maps_cafes'
    lot_dir.mkdir(parents=True, exist_ok=True)
    (lot_dir / 'lot.json').write_text(json.dumps({
        'lot': 'maps_cafes',
        'dossier': 'lots/maps_cafes',
        'titre': 'Maps café — réseau Métano (5 cartes)',
        'description': "Cartes accueil/café/casino/salons générées par l'utilisateur "
                       '(générateur reseau_metano_normal_v1, guidé par images de référence ; '
                       'références Halcyon Metano_Town_Normal_Home + formes Café Spinda créditées). '
                       'Intégrées à la quest PMDO Destiny, zone maps_cafes. runtime_tested: false.',
        'type': 'cartes',
        'map_ids': list(MAPS),
        'tilesheets': list(SHEETS.values()),
        'source': 'renders/reseau_metano_normal_v1 (branche arena/e39626d2-projet-creation-pmdo)',
        'taille_go': 0.01,
        'statut': 'intégré',
        'art_approved': False,
    }, ensure_ascii=False, indent=2), encoding='utf-8')
    print('lot bibliotheque_ground/lots/maps_cafes enregistré')


if __name__ == '__main__':
    main()
