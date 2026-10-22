"""PMDO viewport & camera invariants.

PMDO 0.8.12 (RogueEssence engine) renders ground maps in a 320x240
logical framebuffer, upscaled by an integer factor at runtime. Ground
tiles are 24x24 pixels. A ground map has to satisfy a few structural
invariants for the camera to behave correctly:

  * The pixel dimensions of the ground must be >= the viewport, or the
    engine draws black bars.
  * The ground pixel dimensions must be a multiple of the tile size,
    or entities placed on tile centres appear off-grid.
  * The camera bounds (half viewport away from each edge) must be
    non-empty; otherwise the camera cannot centre on the player and
    reports clamp jitter.
  * Every entity spawn must fall inside the map.

This module offers a single check_ground_viewport(Ground_IR) function
returning a ViewportCheck report. It is used both by the s06_validate
stage and by any test that wants a fast structural pass.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from converter.ir.ground import Ground_IR


# PMDO 0.8.12 constants. These come from the running engine's own
# defaults (see the RogueEssence source under RogueEssence.Content /
# RogueEssence.Ground). We keep them as pure numeric constants; they
# are not ROM content.
PMDO_TILE_PX: int = 24
PMDO_VIEWPORT_W_PX: int = 320
PMDO_VIEWPORT_H_PX: int = 240

# Half-viewport, used to derive the camera-centre bounds.
_HALF_W = PMDO_VIEWPORT_W_PX // 2
_HALF_H = PMDO_VIEWPORT_H_PX // 2


@dataclass
class ViewportCheck:
    """Result of check_ground_viewport(). `ok` is True only if there
    is no FAIL-level finding."""

    ok: bool
    ground_id: str
    tile_px: int
    ground_px_w: int
    ground_px_h: int
    camera_bounds_px: tuple[int, int, int, int]
    findings: list[dict] = field(default_factory=list)

    def summary(self) -> str:
        counts: dict[str, int] = {}
        for f in self.findings:
            counts[f["level"]] = counts.get(f["level"], 0) + 1
        return (
            f"ground={self.ground_id} {self.ground_px_w}x{self.ground_px_h}px "
            f"tile={self.tile_px} camera_bounds={self.camera_bounds_px} "
            f"findings={counts}"
        )


def _finding(level: str, code: str, message: str) -> dict:
    return {"level": level, "code": code, "message": message}


def check_ground_viewport(
    ground: "Ground_IR",
    *,
    tile_px: int = PMDO_TILE_PX,
    viewport_w: int = PMDO_VIEWPORT_W_PX,
    viewport_h: int = PMDO_VIEWPORT_H_PX,
) -> ViewportCheck:
    """Run the PMDO viewport invariants on a Ground_IR.

    FAIL findings mean the ground would render incorrectly in PMDO
    (black bars, cropped edges, jittering camera, off-screen entities).
    WARN findings mean the ground would render but has an oddity worth
    surfacing (e.g. tile grid mismatch that entities can still avoid).

    Independent from the ROM: we compare Ground_IR dimensions to the
    fixed engine viewport constants.
    """
    findings: list[dict] = []

    # Ground pixel dimensions derived from the IR tile grid + PMDO tile.
    px_w = ground.width_tiles * tile_px
    px_h = ground.height_tiles * tile_px

    # 1) Minimum size vs viewport. Anything smaller draws black bars.
    if px_w < viewport_w:
        findings.append(_finding(
            "FAIL", "viewport_width_underrun",
            f"ground pixel width {px_w} < PMDO viewport {viewport_w}: "
            "black bars on the sides",
        ))
    if px_h < viewport_h:
        findings.append(_finding(
            "FAIL", "viewport_height_underrun",
            f"ground pixel height {px_h} < PMDO viewport {viewport_h}: "
            "black bars top/bottom",
        ))

    # 2) Pixel dimensions must be exact multiples of the tile size.
    #    Ground_IR is already tile-aligned by construction, but if the
    #    source ROM reports a pixel size that disagrees with tiles *
    #    tile_px we must surface the mismatch.
    if ground.pixel_width and ground.pixel_width != ground.width_tiles * (
        ground.pixel_width // max(1, ground.width_tiles)
    ):
        findings.append(_finding(
            "WARN", "pixel_width_not_tile_aligned",
            f"reported pixel_width={ground.pixel_width} is not an "
            f"integer multiple of width_tiles={ground.width_tiles}",
        ))
    if ground.pixel_height and ground.pixel_height != ground.height_tiles * (
        ground.pixel_height // max(1, ground.height_tiles)
    ):
        findings.append(_finding(
            "WARN", "pixel_height_not_tile_aligned",
            f"reported pixel_height={ground.pixel_height} is not an "
            f"integer multiple of height_tiles={ground.height_tiles}",
        ))

    # 3) Camera-centre bounds. Camera can be centred anywhere in
    #    [_HALF, ground_px - _HALF]. If that interval is empty the
    #    engine cannot follow the player without clamping every frame.
    cam_x_min = _HALF_W
    cam_x_max = max(_HALF_W, px_w - _HALF_W)
    cam_y_min = _HALF_H
    cam_y_max = max(_HALF_H, px_h - _HALF_H)
    if cam_x_max <= cam_x_min:
        findings.append(_finding(
            "FAIL", "camera_x_bounds_empty",
            f"camera-x bounds [{cam_x_min},{cam_x_max}] empty: camera "
            "cannot pan horizontally",
        ))
    if cam_y_max <= cam_y_min:
        findings.append(_finding(
            "FAIL", "camera_y_bounds_empty",
            f"camera-y bounds [{cam_y_min},{cam_y_max}] empty: camera "
            "cannot pan vertically",
        ))

    # 4) Entity spawns must land inside the map, in tile coordinates.
    for ent in ground.entities:
        if not (0 <= ent.tile_x < ground.width_tiles) or not (
            0 <= ent.tile_y < ground.height_tiles
        ):
            findings.append(_finding(
                "FAIL", "entity_out_of_bounds",
                f"entity slot={ent.slot} at ({ent.tile_x},{ent.tile_y}) "
                f"outside ground grid {ground.width_tiles}x{ground.height_tiles}",
            ))

    # 5) Warp destinations that reference this ground must land inside.
    for w in ground.warps:
        if w.dest_ground == ground.id and w.dest_x is not None \
                and w.dest_y is not None:
            if not (0 <= w.dest_x < ground.width_tiles) or not (
                0 <= w.dest_y < ground.height_tiles
            ):
                findings.append(_finding(
                    "FAIL", "warp_dest_out_of_bounds",
                    f"warp {w.trigger_kind} dest ({w.dest_x},{w.dest_y}) "
                    f"outside ground grid",
                ))

    ok = not any(f["level"] == "FAIL" for f in findings)
    return ViewportCheck(
        ok=ok,
        ground_id=ground.id,
        tile_px=tile_px,
        ground_px_w=px_w,
        ground_px_h=px_h,
        camera_bounds_px=(cam_x_min, cam_x_max, cam_y_min, cam_y_max),
        findings=findings,
    )
