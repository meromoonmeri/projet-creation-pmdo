-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/un0404.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if (SkyProg.cmp_side(43, 2) >= 0) or ((SV.SkyTalkBitFlags or {})[135] == 1) then -- if ROM: scn($SCENARIO_SIDE) >= [43, 2] || $SCENARIO_TALK_BIT_FLAG[13
  -- @label_0 [étiquette de flux ExplorerScript]
  -- switch(message_Menu(MENU_KANGASKHAN_STORAGE)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_1 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[135] = 1 -- $SCENARIO_TALK_BIT_FLAG[135] = 1 (ROM)
  local npc_npc_garuura = SkySceneKit.spawn_npc("kangaskhan", 184, 168, Direction.Down, "NPC_GARUURA")
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english="I've got it! [CS:Y]Sunflora[CR]![K]\nHave you come to use the storage?", french="J'y suis! [CS:Y]Héliatronc[CR]![K]\nTu es venue pour utiliser la réserve?", german="Na klaro! [CS:Y]Sonnflora[CR]![K] Bist du\ngekommen, um das Lager zu verwenden?", italian="Ciao [CS:Y]Sunflora[CR], lasciami\nindovinare![K] Sei venuta qui per usare\nil deposito, vero?", spanish="¡Ya sé! [CS:Y]Sunflora[CR]...[K]\n¿has venido a usar la consigna?"})
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english="I'll take good care of your items,\nso you can entrust them to me!", french="Je prendrai grand soin de tes\nobjets, alors n'hésite pas à me les confier.", german="Ich werde gut auf deine Items\naufpassen. Du kannst sie mir anvertrauen!", italian="Avrò cura dei tuoi strumenti,\nfidati di me!", spanish="Me ocuparé bien de tus objetos,\npuedes confiármelos con total tranquilidad."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
