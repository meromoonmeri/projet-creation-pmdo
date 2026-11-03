#!/usr/bin/env python3
"""Lot « animations de diva » — Team Dazzling (Lopunny, Tsareena, Mawile).

Produit, pour chaque espèce :

  * un **pack sprite importable** (`renders/diva_dazzling_v1/<slot>_<nom>/`) :
    `DivaX-Anim.png` / `-Offsets.png` / `-Shadow.png` (18 phases × 8 directions) et un
    `AnimData.xml` natif complété de l'animation ;
  * un **aperçu autonome** `apercu_diva_dazzling_v1.html` (aucune ressource externe) ;
  * un `verification.json` honnête : provenances, palette, boucle, repères.

    .venv/bin/python source/diva_dazzling_v1/build.py
"""
from __future__ import annotations

import base64
import io
import json
import sys
from datetime import datetime, timezone
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

from diva import REF, SPECIES, TICK, load, patch_animdata, write_pack  # noqa: E402
from gestures import ANIM_ID, TITLES, render  # noqa: E402

ROOT = HERE.parents[1]
OUT = ROOT / "renders" / "diva_dazzling_v1"
HTML = ROOT / "apercu_diva_dazzling_v1.html"
DIRS = ["Sud", "Sud-Est", "Est", "Nord-Est", "Nord", "Nord-Ouest", "Ouest", "Sud-Ouest"]

DESCRIPTIONS = {
    "0428": ("Salut aux pompons",
             "Ses deux pompons-mains s'ouvrent en éventail vers le haut, tenus par des bras fins "
             "qui naissent au buste ; deux éclats brillent au-dessus des mains levées, puis elle "
             "s'incline en révérence, oreilles comprises, avant de revenir au repos."),
    "0763": ("Éclosion royale",
             "Les deux fleurs de ses hanches montent en arc jusqu'à la hauteur des épaules, des "
             "pétales et un éclat s'ouvrent autour d'elles, la robe ondule d'un côté à l'autre "
             "puis elle salue d'une révérence de reine, sans jamais plier les jambes."),
    "0303": ("Clac de la diva",
             "Ses cornes-mâchoires s'écartent largement de part et d'autre du crâne, se "
             "referment d'un claquement sec accompagné d'un éclat, tandis que la tête se renverse "
             "en arrière pour un salut théâtral, puis tout revient au repos."),
}


def data_uri(img: Image.Image) -> str:
    buf = io.BytesIO()
    img.save(buf, format="PNG", optimize=True)
    return "data:image/png;base64," + base64.b64encode(buf.getvalue()).decode("ascii")


def sheet_image(frames: list[list[np.ndarray]], fw: int, fh: int) -> Image.Image:
    n = len(frames[0])
    sheet = Image.new("RGBA", (fw * n, fh * len(frames)))
    for d, row in enumerate(frames):
        for f, fr in enumerate(row):
            sheet.paste(Image.fromarray(fr), (f * fw, d * fh))
    return sheet


def check_pose(frames: list[list[np.ndarray]], sp) -> dict:
    """Contrôles factuels : provenance de la phase 0, palette, boucle, repères."""
    prov, pal_bad, loop, marker_bad = [], 0, [], 0
    for d in range(sp.dirs):
        native = sp.views[d].img
        prov.append(bool(np.array_equal(frames[d][0], native)) and bool(np.array_equal(frames[d][-1], native)))
        for fr in frames[d]:
            cols = {tuple(int(v) for v in c) for c in np.unique(fr[fr[:, :, 3] > 0][:, :3], axis=0)}
            pal_bad += len(cols - sp.native_cols)
    return {"phase0_identique_au_natif": all(prov), "directions_verifiees": sp.dirs,
            "couleurs_hors_palette_native": pal_bad,
            "boucle_fermee": all(np.array_equal(frames[d][0], frames[d][-1]) for d in range(sp.dirs))}


