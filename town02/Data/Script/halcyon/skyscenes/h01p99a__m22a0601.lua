-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99A/m22a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(23, 3) -- $SCENARIO_MAIN = scn[23,3] (ROM)
  -- back_SetGround(LEVEL_H01P99A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GROUND:MoveToPosition(hero, 320, 172, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 352, 192, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I wonder if [CS:N]Grovyle[CR]'s back...", french="Je me demande si [CS:N]Massko[CR] est\nrevenu...", german="Ich frage mich, ob [CS:N]Reptain[CR] schon\nzurück ist...", italian=" Chissà se [CS:N]Grovyle[CR] è tornato...", spanish="Me pregunto si [CS:N]Grovyle[CR] habrá\nvuelto..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Is [CS:N]Grovyle[CR] back, I wonder?", french="Je me demande si [CS:N]Massko[CR] est\nrevenu...", german="Ob [CS:N]Reptain[CR] zurück ist, würde ich\ngerne wissen.", italian=" Sarà tornato [CS:N]Grovyle[CR]?", spanish="Me pregunto si [CS:N]Grovyle[CR] habrá\nvuelto..."})
  else
  SkySceneKit.say({english=" I wonder if [CS:N]Grovyle[CR]'s back...", french="Je me demande si [CS:N]Massko[CR] est\nrevenu...", german="Ich frage mich, ob [CS:N]Reptain[CR]\nzurück ist...", italian=" Chissà se [CS:N]Grovyle[CR] è tornato...", spanish="Me pregunto si [CS:N]Grovyle[CR] habrá\nvuelto..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's go.", french=" Allons-y.", german=" Gehen wir.", italian=" Andiamo.", spanish=" Vamos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go.", french=" Allons-y.", german=" Gehen wir.", italian=" Andiamo.", spanish=" Vamos."})
  else
  SkySceneKit.say({english=" Let's go.", french=" Allons-y.", german=" Gehen wir.", italian=" Andiamo.", spanish=" Vamos."})
  end
  -- message_Close
  GROUND:MoveToPosition(hero, 304, 156, false, 2)
  GROUND:MoveToPosition(partner, 304, 156, false, 2)
  GROUND:MoveToPosition(hero, 276, 156, false, 2)
  -- Destroy() [neutre/état moteur]
  GROUND:MoveToPosition(partner, 276, 156, false, 2)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(20)
  GAME:FadeOut(false, 30)
end
