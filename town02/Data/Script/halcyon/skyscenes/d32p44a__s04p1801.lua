-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D32P44A/s04p1801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(61, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D32P44A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_LOWER_BRINE_CAVE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(hero, 300, 276, false, 2)
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 324, 292, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 276, 292, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 300, 308, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- GAP: se_Play(6925) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(30) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  GAME:WaitFrames(2) -- join WaitSe
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" ........................", french=" ........................", german=" ........................", italian=" ........................", spanish=" ..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" SHOW ALL OF YOUR POWER!", french=" MONTREZ TOUT VOTRE POUVOIR!", german=" DEMONSTRIERT ALL EURE KRAFT!", italian=" DAI PROVA DI TUTTA LA TUA FORZA!", spanish=" ¡DEMOSTRAD TODO VUESTRO PODER!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="PROVE YOURSELVES WORTHY TO\nBECOME MY MASTER.", french="MONTREZ-VOUS DIGNES DE DEVENIR\nMES MAITRES.", german="ERWEIST EUCH WÜRDIG, MEIN MEISTER\nZU WERDEN.", italian="DIMOSTRATI IN GRADO DI FARMI\nDIVENTARE UN TUO SERVITORE.", spanish="DEMOSTRAD QUE MERECÉIS TENER\nEL DOMINIO."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(7952) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 15) -- screen_WhiteOut
  GAME:WaitFrames(90)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(5136) — id SE NDS sans portage PMDO identifié
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
end
