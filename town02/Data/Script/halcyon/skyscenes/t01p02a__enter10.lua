-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/enter10.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_garuura = SkySceneKit.spawn_npc("kangaskhan", 184, 168, Direction.Down, "NPC_GARUURA")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_garuura, 4) end)
  if ((SV.SkyTalkBitFlags or {})[71] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[71]
  -- @label_131 [étiquette de flux ExplorerScript]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_garuura, 4) end)
  -- switch(message_Menu(MENU_KANGASKHAN_STORAGE)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[71] = 1 -- $SCENARIO_TALK_BIT_FLAG[71] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english=" Well! Aren't you impressive!", french="Eh bien! Vous êtes\nfantastiques!", german=" Ihr seid echt beeindruckend!", italian=" Bene! Siete grandi!", spanish=" ¡Vaya! ¡Me siento muy orgullosa!"})
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english="My dears, I love the both of you\nas if you were my own children!", french="Je vous aime\ncomme mes propres enfants!", german="Meine Lieben, ich liebe euch\nbeide, als wärt ihr meine eigenen Kinder!", italian="Dolcezze mie, vi voglio bene\ncome se foste miei cuccioli!", spanish="No hace falta que os diga que\npara mí sois como de la familia."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_garuura, 4) end)
  if ((SV.SkyTalkBitFlags or {})[70] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[70]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[70] = 1 -- $SCENARIO_TALK_BIT_FLAG[70] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english="I've heard you have to face a\ntough enemy...", french="J'ai entendu dire que vous alliez\naffronter un ennemi coriace...", german="Ich habe gehört, dass ihr es mit\neinem schwierigen Gegner zu tun habt.", italian="Ho sentito che dovete affrontare\nun nemico di quelli tosti...", spanish="He oído que debéis enfrentaros\na un duro enemigo..."})
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english="But you two can do it! You're\nsure to win! Don't lose faith!", french="Mais vous pouvez y arriver!\nVous allez gagner, c'est sûr! Ne perdez pas\nespoir!", german="Aber ihr zwei könnt es\nschaffen! Ihr werdet mit Sicherheit siegreich\nsein! Ihr müsst nur daran glauben!", italian="Ma voi ce la potete fare!\nVincerete di sicuro! Abbiate fiducia!", spanish="¡Pero sé que podréis vencerle!\n¡No perdáis la fe en vuestro potencial!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_garuura, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 67) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 67]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_garuura, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_garuura, 4) end)
  if ((SV.SkyTalkBitFlags or {})[69] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[69]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[69] = 1 -- $SCENARIO_TALK_BIT_FLAG[69] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english="You know, I'm not at all that\nenthralled by Team [CS:X]Charm[CR].", french="Vous savez, l'Equipe [CS:X]Charme[CR]\nne me fait ni chaud ni froid.", german="Um ehrlich zu sein, fesselt mich\nTeam [CS:X]Charme[CR] nicht so besonders.", italian="Sapete, non sono così\naffascinata dal Team [CS:X]Malia[CR].", spanish="A mí no me impresiona tanto\nel [CS:X]Equipo Carisma[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english="I honestly don't understand what\nthe fuss is all about.", french="Honnêtement, je ne comprends\npas tout ce tapage autour d'elles.", german="Ich verstehe echt den ganzen\nAufruhr nicht.", italian="Onestamente non capisco perché\ntutti siano così agitati in proposito.", spanish="De verdad que no entiendo por\nqué causan tanta expectación."})
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english="I mean, what is so special about\nTeam [CS:X]Charm[CR], I ask you...", french="C'est vrai quoi, qu'est-ce qu'elle\na de si spécial, l'Equipe [CS:X]Charme[CR],\nje vous le demande...", german="Ich meine, was ist denn so\nbesonders an Team [CS:X]Charme[CR]?", italian="Voglio dire, cos'ha di speciale\nquesto Team [CS:X]Malia[CR], dico io...", spanish="¿Qué es lo que tiene de especial\nel [CS:X]Equipo Carisma[CR]? Si lo sabéis, decídmelo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_garuura, 4) end)
  if ((SV.SkyTalkBitFlags or {})[68] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[68]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[68] = 1 -- $SCENARIO_TALK_BIT_FLAG[68] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english="Congratulations on graduating!\nYou two are extraordinary!", french="Félicitations pour votre\ndiplôme! Vous êtes extraordinaires!", german="Gratulation zur bestandenen\nAbschlussprüfung! Ihr zwei seid wirklich\naußergewöhnlich!", italian="Congratulazioni per l'esame!\nÈ una notizia straordinaria!", spanish="¡Felicidades por superar el gran\nreto! ¡Sois de lo que no hay!"})
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english="Do you know what they say\nabout that guild?[K] That they make it terribly\nhard for apprentices to graduate!", french="Vous savez ce qu'on dit à propos\nde la Guilde?[K] Que l'examen est terriblement\ndifficile!", german="Wisst ihr, was sie über diese\nGilde sagen?[K] Dass sie es ihren Lehrlingen\nschwer macht, einen Abschluss zu erwerben!", italian="Sapete cosa dicono a proposito\ndi quella Gilda?[K] Che l'esame finale\nsia molto difficile per le reclute!", spanish="¿Sabéis lo que dicen por ahí del\n[CS:N]Pokégremio[CR]?[K] ¡Que hacen todo lo posible para\nque ningún aprendiz supere el reto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 4] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_garuura, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_garuura, 4) end)
  if ((SV.SkyTalkBitFlags or {})[67] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[67]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[67] = 1 -- $SCENARIO_TALK_BIT_FLAG[67] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english="Don't worry, sweeties![K] With you\ntwo in charge, nothing can go wrong!", french="Pas d'inquiétude à avoir, mes\nenfants![K] Avec vous deux aux commandes, rien\nde mal ne peut arriver!", german="Keine Sorge, ihr Süßen![K] Jetzt,\nwo ihr beide die Sache in die Hand genommen\nhabt, kann nichts mehr schiefgehen!", italian="Non preoccupatevi, dolcezze\nmie![K] Con voi due in azione, nulla può\nandare storto!", spanish="No os preocupéis.[K] Si os ocupáis\nvosotros, seguro que no pasará nada malo."})
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english="Have confidence in yourselves,\nmy dears!", french="Ayez confiance en vous,\nmes enfants!", german="Ihr müsst mehr an euch glauben,\nmeine Lieben!", italian="Abbiate fiducia in voi,\ntesori miei!", spanish="Debéis tener confianza y creer\nen vuestras habilidades."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_garuura, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 3] || scn($SCENARIO_MAIN) >= [23
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_garuura, 4) end)
  if ((SV.SkyTalkBitFlags or {})[66] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[66]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[66] = 1 -- $SCENARIO_TALK_BIT_FLAG[66] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english="Oh, my goodness! You're safe!\nOh, thank mercy!", french="Oh là là! Vous êtes indemnes!\nQuel bonheur!", german="Ach du meine Güte! Ihr seid\nin Sicherheit! Oh, ich bin ja so dankbar!", italian="Oh, accipicchia! State bene!\nOh, grazie al cielo!", spanish="¡Vaya, menos mal! ¡Estáis bien!\n¡Qué alivio!"})
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english="I was so worried about you![K]\nYou're back without a scratch on you...[K]\nThis is w-w-wonderful!", french="J'étais si inquiète![K]\nEt vous voilà de retour sans la moindre\négratignure...[K] Mais c'est merveilleux!", german="Ich habe mir solche Sorgen um\neuch gemacht![K] Ihr seid völlig unversehrt\nzurückgekehrt.[K] Das ist einfach w-wunderbar!", italian="Ero così preoccupata per voi![K]\nSiete di ritorno senza un graffio...[K]\nÈ m-m-magnifico!", spanish="¡Me teníais preocupada![K] Habéis\nvuelto de una pieza.[K] ¡Ya puedo respirar\ntranquila!"})
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english="...[K]I shouldn't be sobbing.\nI should be strong like you.", french="... [K]Je ne devrais pas pleurnicher.\nJe devrais me montrer forte, comme vous.", german="...[K]Ich sollte nicht rumschluchzen,\nsondern stark sein... So wie ihr.", italian="...[K] Non dovrei piangere.\nDovrei essere forte come voi.", spanish="Ya sé...[K] No debería dejarme\nllevar tanto por las emociones. Debería\nseguir vuestro ejemplo y ser fuerte."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_garuura, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 3] || scn($SCENARIO_MAIN) >= [17
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_garuura, 4) end)
  if ((SV.SkyTalkBitFlags or {})[65] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[65]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[65] = 1 -- $SCENARIO_TALK_BIT_FLAG[65] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english="If that [CS:N]Grovyle[CR] doesn't get\ncaught soon, this old lady won't sleep easy!", french="Si on n'attrape pas ce [CS:N]Massko[CR]\nrapidement, la vieille dame que je suis ne\ndormira pas sur ses deux oreilles!", german="Falls dieser [CS:N]Reptain[CR] nicht bald\ngefasst wird, werde ich alte Dame nicht mehr\nruhig schlafen können!", italian="Se quel [CS:N]Grovyle[CR] non verrà\ncatturato presto, questa vecchia signora non\nriuscirà a dormire sonni tranquilli!", spanish="Si no atrapan pronto a [CS:N]Grovyle[CR],\n¡no sé cómo voy a dormir tranquila!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_garuura, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 4] || scn($SCENARIO_MAIN) >= [12
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_garuura, 4) end)
  if ((SV.SkyTalkBitFlags or {})[64] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[64]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[64] = 1 -- $SCENARIO_TALK_BIT_FLAG[64] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english=" Welcome back!", french=" Contente de vous revoir!", german=" Willkommen zurück!", italian="Sono contenta di vedervi di\nnuovo qui!", spanish=" ¡Qué alegría que hayáis vuelto!"})
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english="Oh! After that expedition, you\nboth seem a little different. My dears, you\nhave a new lean, mean look!", french="Oh! Vous avez changé au cours\nde cette expédition, mes enfants! Comme vous\navez maigri!", german="Oh! Die Expedition hat euch\nirgendwie verändert. Meine Lieben, ihr seht\nja so verwegen aus!", italian="Oh! Dopo quella spedizione,\ntesori miei, mi sembra che abbiate acquisito\npiù smalto!", spanish="Tras esa expedición parecéis\nhaber cambiado. ¡Ahora se os ve capaces\nde cualquier cosa!"})
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english=" I can see that!", french=" Je le vois bien!", german=" Das kann ich wohl sehen!", italian=" Lo distinguo chiaramente!", spanish=" ¡Está tan claro como el agua!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_garuura, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [9, 1]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_garuura, 4) end)
  if ((SV.SkyTalkBitFlags or {})[63] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[63]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[63] = 1 -- $SCENARIO_TALK_BIT_FLAG[63] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english="You're going on an expedition?\nWell, doesn't that sound fun!", french="Vous partez en expédition?\nVoilà qui promet d'être amusant, dites-moi!", german="Ihr begebt euch auf eine\nExpedition? Nun, wenn das mal nicht nach Spaß\nklingt!", italian="State partendo per una\nspedizione? Sembra divertente!", spanish="¿Vais de expedición? ¡Vaya,\nsuena muy divertido!"})
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english="I'll be thinking of you, my dears!\nHave a good time!", french="Je penserai à vous, mes\nenfants! Amusez-vous bien!", german="Ich werde an euch denken, meine\nLieben! Viel Vergnügen!", italian="Vi penserò, tesori miei!\nPassatevela bene!", spanish="¡Os deseo lo mejor! ¡Que os\ndivirtáis!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_garuura, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
