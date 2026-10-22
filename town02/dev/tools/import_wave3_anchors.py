#!/usr/bin/env python3
"""Vague 3 — « L'Éveil des Ancrages » : donjons légendaires ch11-32.

Plan utilisateur (plan_integration_legendaires_ch8-32.md) : BRANCHER TOUT.
Chaque légendaire reçoit un donjon DumpAsset assorti à sa DA + une arène de
revanche dédiée (segment final), reliés au système LegendZones existant
(Grodoudou, 3 verrous). Les 12 arènes pmd-red restent les grounds de
cinématique d'histoire ; ici on branche la boucle JOUABLE (donjon + combat).

Corrections canon validées : Sky Tower = RAYQUAZA (autel_celeste lui revient
à terme) ; Lugia = Silver Trench (fosse_argentee).

Chaque entrée : (zone source DumpAsset, id New Era, noms, palier niveau,
boss légendaire[s], niveau boss, autotiles de l'arène (DA), musique d'arène).
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
import json, io, re, os, copy, shutil

SRC = '/tmp/wave3/zones'
MAPS = '/tmp/wave3/maps'

def load(p): return json.load(open(p, encoding='utf-8-sig'))
def save(p, d):
    with io.open(p, 'w', encoding='utf-8-sig') as f:
        json.dump(d, f, ensure_ascii=False, indent=2)

BANNED_SCRIPTS = {'Tutorial', 'Mysteriosity', 'SpawnRandomTutor', 'ShopkeeperInteract',
                  'GeodeCreviceRevisit', 'HiddenLegend', 'PairTalk', 'RoamingLegend'}

def purge_scripts(node):
    removed = 0
    if isinstance(node, dict):
        for k, v in list(node.items()):
            if isinstance(v, list):
                keep = []
                for it in v:
                    s = None
                    if isinstance(it, dict):
                        s = it.get('Script')
                        for _k in ('Value', 'Spawn'):
                            _v = it.get(_k)
                            if not s and isinstance(_v, dict):
                                s = _v.get('Script')
                    if s in BANNED_SCRIPTS:
                        removed += 1
                        continue
                    removed += purge_scripts(it)
                    keep.append(it)
                node[k] = keep
            else:
                removed += purge_scripts(v)
    elif isinstance(node, list):
        for it in node:
            removed += purge_scripts(it)
    return removed

def drop_empty_steps(node):
    n = 0
    if isinstance(node, dict):
        for k, v in list(node.items()):
            if k == 'ZoneSteps' and isinstance(v, list):
                keep = []
                for zs in v:
                    if isinstance(zs, dict) and zs.get('Spawns') == []:
                        n += 1
                        continue
                    keep.append(zs)
                node[k] = keep
            else:
                n += drop_empty_steps(v)
    elif isinstance(node, list):
        for it in node:
            n += drop_empty_steps(it)
    return n

def scale_levels(t, factor, min_lv=3, max_lv=None):
    def rep(m):
        lo, hi = int(m.group(1)), int(m.group(2))
        nlo = max(min_lv, round(lo * factor))
        nhi = max(nlo, round(hi * factor))
        if max_lv:
            nlo, nhi = min(nlo, max_lv), min(nhi, max_lv)
        return f'"Level": {{\n"Min": {nlo},\n"Max": {nhi}\n}}'
    return re.sub(r'"Level":\s*\{\s*"Min":\s*(\d+),\s*"Max":\s*(\d+)\s*\}', rep, t)

# ---------------------------------------------------------------------------
# LES 15 DONJONS-ANCRAGES (source -> DA du légendaire)
# bosses: [(species, nickname, level, gender, intrinsic, [(skill,charges)x4])]
# ---------------------------------------------------------------------------
DUNGEONS = [
 # ch11 Groudon — Caldeira Endormie (volcan endormi qui se réveille : sa DA exacte)
 dict(src='sleeping_caldera', zid='caldeira_endormie', ch=11,
      nen='Sleeping Caldera', nfr='Caldeira Endormie',
      factor=1.0, max_lv=38, level=36, lz_key='molten_throne',
      lz_name=('Molten Throne', 'Trône de Magma'),
      arena='fosse_ardente_arene', arena_at=('deep_dark_crater_floor', 'deep_dark_crater_wall'),
      arena_music='Enraged Caldera.ogg',
      bosses=[('groudon', 'Groudon', 37, 0, 'drought',
               [('earthquake', 10), ('lava_plume', 15), ('bulk_up', 20), ('slash', 20)])]),
 # ch12 Kyogre — Eaux Inexplorées (mer démontée : Stormy Sea like)
 dict(src='uncharted_waters', zid='eaux_inexplorees', ch=12,
      nen='Uncharted Waters', nfr='Eaux Inexplorées',
      factor=0.72, max_lv=40, level=38, lz_key='tide_hollow',
      lz_name=('Tide Hollow', 'Creux des Marées'),
      arena='abime_tempetes_arene', arena_at=('stormy_sea_1_floor', 'stormy_sea_1_wall'),
      arena_music='On the Beach at Dusk.ogg',
      bosses=[('kyogre', 'Kyogre', 39, 0, 'drizzle',
               [('hydro_pump', 5), ('calm_mind', 20), ('body_slam', 15), ('aqua_ring', 20)])]),
 # ch13 trio des lacs — Sentier du Savoir (Uxie seul en boss, décision doc maître)
 dict(src='wisdom_road', zid='sentier_savoir', ch=13,
      nen='Wisdom Road', nfr='Sentier du Savoir',
      factor=1.0, max_lv=42, level=40, lz_key='quiet_ledger_road',
      lz_name=('Mirror of Memory', 'Miroir de la Mémoire'),
      arena='miroir_memoire_arene', arena_at=('crystal_cave_2_floor', 'crystal_cave_2_wall'),
      arena_music='Star Cave.ogg',
      bosses=[('uxie', 'Uxie', 41, 0, 'levitate',
               [('extrasensory', 20), ('yawn', 10), ('flail', 15), ('amnesia', 20)])]),
 # ch14 Moltres — Île de Lave Flottante (île volcanique : DA feu/oiseau)
 dict(src='lava_floe_island', zid='ile_lave_flottante', ch=14,
      nen='Lava Floe Island', nfr='Île de Lave Flottante',
      factor=0.72, max_lv=44, level=42, lz_key='long_ash_isle',
      lz_name=('Isle of Long Ash', 'Île des Longues Cendres'),
      arena='champ_braises_arene', arena_at=('fiery_field_floor', 'fiery_field_wall'),
      arena_music='Deep Dark Crater.ogg',
      bosses=[('moltres', 'Sulfura', 43, 0, 'flame_body',
               [('heat_wave', 10), ('agility', 30), ('wing_attack', 30), ('fire_spin', 15)])]),
 # ch16 Raikou — Crête Voilée (orages de crête : DA foudre)
 dict(src='veiled_ridge', zid='crete_voilee', ch=16,
      nen='Veiled Ridge', nfr='Crête Voilée',
      factor=0.85, max_lv=47, level=45, lz_key='storm_bell_ridge',
      lz_name=('Storm Bell', 'Cloche des Orages'),
      arena='champ_foudre_arene', arena_at=('lightning_field_floor', 'lightning_field_wall'),
      arena_music='Rising Fear.ogg',
      bosses=[('raikou', 'Raikou', 46, 0, 'pressure',
               [('thunder_fang', 15), ('calm_mind', 20), ('quick_attack', 30), ('spark', 20)])]),
 # ch17 Articuno + Zapdos — Montagne Traîtresse (pics gelés balayés de vents)
 dict(src='treacherous_mountain', zid='montagne_traitresse', ch=17,
      nen='Treacherous Mountain', nfr='Montagne Traîtresse',
      factor=1.18, max_lv=49, level=47, lz_key='frozen_watch',
      lz_name=('Frozen Watch', 'Veille Gelée'),
      arena='champ_boreal_arene', arena_at=('northwind_field_floor', 'northwind_field_wall'),
      arena_music='Snow Camp.ogg',
      bosses=[('articuno', 'Artikodin', 48, 0, 'pressure',
               [('ice_beam', 10), ('mind_reader', 20), ('agility', 30), ('gust', 30)]),
              ('zapdos', 'Électhor', 48, 0, 'pressure',
               [('drill_peck', 20), ('thunder_wave', 20), ('detect', 10), ('spark', 20)])]),
 # ch18 Ho-Oh — Tour Sacrée (SA tour : DA exacte de la Tour Cendrée)
 dict(src='sacred_tower', zid='tour_sacree', ch=18,
      nen='Sacred Tower', nfr='Tour Sacrée',
      factor=1.0, max_lv=52, level=50, lz_key='rainbow_ash_tower',
      lz_name=('Pyre of Dawn', "Bûcher de l'Aurore"),
      arena='sommet_aurore_arene', arena_at=('mt_faraway_4_floor', 'mt_faraway_4_wall'),
      arena_music='Summit.ogg',
      bosses=[('ho_oh', 'Ho-Oh', 51, 0, 'pressure',
               [('sacred_fire', 5), ('recover', 10), ('extrasensory', 20), ('safeguard', 25)])]),
 # ch19 Lugia — Fosse des Abysses (Silver Trench : son donjon canon)
 dict(src='the_abyss', zid='fosse_abysses', ch=19,
      nen='The Deep Abyss', nfr='Fosse des Abysses',
      factor=0.54, max_lv=55, level=53, lz_key='sunken_choir_deep',
      lz_name=('Sunken Choir', 'Chœur Englouti'),
      arena='fosse_argentee_arene', arena_at=('silver_trench_3_floor', 'silver_trench_3_wall'),
      arena_music='Water Cave.ogg',
      bosses=[('lugia', 'Lugia', 54, 0, 'pressure',
               [('aeroblast', 5), ('recover', 10), ('hydro_pump', 5), ('safeguard', 25)])]),
 # ch21 Mewtwo — Forteresse Abandonnée (laboratoire/ruine artificielle : sa DA)
 dict(src='deserted_fortress', zid='forteresse_abandonnee', ch=21,
      nen='Deserted Fortress', nfr='Forteresse Abandonnée',
      factor=2.2, max_lv=59, level=57, lz_key='western_silence',
      lz_name=('Western Silence', "Silence de l'Occident"),
      arena='antre_occident_arene', arena_at=('western_cave_1_floor', 'western_cave_1_wall'),
      arena_music='Growing Anxiety.ogg',
      bosses=[('mewtwo', 'Mewtwo', 58, 0, 'pressure',
               [('psychic', 10), ('recover', 10), ('swift', 20), ('barrier', 20)])]),
 # ch22 Entei + Victini — Caldeira du Vif (Enraged Caldera seg, feu pur)
 dict(src='faultline_ridge', zid='crete_faille', ch=22,
      nen='Faultline Ridge', nfr='Crête de la Faille',
      factor=3.6, max_lv=61, level=59, lz_key='ember_vigil_ridge',
      lz_name=('Ember Vigil', 'Veillée des Braises'),
      arena='veillee_braises_arene', arena_at=('deep_dark_crater_floor', 'deep_dark_crater_wall'),
      arena_music='Deep Dark Crater.ogg',
      bosses=[('entei', 'Entei', 60, 0, 'pressure',
               [('fire_fang', 15), ('roar', 20), ('stomp', 20), ('calm_mind', 20)]),
              ('victini', 'Victini', 58, 0, 'victory_star',
               [('searing_shot', 10), ('confusion', 25), ('quick_attack', 30), ('endure', 10)])]),
 # ch23 Cresselia + Darkrai — Cour du Clair de Lune (lune : DA exacte)
 dict(src='moonlit_courtyard', zid='cour_clair_lune', ch=23,
      nen='Moonlit Courtyard', nfr='Cour du Clair de Lune',
      factor=2.4, max_lv=63, level=61, lz_key='soft_sleep_court',
      lz_name=('Two Faces of the Moon', 'Les Deux Visages de la Lune'),
      arena='visages_lune_arene', arena_at=('darknight_relic_floor', 'darknight_relic_wall'),
      arena_music='Sky Peak Cave.ogg',
      bosses=[('cresselia', 'Cresselia', 62, 2, 'levitate',
               [('psycho_cut', 20), ('moonlight', 5), ('aurora_beam', 20), ('safeguard', 25)]),
              ('darkrai', 'Darkrai', 62, 0, 'bad_dreams',
               [('dark_void', 10), ('dream_eater', 15), ('shadow_ball', 15), ('double_team', 15)])]),
 # ch24 Latios/Latias — Île Éon (leur île canon !)
 dict(src='eon_island', zid='ile_eon', ch=24,
      nen='Eon Island', nfr='Île Éon',
      factor=12.4, max_lv=65, level=63, lz_key='twin_rift',
      lz_name=('Twin Rift', 'Faille Jumelle'),
      arena='faille_jumelle_arene', arena_at=('sky_tower_floor', 'sky_tower_wall'),
      arena_music='Mt. Travail.ogg',
      bosses=[('latios', 'Latios', 64, 0, 'levitate',
               [('luster_purge', 10), ('dragon_dance', 20), ('psychic', 10), ('recover', 10)]),
              ('latias', 'Latias', 64, 1, 'levitate',
               [('mist_ball', 10), ('wish', 10), ('dragon_breath', 20), ('safeguard', 25)])]),
 # ch25 Suicune — Antre Chuchotant (grottes d'eau pure : sa DA)
 dict(src='cave_of_whispers', zid='antre_chuchotant', ch=25,
      nen='Cave of Whispers', nfr='Antre Chuchotant',
      factor=13.0, max_lv=67, level=65, lz_key='clearwater_hollow',
      lz_name=('Clearwater Ford', 'Gué des Eaux Claires'),
      arena='gue_eaux_claires_arene', arena_at=('howling_forest_1_floor', 'howling_forest_1_wall'),
      arena_music='Spring Cave.ogg',
      bosses=[('suicune', 'Suicune', 66, 0, 'pressure',
               [('hydro_pump', 5), ('mirror_coat', 20), ('calm_mind', 20), ('gust', 30)])]),
 # ch26 Mew + Hoopa — Bois Enchevêtrés (jungle mystère : Mystery Jungle DA)
 dict(src='overgrown_wilds', zid='bois_enchevetres', ch=26,
      nen='Overgrown Wilds', nfr='Bois Enchevêtrés',
      factor=3.4, max_lv=69, level=67, lz_key='first_cradle_wilds',
      lz_name=('First Cradle', 'Premier Berceau'),
      arena='premier_berceau_arene', arena_at=('mystery_jungle_1_floor', 'mystery_jungle_1_wall'),
      arena_music='Mystifying Forest.ogg',
      bosses=[('mew', 'Mew', 68, 0, 'synchronize',
               [('psychic', 10), ('transform', 10), ('ancient_power', 5), ('barrier', 20)]),
              ('hoopa', 'Hoopa', 67, 0, 'magician',
               [('hyperspace_hole', 5), ('shadow_ball', 15), ('astonish', 15), ('trick', 10)])]),
 # ch27 Rayquaza — Hauteurs de l'Étoile Filante (le ciel : sa DA, notre Sky Tower New Era)
 dict(src='starfall_heights', zid='hauteurs_etoile', ch=27,
      nen='Starfall Heights', nfr="Hauteurs de l'Étoile Filante",
      factor=1.0, max_lv=71, level=69, lz_key='ninth_summit_heights',
      lz_name=('Ninth Summit', 'Neuvième Sommet'),
      arena='neuvieme_sommet_arene', arena_at=('sky_tower_floor', 'sky_tower_wall'),
      arena_music='Sky Tower.ogg',
      bosses=[('rayquaza', 'Rayquaza', 70, 0, 'air_lock',
               [('dragon_ascent', 5), ('extreme_speed', 5), ('dragon_dance', 20), ('twister', 20)])]),
]

GENERIC_MAPS = ['boss_artifact', 'boss_beehive', 'boss_celestial', 'boss_charm',
                'boss_discharge', 'boss_dragon_1', 'boss_dragon_2',
                'boss_eeveelution_1', 'boss_eeveelution_2', 'boss_firefly_pair',
                'boss_lava_plume', 'boss_pink_wall', 'boss_psychic',
                'boss_ralts_pair', 'boss_sandstorm_1', 'boss_sun_altar',
                'boss_trapper', 'end_moonlit_courtyard', 'end_overgrown_wilds',
                'end_relic_tower', 'end_sickly_hollow', 'end_veiled_ridge',
                'pattern_double_colon', 'room_exotic_wilds_entrance',
                'room_garden_center_cross', 'room_garden_cross',
                'room_inscribed_entrance', 'room_moon_crescent_left',
                'room_moon_crescent_right', 'room_moon_dance', 'room_moon_full',
                'room_moon_half_left', 'room_moon_half_right', 'room_moon_new',
                'room_sleeping_caldera_altar', 'room_treacherous_item',
                'secret_tropical_path', 'special_gsc_ghost', 'special_rby_fairy']
# end_treacherous_mountain : déjà utilisé comme ground ch5 -> renommé
MAP_RENAMES = {'end_treacherous_mountain': 'montagne_traitresse_fond'}
MUSIC_SUBS = {'Fortune Ravine Depths.ogg': 'Boulder Quarry.ogg',
              'Hidden Land.ogg': 'Time Gear Remix.ogg',
              'Title.ogg': 'Top Menu Theme.ogg'}

ARENA_TEMPLATE = json.load(open('/tmp/arena_map_template.json'))

# HP par niveau (ref rebalance: Magcargo L18 HP 150 -> ~8.3 HP/level +bonus)
def hp_for(level):
    return int(150 + (level - 18) * 9)

def build_arena(cfg):
    d = copy.deepcopy(ARENA_TEMPLATE)
    o = d['Object']
    o['AssetName'] = cfg['arena']
    o['ID'] = cfg['arena']
    o['Name'] = {'DefaultText': cfg['lz_name'][0], 'LocalTexts': {'fr': cfg['lz_name'][1]}}
    o['Comment'] = (f"New Era ch{cfg['ch']} anchor arena — rematch of "
                    f"{'/'.join(b[0] for b in cfg['bosses'])}. Autotiles: {cfg['arena_at'][0]}.")
    o['Music'] = cfg['arena_music']
    raw = json.dumps(d)
    raw = raw.replace('treeshroud_forest_1_floor', cfg['arena_at'][0])
    raw = raw.replace('treeshroud_forest_1_wall', cfg['arena_at'][1])
    d = json.loads(raw)
    o = d['Object']
    tmpl = o['MapTeams'][0]['Players'][0]
    positions = [(7, 5), (5, 5), (9, 5)]
    players = []
    for i, (sp, nick, lv, gender, intr, skills) in enumerate(cfg['bosses']):
        p = copy.deepcopy(tmpl)
        p['BaseForm'] = {'Species': sp, 'Form': 0, 'Skin': 'normal', 'Gender': gender}
        p['Nickname'] = nick
        p['Level'] = lv
        p['HP'] = hp_for(lv)
        p['MaxHPBonus'] = min(256, 60 + lv)
        p['BaseIntrinsics'] = [intr]
        p['BaseSkills'] = [{'SkillNum': s, 'Charges': c, 'CanForget': False} for s, c in skills]
        p['Unrecruitable'] = False
        p['serializationLoc'] = {'X': positions[i][0], 'Y': positions[i][1]}
        players.append(p)
    o['MapTeams'][0]['Players'] = players
    save(f"Data/Map/{cfg['arena']}.rsmap", d)

SEG_TEMPLATE = json.load(open('/tmp/arena_segment_template.json'))

def arena_segment(cfg):
    s = copy.deepcopy(SEG_TEMPLATE)
    raw = json.dumps(s)
    raw = raw.replace('verdant_oath_arena', cfg['arena'])
    s = json.loads(raw)
    return s

if __name__ == '__main__':
    # 1. musiques
    n = 0
    for f in sorted(os.listdir('/tmp/wave3/music')):
        dst = f'Content/Music/{f}'
        if not os.path.exists(dst):
            shutil.copy(f'/tmp/wave3/music/{f}', dst)
            n += 1
    print('musiques importées:', n)

    # 2. cartes génériques
    n = 0
    for m in GENERIC_MAPS:
        if os.path.exists(f'Data/Map/{m}.rsmap'):
            continue
        save(f'Data/Map/{m}.rsmap', load(f'{MAPS}/{m}.rsmap'))
        n += 1
    for old, new in MAP_RENAMES.items():
        d = load(f'{MAPS}/{old}.rsmap')
        d['Object']['AssetName'] = new
        save(f'Data/Map/{new}.rsmap', d)
        n += 1
    print('cartes importées:', n)

    # 3. zones + arènes + index
    idx = load('Data/Zone/index.idx')
    lz_entries = []
    for cfg in DUNGEONS:
        d = load(f"{SRC}/{cfg['src']}.json")
        o = d['Object']
        o['Name'] = {'DefaultText': cfg['nen'], 'LocalTexts': {'fr': cfg['nfr']}}
        o['Comment'] = (f"New Era ch{cfg['ch']} — Anchor dungeon of "
                        f"{'/'.join(b[1] for b in cfg['bosses'])} (Livre II, Éveil des Ancrages). "
                        f"Source rescaled per tier chart.")
        o['Released'] = True
        o['Level'] = cfg['level']
        n_p = purge_scripts(o)
        n_e = drop_empty_steps(o)
        # segment d'arène ajouté en dernier
        segs = None
        def find_segs(x):
            global segs
            if isinstance(x, dict):
                for k, v in x.items():
                    if k == 'Segments' and isinstance(v, list):
                        segs = v
                        return
                    find_segs(v)
            elif isinstance(x, list):
                for v in x:
                    find_segs(v)
        find_segs(o)
        segs.append(arena_segment(cfg))
        seg_id = len(segs) - 1
        t = json.dumps(d, ensure_ascii=False, indent=2)
        if cfg['factor'] != 1.0 or cfg['max_lv']:
            t = scale_levels(t, cfg['factor'], max_lv=cfg['max_lv'])
        for old, new in MAP_RENAMES.items():
            t = t.replace(f'"{old}"', f'"{new}"')
        for old, new in MUSIC_SUBS.items():
            t = t.replace(old, new)
        with io.open(f"Data/Zone/{cfg['zid']}.json", 'w', encoding='utf-8-sig') as f:
            f.write(t)
        build_arena(cfg)
        # résumé index
        d2 = json.loads(t)
        o2 = d2['Object']
        maps_arr, total = [], 0
        def find_segs2(x):
            if isinstance(x, dict):
                for k, v in x.items():
                    if k == 'Segments' and isinstance(v, list):
                        return v
                    r = find_segs2(v)
                    if r is not None:
                        return r
            elif isinstance(x, list):
                for v in x:
                    r = find_segs2(v)
                    if r is not None:
                        return r
        for s in find_segs2(o2):
            ty = s.get('$type', '')
            fl = s.get('Floors')
            if 'LayeredSegment' in ty:
                nf = len(fl['$values']) if isinstance(fl, dict) and '$values' in fl else len(fl)
                maps_arr.append(list(range(nf))); total += nf
            else:
                maps_arr.append([0]); total += 1
        idx['Object'][cfg['zid']] = {
            '$type': 'RogueEssence.Data.ZoneEntrySummary, RogueEssence',
            'ExpPercent': o2.get('ExpPercent', 100), 'Level': cfg['level'],
            'LevelCap': o2.get('LevelCap', False), 'KeepSkills': o2.get('KeepSkills', False),
            'TeamRestrict': o2.get('TeamRestrict', False), 'TeamSize': o2.get('TeamSize', -1),
            'MoneyRestrict': o2.get('MoneyRestrict', False), 'BagRestrict': o2.get('BagRestrict', -1),
            'KeepTreasure': o2.get('KeepTreasure', False), 'BagSize': o2.get('BagSize', -1),
            'Rescues': o2.get('Rescues', 2), 'CountedFloors': total, 'Rogue': 0,
            'Grounds': [], 'Maps': maps_arr,
            'Name': {'DefaultText': cfg['nen'], 'LocalTexts': {'fr': cfg['nfr']}},
            'Released': True, 'SortOrder': 0,
        }
        lz_entries.append((cfg, seg_id))
        print(f"{cfg['zid']:24s} ch{cfg['ch']} L{cfg['level']} arena_seg={seg_id} "
              f"boss={'/'.join(b[0] for b in cfg['bosses'])} purged={n_p}+{n_e}")
    save('Data/Zone/index.idx', idx)
    json.dump([{'zid': c['zid'], 'ch': c['ch'], 'seg': s, 'lz_key': c['lz_key'],
                'species': c['bosses'][0][0], 'lz_name': c['lz_name'],
                'bosses': [b[0] for b in c['bosses']], 'price': 12000 + c['ch']*1200}
               for c, s in lz_entries],
              open('/tmp/wave3_lz.json', 'w'), indent=1)
    print('index.idx +15 zones ; manifest LegendZones -> /tmp/wave3_lz.json')
