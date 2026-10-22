#!/usr/bin/env python3
"""Industrialisation pmd-red : conversion par lot des ground maps GBA vers
RogueEssence (.tile + .rsground), d'apres le pipeline valide par la zone pilote
autel_celeste (D13P03, commit f9a2c46).

Regle absolue (Partie 6 du document maitre) : AUCUNE transformation spatiale.
- geometrie : rendu identity-mapped (tuile (x,y) -> TexLoc{X:x,Y:y})
- collision : couche collision BMA d'origine cellule par cellule
- positions d'entites : lues AUTOMATIQUEMENT dans les GroundLivesData des
  fichiers src/data/ground/ground_data_*_station.h de pret/pmd-red
  (kind 0 = heros -> Main_Entrance_Marker ; kind 4/34 = partenaire ->
  TEAMMATE_1 ; 10/11 = allies -> TEAMMATE_2/3 ; kind >= 80 = boss/PNJ
  -> Boss_Marker / PNJ_Marker_n) ; GroundEffectData -> Cutscene_Marker_n.
Seul le NOM de zone change (renommage francais, manifeste ci-dessous).

Usage : python3 tools/convert_pmdred_batch.py            (tout le manifeste)
        python3 tools/convert_pmdred_batch.py D12P01 ... (sous-ensemble)
Prerequis : pret/pmd-red clone dans /tmp/pmd-red ; skytemple-files installe.
"""
import io, json, os, re, struct, sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(REPO, 'tools'))
from pmdred_lib import render, get_collision, BASE  # noqa: E402

PMDRED = '/tmp/pmd-red'

