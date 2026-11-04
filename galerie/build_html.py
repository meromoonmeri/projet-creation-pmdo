#!/usr/bin/env python3
"""Construit galerie/index.html à partir de galerie/data.json (produit par collect.py)."""
import html, json, pathlib

R = pathlib.Path(__file__).resolve().parents[1]
D = json.load(open(R / 'galerie' / 'data.json'))
E = html.escape

SISTER_BRANCHES = [
    ('arena/01a0de11', 'EFF1, EFF2, EDP1, ECF1, ECC1, ECC2, ESJ1, ESR1, EWL1, TMA1-3, ZGE1, ZGA1'),
    ('arena/01a0dfad', 'EJT1 (Entrée Jungle Treasure)'),
    ('arena/01a0e001', 'EFF1 (autre lot Foggy Forest, préfixe en doublon)'),
    ('arena/01a0e017', 'cartes glace et cristal (autre historique)'),
    ('arena/01a0e2db', 'ESP1, ESP2'),
    ('arena/01a0db11', 'EGC1 (Grotte des Cascades)'),
    ('arena/01a0dc8e', 'EAN1 (Amp), EHN1 (Horn), EWN1 (Waterfall gemmes)'),
    ('arena/01a0dc9b', 'ECN1 native, ECN2 (Cascade V2 référencée)'),
    ('arena/01a0ea8f', 'FUL1, ATF1 (fins)'),
    ('arena/01a0eaca', 'FUL1, FMF1, FMF2, BZF1 + repères FCV1, FJS3, FMT1, FQS1, FSC1, FTC1'),
]

def card_html(c, sid):
    imgs = c['images']
    badges = ''.join(f'<span class="badge{" ok" if "validée" in b else ""}">{E(b)}</span>' for b in c.get('badges', []))
    if imgs:
        main = imgs[0]
        thumbs = ''
        if len(imgs) > 1:
            thumbs = '<div class="thumbs">' + ''.join(
                f'<button class="thumb{" on" if k == 0 else ""}" data-src="img/{E(i["file"])}" '
                f'data-cap="{E(i["caption"])}" data-anim="{1 if i["animated"] else 0}" title="{E(i["caption"])}">'
                f'<img loading="lazy" src="img/{E(i["file"])}" alt=""></button>'
                for k, i in enumerate(imgs)) + '</div>'
        anim_tag = '<span class="anim">▶ animée</span>' if main['animated'] else ''
        media = (f'<div class="media"><img class="main" loading="lazy" src="img/{E(main["file"])}" '
                 f'alt="{E(c["title"])}" data-cap="{E(main["caption"])}">{anim_tag}</div>{thumbs}')
    else:
        media = ('<div class="media noimg"><span>Pas d\'aperçu image — données natives '
                 '(.rsground / .tile) et méthode uniquement</span></div>')
    meta = c.get('meta', {})
    lines = []
    if meta.get('method'):
        m = meta['method']
        lines.append(f'<div class="method">{E(m[:150] + ("…" if len(m) > 150 else ""))}</div>')
    if meta.get('reference_da'):
        lines.append(f'<div class="ref">Référence : <code>{E(str(meta["reference_da"]))}</code></div>')
    links = []
    if c.get('github'):
        links.append(f'<a href="{E(c["github"])}" target="_blank" rel="noopener">lot complet ↗</a>')
    if c.get('source'):
        links.append(f'<a href="../{E(c["source"])}" target="_blank" rel="noopener">méthode</a>')
    search = (c['title'] + ' ' + c['lot']).lower()
    return (f'<article class="card" data-search="{E(search)}">'
            f'{media}<div class="body"><h3>{E(c["title"])}</h3>'
            f'<div class="badges">{badges}</div>{"".join(lines)}'
            f'<div class="links">{" · ".join(links)}</div>'
            f'<div class="lot">{E(c["lot"])}</div></div></article>')

