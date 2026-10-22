-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m03a0105.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P04A, 'UM03') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 328, 216, Direction.Down, "NPC_BIPPA")
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" First things first!", french="Commençons par\nl'commencement!", german=" Eins nach dem anderen!", italian=" Prima le cose più importanti!", spanish=" ¡Lo primero es lo primero!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_bippa, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(228, 220, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end) -- message_SetActor(ACTOR_NPC_BIPPA)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Here, we have [CS:N]Croagunk[CR]...", french=" Lui, c'est [CS:N]Cradopaud[CR]...", german=" Hier haben wir [CS:N]Glibunkel[CR]...", italian=" Qui c'è [CS:N]Croagunk[CR]...", spanish=" Aquí tenemos a [CS:N]Croagunk[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="But to tell the truth, I don't\nhave any idea what that Pokémon's up to...", french="Pour être franc, j'sais pas trop\nc'qu'il fabrique dans l'coin, çui-là...", german="Um ehrlich zu sein, ich habe\nkeine Ahnung, was dieses Pokémon treibt.", italian="Ma a dir la verità non ho idea di\ncosa faccia...", spanish="Lo cierto es que no tengo ni idea\nde lo que ese Pokémon se trae entre manos."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="He always seems to be fiddling\naround with that big cauldron back there.\nIt's all a mystery to me! Yup yup!", french="Il passe son temps à traficoter\nle gros chaudron derrière lui. Ça reste un\ngrand mystère pour moi, pour sûr!", german="Er scheint ständig an diesem\ngroßen Kessel da hinten herumzuwerkeln.\nEs ist mir ein Rätsel! Jawollja!", italian="È sempre impegnato ad\narmeggiare con quel gran pentolone lì\ndietro. È un mistero! Già, già!", spanish="Parece estar todo el día\nenredando con ese gran caldero de ahí.\n¡Pero no sé para qué! ¡No, señor...!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(124, 276, 60, false) end) -- performer/caméra
  GROUND:EntTurn(npc_npc_bippa, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Over this way's the mess hall.", french=" Là-bas, y'a l'mess d'la Guilde.", german="In dieser Richtung liegt die\nGildenkantine.", italian=" Da quella parte c'è la mensa.", spanish=" Por ahí se va al comedor."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(300, 276, 60, false) end) -- performer/caméra
  pcall(function() GAME:MoveCamera(508, 276, 60, false) end) -- performer/caméra
  GROUND:EntTurn(npc_npc_bippa, Direction.DownRight)
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="And if you all look that way,\nyou'll find the crew rooms.", french="Et d'ce côté, il y a les\ndortoirs des membres.", german="Und in dieser Richtung findet ihr\ndie Crewräume.", italian="E se guardate da quella parte,\nvedrete le stanze degli altri esploratori.", spanish="Y si vais por allí, encontraréis\nlos dormitorios."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(420, 220, 60, false) end) -- performer/caméra
  GROUND:EntTurn(npc_npc_bippa, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="And this here leads to the\nGuildmaster's Chamber.", french="Et par là, c'est la salle du\nMaître d'la Guilde.", german="Und hier kommt ihr zur Kammer\ndes Gildenmeisters.", italian="Per di lì si va alla Stanza del\nCapitano.", spanish="Y por ahí se va a la Cámara del\nGran Bluff."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(324, 220, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Next, I'll guide you both around\nplaces outside the guild.", french="Maintenant, j'vais vous\nmontrer les alentours d'la Guilde.", german="Als Nächstes führe ich euch\naußerhalb der Gilde herum.", italian="Adesso vi porterò a vedere i\nposti fuori dalla Gilda.", spanish="Ahora, os llevaré a los sitios\nque están fuera del [CS:N]Pokégremio[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_bippa, 324, 116, false, 2)
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(45)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-16), p.Y+(-16), false, 2) end
  GROUND:MoveToPosition(hero, 324, 116, false, 2)
  GAME:WaitFrames(10)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(16), p.Y+(-16), false, 2) end
  GROUND:MoveToPosition(partner, 324, 116, false, 2)
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
