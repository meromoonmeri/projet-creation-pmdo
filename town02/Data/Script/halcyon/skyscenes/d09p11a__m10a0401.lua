-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D09P11A/m10a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh![K] We couldn't get through!", french=" Argh![K] On a échoué!", german="Ugh![K] Wir sind nicht\ndurchgekommen!", italian=" Ugh![K] Niente da fare!", spanish=" ¡Ay![K] ¡No hemos podido pasar!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ouch![K] We didn't make it through!", french=" Argh![K] On a échoué!", german="Autsch![K] Wir haben es nicht\ngeschafft!", italian=" Ahi ahi![K] Non ce l'abbiamo fatta!", spanish=" ¡Ay![K] ¡No hemos podido pasar!"})
  else
  SkySceneKit.say({english=" Ouchie![K] We didn't get through!", french=" Argh![K] On a échoué!", german="Autschie![K] Wir sind nicht\ndurchgekommen!", italian=" Ahi ahi![K] Non ce l'abbiamo fatta!", spanish=" ¡Ay![K] ¡No hemos podido pasar!"})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D09P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Steam Cave.ogg", true) end)
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
  SkySceneKit.say({english=" We got a little cocky, I guess.", french=" On a dû manquer de prudence.", german="Wir waren ein bisschen\nübermütig, schätze ich.", italian="Non è stata una buona idea\nbuttarsi così a capofitto!", spanish=" Supongo que nos hemos confiado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I guess we got a little careless.", french=" On a dû manquer de prudence.", german="Ich schätze, wir waren etwas\nleichtsinnig.", italian="Avremmo dovuto essere un po'\npiù prudenti.", spanish="Supongo que hemos sido algo\ndescuidados."})
  else
  SkySceneKit.say({english=" I guess we got a little careless?", french=" On a dû manquer de prudence.", german="Wir waren wohl etwas\nleichtsinnig, was?", italian="Avremmo dovuto agire con\nmaggiore prudenza.", spanish=" Supongo que nos hemos confiado."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But there's no time to waste\nfeeling sorry for ourselves!", french="Mais pas le temps de nous\napitoyer sur notre sort!", german="Aber verschwenden wir keine\nZeit mit Selbstmitleid!", italian="Beh, non c'è tempo per piangersi\naddosso, giusto?", spanish="Pero no podemos perder\nel tiempo con lloriqueos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But there's no time to feel sorry\nfor ourselves.", french="Mais pas le temps de nous\napitoyer sur notre sort!", german="Aber wir haben keine Zeit für\nSelbstmitleid.", italian="Ma ora non è il momento di\ncommiserarsi, giusto?", spanish="Pero no hay tiempo para\nlamentarse."})
  else
  SkySceneKit.say({english="But there's no time to feel sorry\nfor ourselves.", french="Mais pas le temps de nous\napitoyer sur notre sort!", german="Aber wir haben keine Zeit für\nSelbstmitleid.", italian="Ma ora non è il momento di\ncommiserarsi, giusto?", spanish="Pero no hay tiempo para\nlamentos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [hero], let's keep it going!", french=" Accrochons-nous, [hero]!", german="[hero], machen wir\nweiter!", italian=" Diamoci dentro, [hero]!", spanish=" ¡[hero], sigamos adelante!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [hero], let's keep at it!", french=" Accrochons-nous, [hero]!", german="[hero], lass uns nicht\naufgeben!", italian=" Forza e coraggio, [hero]!", spanish=" ¡[hero], sigamos adelante!"})
  else
  SkySceneKit.say({english=" [hero], let's keep at it!", french=" Accrochons-nous, [hero]!", german="[hero], lass uns nicht\naufgeben!", italian=" Forza e coraggio, [hero]!", spanish=" ¡[hero], sigamos adelante!"})
  end
  -- message_Close
end
