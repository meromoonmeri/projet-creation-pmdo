#!/usr/bin/env python3
"""Aperçu animé du parallax du Personality Quiz (fond « Dream » Halcyon).

Le quiz de personnalité s'affiche sur un fond en deux couches défilantes
(``Dream_Back`` / ``Dream_Front``, fichiers ``.dir`` PMDO) définies dans la map
``personality_test.rsground`` (RogueEssence ``LayeredBG``). Ce script :

  1. décode les deux ``.dir`` (63 frames 192×240, ``RotateType.None`` →
     indexation row-major sur 8 colonnes) ;
  2. exporte les planches PNG non-prémultipliées + une vignette composite
     dans ``apercus/quiz/`` ;
  3. écrit ``apercu_personality_quiz_parallax.html`` à la racine (animation
     fidèle au moteur, pour la visionneuse ``source/serveur_apercus/serve.py``) ;
  4. avec ``--integrer-quest`` : copie les assets du quiz dans
     ``quest_pmd_destiny/`` (Content/BG, Data/Ground) + déclare la zone
     ``personality_test`` (Data/Zone/personality_test.json + index.idx).

Fidélité du rendu — sémantique de
``RogueEssence/Content/Animation/Backgrounds/MapBG.Draw`` (RogueCollab/RogueEssence) :
  * défilement = ``BGMovement`` (pixels/seconde) × ticks écoulés / 60
    (division entière tronquée vers zéro, comme ``Loc``) ;
  * frame courante = ``ticks / FrameTime % totalFrames`` (FrameTime en ticks,
    60 ticks/s) ;
  * ``RepeatX`` : la frame se répète horizontalement sur toute la largeur
    d'écran à partir de ``MapLoc + movement`` ;
  * alpha = ``BGAnim.Alpha / 255`` ; ordre = couches de bas en haut.
Découpage des ``.dir`` : ``[i64 len][PNG prémultiplié][i32 w][i32 h][i32 dirs]
[i32 frames]`` (``DirSheet.Load``) ; frame i → colonne ``i % (largeur_planche/w)``,
ligne ``i / colonnes`` (``DrawDir``, RotateType.None).

Sources : ``quest_pmd_destiny/Content/BG/`` puis ``/tmp/halcyon/Content/BG/``
(assets Halcyon — Palikadude/Halcyon, voir CREDITS). Usage :

    .venv/bin/python OUTILS/rendre_quiz_parallax.py [--dir-root DIR] [--integrer-quest]
"""
from __future__ import annotations

import argparse
import io
import json
import struct
import sys
from pathlib import Path

import numpy as np
from PIL import Image

R = Path(__file__).resolve().parents[1]
OUT = R / 'apercus' / 'quiz'
PAGE = R / 'apercu_personality_quiz_parallax.html'
QUEST = R / 'quest_pmd_destiny'

# Paramètres natifs lus dans personality_test.rsground (Background/Layers)
SCREEN_W, SCREEN_H = 320, 240          # GFXParams Halcyon (40×30 cases × 8 px)
FRAME_W, FRAME_H = 192, 240            # frame des .dir Dream
FRAME_TIME = 8                         # ticks par frame (60 ticks/s)
TOTAL_FRAMES = 63
COLS = 8                               # 1536/192 — row-major (DirSheet None)
LAYERS = [
    {'nom': 'Dream_Back', 'move': [30, 0], 'alpha': 255, 'repeat_x': True,
     'repeat_y': False, 'loc': [0, 0], 'parallax': '0, 0'},
    {'nom': 'Dream_Front', 'move': [-30, 0], 'alpha': 128, 'repeat_x': True,
     'repeat_y': False, 'loc': [0, 0], 'parallax': '0, 0'},
]


# ---------------------------------------------------------------- natif

