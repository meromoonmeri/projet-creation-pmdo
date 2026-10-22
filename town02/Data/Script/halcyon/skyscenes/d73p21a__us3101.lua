-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P21A/us3101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_kagebouzu = SkySceneKit.spawn_npc("shuppet", 320, 240, Direction.Left, "NPC_KAGEBOUZU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kagebouzu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="My partner [CS:N]Murkrow[CR] won't do\nanything I say.", french="Ma partenaire, [CS:N]Cornèbre[CR],\nn'écoute jamais ce que je lui dis de faire.", german="Mein Partner [CS:N]Kramurx[CR] tut nichts\nvon dem, was ich ihr auftrage.", italian="La mia compagna [CS:N]Murkrow[CR] non\nfa nulla di quello che le dico.", spanish="Mi compañera [CS:N]Murkrow[CR] nunca\nhace lo que le digo."})
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="I really want to go look for the\n[CS:I]Secret Slab[CR], but...", french="J'aimerais vraiment partir en\nquête du [CS:I]Bloc Secret[CR], mais...", german="Ich möchte wirklich gerne die\n[CS:I]Geheimtafel[CR] suchen gehen, aber...", italian="Vorrei davvero cercare la\n[CS:I]Lastraenigma[CR], ma...", spanish="Querría buscar la [CS:I]Losa Secreta[CR],\npero..."})
  -- message_Close
  -- @label_131 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 93] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kagebouzu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="We've been on the hunt for the\n[CS:I]Golden Apple[CR], but...[K]we've given up.", french="Nous avons longtemps cherché\nla [CS:I]Pomme d'Or[CR], mais en vain...[K]\nNous avons fini par abandonner.", german="Wir sind auf der Jagd nach dem\n[CS:I]Goldapfel[CR] gewesen, aber[K] wir haben aufgegeben.", italian="Siamo andate alla ricerca della\n[CS:I]Mela Dorata[CR], ma...[K] abbiamo rinunciato.", spanish="Hemos intentado encontrar la\n[CS:I]Manzana Oro[CR], pero...[K] nos hemos rendido."})
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="My partner [CS:N]Murkrow[CR] has no\npatience or endurance for searches...", french="Ma partenaire, [CS:N]Cornèbre[CR],\nla patience, ce n'est pas son fort,\nla persévérance non plus d'ailleurs...", german="Mein Partner [CS:N]Kramurx[CR] hat\nweder Geduld noch Ausdauer bei Suchaktionen.", italian="La mia compagna [CS:N]Murkrow[CR] non\nha abbastanza pazienza e resistenza per le\nricerche...", spanish="Mi compañera [CS:N]Murkrow[CR] no tiene\nni paciencia ni resistencia para buscar."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 71] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kagebouzu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="We finally agreed on something\nthat we both prized!", french="On s'est finalement mises\nd'accord sur un trésor qui nous intéresse\ntoutes les deux!", german="Wir haben uns schlussendlich auf\netwas geeinigt, das wir beide schätzen!", italian="Finalmente siamo d'accordo su\nuna cosa a cui diamo entrambe valore!", spanish="¡Por fin hemos acordado qué\ntesoro buscar!"})
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="That treasure is none other\nthan...[K]the [CS:I]Golden Apple[CR].", french="Ce trésor, c'est ni plus ni moins\nque... [K]la [CS:I]Pomme d'Or[CR].", german="Der Schatz ist nichts anderes\nals...[K] der [CS:I]Goldapfel[CR].", italian="Questo tesoro non è altro che...[K]\nla [CS:I]Mela Dorata[CR].", spanish="Y el tesoro en cuestión es...[K] la\n[CS:I]Manzana Oro[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english=" So?[K] Know anything about it?", french="Alors?[K] Ça vous dit quelque\nchose?", german=" Nun?[K] Weißt du etwas darüber?", italian=" Allora?[K] Ne sapete qualcosa?", spanish=" ¿Eh?[K] ¿Sabéis algo de eso?"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 33] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kagebouzu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="I rode the Gondola, but it only\ngoes as far as the 6th Station Clearing.", french="J'ai pris la Navette, mais elle\nne monte que jusqu'à la trouée du 6[F:E] Relais.", german="Ich habe die Seilbahn genommen.\nSie reicht aber nur bis zur\n6. Zwischenlagerlichtung.", italian="Peccato che con l'Agenzia\nViaggi Drifblim si possa arrivare solo\nfino al Bivacco 6.", spanish="Me subí a la góndola, pero solo\nllega hasta la Base del Sexto Puerto."})
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="I wanted to climb all the way\nto the top, but...", french="Moi, je voulais grimper jusqu'au\nsommet, mais...", german="Ich wollte bis ganz nach oben\nklettern...", italian="Volevo arrivare fino in cima,\nma...", spanish="Es una lástima, porque yo\nlo que quería era llegar a la cima..."})
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="[CS:N]Murkrow[CR] insisted she's weary\nof climbing, so we just left...", french="[CS:N]Cornèbre[CR] m'a dit qu'elle n'en\npouvait plus, alors nous sommes parties...", german="Aber [CS:N]Kramurx[CR] war der Kletterei\nüberdrüssig, also sind wir einfach gegangen...", italian="... [CS:N]Murkrow[CR] era troppo stanca\nper continuare e così abbiamo lasciato perdere.", spanish="[CS:N]Murkrow[CR] insistió en que se\nhabía cansado de ascender y nos fuimos..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 30] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english=" Gondolas are so convenient...", french=" Les navettes sont si pratiques...", german=" Seilbahnen sind so praktisch...", italian="L'Agenzia Viaggi Drifblim è così\ncomoda...", spanish=" Las góndolas son muy prácticas."})
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="I love it when it's easy to find\nlots of treasure!", french="J'adore quand on trouve plein\nde trésors d'un coup!", german="Ich liebe es, ohne Aufwand\nviele Schätze zu finden!", italian="Adoro trovare tanti tesori senza\nfare la minima fatica!", spanish="Me encantan los tesoros que\nson fáciles de encontrar... ¡y abundantes!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 26] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="When I'm searching for\ntreasure, it makes it hard to move forward.", french="Quand je passe du temps à\nchercher un trésor, j'avance difficilement.", german="Wenn ich auf Schatzsuche bin,\nfällt es mir nicht leicht, voranzukommen.", italian="Quando sono alla caccia di\ntesori, diventa difficile andare avanti.", spanish="Cuando estoy buscando tesoros,\nme cuesta avanzar."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 20] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kagebouzu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="How time flies when looking\nfor treasure, but the wind will blow you away\nif you stay on the same floor too long.", french="Comme le temps passe vite\nquand on cherche des trésors, mais si on\ns'attarde dans un étage, le vent nous chasse.", german="Die Zeit auf Schatzsuche vergeht\nsehr schnell. Nur sollte man nicht zu lange auf\neiner Ebene weilen, sonst wird man weggeweht.", italian="Quando sei alla ricerca di tesori\nil tempo vola, ma se rimani sullo stesso piano\ntroppo a lungo, il vento ti spazzerà via.", spanish="El tiempo vuela cuando buscas\ntesoros, pero el viento se te llevará si\nte quedas demasiado tiempo en el mismo piso."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 16] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="[CS:N]Murkrow[CR] keeps saying,\n\"Gold! Gold!\" and I'm getting sick of it...", french="[CS:N]Cornèbre[CR] n'arrête pas de crier\n\"De l'or! Encore!\", et ça me rend malade...", german="[CS:N]Kramurx[CR] sagt ständig nur\n[F:S2]Gold! Gold![F:E2]. Und das geht mir auf den Keks...", italian="[CS:N]Murkrow[CR] non fa che parlare di\noro, oro, oro! Non ne posso più...", spanish="[CS:N]Murkrow[CR] no para de decir:\n\"¡Oro, oro!\", y ya me estoy hartando..."})
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="I would rather find some stylish\nand elegant treasure...", french="Moi, je préférerais trouver un\ntrésor qui a du style, un trésor élégant...", german="Ich würde lieber einen eleganten\nund stilvollen Schatz finden...", italian="Io preferirei trovare qualche\ntesoro più raffinato ed elegante...", spanish="A mí me parecería ideal\nencontrar un tesoro elegante y estiloso..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 9) >= 0) or (SkyProg.cmp(29, 8) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 11] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kagebouzu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="\"Mysterious Mountain\" just\nsounds cool.", french="\"La Montagne Mystérieuse\",\nça sonne vraiment bien.", german="[F:S2]Mysteriöser Berg[F:E2] klingt\neinfach cool.", italian="\"Montagna Misteriosa\"... che\nnome affascinante.", spanish="\"Montaña Misteriosa\" suena\nsuperguay."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 6] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kagebouzu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="The guild seems to be buzzing\nwith activity...", french="La Guilde a l'air en\neffervescence en ce moment...", german="In der Gilde herrscht ein reges\nTreiben.", italian="La Gilda sembra pullulare di\nattività...", spanish="El [CS:N]Pokégremio[CR] está rebosante de\nactividad..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kagebouzu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="We found a mysterious\ntreasure box in a dungeon.", french="On a trouvé un mystérieux\ncoffre au fin fond d'un donjon.", german="Wir haben eine mysteriöse\nSchatzbox in einem Dungeon gefunden.", italian="Abbiamo trovato un forziere\nmisterioso in un dungeon.", spanish="Encontramos un misterioso cofre\ndel tesoro en un territorio."})
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="We visited Treasure Town so\nwe could have the box appraised at\n[CS:K]Xatu[CR]'s shop.", french="On est venues à Bourg-Trésor\npour faire expertiser le coffre chez [CS:K]Xatu[CR].", german="Wir sind nach Schatzstadt\ngereist, um die Box bei der\n[CS:K]Xatu-Begutachtung[CR] untersuchen zu lassen.", italian="Siamo andate all'Ufficio Perizie\ndi [CS:K]Xatu[CR], qui a Borgo Tesoro, che ci ha aperto\nil forziere.", spanish="Vinimos a Aldea Tesoro para\nque nos lo abrieran en el [CS:K]Anticuario Xatu[CR]."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 1] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kagebouzu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="I'm interested in a treasure\ncalled [CS:I]Mystery Part[CR].", french="Je m'intéresse à un trésor\nconnu sous le nom de [CS:I]Pièce Mystère[CR].", german="Mich interessiert ein Schatz\nnamens [CS:I]Geheimteil[CR].", italian="Sto cercando un tesoro che\nsi chiama [CS:I]Pezzoenigma[CR].", spanish="Últimamente no hago más que\npensar en la [CS:I]Pieza Enigma[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="It's a legendary item that's\nveiled in mystery.[K] Well? Don't you find it\nintriguing?", french="C'est un objet légendaire sur\nlequel planent bien des mystères.[K] Alors?\nVous ne trouvez pas ça fascinant?", german="Es handelt sich um ein\nlegendäres Item, das in Mysterien verschleiert\nliegt.[K] Sagt nicht, ihr findet das nicht fesselnd!", italian="È uno strumento leggendario che\nè celato nel mistero.[K] Beh?\nNon è intrigante?", spanish="Es un objeto legendario rodeado\nde misterios.[K] ¿No os resulta intrigante?"})
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english=" But my partner [CS:N]Murkrow[CR]...", french=" Mais ma partenaire, [CS:N]Cornèbre[CR]...", german=" Aber mein Partner [CS:N]Kramurx[CR]...", italian=" Ma la mia compagna [CS:N]Murkrow[CR]...", spanish=" Pero mi compañera [CS:N]Murkrow[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="She's like, \"I have no interest in\na drab and dingy thing like that!\"", french="Elle dit tout le temps:\n\"Un truc aussi terne et miteux n'a aucun\nintérêt pour moi!\"", german="[F:S2]Ich habe kein Interesse an\ndiesem eintönigen trüben Ding![F:E2], waren\nihre Worte.", italian="Lei dice: \"Non mi interessano\ncose povere e squallide come quella!\".", spanish="Dice que no le interesa algo tan\ngris y lúgubre."})
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english=" Oh, what am I to do with her...?", french="Oh, qu'est-ce que je vais\nbien pouvoir faire d'elle...?", german="Oh, was soll ich bloß mit ihr\nmachen?", italian=" Oh, cosa devo fare con lei...?", spanish=" Ay, ¿qué voy a hacer con ella?"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 4] || scn($SCENARIO_MAIN) >= [14
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kagebouzu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="Gummi? [CS:I]Apple[CR]?\nOh, I can't decide...", french="Gelée? [CS:I]Pomme[CR]?\nOh, impossible de choisir...", german="Gummi? [CS:I]Apfel[CR]?\nOh, ich kann mich nicht entscheiden...", italian="Una Gomma? O una [CS:I]Mela[CR]?\nOh, non so cosa scegliere...", spanish="¿Gomi? ¿[CS:I]Manzanita[CR]?\nJo, no consigo decidirme..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kagebouzu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="Did you know? There are ranks\nto exploration teams.", french="Les équipes d'exploration sont\nclassées selon leur grade. Vous le saviez?", german="Wusstet ihr das schon?\nErkundungsteams werden Ränge zugeordnet.", italian="Le squadre di esplorazione sono\nclassificate per ranghi, lo sapevate?", spanish="¿Sabíais que hay distintos\nrangos de equipos?"})
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="We of Team [CS:X]Ebony[CR] have the\nSilver Rank.", french="Nous, l'Equipe [CS:X]Ebène[CR], on a le\nGrade Argent.", german="Wir von Team [CS:X]Ebenholz[CR]\nverfügen über den Silber-Rang.", italian="Noi del Team [CS:X]Nero[CR] abbiamo il\nRango Argento.", spanish="Nosotras, el [CS:X]Equipo Azabache[CR],\ntenemos el Rango Plata."})
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english=" Well?[K] Nice, huh?", french=" Alors?[K] Pas mal, hein?", german=" Nun?[K] Gut, oder?", italian=" Beh?[K] Bello, no?", spanish=" ¿Y bien?[K] ¿No está nada mal, eh?"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 7] || scn($SCENARIO_MAIN) >= [4, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kagebouzu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="We're Team [CS:X]Ebony[CR].[K] We've\ntraveled and explored all over.", french="On est l'Equipe [CS:X]Ebène[CR].[K] On a\nbeaucoup voyagé et exploré le monde entier.", german="Wir sind Team [CS:X]Ebenholz[CR].[K] Wir\nsind schon überallhin gereist und haben alles\nerkundet.", italian="Siamo il Team [CS:X]Nero[CR].[K] Abbiamo\nviaggiato ed esplorato molto.", spanish="Somos el [CS:X]Equipo Azabache[CR].[K]\nHemos viajado y explorado por todas partes."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 0] || scn($SCENARIO_MAIN) >= [3, 
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
