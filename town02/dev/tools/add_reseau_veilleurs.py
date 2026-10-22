#!/usr/bin/env python3
"""Réseau des Anciens Chemins — passe « Veilleurs » (2026-07-27).

Directive : les 34 zones add-on deviennent du contenu end-game structuré :
- 12 zones « histoire du Réseau » reçoivent un BOSS associé (« Veilleur »),
  arène dédiée (segment final), dialogues FR victoire/défaite dans ExitSegment ;
- 22 zones restent secondaires end-game (job board) ;
- restrictions fidèles pmd-red : Puits des Vœux Fossiles (Wish Cave, id 26)
  = reset de niveau + sac restreint, géré nativement par le moteur PMDC
  (LevelCap/BagRestrict/KeepSkills de la Zone) ;
- job board : les 34 zones entrent dans MISSION_GEN ;
- lore : chaque Veilleur est un gardien laissé par les bâtisseurs du Réseau,
  cohérent avec l'Éveil des Ancrages (Livre II).
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
import importlib
w3 = importlib.import_module('import_wave3_anchors')

# zone -> (arena_id, autotiles, musique, bosses[(species,nick,lvl,gender,intrinsic,skills)], lore_key)
VEILLEURS = {
 'new_era_zone_02': dict(arena='veilleur_pylone_arene', at=('mt_thunder_floor','mt_thunder_wall'),
    mus='Boss Battle!.ogg', lore='pylone',
    bosses=[('bastiodon','Rempart',12,0,'sturdy',[('iron_head',15),('taunt',20),('block',10),('take_down',20)])]),
 'new_era_zone_05': dict(arena='veilleur_antenne_arene', at=('lightning_field_floor','lightning_field_wall'),
    mus='Boss Battle!.ogg', lore='antenne',
    bosses=[('eelektross','Câble-Vif',18,0,'levitate',[('discharge',15),('crunch',15),('coil',20),('acid',30)])]),
 'new_era_zone_09': dict(arena='veilleur_reacteur_arene', at=('deep_dark_crater_floor','deep_dark_crater_wall'),
    mus='Boss Battle!.ogg', lore='reacteur',
    bosses=[('magmortar','Fusible',24,0,'flame_body',[('lava_plume',15),('smokescreen',20),('feint_attack',20),('confuse_ray',10)])]),
 'new_era_zone_11': dict(arena='veilleur_givre_arene', at=('frosty_forest_floor','frosty_forest_wall'),
    mus='Boss Battle!.ogg', lore='givre',
    bosses=[('abomasnow','Blizzard-Sentinelle',26,0,'snow_warning',[('wood_hammer',15),('icy_wind',15),('ingrain',20),('razor_leaf',25)])]),
 'new_era_zone_13': dict(arena='veilleur_zero_arene', at=('frosty_forest_floor','frosty_forest_wall'),
    mus='Boss Battle!.ogg', lore='zero',
    bosses=[('froslass','Voile-Blanc',28,1,'snow_cloak',[('ice_shard',30),('will_o_wisp',15),('draining_kiss',10),('double_team',15)]),
            ('glalie','Masque-Gel',28,0,'ice_body',[('ice_fang',15),('crunch',15),('protect',10),('icy_wind',15)])]),
 'new_era_zone_15': dict(arena='veilleur_fournaise_arene', at=('deep_dark_crater_floor','deep_dark_crater_wall'),
    mus='Boss Battle!.ogg', lore='fournaise',
    bosses=[('volcarona','Soleil-de-Cendre',32,1,'flame_body',[('fiery_dance',10),('quiver_dance',20),('bug_buzz',10),('gust',30)])]),
 'new_era_zone_17': dict(arena='veilleur_ciel_arene', at=('sky_tower_floor','sky_tower_wall'),
    mus='Boss Battle!.ogg', lore='ciel',
    bosses=[('salamence','Déchire-Nuages',36,0,'intimidate',[('dragon_claw',15),('dragon_dance',20),('zen_headbutt',15),('bite',25)])]),
 'new_era_zone_19': dict(arena='veilleur_tempete_arene', at=('stormy_sea_1_floor','stormy_sea_1_wall'),
    mus='Boss Battle!.ogg', lore='tempete',
    bosses=[('gyarados','Lame-de-Fond',40,0,'intimidate',[('aqua_tail',10),('dragon_dance',20),('crunch',15),('twister',20)])]),
 'new_era_zone_20': dict(arena='veilleur_abysse_arene', at=('silver_trench_3_floor','silver_trench_3_wall'),
    mus='Boss Battle!.ogg', lore='abysse',
    bosses=[('jellicent','Lanterne-Noyée',49,1,'water_absorb',[('water_spout',5),('hex',15),('recover',10),('whirlpool',15)]),
            ('dhelmise','Ancre-Morte',49,0,'steelworker',[('anchor_shot',15),('shadow_claw',15),('rapid_spin',30),('metal_sound',20)])]),
 'new_era_zone_23': dict(arena='veilleur_silence_arene', at=('western_cave_1_floor','western_cave_1_wall'),
    mus='Boss Battle!.ogg', lore='silence',
    bosses=[('dusknoir','Portier-du-Vide',54,0,'pressure',[('shadow_punch',20),('mean_look',5),('ice_punch',15),('confuse_ray',10)])]),
 'new_era_zone_27': dict(arena='veilleur_relique_arene', at=('buried_relic_1_floor','buried_relic_1_wall'),
    mus='Boss Battle!.ogg', lore='relique',
    bosses=[('golurk','Golem-Registre',50,0,'iron_fist',[('shadow_punch',20),('heavy_slam',10),('curse',10),('mega_punch',20)])]),
 'new_era_zone_32': dict(arena='veilleur_meridien_arene', at=('murky_cave_floor','murky_cave_wall'),
    mus='Boss Battle!.ogg', lore='meridien',
    bosses=[('krookodile','Mâchoire-du-Sud',46,0,'intimidate',[('earthquake',10),('crunch',15),('scary_face',20),('sand_attack',25)])]),
}

# dialogues FR victoire/défaite par Veilleur (partenaire = speaker)
LINES = {
 'pylone':   ("Le Rempart s'incline...[pause=20] le Pylône du Vieux Fer nous reconnaît.",
              "Ce Veilleur garde le Pylône depuis des siècles...[pause=20] Il faudra revenir plus forts."),
 'antenne':  ("Câble-Vif s'apaise.[pause=20] L'Antenne cesse de gronder... pour l'instant.",
              "La foudre de l'Antenne nous dépasse encore..."),
 'reacteur': ("Fusible s'éteint doucement.[pause=20] La Cheminée retrouve un souffle régulier.",
              "Trop chaud...[pause=20] le Réacteur Rouge ne veut pas encore de nous."),
 'givre':    ("Blizzard-Sentinelle range sa tempête.[pause=20] Le Givre Statique se calme.",
              "Le froid nous a mordus jusqu'aux os...[pause=20] Repartons nous préparer."),
 'zero':     ("Les deux masques de glace se dissipent.[pause=20] L'Aiguille nous laisse passer.",
              "Voile-Blanc et Masque-Gel veillent toujours...[pause=20] Le Zéro Absolu attendra."),
 'fournaise':("Soleil-de-Cendre replie ses ailes.[pause=20] Le cœur de la Fournaise-Mère bat plus doucement.",
              "Ses ailes de braise nous ont repoussés...[pause=20] La Fournaise garde son secret."),
 'ciel':     ("Déchire-Nuages remonte vers les hauteurs.[pause=20] La Tour du Ciel Fracturé est à nous.",
              "Le ciel de la Tour est à lui...[pause=20] pas encore à nous."),
 'tempete':  ("Lame-de-Fond replonge.[pause=20] La Mer des Tempêtes s'ouvre enfin.",
              "La mer nous a recrachés...[pause=20] Cette tempête n'a pas dit son dernier mot."),
 'abysse':   ("La Lanterne s'éteint, l'Ancre se pose.[pause=20] La Fosse d'Argent nous accepte.",
              "Deux Veilleurs, une seule nuit sans fond...[pause=20] Remontons."),
 'silence':  ("Le Portier-du-Vide s'écarte.[pause=20] Étrange...[pause=10] il semblait presque nous ATTENDRE.",
              "Ce silence...[pause=20] il nous a engloutis. Le Portier garde bien sa caverne."),
 'relique':  ("Le Golem-Registre retourne à son socle.[pause=20] La Relique Ensevelie livre ses salles.",
              "Le Golem ne dort jamais...[pause=20] La Relique reste scellée."),
 'meridien': ("Mâchoire-du-Sud desserre son étreinte.[pause=20] Le Méridien Sud est franchi.",
              "Ses crocs ont eu raison de nous...[pause=20] Le Sud se mérite."),
}

def load(p): return json.load(open(p, encoding='utf-8-sig'))
def save(p, d):
    with io.open(p, 'w', encoding='utf-8-sig') as f:
        json.dump(d, f, ensure_ascii=False, indent=2)

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

if __name__ == '__main__':
    zones = json.load(open('/tmp/wave5_zones.json'))
    zmeta = {z: (nfr, n1, n2, lv) for z, nfr, n1, n2, lv in zones}
    idx = load('Data/Zone/index.idx')
    boss_report = []
    for zid, cfg in VEILLEURS.items():
        nfr, n1, n2, lv = zmeta[zid]
        # 1. arène
        acfg = dict(arena=cfg['arena'], arena_at=cfg['at'], arena_music=cfg['mus'],
                    bosses=cfg['bosses'], ch=0, lz_name=(nfr, nfr))
        w3.build_arena(acfg)
        # 2. segment final
        p = f'Data/Zone/{zid}.json'
        d = load(p)
        S = find_segs(d['Object'])
        S.append(w3.arena_segment(acfg))
        seg_id = len(S) - 1
        save(p, d)
        # 3. index : +1 étage
        e = idx['Object'][zid]
        e['CountedFloors'] = e['CountedFloors'] + 1
        e['Maps'] = e['Maps'] + [[0]]
        # 4. script : routage arène + dialogues FR
        sp = f'Data/Script/halcyon/zone/{zid}/init.lua'
        s = open(sp, encoding='utf-8').read()
        win, lose = LINES[cfg['lore']]
        prev_seg = 1 if n2 else 0
        block = f'''
  -- Veilleur du Réseau : segment {seg_id} = arène ({'/'.join(b[0] for b in cfg['bosses'])}).
  if segmentID == {prev_seg} and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:ContinueDungeon("{zid}", {seg_id}, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end
  if segmentID == {seg_id} then
    if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
      if SV.Reseau == nil then SV.Reseau = {{ Veilleurs = {{}} }} end
      if SV.Reseau.Veilleurs == nil then SV.Reseau.Veilleurs = {{}} end
      SV.Reseau.Veilleurs['{zid}'] = true
      GAME:WaitFrames(20)
      UI:SetSpeaker(GAME:GetPlayerPartyMember(1))
      UI:SetSpeakerEmotion("Happy")
      UI:WaitShowDialogue("{win}")
    else
      GAME:WaitFrames(20)
      UI:SetSpeaker(GAME:GetPlayerPartyMember(1))
      UI:SetSpeakerEmotion("Sad")
      UI:WaitShowDialogue("{lose}")
    end
    GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
    return
  end
'''
        anchor = '  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)'
        assert anchor in s, zid
        s = s.replace(anchor, block + anchor, 1)
        open(sp, 'w', encoding='utf-8').write(s)
        boss_report.append((zid, nfr, cfg['bosses'], seg_id))
        print(f'{zid}: Veilleur {"/".join(b[1] for b in cfg["bosses"])} seg={seg_id}')

    # 5. restrictions fidèles : Puits des Vœux Fossiles (Wish Cave) = reset niveau + sac
    p = 'Data/Zone/new_era_zone_26.json'
    d = load(p)
    o = d['Object']
    o['LevelCap'] = True
    o['Level'] = 5
    o['KeepSkills'] = False
    o['BagRestrict'] = 0
    o['TeamSize'] = 2
    save(p, d)
    e = idx['Object']['new_era_zone_26']
    e.update({'LevelCap': True, 'Level': 5, 'BagRestrict': 0, 'TeamSize': 2})
    print('new_era_zone_26 (Puits des Vœux Fossiles): reset niveau 5, sac vide, équipe de 2 — fidèle Wish Cave')

    save('Data/Zone/index.idx', idx)
    json.dump(boss_report, open('/tmp/wave5b_bosses.json', 'w'))
