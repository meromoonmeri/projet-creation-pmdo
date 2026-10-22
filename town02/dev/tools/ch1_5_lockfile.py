#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Verrou CH1–CH5 — ressources STRICTEMENT IMMUTABLES.

Instruction utilisateur (2026-08-25) : les chapitres 1–5 et leurs ressources
sont immuables. Aucune campagne, générateur, validateur, correcteur,
renommage ou conversion ne doit pouvoir les modifier. Toute tentative
d'écriture doit ÉCHOUER immédiatement.

Référence d'état : commit 0f691fa3 (état initial du dépôt au début de la
session arena/01a0357e). Chaque entrée liste le blob git attendu — la CI/les
outils peuvent vérifier l'intégrité byte-exacte, pas seulement interdire
l'écriture.

Usage outillage:
    from dev.tools.ch1_5_lockfile import assert_unlocked, LOCKED_PATHS
    assert_unlocked(path)     # lève PermissionError si path est verrouillé

Vérification d'intégrité:
    python3 dev/tools/ch1_5_lockfile.py check
"""
from __future__ import annotations

import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]

REFERENCE_COMMIT = "0f691fa37ca484c3b6ab6599597db2f0483fd15e"

# path -> blob sha1 attendu (git hash-object) à l'état initial 0f691fa3.
LOCKED_BLOBS: dict[str, str] = {
    # Zones histoire CH1–CH5
    "Data/Zone/relic_forest.json":        "8aeaf9cd4c96591b7de189404da2a315e1b5e1b3",
    "Data/Zone/illuminant_riverbed.json": "827bf3867e20f9c24c3dc4fdc835741992a61874",
    "Data/Zone/crooked_cavern.json":      "12a42b7b0136dd4ce3c2bbed11017624c9ed5627",
    "Data/Zone/apricorn_grove.json":      "e1971236a4c222f10e79849bb99fd4c95ef9e342",
    "Data/Zone/vast_steppe.json":         "867594fa4fc2795b6510015b1bcfb967efbc7cff",
    "Data/Zone/searing_tunnel.json":      "18517271f2e71a114475d94aa57e09da7f246ba8",
    "Data/Zone/mount_windswept.json":     "e175b7b0b030ca86d7930931ebb6146b69b4de51",
    "Data/Zone/cloven_ruins.json":        "3cdaeb5160611dc2ec5c805cd9c801d903f205a2",
    "Data/Zone/beginner_lesson.json":     "4577bd2cffca65815de926564be60f209733e4e5",
    # Donjons secondaires débloqués aux chapitres 1–5
    "Data/Zone/petit_tunnel.json":        "3a700e11d0097b288b141030548409794fbe2c3b",
    "Data/Zone/bosquet_voile.json":       "07f2797a37157ea96e93fe64546f7b4e3802e684",
    "Data/Zone/grotte_mystere.json":      "1aaa05794ea95d9be1f12d4c4211c539361ad73b",
    "Data/Zone/vallee_fertile.json":      "47a7ff8809a613edcc9220a823f20af74f7fdcba",
    "Data/Zone/grotte_repos.json":        "53d9bfe6b9f4c6360e93f03656e1a223add9f308",
    "Data/Zone/bois_ronces.json":         "045b6178b7a3fbc38c6e97dc0f240a7af0491f19",
    "Data/Zone/antre_enigme.json":        "88b497dd02cd17154edab7ff8e1df43c1cb415fb",
    "Data/Zone/carriere_cuivre.json":     "93997ea311724b2683cd976ce6c6aac8ba9bf502",
    "Data/Zone/grotte_echoue.json":       "5c6d427e4a0d068118f022ee18d7bae7a5a3a55e",
    "Data/Zone/halles_royales.json":      "84cb0ff42699a87e61f9be826681109216d8f38a",
    "Data/Zone/jardin_secret.json":       "749d0277ec3c8c7249846ef09b019c07d659b8ee",
    "Data/Zone/foret_embuscade.json":     "a391a7fb10d733e981bd01901809f75288975a1e",
    "Data/Zone/bois_filou.json":          "82e647a3b8280520401fc5ed304956118db0ff66",
    # Dojo (mazes accessibles dès les chapitres 1–5)
    "Data/Zone/normal_maze.json":         "d9b3ec679e4dc7bed97d8c39fd43010c0773e353",
    "Data/Zone/bug_maze.json":            "8b9667960b2a292d2681974f5660a5c35340e9f2",
    "Data/Zone/electric_maze.json":       "6323f15735ddef45f2b020ba0e955eff6ca45443",
    "Data/Zone/fire_maze.json":           "0f1cd4af8cf590d7b01d284f0063420386909772",
    "Data/Zone/flying_maze.json":         "83c257302896d40c992efd430a09510f956df6a5",
    "Data/Zone/grass_maze.json":          "2f4a231cd822fa89926f7ef888697dc7294b68ab",
    "Data/Zone/rock_maze.json":           "1ed35e1a4e24082e7cdfcf5250eaad5609db7d47",
    "Data/Zone/water_maze.json":          "24061f9e786d9626f91abc8eb6fb69e43522521b",
    # Hub / infrastructures partagées CH1–CH5
    "Data/Zone/master_zone.json":         "2ed99b6d437772b3515de85c63375a0a8c2724f7",
    "Data/Script/halcyon/ground/metano_town/init.lua":
        "00a050daa7552832441f87c35b7ff182199af0cb",
    "Data/Script/halcyon/common.lua":     "3d936828097028c04ff772cc9c2947282b0f11e5",
    "Data/Script/halcyon/main.lua":       "ed1e17261a8b9fe834aedca2455b2315759a345a",
    "Data/Script/halcyon/mission_gen.lua": "33ac7b68c7f086d81399e9e2ef7a6457860c3c7c",
    # Arènes de boss CH5
    "Data/Map/mount_windswept_guardian.rsmap":
        "9c9c21efea78545c6b21a6b1afa61c488b8fdd38",
    "Data/Map/vast_steppe_guardian.rsmap":
        "4a4e80bf3c85d5f1ba4e3f7c3482d0cac4653c84",
}

# Répertoires verrouillés en bloc (scripts de zone/ground CH1–CH5).
LOCKED_DIRS: tuple[str, ...] = (
    "Data/Script/halcyon/zone/relic_forest",
    "Data/Script/halcyon/zone/illuminant_riverbed",
    "Data/Script/halcyon/zone/crooked_cavern",
    "Data/Script/halcyon/zone/apricorn_grove",
    "Data/Script/halcyon/zone/vast_steppe",
    "Data/Script/halcyon/zone/searing_tunnel",
    "Data/Script/halcyon/zone/mount_windswept",
    "Data/Script/halcyon/zone/cloven_ruins",
    "Data/Script/halcyon/zone/beginner_lesson",
    "Data/Script/halcyon/ground/metano_town",
    "Data/Script/halcyon/ground/guild_heros_room",
)

LOCKED_PATHS = frozenset(LOCKED_BLOBS)


def is_locked(path: str | Path) -> bool:
    p = str(Path(path))
    if p.startswith(str(ROOT) + "/"):
        p = p[len(str(ROOT)) + 1:]
    if p in LOCKED_BLOBS:
        return True
    return any(p == d or p.startswith(d + "/") for d in LOCKED_DIRS)


def assert_unlocked(path: str | Path) -> None:
    """Lève PermissionError si `path` appartient au périmètre CH1–CH5."""
    if is_locked(path):
        raise PermissionError(
            f"CH1-5 VERROUILLÉ: {path} est immuable (référence {REFERENCE_COMMIT[:8]}). "
            "Aucune écriture autorisée — voir dev/tools/ch1_5_lockfile.py.")


def check() -> int:
    """Vérifie l'intégrité byte-exacte de chaque ressource verrouillée."""
    bad = 0
    for rel, expected in sorted(LOCKED_BLOBS.items()):
        p = ROOT / rel
        if not p.exists():
            print(f"ABSENT     {rel}")
            bad += 1
            continue
        actual = subprocess.run(
            ["git", "hash-object", str(p)], cwd=ROOT,
            capture_output=True, text=True).stdout.strip()
        if actual == expected:
            print(f"IDENTIQUE  {rel}")
        else:
            print(f"MODIFIÉ    {rel}  attendu {expected[:12]} obtenu {actual[:12]}")
            bad += 1
    print(f"\n{'INTÉGRITÉ OK' if bad == 0 else f'{bad} VIOLATION(S)'} "
          f"— référence {REFERENCE_COMMIT[:8]}")
    return 0 if bad == 0 else 1


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "check":
        raise SystemExit(check())
    print(__doc__)
