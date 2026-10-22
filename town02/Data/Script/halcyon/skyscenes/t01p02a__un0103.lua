-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/un0103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_4 [étiquette de flux ExplorerScript]
  -- switch(message_Menu(MENU_KANGASKHAN_STORAGE)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp_side(40, 3) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 3]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(40, 2) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 2]
  if ((SV.SkyTalkBitFlags or {})[127] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[127]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[127] = 1 -- $SCENARIO_TALK_BIT_FLAG[127] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_garuura = SkySceneKit.spawn_npc("kangaskhan", 184, 168, Direction.Down, "NPC_GARUURA")
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english="Huh? [CS:Y]Bidoof[CR]![K]\nLong time no see!", french="Hein? [CS:Y]Keunotor[CR]![K]\nÇa fait un bout de temps!", german="Huch? [CS:Y]Bidiza[CR]![K]\nLange nicht gesehen!", italian="Eh? [CS:Y]Bidoof[CR]![K]\nNe è passato di tempo!", spanish="¿Eh? ¡[CS:Y]Bidoof[CR]![K]\n¡Cuánto tiempo sin verte!"})
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english=" You want to use the storage?", french=" Tu veux utiliser la réserve?", german="Möchtest du das Lager\nverwenden?", italian=" Vuoi usare il deposito?", spanish=" ¿Quieres usar la consigna?"})
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english="My dear, anything you want\nto store, I'll take good care of for you!", french="Mon enfant, je prendrai grand\nsoin de tout ce que tu voudras placer\ndans la réserve.", german="Ich werde auf alles, das du\nlagern möchtest, aufpassen, werter Erkunder!", italian="Tesoro mio, se vuoi conservare\nqualcosa nel deposito non preoccuparti. Avrò\ncura dei tuoi strumenti come se fossero miei!", spanish="Claro, cielo, cuidaré bien de\ncualquier cosa que quieras que guarde."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  else
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
