-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D54P11A/n06a3902.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_ILLUSION_STONE_CHAMBER non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_D54P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 224, 368, Direction.Up, "NPC_CHAAREMU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 288, 368, Direction.Up, "NPC_SAANAITO")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_metamon_kireihana = SkySceneKit.spawn_npc("bellossom", 256, 120, Direction.Down, "NPC_METAMON_KIREIHANA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:TeleportTo(hero, 252, 228, Direction.Down)
  GROUND:TeleportTo(npc_npc_saanaito, 284, 244, Direction.Down)
  GROUND:TeleportTo(npc_npc_chaaremu, 220, 244, Direction.Down)
  GROUND:EntTurn(hero, Direction.DownRight)
  GROUND:EntTurn(npc_npc_saanaito, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Right)
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "happy", 1) end)
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="All right, let's do our best and\nget through this jungle! ♪", french="Faisons de notre mieux pour\ntraverser cette jungle au plus vite! ♪", german="Na gut. Lasst uns unser Bestes\ngeben und diesen Dschungel durchqueren! ♪", italian="Ok, mettiamocela tutta\ne usciamo da questa giungla! ♪", spanish="Bueno, vamos a darlo todo, hay\nque atravesar esta selva. ♪"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "happy", 1) end)
  GAME:WaitFrames(90)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, nil, 0) end) -- EFFECT_NONE
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" U-um...", french=" Hum hum...", german=" Ä-ähem...", italian=" U-Uhm...", spanish=" E... ejem..."})
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "exclaim", 1) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "exclaim", 1) end)
  GAME:WaitFrames(4)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Up)
  GAME:WaitFrames(6)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  GROUND:MoveToPosition(npc_npc_metamon_kireihana, 252, 196, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Wh-who are you?", french=" Qui es-tu?", german=" W-wer bist du?", italian=" C-Chi sei tu?", spanish=" ¿Qui... quién eres?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_metamon_kireihana) end)
  SkySceneKit.say({english="I'm [CS:N]Bellossom[CR].[K]\nI live in this jungle.", french="Je m'appelle [CS:N]Joliflor[CR].[K]\nJe vis dans cette jungle.", german="Ich bin [CS:N]Blubella[CR].[K]\nIch lebe in diesem Dschungel.", italian="Mi chiamo [CS:N]Bellossom[CR].[K]\nVivo in questa giungla.", spanish="Soy [CS:N]Bellossom[CR].[K]\nVivo en esta selva."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_kireihana) end)
  SkySceneKit.say({english="If you're talking about the\ntreasure in [CS:P]Boulder Quarry[CR]...", french="Si vous parlez du trésor de la\n[CS:P]Carrière Rocher[CR]...", german="Falls ihr gerade über den\nSchatz im [CS:P]Geröllbruch[CR] gesprochen habt...", italian="Se state parlando del tesoro\ndella [CS:P]Cava Rocciosa[CR]...", spanish="Si estáis hablando del tesoro\ndel [CS:P]Roquedal[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_kireihana) end)
  SkySceneKit.say({english=" You really should give up.", french="... vous feriez mieux\nd'abandonner.", german=" Gebt besser auf.", italian="... fareste meglio a lasciar\nperdere.", spanish=" Será mejor que lo olvidéis."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_metamon_kireihana) end)
  SkySceneKit.say({english="[CN]Was it back then...", french="[CN]Ainsi donc...", german="[CN]Damals...", italian="[CN]È stato allora...", spanish="[CN]Fue entonces..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_kireihana) end)
  SkySceneKit.say({english="[CN]When we were warned earlier in\n[CN][CS:P]Southern Jungle[CR]...", french="[CN]... ce Pokémon qui a tenté de nous dissuader\n[CN]dans la [CS:P]Jungle Méridionale[CR]...", german="[CN]Als wir gewarnt wurden, im\n[CN][CS:P]Süddschungel[CR]...", italian="[CN]Quando abbiamo ricevuto quell'avvertimento\n[CN]nella [CS:P]Giungla Meridionale[CR]...", spanish="[CN]Cuando nos avisaron en la\n[CN][CS:P]Selva Meridional[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_kireihana) end)
  SkySceneKit.say({english="[CN]That [CS:N]Bellossom[CR] and...", french="[CN]Ce [CS:N]Joliflor[CR] et...", german="[CN]War es damals? Jene [CS:N]Blubella[CR] und...", italian="[CN]Quel [CS:N]Bellossom[CR] e...", spanish="[CN]Ese [CS:N]Bellossom[CR] y..."})
  -- message_Close
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
