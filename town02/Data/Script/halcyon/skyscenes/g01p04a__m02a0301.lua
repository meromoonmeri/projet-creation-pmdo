-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m02a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  SkyProg.set(3, 2) -- $SCENARIO_MAIN = scn[3,2] (ROM)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyPosition() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Hey, you shouldn't just be\nwandering around there.", french="Hé, vous ne devriez pas\nlambiner là, vous deux.", german="Hey, ihr habt hier nicht einfach\nso herumzuspazieren.", italian="Ehi, non dovreste stare qui con\nle mani in mano.", spanish="¡Eh, aprendices! ¡No deberíais\nestar dando vueltas por ahí!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" You two come here. ♪", french=" Venez un peu par ici. ♪", german=" Kommt mal mit, ihr zwei. ♪", italian=" Voi due, venite con me. ♪", spanish=" Venid conmigo. ♪"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_perappu, 320, 220, false, 2)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_perappu, 324, 132, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(60)
  GROUND:MoveToPosition(hero, 320, 220, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 320, 220, false, 2)
  GAME:WaitFrames(20)
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
end
