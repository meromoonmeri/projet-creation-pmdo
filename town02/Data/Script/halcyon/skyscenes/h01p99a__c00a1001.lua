-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99A/c00a1001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_H01P99A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I'm beat! It was a long day!", french=" Je suis vanné! Rude journée!", german="Ich bin platt! Das war ein langer\nTag!", italian="Sono sfinito! È stata una lunga\ngiornata!", spanish="¡Me duele todo el cuerpo!\n¡Vaya día que hemos tenido!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We put in a full day today.\nI'm exhausted.", french=" Je suis vanné! Rude journée!", german="Wir haben heute den ganzen Tag\nlang Einsatz gezeigt. Ich bin erschöpft.", italian="Oggi abbiamo dato tutto. Sono\nesausto.", spanish="Ha sido un día duro, estoy que\nno me puedo mover."})
  else
  SkySceneKit.say({english="We worked hard all day long.\nI'm tired!", french=" Je suis vannée! Rude journée!", german="Wir haben den ganzen Tag lang\nhart gearbeitet. Ich bin müde!", italian="Oggi abbiamo dato tutto. Sono\nstanca.", spanish="Ha sido un día muy largo.\n¡Estoy molida!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We should get some rest now.", french=" Allons nous reposer, maintenant.", german="Wir sollten uns jetzt etwas\nausruhen.", italian=" Dovremmo riposarci un po'.", spanish="Será mejor que vayamos a\ndormir."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We should get some sleep now.", french=" Allons nous reposer, maintenant.", german="Wir sollten jetzt etwas\nschlafen.", italian=" Dovremmo dormire un po'.", spanish=" Mejor nos vamos a dormir."})
  else
  SkySceneKit.say({english=" We should get some sleep now.", french=" Allons nous reposer, maintenant.", german="Wir sollten jetzt etwas\nschlafen.", italian=" Dovremmo dormire un po'.", spanish=" Mejor nos vamos a dormir."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That way, we can put in another\ngood effort tomorrow.", french="Comme ça, on sera en forme\npour demain.", german="Auf diese Weise können wir\nmorgen wieder richtig loslegen.", italian="Così, domani saremo di nuovo\nin gran forma.", spanish="Así, mañana nos levantaremos\ncon las pilas cargadas."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We can be rested up for another\ngood day tomorrow.", french="Comme ça, on sera en forme\npour demain.", german="Wir sollten für einen weiteren\ntollen Tag morgen ausgeruht sein.", italian="Ne abbiamo bisogno, così domani\npotremo dare il meglio.", spanish="Así, mañana nos levantaremos\ncon las pilas cargadas."})
  else
  SkySceneKit.say({english="We'll need it for another full\nday tomorrow.", french="Comme ça, on sera en forme\npour demain.", german="Wir brauchen die Erholung für\neinen weiteren langen Tag morgen.", italian="Ne abbiamo bisogno, così domani\npossiamo dare il meglio.", spanish="Así, mañana nos levantaremos\ncon las pilas cargadas."})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(30)
end
