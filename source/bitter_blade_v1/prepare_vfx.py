from __future__ import annotations

"""Remove the generated transparency-checker preview from the pixel-art VFX."""

import subprocess
from pathlib import Path

SOURCE = Path(__file__).resolve().parent / "assets/bitter_blade_vfx.png"
OUTPUT = Path(__file__).resolve().parent / "assets/bitter_blade_vfx_cutout.png"
WIDTH = HEIGHT = 1024


def run(*args: str) -> bytes:
    return subprocess.check_output(args)


def main() -> None:
    rgb = run("convert", str(SOURCE), "-alpha", "off", "-depth", "8", "rgb:-")
    if len(rgb) != WIDTH * HEIGHT * 3:
        raise ValueError(f"Expected a {WIDTH}x{HEIGHT} RGB source, got {len(rgb)} bytes")

    # The image model flattened its transparency preview into two neutral checker
    # colors. The authored fire/blue/violet pixels are chromatic; remove only the
    # low-saturation dark-to-midrange tones and retain the hot white impact spark.
    rgba = bytearray(WIDTH * HEIGHT * 4)
    transparent = 0
    colored = 0
    brightest = (0, 0)
    brightest_value = -1
    for i in range(WIDTH * HEIGHT):
        r, g, b = rgb[i * 3 : i * 3 + 3]
        value = (r + g + b) // 3
        saturation = max(r, g, b) - min(r, g, b)
        alpha = 0 if saturation <= 30 and value < 218 else 255
        if alpha == 0:
            transparent += 1
        else:
            colored += 1
        if value > brightest_value:
            brightest_value = value
            brightest = (i % WIDTH, i // WIDTH)
        j = i * 4
        if alpha:
            rgba[j : j + 4] = bytes((r, g, b, 255))
        else:
            rgba[j : j + 4] = b"\x00\x00\x00\x00"

    if not transparent or not colored:
        raise ValueError("Background key did not produce both transparent and opaque pixels")
    # The central white-hot spark must survive the neutral-background key.
    spark_i = (brightest[1] * WIDTH + brightest[0]) * 4 + 3
    if rgba[spark_i] != 255:
        raise ValueError("The brightest impact pixel was unexpectedly keyed out")

    raw = OUTPUT.with_suffix(".rgba")
    raw.write_bytes(rgba)
    subprocess.run(
        [
            "convert",
            "-size",
            f"{WIDTH}x{HEIGHT}",
            "-depth",
            "8",
            f"RGBA:{raw}",
            str(OUTPUT),
        ],
        check=True,
    )
    raw.unlink()
    print(
        f"Prepared {OUTPUT}: {colored:,} kept pixels, {transparent:,} keyed pixels; "
        f"impact pixel {brightest} retained."
    )


if __name__ == "__main__":
    main()
