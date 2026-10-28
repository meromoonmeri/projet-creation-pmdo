#!/usr/bin/env python3
"""Génère le simulateur du quiz de personnalité PMD Destiny (15 questions).

Sources (single source of truth) :
  * ``quest_pmd_destiny/Data/quiz_personnalite_config.json`` — 15 questions
    (textes originaux), pool de 36 starters (gen 1-9 + extras), mapping
    nature → starter, talents, méga-évolution ;
  * ``quest_pmd_destiny/Data/quiz_personnalite_natures.json`` — 16 natures,
    couleurs et badges étoile (générés par ``generer_badge_quiz.py``).

Sorties :
  * ``apercu_quiz_destiny_15_questions.html`` — simulateur jouable pour la
    visionneuse : 15 questions → couleur de badge → starter selon la nature →
    choix du sexe et du talent → confirmation « Êtes-vous sûr… ? » avec la
    mention méga-évolution en lettres arc-en-ciel (chaque lettre sa couleur) ;
  * ``quest_pmd_destiny/Data/Script/ground/personality_test/quiz_data.lua`` —
    miroir des données pour le script Lua du jeu.

Le flux s'inspire de la structure du ``personality_test`` de Halcyon
(Palikadude/Halcyon) : choix du sexe, choix du talent (Intrinsic1/2/3),
confirmation — code de notre écriture, aucun fichier Halcyon copié.

Usage : .venv/bin/python OUTILS/generer_quiz_destiny.py
"""
from __future__ import annotations

import json
from pathlib import Path

R = Path(__file__).resolve().parents[1]
QUEST = R / 'quest_pmd_destiny'
CONFIG = QUEST / 'Data' / 'quiz_personnalite_config.json'
NATURES = QUEST / 'Data' / 'quiz_personnalite_natures.json'
LUA_DIR = QUEST / 'Data' / 'Script' / 'ground' / 'personality_test'
PAGE = R / 'apercu_quiz_destiny_15_questions.html'

RAINBOW = ['#FF4D4D', '#FF9E2B', '#FFE12B', '#8CE02B', '#2BD9FF', '#3B76FF', '#A64DFF']


def rainbow_span(texte: str) -> str:
    """Chaque lettre dans une couleur de l'arc-en-ciel (HTML)."""
    out, i = [], 0
    for car in texte:
        if car in ' -':
            out.append(car)
        else:
            out.append(f'<span style="color:{RAINBOW[i % len(RAINBOW)]}">{car}</span>')
            i += 1
    return ''.join(out)


def charger() -> tuple[dict, dict]:
    cfg = json.loads(CONFIG.read_text(encoding='utf-8'))['Object']
    nat = json.loads(NATURES.read_text(encoding='utf-8'))['Object']['Natures']
    return cfg, {n['NomEN'].lower(): n for n in nat if n['Index'] >= 0}


def ecrire_lua(cfg: dict, nats: dict) -> None:
    """Miroir Lua des données (le script du jeu lit cette table)."""
    LUA_DIR.mkdir(parents=True, exist_ok=True)
    L = LUA_DIR / 'quiz_data.lua'
    parts = ['-- Généré par OUTILS/generer_quiz_destiny.py — NE PAS ÉDITER À LA MAIN.\n',
             '-- Données du quiz de personnalité PMD Destiny (15 questions, 16 natures,\n',
             '-- pool starters gen 1-9 + extras, mapping, méga-évolution).\n',
             'local quiz_data = {}\n\n']

    parts.append('quiz_data.questions = {\n')
    for q in cfg['Questions']:
        choix = ', '.join(
            '{ texte = %s, points = { %s } }' % (
                lua_str(c['Texte']),
                ', '.join(f'{k} = {v}' for k, v in c['Points'].items()))
            for c in q['Choix'])
        parts.append(f'  {{ texte = {lua_str(q["Texte"])}, choix = {{ {choix} }} }},\n')
    parts.append('}\n\n')

    parts.append('quiz_data.natures = {\n')
    for slug, n in sorted(nats.items(), key=lambda kv: kv[1]['Index']):
        c = n['Couleur']
        parts.append(
            f'  {{ slug = "{slug}", fr = {lua_str(n["NomFR"])}, en = {lua_str(n["NomEN"])}, '
            f'couleur = "{c["Nom"]}", hex = "{c["Hex"]}" }},\n')
    parts.append('}\n\n')

    parts.append('quiz_data.starters = {\n')
    for s in cfg['Starters']:
        talents = ', '.join(lua_str(t) for t in s['Talents'])
        mega = lua_str(s['MegaNom']) if s.get('Mega') else 'nil'
        parts.append(
            f'  ["{s["Id"]}"] = {{ espece = "{s["Espece"]}", forme = {s["Forme"]}, '
            f'nom = {lua_str(s["NomFR"])}, gen = {s["Gen"]}, '
            f'talents = {{ {talents} }}, mega = {mega} }},\n')
    parts.append('}\n\n')

    parts.append('quiz_data.mapping = {\n')
    for m in cfg['Mapping']:
        parts.append(f'  ["{m["Nature"]}"] = "{m["Starter"]}",\n')
    parts.append('}\n\n')
    parts.append(f'quiz_data.mega_texte = {lua_str(cfg["MegaTexteFR"])}\n')
    parts.append('return quiz_data\n')
    L.write_text(''.join(parts), encoding='utf-8')
    print(f'  lua  → {L}')


