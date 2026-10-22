-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/us0209.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_yamikarasu = SkySceneKit.spawn_npc("murkrow", 64, 232, Direction.Right, "NPC_YAMIKARASU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yamikarasu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="Oooh, I must have it! The [CS:I]Lost\nLoot[CR] calls to me!", french="Oooh, il me le faut! Le [CS:I]Butin\nPerdu[CR] m'appelle!", german="Oooh, ich muss es haben! Das\n[CS:I]Beutegut[CR] ruft nach mir!", italian="Oooh, devo averlo!\nIl [CS:I]Tesorperduto[CR] mi chiama!", spanish="¡Lo necesito! ¡El [CS:I]Botín Oculto[CR] me\nestá llamando!"})
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english=" The [CS:I]Lost Loot[CR] is rightfully mine!", french="Le [CS:I]Butin Perdu[CR] m'appartient\nde droit!", german="Das [CS:I]Beutegut[CR] gehört\nrechtmäßig mir!", italian=" Il [CS:I]Tesorperduto[CR] è mio di diritto!", spanish="¡El [CS:I]Botín Oculto[CR] será mío y solo\nmío!"})
  -- message_Close
  -- @label_131 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 93] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yamikarasu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="I discovered there's something\nI find more desirable than the [CS:I]Golden Apple[CR]!", french="J'ai découvert qu'il existait\nquelque chose que je convoitais encore plus\nqu'une [CS:I]Pomme d'Or[CR]!", german="Ich habe herausgefunden, dass\nes etwas gibt, was ich noch mehr begehre als\nden [CS:I]Goldapfel[CR]!", italian="Ho scoperto che c'è qualcosa\nche desidero di più della [CS:I]Mela Dorata[CR]!", spanish="He descubierto que hay algo más\napetecible que la [CS:I]Manzana Oro[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english=" And that is...[K]the [CS:I]Lost Loot[CR]!", french="Et cette chose, c'est...[K]\nle [CS:I]Butin Perdu[CR]!", german=" Und zwar ist es... [K]das [CS:I]Beutegut[CR]!", italian=" Ed è...[K] il [CS:I]Tesorperduto[CR]!", spanish=" Y es...[K] ¡el [CS:I]Botín Oculto[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="We've heard rumors that the\nincredibly valuable [CS:I]Lost Loot[CR] is buried\nsomewhere!", french="C'est un trésor d'une valeur\ninestimable! Le bruit court que le [CS:I]Butin Perdu[CR]\nest enfoui quelque part!", german="Gerüchten zufolge liegt das\nunglaublich wertvolle [CS:I]Beutegut[CR] irgendwo\nbegraben!", italian="Dicono che l'inestimabile\n[CS:I]Tesorperduto[CR] sia sepolto da qualche parte!", spanish="¡Hemos oído rumores de que el\nincreíblemente valioso [CS:I]Botín Oculto[CR] está\nenterrado en alguna parte!"})
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english=" Do you know anything of it?", french=" Ça vous dit quelque chose?", german=" Wisst ihr etwas darüber?", italian=" Ne sapete qualcosa?", spanish=" ¿Sabes algo de él?"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 71] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yamikarasu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english=" I want a [CS:I]Golden Apple[CR]!", french=" Je veux une [CS:I]Pomme d'Or[CR]!", german=" Ich will einen [CS:I]Goldapfel[CR]!", italian=" Voglio una [CS:I]Mela Dorata[CR]!", spanish=" ¡Quiero una [CS:I]Manzana Oro[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english=" Oooh, I must have it!", french=" Oooh, il m'en faut une!", german="Oooh, ich muss ihn einfach\nhaben!", italian=" Oooh, devo averla!", spanish=" ¡La necesito!"})
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="...[K]But there's been precious\nlittle information about it.", french="... [K]Mais on sait très peu de\nchose à son sujet.", german="...[K]Aber es gibt so wenig\nInformationen darüber.", italian="...[K] Ma ci sono davvero poche\ninformazioni a riguardo.", spanish="Pero...[K] hay tan poca información\nsobre ella..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 33] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yamikarasu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="We were looking for hidden\ntreasure buried on [CS:P]Sky Peak[CR] but didn't\nfind any.", french="On cherchait des trésors\nsecrets sur le [CS:P]Pic Céleste[CR], mais on\nn'en a trouvé aucun.", german="Wir haben nach versteckten\nSchätzen auf dem [CS:P]Himmelsgipfel[CR] gesucht,\naber leider keine gefunden.", italian="Eravamo alla ricerca dei tesori\nnascosti sul [CS:P]Picco del Cielo[CR], ma\nnon ne abbiamo trovato nemmeno uno.", spanish="Estábamos buscando tesoros\nocultos en la [CS:P]Cumbre del Cielo[CR],\npero no encontramos nada."})
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="But we found some very shiny,\nsparkly treasure, so I'm satisfied!", french="Par contre on a trouvé des\ntrésors tout brillants et étincelants,\nalors je suis comblée!", german="Aber wir haben einige glänzende,\nfunkelnde Kostbarkeiten entdeckt. Daher bin\nich ganz zufrieden!", italian="Però abbiamo trovato dei tesori\nche risplendono come il sole, quindi sono molto\nsoddisfatta!", spanish="Eso sí, hallamos un tesoro\nreluciente, ¡así que me doy por satisfecha!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 30] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="The 6th Station Clearing seems\nkind of empty...", french="La trouée du 6[F:E] Relais\nest bien vide...", german="Diese 6. Zwischenlagerlichtung\nscheint ziemlich leer...", italian="Non c'è praticamente nulla\nin questo Bivacco 6...", spanish="A la Base del Sexto Puerto le\nfalta ambientillo..."})
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="The 2nd Station Clearing was\nvery busy and just gorgeous...", french="La trouée du 2[F:E] Relais était\nbien plus animée et tout bonnement splendide...", german="Die 2. Zwischenlagerlichtung\nhingegen war geschäftig und aufregend...", italian="Quel Bivacco 2 era così\naffollato... Che meraviglia!", spanish="Con lo animada que estaba la\nBase del Segundo Puerto y lo bonita que era..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 26] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="We're more interested in\ntreasure than in climbing the mountain!", french="Nous, on s'intéresse plus aux\ntrésors qu'à l'ascension de la montagne!", german="Wir finden Schätze aufregender\nals Bergsteigen!", italian="Ci interessa di più scovare\ntesori che scalare montagne!", spanish="Nos interesan más los tesoros\nque escalar la montaña."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 20] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yamikarasu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="I was about to seize a glittery,\nsparkly treasure, but the wind blew me away!", french="J'étais sur le point de ramasser\nun trésor tout brillant et étincelant, quand le\nvent m'a chassée!", german="Ich wollte just einen funkelnden,\nglitzernden Schatz bergen, da wehte mich der\nWind davon!", italian="Stavo per mettere le mani su\nun tesoro scintillante, ma il vento mi ha\nfatta volare via!", spanish="Estaba a punto de hacerme con\nun tesoro brillante, pero se me llevó el viento."})
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="Kyaaaah!\nFrustrating!", french="Croâââ!\nComme c'est frustrant!", german="Kyaaaah!\nFrustrierend!", italian="Craaah!\nCom'è frustrante!", spanish="¡Jooo!\n¡Qué desilusión!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 16] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="What do you think is the\ngreatest secret treasure of all, darlings?", french="D'après toi, quel est le plus\ngrand trésor secret de tous?", german="Was glaubst du, ist der größte\ngeheime Schatz von allen, du süßes Ding?", italian="Secondo te qual è il tesoro\nsegreto più prezioso che esiste, dolcezza?", spanish="¿Cuál crees que es el mayor\ntesoro secreto, ricura?"})
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="I bet it is...a sparkly, golden...\nsomething!", french="A mon avis... un...\nun truc qui brille...", german="Ich wette, es ist...\nein goldenes, funkelndes... Etwas!", italian="Io dico che è qualcosa...\ndi dorato e brillante!", spanish="A mí no me cabe duda... Es...\n¡algo dorado y brillante!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 9) >= 0) or (SkyProg.cmp(29, 8) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 11] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yamikarasu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="One day, I will find a sparkly,\nglittery treasure!", french="Un jour, je trouverai un trésor\ntout brillant et étincelant!", german="Eines Tages werde ich einen\nfunkelnden, glitzernden Schatz finden!", italian="Un giorno troverò un\nmeraviglioso tesoro scintillante!", spanish="Algún día encontraré un tesoro\nbrillante y reluciente."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 6] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yamikarasu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english=" The [CS:P]Hidden Land[CR]?", french=" Les [CS:P]Terres Illusoires[CR]?", german=" Das [CS:P]Verborgene Land[CR]?", italian=" La [CS:P]Terra Nascosta[CR]?", spanish=" ¿La [CS:P]Tierra Oculta[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="I don't think so...?[K] No, I've never\nheard of such a place.", french="Je ne crois pas... [K]Non, je n'ai\njamais entendu parler d'un tel endroit.", german="Ich glaube kaum.[K] Nein, von einem\nsolchen Ort habe ich noch nie gehört.", italian="Mmm...[K] No, non l'ho mai\nsentita nominare.", spanish="No me suena de nada...[K] No, nunca\nhe oído hablar de ese sitio."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yamikarasu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="The treasure must be seriously\nsparkly! My heart tells me so!", french="Ce trésor doit être si\néblouissant! C'est mon cœur qui me le dit!", german="Der Schatz muss besonders\nfunkelnd sein! Mein Herz versichert mir das!", italian="Il tesoro dev'essere davvero\nscintillante! Me lo dice il mio cuore!", spanish="¡Ese tesoro tiene que brillar\ncomo una estrella! ¡Me lo dice el corazón!"})
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english=" There's no mistake!", french=" Ça ne fait aucun doute!", german=" Ein Irrtum ist ausgeschlossen!", italian=" Non mi sbaglio!", spanish=" ¡No puede ser de otra forma!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 1] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yamikarasu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="I keep an eye out for\nsparkly things!", french="Je suis toujours à l'affût des\nchoses qui brillent!", german="Ich halte Ausschau nach\nfunkelnden Dingen!", italian="Ho un debole per le cose che\nbrillano!", spanish=" ¡Todo lo que brilla me atrae!"})
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="What I find most intriguing\nright now is the [CS:I]Golden Mask[CR]. Imagine its\nglittery gleam!", french="Ce qui me fascine le plus en ce\nmoment, c'est le [CS:I]Masque d'Or[CR]. Imaginez-vous\nsa brillance étincelante!", german="Was ich derzeit am\nfaszinierendsten finde, ist die [CS:I]Goldmaske[CR].\nStellt euch nur ihren funkelnden Schimmer vor!", italian="Quello che mi affascina di più\nora come ora è la [CS:I]Mascheradoro[CR]. Immagina\nil suo scintillante brillio!", spanish="Ahora lo que más me intriga es\nla [CS:I]Máscara Oro[CR]. ¡Imagínate cuánto brillo!"})
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="But my partner [CS:N]Shuppet[CR] isn't\nkeen on the idea at all...", french="Mais ma partenaire, [CS:N]Polichombr[CR],\nn'est pas vraiment éblouie par l'idée...", german="Aber mein Partner [CS:N]Shuppet[CR] ist\ndavon nicht sonderlich begeistert.", italian="Ma la mia compagna [CS:N]Shuppet[CR]\nnon è per niente della stessa opinione...", spanish="Pero a mi compañera [CS:N]Shuppet[CR]\nno parece hacerle gracia la idea."})
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="She refuses, with silly reasons\nlike, \"It sounds so garish and tacky!\"", french="Elle refuse toujours et me donne\ndes raisons ridicules du genre \"Ça a l'air\ncriard et clinquant, ton truc!\"", german="Sie sagt, es klinge alles so grell\nund kitschig. Das sind ihre Gründe... Einfältige\nGründe...", italian="Si rifiuta, con sciocche\nmotivazioni come: \"Suona così kitsch e di\ncattivo gusto!\"", spanish="No hace más que negarse, con\nrazones tan tontas como que \"¡eso suena\nsuperhortera!\"."})
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english=" Arrgh, it is just so frustrating!", french=" Aaargh, c'est très frustrant!", german="Arrgh, das ist einfach so\nfrustrierend!", italian=" Arrgh, è così frustrante!", spanish=" Aj, ¡me pone de los nervios!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 4] || scn($SCENARIO_MAIN) >= [14
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yamikarasu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="This must be the Juice Bar\neveryone's been talking about...", french="C'est sûrement le fameux\nBar à Jus dont tout le monde parle...", german="Das muss die Saftbar sein, über\ndie sich alle unterhalten...", italian="Questo deve essere il famoso\nBarsucco di cui parlano tutti...", spanish="Esta debe de ser la cafetería\nde la que todo el mundo habla..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yamikarasu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="I'm not content with our rank.\nWe should be so much better.", french="Je ne suis pas satisfaite de\nnotre grade. On devrait faire bien mieux.", german="Ich bin mit unserem Rang nicht\nzufrieden. Wir sollten um einiges besser sein.", italian="Non sono soddisfatta del nostro\nrango. Dovremmo fare molto di più.", spanish="No estoy contenta con nuestro\nrango. Podríamos estar mucho mejor."})
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="I would like to raise our\nExplorer Rank much higher.", french="Je voudrais obtenir un Grade\nd'Explorateur bien plus élevé.", german="Ich würde unseren Erkunderrang\ngerne viel höher schrauben.", italian="Vorrei che la nostra squadra\nd'esplorazione raggiungesse un rango più alto.", spanish="Me gustaría que el rango de\nnuestro equipo fuera mayor."})
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="I deserve a rank that sparkles\nand shines![K] I am worthy!", french="Je mérite un grade qui brille de\nmille feux![K] Je le vaux bien!", german="Ich verdiene einen Rang, der\nfunkelt und strahlt![K] Würdig bin ich!", italian="Merito un rango splendente e\nluccicante![K] Ne sono degna!", spanish="¡Merezco tener un rango nuevito\ny reluciente![K] ¡Me lo merezco!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 7] || scn($SCENARIO_MAIN) >= [4, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yamikarasu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="My favorite things, darlings?\nWell, do I ever have an eye for sparklies!", french="Ce que je préfère, mes enfants?\nEh bien, moi j'ai l'œil pour repérer tout ce qui\nbrille!", german="Meine Lieblingsdinge, ihr Süßen?\nNun, für Glitzerkram habe ich echt etwas\nübrig!", italian="Volete sapere cosa mi piace,\ndolcezze? Ho sempre avuto un debole per ciò\nche brilla!", spanish="¿Que qué son mis cosas\nfavoritas? Bueno, ¡me pierde todo lo\nque brilla!"})
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="I keep telling my partner that\nwe should seek out flashy baubles and\nglamorous glitz...", french="Je n'arrête pas de dire à ma\npartenaire qu'on devrait chercher des bibelots\nclinquants et des fanfreluches chic...", german="Ich erzähle meinem Partner\nfortwährend, dass wir glitzernden Tand und\nanderes schickes Glitzerzeug suchen sollten.", italian="Dico sempre alla mia compagna\nche dovremmo cercare oggetti di bigiotteria\nbelli luccicanti e sfarzosi...", spanish="No dejo de decirle a mi\ncompañera que deberíamos buscar\nadornos brillantes y cosas ostentosas..."})
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="But [CS:N]Shuppet[CR] always reacts\ncoolly to my suggestions.", french="Mais mes suggestions laissent\ntoujours [CS:N]Polichombr[CR] de marbre.", german="Aber [CS:N]Shuppet[CR] reagiert immer so\nabweisend auf meine Vorschläge.", italian="Ma [CS:N]Shuppet[CR] reagisce sempre\nfreddamente alle mie proposte.", spanish="Pero [CS:N]Shuppet[CR] no se toma muy\nbien mis sugerencias."})
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="But she seems not to hear! Or\nshe just won't listen![K] Arrgh, it's aggravating!", french="On dirait qu'elle n'entend pas!\nOu simplement qu'elle refuse de m'écouter![K]\nCe que ça peut être agaçant!", german="Sie scheint es nicht zu hören!\nOder sie will einfach nicht zuhören![K]\nArrgh, das ist ärgerlich!", italian="Sembra che non mi senta!\nO forse non vuole ascoltare![K] Arrgh, è\nirritante!", spanish="Hace como que no me oye, pero\nla verdad es ¡que no quiere escucharme![K] Aj,\n¡cómo me irrita!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 0] || scn($SCENARIO_MAIN) >= [3, 
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
