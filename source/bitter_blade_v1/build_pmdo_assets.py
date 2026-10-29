from __future__ import annotations

"""Build PMDO-ready, length-prefixed .dir particle strips for Bitter Blade."""

import json
import math
import struct
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SRC = Path(__file__).resolve().parent
ASSETS = SRC / "assets"
BLADE_SOURCE = ASSETS / "bitter_blade_blade_source.png"
BLADE_CUTOUT = ASSETS / "bitter_blade_blade_cutout.png"
WISP_SOURCE = ASSETS / "bitter_blade_wisp_source.png"
PNG_OUT = ASSETS / "pmdo_animation"
DIR_OUT = SRC / "Content/Particle"
MANIFEST_OUT = PNG_OUT / "animation_manifest.json"

FRAME_COUNT = 8
AURA_SIZE = 72
WISP_SIZE = 32
SLASH_SIZE = 72


def run(*args: str) -> None:
    subprocess.run([str(arg) for arg in args], check=True)


def make_dir_resource(png_path: Path, dir_path: Path) -> None:
    payload = png_path.read_bytes()
    if not payload.startswith(b"\x89PNG\r\n\x1a\n"):
        raise ValueError(f"Not a PNG sprite strip: {png_path}")
    dir_path.write_bytes(struct.pack("<Q", len(payload)) + payload)


def compose_over(base: Path, overlay: Path, x: int, y: int, output: Path) -> None:
    run(
        "convert",
        str(base),
        str(overlay),
        "-geometry",
        f"+{x}+{y}",
        "-compose",
        "over",
        "-composite",
        str(output),
    )


def make_blade_cutout(output: Path) -> None:
    # The newly generated blade frame has a flat teal chroma background. Preserve
    # its transparent crescent and impact spark; the animation is built from this
    # fresh source rather than the discarded first concept image.
    run(
        "convert",
        str(BLADE_SOURCE),
        "-alpha",
        "off",
        "-fuzz",
        "7%",
        "-transparent",
        "rgb(2,128,130)",
        "-trim",
        "+repage",
        "-strip",
        "-define",
        "png:exclude-chunk=date,time",
        str(output),
    )


def make_wisp_cutout(output: Path) -> None:
    # The generator produced a clean, flat teal background. Key only that color
    # family; preserve the generated charcoal-black flame and muted indigo edge.
    run(
        "convert",
        str(WISP_SOURCE),
        "-alpha",
        "off",
        "-fuzz",
        "7%",
        "-transparent",
        "rgb(7,129,129)",
        "-trim",
        "+repage",
        "-strip",
        "-define",
        "png:exclude-chunk=date,time",
        str(output),
    )


def make_wisp_frames(cutout: Path, work: Path) -> list[Path]:
    frames: list[Path] = []
    widths = (19, 20, 22, 21, 19, 18, 20, 22)
    heights = (26, 28, 27, 25, 26, 28, 27, 25)
    rotations = (-7, -4, 0, 5, 8, 4, -2, -6)
    brightness = (92, 100, 108, 104, 96, 90, 102, 110)
    for i in range(FRAME_COUNT):
        frame = work / f"wisp_{i:02d}.png"
        run(
            "convert",
            str(cutout),
            "-filter",
            "point",
            "-resize",
            f"{widths[i]}x{heights[i]}!",
            "-background",
            "none",
            "-rotate",
            str(rotations[i]),
            "-trim",
            "+repage",
            "-background",
            "none",
            "-gravity",
            "center",
            "-extent",
            f"{WISP_SIZE}x{WISP_SIZE}",
            "-modulate",
            f"{brightness[i]},100,100",
            str(frame),
        )
        frames.append(frame)
    return frames


