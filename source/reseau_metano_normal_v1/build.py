#!/usr/bin/env python3
"""Réseau de pièces Métano Normal — MÉTHODE GÉNÉRATEUR RÉFÉRENCÉ.

5 pièces générées par le générateur d'images avec double référence :
(1) le rendu Halcyon metano_normal_home (texture Metano_Town_Normal_Home,
variante normale) et (2) la salle Café Spinda V7 correspondante (forme).
Pièces LARGES et COMPLÈTEMENT VIDES (aucun mobilier), disposition Spinda :
accueil RDC escaliers N/S centrés, café + salon_haut au +1, casino +
salon_bas au -1, salons à l'est.

Traitement : détourage magenta, silhouette recalée EXACTEMENT sur le
masque alpha de la salle Spinda correspondante, nettoyage de frange
pourpre (recoloration depuis l'intérieur, résidu mesuré = 0), réduction
à 600x448, export PNG transparent + aperçu fond neutre + tileset .tile
et Ground PMDO construits depuis les tuiles 8 px du rendu réduit.
Pixels GÉNÉRÉS (pas des tuiles natives Halcyon). Non testé moteur.
"""
import base64, copy, io, json, struct
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
REF = HERE / 'references'
BRUTS = HERE / 'bruts'
SPINDA = ROOT / 'renders/cafe_spinda_revisite_v7/salles'
OUT = ROOT / 'renders/reseau_metano_normal_v1'
NEUTRAL = (58, 48, 40)
W, H = 800, 600  # 100x75 tuiles : calibre sur les interieurs de guilde Halcyon (lobby 100x56, 2e etage 84x56)
TW, TH = W // 8, H // 8

ROOMS = ['accueil', 'cafe', 'salon_haut', 'casino', 'salon_bas']
FLOORS = {'accueil': 0, 'cafe': 1, 'salon_haut': 1, 'casino': -1, 'salon_bas': -1}
ACCESS = {
    'accueil': {'escalier_N': (300, 66), 'escalier_S': (300, 398)},
    'cafe': {'porte_S_depuis_accueil': (92, 392), 'porte_E_vers_salon_haut': (548, 210)},
    'salon_haut': {'porte_W_vers_cafe': (52, 210)},
    'casino': {'porte_N_depuis_accueil': (66, 190), 'porte_E_vers_salon_bas': (548, 235)},
    'salon_bas': {'porte_W_vers_casino': (52, 235)},
}
LINKS = [['accueil', 'escalier_N', 'cafe', 'porte_S_depuis_accueil'],
         ['accueil', 'escalier_S', 'casino', 'porte_N_depuis_accueil'],
         ['casino', 'porte_E', 'salon_bas', 'porte_W'],
         ['cafe', 'porte_E', 'salon_haut', 'porte_W']]


def segment_magenta(im):
    a = np.array(im.convert('RGB')).astype(int)
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    magenta = (r > 160) & (b > 150) & (g < 140) & (r - g > 50) & (b - g > 40)
    out = np.dstack([a, np.where(magenta, 0, 255)]).astype('uint8')
    return Image.fromarray(out, 'RGBA')


