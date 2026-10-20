"""Tests -> ZIP PNG sans fond + ZIP PMDO 0.8.12 -> Atelier complet 10 objets (KTR1 + KMC1).
.venv/bin/python source/mobilier_cafe_complet_v1/package.py   (après build.py)
"""
from __future__ import annotations

import base64, io, json, subprocess, sys, zipfile
from pathlib import Path
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/mobilier_cafe_complet_v1'
S = R / '.cache/mobilier_cafe_complet_v1/mobilier_cafe_complet'
TRIO_O = R / 'renders/kiosques_spinda_trio_v1'
TRIO_REF = R / 'source/kiosques_spinda_trio_v1/references'
HALCYON_CAFE = R / 'renders/cafe_halcyon_agrandi_v1/CafeHalcyon_terrain_transparent.png'
V7_ROOMS_DIR = R / 'renders/cafe_spinda_revisite_v7/salles'
PFX = 'KMC1'

ANIM_META = {
    'kirlia': {'sheet': HERE / 'references/kirlia_0281_idle_sheet.png', 'fw': 24, 'fh': 40, 'durs': [60, 4, 4, 4, 4, 4, 4, 6, 24]},
    'charmilly': {'sheet': HERE / 'references/charmilly_0869_idle_sheet.png', 'fw': 24, 'fh': 40, 'durs': [14, 30, 14, 30]},
    'estrade': {'sheet': HERE / 'references/rondoudou_0039_idle_sheet.png', 'fw': 24, 'fh': 32, 'durs': [25, 8, 15, 8, 15]},
    'spinda': {'sheet': TRIO_REF / 'spinda_0327_idle_sheet.png', 'fw': 32, 'fh': 48, 'durs': [4, 8, 14, 4, 5, 6, 8, 14, 6]},
    'qulbutoke': {'sheet': TRIO_REF / 'qulbutoke_0202_idle_sheet.png', 'fw': 24, 'fh': 40, 'durs': [40, 4, 4, 4, 4, 4, 4, 4, 4]},
    'sucreine': {'sheet': TRIO_REF / 'sucreine_0763_idle_sheet.png', 'fw': 32, 'fh': 56, 'durs': [30, 30]},
}


def zipdir(path: Path, items: list[tuple[Path, str]]) -> None:
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for src, arc in items:
            z.write(src, arc)


def uri_bytes(b: bytes) -> str:
    return 'data:image/png;base64,' + base64.b64encode(b).decode()


def uri(p: Path) -> str:
    return uri_bytes(Path(p).read_bytes())


def extract_frames(key: str) -> tuple[list[str], list[int]]:
    meta = ANIM_META.get(key)
    if not meta or not meta['sheet'].exists():
        return [], []
    im = Image.open(meta['sheet']).convert('RGBA')
    fw, fh, durs = meta['fw'], meta['fh'], meta['durs']
    out = []
    for c in range(len(durs)):
        buf = io.BytesIO()
        im.crop((c * fw, 0, (c + 1) * fw, fh)).save(buf, 'PNG')
        out.append(uri_bytes(buf.getvalue()))
    return out, durs


