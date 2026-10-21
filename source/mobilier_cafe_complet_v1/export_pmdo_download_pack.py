"""Assemble le dossier versionné `livrables_pmdo_sans_fond/` + `telecharger_objets_cafe_pmdo.html`.

Objectif :
- Permettre à l'utilisateur de télécharger immédiatement en 1 clic (via Blob JS en autonome, via
  `?dl=1` Content-Disposition sur le serveur `:8000`, via l'explorateur de fichiers Arena, ou via
  `git pull` sur GitHub) TOUS les 11 objets de Café & Cabaret 100 % SANS FOND (`alpha = 0`, `0 px`
  magenta/pourpre) prêts à placer directement dans PMDO 0.8.12 (`PNG 1x grille 8 px` + `Arrière/Avant`
  + `Mod PMDO 0.8.12 unifié` + `PNG HD sans fond`).

Usage : .venv/bin/python source/mobilier_cafe_complet_v1/export_pmdo_download_pack.py
"""
from __future__ import annotations

import base64, importlib.util, io, json, shutil, uuid, zipfile
from pathlib import Path

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
DEST = R / 'livrables_pmdo_sans_fond'
MOD_DIR = DEST / 'Mod_PMDO_0812_Pret_A_Placer/cafe_spinda_metano_complet'

KMC = R / 'renders/mobilier_cafe_complet_v1'
KTR = R / 'renders/kiosques_spinda_trio_v1'
KKR = R / 'renders/kiosque_kirlia_spinda_v1'


