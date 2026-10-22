-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m03a0702.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hurry! We have to rescue\n[CS:N]Azurill[CR]!", french="Dépêche-toi! Nous devons\nsauver [CS:N]Azurill[CR]!", german="Beeilung! Wir müssen [CS:N]Azurill[CR]\nretten!", italian="Presto! Dobbiamo salvare\n[CS:N]Azurill[CR]!", spanish="¡Rápido! ¡Tenemos que rescatar\na [CS:N]Azurill[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hurry! We have to rescue\n[CS:N]Azurill[CR]!", french="Dépêche-toi! Nous devons\nsauver [CS:N]Azurill[CR]!", german="Beeilung! Wir müssen [CS:N]Azurill[CR]\nretten!", italian="Presto! Dobbiamo salvare\n[CS:N]Azurill[CR]!", spanish="¡Rápido! ¡Tenemos que rescatar\na [CS:N]Azurill[CR]!"})
  else
  SkySceneKit.say({english="Hurry! We have to rescue\n[CS:N]Azurill[CR]!", french="Dépêche-toi! Nous devons\nsauver [CS:N]Azurill[CR]!", german="Beeilung! Wir müssen [CS:N]Azurill[CR]\nretten!", italian="Presto! Dobbiamo salvare\n[CS:N]Azurill[CR]!", spanish="¡Rápido! ¡Tenemos que rescatar\na [CS:N]Azurill[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Quick! Off to [CS:P]Mt. Bristle[CR]!", french=" Vite! Au [CS:P]Mt Hérissé[CR]!", german=" Schnell! Auf zum [CS:P]Stachelberg[CR]!", italian="Veloce! Dobbiamo raggiungere il\n[CS:P]Monte Crespo[CR]!", spanish=" ¡Vamos al [CS:P]Monte Árido[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hurry! Off to [CS:P]Mt. Bristle[CR]!", french=" Vite! Au [CS:P]Mt Hérissé[CR]!", german=" Beeilung! Auf zum [CS:P]Stachelberg[CR]!", italian="Veloce! Dobbiamo raggiungere il\n[CS:P]Monte Crespo[CR]!", spanish=" ¡Vamos al [CS:P]Monte Árido[CR]!"})
  else
  SkySceneKit.say({english=" Hurry! Off to [CS:P]Mt. Bristle[CR]!", french=" Vite! Au [CS:P]Mt Hérissé[CR]!", german=" Beeilung! Auf zum [CS:P]Stachelberg[CR]!", italian="Veloce! Dobbiamo raggiungere il\n[CS:P]Monte Crespo[CR]!", spanish=" ¡Vamos al [CS:P]Monte Árido[CR]!"})
  end
  -- message_Close
end
