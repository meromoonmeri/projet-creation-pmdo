-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/n04a2401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  GAME:FadeOut(false, 30)
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(30)
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I've got to move quickly and help\n[CS:N]Loudred[CR]!", french="Il faut que je me dépêche d'aller\nprêter main forte à [CS:N]Ramboum[CR]!", german="Ich muss mich beeilen\nund [CS:N]Krakeelo[CR] helfen!", italian="Devo sbrigarmi e andare\nad aiutare [CS:N]Loudred[CR]!", spanish="¡Tengo que darme prisa y ayudar\na [CS:N]Loudred[CR]!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I've got to do my best!", french=" Je dois faire de mon mieux!", german=" Ich muss mich anstrengen!", italian=" Devo fare del mio meglio!", spanish=" ¡Tengo que darlo todo!"})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(64), p.Y+(0), false, 2) end
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- switch(main_EnterAdventure(250, 30)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  GAME:WaitFrames(1) -- hold
end
