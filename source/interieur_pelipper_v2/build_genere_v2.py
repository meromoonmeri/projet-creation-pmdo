"""PPO2 — intérieur Pelipper Post Office à la taille de la référence Halcyon/Palika.

Cible : Data/Ground/post_office.rsground (Palikadude/Halcyon, commit da6c2130d641507447e6386a5e47a296e8cb4c71),
grille de 16 × 13 tuiles de 24 px, soit 384 × 312 px (48 × 39 cases de 8 px). Mesuré dans le fichier :
le champ Layers[0].Tiles est une grille 16 × 13 et les obstacles couvrent 0–384 × 0–312.

Entrée : renders/interieur_pelipper_v2/bruts/decor_magenta_v2.png, rendu généré référencé à partir de la
capture PMD, salle sur magenta (255,0,255).

Méthode (GUIDE §3) : détourage par rapport de canaux, classification plein format (herbe, contour brun, reste),
salle réduite à facteur uniforme (1200 px → 384 px de large, hauteur 284) par vote majoritaire de classe,
centrée dans un canevas 384 × 312 avec marges transparentes, palette de 96 couleurs au plus.

Exécution : .venv/bin/python source/interieur_pelipper_v2/build_genere_v2.py
"""
from pathlib import Path
import base64, hashlib, json

from PIL import Image
import numpy as np

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
BRUT = R / 'renders' / 'interieur_pelipper_v2' / 'bruts' / 'decor_magenta_v2.png'
REF = HERE.parent / 'interieur_pelipper_v1' / 'reference' / 'pelipper_post_office_interior_gba.png'
OUT = R / 'renders' / 'interieur_pelipper_v2' / 'genere'
PFX = 'PPO2'
CANEVAS = (384, 312)                 # post_office.rsground : 16 × 13 tuiles de 24 px
SALLE = (384, 284)                   # salle réduite à facteur uniforme, centrée verticalement
MARGE_Y = (CANEVAS[1] - SALLE[1]) // 2   # 14 px transparents en haut et en bas
BOITE = (0, 7, 1200, 896)            # salle mesurée sur le brut : x 0–1199, y 7–895
PALETTE = 96


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def classes(rgb):
    """0 magenta, 1 herbe, 2 contour brun, 3 reste."""
    r, g, b = rgb[..., 0].astype(int), rgb[..., 1].astype(int), rgb[..., 2].astype(int)
    mag = (r > 1.45 * g) & (b > 1.45 * g)
    herbe = (g > r) & (g > b) & ~mag
    brun = (r > g) & (g > b) & (r < 170) & (g < 110) & ~mag & ~herbe
    cls = np.full(rgb.shape[:2], 3, np.uint8)
    cls[brun] = 2
    cls[herbe] = 1
    cls[mag] = 0
    return cls


def reduit(rgb, cls, boite, taille):
    x0, y0, x1, y1 = boite
    sub = rgb[y0:y1, x0:x1].astype(np.float64)
    c = cls[y0:y1, x0:x1]
    W_, H_ = taille
    fx, fy = sub.shape[1] / W_, sub.shape[0] / H_
    out = np.zeros((H_, W_, 3), np.float64)
    out_cls = np.zeros((H_, W_), np.uint8)
    alpha = np.zeros((H_, W_), np.uint8)
    for j in range(H_):
        ya, yb = int(round(j * fy)), int(round((j + 1) * fy))
        for i in range(W_):
            xa, xb = int(round(i * fx)), int(round((i + 1) * fx))
            bc = c[ya:yb, xa:xb].ravel()
            comptes = np.bincount(bc, minlength=4)
            if comptes[0] * 2 > bc.size:
                continue
            k = int(np.argmax(comptes[1:]) + 1)
            m = bc == k
            out[j, i] = sub[ya:yb, xa:xb].reshape(-1, 3)[m].mean(0)
            out_cls[j, i] = k
            alpha[j, i] = 255
    return out.round().astype(np.uint8), out_cls, alpha


