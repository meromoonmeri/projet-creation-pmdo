#!/usr/bin/env python3
"""Vague 3b — 13 donjons-Ancrages supplémentaires (dragons créateurs, vie/mort,
soleil/lune, Abîme). Réutilise les helpers de import_wave3_anchors.py.

Assignations DA :
 Mesprit -> Hope Road (lac de l'émotion)         Azelf -> Bravery Road
 Dialga  -> Relic Tower (reliques du temps)      Palkia -> Inscribed Cave (glyphes spatiaux)
 Giratina-> Labyrinth of the Lost (monde inversé) Yveltal-> Sickly Hollow (terres mourantes)
 Zygarde -> The Sky (Le Ciel Suspendu, doc maître P7)  Xerneas-> Prism Isles (lumière de vie)
 Solgaleo+Lunala -> The Neverending Tale (conte du soleil et de la lune)
 Necrozma-> Faded Trail (piste dont la lumière s'est éteinte)
 Eternatus-> Guildmaster Trail (gauntlet final -> Nervure du Monde)
 Jirachi -> Training Maze (-> Dédale du Vœu, autotiles wish_cave)
 Celebi  -> Tropical Path (-> Bois d'Antan, forêt hors du temps)
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
import sys, os, json, io
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import importlib
w3 = importlib.import_module('import_wave3_anchors')

DUNGEONS_B = [
 dict(src='hope_road', zid='sentier_espoir', ch=13,
      nen='Hope Road', nfr="Sentier de l'Espoir",
      factor=1.0, max_lv=42, level=40, lz_key='kept_feeling_road',
      lz_name=('Kept Feeling', 'Sentiment Gardé'),
      arena='sentiment_garde_arene', arena_at=('crystal_cave_1_floor', 'crystal_cave_1_wall'),
      arena_music='Star Cave.ogg',
      bosses=[('mesprit', 'Mesprit', 41, 0, 'levitate',
               [('extrasensory', 20), ('charm', 20), ('lucky_chant', 20), ('swift', 20)])]),
 dict(src='bravery_road', zid='sentier_courage', ch=13,
      nen='Bravery Road', nfr='Sentier du Courage',
      factor=1.9, max_lv=42, level=40, lz_key='last_resolve_road',
      lz_name=('Last Resolve', 'Dernière Résolution'),
      arena='derniere_resolution_arene', arena_at=('crystal_crossing_floor', 'crystal_crossing_wall'),
      arena_music='Star Cave.ogg',
      bosses=[('azelf', 'Azelf', 41, 0, 'levitate',
               [('extrasensory', 20), ('nasty_plot', 20), ('uproar', 10), ('swift', 20)])]),
 dict(src='tropical_path', zid='bois_antan', ch=20,
      nen='Grove of Yesteryear', nfr="Bois d'Antan",
      factor=7.8, max_lv=57, level=55, lz_key='dead_hours_grove',
      lz_name=('Dead Hours', 'Heures Mortes'),
      arena='heures_mortes_arene', arena_at=('mystery_jungle_2_floor', 'mystery_jungle_2_wall'),
      arena_music='Healing Forest.ogg',
      bosses=[('celebi', 'Celebi', 56, 0, 'natural_cure',
               [('leaf_storm', 5), ('recover', 10), ('ancient_power', 5), ('baton_pass', 40)])]),
 dict(src='relic_tower', zid='tour_reliques', ch=28,
      nen='Relic Tower', nfr='Tour des Reliques',
      factor=1.9, max_lv=73, level=71, lz_key='hour_that_lags_tower',
      lz_name=('Hour That Lags', "L'Heure qui Traîne"),
      arena='heure_traine_arene', arena_at=('temporal_tower_floor', 'temporal_tower_wall'),
      arena_music='Time Gear Remix.ogg',
      bosses=[('dialga', 'Dialga', 72, 0, 'pressure',
               [('roar_of_time', 5), ('ancient_power', 5), ('dragon_claw', 15), ('iron_tail', 15)])]),
 dict(src='inscribed_cave', zid='grotte_gravee', ch=28,
      nen='Inscribed Cave', nfr='Grotte Gravée',
      factor=1.2, max_lv=73, level=71, lz_key='spatial_hill_cave',
      lz_name=('Spatial Hill', 'Colline Spatiale'),
      arena='colline_spatiale_arene', arena_at=('spacial_rift_1_floor', 'spacial_rift_1_wall'),
      arena_music='Time Gear Remix.ogg',
      bosses=[('palkia', 'Palkia', 72, 0, 'pressure',
               [('spacial_rend', 5), ('surf', 15), ('dragon_claw', 15), ('protect', 10)])]),
 dict(src='labyrinth_of_the_lost', zid='labyrinthe_perdus', ch=29,
      nen='Labyrinth of the Lost', nfr='Labyrinthe des Perdus',
      factor=14.6, max_lv=75, level=73, lz_key='reverse_slope_maze',
      lz_name=('Reverse Slope', 'Versant Inversé'),
      arena='versant_inverse_arene', arena_at=('world_abyss_2_floor', 'world_abyss_2_wall'),
      arena_music='In the Depths of the Pit.ogg',
      bosses=[('giratina', 'Giratina', 74, 0, 'pressure',
               [('shadow_force', 5), ('dragon_claw', 15), ('ominous_wind', 5), ('ancient_power', 5)])]),
 dict(src='sickly_hollow', zid='vallon_malsain', ch=29,
      nen='Sickly Hollow', nfr='Vallon Malsain',
      factor=2.9, max_lv=75, level=73, lz_key='final_rest',
      lz_name=('Cocoon of Ruin', 'Cocon de la Ruine'),
      arena='cocon_ruine_arene', arena_at=('dark_wasteland_floor', 'dark_wasteland_wall'),
      arena_music='Growing Anxiety.ogg',
      bosses=[('yveltal', 'Yveltal', 74, 0, 'dark_aura',
               [('oblivion_wing', 10), ('dark_pulse', 15), ('hurricane', 10), ('snarl', 15)])]),
 dict(src='the_sky', zid='ciel_suspendu', ch=30,
      nen='The Sky', nfr='Le Ciel Suspendu',
      factor=1.09, max_lv=77, level=75, lz_key='cells_gathering',
      lz_name=('Gathering of Cells', 'Assemblée des Cellules'),
      arena='assemblee_cellules_arene', arena_at=('spacial_cliffs_floor', 'spacial_cliffs_wall'),
      arena_music='Sky Peak Prairie.ogg',
      bosses=[('zygarde', 'Zygarde', 76, 0, 'aura_break',
               [('lands_wrath', 10), ('dragon_dance', 20), ('crunch', 15), ('safeguard', 25)])]),
 dict(src='prism_isles', zid='iles_prismatiques', ch=30,
      nen='Prism Isles', nfr='Îles Prismatiques',
      factor=7.6, max_lv=77, level=75, lz_key='given_life_isles',
      lz_name=('Given Life', 'Vie Donnée'),
      arena='vie_donnee_arene', arena_at=('crystal_crossing_floor', 'crystal_crossing_wall'),
      arena_music='Luminous Spring.ogg',
      bosses=[('xerneas', 'Xerneas', 76, 0, 'fairy_aura',
               [('moonblast', 15), ('geomancy', 10), ('horn_leech', 10), ('megahorn', 10)])]),
 dict(src='the_neverending_tale', zid='conte_sans_fin', ch=31,
      nen='The Neverending Tale', nfr='Le Conte Sans Fin',
      factor=15.4, max_lv=79, level=77, lz_key='two_lights',
      lz_name=('Two Lights', 'Les Deux Lumières'),
      arena='deux_lumieres_arene', arena_at=('mt_faraway_2_floor', 'mt_faraway_2_wall'),
      arena_music='Welcome to the World of Pokémon!.ogg',
      bosses=[('solgaleo', 'Solgaleo', 78, 0, 'full_metal_body',
               [('sunsteel_strike', 5), ('zen_headbutt', 15), ('flash_cannon', 10), ('morning_sun', 5)]),
              ('lunala', 'Lunala', 78, 1, 'shadow_shield',
               [('moongeist_beam', 5), ('psychic', 10), ('air_slash', 15), ('moonlight', 5)])]),
 dict(src='training_maze', zid='dedale_voeu', ch=31,
      nen='Wishbound Maze', nfr='Dédale du Vœu',
      factor=7.6, max_lv=77, level=75, lz_key='unsaid_wishes_maze',
      lz_name=('Unsaid Wishes', 'Vœux Tus'),
      arena='voeux_tus_arene', arena_at=('wish_cave_2_floor', 'wish_cave_2_wall'),
      arena_music='Star Cave.ogg',
      bosses=[('jirachi', 'Jirachi', 75, 0, 'serene_grace',
               [('doom_desire', 5), ('wish', 10), ('zen_headbutt', 15), ('swift', 20)])]),
 dict(src='faded_trail', zid='sentier_eteint', ch=32,
      nen='Lightless Trail', nfr='Sentier Éteint',
      factor=7.7, max_lv=81, level=79, lz_key='borrowed_light_trail',
      lz_name=('Borrowed Light', 'Lumière Empruntée'),
      arena='lumiere_empruntee_arene', arena_at=('deep_dusk_forest_1_floor', 'deep_dusk_forest_1_wall'),
      arena_music='I Saw Something Again....ogg',
      bosses=[('necrozma', 'Necrozma', 80, 0, 'prism_armor',
               [('prismatic_laser', 5), ('photon_geyser', 5), ('iron_defense', 15), ('slash', 20)])]),
 dict(src='guildmaster_trail', zid='nervure_monde', ch=32,
      nen='Worldvein', nfr='Nervure du Monde',
      factor=8.4, max_lv=86, level=84, lz_key='eternal_coil',
      lz_name=('Eternal Coil', 'Spirale Éternelle'),
      arena='spirale_eternelle_arene', arena_at=('world_abyss_2_floor', 'world_abyss_2_wall'),
      arena_music='In the Depths of the Pit.ogg',
      bosses=[('eternatus', 'Eternatus', 85, 0, 'pressure',
               [('dynamax_cannon', 5), ('flamethrower', 15), ('cross_poison', 20), ('cosmic_power', 20)])]),
]

MUSIC_SUBS = dict(w3.MUSIC_SUBS)

if __name__ == '__main__':
    idx = w3.load('Data/Zone/index.idx')
    lz = json.load(open('/tmp/wave3_lz.json'))
    for cfg in DUNGEONS_B:
        d = w3.load(f"{w3.SRC}/{cfg['src']}.json")
        o = d['Object']
        o['Name'] = {'DefaultText': cfg['nen'], 'LocalTexts': {'fr': cfg['nfr']}}
        o['Comment'] = (f"New Era ch{cfg['ch']} — Anchor dungeon of "
                        f"{'/'.join(b[1] for b in cfg['bosses'])} (Livre II). Rescaled.")
        o['Released'] = True
        o['Level'] = cfg['level']
        n_p = w3.purge_scripts(o)
        n_e = w3.drop_empty_steps(o)
        segs = []
        def find_segs(x):
            if isinstance(x, dict):
                for k, v in x.items():
                    if k == 'Segments' and isinstance(v, list):
                        return v
                    r = find_segs(v)
                    if r is not None:
                        return r
            elif isinstance(x, list):
                for v in x:
                    r = find_segs(v)
                    if r is not None:
                        return r
        segs = find_segs(o)
        segs.append(w3.arena_segment(cfg))
        seg_id = len(segs) - 1
        t = json.dumps(d, ensure_ascii=False, indent=2)
        if cfg['factor'] != 1.0 or cfg['max_lv']:
            t = w3.scale_levels(t, cfg['factor'], max_lv=cfg['max_lv'])
        for old, new in MUSIC_SUBS.items():
            t = t.replace(old, new)
        with io.open(f"Data/Zone/{cfg['zid']}.json", 'w', encoding='utf-8-sig') as f:
            f.write(t)
        w3.build_arena(cfg)
        d2 = json.loads(t)
        o2 = d2['Object']
        maps_arr, total = [], 0
        for s in find_segs(o2):
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
        lz.append({'zid': cfg['zid'], 'ch': cfg['ch'], 'seg': seg_id,
                   'lz_key': cfg['lz_key'], 'species': cfg['bosses'][0][0],
                   'lz_name': cfg['lz_name'], 'bosses': [b[0] for b in cfg['bosses']],
                   'price': 12000 + cfg['ch'] * 1200})
        print(f"{cfg['zid']:24s} ch{cfg['ch']} L{cfg['level']} seg={seg_id} "
              f"boss={'/'.join(b[0] for b in cfg['bosses'])} purged={n_p}+{n_e}")
    w3.save('Data/Zone/index.idx', idx)
    json.dump(lz, open('/tmp/wave3_lz.json', 'w'), indent=1)
    print('index.idx +13 ; manifest total:', len(lz))
