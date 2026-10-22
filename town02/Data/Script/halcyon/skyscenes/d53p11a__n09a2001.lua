-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D53P11A/n09a2001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Argh...[K] We didn't do so well...", french=" Argh...[K] Un échec retentissant...", german="Argh...[K]\nWir waren wohl nicht gut genug...", italian=" Argh...[K] Ci è andata male...", spanish=" Ay...[K] ¡Lo hemos hecho mal!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" We should turn back for now.", french="Nous devrions faire demi-tour\npour l'instant.", german="Wir sollten besser\nnoch einmal umkehren.", italian=" Meglio tornare sui nostri passi.", spanish="No queda otra opción que\nretroceder."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D53P11A) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- supervision_Acting(3) [neutre/état moteur]
  -- supervision_Acting(4) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru_n9 = SkySceneKit.spawn_npc("dusknoir", 288, 200, Direction.UpRight, "NPC_YONOWAARU_N9")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_serebii = SkySceneKit.spawn_npc("celebi", 304, 168, Direction.DownRight, "NPC_SEREBII")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 280, 144, Direction.Down, "NPC_YAMIRAMI")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_yamirami2 = SkySceneKit.spawn_npc("sableye", 256, 168, Direction.DownRight, "NPC_YAMIRAMI2")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_yamirami3 = SkySceneKit.spawn_npc("sableye", 232, 208, Direction.Right, "NPC_YAMIRAMI3")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_yamirami4 = SkySceneKit.spawn_npc("sableye", 264, 240, Direction.UpRight, "NPC_YAMIRAMI4")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_VAST_ICE_MOUNTAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  -- GAP: se_Play(11534) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(10)
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(10)
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(10)
  -- supervision_Acting(4) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(30)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(10)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(10)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(10)
  -- Destroy() [neutre/état moteur]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(0), p.Y+(-4), false, 2) end -- SlidePositionOffset
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "shock", 1) end)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_yamirami2.Position; GROUND:MoveToPosition(npc_npc_yamirami2, p.X+(-4), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami2, "exclaim", 1) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_yamirami3.Position; GROUND:MoveToPosition(npc_npc_yamirami3, p.X+(-4), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami3, "shock", 1) end)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(3)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_yamirami4.Position; GROUND:MoveToPosition(npc_npc_yamirami4, p.X+(0), p.Y+(4), false, 2) end -- SlidePositionOffset
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "exclaim", 1) end)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" There's no time.", french=" Pas une minute à perdre.", german=" Uns bleibt keine Zeit mehr.", italian=" Abbiamo poco tempo.", spanish=" Pero no tenemos tiempo."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Until we disappear, we should do\neverything we can to hold off Master [CS:N]Dialga[CR]...", french="Avant de disparaître, faisons de\nnotre mieux pour retenir Maître [CS:N]Dialga[CR].", german="Bis zu unserem Verschwinden\nsollten wir alles uns Mögliche tun, um\nMeister [CS:N]Dialga[CR] Einhalt zu gebieten!", italian="Prima di sparire, dobbiamo fare\ntutto ciò che è in nostro potere per fermare\nil Maestro [CS:N]Dialga[CR]!", spanish="Hasta que desaparezcamos, hay\nque contener a [CS:N]Dialga[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Got it.[K] Let's hurry up and go.", french=" Entendu.[K] Dépêchons-nous.", german="Verstanden.[K]\nLasst uns schnell weitergehen.", italian=" Ricevuto.[K] Forza, andiamo.", spanish="Entendido.[K] Démonos prisa\ny sigamos adelante."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
