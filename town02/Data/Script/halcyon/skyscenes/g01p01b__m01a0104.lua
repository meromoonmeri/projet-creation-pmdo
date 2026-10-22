-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P01B/m01a0104.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P01A) [décor sub chargé: Sub_v02p01a]
  -- back_SetGround(LEVEL_G01P01B2) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_FIRE_CRACKLING_LOUDER non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Show("v02p01a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hmm...", french=" Hmm...", german=" Hmm...", italian=" Mmm...", spanish=" Hum..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hmm...", french=" Hmm...", german=" Hmm...", italian=" Mmm...", spanish=" Hum..."})
  else
  SkySceneKit.say({english=" Hmm...", french=" Hmm...", german=" Hmm...", italian=" Mmm...", spanish=" Uf..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(24), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-48), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(48), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-24), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="No.[K] I refuse to be paralyzed\nby this any longer!", french="Non.[K] Je ne veux plus me laisser\nparalyser par tout ça!", german="Nein.[K] Ich will nicht länger\nzur Untätigkeit verdammt sein!", italian="No.[K] Non posso continuare a\nrestarmene così. Devo fare qualcosa.", spanish="No.[K] ¡No debo dejar que esto me\nvuelva a asustar!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="No.[K] I refuse to be paralyzed\nby this any longer!", french="Non.[K] Je ne veux plus me laisser\nparalyser par tout ça!", german="Nein.[K] Ich will nicht länger\nzur Untätigkeit verdammt sein!", italian="No.[K] Non posso continuare a\nrestarmene così. Devo fare qualcosa.", spanish="No.[K] ¡No puedo permitir que esto\nsiga paralizándome!"})
  else
  SkySceneKit.say({english="No.[K] I refuse to be paralyzed\nby this any longer!", french="Non.[K] Je ne veux plus me laisser\nparalyser par tout ça!", german="Nein.[K] Ich will nicht länger\nzur Untätigkeit verdammt sein!", italian="No.[K] Non posso continuare a\nrestarmene così. Devo fare qualcosa.", spanish=" No.[K] ¡Estoy harta de tener miedo!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="No more wimping out. I have to\nbe brave today.", french="Je ne veux plus avoir peur.\nAujourd'hui, c'est décidé, je vais être\ncourageux!", german="Keine Ausreden mehr. Heute\nnehme ich meinen Mut zusammen.", italian="Basta fare il fifone. Oggi devo\navere coraggio.", spanish="Ya está bien de acobardarse.\nHoy tengo que ser valiente."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This is it. I have to steel my\ncourage today.", french="Je ne veux plus avoir peur.\nAujourd'hui, c'est décidé, je vais être\ncourageux!", german="Es ist so weit. Heute muss ich\nall meinen Mut aufbringen.", italian="È il momento. Oggi devo essere\ncoraggioso.", spanish="Ya está bien. Hoy voy a ser\nvaliente."})
  else
  SkySceneKit.say({english="This is it. Today I'm going to\nbe brave.", french="Je ne veux plus avoir peur.\nAujourd'hui, c'est décidé, je vais être\ncourageuse!", german="Es ist so weit. Heute nehme ich\nmeinen Mut zusammen.", italian="È il momento. Oggi devo essere\ncoraggiosa.", spanish="Ya está bien. Hoy voy a ser\nvaliente."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-24), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Pokémon detected! Pokémon detected!", french=" Pokémon détecté! Pokémon détecté!", german=" Pokémon entdeckt! Pokémon entdeckt!", italian=" Pokémon in arrivo! Pokémon in arrivo!", spanish=" ¡Pokémon detectado! ¡Pokémon detectado!"})
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Whose footprint? Whose footprint?", french="A qui appartient l'empreinte?\nA qui appartient l'empreinte?", german=" Wessen Fußabdruck? Wessen Fußabdruck?", italian="A chi corrisponde la forma della zampa?\nA chi corrisponde la forma della zampa?", spanish="¿De quién es la huella?\n¿De quién es la huella?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="The footprint is [c_kind:ATTENDANT1]'s![K]\nThe footprint is [c_kind:ATTENDANT1]'s!", french="C'est l'empreinte de [c_kind:ATTENDANT1]![K]\nC'est l'empreinte de [c_kind:ATTENDANT1]!", german="Der Fußabdruck ist von [c_kind:ATTENDANT1]![K]\nDer Fußabdruck ist von [c_kind:ATTENDANT1]!", italian="È la zampa di [c_kind:ATTENDANT1]![K]\nÈ la zampa di [c_kind:ATTENDANT1]!", spanish="¡La huella es de [c_kind:ATTENDANT1]![K]\n¡La huella es de [c_kind:ATTENDANT1]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(24), false, 2) end -- SlidePositionOffset
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waah!", french=" Aaah!", german=" Waah!", italian=" Waah!", spanish=" ¡Aaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah!", french=" Aaah!", german=" Waah!", italian=" Aaah!", spanish=" ¡Aaah!"})
  else
  SkySceneKit.say({english=" Waah!", french=" Aaah!", german=" Waah!", italian=" Aaah!", spanish=" ¡Aaah!"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- message_Close
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  SkySceneKit.spin(partner, 1, 1, 3)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(5)
  SkySceneKit.spin(partner, 1, 2, 5)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  SkySceneKit.spin(partner, 1, 1, 5)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(5)
  SkySceneKit.spin(partner, 1, 2, 4)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That shocked me!", french=" C'est trop stressant!", german=" Bin ich erschrocken!", italian=" Che shock!", spanish=" ¡Qué susto me he llevado!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That was too shocking!", french=" C'est trop stressant!", german="Das hat mir vielleicht einen\nSchreck eingejagt!", italian=" Che spavento!", spanish=" ¡Menudo susto!"})
  else
  SkySceneKit.say({english=" That shocked me!", french=" C'est trop stressant!", german=" Bin ich erschrocken!", italian=" Che spavento!", spanish=" ¡Qué susto me he llevado!"})
  end
  -- message_Close
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whew...", french=" Euh...", german=" Puh...", italian=" Fiuu...", spanish=" Vaya..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Whew...", french=" Euh...", german=" Puh...", italian=" Fiuu...", spanish=" Vaya..."})
  else
  SkySceneKit.say({english=" Whew...", french=" Euh...", german=" Puh...", italian=" Fiuu...", spanish=" Ay..."})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="...[K]I can't...[K] I can't push myself\nto go in after all.", french="...[K] Je n'y arrive pas...\nFinalement, je n'arrive pas à trouver\nle courage d'entrer...", german="...[K]Ich...[K] Ich kann mich doch\nnicht überwinden, reinzugehen.", italian="...[K] Non riesco...[K] Non riesco a\ntrovare il coraggio di entrare.", spanish="No...[K] No puedo...[K] No soy capaz\nde entrar."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="...[K]I can't...[K] I can't work up the\ncourage to go in, after all...", french="...[K] Je n'y arrive pas...\nFinalement, je n'arrive pas à trouver\nle courage d'entrer...", german="...[K]Ich...[K] Ich bin einfach zu feige,\num hineinzugehen...", italian="...[K] Non riesco...[K] Non riesco a\ntrovare il coraggio di entrare.", spanish="No...[K] No puedo...[K] No soy capaz\nde entrar."})
  else
  SkySceneKit.say({english="...[K]I can't...[K] I can't bring myself\nto go in.", french="...[K] Je n'y arrive pas...\nFinalement, je n'arrive pas à trouver\nle courage d'entrer...", german="...[K]Ich...[K] Ich traue mich einfach\nnicht...", italian="...[K] Non riesco...[K] Non riesco a\ntrovare il coraggio di entrare.", spanish="No...[K] No puedo...[K] No soy capaz\nde entrar."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I said to myself that this is the\nday, but...", french="Je me disais qu'aujourd'hui,\nce serait le grand jour, mais...", german="Ich habe mir eingeredet, heute\nsei es so weit, aber...", italian="Mi ero ripromesso che oggi ce\nl'avrei fatta...", spanish="Me dije que hoy lo conseguiría,\npero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I told myself that this is the\nday, but...", french="Je me disais qu'aujourd'hui,\nce serait le grand jour, mais...", german="Ich habe mir eingeredet, heute\nsei es so weit, aber...", italian="Pensavo che oggi ce l'avrei\nfatta, ma...", spanish="Creía que hoy lo conseguiría,\npero..."})
  else
  SkySceneKit.say({english="I vowed that I would do it\ntoday, but...", french="Je me disais qu'aujourd'hui,\nce serait le grand jour, mais...", german="Ich habe mir fest vorgenommen,\nes heute zu tun, aber...", italian="Mi ero ripromessa che oggi ci\nsarei riuscita, ma...", spanish="Pensaba que hoy lo conseguiría,\npero..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6410) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(15)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(8), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetGround(V01P06B) [décor sub chargé: Sub_v01p06b]
  -- camera2_SetPositionMark(Position<'m0', 21, 15>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v01p06b", 15, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I thought that holding on to my\npersonal treasure would inspire me...", french="Je pensais que mon cher trésor\nm'aiderait à franchir le pas...", german="Ich dachte, es würde mir helfen,\nmeinen Schatz mitzunehmen...", italian="Pensavo che avere con me il mio\ntesoro personale mi avrebbe aiutato, ma...", spanish="Creía que llevar mi talismán\nme inspiraría."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I thought that holding on to my\npersonal treasure would inspire me...", french="Je pensais que mon cher trésor\nm'aiderait à franchir le pas...", german="Ich dachte, es würde mir helfen,\nmeinen Schatz mitzunehmen...", italian="Pensavo che avere con me il mio\ntesoro personale mi avrebbe aiutato, ma...", spanish="Creía que llevar mi talismán\nme inspiraría."})
  else
  SkySceneKit.say({english="I thought that holding on to my\npersonal treasure would inspire me...", french="Je pensais que mon cher trésor\nm'aiderait à franchir le pas...", german="Ich dachte, es würde mir helfen,\nmeinen Schatz mitzunehmen...", italian="Pensavo che avere con me il mio\ntesoro personale mi avrebbe aiutata, ma...", spanish="Creía que llevar mi talismán\npodría inspirarme."})
  end
  -- message_Close
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetGround(V02P01A) [décor sub chargé: Sub_v02p01a]
  SkySubScreen.Show("v02p01a", 15, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(15)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(8), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But I just can't do it.", french=" Pfff... Il n'y a rien à faire.", german=" Aber ich kann es einfach nicht.", italian=" ... proprio non ce la faccio.", spanish="Pero es demasiado para mí.\nNo puedo hacerlo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Sigh...I just can't do it.", french=" Pfff... Il n'y a rien à faire.", german="Seufz... Ich kann es einfach\nnicht tun.", italian=" ... proprio non ce la faccio.", spanish=" Pero no puedo hacerlo."})
  else
  SkySceneKit.say({english=" Sigh...I just can't do it.", french=" Pfff... Il n'y a rien à faire.", german="Seufz... Ich kann es einfach\nnicht tun.", italian=" ... proprio non ce la faccio.", spanish=" Pero es inútil. No puedo hacerlo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I'm such a coward...", french=" Je ne suis qu'un poltron...", german=" Ich bin ein solcher Feigling...", italian=" Sono un tale codardo...", spanish=" Soy un cobardica."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I'm such a coward...", french=" Je ne suis qu'un poltron...", german=" Ich bin ein solcher Feigling...", italian=" Sono un tale codardo...", spanish=" Soy un cobardica."})
  else
  SkySceneKit.say({english=" I'm such a coward...", french=" Je ne suis qu'une poltronne...", german=" Ich bin ein solcher Feigling...", italian=" Sono una tale fifona...", spanish=" Soy una cobardica."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" This is so discouraging...", french=" C'est vraiment décourageant...", german=" Das ist ja so entmutigend...", italian=" È così scoraggiante...", spanish=" Esto me desmoraliza."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" This is so discouraging...", french=" C'est vraiment décourageant...", german=" Das ist ja so entmutigend...", italian=" È così scoraggiante...", spanish=" ¡Qué desastre!"})
  else
  SkySceneKit.say({english=" This is so discouraging...", french=" C'est vraiment décourageant...", german=" Das ist ja so entmutigend...", italian=" È così scoraggiante...", spanish=" No sé qué voy a hacer..."})
  end
  -- message_Close
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(200), false, 2) end
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(104), 149, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(90)
  -- supervision_Acting(1) [neutre/état moteur]
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 160, 184, Direction.Right, "NPC_ZUBATTO")
  -- SetAnimation(5) [anim idle native]
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 136, 184, Direction.Right, "NPC_DOGAASU")
  -- SetOutputAttribute(8) [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-88), 88, false) end) -- MovePositionOffset performer/caméra
  GROUND:MoveToPosition(npc_npc_zubatto, 256, 200, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_dogaasu, 224, 200, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_zubatto, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Hey, [CS:N]Zubat[CR].[K] Did you get a load of that?!", french=" Hé, [CS:N]Nosferapti[CR]![K] T'as vu ça?!", german=" Hey, [CS:N]Zubat[CR].[K] Hast du das mitbekommen?!?", italian=" Ehi, [CS:N]Zubat[CR]![K] Hai visto?!", spanish="Eh, [CS:N]Zubat[CR]...[K] ¡¿Lo has oído?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" You bet I did, [CS:N]Koffing[CR].", french=" Bien sûr que oui, [CS:N]Smogo[CR].", german="Darauf kannst du wetten,\n[CS:N]Smogon[CR].", italian=" Certo che ho visto, [CS:N]Koffing[CR].", spanish=" Y bien que lo he oído, [CS:N]Koffing[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="That little wimp that was pacing\naround...[K]had something good, right?", french="Cette petite mauviette qui vient\nde passer...[K] elle avait quelque chose\nqui pourrait nous intéresser, hein?", german="Dieser kleine Schlaffi, der sich\nhier herumgedrückt hat...[K] Der hatte etwas\nInteressantes dabei, wie?", italian="Quella nullità...[K] aveva con sé\nqualcosa di interessante, vero?", spanish="Ese Pokémon enclenque que\nandaba dando vueltas por aquí...[K] llevaba\nalgo interesante, ¿verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="That wimp had something, that's\nfor sure.[K] It looked like some kind of treasure.", french="Ouaip, cette mauviette tenait\nquelque chose, ça c'est sûr.[K] On aurait dit\nune sorte de trésor.", german="Ganz genau.[K] Und es sah aus wie\neine Art Schatz.", italian="Sì, aveva sicuramente\nqualcosa.[K] Sembrava una specie di tesoro.", spanish="Se veía perfectamente que\nllevaba algo.[K] Parecía valioso."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogaasu, npc_npc_zubatto, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Do we go after it?", french=" On y va?", german=" Gehen wir hinterher?", italian=" Proviamo a vedere dove va?", spanish=" ¿Le seguimos?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zubatto, npc_npc_dogaasu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" We do.", french=" On y va.", german=" Na klar.", italian=" Certo.", spanish=" Venga."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  do local p=npc_npc_dogaasu.Position; GROUND:MoveToPosition(npc_npc_dogaasu, p.X+(0), p.Y+(180), false, 2) end
  GAME:WaitFrames(15)
  do local p=npc_npc_zubatto.Position; GROUND:MoveToPosition(npc_npc_zubatto, p.X+(0), p.Y+(180), false, 2) end
  GAME:WaitFrames(90)
  pcall(function() SOUND:FadeOutBGM(120) end)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