# ---------------------------------------------------------------------------
# MANIFESTE : src -> (asset, nom EN, nom FR, musique, usage prevu New Era)
# Les renames sont des originaux francais ; la provenance n'apparait que dans
# les docs de tracabilite, jamais dans les assets.
# ---------------------------------------------------------------------------
MANIFEST = {
 'D01P01': ('foret_tendre_oree',      'Tender Forest Edge',   'Orée de la Forêt Tendre',
            'Friend Area Forest.ogg', 'reserve entree donjon palier 1'),
 'D02P01': ('grotte_statique_seuil',  'Static Cave Mouth',    'Seuil de la Grotte Statique',
            'Friend Area Cave.ogg',   'reserve entree donjon electrique'),
 'D03P01': ('pic_ferreux_pied',       'Ironclad Foothill',    'Pied du Pic Ferreux',
            'Mt. Horn.ogg',           'reserve entree donjon minier'),
 'D04P01': ('gloomy_forest_entrance',      'Duskwood Edge',        'Orée des Bois Sombres',
            'Mystifying Forest.ogg',  'reserve entree foret sombre (Suaire, arc Accusation)'),
 'D05P01': ('gouffre_muet_bord',      'Silent Rim',           'Bord du Gouffre Muet',
            'Growing Anxiety.ogg',    'reserve entree gouffre'),
 'D06P01': ('mont_grondant_pied',     'Thunderous Foothill',  'Pied du Mont Grondant',
            'Rising Fear.ogg',        'reserve entree donjon orage (echo Fulgur)'),
 'D07P01': ('grand_canyon_porte',     'Vast Canyon Gate',     'Porte du Grand Canyon',
            'Canyon Camp.ogg',        'reserve canyon post-ch10 (tileset EoN CrumblingCanyon)'),
 'D08P01': ('grotte_lazuli_seuil',    'Lazuli Cave Mouth',    'Seuil de la Grotte Lazuli',
            'Water Cave.ogg',         'reserve entree grotte bleue'),
 'D08P02': ('grotte_lazuli_fond',     'Lazuli Cave Depths',   'Fond de la Grotte Lazuli',
            'Lower Spring Cave.ogg',  'reserve salle finale grotte bleue'),
 'D09P01': ('mont_cendre_pied',       'Cinder Foothill',      'Pied du Mont Cendré',
            'Deep Dark Crater.ogg',   'reserve entree donjon feu'),
 'D10P01': ('foret_givree_oree',      'Frostwood Edge',       'Orée de la Forêt Givrée',
            'Snow Camp.ogg',          'entree candidate Sentier Glaciaire (ch8, vague 2)'),
 'D11P01': ('mont_gele_pied',         'Frozen Foothill',      'Pied du Mont Gelé',
            'Summit.ogg',             'entree candidate Sentier Enneigé (ch10, vague 2)'),
 'D12P01': ('gorge_ardente_porte',    'Magmatic Gate',        'Porte de la Gorge Ardente',
            'In the Depths of the Pit.ogg', 'reserve arc Groudon (legende de Dotra, ch5)'),
 'D13P01': ('parvis_celeste',         'Celestial Forecourt',  'Parvis Céleste',
            'Sky Peak Prairie.ogg',   'reserve variante entree Pic Celeste'),
 'D22P01': ('vallon_perdu',           'Lost Hollow',          'Vallon Perdu',
            'Sympathy.ogg',           'reserve scene de sauvetage (mission majeure)'),
 'D23P01': ('sanctuaire_voeu',        'Wishing Sanctum',      'Sanctuaire du Vœu',
            'Star Cave.ogg',          'salle finale Grotte du Voeu (Jirachi, decision 2026-07-27)'),
 'D24P01': ('caverne_trouble_fond',   'Murkdepth Hall',       'Fond de la Caverne Trouble',
            'Mysterious Passage.ogg', 'reserve salle de sceau (arc Suaire)'),
 'D24P02': ('caverne_trouble_autel', 'Murkdepth Altar',      'Autel de la Caverne Trouble',
            'Luminous Spring.ogg',    'reserve autel de sceau (arc Suaire)'),
 # --- Lot 3 : arenes de cinematique de boss (material-layer, comme D13P03) ---
 'D12P02': ('gorge_ardente_coeur',   'Magmatic Heart',       'Cœur de la Gorge Ardente',
            'In the Depths of the Pit.ogg', 'cinematique mi-parcours arc Groudon'),
 'D12P04': ('fosse_ardente',         'Blazing Pit',          'Fosse Ardente',
            'In the Depths of the Pit.ogg', 'arene Groudon (casting conserve, regle 1:1)'),
 'D13P02': ('palier_celeste',        'Celestial Landing',    'Palier Céleste',
            'Sky Peak Cave.ogg',      'reserve relais Pic Celeste'),
 'D14P01': ('abime_tempetes',        'Storm Abyss',          'Abîme des Tempêtes',
            'On the Beach at Dusk.ogg', 'arene Kyogre (casting conserve)'),
 'D15P01': ('fosse_argentee',        'Silver Deep',          'Fosse Argentée',
            'Water Cave.ogg',         'arene Lugia pmd-red (reserve, distincte du ch10)'),
 'D16P01': ('champ_braises',         'Ember Reach',          'Champ des Braises',
            'Deep Dark Crater.ogg',   'arene Moltres (casting conserve)'),
 'D17P01': ('champ_foudre',          'Stormbolt Reach',      'Champ de la Foudre',
            'Rising Fear.ogg',        'arene Raikou (casting conserve)'),
 'D18P01': ('champ_vent_boreal',     'Northgale Reach',      'Champ du Vent Boréal',
            'Snow Camp.ogg',          'arene Articuno (casting conserve)'),
 'D19P01': ('sommet_aurore',         'Dawnlit Summit',       'Sommet de l\u2019Aurore',
            'Summit.ogg',             'arene Ho-Oh (casting conserve)'),
 'D20P01': ('antre_occident',        'Westward Den',         'Antre de l\u2019Occident',
            'Growing Anxiety.ogg',    'arene Mewtwo (casting conserve)'),
 'D21P01': ('cretes_boreales',       'Northern Crests',      'Crêtes Boréales',
            'Mt. Travail.ogg',        'arene Latios/Latias (casting conserve)'),
 'D25P01': ('bois_des_plaintes',     'Wailing Woods',        'Bois des Plaintes',
            'Mystifying Forest.ogg',  'arene Suicune (casting conserve)'),
}

# Correspondance src pmd-red -> fichier station (positions d'entites)
def station_path(src):
    return os.path.join(PMDRED, 'src', 'data', 'ground',
                        f'ground_data_{src.lower()}_station.h')


LIVES_RE = re.compile(
    r'/\*\s*\d+\s*\*/\s*\{\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,'
    r'\s*\{\s*(\d+)\s*,\s*(\d+)\s*,')
BLOCK_RE = re.compile(
    r'static const struct (GroundLivesData|GroundEffectData)'
    r'\s+(\w+)\[\]\s*=\s*\{(.*?)\n\};', re.S)


def parse_station(src):
    """Retourne (lives, effs) : lives = [(kind, x, y)] du premier bloc
    contenant le heros (kind 0) ; effs = [(x, y)] du premier bloc d'effets."""
    txt = open(station_path(src), encoding='utf-8', errors='replace').read()
    lives_blocks, effs_blocks = [], []
    for kind, name, body in BLOCK_RE.findall(txt):
        entries = [(int(m[0]), int(m[4]), int(m[5])) for m in LIVES_RE.findall(body)]
        if not entries:
            continue
        (lives_blocks if kind == 'GroundLivesData' else effs_blocks).append(entries)
    lives = next((b for b in lives_blocks if any(k == 0 for k, _, _ in b)),
                 lives_blocks[0] if lives_blocks else [])
    effs = effs_blocks[0] if effs_blocks else []
    return lives, [(x, y) for _, x, y in effs]


# --- writers (identiques au pilote convert_pmdred_ground.py) ---------------

