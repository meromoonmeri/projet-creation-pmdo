#!/usr/bin/env python3
"""Audit « clamp » d'une GroundMap PMDO 0.8.12, avec corrections traçées.

« Clamp » = la carte ne laisse rien sortir de sa zone :
  1. EdgeView = Clamp (1) : la caméra ne défile jamais au-delà des bords
     (BaseMap.ScrollEdge : Blank=0, Clamp=1, Wrap=2 — Wrap est refusé ici,
     il boucle la carte au lieu de la fermer) ;
  2. tous les calques de tuiles partagent les dimensions de Layers[0] ;
  3. la grille `obstacles` couvre exactement largeur*TexSize × hauteur*TexSize
     cellules de 8 px, Bounds cohérents avec les indices ;
  4. personnages, objets, marqueurs, spawners et décors animés sont
     entièrement dans [0, largeur_px) × [0, hauteur_px) ;
  5. chaque TexLoc adressé existe dans la grille du tileset .tile fourni
     (contrôle seulement si le .tile est retrouvable).

Usage :
    python clamp_rsground.py CARTE.rsground [--tilesets DOSSIER...]
    python clamp_rsground.py CARTE.rsground --corriger -o SORTIE.rsground

Par défaut : audit seul, aucun fichier écrit. --corriger écrit une NOUVELLE
copie (refuse d'écraser un fichier existant : les cartes déjà éditées sont
protégées, comme dans source/pmdo_cote/INSTALLER.py), puis relance l'audit
sur la copie pour prouver le résultat. Sortie : rapport lisible + code de
retour 0 si la carte auditée (ou corrigée) est clampée, 1 sinon.
Stdlib uniquement ; aucun accès réseau ; le fichier source n'est jamais modifié.
"""
import argparse
import copy
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import rsground  # noqa: E402


# ---------------------------------------------------------------- audit pur

def _parcourir_entites(noeud, chemin, fn):
    """Visite récursive restreinte aux sous-arbres Entities/Decorations."""
    if isinstance(noeud, dict):
        fn(noeud, chemin)
        for cle, valeur in noeud.items():
            _parcourir_entites(valeur, f"{chemin}.{cle}", fn)
    elif isinstance(noeud, list):
        for i, element in enumerate(noeud):
            _parcourir_entites(element, f"{chemin}[{i}]", fn)


def _nom_entite(noeud):
    for cle in ("EntName", "NPCName", "Name", "Nickname"):
        valeur = noeud.get(cle)
        if isinstance(valeur, str) and valeur:
            return valeur
    data = noeud.get("Data")
    if isinstance(data, dict) and isinstance(data.get("Nickname"), str):
        return data["Nickname"]
    return "(sans nom)"


