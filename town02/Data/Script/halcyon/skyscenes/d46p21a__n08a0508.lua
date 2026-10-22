-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D46P21A/n08a0508.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=47, sub=2} -- $SCENARIO_SIDE = scn[47,2] (ROM)
  -- back_SetGround(LEVEL_D46P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_BARREN_VALLEY non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 228, 292, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I've come a long way.", french=" Ça fait un moment que j'avance.", german=" Ich bin schon weit gekommen.", italian=" Ho fatto parecchia strada.", spanish=" He recorrido un buen trecho."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Just a little further.", french=" Encore un petit effort.", german=" Nur ein bisschen weiter.", italian=" Manca poco.", spanish=" Venga, solo un poquito más."})
  -- message_Close
end
