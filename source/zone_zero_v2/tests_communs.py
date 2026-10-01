"""Tests partagés — Réseau Zone Zéro V2 (routes fleuries RAF1, RAF2).
Utilisé par source/zone_zero_v2/raf1/test_build.py et raf2/test_build.py :
.venv/bin/python -m unittest source.zone_zero_v2.raf1.test_build -v
Contrôles d'images, de formats, de cadence, de mouvement, de grille et d'accès : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, unittest, zipfile
import numpy as np
from scipy import ndimage
from PIL import Image

V2 = Path(__file__).resolve().parent
R = V2.parents[1]
NAMES_ATTENDUS = ['sol_complet', 'abime', 'brume_profonde', 'brume_haute', 'lueurs', 'eau', 'sol', 'falaises',
                  'herbes', 'fleurs', 'buissons', 'arbres', 'cascades', 'ecume', 'embruns', 'papillons']
SKY_GRASS = (135, 247, 119)                      # ton dominant du GIF Sky Peak (passe haute qualité)


def load(p):
    return np.array(Image.open(p).convert('RGBA'))


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


def alpha(a):
    return a[..., 3] == 255


def colors(a):
    return {tuple(int(v) for v in c) for c in np.unique(a[alpha(a)][:, :3], axis=0)}


def famille(c):
    """Famille de couleur d'une tête de fleur (teinte grossière)."""
    r, g, b = (int(v) for v in c)
    if min(r, g, b) > 205:
        return 'blanc'
    if r > g + 40 and r > b + 20:
        return 'rouge_rose'
    if r > 180 and g > 160 and b < g - 40:
        return 'jaune'
    if b > r + 20 and b > g - 10:
        return 'bleu'
    if r > g + 30 and b > g + 30:
        return 'violet'
    return 'autre'


