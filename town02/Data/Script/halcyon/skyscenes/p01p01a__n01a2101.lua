-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/n01a2101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_P01P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetAnimation(27) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  GAME:WaitFrames(30)
  -- SetAnimation(28) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Sniff...[K] I came back...", french=" Snif...[K] Retour au point d'départ...", german=" Schnief...[K] Da bin ich wieder...", italian=" Sniff...[K] Non ce l'ho fatta...", spanish=" Jo...[K] Pues ya he vuelto..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But while I'm just sitting here,\neveryone is fighting that band of thieves\nfor me! Yup yup!", french="Mais pendant que j'suis assis là\nà geindre, les gars sont en train d'se battre\npour moi contre la bande de voleurs, pardi!", german="Und während ich hier nur\nherumsitze, bekämpfen alle anderen die\nDiebesbande für mich! Jawollja!", italian="Ma mentre io me ne sto\nfermo qui, gli altri stanno lottando contro\nquella banda di ladri per difendermi! Già, già!", spanish="Pero mientras estoy aquí de\nbrazos cruzados todos combaten contra esa\npanda de ladrones. ¡Sí, señor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="...[K]I wonder why everyone came\nall the way out here for me...", french="...[K] Je m'demande pourquoi\ny sont tous venus jusqu'ici pour m'secourir.", german="...[K]Ich frage mich, weshalb sie\nfür mich den ganzen Weg gekommen sind...", italian="...[K] Chissà perché sono venuti\ntutti fin qui per me...", spanish="Me pregunto...[K] por qué vendrían\ntodos hasta aquí por mí..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Anyway![K] I should hurry up and\nget in there too!", french="Assez bavassé![K] Faut qu'j'aille\nfiler un coup de main dare-dare!", german="Wie dem auch sei![K] Ich sollte\nmich beeilen und auch mitmachen!", italian="Ma non c'è tempo ora![K] Devo\nsbrigarmi e aiutarli!", spanish="En fin...[K] ¡Debería darme prisa\ny echarles una mano!"})
  -- message_Close
end
