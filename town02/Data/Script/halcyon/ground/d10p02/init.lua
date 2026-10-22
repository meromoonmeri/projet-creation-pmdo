-- [dungeon_builder] scène canonique PMD Red — scène d10p02 (relay).
--[[ d10p02 — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d10p02.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D10P02_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : relais de mi-parcours — aucun combat (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     Aucun boss ici : dans PMD Red les combats de gardien se jouent à la
     scène de fin du donjon ou dans le donjon lui-même.
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local d10p02 = {}

local SCENE = 'd10p02'
-- Séquence canonique, dans l'ordre du script de la ROM
-- (RESERVE/red_cinematics/d10p02.cif.json).
local EVENTS = {
  {t='bgm', track='Frosty Forest'},
  {t='bgm_fade', frames=60},
  {t='bgm_fade', frames=30},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='bgm', track='Frosty Forest'},
  {t='msg', key='SCENE_D10P02_001'},
  {t='msg', key='SCENE_D10P02_002'},
  {t='msg', key='SCENE_D10P02_003'},
  {t='bgm', track='Frosty Forest'},
  {t='msg', key='SCENE_D10P02_004'},
  {t='msg', key='SCENE_D10P02_005'},
}

function d10p02.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d10p02.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, EVENTS)
  GAME:CutsceneMode(false)
  GAME:FadeOut(false, 30)
  GAME:EnterDungeon('frosty_grotto', 0, 0, 0,
    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function d10p02.Update(map) end
function d10p02.GameSave(map) end
function d10p02.GameLoad(map)
  GAME:FadeIn(20)
end

return d10p02
