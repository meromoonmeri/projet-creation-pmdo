-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D56P11A/n06a1901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D56P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 224, 344, Direction.Up, "NPC_CHAAREMU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 288, 392, Direction.Up, "NPC_SAANAITO")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_ILLUSION_STONE_CHAMBER non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(npc_npc_chaaremu, 220, 212, false, 2)
  GROUND:MoveToPosition(hero, 252, 228, false, 2)
  GAME:WaitFrames(6)
  GROUND:MoveToPosition(npc_npc_saanaito, 284, 212, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Somehow it seems like the\nscenery has changed slightly from before...", french="Cette salle est différente\ndes précédentes...", german="Es sieht fast so aus, als ob sich\ndie Umgebung im Vergleich zu vorhin ein\nwenig verändert hat...", italian="In qualche modo sembra che\nil paesaggio sia leggermente cambiato\nrispetto a prima...", spanish="Parece que el paisaje\nha cambiado un poco..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Huh?", french=" Vous voyez?", german=" Was...", italian=" Eh?", spanish=" ¿Eh?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(252, 212, 60, false) end) -- performer/caméra
  GROUND:EntTurn(npc_npc_chaaremu, Direction.UpRight)
  GAME:WaitFrames(6)
  GROUND:EntTurn(npc_npc_saanaito, Direction.UpRight)
  GAME:WaitFrames(6)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.UpLeft)
  GAME:WaitFrames(6)
  GROUND:EntTurn(npc_npc_saanaito, Direction.UpLeft)
  GAME:WaitFrames(6)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:EntTurn(npc_npc_chaaremu, Direction.UpRight)
  GAME:WaitFrames(6)
  GROUND:EntTurn(npc_npc_saanaito, Direction.UpRight)
  GAME:WaitFrames(6)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Here...[K] There's two entrances?", french=" Là...[K] Il y a deux entrées.", german=" Da...[K] Dort sind zwei Eingänge?", italian=" Qui...[K] ci sono due entrate?", spanish=" Aquí...[K] ¿hay dos entradas?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Looks like the labyrinth\ncontinues...", french="Nous ne sommes pas encore\nsorties du labyrinthe...", german="Sieht fast so aus, als ob das\nLabyrinth weitergeht...", italian=" Sembra che il labirinto continui...", spanish=" Parece que el laberinto continúa..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="We probably have to choose the\ncorrect entrance to proceed.", french="Il doit falloir choisir la bonne\nentrée pour pouvoir continuer.", german="Wir müssen uns wohl für\nden richtigen Eingang entscheiden,\num voranzukommen.", italian="Forse per proseguire dobbiamo\nscegliere l'entrata giusta.", spanish="Supongo que habrá que elegir\nla entrada correcta para poder avanzar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Yeah...[K] But which one should\nwe choose?", french=" Ouais...[K] mais laquelle c'est?", german="Genau...[K] Nur welchen sollen\nwir wählen?", italian=" Già...[K] Ma quale?", spanish=" Sí...[K] Pero... ¿cuál será?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_chaaremu, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Hmm...[K] Just looking at them,\nthey seem to be the same...", french="Hum...[K] à première vue,\nelles sont identiques...", german="Hmmm...[K] Wenn ich sie mir so\nanschaue, sehen sie wirklich gleich aus...", italian="Uhm...[K] A prima vista, sembrano\nidentiche...", spanish="Hum...[K] A simple vista\nparecen iguales..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I think it's fine.[K] Pick whichever\none you like. [M:H8]", french="Peu importe.[K] Choisissez celle\nque vous préférez. [M:H8]", german="Ich glaube, das geht schon.[K]\nWähle einfach einen von beiden. [M:H8]", italian="Penso che non cambi nulla.[K]\nScegliamone una qualsiasi. [M:H8]", spanish="A mí no me preocupa.[K] Elegid\nla que queráis. [M:H8]"})
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, hero, 4) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Yeah.[K] No sense in\nworrying about it.", french="Bien dit.[K] Inutile de se tracasser\navec ça.", german="Genau.[K] Es ergibt keinen Sinn,\nsich darüber Sorgen zu machen.", italian="Sì.[K] È inutile preoccuparsene\ntroppo.", spanish="Sí.[K] No tiene sentido\ndarle muchas vueltas."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="For now, go ahead and pick an\nentrance and we'll find out if it's the right one.", french="Nous finirons bien par découvrir\nsi c'était la bonne entrée.", german="Lasst uns jetzt einfach einen der\nbeiden Eingänge auswählen. Wir werden schon\nmerken, ob es der richtige ist.", italian="Ora come ora ci conviene\nscegliere una delle due entrate e scoprire\nse è quella giusta.", spanish="De momento vamos a elegir\nuna entrada y ya veremos si es la buena."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
