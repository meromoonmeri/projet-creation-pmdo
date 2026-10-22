"""Seeded RNG policy for the Dungeon Builder.

Rules enforced here:
  * production layouts are NEVER generated from a fixed seed: the engine's own
    `IGenContext.Rand` (a `ReRandom` seeded by the run) drives them at runtime;
  * the builder's *authoring* randomness (which profile is attached to which
    floor, preview seeds, validation seeds) uses a non-deterministic seed by
    default, taken from the OS entropy pool;
  * every seed actually used is recorded so a bad case can be replayed with
    `--seed` for debugging only.
"""
from __future__ import annotations

import os
import random
from dataclasses import dataclass, field
from typing import List, Optional


def fresh_seed() -> int:
    """A new 63-bit seed from OS entropy (never a constant)."""
    return int.from_bytes(os.urandom(8), "big") & 0x7FFFFFFFFFFFFFFF


@dataclass
class DungeonRng:
    """Authoring-time RNG with a debug trail of every seed handed out."""

    seed: Optional[int] = None
    label: str = ""
    used_seeds: List[int] = field(default_factory=list)
    _rand: random.Random = field(default_factory=random.Random, repr=False)

    def __post_init__(self) -> None:
        if self.seed is None:
            self.seed = fresh_seed()
            self.explicit = False
        else:
            self.explicit = True
        self._rand = random.Random(self.seed)

    def next_seed(self) -> int:
        value = self._rand.getrandbits(63)
        self.used_seeds.append(value)
        return value

    @property
    def rand(self) -> random.Random:
        return self._rand

    def debug_info(self) -> dict:
        return {"label": self.label, "root_seed": self.seed,
                "explicit_seed": self.explicit, "derived_seeds": len(self.used_seeds)}
