#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""ADD-ON « Réseau du Ciel » — recréation des donjons de PMD Explorateurs du
Ciel en zones New Era (new_era_sky_XX).

Générateur FRÈRE de tools/gen_addon_pmdred_network.py : il en importe les
helpers (load/save, retarget_floor_ranges, scale_levels) et les patrons Lua
(ZONE_LUA, RELAY_BLOCK, RELAY_INIT_LUA), exactement comme le v2 du réseau
pmd-red. Rien n'est réinventé côté plomberie.

RÈGLES DU PROJET APPLIQUÉES
---------------------------
* AUCUN légendaire / fabuleux, ni en boss ni en spawn. Les donjons EoS à
  boss légendaire sont recréés SANS le boss : la zone se termine sobrement
  (message du partenaire + EndDungeonRun). Aucun ground de cinématique.
* Reskin New Era systématique : noms français originaux, lexique des
  bâtisseurs (Station, Terminal, Signal, Balise, Sente) + couleur céleste
  propre à cet add-on. Aucune référence à l'intrigue d'EoS.
* Dédoublonnage : voir SKIPPED ci-dessous, croisé avec Data/Zone/ et
  docs/registre_donjons_new_era.md.
* Autotiles : chaque référence est vérifiée présente dans le dépôt ; sinon
  substitut du même biome, tracé dans SUBSTITUTS et dans la doc.
