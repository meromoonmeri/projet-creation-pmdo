"""Arène de Groudon magma V3 (AGM3) — AGM2 avec des colonnes de magma GÉNÉRÉES par le générateur d'images. 4:3.

Demande : « je veux que tu génères les colonnes de magma ». AGM1 et AGM2 sont gardées telles quelles.

- Tout le reste vient d'AGM2, sans changement : même brut (signe gravé à plat), même sol, même magma visqueux, même signe
  qui pulse, mêmes braises. Le build d'AGM2 est chargé et seules ses colonnes sont remplacées (module colonnes_generees.py).
- Colonnes : brut bruts/colonne_magenta.png, généré avec une découpe de lave de Dark_Crater_Pit_TDS.png (×2) en image.
  Premier essai (bruts/colonne_v0_fond_lave.png) rejeté : colonne rectiligne et fond de lave au lieu du magenta.
- 4 colonnes plus grandes qu'AGM2 (corps d'environ 58 et 88 px au lieu de 40 et 56), les deux de droite en miroir ; sommet jamais visible.
Lancer : .venv/bin/python source/arene_groudon_magma_v3/build.py
"""
from pathlib import Path
import hashlib, importlib.util, json, shutil

import numpy as np

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
LOT = 'arene_groudon_magma_v3'
PFX = 'AGM3'
NAMESPACE = 'arene_groudon_magma_v3'
ASSET = 'agm3_arene_groudon_magma'
OUT = R / 'renders' / LOT
STAGE = R / '.cache' / LOT / NAMESPACE
STYLE = 'source/arene_groudon_magma_v3/reference/Dark_Crater_Pit_lave_decoupe_x2.png'
COLS = [  # bouche (768 x 576), échelle du brut, miroir ; celles du fond plus petites (perspective)
    {'nom': 'gauche_fond', 'x': 26, 'y': 206, 'echelle': 0.20, 'miroir': False, 'decalage': 0, 'graine': 1},
    {'nom': 'gauche_devant', 'x': 90, 'y': 432, 'echelle': 0.30, 'miroir': False, 'decalage': 17, 'graine': 2},
    {'nom': 'droite_fond', 'x': 672, 'y': 202, 'echelle': 0.20, 'miroir': True, 'decalage': 29, 'graine': 3},
    {'nom': 'droite_devant', 'x': 736, 'y': 434, 'echelle': 0.30, 'miroir': True, 'decalage': 8, 'graine': 4}]


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


B2 = loadmod('agm2_build', R / 'source/arene_groudon_magma_v2/build.py')
CGG = loadmod('colonnes_generees', HERE / 'colonnes_generees.py')
for c in COLS:
    c['demi'] = int(round(CGG.prepare(c['echelle'], c['miroir'])['half']))


