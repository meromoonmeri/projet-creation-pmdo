-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D25P11A/um2306.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 288, 224, Direction.UpLeft, "NPC_BIPPA")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Good morning, you all!", french=" Chalut la compagnie!", german=" Guten Morgen, Leute!", italian=" Ehi voi due, buongiorno!", spanish=" ¡Buenos días a todos!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Here's to another good day of\nexploring!", french="Encore une bonne journée\nd'exploration en vue!", german="Auf einen weiteren erfolgreichen\nTag voller Erkundungen!", italian="Un altro bel giorno per\nesplorare!", spanish="Nos espera otro gran día de\nexploración... ¡Sí, señor!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I'm gonna be looking forward to\nyour team's safe return, [hero]!", french="J'espère que tu r'viendras en\nun seul morceau, [hero]!", german="Ich freue mich auf die sichere\nRückkehr eures Teams, [hero]!", italian="Spero che la tua squadra torni\nsana e salva, [hero]!", spanish="¡Estaré esperando vuestro\nregreso, [hero]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Everyone's all checking into this\ndistortion of space thing, yup yup!", french="Tout l'monde est en train\nd'enquêter sur c'te drôle d'histoire de\ndistorsion spatiale, pour sûr.", german="Jeder befasst sich mit dieser\nRaumkrümmungsgeschichte, jawollja!", italian="Sono tutti presi da questa cosa\ndella distorsione dello spazio, sissignore.", spanish="Todo el mundo está pendiente de\nla deformación del espacio. ¡Sí, señor!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I'll be on my way as soon as I\nget ready!", french=" J'm'en vais dès qu'j'suis prêt!", german="Ich werde mich auf den Weg\nmachen, sobald ich fertig bin!", italian=" Parto non appena sono pronto!", spanish="¡Me pondré en marcha en cuanto\nesté listo!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 76] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="You all can go into the\ndream now?[K] That's mighty great news!", french="Ah, maintenant vous pouvez\nentrer dans l'rêve![K] En voilà une nouvelle\nqu'elle est bonne!", german="Ihr könnt jetzt den Traum\nbetreten?[K] Das sind richtig gute Neuigkeiten!", italian="Potete entrare nel\nsogno?[K] Che grande notizia!", spanish="¿Ahora podéis entrar en el\nsueño?[K] ¡Eso sí que son buenas noticias!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 73] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Oof...[K] What's happening to that\nlittle [CS:N]Azurill[CR] is worrisome...", french="Oh là là...[K] C'qui arrive au p'tit\n[CS:N]Azurill[CR], c'est vachement inquiétant...", german="Uff...[K] Was mit dem kleinen\n[CS:N]Azurill[CR] geschieht, ist beunruhigend...", italian="Puff...[K] Quello che sta\nsuccedendo ad [CS:N]Azurill[CR] è preoccupante...", spanish="Uf...[K] Lo que le está pasando al\npobre [CS:N]Azurill[CR] me tiene preocupado..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 71] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Good morning to you all!", french=" Chalut la compagnie!", german=" Guten Morgen, Leute!", italian=" Buon giorno!", spanish=" ¡Buenos días a todos!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I heard you solved the mysteries\nof [CS:P]Aegis Cave[CR]!", french="J'me suis laissé entendre dire\nqu'vous avez résolu l'énigme d'la [CS:P]Grotte Egide[CR]!", german="Ich habe gehört, dass ihr die\nGeheimnisse der [CS:P]Ägishöhle[CR] gelöst habt!", italian="Ho sentito che avete risolto i\nmisteri della [CS:P]Grotta Egida[CR]!", spanish="¡He oído que habéis resuelto los\nmisterios de la [CS:P]Cueva Regia[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" That's mighty great of you all!", french="Félicitations! Quel talent,\npour sûr!", german="Das ist eine reife Leistung von\neuch!", italian=" È grandioso!", spanish=" ¡Eso es genial!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 56) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="There's something mysterious\nabout [CS:P]Aegis Cave[CR]. I'm sure of it, yup yup!", french="La [CS:P]Grotte Egide[CR] a quequ'chose\nde mystérieux. Pas d'doute là-dessus, ma foi!", german="Die [CS:P]Ägishöhle[CR] hat etwas\nMysteriöses an sich. Da bin ich mir sicher,\njawollja!", italian="La [CS:P]Grotta Egida[CR] ha un non so che\ndi misterioso. Ne sono certo, sissignore!", spanish="Hay algo misterioso en la\n[CS:P]Cueva Regia[CR]. Estoy seguro... ¡Sí, señor!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="But what exactly is mysterious\nabout it? Golly, I wouldn't know...", french="Mais elle a quoi d'mystérieux,\nen fait? Ça, j'en sais carrément rien...", german="Aber was genau ist so mysteriös\nan ihr? Menschenskind, ich habe keine Ahnung...", italian="Ma cosa può esserci esattamente\ndi misterioso? Ohibò, non saprei...", spanish="Pero de qué se trata... Eso sí\nque no lo sé. ¡No, señor!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 55]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Oooh...[K] I get to explore with the\nlovely women of Team [CS:X]Charm[CR], by gosh...", french="Oooh...[K] Sapristi! J'vais partir\nen exploration avec les jouvencelles d'l'Equipe\n[CS:X]Charme[CR]...", german="Oooh...[K] Ich werde mit den\nreizenden Damen von Team [CS:X]Charme[CR] auf\nErkundung gehen, zum Donnerwetter...", italian="Oooh...[K] Vado in esplorazione con\nquelle bellezze del Team [CS:X]Malia[CR], ohibò...", spanish="¡Huyuyuy![K] Voy a explorar con las\nencantadoras señoritas del [CS:X]Equipo Carisma[CR],\ncaramba..."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="If the women of Team [CS:X]Charm[CR]\nnotice me...or praise me with a \"lookin' good\"...", french="Si ça s'trouve, les femmes\nd'l'Equipe [CS:X]Charme[CR] me f'ront p'têt' des\ncompliments...", german="Wenn die Damen von Team\n[CS:X]Charme[CR] mich wahrnehmen... Oder mir sogar\nKomplimente machen...", italian="E se le belle del Team [CS:X]Malia[CR] si\naccorgono di me... o mi dicono \"sei caruccio\"...", spanish="Si las preciosidades del [CS:X]Equipo[CR]\n[CS:X]Carisma[CR] advierten mi presencia o elogian\nmi aspecto..."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Or if they think I'm cute or\nsomething...[K] By golly...", french="Ou alors... elles m'trouveront\np'têt' mignon ou quequ'chose dans c'goût-là...[K]\nAh ben ça alors...", german="Oder falls sie denken, dass ich\nsüß bin oder so...[K] Menschenskind...", italian="O se pensano che io sia un bel\ntipo...[K] Ohibò...", spanish="O si piensan que soy mono o lo\nque sea...[K] Me voy a poner como un\ntomate..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Good morning to you all!", french=" Chalut la compagnie!", german=" Guten Morgen, Leute!", italian=" Buongiorno!", spanish=" ¡Buenos días a todos!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Yup yup! Here's to another good\nday of exploring!", french="Une nouvelle journée\nd'exploration nous attend, pour sûr!", german="Jawollja! Auf einen weiteren\nerfolgreichen Tag voller Erkundungen!", italian="Sissignore! Un altro bel giorno\nper esplorare!", spanish="Nos espera otro gran día de\nexploración... ¡Sí, señor!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 52) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 52]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Cheer up, you all!", french="Haut les cœurs! Faut pas\nvous laisser abattre, hein!", german=" Kopf hoch, Leute!", italian=" Coraggio, coraggio!", spanish=" ¡Tenéis que animaros!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 50] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Huh?![K] That little [CS:N]Manaphy[CR] has\ntaken ill?!", french="Hein?![K] Le p'tit [CS:N]Manaphy[CR],\nil est tombé malade?!", german="Was?!?[K] Das kleine [CS:N]Manaphy[CR] ist\nkrank geworden?!?", italian="Uh?![K] Quel piccolo [CS:N]Manaphy[CR]\nsi è ammalato?!", spanish="¿Qué?[K] ¿Que el pequeño [CS:N]Manaphy[CR]\nse ha puesto enfermo?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 48] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" That little kid was kinda cute...", french=" Ce p'tit gars était trop chou...", german="Der kleine Kerl\nwar ziemlich süß...", italian="Quel piccolino è proprio\nadorabile...", spanish=" Ese pequeñín era una monada..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 41] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Huh?![K] You all got to meet that\nfamous explorer [CS:N]Scizor[CR]?!", french="Hein?![K] Z'avez rencontré\nle fameux explorateur, [CS:N]Cizayox[CR]?!", german="Was?!?[K] Ihr habt den berühmten\nErkunder [CS:N]Scherox[CR] getroffen?!?", italian="Uh?![K] Voi due avete incontrato\n[CS:N]Scizor[CR], il famoso esploratore?!", spanish="¡¿Cómo?![K] ¡¿Que todos habéis\nconocido al famoso explorador [CS:N]Scizor[CR]?!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Oof...[K] By golly, I envy you.", french="Pfiou...[K] Comme j'vous\nenvie, z'avez pas idée.", german="Uff...[K] Menschenskind, ich\nbeneide euch.", italian=" Puff...[K] Ohibò, vi invidio.", spanish=" Uf...[K] Caramba, qué envidia."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 33] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Good morning to you all!", french=" Chalut la compagnie!", german=" Guten Morgen, Leute!", italian=" Buongiorno!", spanish=" ¡Buenos días a todos!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="As for me, I need to work on\ngraduating from the guild myself, yes I do!", french="Et moi, faut qu'j'me débrouille\npour décrocher mon diplôme aussi, ça s'rait\npas du luxe!", german="Was mich angeht, ich muss\nselbst auf die Gildenabschlussprüfung\nhinarbeiten. Ja, das muss ich!", italian="Anch'io devo mettermi al lavoro\nper prepararmi all'esame della Gilda,\nsissignore!", spanish="En cuanto a mí, tengo que\ntrabajar para superar el gran reto yo\ntambién. ¡Sí, señor!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Here's to another good day of\nexploring, yup yup!", french="Encore une bonne journée\nd'exploration qui nous attend, ma foi!", german="Auf einen weiteren erfolgreichen\nTag voller Erkundungen, jawollja!", italian="Un altro bel giorno per\nesplorare, sissignore!", spanish="Nos espera otro gran día de\nexploración... ¡Sí, señor!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 31] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Good morning to you all!", french=" Chalut la compagnie!", german=" Guten Morgen, Leute!", italian=" Buongiorno!", spanish=" ¡Buenos días a todos!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Even after you graduate from\nthe guild, you can surely keep up with your\nexploring, yup yup!", french="Z'allez pouvoir continuer\nà explorer même après avoir décroché\nvot' diplôme de la Guilde! Ouaip ouaip!", german="Selbst nach der\nGildenabschlussprüfung könnt ihr weiter auf\nErkundung gehen, jawollja!", italian="Anche dopo aver passato l'esame\ndella Gilda, potrete sicuramente continuare\na esplorare, sissignore!", spanish="Una vez superado el gran reto\ndel [CS:N]Pokégremio[CR], podéis seguir explorando."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="...Huh?[K] You all are asking me\nwhere you ought to go exploring?", french="... Hein, quoi?[K] C'est à moi\nqu'vous demandez quel endroit faut explorer?", german="...Wie?[K] Ihr fragt mich, wo ihr\nerkunden gehen solltet?", italian="Uh?[K] Mi state chiedendo dove\ndovreste andare a esplorare voi due?", spanish="¿Qué?[K] ¿Me estáis preguntando\nadónde ir a explorar?"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Oof...[K] Well, I wouldn't know how\nto answer that for you all.", french="Pfiou...[K] Ben j'en ai pas\nla moindre idée, moi, pardi!", german="Uff...[K] Nun, das kann ich euch\nnicht beantworten.", italian="Puff...[K] Beh, non saprei cosa\nrispondervi.", spanish=" Uf...[K] No sabría qué deciros."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="But...[K]you'd all have to agree with\nme that there are still plenty of mysteries in\nthis here world of ours.", french="Mais...[K] faut ben avouer\nqu'il reste des tas d'endroits mystérieux\nà découvrir dans c'monde.", german="Aber[K] ihr werdet mir\nbeipflichten, wenn ich sage, dass es noch genug\nGeheimnisse in dieser unserer Welt gibt.", italian="Ma...[K] ma voi due concorderete\nsul fatto che il nostro mondo sia ancora pieno\ndi misteri da risolvere...", spanish="Pero...[K] estaréis de acuerdo\nconmigo en que hay un montón de misterios\npor resolver en este mundo."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I'm sure that you all will want\nto probe and explore places like that.", french="Et j'suis sûr que vous mourez\nd'envie d'aller explorer des endroits\ncomme ça.", german="Ich bin mir sicher, dass ihr\nsolche Orte erforschen und erkunden wollt.", italian="Sono sicuro che voi due vorrete\nancora esplorare ed esaminare posti così.", spanish="Seguro que querréis explorar e\ninvestigar en lugares así."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="So keep checking the guild's\ntwo boards for jobs just like always.", french="Alors continuez à consulter\nles deux tableaux à la Guilde pour trouver\ndes missions, comme d'hab.", german="Also überprüft wie üblich die\nJobs auf den beiden Gilden-Infobrettern.", italian="Quindi continuate a controllare\nle Bacheche alla Gilda, come sempre.", spanish="Así que estad siempre al tanto\nde las nuevas misiones que aparezcan\nen los dos tablones."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="After you do more jobs, I bet\nsomething new will brew on the horizon.[K]\nYup yup, I just can't shake that feeling!", french="Si vous faites plein d'missions,\nj'parie qu'vous aurez de bonnes surprises.[K]\nOuais, je l'sens d'ici, le fumet d'la nouveauté!", german="Nach einigen weiteren Jobs wird\nsich etwas Neues für euch ergeben.[K] Jawollja,\nich habe es im Gefühl.", italian="Dopo aver fatto alcune missioni,\nscommetto che cambierà qualcosa\nall'orizzonte.[K] Sissignore, me lo sento!", spanish="Cuando realicéis más misiones,\nalgo pasará...[K] Sí, señor... ¡Estoy seguro!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="As for me, I need to work on\ngraduating from the guild myself, yes I do!", french="Et moi, faut qu'j'me débrouille\npour décrocher mon diplôme aussi, ça s'rait\npas du luxe!", german="Was mich angeht, ich muss\nselbst auf die Gildenabschlussprüfung\nhinarbeiten. Ja, das muss ich!", italian="Anch'io devo mettermi al lavoro\nper prepararmi all'esame della Gilda,\nsissignore!", spanish="En cuanto a mí, tengo que\ntrabajar para superar el gran reto yo\ntambién, ¡caramba!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Here's to another good day of\nexploring, yup yup!", french="Encore une bonne journée\nd'exploration qui nous attend, ma foi!", german="Auf einen weiteren erfolgreichen\nTag voller Erkundungen, jawollja!", italian="Un altro bel giorno per\nesplorare, sissignore!", spanish="Nos espera otro gran día de\nexploración... ¡Sí, señor!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 4]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Oof...[K] I wouldn't know anything\nabout that at all...", french="Pfff...[K] J'en sais rien du tout,\nmais alors là, rien d'chez rien...", german="Uff...[K] Darüber weiß ich rein gar\nnichts...", italian="Puff...[K] Non ne so proprio\nnulla...", spanish=" Uf...[K] No tengo ni idea..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 3] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Huh?[K] The grand master of all\nthings bad?", french="Hein?[K] L'grand maître\nde tous les maux?", german="Wie?[K] Der Großmeister allen\nÜbels?", italian=" Eh?[K] Sua Malvagità?", spanish="¿Qué?[K] ¿El gran malo\nrequetemalo?"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Oof...[K] You know I haven't been\nat the guild much longer than you all.", french="Oh...[K] Moi, vous savez, j'fais pas\npartie de la Guilde depuis très longtemps non\nplus.", german="Uff...[K] Ihr wisst, ich bin noch\nnicht viel länger in der Gilde als ihr.", italian="Puff...[K] Sapete, non venivo alla\nGilda da molto più tempo di voi due.", spanish="Uf...[K] Yo es que no llevo mucho\ntiempo en el [CS:N]Pokégremio[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I couldn't tell you all about that\ngraduation exam if I wanted to, I swear.", french="Même si je l'voulais, j'pourrais\npas vous dire grand-chose sur l'examen\nd'la Guilde, j'vous jure.", german="Selbst wenn ich wollte, könnte\nich euch nicht alles über die Abschlussprüfung\nerzählen, das schwöre ich.", italian="Anche volendo, non potrei dirvi\nnulla sull'esame di diploma della Gilda, lo giuro.", spanish="No podría contaros nada sobre\nel gran reto aunque quisiera, lo juro."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" I'm sorry...", french=" J'suis désolé...", german=" Es tut mir leid...", italian=" Sono spiacente...", spanish=" Lo siento..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Oof...[K] I can't do anything for\nyou all but give encouragement. It frustrates\nme something awful!", french="Pfiou...[K] Tout c'que j'peux faire,\nc'est vous encourager. C'est frustrant,\nz'avez pas idée!", german="Uff...[K] Außer euch Mut\nzuzusprechen, kann ich nichts für euch tun. Das\nfrustriert mich ungemein!", italian="Puff...[K] Non posso far altro\nche darvi il mio incoraggiamento.\nÈ frustrante all'inverosimile!", spanish="Uf...[K] Lo único que puedo hacer\nes animaros. ¡Cómo me está frustrando!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" But...[K]you all get it done now!", french="Mais...[K] allez-y, faut\nrégler c't'affaire!", german=" Aber...[K] Ihr schafft das schon!", italian="Ma...[K] voi due ce la dovete\nfare!", spanish=" Pero...[K] ¡lo conseguiréis!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="You all don't fail us now! Stop\nour planet from becoming paralyzed! You hear?", french="On compte tous sur vous! Faut\nsurtout pas qu'la planète soit paralysée!\nPigé?", german="Enttäuscht uns jetzt nicht! Haltet\ndie Lähmung des Planeten auf, hört ihr?", italian="Non potete fallire! Impedite che\nil nostro pianeta si paralizzi! Avete\ncapito?", spanish="¡No nos falléis ahora! ¡No\npermitáis que el planeta se paralice!\n¿Me oís?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Golly, this surely isn't easy.[K]\nBut I'm not giving up, no sirree!", french="C'est pas facile, pour sûr.[K]\nMais j'abandonnerai pas, ah ça non!", german="Menschenskind, das ist echt\nnicht einfach.[K] Aber ich gebe nicht auf,\nnein, wirklich nicht!", italian="Ohibò, non sarà per nulla\nfacile.[K] Ma non mollerò, nossignore!", spanish="Esto no es fácil, caramba.[K]\nPero no me voy a rendir... ¡No, señor!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 3] || scn($SCENARIO_MAIN) >= [23
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I'm getting kitted out to prepare\nto go to [CS:P]Brine Cave[CR]... Huff-huff...", french="J'fais mes préparatifs pour\naller à la [CS:P]Caverne Saline[CR]... Pfiou, pfiou...", german="Ich rüste mich aus, um mich\nauf die Reise zur [CS:P]Salzwasserhöhle[CR]\nvorzubereiten... Keuch, keuch...", italian="Mi sto preparando per andare\nalla [CS:P]Grotta Salmastra[CR]... Uffi-uff...", spanish="Me estoy equipando para ir\na la [CS:P]Cueva Aguamar[CR]... Uf, uf..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 1] || scn($SCENARIO_MAIN) >= [22
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I've been telling everyone the\ntruth, by golly!", french="J'ai dit la vérité à tout\nl'monde, pardi!", german="Menschenskind, ich habe allen die\nWahrheit erzählt!", italian=" Ohibò, ho detto a tutti la verità!", spanish="¡Le he dicho la verdad a todo\nel mundo!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Folks find it a hard tale to\nswallow. But I'm winning them over with my\nhonesty.", french="Les gens, ils trouvent ça dur\nà avaler. Mais vu qu'j'suis honnête, j'arrive\nà les convaincre.", german="Die Leute können die Geschichte\nnur schwer verdauen. Aber ich überzeuge sie\nmit meiner Ehrlichkeit.", italian="È una storia difficile da digerire\nper la gente. Ma grazie alla mia onestà li\nsto convincendo.", spanish="A la gente le cuesta creérselo,\npero me los voy ganando poco a poco\ncon mi sinceridad."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I'm surely getting through to\nfolks, yup yup!", french="Moi, j'ai du bagou avec\nles gens, pardi!", german="Mit Leuten kann ich umgehen,\njawollja!", italian="Io con la gente riesco a\ncomunicare, sissignore!", spanish="Estoy convenciendo a los demás.\n¡Sí, señor!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I've been spreading that rumor\nthe best I could, yup yup!", french="J'ai fait d'mon mieux pour\nrépandre c'te rumeur, ouaip ouaip!", german="Ich habe das Gerücht so gut es\nging verbreitet. Jawollja!", italian="Ho sparso il più possibile la\nvoce, sissignore!", spanish="He extendido el rumor lo mejor\nposible, ¡sí, señor!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(16, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I'll get out there again as soon\nas I get geared up, yup yup!", french="Sapristi, j'y r'tourne dès que\nj'suis prêt!", german="Ich gehe zurück, sobald ich\nfertig ausgerüstet bin, jawollja!", italian="Uscirò di nuovo non appena mi\nsarò attrezzato, sissignore!", spanish="¡Me pondré en marcha en cuanto\nesté preparado! ¡Sí, señor!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Off to [CS:P]Crystal Crossing[CR]!\nYup yup!", french="En route pour le [CS:P]Croisement\nCristal[CR]! Ouaip ouaip!", german=" Zur [CS:P]Kristallstraße[CR]! Jawollja!", italian="Al [CS:P]Bivio di Cristallo[CR]!\nSissignore!", spanish="¡A la [CS:P]Vía Cristalina[CR]!\n¡Sí, señor!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 0] || scn($SCENARIO_MAIN) >= [15
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Um...[K] Have you all happened to\nsee [CS:N]Dugtrio[CR] anywhere?", french="Hmm...[K] Z'auriez pas vu\n[CS:N]Triopikeur[CR], par hasard?", german="Ähm...[K] Hat jemand von euch\n[CS:N]Digdri[CR] gesehen?", italian="Uhm...[K] Per caso voi due avete\nvisto [CS:N]Dugtrio[CR] da qualche parte?", spanish="Hum...[K] ¿Alguien ha visto a\n[CS:N]Dugtrio[CR]?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 1]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I have to get a move on and\npack... Huff-huff...", french="Faut qu'j'fasse mon paquetage\ndare-dare... Pfiou, pfiou...", german="Ich muss mich beeilen und\npacken... Keuch, keuch...", italian="Devo darmi una mossa e\npreparare tutto... Uffi-uff...", spanish="Tengo que espabilarme y\nponerme a hacer la bolsa..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [13, 2] || scn($SCENARIO_MAIN) >= [13
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="The great [CS:N]Dusknoir[CR] gave me\npointers on exploring, by golly.", french="L'grand [CS:N]Noctunoir[CR], il m'a filé\ndes tuyaux d'explorateur, pardi.", german="Menschenskind, der große\n[CS:N]Zwirrfinst[CR] hat mir Erkundungstipps gegeben!", italian="Il grande [CS:N]Dusknoir[CR] mi ha dato\ndei suggerimenti su come esplorare, ohibò.", spanish="¡Huyuyuy! ¡El gran [CS:N]Dusknoir[CR] me\nha dado consejos de exploración!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="He's given me a shot of\nconfidence in myself, yup yup!", french="Il m'a sacrément redonné\nconfiance en moi, ah ça oui!", german="Dadurch habe ich auch eine\nordentliche Prise Selbstwusstsein erhalten,\njawollja!", italian="Mi ha trasmesso sicurezza e\nfiducia in me stesso, sissignore!", spanish="¡Me ha dado seguridad en mí\nmismo! ¡Sí, señor!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I've got the spirit for a great\nday of training! It's called being positive,\nby gosh!", french="J'me sens d'humeur pour une\nbonne journée d'entraînement, pour sûr!\nC'est c'qui s'appelle positiver, sapristi!", german="Ich bin bereit für einen tollen\nTrainingstag! Das nennt man positives Denken,\nzum Donnerwetter!", italian="Sono proprio dello spirito giusto\nper una grande giornata d'allenamento! Questo\nsi chiama essere ottimisti, ohibò!", spanish="Estoy muy motivado para el\nentrenamiento de hoy. ¡Me siento\noptimista! ¡Sí, señor!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 4] || scn($SCENARIO_MAIN) >= [12
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Oooh...[K] The great [CS:N]Dusknoir[CR] shook\nmy hand! By gosh and by golly...", french="Oooh...[K] L'grand [CS:N]Noctunoir[CR],\nil m'a serré la patte! J'en crois pas mes\nmirettes...", german="Oooh...[K] Der große [CS:N]Zwirrfinst[CR] hat\nmeine Hand geschüttelt. Donnerwetter noch\nmal!", italian="Oooh...[K] Il grande [CS:N]Dusknoir[CR] mi\nha stretto la mano! Ohibò e ancora ohibò...", spanish="Oh...[K] ¡El gran [CS:N]Dusknoir[CR] me ha\ndado la mano! Madre mía, qué emoción..."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" It's like...[K] Like a dream...[K] Wow...", french="C'est comme...[K] comme un rêve...\nWaouh...", german="Es ist wie...[K] wie ein Traum...[K]\nBeeindruckend...", italian="È come...[K] Come un sogno...[K]\nWow...", spanish="Es como...[K] Como un sueño...[K]\nGuau..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(9, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [9, 5]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="We just have to cross this here\nmountain! That's all! Then we'll be at the base\ncamp, yup yup!", french="Tout c'qu'il nous reste à faire,\nc'est d'traverser c'te montagne, là. Et après\non sera arrivés au camp d'base, ouaip ouaip!", german="Alles, was wir jetzt tun müssen,\nist diesen Berg hinter uns zu lassen. Dann sind\nwir am Basislager! Jawollja!", italian="Dobbiamo solo oltrepassare\nquesta montagna! Tutto qui! Poi saremo al\nCampo Base, sissignore!", spanish="¡Solo tenemos que atravesar la\nmontaña y llegaremos al campamento\nbase! ¡Sí, señor!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Let's do it!", french=" On y va!", german=" Wir können das schaffen!", italian=" Mettiamocela tutta!", spanish=" ¡Hagámoslo!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(9, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [9, 4]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="All we gotta do now is cross\nover this here mountain. Then we'll be at base\ncamp! Yup yup!", french="Tout c'qu'il nous reste à faire,\nc'est d'traverser c'te montagne, là. Et après\non sera arrivés au camp d'base, ouaip ouaip!", german="Alles, was wir jetzt tun müssen,\nist diesen Berg hinter uns zu lassen. Dann sind\nwir am Basislager! Jawollja!", italian="Dobbiamo solo oltrepassare\nquesta montagna. Poi saremo al campo base!\nSissignore!", spanish="Solo hay que atravesar esta\nmontaña y llegaremos al campamento\nbase. ¡Sí, señor!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Let's do it!", french=" On y va!", german=" Wir können das schaffen!", italian=" Ce la possiamo fare!", spanish=" ¡Podemos hacerlo!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(9, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [9, 2]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" We'll get it done next time!", french=" La prochaine fois, on y arrivera!", german="Beim nächsten Mal schaffen wir\ndas!", italian=" La prossima volta ce la faremo!", spanish=" ¡Mejor la próxima vez!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [9, 1]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Oooh...[K] It's my first expedition!\nI don't have a clue what items I should take.", french="Baaah...[K] C'est ma première\nexpédition et j'sais pas trop quels objets\nj'devrais prendre.", german="Oooh...[K] Es ist meine erste\nExpedition. Ich habe keine Ahnung, welche\nItems ich mitnehmen soll.", italian="Oooh...[K] È la mia prima\nspedizione! Non so assolutamente che\nstrumenti portarmi.", spanish="¡Huyuyuy![K] ¡Esta es mi primera\nexpedición! No sé qué objetos debería\nllevar."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I want to go on that expedition\nwith your team, [hero]. Yup yup!", french="J'veux partir en expédition\navec ton équipe, [hero], pour sûr!", german="Ich möchte mit eurem Team auf\ndiese Expedition gehen, [hero]. Jawollja!", italian="Vorrei partecipare a una spedi-\nzione con la vostra squadra, [hero].\nSissignore!", spanish="Quiero ir de expedición con tu\nequipo, [hero]. ¡Sí, señor!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Let's get it done!", french=" Faut y aller! C'est parti!", german=" Erledigen wir das!", italian=" Facciamogli vedere chi siamo!", spanish=" ¡Hagámoslo!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 2] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="There's something mighty\npuzzling...", french="Y'a quequ'chose qui\nm'chiffonne un chouïa...", german="Irgendetwas ist mächtig\nrätselhaft...", italian="C'è qualcosa che mi lascia\nmolto perplesso...", spanish=" Hay algo muy extraño..."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Yup yup. I can't help thinking\nthat our larder is going down much faster than\nit should be...", french="C'est ben vrai, j'peux pas\nm'empêcher d'penser qu'nos provisions,\nelles diminuent plus vite que prévu...", german="Jawollja. Ich habe irgendwie das\nGefühl, dass sich unsere Speisekammer\nviel schneller leert, als sie sollte...", italian="Sissignore. Non riesco a essere\nd'aiuto perché penso alla nostra dispensa che\nsi sta svuotando più in fretta del normale...", spanish="Sí, señor. No dejo de pensar que\nnuestra despensa se vacía demasiado\nrápido..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 6) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 6]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Yup yup! I'm glad I'm out from\nunder that cloud of suspicion. No one's giving\nme the stink eye anymore!", french="Pour sûr, j'suis soulagé de plus\nêt' accusé comme ça. On m'regarde plus\ncomme si j'sentais l'castor!", german="Jawollja! Ich bin froh, dass ich\nnicht mehr unter Verdacht stehe. Niemand ist\nmehr ablehnend mir gegenüber!", italian="Sissignore! Sono contento di non\nessere più al centro di quel nugolo di sospetti.\nNiente più occhiatacce!", spanish="¡Huyuyuy! Me alegro de no ser\nsospechoso. Ya me han quitado los\nojos de encima..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 3] || scn($SCENARIO_MAIN) >= [7, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Ewww! What an eye-watering\nstink cloud!", french="Beurk! Ça fouette, j'en ai\nles yeux qui piquent!", german="Bäh! Die Stinkwolke treibt\neinem ja die Tränen in die Augen!", italian=" Bleah! Che puzza insopportabile!", spanish=" ¡Huy! ¡Qué peste!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Now don't you all look at me\nlike that. Gosh, it's not nice to stare!", french="C'est bon, me r'gardez pas\ncomme ça, c'est pas moi! Sapristi, ça s'fait\npas d'fixer les gens!", german="Jetzt schaut mich nicht so an.\nZum Donnerwetter, es ist nicht nett, so zu\ngaffen!", italian="Non guardatemi così.\nOhibò, non si fissano gli altri!", spanish="¡No me miréis todos así,\ncaramba! ¡No es de buena educación!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="By golly, I tell you it has nothing\nto do with me, no sirree!", french="Bon sang, puisque j'vous dis\nqu'j'y suis pour rien! Pour une fois, c'est\npas moi, ah ça non!", german="Zum Donnerwetter, ich sage\neuch, das hat nichts mit mir zu tun, nein,\nwirklich nicht!", italian="Ohibò, vi dico che io non\nc'entro nulla, nossignore!", spanish="Yo no tengo nada que ver.\n¡No, señor!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 1] || scn($SCENARIO_MAIN) >= [6, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Huh?![K] You all have been assigned\nto investigate that waterfall?!", french="Heiiin?![K] C'est vous qu'allez\npartir inspecter la cascade?!", german="Hä?!?[K] Ihr habt den Auftrag, den\nWasserfall auszukundschaften?!?", italian="Uh?![K] Hanno deciso di mandare\nvoi due a esaminare quella cascata?!", spanish="¡¿Qué?![K] ¿Os han ordenado investigar\nesa cascada?"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="It'll be your first exploration![K]\nI'm pulling for you to succeed, by gosh!", french="C'est vot' première mission\nd'exploration![K] Pour sûr, j'suis d'tout cœur\navec vous!", german="Das wird eure erste\nErkundung![K] Ich drücke euch die Daumen,\nzum Donnerwetter!", italian="Sarà la vostra prima\nesplorazione![K] Ohibò, spero che sia un\nsuccesso!", spanish="¡Será vuestra primera exploración![K]\n¡Os deseo lo mejor! ¡Sí, señor!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Now, you all dig into that\nchallenge really hard now!", french="Ben il vous reste plus qu'à vous\nmettre au travail sérieusement, ouaip!", german="Dann stellt euch mal dieser\nHerausforderung und gebt euer Bestes!", italian="State lavorando\nduramente per questa sfida!", spanish=" Ahora, ¡a trabajar duro!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(5, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [5, 5]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I'm going on an exploration with\n[CS:N]Sunflora[CR], but...", french="J'pars en exploration avec\n[CS:N]Héliatronc[CR], mais...", german="Ich gehe mit [CS:N]Sonnflora[CR] auf eine\nErkundung, aber...", italian="Sto andando ad esplorare con\n[CS:N]Sunflora[CR], ma...", spanish="Voy a explorar con [CS:N]Sunflora[CR],\npero..."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Oof...[K] I tell you, I'm feeling\nless than mighty confident.", french="Baaah...[K] J'vous l'dis, j'me sens\npas des masses en confiance.", german="Uff...[K] Ich sage euch, ich bin\nnicht gerade sehr zuversichtlich.", italian="Puff...[K] Vi dirò, non sono\nparticolarmente fiducioso.", spanish="Uf...[K] Me siento un poco inseguro,\nla verdad."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 7]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="So you all ran off the other day\nbecause you had to rescue little [CS:N]Azurill[CR]!", french="Ah bon! L'aut' jour, si vous avez\nfilé en quatrième vitesse, c'est à cause que\nvous deviez sauver le p'tit [CS:N]Azurill[CR]!", german="Ihr seid also neulich losgelaufen,\nweil ihr den kleinen [CS:N]Azurill[CR] befreien musstet.", italian="L'altro giorno eravate di fretta\nperché dovevate soccorrere quel piccolo\n[CS:N]Azurill[CR].", spanish="¡Así que teníais que rescatar\nal pobre [CS:N]Azurill[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="By golly, I'm impressed that you\ncaught yourselves an outlaw in the process!", french="Pour sûr, j'arrive pas à croire\nque vous ayez épinglé un hors-la-loi au\npassage!", german="Donnerwetter, ich bin\nbeeindruckt, dass ihr während des Ganzen noch\neinen Ganoven gefangen genommen habt!", italian="Ohibò, sono rimasto\nimpressionato dal modo in cui avete\ncatturato il fuorilegge!", spanish="¡Caramba, estoy impresionado!\n¡Y, encima, atrapasteis a un malhechor!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Yup yup, I need to pick up the\npace. Can't have you rookies showing me up!", french="Faut que j'suive le rythme, ma\nfoi. J'peux pas laisser la bleusaille\nm'faire honte!", german="Jawollja. Ich muss mich beeilen.\nKann mich doch nicht von euch Anfängern\nvorführen lassen!", italian="Sissignore, devo tenere il passo.\nNon posso fare una brutta figura con delle\nreclute, ohibò.", spanish="Tengo que cogeros el ritmo,\n¡sí, señor! ¡No puedo permitir que\nlos novatos me dejen en evidencia!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 5]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="The other day, you all went off\nrunning in a mighty rush.", french="L'aut' jour, z'avez filé en\nquatrième vitesse, ma foi!", german="Neulich seid ihr in einem\nganz schönen Tempo losgelaufen.", italian="L'altro giorno, voi due avete\nlasciato la Gilda di gran fretta.", spanish="El otro día salisteis de aquí\npitando."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" What was that all about?", french=" Qu'est-ce qui vous a pris?", german=" Worum ging es da?", italian=" Ma come mai?", spanish=" ¿Qué pasó?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 3]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  SkySceneKit.play_scene("g01p03a__m03a050100", "g01p03a__m03a0501", hero, partner) -- supervision_ExecuteActing(LEVEL_G01P03A, 'M03A0501', 0) [chaînage scène ROM]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 2] || scn($SCENARIO_MAIN) >= [4, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
