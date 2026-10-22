-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/n04a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  SV.SkyScenarioSide = {main=43, sub=2} -- $SCENARIO_SIDE = scn[43,2] (ROM)
  GAME:FadeOut(false, 30)
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(30)
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" OK.", french=" Très bien.", german=" Also gut.", italian=" Allora...", spanish=" Vale."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Before I head out...[K] I should\nconfirm my assignment.", french="Avant de me mettre en route...[K]\nje devrais confirmer la mission.", german="Bevor ich mich auf den Weg\nmache,[K] sollte ich meinen Auftrag bestätigen.", italian="Prima di partire...[K] devo\nconfermare il mio incarico.", spanish="Antes de que me vaya...[K] debería\nconfirmar mi tarea."})
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
  SkySceneKit.say({english="I need to apprehend the outlaw\n[CS:N]Haunter[CR].", french="Il faut que j'appréhende\n[CS:N]Spectrum[CR], le hors-la-loi.", german="Ich muss den Ganoven\n[CS:N]Alpollo[CR] fangen.", italian="Devo catturare il ricercato\n[CS:N]Haunter[CR].", spanish="Tengo que capturar al malhechor\n[CS:N]Haunter[CR]."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Officer [CS:N]Magnezone[CR] said that if I\nhead out right away, I should be able to catch\nhim in no time...", french="Le shérif [CS:N]Magnézone[CR] m'a dit\nque si je partais tout de suite, je devrais\npouvoir l'attraper en un rien de temps...", german="Oberwachtmeister [CS:N]Magnezone[CR]\nsagte, dass ich ihn schnell erwischen kann,\nwenn ich mich direkt auf den Weg mache.", italian="Il Commissario [CS:N]Magnezone[CR] mi ha\ndetto che se parto subito dovrei essere\nin grado di raggiungerlo senza problemi...", spanish="El agente [CS:N]Magnezone[CR] dijo que,\nsi salía enseguida, debería poder alcanzarlo\nsin problemas..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="If I head out quickly, I'll be done\nin a flash!", french="Si je pars sur-le-champ,\nj'accomplirai cette mission en un clin d'œil!", german="Wenn ich mich etwas beeile,\nhabe ich das ruckzuck erledigt!", italian="Se mi sbrigo, porterò a termine\nla missione in men che non si dica!", spanish="¡Si salgo ya, habré terminado\nen un periquete!"})
  -- message_Close
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yup![K] All right, here I go!", french=" Ouaip![K] Très bien, c'est parti!", german="Jau![K]\nAlles klar, ich bin unterwegs!", italian=" Ok![K] Si parte!", spanish=" ¡Yupi![K] Pues eso, ¡allá voy!"})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(64), p.Y+(0), false, 2) end
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- switch(main_EnterAdventure(250, 30)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  GAME:WaitFrames(1) -- hold
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
