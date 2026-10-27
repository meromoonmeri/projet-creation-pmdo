#!/usr/bin/env python3
"""(Re)construit Content/Tile/index.idx d'un mod PMDO à partir de ses .tile.

Format du conteneur (vérifié sur les fichiers du dépôt) :
    int32  nombre d'entrées
    par entrée, triées par nom :
      chaîne .NET (longueur en varint 7 bits + UTF-8) = nom du tileset
      nœud = les (8 + count*16) premiers octets du fichier .tile homonyme
             (taille de tuile, nombre de tuiles, table d'adresses x/y/offset)

L'index généré couvre exactement les .tile présents dans le dossier cible :
on ne fusionne jamais avec un index étranger (un index partiel collé sur un
mod existant ferait disparaître ses autres tilesets — cf. source/pmdo_cote).
Si un index.idx existe déjà, il est sauvegardé en index.idx.bak avant écriture.

Usage :
    python construire_index_tiles.py CHEMIN/DU/MOD/Content/Tile [--sec]
"""
import argparse
import struct
import sys
from pathlib import Path


def ecrire_chaine_dotnet(texte):
    brut = texte.encode("utf-8")
    taille, tete = len(brut), bytearray()
    while taille >= 128:
        tete.append((taille & 127) | 128)
        taille >>= 7
    tete.append(taille)
    return bytes(tete) + brut


def noeud_depuis_tile(chemin):
    """Extrait le nœud d'index (en-tête + table d'adresses) d'un .tile."""
    data = Path(chemin).read_bytes()
    if len(data) < 8:
        raise ValueError(f"{chemin} : .tile tronqué")
    taille_tuile, count = struct.unpack_from("<ii", data)
    if taille_tuile <= 0 or count < 0 or len(data) < 8 + count * 16:
        raise ValueError(f"{chemin} : en-tête .tile invalide")
    return data[:8 + count * 16]


def construire(dossier):
    dossier = Path(dossier)
    noeuds = {}
    for fichier in sorted(dossier.glob("*.tile")):
        noeuds[fichier.stem] = noeud_depuis_tile(fichier)
    return struct.pack("<i", len(noeuds)) + b"".join(
        ecrire_chaine_dotnet(nom) + noeuds[nom] for nom in sorted(noeuds)), noeuds


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("dossier", type=Path, help="dossier Content/Tile du mod")
    parser.add_argument("--sec", action="store_true", help="simuler sans écrire")
    args = parser.parse_args(argv)

    if not args.dossier.is_dir():
        print(f"Dossier introuvable : {args.dossier}", file=sys.stderr)
        return 2
    octets, noeuds = construire(args.dossier)
    print(f"{len(noeuds)} tileset(s) indexé(s) : {', '.join(sorted(noeuds)) or '(aucun)'}")
    cible = args.dossier / "index.idx"
    if args.sec:
        print("Simulation : aucun fichier écrit.")
        return 0
    if cible.exists():
        sauvegarde = args.dossier / "index.idx.bak"
        sauvegarde.write_bytes(cible.read_bytes())
        print(f"Ancien index sauvegardé : {sauvegarde.name}")
    cible.write_bytes(octets)
    print(f"Écrit : {cible} ({len(octets)} octets)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
