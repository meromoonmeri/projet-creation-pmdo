"""Tests dédiés — Fin Jardin secret V1 (FJS5, 4:3 vaste).
.venv/bin/python -m unittest source.fin_jardin_secret_v1.test_build -v
Contrôles d'images, de formats, de palettes, de fidélité au rip, de cadence et de grille : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, re, unittest, zipfile
import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/fin_jardin_secret_v1'
S = R / '.cache/fin_jardin_secret_v1/fin_jardin_secret'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
NAMES = [Path(L['file']).name.replace('_fNN', '') for L in M['layers']]
STATIC = ('prairie', 'herbe', 'ombres', 'fleurs', 'rochers', 'arbres', 'haies', 'souche', 'autel', 'marches', 'fond')
REF = R / 'secretgarden.png'


def load(p):
    return np.array(Image.open(p).convert('RGBA'))


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


def expand(L):
    if L['phases'] == 1:
        return [load(O / L['file'])]
    return [load(O / L['file'].replace('fNN', f'f{t:02d}')) for t in range(L['phases'])]


STACK = [expand(L) for L in M['layers']]
BY = {re.sub(r'^FJS5_\d\d_', '', Path(n).stem): fr for n, fr in zip(NAMES, STACK)}
ORDER = list(BY)
MASK = {k: np.array(Image.open(O / f'masques/FJS5_masque_{k}.png')) > 0 for k in (*STATIC, 'embleme', 'rayon', 'praticable')}
B = loadmod('fjs5_build', HERE / 'build.py')


def alpha(a):
    return a[..., 3] == 255


def colors(frames):
    return {tuple(int(v) for v in c) for a in frames for c in np.unique(a[a[..., 3] > 0][:, :3], axis=0)}


def rip_colors():
    a = np.array(Image.open(REF).convert('RGB'))
    return {tuple(int(v) for v in c) for c in np.unique(a.reshape(-1, 3), axis=0)}


def lum(px):
    return px[..., :3].astype(float) @ [.299, .587, .114]


def base_idx():
    return np.array(Image.open(O / 'masques/FJS5_rayon_crans.png')).astype(int) // 11


def emb_idx():
    return np.array(Image.open(O / 'masques/FJS5_embleme_crans.png')).astype(int) // 11


class Build(unittest.TestCase):
    def test_raw_hashes_reference_and_coherence_with_entry(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        ref = M['reference_da']
        self.assertEqual(ref['file'], REF.name)
        self.assertEqual(hashlib.sha256(REF.read_bytes()).hexdigest(), ref['sha256'])
        self.assertEqual(M['entree_associee']['prefix'], 'EJS2')
        self.assertEqual(M['entree_associee']['reference_da'], REF.name)
        g = {x['file']: x for x in M['generation']}
        self.assertEqual(g['decor.png']['images'], [REF.name])
        self.assertEqual(g['temoin_sans_objets.png']['images'], [f'{B.LOT}/bruts/decor.png'])
        self.assertTrue(all(len(x['prompt']) > 100 for x in g.values()))
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])
        rg = M['recalage']['temoin']; self.assertLess(rg['ecart_moyen'], rg['ecart_decale_1px'])

    def test_sizes_names_alpha_no_magenta(self):
        self.assertEqual(len(NAMES), len(set(NAMES))); self.assertTrue(all(n.startswith('FJS5_') for n in NAMES))
        self.assertEqual((W, H, W % 8, H % 8), (768, 576, 0, 0)); self.assertEqual(W * 3, H * 4)
        n = M['normalization']; self.assertAlmostEqual(n['scale'], 576 / 896)
        self.assertEqual(n['scaled'][0] - sum(n['crop_x']), W)
        for name, frames in BY.items():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W))
                self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255}, name)
                v = a[a[..., 3] > 0].astype(int)
                bad = (v[:, 0] - v[:, 1] > 60) & (v[:, 2] - v[:, 1] > 60)
                self.assertEqual(int(bad.sum()), 0, name)

    def test_multicalque_full_coverage_and_order(self):
        self.assertEqual(ORDER, ['sol_complet', *STATIC, 'embleme', 'rayon', 'lucioles'])
        self.assertTrue(alpha(BY['sol_complet'][0]).all())
        fixed = [alpha(BY[k][0]) for k in STATIC] + [MASK['embleme'], MASK['rayon']]
        self.assertTrue((np.sum(fixed, 0) == 1).all())                      # calques fixes + embleme + rayon : partition exacte
        for k in STATIC:
            self.assertGreater(int(alpha(BY[k][0]).sum()), 200, k)
            self.assertTrue((alpha(BY[k][0]) == MASK[k]).all(), k)
        for a in BY['rayon']:
            self.assertTrue((alpha(a) == MASK['rayon']).all())
        for a in BY['embleme']:
            self.assertTrue((alpha(a) == MASK['embleme']).all())
        sol = BY['sol_complet'][0][..., :3].astype(float).reshape(-1, 3)
        self.assertGreater(len(colors(BY['sol_complet'])), 8)               # texture, pas un aplat
        m = sol.mean(0); self.assertGreater(m[1], m[0] + 30); self.assertGreater(m[1], m[2] + 80)   # herbe verte

    def test_palettes_et_matieres(self):
        for g, v in M['normalization']['palettes'].items():
            self.assertLessEqual(len(colors([BY[k][0] for k in v['calques']])), v['couleurs'], g)
        L = lambda k: BY[k][0][alpha(BY[k][0])][:, :3].astype(int)
        s = L('souche').mean(0); self.assertGreater(s[0], s[2] + 50)                     # souche dorée
        f = L('fond').mean(0); self.assertLess(float(lum(f)), 85); self.assertGreater(f[1], f[0] + 15)
        for k in ('prairie', 'herbe', 'ombres'):
            p = L(k).mean(0); self.assertGreater(p[1], p[0] + 20, k)
        self.assertGreater(float(lum(L('prairie')).mean()), float(lum(L('ombres')).mean()) + 25)
        self.assertLess(float(L('prairie')[:, 2].mean()), float(L('herbe')[:, 2].mean()) - 15)
        r = L('rochers').mean(0); self.assertLess(abs(r[0] - r[1]), 30); self.assertGreater(r[0], r[2] + 25)
        sg = M['segmentation_mesures']
        self.assertGreaterEqual(sg['fleurs'], 80); self.assertGreaterEqual(sg['rochers'], 10); self.assertGreaterEqual(sg['arbres'], 8)
        # La souche : autel de pierre posé sur la souche, marches juste dessous qui touchent l'autel et l'herbe.
        self.assertTrue((nd.binary_dilation(MASK['autel'], iterations=2) & MASK['souche']).any())
        self.assertTrue((nd.binary_dilation(MASK['autel'], iterations=2) & MASK['marches']).any())
        self.assertTrue((nd.binary_dilation(MASK['embleme'], iterations=1) & MASK['autel']).any())
        ym, _ = np.nonzero(MASK['marches']); ya, _ = np.nonzero(MASK['autel'])
        self.assertGreater(ym.mean(), ya.mean())
        grass = MASK['prairie'] | MASK['herbe'] | MASK['ombres'] | MASK['fleurs']
        self.assertTrue((nd.binary_dilation(MASK['marches'], iterations=2) & grass).any())
        self.assertTrue(MASK['praticable'][MASK['marches']].all())
        # Rayon en haut, relié au bord haut ; jamais sur la souche ni l'autel.
        ys, _ = np.nonzero(MASK['rayon']); self.assertEqual(int(ys.min()), 0)
        self.assertFalse((MASK['rayon'] & (MASK['souche'] | MASK['autel'] | MASK['embleme'])).any())

    def test_fidelite_rip(self):
        dec, ref = B.rgb(HERE / 'bruts/decor.png'), B.rgb(REF)
        fid = B.fidelity(dec, ref)
        self.assertEqual(set(fid), {'fond', 'herbe_claire', 'herbe', 'roche'})
        for k, v in fid.items():
            self.assertLess(v['distance'], 35, (k, v))
            self.assertAlmostEqual(v['distance'], M['fidelite_rip']['brut'][k]['distance'], places=1)
        for nm, v in M['fidelite_rip']['calques_finaux'].items():
            lay = BY[nm][0]; px = lay[alpha(lay)][:, :3].astype(float)
            sel = B.materials(px.reshape(-1, 1, 3))[v['matiere']][:, 0]
            self.assertGreater(int(sel.sum()), 50, nm)
            d = float(np.linalg.norm(px[sel].mean(0) - np.array(fid[v['matiere']]['rip_rgb'])))
            self.assertLess(d, 35, (nm, d)); self.assertAlmostEqual(d, v['distance_rip'], places=1)
        herbe = np.array(fid['herbe']['rip_rgb'])
        f = B.rgb(HERE / 'bruts/sol_complet.png').reshape(-1, 3).mean(0)
        d = float(np.linalg.norm(f - herbe)); self.assertLess(d, 35); self.assertAlmostEqual(d, M['fidelite_rip']['sol_complet'], places=1)

    def test_embleme_et_rayon_rampe_exacte_boucle_fermee(self):
        rp = [tuple(c) for c in M['rayon']['rampe']]
        self.assertEqual(rp, [tuple(c) for c in B.RAMP]); self.assertEqual(len(rp), 22)
        self.assertTrue(set(rp) <= rip_colors())                                        # couleurs EXACTES du rip
        self.assertEqual(sorted(rp, key=lambda c: lum(np.array(c, float))), rp)         # rampe sombre -> claire
        fr = BY['rayon']; self.assertEqual((len(fr), M['layers'][-2]['ticks']), (24, 5))
        self.assertTrue(colors(fr) <= set(rp))
        bi = base_idx(); m = MASK['rayon']
        want = B.beam_frames(bi, m)
        for t in range(24):
            self.assertTrue((fr[t] == want[t]).all(), t)
        self.assertTrue((B.beam_frames(bi, m, ts=[24])[0] == fr[0]).all())             # 24 = 0 : boucle fermée
        self.assertTrue((fr[0][m][:, :3] == np.array(rp, 'uint8')[bi[m]]).all())
        idx = [B.ramp_index(f[m]).astype(int) - bi[m] for f in fr]
        self.assertEqual(max(int(np.abs(d).max()) for d in idx), M['rayon']['souffle_crans'])
        self.assertGreater(float((idx[6] > 0).mean()), 0.5); self.assertGreater(float((idx[18] < 0).mean()), 0.5)
        dark = m & (bi == 0)
        self.assertTrue(all((f[dark][:, :3] == np.array(rp[0], 'uint8')).all() for f in fr))
        # Emblème de Celebi : rampe exacte, aller-retour symétrique de +3 crans.
        fe = BY['embleme']; ei = emb_idx(); me = MASK['embleme']
        self.assertEqual(len(fe), 24); self.assertTrue(colors(fe) <= set(rp))
        wante = B.emblem_frames(ei, me)
        for t in range(24):
            self.assertTrue((fe[t] == wante[t]).all(), t)
        self.assertTrue((B.emblem_frames(ei, me, ts=[24])[0] == fe[0]).all())
        self.assertGreater(lum(fe[12][me]).mean(), lum(fe[0][me]).mean() + 15)

    def test_lucioles_couleurs_exactes_boucle_fermee(self):
        L = M['lucioles']; fr = BY['lucioles']; motes = [tuple(m) for m in L['lucioles']]
        self.assertEqual(motes, [tuple(m) for m in B.MOTES]); self.assertEqual(len(motes), 10)
        cs = {tuple(c) for c in L['couleurs']}
        self.assertTrue(cs <= set(tuple(c) for c in M['rayon']['rampe']) and cs <= rip_colors())
        self.assertTrue(colors(fr) <= cs)
        want = B.mote_frames(motes)
        for t in range(24):
            self.assertTrue((fr[t] == want[t]).all(), t)
        self.assertTrue((B.mote_frames(motes, ts=[24])[0] == fr[0]).all())             # 24 = 0
        solid = MASK['autel'] | MASK['embleme'] | MASK['souche'] | MASK['marches']
        for t in range(24):
            n = nd.label(alpha(fr[t]))[1]
            self.assertEqual(n, 10, t)                                                   # 10 lucioles, jamais fondues
            self.assertFalse((alpha(fr[t]) & solid).any(), t)                            # jamais sur la souche ni l'autel
            for m in motes:
                x, y, _ = B.mote_state(m, t); self.assertTrue(1 <= y < H - 1 and 1 <= x < W - 1)
        u = [B.mote_state(motes[0], t) for t in range(24)]
        self.assertTrue({s for *_, s in u} == {'point', 'croix'})
        self.assertTrue(all(u[i][1] == u[i - 1][1] - 2 for i in range(1, 24)))            # montée de 2 px par phase

    def test_ora_and_scene(self):
        with zipfile.ZipFile(O / 'FJS5_fin_jardin_secret_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
            self.assertIn(b'Jardin secret', z.read('stack.xml'))
        sc = Image.new('RGBA', (W, H))
        for frames in STACK:
            sc.alpha_composite(Image.fromarray(frames[0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/FJS5_scene_t000.png')).all())
        for L in M['layers']:
            self.assertEqual(M['scene_loop_ticks'] % (L['phases'] * L['ticks']) if L['phases'] > 1 else 0, 0)

    def test_access_fin_sans_sortie(self):
        a = M['access']; self.assertTrue(a['path_found_16x16'])
        self.assertTrue(a['path_entry_to_boss_16x16']); self.assertTrue(a['path_boss_to_objectif_16x16'])
        self.assertNotIn('threshold_px', a); self.assertIn('cul-de-sac', a['sortie'])
        ex, ey = a['entry_px']; bx, by = a['boss_px']; ox, oy = a['objectif_px']
        self.assertGreater(ey, H - 64); self.assertTrue(H // 3 < by < 2 * H // 3); self.assertLess(oy, H // 3)
        for px, py in ((ex, ey), (bx, by), (ox, oy)):
            self.assertGreater(MASK['praticable'][py:py + 16, px:px + 16].mean(), 0.9)
        da = nd.distance_transform_edt(~MASK['autel'])
        self.assertLess(float(da[oy:oy + 16, ox:ox + 16].min()), 16)                # objectif au pied de l'autel
        self.assertTrue(MASK['marches'][oy:oy + 16, ox:ox + 16].any())             # sur les marches
        self.assertEqual(a['walkable_cells'] + a['blocked_cells'], (W // 8) * (H // 8))
        self.assertGreater(a['walkable_cells'], 1500)
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text())
        blocked = np.array([[c['Tags'] for c in col] for col in doc['Object']['obstacles']]).T.astype(bool)
        # Bords nord, ouest et est entièrement fermés (cul-de-sac).
        self.assertTrue(blocked[0, :].all()); self.assertTrue(blocked[:, 0].all()); self.assertTrue(blocked[:, -1].all())
        for px, py in ((ex, ey), (bx, by), (ox, oy)):
            self.assertFalse(blocked[py // 8:py // 8 + 2, px // 8:px // 8 + 2].any())
        for k in ('autel', 'souche', 'rochers', 'arbres', 'haies', 'fond', 'rayon'):
            cells = MASK[k].reshape(H // 8, 8, W // 8, 8).mean((1, 3)) > 0.5
            self.assertTrue(blocked[cells].all(), k)
        cells = MASK['praticable'].reshape(H // 8, 8, W // 8, 8).mean((1, 3)) == 1
        inner = cells.copy(); inner[0, :] = False; inner[:, 0] = False; inner[:, -1] = False
        self.assertFalse(blocked[inner].any())
        for k in ('rochers', 'arbres', 'haies', 'fond', 'rayon', 'souche', 'autel', 'embleme'):
            self.assertFalse((MASK['praticable'] & MASK[k]).any(), k)
        for k in ('prairie', 'herbe'):
            self.assertGreater(float(MASK['praticable'][MASK[k]].mean()), 0.90, k)

    def test_prefix_and_namespace_unique(self):
        for p in (R / 'source').glob('*/build.py'):
            if p.parent != HERE:
                s = p.read_text(errors='ignore')
                self.assertNotIn("PFX = 'FJS5'", s, p); self.assertNotIn("'fin_jardin_secret'", s, p)

    def test_ground_roundtrip(self):
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text()); o = doc['Object']
        self.assertEqual(doc['Version'], '0.8.12.0'); self.assertEqual(len(o['Layers']), len(STACK) + 1)
        self.assertEqual(o['Layers'][-1]['Layer'], 4)
        nr = loadmod('native_reader', R / 'source/cote_v5_expeditions/audit_references.py')
        banks = {p.stem: nr.tiles(p)[1] for p in (S / 'Content/Tile').glob('*.tile')}
        self.assertEqual(set(banks), set(M['pmdo']['banks']))
        for li, (frames, L) in enumerate(zip(STACK, M['layers'])):
            for t in sorted({0, len(frames) // 2, len(frames) - 1}):
                out = np.zeros((H, W, 4), 'uint8')
                for x, col in enumerate(o['Layers'][li]['Tiles']):
                    for y, cell in enumerate(col):
                        for track in cell['Layers']:
                            if len(track['Frames']) > 1:
                                self.assertEqual((len(track['Frames']), track['FrameLength']), (len(frames), L['ticks']))
                            f = track['Frames'][t % len(track['Frames'])]
                            out[y*8:y*8+8, x*8:x*8+8] = np.array(nr.straight(banks[f['Sheet']][f['TexLoc']['X'], f['TexLoc']['Y']]))
                self.assertTrue((out == frames[t]).all(), (li, t))
        self.assertEqual(sum(w['Tags'] for c in o['obstacles'] for w in c), M['access']['blocked_cells'])
        mks = {m['EntName'] for m in o['Entities'][0]['Markers']}
        self.assertEqual(mks, {'entrance', 'boss', 'objectif'})
        self.assertNotIn('donjon_seuil', mks)
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))


if __name__ == '__main__':
    unittest.main()
