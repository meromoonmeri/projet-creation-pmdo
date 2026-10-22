-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P41A/m01d0712.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D01P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 216, 160, Direction.Down, "NPC_DOGAASU")
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="Whoa-ho![K] Don't think you're so\nawesome. Your victory was a fluke!", french="Mouarf![K] Te prends pas trop\nau sérieux. C'était un coup de chance!", german="Whoaho![K] Bildet euch nichts\ndarauf ein! Ihr hattet nur Anfängerglück!", italian="Ah ah![K] Ma non montatevi la\ntesta, adesso! La vostra vittoria è stata solo\nun caso!", spanish="Y...[K] No os creáis que ha sido\npara tanto. ¡Habéis ganado de chiripa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 248, 160, Direction.Down, "NPC_ZUBATTO")
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Yeah, you just remember that!", french=" Ouais, oublie jamais ça!", german=" Genau, merkt euch das!", italian=" Sì, vedete di non scordarvelo!", spanish=" ¡Eso! ¡Que no se os olvide!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_dogaasu, 184, 188, false, 2)
  GAME:WaitFrames(10)
  -- SetAnimation(768) [anim idle native]
  GROUND:MoveToPosition(npc_npc_zubatto, 268, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_dogaasu, 176, 316, false, 2)
  GROUND:MoveToPosition(npc_npc_zubatto, 272, 316, false, 2)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
