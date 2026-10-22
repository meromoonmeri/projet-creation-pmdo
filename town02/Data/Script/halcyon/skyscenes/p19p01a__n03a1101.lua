-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P19P01A/n03a1101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  local npc_npc_aamarudo = SkySceneKit.spawn_npc("armaldo", 256, 176, Direction.Down, "NPC_AAMARUDO")
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
  -- back_SetGround(LEVEL_P19P01A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_A_FUN_EXPLORATION non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Let's try again today.", french=" Essayons encore aujourd'hui.", german="Lass es uns heute auf ein Neues\nversuchen.", italian=" Riproviamoci subito.", spanish="Será mejor que\nvolvamos a intentarlo hoy."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Once you're ready, we'll go.", french=" Quand tu es prêt, on y va.", german="Wir werden aufbrechen, sobald\ndu fertig bist.", italian=" Quando sei pronto, andiamo.", spanish=" Nos iremos cuando estés listo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep, Master. ♪", french=" Voui, Maître. ♪", german=" Okay, Meister. ♪", italian=" Sì, maestro. ♪", spanish=" Vale, maestro. ♪"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
