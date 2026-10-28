#!/usr/bin/env python3
"""Importe la map ground « cliffdaytest — version nuit » dans la quest.

Source : branche ``arena/e39626d2-projet-creation-pmdo`` du dépôt — livrable
``livrables_cutscene_pichu_dazzling_pmdo/MOD_CUTSCENE_PICHU_DAZZLING_PMDO.zip``
(déjà versionné) qui contient la map ``cliffdaytest_nuit.rsground`` complète
avec ses atlas de tuiles autonomes ``PICHU_CLIFF_NIGHT_{CANOPY,SEA,TERRAIN}``
et ses fonds nocturnes ``CLIFF_PICHU_NUIT_{CIEL,ASTRES,NUAGES_*}``.

Le script :
1. extrait la map et les assets dans ``quest_pmd_destiny/`` ;
2. fusionne (en ajout) les 3 entrées d'atlas dans
   ``Content/Tile/index.idx`` — format natif :
   ``[i32 n][n x (chaîne .NET 7-bit + nœud)]`` trié, nœud =
   ``[i32 tile_size][i32 count][count x (i32 x, i32 y, u64 off)]``.

La map (48 Mo) reste hors Git (comme les 246 maps de la quest, cf.
.gitignore) : ce script la restaure à la demande. Honnêteté :
runtime_tested false.

Usage : .venv/bin/python OUTILS/importer_cliffdaytest_nuit.py
"""
from __future__ import annotations

import io
import json
import struct
import subprocess
import sys
import zipfile
from pathlib import Path

R = Path(__file__).resolve().parents[1]
QUEST = R / 'quest_pmd_destiny'
BRANCHE = 'FETCH_HEAD'  # après : git fetch origin arena/e39626d2-projet-creation-pmdo
ARCHE = 'livrables_cutscene_pichu_dazzling_pmdo/MOD_CUTSCENE_PICHU_DAZZLING_PMDO.zip'

FICHIERS = {
    'mod_pmdo/Data/Ground/cliffdaytest_nuit.rsground':
        'quest_pmd_destiny/Data/Ground/cliffdaytest_nuit.rsground',
    'mod_pmdo/Content/BG/CLIFF_PICHU_NUIT_CIEL.dir':
        'quest_pmd_destiny/Content/BG/CLIFF_PICHU_NUIT_CIEL.dir',
    'mod_pmdo/Content/BG/CLIFF_PICHU_NUIT_ASTRES.dir':
        'quest_pmd_destiny/Content/BG/CLIFF_PICHU_NUIT_ASTRES.dir',
    'mod_pmdo/Content/BG/CLIFF_PICHU_NUIT_NUAGES_HORIZON.dir':
        'quest_pmd_destiny/Content/BG/CLIFF_PICHU_NUIT_NUAGES_HORIZON.dir',
    'mod_pmdo/Content/BG/CLIFF_PICHU_NUIT_NUAGES_MILIEU.dir':
        'quest_pmd_destiny/Content/BG/CLIFF_PICHU_NUIT_NUAGES_MILIEU.dir',
    'mod_pmdo/Content/BG/CLIFF_PICHU_NUIT_NUAGES_HAUT.dir':
        'quest_pmd_destiny/Content/BG/CLIFF_PICHU_NUIT_NUAGES_HAUT.dir',
    'mod_pmdo/Content/Tile/PICHU_CLIFF_NIGHT_CANOPY.tile':
        'quest_pmd_destiny/Content/Tile/PICHU_CLIFF_NIGHT_CANOPY.tile',
    'mod_pmdo/Content/Tile/PICHU_CLIFF_NIGHT_SEA.tile':
        'quest_pmd_destiny/Content/Tile/PICHU_CLIFF_NIGHT_SEA.tile',
    'mod_pmdo/Content/Tile/PICHU_CLIFF_NIGHT_TERRAIN.tile':
        'quest_pmd_destiny/Content/Tile/PICHU_CLIFF_NIGHT_TERRAIN.tile',
}
ATLAS_AJOUTER = ('PICHU_CLIFF_NIGHT_CANOPY', 'PICHU_CLIFF_NIGHT_SEA',
                 'PICHU_CLIFF_NIGHT_TERRAIN')


# ---------------------------------------------- index.idx format natif
def exact(f: io.BytesIO, n: int) -> bytes:
    b = f.read(n)
    if len(b) != n:
        raise ValueError('fichier tronqué')
    return b


def write_string(value: str) -> bytes:
    raw = value.encode('utf-8')
    size, header = len(raw), bytearray()
    while size >= 128:
        header.append((size & 127) | 128)
        size >>= 7
    return bytes(header) + bytes([size]) + raw


def read_string(f: io.BytesIO) -> str:
    size, shift = 0, 0
    while True:
        byte = exact(f, 1)[0]
        size |= (byte & 127) << shift
        if byte < 128:
            return exact(f, size).decode('utf-8')
        shift += 7
        if shift > 35:
            raise ValueError('chaîne .NET invalide')


def read_node(f: io.BytesIO) -> bytes:
    header = exact(f, 8)
    tile_size, count = struct.unpack('<ii', header)
    if tile_size <= 0 or not 0 <= count <= 10_000_000:
        raise ValueError('nœud TileIndex invalide')
    return header + exact(f, count * 16)


def lire_index(blob: bytes) -> dict[str, bytes]:
    f = io.BytesIO(blob)
    n = struct.unpack('<i', exact(f, 4))[0]
    noeuds: dict[str, bytes] = {}
    for _ in range(n):
        nom = read_string(f)
        noeuds[nom] = read_node(f)
    if f.read(1):
        raise ValueError('données résiduelles dans index.idx')
    return noeuds


def encode_index(nodes: dict[str, bytes]) -> bytes:
    return struct.pack('<i', len(nodes)) + b''.join(
        write_string(k) + nodes[k] for k in sorted(nodes))


# ------------------------------------------------------------------ main
def main() -> int:
    print(f'→ archive livrable depuis la branche ({BRANCHE})')
    brut = subprocess.run(['git', 'show', f'{BRANCHE}:{ARCHE}'],
                          check=True, capture_output=True).stdout
    z = zipfile.ZipFile(io.BytesIO(brut))

    for src, dst in FICHIERS.items():
        cible = R / dst
        cible.parent.mkdir(parents=True, exist_ok=True)
        cible.write_bytes(z.read(src))
        print(f'  {dst} ({cible.stat().st_size} o)')

    # fusion d'index : ajout des 3 atlas nuit (aucun remplacement)
    idx_mod = lire_index(z.read('mod_pmdo/Content/Tile/index.idx'))
    idx_quest_p = QUEST / 'Content' / 'Tile' / 'index.idx'
    noeuds = lire_index(idx_quest_p.read_bytes())
    for nom in ATLAS_AJOUTER:
        if nom in noeuds:
            print(f'  index : {nom} déjà présent')
        else:
            noeuds[nom] = idx_mod[nom]
            print(f'  index : + {nom}')
    idx_quest_p.write_bytes(encode_index(noeuds))
    print(f'  index.idx régénéré ({len(noeuds)} atlas)')
    print('Terminé — map cliffdaytest_nuit installée dans la quest.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
