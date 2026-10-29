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
CUTOUT = ASSETS / "bitter_blade_vfx_cutout.png"
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


def make_wisp_cutout(output: Path) -> None:
    # The generator produced a clean, flat teal background. Key only that color
    # family; the deep violet and ember-red sprite remains untouched.
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
        outer_alpha = 0.34 + (i % 3) * 0.04
        inner_alpha = 0.22 + (i % 2) * 0.06
        draw = (
            f"stroke rgba(29,8,52,{outer_alpha:.2f}) stroke-width 4 fill none "
            "ellipse 36,36 28,20 0,360 "
            f"stroke rgba(118,47,166,{inner_alpha:.2f}) stroke-width 2 fill none "
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

        # A few tiny embers give the aura a fire/ghost split without filling the
        # center, where Ceruledge's native sprite remains visible.
        ember_angle = math.radians(phase * 2 + 27)
        ember_x = round(36 + 29 * math.cos(ember_angle))
        ember_y = round(36 + 25 * math.sin(ember_angle))
        final = work / f"aura_{i:02d}.png"
        run(
            "convert",
            str(current),
            "-fill",
            "rgba(244,76,48,0.9)",
            "-stroke",
            "none",
            "-draw",
            f"circle {ember_x},{ember_y} {ember_x + 2},{ember_y}",
            str(final),
        )
        frames.append(final)
    return frames


def make_slash_frames(work: Path) -> list[Path]:
    trimmed = work / "slash_trimmed.png"
    run("convert", str(CUTOUT), "-trim", "+repage", str(trimmed))
    sizes = (52, 58, 63, 68, 68, 64, 60, 55)
    rotations = (-8, -6, -3, 0, 3, 6, 8, 5)
    alpha = (0.32, 0.48, 0.68, 0.92, 1.0, 0.88, 0.66, 0.42)
    frames: list[Path] = []
    for i in range(FRAME_COUNT):
        frame = work / f"slash_{i:02d}.png"
        run(
            "convert",
            str(trimmed),
            "-filter",
            "point",
            "-resize",
            f"{sizes[i]}x{sizes[i]}",
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
            f"{SLASH_SIZE}x{SLASH_SIZE}",
            "-channel",
            "A",
            "-evaluate",
            "multiply",
            f"{alpha[i]:.3f}",
            "+channel",
            str(frame),
        )
        frames.append(frame)
    return frames


def make_strip(frames: list[Path], output: Path) -> None:
    run("convert", *(str(path) for path in frames), "+append", str(output))


def main() -> None:
    for required in (CUTOUT, WISP_SOURCE):
        if not required.exists():
            raise FileNotFoundError(required)
    PNG_OUT.mkdir(parents=True, exist_ok=True)
    DIR_OUT.mkdir(parents=True, exist_ok=True)
    work_parent = ROOT / ".cache"
    work_parent.mkdir(exist_ok=True)

    with tempfile.TemporaryDirectory(prefix="bitter_blade_assets_", dir=work_parent) as temp:
        work = Path(temp)
        wisp_cutout = ASSETS / "bitter_blade_wisp_cutout.png"
        make_wisp_cutout(wisp_cutout)
        wisp_frames = make_wisp_frames(wisp_cutout, work)
        aura_frames = make_aura_frames(wisp_cutout, work)
        slash_frames = make_slash_frames(work)

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
