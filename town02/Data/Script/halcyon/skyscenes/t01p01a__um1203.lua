-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/um1203.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_himeguma = SkySceneKit.spawn_npc("teddiursa", 296, 200, Direction.UpRight, "NPC_HIMEGUMA")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_himeguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="I'm supporting you too![K]\nDon't give up!", french="Vous avez tout mon soutien![K]\nNe vous découragez pas!", german="Ich unterstütze euch![K]\nGebt nicht auf!", italian="Faccio il tifo per voi![K]\nNon mollate!", spanish="¡Ya sabéis que contáis con todo\nmi apoyo![K] ¡No os rindáis!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_himeguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" I believe what you said!", french=" Je crois toute votre histoire!", german="Ich glaube das, was ihr gesagt\nhabt!", italian="Credo anch'io a ciò che mi avete\ndetto!", spanish="¡Yo creo lo que me habéis\ncontado!"})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="After all, it's very strange that\ntime hasn't started moving again after the\nTime Gears were put back.", french="Après tout, c'est très étrange\nque le temps n'ait pas repris son cours,\nune fois les Rouages du Temps remis en place.", german="Immerhin ist es schon recht\nkomisch, dass die Zeit nach wie vor stillsteht,\nauch nach Rückgabe der Zahnräder der Zeit.", italian="Dopotutto, è davvero strano che\nil tempo non sia ripartito dopo che gli\nIngranaggi del Tempo sono tornati a posto.", spanish="Al fin y al cabo, es muy extraño\nque el tiempo no haya vuelto a fluir tras\ncolocar los Engranajes del Tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="I'm in your corner![K] I hope you\nsucceed!", french="Je suis de votre côté![K] J'espère\nque vous réussirez!", german="Ich stehe auf eurer Seite![K] Ich\nhoffe, dass ihr Erfolg haben werdet!", italian="Sono dalla vostra parte![K]\nSpero che ce la farete!", spanish="¡Estoy de vuestra parte![K] ¡Os\ndeseo mucha suerte!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 1] || scn($SCENARIO_MAIN) >= [22
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_himeguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="You're both back safely!\nThat's wonderful news!", french="Vous êtes de retour!\nExcellente nouvelle!", german="Ihr seid beide gesund\nzurückgekehrt! Das sind wunderbare\nNachrichten!", italian="Siete di ritorno senza neppure\nun graffio! Che splendida notizia!", spanish="¡Habéis regresado y ya estáis a\nsalvo! ¡Estupendo!"})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="Oh, I also heard something from\n[CS:N]Bidoof[CR] earlier!", french="Au fait, [CS:N]Keunotor[CR] m'a raconté\nquelque chose tout à l'heure!", german="Oh, ich habe vor Kurzem etwas\nvon [CS:N]Bidiza[CR] gehört!", italian="Ah, prima [CS:N]Bidoof[CR] mi ha detto\nuna cosa.", spanish="Por cierto, [CS:N]Bidoof[CR] me ha contado\nalgo antes..."})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="He said [CS:N]Grovyle[CR] is actually\ngood...[K] And the great [CS:N]Dusknoir[CR] is the bad guy!", french="Il a dit que [CS:N]Massko[CR] est un gentil\nPokémon en réalité...[K] Et que le méchant de\nl'histoire, c'est [CS:N]Noctunoir[CR]!", german="Laut ihm ist [CS:N]Reptain[CR] eigentlich\nein gutartiges Pokémon.[K] Und der große\n[CS:N]Zwirrfinst[CR] soll der Bösewicht sein!", italian="Ha detto che in realtà [CS:N]Grovyle[CR]\nè il buono...[K] E che il grande [CS:N]Dusknoir[CR] è il\ncattivo!", spanish="Dice que [CS:N]Grovyle[CR] es en realidad\nel bueno...[K] ¡y que el gran [CS:N]Dusknoir[CR] es el malo!"})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" Is that really true?!", french=" Est-ce que c'est vrai, tout ça?", german=" Ist das wirklich wahr?!?", italian=" È la verità?!", spanish=" ¿Es eso cierto?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_himeguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="I think we're in safe hands\nwith the great [CS:N]Dusknoir[CR].", french="Je pense qu'avec l'illustre\n[CS:N]Noctunoir[CR] à nos côtés, nous sommes entre\nde bonnes mains.", german="Ich denke, wir sind bei dem\ngroßen [CS:N]Zwirrfinst[CR] in sicheren Händen.", italian="Credo che con il grande\n[CS:N]Dusknoir[CR] saremo in ottime mani.", spanish="Creo que estamos en buenas\nmanos con el gran [CS:N]Dusknoir[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="I'm sure he'll catch [CS:N]Grovyle[CR]\nfor us!", french="Je suis sûre qu'il attrapera\n[CS:N]Massko[CR] pour nous!", german="Ich bin mir sicher, dass er\n[CS:N]Reptain[CR] für uns fangen wird!", italian="Sono sicura che catturerà\n[CS:N]Grovyle[CR] per noi!", spanish=" ¡Seguro que atrapará a [CS:N]Grovyle[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="...Oops. I shouldn't have said\nthat so loud.", french="... Oups! Je n'aurais pas dû\nparler si fort.", german="...Ups. Das hätte ich nicht so\nlaut sagen sollen.", italian="Ups... Non avrei dovuto dirlo\ntroppo forte.", spanish="Huy, no debería haber dicho eso\ntan alto..."})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="Who knows? [CS:N]Grovyle[CR] might\neven be listening in on us.[K] One can't be\ntoo careful.", french="Qui sait? Peut-être que [CS:N]Massko[CR]\nnous espionne en ce moment même.[K]\nOn n'est jamais trop prudent.", german="Wer weiß? [CS:N]Reptain[CR] könnte uns\nsogar belauschen.[K] Man kann niemals vorsichtig\ngenug sein.", italian="Chi lo sa? [CS:N]Grovyle[CR] potrebbe\nanche sentirci.[K] Non si è mai troppo attenti.", spanish="¿Quién sabe? [CS:N]Grovyle[CR] podría\nestar escuchándonos.[K] Todo cuidado es poco."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 1]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_himeguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="He's trying to paralyze the\nplanet by stealing Time Gears, isn't he?", french="Il essaie de paralyser la planète\nen volant les Rouages du Temps, n'est-ce pas?", german="Er versucht den Planeten zu\nlähmen, indem er Zahnräder der Zeit stiehlt,\nnicht wahr?", italian="Sta provando a paralizzare il\npianeta rubando gli Ingranaggi del Tempo,\nvero?", spanish="Está intentando paralizar el\nplaneta robando los Engranajes del\nTiempo, ¿verdad?"})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="What a horrible thing to do!\nThat [CS:N]Grovyle[CR]'s horrid!", french="C'est vraiment horrible de faire\nça! Quel odieux personnage, ce [CS:N]Massko[CR]!", german="Was für eine schreckliche Tat!\nDieser [CS:N]Reptain[CR] ist abscheulich!", italian="Che cosa terribile!\nQuel [CS:N]Grovyle[CR] è mostruoso!", spanish="¡Terrible! ¡Ese [CS:N]Grovyle[CR] es\nun infame!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_himeguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="I've heard.[K] Your whole guild is\ntrying to capture [CS:N]Grovyle[CR]?", french="Je suis au courant.[K] Votre\nGuilde au grand complet essaie de capturer\n[CS:N]Massko[CR]?", german="Ich habe es gehört.[K] Deine\ngesamte Gilde versucht, [CS:N]Reptain[CR] zu fangen.", italian="Ho sentito.[K] L'intera Gilda sta\ncercando di catturare [CS:N]Grovyle[CR]?", spanish="Eso he oído.[K] ¿Está todo el\n[CS:N]Pokégremio[CR] a la caza de [CS:N]Grovyle[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" I hope you succeed!", french="J'espère de tout cœur que\nvous réussirez!", german=" Ich hoffe, ihr habt Erfolg!", italian=" Spero che ce la facciate!", spanish=" ¡Espero que lo logréis!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 4] || scn($SCENARIO_MAIN) >= [14
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_himeguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="The guild's Pokémon seem to be\nin a panic or something...", french="Les Pokémon de la Guilde sont\ntrès agités, on dirait...", german="Die Pokémon der Gilde scheinen\nin Panik zu sein...", italian="I Pokémon della Gilda sembrano\nessere nel panico, o qualcosa del genere...", spanish="En el [CS:N]Pokégremio de[CR]\n[CS:N]Exploradores[CR] están todos muy\nnerviosos..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [13, 2] || scn($SCENARIO_MAIN) >= [13
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_himeguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" Hi! Isn't the weather wonderful?", french="Salut! Le temps est magnifique\naujourd'hui, pas vrai?", german="Hallo! Ist das Wetter nicht\nwunderschön?", italian="Ciao! Non è una giornata\nsplendida?", spanish="¡Hola! ¿No hace un día\nestupendo?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 4] || scn($SCENARIO_MAIN) >= [12
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_himeguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="Welcome back![K] Was the\nexpedition fun?", french="Vous voilà de retour![K] Alors,\nc'était marrant, cette expédition?", german="Willkommen zurück![K] Hat die\nExpedition Spaß gemacht?", italian="Finalmente di ritorno![K] È stata\ndivertente la spedizione?", spanish="¡Ya habéis vuelto![K] ¿Cómo ha ido\nla expedición?"})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="Oh? You never discovered\nanything?[K] Oh... That's too bad.", french="Ah bon? Vous n'avez rien\ndécouvert du tout?[K] Oh...\nComme c'est dommage.", german="Oh? Ihr habt nichts entdeckt?[K]\nOh... Das ist schade.", italian="Oh? Non avete scoperto nulla?[K]\nOh... Che peccato!", spanish="¿No habéis descubierto nada?[K]\nOh... Qué lástima."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_himeguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="I've heard! You were picked for\nthe expedition!", french="J'ai appris la nouvelle!\nVous allez faire partie de l'expédition!", german="Ich habe es gehört! Ihr wurdet\nfür die Expedition ausgewählt!", italian="Ho saputo! Parteciperete alla\nspedizione!", spanish="¡He oído que os han escogido\npara la expedición!"})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" Congratulations!", french=" Toutes mes félicitations!", german=" Glückwunsch!", italian=" Congratulazioni!", spanish=" ¡Felicidades!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_himeguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="I've heard.[K] [CS:N]Wigglytuff[CR]'s Guild is\ngoing on an expedition soon?", french="Alors...[K] à ce qu'il paraît,\nla Guilde de [CS:N]Grodoudou[CR] part bientôt\nen expédition?", german="Ich habe es gehört.[K]\nDie [CS:N]Knuddeluff-Gilde[CR] macht sich bald zu einer\nExpedition auf?", italian="Ho saputo.[K] La Gilda di\n[CS:N]Wigglytuff[CR] partirà presto per una spedizione?", spanish="Las noticias vuelan...[K] ¿Así que el\n[CS:N]Pokégremio de Exploradores[CR] va a emprender\nuna expedición?"})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" Good luck with that!", french=" Bonne chance!", german=" Viel Glück dabei!", italian=" Buona fortuna!", spanish=" ¡Buena suerte!"})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="I hope you get picked for\nthe expedition!", french="J'espère que vous ferez partie\nde l'expédition!", german="Ich hoffe, dass ihr für die\nExpedition ausgewählt werdet!", italian="Spero che vi sceglieranno per la\nspedizione!", spanish="¡Espero que os escojan\npara la expedición!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 2] || scn($SCENARIO_MAIN) >= [8, 
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_himeguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="There's been a terrible stench\nlately. Or am I imagining it?", french="Il y a comme une horrible\npuanteur dans l'air... Ou alors c'est juste\nmon imagination qui me joue des tours?", german="Seit Kurzem liegt ein\nfürchterlicher Gestank in der Luft. Oder bilde\nich mir das nur ein?", italian="C'era una puzza terribile o me la\nsono immaginata?", spanish="Últimamente huele fatal por\naquí. ¿O serán imaginaciones mías?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 3] || scn($SCENARIO_MAIN) >= [7, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_himeguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="I've heard that the Time Gear of\n[CS:P]Treeshroud Forest[CR] was stolen.", french="J'ai entendu dire que le Rouage\ndu Temps de la [CS:P]Forêt Linceul[CR] avait été\nvolé.", german="Mir ist zu Ohren gekommen,\ndass das sich im [CS:P]Schemengehölz[CR] befindende\nZahnrad der Zeit gestohlen wurde.", italian="Ho sentito che l'Ingranaggio del\nTempo della [CS:P]Foresta Arcana[CR] è stato rubato.", spanish="He oído que han robado el\nEngranaje del Tiempo del [CS:P]Bosque Enraizado[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="Because of that, time has\nstopped in [CS:P]Treeshroud Forest[CR]...", french="Du coup, dans la [CS:P]Forêt\nLinceul[CR], le temps s'est arrêté...", german="Aus diesem Grund ist die Zeit im\n[CS:P]Schemengehölz[CR] zum Stillstand gekommen...", italian="È per questo che il tempo nella\n[CS:P]Foresta Arcana[CR] si è fermato...", spanish="Y por eso se ha detenido el\ntiempo en esa zona..."})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="There's been so much horrible\nnews lately. It's discouraging.", french="On ne reçoit plus que des\nmauvaises nouvelles ces derniers temps.\nC'est décourageant.", german="In letzter Zeit gab es so viele\nschreckliche Neuigkeiten. Es ist entmutigend.", italian="Ultimamente ci sono state così\ntante terribili novità... È scoraggiante.", spanish="Últimamente todo son malas\nnoticias. Es desalentador."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 1] || scn($SCENARIO_MAIN) >= [6, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_himeguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="I've heard more and more bad\nPokémon are appearing.", french="On dit qu'il y a de plus en plus\nde Pokémon méchants dans les parages.", german="Ich habe gehört, dass mehr und\nmehr bösartige Pokémon auftauchen.", italian="Dicono che arriveranno Pokémon\nmolto, ma molto più cattivi.", spanish="He oído que cada vez hay más\nPokémon malvados."})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="They say it's caused by time\ngoing out of control.", french="Il paraît que c'est à cause du\ntemps qui se détraque.", german="Man sagt, dass es durch die Zeit\nverursacht wird, die nach und nach außer\nKontrolle gerät.", italian="Pare sia dovuto al tempo\nche è fuori controllo.", spanish="Parece ser que se debe al\ndescontrol del tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="I think it's awful.[K] I wish we\ncould live in peace.", french="Je trouve ça affreux.[K]\nSi seulement nous pouvions vivre en paix.", german="Ich finde das schrecklich.[K] Ich\nwünschte, wir könnten in Frieden leben.", italian="È terribile.[K] Se solo\npotessimo vivere in pace...", spanish="Me parece algo horrible.[K] Ojalá\npudiéramos vivir en paz."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
