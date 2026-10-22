-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/um0502.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_sutoraiku = SkySceneKit.spawn_npc("scyther", 336, 160, Direction.UpRight, "NPC_SUTORAIKU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sutoraiku, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english=" We're leaving soon.", french=" On part bientôt.", german=" Wir brechen bald auf.", italian=" Ce ne andremo presto.", spanish=" Pronto nos iremos."})
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english="We're back on the hunt for\nnew treasures.", french="Nous voilà de nouveau en quête\nde trésors.", german="Wir sind zurück auf der Jagd\nnach neuen Schätzen.", italian=" Siamo tornati a caccia di tesori.", spanish="Vamos en busca de nuevos\ntesoros."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 50] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sutoraiku, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english="I hear that Phione Dew is\npretty rare.", french="J'ai entendu dire que la Rosée\nPhione est très rare.", german="Phione-Tau soll ziemlich selten\nsein.", italian="Ho sentito che la Brina Phione è\npiuttosto rara.", spanish="He oído que el Rocío Phione es\nmuy difícil de encontrar, muy inusual."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 48] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sutoraiku, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english="What was his name again? Was\nit [CS:N]Manaphy[CR], that little Pokémon?", french="Quel est le nom de ce bébé,\ndéjà? [CS:N]Manaphy[CR], c'est bien ça?", german="Wie war sein Name noch gleich?\nWar es [CS:N]Manaphy[CR], dieses kleine Pokémon?", italian="Come avete detto che si chiama?\nÈ [CS:N]Manaphy[CR], quel piccolo Pokémon?", spanish="¿Cómo dices que se llamaba\nese pequeño Pokémon? ¿[CS:N]Manaphy[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english=" Where could he have gotten to?", french=" Où a-t-il bien pu aller?", german=" Wo kann das Kleine nur sein?", italian=" Dove può essere andato?", spanish=" ¿Dónde estará?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 46) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 46]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sutoraiku, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english=" So the baby's called [CS:N]Manaphy[CR]...", french="Alors, le bébé s'appelle\n[CS:N]Manaphy[CR]...", german=" Das Kleine heißt also [CS:N]Manaphy[CR]...", italian="Quindi questo piccoletto si\nchiama [CS:N]Manaphy[CR]...", spanish="Así que el bebé se llama\n[CS:N]Manaphy[CR]..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 45] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sutoraiku, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english="We dropped by before we\nheaded out to [CS:P]Midnight Forest[CR].", french="On fait un saut dans le coin\navant d'aller à la [CS:P]Forêt Minuit[CR].", german="Wir sind vor unserem Aufbruch\nin den [CS:P]Mitternachtswald[CR] vorbeigekommen.", italian="Siamo passati prima di\ndirigerci verso la [CS:P]Foresta Mezzanotte[CR].", spanish="Decidimos hacer una visita antes\nde ir al [CS:P]Bosque Nocturno[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english="We needed to swing by [CS:K]Kecleon[CR]\nMarket to buy a [CS:I]Key[CR].", french="Il fallait qu'on passe par le\n[CS:K]Marché Kecleon[CR] pour acheter une [CS:I]Clé[CR].", german="Wir mussten beim\n[CS:K]Kecleon-Markt[CR] vorbeischauen, um einen\n[CS:I]Schlüssel[CR] zu kaufen.", italian="Dobbiamo fare un salto al\n[CS:K]Kecleon[CR] Market per comprare una [CS:I]Chiave[CR].", spanish="Teníamos que pasarnos por el\n[CS:K]Bazar Kecleon[CR] para comprar una [CS:I]Llave[CR]."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 41] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sutoraiku, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english="An Honorary Member of the\nPokémon Exploration Team Federation?", french="Quoi? Membre Honoraire de la\nFédération des Equipes d'Exploration Pokémon?", german="Ein Ehrenmitglied des\nErkundungsteamverbandes?", italian="Un membro onorario della\nFederazione Squadre d'Esplorazione dei\nPokémon?", spanish="¿Un miembro honorario de la\nFederación de Exploradores?"})
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english="What's that about? An Honorary\nMember?", french="Qu'est-ce que ça veut dire,\nMembre Honoraire?", german="Was soll das sein, ein\nEhrenmitglied?", italian="In che senso? Un membro\nonorario?", spanish="¿Qué es eso de miembro\nhonorario?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 33] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sutoraiku, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english="I don't think we're truly\ncut out to be mountain climbers.", french="Je ne pense pas qu'on soit\nvraiment taillés pour la haute montagne.", german="Ich glaube nicht, dass wir zum\nBergsteigen geboren sind.", italian="Non credo che siamo tagliati per\nfare gli scalatori...", spanish="No creo que tengamos madera\nde alpinistas, sinceramente."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 30] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sutoraiku, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english="Aah... This is an amazingly\ndelicious drink.", french="Aah... Cette boisson est\nun pur délice!", german="Aaah... Das ist ein vorzüglicher,\nleckerer Drink!", italian="Aaah... Questa bevanda è\nassolutamente deliziosa.", spanish="Aah... Esta bebida está\nde rechupete."})
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english=" It's really great for tired bones.", french="Il n'y a rien de mieux pour\nsoulager les vieux os.", german="Wirkt großartig bei müden\nKnochen!", italian="È perfetta per combattere\nla stanchezza.", spanish=" Es un gran reconstituyente."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 28] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english="There's snow around this area...\nI wonder what the summit looks like.", french="Il y a de la neige par ici... Je me\ndemande à quoi peut ressembler le sommet.", german="Rundherum liegt Schnee...\nIch frage mich, wie der Gipfel aussieht?", italian="Questa zona è ricoperta di\nneve... chissà cosa ci aspetta in cima?", spanish="Por esta zona hay nieve...\n¿Qué aspecto tendrá la cima?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 24] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english="We come all the way here, and\nthe path has become much steeper...", french="On a fait tout ce chemin\njusqu'ici mais ça devient très escarpé...", german="Nun sind wir so weit\ngekommen... Und der Pfad ist um einiges\nsteiler geworden...", italian="Siamo arrivati fin qui e\nil sentiero è diventato ancora più ripido\ne faticoso...", spanish="Hemos llegado hasta aquí y de\nrepente el sendero es mucho más escarpado..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 20] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english="It's a little strange...\nA treasure that has to be given as a gift...", french="C'est un peu bizarre, tout ça...\nUn trésor qu'il faut donner...", german="Eigenartig... Ein Schatz, der als\nGeschenk weitergegeben wird...", italian="Un tesoro da regalare a\nqualcuno... certo che è strano...", spanish="Es un poco raro...\nUn tesoro que se da como regalo..."})
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english="I don't know whether to be\nhappy about it or not. It's not like you get to\nkeep what's inside...", french="Je ne sais pas s'il faut s'en\nréjouir ou pas. Après tout, ce n'est pas comme\nsi on pouvait garder le contenu du cadeau...", german="Ich weiß nicht, wie ich das\nfinden soll. Der Inhalt ist ja dann auf jeden\nFall kein Thema mehr...", italian="Non so se essere felice oppure\nno. Non si può nemmeno tenere quello che\nc'è dentro...", spanish="La verdad es que no sé si\nalegrarme o ponerme triste. Si no te puedes\nquedar lo que hay dentro..."})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sutoraiku, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english=" Tch! No! What am I saying?", french="Tss! Non mais! Qu'est-ce que\nje raconte, moi?", german=" Nein! Was rede ich da?", italian=" Argh! No! No!", spanish=" ¡Ay! ¡No! ¿Qué estoy diciendo?"})
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english="What a greedy point of view...\nI'm ashamed to be so selfish...", french="Quel avare je fais...\nJe devrais avoir honte...", german="Wie kann ich nur so kleinlich,\nknauserig und berechnend davon sprechen...\nIch schäme mich, so selbstsüchtig zu sein!", italian="Come posso essere così egoista?\nÈ troppo meschino... perfino per me.", spanish="Mira que hay que ser avaricioso.\nMe da vergüenza ser tan egoísta..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 14] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sutoraiku, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english="Save the world![K] You're our\nonly hope!", french="Sauvez le monde![K] Vous êtes\nnotre seul espoir!", german="Rettet die Welt![K] Ihr seid unsere\neinzige Hoffnung!", italian="Salvate il mondo![K] Siete la\nnostra unica speranza!", spanish="¡Salvad el mundo![K] ¡Sois nuestra\núnica esperanza!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sutoraiku, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english="They're saying [CS:N]Grovyle[CR]'s actually\na good guy?", french="Il paraît que [CS:N]Massko[CR] est\nun bon Pokémon finalement?", german="Sie behaupten, [CS:N]Reptain[CR] sei in\nWirklichkeit einer von den Guten?", italian="Stanno dicendo che [CS:N]Grovyle[CR] ora\nè diventato buono?", spanish="O sea, ¿que ese [CS:N]Grovyle[CR] es en\nrealidad un buen Pokémon?"})
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english="Humph![K] How do they expect me\nto believe that now?", french="Hum![K] Comment veulent-ils me\nfaire avaler ça?", german=" Hmpf![K] Und das soll ich glauben?", italian="Umpf![K] Come possono\naspettarsi che ci creda, adesso?", spanish="¡Hay que ver![K] ¡¿No esperaréis\nque me trague eso ahora?!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sutoraiku, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english="He must have been a nasty piece\nof work in the future too, eh?", french="Dans le futur aussi, ce devait\nêtre un bandit notoire, pas vrai?", german="Er muss auch in der Zukunft ein\nschwieriger Fall gewesen sein, oder?", italian="Sarà stato un bell'osso duro\nanche nel futuro, eh?", spanish="Seguro que ya en el futuro era\nuna buena pieza, ¿eh?"})
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english=" That [CS:N]Grovyle[CR].", french=" Cet abominable [CS:N]Massko[CR].", german=" Dieser [CS:N]Reptain[CR]!", italian=" Quel [CS:N]Grovyle[CR]...", spanish=" Ese [CS:N]Grovyle[CR]..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sutoraiku, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english="That [CS:N]Grovyle[CR]...[K] I'll rough him up\nwith my claws!", french="Ce [CS:N]Massko[CR]...[K]\nil devra tâter de mes griffes!", german="Dieser [CS:N]Reptain[CR].[K] Ich werde ihn\nmit meinen Klauen auseinandernehmen!", italian="Quel [CS:N]Grovyle[CR]...[K] Lo graffierei\ncoi miei artigli!", spanish="A ese tal [CS:N]Grovyle[CR]...[K] ¡le voy a\nponer en su sitio!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 4] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sutoraiku, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english="All right! So which outlaw should\nwe punish today?", french="Très bien! Alors, quel\nhors-la-loi on va punir aujourd'hui?", german="In Ordnung! Also, welchen\nGanoven sollen wir heute bestrafen?", italian="Va bene! Allora quali ricercati\ndobbiamo sistemare oggi?", spanish="¡Muy bien! ¿A qué malhechor\ncastigamos hoy?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 1] || scn($SCENARIO_MAIN) >= [10
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sutoraiku, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english=" It's eco-friendly, you know?", french=" C'est une bourse, vous savez?", german="Es ist umweltfreundlich,\nweißt du?", italian=" È rispettoso dell'ambiente, sai?", spanish="Es respetuosa con el medio\nambiente, ¿lo sabías?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 3] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sutoraiku, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english="It's like this shop just sprang\nup overnight...", french="On dirait que ce magasin est\napparu dans la nuit...", german="Es scheint, als sei dieser Laden\nüber Nacht entstanden...", italian="Sembra quasi che questo locale\nsia spuntato fuori durante la notte...", spanish="Es como si esa tienda hubiera\naparecido de la noche a la mañana..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 3] || scn($SCENARIO_MAIN) >= [7, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sutoraiku, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english="We like finding new places\nwhere no one's gone before.", french="Ce qu'on adore, c'est découvrir\nde nouvelles contrées et être les premiers\nà les explorer.", german="Wir lieben es, noch unerforschte\nOrte zu erkunden.", italian="Ci piace trovare dei posti nuovi\ndove non è mai stato nessuno.", spanish="Nos gusta ir a sitios donde nunca\nha estado nadie antes."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [5, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
