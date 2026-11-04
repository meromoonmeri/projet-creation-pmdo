#!/usr/bin/env python3
"""Collecte les aperçus de TOUTES les maps du projet et construit galerie/data.json.

Les images vivent dans meromoonmeri/projet-pmdo (commit 6cca4a0) ; ce dépôt-ci n'en
contient que les méthodes. Ce script télécharge les meilleures vues par lot via
l'API GitHub (blobs bruts), fabrique des miniatures légères dans galerie/img/ et
écrit galerie/data.json consommé par galerie/index.html.

    GH_TOKEN=$(gh auth token) python3 galerie/collect.py

Reproductible : relancer après une nouvelle livraison. Les images sont ignorées
par git (voir .gitignore) ; seuls ce script, le gabarit et data.json sont versionnés.
"""
import base64, concurrent.futures as cf, io, json, os, pathlib, re, subprocess, sys, urllib.request

R = pathlib.Path(__file__).resolve().parents[1]
IMG = R / 'galerie' / 'img'
IMG.mkdir(parents=True, exist_ok=True)
REPO = 'meromoonmeri/projet-pmdo'
REF = '6cca4a09380211e510ab1bea454a1b1926ef4b5a'
TOKEN = os.environ.get('GH_TOKEN') or subprocess.run(['gh', 'auth', 'token'], capture_output=True, text=True).stdout.strip()
TREE_CACHE = R / 'galerie' / '.tree_cache.json'

from PIL import Image, ImageSequence

# ---------------------------------------------------------------- tree
def load_tree():
    if TREE_CACHE.exists():
        return json.load(open(TREE_CACHE))
    url = f'https://api.github.com/repos/{REPO}/git/trees/{REF}?recursive=1'
    req = urllib.request.Request(url, headers={'Authorization': f'Bearer {TOKEN}', 'User-Agent': 'galerie-pmdo'})
    d = json.load(urllib.request.urlopen(req, timeout=120))
    json.dump(d, open(TREE_CACHE, 'w'))
    return d

TREE = load_tree()
BLOBS = {e['path']: (e['sha'], e.get('size', 0)) for e in TREE['tree'] if e['type'] == 'blob'}
print(f'{len(BLOBS)} fichiers dans l\'arbre distant', flush=True)

def rfiles(prefix, exts=('.png', '.webp', '.gif', '.jpg', '.jpeg')):
    return sorted(p for p in BLOBS if p.startswith(prefix) and p.lower().endswith(exts))

# ---------------------------------------------------------------- sélection
def multi(lot, pattern, exclude=()):
    rx = re.compile(pattern)
    out = []
    for p in rfiles(f'renders/{lot}/'):
        rel = p[len(f'renders/{lot}/'):]
        if rx.fullmatch(rel) and not any(x in rel for x in exclude):
            out.append(p)
    return out

def first(lot, *rels):
    for rel in rels:
        p = f'renders/{lot}/{rel}'
        if p in BLOBS:
            return [p]
    return []

