-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V03P08A/t01p0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(S05P04A) [décor sub chargé: Sub_s05p04a]
  -- back_SetGround(LEVEL_V03P08A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 17>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- back2_SetBackEffect(3) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  SkySubScreen.Show("s05p04a", 0, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_S05P04A1_187) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(60)
  SkySubScreen.Hide(60) -- screen2_WhiteOut: retour BOTTOM_FOCUS (timeline ROM)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(45)
  GAME:WaitFrames(30) -- WaitBgmSignal (signal SMD NDS sans équivalent: join fixe documenté)
  -- GAP: se_Play(8979) — id SE NDS sans portage PMDO identifié
  -- back2_SetGround(S05P04A) [décor sub chargé: Sub_s05p04a]
  -- camera2_SetPositionMark(Position<'m1', 16.5, 13.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- back2_SetBackEffect(3) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  SkySubScreen.Show("s05p04a", 0, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  -- camera2_SetPositionMark(Position<'m2', 16.5, 13.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(2)
  -- camera2_SetPositionMark(Position<'m3', 49.5, 13.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(2)
  -- camera2_SetPositionMark(Position<'m4', 82.5, 13.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(2)
  -- camera2_SetPositionMark(Position<'m5', 16.5, 37.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(2)
  -- camera2_SetPositionMark(Position<'m6', 49.5, 37.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(2)
  -- camera2_SetPositionMark(Position<'m7', 82.5, 37.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(2)
  -- camera2_SetPositionMark(Position<'m8', 16.5, 61.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(2)
  -- camera2_SetPositionMark(Position<'m9', 49.5, 61.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(2)
  -- camera2_SetPositionMark(Position<'m10', 82.5, 61.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(2)
  -- camera2_SetPositionMark(Position<'m11', 16.5, 85.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(2)
  -- camera2_SetPositionMark(Position<'m12', 49.5, 85.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(2)
  -- camera2_SetPositionMark(Position<'m13', 82.5, 85.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  if true --[[BranchVariation: ROM Sky EU]] then -- if ROM: variation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_Acting(10) [neutre/état moteur]
  -- @label_1 [étiquette de flux ExplorerScript]
  GAME:WaitFrames(30)
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  GAME:WaitFrames(1)
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  -- GAP: SetEffect 661 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(110)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(10)
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 1 -- $EVENT_LOCAL = 1 (ROM)
  -- switch(ProcessSpecial(22, 1, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  GAME:WaitFrames(2000)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 60)
  else
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
