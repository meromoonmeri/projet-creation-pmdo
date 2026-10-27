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
Les pièces (fond, shine, anneau, particules) sont **dessinées par le script**
(numpy/PIL) — aucune image de Relict copiée ni recolorée. La figure centrale
est générée (art IA, ``apercus/intro_halo/figure_deesse.png``, art_approved :
false) avec en variante le blason Œuf Ailé de l'opening PMD Destiny.

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


# ----------------------------------------------------------------- dessins

def hsv(h: float, s: float, v: float) -> tuple[int, int, int]:
    import colorsys
    r, g, b = colorsys.hsv_to_rgb(h % 1.0, s, v)
    return int(r * 255), int(g * 255), int(b * 255)


def halo_fond(w: int = 640, h: int = 480) -> None:
    """Halo radial arc-en-ciel : teinte par angle (roue), cœur blanc chaud."""
    yy, xx = np.mgrid[0:h, 0:w]
    cx, cy = w / 2, h / 2
    ang = (np.arctan2(yy - cy, xx - cx) / (2 * np.pi)) + 0.5
    dist = np.sqrt((xx - cx) ** 2 + (yy - cy) ** 2) / (w * 0.42)
    # teinte conique douce (arc-en-ciel) + valeur/blanc par rayon
    import colorsys
    hue = (ang + 0.72) % 1.0
    sat = np.clip(dist * 1.6, 0, 1) * 0.55
    val = np.exp(-(dist ** 1.7) * 2.2)
    # hsv → rgb vectorisé
    i = np.floor(hue * 6).astype(int) % 6
    f = hue * 6 - np.floor(hue * 6)
    p = val * (1 - sat)
    q = val * (1 - f * sat)
    t = val * (1 - (1 - f) * sat)
    rgb = np.zeros((h, w, 3))
    for k, (rv, gv, bv) in enumerate([(val, t, p), (q, val, p), (p, val, t),
                                      (p, q, val), (t, p, val), (val, p, q)]):
        m = i == k
        rgb[..., 0] = np.where(m, rv, rgb[..., 0])
        rgb[..., 1] = np.where(m, gv, rgb[..., 1])
        rgb[..., 2] = np.where(m, bv, rgb[..., 2])
    img = np.zeros((h, w, 4), dtype=np.uint8)
    img[..., :3] = np.clip(rgb * 255, 0, 255).astype(np.uint8)
    img[..., 3] = np.clip(val * 255, 0, 255).astype(np.uint8)
    Image.fromarray(img, 'RGBA').filter(ImageFilter.GaussianBlur(6)).save(OUT / 'halo_fond.png')


