#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""png2tileset.py — convertit une image PNG en tileset RogueEssence/PMDO.

    python3 tools/png2tileset.py decoupe  <image.png> [--tile 24] [--grid 8]
    python3 tools/png2tileset.py importer <image.png> <NomPlanche> [options]
    python3 tools/png2tileset.py carte    <image.png> <NomPlanche> <sortie.rsmap> [options]
    python3 tools/png2tileset.py ground   <image.png> <NomPlanche> <sortie.rsground> [options]
    python3 tools/png2tileset.py verifier <NomPlanche>

Options communes :
    --tile N      taille de tuile en px      (defaut 24 = tuile de donjon)
    --grid N      pas de grille du ground    (defaut 8, seulement pour `ground`)
    --align X,Y   decalage du decoupage      (defaut 0,0)
    --seuil N     % d'opacite mini pour qu'une tuile soit gardee (defaut 1)
    --sol "a,b"   couleurs RGB du sol marchable, pour `carte`
    --apply       ecrit reellement (sinon simple essai a blanc)

--------------------------------------------------------------------------
CE QUE LE FORMAT EXIGE — verifie dans le moteur, pas suppose
--------------------------------------------------------------------------
1) STRUCTURE DU .tile  (RogueEssence/Content/TileSheet.cs + BaseSheet.cs)
       uint32  tileSize
       uint32  tileCount
       tileCount x ( uint64 key = x | (y << 32) , uint64 offset absolu )
       a chaque offset :  int64 longueur  +  octets PNG
   Les tuiles identiques PARTAGENT le meme offset : la deduplication est
   native au format, pas une optimisation de mon cru. Verifie sur
   Metano_Town_Base (35646 entrees pour un nombre d'images bien moindre).

2) ALPHA PREMULTIPLIE — le piege principal.
   `BaseSheet.ImportTex` (l.188-192) applique premultiply(tex, false) a
   l'import, et `BaseSheet.Load` (l.63-73) ne l'applique PAS. Les octets
   stockes dans un .tile sont donc DEJA premultiplies.
   Mesure de confirmation sur Metano_Town_Objects : 45760 pixels
   d'alpha 0 testes, 0 avec un RGB non nul ; et tous les pixels d'alpha
   partiel respectent RGB <= A. C'est la signature du premultiplie.
   Consequence : ecrire un PNG standard (alpha droit) donnerait des
   halos clairs sur tous les bords transparents. L'outil premultiplie
   donc a l'ecriture, et de-premultiplie a la relecture.

3) index.idx  (RogueEssence/Content/TileIndex.cs, TileGuide.Load)
       uint32 nbPlanches
       par planche : nom en chaine C# 7-bit-encoded, uint32 tileSize,
                     uint32 nbTuiles, puis nbTuiles x (int32 x, int32 y,
                     int64 position)
   GraphicsManager.GetTile lit la position DANS cet index : une planche
   absente de l'index renvoie 0 -> tuile d'erreur affichee. On regenere
   donc l'index apres toute ecriture, via tools/rebuild_tile_index.py
   dont la non-regression est verifiee (il reproduit l'index d'origine
   octet pour octet).

4) TAILLES DE TUILE
   Ground  : la grille vaut 8 * TexSize px (GroundMap.TileSize).
   Donjon  : GraphicsManager.TileSize, 24 px dans ce projet.
   Une carte de combat batie sur des tuiles de 8 px ne s'afficherait pas
   correctement : l'outil refuse la combinaison et le dit.
"""
import argparse
import copy
import io
import json
import os
import struct
import sys
from collections import Counter

from PIL import Image
import numpy as np

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TILEDIR = os.path.join(ROOT, 'Content', 'Tile')


# ---------------------------------------------------------------- alpha
def premultiplier(im):
    """PNG standard -> octets tels que le moteur les attend."""
    a = np.asarray(im.convert('RGBA')).astype(np.uint16)
    al = a[:, :, 3]
    out = a.copy()
    for c in range(3):
        out[:, :, c] = (a[:, :, c] * al) // 255
    return Image.fromarray(out.astype(np.uint8), 'RGBA')


def depremultiplier(im):
    """Octets du moteur -> PNG standard, pour relecture/apercu."""
    a = np.asarray(im.convert('RGBA')).astype(np.uint16)
    al = a[:, :, 3]
    out = a.copy()
    nz = al > 0
    for c in range(3):
        ch = out[:, :, c]
        ch[nz] = np.minimum(a[:, :, c][nz] * 255 // al[nz], 255)
    return Image.fromarray(out.astype(np.uint8), 'RGBA')


# ------------------------------------------------------------- lecture
def lire_planche(nom, brut=False):
    """Retourne (tileSize, {(x,y): Image}).

    brut=False : images en alpha DROIT (pour affichage / edition).
    brut=True  : images telles qu'elles sont stockees, donc PREMULTIPLIEES.

    Le mode brut existe pour une raison precise. La de-premultiplication
    n'est PAS reversible sans perte : elle divise par l'alpha, et sur un
    alpha faible l'erreur d'arrondi explose. Mesure sur
    Metano_Town_Objects, pixel (1,2) de la tuile (161,2) :
        stocke (191,127,63, a=4)  ->  droit (255,255,255)  [sature]
                                  ->  restocke (4,4,3)     [perdu]
    soit 127/255 d'ecart sur un simple aller-retour.
    Pour COPIER ou RE-EMPAQUETER une planche existante sans l'abimer, il
    faut donc repartir des octets d'origine : c'est ce que fait brut=True,
    couple a ecrire_planche(..., deja_premultiplie=True).
    """
    with open(os.path.join(TILEDIR, nom + '.tile'), 'rb') as f:
        raw = f.read()
    ts, cnt = struct.unpack_from('<II', raw, 0)
    cells = {}
    for i in range(cnt):
        key, off = struct.unpack_from('<QQ', raw, 8 + i * 16)
        x, y = key & 0xFFFFFFFF, key >> 32
        if (x, y) in cells:
            continue
        ln = struct.unpack_from('<q', raw, off)[0]
        im = Image.open(io.BytesIO(raw[off + 8: off + 8 + ln])).convert('RGBA')
        cells[(x, y)] = im if brut else depremultiplier(im)
    return ts, cells


# ------------------------------------------------------------ ecriture
def ecrire_planche(nom, tile_size, grille, deja_premultiplie=False):
    """Ecrit un .tile dedupe.

    grille : {(x,y): Image}.
      deja_premultiplie=False -> images en alpha droit (cas normal :
        on importe un PNG produit par un graphiste). L'outil applique
        la premultiplication attendue par le moteur.
      deja_premultiplie=True  -> images deja au format moteur (cas d'une
        copie de planche existante lue avec brut=True). Aucune conversion,
        donc aucune perte.
    """
    keys = sorted(grille, key=lambda k: (k[1], k[0]))
    png_de = {}
    for k in keys:
        im = grille[k] if deja_premultiplie else premultiplier(grille[k])
        buf = io.BytesIO()
        im.save(buf, format='PNG')
        png_de[k] = buf.getvalue()

    encode, ordre = {}, []
    for k in keys:
        png = png_de[k]
        if png not in encode:
            encode[png] = None
            ordre.append(png)
    off = 8 + len(keys) * 16
    for png in ordre:
        encode[png] = off
        off += 8 + len(png)

    out = bytearray()
    out += struct.pack('<II', tile_size, len(keys))
    for k in keys:
        out += struct.pack('<QQ', k[0] | (k[1] << 32), encode[png_de[k]])
    for png in ordre:
        out += struct.pack('<q', len(png)) + png
    path = os.path.join(TILEDIR, nom + '.tile')
    with open(path, 'wb') as f:
        f.write(bytes(out))
    return path, len(keys), len(ordre), len(out)


# -------------------------------------------------------------- decoupe
def decouper(path, tile, ax=0, ay=0, seuil=1):
    """Decoupe l'image en tuiles. Retourne (grille, stats)."""
    im = Image.open(path).convert('RGBA')
    W, H = im.size
    nx = (W - ax) // tile
    ny = (H - ay) // tile
    reste = ((W - ax) % tile, (H - ay) % tile)
    grille = {}
    vides = 0
    for gx in range(nx):
        for gy in range(ny):
            box = (ax + gx * tile, ay + gy * tile,
                   ax + (gx + 1) * tile, ay + (gy + 1) * tile)
            t = im.crop(box)
            al = np.asarray(t)[:, :, 3]
            if (al > 0).mean() * 100 < seuil:
                vides += 1
                continue
            grille[(gx, gy)] = t
    stats = dict(taille=(W, H), grille=(nx, ny), reste=reste,
                 gardees=len(grille), vides=vides)
    return grille, stats


