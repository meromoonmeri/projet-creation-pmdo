-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D12P21A/m12a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh, we blew that attempt...", french=" Argh, quelle défaite...", german=" Ugh, das war ein Reinfall...", italian=" Ugh, che batosta...", spanish=" ¡Ay! No lo hemos conseguido..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh, that ended badly...", french=" Argh, quelle défaite...", german=" Ugh, das ging nicht gut aus...", italian=" Ohi, non è andata troppo bene...", spanish=" ¡Ay! Esto no ha ido bien..."})
  else
  SkySceneKit.say({english=" Ugh, that wasn't so good...", french=" Argh, quelle défaite...", german=" Ugh, das lief nicht gut...", italian=" Ohi, non è andata troppo bene...", spanish=" ¡Ay! Esto no ha ido muy bien..."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D12P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(8) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_FAR_AMP_PLAINS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
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
  SkySceneKit.say({english=" This is tougher than I thought!", french="C'est plus dur que je ne le\npensais!", german=" Das ist schwerer, als ich dachte!", italian="È più tosta di quel che\npensassi...", spanish="¡Esto es más difícil de lo que\nesperaba!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" This is harder than expected...", french="C'est plus dur que je ne le\npensais!", german=" Das ist schwerer als erwartet...", italian="È più difficile di quel che\npensassi...", spanish="¡Esto es más difícil de lo que\nesperaba!"})
  else
  SkySceneKit.say({english=" This won't be easy...", french="C'est plus dur que je ne le\npensais!", german=" Das wird nicht leicht...", italian=" Non sarà facile...", spanish=" ¡Esto no va a ser fácil!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But we're almost there.\nLet's keep at it!", french="Mais on y est presque! Il faut\ntenir bon!", german="Aber wir sind fast da.\nGeben wir nicht auf!", italian="Ma ci siamo quasi! Diamoci\ndentro!", spanish="Pero ya casi estamos.\n¡Hay que seguir!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But we were nearly there.\nLet's keep at it!", french="Mais on y est presque! Il faut\ntenir bon!", german="Aber wir waren fast da.\nGeben wir nicht auf!", italian="Ma non manca molto ormai.\nDiamo del nostro meglio!", spanish="Pero ya casi estamos.\n¡Hay que seguir!"})
  else
  SkySceneKit.say({english="But we're almost there.\nLet's keep at it!", french="Mais on y est presque! Il faut\ntenir bon!", german="Aber wir sind fast da.\nGeben wir nicht auf!", italian="Ma non manca molto ormai.\nDiamo del nostro meglio!", spanish="Pero ya casi estamos.\n¡Hay que seguir!"})
  end
  -- message_Close
end
