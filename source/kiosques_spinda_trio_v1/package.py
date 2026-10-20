"""Tests -> ZIP PNG sans fond + ZIP PMDO 0.8.12 -> aperçu interactif autonome racine du Trio Café.
.venv/bin/python source/kiosques_spinda_trio_v1/package.py   (après build.py)
"""
from __future__ import annotations

import base64, io, json, subprocess, sys, zipfile
from pathlib import Path
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/kiosques_spinda_trio_v1'
S = R / '.cache/kiosques_spinda_trio_v1/kiosques_cafe_spinda_trio'
HALCYON_CAFE = R / 'renders/cafe_halcyon_agrandi_v1/CafeHalcyon_terrain_transparent.png'
V7_ROOMS_DIR = R / 'renders/cafe_spinda_revisite_v7/salles'
PFX = 'KTR1'


def zipdir(path: Path, items: list[tuple[Path, str]]) -> None:
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for src, arc in items:
            z.write(src, arc)


def uri_bytes(b: bytes) -> str:
    return 'data:image/png;base64,' + base64.b64encode(b).decode()


def uri(p: Path) -> str:
    return uri_bytes(Path(p).read_bytes())


ANIM_META = {
    'spinda': {'fw': 32, 'fh': 48, 'durations': [4, 8, 14, 4, 5, 6, 8, 14, 6]},
    'qulbutoke': {'fw': 24, 'fh': 40, 'durations': [40, 4, 4, 4, 4, 4, 4, 4, 4]},
    'sucreine': {'fw': 32, 'fh': 56, 'durations': [30, 30]},
}


def extract_idle_south_frames(slug: str, sheet_p: Path) -> list[str]:
    if not sheet_p.exists() or slug not in ANIM_META:
        return []
    im = Image.open(sheet_p).convert('RGBA')
    fw = ANIM_META[slug]['fw']
    fh = ANIM_META[slug]['fh']
    cols = len(ANIM_META[slug]['durations'])
    out = []
    for c in range(cols):
        buf = io.BytesIO()
        im.crop((c * fw, 0, (c + 1) * fw, fh)).save(buf, 'PNG')
        out.append(uri_bytes(buf.getvalue()))
    return out


