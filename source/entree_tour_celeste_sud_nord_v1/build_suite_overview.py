"""Construit le pack unifié des 4 cartes multicalques (EST1, MST1, SST1, FGM1) et la page racine index.html."""
from __future__ import annotations

import base64
import json
import re
import sys
import uuid
import zipfile
from pathlib import Path

from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
if str(HERE) not in sys.path:
    sys.path.insert(0, str(HERE))

from sky_tower_common import TOOLS  # noqa: E402

SCENES_SPEC = [
    {
        'code': 'EST1',
        'lot': 'entree_tour_celeste_sud_nord_v1',
        'ns': 'entree_tour_celeste',
        'title': 'EST1 · Entrée de la Tour Céleste (sud → nord)',
        'ref_path': 'source/entree_tour_celeste_sud_nord_v1/references/D13P01.png',
        'ref_code': 'D13P01 (408×288)',
        'status_badge': 'Généré référencé D13P01 + D13P01.bpl',
        'ora': 'EST1_entree_tour_celeste_calques.ora',
        'page': 'apercu_entree_tour_celeste_sud_nord_v1.html',
        'goal_key': 'threshold_px',
        'goal_label': 'donjon_seuil',
        'surface': 'rgb(18,46,112)',
    },
    {
        'code': 'MST1',
        'lot': 'relais_tour_celeste_sud_nord_v1',
        'ns': 'relais_tour_celeste',
        'title': 'MST1 · Relais Mi-Tour de la Tour Céleste (sud → nord)',
        'ref_path': 'source/relais_tour_celeste_sud_nord_v1/references/D13P02.png',
        'ref_code': 'D13P02 / b35 (456×456)',
        'status_badge': 'Sol 100 % natif 0,00 + Décor référencé D13P02',
        'ora': 'MST1_relais_tour_celeste_calques.ora',
        'page': 'apercu_relais_tour_celeste_sud_nord_v1.html',
        'goal_key': 'threshold_px',
        'goal_label': 'donjon_seuil',
        'surface': 'rgb(22,52,128)',
    },
    {
        'code': 'SST1',
        'lot': 'sommet_tour_celeste_rayquaza_v1',
        'ns': 'sommet_tour_celeste',
        'title': 'SST1 · Sommet de la Tour Céleste — Arène de Rayquaza',
        'ref_path': 'source/sommet_tour_celeste_rayquaza_v1/references/b71_sky_tower_summit.png',
        'ref_code': 'b71 / D13P03 (552×576)',
        'status_badge': 'Généré référencé b71 (fidélité brute max 6,05)',
        'ora': 'SST1_sommet_tour_celeste_calques.ora',
        'page': 'apercu_sommet_tour_celeste_rayquaza_v1.html',
        'goal_key': 'boss_px',
        'goal_label': 'boss_sommet',
        'surface': 'rgb(12,26,118)',
    },
    {
        'code': 'FGM1',
        'lot': 'arene_grotte_meteore_deoxys_native_v1',
        'ns': 'arene_grotte_meteore_deoxys',
        'title': 'FGM1 · Grotte Météore — Arène de Deoxys (576×576)',
        'ref_path': 'source/arene_grotte_meteore_deoxys_native_v1/references/b74_meteor_cave_deoxys.png',
        'ref_code': 'b74 (576×576)',
        'status_badge': '100 % Natif bit-exact (distance RVB 0,00)',
        'ora': 'FGM1_arene_grotte_meteore_calques.ora',
        'page': 'apercu_arene_grotte_meteore_deoxys_native_v1.html',
        'goal_key': 'boss_px',
        'goal_label': 'coeur_deoxys',
        'surface': 'rgb(0,0,72)',
    },
]


def data_uri(p: Path, mime: str = 'image/png') -> str:
    return f'data:{mime};base64,' + base64.b64encode(p.read_bytes()).decode()


