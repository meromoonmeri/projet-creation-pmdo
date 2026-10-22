-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D12P21A/m12a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- GAP: BGM BGM_FAR_AMP_PLAINS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkyProg.set(13, 3) -- $SCENARIO_MAIN = scn[13,3] (ROM)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[hero], I think we're going\nto reach the deepest part soon.", french="[hero], je crois qu'on se\nrapproche du fond.", german="[hero], ich glaube, wir\nsind bald am tiefsten Punkt angelangt.", italian="[hero], penso che non\nmanchi molto ormai.", spanish="[hero], creo que vamos a\nllegar pronto a la parte más profunda."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We must be getting closer to the\ndeepest part, [hero].", french="[hero], je crois qu'on se\nrapproche du fond.", german="Wir müssten bald am tiefsten\nPunkt angelangt sein, [hero].", italian="Dovremmo quasi esserci,\n[hero].", spanish="[hero], debemos de estar\nacercándonos ya a la parte más profunda."})
  else
  SkySceneKit.say({english="We must be getting closer to the\ndeepest part, [hero].", french="[hero], je crois qu'on se\nrapproche du fond.", german="Wir müssten bald am tiefsten\nPunkt angelangt sein, [hero].", italian="Dovremmo quasi esserci,\n[hero].", spanish="[hero], debemos de estar\nacercándonos ya a la parte más profunda."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I don't know what to expect, so\nwe'd better go really carefully.", french="Prudence! On ne sait pas sur\nquoi on va tomber.", german="Ich weiß nicht, was uns\nerwartet, also sollten wir besser sehr\nvorsichtig sein.", italian="Non so davvero cosa ci aspetti.\nMi raccomando, prudenza!", spanish="No sé lo que podemos\nencontrarnos, así que habrá que ir\ncon cuidado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I don't know what awaits us.\nWe'd better go really cautiously.", french="Prudence! On ne sait pas sur\nquoi on va tomber.", german="Ich weiß nicht, was uns\nerwartet. Seien wir am besten sehr vorsichtig.", italian="Non so davvero cosa ci aspetti.\nCerchiamo di essere prudenti.", spanish="No sé lo que podemos\nencontrarnos, así que habrá que ir\ncon cuidado."})
  else
  SkySceneKit.say({english="I don't know what to expect, so\nwe'd better go really carefully.", french="Prudence! On ne sait pas sur\nquoi on va tomber.", german="Ich weiß nicht, was uns\nerwartet, also sollten wir besser sehr\nvorsichtig sein.", italian="Non so davvero cosa ci aspetti.\nCerchiamo di agire con prudenza.", spanish="No sé lo que podemos\nencontrarnos, así que habrá que ir\ncon cuidado."})
  end
  -- message_Close
  GROUND:MoveToPosition(hero, 228, 28, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(partner, 228, 28, false, 2)
  GAME:WaitFrames(20)
  pcall(function() SOUND:FadeOutBGM(180) end)
  GAME:FadeOut(false, 60)
end
