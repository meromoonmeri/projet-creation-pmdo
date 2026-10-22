-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D10P41A/m10a1001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(16, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D10P41A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Steam Cave.ogg", true) end)
  GAME:WaitFrames(30)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  local npc_npc_guraadon = SkySceneKit.spawn_npc("groudon", 328, 96, Direction.Down, "NPC_GURAADON")
  do local p=npc_npc_guraadon.Position; GROUND:MoveToPosition(npc_npc_guraadon, p.X+(0), p.Y+(80), false, 1) end
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(9) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_guraadon) end)
  SkySceneKit.say({english=" GRR...GRR...OOOOOOOOOH!", french=" GRR... GRR... OOOOOOOOOH!", german=" GRR...GRR...OOOOOOOOOH!", italian=" GRR... GRR... OOOOOOOOOH!", spanish=" ¡GRR! ¡GRR! ¡GRRRRRRRRRR!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_guraadon) end)
  SkySceneKit.say({english=" YOU AGAIN!", french=" ENCORE VOUS!", german=" IHR SCHON WIEDER!", italian=" ANCORA VOI!", spanish=" ¿QUÉ HACÉIS AQUÍ OTRA VEZ?"})
  pcall(function() UI:SetSpeaker(npc_npc_guraadon) end)
  SkySceneKit.say({english="NO MATTER HOW MANY TIMES\nYOU TRY...[K]YOU WILL NOT PASS THROUGH TO\n[CS:P]FOGBOUND LAKE[CR]!", french="VOUS AUREZ BEAU ESSAYER\nMILLE FOIS...[K] JAMAIS VOUS N'ATTEINDREZ\nLE [CS:P]LAC DES BRUMES[CR]!", german="WIE OFT IHR ES AUCH\nVERSUCHT...[K] IHR WERDET ES NICHT ZUM\n[CS:P]NEBELSEE[CR] SCHAFFEN!", italian="I VOSTRI PATETICI TENTATIVI\nSONO INUTILI...[K] NON RIUSCIRETE MAI A\nRAGGIUNGERE IL [CS:P]LAGO FOSCHIA[CR]!", spanish="DA IGUAL CUÁNTAS VECES\nLO INTENTÉIS.[K] ¡NUNCA PODRÉIS ALCANZAR\nEL [CS:P]LAGO VELADO[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_guraadon) end)
  SkySceneKit.say({english=" NEVER!", french=" JAMAIS!", german=" NIEMALS!", italian=" MAI!", spanish=" ¡NUNCA!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(15)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '2', '0')
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  -- MoveHeight(2, 5) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(2, 5) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(16, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
