#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Insère UNE planche dans Content/Tile/index.idx sans régénérer l'index.

POURQUOI CET OUTIL EXISTE
=========================
`tools/rebuild_tile_index.py` reconstruit l'index à partir de TOUS les
`.tile` présents dans `Content/Tile/`. C'est correct sur un dépôt complet,
mais catastrophique sur un checkout partiel : le dossier ne contient alors
qu'une poignée de planches, et l'index régénéré n'en déclare qu'une
poignée. `GraphicsManager.GetTile` renvoie alors 0 pour toutes les autres
— autrement dit la tuile d'erreur sur l'intégralité du jeu.

Cas réel rencontré le 2026-08-02 : après conversion de l'arène Zeraora sur
un checkout allégé, `png2tileset.py` a appelé `reindexer()` et produit un
index de **1 planche au lieu de 522**. Détecté avant le push par
comparaison avec l'index du dépôt (15 574 230 octets contre 28 111).

Cet outil fait l'opération inverse et sûre : il lit l'index existant, y
remplace ou y ajoute UNE entrée, et laisse les autres strictement
intactes — octet pour octet.

FORMAT (RogueEssence/Content/TileIndex.cs, TileGuide.Load)
    uint32 nbPlanches
    pour chaque planche :
        uint8   longueur du nom
        bytes   nom UTF-8
        uint32  tileSize
        uint32  tileCount
        bytes   table de tileCount * 16 octets (recopiée telle quelle
                depuis l'en-tête du .tile)

L'ordre des planches dans l'index est ALPHABÉTIQUE dans le dépôt (c'est
ce que produit `rebuild_tile_index.py` via `sorted()`). On respecte cet
ordre à l'insertion.

Usage
    python3 tools/inject_tile_index.py <NomPlanche> [--racine .]
"""
import os
import struct
import sys


def lire_index(chemin):
    """Retourne [(nom, tileSize, tileCount, table_bytes), ...]."""
    d = open(chemin, 'rb').read()
    n = struct.unpack_from('<I', d, 0)[0]
    pos = 4
    entrees = []
    for _ in range(n):
        ln = d[pos]
        pos += 1
        nom = d[pos:pos + ln].decode('utf-8')
        pos += ln
        ts, tc = struct.unpack_from('<II', d, pos)
        pos += 8
        table = d[pos:pos + tc * 16]
        if len(table) != tc * 16:
            raise ValueError(f'table tronquee pour {nom}')
        pos += tc * 16
        entrees.append((nom, ts, tc, table))
    if pos != len(d):
        raise ValueError(f'octets residuels : {len(d) - pos}')
    return entrees


def ecrire_index(chemin, entrees):
    out = bytearray()
    out += struct.pack('<I', len(entrees))
    for nom, ts, tc, table in entrees:
        enc = nom.encode('utf-8')
        out += struct.pack('<B', len(enc)) + enc
        out += struct.pack('<II', ts, tc)
        out += table
    open(chemin, 'wb').write(bytes(out))
    return len(out)


def entree_depuis_tile(racine, nom):
    chemin = os.path.join(racine, 'Content', 'Tile', nom + '.tile')
    d = open(chemin, 'rb').read()
    ts, tc = struct.unpack_from('<II', d, 0)
    table = d[8:8 + tc * 16]
    if len(table) != tc * 16:
        raise ValueError(f'.tile tronque : {nom}')
    return (nom, ts, tc, table)


def injecter(racine, nom):
    idx = os.path.join(racine, 'Content', 'Tile', 'index.idx')
    entrees = lire_index(idx)
    avant = len(entrees)

    # Non-régression : on doit savoir réécrire l'index tel quel.
    temoin = bytearray()
    temoin += struct.pack('<I', len(entrees))
    for nm, ts, tc, tb in entrees:
        e = nm.encode('utf-8')
        temoin += struct.pack('<B', len(e)) + e + struct.pack('<II', ts, tc) + tb
    if bytes(temoin) != open(idx, 'rb').read():
        raise SystemExit('ABANDON : relecture non identique a l\'original. '
                         'Le format n\'est pas celui attendu.')

    nouvelle = entree_depuis_tile(racine, nom)
    entrees = [e for e in entrees if e[0] != nom]
    remplace = len(entrees) != avant
    entrees.append(nouvelle)
    entrees.sort(key=lambda e: e[0])  # ordre alphabetique, comme rebuild

    taille = ecrire_index(idx, entrees)
    print(f"  {'remplacee' if remplace else 'ajoutee':10} : {nom} "
          f"(tileSize {nouvelle[1]}, {nouvelle[2]} tuiles)")
    print(f"  planches   : {avant} -> {len(entrees)}")
    print(f"  index      : {taille} octets")

    # Controle : l'index reste relisible et contient bien la planche.
    relu = {e[0]: e for e in lire_index(idx)}
    if nom not in relu:
        raise SystemExit('ABANDON : la planche est absente apres ecriture.')
    return len(entrees)


if __name__ == '__main__':
    argv = sys.argv[1:]
    racine = '.'
    if '--racine' in argv:
        i = argv.index('--racine')
        racine = argv[i + 1]
        del argv[i:i + 2]          # sinon la valeur passait pour un nom
    args = [a for a in argv if not a.startswith('--')]
    if not args:
        print(__doc__)
        sys.exit(1)
    for nom in args:
        injecter(racine, nom)
