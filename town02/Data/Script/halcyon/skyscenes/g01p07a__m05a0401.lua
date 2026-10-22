-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07A/m05a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh... That didn't go well...", french="Argh... Ça ne s'est pas bien\nterminé...", german=" Uff... Das ging daneben...", italian=" Ugh... Non è andata bene...", spanish=" Uf... No ha ido muy bien..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh... That didn't go well...", french="Argh... Ça ne s'est pas bien\nterminé...", german=" Uff... Das war wohl nichts...", italian=" Ugh... Non è andata bene...", spanish=" Uf... No ha ido muy bien..."})
  else
  SkySceneKit.say({english=" Ugh... That didn't go well...", french="Argh... Ça ne s'est pas bien\nterminé...", german=" Uff... Das ging daneben...", italian=" Ugh... Non è andata bene...", spanish=" Uf... No nos ha ido muy bien..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hmmm... This is pretty\nchallenging...[K] Let's call it off for today.", french="Hum... C'est vraiment difficile...\nÇa suffit pour aujourd'hui.", german="Hmm... Das ist nicht leicht...[K]\nVerschieben wir es auf ein andermal.", italian="Mmm... È un'impresa non da\npoco...[K] Per oggi può bastare così.", spanish="Uf...[K] Esto es todo un desafío...\nVamos a dejarlo por hoy."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hmmm... This won't be easy...\nLet's call it off for today.", french="Hum... C'est vraiment difficile...\nÇa suffit pour aujourd'hui.", german="Hmm... Das wird nicht leicht...\nLassen wir es für heute.", italian="Mmm... È un'impresa non da\npoco...[K] Per oggi può bastare così.", spanish="Hum... Esto no va a ser fácil...\nVamos a dejarlo por hoy."})
  else
  SkySceneKit.say({english="Hmmm... This is really hard...\nLet's call it off for today.", french="Hum... C'est vraiment difficile...\nÇa suffit pour aujourd'hui.", german="Hmm... Das ist ganz schön\nschwierig. Lassen wir es für heute.", italian="Mmm... È un'impresa non da\npoco...[K] Per oggi può bastare così.", spanish="Vaya... Está resultando muy\ndifícil... Vamos a dejarlo por hoy."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  GAME:WaitFrames(60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
