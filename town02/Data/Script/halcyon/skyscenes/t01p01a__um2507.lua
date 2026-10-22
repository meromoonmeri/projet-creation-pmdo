-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/um2507.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_bakuuda = SkySceneKit.spawn_npc("camerupt", 296, 256, Direction.DownRight, "NPC_BAKUUDA")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bakuuda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bakuuda) end)
  SkySceneKit.say({english=" Thank you, Team [team:]!", french="Merci à vous, l'Equipe\n[team:]!", german=" Danke, Team [team:]!", italian=" Grazie, Team [team:]!", spanish=" ¡Gracias, [CS:X]Equipo[CR] [team:]!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bakuuda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bakuuda) end)
  SkySceneKit.say({english="There are exploration teams\neven more famous than Team [CS:X]Charm[CR].", french="Il existe des équipes\nd'exploration plus célèbres encore que\nl'Equipe [CS:X]Charme[CR].", german="Es gibt Erkundungsteams, die\nnoch berühmter sind als Team [CS:X]Charme[CR].", italian="Ci sono anche squadre\nd'esplorazione più famose del Team [CS:X]Malia[CR].", spanish="Hay equipos de exploración más\nfamosos incluso que el [CS:X]Equipo Carisma[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_bakuuda) end)
  SkySceneKit.say({english="The most famous would have to\nbe Team [CS:X]Raider[CR].", french="L'Equipe [CS:X]As[CR] est sans\ndoute la plus célèbre de toutes.", german="Das berühmteste ist wohl\nTeam [CS:X]Schatzsucher[CR].", italian="La squadra più famosa dovrebbe\nessere il Team [CS:X]Asso[CR].", spanish="El equipo más famoso debe de\nser el [CS:X]Equipo As[CR]."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bakuuda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bakuuda) end)
  SkySceneKit.say({english=" You did it! That's wonderful!", french=" Formidable! Vous avez réussi!", german="Ihr habt es geschafft. Das ist\nwundervoll!", italian=" Ce l'avete fatta! È magnifico!", spanish=" ¡Lo lograsteis! ¡Maravilloso!"})
  pcall(function() UI:SetSpeaker(npc_npc_bakuuda) end)
  SkySceneKit.say({english=" Thank you so much!", french=" Merci mille fois!", german=" Habt vielen Dank!", italian=" Grazie mille!", spanish=" ¡Muchas gracias!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bakuuda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bakuuda) end)
  SkySceneKit.say({english=" Your team won't fail! Go for it!", french=" Votre équipe vaincra! Foncez!", german="Euer Team wird nicht verlieren!\nVorwärts!", italian=" Ce la farete! Forza!", spanish="¡Vuestro equipo no puede perder!\n¡A por él!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bakuuda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bakuuda) end)
  SkySceneKit.say({english=" [CS:N]Grovyle[CR] is a Grass type, I hear.", french="[CS:N]Massko[CR] est un Pokémon\nde type Plante, à ce qu'il paraît.", german="[CS:N]Reptain[CR] ist ein\nPflanzen-Pokémon, wie ich gehört habe.", italian="[CS:N]Grovyle[CR], da quel che ho sentito,\nè di tipo Erba.", spanish="Según dicen, [CS:N]Grovyle[CR] es de tipo\nPlanta."})
  pcall(function() UI:SetSpeaker(npc_npc_bakuuda) end)
  SkySceneKit.say({english="Though he's said to be very\nskilled...[K]our attacks are mostly fire based!", french="Même s'il est aussi fort\nqu'on le dit...[K] la plupart de nos attaques\nsont de type Feu!", german="Er soll ja sehr erfahren sein...[K]\nDafür basieren die meisten unserer Attacken\nauf Feuer!", italian="Nonostante dicano sia così\nscaltro...[K] i nostri attacchi si basano\nprincipalmente sul fuoco!", spanish="Nuestros ataques son sobre todo\nde tipo Fuego...[K] Así que, por muy hábil que\nsea..."})
  pcall(function() UI:SetSpeaker(npc_npc_bakuuda) end)
  SkySceneKit.say({english="So I think we'd be more than a\nmatch for him. At least as far as our types\nare concerned!", french="Alors, je pense qu'on serait\ndes adversaires redoutables pour lui.\nAu moins du point de vue de nos types!", german="Ich glaube also, dass wir ihm\ndurchaus ebenbürtig wären. Zumindest was\ndie Typen betrifft!", italian="Non gli renderemo certo la vita\nfacile.", spanish="Creo que, como rivales, damos\nla talla... Al menos en cuanto a tipo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bakuuda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bakuuda) end)
  SkySceneKit.say({english="I've heard even the great\n[CS:N]Dusknoir[CR] himself is tracking [CS:N]Grovyle[CR].", french="Il paraît que le grand [CS:N]Noctunoir[CR]\nlui-même est à la poursuite de [CS:N]Massko[CR].", german="Ich habe gehört, dass sogar der\ngroße [CS:N]Zwirrfinst[CR] selbst auf der Suche nach\n[CS:N]Reptain[CR] ist.", italian="Ho sentito pure che sulle tracce\ndi [CS:N]Grovyle[CR] si è messo il grande [CS:N]Dusknoir[CR]\nin persona.", spanish="También se rumorea que el gran\n[CS:N]Dusknoir[CR] en persona está buscándolo."})
  pcall(function() UI:SetSpeaker(npc_npc_bakuuda) end)
  SkySceneKit.say({english="But so far, the thief has eluded\nthem all. He must be good.", french="Mais pour l'instant, le voleur\nréussit toujours à lui filer entre les doigts.\nIl doit être très fort, à mon avis.", german="Aber bisher ist der Dieb allen\nentkommen. Er muss also gut sein.", italian="Ma il ladro dev'essere molto\nabile, se è riuscito a sfuggire a tutti finora.", spanish="Pero, de momento, el ladrón ha\nlogrado escapar. Debe de ser muy hábil."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 1] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bakuuda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bakuuda) end)
  SkySceneKit.say({english="I've heard that the thief stealing\nthe Time Gears is named [CS:N]Grovyle[CR].", french="J'ai entendu dire que le voleur\nqui fait main basse sur les Rouages du Temps\ns'appelle [CS:N]Massko[CR].", german="Ich habe gehört, dass der Dieb,\nder die Zahnräder der Zeit stiehlt, [CS:N]Reptain[CR]\nheißt.", italian="Ho sentito che il ladro degli\nIngranaggi del Tempo si chiama [CS:N]Grovyle[CR].", spanish="He oído que el ladrón de los\nEngranajes del Tiempo se llama [CS:N]Grovyle[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_bakuuda) end)
  SkySceneKit.say({english="Hmm... Can't say that I've heard\nof him.", french="Hmmm... Je ne crois pas en\navoir entendu parler auparavant.", german="Hmm... Kann nicht behaupten,\nvorher schon einmal von ihm gehört zu haben.", italian="Mmm... Questo nome non mi è\nfamiliare.", spanish="Aunque tampoco es que se sepa\nmucho de él."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [13, 2] || scn($SCENARIO_MAIN) >= [13
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bakuuda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bakuuda) end)
  SkySceneKit.say({english="[CS:N]Ponyta[CR] and I are great at using\nfire-based attacks, as you can imagine. But...", french="Comme vous vous en doutez,\nles attaques de type Feu n'ont pas de secret\npour [CS:N]Ponyta[CR] et moi. Mais...", german="[CS:N]Ponita[CR] und ich sind gut, wenn es\num das Verwenden von Feuer-Attacken geht,\nwie du dir vorstellen kannst. Aber...", italian="Come potrai immaginare, [CS:N]Ponyta[CR]\ne io siamo maestre negli attacchi di tipo Fuoco.\nMa...", spanish="[CS:N]Ponyta[CR] y yo usamos con gran\ndestreza ataques de tipo Fuego, pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_bakuuda) end)
  SkySceneKit.say({english="We leave swirling fire in our\nwake as we fight...[K]and that scares our leader.", french="On laisse des tourbillons de feu\ndans notre sillage...[K] et cela effraie\nnotre meneur.", german="Wir lassen Feuerwirbel an\nunseren Kampfschauplätzen zurück...[K] Und das\nmacht unserem Anführer Angst.", italian="Ci lasciamo alle spalle un turbine\ndi fuoco quando lottiamo...[K] e il nostro leader\nsi spaventa.", spanish="Al luchar dejamos una estela...[K]\nque asusta bastante a nuestro líder."})
  pcall(function() UI:SetSpeaker(npc_npc_bakuuda) end)
  SkySceneKit.say({english="I think our leader has lost\nconfidence because of this...[K] But I don't know\nwhat we can do about it.", french="Je crois que c'est pour ça que\nnotre meneur a perdu confiance en lui...[K]\nMais je ne vois pas ce qu'on peut y faire...", german="Ich glaube, unser Anführer hat\ndeshalb das Vertrauen verloren...[K] Ich bin mir\nnicht sicher, was wir dagegen tun können.", italian="Penso che il nostro leader abbia\nperso sicurezza...[K] Ma cosa ci possiamo\nfare?", spanish="Me temo que nuestro líder ha\nperdido la confianza...[K] pero no sé qué\npodemos hacer al respecto."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [5, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
