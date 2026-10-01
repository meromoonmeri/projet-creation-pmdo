"""Tests — étude des animations canoniques eau / magma (PMD Ciel) et de leur portage PMDO.
.venv/bin/python -m unittest source.etude_animations_canoniques_sky_v1.test_etude -v      (après etude.py)
Tout est recalculé depuis les fichiers de la ROM et du port en cache : PAS un test du moteur PMDO.
"""
from pathlib import Path
from math import gcd
import hashlib, importlib.util, json, re, unittest
import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
_sp = importlib.util.spec_from_file_location('etude', HERE / 'etude.py')
E = importlib.util.module_from_spec(_sp); _sp.loader.exec_module(E)
REP = json.loads((E.OUT / 'rapport.json').read_text())
MAPBG, PORT = E.CACHE / 'pmd-sky/files/MAP_BG', E.CACHE / 'port'
STUDY = {}


def get(name):
    if name not in STUDY:
        m = E.SkyMap(MAPBG, name); bank = dict((n, b) for n, _, b in E.MAPS)[name]
        STUDY[name] = (m, *E.study(m, PORT, bank))
    return STUDY[name]


def preview_dedup(m, tt):
    """Ce que fait le convertisseur du port : aperçu skytemple à pas égaux (to_pil, pal_ani=True), puis, dans
    chaque case, frames uniques dans l'ordre de première apparition, FrameLength 10 (60 si une seule)."""
    n = len(m.bpl.animation_palette) if m.specs else len(m.P)
    imgs = []
    for s in range(n):
        pal = m.palette_table(0).copy().reshape(16, 16, 3)
        for i, nf, d, first in m.specs:
            pal[i, 1:] = np.array(m.bpl.animation_palette[first + s % nf], 'uint8').reshape(15, 3)
        imgs.append(tt.cells(pal.reshape(-1, 3)[m.idx[s % len(m.P)]]))
    S = np.array(imgs); out = {}
    for y in range(S.shape[1]):
        for x in range(S.shape[2]):
            u = list(dict.fromkeys(S[:, y, x].tolist()))
            out[y, x] = (10 if len(u) > 1 else 60, u)
    return out