def dedup_stats(grille):
    sig = Counter()
    for im in grille.values():
        sig[im.tobytes()] += 1
    return len(sig)


# -------------------------------------------------------- construction
def tuile_vide():
    return {'AutoTileset': '', 'Associates': [], 'Layers': [],
            'NeighborCode': -1}


# ------------------------------------------------------- animation
def tuile_anim(sheets, x, y, framelen=10):
    """Cellule animee : une planche par frame, memes coordonnees.

    C'est le patron NATIF du moteur, releve tel quel sur la riviere de
    metano_town.rsground :
        Frames = [ {Sheet: Metano_Town_River_Animation_1, TexLoc:(45,186)},
                   {Sheet: ..._2, TexLoc:(45,186)}, ... ]
        FrameLength = 10
    Le mod compte deja 8273 cellules construites ainsi. On ne cree donc
    aucun mecanisme : on remplit le meme moule.
    """
    return {'AutoTileset': '', 'Associates': [], 'NeighborCode': -1,
            'Layers': [{'Frames': [{'Sheet': s, 'TexLoc': {'X': x, 'Y': y}}
                                   for s in sheets],
                        'FrameLength': framelen}]}


def _otsu(lum):
    """Seuil de separation automatique entre deux modes de luminance.

    Methode d'Otsu : on cherche le seuil qui maximise la variance ENTRE
    les deux groupes. Aucun reglage a la main, et le seuil s'adapte a la
    palette de l'image — c'est ce qui permet de traiter aussi bien un
    decor vert (Aegis Cave) qu'une arene grise (Tornadus).
    """
    hist, _ = np.histogram(lum, bins=256, range=(0, 256))
    tot = lum.size
    sT = (np.arange(256) * hist).sum()
    sB = 0.0
    wB = 0
    best = (0.0, 128)
    for t in range(256):
        wB += hist[t]
        if wB == 0:
            continue
        wF = tot - wB
        if wF == 0:
            break
        sB += t * hist[t]
        mB = sB / wB
        mF = (sT - sB) / wF
        v = wB * wF * (mB - mF) ** 2
        if v > best[0]:
            best = (v, t)
    return best[1]


