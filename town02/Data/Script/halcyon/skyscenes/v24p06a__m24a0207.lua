-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V24P06A/m24a0207.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_THROUGH_THE_SEA_OF_TIME non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_V24P06A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- Move2PositionMark<object OBJECT_V24P06A1_327> [prop décor NDS, géré par le rendu du ground]
  GAME:FadeIn(30)
  GAME:WaitFrames(330)
  -- GAP: se_Play(5125) — id SE NDS sans portage PMDO identifié
  pcall(function() SOUND:FadeOutBGM(180) end)
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:WaitFrames(120)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- worldmap_SetMode(3) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetLevel(5) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_ChangeLevel(6) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetCamera(39) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The clouds parted over\n[CN]the [CS:P]Hidden Land[CR]!", french="[CN]Les nuages se sont dissipés au-dessus\n[CN]des [CS:P]Terres Illusoires[CR]!", german="[CN]Die Wolken teilen sich\n[CN]über dem [CS:P]Verborgenen Land[CR]!", italian="[CN]Le nuvole che ricoprono la [CS:P]Terra Nascosta[CR]\n[CN]si sollevano.", spanish="[CN]¡Las nubes que cubrían la\n[CN][CS:P]Tierra Oculta[CR] se disiparon!"})
  GAME:WaitFrames(60)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:FadeOut(false, 0)
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
end
