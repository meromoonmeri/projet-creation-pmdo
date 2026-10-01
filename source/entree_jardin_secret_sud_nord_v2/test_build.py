"""Tests dédiés — Entrée Jardin secret sud -> nord V2, temple de Celebi (EJS2, 4:3 vaste).
.venv/bin/python -m unittest source.entree_jardin_secret_sud_nord_v2.test_build -v
Contrôles d'images, de formats, de palettes, de fidélité au rip, de cadence et de grille : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, re, unittest, zipfile
import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/entree_jardin_secret_sud_nord_v2'
S = R / '.cache/entree_jardin_secret_sud_nord_v2/entree_jardin_secret_sud_nord_v2'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
NAMES = [Path(L['file']).name.replace('_fNN', '') for L in M['layers']]
STATIC = ('prairie', 'herbe', 'ombres', 'fleurs', 'rochers', 'arbres', 'haies', 'souche', 'temple', 'marches', 'profondeur',
          'fond')
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
BY = {re.sub(r'^EJS2_\d\d_', '', Path(n).stem): fr for n, fr in zip(NAMES, STACK)}
ORDER = list(BY)
MASK = {k: np.array(Image.open(O / f'masques/EJS2_masque_{k}.png')) > 0 for k in (*STATIC, 'rayon', 'embleme', 'praticable')}
B = loadmod('ejs2_build', HERE / 'build.py')


def alpha(a):
    return a[..., 3] == 255


def colors(frames):
    return {tuple(int(v) for v in c) for a in frames for c in np.unique(a[a[..., 3] > 0][:, :3], axis=0)}


def rip_colors():
    a = np.array(Image.open(REF).convert('RGB'))
    return {tuple(int(v) for v in c) for c in np.unique(a.reshape(-1, 3), axis=0)}


def lum(px):
    return px[..., :3].astype(float) @ [.299, .587, .114]


def base_idx(name='rayon'):
    return np.array(Image.open(O / f'masques/EJS2_{name}_crans.png')).astype(int) // 11


def decor():
    """Décor d'EJS1, brut du temple et décor collé, recalculés depuis les bruts."""
    a1, g = B.rgb(B.RAW1 / 'decor.png'), B.rgb(HERE / 'bruts/decor_temple.png')
    return (a1, g, *B.composite(a1, g))


