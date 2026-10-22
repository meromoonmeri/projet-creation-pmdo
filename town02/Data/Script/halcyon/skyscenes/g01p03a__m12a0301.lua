-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m12a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh! We blew that try...", french="Argh! On a lamentablement\néchoué...", german=" Ugh! Das haben wir vergeigt...", italian=" Ugh! Non è andata troppo bene...", spanish="¡Ay! Este intento ha sido\nun desastre."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh! That ended badly...", french="Argh! On a lamentablement\néchoué...", german=" Ugh! Das ging nicht gut aus...", italian=" Ugh! Non è andata troppo bene...", spanish=" ¡Ay! ¡Qué desastre!"})
  else
  SkySceneKit.say({english=" Ugh! That wasn't so good...", french="Argh! On a lamentablement\néchoué...", german=" Ugh! Das lief nicht gut...", italian=" Ugh! Non è andata troppo bene...", spanish="¡Ay! Podríamos haberlo hecho\nmejor."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's harder than I thought...[K]\nLet's go home for today.", french="C'est plus dur que je croyais...[K]\nArrêtons là pour aujourd'hui.", german="Das ist schwieriger, als ich\ndachte.[K] Gehen wir für heute nach Hause.", italian="È più tosta di quel che\npensassi...[K] Per oggi è meglio lasciar perdere.", spanish="Es más difícil de lo que\nesperaba...[K] Mejor dejémoslo por hoy."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's harder than I thought...[K]\nLet's go home for today.", french="C'est plus dur que je croyais...[K]\nArrêtons là pour aujourd'hui.", german="Das ist schwieriger, als ich\ndachte.[K] Gehen wir für heute nach Hause.", italian="È più difficile di quel che\npensassi...[K] Per oggi è meglio lasciar perdere.", spanish="Es más difícil de lo que\nesperaba...[K] Mejor dejémoslo por hoy."})
  else
  SkySceneKit.say({english="Hmm... This won't be easy...[K]\nLet's call it a day.", french="C'est plus dur que je croyais...[K]\nArrêtons là pour aujourd'hui.", german="Hmm, das wird nicht leicht\nwerden.[K] Machen wir für heute Schluss.", italian="È più difficile di quel che\npensassi...[K] Per oggi è meglio lasciar perdere.", spanish="Esto no va a ser fácil...[K]\nMejor dejémoslo por hoy."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  GAME:WaitFrames(60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
