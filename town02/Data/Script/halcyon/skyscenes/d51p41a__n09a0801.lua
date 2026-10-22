-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D51P41A/n09a0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(144, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D51P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  GAME:WaitFrames(30)
  local npc_npc_onigoori = SkySceneKit.spawn_npc("glalie", 200, 184, Direction.DownRight, "NPC_ONIGOORI")
  pcall(function() UI:SetSpeaker(npc_npc_onigoori) end)
  SkySceneKit.say({english=" GOGIGIGI!", french=" GOGNIGNIGNI!", german=" GOGIGIGI!", italian=" GOGIGIGI!", spanish=" ¡GOGUIGUÍ!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_onigoori) end)
  SkySceneKit.say({english=" GOGIGIGIGI!", french=" GOGNIGNIGNIGNI!", german=" GOGIGIGIGI!", italian=" GOGIGIGIGI!", spanish=" ¡GOGUIGUIGUÍ!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="If we don't take care of\nthese guys, we won't be able to proceed!", french="Il faut nous débarrasser d'eux\nsi nous voulons avancer.", german="Wenn wir uns jetzt nicht um sie\nkümmern, kommen wir nicht weiter!", italian="Se non ci sbarazziamo di questi\ntizi, non faremo molta strada!", spanish="¡Si no nos ocupamos de estos\nPokémon, no podremos seguir adelante!"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="This time, we'll knock\nthem around!", french="Cette fois-ci, nous leur ferons\nmordre la poussière!", german="Dieses Mal werden wir\nihnen eine Abreibung verpassen!", italian="Questa volta dobbiamo\nsconfiggerli!", spanish="¡Esta vez nos libraremos\nde ellos de una vez por todas!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Got it!", french=" C'est parti!", german=" Verstanden!", italian=" Certo!", spanish=" ¡Entendido!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- GAP: se_Play(10757) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  local npc_npc_manmuu = SkySceneKit.spawn_npc("mamoswine", 256, 160, Direction.Down, "NPC_MANMUU")
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() UI:SetSpeaker(npc_npc_manmuu) end)
  SkySceneKit.say({english=" BUAAAAOOOOOON!", french=" ROOOAAAAARRRR!", german=" BUAAAAOOOOOON!", italian=" BUAAAAOOOOOON!", spanish=" ¡BUAAAAOOOOOON!"})
  GAME:WaitFrames(90)
  -- message_CloseEnforce
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Here they come!", french=" Ils arrivent!", german=" Es geht los!", italian=" Eccoli che arrivano!", spanish=" ¡Ahí vienen!"})
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(144, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
