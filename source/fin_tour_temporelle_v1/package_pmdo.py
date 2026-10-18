"""Fin Tour Temporelle (FTT1) — Ground PMD natif avec nébuleuse animée en fond.

Produit, dans renders/fin_tour_temporelle_v1/pmdo_staging/ puis FTT1_pmdo_pack.zip :
- Data/Ground/ftt1_fin_tour_temporelle.rsground : GroundMap 0.7.15.1 (arène, calques de tuiles 8 px, marqueurs,
  collisions issues de la grille praticable) ;
- Background (LayeredBG) : deux nébuleuses natives (MapBG) qui défilent en boucle à vitesses différentes ;
- Content/Tile/*.tile et index.idx fusionné ; Content/BG/*.dir pour les nébuleuses ;
- le circuit d'or animé est un calque de tuiles à 4 phases (FrameLength = TICKS).

Gabarit : ce Ground n'emprunte pas le gabarit Métano absent du dépôt ; il suit la structure de
source/pmdo_cote/build.py (même schéma 0.7.15.1). Non testé dans PMDO.
Lancer : .venv/bin/python source/fin_tour_temporelle_v1/package_pmdo.py
"""
from pathlib import Path
import importlib.util, json, shutil, uuid, zipfile

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
OUT = R / 'renders' / 'fin_tour_temporelle_v1'
STAGE = OUT / 'pmdo_staging'
ASSET = 'ftt1_fin_tour_temporelle'
NS = 'fin_tour_temporelle'
PFX = 'FTT1'
NEB_LOIN, NEB_PROCHE = f'{PFX}_NEBULEUSE_LOIN', f'{PFX}_NEBULEUSE_PROCHE'
NEB_SPEED = {NEB_LOIN: (-6, 255), NEB_PROCHE: (-16, 150)}   # px/s, alpha (0-255)


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


B = loadmod('ftt1_build', HERE / 'build.py')
G = loadmod('pmdo_codec', R / 'source/pmdo_cote/build.py')
T = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
W, H, GW, GH = B.W, B.H, B.GW, B.GH