def build() -> Path:
    OUT.mkdir(parents=True, exist_ok=True)
    data: dict[str, dict] = {}
    verification: dict = {
        "lot": "diva_dazzling_v1",
        "date": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "source_sprites": "PMDCollab/SpriteCollab @ 3609a86be2a4c8ad7cf255bd2255f044daafe24f (Idle, 8 directions)",
        "phases": 18, "tick_par_phase": TICK, "art_approved": False, "runtime_tested": False,
        "especes": {},
    }
    for slot, name in SPECIES.items():
        sp = load(slot)
        frames, offsets = render(sp, n=18)
        pack_dir = OUT / f"{slot}_{name}"
        info = write_pack(sp, frames, offsets, ANIM_ID[slot], pack_dir,
                          dur=[TICK] * 18)
        patch_animdata(REF / f"{slot}_{name}" / "AnimData.xml", pack_dir / "AnimData.xml",
                       [info])
        chk = check_pose(frames, sp)
        # repères : toujours dans la frame et proches de leur position au repos
        # (les mains/fleurs d'une diva montent : plafond élargi pour ces deux repères)
        plafond = lambda k: 26 if k in ("right", "left") else 12
        marker_bad = 0
        for d in range(sp.dirs):
            base = sp.views[d].markers
            for f in range(18):
                for k, (x, y) in offsets[d][f].items():
                    if not (0 <= x < sp.fw and 0 <= y < sp.fh):
                        marker_bad += 1
                    elif k in base and (abs(base[k][0] - x) + abs(base[k][1] - y) > plafond(k)):
                        marker_bad += 1
        chk["reperes_hors_cadre_ou_aberrants"] = marker_bad
        chk["octets_anim"] = info["bytes"]
        verification["especes"][slot] = {"nom": name, "animation": ANIM_ID[slot], **chk}
        data[slot] = {
            "name": {"0428": "Lopunny", "0763": "Tsar(e)ena", "0303": "Mawile"}[slot],
            "gesture": TITLES[slot],
            "desc": DESCRIPTIONS[slot][1],
            "anim": ANIM_ID[slot],
            "fw": sp.fw, "fh": sp.fh, "dirs": sp.dirs, "frames": 18, "tick": TICK,
            "sheet": data_uri(sheet_image(frames, sp.fw, sp.fh)),
        }
        print(f"[diva] {slot} {name} — {ANIM_ID[slot]}: {info['frames']} phases × {sp.dirs} dir, "
              f"{info['bytes'] / 1024:.1f} Ko — palette hors native: {chk['couleurs_hors_palette_native']}, "
              f"phase 0 native: {chk['phase0_identique_au_natif']}")

    (OUT / "verification.json").write_text(json.dumps(verification, ensure_ascii=False, indent=2),
                                           encoding="utf-8")
    HTML.write_text(render_html(data, verification), encoding="utf-8")
    print(f"[diva] {HTML.name}: {HTML.stat().st_size / 1024:.0f} Ko")
    return HTML


# --------------------------------------------------------------------------- HTML
CSS = """
html,body{margin:0;background:#0a0d17;color:#e9eefc;font:15px/1.5 Verdana,Geneva,sans-serif}
header{padding:26px 20px 10px;text-align:center}
h1{margin:0 0 6px;font-size:26px;letter-spacing:.4px}
h1 small{display:block;font-size:13px;font-weight:400;color:#93a4cc;margin-top:6px;letter-spacing:0}
.note{max-width:980px;margin:10px auto 0;padding:12px 16px;border:1px solid #2a3552;border-radius:10px;
      background:#111726;color:#b9c6e6;font-size:13px}
.note b{color:#ffd479}
main{display:flex;flex-wrap:wrap;gap:18px;justify-content:center;padding:18px}
.card{width:min(96vw,760px);background:linear-gradient(180deg,#121a2c,#0d1320);border:1px solid #26314c;
      border-radius:16px;padding:16px;box-shadow:0 12px 30px #0006}
.card h2{margin:0;font-size:20px}
.card h2 span{font-size:13px;font-weight:400;color:#8fa2cc;margin-left:8px}
.card p{margin:6px 0 10px;color:#aebbd8;font-size:13px}
.stage{position:relative;border-radius:12px;overflow:hidden;border:1px solid #2a3552}
canvas{display:block;width:100%;height:auto;image-rendering:pixelated;background:transparent}
#cards canvas{height:52vh;width:auto;max-width:100%;margin:0 auto}
.ctrls{display:flex;flex-wrap:wrap;gap:8px;align-items:center;margin-top:10px}
button{background:#1b2540;color:#e9eefc;border:1px solid #3a4870;border-radius:9px;padding:6px 10px;
       font:bold 12px Verdana;cursor:pointer}
button:hover{background:#26334f}
button.on{background:#f4b942;color:#2a1a04;border-color:#a97a1a}
.dir{min-width:38px;text-align:center}
input[type=range]{accent-color:#f4b942}
.strip{display:grid;grid-template-columns:repeat(18,1fr);gap:2px;margin-top:10px}
.strip canvas{width:100%;height:auto;border:1px solid #222c46;border-radius:3px;cursor:pointer;background:#0b101c}
.strip canvas.cur{border-color:#f4b942;box-shadow:0 0 0 1px #f4b942}
.tag{font:11px Verdana;color:#7d8db4}
.legend{max-width:980px;margin:0 auto 40px;padding:0 20px;color:#8ea0c6;font-size:12px}
kbd{background:#1b2540;border:1px solid #3a4870;border-radius:5px;padding:1px 5px;font-size:11px}
"""

