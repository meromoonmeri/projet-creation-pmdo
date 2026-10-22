-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D02P31A/m02a0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(3, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D02P31A) [neutre/état moteur]
  if ((SV.SkyPerformanceProgress or {})[7] == 1) then -- if ROM: $PERFORMANCE_PROGRESS_LIST[7]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(hero, 240, 188, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 264, 204, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 216, 204, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 240, 220, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(7)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- @label_1 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]This appears to be the end of the dungeon.", french="[CN]C'est la fin du donjon.", german="[CN]Das scheint das Ende des Dungeons zu sein.", italian="[CN]Questa sembra essere la fine del dungeon.", spanish="[CN]Parece que este territorio se acaba aquí."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]It's impossible to go any farther.[K]\n[CN]It's time to go back.", french="[CN]Vous ne pouvez pas aller plus loin.[K]\n[CN]Il est temps de rentrer.", german="[CN]Es geht nicht mehr weiter.[K]\n[CN]Zeit, umzukehren.", italian="[CN]Non si può andare oltre.[K]\n[CN]È ora di tornare indietro.", spanish="[CN]No se puede avanzar más.[K]\n[CN]Es hora de regresar."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][player] cleared [CS:P]Drenched Bluff[CR]!\n[CN]Very impressive!", french="[CN][player] a terminé la [CS:P]Falaise Trempée[CR]!\n[CN]Très impressionnant!", german="[CN][player] meisterte die [CS:P]Feuchtklippe[CR]!\n[CN]Sehr eindrucksvoll!", italian="[CN][player] ha completato la\n[CN][CS:P]Riva Paludosa[CR]! Molto bene!", spanish="[CN]¡[player] logró atravesar\n[CN]el [CS:P]Risco Calado[CR]!"})
  -- message_Close
  else
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(partner, 224, 188, false, 2)
  GROUND:MoveToPosition(hero, 256, 188, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 240, 220, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 264, 212, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(7)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
end
