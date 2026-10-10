"""PPO1 — méthode « rendu généré référencé » sur fond magenta, multicalque.

Entrées :
- bruts/decor_magenta.png : rendu généré avec la capture PMD comme image de référence
  (images=[reference]), salle complète, hors salle en magenta (255,0,255).

Étapes (méthode du GUIDE, §3) :
1. détourage du magenta par rapport de canaux (r > 1,45 g et b > 1,45 g) ;
2. classification en pleine résolution : herbe, contour brun, reste (sol, murs, objets) ;
3. recadrage de la salle (boîte mesurée, marge magenta) puis réduction uniforme par classe,
   vote majoritaire par bloc, aucun mélange entre classes ;
4. palette commune de 96 couleurs (MEDIANCUT, sans tramage) ;
5. calques : 00_base, 01_herbe, 02_contour, Top vide, transparents hors salle.

Exécution : .venv/bin/python source/interieur_pelipper_v1/build_genere.py
"""
from pathlib import Path
import hashlib, json

from PIL import Image
import numpy as np

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
BRUT = R / 'renders' / 'interieur_pelipper_v1' / 'bruts' / 'decor_magenta.png'
REF = HERE / 'reference' / 'pelipper_post_office_interior_gba.png'
OUT = R / 'renders' / 'interieur_pelipper_v1' / 'genere'
PFX = 'PPO1'
W, H = 368, 296                          # taille native de la salle capturée (46 × 37 cases de 8 px)
BOITE_SALLE = (134, 37, 1079, 787)       # mesurée sur les pixels non magenta du rendu (x 134–1078, y 37–786)
MARGE_Y = 5                              # marge magenta pour atteindre le ratio 368:296
PALETTE = 96


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def classes(rgb):
    """Carte de classes plein format : 0 magenta, 1 herbe, 2 contour brun, 3 reste."""
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
    """Réduction uniforme par classe : moyenne des pixels de la classe gagnante dans chaque bloc."""
    x0, y0, x1, y1 = boite
    sub = rgb[y0:y1, x0:x1].astype(np.float64)
    c = cls[y0:y1, x0:x1]
    W_, H_ = taille
    fx, fy = sub.shape[1] / W_, sub.shape[0] / H_
    out = np.zeros((H_, W_, 3), np.float64)
    out_cls = np.zeros((H_, W_), np.uint8)
    out_alpha = np.zeros((H_, W_), np.uint8)
    for j in range(H_):
        ya, yb = int(round(j * fy)), int(round((j + 1) * fy))
        for i in range(W_):
            xa, xb = int(round(i * fx)), int(round((i + 1) * fx))
            bloc_c = c[ya:yb, xa:xb].ravel()
            n = bloc_c.size
            comptes = np.bincount(bloc_c, minlength=4)
            if comptes[0] * 2 > n:                 # majorité magenta : hors salle
                continue
            k = int(np.argmax(comptes[1:]) + 1)   # classe gagnante parmi 1..3
            m = bloc_c == k
            out[j, i] = sub[ya:yb, xa:xb].reshape(-1, 3)[m].mean(0)
            out_cls[j, i] = k
            out_alpha[j, i] = 255
    return out.round().astype(np.uint8), out_cls, out_alpha


