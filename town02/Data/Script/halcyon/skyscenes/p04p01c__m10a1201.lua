-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P04P01C/m10a1201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_P04P01C) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_TIME_GEAR non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  local npc_npc_yukushii = SkySceneKit.spawn_npc("uxie", 160, 504, Direction.Up, "NPC_YUKUSHII")
  GROUND:MoveToPosition(npc_npc_yukushii, 156, 372, false, 2)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(partner, 136, 396, false, 2)
  GROUND:MoveToPosition(hero, 176, 396, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wow, it's so dark outside now!", french=" Waouh, il fait si sombre dehors!", german="Wow, es ist jetzt ganz dunkel\ndraußen!", italian="Wow! Si è fatto scuro fuori,\neh?", spanish=" Vaya, ¡qué oscuro!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wow, it's become dark outside!", french=" Waouh, il fait si sombre dehors!", german="Wow, draußen ist es dunkel\ngeworden!", italian="Wow! È buio pesto, non\ntrovate?", spanish=" Vaya, ¡qué oscuridad!"})
  else
  SkySceneKit.say({english=" Wow, it's become dark outside!", french=" Waouh, il fait si sombre dehors!", german="Wow, draußen ist es dunkel\ngeworden!", italian="Wow! È buio pesto, non\ntrovate?", spanish=" Vaya, ¡qué oscuridad!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_yukushii, 156, 348, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_yukushii, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="It may be a little difficult to\nsee at night, but...", french="Vous aurez peut-être du mal\nà le voir de nuit, mais...", german="Er ist zwar nachts vielleicht\nnicht so gut zu sehen, aber...", italian="Effettivamente, a quest'ora di\nnotte può risultare difficile vedere, ma...", spanish="Puede que os resulte un poco\ndifícil verlo de noche, pero..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yukushii, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english=" Behold![K] [CS:P]Fogbound Lake[CR]!", french=" Contemplez![K] Le [CS:P]Lac des Brumes[CR]!", german=" Seht her![K] Der [CS:P]Nebelsee[CR]!", italian=" Osservate![K] Il [CS:P]Lago Foschia[CR]!", spanish=" Aquí está...[K] ¡El [CS:P]Lago Velado[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 136, 380, false, 1)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(hero, 176, 380, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wow!", french=" Waouh!", german=" Wow!", italian=" Wow!", spanish=" ¡Vaya!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wow!", french=" Waouh!", german=" Wow!", italian=" Wow!", spanish=" ¡Vaya!"})
  else
  SkySceneKit.say({english=" Wow!", french=" Waouh!", german=" Wow!", italian=" Wow!", spanish=" ¡Vaya!"})
  end
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-180), 180, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
end
