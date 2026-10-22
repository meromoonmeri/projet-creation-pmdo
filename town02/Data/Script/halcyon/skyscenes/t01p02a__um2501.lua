-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/um2501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_zanguusu = SkySceneKit.spawn_npc("zangoose", 368, 264, Direction.Up, "NPC_ZANGUUSU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_zanguusu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="Like there are encounters, so\nthere too must be farewells.", french="Tout comme il y a des\nrencontres, il doit y avoir des adieux.", german="So, wie es erste Treffen\ngibt, muss es auch Abschiede geben.", italian="La vita è così...\nÈ fatta di incontri e di addii...", spanish="Igual que hay encuentros, debe\nhaber despedidas."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 50] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_zanguusu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="Phione Dew?[K] Oh, that! Yes!\nThey say that it's a cure-all.", french="La Rosée Phione?[K] Ah, oui!\nOn dit que c'est un remède miracle capable\nde tout soigner.", german="Phione-Tau?[K] Ach so! Ja!\nSie sagen, es sei ein Allheilmittel.", italian="Brina Phione?[K] Oh, quella! Sì!\nDicono che sia una panacea.", spanish="¿Rocío Phione?[K] ¡Ah, claro!\n¡Sí! Dicen que lo cura todo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 48] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_zanguusu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="What? That rare Pokémon you\nwere with yesterday?", french="Quoi? Ce Pokémon rare qui était\navec vous hier?", german="Was? Das seltene Pokémon, mit\ndem ihr gestern unterwegs wart?", italian="Cosa? Quel Pokémon raro che\nera ieri con voi?", spanish="¿Qué? ¿Aquel Pokémon tan\ninusual que os acompañaba ayer?"})
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english=" Nope, haven't seen him.", french=" Non, je ne l'ai pas vu.", german="Nein, wir haben es nicht\ngesehen.", italian=" No, non l'abbiamo visto.", spanish=" No, no lo hemos visto."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 46) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 46]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_zanguusu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="That Pokémon you have with you\nis one rarely even seen!", french="Le Pokémon qui vous\naccompagne appartient à une espèce qu'on voit\ntrès rarement!", german="Dieses Pokémon, das ihr dabei\nhabt, taucht nur sehr selten auf!", italian="Quel Pokémon che è con voi\nè uno dei più rari!", spanish="Ese Pokémon que os acompaña\nno es de los que se ven a menudo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 45] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_zanguusu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="Do you two know of a place\ncalled [CS:P]Midnight Forest[CR]?", french="Vous avez déjà entendu parler\nd'un endroit appelé la [CS:P]Forêt Minuit[CR]?", german="Sagt euch beiden ein Ort namens\n[CS:P]Mitternachtswald[CR] etwas?", italian="Conoscete un posto chiamato\n[CS:P]Foresta Mezzanotte[CR]?", spanish="¿Conocéis un lugar llamado\n[CS:P]Bosque Nocturno[CR]?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 41] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_zanguusu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english=" I don't know, either.", french=" Moi non plus, je ne sais pas.", german=" Ich weiß es auch nicht.", italian=" Non ne so nulla.", spanish=" Yo tampoco lo sé."})
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="I don't know a thing about the\nSecret Rank.[K] Or about an Honorary Member of\nthe Pokémon Exploration Team Federation.", french="Je n'ai jamais entendu parler\ndu Grade Secret.[K] Ni des Membres Honoraires\nde la Fédération des Equipes d'Exploration.", german="Ich weiß gar nichts über den\nGeheim-Rang.[K] Oder über ein Ehrenmitglied des\nPokémon-Erkundungsteamverbands.", italian="Non so nulla del Rango Segreto.[K]\nNé del membro onorario della Federazione\nSquadre d'Esplorazione dei Pokémon.", spanish="No sé nada acerca de ese Rango\nSecreto.[K] Ni sobre ningún miembro honorario\nde la Federación de Exploradores."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 33] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_zanguusu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="Hey! I heard you climbed all the\nway to the top!", french="Hé! J'ai entendu dire que vous\naviez escaladé la montagne jusqu'au sommet!", german="Hey! Ich hörte, dass ihr den\nganzen Weg bis zur Spitze geklettert seid!", italian="Ehi! Ho sentito che avete\nraggiunto la cima!", spanish="¡Oye! He oído que has llegado\nhasta la cima."})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_zanguusu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english=" Us? Did we climb to the top too?", french="Hein? Est-ce qu'on est allés\njusqu'au sommet, nous aussi?", german="Äh? Du fragst, ob wir bis zur\nSpitze gekommen sind?", italian="Eh? Mi chiedi se anche noi\nsiamo arrivati in cima?", spanish="¿Cómo? ¿Que si hemos llegado\na la cima y por eso nos lo tomamos con calma?"})
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="Taking a break can be good and\nbad... It's difficult to get moving again.", french="Faire une pause, ça a ses\navantages et ses inconvénients... C'est si\ndur de se remettre en route.", german="Eine Pause einzulegen kann gut,\naber auch schlecht sein... Es ist schwierig,\nsich wieder aufzuraffen.", italian="Fare una pausa non è sempre\nvantaggioso... Dopo è così difficile rimettersi\nin cammino.", spanish="Pues es que tomarse un descanso\npuede ir bien, pero luego da una pereza\nmoverse..."})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_zanguusu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english=" Hah-hahahaha.", french=" Ha-hahahaha.", german=" Hah-hahahaha.", italian=" Ahh-ahahah.", spanish=" ¡Ja... ja, ja, ja, ja!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_zanguusu, nil, 0) end) -- EFFECT_NONE
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 30] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_zanguusu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="Did you climb all the way to the\ntop of [CS:P]Sky Peak[CR]?", french="Avez-vous escaladé le\n[CS:P]Pic Céleste[CR] jusqu'au sommet?", german="Seid ihr den ganzen Weg bis zur\nSpitze des [CS:P]Himmelsgipfels[CR] aufgestiegen?", italian="Voi ce l'avete fatta a\nraggiungere la cima del [CS:P]Picco del Cielo[CR]?", spanish="¿Has llegado hasta la cima de la\n[CS:P]Cumbre del Cielo[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="We got tired right around the\nsnowy area, so we decided to take a break.", french="On a commencé à sentir la\nfatigue là où la neige commence, alors on a\ndécidé de faire une pause.", german="Wir wurden im schneebedeckten\nGebiet etwas müde, darum haben wir dort\neine Pause gemacht.", italian="Noi abbiamo dovuto fare una\npausa dalle parti della zona innevata perché\neravamo esausti.", spanish="Empezamos a agotarnos por la\nzona nevada y decidimos tomarnos un descanso."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 28] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="It looks like the going will be\ntough from here on.", french="On dirait que l'ascension va\ndevenir plus ardue à partir de là.", german="Es scheint, dass der Weg von\nhier an ein wenig härter wird.", italian="Credo che da qui in poi ci sarà\nda sudare un bel po'.", spanish="Por lo visto la cosa se complica\npor momentos."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 24] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="Looks like there will be snow\nfrom here on out.", french="On dirait qu'à partir d'ici,\ntout est recouvert de neige.", german="Sieht so aus, als wird es von\nhier aus verschneit sein.", italian="Pare che ci sarà un bel po' di\nneve da qui in avanti.", spanish="Parece que a partir de este\npunto encontraremos nieve."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 20] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="I was thinking that [CS:I]Sky Gift[CR] was\nsome kind of a joke, because it was completely\nempty when I opened it.", french="J'ai cru que ce [CS:I]Don du Ciel[CR]\nétait une sorte de blague, parce qu'il était\ncomplètement vide quand je l'ai ouvert.", german="Ich dachte, das [CS:I]Himmelspräsent[CR]\nsei eine Art Witz, weil es komplett leer war,\nals ich es geöffnet habe.", italian="Quando ho aperto quel [CS:I]Dono Cielo[CR]\npensavo che si trattasse di uno scherzo\nperché dentro era completamente vuoto...", spanish="Pensaba que el [CS:I]Regalo Cielo[CR] era\nuna broma de mal gusto, porque cuando lo abrí\nestaba completamente vacío."})
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english=" But I was wrong.", french=" Mais j'avais tort.", german=" Aber ich hatte mich geirrt.", italian=" ... ma mi sbagliavo!", spanish=" Pero me equivocaba."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 14] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_zanguusu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="Go with confidence and it'll be\nall right! Be tough!", french="Ayez confiance en vous et tout\nira bien! Courage!", german="Geht mit Zuversicht, und es\nwird alles gut werden! Seid stark!", italian="Abbiate fiducia nelle vostre\nforze e vedrete che tutto andrà bene!\nNon mollate!", spanish="¡Confiad en vuestra habilidad\ny no pasará nada! ¡Sed fuertes!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_zanguusu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="The story is making the rounds\nin Treasure Town. It's hard to believe...", french="Cette histoire fait le tour de\nBourg-Trésor. C'est difficile à croire...", german="Die Geschichte kursiert gerade\nin Schatzstadt. Es ist schwer zu glauben...", italian="Ormai a Borgo Tesoro\nconoscono tutti la storia. È incredibile!", spanish="La historia está circulando por\nAldea Tesoro. Resulta difícil creerla..."})
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="But it is true that time hasn't\ngone back to normal where stolen Time Gears\nwere put back in place...", french="Mais c'est vrai que le temps n'a\npas repris son cours normal là où on a remis\nles Rouages du Temps à leur place...", german="Aber es stimmt, dass die Zeit\ndort, wo die Zahnräder der Zeit an ihren alten\nOrt gebracht wurden, nicht normal weiterläuft.", italian="Ma è vero che nei luoghi in cui\ngli Ingranaggi del Tempo sono stati rimessi a\nposto, il tempo non è tornato alla normalità...", spanish="Pero es cierto que el tiempo no\nha vuelto a la normalidad, a pesar de haber\ndevuelto los engranajes a su sitio."})
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="Worse yet, the zones where\ntime has stopped are growing larger...", french="Pire encore, les zones\noù le temps s'est arrêté s'étendent\nprogressivement...", german="Viel schlimmer ist noch, dass\ndie Zonen, in denen die Zeit stehen geblieben\nist, immer größer werden...", italian="Peggio ancora, le zone in cui il\ntempo si è fermato stanno aumentando...", spanish="¡Peor aún! Las zonas donde se\nha parado el tiempo siguen aumentando..."})
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="There are things happening that\ndon't make sense...", french="Il se passe des choses\ninsensées...", german="Es geschehen Dinge, die einfach\nkeinen Sinn ergeben.", italian="Stanno succedendo cose che\nnon hanno senso...", spanish="No tiene sentido que eso esté\nocurriendo..."})
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="That's why I don't think it's safe\nto deny the rumor. You know! The rumor\nabout [CS:N]Grovyle[CR]...", french="C'est pour ça qu'il ne serait pas\nprudent de démentir la rumeur, à mon avis.\nVous savez! La rumeur concernant [CS:N]Massko[CR]...", german="Daher denke ich, ist es nicht\nsicher, das Gerücht zu verwerfen. Ihr wisst,\nschon... Das Gerücht über [CS:N]Reptain[CR].", italian="È per questo che penso sia poco\nsaggio non credere a ciò che si dice. Sapete,\nno, le voci su [CS:N]Grovyle[CR]...", spanish="Por eso, no creo que sea sensato\nhacer caso omiso al rumor sobre [CS:N]Grovyle[CR]."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_zanguusu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english=" We heard...", french=" On a appris la nouvelle...", german=" Wir haben gehört...", italian=" Abbiamo saputo...", spanish=" Hemos oído algo..."})
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="Yes, we heard why [CS:N]Grovyle[CR] was\nstealing Time Gears in the first place.", french="Oui, on nous a dit pourquoi\n[CS:N]Massko[CR] a voulu s'emparer\ndes Rouages du Temps.", german="Ja, wir haben gehört, warum\n[CS:N]Reptain[CR] überhaupt die Zahnräder der Zeit\ngestohlen hat.", italian="Sì, abbiamo saputo perché\n[CS:N]Grovyle[CR] ha rubato gli Ingranaggi del Tempo.", spanish="Sí, hemos oído por qué [CS:N]Grovyle[CR]\nestaba robando los Engranajes del Tiempo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_zanguusu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="A bad Pokémon like [CS:N]Grovyle[CR]\ncan't be allowed to roam free.", french="On ne peut pas laisser un\nméchant Pokémon comme [CS:N]Massko[CR]\ndans la nature.", german="Ein bösartiges Pokémon wie\n[CS:N]Reptain[CR] darf nicht frei herumlaufen!", italian="Un Pokémon cattivo come\n[CS:N]Grovyle[CR] non può starsene in libertà come\nse niente fosse.", spanish="No se puede permitir que un\nPokémon tan malvado como [CS:N]Grovyle[CR]\nande suelto."})
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="The capture of [CS:N]Grovyle[CR]...[K]\nWe're here to help!", french="On est là pour sa capture...[K]\nOn est venus pour vous aider!", german="Die Gefangennahme von\n[CS:N]Reptain[CR]...[K] Wir sind hier, um zu helfen!", italian="Siamo qui per dare una mano con\nla cattura di [CS:N]Grovyle[CR]...", spanish="La captura de [CS:N]Grovyle[CR]...[K] es\nesencial. ¡Hemos venido a ayudar!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 4] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_zanguusu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="We've been away from here a\nlong time.", french="Ça faisait longtemps qu'on\nn'était pas venus ici.", german="Lange Zeit sind wir von hier\nfort gewesen.", italian="Siamo stati via per molto\ntempo.", spanish="Hemos estado fuera durante\nmucho tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="The guild was away on an\nexpedition, I heard.", french="La Guilde est revenue d'une\ngrande expédition, à ce qu'on dit.", german="Die Gilde war auf einer\nExpedition, wie ich gehört habe.", italian="Ho sentito che la Gilda era via\nper una spedizione.", spanish="He oído que el [CS:N]Pokégremio[CR]\nha salido de expedición."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 1] || scn($SCENARIO_MAIN) >= [10
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_zanguusu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english=" Recycling is a trend of the time.", french="Echanger, c'est dans\nl'air du temps.", german="Wiederverwertung ist ein Trend\ndieser Zeit.", italian="Se vuoi essere al passo con\ni tempi, la parola d'ordine è riciclare.", spanish=" Reciclar es la última moda."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 3] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_zanguusu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english=" I have really taken to this shop.", french="Je suis devenu un adepte\nde ce magasin.", german="Ich habe an diesem Laden\nwirklich Gefallen gefunden.", italian="Questo locale mi è piaciuto\nun sacco.", spanish="Le he cogido el gustillo\na esta tienda."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 3] || scn($SCENARIO_MAIN) >= [7, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_zanguusu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="We're Team [CS:X]Razor Wind[CR]![K]\nWe're the sharp-clawed trio!", french="On est l'Equipe [CS:X]Coupe-Vent[CR]![K]\nLe trio aux griffes acérées!", german="Wir sind Team [CS:X]Klingensturm[CR]![K]\nWir sind das Trio mit den scharfen Klauen!", italian="Siamo il Team [CS:X]Ventagliente[CR]![K]\nSiamo il trio dagli artigli affilati!", spanish="¡Somos el [CS:X]Equipo Cortante[CR]![K]\n¡El trío de las garras afiladas!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [5, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
