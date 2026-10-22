#!/usr/bin/env python3
"""Verrou d'exclusivité du périmètre Ch.6-32 (les 51 donjons canoniques).

Les 51 donjons canoniques (chapitres 6 à 32) sont produits **exclusivement**
par `tools/dungeon_builder`.  Les anciens outils du dépôt (vagues 1-3, imports
manuels, correctifs ponctuels) écrivaient directement dans `Data/Zone/`,
`Data/Script/halcyon/zone/` ou `DungeonDefs/`.  S'ils étaient relancés, ils
reprendraient la main sur des données qui ne leur appartiennent plus.

Ce module installe un garde-fou d'exécution : toute écriture vers un chemin du
périmètre lève `PerimeterViolation` et arrête l'outil.  Il ne bloque rien
d'autre : un ancien outil peut continuer à écrire ses rapports ou ses zones
hors périmètre.

Activation, en tête d'un ancien outil (4 lignes) :

    import sys, pathlib
    sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
    from perimeter_guard import install as _install_perimeter_guard
    _install_perimeter_guard()

Contournement explicite (jamais en usage normal) :

    ALLOW_LEGACY_CH6_32=1 python tools/<ancien_outil>.py
"""
from __future__ import annotations

import builtins
import io
import json
import os
from pathlib import Path
from typing import Iterable, Set

ROOT = Path(__file__).resolve().parents[1]
DEF_DIR = ROOT / "DungeonDefs" / "canonical"
ENV_OVERRIDE = "ALLOW_LEGACY_CH6_32"


class PerimeterViolation(RuntimeError):
    """Écriture refusée : le chemin appartient aux 51 donjons Ch.6-32."""


def perimeter_ids() -> Set[str]:
    """Identifiants des donjons du périmètre, lus depuis les définitions."""
    ids: Set[str] = set()
    if not DEF_DIR.is_dir():
        return ids
    for path in sorted(DEF_DIR.glob("*.json")):
        try:
            raw = json.loads(path.read_text(encoding="utf-8-sig"))
        except (OSError, json.JSONDecodeError):
            continue
        ids.add(str(raw.get("id") or path.stem))
    return ids


def _protected_paths(ids: Iterable[str]) -> Set[Path]:
    protected: Set[Path] = {DEF_DIR}
    for zone_id in ids:
        protected.add(ROOT / "Data" / "Zone" / f"{zone_id}.json")
        protected.add(ROOT / "Data" / "Script" / "halcyon" / "zone" / zone_id)
    protected.add(ROOT / "Data" / "Zone" / "index.idx")
    return protected


_PROTECTED: Set[Path] = set()
_INSTALLED = False


def is_protected(target: os.PathLike | str) -> bool:
    try:
        path = Path(target).resolve()
    except (OSError, ValueError):
        return False
    for guarded in _PROTECTED:
        if path == guarded or guarded in path.parents:
            return True
    return False


def _violation(target: os.PathLike | str) -> PerimeterViolation:
    return PerimeterViolation(
        f"écriture refusée sur {target} : ce fichier appartient aux 51 donjons "
        "canoniques Ch.6-32, produits uniquement par tools/dungeon_builder. "
        f"Relancez avec {ENV_OVERRIDE}=1 seulement si vous savez pourquoi."
    )


def install() -> bool:
    """Installe le verrou. Renvoie False si explicitement désactivé."""
    global _INSTALLED, _PROTECTED
    if os.environ.get(ENV_OVERRIDE) == "1":
        return False
    if _INSTALLED:
        return True
    _PROTECTED = _protected_paths(perimeter_ids())

    real_open = builtins.open
    real_path_open = Path.open
    real_write_text = Path.write_text
    real_write_bytes = Path.write_bytes
    real_replace = os.replace
    real_rename = os.rename
    real_remove = os.remove

    def _writing(mode: str) -> bool:
        return any(flag in mode for flag in ("w", "a", "x", "+"))

    def guarded_open(file, mode="r", *args, **kwargs):  # type: ignore[no-untyped-def]
        if isinstance(mode, str) and _writing(mode) and is_protected(file):
            raise _violation(file)
        return real_open(file, mode, *args, **kwargs)

    def guarded_path_open(self, mode="r", *args, **kwargs):  # type: ignore[no-untyped-def]
        if isinstance(mode, str) and _writing(mode) and is_protected(self):
            raise _violation(self)
        return real_path_open(self, mode, *args, **kwargs)

    def guarded_write_text(self, *args, **kwargs):  # type: ignore[no-untyped-def]
        if is_protected(self):
            raise _violation(self)
        return real_write_text(self, *args, **kwargs)

    def guarded_write_bytes(self, *args, **kwargs):  # type: ignore[no-untyped-def]
        if is_protected(self):
            raise _violation(self)
        return real_write_bytes(self, *args, **kwargs)

    def guarded_replace(src, dst, *args, **kwargs):  # type: ignore[no-untyped-def]
        if is_protected(dst):
            raise _violation(dst)
        return real_replace(src, dst, *args, **kwargs)

    def guarded_rename(src, dst, *args, **kwargs):  # type: ignore[no-untyped-def]
        if is_protected(dst):
            raise _violation(dst)
        return real_rename(src, dst, *args, **kwargs)

    def guarded_remove(path, *args, **kwargs):  # type: ignore[no-untyped-def]
        if is_protected(path):
            raise _violation(path)
        return real_remove(path, *args, **kwargs)

    builtins.open = guarded_open  # type: ignore[assignment]
    io.open = guarded_open  # type: ignore[assignment]
    Path.open = guarded_path_open  # type: ignore[assignment]
    Path.write_text = guarded_write_text  # type: ignore[assignment]
    Path.write_bytes = guarded_write_bytes  # type: ignore[assignment]
    os.replace = guarded_replace  # type: ignore[assignment]
    os.rename = guarded_rename  # type: ignore[assignment]
    os.remove = guarded_remove  # type: ignore[assignment]
    _INSTALLED = True
    return True


GUARD_MARK = "perimeter_guard"

GUARD_SNIPPET = (
    "# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---\n"
    "import sys as _sys, pathlib as _pathlib\n"
    "for _anc in _pathlib.Path(__file__).resolve().parents:\n"
    "    if (_anc / 'tools' / 'perimeter_guard.py').is_file():\n"
    "        _sys.path.insert(0, str(_anc / 'tools'))\n"
    "        break\n"
    "from perimeter_guard import install as _install_perimeter_guard\n"
    "_install_perimeter_guard()\n"
    "# --- fin du verrou ---\n"
)


if __name__ == "__main__":  # diagnostic
    ids = sorted(perimeter_ids())
    print(f"{len(ids)} donjons protégés")
    for zone_id in ids:
        print(" -", zone_id)
