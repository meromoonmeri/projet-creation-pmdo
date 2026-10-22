-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/um1116.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_sandopan = SkySceneKit.spawn_npc("sandslash", 480, 224, Direction.UpLeft, "NPC_SANDOPAN")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sandopan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="We're not likely to come here\nagain.", french="Il y a peu de chances qu'on\nrevienne ici un jour.", german="Aller Wahrscheinlichkeit nach\nwerden wir nicht noch einmal hierherkommen.", italian="Probabilmente non torneremo\npiù qui.", spanish=" No creo que volvamos por aquí."})
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english=" Take care.", french="N'oubliez pas, il faut toujours\nrester prudent!", german=" Passt auf euch auf.", italian=" State in gamba.", spanish=" Cuidaos."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 50] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sandopan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="If there's anything we can do to\nhelp, we would, but...", french="Si on pouvait faire quoi que\nce soit pour vous aider, on le ferait, mais...", german="Aber falls wir irgendwie helfen\nkönnen, würden wir das tun...", italian="Se possiamo fare qualcosa per\naiutarvi, fatecelo sapere, ma...", spanish="Si hubiera algo que pudiéramos\nhacer para ayudar lo haríamos, pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english=" That little baby sure was cute.", french=" Ce bébé est tellement mignon.", german="Das Kleine war auf jeden Fall\nsüß.", italian="Quel cucciolo era davvero\ncarino.", spanish=" Aquel pequeñuelo era muy mono."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 48] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sandopan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="Nope, I haven't seen that baby\nPokémon around either.", french="Non, moi non plus, je n'ai pas vu\nle bébé Pokémon dans les parages.", german="Nein, ich habe das kleine\nPokémon nicht gesehen.", italian="No, non ho visto quel cucciolo di\nPokémon qua in giro.", spanish="No, tampoco he visto a ningún\nbebé Pokémon por aquí."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 46) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 46]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sandopan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english=" ...[K]That's one cute baby.", french=" ... [K]Qu'il est mignon, ce bébé.", german=" ...[K]Das ist aber ein süßes Ding.", italian=" ...[K] È proprio un bel cucciolo.", spanish=" Oooh...[K] Qué pequeño tan mono."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 45] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sandopan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="Hey, have you heard? They say\nthere's a fabulous treasure at [CS:P]Midnight Forest[CR].", french="Hé, vous avez entendu? On dit\nqu'il y a un fabuleux trésor dans la [CS:P]Forêt\nMinuit[CR].", german="Hey, habt ihr gehört? Man sagt,\nes gäbe einen sagenhaften Schatz im\n[CS:P]Mitternachtswald[CR].", italian="Ehi, avete sentito? Dicono che\nnella [CS:P]Foresta Mezzanotte[CR] ci sia un tesoro\nfantastico.", spanish="Eh, ¿lo habéis oído? Dicen que\nel [CS:P]Bosque Nocturno[CR] esconde un tesoro\nfabuloso."})
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="There's one obstacle, though.[K]\nYou can't get at that treasure unless you have\na [CS:I]Key[CR].", french="Mais il y a un obstacle de\ntaille.[K] Vous ne pourrez mettre la main sur\nce trésor que si vous avez une [CS:I]Clé[CR].", german="Allerdings gibt es da ein\nHindernis.[K] An diesen Schatz kommt ihr ohne\neinen [CS:I]Schlüssel[CR] nicht heran.", italian="Ma c'è una difficoltà.[K] Non\npotete accedere al tesoro a meno che non\nabbiate una [CS:I]Chiave[CR].", spanish="Sin embargo, hay un obstáculo.[K]\nNo puede conseguirse a menos que se tenga\nla [CS:I]Llave[CR]."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 41] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sandopan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="What's that?[K] You had a Secret\nRank mark added to your Explorer Badge?", french="Hein, quoi?[K] La marque\ndu Grade Secret a été ajoutée à votre\nBadge d'Explorateur?", german="Was ist denn das?[K]\nEurem Erkunderorden wurde eine\nGeheim-Rang-Kennzeichnung hinzugefügt?", italian="Cosa?[K] Sulla vostra Targhetta\ndell'esploratore avete anche il Rango Segreto?", spanish="¿Qué es eso?[K] ¿Que os han\nmarcado vuestra Placa de Explorador con un\nRango Secreto?"})
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english=" Here, may I see it?", french=" Faites voir ça.", german=" Kann ich mal sehen?", italian=" Posso vederlo?", spanish=" Oye, ¿puedo verla?"})
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english=" ...[K]So this mark is it?", french=" ... [K]Alors, c'est cette marque, là?", german="...[K]Also diese Kennzeichnung\nist es?", italian=" ...[K] Quindi è questo?", spanish=" Así que...[K] ¿es esta marca?"})
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="...[K]It's, uh, kind of\ninteresting...", french="... [K]Mouais... c'est... euh...\nassez intéressant, je dois dire...", german="...[K]Das ist, ähem, recht\ninteressant.", italian=" ...[K] Uhm, sembra interessante...", spanish=" Vaya...[K] ¡Qué interesante!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 33] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sandopan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="Taking a break is a good idea\nwhen you are having trouble...but taking too\nlong of a break can be a problem too.", french="Faire une pause en cas de\ndifficulté, c'est bien... mais une pause trop\nlongue peut aussi poser problème.", german="Eine Pause zu machen, ist eine\ngute Idee, wenn man in Schwierigkeiten ist.\nAber allzu lange sollte man auch nicht ruhen.", italian="Fare una pausa se ti trovi nei\nguai è una buona idea... ma non esagerare\nperché potresti correre altri rischi.", spanish="Tomarse un descanso es buena\nidea si te ves en apuros... Siempre y cuando no\ndure demasiado tiempo, claro."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 30] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sandopan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="When you're having trouble,\ntaking a break and resting could help.", french="Quand on rencontre des\ndifficultés, se poser un moment pour\nrécupérer peut être une bonne solution.", german="Wenn du in Schwierigkeiten bist,\nhilft es oft, eine Pause einzulegen und sich\netwas auszuruhen.", italian="Se ti trovi nei guai, ti conviene\nfermarti e riposare.", spanish="Cuando estás en apuros, darse\nun respiro para descansar puede ser útil."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 28] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="I wonder if Team [CS:X]Frontier[CR] has\nreached the top yet...", french="Je me demande si l'Equipe\n[CS:X]Eclaireurs[CR] a déjà atteint le sommet...", german="Ich frage mich, ob Team\n[CS:X]Grenzland[CR] schon oben angekommen ist...", italian="Chissà se il Team [CS:X]Pioniere[CR] ha\ngià raggiunto la cima...", spanish="Me pregunto si el\n[CS:X]Equipo Frontera[CR] habrá llegado ya a la cima..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 24] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="You know... Team [CS:X]Frontier[CR] is\njust awesome.", french="Tu sais... l'Equipe [CS:X]Eclaireurs[CR]\nest tout simplement formidable.", german="Weißt du... Team [CS:X]Grenzland[CR] ist\neinfach der Wahnsinn.", italian="Beh, sai... Il Team [CS:X]Pioniere[CR]\nè semplicemente fantastico.", spanish="¿Sabes? El [CS:X]Equipo Frontera[CR] es\nincreíble."})
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="They're carrying heavy goods and\nestablishing a base for everyone.", french="Ses membres transportent des\nmarchandises très lourdes et établissent des\ncampements pour tout le monde.", german="Sie tragen schwere Dinge, um\nein Basislager für alle zu errichten.", italian="Trasportano merci pesanti e\ncreano un campo base per tutti.", spanish="Están moviendo objetos pesados\ny levantando un campamento para todos."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 20] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="Putting your heart into a gift of\ntreasure...[K] Sounds nice, huh?", french="Faire don d'un trésor en y\nmettant tout son cœur...[K] C'est charmant, non?", german="Sein Herz in ein Schatzgeschenk\nzu stecken...[K] Klingt schön, nicht wahr?", italian="Fare un regalo prezioso con\ntutto il cuore...[K] Che bella cosa, eh?", spanish="Dar un tesoro como regalo con\ntodo el corazón...[K] Suena bonito, ¿eh?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 14] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sandopan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="We're behind you guys![K]\nGood luck!", french="On est de tout cœur avec vous![K]\nBonne chance!", german="Wir stehen hinter euch, Leute![K]\nViel Glück!", italian="Facciamo il tifo per voi![K]\nBuona fortuna!", spanish=" ¡Os apoyamos![K] ¡Buena suerte!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sandopan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="You're saying our planet's\nparalyzed in the future?", french="Vous dites que dans le futur,\nnotre planète est paralysée?", german="Ihr behauptet, unser Planet sei\nin der Zukunft gelähmt?", italian="State dicendo che nel futuro il\nnostro pianeta rischia di rimanere paralizzato?", spanish="¿Dices que en el futuro nuestro\nplaneta está totalmente paralizado?"})
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english=" ...[K]You're not kidding?!", french=" ... [K]C'est sérieux?!", german=" ...[K]Ernsthaft?!?", italian=" ...[K] Non state scherzando?!", spanish="Tienes...[K] Tienes que estar\nbromeando, ¿verdad?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sandopan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="That [CS:N]Grovyle[CR] needs to be\ncaught...and fast!", french="Il faut attraper ce [CS:N]Massko[CR]...\net vite!", german="Dieser [CS:N]Reptain[CR] muss gefasst\nwerden! Und zwar schnell!", italian="Dobbiamo fermare [CS:N]Grovyle[CR]...\ne in fretta!", spanish="Hay que pararle los pies a ese\n[CS:N]Grovyle[CR]... ¡y cuanto antes!"})
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="I can't sleep at night from all\nthe worrying this is causing!", french="Je suis si inquiet que je n'en\ndors plus la nuit!", german="Diese Sorgen lassen mich nachts\nschon nicht mehr schlafen!", italian="Di notte non dormo per la\npreoccupazione.", spanish="¡No puedo dormir con todas\nestas preocupaciones!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sandopan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="Stealing Time Gears... That's\nabout as wrong as you can get.", french="Voler les Rouages du Temps...\nIl n'y a pas plus abject.", german="Zahnräder der Zeit zu stehlen...\nDas ist der Gipfel des Unrechts!", italian="Rubare gli Ingranaggi del\nTempo... È la cosa più sbagliata che si\npossa fare.", spanish="Robar Engranajes del Tiempo...\nEso es lo peor que se puede hacer."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 4] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sandopan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="We're considering going after\na high-ranking outlaw. We just may go for it.", french="Nous envisageons de nous lancer\nà la poursuite d'un hors-la-loi de grade élevé.\nOn va peut-être tenter le coup.", german="Wir überlegen gerade, ob wir\neinen hochrangigen Ganoven verfolgen sollen.\nVielleicht versuchen wir es einfach.", italian="Stiamo pensando di dare la\ncaccia a un ricercato di alto livello. Ce la\npossiamo fare.", spanish="Estamos planteándonos ir tras\nun malhechor de los difíciles de atrapar.\nTal vez lo hagamos."})
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="It would be a tough fight. But\nthere's only one enemy.", french="Ce sera un combat difficile.\nMais il sera tout seul contre nous.", german="Es wäre ein harter Kampf, aber\nimmerhin ist es nur ein einziger Gegner.", italian="Sarà una dura lotta, ma il\nnemico è uno solo.", spanish="Sería una lucha dura. Pero solo\nes un enemigo."})
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="With all three of us in on it,\nwe can take one outlaw!", french="A nous trois, on peut capturer\nun criminel!", german="Wenn wir drei uns abstimmen,\nkönnen wir einen einzelnen Ganoven besiegen!", italian="Unendo le nostre forze,\npossiamo catturarlo!", spanish="Si nos encargamos los tres, creo\nque podríamos con un solo malhechor."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 1] || scn($SCENARIO_MAIN) >= [10
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sandopan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="It's a bit different from being\neco-friendly, isn't it?", french="Ce ne sont pas vraiment des\nactions qui s'échangent dans cette bourse, si?", german="So richtig umweltfreundlich\nist das aber nicht, oder?", italian="Chissà se è anche rispettoso\ndell'ambiente...", spanish="Me pregunto si será respetuosa\ncon el medio ambiente..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 3] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sandopan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english=" This is a pretty nice shop...", french=" C'est un magasin sympa...", german="Dies ist ein richtig toller\nLaden...", italian=" È davvero un bel locale...", spanish=" Esta tienda está bastante bien..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 3] || scn($SCENARIO_MAIN) >= [7, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sandopan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="We slash our way through deep\nwoods with our sharp claws!", french="Nous nous taillons un chemin\ndans la forêt grâce à nos griffes acérées!", german="Wir bahnen uns unseren Weg\ndurch tiefe Wälder mit unseren scharfen\nKlauen!", italian="Ci facciamo strada nella fitta\nboscaglia con i nostri artigli affilati!", spanish="Con nuestras afiladas garras,\nnos abrimos paso por los bosques."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [5, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
