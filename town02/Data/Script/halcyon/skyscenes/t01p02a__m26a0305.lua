-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/m26a0305.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Restored.ogg", true) end)
  -- back_SetGround(LEVEL_T01P02A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-200), 400, false) end) -- MovePositionOffset performer/caméra
  local npc_npc_nyorotono = SkySceneKit.spawn_npc("politoed", 320, 208, Direction.Up, "NPC_NYOROTONO")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_rediba = SkySceneKit.spawn_npc("ledyba", 368, 208, Direction.UpLeft, "NPC_REDIBA")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_togepii = SkySceneKit.spawn_npc("togepi", 344, 224, Direction.Up, "NPC_TOGEPII")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_neityio = SkySceneKit.spawn_npc("xatu", 240, 352, Direction.Down, "NPC_NEITYIO")
  -- SetAnimation(4) [anim idle native]
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Everyone looks happy!", french=" Tout le monde a l'air si heureux!", german=" Alle sehen glücklich aus!", italian=" Sembrano tutti felici!", spanish=" ¡Todos parecen contentos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Everyone looks happy!", french=" Tout le monde a l'air si heureux!", german=" Alle sehen glücklich aus!", italian=" Sembrano tutti felici!", spanish=" ¡Todos parecen contentos!"})
  else
  SkySceneKit.say({english=" Everyone looks cheerful!", french=" Tout le monde a l'air si heureux!", german=" Alle sehen fröhlich aus!", italian=" Sembrano tutti allegri!", spanish=" ¡Todos parecen contentos!"})
  end
  GAME:WaitFrames(240)
  -- message_CloseEnforce
  GAME:FadeOut(false,  60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