# Choix explicites par lot (sinon : heuristique générique plus bas)
def select(lot):
    L = lot
    # Lots produits localement (pas encore dans le dépôt distant) : images lues sur disque.
    loc = R / 'renders' / lot / 'review'
    if loc.is_dir() and not any(p.startswith(f'renders/{lot}/') for p in BLOBS):
        for pat in ('*_scene_animee.webp', '*_scene_t000.png'):
            hits = sorted(loc.glob(pat))
            if hits:
                return ['local:' + str(h.relative_to(R)) for h in hits[:1]]
    # séries avec review/
    if re.match(r'(entree_|fin_)', L) and 'sud_nord' in L or L.startswith('fin_'):
        s = multi(L, r'review/\w+_scene_animee\.webp')
        if s:
            # plusieurs variantes (jour/nuit…) : garder jour en premier, max 2
            s.sort(key=lambda p: ('jour' not in p, p))
            return s[:2] if len(s) > 1 and ('jour' in s[0] or 'aube' in s[0]) else s[:1]
    O = {
        'entree_cratere_magma_v1': lambda: first(L, 'review/ECM1_scene_animee.webp'),
        'arene_terapagos_v1': lambda: first(L, 'ATP1/review/ATP1_scene_animee.webp'),
        'ruines_zarbi_v1': lambda: first(L, 'RZD1/review/RZD1_scene_animee.webp'),
        'colonnes_lances_v1': lambda: first(L, 'CLR1/review/CLR1_scene_animee.webp'),
        'zone_zero_v1': lambda: multi(L, r'\w+/review/\w+_scene_animee\.webp'),
        'zone_zero_v2': lambda: multi(L, r'\w+/review/\w+_scene_animee\.webp'),
        'zone_reveil_prairie_horizon_v1': lambda: first(L, 'review/ZRV1_jour_scene_animee.webp'),
        'zone_reveil_prairie_horizon_v2': lambda: first(L, 'review/ZRV2_jour_scene_animee.webp'),
        'metano_expeditions_actuel': lambda: multi(L, r'[^/]+/jour\.png'),
        'retouches_zones_v6': lambda: multi(L, r'\d\d_[^/]+\.png', exclude=('_nuit',)),
        'entrees_pmd_collection': lambda: multi(L, r'\d\d_[^/]+\.png', exclude=('_nuit',)),
        'entrees_halcyon_generees': lambda: multi(L, r'\d\d_[^/]+\.png', exclude=('_nuit',)),
        'final_duos_v1': lambda: multi(L, r'D22_[^/]+\.png'),
        'network_zones_multicalques_v1': lambda: multi(L, r'[^/]+/composite\.png'),
        'network_zones_multicalques_v2': lambda: multi(L, r'[^/]+/composite\.png'),
        'network_zones_multicalques_v3': lambda: multi(L, r'[^/]+/composite\.png'),
        'foret_saisons_v1': lambda: multi(L, r'[^/]+/jour/COMPOSITION\.png'),
        'crooked_statique_v2': lambda: multi(L, r'\d\d/composition\.png'),
        'donjons_generes_dtef_v3': lambda: multi(L, r'apercus/[^/]+jour/EXTRAIT_2S\.webp'),
        'designs_dtef_v4': lambda: multi(L, r'apercus/[^/]+jour/EXTRAIT_2S\.webp'),
        'dungeon_autotiles_v1': lambda: multi(L, r'apercus/[^/]+/extrait\.webp'),
        'dungeon_biomes_v1': lambda: first(L, 'apercus/DB1_collection.png'),
        'etude_animations_canoniques_sky_v1': lambda: multi(L, r'cartes/\w+_vrai_\d+ticks\.webp'),
        'caps_terrasses_v3': lambda: multi(L, r'\d\d_[^/]+_scene\.png'),
        'caps_terrasses_v4': lambda: multi(L, r'\d\d_[^/]+_scene\.png'),
        'cafe_multietage_v1': lambda: first(L, 'PLANCHE_A.png') + first(L, 'PLANCHE_B.png'),
        'cafe_multietage_v2': lambda: first(L, 'PLANCHE_A.png') + first(L, 'PLANCHE_B.png'),
        'cafe_multietage_v3': lambda: first(L, 'accueil_ludicolo/01_salle_intacte.png'),
        'cafe_spinda_reseau_v4': lambda: first(L, 'SpindaV4_accueil_magenta.webp'),
        'cafe_spinda_revisite_v5': lambda: multi(L, r'prototypes/[^/]+\.(png|jpg|webp)')[:1],
        'cafe_spinda_revisite_v6': lambda: first(L, 'Spinda_generations_NS.jpg'),
        'cafe_spinda_revisite_v7': lambda: first(L, 'SpindaV7_corrections.jpg'),
        'cafe_spinda_revisite_v8': lambda: first(L, 'SpindaV8_jour_nuit.jpg'),
        'cafe_halcyon_agrandi_v1': lambda: first(L, 'CafeHalcyon_terrain_transparent.png'),
        'spinda_decor_v1': lambda: first(L, 'apercus/SpindaDecor_cafe_demonstration.png'),
        'spinda_torches_v1': lambda: first(L, 'Torche_N_animation.webp'),
        'casino_network_v1': lambda: first(L, 'Casino_apercu_anime.webp'),
        'ledian_dojo_v1': lambda: first(L, 'PLANCHE.png'),
        'beach_extension_v2': lambda: first(L, 'BeachExt_extension_jour.png'),
        'beach_layers_v1': lambda: first(L, 'BeachV1_plage_animee.webp'),
        'beach_network_v1': lambda: first(L, 'BeachNetwork_ensemble_jour.png'),
        'beach_sky_gradient_v3': lambda: first(L, 'Plages_trois_ambiances.jpg'),
        'amp_plains_fleurie_v1': lambda: first(L, 'amp_plains_fleurie/ANIMATION_COMPLETE.webp'),
        'applewoods_skygrass_v1': lambda: first(L, 'entree_pommier/ANIMATION_COMPLETE.webp'),
        'antre_bassin_v4': lambda: first(L, 'antre/ANIMATION.webp'),
        'antre_cascades_v2': lambda: first(L, 'arene/ANIMATION.webp'),
        'antre_ecumes_v6': lambda: first(L, 'antre/ANIMATION.webp'),
        'antre_harmonie_v3': lambda: first(L, 'antre/ANIMATION.webp'),
        'antre_raccords_v5': lambda: first(L, 'antre/ANIMATION.webp'),
        'arene_aquatique_bois_v1': lambda: first(L, 'arene/ANIMATION.webp'),
        'cote_cendres_passage_v2': lambda: first(L, 'cote_cendres_passage/ANIMATION_COMPLETE.webp'),
        'cendres_grotte_eruptions_v3': lambda: first(L, 'cendres_grotte/ANIMATION_COMPLETE.webp') or multi(L, r'cendres_grotte/grotte_v3_scene_000\.png'),
        'cendres_fissures_matiere_v5': lambda: first(L, 'cendres_fissures_matiere/ANIMATION_COMPLETE.webp'),
        'cendres_palette_raccord_v4': lambda: first(L, 'cendres_palette_raccord/ANIMATION_COMPLETE.webp'),
        'eau_siphons_rapides_v2': lambda: first(L, 'eau_siphons_rapides/COMPOSITION.png'),
        'siphons_ecoulement_v3': lambda: first(L, 'siphons_ecoulement/COMPOSITION.png'),
        'steam_cave_geysers_v1': lambda: first(L, 'jour/ANIMATION.webp'),
        'jungle_geysers_v2': lambda: first(L, 'clairiere/jour/ANIMATION.webp') + first(L, 'clairiere_grotte/jour/ANIMATION.webp'),
        'mont_horn_panorama_v1': lambda: first(L, 'mont_horn/COMPOSITION.png'),
        'mont_horn_altitude_v2': lambda: first(L, 'mont_horn/COMPOSITION.png'),
        'sky_peak_canonique_v1': lambda: first(L, 'jour/fleurs_animation.webp'),
        'sky_peak_ambiances_v2': lambda: first(L, 'PLANCHE_5_AMBIANCES.png'),
        'sky_peak_v1': lambda: first(L, 'bruts/01_col_fleuri.png'),
        'sky_peak_plaine_v1': lambda: first(L, 'bruts/prairie_falaise.png'),
        'soleil_spring_v1': lambda: first(L, 'spring/animation.webp'),
        'spring_arc_en_ciel_v1': lambda: first(L, 'PLANCHE_4_LAYOUTS.png'),
        'spring_colonne_irisee_v1': lambda: first(L, 'composition.png'),
        'spring_escalier_v1': lambda: first(L, 'composition.png'),
        'spring_pulsation_v2': lambda: first(L, 'composition.png'),
        'tours_hooh_v1': lambda: first(L, 'VUE_ENSEMBLE.png'),
        'tours_layers_v3': lambda: first(L, 'VUE_ENSEMBLE.png'),
        'panoramas_tours_v2': lambda: first(L, 'VUE_ENSEMBLE.png'),
        'corrections_spring_tours_v2': lambda: first(L, 'VUE_ENSEMBLE.png'),
        'donjons_10_biomes_v1': lambda: first(L, 'VUE_10_BIOMES.png'),
        'donjons_dtef_v2': lambda: first(L, 'VUE_10_DONJONS.png'),
        'layouts_magenta_v1': lambda: first(L, 'PLANCHE_VARIANTES.png'),
        'references_54d3731': lambda: first(L, 'PLANCHE_10_SCENES.png'),
        'references_calques_v1': lambda: first(L, 'guilde/composition.png'),
        'references_calques_v2': lambda: first(L, 'PLANCHE_10_FALAISES.png'),
        'references_fideles_v1': lambda: first(L, 'PLANCHE_REFERENCES.png'),
        'zones_pmd_20_v1': lambda: first(L, 'CONTACT_GENERATIONS.png'),
        'entrees_calques_v6': lambda: first(L, 'PLANCHE_CALQUES.png'),
        'entrees_six_donjons_v1': lambda: first(L, 'sakura_validee/composition_identique.png'),
        'falaise_metano_temoin': lambda: first(L, '01_crete_sillage_transparent.png'),
        'northern_calques_v1': lambda: first(L, 'terrain_detoure.png'),
        'corrections_eau_canopy_v1': lambda: first(L, 'canopy_source_magenta.png'),
        'map_zones_debloquees_v1': lambda: first(L, 'MapZones_debloquees.png'),
        'lisiere_pmd_v1': lambda: first(L, 'LE1_lisiere.png'),
        'viewport_pmdo_v1': lambda: first(L, 'VP1_cadrages.png'),
        'mega_evolution_v1': lambda: first(L, 'preview_0.webp'),
        'mega_evolution_v2': lambda: first(L, 'storyboard.png'),
        'arene_boreales_v4': lambda: first(L, 'review/scene_sans_scroll_000.png'),
        'arene_glace_generee_v2': lambda: first(L, 'review/animation.webp'),
        'arene_glace_large_v3': lambda: first(L, 'review/scene_000.png'),
        'arene_guide_couches_v13': lambda: first(L, 'review/scene_guide_animee.gif'),
        'arene_guide_couches_v14': lambda: first(L, 'review/scene_15frames.gif'),
        'arene_halcyon_v15': lambda: first(L, 'review/scene_ondulation.gif'),
        'arene_halcyon_v16': lambda: first(L, 'review/scene_ondulation.gif'),
        'boreales_frames_generees_v5': lambda: first(L, 'review/scene_00.png'),
        'boreales_ondulation_glace_v8': lambda: first(L, 'review/scene_ondulation_glace.gif'),
        'boreales_palette_cycling_v12': lambda: first(L, 'review/palette_cycling.gif'),
        'boreales_pmdsky_v7': lambda: first(L, 'review/scene_000.png'),
        'boreales_suite_generee_v11': lambda: first(L, 'review/scene_suite_gif.gif'),
        'effet_boreale_canonique_v10': lambda: first(L, 'review/scene_effet_gif.gif'),
        'onde_boreale_v9': lambda: first(L, 'review/scene_onde_gif.gif'),
        'crooked_verdure_v1': lambda: first(L, 'animation.webp'),
        'mod_guilde_entrees_v1': lambda: first(L, 'planche_cartes.png'),
        'waterfall_lake_etendu_v1': lambda: multi(L, r'bruts/[^/]+\.png')[:1],
        'ice_arena_aurora_v1': lambda: ['source/ice_arena_aurora_v1/generation/layout_guide.png'] if 'source/ice_arena_aurora_v1/generation/layout_guide.png' in BLOBS else [],
    }
    if L in O:
        return O[L]()
    if L.startswith('arene_groudon_magma'):
        return multi(L, r'review/\w+_scene_animee\.webp')[:1]
    if L.startswith('world_map_texture_strict'):
        return multi(L, r'WorldMap_Texture_Strict_Layout[^/]*\.png')[:1]
    if L.startswith('world_map'):
        return multi(L, r'WorldMap_[^/]+\.png')[:1]
    if L.startswith('waterfall_lake'):
        return first(L, 'jour/ANIMATION.webp') or multi(L, r'jour/ANIMATION[^/]*\.webp')[:1]
    # heuristique générique
    for pat in (r'review/\w*scene_animee\.webp', r'ANIMATION\.webp', r'[^/]+/ANIMATION\.webp',
                r'[^/]+/jour/ANIMATION\.webp', r'VUE_ENSEMBLE\.png', r'CONTACT[^/]*\.png',
                r'[^/]+/COMPOSITION\.png', r'[^/]+/jour/COMPOSITION\.png',
                r'review/\w*scene_t000\.png', r'review/scene_000\.png', r'composition\.png'):
        s = multi(L, pat)
        if s:
            return s[:1]
    return []

