-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D31P11A/s01p0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh...[K] We messed that up.", french=" Argh...[K] on a raté notre coup.", german=" Uff...[K] Wir haben es verpatzt.", italian=" Ugh...[K] Non ce l'abbiamo fatta.", spanish=" Uf...[K] Menudo fracaso."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh...[K] That didn't work.", french=" Argh...[K] on a raté notre coup.", german=" Uff...[K] Das war wohl nichts.", italian=" Ugh...[K] Non ce l'abbiamo fatta.", spanish="Uf...[K] No fue muy bien que\ndigamos."})
  else
  SkySceneKit.say({english=" Ugh...[K] That didn't work.", french=" Argh...[K] on a raté notre coup.", german=" Uff...[K] Das war wohl nichts.", italian=" Ugh...[K] Non ce l'abbiamo fatta.", spanish=" Uf...[K] Eso no ha funcionado."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D31P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Mystifying Forest.ogg", true) end)
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
  SkySceneKit.say({english=" Urk![K] We were careless.", french="Pff...[K] On a fait preuve\nde négligence, je crois.", german=" Argh![K] Wir waren zu sorglos.", italian="Urk![K] Non abbiamo fatto\nabbastanza attenzione.", spanish="¡Vaya![K] Nos hemos despistado\nun poco."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk![K] That was careless of us.", french="Pff...[K] On a fait preuve\nde négligence, je crois.", german="Umpf![K] Das war unsere\nAchtlosigkeit.", italian="Urk![K] Non abbiamo fatto\nabbastanza attenzione.", spanish=" ¡Vaya![K] Nos hemos descuidado."})
  else
  SkySceneKit.say({english="Urk![K] We need to be more\ncautious.", french="Pff...[K] On a fait preuve\nde négligence, je crois.", german="Umpf![K] Wir müssen vorsichtiger\nsein.", italian="Urk![K] Non abbiamo fatto\nabbastanza attenzione.", spanish="Hum...[K] Habrá que ir con más\ncuidado."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We're so close, though...[K] Let's go\nfor it and graduate, [hero]!", french="On y était presque...[K] Il faut\ny retourner pour réussir l'examen,\n[hero]!", german="Aber wir sind so nah dran...[K]\nProbieren wir es noch mal! Lass uns den\nAbschluss machen, [hero]!", italian="Però c'eravamo quasi...[K] Forza,\nriproviamoci e superiamo l'esame,\n[hero]!", spanish="Aunque nos ha faltado poco...[K]\n¡Tenemos que conseguirlo, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We're so close, though...[K] We can\ndo this and graduate, [hero]!", french="On y était presque...[K] Il faut\ny retourner pour réussir l'examen,\n[hero]!", german="Aber wir sind so nah dran...[K]\nWir können es schaffen und die Prüfung\nbestehen, [hero]!", italian="Però c'eravamo quasi...[K] Forza,\nriproviamoci e superiamo l'esame,\n[hero]!", spanish="Aunque nos ha faltado poco...[K]\n¡Hay que conseguirlo, [hero]!"})
  else
  SkySceneKit.say({english="We're so close, though...[K] Let's go\nfor it and graduate, [hero]!", french="On y était presque...[K] Il faut\ny retourner pour réussir l'examen,\n[hero]!", german="Aber wir sind so nah dran...[K]\nProbieren wir es noch mal! Lass uns den\nAbschluss machen, [hero]!", italian="Però c'eravamo quasi...[K] Forza,\nriproviamoci e superiamo l'esame,\n[hero]!", spanish="Aunque hemos estado a punto de\nlograrlo...[K]\n¡Hay que darlo todo, [hero]!"})
  end
  -- message_Close
end
