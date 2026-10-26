#!/usr/bin/env python3
"""Cinématique « Pichu & la Team Dazzling » — 5 minutes (300 s) dans la map native
`cliffdaytest.rsground` (« CliffReverietownnordest ») : Pichu sort de sa maison, hésite à
partir à l'aventure (boîtes de dialogue canoniques PMDO, portraits selon l'émotion), puis
la Team Dazzling — Loponny (Lockpin, la moqueuse un peu bête), Sucreine (Sucreine/leader
diva), Mystibul (Mysdibule, l'aigri) — fait son entrée en marchant/posant sur l'OST de la
référence (Beta's Theme), le bully, repart en posant une dernière fois, et laisse Pichu
pleurer en se convainquant qu'il est un froussard.

    .venv/bin/python source/cine_pichu_dazzling/build.py
"""
from __future__ import annotations

import base64
import io
import json
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

from PIL import Image

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
SC = ROOT / ".cache" / "spritecollab"
PLATES = HERE / "plates"
OUT_HTML = ROOT / "apercu_cine_pichu_team_dazzling.html"

# ---------------------------------------------------------------------------- espèces
CAST = {
    "0172": {"name": "Pichu"},
    "0428": {"name": "Sonata Loponny"},
    "0763": {"name": "Adagio Tsareen"},
    "0303": {"name": "Aria Mawile"},
}
ANIMS = {
    "0172": ["Walk", "Idle", "Sit", "Nod", "LookUp", "Hop", "Pose", "Pain", "Cringe", "EventSleep", "Wake", "DeepBreath"],
    "0428": ["Walk", "Idle", "Appeal", "Hop", "Double"],
    "0763": ["Walk", "Idle", "Kick", "Rotate", "Hop"],
    "0303": ["Walk", "Idle", "Strike", "Twirl", "Hop", "Cringe"],
}
EMOS = ["Normal", "Happy", "Joyous", "Angry", "Sad", "Crying", "Teary-Eyed", "Worried",
        "Determined", "Surprised", "Stunned", "Sigh", "Pain", "Shouting", "Inspired"]

