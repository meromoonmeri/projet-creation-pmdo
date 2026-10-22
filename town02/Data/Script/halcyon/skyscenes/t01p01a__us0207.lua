-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/us0207.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 98) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 98]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_ringuma = SkySceneKit.spawn_npc("ursaring", 304, 240, Direction.DownRight, "NPC_RINGUMA")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="If you want to evolve, maybe\nyou should head over to [CS:P]Luminous\nSpring[CR] again.", french="Si vous voulez évoluer, vous\ndevriez peut-être retourner\nà la [CS:P]Source Lumineuse[CR].", german="Wenn ihr euch entwickeln wollt,\nsolltet ihr euch vielleicht noch mal zur\n[CS:P]Glitzerquelle[CR] begeben.", italian="Se volete evolvervi, forse\ndovreste riprovare ad andare alla\n[CS:P]Sorgente Luccichio[CR].", spanish="Si quieres evolucionar, quizá\ndeberías volver al [CS:P]Manantial\nLuminoso[CR]."})
  -- message_Close
  -- @label_131 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="You've got my thanks for saving\nthe world!", french="Je vous suis reconnaissant\nd'avoir sauvé le monde!", german="Dafür, dass ihr die Welt\ngerettet habt, gebührt euch mein Dank!", italian="Vi devo ringraziare per aver\nsalvato il mondo!", spanish="¡Tenéis mi agradecimiento por\nhaber salvado el mundo!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="You're the only hope![K] You have\nto beat [CS:N]Darkrai[CR] for us! Please!", french="Vous êtes notre seul espoir![K]\nVous devez vaincre [CS:N]Darkrai[CR] pour nous!\nPar pitié!", german="Ihr seid die einzige Hoffnung![K]\nIhr müsst [CS:N]Darkrai[CR] für uns besiegen! Bitte!", italian="Siete l'unica speranza![K] Dovete\nbattere [CS:N]Darkrai[CR], fatelo per noi! Vi prego!", spanish="¡Sois la única esperanza![K] Tenéis\nque derrotar a [CS:N]Darkrai[CR] por nosotros.\n¡Por favor!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="We came back to Treasure Town\nfor a rare visit. I'm shocked by the news!", french="Ça faisait longtemps qu'on\nn'était pas revenus à Bourg-Trésor.\nJe suis abasourdi par ce que j'ai appris!", german="Wir sind für einen seltenen\nBesuch nach Schatzstadt zurückgekommen.\nDie Neuigkeiten haben mich schockiert!", italian="Siamo tornati a Borgo Tesoro\nsolo per una veloce visita. È una notizia\nscioccante!", spanish="Nos hemos dejado caer por\nAldea Tesoro para hacer una visita y nos\nhemos enterado de las malas noticias."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Little [CS:N]Azurill[CR]'s asleep and won't\nwake up?!", french="Le petit [CS:N]Azurill[CR] est endormi et\nn'arrive pas à se réveiller?!", german="Der kleine [CS:N]Azurill[CR] schläft und\nwacht nicht mehr auf?!?", italian="Il piccolo [CS:N]Azurill[CR] è addormentato\ne non c'è verso di svegliarlo?!", spanish="¿Así que el pequeño [CS:N]Azurill[CR] está\ndormido y no puede despertarse?"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 76] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" The weather's nice as usual.", french=" Il fait beau, comme d'habitude.", german="Das Wetter ist wie immer\nschön.", italian=" Il tempo è bello come al solito.", spanish="Hace un buen día, como de\ncostumbre."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 52) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 52]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Oh...[K] So your little buddy had to\ngo back to the sea...", french="Oh...[K] Alors comme ça, votre\npetit protégé a dû retourner à la mer...", german="Oh.[K] Euer kleiner Kumpel musste\nalso ins Meer zurückkehren.", italian="Oh...[K] Così il piccolo\nè dovuto tornare in mare...", spanish="Oh...[K] Así que tu amiguito tuvo\nque regresar al mar..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 50] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" What?![K] Your little buddy's sick?", french=" Quoi?![K] Le petit est malade?", german="Was?!?[K] Euer kleiner Kumpel ist\nkrank?", italian="Cosa?![K] Il cucciolo\nè malato?", spanish="¡¿Qué?![K] ¿Tu amiguito está\nenfermo?"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 48] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Huh?[K] Did I see that little cute\nbuddy of yours today?", french="Hein?[K] Si j'ai vu le petit\naujourd'hui?", german="Wie?[K] Ob ich den süßen kleinen\nKumpel von euch heute schon gesehen habe?", italian="Eh?[K] Volete sapere se ho visto\nquel vostro piccolo amico?", spanish="¿Eh?[K] ¿Que si vi a tu amiguito\nhoy?"})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" Nope. Can't say I have.", french=" Non. Je ne l'ai pas vu.", german=" Nein, wohl nicht.", italian=" No, non direi.", spanish=" No... La verdad es que no."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 46) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 46]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Oh, hey, now what's with your\ncute little buddy today?", french="Hé, comment va votre petit bout\nde chou aujourd'hui?", german="Oh, hey, was ist denn heute mit\neurem süßen kleinen Kumpel los?", italian="Ah, ehi, oggi come va con il\nvostro cucciolo?", spanish="Oh, ¿qué pasa con ese amiguito\ntuyo?"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 45] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" It's been peaceful lately.", french="C'est assez paisible, ces derniers\ntemps.", german=" In letzter Zeit war es friedlich.", italian=" Che pace c'è ultimamente!", spanish="Últimamente todo ha estado muy\ntranquilo."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="The weather's been great too.\nWarm and pleasant, the way I like it.", french="Et le temps est magnifique.\nChaud et ensoleillé, comme j'aime.", german="Das Wetter war auch gut. Warm\nund angenehm, so, wie ich es mag.", italian="Anche il tempo è splendido.\nCaldo e gradevole come piace a me.", spanish="El tiempo también ha sido muy\nbueno... Cálido y agradable, como a mí me\ngusta."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 41] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" It's me, [CS:N]Ursaring[CR].", french=" C'est moi, [CS:N]Ursaring[CR].", german=" Ich bin es, [CS:N]Ursaring[CR].", italian=" Sono io, [CS:N]Ursaring[CR].", spanish=" Soy yo, [CS:N]Ursaring[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Did you really go out to some\nplace called [CS:P]Blizzard Island[CR]?", french="Vous avez vraiment exploré\ncet endroit qu'on appelle l'[CS:P]Ile Blizzard[CR]?", german="Seid ihr wirklich zu einem Ort\nnamens [CS:P]Blizzardinsel[CR] gereist?", italian="Siete andati davvero in quel\nposto chiamato [CS:P]Isola Tormenta[CR]?", spanish="¿De verdad fuisteis a un sitio\nllamado [CS:P]Isla Ventisca[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" Sounds mighty chilly...", french=" Il doit y faire sacrément froid...", german=" Hört sich mächtig kalt an.", italian=" Deve far freddo laggiù...", spanish=" Me da frío solo de oírlo..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 33] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Yeah, it's me.[K] I'm [CS:N]Ursaring[CR].[K]\n...Well, that's obvious, isn't it?", french="Ouais, c'est moi.[K] Mais si,\n[CS:N]Ursaring[CR].[K] Ça paraît évident, non?", german="Ja, ich bin es.[K] Ich bin\n[CS:N]Ursaring[CR].[K] Na ja, das ist ziemlich\noffensichtlich, oder?", italian="Sì, sono io.[K] Sono [CS:N]Ursaring[CR].[K]\nBeh, ma è ovvio, no?", spanish="Sí, soy yo.[K] Soy [CS:N]Ursaring[CR].[K] Bueno,\nes obvio, ¿no?"})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="It's hard to tell us apart now.\nIt can be annoying.", french="C'est difficile de nous\ndifférencier maintenant. C'est agaçant,\nà la fin.", german="Es ist schwierig, uns jetzt\nauseinanderzuhalten. Das kann echt lästig sein.", italian="Ora è difficile distinguerci. Può\nessere seccante.", spanish="Ahora es difícil distinguirnos.\nA veces resulta irritante."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 4] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" You can count on my support!", french="Vous pouvez compter sur mon\nsoutien!", german="Auf meine Unterstützung könnt\nihr zählen!", italian=" Faccio il tifo per voi!", spanish=" ¡Podéis contar con mi apoyo!"})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="We need you to succeed![K]\nSave the world!", french="Nous avons besoin de vous![K]\nSauvez le monde!", german="Ihr müsst einfach erfolgreich\nsein![K] Rettet die Welt!", italian="Per vincere abbiamo bisogno di\nvoi![K] Salvate il mondo!", spanish="¡Necesitamos que lo consigáis![K]\n¡Tenéis que salvar el mundo!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Hey, I believe too! I believe\nin you!", french="Hé, je veux y croire aussi!\nJe crois en vous!", german="Hey, ich glaube es auch! Ich\nvertraue euch!", italian="Ehi, ci credo anch'io! Credo in\nvoi!", spanish="¡Eh, yo también os creo! ¡Yo\ntambién os creo!"})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="We've never heard anything\nabout the [CS:P]Hidden Land[CR]...", french="On n'a jamais entendu parler\ndes [CS:P]Terres Illusoires[CR]...", german="Wir haben noch nie etwas von\ndem [CS:P]Verborgenen Land[CR] gehört.", italian="Non abbiamo mai sentito parlare\ndella [CS:P]Terra Nascosta[CR]...", spanish="Nunca hemos oído hablar de la\n[CS:P]Tierra Oculta[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="But if anyone can find it, I'm\nsure that you can![K] Go for it!", french="Mais s'il y a bien quelqu'un qui\npeut les trouver, c'est vous![K] Foncez!", german="Aber wenn es überhaupt jemand\nfinden kann, dann seid ihr das, da bin ich mir\nsicher![K] Haltet euch ran!", italian="Ma se c'è qualcuno che può\ntrovarla, siete sicuramente voi![K] Forza!", spanish="¡Pero seguro que lograréis dar\ncon ella![K] ¡Ánimo!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 1] || scn($SCENARIO_MAIN) >= [22
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="[CS:N]Grovyle[CR] was actually gathering\nup the Time Gears to save the world?", french="Quoi? En réalité, c'est pour\nsauver le monde que [CS:N]Massko[CR] rassemblait\nles Rouages du Temps?", german="[CS:N]Reptain[CR] hat in Wirklichkeit die\nZahnräder der Zeit gesammelt, um die Welt\nzu retten?", italian="[CS:N]Grovyle[CR] sta cercando gli\nIngranaggi del Tempo per salvare il mondo?", spanish="¿[CS:N]Grovyle[CR] estaba reuniendo los\nEngranajes del Tiempo para salvar el mundo?"})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" Well, that's...[K]hard to believe.", french="Ça alors... [K]c'est difficile à\ncroire.", german="Nun, das ist...[K] schwer zu\nglauben.", italian=" Beh, è...[K] difficile da credere.", spanish="Pues, la verdad...[K] resulta difícil\nde creer."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Hey, I'm sorry.[K] It's not that I\ndon't trust you or anything...", french="Euh, je suis désolé.[K] Ce n'est pas\nque je n'ai pas confiance en vous...", german="Hey, es tut mir leid.[K] Es ist ja\nnicht so, dass ich euch nicht trauen würde.", italian="Ehi, mi dispiace.[K] Non è che non\nmi fidi di voi, ma...", spanish="Eh, perdonadme.[K] No es que diga\nque estáis mintiendo..."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="It's just that we only just heard\nthe news. And frankly, we're overwhelmed!", french="C'est juste qu'on vient à peine\nd'apprendre la nouvelle! Et franchement, on est\nun peu chamboulés!", german="Es ist nur so, dass wir gerade\ndavon erfahren haben. Und um es vorsichtig\nauszudrücken, wir sind echt überwältigt!", italian="È che abbiamo appena sentito le\nultime notizie e, francamente, siamo rimasti di\nstucco.", spanish="Es solo que ya hemos oído lo que\nse dice. Y, la verdad, ¡es demasiado!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="I want to know how the great\n[CS:N]Dusknoir[CR] intends to take down [CS:N]Grovyle[CR].", french="J'aimerais savoir comment le\ngrand [CS:N]Noctunoir[CR] va s'y prendre pour vaincre\n[CS:N]Massko[CR].", german="Mich würde interessieren, wie\nder große [CS:N]Zwirrfinst[CR] beabsichtigt, [CS:N]Reptain[CR] zu\nstoppen.", italian="Vorrei sapere quale sia il piano\ndel grande [CS:N]Dusknoir[CR] per battere [CS:N]Grovyle[CR].", spanish="Me gustaría saber cómo\npretende [CS:N]Dusknoir[CR] pararle los pies\na [CS:N]Grovyle[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="I'd like to go see that fight,\nbut...[K]I'd better not get in the way.", french="J'aimerais bien assister au\ncombat, mais... [K]mieux vaut ne pas\nse retrouver entre ces deux-là.", german="Den Kampf würde ich mir gerne\nansehen, aber[K] ich sollte wohl besser nicht\ndazwischengeraten.", italian="Mi piacerebbe assistere a quella\nlotta, ma...[K] È meglio che me ne stia qui.", spanish="Sería un enfrentamiento muy\ninteresante...[K] Pero visto de lejos, claro."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 1]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="So the great [CS:N]Dusknoir[CR] and\n[CS:N]Grovyle[CR] were both from the future...", french="Alors comme ça, le grand\n[CS:N]Noctunoir[CR] et [CS:N]Massko[CR] venaient tous les deux\ndu futur...", german="Also waren sowohl der große\n[CS:N]Zwirrfinst[CR] als auch [CS:N]Reptain[CR] aus der Zukunft...", italian="Quindi il grande [CS:N]Dusknoir[CR] e\n[CS:N]Grovyle[CR] vengono entrambi dal futuro...", spanish="Así que tanto el gran [CS:N]Dusknoir[CR]\ncomo [CS:N]Grovyle[CR] venían del futuro..."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Well, that's a stunner! I'm\namazed, I tell you!", french="Ça alors, ça m'en bouche\nun coin!", german="Nun, das ist echt ein Hammer!\nIch bin wirklich überrascht! Das kann ich euch\nsagen!", italian="Beh, è sorprendente! Vi dirò,\nsono sbalordito!", spanish="¡Menuda sorpresa! ¡Me he\nquedado sin palabras, la verdad!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Whoever's stealing the Time\nGears is pretty brazen.", french="Qui que ce soit, celui qui vole\nles Rouages du Temps a un sacré toupet.", german="Wer auch immer die Zahnräder\nder Zeit stiehlt, er ist ziemlich dreist.", italian="Chiunque sia il ladro che ruba\ngli Ingranaggi del Tempo, ha una bella faccia\ntosta!", spanish="Quien esté robando los\nEngranajes del Tiempo no tiene\nvergüenza."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Catch the thief and show him\nwhat a big mistake he made!", french="Attrapez ce voleur et faites-lui\nregretter ses actes!", german="Fangt den Dieb und zeigt ihm,\nwas für einen gewaltigen Fehler er gemacht\nhat!", italian="Catturate il ladro e fategli\ncapire che ha fatto un grave errore!", spanish="¡Atrapa al ladrón y hazle ver\nque ha cometido un gran error!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 4] || scn($SCENARIO_MAIN) >= [14
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Did something happen at\nthe guild?", french="Est-ce qu'il s'est passé quelque\nchose à la Guilde?", german="Ist in der Gilde etwas\ngeschehen?", italian=" È successo qualcosa alla Gilda?", spanish="¿Ha ocurrido algo en el\n[CS:N]Pokégremio[CR]?"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [13, 2] || scn($SCENARIO_MAIN) >= [13
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="You two are settled into the\nguild, it seems.", french="On dirait que vous avez pris\nvos marques à la Guilde maintenant.", german="Ihr habt euch gut in der Gilde\neingelebt, wie mir scheint.", italian="Sembra che ormai siate di\ncasa alla Gilda.", spanish="Parece que el [CS:N]Pokégremio[CR] ya es\ncomo vuestra casa."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="You went out on that expedition,\ntoo...[K] Yeah, I'd say you're looking more and\nmore like a true exploration team.", french="Vous aussi, vous avez participé\nà l'expédition...[K] C'est vrai que vous\ncommencez à avoir l'exploration dans le sang.", german="Ihr wart auch bei der Expedition\ndabei.[K] Ja, ich würde sagen, ihr seht mehr und\nmehr wie ein echtes Erkundungsteam aus.", italian="Anche voi avete partecipato a\nquella spedizione...[K] Direi che sembrate ancor\npiù una vera squadra d'esplorazione.", spanish="Así que fuisteis a la expedición.[K]\nSí, cada vez vais pareciendo más y más un\nequipo explorador de verdad."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 4] || scn($SCENARIO_MAIN) >= [12
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Oh, what?[K] Nothing turned up on\nthe expedition?", french="Hein, quoi?[K] Vous n'avez rien\ntrouvé pendant l'expédition?", german="Wie bitte?[K] Bei der Expedition\nwurde nichts gefunden?", italian="Oh, cosa?[K] Non è saltato\nfuori nulla durante la spedizione?", spanish="¿Cómo?[K] ¿No habéis encontrado\nnada en esta expedición?"})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="The guild normally comes back\nwith lots of treasure after an expedition...[K]\nThat's not like you all to fail.", french="D'habitude, les membres de la\nGuilde reviennent d'expédition avec plein de\ntrésors...[K] Ça ne vous ressemble pas d'échouer.", german="Die Gilde kehrt normalerweise\nmit reichlich Schätzen von einer Expedition\nzurück.[K] Versagen sieht euch gar nicht ähnlich.", italian="Normalmente la Gilda torna\ncarica di tesori da ogni spedizione...[K]\nNon è da voi tornare a mani vuote.", spanish="Pues el [CS:N]Pokégremio[CR] suele acabar\nhasta arriba de tesoros tras cada expedición.[K]\nMe parece rarísimo esto que me decís."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="I hear the whole guild's going\noff on the expedition now.", french="Il paraît que la Guilde au grand\ncomplet participe à l'expédition.", german="Ich habe gehört, dass sich die\ngesamte Gilde nun auf eine Expedition begibt.", italian="Ho sentito che l'intera Gilda\nsta per partire per una spedizione.", spanish="He oído que todo el [CS:N]Pokégremio[CR]\nva a ir a la expedición."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="After the last expedition, they\ncame back with loads of treasure.", french="Après la dernière expédition,\nils sont revenus les bras chargés de trésors.", german="Von der letzten Expedition sind\nsie mit jeder Menge Schätzen zurückgekehrt.", italian="Dopo l'ultima spedizione, sono\ntornati carichi di tesori.", spanish="La última vez regresaron con\ntoda clase de tesoros y recuerdos."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="We expect big things from your\nupcoming expedition!", french="Nous attendons beaucoup de\nvotre prochaine expédition!", german="Wir erwarten Großes von der\nbevorstehenden Expedition!", italian="Ci aspettiamo grandi cose dalla\nvostra prossima spedizione!", spanish="¡Esperamos maravillas de esta\nnueva expedición!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7] || scn($SCENARIO_MAIN) >= [8, 
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="I don't think that stench is just\na figment of my imagination...", french="Je ne crois pas que cette\nodeur pestilentielle soit seulement le fruit\nde mon imagination...", german="Ich glaube nicht, dass der\nGestank bloß ein Produkt meiner Fantasie ist...", italian="Non penso che questa puzza sia\nfrutto della mia immaginazione...", spanish="No, ese pestazo no puedo estar\nimaginándomelo..."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Want proof? Fewer exploration\nteams are visiting Treasure Town lately!", french="La preuve! On voit de moins\nen moins d'équipes d'exploration\nà Bourg-Trésor, ces temps-ci!", german="Wollt ihr Beweise? In letzter\nZeit besuchen immer weniger Erkundungsteams\nSchatzstadt!", italian="Volete delle prove? Ultimamente\na Borgo Tesoro arrivano molte meno squadre\nd'esplorazione!", spanish="¿Queréis pruebas? ¡Últimamente\nvienen muy pocos equipos de exploración\na Aldea Tesoro!"})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="I bet the stench is keeping them\nall away.", french="Je parie que c'est cette puanteur\nqui les a fait fuir.", german="Ich wette, dass der Gestank sie\nalle davon abhält.", italian="Scommetto che è la puzza a\ntenerli alla larga.", spanish="Seguro que es ese pestazo lo que\nlos está alejando."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 3] || scn($SCENARIO_MAIN) >= [7, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Stealing Time Gears is\nunthinkable!", french="Voler les Rouages du Temps...\nC'est inconcevable!", german="Es ist unvorstellbar, Zahnräder\nder Zeit zu stehlen!", italian="È impensabile rubare gli\nIngranaggi del Tempo!", spanish="¡Robar los Engranajes del Tiempo\nes algo impensable!"})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Who would go around stealing\nthem?", french="Comment peut-on oser\ncommettre un tel acte?", german="Wer würde umherziehen und sie\nstehlen?", italian=" Chi potrebbe mai osare rubarli?", spanish=" ¿Quién iba a hacer algo así?"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 1] || scn($SCENARIO_MAIN) >= [6, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="I don't know if it's because time\nis going out of control or not, but...", french="Je ne sais pas si c'est à cause\ndu temps qui se détraque ou pas, mais...", german="Ich weiß nicht, ob es daran\nliegt, dass die Zeit außer Kontrolle gerät,\naber...", italian="Non so se è perché si sta\nperdendo il controllo del tempo, ma...", spanish="No sé si es porque el tiempo\nestá descontrolado, pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" No one can evolve lately.", french="Plus personne ne peut évoluer\nces derniers temps.", german="Seit Kurzem kann sich niemand\nmehr entwickeln.", italian="Nessuno può evolversi\nultimamente.", spanish="Nadie ha podido evolucionar\núltimamente."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="You know how Pokémon evolve\nonly after certain conditions are met, right?", french="Vous savez que les Pokémon\npeuvent évoluer une fois qu'ils remplissent\ncertaines conditions, n'est-ce pas?", german="Euch ist bekannt, dass sich\nPokémon nur bei Erfüllung bestimmter\nKriterien entwickeln können, oder?", italian="Sapete che i Pokémon possono\nevolversi solo a determinate condizioni, vero?", spanish="Ya sabéis que los Pokémon solo\npueden evolucionar si se cumplen ciertas\ncondiciones, ¿verdad?"})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Well, right now, no one can\nevolve, no matter what...", french="Eh bien, en ce moment, personne\nne peut évoluer, de toute façon...", german="Nun, im Moment kann sich\nwirklich niemand entwickeln.", italian="Beh, ora come ora in ogni caso\nnessuno può evolversi...", spanish="El hecho es que ahora nadie\npuede evolucionar, en ningún caso."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
