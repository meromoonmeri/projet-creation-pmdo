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
from re import M

NORMAL = 0
SUPPORT = 1
LEADER = 2 
LONER = 3

roles_arr = ["Normal", "Support", "Leader", "Loner"]




# spheal,
# vulpix, ninetiles
 
# fire


# fighting

# zubat
# diglett, dugtrio
# psyduck, golduck
# growlithe
# poliwag, poliwhirl, poliwrath
# machop, machoke, machamp
# abra, kadabra, alakazam
# geodude, graveler, golem
# ponyta, rapidash
# slowpoke, slowbro, slowking
# seal, # dewgong
# sheldeer, cloyster
# horsea, seadra, kingdra
# staryu, starmie
# goldeen, seaking
# mr mime, mr rime
# jynx
# electabuzz, electivire
# magmar, magmortar
# tauros
# magikarp, gyarados
# lapras
# ditto
# eevee, vaporeon, jolteon, flareon, espeon, umbreon, leafeon, glaceon, sylveon
# omanyte, omastar
# cyndaquil, quilava, typhlosion
# hoothoot, noctowl
# sentret, furret
# chinchou, lanturn
# cleffa, clefairy, clefable
# togepi, togetic, togekiss
# natu xatu
# marill, azumarill
# mareep, flaaffy, ampharos
# sudowoodo
# aipom, ambipom
# wooper, quagsire
# espeon, umbreon
# murkrow, honchkrow
# misdreavus, mismagius
# wobbuffet
# girafarig
# dunsparce
# onix, steelix
# snubbull, granbull
# qwilfish, overqwil
# scizor
# shuckle
# sneasel, weavile (hisuan)
# teddiursa, ursaring
# slugma, magcargo
# swinub, piloswine, mamoswine
# corsola, corsola_galarian, coquillier
# remoraid, octillery
# delibird, skarmory
# phanpy, donphan
# stantler
# smeargle
# tyrogue, hitmonlee, hitmonchan, hitmontop
# smoochum
# chansey, blissey
# larvitar, pupitar, tyranitar
# torchic, combusken, blaziken
# mudkip, marshtomp, swampert
# zigzagoon, linoone, obstagoon
# poochyena, mightyena
# wailmer, wailord
# numel, camerupt
# tailow, swellow
# ralts, kirlia, gardevoir, gallade
# surskit, masquereain
# slakoth, vigoroth, slaking
# nincada, ninjask, shedinja
# whismur, loudred, exploud
# makuhita, hariyama
# nosepass, probopass
# skitty, delcatty
# sableye
# mawile
# aron, lairon, aggron
# meditite, medicham
# electrike, manectric
# plusle, minun
# gulpin, swalot
# trapinch, vibrava, flygon
# swablu, altaria
# zangoose, seviper
# lunatone, solrock
# barboach, whiscash
# corphish, crawdaunt
# baltoy, claydol
# lileep, cradily
# anorith, armaldo
# castform
# kecleon
# shuppet, banette
# duskull, dusclops, dusknoir
# snorunt, glalie, froslass
# spheal, sealeo, walrein
# clamperl, huntail, gorebyss
# relicanth
# chimchar, monferno, infernape
# piplup, prinplup, empoleon
# starly, staravia, staraptor
# bidoof, bibarel
# kricketot, kricketune
# shinx, luxio, luxray
# cranidos, rampardos
# shieldon, bastiodon
# buizel, floatzel
# pachirisu
# drifloon, driftblim
# shellos, gastrodon
# misdreavus, mismagius
# glameow, purugly
# bronzor, bronzong
# spiritomb
# gible, gabite, garchomp
# munchlax, snorlax
# riolu, lucario
# finneon, lumineon
# mantyke, mantine
# snover, abomasnow
# magnemite, magneton, magnezone
# rotom
# emboar
# patrat, watchog
# lillipup, herdier, stoutland
# purrloin, liepard
# pansear, simisear
# panpour, simipour
# blitzle, zebstrika
# roggenrola, boldore, gigalith
# drilbur, excadrill
# timburr, gurdurr, conkeldurr
# throh, sawk
# darumaka, darmanitan
# dwebble, crustle
# yamask, cofagrigus
# tirtouga, carracosta
# zorua, zoroark
# solosis, duosion, reuniclus
# vanillite, vanillish, vanilluxe
# dearling 
# frilLish, jellicent
# elgyem, beheeyem
# axew, fraxure, haxorus
# cubchoo, beartic
# mienfoo, mienshao
# druddigon
# golett, golurk
# bouffalant
# heatmor, durant
# deinos, zweilous, hydreigon
# larvesta, volcarona
# bunnelby, diggersby
# litleo, pyroar
# furfrou
# espurr, meowstic
# honedge, doublade, aegislash
# skrelp, dragalge
# clauncher, clawitzer
# tyrunt, tyrantrum
# amaura, aurorus
# hawlucha
# dedenne
# carbink
# goomy, sliggoo, goodra
# bergmite, avalugg
# litten, torracat, incineroar
# crabrawler, crabominable
# rockruff, lycanroc
# salandit, salazzle
# koffing, weezing
# Turtonator 	Turtonator
# drampa
# jangmo-o, hakamo-o, kommo-o
# Skwovet 	Skwovet, Greedent
# rookie, corvisquire, corviknight
# nickit, thievul
# wooloo, dubwool
# Chewtle 	Chewtle, Drednaw
# Yamper 	Yamper
# rolycoly, carkol, coalossal
# Mr. Rime
# snom, frosmoth
# eiscue, 
# indeedee

