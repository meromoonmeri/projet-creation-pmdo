-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/us2207.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_poniita = SkySceneKit.spawn_npc("ponyta", 384, 288, Direction.DownLeft, "NPC_PONIITA")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_poniita, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_poniita) end)
  SkySceneKit.say({english="Another great accomplishment\nfor Team [team:]!", french="Un exploit supplémentaire à\nl'actif de l'Equipe [team:]!", german="Eine weitere tolle\nErrungenschaft für Team [team:]!", italian="Un altro grande risultato per il\nTeam [team:]!", spanish="¡Otro gran logro del [CS:X]Equipo[CR]\n[team:]!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_poniita, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_poniita) end)
  SkySceneKit.say({english="Team [CS:X]Raider[CR] is another team\nthat would be fantastic to meet.", french="Ce serait tout aussi fantastique\nde rencontrer l'Equipe [CS:X]As[CR].", german="Team [CS:X]Schatzsucher[CR] ist auch ein\nTeam, das wir unheimlich gerne einmal\nkennenlernen würden.", italian="Sarebbe fantastico anche\nincontrare il Team [CS:X]Asso[CR].", spanish="También sería genial conocer al\n[CS:X]Equipo As[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_poniita) end)
  SkySceneKit.say({english="They must be incredibly cool\nin person...", french="C'est sûrement l'équipe la plus\nclasse du monde...", german="So von Angesicht zu Angesicht\nmüssen die ziemlich cool sein.", italian=" Devono essere fantastici...", spanish="Seguro que son Pokémon\nincreíbles..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_poniita, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_poniita) end)
  SkySceneKit.say({english=" Oh, Team [CS:X]Charm[CR] was here...?", french="Oh, l'Equipe [CS:X]Charme[CR] est venue\nici...?", german=" Oh, Team [CS:X]Charme[CR] war hier?", italian=" Ah, il Team [CS:X]Malia[CR] è stato qui?", spanish="Oh, ¿el [CS:X]Equipo Carisma[CR] ha estado\naquí?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_poniita, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_poniita) end)
  SkySceneKit.say({english="You've stopped the planet's\nparalysis?!", french="Vous avez empêché la Paralysie\nde la Planète?!", german="Ihr habt die Lähmung des\nPlaneten aufgehalten?!?", italian="Avete evitato la paralisi del\npianeta?!", spanish="¡¿Habéis detenido la parálisis\ndel planeta?!"})
  pcall(function() UI:SetSpeaker(npc_npc_poniita) end)
  SkySceneKit.say({english=" H-how incredible! Thank you!", french=" C'est incroyable! Merci!", german=" W-wie unglaublich! Danke!", italian=" I-incredibile! Grazie!", spanish=" ¡Es increíble! ¡Muchas gracias!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_poniita, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_poniita) end)
  SkySceneKit.say({english=" It isn't over yet! Good luck!", french="Rien n'est encore perdu!\nBonne chance!", german="Es ist noch nicht vorbei!\nViel Glück!", italian="Non è ancora finita! Buona\nfortuna!", spanish="¡Esto aún no ha acabado! ¡Buena\nsuerte!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_poniita, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_poniita) end)
  SkySceneKit.say({english="The planet's paralysis can't be\nallowed to happen!", french="Il faut absolument empêcher\nla Paralysie de la Planète de se produire!", german="Die Lähmung des Planeten muss\nabgewendet werden!", italian="Non possiamo permettere che il\npianeta si paralizzi!", spanish="¡No podemos permitir que\nparalice el planeta!"})
  pcall(function() UI:SetSpeaker(npc_npc_poniita) end)
  SkySceneKit.say({english=" That [CS:N]Grovyle[CR] must be caught!", french=" Il faut capturer ce [CS:N]Massko[CR]!", german="Dieser [CS:N]Reptain[CR] muss geschnappt\nwerden!", italian="Quel [CS:N]Grovyle[CR] dev'essere\ncatturato!", spanish=" ¡Hay que coger a ese [CS:N]Grovyle[CR]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_poniita, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_poniita) end)
  SkySceneKit.say({english="So, everyone is saying that\n[CS:N]Grovyle[CR] has appeared again!", french="Il paraît que [CS:N]Massko[CR] a encore\nfrappé.", german="Es ist also in aller Munde, dass\n[CS:N]Reptain[CR] wieder aufgetaucht ist.", italian="Dicono che [CS:N]Grovyle[CR] sia\nricomparso.", spanish="¡Así que todos dicen que [CS:N]Grovyle[CR]\nha reaparecido!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 1] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_poniita, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_poniita) end)
  SkySceneKit.say({english=" We've heard...", french=" On a appris la nouvelle...", german=" Wir haben gehört...", italian=" Abbiamo saputo...", spanish=" Hemos oído que..."})
  pcall(function() UI:SetSpeaker(npc_npc_poniita) end)
  SkySceneKit.say({english="They've identified the thief who\nhas been stealing the Time Gears?", french="Ils ont identifié le voleur qui a\nsubtilisé les Rouages du Temps?", german="Sie haben den Dieb identifiziert,\nder die Zahnräder der Zeit gestohlen hat?", italian="... che hanno identificato il ladro\nche ha rubato gli Ingranaggi del Tempo.", spanish="¿Han identificado al ladrón que\nha estado robando los Engranajes del Tiempo?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [13, 2] || scn($SCENARIO_MAIN) >= [13
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_poniita, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_poniita) end)
  SkySceneKit.say({english="Our leader is always nervous\naround fire.[K] But that's a small thing compared\nto all the positives!", french="A cause du feu, notre meneur\npanique... [K]mais ses qualités l'emportent\nde loin sur ce seul défaut.", german="Unser Anführer ist nervös,\nwenn Feuer im Spiel ist.[K] Aber die Vorteile\nüberwiegen die Nachteile.", italian="Il nostro leader diventa nervoso\nquando vede il fuoco...[K] Ma ha tanti\naltri aspetti positivi.", spanish="Nuestro líder siempre se pone\nmuy nervioso cuando hay fuego cerca.[K]\n¡Pero no lo cambiaríamos por nada!"})
  pcall(function() UI:SetSpeaker(npc_npc_poniita) end)
  SkySceneKit.say({english="So I'm happy to support our\nleader through thick or thin.", french="Alors je me réjouis de soutenir\nnotre meneur contre vents et marées.", german="Daher bin ich glücklich, unserem\nAnführer durch dick und dünn zu folgen.", italian="Io sosterrò sempre il leader,\nnella buona e nella cattiva sorte!", spanish="¡Eso es una nimiedad al lado de\ntodos sus méritos!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [5, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
