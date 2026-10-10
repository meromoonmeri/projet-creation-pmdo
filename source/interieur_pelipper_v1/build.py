"""Intérieur « Pelipper Post Office » (PPO1) — capture GBA recadrée, sans rééchantillonnage.

Méthode : la capture est un rendu 1× du jeu (Pokémon Mystery Dungeon : Red Rescue Team).
La salle est recadrée exactement sur la grille 8 px. Rien n'est redessiné, recoloré,
rééchelonné ni généré. Ce n'est donc PAS un rendu généré et PAS une extraction de tuiles
natives : c'est une composition unique, aplatie, sans calques séparés.

Exécution : .venv/bin/python source/interieur_pelipper_v1/build.py
"""
from pathlib import Path
import base64, hashlib, json

from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
SRC = HERE / 'reference' / 'pelipper_post_office_interior_gba.png'
OUT = R / 'renders' / 'interieur_pelipper_v1'
PFX = 'PPO1'

# Boîte de la salle dans la capture (gauche, haut, droite, bas), mesurée sur les pixels :
# bord du cadre sombre (60,60,90) en x=0..7 et y=0..7, mur inférieur qui se termine à y=303.
BOITE = (8, 8, 376, 304)
TAILLE_CASE = 8
FOND_CADRE = (60, 60, 90)


def sha256(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def mesure_salle(im):
    """Retrouve la boîte à partir des pixels, pour contrôler BOITE."""
    rgb = im.convert('RGB')
    w, h = rgb.size
    px = rgb.load()
    # Zone de la salle : tout pixel différent du cadre, au-dessus de la bande de sprites (y < 304).
    xs, ys = [], []
    for y in range(0, 304):
        for x in range(w):
            r, g, b = px[x, y]
            if abs(r - FOND_CADRE[0]) + abs(g - FOND_CADRE[1]) + abs(b - FOND_CADRE[2]) > 40:
                xs.append(x); ys.append(y)
    return min(xs), min(ys), max(xs) + 1, max(ys) + 1


def build():
    OUT.mkdir(parents=True, exist_ok=True)
    src = Image.open(SRC)
    if src.size != (384, 400):
        raise SystemExit(f'capture inattendue : {src.size}')
    trouve = mesure_salle(src)
    # La boîte mesurée (8,8,376,303) reste à l'intérieur de BOITE (8,8,376,304) : BOITE est retenue.
    if not (trouve[0] == BOITE[0] and trouve[1] == BOITE[1] and trouve[2] == BOITE[2] and trouve[3] <= BOITE[3]):
        raise SystemExit(f'boîte mesurée {trouve} ≠ attendue {BOITE}')
    salle = src.crop(BOITE).convert('RGBA')
    w, h = salle.size
    assert w % TAILLE_CASE == 0 and h % TAILLE_CASE == 0, (w, h)

    nom = f'{PFX}_00_salle_complete.png'
    salle.save(OUT / nom, optimize=True)

    aperçu = OUT / f'{PFX}_apercu_x2_non_destine_au_jeu.png'
    salle.resize((w * 2, h * 2), Image.NEAREST).save(aperçu, optimize=True)   # aperçu seul, jamais importé

    manifeste = {
        'projet': 'interieur_pelipper_v1',
        'prefixe': PFX,
        'methode': 'capture 1x recadrée, sans rééchantillonnage ni recoloration',
        'source': {
            'fichier': str(SRC.relative_to(R)),
            'sha256': sha256(SRC),
            'taille_px': list(src.size),
            'jeu': 'Pokémon Mystery Dungeon : Red Rescue Team (GBA)',
            'titre_capture': 'Pelipper Post Office Interior',
            'source_publique': 'capture fournie par l’utilisateur ; bande de sprites et légende exclues',
        },
        'recadrage': {'boite': list(BOITE), 'mesuree': list(trouve), 'taille_px': [w, h],
                      'taille_cases': [w // TAILLE_CASE, h // TAILLE_CASE], 'grille_px': TAILLE_CASE},
        'sorties': {nom: {'taille_px': [w, h], 'sha256': sha256(OUT / nom), 'calques': 'aplati, un seul calque'}},
        'exclus': ['bande de 7 sprites (y 300–343)', 'légende (y 352–391)'],
        'calques': {'separes': False, 'raison': 'capture aplatie : sols, murs et objets ne sont pas séparables sans redessin'},
        'marqueurs': 'non posés : entrée et objectifs à confirmer sur la salle',
        'collisions': 'non posées : aucune collision n’est déduite de l’image',
        'animations': 'aucune ; la bande de sprites n’est pas un décor de salle',
        'art_approved': False,
        'runtime_tested': False,
        'ground_pmdo': 'non produit dans ce lot',
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifeste, ensure_ascii=False, indent=2) + '\n')
    return OUT / nom, aperçu


def apercu_html(png, aperçu):
    b64 = base64.b64encode(Path(aperçu).read_bytes()).decode()
    html = (f'<!doctype html><meta charset="utf-8"><title>Aperçu PPO1</title>'
            f'<body style="background:#222;color:#eee;font-family:sans-serif">'
            f'<h2>PPO1 — Intérieur Pelipper Post Office (capture 1×, aperçu ×2)</h2>'
            f'<p>Capture du jeu recadrée sur la grille 8 px. Aucune retouche. Aperçu seul, non intégré au mod.</p>'
            f'<img src="data:image/png;base64,{b64}" style="image-rendering:pixelated"></body>')
    (png.parent / f'apercu_interieur_pelipper_v1.html').write_text(html, encoding='utf-8')


if __name__ == '__main__':
    png, ap = build()
    apercu_html(png, ap)
    print(png)
