"""Tests dédiés — Entrée Crevasse enneigée sud -> nord V1 (ECE1, 4:3 vaste).
.venv/bin/python -m unittest source.entree_crevasse_enneigee_sud_nord_v1.test_build -v
Contrôles d'images, de formats, de palette exacte du rip, de fidélité, de cadence et de grille : PAS un test du moteur
PMDO. Segmentation, sol complet, scintillements, flocons, poses et chemin 16 x 16 sont RECALCULÉS, pas relus.
"""
from pathlib import Path
import functools, hashlib, importlib.util, io, json, re, unittest, zipfile
import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/entree_crevasse_enneigee_sud_nord_v1'
S = R / '.cache/entree_crevasse_enneigee_sud_nord_v1/entree_crevasse_enneigee_sud_nord'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
NAMES = [Path(L['file']).name.replace('_fNN', '') for L in M['layers']]
STATIC = ('neige', 'ombres', 'corniches', 'falaises', 'profondeur')
REF = HERE / 'references/D79P11A.png'


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
BY = {re.sub(r'^ECE1_\d\d_', '', Path(n).stem): fr for n, fr in zip(NAMES, STACK)}
ORDER = list(BY)
MASK = {k: np.array(Image.open(O / f'masques/ECE1_masque_{k}.png')) > 0 for k in STATIC}
B = loadmod('ece1_build', HERE / 'build.py')


def alpha(a):
    return a[..., 3] == 255


def colors(frames, mask=None):
    out = set()
    for a in frames:
        m = a[..., 3] > 0 if mask is None else (a[..., 3] > 0) & mask
        out |= {tuple(int(v) for v in c) for c in np.unique(a[m][:, :3], axis=0)}
    return out


def rip_colors():
    a = np.array(Image.open(REF).convert('RGB'))
    return {tuple(int(v) for v in c) for c in np.unique(a.reshape(-1, 3), axis=0)}


def walk():
    return alpha(BY['neige'][0]) | alpha(BY['ombres'][0])


def lum(px):
    return px[..., :3].astype(float) @ [.299, .587, .114]


def steps(frames, mask=None):
    n = len(frames); m = np.ones((H, W), bool) if mask is None else mask
    return [int((frames[t][m] != frames[(t + 1) % n][m]).any(-1).sum()) for t in range(n)]


@functools.lru_cache(None)
def recompute():
    """Segmentation et sol complet recalculés depuis le brut (mêmes fonctions que build.py)."""
    a = B.rgb(HERE / 'bruts/decor.png'); pal, _ = B.rip_palette()
    m, walk_full, seg = B.classify(a)
    ex, cols = B.down_class(a, m, ['profondeur', 'neige', 'ombres', 'corniches', 'falaises'])
    sc = np.where(walk_full[..., None], a, np.array(B.SNOW)).astype(np.uint8)
    return ex, cols, B.snap(B.down_full(sc), pal), seg, pal


@functools.lru_cache(None)
def poses():
    pal, _ = B.rip_palette()
    return B.sheet_poses(HERE / 'bruts/source_poses.png', pal)


