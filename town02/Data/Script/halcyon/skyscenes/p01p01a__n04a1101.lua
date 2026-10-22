-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/n04a1101.ssb (ROM sha256 1fa39d35…).
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
  SkySceneKit.say({english=" ...The Invincible [CS:N]Haunter[CR]...", french=" ... [CS:N]Spectrum[CR] l'Invincible...", german=" ...Der unbesiegbare [CS:N]Alpollo[CR]...", italian=" ... L'invincibile [CS:N]Haunter[CR]...", spanish=" [CS:N]Haunter[CR], el Invencible..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Why is [CS:N]Haunter[CR]...[K]\ninvincible...", french="Pourquoi [CS:N]Spectrum[CR] est-il...[K]\ninvincible...?", german="Warum nur ist [CS:N]Alpollo[CR]...[K]\nunbesiegbar?", italian="Com'è possibile che [CS:N]Haunter[CR]...[K]\nsia invincibile...?", spanish="[CS:N]Haunter[CR]...[K] Invencible...\n¿Por qué...?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...Well![K] Anyway!", french=" ... Bah![K] Peu importe!", german=" ...[K]Wie auch immer!", italian=" ... Beh![K] Non importa!", spanish=" ¡En fin...![K] ¡Da igual!"})
  -- message_Close
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="This time, I'll definitely catch\n[CS:N]Haunter[CR]!", french="Cette fois je l'attraperai,\nce [CS:N]Spectrum[CR]!", german="Dieses Mal werde ich [CS:N]Alpollo[CR] auf\njeden Fall fangen!", italian="Questa volta riuscirò\nsicuramente a catturare [CS:N]Haunter[CR]!", spanish="¡Esta vez pienso capturar a\n[CS:N]Haunter[CR]!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I'm on my way to do my best!", french="Je suis partie pour faire des\nétincelles cette fois!", german=" Ich gebe mein Bestes!", italian=" Ce la metterò tutta!", spanish=" ¡Pienso ir a por todas!"})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(64), p.Y+(0), false, 2) end
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- switch(main_EnterAdventure(250, 30)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  GAME:WaitFrames(1) -- hold
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