def unpremult(image: Image.Image) -> Image.Image:
    """Inverse le prémultiplié des .dir pour un affichage alpha droit."""
    a = np.array(image.convert('RGBA'), dtype=np.uint16)
    rgb, al = a[:, :, :3], a[:, :, 3:4]
    with np.errstate(divide='ignore', invalid='ignore'):
        res = np.clip((rgb * 255 + al // 2) // np.maximum(al, 1), 0, 255)
    out = np.zeros_like(a)
    out[:, :, :3] = np.where(al > 0, res, 0)
    out[:, :, 3] = a[:, :, 3]
    return Image.fromarray(out.astype('uint8'))


def lire_dir(path: Path):
    """Décode un .dir : planche RGBA (non prémultipliée) + (w, h, dirs, frames)."""
    raw = path.read_bytes()
    n, = struct.unpack_from('<q', raw)
    im = unpremult(Image.open(io.BytesIO(raw[8:8 + n])).convert('RGBA'))
    w, h, dirs, frames = struct.unpack_from('<4i', raw, 8 + n)
    if w != FRAME_W or h != FRAME_H:
        raise ValueError(f'{path.name}: frame {w}x{h} != {FRAME_W}x{FRAME_H}')
    if im.size != (w * COLS, h * ((frames + COLS - 1) // COLS)):
        raise ValueError(f'{path.name}: planche {im.size} inattendue pour '
                         f'{frames} frames de {w}x{h} sur {COLS} colonnes')
    return im, (w, h, dirs, frames)


def frame0(im: Image.Image) -> Image.Image:
    return im.crop((0, 0, FRAME_W, FRAME_H))


# ---------------------------------------------------------------- sortie

def exporter(dir_root: Path) -> dict:
    OUT.mkdir(parents=True, exist_ok=True)
    infos = {}
    for couche in LAYERS:
        src = dir_root / f"{couche['nom']}.dir"
        if not src.exists():
            raise FileNotFoundError(src)
        im, tail = lire_dir(src)
        im.save(OUT / f"{couche['nom']}.png")
        infos[couche['nom']] = tail
        print(f"  {couche['nom']}.dir → {OUT / (couche['nom'] + '.png')} "
              f"(planche {im.size[0]}x{im.size[1]}, frame {tail[0]}x{tail[1]}, "
              f"dirs={tail[2]}, frames={tail[3]})")
    # vignette composite (tick 0, couches bas→haut, RepeatX sur 320 px)
    base = Image.new('RGBA', (SCREEN_W, SCREEN_H), (24, 20, 40, 255))
    for couche in LAYERS:
        im = Image.open(OUT / f"{couche['nom']}.png")
        f = frame0(im)
        lay = Image.new('RGBA', (SCREEN_W, SCREEN_H))
        x = 0
        while x < SCREEN_W:
            lay.paste(f, (x, 0), f)
            x += FRAME_W
        if couche['alpha'] < 255:
            lay.putalpha(lay.getchannel('A').point(lambda a: a * couche['alpha'] // 255))
        base.alpha_composite(lay)
    base.save(OUT / 'parallax_quiz_vignette.png')
    print(f"  vignette → {OUT / 'parallax_quiz_vignette.png'}")
    return infos


# ---------------------------------------------------------------- page

def page_html() -> str:
    layers_js = []
    for i, c in enumerate(LAYERS):
        layers_js.append({
            'img': f"apercus/quiz/{c['nom']}.png", 'i': i,
            'w': FRAME_W, 'h': FRAME_H, 'frames': TOTAL_FRAMES, 'cols': COLS,
            'frame_time': FRAME_TIME, 'loc': c['loc'], 'move': c['move'],
            'repeat_x': c['repeat_x'], 'repeat_y': c['repeat_y'],
            'alpha': c['alpha'],
        })
    lignes = ''.join(
        f"<tr><td>{c['nom']}</td><td>{TOTAL_FRAMES} × {FRAME_W}×{FRAME_H}</td>"
        f"<td>{FRAME_TIME} ticks (7,5 img/s)</td><td>{c['alpha']} / 255</td>"
        f"<td>{c['move'][0]:+d} px/s</td><td>oui</td></tr>"
        for c in LAYERS)
    cfg = json.dumps(layers_js, separators=(',', ':'))
    return f"""<!doctype html><html lang="fr"><head><meta charset="utf-8">
<title>Personality Quiz — parallax animé (Dream_Back / Dream_Front)</title>
<style>
body {{ background:#141220; color:#eee; font:15px/1.55 system-ui,sans-serif; max-width:1100px; margin:18px auto; padding:0 12px }}
a {{ color:#ffd76a }} small {{ color:#999 }}
h1 {{ font-size:24px }} h2 {{ font-size:18px; margin-top:28px; border-bottom:1px solid #333; padding-bottom:4px }}
.bar {{ position:sticky; top:0; background:#141220ee; padding:8px 0; z-index:5; display:flex; gap:10px; flex-wrap:wrap; align-items:center }}
.stage {{ position:relative; line-height:0; border:1px solid #333; width:max-content; max-width:100%; overflow:hidden; border-radius:6px }}
.stage canvas {{ image-rendering: pixelated; display:block }}
button {{ background:#34304e; color:#eee; border:1px solid #6b5fa8; border-radius:6px; padding:4px 12px; cursor:pointer }}
button:hover {{ background:#464066 }}
table {{ border-collapse:collapse }} td, th {{ border:1px solid #443c2c; padding:3px 10px; font-size:13px }}
.note {{ background:#221e33; border:1px solid #3c3560; border-radius:8px; padding:10px 14px }}
/* simulation d'interface du quiz (HTML, pas des tuiles du jeu) */
.quizui {{ position:absolute; inset:0; display:flex; flex-direction:column; justify-content:space-between;
  padding:10px 12px; font-family: system-ui,sans-serif; pointer-events:none }}
.quizui .titre {{ align-self:center; color:#fff; background:#2a2450cc; border:1px solid #8a7ad0;
  border-radius:8px; padding:2px 18px; font-size:13px; letter-spacing:1px }}
.quizui .question {{ color:#fff; background:#191430d9; border:1px solid #7a6cc0; border-radius:10px;
  padding:8px 12px; font-size:12px; line-height:1.5; text-align:center }}
.quizui .reponses {{ display:flex; gap:10px }}
.quizui .rep {{ flex:1; color:#fff; background:#2d2752d9; border:1px solid #8a7ad0; border-radius:10px;
  padding:7px 10px; font-size:12px; text-align:center }}
.quizui .credit {{ position:absolute; right:8px; bottom:6px; font-size:9px; color:#cfc8eeaa }}
</style></head><body>
<p><a href="/">← Index de la visionneuse</a> · <a href="apercu_maps_destiny_generes.html">Maps Destiny générées</a></p>
<h1>Personality Quiz — parallax animé</h1>
<p>Fond « Dream » du quiz de personnalité : deux couches défilantes
(<code>Dream_Back</code> +30 px/s, <code>Dream_Front</code> −30 px/s en alpha 128)
telles que définies dans <code>personality_test.rsground</code> (Halcyon).
Rendu ci-dessous avec la sémantique exacte du moteur
(<code>MapBG.Draw</code> de RogueEssence).</p>

<div class="bar">
  <button id="pause">Pause</button>
  <button id="z1">×1</button><button id="z2">×2</button><button id="z3">×3</button>
  <label><input type="checkbox" id="voile" checked> simulation d'interface du quiz</label>
  <small id="tick"></small>
</div>
<div class="stage" id="stage">
  <canvas id="fond" width="{SCREEN_W}" height="{SCREEN_H}"></canvas>
  <div class="quizui" id="quizui">
    <div class="titre">PERSONALITY TEST</div>
    <div class="question">« On part à l'aventure ! Ton premier jour de quête s'annonce grandiose.
Que fais-tu pour le célébrer ? »<br><small>(question d'exemple — le quiz complet sera intégré avec le contenu PMD Remixed)</small></div>
    <div class="reponses">
      <div class="rep">Je prépare déjà mon sac pour demain !</div>
      <div class="rep">Je flâne et je profite du paysage.</div>
    </div>
    <div class="credit">interface simulée (HTML) — pas des tuiles du jeu</div>
  </div>
</div>

<h2>Paramètres natifs (personality_test.rsground)</h2>
<table>
<tr><th>Couche</th><th>Animation</th><th>FrameTime</th><th>Alpha</th><th>BGMovement</th><th>RepeatX</th></tr>
{lignes}
</table>
<p class="note"><b>Rendu fidèle.</b> Défilement = BGMovement (pixels/seconde) × ticks/60, frame = ticks/FrameTime % 63,
découpage des planches en {COLS} colonnes (indexation row-major, <code>DirSheet</code> RotateType.None),
écran {SCREEN_W}×{SCREEN_H} (GFXParams de Halcyon — map 40×30 cases × 8 px).
Sémantique vérifiée sur <code>RogueEssence/Content/Animation/Backgrounds/MapBG.cs</code>
et <code>DirSheet.cs</code> (RogueCollab/RogueEssence).</p>

<h2>Provenance et crédits</h2>
<ul>
<li><b>Halcyon (Palikadude/Halcyon)</b> — <code>Content/BG/Dream_Back.dir</code>,
<code>Dream_Front.dir</code> et <code>Data/Ground/personality_test.rsground</code>
(art de référence, crédit affiché ; pas des tuiles natives PMD canoniques).</li>
<li><b>PMD-SKY-PMDO-PORT (meromoonmeri)</b> — examiné : pipeline de conversion des maps
NDS (465 grounds, 569 tiles) ; pas d'asset de quiz à en extraire (le quiz n'est pas une MAP_BG).</li>
<li><b>Intégration quest</b> — <code>quest_pmd_destiny/</code> zone <code>personality_test</code>
(map + fonds), via <code>OUTILS/rendre_quiz_parallax.py --integrer-quest</code>.</li>
<li><b>Questions / résultats / starters / méga-évolutions</b> — contenu PMD Remixed en cours
de réception (fichier &gt; 100 Mo, découpe en volumes demandée) ; le quiz complet prendra place
sur ce fond.</li>
</ul>
<p class="note">Toutes les images de cette page sont régénérées par
<code>.venv/bin/python OUTILS/rendre_quiz_parallax.py</code> à partir des <code>.dir</code> natifs.</p>

<script>
const LAYERS = {cfg};
const W = {SCREEN_W}, H = {SCREEN_H};
const fond = document.getElementById('fond');
const bgImgs = LAYERS.map(b => {{ const im = new Image(); im.src = b.img; return im; }});

function drawFond(tick) {{
  const g = fond.getContext('2d');
  g.clearRect(0, 0, W, H);
  for (let i = 0; i < LAYERS.length; i++) {{
    const b = LAYERS[i], im = bgImgs[i];
    if (!im.complete) continue;
    const fi = Math.floor(tick / b.frame_time) % b.frames;
    const sx = (fi % b.cols) * b.w, sy = Math.floor(fi / b.cols) * b.h;
    // Loc : division entière tronquée vers zéro (comme le moteur)
    const dx = b.loc[0] + Math.trunc(b.move[0] * tick / 60);
    const dy = b.loc[1] + Math.trunc(b.move[1] * tick / 60);
    g.globalAlpha = b.alpha / 255;
    if (b.repeat_x) {{
      for (let x = dx % b.w - b.w; x < W; x += b.w)
        g.drawImage(im, sx, sy, b.w, b.h, x, dy, b.w, b.h);
    }} else g.drawImage(im, sx, sy, b.w, b.h, dx, dy, b.w, b.h);
    g.globalAlpha = 1;
  }}
}}

let start = performance.now(), paused = false, held = 0, lastTick = -1;
function frame(now) {{
  const tick = Math.floor((paused ? held : now - start) / 1000 * 60);
  if (tick !== lastTick) {{
    drawFond(tick);
    document.getElementById('tick').textContent = 'tick ' + tick + '  ·  ' +
      (tick / 60).toFixed(1) + ' s  ·  frame ' + (Math.floor(tick / {FRAME_TIME}) % {TOTAL_FRAMES});
    lastTick = tick;
  }}
  requestAnimationFrame(frame);
}}
function setZoom(z) {{
  const el = document.getElementById('stage');
  el.style.width = W * z + 'px';
  document.getElementById('fond').style.width = W * z + 'px';
  document.getElementById('fond').style.height = H * z + 'px';
}}
document.getElementById('pause').onclick = e => {{
  if (paused) {{ start = performance.now() - held; paused = false; e.target.textContent = 'Pause'; }}
  else {{ held = performance.now() - start; paused = true; e.target.textContent = 'Reprendre'; }}
}};
for (const z of [1, 2, 3]) document.getElementById('z' + z).onclick = () => setZoom(z);
document.getElementById('voile').onchange = e =>
  document.getElementById('quizui').style.display = e.target.checked ? 'flex' : 'none';
setZoom(2); drawFond(0); requestAnimationFrame(frame);
</script>
</body></html>
"""


# ---------------------------------------------------------------- quest

def integrer_quest(dir_root: Path) -> None:
    """Copie les assets du quiz dans la quest et déclare la zone personality_test."""
    bg = QUEST / 'Content' / 'BG'
    gr = QUEST / 'Data' / 'Ground'
    zn = QUEST / 'Data' / 'Zone'
    for d in (bg, gr, zn):
        d.mkdir(parents=True, exist_ok=True)
    for nom in ('Dream_Back', 'Dream_Front'):
        src = dir_root / f'{nom}.dir'
        dst = bg / f'{nom}.dir'
        dst.write_bytes(src.read_bytes())
        print(f'  quest ← {src.name} ({dst.stat().st_size} o)')
    src_map = dir_root.parent.parent / 'Data' / 'Ground' / 'personality_test.rsground'
    if not src_map.exists():
        src_map = Path('/tmp/halcyon/personality_test.rsground')
    dst_map = gr / 'personality_test.rsground'
    dst_map.write_bytes(src_map.read_bytes())
    print(f'  quest ← personality_test.rsground ({dst_map.stat().st_size} o)')

    # ZoneData (format identique aux autres Data/Zone/*.json)
    zone_path = zn / 'personality_test.json'
    zone = {
        'Version': '0.8.12.0',
        'Object': {
            '$type': 'RogueEssence.Data.ZoneData, RogueEssence',
            'Name': {'DefaultText': 'Personality Test (quiz)',
                     'LocalTexts': {'fr': 'Personality Test (quiz)'}},
            'Released': True,
            'Comment': ("Zone du quiz de personnalité — map personality_test.rsground + fonds "
                        "parallax Dream_Back/Dream_Front de Halcyon (Palikadude/Halcyon, crédit). "
                        "Sélecteur de héros/partenaire sur fond « Dream » défilant (±30 px/s). "
                        "Questions/résultats PMD Remixed à intégrer dès réception du fichier."),
            'NoEXP': False, 'ExpPercent': 100, 'Level': -1, 'LevelCap': False,
            'KeepSkills': False, 'TeamRestrict': False, 'TeamSize': -1,
            'MoneyRestrict': False, 'BagRestrict': -1, 'KeepTreasure': False,
            'BagSize': -1, 'Persistent': False, 'Rescues': 0, 'Rogue': 0,
            'Segments': [], 'GroundMaps': ['personality_test'],
        },
    }
    zone_path.write_text(json.dumps(zone, indent=1, ensure_ascii=False) + '\n', encoding='utf-8')
    print(f'  quest ← {zone_path.relative_to(QUEST)}')

    # index.idx : dictionnaire JSON utf-8-sig (JAMAIS réécrire en liste de lignes)
    idx_path = zn / 'index.idx'
    idx = json.loads(idx_path.read_text(encoding='utf-8-sig'))
    obj = idx['Object']
    if 'personality_test' in obj:
        print('  index.idx : entrée personality_test déjà présente')
        return
    obj['personality_test'] = {
        '$type': 'RogueEssence.Data.ZoneEntrySummary, RogueEssence',
        'ExpPercent': 100, 'Level': -1, 'LevelCap': False, 'KeepSkills': False,
        'TeamRestrict': False, 'TeamSize': -1, 'MoneyRestrict': False,
        'BagRestrict': -1, 'KeepTreasure': False, 'BagSize': -1, 'Rescues': 0,
        'CountedFloors': 0, 'Rogue': 0,
        'Grounds': ['personality_test'], 'Maps': [],
        'Name': {'DefaultText': 'personality_test',
                 'LocalTexts': {'fr': 'personality_test'}},
        'Released': True,
        'Comment': ('Zone du quiz de personnalité (parallax Dream Halcyon) — map + fonds, '
                    'crédit Halcyon ; contenu PMD Remixed à venir.'),
        'SortOrder': max((v.get('SortOrder', -1) for v in obj.values()
                          if isinstance(v, dict)), default=0) + 1,
    }
    txt = json.dumps(idx, indent=1, ensure_ascii=False)
    idx_path.write_text('\ufeff' + txt + '\n', encoding='utf-8')
    # validation : relecture + compte
    idx2 = json.loads(idx_path.read_text(encoding='utf-8-sig'))
    assert len(idx2['Object']) == len(obj), 'index.idx corrompu à la relecture'
    print(f'  index.idx : entrée personality_test ajoutée ({len(obj)} zones)')


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--dir-root', type=Path, default=None,
                    help='dossier contenant Dream_Back.dir / Dream_Front.dir')
    ap.add_argument('--integrer-quest', action='store_true',
                    help='copie les assets dans quest_pmd_destiny/ + déclare la zone')
    args = ap.parse_args()

    candidats = [args.dir_root] if args.dir_root else [
        QUEST / 'Content' / 'BG',
        Path('/tmp/halcyon/Content/BG'),
    ]
    dir_root = next((p for p in candidats if p and (p / 'Dream_Back.dir').exists()), None)
    if dir_root is None:
        print('Aucun dossier avec Dream_Back.dir trouvé (--dir-root ?)', file=sys.stderr)
        return 1
    print(f'Source : {dir_root}')
    exporter(dir_root)
    PAGE.write_text(page_html(), encoding='utf-8')
    print(f'  page → {PAGE}')
    if args.integrer_quest:
        print('Intégration quest :')
        integrer_quest(dir_root)
    print('Terminé.')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
