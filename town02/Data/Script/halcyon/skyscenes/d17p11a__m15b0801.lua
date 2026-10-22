-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D17P11A/m15b0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D17P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Crystal Crossing.ogg", true) end)
  GROUND:MoveToPosition(hero, 320, 276, false, 2)
  GROUND:MoveToPosition(partner, 280, 276, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We don't have far to go now,\n[hero]!", french=" On y est presque, [hero]!", german="Es ist jetzt nicht mehr weit,\n[hero]!", italian=" Manca poco, [hero]!", spanish="¡Ya no queda mucho,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It can't be far to go now,\n[hero]!", french=" On y est presque, [hero]!", german="Es kann jetzt nicht mehr weit\nsein, [hero]!", italian=" Manca poco, [hero]!", spanish="¡Ya no puede estar lejos,\n[hero]!"})
  else
  SkySceneKit.say({english="We must be getting close,\n[hero]!", french=" On y est presque, [hero]!", german="Wir sind bestimmt schon in\nder Nähe, [hero]!", italian=" Manca poco, [hero]!", spanish="¡Ya no queda mucho,\n[hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's keep at it!", french=" Tiens bon!", german=" Nicht schlappmachen!", italian=" Teniamo alta la guardia!", spanish=" ¡Sigamos adelante!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's keep at it!", french=" Tiens bon!", german=" Nicht schlappmachen!", italian=" Teniamo alta la guardia!", spanish=" ¡Sigamos adelante!"})
  else
  SkySceneKit.say({english=" Let's keep our spirits up!", french=" Tiens bon!", german=" Nicht aufgeben!", italian=" Teniamo alta la guardia!", spanish=" ¡Sigamos adelante!"})
  end
  -- message_Close
  GROUND:MoveToPosition(hero, 300, 212, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(partner, 300, 212, false, 2)
  GAME:WaitFrames(20)
  -- main_EnterDungeon(25, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
end
