#!/usr/bin/env python3
"""Intro « halo arc-en-ciel » — inspirée de l'intro Arceus de Pokémon Relict.

Référence étudiée : ``Relict/Relict V1.2/.../ArcyGame/ArceusRing.rb`` (dépôt
``meromoonmeri/BIBLIOTHEQUE``) — scène ``ArceusIntroScene`` : fond noir avec
halo doré radial, « shine » (soleil à rayons) qui tourne et respire
(opacité +8/δ, angle +2/δ, zoom amorti 0,8↔1,2), anneaux « glow » expansifs
(2 max, cadence 200 frames, zoom 0,2 → +0,01/δ, fondu +4/δ puis −4/δ), 24
particules additives qui migrent des bords vers l'intérieur en s'estompant.

Notre version : **même mécanique** (vitesses et cadences reprises telles
quelles, δ = 3 à 60 img/s) mais le halo est **arc-en-ciel** au lieu d'or.
Les pièces (fond, shine, anneau, particules) sont les **textures de la
référence recolorées** : la texture d'origine est conservée exactement
(même carte de luminance/opacité — rayons, douceur), seule la teinte devient
un arc-en-ciel conique à cœur blanc. Source :
``Relict/Relict V1.2/Relict/Graphics/EBDX/Transitions/Arceus/``
(``background/shine/glow/particle0/1.png``, dépôt ``meromoonmeri/BIBLIOTHEQUE``)
— crédit **Pokémon Relict**. La figure centrale est le blason Œuf Ailé de
l'opening PMD Destiny (art de l'utilisateur).

Sorties (dans ``apercus/intro_halo/``) : ``halo_fond.png``, ``halo_shine.png``,
``halo_anneau.png``, ``halo_particule0/1.png``, ``figure_oeuf_ailes.png`` +
``apercu_intro_halo_arcenciel.html`` (scène animée pour la visionneuse).

Usage : .venv/bin/python OUTILS/generer_intro_halo_arcenciel.py
"""
from __future__ import annotations

import math
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageFilter

R = Path(__file__).resolve().parents[1]
OUT = R / 'apercus' / 'intro_halo'
PAGE = R / 'apercu_intro_halo_arcenciel.html'
SRC_OEUF = Path('/tmp/destiny-logo/source/pmd_destiny_fangame_v1/references/clean_badge_oeuf_ailes_pmd.png')


# ------------------------------- textures (crédit : Pokémon Relict)

REF_RELIC = Path('/tmp/relic_arceus')
# En cas de perte de /tmp : retélécharger les 5 textures depuis
# meromoonmeri/BIBLIOTHEQUE → Relict/Relict V1.2/Relict/Graphics/EBDX/
# Transitions/Arceus/{background,shine,glow,particle0,particle1}.png
# et les placer dans /tmp/relic_arceus/.


def hsv_vers_rgb(h: np.ndarray, s: np.ndarray, v: np.ndarray) -> np.ndarray:
    """HSV → RGB vectorisé (tableaux 2D, sortie (…, 3))."""
    i = np.floor(h * 6).astype(int) % 6
    f = h * 6 - np.floor(h * 6)
    p = v * (1 - s)
    q = v * (1 - f * s)
    t = v * (1 - (1 - f) * s)
    rgb = np.zeros(h.shape + (3,))
    for k, (rv, gv, bv) in enumerate([(v, t, p), (q, v, p), (p, v, t),
                                      (p, q, v), (t, p, v), (v, p, q)]):
        m = i == k
        rgb[..., 0] = np.where(m, rv, rgb[..., 0])
        rgb[..., 1] = np.where(m, gv, rgb[..., 1])
        rgb[..., 2] = np.where(m, bv, rgb[..., 2])
    return rgb