def auditer(obj, tilesets_disponibles=None):
    """Retourne {'problemes': [...], 'avertissements': [...]} sans rien modifier.

    tilesets_disponibles : {basename_sans_extension: set((x, y), ...)} optionnel.
    Chaque problème est un dict {code, message, corrigeable}.
    """
    problemes, avertissements = [], []
    largeur, hauteur = rsground.dimensions(obj)
    tex = int(obj.get("TexSize", 1))
    largeur_px, hauteur_px = rsground.taille_px(obj)

    if obj.get("EdgeView") != 1:
        problemes.append({
            "code": "EdgeView", "corrigeable": True,
            "message": f"EdgeView={obj.get('EdgeView')} "
                       f"({rsground.EDGEVIEW_NOMS.get(obj.get('EdgeView'), '?')}) "
                       "au lieu de Clamp (1) : la vue peut sortir de la carte."})

    for i, couche in enumerate(obj.get("Layers") or []):
        cl, ch = rsground.grille_tuiles(couche)
        if (cl, ch) != (largeur, hauteur):
            problemes.append({
                "code": "calque_dimensions", "couche": i,
                "corrigeable": cl <= largeur and ch <= hauteur,
                "message": f"Calque {i} « {couche.get('Name','')} » : {cl}×{ch} "
                           f"≠ carte {largeur}×{hauteur}."})

    obstacles = obj.get("obstacles") or []
    att_l, att_h = largeur * tex, hauteur * tex
    reel_l = len(obstacles)
    reel_h = len(obstacles[0]) if obstacles else 0
    if (reel_l, reel_h) != (att_l, att_h):
        problemes.append({
            "code": "obstacles_dimensions", "corrigeable": True,
            "message": f"Grille obstacles {reel_l}×{reel_h} ≠ attendu "
                       f"{att_l}×{att_h} (cellules de 8 px)."})
    else:
        incoherents = 0
        for x, colonne in enumerate(obstacles):
            for y, cellule in enumerate(colonne):
                if not isinstance(cellule, dict):
                    continue
                b = cellule.get("Bounds") or {}
                if (b.get("X"), b.get("Y"), b.get("Width"), b.get("Height")) != \
                        (x * rsground.CELL_PX, y * rsground.CELL_PX,
                         rsground.CELL_PX, rsground.CELL_PX):
                    incoherents += 1
        if incoherents:
            problemes.append({
                "code": "obstacles_bounds", "corrigeable": True,
                "message": f"{incoherents} cellule(s) d'obstacle ont des Bounds "
                           "différents de leur position dans la grille."})

    def verifier(noeud, _chemin):
        for cle in ("Collider", "Bounds"):
            rect = noeud.get(cle)
            if rsground.est_rect(rect):
                if rect["X"] < 0 or rect["Y"] < 0 or \
                        rect["X"] + rect["Width"] > largeur_px or \
                        rect["Y"] + rect["Height"] > hauteur_px:
                    problemes.append({
                        "code": "entite_hors_zone", "corrigeable": True,
                        "message": f"{_nom_entite(noeud)} : {cle} "
                                   f"({rect['X']},{rect['Y']},{rect['Width']}×{rect['Height']}) "
                                   f"sort de la carte {largeur_px}×{hauteur_px} px."})
        for cle in ("serializationLoc", "MapLoc"):
            loc = noeud.get(cle)
            if rsground.est_loc(loc):
                if not (0 <= loc["X"] < largeur_px and 0 <= loc["Y"] < hauteur_px):
                    problemes.append({
                        "code": "position_hors_zone", "corrigeable": True,
                        "message": f"{_nom_entite(noeud)} : {cle} "
                                   f"({loc['X']},{loc['Y']}) hors de la carte "
                                   f"{largeur_px}×{hauteur_px} px."})

    for section in ("Entities", "Decorations"):
        _parcourir_entites(obj.get(section) or [], section, verifier)

    marqueurs = []
    for couche_ent in obj.get("Entities") or []:
        marqueurs += [m.get("EntName", "") for m in couche_ent.get("Markers") or []]
    if not any("entr" in (n or "").lower() for n in marqueurs):
        avertissements.append(
            "Aucun marqueur d'entrée (nom contenant « entr ») : "
            "l'arrivée sur cette carte est à définir (règle d'or n°4 du dépôt).")

    if tilesets_disponibles is not None:
        for sheet, locs in rsground.texlocs_par_sheet(obj).items():
            grille = tilesets_disponibles.get(sheet)
            if grille is None:
                avertissements.append(
                    f"Tileset « {sheet} » : fichier .tile introuvable "
                    f"({len(locs)} TexLoc adressés, contrôle impossible).")
            else:
                absents = sorted(locs - grille)
                if absents:
                    avertissements.append(
                        f"Tileset « {sheet} » : {len(absents)} TexLoc hors grille "
                        f"(ex. {absents[:5]}) — tuiles vides ou sheet incompatible.")

    return {"problemes": problemes, "avertissements": avertissements}


# ---------------------------------------------------------------- corrections

