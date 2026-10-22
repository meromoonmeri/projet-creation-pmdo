-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P11A/s31a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Climb [CS:P]Sky Peak[CR]?", french="[CN]Gravir le [CS:P]Pic Céleste[CR]?", german="[CN]Den [CS:P]Himmelsgipfel[CR] besteigen?", italian="[CN]Vuoi scalare il [CS:P]Picco del Cielo[CR]?", spanish="[CN]¿Quieres subir a la [CS:P]Cumbre del Cielo[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  if (SkyProg.cmp(29, 31) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 31]
  -- @label_2 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_SORANOITADAKI_FLAGSET (fermeture/attente message: géré par say())
  if (SkyProg.cmp(29, 11) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 11]
  -- @label_4 [étiquette de flux ExplorerScript]
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- main_EnterDungeon(111, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else
  SkyProg.set(29, 11) -- $SCENARIO_MAIN = scn[29,11] (ROM)
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  else
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_RECURITABLE_CAN_ADD"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_RECURITABLE_CAN_ADD) [ProcessSpecial(PROCESS_SPECIAL_RECURITABLE_CAN_ADD): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  -- message_Close
  local npc_npc_sheimi = SkySceneKit.spawn_npc("shaymin", 304, 264, Direction.UpLeft, "NPC_SHEIMI")
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sheimi, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_sheimi, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sheimi, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" You're all ready?", french=" Tout est prêt pour le départ?", german=" Seid ihr bereit?", italian=" È tutto pronto?", spanish=" ¿Lo tenéis todo a punto?"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="All right, let's do our best to\nmake it to the summit!", french="Parfait, en route!\nLe sommet nous attend!", german="Alles klar, lasst uns unser\nBestes geben, um die Spitze zu erreichen!", italian="Benissimo! Facciamo del nostro\nmeglio per raggiungere la cima!", spanish="Muy bien... ¡Entonces vamos\na darlo todo para llegar a la cima!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="[CN]You have too many team members.\n[CN][CS:N]Shaymin[CR] cannot join your team.", french="[CN]Votre équipe est déjà au complet,\n[CN][CS:N]Shaymin[CR] ne peut pas la rejoindre.", german="[CN]Du hast zu viele Team-Mitglieder, um\n[CN][CS:N]Shaymin[CR] in dein Team aufzunehmen.", italian="[CN]Ci sono troppi membri nella squadra.\n[CN][CS:N]Shaymin[CR] non può unirsi a voi.", spanish="[CN]Sois demasiados miembros en el equipo.\n[CN][CS:N]Shaymin[CR] no puede unirse al equipo."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="[CN]Use the [CS:K]Chimecho[CR] Assembly Post\n[CN]here to reduce the number of\n[CN]members in your team.", french="[CN]Allez au [CS:K]Point de Rassemblement Eoko[CR]\n[CN]à côté pour réduire le nombre\n[CN]de membres dans votre équipe.", german="[CN]Begib dich zum [CS:K]Palimpalim-Versammlungsort[CR]\n[CN]in der Nähe, um die Anzahl der\n[CN]Team-Mitglieder anzupassen.", italian="[CN]Vai al Raduno Squadra [CS:K]Chimecho[CR]\n[CN]qui accanto per diminuire il numero\n[CN]di membri della tua squadra.", spanish="[CN]Dirígete al punto de reunión de [CS:K]Chimecho[CR]\n[CN]que está aquí al lado para reducir\n[CN]el número de miembros de tu equipo."})
  -- message_Close
  end
  end
  end
  else -- default/annulation
  -- message_Close
  end
  end
  SkySceneKit.cleanup_npcs()
end
