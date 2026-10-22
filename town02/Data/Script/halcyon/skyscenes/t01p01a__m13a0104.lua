-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/m13a0104.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_T01P01A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_T01P01A, 'UM13') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 640, 216, Direction.Right, "NPC_BIPPA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 328, 224, Direction.UpRight, "NPC_HEIGANI")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 352, 192, Direction.Down, "NPC_YONOWAARU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_banebuu = SkySceneKit.spawn_npc("spoink", 384, 232, Direction.UpLeft, "NPC_BANEBUU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  SkySceneKit.cleanup_npcs()
end