def recolorer(ref: str, sortie: Path) -> None:
    """Recolore une texture de l'intro Relict en halo arc-en-ciel.

    La texture d'origine est conservée **à l'identique** (même carte de
    luminance/opacité : rayons, douceur, éclipsions) — seule la teinte
    change : arc-en-ciel conique selon l'angle autour du centre, cœur
    blanc là où la texture est la plus lumineuse (cœur doré → cœur blanc).
    """
    src = Image.open(REF_RELIC / ref).convert('RGBA')
    a = np.asarray(src).astype(np.float32) / 255.0
    r, g, b, al = a[..., 0], a[..., 1], a[..., 2], a[..., 3]
    lum = 0.299 * r + 0.587 * g + 0.114 * b
    h_img, w_img = al.shape
    yy, xx = np.mgrid[0:h_img, 0:w_img]
    cy, cx = (h_img - 1) / 2.0, (w_img - 1) / 2.0
    ang = (np.arctan2(yy - cy, xx - cx) / (2 * np.pi) + 1.0) % 1.0
    opaque = bool(al.min() > 0.99)  # background = glow peint sur noir
    if opaque:
        t = lum / max(float(lum.max()), 1e-6)   # texture du glow normalisée
    else:
        t = al * np.clip(lum, 0, 1)             # forme dans l'alpha
    sat = np.clip(1.0 - np.clip((t - 0.55) / 0.40, 0, 1), 0, 1) * 0.92
    val = np.clip(t * 1.3, 0, 1) if opaque else np.clip(lum, 0, 1)
    rgb = hsv_vers_rgb(ang, sat, val)
    img = np.zeros((h_img, w_img, 4), np.uint8)
    img[..., :3] = np.clip(rgb * 255, 0, 255).astype(np.uint8)
    img[..., 3] = 255 if opaque else (al * 255).astype(np.uint8)
    Image.fromarray(img, 'RGBA').save(sortie)


# ----------------------------------------------------------------- page

