-- [dungeon_builder] scène canonique PMD Red — scène d09p01 (entrance).
--[[ mont_cendre_pied — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d09p01.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D09P01_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : entrée du donjon — aucun combat (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     Aucun boss ici : dans PMD Red les combats de gardien se jouent à la
     scène de fin du donjon ou dans le donjon lui-même.
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local mont_cendre_pied = {}

local SCENE = 'd09p01'
-- Séquence canonique, dans l'ordre du script de la ROM
-- (RESERVE/red_cinematics/d09p01.cif.json).
local EVENTS = {
  {t='bgm', track='Mt. Blaze'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D09P01_001'},
  {t='msg', key='SCENE_D09P01_002'},
  {t='msg', key='SCENE_D09P01_003'},
  {t='msg', key='SCENE_D09P01_004'},
  {t='msg', key='SCENE_D09P01_005'},
  {t='msg', key='SCENE_D09P01_006'},
  {t='msg', key='SCENE_D09P01_007'},
  {t='msg', key='SCENE_D09P01_008'},
  {t='bgm', track='Mt. Blaze'},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D09P01_009'},
  {t='msg', key='SCENE_D09P01_010'},
  {t='msg', key='SCENE_D09P01_011'},
  {t='msg', key='SCENE_D09P01_012'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D09P01_013'},
  {t='msg', key='SCENE_D09P01_014'},
  {t='msg', key='SCENE_D09P01_015'},
  {t='bgm_fade', frames=60},
  {t='bgm_fade', frames=60},
  {t='anim', id='2'},
  {t='bgm', track='Mt. Blaze'},
  {t='msg', key='SCENE_D09P01_016'},
  {t='msg', key='SCENE_D09P01_017'},
  {t='camera', action='PAN'},
  {t='msg', key='SCENE_D09P01_018'},
  {t='msg', key='SCENE_D09P01_019'},
  {t='msg', key='SCENE_D09P01_020'},
  {t='msg', key='SCENE_D09P01_021'},
  {t='msg', key='SCENE_D09P01_022'},
  {t='msg', key='SCENE_D09P01_023'},
  {t='msg', key='SCENE_D09P01_024'},
  {t='msg', key='SCENE_D09P01_025'},
  {t='msg', key='SCENE_D09P01_026'},
  {t='msg', key='SCENE_D09P01_027'},
  {t='msg', key='SCENE_D09P01_028'},
  {t='camera', action='PAN'},
  {t='bgm', track='Mt. Blaze'},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D09P01_029'},
  {t='msg', key='SCENE_D09P01_030'},
  {t='anim', id='2'},
  {t='bgm', track='Mt. Blaze'},
  {t='msg', key='SCENE_D09P01_031'},
  {t='msg', key='SCENE_D09P01_032'},
}

function mont_cendre_pied.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function mont_cendre_pied.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, EVENTS)
  GAME:CutsceneMode(false)
  GAME:FadeOut(false, 30)
  GAME:EnterDungeon('mt_blaze', 0, 0, 0,
    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function mont_cendre_pied.Update(map) end
function mont_cendre_pied.GameSave(map) end
function mont_cendre_pied.GameLoad(map)
  GAME:FadeIn(20)
end

return mont_cendre_pied
