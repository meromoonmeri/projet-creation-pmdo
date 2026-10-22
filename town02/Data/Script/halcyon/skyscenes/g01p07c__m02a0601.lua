-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m02a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's get some sleep.", french=" Il est l'heure de dormir.", german=" Lass uns schlafen gehen.", italian=" Andiamo a dormire.", spanish=" Vamos a dormir."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We should get some sleep.", french=" Il est l'heure de dormir.", german=" Wir sollten schlafen gehen.", italian=" Andiamo a dormire.", spanish=" Será mejor que durmamos."})
  else
  SkySceneKit.say({english=" Why don't we get some sleep?", french=" Il est l'heure de dormir.", german="Wieso legen wir uns nicht\nschlafen?", italian=" Andiamo a dormire.", spanish="Será mejor que nos vayamos\na dormir."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 16, 184, Direction.Right, "NPC_PERAPPU")
  GROUND:MoveToPosition(npc_npc_perappu, 112, 184, false, 2)
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Hey, beginners!", french=" Hé! Les novices!", german=" Hey, Neulinge!", italian=" Ehi, principianti!", spanish=" ¡Escuchadme, aprendices!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Left)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Before you go to bed, our\nGuildmaster wants to speak with you.", french="Le Maître de la Guilde veut vous\nparler avant que vous n'alliez vous coucher.", german="Bevor ihr ins Bett geht, möchte\nunser Gildenmeister euch noch sprechen.", italian="Prima che andiate a letto, il\nnostro Capitano vorrebbe parlarvi.", spanish="Antes de que os acostéis, al\nGran Bluff le gustaría deciros algo."})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