def page_html() -> str:
    return """<!doctype html><html lang="fr"><head><meta charset="utf-8">
<title>Intro PMD Destiny — halo arc-en-ciel</title>
<style>
body { background:#05050a; color:#ddd; font:15px/1.5 system-ui,sans-serif; max-width:1060px; margin:16px auto; padding:0 12px }
a { color:#ffd76a } small { color:#888 }
h1 { font-size:23px; color:#fff }
.bar { display:flex; gap:10px; align-items:center; flex-wrap:wrap; margin:10px 0 }
button { background:#22203a; color:#eee; border:1px solid #5b52a0; border-radius:8px; padding:6px 14px; cursor:pointer }
button:hover { filter:brightness(1.2) }
.scenewrap { position:relative; width:640px; max-width:100%; border:1px solid #2a2740; border-radius:10px; overflow:hidden }
canvas { display:block; width:100%; image-rendering:auto }
.flavor { position:absolute; left:0; right:0; bottom:16px; text-align:center; z-index:5; pointer-events:none }
.flavor .boite { display:inline-block; background:#0c0a1ad9; border:1px solid #6a5fc0; border-radius:10px;
  padding:8px 18px; font-size:14px; color:#eee }
.note { background:#141222; border:1px solid #2a2740; border-radius:8px; padding:10px 14px; margin:12px 0 }
</style></head><body>
<p><a href="/">← Index de la visionneuse</a> ·
<a href="apercu_quiz_destiny_15_questions.html">Quiz de personnalité</a> ·
<a href="apercu_badge_quiz_natures.html">Badges par nature</a></p>
<h1>Intro PMD Destiny — halo arc-en-ciel</h1>
<p>Même mise en scène que l'intro Arceus de <b>Pokémon Relict</b> (halo sur fond
noir, soleil à rayons rotatif, anneaux expansifs, particules additives) — mais
le halo est <b>arc-en-ciel</b>. Mécanique reprise d'après
<code>ArceusRing.rb</code> (δ = 3, 60 img/s) ; <b>textures de Pokémon Relict
recolorées arc-en-ciel</b> en conservant exactement leur texture d'origine
(<code>OUTILS/generer_intro_halo_arcenciel.py</code>) — crédit
<b>Pokémon Relict</b>.</p>

<div class="bar">
  <button id="pause">Pause</button>
  <button id="replay">Rejouer</button>
  <small id="etat"></small>
</div>
<div class="scenewrap">
  <canvas id="sc" width="640" height="480"></canvas>
  <div class="flavor"><div class="boite" id="texte"></div></div>
</div>

<div class="note"><b>Ce que reproduit la scène</b> (comme dans
<code>ArceusIntroScene</code>) : halo radial arc-en-ciel · « shine » qui tourne
à 40°/s avec respiration amortie (zoom 0,8↔1,2, gain × −0,1 à chaque
inversion) · 2 anneaux expansifs max (cadence 200 frames, zoom 0,2 → +0,01/δ,
fondu +4/δ puis −4/δ, perpétuels) · 24 particules additives migrantes
(vitesse 0,1–1,6, estompage 0,5×vitesse/frame) · fondu d'entrée.
<b>Figure centrale</b> : blason Œuf Ailé de l'opening PMD Destiny (art de
l'utilisateur).
Citation de conception et textures : scène d'intro de <b>Pokémon Relict</b>
(<code>meromoonmeri/BIBLIOTHEQUE</code>, <code>ArceusRing.rb</code>).</div>

<script>
const cv = document.getElementById('sc'), g = cv.getContext('2d');
const imgs = {};
for (const n of ['halo_fond', 'halo_shine', 'halo_anneau', 'halo_particule0', 'halo_particule1',
                 'figure_oeuf_ailes']) {
  const im = new Image(); im.src = 'apercus/intro_halo/' + n + '.png'; imgs[n] = im;
}
// --- constantes reprises de ArceusRing.rb (delta = 3, 60 img/s)
const DELTA = 3;
const TEXTES = [
  [0,   ' '],
  [60,  'Bienvenue dans l’un de mes royaumes…'],
  [260, 'Je suis celle que les humains appellent l’Arc-en-Ciel.'],
  [520, 'Bientôt, tu te retrouveras dans un lieu qui t’est étranger…'],
  [800, 'Trouve-moi… et ensemble, nous rétablirons ce qui a dévié.'],
];

let tick = 0, paused = false, held = 0;
const shine = { op: 0, angle: 0, zoom: 1, toggle: 1 };
let rings = [], ringTimer = 8, nextZoom = 0.2;
const NP = 24;
const parts = [];
function refreshPart(p) {
  p.op = 255;
  const dx = 320, dy = 240;
  const x = Math.random() * (dx * 2 + 128) - 64;
  const y = Math.random() * (dy * 2 + 128) - 64;
  const x1 = Math.random() < 0.5 ? -Math.random() * 32 : dx * 2 + Math.random() * 32;
  const y1 = dy - 46 + Math.random() * 92;
  p.pos = [x, y];
  p.px = x1; p.py = y1;
  p.speed = (Math.floor(Math.random() * 16) + 1) * 0.1;
  p.img = Math.random() < 0.5 ? 0 : 1;
}
for (let i = 0; i < NP; i++) {
  const p = { delay: Math.floor(Math.random() * NP), frame: 0, visible: false };
  refreshPart(p); parts.push(p);
}

function update() {
  // shine (ArceusIntroScene#update)
  if (shine.op < 255) shine.op += 8 / DELTA;
  shine.angle += 2 / DELTA;
  shine.zoom -= 0.01 * shine.toggle / DELTA;
  if (shine.zoom <= 0.8 || shine.zoom >= 1.2) shine.toggle *= -0.1;
  // anneaux
  if (ringTimer <= 0 && rings.length < 2) {
    rings.push({ zoom: nextZoom, op: 0, fadingIn: true, initial: nextZoom });
    nextZoom += 0.02;
    ringTimer = 200;
  } else ringTimer--;
  for (const r of rings) {
    r.zoom += 0.01 / DELTA;
    if (r.fadingIn) { r.op += 4 / DELTA; if (r.op >= 255) r.fadingIn = false; }
    else { r.op -= 4 / DELTA; if (r.op <= 0) { r.zoom = r.initial; r.op = 0; r.fadingIn = true; } }
  }
  // particules (AnimatedSpriteParticle#update, inverted = false)
  for (const p of parts) {
    p.frame++;
    if (p.frame < p.delay) continue;
    p.visible = true;
    p.px -= (p.pos[0] - p.px) * (0.002 * p.speed);
    p.py -= (p.pos[1] - p.py) * (0.002 * p.speed);
    p.op -= 0.5 * p.speed;
    if (p.op <= 0) refreshPart(p);
  }
}

function draw() {
  g.clearRect(0, 0, 640, 480);
  g.fillStyle = '#000'; g.fillRect(0, 0, 640, 480);
  const fond = imgs.halo_fond;
  if (fond.complete) g.drawImage(fond, 0, 0, 640, 480);
  // anneaux (derrière)
  for (const r of rings) {
    const im = imgs.halo_anneau;
    g.globalAlpha = Math.max(0, Math.min(1, r.op / 255));
    const w = im.width * r.zoom, h = im.height * r.zoom;
    g.drawImage(im, 320 - w / 2, 240 - h / 2, w, h);
  }
  g.globalAlpha = 1;
  // particules additives
  g.globalCompositeOperation = 'lighter';
  for (const p of parts) {
    if (!p.visible) continue;
    const im = imgs[p.img ? 'halo_particule1' : 'halo_particule0'];
    g.globalAlpha = Math.max(0, Math.min(1, p.op / 255));
    g.drawImage(im, p.px - im.width / 2, p.py - im.height / 2);
  }
  // shine rotatif (additif)
  const sh = imgs.halo_shine;
  g.save();
  g.translate(320, 240);
  g.rotate(shine.angle * Math.PI / 180);
  g.globalAlpha = Math.max(0, Math.min(1, shine.op / 255));
  const sw = sh.width * shine.zoom, shh = sh.height * shine.zoom;
  g.drawImage(sh, -sw / 2, -shh / 2, sw, shh);
  g.restore();
  g.globalCompositeOperation = 'source-over';
  g.globalAlpha = 1;
  // figure centrale : blason Œuf Ailé de l'opening (art de l'utilisateur)
  const fig = imgs['figure_oeuf_ailes'];
  if (fig.complete && fig.naturalWidth) {
    const fh = 330, fw = fh * fig.naturalWidth / fig.naturalHeight;
    g.drawImage(fig, 320 - fw / 2, 268 - fh / 2, fw, fh);
  }
  // fondu d'entrée (pbFadeInAndShow) : 60 premières frames
  if (tick < 60) {
    g.fillStyle = 'rgba(0,0,0,' + (1 - tick / 60) + ')';
    g.fillRect(0, 0, 640, 480);
  }
}

function texteCourant() {
  let t = ' ';
  for (const [debut, txt] of TEXTES) if (tick >= debut) t = txt;
  document.getElementById('texte').textContent = t;
}

let last = -1;
function frame(now) {
  const t = Math.floor((paused ? held : now - start) / 1000 * 60);
  if (!paused && t !== last) {
    for (let k = last + 1; k <= t; k++) { update(); tick++; }
    last = t;
    draw(); texteCourant();
    document.getElementById('etat').textContent =
      'tick ' + tick + ' · shine ' + shine.op.toFixed(0) + ' · zoom ' + shine.zoom.toFixed(3) +
      ' · anneaux ' + rings.length;
  }
  requestAnimationFrame(frame);
}
let start = performance.now();
document.getElementById('pause').onclick = e => {
  if (paused) { start = performance.now() - held; paused = false; e.target.textContent = 'Pause'; }
  else { held = performance.now() - start; paused = true; e.target.textContent = 'Reprendre'; }
};
document.getElementById('replay').onclick = () => {
  tick = 0; last = -1; shine.op = 0; shine.angle = 0; shine.zoom = 1; shine.toggle = 1;
  rings = []; ringTimer = 8; nextZoom = 0.2;
  for (const p of parts) { p.frame = 0; p.visible = false; refreshPart(p); }
  start = performance.now();
};
requestAnimationFrame(frame);
</script>
</body></html>
"""


