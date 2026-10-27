#!/usr/bin/env python3
"""Badge étoile du quiz de personnalité — couleurs par nature.

Dans PMD Explorers of Sky, la conclusion du quiz révèle l'aura sur un **ruban**
(l'« Aura Bow » : blanc, il se colore au toucher — couleur tirée des réglages
de la console). Dans PMD Destiny, ce ruban est remplacé par le **badge étoile
de l'opening** (pendentif étoile pixel-art, ``vfx_bruts/badge_*.png`` de
``source/pmd_destiny_fangame_v1``, branche ``arena/e39626d2``) dont la couleur
suit **la nature conclue et la conclusion du quiz**.

Ce script :
  1. récupère ``badge_amber.png`` (badge de l'opening, art de l'utilisateur) ;
  2. génère les **16 couleurs de natures** + le **blanc « avant analyse »**
     par recolorisation HSV fidèle : rotation de teinte des pixels chromatiques
     (ancre ambre 30°), reflets blancs préservés, contour teinté dans la
     couleur, fond magenta (clé de transparence) converti en alpha ;
  3. écrit les PNG dans ``quest_pmd_destiny/Content/UI/quiz_badges/`` + une
     planche-contact dans ``apercus/quiz_badges/`` ;
  4. écrit ``quest_pmd_destiny/Data/quiz_personnalite_natures.json`` — table
     des 16 natures (index = ordre ROM ``STARTERS_HERO_IDS`` de Sky,
     ``pret/pmd-sky`` overlay_13) : couleur, nature FR/EN, starter héros
     conclu ♂/♀ ;
  5. écrit ``apercu_badge_quiz_natures.html`` (simulateur de conclusion +
     galerie + mécanique du quiz) pour la visionneuse.

Usage :
    .venv/bin/python OUTILS/generer_badge_quiz.py [--source /chemin/badge_amber.png]
"""
from __future__ import annotations

import argparse
import colorsys
import json
import sys
from pathlib import Path

from PIL import Image

R = Path(__file__).resolve().parents[1]
QUEST = R / 'quest_pmd_destiny'
OUT_UI = QUEST / 'Content' / 'UI' / 'quiz_badges'
OUT_SHEET = R / 'apercus' / 'quiz_badges'
PAGE = R / 'apercu_badge_quiz_natures.html'
JSON_NATURES = QUEST / 'Data' / 'quiz_personnalite_natures.json'

# Teinte ancre du badge ambre de l'opening (remplissage ≈ 25-42°)
HUE_ANCRE = 30.0

# 16 natures du quiz de Sky, index = ordre des paires STARTERS_HERO_IDS (ROM).
# Couleurs : palette « Destiny » (une teinte par nature). Les variantes Cyan
# (Quirky) et Émeraude (Quiet) reprennent les badges déjà peints de l'opening.
NATURES = [
    # (fr, en, nom couleur, hex, hue, sat, val, héros ♂, héros ♀)
    ('Hardi',     'Hardy',   'Or',        '#E8A020',  37, 0.82, 0.92, 'Poussifeu',   'Arcko'),
    ('Docile',    'Docile',  'Sable',     '#D8C050',  50, 0.62, 0.90, 'Reptincel',   'Bulbizarre'),
    ('Brave',     'Brave',   'Écarlate',  '#E03028',   2, 0.85, 0.90, 'Pikachu',     'Reptincel'),
    ('Joyeux',    'Jolly',   'Citron',    '#E8D828',  56, 0.80, 0.95, 'Kaiminus',    'Évoli'),
    ('Malicieux', 'Impish',  'Améthyste', '#9040D0', 272, 0.72, 0.85, 'Tiplouf',     'Ouisticram'),
    ('Naïf',      'Naive',   'Rose',      '#F070B0', 332, 0.72, 0.95, 'Ouisticram',  'Skitty'),
    ('Timide',    'Timid',   'Bleu brume','#6098D8', 208, 0.62, 0.88, 'Héricendre',  'Tortipouss'),
    ('Pressé',    'Hasty',   'Mandarine', '#F06820',  20, 0.88, 0.94, 'Lixy',        'Pikachu'),
    ('Malin',     'Sassy',   'Indigo',    '#5848C8', 250, 0.72, 0.80, 'Riolu',       'Kaiminus'),
    ('Calme',     'Calm',    'Menthe',    '#40C898', 155, 0.68, 0.85, 'Germignon',   'Héricendre'),
    ('Relax',     'Relaxed', 'Lagune',    '#28A0B8', 190, 0.78, 0.78, 'Phanpy',      'Goupix'),
    ('Solo',      'Lonely',  'Bleu nuit', '#28406E', 232, 0.70, 0.55, 'Bulbizarre',  'Gobou'),
    ('Bizarre',   'Quirky',  'Cyan',      '#28C8C8', 178, 0.82, 0.82, 'Carapuce',    'Tiplouf'),
    ('Discret',   'Quiet',   'Émeraude',  '#28B058', 142, 0.82, 0.72, 'Arcko',       'Germignon'),
    ('Précipité', 'Rash',    'Magenta',   '#D02890', 318, 0.82, 0.88, 'Gobou',       'Poussifeu'),
    ('Assuré',    'Bold',    'Saphir',    '#2858D0', 222, 0.82, 0.85, 'Tortipouss',  'Carapuce'),
]
SLUGS = ['hardy', 'docile', 'brave', 'jolly', 'impish', 'naive', 'timid', 'hasty',
         'sassy', 'calm', 'relaxed', 'lonely', 'quirky', 'quiet', 'rash', 'bold']