# ---------------------------------------------------------------------------- scénario
# lines : [t0, t1, speaker(pid), emotion, texte]
LINES = [
    [16.0, 21.0, "0172", "Happy", "Ah… quel matin ! Le vent de la falaise, l'odeur de la mer… Aujourd'hui est un grand jour."],
    [26.5, 32.0, "0172", "Worried", "Enfin… « grand jour », c'est ce que je dis. Mais est-ce que j'y vais, vraiment ?"],
    [32.5, 38.5, "0172", "Teary-Eyed", "La Guilde accepte les recrues jusqu'au coucher du soleil. Si je ne pars pas maintenant… je ne partirai jamais."],
    [39.0, 45.0, "0172", "Sad", "Mais et si je tremble devant le formulaire ? Et si je bégaye ? Et si… et si on me rit dessus ?"],
    [45.5, 51.5, "0172", "Determined", "Non ! Je pars. Je suis un explorateur, un vrai. Un grand explorateur ! Je…"],
    [51.5, 57.0, "0172", "Worried", "…je prends juste mon écharpe porte-bonheur. Et mon goûter. Et un plan B. Et C."],
    [60.0, 64.5, "0172", "Surprised", "Hm ? Cette ombre sur le chemin… et ce pas de marche, là-bas ?"],
    [76.0, 81.5, "0763", "Inspired", "STOP ! Ne regardez plus le soleil… regardez-MOI. Ah… et toi, petite miette, tu brilles trop. Ça ME vole la vedette."],
    [82.0, 87.5, "0428", "Joyous", "Ouiiih ! Tu brilles trop, enfaite ! Ça lui vole la vedette, enfaite ! …Moi je trouve ça joli, enfaite."],
    [88.0, 93.5, "0303", "Angry", "Sonata. Tu viens de répéter Adagio en ajoutant « enfaite ». Trois fois. — Enfaite oui. — ENFAITE."],
    [96.5, 102.0, "0428", "Happy", "À moi ! Sonata Loponny, la plus mignonne des chasseuses de trésors, est ARRIVÉE ! …Enfaite, j'ai rien à rajouter, enfaite."],
    [102.5, 108.0, "0763", "Inspired", "Adagio Tsareen, leader DIVA de la Team Dazzling ! Cette falaise est enfin à la hauteur de MON entrée. Pleure de joie, hameau."],
    [108.5, 114.0, "0303", "Sigh", "Aria Mawile. J'accompagne. Je juge. Et je préviens : si Sonata répète encore « enfaite », je mords."],
    [114.5, 119.5, "0763", "Normal", "Dis-moi, miette… c'est ICI que tu rêvais de devenir quelqu'un ? Quel décor misérable… enfin, misérable comparé à moi."],
    [120.0, 126.5, "0428", "Joyous", "Il voulait s'inscrire AUJOURD'HUI, enfaite ! Hihi ! Avec ces petites pattes, enfaite ! …Moi aussi j'ai des petites pattes, enfaite."],
    [127.0, 133.5, "0172", "Stunned", "Je… je m'inscrirai ! Je suis courageux ! La preuve : je suis sorti de ma maison !"],
    [134.0, 140.5, "0428", "Happy", "« Je suis courageux ! La preuve, je suis sorti de ma maison ! » Hihi ! Il se cite lui-même, enfaite !"],
    [141.0, 147.5, "0763", "Inspired", "Voyons, Sonata, sois gentille. Les petits rêves sont adorables… tant qu'ils restent petits. Oh, ça c'était BEAU. Je me cite aussi."],
    [148.0, 154.0, "0303", "Angry", "Rentre chez toi, Pichu. Explorateur, ça se mérite. Toi, t'es né pour frissonner. …Et moi pour supporter ces deux-là."],
    [154.5, 160.5, "0172", "Pain", "Je ne frissonne pas ! C'est le vent de la falaise ! Il est très traître aujourd'hui !"],
    [161.0, 167.0, "0428", "Joyous", "« C'est le vent, enfaite ! » Hihi ! Mais y'a pas de vent, enfaite ! …Enfaite si, un peu, là, sur ma joue. Enfaite non."],
    [167.5, 173.5, "0172", "Crying", "…Il y a toujours du vent. Dans ma tête. C'est mon vent intérieur. Il est méchant."],
    [174.0, 180.0, "0763", "Normal", "Mes étoiles, partons ! Ce hameau n'a plus rien à m'offrir… Adieu, public. Oui, TOI. Tu peux applaudir."],
    [190.0, 196.5, "0303", "Sigh", "Enfin parties. Deux heures perdues pour un tremblement. Quel bilan prestigieux, enfaite. …SONATA. ARRÊTE AVEC ÇA."],
    [197.0, 203.5, "0428", "Happy", "Bye-bye, froussard ! N'oublie pas ton goûter, enfaite ! Et ton plan C, enfaite ! …J'ai dit enfaite combien de fois, enfaite ?"],
    [204.0, 210.5, "0763", "Inspired", "Adieu, petite miette. Essaie de briller… ailleurs. De préférence très loin de MOI. Le soleil a besoin de place."],
    [214.0, 220.0, "0172", "Sad", "…Voilà. Elles sont parties. Elles ont posé. Elles ont brillé. Et moi j'ai… regardé."],
    [220.5, 227.0, "0172", "Crying", "Snif… elles ont raison, en plus. C'est ça le pire. Un froussard… je suis un froussard."],
    [227.5, 234.0, "0172", "Teary-Eyed", "Un froussard avec une écharpe porte-bonheur, un goûter, et trois plans de repli…"],
    [234.5, 242.0, "0172", "Sad", "…mais un froussard qui voulait vraiment y aller. Et ça… ça compte un peu, non ?"],
    [242.5, 250.0, "0172", "Determined", "Demain, je pars à la première heure. Même avec le vent. MÊME avec elles. Promis, juré."],
]

