-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V10P03C/m10a1209.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_NPC_BARUBIITO1
    local npc_npc_barubiito1 = SkySceneKit.spawn_npc("volbeat", 40, 320, Direction.Right, "NPC_BARUBIITO1")
    -- SetOutputAttribute(4) [neutre/état moteur]
    -- SetOutputAttribute(8) [neutre/état moteur]
    -- ResetOutputAttribute(256) [neutre/état moteur]
    -- SetAnimation(42) [anim idle native]
    GAME:WaitFrames(5)
    do local p=npc_npc_barubiito1.Position; GROUND:MoveToPosition(npc_npc_barubiito1, p.X+(100), p.Y+(0), false, 2) end -- Slide2PositionOffset
    GROUND:EntTurn(npc_npc_barubiito1, Direction.Right)
    GAME:WaitFrames(60)
    do local p=npc_npc_barubiito1.Position; GROUND:MoveToPosition(npc_npc_barubiito1, p.X+(150), p.Y+(-30), false, 2) end -- Slide2PositionOffset
    GROUND:EntTurn(npc_npc_barubiito1, Direction.Right)
    GAME:WaitFrames(60)
    do local p=npc_npc_barubiito1.Position; GROUND:MoveToPosition(npc_npc_barubiito1, p.X+(150), p.Y+(0), false, 2) end -- Slide2PositionOffset
    GROUND:EntTurn(npc_npc_barubiito1, Direction.Right)
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 2 for actor ACTOR_NPC_BARUBIITO2
    local npc_npc_barubiito2 = SkySceneKit.spawn_npc("volbeat", 296, 288, Direction.Left, "NPC_BARUBIITO2")
    -- SetOutputAttribute(4) [neutre/état moteur]
    -- SetOutputAttribute(8) [neutre/état moteur]
    -- ResetOutputAttribute(256) [neutre/état moteur]
    -- SetAnimation(42) [anim idle native]
    GAME:WaitFrames(5)
    GAME:WaitFrames(60)
    do local p=npc_npc_barubiito2.Position; GROUND:MoveToPosition(npc_npc_barubiito2, p.X+(-120), p.Y+(0), false, 2) end -- Slide2PositionOffset
    GROUND:EntTurn(npc_npc_barubiito2, Direction.Left)
    GAME:WaitFrames(50)
    do local p=npc_npc_barubiito2.Position; GROUND:MoveToPosition(npc_npc_barubiito2, p.X+(-150), p.Y+(-30), false, 2) end -- Slide2PositionOffset
    GROUND:EntTurn(npc_npc_barubiito2, Direction.Left)
    GAME:WaitFrames(75)
    do local p=npc_npc_barubiito2.Position; GROUND:MoveToPosition(npc_npc_barubiito2, p.X+(-150), p.Y+(0), false, 2) end -- Slide2PositionOffset
    GROUND:EntTurn(npc_npc_barubiito2, Direction.Left)
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 3 for actor ACTOR_NPC_BARUBIITO3
    local npc_npc_barubiito3 = SkySceneKit.spawn_npc("volbeat", 200, 320, Direction.Left, "NPC_BARUBIITO3")
    -- SetOutputAttribute(4) [neutre/état moteur]
    -- SetOutputAttribute(8) [neutre/état moteur]
    -- ResetOutputAttribute(256) [neutre/état moteur]
    -- SetAnimation(42) [anim idle native]
    GAME:WaitFrames(5)
    do local p=npc_npc_barubiito3.Position; GROUND:MoveToPosition(npc_npc_barubiito3, p.X+(-80), p.Y+(-40), false, 2) end -- Slide2PositionOffset
    GROUND:EntTurn(npc_npc_barubiito3, Direction.Left)
    GAME:WaitFrames(55)
    do local p=npc_npc_barubiito3.Position; GROUND:MoveToPosition(npc_npc_barubiito3, p.X+(-150), p.Y+(-20), false, 2) end -- Slide2PositionOffset
    GROUND:EntTurn(npc_npc_barubiito3, Direction.Left)
    GAME:WaitFrames(45)
    do local p=npc_npc_barubiito3.Position; GROUND:MoveToPosition(npc_npc_barubiito3, p.X+(-150), p.Y+(0), false, 2) end -- Slide2PositionOffset
    GROUND:EntTurn(npc_npc_barubiito3, Direction.Left)
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 4 for actor ACTOR_NPC_BARUBIITO4
    local npc_npc_barubiito4 = SkySceneKit.spawn_npc("volbeat", 128, 360, Direction.Right, "NPC_BARUBIITO4")
    -- SetOutputAttribute(4) [neutre/état moteur]
    -- SetOutputAttribute(8) [neutre/état moteur]
    -- ResetOutputAttribute(256) [neutre/état moteur]
    -- SetAnimation(42) [anim idle native]
    GAME:WaitFrames(5)
    do local p=npc_npc_barubiito4.Position; GROUND:MoveToPosition(npc_npc_barubiito4, p.X+(70), p.Y+(0), false, 2) end -- Slide2PositionOffset
    GROUND:EntTurn(npc_npc_barubiito4, Direction.Right)
    GAME:WaitFrames(45)
    do local p=npc_npc_barubiito4.Position; GROUND:MoveToPosition(npc_npc_barubiito4, p.X+(200), p.Y+(0), false, 2) end -- Slide2PositionOffset
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 5 for actor ACTOR_NPC_IRUMIIZE1
    local npc_npc_irumiize1 = SkySceneKit.spawn_npc("illumise", 64, 320, Direction.Right, "NPC_IRUMIIZE1")
    -- SetOutputAttribute(4) [neutre/état moteur]
    -- SetOutputAttribute(8) [neutre/état moteur]
    -- ResetOutputAttribute(256) [neutre/état moteur]
    GAME:WaitFrames(5)
    -- SetAnimation(42) [anim idle native]
    do local p=npc_npc_irumiize1.Position; GROUND:MoveToPosition(npc_npc_irumiize1, p.X+(100), p.Y+(0), false, 2) end -- Slide2PositionOffset
    GROUND:EntTurn(npc_npc_irumiize1, Direction.Right)
    GAME:WaitFrames(60)
    do local p=npc_npc_irumiize1.Position; GROUND:MoveToPosition(npc_npc_irumiize1, p.X+(150), p.Y+(-30), false, 2) end -- Slide2PositionOffset
    GROUND:EntTurn(npc_npc_irumiize1, Direction.Right)
    GAME:WaitFrames(60)
    do local p=npc_npc_irumiize1.Position; GROUND:MoveToPosition(npc_npc_irumiize1, p.X+(150), p.Y+(0), false, 2) end -- Slide2PositionOffset
    GROUND:EntTurn(npc_npc_irumiize1, Direction.Right)
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 6 for actor ACTOR_NPC_IRUMIIZE2
    local npc_npc_irumiize2 = SkySceneKit.spawn_npc("illumise", 272, 288, Direction.Left, "NPC_IRUMIIZE2")
    -- SetOutputAttribute(4) [neutre/état moteur]
    -- SetOutputAttribute(8) [neutre/état moteur]
    -- ResetOutputAttribute(256) [neutre/état moteur]
    GAME:WaitFrames(5)
    -- SetAnimation(42) [anim idle native]
    GAME:WaitFrames(60)
    do local p=npc_npc_irumiize2.Position; GROUND:MoveToPosition(npc_npc_irumiize2, p.X+(-120), p.Y+(0), false, 2) end -- Slide2PositionOffset
    GROUND:EntTurn(npc_npc_irumiize2, Direction.Left)
    GAME:WaitFrames(50)
    do local p=npc_npc_irumiize2.Position; GROUND:MoveToPosition(npc_npc_irumiize2, p.X+(-150), p.Y+(-30), false, 2) end -- Slide2PositionOffset
    GROUND:EntTurn(npc_npc_irumiize2, Direction.Left)
    GAME:WaitFrames(75)
    do local p=npc_npc_irumiize2.Position; GROUND:MoveToPosition(npc_npc_irumiize2, p.X+(-150), p.Y+(0), false, 2) end -- Slide2PositionOffset
    GROUND:EntTurn(npc_npc_irumiize2, Direction.Left)
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 7 for actor ACTOR_NPC_IRUMIIZE3
    local npc_npc_irumiize3 = SkySceneKit.spawn_npc("illumise", 176, 320, Direction.Left, "NPC_IRUMIIZE3")
    -- SetOutputAttribute(4) [neutre/état moteur]
    -- SetOutputAttribute(8) [neutre/état moteur]
    -- ResetOutputAttribute(256) [neutre/état moteur]
    GAME:WaitFrames(5)
    -- SetAnimation(42) [anim idle native]
    do local p=npc_npc_irumiize3.Position; GROUND:MoveToPosition(npc_npc_irumiize3, p.X+(-80), p.Y+(-40), false, 2) end -- Slide2PositionOffset
    GROUND:EntTurn(npc_npc_irumiize3, Direction.Left)
    GAME:WaitFrames(55)
    do local p=npc_npc_irumiize3.Position; GROUND:MoveToPosition(npc_npc_irumiize3, p.X+(-150), p.Y+(-20), false, 2) end -- Slide2PositionOffset
    GROUND:EntTurn(npc_npc_irumiize3, Direction.Left)
    GAME:WaitFrames(45)
    do local p=npc_npc_irumiize3.Position; GROUND:MoveToPosition(npc_npc_irumiize3, p.X+(-150), p.Y+(0), false, 2) end -- Slide2PositionOffset
    GROUND:EntTurn(npc_npc_irumiize3, Direction.Left)
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 8 for actor ACTOR_NPC_IRUMIIZE4
    local npc_npc_irumiize4 = SkySceneKit.spawn_npc("illumise", 152, 360, Direction.Right, "NPC_IRUMIIZE4")
    -- SetOutputAttribute(4) [neutre/état moteur]
    -- SetOutputAttribute(8) [neutre/état moteur]
    -- ResetOutputAttribute(256) [neutre/état moteur]
    GAME:WaitFrames(5)
    -- SetAnimation(42) [anim idle native]
    do local p=npc_npc_irumiize4.Position; GROUND:MoveToPosition(npc_npc_irumiize4, p.X+(70), p.Y+(0), false, 2) end -- Slide2PositionOffset
    GROUND:EntTurn(npc_npc_irumiize4, Direction.Right)
    GAME:WaitFrames(45)
    do local p=npc_npc_irumiize4.Position; GROUND:MoveToPosition(npc_npc_irumiize4, p.X+(200), p.Y+(0), false, 2) end -- Slide2PositionOffset
    GAME:WaitFrames(1) -- hold
  end)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(5) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_V10P03C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- MovePositionOffset<object OBJECT_V10P01C1_228> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V10P01C1_229> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V10P01C2_234> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V10P01C2_235> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V10P01C2_236> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V10P01C3_240> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V10P01C3_241> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V10P01C3_242> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V10P01C1_225> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V10P01C1_226> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V10P01C2_231> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V10P01C2_232> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V10P01C3_237> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V10P01C3_238> [prop décor NDS, géré par le rendu du ground]
  pcall(function() SOUND:PlayBGM("Time Restored.ogg", true) end)
  -- screen2_FadeIn(0, 60) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(60)
  GAME:WaitFrames(210)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 60)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
