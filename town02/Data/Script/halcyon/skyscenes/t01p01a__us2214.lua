-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/us2214.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_kemusso = SkySceneKit.spawn_npc("wurmple", 216, 200, Direction.Right, "NPC_KEMUSSO")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kemusso, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="I'm ashamed that I doubted my\nleader even a little...", french="J'ai honte d'avoir osé douter\nde mon meneur, ne serait-ce qu'un seul\ninstant...", german="Ich bin beschämt, dass ich auch\nnur geringfügig an meinem Anführer\ngezweifelt habe.", italian="Mi vergogno di aver dubitato\nanche solo per un attimo del mio leader...", spanish="Me avergüenzo de haber dudado\nde mi líder..."})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english=" But I'm glad I had the guts to.", french="Mais je suis heureux d'avoir eu\nle courage de lui parler.", german="Aber andererseits bin ich froh,\ndass ich genug Mumm hatte, ihn zu fragen.", italian="Ma sono contento di aver avuto\nil coraggio di parlargli.", spanish="Pero me alegro de haber tenido\nlas agallas de preguntarle."})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="You helped me be brave,\n[hero].", french="C'est toi qui m'as aidé à faire\npreuve de courage, [hero].", german="Du hast mir geholfen, tapfer zu\nsein, [hero].", italian="Mi hai aiutato a fare questo\npasso, [hero].", spanish="Tú me ayudaste a ser valiente,\n[hero]."})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english=" Thank you so much!", french=" Je te remercie du fond du cœur!", german=" Vielen Dank!", italian=" Grazie mille!", spanish=" ¡Muchas gracias!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- SetAnimation(2) [anim idle native]
  local npc_npc_oosubame = SkySceneKit.spawn_npc("swellow", 376, 248, Direction.Up, "NPC_OOSUBAME")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_oosubame, 4) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_kemusso, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="Eep...[K] Thank you, [CS:N]Swellow[CR]...\nYou are my one and only leader...", french="Ah...[K] Merci, [CS:N]Hélédelle[CR]...\nTu es mon seul et unique meneur...", german="Urgs...[K] Danke, [CS:N]Schwalboss[CR]. Dich\nund nur dich betrachte ich als meinen\nAnführer...", italian="Eeh...[K] Grazie, [CS:N]Swellow[CR]...\nSei il mio solo e unico leader...", spanish="Ay...[K] Gracias, [CS:N]Swellow[CR]... Eres mi\nlíder..."})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english=" I'm very...[K] So very h-h-happy...", french=" Je suis si...[K] Si c-c-content...", german="Ich bin so...[K] so unglaublich\nglücklich!", italian="Sono molto...[K] Davvero molto\nf-f-felice...", spanish=" Estoy tan...[K] ¡tan feliz!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kemusso, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="...[K]I see...[K] That little [CS:N]Manaphy[CR]\nhad to go back to the sea.", french="... [K]Je vois...[K] Le petit [CS:N]Manaphy[CR]\ndevait retourner à la mer.", german="...[K]Verstehe.[K] Das kleine [CS:N]Manaphy[CR]\nmusste ins Meer zurückkehren.", italian="...[K] Capisco...[K] Quel piccolo\n[CS:N]Manaphy[CR] doveva tornare nel mare.", spanish="Vaya...[K] Entiendo...[K] El pequeño\n[CS:N]Manaphy[CR] tenía que regresar al mar."})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="The way you feel about little\n[CS:N]Manaphy[CR], [hero]...[K] I feel your pain.", french="Je comprends ce que tu ressens\nvis-à-vis de [CS:N]Manaphy[CR], [hero]...[K]\nJe comprends ta douleur.", german="Was du für das kleine [CS:N]Manaphy[CR]\nempfindest, [hero]...[K] Ich kann deinen\nSchmerz nachvollziehen.", italian="Eh sì, [hero]...[K]\nCapisco la tua preoccupazione per quel\ncucciolo...", spanish="Entiendo cómo te sientes por\n[CS:N]Manaphy[CR], [hero]...[K] Comprendo tu\npesar."})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="Well...[K][hero] and\n[partner]...", french="Eh bien... [K][hero] et\n[partner]...", german="Nun...[K] [hero] und\n[partner]...", italian="Bene...[K] [hero] e\n[partner]...", spanish="Bueno...[K] [hero] y\n[partner]..."})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="I've decided.[K] I'm going to work\nup my courage and ask my leader how he thinks\nof me.", french="Ma décision est prise.[K] Je vais\nprendre mon courage à deux mains et\ndemander à mon meneur ce qu'il pense de moi.", german="Ich habe mich entschieden.[K] Ich\nwerde meinen Mut zusammennehmen und\nmeinen Anführer fragen, was er von mir hält.", italian="Ho deciso.[K] Ho deciso di farmi\ncoraggio e di chiedere al mio leader cosa pensa\ndi me.", spanish="He tomado una decisión.[K] Voy a\narmarme de valor y preguntarle a mi líder a\nver qué opina de mí."})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="I don't know if my leader only\nviews me as food...[K] But...", french="Je ne sais pas si mon meneur\nme considère comme de la nourriture... [K]Mais...", german="Ich habe keine Ahnung, ob mich\nmein Anführer lediglich als Futter ansieht...[K]\nAber...", italian="Non so se il mio leader mi veda\nsolo come un bocconcino appetitoso...[K] Ma...", spanish="No sé si solo pensará en mí\ncomo en comida...[K] pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="It makes no difference in how\nmuch I trust him as leader.", french="Ça ne change rien au fait que\nje lui fais confiance en tant que meneur.", german="Mein Vertrauen in ihn als\nAnführer bleibt davon jedenfalls unberührt.", italian="Qualsiasi cosa succeda,\ncontinuerò a considerarlo il mio leader.", spanish="Eso no afecta a la confianza que\ntengo depositada en él como líder."})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="Thank you, [hero] and\n[partner].", french="Merci, [hero] et\n[partner].", german="Danke, [hero] und\n[partner].", italian="Grazie, [hero] e\n[partner].", spanish="Gracias, [hero] y\n[partner]."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 50] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kemusso, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="You've found [CS:N]Manaphy[CR]!\nHow splendid!", french="Vous avez retrouvé [CS:N]Manaphy[CR]!\nFormidable!", german="Ihr habt [CS:N]Manaphy[CR] gefunden!\nWunderbar!", italian="Avete trovato [CS:N]Manaphy[CR]!\nSplendido!", spanish="¡Habéis encontrado a [CS:N]Manaphy[CR]!\n¡Estupendo!"})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="...[K]Oh?[K] Oh no![K] The baby's taken\nsick now?", french="... [K]Ah bon?[K] Oh non![K] Il est\ntombé malade, le pauvre petit?", german="...[K]Oh?[K] Oh nein![K] Das Kleine ist\nkrank geworden?", italian="...[K] Eh?[K] Oh no![K] Ora il\nmarmocchio si è ammalato?", spanish="¿Eh?[K] ¿De verdad?[K] ¡Oh, no![K]\n¿Ahora vuestro pequeño ha enfermado?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 48] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kemusso, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="Oh no![K] That cute [CS:N]Manaphy[CR]'s\ngone missing?!", french="Oh non?![K] Le petit [CS:N]Manaphy[CR]\na disparu?!", german="Oh nein![K] Das süße [CS:N]Manaphy[CR]\nist verschwunden?!?", italian="Oh no?![K] Quel piccolo [CS:N]Manaphy[CR] è\nsparito?!", spanish="¡Oh, no![K] ¿Ha desaparecido\n[CS:N]Manaphy[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english=" Th-that is worrisome...", french=" G-g-gloups! C-c'est inquiétant...", german=" D-das ist besorgniserregend...", italian=" È-È inquietante...", spanish=" Pues es preocupante..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 46) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 46]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kemusso, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english=" What...what a little cutie...", french=" Oooh... comme il est mignon...", german="Was... Was für ein süßer\nKleiner...", italian=" Che... Che bel marmocchio...", spanish=" ¡Qué monada!"})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="[CS:N]Manaphy[CR] is his name? Such a\ncute little fellow.", french="Il s'appelle [CS:N]Manaphy[CR]? Il est\nmignon tout plein, ce petit gars.", german="[CS:N]Manaphy[CR] ist sein Name? So ein\nsüßes kleines Kerlchen.", italian="Si chiama [CS:N]Manaphy[CR]? È proprio\nun bel piccino.", spanish="¿Se llama [CS:N]Manaphy[CR]? ¡Qué\nmonada!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 45] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kemusso, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english=" Eep! I can't decide what to do...", french="Gloups! Je ne sais pas quoi\nfaire...", german="Urgs! Ich kann mich nicht\nentscheiden, was ich tun soll...", italian="Eeh! Non riesco a decidere cosa\nfare...", spanish=" ¡Ay! No sé qué hacer..."})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="Our team leader, [CS:N]Swellow[CR]...[K]\nDo you suppose he thinks of me as food?", french="Le meneur, [CS:N]Hélédelle[CR]...[K]\nVous croyez qu'il me voit comme de la\nnourriture?", german="Der Anführer unseres Teams,\n[CS:N]Schwalboss[CR]...[K]\nGlaubst du, er hält mich für Futter?", italian="Il mio leader [CS:N]Swellow[CR]...[K]\nSecondo voi pensa a me come a uno spuntino?", spanish="Nuestro líder, [CS:N]Swellow[CR]...[K]\n¿Pensará en mí como su comida?"})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="I want to believe in my leader,\nbut...[K] Y-y-yeesh...", french="Je fais de mon mieux pour\navoir confiance en mon meneur, mais...[K]\ngloups, quoi...", german="Ich will meinem Anführer\nvertrauen, aber...[K] W-w-waaaaah...", italian="Voglio credere nel mio leader,\nma...[K] G-G-Già...", spanish="Quiero confiar en mi líder,\npero...[K] Uf..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 41] || scn($SCENARIO_MAIN) >= [2
  -- @label_66 [étiquette de flux ExplorerScript]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kemusso, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english=" Eep! Y-y-yeesh...", french=" Gloups! Pauvre de moi...", german=" Urgs! W-w-waaaaah...", italian=" Eeh! G-G-Già...", spanish=" ¡Aaay! ¡Sí!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 30] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kemusso, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="Huh? Why is it so empty\nin here?", french="Bah? Pourquoi est-ce que\nc'est tellement désert ici?", german="Huch? Warum ist es hier\ndrinnen so leer?", italian="Uh? Perché questo posto è così\nvuoto?", spanish="¿Eh? ¿Por qué está tan\nvacío esto?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 8] || scn($SCENARIO_MAIN) >= [29
  -- jump @label_66 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 4] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kemusso, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="Good luck! And please\nbe careful!", french="Bonne chance! Et faites\nattention à vous!", german="Viel Glück! Und seid bitte\nvorsichtig!", italian="Buona fortuna! E mi raccomando,\nfate attenzione!", spanish="¡Buena suerte! ¡Y tened mucho\ncuidado!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kemusso, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="If the great [CS:N]Dusknoir[CR] and\n[CS:N]Grovyle[CR] were to fight...[K]I would think the battle\nwould be a high-level one.", french="Si l'illustre [CS:N]Noctunoir[CR] et\nce [CS:N]Massko[CR] s'affrontaient...[K] je crois que\nle combat serait de très haut niveau.", german="Würden der große [CS:N]Zwirrfinst[CR]\nund [CS:N]Reptain[CR] kämpfen...[K] Ich denke, das wäre\nein hochkarätiger Kampf.", italian="Se il grande [CS:N]Dusknoir[CR] e [CS:N]Grovyle[CR]\nsi dovessero scontrare...[K] Penso sarebbe una\nlotta di alto livello.", spanish="Si el gran [CS:N]Dusknoir[CR] y [CS:N]Grovyle[CR]\nse enfrentaran...[K] sería todo un combate."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 1] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kemusso, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english=" We want to help too.", french=" Moi aussi, je veux aider!", german=" Wir wollen auch helfen.", italian=" Vogliamo renderci utili.", spanish=" Nos gustaría ser de ayuda."})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="If we hear anything about\n[CS:N]Grovyle[CR], we'll let you know.", french="Si on apprend quoi que ce\nsoit au sujet de [CS:N]Massko[CR], on vous tiendra\nau courant.", german="Falls wir etwas über [CS:N]Reptain[CR]\nhören, lassen wir es euch wissen.", italian="Appena sentiamo qualcosa su\n[CS:N]Grovyle[CR], ve lo diciamo.", spanish="Si nos enteramos de algo sobre\n[CS:N]Grovyle[CR], os lo haremos saber."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 4] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kemusso, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="Did you know that there are\ndifferent kinds of [CS:I]Prize Tickets[CR]?", french="Tu savais qu'il y a différentes\nsortes de [CS:I]Tickets Magot[CR]?", german="Wusstest du, dass es mehrere\nSorten [CS:I]Preistickets[CR] gibt?", italian="Lo sapevi che ci sono diversi tipi\ndi [CS:I]Buoni Premio[CR]?", spanish="¿Sabías que hay tipos diferentes\nde [CS:I]boletos[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="It seems that you can win\ndifferent prizes with different tickets.", french="Apparemment, les lots varient\nen fonction des tickets.", german="Anscheinend gewinnst du mit\nunterschiedlichen Tickets auch unterschiedliche\nPreise.", italian="Pare che in base al buono si\npossano vincere premi diversi.", spanish="Parece que puedes ganar premios\ndiferentes según cuál tengas."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 4] || scn($SCENARIO_MAIN) >= [12
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kemusso, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english=" Hey, [CS:N]Wurmple[CR]!", french=" Hé, [CS:N]Chenipotte[CR]!", german=" Hey, [CS:N]Waumpel[CR]!", italian=" Ehi, [CS:N]Wurmple[CR]!", spanish=" ¡Oye, [CS:N]Wurmple[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english=" Y-yes?", french=" O-oui?", german=" J-ja?", italian=" S-sì?", spanish=" ¿Sí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english=" The weather's good today.", french=" Il fait beau aujourd'hui.", german=" Das Wetter ist schön heute.", italian=" Oggi è una bella giornata.", spanish=" Hoy hace buen tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="On nice days like this...[K] I really\nwork up an appetite!", french="Un temps pareil...[K] Ça m'ouvre\nl'appétit! Et quand l'appétit va, tout va!", german="An schönen Tagen wie diesem[K]\nbekomme ich immer ganz schön Hunger!", italian="In giornate come questa...[K]\nMi viene davvero un grande appetito!", spanish="En días así...[K] ¡se me abre el\napetito!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kemusso, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english=" Huh?[K] Really?![K] Eeep! Y-y-yeesh!", french="Ah... [K]Ah bon? Vraiment?![K]\nGloups... pauvre de moi...", german="Wie?[K] Ehrlich?!?[K] Urgs!\nW-w-waaaaah!", italian="Uh?[K] Davvero?![K] Eeeh!\nG-g-già!", spanish=" ¿Eh?[K] ¿Ah, sí?[K] ¡Aaaay!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 7]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kemusso, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="The jobs on the boards range\nfrom easy to difficult.", french="Les missions du Tableau des\nMissions sont classées par niveau de\ndifficulté.", german="Die Jobs auf den Infobrettern\nreichen von leicht bis schwierig.", italian="Le missioni in Bacheca possono\nessere più o meno facili.", spanish="Las misiones de los tablones se\nordenan según la dificultad: de fácil a difícil."})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="The easiest jobs are marked\nwith the letter \"E.\"", french="Les plus faciles portent la\nlettre \"E\".", german="Die leichtesten Jobs sind mit\ndem Buchstaben E gekennzeichnet.", italian="Le missioni più facili sono\nindicate dalla lettera \"E\".", spanish="Los trabajos más sencillos\nestán marcados con la letra \"E\"."})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="The jobs get progressively\ndifficult from \"[CS:I]D[CR:0]\" to \"[CS:K]C[CR:0]\" and so on.", french="Et la difficulté augmente\nprogressivement avec la lettre: \"[CS:I]D[CR:0]\" puis \"[CS:K]C[CR:0]\",\netc.", german="Die Jobs werden zunehmend\nschwieriger von [CS:I]D[CR:0] bis [CS:K]C[CR:0] usw.", italian="Poi aumentano progressivamente\ndi difficoltà e sono contraddistinte da una \"[CS:I]D[CR:0]\",\nuna \"[CS:K]C[CR:0]\" e così via.", spanish="Las misiones van aumentando de\ndificultad de \"[CS:I]D[CR:0]\" a \"[CS:K]C[CR:0]\", etc."})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="If you're just starting out and\nyou're unsure of your skills, you should start\nwith the easiest jobs rated \"E.\"", french="Si vous débutez et doutez de\nvos capacités, commencez avec les missions\nles plus faciles, qui portent la lettre \"E\".", german="Wenn du gerade anfängst und dir\ndeiner Fähigkeiten noch nicht sicher bist,\nbeginne Jobs, die mit E markiert sind.", italian="Se sei all'inizio e non sai bene\ncosa sei in grado di fare, dovresti iniziare\ncon le missioni più facili, quelle di tipo \"E\".", spanish="Si acabas de llegar y aún no has\ndesarrollado muy bien tus habilidades, sería\nmejor empezar por las marcadas con la \"E\"."})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english=" Pardon?[K] Me?", french=" Pardon?[K] Moi?", german=" Bitte?[K] Ich?", italian=" Chiedo scusa?[K] Io?", spanish=" ¿Cómo?[K] ¿Yo?"})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="I'd never choose a hard job rated\n\"[CS:K]C[CR:0]\" or anything like that![K] Y-y-yeesh!", french="Jamais je ne me risquerai à\nchoisir une mission classée \"[CS:K]C[CR:0]\" ou plus![K]\nGloups!", german="Ich würde niemals einen\nschwierigen Job mit der Bewertung [CS:K]C[CR:0]\nauswählen![K] W-w-waaaaah!", italian="Io non ho mai scelto una\nmissione di livello \"[CS:K]C[CR:0]\"![K] G-G-Già...!", spanish="Nunca he escogido una misión\nmarcada con una \"[CS:K]C[CR:0]\" ni nada por el estilo.[K]\n¡Qué va!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kemusso, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="Excuse me? Why did I pick the\nname Team [CS:X]Tasty[CR]?", french="Pardon? Pourquoi j'ai choisi le\nnom [CS:X]Miam-Miam[CR] pour mon équipe?", german="Wie bitte? Warum ich den\nNamen Team [CS:X]Schmackhaft[CR] gewählt habe?", italian="Come? Perché ho scelto il nome\nTeam [CS:X]Mangio[CR]?", spanish="¿Perdona? ¿Que por qué le\nllamé [CS:X]Equipo Sabroso[CR] a mi equipo?"})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english=" Well...[K] Er, um...", french=" Eh bien...[K] Heu, hum hum...", german=" Nun...[K] Ähem, ööööööh...", italian=" Beh...[K] Ecco, ehm...", spanish=" Bueno...[K] Eh..."})
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kemusso, npc_npc_oosubame, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kemusso, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kemusso, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="I think that's how my partner\nwill think of me eventually...[K] Y-y-yeesh...", french="Ben je crois que c'est ce que\nmon partenaire finira par se dire en\nme regardant...[K] Gloups...", german="Ich glaube, dass es das ist,\nwofür mich mein Partner schlussendlich hält.[K]\nW-w-waaaaah...", italian="Beh, il mio compagno pensa solo\na quello quando mi guarda...[K] G-G-Già...", spanish="Creo que eso acabará opinando\nde mí mi acompañante...[K] Eso me temo..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 0] || scn($SCENARIO_MAIN) >= [3, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
