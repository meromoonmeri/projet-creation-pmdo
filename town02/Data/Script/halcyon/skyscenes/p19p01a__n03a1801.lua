-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P19P01A/n03a1801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_aamarudo = SkySceneKit.spawn_npc("armaldo", 256, 176, Direction.Down, "NPC_AAMARUDO")
  -- SetAnimation(2) [anim idle native]
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
  SkySceneKit.say({english="Huh?[K] Junior, did you finish\ngetting ready?", french="Hein?[K] Petit, tu as fini\ntes préparatifs?", german="Hmmm...[K]\nJunior, bist du schon so weit?", italian="Uh?[K] Piccolo, hai finito\ndi prepararti?", spanish="¿Eh?[K] ¿Ya has acabado de\nprepararte, peque?"})
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_aamarudo, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local __choice = SkySceneKit.ask({{english="Yep!", french="Voui!", german="Ja!", italian="Sì!", spanish="¡Sí!"}, {english="Not yet.", french="Nan.", german="Fast...", italian="No.", spanish="Aún no"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  if (SkyProg.cmp_side(42, 3) == 0) then -- if ROM: scn($SCENARIO_SIDE) == [42, 3]
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" What do you mean, not yet?", french=" Comment ça, \\\"nan\\\"?", german=" Was meinst du mit [F:S2]Fast...[F:E2]?", italian=" Che significa \\\"no\\\"?", spanish=" ¿Cómo que aún no?"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Once you're ready, we'll go.", french=" Quand tu seras prêt, on partira.", german="Wir brechen auf, sobald du\nfertig bist.", italian=" Quando sei pronto, si parte.", spanish="No nos iremos hasta que\nestés listo."})
  -- message_Close
  -- @label_5 [étiquette de flux ExplorerScript]
  -- SetAnimation(4) [anim idle native]
  else
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" What do you mean, not yet?", french=" Comment ça, \\\"nan\\\"?", german=" Was meinst du mit [F:S2]Fast[F:E2]?", italian=" Che significa \\\"no\\\"?", spanish=" ¿Cómo que aún no?"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="It's all right.[K] I'll wait until\nyou're ready, so take your time.", french="Soit.[K] Dans ce cas, prends ton\ntemps, j'attendrai que tu aies terminé.", german="Schon in Ordnung.[K] Ich warte, bis\ndu bereit bist, lass dir also ruhig Zeit.", italian="E va bene.[K] Aspetterò finché non\nsei pronto, fai pure con calma.", spanish="No pasa nada.[K] Me espero hasta\nque estés listo, tómate tu tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Once you're ready, we'll go.", french=" Quand tu seras prêt, on partira.", german="Wir brechen auf, sobald du\nfertig bist.", italian=" Quando sei pronto, partiamo.", spanish=" Nos iremos cuando estés listo."})
  -- message_Close
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if (SkyProg.cmp_side(42, 3) == 0) then -- if ROM: scn($SCENARIO_SIDE) == [42, 3]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 228, 244, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep. ♪", french=" Voui. ♪", german=" Ja. ♪", italian=" Sì. ♪", spanish=" Vale. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_aamarudo, 252, 220, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_aamarudo, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(4)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" All right, then!", french=" Très bien!", german=" Also gut!", italian=" Ok!", spanish=" De acuerdo, entonces."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Let's go![K] To [CS:P]Eastern Cave[CR]!", french="En avant![K] En route pour\nla [CS:P]Caverne de l'Est[CR]!", german="Machen wir uns auf![K]\nZur [CS:P]Östlichen Höhle[CR]!", italian=" Andiamo![K] Alla [CS:P]Grotta Orientale[CR]!", spanish=" ¡Vamos![K] ¡A la [CS:P]Cueva Oriental[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- @label_3 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep. ♪", french=" Voui. ♪", german=" Ja. ♪", italian=" Sì. ♪", spanish=" Sí. ♪"})
  -- message_Close
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(180), false, 2) end
  GAME:WaitFrames(4)
  do local p=npc_npc_aamarudo.Position; GROUND:MoveToPosition(npc_npc_aamarudo, p.X+(0), p.Y+(180), false, 2) end
  GAME:WaitFrames(40)
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- main_EnterDungeon(129, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else
  GROUND:MoveToPosition(hero, 228, 244, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep. ♪", french=" Voui! ♪", german=" Ja. ♪", italian=" Sì. ♪", spanish=" Sí. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_aamarudo, 252, 220, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_aamarudo, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(4)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" All right!", french=" Très bien!", german=" Sehr gut!", italian=" Bene!", spanish=" ¡Muy bien!"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="All right, let's go![K]\nWe're looking for the treasure in\n[CS:P]Eastern Cave[CR]!", french="Allons-y![K]\nNous partons à la recherche du trésor\nde la [CS:P]Caverne de l'Est[CR]!", german="Sehr gut, lass uns aufbrechen![K]\nWir sind auf der Suche nach dem Schatz der\n[CS:P]Östlichen Höhle[CR]!", italian="In marcia, allora![K] Andiamo\nalla ricerca del tesoro che si nasconde\nnella [CS:P]Grotta Orientale[CR]!", spanish="Bueno, pues vamos.[K] ¡Tenemos\nque encontrar el tesoro de la [CS:P]Cueva Oriental[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Got it, Junior?[K] You're just a\nbeginner when it comes to exploring.", french="Compris, petit?[K] Tu n'es encore\nqu'un novice en matière d'exploration.", german="Verstanden, Junior?[K] Du bist noch\nein Anfänger, wenn es um Erkundungen geht.", italian="Però ascoltami, piccolo![K]\nRicordati che sei solo un esploratore\nalle prime armi.", spanish="No sé si eres consciente, pero...[K]\nEres un novato en lo que a explorar se refiere."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Don't be so impertinent,\nand don't hold me back!", french="Ne sois pas si effronté,\net ne traîne pas dans mes pattes!", german="Sei nicht so frech und halte\nmich nicht auf!", italian="Quindi comportati bene e cerca\ndi non rallentarmi!", spanish="¡Más te vale que no seas tan\nimpertinente y no me entretengas!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
