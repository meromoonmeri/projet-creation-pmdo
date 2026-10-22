-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/enter09.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_neityio = SkySceneKit.spawn_npc("xatu", 240, 352, Direction.Down, "NPC_NEITYIO")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_neityio, 4) end)
  if ((SV.SkyTalkBitFlags or {})[102] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[102]
  -- @label_105 [étiquette de flux ExplorerScript]
  -- switch(message_Menu(MENU_APPRAISAL)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_109 [étiquette de flux ExplorerScript]
  -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
  do local __sw = ((SV.SkyMenuResults or {})["MENU_APPRAISA2"] or 0) -- switch(message_Menu(MENU_APPRAISA2)) [message_Menu(MENU_APPRAISA2): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 1 then
  GROUND:EntTurn(npc_npc_neityio, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  elseif __sw == 2 then
  -- GAP: se_Play(8715) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitSe
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  elseif __sw == 3 then
  -- GAP: se_Play(8716) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_neityio, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  elseif true then -- default
  -- break_loop [contrôle de boucle forever NDS: une itération compilée]
  end
  end
  -- @label_104 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[102] = 1 -- $SCENARIO_TALK_BIT_FLAG[102] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_neityio) end)
  SkySceneKit.say({english=" ...[K]The darkness...", french=" ... [K]L'ombre...", german=" ...[K]Die Dunkelheit...", italian=" ...[K] L'oscurità...", spanish=" ¡Oh!...[K] Las tinieblas..."})
  pcall(function() UI:SetSpeaker(npc_npc_neityio) end)
  SkySceneKit.say({english="The malevolent darkness has\nmelted away...", french="L'ombre malfaisante s'est\ndissipée...", german="Die heimtückische Dunkelheit hat\nsich aufgelöst.", italian=" L'oscurità maligna è svanita...", spanish="Las malévolas tinieblas se han\ndisipado..."})
  pcall(function() UI:SetSpeaker(npc_npc_neityio) end)
  SkySceneKit.say({english="It is your doing. You have\nmy thanks.", french="C'est grâce à vous. Je vous\nadresse mes remerciements.", german="Das ist euer Werk. Ich danke\neuch.", italian=" È merito vostro. Vi ringrazio.", spanish="Y todo se debe a lo que habéis\nhecho. Tenéis mi agradecimiento."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_neityio, 4) end)
  if ((SV.SkyTalkBitFlags or {})[101] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[101]
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[101] = 1 -- $SCENARIO_TALK_BIT_FLAG[101] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_neityio) end)
  SkySceneKit.say({english=" ...[K]Malevolent darkness...", french=" ... [K]Une ombre malfaisante...", german=" ...[K]Heimtückische Dunkelheit...", italian=" ...[K] Oscurità maligna...", spanish=" Hum...[K] Malévola oscuridad..."})
  pcall(function() UI:SetSpeaker(npc_npc_neityio) end)
  SkySceneKit.say({english="The darkness spreads and\ndeepens...", french="L'ombre s'étend et\ns'épaissit...", german="Die Dunkelheit breitet sich aus\nund vertieft sich.", italian="L'oscurità si diffonde e si fa\npiù profonda...", spanish="Las tinieblas se extienden, las\nsombras acechan..."})
  pcall(function() UI:SetSpeaker(npc_npc_neityio) end)
  SkySceneKit.say({english="Its progress can be halted,\nyes...[K] But only by you.", french="On peut encore mettre un terme\nà sa progression... [K]Mais notre seul espoir,\nc'est vous.", german="Ihr Ausbreiten kann verhindert\nwerden, ja.[K] Aber nur von euch.", italian="La sua diffusione può essere\narrestata, sì...[K] Ma soltanto da voi.", spanish="Tal vez se podría detener su\navance...[K] Pero eso es algo que solo\nestá en vuestras manos."})
  pcall(function() UI:SetSpeaker(npc_npc_neityio) end)
  SkySceneKit.say({english="I shall ask this of you.[K]\nStop [CS:N]Darkrai[CR]'s future of nightmares...", french="Je vous le demande instamment.\nEmpêchez l'avènement de ce futur\ncauchemardesque que nous prépare [CS:N]Darkrai[CR]...", german="Ich bitte euch darum,[K] die von\n[CS:N]Darkrai[CR] herbeigesehnte Zukunft voller\nAlbträume aufzuhalten.", italian="Devo chiedervelo.[K] Fermate\nil futuro fatto di incubi che vorrebbe [CS:N]Darkrai[CR]...", spanish="Os debo pedir algo.[K] Detened la\npesadilla que nos quiere imponer [CS:N]Darkrai[CR].\nSería un futuro muy negro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_neityio, 4) end)
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 67) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 67]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_neityio, 4) end)
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_neityio, 4) end)
  if ((SV.SkyTalkBitFlags or {})[100] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[100]
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[100] = 1 -- $SCENARIO_TALK_BIT_FLAG[100] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_neityio) end)
  SkySceneKit.say({english=" .............................................", french=" .............................................", german=" ......", italian=" .............................................", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_neityio) end)
  SkySceneKit.say({english="...[K]Team [CS:X]Charm[CR]... Kwah-ha-ha...\nJust lovely...", french="... [K]L'Equipe [CS:X]Charme[CR]...\nKwah HRROAAAH! Tout simplement adorables...", german="...[K]Team [CS:X]Charme[CR]... Kwah-ha-ha...\nEinfach reizend.", italian="...[K] Il Team [CS:X]Malia[CR]...\nAaah-ah-ah... Com'è delizioso...", spanish="Cuac...[K] El [CS:X]Equipo Carisma[CR]...\nCuac, cuac... Son encantadoras..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_neityio, 4) end)
  if ((SV.SkyTalkBitFlags or {})[99] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[99]
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[99] = 1 -- $SCENARIO_TALK_BIT_FLAG[99] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_neityio) end)
  SkySceneKit.say({english=" .............................................", french=" .............................................", german=" ......", italian=" .............................................", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_neityio) end)
  SkySceneKit.say({english="...[K]You two... I commend you\nfor graduating.", french="...[K] Vous... avez obtenu\nle diplôme de la Guilde. Je vous félicite.", german="...[K]Ihr zwei habt die\nAbschlussprüfung bestanden. Herzlichen\nGlückwunsch!", italian="...[K] Voi due... Complimenti per\naver passato l'esame.", spanish="Vaya...[K] Es admirable que hayáis\nsuperado el gran reto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 4] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_neityio, 4) end)
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_neityio, 4) end)
  if ((SV.SkyTalkBitFlags or {})[98] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[98]
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[98] = 1 -- $SCENARIO_TALK_BIT_FLAG[98] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_neityio) end)
  SkySceneKit.say({english=".............................................[K]\nTime marches on inexorably.", french=".............................................[K]\nLe temps suit son cours, inexorablement.", german="......[K]Die Zeit schreitet\nunaufhaltsam voran.", italian=".............................................[K]\nIl tempo avanza inesorabilmente.", spanish=" Sí...[K] El tiempo pasa y no vuelve."})
  pcall(function() UI:SetSpeaker(npc_npc_neityio) end)
  SkySceneKit.say({english="The time allowed you is but\nlittle. However...", french="Il vous reste bien peu de temps.\nNéanmoins...", german="Die Zeit, die euch gegeben wird,\nist nur kurz. Allerdings...", italian="Avete così poco tempo.\nTuttavia...", spanish="El tiempo con que contáis es\nescaso. Pese a ello..."})
  pcall(function() UI:SetSpeaker(npc_npc_neityio) end)
  SkySceneKit.say({english="You, I can tell, shall prevail.[K]\nBut you must not falter.", french="Je sais que vous triompherez\nde tous les obstacles.[K] Mais vous ne devez pas\nfaillir.", german="Ihr, so weiß ich, werdet euch\ndurchsetzen.[K] Aber ihr dürft nicht zögern.", italian="Voi, lo so, ce la potete fare.[K]\nMa non dovete esitare.", spanish="Puedo ver que tendréis éxito.[K]\nPero no debéis desfallecer."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_neityio, 4) end)
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 3] || scn($SCENARIO_MAIN) >= [23
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_neityio, 4) end)
  if ((SV.SkyTalkBitFlags or {})[97] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[97]
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[97] = 1 -- $SCENARIO_TALK_BIT_FLAG[97] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_neityio) end)
  SkySceneKit.say({english=".............................................[K]\n...........................................................", french=".............................................[K]\n.....................................................................", german=" ......[K] ......", italian=".............................................[K]\n.....................................................................", spanish=" Hum...[K] Hum..."})
  pcall(function() UI:SetSpeaker(npc_npc_neityio) end)
  SkySceneKit.say({english=" ...[K]It has been a long time...", french=" ... [K]Cela faisait fort longtemps...", german=" ...[K]Es ist lange her.", italian=" ...[K] È passato molto tempo...", spanish=" Pues...[K] Ha pasado mucho tiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_neityio, 4) end)
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 3] || scn($SCENARIO_MAIN) >= [17
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_neityio, 4) end)
  if ((SV.SkyTalkBitFlags or {})[96] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[96]
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[96] = 1 -- $SCENARIO_TALK_BIT_FLAG[96] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_neityio) end)
  SkySceneKit.say({english="We all have a purpose. One that\nis unique to each of us.", french="Nous avons tous un but. Un but\nqui nous est propre.", german="Wir alle dienen einem\nbestimmten Zweck. Einem, der bei jedem von\nuns anders geartet ist.", italian="Tutti abbiamo un obiettivo.\nUn fine che è unico per ognuno di noi.", spanish="Todos tenemos un propósito. Es\nalgo que solo posee cada uno de nosotros."})
  pcall(function() UI:SetSpeaker(npc_npc_neityio) end)
  SkySceneKit.say({english="One must serve that purpose the\nbest they can. Kwah... Hah!", french="Chacun doit tendre vers ce but\ndu mieux qu'il peut. Kwah... HRROAAAH!!!", german="Diesem Zweck muss man dienen,\nso gut man kann. Kwah... Hah!", italian="Ognuno deve cercare di\nrealizzare il proprio obiettivo dando il meglio\ndi sé. Aaah... ah!", spanish="Uno ha de servir a ese propósito\nlo mejor que pueda. ¡Cuac, cuac!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_neityio, 4) end)
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_104 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
