-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D55P41A/n06a1801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D55P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- supervision_Acting(3) [neutre/état moteur]
  -- supervision_Acting(4) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(14) [anim idle native]
  -- bgm2_PlayFadeIn(BGM_HEAVY_WIND5) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  local npc_npc_bosugodora = SkySceneKit.spawn_npc("aggron", 256, 192, Direction.Down, "NPC_BOSUGODORA")
  pcall(function() UI:SetSpeaker(npc_npc_bosugodora) end)
  SkySceneKit.say({english="GRR...[K] GRAA-HAHAHAHA...[K]\nGRAA-HAHAHAHA-HAHAHAHA.", french="GRR...[K] GRAA HA HA HA HA...[K]\nGRAA HA HA HA HA.", german="GRR...[K] GRAA-HAHAHAHA...[K]\nGRAA-HAHAHAHA-HAHAHAHA.", italian="GRR...[K] GRAAA-AHAHAHAHAH...[K]\nGRAAA-AHAHAHAH-AHAHAHAH.", spanish="Grrr...[K] Graaaaaaaaaaaaah...[K]\n¡Graaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaah!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_kodora = SkySceneKit.spawn_npc("lairon", 272, 280, Direction.Up, "NPC_KODORA")
  pcall(function() UI:SetSpeaker(npc_npc_kodora) end)
  SkySceneKit.say({english=" Grooooooaaaaaahh...", french=" Grooooooaaaaaahh...", german=" Grooooooaaaaaah...", italian=" Grooooooaaaaaahhh...", spanish=" Grooooooaaaaaah..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bosugodora, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bosugodora) end)
  SkySceneKit.say({english=" Eeeeek...[K] R-run...[K] R-run...", french=" Hiiiii...[K] Courez...[K] Tous aux abris!", german=" Ieeeek...[K] R-rennt...[K] R-rennt...", italian=" Iiiiiih...[K] V-Via...[K] D-Di corsa...", spanish=" Aaaah...[K] Co... corred...[K] Corred..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora, "sweating", 1) end)
  GAME:WaitFrames(4)
  local npc_npc_kodora5 = SkySceneKit.spawn_npc("lairon", 200, 272, Direction.UpRight, "NPC_KODORA5")
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora5, "sweating", 1) end)
  GAME:WaitFrames(3)
  local npc_npc_kodora3 = SkySceneKit.spawn_npc("lairon", 328, 256, Direction.UpLeft, "NPC_KODORA3")
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora3, "sweating", 1) end)
  GAME:WaitFrames(4)
  local npc_npc_kodora4 = SkySceneKit.spawn_npc("lairon", 232, 280, Direction.Up, "NPC_KODORA4")
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora4, "sweating", 1) end)
  GAME:WaitFrames(3)
  local npc_npc_kodora2 = SkySceneKit.spawn_npc("lairon", 304, 272, Direction.UpLeft, "NPC_KODORA2")
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora2, "sweating", 1) end)
  GAME:WaitFrames(4)
  local npc_npc_kodora6 = SkySceneKit.spawn_npc("lairon", 176, 256, Direction.UpRight, "NPC_KODORA6")
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora6, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kodora) end)
  SkySceneKit.say({english=" RUUUUUUUNNNNN!", french=" REPLIEZ-VOUUUUUUS!", german=" RENNNNNT!!!", italian=" SCAPPIAAAAAAMOOO!", spanish=" ¡Correeeeed!"})
  -- message_Close
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_bosugodora.Position; GROUND:MoveToPosition(npc_npc_bosugodora, p.X+(0), p.Y+(-12), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(10250) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(20)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('1', '1', '0', '1', '0')
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- camera_SetEffect(0): arrêt d'effet caméra
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 288, 248, Direction.Up, "NPC_SAANAITO")
  GROUND:EntTurn(npc_npc_saanaito, Direction.DownLeft)
  GAME:WaitFrames(3)
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 224, 248, Direction.Up, "NPC_CHAAREMU")
  GROUND:EntTurn(npc_npc_chaaremu, Direction.DownRight)
  GAME:WaitFrames(3)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(3)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(3)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: se_Play(7430) — id SE NDS sans portage PMDO identifié
  GROUND:MoveToPosition(npc_npc_kodora3, 340, 212, false, 2)
  GROUND:MoveToPosition(npc_npc_kodora6, 164, 212, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_kodora3, 364, 192, false, 2)
  GROUND:MoveToPosition(npc_npc_kodora6, 140, 192, false, 2)
  GROUND:MoveToPosition(npc_npc_kodora2, 340, 212, false, 2)
  GROUND:MoveToPosition(npc_npc_kodora5, 164, 212, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_RemoveActing(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_kodora2, 364, 192, false, 2)
  GROUND:MoveToPosition(npc_npc_kodora5, 140, 192, false, 2)
  GROUND:MoveToPosition(npc_npc_kodora, 304, 268, false, 2)
  GROUND:MoveToPosition(npc_npc_kodora4, 200, 268, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(35)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Hee![K] They panicked and\nran off...", french="Hi hi![K] On leur a flanqué\nune sacrée frousse...", german="Super![K] Sie haben vor Panik\nReißaus genommen.", italian="Ih![K] Si sono spaventati e sono\nscappati via...", spanish=" ¡Ji, ji![K] Han salido despavoridos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_chaaremu, 220, 228, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="We're Team [CS:X]Charm[CR], don't\nunderestimate us!", french="Ne sous-estimez jamais l'Equipe\n[CS:X]Charme[CR]!", german="Wir sind Team [CS:X]Charme[CR],\nunterschätzt uns nicht!", italian="Noi siamo il Team [CS:X]Malia[CR]!\nNessuno deve permettersi di sottovalutarci!", spanish="¡Somos el [CS:X]Equipo Carisma[CR]!\n¡Que nadie nos subestime!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.DownRight)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_saanaito, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Well, at least we won't be\nheld back anymore.", french="Bon, au moins, on ne risque\nplus d'être interrompues.", german="Na, immerhin werden wir jetzt\nerst mal nicht mehr aufgehalten.", italian="Beh, almeno non subiremo\npiù rallentamenti.", spanish="Bueno, al menos ya no nos\nretrasarán más."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Let's keep moving.", french=" Poursuivons.", german=" Lasst uns weitergehen.", italian=" Andiamo avanti.", spanish=" Sigamos avanzando."})
  -- message_Close
  pcall(function() GAME:MoveCamera(252, 136, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 252, 108, false, 2)
  GAME:WaitFrames(9)
  GROUND:MoveToPosition(npc_npc_chaaremu, 220, 124, false, 2)
  GAME:WaitFrames(6)
  GROUND:MoveToPosition(npc_npc_saanaito, 284, 124, false, 2)
  GAME:WaitFrames(15)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
end
