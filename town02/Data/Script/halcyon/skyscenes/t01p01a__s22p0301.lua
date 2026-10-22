-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/s22p0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_T01P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(30)
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  local npc_npc_ruriri = SkySceneKit.spawn_npc("azurill", 376, 200, Direction.Left, "NPC_RURIRI")
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "sweating", 1) end)
  GROUND:MoveToPosition(npc_npc_ruriri, 356, 196, false, 2)
  local npc_npc_mariru = SkySceneKit.spawn_npc("marill", 320, 200, Direction.Right, "NPC_MARIRU")
  GROUND:MoveToPosition(npc_npc_mariru, 340, 196, false, 2)
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" [CS:N]Marill[CR]!", french=" [CS:N]Marill[CR]!", german=" [CS:N]Marill[CR]!", italian=" [CS:N]Marill[CR]!", spanish=" ¡[CS:N]Marill[CR]!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="[CS:N]Azurill[CR]! That's great![K] You woke\nup from your nightmare!", french="[CS:N]Azurill[CR]! C'est génial![K] Tu es enfin\nréveillé! Tu es sorti de ce cauchemar!", german="[CS:N]Azurill[CR]! Das ist toll![K] Du bist aus\ndeinem Albtraum aufgewacht!", italian="[CS:N]Azurill[CR]! Fantastico![K] Ti sei\nsvegliato dal tuo incubo!", spanish="¡[CS:N]Azurill[CR]! ¡Fantástico![K] ¡Has\ndespertado de la pesadilla!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" Yup!", french=" Ouaip!", german=" Ja!", italian=" Sì!", spanish=" ¡Sí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetOutputAttribute(4) [neutre/état moteur]
  GROUND:EntTurn(npc_npc_mariru, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_ruriri, Direction.UpRight)
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="You did it, Miss [CS:N]Cresselia[CR]![K]\nThank you so much!", french="Vous avez réussi, Mademoiselle\n[CS:N]Cresselia[CR]![K] Merci de tout cœur!", german="Das waren Sie, Frau [CS:N]Cresselia[CR]![K]\nVielen, vielen Dank!", italian="Ce l'ha fatta, signorina\n[CS:N]Cresselia[CR]![K] Grazie mille!", spanish="¡Lo lograste, [CS:N]Cresselia[CR]![K]\n¡Muchas gracias!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_ruriri, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" And Mister [CS:N]Drowzee[CR] too!", french="Et merci à vous aussi, Monsieur\n[CS:N]Soporifik[CR]!", german=" Und auch Herr [CS:N]Traumato[CR]!", italian="E grazie anche a lei, signor\n[CS:N]Drowzee[CR]!", spanish="¡Y [CS:N]Drowzee[CR], gracias a ti\ntambién!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_mariru, Direction.DownRight)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 352, 176, Direction.Down, "NPC_PERAPPU")
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 312, 184, Direction.DownRight, "NPC_PUKURIN")
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownRight)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 304, 232, Direction.UpRight, "NPC_BIPPA")
  GROUND:EntTurn(npc_npc_bippa, Direction.Right)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 336, 248, Direction.Up, "NPC_CHIRIIN")
  GROUND:EntTurn(npc_npc_chiriin, Direction.UpRight)
  local npc_npc_kureseria = SkySceneKit.spawn_npc("cresselia", 384, 176, Direction.DownLeft, "NPC_KURESERIA")
  GROUND:EntTurn(npc_npc_kureseria, Direction.Down)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 408, 192, Direction.Left, "NPC_HEIGANI")
  GROUND:EntTurn(npc_npc_heigani, Direction.DownLeft)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  local npc_npc_suriipu = SkySceneKit.spawn_npc("drowzee", 400, 232, Direction.UpLeft, "NPC_SURIIPU")
  pcall(function() GROUND:CharSetEmote(npc_npc_suriipu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Huh?! Me?!", french=" Hein?! Moi?!", german=" Äh? Ich?!?", italian=" Eh?! A me?!", spanish=" ¿Eh? ¿A mí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_ruriri, 372, 220, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_mariru, 372, 204, false, 2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-24), p.Y+(0), false, 2) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-24), false, 2) end
  GROUND:EntTurn(npc_npc_ruriri, Direction.Right)
  GROUND:EntTurn(npc_npc_mariru, Direction.DownRight)
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(partner, Direction.DownRight)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english="Thank you very much,\nMister [CS:N]Drowzee[CR]!", french="Merci beaucoup, Monsieur\n[CS:N]Soporifik[CR]!", german="Vielen Dank,\nHerr [CS:N]Traumato[CR]!", italian="Grazie mille, signor\n[CS:N]Drowzee[CR]!", spanish=" ¡Muchas gracias, Sr. [CS:N]Drowzee[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="Mister [CS:N]Drowzee[CR]![K] I have to thank\nyou too!", french="Monsieur [CS:N]Soporifik[CR]![K] Moi aussi,\nje dois vous remercier!", german="Herr [CS:N]Traumato[CR]![K] Ich muss Ihnen\nauch danken!", italian="Signor [CS:N]Drowzee[CR]![K] Anche io la\ndevo ringraziare!", spanish=" ¡[CS:N]Drowzee[CR]![K] ¡Te lo agradezco!"})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="You stayed to take care of\n[CS:N]Azurill[CR] this whole time...", french="Vous avez passé tout ce temps\nau chevet d'[CS:N]Azurill[CR]...", german="Sie sind die ganze Zeit bei\n[CS:N]Azurill[CR] geblieben, um auf ihn aufzupassen...", italian="È rimasto a prendersi cura di\n[CS:N]Azurill[CR] per tutto questo tempo.", spanish="Has cuidado de [CS:N]Azurill[CR] todo\neste tiempo..."})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Thank you so very much!", french=" Du fond du cœur, merci!", german=" Ganz herzlichen Dank!", italian=" Grazie mille!", spanish=" ¡Muchas gracias!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_suriipu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="Well...[K]shucks, it's the least I\ncould do.", french="Eh ben...[K] mince! C'était bien\nla moindre des choses.", german="Och![K] Nicht doch! Das war das\nMindeste, was ich tun konnte.", italian="Beh...[K] È il minimo che\npotessi fare.", spanish="Bueno...[K] Es lo menos que podía\nhacer, caramba."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, [CS:N]Cresselia[CR].[K] What happened\nto [CS:N]Palkia[CR]?", french="Dis, [CS:N]Cresselia[CR].[K] Qu'est-il arrivé\nà [CS:N]Palkia[CR]?", german="Hey, [CS:N]Cresselia[CR].[K] Was ist mit\n[CS:N]Palkia[CR] geschehen?", italian="Ehi, [CS:N]Cresselia[CR].[K] Cosa è successo\na [CS:N]Palkia[CR]?", spanish="Oye, [CS:N]Cresselia[CR].[K] ¿Qué ha pasado\ncon [CS:N]Palkia[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Listen, [CS:N]Cresselia[CR].[K] What happened\nto [CS:N]Palkia[CR]?", french="Dis, [CS:N]Cresselia[CR].[K] Qu'est-il arrivé\nà [CS:N]Palkia[CR]?", german="Hör mal, [CS:N]Cresselia[CR].[K] Was ist mit\n[CS:N]Palkia[CR] geschehen?", italian="Ehi, [CS:N]Cresselia[CR].[K] Cosa è successo\na [CS:N]Palkia[CR]?", spanish="Oye, [CS:N]Cresselia[CR].[K] ¿Qué ha pasado\ncon [CS:N]Palkia[CR]?"})
  else
  SkySceneKit.say({english="Say, [CS:N]Cresselia[CR].[K] What happened\nto [CS:N]Palkia[CR]?", french="Dis, [CS:N]Cresselia[CR].[K] Qu'est-il arrivé\nà [CS:N]Palkia[CR]?", german="Sag mal, [CS:N]Cresselia[CR].[K] Was ist mit\n[CS:N]Palkia[CR] passiert?", italian="Ehi, [CS:N]Cresselia[CR].[K] Cosa è successo\na [CS:N]Palkia[CR]?", spanish="Oye, [CS:N]Cresselia[CR].[K] ¿Qué ha pasado\ncon [CS:N]Palkia[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kureseria, Direction.DownLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_kureseria, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_kureseria, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_kureseria, 4) end)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 296, 208, Direction.Right, "NPC_DOGOOMU")
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_kureseria, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_kureseria, 4) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 376, 248, Direction.Up, "NPC_KIMAWARI")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_kureseria, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_ruriri, npc_npc_kureseria, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, npc_npc_kureseria, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_suriipu, npc_npc_kureseria, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_kureseria, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[CS:N]Palkia[CR] is immersed within\n[CS:P]Spacial Rift[CR]...", french="[CS:N]Palkia[CR] se trouve au cœur\nde la [CS:P]Faille Spatiale[CR]...", german="[CS:N]Palkia[CR] ist in der\n[CS:P]Raumspalte[CR] untergetaucht...", italian="[CS:N]Palkia[CR] è nella\n[CS:P]Valle Dimensionale[CR]...", spanish="[CS:N]Palkia[CR] se encuentra en la\n[CS:P]Grieta Espacial[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Where he's attempting to take\ncare of the distortion of space.", french="Il essaie de remédier à\nla distorsion de l'espace.", german="Dort will es sich um die\nVerzerrung des Raumes kümmern.", italian="Sta cercando di occuparsi della\ndistorsione dello spazio.", spanish="Está intentando arreglar la\ndeformación del espacio."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="As the being that governs space\nitself, he is staking his pride on success.", french="En tant que maître de l'espace,\nc'est sa fierté qui est en jeu.", german="Als das Wesen, das den Raum\nselbst beherrscht, liegt ihm der Erfolg sehr\nam Herzen.", italian="Dal momento che è l'essere che\ngoverna lo spazio, per lui è una questione di\norgoglio.", spanish="Su labor, como guardián del\nespacio, está en juego."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Given that duty, I would not\nexpect to see him manifest here again.", french="Il a fort à faire, alors il y a\npeu de chances qu'on le revoie par ici.", german="Die Bürde dieser Aufgabe wird\nes hier nicht mehr so schnell erscheinen\nlassen.", italian="Poiché è molto occupato,\nnon penso che lo rivedremo qui.", spanish="Así que no creo que vuelva\npor aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Well done! How remarkable!", french=" Beau travail! C'est remarquable!", german=" Sehr gut! Beeindruckend!", italian=" Ben fatto! Davvero ammirevole!", spanish=" ¡Bien! ¡Bien hecho!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It's truly quite marvelous![K]\nMarvelous indeed, [CS:N]Cresselia[CR]! ♪", french="En vérité, c'est merveilleux![K]\nOui, vraiment merveilleux, [CS:N]Cresselia[CR]! ♪", german="Das ist echt fabelhaft![K]\nWirklich fabelhaft, [CS:N]Cresselia[CR]! ♪", italian="È davvero meraviglioso![K]\nMeraviglioso, [CS:N]Cresselia[CR]! ♪", spanish="¡Es maravilloso![K] ¡Maravilloso,\n[CS:N]Cresselia[CR]! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We'd heard of your power to\ndispel darkness, but only in rumor.", french="Nous avions entendu parler de\nvotre faculté à dissiper l'ombre, mais\nseulement par ouï-dire.", german="Wir hatten von deiner Macht,\ndie Dunkelheit zu vertreiben, gehört. Aber nur\ngerüchteweise.", italian="Avevamo sentito del tuo potere\ndi scacciare l'oscurità, ma pensavamo che\nfossero solo voci.", spanish="Habíamos oído hablar de tus\npoderes, pero solo en rumores."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But it was all true! ♪[K] I must\nsay, this is completely marvelous!", french="Il s'avère que tout était\nvrai! ♪[K] Je dois dire que c'est proprement\nmerveilleux!", german="Und es hat alles gestimmt! ♪[K]\nIch muss zugeben, das ist total fantastisch!", italian="Ma era tutto vero! ♪[K] Devo\nammettere che è proprio meraviglioso!", spanish="¡Pero era cierto! ♪[K] ¡Realmente\nmaravilloso!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I understand...[K] You used your\npower when we were in [CS:N]Palkia[CR]'s nightmare.", french="Je comprends...[K] Tu t'es servie\nde ton pouvoir quand on était dans\nle cauchemar de [CS:N]Palkia[CR].", german="Ich verstehe.[K] Du hast deine\nMacht eingesetzt, als du in dem Albtraum von\n[CS:N]Palkia[CR] warst.", italian="Ho capito...[K] Hai usato il tuo\npotere quando eravamo nell'incubo di [CS:N]Palkia[CR].", spanish="Ahora lo entiendo...[K] Usaste tus\npoderes en la pesadilla de [CS:N]Palkia[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I understand...[K] You used your\npower when we were in [CS:N]Palkia[CR]'s nightmare.", french="Je comprends...[K] Tu t'es servie\nde ton pouvoir quand on était dans\nle cauchemar de [CS:N]Palkia[CR].", german="Ich verstehe.[K] Du hast deine\nMacht eingesetzt, als du in dem Albtraum von\n[CS:N]Palkia[CR] warst.", italian="Ho capito...[K] Hai usato il tuo\npotere quando eravamo nell'incubo di [CS:N]Palkia[CR].", spanish="Ahora lo entiendo...[K] Usaste tus\npoderes en la pesadilla de [CS:N]Palkia[CR]."})
  else
  SkySceneKit.say({english="I understand...[K] You used your\npower when we were in [CS:N]Palkia[CR]'s nightmare.", french="Je comprends...[K] Tu t'es servie\nde ton pouvoir quand on était dans\nle cauchemar de [CS:N]Palkia[CR].", german="Ich verstehe.[K] Du hast deine\nMacht eingesetzt, als du in dem Albtraum von\n[CS:N]Palkia[CR] warst.", italian="Ho capito...[K] Hai usato il tuo\npotere quando eravamo nell'incubo di [CS:N]Palkia[CR].", spanish="Ahora lo entiendo...[K] Usaste tus\npoderes en la pesadilla de [CS:N]Palkia[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's how you pulled [CS:N]Palkia[CR]\nand us out of the nightmare.", french="C'est comme ça que tu as pu\nnous sortir du cauchemar, [CS:N]Palkia[CR] et nous.", german="Auf diese Weise hast du [CS:N]Palkia[CR]\nund uns aus dem Albtraum geholt.", italian="È così che hai trascinato [CS:N]Palkia[CR]\ne noi fuori dall'incubo.", spanish="Así lograste sacarnos con [CS:N]Palkia[CR]\nde esa horrible pesadilla."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's how you pulled [CS:N]Palkia[CR]\nand us out of the nightmare.", french="C'est comme ça que tu as pu\nnous sortir du cauchemar, [CS:N]Palkia[CR] et nous.", german="Auf diese Weise hast du [CS:N]Palkia[CR]\nund uns aus dem Albtraum geholt.", italian="È così che hai trascinato [CS:N]Palkia[CR]\ne noi fuori dall'incubo.", spanish="Así lograste sacarnos con [CS:N]Palkia[CR]\nde esa horrible pesadilla."})
  else
  SkySceneKit.say({english="That's how you pulled [CS:N]Palkia[CR]\nand us out of the nightmare.", french="C'est comme ça que tu as pu\nnous sortir du cauchemar, [CS:N]Palkia[CR] et nous.", german="Auf diese Weise hast du [CS:N]Palkia[CR]\nund uns aus dem Albtraum geholt.", italian="È così che hai trascinato [CS:N]Palkia[CR]\ne noi fuori dall'incubo.", spanish="Así lograste sacarnos con [CS:N]Palkia[CR]\nde esa horrible pesadilla."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_WELCOME_TO_THE_WORLD_OF_POKEMON non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Indeed.[K] I do have the power to\ndispel darkness...", french="En effet.[K] J'ai la faculté\nde dissiper l'ombre...", german="So ist es.[K] Ich habe tatsächlich\ndie Macht, Dunkelheit zu vertreiben...", italian="È vero.[K] Ho il potere di\ndissipare l'oscurità.", spanish="Efectivamente.[K] Tengo el poder\nde disipar la oscuridad..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="It lets me dispel nightmares and\nawaken those in deepest sleep.", french="... ce qui me permet de chasser\nles cauchemars et de tirer les Pokémon du\nplus profond des sommeils.", german="Sie lässt mich Albträume\nverjagen und Schläfer aus ihrem tiefsten\nSchlaf wecken.", italian="Mi permette di scacciare gli\nincubi e svegliare i Pokémon dai sonni più\nprofondi.", spanish="Puedo disipar las pesadillas y\ndespertar a los que sueñan profundamente."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[CS:N]Darkrai[CR] stands as an opposite\nto my being. He has the power to enshroud\nthose who sleep in nightmare.", french="[CS:N]Darkrai[CR] est mon exact opposé.\nIl a le pouvoir de séquestrer ceux qui dorment\ndans un cauchemar.", german="Das Wesen von [CS:N]Darkrai[CR] ist das\nGegenteil von meinem. Es hat die Macht, die\nSchlafenden in Albträume zu hüllen.", italian="[CS:N]Darkrai[CR] ha il potere opposto.\nRiesce a imprigionare negli incubi coloro che\ndormono.", spanish="[CS:N]Darkrai[CR] es mi rival. Tiene\nel poder de sumir en pesadillas a los que\nduermen."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" [partner].[K] And, [hero].", french=" [partner].[K] Et [hero].", german=" [partner].[K] Und [hero].", italian=" [partner].[K] E [hero].", spanish=" [partner].[K] [hero]..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Do you recall where you met my\nimpostor?", french="Vous vous souvenez où vous\navez fait la connaissance de mon double?", german="Erinnert ihr euch, wo ihr meinen\nbetrügerischen Nachmacher getroffen habt?", italian="Vi ricordate dove avete\nincontrato la finta me stessa?", spanish="¿Os acordáis de cómo\nconocisteis a la impostora?"})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="The impostor, that is to say, the\nfirst [CS:N]Cresselia[CR] you met...", french="Par double, j'entends la première\n[CS:N]Cresselia[CR] que vous ayez connue...", german="Die falsche [CS:N]Cresselia[CR], die ihr\ngetroffen habt...", italian="L'impostore, cioè la prima\n[CS:N]Cresselia[CR] che avete incontrato...", spanish=" Es decir, la primera [CS:N]Cresselia[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Those encounters were always\nwithin dreams, weren't they?", french="Chaque fois que vous l'avez vue,\nc'était en rêve, n'est-ce pas?", german="Diese Begegnungen fanden immer\nin Träumen statt, oder nicht?", italian="Quegli incontri sono sempre\navvenuti nei sogni, giusto?", spanish="Os encontrasteis siempre en\nsueños, ¿verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...That's...[K] That's true!", french=" ... C'est...[K] c'est vrai!", german=" ...Das...[K] Das stimmt!", italian=" È...[K] È vero!", spanish=" Eh...[K] ¡Es verdad!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...That's...[K] That's true!", french=" ... C'est...[K] c'est vrai!", german=" ...Das...[K] Das stimmt!", italian=" È...[K] È vero!", spanish=" Eh...[K] ¡Es verdad!"})
  else
  SkySceneKit.say({english=" ...That's...[K] That's true!", french=" ... C'est...[K] c'est vrai!", german=" ...Das...[K] Das stimmt!", italian=" È...[K] È vero!", spanish=" Eh...[K] ¡Es verdad!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's true...)", french="(C'est vrai...)", german="(Es stimmt.)", italian="(È vero...)", spanish="(Es verdad...)"})
  else
  SkySceneKit.say({english="(It's true...)", french="(C'est vrai...)", german="(Es stimmt.)", italian="(È vero...)", spanish="(Es verdad...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The first time was in a dream.)", french="(La première fois, c'était dans un rêve.)", german="(Das erste Mal war in einem Traum.)", italian="(La prima volta è stato in un sogno.)", spanish="(La primera vez fue en un sueño.)"})
  else
  SkySceneKit.say({english="(The first time was in a dream.)", french="(La première fois, c'était dans un rêve.)", german="(Das erste Mal war in einem Traum.)", italian="(La prima volta è stato in un sogno.)", spanish="(La primera vez fue en un sueño.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Then later on, come to think of it...)", french="(Mais par la suite, réflexion faite...)", german="(Und später, wenn ich so darüber nachdenke...)", italian="(Poi, adesso che ci penso...)", spanish="(Y después también, ahora que lo pienso...)"})
  else
  SkySceneKit.say({english="(Then later on, come to think of it...)", french="(Mais par la suite, réflexion faite...)", german="(Und später, wenn ich so darüber nachdenke...)", italian="(Poi, adesso che ci penso...)", spanish="(Y después también, ahora que lo pienso...)"})
  end
  -- message_Close
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
