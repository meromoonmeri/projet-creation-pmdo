"""Mutations des sorties FGV1 : chacune doit faire échouer au moins un test.
.venv/bin/python source/fin_grotte_vasques_v1/mutations.py      (après build.py)
Les PNG des rendus ne sont pas versionnés dans ce dépôt (.gitignore) : chaque fichier touché est sauvegardé avant la
mutation puis restauré octet pour octet (pas de git checkout).
"""
from pathlib import Path
import json, re, shutil, subprocess, sys, tempfile, zipfile, io

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/fin_grotte_vasques_v1'
S = R / '.cache/fin_grotte_vasques_v1/fin_grotte_vasques'
P = 'FGV1'
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


# ---- animation de palette (reflets)
def m_reflet_hors_rip():
    p = F('reflets_vasques', 5); a = img(p); ys, xs = np.nonzero(a[..., 3] == 255); a[ys[:20], xs[:20], :3] = (40, 250, 250); save(p, a)
def m_reflet_pic_fige():
    save(F('reflets_vasques', 6), img(F('reflets_vasques', 0)))          # loi cassée : le pic copie la phase 0
def m_reflet_dephase():
    p = F('reflets_vasques', 9); a = img(p); m = a[..., 3] == 255; ys, xs = np.nonzero(m)
    a[ys[::2], xs[::2]] = np.roll(a[ys[::2], xs[::2]], 1, axis=0); save(p, a)
def m_emplacements_permutes():
    man(lambda d: d['reflets_vasques'].__setitem__('emplacements', d['reflets_vasques']['emplacements'][::-1]))
def m_cadence_entree():
    man(lambda d: d['reflets_vasques'].__setitem__('frame_length_ticks', 2))   # cadence de D56P12A au lieu de D56P41A
# ---- eau et vasques
def m_eau_hors_palette():
    p = F('vasques'); a = img(p); ys, xs = np.nonzero(mask('eau')); a[ys[:30], xs[:30], :3] = (20, 160, 150); save(p, a)
def m_eau_palette_entree():
    p = F('vasques'); a = img(p); ys, xs = np.nonzero(mask('eau')); a[ys[:30], xs[:30], :3] = (47, 223, 191); save(p, a)
# ---- bulles
def m_bulle_sur_sable():
    p = F('bulles_source', 3); a = img(p); a[400:404, 380:384] = (199, 247, 231, 255); save(p, a)
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
# ---- fin : marqueurs, marches, Ground
def m_boss_contre_paroi():
    man(lambda d: d['access'].__setitem__('boss_px', [d['access']['boss_px'][0] - 120, d['access']['boss_px'][1]]))
def m_objectif_hors_colonne():
    man(lambda d: d['access'].__setitem__('objective_px', [d['access']['objective_px'][0] + 160, d['access']['objective_px'][1]]))
def m_warp_ajoute():
    def f(d, M):
        mk = dict(d['Object']['Entities'][0]['Markers'][0]); mk['EntName'] = 'donjon_seuil'
        d['Object']['Entities'][0]['Markers'].append(mk)
    ground(f)
def m_marches_bloquees():
    def f(d, M):
        ys = np.nonzero(mask('ombres').sum(1) > 120)[0]; y = int(np.median(ys)) // 8
        for x in range(len(d['Object']['obstacles'])):
            d['Object']['obstacles'][x][y]['Tags'] = 1
            d['Object']['obstacles'][x][y + 1]['Tags'] = 1
    ground(f)
def m_marche_peinte_en_paroi():
    p = O / f'masques/{P}_masque_ombres.png'; m = np.array(Image.open(p)); m[:] = 0; Image.fromarray(m).save(keep(p))
# ---- manifeste, bruts, ORA, préfixe
def m_fidelite(): man(lambda d: d['fidelite_rip']['brut']['eau'].__setitem__('distance', 20.0))
def m_runtime(): man(lambda d: d['pmdo'].__setitem__('runtime_tested', True))
def m_brut():
    p = HERE / 'bruts/decor.png'; a = np.array(Image.open(p).convert('RGB')); a[0, 0] = (1, 2, 3); Image.fromarray(a).save(keep(p))
def m_ora():
    p = keep(O / f'{P}_fin_grotte_vasques_calques.ora'); items = {}
    with zipfile.ZipFile(p) as z:
        for n in z.namelist():
            items[n] = z.read(n)
    a = np.array(Image.open(io.BytesIO(items['mergedimage.png'])).convert('RGBA')); a[300, 380] = (0, 0, 0, 255)
    b = io.BytesIO(); Image.fromarray(a).save(b, format='PNG'); items['mergedimage.png'] = b.getvalue()
    with zipfile.ZipFile(p, 'w') as z:
        for n, v in items.items():
            z.writestr(n, v)
def m_prefixe_repris():
    d = R / 'source/_mutation_fgv1_tmp'; d.mkdir(exist_ok=True); (d / 'build.py').write_text("PFX = 'FGV1'\n"); TOUCHED.append(d)


def run_tests():
    out = subprocess.run([sys.executable, '-m', 'unittest', 'source.fin_grotte_vasques_v1.test_build'],
                         cwd=R, capture_output=True, text=True).stderr
    return sorted(set(re.findall(r'(?:FAIL|ERROR): (test_\w+)', out)))


def main():
    assert not run_tests(), 'les tests doivent passer avant les mutations'
    res = {}
    for name, f in [(k, v) for k, v in list(globals().items()) if k.startswith('m_')]:
        backup = Path(tempfile.mkdtemp()); saved = {}
        TOUCHED.clear()
        cands = [O / 'manifest.json', HERE / 'bruts/decor.png', O / f'{P}_fin_grotte_vasques_calques.ora']
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
