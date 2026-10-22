-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P03A/enter07.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_garagara = SkySceneKit.spawn_npc("marowak", 256, 208, Direction.Down, "NPC_GARAGARA")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_garagara, 4) end)
  if ((SV.SkyTalkBitFlags or {})[62] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[62]
  -- @label_123 [étiquette de flux ExplorerScript]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_garagara, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="Welcome to [CS:K]Marowak[CR] Dojo.[K]\nTrain yourselves to become better explorers!", french="Bienvenue au [CS:K]Dojo Ossatueur[CR].[K]\nEntraînez-vous pour faire partie des meilleurs\nexplorateurs!", german="Willkommen im [CS:K]Knogga-Dojo[CR].[K]\nArbeitet an euch, damit ihr bessere Erkunder\nwerdet!", italian="Vi do il benvenuto al Dojo\n[CS:K]Marowak[CR].[K] Il luogo adatto per diventare\nesploratori coi fiocchi!", spanish="Os doy la bienvenida al [CS:K]Dojo[CR]\n[CS:K]Marowak[CR].[K] ¡Aquí podéis entrenaros para\naprender a explorar mucho mejor!"})
  do local __choice = SkySceneKit.ask({{english="Info", french="Infos", german="Info", italian="Info", spanish="Información"}, {english="Cancel", french="Annuler", german="Zurück", italian="Annulla", spanish="Cancelar"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- @label_124 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="The entrance to the training\nmazes is up to the right.", french="L'accès aux dédales\nd'entraînement se trouve en haut à droite.", german="Der Eingang zu den\nTrainingsdungeons befindet sich zur Rechten.", italian="L'entrata ai dedali d'allenamento\nè in alto a destra.", spanish="La entrada a los laberintos de\nentrenamiento está ahí a la derecha."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="I have to tell you one thing...[K]\nTraining mazes aren't like ordinary dungeons...", french="Il faut que je vous dise quelque\nchose...[K] Les dédales d'entraînement ne sont\npas des donjons ordinaires...", german="Ich muss euch etwas verraten.[K]\nTrainingsdungeons sind anders als gewöhnliche\nDungeons.", italian="Devo dirvi una cosa...[K]\nI dedali d'allenamento non sono dei\nnormali dungeon...", spanish="Tengo que contaros una cosa...[K]\nMis laberintos de entrenamiento no son\ncomo los territorios normales..."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="There's this icky part, you see.\nWhen you go in, you hand over everything\nthat's in your Treasure Bag.", french="Il y a une subtilité, un os,\nsi j'ose dire. En entrant, vous abandonnez tout\nce que renferme votre Sac à Trésor.", german="Da gibt es diese eine recht\nunschöne Kleinigkeit: Bevor ihr reingeht, gebt\nihr den gesamten Inhalt eures Schatzbeutels ab.", italian="C'è un fattore spiacevole.\nQuando entrate, perdete tutto quello che\nc'è nella vostra Sacca dei tesori.", spanish="Solo hay una pega... Al entrar,\ntenéis que entregar todo lo que llevéis\nen vuestra Bolsa."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="To avoid losing the items in your\nTreasure Bag, put them in [CS:K]Kangaskhan[CR] Storage\nbefore you go in.", french="Pour éviter de perdre tous les\nobjets de votre Sac à Trésor, stockez-les\ndans la [CS:K]Réserve Kangourex[CR] avant d'entrer.", german="Um dem Verlust von Items aus\neurem Schatzbeutel vorzubeugen, hinterlegt sie\nim [CS:K]Kangama-Lager[CR], bevor ihr reingeht.", italian="Per evitare di perdere gli\nstrumenti nella vostra Sacca dei tesori, prima\ndi entrare lasciateli al Deposito [CS:K]Kangaskhan[CR].", spanish="Si no queréis perder los objetos\nque llevéis en la Bolsa, tendréis que dejarlos\nen la [CS:K]Consigna Kangaskhan[CR] antes de entrar."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="There's more![K] If you get KO'd,\nyou don't lose the new money and items that\nyou found in the maze. You get to keep them!", french="Et ce n'est pas tout![K] Si vous\nêtes K.O., vous ne perdez pas l'argent et les\nobjets trouvés dans le dédale. Vous les gardez!", german="Noch etwas![K] Falls ihr besiegt\nwerdet, verliert ihr nicht eure Item- und\nGeldbeute aus dem Dungeon. Ihr behaltet sie!", italian="C'è di più![K] Se andate KO, non\nperdete i soldi e gli strumenti che avete\ntrovato nel dedalo. Li potete tenere!", spanish="¡Y otra cosa más![K] Si os dejan\nfuera de combate, no perderéis el dinero ni\nlos objetos encontrados. ¡Os los quedaréis!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="There's no risk to you, so you\ncan go all out while you train.", french="Vous ne courez aucun risque\npendant l'entraînement, alors foncez!", german="Für euch besteht keinerlei\nRisiko. Ihr könnt also ganz unbesorgt loslegen.", italian="Non correte alcun rischio e\npotete dare il meglio di voi.", spanish="No corréis ningún riesgo real,\nasí que podéis lanzaros sin miedo cuando\nos entrenéis aquí."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="Train all you want here to\ntoughen yourselves up, you two!", french="Entraînez-vous autant que vous\nvoulez pour améliorer vos performances!", german="Ihr könnt hier nach Belieben\ntrainieren, wenn ihr euch ertüchtigen wollt,\nihr zwei!", italian="Potete allenarvi quanto volete\nper rinforzarvi, voi due!", spanish="¡Entrenaos todo lo que podáis\npara volveros mucho más fuertes!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="So welcome to [CS:K]Marowak[CR] Dojo![K]\nShow me how tough you are!", french="Bienvenue au [CS:K]Dojo Ossatueur[CR]![K]\nMontrez-moi de quel bois vous vous chauffez!", german="Also willkommen im\n[CS:K]Knogga-Dojo[CR]![K] Zeigt mir, wie zäh ihr seid!", italian="Dunque, vi do il benvenuto al\nDojo [CS:K]Marowak[CR]![K]\nMostratemi cosa sapete fare!", spanish="¡Entonces os doy la bienvenida\nal [CS:K]Dojo Marowak[CR]![K] ¡A ver lo fuertes que\nsois!"})
  do local __choice = SkySceneKit.ask({{english="Info", french="Infos", german="Info", italian="Info", spanish="Información"}, {english="Cancel", french="Annuler", german="Zurück", italian="Annulla", spanish="Cancelar"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- jump @label_124 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- @label_122 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else -- default/annulation
  -- jump @label_122 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 2 then
  -- jump @label_122 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- jump @label_122 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[62] = 1 -- $SCENARIO_TALK_BIT_FLAG[62] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="You've done the impossible, you\ntwo! Defeating [CS:N]Darkrai[CR]...!", french="Vous avez accompli l'impossible!\nTerrasser [CS:N]Darkrai[CR]...!", german="Ihr zwei habt das Unmögliche\ngeschafft! Ihr habt [CS:N]Darkrai[CR] besiegt!", italian="Avete fatto l'impossibile!\nSconfiggere [CS:N]Darkrai[CR]...!", spanish="¡Habéis hecho lo imposible!\n¡Derrotar a [CS:N]Darkrai[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="I didn't expect any less of you!\nAfter all, you're students of [CS:K]Marowak[CR] Dojo!", french="Je n'en attendais pas moins de\nvotre part! Après tout, vous avez fait vos\narmes au [CS:K]Dojo Ossatueur[CR]!", german="Von euch hätte ich auch nichts\nGeringeres erwartet, seid ihr doch Schüler des\n[CS:K]Knogga-Dojos[CR]!", italian="Sapevo che ce l'avreste fatta!\nDopotutto, avete frequentato il Dojo [CS:K]Marowak[CR]!", spanish="¡No esperaba menos! Al fin y\nal cabo, ¡sois estudiantes del [CS:K]Dojo Marowak[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="Oh?[K] You don't ever recall\nbecoming a student of this dojo?", french="Quoi?[K] Vous ne vous rappelez pas\navoir jamais fait vos armes dans ce dojo?", german="Oh?[K] Ihr könnt euch nicht daran\nerinnern, Schüler dieses Dojos geworden zu\nsein?", italian="Eh?[K] Non vi ricordate di\naver frequentato il Dojo?", spanish="¿Eh?[K] ¿No recordáis haberos\nconvertido en mis discípulos?"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="...[K]That's not important in the\ngrand scheme of things, is it? Ha!", french="... [K]Ça n'a aucune importance\ndans le grand ordre de l'univers, n'est-ce\npas? Ha!", german="...[K]Im Hinblick auf das große\nGanze ist das doch relativ belanglos, nicht\nwahr? Ha!", italian="...[K] Non ha importanza nel\ndisegno generale delle cose, no? Ah!", spanish="Hum...[K] Eso son nimiedades,\n¿no creéis? ¡Ja!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_123 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_garagara, 4) end)
  if ((SV.SkyTalkBitFlags or {})[61] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[61]
  -- jump @label_123 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[61] = 1 -- $SCENARIO_TALK_BIT_FLAG[61] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="I heard what's going on from\nthe others!", french="Ah, vous voilà, vous deux!\nLes autres m'ont raconté ce qui\nse passait!", german="Ich habe von den anderen\nerfahren, was los ist!", italian="Ho saputo dagli altri cosa sta\nsuccedendo!", spanish=" ¡Ya me han contado!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="It's you two! There's no failure\nin either of you!", french="Vous réussissez tout ce que\nvous entreprenez, ma parole!", german="Ihr zwei seid es! Keiner von\neuch ist ein Versager!", italian="Voi due non potete fallire!", spanish="Desde luego, sois un equipo\nexplorador de primera."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english=" Go into battle with confidence!", french="Que la confiance vous\naccompagne au combat!", german="Zieht mit Zuversicht in den\nKampf!", italian="Andate e lottate avendo fiducia\nnei vostri mezzi!", spanish=" ¡Id a luchar con confianza!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english=" Roooaaar!", french=" Grrrrrr!", german=" Roooaaar!", italian=" Grrrrrrr!", spanish=" ¡Grrrr!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_123 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_123 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_garagara, 4) end)
  if ((SV.SkyTalkBitFlags or {})[60] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[60]
  -- jump @label_123 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[60] = 1 -- $SCENARIO_TALK_BIT_FLAG[60] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="I heard from the others about\nwhat you're up against.", french="Les autres m'ont raconté\nce que vous allez devoir affronter.", german="Ich habe von den anderen\ngehört, was euch bevorsteht.", italian="Ho saputo dagli altri cosa\nstate cercando di fare.", spanish="Ya me han contado contra qué\nos enfrentáis."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="Let me throw in what little\nsupport I can give!", french="Laissez-moi vous encourager\ncomme je le peux!", german="Es ist zwar nicht viel, aber\nlasst mich euch, so gut es mir möglich ist,\nunterstützen!", italian="Per quel che posso fare,\ncercherò di aiutarvi!", spanish="¡Dejadme que os ayude con el\npoco apoyo que puedo daros!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="Never give up, you two![K]\nDon't you dare lose!", french="N'abandonnez jamais, vous\ndeux![K] Ne vous avisez pas de perdre!", german="Gebt niemals auf, ihr zwei![K]\nUnd kommt ja nicht auf die Idee, euch besiegen\nzu lassen!", italian="Non mollate, voi due![K]\nNon arrendetevi mai!", spanish="¡No os rindáis![K] ¡Ni se os ocurra\nperder!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english=" Roooaaar!", french=" Grrrrrrr!", german=" Roooaaar!", italian=" Grrrrrr!", spanish=" ¡Grrrr!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_123 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_123 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_122 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
