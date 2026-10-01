"""Tests dédiés — Fin Ruine (FRP1), fosse de Sealed Ruin, 4:3.
.venv/bin/python -m unittest source.fin_ruine_puits_v1.test_build -v
Contrôles d'images, de formats, de cadence, de grille et d'accès : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, unittest, zipfile
import numpy as np
from scipy import ndimage
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/fin_ruine_puits_v1'
S = R / '.cache/fin_ruine_puits_v1/fin_ruine_puits'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
ANIM = ('aura', 'tourbillons', 'fissure', 'feux_follets')
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


def alpha(a):
    return a[..., 3] == 255


VIO = {tuple(c) for c in M['fissure']['rampe']}


def colors(a):
    return {tuple(int(v) for v in c) for c in np.unique(a[alpha(a)][:, :3], axis=0)}


FLOOR = np.array(Image.open(O / 'masques/FRP1_masque_floor.png')) > 0
STONE = alpha(STACK['cle_de_voute'][0])


class Build(unittest.TestCase):
    def test_bruts_references(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        ref = {r['file'].split('/')[-1]: r['images'] for r in M['raw_inputs']}
        self.assertEqual(ref['decor_magenta.png'], ['Sealed_Ruin_pit_TDS.png'])              # vraie fin du jeu en référence
        self.assertEqual(ref['pierre_magenta.png'], ['Sealed_Ruin_pit_TDS.png'])
        self.assertEqual(ref['sol_complet.png'], ['Sealed_Ruin_pit_TDS.png decoupe [220, 130, 440, 360]'])
        f = M['fidelite']
        self.assertEqual(f['seuil'], 35); self.assertLess(f['distance'], 35); self.assertLess(f['distance_parois'], 35)
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])

    def test_calques_ordre_tailles_alpha(self):
        self.assertEqual(NAMES, ['sol_complet', 'ombre_parois', 'aura', 'tourbillons', 'parois', 'cle_de_voute', 'fissure', 'feux_follets'])
        files = [Path(p).name for p in ORDER]
        self.assertTrue(all(n.startswith('FRP1_') for n in files)); self.assertEqual(len(files), len(set(files)))
        self.assertEqual((W, H, W * 3), (768, 576, H * 4))                                  # 4:3
        for frames in STACK.values():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W)); self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255})
                v = a[alpha(a)].astype(int)                                                  # plus de magenta
                self.assertEqual(int(((v[:, 0] > 200) & (v[:, 2] > 200) & (v[:, 1] < 90)).sum()), 0)
        v = STACK['parois'][0][alpha(STACK['parois'][0])].astype(int)                       # parois grises (niche neutralisée)
        self.assertEqual(int(((np.minimum(v[:, 0], v[:, 2]) - v[:, 1]) > 6).sum()), 0)

    def test_couverture_et_parois(self):
        self.assertTrue(alpha(STACK['sol_complet'][0]).all())
        self.assertTrue((alpha(STACK['parois'][0]) == ~FLOOR).all())
        sh = alpha(STACK['ombre_parois'][0]); self.assertFalse((sh & ~FLOOR).any()); self.assertGreater(int(sh.sum()), 2000)
        base = STACK['sol_complet'][0][sh][:, :3].astype(float).mean(); dark = STACK['ombre_parois'][0][sh][:, :3].astype(float).mean()
        self.assertLess(dark, base * 0.85)                                                   # l'ombre assombrit

    def test_cle_de_voute_et_fissure(self):
        c = M['cle_de_voute']; ys, xs = np.nonzero(STONE)
        self.assertEqual((xs.max() - xs.min() + 1, ys.max() + 1), (c['taille_px'][0], c['base_y']))
        self.assertLess(ys.max(), H // 3); self.assertLess(abs(xs.mean() - W / 2), 24)       # niche nord, au centre
        self.assertLessEqual(len(colors(STACK['cle_de_voute'][0])), 16)
        v = STACK['cle_de_voute'][0][STONE][:, :3].astype(int)
        self.assertGreater(int(((v[:, 2] - v[:, 1]) >= 10).sum()), 5)                         # teinte violette de la fissure gardée
        fr = STACK['fissure']; g = alpha(fr[0])
        self.assertFalse((g & ~STONE).any()); self.assertGreater(int(g.sum()), 30)
        lum = lambda a: float(a[g][:, :3].astype(float).mean())
        for a in fr:
            self.assertTrue((alpha(a) == g).all()); self.assertTrue(colors(a) <= VIO)
        self.assertTrue((fr[0] == fr[5]).all() and (fr[2] == fr[3]).all())
        self.assertLess(lum(fr[0]), lum(fr[1])); self.assertLess(lum(fr[1]), lum(fr[2]))
        self.assertEqual((PH['fissure'], TK['fissure']), (6, 10))

    def test_aura_au_sol(self):
        fr = STACK['aura']; au = {tuple(c) for c in M['aura']['couleurs']}
        n = [int(alpha(a).sum()) for a in fr]
        for a in fr:
            self.assertFalse((alpha(a) & ~(FLOOR & ~STONE)).any()); self.assertTrue(colors(a) <= au)
            ys, xs = np.nonzero(alpha(a)); self.assertLess(ys.max(), M['cle_de_voute']['base_y'] + 30)
        self.assertEqual(n[0], n[5]); self.assertLess(n[0], n[1]); self.assertLess(n[1], n[2])  # la densité pulse
        self.assertEqual((PH['aura'], TK['aura']), (6, 10))

    def test_tourbillons_de_l_entree(self):
        fr = STACK['tourbillons']; dust = {tuple(c) for c in M['tourbillons']['couleurs']}
        self.assertIn('entree_ruine_sud_nord_v1/bruts/tourbillon_8_poses.png', M['tourbillons']['origine'])
        self.assertEqual(len(M['tourbillons']['positions']), 2)
        for a in fr:
            self.assertFalse((alpha(a) & ~(FLOOR & ~STONE)).any()); self.assertTrue(colors(a) <= dust); self.assertGreater(int(alpha(a).sum()), 20)
        self.assertTrue(all((fr[t] != fr[(t + 1) % len(fr)]).any() for t in range(len(fr))))
        self.assertEqual((PH['tourbillons'], TK['tourbillons']), (8, 5))

    def test_feux_follets(self):
        fr = STACK['feux_follets']; ys0, xs0 = np.nonzero(STONE)
        for a in fr:
            self.assertTrue(colors(a) <= VIO); m = alpha(a)
            self.assertGreater(int(m.sum()), 0)                                               # toujours un feu follet
            ys, xs = np.nonzero(m)
            self.assertLess(ys.max(), ys0.max()); self.assertLess(abs(xs.mean() - xs0.mean()), 24)   # au-dessus de la pierre
        tops = [int(np.nonzero(alpha(fr[t]).any(1))[0].min()) for t in range(0, 8)]
        self.assertTrue(all(tops[i + 1] <= tops[i] for i in range(len(tops) - 2)), tops)       # ils montent
        self.assertGreaterEqual(max(int(alpha(a).sum()) for a in fr), 40)                      # assez gros pour se voir
        self.assertEqual((PH['feux_follets'], TK['feux_follets']), (24, 5))

    def test_ora_et_scene(self):
        with zipfile.ZipFile(O / 'FRP1_fin_ruine_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
        sc = Image.new('RGBA', (W, H))
        for n in NAMES:
            sc.alpha_composite(Image.fromarray(STACK[n][0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/FRP1_scene_t000.png')).all())
        for k in ANIM:
            self.assertEqual(M['scene_loop_ticks'] % (PH[k] * TK[k]), 0, k)

    def test_acces_fin_de_donjon(self):
        a = M['access']; mk = a['markers']
        self.assertTrue(a['chemins_16x16']['boss']['ok']); self.assertTrue(a['chemins_16x16']['cle_de_voute']['ok'])
        self.assertGreater(mk['entrance'][1], H - 40)                                          # arrivée au sud
        self.assertTrue(H // 3 < mk['boss'][1] < 3 * H // 4)                                  # arène au centre
        ys, xs = np.nonzero(STONE)
        self.assertTrue(0 <= mk['cle_de_voute'][1] - ys.max() < 16)                          # devant la pierre, pas dedans
        self.assertLess(abs(mk['cle_de_voute'][0] + 8 - xs.mean()), 16)
        walk = FLOOR & ~STONE                                                                 # aucune sortie hors du sud
        self.assertFalse(walk[:16].any() or walk[:, :16].any() or walk[:, -16:].any())
        self.assertTrue(walk[-8:].any())
        free = ~(~walk).reshape(H // 8, 8, W // 8, 8).mean((1, 3)).__gt__(0.25)             # grille de collision
        lab, _ = ndimage.label(free); comp = lab == lab[mk['entrance'][1] // 8, mk['entrance'][0] // 8]
        self.assertFalse(comp[:ys.min() // 8].any())                                         # la pierre ferme la niche
        self.assertEqual(int((~free).sum()), a['blocked_cells'])

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
        self.assertEqual({m['EntName'] for m in o['Entities'][0]['Markers']}, {'entrance', 'boss', 'cle_de_voute'})
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))
        self.assertNotIn('warp', (S / f"Data/Script/{M['pmdo']['namespace']}/ground/{M['pmdo']['asset']}/init.lua").read_text().replace('aucun warp', ''))


if __name__ == '__main__':
    unittest.main()