def periodic(a, shift=0):
    """Rend l'image raccordable horizontalement : fondu entre l'image et sa version décalée d'une demi-largeur."""
    w_ = a.shape[1]
    I = np.roll(a, shift, axis=1).astype(float)
    J = np.roll(I, w_ // 2, axis=1)
    x = np.arange(w_)
    w = 1 - np.abs(2 * x / w_ - 1)              # 0 aux bords, 1 au centre
    out = I * w[None, :, None] + J * (1 - w[None, :, None])
    return np.clip(out, 0, 255).astype(np.uint8)


def nebula_images():
    im = Image.open(B.RAW / 'nebuleuse.png').convert('RGB').resize((W, H), Image.LANCZOS)
    a = np.array(im)
    return {NEB_LOIN: periodic(a, 0), NEB_PROCHE: periodic(a, W // 4)}


def bg(name, movement, alpha):
    d = G.background(name, 0, movement, True)
    d['BGAnim']['Alpha'] = alpha
    return d


def static_cell(bank, img):
    def cell(x, y):
        f = bank.add(Image.fromarray(img[y*8:y*8+8, x*8:x*8+8]), x, y)
        return [f] if f else []
    return cell


def gold_cell(bank, frames):
    def cell(x, y):
        fs = [bank.add(Image.fromarray(f[y*8:y*8+8, x*8:x*8+8]), x, y) for f in frames]
        if fs[0] is None:
            return []
        assert all(f is not None for f in fs)
        return fs
    return cell


def build():
    if STAGE.exists():
        shutil.rmtree(STAGE)
    a = B.load_decor(); m = B.classify(a)
    walk = B.walk_mask(m['sol']); grid = B.walk_grid(walk)
    sol_full = B.rgba(a, ~m['mag'])[..., :4]
    sol = B.rgba(a, m['sol']); murs = B.rgba(a, m['murs'])
    gold = B.gold_frames(a, m['gold'])
    banks = {k: G.TileBank(f'{PFX}_{k}') for k in ['SOL_COMPLET', 'SOL', 'MURS', 'OR']}
    layers = [
        G.layer('00 Sol complet (arène sans fond)', GW, GH, static_cell(banks['SOL_COMPLET'], sol_full)),
        G.layer('01 Sol praticable', GW, GH, static_cell(banks['SOL'], sol)),
        G.layer('02 Murs et rochers', GW, GH, static_cell(banks['MURS'], murs)),
        G.layer('03 Circuits d or animes', GW, GH, gold_cell(banks['OR'], gold), B.TICKS),
        G.layer('04 Vos structures - base', GW, GH),
        G.layer('05 Vos structures - avant-plan', GW, GH, draw=4),
    ]
    for name, arr in nebula_images().items():
        speed, alpha = NEB_SPEED[name]
        G.write_dir(STAGE / f'Content/BG/{name}.dir', Image.fromarray(arr))
    obstacles = [[{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(not grid[y, x])}
                  for y in range(GH)] for x in range(GW)]
    mk = lambda n, p: {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                       'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
    obj = {'$type': 'RogueEssence.Ground.GroundMap, RogueEssence', 'TexSize': 1,
           'Name': {'DefaultText': 'Fin Tour Temporelle - arene de boss (4:3)', 'LocalTexts': {}},
           'Released': False,
           'Comment': 'Arene noire et or ; nebuleuse PMD animee en fond (deux MapBG). Collisions issues de la '
                      'grille praticable, a verifier en jeu. Aucune sortie, aucun warp. Art genere, non canonique.',
           'obstacles': obstacles,
           'rand': {'$type': 'RogueElements.ReRandom, RogueElements', 'FirstSeed': 0,
                    's': [16294208416658607535, 7960286522194355700, 487617019471545679, 17909611376780542444]},
           'Status': {},
           'Background': {'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence',
                          'Layers': [{'BG': bg(NEB_LOIN, NEB_SPEED[NEB_LOIN][0], NEB_SPEED[NEB_LOIN][1])},
                                     {'BG': bg(NEB_PROCHE, NEB_SPEED[NEB_PROCHE][0], NEB_SPEED[NEB_PROCHE][1])}]},
           'BlankBG': G.auto(), 'Layers': layers, 'AssetName': ASSET, 'Music': '', 'EdgeView': 0,
           'NoSwitching': False, 'ViewCenter': None, 'ViewOffset': {'X': 0, 'Y': 0}, 'ActiveChar': None,
           'Decorations': [{'Name': 'Vos decorations', 'Layer': 2, 'Visible': True, 'Anims': []}],
           'Entities': [{'Name': 'Entrees et vos acteurs', 'Visible': True, 'MapChars': [], 'GroundObjects': [],
                         'Spawners': [], 'Markers': [mk('entrance', B.MARK['entrance']),
                                                     mk('boss', B.MARK['boss']),
                                                     mk('objectif', B.MARK['objectif'])]}]}
    doc = {'Version': '0.7.15.1', 'Object': obj}
    (STAGE / f'Data/Ground').mkdir(parents=True, exist_ok=True)
    (STAGE / f'Data/Ground/{ASSET}.rsground').write_text(json.dumps(doc, ensure_ascii=False, separators=(',', ':')))
    for d in [f'Data/Script/ground/{ASSET}', f'Data/Script/{NS}/ground/{ASSET}']:
        p = STAGE / d / 'init.lua'; p.parent.mkdir(parents=True, exist_ok=True)
        p.write_text(f'-- {ASSET} : base d edition, aucun warp.\nlocal {ASSET} = {{}}\nreturn {ASSET}\n')
    for bank in banks.values():
        bank.write(STAGE / f'Content/Tile/{bank.name}.tile')
    nodes = {}
    for p in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = T.read_node(f)
    (STAGE / 'Content/Tile/index.idx').write_bytes(T.encode_index(nodes))
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/guilde-treehouse-pmd/' + NS)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Fin Tour Temporelle 4:3 - nebuleuse PMD</Name>
  <Author>meromoonmeri</Author>
  <Description>Zone de fin de donjon noire et or, nebuleuse PMD animee en fond. Projet d'edition, pas une aventure jouable.</Description>
  <Namespace>{NS}</Namespace>
  <UUID>{ident}</UUID>
  <Version>1.0.0.0</Version>
  <GameVersion>0.8.12.0</GameVersion>
  <ModType>Quest</ModType>
  <Relationships />
</Header>
''')
    zip_path = OUT / f'{PFX}_pmdo_pack.zip'
    if zip_path.exists():
        zip_path.unlink()
    with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as z:
        for p in sorted(STAGE.rglob('*')):
            if p.is_file():
                z.write(p, p.relative_to(STAGE).as_posix())
    return zip_path


if __name__ == '__main__':
    print(build())
