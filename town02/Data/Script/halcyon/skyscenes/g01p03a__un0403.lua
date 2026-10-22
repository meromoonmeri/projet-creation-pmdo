-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/un0403.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(43, 2) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [43, 2]
  end
  -- @label_2 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_poniita = SkySceneKit.spawn_npc("ponyta", 384, 288, Direction.DownLeft, "NPC_PONIITA")
  pcall(function() UI:SetSpeaker(npc_npc_poniita) end)
  SkySceneKit.say({english="Our leader is always nervous\naround fire.[K] But that's a small thing compared\nto all the positives!", french="A cause du feu, notre meneur\npanique... [K]mais ses qualités l'emportent\nde loin sur ce seul défaut.", german="Unser Anführer ist nervös,\nwenn Feuer im Spiel ist.[K] Aber die Vorteile\nüberwiegen die Nachteile.", italian="Il nostro leader diventa nervoso\nquando vede il fuoco...[K] Ma ha tanti\naltri aspetti positivi.", spanish="Nuestro líder siempre se pone\nmuy nervioso cuando hay fuego cerca.[K]\n¡Pero no lo cambiaríamos por nada!"})
  pcall(function() UI:SetSpeaker(npc_npc_poniita) end)
  SkySceneKit.say({english="So I'm happy to support our\nleader through thick or thin.", french="Alors je me réjouis de soutenir\nnotre meneur contre vents et marées.", german="Daher bin ich glücklich, unserem\nAnführer durch dick und dünn zu folgen.", italian="Io sosterrò sempre il leader,\nnella buona e nella cattiva sorte!", spanish="¡Eso es una nimiedad al lado de\ntodos sus méritos!"})
  -- message_Close
  -- @label_1 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.cleanup_npcs()
end
