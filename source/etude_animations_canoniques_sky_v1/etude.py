"""Étude des animations canoniques d'eau et de magma de PMD Explorateurs du Ciel (NDS), et de leur portage PMDO.
.venv/bin/python source/etude_animations_canoniques_sky_v1/etude.py      (pip : skytemple-files)

Demande : « regarde les animations canoniques des maps magma / de l'eau, par exemple sur la map S01P02A »
(dépôt meromoonmeri/PMD-SKY-PMDO-PORT). Ce lot est une ÉTUDE, pas une carte de la série.

Sources, figées par commit et vérifiées par sha256 :
- pret/pmd-sky, files/MAP_BG : fichiers de la ROM (.bpl palettes et animation de palette, .bpc tuiles,
  .bma disposition, .bpa tuiles animées). Téléchargés dans .cache, jamais versionnés ici.
- meromoonmeri/PMD-SKY-PMDO-PORT : Grounds et banques .tile produits par son convertisseur, pour l'audit.

Mécanique du jeu (lue dans les fichiers, et dans skytemple-files pour le format) :
- animation de PALETTE (BPL) : pour chaque palette animée i, une suite de `number_of_frames` jeux de 15 couleurs,
  chacun affiché `duration_per_frame` frames (60 par seconde). L'eau et la lave sont des pixels FIXES dont la
  couleur tourne ;
- animation de TUILES (BPA) : `number_of_frames` versions de chaque tuile, chacune affichée `duration_per_frame`.
- RogueEssence (TileLayer.Draw) : frame = totalTick / FrameLength % nombre de frames, horloge globale, en frames
  à 60 par seconde. Une piste PMDO reproduit donc exactement une animation NDS si FrameLength = durée NDS et si
  la suite des frames garde ses répétitions et son ordre.

Rendu de vérité, tick par tick : image indexée de skytemple (`bma.to_pil(..., pal_ani=False)`, une image par cran
de BPA) + palettes du tick t (cran de chaque palette = t // durée % nombre). À t = 0 il est identique pixel à pixel
à l'aperçu publié par le port.
"""
from pathlib import Path
from math import gcd, lcm
import hashlib, io, itertools, json, subprocess, sys, urllib.request, base64

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
LOT = 'etude_animations_canoniques_sky_v1'
OUT = R / 'renders' / LOT
CACHE = R / '.cache' / LOT
PRET_REPO, PRET_SHA = 'pret/pmd-sky', 'c8073235b39746a7ee74e6cea16c730bd91a1e67'
PORT_REPO, PORT_SHA = 'meromoonmeri/PMD-SKY-PMDO-PORT', 'd62110a00269bdc861b8fe41b077607a80f50978'
RE_REPO, RE_SHA = 'RogueCollab/RogueEssence', 'ee6811c27720c76abe5d2d6bf42d3ce5dd463b58'
# Cartes étudiées : (nom MAP_BG, rôle, banque du port).
MAPS = [('s01p02a', 'eau : mer de la clairière tropicale (exemple donné par l utilisateur)', 'S01p02a_Base'),
        ('d41p41a', 'magma : arène cernée de lave', 'D41p41a_Base'),
        ('v03p08a', 'magma : scène de lave à deux palettes de vitesses différentes', 'V03p08a_Base')]
VIEWER = ['s01p02a', 'd41p41a', 'v03p08a']


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


# ---------------------------------------------------------------- sources
def fetch():
    pret = CACHE / 'pmd-sky'
    if not (pret / 'files/MAP_BG').is_dir():
        pret.mkdir(parents=True, exist_ok=True)
        run = lambda *a: subprocess.run(['git', *a], cwd=pret, check=True, capture_output=True)
        run('init', '-q'); run('remote', 'add', 'origin', f'https://github.com/{PRET_REPO}.git')
        run('config', 'core.sparseCheckout', 'true')
        (pret / '.git/info/sparse-checkout').write_text('files/MAP_BG/\n')
        run('fetch', '-q', '--depth', '1', '--filter=blob:none', 'origin', PRET_SHA); run('checkout', '-q', 'FETCH_HEAD')
    head = subprocess.run(['git', 'rev-parse', 'HEAD'], cwd=pret, capture_output=True, text=True).stdout.strip()
    assert head == PRET_SHA, head
    port = CACHE / 'port'; port.mkdir(parents=True, exist_ok=True)
    for name, _, bank in MAPS:
        for rel in (f'output/Grounds/{name}.rsground', f'output/Tiles/{bank}.tile', f'output/Previews/{name}.png'):
            p = port / Path(rel).name
            if not p.exists():
                url = f'https://raw.githubusercontent.com/{PORT_REPO}/{PORT_SHA}/{rel}'
                try:
                    p.write_bytes(urllib.request.urlopen(url, timeout=60).read())
                except Exception:                                   # dépôt privé : passer par gh
                    p.write_bytes(subprocess.run(['gh', 'api', '-H', 'Accept: application/vnd.github.raw',
                                                  f'repos/{PORT_REPO}/contents/{rel}?ref={PORT_SHA}'],
                                                 check=True, capture_output=True).stdout)
    return pret / 'files/MAP_BG', port


