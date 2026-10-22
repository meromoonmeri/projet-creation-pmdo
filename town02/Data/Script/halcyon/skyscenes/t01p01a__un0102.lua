-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/un0102.ssb (ROM sha256 1fa39d35…).
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
  local npc_npc_poniita = SkySceneKit.spawn_npc("ponyta", 328, 256, Direction.DownLeft, "NPC_PONIITA")
  pcall(function() UI:SetSpeaker(npc_npc_poniita) end)
  SkySceneKit.say({english="[CS:N]Wigglytuff[CR]'s Guild is famous for\nhard training.", french="La Guilde de [CS:N]Grodoudou[CR]\nest réputée pour l'entraînement rigoureux\nqu'elle propose.", german="Die [CS:N]Knuddeluff-Gilde[CR] ist\nberühmt für hartes Training.", italian="La Gilda di [CS:N]Wigglytuff[CR] è famosa\nper i suoi durissimi allenamenti.", spanish="El [CS:N]Pokégremio de Exploradores[CR]\nes conocido por su duro entrenamiento."})
  pcall(function() UI:SetSpeaker(npc_npc_poniita) end)
  SkySceneKit.say({english="But it seems like it's really\nworth it, so do your best.", french="Mais il semblerait que ça\nen vaille la peine, alors fais de ton mieux.", german="Aber es scheint, als sei es das\nwirklich wert, also gib dein Bestes.", italian="Ma sembra che ne valga davvero\nla pena, quindi dacci dentro.", spanish="Por lo visto merece totalmente\nla pena, así que hay que darlo todo."})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
