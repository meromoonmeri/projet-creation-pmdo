"""Tests dédiés — Fin Clairière tropicale V1 (FCT3, 4:3 vaste).
.venv/bin/python -m unittest source.fin_clairiere_tropicale_v1.test_build -v
Contrôles d'images, de formats, de palettes, de fidélité au rip, de cadence et de grille : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, re, unittest, zipfile
import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/fin_clairiere_tropicale_v1'
S = R / '.cache/fin_clairiere_tropicale_v1/fin_clairiere_tropicale'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
NAMES = [Path(L['file']).name.replace('_fNN', '') for L in M['layers']]
STATIC = ('herbe', 'ombres', 'dalles', 'touffes', 'fleurs', 'jungle', 'palmiers', 'tertre', 'rive')
REF = R / 'large.S01P03A.png.84e22fb77c4061e77b0f546545fed2c7.png'


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
BY = {re.sub(r'^FCT3_\d\d_', '', Path(n).stem): fr for n, fr in zip(NAMES, STACK)}
ORDER = list(BY)
MASK = {k: np.array(Image.open(O / f'masques/FCT3_masque_{k}.png')) > 0 for k in (*STATIC, 'mer', 'praticable')}
B = loadmod('fct3_build', HERE / 'build.py')


def alpha(a):
    return a[..., 3] == 255


def colors(frames):
    return {tuple(int(v) for v in c) for a in frames for c in np.unique(a[a[..., 3] > 0][:, :3], axis=0)}


def rip_colors():
    a = np.array(Image.open(REF).convert('RGB'))
    return {tuple(int(v) for v in c) for c in np.unique(a.reshape(-1, 3), axis=0)}


def lum(px):
    return px[..., :3].astype(float) @ [.299, .587, .114]


def poses():
    return {k: load(O / f'poses/FCT3_{k}.png') for k in M['papillons']['poses']}


class Build(unittest.TestCase):
    def test_raw_hashes_reference_and_coherence_with_entry(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        ref = M['reference_da']
        self.assertEqual(ref['file'], REF.name)
        self.assertEqual(hashlib.sha256(REF.read_bytes()).hexdigest(), ref['sha256'])
        g = M['generation']
        self.assertEqual([x['file'] for x in g], ['decor_magenta.png', 'sol_complet.png', 'temoin_sans_objets.png', 'papillons_poses.png'])
        self.assertTrue(all(x['images'] and len(x['prompt']) > 100 for x in g))
        self.assertIn(REF.name, g[0]['images']); self.assertIn(REF.name, g[3]['images'])
        for i in (1, 2):
            self.assertTrue(g[i]['images'][0].endswith('bruts/decor_magenta.png'))
        self.assertIn('flat pure magenta', g[0]['prompt'])
        # Planche et constantes partagées avec l'entrée ETC1.
        etc_poses = R / 'source/entree_clairiere_tropicale_sud_nord_v1/bruts/papillons_poses.png'
        self.assertEqual(hashlib.sha256((HERE / 'bruts/papillons_poses.png').read_bytes()).hexdigest(),
                         hashlib.sha256(etc_poses.read_bytes()).hexdigest())
        self.assertEqual((B.WAVE_P, B.BANDE, B.CALME, B.POSE_WIN), (B.ETC.WAVE_P, B.ETC.BANDE, B.ETC.CALME, B.ETC.POSE_WIN))
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])

    def test_recalages_et_sol_complet_propre(self):
        a, f_raw, t = (B.rgb(HERE / f'bruts/{n}.png') for n in ('decor_magenta', 'sol_complet', 'temoin_sans_objets'))
        f = B.clean_sol(f_raw); m, _ = B.classify(a, t)
        rs = B.recalage(a, f, m['herbe'] & (np.abs(a - t).mean(2) < 5))
        rt = B.recalage(a, t, ~m['mer'] & (np.abs(a - t).mean(2) < 15))
        self.assertEqual(rs, {k: M['recalage']['sol_complet'][k] for k in rs})
        self.assertEqual(rt, {k: M['recalage']['temoin'][k] for k in rt})
        self.assertLess(rt['ecart_moyen'], 5)
        sol = BY['sol_complet'][0][alpha(BY['sol_complet'][0])][:, :3].astype(float)
        self.assertGreater(sol.mean(0)[1], sol.mean(0)[2] + 90)
        self.assertGreater(float(lum(sol).min()), 85)                       # plus de buisson sombre sur les bords
        self.assertGreater(len(colors(BY['sol_complet'])), 12)

    def test_sizes_names_alpha_no_magenta(self):
        self.assertEqual(len(NAMES), len(set(NAMES))); self.assertTrue(all(n.startswith('FCT3_') for n in NAMES))
        self.assertEqual((W, H, W % 8, H % 8), (768, 576, 0, 0)); self.assertEqual(W * 3, H * 4)
        n = M['normalization']; self.assertAlmostEqual(n['scale'], 576 / 896)
        self.assertEqual(n['scaled'][0] - sum(n['crop_x']), W)
        for name, frames in BY.items():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W))
                self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255}, name)
                v = a[a[..., 3] > 0].astype(int)
                bad = (v[:, 0] - v[:, 1] > 60) & (v[:, 2] - v[:, 1] > 60)
                if name == 'fleurs':
                    self.assertLess(int(bad.sum()), 80, name)
                else:
                    self.assertEqual(int(bad.sum()), 0, name)

    def test_multicalque_full_coverage_and_order(self):
        self.assertEqual(ORDER, ['sol_complet', *STATIC, 'mer', 'rive_eau', 'papillons'])
        self.assertNotIn('profondeur', BY); self.assertNotIn('ponton', BY)  # fin : ni bouche sombre ni ponton
        self.assertTrue(alpha(BY['sol_complet'][0]).all())
        fixed = [alpha(BY[k][0]) for k in STATIC] + [alpha(BY['mer'][0])]
        self.assertTrue((np.sum(fixed, 0) == 1).all())
        for k in STATIC:
            self.assertGreater(int(alpha(BY[k][0]).sum()), 500, k)
            self.assertTrue((alpha(BY[k][0]) == MASK[k]).all(), k)
        for a in BY['mer']:
            self.assertTrue((alpha(a) == MASK['mer']).all())

    def test_palettes_ombres_et_matieres(self):
        for g, v in M['normalization']['palettes'].items():
            self.assertLessEqual(len(colors([BY[k][0] for k in v['calques']])), v['couleurs'], g)
        L = lambda k: BY[k][0][alpha(BY[k][0])][:, :3].astype(int)
        f = L('fleurs'); self.assertGreater(float(((f.max(1) - f.min(1)) > 150).mean()), 0.15)
        d = L('dalles').mean(0); self.assertGreater(d[0], d[2] + 60); self.assertGreater(d[0], d[1])
        self.assertGreater(L('herbe').mean(0)[1], L('jungle').mean(0)[1] + 55)
        self.assertLess(lum(L('ombres')).mean(), lum(L('herbe')).mean() - 15)
        o = L('ombres'); self.assertGreater(float((o[:, 1] > o[:, 2] + 35).mean()), 0.8)
        base = nd.distance_transform_edt(~MASK['tertre'])
        self.assertLessEqual(float(base[MASK['ombres']].max()), 45 * 576 / 896 + 2)
        lab, n = nd.label(MASK['palmiers']); self.assertGreaterEqual(n, 6)
        lab, n = nd.label(MASK['fleurs']); self.assertGreaterEqual(n, 15)
        self.assertTrue((nd.binary_dilation(MASK['mer'], iterations=2) & MASK['rive']).any())
        self.assertTrue((nd.binary_dilation(MASK['tertre'], iterations=2) & MASK['ombres']).any())

    def test_fidelite_rip(self):
        dec, ref = B.rgb(HERE / 'bruts/decor_magenta.png'), B.rgb(REF)
        fid = B.fidelity(dec, ref)
        for k, v in fid.items():
            self.assertLess(v['distance'], 35, (k, v))
            self.assertAlmostEqual(v['distance'], M['fidelite_rip']['brut'][k]['distance'], places=1)
        for nm, v in M['fidelite_rip']['calques_finaux'].items():
            lay = BY[nm][0]; px = lay[alpha(lay)][:, :3].astype(float)
            sel = B.materials(px.reshape(-1, 1, 3))[v['matiere']][:, 0]
            self.assertGreater(int(sel.sum()), 50, nm)
            d = float(np.linalg.norm(px[sel].mean(0) - np.array(fid[v['matiere']]['rip_rgb'])))
            self.assertLess(d, 35, (nm, d)); self.assertAlmostEqual(d, v['distance_rip'], places=1)

    def test_mer_profil_du_rip_boucle_et_rive_sans_liseré(self):
        Mr = M['mer']; fr = BY['mer']; water = MASK['mer']
        self.assertEqual((len(fr), Mr['frame_length_ticks'], Mr['pas_px'] * len(fr)), (24, 5, Mr['periode_px']))
        self.assertEqual(Mr['sens'], 'vers le sud (vers la rive de sable)')
        ref = B.rgb(REF); prof, crest = B.wave_model(ref)
        self.assertEqual([list(c) for c in prof], Mr['profil']); self.assertEqual(crest, Mr['crete'])
        self.assertTrue(colors(fr) <= rip_colors())
        calc, d = B.sea_frames(water, prof, crest)
        for t, a in enumerate(fr):
            self.assertTrue((a == calc[t]).all(), t)
        self.assertTrue((B.sea_frames(water, prof, crest, ts=[24])[0][0] == fr[0]).all())
        far = water & (d > 12)
        far2 = far[:-2] & far[2:]
        for t in range(24):
            # La mer est au nord et la rive au sud : chaque vague descend de +2 px vers le sud (vers la rive) par phase.
            self.assertTrue((fr[(t + 1) % 24][2:][far2] == fr[t][:-2][far2]).all(), t)
        land = ~water; touch = water & (nd.binary_dilation(land, structure=nd.generate_binary_structure(2, 1)))
        self.assertGreater(int(touch.sum()), 200)
        light = {tuple(c) for c in prof if lum(np.array(c, float)) >= lum(np.array([119, 183, 231], float))}
        for a in fr:
            self.assertTrue((a[touch][:, :3] == Mr['bande_rive']).all())
            near = a[water & (d <= Mr['rive_px']['calme'])][:, :3]
            self.assertFalse(any(tuple(int(v) for v in c) in light for c in np.unique(near, axis=0)))
        # Rive d'eau animée qui touche et recouvre le sable (rive) au rythme des vagues.
        Rv = M['rive_eau']; rfr = BY['rive_eau']
        self.assertEqual((len(rfr), Rv['frame_length_ticks']), (24, 5))
        self.assertTrue(colors(rfr) <= rip_colors())
        rcalc = B.rive_eau_frames(water, MASK['rive'], MASK['tertre'], crest)
        for t, a in enumerate(rfr):
            self.assertTrue((a == rcalc[t]).all(), t)
            self.assertGreater(int((alpha(a) & MASK['rive']).sum()), 400, t)
            self.assertGreater(int((alpha(a) & MASK['mer']).sum()), 400, t)
        self.assertTrue((B.rive_eau_frames(water, MASK['rive'], MASK['tertre'], crest, ts=[24])[0] == rfr[0]).all())
        # La nappe d'eau (hors sable mouillé) qui monte sur le sable varie au cours du cycle des vagues.
        surf_cols = {B.SURF_CREST, B.SURF_FOAM, B.SURF_LIGHT, B.SURF_MID, B.SURF_CALM}
        on_sand = []
        for a in rfr:
            m = alpha(a) & MASK['rive']
            c = a[m][:, :3]
            on_sand.append(int(sum(((c[:, 0] == r) & (c[:, 1] == g) & (c[:, 2] == b)).sum() for r, g, b in surf_cols)))
        self.assertGreater(max(on_sand) - min(on_sand), 500)

    def test_papillons_boucle_fermee(self):
        P = M['papillons']; fr = BY['papillons']; ps = poses()
        self.assertEqual({k: p.shape[0] for k, p in ps.items()}, {k: v[2] // B.POSE_K for k, v in P['poses'].items()})
        self.assertEqual((len(fr), P['frame_length_ticks']), (24, 5))
        self.assertLessEqual(len(colors(fr)), 10)
        for k, p in ps.items():
            lab, n = nd.label(alpha(p), structure=np.ones((3, 3))); self.assertLessEqual(n, 2, k)
        fl = [tuple(f) for f in P['vols']]
        calc = B.butterfly_frames(ps, fl)
        for t, a in enumerate(fr):
            self.assertTrue((a == calc[t]).all(), t)
            self.assertGreater(int(alpha(a).sum()), 40, t)
        self.assertTrue((B.butterfly_frames(ps, fl, ts=[24])[0] == fr[0]).all())
        for f in fl:
            pos = [B.flight_pos(f, t) for t in range(25)]
            self.assertTrue(all(np.hypot(pos[t + 1][0] - pos[t][0], pos[t + 1][1] - pos[t][1]) < 16 for t in range(24)))
            self.assertAlmostEqual(pos[24][0], pos[0][0]); self.assertAlmostEqual(pos[24][1], pos[0][1])

    def test_ora_and_scene(self):
        with zipfile.ZipFile(O / 'FCT3_fin_clairiere_tropicale_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
            self.assertIn(b'Clairiere tropicale', z.read('stack.xml'))
        sc = Image.new('RGBA', (W, H))
        for frames in STACK:
            sc.alpha_composite(Image.fromarray(frames[0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/FCT3_scene_t000.png')).all())
        for L in M['layers']:
            self.assertEqual(M['scene_loop_ticks'] % (L['phases'] * L['ticks']) if L['phases'] > 1 else 0, 0)

    def test_access_fin_sans_sortie(self):
        a = M['access']; self.assertTrue(a['path_found_16x16'] and a['path_to_boss'] and a['path_to_objective'])
        ex, ey = a['entry_px']; bx, by = a['boss_px']; ox, oy = a['objective_px']
        self.assertGreater(ey, H - 64); self.assertLess(oy, H // 2)
        self.assertTrue(MASK['praticable'][ey:ey + 16, ex:ex + 16].mean() > 0.5)
        self.assertTrue(MASK['praticable'][by:by + 16, bx:bx + 16].mean() > 0.9)
        dn = nd.distance_transform_edt(MASK['praticable'])
        self.assertGreater(float(dn[by + 8, bx + 8]), 40)
        self.assertLess(abs(ox + 8 - W // 2), 72)
        self.assertLess(oy, by - 60)
        self.assertEqual(a['walkable_cells'] + a['blocked_cells'], (W // 8) * (H // 8))
        self.assertGreater(a['walkable_cells'], 1200)
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text())
        blocked = np.array([[c['Tags'] for c in col] for col in doc['Object']['obstacles']]).T.astype(bool)
        for k in ('jungle', 'palmiers', 'tertre', 'rive', 'mer'):
            cells = MASK[k].reshape(H // 8, 8, W // 8, 8).mean((1, 3)) > 0.5
            self.assertTrue(blocked[cells].all(), k)
        for px in (a['entry_px'], a['boss_px'], a['objective_px']):
            self.assertFalse(blocked[px[1] // 8:px[1] // 8 + 2, px[0] // 8:px[0] // 8 + 2].any(), px)
        self.assertTrue(blocked[:4].all()); self.assertTrue(blocked[:, :4].all() and blocked[:, -4:].all())

    def test_prefix_and_namespace_unique(self):
        for p in (R / 'source').glob('*/build.py'):
            if p.parent != HERE:
                s = p.read_text(errors='ignore')
                self.assertNotIn("PFX = 'FCT3'", s, p); self.assertNotIn("'fin_clairiere_tropicale'", s, p)

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
        self.assertEqual({m['EntName'] for m in o['Entities'][0]['Markers']}, {'entrance', 'boss', 'objectif'})
        self.assertEqual(len(o['Entities'][0]['Markers']), 3)
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))


if __name__ == '__main__':
    unittest.main()
