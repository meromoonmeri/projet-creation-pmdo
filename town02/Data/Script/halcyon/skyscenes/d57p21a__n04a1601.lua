-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D57P21A/n04a1601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=43, sub=7} -- $SCENARIO_SIDE = scn[43,7] (ROM)
  -- back_SetGround(LEVEL_D57P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Spring Cave Depths.ogg", true) end)
  GROUND:MoveToPosition(hero, 228, 284, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I've come pretty far...", french=" J'ai beaucoup progressé...", german=" Ich bin recht weit gekommen...", italian=" Ho fatto parecchia strada...", spanish=" He avanzado bastante..."})
  -- message_Close
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:N]Haunter[CR] must be hiding\njust ahead!", french="[CS:N]Spectrum[CR] doit se cacher\nun peu plus loin!", german="Noch etwas weiter! [CS:N]Alpollo[CR]\nwird sich da irgendwo versteckt haben!", italian="[CS:N]Haunter[CR] deve essere\nnascosto poco più avanti!", spanish="[CS:N]Haunter[CR] debe de andar\nescondiéndose justo ahí delante."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="This time I will most definitely\ncatch him!", french="Cette fois je vais l'attraper\npour de bon!", german="Dieses Mal werde ich ihn ganz\nsicher kriegen!", italian="Questa volta lo catturerò\nsicuramente!", spanish=" ¡Esta vez pienso atraparlo!"})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
end
