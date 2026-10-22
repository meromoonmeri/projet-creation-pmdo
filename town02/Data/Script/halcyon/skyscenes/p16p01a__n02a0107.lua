-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P16P01A/n02a0107.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_NPC_UPAA
    local npc_npc_upaa = SkySceneKit.spawn_npc("wooper", 224, 136, Direction.DownRight, "NPC_UPAA")
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(5) -- Lock(5) NDS
    pcall(function() GROUND:CharSetEmote(npc_npc_upaa, "happy", 1) end)
    -- SetAnimation(4) [anim idle native]
    GAME:WaitFrames(148)
    -- SetAnimation(2) [anim idle native]
    pcall(function() GROUND:CharSetEmote(npc_npc_upaa, nil, 0) end) -- EFFECT_NONE
    GAME:WaitFrames(20)
    pcall(function() GROUND:CharSetEmote(npc_npc_upaa, nil, 0) end) -- EFFECT_NONE
    pcall(function() GROUND:CharSetEmote(npc_npc_upaa, "happy", 1) end)
    -- SetAnimation(5) [anim idle native]
    GAME:WaitFrames(80)
    pcall(function() GROUND:CharSetEmote(npc_npc_upaa, "happy", 1) end)
    GROUND:MoveToPosition(npc_npc_upaa, 4, 136, false, 2)
    -- Destroy() [neutre/état moteur]
  end)
  SkySceneKit.run_routine(function() -- def 2 for actor ACTOR_NPC_MUCHUURU
    local npc_npc_muchuuru = SkySceneKit.spawn_npc("smoochum", 256, 152, Direction.Left, "NPC_MUCHUURU")
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(10) -- Lock(10) NDS
    pcall(function() GROUND:CharSetEmote(npc_npc_muchuuru, "happy", 1) end)
    GAME:WaitFrames(4)
    -- SetAnimation(5) [anim idle native]
    GAME:WaitFrames(144)
    -- SetAnimation(2) [anim idle native]
    pcall(function() GROUND:CharSetEmote(npc_npc_muchuuru, nil, 0) end) -- EFFECT_NONE
    GAME:WaitFrames(80)
    -- CallCommon CORO_JUMP_HAPPY_FUNC (fermeture/attente message: géré par say())
    GROUND:EntTurn(npc_npc_muchuuru, Direction.Right)
    GAME:WaitFrames(150)
    GROUND:EntTurn(npc_npc_muchuuru, Direction.Left)
    GAME:WaitFrames(15)
    -- CallCommon CORO_JUMP_ANGRY_FUNC (fermeture/attente message: géré par say())
    GAME:WaitFrames(15)
    GROUND:MoveToPosition(npc_npc_muchuuru, 0, 152, false, 2)
    -- Destroy() [neutre/état moteur]
  end)
  SkySceneKit.run_routine(function() -- def 3 for actor ACTOR_NPC_SUBOMII
    local npc_npc_subomii = SkySceneKit.spawn_npc("budew", 224, 168, Direction.UpRight, "NPC_SUBOMII")
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(15) -- Lock(15) NDS
    pcall(function() GROUND:CharSetEmote(npc_npc_subomii, "happy", 1) end)
    GAME:WaitFrames(8)
    -- SetAnimation(4) [anim idle native]
    GAME:WaitFrames(140)
    -- SetAnimation(2) [anim idle native]
    pcall(function() GROUND:CharSetEmote(npc_npc_subomii, nil, 0) end) -- EFFECT_NONE
    GAME:WaitFrames(40)
    pcall(function() GROUND:CharSetEmote(npc_npc_subomii, nil, 0) end) -- EFFECT_NONE
    pcall(function() GROUND:CharSetEmote(npc_npc_subomii, "happy", 1) end)
    -- SetAnimation(5) [anim idle native]
    GAME:WaitFrames(80)
    GROUND:MoveToPosition(npc_npc_subomii, 4, 168, false, 2)
    -- Destroy() [neutre/état moteur]
  end)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Way back when...", french="[CN]Ça remonte à l'époque...", german="[CN]Damals...", italian="[CN]Si tratta di tanto tempo fa...", spanish="[CN]Hace mucho, cuando..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Yep... That was back\n[CN]when I was still a small child...", french="[CN]... et oui... à l'époque de ma prime enfance...", german="[CN]Ja... Damals war ich noch\n[CN]sehr klein...", italian="[CN]Eh sì... quando ero ancora piccolo...", spanish="[CN]Era aún un pequeñajo..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]I wasn't [CS:N]Wigglytuff[CR] yet...\n[CN]This was back when I was still an [CS:Y]Igglybuff[CR].", french="[CN]Je n'étais pas encore [CS:N]Grodoudou[CR]...\n[CN]A cet époque, j'étais encore un [CS:Y]Toudoudou[CR].", german="[CN]Ich war noch kein [CS:N]Knuddeluff[CR]...\n[CN]Damals war ich noch ein [CS:Y]Fluffeluff[CR].", italian="[CN]Non ero ancora diventato [CS:N]Wigglytuff[CR]...\n[CN]Risale tutto ai tempi in cui ero [CS:Y]Igglybuff[CR].", spanish="[CN]Todavía no era [CS:N]Wigglytuff[CR]...\n[CN]Estoy hablando de cuando aún era un [CS:Y]Igglybuff[CR]."})
  -- message_Close
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_P16P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(112, 164, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(10) -- Unlock(10) NDS
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(15) -- Unlock(15) NDS
  pcall(function() SOUND:PlayBGM("Heartwarming.ogg", true) end)
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  -- message_SetWaitMode(190, 80) [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]There everyone lived an easy life...", french="[CN]On avait la belle vie...", german="[CN]Wir lebten alle ein einfaches Leben...", italian="[CN]Allora vivevo in maniera semplice\n[CN]e spensierata...", spanish="[CN]La vida entonces era sencilla..."})
  -- message_KeyWait
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]It was a very peaceful prairie...", french="[CN]Il y avait une paisible prairie...", german="[CN]In einer friedlichen Ebene...", italian="[CN]... in una magnifica prateria.", spanish="[CN]Vivía en una pradera muy tranquila..."})
  -- message_Close
  GAME:FadeOut(false, 30)
  -- message_SetWaitMode(-1, -1) [neutre/état moteur]
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
  SkySceneKit.join_routines()
end
