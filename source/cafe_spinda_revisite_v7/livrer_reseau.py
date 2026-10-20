"""Livre le VRAI reseau Cafe Spinda (V7) de facon visible : salles composees + apercu reseau.

Le reseau existe depuis V6/V7 (accueil avec escaliers N/S au centre, casino -1,
cafe +1, deux salons), mais dans ce depot allege il n'etait present que par ses
documents : les pixels sont dans SpindaV7_complet.zip (depot source, restaure ici
dans renders/cafe_spinda_revisite_v7/). Ce script compose chaque salle avec ses
calques par defaut (acces N/S et fenetres inclus), exporte les PNG dans
renders/cafe_spinda_revisite_v7/salles/ et genere l'apercu reseau racine.
Aucun pixel modifie ; aucun magenta (verifie).
.venv/bin/python source/cafe_spinda_revisite_v7/livrer_reseau.py
"""
from pathlib import Path
import base64, io, json, zipfile

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
D = R / 'renders/cafe_spinda_revisite_v7'
ZIP = D / 'SpindaV7_complet.zip'
OUT = D / 'salles'


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(ZIP) as z:
        m = json.loads(z.read('manifest.json'))
        def load(name):
            return Image.open(io.BytesIO(z.read(name))).convert('RGBA')
        rooms = []
        for room in m['rooms']:
            comp = Image.new('RGBA', tuple(room['size']))
            for layer in room['layers']:
                if layer.get('default'):
                    comp.alpha_composite(load(layer.get('png', layer['file'])))
            a = np.array(comp).astype(int)
            assert not ((a[..., :3] == (255, 0, 255)).all(-1) & (a[..., 3] == 255)).any(), room['id']
            p = OUT / f"SpindaV7_{room['id']}_composee.png"
            comp.save(p, optimize=True)
            rooms.append({'id': room['id'], 'title': room['title'], 'level': room['level'],
                          'file': str(p.relative_to(D)), 'ports': room.get('ports', {}),
                          'uri': 'data:image/png;base64,' + base64.b64encode(p.read_bytes()).decode()})
    (D / 'salles_manifest.json').write_text(json.dumps(
        {'provenance': 'compose depuis SpindaV7_complet.zip (calques par defaut, acces et fenetres inclus), aucun pixel modifie',
         'rooms': [{k: v for k, v in r.items() if k != 'uri'} for r in rooms],
         'links': m['links'], 'runtime_PMDO': 'NOT TESTED'}, ensure_ascii=False, indent=2) + '\n')
    html = TEMPLATE.replace('__DATA__', json.dumps({'rooms': rooms, 'links': m['links']}, ensure_ascii=False))
    (R / 'apercu_cafe_spinda_reseau_v7.html').write_text(html)
    print([r['id'] for r in rooms], m['links'])


TEMPLATE = r"""<!doctype html><html lang="fr"><meta charset="utf-8">
<title>Café Spinda · le vrai réseau (étages)</title>
<style>
body{font-family:system-ui,sans-serif;background:#241c15;color:#f3e9d2;margin:2em}
.floor{border:1px solid #a98f6b;border-radius:12px;padding:1em;margin:1em 0;background:#2e2620}
.row{display:flex;gap:1em;flex-wrap:wrap}
figure{margin:0;text-align:center}
img{width:420px;max-width:88vw;image-rendering:pixelated;background:repeating-conic-gradient(#5a5a5a 0 25%,#8a8a8a 0 50%) 0 0/20px 20px;border-radius:6px}
figcaption{margin-top:.4em}

</style>
<h1>☕ Café Spinda — le vrai réseau, avec ses étages</h1>
<p>Accueil au rez-de-chaussée : <strong>escalier nord au centre</strong> → café (+1), <strong>escalier sud au centre</strong> → casino (−1).
Casino ↔ salon des jeux (−1) et café ↔ salon haut (+1) par les portes latérales. Salles 600×448 composées depuis le pack V7
(calques par défaut, accès et fenêtres inclus), fond transparent. Transitions indépendantes — warps PMDO non testés.</p>
<div id="app"></div>
<script>
const D=__DATA__;const app=document.getElementById('app');
[[1,'Étage +1'],[0,'Rez-de-chaussée'],[-1,'Sous-sol −1']].forEach(([lv,name])=>{
 const sec=document.createElement('section');sec.className='floor';sec.innerHTML='<h2>'+name+'</h2>';
 const row=document.createElement('div');row.className='row';
 D.rooms.filter(r=>r.level===lv).forEach(r=>{const f=document.createElement('figure');
  f.innerHTML='<img src="'+r.uri+'"><figcaption><strong>'+r.title+'</strong></figcaption>';row.append(f);});
 sec.append(row);app.append(sec);});
</script></html>
"""

if __name__ == '__main__':
    main()
