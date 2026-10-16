"""Mutations des sorties ECE1 : chacune doit faire échouer au moins un test.
.venv/bin/python source/entree_crevasse_enneigee_sud_nord_v1/mutations.py      (après build.py)
Les PNG des rendus ne sont pas versionnés dans ce dépôt (.gitignore) : chaque fichier touché est sauvegardé avant la
mutation puis restauré octet pour octet (pas de git checkout).
"""
from pathlib import Path
import json, re, shutil, subprocess, sys, tempfile, zipfile, io

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/entree_crevasse_enneigee_sud_nord_v1'
S = R / '.cache/entree_crevasse_enneigee_sud_nord_v1/entree_crevasse_enneigee_sud_nord'
P = 'ECE1'
TOUCHED = []


def keep(p):
    TOUCHED.append(Path(p))
    return Path(p)


def img(p): return np.array(Image.open(p).convert('RGBA'))
def save(p, a): Image.fromarray(a).save(keep(p))
def F(nom, t=None):
    hits = list(O.glob(f'calques/{P}_??_{nom}.png') if t is None else O.glob(f'animation/{nom}/{P}_??_{nom}_f{t:02d}.png'))
    assert len(hits) == 1, (nom, t, hits); return hits[0]
def mask(k): return np.array(Image.open(O / f'masques/{P}_masque_{k}.png')) > 0
def man(f):
    p = keep(O / 'manifest.json'); d = json.loads(p.read_text()); f(d); p.write_text(json.dumps(d, indent=1, ensure_ascii=False))
def ground(f):
    M = json.loads((O / 'manifest.json').read_text()); p = keep(S / f"Data/Ground/{M['pmdo']['asset']}.rsground")
    d = json.loads(p.read_text()); f(d, M); p.write_text(json.dumps(d, separators=(',', ':')))


# ---- palette exacte du rip
def m_neige_hors_rip():
    p = F('neige'); a = img(p); ys, xs = np.nonzero(a[..., 3] == 255); a[ys[:40], xs[:40], :3] = (250, 250, 250); save(p, a)
def m_flocon_hors_rip():
    p = F('flocons', 7); a = img(p); ys, xs = np.nonzero(a[..., 3] == 255); a[ys[:6], xs[:6], :3] = (240, 240, 255); save(p, a)
def m_palette_manifeste_amputee():
    man(lambda d: d['palette_rip']['couleurs'].pop())
# ---- calques fixes et partition
def m_ombres_blanchies():
    p = F('ombres'); a = img(p); a[a[..., 3] == 255, :3] = (255, 255, 255); save(p, a)
def m_trou_dans_la_neige():
    p = F('neige'); a = img(p); ys, xs = np.nonzero(a[..., 3] == 255); a[ys[9000:9040], xs[9000:9040]] = 0; save(p, a)
def m_corniche_doublee():
    p = F('corniches'); a = img(p); f = img(F('falaises')); m = f[..., 3] == 255; ys, xs = np.nonzero(m)
    a[ys[:50], xs[:50]] = f[ys[:50], xs[:50]]; save(p, a)
def m_bouche_eclaircie():
    p = F('profondeur'); a = img(p); a[a[..., 3] == 255, :3] = (183, 183, 223); save(p, a)
def m_magenta():
    p = F('falaises'); a = img(p); ys, xs = np.nonzero(a[..., 3] == 255); a[ys[:5], xs[:5]] = (255, 0, 255, 255); save(p, a)
def m_sol_complet_retouche():
    p = F('sol_complet'); a = img(p); a[300:340, 300:340, :3] = (231, 231, 247); save(p, a)
def m_masque_neige():
    p = O / f'masques/{P}_masque_neige.png'; m = np.array(Image.open(p)); m[500:520, 100:140] = 0; Image.fromarray(m).save(keep(p))
# ---- animations
def m_eclat_fige():
    save(F('scintillements', 2), img(F('scintillements', 1)))
def m_eclat_ajoute():
    p = F('scintillements', 20); a = img(p); a[200:203, 100:103] = (255, 255, 255, 255); save(p, a)
def m_emetteur_eclat_deplace():
    man(lambda d: d['scintillements']['emetteurs'][0].__setitem__(1, d['scintillements']['emetteurs'][0][1] + 3))
def m_flocon_saute():
    p = F('flocons', 30); a = img(p); save(p, np.roll(a, 2, axis=0))
def m_flocons_liste_a_la_main():
    man(lambda d: d['flocons']['emetteurs'][5].__setitem__(0, d['flocons']['emetteurs'][5][0] + 10))
def m_pose_retouchee():
    p = O / f'poses/{P}_eclat_3.png'; a = img(p); a[0, 0] = (255, 255, 255, 255); save(p, a)
