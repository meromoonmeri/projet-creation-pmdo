-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/c00a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We should get some sleep too.", french=" On devrait dormir un peu.", german=" Wir sollten auch etwas schlafen.", italian="Dovremmo andare a\ndormire.", spanish=" Será mejor que nos durmamos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We should get some sleep too.", french=" On devrait dormir un peu.", german=" Wir sollten auch etwas schlafen.", italian="Dovremmo andare a\ndormire.", spanish=" Será mejor que descansemos."})
  else
  SkySceneKit.say({english=" We should get some sleep too.", french=" On devrait dormir un peu.", german=" Wir sollten auch etwas schlafen.", italian="Dovremmo andare a\ndormire.", spanish=" Será mejor que nos durmamos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's make tomorrow another\ngood day, [hero]!", french="Partons du bon pied demain\nmatin, [hero]!", german="Machen wir aus dem morgigen\nTag wieder einen guten Tag, [hero]!", italian="Domani dobbiamo mettercela\ntutta, [hero]!", spanish="¡Hay que recuperar fuerzas\npara mañana, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's make tomorrow another\ngood day, [hero]!", french="Partons du bon pied demain\nmatin, [hero]!", german="Machen wir aus dem morgigen\nTag wieder einen guten Tag, [hero]!", italian="Domani dobbiamo mettercela\ntutta, [hero]!", spanish="¡Hay que recuperar fuerzas\npara mañana, [hero]!"})
  else
  SkySceneKit.say({english="Let's make tomorrow another\ngood day, [hero]!", french="Partons du bon pied demain\nmatin, [hero]!", german="Machen wir aus dem morgigen\nTag wieder einen guten Tag, [hero]!", italian="Domani dobbiamo mettercela\ntutta, [hero]!", spanish="¡Hay que recuperar fuerzas\npara mañana, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right, good night.", french=" Allez, bonne nuit.", german=" In Ordnung, gute Nacht.", italian=" Buonanotte.", spanish=" Hala, buenas noches."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK, good night.", french=" Allez, bonne nuit.", german=" Okay, gute Nacht.", italian=" Ok, buonanotte.", spanish=" Venga, buenas noches."})
  else
  SkySceneKit.say({english=" OK, good night.", french=" Allez, bonne nuit.", german=" Okay, gute Nacht.", italian=" Buonanotte.", spanish=" Vale, buenas noches."})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
end
