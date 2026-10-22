-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P01A/m26a0505.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_ATTENDANT1
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(5) -- Lock(5) NDS
    GROUND:EntTurn(partner, Direction.UpLeft)
    -- CallCommon CORO_JUMP_SURPRISE_FUNC (fermeture/attente message: géré par say())
    SkySceneKit.lock(6) -- Lock(6) NDS
    pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
    GROUND:EntTurn(partner, Direction.Up)
    SkySceneKit.lock(7) -- Lock(7) NDS
    -- SetAnimation(5) [anim idle native]
    GROUND:MoveToPosition(partner, 240, 204, false, 2) -- SlidePositionMark (glissement)
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(8) -- Lock(8) NDS
    GAME:WaitFrames(10)
    GROUND:EntTurn(partner, Direction.Right)
    GAME:WaitFrames(45)
    GROUND:EntTurn(partner, Direction.UpLeft)
    GAME:WaitFrames(30)
    GROUND:EntTurn(partner, Direction.UpRight)
    GAME:WaitFrames(45)
    GROUND:EntTurn(partner, Direction.Left)
    GAME:WaitFrames(45)
    GROUND:EntTurn(partner, Direction.Up)
    SkySceneKit.lock(9) -- Lock(9) NDS
    GAME:WaitFrames(1) -- hold
  end)
  -- GAP: BGM BGM_A_WISH_FOR_PEACE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_G01P01A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(11) [neutre/état moteur]
  -- SetAnimation(9) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitLockLives
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- supervision_Acting(1) [neutre/état moteur]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 200, 168, Direction.Down, "NPC_DIGUDA")
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(15)
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(2) -- join WaitLockLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_diguda, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  GAME:WaitFrames(20)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_G01P01A3_95) [routine d'objet NDS non simulée - documenté]
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(5)
  SkySceneKit.unlock(6) -- Unlock(6) NDS
  GAME:WaitFrames(2) -- join WaitLockLives
  GAME:WaitFrames(15)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 240, 152, Direction.Down, "NPC_DOGOOMU")
  GROUND:MoveToPosition(npc_npc_dogoomu, 240, 188, false, 2)
  GAME:WaitFrames(15)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(2) -- join WaitLockLives
  -- supervision_Acting(3) [neutre/état moteur]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 240, 152, Direction.Down, "NPC_BIPPA")
  -- ResetHitAttribute(31) [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_bippa, 240, 172, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 264, 204, false, 2)
  -- supervision_Acting(4) [neutre/état moteur]
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 240, 152, Direction.Down, "NPC_CHIRIIN")
  GROUND:MoveToPosition(npc_npc_chiriin, 240, 172, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 216, 204, false, 2)
  GROUND:EntTurn(npc_npc_bippa, Direction.Left)
  SkySceneKit.unlock(8) -- Unlock(8) NDS
  -- supervision_Acting(5) [neutre/état moteur]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 240, 152, Direction.Down, "NPC_HEIGANI")
  GROUND:MoveToPosition(npc_npc_heigani, 240, 172, false, 2)
  GROUND:MoveToPosition(npc_npc_heigani, 264, 188, false, 2)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Right)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  -- supervision_Acting(6) [neutre/état moteur]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 240, 152, Direction.Down, "NPC_GUREGGURU")
  GROUND:MoveToPosition(npc_npc_guregguru, 240, 172, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 216, 188, false, 2)
  GROUND:EntTurn(npc_npc_heigani, Direction.DownLeft)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
  GROUND:EntTurn(npc_npc_guregguru, Direction.DownRight)
  -- supervision_Acting(7) [neutre/état moteur]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 280, 168, Direction.Down, "NPC_DAGUTORIO")
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_dagutorio, Direction.DownLeft)
  -- SetAnimation(4) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  -- supervision_Acting(8) [neutre/état moteur]
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 240, 152, Direction.Down, "NPC_KIMAWARI")
  -- ResetHitAttribute(31) [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_kimawari, 256, 172, false, 2)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Down)
  GAME:WaitFrames(60)
  -- supervision_Acting(9) [neutre/état moteur]
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 240, 152, Direction.Down, "NPC_PERAPPU")
  -- ResetHitAttribute(31) [neutre/état moteur]
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  GAME:WaitFrames(60)
  GROUND:MoveToPosition(npc_npc_kimawari, 288, 188, false, 2)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Left)
  GROUND:MoveToPosition(npc_npc_guregguru, 192, 188, false, 2)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Right)
  GROUND:MoveToPosition(npc_npc_dogoomu, 216, 188, false, 2)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Right)
  GROUND:MoveToPosition(npc_npc_perappu, 264, 172, false, 1)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GAME:WaitFrames(60)
  -- supervision_Acting(10) [neutre/état moteur]
  GAME:WaitFrames(45)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 240, 152, Direction.Down, "NPC_PUKURIN")
  GROUND:MoveToPosition(npc_npc_pukurin, 240, 188, false, 1)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_diguda, Direction.DownRight)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownRight)
  GROUND:EntTurn(npc_npc_heigani, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_guregguru, Direction.DownRight)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Right)
  GROUND:EntTurn(npc_npc_bippa, Direction.Left)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Upon returning to the guild...", french="[CN]A son retour à la Guilde...", german="[CN]Nach der Rückkehr zur Gilde", italian="[CN]Tornando alla Gilda...", spanish="[CN]A su regreso al [CS:N]Pokégremio[CR]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][partner] told everyone\n[CN]about the adventure...", french="[CN]... [partner] raconta\n[CN]à tout le monde...", german="[CN]erzählt [partner] allen\n[CN]von diesem großen Abenteuer.", italian="[CN]... [partner] racconta\n[CN]a tutti la sua avventura...", spanish="[CN][partner] les contó a todos\n[CN]su aventura."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]about what happened\n[CN]in the [CS:P]Hidden Land[CR]...", french="[CN]... leurs aventures dans\n[CN]les [CS:P]Terres Illusoires[CR]...", german="[CN]Von all dem, was im\n[CN][CS:P]Verborgenen Land[CR] geschah.", italian="[CN]Racconta tutto ciò che è accaduto alla\n[CN][CS:P]Terra Nascosta[CR]...", spanish="[CN]Les relató lo ocurrido\n[CN]en la [CS:P]Tierra Oculta[CR]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]about what took place in\n[CN][CS:P]Temporal Tower[CR]...", french="[CN]... ainsi que les événements de\n[CN]la [CS:P]Tour du Temps[CR]...", german="[CN]Von den Geschehnissen, die sich im\n[CN][CS:P]Zeitturm[CR] abspielten.", italian="[CN]... gli avvenimenti alla [CS:P]Torre del Tempo[CR]...", spanish="[CN]Lo que tuvo lugar\n[CN]en la [CS:P]Torre del Tiempo[CR]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]about [CS:N]Grovyle[CR]...\n[CN]and about [hero].", french="[CN]... et expliqua ce qu'il était advenu\n[CN]de [CS:N]Massko[CR] et de [hero]...", german="[CN]Von [CS:N]Reptain[CR]\n[CN]und von [hero].", italian="[CN]E racconta di [CS:N]Grovyle[CR]...\n[CN]e di [hero].", spanish="[CN]Lo que sucedió con [CS:N]Grovyle[CR]...\n[CN]y con [hero]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Of course, [partner] also spoke of how\n[CN]the destruction of time was stopped...", french="[CN]Bien sûr, [partner] décrivit aussi comment\n[CN]la destruction du temps avait été évitée...", german="[CN]Natürlich erzählt [partner] auch, wie die\n[CN]Zerstörung der Zeit aufgehalten wurde.", italian="[CN]Naturalmente, [partner] spiega anche come\n[CN]hanno fermato la paralisi del tempo...", spanish="[CN]Por supuesto, [partner] también habló de\n[CN]cómo se detuvo la destrucción del tiempo..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]and how the world was\n[CN]restored to peace.", french="[CN]... et comment la paix\n[CN]était revenue dans le monde.", german="[CN]Und wie der Welt der Frieden\n[CN]zurückgebracht wurde.", italian="[CN]... e come hanno riportato\n[CN]il mondo alla pace.", spanish="[CN]Y de cómo se devolvió\n[CN]la paz al mundo."})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
