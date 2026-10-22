-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P05A/un0402.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(43, 2) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [43, 2]
  end
  -- @label_2 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 248, 232, Direction.UpLeft, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I feel safe as long as you're\non it, [CS:Y]Sunflora[CR]! ♪", french="Je me sens rassuré de savoir\nque c'est toi qui t'en occupes, [CS:Y]Héliatronc[CR]! ♪", german="Ich bin unbesorgt, da du dich der\nSache annimmst, [CS:Y]Sonnflora[CR]! ♪", italian="Sapere che sarai tu a occuparti\ndi questa missione mi rende molto più\ntranquillo, [CS:Y]Sunflora[CR]! ♪", spanish="Me siento seguro mientras tú\nestés al frente, [CS:Y]Sunflora[CR]. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Good luck catching [CS:N]Haunter[CR]! ♪", french="Bonne chance pour ta chasse\nau [CS:N]Spectrum[CR]! ♪", german="Viel Glück mit der Verhaftung\nvon [CS:N]Alpollo[CR]! ♪", italian="Buona fortuna per la cattura\ndel Pokémon [CS:N]Haunter[CR]! ♪", spanish="¡Buena suerte con la captura de\n[CS:N]Haunter[CR]! ♪"})
  -- message_Close
  -- @label_1 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.cleanup_npcs()
end
