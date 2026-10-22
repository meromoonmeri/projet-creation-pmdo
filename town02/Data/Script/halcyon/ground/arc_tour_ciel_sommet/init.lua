-- [dungeon_builder] scène canonique PMD Red — scène d13p03 (end).
--[[ arc_tour_ciel_sommet — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d13p03.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D13P03_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : scène de fin / arène du donjon (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local arc_tour_ciel_sommet = {}

local SCENE = 'd13p03'
-- Séquence canonique, dans l'ordre du script de la ROM
-- (RESERVE/red_cinematics/d13p03.cif.json).
local EVENTS = {
  {t='bgm', track=''},
  {t='camera', action='INIT_PAN'},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D13P03_001'},
  {t='msg', key='SCENE_D13P03_002'},
  {t='shake', frames=30},
  {t='msg', key='SCENE_D13P03_003'},
  {t='msg', key='SCENE_D13P03_004'},
  {t='msg', key='SCENE_D13P03_005'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='9'},
  {t='anim', id='23'},
  {t='anim', id='22'},
  {t='anim', id='23'},
  {t='msg', key='SCENE_D13P03_006'},
  {t='anim', id='24'},
  {t='anim', id='25'},
  {t='anim', id='2'},
  {t='bgm', track=''},
  {t='camera', action='INIT_PAN'},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D13P03_007'},
  {t='msg', key='SCENE_D13P03_008'},
  {t='msg', key='SCENE_D13P03_009'},
  {t='msg', key='SCENE_D13P03_010'},
  {t='msg', key='SCENE_D13P03_011'},
  {t='msg', key='SCENE_D13P03_012'},
  {t='msg', key='SCENE_D13P03_013'},
  {t='msg', key='SCENE_D13P03_014'},
  {t='msg', key='SCENE_D13P03_015'},
  {t='msg', key='SCENE_D13P03_016'},
  {t='msg', key='SCENE_D13P03_017'},
  {t='bgm_fade', frames=120},
  {t='msg', key='SCENE_D13P03_018'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='shake', frames=30},
  {t='anim', id='2'},
  {t='anim', id='24'},
  {t='bgm', track=''},
  {t='bgm_fade', frames=60},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D13P03_019'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
}

function arc_tour_ciel_sommet.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function arc_tour_ciel_sommet.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, EVENTS)
  GAME:CutsceneMode(false)
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons['sky_tower_summit'] = true
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function arc_tour_ciel_sommet.Update(map) end
function arc_tour_ciel_sommet.GameSave(map) end
function arc_tour_ciel_sommet.GameLoad(map)
  GAME:FadeIn(20)
end

return arc_tour_ciel_sommet
