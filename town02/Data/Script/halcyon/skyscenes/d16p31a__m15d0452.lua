-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D16P31A/m15d0452.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  GAME:FadeOut(false, 0)
  GAME:WaitFrames(30)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]I see...", french="[CN]Je vois...", german="[CN]Ich verstehe...", italian="[CN]È chiaro...", spanish="[CN]Puedo ver que..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Of the three spiritual elements of\n[CN]knowledge, emotion, and willpower...", french="[CN]Parmi les trois éléments spirituels du\n[CN]savoir, de l'émotion et de la volonté...", german="[CN]Es gibt drei spirituelle Elemente.\n[CN]Wissen, Gefühl und Stärke...", italian="[CN]I tre elementi spirituali...\n[CN]la conoscenza, le emozioni e la volontà...", spanish="[CN]De los tres elementos espirituales:\n[CN]emoción, sabiduría y voluntad..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Azelf[CR] is the\n[CN]Being of Willpower.", french="[CN][CS:N]Créfadet[CR] est\n[CN]l'être de la volonté.", german="[CN][CS:N]Tobutz[CR] steht für die Stärke.\n[CN]Es ist das Starke Wesen.", italian="[CN][CS:N]Azelf[CR]...\n[CN]è l'Essere della volontà.", spanish="[CN][CS:N]Azelf[CR] es\n[CN]el ser de la voluntad."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Willpower is the motivation that\n[CN]drives us.[K] It's a unifying power.", french="[CN]La volonté est la motivation qui nous dicte\n[CN]nos actions.[K] C'est un pouvoir fédérateur.", german="[CN]Stärke ist das, was uns antreibt.[K]\n[CN]Sie ist eine Kraft, die uns alle vereint.", italian="[CN]La volontà è quella forza che ci spinge\n[CN]ad andare avanti.[K] Ci rende uniti.", spanish="[CN]La voluntad es la motivación que\n[CN]nos impulsa.[K] Es un poder unificador."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]To unify is to make one.\n[CN]So if the colors of the\n[CN]crystals were made one...", french="[CN]Fédérer, c'est créer l'harmonie.\n[CN]Alors quand les couleurs des\n[CN]cristaux seront harmonisées...", german="[CN]Sich vereinen heißt, eins zu werden.\n[CN]Wenn die Farben der Kristalle\n[CN]eins würden...", italian="[CN]La nostra volontà, ha fatto sì che\n[CN]diventassimo una cosa sola. Se i diversi\n[CN]colori dei cristalli diventassero uno solo...", spanish="[CN]Unificar es convertir en uno.\n[CN]Entonces, si los colores de los\n[CN]cristales se convirtieran en uno..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The path should reveal itself.", french="[CN]... le chemin sera révélé.", german="[CN]Dann würde der Weg offenbart.", italian="[CN]... forse il passaggio apparirà.", spanish="[CN]El camino se haría visible."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]What is the color of [CS:N]Azelf[CR]'s\n[CN]spirit? That is the question.", french="[CN]De quelle couleur est l'esprit de\n[CN][CS:N]Créfadet[CR]? Telle est la question.", german="[CN]Welche Farbe hat das Element von [CS:N]Tobutz[CR]?\n[CN]Das ist die Frage.", italian="[CN]Ma bisogna ancora scoprire\n[CN]qual è il colore di [CS:N]Azelf[CR].", spanish="[CN]¿De qué color es el espíritu de [CS:N]Azelf[CR]?\n[CN]Esa es la gran pregunta."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Azelf[CR] lives at\n[CN][CS:P]Shining Lake[CR].", french="[CN][CS:N]Créfadet[CR] vit dans\n[CN]le [CS:P]Lac Cristal[CR].", german="[CN][CS:N]Tobutz[CR] lebt\n[CN]am [CS:P]Kristallsee[CR].", italian="[CN][CS:N]Azelf[CR], l'Essere della volontà, vive\n[CN]presso il [CS:P]Lago di Cristallo[CR].", spanish="[CN][CS:N]Azelf[CR] vive en el\n[CN][CS:P]Lago Cristal[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Then [CS:N]Azelf[CR]'s spirit must be\n[CN]affected by the crystals...", french="[CN]Donc son esprit doit être\n[CN]affecté par les cristaux...", german="[CN]Außerdem muss das Element von [CS:N]Tobutz[CR]\n[CN]mit den Kristallen verbunden sein...", italian="[CN]La volontà di [CS:N]Azelf[CR]...\n[CN]comanda quei cristalli...", spanish="[CN]Por tanto el espíritu de [CS:N]Azelf[CR]\n[CN]debe de verse afectado por los cristales..."})
  -- GAP: se_Play(5139) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 5) -- screen_WhiteOutAll
  -- message_CloseEnforce
  GAME:FadeOut(true, 0) -- screen_WhiteOut
  GAME:FadeIn(0)
end
