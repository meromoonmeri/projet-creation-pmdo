-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/c00a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  do local __sw = select(1, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[0]) [scn($SCENARIO_MAIN)[0]: chapitre courant]
  if __sw == 25 or __sw == 26 then
  -- @label_0 [étiquette de flux ExplorerScript]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk! We didn't do well on that.", french="Argh! On n'a pas vraiment\nassuré sur ce coup-là...", german="Urgs! Dabei haben wir uns aber\nnicht gut angestellt.", italian=" Uff! Non ce l'abbiamo fatta.", spanish=" ¡Uf! Hemos metido la pata."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk! That's how not to do it.", french="Argh! On n'a pas vraiment\nassuré sur ce coup-là...", german="Urgs! So sollte man das wohl\nnicht machen.", italian=" Uff! Ci è andata male.", spanish=" ¡Uf! Hoy no ha habido suerte."})
  else
  SkySceneKit.say({english=" Urk! That didn't work.", french="Argh! On n'a pas vraiment\nassuré sur ce coup-là...", german=" Urgs! Das hat nicht funktioniert.", italian=" Uff! Così non va bene", spanish=" ¡Uf! Esta vez no hubo manera."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hmm... This is demanding.[K]\nLet's go back for now.", french="Ce n'est vraiment pas facile...[K]\nTant pis, on réessaiera une autre fois.", german="Hmm, das ist ziemlich\nfordernd.[K] Gehen wir fürs Erste zurück.", italian="Mmm... È molto impegnativo.[K]\nPer ora torniamo indietro.", spanish="Hum... Esto parece difícil.[K]\n¿Por qué no volvemos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hmm... This is challenging.[K]\nLet's go back for now.", french="Ce n'est vraiment pas facile...[K]\nTant pis, on réessaiera une autre fois.", german="Hmm, das ist eine richtige\nHerausforderung.[K] Gehen wir fürs Erste\nzurück.", italian="Mmm... È molto impegnativo.[K]\nPer ora torniamo indietro.", spanish="Hum... La cosa está complicada.[K]\n¿Por qué no volvemos?"})
  else
  SkySceneKit.say({english="Hmm... This is kind of hard.[K]\nLet's go back for now.", french="Ce n'est vraiment pas facile...[K]\nTant pis, on réessaiera une autre fois.", german="Hmm, das ist ziemlich\nschwierig.[K] Gehen wir fürs Erste zurück.", italian="Mmm... È molto difficile.[K]\nPer ora torniamo indietro.", spanish="Hum... Es bastante duro.[K]\n¿Por qué no volvemos?"})
  end
  -- message_KeyWait
  -- @label_1 [étiquette de flux ExplorerScript]
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  GAME:WaitFrames(60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  elseif true then -- default
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh! Well, that went badly.", french=" Argh! Ben ça s'est mal passé!", german="Umpf! Nun, das ist wohl\nschiefgegangen.", italian=" Uh! Beh, è andata male.", spanish=" ¡Uf! Hoy nos hemos lucido..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh! That didn't go well.", french=" Argh! Ben ça s'est mal passé!", german="Umpf! Nun, das ist wohl nicht\ngutgegangen.", italian=" Uh! Non è andata molto bene.", spanish=" ¡Uf! No se nos ha dado muy bien."})
  else
  SkySceneKit.say({english=" Ugh! Well that wasn't so good.", french=" Argh! Ben ça s'est mal passé!", german="Umpf! Nun, das war wohl nicht\nso gut.", italian="Uh! Beh, non è andata molto\nbene.", spanish=" ¡Uf! Podría haber estado mejor."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's harder than I thought...[K]\nLet's try this another time.", french="C'est plus dur que je croyais...[K]\nOn retentera notre chance une autre fois.", german="Es ist schwieriger, als ich\nangenommen hatte.[K] Versuchen wir es\nzu einer anderen Zeit noch einmal.", italian="È più difficile di quel che\npensavo...[K] Ci proveremo un'altra volta.", spanish="Ha sido más difícil de lo que\ncreía...[K] Tendremos que probar otra vez."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's harder than I thought...[K]\nLet's call it a day.", french="C'est plus dur que je croyais...[K]\nOn retentera notre chance une autre fois.", german="Es ist schwieriger, als ich\nangenommen hatte.[K] Lassen wir es gut sein für\nheute.", italian="È più difficile di quel che\npensavo...[K] Basta così, per oggi.", spanish="Ha sido más difícil de lo que\ncreía...[K] Y, por hoy, ha sido suficiente."})
  else
  SkySceneKit.say({english="It's harder than I thought...[K]\nLet's go home for the day.", french="C'est plus dur que je croyais...[K]\nOn retentera notre chance une autre fois.", german="Es ist schwieriger, als ich\nangenommen hatte.[K] Gehen wir für heute nach\nHause.", italian="È più difficile di quel che\npensavo...[K] Basta così, per oggi.", spanish="Ha sido más difícil de lo que\ncreía...[K] Más vale que descansemos por hoy."})
  end
  -- message_KeyWait
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
