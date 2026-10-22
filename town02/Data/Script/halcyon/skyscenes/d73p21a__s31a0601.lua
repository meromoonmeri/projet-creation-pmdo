-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P21A/s31a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 12) -- $SCENARIO_MAIN = scn[29,12] (ROM)
  local npc_npc_sheimi = SkySceneKit.spawn_npc("shaymin", 232, 448, Direction.Up, "NPC_SHEIMI")
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We're almost to the\n1st Station Clearing. [K]You can do it!", french="Plus que quelques efforts\njusqu'à la trouée du 1[F:ER] Relais.[K]\nVous pouvez le faire!", german="Wir haben die\n1. Zwischenlagerlichtung fast erreicht.[K]\nIhr schafft das!", italian="Siamo quasi al Bivacco 1.[K]\nPossiamo farcela!", spanish="Ya casi hemos llegado a la Base\ndel Primer Puerto.[K] ¡No desfallezcamos!"})
  -- message_Close
  -- back_SetGround(LEVEL_D73P21A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_D73P21A, 'US31') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(40) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(42) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(43) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(44) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(45) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(9) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Sky Peak Forest.ogg", true) end)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_sheimi, 228, 284, false, 2)
  GROUND:MoveToPosition(hero, 228, 324, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 252, 316, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 204, 316, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sheimi, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" This is the 1st Station Clearing.", french=" Voici la trouée du 1[F:ER] Relais.", german="Das hier ist die\n1. Zwischenlagerlichtung.", italian=" Questo è il Bivacco 1.", spanish=" Esta es la Base del Primer Puerto."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="[CS:P]Sky Peak[CR] has resting areas,\nlabeled 1st Station through 9th Station.", french="On trouve des bivouacs sur le\n[CS:P]Pic Céleste[CR], on les appelle \"relais\".\nIl y en a neuf en tout.", german="Der [CS:P]Himmelsgipfel[CR] bietet\nZwischenlagerlichtungen zum Verschnaufen.\nSie sind nummeriert von 1 bis 9.", italian="Lungo il [CS:P]Picco del Cielo[CR] ci sono\nnove aree, note come Bivacchi, dove\nè possibile fare una sosta.", spanish="La [CS:P]Cumbre del Cielo[CR] tiene zonas\nde descanso numeradas, del Primer Puerto\nal Noveno Puerto."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="The 10th Station is, of course,\nthe summit.", french="Le 10[F:E] Relais, bien sûr,\nc'est le sommet.", german="Und danach kommt\nselbstverständlich der Gipfel.", italian="Naturalmente, il Bivacco 10\nè la cima.", spanish="El Décimo Puerto obviamente es\nla cima."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="The road ahead is long, so let's\ntake it in stages.", french="La route est longue jusqu'au\nsommet, alors il vaut mieux\nprocéder par étapes.", german="Der Weg vor uns ist weit, also\nlasst ihn uns in Abschnitten bewältigen.", italian="Ci attende un lungo cammino,\nquindi dovremo procedere a tappe.", spanish="Nos aguarda un largo camino,\nasí que es mejor dividirlo en etapas."})
  -- message_Close
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 276, 316, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 180, 316, false, 2) end end
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.UpRight) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.cleanup_npcs()
end