def main() -> None:
    subprocess.run([sys.executable, '-m', 'unittest', 'source.mobilier_cafe_complet_v1.test_build'], cwd=R, check=True)
    M = json.loads((O / 'manifest.json').read_text())
    M_trio = json.loads((TRIO_O / 'manifest.json').read_text())

    # 1. ZIP complet réunissant les 10 objets sans fond (7 nouveaux KMC1 + 3 KTR1 pour confort total)
    all_pngs = [(p, 'KMC1_nouveaux/' + p.relative_to(O).as_posix()) for p in sorted(O.rglob('*')) if p.is_file() and p.suffix != '.zip']
    all_pngs += [(p, 'KTR1_spinda_qulbutoke_sucreine/' + p.relative_to(TRIO_O).as_posix()) for p in sorted(TRIO_O.rglob('*')) if p.is_file() and p.suffix != '.zip']
    zipdir(O / f'{PFX}_collection_10_objets_cafe_sans_fond.zip', all_pngs)

    zipdir(
        O / f'{PFX}_mobilier_cafe_complet_pmdo_0812.zip',
        [(p, 'mobilier_cafe_complet/' + p.relative_to(S).as_posix()) for p in sorted(S.rglob('*')) if p.is_file()],
    )

    cards = []
    for o in M['objects']:
        stem = o['file_stem']
        has_split = o['normalization_1x']['split_mode'] is not None
        frames, durs = extract_frames(o['id'])
        cards.append({
            'id': o['id'],
            'stem': stem,
            'label': o['label'],
            'group': 'new',
            'pfx': o['bank_prefix'],
            'norm': o['normalization_1x'],
            'hd_size': o['hd_tight_size'],
            'hd': uri(O / o['hd_sans_fond']),
            'day_full': uri(O / f'assets_1x/{stem}_1x_complet.png'),
            'day_back': uri(O / f'assets_1x/{stem}_1x_arriere.png') if has_split else uri(O / f'assets_1x/{stem}_1x_complet.png'),
            'day_front': uri(O / f'assets_1x/{stem}_1x_avant.png') if has_split else None,
            'night_full': uri(O / f'assets_1x/{stem}_1x_nuit_complet.png'),
            'night_back': uri(O / f'assets_1x/{stem}_1x_nuit_arriere.png') if has_split else uri(O / f'assets_1x/{stem}_1x_nuit_complet.png'),
            'night_front': uri(O / f'assets_1x/{stem}_1x_nuit_avant.png') if has_split else None,
            'idle': frames,
            'durations': durs,
        })

    for o in M_trio['objects']:
        slug = o['id']
        Cap = slug.capitalize()
        frames, durs = extract_frames(slug)
        cards.append({
            'id': slug,
            'stem': f'{Cap}_Comptoir',
            'label': f'Comptoir {o["label"]}',
            'group': 'trio',
            'pfx': o['prefix'],
            'norm': o['normalization_1x'],
            'hd_size': o['normalization_1x']['hd_tight_size'],
            'hd': uri(TRIO_O / o['hd_sans_fond']),
            'day_full': uri(TRIO_O / f'assets_1x/{Cap}_Comptoir_1x_complet.png'),
            'day_back': uri(TRIO_O / f'assets_1x/{Cap}_Comptoir_1x_arriere.png'),
            'day_front': uri(TRIO_O / f'assets_1x/{Cap}_Comptoir_1x_avant.png'),
            'night_full': uri(TRIO_O / f'assets_1x/{Cap}_Comptoir_1x_nuit_complet.png'),
            'night_back': uri(TRIO_O / f'assets_1x/{Cap}_Comptoir_1x_nuit_arriere.png'),
            'night_front': uri(TRIO_O / f'assets_1x/{Cap}_Comptoir_1x_nuit_avant.png'),
            'idle': frames,
            'durations': durs,
        })

    rooms = []
    if HALCYON_CAFE.exists():
        with Image.open(HALCYON_CAFE) as im:
            rw, rh = im.size
        rooms.append({
            'id': 'halcyon_grand_cafe',
            'label': 'Grand Café Métano · Halcyon (840×576 — Salle complète 10 objets)',
            'w': rw,
            'h': rh,
            'uri': uri(HALCYON_CAFE),
            'defaults': {
                'estrade': [312, 32],
                'piano': [224, 128],
                'jukebox': [536, 120],
                'spinda': [80, 128],
                'sucreine': [608, 112],
                'kirlia': [80, 280],
                'charmilly': [608, 280],
                'qulbutoke': [80, 416],
                'table_cabaret': [344, 264],
                'banquette_velours': [432, 264],
            },
        })
    for rid, rlabel in [
        ('cafe', 'Café Spinda V7 (+1 · 600×448)'),
        ('salon_haut', 'Salon haut Cabaret Spinda V7 (+1 · 600×448)'),
        ('salon_bas', 'Salon des jeux Spinda V7 (−1 · 600×448)'),
    ]:
        rp = V7_ROOMS_DIR / f'SpindaV7_{rid}_sans_magenta.png'
        if rp.exists():
            with Image.open(rp) as im:
                rw, rh = im.size
            rooms.append({
                'id': rid,
                'label': rlabel,
                'w': rw,
                'h': rh,
                'uri': uri(rp),
                'defaults': {
                    'estrade': [192, 32],
                    'piano': [112, 128],
                    'jukebox': [416, 120],
                    'kirlia': [64, 240],
                    'charmilly': [392, 240],
                    'spinda': [64, 344],
                    'sucreine': [392, 344],
                    'qulbutoke': [224, 344],
                    'table_cabaret': [248, 248],
                    'banquette_velours': [304, 248],
                },
            })

    data = {
        'manifest': M,
        'sheet_day': uri(O / 'tilesheets/Tilesheet_Mobilier_Cafe_Jour_1x.png'),
        'sheet_acc': uri(O / 'tilesheets/Tilesheet_Accessoires_Cabaret_Jour_1x.png'),
        'cards': cards,
        'rooms': rooms,
    }
    out_html = R / 'apercu_mobilier_cafe_complet_v1.html'
    out_html.write_text(TEMPLATE.replace('__DATA__', json.dumps(data, ensure_ascii=False)))
    for p in [
        O / f'{PFX}_collection_10_objets_cafe_sans_fond.zip',
        O / f'{PFX}_mobilier_cafe_complet_pmdo_0812.zip',
        out_html,
    ]:
        print(p.relative_to(R), round(p.stat().st_size / 1e6, 2), 'Mo')