class Build(unittest.TestCase):
    def test_raw_hashes_and_reference(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        ref = M['reference_da']
        self.assertEqual(ref['code_rom'], 'D79P11A')
        self.assertEqual(hashlib.sha256(REF.read_bytes()).hexdigest(), ref['sha256'])
        prov = json.loads((HERE / 'references/provenance.json').read_text())
        self.assertIn('D79P11A', json.dumps(prov))
        g = M['generation']
        self.assertEqual([x['file'] for x in g], ['decor.png', 'source_poses.png'])
        self.assertTrue(all(x['images'] and len(x['prompt']) > 100 and x['essais'] for x in g))
        self.assertTrue(all(x['images'][0].endswith('references/D79P11A.png') for x in g))
        self.assertIn('No water', g[0]['prompt']); self.assertIn('SOUTH', g[0]['prompt']); self.assertIn('NORTH', g[0]['prompt'])
        ec = M['sol_complet']['editions_generateur_ecartees']                # échecs documentés, pas cachés
        self.assertEqual(len(ec), 2); self.assertTrue(all(e['resultat'].startswith('ecarte') for e in ec))
        self.assertFalse((HERE / 'bruts/sol_complet.png').exists())        # aucun brut écarté gardé comme source
        self.assertIn('choisi par l agent', M['biome']); self.assertIn('a confirmer', M['biome'])
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])

    def test_segmentation_et_sol_complet_recalcules(self):
        ex, cols, sol, seg, pal = recompute()
        for k in STATIC:
            self.assertTrue((ex[k] == MASK[k]).all(), k)
            self.assertTrue((ex[k] == alpha(BY[k][0])).all(), k)
            self.assertTrue((BY[k][0][ex[k]][:, :3] == B.snap(cols[k], pal)[ex[k]]).all(), k)
        self.assertEqual(seg, M['segmentation_mesures'])
        sc = BY['sol_complet'][0]
        self.assertTrue(alpha(sc).all())
        self.assertTrue((sc[..., :3] == sol).all())                          # sol complet = pipeline, recalculé
        cs, cn = np.unique(sc[..., :3].reshape(-1, 3), axis=0, return_counts=True)
        self.assertEqual(tuple(int(v) for v in cs[np.argmax(cn)]), B.SNOW)   # blanc du rip dominant

    def test_sizes_names_alpha_no_magenta(self):
        self.assertEqual(len(NAMES), len(set(NAMES))); self.assertTrue(all(n.startswith('ECE1_') for n in NAMES))
        self.assertEqual((W, H, W % 8, H % 8), (768, 576, 0, 0)); self.assertEqual(W * 3, H * 4)
        for name, frames in BY.items():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W))
                self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255}, name)
                v = a[a[..., 3] > 0].astype(int)
                self.assertEqual(int(((v[:, 0] - v[:, 1] > 60) & (v[:, 2] - v[:, 1] > 60) & (v[:, 1] < 90)).sum()), 0, name)

    def test_multicalque_partition(self):
        self.assertEqual(ORDER, ['sol_complet', *STATIC, 'scintillements', 'flocons'])
        fixed = [alpha(BY[k][0]) for k in STATIC]
        self.assertTrue((np.sum(fixed, 0) == 1).all())
        for k in STATIC:
            self.assertGreater(int(alpha(BY[k][0]).sum()), 1000, k)
        self.assertNotIn('eau', BY)                                          # aucune eau, nulle part
        self.assertTrue((np.nonzero(MASK['profondeur'])[0] < H // 2).all())  # la bouche est au nord

    def test_palette_exacte_du_rip(self):
        rip = rip_colors(); self.assertEqual(len(rip), 103)
        self.assertEqual({tuple(c) for c in M['palette_rip']['couleurs']}, rip)
        for name, frames in BY.items():                                      # TOUS les calques, toutes les phases
            self.assertTrue(colors(frames) <= rip, name)
        L = lambda k: lum(BY[k][0][alpha(BY[k][0])])
        self.assertGreater(L('neige').mean(), 250)
        self.assertLess(L('ombres').mean(), L('neige').mean() - 15)
        self.assertLess(L('profondeur').mean(), 80)                          # bouche sombre
        self.assertLess(L('corniches').mean(), L('ombres').mean() - 40)
        self.assertLess(M['palette_rip']['ecart_decor_brut']['moyenne'], 6)

    def test_fidelite_rip(self):
        dec, ref = B.rgb(HERE / 'bruts/decor.png'), B.rgb(REF)
        fid = B.fidelity(dec, ref)
        for k, v in fid.items():
            self.assertLess(v['distance'], 35, (k, v))
            self.assertAlmostEqual(v['distance'], M['fidelite_rip']['brut'][k]['distance'], places=1)
        for nm, v in M['fidelite_rip']['calques_finaux'].items():
            lay = BY[nm][0]; px = lay[alpha(lay)][:, :3].astype(float)
            sel = B.materials(px.reshape(-1, 1, 3))[v['matiere']][:, 0]
            px = px[sel] if sel.sum() > 50 else px
            d = float(np.linalg.norm(px.mean(0) - np.array(fid[v['matiere']]['rip_rgb'])))
            self.assertLess(d, 35, (nm, d)); self.assertAlmostEqual(d, v['distance_rip'], places=1)

    def test_poses_recalculees(self):
        ps, tinted = poses()
        self.assertEqual(tinted, M['poses']['pixels_teintes_ecartes'])
        self.assertEqual(set(ps), set(B.POSE_WIN))
        for k, p in ps.items():
            self.assertTrue((load(O / f'poses/ECE1_{k}.png') == p).all(), k)
        rip = rip_colors()
        self.assertTrue(colors(list(ps.values())) <= rip)
        n = lambda k: int(alpha(ps[k]).sum())
        self.assertLess(n('flocon_0'), n('flocon_2')); self.assertLess(n('flocon_2'), n('flocon_5'))
        self.assertEqual(max((f'eclat_{i}' for i in range(6)), key=n), 'eclat_3')   # l'étoile culmine à la phase 3
        self.assertLessEqual(max(max(p.shape[:2]) for k, p in ps.items() if k.startswith('flocon')), 8)

    def test_scintillements(self):
        Sc = M['scintillements']; fr = BY['scintillements']
        self.assertEqual((len(fr), Sc['frame_length_ticks']), (48, 4))
        em = [tuple(e) for e in Sc['emetteurs']]; self.assertEqual(len(em), B.N_GLINTS)
        self.assertEqual(Sc['sequence'], B.GLINT_SEQ)
        ps, _ = poses()
        calc = B.glint_frames(ps, em)
        for t, a in enumerate(fr):
            self.assertTrue((a == calc[t]).all(), t)
        self.assertTrue((B.glint_frames(ps, em, ts=[48])[0] == fr[0]).all())    # 48 = 0 : boucle fermée
        for x, y, _ in em:
            self.assertTrue(MASK['falaises'][y, x], (x, y))
        self.assertEqual(sorted(o for _, _, o in em), [(j * 48) // 16 for j in range(16)])
        self.assertTrue(min(steps(fr)) > 0)

    def test_flocons(self):
        F = M['flocons']; fr = BY['flocons']
        self.assertEqual((len(fr), F['frame_length_ticks']), (48, 4))
        fl = [tuple(f) for f in F['emetteurs']]; self.assertEqual(len(fl), B.N_FLAKES)
        rng = np.random.default_rng(F['graine']); calc_em = []
        for j in range(B.N_FLAKES):
            kind = B.FLAKE_KINDS[j % len(B.FLAKE_KINDS)]
            calc_em.append((int(rng.integers(6, W - 6)), int(rng.integers(-8, H - 56)), kind, int(rng.integers(0, 48))))
        self.assertEqual(fl, calc_em)                                         # émetteurs = graine, pas une liste à la main
        ps, _ = poses()
        calc = B.flake_frames(ps, fl, walk())
        for t, a in enumerate(fr):
            self.assertTrue((a == calc[t]).all(), t)
        self.assertTrue((B.flake_frames(ps, fl, walk(), ts=[48])[0] == fr[0]).all())
        self.assertTrue(min(steps(fr)) > 0)
        vis = [sum(((t - o) % 48) < B.FLAKE_LIFE for _, _, _, o in fl) for t in range(48)]
        self.assertGreaterEqual(min(vis), 45)                                # chute continue, jamais vide

    def test_ora_and_scene(self):
        with zipfile.ZipFile(O / 'ECE1_entree_crevasse_enneigee_calques.ora') as z:
            self.assertEqual(z.namelist()[0], 'mimetype')
            self.assertEqual(z.getinfo('mimetype').compress_type, zipfile.ZIP_STORED)
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
            self.assertIn(b'Crevasse enneigee', z.read('stack.xml'))
            self.assertTrue(all(i.date_time == (1980, 1, 1, 0, 0, 0) for i in z.infolist()))
        sc = Image.new('RGBA', (W, H))
        for frames in STACK:
            sc.alpha_composite(Image.fromarray(frames[0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/ECE1_scene_t000.png')).all())
        for L in M['layers']:
            self.assertEqual(M['scene_loop_ticks'] % (L['phases'] * L['ticks']) if L['phases'] > 1 else 0, 0)

    def test_access(self):
        a = M['access']; self.assertTrue(a['path_found_16x16'])
        ex, ey = a['entry_px']; tx, ty = a['threshold_px']
        self.assertGreater(ey, H - 64); self.assertLess(abs(ex + 8 - W // 2), 64)   # arrivée au sud, au centre
        dys, dxs = np.nonzero(MASK['profondeur'])
        self.assertLess(abs(tx + 8 - dxs.mean()), 16)
        self.assertTrue(-8 <= ty - dys.max() <= 24, (ty, dys.max()))         # seuil sur le pas de la bouche
        self.assertTrue(walk()[ey:ey + 16, ex:ex + 16].mean() > 0.5)
        self.assertTrue(walk()[ty:ty + 16, tx:tx + 16].mean() > 0.5)
        self.assertEqual(a['walkable_cells'] + a['blocked_cells'], (W // 8) * (H // 8))
        self.assertGreater(a['walkable_cells'], 2000)
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text())
        blocked = np.array([[c['Tags'] for c in col] for col in doc['Object']['obstacles']]).T.astype(bool)
        for k in ('corniches', 'falaises', 'profondeur'):
            cells = MASK[k].reshape(H // 8, 8, W // 8, 8).mean((1, 3)) > 0.5
            self.assertTrue(blocked[cells].all(), k)
        for px in (a['entry_px'], a['threshold_px']):
            self.assertFalse(blocked[px[1] // 8:px[1] // 8 + 2, px[0] // 8:px[0] // 8 + 2].any(), px)
        self.assertTrue(blocked[:25].all())                                  # la falaise ferme tout le nord
        self.assertTrue((blocked == B.cell_grid(~walk())).all())             # obstacles = calques
        v1 = loadmod('esn1_t', R / 'source/entree_sud_nord_generee_v1/build.py')   # chemin recalculé, pas lu
        self.assertTrue(v1.reachable(blocked, (ey // 8, ex // 8), (ty // 8, tx // 8))[0])

    def test_prefix_and_namespace_unique(self):
        for p in (R / 'source').glob('*/build.py'):
            if p.parent != HERE:
                s = p.read_text(errors='ignore')
                self.assertNotIn("PFX = 'ECE1'", s, p); self.assertNotIn("'entree_crevasse_enneigee_sud_nord'", s, p)

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
        self.assertEqual([m['EntName'] for m in o['Entities'][0]['Markers']], ['entrance', 'donjon_seuil'])
        lua = (S / f"Data/Script/{M['pmdo']['namespace']}/ground/{M['pmdo']['asset']}/init.lua").read_text()
        self.assertNotIn('Warp', lua); self.assertNotIn('MoveToZone', lua)
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))


if __name__ == '__main__':
    unittest.main()
