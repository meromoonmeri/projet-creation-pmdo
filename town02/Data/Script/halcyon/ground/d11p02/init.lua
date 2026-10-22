-- [dungeon_builder] scène canonique PMD Red — scène d11p02 (relay).
--[[ d11p02 — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d11p02.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D11P02_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : relais de mi-parcours — aucun combat (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     Aucun boss ici : dans PMD Red les combats de gardien se jouent à la
     scène de fin du donjon ou dans le donjon lui-même.
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local d11p02 = {}

local SCENE = 'd11p02'
-- Séquence canonique, dans l'ordre du script de la ROM
-- (RESERVE/red_cinematics/d11p02.cif.json).
local EVENTS = {
  {t='bgm', track='Mt. Freeze'},
  {t='bgm_fade', frames=60},
  {t='bgm_fade', frames=30},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='bgm', track='Mt. Freeze'},
  {t='msg', key='SCENE_D11P02_001'},
  {t='msg', key='SCENE_D11P02_002'},
}

function d11p02.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d11p02.Enter(map)
  DEBUG.EnableDbgCoro()
  -- Canonical PMD Red relay scene between mt_freeze and mt_freeze_peak.
  -- See d05p02.Enter for the SV.CanonicalDungeons marker rationale.
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons['mt_freeze'] = true
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, EVENTS)
  GAME:CutsceneMode(false)
  GAME:FadeOut(false, 30)
  GAME:EnterDungeon('mt_freeze_peak', 0, 0, 0,
    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function d11p02.Update(map) end
function d11p02.GameSave(map) end
function d11p02.GameLoad(map)
  GAME:FadeIn(20)
end

return d11p02
