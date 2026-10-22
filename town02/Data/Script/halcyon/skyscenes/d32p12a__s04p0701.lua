-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D32P12A/s04p0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 60) -- $SCENARIO_MAIN = scn[29,60] (ROM)
  -- back_SetGround(LEVEL_D32P12A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(hero, 228, 268, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 252, 280, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 204, 280, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 228, 284, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" That was good work!", french=" Bon travail!", german=" Das war gute Arbeit!", italian=" Ottimo lavoro!", spanish=" ¡Buen trabajo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(24), 24, false) end) -- MovePositionOffset performer/caméra
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Down) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Down) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:EntTurn(__slot, Direction.Down) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_mimiroppu = SkySceneKit.spawn_npc("lopunny", 232, 440, Direction.Up, "NPC_MIMIROPPU")
  GROUND:MoveToPosition(npc_npc_mimiroppu, 228, 316, false, 2)
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 256, 456, Direction.UpLeft, "NPC_SAANAITO")
  GROUND:MoveToPosition(npc_npc_saanaito, 252, 316, false, 2)
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 208, 456, Direction.UpRight, "NPC_CHAAREMU")
  GROUND:MoveToPosition(npc_npc_chaaremu, 204, 316, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="You handled that battle with\nsuperb aplomb.", french="Vous avez mené la bataille avec\nun bel aplomb.", german="Ihr habt diesen Kampf mit\ngroßer Souveränität gemeistert.", italian="Avete affrontato la lotta con\nun aplomb super.", spanish="Habéis librado la batalla\ncon gran aplomo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="You're going to make us look bad\nif we don't pick up the pace!", french="Nous allons perdre de notre\nsuperbe si nous ne nous élevons pas à votre\nniveau!", german="Ihr lasst uns schlecht aussehen,\nwenn wir das Tempo nicht anziehen!", italian="Faremo una brutta figura se\nnon ci diamo una mossa!", spanish="¡Nos haréis quedar mal\ncomo no pillemos el ritmo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Tee-hee! This has become\nunusually exciting for me!", french="Hi hi! Ça devient bien plus\npalpitant que ce que je croyais.", german="Hihi! Das ist ungewöhnlich\naufregend für mich geworden!", italian="Eeh-eeh! Le cose si stanno\nfacendo più emozionanti del solito!", spanish="¡Ji, ji! ¡Esto está siendo\nmuy emocionante!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="But we'll beat you to solving the\nnext mystery!", french="Mais à la prochaine énigme,\nc'est nous qui vous coifferons au poteau!", german="Aber beim Lösen des nächsten\nRätsels schlagen wir euch!", italian="Ma vi batteremo nel\nrisolvere il prossimo mistero!", spanish="¡Pero nosotras resolveremos\nel próximo misterio!"})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" We're off!", french=" Nous partons!", german=" Sind schon weg!", italian=" Andiamo!", spanish=" ¡Vamos allá!"})
  -- message_Close
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(-24), p.Y+(-24), false, 2) end
  GAME:WaitFrames(5)
  do local p=npc_npc_saanaito.Position; GROUND:MoveToPosition(npc_npc_saanaito, p.X+(24), p.Y+(-24), false, 2) end
  GAME:WaitFrames(5)
  do local p=npc_npc_mimiroppu.Position; GROUND:MoveToPosition(npc_npc_mimiroppu, p.X+(48), p.Y+(-24), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Up)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  GROUND:MoveToPosition(npc_npc_chaaremu, 180, 228, false, 2)
  GROUND:MoveToPosition(npc_npc_saanaito, 276, 228, false, 2)
  GROUND:MoveToPosition(npc_npc_mimiroppu, 276, 228, false, 2)
  GROUND:MoveToPosition(npc_npc_chaaremu, 228, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_saanaito, 228, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_mimiroppu, 228, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_chaaremu, 228, 124, false, 2)
  GROUND:MoveToPosition(npc_npc_saanaito, 228, 124, false, 2)
  GROUND:MoveToPosition(npc_npc_mimiroppu, 228, 124, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.cleanup_npcs()
end
