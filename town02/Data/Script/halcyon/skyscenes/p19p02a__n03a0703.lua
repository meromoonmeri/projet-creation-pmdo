-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P19P02A/n03a0703.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_A_FUN_EXPLORATION non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_P19P02A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: se_Play(6667) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(25) [anim idle native]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(50)
  -- back_SetBackEffect(4) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]We would open up the map and look\n[CN]for a place to explore.", french="[CN]Nous déroulions la carte et nous cherchions\n[CN]un endroit à explorer.", german="[CN]Wir schlugen gemeinsam die Karte auf,\n[CN]um einen Ort zum Erkunden auszuwählen.", italian="[CN]Aprivamo la mappa e cercavamo\n[CN]un posto da esplorare.", spanish="[CN]Abríamos el mapa y buscábamos\n[CN]un lugar para explorar."})
  -- message_Close
  -- back_SetBackEffect(5) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  -- SetAnimation(1) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_aamarudo = SkySceneKit.spawn_npc("armaldo", 280, 168, Direction.Down, "NPC_AAMARUDO")
  GROUND:EntTurn(npc_npc_aamarudo, Direction.DownLeft)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Hey, Master...[K] Let's explore\nthis place today! ♪", french="Hé, Maître...[K] Allons explorer\ncet endroit aujourd'hui! ♪", german="Hey, Meister...[K] Lass uns heute\ndiesen Ort gemeinsam erkunden! ♪", italian="Ehi, maestro...[K] Andiamo\na esplorare questo posto oggi! ♪", spanish="Oye, maestro...[K] ¡Vamos a explorar\neste sitio hoy! ♪"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="This place...[K]labeled \"The End of\nthe World\"! ♪", french="Cet endroit...[K] appelé\n\"Le Bout du Monde\"! ♪", german="Diesen Ort[K] namens [F:S2]Das Ende\nder Welt[F:E2]! ♪", italian="Questo posto...[K] che si chiama\n\"La Fine del Mondo\"! ♪", spanish="Este sitio que se llama...[K] \"El fin\ndel mundo\". ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "angry", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Come on! There is no way we\ncould go to such a place.", french="Allons, allons! Nous n'avons\naucun moyen de nous rendre dans\nun tel endroit.", german="Nun mach aber mal halblang! So\neinen Ort können wir gar nicht erkunden.", italian="Insomma! Come puoi pensare\ndi andare in un posto simile?!", spanish="¡Qué dices! No podemos ir\na un sitio así."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.UpRight)
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(10)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetOutputAttribute(1) [neutre/état moteur]
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "angry", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  GAME:WaitFrames(100)
  -- back_SetBackEffect(4) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  -- PauseEffect(EFFECT_ANGRY) [neutre/état moteur]
  -- PauseEffect(EFFECT_LAUGHING) [neutre/état moteur]
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="[CN]We'd decide where to go together like\n[CN]two old friends...", french="[CN]Nous décidions ensemble de l'endroit où\n[CN]aller, comme de vieux amis...", german="[CN]Wir entschieden uns Tag für Tag gemeinsam\n[CN]für einen Ort. Wie zwei alte Freunde...", italian="[CN]Decidevamo insieme quali luoghi\n[CN]esplorare, come due vecchi amici...", spanish="[CN]Decidíamos adónde ir juntos, como\n[CN]dos viejos amigos..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="[CN]And then head out exploring right away...", french="[CN]Puis, on partait l'explorer sur-le-champ...", german="[CN]Und machten uns gleich danach\n[CN]auf die Erkundung...", italian="[CN]E poi partivamo subito a esplorare...", spanish="[CN]Y nos íbamos a explorar de inmediato..."})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
