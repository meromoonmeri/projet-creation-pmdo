-- [dungeon_builder] scène canonique PMD Red — scène d05p02 (end).
--[[ d05p02 — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d05p02.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D05P02_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : scène de fin / arène du donjon (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local d05p02 = {}

local SCENE = 'd05p02'
-- Séquence canonique, dans l'ordre du script de la ROM
-- (RESERVE/red_cinematics/d05p02.cif.json).
local EVENTS = {
  {t='bgm', track='In the Depths of the Pit'},
  {t='bgm_fade', frames=60},
  {t='camera', action='INIT_PAN'},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D05P02_001'},
  {t='msg', key='SCENE_D05P02_002'},
  {t='msg', key='SCENE_D05P02_003'},
  {t='msg', key='SCENE_D05P02_004'},
  {t='msg', key='SCENE_D05P02_005'},
  {t='msg', key='SCENE_D05P02_006'},
  {t='msg', key='SCENE_D05P02_007'},
  {t='msg', key='SCENE_D05P02_008'},
  {t='msg', key='SCENE_D05P02_009'},
  {t='msg', key='SCENE_D05P02_010'},
  {t='msg', key='SCENE_D05P02_011'},
  {t='msg', key='SCENE_D05P02_012'},
  {t='msg', key='SCENE_D05P02_013'},
  {t='msg', key='SCENE_D05P02_014'},
  {t='msg', key='SCENE_D05P02_015'},
  {t='msg', key='SCENE_D05P02_016'},
  {t='msg', key='SCENE_D05P02_017'},
  {t='msg', key='SCENE_D05P02_018'},
  {t='msg', key='SCENE_D05P02_019'},
  {t='msg', key='SCENE_D05P02_020'},
  {t='bgm', track='Rising Fear'},
  {t='msg', key='SCENE_D05P02_021'},
  {t='msg', key='SCENE_D05P02_022'},
  {t='msg', key='SCENE_D05P02_023'},
  {t='msg', key='SCENE_D05P02_024'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='9'},
  {t='anim', id='5'},
  {t='anim', id='2'},
  {t='anim', id='22'},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D05P02_025'},
}

function d05p02.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d05p02.Enter(map)
  DEBUG.EnableDbgCoro()
  -- Set the canonical-scene marker BEFORE the cinematic and the transition:
  -- the marker is what any external validator (headless or in-game route
  -- probe) reads from SV.CanonicalDungeons to detect that the canonical
  -- rescue scene actually played. It must be set even if EndDungeonRun
  -- transitions away from this Ground before OnGroundMapEnter fires.
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons['silent_chasm'] = true
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, EVENTS)
  GAME:CutsceneMode(false)
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function d05p02.Update(map) end
function d05p02.GameSave(map) end
function d05p02.GameLoad(map)
  GAME:FadeIn(20)
end

return d05p02