# ---------------------------------------------------------------- download + traitement
def fetch(path):
    sha, size = BLOBS[path]
    url = f'https://api.github.com/repos/{REPO}/git/blobs/{sha}'
    req = urllib.request.Request(url, headers={'Authorization': f'Bearer {TOKEN}',
                                               'Accept': 'application/vnd.github.raw',
                                               'User-Agent': 'galerie-pmdo'})
    for attempt in range(3):
        try:
            return urllib.request.urlopen(req, timeout=120).read()
        except Exception as e:
            if attempt == 2:
                raise
    return None

def is_anim(data, ext):
    if ext == '.gif':
        return True
    if ext == '.webp':
        try:
            im = Image.open(io.BytesIO(data))
            return getattr(im, 'n_frames', 1) > 1
        except Exception:
            return False
    return False

def process(data, path, out_base):
    """Écrit une image légère dans img/, retourne (fichier, animé, largeur, hauteur)."""
    ext = pathlib.Path(path).suffix.lower()
    anim = is_anim(data, ext)
    im = Image.open(io.BytesIO(data))
    w, h = im.size
    contact = bool(re.search(r'(PLANCHE|VUE_|CONTACT|planche_cartes)', path))
    maxw = 1100 if contact else 880
    if anim:
        if len(data) <= 2_300_000 and ext == '.webp':
            out = IMG / (out_base + '.webp'); out.write_bytes(data)
            return out.name, True, w, h
        # ré-encodage compact : 560 px, 48 images max
        frames, durations = [], []
        for fr in ImageSequence.Iterator(im):
            frames.append(fr.convert('RGBA'))
            durations.append(fr.info.get('duration', 100))
        if len(frames) > 48:
            step = len(frames) / 48
            idx = [int(i * step) for i in range(48)]
            frames = [frames[i] for i in idx]
            durations = [int(durations[i] * step) for i in idx]
        fw, fh = frames[0].size
        if fw > 560:
            nh = round(fh * 560 / fw)
            frames = [f.resize((560, nh), Image.LANCZOS) for f in frames]
        out = IMG / (out_base + '.webp')
        frames[0].save(out, save_all=True, append_images=frames[1:], duration=durations,
                       loop=0, quality=58, method=4)
        if out.stat().st_size > 2_600_000:
            frames[0].save(out, save_all=True, append_images=frames[1:], duration=durations,
                           loop=0, quality=40, method=4)
        return out.name, True, frames[0].size[0], frames[0].size[1]
    # statique
    im = im.convert('RGBA') if ext in ('.png', '.webp', '.gif') else im.convert('RGB')
    if w > maxw:
        im = im.resize((maxw, round(h * maxw / w)), Image.LANCZOS)
    if ext == '.jpg' or ext == '.jpeg':
        out = IMG / (out_base + '.jpg'); im.convert('RGB').save(out, quality=86)
    else:
        out = IMG / (out_base + '.png'); im.save(out, optimize=True)
        if out.stat().st_size > 1_100_000:
            out = IMG / (out_base + '.jpg'); im.convert('RGB').save(out, quality=85)
            (IMG / (out_base + '.png')).unlink(missing_ok=True)
    return out.name, False, im.size[0], im.size[1]

