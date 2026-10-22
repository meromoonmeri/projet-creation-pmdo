-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/n04a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
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
  SkySceneKit.say({english="Before I head out...[K] I should\nconfirm my assignment.", french="Avant de me mettre en route...[K]\nje devrais confirmer la mission.", german="Bevor ich mich auf den Weg\nmache,[K] sollte ich meinen Auftrag bestätigen.", italian="Prima di partire...[K] devo\nconfermare il mio incarico.", spanish="Antes de irme...[K] debería\nconfirmar mi tarea."})
  -- message_Close
  -- GAP: se_Play(9985) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(25) [anim idle native]
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V34P01A) [décor sub chargé: Sub_v34p01a]
  -- camera2_SetPositionMark(Position<'m0', 16.5, 16.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v34p01a", 15, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" .........", french=" .........", german=" ..........", italian=" ..........", spanish=" ..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" This time, I'll catch [CS:N]Haunter[CR]!", french="Cette fois, je vais l'attraper,\nce [CS:N]Spectrum[CR]!", german=" Dieses Mal kriege ich [CS:N]Alpollo[CR]!", italian="Questa volta riuscirò\na catturare [CS:N]Haunter[CR]!", spanish=" Esta vez atraparé a [CS:N]Haunter[CR]."})
  -- message_Close
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I'm going to do my best!", french=" Je vais faire de mon mieux!", german=" Ich werde mein Bestes geben!", italian=" Ce la metterò tutta!", spanish=" ¡Pienso darlo todo!"})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(64), p.Y+(0), false, 2) end
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- switch(main_EnterAdventure(250, 30)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  GAME:WaitFrames(1) -- hold
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
