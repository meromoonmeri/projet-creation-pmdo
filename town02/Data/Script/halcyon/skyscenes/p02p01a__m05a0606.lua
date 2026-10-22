-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P02P01A/m05a0606.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_P02P01A) [neutre/état moteur]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  GAME:FadeOut(false, 0) -- screen_FlushOut
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  -- ResetOutputAttribute(256) [neutre/état moteur]
  -- ResetOutputAttribute(256) [neutre/état moteur]
  local npc_npc_himeguma = SkySceneKit.spawn_npc("teddiursa", 224, 192, Direction.UpRight, "NPC_HIMEGUMA")
  -- ResetOutputAttribute(256) [neutre/état moteur]
  local npc_npc_ringuma = SkySceneKit.spawn_npc("ursaring", 304, 240, Direction.UpLeft, "NPC_RINGUMA")
  -- ResetOutputAttribute(256) [neutre/état moteur]
  local npc_npc_yarukimono = SkySceneKit.spawn_npc("vigoroth", 264, 248, Direction.Up, "NPC_YARUKIMONO")
  -- ResetOutputAttribute(256) [neutre/état moteur]
  local npc_npc_mankii = SkySceneKit.spawn_npc("mankey", 304, 184, Direction.UpLeft, "NPC_MANKII")
  -- ResetOutputAttribute(256) [neutre/état moteur]
  local npc_npc_okorizaru = SkySceneKit.spawn_npc("primeape", 208, 232, Direction.UpRight, "NPC_OKORIZARU")
  -- ResetOutputAttribute(256) [neutre/état moteur]
  -- GAP: SetEffect EFFECT_STUCK_IN_YELLOW_WATER — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_STUCK_IN_YELLOW_WATER — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_STUCK_IN_YELLOW_WATER — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_STUCK_IN_YELLOW_WATER_DEEP — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_STUCK_IN_YELLOW_WATER_MEDIUM — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_STUCK_IN_YELLOW_WATER_MEDIUM2 — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_STUCK_IN_YELLOW_WATER_DEEP2 — VFX sans émote PMDO équivalente
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_kootasu = SkySceneKit.spawn_npc("torkoal", 264, 152, Direction.Down, "NPC_KOOTASU")
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_0 [étiquette de flux ExplorerScript]
  pcall(function() SOUND:PlayBGM("Heartwarming.ogg", true) end)
  -- supervision_Acting(8) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  -- ResetOutputAttribute(256) [neutre/état moteur]
  -- ResetOutputAttribute(256) [neutre/état moteur]
  -- ResetOutputAttribute(256) [neutre/état moteur]
  -- ResetOutputAttribute(256) [neutre/état moteur]
  -- ResetOutputAttribute(256) [neutre/état moteur]
  -- ResetOutputAttribute(256) [neutre/état moteur]
  -- ResetOutputAttribute(256) [neutre/état moteur]
  -- GAP: SetEffect EFFECT_STUCK_IN_YELLOW_WATER — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_STUCK_IN_YELLOW_WATER — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_STUCK_IN_YELLOW_WATER — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_STUCK_IN_YELLOW_WATER_DEEP — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_STUCK_IN_YELLOW_WATER_MEDIUM — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_STUCK_IN_YELLOW_WATER_MEDIUM2 — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_STUCK_IN_YELLOW_WATER_DEEP2 — VFX sans émote PMDO équivalente
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- @label_2 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="My goodness! It was the water\nthat carried you all this way?", french="Saperlotte! C'est à cause du\ncourant que vous vous retrouvez ici?", german="Meine Güte! Ihr wurdet vom\nWasser hierher getragen?", italian="Cielo! È stata l'acqua a farvi\narrivare fin qui?", spanish="¿Que os ha traído el agua?\n¡Asombroso!"})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="What a long journey that must\nhave been![K] Let the Hot Spring wash away your\nfatigue before you make your way home.", french="En voilà un voyage pas banal,\ndites-moi![K] Laissez la Source Chaude\neffacer votre fatigue avant de rentrer.", german="Was für eine lange Reise![K] Lasst\ndie Heiße Quelle eure Müdigkeit wegwaschen,\nbevor ihr euch auf den Heimweg macht.", italian="Dev'essere stato un viaggio\nmolto lungo![K] Lasciate che la Sorgente Termale\nvi allevii la stanchezza, prima di andare.", spanish="¡Ha debido de ser un viaje\nlarguísimo![K] ¿Por qué no descansáis\nen la Terma antes de volver a casa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Good idea. We'll do that. Thanks,\neveryone!", french=" Bonne idée. Merci à vous tous!", german="Gute Idee. Das machen wir.\nVielen Dank euch allen!", italian="Ottima idea. Lo faremo. Grazie\na tutti voi!", spanish="Buena idea. Eso haremos.\n¡Gracias a todos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Good idea. We'll do that. Thanks,\neveryone!", french=" Bonne idée. Merci à vous tous!", german="Gute Idee. Das machen wir.\nVielen Dank euch allen!", italian="Ottima idea. Lo faremo. Grazie\na tutti voi!", spanish="Buena idea. Eso haremos.\n¡Gracias a todos!"})
  else
  SkySceneKit.say({english="Good idea. We'll do that. Thanks,\neveryone!", french=" Bonne idée. Merci à vous tous!", german="Gute Idee. Das machen wir.\nVielen Dank euch allen!", italian="Ottima idea. Lo faremo. Grazie\na tutti voi!", spanish="Buena idea. Eso haremos.\n¡Gracias a todos!"})
  end
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_himeguma, partner, 4) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mankii, partner, 4) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "happy", 1) end)
  GAME:WaitFrames(60)
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 1 -- $SCENARIO_MAIN_BIT_FLAG[8] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.COMPULSORY_SAVE_POINT = 3 -- $COMPULSORY_SAVE_POINT = 3 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  -- @label_5 [étiquette de flux ExplorerScript]
  end
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