#Dracozolt 	Dracozolt

#0881 	Arctozolt 	Arctozolt

#0882 	Dracovish 	Dracovish

#0883 	Arctovish 	Arctovish

# Duraludon 	Duraludon, Arc
# dreepy, drakloak, dragapult	
# wydeer, kleavor, urshifu, basculin, sableye_hisuan, braviary_hisuan
# ursaluna, basculegion, enamorus
# sneasler
# nacli, naclstack, garganacl
# charcadet, armarouge, ceruledge
# wiglett, wugtrio
# tinkatink, tinkatuff, tinkaton
# finizen, palafin
# glimnira
# cetoddle, cetitan
# annihilape
# clodsire
# kingambit


# ["Name", "Tactic", "Ablity", "Move 1", "Move 2",
#                             "Move 3", "Move 4", "Min Lev", "Max Lev", "Min Floor", "Max Floor", "Role", "Rate"]
if __name__ == "__main__":


    # cynda - ember
# rowlet - leafage
# oshawott - water gun
# eevee - tickle, tackle
# pikachu - thunder shock, quick attack
# munchlax - sleeping, snore, body slam
# budew - absorb, poison sting
# psychduck - confusion, water gun, Amnesia
# buizel - sonicboom waterspart, soak
# chimxhar - counter, double kick, flame wheel
# starly - wing attack, quick attack
# bidoof - super-fang, tackle
# Machop - 	Karate Chop, focus-enery
# paras
# shinx
# cherubi
# happiny
# ponyta




