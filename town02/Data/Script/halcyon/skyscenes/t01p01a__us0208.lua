-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/us0208.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 98) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 98]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_ringuma2 = SkySceneKit.spawn_npc("ursaring", 328, 264, Direction.UpLeft, "NPC_RINGUMA2")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma2, 4) end)
  local npc_npc_ringuma = SkySceneKit.spawn_npc("ursaring", 304, 240, Direction.DownRight, "NPC_RINGUMA")
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="There's something different\nabout [CS:P]Luminous Spring[CR].", french="Quelque chose a changé\nà la [CS:P]Source Lumineuse[CR].", german="Die [CS:P]Glitzerquelle[CR] hat sich\nirgendwie verändert.", italian="C'è qualcosa di diverso alla\n[CS:P]Sorgente Luccichio[CR].", spanish="El [CS:P]Manantial Luminoso[CR]\nparece diferente..."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="It still looks the same...[K]\nBut I know it's not just my imagination.", french="Tout semble pareil...[K]\nPourtant je suis sûre que quelque chose\na changé.", german="Sie sieht zwar noch gleich aus...[K]\nAber ich weiß, ich bilde mir da nichts ein.", italian="Apparentemente sembra che non\nsia cambiato nulla...[K] ma il mio istinto mi dice\nche non è così.", spanish="Aparentemente está igual...[K]\nPero sé que no me lo estoy imaginando."})
  -- message_Close
  -- @label_131 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma2, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" Thank you so much!", french=" Merci de tout cœur!", german=" Vielen Dank!", italian=" Grazie mille!", spanish=" ¡Muchísimas gracias!"})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" Your team is so cool!", french="Votre équipe est vraiment\nmagnifique!", german=" Euer Team ist so cool!", italian="La vostra squadra è davvero\nfantastica!", spanish=" ¡Vuestro equipo es genial!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma2, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Don't let that scheming [CS:N]Darkrai[CR]\nbeat you!", french="Ne laissez pas ce scélérat de\n[CS:N]Darkrai[CR] vous vaincre!", german="Lasst euch nicht von dem\nintriganten [CS:N]Darkrai[CR] besiegen!", italian="Non permettete che quello\nsciagurato di [CS:N]Darkrai[CR] vi batta!", spanish="¡No dejéis que ese malévolo\n[CS:N]Darkrai[CR] se salga con la suya!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma2, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="If nothing can be done, it won't\njust be [CS:N]Azurill[CR]! All Pokémon will get locked up\nin sleep forever!", french="Si on ne fait rien, ce ne sera\nplus seulement [CS:N]Azurill[CR]! Tous les Pokémon\nseront à jamais coincés dans leur sommeil!", german="Falls nichts getan werden kann,\nwird es nicht nur [CS:N]Azurill[CR] betreffen! Alle\nPokémon werden für immer einschlafen!", italian="Se non si può fare nulla, non\nsi tratterà solo di [CS:N]Azurill[CR]! Tutti i Pokémon\nrimarranno per sempre prigionieri del sonno!", spanish="Si no hacemos algo pronto, ¡no\nserá únicamente [CS:N]Azurill[CR]! ¡Todos los Pokémon\nquedarán atrapados en una pesadilla!"})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" It's a crisis!", french=" C'est la catastrophe!", german=" Es ist eine Krise!", italian=" È una situazione critica!", spanish=" ¡Esto es una crisis!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 76] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma2, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Good morning, [hero] and\n[partner]!", french="Bonjour, [hero] et\n[partner]!", german="Guten Morgen, [hero] und\n[partner]!", italian="Buongiorno, [hero] e\n[partner]!", spanish="¡Buenos días, [hero] y\n[partner]!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 52) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 52]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma2, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Our environment was too\ndifferent from the one [CS:N]Manaphy[CR] needs...", french="Notre environnement était trop\ndifférent de celui dans lequel doit vivre\n[CS:N]Manaphy[CR]...", german="Unsere Umgebung unterscheidet\nsich zu sehr von der, die [CS:N]Manaphy[CR] braucht.", italian="Il nostro ambiente era troppo\ndiverso da quello di cui [CS:N]Manaphy[CR] ha\nbisogno...", spanish="Nuestro entorno es demasiado\ndiferente del que necesita [CS:N]Manaphy[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" Cheer up.", french=" Courage.", german=" Kopf hoch!", italian=" Coraggio.", spanish=" Arriba ese ánimo."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 50] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma2, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" Pardon?[K] That cutie's fallen ill?", french="Pardon?[K] Le petit est tombé\nmalade?", german="Bitte?[K] Das süße Ding ist krank\ngeworden?", italian="Cosa?[K] Quel piccolino\nsi è ammalato?", spanish=" ¿Cómo?[K] ¿Que ha enfermado?"})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="That's really worrisome...[K] I hope\nthat cutie gets better soon.", french="C'est vraiment inquiétant...[K]\nJ'espère qu'il va vite se remettre.", german="Das ist wirklich beunruhigend.[K]\nIch hoffe, dass es dem Kleinen bald wieder\nbesser geht.", italian="È preoccupante...[K] Spero si\nriprenda presto.", spanish="Vaya, qué desgracia...[K] Esperemos\nque mejore pronto."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 48] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma2, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="That little cutie disappeared?\nThe one we saw yesterday?", french="Le petit a disparu?\nCelui qu'on a vu hier?", german="Das süße kleine Kerlchen ist\nverschwunden? Das, das wir gestern gesehen\nhaben?", italian="Quel piccolino è scomparso?\nQuello che ho visto ieri?", spanish="¿Aquella monada desapareció?\n¿Aquella criaturita que vimos ayer?"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 46) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 46]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma2, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" Oh! What a cutie!", french=" Oh! Comme il est mignon!", german="Oh! Was für ein süßer kleiner\nSchatz!", italian=" Oh! Che carino!", spanish=" ¡Oh! ¡Qué monada!"})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Why is that little cutie\nwith you?", french="Qu'est-ce que vous faites avec\nce petit bout de chou?", german="Warum habt ihr den kleinen\nSchatz denn dabei?", italian="Perché questo piccolino è con\nvoi?", spanish=" ¿Por qué está contigo?"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 45] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma2, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Good morning.[K] It's a nice day\nout again.", french="Bonjour.[K] Encore une bien belle\njournée.", german="Guten Morgen.[K] Heute ist mal\nwieder ein toller Tag.", italian=" Buongiorno.[K] Che bella giornata!", spanish="Buenos días.[K] Vuelve a ser un\ngran día."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 41] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma2, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" I'm [CS:N]Ursaring[CR].", french=" Je suis [CS:N]Ursaring[CR].", german=" Ich bin [CS:N]Ursaring[CR].", italian=" Sono [CS:N]Ursaring[CR].", spanish=" Soy [CS:N]Ursaring[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="I haven't gotten used to\nthings yet...", french="Je ne m'y suis pas encore\nfaite...", german="Ich habe mich noch nicht an die\nDinge gewöhnt.", italian=" Non mi ci sono ancora abituata...", spanish="Aún no me he acostumbrado a\ntodo esto..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 33] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma2, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Oh! [partner] and\n[hero]![K] How are you?!", french="Hé! [partner] et\n[hero]![K] Comment ça va?!", german="Oh! [partner] und\n[hero]![K] Wie geht es euch?", italian="Oh! [partner] e\n[hero]![K] Come state?!", spanish="¡Oh! ¡[partner] y\n[hero]![K] ¡¿Cómo estáis?!"})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="It's me![K] [CS:N]Teddiursa[CR]...[K] Oh, wait!\nNo, I'm [CS:N]Ursaring[CR] now!", french="C'est moi![K] [CS:N]Teddiursa[CR]...[K]\nNon, attendez! En fait, je suis [CS:N]Ursaring[CR]\nmaintenant!", german="Ich bin es,[K] [CS:N]Teddiursa[CR].[K] Oh, wartet\nmal! Nein, ich bin jetzt [CS:N]Ursaring[CR]!", italian="Sono io![K] [CS:N]Teddiursa[CR]...[K]\nOh, aspettate! No, ora sono [CS:N]Ursaring[CR]!", spanish="¡Soy yo![K] [CS:N]Teddiursa[CR]...[K] No, espera.\n¡Ahora soy [CS:N]Ursaring[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Oh, this is still all so new and\nconfusing...", french="Oh, c'est encore tout récent,\nalors je m'emmêle un peu les pinceaux...", german="Oh, das ist alles noch so neu und\nverwirrend.", italian="Oh, è tutto ancora così nuovo e\nstrano...", spanish="Esto todavía me resulta muy\nconfuso..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 4] || scn($SCENARIO_MAIN) >= [29
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