def est_fond(r: int, g: int, b: int) -> bool:
    """Fond magenta (clé de transparence) des bruts de l'opening."""
    return r > 170 and b > 170 and g < 130


def charger_badge(path: Path) -> Image.Image:
    """RGBA avec alpha = hors fond magenta ; nettoyage des bords."""
    im = Image.open(path).convert('RGB')
    w, h = im.size
    out = Image.new('RGBA', (w, h))
    src, dst = im.load(), out.load()
    for y in range(h):
        for x in range(w):
            r, g, b = src[x, y]
            dst[x, y] = (0, 0, 0, 0) if est_fond(r, g, b) else (r, g, b, 255)
    # léger lissage : pixels seuls sur fond transparent → transparent
    alpha = out.getchannel('A')
    ap = alpha.load()
    for y in range(1, h - 1):
        for x in range(1, w - 1):
            if ap[x, y] and sum(1 for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))
                                if ap[x + dx, y + dy]) <= 1:
                dst[x, y] = (0, 0, 0, 0)
    return out


def recolorier(im: Image.Image, hue: float, sat: float, val: float,
               blanc: bool = False) -> Image.Image:
    """Rotation de teinte fidèle (ancre ambre) ; reflets blancs préservés."""
    px = im.load()
    w, h = im.size
    out = Image.new('RGBA', (w, h))
    op = out.load()
    dh = (hue - HUE_ANCRE) / 360.0
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if not a:
                continue
            hh, ss, vv = colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)
            if blanc:
                # variante « avant analyse » : quasi-négre, léger halo perle
                ns, nv = ss * 0.10, min(1.0, vv * 1.02)
                nr, ng, nb = colorsys.hsv_to_rgb(hh, ns, nv)
                op[x, y] = (int(nr * 255), int(ng * 255), int(nb * 255), a)
                continue
            if ss < 0.12:
                # reflet blanc : très légère teinte (8 %) pour lier au groupe
                nr, ng, nb = colorsys.hsv_to_rgb((hh + dh) % 1.0, ss + 0.08, vv)
                op[x, y] = (int(nr * 255), int(ng * 255), int(nb * 255), a)
                continue
            ns = min(1.0, ss * (sat / 0.82))
            nv = min(1.0, vv * (val / 0.90))
            # les ombres profondes (contour) restent sombres
            if vv < 0.35:
                nv = vv
            nr, ng, nb = colorsys.hsv_to_rgb((hh + dh) % 1.0, ns, nv)
            op[x, y] = (int(nr * 255), int(ng * 255), int(nb * 255), a)
    return out


def rogner(im: Image.Image, marge: int = 12) -> Image.Image:
    box = im.getbbox()
    if not box:
        return im
    x0, y0, x1, y1 = box
    x0, y0 = max(0, x0 - marge), max(0, y0 - marge)
    x1, y1 = min(im.size[0], x1 + marge), min(im.size[1], y1 + marge)
    return im.crop((x0, y0, x1, y1))


