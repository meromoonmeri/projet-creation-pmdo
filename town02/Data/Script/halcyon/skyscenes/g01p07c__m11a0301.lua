-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m11a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  SkyProg.set(12, 2) -- $SCENARIO_MAIN = scn[12,2] (ROM)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We should get some sleep too.", french=" Allons dormir, nous aussi.", german=" Wir sollten auch etwas schlafen.", italian="Dovremmo farci una\nbella dormita.", spanish=" Deberíamos dormir un poco."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's get some sleep too.", french=" Allons dormir, nous aussi.", german=" Lass uns auch etwas schlafen.", italian="Dovremmo andare a\ndormire.", spanish=" Deberíamos dormir un poco."})
  else
  SkySceneKit.say({english=" Let's get some sleep too.", french=" Allons dormir, nous aussi.", german=" Lass uns auch etwas schlafen.", italian="Dovremmo andare a\ndormire.", spanish=" Deberíamos dormir un poco."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's go hard at it again\ntomorrow, [hero]!", french="On se remettra au travail\ndemain, [hero]!", german="Packen wir es morgen wieder\nan, [hero]!", italian="Diamoci dentro anche domani.\nGiusto, [hero]?", spanish="Bueno, pues mañana más,\n¿verdad, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's go hard at it again\ntomorrow, [hero]!", french="On se remettra au travail\ndemain, [hero]!", german="Packen wir es morgen wieder\nan, [hero]!", italian="Dobbiamo fare del nostro meglio\nanche domani, [hero]!", spanish="Mañana tenemos que levantarnos\nfrescos para seguir mejorando, [hero]."})
  else
  SkySceneKit.say({english="Let's go hard at it again\ntomorrow, [hero]!", french="On se remettra au travail\ndemain, [hero]!", german="Packen wir es morgen wieder\nan, [hero]!", italian="Dobbiamo fare del nostro meglio\nanche domani, [hero]!", spanish="¡Mañana será otro día! Nos\nesforzaremos mucho, ¿verdad, [hero]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right, night.", french=" Allez, bonne nuit.", german=" In Ordnung. Gute Nacht!", italian=" Ok, 'notte!", spanish=" Muy bien, a dormir."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK, good night.", french=" Allez, bonne nuit.", german=" Okay, gute Nacht.", italian=" Buonanotte.", spanish="Muy bien, a dormir.\nBuenas noches."})
  else
  SkySceneKit.say({english=" OK, good night.", french=" Allez, bonne nuit.", german=" Okay, gute Nacht.", italian=" Buonanotte.", spanish="Muy bien, a dormir.\nBuenas noches."})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(2) -- join WaitBgm
end
