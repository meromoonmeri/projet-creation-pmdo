-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D26P43A/m23a0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(37, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D26P43A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  GAME:WaitFrames(30)
  local npc_npc_kabutopusu = SkySceneKit.spawn_npc("kabutops", 280, 296, Direction.Down, "NPC_KABUTOPUSU")
  pcall(function() UI:SetSpeaker(npc_npc_kabutopusu) end)
  SkySceneKit.say({english=" You again!", french=" Encore vous!", german=" Ihr schon wieder!", italian=" Ancora voi!", spanish=" ¡Habéis vuelto!"})
  pcall(function() UI:SetSpeaker(npc_npc_kabutopusu) end)
  SkySceneKit.say({english="You can come back all you want!\nNothing will ever change!", french="Revenez tant que vous voudrez!\nÇa ne changera rien!", german="Ihr könnt nicht ewig\nzurückkommen! Es wird sich nichts ändern!", italian="Potete tornare tutte le volte che\nvolete! Non cambierà mai nulla!", spanish="¡Podéis volver cuantas veces\nqueráis! ¡El resultado seguirá siendo\nel mismo!"})
  pcall(function() UI:SetSpeaker(npc_npc_kabutopusu) end)
  SkySceneKit.say({english="Every time you come here...[K]\nWe will always crush you!", french="Chaque fois que vous\nreviendrez...[K] On vous écrasera, encore et\nencore!", german="Jedes Mal, wenn ihr\nwiederkommt,[K] werden wir euch zerquetschen!", italian="Ogni volta che verrete qui...[K]\nvi annienteremo!", spanish="Una y otra vez...[K]\n¡Volveremos a aplastaros!"})
  pcall(function() UI:SetSpeaker(npc_npc_kabutopusu) end)
  SkySceneKit.say({english=" Take THIS!", french=" Prenez ÇA!", german=" Nehmt DAS!", italian=" Prendete QUESTO!", spanish=" ¡Tomad esto!"})
  -- SetAnimation(12) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
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
  -- main_EnterDungeon(37, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