def build():
    OUT.mkdir(parents=True, exist_ok=True)
    brut = np.array(Image.open(BRUT).convert('RGB'))
    cls_full = classes(brut)
    rgb_r, cls_r, alpha_r = reduit(brut, cls_full, BOITE, SALLE)

    # Canevas 384 × 312 : salle centrée, marges transparentes
    rgb_c = np.zeros((CANEVAS[1], CANEVAS[0], 3), np.uint8)
    cls_c = np.zeros(CANEVAS[::-1], np.uint8)
    alpha_c = np.zeros(CANEVAS[::-1], np.uint8)
    y = MARGE_Y
    rgb_c[y:y + SALLE[1]] = rgb_r
    cls_c[y:y + SALLE[1]] = cls_r
    alpha_c[y:y + SALLE[1]] = alpha_r

    opaque = alpha_c > 0
    q = Image.fromarray(rgb_c).quantize(colors=PALETTE, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    rgb_q = np.array(q.convert('RGB'))
    rgb_q[~opaque] = 0

    couches = {
        f'{PFX}_00_base.png': (cls_c == 3) & opaque,
        f'{PFX}_01_herbe.png': (cls_c == 1) & opaque,
        f'{PFX}_02_contour_brun.png': (cls_c == 2) & opaque,
    }
    asm = np.zeros((CANEVAS[1], CANEVAS[0], 4), np.uint8)
    for nom, m in couches.items():
        arr = np.zeros((CANEVAS[1], CANEVAS[0], 4), np.uint8)
        arr[m, :3] = rgb_q[m]
        arr[m, 3] = 255
        Image.fromarray(arr, 'RGBA').save(OUT / nom, optimize=True)
        asm[m] = arr[m]
    Image.new('RGBA', CANEVAS, (0, 0, 0, 0)).save(OUT / f'{PFX}_Top_vide.png')
    Image.fromarray(asm, 'RGBA').save(OUT / f'{PFX}_assemblage.png', optimize=True)

    ref = np.array(Image.open(REF).convert('RGB')).astype(float)
    ref_herbe = ref[(ref[..., 1] > ref[..., 0]) & (ref[..., 1] > ref[..., 2])].mean(0)
    out_herbe = rgb_q[couches[f'{PFX}_01_herbe.png']].astype(float).mean(0)
    dist = float(np.linalg.norm(ref_herbe - out_herbe))

    man = {
        'projet': 'interieur_pelipper_v2', 'prefixe': PFX,
        'methode': 'rendu généré référencé (images=[capture PMD]) puis réduction uniforme par classe, multicalque',
        'cible_taille': {
            'source': 'Palikadude/Halcyon, Data/Ground/post_office.rsground, commit da6c2130d641507447e6386a5e47a296e8cb4c71',
            'grille_tuiles': [16, 13], 'taille_tuile_px': 24, 'canevas_px': list(CANEVAS), 'cases_8px': [48, 39],
            'verification': 'Layers[0].Tiles = 16 × 13 ; obstacles couvrent 0–384 × 0–312',
        },
        'brut': {'fichier': str(BRUT.relative_to(R)), 'sha256': sha(BRUT), 'taille_px': list(Image.open(BRUT).size)},
        'reference': {'fichier': str(REF.relative_to(R)), 'sha256': sha(REF)},
        'salle': {'boite_brut': list(BOITE), 'taille_px': list(SALLE), 'marge_y_px': MARGE_Y,
                  'facteur': [round(1200 / SALLE[0], 4), round((BOITE[3] - BOITE[1]) / SALLE[1], 4)]},
        'palette': {'couleurs_max': PALETTE, 'methode': 'MEDIANCUT, sans tramage'},
        'calques': ['00_base', '01_herbe', '02_contour_brun', 'Top_vide'],
        'fidelite_herbe': {'distance': round(dist, 1), 'seuil': 35, 'ok': dist < 35},
        'art_approved': False, 'runtime_tested': False,
        'avertissement': 'Pixels générés, non natifs : ne pas présenter comme tuiles canoniques. Taille = cible Halcyon, pas un test moteur.',
    }
    (OUT / 'manifest.json').write_text(json.dumps(man, ensure_ascii=False, indent=2) + '\n')
    apercu(OUT / f'{PFX}_assemblage.png')
    return man


def apercu(png):
    fond = Image.new('RGBA', CANEVAS, (40, 40, 60, 255))
    fond.alpha_composite(Image.open(png).convert('RGBA'))
    tmp = Path(png).parent / '_tmp.png'
    fond.resize((CANEVAS[0] * 2, CANEVAS[1] * 2), Image.NEAREST).convert('RGB').save(tmp)
    b64 = base64.b64encode(tmp.read_bytes()).decode()
    tmp.unlink()
    html = ('<!doctype html><meta charset="utf-8"><title>Aperçu PPO2</title>'
            '<body style="background:#222;color:#eee;font-family:sans-serif">'
            '<h2>PPO2 — Pelipper Post Office, taille Halcyon 384 × 312 (aperçu ×2)</h2>'
            '<p>Rendu généré référencé, multicalque. Pixels générés, non natifs, non validés en jeu.</p>'
            f'<img src="data:image/png;base64,{b64}" style="image-rendering:pixelated"></body>')
    (Path(png).parent / 'apercu_interieur_pelipper_v2.html').write_text(html, encoding='utf-8')


if __name__ == '__main__':
    print(json.dumps(build()['fidelite_herbe'], ensure_ascii=False))
