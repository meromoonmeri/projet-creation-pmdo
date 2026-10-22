-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D19P11A/m18a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Ugh...[K] We couldn't get\nthrough...", french="Argh...[K] On s'est pris\nune dérouillée...", german="Ugh...[K] Wir sind nicht\ndurchgekommen...", italian=" Uff...[K] Non ce l'abbiamo fatta...", spanish=" Vaya...[K] No hemos podido pasar."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Ouch...[K] We couldn't break\nthrough...", french="Argh...[K] On s'est pris\nune dérouillée...", german="Autsch...[K] Wir konnten nicht\ndurchbrechen...", italian="Ouch...[K] Non ce l'abbiamo\nfatta...", spanish=" Vaya...[K] No hemos podido pasar."})
  else
  SkySceneKit.say({english="Ouch...[K] We couldn't break\nthrough...", french="Argh...[K] On s'est pris\nune dérouillée...", german="Autsch...[K] Wir konnten nicht\ndurchbrechen...", italian=" Ouch...[K] Non ce l'abbiamo fatta...", spanish=" Vaya...[K] No hemos podido pasar."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D19P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Dark Hill.ogg", true) end)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hmmm... We got a little too\ncareless, maybe.", french="Hum... On a dû manquer\nde prudence.", german="Hmmm... Vielleicht waren wir\netwas zu leichtsinnig.", italian="Mmm... Dovevamo fare più\nattenzione, forse.", spanish="Hum... Quizás nos hemos\ndescuidado un poco."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hmmm... I think we got a little\ntoo careless.", french="Hum... On a dû manquer\nde prudence.", german="Hmmm... Wir waren wohl zu\nleichtsinnig.", italian="Mmm... Dovevamo fare più\nattenzione.", spanish="Hum... Quizás nos hemos\ndescuidado un poco."})
  else
  SkySceneKit.say({english="Hmmm... I think we were a bit\ntoo careless.", french="Hum... On a dû manquer\nde prudence.", german="Hmmm... Ich glaube, wir waren\nzu leichtsinnig.", italian="Mmm... Dovevamo fare più\nattenzione.", spanish="Hum... Quizás nos hemos\ndescuidado un poco."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We have to hurry and go.", french=" Partons vite.", german=" Wir müssen los, Beeilung!", italian=" Diamoci una mossa.", spanish=" Debemos darnos prisa y seguir."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We need to get away\nfrom them.", french=" Partons vite.", german=" Wir müssen weg von hier.", italian=" Dobbiamo seminarli.", spanish=" Debemos darnos prisa y seguir."})
  else
  SkySceneKit.say({english=" We have to hurry.", french=" Partons vite.", german=" Wir müssen uns beeilen.", italian=" Dobbiamo sbrigarci.", spanish=" Debemos darnos prisa y seguir."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We'll go when you're ready.", french=" On part quand tu veux.", german=" Wir gehen, wenn du so weit bist.", italian=" Quando è tutto pronto andiamo.", spanish=" Cuando quieras, seguimos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go when you're ready.", french=" On part quand tu veux.", german=" Gehen wir, wenn du so weit bist.", italian=" Quando è tutto pronto andiamo.", spanish=" Cuando quieras, seguimos."})
  else
  SkySceneKit.say({english=" Let's go when you're ready.", french=" On part quand tu veux.", german=" Gehen wir, wenn du so weit bist.", italian=" Quando è tutto pronto andiamo.", spanish=" Cuando quieras, seguimos."})
  end
  -- message_Close
end
