-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D79P41A/s02p1001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(49, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D79P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(hero, 300, 212, false, 2)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 324, 228, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 276, 228, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 300, 244, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
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
  SkySceneKit.say({english="[CN]This area's master isn't here.", french="[CN]Le maître de cette zone n'est pas ici.", german="[CN]Der Meister dieses Gebietes ist nicht da.", italian="[CN]Il padrone di questa sala non si trova qui.", spanish="[CN]En esta zona no hay nadie\n[CN]que plantee un serio reto."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]It's impossible to go farther.[K]\n[CN]It's time to go back.", french="[CN]Impossible d'aller plus loin.[K]\n[CN]Vous devez retourner sur vos pas.", german="[CN]Es ist unmöglich weiterzugehen.[K]\n[CN]Es ist Zeit, umzukehren.", italian="[CN]Non si può andare oltre.[K]\n[CN]È ora di tornare indietro.", spanish="[CN]No se puede continuar.[K]\n[CN]Hay que regresar."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][player] cleared [CS:P]Crevice Cave[CR]\n[CN]in admirable fashion!", french="[CN][player] a terminé la [CS:P]Grotte Lézarde[CR]\n[CN]de façon admirable!", german="[CN][player] meisterte die [CS:P]Gletscherhöhle[CR]\n[CN]auf beeindruckende Weise!", italian="[CN][player] ha completato la\n[CN][CS:P]Grotta dell'Abisso[CR] in modo eccellente!", spanish="[CN]¡[player] logró atravesar la [CS:P]Cueva\n[CN]Témpano[CR] de forma admirable!"})
  -- message_Close
end