def main() -> int:
    OUT.mkdir(parents=True, exist_ok=True)
    if not REF_RELIC.exists():
        print(f'  (!) dossier de textures Relict absent : {REF_RELIC}')
        print('      retélécharger depuis meromoonmeri/BIBLIOTHEQUE → Relict/'
              'Relict V1.2/Relict/Graphics/EBDX/Transitions/Arceus/')
        return 1
    for ref, nom, lbl in [
            ('background.png', 'halo_fond.png', 'fond radial'),
            ('shine.png', 'halo_shine.png', 'soleil à rayons'),
            ('glow.png', 'halo_anneau.png', 'anneau rayonnant'),
            ('particle0.png', 'halo_particule0.png', 'particule 0'),
            ('particle1.png', 'halo_particule1.png', 'particule 1')]:
        if not (REF_RELIC / ref).exists():
            print(f'  (!) texture Relict absente : {REF_RELIC / ref}')
            return 1
        recolorer(ref, OUT / nom)
        print(f'  {nom} ({lbl} — texture Relict recolorée)')
    # variante figure : blason Œuf Ailé de l'opening (art utilisateur)
    if SRC_OEUF.exists():
        im = Image.open(SRC_OEUF).convert('RGB')
        arr = np.array(im)
        mask = (arr[..., 0] > 235) & (arr[..., 1] > 235) & (arr[..., 2] > 235)
        rgba = np.dstack([arr, np.where(mask, 0, 255).astype(np.uint8)])
        Image.fromarray(rgba, 'RGBA').save(OUT / 'figure_oeuf_ailes.png')
        print('  figure_oeuf_ailes.png (Œuf Ailé, fond retiré)')
    else:
        print('  (!) source Œuf Ailé absente — variante non générée')
    PAGE.write_text(page_html(), encoding='utf-8')
    print(f'  page → {PAGE}')
    print('Terminé.')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
