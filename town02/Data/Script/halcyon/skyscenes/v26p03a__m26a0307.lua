-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V26P03A/m26a0307.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Restored.ogg", true) end)
  -- back_SetGround(LEVEL_V26P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's [CS:P]Temporal Tower[CR].[K] It looks\npretty beaten up...", french="Et voilà la [CS:P]Tour du Temps[CR].[K]\nElle est en très mauvais état...", german="Das ist der [CS:P]Zeitturm[CR].[K] Er sieht\nganz schön ramponiert aus...", italian="La [CS:P]Torre del Tempo[CR]...[K]\nè piuttosto malconcia...", spanish="La [CS:P]Torre del Tiempo[CR]...[K] se ve\nmuy dañada."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's [CS:P]Temporal Tower[CR].[K] It seems\nto be badly damaged...", french="Et voilà la [CS:P]Tour du Temps[CR].[K]\nElle est en très mauvais état...", german="Das ist der [CS:P]Zeitturm[CR].[K] Er sieht\nziemlich beschädigt aus...", italian="La [CS:P]Torre del Tempo[CR]...[K]\nè molto danneggiata...", spanish="La [CS:P]Torre del Tiempo[CR]...[K] se ve\nmuy dañada."})
  else
  SkySceneKit.say({english="It's [CS:P]Temporal Tower[CR].[K]\nIt's wrecked all over...", french="Et voilà la [CS:P]Tour du Temps[CR].[K]\nElle est en très mauvais état...", german="Das ist der [CS:P]Zeitturm[CR].[K] Er sieht\nziemlich ruiniert aus...", italian="La [CS:P]Torre del Tempo[CR]...[K]\nè mezza distrutta...", spanish="La [CS:P]Torre del Tiempo[CR]...[K] se ve\nmuy dañada."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But...[K]it's still standing!", french=" Mais...[K] elle tient toujours debout!", german=" Aber[K] er steht noch!", italian=" Ma...[K] è ancora in piedi!", spanish=" Pero...[K] ¡aún sigue en pie!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But...[K]it's still standing!", french=" Mais...[K] elle tient toujours debout!", german=" Aber[K] er steht noch!", italian=" Ma...[K] è ancora in piedi!", spanish=" Pero...[K] ¡aún sigue en pie!"})
  else
  SkySceneKit.say({english=" But...[K]it's still standing!", french=" Mais...[K] elle tient toujours debout!", german=" Aber[K] er steht noch!", italian=" Ma...[K] è ancora in piedi!", spanish=" Pero...[K] ¡aún sigue en pie!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:P]Temporal Tower[CR] didn't\nfall apart...", french="La [CS:P]Tour du Temps[CR] ne s'est pas\neffondrée...", german="Der [CS:P]Zeitturm[CR] ist nicht\neingestürzt...", italian="La [CS:P]Torre del Tempo[CR] non è\ncrollata...", spanish=" No se ha derrumbado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:P]Temporal Tower[CR] didn't\ncollapse...", french="La [CS:P]Tour du Temps[CR] ne s'est pas\neffondrée...", german="Der [CS:P]Zeitturm[CR] ist nicht\nkollabiert...", italian="La [CS:P]Torre del Tempo[CR] non è\ncrollata...", spanish=" No se ha derrumbado."})
  else
  SkySceneKit.say({english="[CS:P]Temporal Tower[CR] didn't\nbreak apart...", french="La [CS:P]Tour du Temps[CR] ne s'est pas\neffondrée...", german="Der [CS:P]Zeitturm[CR] ist nicht\nauseinandergebrochen...", italian="La [CS:P]Torre del Tempo[CR] non è\ncrollata...", spanish=" No se ha derrumbado."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It survived!", french=" Elle a résisté!", german=" Er hat es überstanden!", italian=" Ha resistito!", spanish=" ¡Sigue aquí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It survived!", french=" Elle a résisté!", german=" Er hat es überstanden!", italian=" Ha resistito!", spanish=" ¡Sigue aquí!"})
  else
  SkySceneKit.say({english=" It survived!", french=" Elle a résisté!", german=" Er hat es überstanden!", italian=" Ha resistito!", spanish=" ¡Sigue aquí!"})
  end
  -- message_Close
  GAME:FadeOut(true, 60) -- screen_WhiteOut
  GAME:WaitFrames(30)
end
