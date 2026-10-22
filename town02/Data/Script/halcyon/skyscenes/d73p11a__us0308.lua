-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P11A/us0308.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_kinogassa = SkySceneKit.spawn_npc("breloom", 280, 232, Direction.Down, "NPC_KINOGASSA")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kinogassa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="It's time for us to move on and\ndiscover new areas that no one's seen before.", french="Il est temps pour nous de\nreprendre la route et de partir explorer\ndes territoires inconnus.", german="Es ist an der Zeit, dass wir\nweiterziehen und neue Gebiete erkunden, die\nnoch niemand vor uns gesehen hat.", italian="Ora dobbiamo ripartire\ne scoprire nuovi luoghi in cui nessuno\nha ancora messo piede.", spanish="Ya es hora de seguir adelante y\ndescubrir zonas que nadie haya visto antes."})
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="If there happens to be a new\ndiscovery, we will let you know!", french="Si on fait une nouvelle\ndécouverte, on vous préviendra.", german="Wenn es eine neue Entdeckung\ngibt, lassen wir es euch wissen!", italian="Se scopriremo qualcosa di nuovo,\nve lo faremo sapere!", spanish="Si resulta que descubrimos algo,\nya te lo contaremos."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 53] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kinogassa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="We've been working pretty hard\nfor [CS:N]Spinda[CR], so he gave us the day off.", french="On a travaillé plutôt dur pour\n[CS:N]Spinda[CR], alors ils nous a accordé\nune journée de congé.", german="Wir haben ziemlich hart für\n[CS:N]Pandir[CR] gearbeitet, daher hat er uns einen Tag\nfreigegeben.", italian="Abbiamo lavorato molto sodo per\n[CS:N]Spinda[CR], così ci ha dato un giorno libero.", spanish="Trabajamos muy duro para\n[CS:N]Spinda[CR], así que nos ha dado el día libre."})
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="[CS:N]Shaymin[CR] are really easy to get\nalong with and hospitable. We were thinking of\njust relaxing here for a while.", french="Les [CS:N]Shaymin[CR] sont vraiment\nagréables et accueillants. On pensait passer\nun peu de temps ici pour se reposer.", german="Mit [CS:N]Shaymin[CR] kann man wirklich\ngut auskommen. Und sie sind so gastfreundlich!\nWir gedenken noch eine Weile hierzubleiben.", italian="È facile andare d'accordo con\ni Pokémon [CS:N]Shaymin[CR]... sono così ospitali!\nPensavamo di rimanere qui a rilassarci un po'.", spanish="Los [CS:N]Shaymin[CR] son de lo más\nhospitalario y amable, así que igual\nnos quedamos por aquí a relajarnos un rato."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 39] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kinogassa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="Hey![K] That last exploration was\nincredible, huh?", french="Hé![K] Cette dernière exploration\nétait incroyable, pas vrai?", german="Hey![K] Die letzte Erkundung war\nunglaublich, nicht wahr?", italian="Ehi![K] L'ultima esplorazione è stata\ngrandiosa, non è vero?", spanish="¡Oye![K] Esa última exploración\nfue de traca, ¿eh?"})
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="I'm still shaking a little from\nflying down here from the summit!", french="On est redescendus du sommet\nde la montagne par la voie des airs!\nJ'en frissonne encore!", german="Ich zittere immer noch ein wenig\nvon dem Flug vom Gipfel hier herunter!", italian="Ho ancora il batticuore per il\nvolo che ho fatto per tornare quaggiù!", spanish="¡Todavía tengo un poco de\ntembleque por bajar volando desde la cima!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 30] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="We should do what [CS:N]Ampharos[CR]\nsays and head for the summit.", french="[CS:N]Pharamp[CR] nous a dit de\nreprendre notre ascension\nvers le sommet.", german="[CS:N]Ampharos[CR] sagte uns,\nwir sollten zum Gipfel eilen.", italian="Dovremmo seguire il consiglio di\n[CS:N]Ampharos[CR] e raggiungere la cima.", spanish="[CS:N]Ampharos[CR] nos dijo que podíamos\nsubir a la cima."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 25] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english=" It's dangerous if you don't hurry.", french=" Dépêche-toi, il y a urgence!", german="Wenn du dich nicht beeilst, kann\nes gefährlich werden.", italian="Sbrigatevi o vi troverete\nin pericolo.", spanish=" Si no te das prisa es un peligro."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 23] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="You can't judge based on\nappearance... Let me tell you.", french="Il ne faut pas se fier aux\napparences... Crois-moi.", german="Hör gut zu. Verlass dich beim\nUrteilen nicht darauf, wie etwas scheint.", italian="Non puoi esprimere un giudizio\nin base all'aspetto... Credi a me.", spanish="Deja que te diga que no se puede\njuzgar a la gente por las apariencias..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 19] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_kinogassa, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="Over there is one of those\nubiquitous Kangaskhan Rocks.", french="Là-bas, il y a une de ces Statues\nKangourex qu'on trouve un peu partout.", german="Dort drüben ist einer jener\nallgegenwärtigen Kangama-Speicher.", italian="Laggiù c'è una di quelle\nonnipresenti Statue Kangaskhan.", spanish="Ahí hay una de esas Rocas de\nKangaskhan que están por todos lados."})
  -- message_KeyWait
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kinogassa, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="Make sure to store anything\nvaluable you don't want to lose!", french="Assure-toi bien de placer dans la\nréserve les objets importants\nque tu ne veux pas perdre!", german="Lagere dort alle\nWertgegenstände, die du nicht verlieren\nwillst!", italian="Se non si vuole perdere\nqualcosa di prezioso, bisogna depositarlo!", spanish="¡Asegúrate de guardar cualquier\ncosa valiosa que no quieras perder!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 13] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kinogassa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="Yo! I'm [CS:N]Breloom[CR]. I'm part of the\nsurvey team.", french="Bonjour! Je suis [CS:N]Chapignon[CR].\nJe fais partie de l'équipe de reconnaissance.", german="Jau! Ich bin [CS:N]Kapilz[CR]. Ich gehöre\nzum Vermessungsteam.", italian="Yo! Mi chiamo [CS:N]Breloom[CR].\nSono un membro della squadra d'indagine.", spanish="¡Buenas! Soy [CS:N]Breloom[CR], formo\nparte del equipo de reconocimiento."})
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="I thought I'd take on this\nmountain before anyone else got here\nto see how it is, you know?", french="Je me suis dit que j'aimerais\nbien escalader cette montagne seul avant\nque les autres n'arrivent.", german="Ich wollte mir den Berg schon\nmal allein vornehmen, bevor der Rest des\nTeams ihn zu sehen bekommt, verstehst du?", italian="Stavo pensando di precedere\ni miei compagni per dare un'occhiata\nal cammino che ci aspetta...", spanish="Me apetecía subir aquí antes que\nnadie para tener información privilegiada."})
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="But you know, the dungeon\nis pretty tough!", french="Mais, figurez-vous que le donjon\nest plutôt corsé!", german="Aber weißt du, der Dungeon ist\nleider ganz schön schwierig!", italian="... ma il dungeon è davvero\ndifficile!", spanish="¡Pero resulta que el territorio\nes bastante dificilillo!"})
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="It's so complex that\na rescue request can't be sent...", french="Il est si compliqué qu'aucune\ndemande de sauvetage ne peut être envoyée...", german="Er ist so komplex, dass man\nkeine Hilfe anfordern kann...", italian="È talmente complesso che non è\npossibile richiedere un Pronto Intervento...", spanish="Tanto que no se puede ni mandar\nuna petición de rescate..."})
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="All collected treasures can be...\nPoof! Gone!", french="Tous les trésors ramassés\npeuvent... pouf! s'envoler!", german="Alle gesammelten Schätze...\nPuff! Weg!", italian="Tutti i tesori raccolti possono...\nPuf! Sparire nel nulla!", spanish="Si te descuidas, los tesoros...\n¡Puf! ¡Desaparecen!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 8] || scn($SCENARIO_MAIN) >= [29
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
