-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D15P21A/m14a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh! We blew it!", french="Argh! On a lamentablement\néchoué!", german=" Ugh! Wir haben versagt!", italian=" Ohi! Che fiasco!", spanish=" ¡Ay! ¡La hemos pifiado!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh! That ended badly.", french="Argh! On a lamentablement\néchoué!", german=" Ugh! Das ging nicht gut aus.", italian=" Ohi ohi. Così non va.", spanish=" ¡Ay! ¡Qué mal!"})
  else
  SkySceneKit.say({english=" Ugh! We didn't make it!", french="Argh! On a lamentablement\néchoué!", german="Ugh! Wir haben es nicht\ngeschafft!", italian=" Ohi ohi. Niente da fare.", spanish=" ¡Ay! ¡No lo hemos conseguido!"})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D15P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(8) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_QUICKSAND_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
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
  SkySceneKit.say({english=" Ugh! The going's rough here!", french="Argh! Ce n'est pas une sinécure,\nici!", german="Ugh! Man kommt hier schwer\nvoran!", italian=" Ugh! È proprio tosta, eh?", spanish=" ¡Ay! ¡Qué difícil nos lo ponen!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh! It's really tough here!", french="Argh! Ce n'est pas une sinécure,\nici!", german="Ugh! Es ist wirklich schwierig,\nhier voranzukommen!", italian="Ugh! È proprio difficile\nproseguire.", spanish=" ¡Ay! ¡Esto es muy difícil!"})
  else
  SkySceneKit.say({english="Ugh! The going is really\nrough here!", french="Argh! Ce n'est pas une sinécure,\nici!", german="Ugh! Es ist wirklich schwierig,\nhier voranzukommen!", italian="Ugh! È proprio difficile\nproseguire.", spanish="¡Ay! ¡Las cosas no son nada\nfáciles por aquí!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But it's not far now. We can't\ngive up. Let's keep going!", french="Mais on se rapproche du but.\nPas question de baisser les bras!\nAccrochons-nous!", german="Aber es ist jetzt nicht mehr\nweit. Wir dürfen nicht aufgeben.\nGehen wir weiter!", italian="Ma ci siamo quasi. Non possiamo\nmollare adesso! Forza!", spanish="Pero ya no queda mucho.\nNo podemos rendirnos ahora.\n¡Hay que seguir adelante!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But we don't have far to go. We\ncan't give up. We have to keep trying!", french="Mais on se rapproche du but.\nPas question de baisser les bras!\nAccrochons-nous!", german="Aber es ist jetzt nicht mehr\nweit. Wir dürfen nicht aufgeben.\nWir müssen weitermachen!", italian="Ma dobbiamo andare avanti.\nCoraggio! Non manca molto ormai!", spanish="Pero ya no queda mucho.\nNo podemos rendirnos. ¡Tenemos\nque seguir intentándolo!"})
  else
  SkySceneKit.say({english="But we're so close. There's no\ngiving up now. We have to keep trying!", french="Mais on se rapproche du but.\nPas question de baisser les bras!\nAccrochons-nous!", german="Aber wir sind so nah dran.\nWir dürfen jetzt nicht aufgeben. Wir müssen\nweitermachen!", italian="Ma dobbiamo andare avanti.\nCoraggio! Non manca molto ormai!", spanish="Pero ya no queda mucho.\nNo podemos rendirnos. ¡Tenemos\nque seguir intentándolo!"})
  end
  -- message_Close
end