TEMPLATE = """<!doctype html>
<html lang="fr">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Collection Complète Café &amp; Cabaret · 10 Objets Sans Fond (Estrade Rideaux Rouges, Kirlia, Charmilly, Spinda, Qulbutoké, Sucreine, Piano, Jukebox…)</title>
<style>
body{background:#241c18;color:#f6ecda;font:15px/1.55 system-ui,sans-serif;margin:0;padding:24px}
main{max-width:1380px;margin:auto}
h1{font-size:29px;margin:0 0 6px}
h2{font-size:20px;margin:0 0 10px;color:#f6c86e}
p{color:#dfd1bd;max-width:96ch;margin:6px 0 14px}
.card{background:#382d26;border:1px solid #6f5a4a;border-radius:11px;padding:16px;margin-bottom:20px}
.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(310px,1fr));gap:15px}
.subcard{background:#2c231e;border:1px solid #5c493b;border-radius:9px;padding:12px}
canvas{display:block;image-rendering:pixelated;border-radius:7px;border:1px solid #5c493b;max-width:100%}
button,select,a.btn{background:#ecdfc8;color:#241b14;border:0;border-radius:6px;padding:6px 10px;margin:3px 4px 3px 0;cursor:pointer;font-weight:600;text-decoration:none;display:inline-block;font-size:12.8px}
button.on{background:#e0474c;color:#fff8f0}
.toolbar{display:flex;gap:9px;flex-wrap:wrap;align-items:center;margin-bottom:12px}
.badge{background:#7d1c27;color:#ffd9c8;padding:2px 7px;border-radius:5px;font-size:11.5px;font-weight:700}
.note{border-left:3px solid #e0474c;padding-left:12px;font-size:13.5px;color:#dacbb8}
code{color:#f8d488}
</style>
<main>
<h1>Collection Complète Café &amp; Cabaret — 10 Objets 100 % Sans Fond</h1>
<p>Tous les objets sont conçus sur la même grammaire pixel-art que <code>Metano_Town_Cafe_Objects</code> (<em>Halcyon</em>) et détourés <strong>100 % sans fond</strong> (<code>alpha = 0</code> extérieur et ajours internes, <code>0 px</code> de magenta ou de frange pourpre en HD comme en Ground <code>1×</code>) : <strong>Grande Estrade aux Rideaux de Velours Rouge</strong>, <strong>Comptoir Kirlia</strong>, <strong>Comptoir Charmilly</strong>, <strong>Piano droit</strong>, <strong>Jukebox / Phonographe</strong>, <strong>Table ronde Cabaret rouge</strong>, <strong>Banquette velours rouge</strong>, réunis avec <strong>Spinda</strong>, <strong>Qulbutoké</strong> et <strong>Sucreine</strong>.</p>

<section class="card">
  <div class="toolbar">
    <strong>1. Catalogue des 10 objets détourés sans fond :</strong>
    Fond :
    <button data-bg="#3a3028" class="on">Neutre chaud (#3a3028)</button>
    <button data-bg="checker">Damier alpha (preuve sans fond)</button>
    <button data-bg="#141820">Nuit sombre</button>
    <button data-bg="#ede5d4">Crème clair</button>
    <span style="margin-left:8px">Échelle :</span>
    <button data-mode="hd" class="on">Master HD sans fond</button>
    <button data-mode="1x">Ground 1× (zoom 2×)</button>
    <label style="cursor:pointer;margin-left:6px"><input type="checkbox" id="galNight"> Mode Nuit V8</label>
    <a class="btn" id="dlSheetMain" download="Tilesheet_Mobilier_Cafe_Jour_1x.png">Tilesheet 1× Comptoirs &amp; Estrade</a>
    <a class="btn" id="dlSheetAcc" download="Tilesheet_Accessoires_Cabaret_Jour_1x.png">Tilesheet 1× Accessoires Cabaret</a>
  </div>
  <div class="grid" id="cardsWrap"></div>
</section>

<section class="card">
  <h2>2. Scène Cabaret &amp; Café Interactive — Les 10 objets en situation (840×576 Halcyon &amp; Salles Spinda V7)</h2>
  <div class="toolbar">
    <label>Salle : <select id="roomSel"></select></label>
    <label>Déplacer au clic : <select id="activeObj"></select></label>
    <label style="cursor:pointer"><input type="checkbox" id="toggleActive" checked> Afficher cet objet dans la salle</label>
    <label style="cursor:pointer"><input type="checkbox" id="sceneNight"> Ambiance Nuit V8</label>
    <label style="cursor:pointer"><input type="checkbox" id="showNpcs" checked> Démo Pokémon animés (Rondoudou sur l'estrade + 5 barmans)</label>
    <label style="cursor:pointer"><input type="checkbox" id="showGrid"> Grille 8 px</label>
    <button id="resetPos">Disposition par défaut</button>
    <button id="exportScene">Exporter la salle en PNG</button>
  </div>
  <canvas id="sceneCanvas" style="cursor:crosshair"></canvas>
  <p class="note" style="margin-top:12px">Statut honnête : créations générées référencées sur <code>Metano_Town_Cafe_Objects</code> (pas des tuiles natives certifiées), <code>art_approved = false</code>, <code>runtime_tested = false</code>. Aucun PNG livré ne contient de personnage.</p>
</section>
</main>
<script>
const D=__DATA__;
function mk(u){if(!u)return null;const i=new Image();i.src=u;return i}
const CARDS=D.cards.map(c=>({...c,visible:true,im:{
  hd:mk(c.hd),day_full:mk(c.day_full),day_back:mk(c.day_back),day_front:mk(c.day_front),
  night_full:mk(c.night_full),night_back:mk(c.night_back),night_front:mk(c.night_front)
},idleIm:c.idle.map(mk)}));
const ROOMS=D.rooms.map(r=>({...r,im:mk(r.uri)}));
document.getElementById('dlSheetMain').href=D.sheet_day;
document.getElementById('dlSheetAcc').href=D.sheet_acc;

let bg='#3a3028',mode='hd',roomIdx=0,pos={},animTick=0;
function resetPositions(){pos=JSON.parse(JSON.stringify(ROOMS[roomIdx].defaults));CARDS.forEach(c=>c.visible=true);syncToggle()}
const objSel=document.getElementById('activeObj');
CARDS.forEach(c=>{const o=document.createElement('option');o.value=c.id;o.textContent=c.label;objSel.append(o)});
function syncToggle(){const c=CARDS.find(x=>x.id===objSel.value);if(c)document.getElementById('toggleActive').checked=c.visible}
objSel.onchange=syncToggle;
document.getElementById('toggleActive').onchange=e=>{const c=CARDS.find(x=>x.id===objSel.value);if(c){c.visible=e.target.checked;drawScene()}};

const wrap=document.getElementById('cardsWrap'),cardCv={};
CARDS.forEach(c=>{
  const el=document.createElement('div');el.className='subcard';
  el.innerHTML=`<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:6px">
    <strong style="font-size:15.5px;color:#f8d488">${c.label}</strong>
    <span class="badge">${c.group==='new'?'NOUVEAU · '+c.pfx:c.pfx}</span>
  </div>
  <div style="font-size:12px;color:#cbbba6;margin-bottom:6px">HD ${c.hd_size[0]}×${c.hd_size[1]} · Ground 1× ${c.norm.canvas_size[0]}×${c.norm.canvas_size[1]} px</div>
  <canvas width="300" height="250"></canvas>
  <div style="margin-top:8px">
    <a class="btn" href="${c.hd}" download="${c.stem}_HD_sans_fond.png">PNG HD sans fond</a>
    <a class="btn" href="${c.day_full}" download="${c.stem}_1x_complet.png">PNG 1× sans fond</a>
    ${c.day_front?`<a class="btn" href="${c.day_back}" download="${c.stem}_1x_arriere.png">1× Arrière</a><a class="btn" href="${c.day_front}" download="${c.stem}_1x_avant.png">1× Avant</a>`:''}
  </div>`;
  wrap.append(el);cardCv[c.id]=el.querySelector('canvas');
});

function paintBg(ctx,W,H){
  if(bg==='checker'){for(let y=0;y<H;y+=16)for(let x=0;x<W;x+=16){ctx.fillStyle=((x+y)/16)%2?'#544940':'#362f29';ctx.fillRect(x,y,16,16)}}
  else{ctx.fillStyle=bg;ctx.fillRect(0,0,W,H)}
}
function drawGallery(){
  const night=document.getElementById('galNight').checked;
  CARDS.forEach(c=>{
    const cv=cardCv[c.id],ctx=cv.getContext('2d'),W=cv.width,H=cv.height;
    ctx.imageSmoothingEnabled=false;paintBg(ctx,W,H);
    const im=mode==='hd'?c.im.hd:(night?c.im.night_full:c.im.day_full);
    const sc=mode==='hd'?Math.min((W-20)/im.width,(H-20)/im.height):Math.min(2.0,(W-16)/im.width,(H-16)/im.height);
    const dw=Math.round(im.width*sc),dh=Math.round(im.height*sc);
    ctx.drawImage(im,Math.round((W-dw)/2),Math.round((H-dh)/2),dw,dh);
  });
}
document.querySelectorAll('[data-bg]').forEach(b=>b.onclick=()=>{bg=b.dataset.bg;document.querySelectorAll('[data-bg]').forEach(x=>x.classList.toggle('on',x===b));drawGallery()});
document.querySelectorAll('[data-mode]').forEach(b=>b.onclick=()=>{mode=b.dataset.mode;document.querySelectorAll('[data-mode]').forEach(x=>x.classList.toggle('on',x===b));drawGallery()});
document.getElementById('galNight').onchange=drawGallery;

const rsel=document.getElementById('roomSel');
ROOMS.forEach((r,i)=>{const o=document.createElement('option');o.value=i;o.textContent=r.label;rsel.append(o)});
resetPositions();
const scv=document.getElementById('sceneCanvas'),sctx=scv.getContext('2d');

function frameAtTick(c,t){
  if(!c.durations.length)return null;
  const total=c.durations.reduce((a,b)=>a+b,0);let r=t%total;
  for(let i=0;i<c.durations.length;i++){if(r<c.durations[i])return c.idleIm[i];r-=c.durations[i]}
  return c.idleIm[0];
}
function composeScene(ctx,R0){
  const night=document.getElementById('sceneNight').checked;
  ctx.fillStyle=night?'#1c1718':'#3a3028';ctx.fillRect(0,0,R0.w,R0.h);
  ctx.save();if(night)ctx.filter='brightness(0.45) saturate(0.85)';ctx.drawImage(R0.im,0,0);ctx.restore();
  const ordered=CARDS.filter(c=>c.visible&&pos[c.id]).sort((a,b)=>(pos[a.id][1]+a.norm.canvas_size[1])-(pos[b.id][1]+b.norm.canvas_size[1]));
  ordered.forEach(c=>{
    const [px,py]=pos[c.id];
    ctx.drawImage(night?c.im.night_back:c.im.day_back,px,py);
    const feet=c.norm.npc_feet_local_px;
    if(document.getElementById('showNpcs').checked&&feet&&c.idleIm.length){
      const sp=frameAtTick(c,animTick);
      if(sp)ctx.drawImage(sp,px+feet[0]-Math.floor(sp.width/2),py+feet[1]-sp.height+4);
    }
    const fr=night?c.im.night_front:c.im.day_front;
    if(fr)ctx.drawImage(fr,px,py);
  });
}
function drawScene(){
  if(!ROOMS.length)return;
  const R0=ROOMS[roomIdx];scv.width=R0.w;scv.height=R0.h;sctx.imageSmoothingEnabled=false;
  composeScene(sctx,R0);
  if(document.getElementById('showGrid').checked){
    sctx.strokeStyle='rgba(255,255,255,.15)';sctx.beginPath();
    for(let x=0;x<=R0.w;x+=8){sctx.moveTo(x+.5,0);sctx.lineTo(x+.5,R0.h)}
    for(let y=0;y<=R0.h;y+=8){sctx.moveTo(0,y+.5);sctx.lineTo(R0.w,y+.5)}
    sctx.stroke();
  }
}
rsel.onchange=()=>{roomIdx=+rsel.value;resetPositions();drawScene()};
['sceneNight','showNpcs','showGrid'].forEach(id=>document.getElementById(id).onchange=drawScene);
document.getElementById('resetPos').onclick=()=>{resetPositions();drawScene()};
scv.onclick=e=>{
  const rect=scv.getBoundingClientRect(),sx=scv.width/rect.width,sy=scv.height/rect.height;
  const c=CARDS.find(x=>x.id===objSel.value);c.visible=true;syncToggle();
  pos[c.id]=[Math.max(0,Math.floor(((e.clientX-rect.left)*sx-c.norm.canvas_size[0]/2)/8)*8),Math.max(0,Math.floor(((e.clientY-rect.top)*sy-c.norm.canvas_size[1]/2)/8)*8)];
  drawScene();
};
document.getElementById('exportScene').onclick=()=>{
  const R0=ROOMS[roomIdx],o=document.createElement('canvas');o.width=R0.w;o.height=R0.h;
  const c2=o.getContext('2d');c2.imageSmoothingEnabled=false;composeScene(c2,R0);
  const a=document.createElement('a');a.download=`Cafe_Cabaret_${R0.id}_10_objets.png`;a.href=o.toDataURL('image/png');a.click();
};

const allImgs=[...CARDS.flatMap(c=>[...Object.values(c.im).filter(Boolean),...c.idleIm]),...ROOMS.map(r=>r.im)];
Promise.all(allImgs.map(i=>i.decode().catch(()=>{}))).then(()=>{
  drawGallery();drawScene();
  setInterval(()=>{animTick+=3;if(document.getElementById('showNpcs').checked)drawScene()},50);
});
</script>
</html>
"""


if __name__ == '__main__':
    main()