def make_aura_frames(cutout: Path, work: Path) -> list[Path]:
    frames: list[Path] = []
    for i in range(FRAME_COUNT):
        aura = work / f"aura_{i:02d}_base.png"
        phase = i * 45
        outer_alpha = 0.72 + (i % 3) * 0.05
        inner_alpha = 0.46 + (i % 2) * 0.06
        draw = (
            f"stroke rgba(12,11,20,{outer_alpha:.2f}) stroke-width 4 fill none "
            "ellipse 36,36 28,20 0,360 "
            f"stroke rgba(55,49,76,{inner_alpha:.2f}) stroke-width 2 fill none "
            "ellipse 36,36 25,17 0,360"
        )
        run(
            "convert",
            "-size",
            f"{AURA_SIZE}x{AURA_SIZE}",
            "xc:none",
            "-draw",
            draw,
            str(aura),
        )

        current = aura
        for j in range(3):
            angle = math.radians(phase + j * 120 - 90)
            radius_x, radius_y = 25, 20
            center_x = 36 + radius_x * math.cos(angle)
            center_y = 36 + radius_y * math.sin(angle)
            wisp_size = 22 if (i + j) % 3 else 24
            # Keep each pixel-art wisp on quarter-turn rotations; 45-degree
            # interpolation makes the tiny silhouette look soft and blocky.
            rotation = -round((phase + j * 120) / 90) * 90
            wisp = work / f"aura_{i:02d}_wisp_{j}.png"
            run(
                "convert",
                str(cutout),
                "-filter",
                "point",
                "-resize",
                f"{wisp_size - 5}x{wisp_size}!",
                "-background",
                "none",
                "-rotate",
                str(rotation),
                "-trim",
                "+repage",
                "-background",
                "none",
                "-gravity",
                "center",
                "-extent",
                f"{wisp_size}x{wisp_size}",
                "-modulate",
                f"{92 + ((i + j) % 4) * 5},100,100",
                str(wisp),
            )
            x = round(center_x - wisp_size / 2)
            y = round(center_y - wisp_size / 2)
            next_canvas = work / f"aura_{i:02d}_layer_{j}.png"
            compose_over(current, wisp, x, y, next_canvas)
            current = next_canvas

        # Three generated black wisps orbit a dark spectral ring; the center
        # remains open for Ceruledge's native sprite.
        final = work / f"aura_{i:02d}.png"
        final.write_bytes(current.read_bytes())
        frames.append(final)
    return frames


def make_wipe_mask(progress: float, output: Path) -> None:
    """Make a transparent mask that reveals the slash from heel to tip."""
    edge = SLASH_SIZE - 1
    threshold = max(0, min(edge * 2, round(progress * edge * 2)))
    diagonal = threshold - edge
    if diagonal < 0:
        x_bottom = max(0, min(edge, edge + diagonal))
        y_left = max(0, min(edge, -diagonal))
        points = [(0, edge), (x_bottom, edge), (0, y_left)]
    else:
        x_top = max(0, min(edge, diagonal))
        y_right = max(0, min(edge, edge - diagonal))
        points = [(0, 0), (x_top, 0), (edge, y_right), (edge, edge), (0, edge)]
    polygon = " ".join(f"{x},{y}" for x, y in points)
    run(
        "convert",
        "-size",
        f"{SLASH_SIZE}x{SLASH_SIZE}",
        "xc:none",
        "-fill",
        "white",
        "-stroke",
        "none",
        "-draw",
        f"polygon {polygon}",
        str(output),
    )


def make_slash_frames(blade_cutout: Path, work: Path) -> list[Path]:
    """Build eight distinct slash frames: sweep, full impact, then dissipate."""
    base = work / "generated_blade_full.png"
    run(
        "convert",
        str(blade_cutout),
        "-filter",
        "point",
        "-resize",
        f"68x68>",
        "-background",
        "none",
        "-gravity",
        "center",
        "-extent",
        f"{SLASH_SIZE}x{SLASH_SIZE}",
        str(base),
    )

    # The crescent is revealed progressively along its lower-left to upper-right
    # travel, holds on impact, and fades. This changes the visible shape per
    # frame rather than merely scaling/rotating one frozen image.
    progress = (0.16, 0.30, 0.44, 0.58, 0.72, 0.86, 1.0, 1.0)
    alpha = (0.70, 0.82, 0.94, 1.0, 1.0, 0.94, 0.68, 0.34)
    frames: list[Path] = []
    for i in range(FRAME_COUNT):
        mask = work / f"slash_mask_{i:02d}.png"
        partial = work / f"slash_partial_{i:02d}.png"
        frame = work / f"slash_{i:02d}.png"
        make_wipe_mask(progress[i], mask)
        run(
            "convert",
            str(base),
            str(mask),
            "-compose",
            "DstIn",
            "-composite",
            "-channel",
            "A",
            "-evaluate",
            "multiply",
            f"{alpha[i]:.3f}",
            "+channel",
            str(partial),
        )
        # A short impact hold is followed by a visibly thinner fade-out frame.
        if i == 7:
            run(
                "convert",
                str(partial),
                "-channel",
                "A",
                "-evaluate",
                "multiply",
                "0.55",
                "+channel",
                str(frame),
            )
        else:
            frame.write_bytes(partial.read_bytes())
        frames.append(frame)
    return frames


