#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Constructeur de l'Opening « ULTIME » de `Pokémon Mystery Dungeon : Destiny` — durée exacte `02:33` (`153,00 s`), calée sur
`Simple and Clean -Ray of Hope MIX-` (`2aafI3XvKxo`).

Assemblage (même musique, mêmes repères temporels que l'opening sprites) :
  0 → 31 s    : opening VOYAGE (abysse de bulles → surface)                          [moteur `opening_voyage_engine.js`]
  31 → 46 s   : COURSE LUNAIRE (Riolu / Évoli / Tiplouf, décor Moonlight de PMD Sky) + personnages en gros plan [`opening_ultime_engine.js`]
  46 → 153 s  : opening sprites (passage 46 s → 1:08 conservé, mêlée, chute, remontée, écran-titre) [moteur `opening_sprite_engine.js`]

Sortie : `apercu_fangame_pmd_destiny_ultime.html` autonome (tout en `data:` URI, 0 requête externe).
"""
from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Dict

SOURCE_DIR = Path(__file__).resolve().parent
REPO_ROOT = SOURCE_DIR.parent
for p in (str(REPO_ROOT), str(SOURCE_DIR)):
    if p not in sys.path:
        sys.path.insert(0, p)

from source import build_opening_sprite_cinematique_destiny as SPR  # type: ignore
from source import build_opening_voyage as VOY  # type: ignore
from source import build_opening_voyage_layers as VL  # type: ignore
from source import build_beach_layers as BL  # type: ignore
from PIL import Image  # noqa: E402
import numpy as np  # noqa: E402

RENDERS = REPO_ROOT / "renders" / "pmd_destiny_fangame_v1"
ASSETS_DIR = RENDERS / "opening_assets"
OUT_DIR = RENDERS / "opening_ultime"
BRUTS = SOURCE_DIR / "pmd_destiny_fangame_v1" / "ultime_bruts"
TEMPLATE = SOURCE_DIR / "opening_ultime_template.html"
ENGINES = [SOURCE_DIR / "opening_voyage_engine.js", SOURCE_DIR / "opening_sprite_engine.js", SOURCE_DIR / "opening_ultime_engine.js"]
OUT_HTML = REPO_ROOT / "apercu_fangame_pmd_destiny_ultime.html"
DURATION_S = 153.0

# Personnages de l'histoire (gros plans de la course lunaire) : animations réellement utilisées
EXTRA_ACTORS = {
    "0447": ["Walk"], "0133": ["Walk"], "0393": ["Walk"],
    "0151": ["Twirl"], "0251": ["Twirl"], "0490": ["Idle"],
    "0448": ["Pose"], "0571": ["Idle"], "0491": ["Idle"],
    "0380": ["Idle"], "0381": ["Idle"], "0492": ["Appeal"],
    "0282": ["Appeal"], "0040": ["Hop"], "0253": ["Pose"], "0441": ["Float"],
}
# Calques du clip « sprites » que la nouvelle ligne de temps ne montre plus (plans avant 46 s) : retirés pour alléger la page
PRUNE = {"beachFg", "surfaceSky", "meadow", "clouds", "anticWall", "ttSky", "opm1", "opm5", "plainsFar", "skyPeakFront", "forestFar", "forestMid", "forestRoad", "forestFg"}
PRUNE_PREFIX = ("it", "sh", "tm")


def beach_assets() -> Dict[str, str]:
    """Plage « PMD Sky » en calques (textures canoniques fournies) + logo généré + nuages de la chute :
    beachSea = ciel + mer SANS bulles · beachBubbles = bulles seules (animées en boucle) · beachSand = sable/écume/rochers · pmdLogo = logo « Pokémon Mystery Dungeon : Destiny » (généré) · skyCloud = nuages générés."""
    BL.build(); BL.logo(); BL.skyfall(); BL.meteor()
    out: Dict[str, str] = {}
    for key, fn in (("beachSea", "beach_sea_clean"), ("beachBubbles", "beach_bubbles"), ("beachSand", "beach_sand_pmdsky"), ("pmdLogo", "pmd_logo_destiny"), ("skyCloud", "skyfall_clouds_layer"), ("meteor", "meteor_layer")):
        im = Image.open(BRUTS / f"{fn}.png")
        if im.mode == "RGBA":
            a = np.asarray(im)
            assert set(np.unique(a[..., 3]).tolist()) <= {0, 255}, f"alpha non binaire : {key}"
        else:
            im = im.convert("RGB")
        out[key] = SPR.uri_im(im, "WEBP", lossless=True)
    return out


def build_assets() -> Dict[str, object]:
    a = SPR.build_assets()
    b = VOY.build_assets()
    b["imgs"].update(beach_assets())
    imgs: Dict[str, str] = dict(a["imgs"])
    for k, v in b["imgs"].items():
        if k in imgs and imgs[k] != v:
            raise SystemExit(f"collision de clé image : {k}")
        imgs[k] = v
    for k in list(imgs):
        if k in PRUNE or (k[:2] in PRUNE_PREFIX and k[2:].isdigit()):
            del imgs[k]
    sheets = dict(a["sheets"])
    sheets.update(b["sheets"])
    manifest = json.loads((ASSETS_DIR / "manifest.json").read_text(encoding="utf-8"))
    cat_all = manifest["pmd_catalog"]["pokemon"]
    pokemon: Dict[str, dict] = {}
    for src in (a["catalog"]["pokemon"], b["catalog"]["pokemon"]):
        for pid, P in src.items():
            q = pokemon.setdefault(pid, {"name": P["name"], "anims": {}})
            q["anims"].update(P["anims"])
    for pid, names in EXTRA_ACTORS.items():
        q = pokemon.setdefault(pid, {"name": cat_all[pid].get("name", pid), "anims": {}})
        for n in names:
            if n in q["anims"] or n not in cat_all[pid]["anims"]:
                continue
            m = cat_all[pid]["anims"][n]
            sheets[m["file"]] = SPR.uri_png(ASSETS_DIR / "pmd_sprites" / m["file"])
            q["anims"][n] = {k: m[k] for k in ("file", "fw", "fh", "cols", "rows", "durations")}
    cat = {"pokemon": pokemon, "antic": a["catalog"]["antic"], "vfx": a["catalog"]["vfx"]}
    return {"imgs": imgs, "sheets": sheets, "catalog": cat}


SKYFALL_JS = r"""
    // ---- chute dans le ciel (plan 5a) : décor GÉNÉRÉ multicalque — dégradé de ciel + 3 couches de nuages qui filent vers le haut (échelles/vitesses différentes, bouclage sans raccord) ----
    function skyFallDecor(ctx, t) {
      const u = Math.max(0, t - 106), cl = I.skyCloud, cw = cl.width, ch = cl.height;
      const g = ctx.createLinearGradient(0, -260, 0, 560); g.addColorStop(0, 'rgb(34,74,190)'); g.addColorStop(0.45, 'rgb(96,170,240)'); g.addColorStop(1, 'rgb(206,232,255)');
      ctx.fillStyle = g; ctx.fillRect(-520, -320, 1700, 960);
      [[0.2, 34, 0.6, false, 0], [0.32, 78, 0.85, true, 120], [0.52, 170, 1, false, 260]].forEach((L, li) => { // [échelle, vitesse, alpha, miroir, déphasage]
        const s = L[0], w = cw * s, h = ch * s, off = (u * L[1] * (1 + 0.5 * sstep(u / 3)) + L[4]) % h;
        ctx.save(); ctx.globalAlpha = L[2]; ctx.imageSmoothingEnabled = false;
        for (let iy = -1; -300 + iy * h - off < 520; iy++) for (let ix = 0; -500 + ix * w < 1080; ix++) {
          const x = -500 + ix * w + li * 53, y = -300 + iy * h - off;
          if (L[3]) { ctx.save(); ctx.translate(x + w, y); ctx.scale(-1, 1); ctx.drawImage(cl, 0, 0, w, h); ctx.restore(); } else ctx.drawImage(cl, x, y, w, h);
        }
        ctx.restore();
      });
    }
    function handLinks(ctx, t, c) { // le trio se tient par la main : éclat de lumière à chaque main jointe + fil lumineux
      const e = sstep((t - 106.3) / 1.0) * (1 - sstep((t - 117.6) / 0.8)); if (e <= 0.003) return;
      [[-15, -16], [15, -15]].forEach((p, i) => { const x = c.cx + p[0], y = c.cy + p[1] + Math.sin(t * 5 + i) * 1.2; glow(ctx, x, y, 16, '255,236,170', 0.8 * e); fx(ctx, 'sparkle', (t * 12 + i * 3) % 8, x, y, 0.35, e, { add: true }); });
      ctx.save(); ctx.globalCompositeOperation = 'lighter'; ctx.strokeStyle = 'rgba(255,240,190,' + (0.55 * e).toFixed(3) + ')'; ctx.lineWidth = 1.2; ctx.beginPath(); ctx.moveTo(c.cx - 30, c.cy - 14); ctx.quadraticCurveTo(c.cx, c.cy - 8 + Math.sin(t * 4) * 1.5, c.cx + 30, c.cy - 12); ctx.stroke(); ctx.restore();
    }
"""


def patch_skyfall(spr: str) -> str:
    old = "    function drawMap(ctx, key, t, water) {\n      const im = I[key];"
    assert old in spr, "drawMap introuvable"
    spr = spr.replace(old, SKYFALL_JS + "    function drawMap(ctx, key, t, water) {\n      if (key === 'opm4' && t >= 105.5 && t < 122 && I.skyCloud && I.skyCloud.width) { skyFallDecor(ctx, t); return; }\n      const im = I[key];", 1)
    w = "world(ctx, t, c, ph) { if (ph !== 'over') return; const k = sstep((t - 115) / 3);"
    assert w in spr, "monde 5a introuvable"
    spr = spr.replace(w, "world(ctx, t, c, ph) { if (ph !== 'over') return; handLinks(ctx, t, c); const k = sstep((t - 115) / 3);", 1)
    return patch_ending(spr)


ENDING_PATCHES: list = []  # les gestes de la fin (réveil, hélice, trio Riolu · Évoli · Tiplouf) sont désormais dans le moteur sprites


def patch_ending(spr: str) -> str:
    for a, b in ENDING_PATCHES:
        assert a in spr, "geste de fin introuvable : " + a[:60]
        spr = spr.replace(a, b, 1)
    return spr


def engine_source() -> str:
    voy, spr, ult = (p.read_text(encoding="utf-8") for p in ENGINES)
    old = "OC: 0.8,"
    assert old in spr, "XF.OC introuvable dans le moteur sprites"
    spr = spr.replace(old, "OC: 0,", 1)  # plus de fondu depuis le plan « chute » (supprimé) : l'océan arrive après le flash blanc de la course lunaire
    spr = patch_skyfall(spr)
    return "\n".join((voy, spr, ult))


def build_html() -> Path:
    assets = build_assets()
    tpl = TEMPLATE.read_text(encoding="utf-8")
    assert "/*__ENGINE__*/" in tpl and "/*__ASSETS__*/" in tpl
    html = tpl.replace("/*__ENGINE__*/", engine_source()).replace("/*__ASSETS__*/", json.dumps(assets, ensure_ascii=False, separators=(",", ":")))
    OUT_HTML.write_text(html, encoding="utf-8")
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    meta = {
        "duration_seconds": DURATION_S, "reference_video": "2aafI3XvKxo (Simple and Clean -Ray of Hope MIX-, 02:33)",
        "resolution": [1280, 720], "fps": 60,
        "timeline": {"voyage": [0, 31], "course_lunaire": [31, 46], "opening_sprites": [46, 153]},
        "sprites_clip_kept": [46.0, 68.0], "actors": sorted(set(SPR.ACTORS) | set(VOY.ACTORS) | set(EXTRA_ACTORS)),
        "sheets": len(assets["sheets"]), "html_bytes": OUT_HTML.stat().st_size,
    }
    (OUT_DIR / "metadata.json").write_text(json.dumps(meta, ensure_ascii=False, indent=2), encoding="utf-8")
    return OUT_HTML


if __name__ == "__main__":
    out = build_html()
    print(f"[Opening Ultime] {out.name} : {out.stat().st_size / 1024:.0f} Ko — durée {DURATION_S:.2f}s (02:33)")
