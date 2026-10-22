-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/n01a1902.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  -- back_SetGround(LEVEL_T01P02A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_kakureon1 = SkySceneKit.spawn_npc("kecleon", 328, 168, Direction.Down, "NPC_KAKUREON1")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_kakureon2 = SkySceneKit.spawn_npc("kecleon", 352, 168, Direction.Down, "NPC_KAKUREON2")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GAME:MoveCamera(336, 196, 1, false) end) -- SetPositionMark performer/caméra
  GAME:FadeOut(false, 0) -- screen_FlushOut
  -- back_SetWeather(9) [météo visuelle ground NDS - documenté]
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Sniff...[K] What should I do...?[K]\nShould I buy it? Shouldn't I? I don't know...", french="Snif...[K] Que faire...?[K]\nL'acheter? Pas l'acheter? J'sais pas...", german="Schnüff...[K] Was mache ich\nnur?[K] Soll ich sie kaufen? Oder nicht?\nIch kann mich nicht entscheiden...", italian="Sniff...[K] Cosa devo fare...?[K]\nLa compro? Non la compro? Sono indeciso...", spanish="Jo...[K] ¿Qué hago...?[K] ¿La compro?\n¿No la compro? Qué dilema..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="To tell you the truth...[K]I've got\nthe money for it, but...", french="Pour dire la vérité...[K]\nJ'ai l'argent qu'y faut, mais...", german="Um die Wahrheit zu sagen...[K]\nIch hätte das Geld dafür...", italian="A dire la verità...[K] avrei i soldi\nper comprarla...", spanish="A decir verdad...[K] Tengo dinero\nsuficiente, pero..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(30)
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I've got my own money...[K]\nI always carry it with me...[CS:G]7[MP]000[CR][M:S0].", french="C'est mon argent à moi...[K]\nJ'l'ai toujours sur moi... [CS:G]7 000[CR][M:S0].", german="Ich hätte genug Geld...[K] Ich trage\nes immer bei mir... [CS:G]7.000[CR][M:S0].", italian="Ho dei risparmi da parte...[K]\nLi porto sempre con me... Sono [CS:G]7[MP]000[CR][M:S0].", spanish="Tengo mi propio dinero...[K]\nSiempre lo llevo encima... [CS:G]7000[CR][M:S0]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  -- back_SetBackEffect(4) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  -- SetAnimation(9) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Right then,\n[CN]we were watching you!", french="[CN]A ce moment-là,\n[CN]on était en train de t'épier!", german="[CN]In diesem Augenblick\n[CN]haben wir dich beobachtet!", italian="[CN]Proprio in quel momento,\n[CN]noi ti stavamo osservando!", spanish="[CN]¡Pues justo entonces\n[CN]te estábamos observando!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back_SetBackEffect(5) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  -- SetAnimation(1) [anim idle native]
  pcall(function() GAME:MoveCamera(424, 196, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- back_SetBackEffect(4) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  -- SetAnimation(9) [anim idle native]
  local npc_npc_guraigaa = SkySceneKit.spawn_npc("gligar", 528, 192, Direction.Left, "NPC_GURAIGAA")
  -- SetAnimation(3) [anim idle native]
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]When you pulled out that big wad\n[CN]of money...[K] What a mark!", french="[CN]Quand tu as sorti ce gros paquet\n[CN]d'argent...[K] quelle aubaine!", german="[CN]Als wir diesen Batzen Geld sahen...[K] Das war,\n[CN]als hätte man uns ein Zeichen gegeben!", italian="[CN]Quando hai tirato fuori tutti quei soldi\n[CN]ho pensato...[K] Che bel bottino!", spanish="[CN]Cuando sacaste ese dineral...[K]\n[CN]¡Se nos ocurrió dar el golpe perfecto!"})
  -- message_Close
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetBackEffect(5) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
