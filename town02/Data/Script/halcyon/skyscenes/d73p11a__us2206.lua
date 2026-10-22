-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P11A/us2206.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_sheimi5 = SkySceneKit.spawn_npc("shaymin", 264, 360, Direction.Right, "NPC_SHEIMI5")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sheimi5, 4) end)
  local npc_npc_sheimi = SkySceneKit.spawn_npc("shaymin", 304, 264, Direction.UpLeft, "NPC_SHEIMI")
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Welcome to the [CS:P]Shaymin Village[CR]!", french=" Bienvenue au [CS:P]Village Shaymin[CR]!", german=" Willkommen in [CS:P]Shaymin-Dorf[CR]!", italian="Vi do il benvenuto\nal [CS:P]Villaggio Shaymin[CR]!", spanish="¡Te doy la bienvenida a\n[CS:P]Aldea Shaymin[CR]!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 31) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 31]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sheimi5, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" How was the summit?", french="Comment avez-vous\ntrouvé le sommet?", german=" Wie war es auf dem Gipfel?", italian=" Com'era la cima?", spanish=" ¿Qué tal en la cima?"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We're so happy to have so many\nof you climbing our mountain.", french="Nous sommes heureux que vous\nsoyez si nombreux à gravir la montagne.", german="Wir sind so froh, dass so viele\nvon euch den Berg besteigen.", italian="Siamo molto felici di vedere\ncosì tante squadre d'esplorazione\nsu questa montagna.", spanish="Nos alegra mucho que haya\ntanta gente escalando nuestra montaña."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 30) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 30]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sheimi5, 4) end)
  GAME:WaitFrames(1)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi5, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="What?!\nThere are [CS:N]Grimer[CR] and [CS:N]Muk[CR] at the summit?", french="Quoi?!\nDes [CS:N]Tadmorv[CR] et des [CS:N]Grotadmorv[CR]?\nAu sommet!?", german="Wie bitte?!? Da sind [CS:N]Sleima[CR] und\n[CS:N]Sleimok[CR] auf dem Gipfel?", italian="Come?!\nCi sono dei [CS:N]Grimer[CR] e dei [CS:N]Muk[CR] in cima?", spanish="¡¿Cómo?!\n¿Que hay [CS:N]Grimer[CR] y [CS:N]Muk[CR] en la cima?"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" I wonder what they're up to...", french="Je me demande\nce qu'ils font là-haut...", german="Das ist ja der Gipfel!\nWas suchen sie wohl dort?", italian=" Mi chiedo cosa ci facciano lì...", spanish=" Me pregunto qué tramarán..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="They're supposed to be farther\ndown the mountain...", french="D'ordinaire, ils vivent\nplus bas sur la montagne...", german="Sie sollten eigentlich weiter\nunten im Tal sein...", italian="Non dovrebbero trovarsi così\nin alto...", spanish="Deberían estar en la parte\ninferior de la montaña..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 29) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 29]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sheimi5, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="I wonder how [CS:N]Ampharos[CR] is doing\nat the 8th Station Clearing...", french="Je me demande comment\nça se passe pour [CS:N]Pharamp[CR],\nà la trouée du 8[F:E] Relais.", german="Ich frage mich, wie es\n[CS:N]Ampharos[CR] bei der 8. Zwischenlagerlichtung\nwohl ergeht...", italian="Chissà come se la sta cavando\n[CS:N]Ampharos[CR] al Bivacco 8...", spanish="Me pregunto cómo le irá a\n[CS:N]Ampharos[CR] en la Base del\nOctavo Puerto..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We've looked up to him for a\nlong time now.", french="On a toujours éprouvé\nle plus grand respect pour lui.", german="Wir sehen schon sehr lange zu\nihm auf.", italian="Provo davvero una grande\nsimpatia per lui.", spanish="Ya hace mucho tiempo que\nadmiramos su labor."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="But it seems that he only has\neyes for this mountain...", french="Mais on dirait qu'il n'a d'yeux\nque pour cette montagne...", german="Aber anscheinend hat er nur\nAugen für diesen Berg...", italian="Ma pare che lui non abbia occhi\nche per questa montagna...", spanish="Pero parece que solo tiene ojos\npara esta montaña..."})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi5, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Ah! What am I saying? Oops...", french="Eh! Mais qu'est-ce que\nje raconte, moi? Oups...", german=" Oha! Was sage ich da? Ups...", italian=" Ah! Ma che sto dicendo? Ooops...", spanish=" ¡Huy! ¿Pero qué digo? Jo..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 28] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sheimi5, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="There seems to have been a\nquarrel with the [CS:N]Carnivine[CR] at the\n5th Station Clearing...", french="On dirait qu'il y a eu du rififi\navec les [CS:N]Vortente[CR], à la trouée\ndu 5[F:E] Relais...", german="Es gab wohl einen Streit\nmit den [CS:N]Venuflibis[CR] bei der\n5. Zwischenlagerlichtung...", italian="Pare che ci siano stati dei\nproblemi con le [CS:N]Carnivine[CR] al Bivacco 5...", spanish="Parece que ha habido una disputa\ncon los [CS:N]Carnivine[CR] en la Base del\nQuinto Puerto..."})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi5, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Hee-hee-hee. ♪\nThose [CS:N]Carnivine[CR] never change, do they?", french="Hi hi hi. ♪\nCes [CS:N]Vortente[CR], toujours les mêmes,\npas vrai?", german="Hihihihi. ♪\nDiese [CS:N]Venuflibis[CR] ändern sich wohl nie,\nnicht wahr?", italian="Hi hi hi. ♪\nQuelle [CS:N]Carnivine[CR] non cambiano mai, vero?", spanish="Ji, ji, ji. ♪\nEsos [CS:N]Carnivine[CR] nunca cambian, ¿eh?"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi5, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="But they're not bad, so please\nforgive them.", french="Mais ce ne sont pas de mauvais\nbougres, alors il faut les excuser.", german="Aber sie sind nicht bösartig,\nalso nimm es ihnen nicht übel.", italian="Però non sono cattive, quindi\ncercate di perdonarle.", spanish="Pero en el fondo no son malos,\nhay que perdonarlos."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 20] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sheimi5, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We haven't really climbed the\nmountain in a long time either, not since that\nearthquake.", french="Nous-mêmes, nous n'avons plus\nvraiment escaladé cette montagne depuis\nce tremblement de terre.", german="Wir sind den Berg seit einiger\nZeit auch nicht mehr empor geklommen. Auf\njeden Fall nicht mehr seit dem Erdbeben.", italian="Anche noi non scaliamo la\nmontagna da molto tempo, non da quando quel\nterremoto ha messo a soqquadro il villaggio.", spanish="Hace mucho que no subimos esa\nmontaña, desde aquel terremoto."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="In the past we used to socialize\nwith the others on the mountain...", french="Par le passé, nous avions\nl'habitude de nous lier d'amitié avec\nles autres résidents de la montagne...", german="In der Vergangenheit trafen wir\nhäufig mit anderen auf dem Berg zusammen...", italian="In passato stringevamo molte\namicizie sulla montagna...", spanish="Antiguamente solíamos socializar\ncon la gente de la montaña..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 16] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sheimi5, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Welcome to the [CS:P]Shaymin Village[CR]!", french=" Bienvenue au [CS:P]Village Shaymin[CR]!", german=" Willkommen in [CS:P]Shaymin-Dorf[CR]!", italian="Vi do il benvenuto\nal [CS:P]Villaggio Shaymin[CR]!", spanish="¡Te doy la bienvenida a\n[CS:P]Aldea Shaymin[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We haven't had this many guests\nsince we had that earthquake so long ago.", french="Nous n'avons pas beaucoup de\nvisiteurs depuis ce tremblement de terre,\nil y a bien longtemps.", german="Wir haben seit dem Erdbeben\nnicht mehr so viele Gäste gehabt, und das ist\nlange her.", italian="Non vedevamo così tanti ospiti\nda quando siamo stati colpiti dal terremoto,\nmolto tempo fa.", spanish="No hemos tenido muchos\nvisitantes desde que sufrimos aquel terremoto."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="There's not much here to see,\nbut feel free to take your time.", french="Il n'y a pas grand-chose\nà voir ici, mais prenez votre temps.", german="Hier gibt es nicht viel zu sehen,\naber nimm dir Zeit und sieh dich in Ruhe um.", italian="Qui non c'è molto da visitare,\nma fate pure con calma.", spanish="No es que haya mucho que ver,\npero puedes tomarte tu tiempo si lo deseas."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 8] || scn($SCENARIO_MAIN) >= [29
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