def make_strip(frames: list[Path], output: Path) -> None:
    run(
        "convert",
        *(str(path) for path in frames),
        "+append",
        "-strip",
        "-define",
        "png:exclude-chunk=date,time",
        str(output),
    )


def main() -> None:
    for required in (BLADE_SOURCE, WISP_SOURCE):
        if not required.exists():
            raise FileNotFoundError(required)
    PNG_OUT.mkdir(parents=True, exist_ok=True)
    DIR_OUT.mkdir(parents=True, exist_ok=True)
    work_parent = ROOT / ".cache"
    work_parent.mkdir(exist_ok=True)

    with tempfile.TemporaryDirectory(prefix="bitter_blade_assets_", dir=work_parent) as temp:
        work = Path(temp)
        blade_cutout = BLADE_CUTOUT
        wisp_cutout = ASSETS / "bitter_blade_wisp_cutout.png"
        make_blade_cutout(blade_cutout)
        make_wisp_cutout(wisp_cutout)
        wisp_frames = make_wisp_frames(wisp_cutout, work)
        aura_frames = make_aura_frames(wisp_cutout, work)
        slash_frames = make_slash_frames(blade_cutout, work)

        strips = {
            "Bitter_Blade_Aura": aura_frames,
            "Bitter_Blade_Wisp": wisp_frames,
            "Bitter_Blade_Slash": slash_frames,
        }
        dimensions = {
            "Bitter_Blade_Aura": AURA_SIZE,
            "Bitter_Blade_Wisp": WISP_SIZE,
            "Bitter_Blade_Slash": SLASH_SIZE,
        }
        manifest_animations = []
        for name, frames in strips.items():
            png_path = PNG_OUT / f"{name}.png"
            dir_path = DIR_OUT / f"{name}.dir"
            make_strip(frames, png_path)
            make_dir_resource(png_path, dir_path)
            frame_size = dimensions[name]
            manifest_animations.append(
                {
                    "anim_index": name,
                    "resource": f"Content/Particle/{name}.dir",
                    "editable_png_strip": f"assets/pmdo_animation/{name}.png",
                    "frame_count": FRAME_COUNT,
                    "frame_size": [frame_size, frame_size],
                    "sheet_size": [frame_size * FRAME_COUNT, frame_size],
                    "dir_bytes": dir_path.stat().st_size,
                    "png_bytes": png_path.stat().st_size,
                }
            )

    manifest = {
        "format": "PMDO .dir image: 8-byte little-endian PNG byte length followed by a PNG sprite strip",
        "frame_layout": "8 square frames in a single horizontal strip; AnimIndex uses the basename",
        "visual_style": "Generated black/charcoal flames with restrained shadow-violet highlights; no red or orange pixels.",
        "animation_style_references": ["Will_O_Wisp", "Night_Slash", "Shadow_Claw"],
        "animations": manifest_animations,
    }
    MANIFEST_OUT.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print("Built PMDO particle resources:")
    for item in manifest_animations:
        print(
            f"  {item['anim_index']}: {item['frame_count']}×"
            f"{item['frame_size'][0]}px; {item['dir_bytes']:,} bytes"
        )


if __name__ == "__main__":
    main()
