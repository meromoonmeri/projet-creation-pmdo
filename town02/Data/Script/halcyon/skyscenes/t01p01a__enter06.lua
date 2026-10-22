-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/enter06.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_erekiburu = SkySceneKit.spawn_npc("electivire", 184, 168, Direction.Down, "NPC_EREKIBURU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_erekiburu, 4) end)
  if ((SV.SkyTalkBitFlags or {})[59] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[59]
  -- @label_116 [étiquette de flux ExplorerScript]
  -- switch(message_Menu(MENU_LINK_SHOP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[59] = 1 -- $SCENARIO_TALK_BIT_FLAG[59] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_erekiburu) end)
  SkySceneKit.say({english=" All right! You two are heroes!", french="Super! Vous êtes de véritables\nhéros!", german="In Ordnung! Ihr zwei seid\nHelden!", italian=" Wow, siete due Pokémon eroici!", spanish="La verdad es que siempre nos\nayudáis cuando hace falta."})
  pcall(function() UI:SetSpeaker(npc_npc_erekiburu) end)
  SkySceneKit.say({english="It'll get peaceful in Treasure\nTown too. Thanks for that!", french="Grâce à vous, la paix va\nrevenir à Bourg-Trésor aussi! Merci!", german="Auch in Schatzstadt wird es\nfriedlich werden. Dafür danke ich euch!", italian="Tornerà la pace anche a Borgo\nTesoro. Grazie!", spanish="Por fin podremos respirar\ntranquilos en Aldea Tesoro. Os lo\nagradezco."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_erekiburu, 4) end)
  if ((SV.SkyTalkBitFlags or {})[58] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[58]
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[58] = 1 -- $SCENARIO_TALK_BIT_FLAG[58] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_erekiburu) end)
  SkySceneKit.say({english="You throw everything you have\ninto this, you two!", french="Donnez tout ce que vous avez,\nvous deux!", german="Legt alles in diese Sache, was\nihr habt, ihr zwei!", italian=" Mettetecela tutta, voi due!", spanish=" ¡Empleaos a fondo con esto!"})
  pcall(function() UI:SetSpeaker(npc_npc_erekiburu) end)
  SkySceneKit.say({english=" You set that [CS:N]Darkrai[CR] straight!", french="Donnez une bonne leçon à ce\n[CS:N]Darkrai[CR]!", german="Rückt diesem [CS:N]Darkrai[CR] den Kopf\nzurecht!", italian=" Fategliela vedere a quel [CS:N]Darkrai[CR]!", spanish="¡Tenéis que darle una lección\na ese [CS:N]Darkrai[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_erekiburu, 4) end)
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 67) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 67]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_erekiburu, 4) end)
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_erekiburu, 4) end)
  if ((SV.SkyTalkBitFlags or {})[57] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[57]
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[57] = 1 -- $SCENARIO_TALK_BIT_FLAG[57] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_erekiburu) end)
  SkySceneKit.say({english="T-Team [CS:X]Ch-Charm[CR] is here,\nright?! I mean, at the guild?!", french="L'E-Equipe [CS:X]Ch-Charme[CR] est dans\nle coin, pas vrai?! A la Guilde?!", german="T-team [CS:X]Ch-Charme[CR] ist hier,\nrichtig? Ich meine hier in der Gilde?!?", italian="Il T-Team [CS:X]Ma-Malia[CR] è qui,\nvero?! Voglio dire, alla Gilda?!", spanish="El... el [CS:X]Equipo Carisma[CR] está aquí,\n¿no? Es decir, ¿en el [CS:N]Pokégremio[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_erekiburu) end)
  SkySceneKit.say({english="Whoaaah! Whoooaaah![K]\nWhoo-hoo-whoooaaah!", french="Wouaaah! Wouaaaaah![K]\nWou-ou-ouaaaaah!", german="Boaaah! Boooaaah![K]\nB-b-boooaaah!", italian="Woooow! Wooooooow![K]\nWoooooooooooooooow!", spanish="¡Guaaauuuu! ¡Guaaauuu![K]\n¡Requeteguaaauuuuu!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_erekiburu, 4) end)
  if ((SV.SkyTalkBitFlags or {})[56] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[56]
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[56] = 1 -- $SCENARIO_TALK_BIT_FLAG[56] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_erekiburu) end)
  SkySceneKit.say({english="Graduated from the guild,\nI hear!", french="Vous avez obtenu le diplôme de\nla Guilde, à ce qu'on dit!", german="Ihr habt die\nGildenabschlussprüfung bestanden, wie ich\ngehört habe!", italian="Ho saputo che avete superato\nl'esame della Gilda.", spanish="He oído que habéis superado\nel gran reto."})
  pcall(function() UI:SetSpeaker(npc_npc_erekiburu) end)
  SkySceneKit.say({english="I'm guessing my linking got you\nthrough, am I right?! Ha ha ha!", french="Je vois que mes chaînes de\ncapacités vous ont bien servi, pas vrai?!\nHa ha ha!", german="Ich denke, meine Kombinationen\nhaben euch geholfen durchzukommen, habe ich\nrecht?!? Hahaha!", italian="Suppongo che utilizziate le\nmie combinazioni, vero?! Ah ah ah!", spanish="Supongo que fueron mis enlaces\nlos que os sacaron las castañas del fuego,\n¿eh? ¡Ja, ja, ja!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 4] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_erekiburu, 4) end)
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_erekiburu, 4) end)
  if ((SV.SkyTalkBitFlags or {})[55] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[55]
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[55] = 1 -- $SCENARIO_TALK_BIT_FLAG[55] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_erekiburu) end)
  SkySceneKit.say({english=" Give it everything you've got!", french=" Donnez le maximum!", german=" Gebt alles, was ihr habt!", italian=" Mettetecela tutta!", spanish=" ¡Tenéis que emplearos a fondo!"})
  pcall(function() UI:SetSpeaker(npc_npc_erekiburu) end)
  SkySceneKit.say({english="If it would help, I'll pump up the\npower to link all the moves you need!", french="Si ça peut vous aider, je vais\nemployer mon énergie à lier toutes\nles capacités que vous voulez!", german="Falls das hilft, drehe ich die\nEnergie voll auf, um all die von euch\ngewünschten Attacken zu kombinieren!", italian="Se può essere d'aiuto, userò\ntutta la mia energia per combinare le vostre\nmosse!", spanish="Si necesitáis que os enlace algún\nmovimiento, solo tenéis que pedírmelo. Iré\nacumulando energía por si acaso."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 3] || scn($SCENARIO_MAIN) >= [23
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_erekiburu, 4) end)
  if ((SV.SkyTalkBitFlags or {})[54] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[54]
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[54] = 1 -- $SCENARIO_TALK_BIT_FLAG[54] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_erekiburu) end)
  SkySceneKit.say({english="I heard something that gave me\na short circuit!", french="J'ai entendu quelque chose qui\nm'a causé un choc terrible!", german="Ich habe etwas gehört, das bei\nmir fast einen Kurzschluss verursacht hätte!", italian="Ho sentito una cosa che mi ha\nmandato in corto circuito!", spanish="¡He oído algo que ha hecho que\nme salten chispas!"})
  pcall(function() UI:SetSpeaker(npc_npc_erekiburu) end)
  SkySceneKit.say({english="[CS:N]Grovyle[CR] is really the good guy?\nAnd [CS:N]Dusknoir[CR] is the bad guy?!", french="[CS:N]Massko[CR] est le gentil, en fait?\nEt [CS:N]Noctunoir[CR], le méchant?!", german="[CS:N]Reptain[CR] ist in Wirklichkeit der\nGute? Und [CS:N]Zwirrfinst[CR] ist der Böse?!?", italian="[CS:N]Grovyle[CR] è davvero uno dei\nbuoni? E [CS:N]Dusknoir[CR] è il cattivo?!", spanish="¿[CS:N]Grovyle[CR] es realmente el bueno?\n¡¿Y [CS:N]Dusknoir[CR] es el villano?!"})
  pcall(function() UI:SetSpeaker(npc_npc_erekiburu) end)
  SkySceneKit.say({english="The world's a funny place. You\nnever know what to expect...", french="Etrange, le monde est étrange...\nOn ne sait jamais à quoi s'attendre.", german="Die Welt ist schon ein lustiger\nOrt. Man weiß nie, was man zu erwarten hat.", italian="È strana la vita. Non sai\nmai cosa aspettarti...", spanish="Hay que ver cómo es el mundo.\nLa gente nunca es lo que aparenta..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_erekiburu, 4) end)
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 3] || scn($SCENARIO_MAIN) >= [17
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_erekiburu, 4) end)
  if ((SV.SkyTalkBitFlags or {})[53] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[53]
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[53] = 1 -- $SCENARIO_TALK_BIT_FLAG[53] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_erekiburu) end)
  SkySceneKit.say({english="It'd be good to see that [CS:N]Grovyle[CR]\ncaught soon!", french="Ce serait un plaisir de voir ce\n[CS:N]Massko[CR] sous les verrous au plus vite!", german="Es wäre gut, wenn [CS:N]Reptain[CR] bald\ngefasst werden würde!", italian="Come vorrei che [CS:N]Grovyle[CR]\nvenisse catturato presto!", spanish="¡Espero que agarren pronto a\nese [CS:N]Grovyle[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_erekiburu, 4) end)
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 4] || scn($SCENARIO_MAIN) >= [12
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_erekiburu, 4) end)
  if ((SV.SkyTalkBitFlags or {})[52] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[52]
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[52] = 1 -- $SCENARIO_TALK_BIT_FLAG[52] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_erekiburu) end)
  SkySceneKit.say({english="How was the expedition? Was it\nfun enough for you? Ha ha ha!", french="C'était comment, l'expédition?\nElectrisant, j'espère? Ha ha ha!", german="Wie war die Expedition? Hat sie\neuch genug Spaß gemacht? Hahaha!", italian="Com'è andata la spedizione?\nÈ stata divertente? Ah ah ah!", spanish="¿Qué tal la expedición?\n¿Os divertisteis bastante? ¡Ja, ja, ja!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_erekiburu, 4) end)
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [9, 1]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_erekiburu, 4) end)
  if ((SV.SkyTalkBitFlags or {})[51] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[51]
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[51] = 1 -- $SCENARIO_TALK_BIT_FLAG[51] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_erekiburu) end)
  SkySceneKit.say({english="Show them you've got the power\non the expedition!", french="Montrez-leur toute l'intensité\nqui vous anime pendant cette expédition!", german="Zeig ihnen auf der Expedition,\ndass du die Energie hast!", italian="Fategli vedere che siete in grado\ndi affrontare la spedizione!", spanish="¡Mostradles en la expedición\nque tenéis energía de sobra!"})
  pcall(function() UI:SetSpeaker(npc_npc_erekiburu) end)
  SkySceneKit.say({english="I'll be happy to keep the power\ngoing until we've done all the linking you need.", french="De mon côté, je me charge de\nmaintenir le courant tant que vous avez\nencore des capacités à lier.", german="Aber klar erhalte ich die Energie\naufrecht, bis wir all die Kombinationen\nvorgenommen haben, die du benötigst.", italian="Sarò felice di essere qui a\ndisposizione finché avrete bisogno di creare\ndelle combinazioni.", spanish="Yo me encargo de mantener\nla energía a tope mientras hacemos\nlos enlaces que necesitáis."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7] || scn($SCENARIO_MAIN) >= [8, 
  -- @label_115 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_erekiburu, 4) end)
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_115 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