# eevee, crobat, burmy, wormadam, golem, snorlax, parasect, raichu, infernape (personal one), golduck, combee, vespiquen, scizor, heracross, aipom, ambipom, shellos, gastrodon, blissey, togepi, togetic, togekiss, machamp 
# bidoof, starly, shinx, drifloon, kirketo, stantler, geodude, chimca, lopunny, munchlax, scyther, ponyta, rapiddash, metamod, eevee
# ice, floatzel




    mons = [

        # PikachuPikachu
        # RaichuRaichu
        # ZubatZubat
        # GolbatGolbat
        # ParasParas
        # ParasectParasect
        # PsyduckPsyduck
        # GolduckGolduck
        # AbraAbra
        # KadabraKadabra
        # AlakazamAlakazam
        # MachopMachop
        # MachokeMachoke
        # GeodudeGeodude
        # GravelerGraveler
        # GolemGolem
        # PonytaPonyta
        # RapidashRapidash
        # HaunterHaunter
        # GengarGengar
        # OnixOnix
        # LickitungLickitung
        # ChanseyChansey
        # Mr. MimeMr. Mime
        # ScytherScyther
        # MagikarpMagikarp
        # GyaradosGyarados
        # EeveeEevee
        # SnorlaxSnorlax
        # CrobatCrobat
        # PichuPichu
        # AipomAipom
        # UnownUnown
        # SteelixSteelix
        # QwilfishQwilfish
        # HeracrossHeracross
        # SneaselSneasel
        # UrsaringUrsaring
        # StantlerStantler
        # BlisseyBlissey
        # WurmpleWurmple
        # SilcoonSilcoon
        # BeautiflyBeautifly
        # CascoonCascoon
        # DustoxDustox
        # SphealSpheal
        # SealeoSealeo
        # ChimcharChimchar
        # MonfernoMonferno
        # InfernapeInfernape
        # StarlyStarly
        # StaraviaStaravia
        # StaraptorStaraptor
        # BidoofBidoof
        # BibarelBibarel
        # KricketotKricketot
        # KricketuneKricketune
        # ShinxShinx
        # LuxioLuxio
        # LuxrayLuxray
        # BurmyBurmy
        # WormadamWormadam
        # MothimMothim
        # CombeeCombee
        # VespiquenVespiquen
        # BuizelBuizel
        # FloatzelFloatzel
        # CherubiCherubi
        # CherrimCherrim
        # ShellosShellos
        # GastrodonGastrodon
        # DrifloonDrifloon
        # DrifblimDrifblim
        # BunearyBuneary
        # LopunnyLopunny
        # Mime Jr.Mime Jr.
        # HappinyHappiny
        # ChatotChatot
        # MunchlaxMunchlax
        # ToxicroakToxicroak
        # WeavileWeavile
        # LickilickyLickilicky
        # TogekissTogekiss
        # LeafeonLeafeon
        # MespritMesprit
        # ShayminShaymin
        # ZoruaZorua
        # ZoroarkZoroark
        # LandorusLandorus
        # SylveonSylveon
        # WyrdeerWyrdeer
        # KleavorKleavor
        #1
        ('buneary', 0, 'wander_normal', '', ['double_hit', 'foresight'], 4, 5, 0, 3, 0, 10),
        ('shinx', 0, 'wander_normal', '', ['howl', 'tackle'], 4, 5, 0, 3, LONER, 10),
        ('starly', 0, 'wander_dumb', '', ['tackle', 'sand_attack'], 4, 5, 0, 3, 0, 10),


        #2
        ('psyduck', 0, 'weird_tree', '', ['water_pulse', 'flip_turn'], 8, 9, 1, 5, 0, 6),
        ('bidoof', 0, 'wander_normal', '', ['super_fang', 'tackle'], 6, 7, 1, 5, 0, 10),
        ('paras', 0, 'retreater', '', ['leech_seed', 'poison_powder'], 6, 7, 1, 5, SUPPORT, 10),
        ('burmy', 0, 'wait_attack', '', ['bug_bite', 'poison_sting'], 6, 7, 1, 5, 0, 5),
        ('budew', 0, 'wander_normal', '', ['nature_power'], 5, 6, 1, 3, 0, 10),

        #3
        ('machop', 0, 'wander_normal', '', ['focus_energy', 'low_kick'], 7, 8, 2, 5, LONER, 10),
        ('geodude', 0, 'patrol', '', ['rollout', 'tackle'], 7, 8, 2, 5, 0, 10),
        ('eevee', 0, 'wander_normal', '', ['tickle', 'quick_attack'], 7, 9, 1, 5, 0, 10),

        #4 
 
        ('silcoon', 0, 'wait_attack', '', ['bug_bite', 'poison_sting'], 9, 10, 3, 5, 0, 4),
        ('cascoon', 0, 'wait_attack', '', ['bug_bite', 'string_shot'], 9, 10, 3, 5, 0, 4),
        ('cyndaquil', 0, 'wander_normal', '', ['ember', 'smokescreen'], 9, 10, 3, 5, 0, 10),
        ('oshawott', 0, 'wander_normal', '', ['water_gun', 'encore'], 9, 10, 3, 5, 0, 10),
        ('rowlet', 0, 'wander_normal', '', ['leafage', 'dual_wingbeat'], 9, 10, 3, 5, 0, 10),

        # 5
        # ('onix', 0, 'slow_wander_normal', '', ['block', 'smack_down'], 12, 13, 4, 5, 0, 10),
        ('pichu', 0, 'wander_normal', '', ['nuzzle', 'charm', 'fake_out'], 12, 13, 4, 5, SUPPORT, 10),
        ('buizel', 0, 'wander_normal', '', ['sonic_boom'], 10, 11, 4, 7, 0, 10),
        ('drifloon', 0, 'wander_normal', 'unburden', ['bind', 'night_shade'], 11, 12, 4, 7, NORMAL, 10),



        # Add like path wands + pounce wands on island
        # 6
        ('pancham', 0, 'wander_normal', 'mold_breaker', ['taunt', 'circle_throw'], 12, 13, 5, 7, 0, 10),
        ('meowth', 1, 'thief', '', ['pay_day', 'fury_swipes'], 11, 12, 5, 7, 0, 10),
        ('diglett', 1, 'wander_normal', 'tangling_hair', ['bulldoze', 'sucker_punch'], 10, 11, 5, 8, 0, 10),
        ('corsola', 0, 'wander_normal', 'natural_cure', ['aqua_ring', 'amnesia', 'icicle_spear'], 11, 12, 5, 7, SUPPORT, 10),
        ('shellos', 0, 'wander_normal', 'storm_drain', ['mud_sport', 'water_pulse'], 12, 13, 5, 7, 0, 10),       
        ('krabby', 0, 'wander_normal', '', ['bubble_beam'], 10, 11, 5, 7, 0, 10),
        ('corphish', 0, 'wander_normal', '', ['knock_off', 'fling', 'harden'], 11, 12, 5, 7, 0, 10),

        #7
        ('rattata', 1, 'retreater', 'hustle', ['screech', 'sucker_punch'], 12, 13, 6, 8, 0, 10),
        ('vulpix', 1, 'wander_normal', 'snow_cloak', ['nasty_plot', 'dazzling_gleam'], 11, 12, 6, 7, 0, 10),
        ('geodude', 1, 'wander_normal', 'galvanize', ['rock_climb'], 11, 12, 6, 8, 0, 10),
        ('grimer', 1, 'retreater_item', 'stench', ['assurance', 'clear_smog'], 12, 13, 6, 8, 0, 10),
        ('staryu', 0, 'wander_normal', 'illuminate', ['confuse_ray', 'light_screen', 'water_gun'], 13, 14, 6, 8, SUPPORT, 10),

        #8
        # ('horsea', 0, 'wander_normal', 'swift_swim', ['twister', 'dragon_rage'], 14, 15, 7, 9, 0, 10),
        ('dratini', 0, 'wander_smart', 'shed_skin', ['twister', 'dragon_rage'], 14, 15, 7, 9, 0, 10),
        # ('wimpod', 0, 'fleeing', '', ["sand_attack", "struggle_bug"], 15, 16, 7, 8, 0, 10),
        ('dwebble', 0, 'retreater', 'sturdy', ['rock_tomb', 'bug_bite'], 13, 14, 7, 9, 0, 10),
        ('anorith', 0, 'wander_normal', 'swift_swim', ['stealth_rock', 'ancient_power'], 12, 13, 7, 9, 0, 10),
        ('wailmer', 0, 'wander_normal', 'pressure', ['rest', 'amnesia', 'growl', 'round'], 14, 15, 7, 10, SUPPORT, 10),
        ('mareanie', 0, 'wander_normal', '', ['wide_guard', 'toxic_spikes', 'pounce'], 15, 16, 7, 10, SUPPORT, 10),
    
        #9
        ('quaxwell', 0, 'wander_normal', 'torrent', ['water_pledge', 'detect'], 16, 17, 8, 10, SUPPORT, 6),
        ('scyther', 0, 'wander_normal', 'technician', ['agility', 'false_swipe'], 19, 20, 8, 10, LONER, 10),
        ('sandygast', 0, 'wander_normal', 'water_compaction', ['destiny_bond', 'stockpile', 'swallow', 'spit_up'], 19, 20, 8, 10, NORMAL, 10),
        ('tatsugiri', 0, 'wander_smart', '', ['whirlpool'], 16, 17, 8, 10, SUPPORT, 10),
        ('krabby', 0, 'wander_normal', 'hyper_cutter', ['bubble_beam'], 17, 18, 8, 10, 0, 10),

        #10
        ('croconaw', 0, 'wander_normal', 'sheer_force', ['waterfall'], 18, 19, 9, 10, LONER, 10),
        ('bruxish', 0, 'wander_normal', 'dazzling', ['aqua_jet', 'psychic_fangs'], 19, 20, 9, 10, SUPPORT, 10),

      
        # 11
        ('geodude', 0, 'patrol', '', ['wide_guard', 'rock_blast'], 20, 21, 10, 13, NORMAL, 10),
        ('aron', 0, 'wander_normal', '', ['protect', 'rock_tomb', 'screech'], 20, 21, 10, 12, NORMAL, 10),
        ('sandile', 0, 'wander_normal', 'intimidate', ['dig', 'scary_face'], 20, 21, 10, 12, NORMAL, 10),

        ('cubone', 0, 'wander_normal', '', ['bonemerang', 'smack_down'], 20, 21, 10, 12, NORMAL, 10),
        ('nacli', 0, 'wait_attack', 'purifying_salt', ['salt_cure'], 22, 23, 10, 12, NORMAL, 10),
        # ('naclstack', 0, 'wait_attack', 'purifying_salt', ['salt_cure'], 25, 26, 9, 10, NORMAL, 10),


        #12
        ('shuckle', 0, 'wander_normal', 'contrary', ['shell_smash', 'infestation'], 19, 20, 11, 13, LONER, 10),
        ('glimmet', 0, 'wander_normal', 'toxic_debris', ['toxic', 'venoshock'], 20, 21, 11, 13, NORMAL, 10),
        ('natu', 0, 'wander_normal', 'magic_guard', ['future_sight', 'teleport'], 21, 22, 11, 13, NORMAL, 10),
        ('sigilyph', 0, 'wander_normal', 'magic_guard', ['ancient_power', 'psybeam', 'roost'], 21, 22, 11, 14, NORMAL, 10),


        # 13
        ('audino', 0, 'wander_normal', 'healer', ['heal_pulse', 'baton_pass', 'amnesia'], 21, 22, 12, 15, SUPPORT, 10),
        ('loudred', 0, 'wander_normal', 'soundproof', ['screech', 'round', 'supersonic'], 20, 21, 12, 14, NORMAL, 10),
        ('joltik', 0, 'wander_normal', 'unnerve', ['electroweb', 'gastro_acid', 'struggle_bug'], 23, 24, 12, 14, SUPPORT, 10),  
        ('golett', 0, 'wander_normal', 'iron_fist', ['shadow_punch', 'thunder_punch', 'ice_punch'], 22, 23, 12, 14, NORMAL, 10),
        ('binacle', 0, 'wander_normal', 'tough_claws', ['fling', 'razor_shell', 'x_scissor'], 22, 23, 12, 14, NORMAL, 10),



        #14
        ('druddigon', 0, 'wander_normal', 'rough_skin', ['glare', 'dragon_claw'], 22, 23, 13, 15, LONER, 10),
        ('herdier', 0, 'wander_normal', 'sand_rush', ['work_up', 'take_down'], 22, 23, 13, 15, NORMAL, 10),
        ('noibat', 0, 'wander_normal', 'infiltrator', ['supersonic', 'air_cutter', 'u_turn'], 24, 25, 13, 15, SUPPORT, 10),
        ('relicanth', 0, 'wander_normal', '', ['aqua_tail', 'rock_blast'], 23, 24, 9, 10, NORMAL, 10),




        #15
        ('donphan', 0, 'wander_normal', 'sand_veil', ['rollout', 'bulldoze'], 25, 26, 14, 15, LONER, 10),
        ('lycanroc', 0, 'wander_normal', 'sand_rush', ['quick_guard', 'accelerock', 'rock_throw'], 25, 26, 14, 15, LONER, 10),
        ('heliolisk', 0, 'wander_normal', 'sand_veil', ['parabola_charge'], 25, 26, 14, 15, NORMAL, 10),
        ('parasect', 0, 'wander_normal', '', ['spore', 'leech_life', 'leech_seed'], 24, 25, 14, 15, NORMAL, 10),
        ('lokix', 0, 'wander_normal', 'tinted_lens', ['first_impression', 'knock_off'], 25, 26, 9, 10, LONER, 10),






      
        # ('lopunny', 0, 'wander_normal', 'guts', ['cross_chop'], 19, 20, 9, 10, NORMAL, 10),
        # 16
        # ('snorunt', 0, 'wander_normal', 'snow_cloak', ['powder_snow'], 25, 20, 9, 10, NORMAL, 10),
        # ('castform', 0, 'retreater', 'forecast', ['weather_ball', 'double_team'], 25, 20, 9, 10, NORMAL, 10),
        # ('glalie', 0, 'wander_normal', 'ice_body', ['protect', 'explosion', 'icicle_crash'], 25, 20, 9, 10, LONER, 10),
        # ('froslass', 0, 'wander_normal', 'cursed_body', ['ice_beam', 'spite', 'destiny_bond'], 25, 20, 9, 10, NORMAL, 10),
        # # ('floatzel', 0, 'wander_normal', 'swift_swim', ['ice_fang', 'ice_shard'], 25, 20, 9, 10, NORMAL, 10),
        # ('dusclops', 0, 'wander_normal', 'pressure', ['curse', 'poltergeist'], 25, 20, 9, 10, LONER, 10),
        # ('sealeo', 0, 'wander_normal', 'ice_body', ['icy_wind', 'brine', 'rollout'], 25, 20, 9, 10, NORMAL, 10),
        # ('piloswine', 0, 'wander_normal', 'snow_cloak', ['bulldoze', 'take_down', 'ice_fang'], 25, 20, 9, 10, NORMAL, 10),
        # ('azumarill', 0, 'wander_normal', 'thick_fat', ['belly_drum', 'aqua_jet'], 25, 20, 9, 10, NORMAL, 10),
        
        # ('snorlax', 0, 'slow_wander_normal', 'gluttony', ['body_slam', 'yawn'], 25, 20, 9, 10, NORMAL, 10),
        # ('grumpig', 0, 'wander_normal', 'gluttony', ['body_slam', 'yawn'], 25, 20, 9, 10, NORMAL, 10),
        # ('miltank', 0, 'wander_normal', 'thick_fat', ['psybeam', 'charge_beam'], 25, 20, 9, 10, NORMAL, 10),
        # ('glaceon', 0, 'wander_normal', 'snow_cloak', ['haze', 'mirror_coat', 'icy_wind'], 25, 20, 9, 10, NORMAL, 10),
        # ('weavile', 0, 'retreater', 'pickpocket', ['night_slash', 'agility', 'ice_punch'], 25, 20, 9, 10, LONER, 10),
        # ('sneasel', 1, 'wander_normal', 'thief', ['taunt', 'thief', 'embargo'], 25, 20, 9, 10, LONER, 10),
        # ('sneasler', 0, 'wander_normal', 'unburdan', ['night_slash', 'agility', 'ice_punch'], 25, 20, 9, 10, LONER, 10),



        # ('heracross', 0, 'wander_normal', '', ['pouce', 'brick_break'], 25, 26, 9, 10, NORMAL, 10),
      
        # ('clefairy', 0, 'wander_normal', 'magic_coat', ['encore', 'dazzling_gleam', 'healing_wish'], 19, 20, 9, 10, SUPPORT, 10),


        # ('phantump', 0, 'wander_normal', '', ['forests_curse', 'night_shade'], 19, 20, 9, 10, LONER, 10),
        # ('tangela', 0, 'wander_normal', '', ['grass_knot', 'poison_powder', 'nature_power'], 19, 20, 9, 10, LONER, 10),

        # ('gligar', 0, 'wander_normal', 'sand_veil', ['acrobatics'], 17, 19, 9, 10, NORMAL, 10),


        # ('parasect', 0, 'wander_normal', '', ['spore', 'leech_life'], 20, 21, 9, 10, NORMAL, 10),

      
     


        # ('foongus', 0, 'wait_attack', '', ['spore', 'toxic', 'clear_smog'], 25, 26, 9, 10, NORMAL, 10),


        # ('tirtouga', 0, 'wander_normal', 'solid_rock', ['water_pulse', 'rock_blast'], 25, 26, 9, 10, NORMAL, 10),



        #16

        # ('skarmory', 0, 'wander_normal', '', ['pluck'], 25, 26, 9, 10, NORMAL, 10),
        # ('foongus', 0, 'wait_attack', 'overcoat', ['spore', 'toxic', 'clear_smog'], 25, 26, 9, 10, NORMAL, 10),
        # vullaby
        # ('orthworm', 0, 'wander_normal', 'sand_rush', ['quick_guard', 'accelerock', 'rock_throw'], 25, 26, 9, 10, NORMAL, 10),
        # ('onix', 0, 'wander_normal', 'study', ['wrap', ], 25, 26, 9, 10, NORMAL, 10),

                # ('lycanroc', 2, 'wander_normal', 'sand_rush', ['quick_guard', 'accelerock', 'crush_claw'], 25, 26, 9, 10, NORMAL, 10),        
        # noibat
        # ('dugtrio', 0, 'wander_normal', '', ['rollout', 'bulldoze'], 26, 27, 9, 10, NORMAL, 10),
        

        
        # medichan, hitmonelee, axe_kick

                # Sigilyph
        # ('aron', 0, 'wander_normal', '', ['protect', 'rock_tomb'], 19, 20, 9, 10, NORMAL, 10),
        # ()


        # natu - 

        # bosses
        # sand team
        # garchomp
        # gliscor
        # excadrill
        # stoutland
        # dugtrio
        # sandslash
        # sand veil sand force, sand rush



        # Cofagrigus - will_o_wisp, curse, shadow_ball, heal_block, grudge
        # krookodile
        # lucario - inner focus, bone_rush, swords_dance, close_combat, extreme_speed
        # espeon - magic_bounce, reflect, light_screen, morning_sun, future_sight
        # seviper - 
        # sableye - quash, mean_look_ punishment, torment
        # or


        # overcoat team
        # reunclis
        # mandizbuzz
        # Kommo-o
        # earthquake team
        # alakazam


        # mimikyu
        # joltik
        # carbink
        # shuckle
        # shieldon
        # aero
        # kabutops
        # cranidos
        # xatu
        # rockruff
        # nosepass
        # glimmet
        # stunfisk
        # toedscruel
        # amoongus

        # whismur
        # gloom
        # teddirusa
        # paras
        # diglett
        # cubone
        # rhyhorn
        # phanpy
        # drilbur
        # mudbray
        # sandrew
        # numel
        # cufant
        # onix
        # gligar
        # golette
        # cacnea
        # helioptile
        # skorupi
        # trapinch
        # orthworm
        # sigilyph
        # lileep
        # anorith
        # gible
        # hipppoptas
        # shelgon
        # clefable
        # duosian
        # varoom
        # vullaby
        # mawile
        # ghastly
        # bronzor
        # klink
        # beldum
        # elekid
        # woobat
        # misdreavus
        # magby
        # klefli
        # soloasis
        # tinkatonk
        # archen
        # lunatone
        # solrock
        # sudowoodo
        # wobbu
        # kadabra - magic guard
        # wormadam 
        # baltoy

        # ('salandit', 0, 'wander_smart', 'corrosion', ['flame_burst', 'toxic'], 19, 20, 9, 10, LONER, 10),
        # ('machoke', 0, 'wander_normal', 'guts', ['cross_chop'], 19, 20, 9, 10, NORMAL, 10),


        # 15 haze trap, ice trap
        # ('frost', 0, 'wander_normal', 'guts', ['cross_chop'], 19, 20, 9, 10, NORMAL, 10),
        

        # 20 haze trap, fire trap


        # vulpix and ninetales
        # salandit and salazzle
        

        # 25 haze trap, spore trap, heal trap, harsh winds, does the terrain shift each time ,lots of strucutures

        # farafarig, tinkaton, pawmot, gholdengo, cetitan, kilowattrel, belliboltm corviknight
        # bosses be paradox mons?
        # dragonite, # slowking
        # unown
        # skarmary
        # scizor
        # smeargle, with crazy move sets
        # tyanntior
        # slaking - hit's ally, or gets hit by an ally to swap abilites
        # aggron
        # shedninja
        # exploud
        # swalot
        # tropiis
        # altaria
        # salamence
        # metagross
        # lucario 
        # garcjomp
        # hatterene
        # togekiss
        # perrserker
        # eldegoss
        # rillaboom
        # floette eternal - light of ruins
        # cindarace
        # onteleon
        # toxcricity
        # grimmsnarl
        # morgrem
        # poltargeist tea
        # appletun
        # flapple
        # arcanine, both forms
        # gliscor
        # mamoswine
        # drapion
        # wigglytuff - perish song
        # gengar - perish song
        # marowak - peris h song
        # jynx - perish song
        # lapras - perish song
        # polietoed - perish song
        # altaria perish song
        # absol - perish song
        # kricketine - perish song
        # chimecho perish song
        # primarina perish song
        # murkrow - parish song
        # tile that disables weather for like x tun

        # hold_back
        # fairy lock
        # tiels that chabge the type like forest' scirse
        # golduck
        # froslass
        # gengae
        # rotom
        # lapras
        # dodrio muk
        # samurott, emboar
        # stoutland
        # ditto
        # mimikuyu
        # melemtal basses
        # tapus as bosses
        # ditto transformed as arceus as one of the bosses



        # Overcoat
        # Cryagonal, Dubwool, Greedent, Mr. Rime, Eiscue, Absol, Delibird, Cubchoo, Beartic, Spiritomb, mimikyu,
        #
        # hattrem, hatterene, clefable, magmorter, electabuzz. amaura, aurorus, bronzor, brazil, indeedee, mawile
        # tauros, fighting and water and fire, furret, ghost corsola, stantlr
        # gal darmanitan
        # zoroark, zoroark his
        # gothrita, 
        # slaking, shedninja, hariyama, banette, magnetzone, 
        # hisuan samurott,
        # watchog
        # escalvilar
        # jellicent
        # beheeyem
        # klang, klinklang
        # the ice creams
        # lapras vault
        # mienfoo, mienshao
        # Bouffalant 	Bouffalant
        # pawnyard, bisharp
        # mandibuzz, 
        # hisuan braviary
        # durant
        # diggersby
        # pangoro
        # meowstic
        # the sword mons
        # bergmite
        # dubwool
        # avalugg
        # salandit, salazzle
        # type null, silvally
        # minior
        # thievull
        # rockruff, lycanrok
        # drampa
        # crabdominable
        #20 
        # armarouge and ceruldge]
        # tinkatuff

# Cetoddle 	Cetoddle
# 	Ice
#0975 	Cetitan 	Cetitan
        #25



        # ('wal')
        # ('seadra', 0, 'wander_normal', 'thick_fat', ['curse', 'protect'], 25, 20, 9, 10, LONER, 10),

        # Swinub
        # Piloswine 
        # axumarill
        # floatzel 
        # frostlass
        # prinplup
        # 

        # 17
        # 18
        # 19
        # 20

        # 12
        # ('geodude', 0, 'patrol', '', ['tackle', 'rocks_slide'], 18, 19, 9, 10, NORMAL, 10),
        # ('druddigon', 0, 'wander_smart', '', ['glare', 'scale_shot'], 19, 20, 9, 10, LONER, 10),
        # ('graveler', 0, 'wander_normal', 'sheer_force', ['magnitude', 'rocks_slide'], 18, 19, 9, 10, NORMAL, 10),
        # ('salandit', 0, 'wander_smart', 'corrosion', ['flame_burst', 'toxic'], 19, 20, 9, 10, LONER, 10),
        # ('machoke', 0, 'wander_normal', 'guts', ['cross_chop'], 19, 20, 9, 10, NORMAL, 10),
        #15 - Harder hitting enemies - froslass, spite, poltergeist - no food, seeds,  on this floor!lm
        ## Wyrdeer 	Wyrdeer
        ## glalie - protect, frost_breath
        ## scizor - swords, iron_head
        # purserker
        # vanilite
        # https://pokemondb.net/ability/thick-fat - any mon with
        ## hariyama
        ## delibird - bestow 50% or 50% good ir bad item, maybe the bad item explodes on the leader in like 5 turns
        ## tricksters mon
        ## bascalibur 
        # luxio, chinchou
        



        #20 - Swarms of teamfire types + specifix teams! vulpix with nintales leader, salandit with siazzle leader, durant + heatmor
        # charizrd durant + zangoose versus seviper + heatmor


        #21
        # ('turtonator', 0, 'wander_normal', '', ['dragon_claw', 'dragon_rage'], 21, 22, 10, 12, 0, 10),
        #22
        #23
        #24
        #25 -  
        # turtonator





        # Rocks begin to fall from the dungeon!
        # https://theworldofpokemon.com/habitats/habitat_8.html
        # https://theworldofpokemon.com/HabitatPage.html
        # raticate
        # https://pokemondb.net/pokedex/raticate/moves/7

        # Rocks will fall from the ceiling!
        # 


        # aron, pineco, fortress, # skarmary




        #11

        #16






        # ('dwe', 1, 'fleeing', '', ["sand_attack", "struggle_bug"], 11, 12, 4, 5, LONER, 10),

        # ('marowak', 1, 'retreater', 'rock_head', ['bone_club', 'bone_rush'], 11, 12, 4, 5, LONER, 10),
        # ('raichu', 1, 'wander_normal', 'surge_surfer', ['spark', 'quick_attack'], 11, 12, 4, 5, 0, 10),
        # ('exeggcute', 1, 'wander_normal', 'harvest', ['leech_seed', 'stun_spore'], 11, 12, 4, 5, SUPPORT, 10),
        # ('marill', 1, 'wander_normal', 'thick_fat', ['bubble_beam', 'aqua_jet'], 11, 12, 4, 5, 0, 10),
        # ('wimpod', 1, 'retreater', '', ['aqua_jet', 'bug_bite'], 11, 12, 4, 5, LONER, 10),
        # ('sneasel', 1, 'wander_normal', 'inner_focus', ['ice_shard', 'feint_attack'], 11, 12, 4, 5, LONER, 10),
        # ('krokorok', 1, 'wander_smart', '', ['sand_attack', 'bite'], 11, 12, 4, 5, LONER, 10),

        # ('tirtouga', 1, 'wander_smart', '', ['water_gun', 'rock_throw'], 11, 12, 4, 5, LONER, 10),


        # ('sandyshrew', 1, 'retreater',
        # Have lots of berries in this area

        # ('oricorio', 0, 'wander_normal', '', ['feather_dance', 'quiver_dance', 'attract', 'teeter_dance'], 4, 5, 0, 3, SUPPORT, 10),

        # Have lots of iron balls in this area





        # mons standing on this target get range

        # Relicanth
        # corphish
        # Anorith
        # oricorio
        # alolan rat
        # alolan diglett
        # alolan geodude
        # alolan vulpix
        # alolan meowth
        # alolan grimer
        # eggxecute 
        # alolan eggxecute (sleeping)
        # alolan marow
        # alolan raichu (sleeping)
        # mareanie
        # wimpod
        # snease
        # pancham
        # krok (tototile evo)
        # Dwebble
        # quaxly
        # tirtouga
        # gimme
        # dratini
   
        # Tirtouga
        # tatsugiri


        #2
        # ('skitty', 0, 'wander_normal', 'wonder_skin', ['fake_out', 'copycat'], 10, 11, 0, 4, 0, 10),
        # ('cleffa', 0, 'wander_normal', 'friend_guard', ['covet', 'mimic'], 10, 11, 0, 3, 0, 10),
        
        # #2
        # ('ralts', 0, 'wander_normal', 'trace', ['disarming_voice', 'teleport'], 12, 13, 1, 4, 0, 10),
        # ('goomy', 0, 'wander_normal', '', ['water_gun', 'absorb'], 11, 12, 1, 4, 0, 10),
        # ('diglett', 0, 'wander_normal', 'arena_trap', ['astonish', 'sand_attack'], 12, 13, 1, 4, 0, 10),
        
        # #3
        # ('togepi', 0, 'wander_dumb', 'super_luck', ['metronome'], 14, 15, 2, 5, 0, 10),
        # ('hatenna', 0, 'wander_normal', 'healer', ['play_nice', 'life_dew'], 13, 14, 2, 6, SUPPORT, 10),
        # ('whismur', 0, 'wander_normal', 'rattled', ['echoed_voice', 'round'], 14, 15, 2, 6, 0, 10),
        
        # #4
        # ('zubat2', 0, 'wander_normal', '', ['poison_fang'], 14, 15, 3, 6, 0, 10),
        # ('houndour', 0, 'wander_normal', '', ['ember', 'leer', 'smog'], 14, 15, 3, 6, LONER, 10),
        # ('azurill', 0, 'wander_normal', 'thick_fat', ['charm', 'sing', 'bubble_beam'], 15, 16, 3, 5, 0, 10),
        
        # #5
        # ('noibat', 0, 'wander_normal', 'telepathy', ['double_team', 'gust'], 15, 16, 4, 7, LEADER, 10),
        # ('solosis', 0, 'wander_normal', 'magic_guard', ['confusion', 'reflect'], 15, 16, 4, 7, 0, 10),
        


        # 2
        # remoraid
        # octillary
        # shelder 
        # cloyster
        # carvanah fish
        # krabby
        # boss
        # heracross
        # scyther
        # gyrados
        

        # Tentacool

        # Bruxish

        # Corsola

        # Mareanie

        # Clamperl


        # Luvdisc

        # Pyumuku

        # Lapras

        # Qwilfish

        # Chinchou 
        #6
       
    ]

    def create_monster_house(mon_name, form):
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
                    },
                    {
                        "$type": "PMDC.LevelGen.MobSpawnLuaTable, PMDC",
                        "LuaTable": "{ EmberfrostRun = true }"
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
        struct = create_monster_house(mon_name, 0)
        monster_house_result.append(struct)

    def create_mon(mon):
        name, form, tactic, ability, moves, min_lev, max_lev, min_floor, max_floor, role, rate = mon[0], mon[1], mon[2], mon[3], mon[4], mon[5], mon[6], mon[7], mon[8], mon[9], mon[10]
        
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
                        },
                        {
                            "$type": "PMDC.LevelGen.MobSpawnLuaTable, PMDC",
                            "LuaTable": "{ EmberfrostRun = true }"
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
        min_lev = mon[5]
        if (min_lev < 60):
            result.append(create_mon(mon))

    with open('../Data/Zone/emberfrost_depths.json', 'r', encoding='utf-8-sig') as file:
        data = json.load(file)

    data['Object']['Segments'][1]["ZoneSteps"][4]["Spawns"] = result

    # data['Object']['Segments'][0]["ZoneSteps"][5]["Mobs"] = monster_house_result

    # data['Object']['Segments'][0]["ZoneSteps"][6]["Mobs"] = monster_house_result

    # data['Object']['Segments'][0]["ZoneSteps"][7]["Mobs"] = monster_house_result

    with open('../Data/Zone/emberfrost_depths.json', 'w') as file:
        json.dump(data, file, indent=2)

    csv_filename = 'emberfrost_encounters.csv'
    with open(csv_filename, mode='w', newline='') as csv_file:
        csv_writer = csv.writer(csv_file)
        csv_writer.writerow(["Name", "Form", "Tactic", "Ablity", "Move 1", "Move 2",
                            "Move 3", "Move 4", "Min Lev", "Max Lev", "Min Floor", "Max Floor", "Role", "Rate"])
        for row in mons:
            while len(row[4]) != 4:
                row[4].append("")
            csv_writer.writerow(
                [row[0], row[1], row[2], *row[3], row[4], row[5], row[6] + 1, row[7] + 1, row[8], roles_arr[row[9]], row[10]])