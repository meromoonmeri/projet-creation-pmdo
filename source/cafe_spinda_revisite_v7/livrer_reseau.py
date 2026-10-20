"""Livre le VRAI reseau Cafe Spinda (V7) SANS outline magenta, apercu sur fond neutre.

Demande de l'utilisateur (20 octobre 2026) : « regenere toute les salle sans le
outline majenta et je veux l'apercu avec fond neutre ».

Le reseau V7 (accueil avec escaliers N/S au centre, casino -1, cafe +1, deux salons)
est restaure depuis SpindaV7_complet.zip (depot source). Ses calques gardent une
frange magenta du detourage d'origine le long des bordures (623 a 891 px par salle,
dans parois/bordures/acces). Ici, pour chaque calque par defaut :
- la frange (pixels opaques teintes magenta, meme faiblement : r > g + 20, b > g + 10, a <= 2 px de la
  transparence) est RECOLOREE par le plus proche pixel opaque propre du meme calque
  (alpha et silhouette inchanges) ;
- la salle est recomposee depuis ces calques nettoyes ;
- exporte : salle transparente sans magenta (salles/), calques nettoyes
  (calques_propres/), et apercu sur FOND NEUTRE chaud (58,48,40) (apercus/) ;
- l'apercu HTML racine affiche les salles sur ce fond neutre, sans damier.

Verification integree : aucun pixel magenta exact, aucune frange residuelle au bord,
et l'ecart avec la composition V7 d'origine est limite aux pixels de frange.
Le pack V7 et ses calques d'origine ne sont pas modifies. Pas un test PMDO.
.venv/bin/python source/cafe_spinda_revisite_v7/livrer_reseau.py
"""
from pathlib import Path
import base64, io, json, zipfile

import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
D = R / 'renders/cafe_spinda_revisite_v7'
ZIP = D / 'SpindaV7_complet.zip'
OUT = D / 'salles'
LAYERS_OUT = D / 'calques_propres'
PREVIEW_OUT = D / 'apercus'
NEUTRAL = (58, 48, 40, 255)


def contaminated(a):
    return (a[..., 3] == 255) & (a[..., 0] > a[..., 1] + 20) & (a[..., 2] > a[..., 1] + 10)   # teinte magenta, meme faible


def fringe_of(a):
    return contaminated(a) & nd.binary_dilation(a[..., 3] != 255, iterations=2)


def clean_fringe(im):
    """Recolore la frange magenta d'un calque par le plus proche pixel propre. Alpha inchangée."""
    a = np.array(im).astype(int)
    fringe = fringe_of(a)
    n = int(fringe.sum())
    if n:
        clean = (a[..., 3] == 255) & ~contaminated(a)
        idx = nd.distance_transform_edt(~clean, return_distances=False, return_indices=True)
        a[fringe] = a[tuple(idx[:, fringe])]
        a[..., 3] = np.array(im)[..., 3]
    return Image.fromarray(a.astype('uint8')), n


