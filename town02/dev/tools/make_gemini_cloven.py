#!/usr/bin/env python3
# =============================================================================
# make_gemini_cloven.py — integre la MAP IMAGE ( dessinee hors-jeu ) comme
# ground playable : cloven_ruins_entrance.rsground
#
# PRINCIPE
#   Le moteur n'affiche que des tuiles. L'image source est decoupee en frames
#   16x16 px SANS PERTE (dedoupe a l'octet vers une seule donnee PNG reunie en
#   paquet .tile au format prouve : u32 tileSize + u32 count + index
#   (key=x|y<<32 -> offset) + frames (u64 len + PNG)). La Base de la map
#   reference chaque frame a sa position : le rendu est pixel-identique a
#   l'image, eton moteur reste heureux.
#
# REGLES APPRISES DU GLITCH PRECEDENT :
#   - NOM DE FEUILLE SANS ESPACES ni caracteres exotiques ('GeminiClovenGate').
#     Les feuilles 'Old Ruins Stairs Layer 1' (espaces) ne se chargeaient
#     pas en jeu -> precedentes maps glitchees.
#   - obstacles : Bounds reelles {X,Y,16,16} par cellule (crash sinon).
#   - entrees Layers/Decorations : clonees du donneur d'origine (CLOVEN_ORIG).
#   - TexSize 2 (16 px).
#
# UTILISATION :  python3 tools/make_gemini_cloven.py --image <chemin.png>
#   Geometrie editable en haut de fichier (zones de marche, positions
#   d'entites) ; WALK_BOXES en px. --force pour reecrire la map.
# =============================================================================
import json, struct, io, copy, sys, os, hashlib

MAP_PATH = 'Data/Ground/cloven_ruins_entrance.rsground'
SHEET_NAME = 'GeminiClovenGate'          # SANS espaces
SHEET_PATH = f'Content/Tile/{SHEET_NAME}.tile'
MARK = 'make_gemini_cloven v1'
TS = 16                                  # px par tuile -> TexSize 2

# ---- GEOMETRIE (px, dans le repere de l'image) ------------------------------
# Zones de marche (x, y, l, h) en px, alignees 16, calibrees sur grille 64px :
#   terrasse gauche (arbre bleu) -> escalier de pierre -> pont de bois ->
#   sentier du bas -> pierres sautees de la gorge -> parvis -> porte.
#   NON marchable : gouffre, falaises, eau bas-gauche, statue golem et
#   arche haut-droite (corniches visees, sans pont dans l'image).
WALK_BOXES = [
    (336, 544, 160, 48),    # chemin du haut (terre)           x336-496 y544-592
    (384, 592, 64, 48),     # passage entre cube et rocher     x384-448 y592-640
    (432, 624, 96, 64),     # dalles du bas                    x432-528 y624-688 (bord sud bloque)
    (256, 448, 192, 64),    # pont de bois                     x256-448 y448-512
    (432, 496, 80, 48),     # dalle haute mousseuse            x432-512 y496-544
    (192, 352, 96, 96),     # escalier vers la terrasse        x192-288 y352-448
    (464, 448, 96, 48),     # pierre sautee 2                  x464-560 y448-496
    (496, 400, 96, 48),     # pierre sautee 3                  x496-592 y400-448
    (528, 356, 96, 48),     # pierre sautee 4                  x528-624 y356-404
    (544, 320, 160, 96),    # parvis de la porte               x544-704 y320-416
    (96, 240, 64, 48),      # terrasse haute gauche            x96-160  y240-288
    (216, 240, 56, 48),     # terrasse haute droite            x216-272 y240-288
    (216, 288, 56, 32),     # liaison terrasse                 x216-272 y288-320
    (16, 264, 144, 64),     # terrasse gauche                  x16-160  y264-328
    (144, 320, 128, 80),    # terrasse basse gauche            x144-272 y320-400 (col 9 = liaison D2)
]
# Entites (px) ---------------------------------------------------------------
POS = {
    'Main_Entrance_Marker': (432, 576),   # spawn sur le sentier de terre
    'TEAMMATE_1': (384, 568),
    'TEAMMATE_2': (480, 576),
    'TEAMMATE_3': (432, 616),
    'Kangaskhan_Rock': (556, 376),        # statue de sauvegarde sur le parvis
    'Dungeon_Entrance': (600, 320, 96, 32),  # gueule de la porte (x, y, l, h)
}
# -----------------------------------------------------------------------------


