-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D38P12A/s21p0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  if (SkyProg.cmp(29, 82) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 82]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh...[K] We couldn't get through...", french="Argh...[K] On a lamentablement\néchoué...", german="Uff...[K] Wir sind nicht\ndurchgekommen...", italian=" Ugh...[K] Non ce l'abbiamo fatta...", spanish=" Uf...[K] No lo hemos logrado..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh...[K] We couldn't break through.", french="Argh...[K] On a lamentablement\néchoué...", german="Uff...[K] Wir konnten uns nicht\ndurchsetzen.", italian=" Ugh...[K] Non ce l'abbiamo fatta...", spanish=" Uf...[K] No lo hemos logrado..."})
  else
  SkySceneKit.say({english=" Ugh...[K] We couldn't break through.", french="Argh...[K] On a lamentablement\néchoué...", german="Uff...[K] Wir konnten uns nicht\ndurchsetzen.", italian=" Ugh...[K] Non ce l'abbiamo fatta...", spanish=" Uf...[K] No lo hemos logrado..."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D38P12A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Chasm Cave.ogg", true) end)
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
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hmm... We were a bit careless.", french="Hum... On aurait dû rester\nsur nos gardes.", german=" Hmm... Wir waren zu sorglos.", italian="Mmm... Non abbiamo fatto\nabbastanza attenzione.", spanish="Hum... Hemos sido un poco\nimprudentes."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hmm... We were a bit careless.", french="Hum... On aurait dû rester\nsur nos gardes.", german=" Hmm... Wir waren zu sorglos.", italian="Mmm... Non abbiamo fatto\nabbastanza attenzione.", spanish="Hum... Hemos sido un poco\nimprudentes."})
  else
  SkySceneKit.say({english=" Hmm... We were a bit careless.", french="Hum... On aurait dû rester\nsur nos gardes.", german=" Hmm... Wir waren zu sorglos.", italian="Mmm... Non abbiamo fatto\nabbastanza attenzione.", spanish="Hum... Hemos sido un poco\nimprudentes."})
  end
  -- message_Close
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If we stick around here, [CS:N]Palkia[CR]\ncould find us.", french="Si on reste là, [CS:N]Palkia[CR] risque\nde retrouver notre trace.", german="Wenn wir uns weiter hier\naufhalten, könnte [CS:N]Palkia[CR] uns finden.", italian="Se rimaniamo qui, [CS:N]Palkia[CR]\npotrebbe trovarci.", spanish="Si nos quedamos aquí, [CS:N]Palkia[CR]\nacabará por encontrarnos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If we stay here, [CS:N]Palkia[CR] could\nfind us.", french="Si on reste là, [CS:N]Palkia[CR] risque\nde retrouver notre trace.", german="Wenn wir weiter hierbleiben,\nkönnte [CS:N]Palkia[CR] uns finden.", italian="Se rimaniamo qui, [CS:N]Palkia[CR]\npotrebbe trovarci.", spanish="Si nos quedamos aquí, [CS:N]Palkia[CR]\nacabará por encontrarnos."})
  else
  SkySceneKit.say({english="We can't stay here, because\n[CS:N]Palkia[CR] could find us.", french="Si on reste là, [CS:N]Palkia[CR] risque\nde retrouver notre trace.", german="Wir können nicht hierbleiben.\n[CS:N]Palkia[CR] könnte uns finden.", italian="Se rimaniamo qui, [CS:N]Palkia[CR]\npotrebbe trovarci.", spanish="Si nos quedamos aquí, [CS:N]Palkia[CR]\nacabará por encontrarnos."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's get away from here.", french=" Sauvons-nous d'ici.", german="Wir sollten schleunigst von hier\naufbrechen.", italian=" Dobbiamo andarcene.", spanish=" Hay que marcharse."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We need to get out of here\nright away.", french=" Sauvons-nous d'ici.", german="Wir müssen sofort von hier\nverschwinden.", italian=" Dobbiamo andarcene.", spanish=" Vámonos cuanto antes."})
  else
  SkySceneKit.say({english=" We should get away from here.", french=" Sauvons-nous d'ici.", german="Wir sollten von hier\nverschwinden.", italian=" Dobbiamo andarcene.", spanish=" Vámonos cuanto antes."})
  end
  -- message_Close
  else
  SkyProg.set(29, 82) -- $SCENARIO_MAIN = scn[29,82] (ROM)
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
end
