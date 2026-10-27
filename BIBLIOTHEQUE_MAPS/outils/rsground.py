#!/usr/bin/env python3
"""Accès bas niveau aux fichiers .rsground (RogueEssence.Ground.GroundMap).

Un .rsground est un conteneur JSON sérialisé par RogueEssence :
    {"Version": "0.8.12.0", "Object": {"$type": "RogueEssence.Ground.GroundMap, RogueEssence", ...}}

Fait vérifiés sur les fichiers du dépôt et les sources RogueEssence
(Ground/Maps/GroundMap.cs, Dungeon/Maps/BaseMap.cs) :
  - largeur/hauteur de la carte = dimensions de Layers[0].Tiles (grille [x][y]) ;
  - une case vaut TexSize * 8 pixels (TexSize=1 -> 8 px, TexSize=3 -> 24 px) ;
  - la grille `obstacles` est en cellules de 8 px : [largeur*TexSize][hauteur*TexSize],
    chaque cellule porte Bounds={X:x*8, Y:y*8, Width:8, Height:8} et Tags ;
  - EdgeView suit l'énumération BaseMap.ScrollEdge : Blank=0, Clamp=1, Wrap=2 ;
  - les entités (MapChars, GroundObjects, Markers, Spawners) portent un
    Collider en pixels ; les tuiles référencent leurs tilesets via
    Tiles[x][y].Layers[].Frames[].Sheet (+ TexLoc).

Ce module ne fait que lire/écrire/analyser : aucune correction ici
(voir clamp_rsground.py). Bibliothèque standard uniquement.

L'écriture préserve : le BOM UTF-8 d'origine, l'ordre des clés ($type en
premier, exigence de désérialisation polymorphe) et la Version du conteneur.
"""
import copy
import json
from pathlib import Path

EDGEVIEW_NOMS = {0: "Blank", 1: "Clamp", 2: "Wrap"}
CELL_PX = 8  # taille d'une cellule d'obstacle et unité de TexLoc


def charger(chemin):
    """Retourne (donnees, bom) où donnees est le dict du conteneur complet."""
    brut = Path(chemin).read_bytes()
    bom = brut.startswith(b"\xef\xbb\xbf")
    return json.loads(brut.decode("utf-8-sig")), bom


def enregistrer(chemin, donnees, bom=True):
    """Écrit le conteneur en JSON (une clé par ligne, comme le moteur)."""
    texte = json.dumps(donnees, ensure_ascii=False, indent=0)
    Path(chemin).write_bytes(texte.encode("utf-8-sig" if bom else "utf-8"))


def grille_tuiles(couche):
    """Dimensions (largeur, hauteur) de la grille Tiles d'une couche."""
    tuiles = couche.get("Tiles") or []
    largeur = len(tuiles)
    hauteur = len(tuiles[0]) if largeur else 0
    return largeur, hauteur


def dimensions(obj):
    """(largeur, hauteur) de la carte en cases, d'après Layers[0]."""
    couches = obj.get("Layers") or []
    if not couches:
        return 0, 0
    return grille_tuiles(couches[0])


def taille_px(obj):
    """(largeur_px, hauteur_px) de la carte (GroundWidth/GroundHeight)."""
    largeur, hauteur = dimensions(obj)
    pas = int(obj.get("TexSize", 1)) * CELL_PX
    return largeur * pas, hauteur * pas


def tuile_vide_modele(obj):
    """Cherche une cellule de tuile vide à copier (Layers == [])."""
    for couche in obj.get("Layers") or []:
        for colonne in couche.get("Tiles") or []:
            for tuile in colonne:
                if isinstance(tuile, dict) and not tuile.get("Layers"):
                    return copy.deepcopy(tuile)
    # Forme observée dans les fichiers du dépôt si aucune tuile vide n'existe.
    return {"AutoTileset": "", "Associates": [], "Layers": [], "NeighborCode": -1}


def cellule_obstacle_modele(obj):
    """Cherche une cellule d'obstacle à copier (structure Bounds+Tags)."""
    for colonne in obj.get("obstacles") or []:
        for cellule in colonne:
            if isinstance(cellule, dict) and "Bounds" in cellule:
                return copy.deepcopy(cellule)
    return {"Bounds": {"X": 0, "Y": 0, "Width": CELL_PX, "Height": CELL_PX}, "Tags": 0}


