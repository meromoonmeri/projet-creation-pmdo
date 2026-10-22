-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D32P12A/s04p0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 61) -- $SCENARIO_MAIN = scn[29,61] (ROM)
  -- back_SetGround(LEVEL_D32P12A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(hero, 228, 340, false, 2)
  GAME:WaitFrames(15)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 252, 356, false, 2) end end
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 204, 356, false, 2) end end
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 228, 372, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]There is something in\n[CN]front of the stone marker.", french="[CN]Il y a quelque chose\n[CN]au pied de la stèle.", german="[CN]Da ist etwas\n[CN]vor dem Steinwegweiser.", italian="[CN]C'è qualcosa di fronte\n[CN]alla Stele.", spanish="[CN]Hay algo enfrente de la losa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(228, 284, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 228, 268, false, 2)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 252, 284, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 204, 284, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 228, 300, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(15)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]It appears to be a letter.", french="[CN]C'est une lettre.", german="[CN]Es scheint ein Brief zu sein.", italian="[CN]Sembra trattarsi di una lettera.", spanish="[CN]Parece una carta."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][player] read the letter.", french="[CN][player] lit la lettre.", german="[CN][player] liest den Brief.", italian="[CN][player] legge la lettera.", spanish="[CN][player] ha leído la carta."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="\\\"To Team [team:]:\\\"", french="\\\"Chère Equipe [team:]:", german="[F:S2]An Team [team:]:[F:E2]", italian="\\\"Al Team [team:]:\\\"", spanish="\\\"Al [CS:X]Equipo[CR] [team:]:\\\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="\"As we promised earlier, we have already\nsolved this mystery. We're going on ahead.\"", french="Comme nous vous l'avions promis, nous avons\ndéjà résolu cette énigme. Nous avons pris une\nlongueur d'avance.", german="[F:S2]Wie versprochen haben wir\ndieses Rätsel schon gelöst. Wir gehen weiter\nvoraus.[F:E2]", italian="\"Come promesso, abbiamo già risolto questo\nmistero. Stiamo proseguendo.\"", spanish="\"Tal y como prometimos, hemos resuelto el\nmisterio y seguimos adelante.\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="\"This is a race to see who can get the treasure\nfirst, you know!\"\n- Team [CS:X]Charm[CR] -", french="C'est une véritable course au trésor, nous\nespérons que vous vous en rendez compte!\"\n- L'Equipe [CS:X]Charme[CR] -", german="[F:S2]Bei diesem Rennen wird sich\nzeigen, wer die besseren Schatzjäger sind![F:E2]\n- Team [CS:X]Charme[CR] -", italian="\"Questa è una gara per vedere quale delle due\nsquadre arriverà per prima al tesoro!\"\n- Team [CS:X]Malia[CR] -", spanish="\"¡Esto es una carrera para ver quién\nencuentra primero el tesoro!\"\nFirmado: [CS:X]Equipo Carisma[CR]."})
  -- message_Close
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 252, 284, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 204, 284, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 228, 300, false, 2) end end
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.UpRight) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
end