BODY = """
<header>
  <h1>Team Dazzling — animations de diva
    <small>Lopunny · Tsar(e)ena · Mawile — 18 phases × 8 directions, dessinées sur les sprites natifs</small>
  </h1>
  <div class="note">
    Chaque geste part de la <b>vraie image native</b> de la direction concernée (SpriteCollab épinglé) :
    les parties déplacées sont détectées par couleur native et connexité, le vide laissé est rendu
    transparent, les bras ajoutés ne peignent que des pixels vides avec les couleurs de la palette de
    l'espèce. <b>Aucune couleur inventée</b>, <b>aucun sprite de face pivoté</b>, <b>aucun miroir</b> :
    la phase 1 et la phase 18 sont pixel-identiques à l'image native. Aperçu, pas validation moteur.
  </div>
</header>
<main id="cards"></main>
<div class="legend">
  <p><b>Lecture :</b> la bande du bas montre les 18 phases ; cliquez une vignette pour figer une pose.
  Les flèches du clavier changent de direction, <kbd>espace</kbd> met en pause.
  Import : <code>Diva&lt;X&gt;-Anim.png</code> + <code>-Offsets.png</code> + <code>-Shadow.png</code> avec le
  <code>AnimData.xml</code> du même dossier (animation ajoutée à côté de l'<code>Idle</code> natif).</p>
  <p>Statut honnête : <code>art_approved = false</code>, <code>runtime_tested = false</code>. Aucune ouverture
  dans PMDO n'a été faite ; ces animations ne sont pas des ajouts approuvés à SpriteCollab.</p>
</div>
"""

