-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D42P21A/n01a1501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=40, sub=4} -- $SCENARIO_SIDE = scn[40,4] (ROM)
  -- back_SetGround(LEVEL_D42P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(30) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_yukikaburi = SkySceneKit.spawn_npc("snover", 248, 416, Direction.Up, "NPC_YUKIKABURI")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_DEEP_STAR_CAVE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 212, 268, false, 2)
  GROUND:MoveToPosition(npc_npc_yukikaburi, 244, 268, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_yukikaburi, Direction.UpLeft)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_yukikaburi, Direction.Up)
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_yukikaburi, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" We've gone pretty far...", french=" On a fait un bon bout d'chemin...", german="Wir sind ziemlich\nweit gekommen...", italian=" Abbiamo fatto parecchia strada...", spanish=" Hemos llegado bastante lejos..."})
  GROUND:EntTurn(npc_npc_yukikaburi, Direction.Up)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yukikaburi, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Aren't we to [CS:N]Jirachi[CR]'s place yet?", french="C'est encore loin,\nlà où s'trouve [CS:N]Jirachi[CR]?", german="Müssten wir nicht bald den Ort,\nan dem [CS:N]Jirachi[CR] lebt, erreichen?", italian="Non siamo ancora arrivati\nda [CS:N]Jirachi[CR]?", spanish="¿Falta mucho para llegar a\nla guarida de [CS:N]Jirachi[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yukikaburi, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="Hmm... I don't really\nknow, either...", french="Mmh... A vrai dire, je n'en sais\npas plus que toi...", german="Hmmm... Das kann ich leider\nauch nicht sagen...", italian=" Mmm... Non saprei proprio...", spanish="Hum... La verdad es que\nyo tampoco lo sé..."})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="It's probably close. We just need\nto go a little farther...", french="On n'est sûrement pas loin.\nIl faut sans doute juste progresser\nencore un peu...", german="Möglicherweise sind wir schon\nnah dran. Wir müssen nur noch ein bisschen\nweiter...", italian="Ma non dovrebbe mancare molto.\nProbabilmente dobbiamo proseguire solo\nun altro po'...", spanish="Seguramente ya estemos cerca.\nSolo tenemos que avanzar un poco más..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Is that right?!", french=" Vrai de vrai?!", german=" Ist das so?!?", italian=" Dici?!", spanish=" ¡¿Tú crees?!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="All right, let's dig our heels in!\nI'll do my best!", french="Parfait, c'est pas l'moment\nd'mollir! Je ferai d'mon mieux!", german="Alles klar, strengen wir uns an!\nIch gebe mein Bestes!", italian="Bene allora, in marcia!\nCe la metterò tutta!", spanish="Bueno, pues vamos a seguir.\n¡Y yo voy a darlo todo!"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
