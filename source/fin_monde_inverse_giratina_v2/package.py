"""Tests -> ZIP projet PMDO + ZIP calques PNG (dans .cache) -> aperçu autonome racine.

.venv/bin/python source/fin_monde_inverse_giratina_v2/package.py
"""
from pathlib import Path
from io import BytesIO
import base64, json, subprocess, sys, zipfile
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
LOT = "fin_monde_inverse_giratina_v2"
PFX = "FMI2"
NAMESPACE = "fin_monde_inverse_giratina_v2"
REF_CODE = "finalisland"
SURFACE_RGB = "rgb(14,38,76)"
O = R / "renders" / LOT
CO = R / ".cache" / LOT / "renders"
S = R / ".cache" / LOT / NAMESPACE


def zipdir(path, items):
    with zipfile.ZipFile(path, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for src, arc in items:
            z.write(src, arc)


def uri_q(p):
    im = Image.open(p).convert("RGBA").quantize(colors=256, method=Image.Quantize.FASTOCTREE)
    buf = BytesIO()
    im.save(buf, format="PNG", optimize=True)
    return "data:image/png;base64," + base64.b64encode(buf.getvalue()).decode()


def main():
    subprocess.run([sys.executable, "-m", "unittest", f"source.{LOT}.test_build"], cwd=R, check=True)
    M = json.loads((O / "manifest.json").read_text(encoding="utf-8"))
    (O / "README.md").write_text((HERE / "README_PACK.md").read_text(encoding="utf-8"), encoding="utf-8")

    zipdir(
        CO / f"{PFX}_projet_pmdo_0812.zip",
        [(p, f"{NAMESPACE}/" + p.relative_to(S).as_posix()) for p in sorted(S.rglob("*")) if p.is_file()],
    )

    items = [(p, "calques/" + p.name) for p in sorted((CO / "calques").glob("*.png"))]
    items += [(p, "animation/animation/" + p.name) for p in sorted((CO / "animation/animation").glob("*.png"))]
    items += [
        (HERE / f"reference/{REF_CODE}.png", f"reference/{REF_CODE}.png"),
        (CO / f"{PFX}_{LOT}_calques.ora", f"{PFX}_{LOT}_calques.ora"),
        (O / "manifest.json", "manifest.json"),
        (O / "README.md", "README.md"),
        (O / f"review/{PFX}_scene_t000.png", f"apercu/{PFX}_scene_t000.png"),
        (O / f"review/{PFX}_scene_animee.webp", f"apercu/{PFX}_scene_animee.webp"),
        (O / f"review/{PFX}_collisions_marqueurs.png", f"apercu/{PFX}_collisions_marqueurs.png"),
    ]
    zipdir(CO / f"{PFX}_calques_png_8px.zip", items)

    ph = M["animation"]["phases"]
    tk = M["animation"]["frame_length_ticks"]
    stack = []
    for p in M["layer_order_bottom_to_top"]:
        nm = Path(p).stem.split("_", 2)[2].replace("_fNN", "")
        if "fNN" in p:
            stack.append({
                "id": nm,
                "ticks": tk,
                "frames": [uri_q(CO / p.replace("fNN", f"f{t:02d}")) for t in range(ph)],
            })
        else:
            stack.append({"id": nm, "ticks": 60, "frames": [uri_q(CO / p)]})

    data = {
        "size": M["size_px"],
        "loop": M["scene_loop_ticks"],
        "stack": stack,
        "surface": SURFACE_RGB,
        "poses": [],
        "collisions": uri_q(O / f"review/{PFX}_collisions_marqueurs.png"),
        "entry": M["access"]["markers"]["entrance"],
    }
    page = (HERE / "viewer_template.html").read_text(encoding="utf-8").replace("__DATA__", json.dumps(data))
    (R / f"apercu_{LOT}.html").write_text(page, encoding="utf-8")
    for p in [CO / f"{PFX}_projet_pmdo_0812.zip", CO / f"{PFX}_calques_png_8px.zip", R / f"apercu_{LOT}.html"]:
        print(p.relative_to(R), round(p.stat().st_size / 1e6, 2), "Mo")


if __name__ == "__main__":
    main()