def lua_str(s: str) -> str:
    return '"' + s.replace('\\', '\\\\').replace('"', '\\"') + '"'


def ecrire_page(cfg: dict, nats: dict) -> None:
    # badge slug depuis le chemin des natures (badge_etoile_<slug>.png)
    for slug, n in nats.items():
        n['img'] = f"apercus/quiz_badges/badge_{Path(n['Badge']).stem.replace('badge_etoile_', '')}.png"
    starters = {s['Id']: s for s in cfg['Starters']}
    for m in cfg['Mapping']:
        starters[m['Starter']]['nature'] = m['Nature']

    data = {
        'questions': cfg['Questions'],
        'natures': [{'slug': s, 'fr': n['NomFR'], 'en': n['NomEN'], 'hex': n['Couleur']['Hex'],
                     'couleur': n['Couleur']['Nom'], 'img': n['img']} for s, n in nats.items()],
        'starters': [{'id': s['Id'], 'nom': s['NomFR'], 'gen': s['Gen'], 'types': s['Types'],
                      'talents': s['Talents'], 'mega': bool(s.get('Mega')),
                      'megaNom': s.get('MegaNom', ''), 'forme': s['Forme'],
                      'espece': s['Espece'], 'nature': s.get('nature', '')}
                     for s in cfg['Starters'] if 'nature' in s],
        'megaTexte': cfg['MegaTexteFR'],
        'rainbow': RAINBOW,
    }
    js = json.dumps(data, separators=(',', ':'), ensure_ascii=False)
    mega_rainbow = rainbow_span(cfg['MegaTexteFR'])

    html = f"""<!doctype html><html lang="fr"><head><meta charset="utf-8">
<title>Quiz de personnalité PMD Destiny — 15 questions</title>
<style>
body {{ background:#141220; color:#eee; font:15px/1.55 system-ui,sans-serif; max-width:1000px; margin:18px auto; padding:0 12px }}
a {{ color:#ffd76a }} small {{ color:#999 }}
h1 {{ font-size:24px }} h2 {{ font-size:18px; margin-top:28px; border-bottom:1px solid #333; padding-bottom:4px }}
.note {{ background:#221e33; border:1px solid #3c3560; border-radius:8px; padding:10px 14px }}
.scene {{ position:relative; overflow:hidden; border:1px solid #333; border-radius:12px;
  background:#241c38; min-height:470px; padding:22px 26px; box-sizing:border-box }}
.scene .fond {{ position:absolute; inset:0; width:200%; height:100%; object-fit:cover;
  image-rendering:pixelated; opacity:.55 }}
.scene .voile {{ position:absolute; inset:0; background:radial-gradient(circle at 50% 30%, #0000 30%, #140a24dd 100%) }}
.scene .contenu {{ position:relative; z-index:2 }}
.progress {{ height:10px; background:#2c2547; border-radius:6px; overflow:hidden; margin:10px 0 18px }}
.progress i {{ display:block; height:100%; width:0; background:linear-gradient(90deg,#ffd76a,#ff7a9e); transition:width .3s }}
.qtexte {{ font-size:19px; font-weight:600; margin:14px 0 20px }}
.choix {{ display:flex; flex-direction:column; gap:12px }}
.choix button {{ text-align:left; background:#2d2752d9; color:#fff; border:1px solid #8a7ad0;
  border-radius:10px; padding:12px 16px; font-size:15px; cursor:pointer }}
.choix button:hover {{ background:#403a6d }}
.cartebadge {{ text-align:center; padding:18px 0 }}
.cartebadge img {{ width:230px; image-rendering:pixelated; filter:drop-shadow(0 8px 22px #000a) }}
.natnom {{ font-size:26px; font-weight:700; margin:8px 0 }}
.pastille {{ display:inline-block; width:16px; height:16px; border-radius:5px; border:1px solid #0008;
  vertical-align:-2px; margin-right:8px }}
.type {{ display:inline-block; background:#3a3460; border-radius:8px; padding:2px 10px; margin:2px;
  font-size:12px }}
.boite {{ background:#191430d9; border:1px solid #7a6cc0; border-radius:12px; padding:14px 18px;
  margin:12px 0; max-width:560px; margin-left:auto; margin-right:auto }}
.dlg {{ font-size:17px; text-align:center; margin:10px 0 16px }}
.boutons {{ display:flex; gap:12px; justify-content:center; flex-wrap:wrap }}
.boutons button {{ min-width:120px; background:#34304e; color:#eee; border:1px solid #6b5fa8;
  border-radius:8px; padding:10px 18px; font-size:15px; cursor:pointer }}
.boutons button.primaire {{ background:#5a4bb8; border-color:#9a8ae0; font-weight:700 }}
.boutons button:hover {{ filter:brightness(1.15) }}
.radio {{ display:flex; gap:12px; justify-content:center; flex-wrap:wrap; margin:12px 0 }}
.radio button {{ background:#2d2752d9; color:#fff; border:1px solid #8a7ad0; border-radius:10px;
  padding:10px 18px; cursor:pointer; font-size:15px }}
.radio button.sel {{ outline:3px solid #ffd76a }}
.megaligne {{ text-align:center; font-size:21px; font-weight:800; letter-spacing:1px; margin:12px 0;
  text-shadow:0 0 18px #fff3 }}
.resume {{ text-align:center }}
.resume img {{ width:150px; image-rendering:pixelated }}
table {{ border-collapse:collapse; width:100% }} td, th {{ border:1px solid #443c2c; padding:4px 10px; font-size:13px }}
details {{ background:#221e33; border:1px solid #3c3560; border-radius:8px; padding:10px 14px; margin:10px 0 }}
summary {{ cursor:pointer; font-weight:600 }}
</style></head><body>
<p><a href="/">← Index de la visionneuse</a> ·
<a href="apercu_personality_quiz_parallax.html">Parallax du quiz</a> ·
<a href="apercu_badge_quiz_natures.html">Badges par nature</a></p>
<h1>Quiz de personnalité PMD Destiny — 15 questions</h1>
<p>Le chemin complet du quiz de notre quest : <b>15 questions à la PMD</b> →
<b>couleur de badge</b> (le badge étoile de l'opening remplace le ruban d'aura de
Sky) → <b>starter selon la nature</b> (pool gen 1-9 + Goupix, Goupix d'Alola,
Zorua, Zorua de Hisui, Miaouss, Skitty, Évoli, Pikachu, Charcadet) → choix du
<b>sexe</b> et du <b>talent</b> → confirmation, avec la mention méga-évolution
en lettres arc-en-ciel. Testez :</p>

<audio id="bgm" loop preload="none" src="quest_pmd_destiny/Content/Music/Welcome%20to%20the%20World%20of%20Pok%C3%A9mon%21.ogg"></audio>
<p><button id="musique">♪ Musique : OFF</button>
<small>— musique du personality quiz de Halcyon (« Welcome to the World of Pokémon! »)</small></p>

<div class="scene" id="scene">
  <img class="fond" src="apercus/quiz/Dream_Back.png" alt="">
  <div class="voile"></div>
  <div class="contenu" id="contenu"></div>
</div>

<h2>Données du quiz</h2>
<details open><summary>15 questions (textes originaux PMD Destiny) + points par nature</summary>
<div id="tableau"></div>
</details>
<details><summary>Mapping nature → starter (16) — pool complet en JSON</summary>
<div id="mapping"></div>
</details>

<h2>Notes de conception</h2>
<ul>
<li><b>Mécanique</b> : chaque réponse distribue +4/+2 points sur les 16 natures
(les slugs et couleurs = <code>quiz_personnalite_natures.json</code>) ; la nature
gagnante donne sa couleur au badge étoile et désigne le starter
(<code>quiz_personnalite_config.json</code>).</li>
<li><b>Flux façon Halcyon</b> : choix du sexe (Garçon / Fille / Non-binaire) puis
du talent (les talents affichés viennent des données du jeu, Intrinsic1/2/3 comme
dans le <code>personality_test</code> de Halcyon), puis confirmation
« Êtes-vous sûr de sélectionner ce Pokémon ? ». Code Lua rédigé pour la quest
(rien copié de Halcyon — structure observée uniquement).</li>
<li><b>Méga-évolution</b> : si le starter est éligible, la confirmation affiche
{mega_rainbow} en lettres d'arc-en-ciel (balises <code>[color=#RRGGBB]</code>
du moteur, une par lettre — vérifié sur <code>RogueEssence/Text.cs</code>).</li>
<li>Honnêteté : <code>runtime_tested: false</code> (aucun lancement PMDO depuis
le sandbox) — le script <code>Data/Script/ground/personality_test/init.lua</code>
est à tester en jeu.</li>
</ul>
<p class="note">Régénération : <code>.venv/bin/python OUTILS/generer_quiz_destiny.py</code>
(données : <code>quest_pmd_destiny/Data/quiz_personnalite_config.json</code>).</p>

<script>
const CFG = {js};
const NAT = {{}}; for (const n of CFG.natures) NAT[n.slug] = n;
const ST = {{}}; for (const s of CFG.starters) ST[s.id] = s;
let scores = {{}}, qi = 0, nature = null, starter = null, genre = null, talent = null;

const el = document.getElementById('contenu');
function montrer(html) {{ el.innerHTML = html; }}
function barre(p) {{ return '<div class="progress"><i style="width:' + p + '%"></i></div>'; }}

function demarrer() {{
  scores = {{}}; for (const n of CFG.natures) scores[n.slug] = 0; qi = 0;
  montrer('<div class="cartebadge"><img src="apercus/quiz_badges/badge_blanc.png" alt="badge blanc">' +
    '<div class="natnom">Test de personnalité</div>' +
    '<p>15 questions pour découvrir ta vraie nature d&#39;explorateur.</p>' +
    '<div class="boutons"><button class="primaire" onclick="question(0)">Commencer</button></div></div>');
}}

function question(i) {{
  if (i >= CFG.questions.length) {{ calculer(); return; }}
  qi = i;
  const q = CFG.questions[i];
  let b = '';
  q.Choix.forEach((c, k) => {{
    b += '<button onclick="repondre(' + i + ',' + k + ')">' + c.Texte + '</button>';
  }});
  montrer(barre((i / CFG.questions.length) * 100) +
    '<div class="qtexte">' + q.Texte + '</div><div class="choix">' + b + '</div>');
}}

function repondre(i, k) {{
  const pts = CFG.questions[i].Choix[k].Points;
  for (const n in pts) scores[n] += pts[n];
  question(i + 1);
}}

function calculer() {{
  let best = CFG.natures[0].slug;
  for (const n of CFG.natures) if (scores[n.slug] > scores[best]) best = n.slug;
  nature = NAT[best];
  starter = CFG.starters.find(s => s.nature === best);
  montrer(barre(100) + '<div class="cartebadge"><img src="' + nature.img + '" alt="badge">' +
    '<div class="natnom" style="color:' + nature.hex + '">Nature : ' + nature.fr +
    ' <small>(' + nature.en + ')</small></div>' +
    '<p>Le badge étoile s&#39;illumine en <b>' + nature.couleur + '</b> <code>' + nature.hex + '</code>.</p>' +
    '<div class="boutons"><button class="primaire" onclick="reveleStarter()">Voir mon starter</button></div></div>');
}}

function reveleStarter() {{
  const types = starter.types.map(t => '<span class="type">' + t + '</span>').join('');
  montrer('<div class="cartebadge"><img src="' + nature.img + '" alt="badge">' +
    '<div class="natnom">Starter : ' + starter.nom + ' <small>(gen ' + starter.gen + ')</small></div>' +
    '<div>' + types + '</div>' +
    (starter.mega ? '<p>✨ Éligible à la <b>' + CFG.megaTexte + '</b> (' + starter.megaNom + ')</p>' : '') +
    '<div class="boutons"><button class="primaire" onclick="choixGenre()">Continuer</button></div></div>');
}}

function choixGenre() {{
  montrer('<div class="boite"><div class="dlg">Quel est ton sexe ?</div>' +
    '<div class="radio">' +
    '<button onclick="suiteGenre(\\'male\\')">Garçon</button>' +
    '<button onclick="suiteGenre(\\'femelle\\')">Fille</button>' +
    '<button onclick="suiteGenre(\\'neutre\\')">Non-binaire</button></div></div>');
}}

function suiteGenre(g) {{ genre = g; choixTalent(); }}

function choixTalent() {{
  const t = starter.talents;
  if (t.length === 1) {{ talent = t[0]; confirmation(); return; }}
  let b = '';
  t.forEach((x, k) => {{ b += '<button onclick="suiteTalent(' + k + ')">' + x + '</button>'; }});
  montrer('<div class="boite"><div class="dlg">Quel talent veux-tu ?</div>' +
    '<div class="radio">' + b + '</div></div>');
}}

function suiteTalent(k) {{ talent = starter.talents[k]; confirmation(); }}

function arcEnCiel(txt) {{
  let out = '', i = 0;
  for (const car of txt) {{
    if (car === ' ' || car === '-') out += car;
    else {{ out += '<span style="color:' + CFG.rainbow[i % CFG.rainbow.length] + '">' + car + '</span>'; i++; }}
  }}
  return out;
}}

function confirmation() {{
  const mega = starter.mega
    ? '<div class="megaligne">' + arcEnCiel(CFG.megaTexte) + '</div>' +
      '<p style="text-align:center">Ce Pokémon est compatible avec la méga-évolution !<br>' +
      '<small>(' + starter.megaNom + ')</small></p>' : '';
  montrer('<div class="boite"><div class="dlg">Êtes-vous sûr de sélectionner ce Pokémon ?<br>' +
    '<b>' + starter.nom + '</b> — ' + genre + ' — talent <b>' + talent + '</b></div>' + mega +
    '<div class="boutons"><button class="primaire" onclick="fini()">Oui !</button>' +
    '<button onclick="choixGenre()">Non</button></div></div>');
}}

function fini() {{
  montrer('<div class="resume"><img src="' + nature.img + '" alt="badge">' +
    '<div class="natnom" style="color:' + nature.hex + '">' + starter.nom + '</div>' +
    '<p>Nature <b>' + nature.fr + '</b> · sexe <b>' + genre + '</b> · talent <b>' + talent + '</b>' +
    (starter.mega ? ' · <b>' + starter.megaNom + '</b> ' + arcEnCiel('✦') : '') + '</p>' +
    '<div class="boutons"><button class="primaire" onclick="demarrer()">Rejouer</button></div></div>');
}}

demarrer();

// tableaux de données
let th = '<table><tr><th>#</th><th>Question</th><th>Choix</th><th>Points</th></tr>';
CFG.questions.forEach((q, i) => {{
  q.Choix.forEach((c, k) => {{
    th += '<tr>' + (k === 0 ? '<td rowspan="' + q.Choix.length + '">' + (i + 1) + '</td>' +
      '<td rowspan="' + q.Choix.length + '">' + q.Texte + '</td>' : '') +
      '<td>' + c.Texte + '</td><td>' + Object.entries(c.Points).map(([n, v]) => n + ' +' + v).join(', ') + '</td></tr>';
  }});
}});
th += '</table>';
document.getElementById('tableau').innerHTML = th;
let mh = '<table><tr><th>Nature</th><th>Badge</th><th>Starter</th><th>Gen</th><th>Méga</th></tr>';
for (const n of CFG.natures) {{
  const s = CFG.starters.find(x => x.nature === n.slug);
  mh += '<tr><td><span class="pastille" style="background:' + n.hex + '"></span>' + n.fr + '</td>' +
    '<td>' + n.couleur + '</td><td>' + s.nom + '</td><td>' + s.gen + '</td>' +
    '<td>' + (s.mega ? '✅ ' + s.megaNom : '—') + '</td></tr>';
}}
mh += '</table>';
document.getElementById('mapping').innerHTML = mh;
// musique du personality quiz de Halcyon (« Welcome to the World of Pokémon! »)
const bgm = document.getElementById('bgm');
document.getElementById('musique').onclick = e => {{
  if (bgm.paused) {{ bgm.play(); e.target.textContent = '♪ Musique : ON'; }}
  else {{ bgm.pause(); e.target.textContent = '♪ Musique : OFF'; }}
}};
</script>
</body></html>
"""
    PAGE.write_text(html, encoding='utf-8')
    print(f'  page → {PAGE}')


def main() -> int:
    cfg, nats = charger()
    print(f'Sources : {CONFIG.name} ({len(cfg["Questions"])} questions, '
          f'{len(cfg["Starters"])} starters) + {NATURES.name}')
    ecrire_lua(cfg, nats)
    ecrire_page(cfg, nats)
    print('Terminé.')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
