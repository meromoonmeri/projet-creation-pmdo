-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P04A/um1404.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_poppo = SkySceneKit.spawn_npc("pidgey", 400, 296, Direction.Up, "NPC_POPPO")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_poppo, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_poppo) end)
  SkySceneKit.say({english="We're out of your league![K]\nYou KO'd [CS:N]Darkrai[CR]!", french="Vous avez vaincu [CS:N]Darkrai[CR]![K]\nWaouh, nous sommes très loin d'avoir votre\nniveau...", german="Wir spielen nicht in eurer Liga![K]\nIhr habt [CS:N]Darkrai[CR] bezwungen!", italian="Siete una squadra eccezionale![K]\nAvete sconfitto [CS:N]Darkrai[CR]!", spanish="¡Menudo nivel![K] ¡Habéis derrotado\na [CS:N]Darkrai[CR]!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_poppo, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_poppo) end)
  SkySceneKit.say({english="What?! Team [CS:X]Charm[CR]\ncame here?!", french="Quoi?! L'Equipe [CS:X]Charme[CR]\nétait ici?!", german="Was? Team [CS:X]Charme[CR] ist\nhierhergekommen?!?", italian="Cosa?! Il Team [CS:X]Malia[CR] è venuto\nqui?!", spanish="¡¿Qué?! ¡¿El [CS:X]Equipo Carisma[CR] ha\nestado aquí?!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_poppo, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_poppo) end)
  SkySceneKit.say({english="[CS:P]Luminous Spring[CR]?[K] Oh, that place\nis where Pokémon used to go to evolve.", french="La [CS:P]Source Lumineuse[CR]?[K]\nAh oui, c'est là que les Pokémon se rendaient\npour évoluer autrefois.", german="Die [CS:P]Glitzerquelle[CR]?[K] Oh, an diesen\nOrt gehen Pokémon, um sich zu entwickeln.", italian="La [CS:P]Sorgente Luccichio[CR]?[K] Ah, è\nil posto in cui i Pokémon vanno a evolversi.", spanish="¿El [CS:P]Manantial Luminoso[CR]?[K] Ah, ese\nlugar al que solían ir los Pokémon cuando\nquerían evolucionar."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_poppo, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_poppo) end)
  SkySceneKit.say({english="The guild seems to be buzzing\nwith purpose these days...", french="La Guilde fourmille d'activité\nces jours-ci...", german="Die Gilde scheint dieser Tage\nwichtiger denn je zu sein.", italian="In questi giorni alla Gilda\nsembrano molto indaffarati...", spanish="El [CS:N]Pokégremio[CR] ha estado muy\nactivo estos días..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 1] || scn($SCENARIO_MAIN) >= [22
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_poppo, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_poppo) end)
  SkySceneKit.say({english="It would be good to see [CS:N]Grovyle[CR]\nfinally captured.", french="Vivement que ce [CS:N]Massko[CR] soit\nenfin mis hors d'état de nuire.", german="Es wäre gut zu sehen, dass\n[CS:N]Reptain[CR] letztendlich gefasst würde.", italian="Sarebbe bello vedere [CS:N]Grovyle[CR]\nnelle mani della giustizia.", spanish="Sería un alivio que capturaran a\n[CS:N]Grovyle[CR] de una vez por todas."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 1] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_poppo, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_poppo) end)
  SkySceneKit.say({english="I had a really disgusting\ndrink there. It tasted terrible...", french="J'ai bu un truc absolument\naffreux ici. C'était écœurant!", german="Ich hatte dort einen\nungenießbaren Drink. Er schmeckte\nschrecklich...", italian="Ho bevuto un intruglio davvero\ndisgustoso. Aveva un saporaccio...", spanish="Me he tomado una bebida\nnauseabunda... ¡Puaj!"})
  pcall(function() UI:SetSpeaker(npc_npc_poppo) end)
  SkySceneKit.say({english="I'm not headed back to that\nshop again.", french="Hors de question que je remette\nles pattes dans ce café.", german="Dort werde ich so schnell nicht\nwieder hingehen.", italian="Non ne berrò mai\npiù un altro.", spanish="No pienso volver a ese sitio\nnunca más."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 1] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_poppo, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_poppo) end)
  SkySceneKit.say({english="There are many kinds of\ntreasures in the world.", french="Il existe toutes sortes de\ntrésors dans le monde.", german="Es gibt auf der Welt viele Arten\nvon Schätzen.", italian="Ci sono tanti tipi di tesori nel\nmondo.", spanish="Hay muchos tipos de tesoros en\neste mundo."})
  pcall(function() UI:SetSpeaker(npc_npc_poppo) end)
  SkySceneKit.say({english="We've traveled far searching\nfor those treasures.", french="On a voyagé dans des contrées\nlointaines à leur recherche.", german="Wir sind weit gereist auf der\nSuche nach diesen Schätzen.", italian="Noi siamo andati molto lontano\nalla ricerca di questi tesori.", spanish="Hemos viajado muy lejos para\nencontrar esos tesoros."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 4] || scn($SCENARIO_MAIN) >= [12
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_poppo, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_poppo) end)
  SkySceneKit.say({english=" How was your expedition?", french="Comment s'est passée votre\nexpédition?", german=" Wie war eure Expedition?", italian=" Com'è andata la spedizione?", spanish=" ¿Qué tal la expedición?"})
  pcall(function() UI:SetSpeaker(npc_npc_poppo) end)
  SkySceneKit.say({english="Did you happen to find\nany treasures?", french="Est-ce que vous avez mis la\nmain sur des trésors?", german="Habt ihr irgendwelche Schätze\ngefunden?", italian=" Avete trovato dei tesori?", spanish=" ¿Habéis encontrado tesoros?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_poppo, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_poppo) end)
  SkySceneKit.say({english="We're a two-member\nexploration team!", french="On est une équipe de deux\nexplorateurs!", german="Unser Erkundungsteam besteht\naus zwei Mitgliedern!", italian="Siamo una squadra d'esplorazione\nformata da due membri!", spanish="Somos un equipo explorador de\ndos miembros."})
  pcall(function() UI:SetSpeaker(npc_npc_poppo) end)
  SkySceneKit.say({english="We're [CS:N]Seedot[CR] and [CS:N]Pidgey[CR].[K]\nOur team name, [CS:X]Seedgey[CR], combines our names!", french="Nous sommes [CS:N]Grainipiot[CR] et\n[CS:N]Roucool[CR].[K] Le nom de notre équipe, [CS:X]Grainicool[CR],\nest une combinaison de nos deux noms!", german="Wir sind [CS:N]Samurzel[CR] und [CS:N]Taubsi[CR].[K]\nDer Name unseres Teams, [CS:X]Tauburzel[CR],\nkombiniert unsere Namen!", italian="Siamo [CS:N]Seedot[CR] e [CS:N]Pidgey[CR].[K] Il nome\ndella nostra squadra, [CS:X]Seedgey[CR], è la\ncombinazione dei nostri due nomi.", spanish="[CS:N]Seedot[CR] y [CS:N]Pidgey[CR].[K] ¡Y el nombre\nde nuestro equipo, [CS:X]Seedgey[CR], combina ambos\nnombres!"})
  pcall(function() UI:SetSpeaker(npc_npc_poppo) end)
  SkySceneKit.say({english=" So remember it!", french=" Souvenez-vous-en!", german=" Also präge ihn dir gut ein!", italian=" Quindi ricordatelo!", spanish="¡Así que no debéis tener\nproblemas para recordarlo!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 0] || scn($SCENARIO_MAIN) >= [3, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
