-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/n01a0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" N-nope...[K] Not this way.", french=" Heu, non...[K] Pas par là.", german=" N-nein...[K] Nicht hier lang.", italian=" N-No...[K] Non da questa parte.", spanish=" Hum... no...[K] No es por aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Sniff...[K] I always seem to space\nout and daydream...", french="Snif...[K] J'ai l'impression de\npasser mon temps à rêvasser...", german="Schnief...[K] Es passiert immer\nwieder, dass ich abgelenkt bin und den Faden\nverliere...", italian="Sniff...[K] Ho sempre la testa\ntra le nuvole...", spanish="Ay...[K] Parece que siempre me distraigo,\nsoy bastante despistado..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="And then, before I know it, I\nfind myself in a very strange place...", french="Puis, sans qu'je sache trop\ncomment, j'me retrouve dans un drôle\nd'endroit...", german="Und dann bin ich auf einmal\nan den sonderbarsten Orten...", italian="E così, prima che riesca\nad accorgermene, mi ritrovo sempre\nin qualche strano posto...", spanish="Sin darme cuenta acabo siempre\nen algún lugar extraño. ¡Soy lo peor!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="It's not good, not at all.[K] Golly, I\nreally should be careful, yup yup.", french="C'est pas bon, pas bon du tout.[K]\nSapristi, faut vraiment que j'fasse\ngaffe, ouaip.", german="Das ist nicht gut, nein,\nüberhaupt nicht.[K] Donnerwetter, ich muss\naufpassen! Jawollja.", italian="Non va affatto bene, no, no.[K]\nOhibò, devo fare molta attenzione, già, già.", spanish="Esto no puede ser.[K] Caramba,\ntengo que centrarme un poco, sí, señor."})
  -- message_Close
end
