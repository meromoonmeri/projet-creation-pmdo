-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P03P01A/m09d0652.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_P03P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P03P01A1_127) [routine d'objet NDS non simulée - documenté]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 424, 472, Direction.Left, "NPC_HEIGANI")
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "sweating", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  -- message_FacePositionOffset(-4, -2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Wa-waah! Watch out! Everyone,\nget back!", french=" Wouah! Attention! Reculez!", german="Waaaah! Passt auf!\nGeht alle zurück!", italian="Wa-waah! A-Attenti!\nState indietro!", spanish="¿Quéee? ¡Cuidado!\n¡Apartaos todos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Wa-waah! Watch out! Step back,\neveryone!", french=" Wouah! Attention! Reculez!", german="Waaaah! Passt auf!\nGeht in Deckung!", italian="Wa-waah! A-Attenti!\nState indietro!", spanish="¿Quéee? ¡Cuidado!\n¡Hay que retroceder!"})
  else
  SkySceneKit.say({english="Wa-waah! Watch out! Everyone,\nwe have to get back!", french=" Wouah! Attention! Reculez!", german="Waaaah! Passt auf!\nWir müssen zurückgehen!", italian="Wa-waah! A-Attenti!\nState indietro!", spanish="¿Quéee? ¡Cuidado!\n¡Atrás!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(200), 200, false) end) -- MovePositionOffset performer/caméra
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(200), false, 2) end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(200), false, 2) end
  do local p=npc_npc_heigani.Position; GROUND:MoveToPosition(npc_npc_heigani, p.X+(0), p.Y+(200), false, 2) end
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P03P01A1_127) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(80)
  GAME:FadeOut(true, 30) -- screen_WhiteOutAll
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:FadeOut(true, 0) -- screen_WhiteOut
  GAME:FadeIn(0)
  SkySceneKit.cleanup_npcs()
end
