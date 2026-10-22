-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D29P11A/m25a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh...[K] We messed up...", french="Argh...[K] Ça ne s'est pas passé\ncomme prévu...", german=" Uff...[K] Wir haben es vergeigt...", italian=" Uff...[K] Abbiamo fallito...", spanish=" Ay...[K] Qué desastre..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh...[K] That's not how to do it...", french="Argh...[K] Ça ne s'est pas passé\ncomme prévu...", german=" Uff...[K] So klappt das nicht...", italian=" Uff...[K] È andata male...", spanish="Ay...[K] Así no vamos a ninguna\nparte..."})
  else
  SkySceneKit.say({english=" Ugh...[K] That wasn't so good...", french="Argh...[K] Ça ne s'est pas passé\ncomme prévu...", german=" Uff...[K] Das war nicht so gut...", italian="Uff...[K] Non è andata molto\nbene...", spanish=" Ay...[K] Esto no ha ido bien..."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D29P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Temporal Tower.ogg", true) end)
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
  SkySceneKit.say({english=" Urk![K] The going's not easy at all...", french=" Aïe![K] Ça ne va pas être facile...", german="Umpf![K] Das ist keine leichte\nGangart...", italian=" Eh![K] Non è per nulla facile...", spanish="¡Uf![K] Esto no va a resultar nada\nfácil..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk![K] This is a tough challenge...", french=" Aïe![K] Ça ne va pas être facile...", german=" Umpf![K] Das ist eine harte Nuss...", italian=" Eh![K] È una dura sfida...", spanish="¡Uf![K] Esto no va a resultar nada\nfácil..."})
  else
  SkySceneKit.say({english=" Urk![K] This is no easy task...", french=" Aïe![K] Ça ne va pas être facile...", german="Umpf![K] Das ist keine einfache\nAufgabe...", italian=" Eh![K] Non è un compito facile...", spanish="¡Uf![K] Esto no va a resultar nada\nfácil..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But we don't have far to go.[K]\nLet's keep pressing onward, [hero]!", french="Mais on se rapproche du but.[K]\nCourage, [hero]!", german="Aber wir haben es nicht mehr\nweit.[K] Kämpfen wir uns durch, [hero]!", italian="Ma ci siamo quasi.[K]\nMettiamocela tutta, [hero]!", spanish="Pero ya no queda mucho.[K]\n¡Hay que seguir adelante, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But we're almost there.[K]\nLet's keep going, [hero]!", french="Mais on se rapproche du but.[K]\nCourage, [hero]!", german="Aber wir sind fast da.[K]\nLass uns am Ball bleiben, [hero]!", italian="Ma ci siamo quasi.[K]\nMettiamocela tutta, [hero]!", spanish="Pero ya no queda mucho.[K]\n¡Hay que seguir adelante, [hero]!"})
  else
  SkySceneKit.say({english="But we're so close now.[K]\nLet's keep going, [hero]!", french="Mais on se rapproche du but.[K]\nCourage, [hero]!", german="Aber wir sind jetzt nah dran.[K]\nBleiben wir am Ball, [hero]!", italian="Ma ci siamo quasi.[K]\nMettiamocela tutta, [hero]!", spanish="Pero ya no queda mucho.[K]\n¡Hay que seguir adelante, [hero]!"})
  end
  -- message_Close
end
