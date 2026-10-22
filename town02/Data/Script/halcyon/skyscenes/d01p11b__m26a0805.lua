-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11B/m26a0805.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_ATTENDANT1
    -- SetOutputAttribute(2) [neutre/état moteur]
    -- SetAnimation(81) [anim idle native]
    GAME:WaitFrames(2) -- join WaitAnimation
    SkySceneKit.lock(5) -- Lock(5) NDS
    -- SetAnimation(2) [anim idle native]
    -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
    GAME:WaitFrames(2) -- join WaitEffect
    GAME:WaitFrames(45)
    GROUND:EntTurn(partner, Direction.Left)
    GAME:WaitFrames(30)
    pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
    SkySceneKit.lock(6) -- Lock(6) NDS
    GAME:WaitFrames(1) -- hold
  end)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V01P03B) [décor sub chargé: Sub_v01p03b]
  -- back_SetGround(LEVEL_D01P11B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera2_SetPositionMark(Position<'m0', 33, 9.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- supervision_SpecialActing(21, 600, 0) [cadrage NDS]
  -- supervision2_SpecialActing(21, 600, 0) [acting sub NDS: décor déjà reproduit par SubScreen, acteurs sub non simulés - trace]
  -- GAP: BGM BGM_EPILOGUE_THEME non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Show("v01p03b", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GAME:WaitFrames(90)
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetupOutputAttributeAndAnimation<object OBJECT_D01P11B3_16> [prop décor NDS, rendu du ground]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(30)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D01P11B3_16) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(60)
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D01P11B3_16) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D01P11B3_16) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(4) [anim idle native]
  SkySceneKit.unlock(8) -- Unlock(8) NDS
  GAME:WaitFrames(60)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  -- SetAnimation(3) [anim idle native]
  GAME:WaitFrames(70)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(60)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(60)
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() GAME:MoveCamera(324, 180, 60, false) end) -- performer/caméra
  GROUND:EntTurn(hero, Direction.Right)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-8), p.Y+(-8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30) -- WaitBgmSignal (signal SMD NDS sans équivalent: join fixe documenté)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(32), p.Y+(0), false, 2) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-36), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 408, 184, Direction.Left, "NPC_BIPPA")
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "happy", 1) end)
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  -- SetAnimation(81) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  SkySubScreen.Hide(180) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 180)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
  SkySceneKit.join_routines()
end
