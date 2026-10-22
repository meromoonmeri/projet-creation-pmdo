-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D11P11A/m12a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D11P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Amp Plains.ogg", true) end)
  GROUND:MoveToPosition(partner, 212, 196, false, 2)
  GROUND:MoveToPosition(hero, 244, 196, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's make it through this time!", french=" On va y arriver cette fois-ci!", german=" Diesmal schaffen wir es!", italian=" Questa volta ce la faremo!", spanish=" ¡Esta vez vamos a conseguirlo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's make it through this time!", french=" On va y arriver cette fois-ci!", german=" Diesmal schaffen wir es!", italian=" Questa volta ce la faremo!", spanish=" ¡Esta vez vamos a conseguirlo!"})
  else
  SkySceneKit.say({english=" Let's make it through this time!", french=" On va y arriver cette fois-ci!", german=" Diesmal schaffen wir es!", italian=" Questa volta ce la faremo!", spanish=" ¡Esta vez vamos a conseguirlo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[hero], let's give it our\nbest!", french="Faisons de notre mieux,\n[hero]!", german="[hero], geben wir unser\nBestes!", italian=" Diamoci dentro, [hero]! ", spanish="[hero], ¡esforcémonos al\nmáximo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [hero], let's do our best!", french="Faisons de notre mieux,\n[hero]!", german="[hero], lass uns unser\nBestes geben!", italian="Mettiamocela tutta,\n[hero]!", spanish="[hero], ¡esforcémonos al\nmáximo!"})
  else
  SkySceneKit.say({english=" [hero], let's try our best!", french="Faisons de notre mieux,\n[hero]!", german="[hero], lass uns unser\nBestes geben!", italian="Mettiamocela tutta,\n[hero]!", spanish="[hero], ¡esforcémonos al\nmáximo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 212, 132, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 244, 132, false, 2)
  GAME:WaitFrames(20)
  -- main_EnterDungeon(17, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
end
