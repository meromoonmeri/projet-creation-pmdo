-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D16P11A/m15a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D16P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Crystal Cave.ogg", true) end)
  GROUND:MoveToPosition(hero, 316, 140, false, 2)
  GROUND:MoveToPosition(partner, 284, 140, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We'll find the path to [CS:N]Azelf[CR]'s\nlake this time!", french="On trouvera le chemin du lac\nde [CS:N]Créfadet[CR] cette fois-ci!", german="Diesmal finden wir den Weg zum\nSee von [CS:N]Tobutz[CR]!", italian="Sono sicuro che questa volta\ntroveremo il passaggio per il lago dove si\ntrova [CS:N]Azelf[CR].", spanish="¡Esta vez encontraremos\nel camino al lago de [CS:N]Azelf[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We'll find the path to [CS:N]Azelf[CR]'s\nlake this time!", french="On trouvera le chemin du lac\nde [CS:N]Créfadet[CR] cette fois-ci!", german="Diesmal finden wir den Weg zum\nSee von [CS:N]Tobutz[CR]!", italian="Sono sicuro che questa volta\nriusciremo a trovare il passaggio per il lago\ndove si trova [CS:N]Azelf[CR].", spanish="¡Esta vez encontraremos\nel camino al lago de [CS:N]Azelf[CR]!"})
  else
  SkySceneKit.say({english="We'll find the way to [CS:N]Azelf[CR]'s\nlake this time!", french="On trouvera le chemin du lac\nde [CS:N]Créfadet[CR] cette fois-ci!", german="Diesmal finden wir den Weg zum\nSee von [CS:N]Tobutz[CR]!", italian="Sono sicura che questa volta\nriusciremo a trovare il passaggio per il lago\ndove si trova [CS:N]Azelf[CR].", spanish="¡Esta vez encontraremos\nel camino al lago de [CS:N]Azelf[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's give it our best,\n[hero]!", french="Surpassons-nous,\n[hero]!", german="Geben wir unser Bestes,\n[hero]!", italian=" Diamoci dentro, [hero]!", spanish="¡Tenemos que darlo todo,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's do our best,\n[hero]!", french="Surpassons-nous,\n[hero]!", german="Lass uns unser Bestes geben,\n[hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish="¡Hagamos todo lo que podamos,\n[hero]!"})
  else
  SkySceneKit.say({english=" Let's try our best, [hero]!", french="Surpassons-nous,\n[hero]!", german="Strengen wir uns an,\n[hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish="¡Debemos esforzarnos mucho,\n[hero]!"})
  end
  -- message_Close
  GROUND:MoveToPosition(partner, 284, 76, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 316, 76, false, 2)
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  -- main_EnterDungeon(24, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
end