def halo_shine(size: int = 320) -> None:
    """Soleil à rayons arc-en-ciel (remplace le « shine » doré), cœur blanc."""
    s = size * 4
    img = Image.new('RGBA', (s, s), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    c = s / 2
    rays = 18
    for r in range(rays):
        a0 = (r / rays) * 2 * math.pi
        length = s * (0.46 if r % 2 == 0 else 0.34)
        wide = math.pi / rays * 0.72
        col = hsv(r / rays, 0.55, 1.0)
        pts = [(c, c)]
        for k in range(9):
            a = a0 - wide + (2 * wide) * k / 8
            ll = length * (0.92 + 0.08 * math.sin(k * 2.1 + r))
            pts.append((c + math.cos(a) * ll, c + math.sin(a) * ll))
        d.polygon(pts, fill=col + (255,))
    # cœur blanc chaud
    for rad, al in ((s * 0.20, 255), (s * 0.13, 255)):
        d.ellipse([c - rad, c - rad, c + rad, c + rad], fill=(255, 255, 255, al))
    img = img.filter(ImageFilter.GaussianBlur(s * 0.012))
    img.resize((size, size), Image.LANCZOS).save(OUT / 'halo_shine.png')


def halo_anneau(size: int = 392) -> None:
    """Anneau rayonnant arc-en-ciel (remplace le « glow » doré)."""
    s = size * 3
    yy, xx = np.mgrid[0:s, 0:s]
    c = s / 2
    dist = np.sqrt((xx - c) ** 2 + (yy - c) ** 2) / c
    ang = ((np.arctan2(yy - c, xx - c) / (2 * np.pi)) + 0.5)
    # anneau : rayon 0.42-0.98, texture radiale fine
    ring = np.exp(-((dist - 0.68) ** 2) / (2 * 0.16 ** 2))
    streak = 0.82 + 0.18 * np.sin(ang * 2 * np.pi * 90 + dist * 40)
    alpha = np.clip(ring * streak, 0, 1)
    hue = (ang + 0.72) % 1.0
    sat = 0.55 * np.clip((dist - 0.30) * 2, 0, 1)
    val = np.ones_like(dist)
    i = np.floor(hue * 6).astype(int) % 6
    f = hue * 6 - np.floor(hue * 6)
    p = val * (1 - sat); q = val * (1 - f * sat); t = val * (1 - (1 - f) * sat)
    rgb = np.zeros((s, s, 3))
    for k, (rv, gv, bv) in enumerate([(val, t, p), (q, val, p), (p, val, t),
                                      (p, q, val), (t, p, val), (val, p, q)]):
        m = i == k
        rgb[..., 0] = np.where(m, rv, rgb[..., 0])
        rgb[..., 1] = np.where(m, gv, rgb[..., 1])
        rgb[..., 2] = np.where(m, bv, rgb[..., 2])
    img = np.zeros((s, s, 4), dtype=np.uint8)
    img[..., :3] = np.clip(rgb * 255, 0, 255).astype(np.uint8)
    img[..., 3] = np.clip(alpha * 255, 0, 255).astype(np.uint8)
    Image.fromarray(img, 'RGBA').filter(ImageFilter.GaussianBlur(2.5)) \
        .resize((size, size), Image.LANCZOS).save(OUT / 'halo_anneau.png')


def halo_particule(size: int, nom: str) -> None:
    """Boule de lumière additive (cœur blanc, frange arc-en-ciel)."""
    s = size * 4
    yy, xx = np.mgrid[0:s, 0:s]
    c = s / 2
    dist = np.sqrt((xx - c) ** 2 + (yy - c) ** 2) / c
    ang = ((np.arctan2(yy - c, xx - c) / (2 * np.pi)) + 0.5)
    glow = np.exp(-(dist ** 2) * 3.2)
    hue = (ang + 0.72) % 1.0
    sat = 0.5 * np.clip(dist * 1.8, 0, 1)
    import colorsys
    rgb = np.zeros((s, s, 3))
    i = np.floor(hue * 6).astype(int) % 6
    f = hue * 6 - np.floor(hue * 6)
    val = np.ones_like(dist)
    p = val * (1 - sat); q = val * (1 - f * sat); t = val * (1 - (1 - f) * sat)
    for k, (rv, gv, bv) in enumerate([(val, t, p), (q, val, p), (p, val, t),
                                      (p, q, val), (t, p, val), (val, p, q)]):
        m = i == k
        rgb[..., 0] = np.where(m, rv, rgb[..., 0])
        rgb[..., 1] = np.where(m, gv, rgb[..., 1])
        rgb[..., 2] = np.where(m, bv, rgb[..., 2])
    img = np.zeros((s, s, 4), dtype=np.uint8)
    img[..., :3] = np.clip(rgb * 255, 0, 255).astype(np.uint8)
    img[..., 3] = np.clip(glow * 255, 0, 255).astype(np.uint8)
    Image.fromarray(img, 'RGBA').resize((size, size), Image.LANCZOS).save(OUT / nom)


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
<code>ArceusRing.rb</code> (δ = 3, 60 img/s) ; aucun graphisme de Relict copié
(pièces dessinées par <code>OUTILS/generer_intro_halo_arcenciel.py</code>).</p>

<div class="bar">
  <button id="pause">Pause</button>
  <button id="replay">Rejouer</button>
  <button id="figure">Figure : déesse générée</button>
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
<b>Figure centrale</b> : art généré (« déesse créatrice », <i>art_approved :
false</i>) ou blason Œuf Ailé de l'opening PMD Destiny (art de l'utilisateur).
Citation de conception : scène d'intro de <b>Pokémon Relict</b>
(<code>meromoonmeri/BIBLIOTHEQUE</code>, <code>ArceusRing.rb</code>).</div>

<script>
const cv = document.getElementById('sc'), g = cv.getContext('2d');
const imgs = {};
for (const n of ['halo_fond', 'halo_shine', 'halo_anneau', 'halo_particule0', 'halo_particule1',
                 'figure_deesse', 'figure_oeuf_ailes']) {
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

let tick = 0, paused = false, held = 0, useDeesse = true;
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
  // figure centrale
  const fig = imgs[useDeesse ? 'figure_deesse' : 'figure_oeuf_ailes'];
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
document.getElementById('figure').onclick = e => {
  useDeesse = !useDeesse;
  e.target.textContent = useDeesse ? 'Figure : déesse générée' : 'Figure : Œuf Ailé (opening)';
};
requestAnimationFrame(frame);
</script>
</body></html>
"""


def main() -> int:
    OUT.mkdir(parents=True, exist_ok=True)
    halo_fond()
    print('  halo_fond.png (radial arc-en-ciel)')
    halo_shine()
    print('  halo_shine.png (soleil à rayons)')
    halo_anneau()
    print('  halo_anneau.png (anneau rayonnant)')
    halo_particule(22, 'halo_particule0.png')
    halo_particule(40, 'halo_particule1.png')
    print('  halo_particule0/1.png')
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