def planche(images: list[tuple[str, Image.Image]], path: Path) -> None:
    """Planche-contact 4×4 (vignettes 220 px) sans texte (voir page HTML)."""
    cell, cols = 220, 4
    rows = (len(images) + cols - 1) // cols
    sh = Image.new('RGBA', (cols * cell, rows * cell), (24, 20, 40, 255))
    for i, (_, im) in enumerate(images):
        t = im.copy()
        t.thumbnail((cell - 12, cell - 12))
        cx = (i % cols) * cell + (cell - t.size[0]) // 2
        cy = (i // cols) * cell + (cell - t.size[1]) // 2
        sh.alpha_composite(t, (cx, cy))
    sh.save(path)


def page_html() -> str:
    natures_js = []
    for i, (fr, en, nom, hexc, hue, sat, val, hm, hf) in enumerate(NATURES):
        natures_js.append({'i': i, 'fr': fr, 'en': en, 'couleur': nom, 'hex': hexc,
                           'img': f'apercus/quiz_badges/badge_{SLUGS[i]}.png',
                           'male': hm, 'femelle': hf})
    boutons = ''.join(
        f'<button class="nat" data-i="{i}" style="background:{hexc}">{fr}</button>'
        for i, (fr, en, nom, hexc, *_rest) in enumerate(NATURES))
    lignes = ''.join(
        f'<tr><td>{i}</td><td>{fr} <small>({en})</small></td>'
        f'<td><span class="pastille" style="background:{hexc}"></span>{nom} '
        f'<code>{hexc}</code></td><td>{hm}</td><td>{hf}</td></tr>'
        for i, (fr, en, nom, hexc, _h, _s, _v, hm, hf) in enumerate(NATURES))
    galerie = ''.join(
        f'<figure><img src="apercus/quiz_badges/badge_{SLUGS[i]}.png" alt="{fr}">'
        f'<figcaption style="color:{hexc}">{fr} — {nom}</figcaption></figure>'
        for i, (fr, en, nom, hexc, *_r) in enumerate(NATURES))
    cfg = json.dumps(natures_js, separators=(',', ':'))
    return f"""<!doctype html><html lang="fr"><head><meta charset="utf-8">
<title>Quiz de personnalité — badge étoile par nature</title>
<style>
body {{ background:#141220; color:#eee; font:15px/1.55 system-ui,sans-serif; max-width:1100px; margin:18px auto; padding:0 12px }}
a {{ color:#ffd76a }} small {{ color:#999 }}
h1 {{ font-size:24px }} h2 {{ font-size:18px; margin-top:28px; border-bottom:1px solid #333; padding-bottom:4px }}
.bar {{ display:flex; gap:8px; flex-wrap:wrap; margin:12px 0 }}
button.nat {{ border:1px solid #0008; border-radius:8px; padding:6px 10px; cursor:pointer;
  color:#1a1208; font-weight:600; text-shadow:0 1px 0 #fff6 }}
button.nat.sel {{ outline:3px solid #ffd76a }}
.stage {{ position:relative; width:640px; max-width:100%; height:480px; overflow:hidden;
  border:1px solid #333; border-radius:10px; background:#241c38 }}
.stage img.fond {{ position:absolute; width:200%; height:100%; image-rendering:pixelated; opacity:.95 }}
.stage img.badge {{ position:absolute; left:50%; top:46%; width:280px; transform:translate(-50%,-50%);
  filter:drop-shadow(0 6px 18px #0009); transition:opacity .25s }}
.stage .voile {{ position:absolute; inset:0; background:radial-gradient(circle at 50% 40%, #0000 40%, #12081ccc 100%) }}
.stage .conclusion {{ position:absolute; left:0; right:0; bottom:14px; text-align:center }}
.stage .conclusion .nom {{ font-size:22px; font-weight:700 }}
.stage .conclusion .det {{ background:#191430d9; border:1px solid #7a6cc0; border-radius:10px;
  display:inline-block; padding:6px 14px; margin-top:6px; font-size:13px }}
table {{ border-collapse:collapse }} td, th {{ border:1px solid #443c2c; padding:3px 10px; font-size:13px }}
.pastille {{ display:inline-block; width:14px; height:14px; border-radius:4px; margin-right:6px;
  border:1px solid #0008; vertical-align:-2px }}
.gal {{ display:grid; grid-template-columns:repeat(auto-fill,minmax(150px,1fr)); gap:10px }}
.gal figure {{ margin:0; background:#221e33; border:1px solid #3c3560; border-radius:8px; padding:8px; text-align:center }}
.gal img {{ width:100%; image-rendering:pixelated }}
.gal figcaption {{ font-size:12px; margin-top:4px }}
.note {{ background:#221e33; border:1px solid #3c3560; border-radius:8px; padding:10px 14px }}
</style></head><body>
<p><a href="/">← Index de la visionneuse</a> ·
<a href="apercu_personality_quiz_parallax.html">Parallax du quiz</a></p>
<h1>Quiz de personnalité — badge étoile par nature</h1>
<p>Dans Sky, la conclusion du quiz se joue sur un <b>ruban</b> (l'« Aura Bow »)
qui se colore au toucher. Dans <b>PMD Destiny</b>, il est remplacé par le
<b>badge étoile de l'opening</b>, dont la couleur change selon la
<b>nature conclue</b> et affiche la conclusion (le starter héros ♂/♀).
Cliquez une nature pour simuler la conclusion :</p>

<div class="bar" id="bar">{boutons}</div>
<div class="stage">
  <img class="fond" src="apercus/quiz/Dream_Back.png" alt="">
  <div class="voile"></div>
  <img class="badge" id="badge" src="apercus/quiz_badges/badge_blanc.png" alt="badge étoile">
  <div class="conclusion">
    <div class="nom" id="nom">Avant analyse — appuyez sur une nature</div>
    <div class="det" id="det">Le badge est blanc, comme le ruban avant l'analyse de l'aura.</div>
  </div>
</div>

<h2>Les 16 natures et leur badge</h2>
<div class="gal">
<figure><img src="apercus/quiz_badges/badge_blanc.png" alt="blanc">
<figcaption>Avant analyse — blanc</figcaption></figure>
{galerie}
</div>

<h2>Table de conclusion (tables ROM de Sky)</h2>
<table>
<tr><th>#</th><th>Nature</th><th>Couleur du badge</th><th>Héros ♂</th><th>Héros ♀</th></tr>
{lignes}
</table>
<p class="note"><b>Mécanique du quiz (PMD Explorers of Sky, décomp
<code>pret/pmd-sky</code> overlay_13).</b> Pool de <b>64 questions</b>
(<code>QUIZ_QUESTION_STRINGS</code>) dont <b>8 tirées au hasard</b>, plus la
question d'intro « Avez-vous joué à Time/Darkness ? » (bonus de départage qui
augmente aussi les chances des starters ajoutés) et la question de genre.
Chaque réponse distribue <b>0 à 4 points</b> sur les <b>16 personnalités</b>
(<code>QUIZ_ANSWER_POINTS</code> = 128 réponses × 16 scores) ;
<code>GetPersonality()</code> renvoie le score maximal (bonus
<code>tiebreaker</code> en cas d'égalité). La nature + le genre donnent le
starter héros via <code>STARTERS_HERO_IDS</code> (16 paires ♂/♀) ; le
partenaire se choisit dans <code>STARTERS_PARTNER_IDS</code> (21 espèces).
Le <b>ruban d'aura</b> du résultat (couleur issue des réglages de la DS)
devient ici le <b>badge étoile</b> dont la couleur = la nature.</p>

<h2>Provenance</h2>
<ul>
<li>Badge étoile : <code>vfx_bruts/badge_amber.png</code> de
<code>source/pmd_destiny_fangame_v1</code> (branche <code>arena/e39626d2</code>)
— art de l'utilisateur, présent dans l'opening PMD Destiny. Variantes Cyan et
Émeraude déjà peintes dans les sources ; les 16 couleurs de natures sont
générées par recolorisation fidèle (<code>OUTILS/generer_badge_quiz.py</code>),
reflets blancs et contours préservés. <i>art_approved: false</i> (recolorisations
à valider).</li>
<li>Questions/starters/méga-évolutions de <b>PMD Remixed</b> : toujours en attente
de réception du fichier ; ils s'appuieront sur cette mécanique.</li>
<li>Mécanique et tables : ROM Sky (<code>pret/pmd-sky</code>, données
désassemblées) consultées comme <b>référence de conception</b> — aucun texte ni
graphisme commercial n'est redistribué dans la quest.</li>
</ul>
<p class="note">Régénération : <code>.venv/bin/python OUTILS/generer_badge_quiz.py</code>.</p>

<script>
const NAT = {cfg};
const badge = document.getElementById('badge');
for (const b of document.querySelectorAll('button.nat')) {{
  b.onclick = () => {{
    document.querySelectorAll('button.nat').forEach(x => x.classList.remove('sel'));
    b.classList.add('sel');
    const n = NAT[+b.dataset.i];
    badge.style.opacity = 0;
    setTimeout(() => {{ badge.src = n.img; badge.style.opacity = 1; }}, 180);
    document.getElementById('nom').textContent = 'Nature : ' + n.fr + ' (' + n.en + ')';
    document.getElementById('nom').style.color = n.hex;
    document.getElementById('det').innerHTML =
      'Badge <b>' + n.couleur + '</b> <code>' + n.hex + '</code> — conclusion : héros <b>' +
      n.male + '</b> (♂) ou <b>' + n.femelle + '</b> (♀)';
  }};
}}
</script>
</body></html>
"""


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--source', type=Path, default=None,
                    help='badge_amber.png de l\'opening (défaut : cache /tmp ou arbre archive)')
    args = ap.parse_args()

    candidats = [args.source] if args.source else [
        Path('/tmp/destiny-logo/source/pmd_destiny_fangame_v1/vfx_bruts/badge_amber.png'),
        R / 'OUTILS' / 'ressources_badge' / 'badge_amber.png',
    ]
    src = next((p for p in candidats if p and p.exists()), None)
    if src is None:
        print('badge_amber.png introuvable (--source ?)', file=sys.stderr)
        return 1
    print(f'Source : {src}')

    # conserver une copie de la source dans le dépôt pour régénération hors-ligne
    depot = R / 'OUTILS' / 'ressources_badge'
    depot.mkdir(parents=True, exist_ok=True)
    copie = depot / 'badge_amber.png'
    if not copie.exists() or copie.read_bytes() != src.read_bytes():
        copie.write_bytes(src.read_bytes())
        print(f'  source copiée → {copie}')

    OUT_UI.mkdir(parents=True, exist_ok=True)
    OUT_SHEET.mkdir(parents=True, exist_ok=True)
    base = charger_badge(src)

    images = [('blanc', rogner(recolorier(base, 0, 0, 0, blanc=True)))]
    images[0][1].save(OUT_UI / 'badge_etoile_blanc.png')
    images[0][1].save(OUT_SHEET / 'badge_blanc.png')
    print('  badge_blanc.png (avant analyse)')

    for i, (fr, en, nom, hexc, hue, sat, val, _hm, _hf) in enumerate(NATURES):
        im = rogner(recolorier(base, hue, sat, val))
        im.save(OUT_UI / f'badge_etoile_{SLUGS[i]}.png')
        im.save(OUT_SHEET / f'badge_{SLUGS[i]}.png')
        print(f'  badge_{SLUGS[i]}.png — {fr} ({nom} {hexc})')
    planche(images + [(s, Image.open(OUT_SHEET / f'badge_{s}.png')) for s in SLUGS],
            OUT_SHEET / 'planche_natures.png')

    doc = {
        'Version': '0.8.12.0',
        'Object': {
            '$type': 'RogueEssence.Data.DataType, RogueEssence',
            'Comment': ("Quiz de personnalité — 16 natures (ordre = STARTERS_HERO_IDS de "
                        "PMD Explorers of Sky, pret/pmd-sky overlay_13). Le ruban d'aura "
                        "est remplacé par le badge étoile de l'opening (Content/UI/quiz_badges), "
                        "coloré selon la nature conclue. Questions/résultats PMD Remixed à venir."),
            'Natures': [],
        },
    }
    for i, (fr, en, nom, hexc, hue, sat, val, hm, hf) in enumerate(NATURES):
        doc['Object']['Natures'].append({
            'Index': i, 'NomFR': fr, 'NomEN': en,
            'Couleur': {'Nom': nom, 'Hex': hexc, 'Hue': hue, 'Sat': sat, 'Val': val},
            'Badge': f'Content/UI/quiz_badges/badge_etoile_{SLUGS[i]}.png',
            'HerosMale': hm, 'HerosFemelle': hf,
        })
    doc['Object']['Natures'].append({
        'Index': -1, 'NomFR': 'Avant analyse', 'NomEN': 'Unrevealed',
        'Couleur': {'Nom': 'Blanc', 'Hex': '#E8E8F0', 'Hue': 0, 'Sat': 0, 'Val': 1},
        'Badge': 'Content/UI/quiz_badges/badge_etoile_blanc.png',
        'HerosMale': '', 'HerosFemelle': '',
    })
    JSON_NATURES.write_text(json.dumps(doc, indent=1, ensure_ascii=False) + '\n',
                            encoding='utf-8')
    print(f'  table → {JSON_NATURES}')

    PAGE.write_text(page_html(), encoding='utf-8')
    print(f'  page → {PAGE}')
    print('Terminé.')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