class Build(unittest.TestCase):
    def test_raw_hashes_and_reference(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        ref = M['reference_da']
        self.assertEqual(ref['file'], REF.name)
        self.assertEqual(hashlib.sha256(REF.read_bytes()).hexdigest(), ref['sha256'])
        g = {x['file']: x for x in M['generation']}
        self.assertEqual(g['decor.png']['images'], [REF.name])                                  # rip en référence
        self.assertEqual(g['temoin_sans_objets.png']['images'], [f'{B.LOT1}/bruts/decor.png'])
        self.assertEqual(g['sol_complet.png']['images'], [f'{B.LOT1}/bruts/temoin_sans_objets.png'])
        self.assertEqual(g['decor_temple.png']['images'], [f'{B.LOT1}/bruts/decor.png', REF.name])  # temple : rip en référence
        self.assertEqual(g['decor_temple.png']['lot'], B.LOT)
        self.assertTrue(all(x['lot'] == B.LOT1 for k, x in g.items() if k != 'decor_temple.png'))   # bruts d'EJS1 relus
        self.assertIn('celebi', M['temple']['demande'].lower())
        self.assertTrue(all(len(x['prompt']) > 100 for x in g.values()))
        ec = [x for x in M['generation'] if x.get('ecarte')]
        self.assertEqual(len(ec), 2); self.assertTrue(all('ECARTE' in x['essais'] for x in ec))
        self.assertIn('choisi par l agent', M['biome'])
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])
        for k in ('temoin', 'brut_temple'):
            rg = M['recalage'][k]; self.assertLess(rg['ecart_moyen'], rg['ecart_decale_1px'], k)   # bruts bien calés

    def test_sizes_names_alpha_no_magenta(self):
        self.assertEqual(len(NAMES), len(set(NAMES))); self.assertTrue(all(n.startswith('EJS2_') for n in NAMES))
        self.assertEqual((W, H, W % 8, H % 8), (768, 576, 0, 0)); self.assertEqual(W * 3, H * 4)   # 4:3
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
        fixed = [alpha(BY[k][0]) for k in STATIC] + [MASK['rayon'], MASK['embleme']]
        self.assertTrue((np.sum(fixed, 0) == 1).all())                      # calques fixes + rayon + emblème : partition exacte
        for k in STATIC:
            self.assertGreater(int(alpha(BY[k][0]).sum()), 200, k)
            self.assertTrue((alpha(BY[k][0]) == MASK[k]).all(), k)
        for k in ('rayon', 'embleme'):
            for a in BY[k]:
                self.assertTrue((alpha(a) == MASK[k]).all(), k)
        sol = BY['sol_complet'][0][..., :3].astype(float).reshape(-1, 3)
        self.assertGreater(len(colors(BY['sol_complet'])), 8)               # texture, pas un aplat
        m = sol.mean(0); self.assertGreater(m[1], m[0] + 30); self.assertGreater(m[1], m[2] + 80)   # herbe verte

    def test_palettes_et_matieres(self):
        for g, v in M['normalization']['palettes'].items():
            self.assertLessEqual(len(colors([BY[k][0] for k in v['calques']])), v['couleurs'], g)
        L = lambda k: BY[k][0][alpha(BY[k][0])][:, :3].astype(int)
        self.assertLess(float(np.median(lum(L('profondeur')))), 75)                     # porte sombre
        s = L('souche').mean(0); self.assertGreater(s[0], s[2] + 60)                     # souche dorée
        f = L('fond').mean(0); self.assertLess(float(lum(f)), 85); self.assertGreater(f[1], f[0] + 15)
        for k in ('prairie', 'herbe', 'ombres'):
            p = L(k).mean(0); self.assertGreater(p[1], p[0] + 30, k)
        self.assertGreater(float(lum(L('prairie')).mean()), float(lum(L('ombres')).mean()) + 25)
        self.assertLess(float(L('prairie')[:, 2].mean()), float(L('herbe')[:, 2].mean()) - 15)   # prairie plus jaune
        r = L('rochers').mean(0); self.assertLess(abs(r[0] - r[1]), 30); self.assertGreater(r[0], r[2] + 25)  # roche beige
        sg = M['segmentation_mesures']
        self.assertGreaterEqual(sg['fleurs'], 100); self.assertGreaterEqual(sg['rochers'], 15); self.assertGreaterEqual(sg['arbres'], 10)
        lab, n = nd.label(MASK['rochers']); self.assertGreaterEqual(n, 15)
        # La souche : trou dans la souche, marches juste dessous qui touchent le trou et l'herbe.
        self.assertTrue((nd.binary_dilation(MASK['profondeur'], iterations=2) & MASK['temple']).any())   # porte dans le temple
        self.assertTrue((nd.binary_dilation(MASK['profondeur'], iterations=2) & MASK['marches']).any())
        ym, _ = np.nonzero(MASK['marches']); yp, _ = np.nonzero(MASK['profondeur'])
        self.assertGreater(ym.mean(), yp.mean())
        grass = MASK['prairie'] | MASK['herbe'] | MASK['ombres'] | MASK['fleurs']
        self.assertTrue((nd.binary_dilation(MASK['marches'], iterations=2) & grass).any())
        self.assertTrue(MASK['praticable'][MASK['marches']].all())
        # Rayon en haut, au-dessus des marches, relié au bord haut ; jamais sur la souche ni le temple.
        ys, _ = np.nonzero(MASK['rayon']); self.assertEqual(int(ys.min()), 0); self.assertLess(float(ys.max()), ym.min())
        self.assertFalse((MASK['rayon'] & (MASK['souche'] | MASK['profondeur'] | MASK['temple'] | MASK['embleme'])).any())

    def test_fidelite_rip(self):
        dec, ref = decor()[2], B.rgb(REF)
        fid = B.fidelity(dec, ref)
        self.assertEqual(set(fid), {'fond', 'herbe_claire', 'herbe', 'roche'})
        for k, v in fid.items():
            self.assertLess(v['distance'], 35, (k, v))
            self.assertAlmostEqual(v['distance'], M['fidelite_rip']['brut'][k]['distance'], places=1)
        for nm, v in M['fidelite_rip']['calques_finaux'].items():
            lay = BY[nm][0]; px = lay[alpha(lay)][:, :3].astype(float)
            sel = B.materials(px.reshape(-1, 1, 3))[v['matiere']][:, 0]
            self.assertGreater(int(sel.sum()), 50, nm)                    # la matière est bien présente
            d = float(np.linalg.norm(px[sel].mean(0) - np.array(fid[v['matiere']]['rip_rgb'])))
            self.assertLess(d, 35, (nm, d)); self.assertAlmostEqual(d, v['distance_rip'], places=1)
        herbe = np.array(fid['herbe']['rip_rgb'])
        f = B.rgb(B.RAW1 / 'sol_complet.png').reshape(-1, 3).mean(0)
        d = float(np.linalg.norm(f - herbe)); self.assertLess(d, 35); self.assertAlmostEqual(d, M['fidelite_rip']['sol_complet'], places=1)
        for fn, dist in M['fidelite_rip']['sol_complet_ecartes'].items():   # écartés : non conformes, gardés, pas retouchés
            self.assertGreater(dist, 35, fn)
            self.assertAlmostEqual(float(np.linalg.norm(B.rgb(B.RAW1 / fn).reshape(-1, 3).mean(0) - herbe)), dist, places=1)

    def test_rayon_rampe_exacte_boucle_fermee(self):
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
        self.assertTrue((fr[0][m][:, :3] == np.array(rp, 'uint8')[bi[m]]).all())       # phase 0 = rayon du rendu
        idx = [B.ramp_index(f[m]).astype(int) - bi[m] for f in fr]
        self.assertEqual(max(int(np.abs(d).max()) for d in idx), M['rayon']['souffle_crans'])   # souffle de 2 crans
        self.assertGreater(float((idx[6] > 0).mean()), 0.5); self.assertGreater(float((idx[18] < 0).mean()), 0.5)
        dark = m & (bi == 0)                                                            # bords contre le fond : figés
        self.assertTrue(all((f[dark][:, :3] == np.array(rp[0], 'uint8')).all() for f in fr))

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
        solid = MASK['profondeur'] | MASK['souche'] | MASK['marches'] | MASK['temple'] | MASK['embleme']
        for t in range(24):
            n, k = nd.label(alpha(fr[t]))[1], 0
            self.assertEqual(n, 10, t)                                                   # 10 lucioles, jamais fondues
            self.assertFalse((alpha(fr[t]) & solid).any(), t)                            # jamais sur la souche ni le temple
            for m in motes:
                x, y, _ = B.mote_state(m, t); self.assertTrue(1 <= y < H - 1 and 1 <= x < W - 1)
        u = [B.mote_state(motes[0], t) for t in range(24)]
        self.assertTrue({s for *_, s in u} == {'point', 'croix'})
        self.assertTrue(all(u[i][1] == u[i - 1][1] - 2 for i in range(1, 24)))            # montée de 2 px par phase

    def test_temple_colle_sur_la_souche(self):
        a1, g, a, paste = decor()
        self.assertTrue((a[~paste] == a1[~paste]).all())                               # hors zone : EJS1 au pixel près
        self.assertTrue((a[paste] == g[paste]).all())
        saved = np.array(Image.open(O / 'masques/EJS2_zone_collee_pleine_resolution.png')) > 0
        self.assertTrue((saved == paste).all())
        y0, y1, x0, x1 = M['temple']['fenetre_pleine_resolution']; ys, xs = np.nonzero(paste)
        self.assertTrue(ys.min() >= y0 and ys.max() < y1 and xs.min() >= x0 and xs.max() < x1)
        self.assertEqual(int(paste.sum()), M['segmentation_mesures']['temple']['colle_px'])
        self.assertEqual(M['recalage']['brut_temple'], B.recalage(a1, g, np.pad(np.zeros((y1 - y0 + 40, x1 - x0 + 40), bool),
                         ((y0 - 20, a1.shape[0] - y1 - 20), (x0 - 20, a1.shape[1] - x1 - 20)), constant_values=True)))
        T, D, E, Mr, So = (MASK[k] for k in ('temple', 'profondeur', 'embleme', 'marches', 'souche'))
        ty, tx = np.nonzero(T | D | E); dy, dx = np.nonzero(D); ey, ex = np.nonzero(E); sy, sx = np.nonzero(So | Mr)
        # Le temple tient sur la souche : son pied touche la souche, il reste dans sa largeur, il est au-dessus de l'escalier.
        foot = T & (np.arange(H)[:, None] >= ty.max() - 3)
        self.assertTrue((nd.binary_dilation(foot, iterations=2) & (So | Mr)).any())
        self.assertTrue(tx.min() >= sx.min() - 4 and tx.max() <= sx.max() + 4, (tx.min(), tx.max(), sx.min(), sx.max()))
        self.assertLess(ty.mean(), sy.mean())
        self.assertLess(ty.max() - ty.min(), 80); self.assertLess(tx.max() - tx.min(), 70)   # miniature : < 80 x 70 px
        # Porte : dans le temple (temple au-dessus et sur les côtés), les marches juste dessous.
        self.assertTrue(T[:dy.min(), dx.min():dx.max() + 1].any())
        self.assertTrue(T[dy.min():dy.max() + 1, :dx.min()].any() and T[dy.min():dy.max() + 1, dx.max() + 1:].any())
        self.assertTrue((nd.binary_dilation(D, iterations=2) & Mr).any())
        # Emblème : sur le fronton, au-dessus de la porte, centré, entouré par le temple.
        self.assertLess(ey.max(), dy.min()); self.assertLess(abs(ex.mean() - dx.mean()), 6)
        self.assertGreaterEqual(int(E.sum()), 20)
        self.assertTrue((nd.binary_dilation(E, iterations=1) & ~E & ~T).sum() == 0)

    def test_embleme_rampe_exacte_boucle_fermee(self):
        fr = BY['embleme']; rp = [tuple(c) for c in B.RAMP]; E = MASK['embleme']; bi = base_idx('embleme')
        self.assertEqual(len(fr), 24); self.assertTrue(colors(fr) <= set(rp) <= rip_colors())   # rampe exacte du rip
        want = B.emblem_frames(bi, E)
        for t in range(24):
            self.assertTrue((fr[t] == want[t]).all(), t)
        self.assertTrue((B.emblem_frames(bi, E, ts=[24])[0] == fr[0]).all())            # 24 = 0
        self.assertTrue((fr[0][E][:, :3] == np.array(rp, 'uint8')[bi[E]]).all())          # phase 0 = emblème du rendu
        steps = [int((B.ramp_index(f[E]).astype(int) - bi[E]).max()) for f in fr]
        self.assertEqual(max(steps), M['temple']['embleme']['crans_max']); self.assertEqual(steps[12], 3)
        self.assertEqual(steps, steps[:1] + steps[1:][::-1])                              # aller-retour symétrique
        self.assertTrue(all(b <= a for a, b in zip(steps[12:], steps[13:])))
        self.assertGreater(float(lum(fr[12][E]).mean()), float(lum(fr[0][E]).mean()) + 10)   # il s'éclaire

    def test_ora_and_scene(self):
        with zipfile.ZipFile(O / 'EJS2_entree_jardin_secret_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
            self.assertIn(b'Jardin secret', z.read('stack.xml'))
        sc = Image.new('RGBA', (W, H))
        for frames in STACK:
            sc.alpha_composite(Image.fromarray(frames[0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/EJS2_scene_t000.png')).all())
        for L in M['layers']:
            self.assertEqual(M['scene_loop_ticks'] % (L['phases'] * L['ticks']) if L['phases'] > 1 else 0, 0)

    def test_access(self):
        a = M['access']; self.assertTrue(a['path_found_16x16'])
        ex, ey = a['entry_px']; tx, ty = a['threshold_px']
        self.assertGreater(ey, H - 64); self.assertLess(ty, H // 3)
        self.assertTrue(MASK['praticable'][ey:ey + 16, ex:ex + 16].mean() > 0.9)     # arrivée par l'allée sud
        dp = nd.distance_transform_edt(~MASK['profondeur'])
        self.assertLess(float(dp[ty:ty + 16, tx:tx + 16].min()), 8)                # seuil devant la porte
        self.assertTrue(MASK['marches'][ty:ty + 16, tx:tx + 16].any())             # sur le parvis
        self.assertEqual(a['walkable_cells'] + a['blocked_cells'], (W // 8) * (H // 8))
        self.assertGreater(a['walkable_cells'], 1500)
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text())
        blocked = np.array([[c['Tags'] for c in col] for col in doc['Object']['obstacles']]).T.astype(bool)
        for k in ('profondeur', 'souche', 'temple', 'rochers', 'arbres', 'haies', 'fond', 'rayon'):
            cells = MASK[k].reshape(H // 8, 8, W // 8, 8).mean((1, 3)) > 0.5
            self.assertTrue(blocked[cells].all(), k)
        cells = MASK['praticable'].reshape(H // 8, 8, W // 8, 8).mean((1, 3)) == 1
        self.assertFalse(blocked[cells].any())
        for k in ('rochers', 'arbres', 'haies', 'fond', 'rayon', 'souche', 'profondeur', 'temple', 'embleme'):
            self.assertFalse((MASK['praticable'] & MASK[k]).any(), k)
        # La grande prairie centrale et l'herbe sont presque entièrement praticables.
        for k in ('prairie', 'herbe'):
            self.assertGreater(float(MASK['praticable'][MASK[k]].mean()), 0.95, k)

    def test_prefix_and_namespace_unique(self):
        for p in (R / 'source').glob('*/build.py'):
            if p.parent != HERE:
                s = p.read_text(errors='ignore')
                self.assertNotIn("PFX = 'EJS2'", s, p); self.assertNotIn("'entree_jardin_secret_sud_nord_v2'", s, p)

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
        self.assertEqual({m['EntName'] for m in o['Entities'][0]['Markers']}, {'entrance', 'donjon_seuil'})
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))


if __name__ == '__main__':
    unittest.main()
