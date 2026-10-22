-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P09A/enter04.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  SkySceneKit.turn_to_pos(hero, 260, 128) -- Turn2DirectionMark
  SkySceneKit.turn_to_pos(hero, 260, 128) -- Turn2DirectionMark
  SkySceneKit.turn_to_pos(partner, 260, 128) -- Turn2DirectionMark
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_G01P09A1_562) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(19) [anim idle native]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Something is written here...", french="[CN]Il y a quelque chose écrit ici...", german="[CN]Hier steht etwas geschrieben.", italian="[CN]Qui c'è scritto qualcosa...", spanish="[CN]Aquí hay algo escrito..."})
  -- @label_56 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]This is [CS:N]Sunflora[CR]'s diary.\n[CN]Should we sneak a peek?", french="[CN]C'est le journal d'[CS:N]Héliatronc[CR].\n[CN]On jette un coup d'œil?", german="[CN]Dies ist das Tagebuch von [CS:N]Sonnflora[CR].\n[CN]Sollen wir einen Blick riskieren?", italian="[CN]È il diario di [CS:N]Sunflora[CR].\n[CN]Gli diamo un'occhiata veloce?", spanish="[CN]Se trata del diario de [CS:N]Sunflora[CR].\n[CN]¿Quieres echarle un vistazo?"})
  do local __choice = SkySceneKit.ask({{english="Read", french="Lire", german="Ja", italian="Leggi", spanish="Leerlo"}, {english="Ignore it", french="Ignorer", german="Nein", italian="Ignora", spanish="Mejor no"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 2 then
  -- @label_51 [étiquette de flux ExplorerScript]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 4 -- $EVENT_LOCAL = 4 (ROM)
  -- @label_55 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyMenuResults or {})["MENU_DIARY_SUNFLORA"] or 0) -- switch(message_Menu(MENU_DIARY_SUNFLORA)) [message_Menu(MENU_DIARY_SUNFLORA): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 26 then
  -- @label_2 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Episode 26: Thank You!\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 26: Merci infiniment!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 26: Danke!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 26: Grazie!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]26. ¡Gracias!\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh! Yippee-yay-yay!\nOur [hero] and [partner] are back!\nBack in Treasure Town!", french="Ben mince alors! Youpiii! Super!\nNos héroïques [hero] et [partner]\nsont de retour à Bourg-Trésor!", german="Auweia! Hurraaa! [hero] und\n[partner] sind zurück, zurück in\nSchatzstadt!", italian="Shock! Evviva, evviva, evviva! [hero] e\n[partner] sono di nuovo qui!\nA Borgo Tesoro!", spanish="¡Por fin! ¡Ya están en Aldea Tesoro!\n¡[hero] y [partner] han vuelto!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="They defeated [CS:N]Darkrai[CR]![K] And they're back safe!", french="Ces deux-là ont vaincu [CS:N]Darkrai[CR]![K] Et les voilà\nde retour et en pleine forme!", german="Sie haben [CS:N]Darkrai[CR] besiegt![K] Und sie sind\nunversehrt zurückgekehrt!", italian="Hanno sconfitto [CS:N]Darkrai[CR]![K] E stanno bene!", spanish="¡Han derrotado a [CS:N]Darkrai[CR]![K] ¡Y han vuelto de\nuna pieza! ¡No me lo puedo creer!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Thank you, [hero] and [partner]!\nVery, very sincerely!", french="Merci, [hero] et [partner]!\nTrès sincèrement, merci!", german="Danke, [hero] und [partner]!\nEin aufrichtiges Danke!", italian="Grazie, [hero] e [partner]!\nCon tutto il cuore!", spanish="¡Tenemos que agradecérselo mucho a\n[hero] y [partner]! ¡De verdad!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="From the bottom of my heart, I'm filled with a\ndeep sense of gratitude.", french="Je vous suis très reconnaissante,\ndu fond du cœur.", german="Ich bin zutiefst mit Dankbarkeit erfüllt.", italian="Il mio cuore trabocca di gratitudine!", spanish="Se lo agradezco de todo corazón."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="You two so bravely saved the world, not once,\nbut twice!", french="Vous avez sauvé le monde avec courage,\nnon pas une, mais deux fois!", german="Ihr zwei habt so tapfer die Welt gerettet, und\ndas nicht nur einmal, sondern gleich zweimal!", italian="Avete mostrato così tanto coraggio, salvando il\nmondo non una, ma due volte!", spanish="¡Han salvado al mundo! ¡Y no una, sino dos\nveces!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="When I think back to when you first joined the\nguild...[K]you two were just the cutest!", french="Quand je repense à votre arrivée à la\nGuilde...[K] vous étiez si chou!", german="Wenn ich an den Zeitpunkt zurückdenke, als\nihr euch der Gilde angeschlossen habt...[K] Ihr\nzwei wart echt die Allersüßesten!", italian="Quando ripenso al giorno in cui vi ho visto\narrivare alla Gilda...[K] eravate così dolci!", spanish="Aún me acuerdo del día que les vi llegar al\n[CS:N]Pokégremio[CR]...[K] ¡Eran de lo más mono!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But now you've grown to be so capable and\nconfident.", french="Mais vous avez bien grandi depuis et gagné\nen assurance et en expérience.", german="Aber jetzt seid ihr so tüchtig und selbstsicher.", italian="Ora invece dimostrate capacità e sicurezza.", spanish="Pero ahora rebosan experiencia y confianza."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="...[K]Oh my gosh! This must be what a mother\nfeels like watching her children grow!", french="... [K]Oh là là! Ce doit être ça que ressent\nune mère en voyant ses enfants grandir!", german="...[K]Auweia! So muss sich eine Mutter fühlen,\ndie ihre Kinder heranwachsen sieht!", italian="...[K] Shock! Credo di sentire quello che\nproverebbe una madre vedendo crescere\ni propri pargoli!", spanish="¡Ay![K] Esto debe de ser lo que sienten las\nmadres cuando ven crecer a sus retoños."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh! I feel horrified about writing\nthat![K] Anyway...", french="Ben mince alors! J'arrive pas à croire\nque j'aie pu écrire ça![K] Enfin bref...", german="Auweia! Ich bin entsetzt darüber, das zu\nschreiben![K] Wie auch immer...", italian="Shock! Che orrore scrivere una cosa del\ngenere![K] Comunque...", spanish="¡Anda que...! ¡Soy de lo peor por escribir algo\nasí![K] En fin..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh, [hero] and [partner]! Don't ever\nchange, my good friends!", french="Oh, [hero] et [partner]! Ne changez\njamais, je vous adore!", german="Oh, [hero] und [partner]! Bleibt so,\nwie ihr seid, meine lieben Freunde!", italian="Oh, [hero] e [partner]! Non cambiate\nmai!", spanish="¡[hero], [partner]...! ¡Espero que no\ncambiéis nunca, o sea, nunca!"})
  -- @label_1 [étiquette de flux ExplorerScript]
  -- message_Close
  -- SetAnimation(20) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_G01P09A1_562) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(17) [anim idle native]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw == 25 then
  -- @label_3 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Entry 25: [CS:N]Darkrai[CR]\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 25: [CS:N]Darkrai[CR]\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 25: [CS:N]Darkrai[CR]\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 25: [CS:N]Darkrai[CR]!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]25. [CS:N]Darkrai[CR]\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Yippee! Oh my gosh! Little [CS:N]Azurill[CR]...[K]\nLittle [CS:N]Azurill[CR] has awoken from his nightmare!", french="Youpiii! Oh là là! C'est le petit [CS:N]Azurill[CR]...[K]\nLe petit [CS:N]Azurill[CR] s'est réveillé!", german="Hurra! Auweia! Der kleine [CS:N]Azurill[CR]...[K] Der kleine\n[CS:N]Azurill[CR] ist aus seinem Albtraum erwacht!", italian="Evviva! Shock! Il piccolo [CS:N]Azurill[CR]...[K] Il piccolo\n[CS:N]Azurill[CR] si è risvegliato dall'incubo!", spanish="¡Bien! ¡Por fin! El pequeño [CS:N]Azurill[CR]...[K]\n¡[CS:N]Azurill[CR] se ha despertado de su pesadilla!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Ooh, this is so wonderful! Yippee![K] [CS:N]Cresselia[CR]\nmust be thanked properly for this!", french="Ooh, c'est merveilleux! Youpiii![K] C'est grâce à\n[CS:N]Cresselia[CR]. Il faut la remercier comme\nil se doit!", german="Ooh, das ist so wundervoll! Hurra![K] [CS:N]Cresselia[CR]\nmuss gebührend dafür gedankt werden!", italian="Ooh, è magnifico! Evviva! Dobbiamo\nringraziare[K] [CS:N]Cresselia[CR]!", spanish="¡Qué bien![K] ¡Tenemos que darle las gracias\nde todo corazón a [CS:N]Cresselia[CR]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="We also owe [CS:N]Cresselia[CR] for telling us how\neverything bad that happened came to be...\nEven the destruction of time.", french="C'est aussi [CS:N]Cresselia[CR] qui nous a expliqué\npourquoi toutes ces horreurs sont arrivées...\nMême la destruction du temps.", german="[CS:N]Cresselia[CR] hat etwas gut bei uns, hat sie uns\ndoch über den Ursprung des Übels unterrichtet.\nSogar über die Zerstörung der Zeit.", italian="È solo grazie a [CS:N]Cresselia[CR] che sappiamo come\nsono successe tutte queste brutte cose...\n... inclusa la distruzione del tempo.", spanish="Además, fue [CS:N]Cresselia[CR] la que nos contó por\nqué estaban ocurriendo esas cosas tan malas...\nIncluso nos explicó lo del problema del tiempo."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="We were shocked to learn that it was all the\ndoing of one Pokémon... The one called [CS:N]Darkrai[CR].", french="On était tous choqués d'apprendre qu'un seul\net même Pokémon du nom de [CS:N]Darkrai[CR] était\nà l'origine de tout ça.", german="Wir waren schockiert, als wir erfuhren, dass\ndas alles das Werk eines Pokémon namens\n[CS:N]Darkrai[CR] war.", italian="Che shock scoprire che è stato tutto\norganizzato da un solo Pokémon... Quel [CS:N]Darkrai[CR].", spanish="Todos nos quedamos boquiabiertos cuando nos\nenteramos que era culpa de un solo Pokémon...\nEl malvado [CS:N]Darkrai[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Now [hero] and [partner] are on\ntheir way to confront [CS:N]Darkrai[CR].", french="Et maintenant, [hero] et [partner]\nsont en route pour affronter [CS:N]Darkrai[CR].", german="[hero] und [partner] sind nun auf\ndem Weg, [CS:N]Darkrai[CR] gegenüberzutreten.", italian="Ora [hero] e [partner] sono sulle\ntracce di [CS:N]Darkrai[CR].", spanish="Ahora mismo, [hero] y [partner] van\na enfrentarse a [CS:N]Darkrai[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Good luck, [hero] and [partner]!", french="Bonne chance, [hero] et [partner]!", german="Viel Glück, [hero] und [partner]!", italian="Buona fortuna, [hero] e [partner]!", spanish="¡Buena suerte, [hero] y [partner]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Please win! And please come back safe!", french="Battez-le! Et revenez-nous indemnes!", german="Bitte seid siegreich! Und bitte kommt\nunverletzt zurück!", italian="Mettetecela tutta! E tornate in buona salute!", spanish="¡Por favor, venced y volved de una pieza!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Go for it, Team [team:]!", french="Foncez, Equipe [team:]!", german="Haltet euch ran, Team [team:]!", italian="Coraggio, Team [team:]!", spanish="¡A por él, [CS:X]Equipo[CR] [team:]!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 24 then
  -- @label_4 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Entry 24: Nightmare! Eek!\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 24: Un cauchemar! Hiii!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 24: Der böse Traum! Iek!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 24: Incubo! Shock!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]24. ¡Menuda pesadilla!\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It was so peaceful for a while...[K] But now\nthere has been a sinister incident.", french="Tout était si paisible ces derniers temps...[K]\njusqu'à cet incident tragique.", german="Es war eine Weile lang so friedlich.[K] Aber erst\nkürzlich gab es einen finsteren Zwischenfall.", italian="Per un po' di tempo è stato tutto così\ntranquillo...[K] Ma ora si è verificato\nun episodio sinistro.", spanish="Últimamente estaba todo tranquilo...[K] hasta\nque ha ocurrido algo malo."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Little [CS:N]Azurill[CR] seems to be stuck in a nightmare\nthat he can't wake from.", french="C'est le petit [CS:N]Azurill[CR], on dirait qu'il est bloqué\ndans un cauchemar sans pouvoir se réveiller.", german="Der kleine [CS:N]Azurill[CR] scheint in einem Albtraum\nfestzusitzen, aus dem er nicht mehr aufwachen\nkann.", italian="Sembra che il piccolo [CS:N]Azurill[CR] sia rimasto\nimprigionato in un incubo e non riesca più a\nsvegliarsi.", spanish="El pequeño [CS:N]Azurill[CR] está atrapado en una\nterrible pesadilla y no se puede despertar."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh! How is that possible?!", french="Ben mince alors! Comment est-ce possible?!", german="Auweia! Wie ist das nur möglich?!?", italian="Shock! Com'è possibile?!", spanish="¡Madre mía! ¡¿Cómo es posible?!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="For the time being, Team [team:] has\ngone off in search of a Pokémon named\n[CS:N]Drowzee[CR].", french="Pour l'instant, L'Equipe [team:] est partie\nà la recherche d'un Pokémon appelé [CS:N]Soporifik[CR].", german="Fürs Erste hat sich Team [team:]\naufgemacht, ein Pokémon namens [CS:N]Traumato[CR]\nzu finden.", italian="Per ora, il Team [team:] è in giro alla\nricerca di un Pokémon chiamato [CS:N]Drowzee[CR].", spanish="El [CS:X]Equipo[CR] [team:] ha partido en busca de\nun Pokémon llamado [CS:N]Drowzee[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Apparently, [CS:N]Drowzee[CR] can go into the dreams of\nothers...[K] It would be wonderful if little [CS:N]Azurill[CR]\ncan be awoken that way.", french="Apparemment, [CS:N]Soporifik[CR] est capable de\ns'immiscer dans les rêves des autres...[K]\nSi seulement il pouvait réveiller [CS:N]Azurill[CR].", german="Offenbar kann [CS:N]Traumato[CR] in die Träume anderer\neindringen.[K] Es wäre toll, wenn der kleine\n[CS:N]Azurill[CR] so aufgeweckt werden könnte.", italian="Dicono che [CS:N]Drowzee[CR] possa entrare nei sogni\ndegli altri...[K] Sarebbe magnifico se in questo\nmodo riuscissero a risvegliare [CS:N]Azurill[CR].", spanish="Parece que [CS:N]Drowzee[CR] puede adentrarse en\nlos sueños...[K] Estaría muy bien si pudiera\ndespertar así a [CS:N]Azurill[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="P.S. Oh my gosh, I don't really want to even\nwrite anything like this, but...", french="P.-S. Ben mince alors, je n'ai pas vraiment\nenvie d'en parler, mais...", german="P.S.: Auweia, ich möchte eigentlich nichts\nDerartiges schreiben, aber...", italian="P.S. Shock, non voglio nemmeno pensare a una\ncosa del genere, ma...", spanish="P. D.: ¡Ay, ay, ay! No debería ni escribirlo..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Maybe... Well, lately... Maybe only because it's\nbeen so peaceful for so long... But...", french="Peut-être que... enfin, récemment... Peut-être\nque c'est à cause du calme ambiant... Mais...", german="Vielleicht... Nun, in letzter Zeit... Vielleicht nur\naus dem Grund, weil es so lange so friedlich\ngewesen ist, aber...", italian="... Forse, beh, ultimamente... forse solo perché\nè stato tutto così tranquillo per tanto tempo,\nma...", spanish="Igual sí, no sé... Bueno, creo que igual es\nporque últimamente está todo muy tranquilo..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I can't get over this creepy feeling that\nsomething dreadful is going to happen...", french="Je suis poursuivie par ce pressentiment\nétrange que quelque chose d'affreux va\nse produire...", german="Ich werde das Gefühl nicht los, dass etwas\nFurchtbares geschehen wird.", italian="Ho sempre la sensazione che stia per accadere\nqualcosa di terribile...", spanish="Pero tengo la extraña sensación de que\nestá a punto de pasar algo malo..."})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 23 then
  -- @label_5 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Entry 23: Thunderstorm! Eek!\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 23: Quel orage! Hiii!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 23: Unwetter! Iek!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 23: Un temporale! Ehi!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]23. ¡Vaya tormenta!\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="...It's always sunny.", french="... Il fait toujours beau.", german="Es ist immer sonnig.", italian="C'è sempre il sole.", spanish="Siempre hace sol."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The weather has been nice for a long\ntime now.", french="Ça fait longtemps que le temps\nest au beau fixe.", german="Das Wetter ist nun schon seit langer Zeit\nschön.", italian="Ormai le condizioni atmosferiche sono buone da\nmolto tempo.", spanish="Hace mucho tiempo que los días son soleados\ny agradables."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It sure keeps me feeling perky![K] I wish the\nweather would stay sunny like this.", french="Ça me met de bonne humeur![K] Si seulement\nil pouvait continuer à faire beau.", german="Das hält mich munter![K] Ich wünschte mir, das\nWetter würde so sonnig wie jetzt bleiben.", italian="Sicuramente questo mi mantiene allegra![K]\nVorrei che splendesse sempre il sole.", spanish="¡La verdad es que el buen tiempo me pone de\nbuen humor![K] ¡Ojalá siempre hiciera sol!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But, oh my gosh, everyone is saying there's a\nstorm coming...", french="Oh là là! Le bruit court qu'une tempête\napproche...", german="Aber, auweia, Gerüchten zufolge zieht ein\nSturm auf.", italian="Ma, shock, a quanto dicono, c'è una tempesta\nin arrivo...", spanish="¡Ay! He oído por ahí que se avecina una\ntormenta..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I guess that a Pokémon named [CS:N]Swampert[CR]\nsensed a storm coming and told everyone...", french="Je suppose que c'est [CS:N]Laggron[CR] qui l'a sentie\nvenir et qu'il a prévenu tout le monde...", german="Ich vermute, dass ein Pokémon namens\n[CS:N]Sumpex[CR] einen heraufziehenden Sturm gespürt\nund es allen erzählt hat.", italian="Credo che un Pokémon chiamato [CS:N]Swampert[CR]\nabbia percepito l'arrivo di una tempesta e\nl'abbia detto a tutti...", spanish="Al parecer, un Pokémon llamado [CS:N]Swampert[CR]\nha notado la tormenta y se lo dijo a todos..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="That's all fine and well, but...[K]I...[K]get spooked by\nthunder...", french="C'est bien joli tout ça, mais... [K]moi...[K] j'ai peur\nde l'orage...", german="Das ist schon in Ordnung, aber...[K] ich...[K] habe\nAngst, wenn es donnert...", italian="Va tutto bene così ma...[K] io...[K] ho paura delle\ntempeste...", spanish="Sé que no pasa nada...[K] pero...[K] es que los\ntruenos me dan miedo..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The instant it thunders...[K] Eeeeek!", french="Dès que le tonnerre gronde...[K] Hiiiii!", german="In dem Moment, wenn es donnert...[K] Ieeeek!", italian="Quando si sentono i tuoni...[K] Ehiiiii!", spanish="En cuanto oigo un trueno...[K] ¡Ay, ay!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oooh, just as I wrote that! Eeeeek![K] Thunder!", french="Oooh, un coup de tonnerre![K] Juste au moment\noù j'écris! Hiiiii!", german="Oooh, gerade jetzt, wo ich das geschrieben\nhabe! Ieeeek![K] Donner!", italian="Eeeh, proprio mentre lo scrivevo! Shock![K]\nUn tuono!", spanish="¡Qué mal que lo paso![K] ¡Ay, un trueno!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="...Oh! Actually, it was only [CS:N]Chimecho[CR] ringing\nher bell beside me...", french="... Ah! En fait, c'était seulement [CS:N]Eoko[CR]\nen train de sonner sa cloche à côté de moi...", german="Oh! Aber das war ja nur das Glockenläuten\nvon [CS:N]Palimpalim[CR] neben mir.", italian="Oh! In realtà, era solo [CS:N]Chimecho[CR] che suonava\nla sua campana qui vicino...", spanish="¡Uf! ¡Menos mal que solo era [CS:N]Chimecho[CR]\nhaciendo sonar su campana!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh! She startled me!", french="Ben mince alors! Ce qu'elle m'a fait peur!\nQuelle cruche!", german="Auweia! Das hat mir aber jetzt einen ganz\nschönen Schrecken versetzt!", italian="Shock! Mi ha spaventata!", spanish="En serio, ¡me ha puesto los pétalos de punta!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="That [CS:N]Chimecho[CR] is more mischievous than she\nlooks! Oh my gosh!", french="Ben mince alors, cette [CS:N]Eoko[CR], sous ses airs\nd'intouchable, c'est une vraie pimbêche!", german="[CS:N]Palimpalim[CR] ist verschmitzter, als es auf den\nersten Blick scheint! Auweia!", italian="Quella [CS:N]Chimecho[CR] è più dispettosa di quel che\nsi possa pensare! Shock!", spanish="Ahí donde la ves, ¡[CS:N]Chimecho[CR] tiene muy mala\nidea! ¡En serio!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 22 then
  -- @label_6 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Entry 22: Yippee! Team [CS:X]Charm[CR]!\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 22: Youpiii! Les [CS:X]Charme[CR]!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 22: Hurra! Team [CS:X]Charme[CR]!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 22: Evviva il Team [CS:X]Malia[CR]!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]22. ¡Cuánto [CS:X]Carisma[CR]!\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh! What an exciting day it was!", french="Ben mince alors! Quelle journée passionnante!", german="Auweia! Was war das bloß für ein\naufregender Tag!", italian="Shock! È stato davvero un giorno emozionante!", spanish="¡Hoy ha sido un día superemocionante!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Everyone's favorite celebrities, the women of\nTeam [CS:X]Charm[CR], came to our guild! Oh my gosh!", french="Les stars les plus en vogue, les membres de\nl'Equipe [CS:X]Charme[CR], sont venues à la Guilde!\nOh là là!", german="Die jedermann bekannten Persönlichkeiten, die\nDamen von Team [CS:X]Charme[CR], haben unsere Gilde\nbesucht! Auweia!", italian="Dei Pokémon famosissimi, le bellissime del\nTeam [CS:X]Malia[CR], sono venute alla Gilda! Shock!", spanish="¡El famoso y querido [CS:X]Equipo Carisma[CR],\ncompuesto solo por chicas, ha visitado el\n[CS:N]Pokégremio de Exploradores[CR]! ¡Madre mía!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Yippee![K]\nYippee![K]\nYip-yip-yippeeeeee...", french="Youpiii![K] Youpiii![K] Youp-Youp-youuuu...", german="Hurra![K]\nHurra![K]\nHip, hip, hurra!", italian="Evviva![K]\nEvviva![K]\nEvviva, evviva, evvivaaaaa...", spanish="¡Ay![K]\n¡Ay, ay![K]\n¡Ay, ay, ay!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="...[K]Oh![K] Where?[K] Oh my gosh! Where am I?!", french="... [K]Oh![K] Mais que...[K] Ben mince alors!\nOù est-ce que je suis?!", german="...[K]Oh![K] Wo?[K] Auweia! Wo bin ich?!?", italian="...[K] Eh![K] Dove?[K] Shock! Dove sono?!", spanish="¡Huy!...[K] ¡Ay![K] ¿Dónde?[K] ¡O sea! ¡¿Dónde\nestoy?!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="...[K]Oh, I see now...", french="...[K] Ah, je comprends...", german="...[K]Oh, jetzt verstehe ich.", italian="...[K] Ah, ora capisco...", spanish="Aaaah...[K] Ahora sé lo que ha pasado..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh! I just fainted from being so\nexcited!", french="Ben mince alors! J'étais tellement enthousiaste\nque je viens de m'évanouir!", german="Auweia! Ich muss vor all der Aufregung\nohnmächtig geworden sein!", italian="Shock! Sono appena svenuta per l'emozione!", spanish="¡Madre mía! ¡Me acabo de marear de la\nemoción!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh...! [CS:N]Chimecho[CR] is looking at me all puzzled![K]\nOh my gosh! This just won't do!", french="Oh...! [CS:N]Eoko[CR] me regarde d'un drôle d'air![K]\nOh là là! Ça ne va pas du tout!", german="Oh! [CS:N]Palimpalim[CR] sieht mich so unschlüssig an![K]\nAuweia! Das kann wohl alles nicht wahr sein!", italian="Oh...! [CS:N]Chimecho[CR] mi sta guardando perplessa![K]\nShock! Non va bene!", spanish="Y encima ¡[CS:N]Chimecho[CR] me está mirando\nasombrada![K] ¡Qué mal, o sea, qué mal!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Um, anyway, the women of Team [CS:X]Charm[CR] came\ncalling on our guild for an oh-my-gosh kind of\nreason.", french="Hmm, bref, si les filles de l'Equipe [CS:X]Charme[CR]\nsont venues à la Guilde, c'est pour une raison\ncarrément oh là là. Je te dis pas! Allez, si!", german="Hmm, wie auch immer. Die Damen von\nTeam [CS:X]Charme[CR] sind uns aus einem richtigen\nAuweia-Grund besuchen gekommen.", italian="Uhm, comunque, quelle del Team [CS:X]Malia[CR] sono\nvenute nella nostra Gilda per una qualche\nshock-ragione.", spanish="Bueno, el caso es que el [CS:X]Equipo Carisma[CR]\nha estado visitando el [CS:N]Pokégremio de[CR]\n[CS:N]Exploradores[CR] no sé muy bien por qué."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Turns out they're old friends of our\nGuildmaster. Wow![K] Oh my gosh, our\nGuildmaster is special!", french="En fait, ce sont de vieilles amies du Maître\nde la Guilde. Waouh![K] Ben mince alors, ce n'est\npas n'importe qui, le Maître de la Guilde!", german="Wie sich herausstellte, sind sie alte Freunde\ndes Gildenmeisters. Wow![K] Auweia, unser\nGildenmeister ist wirklich ungewöhnlich!", italian="È saltato fuori che sono vecchie amiche del\nnostro Capitano. Wow![K] Shock, il nostro\nCapitano è davvero speciale!", spanish="Resulta que además son viejas amigas del\nGran Bluff. ¡Hala![K] ¡El Gran Bluff es el mejor!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I feel lucky that I've stayed with the guild to\nfurther my training.", french="Une chance que je sois restée à la Guilde\npour approfondir mon entraînement.", german="Ich bin froh darüber, dass ich bei der Gilde\ngeblieben bin, um mein Training weiter\nvoranzutreiben.", italian="Mi sento fortunata a essere rimasta alla Gilda\nper continuare ad allenarmi.", spanish="Tengo suerte de haberme quedado en el\n[CS:N]Pokégremio[CR] para seguir practicando."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh...! [CS:N]Chimecho[CR] is eyeing me curiously. I can't\nwrite like this, oh my gosh!", french="Oh...! [CS:N]Eoko[CR] me regarde curieusement.\nBen mince alors, je ne peux pas écrire dans\nces conditions-là!", german="Oh! [CS:N]Palimpalim[CR] schaut mich so komisch an. So\nkann ich nicht schreiben, auweia!", italian="Oh...! [CS:N]Chimecho[CR] mi sta guardando con occhi\nincuriositi. Non posso scrivere cose così,\nshock!", spanish="Encima, [CS:N]Chimecho[CR] me está mirando en plan\ncotilla. O sea, ¡así no hay quien escriba!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="So that's all for tonight! Good night!", french="C'est tout pour aujourd'hui! Bonne nuit!", german="Das ist dann alles für heute Nacht! Gute Nacht!", italian="Quindi per questa sera è tutto! Buonanotte!", spanish="¡Hala! Pues dejo de escribir. ¡Buenas\nnoches!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 21 then
  -- @label_7 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Entry 21: Bidding Farewell\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 21: Tristes adieux\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 21: Abschied nehmen...\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 21: L'addio\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]21. Despedida\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Baby [CS:N]Manaphy[CR] went back to the sea...", french="Le bébé [CS:N]Manaphy[CR] est retourné à la mer...", german="Das kleine [CS:N]Manaphy[CR] ist ins Meer\nzurückgekehrt.", italian="Il piccolo [CS:N]Manaphy[CR] è tornato in mare...", spanish="[CS:N]Manaphy[CR] ha vuelto hoy al mar..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Poor [hero] and [partner] must be\ncrushed by this...", french="Les pauvres [hero] et [partner]\ndoivent avoir le cœur brisé...", german="[hero] und [partner] muss das echt\nnahe gehen.", italian="[hero] e [partner] devono essere\ncosì tristi...", spanish="Seguro que la moral de [hero] y\n[partner] está por los suelos..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I feel terrible for them...", french="Je compatis à leur tristesse...", german="Es tut mir schrecklich leid für sie.", italian="Mi sento male per loro...", spanish="¡Qué pena! Pobres..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But... This is exactly the time we must be\ncheerful around them to uplift their spirits!", french="Mais... c'est justement le moment de faire\npreuve d'entrain pour leur remonter le moral!", german="Aber genau jetzt ist die Zeit, heiter zu sein,\num ihren Gram zu vertreiben!", italian="Ma... Questo è proprio il momento in cui\ndobbiamo restare allegri per fare sentire\nmeglio loro!", spanish="En fin, es en estos momentos cuando\ntenemos que estar a su lado para que\nse animen."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="When I see [hero] and [partner]\ntomorrow, I'll have to greet them with a big\nsmile!", french="Quand je verrai [hero] et [partner]\ndemain, je les accueillerai avec\nun grand sourire!", german="Wenn ich [hero] und [partner]\nmorgen treffe, werde ich sie mit einem\nLächeln begrüßen!", italian="Quando domani vedrò [hero] e\n[partner], dovrò salutare con un grande\nsorriso!", spanish="¡Cuando vea mañana a [hero] y a\n[partner] les saludaré con una gran\nsonrisa!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 20 then
  -- @label_8 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Entry 20: Worries...\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 20: Je suis inquiète...\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 20: Sorgen...\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 20: Preoccupazioni...\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]20. Preocupaciones...\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I heard that baby [CS:N]Manaphy[CR] has fallen sick...[K]\nThis worries me so much!", french="J'ai entendu dire que le bébé [CS:N]Manaphy[CR]\nest tombé malade...[K] Je suis si inquiète!", german="Ich habe gehört, dass das kleine [CS:N]Manaphy[CR]\nkrank geworden ist.[K] Das macht mir große\nSorgen!", italian="Ho sentito che il piccolo [CS:N]Manaphy[CR] si è\nammalato...[K] Sono molto preoccupata!", spanish="Me he enterado de que el pequeño [CS:N]Manaphy[CR]\nestá enfermo...[K] ¡Qué preocupada me tiene!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:N]Corphish[CR] blurted out, \"Hey, hey! That baby\n[CS:N]Manaphy[CR] is probably a Pokémon that can only\ngrow up in the sea, hey, hey!\"", french="[CS:N]Ecrapince[CR] a déclaré: \"Eh dis donc! Ce bébé\n[CS:N]Manaphy[CR] est probablement un Pokémon qui doit\nvivre en milieu marin, dis donc!\"", german="[CS:N]Krebscorps[CR] platzte damit heraus, dass das\nkleine [CS:N]Manaphy[CR] bestimmt ein Pokémon ist,\ndas nur im Meer aufwachsen kann!", italian="[CS:N]Corphish[CR] mi ha rivelato che [CS:N]Manaphy[CR]\nprobabilmente è un Pokémon che può crescere\nsolo in mare, ehi, ehi!", spanish="[CS:N]Corphish[CR] piensa que [CS:N]Manaphy[CR] es un Pokémon\nque solo puede crecer en el mar."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I wanted to ask [CS:N]Corphish[CR], \"Then, why aren't\nyou in the water all the time?\"", french="J'ai failli demander à [CS:N]Ecrapince[CR]: \"Alors,\npourquoi tu ne passes pas ta vie dans l'eau,\ntoi?\"", german="Da wollte ich [CS:N]Krebscorps[CR] fragen, warum er\nnicht die ganze Zeit im Wasser ist.", italian="Volevo chiedere a [CS:N]Corphish[CR]: \"Allora, perché tu\nnon stai sempre in acqua?\"", spanish="Me entraron ganas de preguntarle a [CS:N]Corphish[CR]\nsi es que él tenía que estar todo el día en\nremojo."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But, oh my gosh, it wasn't the sort of thing to\nbring up just then!", french="Mais, oh là là, ce n'est pas le genre de choses\nà dire à ce moment-là!", german="Aber, auweia, das schien mir nicht der\nrichtige Zeitpunkt für eine Frage wie diese\nzu sein!", italian="Ma, shock, non sono domande da fare!", spanish="Lo dejé porque no era el momento de discutir."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Please get better soon, [CS:N]Manaphy[CR]!", french="Remets-toi vite, [CS:N]Manaphy[CR]!", german="Gute Besserung, [CS:N]Manaphy[CR]!", italian="Per favore rimettiti presto, [CS:N]Manaphy[CR]!", spanish="¡Ojalá que [CS:N]Manaphy[CR] se mejore!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 19 then
  -- @label_9 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Entry 19: Beaten to the Punch\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 19: Coiffée au poteau\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 19: Sie kamen uns zuvor!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 19: Battuta sul tempo\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]19. Menuda lección\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh! Team [team:] has already\nexplored the [CS:P]Surrounded Sea[CR] through and\nthrough!", french="Ben mince alors! L'Equipe [team:] a déjà\nratissé la [CS:P]Mer Fermée[CR] de fond en comble!", german="Auweia! Team [team:] hat das\n[CS:P]Ringmeer[CR] bereits ausgiebig erkundet!", italian="Shock! Il Team [team:] ha già esplorato\nil [CS:P]Mar Cinto[CR] in lungo e in largo!", spanish="¡Menudo plan! ¡El [CS:X]Equipo[CR] [team:] ya ha\nexplorado el [CS:P]Mar Circundante[CR] de cabo a rabo!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Eeeek! They've beaten me to the punch!", french="Hiii! On m'a coiffée au poteau!", german="Ieeek! Da sind sie mir wohl zuvorgekommen!", italian="Ehiiiii! Mi hanno battuta sul tempo!", spanish="¡Jo! ¡Lo han hecho antes que yo!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Being free associates of the guild gives those\nkids an advantage, though. They're free to\ngo wherever and whenever they want.", french="Cela dit, leur libre association avec la Guilde\nleur donne une longueur d'avance. Libres\ncomme le vent, libres comme l'air...", german="Freier Gildenpartner zu sein, verschafft diesen\nJungspunden einen Vorteil. Sie können überall\nhingehen, wann immer sie wollen.", italian="Non essere più membri interni della Gilda è un\nvantaggio per loro. Possono andare\novunque e quando vogliono.", spanish="Como ya han superado el gran reto, no se\natienen a las mismas normas: pueden ir\nadonde quieran y cuando quieran."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="As opposed to me with my guild work. I can't\nfind time like they can...", french="Contrairement à moi qui ai moins de temps\nlibre avec mes missions pour la Guilde...", german="Ganz im Gegensatz zu mir mit meinen\nVerpflichtungen innerhalb der Gilde. Ich kann\nmir nicht wie sie einfach die Zeit nehmen.", italian="Al contrario di me, che sono sempre impegnata\ncon il lavoro della Gilda. Non trovo mai il\ntempo per fare le cose...", spanish="Yo, por el contrario, no tengo manera de\nencontrar tiempo libre con tantas misiones\ndel [CS:N]Pokégremio de Exploradores[CR]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Eek! I don't like writing this![K] It's all so whiny\nand self-pitying. Oh my gosh!", french="Hiii! Je m'en veux d'écrire ça![K] On croirait\nune pleurnicheuse qui s'apitoie\nsur son sort. Oh là là!", german="Iek! Ich schreibe das hier nicht gerne![K] Es\nklingt alles so weinerlich und\nselbstbemitleidend. Auweia!", italian="Ehi! Non voglio scrivere queste cose![K] Non mi\npiace piangermi addosso. Shock!", spanish="¡Qué mal, qué mal![K] Pero, no voy a escribir\nmás sobre el tema. Que ya está bien de\nlamentarse."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I don't remember turning into this loathsome\ncharacter![K] Oh my gosh! What am I to do?\nWhat am I to do?!", french="Comment j'ai pu devenir aussi lamentable?[K]\nOh là là! Qu'est-ce que je vais faire? Mais\nqu'est-ce que je vais faire?!", german="Ich kann mich nicht daran entsinnen, mich zu\ndiesem abscheulichen Wesen entwickelt zu\nhaben![K] Auweia! Was soll ich nur tun?", italian="Da quand'è che sono diventata così cattiva?[K]\nShock! Cosa devo fare? Cosa devo fare?!", spanish="¡¿Desde cuándo soy tan quejica?![K] ¡Jo!\n¿Ahora qué voy a hacer? ¿Eh?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="P.S. That [hero]'s team brought back a\ntiny baby from the [CS:P]Surrounded Sea[CR].", french="P.-S. L'équipe de [hero] est revenue de\nla [CS:P]Mer Fermée[CR] avec un petit bébé.", german="P.S.: Das Team von [hero] hat ein\nkleines Pokémon vom [CS:P]Ringmeer[CR] mitgebracht.", italian="P.S. La squadra di [hero] ha riportato un\ncucciolotto dal [CS:P]Mar Cinto[CR].", spanish="P. D.: El equipo de [hero] ha vuelto del\n[CS:P]Mar Circundante[CR] con un pequeñín."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh! He's so mysterious! And so\nadorable! Yippee!", french="Ben mince alors! Il est si mystérieux!\nEt si trognon! Youpiii!", german="Auweia! Es ist so geheimnisvoll! Und so\nliebenswert! Hurra!", italian="Shock! Davvero misterioso! E così adorabile!\nEvviva!", spanish="¡Ay, ay! ¡Es muy misterioso! ¡Y es tan mono!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 18 then
  -- @label_10 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Entry 18: The [CS:P]Surrounded Sea[CR]!\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 18: La [CS:P]Mer Fermée[CR]!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 18: Das [CS:P]Ringmeer[CR]!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 18: Il [CS:P]Mar Cinto[CR]!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]18. El [CS:P]Mar Circundante[CR]\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh! I heard a fantastic rumor!", french="Ben mince alors! J'ai entendu une rumeur\nfantastique!", german="Auweia! Ich habe ein fantastisches Gerücht\naufgeschnappt!", italian="Shock! Ho saputo una cosa fantastica!", spanish="¡No te imaginas de lo que me he enterado!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="A rumor about a place called the [CS:P]Surrounded\nSea[CR]! Eek!", french="Une rumeur à propos d'un endroit qu'on appelle\nla [CS:P]Mer Fermée[CR]! Hiii!", german="Ein Gerücht über einen Ort namens\n[CS:P]Ringmeer[CR]! Iek!", italian="Una diceria a proposito di un posto chiamato\n[CS:P]Mar Cinto[CR]! Ehi!", spanish="¡Ay! Al parecer hay un territorio fantástico\nque se llama [CS:P]Mar Circundante[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="What treasures would one find at a place like\nthat...?", french="Quel genre de trésors peut bien cacher\nun endroit comme celui-là...?", german="Was für Schätze ein solcher Ort wohl\nbereithält?", italian="Chissà quanti tesori si potrebbero trovare in\nun posto come quello...", spanish="¿Te imaginas la de tesoros que habrá allí?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh! Yippee! I want to go there!", french="Ben mince alors! Youpiii! Je veux y aller!", german="Auweia! Hurra! Ich will dorthin reisen!", italian="Shock! Evviva! Ci voglio andare!", spanish="¡Ay, ay, ay, que me da! ¡Quiero ir cuanto\nantes!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I want to go so much, I feel like I'm going to\nfaint just from writing about it!", french="Je veux tellement y aller, que j'ai l'impression\nque je vais m'évanouir rien que d'en parler!", german="Ich will so sehr dorthin, dass ich schon fast in\nOhnmacht falle, wenn ich nur darüber\nschreibe!", italian="Ci voglio davvero andare, solo a pensarci mi\nsento svenire!", spanish="¡Tengo tantas ganas de ir que me estoy\nemocionando solo con escribir sobre ese\nsitio!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I think I will find time between my guild jobs\nand go! Oh my gosh! Yes, I will!", french="Je crois que je vais prendre le temps d'y aller\nentre deux missions pour la Guilde! Oh là là!\nC'est décidé, je vais le faire!", german="Ich denke mal, ich werde mir einfach etwas\nZeit zwischen meinen Gildenjobs nehmen und\ndorthin reisen! Auweia! Ja, das werde ich!", italian="Cercherò di trovare il tempo tra una missione\ne l'altra della Gilda! Shock! Sì, lo farò!", spanish="¡Ay! A ver si entre misión y misión me\npuedo escapar. ¡Tengo que ir!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 17 then
  -- @label_11 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Entry 17: Yay! Graduation!\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 17: Youpiii! Le diplôme!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 17: Abschluss geschafft!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 17: Sì! Ce l'hanno fatta!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]17. ¡Sí! ¡Reto superado!\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="They did it!", french="C'est une réussite!", german="Sie haben es geschafft!", italian="Ce l'hanno fatta!", spanish="¡Lo consiguieron!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Those kids made it through the graduation\nexam!", french="Les jeunes pousses ont décroché leur diplôme!", german="Diese Jungspunde haben die Abschlussprüfung\nbestanden!", italian="Hanno passato l'esame della Gilda!", spanish="¡Han superado el gran reto del [CS:N]Pokégremio[CR]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh! The members of Team\n[team:] were so adorable when they\njoined the guild...[K] Now they're authorities!", french="Oh là là! Les deux de l'Equipe [team:]\nétaient si trognons à leur arrivée à la\nGuilde...[K] Et les voilà maintenant des légendes!", german="Auweia! Die Mitglieder von Team [team:]\nwaren so liebenswert, als sie sich der Gilde\nanschlossen.[K] Jetzt sind sie echte Autoritäten.", italian="Shock! Sembra ieri che i membri\ndel Team [team:] sono arrivati alla\nGilda...[K] E ora sono delle autorità!", spanish="El [CS:X]Equipo[CR] [team:] era tan entrañable\ncuando llegó...[K] ¡Y ahora...! ¡Jo! ¡Ahora son\nsuperprofesionales!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It's sad that they're leaving the guild...[K]\nBut Sharpedo Bluff is very close by. I can\nvisit them anytime.", french="C'est triste de les voir partir de la Guilde...[K]\nMais la Falaise Sharpedo n'est pas loin.\nJe pourrai leur rendre visite quand je veux.", german="Es ist traurig, dass sie die Gilde verlassen.[K]\nAber die Tohaido-Klippe ist ja ganz in der Nähe.\nIch kann sie also jederzeit besuchen.", italian="Mi spiace che lascino la Gilda...[K] Ma il\nPromontorio Sharpedo è molto vicino.\nPosso andare spesso da loro.", spanish="Es una pena que tengan que abandonar el\n[CS:N]Pokégremio[CR]...[K] pero el Risco Sharpedo está\nmuy cerca y podré pasarme cuando quiera."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="So [hero] and [partner]...\nCongratulations!", french="Félicitations, [hero] et [partner]!", german="Also, [hero] und [partner].\nGlückwunsch!", italian="Dunque, [hero] e [partner]...\nCongratulazioni!", spanish="¡Enhorabuena, [hero] y [partner]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Do visit us at the guild even after you\ngraduate!", french="Continuez à nous rendre visite à la Guilde,\nmême une fois votre diplôme en poche!", german="Besucht uns in der Gilde auch nach dem\nbestandenen Abschluss!", italian="Venite a trovarci alla Gilda anche se ormai\navete passato l'esame!", spanish="¡Hacednos una visita de vez en cuando,\naunque ya hayáis superado el gran reto!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 16 then
  -- @label_12 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Entry 16: Graduation Exam\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 16: L'examen de la Guilde\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 16: Die Abschlussprüfung\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 16: L'esame di diploma\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]16. El gran reto\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Team [team:] has been chosen to take the\ngraduation exam.", french="L'Equipe [team:] a été admise pour\npasser l'examen de la Guilde.", german="Team [team:] wurde ausgewählt, um die\nAbschlussprüfung abzulegen.", italian="Il Team [team:] è stato scelto per\nsostenere l'esame della Gilda.", spanish="Han elegido al [CS:X]Equipo[CR] [team:] para\nafrontar el gran reto del [CS:N]Pokégremio[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But graduation...[K] Oh my gosh! I remember\nwhen they asked me if I wanted to take it...", french="Mais l'examen...[K] Oh là là! Je me souviens\nquand on m'a demandé si je voulais le\npasser...", german="Abschlussprüfung...[K] Auweia! Ich erinnere mich\nnoch daran, als sie mich danach fragten, ob ich\nsie ablegen wolle.", italian="Ma l'esame...[K] Shock! Mi ricordo quando mi\nhanno chiesto se volevo provarlo...", spanish="¡Jo![K] Me ha traído recuerdos de cuando me\npreguntaron a mí si quería intentarlo..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="At the time, I refused because I wanted to\ntrain some more at the guild.", french="A l'époque, j'ai refusé parce que je voulais\ncontinuer à m'entraîner à la Guilde.", german="Zu jenem Zeitpunkt habe ich abgelehnt, da ich\nnoch etwas länger in der Gilde trainieren\nwollte.", italian="Allora avevo rifiutato perché volevo\nallenarmi ancora un po' alla Gilda.", spanish="Entonces dije que no porque quería entrenarme\nalgo más en el [CS:N]Pokégremio de Exploradores[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Last year, [CS:N]Loudred[CR] took the exam... Of course,\nhe failed in spectacular fashion...", french="L'an dernier, [CS:N]Ramboum[CR] a passé l'examen...\nComme on pouvait s'y attendre, il a essuyé\nun échec retentissant...", german="Letztes Jahr hat sich [CS:N]Krakeelo[CR] an der Prüfung\nversucht, scheiterte aber auf spektakuläre Art\nund Weise.", italian="L'anno scorso, ci ha provato [CS:N]Loudred[CR]...\nOvviamente ha fallito in modo spettacolare...", spanish="El año pasado, [CS:N]Loudred[CR] lo intentó y, cómo\nno, metió la pata estrepitosamente..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But those kids can make it! I'm sure of it! Eek!", french="Mais les jeunes pousses peuvent y arriver!\nJ'en suis sûre! Hiii!", german="Aber diese Jungspunde können es schaffen!\nDa bin ich mir sicher! Iek!", italian="Ma loro ce la possono fare! Ne sono certa! Ehi!", spanish="Pero creo que con este equipo el resultado\nva a ser muy diferente. ¡Estoy segura!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I'll be cheering for them!", french="Je les encouragerai!", german="Ich werde sie anfeuern!", italian="Farò il tifo per loro!", spanish="¡Les daré todo el ánimo posible!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="P.S. It's that time of year again! The season\nof the grand master of all things bad![K] Yippee!", french="P.-S. Ça y est, le temps est venu! C'est\nla saison du grand maître de tous les maux![K]\nYoupiii!", german="P.S.: Es ist wieder diese ganz bestimmte Zeit\ndes Jahres! Die Jahreszeit des Großmeisters\nallen Übels![K] Hurra!", italian="P.S. È arrivato di nuovo quel momento!\nL'entrata in scena di Sua Malvagità, il più\ncattivo di tutti i cattivissimi![K] Shock!", spanish="P. D.: ¡Llegó la hora de que el gran malo\nrequetemalo campe a sus anchas por ahí![K]\n¡Bien!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 15 then
  -- @label_13 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Entry 15: They're Saving Us!\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 15: Nos sauveurs!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 15: Sie retten uns!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 15: Salvate il pianeta!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]15. ¡Nos salvarán!\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Our future is in the hands of those two kids.", french="Notre avenir est entre les mains des jeunes\npousses.", german="Unsere Zukunft liegt in den Händen dieser\nbeiden Jungspunde.", italian="Il nostro futuro è nelle mani di quella squadra!", spanish="Nuestro futuro está en manos de esa pareja."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But I'm convinced that those kids will not fail\nto stop the planet's paralysis.", french="Mais je leur fais entièrement confiance\npour réussir à empêcher la Paralysie de\nla Planète.", german="Aber ich bin überzeugt davon, dass sie die\nLähmung des Planeten aufhalten werden.", italian="Ma sono convinta che riusciranno a scongiurare\nla paralisi del pianeta.", spanish="Pero estoy segura de que evitarán la parálisis\ndel planeta."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="That [hero] and [partner]! Oh, but\ndon't forget [CS:N]Lapras[CR] and [CS:N]Grovyle[CR] too!", french="[hero] et [partner]! Sans oublier\n[CS:N]Lokhlass[CR] et [CS:N]Massko[CR]!", german="[hero] und [partner]! Oh, und nicht\nzu vergessen, [CS:N]Lapras[CR] und [CS:N]Reptain[CR]!", italian="[hero] e [partner]! Oh, ma non\ndimentichiamo [CS:N]Lapras[CR] e [CS:N]Grovyle[CR]!", spanish="¡[hero] y [partner] son geniales!\n¡Y tampoco hay que olvidar que están\ncon [CS:N]Lapras[CR] y [CS:N]Grovyle[CR]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="You can't fail us!", french="Vous devez y arriver!", german="Ihr dürft uns nicht enttäuschen!", italian="Non potete fallire!", spanish="¡No nos pueden fallar!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I hope you all come back safe and sound to\nTreasure Town. Soon!", french="J'espère que vous rentrerez à Bourg-Trésor\nindemnes. Et vite!", german="Ich hoffe, dass ihr alle sicher und wohlbehalten\nnach Schatzstadt zurückkehrt. Und zwar bald!", italian="Spero tornerete tutti sani e salvi a Borgo\nTesoro. Presto!", spanish="¡Ojalá vuelvan sanos y salvos a Aldea Tesoro!\n¡Y pronto!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 14 then
  -- @label_14 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Entry 14: Welcome Back!\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 14: Les revoilà!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 14: Willkommen zurück!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 14: Di nuovo a casa!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]14. ¡Ya están de vuelta!\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh! Yippee! What a shock!", french="Ben mince alors! Youpiii! Quelle surprise!", german="Auweia! Hurra! Was für ein Schock!", italian="Shock! Evviva! Che shock!", spanish="¡Ay, ay, ay! ¡Madre mía! ¡Qué emoción!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It's totally amazing! Team [team:] came\nback![K] From the future! Oh my gosh!", french="J'hallucine! L'Equipe [team:] est\nrevenue![K] Du futur! Oh là là!", german="Es ist absolut erstaunlich! Team [team:]\nist zurückgekehrt![K] Aus der Zukunft! Auweia!", italian="È davvero meraviglioso! Il Team [team:]\nè tornato![K] Dal futuro! Shock!", spanish="¡Ha sido increíble! El [CS:X]Equipo[CR] [team:] ha\nvuelto...[K] ¡del futuro!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It was such an amazing thing! Yippee!", french="C'est si incroyable! Youpiii!", german="Das war so ein dermaßen erstaunliches\nEreignis! Hurra!", italian="È così emozionante! Evviva!", spanish="¡No me lo puedo creer!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="We were even more amazed by [partner]'s\naccount of it all. Oh my gosh!", french="Ce qui nous a encore plus surpris, c'est ce que\nnous a raconté [partner]. Ben mince alors!", german="Was uns aber noch mehr erstaunt hat, war der\nBericht von [partner] über all die\nGeschehnisse. Auweia!", italian="E il racconto di [partner] è stato ancora\npiù emozionante. Shock!", spanish="Cuando [partner] nos contó la historia, nos\ndejó a todos boquiabiertos."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But if those kids said it, then it must be true.", french="Mais si l'Equipe [team:] le dit, ça doit\nêtre vrai.", german="Aber wenn diese Jungspunde das sagen, dann\nmuss es stimmen.", italian="Se lo dicono loro, dev'essere vero.", spanish="Pero si lo dicen, debe ser verdad."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I choose to believe the kids.", french="J'ai décidé de les croire.", german="Ich glaube ihnen.", italian="Voglio credere a quello che dicono.", spanish="Yo me lo creo."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh![K] Then does that mean...", french="Oh![K] Mais alors, ça voudrait dire...", german="Oh![K] Dann bedeutet das...", italian="Oh![K] Allora significa...", spanish="¡Oh![K] Entonces eso quiere decir que..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="That the great [CS:N]Dusknoir[CR], who I revere...[K]is\nactually a bad Pokémon?!", french="... que le grand [CS:N]Noctunoir[CR], que\nj'admire et vénère tant...[K] est en réalité...\nun méchant Pokémon?!", german="Dann bedeutet das, dass der große [CS:N]Zwirrfinst[CR],\nden ich bewundere,[K] in Wirklichkeit ein\nbösartiges Pokémon ist?!?", italian="Che il grande [CS:N]Dusknoir[CR], che io riverisco...[K] è\nun Pokémon cattivo?!", spanish="Mi admirado [CS:N]Dusknoir[CR] es...[K] ¡¿un Pokémon\nde los malos?!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh...[K] A bad Pokémon?!", french="Ben mince alors...[K] Un méchant Pokémon?!", german="Auweia.[K] Ein bösartiges Pokémon?!?", italian="Shock...[K] un Pokémon cattivo?!", spanish="¡Ay, ay, ay![K] ¡¿Uno de los malos?!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="What should I do?! What should I do?!", french="Qu'est-ce que je dois faire?!\nMais qu'est-ce que je dois faire?!", german="Was soll ich nur tun?!? Was soll ich nur\ntun?!?", italian="Cosa devo fare?! Cosa devo fare?!", spanish="No sé qué hacer..."})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 13 then
  -- @label_15 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Entry 13: Those Kids...\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 13: Les jeunes pousses...\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 13: Diese Kinder...\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 13: Quella squadra...\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]13. Vaya par...\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Everyone, including myself, is down in the\ndumps at the guild.", french="Tout le monde à la Guilde est au\ntrente-sixième dessous, moi y compris.", german="Alle in der Gilde, mich eingeschlossen, sind\nniedergeschlagen.", italian="Tutti, me inclusa, sono in depressione alla\nGilda.", spanish="Todos los miembros del [CS:N]Pokégremio[CR],\nservidora incluida, estamos deprimidos."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I thought about why the guild is lacking energy\nlately... The answer is easy.", french="Je me demandais pourquoi c'est si morne\nà la Guilde en ce moment... La réponse est\ntoute simple.", german="Ich habe mich gefragt, warum es der Gilde in\nletzter Zeit so an Antrieb fehlt. Die Antwort\nliegt auf der Hand.", italian="Mi chiedevo perché ultimamente manchi la\ncarica d'energia alla Gilda... La risposta è\nsemplice.", spanish="Ahora me doy cuenta de por qué todo es\núltimamente tan aburrido por aquí. Está\nclaro como el agua."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It's because...[K]Team [team:] is missing.", french="C'est parce que...[K] L'Equipe [team:] est\nabsente.", german="Es liegt daran, dass Team [team:]\nverschwunden ist.", italian="È perché...[K] manca il Team [team:].", spanish="Es porque...[K] el [CS:X]Equipo[CR] [team:] no está."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I didn't realize how lonely it would be without\nTeam [team:]...", french="Je ne me rendais pas compte à quel point\nce serait triste sans l'Equipe [team:]...", german="Ich habe nicht geahnt, wie einsam es ohne\nTeam [team:] sein würde.", italian="Non mi ero accorta di quanto possa essere\ndesolante la Gilda senza il Team [team:]...", spanish="No me había dado cuenta de cómo se nota\nla ausencia del [CS:X]Equipo[CR] [team:]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:N]Chatot[CR] has been very ill tempered lately and\nprone to annoying outbursts...[K] But that's also\nbecause he misses those kids.", french="[CS:N]Pijako[CR] est très irritable en ce moment et\nil a de ces accès de colère...[K] Mais c'est que, à\nlui aussi, ces deux-là lui manquent.", german="[CS:N]Plaudagei[CR] ist seit einiger Zeit übel gelaunt und\nneigt zu Wutausbrüchen.[K] Aber das liegt auch\ndaran, dass er diese Jungspunde vermisst.", italian="[CS:N]Chatot[CR] ultimamente è molto irascibile e\ntende ad avere scatti d'ira fastidiosi...[K] Ma è\nperché anche a lui manca quella squadra.", spanish="[CS:N]Chatot[CR] está muy irascible últimamente...[K]\ny es porque también echa de menos a ese\npar."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh, I hope they're safe... Those kids...", french="Oh, j'espère que nos deux jeunes pousses\nvont bien...", german="Oh, ich hoffe, sie sind in Sicherheit... Diese\nJungspunde...", italian="Oh, spero stiano bene... ", spanish="¡Ay! ¡Solo espero que estén bien!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 12 then
  -- @label_16 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Entry 12: Total Shocker!\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 12: J'en reviens pas!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 12: Was für ein Schock!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 12: Un vero shock!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]12. ¡Impactante!\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh! It's been one shocking thing after\nanother lately!", french="Ben mince alors! C'est l'hallu totale\nces jours-ci!", german="Auweia! In letzter Zeit überschlagen sich die\nschockierenden Ereignisse!", italian="Shock! Ultimamente uno shock dietro l'altro!", spanish="¡Ay, ay, ay! ¡Estos días las sorpresas vienen\nuna detrás de otra!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It turns out that [CS:N]Grovyle[CR] is a wanted outlaw\non the run from (oh my gosh!) the future.", french="Il ressort que [CS:N]Massko[CR] est un criminel\nrecherché qui s'est évadé du futur. Ben mince\nalors!", german="Wie sich herausstellte, ist dieser [CS:N]Reptain[CR] ein\ngesuchter Ganove auf der Flucht aus\n(Auweia!) der Zukunft.", italian="È saltato fuori che [CS:N]Grovyle[CR] è un fuorilegge\nricercato che viene (shock!)... dal futuro!", spanish="Resulta que el tal [CS:N]Grovyle[CR] es un malhechor\nque, no te lo pierdas, ¡viene del futuro!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="And [CS:N]Dusknoir[CR] also came from the future\nto catch that [CS:N]Grovyle[CR]! Eek!", french="Et [CS:N]Noctunoir[CR] aussi est venu du futur pour\ncapturer [CS:N]Massko[CR]! Hiii!", german="Und [CS:N]Zwirrfinst[CR] ist auch aus der Zukunft\ngekommen, um [CS:N]Reptain[CR] zu schnappen! Iek!", italian="E anche [CS:N]Dusknoir[CR] viene dal futuro, per\ncatturare quel [CS:N]Grovyle[CR]! Ehi!", spanish="Pero eso no es todo, ¡[CS:N]Dusknoir[CR] también viene\ndel futuro para atrapar a [CS:N]Grovyle[CR]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="There have been so many unbelievable events!\nIt's like I'm in a perpetual state of shock!\nOh...my...gosh!", french="Il s'est passé tant de choses incroyables!\nJ'ai l'impression d'être tout le temps sous le\nchoc! Ben... mince... alors!", german="Es haben sich so viele unglaubliche Dinge\nereignet! Ich fühle mich wie in einem\ndauerhaften Schockzustand! Auweia!", italian="Sono successe così tante cose incredibili!\nMi sembra di vivere in un continuo stato di...\nshock! Sh... o... ck!", spanish="¡Jo! ¡Han pasado tantas cosas y todas tan\nincreíbles! ¡Estoy que me va a dar algo!\n¡Ay, ay...!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Anyway, [CS:N]Dusknoir[CR] vowed to catch [CS:N]Grovyle[CR]\non his own.", french="Enfin bref, [CS:N]Noctunoir[CR] a juré de s'occuper de\nla capture de [CS:N]Massko[CR] tout seul.", german="Wie auch immer, [CS:N]Zwirrfinst[CR] hat geschworen,\n[CS:N]Reptain[CR] auf eigene Faust zu schnappen.", italian="Comunque, [CS:N]Dusknoir[CR] si è impegnato a catturare\n[CS:N]Grovyle[CR] con le sue mani.", spanish="En fin, [CS:N]Dusknoir[CR] ha asegurado que atrapará a\n[CS:N]Grovyle[CR] él solito."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I'm sure the great [CS:N]Dusknoir[CR] will honor his\npledge, so [CS:N]Grovyle[CR] will be caught.", french="Je suis sûre que le grand [CS:N]Noctunoir[CR] tiendra\nsa promesse et qu'il attrapera [CS:N]Massko[CR].", german="Ich bin mir sicher, dass sich der große\n[CS:N]Zwirrfinst[CR] an sein Gelöbnis halten und\n[CS:N]Reptain[CR] geschnappt werden wird.", italian="Sono sicura che il grande [CS:N]Dusknoir[CR] onorerà il\nsuo impegno e che [CS:N]Grovyle[CR] finirà nelle\nmani della legge.", spanish="Yo estoy convencida de que el gran [CS:N]Dusknoir[CR]\nes un Pokémon de palabra, así que [CS:N]Grovyle[CR]\nacabará entre rejas."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="We have to leave everything up to [CS:N]Dusknoir[CR].", french="On doit laisser faire [CS:N]Noctunoir[CR].", german="Wir müssen [CS:N]Zwirrfinst[CR] nur machen lassen.", italian="Dobbiamo lasciar fare tutto a [CS:N]Dusknoir[CR].", spanish="Ahora solo tenemos que dejarlo todo en manos\nde [CS:N]Dusknoir[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Good luck, [CS:N]Dusknoir[CR]!", french="Bonne chance, [CS:N]Noctunoir[CR]!", german="Viel Glück, [CS:N]Zwirrfinst[CR]!", italian="Buona fortuna, [CS:N]Dusknoir[CR]!", spanish="¡Buena suerte, [CS:N]Dusknoir[CR]!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 11 then
  -- @label_17 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Entry 11: Where's [CS:N]Grovyle[CR]?\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 11: Mais où est [CS:N]Massko[CR]?\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 11: Wo ist [CS:N]Reptain[CR]?\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 11: Dov'è [CS:N]Grovyle[CR]?\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]11. ¿Dónde está [CS:N]Grovyle[CR]?\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The whole guild is now searching for that\nthieving [CS:N]Grovyle[CR].", french="A présent, toute la Guilde est à la recherche\nde [CS:N]Massko[CR] le voleur.", german="Die gesamte Gilde sucht nun nach diesem\ndiebischen [CS:N]Reptain[CR].", italian="L'intera Gilda sta cercando quel ladro di\n[CS:N]Grovyle[CR].", spanish="Todo el [CS:N]Pokégremio[CR] está intentando echarle\nel guante a ese ladrón de [CS:N]Grovyle[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:N]Bidoof[CR], [CS:N]Dugtrio[CR], and I searched [CS:P]Crystal Cave[CR].", french="[CS:N]Keunotor[CR], [CS:N]Triopikeur[CR] et moi, on a fouillé\nla [CS:P]Caverne Cristal[CR] de fond en comble.", german="[CS:N]Bidiza[CR], [CS:N]Digdri[CR] und ich haben die [CS:P]Kristallhöhle[CR]\ndurchsucht.", italian="[CS:N]Bidoof[CR], [CS:N]Dugtrio[CR] e io abbiamo cercato alla\n[CS:P]Grotta di Cristallo[CR].", spanish="[CS:N]Bidoof[CR], [CS:N]Dugtrio[CR] y yo hemos explorado la\n[CS:P]Cueva Cristal[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But our search turned up nothing.", french="Mais on n'a rien trouvé.", german="Aber unsere Suche ist ohne Ergebnis geblieben.", italian="Ma la nostra ricerca si è rivelata un nulla di\nfatto.", spanish="Pero no hemos dado con él."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Where could that [CS:N]Grovyle[CR] be...?", french="Où peut-il bien être ce [CS:N]Massko[CR]...?", german="Wo könnte dieser [CS:N]Reptain[CR] stecken?", italian="Dove può essere quel [CS:N]Grovyle[CR]?", spanish="¿Dónde se habrá metido [CS:N]Grovyle[CR]?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But he must be caught, no matter what!", french="Mais on doit l'attraper, coûte que coûte!", german="Aber er muss gefasst werden, ganz gleich,\nwas geschieht!", italian="Deve essere catturato, non importa come!", spanish="¡Tenemos que atraparlo como sea!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="For [CS:N]Uxie[CR]'s sake too, we'll catch that criminal!", french="On capturera ce criminel, pour [CS:N]Créhelf[CR]!", german="Auch für [CS:N]Selfe[CR] werden wir diesen Ganoven\nschnappen!", italian="Anche per il bene di [CS:N]Uxie[CR], cattureremo quel\ncriminale!", spanish="¡También tenemos que echarle el guante por\n[CS:N]Uxie[CR]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="P.S. That silly [CS:N]Bidoof[CR]...[K] Oh my gosh, he was\nno help looking for [CS:N]Grovyle[CR]...", french="P.-S. Quel boulet, ce [CS:N]Keunotor[CR]...[K] Oh là là,\non ne peut pas dire qu'il nous ait beaucoup aidé\nà chercher [CS:N]Massko[CR]...", german="P.S.: Dieser dumme [CS:N]Bidiza[CR].[K] Auweia, er war\nkeine Hilfe bei der Suche nach [CS:N]Reptain[CR].", italian="P.S. Quello sciocco di [CS:N]Bidoof[CR]...[K] Shock, non è\nstato molto d'aiuto nella ricerca di [CS:N]Grovyle[CR]...", spanish="P. D.: Vamos apañados con [CS:N]Bidoof[CR]...[K] Ha sido\nun cero a la izquierda buscando a [CS:N]Grovyle[CR]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Not only that, he even brought home a crystal\nas a souvenir! Eeek!", french="Et en plus, il a piqué un cristal en souvenir!\nHiii!", german="Nicht nur das, er hat sogar einen Kristall als\nAndenken mit nach Hause gebracht! Ieek!", italian="Non solo, si è pure portato a casa un cristallo\nper ricordo! Ehiiii!", spanish="¡Encima se ha traído un cristal de recuerdo!\n¡Ya le vale!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="That reminds me...[K] When we were leaving\n[CS:P]Crystal Cave[CR], I caught [CS:N]Bidoof[CR] grinning to\nhimself...", french="Tiens, ça me rappelle que...[K] quand on a quitté\nla [CS:P]Caverne Cristal[CR], j'ai surpris [CS:N]Keunotor[CR]\nun petit sourire aux lèvres...", german="Das erinnert mich an...[K] Als wir von der\n[CS:P]Kristallhöhle[CR] aufgebrochen sind, habe ich [CS:N]Bidiza[CR]\nin sich hineingrinsen sehen.", italian="A proposito...[K] Quando stavamo per andarcene\ndalla [CS:P]Grotta di Cristallo[CR], ho beccato [CS:N]Bidoof[CR] che\nridacchiava tra sé e sé...", spanish="Ahora que caigo...[K] Cuando volvíamos de la\n[CS:P]Cueva Cristal[CR], [CS:N]Bidoof[CR] tenía una sonrisilla\nun tanto sospechosa..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Now that I think about it... Oh my gosh, that\nwas him grinning about that crystal!", french="Maintenant que j'y pense... Oh là là, il souriait\nsûrement à cause du cristal!", german="Jetzt, wo ich darüber nachdenke... Auweia, er\nhat über diesen Kristall gegrinst!", italian="Ora che ci penso... Shock, ridacchiava per via\ndi quel cristallo!", spanish="¡Claro! O sea, ¡que era por el cristal por lo\nque estaba tan raro!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh, I never suspected [CS:N]Bidoof[CR] could\nleer in such an icky way! Eek!", french="Ben mince alors, jamais je ne me serais doutée\nque [CS:N]Keunotor[CR] puisse avoir une expression\naussi machiavélique! Hiii!", german="Auweia, ich hätte nie gedacht, dass [CS:N]Bidiza[CR] so\neklig grinsen könnte! Iek!", italian="Shock, non avrei mai sospettato che [CS:N]Bidoof[CR]\npotesse essere così avido! Ehi!", spanish="¡Jo! ¡Nunca habría imaginado que [CS:N]Bidoof[CR]\npodría ser así de raro!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It's another new discovery! Eek!", french="Encore une découverte! Hiii!", german="Das ist eine weitere neue Entdeckung! Iek!", italian="Si scopre sempre qualcosa di nuovo!", spanish="¡Nunca te acostarás sin saber una cosa más!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 10 then
  -- @label_18 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Entry 10: Oh My Gosh! [CS:N]Dusknoir[CR]!\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 10: Oh là là! [CS:N]Noctunoir[CR]!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 10: Oh Mann! [CS:N]Zwirrfinst[CR]!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 10: Shock! [CS:N]Dusknoir[CR]!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]10. ¡Gracias, [CS:N]Dusknoir[CR]!\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh oh my gosh oh my gosh!\nThe famous [CS:N]Dusknoir[CR] came to our guild!\nYippee!", french="Ben mince alors! Ben mince alors! Ben mince\nalors! Le célèbre [CS:N]Noctunoir[CR] est venu\nà la Guilde! Youpiii!", german="Auweiaauweiaauweia!\nDer berühmte [CS:N]Zwirrfinst[CR] hat unserer Gilde\neinen Besuch abgestattet! Hurra!", italian="Shock shock shock! Il famoso [CS:N]Dusknoir[CR]\nè venuto alla Gilda! Evviva!", spanish="¡Ay, ay, ay! ¡El famoso [CS:N]Dusknoir[CR] vino el otro\ndía al [CS:N]Pokégremio[CR]! ¡Qué emoción!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="And...and...and...! He plans to stay in Treasure\nTown for a while! Yippee!", french="Et... devinez quoi... Il a l'intention de rester\nun moment à Bourg-Trésor! Youpiii!", german="Und... und... und! Er beabsichtigt, eine Weile in\nSchatzstadt zu bleiben! Hurra!", italian="E... e... e...! Pensa di fermarsi a Borgo Tesoro\nper un po'! Evviva!", spanish="Y... Y además... ¡Quiere quedarse una\ntemporada en Aldea Tesoro! ¡No me lo\npuedo creer!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I got to talk to him! He's wise! And courteous!\nAnd handsome! And oh my gosh...[K]yippee!", french="J'ai même pu lui parler! Il connaît tant de\nchoses et il est si galant! Et en plus, il est\ntrop canon!!! Ben mince alors... [K]youpiii!", german="Ich muss mit ihm reden! Er ist weise! Und\nhöflich! Und gutaussehend! Und auweia...[K]\nHurra!", italian="Devo parlargli! È saggio! E cortese!\nE bello! E shock...[K] evviva!", spanish="Lo mejor es que pude hablar con [CS:N]Dusknoir[CR]\npersonalmente. Es superlisto, supereducado y\nsuperguapo...[K] O sea, ¡superideal!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Yip-yip-yippee! That's what it feels like!", french="Youp-youp-youpiii! Voilà ce que je ressens\nquand il est là!", german="Hip-hip-hurra! So fühlt sich das an!", italian="Evviva, evviva, evviva! Non c'è altro modo\ndi descrivere come mi sento adesso!\nEvviva, evviva, evviva!", spanish="¡Le gusto! ¡O no le gusto!\n¡Le gusto! ¡O no le gusto!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 9 then
  -- @label_19 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Entry 9: Back Home!\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 9: De retour chez nous!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 9: Wieder zu Hause!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 9: Casa dolce casa!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]9. ¡Vuelta a casa!\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="We just got back from our expedition now!\nOh my gosh! Am I exhausted!", french="On vient juste de rentrer de l'expédition!\nBen mince alors! Je suis méga-vannée!", german="Wir sind gerade von unserer Expedition\nzurückgekehrt! Auweia! Ich bin erschöpft!", italian="Siamo appena tornati dalla spedizione!\nShock! Sono esausta!", spanish="¡Acabamos de volver de la expedición! ¡Uf!\n¡Estoy agotada!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Ooh! This expedition left a big impression\non me in every way!", french="Ooh! Cette expédition a été très marquante,\nà bien des égards!", german="Ooh! Diese Expedition hat in jeder Hinsicht\neinen bleibenden Eindruck bei mir hinterlassen!", italian="Ooh! Questa spedizione mi ha impressionato\nin tutti i sensi!", spanish="¡Pero la expedición mereció mucho la pena!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Especially the sight of [CS:P]Fogbound Lake[CR]...[K] Oh my\ngosh, it moved me in ways I can't express!", french="Surtout quand on est arrivés au [CS:P]Lac des\nBrumes[CR]...[K] Oh là là, ça m'a tellement émue\nque je ne trouve pas les mots!", german="Besonders der Anblick des [CS:P]Nebelsees[CR].[K] Auweia,\ndas hat mich so sehr bewegt, ich kann das gar\nnicht in Worte fassen!", italian="Specialmente vedere il [CS:P]Lago Foschia[CR]...[K] Shock,\nmi ha fatto provare emozioni indescrivibili!", spanish="Sobre todo cuando vimos el [CS:P]Lago Velado[CR]...[K]\n¡No puedo expresar con palabras lo que\nsentí!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh! But if I write any more details, [CS:N]Uxie[CR] would\nbe so upset. And that wouldn't be good! Eek!", french="Oh! Si je le décris plus en détails, [CS:N]Créhelf[CR]\nm'en voudra. Mieux vaut ne pas tenter\nle Pokémon, comme on dit! Hiii!", german="Oh! Aber falls ich weitere Details preisgebe,\nwäre [CS:N]Selfe[CR] sicher sehr erzürnt. Und das wäre\nnicht gut! Iek!", italian="Oh! Ma se scrivo altri dettagli, [CS:N]Uxie[CR] potrebbe\narrabbiarsi. E non sarebbe una bella cosa! Ehi!", spanish="¡Jo! Se me olvidaba que no puedo escribir\nnada sobre eso porque [CS:N]Uxie[CR] se molestaría\n¡Y eso es lo último que queremos!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="This was the best of all the expeditions I've\nattended!", french="C'était l'expédition la plus chouette à laquelle\nj'aie jamais participé!", german="Das war die beste Expedition, an der ich je\nteilgenommen habe!", italian="È stata la migliore spedizione a cui abbia mai\npartecipato!", spanish="Esta ha sido la mejor de todas las expediciones\nen las que he participado."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Ooh, I hope I can go with everyone again\nsometime!", french="Ooh, j'espère qu'on repartira tous ensemble\nun de ces jours!", german="Ooh, ich hoffe, dass ich irgendwann noch\neinmal mit allen losziehen kann!", italian="Ooh, spero di poterci tornare ancora\nun'altra volta insieme a tutti quanti!", spanish="¡Ay! Solo espero poder volver a ese sitio con\ntodos en otra ocasión."})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 8 then
  -- @label_20 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Entry 8: Inspiration!\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 8: Inspiration!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 8: Inspiration!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 8: Ispirazione!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]8. ¡Inspiración!\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh! Something happened that was\ntotally uplifting!", french="Ben mince alors! Cher journal, il s'est passé\nquelque chose qui m'a donné des ailes! Enfin,\nfaçon de parler...", german="Auweia! Etwas sehr Erbauliches ist geschehen!", italian="Shock! È successo qualcosa di molto bello!", spanish="¡Ay, ay, ay! ¡Hoy ha pasado algo sorprendente!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Tonight, Team [team:] had to go without\ndinner for some silly reason...", french="Ce soir, l'Equipe [team:] a dû aller au lit\nsans dîner, pour je ne sais quelle raison\nstupide...", german="Heute Abend hat Team [team:] aus\nirgendeinem dummen Grund kein Essen\nbekommen.", italian="Stasera, il Team [team:] è stato lasciato\nsenza cena per qualche sciocca ragione...", spanish="Esta noche, el [CS:X]Equipo[CR] [team:] se ha ido a\nla cama sin cenar no sé muy bien por qué..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="While we were eating (oh my gosh!), [CS:N]Bidoof[CR]\nwas leaving a part of his dinner untouched!", french="Pendant le repas (ben mince alors!), [CS:N]Keunotor[CR]\na mis une partie de son dîner de côté!", german="Als wir aßen (Auweia!), hat [CS:N]Bidiza[CR] einen Teil\nseines Essens beiseitegelegt!", italian="Mentre mangiava, [CS:N]Bidoof[CR] ha lasciato da\nparte (shock!) un po' della sua cena!", spanish="El caso es que cuando estábamos cenando,\nno te lo pierdas, ¡[CS:N]Bidoof[CR] estaba guardando\nparte de la comida!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="And this is [CS:N]Bidoof[CR], right? The one we call the\n\"bottomless barrel\" because of his big appetite!", french="Oui oui, je parle bien de [CS:N]Keunotor[CR]. Celui qu'on\nsurnomme le \"tonneau sans fond\", à cause\nde son appétit d'ogre!", german="Und das soll dem [CS:N]Bidiza[CR], den wir aufgrund\nseines grenzenlosen Appetits das [F:S2]Fass ohne\nBoden[F:E2] nennen, ähnlich sehen?", italian="Ed era [CS:N]Bidoof[CR], capito? Quello che chiamiamo\n\"pozzo senza fondo\" per via del suo appetito!", spanish="Estamos hablando de [CS:N]Bidoof[CR], ¡al que llamamos\n\"pozo sin fondo\" por lo que traga!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Whatever could have caused that?! Maybe he's\nheartbroken!", french="Qu'est-ce qui a bien pu lui arriver?! Peut-être\nqu'il a le cœur brisé!", german="Was könnte das wohl verursacht haben?\nVielleicht leidet er an gebrochenem Herzen!", italian="Non riuscivo a capire perché stesse facendo\nuna cosa del genere. Ho pensato addirittura\nche si fosse innamorato!", spanish="¿Que por qué ha hecho eso? Igual es porque\nsufre mal de amores..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Well, I guessed that at first. But then I\nfigured out what he was really doing.", french="Ben, c'est ce que je pensais au début. Et puis\nj'ai compris ce qu'il avait derrière la tête.", german="Nun, das dachte ich zunächst auch, aber dann\nbin ich dahintergekommen, was er wirklich\nvorhatte.", italian="Beh, all'inizio ho pensato così. Ma poi ho intuito\nquali erano le sue intenzioni.", spanish="Eso es lo que pensé al principio, pero luego\naverigüé qué era lo que se traía entre manos."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="He was leaving some of his dinner for\n[hero]'s team.", french="Il mettait une partie de son repas de côté pour\nl'équipe de [hero].", german="Er hat einen Teil seines Essens dem Team von\n[hero] überlassen.", italian="Stava tenendo da parte un po' della sua cena\nper la squadra di [hero].", spanish="Estaba guardando parte de su cena para el\nequipo de [hero]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Then (oh my gosh!) the others noticed too.", french="C'est là que (ben mince alors!) les autres\nl'ont remarqué aussi.", german="Daraufhin (Auweia!) haben es die anderen auch\nbemerkt.", italian="Poi (shock!) se ne sono accorti anche gli altri.", spanish="Y no solo fui yo la que se dio cuenta..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="So we all did what [CS:N]Bidoof[CR] was doing. We left\nbits and pieces of our dinner.[K] (Though [CS:N]Loudred[CR]\nagonized over the decision to the end.)", french="Alors on a tous imité [CS:N]Keunotor[CR], en mettant\nun petit quelque chose de côté.[K] (Même si\n[CS:N]Ramboum[CR], lui, a tergiversé jusqu'à la fin.)", german="Wir alle taten es [CS:N]Bidiza[CR] gleich und entschieden,\nTeile unseres Essens aufzuheben.[K] (Allerdings\nquälte sich [CS:N]Krakeelo[CR] bis zum Schluss damit.)", italian="Così abbiamo fatto tutti come [CS:N]Bidoof[CR]. Abbiamo\nmesso da parte qualcosa da mangiare.[K] (Anche\nse [CS:N]Loudred[CR] era piuttosto angosciato.)", spanish="Así que todos hicimos lo mismo que [CS:N]Bidoof[CR].\nGuardamos parte de nuestra cena.[K] (Aunque\n[CS:N]Loudred[CR] lo hizo a regañadientes.)"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Yippee! Everyone pitched in to help! How sweet\nof them! Oh my gosh, I am getting emotional!", french="Youpiii! Tout le monde a mis la main à la pâte!\nComme c'est mignon de leur part! Ben mince\nalors, je suis toute émue!", german="Hurra! Alle sprangen ein, um zu helfen! Wie\nnett von ihnen! Auweia, ich werde ganz\ngefühlsduselig!", italian="Evviva! Hanno partecipato tutti! Che dolci!\nShock, mi sto commuovendo!", spanish="Vaya, ¡todos arrimaron el hombro! Fue algo\nmuy bonito... ¡Casi se me saltan las lágrimas!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="In the end, we decided to share the smaller\nthings ourselves and leave them with one\nwhole [CS:I]Apple[CR] each!", french="On a fini par se mettre d'accord pour partager\nentre nous les petits restes pour leur laisser\ndeux [CS:I]Pommes[CR] entières!", german="Zum Schluss haben wir entschieden, die\nkleineren Dinge unter uns aufzuteilen und jedem\nvon ihnen einen ganzen [CS:I]Apfel[CR] zu überlassen!", italian="Alla fine, abbiamo deciso di dividere fra di noi\nle piccole cose e di dargli una [CS:I]Mela[CR] a testa!", spanish="Al final acordamos compartir los trozos más\npequeños y reservarles dos [CS:I]Manzanitas[CR]\nenteras."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:N]Chimecho[CR], [CS:N]Bidoof[CR], and I will keep those two\n[CS:I]Apples[CR] for the night.", french="[CS:N]Eoko[CR], [CS:N]Keunotor[CR] et moi, on va garder\nces deux [CS:I]Pommes[CR] cette nuit.", german="[CS:N]Palimpalim[CR], [CS:N]Bidiza[CR] und ich werden diese beiden\n[CS:I]Äpfel[CR] über Nacht aufbewahren.", italian="[CS:N]Chimecho[CR], [CS:N]Bidoof[CR] e io terremo queste due\n[CS:I]Mele[CR] per la notte.", spanish="[CS:N]Chimecho[CR], [CS:N]Bidoof[CR] y yo guardaremos las\n[CS:I]Manzanitas[CR] esta noche."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Tomorrow morning, we'll give them to\nTeam [team:].", french="Et demain matin, on les donnera à\nl'Equipe [team:].", german="Morgen früh werden wir sie Team\n[team:] geben.", italian="Domani mattina, le daremo al Team\n[team:].", spanish="Y mañana por la mañana se las daremos\nal [CS:X]Equipo[CR] [team:]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="They must be hungry now, but they have to\nendure it just a little longer...", french="Je les imagine en train de mourir de faim,\nmais tout ce que je peux leur dire, c'est\nde tenir encore un peu...", german="Sie dürften mittlerweile hungrig sein, aber ein\nwenig länger müssen sie es noch aushalten...", italian="Ora avranno fame, ma devono solo resistere\nancora un po'...", spanish="Seguro que ahora mismo tienen hambre, pero\nsolo tienen que aguantar un poco más..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="We all have to stick together and try to make\nit into the expedition party!", french="On doit tous se serrer les coudes et faire en\nsorte d'être pris dans l'expédition!", german="Wir müssen alle zusammenhalten und\nversuchen, es in den Expeditionstrupp zu\nschaffen!", italian="Dobbiamo restare insieme e fare di tutto per\nessere scelti per la spedizione!", spanish="¡Tenemos que echarnos todos una mano e\nintentar que nos elijan para la expedición!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 7 then
  -- @label_21 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Entry 7: A Rare Expedition\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 7: Une expédition rare\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 7: Eine seltene Expedition\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 7: Una nuova esplorazione\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]7. Una expedición rara\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="In the morning briefing, [CS:N]Chatot[CR] told us\nsomething that's worth a good scream. Eek!", french="A la réunion ce matin, [CS:N]Pijako[CR] nous a annoncé\nun événement qui vaut son pesant de Hiii!", german="Während der morgendlichen Unterweisung hat\nuns [CS:N]Plaudagei[CR] etwas wirklich Erfreuliches\nmitgeteilt. Iek!", italian="Alla riunione mattutina, [CS:N]Chatot[CR]\nci ha detto una cosa... da shock! Ehi!", spanish="En la asamblea de esta mañana, [CS:N]Chatot[CR] ha\ndicho algo que me ha erizado los pistilos."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="There's an expedition coming up! Yippee!", french="On va bientôt partir en expédition! Youpiii!", german="Es steht eine Expedition an! Hurra!", italian="Stanno organizzando una spedizione! Evviva!", spanish="¡Están preparando una expedición! ¡Por fin!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh! It's been simply ages since our\nlast one!", french="Ben mince alors! La dernière remonte à des\nlustres!", german="Auweia! Die letzte liegt schon Ewigkeiten\nzurück!", italian="Shock! Ne sono passati di anni dall'ultima!", spanish="¡Jo! ¡Hace siglos que hicimos la última!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="On our last expedition, we brought home simply\nmassive amounts of treasures!", french="La dernière fois, on avait ramené des tonnes\net des tonnes de trésors!", german="Von unserer letzten Expedition haben wir\nhaufenweise Schätze mitgebracht!", italian="Dall'ultima spedizione siamo tornati con\ntantissimi tesori!", spanish="Esa vez encontramos un montón de tesoros."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="We shared everything with everyone in\nTreasure Town. It was a happy, happy time!", french="On avait partagé avec tous les habitants\nde Bourg-Trésor. Ça avait été un moment\nextra-giga-génial!", german="Wir haben alles mit jedem in Schatzstadt\ngeteilt. Das war eine wirklich tolle Zeit!", italian="Quella volta abbiamo diviso tutto con gli\nabitanti di Borgo Tesoro. Sono stati dei\nmomenti tanto, tanto felici!", spanish="Lo compartimos todo con los habitantes de\nAldea Tesoro. ¡Qué bien que lo pasamos!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oooh, the upcoming expedition should be fun!\nI wonder where we'll explore this time?", french="Oooh, la prochaine expédition promet d'être\nsuper amusante! Je me demande où on va\naller exactement.", german="Oooh, die bevorstehende Expedition dürfte\nspaßig werden! Ich frage mich, wo wir\ndiesmal erkunden gehen werden...", italian="Oooh, la spedizione sarà di sicuro divertente.\nMi chiedo dove andremo a esplorare questa\nvolta.", spanish="Oh, seguro que la expedición será muy\ndivertida, pero... ¿adónde nos llevarán?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="My roommate [CS:N]Chimecho[CR] and I got all excited\nguessing about the destination!", french="Ma camarade de chambre, [CS:N]Eoko[CR] et moi, on\npasse notre temps à essayer de deviner notre\ndestination!", german="Meine Mitbewohnerin [CS:N]Palimpalim[CR] und ich sind\nschon ganz aufgeregt dabei, das Ziel zu\nerraten!", italian="Io e la mia compagna di stanza, [CS:N]Chimecho[CR], non\nstiamo quasi più nella pelle! Quand'è che ci\ndiranno dove andremo?", spanish="¡Mi compañera [CS:N]Chimecho[CR] y yo estamos\nnerviosas intentando adivinar adónde\niremos!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Of course, I'm going to do everything I can to\nbe picked for the expedition!", french="Bien sûr, je fais tout ce que je peux pour\nqu'on me prenne dans l'expédition!", german="Natürlich werde ich alles mir Mögliche tun,\num für die Expedition ausgewählt zu werden!", italian="Di sicuro, farò del mio meglio per essere\nscelta per la spedizione!", spanish="¡Por supuesto, intentaré hacer todo lo que\npueda para que me elijan para la expedición!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oooh, I'm feeling motivated! Yippee!", french="Oooh, je suis super-méga-motivée! Youpiii!", german="Oooh, ich bin so motiviert! Hurra!", italian="Oooh, sono così motivata! Evviva!", spanish="¡Qué nervios! ¡Qué emoción! ¡Estoy\nsupercontenta!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 6 then
  -- @label_22 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Entry 6: Mystery!\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 6: Mystère!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 6: Das Rätsel!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 6: Mistero!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]6. ¡Misterio!\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Something very mysterious happened at our\nguild the other day!", french="Il s'est passé quelque chose de très\nmystérieux l'autre jour à la Guilde!", german="Etwas sehr Rätselhaftes ist heute in unserer\nGilde geschehen!", italian="L'altro giorno nella nostra Gilda è successo\nqualcosa di molto strano!", spanish="El otro día ocurrió algo muy misterioso\nen el [CS:N]Pokégremio[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="We were in the guild when (oh my gosh!) the\nplace was stunk up by an atrocious stench!", french="On était à la Guilde quand (ben mince alors!)\nune atroce puanteur a envahi les lieux!\nC'était carrément immonde!", german="Wir waren in der Gilde, als diese (Auweia!)\nvon einem scheußlichen Gestank heimgesucht\nwurde!", italian="Eravamo nella Gilda quando (shock!) si è\ndiffusa una puzza atroce!", spanish="Estábamos tan tranquilos y de repente,\n¡un olor nauseabundo, o sea, súper\nsuperasqueroso, lo inundó todo!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh! I'd never experienced such a foul\ncloud of fumes. It was an eek-worthy moment!", french="Oh là là! Jamais je n'avais senti une odeur\naussi pestilentielle. C'était un de ces moments\nqui me donnent envie de faire \"Hiiii!\".", german="Auweia! So eine übel riechende Qualmwolke\nhabe ich noch nie erlebt. Das war ein\nAugenblick, der echt ein Iek verdient hat!", italian="Shock! Non avevo mai sentito delle esalazioni\ncosì disgustose! È stato davvero un momento\nda... shock!", spanish="¡Jo! No había olido nada así nunca. ¡Por\npoco me desmayo!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But...everyone denied responsibility for it!", french="Mais... personne n'a voulu en endosser la\nresponsabilité!", german="Aber niemand wollte sich dazu bekennen!", italian="Ma... il colpevole non è saltato fuori!", spanish="¡Y lo peor es que no hubo manera de dar\ncon el culpable!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But there's no fooling me! Oh my gosh, I know\nwhat I smelled, and there was no mistaking it!", french="Ah, mais on ne me la fait pas, à moi! Oh là là,\nje sais bien ce que ça sentait, impossible de\ns'y tromper!", german="Aber mich führt man so leicht nicht hinters\nLicht. Auweia, ich weiß, was ich gerochen\nhabe, da gibt es kein Vertun!", italian="Ma non mi si prende in giro così! Shock,\nsapevo cos'era quella puzza, e non mi sbagliavo\ndi certo!", spanish="Pero a mí no me engañan. ¡Yo sé bien que\nesa peste era inconfundible!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Eek, how mysteriously it crept upon us!", french="Hiii, ça nous est tombé dessus sans crier\ngare!", german="Iek, unter welch mysteriösen Umständen es\nuns heimgesucht hat!", italian="Ehi, questa nuvola puzzolente è arrivata su\ndi noi in modo misterioso!", spanish="¡Ay, qué asco, cómo lo inundó todo!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Who is the culprit?! Eek!", french="Qui donc est le coupable?! Hiii!", german="Wer ist der Übeltäter?!? Iek!", italian="Chi è il colpevole?! Ehi!", spanish="¿Quién tendrá la culpa? ¡¿Eh?!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  -- @label_23 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Entry 5: Types and Matchups\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 5: Efficacité des types\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 5: Typen und Vergleiche\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 5: Tipi e abbinamenti\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]5. Tipos y combinaciones\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh! I had a nasty scare the other day!", french="Ben mince alors! J'ai eu une de ces peurs\nl'autre jour! Je n'ai jamais eu aussi peur\nde toute ma vie!", german="Auweia! Neulich habe ich einen fiesen\nSchrecken bekommen!", italian="Shock! Mi sono presa uno spavento l'altro\ngiorno!", spanish="¡Ay, ay! ¡Menudo susto me llevé el otro día!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="While exploring a dungeon, I was careless and\ntook a hit from a Fire-type move! Silly me!", french="J'explorais un donjon sans faire gaffe et j'ai\nété touchée par une capacité de type Feu!\nQuelle idiote!", german="Während der Erkundung eines Dungeons war ich\nunvorsichtig und habe einen Treffer von einem\nFeuer-Pokémon abbekommen! Ich Dummerchen!", italian="Mentre esploravo un dungeon, mi sono distratta\ne sono stata colpita da una mossa di tipo\nFuoco! Che sciocca!", spanish="¡Qué mal! ¡Estaba explorando y me atacaron\ncon un movimiento de tipo Fuego!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I'm a Grass type! So I ended up taking a lot of\ndamage! Eek!", french="Moi, je suis de type Plante! Du coup, j'ai subi\nde gros dégâts! Hiii!", german="Ich bin ein Pflanzen-Pokémon! Daher habe ich\nentsprechend viel Schaden erlitten! Iek!", italian="Io sono un Pokémon di tipo Erba! Così ho\nsubito un sacco di danni! Ehi!", spanish="Y, como soy de tipo Planta, ¡recibí mucho\ndaño!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I should really explain what all this is about.", french="Cher journal, il faut absolument que je\nt'explique de quoi il retourne.", german="Ich sollte wirklich erklären, worum es hierbei\ngeht.", italian="Dovrei spiegare meglio di che cosa sto\nparlando.", spanish="Mejor explico de qué va todo esto."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="As you know, Pokémon come in many types,\nlike Fire and Water.", french="Comme tu le sais, les Pokémon sont classés\npar type, comme Feu et Eau par exemple.", german="Wie du weißt, gibt es viele verschiedene\nPokémon-Typen, wie etwa Feuer und Wasser.", italian="Come tutti ben sanno, i Pokémon possono\nessere di diversi tipi, ad esempio Fuoco e\nAcqua.", spanish="Como todo el mundo sabe, los Pokémon pueden\nser de varios tipos, Fuego o Agua, por ejemplo."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="All moves have types too! The matchup\nbetween the attacking move's type and the\ndefending Pokémon's type affects damage!", french="Et les capacités aussi ont des types! Les\ndégâts infligés dépendent du type du Pokémon\net du type de la capacité utilisée!", german="Attacken gehören ebenfalls zu einem Typ! Der\nVergleich zwischen Attackentyp und\nPokémon-Typ beeinflusst den Schaden!", italian="Anche le mosse hanno i tipi! L'abbinamento del\ntipo della mossa e del tipo del Pokémon che la\nsubisce influiscono sull'entità del danno.", spanish="¡Ojo! ¡Cada movimiento también tiene su tipo!\n¡El tipo del movimiento causará más o menos\ndaño según el tipo del Pokémon atacado!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="As a Grass type, I should really watch out for\nFire-type moves! Knowing how types match up\nis so important.", french="Etant de type Plante, je dois faire archi-\nattention aux capacités de type Feu! Savoir\ncombiner types et capacités, c'est top priorité!", german="Als ein Pflanzen-Pokémon sollte ich mich\nvor Feuer-Attacken in Acht nehmen! Es ist\nwichtig, die Unterschiede der Typen zu kennen.", italian="Da tipo Erba, dovrei davvero stare attenta alle\nmosse di tipo Fuoco! Conoscere come si\nabbinano i diversi tipi è molto importante.", spanish="Yo, como soy de tipo Planta, tengo que evitar\nlos movimientos de tipo Fuego. ¡Hay que sacar\nla mayor ventaja posible de los tipos!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="P.S. When I got into trouble because of all\nthis...[K] It was [CS:N]Loudred[CR] who saved me.", french="P.-S. Quand j'ai eu des ennuis à cause de tout\nça...[K] c'est [CS:N]Ramboum[CR] qui m'a sauvée.", german="P.S.: Als ich deshalb in Schwierigkeiten geraten\nbin,[K] hat mich [CS:N]Krakeelo[CR] gerettet.", italian="P.S. Quando ho avuto problemi a causa di\nciò...[K] è stato [CS:N]Loudred[CR] a salvarmi.", spanish="P. D.: Por cierto, cuando me atacaron el que\nme salvó no fue otro que...[K] [CS:N]Loudred[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Thank you, [CS:N]Loudred[CR].", french="Merci, [CS:N]Ramboum[CR].", german="Danke, [CS:N]Krakeelo[CR].", italian="Grazie, [CS:N]Loudred[CR].", spanish="Gracias, [CS:N]Loudred[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="That other time I yelled at him! I said, \"Oh my\ngosh, [CS:N]Loudred[CR]! I never want to go exploring\nwith you ever again!\"", french="L'autre jour, je lui ai crié dessus! J'ai fait:\n\"Ben mince alors, [CS:N]Ramboum[CR]! Je ne veux plus\njamais repartir en exploration avec toi!\"", german="Das andere Mal habe ich ihn angeschrien! Ich\nhabe [CS:N]Krakeelo[CR] gesagt, dass ich mit ihm niemals\nwieder auf Erkundung gehen will!", italian="Un'altra volta gli ho gridato dietro! Gli ho\ndetto: \"Shock, [CS:N]Loudred[CR]! Non voglio mai più\nandare a esplorare con te!\"", spanish="La última vez le grité: \"¡[CS:N]Loudred[CR], no quiero\nvolver a explorar nunca, o sea, nunca más\ncontigo!\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But...eek! Am I ever sorry for saying that!\nI take back everything nasty I said!", french="Mais... hiii! Je m'en veux de lui avoir dit ça!\nJe retire tout ce que j'ai dit de méchant!", german="Aber... Iek! Es tut mir leid, das gesagt zu\nhaben! Ich nehme all das Gemeine, was ich\ngesagt habe, zurück!", italian="Ma... ehi! Mi spiace davvero di aver parlato\ncosì! Mi rimangio tutte le cose brutte che ho\ndetto!", spanish="Ahora... ¡Siento mucho haberlo dicho! ¡Retiro\ntodo lo malo que dije sobre él!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I wonder if he would go to a dungeon with me\never again?", french="Je me demande s'il acceptera de retourner\nen exploration avec moi.", german="Ich frage mich, ob er jemals wieder einen\nDungeon mit mir erkunden wird.", italian="Chissà se tornerebbe mai in un dungeon con\nme...", spanish="Espero que no le importe y exploremos juntos\nmás veces."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I think I will go apologize to him sincerely\ntomorrow. Yes, that's what I will do.", french="Je crois que je vais lui présenter mes excuses\ndemain. Oui, c'est décidé, je vais le faire.", german="Ich denke, ich werde mich morgen in aller\nForm bei ihm entschuldigen. Ja, das werde ich\nmachen.", italian="Penso che domani andrò da lui a scusarmi\nsinceramente. Sì, farò così.", spanish="Creo que será mejor que me disculpe mañana.\nSí, eso será lo que haré."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I'm sorry, [CS:N]Loudred[CR]. I hope we can keep on\nbeing teammates.", french="Désolée, [CS:N]Ramboum[CR]. J'espère qu'on pourra\nrester amis.", german="Es tut mir leid, [CS:N]Krakeelo[CR]. Ich hoffe, wir\nkönnen auch weiterhin Teamkameraden sein.", italian="Mi spiace, [CS:N]Loudred[CR]. Spero che potremo\ncontinuare a fare squadra insieme.", spanish="Lo siento, [CS:N]Loudred[CR], espero que podamos seguir\nsiendo buenos compañeros de equipo."})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- @label_24 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Entry 4: Exploration Basics\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 4: Exploration: le b.a.-ba\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 4: Erkundungsgrundlagen\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 4: L'abc dell'esplorazione\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]4. Conceptos básicos\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I promised, and now I'll deliver! Here's my\nreport on exploring with [CS:N]Bidoof[CR]!", french="Chose promise, chose due! Cher journal, voilà\nmon rapport sur mon expédition avec\n[CS:N]Keunotor[CR]!", german="Ich habe es versprochen und hier kommt er\nnun! Hier ist mein Bericht über meine\nErkundung mit [CS:N]Bidiza[CR]!", italian="L'avevo promesso, e ora devo farlo! Ecco il\nracconto della mia esplorazione con [CS:N]Bidoof[CR]!", spanish="Como siempre, cumplo con mi palabra. Esta es\nla historia de mi exploración con [CS:N]Bidoof[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh! I was amazed at how little [CS:N]Bidoof[CR]\nknew about exploring.", french="Ben mince alors! J'y crois pas! [CS:N]Keunotor[CR],\nil s'y connaît si peu niveau exploration,\nça fait peur!", german="Auweia! Die Unwissenheit von [CS:N]Bidiza[CR] im\nHinblick auf das Erkunden hat mich erstaunt.", italian="Shock! Sono rimasta sbalordita da quanto poco\nsappia [CS:N]Bidoof[CR] a proposito delle esplorazioni.", spanish="¡Jo! No me imaginaba que [CS:N]Bidoof[CR] supiera tan\npoco sobre cómo explorar."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="An example! If an enemy stands beside you,\npushing [M:B5] will make you face it. Easy, right?", french="Exemple: si un ennemi se trouve à côté de\ntoi, tu appuies sur [M:B5] pour lui faire face.\nTrop facile, pas vrai?", german="Hier ein Beispiel! Wenn ein Gegner neben einem\nsteht, wendet man sich ihm durch Drücken von\n[M:B5] zu. Einfach, nicht wahr?", italian="Un esempio! Quando un amico è vicino a te, se\npremi il pulsante [M:B5], ti giri verso di lui. Facile,\nvero?", spanish="Por ejemplo, no tenía ni idea de que si tienes\na un rival delante, lo puedes encarar si pulsas\n[M:B5]. ¡Y mira que es bien fácil!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="He didn't even know that!", french="Ben lui, il était même pas au courant!", german="Selbst das wusste er nicht!", italian="Non sapeva nemmeno questo!", spanish="¡Ni siquiera sabía eso!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But all he needed was a little coaching.[K] When I\ntaught him, [CS:N]Bidoof[CR] picked things up quickly.\nHe's not so bad after all! Oh my gosh!", french="Mais tout ce dont il avait besoin, c'est d'un bon\ncoach.[K] Quand je lui ai montré, [CS:N]Keunotor[CR] a vite\ncompris. Il n'est pas si nul que ça, après tout!", german="Aber er brauchte nur etwas Nachhilfe.[K] Als ich\nes ihm erklärt habe, hat [CS:N]Bidiza[CR] es schnell\nbegriffen. Er ist gar nicht so übel! Auweia!", italian="Ma gli serve solo qualche dritta.[K] Quando gli\nspiego le cose, [CS:N]Bidoof[CR] le impara in fretta.\nDopotutto non è così male! Shock!", spanish="Solo necesitaba que alguien le enseñara algunas\ncosas.[K] En cuanto se lo expliqué, [CS:N]Bidoof[CR] lo pilló\nrápido. ¡Parece que no es tan mal explorador!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="We got the job done too! ♪[K] Another fun day!", french="Et en plus, on a réussi la mission! ♪[K]\nEncore une journée de folie!", german="Den Job haben wir auch erledigt! ♪[K] Ein\nweiterer spaßiger Tag!", italian="Abbiamo anche completato la missione! ♪[K]\nUn altro giorno divertente!", spanish="¡Además cumplimos con la misión! ♪[K] ¡Y nos\nlo pasamos en grande, como siempre!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  -- @label_25 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Entry 3: Lovely Food!\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 3: Un délicieux repas!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 3: Lecker Essen!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 3: Che bontà!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]3. ¡Comida!\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Tomorrow, I'll be off exploring with [CS:N]Bidoof[CR].", french="Demain, je pars en exploration avec [CS:N]Keunotor[CR].", german="Morgen werde ich mit [CS:N]Bidiza[CR] auf Erkundung\ngehen.", italian="Domani, andrò a esplorare con [CS:N]Bidoof[CR].", spanish="Mañana saldré a explorar con [CS:N]Bidoof[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="That [CS:N]Bidoof[CR] is sure to wander needlessly, so\nI should stock up on lots of food.", french="Je suis prête à parier qu'il est du genre à\nlambiner, ce [CS:N]Keunotor[CR], alors je vais prévoir\nle coup et emporter un max de provisions.", german="Dieser [CS:N]Bidiza[CR] streift sicher unnötig umher. Ich\nsollte reichlich Essensvorräte mitnehmen.", italian="Quel [CS:N]Bidoof[CR] di sicuro andrà in giro senza\nniente di utile, quindi dovrò portare un sacco di\ncibo.", spanish="[CS:N]Bidoof[CR] tiene pinta de dar más vueltas que una\npeonza cuando explora, así que será mejor que\nlleve mucha comida."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh? Why do we need lots of food?", french="Hein? Pourquoi on a besoin d'un max de\nprovisions, même quand on est au régime?", german="Oh? Warum wir reichlich Vorräte benötigen?", italian="Oh? Perché c'è bisogno di così tanto cibo?", spanish="¡Ah! ¿Que por qué mucha comida?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Well, as you move around in a dungeon, you'll\nget hungry as your Belly empties of food.", french="Eh bien, mon cher journal, quand on se déplace\ndans un donjon, l'Estomac se vide et on se\nretrouve affamé.", german="Nun, wenn man durch einen Dungeon streift,\nwird man hungrig, wenn sich nach und nach der\nMagen leert.", italian="Beh, mentre ti aggiri per un dungeon, ti viene\nfame mano a mano che la tua pancia si svuota.", spanish="Porque, a medida que exploras un territorio, tu\nTripa se vacía y te va entrando hambre."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="If your Belly gets empty, you'll get weaker and\nweaker...until you faint! Oh my gosh! Terrible!", french="Si ton Estomac se vide entièrement, tu\nt'affaiblis de plus en plus... jusqu'à\nl'évanouissement! Oh là là, l'horreur, quoi!", german="Wenn sich dein Magen leert, wirst du\nschwächer und schwächer, bis du schließlich\nkampfunfähig wirst! Auweia! Schrecklich!", italian="Se la pancia si svuota, ti indebolisci\nsempre di più... finché vai KO! Shock!\nTerribile!", spanish="Si tu Tripa se vacía completamente, empiezas\na perder PS hasta que te debilitas, ¡o sea que\nmuy mal!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:N]Bidoof[CR] is a little short on experience, so I'll\nback him up.", french="[CS:N]Keunotor[CR] manque un peu d'expérience, alors\nil faudra que je le soutienne.", german="[CS:N]Bidiza[CR] ist nicht sehr erfahren, daher werde ich\nihn unterstützen.", italian="[CS:N]Bidoof[CR] non ha molta esperienza,\ndovrò pensarci io.", spanish="[CS:N]Bidoof[CR] no tiene mucha experiencia, así\nque será mejor que le eche una mano."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="P.S. I plan to write about how my exploration\nwent with [CS:N]Bidoof[CR]...", french="P.-S. J'ai prévu de faire un rapport sur mon\nexpédition en compagnie de [CS:N]Keunotor[CR]...", german="P.S.: Ich beabsichtige, über den Verlauf meiner\nErkundung mit [CS:N]Bidiza[CR] zu schreiben.", italian="P.S. Poi scriverò anche com'è andata la mia\nesplorazione con [CS:N]Bidoof[CR]...", spanish="P. D.: Próximamente escribiré qué tal fue la\nexploración con [CS:N]Bidoof[CR]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Now that should really be something to look\nforward to! Eek!", french="Ça va être quelque chose, hein? Hiii!", german="Darauf sollte man sich wirklich freuen! Iek!", italian="E allora sì che ci sarà qualcosa di interessante\nda leggere!", spanish="¡Seguro que esa es una lectura entretenida!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="...Which again makes me think that someone\nmay be peeking at my diary?", french="... Tiens, encore! Ça me fait penser...\nEst-ce qu'il y a quelqu'un qui lit mon\njournal en douce?", german="Das bringt mich wieder zurück zu der\nAnnahme, dass jemand mein Tagebuch liest!", italian="Il che mi fa pensare che qualcuno\nstia di nuovo sbirciando il mio diario?", spanish="No sé por qué tengo la sensación de que hay\nalguien que me está cotilleando el diario..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh! How horrifying!", french="Ben mince alors! Quelle horreur!", german="Auweia! Wie fürchterlich!", italian="Shock! È terribile!", spanish="¡Ay, ay, ay! ¡Qué mal, qué mal!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 2 then
  -- @label_26 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Entry 2: That Silly [CS:N]Loudred[CR]!\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 2: [CS:N]Ramboum[CR], quel boulet!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 2: Alberner [CS:N]Krakeelo[CR]!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 2: Quello stupido [CS:N]Loudred[CR]!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]2. ¡El tonto de [CS:N]Loudred[CR]!\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh! That silly [CS:N]Loudred[CR]! Ooooh! He can\nbe so absentminded!", french="Oh là là! Mais quel giga-boulet, ce [CS:N]Ramboum[CR]!\nOoooh! Ce qu'il peut être étourdi parfois!", german="Auweia! Dieser dumme [CS:N]Krakeelo[CR]! Ooooh! Er\nkann so zerstreut sein!", italian="Shock! Quello sciocco di [CS:N]Loudred[CR]! Ooooh!\nSa essere così distratto!", spanish="¡Jo! ¡Qué tontorrón que es [CS:N]Loudred[CR]! ¡¿Cómo\nse puede ser tan despistado?!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Everyone knows that if you get totally wiped\nout in a dungeon...you lose some items...and\nhalf your money!", french="Tout le monde sait que si on tombe K.O. dans\nun donjon... on perd certains objets...\net la moitié de son argent!", german="Jeder weiß, dass man, wenn man in einem\nDungeon besiegt wird, einige Items und die\nHälfte seines Geldes verliert!", italian="Tutti sanno che se vieni sconfitto in un\ndungeon... perdi alcuni strumenti... e metà\ndei tuoi soldi!", spanish="Cualquiera sabe que, si te vencen en\nun territorio, pierdes algunos objetos...\n¡y la mitad del dinero, es que es muy fuerte!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But of course that silly [CS:N]Loudred[CR] forgets all\nthat and goes storming off into the dungeon...", french="Mais, évidemment, cet idiot de [CS:N]Ramboum[CR]\na oublié tout ça, et il a foncé tête baissée\ndans le donjon...", german="Aber natürlich muss dieser dumme [CS:N]Krakeelo[CR]\nall das vergessen und sich Hals über Kopf in\nden Dungeon stürzen.", italian="Ma ovviamente quello sciocco di [CS:N]Loudred[CR] se n'è\ndimenticato e si è precipitato nel dungeon...", spanish="Pero claro, al tontorrón de [CS:N]Loudred[CR] se le\nolvida y se va por ahí a explorar como un\ninconsciente."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="And that wound up making us both wipe out!\nSo I got sent back to the guild too!", french="Et par sa faute on s'est retrouvés K.O. tous\nles deux! Du coup, moi aussi, j'ai été\nrenvoyée à la Guilde!", german="Und das führte dazu, dass wir beide besiegt\nwurden! Also wurde auch ich zur Gilde\nzurückgeschickt!", italian="... ed è finita che ci hanno sconfitto entrambi!\nCosì anch'io sono dovuta tornare alla Gilda!", spanish="¡Y por su culpa me derrotan a mí también!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Eek! So frustrating! Oh my gosh, I never, ever\nwant to go to a dungeon with [CS:N]Loudred[CR] again!", french="Argh! C'est si frustrant! Oh là là, je ne veux\nplus jamais (jamais!) retourner dans un donjon\navec [CS:N]Ramboum[CR]!", german="Iek! So frustrierend! Auweia, ich will niemals\nmehr mit [CS:N]Krakeelo[CR] einen Dungeon betreten!", italian="Ehi! È così frustrante! Shock! Mai, non voglio\nmai più tornare in un dungeon con [CS:N]Loudred[CR]!", spanish="¡Ay! ¡Me da tanta rabia! ¡No quiero volver a\nexplorar nunca, o sea, nunca, con [CS:N]Loudred[CR]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="P.S. Two new kids joined the guild!", french="P.-S. Il y a deux novices à la Guilde!", german="P.S.: Zwei neue Jungspunde haben sich der\nGilde angeschlossen!", italian="P.S. Abbiamo due nuove giovani reclute alla\nGilda!", spanish="P. D.: ¡Acaban de llegar dos aprendices!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I think they were called [partner] and\n[hero]...", french="[partner] et\n[hero], je crois...", german="Ich glaube, sie heißen [partner] und\n[hero].", italian="Penso che si chiamino [partner] e\n[hero]...", spanish="Creo que se llaman [partner] y\n[hero]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh. They're both adorable. Yippee!", french="Ben mince alors, ces deux-là sont trop chou.\nYoupiii!", german="Auweia! Sie sind beide bewundernswert, hurra!", italian="Shock! Sono due tesori. Evviva!", spanish="Son muy superadorables."})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 1 then
  -- @label_27 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Sunflora[CR]'s Oh My Gosh Diary\n[CN]Entry 1: What a Scream!\n[CN]OO Month XX Day, Sunny", french="[CN]Ben mince alors! Journal d'[CS:N]Héliatronc[CR]\n[CN]Article 1: Je pousse un cri!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Auweia-Tagebuch von [CS:N]Sonnflora[CR]\n[CN]Eintrag 1: Total durchgeknallt!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Diario-shock di [CS:N]Sunflora[CR]\n[CN]Nota 1: Che shock!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"O sea\" de [CS:N]Sunflora[CR]\n[CN]1. ¡Pero bueno!\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh! So glad to meet you! I'm [CS:N]Sunflora[CR],\nan apprentice at the guild!", french="Ben mince alors! Cher journal, ravie de te\nconnaître! Moi, c'est [CS:N]Héliatronc[CR], je suis\napprentie à la Guilde!", german="Auweia! Erfreut, euch kennenzulernen!\nIch bin [CS:N]Sonnflora[CR], ein Lehrling der Gilde!", italian="Evviva! Sono così contenta di conoscervi! Sono\n[CS:N]Sunflora[CR], un'apprendista della Gilda!", spanish="¡Hola! ¡Encantadísima de conocerte!\nSoy [CS:N]Sunflora[CR], una aprendiz del [CS:N]Pokégremio de[CR]\n[CS:N]Exploradores[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Eek! But does this mean someone else is\nreading my diary besides me?!", french="Hiii! Qu'est-ce que ça veut dire? Que quelqu'un\nd'autre que moi lit mon journal?!", german="Iek! Aber bedeutet das, dass jemand außer mir\nmein Tagebuch liest?", italian="Ehi! Ma significa che non sono la sola a leggere\nil mio diario?!", spanish="Un momento... Este diario es para mí... ¿Qué\nhago escribiendo esto? ¿Es que espero que\nalguien más lo lea?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Double-eek! Is someone sneaking a peek?", french="Double hiii! Est-ce que quelqu'un est en train\nd'y jeter un coup d'œil?", german="Doppel-iek! Riskiert da jemand einen Blick?", italian="Doppio-shock! C'è qualcuno che sta sbirciando?", spanish="¡Jo! Eso sería curiosear y no estaría muy\nbien, ¿verdad?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh my gosh! How horrifying! Eeek!", french="Ben mince alors! C'est horriiible! Hiii!", german="Auweia! Wie schrecklich! Ieek!", italian="Shock! È terribile!", spanish="¡Ay! ¡Qué mal! O sea, ¡qué mal!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 26 -- $EVENT_LOCAL = 26 (ROM)
  -- jump @label_55 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 88) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 88]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 25 -- $EVENT_LOCAL = 25 (ROM)
  -- jump @label_55 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 73) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 73]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 24 -- $EVENT_LOCAL = 24 (ROM)
  -- jump @label_55 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 67) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 67]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 23 -- $EVENT_LOCAL = 23 (ROM)
  -- jump @label_55 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 56) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 22 -- $EVENT_LOCAL = 22 (ROM)
  -- jump @label_55 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 53) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 53]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 21 -- $EVENT_LOCAL = 21 (ROM)
  -- jump @label_55 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 50) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 50]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 20 -- $EVENT_LOCAL = 20 (ROM)
  -- jump @label_55 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 44) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 44]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 19 -- $EVENT_LOCAL = 19 (ROM)
  -- jump @label_55 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 40) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 40]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 18 -- $EVENT_LOCAL = 18 (ROM)
  -- jump @label_55 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 6) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 6]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 17 -- $EVENT_LOCAL = 17 (ROM)
  -- jump @label_55 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 5]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 16 -- $EVENT_LOCAL = 16 (ROM)
  -- jump @label_55 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 1]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 15 -- $EVENT_LOCAL = 15 (ROM)
  -- jump @label_55 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(22, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [22, 3]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 14 -- $EVENT_LOCAL = 14 (ROM)
  -- jump @label_55 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [22, 2]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 13 -- $EVENT_LOCAL = 13 (ROM)
  -- jump @label_55 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 3]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 12 -- $EVENT_LOCAL = 12 (ROM)
  -- jump @label_55 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 5]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 11 -- $EVENT_LOCAL = 11 (ROM)
  -- jump @label_55 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 1]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 10 -- $EVENT_LOCAL = 10 (ROM)
  -- jump @label_55 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 1]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 9 -- $EVENT_LOCAL = 9 (ROM)
  -- jump @label_55 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 3]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 8 -- $EVENT_LOCAL = 8 (ROM)
  -- jump @label_55 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 1]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 7 -- $EVENT_LOCAL = 7 (ROM)
  -- jump @label_55 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 6) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 6]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 6 -- $EVENT_LOCAL = 6 (ROM)
  -- jump @label_55 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 1]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 5 -- $EVENT_LOCAL = 5 (ROM)
  -- jump @label_55 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(6, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [6, 1]
  -- jump @label_51 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(5, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [5, 5]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 3 -- $EVENT_LOCAL = 3 (ROM)
  -- jump @label_55 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 7]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 2 -- $EVENT_LOCAL = 2 (ROM)
  -- jump @label_55 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 3]
  -- @label_54 [étiquette de flux ExplorerScript]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 1 -- $EVENT_LOCAL = 1 (ROM)
  -- jump @label_55 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_54 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  elseif __choice == 2 then
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 88) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 88]
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 73) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 73]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 67) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 67]
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 56) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 53) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 53]
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 50) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 50]
  -- jump @label_8 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 44) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 44]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 40) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 40]
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 6) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 6]
  -- jump @label_11 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 5]
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 1]
  -- jump @label_13 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(22, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [22, 3]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [22, 2]
  -- jump @label_15 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 3]
  -- jump @label_16 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 5]
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 1]
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 1]
  -- jump @label_19 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 3]
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 1]
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 6) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 6]
  -- jump @label_22 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 1]
  -- jump @label_23 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(6, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [6, 1]
  -- jump @label_24 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(5, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [5, 5]
  -- jump @label_25 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 7]
  -- jump @label_26 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 3]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
end
