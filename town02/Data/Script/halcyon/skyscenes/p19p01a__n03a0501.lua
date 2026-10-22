-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P19P01A/n03a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=42, sub=3} -- $SCENARIO_SIDE = scn[42,3] (ROM)
  local npc_npc_aamarudo = SkySceneKit.spawn_npc("armaldo", 256, 176, Direction.Down, "NPC_AAMARUDO")
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Ooogh...[K] That was pretty tough...", french=" Aaargh...[K] C'était plutôt corsé...", german=" Ooouuufff...[K] Das war hart...", italian=" Ooogh...[K] È proprio dura...", spanish=" Uf...[K] Eso ha sido durillo..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" I'll have to try it again.", french=" Il va falloir réessayer.", german="Das müssen wir noch mal\nversuchen.", italian=" Dovremo provarci un'altra volta.", spanish=" Habrá que volver a intentarlo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep. ♪", french=" Voui. ♪", german=" Ja. ♪", italian=" Sì. ♪", spanish=" Pues sí. ♪"})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_P19P01A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- GAP: BGM BGM_A_FUN_EXPLORATION non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" We've still got time today.", french="On a encore un peu de temps\naujourd'hui.", german="Wir haben heute noch ein\nwenig Zeit.", italian=" Oggi abbiamo ancora tempo.", spanish=" Aún nos queda tiempo hoy."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Lets prepare for our exploration\nand make another try at [CS:P]Eastern Cave[CR]!", french="Préparons-nous pour\nl'exploration et faisons une nouvelle tentative\nà la [CS:P]Caverne de l'Est[CR]!", german="Lass uns Vorbereitungen treffen\nund die [CS:P]Östliche Höhle[CR] noch einmal besuchen!", italian="Prepariamoci e facciamo\nun altro tentativo esplorando la [CS:P]Grotta[CR]\n[CS:P]Orientale[CR]!", spanish="¡Vamos a prepararnos para\nla exploración y a probar suerte otra vez\nen la [CS:P]Cueva Oriental[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Oh! ♪", french=" Oh! ♪", german=" Oh ja! ♪", italian=" Urrà! ♪", spanish=" ¡Eso! ♪"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
