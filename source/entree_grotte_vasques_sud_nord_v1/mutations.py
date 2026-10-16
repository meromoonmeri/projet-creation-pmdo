"""Mutations des sorties EGV1 : chacune doit faire échouer au moins un test.
.venv/bin/python source/entree_grotte_vasques_sud_nord_v1/mutations.py      (après build.py)
Les PNG des rendus ne sont pas versionnés dans ce dépôt (.gitignore) : chaque fichier touché est sauvegardé avant la
mutation puis restauré octet pour octet (pas de git checkout).
"""
from pathlib import Path
import json, re, shutil, subprocess, sys, tempfile, zipfile, io

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/entree_grotte_vasques_sud_nord_v1'
S = R / '.cache/entree_grotte_vasques_sud_nord_v1/entree_grotte_vasques_sud_nord'
P = 'EGV1'
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


# ---- animation de palette (reflets)
def m_reflet_hors_rip():
    p = F('reflets_vasques', 5); a = img(p); ys, xs = np.nonzero(a[..., 3] == 255); a[ys[:20], xs[:20], :3] = (40, 250, 250); save(p, a)
def m_reflet_pic_fige():
    save(F('reflets_vasques', 7), img(F('reflets_vasques', 0)))          # loi cassée : le pic copie la phase 0
def m_reflet_dephase():
    p = F('reflets_vasques', 9); a = img(p); m = a[..., 3] == 255; ys, xs = np.nonzero(m)
    a[ys[::2], xs[::2]] = np.roll(a[ys[::2], xs[::2]], 1, axis=0); save(p, a)
def m_emplacements_permutes():
    man(lambda d: d['reflets_vasques'].__setitem__('emplacements', d['reflets_vasques']['emplacements'][::-1]))
# ---- eau et vasques
def m_eau_hors_palette():
    p = F('vasques'); a = img(p); ys, xs = np.nonzero(mask('eau')); a[ys[:30], xs[:30], :3] = (20, 160, 150); save(p, a)
def m_eau_devant_entree():
    p = O / f'masques/{P}_masque_eau.png'; m = np.array(Image.open(p)); t = json.loads((O / 'manifest.json').read_text())['access']['threshold_px']
    m[t[1] + 20:t[1] + 28, t[0]:t[0] + 16] = 255; Image.fromarray(m).save(keep(p))
# ---- bulles
def m_bulle_sur_sable():
    p = F('bulles_source', 3); a = img(p); a[400:404, 380:384] = (207, 247, 239, 255); save(p, a)
def m_bulle_phase_dupliquee():
    save(F('bulles_source', 11), img(F('bulles_source', 10)))
def m_emetteur_deplace():
    man(lambda d: d['bulles_source']['emetteurs'][0].__setitem__(0, d['bulles_source']['emetteurs'][0][0] + 6))
# ---- calques fixes
def m_ombres_claires():
    p = F('ombres'); a = img(p); s = img(F('sol')); c = s[s[..., 3] == 255][:, :3].mean(0).round().astype('uint8')
    a[a[..., 3] == 255, :3] = c; save(p, a)
def m_trou_dans_le_sol():
    p = F('sol'); a = img(p); ys, xs = np.nonzero(a[..., 3] == 255); a[ys[5000:5040], xs[5000:5040]] = 0; save(p, a)
def m_magenta():
    p = F('parois'); a = img(p); ys, xs = np.nonzero(a[..., 3] == 255); a[ys[:5], xs[:5]] = (255, 0, 255, 255); save(p, a)
def m_sol_complet_jaune():
    p = F('sol_complet'); a = img(p); a[..., 0] = np.minimum(255, a[..., 0].astype(int) + 31); a[..., 2] = a[..., 2] // 2; save(p, a)
# ---- manifeste, bruts, Ground, ORA, préfixe
def m_fidelite(): man(lambda d: d['fidelite_rip']['brut']['eau'].__setitem__('distance', 20.0))
def m_runtime(): man(lambda d: d['pmdo'].__setitem__('runtime_tested', True))
def m_brut():
    p = HERE / 'bruts/decor.png'; a = np.array(Image.open(p).convert('RGB')); a[0, 0] = (1, 2, 3); Image.fromarray(a).save(keep(p))
def m_seuil_bloque():
    M = json.loads((O / 'manifest.json').read_text()); p = keep(S / f"Data/Ground/{M['pmdo']['asset']}.rsground")
    d = json.loads(p.read_text()); tx, ty = M['access']['threshold_px']; d['Object']['obstacles'][tx // 8][ty // 8]['Tags'] = 1
    d['Object']['obstacles'][0][0]['Tags'] = 0; p.write_text(json.dumps(d, separators=(',', ':')))
def m_ora():
    p = keep(O / f'{P}_entree_grotte_vasques_calques.ora'); items = {}
    with zipfile.ZipFile(p) as z:
        for n in z.namelist():
            items[n] = z.read(n)
    a = np.array(Image.open(io.BytesIO(items['mergedimage.png'])).convert('RGBA')); a[300, 380] = (0, 0, 0, 255)
    b = io.BytesIO(); Image.fromarray(a).save(b, format='PNG'); items['mergedimage.png'] = b.getvalue()
    with zipfile.ZipFile(p, 'w') as z:
        for n, v in items.items():
            z.writestr(n, v)
def m_prefixe_repris():
    d = R / 'source/_mutation_egv1_tmp'; d.mkdir(exist_ok=True); (d / 'build.py').write_text("PFX = 'EGV1'\n"); TOUCHED.append(d)


def run_tests():
    out = subprocess.run([sys.executable, '-m', 'unittest', 'source.entree_grotte_vasques_sud_nord_v1.test_build'],
                         cwd=R, capture_output=True, text=True).stderr
    return sorted(set(re.findall(r'(?:FAIL|ERROR): (test_\w+)', out)))


def main():
    assert not run_tests(), 'les tests doivent passer avant les mutations'
    res = {}
    for name, f in [(k, v) for k, v in list(globals().items()) if k.startswith('m_')]:
        backup = Path(tempfile.mkdtemp()); saved = {}
        TOUCHED.clear()
        # sauvegarde paresseuse : on copie tout ce qui peut être touché par cette mutation avant de l'appeler
        cands = [O / 'manifest.json', HERE / 'bruts/decor.png', O / f'{P}_entree_grotte_vasques_calques.ora']
        cands += list(O.glob('calques/*.png')) + list(O.glob('masques/*.png')) + list(O.glob('animation/*/*.png'))
        cands += list(S.glob('Data/Ground/*.rsground'))
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
