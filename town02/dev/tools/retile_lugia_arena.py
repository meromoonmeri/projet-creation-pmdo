#!/usr/bin/env python3
"""Retile l'arene de combat Lugia (celestial_peak_boss.rsmap) avec le tileset
Friend Area FA_Rainbow_Peak_RTRB (24px, deja importe, usage prevu par la curation).

Principe (ajout intelligent, geometrie INCHANGEE) :
- terrain IDs (floor/unbreakable), EntryPoints, MapTeams, Status : non touches
- floor      -> mer de nuages (variantes de tuiles nuage plates)
- unbreakable-> ciel bleu (l'arene flotte : lisibilite walkable/non-walkable)
- accents    : mini arcs-en-ciel (2 tuiles) sur les bandes murales haut/bas,
               a distance de la bordure jouable pour ne pas tromper le joueur
- BlankBG    -> tuile ciel du meme tileset (remplace l'autotile concealed_ruins_wall)

Coherence : la cinematique pre-boss (autel_celeste, pmd-red 1:1) se joue dans le
ciel avec le fond anime "Sky" ; le combat encha ine desormais dans le meme registre
visuel (sommet irise au-dessus de la mer de nuages) au lieu de ruines grises.
"""
import json, io, os

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RSMAP = os.path.join(REPO, 'Data', 'Map', 'celestial_peak_boss.rsmap')
SHEET = 'FA_Rainbow_Peak_RTRB'

# Tuiles source (coordonnees dans la feuille 19x13, 24px)
SKY = (1, 0)
CLOUDS = [(4, 7), (14, 7), (0, 4), (18, 4), (1, 8), (17, 8), (5, 10), (13, 10)]
# Mini arcs-en-ciel horizontaux (2 tuiles chacun)
ARC_L = [(2, 4), (3, 4)]
ARC_R = [(15, 4), (16, 4)]

# Emplacements des accents sur la carte 15x18 (bandes murales, y=1 et y=16)
ACCENTS = {
    (3, 1): ARC_L[0], (4, 1): ARC_L[1],
    (10, 1): ARC_R[0], (11, 1): ARC_R[1],
    (3, 16): ARC_R[0], (4, 16): ARC_R[1],
    (10, 16): ARC_L[0], (11, 16): ARC_L[1],
}


def tex(loc):
    return {
        "AutoTileset": "",
        "Associates": [],
        "Layers": [{
            "Frames": [{"Sheet": SHEET, "TexLoc": {"X": loc[0], "Y": loc[1]}}],
            "FrameLength": 60,
        }],
        "NeighborCode": -1,
    }


def main():
    with open(RSMAP, encoding='utf-8-sig') as f:
        doc = json.load(f)
    o = doc['Object']
    tiles = o['Tiles']
    W, H = len(tiles), len(tiles[0])
    assert (W, H) == (15, 18), f"geometrie inattendue {W}x{H}"

    n_floor = n_wall = 0
    for x in range(W):
        for y in range(H):
            cell = tiles[x][y]['Data']
            tid = cell['ID']
            if (x, y) in ACCENTS:
                cell['TileTex'] = tex(ACCENTS[(x, y)])
            elif tid == 'floor':
                cell['TileTex'] = tex(CLOUDS[(x * 7 + y * 13) % len(CLOUDS)])
                n_floor += 1
            else:
                cell['TileTex'] = tex(SKY)
                n_wall += 1
            cell['StableTex'] = False

    # BlankBG : ciel (remplace l'autotile concealed_ruins_wall)
    o['BlankBG'] = tex(SKY)

    with io.open(RSMAP, 'w', encoding='utf-8-sig') as f:
        json.dump(doc, f, indent=2, ensure_ascii=False)
    print(f"OK: {n_floor} floor->nuages, {n_wall} murs->ciel, "
          f"{len(ACCENTS)} accents arc-en-ciel, BlankBG->ciel")


if __name__ == '__main__':
    main()
