-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99C/s20p0104.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_H02P99C) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(We were told why [partner] and I can't\nevolve yet.)", french="(On nous a révélé, à [partner] et à moi,\npourquoi on ne pouvait pas évoluer.)", german="(Es wurde uns erklärt, warum [partner]\nund ich uns noch nicht entwickeln können.)", italian="(Poi ci è stato detto perché [partner] e io\nnon possiamo ancora evolverci.)", spanish="(Entonces nos explicaron por qué [partner]\ny yo no podíamos evolucionar.)"})
  else
  SkySceneKit.say({english="(We were told why [partner] and I can't\nevolve yet.)", french="(On nous a révélé, à [partner] et à moi,\npourquoi on ne pouvait pas évoluer.)", german="(Es wurde uns erklärt, warum [partner]\nund ich uns noch nicht entwickeln können.)", italian="(Poi ci è stato detto perché [partner] e io\nnon possiamo ancora evolverci.)", spanish="(Entonces nos explicaron por qué [partner]\ny yo no podíamos evolucionar.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(We were told that there was distortion in the\nfabric of space that prevented our evolution.)", french="(Une distorsion dans la trame de l'espace\nempêche notre évolution.)", german="(Es hieß, die Verzerrung des Raumgefüges\nverhindere unsere Entwicklung.)", italian="(Sembrerebbe che ci sia una distorsione della\nstruttura dello spazio che ci impedisce di\nevolverci.)", spanish="(Parecía deberse a la deformación del\nespacio.)"})
  else
  SkySceneKit.say({english="(We were told that there was distortion in the\nfabric of space that prevented our evolution.)", french="(Une distorsion dans la trame de l'espace\nempêche notre évolution.)", german="(Es hieß, die Verzerrung des Raumgefüges\nverhindere unsere Entwicklung.)", italian="(Sembrerebbe che ci sia una distorsione della\nstruttura dello spazio che ci impedisce di\nevolverci.)", spanish="(Parecía deberse a la deformación del\nespacio.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But what does \"a distortion in the fabric of\nspace\" mean?)", french="(Mais c'est quoi, une \"distorsion dans la trame\nde l'espace\"?)", german="(Aber was bedeutet das überhaupt?\nVerzerrung des Raumgefüges?)", italian="(Ma cosa significa \"una distorsione della\nstruttura dello spazio\"?)", spanish="(Pero, ¿qué será exactamente esa\n\"deformación del espacio\"?)"})
  else
  SkySceneKit.say({english="(But what does \"a distortion in the fabric of\nspace\" mean?)", french="(Mais c'est quoi, une \"distorsion dans la trame\nde l'espace\"?)", german="(Aber was bedeutet das überhaupt?\nVerzerrung des Raumgefüges?)", italian="(Ma cosa significa \"una distorsione della\nstruttura dello spazio\"?)", spanish="(Pero, ¿qué será exactamente esa\n\"deformación del espacio\"?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Time is back to normal...[K]but maybe some\nthings are still out of whack.)", french="(Le temps a repris son cours normal...[K] mais\npeut-être que quelque chose cloche\nencore.)", german="(Die Zeit läuft wieder normal...[K] Aber eventuell\nsind noch andere Dinge aus der Balance\ngeraten.)", italian="(Il tempo è tornato alla normalità...[K] ma forse\nalcune cose non sono ancora tornate a posto.)", spanish="(El tiempo ha vuelto a la normalidad...[K] pero\nquizás aún haya otras alteraciones.)"})
  else
  SkySceneKit.say({english="(Time is back to normal...[K]but maybe some\nthings are still out of whack.)", french="(Le temps a repris son cours normal...[K] mais\npeut-être que quelque chose cloche\nencore.)", german="(Die Zeit läuft wieder normal...[K] Aber eventuell\nsind noch andere Dinge aus der Balance\ngeraten.)", italian="(Il tempo è tornato alla normalità...[K] ma forse\nalcune cose non sono ancora tornate a posto.)", spanish="(El tiempo ha vuelto a la normalidad...[K] pero\nquizás aún haya otras alteraciones.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:FadeIn(128) -- WhiteChange
  GAME:WaitFrames(2)
  GAME:FadeIn(256) -- WhiteChange
  GAME:FadeIn(128) -- WhiteChange
  GAME:WaitFrames(5)
  GAME:FadeIn(2) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- GAP: se_Play(6425) — id SE NDS sans portage PMDO identifié
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa! Lightning!", french=" Ouah! Un éclair!", german=" Uaah! Blitze!", italian=" Waah! Fulmini!", spanish=" ¡Aah! ¡Un relámpago!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah! Lightning!", french=" Ouah! Un éclair!", german=" Aaaah! Blitze!", italian=" Aaah! Fulmini!", spanish=" ¡Aah! ¡Un relámpago!"})
  else
  SkySceneKit.say({english=" Waah! Lightning!", french=" Ouah! Un éclair!", german=" Aaaah! Blitze!", italian=" Aaah! Fulmini!", spanish=" ¡Aah! ¡Un relámpago!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The storm looks like it's\ngetting closer.", french="On dirait bien que l'orage se\nrapproche.", german="Der Sturm scheint näher zu\nkommen.", italian="Sembra che la tempesta si\nstia avvicinando.", spanish="Parece que la tormenta se\nacerca."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I think the storm's\ngetting closer.", french="On dirait bien que l'orage se\nrapproche.", german="Ich glaube, der Sturm kommt\nnäher.", italian="Sembra che la tempesta si\nstia avvicinando.", spanish="Parece que la tormenta se\nacerca."})
  else
  SkySceneKit.say({english="I think the storm's\ngetting closer.", french="On dirait bien que l'orage se\nrapproche.", german="Ich glaube, der Sturm kommt\nnäher.", italian="Sembra che la tempesta si\nstia avvicinando.", spanish="Parece que la tormenta se\nacerca."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I'm going to sleep now.", french=" Il est temps d'aller se coucher.", german=" Ich lege mich jetzt schlafen.", italian=" Cerchiamo di dormire, adesso.", spanish=" Deberíamos irnos a dormir."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We should get some sleep now.", french=" Il est temps d'aller se coucher.", german="Wir sollten versuchen, noch\neine Runde zu schlafen.", italian=" Cerchiamo di dormire, adesso.", spanish=" Deberíamos irnos a dormir."})
  else
  SkySceneKit.say({english=" We should get some sleep now.", french=" Il est temps d'aller se coucher.", german="Wir sollten versuchen, noch\neine Runde zu schlafen.", italian=" Cerchiamo di dormire, adesso.", spanish=" Deberíamos irnos a dormir."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Good night, [hero].", french=" Bonne nuit, [hero].", german=" Gute Nacht, [hero].", italian=" Buonanotte, [hero].", spanish=" Buenas noches, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Good night, [hero].", french=" Bonne nuit, [hero].", german=" Gute Nacht, [hero].", italian=" Buonanotte, [hero].", spanish=" Buenas noches, [hero]."})
  else
  SkySceneKit.say({english=" Good night, [hero].", french=" Bonne nuit, [hero].", german=" Gute Nacht, [hero].", italian=" Buonanotte, [hero].", spanish=" Buenas noches, [hero]."})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(30)
end
