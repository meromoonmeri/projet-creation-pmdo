-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/n01a0504.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_NPC_GUREGGURU
    local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 232, 224, Direction.Down, "NPC_GUREGGURU")
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(5) -- Lock(5) NDS
    GROUND:EntTurn(npc_npc_guregguru, Direction.DownLeft)
    SkySceneKit.lock(6) -- Lock(6) NDS
    -- @label_0 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    -- SetAnimation(17) [anim idle native]
    GAME:WaitFrames(2) -- join WaitAnimation
    -- SetAnimation(2) [anim idle native]
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
  end)
  SkySceneKit.run_routine(function() -- def 2 for actor ACTOR_NPC_DOGOOMU
    local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 240, 288, Direction.Right, "NPC_DOGOOMU")
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(7) -- Lock(7) NDS
    pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "exclaim", 1) end)
    GROUND:EntTurn(npc_npc_dogoomu, Direction.Left)
    SkySceneKit.lock(8) -- Lock(8) NDS
    pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
    -- @label_1 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    -- SetAnimation(19) [anim idle native]
    GAME:WaitFrames(2) -- join WaitAnimation
    -- SetAnimation(2) [anim idle native]
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
  end)
  SkySceneKit.run_routine(function() -- def 3 for actor ACTOR_PLAYER_BIPPA
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(9) -- Lock(9) NDS
    pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
    GROUND:EntTurn(hero, Direction.Left)
    SkySceneKit.lock(10) -- Lock(10) NDS
    -- @label_2 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    -- SetAnimation(3) [anim idle native]
    -- MoveHeight(2, 10) [élévation d'objet NDS non simulée - documenté]
    GAME:WaitFrames(1)
    -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
    GAME:WaitFrames(2)
    -- MoveHeight(2, 10) [élévation d'objet NDS non simulée - documenté]
    GAME:WaitFrames(1)
    -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
    GAME:WaitFrames(15)
    -- SetAnimation(2) [anim idle native]
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
  end)
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(5123) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 40, 288, Direction.Right, "NPC_CHIRIIN")
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Everyone![K] Thanks for\nwaiting! ♪", french="Ah, vous voilà tous![K] Merci\nde votre patience! ♪", german="Alle mal herhören![K]\nVielen Dank für eure Geduld! ♪", italian="Ehi, gente![K] Grazie di aver\naspettato! ♪", spanish="¡Hola a todos![K] ¡Gracias por\nesperar! ♪"})
  -- message_Close
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  GAME:WaitFrames(2) -- join WaitLockLives
  GAME:FadeIn(30)
  GROUND:MoveToPosition(npc_npc_chiriin, 176, 284, false, 2)
  GAME:WaitFrames(40)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 272, 288, Direction.Left, "NPC_DIGUDA")
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(10)
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(5)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 232, 256, Direction.Up, "NPC_HEIGANI")
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  GAME:WaitFrames(10)
  SkySceneKit.unlock(9) -- Unlock(9) NDS
  GAME:WaitFrames(10)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 288, 232, Direction.DownRight, "NPC_PERAPPU")
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 160, 232, Direction.UpLeft, "NPC_KIMAWARI")
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GROUND:EntTurn(npc_npc_kimawari, Direction.Down)
  GROUND:EntTurn(npc_npc_heigani, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" I finished making dinner! ♪", french="J'ai fini de préparer le\ndîner! ♪", german="Ich bin mit den\nEssensvorbereitungen fertig! ♪", italian=" Tutto pronto in cucina! ♪", spanish=" ¡La cena está lista! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Come on! Dinner's on! ♪", french="C'est bon! Le repas est\nservi! ♪", german=" Alle herkommen! Essenszeit! ♪", italian=" Forza! La cena è pronta! ♪", spanish=" ¡Venga! ¡A cenar! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5138) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  SkySceneKit.unlock(6) -- Unlock(6) NDS
  SkySceneKit.unlock(8) -- Unlock(8) NDS
  SkySceneKit.unlock(10) -- Unlock(10) NDS
  -- supervision_Acting(1) [neutre/état moteur]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 144, 280, Direction.Down, "NPC_DAGUTORIO")
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  do local p=npc_npc_dagutorio.Position; GROUND:MoveToPosition(npc_npc_dagutorio, p.X+(-88), p.Y+(0), false, 2) end
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: YEAH!", french="[CS:N]Tous[CR]: A L'ATTAQUE!", german="[CS:N]Alle[CR]: JUCHHU!", italian="[CS:N]Tutti[CR]: SÌ!", spanish="[CS:N]Todos[CR]: ¡SÍ!"})
  -- message_Close
  -- se_FadeOut(5138, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
