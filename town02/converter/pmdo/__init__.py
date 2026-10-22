"""PMDO 0.8.12 target-engine constraints.

This package captures the RogueEssence/PMDO runtime constraints the
converter must respect at every stage. The most important one is the
viewport (320x240 logical resolution, 24-pixel ground tiles) because a
ground that is decoded correctly from the ROM can still render as a
broken map in PMDO if the tile size or camera bounds are wrong.

Nothing here reads the ROM or reproduces game content: this is a spec
of the target engine, checked against IR objects.
"""
from converter.pmdo.viewport import (
    PMDO_TILE_PX,
    PMDO_VIEWPORT_H_PX,
    PMDO_VIEWPORT_W_PX,
    ViewportCheck,
    check_ground_viewport,
)

__all__ = [
    "PMDO_TILE_PX",
    "PMDO_VIEWPORT_H_PX",
    "PMDO_VIEWPORT_W_PX",
    "ViewportCheck",
    "check_ground_viewport",
]
