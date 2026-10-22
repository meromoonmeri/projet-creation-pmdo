#!/usr/bin/env python3
# =============================================================================
# make_cloven_entrance.py — reconstruction totale de Data/Ground/cloven_ruins_entrance.rsground
#
# CONCEPT (choix utilisateur 2026-07-29, "porte_foret") :
#   entree des Aegis Cave = portique enfoui dans la foret.
#   Assemblage authentique "Old Ruins Stairs" (L1+L2+L3, 480x432 px natif)
#   + portique de piliers (Relic_Forest_Blob_*) + decombres, sur une base
#   d'herbe Relic_Forest_Base (frame echantillonnee de la map d'origine).
#
# FORMAT PROUVE : celui des maps existantes (BOM UTF-8 + json ensure_ascii=False,
# indent=0, cellules {"AutoTileset":"","Associates":[],"Layers":[{...un seul
# sous-calque...}],"NeighborCode":0}, TexSize 1 = 8 px). Empilement par CALQUES
# DE MAP separes (Base/Objects Under/Objects/Fringe) — JAMAIS deux sous-calques
# par cellule (schema non atteste dans le depot).
#   Base          = herbe (8 px)
#   Objects Under = Old Ruins Stairs Layer 1 (24 px)
#   Objects       = Old Ruins Stairs Layer 2 (24 px)
#   Fringe        = Old Ruins Stairs Layer 3 (24 px) + piliers/decombres (24 px)
#
# GEOMETRIE (px, grille obstacles 8 px, Tags 0 = marchable) :
#   corridor joueur : plateau SE -> volee -> corniche -> tablier -> declencheur
#   declencheur Dungeon_Entrance dans la bouche de l'arche au NO.
#
# IDEMPOTENT : si la map porte deja la marque de cet outil, refuse de tourner.
# =============================================================================
import json, struct, io, copy, sys, os

MAP_PATH = 'Data/Ground/cloven_ruins_entrance.rsground'
MARK = 'make_cloven_entrance v1'
W_CELLS, H_CELLS = 60, 54           # 480x432 px
PX = 8                              # TexSize 1
SHEET_L1 = 'Old Ruins Stairs Layer 1'
SHEET_L2 = 'Old Ruins Stairs Layer 2'
SHEET_L3 = 'Old Ruins Stairs Layer 3'


def load_tile_pkg(path):
    from PIL import Image
    raw = open(path, 'rb').read()
    ts, n = struct.unpack_from('<II', raw, 0)
    off = 8
    F = {}
    for _ in range(n):
        k, v = struct.unpack_from('<QQ', raw, off); off += 16
        ln = struct.unpack_from('<Q', raw, v)[0]
        im = Image.open(io.BytesIO(raw[v + 8:v + 8 + ln])).convert('RGBA')
        F[(k & 0xFFFFFFFF, k >> 32)] = im
    return ts, F


def cell(frames):
    """frames = [(Sheet, x, y)] — un seul sous-calque par cellule (schema prouve)."""
    if not frames:
        return {"AutoTileset": "", "Associates": [], "Layers": [], "NeighborCode": 0}
    return {"AutoTileset": "", "Associates": [],
            "Layers": [{"Frames": [{"Sheet": s, "TexLoc": {"X": fx, "Y": fy}} for s, fx, fy in frames],
                        "FrameLength": 60}], "NeighborCode": 0}


def find(seq, name):
    for e in seq:
        if e.get('EntName') == name:
            return e
    return None


