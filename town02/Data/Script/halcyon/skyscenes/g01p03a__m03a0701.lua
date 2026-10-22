-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m03a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hmm. That didn't end well...", french=" Argh... Ça s'est mal fini...", german=" Hmm. Das ging nicht gut aus.", italian=" Mmm. Non è finita bene...", spanish=" Ay... No se nos ha dado bien..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh. That didn't go well.", french=" Argh... Ça s'est mal fini...", german=" Hmpf. Das lief nicht gut.", italian=" Mmm. Non è andata bene.", spanish=" Uf... No se nos ha dado bien..."})
  else
  SkySceneKit.say({english=" Hmm. That didn't end well...", french=" Argh... Ça s'est mal fini...", german=" Hmm. Das ging nicht gut aus.", italian=" Mmm. È andata maluccio...", spanish=" Huy... No se nos ha dado bien..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hmmm... This is pretty hard.\nLet's break for today.", french="Ah... Ce n'est vraiment pas\nfacile. Restons-en là pour aujourd'hui.", german="Hmm... Das ist ziemlich\nschwierig. Machen wir für heute Pause.", italian="Mmm... È dura.\nPer oggi fermiamoci.", spanish="Hum... Esto es muy difícil.\nDejémoslo por hoy."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hmmm... This won't be easy...\nLet's break for today.", french="Ah... Ce n'est vraiment pas\nfacile. Restons-en là pour aujourd'hui.", german="Hmm... Das wird nicht leicht...\nMachen wir für heute Pause.", italian="Mmm... È difficile.\nBasta per oggi.", spanish="Hum... Esto no va a ser fácil.\nDejémoslo por hoy."})
  else
  SkySceneKit.say({english="Hmmm... This is really tough...\nLet's call it off for today.", french="Ah... Ce n'est vraiment pas\nfacile. Restons-en là pour aujourd'hui.", german="Hmm... Das ist wirklich\nschwierig. Machen wir für heute Pause.", italian="Mmm... È difficile.\nPer oggi basta così.", spanish="Vaya... Esto no es fácil.\nDejémoslo por hoy."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  GAME:WaitFrames(60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