sections_html, nav = [], []
for s in D['sections']:
    n = len(s['cards'])
    nv = sum(len(c['images']) for c in s['cards'])
    nav.append(f'<a href="#{s["id"]}">{E(s["title"].split(" — ")[0])} <small>{n}</small></a>')
    cards = ''.join(card_html(c, s['id']) for c in s['cards'])
    sections_html.append(
        f'<section id="{s["id"]}"><h2>{E(s["title"])} <small>{n} lots · {nv} vues</small></h2>'
        f'<p class="desc">{E(s["desc"])}</p><div class="grid">{cards}</div></section>')

sister_rows = ''.join(f'<tr><td><code>{E(b)}</code></td><td>{E(l)}</td></tr>' for b, l in SISTER_BRANCHES)
st = D['stats']

page = f'''<!doctype html>
<html lang="fr"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Toutes les maps — Guilde Treehouse PMD</title>
<style>
:root {{ --bg:#17140f; --panel:#221d15; --line:#3a3226; --txt:#efe7d6; --dim:#a99f8c; --gold:#ffd76a; --ok:#7fb069; }}
* {{ box-sizing:border-box; }}
body {{ margin:0; background:var(--bg); color:var(--txt); font:15px/1.5 system-ui,'Segoe UI',sans-serif; }}
header {{ padding:28px 22px 14px; max-width:1500px; margin:0 auto; }}
h1 {{ margin:0 0 6px; font-size:26px; color:var(--gold); }}
.sub {{ color:var(--dim); max-width:900px; }}
.stats {{ display:flex; flex-wrap:wrap; gap:10px; margin:14px 0 4px; }}
.stat {{ background:var(--panel); border:1px solid var(--line); border-radius:10px; padding:8px 14px; }}
.stat b {{ color:var(--gold); font-size:19px; display:block; }}
.stat span {{ color:var(--dim); font-size:12px; }}
.toolbar {{ position:sticky; top:0; z-index:20; background:rgba(23,20,15,.96); backdrop-filter:blur(6px);
  border-bottom:1px solid var(--line); padding:10px 22px; }}
.toolbar .in {{ max-width:1500px; margin:0 auto; display:flex; gap:12px; align-items:center; flex-wrap:wrap; }}
nav {{ display:flex; flex-wrap:wrap; gap:6px; }}
nav a {{ color:var(--txt); text-decoration:none; background:var(--panel); border:1px solid var(--line);
  border-radius:999px; padding:3px 11px; font-size:12.5px; white-space:nowrap; }}
nav a:hover {{ border-color:var(--gold); color:var(--gold); }}
nav small {{ color:var(--dim); }}
#q {{ margin-left:auto; background:var(--panel); border:1px solid var(--line); color:var(--txt);
  border-radius:8px; padding:7px 12px; min-width:220px; font-size:14px; }}
main {{ max-width:1500px; margin:0 auto; padding:10px 22px 60px; }}
section {{ margin-top:34px; }}
h2 {{ color:var(--gold); font-size:20px; border-bottom:1px solid var(--line); padding-bottom:6px; }}
h2 small {{ color:var(--dim); font-weight:normal; font-size:13px; margin-left:8px; }}
.desc {{ color:var(--dim); margin:6px 0 14px; max-width:950px; }}
.grid {{ display:grid; grid-template-columns:repeat(auto-fill,minmax(300px,1fr)); gap:16px; }}
.card {{ background:var(--panel); border:1px solid var(--line); border-radius:12px; overflow:hidden;
  display:flex; flex-direction:column; }}
.card.hide {{ display:none; }}
.media {{ position:relative; height:250px; display:flex; align-items:center; justify-content:center;
  background:repeating-conic-gradient(#1c1812 0% 25%, #242019 0% 50%) 0 0/16px 16px; cursor:zoom-in; }}
.media img.main {{ max-width:100%; max-height:100%; object-fit:contain; }}
.media.noimg {{ cursor:default; color:var(--dim); font-size:13px; text-align:center; padding:16px;
  background:var(--panel); }}
.anim {{ position:absolute; top:8px; right:8px; background:rgba(0,0,0,.65); color:var(--gold);
  font-size:11px; border-radius:6px; padding:2px 8px; }}
.thumbs {{ display:flex; gap:4px; padding:6px; overflow-x:auto; background:#1b1710; }}
.thumb {{ flex:0 0 56px; height:44px; border:2px solid transparent; border-radius:6px; overflow:hidden;
  padding:0; background:#000; cursor:pointer; }}
.thumb img {{ width:100%; height:100%; object-fit:cover; }}
.thumb.on {{ border-color:var(--gold); }}
.body {{ padding:12px 14px 10px; display:flex; flex-direction:column; gap:7px; flex:1; }}
h3 {{ margin:0; font-size:15px; line-height:1.35; }}
.badges {{ display:flex; flex-wrap:wrap; gap:5px; }}
.badge {{ font-size:11px; background:#2c2519; border:1px solid var(--line); color:var(--dim);
  border-radius:999px; padding:1px 9px; }}
.badge.ok {{ color:#cdeab8; border-color:#4a6b3a; background:#26361d; }}
.method {{ font-size:12.5px; color:var(--dim); }}
.ref {{ font-size:12px; color:var(--dim); }}
.ref code {{ color:#d8b06a; }}
.links {{ font-size:12.5px; margin-top:auto; }}
.links a {{ color:var(--gold); text-decoration:none; }}
.links a:hover {{ text-decoration:underline; }}
.lot {{ font-size:11px; color:#6f6656; font-family:ui-monospace,monospace; }}
.note {{ background:#26200f; border:1px solid #57492a; border-radius:10px; padding:12px 16px;
  color:#e8d9ae; font-size:13.5px; margin:18px 0; }}
table {{ border-collapse:collapse; width:100%; font-size:13px; }}
td,th {{ border:1px solid var(--line); padding:6px 10px; text-align:left; }}
th {{ background:var(--panel); color:var(--gold); }}
footer {{ color:var(--dim); font-size:12.5px; border-top:1px solid var(--line); margin-top:44px; padding-top:16px; }}
#lightbox {{ position:fixed; inset:0; background:rgba(10,8,5,.93); display:none; z-index:50;
  align-items:center; justify-content:center; flex-direction:column; gap:10px; cursor:zoom-out; }}
#lightbox.open {{ display:flex; }}
#lightbox img {{ max-width:94vw; max-height:86vh; object-fit:contain; }}
#lightbox .cap {{ color:var(--txt); font-size:14px; }}
#count {{ color:var(--dim); font-size:12px; white-space:nowrap; }}
</style></head><body>
<header>
<h1>🗺️ Toutes les maps — Guilde Treehouse PMD</h1>
<p class="sub">Aperçu exhaustif des maps réalisées sur le projet, regroupées par famille.
Les vignettes proviennent du dépôt source <code>meromoonmeri/projet-pmdo</code> (commit <code>6cca4a0</code>,
29 septembre 2026) ; les méthodes, générateurs et tests de chaque lot sont dans ce dépôt
(<code>source/</code> et <code>renders/</code>). Cliquez sur une image pour l'agrandir ; les pastilles
« ▶ animée » sont les vraies boucles de scène.</p>
<div class="stats">
<div class="stat"><b>{st['lots']}</b><span>lots de production</span></div>
<div class="stat"><b>{st['views']}</b><span>vues de cartes</span></div>
<div class="stat"><b>{st['animated']}</b><span>scènes animées</span></div>
<div class="stat"><b>{st['validated']}</b><span>cartes du mod validé</span></div>
<div class="stat"><b>{len(D['sections'])}</b><span>familles</span></div>
</div>
<div class="note">⚖️ <b>Honnêteté sur l'état</b> : la série des entrées sud → nord a été validée par vos soins
sur les aperçus (« BEAU TRAVAIL JE VALIDE… », 27 septembre) et réunie dans le mod
<code>guilde_entrees_sud_nord</code> (19 cartes, PMDO 0.8.12). Pour le reste : <code>art_approved: false</code>,
aucun test en jeu PMDO (<code>runtime_tested: false</code>) — les tests listés sont des tests Python de build.
Les biome/références choisis par l'agent restent « à confirmer ».</div>
</header>
<div class="toolbar"><div class="in">
<nav>{''.join(nav)}</nav>
<input id="q" type="search" placeholder="Rechercher une map… (ex. givre, spinda, world)">
<span id="count"></span>
</div></div>
<main>
{''.join(sections_html)}
<section id="branches"><h2>Branches sœurs non intégrées <small>hors galerie</small></h2>
<p class="desc">Conformément à votre consigne (« reprendre seulement de la branche parente »), ces lots produits
en parallèle sur d'autres sessions ne sont pas fusionnés et n'apparaissent pas ci-dessus. Ils existent dans le
dépôt source, sur leurs branches respectives :</p>
<table><tr><th>Branche</th><th>Préfixes / lots</th></tr>{sister_rows}</table></section>
<footer>
Galerie générée le 4 novembre 2026 depuis <code>projet-pmdo@6cca4a0</code> ·
régénérable : <code>python3 galerie/collect.py && python3 galerie/build_html.py</code> ·
les images restent dans le dépôt source (elles sont ignorées par git ici) ·
méthode : <a href="../GUIDE_CREATION_DE_MAP.md" style="color:var(--gold)">GUIDE_CREATION_DE_MAP.md</a> ·
reprises : <a href="../REPRISE_MAPS.md" style="color:var(--gold)">REPRISE_MAPS.md</a>
</footer>
</main>
<div id="lightbox"><img alt=""><div class="cap"></div></div>
<script>
const lb = document.getElementById('lightbox'), lbImg = lb.querySelector('img'), lbCap = lb.querySelector('.cap');
document.querySelectorAll('.media:not(.noimg)').forEach(m => {{
  m.addEventListener('click', e => {{
    if (e.target.closest('.thumb')) return;
    const img = m.querySelector('img.main');
    lbImg.src = img.src; lbCap.textContent = img.dataset.cap || '';
    lb.classList.add('open');
  }});
}});
lb.addEventListener('click', () => lb.classList.remove('open'));
document.addEventListener('keydown', e => {{ if (e.key === 'Escape') lb.classList.remove('open'); }});
document.querySelectorAll('.card').forEach(card => {{
  const main = card.querySelector('img.main'), media = card.querySelector('.media');
  card.querySelectorAll('.thumb').forEach(t => {{
    t.addEventListener('click', e => {{
      e.stopPropagation();
      if (!main) return;
      main.src = t.dataset.src; main.dataset.cap = t.dataset.cap;
      card.querySelectorAll('.thumb').forEach(x => x.classList.remove('on'));
      t.classList.add('on');
      const tag = media.querySelector('.anim');
      if (tag) tag.style.display = t.dataset.anim === '1' ? '' : 'none';
    }});
  }});
}});
const q = document.getElementById('q'), count = document.getElementById('count');
const cards = [...document.querySelectorAll('.card')];
function filter() {{
  const v = q.value.trim().toLowerCase();
  let n = 0;
  cards.forEach(c => {{
    const hit = !v || c.dataset.search.includes(v);
    c.classList.toggle('hide', !hit); if (hit) n++;
  }});
  document.querySelectorAll('main section').forEach(s => {{
    if (s.id === 'branches') {{ s.style.display = v ? 'none' : ''; return; }}
    const vis = s.querySelectorAll('.card:not(.hide)').length;
    s.style.display = vis ? '' : 'none';
  }});
  count.textContent = v ? n + ' résultat' + (n > 1 ? 's' : '') : '';
}}
q.addEventListener('input', filter);
</script>
</body></html>'''

(R / 'galerie' / 'index.html').write_text(page)
print(f'galerie/index.html écrit ({len(page)//1024} Ko)')