def collisions(src, nuage, pas, seuil=0.45, amas=3, verbeux=True,
               mode='auto'):
    """Deduit la grille de collisions par LOGIQUE SPATIALE.

    ----------------------------------------------------------------
    DEUX PALETTES, DEUX STRATEGIES — et le choix est automatique
    ----------------------------------------------------------------
    Les decors du projet ne se ressemblent pas, et un seul jeu de seuils
    ne peut pas les couvrir. Mesure comparee :

      Aegis Cave (ile verte)      Tornadus (cime grise)
        herbe    (207,186, 97)        plateforme (132,139,142) sat 10
        falaise  (173,148, 77)        roche      ( 59, 68, 76) sat 17
        arbre    (144,106, 47)        ciel       (204,223,248) sat 44

    Sur Aegis Cave la TEINTE porte l'information (vert = vegetation,
    beige = roche). Sur Tornadus tout est gris : la teinte ne dit plus
    rien, mais l'histogramme de luminance est franchement BIMODAL —
    657 127 px de plateforme claire (128-143) contre ~680 000 px de
    roche sombre (32-111). C'est la LUMINANCE qui porte l'information.

    Le mode 'auto' mesure la saturation moyenne de l'image et choisit :
      - image coloree  -> mode 'teinte'    (feuillage + roche beige)
      - image grise    -> mode 'luminance' (seuil d'Otsu)

    ----------------------------------------------------------------
    MODE 'teinte' (decors colores)
    ----------------------------------------------------------------
    1. VIDE       ciel/nuages : B-R > 25, ou blanc sature.
    2. FEUILLAGE  vert ET sombre (G > R+8, G > B+20, luminance < 110).
                  L'herbe est verte aussi, mais claire : c'est la
                  luminance qui separe l'arbre de la pelouse.
    3. ROCHE      beige desature, canal BLEU haut (118..187) alors que
                  le sol jaune-vert l'a bas (59..98).

    ----------------------------------------------------------------
    MODE 'luminance' (decors gris)
    ----------------------------------------------------------------
    Seuil d'Otsu sur la luminance : au-dessus = surface praticable,
    en dessous = roche, ombre, vide. Le ciel est retire a part (il est
    clair, donc au-dessus du seuil, mais reste infranchissable).

    ----------------------------------------------------------------
    PUIS ON RAISONNE EN CELLULES, PAS EN PIXELS
    ----------------------------------------------------------------
    Le moteur ne connait que des cellules. On calcule la FRACTION
    d'obstacle par cellule et on bloque au-dela de `seuil`, puis on
    supprime les amas de moins de `amas` cellules : un obstacle isole
    d'une seule case au milieu d'une esplanade est du bruit de texture,
    pas un rocher (~500 fausses collisions retirees sur Aegis Cave).

    Retourne (bloque, stats) ; `bloque` est indexe [y][x].
    """
    a = np.asarray(src.convert('RGB')).astype(int)
    R, G, B = a[:, :, 0], a[:, :, 1], a[:, :, 2]
    lum = a.mean(axis=2)
    sat = a.max(axis=2) - a.min(axis=2)

    if mode == 'auto':
        # DESERT OCRE — 3e palette, ajoutee pour le camp des Ruines v2.
        # Ni 'teinte' ni 'luminance' ne conviennent quand le sol ET la
        # roche sont ocres. Mesures sur cette carte :
        #     sable  (231,182,128)  G-B = 54   lum 167..192
        #     roche  (150,115, 90)  G-B = 24   lum 111..161
        # La luminance seule echoue (roche a 161 > sable a 167, 6 d'ecart)
        # et la teinte seule echoue (tout est beige, aucun vert).
        # C'est l'ECART G-B qui separe net : 54 contre 24, sans recouvrement.
        # Accord mesure contre le masque valide a l'oeil sur l'apercu :
        #     teinte 18.8%   luminance 84.9%   desert 99.0%
        gb_moy = float((G - B).mean())
        if sat.mean() >= 60 and gb_moy >= 35 and float(lum.mean()) >= 120:
            mode = 'desert'
        else:
            mode = 'luminance' if sat.mean() < 35 else 'teinte'
        if verbeux:
            print(f'  palette : saturation moyenne {sat.mean():.0f}, '
                  f'G-B moyen {gb_moy:.0f} -> mode {mode.upper()}')

    vide = ((B - R > 25) & (B > 150)) | ((R > 225) & (G > 225) & (B > 225))
    vide |= nuage

    if mode == 'desert':
        # Praticable = sable : chaud (G-B eleve) ET clair.
        # Tout le reste — roche, eboulis, bouche de grotte, verdure des
        # corniches — est un obstacle. Conforme a la regle du projet :
        # en cas de doute, la collision par defaut est SOLIDE.
        sable = ((G - B) >= 40) & (lum >= 150)
        praticable = sable & (~vide)
        obstacle = (~praticable) & (~vide)
        feuillage = np.zeros_like(vide)
        roche = obstacle
        if verbeux:
            print(f'  mode desert -> {int(praticable.sum())} px de sol '
                  f'praticable ({100 * praticable.mean():.0f}%)')
    elif mode == 'luminance':
        t = _otsu(lum)
        # le ciel est clair : il passerait le seuil, on l'exclut a part
        praticable = (lum >= t) & (~vide)
        obstacle = ~praticable & ~vide
        feuillage = np.zeros_like(vide)
        roche = obstacle
        if verbeux:
            print(f'  seuil Otsu {t} -> {int(praticable.sum())} px praticables')
    else:
        vert = (G > R + 8) & (G > B + 20)
        feuillage = vert & (lum < 110)
        roche = (~vide) & (~vert) & (B > 100) & (R > B) & (R - B < 130)
        obstacle = feuillage | roche

    H, W = lum.shape
    ny, nx = H // pas, W // pas

    def frac(m):
        return m[:ny*pas, :nx*pas].reshape(ny, pas, nx, pas).mean(axis=(1, 3))
    f_obs, f_vide = frac(obstacle), frac(vide)

    bloque = (f_obs >= seuil) | (f_vide > 0.55)
    brut = int(bloque.sum())

    try:
        from scipy import ndimage
        lab, n = ndimage.label(bloque)
        tailles = ndimage.sum(bloque, lab, range(1, n + 1))
        garde = np.zeros_like(bloque)
        for i, t2 in enumerate(tailles, 1):
            if t2 >= amas:
                garde[lab == i] = True
        bloque = garde | (f_vide > 0.55)
    except ImportError:
        if verbeux:
            print('  (scipy absent : nettoyage des amas isoles ignore)')

    st = dict(nx=nx, ny=ny, brut=brut, final=int(bloque.sum()),
              feuillage=int(feuillage.sum()), roche=int(roche.sum()),
              vide=int(vide.sum()), mode=mode)
    if verbeux:
        tot = nx * ny
        print(f'  feuillage {st["feuillage"]:7d} px | roche {st["roche"]:7d} px'
              f' | vide {st["vide"]:7d} px')
        print(f'  cellules bloquees : {brut} -> {st["final"]} apres nettoyage'
              f' des amas < {amas} ({100*st["final"]//tot}% de la carte)')
    return bloque, st


def degager_entites(obj, bloque, pas, verbeux=True):
    """Recale les entites tombees sur une cellule bloquee.

    Necessaire parce que les collisions sont calculees APRES le
    repositionnement : une entite peut atterrir sur un arbre ou un rocher
    que l'ancienne carte n'avait pas. Constate sur Aegis Cave, le
    spawner TEAMMATE_2 se retrouvait dans un massif d'arbres.

    On cherche la cellule libre la plus proche, en spirale. Une entite
    injoignable, c'est un equipier qui n'apparait pas ou une porte de
    donjon qu'on ne peut plus franchir : ca ne peut pas rester.
    """
    ny, nx = bloque.shape
    deplacees = 0
    for e in (obj.get('Entities') or []):
        for cle in ('MapChars', 'GroundObjects', 'Markers', 'Spawners'):
            for o in (e.get(cle) or []):
                c = o.get('Collider')
                if not c:
                    continue
                cx, cy = c['X'] // pas, c['Y'] // pas
                if not (0 <= cx < nx and 0 <= cy < ny) or not bloque[cy][cx]:
                    continue
                # On exige une cellule libre ENTOUREE de cellules libres :
                # un personnage occupe une boite d'environ 20 px, donc une
                # case isolee entre deux rochers ne suffit pas. Sans ce
                # voisinage, TEAMMATE_2 se posait sur une cellule libre
                # dont les quatre voisines etaient bloquees, et le controle
                # final le signalait encore comme « dans un mur ».
                def degage(n):
                    for ddx in (-1, 0, 1):
                        for ddy in (-1, 0, 1):
                            m = (n[0] + ddx, n[1] + ddy)
                            if not (0 <= m[0] < nx and 0 <= m[1] < ny):
                                return False
                            if bloque[m[1]][m[0]]:
                                return False
                    return True

                trouve = None
                for r in range(1, 40):
                    cands = []
                    for dx in range(-r, r + 1):
                        cands += [(cx + dx, cy - r), (cx + dx, cy + r)]
                    for dy in range(-r + 1, r):
                        cands += [(cx - r, cy + dy), (cx + r, cy + dy)]
                    for n in cands:
                        if (0 <= n[0] < nx and 0 <= n[1] < ny and degage(n)):
                            trouve = n
                            break
                    if trouve:
                        break
                if trouve:
                    ax, ay = c['X'], c['Y']
                    c['X'], c['Y'] = trouve[0] * pas, trouve[1] * pas
                    if o.get('serializationLoc'):
                        o['serializationLoc'] = {'X': c['X'], 'Y': c['Y']}
                    deplacees += 1
                    if verbeux:
                        print(f"    {o.get('EntName','?'):24s} etait dans un "
                              f"obstacle ({ax},{ay}) -> ({c['X']},{c['Y']})")
    if verbeux and not deplacees:
        print('    aucune entite dans un obstacle')
    return deplacees


