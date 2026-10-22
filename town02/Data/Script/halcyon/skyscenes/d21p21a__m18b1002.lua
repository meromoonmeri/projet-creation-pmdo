-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D21P21A/m18b1002.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh...[K] We blew it...", french=" Argh...[K] On s'est pris une raclée...", german=" Ugh...[K] Was für ein Reinfall...", italian=" Uh...[K] È andata male...", spanish=" Ay...[K] ¡Qué mal ha ido!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh...[K] We failed...", french=" Argh...[K] On s'est pris une raclée...", german=" Ugh...[K] Wir haben versagt...", italian=" Uh...[K] Abbiamo fallito...", spanish=" Ay...[K] Hemos fracasado..."})
  else
  SkySceneKit.say({english=" Ugh...[K] We couldn't do it...", french=" Argh...[K] On s'est pris une raclée...", german=" Ugh...[K] Das lief nicht gut...", italian=" Uh...[K] Non ce l'abbiamo fatta...", spanish=" Ay...[K] No hemos podido..."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D21P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitLockLives
  GAME:FadeIn(30)
  -- GAP: BGM BGM_SEALED_RUIN_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
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
  SkySceneKit.say({english=" Ugh... It's tough going, but...", french="Argh... Ce n'est pas une mince\naffaire...", german=" Ugh... Es ist hart, aber...", italian=" Uh... È tosta, ma...", spanish=" Ay... Esto es muy duro, pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh... It's not easy, but...", french="Argh... Ce n'est pas une mince\naffaire...", german=" Ugh... Es ist nicht leicht, aber...", italian=" Uh... Non è facile, ma...", spanish=" Ay... Esto no es fácil, pero..."})
  else
  SkySceneKit.say({english=" Ugh... It's not easy, but...", french="Argh... Ce n'est pas une mince\naffaire...", german=" Ugh... Es ist nicht leicht, aber...", italian=" Uh... Non è facile, ma...", spanish=" Ay... Esto no es fácil, pero..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But there's no giving up![K]\nLet's keep at it, [hero]!", french="Mais hors de question qu'on\nbaisse les bras![K] Courage, [hero]!", german="Wir dürfen nicht aufgeben![K]\nBleiben wir dran, [hero]!", italian="Ma non dobbiamo mollare![K]\nCoraggio, [hero]!", spanish="¡No podemos rendirnos![K]\n¡Sigamos adelante, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But we can't give up![K] Let's keep\nat it, [hero]!", french="Mais hors de question qu'on\nbaisse les bras![K] Courage, [hero]!", german="Wir dürfen nicht aufgeben![K]\nBleiben wir dran, [hero]!", italian="Ma non dobbiamo mollare![K]\nCoraggio, [hero]!", spanish="¡No podemos rendirnos![K]\n¡Sigamos adelante, [hero]!"})
  else
  SkySceneKit.say({english="But we can't give up![K] Let's keep\nat it, [hero]!", french="Mais hors de question qu'on\nbaisse les bras![K] Courage, [hero]!", german="Wir dürfen nicht aufgeben![K]\nBleiben wir dran, [hero]!", italian="Ma non dobbiamo mollare![K]\nCoraggio, [hero]!", spanish="¡No podemos rendirnos![K]\n¡Sigamos adelante, [hero]!"})
  end
  -- message_Close
end
