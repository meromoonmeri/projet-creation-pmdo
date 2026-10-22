#!/usr/bin/env python3
"""Vague 3c — Séparation des duos + tous les fabuleux (directive 2026-07-27).

1. Articuno et Zapdos SÉPARÉS : Zapdos reçoit son propre donjon « Mont
   Grondant » (DA Mt Thunder — écho du ground pmd-red mont_grondant_pied déjà
   en réserve) ; Articuno garde la Montagne Traîtresse seul.
2. Solgaleo et Lunala SÉPARÉS : Lunala reçoit « Chapelle de la Nuit »
   (DA murky/nuit) ; Solgaleo garde Le Conte Sans Fin seul.
3. 13 donjons de fabuleux : Marshadow, Deoxys, Shaymin, Manaphy(+Phione),
   Keldeo, Meloetta, Genesect, Volcanion, Magearna, Zeraora, Melmetal(+Meltan),
   Arceus. Chacun son donjon, DA dédiée, contrat Grodoudou ready.

Méthode : clone d'une zone source DumpAsset (déjà téléchargée /tmp/wave3/zones)
avec SWAP D'AUTOTILES (biome complet changé -> aucun doublon visuel), renivelage
propre, arène DA, segment ajouté. Réutilise import_wave3_anchors helpers.
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
import sys, os, json, io, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import importlib
w3 = importlib.import_module('import_wave3_anchors')

# (src_clone, zid, nen, nfr, ch, level, factor, max_lv, at_swap{old:new},
#  lz_key, lz_name(en,fr), arena, arena_at, arena_music, bosses)
DUNGEONS_C = [
 # --- séparations de duos ---
 dict(src='veiled_ridge', zid='mont_grondant', ch=17,
      nen='Rumbling Mount', nfr='Mont Grondant',
      factor=0.85, max_lv=49, level=47,
      at_swap={}, at_biome=('mt_thunder_floor', 'mt_thunder_wall'),
      lz_key='high_conductor', new_contract=False,
      lz_name=('High Conductor', 'Grand Conducteur'),
      arena='grand_conducteur_arene', arena_at=('mt_thunder_peak_floor', 'mt_thunder_peak_wall'),
      arena_music='Rising Fear.ogg',
      bosses=[('zapdos', 'Électhor', 48, 0, 'pressure',
               [('drill_peck', 20), ('thunder_wave', 20), ('detect', 10), ('spark', 20)])]),
 dict(src='moonlit_courtyard', zid='chapelle_nuit', ch=31,
      nen='Night Chapel', nfr='Chapelle de la Nuit',
      factor=2.4, max_lv=79, level=77,
      at_swap={}, at_biome=('murky_cave_floor', 'murky_cave_wall'),
      lz_key='two_lights_lunala', new_contract=False,
      lz_name=('Wings of Night', 'Ailes de la Nuit'),
      arena='ailes_nuit_arene', arena_at=('murky_cave_floor', 'murky_cave_wall'),
      arena_music='Sky Peak Cave.ogg',
      bosses=[('lunala', 'Lunala', 78, 1, 'shadow_shield',
               [('moongeist_beam', 5), ('psychic', 10), ('air_slash', 15), ('moonlight', 5)])]),
 # --- fabuleux ---
 dict(src='labyrinth_of_the_lost', zid='creux_ombres', ch=26,
      nen='Shadow Hollow', nfr='Creux des Ombres',
      factor=13.4, max_lv=69, level=67,
      at_swap={}, at_biome=('deep_dusk_forest_2_floor', 'deep_dusk_forest_2_wall'),
      lz_key='only_shadow', new_contract=True, price=43200,
      lz_name=('Only Shadow', 'La Seule Ombre'),
      arena='seule_ombre_arene', arena_at=('deep_dusk_forest_2_floor', 'deep_dusk_forest_2_wall'),
      arena_music='I Saw Something Again....ogg',
      bosses=[('marshadow', 'Marshadow', 68, 0, 'technician',
               [('spectral_thief', 10), ('close_combat', 5), ('shadow_sneak', 30), ('force_palm', 10)])]),
 dict(src='inscribed_cave', zid='grotte_meteore', ch=21,
      nen='Meteorite Hollow', nfr='Grotte du Météore',
      factor=1.0, max_lv=59, level=57,
      at_swap={}, at_biome=('spacial_rift_2_floor', 'spacial_rift_2_wall'),
      lz_key='fallen_visitor', new_contract=True, price=37200,
      lz_name=('Fallen Visitor', 'Le Visiteur Tombé'),
      arena='visiteur_tombe_arene', arena_at=('spacial_rift_2_floor', 'spacial_rift_2_wall'),
      arena_music='Time Gear Remix.ogg',
      bosses=[('deoxys', 'Deoxys', 58, 0, 'pressure',
               [('psycho_boost', 5), ('cosmic_power', 20), ('extreme_speed', 5), ('recover', 10)])]),
 dict(src='hope_road', zid='jardin_gratitude', ch=15,
      nen='Gratitude Garden', nfr='Jardin de la Gratitude',
      factor=1.05, max_lv=45, level=43,
      at_swap={}, at_biome=('lush_prairie_floor', 'lush_prairie_wall'),
      lz_key='thanks_bloom', new_contract=True, price=30000,
      lz_name=('Where Thanks Bloom', 'Là où Fleurit le Merci'),
      arena='fleur_merci_arene', arena_at=('lush_prairie_floor', 'lush_prairie_wall'),
      arena_music='Healing Forest.ogg',
      bosses=[('shaymin', 'Shaymin', 44, 0, 'natural_cure',
               [('seed_flare', 5), ('synthesis', 5), ('magical_leaf', 20), ('sweet_scent', 20)])]),
 dict(src='the_abyss', zid='berceau_mers', ch=16,
      nen='Cradle of Seas', nfr='Berceau des Mers',
      factor=0.46, max_lv=47, level=45,
      at_swap={}, at_biome=('surrounded_sea_floor', 'surrounded_sea_wall'),
      lz_key='sea_cradle', new_contract=True, price=31200,
      lz_name=('Sea Cradle', 'Berceau des Mers'),
      arena='berceau_mers_arene', arena_at=('surrounded_sea_floor', 'surrounded_sea_wall'),
      arena_music='Water Cave.ogg',
      bosses=[('manaphy', 'Manaphy', 46, 0, 'hydration',
               [('tail_glow', 20), ('surf', 15), ('aqua_ring', 20), ('bubble_beam', 20)]),
              ('phione', 'Phione', 44, 0, 'hydration',
               [('bubble_beam', 20), ('charm', 20), ('whirlpool', 15), ('water_pulse', 20)])]),
 dict(src='bravery_road', zid='gue_poulain', ch=18,
      nen='Colt Ford', nfr='Gué du Poulain',
      factor=2.35, max_lv=52, level=50,
      at_swap={}, at_biome=('brine_cave_floor', 'brine_cave_wall'),
      lz_key='resolute_ford', new_contract=True, price=33600,
      lz_name=('Resolute Ford', 'Gué de la Résolution'),
      arena='gue_resolution_arene', arena_at=('brine_cave_floor', 'brine_cave_wall'),
      arena_music='Spring Cave.ogg',
      bosses=[('keldeo', 'Keldeo', 51, 0, 'justified',
               [('secret_sword', 10), ('aqua_jet', 20), ('double_kick', 30), ('swords_dance', 20)])]),
 dict(src='wisdom_road', zid='amphitheatre_oublie', ch=20,
      nen='Forgotten Amphitheater', nfr='Amphithéâtre Oublié',
      factor=1.35, max_lv=57, level=55,
      at_swap={}, at_biome=('crystal_cave_1_floor', 'crystal_cave_1_wall'),
      lz_key='last_encore', new_contract=True, price=36000,
      lz_name=('Last Encore', 'Dernier Rappel'),
      arena='dernier_rappel_arene', arena_at=('crystal_cave_1_floor', 'crystal_cave_1_wall'),
      arena_music='Sympathy.ogg',
      bosses=[('meloetta', 'Meloetta', 56, 1, 'serene_grace',
               [('relic_song', 10), ('psychic', 10), ('round', 15), ('sing', 15)])]),
 dict(src='deserted_fortress', zid='reacteur_enfoui', ch=22,
      nen='Buried Reactor', nfr='Réacteur Enfoui',
      factor=2.3, max_lv=61, level=59,
      at_swap={}, at_biome=('buried_relic_3_floor', 'buried_relic_3_wall'),
      lz_key='old_reactor', new_contract=True, price=38400,
      lz_name=('The Old Reactor', 'Le Vieux Réacteur'),
      arena='vieux_reacteur_arene', arena_at=('buried_relic_3_floor', 'buried_relic_3_wall'),
      arena_music='Boulder Quarry.ogg',
      bosses=[('genesect', 'Genesect', 60, 0, 'download',
               [('techno_blast', 5), ('metal_claw', 35), ('signal_beam', 15), ('magnet_rise', 10)])]),
 dict(src='sleeping_caldera', zid='forge_vapeur', ch=23,
      nen='Steam Forge', nfr='Forge de Vapeur',
      factor=1.7, max_lv=63, level=61,
      at_swap={}, at_biome=('steam_cave_floor', 'steam_cave_wall'),
      lz_key='steam_heart', new_contract=True, price=39600,
      lz_name=('Steam Heart', 'Cœur de Vapeur'),
      arena='coeur_vapeur_arene', arena_at=('steam_cave_floor', 'steam_cave_wall'),
      arena_music='Steam Cave? no', arena_music_fix='Lower Spring Cave.ogg',
      bosses=[('volcanion', 'Volcanion', 62, 0, 'water_absorb',
               [('steam_eruption', 5), ('flamethrower', 15), ('hydro_pump', 5), ('haze', 30)])]),
 dict(src='relic_tower', zid='atelier_coeur_mecanique', ch=24,
      nen='Gearheart Workshop', nfr='Atelier du Cœur-Mécanique',
      factor=1.75, max_lv=65, level=63,
      at_swap={}, at_biome=('buried_relic_1_floor', 'buried_relic_1_wall'),
      lz_key='gear_heart', new_contract=True, price=40800,
      lz_name=('Gear Heart', 'Cœur d\'Engrenages'),
      arena='coeur_engrenages_arene', arena_at=('buried_relic_1_floor', 'buried_relic_1_wall'),
      arena_music='Marowak Dojo.ogg',
      bosses=[('magearna', 'Magearna', 64, 0, 'soul_heart',
               [('fleur_cannon', 5), ('flash_cannon', 10), ('gear_grind', 15), ('helping_hand', 20)])]),
 dict(src='faultline_ridge', zid='piste_fulgurante', ch=25,
      nen='Fulgurant Track', nfr='Piste Fulgurante',
      factor=3.85, max_lv=67, level=65,
      at_swap={}, at_biome=('mt_thunder_floor', 'mt_thunder_wall'),
      lz_key='wild_current', new_contract=True, price=42000,
      lz_name=('Wild Current', 'Courant Sauvage'),
      arena='courant_sauvage_arene', arena_at=('mt_thunder_floor', 'mt_thunder_wall'),
      arena_music='Rising Fear.ogg',
      bosses=[('zeraora', 'Zeraora', 66, 0, 'volt_absorb',
               [('plasma_fists', 10), ('close_combat', 5), ('quick_attack', 30), ('charge', 20)])]),
 dict(src='sickly_hollow', zid='fonderie_hex', ch=27,
      nen='Hex Foundry', nfr='Fonderie Hex',
      factor=2.75, max_lv=71, level=69,
      at_swap={}, at_biome=('steel_aegis_cave_floor', 'steel_aegis_cave_wall'),
      lz_key='liquid_metal', new_contract=True, price=44400,
      lz_name=('Liquid Metal', 'Métal Liquide'),
      arena='metal_liquide_arene', arena_at=('steel_aegis_cave_floor', 'steel_aegis_cave_wall'),
      arena_music='Boulder Quarry.ogg',
      bosses=[('melmetal', 'Melmetal', 70, 0, 'iron_fist',
               [('double_iron_bash', 10), ('thunder_punch', 15), ('harden', 30), ('flash_cannon', 10)]),
              ('meltan', 'Meltan', 65, 0, 'magnet_pull',
               [('flash_cannon', 10), ('thunder_shock', 30), ('harden', 30), ('headbutt', 15)])]),
 dict(src='sacred_tower', zid='tour_origine', ch=32,
      nen='Tower of Origin', nfr='Tour de l\'Origine',
      factor=1.62, max_lv=86, level=84,
      at_swap={}, at_biome=('hidden_highland_floor', 'hidden_highland_wall'),
      lz_key='first_breath', new_contract=True, price=66000,
      lz_name=('First Breath', 'Premier Souffle'),
      arena='premier_souffle_arene', arena_at=('hidden_highland_floor', 'hidden_highland_wall'),
      arena_music='Welcome to the World of Pokémon!.ogg',
      bosses=[('arceus', 'Arceus', 85, 0, 'multitype',
               [('judgment', 10), ('recover', 10), ('extreme_speed', 5), ('cosmic_power', 20)])]),
]


def swap_biome(t, at_biome):
    """Remplace tous les autotiles floor/wall/secondary de la zone par la DA cible."""
    floors = set(re.findall(r'"([a-z_0-9]+_floor)"', t))
    walls = set(re.findall(r'"([a-z_0-9]+_wall)"', t))
    secs = set(re.findall(r'"([a-z_0-9]+_secondary)"', t))
    nf, nw = at_biome
    ns = nf.replace('_floor', '_secondary')
    for f in floors:
        t = t.replace(f'"{f}"', f'"{nf}"')
    for w in walls:
        t = t.replace(f'"{w}"', f'"{nw}"')
    for s in secs:
        t = t.replace(f'"{s}"', f'"{ns}"')
    return t


if __name__ == '__main__':
    idx = w3.load('Data/Zone/index.idx')
    lz = json.load(open('/tmp/wave3_lz.json'))
    for cfg in DUNGEONS_C:
        d = w3.load(f"{w3.SRC}/{cfg['src']}.json")
        o = d['Object']
        o['Name'] = {'DefaultText': cfg['nen'], 'LocalTexts': {'fr': cfg['nfr']}}
        o['Comment'] = (f"New Era ch{cfg['ch']} — dedicated dungeon of "
                        f"{'/'.join(b[1] for b in cfg['bosses'])}. Cloned from DumpAsset "
                        f"{cfg['src']} with full biome swap ({cfg['at_biome'][0]}).")
        o['Released'] = True
        o['Level'] = cfg['level']
        w3.purge_scripts(o)
        w3.drop_empty_steps(o)
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
        t = w3.scale_levels(t, cfg['factor'], max_lv=cfg['max_lv'])
        t = swap_biome(t, cfg['at_biome'])
        for old, new in w3.MUSIC_SUBS.items():
            t = t.replace(old, new)
        with io.open(f"Data/Zone/{cfg['zid']}.json", 'w', encoding='utf-8-sig') as f:
            f.write(t)
        if 'arena_music_fix' in cfg:
            cfg['arena_music'] = cfg['arena_music_fix']
        w3.build_arena(cfg)
        d2 = json.loads(t)
        o2 = d2['Object']
        maps_arr, total = [], 0
        for s in find_segs(o2):
            ty = s.get('$type', '')
            fl = s.get('Floors')
            if 'LayeredSegment' in ty:
                nf2 = len(fl['$values']) if isinstance(fl, dict) and '$values' in fl else len(fl)
                maps_arr.append(list(range(nf2))); total += nf2
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
                   'price': cfg.get('price', 12000 + cfg['ch'] * 1200),
                   'new_contract': cfg['new_contract']})
        print(f"{cfg['zid']:26s} ch{cfg['ch']} L{cfg['level']} seg={seg_id} "
              f"boss={'/'.join(b[0] for b in cfg['bosses'])} biome={cfg['at_biome'][0]}")
    w3.save('Data/Zone/index.idx', idx)
    json.dump(lz, open('/tmp/wave3_lz.json', 'w'), indent=1)
    print('index.idx +15 ; manifest total:', len(lz))