def _connexite(bloque, depart, cible=None):
    """Combien de cellules libres sont atteignables depuis `depart` ?"""
    from collections import deque
    ny, nx = bloque.shape
    if bloque[depart[1], depart[0]]:
        return 0, False, int((~bloque).sum())
    seen = {depart}
    q = deque([depart])
    while q:
        x, y = q.popleft()
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            n = (x + dx, y + dy)
            if (0 <= n[0] < nx and 0 <= n[1] < ny and n not in seen
                    and not bloque[n[1], n[0]]):
                seen.add(n)
                q.append(n)
    return len(seen), (cible in seen if cible else True), int((~bloque).sum())
    """Regroupe les pixels d'un masque en blocs connexes (4-voisinage).

    Sert a distinguer une CASCADE — un bloc compact, haut et etroit,
    pose sur la falaise — du CIEL, qui est un immense bloc unique
    couvrant tout le pourtour de l'image. Les deux ont la meme couleur ;
    seule la FORME les separe.
    """
    from collections import deque
    vu = np.zeros(masque.shape, bool)
    ys, xs = np.nonzero(masque)
    blocs = []
    for y0, x0 in zip(ys, xs):
        if vu[y0, x0]:
            continue
        q = deque([(y0, x0)])
        vu[y0, x0] = True
        pts = []
        while q:
            y, x = q.popleft()
            pts.append((y, x))
            for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                ny, nx = y + dy, x + dx
                if (0 <= ny < masque.shape[0] and 0 <= nx < masque.shape[1]
                        and not vu[ny, nx] and masque[ny, nx]):
                    vu[ny, nx] = True
                    q.append((ny, nx))
        if len(pts) >= mini:
            blocs.append(pts)
    return blocs


def _composantes(masque, mini=200):
    """Regroupe les pixels d'un masque en blocs connexes (4-voisinage).

    Sert a distinguer une CASCADE — un bloc compact, haut et etroit,
    pose sur la falaise — du CIEL, qui est un immense bloc unique
    couvrant tout le pourtour de l'image. Les deux ont la meme couleur ;
    seule la FORME les separe.
    """
    from collections import deque
    vu = np.zeros(masque.shape, bool)
    ys, xs = np.nonzero(masque)
    blocs = []
    for y0, x0 in zip(ys, xs):
        if vu[y0, x0]:
            continue
        q = deque([(y0, x0)])
        vu[y0, x0] = True
        pts = []
        while q:
            y, x = q.popleft()
            pts.append((y, x))
            for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                ny, nx = y + dy, x + dx
                if (0 <= ny < masque.shape[0] and 0 <= nx < masque.shape[1]
                        and not vu[ny, nx] and masque[ny, nx]):
                    vu[ny, nx] = True
                    q.append((ny, nx))
        if len(pts) >= mini:
            blocs.append(pts)
    return blocs


def _masques(im, verbeux=False):
    """Isole les CASCADES et les NUAGES, chacun avec sa methode.

    Le piege, mesure sur l'image de Aegis Cave : cascade et ciel ont la
    MEME signature bleue.
        cascade (43,97,181) (81,160,236)   ciel (191,211,239)
    Un simple seuil `B - R > 70` marquait donc tout le pourtour du ciel
    comme « eau qui tombe » — 106 831 px au lieu des quelques milliers
    attendus (verifie visuellement : le masque debordait sur tout le
    fond). Deux criteres supplementaires sont necessaires :

      CASCADE  bleu sature ET bloc connexe PLUS HAUT QUE LARGE
               (une chute d'eau est verticale ; le ciel, lui, forme un
               unique bloc large de toute l'image).
      NUAGE    tres clair ET faible saturation, restreint aux blocs
               qui ne sont pas la voute de ciel elle-meme.
    """
    a = np.asarray(im.convert('RGB')).astype(int)
    R, G, B = a[:, :, 0], a[:, :, 1], a[:, :, 2]
    H, W = R.shape

    bleu = (B - R > 70) & (B > 150)
    cascade = np.zeros_like(bleu)
    for pts in _composantes(bleu, mini=300):
        ys = [p[0] for p in pts]
        xs = [p[1] for p in pts]
        h = max(ys) - min(ys) + 1
        w = max(xs) - min(xs) + 1
        # Une chute d'eau : nettement plus haute que large, etroite, ET
        # DETACHEE DES BORDS. Ce dernier critere elimine les langues de
        # ciel qui longent le cadre : sur Aegis Cave, sept blocs
        # verticaux touchaient x=0 ou x=W-1 et passaient les deux premiers
        # tests. Une cascade nait d'une falaise, au milieu de l'image ;
        # elle ne peut pas etre collee au bord.
        touche_bord = min(xs) <= 1 or max(xs) >= W - 2
        if h > w * 1.6 and w < W * 0.12 and not touche_bord:
            for y, x in pts:
                cascade[y, x] = True
            if verbeux:
                print(f'    cascade retenue : x {min(xs)}..{max(xs)} '
                      f'y {min(ys)}..{max(ys)} ({w}x{h})')
        elif verbeux and len(pts) > 5000:
            print(f'    bloc bleu ECARTE (ciel) : {w}x{h}, {len(pts)} px')

    nuage = (R > 200) & (G > 205) & (B > 215) & (B - R < 60)
    return cascade, nuage


def animer_zone(im, masque, frames, dx, dy):
    """Retourne `frames` images : le contenu du masque DEFILE de (dx,dy)
    par frame, le reste ne bouge pas.

    Le defilement est CYCLIQUE sur la hauteur (ou la largeur) de la zone
    masquee : a la derniere frame, le motif est revenu a sa place, donc
    la boucle est invisible. C'est ce qui rend le mouvement « discret »
    plutot que saccade.
    """
    base = np.asarray(im.convert('RGBA')).copy()
    out = []
    for i in range(frames):
        f = base.copy()
        if dy:
            # decalage vertical cyclique, applique colonne par colonne
            src = np.roll(base, (dy * i) % max(1, base.shape[0]), axis=0)
        else:
            src = base
        if dx:
            src = np.roll(src, (dx * i) % max(1, base.shape[1]), axis=1)
        f[masque] = src[masque]
        out.append(Image.fromarray(f, 'RGBA'))
    return out


