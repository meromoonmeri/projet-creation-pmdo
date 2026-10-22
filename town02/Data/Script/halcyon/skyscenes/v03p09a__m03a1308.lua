-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V03P09A/m03a1308.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  -- back_SetGround(LEVEL_V03P09A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(156, 140, 1, false) end)
  -- back_SetEffect(5, 0) [transition couches décor NDS immédiate]
  -- back_SetBackEffect(2) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(60)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" At the center of such places...", french=" Au cœur de ces lieux...", german=" Im Zentrum solcher Orte...", italian=" Al centro di luoghi del genere...", spanish=" En el centro de esos lugares..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" At the center of such places...", french=" Au cœur de ces lieux...", german=" Im Zentrum solcher Orte...", italian=" Al centro di luoghi del genere...", spanish=" En el centro de esos lugares..."})
  else
  SkySceneKit.say({english=" At the center of such places...", french=" Au cœur de ces lieux...", german=" Im Zentrum solcher Orte...", italian=" Al centro di luoghi del genere...", spanish=" En el centro de esos lugares..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" is what's known as a Time Gear.", french="... se trouvent ce qu'on appelle\nles Rouages du Temps.", german="Dort ist ein sogenanntes Zahnrad\nder Zeit versteckt.", italian="... si trova un oggetto chiamato\nIngranaggio del Tempo.", spanish=" Hay un Engranaje del Tiempo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" is what's known as a Time Gear.", french="... se trouvent ce qu'on appelle\nles Rouages du Temps.", german="Dort ist ein sogenanntes Zahnrad\nder Zeit versteckt.", italian="... si trova un oggetto chiamato\nIngranaggio del Tempo.", spanish=" Hay un Engranaje del Tiempo."})
  else
  SkySceneKit.say({english=" is what's known as a Time Gear.", french="... se trouvent ce qu'on appelle\nles Rouages du Temps.", german="Dort ist ein sogenanntes Zahnrad\nder Zeit versteckt.", italian="... si trova un oggetto chiamato\nIngranaggio del Tempo.", spanish=" Hay un Engranaje del Tiempo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Time Gears serve a very\nimportant function.", french="Les Rouages du Temps jouent un\nrôle très important.", german="Zahnräder der Zeit erfüllen\neine sehr wichtige Funktion.", italian="Gli Ingranaggi del Tempo\nhanno una funzione molto importante.", spanish="Los Engranajes del Tiempo\ncumplen una función muy importante."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Time Gears serve a very\nimportant function.", french="Les Rouages du Temps jouent un\nrôle très important.", german="Zahnräder der Zeit erfüllen\neine sehr wichtige Funktion.", italian="Gli Ingranaggi del Tempo\nhanno una funzione molto importante.", spanish="Los Engranajes del Tiempo\ncumplen una función muy importante."})
  else
  SkySceneKit.say({english="Time Gears serve a very\nimportant function.", french="Les Rouages du Temps jouent un\nrôle très important.", german="Zahnräder der Zeit erfüllen\neine sehr wichtige Funktion.", italian="Gli Ingranaggi del Tempo\nhanno una funzione molto importante.", spanish="Los Engranajes del Tiempo\ncumplen una función muy importante."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Each one protects time and keeps\ntime flowing properly in its region.", french="Chacun d'eux protège le temps\net lui permet de s'écouler normalement dans\nla région où il se trouve.", german="Jedes Zahnrad schützt die Zeit\nin der jeweiligen Region und sorgt dafür, dass\nsie richtig fließt.", italian="Ognuno di loro protegge il tempo\ne lo fa scorrere correttamente nella regione\ncircostante.", spanish="Protegen el tiempo y permiten\nque siga fluyendo en cada región."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Each one protects time and keeps\ntime flowing properly in its region.", french="Chacun d'eux protège le temps\net lui permet de s'écouler normalement dans\nla région où il se trouve.", german="Jedes Zahnrad schützt die Zeit\nin der jeweiligen Region und sorgt dafür, dass\nsie richtig fließt.", italian="Ognuno di loro protegge il tempo\ne lo fa scorrere correttamente nella regione\ncircostante.", spanish="Protegen el tiempo y permiten\nque siga fluyendo en cada región."})
  else
  SkySceneKit.say({english="Each one protects time and keeps\ntime flowing properly in its region.", french="Chacun d'eux protège le temps\net lui permet de s'écouler normalement dans\nla région où il se trouve.", german="Jedes Zahnrad schützt die Zeit\nin der jeweiligen Region und sorgt dafür, dass\nsie richtig fließt.", italian="Ognuno di loro protegge il tempo\ne lo fa scorrere correttamente nella regione\ncircostante.", spanish="Protegen el tiempo y permiten\nque siga fluyendo en cada región."})
  end
  -- message_Close
  GAME:WaitFrames(30)
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