# shots : t0, t1, cam keys [t, cx, cy, z], fade, actors visibles
# actors : id, pid, keys [t, x, y], an [t, anim, dir|'auto', opts], a (alpha keys), s (scale)
SHOTS = [
    {"id": "S1", "t0": 0, "t1": 12, "cam": [[0, 420, 430, 0.5], [12, 480, 470, 0.85]], "fade": 0.0, "actors": []},
    {"id": "S2", "t0": 12, "t1": 26, "cam": [[12, 590, 442, 1.5], [20, 586, 458, 1.8], [26, 584, 466, 2.0]], "fade": 0.3,
     "actors": [{"id": "pichu", "pid": "0172", "keys": [[12, 590, 434], [14.5, 590, 434], [17.5, 586, 468], [26, 586, 470]],
                 "an": [[12, "EventSleep", 0], [13.6, "Wake", 0, {"loop": False}], [15.0, "Walk", "auto"], [17.8, "Nod", 0, {"loop": False}], [19.5, "LookUp", 6, {"loop": False}], [22.5, "Idle", 6]]}]},
    {"id": "S3", "t0": 26, "t1": 58, "cam": [[26, 576, 472, 2.1], [40, 570, 476, 2.3], [52, 576, 474, 2.2], [58, 576, 474, 2.2]], "fade": 0.3,
     "actors": [{"id": "pichu", "pid": "0172", "keys": [[26, 586, 470], [31, 560, 478], [36, 586, 474], [41, 562, 480], [44, 566, 480], [50, 566, 480], [53, 570, 478], [58, 570, 478]],
                 "an": [[26, "Walk", "auto"], [43.6, "Sit", 6, {"loop": False}], [49.6, "Hop", 6, {"loop": False}], [50.6, "Idle", 6], [52.6, "Walk", "auto"], [53.6, "Idle", 6], [55.0, "LookUp", 4, {"loop": False}]]}]},
    {"id": "S4", "t0": 58, "t1": 74, "cam": [[58, 566, 484, 2.0], [64, 566, 484, 2.0], [66, 600, 560, 1.35], [74, 640, 640, 1.3]], "fade": 0.35,
     "actors": [{"id": "pichu", "pid": "0172", "keys": [[58, 570, 478], [74, 566, 478]], "an": [[58, "Idle", 4], [60.0, "LookUp", 0, {"loop": False}], [63.0, "Cringe", 0, {"loop": False}], [65.0, "Idle", 0]]},
                {"id": "lop", "pid": "0428", "keys": [[66, 668, 930], [74, 656, 810]], "an": [[66, "Walk", "auto"]], "a": [[66, 0], [67.2, 1]]},
                {"id": "suc", "pid": "0763", "keys": [[66.8, 690, 950], [74, 676, 830]], "an": [[66.8, "Walk", "auto"]], "a": [[66.8, 0], [68, 1]]},
                {"id": "mys", "pid": "0303", "keys": [[67.6, 712, 970], [74, 696, 850]], "an": [[67.6, "Walk", "auto"]], "a": [[67.6, 0], [68.8, 1]]}]},
    {"id": "S5", "t0": 74, "t1": 119, "cam": [[74, 668, 850, 1.2], [84, 650, 700, 1.4], [92, 626, 552, 1.6], [96, 622, 540, 1.7], [110, 620, 538, 1.8], [119, 618, 536, 1.8]], "fade": 0.3,
     "actors": [{"id": "pichu", "pid": "0172", "keys": [[74, 566, 478], [119, 566, 478]], "an": [[74, "Idle", 0], [96, "Cringe", 0, {"loop": False}], [99, "Idle", 0], [113, "LookUp", 0, {"loop": False}]]},
                {"id": "lop", "pid": "0428", "keys": [[74, 656, 810], [92, 606, 548], [119, 606, 548]], "an": [[74, "Walk", "auto"], [92.5, "Idle", 0], [96.5, "Appeal", 0, {"loop": False}], [100.5, "Idle", 0], [113, "LookUp", 2, {"loop": False}], [116, "Idle", 0]]},
                {"id": "suc", "pid": "0763", "keys": [[74, 676, 830], [93, 636, 556], [119, 636, 556]], "an": [[74, "Walk", "auto"], [93.5, "Idle", 0], [102.0, "Kick", 0, {"loop": False}], [106.0, "Rotate", 0, {"loop": False}], [109.5, "Idle", 0], [113.5, "LookUp", 6, {"loop": False}], [116.5, "Idle", 0]]},
                {"id": "mys", "pid": "0303", "keys": [[74, 696, 850], [94, 668, 548], [119, 668, 548]], "an": [[74, "Walk", "auto"], [94.5, "Idle", 0], [107.5, "Strike", 0, {"loop": False}], [111.5, "Idle", 0], [114, "Idle", 0]]}]},
    {"id": "S6", "t0": 119, "t1": 190, "cam": [[119, 616, 520, 1.8], [119.9, 600, 550, 2.5], [126.4, 600, 550, 2.5], [126.5, 566, 478, 2.6], [133.4, 566, 478, 2.6], [133.5, 606, 546, 2.5], [139.9, 606, 546, 2.5], [140, 636, 554, 2.5], [146.9, 636, 554, 2.5], [147, 668, 546, 2.5], [153.4, 668, 546, 2.5], [153.5, 566, 478, 2.6], [159.9, 566, 478, 2.6], [160, 606, 546, 2.5], [165.9, 606, 546, 2.5], [166, 566, 480, 2.6], [172.4, 566, 480, 2.6], [172.5, 636, 554, 2.5], [180, 620, 528, 1.9], [190, 620, 530, 1.8]], "fade": 0.3,
     "actors": [{"id": "pichu", "pid": "0172", "keys": [[119, 566, 478], [190, 566, 478]], "an": [[119, "Idle", 0], [126.5, "Cringe", 0, {"loop": False}], [130, "Idle", 0], [153.5, "Pain", 0, {"loop": False}], [157, "Idle", 0], [166, "Cringe", 0, {"loop": False}], [170, "Idle", 0]]},
                {"id": "lop", "pid": "0428", "keys": [[119, 606, 548], [190, 606, 548]], "an": [[119, "Idle", 4], [120, "Hop", 4, {"loop": False}], [124, "Idle", 4], [133.5, "Double", 4, {"loop": False}], [137.5, "Idle", 4], [160, "Hop", 4, {"loop": False}], [164, "Idle", 4]]},
                {"id": "suc", "pid": "0763", "keys": [[119, 636, 556], [190, 636, 556]], "an": [[119, "Idle", 4], [140, "Rotate", 4, {"loop": False}], [144, "Idle", 4], [172.5, "Kick", 4, {"loop": False}], [176.5, "Idle", 4]]},
                {"id": "mys", "pid": "0303", "keys": [[119, 668, 548], [190, 668, 548]], "an": [[119, "Idle", 4], [147, "Strike", 4, {"loop": False}], [151, "Idle", 4], [181, "Cringe", 6, {"loop": False}], [184, "Idle", 4]]}]},
    {"id": "S7", "t0": 190, "t1": 214, "cam": [[190, 620, 540, 1.6], [200, 640, 580, 1.5], [214, 690, 650, 1.5]], "fade": 0.3,
     "actors": [{"id": "pichu", "pid": "0172", "keys": [[190, 566, 478], [214, 566, 478]], "an": [[190, "Idle", 0], [196.5, "Cringe", 0, {"loop": False}], [200, "Idle", 0], [203, "LookUp", 0, {"loop": False}]]},
                {"id": "lop", "pid": "0428", "keys": [[190, 600, 552], [198, 636, 606], [214, 680, 660]], "an": [[190, "Idle", 4], [194, "Walk", "auto"], [206, "Walk", "auto"]]},
                {"id": "suc", "pid": "0763", "keys": [[190, 640, 566], [199, 672, 622], [214, 706, 676]], "an": [[190, "Idle", 4], [195, "Walk", "auto"]]},
                {"id": "mys", "pid": "0303", "keys": [[190, 682, 554], [200, 702, 636], [214, 732, 668]], "an": [[190, "Idle", 4], [196, "Walk", "auto"]]}]},
    {"id": "S8", "t0": 214, "t1": 232, "cam": [[214, 700, 662, 1.5], [219.5, 700, 662, 1.5], [220, 566, 480, 2.2], [232, 566, 480, 2.3]], "fade": 0.3,
     "actors": [{"id": "pichu", "pid": "0172", "keys": [[214, 566, 478], [232, 566, 478]], "an": [[214, "Idle", 0], [220.5, "Cringe", 0, {"loop": False}], [225, "Idle", 0]]},
                {"id": "lop", "pid": "0428", "keys": [[214, 680, 660], [222, 730, 760], [232, 790, 870]], "an": [[214, "Appeal", 0, {"loop": False}], [218, "Walk", "auto"]]},
                {"id": "suc", "pid": "0763", "keys": [[214, 706, 676], [223, 752, 780], [232, 810, 890]], "an": [[214, "Kick", 0, {"loop": False}], [218.6, "Walk", "auto"]]},
                {"id": "mys", "pid": "0303", "keys": [[214, 732, 668], [224, 774, 800], [232, 830, 910]], "an": [[214, "Strike", 0, {"loop": False}], [219.2, "Walk", "auto"]]}]},
    {"id": "S9", "t0": 232, "t1": 252, "cam": [[232, 570, 480, 2.3], [240, 568, 480, 2.5], [252, 568, 480, 2.6]], "fade": 0.35,
     "actors": [{"id": "pichu", "pid": "0172", "keys": [[232, 566, 478], [236, 566, 480], [252, 566, 480]], "an": [[232, "Idle", 0], [235.6, "Sit", 0, {"loop": False}], [242, "Cringe", 0, {"loop": False}], [246, "Sit", 0, {"loop": False}]]}]},
    {"id": "S10", "t0": 252, "t1": 300, "cam": [[252, 568, 480, 2.6], [262, 566, 478, 2.4], [276, 566, 470, 2.1], [292, 520, 420, 1.2], [300, 470, 400, 0.9]], "fade": 0.3,
     "actors": [{"id": "pichu", "pid": "0172", "keys": [[252, 566, 480], [262, 566, 478], [300, 566, 478]], "an": [[252, "Sit", 0], [261.6, "Hop", 0, {"loop": False}], [262.6, "Idle", 6], [266, "Cringe", 6, {"loop": False}], [270, "Idle", 6], [276, "Nod", 6, {"loop": False}], [280, "Idle", 6], [286, "LookUp", 4, {"loop": False}], [290, "Idle", 4], [292, "Pose", 4, {"loop": False}]]}]},
]

