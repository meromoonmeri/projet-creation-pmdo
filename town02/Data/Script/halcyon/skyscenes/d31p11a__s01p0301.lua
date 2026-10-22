-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D31P11A/s01p0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 3) -- $SCENARIO_MAIN = scn[29,3] (ROM)
  -- back_SetGround(LEVEL_D31P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Mystifying Forest.ogg", true) end)
  GROUND:MoveToPosition(partner, 284, 228, false, 2)
  GROUND:MoveToPosition(hero, 316, 228, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This is the way into\n[CS:P]Mystifying Forest[CR].", french="C'est le chemin qui mène\nà la [CS:P]Forêt Trompeuse[CR].", german="Dieser Weg führt in den\n[CS:P]Verwirrwald[CR].", italian="Da questa parte si entra\nnella [CS:P]Foresta Inganno[CR].", spanish="Por aquí se va al [CS:P]Bosque[CR]\n[CS:P]Misterio[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This is the entrance to\n[CS:P]Mystifying Forest[CR].", french="C'est le chemin qui mène\nà la [CS:P]Forêt Trompeuse[CR].", german="Dies ist der Eingang zum\n[CS:P]Verwirrwald[CR].", italian="Da questa parte si entra\nnella [CS:P]Foresta Inganno[CR].", spanish="Esta es la entrada del [CS:P]Bosque[CR]\n[CS:P]Misterio[CR]."})
  else
  SkySceneKit.say({english="This is the way into\n[CS:P]Mystifying Forest[CR].", french="C'est le chemin qui mène\nà la [CS:P]Forêt Trompeuse[CR].", german="Dieser Weg führt in den\n[CS:P]Verwirrwald[CR].", italian="Da questa parte si entra\nnella [CS:P]Foresta Inganno[CR].", spanish="Por aquí se llega al [CS:P]Bosque[CR]\n[CS:P]Misterio[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I don't know what we can expect\nto see in there...", french=" J'ignore ce qui nous y attend...", german="Ich habe keine Ahnung, was uns\ndrinnen erwarten könnte...", italian="Non so cosa ci aspetti\nlì dentro...", spanish="Ni idea de qué nos podemos\nencontrar allí..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I have no idea what we're going\nto see in there...", french=" J'ignore ce qui nous y attend...", german="Ich weiß nicht, was wir\ndrinnen zu Gesicht bekommen werden...", italian="Non so cosa ci aspetti\nlì dentro...", spanish="Ni idea de qué nos podemos\nencontrar allí..."})
  else
  SkySceneKit.say({english="I don't know what we're\nup against...", french=" J'ignore ce qui nous y attend...", german="Ich weiß nicht, worauf wir\nuns einlassen...", italian="Non so cosa ci aspetti\nlì dentro...", spanish="Veremos con qué nos\nencontramos una vez allí..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But this is our mission.[K] Get to\nthe deepest part of the forest and bring back\nthe treasure.", french="... mais c'est notre mission.[K]\nNous rendre au cœur de la forêt et rapporter\nle trésor.", german="Aber das ist unsere Mission.[K] In\ndie tiefsten Tiefen des Waldes vordringen und\nden Schatz zurückbringen.", italian="Ma la nostra missione è\nquesta.[K] Raggiungere il cuore della\nforesta e prendere il tesoro.", spanish="Según las instrucciones...[K]\ntenemos que llegar a la zona más profunda\ndel bosque y regresar con el tesoro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But this is our mission.[K] Get to\nthe deepest part of the forest and bring back\nthe treasure.", french="... mais c'est notre mission.[K]\nNous rendre au cœur de la forêt et rapporter\nle trésor.", german="Aber das ist unsere Mission.[K] In\ndie tiefsten Tiefen des Waldes vordringen und\nden Schatz zurückbringen.", italian="Ma la nostra missione è\nquesta.[K] Raggiungere il cuore della\nforesta e prendere il tesoro.", spanish="Según las instrucciones...[K]\ntenemos que llegar a la zona más profunda\ndel bosque y regresar con el tesoro."})
  else
  SkySceneKit.say({english="But anyway...[K]we have to go to\nthe deepest part of the forest and bring back\nthe treasure from there.", french="... mais c'est notre mission.[K]\nNous rendre au cœur de la forêt et rapporter\nle trésor.", german="Wie auch immer...[K] Wir müssen\nin die tiefsten Tiefen des Waldes vordringen\nund den Schatz von dort zurückbringen.", italian="Ma la nostra missione è\nquesta.[K] Raggiungere il cuore della\nforesta e prendere il tesoro.", spanish="Según las instrucciones...[K]\ntenemos que llegar a la zona más profunda\ndel bosque y regresar con el tesoro."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That's our graduation exam.", french=" C'est ça notre examen.", german=" Das ist unsere Abschlussprüfung.", italian="Questo è quanto prevede il\nnostro esame.", spanish=" Ese es nuestro gran reto."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That's our graduation exam.", french=" C'est ça notre examen.", german=" Das ist unsere Abschlussprüfung.", italian="Questo è quanto prevede il\nnostro esame.", spanish=" Ese es nuestro gran reto."})
  else
  SkySceneKit.say({english=" That's our graduation exam.", french=" C'est ça notre examen.", german=" Das ist unsere Abschlussprüfung.", italian="Questo è quanto prevede il\nnostro esame.", spanish=" Ese es nuestro gran reto."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's pass this exam and\ngraduate from the guild!", french="Il faut qu'on le réussisse pour\ndécrocher notre diplôme de la Guilde!", german="Lass uns die Prüfung bestehen,\num somit die Gilde mit dem Abschluss in der\nTasche verlassen zu können!", italian=" Passiamo l'esame della Gilda!", spanish="¡Tenemos que superar el gran\nreto del [CS:N]Pokégremio[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's pass this exam and\ngraduate from the guild!", french="Il faut qu'on le réussisse pour\ndécrocher notre diplôme de la Guilde!", german="Lass uns die Prüfung bestehen,\num somit die Gilde mit dem Abschluss in der\nTasche verlassen zu können!", italian=" Passiamo l'esame della Gilda!", spanish="¡Tenemos que superar el gran\nreto del [CS:N]Pokégremio[CR]!"})
  else
  SkySceneKit.say({english="Let's pass this exam and\ngraduate from the guild!", french="Il faut qu'on le réussisse pour\ndécrocher notre diplôme de la Guilde!", german="Lass uns die Prüfung bestehen,\num somit die Gilde mit dem Abschluss in der\nTasche verlassen zu können!", italian=" Passiamo l'esame della Gilda!", spanish="¡Tenemos que superar el gran\nreto del [CS:N]Pokégremio[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's do this right,\n[hero]!", french="Donnons le meilleur de\nnous-mêmes, [hero]!", german="Lass es uns richtig angehen,\n[hero]!", italian="Impegniamoci al massimo,\n[hero]!", spanish="¡Hay que echar el resto,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's not blow this,\n[hero]!", french="Donnons le meilleur de\nnous-mêmes, [hero]!", german="Lass es uns nicht verpatzen,\n[hero]!", italian="Impegniamoci al massimo,\n[hero]!", spanish="¡No lo echemos a perder,\n[hero]!"})
  else
  SkySceneKit.say({english=" Let's do good, [hero]!", french="Donnons le meilleur de\nnous-mêmes, [hero]!", german=" Lass es uns tun, [hero]!", italian="Impegniamoci al massimo,\n[hero]!", spanish="¡Esto hay que hacerlo\nbien, [hero]!"})
  end
  -- message_Close
  GROUND:MoveToPosition(hero, 300, 92, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(partner, 300, 92, false, 2)
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  -- main_EnterDungeon(44, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
end
