-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/um1106.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_dorapion = SkySceneKit.spawn_npc("drapion", 232, 256, Direction.Up, "NPC_DORAPION")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dorapion, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="We found out [CS:P]Zero Isle[CR] is no\nordinary place.", french="Nous avons découvert que l'[CS:P]Ile\nZéro[CR] était tout sauf un endroit ordinaire.", german="Wir haben herausgefunden, dass\ndie [CS:P]Null-Insel[CR] kein gewöhnlicher Ort ist.", italian="Sappiamo che l'[CS:P]Isola Zero[CR] non è\nun posto come gli altri.", spanish="Parece ser que la [CS:P]Isla Cero[CR] no\nes un lugar corriente."})
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="It turns out that the island has\nseveral dungeons.[K] They each put restrictions on\nexplorers in a unique way.", french="En réalité, il y a plusieurs\ndonjons sur l'île.[K] Chacun impose ses propres\ncontraintes à l'explorateur qui y pénètre.", german="Es sieht so aus, als gäbe es auf\nder Insel mehrere verschiedene Dungeons.[K] Sie\nalle legen Erkundern diverse Bürden auf.", italian="Sembra che l'isola abbia diversi\ndungeon.[K] Ognuno di questi pone restrizioni\nnei confronti degli esploratori.", spanish="Resulta que hay diferentes\nterritorios en la isla.[K] Y en cada uno se\naplican distintas restricciones."})
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="Some places knock you down to\nLevel 1 temporarily, and another prevents you\nfrom leveling up.", french="Certains vous font retomber\ntemporairement au Niveau 1, et d'autres\nvous empêchent de monter de niveau.", german="Einige Orte lassen deinen Level\nvorübergehend auf 1 sinken, andere verhindern\neinen Levelaufstieg.", italian="Alcuni posti ti fanno tornare\ntemporaneamente al Livello 1 e altri non ti\nconsentono di salire di livello.", spanish="Algunos te rebajan al Nivel 1\ntemporalmente y otros te impiden subir de\nnivel."})
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="You may also not be allowed to\ntake items in. You'll be restricted in some way\nor another with those dungeons.", french="Parfois, il est interdit d'y\nemporter des objets. Ces donjons imposent\ntous des contraintes diverses.", german="Eventuell ist es dir untersagt,\nItems mitzunehmen. In diesen Dungeons werdet\nihr auf verschiedene Arten eingeschränkt.", italian="In altri non è permesso\nportare strumenti. In un modo o nell'altro,\nquesti dungeon ti pongono restrizioni.", spanish="También pueden prohibirte\nentrar con objetos. Siempre hay algún tipo de\nrestricción en estos territorios."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dorapion, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="[CS:P]Zero Isle[CR] is to the south of\nhere, across the sea.", french="L'[CS:P]Ile Zéro[CR] se trouve au sud d'ici,\nde l'autre côté de la mer.", german="Die [CS:P]Null-Insel[CR] befindet sich\nsüdlich von hier, jenseits des Meeres.", italian="L'[CS:P]Isola Zero[CR] si trova a sud di\nqui, oltre il mare.", spanish="La [CS:P]Isla Cero[CR] está al sur de aquí,\ncruzando el mar."})
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="That's where we're about to\nraid now!", french="C'est notre prochaine\ndestination!", german="Das ist der Ort, den wir im\nBegriff sind, zu erkunden!", italian="Stiamo per andare a\nsaccheggiarla!", spanish="Nos dirigimos hacia allí\nprecisamente."})
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="The mountains of treasures and\ngold in there... We mean to have it all!", french="Des montagnes d'or et de\ntrésors... Tout ça sera à nous!", german="Die Schatz- und Goldberge dort\ndrinnen... Wir wollen sie alle haben!", italian="Ci sono montagne d'oro e di\ntesori laggiù... Vogliamo tutto!", spanish="Montañas de oro y riquezas...\n¡Pretendemos quedarnos con todo!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 4] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_aabokku = SkySceneKit.spawn_npc("arbok", 280, 256, Direction.Up, "NPC_AABOKKU")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_manyuura = SkySceneKit.spawn_npc("weavile", 256, 232, Direction.Up, "NPC_MANYUURA")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dorapion, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dorapion, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="Hey, you two.[K] Do you have any\nnews on [CS:P]Zero Isle[CR]?", french="Hé, vous deux.[K] Vous auriez pas\ndes infos sur l'[CS:P]Ile Zéro[CR], par hasard?", german="Hey, ihr zwei.[K] Habt ihr\nirgendwelche Neuigkeiten über die [CS:P]Null-Insel[CR]?", italian="Ehi, voi due.[K] Sapete qualcosa\ndell'[CS:P]Isola Zero[CR]?", spanish="Eh, pareja.[K] ¿Alguna noticia de\nla [CS:P]Isla Cero[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:P]Zero Isle[CR]?", french=" L'[CS:P]Ile Zéro[CR]?", german=" Die [CS:P]Null-Insel[CR]?", italian=" L'[CS:P]Isola Zero[CR]?", spanish=" ¿La [CS:P]Isla Cero[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:P]Zero Isle[CR]?", french=" L'[CS:P]Ile Zéro[CR]?", german=" Die [CS:P]Null-Insel[CR]?", italian=" L'[CS:P]Isola Zero[CR]?", spanish=" ¿La [CS:P]Isla Cero[CR]?"})
  else
  SkySceneKit.say({english=" [CS:P]Zero Isle[CR]?", french=" L'[CS:P]Ile Zéro[CR]?", german=" Die [CS:P]Null-Insel[CR]?", italian=" L'[CS:P]Isola Zero[CR]?", spanish=" ¿La [CS:P]Isla Cero[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dorapion, partner, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="Yeah. Rumor has it that the\ngreatest treasures are there...", french="Ouais. Le bruit court que\nc'est là que se trouvent les trésors\nles plus fabuleux...", german="Ja. Gerüchten zufolge sind dort\ndie größten Schätze zu finden...", italian="Sì. Girano voci che ci siano\ndei grandi tesori laggiù...", spanish="Sí. Se rumorea que oculta\ngrandes tesoros..."})
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="But the treasures aren't the\nmost fascinating thing about that place.", french="Mais sur cette île, il y a\nune chose encore plus fascinante que les\ntrésors.", german="Aber die Schätze sind nicht das\nfaszinierendste an jenem Ort.", italian="Ma i tesori non sono la cosa più\ninteressante di quel posto.", spanish="Aunque esos tesoros no son lo\nmás fascinante de ese sitio, ni mucho\nmenos."})
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="When you go in the dungeon...[K]\neveryone is temporarily dropped to Level 1 and\ntheir learned abilities are zeroed out.", french="Quiconque entre dans ce donjon...\nretombe temporairement au Niveau 1 et oublie\ntoutes les capacités apprises auparavant.", german="Wenn man den Dungeon betritt,[K]\nwird jeder vorübergehend auf Level 1 zurück-\ngestuft und seine Fähigkeiten werden entfernt.", italian="Chiunque entri nel dungeon...[K]\ntorna temporaneamente al Livello 1 e tutte\nle abilità che ha imparato si azzerano.", spanish="Al entrar en ese territorio...[K]\nbajas al Nivel 1 y pierdes las habilidades\nque has aprendido."})
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="From what we've heard, you\ncan't even take in items.", french="A ce qu'on dit, on ne peut même\npas y emporter d'objets.", german="Unseres Wissens kann man nicht\neinmal Items mit hineinnehmen.", italian="Per quel che ne sappiamo, non\npotete neanche portarvi gli strumenti.", spanish="Por lo que he oído, ni siquiera\npuedes llevar objetos."})
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="Basically, you walk in alone as if\nyou're a rank amateur again.", french="En fait, on y entre tout seul,\ncomme un vulgaire amateur.", german="Im Grunde genommen ist es wie\ndamals, als dein Rang noch der eines Amateurs\nwar.", italian="A farla breve, ci dovete entrare\nda soli come se foste ancora dei novellini.", spanish="Básicamente, es como volver a\nexplorar como si fueras un principiante."})
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="No exploration team's made it to\nthe end yet.", french="Aucune équipe d'exploration\nn'est encore parvenue à finir ce donjon.", german="Kein Erkundungsteam hat es\nbisher bis zum Ende geschafft.", italian="Non ce l'ha ancora fatta nessuna\nsquadra d'esplorazione.", spanish="Ningún equipo explorador ha\nlogrado atravesar este territorio."})
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="They're calling it the ultimate\ndungeon for good reason.", french="Ce n'est pas pour rien qu'il est\nsurnommé \"l'ultime donjon\".", german="Sie nennen es aus gutem Grund\nden ultimativen Dungeon.", italian="È per questo che lo chiamano\nil dungeon definitivo.", spanish="Por algo lo llaman el territorio\nsupremo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_manyuura, npc_npc_dorapion, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english=" [CS:N]Drapion[CR]![K] You talk too much!", french=" [CS:N]Drascore[CR]![K] Tu parles trop!", german=" [CS:N]Piondragi[CR]![K] Du redest zu viel!", italian=" [CS:N]Drapion[CR]![K] Parli troppo!", spanish=" ¡[CS:N]Drapion[CR]![K] ¡Hablas demasiado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dorapion, npc_npc_manyuura, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_manyuura, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_manyuura, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dorapion, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english=" Urk![K] I'm sorry, my lady [CS:N]Weavile[CR].", french="Oups![K] Veuillez m'excuser,\ndame [CS:N]Dimoret[CR].", german=" Ups![K] Es tut mir leid, [CS:N]Snibunna[CR].", italian=" Ups![K] Mi spiace, lady [CS:N]Weavile[CR].", spanish="¡Huy![K] Discúlpeme, señorita\n[CS:N]Weavile[CR]."})
  -- message_Close
  GROUND:EntTurn(npc_npc_dorapion, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dorapion, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="We're Team [CS:X]AWD[CR]![K] We're a band\nof thieves led by [CS:N]Weavile[CR].", french="On est l'Equipe [CS:X]DDA[CR]![K]\nOn est une bande de voleurs, et notre chef\ns'appelle [CS:N]Dimoret[CR].", german="Wir sind Team [CS:X]SPA[CR]![K] Wir sind\neine Gruppe von Dieben und werden von\n[CS:N]Snibunna[CR] angeführt.", italian="Noi siamo il Team [CS:X]AWD[CR]![K]\nSiamo una banda di ladri guidati da [CS:N]Weavile[CR].", spanish="¡Somos el [CS:X]Equipo WAD[CR]![K]\nUna banda de ladrones dirigida por [CS:N]Weavile[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="Our travels in search of the\nultimate treasures brought us here...", french="Notre quête du trésor suprême\nnous a conduits jusqu'ici...", german="Die Suche nach dem ultimativen\nSchatz hat uns hierher geführt...", italian="I nostri viaggi alla ricerca dei\ntesori più ambiti ci hanno portato fin qui...", spanish="Nuestros viajes en busca de los\nmejores tesoros nos han traído hasta aquí..."})
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="But this place doesn't appear to\nbe much of a prospect.", french="Mais j'ai bien peur qu'on ne\ntrouve rien d'intéressant ici.", german="Aber dieser Ort sieht nicht\nsonderlich vielversprechend aus.", italian="Ma questo posto non sembra\noffrire granché.", spanish="Pero este lugar no parece que\nvaya a ser de provecho."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 7] || scn($SCENARIO_MAIN) >= [4, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