class Etude(unittest.TestCase):
    def test_sources_figees(self):
        s = REP['sources']
        self.assertEqual((s['rom']['commit'], s['port']['commit'], s['moteur']['commit']), (E.PRET_SHA, E.PORT_SHA, E.RE_SHA))
        for f, h in s['port']['fichiers_sha256'].items():
            self.assertEqual(E.sha(PORT / f), h, f)
        for name, rep in REP['cartes'].items():
            for f, h in rep['fichiers_rom_sha256'].items():
                self.assertEqual(E.sha(MAPBG / f), h, f)
        self.assertIn('totalTick / FrameToTick(FrameLength) % Frames.Count', s['moteur']['regle'])
        self.assertIn('pas une carte de la serie', REP['nature'])

    def test_rapport_egal_au_recalcul(self):
        for name, role, _ in E.MAPS:
            rep = dict(get(name)[1]); rep['role'] = role
            self.assertEqual(REP['cartes'][name], json.loads(json.dumps(rep)), name)

    def test_inventaire(self):
        inv = json.loads((E.OUT / 'inventaire_animations_sky.json').read_text())
        self.assertEqual(inv, json.loads(json.dumps(E.inventory(MAPBG))))
        i = REP['inventaire']; self.assertEqual(i['cartes_animees'], len(inv))
        self.assertEqual(i['avec_palette_animee'], 110)
        self.assertEqual(i['teintes'], {'eau': 48, 'magma': 8, 'autre': 54})
        row = {r['carte']: r for r in inv}
        self.assertEqual(row['s01p02a']['palettes_animees'], [{'palette': 7, 'crans': 10, 'duree': 10}, {'palette': 8, 'crans': 10, 'duree': 10}])
        self.assertEqual(row['s01p02a']['bpa'], [{'slot': 1, 'tuiles': 88, 'durees': [12, 12, 12, 12]}])
        self.assertEqual(row['d41p41a']['teinte_palettes'], 'magma'); self.assertEqual(row['v03p08a']['teinte_palettes'], 'magma')

    def test_rendu_de_verite(self):
        for name, rep in REP['cartes'].items():
            m = get(name)[0]
            ref = np.array(Image.open(PORT / f'{name}.png').convert('RGB'))
            self.assertTrue((m.frame(0) == ref).all(), name)                            # = aperçu publié par le port
            self.assertTrue(rep['rendu_t0_egal_apercu_port'])
            self.assertTrue((m.frame(m.loop) == m.frame(0)).all(), name)                # boucle fermée
            for _, n, d, _ in m.specs:
                self.assertEqual(m.loop % (n * d), 0)
            self.assertEqual(rep['boucle_ticks'], m.loop)
            self.assertTrue(np.array_equal(np.array(Image.open(E.OUT / 'cartes' / f'{name}_t000.png').convert('RGB')), m.frame(0)))
            ms = [int(f.info['duration']) for f in _frames(E.OUT / 'cartes' / f'{name}_vrai_{m.loop}ticks.webp')]
            self.assertEqual(sum(ms), round(m.loop * 1000 / 60))                        # WebP à la vraie vitesse

    def test_s01p02a_mer_par_rotation_fleurs_par_bpa(self):
        m, rep = get('s01p02a')[:2]
        ap = [np.array(m.bpl.animation_palette[k], int).reshape(15, 3) for k in range(10)]
        for k in range(1, 10):                                   # palette 7 : les entrées 1 à 10 tournent d'un cran
            self.assertTrue((ap[k][1:10] == ap[k - 1][0:9]).all() and (ap[k][0] == ap[k - 1][9]).all(), k)
        self.assertEqual(rep['bpa']['crans_distincts_sur_la_carte'], [0, 1, 2, 3])
        # Case par case, des crans se répètent (0-1-0-2 : le cran 2 redonne le cran 0) : la déduplication les casse.
        self.assertEqual(rep['pistes_exactes']['4 x 12']['motifs'], {'0-1-0-2': 185, '0-1-2-1': 27, '0-1-0-0': 23, '0-1-2-3': 11})
        self.assertEqual(rep['pixels_animes']['recouvrement'], 0)                      # mer et fleurs disjointes
        bm, pm = m.masks(); ys, _ = np.nonzero(pm); yb, _ = np.nonzero(bm)
        self.assertGreater(ys.min(), yb.max())                                          # mer en bas, fleurs au-dessus
        self.assertEqual(rep['pistes_exactes'], {'10 x 10': rep['pistes_exactes']['10 x 10'], '4 x 12': rep['pistes_exactes']['4 x 12']})

    def test_pistes_exactes_rejouent_la_rom(self):
        for name in REP['cartes']:
            m, rep, tt, exact = get(name)[:4]
            ch, S = E.states(m, tt)
            t = np.arange(0, 2 * m.loop)
            truth = S[np.searchsorted(ch, t % m.loop, side='right') - 1]
            for (y, x), tr in exact.items():
                self.assertTrue((E.play(tr, t) == truth[:, y, x]).all(), (name, y, x))
            for k, v in rep['pistes_exactes'].items():
                n, fl = map(int, k.split(' x '))
                self.assertEqual(sum(1 for tr in exact.values() if len(tr[1]) == n and tr[0] == fl and n > 1), v['cases'], (name, k))

    def test_diagnostic_du_port(self):
        """Les pistes du port sont exactement l'aperçu à pas égaux dédoublonné : c'est la cause des écarts."""
        for name in REP['cartes']:
            m, rep, tt, exact, port = get(name)[:5]
            self.assertEqual(preview_dedup(m, tt), port, name)
        d = REP['cartes']
        self.assertEqual(d['s01p02a']['port']['cases_fausses'], 278)
        self.assertEqual(d['s01p02a']['pistes_exactes']['10 x 10']['temps_faux_port'], 0.029)
        self.assertEqual(d['s01p02a']['pistes_exactes']['4 x 12']['temps_faux_port'], 0.655)
        self.assertGreater(d['d41p41a']['port']['temps_faux_moyen_cases_animees'], 0.8)
        self.assertEqual(d['d41p41a']['port']['framelength_port'], [10])

    def test_audit_recalcule(self):
        for name, rep in REP['cartes'].items():
            m, _, tt, exact, port, wrong = get(name)[:6]
            anim = [k for k, tr in exact.items() if len(tr[1]) > 1]
            w = []
            for k in anim:
                (f1, r1), (f2, r2) = exact[k], port[k]
                per = np.lcm(f1 * len(r1), f2 * len(r2)); tp = np.arange(0, per, gcd(f1, f2))
                w.append(float((E.play(port[k], tp) != E.play(exact[k], tp)).mean()))
            self.assertAlmostEqual(round(float(np.mean(w)), 3), rep['port']['temps_faux_moyen_cases_animees'])
            self.assertEqual(sum(1 for v in w if v > 0), rep['port']['cases_fausses'])
            self.assertTrue(all(wrong[k] == 0 for k in exact if len(exact[k][1]) == 1))       # cases fixes : justes

    def test_apercu(self):
        s = (R / f'apercu_{E.LOT}.html').read_text()
        data = json.loads(s[s.index('const DATA=') + 11:s.index(';\nlet M,')])
        self.assertEqual([d['name'] for d in data], E.VIEWER)
        for d in data:
            m, _, tt, exact, port = get(d['name'])[:5]
            used = sorted({i for tr in list(exact.values()) + list(port.values()) for i in tr[1]})
            for (y, x), tr in list(exact.items())[::97]:
                self.assertEqual(d['exact'][y][x], [tr[0], [used.index(i) for i in tr[1]]])
                self.assertEqual(d['port'][y][x], [port[y, x][0], [used.index(i) for i in port[y, x][1]]])
        self.assertIn('totalTick / FrameLength', s)


def _frames(p):
    from PIL import ImageSequence
    im = Image.open(p)
    return [f.copy() for f in ImageSequence.Iterator(im)]


if __name__ == '__main__':
    unittest.main()
