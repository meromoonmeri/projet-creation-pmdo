-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D21P21A/m18b0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- GAP: BGM BGM_SEALED_RUIN_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkyProg.set(19, 3) -- $SCENARIO_MAIN = scn[19,3] (ROM)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We've got to be getting close to\nthe bottom now, [hero].", french="On doit approcher du fond,\n[hero].", german="Wir müssten jetzt fast da sein,\n[hero].", italian="Dovremmo essere quasi in fondo\normai, [hero].", spanish="Ya debemos de estar llegando\nal final, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We must be getting close to the\nbottom now, [hero].", french="On doit approcher du fond,\n[hero].", german="Wir müssten jetzt fast da sein,\n[hero].", italian="Dovremmo essere quasi in fondo\normai, [hero].", spanish="Ya debemos de estar llegando\nal final, [hero]."})
  else
  SkySceneKit.say({english="We must be getting close to the\nbottom now, [hero].", french="On doit approcher du fond,\n[hero].", german="Wir müssten jetzt fast da sein,\n[hero].", italian="Dovremmo essere quasi in fondo\normai, [hero].", spanish="Ya debemos de estar llegando\nal final, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We've got to catch up to\n[CS:N]Grovyle[CR] soon.", french="Il faut rattraper [CS:N]Massko[CR]\nau plus vite.", german="Wir müssten [CS:N]Reptain[CR] bald\neinholen.", italian="Dobbiamo raggiungere [CS:N]Grovyle[CR]\nal più presto.", spanish=" Pronto alcanzaremos a [CS:N]Grovyle[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to catch up to [CS:N]Grovyle[CR]\nsoon.", french="Il faut rattraper [CS:N]Massko[CR]\nau plus vite.", german="Wir müssten [CS:N]Reptain[CR] bald\neinholen.", italian="Dobbiamo raggiungere in fretta\n[CS:N]Grovyle[CR].", spanish=" Pronto alcanzaremos a [CS:N]Grovyle[CR]."})
  else
  SkySceneKit.say({english="We have to catch up to [CS:N]Grovyle[CR]\nsoon.", french="Il faut rattraper [CS:N]Massko[CR]\nau plus vite.", german="Wir müssten [CS:N]Reptain[CR] bald\neinholen.", italian="Dobbiamo raggiungere in fretta\n[CS:N]Grovyle[CR].", spanish=" Pronto alcanzaremos a [CS:N]Grovyle[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's keep it up!", french=" Courage!", german=" Halten wir uns ran!", italian=" Diamoci dentro!", spanish=" ¡No podemos desfallecer!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's keep it up!", french=" Courage!", german=" Halten wir uns ran!", italian=" Diamoci dentro!", spanish=" ¡No podemos desfallecer!"})
  else
  SkySceneKit.say({english=" Let's keep it up!", french=" Courage!", german=" Halten wir uns ran!", italian=" Diamoci dentro!", spanish=" ¡No podemos desfallecer!"})
  end
  -- message_Close
  GROUND:MoveToPosition(hero, 228, 60, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(partner, 228, 60, false, 2)
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(180) end)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(180)
end