# ---------------------------------------------------------------- métadonnées locales
def local_meta(lot):
    meta = {}
    rd = R / 'renders' / lot / 'README.md'
    if rd.exists():
        for line in rd.read_text(errors='ignore').splitlines():
            if line.startswith('# '):
                meta['title'] = line[2:].strip(); break
        m = re.search(r'(\d+)\s+tests?\s+PASS', rd.read_text(errors='ignore'))
        if m:
            meta['tests'] = int(m.group(1))
    mf = R / 'renders' / lot / 'manifest.json'
    if mf.exists():
        try:
            d = json.load(open(mf))
            for k in ('size_px', 'method', 'reference_da', 'art_approved'):
                if k in d:
                    meta[k] = d[k]
            if isinstance(d.get('pmdo'), dict):
                meta['pmdo_target'] = d['pmdo'].get('target')
                meta['runtime_tested'] = d['pmdo'].get('runtime_tested', False)
            if 'reference' in d and 'reference_da' not in meta:
                meta['reference_da'] = d['reference']
        except Exception:
            pass
    st = R / 'source' / lot / 'STATUS.md'
    if 'tests' not in meta and st.exists():
        m = re.search(r'(\d+)\s*/\s*(\d+)\s+tests?\s+PASS|(\d+)\s+tests?\s+PASS', st.read_text(errors='ignore'))
        if m:
            meta['tests'] = int(m.group(1) or m.group(3))
    return meta

