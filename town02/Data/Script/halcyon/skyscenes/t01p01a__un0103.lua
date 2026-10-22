-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/un0103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) or (SkyProg.cmp_side(40, 3) >= 0) or (SkyProg.cmp_side(40, 2) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7] || scn($SCENARIO_SIDE) >= [40
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_bakuuda = SkySceneKit.spawn_npc("camerupt", 296, 256, Direction.DownRight, "NPC_BAKUUDA")
  pcall(function() UI:SetSpeaker(npc_npc_bakuuda) end)
  SkySceneKit.say({english="If you can graduate from\n[CS:N]Wigglytuff[CR]'s Guild, you sure can be an\namazing explorer!", french="Si tu décroches ton diplôme à la\nGuilde de [CS:N]Grodoudou[CR], tu deviendras un as de\nl'exploration!", german="Wenn du den Abschluss der\n[CS:N]Knuddeluff-Gilde[CR] schaffst, wirst du\nsicherlich ein fantastischer Entdecker werden!", italian="Se passi l'esame della Gilda\ndi [CS:N]Wigglytuff[CR] significa che sei davvero\nun esploratore coi fiocchi!", spanish="Si logras superar el reto\ndel [CS:N]Pokégremio de Exploradores[CR],\n¡es que exploras de maravilla!"})
  pcall(function() UI:SetSpeaker(npc_npc_bakuuda) end)
  SkySceneKit.say({english=" Good luck!", french=" Bonne chance!", german=" Viel Erfolg!", italian=" Buona fortuna!", spanish=" ¡Buena suerte!"})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
