-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V01P01A/m01a0102.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- GAP: BGM BGM_STORM non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V01P02A) [décor sub chargé: Sub_v01p02a]
  -- back_SetGround(LEVEL_V01P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(136, 108, 1, false) end)
  -- GAP: SetEffect 699 — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_VERY_HEAVY_RAIN — VFX sans émote PMDO équivalente
  SkySubScreen.Show("v01p02a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(120)
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  -- camera2_SetPositionMark(Position<'m1', 52, 12.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(2)
  -- camera2_SetPositionMark(Position<'m2', 15, 12.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(2)
  -- camera2_SetPositionMark(Position<'m3', 52, 12.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V01P02A1_197) [routine d'objet NDS non simulée - documenté]
  -- camera2_SetPositionMark(Position<'m4', 15, 12.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(50)
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  -- camera2_SetPositionMark(Position<'m5', 52, 12.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(2)
  -- camera2_SetPositionMark(Position<'m6', 15, 12.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(2)
  -- camera2_SetPositionMark(Position<'m7', 52, 12.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V01P02A1_197) [routine d'objet NDS non simulée - documenté]
  -- camera2_SetPositionMark(Position<'m8', 15, 12.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(90)
  pcall(function() SOUND:FadeOutBGM(120) end)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 60)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  GAME:WaitFrames(180)
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