# ---------------------------------------------------------------- sections
SECTIONS = [
    ('guilde', 'Guilde Treehouse — 12 salles', 'Le kit de guilde : 12 salles jour/nuit, 11 calques par salle, vues extérieures interchangeables. Images présentes dans ce dépôt (salles/).', []),
    ('entrees', 'Entrées de donjon sud → nord', 'La série : 21 lots d\'entrées générées référencées, du premier Steam Cave au temple de Celebi. 19 cartes réunies dans le mod unique guilde_entrees_sud_nord (PMDO 0.8.12) ; les 2 dernières (Grotte Fleurie V1/V2) attendent validation.', [
        'entree_vapeur_sud_nord_v1', 'entree_vapeur_sud_nord_v2', 'entree_cratere_sud_nord_v1', 'entree_cratere_magma_v1',
        'entree_ruine_sud_nord_v1', 'entree_givre_sud_nord_v1', 'entree_bristle_sud_nord_v1', 'entree_jungle_sud_nord_v1',
        'entree_waterfall_cave_sud_nord_v1', 'entree_waterfall_cave_sud_nord_v2', 'entree_waterfall_cave_sud_nord_v3',
        'entree_underground_lake_sud_nord_v1', 'entree_mystifying_forest_sud_nord_v1', 'entree_sables_mouvants_sud_nord_v1',
        'entree_star_cave_v1' if False else 'entree_star_cave_sud_nord_v1', 'entree_clairiere_tropicale_sud_nord_v1',
        'entree_couloir_violet_sud_nord_v1', 'entree_mt_thunder_sud_nord_v1',
        'entree_jardin_secret_sud_nord_v1', 'entree_jardin_secret_sud_nord_v2',
        'entree_grotte_fleurie_sud_nord_v1', 'entree_grotte_fleurie_sud_nord_v2']),
    ('fins', 'Fins de donjon — arènes de boss', 'Les fonds de donjon : sommets, fosses, grottes et arènes (Kyogre, cristal, désert…), au format 4:3 avec marqueurs entrance / boss / objectif.', [
        'fin_vapeur_sommet_v1', 'fin_cratere_fosse_v1', 'fin_ruine_puits_v1', 'fin_givre_grotte_v1', 'fin_givre_aurore_v2',
        'fin_bristle_sommet_v1', 'fin_jungle_sud_v1', 'fin_waterfall_cave_v1', 'fin_underground_lake_v1' if False else 'fin_sables_mouvants_v1',
        'fin_star_cave_v1', 'fin_ocean_kyogre_v1', 'fin_grotte_fleurie_v1']),
    ('arenes', 'Arènes élémentaires & antres', 'Arènes de glace et aurores (V4 → V16), magma de Groudon, Terapagos, antres aquatiques multicalques.', [
        'arene_aquatique_bois_v1', 'antre_cascades_v2', 'antre_harmonie_v3', 'antre_bassin_v4', 'antre_raccords_v5', 'antre_ecumes_v6',
        'arene_boreales_v4', 'arene_glace_generee_v2', 'arene_glace_large_v3', 'arene_guide_couches_v13', 'arene_guide_couches_v14',
        'arene_halcyon_v15', 'arene_halcyon_v16', 'ice_arena_aurora_v1',
        'arene_groudon_magma_v1', 'arene_groudon_magma_v2', 'arene_groudon_magma_v3', 'arene_terapagos_v1']),
    ('special', 'Zone Zéro, réveil & lieux spéciaux', 'La zone de réveil (prairie de Sky Peak face à l\'océan), Zone Zéro et ses gouffres, ruines Zarbi, colonnes Lances.', [
        'zone_reveil_prairie_horizon_v1', 'zone_reveil_prairie_horizon_v2',
        'zone_zero_v1', 'zone_zero_v2', 'ruines_zarbi_v1', 'colonnes_lances_v1']),
    ('metano', 'Métano — côtes, caps & expéditions', 'Le réseau côtier façon Métano : les 20 zones du mod Expéditions, retouches V6, caps et terrasses, falaises de référence, côtes cendrées.', [
        'metano_expeditions_actuel', 'retouches_zones_v6', 'cote_dix_zones', 'cote_dix_zones_lot2',
        'cote_v2', 'cote_v3_0812', 'cote_v4_abyss', 'cote_v5_expeditions',
        'caps_terrasses_v3', 'caps_terrasses_v4', 'falaise_metano_temoin', 'references_calques_v2',
        'cote_cendres_passage_v2', 'northern_calques_v1', 'corrections_northern_v1', 'map_zones_debloquees_v1']),
    ('zones', 'Zones & réseaux multicalques', 'Réseaux de zones raccordables (biomes forêt, grotte, glace, volcan), duos jour/nuit, propositions mises de côté.', [
        'network_zones_multicalques_v1', 'network_zones_multicalques_v2', 'network_zones_multicalques_v3',
        'final_duos_v1', 'zones_pmd_20_v1', 'references_54d3731', 'references_fideles_v1', 'references_calques_v1']),
    ('eau', 'Plages, lacs & cascades', 'Waterfall Lake (V1 → V6), plages PMD, siphons et écoulements, corrections d\'eau.', [
        'waterfall_lake_fidele_v1', 'waterfall_lake_trois_v2', 'waterfall_lake_raccords_v3', 'waterfall_lake_demi_cercle_v4',
        'waterfall_lake_encastrees_v5', 'waterfall_lake_generateur_v6', 'waterfall_lake_etendu_v1',
        'beach_layers_v1', 'beach_extension_v2', 'beach_network_v1', 'beach_sky_gradient_v3',
        'eau_siphons_rapides_v2', 'siphons_ecoulement_v3', 'corrections_eau_canopy_v1']),
    ('nature', 'Forêts, jungle & vapeur', 'Steam Cave et ses geysers, Southern Jungle, Amp Plains, Apple Woods, Crooked Cavern, lisières et chemins saisonniers.', [
        'steam_cave_geysers_v1', 'jungle_geysers_v2', 'amp_plains_fleurie_v1', 'applewoods_skygrass_v1',
        'crooked_verdure_v1', 'crooked_statique_v2', 'foret_saisons_v1', 'lisiere_pmd_v1',
        'entrees_six_donjons_v1', 'entrees_calques_v6', 'entrees_pmd_collection', 'entrees_halcyon_generees']),
    ('cendres', 'Cendres & magma', 'Grottes cendrées : bulles, éruptions, fissures animées, palette thermique commune.', [
        'cendres_grotte_eruptions_v3', 'cendres_palette_raccord_v4', 'cendres_fissures_matiere_v5']),
    ('monts', 'Monts, tours & Luminous Spring', 'Mont Horn, Sky Peak, tours Carillon et Cendrée, Luminous Spring et son soleil animé.', [
        'mont_horn_panorama_v1', 'mont_horn_altitude_v2', 'sky_peak_v1', 'sky_peak_plaine_v1',
        'sky_peak_canonique_v1', 'sky_peak_ambiances_v2', 'tours_hooh_v1', 'tours_layers_v3',
        'panoramas_tours_v2', 'corrections_spring_tours_v2', 'soleil_spring_v1',
        'spring_escalier_v1', 'spring_pulsation_v2', 'spring_colonne_irisee_v1', 'spring_arc_en_ciel_v1']),
    ('boreales', 'Glace & aurores boréales', 'La saga des aurores : frames générées, palette cycling, onde canonique, ciel PMD Sky (V5 → V12).', [
        'boreales_frames_generees_v5', 'boreales_pmdsky_v7', 'boreales_ondulation_glace_v8', 'onde_boreale_v9',
        'effet_boreale_canonique_v10', 'boreales_suite_generee_v11', 'boreales_palette_cycling_v12']),
    ('interieurs', 'Café Spinda, casino & intérieurs', 'Le café multietage, le réseau Spinda, le casino des braises, le dojo Ledian et leur mobilier.', [
        'cafe_multietage_v1', 'cafe_multietage_v2', 'cafe_multietage_v3', 'cafe_spinda_reseau_v4',
        'cafe_spinda_revisite_v5', 'cafe_spinda_revisite_v6', 'cafe_spinda_revisite_v7', 'cafe_spinda_revisite_v8',
        'cafe_halcyon_agrandi_v1', 'casino_network_v1', 'casino_bois_v1', 'ledian_dojo_v1', 'spinda_decor_v1', 'spinda_torches_v1']),
    ('donjons', 'Donjons générés & tilesets DTEF', 'Gabarits DTEF natifs PMDO : dix biomes, texture bombing, retouches générées, autotiles audités.', [
        'donjons_10_biomes_v1', 'donjons_dtef_v2', 'donjons_generes_dtef_v3', 'designs_dtef_v4',
        'dungeon_autotiles_v1', 'dungeon_biomes_v1', 'layouts_magenta_v1']),
    ('worldmap', 'Cartes du monde', 'La world map : 7, 8, 9 continents, textures strictes, révélation par les nuages, fond utilisateur.', [
        'world_map_layers_v1', 'world_map_layers_v2', 'world_map_layers_v2_reverie', 'world_map_7_continents_v1',
        'world_map_7_continents_v2', 'world_map_8_continents_v1', 'world_map_8_continents_reverie_v1',
        'world_map_8_continents_reverie_generator_v3', 'world_map_8_continents_reference_da_v4',
        'world_map_9_continents_v1', 'world_map_9_continents_orange_v1', 'world_map_userfond_v1',
        'world_map_latest_references_v1', 'world_map_zones_v1',
        'world_map_texture_strict_v5', 'world_map_texture_strict_v6', 'world_map_texture_strict_v8', 'world_map_texture_strict_v9']),
    ('etudes', 'Études, mécaniques & mod', 'Études d\'animations canoniques, méga-évolution, viewport PMDO, et le mod unique des 19 entrées validées.', [
        'etude_animations_canoniques_sky_v1', 'mega_evolution_v1', 'mega_evolution_v2', 'viewport_pmdo_v1', 'mod_guilde_entrees_v1']),
]

