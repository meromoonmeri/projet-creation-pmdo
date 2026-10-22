-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P41A/s31a3601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(122, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D73P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- back_SetWeather(11) [météo visuelle ground NDS - documenté]
  -- supervision_SpecialActing(34, 0, 0) [cadrage NDS]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(-3, -1) [neutre/état moteur]
  local npc_npc_betobetaa = SkySceneKit.spawn_npc("grimer", 224, 216, Direction.DownRight, "NPC_BETOBETAA")
  pcall(function() UI:SetSpeaker(npc_npc_betobetaa) end)
  SkySceneKit.say({english=" Icky, sticky...grimy, slimy...", french="Graicheux, poicheux...\ncracheux, vichqueux...", german=" Kleb, ekel... Schmutzig, schleimig...", italian=" Sguish, sguosh... Smelm, sblosh...", spanish="Asqueroso, pegajoso... pringoso,\nviscoso..."})
  pcall(function() UI:SetSpeaker(npc_npc_betobetaa) end)
  SkySceneKit.say({english=" We looove dirt and slime...", french=" On ch'ébroue dans la bouuue...", german=" Wir liiieben Dreck und Schleim...", italian="Adoriamo il faaaaaango\ne il viscidume...", spanish=" Nos encanta la suciedad y la mugre..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(11013) — id SE NDS sans portage PMDO identifié
  local npc_npc_betobeton3 = SkySceneKit.spawn_npc("muk", 328, 256, Direction.Left, "NPC_BETOBETON3")
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  -- message_FacePositionOffset(-1, -2) [neutre/état moteur]
  local npc_npc_betobeton = SkySceneKit.spawn_npc("muk", 256, 208, Direction.Down, "NPC_BETOBETON")
  pcall(function() UI:SetSpeaker(npc_npc_betobeton) end)
  SkySceneKit.say({english=" We drive away cleanlinessss!", french="On chalit touuuut ch'qui\nest propre!", german=" Weg mit der Sssauberkeit!", italian="Noi siamo i nemici della\npuliziiiiiia!", spanish=" ¡Odiamosssss la limpieza!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(10) end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(122, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
