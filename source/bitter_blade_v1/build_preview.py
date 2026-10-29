from __future__ import annotations

"""Build a small illustrative GIF from the generated Bitter Blade VFX."""

import math
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SRC = Path(__file__).resolve().parent
CUTOUT = SRC / "assets/bitter_blade_vfx_cutout.png"
WORK = ROOT / ".cache/bitter_blade_preview"
TRIMMED = WORK / "bitter_blade_vfx_trimmed.png"
OUT = ROOT / "exports/illustrations/bitter_blade"
W, H = 512, 288


def run(*args: str) -> str:
    result = subprocess.run(args, check=True, text=True, capture_output=True)
    return result.stdout.strip()


def ensure_cutout() -> None:
    if not CUTOUT.exists():
        subprocess.run(["python3", str(SRC / "prepare_vfx.py")], check=True)
    WORK.mkdir(parents=True, exist_ok=True)
    OUT.mkdir(parents=True, exist_ok=True)
    subprocess.run(
        ["convert", str(CUTOUT), "-trim", "+repage", str(TRIMMED)],
        check=True,
    )


def curve(t: float) -> tuple[float, float]:
    # Energy returns from the impact to Ceruledge's side of the canvas.
    p0 = (282.0, 176.0)
    p1 = (202.0, 102.0)
    p2 = (104.0, 218.0)
    u = 1.0 - t
    return (
        u * u * p0[0] + 2 * u * t * p1[0] + t * t * p2[0],
        u * u * p0[1] + 2 * u * t * p1[1] + t * t * p2[1],
    )


def make_background(path: Path, phase: int) -> None:
    # Restrained night palette: a soft impact haze and a low floor ellipse give
    # the isolated effect scale without introducing characters or UI.
    glow_alpha = 8 + (phase % 4) * 2
    glow = f"rgba(70,35,95,{glow_alpha / 255:.3f})"
    run(
        "convert",
        "-size",
        f"{W}x{H}",
        "xc:#0d1019",
        "-fill",
        glow,
        "-stroke",
        "none",
        "-draw",
        "ellipse 282,176 175,82 0,360",
        str(path),
    )


def make_slash_layer(index: int, size: int, opacity: float, path: Path) -> tuple[int, int]:
    run(
        "convert",
        str(TRIMMED),
        "-filter",
        "point",
        "-resize",
        f"{size}x{size}",
        "-channel",
        "A",
        "-evaluate",
        "multiply",
        f"{opacity:.4f}",
        "+channel",
        str(path),
    )
    x = round((W - size) / 2) + round((5 - min(index, 5)) * 2)
    y = max(5, round((H - size) / 2) - 2)
    return x, y


def energy_overlay(progress: float, name: str) -> Path:
    path = WORK / f"{name}_energy.png"
    draw: list[str] = []
    steps = max(1, round(progress * 24))
    points = [curve(progress * i / steps) for i in range(steps + 1)]

    # A dark red-violet body with a thin ember core makes the return stream read
    # as healing energy instead of another attack slash.
    for a, b in zip(points, points[1:]):
        draw.append(f"stroke rgba(111,25,53,0.72) stroke-width 7 fill none line {a[0]:.1f},{a[1]:.1f} {b[0]:.1f},{b[1]:.1f}")
    for a, b in zip(points, points[1:]):
        draw.append(f"stroke rgba(237,75,42,0.86) stroke-width 3 fill none line {a[0]:.1f},{a[1]:.1f} {b[0]:.1f},{b[1]:.1f}")

    # Several ember beads travel along the same curve at staggered times.
    for lag, radius in ((0.00, 6), (0.12, 5), (0.25, 4), (0.39, 3)):
        t = progress - lag
        if t < 0:
            continue
        x, y = curve(min(1.0, t))
        color = "rgba(255,170,55,0.96)" if radius in (6, 4) else "rgba(238,55,45,0.94)"
        draw.append(f"fill {color} stroke none circle {x:.1f},{y:.1f} {x + radius:.1f},{y:.1f}")

    if progress >= 0.72:
        heal = max(0.0, min(1.0, (progress - 0.72) / 0.28))
        x, y = 104.0, 218.0
        r = 8 + 9 * heal
        draw.append(f"fill none stroke rgba(234,68,54,{0.75 * heal:.3f}) stroke-width 3 ellipse {x:.1f},{y:.1f} {r:.1f},{r*0.58:.1f} 0,360")
        draw.append(f"fill rgba(255,174,58,{0.88 * heal:.3f}) stroke none circle {x:.1f},{y:.1f} {x+3:.1f},{y:.1f}")

    run("convert", "-size", f"{W}x{H}", "xc:none", "-draw", " ".join(draw), str(path))
    return path


def main() -> None:
    ensure_cutout()
    phase = [
        (205, 0.48),
        (220, 0.65),
        (238, 0.81),
        (252, 0.95),
        (268, 1.00),
        (268, 0.94),
        (268, 0.78),
        (268, 0.62),
        (268, 0.45),
        (268, 0.28),
        (268, 0.13),
        (268, 0.00),
    ]
    frames: list[Path] = []
    delays = [8, 8, 8, 9, 12, 8, 8, 8, 8, 8, 10, 18]
    for index, (size, opacity) in enumerate(phase):
        base = WORK / f"frame_{index:02d}_base.png"
        make_background(base, index)
        canvas = base
        if opacity > 0:
            slash = WORK / f"frame_{index:02d}_slash.png"
            x, y = make_slash_layer(index, size, opacity, slash)
            composed = WORK / f"frame_{index:02d}_slash_composite.png"
            run(
                "convert",
                str(canvas),
                str(slash),
                "-geometry",
                f"+{x}+{y}",
                "-compose",
                "over",
                "-composite",
                str(composed),
            )
            canvas = composed
        if index >= 5:
            progress = min(1.0, (index - 4) / 7)
            energy = energy_overlay(progress, f"frame_{index:02d}")
            composed = WORK / f"frame_{index:02d}_final.png"
            run(
                "convert",
                str(canvas),
                str(energy),
                "-compose",
                "over",
                "-composite",
                str(composed),
            )
            canvas = composed
        frames.append(canvas)

    gif = OUT / "bitter_blade_vfx_preview.gif"
    cmd = ["convert"]
    for frame, delay in zip(frames, delays):
        cmd.extend(["-delay", str(delay), str(frame)])
    cmd.extend(["-loop", "0", "-dispose", "None", str(gif)])
    subprocess.run(cmd, check=True)
    print(f"Built {gif} ({len(frames)} frames, {gif.stat().st_size:,} bytes)")


if __name__ == "__main__":
    main()
