-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D53P11A/n09a1401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Argh...[K] We didn't do so well...", french=" Argh...[K] Un échec retentissant...", german="Argh...[K]\nWir waren wohl nicht gut genug...", italian=" Argh...[K] Ci è andata male...", spanish=" Ay...[K] No ha ido nada bien..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" We should turn back for now.", french="Nous devrions faire demi-tour\npour l'instant.", german="Wir sollten besser\nnoch einmal umkehren.", italian=" Meglio tornare sui nostri passi.", spanish=" Ahora tenemos que dar la vuelta."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D53P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru_n9 = SkySceneKit.spawn_npc("dusknoir", 288, 200, Direction.Right, "NPC_YONOWAARU_N9")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_serebii = SkySceneKit.spawn_npc("celebi", 304, 168, Direction.Right, "NPC_SEREBII")
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
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="If we don't hurry and chase\nafter Master [CS:N]Dialga[CR]...", french="Pressons! Si nous ne rattrapons\npas Maître [CS:N]Dialga[CR] à temps...", german="Wenn wir uns nicht beeilen und\nMeister [CS:N]Dialga[CR] verfolgen...", italian="Se non lo raggiungiamo\nin fretta, il Maestro [CS:N]Dialga[CR]...", spanish="Si no conseguimos alcanzar\nrápidamente a [CS:N]Dialga[CR]..."})
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_serebii, Direction.DownLeft)
  -- message_KeyWait
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" He will reach the pinnacle...", french=" ... il atteindra le pinacle...", german="Dann wird er die\nSpitze erreichen...", italian=" ... arriverà in cima...", spanish=" Alcanzará la cúspide..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="And he will destroy the\nPassage of Time.", french="... et détruira le Couloir\ndu Temps.", german="Dort angekommen wird er den\nZeittunnel zerstören.", italian="... e distruggerà il Portale del\nTempo.", spanish="Y allí destruirá el\nPasaje del Tiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Right.[K] Once you're prepared,\nwe'll head out.", french="Tu as raison.[K] Nous partirons\ndès que nous aurons fini nos préparatifs.", german="Gut.[K] Wir gehen weiter,\nsobald ihr fertig seid.", italian="Giusto.[K] Prepariamoci\ne ripartiamo.", spanish="Eso me temo.[K] En cuanto estés\nlisto, partiremos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_serebii, Direction.Right)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.cleanup_npcs()
end
