"""Asset_IR (tile) -> Content/Tile atlas (staging only).

Placeholder. When implemented, this mapper produces the .tile atlas
files consumed by RogueEssence (identical layout to what our packager
already expects). Pixel data comes from converter/rom_output/
(git-ignored). The mapper writes staged atlases plus the index entry
under converter/rom_output/05_emit/Content/Tile/.
"""
from __future__ import annotations


def map_tile_atlas(asset_ir, *, staging_dir):
    raise NotImplementedError("tile_to_atlas mapper not wired yet.")