def write_tile_file(img, out_path, tile_size=8):
    W, H = img.size
    cols, rows = W // tile_size, H // tile_size
    entries = []
    for y in range(rows):
        for x in range(cols):
            t = img.crop((x*tile_size, y*tile_size, (x+1)*tile_size, (y+1)*tile_size))
            buf = io.BytesIO()
            t.save(buf, 'PNG', optimize=True)
            entries.append(((x | (y << 32)), buf.getvalue()))
    uniq, order = {}, []
    for key, png in entries:
        if png not in uniq:
            uniq[png] = None
            order.append(png)
    header_size = 8 + len(entries) * 16
    offsets, pos = {}, header_size
    for h in order:
        offsets[h] = pos
        pos += 8 + len(h)
    out = bytearray()
    out += struct.pack('<II', tile_size, len(entries))
    for key, png in entries:
        out += struct.pack('<QQ', key, offsets[png])
    for h in order:
        out += struct.pack('<Q', len(h)) + h
    open(out_path, 'wb').write(bytes(out))
    return len(entries), len(order)


def mk_marker(nm, x, y, direction=4):
    return {"EntName": nm, "Direction": direction, "EntEnabled": True,
            "EntOrder": 0, "InteractOrder": 0, "triggerType": 0,
            "Collider": {"X": x, "Y": y, "Width": 16, "Height": 16}}


def mk_spawner(nm, x, y):
    tpl = json.load(open(os.path.join(REPO, 'Data/Ground/searing_tunnel_midpoint.rsground'),
                         encoding='utf-8-sig'))
    src = [s for s in tpl['Object']['Entities'][0]['Spawners']
           if s.get('EntName') == 'TEAMMATE_1'][0]
    import copy
    s = copy.deepcopy(src)
    s['NPCName'] = 'Teammate' + nm[-1]
    s['EntName'] = nm
    s['Collider'] = {"X": x, "Y": y, "Width": 16, "Height": 16}
    return s


def make_rsground(name, name_en, name_fr, comment, music, sheet, W, H, collision,
                  markers, spawners, out_path):
    def tile(x, y):
        return {"AutoTileset": "", "Associates": [],
                "Layers": [{"Frames": [{"Sheet": sheet, "TexLoc": {"X": x, "Y": y}}],
                            "FrameLength": 60}],
                "NeighborCode": -1}
    tiles = [[tile(x, y) for y in range(H)] for x in range(W)]
    obstacles = [[{"Bounds": {"X": x*8, "Y": y*8, "Width": 8, "Height": 8},
                   "Tags": 1 if collision[y*W + x] else 0}
                  for y in range(H)] for x in range(W)]
    d = {
        "Version": "0.8.9.0",
        "Object": {
            "$type": "RogueEssence.Ground.GroundMap, RogueEssence",
            "TexSize": 1,
            "Name": {"DefaultText": name_en, "LocalTexts": {"fr": name_fr}},
            "Released": False,
            "Comment": comment,
            "obstacles": obstacles,
            "rand": {"$type": "RogueElements.ReRandom, RogueElements",
                     "FirstSeed": 0, "s": [16294208416658607535, 7960286522194355700,
                                            4876170194715417726, 12554865158188930543]},
            "Status": {},
            "Background": {"$type": "RogueEssence.Dungeon.MapBG, RogueEssence",
                           "MapLoc": {"X": 0, "Y": 0},
                           "BGAnim": {"AnimIndex": "", "FrameTime": 1,
                                      "StartFrame": -1, "EndFrame": -1,
                                      "AnimDir": -1, "Alpha": 255, "AnimFlip": 0},
                           "BGMovement": {"X": 0, "Y": 0},
                           "RepeatX": False, "RepeatY": False},
            "BlankBG": {"AutoTileset": "", "Associates": [], "Layers": [],
                        "NeighborCode": -1},
            "Layers": [{"Name": "Base", "Layer": 0, "Visible": True,
                        "Tiles": tiles}],
            "AssetName": name,
            "Music": music,
            "EdgeView": 1,
            "NoSwitching": False,
            "ViewCenter": None,
            "ViewOffset": {"X": 0, "Y": 0},
            "ActiveChar": None,
            "Decorations": [{"Name": "New Deco", "Layer": 0, "Visible": True,
                             "Anims": []}],
            "Entities": [{"Name": "New EntLayer", "Visible": True,
                          "MapChars": [],
                          "GroundObjects": [],
                          "Spawners": spawners,
                          "Markers": markers}],
        },
    }
    with io.open(out_path, 'w', encoding='utf-8-sig') as f:
        json.dump(d, f, ensure_ascii=False, indent=1)


def sheet_name(asset):
    return ''.join(p.capitalize() for p in asset.split('_')) + '_Base'