def main():
    for d in (OUT, LAYERS_OUT, PREVIEW_OUT):
        d.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(ZIP) as z:
        m = json.loads(z.read('manifest.json'))
        def load(name):
            return Image.open(io.BytesIO(z.read(name))).convert('RGBA')

        rooms = []
        for room in m['rooms']:
            comp = Image.new('RGBA', tuple(room['size']))
            original = Image.new('RGBA', tuple(room['size']))
            cleaned_total, per_layer = 0, {}
            union_fringe = np.zeros(tuple(room['size'])[::-1], bool)
            for layer in room['layers']:
                if not layer.get('default'):
                    continue
                raw = load(layer.get('png', layer['file']))
                original.alpha_composite(raw)
                union_fringe |= fringe_of(np.array(raw).astype(int))
                im, n = clean_fringe(raw)
                cleaned_total += n
                per_layer[layer['id']] = n
                dst = LAYERS_OUT / room['id'] / f"SpindaV7_{room['id']}_{layer['id']}_sans_magenta.png"
                dst.parent.mkdir(parents=True, exist_ok=True)
                im.save(dst, optimize=True)
                comp.alpha_composite(im)
            a = np.array(comp).astype(int)
            assert not ((a[..., :3] == (255, 0, 255)).all(-1) & (a[..., 3] == 255)).any(), room['id']
            assert not fringe_of(a).any(), (room['id'], int(fringe_of(a).sum()))
            orig = np.array(original).astype(int)
            diff = (a != orig).any(-1)
            assert not (diff & ~union_fringe).any(), (room['id'], 'écart hors frange des calques')
            p = OUT / f"SpindaV7_{room['id']}_sans_magenta.png"
            comp.save(p, optimize=True)
            bg = Image.new('RGBA', tuple(room['size']), NEUTRAL)
            bg.alpha_composite(comp)
            preview = PREVIEW_OUT / f"SpindaV7_{room['id']}_fond_neutre.png"
            bg.convert('RGB').save(preview, optimize=True)
            rooms.append({'id': room['id'], 'title': room['title'], 'level': room['level'],
                          'file': str(p.relative_to(D)), 'preview': str(preview.relative_to(D)),
                          'frange_recoloree_px': cleaned_total, 'frange_par_calque': per_layer,
                          'uri': 'data:image/png;base64,' + base64.b64encode(preview.read_bytes()).decode()})
    (D / 'salles_manifest.json').write_text(json.dumps(
        {'provenance': 'compose depuis SpindaV7_complet.zip (calques par defaut, acces et fenetres inclus)',
         'nettoyage': 'frange magenta (r > g+20 et b > g+10, <= 2 px de la transparence) recoloree par plus proche pixel '
                      'propre du meme calque ; alpha et silhouette inchangées ; aucun pixel magenta, verifie',
         'fond_apercu': 'neutre chaud (58,48,40), uniquement dans apercus/*_fond_neutre.png et l apercu HTML ; '
                        'les salles salles/*_sans_magenta.png restent transparentes',
         'rooms': [{k: v for k, v in r.items() if k != 'uri'} for r in rooms],
         'links': m['links'], 'runtime_PMDO': 'NOT TESTED'}, ensure_ascii=False, indent=2) + '\n')
    html = TEMPLATE.replace('__DATA__', json.dumps({'rooms': rooms, 'links': m['links']}, ensure_ascii=False))
    (R / 'apercu_cafe_spinda_reseau_v7.html').write_text(html)
    print({r['id']: r['frange_recoloree_px'] for r in rooms})


TEMPLATE = r"""<!doctype html><html lang="fr"><meta charset="utf-8">
<title>Café Spinda · le vrai réseau, sans outline magenta (fond neutre)</title>
<style>
body{font-family:system-ui,sans-serif;background:#3a3028;color:#f3e9d2;margin:2em}
.floor{border:1px solid #a98f6b;border-radius:12px;padding:1em;margin:1em 0;background:#443830}
.row{display:flex;gap:1em;flex-wrap:wrap}
figure{margin:0;text-align:center}
img{width:460px;max-width:88vw;image-rendering:pixelated;border-radius:6px;background:#3a3028}
figcaption{margin-top:.4em}
</style>
<h1>☕ Café Spinda — le vrai réseau, sans outline magenta</h1>
<p>Les cinq salles régénérées depuis le pack V7 : la <strong>frange magenta de détourage est recolorée</strong>
(623 à 891 px par salle, bords rocheux), silhouette inchangée. Aperçus sur <strong>fond neutre chaud</strong>, sans damier ni autre arrière-plan.
Les PNG livrés (<code>renders/cafe_spinda_revisite_v7/salles/*_sans_magenta.png</code>) restent à fond transparent.
Accueil : <strong>escalier nord au centre</strong> → café (+1), <strong>escalier sud au centre</strong> → casino (−1) ;
casino ↔ salon des jeux (−1), café ↔ salon haut (+1). Transitions indépendantes — warps PMDO non testés.</p>
<div id="app"></div>
<script>
const D=__DATA__;const app=document.getElementById('app');
[[1,'Étage +1'],[0,'Rez-de-chaussée'],[-1,'Sous-sol −1']].forEach(([lv,name])=>{
 const sec=document.createElement('section');sec.className='floor';sec.innerHTML='<h2>'+name+'</h2>';
 const row=document.createElement('div');row.className='row';
 D.rooms.filter(r=>r.level===lv).forEach(r=>{const f=document.createElement('figure');
  f.innerHTML='<img src="'+r.uri+'"><figcaption><strong>'+r.title+'</strong><br><small>frange recolorée : '+r.frange_recoloree_px+' px</small></figcaption>';row.append(f);});
 sec.append(row);app.append(sec);});
</script></html>
"""

if __name__ == '__main__':
    main()
