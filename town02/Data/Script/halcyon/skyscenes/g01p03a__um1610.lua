-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/um1610.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 416, 248, Direction.DownLeft, "NPC_HEIGANI")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! Let's have another fun\nday of exploring, hey, hey!", french="Eh dis donc! Encore une folle\njournée d'exploration devant nous!", german="Hey, hey! Auf einen weiteren\nspaßigen Erkundungstag, hey, hey!", italian="Ehi, ehi! Un'altra divertente\ngiornata d'esplorazione, ehi, ehi!", spanish="¡Oye, oye! ¡Divirtámonos\nexplorando un día más!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! Don't let that [CS:N]Darkrai[CR]\nbeat you now, hey, hey!", french="Eh dis donc! Ne laissez pas\nl'ignoble [CS:N]Darkrai[CR] vous vaincre!", german="Hey, hey! Lass dich jetzt bloß\nnicht von diesem [CS:N]Darkrai[CR] schlagen, hey, hey!", italian="Ehi, ehi! Non permettete a quel\n[CS:N]Darkrai[CR] di battervi, ehi, ehi!", spanish="¡Oye, oye! ¡No permitáis que ese\n[CS:N]Darkrai[CR] os derrote!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! That [CS:N]Drowzee[CR] really\ndid turn his life around...", french="Eh dis donc! Ce [CS:N]Soporifik[CR]\na complètement changé de vie...", german="Hey, hey! Dieser [CS:N]Traumato[CR] hat\nsein Leben wirklich umgekrempelt...", italian="Ehi, ehi! Quel [CS:N]Drowzee[CR] ha\ndavvero cambiato vita...", spanish="¡Oye, oye! [CS:N]Drowzee[CR] ha cambiado\nde vida..."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="I feel bad for doubting him...\nHey, hey...", french="Je m'en veux d'avoir douté de\nlui, dis donc...", german="Ich fühle mich schlecht, weil ich\nan ihm gezweifelt habe... Hey, hey...", italian="Mi sento in colpa per aver\ndubitato di lui... Ehi, ehi...", spanish="Me siento mal por haber dudado\nde él."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 73] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! You have to find\n[CS:N]Drowzee[CR]!", french="Eh dis donc! Vous devez\ntrouver [CS:N]Soporifik[CR]!", german="Hey, hey! Ihr müsst [CS:N]Traumato[CR]\nfinden!", italian="Ehi, ehi! Dovete trovare\n[CS:N]Drowzee[CR]!", spanish="¡Oye, oye! ¡Tenéis que encontrar\na [CS:N]Drowzee[CR]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 71] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! So tell me, what were\nthe mysteries of [CS:P]Aegis Cave[CR]?", french="Eh dis donc! Alors dites-moi,\nc'était quoi, l'énigme de la [CS:P]Grotte Egide[CR]?", german="Hey, hey! Nun sagt schon, was\nwar das Geheimnis der [CS:P]Ägishöhle[CR]?", italian="Ehi, ehi! Ditemi dunque, quali\nerano i misteri della [CS:P]Grotta Egida[CR]?", spanish="¡Oye, oye! Contadme, ¿cuáles\neran los misterios de la [CS:P]Cueva Regia[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="...[K]...[K]Uh-huh...[K] Hey, hey, I\ndon't understand any of it, hey...", french="...[K] ...[K] Oui, oui...[K] Eh dis donc,\nj'y comprends rien du tout...", german="...[K] ...[K]Aha...[K] Hey, hey, ich\nverstehe rein gar nichts, hey...", italian="...[K]...[K] Uh...[K] Ehi, ehi, non ho\ncapito nulla, ehi...", spanish="¿Eh?...[K] ¿Sí?...[K] Ajá...[K] No entiendo\nnada, oye."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 56) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="I'm no good with mysteries and\nthings using my head, hey, hey, hey...", french="Je ne suis pas très doué pour\nles énigmes ou les trucs pour lesquels il faut\nréfléchir, dis donc...", german="Bei Rätseln oder anderen Dingen,\nbei denen ich meinen Kopf einsetzen muss, bin\nich nicht sonderlich gut, hey, hey, hey...", italian="Non sono bravo quando si tratta\ndi usare la testa per risolvere misteri e altre\ncose, ehi, ehi, ehi...", spanish="¡Oye, oye! No se me dan bien los\nmisterios y las cosas de pensar mucho..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 55]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey, hey![K] Hey, hey, hey!", french="Eh dis donc![K] Eh dis donc!\nEh dis donc!", german=" Hey, hey, hey![K] Hey, hey, hey!", italian=" Ehi, ehi, ehi![K] Ehi, ehi, ehi!", spanish=" ¡Oye, oye![K] ¡Oye, oye!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Let's have another fun day of\nexploring, hey, hey!", french="Eh dis donc! Encore une folle\njournée d'exploration devant nous!", german="Auf einen weiteren spaßigen\nErkundungstag, hey, hey!", italian="Avanti, un'altra divertente\ngiornata d'esplorazione, ehi, ehi!", spanish="¡Oye, oye! ¡Divirtámonos\nexplorando un día más!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 52) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 52]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="He may come back one day,\nhey, hey?", french="Peut-être qu'il reviendra\nun jour, dis donc?", german="Vielleicht kommt es eines Tages\nzurück, hey, hey?", italian="Potrà tornare un giorno, ehi,\nehi?", spanish="¡Oye, oye! Puede que algún día\nregrese, ¿no creéis?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 50] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="That baby [CS:N]Manaphy[CR] must only\ngrow in the sea, hey, hey...", french="Ce bébé [CS:N]Manaphy[CR]\nne peut grandir que dans la mer, dis donc...", german="Das kleine [CS:N]Manaphy[CR] kann nur im\nMeer aufwachsen, hey, hey...", italian="Quel piccolo [CS:N]Manaphy[CR] deve\ncrescere nel mare, ehi, ehi...", spanish="El pequeño [CS:N]Manaphy[CR] tiene que\ncrecer en el mar..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 48] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey![K] What happened to that\nlittle baby?", french="Eh dis donc![K] Qu'est-ce qui lui\nest arrivé, à ce petit bébé?", german="Hey, hey![K] Was ist dem Kleinen\nzugestoßen?", italian="Ehi, ehi![K] Cos'è successo a quel\npiccoletto?", spanish="¡Oye, oye![K] ¿Qué le ha pasado\nal pobre bebé?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 41) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 41]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey, you two![K] So what'd\n[CS:N]Sunflora[CR] say, hey, hey?", french="Eh dis donc, vous deux![K]\nAlors, elle vous a raconté quoi, [CS:N]Héliatronc[CR],\ndis donc?", german="Hey, hey, ihr zwei![K] Was hat\n[CS:N]Sonnflora[CR] denn gesagt, hey, hey?", italian="Ehi, ehi, voi due![K] Allora? Cos'ha\ndetto [CS:N]Sunflora[CR], ehi, ehi?", spanish="¡Oye, oye, pareja![K] ¿Qué os contó\n[CS:N]Sunflora[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="...[K]Oh yeah...[K]Uh-huh...[K]\nGotcha, hey, hey.", french="...[K] Oh d'accord...[K] Je vois...[K]\nPigé, dis donc.", german="...[K]Oh ja...[K] Aha...[K] Verstanden,\nhey, hey.", italian="...[K] Oh sì...[K] Eh...[K]\nAfferrato, ehi, ehi.", spanish="¿Eh?...[K] Ah, sí...[K] Ajá...[K]\nYa lo pillo."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="[CS:N]Sunflora[CR] gets kind of confusing\nwhen she's really excited, hey. So I didn't\nget what she was saying, hey, hey?", french="[CS:N]Héliatronc[CR] perd un peu\nles pétales quand elle s'emballe, dis donc. Du\ncoup, je n'ai pas bien compris ce qu'elle a dit!", german="[CS:N]Sonnflora[CR] wirkt verwirrt, wenn\nsie aufgeregt ist, hey, hey. Ich habe also nicht\nverstanden, was sie gesagt hat, hey, hey!", italian="[CS:N]Sunflora[CR] quand'è davvero\nemozionata entra in confusione, ehi. È per\nquesto che non capivo cosa diceva, ehi, ehi?", spanish="[CS:N]Sunflora[CR] puede ser un poco\nconfusa cuando se emociona. Oye, tal vez\nno la entendí bien..."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="But now that I hear it from you,\nhey, hey, it does sound epic and adventurous!", french="Mais maintenant que vous me le\ndites, ça fleure bon le parfum de l'aventure,\ndis donc!", german="Aber jetzt, wo ich es von euch\nhöre, hey, hey, klingt es episch und\nabenteuerlich zugleich!", italian="Ma ora che lo sento da voi, ehi,\nehi, sembra davvero una cosa avventurosa,\nehi, ehi!", spanish="Ahora que me lo contáis, me\nsuena más épico."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="The [CS:P]Surrounded Sea[CR]...[K] What sort\nof treasures do you think one would find there,\nhey, hey, hey?", french="La [CS:P]Mer Fermée[CR]...[K]\nQuel genre de trésors est-ce qu'on pourrait\ntrouver là-bas, à votre avis, dis donc?", german="Das [CS:P]Ringmeer[CR]...[K] Welche Art\nvon Schätzen sind dort deiner Meinung nach zu\nfinden, hey, hey, hey?", italian="Il [CS:P]Mar Cinto[CR]...[K] Che tipo di\ntesori pensate si possano trovare laggiù,\nehi, ehi, ehi?", spanish="El [CS:P]Mar Circundante[CR]...[K] ¿Qué clase\nde tesoros habrá allí?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 40) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 40]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! Another great day!", french="Eh dis donc! Encore une belle\njournée qui s'annonce!", german="Hey, hey! Ein weiterer toller\nTag!", italian="Ehi, ehi! Un'altra grande\ngiornata!", spanish=" ¡Oye, oye! ¡Otro gran día!"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="You know something...[K] [CS:N]Sunflora[CR]\nhas been pretty excited lately, hey, hey!", french="Vous savez quoi?[K] [CS:N]Héliatronc[CR]\nest complètement surexcitée depuis quelque\ntemps, dis donc!", german="Wisst ihr was...[K] [CS:N]Sonnflora[CR] ist\nin letzter Zeit ziemlich aufgeregt gewesen,\nhey, hey!", italian="Sapete...[K] [CS:N]Sunflora[CR] è\npiuttosto emozionata ultimamente, ehi, ehi!", spanish="¿Sabíais que...?[K] ¿Sabíais que\n[CS:N]Sunflora[CR] ha estado muy nerviosa\núltimamente?"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Saying stuff like...[K] \"Oh my gosh!\nThe [CS:P]Surrounded Sea[CR]! Oh my gosh!\"", french="Elle n'arrête pas de dire des\ntrucs bizarres comme...[K] \"Oh là là! La [CS:P]Mer\nFermée[CR]! Oh là là!\"", german="Faselte etwas wie...[K] [F:S2]Du meine\nGüte! Das [CS:P]Ringmeer[CR]! Du meine Güte![F:E2]", italian="Dice cose come...[K] \"Evviva!\nIl [CS:P]Mar Cinto[CR]! Evviva!\"", spanish="Diciendo cosas como...[K] \"¡Jo!\n¡Qué superguay! ¡El [CS:P]Mar Circundante[CR]!\n¡Superdíver!\""})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="\"Oh my gosh! No one's seen it\nfor tens of thousands of years!\"[K] That sort of\nthing, hey, hey?", french="\"Oh là là! Personne ne l'a vue\ndepuis des dizaines de milliers d'années!\"[K]\nVous voyez le genre, dis donc!", german="[F:S2]Du meine Güte! Niemand hat es\nseit Zehntausenden von Jahren gesehen![F:E2][K]\nDerlei Zeugs, hey, hey?", italian="\"Evviva! Non l'ha visto nessuno\nper decine di migliaia di anni!\"[K] Cose del\ngenere, ehi, ehi?", spanish="\"¡Qué fuerte! ¡Y nadie lo ha\nvisto en miles de años!\"[K] No para de\ndecir ese tipo de cosas."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="She's been on a tear about that\nall by herself, hey, hey...", french="Elle est dans tous ses états\nà cause de ça, dis donc...", german="Sie ist da seit einiger Zeit im\nAlleingang unterwegs. Wie besessen, hey, hey...", italian="Stava per mettersi a piangere,\nehi, ehi...", spanish="Oye, está emocionadísima con el\ntema..."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="[CS:N]Sunflora[CR] is down in the guild's\nlower level right now, hey, hey.", french="[CS:N]Héliatronc[CR] se trouve au\ndeuxième sous-sol de la Guilde en ce moment\nmême, dis donc.", german="[CS:N]Sonnflora[CR] ist gerade auf der\nUnteren Gildenebene 2, hey, hey.", italian="[CS:N]Sunflora[CR] ora è al piano più\nbasso della Gilda, ehi, ehi.", spanish="[CS:N]Sunflora[CR] está ahora en la\nplanta -2 del [CS:N]Pokégremio[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="If you're interested, you should\nchat with [CS:N]Sunflora[CR], hey, hey! She's itching to\ngab about it!", french="Si ça vous intrigue, vous\ndevriez en discuter avec elle, dis\ndonc! Ça la démange d'en parler, on dirait!", german="Wenn ihr interessiert seid,\nplaudert mal mit [CS:N]Sonnflora[CR], hey, hey! Sie\nbrennt darauf, darüber zu schnattern!", italian="Se vi va, potete chiacchierare\ncon [CS:N]Sunflora[CR], ehi, ehi!\nNon sta nella pelle!", spanish="Deberíais hablar con [CS:N]Sunflora[CR] si\nos interesa. ¡Se muere de ganas de contárselo\na todos!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 39) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 39]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Secret Rank?", french=" Le Grade Secret?", german=" Geheim-Rang?", italian=" Rango Segreto?", spanish=" ¿El Rango Secreto?"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Not anything I've heard of,\nhey, hey...", french="Jamais entendu parler,\ndis donc...", german=" Ist mir unbekannt, hey, hey...", italian="Non ne ho mai sentito parlare,\nehi, ehi...", spanish=" Nunca he oído hablar de ello."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, maybe someone pulled a\ntrick on you, hey, hey?", french="Hé, peut-être que c'est quelqu'un\nqui vous a fait une blague, dis donc!", german="Hey, vielleicht hat euch jemand\neinen Streich gespielt, hey, hey?", italian="Ehi, forse qualcuno vi ha giocato\nun brutto scherzo, ehi, ehi?", spanish="¡Oye, oye! A ver si os han\nengañado..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 33] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Visiting the guild, hey, hey?!", french="Alors, on vient faire un tour\nà la Guilde, dis donc?!", german="Zu Besuch in der Gilde,\nhey, hey?!?", italian=" In visita alla Gilda, ehi, ehi?!", spanish="¡Oye, oye! ¿De visita por el\n[CS:N]Pokégremio[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Makes me glad to see you!\nHey, hey!", french="Content de vous voir, dis\ndonc!", german="Bin froh, euch zu sehen!\nHey, hey!", italian=" Sono felice di vedervi! Ehi, ehi!", spanish=" ¡Me alegro de veros!"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Even after you graduate, you're\nfree to look up jobs on the boards and go after\noutlaws.", french="Même après avoir obtenu votre\ndiplôme, n'hésitez pas à venir consulter le\nTableau des Missions et les Avis de Recherche.", german="Selbst nachdem ihr den\nAbschluss gemacht habt, könnt ihr Jobs auf\ndem Infobrett einsehen und Ganoven jagen.", italian="Anche dopo aver passato l'esame,\npotete accettare missioni dalle due Bacheche.", spanish="Una vez superado el gran reto,\ntodavía podéis perseguir a malhechores y\naceptar misiones de los tablones."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="So keep taking on those jobs,\nhey, hey.", french="Il faut continuer à accepter\nce genre de missions, dis donc.", german="Also nehmt weiterhin jene Jobs\nan, hey, hey.", italian="Perciò continuate pure ad\naccettare missioni, ehi, ehi.", spanish=" Así que seguid echándoles un ojo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 4]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 3] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Good luck on the graduation\nexam. Hey, hey, hey!", french="Eh dis donc! Bonne chance\npour l'examen de la Guilde.", german="Viel Glück bei der\nAbschlussprüfung. Hey, hey, hey!", italian="Buona fortuna per il vostro\nesame. Ehi, ehi, ehi!", spanish="Buena suerte en el gran reto.\n¡Oye, oye!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! I believe in you!", french=" Eh dis donc! Je crois en vous!", german=" Hey, hey! Ich glaube an euch!", italian=" Ehi, ehi! Io credo in voi!", spanish="¡Oye, oye! ¡Confío en vuestra\ndestreza!"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="I know you'll get things done,\nhey, hey!", french="Je sais que vous mènerez à bien\nvotre mission, dis donc!", german="Ich bin mir sicher, dass ihr die\nDinge schon richten werdet, hey, hey!", italian=" So che ce la farete, ehi, ehi!", spanish="¡Sé que actuaréis como es\ndebido!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! [CS:P]Brine Cave[CR] has some\nnasty enemies on the loose.", french="Eh dis donc! Il y a\nde redoutables ennemis qui se baladent\ndans la [CS:P]Caverne Saline[CR].", german="Hey, hey! In der\n[CS:P]Salzwasserhöhle[CR] sind ein paar fiese Gegner\nunterwegs.", italian="Ehi, ehi! Nella [CS:P]Grotta Salmastra[CR]\nci sono nemici davvero tosti.", spanish="¡Oye, oye! En la [CS:P]Cueva Aguamar[CR]\nhay enemigos peligrosos por ahí sueltos."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Everyone'd better get stocked up\nwith proper equipment, hey, hey.", french="Mieux vaut faire le plein de\nprovisions et d'objets, dis donc.", german="Es sollten sich besser alle mit\nordentlicher Ausrüstung ausstatten, hey, hey.", italian="È meglio che vi prepariate a\ndovere, ehi, ehi.", spanish=" Más vale ir bien equipados."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 1] || scn($SCENARIO_MAIN) >= [22
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! Not knowing what's\nbeen happening...", french="Eh dis donc! Ne pas savoir\nce qui se passe...", german="Hey, hey! Nicht zu wissen, was\npassiert ist...", italian="Ehi, ehi! Non capisco cosa stia\nsuccedendo...", spanish="¡Oye, oye! Ni idea de qué está\npasando..."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! That's stressful, I say.", french="... c'est ce qu'il y a de pire,\nd'après moi, dis donc!", german="Hey, hey! Das ist anstrengend,\nsage ich euch.", italian="Ehi, ehi! Tutto ciò è stressante,\ndico io.", spanish=" ¡Qué estresante, oye!"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Well, all we can do is keep doing\nour usual work, hey, hey.", french="Bon, tout ce qui nous reste\nà faire, c'est poursuivre notre travail\nhabituel, dis donc.", german="Nun, alles, was wir tun können,\nist mit unserer normalen Arbeit fortzufahren,\nhey, hey.", italian="Bene, possiamo solo fare il\nnostro solito lavoro, ehi, ehi.", spanish="Tendremos que seguir con\nnuestro trabajo de siempre."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 1] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Let's catch that thieving [CS:N]Grovyle[CR],\nhey, hey!", french="Attrapons ce voleur de [CS:N]Massko[CR],\ndis donc!", german="Lasst uns den Langfinger\n[CS:N]Reptain[CR] einfangen, hey, hey!", italian="Andiamo a catturare quel ladro\ndi [CS:N]Grovyle[CR], ehi, ehi!", spanish="¡Atrapemos al ladrón de [CS:N]Grovyle[CR],\noye, oye!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [13, 2] || scn($SCENARIO_MAIN) >= [13
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey, hey! I'm going after\noutlaws from the Outlaw Notice Board today!", french="Eh dis donc! Aujourd'hui,\nje me lance à la poursuite de hors-la-loi\nrecherchés!", german="Hey, hey, hey! Ich mache mich\nheute auf die Suche nach Ganoven, die auf dem\nGanoven-Infobrett aufgeführt sind!", italian="Ehi, ehi, ehi! Oggi controllo la\nBacheca per andare a caccia di ricercati!", spanish="¡Oye, oye! Hoy voy a capturar\nmalhechores del Tablón \"Se Busca\"."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Let's look good training! Hey,\nhey, hey!", french="Faisons bonne impression à\nl'entraînement, dis donc!", german="Lasst uns ein gutes Training\nhinlegen! Hey, hey, hey!", italian="Andiamo a fare un buon\nallenamento! Ehi, ehi, ehi!", spanish="¡Oye, oye! ¡Vamos a entrenarnos\ncon estilo!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 4] || scn($SCENARIO_MAIN) >= [12
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="No time to chat! Have to get\nready for the expedition, hey, hey!", french="Pas le temps de bavarder!\nIl faut se préparer pour l'expédition, dis\ndonc!", german="Keine Zeit zum Plaudern! Muss\nmich auf die Expedition vorbereiten, hey, hey!", italian="Non abbiamo tempo per le\nchiacchiere! Dobbiamo farci trovare pronti\nper la spedizione, ehi, ehi!", spanish="¡No hay tiempo que perder!\n¡Hay que prepararse para la expedición!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! I'm not about to lose!", french="Eh dis donc! En tout cas,\nje n'ai pas l'intention de rester les pinces\ncroisées!", german="Hey, hey! Ich stehe nicht gerade\nvor einer Niederlage!", italian="Ehi, ehi! Non ho intenzione di\nperdere!", spanish=" ¡Oye, oye! ¡No voy a rendirme!"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="We all want to win a place on\nthe expedition, hey, hey!", french="Nous voulons tous décrocher\nnotre place au sein de l'expédition!", german="Wir alle wollen uns die\nTeilnahme an der Expedition sichern, hey, hey!", italian="Vogliamo tutti essere scelti per\nla spedizione, ehi, ehi!", spanish="¡Todos queremos hacernos un\nhueco en la expedición!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 2] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! It's no time to be\nlosing motivation! What's a little stink?", french="Eh dis donc! Ça n'est pas\nle moment de perdre courage! Faites pas\nattention à l'odeur!", german="Hey, hey! Keine Zeit, um die\nMotivation zu verlieren! So schlimm ist diese\nkleine Stinkwolke schon nicht, oder?", italian="Ehi, ehi! Non è il momento di\nperdere la motivazione! È una cosuccia\nda niente!", spanish="¡No podemos perder ahora la\nmotivación! ¡Solo es un tufillo de nada!"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="There's an expedition coming up,\nhey, hey!", french="L'expédition, c'est pour bientôt,\ndis donc!", german="Schon bald wird es eine\nExpedition geben, hey, hey!", italian="Ci sarà presto una spedizione,\nehi, ehi!", spanish=" ¡Hay una expedición en camino!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 6) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 6]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="We're going to have a putrid\ntime, hey, hey...", french="Je le sens mal... On va passer\nun sale quart d'heure, dis donc...", german="Wir werden eine eklige Zeit\ndurchzustehen haben, hey, hey...", italian="Ce la passeremo davvero brutta,\nehi, ehi...", spanish=" Esto me huele muy mal..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 3] || scn($SCENARIO_MAIN) >= [7, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey, hey! Those guys you\nwere talking with...", french="Eh dis donc! Ces types à qui\nvous parliez...", german="Hey, hey, hey! Diese Typen, mit\ndenen ihr euch unterhalten habt...", italian="Ehi, ehi, ehi! Quei tipi con cui\nstavate parlando...", spanish="¡Oye, oye! Aquellos Pokémon\ncon los que estabais hablando..."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="They looked like some rough\ncustomers, hey, hey?", french="... ils n'avaient pas l'air\ncommodes, dis donc!", german="Die sahen wie ein paar echt raue\nKollegen aus, hey, hey?", italian="Sembrano dei brutti ceffi, ehi,\nehi!", spanish="Tenían pinta de indeseables,\n¿no?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 1] || scn($SCENARIO_MAIN) >= [6, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey, you two![K] Want to hear\na tip about these Job Bulletin Board tasks?", french="Eh dis donc![K] Vous voulez\nque je vous dise un secret à propos des\nmissions affichées au Tableau des Missions?", german="Hey, hey, ihr zwei![K] Wollt ihr\neinen Tipp zum Job-Infobrett?", italian="Ehi, ehi, voi![K] Volete sentire un\npiccolo segreto sulla Bacheca delle missioni?", spanish="¡Oye, oye, pareja![K] ¿Queréis que\nos dé un consejo sobre las misiones del Tablón\nde Anuncios?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="What, you don't want to know?\nSay it ain't so, hey, hey...", french="Quoi, vous ne voulez pas savoir?\nDites-moi que ce n'est pas vrai, dis donc...", german="Wie, ihr wollt das nicht wissen?\nSagt, dass das nicht wahr ist, hey, hey...", italian="Cosa, non volevate saperlo?\nNon dite così, ehi, ehi...", spanish="¿Qué? ¿No os interesa?\n¡Oye, oye, como queráis!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Sure, you want to hear![K] I'll tell\nyou, hey, hey!", french="Evidemment que vous voulez\nsavoir![K] Je vais vous le dire, dis donc!", german="Aber sicher wollt ihr das![K] Ich\nerzähle es euch, hey, hey!", italian="Certo che lo volete sentire![K]\nE io ve lo dirò, ehi, ehi!", spanish="¡Claro que queréis![K] Dejadme que\nos cuente..."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="You can take as many of those\njobs and outlaw missions for the same dungeon\nas you want! Hey, hey!", french="Les missions et Avis de\nRecherche...[K] Vous pouvez en prendre plusieurs\npar donjon en même temps, dis donc!", german="Hey, hey! Jene Jobs und\nGanovenmissionen... Ihr könnt so viele für\ndenselben Dungeon annehmen, wie ihr wollt!", italian="Di queste missioni e di quelle dei\nricercati... Potete accettarne quante volete per\nlo stesso dungeon! Ehi, ehi!", spanish="Podéis aceptar cuantas misiones\ny encargos queráis para el mismo territorio."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Here's an example! Let's say\nthere are two jobs in the same dungeon, one\non 5F and another on 10F...", french="Admettons qu'il y ait deux\nmissions à accomplir dans le même donjon,\nune au 5[F:E] étage (E. 5) et une au 10[F:E] (E. 10)...", german="Hier ist ein Beispiel: Nehmen wir\nan, es gibt zwei Jobs in demselben Dungeon,\neinen auf E5 und einen auf E10...", italian="Vi faccio un esempio! Diciamo\nche ci sono due missioni nello stesso dungeon,\nuna al P. 5 e una al P. 10...", spanish="Por ejemplo, pongamos que hay\ndos misiones en el mismo territorio, una\nen el quinto piso y otra en el décimo."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="First, add the jobs to your own\nJob List. Second, select Take Job for both of\nthem. Third, go to that dungeon!", french="D'abord, ajoutez-les à votre\nListe de Missions, puis sélectionnez Accepter.\nEnsuite, allez dans le donjon en question!", german="Fügt die Jobs zuerst eurer\neigenen Jobliste hinzu. Wählt dann AUSÜBEN\nfür beide aus, und geht dann in den Dungeon!", italian="Primo, aggiungi le missioni alla\nlista, accettandole. Secondo, seleziona Attiva\nper entrambe. Terzo, vai in quel dungeon!", spanish="Añadid las misiones a vuestra\nlista de misiones. Resaltadlas una a una y\nseleccionad Aceptar. ¡Y después al territorio!"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Once there, you do the job on 5F\nfirst! Then, instead of returning here, you\ncontinue onward to do the job on 10F!", french="Une fois là-bas, effectuez la\nmission du 5[F:E] étage! Ensuite, au lieu de\nrentrer, continuez pour faire celle du 10[F:E]!", german="Dort angekommen, erledigt ihr\nden Job auf E5! Anstatt zurückzukehren,\nkümmert ihr euch dann um den Job auf E10!", italian="Una volta là, completa prima la\nmissione al P. 5! Poi, invece di tornare qui,\nprosegui e completa la missione al P. 10!", spanish="Una vez allí, realizad la misión\ndel P5 primero y, en lugar de regresar,\ncontinuad con la misión del P10."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="That way, you do two jobs in one\nexploration! Hey, hey!", french="Comme ça, vous effectuez deux\nmissions en une seule fois, dis donc!", german="Auf diese Art erledigt ihr zwei\nJobs auf einer einzigen Erkundung! Hey, hey!", italian="In questo modo, completi due\nmissioni con una sola esplorazione! Ehi, ehi!", spanish="¡Así realizaréis dos misiones en\nuna sola exploración!"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Nice and neat, right? Hey, hey!", french=" Eh dis donc! Pratique, non?", german="Clever und bequem, richtig?\nHey, hey!", italian=" Facile e bello, vero? Ehi, ehi!", spanish=" Muy conveniente, ¿verdad?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 7] || scn($SCENARIO_MAIN) >= [4, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! You're going out on an\nexploration?", french="Eh dis donc! Vous partez en\nexploration?", german="Hey, hey! Ihr begebt euch auf\neine Erkundung?", italian="Ehi, ehi! State andando in\nesplorazione?", spanish=" ¡Oye, oye! ¿Vais a explorar?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_heigani, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="You can start exploring by going\nout this way, hey, hey!", french="Pour commencer à explorer,\nc'est par là, dis donc!", german="Eine Erkundung könnt ihr\nbeginnen, indem ihr diesen Weg entlanggeht,\nhey, hey!", italian="Da qui si parte per le\nesplorazioni, ehi, ehi!", spanish="¡Podéis empezar a explorar si\nvais por aquí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! You be careful!", french=" Eh dis donc! Faites attention!", german=" Hey, hey! Seid vorsichtig!", italian=" Ehi, ehi! Fate attenzione!", spanish=" ¡Id con cuidado!"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! If you're looking for\nadventure, you gotta get ready for whatever\ncomes your way!", french="Eh dis donc! Si vous cherchez\nl'aventure, pensez à bien vous préparer pour\npouvoir affronter toutes les situations!", german="Hey, hey! Wenn ihr auf ein\nAbenteuer aus seid, müsst ihr auf alles gefasst\nsein, was euch entgegentritt!", italian="Ehi, ehi! Chi cerca l'avventura,\ndeve essere pronto a ogni evenienza!", spanish="¡Oye, oye! ¡Si andáis buscando\naventuras, preparaos para lo que pueda\npasar!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 3] || scn($SCENARIO_MAIN) >= [4, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey, hey! You there![K]\nYou're the new rookies at the guild, aren't you?", french="Eh dis donc! Vous, là-bas![K]\nVous êtes les novices débarquant à peine à la\nGuilde, n'est-ce pas?", german="Hey, hey, hey! Ihr zwei![K]\nIhr seid die neuen Gildenrekruten, richtig?", italian="Ehi, ehi, ehi! Voi![K]\nSiete le nuove reclute della Gilda, vero?", spanish="¡Oye, oye![K] ¿Acabáis de ingresar\nen el [CS:N]Pokégremio[CR], no?"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! My name's [CS:N]Corphish[CR]!", french="Moi, je m'appelle [CS:N]Ecrapince[CR],\ndis donc!", german="Hey, hey! Mein Name ist\n[CS:N]Krebscorps[CR]!", italian=" Ehi, ehi! Mi chiamo [CS:N]Corphish[CR]!", spanish=" ¡Me llamo [CS:N]Corphish[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="I'm an apprentice at [CS:N]Wigglytuff[CR]'s\nGuild too. Hey, hey!", french="Moi aussi, je suis apprenti à\nla Guilde de [CS:N]Grodoudou[CR], dis donc!", german="Ich bin auch ein Schüler der\n[CS:N]Knuddeluff-Gilde[CR]. Hey, hey!", italian="Sono anch'io un apprendista alla\nGilda di [CS:N]Wigglytuff[CR]. Ehi, ehi!", spanish="Yo también soy aprendiz en el\n[CS:N]Pokégremio de Exploradores[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="If you don't know what's going\non or whatever...you come ask me! You got\nthat, hey, hey?", french="Si vous ne comprenez pas trop\nce qui se passe ici... venez me voir, dis\ndonc! C'est compris?", german="Wenn ihr nicht wisst, was los\nist, oder sonst irgendein Problem habt, kommt\nund fragt mich! Kapiert, hey, hey?", italian="Se non sapete cosa stia\nsuccedendo o per qualsiasi altra cosa, potete\nrivolgervi a me! Avete capito, ehi, ehi?", spanish="Si no sabéis qué ocurre, ¡venid\na preguntarme! ¿Entendido?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 0] || scn($SCENARIO_MAIN) >= [3, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