def main():
    root = json.load(open(MAP_PATH, encoding='utf-8-sig'))
    old = root['Object']
    # Donneur de schema : la version ORIGINALE de la map (avant cet outil),
    # recuperee de l'historique git. Les entrees Layers/Decorations y sont
    # conformes moteur (champ 'Layer', clefs completes). Sans donneur, on
    # retombe sur le fichier courant (deja marque => pas de clefs fiables).
    donor_path = os.environ.get('CLOVEN_ORIG')
    if donor_path:
        donor = json.load(open(donor_path, encoding='utf-8-sig'))['Object']
    else:
        donor = old
    if MARK in str(old.get('Comment', '')) and '--force' not in sys.argv:
        print('Refus: la map porte deja la marque', MARK, '— rien a faire (--force pour reposer).')
        return

    # --- frame d'herbe echantillonnee de la map d'origine ---
    sample = old['Layers'][0]['Tiles'][15][20]
    grass = None
    for sub in sample.get('Layers', []):
        for fr in sub.get('Frames', []):
            grass = (fr['Sheet'], fr['TexLoc']['X'], fr['TexLoc']['Y'])
    assert grass and grass[0] == 'Relic_Forest_Base', f'frame herbe introuvable: {sample}'
    print('frame herbe retenue:', grass)

    # --- feuilles 24 px (frames non vides uniquement) ---
    _, L1 = load_tile_pkg(f'Content/Tile/{SHEET_L1}.tile')
    _, L2 = load_tile_pkg(f'Content/Tile/{SHEET_L2}.tile')
    _, L3 = load_tile_pkg(f'Content/Tile/{SHEET_L3}.tile')
    L1 = {k: v for k, v in L1.items() if v.getbbox()}
    L2 = {k: v for k, v in L2.items() if v.getbbox()}
    L3 = {k: v for k, v in L3.items() if v.getbbox()}
    print(f'L1 {len(L1)} frames, L2 {len(L2)} frames, L3 {len(L3)} frames')

    layers = {name: [[cell([]) for _ in range(H_CELLS)] for _ in range(W_CELLS)]
              for name in ('Base', 'Objects Under', 'Objects', 'Fringe')}
    for x in range(W_CELLS):
        for y in range(H_CELLS):
            layers['Base'][x][y] = cell([grass])

    def put(layer, sheet, fx, fy, pxX, pxY):
        cx, cy = pxX // PX, pxY // PX
        layers[layer][cx][cy] = cell([(sheet, fx, fy)])

    # --- assemblage Old Ruins Stairs ---
    for (fx, fy) in L1:
        put('Objects Under', SHEET_L1, fx, fy, fx * 24, fy * 24)
    for (fx, fy) in L2:
        put('Objects', SHEET_L2, fx, fy, fx * 24, fy * 24)

    # --- zones totalement vides (ni L1/L2/L3) -> boucher au noir si frame trouvee ---
    black = None
    for (fx, fy), im in L1.items():
        r, g, b, a = im.resize((1, 1)).getpixel((0, 0))
        if a == 255 and r < 25 and g < 25 and b < 25:
            black = (SHEET_L1, fx, fy); break
    nfilled = 0
    if black:
        for gx in range(20):
            for gy in range(18):
                if (gx, gy) not in L1 and (gx, gy) not in L2 and (gx, gy) not in L3:
                    put('Objects', *black, gx * 24, gy * 24)
                    nfilled += 1
    print('frame noire:', black, '| cellules bouchees:', nfilled)

    # --- L3 + portique sur Fringe ---
    for (fx, fy) in L3:
        put('Fringe', SHEET_L3, fx, fy, fx * 24, fy * 24)
    P, B = 'Relic_Forest_Blob_Pillar', 'Relic_Forest_Blob_Broken_Pillar'
    FL, FR = 'Relic_Forest_Blob_Fallen_Left', 'Relic_Forest_Blob_Fallen_Right'
    R, RU = 'Relic_Forest_Blob_Rubble', 'Relic_Forest_Blob_Ruins'
    def fringe(sheet, fx, fy, px):
        put('Fringe', sheet, fx, fy, px[0], px[1])
    # piliers flanquant l'arche (jambe ouest x=84, est x=240, contre la falaise
    # a l'est de l'anneau x 96..236 ; futs y 144-216, bases au tablier)
    for py, fr in ((192, (0, 2)), (168, (0, 1)), (144, (0, 0))):
        fringe(P, *fr, (84, py))
        fringe(P, *fr, (240, py))
    # pilier brise au pied de la volee (bord du plateau)
    fringe(B, 0, 0, (264, 264))
    fringe(B, 0, 1, (264, 288))
    # decombres
    fringe(FL, 0, 0, (72, 96));  fringe(FL, 1, 0, (48, 96))
    fringe(FR, 0, 1, (240, 336)); fringe(FR, 1, 1, (216, 336))
    fringe(R, 0, 0, (264, 72));  fringe(R, 0, 0, (312, 240))
    # rangee de pierres gravees marquant la limite sud du plateau
    for i, gx in enumerate((312, 336, 360)):
        fringe(RU, i, 0, (gx, 312))

    # --- obstacles (0 = marchable) ; tout solide par defaut ---
    obs = [[1] * H_CELLS for _ in range(W_CELLS)]
    def walk(pxX, pxY, w, h):
        for cx in range(pxX // PX, (pxX + w) // PX):
            for cy in range(pxY // PX, (pxY + h) // PX):
                if 0 <= cx < W_CELLS and 0 <= cy < H_CELLS:
                    obs[cx][cy] = 0
    # zones de marche recalees sur l'art (rendu composite annote) :
    walk(284, 336, 196, 96)    # plateau de paves SE (spawn, rocher)
    walk(356, 328, 124, 44)    # pied de volee -> plateau
    walk(348, 238, 80, 98)     # volee d'escalier (entre balustres et mur)
    walk(320, 230, 40, 44)     # tete de volee -> corniche
    walk(196, 236, 148, 36)    # bandeau de dalles grises (corniche vers l'est)
    walk(120, 228, 96, 40)     # tablier de terre devant la bouche de l'arche
    nwalk = sum(1 for x in range(W_CELLS) for y in range(H_CELLS) if obs[x][y] == 0)
    print('cellules marchables:', nwalk, '/', W_CELLS * H_CELLS)

    # --- entites reprises/repositionnees ---
    ents = copy.deepcopy(old['Entities'][0])
    mk = find(ents['Markers'], 'Main_Entrance_Marker')
    if mk: mk['Collider'] = {'Height': 16, 'Width': 16, 'X': 408, 'Y': 376}
    sp = {s['EntName']: s for s in ents['Spawners']}
    if 'TEAMMATE_1' in sp: sp['TEAMMATE_1']['Collider'] = {'Height': 16, 'Width': 16, 'X': 440, 'Y': 376}
    if 'TEAMMATE_2' in sp: sp['TEAMMATE_2']['Collider'] = {'Height': 16, 'Width': 16, 'X': 384, 'Y': 384}
    if 'TEAMMATE_3' in sp: sp['TEAMMATE_3']['Collider'] = {'Height': 16, 'Width': 16, 'X': 440, 'Y': 400}
    de = find(ents['GroundObjects'], 'Dungeon_Entrance')
    if de is not None:
        de['Collider'] = {'Height': 16, 'Width': 40, 'X': 144, 'Y': 220}
    ks = find(ents['GroundObjects'], 'Kangaskhan_Rock')
    if ks is not None:
        ks['Collider'] = {'Height': 24, 'Width': 24, 'X': 312, 'Y': 376}

    # --- format obstacles : {"Bounds":{"X":x*8,"Y":y*8,"Width":8,"Height":8},
    # "Tags":n} PAR CELLULE (preuve : texte brut de relic_forest.rsground).
    # Ne JAMAIS copier la Bounds d'une cellule sur une autre : le moteur s'en
    # sert pour indexer la grille de collisions (sinon : collisions cassees/crash).
    obs_out = [[{"Bounds": {"X": x * PX, "Y": y * PX, "Width": PX, "Height": PX},
                 "Tags": obs[x][y]} for y in range(H_CELLS)] for x in range(W_CELLS)]

    new_obj = copy.deepcopy(old)
    new_obj['Comment'] = (f'{MARK} — portique enfoui dans la foret ; Old Ruins Stairs (3 calques) '
                          '+ piliers Blob ; corridor de marche verifie par rendu')
    # Layers : CLONER les entrees de l'ancienne map (champ 'Layer' requis par
    # le moteur, prouve par le texte brut de relic_forest) et ne remplacer
    # que 'Tiles'. Ne PAS construire d'entrees minimales.
    old_by_name = {L['Name']: L for L in donor['Layers']}
    new_layers = []
    for i, name in enumerate(('Base', 'Objects Under', 'Objects', 'Fringe')):
        if name in old_by_name:
            nl = copy.deepcopy(old_by_name[name])
        else:
            nl = copy.deepcopy(donor['Layers'][min(i, len(donor['Layers']) - 1)])
            nl['Name'] = name
        nl['Tiles'] = layers[name]
        new_layers.append(nl)
    new_obj['Layers'] = new_layers
    new_obj['obstacles'] = obs_out
    new_obj['Entities'] = [ents]
    # Decorations : meme logique — cloner l'entree d'origine (clefs
    # Name/Layer/Visible/Anims, sans $type) et vider ses anims.
    if donor.get('Decorations'):
        deco = copy.deepcopy(donor['Decorations'][0])
        deco.pop('$type', None)
        deco['Anims'] = []
        new_obj['Decorations'] = [deco]
    new_obj['MapChars'] = old.get('MapChars', new_obj.get('MapChars', []))

    text = '﻿' + json.dumps({'Version': root.get('Version', '0.8.9.0'), 'Object': new_obj},
                            ensure_ascii=False, indent=0)
    with open(MAP_PATH, 'w', encoding='utf-8') as f:
        f.write(text)
    print('ecrit', MAP_PATH, len(text), 'octets')


if __name__ == '__main__':
    main()
