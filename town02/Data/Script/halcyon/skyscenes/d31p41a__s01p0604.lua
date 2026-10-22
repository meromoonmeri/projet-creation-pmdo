-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D31P41A/s01p0604.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  -- back_SetGround(LEVEL_D31P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 312, 184, Direction.Up, "NPC_PERAPPU")
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:ResetSpeaker() end)
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:N]Minion[CR]: Arrgh! What a farce...", french="[CS:N]Sbire[CR]: Aaaah! Mais quel empoté...", german="[CS:N]Untergebener[CR]: Arrgh! Was für eine Farce...", italian="[CS:N]Sgherro[CR]: Arrgh! Che farsa...", spanish="[CS:N]Secuaz[CR]: ¡Anda, anda! ¡Qué chapuza!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, [CS:N]Wigglytuff[CR].[K] Can you tell us\nwhat's going on?", french="Hé, [CS:N]Grodoudou[CR].[K] Vous pouvez\nnous expliquer ce qui se passe?", german="Hey, [CS:N]Knuddeluff[CR].[K] Kannst du uns\nsagen, was hier los ist?", italian="Ehi, [CS:N]Wigglytuff[CR],[K] puoi dirci cosa\nsta succedendo?", spanish="Oye, [CS:N]Wigglytuff[CR].[K] ¿Puedes\nexplicarnos qué está pasando?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Listen, [CS:N]Wigglytuff[CR].[K] Can you\nplease tell us what's going on?", french="Hé, [CS:N]Grodoudou[CR].[K] Vous pouvez\nnous expliquer ce qui se passe?", german="Hör mal, [CS:N]Knuddeluff[CR].[K] Kannst du\nuns bitte sagen, was hier vor sich geht?", italian="Ehi, [CS:N]Wigglytuff[CR],[K] puoi dirci cosa\nsta succedendo?", spanish="Oye, [CS:N]Wigglytuff[CR].[K] ¿Puedes\nexplicarnos qué está pasando?"})
  else
  SkySceneKit.say({english="Say, [CS:N]Wigglytuff[CR].[K] Please, can you\ntell us what's going on?", french="Hé, [CS:N]Grodoudou[CR].[K] Vous pouvez\nnous expliquer ce qui se passe?", german="Sag mal, [CS:N]Knuddeluff[CR].[K] Kannst du\nuns bitte sagen, was hier vor sich geht?", italian="Ehi, [CS:N]Wigglytuff[CR],[K] puoi dirci cosa\nsta succedendo?", spanish="Oye, [CS:N]Wigglytuff[CR].[K] ¿Puedes\nexplicarnos qué está pasando?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 280, 176, Direction.Down, "NPC_PUKURIN")
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_pukurin, 4) end)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 248, 184, Direction.DownRight, "NPC_DOGOOMU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_pukurin, 4) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 336, 208, Direction.DownLeft, "NPC_KIMAWARI")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_pukurin, 4) end)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 320, 240, Direction.UpLeft, "NPC_DIGUDA")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_pukurin, 4) end)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 224, 240, Direction.UpRight, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_pukurin, 4) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 296, 256, Direction.Up, "NPC_CHIRIIN")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_pukurin, 4) end)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 256, 256, Direction.Up, "NPC_GUREGGURU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_pukurin, 4) end)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 224, 208, Direction.DownRight, "NPC_HEIGANI")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() UI:ResetSpeaker() end)
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:N]Grand Master[CR]: ...[K]Who's...[K][CS:N]Wigglytuff[CR]?", french="[CS:N]Grand maître[CR]: ...[K] Qui est...[K] ce [CS:N]Grodoudou[CR]?", german="[CS:N]Großmeister[CR]: ...[K]Wer...[K] ist [CS:N]Knuddeluff[CR]?", italian="[CS:N]Sua Malvagità[CR]: ...[K] Chi è...[K] [CS:N]Wigglytuff[CR]?", spanish="[CS:N]Gran malo[CR]: Hum... [K]¿Quién es...?[K]\n¿Quién es [CS:N]Wigglytuff[CR]?"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?!", french=" Quoi?!", german=" Ähem?!?", italian=" Eh?!", spanish=" ¿Qué?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¿Cómo?"})
  else
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¿Qué?"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_THE_POWER_OF_DARKNESS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:ResetSpeaker() end)
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:N]Grand Master[CR]: I am the grand master.[K] I know\nnothing of your so-called [CS:N]Wigglytuff[CR].", french="[CS:N]Grand maître[CR]: Je suis le grand maître.[K]\nJ'ignore tout de celui que vous appelez\n[CS:N]Grodoudou[CR].", german="[CS:N]Großmeister[CR]: Ich bin der Großmeister.[K]\nMir ist nichts von einem sogenannten\n[CS:N]Knuddeluff[CR] bekannt.", italian="[CS:N]Sua Malvagità[CR]: Io sono Sua Malvagità.[K]\nNon so niente del vostro cosiddetto [CS:N]Wigglytuff[CR].", spanish="[CS:N]Gran malo[CR]: Yo soy el gran malo.[K] No sé quién\nes ese [CS:N]Wigglytuff[CR] del que hablas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whaaat?!", french=" Quoiii?!", german=" Waaaas?!?", italian=" Cooosa?!", spanish=" ¡¿Quéee?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Whaaat?!", french=" Quoiii?!", german=" Waaaas?!?", italian=" Cooosa?!", spanish=" ¡¿Quéee?!"})
  else
  SkySceneKit.say({english=" Whaaat?!", french=" Quoiii?!", german=" Waaaas?!?", italian=" Cooosa?!", spanish=" ¡¿Quéee?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownRight)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_diguda, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Up)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  GROUND:EntTurn(npc_npc_heigani, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:ResetSpeaker() end)
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:N]Minion[CR]: Uh...[K]that's right![K] And we're the\ngrand master's minions!", french="[CS:N]Sbire[CR]: Euh...[K] c'est vrai![K] Et nous\nsommes les serviteurs du grand maître!", german="[CS:N]Untergebener[CR]: Äh...[K] Stimmt![K] Und wir sind des\nGroßmeisters Untergebene!", italian="[CS:N]Sgherro[CR]: Eh...[K] esatto![K] E noi siamo gli\nsgherri di Sua Malvagità!", spanish="[CS:N]Secuaz[CR]: Eh...[K] ¡Exacto![K] ¡Y nosotros somos\nsus secuaces!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.Right)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:N]Minion[CR]: Oh my gosh! That is so right![K] I don't\nknow any Pokémon named [CS:N]Sunflora[CR]!", french="[CS:N]Sbire[CR]: Ben mince alors! Je suis trop d'accord![K]\nEt puis je ne connais aucun Pokémon qui\ns'appelle [CS:N]Héliatronc[CR]!", german="[CS:N]Untergebene[CR]: Auweia! Das ist so was von\nrichtig![K] Ich kenne überhaupt kein Pokémon\nnamens [CS:N]Sonnflora[CR]!", italian="[CS:N]Sgherro[CR]: Shock! È proprio così![K] Non conosco\nnessun Pokémon chiamato [CS:N]Sunflora[CR]!", spanish="[CS:N]Secuaz[CR]: ¡Sí! ¡Y que lo digas![K] ¡No conozco\na ninguna [CS:N]Sunflora[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.UpLeft)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:N]Minion[CR]: Hey, hey, hey!", french="[CS:N]Sbire[CR]: Eh dis donc!", german="[CS:N]Untergebener[CR]: Hey, hey, hey!", italian="[CS:N]Sgherro[CR]: Ehi, ehi, ehi!", spanish="[CS:N]Secuaz[CR]: ¡Oye, oye, oye!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-what's going on here?!", french="Mais... mais qu'est-ce qui\nse passe ici, à la fin?!", german=" W-was läuft denn hier?!?", italian=" C-Cosa sta succedendo qui?!", spanish=" ¡¿Qué está ocurriendo aquí?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-what's going on here?!", french="Mais... mais qu'est-ce qui\nse passe ici, à la fin?!", german=" W-was läuft denn hier?!?", italian=" C-Cosa sta succedendo qui?!", spanish=" ¡¿Qué está ocurriendo aquí?!"})
  else
  SkySceneKit.say({english=" Wh-what's going on here?!", french="Mais... mais qu'est-ce qui\nse passe ici, à la fin?!", german=" W-was läuft denn hier?!?", italian=" C-Cosa sta succedendo qui?!", spanish=" ¡¿Qué está ocurriendo aquí?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:N]Grand Master[CR]: Coming to our lair is the last\nmistake you will ever make.[K] You're not\nwalking out of here.", french="[CS:N]Grand maître[CR]: Pénétrer dans notre repaire\nsera votre dernière erreur.[K] Vous ne quitterez\njamais ces lieux.", german="[CS:N]Großmeister[CR]: In unsere Höhle zu kommen, war\neuer letzter Fehler.[K] Hier kommt ihr nicht\nmehr heraus.", italian="[CS:N]Sua Malvagità[CR]: Venire qui è stato il vostro\nultimo errore.[K] Non uscirete mai di qui.", spanish="[CS:N]Gran malo[CR]: Venir a nuestra guarida ha sido una\nidea malísima.[K] No saldréis de aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:ResetSpeaker() end)
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:N]Grand Master[CR]: Prepare to face the terror that\nis the grand master of all things bad!", french="[CS:N]Grand maître[CR]: Préparez-vous à faire face à la\nterreur qu'on appelle le grand maître de tous\nles maux!", german="[CS:N]Großmeister[CR]: Bereitet euch darauf vor, das\nGrauen zu erleben, das vom Großmeister allen\nÜbels ausgeht!", italian="[CS:N]Sua Malvagità[CR]: Preparatevi ad affrontare\nSua Malvagità!", spanish="[CS:N]Gran malo[CR]: ¡Preparaos para luchar contra el\ngran malo requetemalo!"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:N]Grand Master[CR]: YOOM...TAH!", french="[CS:N]Grand maître[CR]: TA-DAAA!", german="[CS:N]Großmeister[CR]: LUUUU... FIIII!", italian="[CS:N]Sua Malvagità[CR]: BADABUM!", spanish="[CS:N]Gran malo[CR]: ¡Ami...! Digo... secuaces..."})
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:FadeOutBGM(10) end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  -- message_CloseEnforce
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(5136) — id SE NDS sans portage PMDO identifié
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
