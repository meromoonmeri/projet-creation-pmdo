-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D57P44A/n04a2601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D57P44A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_goosuto = SkySceneKit.spawn_npc("haunter", 240, 208, Direction.Down, "NPC_GOOSUTO")
  -- SetAnimation(25) [anim idle native]
  local npc_npc_goosuto2 = SkySceneKit.spawn_npc("haunter", 208, 200, Direction.Down, "NPC_GOOSUTO2")
  -- SetAnimation(25) [anim idle native]
  local npc_npc_goosuto3 = SkySceneKit.spawn_npc("haunter", 272, 200, Direction.Down, "NPC_GOOSUTO3")
  -- SetAnimation(25) [anim idle native]
  -- SetOutputAttribute(8) [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" OWowowowowowow...", french=" Ouilla ouah ouilla...", german=" Auauauauauauau...", italian=" AHI ahi ahi ahi ahi ahi ahi...", spanish=" Ay, ay, ay, ay..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" Owwwwwwww...", french=" Ouillaaaaaaaaa...", german=" Auuuuuuuu...", italian=" Aaahhhhhhhhh...", spanish=" Aaaaay..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" I-I give up...", french=" J-je me rends...", german=" I-ich gebe auf...", italian=" M-Mi arrendo...", spanish=" Vale... me rindo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 256, 256, Direction.Up, "NPC_DOGOOMU")
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_dogoomu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, hero, 4) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="ALL RIGHT![K] We've knocked OUT\nEVERY [CS:N]Haunter[CR]!", french="TRES BIEN![K] On a mis K.O.\nTOUS les [CS:N]Spectrum[CR]!", german="GUT gemacht![K] WIR haben ALLE\n[CS:N]Alpollo[CR] ERLEDIGT!", italian="EVVIVA![K] Abbiamo SCONFITTO\nTUTTI gli [CS:N]Haunter[CR]!", spanish="¡Genial![K] ¡Hemos tumbado a todos\nlos [CS:N]Haunter[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yippee!", french=" Youpiii!", german=" Juchhu!", italian=" Urrà!", spanish=" ¡Yupiiiiii!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Let's hurry and\narrest them! ♪", french="Dépêchons-nous de\nles arrêter! ♪", german="Beeilen wir uns und nehmen\nsie fest! ♪", italian=" Forza, arrestiamoli! ♪", spanish=" ¡Deprisa, vamos a arrestarlos! ♪"})
  -- message_Close
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-40), false, 2) end
  GAME:WaitFrames(10)
  do local p=npc_npc_dogoomu.Position; GROUND:MoveToPosition(npc_npc_dogoomu, p.X+(0), p.Y+(-40), false, 2) end
  pcall(function() SOUND:FadeOutBGM(150) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
end