def _clamper(valeur, bas, haut):
    return max(bas, min(valeur, haut))


def corriger(donnees):
    """Applique les corrections de clamp sur une copie profonde.

    Retourne (nouvelle_copie, journal_des_changements).
    Ne rogne jamais un calque plus grand que la carte (erreur signalée,
    correction manuelle requise) : on ne détruit pas de peinture en silence.
    """
    copie = copy.deepcopy(donnees)
    obj = copie["Object"]
    journal = []
    largeur, hauteur = rsground.dimensions(obj)
    tex = int(obj.get("TexSize", 1))
    largeur_px, hauteur_px = rsground.taille_px(obj)

    if obj.get("EdgeView") != 1:
        journal.append(f"EdgeView : {obj.get('EdgeView')} → 1 (Clamp).")
        obj["EdgeView"] = 1

    modele_tuile = rsground.tuile_vide_modele(obj)
    for i, couche in enumerate(obj.get("Layers") or []):
        tuiles = couche.get("Tiles") or []
        cl, ch = rsground.grille_tuiles(couche)
        if (cl, ch) == (largeur, hauteur):
            continue
        if cl > largeur or ch > hauteur:
            journal.append(
                f"Calque {i} « {couche.get('Name','')} » plus grand que la carte "
                f"({cl}×{ch} > {largeur}×{hauteur}) : NON corrigé automatiquement.")
            continue
        for colonne in tuiles:
            while len(colonne) < hauteur:
                colonne.append(copy.deepcopy(modele_tuile))
        while len(tuiles) < largeur:
            tuiles.append([copy.deepcopy(modele_tuile) for _ in range(hauteur)])
        couche["Tiles"] = tuiles
        journal.append(
            f"Calque {i} « {couche.get('Name','')} » complété en tuiles vides : "
            f"{cl}×{ch} → {largeur}×{hauteur}.")

    obstacles = obj.get("obstacles") or []
    att_l, att_h = largeur * tex, hauteur * tex
    reel_l = len(obstacles)
    reel_h = len(obstacles[0]) if obstacles else 0
    if (reel_l, reel_h) != (att_l, att_h) or obstacles:
        modele = rsground.cellule_obstacle_modele(obj)
        nouvelle = []
        for x in range(att_l):
            colonne = []
            for y in range(att_h):
                if x < reel_l and y < len(obstacles[x]) and \
                        isinstance(obstacles[x][y], dict):
                    cellule = copy.deepcopy(obstacles[x][y])
                else:
                    cellule = copy.deepcopy(modele)
                    cellule["Tags"] = 0
                cellule.setdefault("Bounds", {})
                cellule["Bounds"] = {"X": x * rsground.CELL_PX,
                                     "Y": y * rsground.CELL_PX,
                                     "Width": rsground.CELL_PX,
                                     "Height": rsground.CELL_PX}
                colonne.append(cellule)
            nouvelle.append(colonne)
        if (reel_l, reel_h) != (att_l, att_h):
            journal.append(
                f"Grille obstacles reconstruite : {reel_l}×{reel_h} → "
                f"{att_l}×{att_h} (Tags conservés dans le recouvrement).")
        obj["obstacles"] = nouvelle

    def ramener(noeud, _chemin):
        for cle in ("Collider", "Bounds"):
            rect = noeud.get(cle)
            if rsground.est_rect(rect):
                nx = _clamper(rect["X"], 0, max(0, largeur_px - rect["Width"]))
                ny = _clamper(rect["Y"], 0, max(0, hauteur_px - rect["Height"]))
                if (nx, ny) != (rect["X"], rect["Y"]):
                    journal.append(
                        f"{_nom_entite(noeud)} : {cle} ramené de "
                        f"({rect['X']},{rect['Y']}) à ({nx},{ny}).")
                    rect["X"], rect["Y"] = nx, ny
        for cle in ("serializationLoc", "MapLoc"):
            loc = noeud.get(cle)
            if rsground.est_loc(loc):
                nx = _clamper(loc["X"], 0, max(0, largeur_px - 1))
                ny = _clamper(loc["Y"], 0, max(0, hauteur_px - 1))
                if (nx, ny) != (loc["X"], loc["Y"]):
                    journal.append(
                        f"{_nom_entite(noeud)} : {cle} ramené de "
                        f"({loc['X']},{loc['Y']}) à ({nx},{ny}).")
                    loc["X"], loc["Y"] = nx, ny

    for section in ("Entities", "Decorations"):
        _parcourir_entites(obj.get(section) or [], section, ramener)

    return copie, journal


