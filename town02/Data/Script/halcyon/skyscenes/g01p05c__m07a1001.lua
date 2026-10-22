-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P05C/m07a1001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P05C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GAME:WaitFrames(60)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 208, 200, Direction.Up, "NPC_PUKURIN")
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Hiya!", french=" Amis du soir, bonsoir!", german=" Hallöchen!", italian=" Ullalà!", spanish=" ¿Qué hay?"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="You brought me some Perfect\nApples, didn't you?", french="Vous m'apportez des Pommes\nParfaites, hein, dites?", german="Ihr habt mir Perfekte Äpfel\nmitgebracht, nicht wahr?", italian="Mi avete portato delle Mele\nPerfette, vero?", spanish="Me habéis traído Manzanas\nPerfectas, ¿verdad?"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Thank you!", french=" Merciii!", german=" Vielen Dank!", italian=" Grazie!", spanish=" ¡Gracias!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 248, 232, Direction.UpLeft, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Uh... There's, uh, a slight...", french="Hum... euh... Il y a... euh, un\npetit...", german=" Äh, es gibt da, äh, ein kleines...", italian=" Eh... C'è un piccolo, ehm...", spanish=" Esto... Ha habido un ligero..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Uh... It's awfully hard to say\nthis, but...", french="Euh... Vous me voyez\nterriblement navré de vous annoncer\ncela, mais...", german="Äh, ich weiß nicht, wie ich es\nsagen soll, aber...", italian="Ecco... È davvero difficile dirlo,\nma...", spanish="Esto... Me resulta...\ntremendamente difícil decir esto, pero..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Huh? What's wrong?", french=" Hein? Qu'y a-t-il?", german=" Wie? Was ist los?", italian=" Eh? Cosa c'è?", spanish=" ¿Eh? ¿Qué pasa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" You see, uh, truth be told...", french="Vous comprenez... euh... pour\ndire la vérité...", german=" Also, äh, um ehrlich zu sein...", italian=" Beh, a dire la verità...", spanish=" Yo... Lo cierto es que..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="These apprentices... Well, they\nfailed in their mission to bring back any\nPerfect Apples, and...", french="Eh bien... les deux novices...\nn'ont pas réussi leur mission et n'ont pas\nréussi à rapporter de Pommes Parfaites.", german="Diese Lehrlinge... Nun, sie haben\nes nicht geschafft, ihre Mission zu erfüllen,\nund...", italian="Questi Pokémon apprendisti...\nBeh, non sono riusciti a trovare neanche una\nMela Perfetta e...", spanish="Este equipo... El caso es que no\nhan cumplido la misión de traer Manzanas\nPerfectas y..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" So, uh, to put it another way...", french="Donc... euh... pour dire les\nchoses autrement...", german=" Also, äh, anders ausgedrückt...", italian=" Quindi, eh, per farla breve...", spanish=" Así que, por tanto..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" It's OK. I understand. ♪", french=" C'est bon. J'ai compris. ♪", german=" Es ist okay. Ich verstehe. ♪", italian=" Non c'è problema. Capisco. ♪", spanish=" No pasa nada. Lo entiendo. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="It's all right![K]\nNobody wins all the time. ♪", french="Ce n'est pas grave![K]\nOn ne peut pas gagner à tous les coups. ♪", german="Ist schon okay![K]\nDas kann doch jedem mal passieren. ♪", italian="Non preoccupatevi![K]\nA volte va bene, a volte no. ♪", spanish="¡No pasa nada![K]\nUnas veces se gana y otras se pierde. ♪"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Don't feel blue, don't feel\nblue. ♪", french="Ne soyez pas tristes, ne soyez\npas tristes. ♪", german="Nicht traurig sein, nicht traurig\nsein. ♪", italian="Non sentitevi giù, non sentitevi\ngiù. ♪", spanish="No estéis tristes. No estéis\ntristes. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Where are the other Perfect\nApples?", french="Où sont les Pommes\nParfaites qui restent?", german="Wo sind die anderen Perfekten\nÄpfel?", italian="Dove sono le altre Mele\nPerfette?", spanish="¿Dónde están las otras\nManzanas Perfectas?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="As I'd explained... Um... They\nfailed to get them, so, uh...", french="Comme je l'ai expliqué... hum...\nles deux novices n'ont pas réussi à en\nrapporter, donc, euh...", german="Wie ich schon sagte... Ähm...\nSie konnten keine besorgen, also, äh...", italian="Come stavo spiegando... ehm...\nnon le hanno trovate, quindi, ehm...", spanish="Tal y como he explicado, pues...\nNo las han conseguido, así que..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="In other words, uh...the Perfect\nApples...", french="En d'autres termes, euh...\nles Pommes Parfaites...", german="Anders ausgedrückt, äh,\ndie Perfekten Äpfel...", italian="In altre parole, ehm... le Mele\nPerfette...", spanish="En otras palabras...\nLas Manzanas Perfectas..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The number of Perfect Apples\nharvested...would be, uh...[K]zero.", french="Le nombre de Pommes Parfaites\ncueillies... s'élève à... euh...[K] zéro.", german="Die Anzahl der geernteten\nPerfekten Äpfel beträgt, äh...[K] Null.", italian="Il numero di Mele Perfette\nraccolte... è...[K] zero.", spanish="El número de Manzanas\nPerfectas recogidas sería de...\nmás o menos...[K] ninguna."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" ...[K]Oh.", french=" ...[K] Oh.", german=" ...[K]Oh.", italian=" ...[K] Oh.", spanish=" Oh...[K] Vaya."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Therefore...not even one\nPerfect Apple was obtained...", french="Donc... pas une seule Pomme\nParfaite n'a été cueillie...", german="Aus diesem Grund... wurde kein\neinziger Perfekter Apfel herbeigeschafft.", italian="Quindi... non abbiamo neanche\nuna Mela Perfetta...", spanish="Por tanto... no hemos conseguido\nni una sola Manzana Perfecta..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" That means, Guildmaster...", french=" Ce qui signifie, Maître...", german=" Das bedeutet, Gildenmeister...", italian=" Il che significa, Capitano...", spanish=" Eso significa, Gran Bluff..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You will have to make do\nwithout Perfect Apples for a little bit.", french="... que vous allez devoir\nvous passer de Pommes Parfaites, très\nprovisoirement, cela va sans dire.", german="Du wirst ein klitzekleines\nWeilchen auf Perfekte Äpfel verzichten\nmüssen.", italian="... che dovrà fare a meno di\nmangiare Mele Perfette per un po'.", spanish="Que tendrás que pasar sin\nManzanas Perfectas una temporada."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Yep, that's what it means!", french=" C'est la triste vérité!", german=" Ja, das bedeutet es!", italian=" Già, è così!", spanish=" ¡Sí, eso es lo que pasa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Hee! ♪[K] Hee! ♪[K] Hee-heeee!\nHee-heeee! Hee-heeee! Hee-heeee! ♪\nHee-heeee! Hee-heeee! Hee-heeee! ♪", french="Hii! ♪[K] Hii! ♪[K] Hii hiii! ♪\nHii hiii! Hii hiii! Hii hiii! ♪\nHii hiii! Hii hiii! Hii hiii! ♪", german="Hii! ♪[K] Hii! ♪[K] Hihihi!\nHihihi! Hihihi! Hihihi! ♪\nHihihi! Hihihi! Hihihi! ♪", italian="Eeh! ♪[K] Eeh! ♪[K] Eeh-eeeeh!\nEeh-eeeeh! Eeh-eeeeh! Eeh-eeeeh! ♪\nEeh-eeeeh! Eeh-eeeeh! Eeh-eeeeh! ♪", spanish="¡Ji! ♪[K] ¡Ji, ji! ♪[K] ¡Ji, ji, ji!\n¡Ji, ji, ji! ¡Ji, ji, ji! ¡Ji, ji, ji! ♪\n¡Ji, ji, ji! ¡Ji, ji, ji! ¡Ji, ji, ji! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Hee-heeee! Hee-heeee! ♪[K]\nHee-heeee...[K] Hee...", french="Hii hiii! Hii hiii! ♪[K]\nHii hiii...[K] Hii...", german="Hihihi! Hihihi! ♪[K]\nHihihi...[K] Hi...", italian="Eeh-Eeeeh! Eeh-Eeeeh! ♪[K]\nEeh-Eeeeh...[K] Eeh...", spanish="¡Ji, ji, ji! ¡Ji, ji, ji! ♪[K]\nJi, jiii...[K] Ji..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Um, Guildmaster? Guildmaster?", french=" Hum, Maître? Maître?", german="Äh, Gildenmeister?\nGildenmeister?", italian=" Ehm, Capitano? Capitano?", spanish="Hum... ¿Gran Bluff?\n¿Gran Bluff?"})
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Sniffle...", french=" Snif...", german=" Schnief...", italian=" Sniff...", spanish=" Snif..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Sniffle...", french=" Snif...", german=" Schnief...", italian=" Sniff...", spanish=" Snif..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Sob...", french=" Snif...", german=" Schluchz...", italian=" Sob...", spanish=" ¡Qué triste!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" (Whoa! He's going to bawl!)", french=" (Ouah! Il pleure!)", german="(Boah! Er fängt gleich an\nzu heulen!)", italian="(Oh-oh! Sta per mettersi a\nstrillare!)", spanish="(¡Vaya! ¡Le va a dar\nun berrinche!)"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" (Whoa! He's going to cry!)", french=" (Ouah! Il pleure!)", german="(Boah! Gleich bricht er in\nTränen aus!)", italian="(Oh-oh! Sta per mettersi a\nstrillare!)", spanish=" (¡Vaya! ¡Va a llorar!)"})
  else
  SkySceneKit.say({english=" (Whoa! He's going to cry!)", french=" (Ouah! Il pleure!)", german="(Boah! Gleich bricht er in\nTränen aus!)", italian="(Oh-oh! Sta per mettersi a\nstrillare!)", spanish=" (¡Vaya! ¡Va a ponerse a llorar!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(9) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Sniffle-snivel-snivel-snivel...", french=" Snif snif snif snif...", german=" Schnief-schnuff-schnuff...", italian=" Sniff-sniff-sniff-sniff...", spanish=" Snif... Snif..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Waaaah! N-no!", french=" Oooh! Non... non!", german=" Waaaah! N-nein!", italian=" Waaaah! N-No!", spanish=" ¿Qué? ¡Nooo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Urrrrffff...[K] Urrrrrrrrrr...", french=" Aaarf...[K] Aaaaaaaaarf...", german=" Urrrrffff...[K] Urrrrrrrrrr...", italian=" Urrrrffff...[K] Urrrrrrrrrr...", spanish=" Auu...[K] Auu..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_EARTHQUAKE1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1')
  GAME:WaitFrames(60)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yow! The whole place\nis shaking!", french=" Oh! Toute la pièce tremble!", german=" Oje! Alles wackelt und bebt!", italian=" Aah! Sta tremando tutto!", spanish="¡Ay! ¡Todo el edificio\nestá temblando!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yow! The whole place\nis shaking!", french=" Oh! Toute la pièce tremble!", german=" Oje! Alles wackelt und bebt!", italian=" Aah! Sta tremando tutto!", spanish="¡Ay! ¡Todo el edificio\nestá temblando!"})
  else
  SkySceneKit.say({english="Yow! The whole place\nis shaking!", french=" Oh! Toute la pièce tremble!", german=" Oje! Alles wackelt und bebt!", italian=" Aah! Sta tremando tutto!", spanish="¡Ay! ¡Todo el edificio\nestá temblando!"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Waa...[K] Waaaaaaaaahhh...", french=" Ouiiin...[K] Ouiiiiiiiiin...", german=" Wää...[K] Wääääääääähhh...", italian=" Waa...[K] Waaaaaaaaahhh...", spanish=" Bua...[K] Buaaaaaaa..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_PlayFadeIn(BGM_EARTHQUAKE3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '1')
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Cover your ears!", french=" Bouchez-vous les oreilles!", german=" Haltet euch die Ohren zu!", italian=" Tappatevi le orecchie!", spanish=" ¡Tapaos los oídos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" W-why?!", french=" Euh... pourquoi?", german=" W-warum?!?", italian=" P-Perché?!", spanish=" ¡¿Pero por qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" W-why?!", french=" Euh... pourquoi?", german=" W-warum?!?", italian=" P-Perché?!", spanish=" ¡¿Pero por qué?!"})
  else
  SkySceneKit.say({english=" W-why?!", french=" Euh... pourquoi?", german=" W-warum?!?", italian=" P-Perché?!", spanish=" ¡¿Pero por qué?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Don't argue! Do it now!", french=" Ne discutez pas! Vite!", german=" Fragt nicht! Tut es einfach!", italian="Niente discussioni! Fatelo\ne basta!", spanish=" ¡No discutáis! ¡Hacedlo ya!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(27) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" WAAAAAAAAAAAAAAAAH!", french=" Ouiiiiin! Ouiiiiiiiiiiiiiiiiiiiiin!", german=" WÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄH!", italian=" WAAAAAAAAAAAAAAAAH!", spanish=" ¡Buuuaaaaaaaaaa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_ChangeVolume(0, 256) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 6, 30)) end) -- camera_SetEffect('2', '3', '1')
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Eeeeeeh!", french=" Hiiiiiiiiiii!", german=" Ieeeeeeek!", italian=" Eeeeeeh!", spanish=" ¡Aaaaaah!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6665) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" BWEEEEEEEEEAAAAAHHHHH!", french=" Ouiiiiin! Ouiiiiiiiiiiiiiiiiiiiiin!", german=" BUÄÄÄÄÄÄÄÄÄÄÄÄÄHHHHH!", italian=" BUUUUUUUUAAAAAHHHHH!", spanish=" ¡Buuuaaaaaaaaaa!"})
  -- GAP: SetEffect 244 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  pcall(function() GAME:MoveCamera(280, 244, 1, false) end) -- SetPositionMark performer/caméra
  -- GAP: SetEffect 244 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  -- message_CloseEnforce
  -- GAP: SetEffect 438 — VFX sans émote PMDO équivalente
  -- GAP: SetEffect 438 — VFX sans émote PMDO équivalente
  -- GAP: SetEffect 438 — VFX sans émote PMDO équivalente
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Aiyeeeeee!", french=" Aïe aïe aïe! Ouille! Aïe aïe aïe!", german=" Iiiiaaaargh!", italian=" Aaaaaah!", spanish=" ¡Nooooooo!"})
  pcall(function() GAME:MoveCamera(280, 244, 1, false) end) -- SetPositionMark performer/caméra
  -- GAP: SetEffect 244 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  pcall(function() GAME:MoveCamera(140, 236, 1, false) end) -- SetPositionMark performer/caméra
  -- GAP: SetEffect 244 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  pcall(function() GAME:MoveCamera(244, 192, 1, false) end) -- SetPositionMark performer/caméra
  -- GAP: SetEffect 244 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  -- message_CloseEnforce
  GAME:FadeOut(false, 5)
  -- se_Stop(6665) [SE one-shot PMDO déjà terminé: arrêt sans objet, canal SE V2]
  pcall(function() SOUND:FadeOutBGM(10) end)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Sorry to disturb you! We've come to\ndeliver a Perfect Apple!", french="Navré de vous déranger! Nous vous\napportons une Pomme Parfaite!", german="Verzeiht die Störung! Wir sind da, um\neinen Perfekten Apfel zu bringen!", italian="Scusate il disturbo! Siamo venuti\na portare una Mela Perfetta!", spanish="¡Disculpad la interrupción!\n¡Veníamos a traer una Manzana Perfecta!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(27) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeIn(5)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Huh?", french=" Hein?", german=" Huch?", italian=" Eh?", spanish=" ¿Eh?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(partner, Direction.Down)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(204, 260, 60, false) end) -- performer/caméra
  local npc_npc_sukatanku = SkySceneKit.spawn_npc("skuntank", 208, 376, Direction.Down, "NPC_SUKATANKU")
  GROUND:MoveToPosition(npc_npc_sukatanku, 204, 276, false, 2)
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 176, 368, Direction.Down, "NPC_DOGAASU")
  GROUND:MoveToPosition(npc_npc_dogaasu, 176, 276, false, 2)
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 232, 368, Direction.Down, "NPC_ZUBATTO")
  GROUND:MoveToPosition(npc_npc_zubatto, 232, 276, false, 2)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  GROUND:MoveToPosition(npc_npc_dogaasu, 192, 252, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_zubatto, 216, 252, false, 2)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_zubatto, Direction.UpRight)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Right)
  -- SetAnimation(11) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(16), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(5)
  -- SetAnimation(11) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-16), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Up)
  GROUND:MoveToPosition(npc_npc_dogaasu, 176, 276, false, 2) -- Slide2PositionMark (glissement)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Up)
  GROUND:MoveToPosition(npc_npc_zubatto, 232, 276, false, 2) -- Slide2PositionMark (glissement)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Up)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_sukatanku, 204, 220, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_sukatanku, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sukatanku, 4) end)
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6410) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(30)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_sukatanku.Position; GROUND:MoveToPosition(npc_npc_sukatanku, p.X+(0), p.Y+(40), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_sukatanku, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sukatanku, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_sukatanku, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_sukatanku, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Here you go. A genuine\nPerfect Apple.", french="Et voilà. Une Pomme Parfaite\ntout ce qu'il y a de plus authentique.", german="Bitte schön. Ein echter\nPerfekter Apfel.", italian="Ecco qua. Una vera\nMela Perfetta.", spanish="Aquí tienes. Una auténtica\nManzana Perfecta."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Please accept it as our token\nof friendship.", french="Veuillez l'accepter en gage de\nnotre amitié.", german="Bitte nimm ihn als Zeichen\nunserer Freundschaft an.", italian="La offriamo come prova della\nnostra amicizia.", spanish="Acéptala como prueba de\nnuestra amistad."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Oh, wow! You went and got it\njust for me?!", french="Oh, waouh! Vous êtes allés la\nchercher rien que pour moi?!", german="Oh, wow! Ihr habt ihn extra für\nmich geholt?", italian="Oh, wow! Siete andati a\nprenderla solo per me?!", spanish="¡Oh, vaya!\n¡¿Habéis ido a buscarla para mí?!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Yay! Thank you! Friends!\nFriends!", french="Youhou! Merci! Cool! Copains\nde moi! Amis de moi!", german="Juchhu! Danke! Freunde!\nFreunde!", italian="Grande! Grazie! Amici!\nAmici!", spanish="¡Chachi! ¡Gracias!\n¡Amigos! ¡Amigos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_perappu, 220, 228, false, 2)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownLeft)
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Th-thank you so very,\nvery kindly!", french="C'est nous qui vous remercions!\nC'est très aimable à vous!", german="D-danke! Aus tiefstem Herzen,\ndanke! Danke!", italian=" G-Grazie mille!", spanish="Mu... muchas gracias,\n¡de verdad!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Thanks to you, we've all been\nspared a catastrophe!", french="Merci, grâce à vous nous avons\névité la catastrophe!", german="Dank euch bleibt uns eine\nKatastrophe erspart!", italian="Grazie a voi abbiamo evitato\nuna catastrofe!", spanish="¡Habéis conseguido evitar\nuna catástrofe!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.UpRight)
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Hey! You two! Quit dozing and\nshow your respect and appreciation!", french="Hé! Vous deux! Cessez de\nrêvasser et faites preuve de respect!", german="Hey! Ihr zwei! Wacht auf\nund zeigt etwas Respekt und Dankbarkeit!", italian="Ehi! Voi due! Smettetela di\ndormire e dimostrate la vostra gratitudine!", spanish="¡Y esos dos Pokémon! ¡Dejad\nde dormitar y mostrad un poco de respeto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_sukatanku, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sukatanku, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ungggh...", french=" Argh...", german=" Hrghhnnn...", italian=" Ungggh...", spanish=" Aaaaay..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ungggh...", french=" Argh...", german=" Hrghhnnn...", italian=" Ungggh...", spanish=" Aaaaay..."})
  else
  SkySceneKit.say({english=" Ungggh...", french=" Argh...", german=" Hrghhnnn...", italian=" Ungggh...", spanish=" Aaaaay..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Chaw-haw-haw. No, no, it's quite\nall right. After all, your guild has been very\ngenerous and hospitable to us.", french="Gnark gnark gnark! Non, non,\nce n'est rien. Après tout, votre Guilde a été\nsi généreuse et hospitalière avec nous.", german="Cha-ha-ha. Nein, nein, das ist\nschon in Ordnung. Eure Gilde war sehr\ngroßzügig und gastfreundlich zu uns.", italian="Ahr-ahr-ahr. No, no, va bene\ncosì. In fondo, la vostra Gilda è stata molto\ngenerosa e ospitale con noi.", spanish="Jua, jua, jua. No, no importa.\nAl fin y al cabo, vuestro [CS:N]Pokégremio[CR] nos ha\ntratado de forma muy generosa y hospitalaria."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="It's only right that we try to\nrepay that favor in our own way.", french="Il est tout naturel que nous\nvous rendions la pareille.", german="Es gehört sich, dass wir\nversuchen, uns auf unsere Weise zu\nrevanchieren.", italian="Ripagare il favore a modo\nnostro è il minimo che potessimo\nfare.", spanish="Lo justo es que tratemos de\ndevolver el favor de alguna forma."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Ah! I see that you're the most\nadmirable of Pokémon. ♪", french="Ah! Je constate que vous êtes\nle plus admirable des Pokémon. ♪", german="Ah! Wie ich sehe, gehört ihr\nzu den edelsten aller Pokémon. ♪", italian="Ah! Siete proprio dei\nPokémon per bene. ♪", spanish="¡Ah! Veo que sois unos Pokémon\nrealmente admirables. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="To be able to embark on an\nexpedition with someone so noble as you...", french="Pouvoir faire une expédition\naux côtés d'une personne aussi noble...", german="Mit so noblen Pokémon wie\neuch zu einer Expedition aufzubrechen...", italian="Partecipare a una spedizione\ninsieme a gente nobile come voi...", spanish="Es todo un lujo que alguien tan\nnoble como vosotros nos acompañe\nen la expedición."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" It will be truly inspiring!", french=" ... c'est un immense honneur!", german=" Das wird wahrhaft inspirierend!", italian="... sarà davvero fonte\nd'ispirazione!", spanish=" ¡Seréis toda una inspiración!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sukatanku, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_sukatanku, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Chaw-haw-haw. No, no! You will\nbe the ones who inspire us.", french="Gnark gnark gnark! Non, non!\nTout l'honneur est pour nous, voyons.", german="Cha-ha-ha. Aber nein! Ihr seid\ndiejenigen, die uns inspirieren werden.", italian="Ahr-ahr-ahr. No, no! Sarete voi\na ispirare noi.", spanish="Jua, jua, jua... No, para nada.\nVosotros sois los que nos vais a inspirar."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Truly, we look forward to our\nexpedition.", french="Nous attendons l'expédition\navec beaucoup d'impatience.", german="Oh ja, wir freuen uns auf die\nExpedition.", italian="Non vediamo davvero l'ora che\nquesta spedizione abbia inizio.", spanish="La verdad es que estamos\nesperando la expedición con muchas ganas."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="It's late now, so we'll be off\nto bed.", french="Il est tard à présent, nous\ndevrions aller nous coucher.", german="Da es schon spät ist, werden\nwir jetzt schlafen gehen.", italian="Si è fatto tardi, quindi adesso\nandiamo a dormire.", spanish="Ya es muy tarde, así que\nvamos a ir a acostarnos."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Until tomorrow then.\nChaw-haw-haw!", french=" A demain. Gnark gnark gnark!", german=" Bis morgen dann. Cha-ha-ha!", italian=" A domani. Ahr-ahr-ahr!", spanish="Entonces, ¡hasta mañana!\n¡Jua, jua, jua!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_sukatanku, 204, 380, false, 2)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Down)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Down)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_dogaasu, 176, 380, false, 2)
  GROUND:MoveToPosition(npc_npc_zubatto, 232, 380, false, 2)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Thank you! Good night! Friends!\nFriends!", french="Merci! Bonne nuit! Amis de moi!\nCopains de moi!", german="Vielen Dank! Gute Nacht!\nFreunde! Freunde!", italian="Grazie! Buonanotte! Amici!\nAmici!", spanish="¡Gracias! ¡Buenas noches!\n¡Amigos! ¡Amigos!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
end
