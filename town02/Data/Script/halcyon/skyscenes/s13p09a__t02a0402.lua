-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S13P09A/t02a0402.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back2_SetMode(5) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_S13P09A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 80, 576, Direction.Right, "NPC_PUKURIN")
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 104, 576, Direction.Right, "NPC_PERAPPU")
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 136, 576, Direction.Right, "NPC_BIPPA")
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 184, 576, Direction.Right, "NPC_KIMAWARI")
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 152, 576, Direction.Right, "NPC_HEIGANI")
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 160, 576, Direction.Right, "NPC_CHIRIIN")
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 192, 576, Direction.Right, "NPC_GUREGGURU")
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 128, 576, Direction.Right, "NPC_DOGOOMU")
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 88, 576, Direction.Right, "NPC_DAGUTORIO")
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 64, 576, Direction.Right, "NPC_DIGUDA")
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- screen2_FadeIn(0, 15) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(15)
  GROUND:MoveToPosition(hero, 144, 420, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 112, 420, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_pukurin, 80, 444, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_bippa, 136, 444, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_perappu, 104, 460, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_kimawari, 184, 460, false, 2)
  GAME:WaitFrames(4)
  GROUND:MoveToPosition(npc_npc_heigani, 152, 468, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_chiriin, 160, 492, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_dagutorio, 88, 500, false, 2)
  GAME:WaitFrames(3)
  GROUND:MoveToPosition(npc_npc_guregguru, 192, 492, false, 2)
  GAME:WaitFrames(4)
  GROUND:MoveToPosition(npc_npc_diguda, 64, 484, false, 2)
  GAME:WaitFrames(4)
  GROUND:MoveToPosition(npc_npc_dogoomu, 128, 508, false, 2)
  GAME:WaitFrames(30)
  pcall(function() GAME:MoveCamera(128, 300, 60, false) end) -- performer/caméra
  -- SetAnimation(3) [anim idle native]
  GAME:WaitFrames(104)
  -- SetAnimation(20) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySubScreen.Hide(30) -- screen2_WhiteOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.cleanup_npcs()
end