* Musiques : uniquement des .ogg présents dans Content/Music/.
"""
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---
import json, io, os, re, copy, sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from gen_addon_pmdred_network import (            # noqa: E402
    load, save, retarget_floor_ranges, scale_levels,
    TEMPLATE_ZONE, TPL_SPECIES, RELAY_GROUND,
    ZONE_LUA, RELAY_BLOCK, RELAY_INIT_LUA,
)

# ---------------------------------------------------------------------------
# DÉDOUBLONNAGE — donjons EoS écartés, avec justification
# ---------------------------------------------------------------------------
SKIPPED = [
    ('Aegis Cave',
     "Déjà consommé : arène Regigigas du ch7 (sanctuaire_titans, import 1:1 de "
     "« Deep Aegis Cave Regigigas Boss Arena », cf. inventaire_boss_arenes_provenances.md:31)."),
    ('Mt. Faraway',
     "Déjà consommé : sommet_aurore / arène Ho-Oh, réservée par tour_sacree ch18 "
     "(registre_donjons_new_era.md:61). Recréé sans boss côté pmd-red (zone 47)."),
]

# ---------------------------------------------------------------------------
# SPAWNS gén. 4-9 par thème (aucun légendaire ni fabuleux)
# ---------------------------------------------------------------------------
SPECIES = {
 'beach':    ['wingull','krabby','shellos','finneon','wimpod','sandygast','clauncher','mareanie','arrokuda','wiglett','crabrawler','binacle','dwebble','pyukumuku'],
 'cave':     ['zubat','geodude','roggenrola','woobat','dwebble','carbink','rockruff','nacli','klawf','glimmet','bronzor','noibat','sableye','mawile'],
 'mountain': ['cranidos','gible','drilbur','rockruff','cufant','rolycoly','nacli','orthworm','silicobra','capsakid','klawf','glimmet','mudbray','bonsly'],
 'forest':   ['starly','kricketot','combee','burmy','sewaddle','cottonee','phantump','rookidee','applin','smoliv','nymble','shroodle','fletchling','skiddo'],
 'water':    ['buizel','tympole','frillish','skrelp','wishiwashi','arrokuda','clobbopus','veluza','finizen','tatsugiri','dondozo','chewtle','psyduck','marill'],
 'electric': ['shinx','pachirisu','blitzle','joltik','helioptile','dedenne','togedemaru','yamper','morpeko','pawmi','tadbulb','wattrel','charjabug','pincurchin'],
 'desert':   ['sandile','trapinch','hippopotas','sandygast','silicobra','orthworm','capsakid','maractus','cufant','klawf','rolycoly','nacli','glimmet','bramblin'],
 'ice':      ['snover','vanillite','cubchoo','bergmite','snom','cetoddle','frigibax','eiscue','cryogonal','swinub','sneasel','delibird','spheal','snorunt'],
 'ghost':    ['duskull','shuppet','yamask','phantump','sinistea','greavard','gimmighoul','bramblin','drifloon','litwick','golett','honedge','sandygast','mimikyu'],
 'fire':     ['numel','slugma','litleo','salandit','sizzlipede','charcadet','rolycoly','carkol','darumaka','fletchinder','turtonator','heatmor','magby','torkoal'],
 'sky':      ['starly','rufflet','vullaby','noibat','oricorio','flittle','bombirdier','swablu','emolga','hawlucha','natu','sigilyph','wingull','rookidee'],
 'relic':    ['baltoy','yamask','golett','honedge','sinistea','bronzor','elgyem','runerigus','cofagrigus','falinks','varoom','tinkatink','dottler','klefki'],
 'jungle':   ['treecko','sewaddle','pansage','fomantis','morelull','bounsweet','grookey','nymble','capsakid','smoliv','tangela','shroomish','budew','skiddo'],
 'psychic':  ['ralts','abra','munna','solosis','espurr','hatenna','indeedee','flittle','gothita','beldum','natu','inkay','chingling','dottler'],
}

# ---------------------------------------------------------------------------
# AUTOTILES — 'exact' si présent dans le dépôt, sinon substitut documenté.
# Vérifié à l'exécution par check_assets().
# ---------------------------------------------------------------------------
SUBSTITUTS = {}   # rempli à l'exécution : donjon -> (voulu, utilisé, raison)

AT_BY_THEME = {
 'beach':    'craggy_coast',   'cave':     'chasm_cave_1',
 'mountain': 'mt_horn',        'forest':   'treeshroud_forest_1',
 'water':    'surrounded_sea', 'electric': 'amp_plains',
 'desert':   'northern_desert_1', 'ice':   'frosty_forest',
 'ghost':    'the_nightmare',  'fire':     'deep_dark_crater',
 'sky':      'sky_tower',      'relic':    'buried_relic_1',
 'jungle':   'mystery_jungle_2', 'psychic': 'spacial_rift_1',
}

MUSIC_BY_THEME = {
 'beach':'Craggy Coast.ogg',   'cave':'Chasm Cave.ogg',
 'mountain':'Mt. Horn.ogg',    'forest':'Treeshroud Forest.ogg',
 'water':'Water Cave.ogg',     'electric':'Amp Plains.ogg',
 'desert':'Northern Desert.ogg','ice':'Snow Camp.ogg',
 'ghost':'Dark Hill.ogg',      'fire':'Deep Dark Crater.ogg',
 'sky':'Sky Tower.ogg',        'relic':'Sealed Ruin.ogg',
 'jungle':'Gourmet Jungle.ogg','psychic':'Mysterious Passage.ogg',
}

# ---------------------------------------------------------------------------
# LE CATALOGUE
# (nom EoS, nom FR New Era, thème, niveau, étages, étages_relais|0,
#  nom FR du relais|None, autotile souhaité, musique souhaitée, tier)
# tier : 1 = ch11+, 2 = ch20+, 3 = post-game (StoryCompleted)
#
# ÉTAGES : valeurs de référence d'Explorers of Sky. Bulbapedia n'est pas
# consultable depuis ce sandbox (pas d'accès réseau garanti) : les valeurs
# proviennent de ma connaissance du jeu et sont TOUTES tracées dans
# docs/addon_reseau_du_ciel.md pour recoupement ultérieur.
# ---------------------------------------------------------------------------
Z = [
 ('Beach Cave',          'Grotte du Ressac',            'beach',    8,   4, 0, None, 'beach_cave','Drenched Bluff.ogg',1),
 ('Drenched Bluff',      'Falaise Ruisselante',         'cave',    10,   6, 0, None, 'drenched_bluff','Drenched Bluff.ogg',1),
 ('Mt. Bristle',         'Mont Hérissé',                'mountain',12,   8, 0, None, 'mt_bristle','Mt. Bristle.ogg',1),
 ('Waterfall Cave',      'Grotte de la Cascade',        'water',   14,   6, 0, None, 'waterfall_cave','Waterfall Cave.ogg',1),
 ('Apple Woods',         'Bois des Pommes',             'forest',  15,   6, 0, None, 'apple_woods','Apple Woods.ogg',1),
 ('Craggy Coast',        'Côte Escarpée',               'beach',   17,   6, 0, None, 'craggy_coast','Craggy Coast.ogg',1),
 ('Side Path',           'Sente Latérale',              'cave',    18,   3, 0, None, 'side_path','Craggy Coast.ogg',1),
 ('Mt. Horn',            'Mont Corne',                  'mountain',19,   9, 0, None, 'mt_horn','Mt. Horn.ogg',1),
 ('Rock Path',           'Sente Rocheuse',              'cave',    20,   3, 0, None, 'rock_path_tds','Mt. Horn.ogg',1),
 ('Foggy Forest',        'Forêt Embrumée',              'forest',  21,   6, 0, None, 'foggy_forest','Foggy Forest.ogg',1),
 ('Forest Path',         'Sente Forestière',            'forest',  22,   3, 0, None, 'foggy_forest','Foggy Forest.ogg',1),
 ('Steam Cave',          'Grotte des Vapeurs',          'fire',    23,  16, 0, None, 'steam_cave','Steam Cave.ogg',1),
 ('Amp Plains',          'Plaines du Grand Arc',        'electric',25,  10, 9, 'Station de l\'Arc Électrique','amp_plains','Amp Plains.ogg',1),
 ('Northern Desert',     'Désert Boréal',               'desert',  26,   8, 0, None, 'northern_desert_1','Northern Desert.ogg',1),
 ('Quicksand Cave',      'Grotte des Sables Mouvants',  'desert',  27,  14, 0, None, 'quicksand_cave','Quicksand Cave.ogg',1),
 ('Crystal Cave',        'Grotte de Cristal',           'cave',    28,  10, 0, None, 'crystal_cave_1','Crystal Cave.ogg',1),
 ('Crystal Crossing',    'Carrefour de Cristal',        'ice',     29,   8, 0, None, 'crystal_crossing','Crystal Crossing.ogg',1),
 ('Chasm Cave',          'Grotte du Gouffre',           'cave',    30,   9, 0, None, 'chasm_cave_1','Chasm Cave.ogg',1),
 ('Dark Hill',           'Colline Obscure',             'ghost',   31,  10, 0, None, 'dark_hill','Dark Hill.ogg',1),
 ('Sealed Ruin',         'Ruine Scellée',               'relic',   32,   8, 0, None, 'sealed_ruin','Sealed Ruin.ogg',1),
 ('Dusk Forest',         'Forêt du Crépuscule',         'ghost',   33,   8, 0, None, 'dusk_forest','Deep Dusk Forest.ogg',1),
 ('Deep Dusk Forest',    'Crépuscule Profond',          'ghost',   34,   8, 0, None, 'deep_dusk_forest_2','Deep Dusk Forest.ogg',1),
 ('Treeshroud Forest',   'Forêt du Linceul',            'forest',  35,   9, 0, None, 'treeshroud_forest_1','Treeshroud Forest.ogg',1),
 ('Brine Cave',          'Grotte Saumâtre',             'water',   36,  10, 4, 'Station des Eaux Closes','brine_cave','Brine Cave.ogg',1),
 # --- tier 2 : ch20+ ---
 ('Hidden Land',         'Terre Dérobée',               'jungle',  38,  14, 3, 'Station des Vieilles Pierres','hidden_land','Hidden Land.ogg',2),
 ('Temporal Tower',      'Tour Suspendue',              'sky',     40,  12, 5, 'Station du Dernier Palier','temporal_tower','Temporal Tower.ogg',2),
 ('Mystifying Forest',   'Forêt Mystifiante',           'forest',  36,  13, 0, None, 'mystifying_forest','Mystifying Forest.ogg',2),
 ('Blizzard Island',     'Île des Blizzards',           'ice',     37,  10, 0, None, 'blizzard_island','Snowbound Path.ogg',2),
 ('Crevice Cave',        'Grotte de la Crevasse',       'ice',     38,  10, 5, 'Station de la Crevasse','crevice_cave','Glacial Path.ogg',2),
 ('Surrounded Sea',      'Mer Encerclée',               'water',   39,  15, 0, None, 'surrounded_sea','Water Cave.ogg',2),
 ('Miracle Sea',         'Mer des Miracles',            'water',   40,  15, 0, None, 'miracle_sea','Water Cave.ogg',2),
 ('Mt. Travail',         'Mont Labeur',                 'mountain',41,  10, 0, None, 'mt_travail','Mt. Travail.ogg',2),
 ('The Nightmare',       'Le Cauchemar',                'ghost',   42,   9, 0, None, 'the_nightmare','The Power of Darkness.ogg',2),
 ('Spacial Rift',        'Faille Spatiale',             'psychic', 43,   9, 6, 'Station de la Faille','spacial_rift_1','Rising Fear.ogg',2),
 ('Dark Crater',         'Cratère Obscur',              'fire',    44,  10, 5, 'Station du Cratère','deep_dark_crater','Dark Crater.ogg',2),
 # --- tier 3 : post-game ---
 ('Concealed Ruins',     'Ruines Dissimulées',          'relic',   42,  14, 0, None, 'concealed_ruins','Sealed Ruin.ogg',3),
 ('Marine Resort',       'Havre Marin',                 'water',   43,  19, 0, None, 'marine_resort','Water Cave.ogg',3),
 ('Bottomless Sea',      'Mer sans Fond',               'water',   45,  25, 0, None, 'bottomless_sea','Water Cave.ogg',3),
 ('Shimmer Desert',      'Désert Chatoyant',            'desert',  45,  25, 0, None, 'shimmer_desert','Forsaken Desert.ogg',3),
 ('Mt. Avalanche',       'Mont des Avalanches',         'ice',     46,  20, 0, None, 'mt_avalanche','Glacial Path.ogg',3),
 ('Giant Volcano',       'Volcan Géant',                'fire',    46,  20, 0, None, 'giant_volcano','Enraged Caldera.ogg',3),
 ('World Abyss',         'Abysse du Monde',             'ghost',   47,  20, 0, None, 'world_abyss_2','In the Depths of the Pit.ogg',3),
 ('Sky Stairway',        'Escalier Céleste',            'sky',     48,  25, 0, None, 'sky_stairway','Sky Tower.ogg',3),
 ('Mystery Jungle',      'Jungle Mystère',              'jungle',  47,  30, 0, None, 'mystery_jungle_2','Gourmet Jungle.ogg',3),
 ('Serenity River',      'Rivière Sereine',             'water',   30,   9, 0, None, 'serenity_river','Water Cave.ogg',3),
 ('Landslide Cave',      'Grotte des Éboulements',      'cave',    31,  10, 0, None, 'landslide_cave','Boulder Quarry.ogg',3),
 ('Lush Prairie',        'Prairie Verdoyante',          'forest',  32,   9, 0, None, 'lush_prairie','Sky Peak Prairie.ogg',3),
 ('Tiny Meadow',         'Pré Minuscule',               'forest',  33,   9, 0, None, 'tiny_meadow','Sky Peak Prairie.ogg',3),
 ('Labyrinth Cave',      'Grotte du Labyrinthe',        'cave',    34,  15, 0, None, 'labyrinth_cave','Mysterious Passage.ogg',3),
 ('Oran Forest',         'Forêt des Oran',              'forest',  35,  17, 0, None, 'oran_forest','Berry Grove.ogg',3),
 ('Lake Afar',           'Lac Lointain',                'water',   36,  20, 0, None, 'lake_afar','Water Cave.ogg',3),
 ('Happy Outlook',       'Belvédère Serein',            'sky',     37,  20, 0, None, 'happy_outlook','Sky Peak Coast.ogg',3),
 ('Mt. Mistral',         'Mont Mistral',                'mountain',38,  20, 0, None, 'mt_mistral','Mt. Travail.ogg',3),
 ('Shimmer Hill',        'Colline Chatoyante',          'sky',     39,  20, 0, None, 'shimmer_hill','Rainbow Peak.ogg',3),
 ('Lost Wilderness',     'Étendue Perdue',              'jungle',  40,  20, 0, None, 'lost_wilderness','Overgrown Wilds.ogg',3),
 ('Midnight Forest',     'Forêt de Minuit',             'ghost',   41,  20, 0, None, 'midnight_forest','Deep Dusk Forest.ogg',3),
 ('Zero Isle North',     'Île Zéro — Nord',             'ice',     50,  25, 0, None, 'zero_isle_east_4','Barren Tundra.ogg',3),
 ('Zero Isle East',      'Île Zéro — Est',              'forest',  50,  40, 0, None, 'zero_isle_east_4','Barren Tundra.ogg',3),
 ('Zero Isle West',      'Île Zéro — Ouest',            'cave',    50,  40, 0, None, 'zero_isle_east_4','Barren Tundra.ogg',3),
 ('Zero Isle South',     'Île Zéro — Sud',              'beach',   50,  50, 0, None, 'zero_isle_east_4','Barren Tundra.ogg',3),
 ('Zero Isle Center',    'Île Zéro — Centre',           'relic',   50,  99, 0, None, 'zero_isle_east_4','Barren Tundra.ogg',3),
 ('Destiny Tower',       'Tour du Destin',              'sky',     50,  99, 0, None, 'destiny_tower','Sacred Tower.ogg',3),
 ('Oblivion Forest',     'Forêt de l\'Oubli',           'ghost',   48,  30, 0, None, 'oblivion_forest','Deep Dusk Forest.ogg',3),
 ('Treacherous Waters',  'Eaux Traîtresses',            'water',   48,  30, 0, None, 'treacherous_waters','Water Cave.ogg',3),
 ('Southeastern Islands','Îles du Sud-Est',             'beach',   48,  30, 0, None, 'southeastern_islands','Sky Peak Coast.ogg',3),
 ('Inferno Cave',        'Grotte Infernale',            'fire',    48,  30, 0, None, 'inferno_cave','Enraged Caldera.ogg',3),
 ('Star Cave',           'Grotte des Étoiles',          'relic',   49,  20, 0, None, 'star_cave','Star Cave.ogg',3),
]

# Restrictions d'origine : Zero Isles + Destiny Tower
LV1_SOLO = dict(Level=1, LevelCap=True, KeepSkills=False, TeamRestrict=True,
                TeamSize=1, MoneyRestrict=True, BagRestrict=0)
ZERO = dict(Level=1, LevelCap=True, KeepSkills=False, TeamRestrict=False,
            TeamSize=-1, MoneyRestrict=True, BagRestrict=0)
RESTRICT = {'Destiny Tower': LV1_SOLO}
for n in ('Zero Isle North','Zero Isle East','Zero Isle West',
          'Zero Isle South','Zero Isle Center'):
    RESTRICT[n] = ZERO

DEFAULTS = dict(Level=5, LevelCap=False, KeepSkills=False, TeamRestrict=False,
                TeamSize=-1, MoneyRestrict=False, BagRestrict=-1)


# ---------------------------------------------------------------------------
def available_autotiles():
    """Autotiles réellement référencés quelque part dans Data/Zone (donc
    fournis par le jeu de base et déjà éprouvés)."""
    import glob
    have = set()
    for f in glob.glob('Data/Zone/*.json'):
        try:
            t = open(f, encoding='utf-8-sig').read()
        except Exception:
            continue
        for m in re.findall(r'"(?:GroundTileset|BlockTileset|WaterTileset)":\s*"([^"]+)"', t):
            if m:
                have.add(m)
    return have


def resolve_autotile(name, want, theme, have):
    """Renvoie l'autotile à utiliser : celui voulu s'il existe, sinon le
    substitut du même biome. Trace la substitution."""
    if want + '_floor' in have:
        return want
    sub = AT_BY_THEME[theme]
    SUBSTITUTS[name] = (want, sub, 'absent du dépôt — substitut biome « %s »' % theme)
    return sub


def resolve_music(name, want, theme):
    if os.path.exists(os.path.join('Content/Music', want)):
        return want
    return MUSIC_BY_THEME[theme]


def build(num, nen, nfr, theme, level, n1, n2, relay, at, mus, tier, have):
    zid = 'new_era_sky_%02d' % num
    d = load(TEMPLATE_ZONE)
    o = d['Object']
    o['Name'] = {'DefaultText': nen, 'LocalTexts': {'fr': nfr}}
    o['Released'] = True
    o['Comment'] = ('New Era add-on « Réseau du Ciel » — recréation de %s '
                    '(Explorers of Sky), %d étages%s. Générateurs PMDO, tables '
                    'gén. 4-9 (%s). Aucun légendaire, aucun boss.'
                    % (nen, n1, (' + %d (relais)' % n2) if n2 else '', theme))

    def segs(x):
        if isinstance(x, dict):
            for k, v in x.items():
                if k == 'Segments':
                    return v
                r = segs(v)
                if r is not None:
                    return r
        elif isinstance(x, list):
            for v in x:
                r = segs(v)
                if r is not None:
                    return r
    S = segs(o)
    del S[1:]
    base = S[0]
    old_max = base['Floors']['nodes'][0]['Range']['Max']
    retarget_floor_ranges(base, old_max, n1)
    if n2:
        peak = copy.deepcopy(base)
        retarget_floor_ranges(peak, n1, n2)
        S.append(peak)

    fields = dict(DEFAULTS)
    r = RESTRICT.get(nen)
    if r:
        fields.update(r)
    else:
        fields['Level'] = level
    for k, v in fields.items():
        o[k] = v

    t = json.dumps(d, ensure_ascii=False, indent=2)
    t = scale_levels(t, level / 15.0, level + 3)
    pool = SPECIES[theme]
    for i, sp in enumerate(TPL_SPECIES):
        t = t.replace('"%s"' % sp, '"%s"' % pool[i % len(pool)])
    at_use = resolve_autotile(nen, at, theme, have)
    t = t.replace('"lush_prairie_floor"', '"%s_floor"' % at_use)
    t = t.replace('"lush_prairie_wall"', '"%s_wall"' % at_use)
    t = t.replace('"lush_prairie_secondary"', '"%s_secondary"' % at_use)
    t = t.replace('"treeshroud_forest_1_wall"', '"%s_wall"' % at_use)
    mus_use = resolve_music(nen, mus, theme)
    t = re.sub(r'"Music":\s*"[^"]*"', '"Music": "%s"' % mus_use, t)

    d2 = json.loads(t)
    o2 = d2['Object']
    gmaps = ['%s_relais' % zid] if n2 else []

    def set_gm(x):
        if isinstance(x, dict):
            for k in x:
                if k == 'GroundMaps':
                    x[k] = gmaps
                    return True
                if set_gm(x[k]):
                    return True
        elif isinstance(x, list):
            for it in x:
                if set_gm(it):
                    return True
        return False
    set_gm(o2)
    save('Data/Zone/%s.json' % zid, d2)
    return zid, fields, gmaps, at_use, mus_use


def build_relay(zid, nfr_relay, music):
    d = load(RELAY_GROUND)
    o = d['Object']
    o['AssetName'] = '%s_relais' % zid
    o['Name'] = {'DefaultText': 'Relay Station', 'LocalTexts': {'fr': nfr_relay}}
    o['Comment'] = ('New Era add-on « Réseau du Ciel » — Station-Relais de %s. '
                    'Patron canonique : Terminal de Sauvegarde (Kangourex) + réserve, '
                    'sortie Nord = suite, sortie Sud = retour.' % zid)
    o['Music'] = music
    save('Data/Ground/%s_relais.rsground' % zid, d)


def main():
    have = available_autotiles()
    idx = load('Data/Zone/index.idx')
    made = []
    for num, row in enumerate(Z):
        nen, nfr, theme, level, n1, n2, relay, at, mus, tier = row
        zid, fields, gmaps, at_use, mus_use = build(
            num, nen, nfr, theme, level, n1, n2, relay, at, mus, tier, have)

        os.makedirs('Data/Script/halcyon/zone/%s' % zid, exist_ok=True)
        peak_txt = ' + relais + %d étages' % n2 if n2 else ''
        relay_block = RELAY_BLOCK.format(zid=zid) if n2 else ''
        open('Data/Script/halcyon/zone/%s/init.lua' % zid, 'w', encoding='utf-8').write(
            ZONE_LUA.format(zid=zid, nfr=nfr, idn=nen, n1=n1,
                            peak_txt=peak_txt, relay_block=relay_block))

        if n2:
            build_relay(zid, relay, mus_use)
            rid = '%s_relais' % zid
            os.makedirs('Data/Script/halcyon/ground/%s' % rid, exist_ok=True)
            open('Data/Script/halcyon/ground/%s/init.lua' % rid, 'w',
                 encoding='utf-8').write(
                RELAY_INIT_LUA.format(rid=rid, zid=zid, nfr_relay=relay))

        nsegs = 2 if n2 else 1
        total = n1 + n2
        idx['Object'][zid] = {
            '$type': 'RogueEssence.Data.ZoneEntrySummary, RogueEssence',
            'ExpPercent': 100,
            'Level': fields['Level'], 'LevelCap': fields['LevelCap'],
            'KeepSkills': fields['KeepSkills'],
            'TeamRestrict': fields['TeamRestrict'], 'TeamSize': fields['TeamSize'],
            'MoneyRestrict': fields['MoneyRestrict'], 'BagRestrict': fields['BagRestrict'],
            'KeepTreasure': False, 'BagSize': -1, 'Rescues': 2,
            'CountedFloors': total, 'Rogue': 0,
            'Grounds': gmaps, 'Maps': [[0]] * nsegs,
            'Name': {'DefaultText': nen, 'LocalTexts': {'fr': nfr}},
            'Released': True, 'SortOrder': 0,
        }
        made.append(dict(zid=zid, en=nen, fr=nfr, theme=theme, n1=n1, n2=n2,
                         tier=tier, at=at_use, music=mus_use,
                         level=fields['Level'], restrict=bool(RESTRICT.get(nen))))
        print('%s  %-26s %3d%-5s L%-3s t%d  %-22s %s'
              % (zid, nfr, n1, ('+%d' % n2) if n2 else '', fields['Level'],
                 tier, at_use, mus_use))

    save('Data/Zone/index.idx', idx)
    json.dump(made, open('/tmp/sky_zones.json', 'w'))
    print('\n%d zones « Réseau du Ciel » générées' % len(made))
    if SUBSTITUTS:
        print('\nSubstitutions d\'autotiles (%d) :' % len(SUBSTITUTS))
        for k, (w, s, why) in sorted(SUBSTITUTS.items()):
            print('  %-24s %-22s -> %-22s %s' % (k, w, s, why))
    json.dump(SUBSTITUTS, open('/tmp/sky_subs.json', 'w'))


if __name__ == '__main__':
    main()
