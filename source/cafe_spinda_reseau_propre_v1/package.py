"""Aperçu autonome + ZIP de la livraison propre du réseau café (après build + verify).
.venv/bin/python source/cafe_spinda_reseau_propre_v1/package.py
"""
from pathlib import Path
import base64, json, subprocess, sys, zipfile

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
OUT = R / 'renders/cafe_spinda_reseau_propre_v1'


def uri(p):
    return 'data:image/png;base64,' + base64.b64encode(Path(p).read_bytes()).decode()


def main():
    subprocess.run([sys.executable, str(HERE / 'verify.py')], cwd=R, check=True)
    m = json.loads((OUT / 'manifest.json').read_text())
    rooms = [{'id': r['id'], 'title': r['title'], 'level': r['level'],
              'uri': uri(OUT / r['file']), 'preview': uri(OUT / r['preview']),
              'layers': [l['id'] for l in r['layers']]} for r in m['rooms']]
    html = TEMPLATE.replace('__DATA__', json.dumps({'rooms': rooms, 'links': m['links']}, ensure_ascii=False))
    (R / 'apercu_cafe_spinda_reseau_propre_v1.html').write_text(html)
    target = OUT / 'CafeSpinda_reseau_propre.zip'
    files = {}
    for p in sorted(OUT.rglob('*')):
        if p.is_file() and p.name != target.name:
            files[str(p.relative_to(OUT))] = p.read_bytes()
    files['apercu_cafe_spinda_reseau_propre_v1.html'] = html.encode()
    with zipfile.ZipFile(target, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for name, payload in files.items():
            info = zipfile.ZipInfo(name, date_time=(2026, 10, 20, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            z.writestr(info, payload)
    with zipfile.ZipFile(target) as z:
        assert z.testzip() is None
        for name, payload in files.items():
            assert z.read(name) == payload
    print(target.relative_to(R), round(target.stat().st_size / 1e6, 2), 'Mo')
    print('apercu_cafe_spinda_reseau_propre_v1.html', round((R / 'apercu_cafe_spinda_reseau_propre_v1.html').stat().st_size / 1e6, 2), 'Mo')


TEMPLATE = r"""<!doctype html><html lang="fr"><meta charset="utf-8">
<title>Café Spinda · réseau au propre (sans fond magenta)</title>
<style>
body{font-family:system-ui,sans-serif;background:#2e2620;color:#f3e9d2;margin:2em}
button{background:#57493a;color:#f3e9d2;border:1px solid #a98f6b;border-radius:8px;padding:.5em 1em;margin:.2em;cursor:pointer}
button.on{background:#a98f6b;color:#221a14}
#stage{width:900px;max-width:95vw;aspect-ratio:600/448;display:flex;align-items:center;justify-content:center;border-radius:8px}
#stage img{width:100%;image-rendering:pixelated}
.checker{background:repeating-conic-gradient(#666 0 25%,#999 0 50%) 0 0/24px 24px}
.neutral{background:#3a3028}
a{color:#e8c97a}
</style>
<h1>Café &amp; Casino Spinda — réseau au propre, sans fond magenta</h1>
<p>Les cinq salles du réseau V4, recomposées en <strong>PNG à fond transparent</strong> : aucun pixel magenta,
frange de détourage recolorée. V4 (et ses aperçus magenta) est conservée telle quelle ; ceci est un dérivé propre.
Fond d'affichage : <button id="bchecker">damier (transparence)</button> <button id="bneutral">neutre chaud</button></p>
<div id="nav"></div>
<h2 id="title"></h2>
<div id="stage" class="checker"><img id="room" alt="salle"></div>
<p id="meta"></p>
<p>Réseau : accueil (RDC) ↔ casino et salon bas (−1) par les escaliers proposés ; accueil ↔ café et salon haut (+1) ;
casino ↔ salon bas et café ↔ salon haut par les portes latérales. Transitions indépendantes, pas de warps PMDO (non testé dans le moteur).</p>
<script>
const D=__DATA__;
const nav=document.getElementById('nav'),img=document.getElementById('room'),title=document.getElementById('title'),meta=document.getElementById('meta'),stage=document.getElementById('stage');
function show(r,btn){img.src=r.uri;title.textContent=r.title+' · niveau '+r.level;meta.textContent='PNG transparent 600×448 · calques : '+r.layers.join(', ');
document.querySelectorAll('#nav button').forEach(b=>b.classList.remove('on'));btn.classList.add('on');}
D.rooms.forEach((r,i)=>{const b=document.createElement('button');b.textContent=r.title;nav.append(b);b.onclick=()=>show(r,b);if(!i)show(r,b);});
document.getElementById('bchecker').onclick=()=>stage.className='checker';
document.getElementById('bneutral').onclick=()=>stage.className='neutral';
</script></html>
"""

if __name__ == '__main__':
    main()
