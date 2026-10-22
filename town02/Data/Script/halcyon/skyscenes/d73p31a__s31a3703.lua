-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P31A/s31a3703.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Restored.ogg", true) end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_D73P31A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  SkySubScreen.Show("v24p08a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(60)
  local npc_npc_kuchiito = SkySceneKit.spawn_npc("mawile", 176, 304, Direction.UpRight, "NPC_KUCHIITO")
  GROUND:MoveToPosition(npc_npc_kuchiito, 204, 268, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_goorikii = SkySceneKit.spawn_npc("machoke", 200, 336, Direction.UpRight, "NPC_GOORIKII")
  GROUND:MoveToPosition(npc_npc_goorikii, 196, 308, false, 1)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(hero, 288, 300, false, 1)
  GAME:WaitFrames(10)
  local npc_npc_kinogassa = SkySceneKit.spawn_npc("breloom", 248, 344, Direction.Up, "NPC_KINOGASSA")
  GROUND:EntTurn(npc_npc_kinogassa, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 300, 340, false, 1) end end
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 340, 284, false, 1) end end
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_kinogassa, 244, 324, false, 1) -- SlidePositionMark (glissement)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="This is the summit?\nIt's just such a change from what we\nwere looking at before...", french="Alors ça ressemble à ça,\nle sommet? Rien à voir avec tout à l'heure...", german="Das ist also der Gipfel?\nEr hat sich wirklich verändert gegenüber\nder Müllkippe von zuvor...", italian="È questa la cima?\nÈ completamente cambiata rispetto\na prima...", spanish="¿Seguimos estando en la cima?\nMenudo cambiazo, no se parece en nada a\nlo que se veía hace solo un momento..."})
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english=" It's so beautiful...", french=" C'est tellement beau...", german=" Er ist so schön...", italian=" Che meraviglia...", spanish=" Es precioso..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="I've never seen such beautiful\nscenery before...", french="Je n'avais jamais vu de\npaysage aussi beau...", german="So eine schöne Aussicht sehe\nich zum ersten Mal...", italian="Non ho mai visto un panorama\ncosì bello...", spanish="Nunca había visto un paisaje\ntan hermoso..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_goorikii) end)
  SkySceneKit.say({english=" .........", french=" ..........", german=" ..........", italian=" ..........", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_sheimi = SkySceneKit.spawn_npc("shaymin", 256, 288, Direction.Down, "NPC_SHEIMI")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Congratulations on reaching\nthe summit!", french="Félicitations pour avoir atteint\nle sommet!", german="Meinen herzlichen Glückwunsch\nfür das Erreichen des Gipfels!", italian="Congratulazioni per aver\nraggiunto la cima!", spanish="¡Enhorabuena por llegar\na la cima!"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" This is the [CS:P]Sky Peak[CR] Summit!", french="Vous êtes au\n[CS:P]Sommet du Pic Céleste[CR]!", german=" Dies ist die [CS:P]Himmelsgipfelspitze[CR]!", italian="Questa è la vetta\ndel [CS:P]Picco del Cielo[CR]!", spanish=" ¡Esta es la [CS:P]Cumbre del Cielo[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_goorikii, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_goorikii) end)
  SkySceneKit.say({english="Wow!\nWe did it!!", french="Waouh!!\nOn a réussi!!", german="Wow!!!\nWir haben es geschafft!!!", italian="Wow!!!\nCe l'abbiamo fatta!!!", spanish=" ¡¡Qué fuerte!! ¡Lo hemos conseguido!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_goorikii, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kinogassa, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="At last! We've reached\nthe summit!", french=" On a enfin atteint le sommet!", german="Endlich!\nWir haben den Gipfel erreicht!", italian="Finalmente abbiamo raggiunto\nla cima!", spanish=" ¡Al fin hemos alcanzado la cima!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_kuchiito.Position; GROUND:MoveToPosition(npc_npc_kuchiito, p.X+(16), p.Y+(-16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_kuchiito, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kuchiito, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_kinogassa, nil, 0) end) -- EFFECT_NONE
  -- message_FacePositionOffset(2, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english=" Hey, everyone! Look over here!", french="Hé, tout le monde!\nRegardez!", german=" Hey, alle! Seht mal dort!", italian="Ehi! Venite tutti a dare\nun'occhiata!", spanish=" ¡Eh, mirad esto!"})
  -- message_Close
  GROUND:EntTurn(npc_npc_sheimi, Direction.Up)
  GROUND:EntTurn(npc_npc_goorikii, Direction.Up)
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_kinogassa, Direction.Up)
  GAME:WaitFrames(3)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_kuchiito, 220, 172, false, 2)
  GAME:WaitFrames(30)
  pcall(function() GAME:MoveCamera(252, 196, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_goorikii, 228, 196, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_kinogassa, 228, 300, false, 2)
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 316, 204, false, 2) end end
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 292, 196, false, 2) end end
  GROUND:MoveToPosition(hero, 272, 172, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
