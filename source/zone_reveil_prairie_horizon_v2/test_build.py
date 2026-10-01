"""Tests dédiés — Zone de réveil V2 (ZRV2) : layout de ZRV1, mer V24P04A, ciel / nuages / montagne séparés.
.venv/bin/python -m unittest source.zone_reveil_prairie_horizon_v2.test_build -v
Contrôles d'images, de lois d'animation, de boucles, de profondeur et de grille : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, math, unittest, zipfile
import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/zone_reveil_prairie_horizon_v2'
V1 = R / 'renders/zone_reveil_prairie_horizon_v1'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


B = loadmod('zrv2_build', HERE / 'build.py')
S = B.STAGE
YH = B.YH


def load(p):
    return np.array(Image.open(p).convert('RGBA'))


def alpha(a):
    return a[..., 3] > 0


LAYERS = {amb: {L['nom']: L for L in M['ambiances'][amb]['layers']} for amb in B.AMB}


def frame(amb, nom, t=0):
    L = LAYERS[amb][nom]
    return load(O / (L['file'] if L['phases'] == 1 else L['file'].replace('fNNN', f'f{t:03d}')))


def frames(amb, nom):
    return [frame(amb, nom, t) for t in range(LAYERS[amb][nom]['phases'])]


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


SEA = np.array(Image.open(O / 'masques/ZRV2_masque_mer.png')) > 127
MEADOW = np.array(Image.open(O / 'masques/ZRV2_masque_prairie.png')) > 127
_ALL = {}


def rebuilt():
    if not _ALL:
        _ALL['out'], _ALL['info'], _ALL['meadow'], _ALL['sea'], _ALL['strip'] = B.make_all()
    return _ALL


class Build(unittest.TestCase):
    def test_bruts_references_et_prompts(self):
        for r in M['raw_inputs']:
            self.assertEqual(sha(R / r['file']), r['sha256'], r['file'])
        for k, v in M['references'].items():
            self.assertEqual(sha(R / v['file']), v['sha256'], k)
        g = {x['file']: x for x in M['generation']}
        self.assertEqual(set(g), {'ciel_mer_jour.png', 'cretes_jour.png', 'banc_nuages_jour.png', 'montagne_jour.png', 'astres.png',
                                  'reflets_astres.png', 'decor_crepuscule_zrv1.png', 'banc_nuages_jour_b.png', 'banc_nuages_jour_c.png'})
        for k in ('banc_nuages_jour_b.png', 'banc_nuages_jour_c.png'):                     # bancs de plus : style du banc A
            self.assertTrue(any('banc_nuages' in i for i in g[k]['images']), k)
        for k in ('ciel_mer_jour.png', 'cretes_jour.png', 'banc_nuages_jour.png', 'reflets_astres.png'):   # V24P04A en référence
            self.assertTrue(any('v24p04a' in i for i in g[k]['images']), k)
        self.assertTrue(any('v1_montagne' in i for i in g['montagne_jour.png']['images']))  # la montagne de ZRV1
        self.assertIn('source/zone_reveil_prairie_horizon_v1/bruts/decor_jour.png', g['decor_crepuscule_zrv1.png']['images'])
        rc = M['crepuscule']['recalage']
        self.assertEqual(rc, B.dusk_meadow()['recalage'])                                  # recalé au pixel
        self.assertEqual([rc['dx'], rc['dy']], [0, 0]) if 'dx' in rc else None
        self.assertFalse(M['art_approved']); self.assertFalse(M['runtime_tested'])

    def test_exports_reproduits(self):
        """make_all() redonne exactement chaque image exportée (toutes les phases de tous les calques)."""
        out = rebuilt()['out']
        for amb, L in out.items():
            self.assertEqual([n for n in B.ORDER if n in L], list(LAYERS[amb]), amb)
            for nom, (fr, tk) in L.items():
                self.assertEqual((len(fr), tk if len(fr) > 1 else 60), (LAYERS[amb][nom]['phases'], LAYERS[amb][nom]['ticks']))
                for t, f in enumerate(fr):
                    self.assertTrue((f == frame(amb, nom, t)).all(), (amb, nom, t))

    def test_layout_de_zrv1(self):
        """Prairie, mer, collisions et marqueurs : ceux de ZRV1, sans changement."""
        self.assertTrue(M['mesures']['mer_identique_zrv1'])
        self.assertTrue((SEA == (np.array(Image.open(V1 / 'masques/ZRV1_masque_mer.png')) > 127)).all())
        for amb, a in B.AMB.items():
            for k, i in B.V1_INDEX.items():
                if amb == 'crepuscule':                                                   # mêmes masques que ZRV1
                    self.assertTrue((alpha(frame(amb, k, 0)) == alpha(frame('jour', k, 0))).all(), k)
                    continue
                v1 = load(V1 / f'calques/{amb}/ZRV1{a}_{i:02d}_{k}.png')
                self.assertTrue((frame(amb, k, 0) == v1).all(), (amb, k))                 # fleurs : phase A = ZRV1
        v1m = json.loads((V1 / 'manifest.json').read_text())
        self.assertEqual(M['access']['entry_px'], v1m['access']['entry_px'])
        self.assertEqual(M['access']['reveil_px'], v1m['access']['reveil_px'])
        self.assertEqual(M['access']['blocked_cells'], v1m['access']['blocked_cells'])

    def test_multicalque_et_profondeur(self):
        """Ciel, nuages, montagne, mer séparés ; de l'avant vers l'arrière : mer -> montagne -> nuages."""
        o = B.ORDER
        self.assertLess(o.index('ciel'), o.index('nuages')); self.assertLess(o.index('nuages'), o.index('montagne'))
        self.assertLess(o.index('montagne'), o.index('mer')); self.assertLess(o.index('mer'), o.index('herbe'))
        for amb in B.AMB:
            sky, mont, mer = alpha(frame(amb, 'ciel')), alpha(frame(amb, 'montagne')), alpha(frame(amb, 'mer'))
            self.assertTrue(sky[:YH].all()); self.assertFalse(sky[YH:].any())
            self.assertTrue((mer == SEA).all()); self.assertFalse(mont[YH:].any())
            for nom in ('ondes', 'scintillement', 'houle', 'reflet', 'ecume'):
                if nom in LAYERS[amb]:
                    for f in frames(amb, nom):
                        self.assertTrue((alpha(f) <= SEA).all(), (amb, nom))
            for t in range(0, B.CLOUD_PHASES, 8):
                c = alpha(frame(amb, 'nuages', t))
                self.assertFalse((c & mont).any(), (amb, t))                               # derrière la montagne
                self.assertFalse(c[YH:].any())

    def test_montagne_raccordee_a_l_horizon(self):
        m = alpha(frame('jour', 'montagne'))
        self.assertTrue(m[YH - 1].any())                                                   # la base touche l'horizon
        rows = [y for y in range(YH) if m[y].any()]
        left = np.array([np.nonzero(m[y])[0].min() for y in rows]); right = np.array([np.nonzero(m[y])[0].max() for y in rows])
        self.assertTrue((np.diff(left) <= 0).all()); self.assertTrue((np.diff(right) >= 0).all())   # flancs qui s'élargissent
        # pas de bord vertical : sur les 20 rangées du pied, chaque flanc avance d'au moins 1 px toutes les 2 rangées
        self.assertGreaterEqual(left[-21] - left[-1], 10); self.assertGreaterEqual(right[-1] - right[-21], 10)
        for e in (left[-40:], right[-40:]):                                                # aucun pan vertical de 4 rangées
            same = np.diff(e) == 0
            self.assertFalse(any(same[i:i + 3].all() for i in range(len(same) - 2)))
        self.assertLess(rows[0], 30)                                                       # sommet haut (celui de ZRV1)

    def test_nuages_defilent_boucle_fermee(self):
        strip = load(O / 'masques/ZRV2_jour_nuages_bande.png')
        self.assertEqual(strip.shape[1], B.CLOUD_PERIOD); self.assertEqual(B.CLOUD_PERIOD, W)     # période = écran entier
        self.assertEqual(B.CLOUD_PHASES * B.CLOUD_PAS % B.CLOUD_PERIOD, 0)
        self.assertEqual(B.CLOUD_PAS / B.CLOUD_TICKS, 1 / 8)                                 # vitesse de ZRV2 gardée
        self.assertTrue((strip == rebuilt()['strip']).all())
        self.assertTrue(alpha(strip)[-1].all())                                           # le banc est posé sur l'horizon
        # aucun nuage répété à l'écran : la bande n'a pas de période plus courte que l'écran (l'ancienne : 256 px)
        al = alpha(strip)
        for p in (128, 192, 256, 384):
            self.assertGreater((al != np.roll(al, p, axis=1)).mean(), 0.05, p)
        # les colonnes du banc A recopiées par le générateur dans le banc c (x 375-1075) ne sont pas reprises deux fois
        bancs = M['mesures']['nuages']['bancs']
        self.assertEqual([b['brut'] for b in bancs], [b[0] for b in B.CLOUD_BANKS])
        a_ = next(b for b in bancs if b['brut'] == 'banc_nuages_jour.png'); self.assertLessEqual(a_['coupe_brut'][1], 375)
        self.assertEqual(sum(b['largeur_px'] for b in bancs), W)
        self.assertEqual(a_['sommets_arrondis'], [[217, 286, 276]])
        # raccords : la bande est continue en boucle (écart entre colonnes voisines aux raccords comme ailleurs)
        a = strip[..., :3].astype(int); d = np.abs(np.diff(a, axis=1)).mean()
        x = 0
        for b in bancs:
            seam = np.abs(a[:, x % W] - a[:, x - 1]).mean(); self.assertLess(seam, d * 2.5, (b['brut'], x)); x += b['largeur_px']
        mont = alpha(frame('jour', 'montagne')); want = B.cloud_frames(strip, mont)
        for t in (0, 1, 100, B.CLOUD_PHASES - 1):
            self.assertTrue((want[t] == frame('jour', 'nuages', t)).all(), t)
        self.assertTrue((np.roll(strip, B.CLOUD_PHASES * B.CLOUD_PAS, axis=1) == strip).all())    # dernière phase + 1 = phase 0
        self.assertFalse((frame('jour', 'nuages', 0) == frame('jour', 'nuages', 1)).all())
        for amb in B.AMB:
            self.assertEqual(LAYERS[amb]['nuages']['phases'], B.CLOUD_PHASES)
        # pas de nuage rogné : ni colonne isolée qui dépasse, ni sommet plat de plus de 10 px (en boucle), ni rien au bord haut
        tops = np.array([int(np.argmax(al[:, x])) for x in range(strip.shape[1])])
        self.assertLessEqual(int(al[0].sum()), 24)                                          # seul le plus haut sommet touche le haut (pas de coupe plate)
        for x in range(len(tops)):
            self.assertFalse(tops[x] < min(tops[x - 1], tops[(x + 1) % len(tops)]) - 2, x)
        run, best = 1, 1
        for x in range(1, 2 * len(tops)):
            run = run + 1 if tops[x % len(tops)] == tops[(x - 1) % len(tops)] else 1; best = max(best, run)
        self.assertLessEqual(best, 10)
        self.assertGreater(YH - strip.shape[0], 30)                                        # le banc tient dans le bas du ciel

    def test_ondes_lignes_peintes_animees(self):
        """Les lignes de houle et plaques claires peintes dans la plaque ne sont plus statiques : extraites dans « ondes »,
        plaque rebouchée avec son grain, orbite au rythme de la houle, boucle fermée."""
        info = M['mesures']['ondes']; self.assertGreaterEqual(info['lignes'], 4); self.assertGreater(info['pixels'], 5000)
        self.assertGreaterEqual(info['rangees'][0], B.ONDES_Y0)
        o = B.ORDER; self.assertLess(o.index('mer'), o.index('ondes')); self.assertLess(o.index('ondes'), o.index('houle'))
        rb = rebuilt()
        for amb in B.AMB:
            fr = frames(amb, 'ondes'); self.assertEqual(len(fr), B.SWELL_STEPS)
            self.assertEqual(LAYERS[amb]['ondes']['ticks'], B.SWELL_TICKS)                    # calé sur la houle
            for s_, f in enumerate(fr):
                self.assertTrue((f == rb['out'][amb]['ondes'][0][s_]).all(), (amb, s_))
                self.assertTrue((f == fr[(s_ + 6) % 12]).all())                              # une orbite par rangée de crêtes
                ys = np.nonzero(alpha(f).any(1))[0]; self.assertGreaterEqual(ys.min(), B.ONDES_Y0 - 3)
            self.assertFalse((fr[0] == fr[1]).all()); self.assertFalse((fr[0] == fr[3]).all())
            mer = frame(amb, 'mer'); self.assertTrue((alpha(mer) == SEA).all())
        # extraction : hors motifs la plaque est celle du brut ; les lignes ont quitté la plaque
        sea_full = np.zeros((H, W, 3), int); hr, fy, sky, sea = B.sky_sea(B.rgb(B.RAW / 'ciel_mer_jour.png')); sea_full[YH:] = sea
        mer = frame('jour', 'mer')[..., :3].astype(int)
        f0 = frames('jour', 'ondes')
        l_mer, l_raw = B.lum(mer), B.lum(sea_full)
        def energy(l):
            m = SEA.copy(); m[:B.ONDES_Y0] = False
            from scipy import ndimage as nd_
            v = np.abs(nd_.gaussian_filter1d(l - nd_.median_filter(l, size=(9, 1)), 3, axis=1)); return v[m].mean()
        self.assertLess(energy(l_mer), 0.7 * energy(l_raw))                                  # la plaque n'a plus ses lignes
        diff = (mer != sea_full).any(-1) & SEA; diff[:YH + 40] = False
        self.assertLess(diff.sum(), 1.2 * info['pixels'])                                    # seuls les motifs ont été rebouchés
        # orbite : dx = Ah cos phi, dy = Av sin phi ; la ligne de y ~ 225 bouge d'au moins 2 px
        cy = [np.nonzero(alpha(f)[215:240])[0].mean() for f in f0[:6]]
        self.assertGreaterEqual(max(cy) - min(cy), 1.5)

    def test_houle_loi_v24p04a(self):
        self.assertEqual((B.SWELL_STEPS, B.SWELL_TICKS, B.GLINT_STEPS, B.GLINT_TICKS), (12, 10, 16, 4))
        self.assertEqual(len(B.GLINT_LEVELS), B.GLINT_STEPS); self.assertEqual(W % B.SWELL_PERIOD_X, 0)
        hmax = max(s[1] for pair in M['mesures']['cretes']['tailles_px'] for s in pair)
        ymax = int(np.nonzero(SEA.any(1))[0].max()); K = B.swell_rows()
        # la dernière crête sort de la mer avant de disparaître : aucun saut à la boucle
        self.assertGreater(B.swell_y(K - 1) - hmax + 1, ymax)
        # les crêtes grandissent en descendant (tailles croissantes)
        widths = [s[0] for pair in M['mesures']['cretes']['tailles_px'] for s in pair]
        self.assertTrue(all(w == B.CREST_W for w in widths))                               # largeur de V24P04A (78 / 96)
        heights = [pair[0][1] for pair in M['mesures']['cretes']['tailles_px']]
        self.assertEqual(heights, sorted(heights))                                         # plus épaisses en approchant
        # cadence décodée de V24P04A : 2 rangées par cycle de 12 crans, 5 à 10 px par cran dans la mer visible
        self.assertEqual(B.SWELL_PASSES, 2)
        steps = [B.swell_y(u + 2 / 12) - B.swell_y(u) for u in np.arange(0.4, 2.8, 1 / 6)]
        self.assertTrue(all(5 <= d <= 11 for d in steps), steps)
        # loi de profondeur : bas des crêtes du cran s en y(k + 2s/12), dans la mer pleine largeur
        top_meadow = int(np.nonzero(MEADOW.any(1))[0].min())
        for amb in B.AMB:
            fr = frames(amb, 'houle'); self.assertEqual(len(fr), 12)
            for s, f in enumerate(fr):
                a = alpha(f)
                want = {int(round(B.swell_y(k + (2 * s / 12) % 1))) for k in range(K)}
                bottoms = {y for y in range(YH, top_meadow) if a[y].any() and not a[y + 1].any()}
                # rangées transparentes au pied des sprites : le bas visible est au plus 3 px au-dessus de y(u)
                self.assertTrue(all(any(0 <= w - y <= 3 for w in want) for y in bottoms), (amb, s, sorted(bottoms), sorted(want)))
                self.assertGreaterEqual(len(bottoms), 1)
                # motif de 96 px (deux états alternés -> 192) ; la ligne prend la couleur de la mer : on compare l'alpha
                self.assertTrue((a[YH:top_meadow] == np.roll(a[YH:top_meadow], 192, axis=1)).all())
                # pas d'interstice : les rangées de crêtes (u >= 0,4) ont une ligne continue sur toute la largeur de mer
                for k in range(K):
                    u = k + (2 * s / 12) % 1
                    if u >= B.SIZE_BOUNDS[0]:
                        yc = int(round(B.swell_y(u)))
                        yl = [y for y in range(yc - 3, yc + 1) if YH <= y < H and SEA[y].all()]
                        if yl:
                            self.assertTrue(any(a[y][SEA[y]].all() for y in yl), (amb, s, k))
                self.assertTrue((f == fr[(s + 6) % 12]).all())                               # une rangée en 6 crans
            self.assertFalse((fr[0] == fr[1]).all())
        self.assertTrue((frames('jour', 'houle')[0][YH:top_meadow] != 0).any())

    def test_scintillement_horizon(self):
        for amb in B.AMB:
            fr = frames(amb, 'scintillement'); self.assertEqual(len(fr), 16)
            for f in fr:
                ys = np.nonzero(alpha(f).any(1))[0]
                if len(ys):
                    self.assertGreaterEqual(ys.min(), YH); self.assertLess(ys.max(), YH + 40)    # bande de l'horizon
            n = [int(alpha(f).sum()) for f in fr]
            self.assertGreater(max(n) - min(n), 0)

    def test_reflet_astre_genere(self):
        self.assertNotIn('reflet', LAYERS['jour']); self.assertNotIn('astre', LAYERS['jour'])
        sheet = B.rgb(B.RAW / 'reflets_astres.png')
        for y in range(YH + 45, 280, 7):                                              # u(y) inverse la loi de la houle
            self.assertAlmostEqual(B.swell_y(B.u_of_y(y)), y, places=6)
        for amb in ('aube', 'crepuscule', 'nuit'):
            A = B.ASTRE[amb]; xc = A['c'][0]
            ast = alpha(frame(amb, 'astre')); mont = alpha(frame(amb, 'montagne'))
            fr = frames(amb, 'reflet'); self.assertEqual(len(fr), B.SWELL_STEPS)
            self.assertEqual(LAYERS[amb]['reflet']['ticks'], B.SWELL_TICKS)                   # calé sur la houle
            dashes, rinfo = B.reflet_dashes(sheet, B.REFLET_COL[amb])
            self.assertGreater(rinfo['traits'], 40)
            want = B.reflet_frames(dashes, xc, SEA)
            sheet_cols = {tuple(int(v) for v in c) for d in dashes for c in d['spr'][d['spr'][..., 3] == 255][:, :3]}
            mer = frame(amb, 'mer')
            for t, f in enumerate(fr):
                self.assertTrue((f == want[t]).all(), (amb, t))
                ys, xs = np.nonzero(alpha(f)); self.assertGreater(len(ys), 150)
                self.assertTrue((np.abs(xs - xc) <= 260 * B.REFLET_SX / 2 + 12).all())       # colonne sous l'astre
                self.assertTrue({tuple(int(v) for v in c) for c in f[alpha(f)][:, :3]} <= sheet_cols)   # couleurs générées
                rr = f[alpha(f)][:, :3].astype(int); sm = mer[SEA][:, :3].astype(int)
                if amb == 'crepuscule':                                                     # reflet rouge du couchant
                    self.assertGreater((rr[:, 0] - rr[:, 2]).mean(), (sm[:, 0] - sm[:, 2]).mean() + 40)
                    self.assertGreater(B.lum(rr).mean(), B.lum(sm).mean())
                else:
                    self.assertGreater(B.lum(rr).mean(), B.lum(sm).mean() + 25)
            self.assertFalse((fr[0] == fr[3]).all())
            ys, xs = np.nonzero(ast); self.assertLess(ys.max(), YH)
            if amb == 'nuit':
                self.assertTrue((ast & mont).any())                                          # la lune derrière le sommet
            else:
                vis = ast & ~mont
                for t in range(0, B.CLOUD_PHASES, 32):
                    vis = vis & ~alpha(frame(amb, 'nuages', t))
                self.assertGreater(vis.sum(), (0.6 if amb == 'aube' else 0.35) * ast.sum(), amb)
                if amb == 'crepuscule':                                                     # soleil couchant à demi caché
                    self.assertLess(vis.sum(), 0.95 * ast.sum())

    def test_ecume_et_bulles_de_zrv1(self):
        for amb, a in B.AMB.items():
            e, b = frames(amb, 'ecume'), frames(amb, 'bulles')
            self.assertEqual((len(e), LAYERS[amb]['ecume']['ticks'], len(b), LAYERS[amb]['bulles']['ticks']), (10, 10, 24, 5))
            if amb == 'crepuscule':
                d = B.dusk_meadow()
                self.assertTrue(all((x == y).all() for x, y in zip(e, d['ecume'])))
                self.assertTrue(all((x == y).all() for x, y in zip(b, d['bulles'])))
                self.assertTrue(all((alpha(x) == alpha(y)).all() for x, y in zip(e, frames('jour', 'ecume'))))
                continue
            for t, f in enumerate(e):
                self.assertTrue((f == load(V1 / f'animation/{amb}/ecume/ZRV1{a}_08_ecume_f{t:03d}.png')).all(), (amb, t))
            for t, f in enumerate(b):
                self.assertTrue((f == load(V1 / f'animation/{amb}/bulles/ZRV1{a}_09_bulles_f{t:03d}.png')).all(), (amb, t))

    def test_fleurs_sky_peak(self):
        for amb in B.AMB:
            fr = frames(amb, 'fleurs'); self.assertEqual(len(fr), 4); self.assertEqual(LAYERS[amb]['fleurs']['ticks'], 12)
            self.assertTrue((fr[0] == fr[2]).all()); self.assertFalse((fr[0] == fr[1]).all()); self.assertFalse((fr[1] == fr[3]).all())
            for f in fr:
                self.assertTrue(set(np.unique(f[..., 3])) <= {0, 255})

    def test_etoiles_nuit(self):
        fr = frames('nuit', 'etoiles'); self.assertEqual(len(fr), B.STAR_PHASES)
        mont = alpha(frame('nuit', 'montagne')); cloud_top = YH - load(O / 'masques/ZRV2_jour_nuages_bande.png').shape[0]
        for f in fr:
            a = alpha(f); self.assertFalse((a & mont).any()); self.assertFalse(a[cloud_top:].any())
        self.assertGreaterEqual(M['mesures']['etoiles']['gardees'], 6)

    def test_couleurs_aube_nuit(self):
        d = B.lum(frame('jour', 'mer')[SEA][:, :3]).mean(); n = B.lum(frame('nuit', 'mer')[SEA][:, :3]).mean()
        self.assertLess(n, d - 60)                                                          # la mer de nuit est sombre
        aube = frame('aube', 'mer')[SEA][:, :3].astype(int)
        self.assertGreater(float((aube[:, 2] >= aube[:, 1]).mean()), 0.9)                   # aube : mer ardoise / violette
        sky = frame('aube', 'ciel')[:YH, :, :3].astype(int)
        self.assertGreater(sky[80, :, 1].mean(), sky[5, :, 1].mean() + 10)                 # aube : dégradé vers le rose clair
        dusk = frame('crepuscule', 'ciel')[:YH, :, :3].astype(int)
        self.assertGreater(dusk[80, :, 0].mean(), dusk[5, :, 0].mean() + 30)                # crépuscule : violet -> orange
        self.assertGreater(dusk[5, :, 2].mean(), dusk[5, :, 1].mean())
        night = frame('nuit', 'ciel')[:YH, :, :3].astype(int)
        self.assertTrue((night[..., 2] > night[..., 0]).mean() > 0.95)                       # nuit : ciel bleu nuit

    def test_access_et_collisions(self):
        a = M['access']; self.assertTrue(a['path_found_16x16'])
        walk = np.array(Image.open(V1 / 'masques/ZRV1_masque_praticable.png')) > 127
        for amb in B.AMB:
            doc = json.loads((S / f"Data/Ground/{B.ASSET[amb]}.rsground").read_text(encoding='utf-8-sig'))
            blocked = np.array([[c['Tags'] for c in col] for col in doc['Object']['obstacles']]).T.astype(bool)
            self.assertEqual(int(blocked.sum()), a['blocked_cells'])
            cells = SEA.reshape(H // 8, 8, W // 8, 8).mean((1, 3)) > 0.5
            self.assertTrue(blocked[cells].all()); self.assertTrue(blocked[:YH // 8].all())
            self.assertFalse(blocked[walk.reshape(H // 8, 8, W // 8, 8).mean((1, 3)) == 1].any())
            mk = {m['EntName']: m for m in doc['Object']['Entities'][0]['Markers']}
            self.assertEqual(set(mk), {'reveil', 'entrance'})
            self.assertEqual([mk['reveil']['Collider']['X'], mk['reveil']['Collider']['Y']], a['reveil_px'])

    def test_ora_et_scenes(self):
        for amb in B.AMB:
            with zipfile.ZipFile(O / f'ZRV2_zone_reveil_{amb}_calques.ora') as z:
                merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
                self.assertEqual(sum(1 for n in z.namelist() if n.startswith('data/layer')), len(LAYERS[amb]))
            comp = Image.new('RGBA', (W, H))
            for nom in LAYERS[amb]:
                comp.alpha_composite(Image.fromarray(frame(amb, nom, 0)))
            self.assertTrue((np.array(comp) == merged).all(), amb)
            self.assertTrue((load(O / f'review/ZRV2_{amb}_scene_t000.png') == merged).all(), amb)

    def test_prefixe_et_namespace_uniques(self):
        for p in (R / 'source').glob('*/build*.py'):
            if p.parent != HERE:
                s = p.read_text(errors='ignore')
                self.assertNotIn("PFX = 'ZRV2'", s, p); self.assertNotIn("'zone_reveil_prairie_horizon_v2'", s, p)
        names = [p.name for p in (O / 'calques').rglob('*.png')] + [p.name for p in (O / 'animation').rglob('*.png')]
        self.assertEqual(len(names), len(set(names)))
        v1 = {p.name for p in (V1 / 'calques').rglob('*.png')} | {p.name for p in (V1 / 'animation').rglob('*.png')}
        self.assertFalse(set(names) & v1)

    def test_ground_roundtrip(self):
        nr = loadmod('native_reader', R / 'source/cote_v5_expeditions/audit_references.py')
        banks = {p.stem: nr.tiles(p)[1] for p in (S / 'Content/Tile').glob('*.tile')}
        self.assertEqual(set(banks), set(M['pmdo']['tiles_per_bank']))
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(banks))
        for amb in B.AMB:
            doc = json.loads((S / f"Data/Ground/{B.ASSET[amb]}.rsground").read_text(encoding='utf-8-sig')); o = doc['Object']
            self.assertEqual(doc['Version'], '0.8.12.0'); self.assertEqual(len(o['Layers']), len(LAYERS[amb]) + 1)
            self.assertEqual(o['Layers'][-1]['Layer'], 4)
            for li, (nom, L) in enumerate(LAYERS[amb].items()):
                n = L['phases']
                for t in sorted({0, n // 2, n - 1}):
                    want = frame(amb, nom, t); out = np.zeros((H, W, 4), 'uint8')
                    for x, col in enumerate(o['Layers'][li]['Tiles']):
                        for y, cell in enumerate(col):
                            for track in cell['Layers']:
                                if len(track['Frames']) > 1:
                                    self.assertEqual((len(track['Frames']), track['FrameLength']), (n, L['ticks']))
                                f = track['Frames'][t % len(track['Frames'])]
                                out[y*8:y*8+8, x*8:x*8+8] = np.array(nr.straight(banks[f['Sheet']][f['TexLoc']['X'], f['TexLoc']['Y']]))
                    self.assertTrue((out == want).all(), (amb, nom, t))


if __name__ == '__main__':
    unittest.main()
