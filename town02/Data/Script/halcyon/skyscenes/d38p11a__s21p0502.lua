-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D38P11A/s21p0502.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D38P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: se_Play(8201) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_H02P99C4_119) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  -- supervision_Acting(2) [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(1)
  -- SetOutputAttribute(2) [neutre/état moteur]
  GAME:WaitFrames(30)
  -- GAP: se_Play(5128) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '2')
  GAME:FadeIn(15)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  -- GAP: BGM BGM_SEALED_RUIN_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-where is this...?", french=" Où sommes-nous...?", german=" W-wo sind wir hier?", italian=" D-Dove siamo...?", spanish=" Pe... pero dónde..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-where is this...?", french=" Où sommes-nous...?", german=" W-wo sind wir hier?", italian=" D-Dove siamo...?", spanish=" Pe... pero dónde..."})
  else
  SkySceneKit.say({english=" Wh-where is this...?", french=" Où sommes-nous...?", german=" W-wo sind wir hier?", italian=" D-Dove siamo...?", spanish=" Pe... pero dónde..."})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_parukia = SkySceneKit.spawn_npc("palkia", 208, 144, Direction.Right, "NPC_PARUKIA")
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="THIS IS MY DOMAIN![K]\n[CS:P]SPACIAL RIFT[CR]!", french="CECI EST MON TERRITOIRE![K]\nLA [CS:P]FAILLE SPATIALE[CR]!", german="DIES IST MEIN\nHERRSCHAFTSGEBIET! DIE[K] [CS:P]RAUMSPALTE[CR]!", italian="QUESTO È IL MIO REGNO![K]\nLA [CS:P]VALLE DIMENSIONALE[CR]!", spanish="¡ESTOS SON MIS DOMINIOS![K]\n¡LA [CS:P]GRIETA ESPACIAL[CR]!"})
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_parukia, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_parukia, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitSe
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?![K] This is [CS:P]Spacial Rift[CR]?!", french="Quoi?![K] Nous sommes dans\nla [CS:P]Faille Spatiale[CR]?!", german="Was?!?[K] Das ist die\n[CS:P]Raumspalte[CR]?!?", italian="Cosa?![K] Questa è la [CS:P]Valle[CR]\n[CS:P]Dimensionale[CR]?!", spanish=" ¡¿Qué?![K] ¡¿La [CS:P]Grieta Espacial[CR]?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?![K] This is [CS:P]Spacial Rift[CR]?!", french="Quoi?![K] Nous sommes dans\nla [CS:P]Faille Spatiale[CR]?!", german="Was?!?[K] Das ist die\n[CS:P]Raumspalte[CR]?!?", italian="Cosa?![K] Questa è la [CS:P]Valle[CR]\n[CS:P]Dimensionale[CR]?!", spanish=" ¡¿Qué?![K] ¡¿La [CS:P]Grieta Espacial[CR]?!"})
  else
  SkySceneKit.say({english=" What?![K] This is [CS:P]Spacial Rift[CR]?!", french="Quoi?![K] Nous sommes dans\nla [CS:P]Faille Spatiale[CR]?!", german="Was?!?[K] Das ist die\n[CS:P]Raumspalte[CR]?!?", italian="Cosa?![K] Questa è la [CS:P]Valle[CR]\n[CS:P]Dimensionale[CR]?!", spanish=" ¡¿Qué?![K] ¡¿La [CS:P]Grieta Espacial[CR]?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="YOU DARE DISTORT SPACE?\nWITHOUT MY PERMISSION?", french="VOUS AVEZ OSE DISTORDRE\nL'ESPACE SANS MA PERMISSION!", german="IHR WAGT ES, OHNE MEINE\nERLAUBNIS DEN RAUM ZU VERZERREN?", italian="OSATE DISTORCERE LO SPAZIO?\nSENZA IL MIO PERMESSO?", spanish="¿OSÁIS DEFORMAR EL ESPACIO\nSIN MI PERMISO?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" I WILL BE RID OF YOU NOW!", french="JE M'EN VAIS VOUS ELIMINER\nSUR-LE-CHAMP!", german="ICH WERDE MICH EURER JETZT\nENTLEDIGEN!", italian=" È SCOCCATA LA VOSTRA ORA!", spanish=" ¡AHORA VERÉIS!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  else
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_parukia.Position; GROUND:MoveToPosition(npc_npc_parukia, p.X+(16), p.Y+(0), false, 2) end
  GAME:WaitFrames(10)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(16), g.ViewCenter.Y+(0), 16, false) end) -- MovePositionOffset performer/caméra
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(16), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(5)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(16), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" THIS IS THE END!", french=" VOTRE HEURE A SONNE!", german=" DAS IST DAS ENDE!", italian=" PER VOI È LA FINE!", spanish=" ¡HA LLEGADO VUESTRA HORA!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_parukia.Position; GROUND:MoveToPosition(npc_npc_parukia, p.X+(16), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(12) [anim idle native]
  -- GAP: se_Play(6421) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(24), g.ViewCenter.Y+(0), 10, false) end) -- MovePositionOffset performer/caméra
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(24), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(24), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa! What are you doing?!", french=" Ouah! Qu'est-ce que tu fais?!", german=" Uah! Was machst du?!?", italian=" Ehi! Cosa stai facendo?!", spanish=" ¡Ah! ¿Qué estás haciendo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah! What are you doing?!", french=" Ouah! Qu'est-ce que tu fais?!", german=" Uah! Was machst du?!?", italian=" Aaah! Cosa stai facendo?!", spanish=" ¡Ah! ¿Qué estás haciendo?"})
  else
  SkySceneKit.say({english=" Waah! What are you doing?!", french=" Ouah! Qu'est-ce que tu fais?!", german=" Uah! Was machst du?!?", italian=" Aaah! Cosa stai facendo?!", spanish=" ¡Ah! ¿Qué estás haciendo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  do local p=npc_npc_parukia.Position; GROUND:MoveToPosition(npc_npc_parukia, p.X+(16), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Th-there's absolutely nothing\nbehind us!", french=" On n'a nulle part où se réfugier!", german=" H-hinter uns ist absolut nichts!", italian="N-Non c'è assolutamente nulla\ndietro di noi!", spanish=" ¡No hay nada detrás de nosotros!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Th-there's absolutely nothing\nbehind us!", french=" On n'a nulle part où se réfugier!", german=" H-hinter uns ist absolut nichts!", italian="N-Non c'è assolutamente nulla\ndietro di noi!", spanish=" ¡No hay nada detrás de nosotros!"})
  else
  SkySceneKit.say({english="Th-there's absolutely nothing\nbehind us!", french=" On n'a nulle part où se réfugier!", german=" H-hinter uns ist absolut nichts!", italian="N-Non c'è assolutamente nulla\ndietro di noi!", spanish=" ¡No hay nada detrás!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_parukia, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_parukia, 4) end)
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" GRRR-OOOOOO!", french=" GRRR-OOOOOO!", german=" GRRR-OOOOOO!", italian=" GRRR-OOOOOO!", spanish=" ¡GRRR!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(90)
  -- message_CloseEnforce
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- SetAnimation(2) [anim idle native]
  do local p=npc_npc_parukia.Position; GROUND:MoveToPosition(npc_npc_parukia, p.X+(24), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6421) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(12) [anim idle native]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(24), g.ViewCenter.Y+(0), 10, false) end) -- MovePositionOffset performer/caméra
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(32), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(32), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaaaaah!", french=" Ouaaah!", german=" Uaaaaaah!", italian=" Waaaaaah!", spanish=" ¡Aaaaaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaaaaah!", french=" Ouaaah!", german=" Uaaaaaah!", italian=" Aaaaaaah!", spanish=" ¡Aaaaaah!"})
  else
  SkySceneKit.say({english=" Waaaaaah!", french=" Ouaaah!", german=" Uaaaaaah!", italian=" Aaaaaaah!", spanish=" ¡Aaaaaah!"})
  end
  -- MoveHeight(5, -80) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(5, -80) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(90)
  -- message_CloseEnforce
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" GRRRR![K] THEY FELL!", french="GRRRR![K] LES PROFANATEURS\nONT CHU!", german=" GRRRR![K] SIE SIND GEFALLEN!", italian="GRRRR![K] HANNO FATTO UN\nPASSO DI TROPPO!", spanish=" ¡GRRRR![K] ¡SE HAN CAÍDO!"})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="HOWEVER...[K]THERE IS NO\nESCAPING ME!", french="QU'IMPORTE...[K] NUL NE PEUT\nM'ECHAPPER!", german="ABER...[K] VOR MIR GIBT ES KEIN\nENTRINNEN!", italian="MA...[K] NON RIUSCIRANNO A\nSFUGGIRMI!", spanish=" PERO...[K] ¡NO ESCAPARÉIS DE MÍ!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1')
  -- GAP: se_Play(8200) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end) -- message_SetActor(ACTOR_NPC_PARUKIA)
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" GRRR-OOOOOO!", french=" GRRR-OOOOOO!", german=" GRRR-OOOOOO!", italian=" GRRR-OOOOOO!", spanish=" ¡GRRR!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_H02P99C5_120) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(4) [anim idle native]
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(30)
  -- message_CloseEnforce
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_H02P99C5_120) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(90)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(60)
  GAME:WaitFrames(2) -- join WaitSe
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[64] = 1 -- dungeon_mode(64) = DMODE_OPEN (ROM)
  SkySceneKit.cleanup_npcs()
end
