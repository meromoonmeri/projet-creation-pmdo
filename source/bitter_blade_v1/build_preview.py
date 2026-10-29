from __future__ import annotations

"""Render a 5-tile, 8-direction preview with Ceruledge's native walk frames."""

import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SRC = Path(__file__).resolve().parent
ANIM = SRC / "assets/pmdo_animation"
WALK_SHEET = SRC / "references/upstream/ceruledge_sprite/Walk-Anim.png"
OUT_DIR = ROOT / "exports/illustrations/bitter_blade"
ATLAS = SRC / "assets/bitter_blade_animation_sheet.png"
GIF = OUT_DIR / "bitter_blade_dash_preview.gif"

CANVAS = 640
TILE = 40
CENTER = (CANVAS // 2, CANVAS // 2)
SPRITE_SIZE = (64, 112)  # nearest-neighbour 2x preview enlargement of native 32x56 cells
AURA_SIZE = 144          # 2x native 72x72 PMDO particle cell
WISP_SIZE = 48           # 1.5x native 32x32 PMDO particle cell
SLASH_SIZE = 144
DIRECTIONS = [
    (0, 1, "S", "Sud"),
    (1, 1, "SE", "Sud-Est"),
    (1, 0, "E", "Est"),
    (1, -1, "NE", "Nord-Est"),
    (0, -1, "N", "Nord"),
    (-1, -1, "NO", "Nord-Ouest"),
    (-1, 0, "O", "Ouest"),
    (-1, 1, "SO", "Sud-Ouest"),
]


def run(*args: str) -> None:
    subprocess.run([str(arg) for arg in args], check=True)


def crop_strip_frame(sheet: Path, cell: int, index: int, scale: int, output: Path) -> None:
    run(
        "convert",
        str(sheet),
        "-crop",
        f"{cell}x{cell}+{index * cell}+0",
        "+repage",
        "-filter",
        "point",
        "-resize",
        f"{scale}x{scale}!",
        str(output),
    )


def crop_sprite(direction: int, frame: int, output: Path) -> None:
    x = frame * 32
    y = direction * 56
    run(
        "convert",
        str(WALK_SHEET),
        "-crop",
        f"32x56+{x}+{y}",
        "+repage",
        "-filter",
        "point",
        "-resize",
        f"{SPRITE_SIZE[0]}x{SPRITE_SIZE[1]}!",
        str(output),
    )


def make_animation_atlas(work: Path) -> None:
    aura = ANIM / "Bitter_Blade_Aura.png"
    wisp = ANIM / "Bitter_Blade_Wisp.png"
    slash = ANIM / "Bitter_Blade_Slash.png"
    enlarged_wisp = work / "wisp_atlas.png"
    run("convert", str(wisp), "-filter", "point", "-resize", "512x64!", str(enlarged_wisp))
    width, height = 900, 560
    args = [
        "convert",
        "-size",
        f"{width}x{height}",
        "xc:#008080",
        "-font",
        "DejaVu-Sans",
        "-fill",
        "white",
        "-pointsize",
        "19",
        "-annotate",
        "+24+29",
        "BITTER BLADE / PMDO .dir particle strips",
        "-pointsize",
        "15",
        "-annotate",
        "+24+52",
        "Aura malefique — 8 frames, 72 x 72",
        str(aura),
        "-geometry",
        "+24+61",
        "-compose",
        "over",
        "-composite",
        "-annotate",
        "+24+164",
        "Feux follets — 8 frames, 32 x 32 (agrandis ici)",
        str(enlarged_wisp),
        "-geometry",
        "+24+174",
        "-compose",
        "over",
        "-composite",
        "-annotate",
        "+24+272",
        "Impact de lame — 8 frames, 72 x 72",
        str(slash),
        "-geometry",
        "+24+282",
        "-compose",
        "over",
        "-composite",
        "-annotate",
        "+24+389",
        "Ceruledge natif / Walk-Anim : 8 directions distinctes, aucune pose tournee",
    ]

    # The final row samples the first native Walk frame from each of Ceruledge's
    # eight direction rows; it is not synthesized by rotating one pose.
    for index, (_dx, _dy, label, _french) in enumerate(DIRECTIONS):
        sprite = work / f"ceruledge_direction_{index}.png"
        crop_sprite(index, 0, sprite)
        args.extend(
            [
                str(sprite),
                "-geometry",
                f"+{24 + index * 84}+400",
                "-compose",
                "over",
                "-composite",
                "-font",
                "DejaVu-Sans",
                "-fill",
                "white",
                "-pointsize",
                "14",
                "-annotate",
                f"+{39 + index * 84}+510",
                label,
            ]
        )
    args.append(str(ATLAS))
    run(*args)


def background(direction: int, work: Path) -> Path:
    dx, dy, label, french = DIRECTIONS[direction]
    path = work / f"path_{direction}.png"
    x0, y0 = CENTER
    x1, y1 = x0 + dx * TILE * 5, y0 + dy * TILE * 5
    draw: list[str] = []
    for x in range(0, CANVAS + 1, TILE):
        draw.append(f"stroke #232633 stroke-width 1 line {x},0 {x},{CANVAS}")
    for y in range(0, CANVAS + 1, TILE):
        draw.append(f"stroke #232633 stroke-width 1 line 0,{y} {CANVAS},{y}")
    draw.append(f"stroke rgba(96,48,127,0.72) stroke-width 4 line {x0},{y0} {x1},{y1}")
    draw.append("stroke none fill rgba(225,74,52,0.95)")
    draw.append(f"circle {x0},{y0} {x0 + 4},{y0}")
    for step in range(1, 6):
        px, py = x0 + dx * TILE * step, y0 + dy * TILE * step
        draw.append(f"fill rgba(153,79,179,0.84) circle {px},{py} {px + 3},{py}")
    run(
        "convert",
        "-size",
        f"{CANVAS}x{CANVAS}",
        "xc:#11131c",
        "-draw",
        " ".join(draw),
        "-font",
        "DejaVu-Sans",
        "-fill",
        "#f4f0ff",
        "-pointsize",
        "21",
        "-annotate",
        "+20+29",
        f"BITTER BLADE  /  DASH 5 CASES  /  {french.upper()}",
        "-fill",
        "#a59ab8",
        "-pointsize",
        "14",
        "-annotate",
        "+20+52",
        "Ceruledge natif — animations directionnelles PMDO",
        str(path),
    )
    return path


def make_frames(work: Path) -> list[Path]:
    aura_sheet = ANIM / "Bitter_Blade_Aura.png"
    wisp_sheet = ANIM / "Bitter_Blade_Wisp.png"
    slash_sheet = ANIM / "Bitter_Blade_Slash.png"
    aura_frames: list[Path] = []
    wisp_frames: list[Path] = []
    slash_frames: list[Path] = []
    for i in range(8):
        aura = work / f"aura_preview_{i}.png"
        wisp = work / f"wisp_preview_{i}.png"
        slash = work / f"slash_preview_{i}.png"
        crop_strip_frame(aura_sheet, 72, i, AURA_SIZE, aura)
        crop_strip_frame(wisp_sheet, 32, i, WISP_SIZE, wisp)
        crop_strip_frame(slash_sheet, 72, i, SLASH_SIZE, slash)
        aura_frames.append(aura)
        wisp_frames.append(wisp)
        slash_frames.append(slash)

    sprites: dict[tuple[int, int], Path] = {}
    for direction in range(8):
        for frame in range(4):
            sprite = work / f"ceruledge_{direction}_{frame}.png"
            crop_sprite(direction, frame, sprite)
            sprites[(direction, frame)] = sprite

    bases = [background(direction, work) for direction in range(8)]
    output: list[Path] = []
    frame_number = 0
    for direction, (dx, dy, _label, _french) in enumerate(DIRECTIONS):
        base = bases[direction]
        # Two ready-up beats, ten dash beats (five tiles), then three impact
        # frames. All eight direction rows are read from Ceruledge's native sheet.
        for local_frame in range(13):
            if local_frame < 2:
                progress = 0.0
            elif local_frame < 12:
                progress = (local_frame - 1) / 10
            else:
                progress = 1.0
            x = round(CENTER[0] + dx * TILE * 5 * progress)
            y = round(CENTER[1] + dy * TILE * 5 * progress)
            walk_frame = (local_frame // 2) % 4
            sprite = sprites[(direction, walk_frame)]
            overlays: list[tuple[Path, int, int]] = []

            # TileEmitter leaves a short string of animated wisps behind the dash.
            trail_count = min(5, int(progress * 5 + 1e-6))
            for tile_index in range(1, trail_count + 1):
                wx = CENTER[0] + dx * TILE * tile_index
                wy = CENTER[1] + dy * TILE * tile_index
                wisp = wisp_frames[(local_frame + tile_index) % 8]
                overlays.append((wisp, wx - WISP_SIZE // 2, wy - WISP_SIZE // 2))

            aura = aura_frames[(local_frame + direction) % 8]
            overlays.append((aura, x - AURA_SIZE // 2, y - AURA_SIZE // 2))
            overlays.append((sprite, x - SPRITE_SIZE[0] // 2, y - SPRITE_SIZE[1] // 2))
            if local_frame >= 11:
                slash_index = min(7, 3 + (local_frame - 11) * 2)
                slash = slash_frames[slash_index]
                overlays.append((slash, x - SLASH_SIZE // 2, y - SLASH_SIZE // 2))

            frame = work / f"preview_{frame_number:03d}.png"
            args = ["convert", str(base)]
            for layer, ox, oy in overlays:
                args.extend(
                    [
                        str(layer),
                        "-geometry",
                        f"+{ox}+{oy}",
                        "-compose",
                        "over",
                        "-composite",
                    ]
                )
            args.append(str(frame))
            run(*args)
            output.append(frame)
            frame_number += 1
    return output


def main() -> None:
    required = [
        ANIM / "Bitter_Blade_Aura.png",
        ANIM / "Bitter_Blade_Wisp.png",
        ANIM / "Bitter_Blade_Slash.png",
        WALK_SHEET,
    ]
    missing = [path for path in required if not path.exists()]
    if missing:
        raise FileNotFoundError("Missing animation inputs: " + ", ".join(map(str, missing)))

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    cache_dir = ROOT / ".cache"
    cache_dir.mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="bitter_blade_preview_", dir=cache_dir) as temp:
        work = Path(temp)
        make_animation_atlas(work)
        frames = make_frames(work)
        args = ["convert"]
        for frame in frames:
            args.extend(["-delay", "5", str(frame)])
        args.extend(["-loop", "0", "-dispose", "None", str(GIF)])
        run(*args)

    print(f"Built {ATLAS} and {GIF} ({len(frames)} frames, {GIF.stat().st_size:,} bytes).")


if __name__ == "__main__":
    main()
