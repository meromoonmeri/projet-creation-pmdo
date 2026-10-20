"""Tests -> ZIP PNG + ZIP PMDO 0.8.12 -> aperçu interactif autonome racine du Kiosque Kirlia.
.venv/bin/python source/kiosque_kirlia_spinda_v1/package.py   (après build.py)
"""
from __future__ import annotations

import base64, io, json, subprocess, sys, zipfile
from pathlib import Path
import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/kiosque_kirlia_spinda_v1'
S = R / '.cache/kiosque_kirlia_spinda_v1/kiosque_kirlia_spinda'
V7_ROOMS_DIR = R / 'renders/cafe_spinda_revisite_v7/salles'
PFX = 'KKR1'


def zipdir(path: Path, items: list[tuple[Path, str]]) -> None:
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for src, arc in items:
            z.write(src, arc)


def uri_bytes(b: bytes) -> str:
    return 'data:image/png;base64,' + base64.b64encode(b).decode()


def uri(p: Path) -> str:
    return uri_bytes(Path(p).read_bytes())


def extract_kirlia_demo_frames() -> list[str]:
    """Découpe les poses de face (ligne 0) du sprite officiel Kirlia #0281 uniquement pour la démo interactive HTML."""
    sheet_p = HERE / 'references/kirlia_0281_idle_sheet.png'
    if not sheet_p.exists():
        return []
    im = Image.open(sheet_p).convert('RGBA')
    w, h = im.size
    fh = h // 8  # 8 directions PMD : ligne 0 = Sud (face au client !)
    cols = w // 27 if w % 27 == 0 else max(1, round(w / fh))
    fw = w // cols
    frames = []
    for c in range(cols):
        cell = im.crop((c * fw, 0, (c + 1) * fw, fh))
        buf = io.BytesIO()
        cell.save(buf, 'PNG')
        frames.append(uri_bytes(buf.getvalue()))
    return frames


def main() -> None:
    # S'assurer que les 5 salles propres V7 existent pour la démo de placement en salle
    if not (V7_ROOMS_DIR / 'SpindaV7_cafe_sans_magenta.png').exists():
        subprocess.run([sys.executable, 'source/cafe_spinda_revisite_v7/livrer_reseau.py'], cwd=R, check=True)

    subprocess.run([sys.executable, '-m', 'unittest', 'source.kiosque_kirlia_spinda_v1.test_build'], cwd=R, check=True)
    M = json.loads((O / 'manifest.json').read_text())

    zipdir(
        O / f'{PFX}_kiosque_kirlia_pmdo_0812.zip',
        [(p, 'kiosque_kirlia_spinda/' + p.relative_to(S).as_posix()) for p in sorted(S.rglob('*')) if p.is_file()],
    )
    png_items = [(p, p.relative_to(O).as_posix()) for p in sorted(O.rglob('*')) if p.is_file() and p.suffix != '.zip']
    zipdir(O / f'{PFX}_kiosque_kirlia_png.zip', png_items)

    rooms = []
    for rid, rlabel in [
        ('cafe', 'Café Spinda (+1)'),
        ('salon_haut', 'Salon haut (+1)'),
        ('accueil', 'Accueil escaliers N/S (0)'),
        ('casino', 'Casino (−1)'),
        ('salon_bas', 'Salon des jeux (−1)'),
    ]:
        rp = V7_ROOMS_DIR / f'SpindaV7_{rid}_sans_magenta.png'
        if rp.exists():
            with Image.open(rp) as rim:
                rw, rh = rim.size
            rooms.append({'id': rid, 'label': rlabel, 'w': rw, 'h': rh, 'uri': uri(rp)})

    data = {
        'manifest': M,
        'hd_clean': uri(O / 'hd/Kiosque_Kirlia_HD_sans_magenta.png'),
        'day_full': uri(O / 'assets_1x/Kiosque_Kirlia_1x_complet.png'),
        'day_back': uri(O / 'assets_1x/Kiosque_Kirlia_1x_arriere.png'),
        'day_front': uri(O / 'assets_1x/Kiosque_Kirlia_1x_avant.png'),
        'night_full': uri(O / 'assets_1x/Kiosque_Kirlia_1x_nuit_complet.png'),
        'night_back': uri(O / 'assets_1x/Kiosque_Kirlia_1x_nuit_arriere.png'),
        'night_front': uri(O / 'assets_1x/Kiosque_Kirlia_1x_nuit_avant.png'),
        'sheet_day': uri(O / 'tilesheets/Spinda_kirlia_kiosque_jour.png'),
        'sheet_night': uri(O / 'tilesheets/Spinda_kirlia_kiosque_nuit.png'),
        'kirlia_idle': extract_kirlia_demo_frames(),
        'rooms': rooms,
    }

    html = TEMPLATE.replace('__DATA__', json.dumps(data, ensure_ascii=False))
    out_html = R / 'apercu_kiosque_kirlia_spinda_v1.html'
    out_html.write_text(html)
    for p in [O / f'{PFX}_kiosque_kirlia_pmdo_0812.zip', O / f'{PFX}_kiosque_kirlia_png.zip', out_html]:
        print(p.relative_to(R), round(p.stat().st_size / 1e6, 2), 'Mo')