# --------------------------------------------------------------------------- moteur JS
ENGINE_JS = r"""
/* Cinématique « Pichu & la Team Dazzling » — 5 min dans cliffdaytest (map native PMDO).
   Boîtes de dialogue canoniques PMDO : plaque de nom, portrait selon l'émotion, texte
   machine-à-écrire, flèche de suite. Caméra immersive, entrée marchée/posée de la team. */
(function (root) {
  'use strict';
  const W = 1280, H = 720, D = 300.0, TAU = Math.PI * 2;
  const clamp = (x, a, b) => Math.min(b, Math.max(a, x));
  const sstep = (x) => { x = clamp(x, 0, 1); return x * x * (3 - 2 * x); };
  const lerp = (a, b, u) => a + (b - a) * u;
  const rnd = (i, s) => { const x = Math.sin(i * 127.1 + (s || 0) * 311.7) * 43758.5453; return x - Math.floor(x); };
  function create(EV) {
    const I = EV.imgs, SH = EV.sheets, PT = EV.catalog.portraits || {}, CAT = EV.catalog.pokemon;
    const SHOTS = EV.catalog.script.shots, LINES = EV.catalog.script.lines, mk = EV.mk;
    function lin(keys, t) { if (!keys || !keys.length) return null; if (t <= keys[0][0]) return keys[0].slice(1);
      for (let i = 0; i < keys.length - 1; i++) { if (t >= keys[i][0] && t < keys[i + 1][0]) { const u = (t - keys[i][0]) / (keys[i + 1][0] - keys[i][0]); return keys[i].slice(1).map((v, k) => lerp(v, keys[i + 1][1 + k], u)); } }
      return keys[keys.length - 1].slice(1); }
    function animInfo(pid, anim) { const e = CAT[pid]; return e && e.anims[anim] ? e.anims[anim] : null; }
    function frameAt(info, tick, loop) { const d = info.durations; let tot = 0; for (const q of d) tot += q;
      let x = loop ? ((tick % tot) + tot) % tot : clamp(tick, 0, tot - 0.001); let acc = 0;
      for (let i = 0; i < d.length; i++) { acc += d[i]; if (x < acc) return i; } return d.length - 1; }
    function dirAuto(keys, t) { const p = lin(keys, t), q = lin(keys, t + 0.12); if (!p || !q) return 0;
      const dx = q[0] - p[0], dy = q[1] - p[1]; if (Math.abs(dx) < 0.02 && Math.abs(dy) < 0.02) return null;
      return Math.abs(dx) > Math.abs(dy) ? (dx > 0 ? 2 : 6) : (dy > 0 ? 0 : 4); }
    function drawSprite(ctx, pid, anim, dir, tick, loop, x, y, o) {
      const info = animInfo(pid, anim); if (!info) return; const im = SH[info.file]; if (!im || !im.width) return;
      o = o || {}; const col = frameAt(info, tick, loop), row = info.rows > 1 ? dir % info.rows : 0;
      const fw = info.fw, fh = info.fh, sc = o.s || 1, al = o.a == null ? 1 : o.a;
      ctx.save(); ctx.globalAlpha = 0.22 * al; ctx.fillStyle = '#000';
      ctx.beginPath(); ctx.ellipse(x, y + 3, 8 * sc, 3.6 * sc, 0, 0, TAU); ctx.fill(); ctx.restore();
      ctx.save(); ctx.globalAlpha = al; ctx.imageSmoothingEnabled = false; ctx.translate(x, y - 2); ctx.scale(sc * (o.flip ? -1 : 1), sc);
      ctx.drawImage(im, col * fw, row * fh, fw, fh, -fw / 2, -fh / 2, fw, fh); ctx.restore(); }
    function glow(ctx, x, y, r, rgb, a) { if (a <= 0.004) return; ctx.save(); ctx.globalCompositeOperation = 'lighter';
      const g = ctx.createRadialGradient(x, y, 0, x, y, r); g.addColorStop(0, 'rgba(' + rgb + ',' + a.toFixed(3) + ')'); g.addColorStop(1, 'rgba(' + rgb + ',0)');
      ctx.fillStyle = g; ctx.beginPath(); ctx.arc(x, y, r, 0, TAU); ctx.fill(); ctx.restore(); }
    function ring(ctx, x, y, r, w, rgb, a, sy) { if (a <= 0.004) return; ctx.save(); ctx.globalCompositeOperation = 'lighter';
      ctx.translate(x, y); ctx.scale(1, sy || 1); ctx.strokeStyle = 'rgba(' + rgb + ',' + clamp(a, 0, 1).toFixed(3) + ')'; ctx.lineWidth = Math.max(0.4, w);
      ctx.beginPath(); ctx.arc(0, 0, Math.max(0.6, r), 0, TAU); ctx.stroke(); ctx.restore(); }
    function starBurst(ctx, x, y, r, a, rays, rot) { if (a <= 0.004) return; ctx.save(); ctx.translate(x, y); ctx.rotate(rot || 0);
      ctx.globalCompositeOperation = 'lighter'; ctx.strokeStyle = 'rgba(255,252,235,' + a.toFixed(3) + ')';
      for (let i = 0; i < rays; i++) { const an = (i / rays) * TAU, L = r * (0.55 + 0.45 * rnd(i, 7)); ctx.lineWidth = i % 2 ? 1.4 : 2.6;
        ctx.beginPath(); ctx.moveTo(Math.cos(an) * r * 0.18, Math.sin(an) * r * 0.18); ctx.lineTo(Math.cos(an) * L, Math.sin(an) * L); ctx.stroke(); } ctx.restore(); }
    function flash(ctx, a, rgb) { if (a <= 0.004) return; ctx.fillStyle = 'rgba(' + (rgb || '255,255,255') + ',' + clamp(a, 0, 1).toFixed(3) + ')'; ctx.fillRect(0, 0, W, H); }
    // ---- caméra ----
    function camAt(sc, t) { const k = lin(sc.cam, t); let sh = 0;
      for (const pt of POSE_T) { const d = t - pt; if (d >= 0 && d < 0.5) sh += 2.6 * Math.exp(-d * 9); }
      const cx = k[0] + (sh ? Math.sin(t * 67) * sh : 0), cy = k[1] + (sh ? Math.cos(t * 71) * sh : 0);
      return { cx, cy, S: 4 * k[2] }; }
    const POSE_T = [96.5, 102.0, 107.5, 214.0, 214.6, 215.2];
    // ---- acteurs ----
    function actorState(a, t) { const pos = lin(a.keys, t); const al = a.a ? lin(a.a, t)[0] : 1;
      let anim = a.an[0][1], dir = a.an[0][2], loop = true, tick = t * 60, spd = 1;
      for (const e of a.an) { if (t >= e[0]) { anim = e[1]; dir = e[2]; loop = !(e[3] && e[3].loop === false); spd = e[3] && e[3].speed || 1; } }
      let d = dir; if (d === 'auto') { d = dirAuto(a.keys, t); if (d == null) d = 0; }
      const info = animInfo(a.pid, anim); if (info && !loop) tick = (t - animStart(a, t)) * 60 * spd;
      let bob = 0; if (anim === 'Walk') bob = -Math.abs(Math.sin(t * Math.PI * 2.06)) * 1.6; // pas de marche strut
      return { pos, al, anim, dir: d, tick, bob }; }
    function animStart(a, t) { let s0 = a.an[0][0]; for (const e of a.an) if (t >= e[0]) s0 = e[0]; return s0; }
    // ---- boîte de dialogue canonique PMDO ----
    function roundRect(ctx, x, y, w, h, r) { ctx.beginPath(); ctx.moveTo(x + r, y); ctx.arcTo(x + w, y, x + w, y + h, r); ctx.arcTo(x + w, y + h, x, y + h, r); ctx.arcTo(x, y + h, x, y, r); ctx.arcTo(x, y, x + w, y, r); ctx.closePath(); }
    function wrapText(ctx, text, maxw) { const words = text.split(' '), out = []; let cur = '';
      for (const w of words) { const test = cur ? cur + ' ' + w : w; if (ctx.measureText(test).width > maxw && cur) { out.push(cur); cur = w; } else cur = test; }
      if (cur) out.push(cur); return out; }
    function dialogBox(ctx, L, t) {
      const u0 = sstep((t - L[0]) / 0.18), u1 = 1 - sstep((t - (L[1] - 0.22)) / 0.22), a = Math.min(u0, u1);
      if (a <= 0.004) return; const pid = L[2], emo = L[3], txt = L[4];
      const bx = 150, by = 540 + (1 - u0) * 30, bw = 980, bh = 150;
      ctx.save(); ctx.globalAlpha = a;
      ctx.fillStyle = 'rgba(6,10,34,0.88)'; roundRect(ctx, bx, by, bw, bh, 16); ctx.fill();
      ctx.strokeStyle = 'rgba(214,230,255,0.95)'; ctx.lineWidth = 3; roundRect(ctx, bx, by, bw, bh, 16); ctx.stroke();
      ctx.strokeStyle = 'rgba(90,120,220,0.8)'; ctx.lineWidth = 1.5; roundRect(ctx, bx + 5, by + 5, bw - 10, bh - 10, 12); ctx.stroke();
      const name = CAT[pid].name; ctx.font = 'bold 24px "Trebuchet MS", Verdana, sans-serif';
      const nw = ctx.measureText(name).width + 34;
      const g = ctx.createLinearGradient(bx + 22, by - 18, bx + 22 + nw, by + 16); g.addColorStop(0, '#ffe9a8'); g.addColorStop(1, '#f4b942');
      ctx.fillStyle = g; roundRect(ctx, bx + 22, by - 18, nw, 36, 9); ctx.fill();
      ctx.strokeStyle = '#7a4a10'; ctx.lineWidth = 2; roundRect(ctx, bx + 22, by - 18, nw, 36, 9); ctx.stroke();
      ctx.fillStyle = '#4a2c08'; ctx.textBaseline = 'middle'; ctx.fillText(name, bx + 39, by + 1);
      const pim = I['pt_' + pid + '_' + emo]; const px = bx + 24, py = by + 24, ps = 102;
      ctx.fillStyle = '#0b1440'; roundRect(ctx, px - 6, py - 6, ps + 12, ps + 12, 10); ctx.fill();
      ctx.strokeStyle = 'rgba(214,230,255,0.9)'; ctx.lineWidth = 2.5; roundRect(ctx, px - 6, py - 6, ps + 12, ps + 12, 10); ctx.stroke();
      if (pim && pim.width) { ctx.imageSmoothingEnabled = true; ctx.drawImage(pim, px, py, ps, ps); }
      ctx.fillStyle = '#f2f6ff'; ctx.font = '23px "Trebuchet MS", Verdana, sans-serif'; ctx.textBaseline = 'alphabetic';
      const lines = wrapText(ctx, txt, bw - 190); const nch = Math.floor((t - L[0] - 0.12) * 46);
      let shown = 0; for (let i = 0; i < lines.length; i++) { const take = clamp(nch - shown, 0, lines[i].length);
        ctx.fillText(lines[i].slice(0, take), bx + 150, by + 62 + i * 34); shown += lines[i].length;
        if (take < lines[i].length) break; }
      let tot = 0; for (const q of lines) tot += q.length;
      if (nch >= tot) { const bl = 0.5 + 0.5 * Math.sin(t * 7);
        ctx.fillStyle = 'rgba(255,240,170,' + (0.4 + 0.6 * bl).toFixed(2) + ')'; ctx.font = 'bold 26px Verdana'; ctx.fillText('▼', bx + bw - 44, by + bh - 20); }
      ctx.restore(); }
    // ---- larmes ----
    function tears(ctx, x, y, t, a) { if (a <= 0.01) return; ctx.save(); ctx.globalCompositeOperation = 'lighter';
      for (let i = 0; i < 5; i++) { const ph = ((t * 1.15 + i * 0.37) % 1); const sx = x + (i % 2 ? 5 : -5) + Math.sin(i * 3) * 1.5;
        const sy = y - 16 + ph * 22; ctx.fillStyle = 'rgba(150,220,255,' + (a * (1 - ph) * 0.85).toFixed(3) + ')';
        ctx.beginPath(); ctx.ellipse(sx, sy, 1.8, 2.8 + ph * 1.4, 0, 0, TAU); ctx.fill(); } ctx.restore(); }
    // ---- rendu ----
    function render(ctx, t, opts) {
      opts = opts || {}; t = clamp(t, 0, D);
      ctx.save(); ctx.fillStyle = '#000'; ctx.fillRect(0, 0, W, H);
      let sc = SHOTS[SHOTS.length - 1]; for (const s of SHOTS) if (t >= s.t0 && t < s.t1) { sc = s; break; }
      const c = camAt(sc, t);
      ctx.save(); ctx.imageSmoothingEnabled = true; ctx.translate(W / 2, H / 2); ctx.scale(c.S, c.S); ctx.translate(-c.cx, -c.cy);
      ctx.drawImage(I.mapUnder, 0, 0);
      // ombres de nuages dérivantes + lumière du matin
      for (let i = 0; i < 3; i++) { const sx = ((t * (7 + i * 3) + i * 330) % 1100) - 150, sy = 180 + i * 260;
        ctx.save(); ctx.globalAlpha = 0.07; ctx.fillStyle = '#10204a'; ctx.beginPath(); ctx.ellipse(sx, sy, 150 + i * 30, 60 + i * 12, 0.2, 0, TAU); ctx.fill(); ctx.restore(); }
      const items = [];
      for (const a of (sc.actors || [])) { const st = actorState(a, t); if (st.al <= 0.004) continue;
        items.push({ y: st.pos[1], fn: () => drawSprite(ctx, a.pid, st.anim, st.dir, st.tick, true, st.pos[0], st.pos[1] + st.bob, { a: st.al, s: a.s || 1 }) }); }
      items.sort((p, q) => p.y - q.y); items.forEach((it) => it.fn());
      ctx.drawImage(I.mapOver, 0, 0);
      // éclats de pose de l'entrée
      for (const pt of POSE_T) { const d = t - pt; if (d < 0 || d >= 0.6) continue; const u = d / 0.6;
        const who = pt < 100 ? [606, 548] : pt < 106 ? [636, 556] : pt < 112 ? [668, 548] : pt < 214.4 ? [680, 660] : pt < 215 ? [706, 676] : [732, 668];
        ring(ctx, who[0], who[1] - 6, 4 + u * 26, 1.6, '255,244,190', 0.8 * (1 - u), 0.6);
        starBurst(ctx, who[0], who[1] - 12, 14 + u * 24, 0.7 * (1 - u), 8, pt + u * 0.4); }
      // larmes de Pichu
      if (t > 220.5 && t < 252) tears(ctx, 566, 470, t, 0.9 * sstep((t - 220.5) / 1.2) * (1 - sstep((t - 250) / 2)));
      if (t > 262 && t < 286) tears(ctx, 566, 470, t, 0.8 * sstep((t - 262) / 1.2) * (1 - sstep((t - 284) / 2)));
      ctx.restore();
      // flashs d'entrée & fondus
      for (const pt of POSE_T) { const d = t - pt; if (d >= 0 && d < 0.3) flash(ctx, 0.30 * Math.exp(-d * 12), '255,248,220'); }
      if (sc.fade && t < sc.t0 + sc.fade) flash(ctx, 1 - sstep((t - sc.t0) / sc.fade), '0,0,0');
      if (t > D - 4) flash(ctx, sstep((t - (D - 4)) / 3.2), '0,0,0');
      flash(ctx, 0.9 * Math.exp(-t * 3.2), '0,0,0');
      // dialogue
      for (const L of LINES) if (t >= L[0] && t < L[1]) dialogBox(ctx, L, t);
      // barres cinéma
      const bk = sstep((t - 0.2) / 1.2) * (1 - sstep((t - (D - 4.5)) / 1.0)); ctx.fillStyle = '#000';
      ctx.fillRect(0, 0, W, 46 * bk); ctx.fillRect(0, H - 46 * bk, W, 46 * bk);
      ctx.restore(); return { shot: sc.id };
    }
    return { render, W, H, D };
  }
  root.PMDDestinyDazzling = { create, W, H, D };
})(typeof window !== 'undefined' ? window : globalThis);
"""

