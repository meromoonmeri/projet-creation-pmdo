-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/m01a0102.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The shop-related menus will be opened.\nWhich one would you like?", french="The shop-related menus will be opened.\nWhich one would you like?", german="The shop-related menus will be opened.\nWhich one would you like?", italian="The shop-related menus will be opened.\nWhich one would you like?", spanish="The shop-related menus will be opened.\nWhich one would you like?"})
  do local __choice = SkySceneKit.ask({{english="Duskull Bank", french="Duskull Bank", german="Duskull Bank", italian="Duskull Bank", spanish="Duskull Bank"}, {english="Kangaskhan Storage", french="Kangaskhan Storage", german="Kangaskhan Storage", italian="Kangaskhan Storage", spanish="Kangaskhan Storage"}, {english="Kecleon Shop", french="Kecleon Shop", german="Kecleon Shop", italian="Kecleon Shop", spanish="Kecleon Shop"}, {english="Kecleon Wares", french="Kecleon Wares", german="Kecleon Wares", italian="Kecleon Wares", spanish="Kecleon Wares"}, {english="Name", french="Name", german="Name", italian="Name", spanish="Name"}, {english="Croagunk Swap Shop", french="Croagunk Swap Shop", german="Croagunk Swap Shop", italian="Croagunk Swap Shop", spanish="Croagunk Swap Shop"}, {english="Evolution", french="Evolution", german="Evolution", italian="Evolution", spanish="Evolution"}, {english="Egg (Day Care)", french="Egg (Day Care)", german="Egg (Day Care)", italian="Egg (Day Care)", spanish="Egg (Day Care)"}, {english="Drink", french="Boisson", german="Drink", italian="Drink", spanish="Zumo"}, {english="Recycle", french="Echanger", german="Recycle", italian="Recycle", spanish="Reciclar"}, {english="Prize Drawing", french="Loterie", german="Prize Drawing", italian="Prize Drawing", spanish="Sorteo"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- message_Close
  -- switch(message_Menu(MENU_DUSKULL_BANK)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 2 then
  -- message_Close
  -- switch(message_Menu(MENU_KANGASKHAN_STORAGE)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 3 then
  -- message_Close
  -- switch(message_Menu(MENU_KECLEON_SHOP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 4 then
  -- message_Close
  -- switch(message_Menu(MENU_KECLEON_WARES)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 5 then
  -- message_Close
  -- switch(message_Menu(MENU_PLAYER_NAME)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 6 then
  -- message_Close
  -- switch(message_Menu(MENU_SWAP_SHOP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_12 [étiquette de flux ExplorerScript]
  -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
  do local __sw = ((SV.SkyMenuResults or {})["MENU_SWAP_SHOP2"] or 0) -- switch(message_Menu(MENU_SWAP_SHOP2)) [message_Menu(MENU_SWAP_SHOP2): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 1 then
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Up)
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  elseif true then -- default
  -- break_loop [contrôle de boucle forever NDS: une itération compilée]
  end
  end
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 7 then
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.play_scene("p14p01a__evolve00", "p14p01a__evolve", hero, partner) -- supervision_ExecuteActing(LEVEL_P14P01A, 'EVOLVE', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 8 then
  -- message_Close
  -- switch(message_Menu(MENU_DAY_CARE)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 9 then
  -- message_Close
  -- switch(message_Menu(MENU_JUICE_BAR)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_14 [étiquette de flux ExplorerScript]
  -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
  do local __sw = ((SV.SkyMenuResults or {})["MENU_JUICE_BAR_PICK_ITEM"] or 0) -- switch(message_Menu(MENU_JUICE_BAR_PICK_ITEM)) [message_Menu(MENU_JUICE_BAR_PICK_ITEM): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 0 then
  -- break_loop [contrôle de boucle forever NDS: une itération compilée]
  elseif true then -- default
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  end
  end
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 10 then
  -- message_Close
  -- switch(message_Menu(MENU_RECYCLE_SHOP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_16 [étiquette de flux ExplorerScript]
  -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
  do local __sw = ((SV.SkyMenuResults or {})["MENU_RECYCLE_SHOP2"] or 0) -- switch(message_Menu(MENU_RECYCLE_SHOP2)) [message_Menu(MENU_RECYCLE_SHOP2): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 0 then
  -- break_loop [contrôle de boucle forever NDS: une itération compilée]
  elseif true then -- default
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  end
  end
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 11 then
  -- message_Close
  -- switch(message_Menu(MENU_LOTTERY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_18 [étiquette de flux ExplorerScript]
  -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
  do local __sw = ((SV.SkyMenuResults or {})["MENU_LOTTERY2"] or 0) -- switch(message_Menu(MENU_LOTTERY2)) [message_Menu(MENU_LOTTERY2): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 0 then
  -- break_loop [contrôle de boucle forever NDS: une itération compilée]
  elseif true then -- default
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  end
  end
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else -- default/annulation
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I see...", french="I see...", german="I see...", italian="I see...", spanish="I see..."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
end