def tuile_ref(sheet, x, y, framelen=60):
    return {'AutoTileset': '', 'Associates': [], 'NeighborCode': -1,
            'Layers': [{'Frames': [{'Sheet': sheet,
                                    'TexLoc': {'X': x, 'Y': y}}],
                        'FrameLength': framelen}]}


def gabarit_rsmap():
    """Clone une carte de combat existante pour heriter des 37 champs."""
    src = os.path.join(ROOT, 'Data', 'Map', 'montagne_traitresse_fond.rsmap')
    with open(src, encoding='utf-8-sig') as f:
        return json.load(f)


def gabarit_rsground(source=None):
    """Gabarit de ground.

    `source` permet de repartir d'un ground EXISTANT plutot que du
    gabarit neutre : on herite alors de ses entites (marqueurs
    d'entree, spawners d'equipiers, objets scriptes comme la porte de
    donjon ou le rocher de Kangaskhan). Sans cela, remplacer un decor
    reviendrait a casser tous les scripts qui le referencent.
    """
    src = os.path.join(ROOT, 'Data', 'Ground',
                       (source or 'guild_heros_room') + '.rsground')
    with open(src, encoding='utf-8-sig') as f:
        return json.load(f)


def _replacer_entites(obj, W, H, ancien_w, ancien_h, verbeux=True):
    """Remet les entites heritees a l'interieur des nouvelles limites.

    Une entite posee hors carte est invisible et injoignable : le joueur
    ne peut plus entrer dans le donjon, ou l'equipier n'apparait pas.
    On applique donc une mise a l'echelle proportionnelle, puis on
    clampe dans la carte avec une marge d'une tuile.
    """
    if not obj.get('Entities'):
        return
    sx = W / max(1, ancien_w)
    sy = H / max(1, ancien_h)
    for e in obj['Entities']:
        for cle in ('MapChars', 'GroundObjects', 'Markers', 'Spawners'):
            for o in (e.get(cle) or []):
                c = o.get('Collider')
                if not c:
                    continue
                ax, ay = c['X'], c['Y']
                c['X'] = int(min(max(ax * sx, 8), W - c.get('Width', 16) - 8))
                c['Y'] = int(min(max(ay * sy, 8), H - c.get('Height', 16) - 8))
                if 'serializationLoc' in o and o['serializationLoc']:
                    o['serializationLoc'] = {'X': c['X'], 'Y': c['Y']}
                if verbeux:
                    print(f"    {o.get('EntName','?'):24s} "
                          f"({ax},{ay}) -> ({c['X']},{c['Y']})")


def _profil(im):
    """(luminance moyenne, saturation moyenne) des pixels opaques."""
    a = np.asarray(im.convert('RGBA')).astype(float)
    m = a[:, :, 3] > 128
    if not m.sum():
        return 0.0, 0.0
    rgb = a[:, :, :3][m]
    return float(rgb.mean()), float((rgb.max(axis=1) - rgb.min(axis=1)).mean())


def couleurs_sol(grille, seuil_pct=55, echantillon=None, tol_lum=28,
                 tol_sat=14):
    """Classe chaque tuile en SOL ou MUR.

    DEUX MODES, et le second est presque toujours le bon.

    1) Sans --sol : heuristique de luminance. Les tuiles les plus claires
       sont supposees etre le sol. Rapide, mais elle se trompe des que
       l'image contient un ciel clair ou des nuages : sur l'arene de
       Tornadus elle classait le ciel ET les corniches en terrain
       marchable (mesure : ciel lum 225 > plateforme lum 138).

    2) Avec --sol X,Y : on echantillonne la tuile qui contient ce pixel
       et on retient toutes les tuiles de meme PROFIL (luminance ET
       saturation proches). C'est ce qui separe proprement la roche du
       ciel : sur cette arene, sol = lum 138 / sat 10, ciel = lum 225 /
       sat 44. La saturation seule suffit a trancher.
    """
    prof = {k: _profil(im) for k, im in grille.items()}
    if not prof:
        return set()

    if echantillon is not None:
        lum0, sat0 = echantillon
        return {k for k, (l, s) in prof.items()
                if abs(l - lum0) <= tol_lum and abs(s - sat0) <= tol_sat}

    vals = sorted(l for l, _ in prof.values())
    seuil = vals[int(len(vals) * seuil_pct / 100)]
    return {k for k, (l, _) in prof.items() if l >= seuil}


# ------------------------------------------------------------ commandes
def cmd_decoupe(a):
    grille, st = decouper(a.image, a.tile, *map(int, a.align.split(',')),
                          seuil=a.seuil)
    print(f"image        : {st['taille'][0]}x{st['taille'][1]} px")
    print(f"tuile        : {a.tile} px")
    print(f"grille       : {st['grille'][0]} x {st['grille'][1]} tuiles")
    if st['reste'] != (0, 0):
        print(f"  ATTENTION  : reste {st['reste'][0]}x{st['reste'][1]} px "
              f"non couverts (l'image n'est pas un multiple de {a.tile}).")
        print(f"               ces pixels seront IGNORES. Recadrez l'image ou")
        print(f"               ajustez --align pour choisir ou tombe la coupe.")
    print(f"tuiles gardees : {st['gardees']}  (vides ignorees : {st['vides']})")
    print(f"tuiles uniques : {dedup_stats(grille)}  "
          f"-> deduplication native du format")


def cmd_importer(a):
    grille, st = decouper(a.image, a.tile, *map(int, a.align.split(',')),
                          seuil=a.seuil)
    if not grille:
        print('ABANDON : aucune tuile opaque trouvee.')
        return 1
    print(f"{st['grille'][0]}x{st['grille'][1]} tuiles de {a.tile} px, "
          f"{st['gardees']} gardees, {dedup_stats(grille)} uniques")
    if st['reste'] != (0, 0):
        print(f"  ATTENTION : {st['reste']} px non couverts, ignores.")
    if not a.apply:
        print('(essai a blanc ; --apply pour ecrire)')
        return 0
    path, nk, nu, sz = ecrire_planche(a.nom, a.tile, grille)
    print(f'ecrit {path}\n  {nk} entrees, {nu} images uniques, {sz} octets')
    reindexer()
    verifier(a.nom, grille, a.tile)
    return 0


def reindexer():
    import subprocess
    r = subprocess.run([sys.executable,
                        os.path.join(ROOT, 'tools', 'rebuild_tile_index.py')],
                       cwd=ROOT, capture_output=True, text=True)
    print('  index :', (r.stdout or r.stderr).strip().splitlines()[-1])