def ft():
    from skytemple_files.common.types.file_types import FileType
    return FileType


# ---------------------------------------------------------------- lecture et rendu de vérité
class SkyMap:
    def __init__(self, mapbg, name):
        F = ft(); L = lambda f, t: t.deserialize((mapbg / f).read_bytes())
        self.name = name
        self.files = {f: sha(mapbg / f) for f in (f'{name}.bpl', f'{name}.bpc', f'{name}.bma')}
        self.bpl, self.bpc, self.bma = L(f'{name}.bpl', F.BPL), L(f'{name}.bpc', F.BPC), L(f'{name}.bma', F.BMA)
        self.slots = [None] * 8
        for s in range(8):
            f = f'{name}{s + 1}.bpa'
            if (mapbg / f).exists():
                self.slots[s] = L(f, F.BPA); self.files[f] = sha(mapbg / f)
        bpas = [b for b in self.slots if b is not None]
        # Rendu exact seulement si tous les BPA partagent le même nombre de crans et les mêmes durées (vrai ici).
        self.bpa_durs = [int(fi.duration_per_frame) for fi in bpas[0].frame_info] if bpas else []
        for b in bpas:
            assert [int(fi.duration_per_frame) for fi in b.frame_info] == self.bpa_durs, 'BPA de rythmes différents'
        self.P = self.bma.to_pil(self.bpc, self.bpl, self.slots, include_collision=False,
                                 include_unknown_data_block=False, pal_ani=False)
        assert len(self.P) == max(1, len(self.bpa_durs))
        self.idx = [np.array(p) for p in self.P]
        self.specs = []                                          # (palette, crans, durée, premier cran dans la table)
        used = 0
        if self.bpl.has_palette_animation:
            for i, s in enumerate(self.bpl.animation_specs):
                if s.number_of_frames > 0:
                    self.specs.append((i, int(s.number_of_frames), int(s.duration_per_frame), used)); used += s.number_of_frames
        periods = [n * d for _, n, d, _ in self.specs] + ([sum(self.bpa_durs)] if self.bpa_durs else [])
        self.loop = lcm(*periods) if periods else 1

    def bpa_step(self, t):
        if not self.bpa_durs:
            return 0
        t %= sum(self.bpa_durs); c = 0
        for k, d in enumerate(self.bpa_durs):
            c += d
            if t < c:
                return k

    def palette_table(self, t):
        pals = [list(p) for p in self.bpl.palettes]
        for i, n, d, first in self.specs:
            pals[i] = [0, 0, 0] + list(self.bpl.animation_palette[first + (t // d) % n])
        return np.array(pals, 'uint8').reshape(-1, 3)             # 256 couleurs : index = palette * 16 + entrée

    def frame(self, t):
        return self.palette_table(t)[self.idx[self.bpa_step(t)]]

    def change_ticks(self):
        """Ticks de la boucle où quelque chose peut changer (crans de palette ou de BPA)."""
        ts = {0}
        for _, n, d, _ in self.specs:
            ts |= set(range(0, self.loop, d))
        c = 0
        while self.bpa_durs and c < self.loop:
            for d in self.bpa_durs:
                ts.add(c); c += d
        return sorted(t for t in ts if t < self.loop)

    def masks(self):
        bm = np.zeros(self.idx[0].shape, bool)
        for k in self.idx[1:]:
            bm |= k != self.idx[0]
        f0 = self.frame(0); pm = np.zeros_like(bm)
        for t in self.change_ticks():
            pm |= (self.frame(t) != f0).any(2) & ~bm
        return bm, pm                                            # pixels animés par BPA, par palette


# ---------------------------------------------------------------- tuiles 8 x 8 et pistes exactes
class TileTable:
    def __init__(self):
        self.ids, self.tiles = {}, []

    def key(self, t8):
        b = np.ascontiguousarray(t8).tobytes()
        if b not in self.ids:
            self.ids[b] = len(self.tiles); self.tiles.append(np.array(t8))
        return self.ids[b]

    def cells(self, img):
        h, w = img.shape[0] // 8, img.shape[1] // 8
        return np.array([[self.key(img[y * 8:y * 8 + 8, x * 8:x * 8 + 8]) for x in range(w)] for y in range(h)])


def states(m, tt):
    """État (id de tuile) de chaque case à chaque tick de changement ; seq(t) = état du dernier changement <= t."""
    ch = m.change_ticks()
    return ch, np.array([tt.cells(m.frame(t)) for t in ch])


def exact_track(seq):
    """Piste PMDO minimale qui reproduit la suite par tick `seq` (longueur = boucle) sous frame = t // FL % n.
    Aucune déduplication : l'ordre et les répétitions sont gardés."""
    L = len(seq)
    chg = [t for t in range(1, L) if seq[t] != seq[t - 1]]
    fl = L
    for t in chg:
        fl = gcd(fl, t)
    fr = list(seq[::fl]); n = len(fr)
    for p in range(1, n + 1):
        if n % p == 0 and fr == fr[:p] * (n // p):
            fr = fr[:p]; break
    return fl, fr


def port_tracks(port_dir, name, bank, tt):
    nr = loadmod('native_reader', R / 'source/cote_v5_expeditions/audit_references.py')
    tiles = nr.tiles(port_dir / f'{bank}.tile')[1]
    doc = json.loads((port_dir / f'{name}.rsground').read_text(encoding='utf-8-sig'))
    T = doc['Object']['Layers']; assert len(T) == 1
    cache, tracks = {}, {}
    for x, col in enumerate(T[0]['Tiles']):
        for y, c in enumerate(col):
            assert len(c['Layers']) == 1
            tr = c['Layers'][0]; ids = []
            for f in tr['Frames']:
                k = (f['TexLoc']['X'], f['TexLoc']['Y'])
                if k not in cache:
                    cache[k] = tt.key(np.array(nr.straight(tiles[k]))[..., :3])
                ids.append(cache[k])
            tracks[y, x] = (int(tr['FrameLength']), ids)
    return doc, tracks


def loadmod(name, path):
    import importlib.util
    sp = importlib.util.spec_from_file_location(name, path)
    mod = importlib.util.module_from_spec(sp); sp.loader.exec_module(mod); return mod


def play(track, ticks):
    fl, fr = track
    return np.array(fr)[(np.asarray(ticks) // fl) % len(fr)]


# ---------------------------------------------------------------- inventaire de toutes les cartes
def kind_of(cols):
    r, g, b = np.array(cols, float).reshape(-1, 3).mean(0)
    return 'magma' if r > g + 30 and r > b + 50 else 'eau' if b > r + 40 else 'autre'


def inventory(mapbg):
    F = ft(); rows = []
    for p in sorted(mapbg.glob('*.bpl')):
        try:
            b = F.BPL.deserialize(p.read_bytes())
        except Exception:
            continue
        specs = [(i, int(s.number_of_frames), int(s.duration_per_frame)) for i, s in enumerate(b.animation_specs)
                 if s.number_of_frames > 0] if b.has_palette_animation else []
        bpas = []
        for s in range(8):
            q = mapbg / f'{p.stem}{s + 1}.bpa'
            if q.exists():
                a = F.BPA.deserialize(q.read_bytes())
                bpas.append({'slot': s + 1, 'tuiles': int(a.number_of_tiles),
                             'durees': [int(fi.duration_per_frame) for fi in a.frame_info]})
        if not specs and not bpas:
            continue
        rows.append({'carte': p.stem, 'palettes_animees': [{'palette': i, 'crans': n, 'duree': d} for i, n, d in specs],
                     'bpa': bpas, 'teinte_palettes': kind_of(b.animation_palette) if specs else None})
    return rows


# ---------------------------------------------------------------- sorties
def palette_strip(m):
    """Une bande par palette animée : une ligne par cran (15 couleurs), agrandie x12."""
    rows = []
    for i, n, d, first in m.specs:
        a = np.array([m.bpl.animation_palette[first + k] for k in range(n)], 'uint8').reshape(n, 15, 3)
        rows.append(np.pad(a, ((0, 1), (0, 0), (0, 0)), constant_values=24))
    a = np.concatenate(rows, 0)
    return Image.fromarray(a).resize((a.shape[1] * 12, a.shape[0] * 12), Image.Resampling.NEAREST)


def webp(m, path, max_px=456):
    ch = m.change_ticks() + [m.loop]
    frames = [Image.fromarray(m.frame(t)) for t in ch[:-1]]
    if frames[0].width > max_px:
        s = max_px / frames[0].width
        frames = [f.resize((max_px, round(f.height * s)), Image.Resampling.NEAREST) for f in frames]
    # durées en ms : ticks x 1000 / 60 (arrondi cumulatif pour ne pas dériver)
    ms = [round(ch[k + 1] * 1000 / 60) - round(ch[k] * 1000 / 60) for k in range(len(ch) - 1)]
    frames[0].save(path, save_all=True, append_images=frames[1:], duration=ms, loop=0, lossless=True, method=4)


def atlas_png(tiles, path, per_row=64):
    n = len(tiles); rows = (n + per_row - 1) // per_row
    a = np.zeros((rows * 8, per_row * 8, 3), 'uint8')
    for k, t in enumerate(tiles):
        a[(k // per_row) * 8:(k // per_row) * 8 + 8, (k % per_row) * 8:(k % per_row) * 8 + 8] = t
    Image.fromarray(a).save(path, optimize=True)


def study(m, port_dir, bank):
    tt = TileTable()
    ch, S = states(m, tt)
    H, W = S.shape[1:]
    ticks = np.arange(m.loop)
    pos = np.searchsorted(ch, ticks, side='right') - 1
    exact, kinds = {}, {}
    for y in range(H):
        for x in range(W):
            exact[y, x] = exact_track(list(S[pos, y, x]))
    # Vérification : la piste exacte redonne la vérité à chaque tick de deux boucles.
    t2 = np.arange(2 * m.loop)
    truth2 = S[np.searchsorted(ch, t2 % m.loop, side='right') - 1]
    for (y, x), tr in exact.items():
        assert (play(tr, t2) == truth2[:, y, x]).all(), (y, x)
    doc, port = port_tracks(port_dir, m.name, bank, tt)
    assert max(k[0] for k in port) + 1 == H and max(k[1] for k in port) + 1 == W
    # Audit du port, case par case : fraction du temps où la piste du port diffère de la piste exacte (validée
    # ci-dessus contre la vérité), sur le ppcm des deux périodes, au pas du pgcd des deux FrameLength.
    wrong = np.zeros((H, W)); per_max = 0
    for (y, x), trk in port.items():
        (f1, r1), (f2, r2) = exact[y, x], trk
        per = lcm(f1 * len(r1), f2 * len(r2)); per_max = max(per_max, per)
        tp = np.arange(0, per, gcd(f1, f2))
        wrong[y, x] = float((play(trk, tp) != play(exact[y, x], tp)).mean())
    animated = np.array([[len(exact[y, x][1]) > 1 for x in range(W)] for y in range(H)])
    port_n = np.array([[len(port[y, x][1]) for x in range(W)] for y in range(H)])
    port_fl = np.array([[port[y, x][0] for x in range(W)] for y in range(H)])
    ex_n = np.array([[len(exact[y, x][1]) for x in range(W)] for y in range(H)])
    ex_fl = np.array([[exact[y, x][0] for x in range(W)] for y in range(H)])
    t0 = np.array(Image.open(port_dir / f'{m.name}.png').convert('RGB'))
    bm, pm = m.masks()
    by = {}
    for fl, n in sorted({(int(a), int(b)) for a, b in zip(ex_fl[animated], ex_n[animated])}):
        sel = animated & (ex_fl == fl) & (ex_n == n)
        mot = {}
        for y, x in zip(*np.nonzero(sel)):
            u = {}; k = '-'.join(str(u.setdefault(i, len(u))) for i in exact[y, x][1]); mot[k] = mot.get(k, 0) + 1
        by[f'{n} x {fl}'] = {'cases': int(sel.sum()), 'temps_faux_port': round(float(wrong[sel].mean()), 3),
                             'motifs': dict(sorted(mot.items(), key=lambda kv: -kv[1])[:6]),
                             'pistes_port': sorted({f'{int(a)} x {int(b)}' for a, b in zip(port_n[sel], port_fl[sel])})}
    rep = {
        'carte': m.name, 'taille_px': [W * 8, H * 8], 'fichiers_rom_sha256': m.files,
        'palettes_animees': [{'palette': i, 'crans': n, 'duree_frames': d, 'periode': n * d,
                              'couleurs': [[list(m.bpl.animation_palette[first + k][j * 3:j * 3 + 3]) for j in range(15)]
                                           for k in range(n)],
                              'palette_de_base_egale_au_cran_0': list(m.bpl.palettes[i][3:48]) == list(m.bpl.animation_palette[first])}
                             for i, n, d, first in m.specs],
        'bpa': {'crans': len(m.bpa_durs), 'durees_frames': m.bpa_durs,
                'crans_distincts_sur_la_carte': bpa_pattern(m)} if m.bpa_durs else None,
        'boucle_ticks': m.loop, 'ticks_de_changement': len(m.change_ticks()),
        'pixels_animes': {'palette': int(pm.sum()), 'bpa': int(bm.sum()), 'recouvrement': int((pm & bm).sum())},
        'rendu_t0_egal_apercu_port': bool((m.frame(0) == t0).all()),
        'pistes_exactes': by,
        'port': {'cases_animees_vraies': int(animated.sum()), 'cases_animees_port': int((port_n > 1).sum()),
                 'cases_fausses': int((wrong > 0).sum()), 'temps_faux_moyen_cases_animees': round(float(wrong[animated].mean()), 3),
                 'periode_audit_max_ticks': int(per_max),
                 'framelength_port': sorted({int(v) for v in port_fl[port_n > 1]}),
                 'tuiles_uniques_vraies': len(tt.tiles)},
    }
    return rep, tt, exact, port, wrong, (bm, pm), doc


def bpa_pattern(m):
    """Crans BPA identiques en pixels (ex. 0-1-2-1 : le cran 3 redonne le cran 1)."""
    out = []
    for k in range(len(m.idx)):
        same = [j for j in range(k) if (m.idx[j] == m.idx[k]).all()]
        out.append(same[0] if same else k)
    return out


def heat(m, wrong, masks, path):
    f0 = m.frame(0).astype(float) * 0.45
    bm, pm = masks
    f0[pm] = f0[pm] * 0.5 + np.array([0, 150, 255]) * 0.5
    f0[bm] = f0[bm] * 0.5 + np.array([255, 0, 200]) * 0.5
    w = np.kron(wrong, np.ones((8, 8)))[..., None]
    img = f0 * (1 - 0.8 * (w > 0)) + np.array([255, 40, 0]) * 0.8 * (w > 0) * (0.35 + 0.65 * w)
    Image.fromarray(np.clip(img, 0, 255).astype('uint8')).save(path)


def viewer_data(m, tt, exact, port):
    H, W = max(k[0] for k in exact) + 1, max(k[1] for k in exact) + 1
    used = sorted({i for tr in list(exact.values()) + list(port.values()) for i in tr[1]})
    remap = {i: k for k, i in enumerate(used)}
    bio = io.BytesIO()
    tiles = [tt.tiles[i] for i in used]
    per_row = 64; rows = (len(tiles) + per_row - 1) // per_row
    a = np.zeros((rows * 8, per_row * 8, 3), 'uint8')
    for k, t in enumerate(tiles):
        a[(k // per_row) * 8:(k // per_row) * 8 + 8, (k % per_row) * 8:(k % per_row) * 8 + 8] = t
    Image.fromarray(a).save(bio, 'PNG', optimize=True)
    enc = lambda d: [[[d[y, x][0], [remap[i] for i in d[y, x][1]]] for x in range(W)] for y in range(H)]
    return {'name': m.name, 'w': W, 'h': H, 'loop': m.loop, 'atlas': 'data:image/png;base64,' + base64.b64encode(bio.getvalue()).decode(),
            'per_row': per_row, 'exact': enc(exact), 'port': enc(port)}


def main():
    mapbg, port_dir = fetch()
    for d in ('', 'cartes', 'audit'):
        (OUT / d).mkdir(parents=True, exist_ok=True)
    inv = inventory(mapbg)
    (OUT / 'inventaire_animations_sky.json').write_text(json.dumps(inv, indent=1, ensure_ascii=False))
    report = {'lot': LOT, 'nature': 'etude ; pas une carte de la serie ; aucun pixel copie dans les lots de la serie',
              'sources': {'rom': {'depot': PRET_REPO, 'commit': PRET_SHA, 'dossier': 'files/MAP_BG'},
                          'port': {'depot': PORT_REPO, 'commit': PORT_SHA,
                                   'fichiers_sha256': {p.name: sha(p) for p in sorted(port_dir.iterdir())}},
                          'moteur': {'depot': RE_REPO, 'commit': RE_SHA, 'fichier': 'RogueEssence/Dungeon/Tiles/TileLayer.cs',
                                     'regle': 'currentFrame = totalTick / FrameToTick(FrameLength) % Frames.Count'}},
              'inventaire': {'cartes_animees': len(inv),
                             'avec_palette_animee': sum(1 for r in inv if r['palettes_animees']),
                             'avec_bpa': sum(1 for r in inv if r['bpa']),
                             'teintes': {k: sum(1 for r in inv if r['teinte_palettes'] == k) for k in ('eau', 'magma', 'autre')},
                             'teinte_regle': 'moyenne des couleurs animees : magma si r > g + 30 et r > b + 50 ; eau si b > r + 40'},
              'cartes': {}}
    data = []
    for name, role, bank in MAPS:
        m = SkyMap(mapbg, name)
        rep, tt, exact, port, wrong, masks, _ = study(m, port_dir, bank)
        rep['role'] = role
        report['cartes'][name] = rep
        Image.fromarray(m.frame(0)).save(OUT / 'cartes' / f'{name}_t000.png')
        palette_strip(m).save(OUT / 'cartes' / f'{name}_cycles_palette.png')
        webp(m, OUT / 'cartes' / f'{name}_vrai_{m.loop}ticks.webp')
        heat(m, wrong, masks, OUT / 'audit' / f'{name}_audit_port.png')
        if name in VIEWER:
            d = viewer_data(m, tt, exact, port); pr = rep['port']
            bio = io.BytesIO(); palette_strip(m).save(bio, 'PNG')
            d.update(label=role.split(' : ')[0], strip='data:image/png;base64,' + base64.b64encode(bio.getvalue()).decode(),
                     stats={'rows': [['palettes animées', ', '.join(f"n°{x['palette']} : {x['crans']} crans × {x['duree_frames']}"
                                                                   for x in rep['palettes_animees'])],
                                     ['tuiles animées (BPA)', f"{rep['bpa']['crans']} crans × {rep['bpa']['durees_frames'][0]}"
                                      if rep['bpa'] else 'aucune'],
                                     ['pixels animés (palette / BPA)', f"{rep['pixels_animes']['palette']} / {rep['pixels_animes']['bpa']}"],
                                     ['pistes exactes (frames × ticks)', ' ; '.join(f"{k} : {v['cases']} cases" for k, v in rep['pistes_exactes'].items())],
                                     ['motifs par case (crans égaux en pixels)', ' ; '.join(f"{k} : {' / '.join(f'{a} ({c})' for a, c in list(v['motifs'].items())[:4])}"
                                                                                          for k, v in rep['pistes_exactes'].items())],
                                     ['cases animées', str(pr['cases_animees_vraies'])],
                                     ['cases fausses dans le port', f"{pr['cases_fausses']} ({pr['cases_fausses'] * 100 // max(1, pr['cases_animees_vraies'])} %)"],
                                     ['temps faux moyen (cases animées)', f"{round(pr['temps_faux_moyen_cases_animees'] * 100, 1)} %"]]})
            data.append(d)
        print(name, json.dumps(rep['port']), json.dumps(rep['pistes_exactes'])[:400])
    (OUT / 'rapport.json').write_text(json.dumps(report, indent=1, ensure_ascii=False))
    page = (HERE / 'viewer_template.html').read_text().replace('__DATA__', json.dumps(data, separators=(',', ':')))
    (R / f'apercu_{LOT}.html').write_text(page)
    print('apercu', round((R / f'apercu_{LOT}.html').stat().st_size / 1e6, 2), 'Mo')


if __name__ == '__main__':
    main()
