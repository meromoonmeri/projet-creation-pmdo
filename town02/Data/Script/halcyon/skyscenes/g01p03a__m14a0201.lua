-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m14a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh! We blew that attempt!", french=" Argh! On a échoué!", german=" Ugh! Was für ein Reinfall!", italian=" Ohi ohi! È andata male!", spanish=" ¡Ay! Hemos fallado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh! That ended badly!", french=" Argh! On a échoué!", german=" Ugh! Das ging daneben!", italian="Oops! Non è andata affatto\nbene...", spanish=" ¡Ay! ¡Qué mal hemos acabado!"})
  else
  SkySceneKit.say({english=" Ugh! That wasn't so good!", french=" Argh! On a échoué!", german=" Ugh! Das war nicht so toll!", italian="Oops! Non è andata affatto\nbene...", spanish="¡Ay! No nos ha ido pero nada\nbien."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This is tougher than I thought.\nLet's go home for today.", french="C'est plus dur que je pensais.\nÇa suffit pour aujourd'hui.", german="Das ist schwerer, als ich dachte.\nMachen wir für heute Schluss.", italian="È più tosta di quello che\npensassi! Forse per oggi è meglio andare a\ncasa.", spanish="Es más difícil de lo que pensaba.\nVolvamos a casa."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This is much harder than\nexpected. Let's call it a day.", french="C'est plus dur que je pensais.\nÇa suffit pour aujourd'hui.", german="Das ist viel schwieriger, als ich\ndachte. Lassen wir es für heute gut sein.", italian="È più difficile del previsto. Per\noggi direi che può bastare.", spanish="Es más difícil de lo que pensaba.\nVamos a dejarlo por hoy."})
  else
  SkySceneKit.say({english="This won't be easy. Let's call it\na day.", french="C'est plus dur que je pensais.\nÇa suffit pour aujourd'hui.", german="Das wird nicht leicht werden.\nLassen wir es für heute gut sein.", italian="È più difficile del previsto. Per\noggi direi che può bastare.", spanish="Esto no será fácil.\nVamos a dejarlo por hoy."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  GAME:WaitFrames(60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
