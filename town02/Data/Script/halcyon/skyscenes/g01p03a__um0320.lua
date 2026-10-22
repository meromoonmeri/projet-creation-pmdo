-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/um0320.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_pochiena_b = SkySceneKit.spawn_npc("poochyena", 408, 240, Direction.UpRight, "NPC_POCHIENA_B")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_b, 4) end)
  local npc_npc_pochiena_a = SkySceneKit.spawn_npc("poochyena", 448, 240, Direction.Up, "NPC_POCHIENA_A")
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="Why'd you bring in a known\noutlaw like [CS:N]Drowzee[CR]?", french="Mais pourquoi vous avez amené\nun criminel notoire comme [CS:N]Soporifik[CR] dans\nl'enceinte de la Guilde?", german="Warum einen bekannten Ganoven\nwie [CS:N]Traumato[CR] miteinbeziehen?", italian="Perché hai fatto entrare un noto\ncriminale come [CS:N]Drowzee[CR]?", spanish="¿Para qué traer a un delincuente\ncomo [CS:N]Drowzee[CR]?"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 73] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_b, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="[CS:N]Drowzee[CR]?[K] ...Oh, right.\nThat petty crook.", french="[CS:N]Soporifik[CR]?[K] ... Ah, oui.\nCe bandit à la petite semaine.", german="[CS:N]Traumato[CR]?[K] ...Oh, richtig. Dieser\nkleine Gauner.", italian="[CS:N]Drowzee[CR]?[K] Ah, giusto. Quel\ncriminale da strapazzo.", spanish=" ¿[CS:N]Drowzee[CR]?[K] Ah, sí. Ese granuja."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 71] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_b, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english=" I enjoy getting [CS:I]Prize Tickets[CR]...", french="J'adore ça, recevoir\ndes [CS:I]Tickets Magot[CR]...", german="Von [CS:I]Preistickets[CR] kann ich kaum\ngenug bekommen...", italian="Mi piace collezionare\n[CS:I]Buoni Premio[CR]...", spanish=" Me encanta conseguir [CS:I]boletos[CR]..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_b, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="The grand master of all things\nbad? Nope, never heard of him.", french="Le grand maître de tous les\nmaux? Non, jamais entendu parler.", german="Der Großmeister allen Übels?\nNein, nie von ihm gehört.", italian="Sua Malvagità? No, non ne ho\nmai sentito parlare.", spanish="¿El gran malo requetemalo? No,\nnunca había oído hablar de él."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_b, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english=" Team [team:] is in charge!", french="L'Equipe [team:] s'occupe\nde tout!", german="Team [team:] hat das\nKommando!", italian="È compito del\nTeam [team:]!", spanish="¡El [CS:X]Equipo[CR] [team:] se\nencargará de esto!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_b, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="Is it safe to seal away the\nTime Gears?", french="Est-ce que ça n'est pas risqué\nde sceller les Rouages du Temps?", german="Ist es sicher, die Zahnräder der\nZeit zu versiegeln?", italian="È prudente mettere al sicuro\ngli Ingranaggi del Tempo?", spanish="¿Es seguro sellar así los\nEngranajes del Tiempo?"})
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="Will that still allow time to\nwork properly in that area?", french="Vous croyez que ça permettra\nau temps de reprendre son cours normal dans\nla région?", german="Wird das in der Gegend immer\nnoch einen normalen Fluss der Zeit zulassen?", italian="Potremmo ancora lavorare bene\nin quell'area?", spanish="¿Permitirá eso que el paso del\ntiempo no se vea alterado en esa zona?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_b, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="Another Time Gear has\nbeen stolen?", french="Quoi? On a volé un autre\nRouage du Temps?", german="Ein weiteres Zahnrad der Zeit\nwurde gestohlen?", italian="È stato rubato un altro\nIngranaggio del Tempo?", spanish="¿Han robado otro Engranaje del\nTiempo?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 1] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_b, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english=" It still stinks a little...", french="Cette mauvaise odeur n'a pas\nencore totalement disparu...", german=" Es stinkt immer noch ein wenig.", italian=" C'è ancora un po' di puzza...", spanish="Aún hay un cierto mal olor por\naquí..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_b, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="We try to buy only cheaper\nitems that have the greatest value!", french="On n'achète que les objets qui\nont le meilleur rapport qualité-prix!", german="Wir versuchen, nur\ngünstige Items einzukaufen, die den größten\nNutzen bringen!", italian="Cerchiamo di comprare solo\ngli strumenti con il miglior rapporto\nqualità-prezzo!", spanish="¡Intentamos comprar solo los\nobjetos más baratos, pero más valiosos!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(5, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [5, 5]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_b, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="We try to pursue weak crooks\nwith only the highest bounties!", french="On se lance à la poursuite des\nbandits les plus faibles qui font l'objet des\nplus fortes récompenses!", german="Wir versuchen, nur schwache\nGauner zu verfolgen, die gleichzeitig die\ndicksten Belohnungen einbringen!", italian="Proviamo a catturare i\ncriminali deboli con le taglie più alte!", spanish="¡Intentamos perseguir a los\nmalhechores débiles, pero siempre que\nofrezcan buenas recompensas!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 7]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_b, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="The three of us are the\n[CS:N]Poochyena[CR] Brothers![K] We're Team [CS:X]Poochy[CR]!", french="Nous trois, on est les frères\n[CS:N]Medhyèna[CR]![K]\nOn est l'Equipe [CS:X]Morsure[CR]!", german="Wir drei sind die\n[CS:N]Fiffyen[CR]-Brüder![K] Wir sind Team [CS:X]Fiffi[CR]!", italian="Noi tre siamo i fratelli\n[CS:N]Poochyena[CR]![K] E siamo il Team [CS:X]Poochyena[CR]!", spanish="¡Somos los hermanos [CS:N]Poochyena[CR]![K]\nY los tres, como no, formamos el [CS:X]Equipo[CR]\n[CS:X]Poochyena[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english=" We stick to tracking outlaws!", french="On passe notre vie à traquer les\nhors-la-loi!", german="Wir haben uns darauf\nspezialisiert, Ganoven zu jagen!", italian=" Diamo la caccia ai ricercati!", spanish="¡Nos centramos en perseguir\nmalhechores!"})
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="We chase and chase and chase\nour targets...", french="On pourchasse les criminels\nencore et encore, sans relâche...", german="Wir jagen und jagen und jagen\nunsere Ziele...", italian="Inseguiamo e inseguiamo e\ninseguiamo i nostri obiettivi...", spanish="Les perseguimos de un sitio\na otro, y a otro, y a otro..."})
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="And then we catch them when\nthey're too tired to move!", french="Et quand ils sont trop épuisés\npour s'enfuir, on leur tombe dessus!", german="Und dann überwältigen wir sie,\nwenn sie zu erschöpft sind, um zu entkommen!", italian="E quando sono sfiniti dalla\nstanchezza, li catturiamo!", spanish="¡Hasta que están demasiado\ncansados y les capturamos!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
