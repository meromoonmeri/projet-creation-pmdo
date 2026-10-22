-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V24P03A/m24a0205.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_THROUGH_THE_SEA_OF_TIME non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_V24P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-1200), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(-10.0,0.0) px/frame -> caméra continue (pilote scroll)
  -- SetOutputAttribute(2048) [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-2400), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(-20.0,0.0) px/frame -> caméra continue (pilote scroll)
  GAME:WaitFrames(100)
  pcall(function() UI:SetSpeaker("Lapras", true, "lapras", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_RAPURASU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" OK![K] Here we go!", french=" Allez![K] C'est parti!", german=" Okay![K] Los geht's!", italian=" Ok![K] Andiamo!", spanish=" ¡De acuerdo![K] ¡Allá vamos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8463) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(10)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-3600), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(-30.0,0.0) px/frame -> caméra continue (pilote scroll)
  GAME:WaitFrames(20)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-4800), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(-40.0,0.0) px/frame -> caméra continue (pilote scroll)
  GAME:WaitFrames(60)
  -- GAP: se_Play(5140) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(7445) — id SE NDS sans portage PMDO identifié
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-8160), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(-68.0,0.0) px/frame -> caméra continue (pilote scroll)
  GAME:WaitFrames(120)
  -- supervision_Acting(2) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(496, 116, 1, false) end)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(60)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-8640), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(-72.0,0.0) px/frame -> caméra continue (pilote scroll)
  -- supervision_Acting(3) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(808, 116, 1, false) end)
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(90)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-9120), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(-76.0,0.0) px/frame -> caméra continue (pilote scroll)
  -- supervision_Acting(4) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(184, 356, 1, false) end)
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-9600), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(-80.0,0.0) px/frame -> caméra continue (pilote scroll)
  -- supervision_Acting(5) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(496, 356, 1, false) end)
  -- supervision_RemoveActing(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-10080), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(-84.0,0.0) px/frame -> caméra continue (pilote scroll)
  GAME:WaitFrames(60)
  pcall(function() GAME:MoveCamera(808, 356, 1, false) end)
  GAME:WaitFrames(10)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-10560), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(-88.0,0.0) px/frame -> caméra continue (pilote scroll)
  pcall(function() GAME:MoveCamera(184, 596, 1, false) end)
  GAME:WaitFrames(10)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-11040), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(-92.0,0.0) px/frame -> caméra continue (pilote scroll)
  pcall(function() GAME:MoveCamera(496, 596, 1, false) end)
  GAME:WaitFrames(10)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-11520), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(-96.0,0.0) px/frame -> caméra continue (pilote scroll)
  pcall(function() GAME:MoveCamera(808, 596, 1, false) end)
  GAME:WaitFrames(10)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-12000), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(-100.0,0.0) px/frame -> caméra continue (pilote scroll)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa! [CS:N]Lapras[CR]!", french=" Ouah! [CS:N]Lokhlass[CR]!", german=" Huah! [CS:N]Lapras[CR]!", italian=" Wow! [CS:N]Lapras[CR]!", spanish=" ¡Vaya! ¡[CS:N]Lapras[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah! [CS:N]Lapras[CR]!", french=" Ouah! [CS:N]Lokhlass[CR]!", german=" Uaah! [CS:N]Lapras[CR]!", italian=" Aaah! [CS:N]Lapras[CR]!", spanish=" ¡Vaya! ¡[CS:N]Lapras[CR]!"})
  else
  SkySceneKit.say({english=" Waah! [CS:N]Lapras[CR]!", french=" Ouah! [CS:N]Lokhlass[CR]!", german=" Uaah! [CS:N]Lapras[CR]!", italian=" Aaah! [CS:N]Lapras[CR]!", spanish=" ¡Vaya! ¡[CS:N]Lapras[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Lapras[CR] is flying!", french=" [CS:N]Lokhlass[CR] s'envole!", german=" [CS:N]Lapras[CR] fliegt!", italian=" [CS:N]Lapras[CR] sta volando!", spanish=" ¡[CS:N]Lapras[CR] está volando!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Lapras[CR] is flying!", french=" [CS:N]Lokhlass[CR] s'envole!", german=" [CS:N]Lapras[CR] fliegt!", italian=" [CS:N]Lapras[CR] sta volando!", spanish=" ¡[CS:N]Lapras[CR] está volando!"})
  else
  SkySceneKit.say({english=" [CS:N]Lapras[CR] is flying!", french=" [CS:N]Lokhlass[CR] s'envole!", german=" [CS:N]Lapras[CR] fliegt!", italian=" [CS:N]Lapras[CR] sta volando!", spanish=" ¡[CS:N]Lapras[CR] está volando!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 208, 176, Direction.UpLeft, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" No! That's not it!", french=" Non! Ce n'est pas ça!", german=" Nein! Das ist es nicht!", italian=" No! Non è così!", spanish=" ¡No! ¡No es eso!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" This...[K] This isn't flying!", french=" On...[K] on ne vole pas!", german=" Das...[K] Das ist kein Fliegen!", italian=" Non...[K] stiamo volando!", spanish=" Esto...[K] ¡Esto no es volar!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We're crossing the sea of time!", french=" On traverse la mer du temps!", german="Wir überqueren das Meer der\nZeit!", italian="Stiamo attraversando il mare\ndel tempo!", spanish="¡Estamos cruzando el mar\ndel tiempo!"})
  -- message_Close
  GAME:WaitFrames(30)
  -- GAP: se_Play(7949) — id SE NDS sans portage PMDO identifié
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-24000), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(-200.0,0.0) px/frame -> caméra continue (pilote scroll)
  GAME:WaitFrames(120)
  GAME:FadeOut(true, 15) -- screen_WhiteOut
  SkySceneKit.cleanup_npcs()
end
