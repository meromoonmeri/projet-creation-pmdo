-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P20P02A/n03a0704.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_A_FUN_EXPLORATION non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_P20P02A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  pcall(function() GAME:MoveCamera(204, 240, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Wow! Treasure! Treasure! ♪", french=" Ouah! Un trésor! Un trésor! ♪", german=" Wow! Schätze! Schätze! ♪", italian=" Wow! Tesoro! Tesoro! ♪", spanish=" ¡Anda! ¡Tesoros, tesoros! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_aamarudo = SkySceneKit.spawn_npc("armaldo", 208, 256, Direction.Up, "NPC_AAMARUDO")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_aamarudo, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Don't be so happy-go-lucky![K]\nThere might be a trap!", french="Ne sois pas si insouciant![K]\nIl pourrait y avoir un piège!", german="Sei nicht so unbedarft![K]\nHier ist möglicherweise eine Falle!", italian="Non cantare vittoria così presto![K]\nPotrebbe essere una trappola!", spanish="¡No seas tan ingenuo![K]\n¡Podría haber una trampa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  GROUND:MoveToPosition(hero, 176, 208, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(npc_npc_aamarudo, 204, 228, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(7937) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(10) [anim idle native]
  -- SetOutputAttribute(4) [neutre/état moteur]
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "shock", 1) end)
  -- SetAnimation(11) [anim idle native]
  GAME:WaitFrames(45)
  -- GAP: se_Play(7170) — id SE NDS sans portage PMDO identifié
  do local p=npc_npc_aamarudo.Position; GROUND:MoveToPosition(npc_npc_aamarudo, p.X+(0), p.Y+(24), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Uwaaaaaaaaaaahhhhhhhhhhhh!", french=" Yaaaaaaaaaaaaaaaah!", german=" Uwaaaaaaaaaaah!", italian=" Uaaaaaaaaaaaahhhhhhhhhhhh!", spanish=" ¡Aaaaaaaaaaaaaaaaaaaaah!"})
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" M-Master![K] Master!", french=" M-maître![K] Maître!", german=" M-meister![K] Meister!", italian=" M-Maestro![K] Maestro!", spanish=" ¡Ma... maestro![K] ¡Maestro!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Master!!!", french=" Maître!!!", german=" Meister!!!", italian=" Maestro!!!", spanish=" ¡¡¡Maestro!!!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="It's all right.[K] I can rescue\nhim later. ♪", french="Rien de grave.[K] Je lui porterai\nsecours plus tard. ♪", german="Ist schon okay.[K] Ich kann ihn\nauch noch später retten. ♪", italian="E va bene.[K] Lo aiuterò più\ntardi. ♪", spanish="Bueno, da igual.[K] Ya lo rescato\nluego. ♪"})
  -- message_Close
  pcall(function() GAME:MoveCamera(204, 176, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 204, 148, false, 2)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P20P01A2_374) [routine d'objet NDS non simulée - documenté]
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Master and I made a great\n[CN]team and we found a bunch\n[CN]of treasure!", french="[CN]Le Maître et moi, nous formions\n[CN]une super équipe et nous avons\n[CN]trouvé plein de trésors tous les deux!", german="[CN]Mein Meister und ich gaben ein\n[CN]wunderbares Team ab und wir fanden\n[CN]zusammen eine Menge Schätze!", italian="[CN]Io e il maestro eravamo una\n[CN]squadra fantastica e scoprivamo\n[CN]valanghe di tesori!", spanish="[CN]¡El maestro y yo formábamos\n[CN]un equipo inseparable y encontrábamos\n[CN]montones de tesoros!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Just like that, we...", french="[CN]C'est comme ça...", german="[CN]Es war wirklich großartig...", italian="[CN]Proprio così, noi...", spanish="[CN]Y así fue pasando el tiempo..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Went on one successful exploration\n[CN]after another. ♪", french="[CN]... que nous sommes passés d'une exploration\n[CN]réussie à une autre. ♪", german="[CN]Wir machten eine erfolgreiche\n[CN]Erkundung nach der anderen. ♪", italian="[CN]Portavamo a termine con successo\n[CN]un'esplorazione dietro l'altra. ♪", spanish="[CN]Yendo de una exploración triunfal\n[CN]a otra. ♪"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(210) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Then... A few months later...", french="[CN]Quelques mois plus tard...", german="[CN]Und dann... Ein paar Monate später...", italian="[CN]Poi... qualche mese più tardi...", spanish="[CN]Y varios meses más tarde..."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
