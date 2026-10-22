-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D30P32A/m26a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(............)", french="(............)", german="(............)", italian="(............)", spanish="(...)"})
  else
  SkySceneKit.say({english="(............)", french="(............)", german="(............)", italian="(............)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  else
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(........................)", french="(........................)", german="(........................)", italian="(........................)", spanish="(...)"})
  else
  SkySceneKit.say({english="(........................)", french="(........................)", german="(........................)", italian="(........................)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...Ugh...)", french="(... Argh...)", german="(Uff...)", italian="(... Uh...)", spanish="(Ay...)"})
  else
  SkySceneKit.say({english="(...Ugh...)", french="(... Argh...)", german="(Uff...)", italian="(... Uh...)", spanish="(Ay...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Urk...[K] Th-this is...)", french="(Argh...[K] Qu'est-ce que...)", german="(Umpf...[K] D-das ist...)", italian="(Ah...[K] Q-Questa è...)", spanish="(Uf...[K] Esto... Esto es...)"})
  else
  SkySceneKit.say({english="(Urk...[K] Th-this is...)", french="(Argh...[K] Qu'est-ce que...)", german="(Umpf...[K] D-das ist...)", italian="(Ah...[K] Q-Questa è...)", spanish="(Uf...[K] Esto... Esto es...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D30P32A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(76) [anim idle native]
  -- SetAnimation(76) [anim idle native]
  GAME:FadeIn(60)
  GAME:WaitFrames(60)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Wh-where...?)", french="(Mais où...?)", german="(W-wo?)", italian="(D-Dove...?)", spanish="(¿Pero dónde...?)"})
  else
  SkySceneKit.say({english="(Wh-where...?)", french="(Mais où...?)", german="(W-wo?)", italian="(D-Dove...?)", spanish="(¿Pero dónde...?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner]...)", french="([partner]...)", german="([partner]...)", italian="([partner]...)", spanish="([partner]...)"})
  else
  SkySceneKit.say({english="([partner]...)", french="([partner]...)", german="([partner]...)", italian="([partner]...)", spanish="([partner]...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-24), 24, false) end) -- MovePositionOffset performer/caméra
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-16), p.Y+(-16), false, 2) end
  GROUND:MoveToPosition(hero, 284, 236, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...[K]Ugh...[K] Urrgh...", french=" ...[K] Argh...[K] Aaargh...", german=" ...[K]Uff...[K] Umpf...", italian=" ...[K] Uh...[K] Ufff...", spanish=" Ay...[K] Ay...[K] Uf..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...[K]Ugh...[K] Urrgh...", french=" ...[K] Argh...[K] Aaargh...", german=" ...[K]Uff...[K] Umpf...", italian=" ...[K] Uh...[K] Ufff...", spanish=" Ay...[K] Ay...[K] Uf..."})
  else
  SkySceneKit.say({english=" ...[K]Ugh...[K] Urrgh...", french=" ...[K] Argh...[K] Aaargh...", german=" ...[K]Uff...[K] Umpf...", italian=" ...[K] Uh...[K] Ufff...", spanish=" Ay...[K] Ay...[K] Uf..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey...[K] [hero]...", french=" Eh...[K] [hero]...", german=" Hey...[K] [hero]...", italian=" Ehi...[K] [hero]...", spanish=" Oye...[K] [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey...[K] [hero]...", french=" Eh...[K] [hero]...", german=" Hey...[K] [hero]...", italian=" Ehi...[K] [hero]...", spanish=" Oye...[K] [hero]."})
  else
  SkySceneKit.say({english=" Oh...[K] [hero]...", french=" Eh...[K] [hero]...", german=" Oh...[K] [hero]...", italian=" Oh...[K] [hero]...", spanish=" Oye...[K] [hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-where...?", french=" Où...?", german=" W-wo?", italian=" D-Dove...?", spanish=" ¿Dónde...?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-where...?", french=" Où...?", german=" W-wo?", italian=" D-Dove...?", spanish=" ¿Dónde...?"})
  else
  SkySceneKit.say({english=" Wh-where...?", french=" Où...?", german=" W-wo?", italian=" D-Dove...?", spanish=" ¿Dónde...?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(1) [neutre/état moteur]
  local npc_npc_diaruga = SkySceneKit.spawn_npc("dialga", 280, 376, Direction.Up, "NPC_DIARUGA")
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end) -- message_SetActor(ACTOR_NPC_DIARUGA)
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english=" THIS IS...[K][CS:P]TEMPORAL TOWER[CR].", french="VOUS ETES... [K]A LA [CS:P]TOUR\nDU TEMPS[CR].", german="DIES IST...[K]\nDER [CS:P]ZEITTURM[CR].", italian="QUESTA È...[K] LA [CS:P]TORRE DEL[CR]\n[CS:P]TEMPO[CR].", spanish="ESTO ES...[K] SÍ... ESTO ES LA\n[CS:P]TORRE DEL TIEMPO[CR]."})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(276, 348, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:MoveToPosition(hero, 292, 284, false, 2)
  GROUND:MoveToPosition(partner, 260, 284, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wah! [CS:N]Dialga[CR]!", french=" Ouah! [CS:N]Dialga[CR]!", german=" Wah! [CS:N]Dialga[CR]!", italian=" Aah! [CS:N]Dialga[CR]!", spanish=" ¡Aaah! ¡[CS:N]Dialga[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wah! [CS:N]Dialga[CR]!", french=" Ouah! [CS:N]Dialga[CR]!", german=" Wah! [CS:N]Dialga[CR]!", italian=" Aah! [CS:N]Dialga[CR]!", spanish=" ¡Aaah! ¡[CS:N]Dialga[CR]!"})
  else
  SkySceneKit.say({english=" Wah! [CS:N]Dialga[CR]!", french=" Ouah! [CS:N]Dialga[CR]!", german=" Wah! [CS:N]Dialga[CR]!", italian=" Aah! [CS:N]Dialga[CR]!", spanish=" ¡Aaah! ¡[CS:N]Dialga[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="YOU HAVE NO CAUSE FOR\nALARM.[K] I HAVE REGAINED MY REASON.", french="N'AYEZ AUCUNE CRAINTE.[K]\nJ'AI RETROUVE MES ESPRITS.", german="KEIN ANLASS ZUR PANIK.[K]\nICH BIN ZUR VERNUNFT GEKOMMEN.", italian="NON DOVETE ALLARMARVI.[K]\nHO RIACQUISTATO LA RAGIONE.", spanish="NO OS PREOCUPÉIS.[K]\nHE RECUPERADO LA RAZÓN."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?", french=" Pardon?", german=" Hä?", italian=" Eh?", spanish=" ¿Cómo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?", french=" Pardon?", german=" Was?", italian=" Cosa?", spanish=" ¿Cómo?"})
  else
  SkySceneKit.say({english=" What?", french=" Pardon?", german=" Was?", italian=" Cosa?", spanish=" ¿Cómo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="[CS:P]TEMPORAL TOWER[CR] HAS TAKEN\nHEAVY DAMAGE...", french="LA [CS:P]TOUR DU TEMPS[CR] A SUBI\nD'ENORMES DEGATS...", german="DER [CS:P]ZEITTURM[CR] HAT SCHWEREN\nSCHADEN GENOMMEN...", italian="LA [CS:P]TORRE DEL TEMPO[CR] HA SUBITO\nGRAVI DANNI...", spanish="LA [CS:P]TORRE DEL TIEMPO[CR] HA\nSUFRIDO DAÑOS CONSIDERABLES..."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english=" BUT IT HAS SURVIVED.", french=" MAIS ELLE A SURVECU.", german=" ABER ER HAT ES ÜBERSTANDEN.", italian=" MA È ANCORA IN PIEDI.", spanish=" PERO HA AGUANTADO."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english=" NOW, OBSERVE.", french=" A PRESENT, REGARDEZ.", german="SEHT ZU BEI DEM, WAS JETZT\nGESCHIEHT.", italian=" ORA, OSSERVATE.", spanish=" OBSERVAD."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_diaruga, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  -- GAP: se_Play(8458) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeOut(true, 60) -- screen_WhiteOut
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
end