def main() -> None:
    subprocess.run([sys.executable, '-m', 'unittest', 'source.kiosques_spinda_trio_v1.test_build'], cwd=R, check=True)
    M = json.loads((O / 'manifest.json').read_text())

    zipdir(
        O / f'{PFX}_kiosques_spinda_qulbutoke_sucreine_pmdo_0812.zip',
        [(p, 'kiosques_cafe_spinda_trio/' + p.relative_to(S).as_posix()) for p in sorted(S.rglob('*')) if p.is_file()],
    )
    png_items = [(p, p.relative_to(O).as_posix()) for p in sorted(O.rglob('*')) if p.is_file() and p.suffix != '.zip']
    zipdir(O / f'{PFX}_kiosques_spinda_qulbutoke_sucreine_sans_fond.zip', png_items)

    rooms = []
    if HALCYON_CAFE.exists():
        with Image.open(HALCYON_CAFE) as im:
            rw, rh = im.size
        rooms.append({
            'id': 'halcyon_grand_cafe',
            'label': 'Grand Café Métano · Halcyon (840×576)',
            'w': rw,
            'h': rh,
            'uri': uri(HALCYON_CAFE),
            'defaults': {'spinda': [144, 96], 'sucreine': [352, 64], 'qulbutoke': [560, 80]},
        })
    for rid, rlabel in [
        ('cafe', 'Café Spinda V7 (+1 · 600×448)'),
        ('salon_haut', 'Salon haut Spinda V7 (+1 · 600×448)'),
        ('casino', 'Casino Spinda V7 (−1 · 600×448)'),
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
                'defaults': {'spinda': [80, 96], 'sucreine': [232, 72], 'qulbutoke': [384, 88]},
            })

    cards = []
    for o in M['objects']:
        slug = o['id']
        Cap = slug.capitalize()
        cards.append({
            'id': slug,
            'label': o['label'],
            'pfx': o['prefix'],
            'dex': o['dex'],
            'norm': o['normalization_1x'],
            'hd': uri(O / o['hd_sans_fond']),
            'day_full': uri(O / f'assets_1x/{Cap}_Comptoir_1x_complet.png'),
            'day_back': uri(O / f'assets_1x/{Cap}_Comptoir_1x_arriere.png'),
            'day_front': uri(O / f'assets_1x/{Cap}_Comptoir_1x_avant.png'),
            'night_full': uri(O / f'assets_1x/{Cap}_Comptoir_1x_nuit_complet.png'),
            'night_back': uri(O / f'assets_1x/{Cap}_Comptoir_1x_nuit_arriere.png'),
            'night_front': uri(O / f'assets_1x/{Cap}_Comptoir_1x_nuit_avant.png'),
            'idle': extract_idle_south_frames(slug, HERE / f'references/{slug}_{o["dex"]}_idle_sheet.png'),
            'durations': ANIM_META[slug]['durations'],
        })

    data = {
        'manifest': M,
        'ref_halcyon_bar': uri(HERE / 'references/halcyon_metano_cafe/ref_bar_shuckle_complet_4x.png'),
        'sheet_day': uri(O / 'tilesheets/Tilesheet_Kiosques_Cafe_Jour_1x.png'),
        'sheet_night': uri(O / 'tilesheets/Tilesheet_Kiosques_Cafe_Nuit_1x.png'),
        'cards': cards,
        'rooms': rooms,
    }
    out_html = R / 'apercu_kiosques_spinda_trio_v1.html'
    out_html.write_text(TEMPLATE.replace('__DATA__', json.dumps(data, ensure_ascii=False)))
    for p in [
        O / f'{PFX}_kiosques_spinda_qulbutoke_sucreine_pmdo_0812.zip',
        O / f'{PFX}_kiosques_spinda_qulbutoke_sucreine_sans_fond.zip',
        out_html,
    ]:
        print(p.relative_to(R), round(p.stat().st_size / 1e6, 2), 'Mo')