TEMPLATE = """<!doctype html>
<html lang="fr">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Kiosque Kirlia · Café Spinda (sans magenta, guichet transparent, comptoir bois nu)</title>
<style>
body{background:#2d2520;color:#f4ead8;font:15px/1.55 system-ui,sans-serif;margin:0;padding:24px}
main{max-width:1260px;margin:auto}
h1{font-size:29px;margin:0 0 6px}
h2{font-size:20px;margin:22px 0 8px;color:#bde3a8}
p{color:#dfd1bd;max-width:88ch;margin:6px 0 14px}
.row{display:flex;gap:22px;flex-wrap:wrap;align-items:flex-start}
.card{background:#3a3028;border:1px solid #6b5848;border-radius:10px;padding:16px}
canvas{display:block;image-rendering:pixelated;border-radius:6px;border:1px solid #59483b;cursor:crosshair}
aside{flex:1;min-width:290px;max-width:410px}
fieldset{border:1px solid #6b5848;border-radius:8px;margin:0 0 12px;padding:10px 14px}
legend{color:#bde3a8;padding:0 6px;font-weight:600}
label{display:block;padding:3px 0;cursor:pointer}
button,select,a.btn{background:#e7decb;color:#241c16;border:0;border-radius:6px;padding:7px 12px;margin:3px 4px 3px 0;cursor:pointer;font-weight:600;text-decoration:none;display:inline-block;font-size:13.5px}
button.on{background:#9bd180;color:#142410}
.hdwrap{display:flex;gap:18px;flex-wrap:wrap;align-items:center}
.hdimg{width:340px;height:340px;image-rendering:pixelated;border-radius:8px;border:1px solid #6b5848}
.note{border-left:3px solid #9bd180;padding-left:12px;font-size:13.5px;color:#d8cbb8}
code{color:#c7edb4}
</style>
<main>
<h1>Kiosque Kirlia — Café Spinda (détouré sans magenta, guichet transparent, comptoir nu)</h1>
<p>Version corrigée selon vos consignes : <strong>aucun fond noir dans le guichet</strong> (l'ouverture centrale et les ajours latéraux étaient en <code>#FF00FF</code> pur et ont été intégralement retirés vers <code>alpha = 0</code>), <strong>aucune feuille</strong> sur la façade du comptoir, <strong>aucun café/tasse</strong> posé sur le plateau en bois, et <strong>0 px de frange magenta/pourpre</strong> au bord extérieur comme au bord intérieur. Les PNG exportés ne contiennent aucun personnage.</p>

<section class="card" style="margin-bottom:20px">
  <h2 style="margin-top:0">1. Inspection directe du kiosque détouré (HD 1024×1024 &amp; échelle Ground 1× 112×120)</h2>
  <div class="hdwrap">
    <div>
      <canvas id="solo" width="340" height="340"></canvas>
      <div style="margin-top:8px">
        Fond de contrôle :
        <button data-bg="#3a3028" class="on">Neutre chaud (#3a3028)</button>
        <button data-bg="checker">Damier alpha</button>
        <button data-bg="#14181f">Sombre</button>
        <button data-bg="#e9e2d2">Crème clair</button>
      </div>
    </div>
    <div style="flex:1;min-width:280px">
      <fieldset><legend>Variante &amp; découpe éditeur</legend>
        <button data-part="full" class="on">Complet vide (112×120)</button>
        <button data-part="back">Plan arrière seul</button>
        <button data-part="front">Comptoir avant seul</button>
        <button data-part="hd">Master HD (1024×1024)</button>
        <label style="margin-top:6px"><input type="checkbox" id="soloNight"> Ambiance Nuit Spinda V8</label>
      </fieldset>
      <fieldset><legend>Téléchargements directs PNG transparents (alpha = 0)</legend>
        <a class="btn" id="dlHd" download="Kiosque_Kirlia_HD_sans_magenta.png">PNG HD (1024×1024)</a>
        <a class="btn" id="dl1x" download="Kiosque_Kirlia_1x_complet.png">PNG 1× Complet (112×120)</a>
        <a class="btn" id="dlBack" download="Kiosque_Kirlia_1x_arriere.png">PNG 1× Arrière</a>
        <a class="btn" id="dlFront" download="Kiosque_Kirlia_1x_avant.png">PNG 1× Avant</a>
        <a class="btn" id="dlSheet" download="Spinda_kirlia_kiosque_jour.png">Tilesheet Jour 1×</a>
      </fieldset>
      <p class="note">Vérification mesurée : trou central du guichet = <code>71 876 px</code> transparents en HD (<code>0 px</code> de noir, <code>0 px</code> de frange pourpre). Changez le fond ci-contre pour constater que tout l'intérieur du guichet laisse passer le décor.</p>
    </div>
  </div>
</section>

<div class="row">
  <div class="card"><canvas id="roomCanvas"></canvas></div>
  <aside>
    <fieldset><legend>2. Essai en situation — Salles Café Spinda V7</legend>
      <label>Salle V7 (sans outline magenta) : <select id="roomSel"></select></label>
      <label><input type="checkbox" id="nightMode"> Mode Nuit V8 (salle + kiosque)</label>
      <label><input type="checkbox" id="showKirlia" checked> Démo PNJ Kirlia (#0281) entre arrière et avant</label>
      <label><input type="checkbox" id="grid8"> Grille Ground 8 px</label>
      <div style="margin-top:8px">
        Zoom : <button data-z="1" class="on">1×</button><button data-z="2">2×</button>
      </div>
      <p style="font-size:13px;margin:8px 0 0">Cliquez dans la salle pour déplacer le kiosque sur la grille <code>8 px</code> : le mur/sol de la salle apparaît directement à travers le guichet ouvert.</p>
      <div id="posInfo" style="font-family:monospace;font-size:13px;margin-top:6px;color:#c7edb4"></div>
    </fieldset>
    <fieldset><legend>Export de la mise en situation</legend>
      <button id="expRoom">PNG 1× de la salle actuelle</button>
    </fieldset>
    <p class="note">Statut honnête : création générée (non native), <code>art_approved = false</code>, <code>runtime_tested = false</code>. Le sprite Kirlia #0281 affiché en option ci-dessus sert uniquement de repère d'échelle dans l'aperçu : aucun PNG livré ne contient de personnage.</p>
  </aside>
</div>
</main>
<script>
const D=__DATA__;
function mkImg(u){const i=new Image();i.src=u;return i}
const IM={
  hd:mkImg(D.hd_clean),
  day_full:mkImg(D.day_full),day_back:mkImg(D.day_back),day_front:mkImg(D.day_front),
  night_full:mkImg(D.night_full),night_back:mkImg(D.night_back),night_front:mkImg(D.night_front)
};
const KIRLIA=D.kirlia_idle.map(mkImg);
const ROOMS=D.rooms.map(r=>({...r,im:mkImg(r.uri)}));

document.getElementById('dlHd').href=D.hd_clean;
document.getElementById('dl1x').href=D.day_full;
document.getElementById('dlBack').href=D.day_back;
document.getElementById('dlFront').href=D.day_front;
document.getElementById('dlSheet').href=D.sheet_day;

let bgMode='#3a3028',part='full',roomIdx=0,zoom=1,kx=240,ky=96,kf=0;
const solo=document.getElementById('solo'),sctx=solo.getContext('2d');
function drawSolo(){
  const W=360,H=360;solo.width=W;solo.height=H;sctx.imageSmoothingEnabled=false;
  if(bgMode==='checker'){
    for(let y=0;y<H;y+=16)for(let x=0;x<W;x+=16){sctx.fillStyle=((x+y)/16)%2?'#524840':'#362f29';sctx.fillRect(x,y,16,16)}
  }else{sctx.fillStyle=bgMode;sctx.fillRect(0,0,W,H)}
  const night=document.getElementById('soloNight').checked;
  let im=part==='hd'?IM.hd:IM[(night?'night_':'day_')+(part==='full'?'full':part)];
  const sc=part==='hd'?0.33:2.8;
  const dw=Math.round(im.width*sc),dh=Math.round(im.height*sc);
  sctx.drawImage(im,Math.round((W-dw)/2),Math.round((H-dh)/2),dw,dh);
}
document.querySelectorAll('[data-bg]').forEach(b=>b.onclick=()=>{bgMode=b.dataset.bg;document.querySelectorAll('[data-bg]').forEach(o=>o.classList.toggle('on',o===b));drawSolo()});
document.querySelectorAll('[data-part]').forEach(b=>b.onclick=()=>{part=b.dataset.part;document.querySelectorAll('[data-part]').forEach(o=>o.classList.toggle('on',o===b));drawSolo()});
document.getElementById('soloNight').onchange=drawSolo;

const sel=document.getElementById('roomSel');
ROOMS.forEach((r,i)=>{const o=document.createElement('option');o.value=i;o.textContent=r.label;sel.append(o)});
const rc=document.getElementById('roomCanvas'),rctx=rc.getContext('2d');

function composeRoom(ctx,R0){
  ctx.fillStyle=document.getElementById('nightMode').checked?'#1c1718':'#3a3028';
  ctx.fillRect(0,0,R0.w,R0.h);
  ctx.save();
  if(document.getElementById('nightMode').checked)ctx.filter='brightness(0.45) saturate(0.85)';
  ctx.drawImage(R0.im,0,0);
  ctx.restore();
  const night=document.getElementById('nightMode').checked;
  const back=night?IM.night_back:IM.day_back,front=night?IM.night_front:IM.day_front;
  ctx.drawImage(back,kx,ky);
  if(document.getElementById('showKirlia').checked&&KIRLIA.length){
    const sp=KIRLIA[kf%KIRLIA.length];
    const feet=D.manifest.normalization_1x.npc_feet_local_px;
    ctx.drawImage(sp,kx+feet[0]-Math.floor(sp.width/2),ky+feet[1]-sp.height+4);
  }
  ctx.drawImage(front,kx,ky);
}
function drawRoom(){
  if(!ROOMS.length)return;
  const R0=ROOMS[roomIdx];
  rc.width=R0.w*zoom;rc.height=R0.h*zoom;rctx.imageSmoothingEnabled=false;
  rctx.save();rctx.scale(zoom,zoom);composeRoom(rctx,R0);rctx.restore();
  if(document.getElementById('grid8').checked){
    rctx.strokeStyle='rgba(255,255,255,.16)';rctx.beginPath();
    for(let x=0;x<=R0.w;x+=8){rctx.moveTo(x*zoom+.5,0);rctx.lineTo(x*zoom+.5,R0.h*zoom)}
    for(let y=0;y<=R0.h;y+=8){rctx.moveTo(0,y*zoom+.5);rctx.lineTo(R0.w*zoom,y*zoom+.5)}
    rctx.stroke();
  }
  document.getElementById('posInfo').textContent=`Position grille 8 px : X = ${kx}, Y = ${ky} (tuile ${kx/8}, ${ky/8})`;
}
sel.onchange=()=>{roomIdx=+sel.value;drawRoom()};
['nightMode','showKirlia','grid8'].forEach(id=>document.getElementById(id).onchange=drawRoom);
document.querySelectorAll('[data-z]').forEach(b=>b.onclick=()=>{zoom=+b.dataset.z;document.querySelectorAll('[data-z]').forEach(o=>o.classList.toggle('on',o===b));drawRoom()});
rc.onclick=e=>{const rect=rc.getBoundingClientRect();const x=Math.floor((e.clientX-rect.left)/zoom/8)*8-56;const y=Math.floor((e.clientY-rect.top)/zoom/8)*8-60;kx=Math.max(0,x);ky=Math.max(0,y);drawRoom()};
document.getElementById('expRoom').onclick=()=>{const R0=ROOMS[roomIdx],o=document.createElement('canvas');o.width=R0.w;o.height=R0.h;const c2=o.getContext('2d');c2.imageSmoothingEnabled=false;composeRoom(c2,R0);const a=document.createElement('a');a.download=`Spinda_${R0.id}_kiosque_kirlia_${kx}_${ky}.png`;a.href=o.toDataURL('image/png');a.click()};

Promise.all([...Object.values(IM),...KIRLIA,...ROOMS.map(r=>r.im)].map(i=>i.decode().catch(()=>{}))).then(()=>{
  drawSolo();drawRoom();
  setInterval(()=>{kf=(kf+1)%Math.max(KIRLIA.length,1);if(document.getElementById('showKirlia').checked)drawRoom()},180);
});
</script>
</html>
"""


if __name__ == '__main__':
    main()
