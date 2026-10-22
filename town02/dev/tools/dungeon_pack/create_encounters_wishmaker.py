# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---
import json
import csv

NORMAL = 0
SUPPORT = 1
LEADER = 2 
LONER = 3

roles_arr = ["Normal", "Support", "Leader", "Loner"]

        
if __name__ == "__main__":
    mons = [
        

        #1
        ('eevee2', 'wander_normal', 'adaptability', ['baby_doll_eyes', 'round'], 10, 11, 0, 4, 0, 10),
        ('skitty', 'wander_normal', 'wonder_skin', ['fake_out', 'copycat'], 10, 11, 0, 4, 0, 10),
        ('cleffa', 'wander_normal', 'friend_guard', ['covet', 'mimic'], 10, 11, 0, 3, 0, 10),
        
        #2
        ('ralts', 'wander_normal', 'trace', ['disarming_voice', 'teleport'], 12, 13, 1, 4, 0, 10),
        ('goomy', 'wander_normal', '', ['water_gun', 'absorb'], 11, 12, 1, 4, 0, 10),
        ('diglett', 'wander_normal', 'arena_trap', ['astonish', 'sand_attack'], 12, 13, 1, 4, 0, 10),
        
        #3
        ('togepi', 'wander_dumb', 'super_luck', ['metronome'], 14, 15, 2, 5, 0, 10),
        ('hatenna', 'wander_normal', 'healer', ['play_nice', 'life_dew'], 13, 14, 2, 6, SUPPORT, 10),
        ('whismur', 'wander_normal', 'rattled', ['echoed_voice', 'round'], 14, 15, 2, 6, 0, 10),
        
        #4
        ('zubat2', 'wander_normal', '', ['poison_fang'], 14, 15, 3, 6, 0, 10),
        ('houndour', 'wander_normal', '', ['ember', 'leer', 'smog'], 14, 15, 3, 6, LONER, 10),
        ('azurill', 'wander_normal', 'thick_fat', ['charm', 'sing', 'bubble_beam'], 15, 16, 3, 5, 0, 10),
        
        #5
        ('noibat', 'wander_normal', 'telepathy', ['double_team', 'gust'], 15, 16, 4, 7, LEADER, 10),
        ('solosis', 'wander_normal', 'magic_guard', ['confusion', 'reflect'], 15, 16, 4, 7, 0, 10),
        
        #6
        ('spritzee', 'wander_normal', '', ['fairy_wind'], 17, 18, 5, 10, SUPPORT, 10),
        ('joltik', 'wander_normal', 'unnerve', ['electroweb', 'string_shot'], 16, 17, 5, 8, 0, 10),
        ('pikachu', 'wander_normal', '', ['quick_attack', 'round', 'thunder_wave', 'agility'], 17, 18, 5, 10, SUPPORT, 10),
        ('woobat2', 'wander_normal', '', ['heart_stamp', 'attract'], 16, 17, 5, 8, 0, 10),
        ('vulpix', 'wander_normal', 'flash_fire', ['disable', 'ember'], 16, 17, 5, 8, 0, 10),
        
        
        #7
        ('chingling2', 'wander_normal', '', ['wish', 'wrap', 'ally_switch'], 18, 19, 6, 9, SUPPORT, 10),
        ('nickit', 'thief', 'stakeout', ['thief2'], 18, 19, 6, 10, 0, 10),
        ('gothita', 'wander_normal', 'competitive', ['confusion', 'fake_tears'], 18, 19, 6, 9, 0, 10),
        ('swinub', 'wander_normal', '', ['mud_bomb'], 18, 19, 6, 9, 0, 10),
        ('chinchou', 'wander_normal', 'volt_absorb', ['supersonic', "spark"], 18, 19, 6, 9, 0, 10),
        
        #8
        ('jigglypuff', 'wander_normal', 'friend_guard', ['baton_pass', 'defense_curl', 'round'], 20, 21, 7, 11, SUPPORT, 10),
        ('mime_jr', 'wander_normal', 'technician', ['mimic', 'stored_power'], 21, 22, 7, 10, 0, 10),
        ('gulpin', 'wander_normal', 'liquid_ooze', ['sludge', 'yawn'], 20, 21, 7, 10, LONER, 10),
        ('beldum', 'wander_normal', '', ['take_down'], 20, 21, 7, 10, 0, 10),
        ('clauncher', 'wander_normal', 'mega_launcher', ['aqua_jet', 'vice_grip'], 20, 21, 7, 10, SUPPORT, 10),
        
        #9
        ('morelull', 'retreater', '', ['sleep_powder', 'leech_seed'], 22, 23, 8, 10, SUPPORT, 10),
        ('bagon', 'wander_normal', 'rock_head', ['wish', 'focus_energy', 'scary_face', 'ember'], 21, 22, 8, 10, 0, 10),
        ('meditite', 'wander_normal', 'pure_power', ['fake_out', 'force_palm'], 21, 22, 8, 10, LEADER, 10),
        ('elekid', 'wander_normal', '', ['thunder_punch', 'leer'], 21, 22, 8, 10, 0, 10),
        ('ferroseed', 'wander_normal', '', ['leech_seed', 'tackle'], 21, 22, 8, 10, SUPPORT, 10),
        ('bronzor', 'wander_normal', 'levitate', ['psywave', 'heal_block'], 21, 22, 8, 10, SUPPORT, 10),
        
        
        #10
        ('tinkatink', 'wander_normal', 'mold_breaker', ['baby_doll_eyes', 'metal_claw', 'covet2'], 23, 23, 9, 12, 0, 10),
        ('aron', 'wander_normal', 'rock_head', ['metal_claw', 'dig'], 23, 24, 9, 11, 0, 10),
        ('marill', 'wander_normal', 'thick_fat', ['rollout', 'aqua_ring', 'mud_slap'], 23, 24, 9, 12, 0, 10),
        
        #11
        ('luvdisc', 'wander_normal', '', ['wish', 'water_pulse', 'round'], 23, 24, 10, 14, LEADER, 10),
        ('tentacool', 'wander_normal', 'liquid_ooze', ['acid', 'water_gun'], 23, 24, 10, 13, 0, 10),
        ('sneasel', 'wander_crystal_normal', '', ['taunt', 'icy_wind', 'fury_swipes'], 23, 24, 10, 13, 0, 10),
        ('mareanie', 'wander_normal', 'limber', ['acid_spray'], 23, 24, 10, 13, SUPPORT, 10),
        ('impidimp', 'thief_crystal', 'pickpocket2', ['torment', 'foul_play', 'play_rough'], 24, 25, 10, 14, 0, 10),
        
        #12
        ('porygon', 'wander_crystal_normal', '', ['conversion', 'signal_beam', 'charge_beam'], 25, 26, 11, 14, LONER, 10),
        ('feebas', 'wander_normal', '', ['scald', 'flail'], 27, 28, 11, 14, 0, 10),
        ('baltoy', 'wander_normal', '', ['rock_tomb', 'cosmic_power', 'imprison'], 26, 27, 11, 14, SUPPORT, 10),
        ('kirlia', 'wander_normal', 'telepathy', ['dazzling_gleam', 'heal_pulse', 'trick'], 26, 27, 11, 14, SUPPORT, 10),
        
        #13
        ('volbeat', 'wander_normal', 'swarm', ['giga_drain', 'bug_buzz'], 27, 28, 12, 15, 0, 10),
        ('illumise', 'wander_normal', 'prankster', ['wish', 'helping_hand', 'struggle_bug'], 25, 26, 12, 15, SUPPORT, 10),
        ('emolga', 'wander_normal', 'static', ['volt_switch', 'aerial_ace'], 25, 26, 12, 15, LEADER, 7),
        ('dunsparce', 'wander_normal', 'serene_grace', ['take_down', 'yawn', 'screech'], 26, 27, 12, 15, 0, 7),
        
        #14
        ('rhyhorn', 'wander_normal', 'rock_head', ['rock_blast', 'bulldoze'], 27, 28, 13, 15, 0, 10),
        ('swoobat', 'wander_normal', 'unaware', ['air_cutter', 'imprison'], 29, 30, 13, 15, 0, 10),
        ('onix', 'wander_normal', '', ['bind', 'rage', 'rock_tomb'], 29, 30, 13, 15, 0, 10),
        ('togetic', 'wander_crystal_normal', '', ['baton_pass', 'ancient_power', 'double_team'], 28, 29, 13, 15, SUPPORT, 10),
        
        #15
        ('skarmory', 'wander_normal', 'sturdy', ['spikes', 'metal_claw'], 28, 29, 14, 17, LONER, 10),
        ('sableye', 'wander_crystal_normal_greedy', 'prankster', ['punishment', 'taunt'], 30, 31, 14, 17, LONER, 10),
        
        #16
        ('loudred', 'wander_normal', '', ['uproar', 'stomp', 'round'], 31, 32, 15, 18, 0, 10),
        ('solrock', 'wander_normal', 'levitate', ['psyshock', 'rock_slide', 'substitute'], 30, 31, 15, 18, 0, 10),
        ('lunatone', 'wander_normal', 'levitate', ['moonblast', 'moonlight'], 31, 32, 15, 18, SUPPORT, 10),
        ('swoobat', 'wander_normal', 'unaware', ['air_cutter', 'imprison'], 31, 32, 15, 18, 0, 6),
        ('chatot', 'wander_normal', 'tangled_feet', ['chatter', 'round', 'mimic'], 32, 33, 15, 18, LONER, 10),
        ('spinda', 'wander_normal', '', ['focus_punch', 'teeter_dance', 'hyper_voice'], 34, 35, 15, 18, 0, 10),
        ('relicanth', 'wander_normal', '', ['dive', 'ancient_power'], 30, 31, 15, 18, LONER, 10),
        ('nosepass', 'wander_normal', 'sturdy', ['power_gem', 'discharge'], 29, 30, 15, 18, LONER, 10),
        ('tinkatuff', 'thief_crystal', 'mold_breaker', ['thief2', 'fake_out', 'play_rough'], 32, 33, 15, 18, LEADER, 10),
        ('clefairy', 'wander_normal', 'friend_guard', ['follow_me', 'wish', 'copycat', 'minimize'], 31, 32, 15, 18, SUPPORT, 10),
        ('girafarig', 'wander_crystal_normal', 'inner_focus', ['nasty_plot', 'baton_pass', 'agility', 'stomp'], 32, 33, 15, 18, SUPPORT, 10),
        ('impidimp', 'thief_crystal', 'pickpocket2', ['fake_out', 'parting_shot'], 32, 33, 15, 19, 0, 10),
        
        #17
        ('swoobat', 'retreater', 'unaware', ['odor_sleuth', 'imprison', "attract", "gust"], 36, 37, 16, 19, SUPPORT, 5),
        ('wigglytuff', 'wander_normal', 'friend_guard', ['round', 'wish', 'disable', 'endeavor'], 34, 35, 16, 19, SUPPORT, 10),
        ('espeon', 'wander_normal', 'magic_bounce', ['dazzling_gleam', 'psybeam', 'wish'], 34, 35, 16, 19, 0, 10),
        ('metang', 'wander_normal', 'clear_body', ['take_down', 'zen_headbutt'], 34, 35, 16, 19, 0, 10),
        ('umbreon', 'wander_normal', 'synchronize', ['wish', 'snarl', 'sand_attack'], 34, 35, 16, 19, 0, 10),
        ('gothorita', 'wander_normal', 'competitive', ['future_sight', 'mean_look'], 35, 36, 16, 19, 0, 10),
        ('persian', 'wander_crystal_normal_greedy', 'limber', ['fake_out', 'fury_swipes', 'hyper_voice'], 34, 35, 16, 19, LEADER, 10),
        ('mr_mime', 'wander_normal', 'soundproof', ['safeguard', 'round', 'encore', 'reflect'], 36, 37, 16, 19, SUPPORT, 10),
        ('rhydon', 'wander_normal', 'rock_head', ['scary_face', 'drill_run', 'rock_blast'], 34, 35, 16, 19, LONER, 10),
        
        #18
        ('plusle', 'wander_crystal_normal', 'plus', ['shock_wave', 'nuzzle', 'agility'], 36, 37, 17, 20, SUPPORT, 8),
        ('minun', 'wander_crystal_normal', 'minus', ['electroweb', 'baton_pass', 'copycat', 'wish'], 36, 37, 17, 20, SUPPORT, 10),
        ('golbat2', 'wander_normal', 'infiltrator', ['haze', 'wing_attack', 'giga_drain'], 37, 38, 18, 20, LEADER, 10),
        ('hattrem', 'wander_normal', 'healer', ['life_dew', 'aromatic_mist', 'mystical_fire'], 37, 38, 17, 20, SUPPORT, 10),
        ('duosion', 'wander_normal', 'magic_guard', ['reflect', 'pain_split', 'psybeam'], 38, 39, 17, 20, SUPPORT, 10),
        ('murkrow', 'wander_crystal_normal', 'super_luck', ['pursuit', 'foul_play', 'taunt'], 38, 39, 17, 20, 0, 10),
        ('electabuzz', 'wander_normal', '', ['thunder_punch', 'low_kick', 'screech'], 37, 38, 17, 20, 0, 10),
        ('mawile', 'wander_crystal_normal', '', ['iron_head', 'play_rough', 'vice_grip'], 37, 38, 17, 20, LONER, 10),
        
        #19
        ('shelgon', 'wander_normal', 'rock_head', ['dragon_breath', 'scary_face', 'thrash'], 39, 40, 18, 20, 0, 10),
        ('sliggoo', 'wander_normal', 'gooey', ['dragon_breath', 'acid_spray'], 36, 37, 18, 20, 0, 10),
        ('audino', 'wander_normal', 'healer', ['healing_wish', 'after_you', 'simple_beam', 'round'], 40, 41, 18, 22, SUPPORT, 10),
        ('lairon', 'wander_normal', 'rock_head', ['autotomize', 'iron_head', 'rock_slide'], 36, 37, 18, 20, 0, 10),
        ('piloswine', 'wander_normal', 'oblivious', ['icicle_crash', 'mud_slap', 'body_slam'], 39, 40, 18, 20, 0, 10),
        
        #20
        ('ledian', 'wander_crystal_normal', 'swarm', ['baton_pass', 'wish', 'silver_wind'], 43, 44, 19, 22, 0, 10),
        ('porygon2', 'wander_crystal_normal', 'trace', ['conversion_2', 'recover', 'psybeam', 'charge_beam'], 42, 43, 19, 22, LONER, 10),
        
        #21
        ('farigiraf', 'wander_normal', 'sap_sipper', ['trick_room', 'dazzling_gleam', 'hyper_voice'], 43, 44, 20, 23, LEADER, 10),
        ('exploud', 'wander_normal', '', ['hyper_voice', 'rest', 'sleep_talk', 'boomburst'], 44, 45, 20, 23, 0, 10),
        ('thievul', 'thief_crystal', 'stakeout', ['foul_play', 'thief2', 'agility', 'taunt'], 44, 45, 20, 25, 0, 10),
        ('carbink', 'turret', '', ['moonblast', 'stone_edge', 'trick_room'], 45, 46, 20, 25, 0, 10),
        ('delcatty', 'wander_normal', 'cute_charm', ['assist', 'wish', 'fake_out', 'foresight'], 44, 45, 20, 24, SUPPORT, 10),
        ('klefki', 'wander_normal', 'prankster', ['spikes', 'imprison'], 44, 45, 20, 24, 0, 10),
        ('tinkaton', 'wander_crystal_normal', 'mold_breaker', ['fake_out', 'gigaton_hammer', 'fling'], 41, 42, 20, 23, 0, 10),
        ('chimecho', 'wander_normal', '', ['yawn', 'healing_wish', 'safeguard', 'wrap'], 45, 46, 20, 24, SUPPORT, 10),
        ('raichu', 'wander_normal', '', ['thunderbolt', 'psychic'], 41, 42, 20, 24, 0, 10),
        ('sylveon', 'wander_crystal_normal', 'cute_charm', ['fairy_wind', 'helping_hand'], 44, 45, 20, 23, SUPPORT, 10),
        ('togekiss', 'wander_normal', 'serene_grace', ['follow_me', 'wish', 'foresight'], 44, 45, 20, 23, SUPPORT, 10),
        ('steelix', 'wander_normal', 'rock_head', ['smack_down', 'block', 'stealth_rock'], 43, 44, 20, 23, 0, 10),
        
        #22
        ('mr_mime', 'wander_crystal_normal', 'soundproof', ['baton_pass', 'calm_mind', 'telekinesis'], 45, 46, 21, 25, SUPPORT, 10),
        ('dugtrio', 'wander_normal', 'arena_trap', ['sucker_punch', 'sand_tomb', 'earth_power'], 45, 46, 21, 24, 0, 10),
        ('gardevoir', 'wander_normal', '', ['wish', 'moonblast', 'psyshock'], 45, 46, 21, 24, 0, 10),
        ('weavile', 'wander_crystal_normal', 'pressure', ['embargo', 'night_slash'], 44, 45, 21, 24, LONER, 10),
        ('azumarill', 'wander_normal', 'pure_power', ['belly_drum', 'aqua_tail', 'play_rough'], 45, 46, 21, 24, 0, 10),
        ('gothitelle', 'wander_normal', 'shadow_tag', ['mean_look', 'shadow_ball'], 45, 46, 21, 24, 0, 10),
        ('bronzong', 'retreater', '', ['imprison', 'gyro_ball', 'trick_room', 'metal_sound'], 45, 46, 20, 23, SUPPORT, 10),
        ('claydol', 'wander_normal', '', ['heal_block', 'teleport', 'explosion'], 46, 47, 21, 24, 0, 10),
        
        #23
        ('milotic', 'wander_normal', '', ['water_pulse', 'recover', 'icy_wind', 'dragon_tail'], 47, 48, 22, 25, LEADER, 10),
        ('reuniclus', 'wander_normal', 'magic_guard', ['psychic', 'recover', 'reflect'], 47, 48, 22, 25, 0, 10),
        ('hatterene', 'wander_normal', 'magic_bounce', ['mystical_fire', 'draining_kiss', 'heal_pulse', 'aromatic_mist'], 47, 48, 22, 25, SUPPORT, 10),
        ('electivire', 'wander_normal', 'vital_spirit', ['discharge', 'ice_punch'], 42, 43, 22, 25, 0, 10),
        ('swalot', 'wander_normal', 'liquid_ooze', ['sludge_bomb', 'stockpile', 'clear_smog', 'swallow'], 46, 47, 22, 25, 0, 10),
        ('rhyperior', 'wander_normal', '', ['drill_run', 'rock_polish', 'stone_edge'], 45, 46, 22, 25, 0, 10),
        
        #24
        ('farigiraf', 'wander_crystal_normal', 'sap_sipper', ['trick_room', 'dazzling_gleam', 'hyper_voice', 'future_sight'], 48, 49, 23, 26, LEADER, 10),
        ('tentacruel', 'wander_normal', 'liquid_ooze', ['haze', 'sludge_wave', 'water_pulse'], 49, 50, 23, 26, 0, 10),
        ('crobat', 'wander_normal', 'infiltrator', ['cross_poison', 'brave_bird', 'quick_guard'], 49, 50, 23, 26, SUPPORT, 10),
        ('glimmora', 'wander_normal', 'corrosion', ['toxic_spikes', 'rock_slide', 'toxic'], 49, 50, 23, 26, LONER, 10),
        ('togekiss', 'wander_normal', 'serene_grace', ['air_slash', 'aura_sphere', 'heat_wave'], 49, 50, 23, 26, 0, 10),
        ('clefable', 'wander_normal', 'unaware', ['moonblast', 'wish', 'cosmic_power'], 45, 46, 23, 26, SUPPORT, 10),
        
        #25
        ('aggron', 'wander_normal', 'rock_head', ['autotomize', 'head_smash', 'iron_head'], 48, 49, 24, 26, 0, 10),
        ('houndoom', 'wander_normal', 'flash_fire', ['dark_pulse', 'nasty_plot', 'overheat'], 51, 52, 24, 26, 0, 10),
        ('honchkrow', 'wander_crystal_normal', 'super_luck', ['haze', 'swagger', 'night_slash'], 51, 52, 24, 26, SUPPORT, 10),
        ('porygon_z', 'wander_crystal_normal', 'download', ['tri_attack', 'thunderbolt', 'conversion', 'conversion_2'], 48, 49, 24, 27, LONER, 7),
        ('medicham', 'wander_normal', 'pure_power', ['high_jump_kick', 'drain_punch', 'endure', 'psycho_cut'], 50, 51, 24, 27, LEADER, 10),
        
        #26
        ('metagross', 'wander_crystal_normal', 'clear_body', ['agility', 'meteor_mash', 'zen_headbutt'], 52, 53, 25, 27, 0, 10),
        ('noivern', 'wander_normal', 'infiltrator', ['boomburst', 'dragon_pulse', 'tailwind'], 54, 55, 25, 27, SUPPORT, 10),
        ('goodra', 'wander_normal', 'gooey', ['draco_meteor', 'muddy_water', 'power_whip'], 52, 53, 25, 27, 0, 10),
        ('clawitzer', 'wander_normal', 'mega_launcher', ['aura_sphere', 'water_pulse', 'dark_pulse', 'dragon_pulse'], 53, 54, 25, 27, 0, 10),
        ('salamence', 'wander_normal', 'intimidate', ["dragon_rush", "fly", "fire_fang"], 53, 54, 25, 27, LEADER, 10),
    ]

    def create_monster_house(mon_name):
        form = 0
        if mon_name == "raichu":
            form = 1
        base = {
            "Spawn": {
                "BaseForm": {
                    "Species": mon_name,
                    "Form": form,
                    "Skin": "",
                    "Gender": -1
                },
                "Level": {
                    "Min": 1,
                    "Max": 1
                },
                "SpecifiedSkills": [],
                "Intrinsic": "",
                "Tactic": "wander_smart",
                "SpawnConditions": [],
                "SpawnFeatures": [
                    {
                        "$type": "PMDC.LevelGen.MobSpawnWeak, PMDC"
                    },
                    {
                        "$type": "PMDC.LevelGen.MobSpawnLevelScale, PMDC",
                        "StartFromID": 0,
                        "AddNumerator": 4,
                        "AddDenominator": 3
                    }
                ]
            },
            "Rate": 10,
            "Range": {
                "Min": 0,
                "Max": 27
            }
        }
        return base

    monster_house_mons = [
        "cleffa", "clefairy", "clefable",
        "hatenna", "hattrem", "hatterene",
        "zubat", "golbat", "crobat",
        "meowth", "persian", 
        "vulpix", "ninetales",
        "tinkatink", "tinkatuff", "tinkaton",
        "ledian",
        "audino",
        "beldum", "metang",
        "pichu", "pikachu", "raichu",
        "togepi", "togetic", "togekiss",
        "mawile",
        "baltoy", "claydol",
        "gulpin", "swalot",
        "swinub", "piloswine",
        "minun", "plusle",
        "ralts", "kirlia", "gardevoir", "gallade",
        "azurill", "marill", "azumarill",
        "baltoy", "claydol",
        "woobat", "swoobat",
        "illumise", "volbeat",
        "bagon", "shelgon",
        "jigglypuff", "wigglytuff",
        "mime_jr", "mr_mime",
        "aron", "lairon", "aggron",
        "elekid", "electabuzz", "electivire",
        "sneasel", "weavile",
        "nickit", "thievul",
        "eevee",
        "morelull",
        "girafarig",
        "tentacool", "tentacruel",
        "dunsparce",
        "skitty", "delcatty",
        "houndour", "houndoom",
        "whismur", "loudred", "exploud",
        "solosis", "duosion", "reuniclus",
        "luvdisc",
        "clauncher", "clawitzer",
        "meditite", "medicham",
        "bronzor",  "bronzong",
        "rhyhorn", "rhydon",
        "nosepass", "probopass",
        "chingling", "chimecho",
        "chinchou", "lanturn"
    ]

    monster_house_result = []
    for mon_name in monster_house_mons:
        struct = create_monster_house(mon_name)
        monster_house_result.append(struct)

    def create_mon(mon):
        name, tactic, ability, moves, min_lev, max_lev, min_floor, max_floor, role, rate = mon[0], mon[1], mon[2], mon[3], mon[4], mon[5], mon[6], mon[7], mon[8], mon[9]
        form = 0
        if name == "raichu":
            form = 1
            
        if name == "vulpix" and ability == "snow_cloak":
            form = 1
            
        base_structure = {
            "Spawn": {
                "Spawn": {
                    "BaseForm": {
                        "Species": name,
                        "Form": form,
                        "Skin": "",
                        "Gender": -1
                    },
                    "Level": {
                        "Min": min_lev,
                        "Max": max_lev
                    },
                    "SpecifiedSkills": moves,
                    "Intrinsic": ability,
                    "Tactic": tactic,
                    "SpawnConditions": [],
                    "SpawnFeatures": [
                        {
                            "$type": "PMDC.LevelGen.MobSpawnMovesOff, PMDC",
                            "StartAt": len(moves),
                            "Remove": False
                        },
                        {
                            "$type": "PMDC.LevelGen.MobSpawnWeak, PMDC"
                        }
                    ]
                },
                "Role": role
            },
            "Rate": rate,
            "Range": {
                "Min": min_floor,
                "Max": max_floor
            }
        }
        return base_structure

    mons.sort(key=lambda item: (item[-4], item[0]))
    result = []
    for mon in mons:
        name = mon[0]
        min_lev = mon[4]
        if (min_lev < 60):
            result.append(create_mon(mon))

    with open('../Data/Zone/wishmaker_cave.json', 'r', encoding='utf-8-sig') as file:
        data = json.load(file)

    data['Object']['Segments'][0]["ZoneSteps"][4]["Spawns"] = result

    data['Object']['Segments'][0]["ZoneSteps"][5]["Mobs"] = monster_house_result

    data['Object']['Segments'][0]["ZoneSteps"][6]["Mobs"] = monster_house_result

    data['Object']['Segments'][0]["ZoneSteps"][7]["Mobs"] = monster_house_result

    with open('../Data/Zone/wishmaker_cave.json', 'w') as file:
        json.dump(data, file, indent=2)

    csv_filename = 'encounters.csv'
    with open(csv_filename, mode='w', newline='') as csv_file:
        csv_writer = csv.writer(csv_file)
        csv_writer.writerow(["Name", "Tactic", "Ablity", "Move 1", "Move 2",
                            "Move 3", "Move 4", "Min Lev", "Max Lev", "Min Floor", "Max Floor", "Role", "Rate"])
        for row in mons:
            while len(row[3]) != 4:
                row[3].append("")
            csv_writer.writerow(
                [row[0], row[1], row[2], *row[3], row[4], row[5], row[6] + 1, row[7] + 1, roles_arr[row[8]], row[9]])