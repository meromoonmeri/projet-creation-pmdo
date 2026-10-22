-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P27A/us3108.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_jiguzaguma = SkySceneKit.spawn_npc("zigzagoon", 256, 160, Direction.Down, "NPC_JIGUZAGUMA")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_jiguzaguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="I've decided to team up with\n[CS:N]Heracross[CR] and explore all over the world! ♪", french="J'ai décidé de faire équipe avec\n[CS:N]Scarhino[CR] et d'aller explorer\nle monde entier! ♪", german="Ich habe beschlossen, zusammen\nmit [CS:N]Skaraborn[CR] die ganze Welt zu erkunden! ♪", italian="Ho deciso di unirmi a [CS:N]Heracross[CR]\nper esplorare tutto il mondo! ♪", spanish="He decidido unirme a [CS:N]Heracross[CR]\ny explorar todo el mundo. ♪"})
  -- message_Close
  -- @label_131 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_jiguzaguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english=" [CS:P]Sky Peak[CR] was so much fun...", french="Escalader le [CS:P]Pic Céleste[CR],\nc'était si amusant...", german="Die Erkundung zum\n[CS:P]Himmelsgipfel[CR] hat so viel Spaß gemacht...", italian="Mi sono proprio divertito\nsul [CS:P]Picco del Cielo[CR]...", spanish=" La [CS:P]Cumbre del Cielo[CR] es la pera..."})
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="I wonder where I'll explore\nnext time.", french="Je me demande où je vais aller\npour ma prochaine exploration.", german="Ich frage mich, wohin ich das\nnächste Mal auf Erkundung gehen werde.", italian="Chissà che luogo esplorerò\nla prossima volta.", spanish="Quién sabe dónde exploraré\nla próxima vez."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 71] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="Yay! Hooray!\nWe've reached the summit!", french="Yahou! Hourra!\nOn a atteint le sommet!", german="Jaaa! Hurra!\nWir haben den Gipfel erreicht!", italian="Evviva! Urrà!\nAbbiamo raggiunto la cima!", spanish="¡Bieeeen! ¡Yupi!\n¡Hemos llegado a la cima!"})
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="I joined up with [CS:N]Heracross[CR] at the\n7th Station Clearing, and we were climbing\ntogether. It was such fun!", french="J'ai rejoint [CS:N]Scarhino[CR] à la\ntrouée du 7[F:E] Relais et nous avons fait\nl'ascension ensemble. Quel plaisir c'était!", german="Ab der 7. Zwischenlagerlichtung\nbin ich zusammen mit [CS:N]Skaraborn[CR] geklettert.\nDas hat vielleicht Spaß gemacht!", italian="Al Bivacco 7 mi sono unito a\n[CS:N]Heracross[CR] e abbiamo continuato il viaggio\ninsieme. È stato proprio divertente!", spanish="Me reuní con [CS:N]Heracross[CR] en la\nBase del Séptimo Puerto y subimos juntos.\n¡Fue divertidísimo!"})
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="He kept yelling, \"Whooooa!\"\nJust watching it was so much fun.", french="Il n'arrêtait pas de crier:\n\"Youhouuuuu!\" Rien que pour entendre ça,\nça valait le détour.", german="Er hat die ganze Zeit [F:S2]Boooah![F:E2]\ngeschrieen. Urkomisch!", italian="Non faceva che gridare\n\"Wooow\"! Era davvero uno spasso.", spanish="No paraba de gritar: \"¡Guauuu!\".\nSolo por verlo valía la pena subir."})
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="I've heard it so many times,\nI can imitate it. Ha ha ha!", french="Je l'ai entendu crier ça si\nsouvent que maintenant je peux l'imiter.\nHa ha ha!", german="Jetzt habe ich es so oft gehört,\ndass ich es nachahmen kann. Ha ha ha!", italian="L'ho sentito tante di quelle\nvolte che ormai riesco a imitarlo. Ah ah ah!", spanish="Lo he oído tantas veces que lo\nimito a la perfección. ¡Ja, ja, ja!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_jiguzaguma, "happy", 1) end)
  -- message_Close
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(npc_npc_jiguzaguma, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 30] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="Psst...hey! Did you find the\nSecret Room yet?", french="Psst... hé! Tu as déjà trouvé\nla Salle Secrète?", german="Psst... Hey! Hast du den\nGeheimraum schon gefunden?", italian="Psss... Ehi! Hai già trovato\nla Sala Segreta?", spanish="Psst... Oye, ¿has encontrado ya\nla Cámara Secreta?"})
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="It's rumored that there is some\nreally incredible treasure hiding in the\nSecret Room!", french="On dit qu'un trésor vraiment\nincroyable se cache dedans!", german="Gerüchte besagen, dass sich\nwirklich unglaubliche Schätze in dem\nGeheimraum befinden!", italian="Gira voce che in questa sala\nsia nascosto un tesoro incredibile!", spanish="Se rumorea que en la Cámara\nSecreta hay escondido un tesoro\ntotalmente sensacional."})
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="According to [CS:N]Shaymin[CR], it seems\nthat the Secret Room isn't actually in a fixed\nlocation...", french="D'après [CS:N]Shaymin[CR], cette\nSalle Secrète ne se trouverait pas\ndans un endroit fixe et immuable.", german="[CS:N]Shaymin[CR] zufolge befindet sich\nder Geheimraum nicht an einem festen Ort...", italian="[CS:N]Shaymin[CR] dice che la Sala Segreta\nnon si trova in un luogo preciso...", spanish="Según [CS:N]Shaymin[CR], parece\nque la Cámara Secreta no se encuentra en\nun lugar fijo..."})
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="It'd be great if you happened\nacross it by chance!", french="Quelle chance si tu pouvais\ntomber dessus par hasard!", german="Es wäre toll, wenn du ihn per\nZufall entdecken würdest!", italian="Sarebbe fantastico se riusciste\na scoprirla per caso!", spanish="¡Molaría que te la encontraras\npor casualidad!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 26] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="It seems like the trouble at the\n5th Station Clearing was caused by [CS:N]Sneasel[CR].", french="Apparemment, c'est [CS:N]Farfuret[CR]\nqui a semé la pagaille à la trouée du 5[F:E] Relais.", german="Es scheint, als ob der Ärger auf\nder 5. Zwischenlagerlichtung von [CS:N]Sniebel[CR]\nverursacht wurde.", italian="A quanto si dice, è stato [CS:N]Sneasel[CR]\na combinare tutti quei guai al Bivacco 5.", spanish="Por lo visto [CS:N]Sneasel[CR] era quien\ncausaba los problemas en la Base\ndel Quinto Puerto."})
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english=" [CS:N]Sneasel[CR]'s pretty selfish, huh...?", french="[CS:N]Farfuret[CR] est plutôt égoïste\ndans son genre, hein...?", german="[CS:N]Sniebel[CR] ist ganz schön\negoistisch, nicht wahr?", italian=" [CS:N]Sneasel[CR] è proprio egoista, eh...?", spanish=" [CS:N]Sneasel[CR] es un egoísta, ¿eh?"})
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="I wish he'd pay more attention\nto his surroundings...", french="Si seulement il pouvait faire un\npeu plus attention à ce qui l'entoure...", german="Ich wünschte, er würde seine\nUmgebung mehr achten...", italian="Vorrei che si comportasse con\npiù responsabilità...", spanish="Ojalá prestara más atención a\ntodo lo que le rodea..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 20] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="It looks like [CS:N]Sneasel[CR] was\nfirst heading for the 5th Station Clearing.", french="Apparemment, [CS:N]Farfuret[CR] s'est\nd'abord dirigé vers la trouée du 5[F:E] Relais.", german="Sieht so aus, als ob [CS:N]Sniebel[CR] als\nErster auf der 5. Zwischenlagerlichtung war.", italian="Pare che [CS:N]Sneasel[CR] volesse\nraggiungere il Bivacco 5.", spanish="Parece que [CS:N]Sneasel[CR] se dirigía\nprimero a la Base del Quinto Puerto."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 17] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="It looks like the path enters a\ncave from here.", french="On dirait que le chemin se\npoursuit dans une grotte à partir d'ici.", german="Es scheint, als ob der Pfad von\nhier aus in eine Höhle führt.", italian="Sembra che da questo punto il\nsentiero prosegua dentro una grotta.", spanish="Parece que el camino lleva\na una cueva a partir de aquí."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 9) >= 0) or (SkyProg.cmp(29, 8) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 13] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_jiguzaguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english=" There's treasure everywhere!", french=" Il y a des trésors partout!", german=" Da sind überall Schätze!", italian=" Ci sono tesori ovunque!", spanish=" ¡Hay tesoros por todas partes!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 6] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_jiguzaguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="While I was out on an\nexploration, something impossible happened\nto the world... Or so I hear.", french="Pendant que j'étais en\nexploration, un truc inimaginable est arrivé à\nce monde... C'est ce que j'ai entendu, du moins.", german="Während ich auf Erkundung war,\nscheint etwas Unmögliches mit der Welt\ngeschehen zu sein... Habe ich zumindest gehört.", italian="Mentre mi trovavo in\nesplorazione, è successo qualcosa di incredibile\nal mondo... O almeno è quello che ho sentito.", spanish="Mientras estaba explorando\nle ha pasado algo imposible al mundo...\nAl menos eso me han dicho."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_jiguzaguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="I wonder where I'll go\nexploring next...", french="Je me demande quel coin j'irai\nexplorer la prochaine fois...", german="Ich frage mich, wohin mich die\nErkundungen als Nächstes führen werden...", italian="Chissà che avventure\nmi attendono in futuro...", spanish="A saber adónde iré a explorar\nla próxima vez..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 1] || scn($SCENARIO_MAIN) >= [22
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_jiguzaguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="You were out on some kind of\njourney, weren't you?", french="Tu étais en voyage, ou quelque\nchose comme ça, non?", german="Ihr wart unterwegs auf einer\nArt Reise, nicht wahr?", italian="Avete partecipato a qualche\nspedizione, non è vero?", spanish="Tú estabas de viaje o algo así,\n¿no es cierto?"})
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="I just got back from a long\njourney myself.", french="Moi-même, je rentre tout juste\nd'un long voyage.", german="Ich bin selbst gerade erst von\neiner langen Reise zurückgekehrt.", italian="Anch'io sono appena tornato\nda un lungo viaggio.", spanish="Yo acabo de volver de\nun viaje larguísimo."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_jiguzaguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english=" Browsing is just relaxing!", french="Prendre son temps,\nc'est relaxant!", german=" Stöbern entspannt ungemein!", italian="È così rilassante dare\nun'occhiata in giro!", spanish="¡Ir mirando los productos\nme relaja que ni te cuento!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 4] || scn($SCENARIO_MAIN) >= [12
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_jiguzaguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="I've got a bad feeling about the\n[CS:N]Sneasel[CR] at the other table for some reason.", french="Je ne sais pas pourquoi, mais ce\n[CS:N]Farfuret[CR] à la table voisine\nne m'inspire rien de bon.", german="Irgendwie habe ich ein ungutes\nGefühl, wenn ich [CS:N]Sniebel[CR] an dem Tisch dort\ndrüben sehe.", italian="Non so perché, ma quello [CS:N]Sneasel[CR]\nlaggiù non me la racconta giusta.", spanish="No sé por qué, pero el [CS:N]Sneasel[CR]\nde la otra mesa me da mala espina."})
  -- message_KeyWait
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_jiguzaguma, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="As soon as he came into the\nstore, he yelled at me, \"Don't just loiter!\"", french="A peine entré dans le magasin,\nil m'a crié: \"Alors, décide-toi un peu!\"", german="Als er den Laden betrat, schrie\ner mich an: [F:S2]Was lümmelst du hier rum![F:E2]", italian="Non appena ho messo piede nel\nnegozio, mi ha gridato di non curiosare!", spanish="En cuanto entró, le dio por\ngritarme: \"¡No te quedes ahí pasmado!\""})
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="It's OK to take your time and\nbrowse a bit, though.[K] Isn't it?", french="Pourtant, je ne vois pas où\nest le mal: prendre son temps pour regarder\navant d'acheter, c'est normal.[K] Non?", german="Es ist doch okay, sich Zeit zu\nnehmen und ein wenig herumzustöbern.[K] Oder?", italian="Ma non c'è niente di male\na curiosare un po'.[K] Giusto?", spanish="No creo que tenga nada de malo\npensárselo un poco antes de comprar.[K] ¿No?"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_jiguzaguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="Everyone in [CS:N]Wigglytuff[CR]'s Guild is\nout on an expedition right now.", french="Tous les membres de la Guilde\nde [CS:N]Grodoudou[CR] partent en expédition.", german="Alle von der [CS:N]Knuddeluff-Gilde[CR]\nbereiten sich gerade auf eine Expedition vor.", italian="Tutti i membri della Gilda di\n[CS:N]Wigglytuff[CR] parteciperanno a una spedizione.", spanish="Todos los del [CS:N]Pokégremio[CR]\n[CS:N]de Exploradores[CR] se están preparando\npara ir de expedición."})
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="Must be fun...\nI wish I could have gone along...", french="Ça doit être plutôt sympa...\nSi seulement j'avais pu partir avec eux...", german="Muss spaßig sein...\nIch wünschte, ich wäre dabei...", italian="Deve essere divertente...\nQuanto mi piacerebbe unirmi a loro...", spanish="Debe de ser divertido...\nY yo, sin haber podido ir..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_jiguzaguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english=" Recycle! Recycle!", french="Echanger, encore\net toujours plus!", german="Wiederverwerten!\nWiederverwerten!", italian=" Devo riciclare! Devo riciclare!", spanish=" ¡A reciclar! ¡A reciclar!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 6] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_jiguzaguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="All right! I'm going to recycle a\nbunch from here on out!", french="Très bien! A partir de\nmaintenant, je vais échanger, échanger,\néchanger!", german="Na gut! Ich werde mich mal\naufmachen, ein paar Dinge wiederzuverwerten!", italian="Bene! D'ora in poi riciclerò\na più non posso!", spanish="Bueno, pues voy a ponerme a\nreciclar como un loco."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 3] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_jiguzaguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="Do you know of the IQ Skill\n\"Acute Sniffer\"?", french="Tu connais l'aptitude Q.I.\n\"Flaireur d'Objets\"?", german="Kennst du die IQ-Fähigkeit\n[F:S2]Spürnase[F:E2]?", italian="Hai presente l'Abilità QI\n\"Fiuto acuto\"?", spanish="¿Conoces la habilidad CI\n\"Cuenta-objetos\"?"})
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="It's a skill that allows you to\ninstantly know how many treasures are left\non the floor!", french="C'est une aptitude qui te permet\nde savoir instantanément combien de trésors\nil reste dans un étage!", german="Eine Fähigkeit, die es dir\nerlaubt, sofort zu wissen, wie viele Schätze\nnoch auf der Ebene versteckt sind!", italian="Ti permette di capire\nimmediatamente quanti tesori ci sono\nsu un piano!", spanish="Te permite saber al instante\ncuántos tesoros quedan en\nun determinado piso."})
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="You'll even know how much\ntreasure is hidden in the walls! Isn't it great?", french="Ça te dira même combien\nde trésors sont cachés dans les murs!\nGénial, non?", german="Dank ihr weißt du sogar, wie\nviele Schätze in den Wänden versteckt sind.\nIst das nicht super?", italian="Puoi addirittura scoprire quanti\ntesori nascosti ci sono dietro le pareti!\nNon è fantastico?", spanish="Sabrás hasta cuántos tesoros\nhay escondidos en los muros. ¿A que mola?"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 6] || scn($SCENARIO_MAIN) >= [7, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_jiguzaguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="Heh-heh-heh...\nThere's a new scent!", french="Hé hé hé...\nIl y a une nouvelle odeur!", german="Hehehe...\nEin neuer Geruch!", italian="Eh eh eh...\nC'è un nuovo odore!", spanish="Je, je, je...\n¡Una nueva fragancia!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 2] || scn($SCENARIO_MAIN) >= [7, 
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
