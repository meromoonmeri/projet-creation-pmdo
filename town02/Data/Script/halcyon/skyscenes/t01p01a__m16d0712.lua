-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/m16d0712.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_T01P01A) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_s_juputoru = SkySceneKit.spawn_npc("grovyle", 320, 168, Direction.Down, "NPC_S_JUPUTORU")
  -- SetAnimation(26) [anim idle native]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_s_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 352, 184, Direction.Down, "NPC_S_YONOWAARU")
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 352, 192, Direction.Down, "NPC_YONOWAARU")
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" [CS:N]Uxie[CR]...[CS:N]Mesprit[CR]...[CS:N]Azelf[CR]...", french="[CS:N]Créhelf[CR]... [CS:N]Créfollet[CR]...\n[CS:N]Créfadet[CR]...", german=" [CS:N]Selfe[CR]...[CS:N] Vesprit[CR]...[CS:N] Tobutz[CR]...", italian=" [CS:N]Uxie[CR]... [CS:N]Mesprit[CR]... [CS:N]Azelf[CR]...", spanish=" [CS:N]Uxie[CR]... [CS:N]Mesprit[CR]... [CS:N]Azelf[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_s_yukushii = SkySceneKit.spawn_npc("uxie", 304, 224, Direction.UpRight, "NPC_S_YUKUSHII")
  GROUND:EntTurn(npc_npc_s_yukushii, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" I entrust you with the rest.", french="Je vous fais confiance\npour la suite.", german="Ich vertraue euch die Aufgabe\nan, es zu Ende zu bringen.", italian=" Affido a voi il resto.", spanish=" Os confío a vosotros el resto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 4) [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Azelf", true, "azelf", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AGUNOMU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Yep.", french=" Ouaip.", german=" Ja.", italian=" D'accordo.", spanish=" Sí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Mesprit", true, "mesprit", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_EMURITTO (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" We know.", french="Nous savons ce que nous avons\nà faire.", german=" Wir wissen Bescheid.", italian=" Lasci fare a noi.", spanish=" Lo sabemos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Uxie", true, "uxie", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YUKUSHII (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" We got the Time Gears back.", french="Nous avons récupéré\nles Rouages du Temps.", german="Wir haben die Zahnräder der\nZeit wieder.", italian="Gli Ingranaggi del Tempo sono\ntornati in mano nostra...", spanish="Hemos recuperado los Engranajes\ndel Tiempo."})
  pcall(function() UI:SetSpeaker("Uxie", true, "uxie", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YUKUSHII (espèce ROM, sans placement zone)
  SkySceneKit.say({english="And we will make sure they're\nreturned to their rightful places.", french="Et nous allons nous assurer\nqu'ils reprennent leur juste place.", german="Und wir werden sicherstellen,\ndass sie wieder da hinkommen, wo sie\nhingehören.", italian="Sarà nostro compito rimetterli\nal loro posto.", spanish="Y nos encargaremos de que\nvuelvan a ocupar el lugar que les corresponde."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" The task is yours.", french=" Cette tâche vous revient.", german=" Das ist eure Aufgabe.", italian=" Va bene.", spanish=" Eso queda en vuestras manos."})
  -- message_Close
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