# titres de secours pour les lots sans README
FALLBACK_TITLES = {
    'arene_terapagos_v1': 'ATP1 — Arène de Terapagos',
    'cafe_multietage_v3': 'Café V3 — accueil Ludicolo repris',
    'cafe_spinda_revisite_v5': 'Spinda V5 — prototypes de reprise',
    'casino_bois_v1': 'Casino des braises — banque de tuiles bois',
    'colonnes_lances_v1': 'CLR1 — Colonnes Lances (Spear Pillar)',
    'final_duos_v1': 'Duos finaux — onze zones jour/nuit',
    'map_zones_debloquees_v1': 'Carte des zones débloquées',
    'mega_evolution_v1': 'Méga-Évolution V1 — éclairs et emblème',
    'mega_evolution_v2': 'Méga-Évolution V2 — storyboard directionnel',
    'network_zones_multicalques_v1': 'Réseau de zones V1 — huit biomes',
    'network_zones_multicalques_v2': 'Réseau de zones V2 — camp et maison',
    'network_zones_multicalques_v3': 'Réseau de zones V3 — repris au propre',
    'ruines_zarbi_v1': 'RZD1 — Ruines Zarbi',
    'zone_zero_v1': 'Zone Zéro V1 — RAZ1-3 & EAZ1',
    'zone_zero_v2': 'Zone Zéro V2 — RAF1-3 & EAF1',
    'cote_dix_zones': 'Côte Métano — dix zones guidées',
    'cote_dix_zones_lot2': 'Côte Métano — lot 2',
    'cote_v2': 'Côte V2 — premières falaises',
    'cote_v3_0812': 'Côte V3 — portage PMDO 0.8.12',
    'cote_v4_abyss': 'Côte V4 — Abyss',
    'cote_v5_expeditions': 'Côte V5 — Expéditions (Ground natifs)',
    'world_map_layers_v1': 'World map — calques DA',
    'world_map_layers_v2': 'World map — 7 continents DA strict',
    'world_map_layers_v2_reverie': 'World map — 7 continents Reverie Town',
    'world_map_7_continents_v1': 'World map — 7 continents V1',
    'world_map_7_continents_v2': 'World map — 7 continents générés V2',
    'world_map_8_continents_v1': 'World map — 8 continents orange DA',
    'world_map_8_continents_reverie_v1': 'World map — 8 continents Reverie Town',
    'world_map_8_continents_reverie_generator_v3': 'World map — 8 continents Reverie générés',
    'world_map_8_continents_reference_da_v4': 'World map — 8 continents référence DA',
    'world_map_9_continents_v1': 'World map — 9 continents, fond utilisateur',
    'world_map_9_continents_orange_v1': 'World map — 9 continents orange',
    'world_map_userfond_v1': 'World map — fond utilisateur, 9 continents',
    'world_map_latest_references_v1': 'World map — dernières références',
    'world_map_zones_v1': 'World map — zones',
    'world_map_texture_strict_v5': 'World map — texture stricte V5',
    'world_map_texture_strict_v6': 'World map — texture stricte V6',
    'world_map_texture_strict_v8': 'World map — texture stricte V8',
    'world_map_texture_strict_v9': 'World map — texture stricte V9',
}

