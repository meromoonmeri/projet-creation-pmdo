-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/us2308.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_namakero = SkySceneKit.spawn_npc("slakoth", 312, 272, Direction.UpLeft, "NPC_NAMAKERO")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_namakero, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_namakero) end)
  SkySceneKit.say({english="Exploring is far too much\neffort...[K] Maybe we'll go to the Hot Spring...", french="L'exploration, ça nous épuise...[K]\nEt si on allait à la Source Chaude?", german="Erkunden erfordert viel zu viel\nAnstrengung.[K] Vielleicht werden wir zur\nHeißen Quelle gehen.", italian="Anche esplorare è troppo\nfaticoso...[K] Al massimo potremmo andare alla\nSorgente Termale...", spanish="Explorar supondría demasiado\nesfuerzo...[K] Quizás vayamos a la Terma."})
  pcall(function() UI:SetSpeaker(npc_npc_namakero) end)
  SkySceneKit.say({english="But going to the Hot Spring from\nhere takes too much effort...", french="Ah ouais, mais il faudrait faire\nla route jusqu'à la Source Chaude... Nan,\nça aussi, ce serait trop épuisant...", german="Aber von hier zur Heißen Quelle\nzu gehen, erfordert zu viel Anstrengung.", italian="Ma andare da qui fino alla\nSorgente Termale è troppo faticoso...", spanish="Aunque ir a la Terma desde aquí\ntambién puede resultar agotador..."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 93] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_namakero, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_namakero) end)
  SkySceneKit.say({english=" What's a Recycle Shop?", french=" C'est quoi une Bourse d'Echange?", german="Was ist ein\nWiederverwertungsladen?", italian=" Che cos'è un Centro Riciclo?", spanish=" ¿Qué es el [CS:K]Reciclaje Explorador[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_namakero) end)
  SkySceneKit.say({english="Learning things takes too\nmuch effort...", french="Apprendre de nouveaux trucs,\nc'est trop fatigant...", german="Neues zu lernen ist wirklich\nsehr anstrengend...", italian=" Imparare è troppo faticoso...", spanish="Aprender cosas me cansa\nlo indecible..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 31] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_namakero, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_namakero) end)
  SkySceneKit.say({english="Getting excited over the planet's\nparalysis takes too much effort...", french="A quoi bon s'agiter pour éviter\nla Paralysie de la Planète? C'est beaucoup\ntrop d'efforts...", german="Im Hinblick auf die Lähmung des\nPlaneten nervös zu werden, erfordert zu viel\nAnstrengung.", italian="Agitarsi per la paralisi del\npianeta è troppo faticoso...", spanish="Inquietarnos por la parálisis del\nplaneta requeriría demasiado esfuerzo..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 1] || scn($SCENARIO_MAIN) >= [22
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_namakero, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_namakero) end)
  SkySceneKit.say({english="Time stopping...[K]might not make\nany difference to us.", french="Le temps peut bien s'arrêter...[K]\nNous, on ne remarquera même pas la\ndifférence.", german="Ein Zeitstillstand...[K] Das würde\nfür uns keinen Unterschied machen.", italian="Anche se il tempo dovesse\nfermarsi,[K] per noi non cambierebbe nulla.", spanish="Que se pare el tiempo...[K] a\nnosotros no nos va a afectar gran cosa."})
  pcall(function() UI:SetSpeaker(npc_npc_namakero) end)
  SkySceneKit.say({english=" We're not moving either way.", french="Nous, on ne bouge jamais,\nquoi qu'il arrive.", german="Wir bewegen uns schon jetzt\nnicht mehr als unbedingt nötig.", italian=" Non ci muoviamo comunque.", spanish="Tampoco es que nos movamos\nmucho precisamente."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 4] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_namakero, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_namakero) end)
  SkySceneKit.say({english="Just lying here takes too\nmuch effort...", french="Rien que rester affalés ici,\nc'est déjà trop crevant pour nous...", german="Nur hier herumzuliegen\nerfordert schon zu viel Anstrengung.", italian="Stare stesi qui è già anche\ntroppo faticoso per noi...", spanish="Solo estar aquí parados ya nos\nsupone un gran esfuerzo..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 1] || scn($SCENARIO_MAIN) >= [10
  -- SetAnimation(2) [anim idle native]
  local npc_npc_yadon = SkySceneKit.spawn_npc("slowpoke", 288, 256, Direction.DownRight, "NPC_YADON")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_namakero, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english="Other teams are losing their\nstomachs for exploring because of the awful\nstench lately...", french="Ces derniers temps, certaines\néquipes ne vont plus en exploration à cause\nde cette puanteur infecte...", german="Andere Teams sind schon so\nbenebelt von dem fürchterlichen Gestank,\ndass sie nicht mehr auf Erkundung gehen.", italian="Le altre squadre ultimamente\nstanno faticando molto a esplorare a causa di\nquella puzza insopportabile...", spanish="A otros equipos se les ha\nrevuelto el estómago por explorar con\nel hedor que hay últimamente..."})
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english=" But it hasn't affected us.", french="Mais nous, ça ne nous gêne pas\ndu tout.", german="Aber uns konnte er bisher\nnichts anhaben.", italian=" Ma su di noi non ha effetto.", spanish="Pero a nosotros no nos ha\nafectado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_namakero) end)
  SkySceneKit.say({english="Yeah.[K] How could we get any less\nmotivated than we are now...?", french="Eh ouais...[K] De toute façon,\nmoins motivés que nous, tu meurs...", german="Ja.[K] Wie könnten wir auch noch\nweniger motiviert sein als im Moment?", italian="Sì.[K] Siamo la demotivazione\nfatta Pokémon, noi.", spanish="Total...[K] ¿Qué nos podría\ndesmotivar más de lo que ya estamos?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 3] || scn($SCENARIO_MAIN) >= [7, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_namakero, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_namakero) end)
  SkySceneKit.say({english=" We have no motivation at all...", french="Nous, on n'a jamais aucune\nmotivation pour quoi que ce soit...", german="Wir haben überhaupt keine\nMotivation.", italian="Non abbiamo alcuna\nmotivazione...", spanish=" No tenemos ninguna motivación..."})
  pcall(function() UI:SetSpeaker(npc_npc_namakero) end)
  SkySceneKit.say({english="Why did we even bother forming\nan exploration team...?", french="Franchement, je me demande\nmême pourquoi on s'est fatigués à monter\nune équipe d'exploration...", german="Warum haben wir überhaupt ein\nErkundungsteam gegründet?", italian="Perché ci siamo persino\ndisturbati a formare una squadra\nd'esplorazione...?", spanish="Me pregunto para qué nos\nmolestamos siquiera en formar un equipo\nexplorador."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 1] || scn($SCENARIO_MAIN) >= [6, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_namakero, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_namakero) end)
  SkySceneKit.say({english=" Exploring is...[K]too much effort.", french="Raaagh... L'exploration... [K]c'est\ntrop d'efforts, trop fatigant.", german=" Erkunden ist[K] zu anstrengend.", italian=" Esplorare è...[K] troppo faticoso.", spanish="Explorar supone...[K] demasiado\nesfuerzo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [5, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
