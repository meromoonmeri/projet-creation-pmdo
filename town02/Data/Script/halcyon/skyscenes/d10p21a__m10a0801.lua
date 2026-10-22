-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D10P21A/m10a0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh...[K] We blew it!", french=" Argh...[K] On a échoué!", german=" Ugh...[K] Wir haben es vergeigt!", italian=" Ugh...[K] Che fiasco!", spanish=" Uf...[K] ¡Qué mal!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk...[K] That didn't go well!", french=" Argh...[K] On a échoué!", german=" Urk...[K] Das lief nicht gut!", italian="Ehm...[K] Non è andata troppo\nbene, direi!", spanish=" Ay...[K] ¡Esto no ha ido bien!"})
  else
  SkySceneKit.say({english=" Ack...[K] We didn't make it!", french=" Argh...[K] On a échoué!", german="Argh...[K] Wir haben es nicht\ngeschafft!", italian=" Nooo...[K] Non c'è l'abbiamo fatta!", spanish=" Ay...[K] ¡Ha ido de pena!"})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D10P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Upper Steam Cave.ogg", true) end)
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
  SkySceneKit.say({english=" The going's really rough here.", french="Ça devient de plus en plus\ndifficile.", german="Hier kommt man wirklich\nschwer voran.", italian=" È proprio tosta, eh?", spanish=" Es un sitio complicado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's really tough.", french="Ça devient de plus en plus\ndifficile.", german=" Das war wirklich schwierig.", italian=" Che fatica!", spanish=" Esto es duro."})
  else
  SkySceneKit.say({english=" Wow, that was really tough!", french="Ça devient de plus en plus\ndifficile.", german=" Wow, das war echt schwierig!", italian=" Che fatica!", spanish=" Vaya, ¡qué duro ha resultado!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But we're not far now![K] We can't\ngive up. Let's keep going!", french="Mais on se rapproche![K] Courage,\nil faut continuer!", german="Aber es ist nicht mehr weit![K]\nWir dürfen nicht aufgeben. Gehen wir weiter!", italian="Ormai ci siamo, dai![K] Non\npossiamo arrenderci ora. Andiamo!", spanish="¡Pero ya no queda mucho![K]\nNo podemos rendirnos. ¡Sigamos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But we don't have far to go.[K]\nWe can't give up. We have to keep trying!", french="Mais on se rapproche![K] Courage,\nil faut continuer!", german="Aber es ist nicht mehr weit.[K]\nWir dürfen nicht aufgeben. Wir müssen\nweiterkämpfen!", italian="Però ormai ci siamo.[K]\nNon possiamo arrenderci. Dobbiamo farcela!", spanish="¡Pero ya no queda mucho![K]\nNo podemos rendirnos. ¡Sigamos intentándolo!"})
  else
  SkySceneKit.say({english="But we're so close![K] We just\ncan't give up now! Let's keep trying!", french="Mais on se rapproche![K] Courage,\nil faut continuer!", german="Aber wir sind so nah dran![K]\nWir dürfen jetzt nicht aufgeben! Wir müssen\nweiterkämpfen!", italian="Però ormai ci siamo.[K]\nNon possiamo arrenderci. Dobbiamo farcela!", spanish="¡Pero ya no queda mucho![K]\n¡No nos rindamos ahora! ¡Sigamos intentándolo!"})
  end
  -- message_Close
end