def flood_stats(collision, W, H, sx, sy):
    """Audit spatial : nb de cases atteignables depuis (sx,sy) en tuiles."""
    from collections import deque
    walk = {(x, y) for x in range(W) for y in range(H) if not collision[y*W + x]}
    if (sx, sy) not in walk:
        return 0, len(walk), False
    seen, q = {(sx, sy)}, deque([(sx, sy)])
    while q:
        x, y = q.popleft()
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            n = (x+dx, y+dy)
            if n in walk and n not in seen:
                seen.add(n)
                q.append(n)
    return len(seen), len(walk), True


def convert(src):
    asset, name_en, name_fr, music, usage = MANIFEST[src]
    img, W, H = render(src, None)
    from PIL import Image
    bg = Image.new('RGBA', img.size, (0, 0, 0, 255))
    bg.alpha_composite(img)
    img = bg
    coll, cw, ch = get_collision(f'{BASE}/{src}m.bma')
    coll_derived = False
    if coll is None:
        # Le BMA source n'a pas de couche collision (hasCollision=0).
        # Fallback documente : bloque = tuile 8x8 entierement noire (hors
        # decor visible), marchable sinon. Consigne dans la tracabilite.
        coll_derived = True
        cw, ch = W, H
        px = img.load()
        coll = []
        for y in range(H):
            for x in range(W):
                black = all(px[x*8+i, y*8+j][:3] == (0, 0, 0)
                            for i in (0, 3, 7) for j in (0, 3, 7))
                coll.append(1 if black else 0)
    assert (cw, ch) == (W, H), f'{src}: collision {cw}x{ch} != rendu {W}x{H}'
    lives, effs = parse_station(src)

    sheet = sheet_name(asset)
    n_ent, n_uniq = write_tile_file(img, os.path.join(REPO, f'Content/Tile/{sheet}.tile'))

    T = 8
    markers, spawners = [], []
    mates = 0
    boss_done = False
    npc_i = 0
    hero = None
    for kind, x, y in lives:
        if kind == 0 and hero is None:
            hero = (x, y)
            markers.append(mk_marker('Main_Entrance_Marker', x*T, y*T, 0))
        elif kind in (4, 34, 10, 11) and mates < 3:
            mates += 1
            spawners.append(mk_spawner(f'TEAMMATE_{mates}', x*T, y*T))
        elif kind >= 80 and not boss_done:
            boss_done = True
            markers.append(mk_marker('Boss_Marker', x*T, y*T, 4))
        else:
            npc_i += 1
            markers.append(mk_marker(f'PNJ_Marker_{npc_i}', x*T, y*T, 4))
    for i, (x, y) in enumerate(effs):
        markers.append(mk_marker(f'Cutscene_Marker_{i+1}' if i else 'Cutscene_Marker',
                                 x*T, y*T, 4))
    if hero is None:
        # fallback : centre des cases marchables
        walk = [(x, y) for x in range(W) for y in range(H) if not coll[y*W + x]]
        cx = sum(p[0] for p in walk)//len(walk)
        cy = sum(p[1] for p in walk)//len(walk)
        hero = (cx, cy)
        markers.insert(0, mk_marker('Main_Entrance_Marker', cx*T, cy*T, 0))

    comment = (f'New Era - {name_fr}. Imported 1:1 from pmd-red {src} '
               f'(github.com/pret/pmd-red). Geometry, collision and entity '
               f'positions preserved from ground_data_{src.lower()}_station.h; '
               f'only the zone name changes. Usage: {usage}.'
               + (' Collision derived from visible area (source BMA has no '
                  'collision layer).' if coll_derived else ''))
    make_rsground(asset, name_en, name_fr, comment, music, sheet, W, H, coll,
                  markers, spawners,
                  os.path.join(REPO, f'Data/Ground/{asset}.rsground'))

    reach, walk_n, on_walk = flood_stats(coll, W, H, hero[0], hero[1])
    print(f'{src} -> {asset:24s} {W}x{H}  tiles={n_ent}({n_uniq}u)  '
          f'lives={len(lives)} effs={len(effs)}  '
          f'flood={reach}/{walk_n}{"" if on_walk else "  !! HERO SUR MUR"}')
    return {'src': src, 'asset': asset, 'fr': name_fr, 'W': W, 'H': H,
            'lives': lives, 'effs': effs, 'reach': reach, 'walk': walk_n,
            'hero_on_walk': on_walk, 'usage': usage, 'music': music,
            'coll_derived': coll_derived}


if __name__ == '__main__':
    targets = sys.argv[1:] or list(MANIFEST)
    results = [convert(s) for s in targets]
    bad = [r for r in results if not r['hero_on_walk'] or r['reach'] == 0]
    print(f'\n{len(results)} zones converties, {len(bad)} anomalies')
    for r in bad:
        print('  !!', r['src'], r['asset'])
