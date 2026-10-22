-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D42P42A/m99a0141.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(127, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D42P42A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(hero, 252, 204, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 276, 220, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 228, 220, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 252, 236, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(7)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]There appears to be no one here.", french="[CN]Il n'y a personne ici.", german="[CN]Es scheint niemand hier zu sein.", italian="[CN]Sembra che qui non ci sia nessuno.", spanish="[CN]Parece que aquí no hay nadie."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]It's impossible to go any farther.[K]\n[CN]Let's go back to Treasure Town.", french="[CN]Impossible d'aller plus loin.[K]\n[CN]Regagnons Bourg-Trésor.", german="[CN]Es ist unmöglich weiterzugehen.[K]\n[CN]Gehen wir zurück nach Schatzstadt.", italian="[CN]È impossibile proseguire.[K]\n[CN]Torniamo a Borgo Tesoro.", spanish="[CN]Es imposible ir más lejos.[K]\n[CN]Volvamos a Aldea Tesoro."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][player] has cleared\n[CN][CS:P]Star Cave[CR]!", french="[CN][player] a terminé\n[CN]la [CS:P]Caverne Etoile[CR]!", german="[CN][player] meisterte die\n[CN][CS:P]Sternenhöhle[CR]!", italian="[CN][player] ha completato\n[CN]la [CS:P]Caverna Stellata[CR]!", spanish="[CN][player] ha atravesado con éxito la\n[CN][CS:P]Cueva Estrella[CR]."})
  -- message_Close
end