# lots validés par l'utilisateur (mod unique)
VALIDATED = set()
try:
    mod = json.load(open(R / 'renders' / 'mod_guilde_entrees_v1' / 'manifest.json'))
    for m in mod.get('maps', []):
        VALIDATED.add(m['lot'])
    VAL_PREFIXES = set(mod.get('validation_utilisateur', {}).get('cartes_validees', []))
except Exception:
    VAL_PREFIXES = set()

def caption_for(path, lot):
    rel = path.split(f'renders/{lot}/')[-1] if f'renders/{lot}/' in path else path
    rel = rel.replace('review/', '').replace('apercus/', '')
    rel = re.sub(r'\.(png|webp|gif|jpg)$', '', rel)
    rel = re.sub(r'^[A-Z0-9]+_', '', rel)
    rel = rel.replace('_scene_animee', 'scène animée').replace('ANIMATION_COMPLETE', 'animation complète')
    rel = rel.replace('ANIMATION', 'animation').replace('COMPOSITION', 'composition').replace('composition', 'composition')
    rel = rel.replace('/jour', ' — jour').replace('jour/', 'jour ').replace('/composite', '')
    rel = rel.replace('_', ' ').replace('/', ' · ')
    return rel.strip(' ·')

def main():
    data = {'ref': REF, 'repo': REPO, 'sections': [], 'stats': {}}
    jobs = []   # (lot, path)
    lotsel = {}
    for sid, stitle, sdesc, lots in SECTIONS:
        for lot in lots:
            sel = select(lot)
            if not sel:
                # chercher dans source/ ou exports/
                for pref in (f'source/{lot}/', f'exports/{lot}/'):
                    cands = [p for p in rfiles(pref) if re.search(r'(composition|guide|scene|planche|apercu|contact)', p, re.I)
                             and not re.search(r'(masque|frame|pose|calque|layer)', p, re.I)]
                    if cands:
                        sel = cands[:1]; break
            lotsel[lot] = sel
            for p in sel:
                jobs.append((lot, p))
    print(f'{len(jobs)} images à télécharger pour {len(lotsel)} lots', flush=True)

    results = {}
    def work(job):
        lot, path = job
        out_base = re.sub(r'[^A-Za-z0-9]+', '_', path)[:150]
        try:
            if path.startswith('local:'):
                data_bytes = (R / path[len('local:'):]).read_bytes()
            else:
                data_bytes = fetch(path)
            return job, process(data_bytes, path, out_base), None
        except Exception as e:
            return job, None, str(e)

    with cf.ThreadPoolExecutor(max_workers=8) as ex:
        for i, (job, res, err) in enumerate(ex.map(work, jobs)):
            results[job] = (res, err)
            if (i + 1) % 40 == 0:
                print(f'  {i+1}/{len(jobs)}', flush=True)

    # salles de guilde (images locales)
    guild_cards = []
    room_names = {'01_accueil': 'Accueil', '02_hall_missions': 'Hall des missions', '03_salle_commune': 'Salle commune',
                  '04_cantine': 'Cantine', '05_chambre_equipe': "Chambre d'équipe", '06_chambre_veilleur': 'Chambre du veilleur',
                  '07_chambre_residents': 'Chambre des résidents', '08_dortoir_trio': 'Dortoir trio', '09_dortoir_quatre': 'Dortoir quatre',
                  '10_dortoir_trio': 'Dortoir trio (bis)', '11_chambre_eclaireurs': 'Chambre des éclaireurs', '12_salle_chef': 'Salle du chef'}
    for d in sorted((R / 'salles').iterdir()):
        if not d.is_dir():
            continue
        imgs = []
        for variant in ('jour', 'nuit'):
            src = d / f'salle_{variant}.png'
            if src.exists():
                out = IMG / f'guilde_{d.name}_{variant}.png'
                im = Image.open(src)
                if im.size[0] > 880:
                    im = im.resize((880, round(im.size[1] * 880 / im.size[0])), Image.LANCZOS)
                im.save(out, optimize=True)
                imgs.append({'file': out.name, 'caption': variant, 'animated': False, 'w': im.size[0], 'h': im.size[1]})
        if imgs:
            guild_cards.append({'lot': d.name, 'title': room_names.get(d.name, d.name), 'images': imgs,
                                'meta': {'title': room_names.get(d.name, d.name)}, 'badges': ['jour/nuit', 'calques ×11'],
                                'github': None, 'source': f'salles/{d.name}/'})
    # extérieurs
    ext_imgs = []
    for name in ('jour', 'aube', 'crepuscule', 'soir', 'nuit', 'orageux'):
        src = R / 'exterieur' / f'{name}.png'
        if src.exists():
            out = IMG / f'exterieur_{name}.png'
            im = Image.open(src)
            if im.size[0] > 880:
                im = im.resize((880, round(im.size[1] * 880 / im.size[0])), Image.LANCZOS)
            im.save(out, optimize=True)
            ext_imgs.append({'file': out.name, 'caption': name, 'animated': False, 'w': im.size[0], 'h': im.size[1]})
    if ext_imgs:
        guild_cards.append({'lot': 'exterieur', 'title': 'Vues extérieures des fenêtres', 'images': ext_imgs,
                            'meta': {}, 'badges': '6 ambiances'.split(), 'github': None, 'source': 'exterieur/'})

    n_anim = n_maps = n_lots = 0
    for sid, stitle, sdesc, lots in SECTIONS:
        cards = []
        if sid == 'guilde':
            cards = guild_cards
        for lot in lots:
            n_lots += 1
            meta = local_meta(lot)
            title = meta.get('title') or FALLBACK_TITLES.get(lot) or lot.replace('_', ' ').capitalize()
            images = []
            for p in lotsel[lot]:
                res, err = results.get((lot, p), (None, 'absent'))
                if res:
                    f, anim, w, h = res
                    images.append({'file': f, 'caption': caption_for(p, lot), 'animated': anim, 'w': w, 'h': h,
                                   'remote': p})
                    n_maps += 1
                    n_anim += anim
                else:
                    print(f'  ÉCHEC {p}: {err}', flush=True)
            badges = []
            if any(i['animated'] for i in images):
                badges.append('animée')
            if lot in VALIDATED:
                badges.append('série validée ✓')
            if meta.get('tests'):
                badges.append(f"{meta['tests']} tests PASS")
            if meta.get('pmdo_target'):
                badges.append(f"PMDO {meta['pmdo_target']}")
            if meta.get('size_px'):
                badges.append(f"{meta['size_px'][0]}×{meta['size_px'][1]} px")
            if len(images) > 1:
                badges.append(f'{len(images)} vues')
            cards.append({'lot': lot, 'title': title, 'images': images, 'meta': meta, 'badges': badges,
                          'github': f'https://github.com/{REPO}/tree/{REF}/renders/{lot}' if any(p.startswith(f'renders/{lot}/') for p in BLOBS) else None,
                          'source': f'source/{lot}/' if (R / 'source' / lot).exists() else None})
        data['sections'].append({'id': sid, 'title': stitle, 'desc': sdesc, 'cards': cards})
    data['stats'] = {'lots': n_lots + len(guild_cards), 'views': n_maps + sum(len(c['images']) for c in guild_cards),
                     'animated': n_anim, 'validated': len(VALIDATED)}
    json.dump(data, open(R / 'galerie' / 'data.json', 'w'), ensure_ascii=False, indent=1)
    print(f"OK — {data['stats']}", flush=True)

if __name__ == '__main__':
    main()
