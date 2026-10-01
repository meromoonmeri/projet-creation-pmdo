"""Tests dédiés — Arène de Terapagos, cristal prismatique (ATP1), 4:3.
.venv/bin/python -m unittest source.arene_terapagos_v1.test_build -v
Contrôles d'images, de formats, de lois d'animation, de grille et d'accès : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, re, unittest, zipfile
import numpy as np
from scipy import ndimage
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/arene_terapagos_v1/ATP1'
S = R / '.cache/arene_terapagos_v1/arene_terapagos'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
ANIM = ('reflets', 'embleme', 'runes', 'scintillements')
PH = {k: M[k]['phases'] for k in ANIM}
TK = {k: M[k]['frame_length_ticks'] for k in ANIM}


def load(p):
    return np.array(Image.open(p).convert('RGBA'))


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


def name_of(p):
    return re.sub(r'_fN+$', '', Path(p).stem.split('_', 2)[2])


def expand(p):
    mt = re.search(r'fN+', p)
    if mt:
        w = len(mt.group()) - 1
        return [load(O / p.replace(mt.group(), f'f{t:0{w}d}')) for t in range(PH[name_of(p)])]
    return [load(O / p)]


ORDER = M['layer_order_bottom_to_top']
NAMES = [name_of(p) for p in ORDER]
STACK = {n: expand(p) for n, p in zip(NAMES, ORDER)}
MASK = {k: np.array(Image.open(O / f'masques/ATP1_masque_{k}.png')) > 0 for k in ('sol', 'cristaux', 'embleme', 'runes')}
RL = np.array(Image.open(O / 'masques/ATP1_etiquettes_runes.png')).astype(int) // 18
B = loadmod('atp1_build', HERE / 'build.py')
SPEC = np.array(M['spectre']['tons'])
SPEC_SET = {tuple(int(v) for v in c) for c in SPEC.reshape(-1, 3)}


def alpha(a):
    return a[..., 3] == 255


def colors(a, m=None):
    m = alpha(a) if m is None else m
    return {tuple(int(v) for v in c) for c in np.unique(a[m][:, :3], axis=0)}


class Build(unittest.TestCase):
    def test_bruts_references_fidelite(self):
        raw, = M['raw_inputs']
        self.assertEqual(hashlib.sha256((R / raw['file']).read_bytes()).hexdigest(), raw['sha256'])
        with Image.open(R / raw['file']) as im:
            self.assertEqual(list(im.size), raw['size']); self.assertEqual(raw['size'], [1200, 896])   # 4:3
        self.assertTrue(raw['utilise']); self.assertEqual(raw['editions'], 0)
        self.assertEqual(raw['images'], ['source/arene_terapagos_v1/reference/D17P45A_decoupe_x2.png',
                                         'source/arene_terapagos_v1/reference/D42P42A_etoile_decoupe_x2.png'])
        for p in raw['images']:
            self.assertTrue((R / p).exists())
        for code, ref in M['references_da'].items():
            self.assertEqual(hashlib.sha256((R / ref['fichier']).read_bytes()).hexdigest(), ref['sha256'], code)
        an = M['reference_animation']
        self.assertEqual(hashlib.sha256((R / an['fichier']).read_bytes()).hexdigest(), an['sha256'])
        f = M['fidelite']; self.assertEqual(f['seuil'], 35); self.assertEqual(sorted(f['seuille']), ['cristaux', 'sol'])
        sc = np.array(Image.open(O / 'review/ATP1_scene_t000.png').convert('RGB')).astype(int)   # recalcul, même règle
        ref = np.array(Image.open(R / M['references_da']['D17P45A']['fichier']).convert('RGB')).astype(int)
        glow = B.morph(ndimage.binary_dilation, MASK['embleme'] | MASK['runes'], 3)
        again = B.fidelity(Image.fromarray(sc.astype('uint8')), glow)
        for k in ('sol', 'cristaux'):
            self.assertLess(f[k]['distance'], 35, k)
            self.assertAlmostEqual(again[k]['distance'], f[k]['distance'], places=2)
            self.assertGreater(f[k]['part_ref'], 0.1); self.assertGreater(f[k]['part_scene'], 0.1)
        self.assertGreater(float((B.floor_rule(sc) & MASK['sol']).sum() / B.floor_rule(sc).sum()), 0.95)   # règle = vrai sol
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])

    def test_calques_ordre_tailles_alpha(self):
        self.assertEqual(NAMES, ['sol_complet', 'sol', 'cristaux', 'reflets', 'embleme', 'runes', 'scintillements'])
        files = [Path(p).name for p in ORDER]
        self.assertTrue(all(n.startswith('ATP1_') for n in files)); self.assertEqual(len(files), len(set(files)))
        self.assertEqual((W, H, W * 3), (768, 576, H * 4))                                  # 4:3
        for n, frames in STACK.items():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W)); self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255})
                self.assertNotIn((255, 0, 255), colors(a), n)
                v = a[alpha(a)].astype(int)                                                  # fixes : ni magenta ni liseré rosé
                if len(frames) == 1:                                                         # (animés : tons du spectre seulement)
                    self.assertEqual(int(((v[:, 0] - v[:, 1] > 45) & (v[:, 2] - v[:, 1] > 35)).sum()), 0, n)
        for n in ('sol_complet', 'sol', 'cristaux'):                                           # aucun vert de gravure resté
            v = STACK[n][0][alpha(STACK[n][0])].astype(int)
            self.assertEqual(int(((v[:, 1] - np.maximum(v[:, 0], v[:, 2]) > 30)).sum()), 0, n)
        self.assertTrue(alpha(STACK['sol_complet'][0]).all())
        sol, cr = alpha(STACK['sol'][0]), alpha(STACK['cristaux'][0])
        self.assertTrue((sol == MASK['sol']).all()); self.assertTrue((cr == MASK['cristaux']).all())
        self.assertFalse((sol & cr).any()); self.assertTrue((sol | cr).all())                 # partition exacte
        self.assertLessEqual(len(colors(STACK['cristaux'][0])), 64)
        self.assertTrue(0.15 < float(sol.mean()) < 0.5)

    def test_spectre(self):
        self.assertEqual(SPEC.shape, (12, 5, 3))
        self.assertTrue(((SPEC % 8 == 7) | (SPEC == 255)).all())                               # tons 5 bits NDS
        self.assertEqual(len(SPEC_SET), 60)
        hues = [np.argmax(SPEC[h, 0]) for h in (0, 4, 8)]; self.assertEqual(hues, [0, 1, 2])    # rouge, vert, bleu
        for h in range(12):
            lum = SPEC[h] @ [.299, .587, .114]; self.assertTrue((np.diff(lum) > 0).all(), h)    # niveaux croissants
        self.assertTrue((SPEC == B.SPEC).all())

    def test_embleme_pulse_au_sol(self):
        fr = STACK['embleme']; E = M['embleme']; emb = MASK['embleme']
        self.assertEqual((PH['embleme'], TK['embleme']), (36, 5))
        self.assertTrue((emb & ~MASK['sol']).sum() == 0); self.assertGreater(int(emb.sum()), 5000)   # gravé à plat dans le sol
        cx, cy = E['centre_xy']; ys, xs = np.nonzero(emb)
        self.assertLess(abs(xs.mean() - cx), 6); self.assertLess(abs(ys.mean() - cy), 6)
        want = B.emblem_frames(emb, MASK['sol'] & ~MASK['runes'], (cy, cx), E['rayon_anneau'])
        far = ~B.morph(ndimage.binary_dilation, emb, 2)
        yy, xx = np.mgrid[:H, :W]; rad = np.hypot(yy - cy, xx - cx) / E['rayon_anneau']
        for t, a in enumerate(fr):
            self.assertTrue((a == want[t]).all(), t)                                             # loi recalculée
            self.assertTrue(alpha(a)[emb].all()); self.assertFalse((alpha(a) & far).any())
            self.assertFalse((alpha(a) & ~MASK['sol']).any()); self.assertTrue(colors(a) <= SPEC_SET)
            self.assertTrue((a != fr[(t + 1) % 36]).any())
        lv = lambda a, m: float((a[m][:, :3].astype(float) @ [.299, .587, .114]).mean())
        inner, outer = emb & (rad < 0.35), emb & (rad > 0.8)
        seq_in = [lv(a, inner) for a in fr]; seq_out = [lv(a, outer) for a in fr]
        self.assertGreater(max(seq_in) - min(seq_in), 60)                                        # pulsation visible
        lag = (int(np.argmax(seq_out)) - int(np.argmax(seq_in))) % 36
        self.assertTrue(8 <= lag <= 18, lag)                                                   # l'onde part du centre
        look = {tuple(int(v) for v in SPEC[h, l]): h for h in range(12) for l in range(5)}
        ring = emb & (rad > 0.9)
        for t in (0, 9, 35):                                                                     # le spectre complet, qui tourne
            hs = np.array([look[tuple(int(v) for v in c)] for c in fr[t][ring][:, :3]])
            self.assertEqual(set(hs.tolist()), set(range(12)), t)
        east = ring & (xx > cx) & (abs(yy - cy) < 4)
        h0 = [look[tuple(int(v) for v in fr[t][east][0, :3])] for t in (0, 3)]
        self.assertEqual((h0[1] - h0[0]) % 12, 1)                                                # +1 teinte tous les 3 pas

    def test_runes_tour_a_tour(self):
        fr = STACK['runes']; RU = M['runes']; n = RU['nombre']
        self.assertEqual((n, PH['runes'], TK['runes']), (14, 36, 5))
        self.assertEqual(int(RL.max()), n); self.assertTrue(((RL > 0) == MASK['runes']).all())
        self.assertFalse((MASK['runes'] & MASK['embleme']).any()); self.assertFalse((MASK['runes'] & ~MASK['sol']).any())
        ang = RU['angles_deg']; self.assertEqual(ang, sorted(ang)); self.assertTrue(all(15 < d < 40 for d in np.diff(ang)))
        want = B.rune_frames(RL, MASK['sol'] & ~MASK['embleme'], n)
        peaks = []
        for t, a in enumerate(fr):
            self.assertTrue((a == want[t]).all(), t); self.assertTrue(colors(a) <= SPEC_SET)
            self.assertTrue(alpha(a)[MASK['runes']].all())                                     # toujours lisibles
        for k in range(1, n + 1):
            m = RL == k; seq = [float((a[m][:, :3].astype(float) @ [.299, .587, .114]).mean()) for a in fr]
            peaks.append(int(np.argmax(seq)))
            self.assertTrue(len(colors(fr[peaks[-1]], m)) == 1)
        self.assertEqual(peaks, [round((k - 1) * 36 / n) for k in range(1, n + 1)])               # sens horaire depuis le nord
        self.assertEqual(len({tuple(fr[p][RL == k][0, :3]) for k, p in enumerate(peaks, 1)}), 12)   # teinte par rune

    def test_reflets_spectre_boucle(self):
        fr = STACK['reflets']; self.assertEqual((PH['reflets'], TK['reflets']), (54, 10))
        want, info = B.reflect_frames(STACK['cristaux'][0], MASK['cristaux'])
        self.assertAlmostEqual(info['q75'], M['reflets']['seuils_luminance']['q75'], places=1)
        yy, xx = np.mgrid[:H, :W]; s = xx + 0.6 * yy
        for t, a in enumerate(fr):
            self.assertTrue((a == want[t]).all(), t)
            self.assertFalse((alpha(a) & ~MASK['cristaux']).any()); self.assertTrue(colors(a) <= SPEC_SET)
            self.assertTrue((a != fr[(t + 1) % 54]).any())
        self.assertGreater(int(alpha(fr[0]).sum()), 1000)
        lum = STACK['cristaux'][0][..., :3].astype(float) @ [.299, .587, .114]
        hi = MASK['cristaux'] & (lum >= info['q75']); D = info['D']; bw = M['reflets']['demi_largeur']
        band = lambda t: hi & ((np.abs(s - (-bw + t / 54 * D)) < bw) | (np.abs(s - (-bw + t / 54 * D + D)) < bw))
        self.assertTrue((band(54) == alpha(fr[0])).all())                                        # raccord 53 -> 0 exact
        self.assertTrue((band(27) == alpha(fr[27])).all())
        first = [alpha(fr[t]) & (s < t / 54 * D) for t in range(5, 50)]                       # 1re bande seule
        mid = [float(s[m].mean()) for m in first if m.sum() > 50]
        self.assertGreater(len(mid), 30); self.assertTrue(all(b > a for a, b in zip(mid, mid[1:])))                     # la bande avance

    def test_scintillements_loi_rom(self):
        fr = STACK['scintillements']; SC = M['scintillements']
        self.assertEqual((PH['scintillements'], TK['scintillements'], len(SC['liste'])), (54, 10, 44))
        fo = SC['formes_rom']; self.assertEqual((fo['grande']['pixels'], fo['petite']['pixels']), (17, 5))
        self.assertEqual(max(fo['grande']['periodes_rom'], key=fo['grande']['periodes_rom'].get), '16')
        self.assertEqual(max(fo['petite']['periodes_rom'], key=fo['petite']['periodes_rom'].get), '11')
        self.assertEqual((fo['grande']['periode_ici'], fo['petite']['periode_ici']), (18, 9))
        self.assertTrue(all(54 % p == 0 for p in (18, 9)))
        want, pick, _ = B.sparkle_frames(MASK['cristaux'], STACK['cristaux'][0])
        self.assertEqual(pick, SC['liste'])
        for t, a in enumerate(fr):
            self.assertTrue((a == want[t]).all(), t)
            self.assertFalse((alpha(a) & ~MASK['cristaux']).any()); self.assertTrue(colors(a) <= SPEC_SET)
        for p in SC['liste'][:12]:                                                             # éclat puis décroissance
            P = 18 if p['forme'] == 'grande' else 9
            lum = [float(fr[(p['phase'] + k) % 54][p['y'], p['x'], :3].astype(float) @ [.299, .587, .114])
                   if fr[(p['phase'] + k) % 54][p['y'], p['x'], 3] else 0 for k in range(P)]
            self.assertEqual(int(np.argmax(lum)), 0, p); self.assertTrue(all(np.diff(lum) <= 0), p)

    def test_ora_et_scene(self):
        with zipfile.ZipFile(O / 'ATP1_arene_terapagos_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
        sc = Image.new('RGBA', (W, H))
        for n in NAMES:
            sc.alpha_composite(Image.fromarray(STACK[n][0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/ATP1_scene_t000.png')).all())
        for k in ANIM:
            self.assertEqual(M['scene_loop_ticks'] % (PH[k] * TK[k]), 0, k)
        self.assertEqual(M['scene_loop_ticks'], 540)

    def test_acces_arene(self):
        a = M['access']; mk = a['markers']
        self.assertTrue(all(p['ok'] for p in a['chemins_16x16'].values()))
        self.assertGreater(mk['entrance'][1], H - 40); self.assertLess(abs(mk['entrance'][0] + 8 - W // 2), 40)   # arrivée au sud
        walk = alpha(STACK['sol'][0])
        self.assertEqual(ndimage.label(walk)[1], 1)                                            # un seul sol continu
        self.assertTrue(walk[H - 1].any())
        self.assertFalse(walk[:, :16].any() or walk[:, -16:].any() or walk[:40].any())         # ni sortie latérale ni au nord
        xs = np.nonzero(walk[H - 1])[0]; self.assertLess(xs.max() - xs.min(), 140)              # seul le couloir arrive au sud
        free = ~(~walk).reshape(H // 8, 8, W // 8, 8).mean((1, 3)).__gt__(0.25)
        self.assertEqual(int((~free).sum()), a['blocked_cells'])
        cx, cy = M['embleme']['centre_xy']; r = M['embleme']['rayon_anneau']
        self.assertLess(np.hypot(mk['boss'][0] + 8 - cx, mk['boss'][1] + 8 - cy), 16)           # boss sur l'emblème
        self.assertGreater(mk['heros'][1] + 8, cy + r); self.assertLess(mk['heros'][1], mk['entrance'][1])
        for k in ('boss', 'heros', 'entrance'):
            x, y = mk[k]; self.assertTrue(free[y // 8:y // 8 + 2, x // 8:x // 8 + 2].all(), k)
        self.assertTrue(free[MASK['embleme'].reshape(H // 8, 8, W // 8, 8).any((1, 3))].mean() > 0.95)   # l'emblème se traverse

    def test_ground_aller_retour(self):
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text()); o = doc['Object']
        self.assertEqual(doc['Version'], '0.8.12.0'); self.assertEqual(len(o['Layers']), len(NAMES) + 1)
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
