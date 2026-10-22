-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D28P33A/m25a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetBanner2(LEVEL_V25P04A, 0, 156, 128, -1) [bannière 2e écran NDS: information dupliquée du menu, hors canvas unique - documenté]
  GAME:FadeIn(45)
  GAME:WaitFrames(160)
  GAME:FadeOut(false, 45)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D28P33C) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_RAINBOW_STONESHIP_NOISE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(partner, 368, 200, false, 2) -- Slide2PositionMark (glissement)
  GAME:WaitFrames(20)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(hero, 384, 208, false, 2) -- Slide2PositionMark (glissement)
  GROUND:MoveToPosition(partner, 360, 200, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(20)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa! It's getting louder!", french="Ouah! Le bruit devient\nassourdissant!", german=" Wow! Es wird lauter!", italian=" Aaah! È sempre più rumoroso!", spanish="¡Vaya!\n¡Cada vez suena más fuerte!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah! It's getting louder!", french="Ouah! Le bruit devient\nassourdissant!", german=" Waah! Es wird lauter!", italian=" Aaah! È sempre più rumoroso!", spanish="¡Vaya!\n¡Cada vez suena más fuerte!"})
  else
  SkySceneKit.say({english=" Waah! It's getting louder!", french="Ouah! Le bruit devient\nassourdissant!", german=" Waah! Es wird lauter!", italian=" Aaah! È sempre più rumoroso!", spanish="¡Vaya!\n¡Cada vez suena más fuerte!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's about to start moving!\nGet on it, quick!", french="Il va se mettre en route!\nMontons, vite!", german="Es fängt gleich an, sich zu\nbewegen! Schnell, springen wir auf!", italian="Sta cominciando a muoversi!\nMontiamoci su, presto!", spanish="Va a empezar a moverse.\n¡Sube, rápido!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's about to move! Let's get on\nit, quick!", french="Il va se mettre en route!\nMontons, vite!", german="Es fängt gleich an, sich zu\nbewegen! Schnell, springen wir auf!", italian="Sta cominciando a muoversi!\nSaliamo, presto!", spanish="Va a empezar a moverse.\n¡Sube, rápido!"})
  else
  SkySceneKit.say({english="It's about to start moving!\nLet's get on it, quick!", french="Il va se mettre en route!\nMontons, vite!", german="Es fängt gleich an, sich zu\nbewegen! Schnell, springen wir auf!", italian="Sta cominciando a muoversi!\nSaliamo, presto!", spanish="Va a empezar a moverse.\n¡Sube, rápido!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 280, 200, false, 2)
  GAME:WaitFrames(15)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(hero, 368, 200, false, 2) -- Slide2PositionMark (glissement)
  GROUND:MoveToPosition(hero, 320, 200, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(45)
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- GAP: se_Play(5130) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- SetAnimation(18) [anim idle native]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D28P33A8_73) [routine d'objet NDS non simulée - documenté]
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-24), 81, false) end) -- MovePositionOffset performer/caméra
  -- MovePositionOffset<object OBJECT_D28P33A3_68> [prop décor NDS, géré par le rendu du ground]
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-24), false, 1) end -- SlidePositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-24), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wa-wa-waaah!", french=" Ouaaaaaaaah!", german=" Wa-wa-waaah!", italian=" Wo-wo-wooow!", spanish=" ¡Aaaaaaaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wa-wa-waaah!", french=" Ouaaaaaaaah!", german=" Wa-wa-waaah!", italian=" Wo-wo-wooow!", spanish=" ¡Aaaaaaaah!"})
  else
  SkySceneKit.say({english=" Wa-wa-waaah!", french=" Ouaaaaaaaah!", german=" Wa-wa-waaah!", italian=" Wo-wo-wooow!", spanish=" ¡Aaaaaaaah!"})
  end
  GAME:WaitFrames(30)
  -- se_FadeOut(5130, 60) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(60)
  -- message_CloseEnforce
  -- GAP: se_Play(7689) — id SE NDS sans portage PMDO identifié
  -- SetOutputAttribute(4) [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-80), 160, false) end) -- MovePositionOffset performer/caméra
  -- MovePositionOffset<object OBJECT_D28P33A3_68> [prop décor NDS, géré par le rendu du ground]
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-80), false, 1) end -- SlidePositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-80), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(45)
  GAME:FadeOut(true, 60) -- screen_WhiteOut
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(120)
end
