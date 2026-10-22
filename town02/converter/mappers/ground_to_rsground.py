"""Ground_IR -> RogueEssence .rsground (staging only).

Placeholder. When implemented, this mapper will:
  1. Translate BMA layers into RogueEssence GroundMap layer chunks.
  2. Translate collision layers into GroundMap block map.
  3. Translate Entity_IR into GroundMap entities with the appropriate
     RogueEssence type (GroundChar, GroundObject, GroundMarker) and
     wire a Lua script hook when Entity_IR.script_ref is set.
  4. Emit a staged bytes payload + a provenance manifest, both under
     converter/rom_output/05_emit/ (never directly to Data/Ground/).

Downgrade rule: if a feature (e.g. tile animation frame timing beyond
what RogueEssence supports) has no exact equivalent, provenance is
downgraded to PARTIAL with a specific status_reason.
"""
from __future__ import annotations


def map_ground(ground_ir, *, staging_dir):
    raise NotImplementedError("ground_to_rsground mapper not wired yet.")