def build_combined_pack_zip() -> Path:
    vzip = R / '.cache/virtual_zips/PACK_TOUR_CELESTE_ET_METEORE_PMDO_0812.zip'
    vzip.parent.mkdir(parents=True, exist_ok=True)
    merged_nodes = {}

    with zipfile.ZipFile(vzip, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for sp in SCENES_SPEC:
            stage = R / '.cache' / sp['lot'] / sp['ns']
            out = R / 'renders' / sp['lot']
            for fp in sorted(stage.rglob('*')):
                if not fp.is_file():
                    continue
                rel = fp.relative_to(stage).as_posix()
                if rel in ('Content/Tile/index.idx', 'Mod.xml', 'INSTALLER.py', 'README.md'):
                    continue
                z.write(fp, f'suite_tour_celeste_meteore/{rel}')
                if fp.suffix == '.tile':
                    with fp.open('rb') as f:
                        merged_nodes[fp.stem] = TOOLS.read_node(f)
            z.write(out / sp['ora'], f'calques_ora/{sp["ora"]}')
            z.write(out / 'manifest.json', f'manifests/{sp["code"]}_manifest.json')

        z.writestr('suite_tour_celeste_meteore/Content/Tile/index.idx', TOOLS.encode_index(merged_nodes))
        ident = uuid.uuid5(uuid.NAMESPACE_OID, 'pmdo-quest-0812:suite_tour_celeste_meteore')
        z.writestr('suite_tour_celeste_meteore/Mod.xml', f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Suite Tour Celeste et Grotte Meteore (EST1, MST1, SST1, FGM1) - 0.8.12</Name>
  <Author></Author>
  <Description>4 cartes multicalques 10 calques (EST1 D13P01, MST1 D13P02, SST1 b71, FGM1 b74 natif) pour PMDO 0.8.12.</Description>
  <Namespace>suite_tour_celeste_meteore</Namespace>
  <UUID>{ident}</UUID>
  <Version>1.0.0.0</Version>
  <GameVersion>0.8.12.0</GameVersion>
  <ModType>Quest</ModType>
  <Relationships />
</Header>
''')
        z.write(R / '.cache/entree_tour_celeste_sud_nord_v1/entree_tour_celeste/INSTALLER.py',
                'suite_tour_celeste_meteore/INSTALLER.py')
    return vzip


def main() -> None:
    pack_zip = build_combined_pack_zip()
    scenes_js = []
    cards_html = []

    for idx_s, sp in enumerate(SCENES_SPEC):
        out = R / 'renders' / sp['lot']
        m = json.loads((out / 'manifest.json').read_text())
        code = sp['code']
        stack = []
        for lay in m['layers']:
            nm = re.sub(rf'^{code}_\d\d_', '', Path(lay['file']).stem.replace('_fNN', ''))
            frs = [out / lay['file']] if lay['phases'] == 1 else [out / lay['file'].replace('fNN', f'f{t:02d}') for t in range(lay['phases'])]
            stack.append({'id': nm, 'ticks': lay['ticks'], 'frames': [data_uri(p) for p in frs]})

        poses = []
        for p in sorted((out / 'poses').glob('*.png')):
            w, h = Image.open(p).size
            poses.append({'id': p.stem.replace(code + '_', ''), 'uri': data_uri(p), 'w': w, 'h': h})

        max_brut = max(
            v['distance'] if 'distance' in v else v['distance_rip']
            for v in m['fidelite_rip']['brut'].values()
        )
        fid_str = (
            '100 % Natif · dérive RVB = 0,00 (identique bit-à-bit à t=0)'
            if code == 'FGM1'
            else f'Fidélité mesurée / rip : max = {max_brut:.2f} / 35 · sol_complet = {m["fidelite_rip"]["sol_complet"]:.2f}'
        )
        webp_uri = data_uri(out / f'review/{code}_scene_animee.webp', 'image/webp')
        ref_uri = data_uri(R / sp['ref_path'])

        scenes_js.append({
            'code': code,
            'title': sp['title'],
            'size': m['size_px'],
            'loop': m['scene_loop_ticks'],
            'stack': stack,
            'poses': poses,
            'surface': sp['surface'],
            'reference': ref_uri,
            'ref_code': sp['ref_code'],
            'collisions': data_uri(out / f'review/{code}_collisions_marqueurs.png'),
            'entry': m['access']['entry_px'],
            'threshold': m['access'][sp['goal_key']],
            'goal_label': sp['goal_label'],
            'status_badge': sp['status_badge'],
            'fid_str': fid_str,
            'page': sp['page'],
            'zip_href': f'{code}_{sp["ns"]}_pmdo_0812.zip?dl=1',
        })

        cards_html.append(f'''
        <article class="card">
          <div class="card-head">
            <div>
              <span class="tag">{code}</span>
              <strong>{sp["title"]}</strong>
            </div>
            <span class="badge">{sp["status_badge"]}</span>
          </div>
          <div class="media-pair">
            <figure>
              <img src="{webp_uri}" alt="{sp['title']}" onclick="selectScene({idx_s});window.scrollTo({{top:0,behavior:'smooth'}})" title="Cliquer pour inspecter les 10 calques en direct">
              <figcaption>Scène 10 calques animée ({m['size_px'][0]}×{m['size_px'][1]} · 60 i/s · 0 % damier)</figcaption>
            </figure>
            <figure class="ref-fig">
              <img src="{ref_uri}" alt="Référence {sp['ref_code']}">
              <figcaption>Référence canonique {sp['ref_code']}</figcaption>
            </figure>
          </div>
          <p class="meta">{fid_str} · <code>10</code> banques <code>.tile</code> (<code>TexSize=1</code>) + <code>.ora</code></p>
          <div class="btnrow">
            <button onclick="selectScene({idx_s});window.scrollTo({{top:0,behavior:'smooth'}})">Inspecter les 10 calques ici</button>
            <a class="btn sec" href="{sp['page']}">Page plein écran ({code})</a>
            <a class="btn dl" href="{code}_{sp['ns']}_pmdo_0812.zip?dl=1">ZIP Mod PMDO 0.8.12</a>
          </div>
        </article>''')

    html_doc = f'''<!doctype html>
<html lang="fr">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Tour Céleste (D13) &amp; Grotte Météore (b74) · Studio Multicalque PMDO 0.8.12</title>
<style>
body{{background:#101622;color:#e7ecf4;font:14.5px/1.55 system-ui,sans-serif;margin:0;padding:20px 24px}}
main{{max-width:1320px;margin:auto}}
header{{display:flex;justify-content:space-between;align-items:flex-end;gap:16px;flex-wrap:wrap;padding-bottom:14px;border-bottom:1px solid #26384a;margin-bottom:18px}}
h1{{font-size:26px;margin:0 0 4px}}
h2{{font-size:20px;margin:28px 0 12px;padding-bottom:6px;border-bottom:1px solid #26384a}}
p{{color:#bcccd8;margin:4px 0}}
.tabs{{display:flex;gap:8px;flex-wrap:wrap;margin:0 0 14px}}
.wrap{{display:flex;gap:22px;flex-wrap:wrap;align-items:flex-start;background:#141d2b;border:1px solid #2a3e52;border-radius:10px;padding:16px}}
.stage{{position:relative;background:#090e16;overflow:auto;max-height:82vh;border:1px solid #2d4252;border-radius:6px}}
canvas{{display:block;image-rendering:pixelated}}
aside{{flex:1;min-width:300px;max-width:440px}}
fieldset{{border:1px solid #2d4252;border-radius:8px;margin:0 0 12px;padding:9px 13px}}
legend{{color:#7ee0ec;padding:0 6px;font-weight:600}}
.layrow{{display:flex;align-items:center;justify-content:space-between;gap:6px;padding:2px 0}}
.layrow label{{padding:1px 0;margin:0;flex:1;cursor:pointer}}
.mini{{padding:2px 7px;font-size:11.5px;background:#223446;color:#cfe4ee;margin:0}}
label{{display:block;padding:2px 0;cursor:pointer}}
button,.btn{{display:inline-block;background:#cfe4ee;color:#102b38;border:0;border-radius:6px;padding:7px 13px;margin:2px 4px 2px 0;cursor:pointer;font-weight:600;text-decoration:none;font-size:13.5px}}
button.on{{background:#7ee0ec}}
.btn.sec{{background:#233548;color:#d8ecf8;border:1px solid #35506b}}
.btn.dl{{background:#4fd1c5;color:#082424}}
.grid-cards{{display:grid;grid-template-columns:repeat(auto-fit,minmax(560px,1fr));gap:18px}}
.card{{background:#141d2b;border:1px solid #2a3e52;border-radius:10px;padding:14px 16px}}
.card-head{{display:flex;justify-content:space-between;align-items:center;gap:8px;flex-wrap:wrap;margin-bottom:10px}}
.tag{{display:inline-block;background:#7ee0ec;color:#0b2230;font-weight:800;border-radius:5px;padding:2px 8px;margin-right:6px;font-size:12.5px}}
.badge{{background:#1d2e42;color:#b8e6f2;border:1px solid #314b66;border-radius:5px;padding:2px 8px;font-size:12px}}
.media-pair{{display:grid;grid-template-columns:1.62fr 1fr;gap:10px;align-items:start}}
figure{{margin:0}}
figure img{{width:100%;image-rendering:pixelated;border-radius:5px;border:1px solid #2d4252;background:#090e16;cursor:pointer}}
figcaption{{font-size:12px;color:#9cb4c7;margin-top:4px}}
.meta{{font-size:13px;color:#c5dae8;margin:8px 0}}
.btnrow{{display:flex;flex-wrap:wrap;gap:6px;margin-top:8px}}
.note{{border-left:3px solid #7ee0ec;padding-left:10px;font-size:13px}}
.ref{{width:100%;max-height:210px;object-fit:contain;image-rendering:pixelated;border-radius:4px;border:1px solid #2d4252;background:#090e16}}
code{{color:#d3ebf7}}
</style>
<main>
<header>
  <div>
    <h1>Trilogie Tour Céleste (<code>D13P01</code> → <code>D13P02</code> → <code>b71</code>) &amp; Grotte Météore (<code>b74</code>) — Multicalque PMDO 0.8.12</h1>
    <p>4 scènes inédites (<code>40</code> calques RGBA, <code>40</code> banques <code>.tile</code> <code>TexSize=1</code>, archives <code>.ora</code>, fidélité vérifiée <code>&lt; 35</code> et <code>0,00</code> Natif, <code>0 %</code> damier).</p>
  </div>
  <div>
    <a class="btn dl" href="PACK_TOUR_CELESTE_ET_METEORE_PMDO_0812.zip?dl=1">Télécharger le Pack Complet des 4 Scènes (.ZIP)</a>
    <a class="btn sec" href="apercu_entree_traversee_cristal_sud_nord_v1.html">Biome D17 · ETX1</a>
    <a class="btn sec" href="apercu_fin_traversee_cristal_v1.html">Biome D17 · FTX1</a>
  </div>
</header>

<div class="tabs" id="sceneTabs"></div>

<div class="wrap">
  <div class="stage"><canvas id="c"></canvas></div>
  <aside>
    <fieldset><legend id="scTitle">Scène active</legend>
      <button id="play">Pause</button><button id="step">+2 ticks</button><button id="png">Export PNG 1×</button>
      <a id="openFull" class="btn sec" href="#">Plein écran</a>
      <div id="phase" style="margin-top:4px;font-size:13px;color:#9fc0d4"></div>
    </fieldset>
    <fieldset><legend>Affichage</legend>
      <button data-zoom="1" class="on">1×</button><button data-zoom="2">2×</button>
      <label><input type="checkbox" id="grid"> Grille 8 px</label>
      <label><input type="checkbox" id="coll"> Collisions 16×16 et marqueurs</label>
      <label><input type="checkbox" id="view"> Viewport PMDO ×1 (320×240) à l'arrivée</label>
    </fieldset>
    <fieldset><legend>Calques multicalques (bas → haut)</legend><div id="layers"></div><div style="margin-top:6px"><button id="solo">Tout afficher</button></div></fieldset>
    <fieldset><legend>Poses / Modules détourés (×4)</legend><div id="poses" style="display:flex;flex-wrap:wrap;gap:6px"></div></fieldset>
    <fieldset><legend id="refLegend">Référence canonique</legend><img id="ref" class="ref" alt="Référence"><p id="fidBox" class="note" style="margin-top:8px"></p></fieldset>
  </aside>
</div>

<h2>Vue d’ensemble des 4 scènes multicalques &amp; comparaison directe aux captures canoniques</h2>
<div class="grid-cards">
  {''.join(cards_html)}
</div>
</main>
<script>
const SCENES={json.dumps(scenes_js)};
const c=document.getElementById('c'),x=c.getContext('2d');
function mkImg(u){{const i=new Image();i.src=u;return i}}
const LOADED=SCENES.map(s=>({{
  ...s,
  layers:s.stack.map(l=>({{id:l.id,ticks:l.ticks,frames:l.frames.map(mkImg)}})),
  collImg:mkImg(s.collisions)
}}));
let cur=0,zoom=1,tick=0,playing=true,last=performance.now(),checks={{}};
const STEP=2,MS=STEP*1000/60;

const tabsEl=document.getElementById('sceneTabs');
SCENES.forEach((s,idx)=>{{
  const b=document.createElement('button');
  b.textContent=s.code+' · '+s.title.split('·')[1].trim();
  b.onclick=()=>selectScene(idx);
  tabsEl.append(b);
}});

function selectScene(idx){{
  cur=idx;tick=0;
  [...tabsEl.children].forEach((b,i)=>b.classList.toggle('on',i===idx));
  const S=LOADED[cur];
  document.getElementById('scTitle').textContent=S.title;
  document.getElementById('openFull').href=S.page;
  document.getElementById('refLegend').textContent='Référence canonique '+S.ref_code;
  document.getElementById('ref').src=S.reference;
  document.getElementById('fidBox').textContent=S.status_badge+' — '+S.fid_str+' · art_approved=false, runtime_tested=false.';
  const box=document.getElementById('layers');box.innerHTML='';checks={{}};
  S.layers.forEach((l,i)=>{{
    const row=document.createElement('div');row.className='layrow';
    const lab=document.createElement('label'),ch=document.createElement('input');
    ch.type='checkbox';ch.checked=true;ch.onchange=draw;checks[l.id]=ch;
    lab.append(ch,' '+String(i).padStart(2,'0')+' · '+l.id+(l.frames.length>1?' ('+l.frames.length+'×'+l.ticks+'t)':''));
    const sb=document.createElement('button');sb.className='mini';sb.textContent='Solo';
    sb.onclick=()=>{{Object.values(checks).forEach(o=>o.checked=false);ch.checked=true;draw()}};
    row.append(lab,sb);box.append(row);
  }});
  const pbox=document.getElementById('poses');pbox.innerHTML='';
  S.poses.forEach(p=>{{const i=mkImg(p.uri);i.width=p.w*4;i.height=p.h*4;i.title=p.id;i.style.cssText='image-rendering:pixelated;background:'+S.surface;pbox.append(i)}});
  draw();
}}

function render(ctx){{
  const S=LOADED[cur],[W,H]=S.size;
  ctx.clearRect(0,0,W,H);
  S.layers.forEach(l=>{{if(checks[l.id]&&checks[l.id].checked)ctx.drawImage(l.frames[Math.floor(tick/l.ticks)%l.frames.length],0,0)}});
  if(document.getElementById('coll').checked)ctx.drawImage(S.collImg,0,0);
}}

function draw(){{
  const S=LOADED[cur],[W,H]=S.size;
  c.width=W*zoom;c.height=H*zoom;x.imageSmoothingEnabled=false;x.save();x.scale(zoom,zoom);render(x);x.restore();
  if(document.getElementById('grid').checked){{x.strokeStyle='rgba(255,255,255,.18)';x.lineWidth=1;x.beginPath();
    for(let i=0;i<=W;i+=8){{x.moveTo(i*zoom+.5,0);x.lineTo(i*zoom+.5,H*zoom)}}for(let j=0;j<=H;j+=8){{x.moveTo(0,j*zoom+.5);x.lineTo(W*zoom,j*zoom+.5)}}x.stroke()}}
  if(document.getElementById('view').checked){{const cx=Math.min(Math.max(S.entry[0]+8-160,0),W-320),cy=Math.min(Math.max(S.entry[1]+8-120,0),H-240);
    x.strokeStyle='#ffe066';x.lineWidth=2;x.strokeRect(cx*zoom,cy*zoom,320*zoom,240*zoom)}}
  document.getElementById('phase').textContent=S.code+' · '+W+'×'+H+' · tick '+tick+' / '+S.loop+' (jaune = entrance, cyan = '+S.goal_label+')';
}}

function adv(){{tick=(tick+STEP)%LOADED[cur].loop;draw()}}
function loop(t){{if(playing&&t-last>=MS){{last=t;adv()}}requestAnimationFrame(loop)}}
document.getElementById('play').onclick=e=>{{playing=!playing;e.target.textContent=playing?'Pause':'Lecture'}};
document.getElementById('step').onclick=adv;
document.querySelectorAll('[data-zoom]').forEach(b=>b.onclick=()=>{{zoom=+b.dataset.zoom;document.querySelectorAll('[data-zoom]').forEach(o=>o.classList.toggle('on',o===b));draw()}});
['grid','coll','view'].forEach(id=>document.getElementById(id).onchange=draw);
document.getElementById('solo').onclick=()=>{{Object.values(checks).forEach(ch=>ch.checked=true);draw()}};
document.getElementById('png').onclick=()=>{{const S=LOADED[cur],[W,H]=S.size,o=document.createElement('canvas');o.width=W;o.height=H;render(o.getContext('2d'));const a=document.createElement('a');a.download=S.code+'_vue_tick'+String(tick).padStart(3,'0')+'.png';a.href=o.toDataURL('image/png');a.click()}};
Promise.all(LOADED.flatMap(s=>[...s.layers.flatMap(l=>l.frames),s.collImg]).map(i=>i.decode())).then(()=>{{selectScene(0);requestAnimationFrame(loop)}});
</script>
</html>
'''
    out_index = R / 'index.html'
    out_index.write_text(html_doc)
    print('Pack unifié :', pack_zip.relative_to(R), round(pack_zip.stat().st_size / 1e6, 2), 'Mo')
    print('Index studio :', out_index.relative_to(R), round(out_index.stat().st_size / 1e6, 2), 'Mo')


if __name__ == '__main__':
    main()
