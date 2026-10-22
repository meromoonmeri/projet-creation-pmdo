-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P03P01A/m09d0613.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_P03P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Wh-what was that?)", french="(C'était quoi?)", german="(W-was war das?)", italian="(C-Cosa è stato?)", spanish="(¿Qué... qué ha sido eso?)"})
  else
  SkySceneKit.say({english="(Wh-what was that?)", french="(C'était quoi?)", german="(W-was war das?)", italian="(C-Cosa è stato?)", spanish="(¿Qué... qué ha sido eso?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Whose voice was that?)", french="(A qui appartenait cette voix?)", german="(Wessen Stimme war das?)", italian="(Di chi era quella voce?)", spanish="(¿De quién era esa voz?)"})
  else
  SkySceneKit.say({english="(Whose voice was that?)", french="(A qui appartenait cette voix?)", german="(Wessen Stimme war das?)", italian="(Di chi era quella voce?)", spanish="(¿De quién era esa voz?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5133) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Wh-what, again?)", french="(Quoi, encore?)", german="(W-was?)", italian="(C-Cosa? Ancora?)", spanish="(¿Cómo, otra vez?)"})
  else
  SkySceneKit.say({english="(Wh-what, again?)", french="(Quoi, encore?)", german="(W-was?)", italian="(C-Cosa? Ancora?)", spanish="(¿Cómo, otra vez?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(So soon after the first one...)", french="(Déjà une deuxième vision...)", german="(Schon so kurz nach dem ersten...)", italian="(Così presto dopo il primo...)", spanish="(Justo después de la otra.)"})
  else
  SkySceneKit.say({english="(So soon after the first one...)", french="(Déjà une deuxième vision...)", german="(Schon so kurz nach dem ersten...)", italian="(Così presto dopo il primo...)", spanish="(Justo después de la otra.)"})
  end
  -- message_Close
  GAME:FadeOut(false,  5)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
