"""Opening « Peinture » — remplace les décors-textures de l'Ultime par des décors repeints à la main (crayon + encre + couleur).
La page contient les décors à la taille d'origine ; le rendu vidéo HD (source/render_sketch_video.js, HIRES=…/decors_peints) substitue les versions haute définition au dessin.
Sortie : page intermédiaire pour le rendu vidéo (source/render_sketch_video.js + opening_spyrook_engine.js).
Usage : python source/build_opening_peinture.py [sortie.html]"""
import base64
import io
import json
import re
import sys
from pathlib import Path

from PIL import Image, ImageFilter

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "apercu_fangame_pmd_destiny_ultime.html"
PLATES = ROOT / "source" / "pmd_destiny_fangame_v1" / "decors_peints"
KEYS = ["ocBg", "beachSea", "laprasSky", "laprasSea", "opm2", "opm3", "th1", "th5", "skyPeak"]


def main(out: Path) -> None:
    h = SRC.read_text(encoding="utf-8")
    i0 = h.index("const ASSETS = ") + len("const ASSETS = ")
    i1 = h.index(";\n</script>", i0)
    A = json.loads(h[i0:i1])
    for k in KEYS:
        ref = Image.open(io.BytesIO(base64.b64decode(A["imgs"][k].split(",", 1)[1])))
        im = Image.open(PLATES / f"{k}.png").convert("RGB").resize(ref.size, Image.LANCZOS).filter(ImageFilter.UnsharpMask(1.2, 60, 2))
        buf = io.BytesIO()
        im.save(buf, "WEBP", quality=94)
        A["imgs"][k] = "data:image/webp;base64," + base64.b64encode(buf.getvalue()).decode()
    h = h[:i0] + json.dumps(A, separators=(",", ":")) + h[i1:]
    old = "return { render, renderTitleMode, W, H, D, CHAPTERS, TITLE_T, IMPACTS: S.IMPACTS, SC };"
    if old in h:  # liste des plans (pour la caméra « dessin animé ») : même export que opening_ultime_engine.js
        h = h.replace(old, "return { render, renderTitleMode, W, H, D, CHAPTERS, TITLE_T, IMPACTS: S.IMPACTS, SC, SHOTS: [].concat(V.SC.map((q) => [q.id, q.t0, q.t1]), S.SC.map((q) => [q.id, q.t0, q.t1]), SC.map((q) => [q.id, q.t0, q.t1])) };")
    out.write_text(h, encoding="utf-8")
    print(out, out.stat().st_size // 1024, "Ko")


if __name__ == "__main__":
    main(Path(sys.argv[1]) if len(sys.argv) > 1 else Path("/tmp/vid/peinture.html"))