TEMPLATE = """<!doctype html>
<html lang="fr">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Kiosques Café · Spinda, Qulbutoké &amp; Sucreine (100 % sans fond · style Metano_Town_Cafe_Objects)</title>
<style>
body{background:#261f1a;color:#f5ebd9;font:15px/1.55 system-ui,sans-serif;margin:0;padding:24px}
main{max-width:1340px;margin:auto}
h1{font-size:29px;margin:0 0 6px}
h2{font-size:20px;margin:0 0 10px;color:#f6d58e}
p{color:#dfd1bd;max-width:94ch;margin:6px 0 14px}
.card{background:#3a3028;border:1px solid #6d5948;border-radius:11px;padding:16px;margin-bottom:20px}
.grid3{display:grid;grid-template-columns:repeat(auto-fit,minmax(360px,1fr));gap:16px}
.subcard{background:#2f2620;border:1px solid #5d4b3d;border-radius:9px;padding:13px}
canvas{display:block;image-rendering:pixelated;border-radius:7px;border:1px solid #5d4b3d;max-width:100%}
button,select,a.btn{background:#ebdfc8;color:#241b14;border:0;border-radius:6px;padding:6px 11px;margin:3px 4px 3px 0;cursor:pointer;font-weight:600;text-decoration:none;display:inline-block;font-size:13px}
button.on{background:#f2c15a;color:#231606}
.toolbar{display:flex;gap:10px;flex-wrap:wrap;align-items:center;margin-bottom:12px}
.note{border-left:3px solid #f2c15a;padding-left:12px;font-size:13.5px;color:#d9cab6}
code{color:#f7d996}
</style>
<main>
<h1>Comptoirs / Kiosques de Café — Spinda, Qulbutoké &amp; Sucreine (100 % sans fond)</h1>
<p>Conçus directement d'après l'objet de bar de <code>Metano_Town_Cafe_Objects</code> + <code>Metano_Town_Cafe_Objects_Over</code> (<em>Halcyon</em>) et détourés <strong>100 % sans fond</strong> (<code>alpha = 0</code> extérieur et ajours internes, <code>0 px</code> de magenta ou de frange pourpre en HD comme à l'échelle Ground <code>1×</code>). Aucun personnage n'est incrusté dans les PNG livrés.</p>

<section class="card">
  <div class="toolbar">
    <strong style="margin-right:6px">1. Galerie des 3 objets détourés sans fond :</strong>
    Fond de contrôle :
    <button data-bg="#3a3028" class="on">Neutre chaud (#3a3028)</button>
    <button data-bg="checker">Damier alpha (preuve sans fond)</button>
    <button data-bg="#141820">Nuit sombre</button>
    <button data-bg="#ede5d4">Crème clair</button>
    <span style="margin-left:10px">Rendu :</span>
    <button data-mode="hd" class="on">Master HD sans fond</button>
    <button data-mode="full">Ground 1× Complet (144 px)</button>
    <button data-mode="back">1× Arrière seul</button>
    <button data-mode="front">1× Comptoir avant seul</button>
    <label style="margin-left:8px;cursor:pointer"><input type="checkbox" id="galNight"> Mode Nuit V8</label>
    <a class="btn" id="dlSheetDay" download="Tilesheet_Kiosques_Cafe_Jour_1x.png">Tilesheet 1× Jour (les 3)</a>
    <a class="btn" id="dlSheetNight" download="Tilesheet_Kiosques_Cafe_Nuit_1x.png">Tilesheet 1× Nuit (les 3)</a>
  </div>
  <div class="grid3" id="cardsWrap"></div>
</section>

<section class="card">
  <h2>2. Mise en situation interactive — Grand Café Métano (Halcyon 840×576) &amp; Salles Café Spinda V7</h2>
  <div class="toolbar">
    <label>Salle : <select id="roomSel"></select></label>
    <label>Déplacer au clic :
      <select id="activeObj">
        <option value="spinda">Comptoir Spinda</option>
        <option value="sucreine">Comptoir Sucreine</option>
        <option value="qulbutoke">Comptoir Qulbutoké</option>
      </select>
    </label>
    <label style="cursor:pointer"><input type="checkbox" id="sceneNight"> Ambiance Nuit V8</label>
    <label style="cursor:pointer"><input type="checkbox" id="showNpcs" checked> Démo PNJ animés (#0327 / #0763 / #0202) entre arrière et avant</label>
    <label style="cursor:pointer"><input type="checkbox" id="showGrid"> Grille 8 px</label>
    <button id="resetPos">Réinitialiser l'alignement</button>
    <button id="exportScene">Exporter la salle en PNG</button>
  </div>
  <canvas id="sceneCanvas" style="cursor:crosshair"></canvas>
  <p id="coordsLine" style="font-family:monospace;font-size:13px;color:#f7d996;margin:10px 0 4px"></p>
  <p class="note">Statut honnête : créations générées référencées sur <code>Metano_Town_Cafe_Objects</code> (non des tuiles natives certifiées), <code>art_approved = false</code>, <code>runtime_tested = false</code>. Les sprites Pokémon affichés en option servent uniquement de démonstration d'échelle entre <code>arriere</code> et <code>avant</code> : tous les PNG téléchargeables sont 100 % vides de personnage et 100 % sans fond.</p>
</section>
</main>
<script>
const D=__DATA__;
function mk(u){const i=new Image();i.src=u;return i}
const CARDS=D.cards.map(c=>({...c,im:{
  hd:mk(c.hd),day_full:mk(c.day_full),day_back:mk(c.day_back),day_front:mk(c.day_front),
  night_full:mk(c.night_full),night_back:mk(c.night_back),night_front:mk(c.night_front)
},idleIm:c.idle.map(mk)}));
const ROOMS=D.rooms.map(r=>({...r,im:mk(r.uri)}));
document.getElementById('dlSheetDay').href=D.sheet_day;
document.getElementById('dlSheetNight').href=D.sheet_night;

let bg='#3a3028',mode='hd',roomIdx=0,pos={},animTick=0;
function resetPositions(){pos=JSON.parse(JSON.stringify(ROOMS[roomIdx].defaults))}
resetPositions();

const wrap=document.getElementById('cardsWrap');
const cardCanvases={};
CARDS.forEach(c=>{
  const Cap=c.id[0].toUpperCase()+c.id.slice(1);
  const el=document.createElement('div');el.className='subcard';
  el.innerHTML=`<div style="display:flex;justify-content:space-between;align-items:baseline;margin-bottom:6px">
    <strong style="font-size:17px;color:#f6d58e">${c.label} <code>(${c.pfx})</code></strong>
    <small style="color:#cbbba6">HD ${c.norm.hd_tight_size[0]}×${c.norm.hd_tight_size[1]} · 1× ${c.norm.canvas_size[0]}×${c.norm.canvas_size[1]}</small>
  </div>
  <canvas width="384" height="312" id="cv_${c.id}"></canvas>
  <div style="margin-top:9px">
    <a class="btn" href="${c.hd}" download="${Cap}_Comptoir_HD_sans_fond.png">PNG HD sans fond</a>
    <a class="btn" href="${c.day_full}" download="${Cap}_Comptoir_1x_complet.png">PNG 1× Complet</a>
    <a class="btn" href="${c.day_back}" download="${Cap}_Comptoir_1x_arriere.png">1× Arrière</a>
    <a class="btn" href="${c.day_front}" download="${Cap}_Comptoir_1x_avant.png">1× Avant</a>
  </div>`;
  wrap.append(el);
  cardCanvases[c.id]=el.querySelector('canvas');
});

function paintBg(ctx,W,H){
  if(bg==='checker'){
    for(let y=0;y<H;y+=16)for(let x=0;x<W;x+=16){ctx.fillStyle=((x+y)/16)%2?'#544940':'#362f29';ctx.fillRect(x,y,16,16)}
  }else{ctx.fillStyle=bg;ctx.fillRect(0,0,W,H)}
}
function drawGallery(){
  const night=document.getElementById('galNight').checked;
  CARDS.forEach(c=>{
    const cv=cardCanvases[c.id],ctx=cv.getContext('2d'),W=cv.width,H=cv.height;
    ctx.imageSmoothingEnabled=false;paintBg(ctx,W,H);
    const key=mode==='hd'?'hd':((night?'night_':'day_')+mode);
    const im=c.im[key];
    const scale=mode==='hd'?Math.min((W-24)/im.width,(H-24)/im.height):2.0;
    const dw=Math.round(im.width*scale),dh=Math.round(im.height*scale);
    ctx.drawImage(im,Math.round((W-dw)/2),Math.round((H-dh)/2),dw,dh);
  });
}
document.querySelectorAll('[data-bg]').forEach(b=>b.onclick=()=>{bg=b.dataset.bg;document.querySelectorAll('[data-bg]').forEach(x=>x.classList.toggle('on',x===b));drawGallery()});
document.querySelectorAll('[data-mode]').forEach(b=>b.onclick=()=>{mode=b.dataset.mode;document.querySelectorAll('[data-mode]').forEach(x=>x.classList.toggle('on',x===b));drawGallery()});
document.getElementById('galNight').onchange=drawGallery;

const rsel=document.getElementById('roomSel');
ROOMS.forEach((r,i)=>{const o=document.createElement('option');o.value=i;o.textContent=r.label;rsel.append(o)});
const scv=document.getElementById('sceneCanvas'),sctx=scv.getContext('2d');

function frameAtTick(c,t){
  const total=c.durations.reduce((a,b)=>a+b,0);
  let r=t%total;
  for(let i=0;i<c.durations.length;i++){if(r<c.durations[i])return c.idleIm[i];r-=c.durations[i];}
  return c.idleIm[0];
}
function composeScene(ctx,R0){
  const night=document.getElementById('sceneNight').checked;
  ctx.fillStyle=night?'#1c1718':'#3a3028';ctx.fillRect(0,0,R0.w,R0.h);
  ctx.save();if(night)ctx.filter='brightness(0.45) saturate(0.85)';ctx.drawImage(R0.im,0,0);ctx.restore();
  // Tri vertical par bas de comptoir pour superposition 3/4 naturelle
  const ordered=[...CARDS].sort((a,b)=>(pos[a.id][1]+a.norm.canvas_size[1])-(pos[b.id][1]+b.norm.canvas_size[1]));
  ordered.forEach(c=>{
    const [px,py]=pos[c.id];
    ctx.drawImage(night?c.im.night_back:c.im.day_back,px,py);
    if(document.getElementById('showNpcs').checked&&c.idleIm.length){
      const sp=frameAtTick(c,animTick);
      const feet=c.norm.npc_feet_local_px;
      ctx.drawImage(sp,px+feet[0]-Math.floor(sp.width/2),py+feet[1]-sp.height+4);
    }
    ctx.drawImage(night?c.im.night_front:c.im.day_front,px,py);
  });
}
function drawScene(){
  if(!ROOMS.length)return;
  const R0=ROOMS[roomIdx];
  scv.width=R0.w;scv.height=R0.h;sctx.imageSmoothingEnabled=false;
  composeScene(sctx,R0);
  if(document.getElementById('showGrid').checked){
    sctx.strokeStyle='rgba(255,255,255,.15)';sctx.beginPath();
    for(let x=0;x<=R0.w;x+=8){sctx.moveTo(x+.5,0);sctx.lineTo(x+.5,R0.h)}
    for(let y=0;y<=R0.h;y+=8){sctx.moveTo(0,y+.5);sctx.lineTo(R0.w,y+.5)}
    sctx.stroke();
  }
  document.getElementById('coordsLine').textContent=CARDS.map(c=>`${c.label}: (${pos[c.id][0]}, ${pos[c.id][1]})`).join('  ·  ');
}
rsel.onchange=()=>{roomIdx=+rsel.value;resetPositions();drawScene()};
['sceneNight','showNpcs','showGrid'].forEach(id=>document.getElementById(id).onchange=drawScene);
document.getElementById('resetPos').onclick=()=>{resetPositions();drawScene()};
scv.onclick=e=>{
  const rect=scv.getBoundingClientRect(),sx=scv.width/rect.width,sy=scv.height/rect.height;
  const id=document.getElementById('activeObj').value;
  const c=CARDS.find(x=>x.id===id);
  pos[id]=[Math.max(0,Math.floor(((e.clientX-rect.left)*sx-c.norm.canvas_size[0]/2)/8)*8),Math.max(0,Math.floor(((e.clientY-rect.top)*sy-c.norm.canvas_size[1]/2)/8)*8)];
  drawScene();
};
document.getElementById('exportScene').onclick=()=>{
  const R0=ROOMS[roomIdx],o=document.createElement('canvas');o.width=R0.w;o.height=R0.h;
  const c2=o.getContext('2d');c2.imageSmoothingEnabled=false;composeScene(c2,R0);
  const a=document.createElement('a');a.download=`Cafe_${R0.id}_trio_spinda_qulbutoke_sucreine.png`;a.href=o.toDataURL('image/png');a.click();
};

const allImgs=[...CARDS.flatMap(c=>[...Object.values(c.im),...c.idleIm]),...ROOMS.map(r=>r.im)];
Promise.all(allImgs.map(i=>i.decode().catch(()=>{}))).then(()=>{
  drawGallery();drawScene();
  setInterval(()=>{animTick+=3;if(document.getElementById('showNpcs').checked)drawScene()},50);
});
</script>
</html>
"""


if __name__ == '__main__':
    main()
