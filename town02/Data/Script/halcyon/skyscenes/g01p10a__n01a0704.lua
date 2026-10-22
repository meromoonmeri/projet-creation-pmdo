-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P10A/n01a0704.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The next morning...", french="[CN]Le lendemain matin...", german="[CN]Am nächsten Morgen...", italian="[CN]Il giorno dopo...", spanish="[CN]A la mañana siguiente..."})
  -- message_Close
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 216, 168, Direction.Down, "NPC_DOGOOMU")
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="HEY!![K]\nHEEEEEEEEEYYYYYYYYYYY!!", french="OH!![K]\nOHEEEEEEEEEEEEEEE!!", german="HEY!!![K]\nHEEEEEEEEEYYYYYYYYYYY!!!", italian="EHI!![K]\nEEEEEEHIIIIIIIII!!!", spanish="¡¡Oye!![K]\n¡¡Eeeh!!"})
  -- message_KeyWait
  -- GAP: se_Play(8970) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="GET UUUUUUUUUUUUUUPPPPPP![K]\nIT'S MORRRRRRRNNNIIIIIIIIIINNNNNNGGGG!", french="DEBOUUUUUUUUUT LA-DEDANS![K]\nC'EST L'HEUUUUUUUUUUUUURE!", german="AUUUFSTEEEHEN![K]\nES IST MMMMOOOORRRRGGGGEEEENNNN!", italian="SVEEEEEEEEEGLIAAAAAA![K]\nÈ MAAATTIIIIIINAAAAAAAAAAAA!", spanish="¡ARRIBA![K]\n¡QUE YA ES DE DÍA!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_Close
  -- back_SetGround(LEVEL_G01P10A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(27) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" H-huh...?[K] What's that...?", french=" Hein quoi...?[K] Qu'est-ce qui...?", german=" Wie...[K] Was soll das?", italian=" Uh...?[K] Che succede...?", spanish=" ¿Eh?[K] ¿Qué pasa? ¡¿Un terremoto?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" How LATE will you SLEEP!", french="Tu comptes DORMIR jusqu'à\nQUAND comme ÇA?", german=" Wie LANGE du SCHLÄFST!!!", italian=" Fino a QUANDO vuoi DORMIRE?!", spanish=" ¡Eres un dormilón!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="The MORNING address is\nSTARTING![K] HURRY UP!", french="Les ENCOURAGEMENTS matinaux\nONT commencé![K] BOUGE-TOI UN PEU!", german="Die MORGENANSPRACHE beginnt![K]\nBEEIL DICH!", italian="Sta per COMINCIARE il discorso\nMATTUTINO![K] SBRIGATI!", spanish="¡Está empezando el discurso\nmatinal![K] ¡Deprisa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_dogoomu, 216, 124, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Oogh...[K] Whose fault do you think\nit is I can't get up in the first place...?", french="Ouuh...[K] Tu crois qu'c'est la faute\nà qui si j'ai du mal à m'lever...?", german="Uuff...[K] Wessen Schuld\nist es wohl, dass ich so müde bin?", italian="Oooh...[K] E di chi credi che sia la\ncolpa se non sono riuscito a svegliarmi\nsubito...?", spanish="Uuf...[K] ¿De quién crees que es\nla culpa de que no pueda levantarme?..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Left)
  -- SetAnimation(28) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Sniff...[K] His snoring made it\nreally hard for me to sleep, yup yup...", french="Snif...[K] Avec tous ses\nronflements, j'ai pas pu fermer\nl'œil d'la nuit, pardi!", german="Schnief...[K] Sein Geschnarche\nhat mich vom Schlafen abgehalten, jawollja...", italian="Sniff...[K] Il suo russare non\nmi ha fatto chiudere occhio, già, già...", spanish="Jo...[K] Con esos ronquidos no había\nforma de pegar ojo, no, señor..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But if I don't get up, I'll miss\nthe morning address...", french="Mais si j'me lève pas, j'vais\nrater les encouragements matinaux...", german="Aber wenn ich jetzt nicht\naufstehe, werde ich die Ansprache verpassen.", italian="Ma se non mi alzo, perderò\nil discorso mattutino...", spanish="Pero si no me levanto\nme perderé el discurso matinal..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I-I've got to hurry!", french=" F-faut qu'je m'grouille!", german=" I-ich muss mich beeilen!", italian=" D-Devo sbrigarmi!", spanish=" ¡Te... tengo que darme prisa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[1] = 1 -- $SCENARIO_MAIN_BIT_FLAG[1] = 1 (ROM)
  -- main_SetGround(LEVEL_G01P10A) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[7] = 1 -- $SCENARIO_MAIN_BIT_FLAG[7] = 1 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