def cover_to_mask(brut, mask_alpha):
    """Recale le brut (RGBA détouré) sur la silhouette Spinda (masque 600x448)."""
    a = np.array(brut)
    ys, xs = np.where(a[..., 3] > 0)
    bx0, bx1, by0, by1 = xs.min(), xs.max() + 1, ys.min(), ys.max() + 1
    crop = brut.crop((bx0, by0, bx1, by1))
    ys, xs = np.where(mask_alpha > 0)
    mx0, mx1, my0, my1 = xs.min(), xs.max() + 1, ys.min(), ys.max() + 1
    mw, mh = mx1 - mx0, my1 - my0
    scale = max(mw / crop.width, mh / crop.height) * 1.03
    resized = crop.resize((round(crop.width * scale), round(crop.height * scale)),
                          Image.Resampling.LANCZOS)
    canvas = Image.new('RGBA', (W, H))
    canvas.alpha_composite(resized, (mx0 + (mw - resized.width) // 2,
                                     my0 + (mh - resized.height) // 2))
    ca = np.array(canvas)
    # comble les éventuels trous intérieurs au masque par le plus proche opaque
    hole = (mask_alpha > 0) & (ca[..., 3] == 0)
    if hole.any():
        _, inds = nd.distance_transform_edt(ca[..., 3] == 0, return_indices=True)
        ca[hole] = ca[tuple(i[hole] for i in inds)]
    ca[..., 3] = mask_alpha
    return Image.fromarray(ca, 'RGBA')


def purge_magenta(im):
    """Remplace toute couleur encore magenta dans le masque par le plus proche donneur."""
    a = np.array(im).astype(int)
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    magentaish = (a[..., 3] > 0) & (r > 110) & (r - g > 45) & (b - g > 30)
    if not magentaish.any():
        return im
    donor = (a[..., 3] > 0) & ~magentaish
    _, inds = nd.distance_transform_edt(~donor, return_indices=True)
    a[magentaish] = a[tuple(i[magentaish] for i in inds)]
    return Image.fromarray(a.astype('uint8'), 'RGBA')


def clean_fringe(im):
    a = np.array(im).astype(int)
    alpha = a[..., 3] > 0
    dist = nd.distance_transform_edt(alpha)
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    purple = alpha & (b >= g) & (r > g + 10)
    fringe = purple & (dist <= 3)
    donor_ok = alpha & (b < g) & (dist >= 1)
    _, inds = nd.distance_transform_edt(~donor_ok, return_indices=True)
    out = a.copy()
    out[fringe] = a[tuple(i[fringe] for i in inds)]
    # anneau externe : recolore dist==1 depuis dist>=2 non pourpre
    ring = alpha & (dist == 1)
    donor2 = alpha & (dist >= 2) & (b < g)
    _, inds2 = nd.distance_transform_edt(~donor2, return_indices=True)
    out[ring] = out[tuple(i[ring] for i in inds2)]
    out[..., 3] = a[..., 3]
    res = Image.fromarray(out.astype('uint8'), 'RGBA')
    ra = np.array(res).astype(int)
    rd = nd.distance_transform_edt(ra[..., 3] > 0)
    resid = int(((ra[..., 2] >= ra[..., 1]) & (ra[..., 0] > ra[..., 1] + 10)
                 & (ra[..., 3] > 0) & (rd <= 3)).sum())
    return res, resid


def encode_tile(path, tiles, cols=48):
    """tiles: liste d'images RGBA 8x8. Format .tile PMDO (inverse du décodeur)."""
    rows = (len(tiles) + cols - 1) // cols
    blobs = []
    for t in tiles:
        buf = io.BytesIO(); t.save(buf, 'PNG'); blobs.append(buf.getvalue())
    header = struct.pack('<ii', 8, len(tiles))
    entry_size = 16
    off = len(header) + entry_size * len(tiles)
    entries, data = [], []
    for i, blob in enumerate(blobs):
        entries.append(struct.pack('<iiq', i % cols, i // cols, off))
        data.append(struct.pack('<q', len(blob)) + blob)
        off += 8 + len(blob)
    path.write_bytes(header + b''.join(entries) + b''.join(data))
    return cols, rows


def build_ground(rid, im, ref_ground):
    a = np.array(im)
    tiles, index = [], {}
    grid = [[None] * TH for _ in range(TW)]
    for cx in range(TW):
        for cy in range(TH):
            cell = a[cy * 8:(cy + 1) * 8, cx * 8:(cx + 1) * 8]
            if (cell[..., 3] > 0).mean() < 0.4:
                continue
            tile = Image.fromarray(cell, 'RGBA')
            key = tile.tobytes()
            if key not in index:
                index[key] = len(tiles); tiles.append(tile)
            grid[cx][cy] = index[key]
    sheet = f'MetanoGen_{rid}'
    (OUT / 'tilesheets').mkdir(parents=True, exist_ok=True)
    cols, rows = encode_tile(OUT / f'tilesheets/{sheet}.tile', tiles)
    obj = copy.deepcopy(ref_ground['Object'])
    obj['AssetName'] = f'metano_gen_{rid}'
    obj['Comment'] = ('Reseau Metano Normal genere (generateur reference Halcyon '
                      'Metano_Town_Normal_Home + formes Cafe Spinda), vide et large. '
                      'Non teste moteur.')
    for k in ('Entities', 'obstacles', 'Decorations'):
        if isinstance(obj.get(k), list):
            obj[k] = []
    tiles_json = []
    for cx in range(TW):
        col = []
        for cy in range(TH):
            idx = grid[cx][cy]
            if idx is None:
                col.append({'AutoTileset': '', 'Associates': [], 'Layers': [], 'NeighborCode': -1})
            else:
                col.append({'AutoTileset': '', 'Associates': [],
                            'Layers': [{'Frames': [{'Sheet': sheet,
                                                    'TexLoc': {'X': idx % cols, 'Y': idx // cols}}],
                                        'FrameLength': 60}],
                            'NeighborCode': -1})
        tiles_json.append(col)
    obj['Layers'] = [{'Name': 'Base', 'Layer': 0, 'Visible': True, 'Tiles': tiles_json}]
    ground = {'Version': ref_ground.get('Version', '0.8.12'), 'Object': obj}
    (OUT / 'grounds').mkdir(parents=True, exist_ok=True)
    (OUT / f'grounds/metano_gen_{rid}.rsground').write_text(
        json.dumps(ground, ensure_ascii=False), encoding='utf-8')
    return len(tiles)


def b64(im):
    buf = io.BytesIO(); im.save(buf, 'PNG')
    return 'data:image/png;base64,' + base64.b64encode(buf.getvalue()).decode()


def main():
    ref_ground = json.loads((REF / 'metano_normal_home.rsground').read_text(encoding='utf-8-sig'))
    for d in ('salles', 'apercus', 'grounds', 'tilesheets'):
        (OUT / d).mkdir(parents=True, exist_ok=True)
    manifest = {
        'lot': 'reseau_metano_normal_v1',
        'methode': 'generateur d images reference (rendu Halcyon metano_normal_home + salle '
                   'Cafe Spinda V7 correspondante pour la forme), detourage magenta, silhouette '
                   'recalee sur le masque Spinda, reduction 600x448, frange pourpre nettoyee.',
        'disposition': 'identique au reseau Cafe Spinda V7 (formes des salles Spinda conservees) : '
                       'accueil RDC escaliers N/S centres, cafe et salon_haut au +1, casino et '
                       'salon_bas au -1, salons a l est. Pieces larges et completement vides.',
        'texture': 'Metano_Town_Normal_Home (Halcyon), variante normale, via rendu de reference.',
        'liens': LINKS, 'rooms': [],
        'art_approved': False, 'runtime_tested': False, 'runtime_PMDO': 'NOT TESTED',
    }
    previews = {}
    for rid in ROOMS:
        spinda = Image.open(SPINDA / f'SpindaV7_{rid}_sans_magenta.png').convert('RGBA')
        mask = np.array(spinda.resize((W, H), Image.Resampling.NEAREST))[..., 3]
        brut = segment_magenta(Image.open(BRUTS / f'{rid}.png'))
        room = cover_to_mask(brut, mask)
        room = purge_magenta(room)
        room, resid = clean_fringe(room)
        a = np.array(room).astype(int)
        assert not ((a[..., 0] > 200) & (a[..., 1] < 80) & (a[..., 2] > 200) & (a[..., 3] > 0)).any(), rid
        assert (np.array(room)[..., 3] == mask).all(), (rid, 'silhouette != Spinda')
        room.save(OUT / f'salles/MetanoNormal_{rid}.png')
        bg = Image.new('RGBA', (W, H), NEUTRAL + (255,)); bg.alpha_composite(room)
        previews[rid] = bg.convert('RGB')
        previews[rid].save(OUT / f'apercus/MetanoNormal_{rid}_fond_neutre.png')
        ntiles = build_ground(rid, room, ref_ground)
        manifest['rooms'].append({'id': rid, 'etage': FLOORS[rid],
                                  'file': f'salles/MetanoNormal_{rid}.png',
                                  'ground': f'grounds/metano_gen_{rid}.rsground',
                                  'tileset': f'tilesheets/MetanoGen_{rid}.tile',
                                  'tuiles_uniques': ntiles, 'residu_pourpre_bord_px': resid,
                                  'acces': {k: (round(x * W / 600), round(y * H / 448)) for k, (x, y) in ACCESS[rid].items()}})
        print(rid, 'ok, tuiles:', ntiles, 'residu pourpre:', resid)
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=1), encoding='utf-8')

    cards = ''
    for floor, title in ((1, 'Étage +1'), (0, 'Rez-de-chaussée'), (-1, 'Étage −1')):
        rs = [r for r in manifest['rooms'] if r['etage'] == floor]
        cards += f'<h2>{title}</h2><div class="row">' + ''.join(
            f'<figure><img src="{b64(previews[r["id"]])}"><figcaption><b>{r["id"]}</b> — '
            + ', '.join(r['acces'].keys()) + '</figcaption></figure>' for r in rs) + '</div>'
    html = ('<!doctype html><html lang="fr"><meta charset="utf-8">'
            '<title>Réseau Métano Normal — formes Café Spinda</title>'
            '<style>body{font:16px system-ui;background:#241f1a;color:#efe6da;margin:0 auto;'
            'max-width:1500px;padding:24px}h1{font-size:30px}h2{margin-top:34px;color:#f1d69d}'
            '.row{display:flex;gap:20px;flex-wrap:wrap}figure{margin:0}img{width:600px;max-width:44vw;'
            'image-rendering:pixelated;background:#3a3028}figcaption{margin-top:6px;color:#cbb9a0}'
            'p{line-height:1.55;color:#d8c9b4}.tag{color:#f1d69d}</style>'
            '<h1>Réseau « Métano Normal » — formes du Café Spinda</h1>'
            '<p>Cinq pièces <b>larges et complètement vides</b>, générées avec le générateur '
            'd’images référencé sur <i>Metano_Town_Normal_Home</i> d’Halcyon (variante normale) '
            'et sur la salle Café Spinda V7 correspondante : la <span class="tag">silhouette de '
            'chaque pièce est exactement celle de Spinda</span> (accueil à escaliers nord/sud '
            'centrés, salons à l’est). Aucun mobilier. Exports PNG transparents + Grounds PMDO '
            'avec tilesets 8 px construits depuis les rendus. Warps/collisions non testés moteur.</p>'
            + cards + '</html>')
    (ROOT / 'apercu_reseau_metano_normal_v1.html').write_text(html, encoding='utf-8')
    print('liens:', LINKS)


if __name__ == '__main__':
    main()
