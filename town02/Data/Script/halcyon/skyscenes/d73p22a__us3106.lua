-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P22A/us3106.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_tamatama = SkySceneKit.spawn_npc("exeggcute", 312, 272, Direction.Down, "NPC_TAMATAMA")
  pcall(function() UI:SetSpeaker(npc_npc_tamatama) end)
  SkySceneKit.say({english="We're always here as support\nfor the explorers climbing to the top of\n[CS:P]Sky Peak[CR]! Yes, we are!", french="Nous sommes toujours là, oui\nnous le sommes, pour soutenir les explorateurs\nqui escaladent le [CS:P]Pic Céleste[CR] jusqu'au sommet!", german="Ich bin allzeit bereit, die\nErkunder bei der Besteigung des [CS:P]Himmelsgipfels[CR]\nzu unterstützen! Ja, das bin ich!", italian="Siamo sempre qui per aiutare\ngli esploratori che vogliono raggiungere la cima\ndel [CS:P]Picco del Cielo[CR]! Oh sì che ci siamo!", spanish="Siempre estamos aquí para\nayudar a los exploradores que ascienden\na la cima de la [CS:P]Cumbre del Cielo[CR]. ¡Sí, sí!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 39] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_tamatama) end)
  SkySceneKit.say({english="Congratulations on making it to\nthe summit safely!", french="Nous vous félicitons d'avoir\natteint le sommet sans trop de dégâts!", german="Herzlichen Glückwunsch zur\nerfolgreichen Besteigung des Gipfels!", italian="Congratulazioni per aver\nraggiunto la vetta!", spanish="¡Enhorabuena por llegar a salvo\na la cima!"})
  pcall(function() UI:SetSpeaker(npc_npc_tamatama) end)
  SkySceneKit.say({english="Your achievement made our\nsupport well worth it!", french="Votre réussite justifie\nnotre rôle d'équipe de soutien!", german="Dein Erfolg adelt unsere\nBemühungen!", italian="La vostra impresa rende onore\nai nostri sforzi!", spanish="¡Un logro así hace que haya\nvalido la pena ayudar!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 30] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_tamatama) end)
  SkySceneKit.say({english="We've set up a base at\nthe 6th Station Clearing.", french="Il y a un dernier campement\nà la trouée du 6[F:E] Relais.", german="Wir haben eine Basis auf der\n6. Zwischenlagerlichtung errichtet.", italian="Abbiamo creato un campo base\nal Bivacco 6.", spanish="Hemos levantado un campamento\nen la Base del Sexto Puerto."})
  pcall(function() UI:SetSpeaker(npc_npc_tamatama) end)
  SkySceneKit.say({english="But above the 6th Station\nClearing, the road gets too steep for us to\nset up any bases.", french="Mais au-delà de la trouée\ndu 6[F:E] Relais, la route devient trop escarpée.", german="Aber der Weg wird zu steil\noberhalb der 6. Zwischenlagerlichtung, daher\nkönnen wir keine weiteren Basen errichten.", italian="Ma oltre quel punto il sentiero\nè troppo ripido e non ci permette di costruirne\naltri.", spanish="Pero por encima de la Base del\nSexto Puerto el sendero es demasiado\nimpracticable como para levantar una base."})
  pcall(function() UI:SetSpeaker(npc_npc_tamatama) end)
  SkySceneKit.say({english="From there on, you have to rely\non yourself!", french="A partir de ce point,\nil vous faudra compter sur vous-mêmes!", german="Willst du weiter, musst du dich\nauf dich selbst verlassen!", italian="Da là in avanti, dovrete\ncavartela per conto vostro!", spanish="A partir de allí tendrás que\nconfiar en tu pericia."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 22] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_tamatama) end)
  SkySceneKit.say({english="They've set up a base at\nthe 4th Station Clearing.", french="Un campement a été établi\nà la trouée du 4[F:E] Relais.", german="Auf der 4. Zwischenlagerlichtung\nwurde eine Basis errichtet.", italian="Hanno costruito un campo base al\nBivacco 4.", spanish="Han levantado un campamento en\nla Base del Cuarto Puerto."})
  pcall(function() UI:SetSpeaker(npc_npc_tamatama) end)
  SkySceneKit.say({english="You can use the Gondola to climb\nquickly as well.", french="Vous pouvez aussi utiliser\nla Navette pour grimper là-haut plus vite.", german="Mit der Seilbahn kann man\nschnell hinaufkommen.", italian="Puoi anche usare l'Agenzia Viaggi\nper salire velocemente.", spanish="También puedes usar la Góndola\npara ascender rápidamente."})
  pcall(function() UI:SetSpeaker(npc_npc_tamatama) end)
  SkySceneKit.say({english="Feel free to use it if you're\ngetting tired.", french="N'hésitez pas à l'utiliser\nsi vous sentez la fatigue vous envahir.", german="Du kannst sie ohne schlechtes\nGewissen verwenden, solltest du dich müde\nfühlen!", italian="Usala pure se hai bisogno di\ntirare un po' il fiato.", spanish="No dudes en usarla si te\nempiezas a cansar."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 18] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_tamatama) end)
  SkySceneKit.say({english="[CS:N]Breloom[CR] has gone ahead to the\n4th Station Clearing to build a base.", french="[CS:N]Chapignon[CR] est parti devant\njusqu'à la trouée du 4[F:E] Relais\npour établir un campement.", german="[CS:N]Kapilz[CR] ist schon zur\n4. Zwischenlagerlichtung vorausgegangen, um\neine Basis zu errichten.", italian="[CS:N]Breloom[CR] e la sua squadra ci\nhanno preceduti al Bivacco 4 per costruire\nun campo base.", spanish="[CS:N]Breloom[CR] se ha adelantado hasta\nla Base del Cuarto Puerto para levantar\nun campamento."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 14) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 14]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_tamatama) end)
  SkySceneKit.say({english="We're the backup team for\nProject P. Yes, we are!", french="Nous sommes l'équipe de soutien\ndu Projet P. Oui, c'est nous!", german="Wir sind das\nUnterstützungsteam von Projekt P.\nGenau das sind wir!", italian="Siamo la squadra che si occupa\ndel Progetto P. Eh sì, siamo noi!", spanish="Somos el equipo de reserva del\nProyecto P. ¡Eso es lo que somos!"})
  pcall(function() UI:SetSpeaker(npc_npc_tamatama) end)
  SkySceneKit.say({english="We're here as support for\neveryone's explorations!", french="Nous servons ici de soutien\naux explorations de tout un chacun!", german="Wir unterstützen bei Bedarf alle\nanderen Erkundungen!", italian="Siamo qui per offrire il nostro\naiuto a tutti gli esploratori!", spanish="Estamos aquí para ayudar a\nexplorar a quien nos necesite."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 13] || scn($SCENARIO_MAIN) >= [2
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
