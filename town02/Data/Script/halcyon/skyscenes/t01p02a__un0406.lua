-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/un0406.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if (SkyProg.cmp_side(43, 2) >= 0) or ((SV.SkyTalkBitFlags or {})[136] == 1) then -- if ROM: scn($SCENARIO_SIDE) >= [43, 2] || $SCENARIO_TALK_BIT_FLAG[13
  -- @label_0 [étiquette de flux ExplorerScript]
  -- switch(message_Menu(MENU_KECLEON_SHOP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_1 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[136] = 1 -- $SCENARIO_TALK_BIT_FLAG[136] = 1 (ROM)
  local npc_npc_kakureon1 = SkySceneKit.spawn_npc("kecleon", 328, 168, Direction.Down, "NPC_KAKUREON1")
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="It looks like your workload is\npiling up... It must be tough!", french="On dirait qu'il y a beaucoup\nde travail... Dur, dur!", german="Anscheinend wird die Arbeit,\ndie du zu erledigen hast, noch mehr werden...\nDas muss hart sein!", italian="A quanto pare, il tuo carico di\nlavoro aumenta sempre di più... Deve\nessere una bella fatica!", spanish="Parece que está hasta\narriba de trabajo... ¡Qué cansancio!"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" But do your best! ♪", french=" Fais de ton mieux! ♪", german=" Aber gib dein Bestes! ♪", italian=" Ma fai del tuo meglio! ♪", spanish=" ¡Pero debe darlo todo! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="Feel free to purchase some of\nour items for your use. ♪", french="N'hésite pas à acheter\nce dont tu as besoin. ♪", german="Leg dir ruhig das ein oder\nandere unserer Items zum persönlichen\nGebrauch zu. ♪", italian="I nostri strumenti sono a tua\ndisposizione. Compra pure quello che\nti serve. ♪", spanish="Puede comprar algunos de\nnuestros objetos para usarlos. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
