-- [dungeon_builder] scène canonique PMD Red — scène d07p02 (end).
--[[ d07p02 — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d07p02.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D07P02_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : scène de fin / arène du donjon (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local d07p02 = {}

local SCENE = 'd07p02'
-- Séquence canonique, dans l'ordre du script de la ROM
-- (RESERVE/red_cinematics/d07p02.cif.json).
local EVENTS = {
  {t='bgm', track='In the Depths of the Pit'},
  {t='bgm_fade', frames=60},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D07P02_001'},
  {t='anim', id='5'},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D07P02_002'},
  {t='msg', key='SCENE_D07P02_003'},
  {t='msg', key='SCENE_D07P02_004'},
  {t='msg', key='SCENE_D07P02_005'},
  {t='msg', key='SCENE_D07P02_006'},
  {t='msg', key='SCENE_D07P02_007'},
  {t='msg', key='SCENE_D07P02_008'},
  {t='msg', key='SCENE_D07P02_009'},
  {t='msg', key='SCENE_D07P02_010'},
  {t='msg', key='SCENE_D07P02_011'},
  {t='msg', key='SCENE_D07P02_012'},
  {t='msg', key='SCENE_D07P02_013'},
  {t='msg', key='SCENE_D07P02_014'},
  {t='msg', key='SCENE_D07P02_015'},
  {t='msg', key='SCENE_D07P02_016'},
  {t='msg', key='SCENE_D07P02_017'},
  {t='msg', key='SCENE_D07P02_018'},
  {t='msg', key='SCENE_D07P02_019'},
  {t='msg', key='SCENE_D07P02_020'},
  {t='msg', key='SCENE_D07P02_021'},
  {t='msg', key='SCENE_D07P02_022'},
  {t='anim', id='2'},
  {t='anim', id='9'},
  {t='anim', id='2'},
  {t='bgm', track='In the Depths of the Pit'},
  {t='camera', action='INIT_PAN'},
  {t='camera', action='PAN'},
  {t='camera', action='PAN'},
  {t='camera', action='PAN'},
  {t='camera', action='PAN'},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D07P02_023'},
  {t='msg', key='SCENE_D07P02_024'},
  {t='msg', key='SCENE_D07P02_025'},
  {t='msg', key='SCENE_D07P02_026'},
  {t='msg', key='SCENE_D07P02_027'},
  {t='msg', key='SCENE_D07P02_028'},
  {t='msg', key='SCENE_D07P02_029'},
  {t='msg', key='SCENE_D07P02_030'},
  {t='msg', key='SCENE_D07P02_031'},
  {t='msg', key='SCENE_D07P02_032'},
  {t='msg', key='SCENE_D07P02_033'},
  {t='msg', key='SCENE_D07P02_034'},
  {t='msg', key='SCENE_D07P02_035'},
  {t='msg', key='SCENE_D07P02_036'},
  {t='msg', key='SCENE_D07P02_037'},
  {t='msg', key='SCENE_D07P02_038'},
  {t='msg', key='SCENE_D07P02_039'},
  {t='msg', key='SCENE_D07P02_040'},
  {t='msg', key='SCENE_D07P02_041'},
  {t='msg', key='SCENE_D07P02_042'},
  {t='msg', key='SCENE_D07P02_043'},
  {t='msg', key='SCENE_D07P02_044'},
  {t='msg', key='SCENE_D07P02_045'},
  {t='msg', key='SCENE_D07P02_046'},
  {t='msg', key='SCENE_D07P02_047'},
  {t='msg', key='SCENE_D07P02_048'},
  {t='msg', key='SCENE_D07P02_049'},
  {t='msg', key='SCENE_D07P02_050'},
  {t='msg', key='SCENE_D07P02_051'},
  {t='msg', key='SCENE_D07P02_052'},
  {t='msg', key='SCENE_D07P02_053'},
  {t='msg', key='SCENE_D07P02_054'},
  {t='msg', key='SCENE_D07P02_055'},
  {t='msg', key='SCENE_D07P02_056'},
  {t='msg', key='SCENE_D07P02_057'},
  {t='msg', key='SCENE_D07P02_058'},
  {t='msg', key='SCENE_D07P02_059'},
  {t='bgm_fade', frames=30},
  {t='msg', key='SCENE_D07P02_060'},
  {t='msg', key='SCENE_D07P02_061'},
  {t='msg', key='SCENE_D07P02_062'},
  {t='msg', key='SCENE_D07P02_063'},
  {t='msg', key='SCENE_D07P02_064'},
  {t='msg', key='SCENE_D07P02_065'},
  {t='msg', key='SCENE_D07P02_066'},
  {t='msg', key='SCENE_D07P02_067'},
  {t='msg', key='SCENE_D07P02_068'},
  {t='msg', key='SCENE_D07P02_069'},
  {t='msg', key='SCENE_D07P02_070'},
  {t='msg', key='SCENE_D07P02_071'},
  {t='msg', key='SCENE_D07P02_072'},
  {t='msg', key='SCENE_D07P02_073'},
  {t='msg', key='SCENE_D07P02_074'},
  {t='msg', key='SCENE_D07P02_075'},
  {t='msg', key='SCENE_D07P02_076'},
  {t='msg', key='SCENE_D07P02_077'},
  {t='msg', key='SCENE_D07P02_078'},
  {t='msg', key='SCENE_D07P02_079'},
  {t='msg', key='SCENE_D07P02_080'},
  {t='msg', key='SCENE_D07P02_081'},
  {t='msg', key='SCENE_D07P02_082'},
  {t='msg', key='SCENE_D07P02_083'},
  {t='msg', key='SCENE_D07P02_084'},
  {t='msg', key='SCENE_D07P02_085'},
  {t='msg', key='SCENE_D07P02_086'},
  {t='msg', key='SCENE_D07P02_087'},
  {t='msg', key='SCENE_D07P02_088'},
  {t='msg', key='SCENE_D07P02_089'},
  {t='msg', key='SCENE_D07P02_090'},
  {t='msg', key='SCENE_D07P02_091'},
  {t='msg', key='SCENE_D07P02_092'},
  {t='msg', key='SCENE_D07P02_093'},
  {t='msg', key='SCENE_D07P02_094'},
  {t='msg', key='SCENE_D07P02_095'},
  {t='msg', key='SCENE_D07P02_096'},
  {t='msg', key='SCENE_D07P02_097'},
  {t='msg', key='SCENE_D07P02_098'},
  {t='bgm_fade', frames=150},
  {t='msg', key='SCENE_D07P02_099'},
  {t='msg', key='SCENE_D07P02_100'},
  {t='msg', key='SCENE_D07P02_101'},
  {t='anim', id='2'},
  {t='anim', id='9'},
  {t='anim', id='2'},
  {t='anim', id='9'},
  {t='anim', id='2'},
  {t='anim', id='9'},
  {t='anim', id='2'},
  {t='anim', id='9'},
  {t='anim', id='2'},
  {t='shake', frames=30},
  {t='anim', id='41'},
  {t='anim', id='2'},
  {t='shake', frames=30},
  {t='anim', id='2'},
  {t='shake', frames=30},
  {t='anim', id='2'},
  {t='shake', frames=30},
  {t='anim', id='2'},
  {t='anim', id='24'},
  {t='anim', id='2'},
  {t='anim', id='9'},
  {t='anim', id='2'},
  {t='anim', id='24'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='24'},
  {t='anim', id='2'},
}

function d07p02.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d07p02.Enter(map)
  DEBUG.EnableDbgCoro()
  -- See d05p02.Enter for the SV.CanonicalDungeons marker rationale.
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons['great_canyon'] = true
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, EVENTS)
  GAME:CutsceneMode(false)
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function d07p02.Update(map) end
function d07p02.GameSave(map) end
function d07p02.GameLoad(map)
  GAME:FadeIn(20)
end

return d07p02
