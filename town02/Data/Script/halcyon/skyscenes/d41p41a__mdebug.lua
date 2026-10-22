-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D41P41A/mdebug.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  do local __choice = SkySceneKit.ask({{english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"}, {english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  pcall(function() SOUND:StopBGM() end)
  -- supervision_LoadStation(LEVEL_D41P41A, 'MUS') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(69, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D41P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(hero, 280, 260, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(50)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 16) -- screen_WhiteOut
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(5)
  GAME:FadeIn(16)
  pcall(function() GAME:MoveCamera(280, 204, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 280, 208, Direction.Down, "NPC_HEIGANI")
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- @label_16 [étiquette de flux ExplorerScript]
  -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  do local __choice = SkySceneKit.ask({{english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"}, {english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- @label_14 [étiquette de flux ExplorerScript]
  do local __choice = SkySceneKit.ask({{english="Yes", french="Yes", german="Yes", italian="Sì", spanish="Yes"}, {english="No", french="No", german="No", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 2) ROM
  if __choice == 2 then
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  else -- default/annulation
  -- break_loop [contrôle de boucle forever NDS: une itération compilée]
  end
  end
  end
  end
  -- message_Close
  -- supervision_Acting(0) [neutre/état moteur]
  GROUND:MoveToPosition(hero, 280, 220, false, 2)
  pcall(function() GAME:MoveCamera(280, 204, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(1) [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_heigani, 280, 188, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:WaitFrames(60)
  -- GAP: BGM BGM_OH_NO non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(10)
  -- supervision_Acting(2) [neutre/état moteur]
  -- GAP: se_Play(7443) — id SE NDS sans portage PMDO identifié
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 256, 88, Direction.Down, "NPC_BIPPA")
  -- ResetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 320, 88, Direction.Down, "NPC_DOGOOMU")
  -- ResetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  GROUND:MoveToPosition(npc_npc_bippa, 248, 212, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_dogoomu, 312, 212, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(10)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '0', '2', '0')
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(hero, 280, 236, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(50)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, hero, 4) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  GAME:WaitFrames(50)
  -- message_CloseEnforce
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, hero, 4) end)
  -- SetAnimation(18) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  GAME:WaitFrames(50)
  -- message_CloseEnforce
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(50)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(50)
  pcall(function() SOUND:FadeOutBGM(120) end)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "question", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "question", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "question", 1) end)
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  GROUND:EntTurn(npc_npc_bippa, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(8195) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  -- supervision_Acting(3) [neutre/état moteur]
  GAME:WaitFrames(80)
  -- GAP: se_Play(5128) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '2')
  GAME:WaitFrames(120)
  local npc_npc_parukia = SkySceneKit.spawn_npc("palkia", 280, 160, Direction.Down, "NPC_PARUKIA")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_parukia, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_parukia, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_parukia, 4) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "sweating", 1) end)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_THE_POWER_OF_DARKNESS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(15)
  GAME:WaitFrames(120)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  GAME:WaitFrames(30)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- SetAnimation(19) [anim idle native]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(200)
  -- SetAnimation(4) [anim idle native]
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  -- SetAnimation(2) [anim idle native]
  do local p=npc_npc_parukia.Position; GROUND:MoveToPosition(npc_npc_parukia, p.X+(0), p.Y+(16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(180), false, 2) end
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- SetAnimation(19) [anim idle native]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(90)
  -- message_CloseEnforce
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_dogoomu.Position; GROUND:MoveToPosition(npc_npc_dogoomu, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7430) — id SE NDS sans portage PMDO identifié
  do local p=npc_npc_dogoomu.Position; GROUND:MoveToPosition(npc_npc_dogoomu, p.X+(8), p.Y+(180), false, 2) end
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(-8), p.Y+(180), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(100)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(30)
  do local p=npc_npc_heigani.Position; GROUND:MoveToPosition(npc_npc_heigani, p.X+(0), p.Y+(8), false, 1) end -- SlidePositionOffset
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- bgm2_PlayFadeIn(BGM_EARTHQUAKE3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '1')
  do local p=npc_npc_heigani.Position; GROUND:MoveToPosition(npc_npc_heigani, p.X+(0), p.Y+(16), false, 1) end -- SlidePositionOffset
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_ChangeVolume(0, 256) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 6, 30)) end) -- camera_SetEffect('2', '3', '1')
  -- GAP: se_Play(5128) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect 244 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  -- GAP: se_Play(5129) — id SE NDS sans portage PMDO identifié
  pcall(function() GAME:MoveCamera(336, 180, 1, false) end) -- SetPositionMark performer/caméra
  -- GAP: SetEffect 244 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  -- GAP: se_Play(5128) — id SE NDS sans portage PMDO identifié
  pcall(function() GAME:MoveCamera(336, 180, 1, false) end) -- SetPositionMark performer/caméra
  -- GAP: SetEffect 244 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  -- GAP: se_Play(5129) — id SE NDS sans portage PMDO identifié
  pcall(function() GAME:MoveCamera(232, 180, 1, false) end) -- SetPositionMark performer/caméra
  -- GAP: SetEffect 244 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  -- GAP: se_Play(5128) — id SE NDS sans portage PMDO identifié
  pcall(function() GAME:MoveCamera(320, 140, 1, false) end) -- SetPositionMark performer/caméra
  -- GAP: SetEffect 244 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  GAME:WaitFrames(30)
  -- message_CloseEnforce
  -- bgm2_ChangeVolume(0, 256) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 6, 30)) end) -- camera_SetEffect('2', '3', '1')
  -- GAP: se_Play(5129) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect 244 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  -- GAP: se_Play(5128) — id SE NDS sans portage PMDO identifié
  pcall(function() GAME:MoveCamera(336, 180, 1, false) end) -- SetPositionMark performer/caméra
  -- GAP: SetEffect 244 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  -- GAP: se_Play(5129) — id SE NDS sans portage PMDO identifié
  pcall(function() GAME:MoveCamera(232, 180, 1, false) end) -- SetPositionMark performer/caméra
  -- GAP: SetEffect 244 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  GAME:WaitFrames(60)
  -- message_CloseEnforce
  do local p=npc_npc_heigani.Position; GROUND:MoveToPosition(npc_npc_heigani, p.X+(0), p.Y+(24), false, 1) end
  -- SetAnimation(2) [anim idle native]
  do local p=npc_npc_parukia.Position; GROUND:MoveToPosition(npc_npc_parukia, p.X+(0), p.Y+(32), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6421) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(12) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(50)
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 120) -- screen_WhiteOutAll
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-180), false, 2) end
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- se_Stop(6665) [SE one-shot PMDO déjà terminé: arrêt sans objet, canal SE V2]
  pcall(function() SOUND:FadeOutBGM(120) end)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(100)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:WaitFrames(100)
  -- GAP: BGM BGM_MISSION_SUCCESS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  -- CallCommon CORO_EVENT_END_MAPIN (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Hidden Land.ogg", true) end)
  -- main_SetGround(LEVEL_D41P41A) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- supervision_Station(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_ExecuteStationCommon(LEVEL_D41P41A, 1) [exécution de station sans cible littérale: harnais journey]
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- message_Close
  pcall(function() SOUND:PlayBGM("Hidden Highland.ogg", true) end)
  -- back_SetGround(LEVEL_D41P41A) [neutre/état moteur]
  -- supervision_Acting(10) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_daakurai = SkySceneKit.spawn_npc("darkrai", 280, 152, Direction.Down, "NPC_DAAKURAI")
  -- SetAnimation(4) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  local npc_npc_kureseria = SkySceneKit.spawn_npc("cresselia", 280, 200, Direction.Up, "NPC_KURESERIA")
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(4), 13, false) end) -- MovePositionOffset performer/caméra
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(4), false, 1) end -- SlidePositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(4), false, 1) end -- SlidePositionOffset
  do local p=npc_npc_kureseria.Position; GROUND:MoveToPosition(npc_npc_kureseria, p.X+(0), p.Y+(4), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_PLANETS_PARALYSIS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kureseria, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 252, 148, false, 1)
  GROUND:EntTurn(npc_npc_kureseria, Direction.UpLeft)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_daakurai, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_daakurai, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  GROUND:EntTurn(npc_npc_kureseria, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_kureseria, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "shock", 1) end)
  GROUND:EntTurn(npc_npc_kureseria, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(45)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GROUND:MoveToPosition(hero, 292, 196, false, 1)
  GROUND:MoveToPosition(hero, 276, 172, false, 1)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "shock", 1) end)
  GROUND:EntTurn(npc_npc_kureseria, Direction.Up)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_daakurai, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  do local __choice = SkySceneKit.ask({{english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"}, {english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:StopBGM() end)
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:WaitFrames(15)
  -- jump @label_8 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:WaitFrames(15)
  do local __sw = ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) -- switch($PARTNER_TALK_KIND) [GameVar PARTNER_TALK_KIND (genre partenaire)]
  if __sw == 1 then
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- @label_7 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- @label_8 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyVars or {}).HERO_TALK_KIND or 0) -- switch($HERO_TALK_KIND) [GameVar HERO_TALK_KIND (genre héros)]
  if __sw == 4 then
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- @label_11 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8198) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 60) -- screen_WhiteOut
  GROUND:TeleportTo(partner, 260, 220, Direction.Down)
  GROUND:TeleportTo(npc_npc_kureseria, 292, 220, Direction.Down)
  GROUND:TeleportTo(npc_npc_daakurai, 276, 164, Direction.Down)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_kureseria, Direction.Up)
  GROUND:EntTurn(npc_npc_daakurai, Direction.Down)
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:FadeIn(15)
  -- GAP: se_Play(5126) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(13) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_daakurai, "shock", 1) end)
  -- SetAnimation(11) [anim idle native]
  do local p=npc_npc_daakurai.Position; GROUND:MoveToPosition(npc_npc_daakurai, p.X+(0), p.Y+(-16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(43) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(4) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_daakurai, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- message_Close
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(16), 6, false) end) -- MovePositionOffset performer/caméra
  GROUND:EntTurn(hero, Direction.Left)
  -- SetAnimation(68) [anim idle native]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(32), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "shock", 1) end)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(4), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kureseria.Position; GROUND:MoveToPosition(npc_npc_kureseria, p.X+(0), p.Y+(4), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  do local p=npc_npc_daakurai.Position; GROUND:MoveToPosition(npc_npc_daakurai, p.X+(0), p.Y+(16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_daakurai, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_DOWN_A_DARK_PATH non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5133) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 15)
  GAME:WaitFrames(15)
  -- supervision_Acting(11) [neutre/état moteur]
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "shock", 1) end)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(7)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- message_Close
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  elseif true then -- default
  -- @label_10 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- jump @label_11 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 2 then
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_6 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
