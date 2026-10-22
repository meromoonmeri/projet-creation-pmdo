-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P29A/s31a3101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 28) -- $SCENARIO_MAIN = scn[29,28] (ROM)
  local npc_npc_sheimi = SkySceneKit.spawn_npc("shaymin", 232, 416, Direction.Up, "NPC_SHEIMI")
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We're almost to the 9th Station\nClearing! Come on!", french="Nous sommes presque à la\ntrouée du 9[F:E] Relais! Allez!", german="Wir sind schon fast bei der\n9. Zwischenlagerlichtung! Nicht aufgeben!", italian="Ormai siamo al Bivacco 9!\nForza!", spanish="Ya casi estamos en la Base del\nNoveno Puerto. ¡Venga, vamos!"})
  -- message_Close
  -- back_SetGround(LEVEL_D73P29A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_D73P29A, 'US31') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(20) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(9) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_SKY_PEAK_FINAL_PASS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_sheimi, 228, 260, false, 2)
  GROUND:MoveToPosition(hero, 228, 300, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 252, 292, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 204, 292, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sheimi, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Phew...\nHere we are, the 9th Station Clearing.", french="Pfiou...\nNous y voilà: la trouée du 9[F:E] Relais.", german="Puh... Endlich.\nDie 9. Zwischenlagerlichtung.", italian="Fiuuu...\nEccoci qua... il Bivacco 9.", spanish="Uf...\nPor fin, esta es la Base del Noveno Puerto."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="I think Team [CS:X]Frontier[CR] already\nwent on ahead.", french="Je crois que l'Equipe [CS:X]Eclaireurs[CR]\nest arrivée avant nous.", german="Ich nehme an, Team [CS:X]Grenzland[CR]\nist schon weitergezogen.", italian="Penso che il Team [CS:X]Pioniere[CR]\nsia già andato avanti.", spanish="Creo que el [CS:X]Equipo Frontera[CR]\nya ha pasado por aquí."})
  -- message_Close
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" .........", french=" ..........", german=" ..........", italian=" ..........", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Something seems different from\nthe last time I was here...", french="Quelque chose semble avoir\nchangé depuis la dernière fois\nque je suis venue...", german="Irgendetwas ist anders\nals beim letzten Mal, als ich hier war...", italian="C'è qualcosa di diverso rispetto\nall'ultima volta che sono stata qui...", spanish="Creo que hay algo diferente\nde la última vez que estuve aquí..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sheimi, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Oh! Sorry...", french=" Oh! Pardon...", german=" Oh! Entschuldige...", italian=" Oh! Scusate...", spanish="Huy, perdón, estaba pensando\nen voz alta..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="It's nothing. Probably just my\nimagination.", french="Ce n'est rien. Ce doit être mon\nimagination qui me joue des tours.", german="Es ist nichts. Ich habe mir\nwohl nur etwas eingebildet.", italian="Non è niente. Forse è solo\nla mia immaginazione.", spanish="Seguramente no sea nada y solo\nsea producto de mi imaginación."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Well, at any rate, it's only a\nlittle farther to the summit! Keep at it!", french="Bon, peu importe, il ne nous\nreste plus qu'un petit bout de chemin\njusqu'au sommet! Continuons!", german="Na, auf jeden Fall ist es nur noch\nein kleines Stück bis zur Spitze, also los!", italian="Beh, in ogni caso manca poco\nalla cima! Non molliamo!", spanish="En cualquier caso, solo queda un\npoquito más hasta la cima. ¡Sigamos!"})
  -- message_Close
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 276, 292, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 180, 292, false, 2) end end
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.UpRight) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.cleanup_npcs()
end
