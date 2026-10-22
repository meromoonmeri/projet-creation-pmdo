-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P04A/um0607.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_pachirisu = SkySceneKit.spawn_npc("pachirisu", 208, 184, Direction.Up, "NPC_PACHIRISU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pachirisu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="Have you heard of [CS:K]Shaymin[CR]'s\nDelivery Service?", french="Tu as entendu parler du\n[CS:K]Service de Livraison Shaymin[CR]?", german="Hast du schon vom\n[CS:K]Shaymin-Lieferservice[CR] gehört?", italian="Hai mai sentito parlare del\nServizio Consegne [CS:K]Shaymin[CR]?", spanish="¿Has oído hablar de los\n[CS:K]Repartos Shaymin[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="It's a service that will deliver\n[CS:I]Sky Gift[CR]s to others.", french="C'est un service qui permet\nde faire livrer des [CS:I]Dons du Ciel[CR].", german="Das ist ein Service, der in\ndeinem Namen [CS:I]Himmelspräsente[CR] zustellt.", italian="È un servizio che recapita\n[CS:I]Doni Cielo[CR] agli altri.", spanish="Es un servicio que se dedica a la\nentrega de [CS:I]Regalos Cielo[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="The shop is near the [CS:P]Shaymin\nVillage[CR]'s entrance. You should check it\nout sometime.", french="Le magasin est à proximité\nde l'entrée du [CS:P]Village Shaymin[CR].\nTu devrais aller y faire un tour, une fois.", german="Der Laden befindet sich beim\nEingang von [CS:P]Shaymin-Dorf[CR]. Du solltest den\nLieferservice mal ausprobieren!", italian="Il negozio si trova vicino\nall'entrata del [CS:P]Villaggio Shaymin[CR]. Dovresti\nfarci un salto qualche volta.", spanish="Se encuentra cerca de la entrada\nde [CS:P]Aldea Shaymin[CR]. Deberías\necharle un vistazo cuando tengas un momento."})
  -- message_Close
  -- @label_131 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pachirisu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english=" I haven't returned in a while...", french="Ça fait un moment que je ne\nsuis pas retourné là-bas...", german="Ich bin schon eine Weile nicht\nmehr hier gewesen...", italian="È da un bel po' che non ne\nrestituisco uno...", spanish=" Hace tiempo que no vuelvo..."})
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="I wanted a [CS:I]Sky Gift[CR], so I've\nbeen exploring [CS:P]Sky Peak[CR] for some time.", french="Je voudrais trouver un\n[CS:I]Don du Ciel[CR], alors j'explore\nle [CS:P]Pic Céleste[CR] depuis quelque temps.", german="Ich wollte mal wieder ein\n[CS:I]Himmelspräsent[CR], also habe ich ein wenig den\n[CS:P]Himmelsgipfel[CR] erkundet.", italian="Desideravo tanto un [CS:I]Dono Cielo[CR],\necco perché ho esplorato il [CS:P]Picco del Cielo[CR]\nin lungo e in largo.", spanish="Quería un [CS:I]Regalo Cielo[CR], así que\nme he pasado un tiempo explorando la [CS:P]Cumbre[CR]\n[CS:P]del Cielo[CR]."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 71] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="The [CS:I]Sky Gift[CR]s I received in\nreturn had all sorts of wonderful items inside.", french="Les [CS:I]Dons du Ciel[CR] que j'ai reçus\nen retour avaient toutes sortes de super\nobjets à l'intérieur.", german="Die [CS:I]Himmelspräsente[CR], die ich\nim Austausch bekam, enthielten alle\nwundervolle Items.", italian="Il [CS:I]Dono Cielo[CR] che ho ricevuto in\ncambio conteneva degli strumenti meravigliosi.", spanish="Los [CS:I]Regalos Cielo[CR] que he recibido\na cambio tenían todo tipo de objetos increíbles."})
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="Once I used the items, I made\nit to the summit before I knew it!", french="Grâce à ces objets, j'ai atteint\nle sommet en un clin d'œil!", german="Mithilfe dieser Items habe ich\nes zum Gipfel geschafft, ehe ich wusste, was\nlos war!", italian="Dopo averli usati, sono arrivato\nin cima alla montagna in un batter d'occhio!", spanish="¡En cuanto usé los objetos,\nllegué a la cima en un periquete!"})
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="[CS:I]Sky Gift[CR]s are such\nwonderful treasures!", french="Les [CS:I]Dons du Ciel[CR] sont\ndes trésors fabuleux!", german="[CS:I]Himmelspräsente[CR] sind solch\nwunderbare Schätze!", italian="I [CS:I]Doni Cielo[CR] sono dei tesori\nstupendi!", spanish="¡Los [CS:I]Regalos Cielo[CR]\nson unos tesoros maravillosos!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 30] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="Phew... The 4th Station\nClearing, huh?", french="Pfiou...\nEnfin la trouée du 4[F:E] Relais, hein?", german="Puh... Sind wir endlich an der\n4. Zwischenlagerlichtung?", italian=" Fiuuu... Ecco qua il Bivacco 4...", spanish="Fiu... La Base del Cuarto\nPuerto por fin, ¿eh?"})
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="As I find a [CS:I]Sky Gift[CR], I search\nfor someone to give it to... I'm not\nmaking much progress.", french="A chaque fois que je trouve un\n[CS:I]Don du Ciel[CR], je cherche quelqu'un à qui\nl'offrir... je n'ai pas vraiment progressé.", german="Sobald ich ein [CS:I]Himmelspräsent[CR]\nfinde, halte ich Ausschau nach jemandem, dem\nich es geben kann... Na ja, noch suche ich.", italian="Dato che ho trovato\nun [CS:I]Dono Cielo[CR], sto cercando qualcuno a cui\nregalarlo... ma senza successo finora.", spanish="Cada vez que encuentro un\n[CS:I]Regalo Cielo[CR], busco a alguien a quien dárselo...\nAsí que no estoy avanzando demasiado."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 26] || scn($SCENARIO_MAIN) >= [2
  if ((SV.SkyTalkBitFlags or {})[125] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[125]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english=" Huh? Thanks for the gift?", french="Comment?\nMerci pour le cadeau?", german="Huch? Du willst dich für das\nGeschenk bedanken?", italian="Eh? Vuoi ringraziarmi per\nil regalo?", spanish="¿Cómo? ¿Que gracias\npor el regalo?"})
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english=" You're more than welcome!", french=" Mais c'est tout à fait naturel!", german="Das ist wirklich nicht der\nRede wert!", italian=" Non c'è di che!", spanish=" ¡Nada, nada, un placer!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english=" I heard [CS:N]Shaymin[CR] talking earlier...", french="J'ai entendu parler [CS:N]Shaymin[CR]\ntout à l'heure...", german="Vorhin habe ich [CS:N]Shaymin[CR]\nreden hören...", italian="Prima ho sentito [CS:N]Shaymin[CR] che\ndiceva qualcosa...", spanish=" Antes he oído hablar a [CS:N]Shaymin[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english=" I did find a [CS:I]Sky Gift[CR]...", french="J'ai trouvé un [CS:I]Don du Ciel[CR],\nc'est vrai...", german="Ich habe ein [CS:I]Himmelspräsent[CR]\ngefunden...", italian=" Ho trovato un [CS:I]Dono Cielo[CR]...", spanish=" Encontré un [CS:I]Regalo Cielo[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="Team [team:] saved the\nworld, and I owe you for many things, so...", french="L'Equipe [team:] a sauvé\nle monde, et je te dois beaucoup, alors...", german="Team [team:] hat die Welt\ngerettet. Ich bin euch wohl etwas schuldig.\nUnd jetzt, wo du hier bist...", italian="Il Team [team:] ha salvato\nil mondo e vi sono debitore, per cui...", spanish="[CS:X]Equipo[CR] [team:], desde que\nsalvasteis el mundo tengo tanto\nque agradeceros..."})
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="I always wanted to show you\nmy appreciation.", french="... j'ai toujours voulu te\nmontrer ma reconnaissance.", german="Da kann ich dir endlich meine\nAnerkennung zeigen.", italian="... dato che ho sempre voluto\ndimostrarvi la mia riconoscenza...", spanish="Siempre quise mostraros\nmi agradecimiento."})
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english=" So please accept this from me!", french="Alors voilà, accepte ceci\nde ma part!", german=" Bitte nimm das von mir!", italian="Per favore, accettate questo da\nparte mia!", spanish=" Así que aceptad esto."})
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_BAG_FULL"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_BAG_FULL, 0, 0)) [ProcessSpecial(PROCESS_SPECIAL_IS_BAG_FULL): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[125] = 1 -- $SCENARIO_TALK_BIT_FLAG[125] = 1 (ROM)
  -- item_SetTableData(0, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(ProcessSpecial(PROCESS_SPECIAL_ADD_TABLE_ITEM_TO_BAG, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8710) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="[CN][player] received\n[CN]a [CS:I]Sky Gift[CR].", french="[CN][player] reçoit\n[CN]un [CS:I]Don du Ciel[CR].", german="[CN][player] erhält\n[CN]ein [CS:I]Himmelspräsent[CR].", italian="[CN][player] ha ricevuto\n[CN]un [CS:I]Dono Cielo[CR].", spanish="[CN][player] ha obtenido\n[CN]un [CS:I]Regalo Cielo[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="[CN]You gently open the lid...", french="[CN]Vous ouvrez délicatement le couvercle...", german="[CN]Du öffnest behutsam den Deckel...", italian="[CN]Apri lentamente il pacchetto...", spanish="[CN]Abres la tapa con cuidado..."})
  -- message_Close
  -- GAP: se_Play(11021) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="[CN]Inside was the\n[CN][s_item:0]!", french="[CN]A l'intérieur se trouve l'objet\n[CN][s_item:0]!", german="[CN]Im Paket liegt das Item\n[CN][s_item:0]!", italian="[CN]... e al suo interno trovi lo strumento\n[CN][s_item:0]!", spanish="[CN]¡Había un objeto\n[CN][s_item:0] dentro!"})
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="[CN]A warm and fuzzy feeling falls over you...", french="[CN]Que c'est agréable de recevoir un cadeau...", german="[CN]Ein warmes, angenehmes Kribbeln\n[CN]überkommt dich...", italian="[CN]Una dolce sensazione di calore ti investe...", spanish="[CN]Te invade una sensación de calidez..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="...Or so I thought, but you seem\nto have too many items already.", french="... Enfin, je te l'aurais\nvolontiers offert, mais on dirait\nque tu n'as pas de place.", german="...Zumindest hatte ich mir das so\ngedacht, aber du hast anscheinend schon zu\nviele Items.", italian="O almeno è quello che avrei\nvoluto, ma pare che abbiate già troppi\nstrumenti con voi.", spanish="Vaya, por lo visto ya tenéis\ndemasiados objetos."})
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english=" Hmm... That's too bad...", french=" Hum... Quel dommage...", german=" Hmm... Wirklich zu schade...", italian=" Mmmh... Peccato...", spanish=" Hum... Qué lástima..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  elseif (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 9) >= 0) or (SkyProg.cmp(29, 8) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 15] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pachirisu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="I wonder if any new drink\ningredients can be found around [CS:P]Sky Peak[CR]...", french="Je me demande si on peut\ntrouver de nouveaux ingrédients\nau [CS:P]Pic Céleste[CR]...", german="Ich frage mich, ob es rund um\nden [CS:P]Himmelsgipfel[CR] irgendeine\nneue Zutat für einen Drink gibt...", italian="Chissà se dalle parti del\n[CS:P]Picco del Cielo[CR] si possono trovare altri\ningredienti per preparare delle bevande...", spanish="Me pregunto si habrá\ningredientes nuevos en la [CS:P]Cumbre del Cielo[CR]..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 6] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pachirisu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="It's thanks to you guys that I'm\neven able to sit here enjoying\nsuch delicious drinks.", french="C'est grâce à vous si je peux\nêtre ici à siroter de délicieuses boissons.", german="Ich muss euch danken. Dank euch\nkann ich hier sitzen und entspannt solch\nköstliche Drinks genießen!", italian="È grazie a voi due se posso\nstare seduto qui a bere queste bevande\ndeliziose.", spanish="Gracias a vuestra actuación\npuedo relajarme y disfrutar de estas bebidas\ntan ricas."})
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english=" Thanks, Team [team:].", french=" Merci, Equipe [team:].", german=" Danke, Team [team:].", italian=" Grazie, Team [team:].", spanish=" Gracias, [CS:X]Equipo[CR] [team:]."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pachirisu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="Different things happen when\nyou consume many of these drinks...", french="Plein de choses peuvent arriver\nau Bar à Jus...", german="Ganz unterschiedliche Sachen\nkönnen passieren, wenn du viele dieser Drinks\nzu dir nimmst.", italian="Quando bevi tanti succhi\ndel genere accadono un sacco di cose...", spanish="No se sabe qué puede pasar si te\ntomas muchas bebidas..."})
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="I usually get a really tasty\ndrink, but the last one I had was\njust terrible...", french="D'ordinaire, on me sert toujours\nde très bonnes boissons, mais la dernière était\nune horreur...", german="Normalerweise bekomme ich\nwirklich geschmackvolle Drinks, aber der\nletzte, den ich hatte, war einfach grauselig...", italian="Di solito le bevande che prendo\nsono deliziose, ma l'ultima aveva un sapore\norribile...", spanish="Normalmente me tomo algo\nriquísimo, pero la última vez me tocó\nalgo repugnante..."})
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="But [CS:N]Spinda[CR] always has such a\nhappy grin on his face, I wasn't able to\nbring myself to tell him it was terrible...", french="Mais [CS:N]Spinda[CR] est toujours si\naimable, je n'ai pas eu le courage de lui\ndire que c'était imbuvable.", german="Aber [CS:N]Pandir[CR] hat immer so ein\nnettes Lächeln auf dem Gesicht... Ich brachte\nes nicht übers Herz, es ihm zu sagen...", italian="Però [CS:N]Spinda[CR] ha sempre quel\nsorriso felice dipinto in volto e non me la\nsono sentita di lamentarmi...", spanish="Pero [CS:N]Spinda[CR] te mira con tal\ncara de felicidad que no me atreví a decirle\nque no había quién se bebiera aquello..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pachirisu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english=" Hey, listen up!", french=" Hé, écoute ça!", german=" Hey, hör mal zu!", italian=" Ehi, senti un po'!", spanish=" ¡Oye, escúchame!"})
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="I was here having a juice drink\nas usual, and something really cool happened!", french="J'étais assis là, à boire un jus\ncomme d'habitude, quand quelque chose\nde vraiment super m'est arrivé!", german="Ich habe hier wie üblich einen\nFruchtsaft genossen, als etwas Unglaubliches\npassierte!", italian="Ero qui che bevevo il mio solito\nsucco quando è accaduto qualcosa di\nincredibile!", spanish="Me estaba tomando algo aquí,\ncomo siempre, cuando pasó algo sensacional."})
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="Once I finished my drink, I\nfound \"Win!\" written on the bottom of\nmy glass!", french="Après avoir fini ma boisson,\nj'ai vu le mot \"Gagné!\" inscrit sur le fond\nde mon verre!", german="Als ich meinen Drink geleert\nhatte, sah ich [F:S2]Gewonnen![F:E2] auf dem Boden\nmeines Glases geschrieben!", italian="Dopo aver finito di bere, ho\ntrovato la scritta \"Hai vinto\" sul fondo\ndel mio bicchiere!", spanish="Me acabo la bebida y, ¿qué me\nencuentro? ¡\"Has ganado\", escrito en el fondo\ndel vaso!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_pachirisu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="I busted out laughing!\nAh ha ha ha!", french="J'ai éclaté de rire!\nAh ha ha ha!", german="Ich habe losgeprustet vor\nLachen! Ah ha ha ha!", italian="Sono scoppiato a ridere!\nAh ah ah!", spanish="¡Me partí de la risa!\n¡Jua, ja, ja, ja!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_pachirisu, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="There are such surprises here\nat the Juice Bar!", french="On a de ces surprises ici,\nau Bar à Jus!", german="Hier in der Saftbar gibt es\nsolche Überraschungen!", italian="Qui al Barsucco le sorprese non\nfiniscono mai!", spanish="¡Los Zumos Spinda tienen\nun montón de sorpresas!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 1] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pachirisu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english=" Hey, listen, listen.", french=" Hé, écoute, écoute.", german=" Hey, hör mal zu, hör mal zu.", italian=" Ehi, ascolta, ascolta!", spanish=" Oye, escucha."})
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="The last time I had a drink here,\nthis stranger came up to me and gave me\nan Egg.", french="La dernière fois que j'ai pris\nun verre ici, un inconnu est venu vers moi\net m'a donné un Œuf.", german="Als ich das letzte Mal hier einen\nDrink hatte, kam ein Fremder zu mir und gab\nmir ein Ei.", italian="L'ultima volta che ho preso una\nbevanda qui, è arrivato un tizio mai visto e\nmi ha dato un Uovo.", spanish="La última vez que me tomé algo\naquí se me acercó un desconocido\ny me dio un Huevo."})
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english=" These drinks sure are special.", french="Ces boissons ont vraiment\nquelque chose de spécial.", german="Diese Drinks sind\nwirklich einzigartig.", italian="Queste bevande sono davvero\nspeciali.", spanish="Qué especiales son\nestas bebidas."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 4] || scn($SCENARIO_MAIN) >= [12
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pachirisu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="[CS:N]Murkrow[CR]'s been over there\nfor a while now.", french="[CS:N]Cornèbre[CR] et [CS:N]Polichombr[CR]\nsont là-bas depuis quelque temps, maintenant.", german="[CS:N]Kramurx[CR] steht nun schon\neine Weile dort.", italian="È da un po' che [CS:N]Murkrow[CR]\ne [CS:N]Shuppet[CR] si trovano qui.", spanish="[CS:N]Murkrow[CR] y [CS:N]Shuppet[CR] llevan\nya un buen rato allí."})
  -- message_KeyWait
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pachirisu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="It looks like those two are\nhaving a hard time deciding what to order.", french="On dirait qu'elles ont du mal\nà décider ce qu'elles veulent prendre.", german="Anscheinend können sich die\nZwei dort nicht entscheiden, was sie\nbestellen sollen.", italian="Pare che non sappiano proprio\ncosa ordinare.", spanish="Por lo visto les está costando\nlo suyo decidir qué se toman."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pachirisu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english=" Where are you headed?", french=" Où est-ce que tu vas?", german="Wohin geht eure nächste\nErkundung?", italian=" Te ne vai da qualche parte?", spanish=" ¿Adónde te diriges?"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pachirisu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="Project P is cool, but I think\nthe Juice Bar is as cool.", french="Le Projet P est cool, mais je\npense que le Bar à Jus l'est tout autant.", german="Projekt P ist cool, aber meiner\nMeinung nach ist die Saftbar mindestens\ngenauso cool.", italian="Il Progetto P è troppo forte, ma\nsecondo me anche il Barsucco non è niente\nmale.", spanish="El Proyecto P es muy chulo, pero\nlos Zumos Spinda no le andan a la zaga."})
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="The last time I had one of the\ndrinks here, I made a new friend.", french="La dernière fois que j'ai pris un\nverre ici, je me suis fait un nouvel ami.", german="Das letzte Mal, als ich hier einen\nDrink hatte, habe ich einen neuen\nFreund getroffen.", italian="L'ultima volta che ho preso una\nbevanda qui, mi sono fatto un nuovo amico.", spanish="La última vez que me tomé algo\nhice un nuevo amigo y todo."})
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="It's like \"juice-drink harmony\" or\nsomething.[K] Pretty cool, huh? Drinks, I mean.", french="C'est comme une \"symphonie\nde jus frais\".[K] Plutôt classe, hein?", german="Wohl so etwas wie die\n[F:S2]Harmonie der Safttrinkenden[F:E2].[K] Nicht schlecht,\noder? Die Drinks, meine ich.", italian="È una specie di\n\"miscela perfetta\" o qualcosa di simile.[K]\nBello, eh? Tutte queste bevande, intendo.", spanish="Es algo así como \"el buen rollo\nde los zumos\".[K] Mola, ¿eh? El zumo, digo."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 3] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pachirisu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english=" Hey, listen, listen.", french=" Hé, écoute, écoute.", german=" Hey, hör mal zu, hör mal zu.", italian=" Ehi, ascolta, ascolta!", spanish=" Oye, escucha."})
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="I ordered a drink here before,\nand I got this \"amazing miracle drink\" or\nsomething!", french="J'ai commandé un verre ici tout\nà l'heure, et j'ai reçu cette \"boisson\nmiraculeuse\", ou quelque chose comme ça!", german="Ich habe vorhin einen Drink\nbestellt und dann bekam ich einen\n[F:S2]unglaublichen Wunder-Drink[F:E2]. Oder so!", italian="Prima ho ordinato qualcosa\nda bere e mi hanno dato questa\n\"bevanda miracolosa\" o una roba simile!", spanish="Antes pedí una bebida y me\ndieron \"la bebida prodigiosa\" o algo así."})
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="I heard it rarely gets made, but\nit was incredibly delicious.", french="J'ai entendu dire qu'on la\nprépare très rarement, mais c'était\nfollement délicieux!", german="Ich habe gehört, dass so einer\nnur selten zubereitet wird. Es war\nunbeschreiblich lecker.", italian="Ho sentito che viene preparata\nraramente, ma era incredibilmente deliziosa.", spanish="Por lo que me han dicho, casi\nnunca la hacen, pero estaba riquísima."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 6] || scn($SCENARIO_MAIN) >= [7, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pachirisu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="If you bring in a favorite\ningredient, you can have a delicious\ndrink made.", french="Si tu apportes un de tes\ningrédients favoris, tu peux faire\npréparer une boisson délicieuse avec.", german="Wenn du die bevorzugte Zutat\ndabeihast, kannst du dir einen leckeren Drink\nmixen lassen.", italian="Se porti il tuo ingrediente\npreferito, puoi farti preparare una bevanda\ndeliziosa.", spanish="Si traes algún ingrediente que\nte guste, te harán una bebida deliciosa."})
  -- message_KeyWait
  GROUND:EntTurn(npc_npc_pachirisu, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english="Hmm... What should I do...?\nI should splurge and have a drink made with\nmy [CS:I]Yellow Gummi[CR]...", french="Hum... Que devrais-je faire...?\nJe devrais faire des folies et demander qu'on\nme prépare une boisson avec ma [CS:I]Gelée Jaune[CR]...", german="Hmm... Was soll ich tun? Ich\nsollte mal etwas protzen und mir einen Drink\nmit meinem [CS:I]Gelbgummi[CR] mixen lassen...", italian="Mmmh... Che dovrei fare...?\nDare fondo ai miei risparmi e farmi preparare\nuna bevanda con la mia [CS:I]Gommagialla[CR]?", spanish="Hum... ¿Qué hago...?\nDebería tirar la casa por la ventana y hacerme\nuna bebida con mi [CS:I]Gomi Ámbar[CR]..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 2] || scn($SCENARIO_MAIN) >= [7, 
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
