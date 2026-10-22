-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P10C/n01a1101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P06A) [décor sub chargé: Sub_v02p06a]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v02p06a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(150)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_G01P10C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 264, 200, Direction.Down, "NPC_DOGOOMU")
  -- SetAnimation(44) [anim idle native]
  GAME:WaitFrames(10)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 176, 200, Direction.Down, "NPC_HEIGANI")
  -- SetAnimation(45) [anim idle native]
  GAME:FadeIn(60) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Today I should sleep and rest up,\nand I can try again tomorrow. Yup yup.", french="Je f'rais mieux de\nm'reposer et de récupérer, aujourd'hui.\nJ'pourrai réessayer demain.", german="Ich sollte ins Bett und mich\nausruhen. Morgen probiere ich es erneut,\njawollja.", italian="È meglio che dorma e mi riposi\nper bene. Domani ci riproverò, già, già.", spanish="Debería descansar y dormir bien,\nmañana será otro día. Sí, señor."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yup yup. Good night.", french=" Ouaip ouaip. Bonne nuit.", german=" Jawollja. Gute Nacht.", italian=" Già, già. Buonanotte.", spanish=" Sí, señor. Buenas noches."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Left)
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- SetAnimation(46) [anim idle native]
  GAME:WaitFrames(120)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 120)
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