def make(lot):
    PFX = lot.upper()
    HERE = V2 / lot
    O = R / 'renders/zone_zero_v2' / PFX
    B = loadmod(f'{lot}_build', V2 / 'build.py')
    CF = B.CFG[lot]
    S = R / '.cache/zone_zero_v2' / CF['NAMESPACE']
    M = json.loads((O / 'manifest.json').read_text())
    W, H = M['size_px']
    AN = M['animations']
    ORDER = M['layer_order_bottom_to_top']

    def name_of(p):
        return Path(p).stem.split('_', 2)[2].replace('_fNN', '')

    def expand(p):
        if 'fNN' in p:
            return [load(O / p.replace('fNN', f'f{t:02d}')) for t in range(AN[name_of(p)]['phases'])]
        return [load(O / p)]

    NAMES = [name_of(p) for p in ORDER]
    STACK = {n: expand(p) for n, p in zip(NAMES, ORDER)}
    C = B.C
    MASK = {k: np.array(Image.open(O / f'masques/{PFX}_masque_{k}.png')) > 0
            for k in ('sol', 'vide', 'falaises', 'vegetation', 'eau', 'cascades', 'escaliers', 'fleurs', 'lisiere', 'troncs',
                      'praticable')}
    DEP = np.array(Image.open(O / f'masques/{PFX}_profondeur.png')).astype(float) / 255

    def scene(tick):
        im = Image.new('RGBA', (W, H))
        for n in NAMES:
            fr = STACK[n]
            im.alpha_composite(Image.fromarray(fr[(tick // AN[n]['frame_length_ticks']) % len(fr)] if n in AN else fr[0]))
        return np.array(im)

    class Build(unittest.TestCase):
        def test_bruts_references_fidelite(self):
            for r in M['raw_inputs']:
                self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
                self.assertEqual(r['size'], [1200, 896])                                       # bruts 4:3
            self.assertEqual([Path(r['file']).name for r in M['raw_inputs']], CF['chaine'] + [CF['gouffre']])
            for k in ('sky_peak', 'apple_woods', 'brut_v1'):
                ref = M['references'][k]
                self.assertEqual(hashlib.sha256((R / ref['fichier']).read_bytes()).hexdigest(), ref['sha256'], k)
            f = M['fidelite']; self.assertEqual(f['seuil'], 35); self.assertEqual(f['seuille'], ['herbe', 'arbres'])
            for k in f['seuille']:
                self.assertLess(f[k]['distance'], 35, k)
            # matière principale : herbe Sky Peak. Passe HQ = aplat au ton DOMINANT du GIF (135,247,119), qui est à 11,4 de la
            # moyenne de la règle herbe du GIF (elle compte aussi les tons d'ombre) : seuil strict 15 (seuil documenté 35)
            self.assertLess(f['herbe']['distance'], 15)
            self.assertIn('falaises', f['signale'])                                            # signalées, jamais cachées
            rej = M['arbres_source']['planches_rejetees']
            self.assertEqual(len(rej), 2); self.assertTrue(all(x['distance_apple_woods'] > 35 for x in rej))
            self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])

        def test_calques_ordre_tailles_alpha(self):
            att = list(NAMES_ATTENDUS)
            if CF.get('cristaux'):                                                              # cristaux : base + reflets après falaises
                i = att.index('falaises') + 1; att[i:i] = ['cristaux', 'reflets']
            self.assertEqual(NAMES, att)
            files = [Path(p).name for p in ORDER]
            self.assertTrue(all(n.startswith(PFX + '_') for n in files)); self.assertEqual(len(files), len(set(files)))
            self.assertEqual((W, H, W * 3), (768, 576, H * 4))                                  # 4:3
            for n, frames in STACK.items():
                for a in frames:
                    self.assertEqual(a.shape[:2], (H, W)); self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255})
                    v = a[alpha(a)].astype(int)                                                  # plus de magenta
                    self.assertEqual(int(((v[:, 0] > 200) & (v[:, 2] > 200) & (v[:, 1] < 90)).sum()), 0, n)

        def test_couverture_et_calques_propres(self):
            solc, ab = alpha(STACK['sol_complet'][0]), alpha(STACK['abime'][0])
            self.assertTrue((solc | ab).all()); self.assertFalse((solc & ab).any())
            self.assertTrue((ab == MASK['vide']).all())
            for n in ('brume_profonde', 'brume_haute', 'lueurs'):                                # la profondeur reste dans le trou
                for a in STACK[n]:
                    self.assertFalse((alpha(a) & ~MASK['vide']).any(), n)
            fl = alpha(STACK['fleurs'][0]); tr = alpha(STACK['arbres'][0]); cs = alpha(STACK['cascades'][0])
            self.assertGreater(fl.sum(), 800); self.assertGreater(tr.sum(), 8000); self.assertGreater(cs.sum(), 3000)
            self.assertFalse((fl & alpha(STACK['sol'][0]) & ~MASK['fleurs']).any())
            self.assertFalse((tr & MASK['vide']).any()); self.assertFalse((cs & MASK['vide']).any())

        def test_profondeur_du_gouffre(self):
            v = MASK['vide']; self.assertGreater(v.sum(), 20000)
            deep, rim = v & (DEP > 0.7), v & (DEP < 0.25)
            self.assertGreater(deep.sum(), 2000); self.assertGreater(rim.sum(), 2000)
            lum = [scene(t)[..., :3].astype(float) @ [.299, .587, .114] for t in (0, 120, 240, 360)]
            for L in lum:                                                                       # le fond est plus sombre que les parois
                self.assertLess(L[deep].mean() + 20, L[rim].mean())
            for n, pas in (('brume_profonde', 4), ('brume_haute', -8)):
                fr = STACK[n]; ph = len(fr)
                self.assertEqual((ph, M['profondeur'][n]['pas_px']), (24, pas))
                al = [alpha(a) for a in fr]
                ch = [float(((fr[t] != fr[(t + 1) % ph]).any(2) & v).sum() / max(1, (al[t] | al[(t + 1) % ph]).sum())) for t in range(ph)]
                self.assertGreater(min(ch), 0.2, n); self.assertLess(max(ch) / min(ch), 3, n)       # bouge à chaque phase, raccord fermé
                self.assertTrue(all(a.sum() > 50 for a in al), n)                                   # jamais vide
            self.assertGreater(np.mean([alpha(a)[deep].mean() for a in STACK['brume_profonde']]), 0.15)
            self.assertGreater(np.mean([alpha(a)[v].mean() for a in STACK['brume_haute']]), 0.01)
            hd = np.mean([alpha(a)[deep].mean() for a in STACK['brume_profonde']])
            hr = np.mean([alpha(a)[rim].mean() for a in STACK['brume_profonde']])
            self.assertGreater(hd, hr + 0.1)                                                   # la brume épaissit vers le fond
            g = M['profondeur']['lueurs']; self.assertEqual(g['nombre'], 34)
            gf = STACK['lueurs']; lit = np.zeros((H, W), bool)
            for a in gf:
                lit |= alpha(a)
            self.assertLess(DEP[lit].min(), 1.01); self.assertGreater(np.median(DEP[lit]), 0.6)
            self.assertTrue(all(alpha(a).sum() > 0 for a in gf))

        def test_fleurs_multicolores_loi_sky_peak(self):
            fr = STACK['fleurs']; self.assertEqual((len(fr), AN['fleurs']['frame_length_ticks']), (4, 12))
            self.assertTrue((fr[0] == fr[2]).all())                                             # A B A C
            self.assertFalse((fr[0] == fr[1]).all()); self.assertFalse((fr[0] == fr[3]).all()); self.assertFalse((fr[1] == fr[3]).all())
            area = ndimage.binary_dilation(MASK['fleurs'], iterations=2)
            for a in fr:
                self.assertFalse((alpha(a) & ~area).any())
            fam = {}
            for c in colors(fr[0]):
                k = famille(c); fam[k] = fam.get(k, 0) + 1
            a = fr[0]; px = a[alpha(a)][:, :3]
            cnt = {}
            for c in px[::3]:
                k = famille(c); cnt[k] = cnt.get(k, 0) + 1
            vives = [k for k in ('blanc', 'rouge_rose', 'jaune', 'bleu', 'violet') if cnt.get(k, 0) >= 30]
            self.assertGreaterEqual(len(vives), 3, cnt)                                        # fleurs de différentes couleurs
            pal = M['fleurs']['palettes']; cs = colors(fr[0])
            presentes = [k for k, v in pal.items() if tuple(v[0]) in cs]
            self.assertGreaterEqual(len(presentes), 6, presentes)                                # plein de couleurs (HQ)
            self.assertEqual(sorted(M['fleurs']['couleurs']), sorted(presentes))
            self.assertGreater(M['fleurs']['tetes'], 30)
            libres = MASK['fleurs'] & ~MASK['lisiere'] & ~MASK['troncs'] & ~alpha(STACK['arbres'][0]) & ~MASK['vegetation']
            self.assertGreater(libres.sum(), 500); self.assertTrue((libres <= MASK['praticable']).all())   # on marche sur les fleurs

        def test_haute_qualite(self):
            hq = M['haute_qualite']; sol = STACK['sol'][0]; so = alpha(sol)
            flat = so & (sol[..., :3] == SKY_GRASS).all(2)
            gr = so & B.grass_rule(sol[..., :3].astype(int))
            self.assertGreater(flat.sum() / max(1, gr.sum()), 0.85)                              # herbe = aplat franc
            cols_, cnt_ = np.unique(sol[so][:, :3], axis=0, return_counts=True)
            self.assertEqual(tuple(int(v) for v in cols_[cnt_.argmax()]), SKY_GRASS)
            walk = MASK['praticable']
            # touffes : A B A C, seulement sur l'herbe franche praticable
            tf = STACK['herbes']; self.assertEqual((len(tf), AN['herbes']['frame_length_ticks']), (4, 12))
            self.assertTrue((tf[0] == tf[2]).all()); self.assertFalse((tf[0] == tf[1]).all()); self.assertFalse((tf[1] == tf[3]).all())
            self.assertGreaterEqual(hq['herbes']['touffes'], 40)
            for a in tf:
                m = alpha(a); self.assertGreater(m.sum(), 400)
                self.assertGreater((m & walk).sum() / m.sum(), 0.97)
                self.assertGreater((m & flat).sum() / m.sum(), 0.9)
                self.assertTrue(colors(a) <= {tuple(t) for t in hq['herbes']['tons']})
            ch = np.zeros((H, W), bool)
            for t in range(4):
                ch |= (tf[t] != tf[(t + 1) % 4]).any(2)
            self.assertGreater((ch & flat).sum() / ch.sum(), 0.9)                                # le balancement reste sur l'herbe
            # embruns : au pied des cascades, 24 phases, bougent à chaque phase, boucle fermée
            em = STACK['embruns']; self.assertEqual((len(em), AN['embruns']['frame_length_ticks']), (24, 10))
            near = np.zeros((H, W), bool)
            for c in M['cascades']['rects']:
                near[max(0, c['y0']):c['y1'] + 24, max(0, c['x0'] - 30):c['x1'] + 30] = True
            for t in range(24):
                m = alpha(em[t]); self.assertGreater(m.sum(), 40); self.assertFalse((m & ~near).any())
                self.assertTrue((em[t] != em[(t + 1) % 24]).any(), t)                           # raccord 23 -> 0 compris
                self.assertFalse((m & MASK['vide'] & ~MASK['cascades']).any())
            self.assertGreaterEqual(hq['embruns']['gouttelettes'], 28 * len(M['cascades']['rects']))
            # papillons : >= 5, boucles fermées, pas <= 4 px (raccord compris), couleurs variées, dessinés sur leur trajet
            pp = STACK['papillons']; self.assertEqual((len(pp), AN['papillons']['frame_length_ticks']), (48, 10))
            lst, tj = hq['papillons']['liste'], hq['papillons']['trajets']
            self.assertGreaterEqual(len(lst), 5); self.assertGreaterEqual(len({b['couleur'] for b in lst}), 5)
            for b, path in zip(lst, tj):
                self.assertEqual(len(path), 48)
                for t in range(48):
                    (x0, y0), (x1, y1) = path[t], path[(t + 1) % 48]
                    self.assertLessEqual(max(abs(x1 - x0), abs(y1 - y0)), 4, (b, t))
                    x, y = path[t]; self.assertTrue(alpha(pp[t])[max(0, y - 3):y + 3, max(0, x - 3):x + 4].any(), (b, t))
            for t in range(48):
                self.assertTrue((pp[t] != pp[(t + 1) % 48]).any())
            self.assertFalse(any((alpha(a) & MASK['vide']).any() for a in pp))                   # au-dessus de la prairie

        def test_arbres_pmd(self):
            tr = STACK['arbres'][0]; m = alpha(tr); px = tr[m][:, :3].astype(int)
            green = (px[:, 1] > px[:, 0] + 25) & (px[:, 1] > px[:, 2] + 30)
            self.assertGreater(green.mean(), 0.5)
            self.assertGreaterEqual(len(M['arbres']['plantes']), CF.get('arbres_min', 20))
            self.assertEqual(len(M['arbres_source']['modeles']), 8)
            self.assertFalse((MASK['troncs'] & MASK['praticable']).any())                        # troncs bloquants
            self.assertFalse((m & MASK['praticable']).any())
            wet = MASK['eau'] | MASK['cascades']
            self.assertFalse((m & wet).any())

        def test_cascades_loi_native(self):
            fr = STACK['cascades']; rects = M['cascades']['rects']; pal = {tuple(c) for c in C.CASC_PAL}
            self.assertEqual((len(fr), AN['cascades']['frame_length_ticks']), (3, 10))
            self.assertGreaterEqual(len(rects), 2 if CF.get('chutes_x') else 5)
            if CF.get('chutes_x'):                                                            # seulement les chutes peintes
                self.assertTrue(all(c['y0'] == 0 for c in rects))
            for a in fr:
                self.assertTrue(colors(a) <= pal)
            for c in rects:
                sl = (slice(c['y0'], c['y1']), slice(c['x0'], c['x1'])); h = c['y1'] - c['y0']
                for t in range(3):
                    a, b = fr[t][sl], fr[(t + 1) % 3][sl]
                    self.assertTrue(alpha(a).all())
                    self.assertTrue((a[:h - 32, :, :3] == b[32:, :, :3]).all(), (c, t))          # descend de 32 px par image
                    self.assertFalse((a == b).all())
                if h > 120:
                    col = fr[0][sl][:, (c['x1'] - c['x0']) // 2, :3].astype(int)
                    self.assertTrue((col[96:] == col[:-96]).all())                              # période 96 px
            again = C.cascade_frames(H, W, rects)
            self.assertTrue(all((again[t] == fr[t]).all() for t in range(3)))                   # loi du module P03P01A

        def test_eau_ecume(self):
            wet = MASK['eau']; wd = ndimage.binary_dilation(wet | MASK['cascades'], iterations=1)
            for n in ('eau', 'ecume'):
                fr = STACK[n]; self.assertEqual((len(fr), AN[n]['frame_length_ticks']), (3, 10))
                for a in fr:
                    self.assertFalse((alpha(a) & ~wd).any(), n)                                  # jamais sur la terre
                self.assertTrue(all((fr[t] != fr[(t + 1) % 3]).any() for t in range(3)), n)
            fp = {tuple(c) for c in C.FOAM_PAL}
            self.assertTrue(all(colors(a) <= fp for a in STACK['ecume']))
            for c in M['cascades']['rects']:                                                    # écume au pied de chaque chute
                box = alpha(STACK['ecume'][0][c['y1'] - 8:c['y1'] + 14, c['x0']:c['x1']])
                self.assertGreater(box.mean(), 0.2, c)

        def test_ora_scene_boucle(self):
            with zipfile.ZipFile(O / f'{PFX}_route_fleurie_calques.ora') as z:
                merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
            s0 = scene(0)
            self.assertTrue((s0 == merged).all())
            self.assertTrue((s0 == load(O / f'review/{PFX}_scene_t000.png')).all())
            for k, v in AN.items():
                self.assertEqual(M['scene_loop_ticks'] % (v['phases'] * v['frame_length_ticks']), 0, k)
            self.assertEqual(M['scene_loop_ticks'], 480)
            self.assertTrue((scene(M['scene_loop_ticks']) == s0).all())                        # boucle fermée

        def test_acces_sud_nord(self):
            a = M['access']; mk = a['markers']; walk = MASK['praticable']
            self.assertTrue(all(p['ok'] for p in a['chemins_16x16'].values()))
            self.assertEqual(mk['entrance'][1], H - 16)                                               # arrivée au sud
            if CF.get('sortie_grotte'):                                                               # sortie : bouche du tunnel nord
                self.assertLess(mk['sortie'][1], CF.get('sortie_y_max', 96)); self.assertLess(abs(mk['sortie'][1] - CF['sortie'][1]), 24)
            else:
                self.assertEqual(mk['sortie'][1], 0)                                                  # sortie au bord nord
            self.assertLess(abs(mk['sortie'][0] - CF['sortie'][0]), 24)                               # sortie à l'endroit peint
            self.assertLess(abs(mk['entrance'][0] - CF['entree_x']), 24)
            self.assertFalse((walk & (MASK['vide'] | MASK['eau'] | MASK['cascades'])).any())
            self.assertFalse(walk[:, :8].any() or walk[:, -8:].any())                               # aucune sortie latérale
            free = ~((~walk).reshape(H // 8, 8, W // 8, 8).mean((1, 3)) > 0.25)
            self.assertEqual(int((~free).sum()), a['blocked_cells'])
            st = MASK['escaliers']
            if st.any():                                                                          # escaliers praticables
                self.assertGreater((walk & st).sum() / st.sum(), 0.95)
            bx, by = mk['belvedere']
            d = ndimage.distance_transform_edt(~MASK['vide'])
            self.assertLess(d[by:by + 16, bx:bx + 16].min(), 40)                                    # belvédère près du gouffre

        def test_cristaux_blancs_reflets_arc_en_ciel(self):
            if not CF.get('cristaux'):
                self.assertNotIn('cristaux', NAMES); self.assertIsNone(M.get('cristaux')); self.assertNotIn('reflets', AN)
                return
            cm = M['cristaux']; base = STACK['cristaux'][0]; ba = alpha(base)
            self.assertGreater(ba.sum(), 2500)
            self.assertEqual(ba.sum(), cm['pixels_cristal'] + cm['pixels_contour'])
            tons = {tuple(t) for t in cm['tons_base']} | {tuple(cm['contour'])}
            self.assertTrue(colors(base) <= tons)
            v = base[ba][:, :3].astype(int); body = ba & ~(base[..., :3] == cm['contour']).all(2)
            vb = base[body][:, :3].astype(int)
            self.assertGreater(float((vb @ [.299, .587, .114]).mean()), 200)                       # base blanche
            self.assertLess(float((vb.max(1) - vb.min(1)).mean()), 45)                            # peu saturée
            self.assertGreater(float((vb.min(1) >= 240).mean()), 0.3)
            # les cristaux menthe ont quitté le calque falaises (règle du cœur menthe pâle)
            f = STACK['falaises'][0].astype(int); r, g, b = f[..., 0], f[..., 1], f[..., 2]
            core = alpha(STACK['falaises'][0]) & (g > r + 20) & (abs(b - g) < 25) & (f[..., :3].min(2) > 150)
            self.assertLess(int(core.sum()), 0.02 * ba.sum()); self.assertFalse((ba & alpha(STACK['falaises'][0])).any())
            # reflets : 24 phases x 10, dans les cristaux, chaque phase différente, boucle fermée sur 480 ticks
            rf = STACK['reflets']; self.assertEqual((len(rf), AN['reflets']['frame_length_ticks']), (24, 10))
            self.assertEqual((cm['phases'], cm['frame_length_ticks']), (24, 10))
            halo = ndimage.binary_dilation(body, iterations=1)
            pal = {tuple(c) for c in cm['palette_reflets']}
            for t, a in enumerate(rf):
                self.assertFalse((alpha(a) & ~halo).any(), t); self.assertTrue(colors(a) <= pal, t)
                self.assertGreater(alpha(a).sum(), 0.08 * body.sum(), t)
                self.assertFalse((a == rf[(t + 1) % 24]).all(), t)
            # arc-en-ciel : les 8 teintes présentes à chaque phase ; la couleur change au même pixel (rouge, mauve...)
            arc = {k: np.array(c, float) for k, c in cm['arc_en_ciel'].items()}
            self.assertEqual(list(arc), ['rouge', 'orange', 'jaune', 'vert', 'cyan', 'bleu', 'mauve', 'rose'])
            def teinte(c):
                c = np.array(c, float)
                if c.min() >= 225 and c.max() - c.min() < 30:
                    return 'eclat'
                return min(arc, key=lambda k: np.corrcoef(c - c.mean(), arc[k] - arc[k].mean())[0, 1] * -1)
            tmap = {c: teinte(c) for c in pal}
            for t in (0, 7, 15, 23):
                self.assertEqual({tmap[c] for c in colors(rf[t])} - {'eclat'}, set(arc), t)
            st = np.stack([a for a in rf]); on = st[..., 3] == 255
            ys, xs = np.nonzero(on.sum(0) >= 6)
            vus = []
            for y, x in list(zip(ys, xs))[::max(1, len(ys) // 200)]:
                vus.append(len({tmap[tuple(int(u) for u in st[t, y, x, :3])] for t in range(24) if on[t, y, x]} - {'eclat'}))
            self.assertGreaterEqual(max(vus), 4); self.assertGreater(float(np.mean(vus)), 1.5)
            # éclats scintillants 1-2-3-2-1
            self.assertGreaterEqual(cm['eclats'], 12)
            self.assertGreater(sum(((a[..., :3] == 255).all(2) & alpha(a)).sum() for a in rf), cm['eclats'] * 3)

        def test_ground_aller_retour(self):
            doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text()); o = doc['Object']
            self.assertEqual(doc['Version'], '0.8.12.0'); self.assertEqual(len(o['Layers']), len(NAMES) + 1)
            self.assertEqual(o['Layers'][-1]['Layer'], 4)
            nr = loadmod('native_reader', R / 'source/cote_v5_expeditions/audit_references.py')
            banks = {p.stem: nr.tiles(p)[1] for p in (S / 'Content/Tile').glob('*.tile')}
            self.assertEqual(set(banks), set(M['pmdo']['banks']))
            for li, n in enumerate(NAMES):
                frames = STACK[n]; ticks = AN[n]['frame_length_ticks'] if n in AN else 60
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
            self.assertEqual([m['EntName'] for m in o['Entities'][0]['Markers']], ['entrance', 'sortie', 'belvedere'])
            tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
            self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))

    Build.__name__ = f'Build{PFX}'
    return Build