def main():
    args = sys.argv[1:]
    img = None
    force = '--force' in args
    for i, a in enumerate(args):
        if a == '--image' and i + 1 < len(args):
            img = args[i + 1]
    if not img or not os.path.exists(img):
        print('USAGE: python3 tools/make_gemini_cloven.py --image <chemin.png> [--force]')
        sys.exit(1)

    root = json.load(open(MAP_PATH, encoding='utf-8-sig'))
    old = root['Object']
    if MARK in str(old.get('Comment', '')) and not force:
        print('Refus: marque deja presente (--force pour reposer).')
        return
    donor_path = os.environ.get('CLOVEN_ORIG')
    donor = json.load(open(donor_path, encoding='utf-8-sig'))['Object'] if donor_path else old

    gx, gy = write_pkg(img, SHEET_PATH)
    print('paquet tuiles ecrit:', SHEET_PATH)

    W_CELLS, H_CELLS = gx, gy
    def cell(sheet, fx, fy):
        return {"AutoTileset": "", "Associates": [],
                "Layers": [{"Frames": [{"Sheet": sheet, "TexLoc": {"X": fx, "Y": fy}}], "FrameLength": 60}],
                "NeighborCode": 0}
    tiles = [[cell(SHEET_NAME, x, y) for y in range(H_CELLS)] for x in range(W_CELLS)]

    # obstacles : Bounds reelles par cellule
    obs = [[1] * H_CELLS for _ in range(W_CELLS)]
    for (bx, by, bw, bh) in WALK_BOXES:
        for cx in range(bx // TS, (bx + bw) // TS):
            for cy in range(by // TS, (by + bh) // TS):
                if 0 <= cx < W_CELLS and 0 <= cy < H_CELLS:
                    obs[cx][cy] = 0
    obs_out = [[{"Bounds": {"X": x * TS, "Y": y * TS, "Width": TS, "Height": TS},
                 "Tags": obs[x][y]} for y in range(H_CELLS)] for x in range(W_CELLS)]
    nwalk = sum(1 for x in range(W_CELLS) for y in range(H_CELLS) if obs[x][y] == 0)
    print('marchables:', nwalk, '/', W_CELLS * H_CELLS)

    # entites
    ents = copy.deepcopy(old['Entities'][0])
    def find(seq, name):
        for e in seq:
            if e.get('EntName') == name:
                return e
    def place(collider_holder, xywh):
        if len(xywh) == 2:
            w, h = collider_holder['Collider']['Width'], collider_holder['Collider']['Height']
            collider_holder['Collider'] = {'Height': h, 'Width': w, 'X': xywh[0], 'Y': xywh[1]}
        else:
            collider_holder['Collider'] = {'X': xywh[0], 'Y': xywh[1], 'Width': xywh[2], 'Height': xywh[3]}
    mk = find(ents['Markers'], 'Main_Entrance_Marker')
    if mk: place(mk, POS['Main_Entrance_Marker'])
    for s in ents['Spawners']:
        if s['EntName'] in POS: place(s, POS[s['EntName']])
    de = find(ents['GroundObjects'], 'Dungeon_Entrance')
    if de is not None: place(de, POS['Dungeon_Entrance'])
    ks = find(ents['GroundObjects'], 'Kangaskhan_Rock')
    if ks is not None: place(ks, POS['Kangaskhan_Rock'])

    old_by_name = {L['Name']: L for L in donor['Layers']}
    base_layer = copy.deepcopy(old_by_name.get('Base', donor['Layers'][0]))
    base_layer['Name'] = 'Base'
    base_layer['Tiles'] = tiles
    new_layers = [base_layer]

    new_obj = copy.deepcopy(old)
    new_obj['Comment'] = (f'{MARK} — map image exterieure decoupee sans perte en tuiles {TS}px ; '
                          'geometrie de marche calquee sur l image ; feuille sans espaces')
    new_obj['TexSize'] = 2
    new_obj['Layers'] = new_layers
    new_obj['obstacles'] = obs_out
    new_obj['Entities'] = [ents]
    if donor.get('Decorations'):
        deco = copy.deepcopy(donor['Decorations'][0])
        deco.pop('$type', None)
        deco['Anims'] = []
        new_obj['Decorations'] = [deco]

    text = '﻿' + json.dumps({'Version': root.get('Version', '0.8.9.0'), 'Object': new_obj},
                            ensure_ascii=False, indent=0)
    with open(MAP_PATH, 'w', encoding='utf-8') as f:
        f.write(text)
    print('ecrit', MAP_PATH, len(text), 'octets —', W_CELLS, 'x', H_CELLS, 'cellules @16px')


def write_pkg(img_path, out_path):
    from PIL import Image
    im = Image.open(img_path).convert('RGBA')
    W, H = im.size
    W2, H2 = -(-W // TS) * TS, -(-H // TS) * TS
    if (W2, H2) != (W, H):
        pad = Image.new('RGBA', (W2, H2))
        pad.paste(im, (0, 0))
        if W2 > W:
            pad.paste(im.crop((W - 1, 0, W, H)).resize((W2 - W, H), Image.NEAREST), (W, 0))
        if H2 > H:
            pad.paste(im.crop((0, H - 1, W2, H)).resize((W2, H2 - H), Image.NEAREST), (0, H))
        im = pad
    gx, gy = W2 // TS, H2 // TS
    print(f'decoupe: {gx}x{gy} cellules {TS}px (image {W}x{H} paddee {W2}x{H2})')

    # collecte : une donnee PNG par contenu unique
    png_of = {}              # (x,y) -> bytes
    uniq = {}                # hash -> bytes
    for y in range(gy):
        for x in range(gx):
            buf = io.BytesIO()
            im.crop((x * TS, y * TS, x * TS + TS, y * TS + TS)).save(buf, 'PNG')
            png = buf.getvalue()
            png_of[(x, y)] = png
            uniq.setdefault(hashlib.md5(png).digest(), png)

    # blocs (u64 len + png) concatenees dans l'ordre des cles
    order = sorted(uniq.items(), key=lambda kv: kv[0])
    blob = bytearray()
    off_by_hash = {}
    for h, png in order:
        off_by_hash[h] = len(blob)
        blob += struct.pack('<Q', len(png)) + png

    n = len(png_of)
    header_size = 8 + 16 * n
    with open(out_path, 'wb') as f:
        f.write(struct.pack('<II', TS, n))
        for (x, y) in sorted(png_of):
            h = hashlib.md5(png_of[(x, y)]).digest()
            f.write(struct.pack('<QQ', (y << 32) | x, header_size + off_by_hash[h]))
        f.write(bytes(blob))
    return gx, gy


if __name__ == '__main__':
    main()
