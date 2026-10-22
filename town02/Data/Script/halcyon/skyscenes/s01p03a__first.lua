-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S01P03A/first.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- back_SetGround(LEVEL_S01P03A) [neutre/état moteur]
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(S01P04A) [décor sub chargé: Sub_s01p04a]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[40] = 1 -- $SCENARIO_MAIN_BIT_FLAG[40] = 1 (ROM)
  -- GAP: BGM BGM_PELIPPER_ISLAND non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- bgm2_PlayFadeIn(BGM_OCEAN1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 21, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- SetAnimation(1) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  GAME:WaitFrames(20)
  -- SetAnimation(1) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  GAME:WaitFrames(20)
  -- SetAnimation(1) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  SkySubScreen.Show("s01p04a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  pcall(function() GAME:MoveCamera(228, 124, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  GAME:WaitFrames(4) -- WaitMoveCamera (join caméra)
  GAME:WaitFrames(30)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  SkySceneKit.unlock(3) -- Unlock(3) NDS
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_EVENT_END_MAPIN (fermeture/attente message: géré par say())
  -- main_SetGround(LEVEL_S01P03A) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- supervision_ExecuteStationCommon(LEVEL_S01P03A, 1) [exécution de station sans cible littérale: harnais journey]
  GAME:WaitFrames(1) -- hold
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