def loadmod(name: str, path: Path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


def b64(p: Path) -> str:
    return base64.b64encode(p.read_bytes()).decode()


def zip_files(zpath: Path, pairs: list[tuple[Path, str]]) -> None:
    with zipfile.ZipFile(zpath, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for src, arc in pairs:
            z.write(src, arc)


CATALOG = [
    {
        'num': '01',
        'id': 'spinda_comptoir',
        'title': 'Comptoir Spinda (Bar à Jus)',
        'usage_pmdo': 'Placer Arrière en calque Objects (Under) et Avant en calque Objects (Over) aux mêmes coordonnées (X, Y) : Spinda se place entre les deux !',
        'hd': KTR / 'hd/Spinda_Comptoir_HD_sans_fond.png',
        'complet_1x': KTR / 'assets_1x/Spinda_Comptoir_1x_complet.png',
        'arriere_1x': KTR / 'assets_1x/Spinda_Comptoir_1x_arriere.png',
        'avant_1x': KTR / 'assets_1x/Spinda_Comptoir_1x_avant.png',
        'nuit_1x': KTR / 'assets_1x/Spinda_Comptoir_1x_nuit_complet.png',
        'tiles': [
            R / '.cache/kiosques_spinda_trio_v1/kiosques_cafe_spinda_trio/Content/Tile/KSP1_00_ARRIERE.tile',
            R / '.cache/kiosques_spinda_trio_v1/kiosques_cafe_spinda_trio/Content/Tile/KSP1_01_AVANT.tile',
            R / '.cache/kiosques_spinda_trio_v1/kiosques_cafe_spinda_trio/Content/Tile/KSP1_02_COMPLET.tile',
            R / '.cache/kiosques_spinda_trio_v1/kiosques_cafe_spinda_trio/Content/Tile/KSP1_03_NUIT.tile',
        ],
    },
    {
        'num': '02',
        'id': 'qulbutoke_comptoir',
        'title': 'Comptoir Qulbutoké (Stand Recyclage & Loteries)',
        'usage_pmdo': 'Placer Arrière (Under) + Avant (Over) aux mêmes (X, Y) pour glisser Qulbutoké derrière le comptoir, ou Complet en bloc unique.',
        'hd': KTR / 'hd/Qulbutoke_Comptoir_HD_sans_fond.png',
        'complet_1x': KTR / 'assets_1x/Qulbutoke_Comptoir_1x_complet.png',
        'arriere_1x': KTR / 'assets_1x/Qulbutoke_Comptoir_1x_arriere.png',
        'avant_1x': KTR / 'assets_1x/Qulbutoke_Comptoir_1x_avant.png',
        'nuit_1x': KTR / 'assets_1x/Qulbutoke_Comptoir_1x_nuit_complet.png',
        'tiles': [
            R / '.cache/kiosques_spinda_trio_v1/kiosques_cafe_spinda_trio/Content/Tile/KQB1_00_ARRIERE.tile',
            R / '.cache/kiosques_spinda_trio_v1/kiosques_cafe_spinda_trio/Content/Tile/KQB1_01_AVANT.tile',
            R / '.cache/kiosques_spinda_trio_v1/kiosques_cafe_spinda_trio/Content/Tile/KQB1_02_COMPLET.tile',
            R / '.cache/kiosques_spinda_trio_v1/kiosques_cafe_spinda_trio/Content/Tile/KQB1_03_NUIT.tile',
        ],
    },
    {
        'num': '03',
        'id': 'sucreine_comptoir',
        'title': 'Comptoir Sucreine (Bar Royal Baies & Nectars)',
        'usage_pmdo': 'Placer Arrière (Under) + Avant (Over) aux mêmes (X, Y) pour glisser Sucreine derrière le comptoir à volant blanc.',
        'hd': KTR / 'hd/Sucreine_Comptoir_HD_sans_fond.png',
        'complet_1x': KTR / 'assets_1x/Sucreine_Comptoir_1x_complet.png',
        'arriere_1x': KTR / 'assets_1x/Sucreine_Comptoir_1x_arriere.png',
        'avant_1x': KTR / 'assets_1x/Sucreine_Comptoir_1x_avant.png',
        'nuit_1x': KTR / 'assets_1x/Sucreine_Comptoir_1x_nuit_complet.png',
        'tiles': [
            R / '.cache/kiosques_spinda_trio_v1/kiosques_cafe_spinda_trio/Content/Tile/KSC1_00_ARRIERE.tile',
            R / '.cache/kiosques_spinda_trio_v1/kiosques_cafe_spinda_trio/Content/Tile/KSC1_01_AVANT.tile',
            R / '.cache/kiosques_spinda_trio_v1/kiosques_cafe_spinda_trio/Content/Tile/KSC1_02_COMPLET.tile',
            R / '.cache/kiosques_spinda_trio_v1/kiosques_cafe_spinda_trio/Content/Tile/KSC1_03_NUIT.tile',
        ],
    },
    {
        'num': '04',
        'id': 'kirlia_comptoir',
        'title': 'Comptoir Kirlia (Bar Thés & Infusions)',
        'usage_pmdo': 'Style Metano_Town_Cafe_Objects assorti : Arrière (Under) + Avant (Over) aux mêmes (X, Y) ou Complet.',
        'hd': KMC / 'hd/Kirlia_Comptoir_HD_sans_fond.png',
        'complet_1x': KMC / 'assets_1x/Kirlia_Comptoir_1x_complet.png',
        'arriere_1x': KMC / 'assets_1x/Kirlia_Comptoir_1x_arriere.png',
        'avant_1x': KMC / 'assets_1x/Kirlia_Comptoir_1x_avant.png',
        'nuit_1x': KMC / 'assets_1x/Kirlia_Comptoir_1x_nuit_complet.png',
        'tiles': [
            R / '.cache/mobilier_cafe_complet_v1/mobilier_cafe_complet/Content/Tile/KKB1_00_ARRIERE.tile',
            R / '.cache/mobilier_cafe_complet_v1/mobilier_cafe_complet/Content/Tile/KKB1_01_AVANT.tile',
            R / '.cache/mobilier_cafe_complet_v1/mobilier_cafe_complet/Content/Tile/KKB1_02_COMPLET.tile',
            R / '.cache/mobilier_cafe_complet_v1/mobilier_cafe_complet/Content/Tile/KKB1_03_NUIT.tile',
        ],
    },
    {
        'num': '05',
        'id': 'charmilly_comptoir',
        'title': 'Comptoir Charmilly (Pâtisserie & Crème Fouettée)',
        'usage_pmdo': 'Style Metano_Town_Cafe_Objects assorti : Arrière (Under) + Avant (Over) aux mêmes (X, Y) ou Complet.',
        'hd': KMC / 'hd/Charmilly_Comptoir_HD_sans_fond.png',
        'complet_1x': KMC / 'assets_1x/Charmilly_Comptoir_1x_complet.png',
        'arriere_1x': KMC / 'assets_1x/Charmilly_Comptoir_1x_arriere.png',
        'avant_1x': KMC / 'assets_1x/Charmilly_Comptoir_1x_avant.png',
        'nuit_1x': KMC / 'assets_1x/Charmilly_Comptoir_1x_nuit_complet.png',
        'tiles': [
            R / '.cache/mobilier_cafe_complet_v1/mobilier_cafe_complet/Content/Tile/KCM1_00_ARRIERE.tile',
            R / '.cache/mobilier_cafe_complet_v1/mobilier_cafe_complet/Content/Tile/KCM1_01_AVANT.tile',
            R / '.cache/mobilier_cafe_complet_v1/mobilier_cafe_complet/Content/Tile/KCM1_02_COMPLET.png' if False else R / '.cache/mobilier_cafe_complet_v1/mobilier_cafe_complet/Content/Tile/KCM1_02_COMPLET.tile',
            R / '.cache/mobilier_cafe_complet_v1/mobilier_cafe_complet/Content/Tile/KCM1_03_NUIT.tile',
        ],
    },
    {
        'num': '06a',
        'id': 'estrade_spinda_troubadour',
        'title': 'Estrade Ouverte & Arche Rideaux Spinda Troubadour (POV Salles Existantes)',
        'usage_pmdo': 'POV 3/4 de dessus cohérente aux salles SpindaV7 : Arrière = plateau bois miel au médaillon spirale Spinda + escalier (Under) ; Avant = grande arche ouverte à motifs Spinda Troubadour (Over, centre 100 % alpha = 0 !).',
        'hd': KMC / 'hd/Estrade_Spinda_Troubadour_HD_sans_fond.png',
        'complet_1x': KMC / 'assets_1x/Estrade_Spinda_Troubadour_1x_complet.png',
        'arriere_1x': KMC / 'assets_1x/Estrade_Spinda_Troubadour_1x_arriere.png',
        'avant_1x': KMC / 'assets_1x/Estrade_Spinda_Troubadour_1x_avant.png',
        'nuit_1x': KMC / 'assets_1x/Estrade_Spinda_Troubadour_1x_nuit_complet.png',
        'tiles': [
            R / '.cache/mobilier_cafe_complet_v1/mobilier_cafe_complet/Content/Tile/EST1_00_ARRIERE.tile',
            R / '.cache/mobilier_cafe_complet_v1/mobilier_cafe_complet/Content/Tile/EST1_01_AVANT.tile',
            R / '.cache/mobilier_cafe_complet_v1/mobilier_cafe_complet/Content/Tile/EST1_02_COMPLET.tile',
            R / '.cache/mobilier_cafe_complet_v1/mobilier_cafe_complet/Content/Tile/EST1_03_NUIT.tile',
        ],
    },
    {
        'num': '06b',
        'id': 'estrade_plateau_spinda',
        'title': 'Plateau d’Estrade Seul — Bois Miel & Spirale Spinda (POV 3/4)',
        'usage_pmdo': 'Plateau d’estrade vide en vraie POV 3/4 de dessus (192×136 px = 24×17 tuiles) avec escalier central et médaillon spirale Spinda incrusté dans le bois.',
        'hd': KMC / 'hd/Estrade_Plateau_Spinda_HD_sans_fond.png',
        'complet_1x': KMC / 'assets_1x/Estrade_Plateau_Spinda_1x_complet.png',
        'arriere_1x': None,
        'avant_1x': None,
        'nuit_1x': KMC / 'assets_1x/Estrade_Plateau_Spinda_1x_nuit_complet.png',
        'tiles': [
            R / '.cache/mobilier_cafe_complet_v1/mobilier_cafe_complet/Content/Tile/STR1_00_MODULES_JOUR.tile',
            R / '.cache/mobilier_cafe_complet_v1/mobilier_cafe_complet/Content/Tile/STR1_01_MODULES_NUIT.tile',
        ],
    },
    {
        'num': '06c',
        'id': 'rideau_gauche_spinda_troubadour',
        'title': 'Rideau de Scène Gauche Indépendant — Motif Spinda Troubadour',
        'usage_pmdo': 'Rideau gauche seul (104×96 px = 13×12 tuiles, Over) : spirales crème Spinda, pois asymétriques, fanions troubadour cyan/or et embrasse dorée.',
        'hd': KMC / 'hd/Rideau_Gauche_Spinda_Troubadour_HD_sans_fond.png',
        'complet_1x': KMC / 'assets_1x/Rideau_Gauche_Spinda_Troubadour_1x_complet.png',
        'arriere_1x': None,
        'avant_1x': None,
        'nuit_1x': KMC / 'assets_1x/Rideau_Gauche_Spinda_Troubadour_1x_nuit_complet.png',
        'tiles': [],
    },
    {
        'num': '06d',
        'id': 'rideau_droit_spinda_troubadour',
        'title': 'Rideau de Scène Droit Indépendant — Motif Spinda Troubadour',
        'usage_pmdo': 'Rideau droit seul (104×96 px = 13×12 tuiles, Over) : pendant asymétrique authentique (spirales & taches Spinda décalées) pour tout écartement.',
        'hd': KMC / 'hd/Rideau_Droit_Spinda_Troubadour_HD_sans_fond.png',
        'complet_1x': KMC / 'assets_1x/Rideau_Droit_Spinda_Troubadour_1x_complet.png',
        'arriere_1x': None,
        'avant_1x': None,
        'nuit_1x': KMC / 'assets_1x/Rideau_Droit_Spinda_Troubadour_1x_nuit_complet.png',
        'tiles': [],
    },
    {
        'num': '06e',
        'id': 'lambrequin_arche_spinda_troubadour',
        'title': 'Grande Arche Supérieure Ouverte Seule — Spinda Troubadour (Over)',
        'usage_pmdo': 'Arche horizontale de rideaux ouverts seule (208×144 px = 26×18 tuiles, Over) : 5 festons Spinda Troubadour, anneaux ajourés alpha = 0 et pans latéraux.',
        'hd': KMC / 'hd/Lambrequin_Arche_Spinda_Troubadour_HD_sans_fond.png',
        'complet_1x': KMC / 'assets_1x/Lambrequin_Arche_Spinda_Troubadour_1x_complet.png',
        'arriere_1x': None,
        'avant_1x': None,
        'nuit_1x': KMC / 'assets_1x/Lambrequin_Arche_Spinda_Troubadour_1x_nuit_complet.png',
        'tiles': [],
    },
    {
        'num': '06f',
        'id': 'estrade_fond_ferme_spinda_troubadour',
        'title': 'Variante Scène avec Fond Rideau Rouge Drapé — Spinda Troubadour',
        'usage_pmdo': 'Variante adossée avec rideau rouge continu à l’arrière-plan (208×168 px = 26×21 tuiles, Arrière Under + Avant Over).',
        'hd': KMC / 'hd/Estrade_Fond_Ferme_Spinda_Troubadour_HD_sans_fond.png',
        'complet_1x': KMC / 'assets_1x/Estrade_Fond_Ferme_Spinda_Troubadour_1x_complet.png',
        'arriere_1x': KMC / 'assets_1x/Estrade_Fond_Ferme_Spinda_Troubadour_1x_arriere.png',
        'avant_1x': KMC / 'assets_1x/Estrade_Fond_Ferme_Spinda_Troubadour_1x_avant.png',
        'nuit_1x': KMC / 'assets_1x/Estrade_Fond_Ferme_Spinda_Troubadour_1x_nuit_complet.png',
        'tiles': [
            R / '.cache/mobilier_cafe_complet_v1/mobilier_cafe_complet/Content/Tile/EST2_00_ARRIERE.tile',
            R / '.cache/mobilier_cafe_complet_v1/mobilier_cafe_complet/Content/Tile/EST2_01_AVANT.tile',
            R / '.cache/mobilier_cafe_complet_v1/mobilier_cafe_complet/Content/Tile/EST2_02_COMPLET.tile',
            R / '.cache/mobilier_cafe_complet_v1/mobilier_cafe_complet/Content/Tile/EST2_03_NUIT.tile',
        ],
    },
    {
        'num': '07',
        'id': 'piano_cafe_bois',
        'title': 'Piano Droit en Bois Miel & Velours Rouge',
        'usage_pmdo': 'Meuble 1× (72×80 px = 9×10 tuiles de 8 px) prêt à importer tel quel via PNG to Tileset.',
        'hd': KMC / 'hd/Piano_Cafe_Bois_HD_sans_fond.png',
        'complet_1x': KMC / 'assets_1x/Piano_Cafe_Bois_1x_complet.png',
        'arriere_1x': None,
        'avant_1x': None,
        'nuit_1x': KMC / 'assets_1x/Piano_Cafe_Bois_1x_nuit_complet.png',
        'tiles': [
            R / '.cache/mobilier_cafe_complet_v1/mobilier_cafe_complet/Content/Tile/ACC1_00_JOUR.tile',
            R / '.cache/mobilier_cafe_complet_v1/mobilier_cafe_complet/Content/Tile/ACC1_01_NUIT.tile',
        ],
    },
    {
        'num': '08',
        'id': 'jukebox_cafe',
        'title': 'Jukebox / Phonographe Bois & Cuivre Doré',
        'usage_pmdo': 'Meuble 1× (48×88 px = 6×11 tuiles de 8 px) prêt à importer tel quel via PNG to Tileset.',
        'hd': KMC / 'hd/Jukebox_Cafe_HD_sans_fond.png',
        'complet_1x': KMC / 'assets_1x/Jukebox_Cafe_1x_complet.png',
        'arriere_1x': None,
        'avant_1x': None,
        'nuit_1x': KMC / 'assets_1x/Jukebox_Cafe_1x_nuit_complet.png',
        'tiles': [],
    },
    {
        'num': '09',
        'id': 'table_cabaret_rouge',
        'title': 'Table Ronde de Cabaret (Nappe Velours Rouge)',
        'usage_pmdo': 'Meuble 1× (48×56 px = 6×7 tuiles de 8 px, même gabarit que les tables Halcyon).',
        'hd': KMC / 'hd/Table_Cabaret_Rouge_HD_sans_fond.png',
        'complet_1x': KMC / 'assets_1x/Table_Cabaret_Rouge_1x_complet.png',
        'arriere_1x': None,
        'avant_1x': None,
        'nuit_1x': KMC / 'assets_1x/Table_Cabaret_Rouge_1x_nuit_complet.png',
        'tiles': [],
    },
    {
        'num': '10',
        'id': 'banquette_velours_rouge',
        'title': 'Banquette Capitonnée Bois & Velours Rouge',
        'usage_pmdo': 'Meuble 1× (88×56 px = 11×7 tuiles de 8 px) pour la salle de spectacle / café.',
        'hd': KMC / 'hd/Banquette_Velours_Rouge_HD_sans_fond.png',
        'complet_1x': KMC / 'assets_1x/Banquette_Velours_Rouge_1x_complet.png',
        'arriere_1x': None,
        'avant_1x': None,
        'nuit_1x': KMC / 'assets_1x/Banquette_Velours_Rouge_1x_nuit_complet.png',
        'tiles': [],
    },
    {
        'num': '11',
        'id': 'kirlia_kiosque_guichet',
        'title': 'Kiosque Kirlia à Guichet Ouvert (Bonus)',
        'usage_pmdo': 'Pavillon Kirlia (112×120 px = 14×15 tuiles) à guichet 100 % transparent sans noir, comptoir nu sans feuille ni café.',
        'hd': KKR / 'hd/Kiosque_Kirlia_HD_sans_magenta.png',
        'complet_1x': KKR / 'assets_1x/Kiosque_Kirlia_1x_complet.png',
        'arriere_1x': KKR / 'assets_1x/Kiosque_Kirlia_1x_arriere.png',
        'avant_1x': KKR / 'assets_1x/Kiosque_Kirlia_1x_avant.png',
        'nuit_1x': KKR / 'assets_1x/Kiosque_Kirlia_1x_nuit_complet.png',
        'tiles': [
            R / '.cache/kiosque_kirlia_spinda_v1/kiosque_kirlia_spinda/Content/Tile/KKR1_00_ARRIERE.tile',
            R / '.cache/kiosque_kirlia_spinda_v1/kiosque_kirlia_spinda/Content/Tile/KKR1_01_AVANT.tile',
            R / '.cache/kiosque_kirlia_spinda_v1/kiosque_kirlia_spinda/Content/Tile/KKR1_02_COMPLET.tile',
            R / '.cache/kiosque_kirlia_spinda_v1/kiosque_kirlia_spinda/Content/Tile/KKR1_03_NUIT.tile',
        ],
    },
]


def main() -> None:
    tools = loadmod('idx_tools_export', R / 'source/pmdo_cote/INSTALLER.py')
    if DEST.exists():
        shutil.rmtree(DEST)
    d_1x = DEST / '1x_PMDO_8px_sans_fond'
    d_hd = DEST / 'HD_sans_fond'
    d_sh = DEST / 'tilesheets_import_pmdo_8px'
    for d in (d_1x, d_hd, d_sh, MOD_DIR / 'Content/Tile'):
        d.mkdir(parents=True, exist_ok=True)

    # Copier les 4 planches groupées 8 px prêtes pour Data -> Tiles -> Import PNG dans PMDO
    sheets_copied = []
    for src, dst_name in [
        (KMC / 'tilesheets/Tilesheet_Scene_Spinda_Troubadour_Modules_Jour_1x.png', 'Planche_00_Scene_et_Rideaux_Spinda_Troubadour_Jour_8px.png'),
        (KMC / 'tilesheets/Tilesheet_Scene_Spinda_Troubadour_Modules_Nuit_1x.png', 'Planche_00_Scene_et_Rideaux_Spinda_Troubadour_Nuit_8px.png'),
        (KTR / 'tilesheets/Tilesheet_Kiosques_Cafe_Jour_1x.png', 'Planche_01_Spinda_Qulbutoke_Sucreine_Jour_8px.png'),
        (KTR / 'tilesheets/Tilesheet_Kiosques_Cafe_Nuit_1x.png', 'Planche_01_Spinda_Qulbutoke_Sucreine_Nuit_8px.png'),
        (KMC / 'tilesheets/Tilesheet_Mobilier_Cafe_Jour_1x.png', 'Planche_02_Scene_Kirlia_Charmilly_Cabaret_Jour_8px.png'),
        (KMC / 'tilesheets/Tilesheet_Mobilier_Cafe_Nuit_1x.png', 'Planche_02_Scene_Kirlia_Charmilly_Cabaret_Nuit_8px.png'),
        (KMC / 'tilesheets/Tilesheet_Accessoires_Cabaret_Jour_1x.png', 'Planche_03_Piano_Jukebox_Table_Banquette_Jour_8px.png'),
        (KKR / 'tilesheets/Spinda_kirlia_kiosque_jour.png', 'Planche_04_Kiosque_Kirlia_Guichet_Jour_8px.png'),
    ]:
        out_p = d_sh / dst_name
        shutil.copyfile(src, out_p)
        sheets_copied.append(out_p)

    js_entries = []
    js_zip_files = []  # Tous les fichiers 1x + planches + Mod .tile embarqués pour téléchargement ZIP Blob 100% hors-ligne !

    for c in CATALOG:
        prefix = f"{c['num']}_{c['id']}"
        hd_dst = d_hd / f"{prefix}_HD_sans_fond.png"
        c1_dst = d_1x / f"{prefix}_1x_complet.png"
        n1_dst = d_1x / f"{prefix}_1x_nuit.png"
        shutil.copyfile(c['hd'], hd_dst)
        shutil.copyfile(c['complet_1x'], c1_dst)
        shutil.copyfile(c['nuit_1x'], n1_dst)

        arr = np.array(Image.open(c1_dst).convert('RGBA'))
        assert set(np.unique(arr[..., 3])) <= {0, 255}, c1_dst
        assert arr.shape[0] % 8 == 0 and arr.shape[1] % 8 == 0, c1_dst
        arr_hd = np.array(Image.open(hd_dst).convert('RGBA'))
        assert set(np.unique(arr_hd[..., 3])) == {0, 255}, hd_dst

        js_zip_files.append({'arc': f'1x_PMDO_8px_sans_fond/{c1_dst.name}', 'b64': b64(c1_dst)})
        js_zip_files.append({'arc': f'1x_PMDO_8px_sans_fond/{n1_dst.name}', 'b64': b64(n1_dst)})

        back_rel = front_rel = None
        back_b64 = front_b64 = None
        if c['arriere_1x'] and c['avant_1x']:
            b_dst = d_1x / f"{prefix}_1x_arriere.png"
            f_dst = d_1x / f"{prefix}_1x_avant.png"
            shutil.copyfile(c['arriere_1x'], b_dst)
            shutil.copyfile(c['avant_1x'], f_dst)
            back_rel = b_dst.relative_to(R).as_posix()
            front_rel = f_dst.relative_to(R).as_posix()
            back_b64 = b64(b_dst)
            front_b64 = b64(f_dst)
            js_zip_files.append({'arc': f'1x_PMDO_8px_sans_fond/{b_dst.name}', 'b64': back_b64})
            js_zip_files.append({'arc': f'1x_PMDO_8px_sans_fond/{f_dst.name}', 'b64': front_b64})

        for tp in c['tiles']:
            shutil.copyfile(tp, MOD_DIR / 'Content/Tile' / tp.name)

        js_entries.append({
            'num': c['num'],
            'id': c['id'],
            'title': c['title'],
            'usage': c['usage_pmdo'],
            'w1x': int(arr.shape[1]),
            'h1x': int(arr.shape[0]),
            'whd': int(arr_hd.shape[1]),
            'hhd': int(arr_hd.shape[0]),
            'rel_1x': c1_dst.relative_to(R).as_posix(),
            'name_1x': c1_dst.name,
            'b64_1x': b64(c1_dst),
            'rel_nuit': n1_dst.relative_to(R).as_posix(),
            'name_nuit': n1_dst.name,
            'b64_nuit': b64(n1_dst),
            'rel_back': back_rel,
            'name_back': Path(back_rel).name if back_rel else None,
            'b64_back': back_b64,
            'rel_front': front_rel,
            'name_front': Path(front_rel).name if front_rel else None,
            'b64_front': front_b64,
            'rel_hd': hd_dst.relative_to(R).as_posix(),
            'name_hd': hd_dst.name,
            'b64_hd': b64(hd_dst),
        })

    # Reconstruire un index.idx unique couvrant TOUTES les 30 banques .tile réunies !
    nodes = {}
    for p in sorted((MOD_DIR / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = tools.read_node(f)
    (MOD_DIR / 'Content/Tile/index.idx').write_bytes(tools.encode_index(nodes))

    ns = 'cafe_spinda_metano_complet'
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/projet-creation-pmdo/' + ns)
    (MOD_DIR / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Pack Complet Objets Cafe &amp; Estrade Sans Fond (30 banques .tile) - PMDO 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Tous les comptoirs (Spinda, Qulbutoke, Sucreine, Kirlia, Charmilly), Estrade rideaux rouges, Piano, Jukebox, Table &amp; Banquette sans fond.</Description>
  <Namespace>{ns}</Namespace>
  <UUID>{ident}</UUID>
  <Version>1.0.0.0</Version>
  <GameVersion>0.8.12.0</GameVersion>
  <ModType>Quest</ModType>
  <Relationships />
</Header>
''')
    script = (R / 'source/pmdo_cote/INSTALLER.py').read_text()
    needle = '            relative = src.relative_to(source)\n'
    script = script.replace(needle, needle + "            if relative.as_posix() == 'Content/Tile/index.idx':\n                continue\n")
    (MOD_DIR / 'INSTALLER.py').write_text(script)

    guide_txt = """COMMENT PLACER CES OBJETS SANS FOND DANS PMDO 0.8.12 (2 MÉTHODES AU CHOIX)
===========================================================================

MÉTHODE A — LA PLUS SIMPLE (IMPORT PNG DIRECT DANS L'ÉDITEUR PMDO DEV) :
1. Ouvrez PMDO avec l'éditeur Dev (`-dev`), puis ouvrez votre Ground (ex: Café Spinda / Café Métano) dans l'éditeur de carte.
2. Menu `Data` -> `Tiles` (ou onglet Tilesets de la carte) -> `Import` / `PNG to Tileset` :
   - Taille de tuile (`Tile Size`) : `8` (`8 x 8 px`)
   - Sélectionnez au choix :
     * les PNG individuels dans `1x_PMDO_8px_sans_fond/` (ex: `01_spinda_comptoir_1x_arriere.png` et `01_spinda_comptoir_1x_avant.png`),
     * OU les planches groupées dans `tilesheets_import_pmdo_8px/`.
3. Tous les PNG ont déjà `alpha = 0` (100 % sans fond, 0 px de magenta, grille exacte de 8 px) :
   - Pour un meuble simple (Piano, Jukebox, Table, Banquette) : peignez le rectangle complet sur un calque `Objects`.
   - Pour un comptoir avec Pokémon vendeur derrière (Spinda, Qulbutoké, Sucreine, Kirlia, Charmilly) :
     * placez `*_1x_arriere.png` sur un calque `Objects` normal (sous les entités),
     * placez `*_1x_avant.png` exactement aux MÊMES coordonnées `(X, Y)` sur un calque `Over` (au-dessus des entités),
     * placez votre Pokémon vendeur (`NPC Spawner`) entre les deux !
   - Pour l'Estrade aux Rideaux Rouges :
     * placez `06_estrade_rideaux_rouges_1x_arriere.png` sur un calque sous les personnages (`Under` / `Floor_Objects`) pour que les Pokémon marchent sur le bois de scène,
     * et `06_estrade_rideaux_rouges_1x_avant.png` sur un calque `Over` aux mêmes `(X, Y)` pour le rideau supérieur !

MÉTHODE B — MOD PRÊT À COPIER (30 BANQUES `.tile` DÉJÀ COMPILÉES) :
- Copiez le dossier `Mod_PMDO_0812_Pret_A_Placer/cafe_spinda_metano_complet/` directement dans `<dossier_PMDO>/MODS/`,
  OU lancez `python INSTALLER.py "<dossier_PMDO>/MODS/<votre_mod>"` pour fusionner automatiquement les 30 banques `.tile` dans `index.idx` !
"""
    (DEST / 'LISEZ_MOI_IMPORT_PMDO.txt').write_text(guide_txt)
    js_zip_files.append({
        'arc': 'LISEZ_MOI_IMPORT_PMDO.txt',
        'b64': base64.b64encode(guide_txt.encode()).decode(),
    })
    for sp in sheets_copied:
        js_zip_files.append({'arc': f'tilesheets_import_pmdo_8px/{sp.name}', 'b64': b64(sp)})
    for mp in sorted(MOD_DIR.rglob('*')):
        if mp.is_file():
            js_zip_files.append({
                'arc': 'Mod_PMDO_0812_Pret_A_Placer/cafe_spinda_metano_complet/' + mp.relative_to(MOD_DIR).as_posix(),
                'b64': b64(mp),
            })

    # Créer l'archive .zip PMDO prête à télécharger (2.01 Mo : tous les PNG 1x 8px sans fond + planches + Mod 30 banques .tile)
    pmdo_zip_pairs = [(p, p.relative_to(DEST).as_posix()) for p in sorted(DEST.rglob('*')) if p.is_file() and 'HD_sans_fond/' not in p.as_posix() and p.suffix != '.zip']
    zip1 = DEST / 'PACK_PMDO_1X_ET_MOD_0812_SANS_FOND.zip'
    zip_files(zip1, pmdo_zip_pairs)

    payload = {
        'items': js_entries,
        'sheets': [{'name': p.name, 'rel': p.relative_to(R).as_posix(), 'b64': b64(p)} for p in sheets_copied],
        'zip_pmdo_entries': js_zip_files,
        'zip1_rel': zip1.relative_to(R).as_posix(),
        'zip2_rel': None,
    }
    html = PAGE_HTML.replace('__PAYLOAD__', json.dumps(payload, ensure_ascii=False))
    out_page = R / 'telecharger_objets_cafe_pmdo.html'
    out_page.write_text(html)
    print(f'OK export: {len(nodes)} banques .tile, {zip1.name}={zip1.stat().st_size/1e6:.2f} Mo, page={out_page.stat().st_size/1e6:.2f} Mo')


PAGE_HTML = """<!doctype html>
<html lang="fr">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Télécharger les 11 Objets Sans Fond pour PMDO 0.8.12</title>
<style>
body{background:#211b17;color:#f6ecda;font:15px/1.55 system-ui,sans-serif;margin:0;padding:24px}
main{max-width:1320px;margin:auto}
h1{font-size:28px;margin:0 0 8px;color:#ffd57e}
h2{font-size:19px;margin:0 0 10px;color:#ffd57e}
p{color:#e2d4c0;max-width:95ch;margin:6px 0 12px}
.hero{background:#342922;border:2px solid #f0b44c;border-radius:12px;padding:18px 20px;margin-bottom:22px}
.steps{background:#2a211b;border:1px solid #634f40;border-radius:10px;padding:14px 18px;margin-bottom:22px;font-size:14px}
.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(340px,1fr));gap:16px}
.card{background:#312720;border:1px solid #645041;border-radius:10px;padding:14px}
canvas{display:block;image-rendering:pixelated;border-radius:7px;border:1px solid #5a4739;margin:8px 0;max-width:100%}
button,a.btn{background:#f2be5c;color:#1f1508;border:0;border-radius:7px;padding:8px 13px;margin:4px 5px 4px 0;cursor:pointer;font-weight:700;text-decoration:none;display:inline-block;font-size:13.2px}
button.big{background:#e6484d;color:#fff;font-size:15.5px;padding:11px 18px}
button.sec{background:#dfd3be;color:#221912;font-weight:600;padding:6px 10px;font-size:12.5px}
.status{display:inline-block;margin-left:10px;color:#a9efb0;font-weight:700}
code{color:#ffd57e;background:#241c16;padding:1px 5px;border-radius:4px}
</style>
<main>
<h1>Téléchargement Direct — 11 Objets Café &amp; Estrade 100 % Sans Fond (PMDO 0.8.12)</h1>
<p>Le damier ci-dessous montre la <strong>vraie transparence alpha (`alpha = 0`)</strong> enregistrée dans chaque PNG : <strong>aucun fond magenta, aucun fond noir, 0 px de frange violette, grille exacte `8 × 8 px`</strong> prêts à importer dans PMDO !</p>

<section class="hero">
  <h2>Télécharger tout le pack d'un seul clic (recommandé pour PMDO)</h2>
  <button class="big" id="btnZipPmdo">⬇ Télécharger TOUT le Pack PMDO (.ZIP — PNG 1× 8px sans fond + Planches + Mod 30 banques .tile)</button>
  <button id="btnZipAll">⬇ Télécharger TOUS les 11 Masters HD sans fond (.ZIP)</button>
  <span class="status" id="dlStatus"></span>
  <div style="margin-top:10px">
    <strong style="font-size:13.5px;color:#e6d8c3">Planches groupées prêtes pour <code>Data → Tiles → Import (8×8)</code> :</strong><br>
    <span id="sheetsBar"></span>
  </div>
</section>

<section class="steps">
  <strong>Comment les placer dans PMDO 0.8.12 en 30 secondes :</strong>
  <ol style="margin:6px 0 0;padding-left:20px">
    <li><strong>Option 1 — Import PNG direct dans l'éditeur PMDO (`-dev`) :</strong> ouvrez votre Ground → onglet <code>Tiles</code> → <code>Import / PNG to Tileset</code> avec taille de tuile <code>8 × 8</code> → choisissez le PNG <code>1× sans fond</code> voulu. Pour mettre un Pokémon derrière son comptoir, placez <code>*_1x_arriere.png</code> sur un calque <code>Objects</code> normal et <code>*_1x_avant.png</code> aux <strong>mêmes coordonnées (X, Y)</strong> sur un calque <code>Over</code> !</li>
    <li><strong>Option 2 — Mod <code>.tile</code> déjà compilé (zéro découpe manuelle) :</strong> dans le ZIP téléchargé ci-dessus, copiez directement le dossier <code>Mod_PMDO_0812_Pret_A_Placer/cafe_spinda_metano_complet/</code> dans <code>PMDO/MODS/</code> (ou lancez son <code>INSTALLER.py</code> vers votre mod existant) : les <strong>30 banques <code>.tile</code></strong> apparaissent directement dans l'éditeur !</li>
  </ol>
</section>

<div style="margin-bottom:12px">
  Fond d'aperçu des vignettes :
  <button class="sec" data-bg="checker">Damier transparent (preuve alpha = 0)</button>
  <button class="sec" data-bg="#3a3028">Bois neutre (#3a3028)</button>
  <button class="sec" data-bg="#12161e">Sombre</button>
</div>

<div class="grid" id="grid"></div>
</main>
<script>
const P=__PAYLOAD__;
const isHttp=location.protocol.startsWith('http');

function b64ToBytes(b64){
  const bin=atob(b64),len=bin.length,u=new Uint8Array(len);
  for(let i=0;i<len;i++)u[i]=bin.charCodeAt(i);
  return u;
}
function saveBlob(bytes,mime,filename,relUrl){
  const st=document.getElementById('dlStatus');
  // Si servi en HTTP sur le serveur Live Preview :8000, ?dl=1 envoie Content-Disposition: attachment natif !
  if(isHttp&&relUrl){
    const a=document.createElement('a');
    a.href=relUrl+'?dl=1';
    a.download=filename;
    document.body.appendChild(a);a.click();a.remove();
    st.textContent='✓ Téléchargement lancé : '+filename;
    return;
  }
  const blob=new Blob([bytes],{type:mime});
  const url=URL.createObjectURL(blob);
  const a=document.createElement('a');
  a.href=url;a.download=filename;
  document.body.appendChild(a);a.click();a.remove();
  setTimeout(()=>URL.revokeObjectURL(url),15000);
  st.textContent='✓ Téléchargement lancé : '+filename;
}

// Générateur ZIP standard CRC-32 autonome en mémoire (fonctionne même sans serveur !)
const CRC_TABLE=(()=>{const t=new Uint32Array(256);for(let i=0;i<256;i++){let c=i;for(let k=0;k<8;k++)c=(c&1)?(0xEDB88320^(c>>>1)):(c>>>1);t[i]=c>>>0}return t})();
function crc32(u8){let c=0xFFFFFFFF;for(let i=0;i<u8.length;i++)c=CRC_TABLE[(c^u8[i])&0xFF]^(c>>>8);return(c^0xFFFFFFFF)>>>0}
function makeZipBytes(entries){
  const enc=new TextEncoder(),parts=[],central=[];let offset=0;
  for(const e of entries){
    const nameB=enc.encode(e.name),data=e.bytes,crc=crc32(data);
    const lh=new Uint8Array(30+nameB.length),lv=new DataView(lh.buffer);
    lv.setUint32(0,0x04034b50,true);lv.setUint16(4,20,true);lv.setUint16(8,0,true);
    lv.setUint32(14,crc,true);lv.setUint32(18,data.length,true);lv.setUint32(22,data.length,true);
    lv.setUint16(26,nameB.length,true);lh.set(nameB,30);
    parts.push(lh,data);
    const ch=new Uint8Array(46+nameB.length),cv=new DataView(ch.buffer);
    cv.setUint32(0,0x02014b50,true);cv.setUint16(4,20,true);cv.setUint16(6,20,true);
    cv.setUint32(16,crc,true);cv.setUint32(20,data.length,true);cv.setUint32(24,data.length,true);
    cv.setUint16(28,nameB.length,true);cv.setUint32(42,offset,true);ch.set(nameB,46);
    central.push(ch);offset+=lh.length+data.length;
  }
  const cdStart=offset;let cdSize=0;central.forEach(c=>{parts.push(c);cdSize+=c.length});
  const eocd=new Uint8Array(22),ev=new DataView(eocd.buffer);
  ev.setUint32(0,0x06054b50,true);ev.setUint16(8,entries.length,true);ev.setUint16(10,entries.length,true);
  ev.setUint32(12,cdSize,true);ev.setUint32(16,cdStart,true);parts.push(eocd);
  const total=parts.reduce((s,p)=>s+p.length,0),out=new Uint8Array(total);
  let p=0;for(const chunk of parts){out.set(chunk,p);p+=chunk.length}
  return out;
}

document.getElementById('btnZipPmdo').onclick=()=>{
  const z=makeZipBytes(P.zip_pmdo_entries.map(e=>({name:e.arc,bytes:b64ToBytes(e.b64)})));
  saveBlob(z,'application/zip','PACK_PMDO_1X_ET_MOD_0812_SANS_FOND.zip',P.zip1_rel);
};
document.getElementById('btnZipAll').onclick=()=>{
  const z=makeZipBytes(P.items.map(it=>({name:'HD_sans_fond/'+it.name_hd,bytes:b64ToBytes(it.b64_hd)})));
  saveBlob(z,'application/zip','PACK_11_OBJETS_HD_SANS_FOND.zip',P.zip2_rel);
};

const sbar=document.getElementById('sheetsBar');
P.sheets.forEach(s=>{
  const b=document.createElement('button');b.className='sec';b.textContent='⬇ '+s.name;
  b.onclick=()=>saveBlob(b64ToBytes(s.b64),'image/png',s.name,s.rel);
  sbar.appendChild(b);
});

let bgMode='checker';
const grid=document.getElementById('grid'),canvases=[];
P.items.forEach(it=>{
  const card=document.createElement('div');card.className='card';
  card.innerHTML=`<div style="display:flex;justify-content:space-between;align-items:baseline">
    <strong style="font-size:16px;color:#ffd57e">${it.num}. ${it.title}</strong>
    <small style="color:#cbbba6">1× ${it.w1x}×${it.h1x} px</small>
  </div>
  <canvas width="320" height="230"></canvas>
  <div>
    <button data-k="1x">⬇ PNG 1× PMDO (${it.w1x}×${it.h1x})</button>
    ${it.b64_back?`<button class="sec" data-k="back">⬇ 1× Arrière</button><button class="sec" data-k="front">⬇ 1× Avant</button>`:''}
    <button class="sec" data-k="nuit">⬇ 1× Nuit</button>
    <button class="sec" data-k="hd">⬇ PNG HD sans fond (${it.whd}×${it.hhd})</button>
  </div>
  <p style="font-size:12.5px;color:#cfc0ac;margin:7px 0 0">${it.usage}</p>`;
  grid.appendChild(card);
  const cv=card.querySelector('canvas');
  const im=new Image();im.src='data:image/png;base64,'+it.b64_1x;
  canvases.push({cv,im});
  card.querySelector('[data-k="1x"]').onclick=()=>saveBlob(b64ToBytes(it.b64_1x),'image/png',it.name_1x,it.rel_1x);
  card.querySelector('[data-k="nuit"]').onclick=()=>saveBlob(b64ToBytes(it.b64_nuit),'image/png',it.name_nuit,it.rel_nuit);
  card.querySelector('[data-k="hd"]').onclick=()=>saveBlob(b64ToBytes(it.b64_hd),'image/png',it.name_hd,it.rel_hd);
  if(it.b64_back){
    card.querySelector('[data-k="back"]').onclick=()=>saveBlob(b64ToBytes(it.b64_back),'image/png',it.name_back,it.rel_back);
    card.querySelector('[data-k="front"]').onclick=()=>saveBlob(b64ToBytes(it.b64_front),'image/png',it.name_front,it.rel_front);
  }
});

function renderAll(){
  canvases.forEach(({cv,im})=>{
    const ctx=cv.getContext('2d'),W=cv.width,H=cv.height;ctx.imageSmoothingEnabled=false;
    if(bgMode==='checker'){for(let y=0;y<H;y+=16)for(let x=0;x<W;x+=16){ctx.fillStyle=((x+y)/16)%2?'#594f46':'#352e28';ctx.fillRect(x,y,16,16)}}
    else{ctx.fillStyle=bgMode;ctx.fillRect(0,0,W,H)}
    const sc=Math.min(2.0,(W-16)/Math.max(1,im.width),(H-16)/Math.max(1,im.height));
    const dw=Math.round(im.width*sc),dh=Math.round(im.height*sc);
    ctx.drawImage(im,Math.round((W-dw)/2),Math.round((H-dh)/2),dw,dh);
  });
}
document.querySelectorAll('[data-bg]').forEach(b=>b.onclick=()=>{bgMode=b.dataset.bg;renderAll()});
Promise.all(canvases.map(x=>x.im.decode().catch(()=>{}))).then(renderAll);
</script>
</html>
"""


if __name__ == '__main__':
    main()