# ---------------------------------------------------------------- tilesets

def grille_tile(chemin):
    """Ensemble des (x, y) présents dans un fichier .tile (en-tête 8 + count×16)."""
    data = Path(chemin).read_bytes()
    if len(data) < 8:
        raise ValueError(f"{chemin} : fichier .tile tronqué")
    _taille, count = struct.unpack_from("<ii", data)
    if count < 0 or len(data) < 8 + count * 16:
        raise ValueError(f"{chemin} : table d'adresses .tile invalide")
    grille = set()
    for i in range(count):
        x, y, _adr = struct.unpack_from("<iiq", data, 8 + i * 16)
        grille.add((x, y))
    return grille


def inventaire_tilesets(dossiers):
    """{basename_sans_extension: (chemin, grille)} pour les dossiers donnés."""
    inventaire = {}
    for dossier in dossiers:
        for fichier in sorted(Path(dossier).rglob("*.tile")):
            inventaire.setdefault(fichier.stem, (fichier, grille_tile(fichier)))
    return inventaire


# ---------------------------------------------------------------- CLI

def _rapport(audit, titre):
    print(f"--- {titre}")
    if audit["problemes"]:
        for p in audit["problemes"]:
            print(f"  [CLAMP] {p['message']}")
    else:
        print("  Aucun problème de clamp.")
    for a in audit["avertissements"]:
        print(f"  [info]  {a}")


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("carte", type=Path)
    parser.add_argument("--tilesets", type=Path, nargs="*", default=[],
                        help="dossiers où chercher les .tile (contrôle TexLoc)")
    parser.add_argument("--corriger", action="store_true",
                        help="écrire une copie corrigée (exige -o)")
    parser.add_argument("-o", "--sortie", type=Path)
    args = parser.parse_args(argv)

    donnees, bom = rsground.charger(args.carte)
    info = rsground.analyser(donnees)
    print(f"{args.carte.name} — {info['taille_cases'][0]}×{info['taille_cases'][1]} cases, "
          f"TexSize {info['TexSize']}, conteneur {info['version_conteneur']}, "
          f"EdgeView {info['EdgeView_nom']}")

    inventaire = None
    if args.tilesets:
        brut = inventaire_tilesets(args.tilesets)
        inventaire = {nom: grille for nom, (_c, grille) in brut.items()}

    avant = auditer(donnees["Object"], inventaire)
    _rapport(avant, "audit d'entrée")

    if not args.corriger:
        return 0 if not avant["problemes"] else 1

    if not args.sortie:
        parser.error("--corriger exige -o SORTIE.rsground")
    if args.sortie.exists():
        print(f"Refus d'écraser {args.sortie} (carte protégée).", file=sys.stderr)
        return 2
    copie, journal = corriger(donnees)
    for ligne in journal:
        print(f"  [fix]   {ligne}")
    args.sortie.parent.mkdir(parents=True, exist_ok=True)
    rsground.enregistrer(args.sortie, copie, bom=bom)

    relu, _ = rsground.charger(args.sortie)  # preuve par relecture
    apres = auditer(relu["Object"], inventaire)
    _rapport(apres, f"audit après correction ({args.sortie.name})")
    return 0 if not apres["problemes"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