JS = r"""
const DATA = __DATA__;
const VER = __VER__;
const DIRNAMES = __DIRNAMES__;

function mkCanvas(w, h) {
  const c = document.createElement('canvas');
  c.width = w; c.height = h; return c;
}

function makeCard(slot, d) {
  const card = document.createElement('section');
  card.className = 'card';
  card.innerHTML = '<h2>' + d.name + ' <span>' + d.gesture + ' — animation ' + d.anim +
    ' · ' + d.frames + ' phases × ' + d.dirs + ' dir · ' + d.fw + '×' + d.fh + ' px</span></h2>' +
    '<p>' + d.desc + '</p>';
  const stage = document.createElement('div'); stage.className = 'stage';
  stage.style.display = 'flex'; stage.style.justifyContent = 'center';
  const cv = mkCanvas(d.fw, d.fh);
  stage.appendChild(cv); card.appendChild(stage);
  const ctrls = document.createElement('div'); ctrls.className = 'ctrls';
  const bPlay = document.createElement('button'); bPlay.textContent = '⏸ Pause';
  const bRestart = document.createElement('button'); bRestart.textContent = '↺ Repos';
  const bPeak = document.createElement('button'); bPeak.textContent = '✦ Pose de diva';
  const speed = document.createElement('input'); speed.type = 'range'; speed.min = 20; speed.max = 200;
  speed.value = 100; speed.title = 'Vitesse';
  const time = document.createElement('span'); time.className = 'tag';
  ctrls.append(bPlay, bRestart, bPeak, speed, time);
  const dirs = document.createElement('div'); dirs.className = 'ctrls';
  const dirBtns = [];
  DIRNAMES.forEach((nm, i) => {
    const b = document.createElement('button'); b.className = 'dir';
    b.textContent = ['↓', '↘', '→', '↗', '↑', '↖', '←', '↙'][i];
    b.title = nm;
    b.onclick = () => { st.dir = i; st.frame = 0; st.playing = true; sync(); };
    dirBtns.push(b); dirs.appendChild(b);
  });
  card.append(ctrls, dirs);
  // bande des 18 phases
  const strip = document.createElement('div'); strip.className = 'strip';
  const thumbs = [];
  for (let f = 0; f < d.frames; f++) {
    const t = mkCanvas(d.fw, d.fh);
    t.title = 'phase ' + (f + 1) + ' — ' + (d.tick * (f)) + ' ticks';
    t.onclick = () => { st.playing = false; st.frame = f; sync(); };
    thumbs.push(t); strip.appendChild(t);
  }
  card.appendChild(strip);
  const st = { dir: 0, frame: 0, playing: true, t0: performance.now(), sheet: new Image() };
  st.sheet.onload = () => { drawThumbs(); sync(); };
  st.sheet.src = d.sheet;

  function drawThumbs() {
    const img = st.sheet;
    thumbs.forEach((t, f) => {
      const g = t.getContext('2d'); g.clearRect(0, 0, d.fw, d.fh);
      g.imageSmoothingEnabled = false;
      g.drawImage(img, f * d.fw, 0, d.fw, d.fh, 0, 0, d.fw, d.fh);
    });
  }
  const ctx = cv.getContext('2d');
  ctx.imageSmoothingEnabled = false;
  function sync() {
    dirBtns.forEach((b, i) => b.classList.toggle('on', i === st.dir));
    thumbs.forEach((t, i) => t.classList.toggle('cur', i === st.frame));
    bPlay.textContent = st.playing ? '⏸ Pause' : '▶ Lire';
    time.textContent = 'dir ' + DIRNAMES[st.dir] + ' · phase ' + (st.frame + 1) + '/' + d.frames;
  }
  bPlay.onclick = () => { st.playing = !st.playing; st.t0 = performance.now(); sync(); };
  bRestart.onclick = () => { st.playing = false; st.frame = 0; sync(); };
  bPeak.onclick = () => { st.playing = false; st.frame = peakFrame(slot); sync(); };
  const peak = 10; // phase de tenue : pompons/fleurs en haut, mâchoires ouvertes
  function peakFrame() { return peak; }
  window.__cards[slot] = {
    step(now) {
      if (st.playing) {
        const rate = Number(speed.value) / 100;
        st.frame = Math.floor(((now - st.t0) / (d.tick * 33.333) * rate)) % d.frames;
      }
      ctx.clearRect(0, 0, d.fw, d.fh);
      ctx.drawImage(st.sheet, st.frame * d.fw, st.dir * d.fh, d.fw, d.fh, 0, 0, d.fw, d.fh);
      sync();
    },
    nextDir(step) { st.dir = (st.dir + step + 8) % 8; st.frame = 0; st.playing = true; sync(); },
    toggle() { st.playing = !st.playing; st.t0 = performance.now(); sync(); },
  };
  return card;
}

window.__cards = {};
const cardsEl = document.getElementById('cards');
const order = ['0428', '0763', '0303'];
order.forEach(s => cardsEl.appendChild(makeCard(s, DATA[s])));

// fond de scène : damier discret dessiné dans le CSS du conteneur
document.querySelectorAll('.stage').forEach(el => {
  el.style.background = 'radial-gradient(circle at 50% 55%,#1b2437,#0b101c 70%)';
});

let lap = 0;
function loop(now) {
  clearTimeout(lap);
  Object.values(window.__cards).forEach(c => c.step(now));
  lap = setTimeout(() => requestAnimationFrame(loop), 33);
}
requestAnimationFrame(loop);

addEventListener('keydown', e => {
  if (e.code === 'Space') { e.preventDefault(); Object.values(window.__cards).forEach(c => c.toggle()); }
  if (e.code === 'ArrowRight') Object.values(window.__cards).forEach(c => c.nextDir(1));
  if (e.code === 'ArrowLeft') Object.values(window.__cards).forEach(c => c.nextDir(-1));
});
"""


def render_html(data: dict, verification: dict) -> str:
    js = (JS.replace("__DATA__", json.dumps(data, separators=(",", ":")))
            .replace("__VER__", json.dumps({k: v for k, v in verification.items() if k != "especes"},
                                           separators=(",", ":")))
            .replace("__DIRNAMES__", json.dumps(DIRS, ensure_ascii=False)))
    return ("<!DOCTYPE html>\n<html lang=\"fr\">\n<head>\n<meta charset=\"utf-8\" />\n"
            "<meta name=\"viewport\" content=\"width=device-width,initial-scale=1\" />\n"
            "<title>Team Dazzling — animations de diva (aperçu)</title>\n"
            f"<style>{CSS}</style>\n</head>\n<body>\n{BODY}\n"
            f"<script>{js}</script>\n</body>\n</html>\n")


if __name__ == "__main__":
    build()