def build():
    for k, v in dict(PFX=PFX, NAMESPACE=NAMESPACE, ASSET=ASSET, OUT=OUT, STAGE=STAGE, HERE=HERE, CG=CGG, COLS=COLS).items():
        setattr(B2, k, v)
    B2.LOOP_TICKS = int(np.lcm.reduce([B2.MG.PHASES * B2.MG.TICKS, CGG.PHASES * CGG.TICKS, B2.SIGN_PHASES * B2.SIGN_TICKS,
                                       B2.EMBER_PHASES * B2.EMBER_TICKS]))
    gp = B2.GR.ground_project

    def ground_project(*a, **kw):
        kw.update(name='Arene de Groudon V3 - colonnes de magma generees (4:3)',
                  comment=('PMDO 0.8.12. Arene generee 4:3 (textures de la fosse de Dark Crater) ; magma visqueux, 4 colonnes de '
                           'magma generees qui montent et sortent par le haut de la carte, symbole de Groudon grave a plat qui pulse '
                           'sur le sol, braises. Arrivee au sud, boss sur le signe, heros au sud. Aucun warp.'),
                  mod_name='Arene de Groudon V3 (colonnes de magma generees) 4:3',
                  mod_desc=("Projet d'edition : arene generee au format 4:3 (ref. fosse de Dark Crater), colonnes de magma generees, "
                            "symbole de Groudon qui pulse a meme le sol, magma visqueux."))
        return gp(*a, **kw)
    B2.GR.ground_project = ground_project
    B2.build()
    M = json.loads((OUT / 'manifest.json').read_text())
    pal, outline = CGG.palette()
    M['lot'] = LOT
    M['remplace_sans_supprimer'] = ['arene_groudon_magma_v1', 'arene_groudon_magma_v2']
    M['demande'] = ["lance toi je veux que tu genere les colonne de magma etc et je veux une map style colonne lance ruin etc avec les "
                    "texture pmd"] + M['demande']
    M['choix_agent']['colonnes'] = ('4 colonnes GENEREES par le generateur d images (reference : lave de Dark_Crater_Pit_TDS.png), plus '
                                    'grandes qu AGM2, deux de chaque cote, celles de droite en miroir, decalees ; elles sortent par le haut')
    M['choix_agent']['reste'] = 'identique a AGM2 (brut, sol, magma visqueux, signe, braises) : seul le calque des colonnes change'
    for r in M['raw_inputs']:
        r['file'] = r['file'].replace(LOT, 'arene_groudon_magma_v2')
    M['raw_inputs'] += [
        {'file': f'source/{LOT}/bruts/colonne_v0_fond_lave.png', 'sha256': sha(HERE / 'bruts/colonne_v0_fond_lave.png'),
         'size': [672, 1584], 'images': [STYLE], 'utilise': False,
         'rejet': 'colonne rectiligne (bords droits) et fond de lave au lieu du magenta, sauf en bas'},
        {'file': f'source/{LOT}/bruts/colonne_magenta.png', 'sha256': sha(CGG.RAW), 'size': [848, 1264], 'images': [STYLE],
         'utilise': True, 'consigne': 'colonne geante de magma, organique, coupee par le bord haut, couronne d eclaboussures, fond magenta pur'}]
    M['method'] += ' ; colonnes : pixels generes (brut colonne_magenta.png), decoupes, reduits, raccordes et deplaces'
    M['colonnes'] = {
        'phases': CGG.PHASES, 'frame_length_ticks': CGG.TICKS, 'colonnes': COLS,
        'origine': 'pixels GENERES (source/arene_groudon_magma_v3/bruts/colonne_magenta.png) ; aucun pixel de colonne calcule',
        'palette': [list(map(int, c)) for c in pal], 'contour_index': outline,
        'corps': {'lignes_brut': [0, CGG.BODY_END], 'raccord': f'{int(CGG.SEAM * 100)} % de la bande fondus puis re-quantifies et recontoures',
                  'periodes': {str(c['echelle']): CGG.prepare(c['echelle'], c['miroir'])['P'] for c in COLS},
                  'montee': 'une periode par boucle, decalage(u) = P (u - 0,6 sin(4 pi u) / 4 pi) : deux poussees, jamais de recul'},
        'couronne': {'lignes_brut': [CGG.CROWN_TOP, 1264], 'bouche_brut': CGG.MOUTH_ROW, 'x_brut': list(CGG.CROWN_X),
                     'bouillonnement': 'tons clairs (rang >= 16) decales de round(1,6 sin(2 pi 2u - 0,18 r + 3 angle + g)) rangs, '
                                       'bornes a la moitie claire de la palette'},
        'gouttes': {'nombre_par_colonne': len(CGG.prepare(0.3, False)['drops']), 'vols_par_boucle': CGG.DROP_FLIGHTS,
                    'loi': 'parabole depuis la bouche, hauteur 40-130 px, seulement sur le lac visible'},
        'sommet': 'hors cadre : chaque colonne touche le bord haut (y = 0) a toutes les phases'}
    (OUT / 'manifest.json').write_text(json.dumps(M, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')


if __name__ == '__main__':
    build()
