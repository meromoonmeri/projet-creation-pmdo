-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/um0306.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 376, 248, Direction.Up, "NPC_KIMAWARI")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="I'm going to explore all over\nagain today!", french="Je recommence l'exploration de\nzéro, aujourd'hui!", german="Ich werde heute wieder überall\nerkunden gehen!", italian="Anche oggi andrò in giro ad\nesplorare!", spanish="¡Hoy voy a volver a explorar\ntodo de nuevo!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Oh my! There's no telling what\ntraps are in store for you!", french="Ouh mince alors! Impossible de\nsavoir quels pièges vous attendent!\nC'est trop bizarre!", german="Oje! Es ist völlig unklar,\nwelche Fallen euch erwarten werden!", italian="Shock! Chissà quante trappole\ndovrete affrontare!", spanish="¡A saber qué trampas os\nencontraréis!"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Please, please be careful!", french="Je vous en prie, je vous en\nsupplie, je vous en conjure, faites attention!", german=" Bitte, bitte seid vorsichtig!", italian=" Vi prego, fate attenzione!", spanish=" ¡Por favor, id con cuidado!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="What do you suppose exploring\na dream would be like?", french="C'est comment, tu crois,\nd'explorer un rêve?", german="Was meinst du, wie die\nErkundung eines Traumes aussieht?", italian="Come pensate che sia esplorare\nun sogno?", spanish=" ¿Cómo será explorar un sueño?"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Oh my gosh! I can't\neven imagine!", french="Ben mince alors! Je n'en ai pas\nla moindre idée, moi!", german="Du meine Güte! Ich kann es mir\nnicht mal vorstellen!", italian="Shock! Non riesco nemmeno a\nimmaginarlo!", spanish=" ¡Jo! ¡No puedo ni imaginármelo!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 73] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="[CS:P]Mt. Travail[CR] is to the\neast of here.", french=" Le [CS:P]Mt Labeur[CR] est à l'est d'ici.", german="Der [CS:P]Mühsalberg[CR] befindet sich\nöstlich von hier.", italian="Il [CS:P]Monte Odissea[CR] si trova\nad est di qui.", spanish="El [CS:P]Monte Tribulaciones[CR] está\nal este."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Good luck!", french=" Bonne chance!", german=" Viel Glück!", italian=" Buona fortuna!", spanish=" ¡Buena suerte!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 71] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="That Team [CS:X]Charm[CR]! Oh my gosh!\nThey were so cool!", french="Mais alors, vraiment, cette\nEquipe [CS:X]Charme[CR]! Waouh!\nElles sont trop cool, c'est l'hallu!", german="Aber dieses Team [CS:X]Charme[CR]! Du\nmeine Güte! Sie waren so unglaublich cool!", italian="Ma quel Team [CS:X]Malia[CR]! Aah!\nErano davvero favolose!", spanish="¡Vaya, el [CS:X]Equipo Carisma[CR]!\n¡Jo! ¡Eran increíbles!"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Just thinking about them makes\nme go, \"Oh...my...gosh!\"", french="Quand je pense à elles, c'est plus\nfort que moi! Faut que je crie: OH... LA... LA!", german="Nur an sie zu denken, ringt mir\nschon ein [F:S2]Du meine Güte![F:E2] ab.", italian="Il solo pensiero...\nShock! Mi scombussola tutta!", spanish="Solo de pensar en ellas...\n¡Ay, qué emoción!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 56) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="I've heard from [CS:N]Loudred[CR]\nand his team.", french="[CS:N]Ramboum[CR] et son\néquipe m'ont raconté un truc.", german="Ich habe von [CS:N]Krakeelo[CR] und\nseinem Team gehört.", italian="Me l'hanno detto [CS:N]Loudred[CR] e la\nsua squadra.", spanish="[CS:N]Loudred[CR] y su equipo me han\ndicho..."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="That [CS:P]Aegis Cave[CR] sounds quite\nchallenging.", french="A ce qu'on dit, la [CS:P]Grotte Egide[CR],\nc'est un vrai défi pour les explorateurs.", german="Diese [CS:P]Ägishöhle[CR] klingt nach\neiner echten Herausforderung.", italian="Quella [CS:P]Grotta Egida[CR] sembra\nimpegnativa.", spanish="Que la [CS:P]Cueva Regia[CR] es todo\nun reto."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="I was thinking of mounting my\nown challenge, but...[K]I'm going to pass...", french="Je pensais tenter ma chance\nmoi aussi, mais... [K]finalement, je crois que\nje vais passer mon tour...", german="Ich habe darüber nachgedacht,\nmir eine eigene Herausforderung zu suchen,\naber[K] ich werde es wohl lassen.", italian="Pensavo di raccogliere la\nsfida, ma...[K]\nRinuncerò...", spanish="Estaba pensando en ir yo sola... [K]\npero creo que será mejor que me olvide."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 55]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Yippee! I mean, yip-yip-yippee!", french="Youpiii! Ou plutôt,\nyoup-youp-youpiii!", german="Hurra! Ich meinte natürlich\nhip, hip, hurra!", italian="Shock! Cioè,\nshock, shock, shock!", spanish="¡No me lo puedo creer!\n¡Es supergenial!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Let's make it another super day!", french="Encore une super journée devant\nnous!", german=" Auf einen weiteren tollen Tag!", italian=" Che sia un altro grande giorno!", spanish="¡A disfrutar de otro gran día\ntrabajando!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 52) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 52]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Let's try to be cheerful! ♪", french=" Tâchons de garder le moral! ♪", german="Versuchen wir, heiter\nzu sein! ♪", italian="Proviamo a mantenere il buon\numore! ♪", spanish=" ¡Hay que ser optimistas! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 50] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="I'm worried for that baby\n[CS:N]Manaphy[CR]...", french="Je me fais une sève d'encre\npour ce bébé, [CS:N]Manaphy[CR]...", german="Ich mache mir Sorgen um das\nkleine [CS:N]Manaphy[CR]...", italian="Sono preoccupata per quel\npiccolo [CS:N]Manaphy[CR]...", spanish="Me preocupa el pequeño\n[CS:N]Manaphy[CR]..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 48] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="You're saying that you found that\nbaby's Egg at the [CS:P]Surrounded Sea[CR]?", french="Vous dites que vous avez trouvé\ncet Œuf dans la [CS:P]Mer Fermée[CR]?", german="Ihr sagt, ihr habt das Ei im\n[CS:P]Ringmeer[CR] gefunden?", italian="State dicendo che avete trovato\nl'Uovo di quel piccoletto nel [CS:P]Mar Cinto[CR]?", spanish="¿Dices que habéis encontrado\nun Huevo en el [CS:P]Mar Circundante[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Oh my gosh! How mysterious!", french="Oh là là! Comme c'est\nmystérieux! Ben mince alors!", german="Du meine Güte! Wie\ngeheimnisvoll!", italian=" Shock! Che mistero!", spanish="¡No me lo puedo creer! ¡Eso sí\nque es un misterio!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 41) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 41]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Apparently, all the world's ocean\ncurrents flow through the [CS:P]Surrounded Sea[CR].", french="Apparemment, tous les courants\nocéaniques du monde passent par la [CS:P]Mer\nFermée[CR].", german="Anscheinend fließen alle\nOzeanströmungen der Welt durch das\n[CS:P]Ringmeer[CR].", italian="Pare che tutte le correnti di\ntutti i mari del mondo passino per il\n[CS:P]Mar Cinto[CR].", spanish="Al parecer, todas las corrientes\nmarinas del mundo fluyen a través del [CS:P]Mar[CR]\n[CS:P]Circundante[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Rumor has it that many rare\ntreasures have washed ashore there.", french="Selon certaines rumeurs,\nles flots ont déposé sur ses plages des\nquantités de trésors hyper rares.", german="Gerüchten zufolge wurden dort\nviele Schätze an Land gespült.", italian="Dicono che laggiù si siano\narenati molti tesori rari.", spanish="Se dice que muchos tesoros\nacaban arrastrados a la orilla."})
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Oh my gosh! Just thinking about\nthat makes me feel faint!", french="Ben mince alors! Rien que d'y\npenser, je me sens toute chose!", german="Du meine Güte! Bloß daran zu\ndenken, macht mich schon schwach!", italian="Shock! Solo a pensarci mi\nsento svenire!", spanish="¡Me tiemblan los pétalos de\nemoción!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="The way to the [CS:P]Surrounded Sea[CR]\nis from the sea to the east of [CS:P]Blizzard Island[CR].", french="Pour atteindre la [CS:P]Mer Fermée[CR],\nil faut passer par la mer à l'est de l'[CS:P]Ile\nBlizzard[CR].", german="Das [CS:P]Ringmeer[CR] ist vom Meer\nöstlich der [CS:P]Blizzardinsel[CR] aus zu erreichen.", italian="Per arrivare al [CS:P]Mar Cinto[CR]\nbisogna navigare ad est dell'[CS:P]Isola Tormenta[CR].", spanish="El [CS:P]Mar Circundante[CR] está al este\nde la [CS:P]Isla Ventisca[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Oh, you really must see it for\nyourselves!", french="Oh, il faut absolument que\nvous alliez voir ça par vous-mêmes!", german="Oh, das müsst ihr euch wirklich\nselbst ansehen!", italian="Oh, dovreste proprio vederlo\ncon i vostri occhi!", spanish=" ¡Deberíais ir a verlo!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 40) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 40]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  -- supervision_ExecuteCommon(CORO_EVENT_S03_01) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 39] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Time passes so quickly!", french="Comme le temps passe vite!\nTrop vite, même! Hiii!", german=" Die Zeit vergeht so rasch!", italian=" Il tempo passa così in fretta!", spanish=" ¡El tiempo pasa tan rápido!"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="It seems as if it were only\nyesterday that you two showed up at the guild.", french="Ben mince alors! J'ai\nl'impression que votre toute première arrivée\nà la Guilde, c'était hier!", german="Mir ist so, als wäre es erst\ngestern gewesen, dass ihr zwei bei der Gilde\naufgetaucht seid.", italian="Mi sembra ieri che voi due\navete fatto la vostra comparsa alla Gilda.", spanish="Parece que fue ayer cuando\nllegasteis al [CS:N]Pokégremio[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="The two of you then...[K] Oh, you\nwere adorable! Oh my gosh!", french="Vous deux...[K] Oh, vous étiez\nsi chou! Oh là là!", german="Ihr zwei...[K] Oh, ihr wart\nhinreißend! Du meine Güte!", italian="A pensarci...[K] Oh, come eravate\ndolci, voi due!", spanish="Menuda parejita más mona,\npensé...[K] ¡Unos superencantos de\nPokémon!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 4]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ......", italian=" ..................", spanish=" ..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 3] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Oh? You want to know about the\ngrand master of all things bad?", french="Ah? Vous voulez en savoir plus\nsur le grand maître de tous les maux?", german="Oh? Ihr wollt etwas über den\nGroßmeister allen Übels erfahren?", italian="Eh? Volete sapere qualcosa su\nSua Malvagità?", spanish="¿Qué? ¿Queréis que os hable del\ngran malo requetemalo?"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Let me put it as simply...[K]\nEeeeeeek!", french="Je vais essayer de faire\nsimple... [K]Giga Hiiiiiiii!", german="Lasst es mich so einfach wie\nmöglich ausdrücken...[K] Ieeeek!", italian="Per farla semplice...[K]\nAaaaaaaaah!", spanish="Para que nos entendamos...[K]\n¡No me lo puedo ni imaginar! Tiene que ser\nsuperhorrible."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="It will be all right![K]\nIt's [partner] and [hero]!", french="Tout va bien![K]\nC'est [partner] et [hero]!", german="Alles kommt in Ordnung![K] Es sind\n[partner] und [hero]!", italian="Andrà tutto bene![K]\nForza [partner]! Forza [hero]!", spanish="Todo irá bien.[K] Estamos hablando\nde [partner] y [hero]..."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="I'm certain that you will be able\nto stop the planet's paralysis!", french="Je suis certaine que vous\nparviendrez à empêcher la Paralysie de la\nPlanète!", german="Ich bin mir sicher, dass ihr die\nLähmung des Planeten aufhalten werdet!", italian="Sono certa che riuscirete a\nscongiurare la paralisi del pianeta!", spanish="¡Estoy segurísima de que podréis\ndetener la parálisis del planeta!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="The horrible enemies within\n[CS:P]Brine Cave[CR]...[K] What do you suppose they are?", french="Cette créature immonde de la\n[CS:P]Caverne Saline[CR]...[K]\nC'est quoi, à ton avis?", german="Die schrecklichen Gegner in der\n[CS:P]Salzwasserhöhle[CR]...[K] Was, glaubst du, sind sie?", italian="Cosa pensate che siano quei\nripugnanti mostri della [CS:P]Grotta Salmastra[CR]...[K]\neh, cosa?", spanish="Esos horribles enemigos de la\n[CS:P]Cueva Aguamar[CR]...[K] ¿Quiénes serán?"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="...[K]Eek! Thinking about them\nfrightens me!", french="... [K]Hiii! J'ai trop peur! Rien que\nd'y penser, j'en ai la chlorophylle qui se défile!", german="...[K]Ieek! Der Gedanke an sie\nmacht mir schon Angst!", italian="...[K] Shock! Il solo pensiero\nmi fa rabbrividire!", spanish="¡Ay![K] ¡Jo! Me asusto solo de\npensar en ellos..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 1] || scn($SCENARIO_MAIN) >= [22
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="We should let the great [CS:N]Dusknoir[CR]\nhandle that horrid [CS:N]Grovyle[CR].", french="Laissons le grand [CS:N]Noctunoir[CR]\ns'occuper de cet horrible [CS:N]Massko[CR].", german="Der große [CS:N]Zwirrfinst[CR] sollte\nsich um den abscheulichen [CS:N]Reptain[CR] kümmern.", italian="Dovremmo lasciare che il grande\n[CS:N]Dusknoir[CR] si occupi di quell'orrendo [CS:N]Grovyle[CR].", spanish="Dejemos que el gran [CS:N]Dusknoir[CR]\nse ocupe de [CS:N]Grovyle[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="After all, I'm sure that it would\ntake someone as great as [CS:N]Dusknoir[CR] to capture\n[CS:N]Grovyle[CR].", french="Après tout, je suis sûre qu'il\nfaut quelqu'un de la trempe de [CS:N]Noctunoir[CR] pour\nvenir à bout de [CS:N]Massko[CR].", german="Im Grunde bin ich mir sicher,\ndass es jemanden wie den großen [CS:N]Zwirrfinst[CR]\nbraucht, um [CS:N]Reptain[CR] zu fangen.", italian="Dopotutto, sono sicura che ci\nvoglia qualcuno di grande come [CS:N]Dusknoir[CR] per\ncatturare [CS:N]Grovyle[CR].", spanish="Estoy segurísima de que hace\nfalta alguien de la talla de [CS:N]Dusknoir[CR] para\ncapturar a [CS:N]Grovyle[CR]."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="The three of us--[CS:N]Bidoof[CR],\n[CS:N]Dugtrio[CR], and I--were supposed to go to\n[CS:P]Crystal Cave[CR].", french="[CS:N]Keunotor[CR], [CS:N]Triopikeur[CR] et moi,\non était censés se rendre à la\n[CS:P]Caverne Cristal[CR].", german="Wir drei - [CS:N]Bidiza[CR], [CS:N]Digdri[CR] und\nich - sollten in die [CS:P]Kristallhöhle[CR] gehen.", italian="Noi tre, [CS:N]Bidoof[CR], [CS:N]Dugtrio[CR]\ne io, dovremmo andare alla [CS:P]Grotta di[CR]\n[CS:P]Cristallo[CR].", spanish="Nosotros tres: [CS:N]Bidoof[CR], [CS:N]Dugtrio[CR]\ny yo teníamos que ir a la [CS:P]Cueva Cristal[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="While we weren't paying\nattention, [CS:N]Dugtrio[CR] went off somewhere\nby himself.", french="Pendant qu'on avait le dos\ntourné, môssieu [CS:N]Triopikeur[CR] est parti de\nson côté on ne sait où.", german="Als wir unachtsam waren, hat\nsich [CS:N]Digdri[CR] abgesetzt und ist allein\nweitergezogen.", italian="Mentre eravamo distratti, shock,\n[CS:N]Dugtrio[CR] se n'è andato per conto suo.", spanish="Nos distrajimos un momento y\n[CS:N]Dugtrio[CR] se marchó por su cuenta."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Where has he gotten to...?", french="Où peut-il bien être...?\nJ'hallucine, franchement!", german=" Wo ist er abgeblieben?", italian=" Dove sarà andato?", spanish=" ¿Adónde habrá ido?"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="We'll leave when [CS:N]Dugtrio[CR] decides\nto join us.", french="On partira quand môssieu\n[CS:N]Triopikeur[CR] se décidera enfin à nous\nrejoindre.", german="Sobald [CS:N]Digdri[CR] entscheidet, sich\nuns anzuschließen, brechen wir auf.", italian="Partiremo quando [CS:N]Dugtrio[CR] si\ndeciderà a tornare.", spanish="Nos iremos cuando [CS:N]Dugtrio[CR] se\ndecida a venir con nosotros."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 1]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="We must capture that dreadful\n[CS:N]Grovyle[CR]!", french="Nous devons capturer l'infâme\n[CS:N]Massko[CR]!", german="Wir müssen diesen grausamen\n[CS:N]Reptain[CR] fangen!", italian="Dobbiamo catturare quell'orribile\n[CS:N]Grovyle[CR]!", spanish="¡Hay que capturar al terrible\n[CS:N]Grovyle[CR]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [13, 2] || scn($SCENARIO_MAIN) >= [13
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="It's another day of helping\nPokémon in need!", french="Aujourd'hui encore, partons\nà la rescousse des Pokémon qui ont besoin\nde nous!", german="Es ist ein weiterer Tag, an dem\nPokémon in Not geholfen werden muss!", italian="Un'altra giornata ad aiutare i\nPokémon in difficoltà!", spanish="¡Otro día más ayudando a los\nPokémon en apuros!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 4] || scn($SCENARIO_MAIN) >= [12
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="I had the chance to chat with\nthe great [CS:N]Dusknoir[CR] the other day.", french="J'ai eu la chance de tailler\nune bavette avec le grand [CS:N]Noctunoir[CR] l'autre\njour.", german="Ich hatte neulich die Möglichkeit,\nmich mit dem großen [CS:N]Zwirrfinst[CR] zu\nunterhalten.", italian="L'altro giorno ho avuto\nla possibilità di chiacchierare con\nil grande [CS:N]Dusknoir[CR].", spanish="El otro día tuve la suerte de\ncharlar con el gran [CS:N]Dusknoir[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="I must say that [CS:N]Dusknoir[CR] is\nincredibly worldly and wise.", french="[CS:N]Noctunoir[CR] est tellement\nexpérimenté, tellement avisé, tellement\ntout, quoi... C'est mon idole! Je l'adore!", german="Ich muss sagen, [CS:N]Zwirrfinst[CR] ist\nunglaublich weltläufig und weise.", italian="Devo dire che [CS:N]Dusknoir[CR]\nè straordinariamente saggio ed esperto.", spanish="Debo reconocer que [CS:N]Dusknoir[CR]\nes muy sabio y muy mundano."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="He's a wealth of hints and tips\nfor exploring too.", french="C'est aussi une mine\nd'informations pour l'explorateur.", german="Ferner ist er eine Quelle guter\nHinweise und Tipps in Bezug auf das Erkunden.", italian="È un pozzo di sapienza e di\nsuggerimenti per l'esplorazione.", spanish="Tiene muchos consejos y pistas\npara los exploradores."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" He's so very inspiring!", french="Il est si captivant! Il n'y a pas\nplus cool que lui!", german="Er ist eine unglaubliche\nInspiration!", italian=" Mi ha ispirato molto!", spanish=" ¡A mí me inspira!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 1]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Oh my gosh! I got to meet the\nfamous [CS:N]Dusknoir[CR]!", french="Ben mince alors! J'ai eu la\nchance, et le plaisir de rencontrer le\ncélébrissime [CS:N]Noctunoir[CR]! Oh là là!", german="Du meine Güte! Ich habe den\nberühmten [CS:N]Zwirrfinst[CR] getroffen!", italian="Shock! Incontrerò il celebre\n[CS:N]Dusknoir[CR]!", spanish="¡Qué bien! ¡He conocido al\nfamosísimo [CS:N]Dusknoir[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" It's such an honor! Yippee!", french=" C'est un tel honneur! Youpii!", german=" Das ist solch eine Ehre! Hurra!", italian=" E' un vero onore! Shock!", spanish=" ¡Es todo un honor para mí! ¡Sí!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="The expedition will be a very\nlong journey.", french="Cette expédition promet d'être\nun long périple.", german="Die Expedition wird auf eine\nweite Reise hinauslaufen.", italian="La spedizione sarà un viaggio\nmolto lungo.", spanish="La expedición será un viaje muy\nlargo."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="It will be even harder if you\ndon't take the right supplies.", french="Ce sera encore plus dur si on\nn'emporte pas les provisions nécessaires.", german="Es wird noch schwieriger\nwerden, wenn ihr nicht die richtigen Vorräte\nmitnehmt.", italian="Sarà anche più dura se non\nti porterai l'equipaggiamento adatto.", spanish=" Habrá que ir bien equipados."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="We all should get properly\nstocked up before we go see [CS:N]Chatot[CR].", french="Equipons-nous comme il faut\navant d'aller voir [CS:N]Pijako[CR].", german="Wir sollten uns alle\nentsprechend ausstatten, bevor wir [CS:N]Plaudagei[CR]\naufsuchen.", italian="Dobbiamo prepararci al meglio\nprima di andare da [CS:N]Chatot[CR].", spanish="Armémonos de provisiones antes\nde ir a ver a [CS:N]Chatot[CR]."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="The members haven't been\nchosen yet!", french="Les participants n'ont pas encore\nété choisis!", german="Die Teilnehmer wurden noch\nnicht bestimmt!", italian="I membri non sono ancora stati\nscelti!", spanish="¡Todavía no se ha escogido\na los miembros participantes!"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" We must never give up! ♪", french="Hors de question qu'on\nabandonne! ♪", german="Wir dürfen niemals\naufgeben! ♪", italian=" Non molleremo mai! ♪", spanish=" ¡No podemos rendirnos! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 2] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Everyone's quite excited about\nthe upcoming expedition. Eek!", french="Tout le monde est surexcité\nà propos de la prochaine expédition. Hiii!", german="Alle sind ziemlich aufgeregt im\nHinblick auf die nahende Expedition. Iek!", italian="Sono tutti emozionati per\nla spedizione. Aah!", spanish="¡Jo! ¡Todos estamos nerviosos\npor la expedición!"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="We all should work hard so we\nget chosen for the expedition!", french="On devrait tous travailler dur\npour faire partie de l'expédition!", german="Wir sollten alle hart arbeiten,\ndamit wir für die Expedition ausgewählt\nwerden!", italian="Dobbiamo dare il meglio per\nessere scelti in vista della spedizione!", spanish="¡Hay que trabajar superduro\npara poder participar en la expedición!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 6) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 6]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Well...complaining about the\nsmell doesn't help.", french="Mais se plaindre de l'odeur,\nça n'avance à rien.", german="Sich über den Gestank zu\nbeschweren, löst das Problem nicht.", italian="Ma lamentarsi della puzza non\nserve a nulla.", spanish="No servirá de nada quejarse\ndel olor."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 3] || scn($SCENARIO_MAIN) >= [7, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="I wonder why we had such an\nawful stench in our guild...", french="Je me demande bien d'où venait\ncette ignoble puanteur à la Guilde...", german="Ich frage mich, warum wir\ndiesen fiesen Gestank in der Gilde hatten.", italian="Che shock! Che sarà questa\npuzza terribile nella nostra Gilda?", spanish="Me pregunto por qué huele tan\nmal en el [CS:N]Pokégremio[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" It's a mystery! Eek!", french=" Hiii! Mystère et boule puante!", german=" Es ist ein Rätsel! Urgs!", italian=" È un mistero! Aah!", spanish=" ¡Menudo misterio!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 1] || scn($SCENARIO_MAIN) >= [6, 
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Oh, there's nothing to be\nfrightened of, [CS:N]Bidoof[CR].", french="Oh là là, mais il n'y a\nab-so-lu-ment rien à craindre, [CS:N]Keunotor[CR].", german="Oh, es gibt nichts, wovor du\nAngst haben müsstest, [CS:N]Bidiza[CR].", italian="Ah, non c'è nulla di cui\npreoccuparsi, [CS:N]Bidoof[CR].", spanish="No hay por qué asustarse,\n[CS:N]Bidoof[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Let us be brave and go on our\nexploration.", french="Il faut qu'on soit courageux!\nOn part en exploration ou quoi?", german="Lass uns tapfer sein und mit\nunserer Erkundung beginnen.", italian="Facciamoci coraggio e andiamo\na esplorare.", spanish="Seamos valientes y afrontemos\nla exploración."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 7]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" See that signboard on the left?", french="Vous voyez cette pancarte,\nsur la gauche?", german="Seht ihr das Aushängeschild da\nauf der linken Seite?", italian="Vedete quel cartello sulla\nsinistra?", spanish=" ¿Veis aquel panel a la izquierda?"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="That is the Pokémon Exploration\nTeam Federation Q&A.", french="C'est la Foire aux Questions\n(FAQ pour les intimes) de la Fédération\ndes Equipes d'Exploration.", german="Das ist die Pokémon-\nErkundungsteamverband-FAQ.", italian="È la FAQ della Federazione\nSquadre d'Esplorazione.", spanish="Es la guía básica para\nexploradores."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="It lists topics that you should\nfind useful as explorers.", french="Elle répond à des questions\nque tous les explorateurs peuvent se poser,\nc'est hyper utile.", german="Dort sind Themen aufgelistet,\nderen Informationen gerade für Erkunder\nwie euch sehr hilfreich sein dürften.", italian="Lì si trova una lista\ndi informazioni utili per gli esploratori.", spanish="Allí encontraréis información\nsuperútil para los exploradores."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="You should take a look if you\ndon't understand something.", french="Jetez-y un coup d'œil s'il y a\nquelque chose que vous ne comprenez pas.\nConseil d'amie!", german="Ihr solltet einen Blick darauf\nwerfen, wenn ihr etwas nicht versteht.", italian="Dovreste darci un'occhiata\nquando qualcosa non è molto chiaro.", spanish="Deberíais echarle un vistazo,\npor si hay algo que no os quede claro."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 5]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Yes?[K] Oh, you want to know\nhow the Job Bulletin Board works?", french="Oui?[K] Oh, vous voulez savoir\ncomment fonctionne le Tableau des Missions?", german="Ja?[K] Oh, ihr wollt wissen, wie\ndas Job-Infobrett funktioniert?", italian="Sì?[K] Ah, volete sapere come\nfunziona la Bacheca delle missioni?", spanish="¿Sí?[K] Ah, ¿queréis saber cómo\nfunciona el Tablón de Anuncios?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="This Job Bulletin Board fills up\nwith many kinds of jobs.", french="Le Tableau des Missions regorge\nde toutes sortes de missions.", german="Dieses Job-Infobrett füllt sich\nmit vielen verschiedenen Jobarten.", italian="Questa Bacheca offre sempre\nuna vasta gamma di missioni.", spanish="Este Tablón de Anuncios contiene\ntoda clase de misiones."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="They represent the cries of\nPokémon who are calling for our help.", french="Elles représentent les flots de\nlarmes de tous ces Pokémon qui nous appellent\nà l'aide.", german="Sie spiegeln die Rufe der\nPokémon wider, die unsere Hilfe benötigen.", italian="Rappresentano le richieste\nd'aiuto dei Pokémon che sono in difficoltà.", spanish="Aquí están las peticiones de\nayuda de los Pokémon en apuros."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Lending a helping hand to such\nPokémon in need is an important part of an\nexploration team's work.", french="Prêter main-forte aux Pokémon\nen danger, c'est une part hyper importante\ndu travail d'une équipe d'exploration.", german="Einem Pokémon in Not eine\nhelfende Hand zu reichen, ist ein wichtiger Teil\nder Arbeit eines Erkundungsteams.", italian="Prestare il proprio aiuto a un\nPokémon in difficoltà è una parte importante\ndel lavoro di una squadra d'esplorazione.", spanish="Echar una mano a los Pokémon\nque lo necesitan es parte importante de la\nlabor de cada equipo de exploración."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Very well.[K] I will be happy to\nexplain it to you.", french="Très bien.[K] Je vais me faire un\nplaisir de vous l'expliquer.", german="Also gut.[K] Es wird mir ein\nVergnügen sein, es euch zu erklären.", italian="Benissimo.[K] Sarò felice di\nspiegarvelo.", spanish="Muy bien.[K] Os lo explicaré con\nmucho gusto."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="First, you walk up to the Job\nBulletin Board and press [M:B2].", french="D'abord, placez-vous devant\nle Tableau des Missions et appuyez sur [M:B2].", german="Zuerst tretet ihr an das\nJob-Infobrett heran und drückt [M:B2].", italian="Per prima cosa, avvicinatevi alla\nBacheca delle missioni e premete [M:B2].", spanish="Primero, te acercas al Tablón\nde Anuncios y pulsas [M:B2]."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Using the Job Bulletin Board,\nfirst choose the jobs you want to do someday.", french="Commencez par choisir\nles missions que vous voulez accomplir.", german="Auf dem Job-Infobrett wählt ihr\ndann die Jobs, die ihr irgendwann erledigen\nwollt.", italian="Poi scegliete le missioni da\naffrontare.", spanish="Debes escoger las misiones que\nte gustaría emprender tarde o temprano."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="The jobs you chose will then\nappear in your menu's Job List. Each whole job\nletter will be there with all the details.", french="Ces missions apparaîtront alors\ndans votre Liste de Missions, avec la lettre\ndu demandeur et un descriptif complet.", german="Die von euch gewählten Jobs\ntauchen in der Jobliste des Menüs auf. Dort\nfindet ihr detaillierte Jobbeschreibungen.", italian="Le missioni scelte appariranno\nnella lista delle missioni. Qui si possono\nvedere in dettaglio gli obiettivi di ognuna.", spanish="Las misiones elegidas aparecerán\nen tu lista de misiones. Cada una tiene una\ncarta en la que se indican los detalles."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Then use the Take Job command\nto activate jobs on your Job List.[K] After that,\nyou can go to the dungeon to do the job!", french="Puis utilisez la commande\nAccepter pour activer des missions de la liste.\nEnsuite, facile! Allez dans le donjon concerné!", german="Wählt AUSÜBEN, um Jobs von\neurer Jobliste zu aktivieren.[K] Dann könnt ihr\nden Dungeon betreten und den Job erledigen.", italian="Per attivare le missioni della\nlista, bisogna selezionare il comando Attiva.[K]\nPoi, si può andare e iniziare la missione.", spanish="Para activar alguna misión de la\nlista, selecciona la opción Aceptar.[K] ¡Después\ndirígete al territorio para realizar la misión!"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Don't forget! You must activate\na job with Take Job if you want to do it.", french="Attention, hein! N'oubliez pas\nd'activer la mission à accomplir au moyen\nde la commande Accepter.", german="Vergesst nicht! Ihr müsst einen\nJob mit AUSÜBEN aktivieren, wenn ihr ihn\nerledigen wollt.", italian="Importante! Per portare a\ntermine una missione bisogna prima\nattivarla con il comando Attiva.", spanish="¡No olvides seleccionar la opción\nAceptar de cada misión que quieras emprender\nantes de ir al territorio!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 3] || scn($SCENARIO_MAIN) >= [4, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Eek!", french=" Hiii!", german=" Ieek!", italian=" Aaah!", spanish=" ¡Vaya!"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Oh my gosh! The new guild\nrecruits![K] Delighted to meet you!", french="Ben mince alors! J'hallucine!\nLes nouvelles recrues de la Guilde![K] Je suis\ntrop contente de vous rencontrer!", german="Oh, die neuen Gildenrekruten![K]\nErfreut, eure Bekanntschaft zu machen!", italian="Ah, le nuove reclute della\nGilda![K] Deliziata di conoscervi!", spanish="¡Qué fuerte! ¡No me digas que\nrecién os habéis incorporado al [CS:N]Pokégremio[CR]![K]\n¡Encantada de conoceros!"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="You can get all sorts of things\nhere. It's quite convenient.", french="Bon, que je vous explique.\nOn trouve toutes sortes de trucs ici. C'est\nhyper pratique.", german="Ihr könnt hier alle möglichen\nDinge bekommen. Das ist ziemlich praktisch.", italian="Qui potete trovare qualsiasi\ncosa. È anche conveniente.", spanish="Aquí podéis conseguir toda clase\nde cosas. Es bastante útil."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Do build a stock of items that\nwill aid your explorations.", french="Il faut ab-so-lu-ment vous\nconstituer une réserve d'objets! Ça vous\nsera hyper utile en exploration.", german="Schafft euch einen Grundvorrat\nan Items an, die euch bei euren Erkundungen\nhelfen werden.", italian="Procuratevi una serie di\nstrumenti che vi potranno tornare utili durante\nle esplorazioni.", spanish="Siempre viene bien acumular objetos\npara llevarlos encima a la hora de explorar."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 0] || scn($SCENARIO_MAIN) >= [3, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
