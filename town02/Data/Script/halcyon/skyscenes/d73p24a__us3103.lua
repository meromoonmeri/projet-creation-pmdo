-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P24A/us3103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_okutan = SkySceneKit.spawn_npc("octillery", 232, 144, Direction.Down, "NPC_OKUTAN")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_okutan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="It's terrible! I don't do anything\nother than trying to win at Big Treasure!", french="C'est terrifiant! Je passe tout\nmon temps à essayer de gagner à Méga Magot!", german="Es ist schrecklich! Meine einzige\nBeschäftigung ist es nun, zu versuchen, beim\nGroßen Schatz abzuräumen!", italian="È terribile! Non faccio altro\nche passare le giornate cercando di\nvincere qualcosa al Gran Tesoro!", spanish="¡Es un horror! ¡Lo único\nemocionante que hago es intentar\nganar en el Gran Tesoro!"})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english=" I can't go on like this!", french="Je ne peux pas continuer\ncomme ça!", german=" So kann ich nicht weitermachen!", italian=" Non posso andare avanti così!", spanish=" ¡Esto no puede seguir así!"})
  -- message_Close
  -- @label_131 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_okutan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="Ever since I came back from\n[CS:P]Sky Peak[CR], the daily routine has been\nkind of boring.", french="Depuis que je suis revenue du\n[CS:P]Pic Céleste[CR], le train-train quotidien\nme semble bien ennuyeux.", german="Der Alltag ist jetzt ganz schön\nlangweilig, seitdem ich vom [CS:P]Himmelsgipfel[CR]\nzurückgekehrt bin.", italian="Da quando sono tornata dal\n[CS:P]Picco del Cielo[CR], mi sembra che tutto sia\ndiventato così noioso.", spanish="Desde que volví de la [CS:P]Cumbre[CR]\n[CS:P]del Cielo[CR], la rutina diaria me resulta\nalgo aburridilla."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_okutan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="I'm done climbing the mountain\nfor now. I'll just relax here for a bit.", french="Mon ascension de la montagne\nest terminée. Je vais me reposer un peu ici.", german="Vom Bergsteigen habe ich jetzt\nerst einmal genug. Ich werde hier ein wenig\nausruhen.", italian="La mia scalata finisce qui, per\nora. Ne approfitterò per riposarmi un po'.", spanish="Ya he escalado bastante por el\nmomento, voy a relajarme aquí un rato."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 71] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="I got caught up in an avalanche\nnear the 7th Station Clearing!", french="J'ai été surprise par une\navalanche près de la trouée du 7[F:E] Relais!", german="In der Nähe der\n7. Zwischenlagerlichtung wurde ich\nsogar von einer Lawine überrascht!", italian="Dalle parti del Bivacco 7 sono\nstata travolta da una valanga!", spanish="Quedé atrapada en una avalancha\ncerca de la Base del Séptimo Puerto."})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="When I was buried in that cold\nsnow, I lost all hope!", french="Quand j'étais ensevelie sous\ncette neige glacée, j'ai perdu tout espoir!", german="Begraben vom kalten Schnee\nverlor ich alle Hoffnung!", italian="Quando tutta quella neve mi ha\nsepolta, mi sono sentita perduta!", spanish="Al verme cubierta de toda esa\nnieve tan fría, perdí toda esperanza."})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="Then I saw this glittering light,\nand someone came and rescued me...", french="Puis j'ai aperçu une lumière,\net quelqu'un est venu me secourir...", german="Dann sah ich dieses funkelnde\nLicht. Jemand kam und rettete mich...", italian="Poi ho visto questo luccichio e\nqualcuno che veniva a salvarmi...", spanish="Justo entonces vi una luz\nbrillante y alguien acudió en mi auxilio..."})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english=" Oh, [CS:N]Ampharos[CR]... My hero...", french=" Oh, [CS:N]Pharamp[CR]... Mon héros...", german=" Oh, [CS:N]Ampharos[CR]... Mein Held...", italian=" Oh, [CS:N]Ampharos[CR]... Mio eroe...", spanish=" Aish, [CS:N]Ampharos[CR]... Mi héroe..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 30] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_okutan, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="I...I climbed up here all on\nmy own!", french="Je... je suis montée ici\ntoute seule!", german="Ich... Ich bin hier ohne jede\nfremde Hilfe hochgeklettert!", italian="S-Sono salita fin quassù tutta\nda sola!", spanish="He subido hasta aquí arriba yo\nsolita... ¡de verdad!"})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="I...I didn't even use the\nGondola once!", french="Je... je n'ai pas utilisé la\nNavette une seule fois!", german="Ich... Ich habe die Seilbahn kein\neinziges Mal verwendet!", italian="N-Non ho usato l'Agenzia Viaggi\nnemmeno una volta!", spanish="¡No he usado la Góndola\nni una sola vez!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 26] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_okutan, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="Huh? The strange group at the\n5th Station Clearing weren't bad folks?", french="Hein? La drôle de bande à la\ntrouée du 5[F:E] Relais n'était pas\ncomposée de vauriens?", german="Echt? Diese seltsame Gruppe bei\nder 5. Zwischenlagerlichtung war gar keine\nAnsammlung schlechter Gesellen?", italian="Come? Quegli strani tipi\nal Bivacco 5 non erano cattivi?", spanish="¿Cómo? ¿Que el grupo raro de\nla Base del Quinto Puerto no era mala gente?"})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="Oh, no! I must have\nmisunderstooood!", french="Oh... oups! J'ai dû mal\ncomprendre, alors!", german="Oh nein! Ich habe es wohl falsch\nverstaaaaanden!", italian="Oh, no! Devo essermi\nsbagliaaaaaata!", spanish=" ¡Anda! Pues lo entendería mal."})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_okutan, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 20] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="Looks like there's a strange\ngroup near the 5th Station Clearing,\npicking fights with other explorers!", french="Une drôle de bande cherche\ndes noises aux autres explorateurs près\nde la trouée du 5[F:E] Relais!", german="Diese sonderbare Gruppe\nverwickelt bei der 5. Zwischenlagerlichtung\nandere Erkunder in Kämpfe, wie es aussieht!", italian="Dalle parti del Bivacco 5\nsi aggira uno strano gruppetto che\nattacca briga con altri esploratori!", spanish="Ese grupo tan raro que busca\npelea con otros exploradores está\nen la Base del Quinto Puerto."})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="I don't think I could handle them\non my own. I'd prefer to get someone to\ncome with me.", french="Je ne pense pas que je serais\ncapable d'en venir à bout toute seule. Il\nvaudrait mieux que quelqu'un m'accompagne.", german="Ich glaube kaum, dass ich allein\nmit denen fertig werden würde. Da hätte ich\nschon gerne jemanden bei mir.", italian="Non credo che riuscirei a\ntenergli testa da sola. Preferisco avere\nqualcuno al mio fianco.", spanish="No creo que pudiera enfrentarme\na ellos yo sola, sería mejor poder ir\ncon alguien."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 17] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english=" Hey, did you already find out?", french=" Hé, tu es au courant?", german=" Hey, hast du es schon gehört?", italian=" Ehi, avete saputo?", spanish=" Oye, ¿lo sabías?"})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="There's a rumor that this\nmountain hides many hidden places.", french="Une rumeur raconte que cette\nmontagne regorge de lieux cachés.", german="Es gibt ein Gerücht, laut dem\nes auf diesem Berg eine Menge geheimer\nOrte gibt.", italian="Gira voce che questa montagna\nnasconda molti luoghi segreti.", spanish="Se rumorea que en esta montaña\nse esconden muchos lugares misteriosos."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 11] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_okutan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="I wonder what can be found at\nthe summit.", french="Je me demande ce qu'on peut\ntrouver au sommet...", german="Ich frage mich, was man wohl\nauf dem Gipfel finden kann?", italian="Chissà che cosa si nasconde\nsulla cima?", spanish=" ¿Qué será lo que hay en la cima?"})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="Ooh!\nI'm so excited!!", french="Ooh!\nComme c'est excitant!!", german="Ooh!\nIch bin so aufgeregt!!!", italian="Oooh!\nNon sto nella pelle!!!", spanish=" ¡Caray! ¡Qué emoción!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 9) >= 0) or (SkyProg.cmp(29, 8) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 9] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_okutan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="Just how tall is a mountain that\ncan reach beyond the sky?", french="Une montagne qui s'élève\nau-delà du ciel, c'est grand comment?", german="Wie hoch muss ein Berg sein,\nder über den Himmel hinausragt?", italian="Ma quanto alta è una montagna\nche supera addirittura le nuvole?", spanish="¿Cómo de alta es una montaña\nque toca las nubes?"})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english=" I can't even imagine!", french=" Je n'arrive pas à me l'imaginer!", german="Das kann ich mir nicht\nmal vorstellen!", italian="Non riesco nemmeno\na immaginarmelo!", spanish=" ¡Es que no me lo imagino!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 6] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_okutan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="Maybe it's too late to say it,\nbut now I know the rumor about the world\nbeing at stake was true...", french="Il est peut-être trop tard pour\nle dire, mais maintenant je sais que la rumeur\nsur l'avenir du monde en jeu était vraie.", german="Vielleicht ein bisschen spät...\nIch weiß nun, dass das Gerücht über das\nSchicksal der Welt wahr gewesen ist...", italian="Forse è troppo tardi per\nammetterlo, ma ora mi rendo conto che\nle voci sul destino del mondo erano vere...", spanish="Igual ya es un poco tarde, pero\nsé de buena tinta que ese rumor sobre que el\nmundo estaba en peligro era cierto..."})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="But your team stopped it, right?\nI'm truly grateful! ♪", french="Mais ton équipe nous a\nsauvés, pas vrai?\nJe vous suis très reconnaissante! ♪", german="Aber dein Team hat sie gerettet,\nnicht wahr? Ich bin euch wirklich dankbar! ♪", italian="Ma la vostra squadra ha\nscongiurato il peggio, no? Ve ne sono\ndavvero grata! ♪", spanish="Pero tu equipo lo salvó, ¿no?\n¡Te lo agradezco muchísimo! ♪"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_okutan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="Hey, you! I heard a rumor\nthat the fate of the world is at stake.\nIs that true?", french="Hé! J'ai entendu dire que\nl'avenir du monde est en jeu. C'est vrai,\ncette histoire?", german="Hey, du da! Ich habe ein Gerücht\ngehört, dass das Schicksal der Welt auf dem\nSpiel steht. Stimmt das?", italian="Ehi, voi! Mi è giunta voce che\nil destino del mondo è in pericolo. È vero?", spanish="¡Eh, tú! Me ha llegado el rumor\nde que el mundo está en peligro,\n¿es eso cierto?"})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="It's a lie, right? It has to be.\nI don't know what I'd do otherwise.", french="C'est une farce, non? Pourvu\nque oui. Je ne sais pas ce que je ferais, sinon.", german="Das ist eine Lüge, nicht wahr?\nEs muss eine sein. Ich wüsste nicht, was ich\nsonst machen sollte.", italian="È una bugia, vero? Deve essere\ncosì, altrimenti non saprei cosa fare.", spanish="Es una trola, ¿verdad? Fijo,\nvamos. Si fuera verdad, no sabría qué hacer."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_okutan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="I love to hear [CS:N]Wobbuffet[CR]\nblurt out, \"That's right!\" when someone wins\non a [CS:I]Prize Ticket[CR].", french="J'adore entendre [CS:N]Qulbutoké[CR]\ns'exclamer \"Banco!\" quand un [CS:I]Ticket Magot[CR]\nest gagnant.", german="Ich liebe es, wenn [CS:N]Woingenau[CR]\n[F:S2]Ganz genau![F:E2] sagt, sobald jemand mit einem\n[CS:I]Preisticket[CR] gewinnt.", italian="Adoro sentire [CS:N]Wobbuffet[CR]\nche urla \"Perfetto!\" quando viene estratto\nun [CS:I]Buono Premio[CR] vincente.", spanish="Me encanta cuando [CS:N]Wobbuffet[CR]\nsuelta: \"¡Eso, eso!\" cuando alguien gana un\npremio con un [CS:I]boleto[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="Oh... I'd love to hear her yell\nthat again...", french="Oh... J'adorerais l'entendre crier\nça encore une fois...", german="Oh... Wie gerne würde ich sie\ndas jetzt rufen hören...", italian="Oh... Quanto mi piacerebbe\nsentirglielo gridare un'altra volta...", spanish="Jo... Lo que daría por volver a\noírle gritar eso..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 1] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_okutan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="I'm really enjoying the \"Big\nTreasure\" [CS:I]Prize Tickets[CR] at the Recycle Shop.\nI can't get enough!", french="Je trouve ça génial, ces [CS:I]Tickets\nMagot[CR] de chez \"Méga Magot\", à la Bourse\nd'Echange. Je ne peux plus m'en passer!", german="[F:S2]Großer Schatz[F:E2]-[CS:I]Preistickets[CR]\nvom Wiederverwertungsladen sind genial!\nVon denen krieg ich nicht genug!", italian="I [CS:I]Buoni Premio[CR] del Gran Tesoro\nche estraggono al Centro Riciclo sono\nfantastici. Non riesco a farne a meno!", spanish="Tengo un montón de [CS:I]boletos[CR] del\n\"Gran Tesoro\" del Reciclaje Explorador,\n¡pero quiero aún más!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_okutan, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="I wonder if I'll win on my very\nfirst [CS:I]Prize Ticket[CR]. Ho-ho-ho!", french="Je me demande si mon premier\n[CS:I]Ticket Magot[CR] va être gagnant. Ho ho ho!", german="Ich frage mich, was ich für\nmein allererstes [CS:I]Preisticket[CR] bekomme.\nHo-oh-oh!", italian="Chissà se con il mio primo\n[CS:I]Buono Premio[CR] vincerò qualcosa. Oh oh oh!", spanish="Me pregunto si tendré la suerte\ndel principiante con mi primer [CS:I]boleto[CR], ¡jo, jo!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_okutan, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english=" One day, I'll win big!", french=" Un jour, je gagnerai le gros lot!", german="Eines Tages werde ich groß\nabräumen!", italian="Un giorno farò una grossa\nvincita!", spanish="¡Algún día me tocará\nel premio gordo!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 4] || scn($SCENARIO_MAIN) >= [12
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_okutan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="I went out exploring with a\nfriend once, long ago. It was a lot of fun.", french="Une fois, il y a longtemps,\nje suis partie en exploration avec un ami.\nC'était très sympa.", german="Ich bin vor langer Zeit einmal\nmit einem Freund auf Erkundung gewesen.\nDas hat viel Spaß gemacht.", italian="Tanto tempo fa, ho partecipato\na un'esplorazione con un mio amico. Mi sono\ndivertita un sacco.", spanish="Hace mucho me fui a explorar\ncon un amigo y me lo pasé bomba."})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english=" It's a wonderful memory.", french=" C'est un souvenir merveilleux.", german=" Eine wunderbare Erinnerung.", italian=" Che ricordi meravigliosi.", spanish="Tengo muy buenos recuerdos\nde aquella vez."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_okutan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="Project P is cool, but what\nI'm interested in most are the [CS:I]Prize Ticket[CR]\ndrawings going on at the Recycle Shop.", french="Le Projet P est cool, mais ce\nqui m'intéresse le plus, c'est les [CS:I]Tickets Magot[CR]\nqu'on peut utiliser à la loterie Méga Magot.", german="Projekt P ist cool. Nur was mich\nviel mehr interessiert, sind die [CS:I]Preistickets[CR],\ndie es im Wiederverwertungsladen gibt.", italian="Il Progetto P è grandioso, ma\nla cosa che mi interessa di più è l'estrazione\ndei [CS:I]Buoni Premio[CR] al Centro Riciclo.", spanish="El Proyecto P es una pasada,\npero me interesan más los sorteos con [CS:I]boletos[CR]\ndel Reciclaje Explorador."})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="I should try and see what\nI can win...", french="Je devrais essayer et voir ce\nque je peux gagner...", german="Ich sollte es versuchen und\nherausfinden, was ich dafür bekomme.", italian="Dovrei provarci e vedere\nse riesco a vincere qualcosa...", spanish="Debería probar a ver qué\nme toca..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 6] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_okutan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="When you recycle, you can trade\nup for even more amazing items...", french="En échangeant des objets,\ntu peux recevoir des objets tous plus\nfascinants les uns que les autres.", german="Bei der Wiederverwertung\nkannst du noch viel tollere Items erhalten...", italian="Quando ricicli, puoi scambiare\ndegli strumenti e ottenerne alcuni incredibili...", spanish="Al reciclar, puedes conseguir\nobjetos de lo más increíble..."})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="I'm not being deceived, right?\nThis is OK?", french="Je ne me fais pas avoir, non?\nC'est bon?", german="Ich werde nicht getäuscht,\nrichtig? Das ist okay so?", italian="Non mi sto sbagliando, vero?\nHo ragione?", spanish="No me la están colando, ¿no?\nEs un buen trato, ¿a que sí?"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 3] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_okutan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="I absolutely love drinks made\nwith [CS:I]Apples[CR]. I can't get enough of them!", french="Je raffole des boissons\nà base de [CS:I]Pommes[CR].\nJe ne m'en lasse pas!", german="Ich liebe Drinks, die aus dem\nItem [CS:I]Apfel[CR] gemacht sind.\nVon denen kann ich nicht genug bekommen!", italian="Vado pazza per le bevande\npreparate con le [CS:I]Mele[CR]. Non riesco a farne\na meno!", spanish="Me encantan las bebidas hechas\nde [CS:I]Manzanita[CR]. ¡Nunca me canso de tomarlas!"})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="They're just delicious drinks, but\nthat's enough for me![K] Or so I thought.\nI keep drinking them...", french="Elles n'ont finalement rien de\nparticulier à part leur goût, mais ça me va.[K]\nEnfin, je continue à en boire...", german="Die sind einfach unerhört lecker,\ndas reicht mir auch schon.[K] Ich kann einfach\nnicht damit aufhören, sie zu trinken...", italian="Non avranno nessun effetto, ma\nsono deliziose e tanto mi basta![K] O almeno\ncredo. Non riesco a smettere di berle...", spanish="Solo sirven para degustarlas,\npero ya me basta.[K] O eso pensaba, porque\nno paro de tomármelas..."})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="But! Spinda said he had \"a\ngood feeling\" about this one drink, and when\nI drank it, my attack power increased!", french="Spinda m'a dit qu'il avait \"un bon\npressentiment\" à propos de cette boisson.\nEt quand je l'ai bue, mon Attaque a augmenté!", german="Aber Pandir sagte einst, er habe\n[F:S2]ein erstaunlich gutes Gefühl[F:E2] bei einem Drink.\nAls ich ihn trank, stieg mein Angriffswert!", italian="Ma poi Spinda mi ha detto che\nquesta bevanda gli dava \"una bella sensazione\".\nQuando l'ho bevuta la mia potenza è aumentata!", spanish="Pero Spinda dijo que tenía una\ncorazonada con una bebida y, cuando me\nla tomé, ¡me aumentó el Ataque!"})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="I thought that drinks made using\nan [CS:I]Apple[CR] or an [CS:I]Oran Berry[CR] wouldn't have any\neffect, but it looks like I was wrong!", french="Je pensais que les boissons à\nbase de [CS:I]Pommes[CR] ou de [CS:I]Baies Oran[CR] n'avaient\naucun effet, mais on dirait que j'avais tort!", german="Ich war überzeugt, dass Drinks\naus den Items [CS:I]Apfel[CR] oder [CS:I]Sinelbeere[CR] keinen\nEffekt haben würden, aber ich lag falsch!", italian="Pensavo che le bevande\npreparate con una [CS:I]Mela[CR] o una [CS:I]Baccarancia[CR]\nnon avessero effetto, ma mi sbagliavo!", spanish="Pensaba que las bebidas de\n[CS:I]Manzanita[CR] y [CS:I]Baya Aranja[CR] no servían para\nnada, pero parece que me equivoqué."})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="The Juice Bar is really\nwonderful.", french="Le Bar à Jus est vraiment\nformidable.", german=" Die Saftbar ist echt wundervoll.", italian="Il Barsucco è davvero\nfantastico.", spanish="Los Zumos Spinda\nson una auténtica maravilla."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 6] || scn($SCENARIO_MAIN) >= [7, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_okutan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="I had collected a bunch of\n[CS:I]Apples[CR], so I had some drinks made.", french="J'ai ramassé tout un tas de\n[CS:I]Pommes[CR], alors j'ai fait préparer\nquelques boissons avec.", german="Ich habe eine Ladung [CS:I]Äpfel[CR]\ngesammelt. Aus ihnen habe ich mir ein paar\nDrinks machen lassen.", italian="Avevo raccolto un sacco di\n[CS:I]Mele[CR], così mi sono fatta preparare\ndelle bevande.", spanish="Tenía un montón de [CS:I]Manzanitas[CR],\nasí que me fui a que me hicieran un zumo."})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="The drinks were so fresh and\njuicy...and delicious...[K]\nBut that was it...", french="Les boissons étaient vraiment\nfraîches et juteuses... et délicieuses...[K]\nMais c'est tout...", german="Die Drinks waren so frisch\nund saftig und lecker...[K]\nDas war's auch schon...", italian="Erano così fresche, dolci e...\ndeliziose...[K]\nMa a parte questo...", spanish="Debo admitir que las bebidas\nestaban riquísimas... y fresquitas...[K]\nPero nada más..."})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="I thought my Belly would be\nfilled and my HP would be restored...", french="Je pensais que ça me remplirait\nl'Estomac et restaurerait mes PV...", german="Ich dachte, sie würden meinen\nMagen füllen und meine KP würden\nwiederhergestellt...", italian="Credevo che avrei riempito\nla pancia e recuperato i miei PS...", spanish="Pensaba que me llenarían la\nTripa y recuperaría mis PS..."})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="It seems like a drink made from\nan [CS:I]Apple[CR] or an [CS:I]Oran Berry[CR] has no effect.", french="Il semblerait qu'une boisson\nfaite à base de [CS:I]Pommes[CR]\nou de [CS:I]Baies Oran[CR] n'ait aucun effet.", german="Aber es scheint fast so, als ob\nDrinks aus den Items [CS:I]Apfel[CR] oder [CS:I]Sinelbeere[CR]\nkeinen Effekt haben.", italian="Sembra che una bevanda\npreparata con una [CS:I]Mela[CR] o una [CS:I]Baccarancia[CR]\nnon abbia effetto.", spanish="Pero por lo visto las bebidas de\n[CS:I]Manzanita[CR] o [CS:I]Baya Aranja[CR] no tienen\nningún efecto."})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="Well, at any rate, it was\ndelicious, so I'm not too disappointed.", french="Mais bon, c'était délicieux,\nalors je ne suis pas trop déçue.", german="Na, auf jeden Fall war es lecker,\ndaher bin ich nicht zu sehr enttäuscht.", italian="Beh, in ogni caso erano deliziose,\nquindi non sono così delusa.", spanish="En cualquier caso, estaba\nde rechupete, así que no me quejo."})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="I wonder if there's an effect\nwhen you use a Gummi...", french="Je me demande s'il y a un\neffet spécial quand on utilise une gelée...", german="Ich frage mich, ob der Drink\nmit einem Gummi als Zutat eine andere\nWirkung hätte...", italian="Chissà se usando una Gomma\nsuccede qualcosa...", spanish="Me pregunto si habrá algún\nefecto al usar una gomi..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 2] || scn($SCENARIO_MAIN) >= [7, 
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
