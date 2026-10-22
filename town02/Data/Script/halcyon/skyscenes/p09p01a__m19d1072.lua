-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P09P01A/m19d1072.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_P09P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 304, 368, Direction.Down, "NPC_YONOWAARU")
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="We shall be rid of you for\nall time!", french="Nous serons débarrassés\nde vous pour toujours!", german="Wir werden euch für immer\nlos sein!", italian=" Ci libereremo per sempre di voi!", spanish="¡Ha llegado el momento de que\ndesaparezcáis de una vez!"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" This is the end...[K]for you!", french=" Voici venir la fin...[K] votre fin!", german=" Das ist das Ende...[K] für euch!", italian=" È la fine...[K] per voi!", spanish=" Este es...[K] ¡vuestro fin!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 232, 384, Direction.DownRight, "NPC_YAMIRAMI")
  -- SetAnimation(17) [anim idle native]
  local npc_npc_yamirami4 = SkySceneKit.spawn_npc("sableye", 384, 408, Direction.Left, "NPC_YAMIRAMI4")
  -- SetAnimation(17) [anim idle native]
  local npc_npc_yamirami5 = SkySceneKit.spawn_npc("sableye", 224, 440, Direction.Right, "NPC_YAMIRAMI5")
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(10)
  local npc_npc_yamirami2 = SkySceneKit.spawn_npc("sableye", 368, 384, Direction.DownLeft, "NPC_YAMIRAMI2")
  -- SetAnimation(17) [anim idle native]
  local npc_npc_yamirami3 = SkySceneKit.spawn_npc("sableye", 224, 408, Direction.Right, "NPC_YAMIRAMI3")
  -- SetAnimation(17) [anim idle native]
  local npc_npc_yamirami6 = SkySceneKit.spawn_npc("sableye", 376, 440, Direction.Left, "NPC_YAMIRAMI6")
  -- SetAnimation(17) [anim idle native]
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Wheh-heh-heh!", french=" Whé hé hé!", german=" Wähähäh!", italian=" Meh-eh-eh-eh!", spanish=" ¡Je, je, je, je!"})
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  GROUND:EntTurn(partner, Direction.Left)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(8), p.Y+(8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami2.Position; GROUND:MoveToPosition(npc_npc_yamirami2, p.X+(-8), p.Y+(8), false, 1) end -- Move2PositionOffset
  do local p=npc_npc_yamirami3.Position; GROUND:MoveToPosition(npc_npc_yamirami3, p.X+(8), p.Y+(8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami4.Position; GROUND:MoveToPosition(npc_npc_yamirami4, p.X+(-8), p.Y+(8), false, 1) end -- Move2PositionOffset
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(8), p.Y+(0), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami6.Position; GROUND:MoveToPosition(npc_npc_yamirami6, p.X+(-8), p.Y+(0), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk...", french=" Argh...", german=" Uff...", italian=" Ah...", spanish=" ¡Glup!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk...", french=" Argh...", german=" Uff...", italian=" Ah...", spanish=" ¡Glup!"})
  else
  SkySceneKit.say({english=" Urk...", french=" Argh...", german=" Uff...", italian=" Uh...", spanish=" ¡Glup!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, [hero]! [CS:N]Grovyle[CR]![K]\nYou can't give up!", french="Eh, [hero]! [CS:N]Massko[CR]![K]\nVous ne pouvez pas baisser les bras!", german="Hey, [hero]! [CS:N]Reptain[CR]![K]\nIhr könnt nicht aufgeben!", italian="Ehi, [hero]! [CS:N]Grovyle[CR]![K]\nNon potete mollare!", spanish="¡[hero]! ¡[CS:N]Grovyle[CR]![K]\n¡Escuchadme! ¡No podéis rendiros!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hey, [hero]! [CS:N]Grovyle[CR]![K]\nYou can't give up!", french="Eh, [hero]! [CS:N]Massko[CR]![K]\nVous ne pouvez pas baisser les bras!", german="Hey, [hero]! [CS:N]Reptain[CR]![K]\nIhr könnt nicht aufgeben!", italian="Ehi, [hero]! [CS:N]Grovyle[CR]![K]\nNon potete mollare!", spanish="¡[hero]! ¡[CS:N]Grovyle[CR]![K]\n¡Escuchadme! ¡No podéis rendiros!"})
  else
  SkySceneKit.say({english="Hey, [hero]! [CS:N]Grovyle[CR]![K]\nYou can't give up!", french="Eh, [hero]! [CS:N]Massko[CR]![K]\nVous ne pouvez pas baisser les bras!", german="Hey, [hero]! [CS:N]Reptain[CR]![K]\nIhr könnt nicht aufgeben!", italian="Ehi, [hero]! [CS:N]Grovyle[CR]![K]\nNon potete mollare!", spanish="¡[hero]! ¡[CS:N]Grovyle[CR]![K]\n¡Escuchadme! ¡No podéis rendiros!"})
  end
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, -2) [neutre/état moteur]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 312, 416, Direction.Up, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Gah...[K] You say not to give up...?", french="Argh...[K] Tu nous encourages à\nfaire front...?", german=" Pah...[K] Nicht aufgeben, sagst du?", italian="Ah...[K] Dici che non dobbiamo\narrenderci...?", spanish="¿Cómo?[K] ¿Has dicho que no nos\nrindamos?"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="But what can we possibly do in\nthis bleak situation?", french="Mais qu'est-ce que tu veux\nqu'on fasse? La situation est désespérée!", german="Aber was können wir in dieser\ntrostlosen Situation denn tun?", italian="Ma cos'altro possiamo fare in\nquesta situazione disperata?", spanish="¿Pero qué podemos hacer en\nuna situación tan adversa como esta?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We have to think!", french=" Creusons-nous les méninges!", german=" Wir müssen nachdenken!", italian=" Dobbiamo pensare!", spanish=" ¡Hay que pensar en algo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We have to think!", french=" Creusons-nous les méninges!", german=" Wir müssen nachdenken!", italian=" Dobbiamo pensare!", spanish=" ¡Hay que pensar en algo!"})
  else
  SkySceneKit.say({english=" We have to think!", french=" Creusons-nous les méninges!", german=" Wir müssen nachdenken!", italian=" Dobbiamo pensare!", spanish=" ¡Hay que pensar en algo!"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
