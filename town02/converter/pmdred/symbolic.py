"""Symbolic name resolvers for PMD Red numeric ids.

Turns hex-suffixed placeholder keys (BGM_00AA, SFX_00BB, FLAG_0007,
MSG_00CC) into canonical pret enum names (MUS_MT_BLAZE, SE_WATER_DROP,
FLAG_HAS_MET_LOMBRE, ...) when the pret checkout is available.

If the pret checkout is not available, the resolvers return None and
callers keep the hex placeholder. The alternative (fabricating names
by guessing) would violate the "no fake PASS" rule.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import Optional

from converter.aux_sources.pret import PretCheckout


@dataclass
class SymbolResolver:
    """Small facade over a pret checkout that inverts (id -> name)
    the enums the converter needs at map/normalise time.

    We invert lazily and cache: the enums are tiny but there is no
    reason to keep re-scanning them for every event we translate.
    """

    pret: Optional[PretCheckout]
    _cache: dict[str, dict[int, str]] = field(default_factory=dict)

    # ------------------------------------------------------------------ base

    def _invert(self, enum_name: str) -> dict[int, str]:
        if enum_name in self._cache:
            return self._cache[enum_name]
        if self.pret is None:
            self._cache[enum_name] = {}
            return {}
        e = self.pret.get_enum(enum_name)
        if e is None:
            self._cache[enum_name] = {}
            return {}
        inv: dict[int, str] = {}
        for name, val in e.members.items():
            # First declaration wins on duplicates (pret has duplicate
            # trailer members here and there, e.g. MT_FREEZE_PEAK_2).
            inv.setdefault(val, name)
        self._cache[enum_name] = inv
        return inv

    # ------------------------------------------------------------------ API

    def music(self, numeric_id: int) -> Optional[str]:
        """Resolve a BGM numeric id to its MUS_* name.

        The enum in pret is named MusicID. Members start at 1
        (MUS_RESCUE_TEAM_BASE = 1).
        """
        return self._invert("MusicID").get(numeric_id)

    def sfx(self, numeric_id: int) -> Optional[str]:
        """Resolve a sound-effect numeric id.

        PMD Red uses several sound-effect enums (SE_*, ME_*, VE_*)
        living in different headers. We try them in order and return
        the first hit so callers can label the id even when the
        specific bank is unclear.
        """
        for name in ("SoundEffectID", "SEID", "SoundID"):
            r = self._invert(name).get(numeric_id)
            if r is not None:
                return r
        return None

    def flag(self, numeric_id: int) -> Optional[str]:
        """Resolve an event flag id to its FLAG_* / EVENT_* name.

        pret exposes these in enums such as EventFlag / EventFlagID
        depending on decompilation vintage. Try a small set.
        """
        for name in ("EventFlagID", "EventFlag", "FlagID"):
            r = self._invert(name).get(numeric_id)
            if r is not None:
                return r
        return None

    def cutscene(self, numeric_id: int) -> Optional[str]:
        """Resolve a cutscene id to its CUTSCENE_* name."""
        for name in ("CutsceneID", "Cutscene"):
            r = self._invert(name).get(numeric_id)
            if r is not None:
                return r
        return None


# --------------------------------------------------------- key resolution


def resolve_bgm_key(hex_key: str, resolver: SymbolResolver) -> Optional[str]:
    """Turn 'BGM_00AA' into 'MUS_...' if pret provides it."""
    if not hex_key.startswith("BGM_"):
        return None
    try:
        n = int(hex_key.split("_", 1)[1], 16)
    except ValueError:
        return None
    return resolver.music(n)


def resolve_sfx_key(hex_key: str, resolver: SymbolResolver) -> Optional[str]:
    if not hex_key.startswith("SFX_"):
        return None
    try:
        n = int(hex_key.split("_", 1)[1], 16)
    except ValueError:
        return None
    return resolver.sfx(n)


def resolve_flag_key(hex_key: str, resolver: SymbolResolver) -> Optional[str]:
    if not hex_key.startswith("FLAG_"):
        return None
    try:
        n = int(hex_key.split("_", 1)[1], 16)
    except ValueError:
        return None
    return resolver.flag(n)
