-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S13P06A/t02a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back2_SetMode(5) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_S13P06A) [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(480), g.ViewCenter.Y+(360), 120, false) end) -- back_SetBackScrollSpeed(4.0,3.0) px/frame -> caméra continue (pilote scroll)
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 24, 360, Direction.Right, "NPC_PUKURIN")
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 24, 352, Direction.Right, "NPC_PERAPPU")
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 24, 360, Direction.Right, "NPC_BIPPA")
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 24, 352, Direction.Right, "NPC_KIMAWARI")
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 24, 360, Direction.Right, "NPC_HEIGANI")
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 24, 352, Direction.Right, "NPC_CHIRIIN")
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 24, 360, Direction.Right, "NPC_GUREGGURU")
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 24, 352, Direction.Right, "NPC_DOGOOMU")
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 24, 360, Direction.Right, "NPC_DAGUTORIO")
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 24, 352, Direction.Right, "NPC_DIGUDA")
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(30) -- WaitBgmSignal (signal SMD NDS sans équivalent: join fixe documenté)
  -- screen2_FadeIn(0, 10) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(10)
  GROUND:MoveToPosition(partner, 160, 364, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- back_SetBackScrollSpeed(0,0): arrêt du défilement
  -- SetAnimation(2) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(16), p.Y+(0), false, 2) end
  GAME:WaitFrames(5)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  -- SetAnimation(3) [anim idle native]
  -- MoveHeight(2, 6) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(1)
  -- MoveHeight(2, 6) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(5)
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(500), p.Y+(0), false, 2) end
  GAME:WaitFrames(15)
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(500), p.Y+(0), false, 2) end
  GAME:WaitFrames(15)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(500), p.Y+(0), false, 2) end
  GAME:WaitFrames(15)
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(500), p.Y+(0), false, 2) end
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(200), p.Y+(0), false, 2) end
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(200), p.Y+(0), false, 2) end
  GAME:WaitFrames(13)
  do local p=npc_npc_heigani.Position; GROUND:MoveToPosition(npc_npc_heigani, p.X+(500), p.Y+(0), false, 2) end
  GAME:WaitFrames(15)
  do local p=npc_npc_chiriin.Position; GROUND:MoveToPosition(npc_npc_chiriin, p.X+(500), p.Y+(0), false, 2) end
  GAME:WaitFrames(15)
  do local p=npc_npc_guregguru.Position; GROUND:MoveToPosition(npc_npc_guregguru, p.X+(500), p.Y+(0), false, 2) end
  GAME:WaitFrames(15)
  do local p=npc_npc_dogoomu.Position; GROUND:MoveToPosition(npc_npc_dogoomu, p.X+(500), p.Y+(0), false, 2) end
  GAME:WaitFrames(15)
  do local p=npc_npc_dagutorio.Position; GROUND:MoveToPosition(npc_npc_dagutorio, p.X+(500), p.Y+(0), false, 2) end
  GAME:WaitFrames(15)
  do local p=npc_npc_diguda.Position; GROUND:MoveToPosition(npc_npc_diguda, p.X+(500), p.Y+(0), false, 2) end
  GAME:WaitFrames(15)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.cleanup_npcs()
end