def verifier(nom, attendu=None, tile=None):
    """Relit la planche ecrite et la compare a la source."""
    ts, cells = lire_planche(nom)
    ok = True
    if tile is not None and ts != tile:
        print(f'  ECHEC : tileSize relu {ts}, attendu {tile}')
        ok = False
    if attendu is not None:
        diff = 0
        for k, im in attendu.items():
            if k not in cells:
                diff += 1
                continue
            a = np.asarray(im.convert('RGBA')).astype(int)
            b = np.asarray(cells[k].convert('RGBA')).astype(int)
            # tolerance 1/255 : le premultiplie est une division entiere
            if np.abs(a - b).max() > 2:
                diff += 1
        print(f'  relecture : {len(cells)} tuiles, {diff} ecarts > 2/255')
        ok = ok and diff == 0
    print('  VERIFICATION :', 'OK' if ok else 'ECHEC')
    return ok


def cmd_verifier(a):
    ts, cells = lire_planche(a.nom)
    print(f'{a.nom} : tuile {ts} px, {len(cells)} cellules')
    xs = [k[0] for k in cells]
    ys = [k[1] for k in cells]
    print(f'  grille {max(xs)+1} x {max(ys)+1}')
    # apercu
    W = (max(xs) + 1) * ts
    H = (max(ys) + 1) * ts
    ap = Image.new('RGBA', (W, H), (25, 25, 35, 255))
    for (x, y), im in cells.items():
        ap.alpha_composite(im, (x * ts, y * ts))
    out = os.path.join(ROOT, 'docs', 'renders', f'tileset_{a.nom}.png')
    os.makedirs(os.path.dirname(out), exist_ok=True)
    ap.save(out)
    print('  apercu ->', out)


