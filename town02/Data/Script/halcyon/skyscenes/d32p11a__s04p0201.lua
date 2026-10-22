-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D32P11A/s04p0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 57) -- $SCENARIO_MAIN = scn[29,57] (ROM)
  -- back_SetGround(LEVEL_D32P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Aegis Cave.ogg", true) end)
  GROUND:MoveToPosition(hero, 228, 292, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 252, 308, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 204, 308, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 228, 316, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  local npc_npc_mimiroppu = SkySceneKit.spawn_npc("lopunny", 192, 264, Direction.DownRight, "NPC_MIMIROPPU")
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="There you are![K] Well, this is\n[CS:P]Aegis Cave[CR].", french="Vous voilà![K] Eh bien, voici\nla [CS:P]Grotte Egide[CR].", german="Und da sind wir![K] Das hier ist\ndie [CS:P]Ägishöhle[CR].", italian="Eccovi qui![K] Beh, questa è la\n[CS:P]Grotta Egida[CR].", spanish="¡Ya está![K] Bueno, esto es la\n[CS:P]Cueva Regia[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="Beyond this point is unknown\nterritory. No one has ever been inside.", french="A partir d'ici, nous entrons\ndans un territoire bizarre. Personne n'a\njamais pénétré à l'intérieur.", german="Hinter diesem Punkt liegt\nunbekanntes Territorium. Niemand hat es je\nbetreten.", italian="Oltre questo punto si trova una\nzona inesplorata. Nessuno è mai entrato.", spanish="A partir de aquí es territorio\ndesconocido. Nadie se ha adentrado nunca."})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="Just imagine what mysteries\nawait us inside. Isn't it exciting, darlings?", french="Songez aux mystères qui\nattendent d'être dévoilés. N'est-ce pas\npalpitant, mes mignons?", german="Stellt euch vor, was für\nGeheimnisse uns da drin erwarten. Ist das\nnicht aufregend, ihr Lieben?", italian="Pensate ai misteri che ci\nattendono all'interno. Non è eccitante, tesori?", spanish="Imaginaos los misterios que nos\nesperan. ¿Emocionante, verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 272, 248, Direction.DownLeft, "NPC_HEIGANI")
  GROUND:EntTurn(npc_npc_heigani, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey, hey! This thing looks\nimportant somehow!", french="Eh dis donc! Ce truc a l'air\nimportant, vous ne trouvez pas?", german="Hey, hey, hey! Das Ding sieht\nirgendwie wichtig aus!", italian="Ehi, ehi, ehi! Questa cosa sembra\nabbastanza importante!", spanish="¡Oye, oye, oye! ¡Esto parece\nalgo importante!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 168, 248, Direction.DownRight, "NPC_SAANAITO")
  GROUND:EntTurn(npc_npc_saanaito, Direction.Right)
  GROUND:EntTurn(npc_npc_mimiroppu, Direction.UpRight)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 296, 264, Direction.DownLeft, "NPC_BIPPA")
  GROUND:EntTurn(npc_npc_bippa, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Yup yup. It's got these\nodd-shaped grooves gouged out, by golly.", french="Ouaip ouaip! Regardez, y'a des\ndrôles de symboles gravés dedans, sapristi!", german="Jawollja. Hier sind so\nmerkwürdig geformte Rillen eingemeißelt,\nMenschenskind.", italian="Già, già. Che strane incisioni\nci sono, ohibò.", spanish="Sí, señor. Hay unas ranuras\nmuy extrañas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-3, -1) [neutre/état moteur]
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 192, 232, Direction.DownRight, "NPC_CHAAREMU")
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="It's got a trick to it, I'm sure.\nThere has to be!", french="Il doit y avoir une astuce,\nj'en suis sûre. Il y a forcément un truc!", german="Es muss einen Trick hierbei\ngeben, da bin ich sicher. Es muss so sein!", italian="Sono sicura che c'è qualche\ntrucco. Ci deve essere!", spanish=" Esto tiene truco, ¡seguro!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-3, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="I'll solve that mystery!\nYou watch me now!", french="Je résoudrai ce mystère!\nSoyez-en certains!", german="Ich löse dieses Geheimnis jetzt!\nPasst nur auf!", italian="Risolverò questo mistero!\nState a vedere!", spanish="¡Resolveré este misterio!\n¡Atención!"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_mimiroppu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_mimiroppu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="Oh, yes.[K] We've asked everyone\nelse already, but what's your team's name?", french="Oh.[K] Nous connaissons\nles noms de toutes les équipes, sauf le vôtre.\nVous vous appelez...?", german="Oh ja.[K] Wir haben schon alle\nanderen gefragt, aber wie heißt euer Team\nnoch mal?", italian="Oh, sì.[K] Lo abbiamo già\nchiesto a tutti gli altri, ma come si chiama la\nvostra squadra?", spanish="Ah, por cierto.[K] Ya hemos\npreguntado a los demás pero, ¿cómo se llama\nvuestro equipo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_bippa, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_heigani, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_saanaito, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" Ah, you're Team [team:].", french="Ah, vous êtes l'Equipe\n[team:].", german=" Ah, ihr seid Team [team:].", italian=" Ah, siete il Team [team:].", spanish=" Ah, sois el [CS:X]Equipo[CR] [team:]."})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" That's quite a good name.", french=" C'est joli tout plein comme nom.", german=" Das ist ein echt guter Name.", italian=" È proprio un bel nome.", spanish=" Es un buen nombre."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" I think we should be on our way.", french="Je pense que nous devrions\ny aller.", german="Wir sollten uns auf den Weg\nmachen, denke ich.", italian=" Penso che dovremmo muoverci.", spanish=" Bueno, arranquemos."})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="Let's see who can find the big\ntreasure, or treasures, of this place.", french="Voyons qui découvrira le ou les\nplus gros trésors de cet endroit!", german="Sehen wir mal, wer den großen\nSchatz - oder die Schätze - hier herausholen\nkann.", italian="Vediamo chi riesce a trovare il\ngrande tesoro, o i tesori, di questo posto.", spanish="A ver quién encuentra los\ntesoros de este lugar."})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="Of course, we'd be disappointed\nin ourselves if we weren't first! Tee-hee!", french="Bien évidemment, nous serions\nextrêêêmement déçues de ne pas être les\ngrandes gagnantes! Hi hi!", german="Natürlich wären wir sehr\nenttäuscht von uns selbst, wenn wir nicht die\nErsten wären! Hihi!", italian="Naturalmente ci rimarremmo\nmale se non fossimo noi le prime! Eeh-eeh!", spanish="¡Espero que seamos nosotras!\n¡Ji, ji, ji!"})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="But let's wish each other the\nbest of luck!", french="Mais je vous souhaite bonne\nchance quand même!", german="Aber wünschen wir uns\ngegenseitig Glück.", italian="Ma auguriamoci buona\nfortuna a vicenda!", spanish=" ¡Pero deseémonos buena suerte!"})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" OK, sweeties, we're off!", french=" C'est parti, mes chéris!", german=" Okay, ihr Süßen, wir sind weg!", italian=" Ok, dolcezze, noi andiamo!", spanish="De acuerdo, encantos,\n¡vamos allá!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_chaaremu, 228, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_saanaito, 228, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_mimiroppu, 188, 228, false, 2)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 272, 224, Direction.DownLeft, "NPC_DOGOOMU")
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpLeft)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_mimiroppu, 228, 124, false, 2)
  GROUND:MoveToPosition(npc_npc_chaaremu, 228, 124, false, 2)
  GROUND:MoveToPosition(npc_npc_saanaito, 228, 124, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(3, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="YEAH! I'll be the first to find\nthe treasure!", french="OUAIS! Je serai le premier\nà trouver le trésor!", german="Jaaa! Ich werde den Schatz\nzuerst finden!", italian="SÌ! Sarò il primo a trovare\nil tesoro!", spanish="¡Seré el primero en encontrar el\ntesoro! ¡Sí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_dogoomu, 228, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 228, 124, false, 2)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Yup yup, we'll have to step it\nup, by golly!", french="Ouaip ouaip, il faut qu'on\ns'secoue les puces, pour sûr!", german="Jawollja, wir müssen eine\nSchippe drauflegen, Menschenskind!", italian="Già, già. Dovremo mettercela\ntutta, ohibò!", spanish=" Habrá que darse prisa. Sí, señor."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(0), p.Y+(-16), false, 2) end
  GROUND:MoveToPosition(npc_npc_bippa, 228, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 228, 124, false, 2)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey, hey!", french=" Eh dis donc!", german=" Hey, hey, hey!", italian=" Ehi, ehi, ehi!", spanish=" ¡Oye, oye, oye!"})
  -- message_Close
  do local p=npc_npc_heigani.Position; GROUND:MoveToPosition(npc_npc_heigani, p.X+(0), p.Y+(-16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "shock", 1) end)
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(npc_npc_heigani, 228, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_heigani, 228, 124, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 268, 308, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 184, 308, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 208, 324, false, 2) end end
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.UpRight) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.cleanup_npcs()
end