def _collecter_sheets(noeud, compteurs):
    """Accumule les valeurs des clés 'Sheet' rencontrées sous un nœud."""
    if isinstance(noeud, dict):
        for cle, valeur in noeud.items():
            if cle == "Sheet" and isinstance(valeur, str) and valeur:
                compteurs[valeur] = compteurs.get(valeur, 0) + 1
            else:
                _collecter_sheets(valeur, compteurs)
    elif isinstance(noeud, list):
        for element in noeud:
            _collecter_sheets(element, compteurs)


def references_tilesets(obj):
    """Tilesets référencés par section : {'tuiles': {nom: n}, 'objets': ...}"""
    sections = {}
    for cle, nom in (("Layers", "tuiles"), ("Entities", "objets"),
                     ("Decorations", "decorations"), ("Background", "fond")):
        compteurs = {}
        _collecter_sheets(obj.get(cle), compteurs)
        if compteurs:
            sections[nom] = dict(sorted(compteurs.items()))
    return sections


def texlocs_par_sheet(obj):
    """Pour les calques de tuiles : {sheet: {(x, y), ...}} des TexLoc utilisés."""
    resultat = {}
    for couche in obj.get("Layers") or []:
        for colonne in couche.get("Tiles") or []:
            for tuile in colonne:
                if not isinstance(tuile, dict):
                    continue
                for sous in tuile.get("Layers") or []:
                    for frame in sous.get("Frames") or []:
                        sheet = frame.get("Sheet")
                        loc = frame.get("TexLoc") or {}
                        if sheet and "X" in loc and "Y" in loc:
                            resultat.setdefault(sheet, set()).add((loc["X"], loc["Y"]))
    return resultat


def est_rect(valeur):
    return isinstance(valeur, dict) and all(
        isinstance(valeur.get(c), int) for c in ("X", "Y", "Width", "Height"))


def est_loc(valeur):
    return isinstance(valeur, dict) and all(
        isinstance(valeur.get(c), int) for c in ("X", "Y")) and "Width" not in valeur


def analyser(donnees):
    """Photographie factuelle d'une GroundMap (aucune modification)."""
    obj = donnees["Object"]
    largeur, hauteur = dimensions(obj)
    tex = int(obj.get("TexSize", 1))
    largeur_px, hauteur_px = taille_px(obj)

    couches = []
    for couche in obj.get("Layers") or []:
        cl, ch = grille_tuiles(couche)
        couches.append({"nom": couche.get("Name", ""), "largeur": cl, "hauteur": ch,
                        "visible": couche.get("Visible", True)})

    obstacles = obj.get("obstacles") or []
    entites, marqueurs = [], []
    nb_chars = nb_objets = 0
    for couche_ent in obj.get("Entities") or []:
        nb_chars += len(couche_ent.get("MapChars") or [])
        nb_objets += len(couche_ent.get("GroundObjects") or [])
        for marqueur in couche_ent.get("Markers") or []:
            collider = marqueur.get("Collider") or {}
            marqueurs.append({"nom": marqueur.get("EntName", ""),
                              "x": collider.get("X"), "y": collider.get("Y")})
        entites.append(couche_ent.get("Name", ""))

    nom = obj.get("Name") or {}
    return {
        "version_conteneur": donnees.get("Version", ""),
        "nom_affiche": nom.get("DefaultText", "") if isinstance(nom, dict) else str(nom),
        "asset_name_interne": obj.get("AssetName", ""),
        "TexSize": tex,
        "taille_cases": [largeur, hauteur],
        "taille_px": [largeur_px, hauteur_px],
        "EdgeView": obj.get("EdgeView"),
        "EdgeView_nom": EDGEVIEW_NOMS.get(obj.get("EdgeView"), "inconnu"),
        "calques": couches,
        "obstacles_grille": [len(obstacles), len(obstacles[0]) if obstacles else 0],
        "obstacles_attendu": [largeur * tex, hauteur * tex],
        "couches_entites": entites,
        "nb_personnages": nb_chars,
        "nb_objets": nb_objets,
        "marqueurs": marqueurs,
        "nb_calques_decor": len(obj.get("Decorations") or []),
        "Musique": obj.get("Music", ""),
        "tilesets": references_tilesets(obj),
    }
