-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P05A/um2501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 208, 200, Direction.Up, "NPC_PUKURIN")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" You two are fantastic!", french="Vous deux alors, vous êtes\nfantastiques!", german=" Ihr zwei seid fantastisch!", italian=" Siete grandi!", spanish=" ¡Sois un equipo fantástico!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="You saved the world not just\nonce, but twice! ♪", french="Vous n'avez pas sauvé le monde\nune, mais deux fois! ♪", german="Ihr habt die Welt nicht nur\neinmal, sondern zweimal gerettet! ♪", italian="Avete salvato il mondo non una\nsola volta, ma due! ♪", spanish="¡No solo habéis salvado el\nmundo una vez, sino dos! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I think you're going to become an\neven more incredible exploration team!", french="Je crois bien que vous allez\ndevenir une équipe d'exploration encore\nplus impressionnante!", german="Ich bin der Ansicht, dass ihr ein\nnoch unglaublicheres Erkundungsteam werdet!", italian="Penso che diventerete una\nsquadra d'esplorazione fuori dal comune!", spanish="¡A este paso vais a convertiros\nen un equipo aún más extraordinario!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Equal to even the legendary\nTeam [CS:X]Raider[CR]! ♪", french="Peut-être même jusqu'à égaler\nla fameuse Equipe [CS:X]As[CR]! ♪", german="Sogar dem legendären Team\n[CS:X]Schatzsucher[CR] ebenbürtig! ♪", italian="Allo stesso livello del\nleggendario Team [CS:X]Asso[CR]! ♪", spanish="¡Quizás incluso podáis igualar al\nlegendario [CS:X]Equipo As[CR]! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Keep up your exploring! ♪", french=" Continuez à explorer! ♪", german=" Setzt eure Erkundungen fort! ♪", italian=" Continuate a esplorare! ♪", spanish=" ¡Seguid explorando! ♪"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="You two can do it. You've shown\nme you can! ♪", french="Vous pouvez y arriver, vous\ndeux. Vous me l'avez déjà prouvé moult\nfois! ♪", german="Ihr zwei könnt es schaffen. Ihr\nhabt mir gezeigt, dass ihr es könnt! ♪", italian="Voi due ce la potete fare!\nSappiamo di cosa siete capaci! ♪", spanish="Podéis encargaros de ello. Ya\nme lo habéis probado muchas veces. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="It's all up to you to defeat that\n[CS:N]Darkrai[CR]! ♪", french="Il n'y a que vous qui puissiez\nvaincre ce [CS:N]Darkrai[CR]! ♪", german="Es ist an euch, [CS:N]Darkrai[CR]\nzu besiegen! ♪", italian="Solo voi potete battere\n[CS:N]Darkrai[CR]! ♪", spanish="¡Ahora os toca derrotar a ese\n[CS:N]Darkrai[CR]! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Now we have to investigate the\ndistortion of space! ♪", french="Maintenant, on doit enquêter sur\nla distorsion spatiale! ♪", german="Jetzt müssen wir die\nRaumkrümmung untersuchen! ♪", italian="Ora dobbiamo indagare sulla\ndistorsione dello spazio! ♪", spanish="¡Tenemos que investigar esa\ndeformación del espacio! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="If we don't, we won't be able\nto stop the nightmare from spreading! ♪", french="Sinon, on ne pourra pas\nempêcher le cauchemar de se répandre! ♪", german="Wenn wir das nicht tun, werden\nwir die Ausbreitung des Albtraums nicht\naufhalten können! ♪", italian="Se no, non saremo in grado di\nfermare la diffusione dell'incubo! ♪", spanish="Si no lo hacemos, ¡no podremos\nevitar que la pesadilla se extienda! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 76] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" It's good you found [CS:N]Drowzee[CR]! ♪", french="C'est bien que vous ayez\nretrouvé [CS:N]Soporifik[CR]! ♪", german="Es ist gut, dass ihr [CS:N]Traumato[CR]\ngefunden habt! ♪", italian="Ullalà! Avete trovato\n[CS:N]Drowzee[CR]! ♪", spanish="¡Qué bien que encontrasteis a\n[CS:N]Drowzee[CR]! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Now it gets tricky![K] You have to\nfind out why [CS:N]Azurill[CR] can't wake from his\nnightmare! ♪", french="Mais c'est là que ça devient\ncoton![K] Vous devez découvrir pourquoi\n[CS:N]Azurill[CR] est coincé dans son cauchemar! ♪", german="Jetzt wird es kompliziert![K] Ihr\nmüsst herausfinden, warum [CS:N]Azurill[CR] nicht aus\nseinem Albtraum aufwachen kann! ♪", italian="Adesso viene il difficile![K]\nDovete scoprire perché [CS:N]Azurill[CR] non riesce\na svegliarsi dal suo incubo! ♪", spanish="¡Ahora llega lo más complicado![K]\n¡Debéis averiguar por qué [CS:N]Azurill[CR] no consigue\ndespertarse de su pesadilla! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 73] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="We'll leave this up to you,\nTeam [team:]! ♪", french="On vous laisse faire,\nEquipe [team:]! ♪", german="Wir werden euch dies\nüberlassen, Team [team:]! ♪", italian="Toccherà a voi,\nTeam [team:]! ♪", spanish="¡Esta misión queda en vuestras\nmanos, [CS:X]Equipo[CR] [team:]! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Bring [CS:N]Drowzee[CR] back here! ♪", french=" Ramenez-nous [CS:N]Soporifik[CR]! ♪", german=" Bringt [CS:N]Traumato[CR] hierher! ♪", italian=" Riportate qui [CS:N]Drowzee[CR]! ♪", spanish=" ¡Traed a [CS:N]Drowzee[CR] aquí! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 71] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Keep up exploring as always! ♪", french="Continuez à explorer comme\nd'habitude! ♪", german="Geht weiter auf Erkundung\nwie gehabt! ♪", italian="Continuate a esplorare come al\nsolito! ♪", spanish="¡Seguid explorando como\nsiempre! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Yay! Yay! ♪ Perfect Apple! ♪\nPerfect Apple! ♪", french="Youpla! Youpla! ♪ Pomme\nParfaite! ♪ Pomme Parfaite! ♪", german="Juchhu! Juchhu! ♪ Perfekter\nApfel! ♪ Perfekter Apfel! ♪", italian="Woo! Woo! ♪\nMela Perfetta! ♪ Mela Perfetta! ♪", spanish="¡Chachi! ¡Chachi! ♪ ¡Manzana\nPerfecta! ♪ ¡Manzana Perfecta! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Friendly friends! ♪[K] Are you\nkeeping up with your exploring?", french="Copains de moi! ♪[K] Est-ce que\nvous continuez à explorer des donjons?", german="Liebe Freunde! ♪[K] Geht ihr\nweiterhin auf Erkundungen?", italian="Amichevoli amici! ♪[K] State\ncontinuando a esplorare?", spanish="¡Los amigos son lo mejor! ♪[K]\n¿Seguís explorando como siempre?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 41] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" The Secret Rank?", french=" Le Grade Secret?", german=" Der Geheim-Rang?", italian=" Il Rango Segreto?", spanish=" ¿El Rango Secreto?"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Wow! Seems like a fun rank! ♪", french="Waouh! Ça a l'air marrant\ncomme grade! ♪", german="Wow! Hört sich wie ein\nspaßiger Rang an! ♪", italian="Wow! Sembra un rango\nspassoso! ♪", spanish="¡Vaya! ¡Qué divertido parece\neso! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 33] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Congratulations! You graduated\nfrom the guild! ♪", french="Félicitations! Vous avez obtenu\nvotre diplôme de la Guilde! ♪", german="Glückwunsch! Ihr habt den\nGildenabschluss erworben! ♪", italian="Congratulazioni! Avete passato\nl'esame della Gilda! ♪", spanish="¡Enhorabuena! ¡Habéis superado\nel gran reto! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="From now on, your team can\nexplore independently from us! ♪", french="Désormais, votre équipe peut\npartir en exploration indépendamment de\nla Guilde! ♪", german="Von jetzt an kann euer Team\nunabhängig von uns auf Erkundung gehen! ♪", italian="Da oggi in poi, la vostra squadra\npuò esplorare indipendentemente da noi! ♪", spanish="Desde ahora, ¡vuestro equipo\npuede actuar independientemente! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="But if you have trouble deciding\nwhere you want to explore...", french="Mais si vous ne savez pas\noù partir en exploration...", german="Aber wenn ihr euch nicht sicher\nseid, wo ihr auf Erkundung gehen wollt...", italian="Ma se avete dei problemi a\ndecidere dove volete andare...", spanish="Pero si no acabáis de decidiros\nsobre dónde explorar..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="You can always take on the jobs\nlisted here! ♪", french="Vous pouvez toujours accomplir\nles missions affichées ici! ♪", german="Könnt ihr immer die hier\ngelisteten Jobs annehmen! ♪", italian="Potete sempre scegliere tra le\nmissioni elencate qui! ♪", spanish="¡Siempre podéis venir a aceptar\nlas misiones que tenemos aquí! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I hope you'll keep exploring all\non your own! ♪", french="J'espère que vous continuerez\nà explorer de votre côté! ♪", german="Ich hoffe, dass ihr auf eigene\nFaust weiter erkundet! ♪", italian="Spero che continuerete a\nesplorare per conto vostro! ♪", spanish="¡Espero que sigáis explorando\nmucho por vuestra cuenta! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 4] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Work hard on your graduation\nexam! ♪", french="Travaillez dur pour votre\nexamen de la Guilde! ♪", german="Arbeitet hart an eurer\nAbschlussprüfung! ♪", italian="Mettetecela tutta durante\nl'esame! ♪", spanish="¡Esforzaos mucho en el gran\nreto! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Ooooh, Team [team:]! You\ncan do it! ♪", french="Ooooh, Equipe [team:]!\nVous avez toute ma confiance! ♪", german="Ooooh, Team [team:]! Ihr\nkönnt es schaffen! ♪", italian="Ooooh, Team [team:]!\nCe la potete fare! ♪", spanish="¡Ooooh, [CS:X]Equipo[CR] [team:]!\n¡Podéis hacerlo! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Best of luck! ♪", french=" Bonne chance! ♪", german=" Viel Glück! ♪", italian=" In bocca al lupo! ♪", spanish=" ¡Muchísima suerte! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="We're going to [CS:P]Brine Cave[CR]\ntomorrow! ♪", french="Demain, nous allons à la [CS:P]Caverne\nSaline[CR]! ♪", german="Morgen gehen wir zur\n[CS:P]Salzwasserhöhle[CR]! ♪", italian="Domani andiamo alla [CS:P]Grotta[CR]\n[CS:P]Salmastra[CR]! ♪", spanish="¡Mañana iremos a la [CS:P]Cueva[CR]\n[CS:P]Aguamar[CR]! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Go get ready while you have\nthe chance! ♪", french="Allez vous préparer tant qu'il en\nest encore temps! ♪", german="Bereitet euch vor, solange ihr\nnoch könnt! ♪", italian="Andate a prepararvi, finché\navete tempo! ♪", spanish="¡Id a prepararos mientras estéis\na tiempo! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(22, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [22, 3]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="You should ask [CS:N]Torkoal[CR], the\ntown elder.", french="Vous devriez demander à\n[CS:N]Chartor[CR], le doyen du bourg.", german="Ihr solltet [CS:N]Qurtel[CR], den\nDorfältesten, befragen.", italian="Dovreste chiedere a [CS:N]Torkoal[CR],\nl'anziano della città.", spanish="Deberíais preguntarle a [CS:N]Torkoal[CR],\nel anciano de la aldea."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="He may know something about\nthe [CS:P]Hidden Land[CR]! ♪", french="Il saura peut-être quelque chose\nà propos des [CS:P]Terres Illusoires[CR]! ♪", german="Er könnte etwas über das\n[CS:P]Verborgene Land[CR] wissen! ♪", italian="Potrebbe sapere qualcosa sulla\n[CS:P]Terra Nascosta[CR]! ♪", spanish="¡Puede que sepa algo sobre\nla [CS:P]Tierra Oculta[CR]! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="You should put his years of\nwisdom to use! ♪", french="Mettez donc à profit ses longues\nannées de sagesse! ♪", german="Ihr solltet euch seine\nunermessliche Weisheit zunutze machen! ♪", italian="Dovreste approfittare di tutti\ni suoi anni di saggezza! ♪", spanish="¡Su experiencia nos puede\nresultar muy útil! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [22, 2]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Go talk to [CS:N]Torkoal[CR],\nthe town elder.", french="Allez consulter [CS:N]Chartor[CR],\nle doyen du bourg.", german="Geht und befragt [CS:N]Qurtel[CR], den\nDorfältesten.", italian="Andate a parlare con [CS:N]Torkoal[CR],\nl'anziano della città.", spanish="Id a hablar con [CS:N]Torkoal[CR],\nel anciano de la aldea."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="If anyone knows about the\n[CS:P]Hidden Land[CR], it'd be him! ♪", french="S'il y a bien quelqu'un qui connaît\nles [CS:P]Terres Illusoires[CR], c'est lui! ♪", german="Wenn jemand etwas über das\n[CS:P]Verborgene Land[CR] weiß, dann er! ♪", italian="Solo lui può sapere qualcosa\ndella [CS:P]Terra Nascosta[CR]! ♪", spanish="Si alguien recuerda algo aún\nsobre la [CS:P]Tierra Oculta[CR], ¡tiene que ser él! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="You should put his years of\nwisdom to use! ♪", french="Mettez donc à profit ses longues\nannées de sagesse! ♪", german="Ihr solltet euch seine\nunermessliche Weisheit zunutze machen! ♪", italian="Dovreste approfittare di tutti\ni suoi anni di saggezza! ♪", spanish="¡Su experiencia nos puede\nresultar muy útil! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  -- @label_122 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Friendly friends! ♪[K] Keep up\nyour training!", french="Copains de moi! ♪[K] Poursuivez\nvotre entraînement!", german="Liebe Freunde! ♪[K] Setzt euer\nTraining fort!", italian="Amichevoli amici! ♪[K]\nContinuate così!", spanish="¡Qué bonita es la amistad! ♪[K]\n¡Seguid con el entrenamiento!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Do your very best!", french=" Faites de votre mieux!", german=" Gebt euer Bestes!", italian=" Date il massimo!", spanish=" ¡Hay que esforzarse al máximo!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 1] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="In the name of [CS:N]Wigglytuff[CR]'s\nGuild...[K]we'll catch that [CS:N]Grovyle[CR]!", french="Sur l'honneur de la Guilde de\n[CS:N]Grodoudou[CR]... [K]nous attraperons ce [CS:N]Massko[CR]!", german="Im Namen der [CS:N]Knuddeluff-Gilde[CR][K]\nwerden wir diesen [CS:N]Reptain[CR] fassen!", italian="Nel nome della Gilda di\n[CS:N]Wigglytuff[CR]...[K]\nCattureremo [CS:N]Grovyle[CR]!", spanish="En nombre del [CS:N]Pokégremio de[CR]\n[CS:N]Exploradores[CR]...[K] ¡prometo que atraparemos\na ese [CS:N]Grovyle[CR]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [13, 2] || scn($SCENARIO_MAIN) >= [13
  -- jump @label_122 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 1]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Hiya!", french=" Amis du jour, bonjour!", german=" Hallöchen!", italian=" Ullalà!", spanish=" ¿Qué hay?"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="The expedition was fun! ♪[K]\nLet's do it again soon! ♪ La-la-la! ♪", french="C'était rigolo, l'expédition! ♪[K]\nIl faudra qu'on remette ça rapidement! ♪\nLa la la! ♪", german="Die Expedition hat Spaß\ngemacht! ♪[K] Lasst uns das bald\nwiederholen! ♪ Lalala! ♪", italian="La spedizione è stata uno\nspasso! ♪[K] Rifacciamola presto! ♪\nLa-la-la! ♪", spanish="¡Qué divertida que fue la\nexpedición! ♪[K] ¡Hay que repetirla un día\nde estos! ♪ ¡Laralá! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Oh, I wish the gang would report\nin soon! ♪ Ooooh, this is exciting! ♪", french="Oh, j'espère que la troupe va\nvite venir au rapport! ♪\nOoooh, comme c'est palpitant! ♪", german="Oh, ich wünschte, die Bande\nwürde sich bald melden! ♪ Ooooh, das ist\naufregend! ♪", italian="Oh, spero che vengano presto!\nOoooh, che emozione! ♪", spanish="¡Oh, a ver si nos informan\npronto de las novedades! ♪ ¡Ooooh,\npero qué emocionante! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [9, 5] || scn($SCENARIO_MAIN) >= [9, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="We're going on an expedition![K]\nFun, fun, fun! ♪ Ooooh! ♪", french="On part en expédition![K]\nOn va s'amuser, s'amuser, s'amuser! ♪\nYoupla! ♪", german="Wir begeben uns auf eine\nExpedition![K] Was für ein Riesenspaß! ♪\nOoooh! ♪", italian="Esplorazione, arriviamo![K]\nSpasso, spasso, spasso! ♪ Ooooh! ♪", spanish="¡Vamos de expedición![K]\n¡Mola, mola, mola! ♪ ¡Bieeeeen! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I'd better not forget my precious\nPerfect Apple! ♪[K] La-la-la! ♪", french="Je ferais mieux de ne pas\noublier ma précieuse Pomme Parfaite! ♪[K]\nLa la la! ♪", german="Ich vergesse meinen wertvollen\nPerfekten Apfel besser nicht! ♪[K] Lalala! ♪", italian="Farei meglio a non dimenticare\nla mia preziosa Mela Perfetta! ♪[K]\nLa-la-la! ♪", spanish="¡Será mejor que no me olvide\nde mi preciosa Manzana Perfecta! ♪[K]\n¡Laralá! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7] || scn($SCENARIO_MAIN) >= [8, 
  -- jump @label_122 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 2] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Huh?[K] You're going to get me\nsome Perfect Apples?", french="Hein?[K] Vous allez me chercher\ndes Pommes Parfaites?", german="Wie?[K] Ihr wollt mir ein paar\nPerfekte Äpfel besorgen?", italian="Eh?[K] State andando a prendermi\ndelle Mele Perfette?", spanish="¿Eh?[K] ¿Me vais a traer algunas\nManzanas Perfectas?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Yay! Thanks! ♪", french=" Youhou! Merci! ♪", german=" Juchhu! Danke! ♪", italian=" Woo! Grazie! ♪", spanish=" ¡Genial! ¡Gracias! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Friendly friends! ♪[K] Bring me\nlots and lots and lots!", french="Copains de moi! ♪[K]\nApportez-m'en des tonnes et des tonnes!", german="Liebe Freunde! ♪[K] Bringt mir\nviele, viele, viele!", italian="Amichevoli amici! ♪[K]\nPortatemene ancora, ancora ed ancora!", spanish="¡Los amigos son lo mejor! ♪[K]\n¡Traedme montones y montones y montones!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 6] || scn($SCENARIO_MAIN) >= [7, 
  -- jump @label_122 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 7]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Hiya![K] You caught an outlaw?\nThat's just super!", french="Amis du jour, bonjour![K] Vous avez\ncapturé un hors-la-loi? C'est super chouette!", german="Hallöchen![K] Ihr habt einen\nGanoven geschnappt? Das ist einfach super!", italian="Ullalà![K] Avete catturato un\nricercato? È straordinario!", spanish="¿Qué hay?[K] ¿Habéis capturado\na algún malhechor? ¡Qué chachi!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Friendly friends! ♪[K] Keep up the\ngood work!", french="Copains de moi! ♪[K] Continuez\nà faire du bon travail!", german="Liebe Freunde! ♪[K] Macht\nweiter so!", italian="Amichevoli amici! ♪[K]\nContinuate così!", spanish="¡Los amigos son lo mejor! ♪[K]\n¡Seguid así!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="How do you like living in the\nguild?[K] Is it fun?", french="Comment vous trouvez la vie à\nla Guilde?[K] Ça vous plaît?", german="Wie gefällt euch das Leben in\nder Gilde?[K] Macht es Spaß?", italian="Vi piace vivere nella Gilda?[K]\nÈ divertente?", spanish="¿Os gusta vivir en el\n[CS:N]Pokégremio[CR]?[K] ¿Es divertido?"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Friendly friends! ♪[K] Go out and\nwork hard for us!", french="Copains de moi! ♪[K]\nMettez-vous en route et travaillez dur pour\nnous!", german="Liebe Freunde! ♪[K] Zieht los und\narbeitet hart für uns!", italian="Amichevoli amici! ♪[K] Andate e\nmettetecela tutta!", spanish="¡Los amigos son lo mejor! ♪[K]\n¡Salid ahí fuera a trabajar duro por todos\nnosotros!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 2] || scn($SCENARIO_MAIN) >= [4, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
