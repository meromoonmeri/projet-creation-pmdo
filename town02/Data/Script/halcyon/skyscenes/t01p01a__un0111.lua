-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/un0111.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) or (SkyProg.cmp_side(40, 3) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7] || scn($SCENARIO_SIDE) >= [40
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_rediba = SkySceneKit.spawn_npc("ledyba", 416, 200, Direction.Left, "NPC_REDIBA")
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english="We go out on explorations not\nreally worrying too much about them.", french="Quand on part en exploration,\non ne se soucie pas vraiment de ce\nqui nous attend.", german="Wir gehen auf Erkundungen,\nohne uns große Gedanken darüber zu machen.", italian="Quando partiamo per\nun'esplorazione non ci preoccupiamo\npiù di tanto.", spanish="Solemos ir a explorar sin\ncalentarnos mucho la cabeza."})
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english="Well, we still manage, no matter\nwhat we come up against.", french="En fait, on s'en sort toujours,\nquoi qu'il arrive.", german="Na ja, bisher hat es immer\nhingehauen, was auch immer uns widerfahren\nist.", italian="Non importa cosa dobbiamo\naffrontare, alla fine riusciamo sempre\na cavarcela.", spanish="Al fin y al cabo, siempre nos va\nbien, surja lo que surja."})
  -- message_Close
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp_side(40, 2) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 2]
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
