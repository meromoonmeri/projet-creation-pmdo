-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/um1413.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_pochiena_c = SkySceneKit.spawn_npc("poochyena", 480, 240, Direction.UpLeft, "NPC_POCHIENA_C")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_c, 4) end)
  local npc_npc_pochiena_a = SkySceneKit.spawn_npc("poochyena", 448, 240, Direction.Up, "NPC_POCHIENA_A")
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="[CS:N]Drowzee[CR] has become a changed\nPokémon?[K] Good to hear he has reformed.", french="[CS:N]Soporifik[CR] a changé de vie?[K]\nHeureux d'apprendre qu'il a tiré un trait\nsur ses crimes passés.", german="[CS:N]Traumato[CR] hat sich verändert?[K]\nGut zu hören, dass er sich gebessert hat.", italian="[CS:N]Drowzee[CR] è cambiato?[K] Che bello\nsapere che non è più quello di una volta!", spanish="¿[CS:N]Drowzee[CR] se ha reformado?[K]\nPues un problema menos..."})
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="Not that it matters to us, since\nwe're a team that focuses on catching outlaws.", french="Bon, nous, ça ne nous arrange\npas vraiment, puisque nous sommes spécialisés\ndans la capture des bandits.", german="Nicht, dass das für uns von\nBedeutung wäre, sind wir doch ein Team, das\nauf das Fangen von Ganoven spezialisiert ist.", italian="A noi non cambia molto, dato che\nsiamo una squadra che si occupa di catturare\ni ricercati.", spanish="Aunque, tampoco me preocuparía\nlo contrario, puesto que nuestro equipo se\nespecializa en atrapar maleantes..."})
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="But if [CS:N]Drowzee[CR] becomes an\noutlaw again, we'll be there to catch him.", french="Mais si [CS:N]Soporifik[CR] recommence\nà faire du grabuge, on sera les premiers\nà l'attraper.", german="Aber falls sich [CS:N]Traumato[CR] wieder\nzu einem Ganoven entwickelt, werden wir da\nsein, um ihn einzufangen.", italian="Ma se [CS:N]Drowzee[CR] tornerà a\ncommettere crimini, saremo pronti ad\nacciuffarlo.", spanish="Pero avísanos si [CS:N]Drowzee[CR]\nvuelve a las andadas, porque entonces...\n¡nos encargaremos de cogerle!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 73] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_c, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="We heard that [CS:N]Drowzee[CR] is holed\nup on [CS:P]Mt. Travail[CR].", french="Nous avons entendu dire que\n[CS:N]Soporifik[CR] se terre sur le [CS:P]Mt Labeur[CR].", german="Wir haben gehört, dass sich\n[CS:N]Traumato[CR] auf den [CS:P]Mühsalberg[CR] zurückgezogen\nhat.", italian="Abbiamo saputo che [CS:N]Drowzee[CR]\nsi è rintanato sul [CS:P]Monte Odissea[CR].", spanish="Hemos oído que [CS:N]Drowzee[CR] se ha\nrefugiado en el [CS:P]Monte Tribulaciones[CR]."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 71] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_c, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="I had a Pulpy Life Seed earlier,\nand it was pretty tasty.", french="J'ai bu une Pulpe Pévégraine\ntout à l'heure et c'était pas mauvais du tout.", german="Ich habe gerade Lebenssamen-\nMatsch getrunken. Das war wirklich lecker.", italian="Mi sono appena bevuto una bella\nSpremuta Semevita ed era davvero deliziosa.", spanish="Antes me tomé una Crema de\nSemilla Vida y estaba de vicio."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_c, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="I've never heard of that.[K]\nThe grand master of all things bad?", french="Le grand maître de tous les\nmaux?[K] Je n'en ai jamais entendu parler!", german="Davon habe ich noch nie gehört.[K]\nDer Großmeister allen Übels?", italian="Non ne ho mai sentito parlare.[K]\nSua Malvagità?", spanish="No sabía nada de eso.[K] ¿El gran\nmalo requetemalo?"})
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="Still, there's plenty we don't\nknow about the world.", french="Mais bon, il y a plein de choses\nqu'on ignore dans ce monde.", german="Es gibt einfach immer noch\nreichlich Dinge in der Welt, über die wir\nnichts wissen.", italian="Ci sono ancora un sacco di cose\nche non sappiamo del mondo.", spanish="Pero, claro, todavía hay muchas\ncosas de este mundo que ignoramos..."})
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="It makes it that much more\nrewarding to be an exploration team.", french="Et c'est ça qui fait tout l'intérêt\nde l'exploration.", german="Das macht es so viel\nlohnenswerter, ein Erkundungsteam zu sein.", italian="Essere una squadra\nd'esplorazione ti dà molta più soddisfazione.", spanish="Eso hace que sea mucho más\nsatisfactorio ser un equipo explorador."})
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="Oh, there's something else...[K]\nWe heard this from other teams...", french="Oh, il y a autre chose...[K]\nNous l'avons appris par les autres équipes...", german="Oh, da ist noch etwas anderes.[K]\nWir haben das von anderen Teams erfahren.", italian="Ah, un'altra cosa...[K]\nL'abbiamo saputo dalle altre squadre...", spanish="Ah, por cierto...[K] Otros equipos\nnos han contado algo..."})
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="They told us about some newly\ndiscovered dungeons.[K] The wild Pokémon in\nthem seem more intelligent!", french="Elles nous ont parlé de nouveaux\ndonjons découverts récemment.[K] Les Pokémon\nsauvages qui s'y trouvent ont l'air plus malins!", german="Sie haben von einigen kürzlich\nentdeckten Dungeons berichtet.[K] Die wilden\nPokémon in ihnen scheinen intelligenter zu sein!", italian="Ci hanno detto che sono stati\nscoperti nuovi dungeon.[K] Pare che i Pokémon\nselvatici che ci vivono siano più intelligenti.", spanish="Nos han hablado de nuevos\nterritorios que acaban de descubrir...[K]\ncon Pokémon salvajes más inteligentes."})
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="They've learned to use\nitems...[K] And they're smarter in the ways they\nmove and attack!", french="Ils ont appris à se servir des\nobjets...[K] Et ils se déplacent et attaquent\navec beaucoup de stratégie!", german="Sie haben gelernt, Items zu\nverwenden.[K] Und sie sind klüger, was ihre\nBewegungen und Angriffe anbelangt!", italian="Hanno imparato a usare gli\nstrumenti...[K] E si muovono e attaccano con\npiù astuzia.", spanish="Han aprendido a usar objetos...[K]\n¡Y se ve que son más listos en la forma en\nla que se mueven y atacan!"})
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="So your team should keep that in\nmind when you're going into new dungeons!", french="Gardez ça à l'esprit quand vous\nirez explorer ces nouveaux donjons!", german="Euer Team sollte das also im\nHinterkopf haben, wenn ihr neue Dungeons\nbetretet!", italian="Tenetelo bene a mente quando\nandrete nei nuovi dungeon!", spanish="¡Será mejor que tu equipo tenga\neso en cuenta al explorar nuevos territorios!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_c, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english=" Good luck to you!", french=" Bonne chance à vous!", german=" Viel Glück euch!", italian=" Buona fortuna!", spanish=" ¡Que tengáis suerte!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_c, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="But if [CS:N]Grovyle[CR] is out to get the\nTime Gears...[K]it might be better to just seal\nthem away.", french="Mais si [CS:N]Massko[CR] a décidé de\ns'emparer des Rouages du Temps... [K]il vaut\npeut-être mieux les sceller tout simplement.", german="Aber wenn [CS:N]Reptain[CR] beabsichtigt,\ndie Zahnräder der Zeit zu bekommen,[K] könnte\nes besser sein, sie einfach zu versiegeln.", italian="Ma se [CS:N]Grovyle[CR] vuole\nimpossessarsi degli Ingranaggi del Tempo...[K]\nsarebbe meglio metterli al sicuro.", spanish="Si [CS:N]Grovyle[CR] pretende conseguir\nlos Engranajes del Tiempo...[K] tal vez sea mejor\nsellarlos para siempre."})
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english=" It's an option worth considering.", french="C'est une solution extrême, mais\nil faut la prendre en considération.", german="Über diese Möglichkeit sollte\nman wirklich nachdenken.", italian="È un'ipotesi che vale la pena di\nconsiderare.", spanish="Es una opción que hay que tener\nen cuenta."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_c, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="There's no way we can ignore\nwhat [CS:N]Grovyle[CR] is up to.", french="On ne peut pas ignorer les\nintentions de [CS:N]Massko[CR].", german="Auf keinen Fall können wir\nignorieren, auf was [CS:N]Reptain[CR] aus ist.", italian="Non possiamo assolutamente\nignorare quello che sta facendo [CS:N]Grovyle[CR].", spanish="Desde luego debemos estar muy\npendientes de [CS:N]Grovyle[CR]."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 1] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_c, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="Our sense of smell's acute.\nWe're real sensitive about it.", french="Notre sens de l'odorat est\ntrès développé. Nous sommes très sensibles\nà toutes les odeurs.", german="Unser Geruchssinn ist sehr fein.\nWir sind ziemlich empfindlich, was das angeht.", italian="Abbiamo un olfatto acuto e molto\ndelicato.", spanish="Tenemos un olfato muy agudo.\nEs nuestro sentido más sensible."})
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="But the stink is mostly gone.\nThat's a good thing.", french="Mais la puanteur a presque\ndisparu. C'est une bonne chose.", german="Aber der Gestank hat sich\ngrößtenteils verzogen. Das ist gut so.", italian="Ma la puzza è quasi del tutto\nsvanita, per fortuna.", spanish="Menos mal que aquel pestazo ya\ncasi ha desaparecido..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_c, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="The shop down from here looks\nunoccupied now...", french="La boutique en bas d'ici a l'air\ninoccupée pour l'instant...", german="Der Laden unterhalb von hier\nsieht aus, als würde er leer stehen.", italian="Pare che non ci sia nessuno\nal negozio lì in fondo...", spanish="El establecimiento de ahí abajo\nno parece estar en funcionamiento..."})
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english=" Not in business yet, I guess...", french="Pas encore en activité,\nj'imagine...", german=" Noch nicht eröffnet, denke ich.", italian=" Non hanno ancora aperto, credo...", spanish="Supongo que lo abrirán más\nadelante..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(5, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [5, 5]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_c, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="There are bad Pokémon out and\nabout in the world. That's why we can make a\nbusiness of catching them.", french="Le monde est infesté de\nPokémon méchants. Du coup, on gagne\nnotre vie en les capturant.", german="Es gibt auch bösartige Pokémon\nin der Welt. Daher können wir daran\nverdienen, sie einzufangen.", italian="Il mondo è pieno di Pokémon\ncattivi. È per questo che catturarli può\ndiventare un affare.", spanish="Hay muchos Pokémon malvados\nen este mundo. Por eso, podemos sacar\nbastante dinero capturándolos."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 7]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_c, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="We target only outlaws with a\n\"[CS:K]C[CR:0]\" rank.[K] They have bigger bounties on them\nthan the ones with \"E\" and \"[CS:I]D[CR:0]\" ranks.", french="Nous ne traquons que les\ncriminels classés \"[CS:K]C[CR:0]\".[K] Les récompenses sont\nplus fortes que pour ceux classés \"E\" et \"[CS:I]D[CR:0]\".", german="Wir haben es nur auf Ganoven\nmit dem Rang [CS:K]C[CR:0] abgesehen.[K] Sie bringen höhere\nBelohnungen ein als Ganoven mit E und [CS:I]D[CR:0].", italian="Ci occupiamo solo dei criminali\ndi rango \"[CS:K]C[CR:0]\".[K] Danno ricompense più ricche\nrispetto a quelli dei ranghi \"E\" e \"[CS:I]D[CR:0]\".", spanish="Solo perseguimos a malhechores\ncon el rango \"[CS:K]C[CR:0]\".[K] Las recompensas son mejores\nque las que ofrecen para los rangos \"E\" y \"[CS:I]D[CR:0]\"."})
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="There's a catch...[K] Outlaws with a\n\"[CS:K]C[CR:0]\" rank are much tougher.", french="Mais il y a un hic...[K] Les\nhors-la-loi classés \"[CS:K]C[CR:0]\" sont beaucoup\nplus coriaces.", german="Das Ganze hat einen Haken:[K]\nGanoven des Ranges [CS:K]C[CR:0] sind viel zäher.", italian="Ma c'è un piccolo problema...[K]\nI ricercati di rango \"[CS:K]C[CR:0]\" sono dei\nveri ossi duri.", spanish="Hay una pega...[K] Los malhechores\ncon el rango \"[CS:K]C[CR:0]\" son mucho más duros."})
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="We have to fight those crooks\ncarefully. Otherwise, we could take a beating!", french="Il faut être prudent quand\non s'y attaque. Autrement, ils pourraient nous\nbattre!", german="Wir müssen diese Gauner\nvorsichtig bekämpfen. Ansonsten könnte es\nsein, dass wir eine Abreibung bekommen!", italian="Dobbiamo affrontare questi\ncriminali con attenzione. Altrimenti\npotremmo essere sconfitti!", spanish="No se puede luchar contra ellos\na la ligera. Si no, ¡podríamos llevarnos una\nbuena tunda!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
