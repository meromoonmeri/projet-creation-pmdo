-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V00P02/m01a05a.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V01P02A) [décor sub chargé: Sub_v01p02a]
  -- back_SetGround(LEVEL_V01P02A) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(128, 100, 1, false) end)
  SkySubScreen.Show("v01p02a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(60)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_S11P02C) [neutre/état moteur]
  -- back_SetEffect(5, 0) [transition couches décor NDS immédiate]
  GAME:WaitFrames(2) -- WaitBackEffect (join)
  pcall(function() GAME:MoveCamera(384, 100, 1, false) end)
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  GAME:WaitFrames(120) -- back_SetEffect(3, 120) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  GAME:WaitFrames(2) -- WaitBackEffect (join)
  GAME:WaitFrames(60)
  GAME:WaitFrames(120) -- back_SetEffect(5, 120) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  GAME:WaitFrames(2) -- WaitBackEffect (join)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 30)
  -- back_SetGround(LEVEL_V03P06A) [neutre/état moteur]
  -- back_SetEffect(12, 0) [transition couches décor NDS immédiate]
  GAME:WaitFrames(2) -- WaitBackEffect (join)
  pcall(function() GAME:MoveCamera(128, 100, 1, false) end)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V03P06A1_212) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V03P06A1_213) [routine d'objet NDS non simulée - documenté]
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  -- ResetOutputAttribute(128) [neutre/état moteur]
  GAME:WaitFrames(60) -- back_SetEffect(11, 60) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  GAME:WaitFrames(2) -- WaitBackEffect (join)
  -- ResetOutputAttribute(64) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V03P06A1_212) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(60)
  -- back_SetEffect(12, 0) [transition couches décor NDS immédiate]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V03P06A1_213) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(60) -- back_SetEffect(11, 60) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  GAME:WaitFrames(2) -- WaitBackEffect (join)
  GAME:WaitFrames(128) -- back_SetEffect(15, 128) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  GAME:WaitFrames(60)
  GAME:WaitFrames(128) -- back_SetEffect(16, 128) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  GAME:WaitFrames(60)
  -- back_SetEffect(11, 0) [transition couches décor NDS immédiate]
  -- SetOutputAttribute(64) [neutre/état moteur]
  -- ResetOutputAttribute(64) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V03P06A1_212) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V03P06A1_213) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(60) -- back_SetEffect(12, 60) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  GAME:WaitFrames(2) -- WaitBackEffect (join)
  -- SetOutputAttribute(128) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V03P06A1_212) [routine d'objet NDS non simulée - documenté]
  -- back_SetEffect(11, 0) [transition couches décor NDS immédiate]
  -- SetOutputAttribute(64) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V03P06A1_213) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(60) -- back_SetEffect(12, 60) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  GAME:WaitFrames(2) -- WaitBackEffect (join)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 30)
  SkySceneKit.play_scene("t00p01__m01a0100", "t00p01__m01a01", hero, partner) -- supervision_ExecuteStation(LEVEL_T00P01, 'M01A01', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
