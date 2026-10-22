-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P19P01A/n03a1901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_aamarudo = SkySceneKit.spawn_npc("armaldo", 256, 176, Direction.Down, "NPC_AAMARUDO")
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetPositionLives(6) [cible objet/id de décor NDS non simulée - trace]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(228, 244, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_aamarudo, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Huh?[K] Junior, did you finish\ngetting ready?", french="Hein?[K] Petit, tu as fini\ntes préparatifs?", german="Hmmm...[K] Junior, bist du schon\nfertig mit deinen Vorbereitungen?", italian="Uh?[K] Piccolo, hai finito\ndi prepararti?", spanish="¿Eh?[K] ¿Has acabado de\nprepararte, peque?"})
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_aamarudo, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local __choice = SkySceneKit.ask({{english="Yep!", french="Voui!", german="Ja!", italian="Sì!", spanish="¡Sí!"}, {english="Not yet.", french="Nan.", german="Fast...", italian="No.", spanish="Aún no"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 228, 244, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep. ♪", french=" Voui! ♪", german=" Genau. ♪", italian=" Sì. ♪", spanish=" Sí. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_aamarudo, 252, 220, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_aamarudo, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(4)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" All right!", french=" Très bien!", german=" Alles klar!", italian=" Bene!", spanish=" ¡Muy bien!"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="OK, let's go![K]\nTo [CS:P]Fortune Ravine[CR]!", french="En avant![K] En route pour\nle [CS:P]Ravin Aubaine[CR]!", german="Also, machen wir uns auf![K]\nZur [CS:P]Schicksalsschlucht[CR]!", italian="In marcia![K]\nAlla [CS:P]Gola del Tesoro[CR]!", spanish="¡Venga, pues vamos![K]\n¡Al [CS:P]Risco Fortuna[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep. ♪", french=" Voui. ♪", german=" Au ja. ♪", italian=" Sì. ♪", spanish=" Sí. ♪"})
  -- message_Close
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(180), false, 2) end
  GAME:WaitFrames(4)
  do local p=npc_npc_aamarudo.Position; GROUND:MoveToPosition(npc_npc_aamarudo, p.X+(0), p.Y+(180), false, 2) end
  GAME:WaitFrames(40)
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  -- supervision_ExecuteCommon(CORO_EVENT_N03_10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" What do you mean, not yet?", french=" Comment ça, \\\"nan\\\"?", german=" Was meinst du mit [F:S2]Fast...[F:E2]?", italian=" Che significa \\\"no\\\"?", spanish=" ¿Cómo que aún no?"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Once you're ready, we'll go.", french=" Quand tu seras prêt, on partira.", german="Wir brechen auf, sobald du\nfertig bist.", italian=" Quando sei pronto, si parte.", spanish=" Nos iremos cuando estés listo."})
  -- message_Close
  -- SetAnimation(4) [anim idle native]
  else -- default/annulation
  GROUND:MoveToPosition(hero, 228, 244, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_aamarudo, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
