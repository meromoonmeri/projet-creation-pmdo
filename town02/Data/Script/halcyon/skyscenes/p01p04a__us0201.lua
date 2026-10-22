-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P04A/us0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_yadon = SkySceneKit.spawn_npc("slowpoke", 392, 296, Direction.Up, "NPC_YADON")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yadon, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english="We've been away from Treasure\nTown for some time...", french="On a quitté Bourg-Trésor\nquelque temps...", german="Nach einiger Zeit sind wir\nmal wieder in Schatzstadt.", italian="Siamo stati via da Borgo Tesoro\nper un po' di tempo...", spanish="Hacía tiempo que no veníamos\npor Aldea Tesoro."})
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english=" I like it here. It's so laid back.", french="J'aime bien cet endroit. C'est\ntellement relax.", german="Mir gefällt es hier. Es ist so\nlocker hier.", italian="Mi piace qui.\nÈ rilassante.", spanish="Me gusta estar aquí. Es bastante\nrelajado."})
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english="Oh...[K] My motivation's\nslipping already...", french="Oh...[K] Voilà que ma motivation\ndécline déjà...", german="Oh...[K] Meine Motivation schwindet\nbereits...", italian="Oh...[K] La mia motivazione\nsi sta... dissolvendo...", spanish="¡Uf![K] Ya empiezo a\ndesmotivarme."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 93] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yadon, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english="First time I come here, and\nthe place is empty...", french="C'est la première fois que je\nviens ici et il n'y a personne...", german="Das ist das erste Mal, dass ich\nhierherkomme und dieser Ort leer ist...", italian="Vengo qui per la prima volta e\nil posto è deserto...", spanish="Es la primera vez que vengo y\nme encuentro con que el sitio está vacío..."})
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english=" This shop is lacking drive.", french=" Ce magasin manque d'animation.", german=" Diesem Laden fehlt der Schwung!", italian="Questo negozio non è gestito\nbene.", spanish=" A este local le falta ambiente."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 31] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yadon, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english="The planet will be paralyzed if\nsomething's not done?", french="Alors la planète va être\nparalysée si on ne fait rien?", german="Der Planet wird gelähmt werden,\nwenn nichts unternommen wird?", italian="Se non faremo qualcosa, il\npianeta si paralizzerà?", spanish="¿El planeta quedará paralizado\nsi nadie lo evita?"})
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english="We'd offer to help...[K]but being\nmotivated isn't really our thing...", french="On vous aiderait bien... [K]mais\non n'a pas tellement envie... La motivation\net nous, ça fait au moins trois...", german="Wir würden ja Hilfe\nanbieten,[K] aber motiviert zu sein, ist irgendwie\nnicht so unser Ding.", italian="Vorremmo incoraggiarvi...[K] ma\nla parola motivazione non è nel nostro\nvocabolario.", spanish="Nosotros te ayudaríamos...[K] pero\nno estamos lo bastante motivados."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 1] || scn($SCENARIO_MAIN) >= [22
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yadon, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english="They say if you take a Time\nGear away, the time stops where that Time\nGear was.", french="On dit que si un Rouage du\nTemps disparaît quelque part, alors le temps\ns'arrête à cet endroit-là.", german="Man sagt, dass die Zeit an dem\nentsprechenden Ort stehenbleibt, wenn man ein\nZahnrad der Zeit entfernt.", italian="Dicono che se porti via dal suo\nposto un Ingranaggio del Tempo, lì il tempo\nsi arresta.", spanish="Dicen que si quitas un Engranaje\ndel Tiempo, el tiempo se para en ese lugar."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 4] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yadon, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english="Oh, hi. How was your\nexpedition?", french="Tiens, salut. Comment c'était\nvotre expédition?", german="Oh, hallo. Wie war eure\nExpedition?", italian="Oh, ehi, com'è andata la vostra\nspedizione?", spanish=" Ah, hola. ¿Qué tal la expedición?"})
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english=" Wasn't it too much work?", french=" Ça n'a pas été fatigant?", german=" War das nicht zu viel Arbeit?", italian="Non è stata troppo faticosa,\nvero?", spanish="¿No os pareció un esfuerzo\nenorme?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 1] || scn($SCENARIO_MAIN) >= [10
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_namakero = SkySceneKit.spawn_npc("slakoth", 392, 264, Direction.Down, "NPC_NAMAKERO")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yadon, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english="We've heard other exploration\nteams are losing their will to work. You know,\nbecause of the stench.", french="Il paraît que les autres équipes\nperdent toute envie d'explorer, elles aussi.\nVous savez, à cause de la puanteur.", german="Wir haben gehört, dass andere\nTeams ihre Motivation eingebüßt haben.\nIhr wisst schon, wegen des Gestanks.", italian="Abbiamo saputo che le altre\nsquadre d'esplorazione stanno perdendo la\nvoglia di lavorare. Sapete, per via della puzza.", spanish="Hemos oído que a otros equipos\nexploradores se les han quitado las ganas\nde trabajar. Ya sabéis, por el pestazo."})
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english=" It didn't have any effect on us.", french="Pour être franc, nous, niveau\nmotivation, on n'a pas vu la différence...", german="Auf uns hatte das keinerlei\nEffekt.", italian=" Su di noi non ha alcun effetto.", spanish="Eso no ha tenido ningún efecto\nen nosotros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_namakero) end)
  SkySceneKit.say({english="Yup.[K] We didn't have any energy\nto begin with.", french="Ouaip.[K] De toute façon, déjà\nau départ, l'énergie, c'est pas trop notre\ntruc...", german="Jup.[K] Wir hatten ohnehin keinerlei\nMotivation.", italian="Già.[K] Non abbiamo nemmeno\nl'energia per alzare un dito.", spanish="Total...[K] No íbamos a hacer nada\nde todas formas..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 3] || scn($SCENARIO_MAIN) >= [7, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yadon, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english="We're Team [CS:X]Slacker[CR].[K] We're the\nexploration team without any motivation.", french="On est l'Equipe [CS:X]Flemmards[CR].[K]\nL'équipe d'exploration avec zéro motivation.", german="Wir sind Team [CS:X]Faulenzer[CR].[K] Wir\nsind das Erkundungsteam, das nicht einmal über\ndie geringste Motivation verfügt.", italian="Noi siamo il Team [CS:X]Siesta[CR].[K]\nSiamo una squadra d'esplorazione assolutamente\npriva di motivazioni.", spanish="Somos el [CS:X]Equipo Gandul[CR].[K]\nUn equipo explorador sin motivación\nalguna."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 1] || scn($SCENARIO_MAIN) >= [6, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yadon, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english="We're Team [CS:X]Slacker[CR].[K] We're the\nzero-motivation exploration team.", french="On est l'Equipe [CS:X]Flemmards[CR].[K]\nL'équipe d'exploration avec zéro motivation.", german="Wir sind Team [CS:X]Faulenzer[CR].[K] Wir\nsind das Erkundungsteam, das nicht einmal über\ndie geringste Motivation verfügt.", italian="Noi siamo il Team [CS:X]Siesta[CR].[K]\nSiamo la squadra d'esplorazione con zero\nmotivazioni.", spanish="Somos el [CS:X]Equipo Gandul[CR].[K]\nUn equipo explorador sin motivación\nalguna."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [5, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