# ---- accès et Ground
def m_entree_dans_la_corniche():
    man(lambda d: d['access'].__setitem__('entry_px', [d['access']['entry_px'][0] - 72, d['access']['entry_px'][1]]))
def m_seuil_loin_de_la_bouche():
    man(lambda d: d['access'].__setitem__('threshold_px', [d['access']['threshold_px'][0], d['access']['threshold_px'][1] + 64]))
def m_falaise_ouverte():
    def f(d, M):
        for x in range(len(d['Object']['obstacles'])):
            d['Object']['obstacles'][x][10]['Tags'] = 0
    ground(f)
def m_chemin_coupe():
    def f(d, M):
        y = (M['access']['entry_px'][1] // 8) - 12
        for x in range(len(d['Object']['obstacles'])):
            d['Object']['obstacles'][x][y]['Tags'] = 1
    ground(f)
def m_warp_ajoute():
    def f(d, M):
        mk = dict(d['Object']['Entities'][0]['Markers'][0]); mk['EntName'] = 'warp_donjon'
        d['Object']['Entities'][0]['Markers'].append(mk)
    ground(f)
def m_seuil_retire():
    ground(lambda d, M: d['Object']['Entities'][0].__setitem__('Markers', d['Object']['Entities'][0]['Markers'][:1]))
# ---- manifeste, bruts, ORA, préfixe
def m_fidelite(): man(lambda d: d['fidelite_rip']['brut']['roche'].__setitem__('distance', 5.0))
def m_runtime(): man(lambda d: d['pmdo'].__setitem__('runtime_tested', True))
def m_art_approuve(): man(lambda d: d.__setitem__('art_approved', True))
def m_echecs_caches(): man(lambda d: d['sol_complet'].__setitem__('editions_generateur_ecartees', []))
def m_brut():
    p = HERE / 'bruts/decor.png'; a = np.array(Image.open(p).convert('RGB')); a[0, 0] = (1, 2, 3); Image.fromarray(a).save(keep(p))
def m_ora():
    p = keep(O / f'{P}_entree_crevasse_enneigee_calques.ora'); items = {}
    with zipfile.ZipFile(p) as z:
        for n in z.namelist():
            items[n] = z.read(n)
    a = np.array(Image.open(io.BytesIO(items['mergedimage.png'])).convert('RGBA')); a[300, 380] = (0, 0, 0, 255)
    b = io.BytesIO(); Image.fromarray(a).save(b, format='PNG'); items['mergedimage.png'] = b.getvalue()
    with zipfile.ZipFile(p, 'w') as z:
        for n, v in items.items():
            z.writestr(n, v)
def m_prefixe_repris():
    d = R / 'source/_mutation_ece1_tmp'; d.mkdir(exist_ok=True); (d / 'build.py').write_text("PFX = 'ECE1'\n"); TOUCHED.append(d)


def run_tests():
    out = subprocess.run([sys.executable, '-m', 'unittest', 'source.entree_crevasse_enneigee_sud_nord_v1.test_build'],
                         cwd=R, capture_output=True, text=True).stderr
    return sorted(set(re.findall(r'(?:FAIL|ERROR): (test_\w+)', out)))


def main():
    assert not run_tests(), 'les tests doivent passer avant les mutations'
    res = {}
    for name, f in [(k, v) for k, v in list(globals().items()) if k.startswith('m_')]:
        backup = Path(tempfile.mkdtemp()); saved = {}
        TOUCHED.clear()
        cands = [O / 'manifest.json', HERE / 'bruts/decor.png', O / f'{P}_entree_crevasse_enneigee_calques.ora']
        cands += list(O.glob('calques/*.png')) + list(O.glob('masques/*.png')) + list(O.glob('animation/*/*.png'))
        cands += list(O.glob('poses/*.png')) + list(S.glob('Data/Ground/*.rsground'))
        for i, c in enumerate(cands):
            dst = backup / f'{i:05d}'; shutil.copy2(c, dst); saved[c] = dst
        try:
            f()
            res[name] = run_tests()
        finally:
            for c in TOUCHED:
                if c in saved:
                    shutil.copy2(saved[c], c)
                elif c.is_dir():
                    shutil.rmtree(c)
            shutil.rmtree(backup)
    for k, v in res.items():
        print(('OK  ' if v else 'RATE'), k, v)
    assert not run_tests(), 'restauration incomplète'
    print(f'{sum(bool(v) for v in res.values())}/{len(res)} mutations détectées ; tests de nouveau verts après restauration')
    sys.exit(0 if all(res.values()) else 1)


if __name__ == '__main__':
    main()