def _echantillon_sol(a, grille, tile, align):
    """Convertit --sol X,Y (pixel image) en profil (lum, sat) de sa tuile."""
    if not a.sol:
        return None
    ax, ay = map(int, align.split(','))
    px, py = map(int, a.sol.split(','))
    k = ((px - ax) // tile, (py - ay) // tile)
    if k not in grille:
        print(f'  ATTENTION : le pixel --sol {a.sol} tombe sur la tuile {k}, '
              f'qui est vide. Heuristique de luminance utilisee a la place.')
        return None
    lum, sat = _profil(grille[k])
    print(f'  echantillon sol : tuile {k}, luminance {lum:.0f}, '
          f'saturation {sat:.0f}')
    return lum, sat


def cmd_carte(a):
    tile = a.tile
    if tile != 24:
        print(f'  NOTE : une carte de COMBAT se dessine en tuiles de 24 px '
              f'(GraphicsManager.TileSize). Vous demandez {tile}.')
        if not a.force:
            print('  ABANDON (--force pour passer outre).')
            return 1
    grille, st = decouper(a.image, tile, *map(int, a.align.split(',')),
                          seuil=a.seuil)
    nx, ny = st['grille']
    if not grille:
        print('ABANDON : aucune tuile.')
        return 1
    ech = _echantillon_sol(a, grille, tile, a.align)
    sol = couleurs_sol(grille, a.solpct, ech)
    print(f'grille {nx}x{ny} | {len(grille)} tuiles | '
          f'{len(sol)} classees SOL, {len(grille)-len(sol)} MUR')

    doc = gabarit_rsmap()
    obj = doc['Object']
    proto = copy.deepcopy(obj['Tiles'][0][0])

    def mk(idv, x, y):
        t = copy.deepcopy(proto)
        t['Data']['ID'] = idv
        t['Data']['TileTex'] = tuile_vide()
        t['Effect']['TileLoc'] = {'X': x, 'Y': y}
        return t

    obj['Tiles'] = [[mk('floor' if (x, y) in sol else 'unbreakable', x, y)
                     for y in range(ny)] for x in range(nx)]
    couche = {'Name': 'Base', 'Layer': 0, 'Visible': True,
              'Tiles': [[tuile_ref(a.nom, x, y) if (x, y) in grille
                         else tuile_vide() for y in range(ny)]
                        for x in range(nx)]}
    obj['Layers'] = [couche]
    obj['AssetName'] = os.path.splitext(os.path.basename(a.sortie))[0]
    obj['Name'] = {'DefaultText': a.nom.replace('_', ' '), 'LocalTexts': {}}
    obj['MapTeams'] = []
    obj['AllyTeams'] = []
    obj['BlankBG'] = tuile_vide()

    if not a.apply:
        print('(essai a blanc ; --apply pour ecrire)')
        return 0
    ecrire_planche(a.nom, tile, grille)
    reindexer()
    dst = a.sortie if os.path.isabs(a.sortie) \
        else os.path.join(ROOT, 'Data', 'Map', os.path.basename(a.sortie))
    with open(dst, 'w', encoding='utf-8') as f:
        json.dump(doc, f, ensure_ascii=False, indent=2)
    print('ecrit', dst)
    verifier(a.nom, grille, tile)
    return 0


def cmd_anime(a):
    """Ground avec nuages et cascades animes.

    STRUCTURE PRODUITE — trois couches, et une seule est animee :
      'Base'     tout le decor fixe                       (1 frame)
      'Anim'     uniquement les cellules qui contiennent
                 du nuage ou de la cascade                (N frames)
    Les cellules fixes ne sont PAS dupliquees dans les planches d'anim :
    seules celles qui bougent le sont. Sur Aegis Cave cela represente
    une fraction des tuiles, pas les 8000 de la carte.

    VITESSES : les nuages derivent lentement a l'horizontale, l'eau tombe
    a la verticale plus vite. Deux couches distinctes seraient necessaires
    pour deux cadences differentes ; on les regroupe ici sur une cadence
    commune en jouant sur l'AMPLITUDE du decalage (1 px/frame pour les
    nuages, 3 px/frame pour l'eau), ce qui donne deux vitesses apparentes
    tout en gardant une seule couche animee.
    """
    pas = a.grid
    if 8 * (pas // 8) != pas:
        print("  ABANDON : le pas de grille d'un ground vaut 8 * TexSize.")
        return 1
    src = Image.open(a.image).convert('RGBA')
    W, H = src.size
    nx, ny = (W - 0) // pas, (H - 0) // pas
    if W % pas or H % pas:
        print(f'  ATTENTION : image {W}x{H}, residu {W % pas}x{H % pas} px '
              f'ignore. Recadrez au multiple de {pas}.')

    ecran_w, ecran_h = 320, 240
    if nx * pas < ecran_w or ny * pas < ecran_h:
        print(f'  ABANDON : la carte ferait {nx*pas}x{ny*pas} px, plus petite '
              f'que l ecran ({ecran_w}x{ecran_h}). Le moteur centrerait la '
              f'carte et laisserait du VIDE sur les cotes.')
        return 1

    cascade, nuage = _masques(src)
    print(f'image {W}x{H} -> {nx}x{ny} cellules de {pas} px')
    print(f'  cascade : {int(cascade.sum()):7d} px')
    print(f'  nuages  : {int(nuage.sum()):7d} px')

    NF = a.frames
    # deux vitesses, une seule cadence
    fr_casc = animer_zone(src, cascade, NF, 0, a.vit_eau)
    fr_nuag = animer_zone(src, nuage, NF, a.vit_nuage, 0)
    frames_img = []
    for i in range(NF):
        f = np.asarray(fr_casc[i]).copy()
        f[nuage] = np.asarray(fr_nuag[i])[nuage]
        frames_img.append(Image.fromarray(f, 'RGBA'))

    # quelles cellules bougent ?
    bouge = set()
    m_any = cascade | nuage
    for gx in range(nx):
        for gy in range(ny):
            if m_any[gy*pas:(gy+1)*pas, gx*pas:(gx+1)*pas].any():
                bouge.add((gx, gy))
    print(f'  cellules animees : {len(bouge)} / {nx*ny}')

    # --- planches -----------------------------------------------------
    base_grille = {}
    for gx in range(nx):
        for gy in range(ny):
            if (gx, gy) in bouge:
                continue
            base_grille[(gx, gy)] = src.crop((gx*pas, gy*pas,
                                              (gx+1)*pas, (gy+1)*pas))
    anim_grilles = []
    for i in range(NF):
        g = {}
        for (gx, gy) in bouge:
            g[(gx, gy)] = frames_img[i].crop((gx*pas, gy*pas,
                                              (gx+1)*pas, (gy+1)*pas))
        anim_grilles.append(g)

    if not a.apply:
        print('(essai a blanc ; --apply pour ecrire)')
        return 0

    nom_base = a.nom + '_Base'
    ecrire_planche(nom_base, pas, base_grille)
    noms_anim = []
    for i, g in enumerate(anim_grilles):
        n = f'{a.nom}_Anim_{i+1}'
        ecrire_planche(n, pas, g)
        noms_anim.append(n)
    reindexer()

    # --- ground -------------------------------------------------------
    # On repart du ground EXISTANT s'il est indique (--herite) : ses
    # entites (marqueur d'entree, spawners, porte de donjon...) sont
    # conservees et repositionnees, sinon tous les scripts qui les
    # referencent casseraient.
    doc = gabarit_rsground(a.herite)
    obj = doc['Object']
    anc_w = len(obj['obstacles']) * 8 * obj.get('TexSize', 1)
    anc_h = len(obj['obstacles'][0]) * 8 * obj.get('TexSize', 1)
    obj['TexSize'] = pas // 8
    couche_base = [[tuile_ref(nom_base, x, y) if (x, y) in base_grille
                    else tuile_vide() for y in range(ny)] for x in range(nx)]
    couche_anim = [[tuile_anim(noms_anim, x, y, a.framelen)
                    if (x, y) in bouge else tuile_vide()
                    for y in range(ny)] for x in range(nx)]
    obj['Layers'] = [
        {'Name': 'Base', 'Layer': 0, 'Visible': True, 'Tiles': couche_base},
        {'Name': 'Anim', 'Layer': 0, 'Visible': True, 'Tiles': couche_anim},
    ]
    # PAS DE BANDE NOIRE : Clamp bride la camera aux bords de la carte.
    # ScrollEdge.Blank (0) afficherait le vide ; Clamp (1) est la valeur
    # employee par 232 des 276 grounds du mod.
    obj['EdgeView'] = 1
    # --- COLLISIONS : par logique spatiale (voir collisions()) --------
    bloque, cst = collisions(src, nuage, pas, a.seuil_obs, a.amas)
    proto_ob = obj['obstacles'][0][0]
    obj['obstacles'] = [[{**copy.deepcopy(proto_ob),
                          'Tags': 1 if bloque[y][x] else 0}
                         for y in range(ny)] for x in range(nx)]

    # CONTROLE DE JOUABILITE : une grille de collisions n'a de valeur que
    # si la carte reste traversable. On part du marqueur d'entree et on
    # verifie que le reste du sol est bien atteignable.
    dep = None
    for e in (obj.get('Entities') or []):
        for m in (e.get('Markers') or []):
            if m.get('EntName') == 'Main_Entrance_Marker' and m.get('Collider'):
                dep = (m['Collider']['X'] // pas, m['Collider']['Y'] // pas)
    if dep and 0 <= dep[0] < nx and 0 <= dep[1] < ny:
        att, _, libre = _connexite(bloque, dep)
        pct = 100 * att // max(1, libre)
        print(f'  jouabilite : {att}/{libre} cellules libres atteignables '
              f'depuis l entree ({pct}%)')
        if pct < 80:
            print('    ATTENTION : la carte est morcelee. Baissez --seuil-obs '
                  'ou augmentez --amas.')
    obj['AssetName'] = os.path.splitext(os.path.basename(a.sortie))[0]
    if a.herite:
        print('  entites heritees, repositionnees :')
        _replacer_entites(obj, nx * pas, ny * pas, anc_w, anc_h)
        # Les collisions viennent d'etre calculees : une entite peut
        # desormais tomber sur un arbre ou un rocher que l'ancienne carte
        # ignorait. On la degage.
        print('  controle des entites vs obstacles :')
        degager_entites(obj, bloque, pas)
    dst = a.sortie if os.path.isabs(a.sortie) \
        else os.path.join(ROOT, 'Data', 'Ground', os.path.basename(a.sortie))
    with open(dst, 'w', encoding='utf-8') as f:
        json.dump(doc, f, ensure_ascii=False, indent=2)
    print('ecrit', dst)
    print(f'  {nx*pas}x{ny*pas} px, EdgeView=Clamp -> aucune bande noire')
    verifier(nom_base, base_grille, pas)
    return 0


def composante_du_sol(sol, ancre_px, pas):
    """Ne garde que la poche de sol qui CONTIENT le pixel echantillon.

    Pourquoi : `couleurs_sol` classe par couleur, sans notion de
    voisinage. Sur un decor de ciel (Sky Tower), les nuages blancs du
    fond ont exactement la teinte du plateau praticable — mesure sur
    Sky_Tower_entrance : plateau (215,255,255), nuage du ciel
    (255,255,255). Aucun seuil de luminance ne les separe.

    Mais ils ne se TOUCHENT pas. Un simple remplissage par diffusion
    depuis le pixel donne a --sol elimine les 111 cellules de ciel
    faussement marchables, sans toucher au plateau.

    A n'utiliser que sur un decor dont le sol est d'un seul tenant.
    """
    from collections import deque
    depart = (ancre_px[0] // pas, ancre_px[1] // pas)
    if depart not in sol:
        return sol
    vus = {depart}
    q = deque([depart])
    while q:
        x, y = q.popleft()
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            n = (x + dx, y + dy)
            if n in sol and n not in vus:
                vus.add(n)
                q.append(n)
    return vus


def cmd_ground(a):
    pas = a.grid
    if 8 * (pas // 8) != pas:
        print('  ABANDON : le pas de grille d\'un ground vaut 8 * TexSize.')
        return 1
    grille, st = decouper(a.image, pas, *map(int, a.align.split(',')),
                          seuil=a.seuil)
    nx, ny = st['grille']
    if not grille:
        print('ABANDON : aucune tuile.')
        return 1
    print(f'grille {nx}x{ny} cellules de {pas} px | {len(grille)} tuiles')

    doc = gabarit_rsground(getattr(a, 'herite', None))
    obj = doc['Object']
    ancien_w = len(obj['obstacles'])
    ancien_h = len(obj['obstacles'][0]) if ancien_w else 0
    # Pas de grille de l'ANCIEN ground : les colliders herites sont
    # exprimes dans son referentiel, pas dans le nouveau.
    pas_ancien = max(1, int(obj.get('TexSize') or 1)) * 8
    obj['TexSize'] = pas // 8
    obj['Layers'] = [{'Name': 'Base', 'Layer': 0, 'Visible': True,
                      'Tiles': [[tuile_ref(a.nom, x, y) if (x, y) in grille
                                 else tuile_vide() for y in range(ny)]
                                for x in range(nx)]}]
    ech = _echantillon_sol(a, grille, pas, a.align)
    sol = couleurs_sol(grille, a.solpct, ech)
    if getattr(a, 'solconnexe', False) and a.sol:
        ax, ay = map(int, a.sol.split(','))
        avant = len(sol)
        sol = composante_du_sol(set(sol), (ax, ay), pas)
        print(f'  sol connexe : {avant} -> {len(sol)} cellules '
              f'({avant - len(sol)} poches isolees ecartees)')
    proto_ob = obj['obstacles'][0][0]
    obj['obstacles'] = [[{**copy.deepcopy(proto_ob),
                          'Tags': 0 if (x, y) in sol else 1}
                         for y in range(ny)] for x in range(nx)]
    obj['AssetName'] = os.path.splitext(os.path.basename(a.sortie))[0]

    # Quand on herite d'un ground existant, ses entites sont posees dans
    # l'ANCIEN referentiel. Les laisser telles quelles, c'est produire
    # exactement le defaut qu'on cherche a corriger : des entites qui
    # ignorent le relief. On les remet a l'echelle, puis on les degage des
    # cellules devenues bloquantes.
    if getattr(a, 'herite', None) and ancien_w:
        # CORRECTIF 2026-08-02. _replacer_entites travaille en PIXELS :
        # elle compare des Collider (px) et clampe sur W - largeur - 8.
        # On lui passait ici des NOMBRES DE CELLULES (nx, ny), soit des
        # bornes 8 fois trop petites : toutes les entites se retrouvaient
        # ecrasees sur le meme coin de carte. Mesure avant correctif sur
        # celestial_peak_entrance : Main_Entrance_Marker, TEAMMATE_1,
        # TEAMMATE_2 et TEAMMATE_3 tous ramenes en (45,21) — quatre
        # sprites empiles, partenaires invisibles.
        # cmd_carte, elle, passait deja des pixels (ligne ~994).
        _replacer_entites(obj, nx * pas, ny * pas,
                          ancien_w * pas_ancien, ancien_h * pas_ancien)
        bloque = np.zeros((ny, nx), dtype=bool)
        for x in range(nx):
            for y in range(ny):
                bloque[y][x] = obj['obstacles'][x][y]['Tags'] == 1
        degager_entites(obj, bloque, pas)

    if not a.apply:
        print('(essai a blanc ; --apply pour ecrire)')
        return 0
    ecrire_planche(a.nom, pas, grille)
    reindexer()
    dst = a.sortie if os.path.isabs(a.sortie) \
        else os.path.join(ROOT, 'Data', 'Ground', os.path.basename(a.sortie))
    with open(dst, 'w', encoding='utf-8') as f:
        json.dump(doc, f, ensure_ascii=False, indent=2)
    print('ecrit', dst)
    verifier(a.nom, grille, pas)
    return 0


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest='cmd', required=True)

    def commun(p):
        p.add_argument('--tile', type=int, default=24)
        p.add_argument('--align', default='0,0')
        p.add_argument('--seuil', type=float, default=1.0)
        p.add_argument('--solpct', type=float, default=55.0)
        p.add_argument('--solconnexe', action='store_true',
                       help='ne garder que la poche de sol contenant le '
                            'pixel --sol (decors de ciel : les nuages du '
                            'fond ont la teinte du plateau)')
        p.add_argument('--sol', default=None,
                       help='X,Y : pixel echantillon du terrain marchable')
        p.add_argument('--apply', action='store_true')
        p.add_argument('--force', action='store_true')

    p = sub.add_parser('decoupe'); p.add_argument('image'); commun(p)
    p = sub.add_parser('importer'); p.add_argument('image'); p.add_argument('nom'); commun(p)
    p = sub.add_parser('carte'); p.add_argument('image'); p.add_argument('nom'); p.add_argument('sortie'); commun(p)
    p = sub.add_parser('ground'); p.add_argument('image'); p.add_argument('nom'); p.add_argument('sortie')
    p.add_argument('--grid', type=int, default=8)
    p.add_argument('--herite', default=None,
                   help='ground existant dont on reprend les entites '
                        '(marqueurs, spawners, objets scriptes)')
    commun(p)
    p = sub.add_parser('anime')
    p.add_argument('image'); p.add_argument('nom'); p.add_argument('sortie')
    p.add_argument('--grid', type=int, default=8)
    p.add_argument('--frames', type=int, default=4)
    p.add_argument('--framelen', type=int, default=10)
    p.add_argument('--vit-eau', dest='vit_eau', type=int, default=3,
                   help='px de defilement vertical de l eau, par frame')
    p.add_argument('--vit-nuage', dest='vit_nuage', type=int, default=1,
                   help='px de derive horizontale des nuages, par frame')
    p.add_argument('--herite', default=None,
                   help='ground existant dont on reprend les entites')
    p.add_argument('--seuil-obs', dest='seuil_obs', type=float, default=0.45,
                   help="fraction d'obstacle a partir de laquelle une "
                        "cellule est bloquee (0 = tout bloquer)")
    p.add_argument('--amas', type=int, default=3,
                   help='taille minimale, en cellules, d un amas d obstacles')
    commun(p)

    p = sub.add_parser('verifier'); p.add_argument('nom')

    a = ap.parse_args()
    return {'decoupe': cmd_decoupe, 'importer': cmd_importer,
            'carte': cmd_carte, 'ground': cmd_ground,
            'anime': cmd_anime,
            'verifier': cmd_verifier}[a.cmd](a) or 0


if __name__ == '__main__':
    sys.exit(main())
