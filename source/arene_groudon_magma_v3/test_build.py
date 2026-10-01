"""Tests dédiés — Arène de Groudon magma V2 (AGM3) : signe au sol, colonnes géantes, 4:3.
.venv/bin/python -m unittest source.arene_groudon_magma_v3.test_build -v
Contrôles d'images, de formats, de cadence, de mouvement, de grille et d'accès : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, unittest, zipfile
import numpy as np
from scipy import ndimage
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/arene_groudon_magma_v3'
S = R / '.cache/arene_groudon_magma_v3/arene_groudon_magma_v3'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
ANIM = ('magma', 'symbole_groudon', 'braises', 'colonnes')
PH = {k: M[k]['phases'] for k in ANIM}
TK = {k: M[k]['frame_length_ticks'] for k in ANIM}


def load(p):
    return np.array(Image.open(p).convert('RGBA'))


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


def name_of(p):
    return Path(p).stem.split('_', 2)[2].replace('_fNN', '')


def expand(p):
    if 'fNN' in p:
        return [load(O / p.replace('fNN', f'f{t:02d}')) for t in range(PH[name_of(p)])]
    return [load(O / p)]


ORDER = M['layer_order_bottom_to_top']
NAMES = [name_of(p) for p in ORDER]
STACK = {n: expand(p) for n, p in zip(NAMES, ORDER)}
MG = loadmod('magma_visqueux', R / 'source/magma_visqueux/magma.py')
CG = loadmod('colonnes_generees', HERE / 'colonnes_generees.py')
CPAL = {tuple(int(v) for v in c) for c in CG.palette()[0]}
PAL = {tuple(c) for c in MG.PAL}
MASK = {k: np.array(Image.open(O / f'masques/AGM3_masque_{k}.png')) > 0 for k in ('lava', 'floor', 'rim', 'spires', 'symbole')}


def alpha(a):
    return a[..., 3] == 255


def colors(a):
    return {tuple(int(v) for v in c) for c in np.unique(a[alpha(a)][:, :3], axis=0)}


def land():
    m = np.zeros((H, W), bool)
    for n in ('sol_arene', 'rebord', 'pitons'):
        m |= alpha(STACK[n][0])
    return m


def best_shift(a, b, m, shifts):
    """Décalage vertical de a qui ressemble le plus à b sur m (part de pixels identiques)."""
    score = {s: float((np.roll(a, s, axis=0)[m] == b[m]).all(1).mean()) for s in shifts}
    return max(score, key=score.get), score


class Build(unittest.TestCase):
    def test_bruts_references(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        self.assertEqual(M['raw_inputs'][0]['images'], ['source/arene_groudon_magma_v1/bruts/decor_magenta.png'])   # édition du brut AGM1
        e = M['raw_inputs'][0]['ecart_hors_signe']
        self.assertLess(e['somme_rvb_moyenne'], 20); self.assertLess(e['part_pixels_ecart_60'], 0.01)            # un seul changement
        b = loadmod('agm2_build', R / 'source/arene_groudon_magma_v2/build.py')
        v1 = np.array(Image.open(R / 'source/arene_groudon_magma_v1/bruts/decor_magenta.png').convert('RGB')).astype(int)
        self.assertTrue((np.array(Image.open(R / 'source/arene_groudon_magma_v2/bruts/sol_complet.png').convert('RGB')) == b.make_sol(v1)).all())
        f = M['fidelite']; self.assertEqual(f['seuil'], 35); self.assertLess(f['distance'], 35)
        fm = M['fidelite_magma']; self.assertEqual(fm['seuil'], 12); self.assertLess(fm['distance'], 12)
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])
        for v in ('v1', 'v2'):
            self.assertTrue((R / f'renders/arene_groudon_magma_{v}/manifest.json').exists())                    # AGM1 et AGM2 gardées
        used = [r for r in M['raw_inputs'] if 'colonne' in r['file']]
        self.assertEqual([r['utilise'] for r in used], [False, True])                                         # v0 rejeté, gardé en trace
        self.assertEqual(Path(used[1]['file']).resolve(), CG.RAW.resolve())
        for r in used:
            self.assertEqual(r['images'], ['source/arene_groudon_magma_v3/reference/Dark_Crater_Pit_lave_decoupe_x2.png'])
            self.assertEqual(list(Image.open(R / r['file']).size), r['size'])

    def test_calques_ordre_tailles_alpha(self):
        self.assertEqual(NAMES, ['magma', 'sol_complet', 'sol_arene', 'rebord', 'pitons', 'symbole_groudon', 'braises', 'colonnes'])
        files = [Path(p).name for p in ORDER]
        self.assertTrue(all(n.startswith('AGM3_') for n in files)); self.assertEqual(len(files), len(set(files)))
        self.assertEqual((W, H, W * 3), (768, 576, H * 4))                                  # 4:3
        for frames in STACK.values():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W)); self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255})
                v = a[alpha(a)].astype(int)                                                  # plus de magenta ni de vert
                self.assertEqual(int(((v[:, 0] > 200) & (v[:, 2] > 200) & (v[:, 1] < 90)).sum()), 0)
                self.assertEqual(int(((v[:, 1] > 160) & (v[:, 1] > 1.8 * v[:, 0]) & (v[:, 1] > 1.8 * v[:, 2])).sum()), 0)

    def test_couverture_complete(self):
        mg, sol = alpha(STACK['magma'][0]), alpha(STACK['sol_complet'][0])
        self.assertTrue((mg | sol).all()); self.assertFalse((mg & sol).any())
        self.assertTrue((mg == MASK['lava']).all())

    def test_magma_visqueux(self):
        fr = STACK['magma']; m = alpha(fr[0]); vis = MASK['lava'] & ~land()
        self.assertEqual((PH['magma'], TK['magma']), (32, 15))
        self.assertTrue(min(m[0].mean(), m[-1, :300].mean(), m[:, 0].mean(), m[:, -1].mean()) > 0.75)   # lac autour de l'arène
        for a in fr:
            self.assertTrue((alpha(a) == m).all()); self.assertTrue(colors(a) <= PAL)
        ch = [float((fr[t][vis] != fr[(t + 1) % 32][vis]).any(1).mean()) for t in range(32)]
        self.assertGreater(min(ch), 0.2)                                                     # ça bouge à chaque phase
        self.assertLess(max(ch) - min(ch), 0.1)                                              # boucle fermée : pas de saut 31 -> 0
        core = vis & (ndimage.distance_transform_edt(vis) > 8)
        wins = [best_shift(fr[t], fr[(t + 1) % 32], core, range(-6, 7))[0] for t in range(0, 32, 4)]
        self.assertTrue(all(1 <= w <= 5 for w in wins), wins)                                # dérive lente vers le sud (3 px)
        dark = [float(np.isin(fr[t][vis][:, 0], [70, 120]).mean()) for t in range(0, 32, 8)]
        self.assertTrue(all(0.03 < d < 0.3 for d in dark), dark)                             # plaques de croûte
        rip = {tuple(c) for c in MG.RIP_RAMP}
        self.assertGreater(float(np.mean([tuple(c) in rip for c in fr[0][vis][::7, :3].tolist()])), 0.6)

    def test_symbole_groudon_pulse_sur_le_sol(self):
        fr = STACK['symbole_groudon']; floor = MASK['floor']; sign = MASK['symbole']; walk = alpha(STACK['sol_arene'][0])
        self.assertEqual((PH['symbole_groudon'], TK['symbole_groudon']), (12, 10))
        ys, xs = np.nonzero(sign)
        self.assertLess(abs(xs.mean() - W / 2), 30); self.assertLess(abs(ys.mean() - H / 2), 90)   # au centre de l'arène
        self.assertGreater(xs.max() - xs.min(), 220)                                             # plus grand que sur le dais d'AGM1 (~135)
        self.assertGreater(int(sign.sum()), 3000); self.assertFalse((sign & ~floor).any())
        self.assertTrue((walk[sign]).all())                                                      # à même le sol : praticable
        self.assertFalse(any(Path(p).stem.endswith('dais') for p in ORDER))                     # plus d'estrade
        ramp = [tuple(v) for v in M['symbole_groudon']['rampe']]
        lum = lambda a: float(a[sign][:, :3].astype(float).mean())
        for a in fr:
            self.assertTrue((alpha(a)[sign]).all()); self.assertFalse((alpha(a) & ~floor).any())
            self.assertTrue(colors(a) <= set(ramp))
        for k in range(6):
            self.assertTrue((fr[k] == fr[11 - k]).all())                                         # pulsation symétrique
        L = [lum(fr[k]) for k in range(6)]
        self.assertTrue(all(L[k] < L[k + 1] for k in range(5)), L)                               # monte puis redescend
        halo = [int((alpha(a) & ~sign).sum()) for a in fr]
        self.assertEqual(halo[0], 0); self.assertGreater(halo[5], halo[3]); self.assertGreater(halo[3], 300)   # halo qui s'étend

    def test_colonnes_generees(self):
        fr = STACK['colonnes']; cols = M['colonnes']['colonnes']
        self.assertEqual((PH['colonnes'], TK['colonnes']), (48, 5)); self.assertEqual(len(cols), 4)
        vis = MASK['lava'] & ~land()
        px = np.nonzero((MASK['floor'] | MASK['rim']).any(0))[0]
        self.assertEqual(sorted(c['x'] < px.min() for c in cols), [False, False, True, True])      # deux de chaque côté
        self.assertEqual([c['miroir'] for c in cols], [c['x'] > W // 2 for c in cols])            # celles de droite en miroir
        for c in cols:
            self.assertTrue(vis[c['y'], c['x']]); self.assertTrue(c['x'] < px.min() or c['x'] > px.max())
            xs = slice(max(0, c['x'] - c['demi'] // 2), min(W, c['x'] + c['demi'] // 2))
            for a in fr:
                self.assertTrue(alpha(a[0, xs]).all())                                            # sort par le haut : sommet jamais visible
                self.assertTrue(alpha(a[:c['y'] - 20, c['x'] - 2:c['x'] + 3]).all())              # colonne pleine jusqu'à la bouche
            self.assertGreaterEqual(c['demi'], 28); self.assertGreater(c['y'], 180)               # plus grosse qu'AGM2 (demi 20 / 28)
            # la matière monte exactement du pas de la loi (deux poussées, jamais de recul, raccord 47 -> 0 compris)
            pr = CG.prepare(c['echelle'], c['miroir']); P = pr['P']
            core = np.zeros((H, W), bool); core[30:c['y'] - 50, c['x'] - 3:c['x'] + 4] = True
            for t in (0, 11, 23, 35, 47):
                u0, u1 = [((k - c['decalage']) % 48) / 48 for k in (t, t + 1)]
                d = (CG.shift_of(u1, P) - CG.shift_of(u0, P)) % P
                self.assertTrue(1 <= d <= 16, (c['nom'], t, d))
                w, sc = best_shift(fr[t], fr[(t + 1) % 48], core, range(-18, 1))
                self.assertEqual(w, -d, (c['nom'], t)); self.assertGreater(sc[w], 0.9)
            for t in range(0, 48, 6):                                                              # gerbe et gouttes : jamais sur la roche
                own = CG.column_phase(t, H, W, c, vis) >= 0
                self.assertFalse((own[c['y'] + 1:] & ~vis[c['y'] + 1:]).any(), (c['nom'], t))
        self.assertEqual(len({c['decalage'] for c in cols}), 4)
        self.assertEqual([list(map(int, v)) for v in CG.palette()[0]], M['colonnes']['palette'])  # palette tirée du brut généré
        self.assertEqual(len(CPAL), CG.N_COLORS)
        for a in fr:
            self.assertTrue(colors(a) <= CPAL)                                                     # rien que des tons du brut
        self.assertTrue(all((fr[t] != fr[(t + 1) % 48]).any() for t in range(48)))
        again = CG.column_frames(H, W, cols, vis)
        self.assertTrue((again[5] == fr[5]).all() and (again[40] == fr[40]).all())                 # loi du module

    def test_braises(self):
        fr = STACK['braises']; g = alpha(fr[0]); ramp = [tuple(v) for v in M['braises']['rampe']]
        self.assertFalse((g & ~(alpha(STACK['rebord'][0]) | alpha(STACK['pitons'][0]))).any()); self.assertGreater(int(g.sum()), 100)
        lum = lambda a: float(a[g][:, :3].astype(float).mean())
        for a in fr:
            self.assertTrue((alpha(a) == g).all()); self.assertTrue(colors(a) <= set(ramp))
        self.assertTrue((fr[0] == fr[5]).all() and (fr[2] == fr[3]).all())
        self.assertLess(lum(fr[0]), lum(fr[1])); self.assertLess(lum(fr[1]), lum(fr[2]))

    def test_ora_et_scene(self):
        with zipfile.ZipFile(O / 'AGM3_arene_groudon_magma_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
        sc = Image.new('RGBA', (W, H))
        for n in NAMES:
            sc.alpha_composite(Image.fromarray(STACK[n][0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/AGM3_scene_t000.png')).all())
        for k in ANIM:
            self.assertEqual(M['scene_loop_ticks'] % (PH[k] * TK[k]), 0, k)
        self.assertEqual(M['scene_loop_ticks'], 480)

    def test_acces_arene(self):
        a = M['access']; mk = a['markers']
        self.assertTrue(a['chemin_16x16']['ok']); self.assertTrue(a['chemin_boss_16x16']['ok'])
        self.assertGreater(mk['entrance'][1], H - 40)                                          # arrivée au sud
        ys, xs = np.nonzero(MASK['symbole'])
        self.assertLess(np.hypot(mk['boss'][0] + 8 - xs.mean(), mk['boss'][1] + 8 - ys.mean()), 16)   # boss au centre du Ω
        self.assertTrue(0 <= mk['heros'][1] - ys.max() < 32)                                 # héros au sud de l'anneau
        self.assertLess(abs(mk['heros'][0] + 8 - xs.mean()), 24)
        walk = alpha(STACK['sol_arene'][0])
        self.assertFalse((walk & MASK['lava']).any())
        self.assertFalse(walk[:16].any() or walk[:, :16].any() or walk[:, -16:].any())       # aucune sortie hors du sud
        free = ~(~walk).reshape(H // 8, 8, W // 8, 8).mean((1, 3)).__gt__(0.25)
        self.assertEqual(int((~free).sum()), a['blocked_cells'])
        cy, cx = int(ys.mean()) // 8, int(xs.mean()) // 8
        self.assertTrue(free[cy - 3:cy + 3, cx - 3:cx + 3].all())                              # le centre du signe est praticable
        for c in M['colonnes']['colonnes']:
            self.assertFalse(free[c['y'] // 8, c['x'] // 8])

    def test_ground_aller_retour(self):
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text()); o = doc['Object']
        self.assertEqual(doc['Version'], '0.8.12.0'); self.assertEqual(len(o['Layers']), len(NAMES) + 1)
        self.assertEqual(o['Layers'][-1]['Layer'], 4)
        nr = loadmod('native_reader', R / 'source/cote_v5_expeditions/audit_references.py')
        banks = {p.stem: nr.tiles(p)[1] for p in (S / 'Content/Tile').glob('*.tile')}
        self.assertEqual(set(banks), set(M['pmdo']['banks']))
        for li, n in enumerate(NAMES):
            frames = STACK[n]; ticks = TK.get(n, 60)
            for t in sorted({0, len(frames) // 2, len(frames) - 1}):
                out = np.zeros((H, W, 4), 'uint8')
                for x, col in enumerate(o['Layers'][li]['Tiles']):
                    for y, cell in enumerate(col):
                        for track in cell['Layers']:
                            if len(track['Frames']) > 1:
                                self.assertEqual((len(track['Frames']), track['FrameLength']), (len(frames), ticks))
                            f = track['Frames'][t % len(track['Frames'])]
                            out[y*8:y*8+8, x*8:x*8+8] = np.array(nr.straight(banks[f['Sheet']][f['TexLoc']['X'], f['TexLoc']['Y']]))
                self.assertTrue((out == frames[t]).all(), (n, t))
        self.assertEqual(sum(w['Tags'] for c in o['obstacles'] for w in c), M['access']['blocked_cells'])
        self.assertEqual([m['EntName'] for m in o['Entities'][0]['Markers']], ['entrance', 'boss', 'heros'])
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))
        self.assertNotIn('warp', (S / f"Data/Script/{M['pmdo']['namespace']}/ground/{M['pmdo']['asset']}/init.lua").read_text().replace('aucun warp', ''))


if __name__ == '__main__':
    unittest.main()
