-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/us0402.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 456, 272, Direction.Up, "NPC_DIGUDA")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_diguda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Oh, [hero] and\n[partner]!", french="Hé, [hero] et\n[partner]!", german="Oh, [hero] und\n[partner]!", italian="Oh, [hero] e\n[partner]!", spanish="¡Hombre, [hero] y\n[partner]!"})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="I'm happy to see you! Are you\nvisiting us?", french="Content de vous revoir!\nVous venez nous rendre visite?", german="Ich freue mich, euch zu sehen!\nBesucht ihr uns?", italian="Sono contento di vedervi! Siete\nqui in visita?", spanish="¡Me alegro de veros! ¿Venís\nde visita?"})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="By the way...[K] Have you seen my\ndad anywhere?", french="Au fait...[K] Vous n'auriez pas vu\nmon père?", german="Übrigens...[K] Habt ihr meinen\nVater gesehen?", italian="A proposito...[K] Avete visto mio\npadre da qualche parte?", spanish="Por cierto...[K] ¿Habéis visto\na mi padre por ahí?"})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="I haven't seen him for a while.\nI'm beginning to get worried...", french="Ça fait un moment que je ne l'ai\npas vu. Ça commence à m'inquiéter...", german="Ich habe ihn eine Weile nicht\ngesehen. So langsam fange ich an, mir Sorgen\nzu machen...", italian="Non lo vedo da un po'. Comincio\na essere preoccupato...", spanish="Hace tiempo que no le veo. Estoy\nempezando a preocuparme..."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 93] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_diguda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="I'm glad to see your team back\nsafely, [hero]!", french="Je suis heureux que tu sois\nde retour indemne, [hero]!", german="Es freut mich, euer Team\nunversehrt zurück zu sehen, [hero]!", italian="Sono contento di vedervi di\nnuovo qui, [hero]!", spanish="¡Me alegro de verte de vuelta\npor aquí, [hero]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_diguda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="I hope your team does well,\n[hero]!", french="J'espère que ton équipe s'en\nsortira, [hero]!", german="Ich hoffe, euer Team schlägt\nsich gut, [hero]!", italian="Spero che la tua squadra ce la\nfaccia, [hero]!", spanish="¡Espero que todo salga bien,\n[hero]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_diguda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="It sounds like a challenging\ndungeon, that [CS:P]Aegis Cave[CR].", french="La [CS:P]Grotte Egide[CR] a l'air d'un\ndonjon difficile.", german="Hört sich wie ein\nherausfordernder Dungeon an, diese [CS:P]Ägishöhle[CR].", italian="Sembra un dungeon impegnativo,\nquella [CS:P]Grotta Egida[CR].", spanish="La [CS:P]Cueva Regia[CR] debe de ser todo\nun reto."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 55]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_diguda, 4) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Ugh...[K] I would love to go too...", french="Ooh...[K] J'adorerais y aller\nmoi aussi...", german="Hmpf...[K] Ich würde auch gerne\ngehen...", italian="Uh...[K] Piacerebbe anche a me\nandarci...", spanish="Uf...[K] Me encantaría ir a mí\ntambién..."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="But [CS:N]Loudred[CR] is all set and raring\nto go...[K] He's beaten me to the punch.", french="Mais [CS:N]Ramboum[CR] est prêt et\nil est impatient d'y aller...[K] Il m'a pris de court.", german="Aber [CS:N]Krakeelo[CR] ist entschlossen\nund brennt darauf, zu gehen...[K] Er ist mir\nzuvorgekommen.", italian="Ma [CS:N]Loudred[CR] è gia pronto ed è\nimpaziente di andare...[K] È stato più veloce di\nme.", spanish="Pero [CS:N]Loudred[CR] ya está preparado\ny con muchas ganas de ir...[K] Se me ha\nadelantado."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="I'll have to stay behind at the\nguild to look after the sentry post.", french="Il faut que je reste à la Guilde\npour m'occuper du poste de guet.", german="Ich werde in der Gilde\nzurückbleiben müssen, um nach dem\nWachposten zu sehen.", italian="Dovrò restare a fare la guardia\nalla Gilda.", spanish="Tendré que quedarme en el\n[CS:N]Pokégremio[CR] para encargarme de vigilar."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_diguda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" ...........................", french=" ...........................", german=" ...........................", italian=" ...........................", spanish=" ..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 3] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_diguda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Excuse me?![K] The grand master of\nall things bad?!", french="Pardon?![K] Le grand maître de\ntous les maux?!", german="Entschuldigt bitte?!?[K] Der\nGroßmeister allen Übels?!?", italian=" Scusa?![K] Sua Malvagità?", spanish="¿Cómo?[K] ¿El gran malo\nrequetemalo?"})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="I...I really can't tell you...[K]\nPlease, I just can't...", french="Je... je ne peux rien vous dire...\nJe vous en prie, je n'ai pas le droit...", german="Ich... Ich kann es euch wirklich\nnicht sagen...[K] Bitte, ich kann es wirklich\nnicht...", italian="Io... davvero, non te lo posso\ndire...[K] Mi spiace, è solo che non posso...", spanish="No puedo deciros nada...[K] Es que\nno puedo..."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" I'm so sorry...", french=" Je suis vraiment désolé...", german=" Es tut mir so leid...", italian=" Mi dispiace tanto...", spanish=" Lo siento..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_diguda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Oh, [partner] and\n[hero]!", french="Hé, [partner] et\n[hero]!", german="Oh, [partner] und\n[hero]!", italian="Oh, [partner] e\n[hero]!", spanish="¡Oh, [partner] y\n[hero]!"})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="My thoughts go with you![K]\nGood luck!", french="Mes pensées vous accompagnent!\nBonne chance!", german="In Gedanken bin ich bei euch![K]\nViel Glück!", italian=" Vi penserò![K] In bocca al lupo!", spanish="¡Ojalá os vaya bien![K]\n¡Buena suerte!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_diguda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Ugh...[K] Our team was wiped out\nas well.", french="Argh...[K] Notre équipe aussi a été\nvaincue.", german="Hmpf...[K] Unser Team wurde auch\nbesiegt.", italian="Uh...[K] Anche la nostra squadra\nè stata sconfitta.", spanish="Uf...[K] También han derrotado a\nnuestro equipo."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="But we won't give up! We'll do\nour best!", french="Mais on n'abandonnera pas!\nOn se donnera à fond!", german="Aber wir geben nicht auf! Wir\ngeben unser Bestes!", italian="Ma non molleremo! Ce la\nmetteremo tutta!", spanish="¡Pero no nos rendiremos!\n¡Lo haremos lo mejor posible!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 3] || scn($SCENARIO_MAIN) >= [23
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_diguda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="I'm helping to get word out\nabout what really happened.", french="J'aide à répandre la nouvelle\nde ce qui s'est réellement passé.", german="Ich helfe dabei, zu verbreiten,\nwas wirklich geschehen ist.", italian="Sto cercando di capire\ncos'è successo davvero.", spanish="Estoy ayudando a difundir lo\nque sucedió en realidad."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="The others are finding it hard to\nbelieve right away...", french="Les autres Pokémon trouvent ça\ndifficile à croire au début...", german="Die anderen können das so ohne\nWeiteres nur schwer glauben...", italian=" Gli altri stentano a crederlo...", spanish="A los demás les cuesta\ncreérselo así de golpe..."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" But I'll do my best!", french=" Mais je ferai de mon mieux!", german="Aber ich werde mein Bestes\ngeben!", italian=" Ma farò del mio meglio!", spanish="¡Pero haré todo lo que esté\nen mi mano!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 424, 272, Direction.Up, "NPC_DOGOOMU")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_diguda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Yes, [CS:N]Loudred[CR]!", french=" Oui, [CS:N]Ramboum[CR]!", german=" Ja, [CS:N]Krakeelo[CR]!", italian=" Sì, [CS:N]Loudred[CR]!", spanish=" ¡Sí, [CS:N]Loudred[CR]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 1] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_diguda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Hey![K] [hero]!\n[partner]!", french="Hé![K] [hero]!\n[partner]!", german="Hey![K] [hero]!\n[partner]!", italian="Ehi![K] [hero]!\n[partner]!", spanish="¡Eh![K] ¡[hero]!\n¡[partner]!"})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="This is my first time out on an\nexpedition, so I'm a little nervous.", french="C'est ma première expédition,\nalors je suis un peu nerveux.", german="Das ist meine erste Expedition,\ndeswegen bin ich ein wenig aufgeregt.", italian="È la prima volta che partecipo\na una spedizione... Sono un po' nervoso.", spanish="Es la primera vez que salgo de\nexpedición, así que estoy nerviosillo."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="But let's be sure to make this a\nsuccess!", french="Mais faisons en sorte\nque ce soit un succès!", german=" Aber lasst uns erfolgreich sein!", italian="Ma se ci impegniamo a fondo,\nsarà un successo!", spanish="¡Hay que asegurarse de que\nsea un éxito!"})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Incidentally...", french=" A propos...", german=" Übrigens...", italian=" A proposito...", spanish=" A propósito..."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Do you know anything about the\nSecret Bazaar, [hero]?", french="Tu as entendu parler\ndu Bazar Secret, [hero]?", german="Weißt du etwas über den\nGeheimbasar, [hero]?", italian="Hai mai sentito parlare del\nBazar Segreto, [hero]?", spanish="¿Sabes algo del\nBazar Secreto, [hero]?"})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="I haven't seen it either, but...[K]\nA rumor tells me that the Secret Bazaar is...", french="Je ne l'ai pas encore vu, moi non\nplus...[K] mais on raconte que le Bazar Secret...", german="Ich habe ihn auch noch nicht\ngesehen...[K] Einem Gerücht zufolge ist\nder Geheimbasar...", italian="Io non l'ho mai trovato, ma...[K]\na quanto si dice, il Bazar Segreto è...", spanish="Yo tampoco lo he visto, pero...[K]\ncircula el rumor de que es..."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="A mysterious facility that\nappears occasionally in dungeons...", french="... est un endroit mystérieux qui\napparaît parfois dans les donjons...", german="Nun, er scheint wohl eine\nmysteriöse Einrichtung zu sein, die ab und zu\nin Dungeons auftaucht...", italian="... un luogo misterioso che\nappare di tanto in tanto nei dungeon.", spanish="Un local misterioso que aparece\na veces en los territorios."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="You can heal your wounds and\neven buy a Grab Bag there, so I hear...", french="On peut s'y faire soigner et\nmême y acheter des Pochettes Surprises.", german="Dort kannst du deine Wunden\nheilen und sogar eine Wundertüte kaufen,\nhabe ich gehört...", italian="Lì puoi curare le tue ferite e\ncomprare addirittura un Sacco Sorpresa...\nma non solo!", spanish="Por lo visto puedes curarte y\nhasta hacerte con una Bolsa Sorpresa."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Several kinds of shops\nare there.", french="Il paraît qu'il abrite plusieurs\nmagasins!", german="Und es gibt dort wohl\nverschiedene Läden!", italian="Pare che ci siano un sacco di\naltri negozi!", spanish=" Tiene varios tipos de tiendas."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="I wonder what other shops can\nbe found there...[K] I'd love to find out\nfor myself...", french="Je me demande quel genre de\nmagasins on peut trouver là-bas...[K]\nJ'adorerais aller vérifier par moi-même...", german="Ich frage mich, welche anderen\nLäden es dort wohl gibt...[K] Ich würde es gerne\nselbst herausfinden...", italian="Chissà di che negozi si tratta...[K]\nmi piacerebbe un sacco scoprirlo.", spanish="Me pregunto qué otras tiendas\nhabrá...[K] Me encantaría verlo\ncon mis propios ojos."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Maybe there's a chance we can\nfind the Secret Bazaar on our expedition?", french="Avec un peu de chance\non tombera sur le Bazar Secret\npendant notre expédition...", german="Vielleicht ist es ja möglich,\ndass wir auf unserer Expedition einen\nGeheimbasar entdecken?", italian="Magari troveremo un Bazar\nSegreto durante la nostra spedizione...", spanish="Quizá tengamos ocasión de hallar\nel Bazar Secreto durante nuestra expedición."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Ooh, I'm so excited!", french=" Oh, comme c'est excitant!", german=" Oooh, ich bin so aufgeregt!", italian=" Oooh, non sto nella pelle!", spanish=" ¡Uf, no me aguanto los nervios!"})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="If you happen to find the\nSecret Bazaar, [hero], be sure to tell\nme all about it!", french="Si jamais tu trouves le Bazar\nSecret, [hero], tu me préviens, promis?", german="Wenn du einen Geheimbasar\nfinden solltest, [hero], sag mir auf\njeden Fall Bescheid!", italian="[hero], se dovessi\nimbatterti in un Bazar Segreto, voglio\nche mi racconti tutto!", spanish="[hero], si logras hallar\nel Bazar Secreto, ¡me lo tienes que contar\ncon pelos y señales!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7] || scn($SCENARIO_MAIN) >= [8, 
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[26] = 1 -- $SCENARIO_TALK_BIT_FLAG[26] = 1 (ROM)
  -- SetAnimation(2) [anim idle native]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 360, 272, Direction.UpRight, "NPC_DAGUTORIO")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_diguda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" My son.", french=" Notre fils.", german=" Mein Sohn.", italian=" Figlio.", spanish=" Hijo mío."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_dagutorio, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Yes, Dad?", french=" Oui, père?", german=" Ja, Papa?", italian=" Sì, papà?", spanish=" ¿Sí, papá?"})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Why did you call me out here?", french="Pourquoi est-ce que tu m'as fait\nvenir ici?", german="Warum hast du mich hierher\nbestellt?", italian=" Perché mi hai fatto venire qui?", spanish="¿Para qué me has hecho venir\naquí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" See?[K] The sea is vast.", french="Tu vois?[K] Contemple comme\nla mer est vaste.", german=" Siehst du?[K] Das Meer ist riesig.", italian=" Vedi?[K] Il mare è immenso.", spanish=" ¿Ves?[K] El mar es inmenso."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Um, yes... But why are you\ntelling me this?", french="Euh, oui... Mais pourquoi est-ce\nque tu me racontes tout ça?", german="Ähm, ja... Aber warum erzählst\ndu mir das?", italian="Uhm, sì... Ma perché mi dici\nquesto?", spanish="Hum, sí... Pero, ¿a qué viene\nesto?"})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" I'm supposed to be working, Dad.", french="Je devrais retourner au travail,\npère.", german="Ich sollte bei der Arbeit sein,\nPapa.", italian=" Dovrei essere al lavoro, papà.", spanish=" Debería estar trabajando, papá."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="If I don't go back soon, I'll get\nan earful from [CS:N]Loudred[CR].", french="Si je n'y retourne pas très vite,\n[CS:N]Ramboum[CR] va me passer un savon.\nIl va encore crier comme un sourd!", german="Wenn ich nicht bald zurückgehe,\nbekomme ich Ärger mit [CS:N]Krakeelo[CR].", italian="Se non torno presto, [CS:N]Loudred[CR] mi\nfarà una lavata di capo.", spanish="Si no vuelvo pronto, [CS:N]Loudred[CR] me\nechará la bronca."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" You'll be scolded?", french=" Un savon?", german=" Man wird dich ausschimpfen?", italian=" Una lavata di capo?", spanish=" ¿Te van a regañar?"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Why let such a paltry matter\ncloud your thoughts?", french="Pourquoi laisser un problème si\ndérisoire assombrir tes pensées?", german="Warum lässt du deine Gedanken\nvon solch einer geringfügigen Angelegenheit\neinhüllen?", italian="Perché farsi annebbiare la\nmente da un pensiero così banale?", spanish="¿Por qué dejar que una cuestión\ntan irrelevante nuble tu cabeza?"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Broaden your perspective...[K]\nLike the sea before you.", french="Ouvre ton esprit...[K]\nComme la mer devant toi.", german="Erweitere deine Perspektive...[K]\nSo wie das Meer vor dir.", italian="Amplia la tua prospettiva...[K]\nCome il mare di fronte a te.", spanish="Expande tus horizontes...[K] como\nel mar ante ti."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" I don't know what that means!", french="Mais je n'y comprends rien à ton\ntruc, moi, père!", german="Ich weiß nicht, was das\nbedeuten soll!", italian=" Non capisco cosa vuoi dire!", spanish="No entiendo lo que me quieres\ndecir."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="I'm going back to the guild.[K]\nI want to be chosen for the expedition.", french="Je retourne à la Guilde.[K]\nJe veux être sélectionné pour l'expédition.", german="Ich gehe zurück zur Gilde.[K] Ich\nwill für die Expedition ausgewählt werden.", italian="Torno alla Gilda.[K] Voglio essere\nscelto per la spedizione.", spanish="Me vuelvo al [CS:N]Pokégremio[CR].[K]\nQuiero que me elijan para la expedición."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Dad, you should quit wasting\ntime here and get back to work.[K] See you.", french="Père, arrête de perdre ton\ntemps ici et retourne à ton poste.[K] A plus.", german="Papa, du solltest aufhören, hier\ndeine Zeit zu verschwenden, und wieder zurück\nan die Arbeit gehen.[K] Bis später.", italian="Papà, dovresti smetterla di star\nqui a perdere tempo e tornare a lavoro.[K]\nCi vediamo.", spanish="Papá, deberías dejar de perder\nel tiempo y ponerte a trabajar.[K] Adiós."})
  -- message_Close
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  -- GAP: se_Play(6422) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 6) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 6]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_diguda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Team [CS:X]Skull[CR] is kind of scary...", french="L'Equipe [CS:X]Crâne[CR] me donne\nfroid dans le dos...", german="Team [CS:X]Totenkopf[CR] ist ziemlich\nunheimlich...", italian="Il Team [CS:X]Teschio[CR] ha qualcosa\ndi sinistro...", spanish="El [CS:X]Equipo Calavera[CR] da un poco\nde miedo..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 3] || scn($SCENARIO_MAIN) >= [7, 
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_diguda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Let's do a good job again today,\n[CS:N]Loudred[CR]!", french="Faisons notre travail du mieux\nque nous pouvons, [CS:N]Ramboum[CR]!", german="Leisten wir heute wieder gute\nArbeit, [CS:N]Krakeelo[CR]!", italian="Impegniamoci al massimo anche\noggi, [CS:N]Loudred[CR]!", spanish="¡Hagamos un buen trabajo,\n[CS:N]Loudred[CR]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [6, 5] || scn($SCENARIO_MAIN) >= [6, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_diguda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Thank you for covering my\nsentry shift!", french="Merci de m'avoir remplacé pour\nmon tour de garde!", german="Danke, dass ihr meine Wache\nübernommen habt!", italian="Grazie per aver coperto il mio\nturno di guardia!", spanish="¡Gracias por cubrir mi turno\nde vigilancia!"})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="I may have to ask you again.\nI hope you'll cover for me then!", french="Je vous demanderai peut-être\nde me rendre à nouveau ce service.\nJ'espère que cela ne vous dérangera pas!", german="Ich werde euch eventuell noch\neinmal fragen müssen. Ich hoffe, ihr werdet\nmich dann vertreten!", italian="Può darsi che ve lo chieda di\nnuovo. Spero che potrete sostituirmi ancora!", spanish="Tal vez tenga que pedíroslo en\notra ocasión. Espero que podáis ayudarme\ntambién."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 7]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_diguda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Let's do our best, [CS:N]Loudred[CR]!", french="Faisons de notre mieux,\n[CS:N]Ramboum[CR]!", german="Geben wir unser Bestes,\n[CS:N]Krakeelo[CR]!", italian=" Diamoci dentro, [CS:N]Loudred[CR]!", spanish=" ¡A por todas, [CS:N]Loudred[CR]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_diguda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Yes![K] I'll try my hardest!", french=" Oui![K] Je ferai de mon mieux!", german="Ja![K] Ich werde mein Möglichstes\ntun!", italian=" Sì![K] Ce la metterò tutta!", spanish=" ¡Sí![K] ¡Me esforzaré al máximo!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
