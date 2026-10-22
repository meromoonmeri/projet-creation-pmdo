-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D13P11A/m13a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D13P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Northern Desert.ogg", true) end)
  GROUND:MoveToPosition(hero, 248, 268, false, 2)
  GROUND:MoveToPosition(partner, 216, 268, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's find that Time Gear\nthis time!", french="Trouvons le Rouage du Temps\ncette fois-ci!", german="Diesmal finden wir das Zahnrad\nder Zeit!", italian="Questa volta dobbiamo trovare\nl'Ingranaggio del Tempo!", spanish="¡Esta vez tenemos que\nencontrarlo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's find the Time Gear\nthis time!", french="Trouvons le Rouage du Temps\ncette fois-ci!", german="Diesmal finden wir das Zahnrad\nder Zeit!", italian="Questa volta dobbiamo trovare\nl'Ingranaggio del Tempo!", spanish="¡Esta vez tenemos que\nencontrarlo!"})
  else
  SkySceneKit.say({english="Let's find that Time Gear\nthis time!", french="Trouvons le Rouage du Temps\ncette fois-ci!", german="Diesmal finden wir das Zahnrad\nder Zeit!", italian="Questa volta dobbiamo trovare\nl'Ingranaggio del Tempo!", spanish="¡Esta vez tenemos que\nencontrarlo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's give it our best,\n[hero]!", french="Faisons de notre mieux,\n[hero]!", german="Geben wir unser Bestes,\n[hero]!", italian="Diamoci dentro,\n[hero]!", spanish="¡Hay que esforzarse todo\nlo posible, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's do our best, [hero]!", french="Faisons de notre mieux,\n[hero]!", german="Lass uns unser Bestes geben,\n[hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish="¡Hay que esforzarse todo\nlo posible, [hero]!"})
  else
  SkySceneKit.say({english=" Let's try our best, [hero]!", french="Faisons de notre mieux,\n[hero]!", german="Strengen wir uns an,\n[hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish="¡Hay que esforzarse todo\nlo posible, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 228, 164, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(partner, 228, 164, false, 2)
  GAME:WaitFrames(20)
  GAME:FadeOut(false, 30)
  -- main_EnterDungeon(20, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
end
