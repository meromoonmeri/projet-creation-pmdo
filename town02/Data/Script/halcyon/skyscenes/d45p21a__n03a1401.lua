-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D45P21A/n03a1401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  local npc_npc_aamarudo = SkySceneKit.spawn_npc("armaldo", 248, 296, Direction.Left, "NPC_AAMARUDO")
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Hmmm...[K] Just as I suspected.\nThis is a bit difficult...", french="Mmmh...[K] Je m'en doutais.\nC'est un peu difficile...", german="Hmmm...[K] Ganz wie befürchtet.\nDas ist schwieriger als erwartet...", italian="Uhmmm...[K] È difficile, proprio\ncome immaginavo...", spanish="Hum...[K] Tal como sospechaba,\nesto es algo difícil..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" We should try again.", french=" On devrait refaire une tentative.", german=" Versuchen wir es noch einmal.", italian=" Dobbiamo riprovarci.", spanish=" Deberíamos volver a intentarlo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep. ♪", french=" Voui. ♪", german=" Au ja. ♪", italian=" Sì. ♪", spanish=" Vale. ♪"})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D45P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_FORTUNE_RAVINE_DEPTHS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" This place is a bit difficult...", french=" Ce donjon est un peu difficile...", german="Dieser Ort ist ein bisschen\nschwierig.", italian="Questo posto non è per niente\nfacile da esplorare...", spanish=" Este lugar es algo difícil..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="But we shouldn't give up. Let's\nkeep trying.[K] Come on!", french="Mais nous ne devons pas\nabandonner. Essayons encore.[K] Allons!", german="Aber wir sollten nicht aufgeben.\nLass es uns weiter versuchen.[K] Komm schon!", italian="Ma non dobbiamo arrenderci.\nContinuiamo a provare.[K] Forza!", spanish="Pero no debemos rendirnos, hay\nque seguir intentándolo.[K] ¡A por todas!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Yep. ♪[K] Let's do our best,\nMaster! ♪", french="Voui. ♪[K] Faisons de notre\nmieux, Maître! ♪", german="Jawoll. ♪[K] Lass uns unser\nBestes geben, Meister! ♪", italian="Sì. ♪[K] Facciamo del nostro\nmeglio, maestro! ♪", spanish="Vale. ♪[K] ¡Vamos a por todas,\nmaestro! ♪"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
