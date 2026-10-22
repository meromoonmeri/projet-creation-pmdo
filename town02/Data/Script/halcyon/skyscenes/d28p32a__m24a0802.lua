-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D28P32A/m24a0802.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  SkyProg.set(25, 4) -- $SCENARIO_MAIN = scn[25,4] (ROM)
  pcall(function() SOUND:PlayBGM("Hidden Highland.ogg", true) end)
  -- back_SetGround(LEVEL_D28P32A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  GAME:FadeIn(30)
  GROUND:MoveToPosition(partner, 224, 276, false, 2)
  GAME:WaitFrames(20)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 104, 264, Direction.Right, "NPC_JUPUTORU")
  GROUND:MoveToPosition(npc_npc_juputoru, 200, 260, false, 2)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 176, 292, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What...[K] What is this place?!", french=" C'est...[K] c'est quoi cet endroit?!", german="Was...[K] Was für ein Ort ist\ndas?!?", italian=" Che...[K] cos'è questo posto?!", spanish=" ¿Eh?[K] ¡¿Qué será este lugar?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What...[K] What is this place?!", french=" C'est...[K] c'est quoi cet endroit?!", german="Was...[K] Was für ein Ort ist\ndas?!?", italian=" Che...[K] cos'è questo posto?!", spanish=" ¿Eh?[K] ¡¿Qué será este lugar?!"})
  else
  SkySceneKit.say({english=" What...[K] What is this place?!", french=" C'est...[K] c'est quoi cet endroit?!", german="Was...[K] Was für ein Ort ist\ndas?!?", italian=" Che...[K] cos'è questo posto?!", spanish=" ¿Eh?[K] ¡¿Qué será este lugar?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I'm not sure myself, but...[K]\nI would imagine...", french="Je n'en suis pas sûr, mais...[K]\nj'imagine...", german="Ich bin mir selbst nicht sicher,\naber...[K] Ich könnte mir vorstellen...", italian="Non ne sono sicuro, ma...[K]\nImmagino che...", spanish="Yo tampoco estoy muy seguro...[K]\npero me imagino que..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="It must be the temple of the\n[CS:P]Old Ruins[CR].", french="... qu'il s'agit du temple des\n[CS:P]Ruines Anciennes[CR].", german="Es muss der Tempel der\n[CS:P]Alten Ruinen[CR] sein.", italian="Penso che sia il tempio delle\n[CS:P]Antiche Rovine[CR].", spanish="Debe de ser el templo de\nlas [CS:P]Ruinas Arcanas[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's head up these stairs.", french=" Montons cet escalier.", german="Lasst uns diese Treppe\nhinaufgehen.", italian=" Saliamo queste scale.", spanish=" Subamos por estas escaleras."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's head up these stairs.", french=" Montons cet escalier.", german="Lasst uns diese Treppe\nhinaufgehen.", italian=" Saliamo queste scale.", spanish=" Subamos por estas escaleras."})
  else
  SkySceneKit.say({english=" Let's head up these stairs.", french=" Montons cet escalier.", german="Lasst uns diese Treppe\nhinaufgehen.", italian=" Saliamo queste scale.", spanish=" Subamos por estas escaleras."})
  end
  -- message_Close
  GROUND:MoveToPosition(partner, 260, 276, false, 2)
  GROUND:MoveToPosition(npc_npc_juputoru, 260, 260, false, 2)
  GROUND:MoveToPosition(hero, 260, 292, false, 2)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(partner, 352, 212, false, 2) -- Slide2PositionMark (glissement)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_juputoru, 352, 196, false, 2) -- Slide2PositionMark (glissement)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(hero, 352, 228, false, 2) -- Slide2PositionMark (glissement)
  GAME:WaitFrames(10)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