BOOT_JS = r"""
(function () {
  const cv = document.getElementById('cv'), ctx = cv.getContext('2d');
  const cin = window.PMDDestinyDazzling.create(ASSETS);
  let t0 = performance.now() / 1000 - (parseFloat(new URLSearchParams(location.search).get('t')) || 0);
  let ostAt = null;
  const btn = document.getElementById('ost');
  btn.addEventListener('click', () => { ostAt = performance.now() / 1000 - t0; btn.style.display = 'none';
    const wr = document.getElementById('ostwrap'); wr.style.display = 'block';
    wr.innerHTML = '<iframe width="320" height="180" src="https://www.youtube.com/embed/iV04Wl5DLJo?autoplay=1&start=0" title="OST Team Dazzling" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>'; });
  function loop() { const t = performance.now() / 1000 - t0;
    if (btn.style.display !== 'none' && t > 68 && t < 92) btn.style.opacity = '1'; else if (btn.style.display !== 'none') btn.style.opacity = '0.35';
    cin.render(ctx, t, {}); requestAnimationFrame(loop); }
  loop();
})();
"""


def uri_png(path: Path) -> str:
    return "data:image/png;base64," + base64.b64encode(path.read_bytes()).decode()


def export_assets() -> dict:
    imgs = {"mapUnder": uri_png(PLATES / "cliffdaytest_jour_under.png"), "mapOver": uri_png(PLATES / "cliffdaytest_jour_over.png")}
    sheets, catalog, portraits = {}, {}, {}
    for pid, meta in CAST.items():
        rootx = ET.parse(SC / "sprite" / pid / "AnimData.xml").getroot()
        anims = {}
        for node in rootx.findall(".//Anim"):
            nm = node.findtext("Name")
            if nm not in ANIMS[pid] or node.findtext("FrameWidth") is None:
                continue
            durs = [int(d.text) for d in node.findall(".//Duration")]
            fw, fh = int(node.findtext("FrameWidth")), int(node.findtext("FrameHeight"))
            pim = Image.open(SC / "sprite" / pid / f"{nm}-Anim.png")
            anims[nm] = {"file": f"{pid}/{nm}-Anim.png", "fw": fw, "fh": fh,
                         "cols": pim.width // fw, "rows": pim.height // fh, "durations": durs}
            sheets[f"{pid}/{nm}-Anim.png"] = uri_png(SC / "sprite" / pid / f"{nm}-Anim.png")
        catalog[pid] = {"name": meta["name"], "anims": anims}
        for emo in EMOS:
            q = SC / "portrait" / pid / f"{emo}.png"
            if q.is_file():
                imgs[f"pt_{pid}_{emo}"] = uri_png(q)
                portraits.setdefault(pid, []).append(emo)
    return {"imgs": imgs, "sheets": sheets,
            "catalog": {"pokemon": catalog, "portraits": portraits, "script": {"shots": SHOTS, "lines": LINES}}}


def build() -> Path:
    A = export_assets()
    html = ("<!DOCTYPE html>\n<html lang=\"fr\">\n<head>\n<meta charset=\"utf-8\" />\n"
            "<title>PMD Destiny — Cinématique « Pichu & la Team Dazzling » (cliffdaytest, 5 min)</title>\n"
            "<style>html,body{margin:0;background:#000;height:100%}#wrap{position:relative;width:100vw;height:100vh;display:flex;align-items:center;justify-content:center}"
            "canvas{width:min(100vw,177.7vh);image-rendering:auto;background:#000}"
            "#ost{position:absolute;right:18px;bottom:64px;z-index:5;background:#f4b942;color:#4a2c08;border:2px solid #7a4a10;border-radius:10px;padding:10px 14px;font:bold 15px Verdana;cursor:pointer;opacity:.35}"
            "#ostwrap{position:absolute;right:18px;bottom:110px;z-index:5;display:none}</style>\n</head>\n<body>\n<div id=\"wrap\">\n"
            "<canvas id=\"cv\" width=\"1280\" height=\"720\"></canvas>\n"
            "<button id=\"ost\">▶ OST — Team Dazzling (Beta's Theme)</button><div id=\"ostwrap\"></div>\n</div>\n"
            "<script>\n" + ENGINE_JS + "\n</script>\n<script>\nconst ASSETS = " + json.dumps(A, ensure_ascii=False, separators=(",", ":")) + ";\n</script>\n"
            "<script>\n" + BOOT_JS + "\n</script>\n</body>\n</html>\n")
    OUT_HTML.write_text(html, encoding="utf-8")
    print(f"[ciné] {OUT_HTML.name}: {OUT_HTML.stat().st_size / 1024:.0f} Ko — 300 s")
    return OUT_HTML


if __name__ == "__main__":
    build()
