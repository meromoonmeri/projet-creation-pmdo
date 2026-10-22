"""Tests for the PMDO viewport check.

Uses synthetic Ground_IR instances (never any real game data) to prove
the invariants catch black-bar, off-grid, empty-camera-bounds and
out-of-bounds-entity conditions before they reach the runtime.
"""
from __future__ import annotations

from converter.ir.ground import (
    BMA_IR,
    Entity_IR,
    Ground_IR,
    Warp_IR,
)
from converter.ir.provenance import Provenance, Status
from converter.pmdo.viewport import (
    PMDO_TILE_PX,
    PMDO_VIEWPORT_H_PX,
    PMDO_VIEWPORT_W_PX,
    check_ground_viewport,
)
from converter.stages.context import ROM_EXPECTED_HASH


def _prov(status=Status.PORTED, reason="") -> Provenance:
    if status in (Status.PORTED, Status.CANONICAL):
        return Provenance(rom_sha256=ROM_EXPECTED_HASH, status=status)
    return Provenance(rom_sha256=ROM_EXPECTED_HASH, status=status,
                      status_reason=reason or "test fixture")


def _bma(w_tiles: int, h_tiles: int) -> BMA_IR:
    return BMA_IR(layers=[], collisions=[], animated=[],
                  unknown_data=None, provenance=_prov())


def _ground(
    ground_id: str = "g",
    width_tiles: int = 20,
    height_tiles: int = 15,
    tile_px: int = PMDO_TILE_PX,
    entities: list[Entity_IR] | None = None,
    warps: list[Warp_IR] | None = None,
) -> Ground_IR:
    return Ground_IR(
        id=ground_id,
        rom_map_file_id="TEST",
        width_tiles=width_tiles,
        height_tiles=height_tiles,
        pixel_width=width_tiles * tile_px,
        pixel_height=height_tiles * tile_px,
        tileset_id=0,
        bma=_bma(width_tiles, height_tiles),
        entities=entities or [],
        warps=warps or [],
        provenance=_prov(),
    )


# ---------------------------------------------------------------- pass


def test_viewport_ok_on_standard_ground() -> None:
    # 20x15 tiles at 24 px = 480x360 px, comfortably >= 320x240 viewport
    g = _ground(width_tiles=20, height_tiles=15)
    result = check_ground_viewport(g)
    assert result.ok, f"unexpected failures: {result.findings}"
    assert result.ground_px_w == 480 and result.ground_px_h == 360
    # camera_bounds = (half, px - half) both axes
    cx_min, cx_max, cy_min, cy_max = result.camera_bounds_px
    assert cx_min == PMDO_VIEWPORT_W_PX // 2
    assert cx_max == 480 - PMDO_VIEWPORT_W_PX // 2
    assert cy_min == PMDO_VIEWPORT_H_PX // 2
    assert cy_max == 360 - PMDO_VIEWPORT_H_PX // 2


# ---------------------------------------------------------------- fails


def test_viewport_rejects_tiny_ground_width() -> None:
    # 10 tiles * 24 px = 240 px -> less than 320 viewport width => FAIL
    g = _ground(width_tiles=10, height_tiles=15)
    result = check_ground_viewport(g)
    assert not result.ok
    codes = {f["code"] for f in result.findings if f["level"] == "FAIL"}
    assert "viewport_width_underrun" in codes


def test_viewport_rejects_tiny_ground_height() -> None:
    g = _ground(width_tiles=20, height_tiles=8)   # 192 px < 240
    result = check_ground_viewport(g)
    assert not result.ok
    codes = {f["code"] for f in result.findings if f["level"] == "FAIL"}
    assert "viewport_height_underrun" in codes


def test_viewport_rejects_entity_out_of_bounds() -> None:
    ent = Entity_IR(
        slot=0, kind="npc", species_hint=None,
        tile_x=999, tile_y=0, facing="S",
        script_ref=None, provenance=_prov(),
    )
    g = _ground(entities=[ent])
    result = check_ground_viewport(g)
    assert not result.ok
    codes = {f["code"] for f in result.findings if f["level"] == "FAIL"}
    assert "entity_out_of_bounds" in codes


def test_viewport_rejects_warp_dest_out_of_bounds() -> None:
    w = Warp_IR(
        trigger_kind="step_on", x=0, y=0,
        dest_ground="g", dest_x=999, dest_y=999,
        provenance=_prov(),
    )
    g = _ground(warps=[w])
    result = check_ground_viewport(g)
    assert not result.ok
    codes = {f["code"] for f in result.findings if f["level"] == "FAIL"}
    assert "warp_dest_out_of_bounds" in codes


def test_viewport_summary_contains_useful_info() -> None:
    g = _ground(width_tiles=20, height_tiles=15)
    text = check_ground_viewport(g).summary()
    assert "480x360px" in text
    assert "tile=24" in text