def build():
    OUT.mkdir(parents=True, exist_ok=True)
    brut = np.array(Image.open(BRUT).convert('RGB'))
    x0, y0, x1, y1 = BOITE_SALLE
    y0 -= MARGE_Y; y1 += MARGE_Y
    cls_full = classes(brut)
    rgb_r, cls_r, alpha_r = reduit(brut, cls_full, (x0, y0, x1, y1), (W, H))

    # Palette commune : quantification des seules pixels opaques, puis rang par pixel
    opaque = alpha_r > 0
    im_op = Image.fromarray(rgb_r)
    q = im_op.quantize(colors=PALETTE, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    rgb_q = np.array(q.convert('RGB'))
    rgb_q[~opaque] = 0

    couches = {
        f'{PFX}_00_base.png': (cls_r == 3) & opaque,
        f'{PFX}_01_herbe.png': (cls_r == 1) & opaque,
        f'{PFX}_02_contour_brun.png': (cls_r == 2) & opaque,
    }
    assemblage = np.zeros((H, W, 4), np.uint8)
    for nom, m in couches.items():
        arr = np.zeros((H, W, 4), np.uint8)
        arr[m, :3] = rgb_q[m]
        arr[m, 3] = 255
        Image.fromarray(arr, 'RGBA').save(OUT / nom, optimize=True)
        assemblage[m] = arr[m]
    # Top vide, Layer=4 côté PMDO
    Image.new('RGBA', (W, H), (0, 0, 0, 0)).save(OUT / f'{PFX}_Top_vide.png')
    Image.fromarray(assemblage, 'RGBA').save(OUT / f'{PFX}_assemblage.png', optimize=True)

    # Fidélité : moyenne RGB des classes clés, sortie vs capture PMD (seuil ≈ 35)
    ref = np.array(Image.open(REF).convert('RGB')).astype(float)
    ref_herbe = ref[(ref[..., 1] > ref[..., 0]) & (ref[..., 1] > ref[..., 2])].mean(0)
    out_herbe = rgb_q[couches[f'{PFX}_01_herbe.png']].astype(float).mean(0)
    dist = float(np.linalg.norm(ref_herbe - out_herbe))

    man = {
        'projet': 'interieur_pelipper_v1', 'prefixe': PFX,
        'methode': 'rendu généré référencé (images=[capture PMD]), fond magenta, multicalque, réduction par classe',
        'brut': {'fichier': str(BRUT.relative_to(R)), 'sha256': sha(BRUT), 'taille_px': list(Image.open(BRUT).size)},
        'reference': {'fichier': str(REF.relative_to(R)), 'sha256': sha(REF)},
        'recadrage': {'boite_salle': list(BOITE_SALLE), 'marge_y': MARGE_Y, 'sortie_px': [W, H]},
        'palette': {'couleurs_max': PALETTE, 'methode': 'MEDIANCUT, sans tramage'},
        'calques': ['00_base', '01_herbe', '02_contour_brun', 'Top_vide'],
        'fidelite_herbe': {'distance': round(dist, 1), 'seuil': 35, 'ok': dist < 35},
        'art_approved': False, 'runtime_tested': False,
        'avertissement': 'Pixels générés, non natifs : ne pas présenter comme tuiles canoniques.',
    }
    (OUT / 'manifest.json').write_text(json.dumps(man, ensure_ascii=False, indent=2) + '\n')
    apercu(OUT / f'{PFX}_assemblage.png')
    return man


def apercu(png):
    import base64
    fond = Image.new('RGBA', (W, H), (40, 40, 60, 255))
    fond.alpha_composite(Image.open(png).convert('RGBA'))
    buf = Path(png).parent / '_tmp_apercu.png'
    fond.resize((W * 2, H * 2), Image.NEAREST).convert('RGB').save(buf)
    b64 = base64.b64encode(buf.read_bytes()).decode()
    buf.unlink()
    html = ('<!doctype html><meta charset="utf-8"><title>Aperçu PPO1 généré</title>'
            '<body style="background:#222;color:#eee;font-family:sans-serif">'
            '<h2>PPO1 — rendu généré référencé, fond magenta multicalque (aperçu ×2)</h2>'
            '<p>Pixels générés d’après la capture ; non natifs, non validés à l’import ni en jeu.</p>'
            f'<img src="data:image/png;base64,{b64}" style="image-rendering:pixelated"></body>')
    (Path(png).parent / 'apercu_interieur_pelipper_genere.html').write_text(html, encoding='utf-8')


if __name__ == '__main__':
    print(json.dumps(build()['fidelite_herbe'], ensure_ascii=False))
