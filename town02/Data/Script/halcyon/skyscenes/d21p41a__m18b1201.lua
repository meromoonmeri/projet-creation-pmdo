-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D21P41A/m18b1201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(31, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D21P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 384, 176, Direction.Down, "NPC_JUPUTORU")
  -- SetAnimation(29) [anim idle native]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  -- GAP: BGM BGM_PLANETS_PARALYSIS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_mikaruge = SkySceneKit.spawn_npc("spiritomb", 328, 200, Direction.Down, "NPC_MIKARUGE")
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english=" HEE-hee...HEE-hee...! Back again?", french="HEE hee... HEE hee...! Encore\nvous?", german="HEE-hee... HEE-hee... Schon\nwieder da?", italian=" EEH-eeh... EEH-eeh...! Di nuovo?", spanish="¡Ji, ji, ji! ¡Ji, ji, ji!\n¿Otra vez aquí?"})
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english="None shall be forgiven for\nTRESPASSING here!", french="Pas de quartier pour\nles INTRUS!", german="Keinem EINDRINGLING wird\nVERGEBUNG zuteil!", italian="Non possiamo perdonare chi\nSCONFINA nella nostra terra!", spanish="¡No perdonaremos a nadie!\n¡A NADIE!"})
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english="HEE-hee...HEE-hee... PREPARE to\ntake your punishment!", french="HEE hee... HEE hee...\nPREPAREZ-VOUS à subir votre châtiment!", german="HEE-hee... HEE-hee... Macht\neuch BEREIT für eure Strafe!", italian="EEH-eeh... EEH-eeh...\nPREPARATEVI a una sonora punizione!", spanish="¡Ji, ji, ji! ¡Ji, ji, ji!\n¡Preparaos para sufrir vuestro castigo!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(30) end)
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
  -- main_EnterDungeon(31, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
