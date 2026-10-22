-- [dungeon_builder] scène canonique PMD Red — scène d13p02 (relay).
--[[ arc_palier_celeste — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d13p02.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D13P02_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : relais de mi-parcours — aucun combat (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     Aucun boss ici : dans PMD Red les combats de gardien se jouent à la
     scène de fin du donjon ou dans le donjon lui-même.
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local arc_palier_celeste = {}

local SCENE = 'd13p02'
-- Séquence canonique, dans l'ordre du script de la ROM
-- (RESERVE/red_cinematics/d13p02.cif.json).
local EVENTS = {
  {t='bgm', track='Sky Tower'},
  {t='bgm_fade', frames=60},
  {t='bgm_fade', frames=30},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='bgm', track='Sky Tower'},
  {t='msg', key='SCENE_D13P02_001'},
  {t='msg', key='SCENE_D13P02_002'},
}

function arc_palier_celeste.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function arc_palier_celeste.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, EVENTS)
  GAME:CutsceneMode(false)
  GAME:FadeOut(false, 30)
  GAME:EnterDungeon('sky_tower_summit', 0, 0, 0,
    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function arc_palier_celeste.Update(map) end
function arc_palier_celeste.GameSave(map) end
function arc_palier_celeste.GameLoad(map)
  GAME:FadeIn(20)
end

return arc_palier_celeste
