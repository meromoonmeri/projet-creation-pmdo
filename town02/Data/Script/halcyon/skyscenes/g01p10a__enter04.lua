-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P10A/enter04.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  SkySceneKit.turn_to_pos(hero, 212, 240) -- Turn2DirectionMark
  SkySceneKit.turn_to_pos(hero, 212, 240) -- Turn2DirectionMark
  SkySceneKit.turn_to_pos(partner, 212, 240) -- Turn2DirectionMark
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_G01P10A1_563) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(19) [anim idle native]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Something is written here...", french="[CN]Il y a quelque chose d'écrit ici...", german="[CN]Hier steht etwas geschrieben...", italian="[CN]Qui c'è scritto qualcosa...", spanish="[CN]Aquí hay algo escrito..."})
  -- @label_57 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]This is [CS:N]Bidoof[CR]'s diary.\n[CN]Should we sneak a peek?", french="[CN]C'est le journal de [CS:N]Keunotor[CR].\n[CN]On y jette un coup d'œil?", german="[CN]Dies ist das Tagebuch von [CS:N]Bidiza[CR].\n[CN]Sollen wir einen Blick riskieren?", italian="[CN]È il diario di [CS:N]Bidoof[CR].\n[CN]Gli diamo una sbirciatina furtiva?", spanish="[CN]Se trata del diario de [CS:N]Bidoof[CR].\n[CN]¿Quieres echarle un vistazo?"})
  do local __choice = SkySceneKit.ask({{english="Read", french="Lire", german="Ja", italian="Leggi", spanish="Leerlo"}, {english="Ignore it", french="Ignorer", german="Nein", italian="Ignora", spanish="Mejor no"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 2 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 4 -- $EVENT_LOCAL = 4 (ROM)
  -- @label_55 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyMenuResults or {})["MENU_DIARY_BIDOOF_SP_E_P"] or 0) -- switch(message_Menu(MENU_DIARY_BIDOOF_SP_E_P)) [message_Menu(MENU_DIARY_BIDOOF_SP_E_P): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 4 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 4: Exploring with [CS:Y]Sunflora[CR]\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 4: [CS:Y]Héliatronc[CR]\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 4: Erkunden mit [CS:Y]Sonnflora[CR]\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 4: Esplorando con [CS:Y]Sunflora[CR]\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]4. Explorando con [CS:Y]Sunflora[CR]\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:Y]Sunflora[CR] is some kind of awesome!", french="[CS:Y]Héliatronc[CR], c'est une sacrée nana!", german="[CS:Y]Sonnflora[CR] ist ziemlich toll!", italian="[CS:Y]Sunflora[CR] è davvero fantastica!", spanish="¡[CS:Y]Sunflora[CR] es realmente increíble!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Yup yup! I went exploring with [CS:Y]Sunflora[CR] the\nother day.", french="Ouaip ouaip! J'suis parti en exploration avec\n[CS:Y]Héliatronc[CR] l'aut' jour.", german="Jawollja! Neulich bin ich mit [CS:Y]Sonnflora[CR] auf\nErkundung gewesen.", italian="Ohibò! L'altro giorno sono andato a esplorare\ncon lei.", spanish="¡Sí, señor! El otro día fui a explorar\ncon [CS:Y]Sunflora[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It turns out [CS:Y]Sunflora[CR]'s a real expert at\nfighting in dungeons.", french="J'ai découvert qu'[CS:Y]Héliatronc[CR], ben c'est une\nvéritable experte des combats en donjon.", german="Wie sich herausstellte, ist [CS:Y]Sonnflora[CR] ein\nrichtige Expertin, was Dungeonkämpfe\nanbelangt.", italian="[CS:Y]Sunflora[CR] si è dimostrata una vera esperta\ndi lotte nei dungeon.", spanish="Y resulta que [CS:Y]Sunflora[CR] es toda una experta\ncombatiendo en los territorios."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="When an enemy is just out of reach, she\ndoesn't move toward it! Instead she uses [M:B2] to\nlaunch her regular attack, striking at nothing!", french="Quand un ennemi est hors de portée, elle\ns'en approche pas! Elle lance son attaque\nordinaire avec [M:B2] et frappe dans l'vide!", german="Wenn ein Gegner außer Reichweite ist, bewegt\nsie sich nicht auf ihn zu, sondern drückt [M:B2]\nfür einen Angriff ins Leere!", italian="Quando un nemico è fuori portata, non si\nmuove verso di lui! Usa invece [M:B2] per\nlanciare attacchi regolari, contro il nulla!", spanish="Si un enemigo se encuentra lejos, ¡no va\nhacia él, sino que usa [M:B2] y lanza al aire\nsu ataque convencional!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Then the enemy usually spends that turn closing\nthe distance on her. And then, on her next turn,\nshe's the first one close enough to hit!", french="Alors l'ennemi passe l'tour suivant à\ns'approcher d'elle. Du coup, quand c'est son\ntour, elle est la première à frapper!", german="Dann überbrückt der Gegner die Distanz zu ihr\nin seiner Runde. In der Folgerunde ist sie dann\ndie Erste in Reichweite für einen Treffer.", italian="Poi il nemico, solitamente, in quel turno le si\navvicina. E così lei nel turno successivo\nè abbastanza vicina per colpire per prima!", spanish="Así, el enemigo pierde su turno acercándose.\n¡Y al final es ella la que, en el siguiente turno,\nestá tan cerca como para atacar!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Yup yup! She sure knows what she's doing,\nby golly!", french="Pour sûr! Elle sait c'qu'elle fait, sapristi!", german="Jawollja! Sie weiß echt, was sie tut,\nDonnerwetter!", italian="Ohibò! Sicuramente quella furbetta sa quello\nche fa! Sissignore!", spanish="¡Vaya! ¡Tiene las ideas muy claras!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Why, I wanted to whoop and holler when I saw\nher use that trick. So thrilling![K] Sigh...", french="J'ai bien failli l'acclamer quand elle a utilisé\nc'te ruse-là. Que d'émotions![K] Aaah...", german="Ich wollte schreien und brüllen, als ich sie\ndiesen Trick habe einsetzen sehen. So\naufregend war das![K] Seufz...", italian="Avrei voluto gridare a più non posso quando\nl'ho vista usare questa tecnica.\nÈ sensazionale![K] Sigh...", spanish="¡Huy, me emocioné un montón cuando vi cómo\nusaba ese truco![K] Uf..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="As for me, I always rush into a fight...[K]\nThat's why I end up being first to get hit!", french="Moi, j'fonce toujours dans l'tas...[K] C'est pour\nça que l'ennemi, il m'frappe en premier!", german="Was mich angeht, ich stürze mich immer in\neinen Kampf.[K] Daher bin ich auch immer der\nErste, der getroffen wird!", italian="Io invece corro sempre incontro ai nemici...[K]\nE vengo regolarmente colpito per primo...", spanish="Yo, por el contrario, me tiro de cabeza contra\nel enemigo...[K] ¡Por eso soy siempre el que\nrecibe el primer golpe!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But it's all right, I reckon. I know the way to\ndo it now and can explore better now. Yup yup!", french="Mais c'est pas bien grave, j'imagine. Maintenant\nque j'sais comment faire, j'vais m'améliorer,\npour sûr!", german="Aber ich schätze, das ist in Ordnung. Ich weiß,\nwie man es macht, und kann nun effektiver\nerkunden. Jawollja!", italian="Ma va bene, ne terrò conto. Ora so come fare\ne posso diventare un esploratore migliore,\nohibò!", spanish="Pero bueno, ya sé cómo se tienen que hacer\nlas cosas y a partir de ahora lo haré mejor."})
  -- @label_1 [étiquette de flux ExplorerScript]
  -- message_Close
  -- SetAnimation(20) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_G01P10A1_563) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(17) [anim idle native]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw == 3 then
  -- @label_25 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 3: Bulletin Board Goof-Up\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 3: Oups... la gaffe!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 3: Patzer am Infobrett\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 3: La gaffe della Bacheca\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]3. Metedura de pata\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I... I didn't realize it!", french="J'ai... j'ai pas fait gaffe!", german="Ich... Ich habe es nicht bemerkt!", italian="Io... io non avevo capito!", spanish="¡No me había dado ni cuenta!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="After you take jobs on the Job Bulletin Board\nand Outlaw Notice Board...to actually do 'em,\nyou need to use \"Take Job\" on your Job List!", french="Après avoir pris une mission du Tableau des\nMissions ou des Avis de Recherche... faut faire\nAccepter pour pouvoir effectuer la mission!", german="Nach dem Annehmen von Jobs vom Job-\nund Ganoven-Infobrett, muss man AUSÜBEN\nauf der Jobliste wählen, um sie zu erledigen!", italian="Dopo che scegli una missione da una delle due\nBacheche... per compierla, devi prima scegliere\nAttiva nella lista delle missioni!", spanish="¡Después de coger una misión de los tablones\nhay que abrir la lista de misiones y seleccionar\nla opción Aceptar para poder cumplirla!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I didn't know that... So I went to dungeons\nwithout first activating the jobs with that\n\"Take Job\" command, by golly...", french="Moi j'le savais pas... Alors j'suis allé dans\ndes donjons sans avoir activé les missions\navec la commande Accepter, sapristi...", german="Das wusste ich nicht. Ich bin also in Dungeons\ngegangen, ohne die Jobs vorher mit AUSÜBEN\nzu aktivieren, Menschenskind.", italian="Non lo sapevo... Così sono andato nel dungeon\nsenza prima attivare la missione con quel\ncomando Attiva, ohibò...", spanish="No tenía ni la más remota idea. Siempre\nme adentraba en los territorios sin haber\naceptado la misión..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oof! It's no wonder why I could never do my\njobs once I got to a dungeon...", french="Pfiou! Pas étonnant que j'aie jamais pu\naccomplir ma mission une fois arrivé dans\nun donjon...", german="Uuf! Kein Wunder, dass ich meine Jobs nie\nerledigen konnte, obwohl ich den\nentsprechenden Dungeon betreten habe.", italian="Puff! Non c'è da meravigliarsi se una volta nel\ndungeon non riuscivo mai a portare a termine\nla missione...", spanish="¡Y claro! ¡Así no podía completar nunca\nmis misiones aunque estuviera en el lugar\nadecuado!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I finally understand why [CS:N]Chatot[CR]'s always so\nupset with me, by golly...", french="J'comprends enfin pourquoi [CS:N]Pijako[CR], il perd\ntoujours patience avec moi, sapristi...", german="Jetzt verstehe ich auch, warum [CS:N]Plaudagei[CR]\nimmer so aufgebracht ist, wenn es um mich\ngeht, Menschenskind.", italian="Ora capisco perché [CS:N]Chatot[CR] è sempre così\narrabbiato con me, ohibò...", spanish="¡Uf! Me parece que empiezo a comprender\npor qué [CS:N]Chatot[CR] se enfada tanto conmigo..."})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 2 then
  -- @label_26 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 2: Happy Time!\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 2: J'suis content!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 2: Unbeschwerte Zeit!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 2: Tempi felici!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]2. ¡Estoy contento!\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Yup yup! I'm happy, by golly!", french="Ouaip ouaip! J'suis hyper content, pardi!\nJ'suis à deux doigts de m'rouler par terre!", german="Jawollja! Menschenskind, bin ich glücklich!", italian="Sissignore! Sono felice, ohibò!", spanish="¡Sí, señor! ¡Hoy estoy más feliz que una\nlombriz!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh?[K] Why am I so downright happy?", french="Tiens?[K] Pourquoi donc que j'suis si heureux,\nd'ailleurs?", german="Oh?[K] Warum ich so unglaublich glücklich bin?", italian="Eh?[K] Perché sono così contento?", spanish="¿Cómo?[K] ¿Que por qué estoy tan contento?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Well...[K] Finally...", french="Eh bien...[K] Enfin...", german="Nun...[K] Endlich...", italian="Beh...[K] Finalmente...", spanish="Bueno...[K] Es que por fin..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Finally, I've got junior members under me!", french="Des novices ont fini par arriver pour prendre\nl'relais! J'suis plus le p'tit nouveau!", german="Endlich habe ich Junior-Mitglieder unter mir!", italian="Finalmente, sono arrivati dei novellini!", spanish="¡Por fin he dejado de ser el novato del\n[CS:N]Pokégremio de Exploradores[CR]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oof! This is some kind of wonderful![K] And the\ntwo are both so friendly and kind.[K] I feel so\nlucky. Yup yup!", french="Pfiou! C'est vachement merveilleux![K] Et en\nplus, ces deux-là sont adorables.[K]\nJ'ai vraiment d'la veine, pour sûr!", german="Uuf! Das ist ziemlich toll![K] Und die beiden sind\nso freundlich und nett.[K] Ich bin so glücklich.\nJawollja!", italian="Puff! È meraviglioso![K] E sono dei Pokémon\nsimpatici e gentili.[K] Che fortuna.\nOhibò, dico io.", spanish="¡Uf! ¡Es lo mejor que me podía pasar![K]\nAdemás, este par es muy apañado.[K]\n¡Qué suerte!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I've got to set a good example for my\nnew pals! I have to be better. Yup yup!", french="J'dois servir d'modèle à mes nouveaux\ncompagnons! Pour ça, faut que j'sois plus\nbalaise que ces deux-là, pour sûr!", german="Ich muss für meine neuen Freunde ein\ngutes Vorbild abgeben! Ich muss besser\nwerden. Jawollja!", italian="Devo dare il buon esempio ai miei nuovi\ncompagni e fare del mio meglio! Ohibò!", spanish="Tengo que ser el mejor de los ejemplos\npara mis nuevos compis, ¡tengo que ser\nel mejor, sí, señor!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Yeaaah! I'll do better starting tomorrow!", french="Ouaaaaaaaip! J'ferai mieux à partir de d'main!", german="Jaaaa! Ich fange gleich morgen damit an!", italian="Sì! Da domani comincerò a fare meglio!", spanish="¡Claro que sí! ¡Lo haré mejor a partir de\nmañana!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 1 then
  -- @label_27 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 1: I'll Try Hard!\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 1: J'ferai de mon mieux!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 1: Ich gebe mein Bestes!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 1: Ci proverò!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]1. ¡Lo voy a intentar!\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oof...![K] Seems that it's been a mighty long time\nsince I apprenticed at this here guild.", french="Pfiou...![K] J'ai l'impression qu'ça fait\nvachement longtemps que j'suis apprenti\nà la Guilde.", german="Uuf![K] Scheint schon ziemlich lange her zu\nsein, dass ich hier an dieser Gilde als Lehrling\nangenommen wurde.", italian="Puff...![K] Mi sembra sia passata un'eternità\nda quando sono diventato una recluta della\nGilda.", spanish="¡Uf![K] Parece que ha pasado una eternidad\ndesde que empecé como aprendiz en el\n[CS:N]Pokégremio[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I get so frustrated being so klutzy and slow...\nYup yup! Don't I know it!", french="C'est rudement frustrant d'être aussi\nlent et empoté... Pour sûr! J'en sais\nquequ'chose!", german="Es ist echt niederschmetternd, so\nschwerfällig und langsam zu sein. Jawollja!\nAls ob ich das nicht wüsste!", italian="Quant'è frustrante essere così goffo e lento...\nOhibò! Cosa posso fare?", spanish="¡Me da tanta rabia ser así de lento y torpe!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I'm a slow worker. And it takes me longer to\nlearn than others.", french="J'suis lent à la détente, j'y peux rien.\nDu coup, il m'faut beaucoup plus de temps\nqu'les autres pour apprendre un truc.", german="Ich bin ein langsamer Arbeiter, und ich brauche\nlänger als andere, um Dinge zu lernen.", italian="Sono lento. E ci metto più tempo degli altri\na imparare.", spanish="Voy sin prisa pero sin pausa y tardo algo\nmás en aprender que el resto."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oof... I sure miss my home and folks. Yup yup!", french="J'comprends vite, mais faut m'expliquer\nlongtemps... Pfiou! Ma maison et ma famille\nme manquent. Pour sûr!", german="Uuf, wie vermisse ich meine Heimat und meine\nLeute. Jawollja!", italian="Puff... Mi mancano la mia casa e i miei simili.\nOhibò! Che farò?", spanish="Vaya, ¡y además echo de menos mi casa\ny a mis amigos!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But![K] I can't be what I want to be if I admit\ndefeat now! No sirree, by golly!", french="Mais tant pis![K] J'deviendrai jamais c'que\nj'veux devenir si j'baisse les bras maintenant!\nSapristi, ça non!", german="Aber![K] Ich kann nicht das sein, was ich sein\nmöchte, wenn ich mich jetzt geschlagen gebe!\nNein, wirklich nicht, Menschenskind!", italian="Ma![K] Se mollo adesso non potrò mai essere\nciò che voglio diventare! Nossignore, ohibò!", spanish="Pero...[K] nunca podré llegar a ser quien quiero si\nme rindo a las primeras de cambio. ¡No, señor!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Yup yup! I have my big dream![K] I'm surely going\nto become a first-class explorer, yup!", french="C'est qu'j'ai un rêve, moi, pour sûr![K] J'vais\nsûrement devenir un explorateur d'premier\nordre, pardi!", german="Jawollja! Ich habe einen großen Traum![K] Ich\nwerde sicher einmal ein erstklassiger\nErkunder, jawollja!", italian="Ohibò! Ho un grande sogno![K] Diventare un\nesploratore di prima categoria!", spanish="¡Por supuesto que no me rendiré! ¡Pienso\ncumplir mi sueño![K] Sí, ¡voy a convertirme\nen un explorador hecho y derecho!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="And that's why I've started this here diary!\nIt's a way for me to keep track of what I'm\nmade of. Yup yup!", french="Et c'est pour ça qu'j'me suis mis à écrire\nce journal-là! Ça m'permet de garder une\ntrace de c'que j'fais, pour sûr.", german="Und deshalb habe ich mit diesem Tagebuch hier\nbegonnen! Ich verwende es, um festzuhalten,\naus welchem Holz ich geschnitzt bin.", italian="Ed è per questo che ho iniziato questo diario!\nPer me è un modo per capire di che pasta sono\nfatto... Ohibò!", spanish="¡Y por eso estoy escribiendo este diario! ¡Ea!\n¡Para demostrarme a mí mismo lo que valgo!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Yup yup! Tomorrow, I'll hold my head up high!\nI'll get things done!", french="Demain, j'garderai la tête bien haute,\npour sûr! J'accomplirai tout un tas d'trucs!", german="Jawollja! Morgen werde ich erhobenen Hauptes\nlosziehen und die Dinge in Angriff nehmen!", italian="Ohibò! Domani terrò la testa alta! Ce la farò!", spanish="¡Decidido! ¡Mañana iré con la cabeza bien\nalta y haré bien mi trabajo!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_57 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 26 -- $EVENT_LOCAL = 26 (ROM)
  -- @label_56 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyMenuResults or {})["MENU_DIARY_BIDOOF"] or 0) -- switch(message_Menu(MENU_DIARY_BIDOOF)) [message_Menu(MENU_DIARY_BIDOOF): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 26 then
  -- @label_2 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 26: Keeping It Going\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 26: Faut s'accrocher!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 26: Dranbleiben\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 26: Andare avanti\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]26. Que no decaiga\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="So [hero] and [partner] are back!\nBack in Treasure Town, by golly!", french="Voilà, [hero] et [partner] sont\nd'retour à Bourg-Trésor, pardi!", german="Also, [hero] und [partner] sind\nzurück! Zurück in Schatzstadt, Menschenskind!", italian="Così [hero] e [partner] sono di\nnuovo qui a Borgo Tesoro, ohibò!", spanish="¡[hero] y [partner] ya están de\nvuelta en Aldea Tesoro! ¡Ya lo decía yo!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oof... I'm so glad for this... By golly, I'm\noverjoyed...", french="Pfiou... J'suis vachement soulagé... J'me roule\npar terre tellement j'suis content...", german="Uuf, ich bin so froh darüber. Menschenskind,\nich bin außer mir vor Freude.", italian="Puff... Sono così felice... Ohibò, molto felice...", spanish="¡Huy!... ¡Estoy tan contento que no sé\nqué hacer!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="They had me so worried... Sniffle...", french="J'étais vachement inquiet... snif...", german="Ich war so besorgt um sie. Schnüffel...", italian="Mi hanno fatto preoccupare... Sniff...", spanish="¡Huy! Me tenían tan preocupado..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Yup yup, [hero] and [partner] aren't\njust rookies to me anymore.", french="[hero] et [partner], c'est plus des\nnovices, pour sûr.", german="Jawollja, [hero] und [partner] sind\nkeine bloßen Anfänger mehr für mich.", italian="Ohibò, [hero] e [partner] per me non\nsono più semplici reclute.", spanish="Claro, [hero] y [partner] ya no son\nprincipiantes."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="They're my friends... My trusted fellow guild\nmembers...", french="Ce sont mes compagnons... Mes fidèles\ncompagnons d'la Guilde...", german="Sie sind meine Freunde, meine zuverlässigen\nGildenkollegen.", italian="Ormai ci unisce l'amicizia... La fiducia\ndi noi membri della Gilda...", spanish="Son mis colegas y les confiaría cualquier\ncosa."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="And they're my heroes.", french="Ces deux-là font partie de mes héros.", german="Und sie sind meine Helden.", italian="E per me sono un esempio.", spanish="Además, son mis héroes."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I swear I'll become a first-rate explorer one\nday! For that...I'll try, try, try, by golly!", french="J'le jure, j'serai un explorateur d'premier\nordre un de ces jours! Juré, juré, juré,\npardi!", german="Ich schwöre, dass ich eines Tages ein\nerstklassiger Erkunder sein werde. Dafür\nwerde ich üben, üben, üben, Menschenskind!", italian="Giuro che un giorno diventerò un esploratore\ndi prima categoria! Ci proverò, ci proverò e\nci proverò ancora, ohibò!", spanish="¡Juro que algún día seré un explorador\nhecho y derecho! ¡Aunque tenga que\nentrenar sin cesar!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I gotta catch up to [hero] and\n[partner]!", french="Faut que j'rattrape mon retard sur\n[hero] et [partner]!", german="Ich muss zu [hero] und [partner]\naufschließen!", italian="Devo fare come [hero] e\n[partner]!", spanish="¡Voy a ser tan buen explorador como\n[hero] y [partner]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="That's why I'm gonna keep going, and I hope\nthey will too!", french="C'est pour ça que j'vais m'accrocher, et faire\naussi bien que ces deux-là, j'espère!", german="Darum werde ich weitermachen und darauf\nhoffen, dass auch sie nicht aufhören werden!", italian="È per questo che continuerò a impegnarmi, e\nspero che lo faranno anche loro!", spanish="¡Por eso no voy a dejar de explorar!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 25 then
  -- @label_3 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 25: Sure to Win!\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 25: A moi la victoire!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 25: Ein sicherer Sieg!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 25: La vittoria in tasca!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]25. ¡Venceremos seguro!\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Team [team:] has gone off to a place\ncalled the [CS:P]Dark Crater[CR].", french="L'Equipe [team:] est partie pour un\nendroit appelé [CS:P]Cratère Obscur[CR].", german="Team [team:] hat sich zu einem Ort\nnamens [CS:P]Dunkelkrater[CR] begeben.", italian="Il Team [team:] è partito alla volta di un\nluogo chiamato [CS:P]Cratere Oscuro[CR].", spanish="El [CS:X]Equipo[CR] [team:] se ha marchado a\nun sitio conocido como el [CS:P]Cráter Oscuro[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh, [hero] and [partner]! You have\nto be tough, by golly!", french="Allez, [hero] et [partner]! Du cran,\npardi!", german="Oh, [hero] und [partner]! Ihr müsst\nzäh sein, Menschenskind!", italian="Oh, [hero] e [partner]! Dovete dare\ntutto, ohibò!", spanish="Caramba, ¡[hero] y [partner] son\nmuy valientes!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I've never been much at understanding\nanything complicated, but...", french="J'ai jamais été très doué pour comprendre\nles trucs compliqués, mais...", german="Ich war noch nie gut darin, komplizierte Dinge\nzu verstehen, aber...", italian="Non sono bravo a capire le cose complicate,\nma...", spanish="Nunca se me ha dado bien entender estas\ncosas, pero..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But I know that [hero] and [partner]\ncan beat that [CS:N]Darkrai[CR]...", french="J'sais que [hero] et [partner]\npeuvent battre ce [CS:N]Darkrai[CR]...", german="Aber ich weiß, dass [hero] und\n[partner] dieses [CS:N]Darkrai[CR] besiegen können.", italian="Ma so che [hero] e [partner]\npossono battere quel [CS:N]Darkrai[CR]...", spanish="Estoy convencido de que [hero] y\n[partner] podrán con ese tal [CS:N]Darkrai[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="And, by golly, I know they'll come back like\nthey've always done!", french="Et leur retour sera triomphal,\ncomme toujours, pour sûr!", german="Und, Menschenskind, ich weiß, dass sie wie\nsonst auch zurückkommen werden!", italian="E, ohibò, so anche che torneranno, come han\nsempre fatto!", spanish="Estoy seguro de que volverán, como\nsiempre."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="My thoughts go with them, by gosh!", french="Mes pensées les accompagnent, pour sûr!", german="In Gedanken bin ich bei ihnen, zum\nDonnerwetter!", italian="Penserò molto a loro, ohibò!", spanish="¡Espero que todo se les dé bien!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="They will... They're coming back, sure as the\nsun's coming up!", french="Ces deux-là reviendront, aussi sûr que l'soleil\ns'lève tous les matins!", german="Sie werden... Sie kommen zurück. Das ist so\nsicher wie der morgendliche Sonnenaufgang!", italian="Ce la faranno... Torneranno sicuramente,\ncome è vero che mi chiamo Bidoof!", spanish="Volverán... Seguro que volverán. Estoy\ntan seguro de que volverán como de\nque el cielo es azul."})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 24 then
  -- @label_4 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 24: [CS:N]Azurill[CR]...\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 24: [CS:N]Azurill[CR]...\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 24: [CS:N]Azurill[CR]...\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 24: [CS:N]Azurill[CR]...\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]24. [CS:N]Azurill[CR]...\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oof... Little [CS:N]Azurill[CR] is stuck in a nightmare that\nhe can't wake from...", french="Pfiou... L'petit [CS:N]Azurill[CR] est coincé dans un\ncauchemar, et pas moyen d'le réveiller...", german="Uuf. Der kleine [CS:N]Azurill[CR] steckt in einem\nAlbtraum fest, aus dem er nicht mehr\naufwachen kann.", italian="Puff... Il piccolo [CS:N]Azurill[CR] è imprigionato in un\nincubo da cui non riesce più a svegliarsi...", spanish="¡Huy! ¡El pequeño [CS:N]Azurill[CR] está atrapado en\nuna pesadilla y no puede despertarse!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I've been getting plenty of sleep of late... But,\nmaybe because of all that sleep, I've been\nwanting to sleep even more...", french="J'arrête pas d'dormir ces derniers temps...\nMais peut-être que c'est ça qui m'donne\nencore plus sommeil...", german="Ich habe in letzter Zeit reichlich Schlaf gehabt,\naber der ganze Schlaf hat nur dafür gesorgt,\ndass ich noch mehr schlafen will.", italian="Ultimamente ho dormito un sacco... Ma, forse\nproprio perché dormo così tanto, ho sempre\npiù voglia di dormire...", spanish="Últimamente duermo bastante... y puede que\npor eso quiera dormir más y más..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Why, if I set my mind to it, I reckon I can\nsleep all the day and all the night, yup yup.", french="J'suis sûr que j'pourrais dormir toute la\njournée et toute la nuit, si j'le voulais,\nouaip ouaip.", german="Wenn ich es darauf ankommen lassen würde,\nkönnte ich bestimmt den ganzen Tag und die\nganze Nacht schlafen, jawollja.", italian="Perché? Se ci penso, credo che potrei dormire\ntutto il giorno e tutta la notte, ohibò.", spanish="Creo que, si me lo propusiera, podría dormir\na pierna suelta todo el día."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But that doesn't seem to be the problem with\nthat little guy...", french="Mais ce p'tit gars a l'air de souffrir d'un\nautre problème...", german="Aber das scheint nicht das Problem bei dem\nKleinen zu sein.", italian="Ma non sembra questo il problema di quel\npiccolo...", spanish="Pero ese no parece que sea el problema del\npequeñuelo..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It's a little worrying, by golly...", french="C'est un peu inquiétant, sapristi...", german="Das ist ein wenig beunruhigend, Menschenskind.", italian="È un po' preoccupante, ohibò...", spanish="La verdad es que es preocupante..."})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 23 then
  -- @label_5 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 23: Peace Is Best\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 23: La paix, c'est cool!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 23: Frieden ist das Beste\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 23: Viva la pace!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]23. La paz es lo mejor\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Yawwwn... Shucks, I am sleepy...", french="Mouaaah... Mince alors, j'ai sommeil...", german="Gähhhn... Ich bin so schläfrig...", italian="Yawwwn... uffa, ho sonno...", spanish="Uaaa... Uf, ¡qué sueño!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I write these entries at night... But, by golly,\nit's been hard to keep my eyelids peeled...", french="J'écris ce journal la nuit... Mais, c'est dur\nd'garder les yeux ouverts, parbleu...", german="Diese Einträge schreibe ich in der Nacht.\nMenschenskind, ist das schwer, meine Augen\noffenzuhalten.", italian="Ho scritto queste note di notte... Ma, ohibò,\nè dura restare svegli...", spanish="Siempre escribo el diario de noche, pero hoy\nme está costando mantener los ojos abiertos..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I reckon that goes to show how peaceful it's\nbeen of late. Yup yup.", french="Ça montre bien à quel point la vie est paisible,\nces derniers temps, pour sûr.", german="Ich denke mal, das reicht, um zu verdeutlichen,\nwie friedlich es in letzter Zeit ist. Jawollja.", italian="Suppongo dipenda dal fatto che di recente\ntutto è così pacifico. Ohibò.", spanish="Es porque todo está mucho más tranquilo."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Why, it seems like it's been ages\nsince [hero]'s team put a stop to the\nplanet's paralysis.", french="On dirait que ça fait des lustres que l'équipe\nde [hero] a mis fin à la Paralysie d'la\nPlanète.", german="Es fühlt sich an, als wäre es schon eine\nEwigkeit her, dass das Team von [hero]\ndie Lähmung des Planeten aufgehalten hat.", italian="Perché? Perché sembra che siano passati anni\nda quando la squadra di [hero] ha\nscongiurato la paralisi del pianeta.", spanish="Parece que hace siglos desde que el equipo de\n[hero] evitó la parálisis del planeta."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It'd be perfect, I reckon, if...[K] Everyone can be\ndecent to each other...[K] For a long, long time...", french="Tout irait pour l'mieux dans l'meilleur des\nmondes si...[K] tout l'monde était sympa avec\nles autres...[K] Pendant très, très longtemps...", german="Es wäre nicht auszudenken, wenn...[K] alle nett\nzueinander wären.[K] Und das für eine lange,\nlange Zeit.", italian="Sarebbe perfetto, dico io, se...[K] ognuno\nrispettasse gli altri...[K] per tanto, tanto\ntempo...", spanish="Sería todo perfecto si...[K] si todo el mundo se\nportara bien con los demás...[K] Así seguro que\nduraría bastante esta tranquilidad..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="That's what I think...[K] Yup yup...[K] Zzzz...[K] Zzzzz...", french="C'est mon avis...[K] Pour sûr...[K] Zzzz...[K]\nZzzzz...", german="Das denke ich.[K] Jawollja.[K] Zzzz...[K] Zzzzz...", italian="La penso così...[K] Ohibò...[K]\nZzzz...[K] Zzzzz...", spanish="Eso es lo que pienso...[K] Sí...[K] Zzz...[K] Zzzz..."})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 22 then
  -- @label_6 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 22: Awesome Team [CS:X]Charm[CR]\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 22: Sous le [CS:X]Charme[CR]\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 22: Tolles Team [CS:X]Charme[CR]\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 22: Il bel Team [CS:X]Malia[CR]\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]22. El [CS:X]Equipo Carisma[CR]\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="What...?[K] I'm amazed![K] I am downright amazed!\nYup yup yuppers!", french="Quoi...?[K] J'suis ébahi![K] Vachement ébahi,\nmême! Sapristi, pour sûr et pardi!", german="Was?[K] Ich bin erstaunt![K] Ich bin wirklich\nerstaunt! Jawollja!", italian="Cosa...?[K] Sono sbalordito![K] Sono davvero\nsbalordito! Per tutti gli ohibò!", spanish="¿Eh?[K] ¡Estoy impresionado![K]\n¡Qué digo! ¡Estoy patidifuso!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Those superfamous and superattractive\nmembers of Team [CS:X]Charm[CR]...", french="Les exploratrices hyper célèbres et hyper\nbelles de l'Equipe [CS:X]Charme[CR]...", german="Die superberühmten und superattraktiven\nMitglieder von Team [CS:X]Charme[CR]...", italian="Le superfamose e supergraziose\ncomponenti del Team [CS:X]Malia[CR]...", spanish="Resulta que el megafamoso y superatractivo\n[CS:X]Equipo Carisma[CR]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="They're at the guild! Yup yup yuppers!", french="Elles sont à la Guilde! Ouaip ouaip ouaip!", german="Halten sich in der Gilde auf! Jawollja!", italian="... sono alla Gilda! Per tutti gli ohibò!", spanish="¡Está aquí, en el [CS:N]Pokégremio de Exploradores[CR]!\n¡Qué disparate!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But by golly, there's more! Talk of going\nexploring together came up!", french="Et c'est pas tout, parbleu! Elles ont parlé\nd'partir en exploration avec moi!", german="Aber Menschenskind, das ist noch nicht alles!\nEs wurde über eine gemeinsame Erkundung\ngesprochen!", italian="Ma ohibò, c'è di più! Parlano di andare a\nesplorare assieme!", spanish="Y eso no es todo... ¡Al parecer vamos a ir\njuntos a explorar!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I am...[K]over the moon with happiness!", french="J'suis... [K]aux anges! J'me roule par terre,\nc'est trop génial!", german="Ich glaube,[K] ich platze vor Freude!", italian="Sono...[K] al settimo cielo!", spanish="Estoy...[K] ¡que no quepo en mí de gozo!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Since I have been getting better, if I may say\nso myself...[K] Why, it wouldn't be out of the\nquestion for me to shine, by golly!", french="Vu que j'ai fait des progrès dernièrement, si\nj'peux m'permettre...[K] J'ai toutes mes chances\nd'briller, pour sûr!", german="Seitdem ich besser geworden bin, wenn ich das\nso sagen darf,[K] wäre es doch gar nicht so\nabwegig für mich, zu glänzen, Menschenskind!", italian="Sto andando meglio, sì, me lo dico da solo...[K]\nPerché non dovrei riuscire a eccellere, ohibò?", spanish="Creo que, aunque esté feo decirlo, estoy\nmejorando como explorador...[K] ¡Seguro que\nlo haré muy bien!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="If I did, maybe Miss [CS:N]Lopunny[CR] would be kind\nenough to give me a cheer... Oof...", french="Et si j'me surpasse, peut-être que mam'zelle\n[CS:N]Lockpin[CR] aura la gentillesse de m'encourager...\nPfiou...", german="Wenn ich das täte, würde mich [CS:N]Schlapor[CR]\nvielleicht bejubeln... Uuf...", italian="Se ce la facessi, magari la signorina [CS:N]Lopunny[CR]\nsarebbe così carina da incitarmi... Puff...", spanish="Si sobresalgo, puede que hasta [CS:N]Lopunny[CR] se fije\nen mí... ¡Huyuyuy!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Waaaah![K] I'm an embarrassment to myself!", french="Ouaaah![K] V'là que j'me fais rougir tout seul\nmaintenant!", german="Waaaah![K] Ich bin mir selbst schon peinlich!", italian="Aaaah![K] Sto diventando rosso come un\npeperone!", spanish="¡Oh![K] ¡Qué vergüenza!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I'm beside myself with embarrassment! Yipes!", french="J'suis vachement gêné, ça me met\ndans un état! Saperlipopette!", german="Ich stehe peinlich berührt neben mir! Oje!", italian="Che imbarazzo! Ohibò!", spanish="¡Ay! Me muero de la vergüenza..."})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 21 then
  -- @label_7 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 21: Cheer Up!\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 21: Haut les cœurs!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 21: Kopf hoch!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 21: Coraggio!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]21. ¡Ánimo!\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Sniffle... Baby [CS:N]Manaphy[CR] had to go back to the\nsea today...", french="Snif... Le p'tit [CS:N]Manaphy[CR] a dû retourner\nà la mer aujourd'hui...", german="Schnüffel. Das kleine [CS:N]Manaphy[CR] musste heute\nins Meer zurückkehren.", italian="Sniff... Il piccolo [CS:N]Manaphy[CR] oggi deve tornare\nin mare...", spanish="¡Ay!... El pequeño [CS:N]Manaphy[CR] tuvo que regresar\nhoy al mar..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Like [CS:N]Corphish[CR] said... I reckon that [CS:N]Manaphy[CR] is\na Pokémon that rightly has to grow in the sea.", french="Comme l'a dit [CS:N]Ecrapince[CR]... J'suppose que\n[CS:N]Manaphy[CR] est un Pokémon qui a besoin d'vivre\ndans l'eau.", german="Da stimme ich [CS:N]Krebscorps[CR] zu: [CS:N]Manaphy[CR] ist ein\nPokémon, das naturgemäß im Meer\naufwachsen muss.", italian="Come ha detto [CS:N]Corphish[CR]... Bisogna considerare\nche [CS:N]Manaphy[CR] è un Pokémon che dovrebbe\ncrescere in mare.", spanish="Como decía [CS:N]Corphish[CR], creo que [CS:N]Manaphy[CR] es\nun Pokémon que debe crecer en el mar."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh, [hero] and [partner]! I hope that\nyou cheer up!", french="Oh, [hero] et [partner]! J'espère\nque vous reprendrez espoir!", german="Oh, [hero] und [partner]! Kopf hoch,\nihr zwei!", italian="Oh, [hero] e [partner]! Spero che\ntornerete di buon umore!", spanish="¡Espero que [hero] y [partner] se\nanimen!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="That baby [CS:N]Manaphy[CR] won't forget the two of\nyou, not even after a long time, I reckon.", french="Le bébé [CS:N]Manaphy[CR] ne vous oubliera pas de sitôt,\nah ça non!", german="Ich denke, das kleine [CS:N]Manaphy[CR] wird euch zwei\nsicher nie vergessen, auch nach einer sehr\nlangen Zeit nicht.", italian="Quel piccolo [CS:N]Manaphy[CR] non vi dimenticherà,\nneanche tra molto tempo, suppongo.", spanish="Seguro que [CS:N]Manaphy[CR] no se olvidará nunca de\nese par."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="One of these days, you will be able to see\neach other again, yup yup.", french="Un d'ces jours, vous vous reverrez, pour sûr.", german="Eines Tages werdet ihr euch sicher\nwiedersehen, jawollja.", italian="Uno di questi giorni, lo rivedrete, ohibò.", spanish="Y estoy completamente convencido de que lo\nvolverán a ver."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I'll keep it in mind that I should stay cheerful\nand upbeat around [hero] and\n[partner], yup yup!", french="Faut que j'pense à être plein d'entrain et\nd'optimisme quand j'suis avec [hero] et\n[partner], ouaip ouaip!", german="Ich werde daran denken, aufmunternd und\noptimistisch zu sein, wenn ich in der Nähe von\n[hero] und [partner] bin, jawollja!", italian="Devo ricordarmi di rimanere allegro e\nottimista quando sono vicino a [hero] e\n[partner], ohibò!", spanish="¡A ver si me acuerdo de intentar animar a\n[hero] y a [partner]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I just wish that they'd get back to being their\nusual cheery selves soon, yup yup.", french="J'espère que ces deux-là retrouveront vite\nleur bonne humeur habituelle, sapristi.", german="Ich wünsche mir nur, dass sie bald ihren\nFrohsinn von früher wiedererlangen, jawollja.", italian="Vorrei vedere di nuovo il sorriso sulle\nloro labbra, ohibò.", spanish="Me gustaría que recuperaran su alegría\nhabitual."})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 20 then
  -- @label_8 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 20: [CS:N]Manaphy[CR]?\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 20: [CS:N]Manaphy[CR]?\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 20: [CS:N]Manaphy[CR]?\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 20: [CS:N]Manaphy[CR]?\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]20. ¿[CS:N]Manaphy[CR]?\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="So I was thinking that [CS:N]Chatot[CR] has been mighty\ntesty of late. What's been eating him?", french="En y réfléchissant, [CS:N]Pijako[CR], il est vraiment\ngrincheux, ces derniers temps. Qu'est-ce qui\nle ronge?", german="Ich habe den Eindruck, dass [CS:N]Plaudagei[CR] in\nletzter Zeit ziemlich gereizt ist. Was nagt nur\nan ihm?", italian="Stavo pensando che [CS:N]Chatot[CR] è piuttosto\nirascibile ultimamente. Che cosa lo\npreoccupa?", spanish="Me he estado preguntando por qué [CS:N]Chatot[CR] está\ntan irascible últimamente."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Turns out that baby [CS:N]Manaphy[CR] had taken sick.\nI didn't know that...", french="J'ai découvert que [CS:N]Manaphy[CR] était tombé\nmalade. J'en savais rien...", german="Wie sich herausstellte, ist das kleine [CS:N]Manaphy[CR]\nkrank geworden. Davon wusste ich nichts.", italian="È saltato fuori che il piccolo [CS:N]Manaphy[CR] si è\nammalato. Non lo sapevo...", spanish="Resulta que el pequeño [CS:N]Manaphy[CR] está enfermo.\nYo no tenía ni idea... para variar."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oof... I hope that baby'll be all right... This is\nworrisome, by golly...", french="Pfiou... Espérons qu'il se remette, ce bébé...\nC'est vachement inquiétant, ma foi...", german="Uuf, ich hoffe, dass das Kleine bald wieder\ngesund wird. Das ist besorgniserregend,\nMenschenskind.", italian="Puff... Spero che presto starà meglio... Sono\npreoccupato, ohibò...", spanish="Uf... Espero que no sea nada grave... ¡Huy!\n¡Qué preocupación!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 19 then
  -- @label_9 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 19: Recent Events\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 19: Dernières nouvelles!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 19: Neueste Ereignisse\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 19: Eventi recenti\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]19. Novedades\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I put in another fine day of training today,\nyup yup.", french="Aujourd'hui encore, j'me suis entraîné dur,\npour sûr.", german="Heute habe ich einen weiteren tollen\nTrainingstag hingelegt, jawollja.", italian="Oggi mi sono nuovamente allenato bene, ohibò.", spanish="Hoy se me ha dado muy bien la exploración.\n¡Sí, señor!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I reckon it's because I've got the goal of\ngraduating. It's surely making every day\nmeaningful, yup yup.", french="Sûrement à cause que j'ai un but: obtenir mon\ndiplôme. Ça donne un sens à chaque jour passé\nici, pour sûr.", german="Ich denke, das liegt daran, dass ich den\nGildenabschluss als Ziel vor Augen habe. Das\ngibt jedem Tag einen Sinn. Jawollja.", italian="Suppongo sia perché l'obiettivo dell'esame\nmi dà nuovi stimoli ogni giorno, ohibò.", spanish="Debo confesar que es porque tengo en mente\nsuperar el gran reto del [CS:N]Pokégremio[CR] y eso\nhace que intente superarme cada día."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Why, I can tell I'm getting better and better at\nexploring, by golly!", french="J'sens bien que j'deviens de plus en plus\nbalaise comme explorateur, pardi!", german="Ich werde immer besser beim Erkunden,\nMenschenskind!", italian="Perché? Penso che continuando a\nesplorare, miglioro ogni giorno che passa,\nohibò!", spanish="Huy, además noto como cada vez se me da\nmejor explorar."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The way I've been working lately, like a\nPokémon on a mission... I'm proud of myself,\nby golly!", french="La façon dont j'travaille ces derniers temps,\ncomme un Pokémon en mission... Ça m'remplit\nde fierté, pour sûr!", german="Die Art, wie ich in letzter Zeit gearbeitet habe,\ngleicht der eines Pokémon auf einer Mission.\nIch bin stolz auf mich selbst, Menschenskind!", italian="Il modo in cui ho lavorato ultimamente, come\nun Pokémon in missione... Sono orgoglioso di\nme stesso, ohibò!", spanish="Últimamente, he explorado tan bien, que\nestoy muy orgulloso de mí mismo."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="..................", french="..................", german="......", italian="..................", spanish="..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I think I'm smitten with myself...[K] I'm blushing!", french="J'crois bien que j'ai les chevilles qui enflent...[K]\nÇa m'fait rougir!", german="Ich glaube, ich bin in mich selbst verliebt.[K] Ich\nwerde schon ganz rot!", italian="Mi meraviglio di me stesso...[K] Sto arrossendo!", spanish="Creo que hasta...[K] ¡me estoy ruborizando!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 18 then
  -- @label_10 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 18: Aiming for Graduation\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 18: Objectif: diplôme\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 18: Ziel: Gildenabschluss\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 18: Obiettivo diploma\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]18. A la espera...\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I'm doing the best I can so I can graduate.\nYup yup!", french="J'fais d'mon mieux pour décrocher mon\ndiplôme, pour sûr!", german="Ich tue mein Bestes, um für die\nAbschlussprüfung zugelassen zu werden.\nJawollja!", italian="Sto dando il meglio per riuscire a superare\nl'esame. Ohibò!", spanish="¡Sí! ¡Voy a hacer todo lo posible para superar\nel gran reto del [CS:N]Pokégremio de Exploradores[CR]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I got to thinking about how the others were\nconsidering their prospects for graduating.", french="J'me suis mis à réfléchir à la façon dont les\nautres estiment leurs chances d'avoir leur\ndiplôme.", german="Ich habe angefangen, darüber nachzudenken,\nwie die anderen ihre Aussichten auf den\nAbschluss wohl eingestuft haben.", italian="Chissà cosa pensano gli altri a proposito\ndell'esame? Si ritengono all'altezza?", spanish="He estado preguntándome qué pensarían los\ndemás de sus posibilidades de superar el gran\nreto."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="So I went around asking others their thoughts\nabout graduation... Well, their answers were\nall over the place, yup yup.", french="Alors j'ai fait un p'tit sondage pour connaître\nleur opinion à propos de l'examen... Ben, j'ai\nobtenu toutes sortes de réponses, sapristi.", german="Also bin ich herumgegangen und habe die\nanderen über den Abschluss befragt. Ihre\nAntworten fielen querbeet aus. Jawollja.", italian="Così sono andato in giro a chiedere cosa ne\npensavano... Beh, le loro risposte sono state\ntutte sopra le righe, ohibò.", spanish="Así que decidí darme una vuelta y preguntar\npor ahí. Y había todo tipo de opiniones."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Take, for instance, [CS:N]Croagunk[CR]. They say he's\ngood enough to graduate anytime he wants.", french="Prenons [CS:N]Cradopaud[CR], par exemple. A ce qu'on\ndit, il a l'niveau pour obtenir son diplôme\nquand ça l'chante.", german="Nehmen wir beispielsweise [CS:N]Glibunkel[CR]. Man sagt,\ner sei jederzeit bereit dazu, die Prüfung\nabzulegen.", italian="Prendi, per esempio, [CS:N]Croagunk[CR]. Dicono tutti che\nsia abbastanza preparato da poter passare\nl'esame quando vuole.", spanish="[CS:N]Croagunk[CR], por ejemplo, dice que podría\nsuperar el gran reto cuando quisiera."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Now, I don't rightly know if that is true,\nno sirree...", french="Bon, j'sais pas si c'est vrai, ça non...", german="Ich bin mir da nicht so sicher, nein, wirklich\nnicht!", italian="Ora, non so se è proprio vero, nossignore...", spanish="En fin, ¡yo no me lo acabo de creer! ¡No,\nseñor!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="That said, [CS:N]Croagunk[CR] seems to have no interest\nin being on an exploration team in the first\nplace...", french="Ce qu'il y a, c'est que [CS:N]Cradopaud[CR] a pas l'air\nd'vouloir faire partie d'une équipe\nd'exploration, de toute façon...", german="Man sagt, [CS:N]Glibunkel[CR] habe ohnehin kein großes\nInteresse daran, Mitglied eines\nErkundungsteams zu sein.", italian="[CS:N]Croagunk[CR] non sembra affatto interessato a\nfar parte di una squadra d'esplorazione...", spanish="Aunque parece que [CS:N]Croagunk[CR] no tiene el más\nmínimo interés en abandonar el [CS:N]Pokégremio[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="They tell me he just joined the guild because\nhe had his heart set on getting that Swap\nCauldron.", french="Il paraît qu'il a rejoint la Guilde uniquement\nparce qu'il avait des vues sur\nl'Chaudron-Troc.", german="Offenbar hat er sich nur der Gilde\nangeschlossen, weil er ein Auge auf den\nTauschkessel geworfen hat.", italian="Mi hanno detto che si è unito alla Gilda perché\nil suo cuore è totalmente devoto a quel\nPentolone dei Cambi.", spanish="Dicen por ahí que solo se unió por el Caldero\nde Trueque."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="You see, he was of a mind to graduate and\ntake the Swap Cauldron with him.", french="Il avait prévu de décrocher son diplôme et de\npartir avec le Chaudron-Troc sous l'bras,\ntu vois le genre.", german="Er wollte also die Abschlussprüfung ablegen\nund dann den Tauschkessel mitnehmen.", italian="Capisci, aveva pensato di passare l'esame e\ndi portarsi via il Pentolone.", spanish="Al parecer, pensaba llevárselo después de\nsuperar el gran reto."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But then he found out that the Swap Cauldron\nwas permanently stuck to the guild's floor.", french="Et pis, il s'est rendu compte que\nl'Chaudron-Troc était rivé au sol\nd'la Guilde.", german="Aber dann hat er herausgefunden, dass der\nTauschkessel dauerhaft im Boden der Gilde\nverankert ist.", italian="Ma poi ha scoperto che il Pentolone era fissato\nal pavimento della Gilda.", spanish="Pero descubrió que el Caldero de Trueque\nestá clavado al suelo y no hay manera de\nmoverlo."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="That settled things for him. He wasn't about to\nleave that Swap Cauldron, so he's been here\never since. Golly!", french="Du coup, son choix était fait. Comme il voulait\npas quitter son Chaudron-Troc, il a décidé\nd'rester, pardi!", german="Damit war die Angelegenheit für ihn erledigt.\nDen Kessel konnte er nicht mitnehmen, also\nhält er sich seither hier auf. Menschenskind!", italian="Questo fatto è stato decisivo. Non aveva\nnessuna intenzione di allontanarsi dal Pentolone,\ne da allora è qui. Ohibò!", spanish="Eso le hizo replantearse las cosas. No pensaba\nabandonar su preciado caldero, así que se\nniega a intentar superar el reto. ¡Menudo es!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Yup yup! It seems to me everyone's got their\nown good reason. I'm learning from it, yup yup.", french="Sapristi, on dirait que tout l'monde a ses\nraisons. J'apprends beaucoup des autres,\npour sûr.", german="Jawollja! Offenbar hat jeder seine eigenen\nGründe. Ich lerne dadurch, jawollja.", italian="Ohibò! Mi sembra che abbiano tutti le loro\nbuone ragioni. Sto imparando molto, ohibò.", spanish="¡Sí! Cada uno tiene sus motivos. Y yo estoy\naprendiendo de ellos, claro."})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 17 then
  -- @label_11 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 17: Congratulations!\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 17: Félicitations!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 17: Glückwunsch!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 17: Congratulazioni!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]17. ¡Felicidades!\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Sniffle... Team [team:] passed its\ngraduation exam!", french="Snif... L'Equipe [team:] a décroché son\ndiplôme d'la Guilde!", german="Schnüffel. Team [team:] hat seine\nAbschlussprüfung bestanden!", italian="Sniff... Il Team [team:] ha superato\nl'esame!", spanish="¡Ay! ¡El [CS:X]Equipo[CR] [team:] superó el gran\nreto del [CS:N]Pokégremio de Exploradores[CR]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Well...[hero] and [partner]...\nCongratulations! Sniffle...", french="Bon... [hero] et [partner]...\nFélicitations! Snif...", german="Nun, [hero] und [partner].\nIch gratuliere! Schnüffel.", italian="Bene... [hero] e [partner]...\nCongratulazioni! Sniff...", spanish="En fin... Os tengo que felicitar, [hero] y\n[partner]. ¡Ay!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I'm so happy for you all, yet so sad that you're\nout. My head is spinning... Sniffle...", french="J'suis content pour vous deux, mais j'suis\ntriste qu'vous partiez. J'ai la tête qui\ntourne... snif...", german="Ich freue mich so für euch, aber ich bin\nauch traurig, dass ihr nun draußen seid. In\nmeinem Kopf dreht sich alles. Schnüffel.", italian="Sono davvero contento per voi due, ma anche\nmolto triste perché non sarete più qui. Mi gira\nla testa... Sniff...", spanish="Me alegro mucho, la verdad. Pero al mismo\ntiempo me da tanta pena que vayan a dejar\nel [CS:N]Pokégremio[CR]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But I reckon that the other apprentices are\ngoing to graduate one day too...", french="Mais j'imagine que les autres apprentis\nobtiendront leur diplôme un jour, eux aussi...", german="Aber ich denke, dass die anderen Lehrlinge auch\neines Tages die Abschlussprüfung ablegen\nwerden...", italian="Ma suppongo che anche gli altri membri un\ngiorno passeranno l'esame...", spanish="Bueno, el resto de aprendices también\nsuperará el reto algún día..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="And that'll mean me too...", french="Et moi aussi...", german="Und das schließt mich mit ein.", italian="E questo significa...", spanish="Incluido yo..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="...[K]That does it!", french="... [K]Ça m'suffit!", german="...[K]Das tut es!", italian="...[K] che ce la farò anch'io!", spanish="¡Sí![K] ¡Eso es!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I'm going to do my level best to graduate too!\nYup yup yuppers!", french="J'vais faire en sorte d'augmenter mon niveau\npour obtenir mon diplôme, moi aussi! Sapristi,\npour sûr et pardi!", german="Ich werde alles daran setzen, ebenfalls die\nAbschlussprüfung zu bestehen! Jawollja!", italian="Devo migliorare il mio livello per passare\nanch'io l'esame! Per tutti gli ohibò!", spanish="¡Haré todo lo posible por superar el reto!\n¡Por supuesto!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It'll be my turn to shine!", french="Ce s'ra mon tour d'briller!", german="Es wird die Zeit kommen, in der ich glänzen\nkann!", italian="Verrà anche il mio momento!", spanish="¡Entonces, yo seré el protagonista!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 16 then
  -- @label_12 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 16: Graduation Exam?\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 16: Un examen à passer?\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 16: Abschlussprüfung?\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 16: Esame di diploma?\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]16. ¿El gran reto?\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Team [team:] has been picked to take the\nguild's graduation exam.", french="L'Equipe [team:] a été admise pour\npasser l'examen d'la Guilde.", german="Team [team:] wurde die Option\neingeräumt, die Gildenabschlussprüfung zu\nabsolvieren.", italian="Il Team [team:] è stato scelto per\nsostenere l'esame della Gilda.", spanish="El [CS:X]Equipo[CR] [team:] ha sido elegido para\nafrontar el reto del [CS:N]Pokégremio[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="They arrived after me. But they get to take\nthe exam before I can? That sorta rubs me\nthe wrong way...", french="Des Pokémon plus novices que moi qui passent\nl'examen avant moi? Ça m'caresse dans\nl'mauvais sens du poil...", german="Sie sind nach mir angekommen, dürfen aber die\nPrüfung vor mir ablegen? Das stößt mir\nirgendwie sauer auf.", italian="Sono qui da meno tempo di me, ma sosterranno\nl'esame prima? Questa cosa mi fa un po'\narrabbiare...", spanish="Llegaron más tarde que yo... ¿por qué van\na afrontarlo antes que yo? Eso me fastidia..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But it's tough to argue against the sort of\nsuccess that Team [team:] has had.", french="Mais difficile d'faire l'poids face aux\nexploits d'l'Equipe [team:].", german="Aber der Erfolg, den Team [team:] hatte,\nspricht wohl für sich.", italian="Ma è difficile negare che il Team [team:]\nabbia ottenuto innumerevoli successi.", spanish="La verdad es que es difícil negar que el\n[CS:X]Equipo[CR] [team:] se lo merece."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Besides, the others asked me (yup, me!) to\nhelp behind the scenes on the graduation exam!", french="En plus, les autres, ils m'ont demandé (à moi,\nouaip, à moi) d'les aider en douce à l'examen!", german="Davon abgesehen haben die anderen mich (ja,\nmich!) gebeten, bei den Vorbereitungen für die\nAbschlussprüfung hinter den Kulissen zu helfen.", italian="Inoltre, gli altri mi hanno chiesto (ohibò,\na me!) di aiutarli dietro le quinte per l'esame!", spanish="¡Además, los demás me han pedido (sí,\na mí) que les ayude a preparar el reto!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Who knows what they have in mind for me to\ndo, though. I'm always the last to know...", french="Mais qui sait ce qu'ils ont derrière la tête.\nJ'suis toujours l'dernier à être au courant,\nde toute façon...", german="Wer weiß schon, was sie für mich vorgesehen\nhaben. Ich bin immer der Letzte, der so etwas\nerfährt.", italian="Però non so cos'abbiano in mente per me.\nSono sempre l'ultimo a sapere le cose...", spanish="Aunque no tengo ni idea de qué quieren\nque haga... Para variar, siempre soy el\núltimo en enterarme de todo."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="This will be the first graduation exam I'll help\nout on. I wonder what I'm supposed to do?", french="Ce sera l'premier examen auquel je vais\nparticiper. J'me demande ce que j'suis\ncensé faire, au juste.", german="Dies wird die erste Abschlussprüfung sein, bei\nder ich aushelfen werde. Ich frage mich, was\nich wohl tun soll?", italian="Sarà il primo esame della Gilda che aiuto a\norganizzare. Cosa mi toccherà fare?", spanish="Será el primer reto en el que echo una\nmano. Uf, ¿qué tendré que hacer?"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 15 then
  -- @label_13 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 15: Don't Give Up!\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 15: Courage!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 15: Nicht aufgeben!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 15: Non mollate!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]15. ¡No os rindáis!\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Team [team:]! You all have to shine!", french="Equipe [team:]! Faut qu'vous\nréussissiez!", german="Team [team:]! Ihr müsst glänzen!", italian="Team [team:]! Voi due dovete dare il\nmeglio!", spanish="¡Vamos, [CS:X]Equipo[CR] [team:]!\n¡Lo vais a conseguir!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I surely can't begin to imagine a place called\nthe [CS:P]Hidden Land[CR], but...", french="Même dans mon imagination, j'arrive pas\nà m'représenter un endroit avec un nom\ncomme les [CS:P]Terres Illusoires[CR], mais...", german="Ich kann mir bestimmt immer noch keinen Ort\nwie das [CS:P]Verborgene Land[CR] vorstellen, aber...", italian="Non riesco nemmeno a immaginare un posto\nchiamato [CS:P]Terra Nascosta[CR], ma...", spanish="No puedo ni imaginarme cómo es la [CS:P]Tierra[CR]\n[CS:P]Oculta[CR], pero..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The two of them together... I'm mighty sure\nthey can stop the planet's paralysis. Yup yup!", french="J'suis quasi-sûr que la Paralysie d'la\nPlanète n'arrivera pas... avec ces deux-là\nsur le coup!", german="Die beiden können gemeinsam bestimmt die\nLähmung des Planeten aufhalten, da bin ich mir\nsicher. Jawollja!", italian="Voi due insieme... Sono pressoché certo che\npossiate evitare la paralisi del pianeta. Ohibò!", spanish="¡Estoy seguro de que podrán evitar la parálisis\ndel planeta!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I'll lend my support from Treasure Town!", french="J'les soutiendrai depuis Bourg-Trésor!", german="Ich werde meine Unterstützung von\nSchatzstadt aus anbieten!", italian="Vi sosterrò da Borgo Tesoro!", spanish="¡Yo les estaré apoyando desde Aldea Tesoro!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Go do it, [hero], [partner], [CS:N]Grovyle[CR],\nand [CS:N]Lapras[CR]!", french="Allez-y, [hero], [partner], [CS:N]Massko[CR]\net [CS:N]Lokhlass[CR]!", german="Erledigt das, [hero], [partner],\n[CS:N]Reptain[CR] und [CS:N]Lapras[CR]!", italian="Forza, [hero], [partner], [CS:N]Grovyle[CR],\ne [CS:N]Lapras[CR]!", spanish="¡Adelante, [hero], [partner],\n[CS:N]Grovyle[CR] y [CS:N]Lapras[CR]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="You all do what you can to win!", french="Faites d'votre mieux pour gagner!", german="Tut das, was nötig ist, um zu siegen!", italian="Impegnatevi al massimo per vincere!", spanish="¡Haced todo lo que podáis!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 14 then
  -- @label_14 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 14: Welcome Back!\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 14: Bienvenue au bercail!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 14: Willkommen zurück!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 14: Sono di nuovo qui!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]14. ¡De vuelta!\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Something happened that was half shocking\nand wholly happy! Yup yup!", french="Il s'est passé quelque chose d'un peu\nsurprenant et d'super réjouissant,\npour sûr!", german="Es ist etwas passiert, das einerseits\nschockierend war, andererseits aber Anlass zur\nFreude gab! Jawollja!", italian="È successa una cosa che per metà è scioccante\ne per l'altra metà mi rende davvero felice!\nOhibò!", spanish="¡Huy! ¡Hoy ha pasado algo totalmente increíble!\n¡Algo muy bueno!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It's all sorts of amazing, that's for sure![K]\nTeam [team:] came back!", french="C'est vraiment incroyable, ah oui, vraiment![K]\nL'Equipe [team:] est revenue!", german="Es ist jedenfalls absolut erstaunlich, so viel\nist mal sicher![K] Team [team:] ist\nzurückgekehrt!", italian="Poco ma sicuro, è assolutamente incredibile![K]\nIl Team [team:] è tornato!", spanish="¡No me lo podía creer![K] ¡El [CS:X]Equipo[CR] [team:]\nha vuelto!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Even more amazing is that they say they\nreturned...from the future!", french="Encore plus surprenant: les deux disent être\nd'retour... du futur!", german="Was noch viel erstaunlicher ist, ist die\nTatsache, dass sie behaupten, aus der Zukunft\nzurückgekehrt zu sein!", italian="Ma la cosa più incredibile è che dicono di\nessere di ritorno... dal futuro!", spanish="Y lo que es todavía más increíble es que\naseguran haber vuelto... ¡del futuro!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The story [partner] told was about as\namazing too... But more than anything...", french="L'histoire qu'a racontée [partner] était\nincroyable, elle aussi... Mais avant tout...", german="Die Geschichte, die [partner] erzählt hat,\nwar mindestens genauso unglaublich.", italian="Anche la storia che ha raccontato [partner]\nera incredibile... ma soprattutto...", spanish="[partner] nos contó sus fantásticas\naventuras, pero sobre todo..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I was overjoyed seeing the two of them back\nsafe where they belong, right here. Yup yup.", french="J'étais vachement heureux d'les revoir\nindemnes et avec nous, pour sûr.", german="Aber mehr als alles andere hat mich gefreut,\ndie beiden sicher wieder dort zu sehen, wo sie\nhingehören, nämlich hier. Jawollja.", italian="Mi ha riempito di gioia vedere che stanno bene\ne che sono di nuovo a casa. Ohibò.", spanish="Estoy muy contento de que estén bien y de\nque estén donde tienen que estar, que es\naquí."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Yup yup! I was some kind of happy... Sniffle...", french="Ah ça, j'étais bien content, pour sûr... snif...", german="Jawollja! Ich war ziemlich glücklich. Schnüff...", italian="Ohibò! Ero davvero felice... Sniff...", spanish="¡Huy! Estoy tan contento que se me saltan\nlas lágrimas..."})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 13 then
  -- @label_15 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 13: Very Sad...\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 13: Comme c'est triste...\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 13: Es ist so traurig...\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 13: È davvero triste...\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]13. Es muy triste...\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="An awful long time has gone by since that\nTeam [team:] disappeared...", french="Ça fait vachement longtemps maintenant que\nl'Equipe [team:] a disparu...", german="Eine schrecklich lange Zeit ist vergangen,\nseitdem Team [team:] verschwunden ist.", italian="È passato tanto tempo da quando il Team\n[team:] se n'è andato...", spanish="Hace ya bastante que el [CS:X]Equipo[CR] [team:]\ndesapareció."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I hope that [partner] and [hero] are\ndoing fine...", french="J'espère que [partner] et [hero]\ns'portent bien...", german="Ich hoffe, dass es [partner] und\n[hero] gut geht.", italian="Spero che [partner] e [hero] stiano\nbene...", spanish="Ojalá [partner] y [hero] estén bien..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="After we became buddies in the guild and all...", french="Après qu'on est devenus copains à la Guilde\net tout...", german="Wir haben uns in der Gilde richtig\nangefreundet.", italian="Dopo che siamo diventati amici qui alla Gilda...", spanish="Desde que nos hicimos amigos en el\n[CS:N]Pokégremio de Exploradores[CR]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I was counting on going exploring with them\nmore down the road...", french="J'comptais bien partir encore en exploration\navec ces deux-là par la suite...", german="Daher hatte ich darauf gezählt, in Zukunft\nmehr mit ihnen auf Erkundung gehen zu können.", italian="Contavo di andare a esplorare con loro più\nspesso...", spanish="Estaba esperando tener la oportunidad\nde explorar más veces a su lado."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oof... I miss them...", french="Pfiou... Leur absence me pèse...", german="Uuf, ich vermisse sie.", italian="Oh... mi mancano...", spanish="¡Ay!... Cómo echo de menos a ese equipo..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oof... I surely do miss them...", french="Pfiou... Leur absence me pèse vraiment...", german="Uuf, ich vermisse sie wirklich sehr.", italian="Oh... mi mancano davvero...", spanish="¡Ay!... Lo echo mucho de menos..."})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 12 then
  -- @label_16 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 12: Shocking News!\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 12: Sapristi de sapristi!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 12: Schlimme Neuigkeiten!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 12: Notizie scioccanti!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]12. ¡Menudas noticias!\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It's shocking, by golly!", french="Sapristi, c'est inouï!", german="Es ist schockierend, Menschenskind!", italian="È scioccante, ohibò!", spanish="¡Vaya sorpresa!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I don't rightly understand it...not totally...", french="J'pige pas vraiment... enfin, pas totalement...", german="Ich verstehe es nicht richtig... Nicht ganz\nzumindest...", italian="Non riesco a crederci... non del tutto...", spanish="Todavía no lo acabo de entender muy bien..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But Pokémon can come from the future?!\nIs that even possible? I don't rightly know.", french="Mais les Pokémon peuvent venir du futur?!\nC'est possible, ça? J'en sais rien du tout.", german="Pokémon können aus der Zukunft kommen?!?\nWie soll das möglich sein? Ich weiß nicht\nrecht.", italian="Ma i Pokémon possono venire dal futuro?\nÈ mai possibile? Non lo so davvero.", spanish="¡Pero al parecer hay Pokémon que pueden\nviajar en el tiempo! ¿Cómo es posible?\nLa verdad, no tengo ni idea."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But it's what the great [CS:N]Dusknoir[CR] claimed, so\nyou gotta reckon there's a grain of truth in it.", french="En tout cas, c'est ce que l'grand [CS:N]Noctunoir[CR] a\nraconté, alors j'imagine qu'il doit y avoir\nune part d'vérité là-dedans.", german="Aber das hat der große [CS:N]Zwirrfinst[CR] behauptet,\nalso muss man sich wohl eingestehen, dass ein\nFunken Wahrheit darin steckt.", italian="Ma è ciò che sostiene il grande [CS:N]Dusknoir[CR],\nquindi devo supporre che ci sia un pizzico di\nverità.", spanish="Aunque si lo dice el gran [CS:N]Dusknoir[CR]... será que\nes verdad."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="This is all so confusing that it makes my head\nhurt. But I reckon I'd best focus, yup yup...", french="C'est vachement pas clair, j'en ai mal au crâne.\nMais j'imagine qu'il vaut mieux que j'me\nconcentre, pour sûr...", german="Das alles ist so verwirrend, dass mir der Kopf\nweh tut. Aber ich denke, ich sollte mich am\nbesten konzentrieren, jawollja.", italian="È tutto così strano che mi fa venire mal di\ntesta. Ma suppongo sia meglio che mi concentri,\nohibò...", spanish="Es tan complicado que me duele la cabeza solo\nde pensarlo. Pero más vale que se me pase..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Because now's the time we need to help get out\nthe word about [CS:N]Azelf[CR] and his buddies. Yup yup!", french="Parce que c'est l'moment pour nous d'aider à\nrépandre la rumeur au sujet d'[CS:N]Créfadet[CR] et\nses potes. Ouaip!", german="Denn jetzt ist es an der Zeit, zu helfen, die\nNeuigkeiten von [CS:N]Tobutz[CR] und seinen Freunden\nzu verbreiten. Jawollja!", italian="... perché è ora che facciamo sapere a tutti\ndi [CS:N]Azelf[CR] e dei suoi amici. Ohibò!", spanish="Porque ahora tenemos que hablarle a todo el\nmundo de [CS:N]Azelf[CR] y sus compañeros. ¡Sí!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:N]Grovyle[CR]'s scheme can't continue!", french="On peut pas laisser faire [CS:N]Massko[CR]!", german="Der Plan von [CS:N]Reptain[CR] darf nicht aufgehen!", italian="Il piano di [CS:N]Grovyle[CR] dev'essere sventato!", spanish="¡Tenemos que pararle los pies a [CS:N]Grovyle[CR]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Yup yup! I have to spread that rumor on thick!", french="Sapristi! Faut que j'propage cette rumeur,\net pas qu'un peu!", german="Jawollja! Ich muss dieses Gerücht dick\nauftragen!", italian="Ohibò! Devo diffondere il più possibile la voce!", spanish="¡Debo difundir bien ese rumor! ¡Sí, señor!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 11 then
  -- @label_17 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 11: The Guild at Night\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 11: La Guilde de nuit\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 11: Die Gilde bei Nacht\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 11: La Gilda di notte\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]11. Un paseo nocturno\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Thanks to [CS:N]Croagunk[CR], I haven't been able to\nget a good night's sleep lately.", french="A cause de [CS:N]Cradopaud[CR], ça fait un sacré bail\nqu'j'ai pas eu une bonne nuit de sommeil.", german="Dank [CS:N]Glibunkel[CR] habe ich in letzter Zeit nicht\nmehr ruhig schlafen können.", italian="A causa di [CS:N]Croagunk[CR], ultimamente non riesco a\ndormire bene.", spanish="Llevo varias noches sin pegar ojo por culpa\nde [CS:N]Croagunk[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="There's nothing to do if you're awake at night,\nso I took a stroll through the guild. Yup yup!", french="On s'ennuie quand on arrive pas à trouver\nl'sommeil la nuit, alors j'ai fait tout l'tour\nd'la Guilde, pardi!", german="Da man nichts tun kann, wenn man nachts erst\neinmal wachliegt, habe ich einen Spaziergang\ndurch die Gilde gemacht. Jawollja!", italian="Non c'è niente da fare se sei sveglio di notte,\ncosì sono andato a fare una passeggiata per\nla Gilda. Ohibò!", spanish="Como no tengo nada que hacer en mi habitación,\nanoche decidí dar un paseo por el [CS:N]Pokégremio[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I glanced in [partner] and [hero]'s\nroom, but they were deep in sleep, by golly.", french="J'ai jeté un coup d'œil dans la chambre de\n[partner] et [hero], mais ça\ndormait à poings fermés là-dedans.", german="Ich habe in den Raum von [partner] und\n[hero] gesehen, aber sie haben tief und\nfest geschlafen, Menschenskind.", italian="Ho dato un'occhiata nella stanza di\n[partner] e [hero], ma dormivano\ndella grossa, ohibò.", spanish="Me asomé al dormitorio de [partner] y\n[hero], pero dormían como troncos."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I reckon they must be exhausted from their\ndaily training, yup yup.", french="Ça doit être l'épuisement d'leur\nentraînement quotidien, pour sûr.", german="Ich denke mal, ihr tägliches Training wird sie\nziemlich erschöpft haben, jawollja.", italian="L'allenamento quotidiano deve essere\nveramente faticoso anche per loro, ohibò.", spanish="Seguro que no se pueden mover después\nde tanto entrenamiento."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I didn't peek into [CS:N]Chimecho[CR] and [CS:N]Sunflora[CR]'s\nroom. That'd be downright rude. Yup yup.", french="Par contre, j'ai pas regardé dans la chambre\nd'[CS:N]Eoko[CR] et [CS:N]Héliatronc[CR]. Ça serait carrément\ngrossier, pour sûr.", german="Ich habe nicht in den Raum von [CS:N]Palimpalim[CR] und\n[CS:N]Sonnflora[CR] reingeschaut. Das wäre auch\nziemlich unverschämt gewesen. Jawollja.", italian="Non ho guardato nella stanza di [CS:N]Chimecho[CR] e\n[CS:N]Sunflora[CR]. Sarebbe stato molto scortese.\nOhibò.", spanish="No se me pasó por la cabeza asomarme al\ndormitorio de [CS:N]Chimecho[CR] y [CS:N]Sunflora[CR].\nHabría sido de muy mala educación."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Huh, diary? You wanted me to peek?", french="Qu'est-ce que tu dis, journal? T'aurais bien\nvoulu que j'regarde?", german="Wie, mein Tagebuch? Ich hätte reinschauen\nsollen?", italian="Eh, diario? Vuoi che vada a dare un'occhiata?", spanish="¿Qué opinas, diario?\n¿Tendría que haberlo hecho?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I surely can't do that. It's just not done.[K]\nWho could live that down?", french="Ah, non j'peux pas. Ça s'fait pas, voyons.[K]\nQui pourrait encore s'regarder dans la glace,\naprès ça?", german="Das kann ich auf keinen Fall tun. Das wird\neinfach nicht gemacht.[K] Wer könnte das denn\nungeschehen machen?", italian="Non lo posso certo fare. Non si fa.[K]\nNon me lo perdonerebbero!", spanish="No sería capaz. Esas cosas no se hacen.[K]\nLuego me remordería la conciencia..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="And sneaking into the Guildmaster's room was\ntoo scary. So I gave that a pass and kept\nnosing around elsewhere. Yup yup.", french="Quant à s'glisser dans la chambre du Maître\nde la Guilde, c'était trop risqué. Alors, au lieu\nd'ça, j'ai continué à faire mon p'tit tour, pardi.", german="Ins Zimmer des Gildenmeisters zu schleichen,\nwar mir zu schaurig. Also hab ich es gelassen\nund anderswo weitergeschnüffelt. Jawollja.", italian="Ohibò, e sbirciare nella camera del Capitano mi\nfaceva troppa paura. Quindi sono andato oltre,\na curiosare da un'altra parte.", spanish="Y, como me daba mucho miedo asomarme\na la Cámara del Gran Bluff, pasé de largo\ny seguí con mi paseo nocturno."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Now, that [CS:N]Chatot[CR]! By golly, that one gave me\nquite the start!", french="Et c'est là que j'suis tombé sur [CS:N]Pijako[CR], qui\nm'a flanqué une frousse d'enfer, pour sûr!", german="Dieser [CS:N]Plaudagei[CR] hingegen hat echt den Vogel\nabgeschossen!", italian="Sai, quel [CS:N]Chatot[CR]! Ohibò, che tipo strano!", spanish="¡Entonces [CS:N]Chatot[CR] me dio un susto de muerte!\n¡Uf, menudo susto me dio!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="So, diary, where'd you reckon that [CS:N]Chatot[CR]\nsleeps at night?", french="Alors devine, journal, il pionce où [CS:N]Pijako[CR],\nla nuit?", german="Also, mein liebes Tagebuch, was glaubst du, wo\n[CS:N]Plaudagei[CR] nachts schläft?", italian="Dunque, diario, dove pensi che dorma quel\n[CS:N]Chatot[CR] di notte?", spanish="Y bien, diario... ¿Dónde crees que duerme\n[CS:N]Chatot[CR] por la noche?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Well, surprise, surprise![K] He sleeps on the top\nrung of the guild's entry ladder!", french="Surprise![K] Il pionce sur la dernière marche\nd'l'escalier qui mène à la Guilde!", german="Nun, Überraschung, Überraschung![K] Er schläft\nauf der obersten Sprosse der Leiter am\nGildeneingang!", italian="Beh, sorpresa, sorpresa![K] Dorme sul primo\npiolo della scala d'ingresso della Gilda!", spanish="¡Te va a sorprender![K] ¡Duerme en el último\npeldaño de las escaleras que hay a la entrada\ndel [CS:N]Pokégremio de Exploradores[CR]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="When I crept nearby, he thought I was trying\nto run away, by golly...", french="Quand j'suis passé près de lui à pas d'castor,\nil a cru que j'voulais m'enfuir, sapristi...", german="Als ich vorbeigeschlichen bin, dachte er\noffenbar, ich würde versuchen zu fliehen,\nMenschenskind.", italian="Quando gli sono arrivato vicino, pensava\nstessi cercando di uscire, ohibò...", spanish="Huy, cuando me acerqué por ahí pensó que\nestaba intentando huir... ¡Menuda faena!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="So he wildly attacked me![K] I'm still sore all\nover from that, by gosh!", french="Du coup, il s'est jeté sur moi comme un\nsauvage![K] Sapristi, j'suis encore tout couvert\nde bleus!", german="Daher hat er mich energisch angegriffen![K]\nMir tut immer noch alles weh deshalb,\nzum Donnerwetter!", italian="Così mi ha attaccato selvaggiamente![K]\nHo ancora male dappertutto, ohibò!", spanish="¡Se lanzó como un loco a atacarme![K] ¡Córcholis!\n¡Todavía tengo cardenales por su culpa!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="P.S. [CS:P]Crystal Cave[CR] sure lived up to its name,\nbeing full of crystals and all.", french="P.-S. La [CS:P]Caverne Cristal[CR] porte bien son nom,\nparce que c'est une caverne avec plein de\ncristaux.", german="P.S.: Die [CS:P]Kristallhöhle[CR] wurde ihrem Namen\nwirklich gerecht mit all ihren Kristallen und\nso.", italian="P.S. [CS:P]Grotta di Cristallo[CR] è un nome che le\nsi addice, dato che al suo interno ci sono\ncristalli dappertutto.", spanish="P. D.: El nombre de [CS:P]Cueva Cristal[CR] es muy\nacertado; está llena de cristales por todos\nsitios."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It surely was a pretty place! Yup yup.", french="Un bien bel endroit, pour sûr.", german="Das war ein wunderschöner Ort! Jawollja.", italian="Era proprio un bel posto! Ohibò.", spanish="Era un lugar muy hermoso. ¡Sí, señor!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It was so pretty, I couldn't help...[K]helping\nmyself to a crystal!", french="C'était si beau que j'ai pas pu m'en\nempêcher...[K] j'ai pris un cristal!", german="Er war so schön, dass ich nicht widerstehen\nkonnte...[K] Ich habe einen Kristall mitgenommen!", italian="Era così bello che non ho potuto fare a\nmeno di...[K] prendermi un cristallo!", spanish="Era una cueva tan bonita que no me pude\nresistir...[K] ¡y me llevé un cristal!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It's my own precious treasure! Yup yup!", french="C'est mon petit trésor, rien qu'à moi! Ouaip!", german="Er ist mein persönlicher und wertvoller\nSchatz! Jawollja!", italian="È il mio prezioso tesoro! Ohibò!", spanish="¡Por fin tengo un tesoro solo para mí!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But when everyone found out about it... All I\ngot was a bunch of grief... Sigh...", french="Mais bon, tout l'monde l'a su... Du coup, ils m'en\nont tous voulu pour ça... Shhh...", german="Aber als es alle herausgefunden haben, hat es\nmir nur einen Haufen Kummer eingebracht.\nSeufz...", italian="Ma quando gli altri l'hanno scoperto... Non è\nstato per niente bello... Sigh...", spanish="Pero cuando los demás se enteraron...\n¡Uf! Me quería morir de vergüenza..."})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 10 then
  -- @label_18 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 10: No Sleep!\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 10: Pas moyen de dormir!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 10: Kein Schlaf!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 10: Notti insonni!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]10. Sin pegar ojo...\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oof... I'm feeling foggy from not getting my\nfair share of sleep.", french="Pfiou... J'suis dans le brouillard parce que\nj'ai pas eu mon quota d'sommeil.", german="Uuf... Ich fühle mich benebelt, weil ich nicht\nausreichend Schlaf bekommen habe.", italian="Puff... Senza la mia bella dose di sonno mi\nsento un po' annebbiato.", spanish="Uf... Estoy hecho polvo porque no he dormido\nlo suficiente."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I share my room with [CS:N]Loudred[CR] and [CS:N]Corphish[CR],\nbut...", french="J'partage mon dortoir avec [CS:N]Ramboum[CR] et\n[CS:N]Ecrapince[CR], mais bon...", german="Ich teile mein Zimmer mit [CS:N]Krakeelo[CR] und\n[CS:N]Krebscorps[CR], aber...", italian="Divido la mia stanza con [CS:N]Loudred[CR] e [CS:N]Corphish[CR],\nma...", spanish="Comparto dormitorio con [CS:N]Loudred[CR] y [CS:N]Corphish[CR],\npero..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Lately, [CS:N]Croagunk[CR]'s taken to slipping into our\nroom for some shut-eye every so often.", french="Ces derniers temps, [CS:N]Cradopaud[CR] a pris la drôle\nd'habitude de s'glisser dans notre chambre pour\npiquer un roupillon, de temps en temps.", german="In letzter Zeit schleicht sich [CS:N]Glibunkel[CR]\ngelegentlich für ein Nickerchen in unser\nZimmer.", italian="Ultimamente, [CS:N]Croagunk[CR] ha cominciato a venire\nsempre più spesso nella nostra stanza a fare\ndei pisolini.", spanish="[CS:N]Croagunk[CR] se ha acostumbrado a meterse en\nnuestro dormitorio de vez en cuando para\necharse una cabezada."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Well, that [CS:N]Croagunk[CR], he usually beds down by\nthat Swap Cauldron of his...[K] But lately he's\ntaken to sleeping here...", french="D'habitude, [CS:N]Cradopaud[CR], il dort près de son\nChaudron-Troc...[K] Mais récemment, il s'est mis\nà dormir ici...", german="Nun, normalerweise haut sich [CS:N]Glibunkel[CR] neben\nseinem Tauschkessel aufs Ohr,[K] aber in letzter\nZeit kommt er zum Schlafen hierher.", italian="Insomma, quel [CS:N]Croagunk[CR] di solito si riposa\nvicino al suo Pentolone dei Cambi...[K] Ma negli\nultimi tempi ha preso a dormire qui...", spanish="El caso es que [CS:N]Croagunk[CR] suele dormir dentro\ndel Caldero de Trueque ese que tiene...[K] Pero\núltimamente ha empezado a dormir aquí..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Just the other day, I was surprised to find\n[CS:N]Croagunk[CR] sleeping nearby, by golly...", french="L'aut' jour encore, j'l'ai trouvé endormi à\ncôté de moi, j'ai eu une de ces frousses...", german="Gerade neulich erst habe ich [CS:N]Glibunkel[CR]\nüberraschenderweise in der Nähe schlafend\ngefunden, Menschenskind.", italian="Giusto l'altro giorno, mi sono stupito di\ntrovare [CS:N]Croagunk[CR] addormentato vicino a me,\nohibò...", spanish="El otro día, nada más despertarme, lo primero\nque vi fue a [CS:N]Croagunk[CR] durmiendo tan pancho\nahí al lado..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="And then he murmured, \"Meh-heh-heh! Morning\nthere, [CS:N]Bidoof[CR]!\" I mean, I don't want my day to\nstart that way!", french="Et alors il a murmuré, \"Mwé hé hé... Bonjour,\nsieur [CS:N]Keunotor[CR]!\" Voilà quoi, j'veux pas\nque mes journées commencent comme ça!", german="Und dann murmelte er [F:S2]Mehehe! Morgen auch,\n[CS:N]Bidiza[CR]![F:E2]. Ehrlich, ich möchte nicht, dass mein\nTag so beginnt!", italian="E poi mormorava: \"Eh eh eh! Buongiorno,\n[CS:N]Bidoof[CR]!\". Voglio dire, non mi piace cominciare\ncosì la giornata!", spanish="Y, además, va y me dice: \"¡Je, je, je! ¡Buenos\ndías, [CS:N]Bidoof[CR]!\" ¡Y claro, así no hay manera de\nempezar el día con buen pie!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="That surely put a scare in me. Yup yup! Now I\ncan't sleep because that [CS:N]Croagunk[CR] might\nwant to hang out again... Oof...", french="Comme j'ai eu la trouille, sapristi! Et\nmaintenant, j'peux plus fermer l'œil de peur\nque [CS:N]Cradopaud[CR] revienne... Pfiou...", german="Das hat mir echt einen Schrecken versetzt.\nJawollja! Jetzt kann ich nicht schlafen, weil\ndieser [CS:N]Glibunkel[CR] wieder da sein könnte. Uuf...", italian="Mi spaventa. Ohibò! Ora non riesco a dormire\nperché quel [CS:N]Croagunk[CR] potrebbe voler tornare...\nPuff...", spanish="Me asustó, ¡sí, señor! Ahora no puedo dormir\nporque no hago nada más que pensar en que,\ncuando me despierte, [CS:N]Croagunk[CR] puede estar ahí."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="P.S. The great [CS:N]Dusknoir[CR] is sure mighty wise.", french="P.-S. Le grand [CS:N]Noctunoir[CR], c'est un vrai sage,\npour sûr.", german="P.S.: Der große [CS:N]Zwirrfinst[CR] ist ganz bestimmt\nmächtig weise.", italian="P.S. Di sicuro il grande [CS:N]Dusknoir[CR] è molto\nsaggio.", spanish="P. D.: El gran [CS:N]Dusknoir[CR] es increíble."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Not only that, he shows respect to everyone.\nEven me! By golly, you have to respect\nsomeone like that back!", french="En plus, il est respectueux envers tout le\nmonde! Même moi! Sapristi, on doit l'respect\nà un Pokémon d'sa trempe!", german="Nicht nur, dass er jedem Respekt entgegen-\nbringt. Sogar mir! Menschenskind, so\njemanden muss man einfach auch respektieren!", italian="Non solo, è anche rispettoso verso tutti gli\naltri. Anche con me! Ohibò, bisogna rispettarlo\na sua volta, uno così!", spanish="Además, trata a todo el mundo con respeto.\n¡Incluso a mí! Caramba, un Pokémon así\nmerece toda mi admiración."})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 9 then
  -- @label_19 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 9: Awesome Expedition\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 9: Une expédition super!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 9: Eine tolle Expedition\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 9: Una spedizione stupenda\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]9. Una gran expedición\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="We're back home! Back from our expedition at\nlast! Yup yup!", french="On est rentrés! Enfin rentrés d'l'expédition,\nsapristi!", german="Wir sind wieder daheim! Endlich zurück von\nunserer Expedition! Jawollja!", italian="Siamo tornati a casa! Alla fine siamo tornati\ndalla nostra spedizione! Ohibò!", spanish="¡Por fin estamos de vuelta de la expedición!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It was my first expedition. So, yup yup, I was\nscared something awful. But here I am, back\nhome at the guild, yup yup.", french="C'était ma première expédition. Alors, j'avais\nles j'tons, pour sûr. Mais me v'là de retour\nà la Guilde, ouaip.", german="Das war meine erste Expedition. Jawollja, ich\nhatte ziemlich große Angst. Aber nun bin ich\nwieder heil in der Gilde angekommen, jawollja.", italian="È stata la mia prima spedizione. Così, ohibò,\navevo paura fosse qualcosa di terribile. Ma\neccomi qua, tornato alla Gilda, ohibò.", spanish="Ha sido mi primera excursión de este tipo y\nestaba muy asustado, pero aquí estoy, sano\ny salvo."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The expedition sure was inspiring. We got to\nsee pretty [CS:P]Fogbound Lake[CR] and other stuff!", french="L'expédition, elle était captivante. On a vu\nl'splendide [CS:P]Lac des Brumes[CR] et plein d'autres\ntrucs!", german="Die Expedition hat mich ziemlich begeistert.\nWir haben den [CS:P]Nebelsee[CR] und andere Dinge zu\nGesicht bekommen!", italian="La spedizione è stata molto interessante.\nAbbiamo visto il [CS:P]Lago Foschia[CR] e altre belle\ncose!", spanish="La expedición ha sido increíble. ¡Hasta hemos\nvisto el precioso [CS:P]Lago Velado[CR] y un montón\nde cosas más!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But what sticks most in my mind, by golly...", french="Mais c'qui m'a l'plus marqué, sapristi...", german="Aber woran ich mich immer noch am besten\nerinnere, Menschenskind...", italian="Ma quello che mi è rimasto più impresso in\nmente, ohibò...", spanish="Sin embargo, no es eso lo que más recuerdo..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="was reaching base camp with [hero]'s\nteam. Yup yup.", french="... c'est quand on a rejoint l'camp de base\navec l'équipe de [hero]. Ouaip.", german="Das ist der Zeitpunkt, an dem ich mit dem\nTeam von [hero] das Basislager\nerreicht habe. Jawollja.", italian="... è stato il percorso per raggiungere il Campo\nBase con la squadra di [hero]. Ohibò.", spanish="Lo que más me emocionó y recordaré siempre\nfue llegar al campamento base con el equipo\nde [hero]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It was the first expedition for all three of\nus. So it wasn't easy, no sirree.", french="C'était not' première expédition à\ntous les trois. Alors c'était pas d'la tarte,\npour sûr.", german="Es war für uns alle drei die erste Expedition\nund somit nicht einfach, nein, wirklich nicht!", italian="Era la prima spedizione per tutti e tre. Dunque\nnon è stato facile, nossignore.", spanish="Ha sido la primera expedición para los tres y\nno ha sido nada fácil. ¡No, señor!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I ended up causing a lot of trouble for\nTeam [team:], but...", french="Au final, j'leur ai causé plein d'ennuis à\nl'Equipe [team:], mais bon...", german="Ich habe Team [team:] viele\nUnannehmlichkeiten verursacht, aber...", italian="Alla fine ho causato un sacco di problemi al\nTeam [team:], ma...", spanish="Sé que he sido una carga para el [CS:X]Equipo[CR]\n[team:]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="We helped each other the best we could,\nby golly.", french="On s'est entraidés du mieux qu'on pouvait,\npardi.", german="Wir haben einander so gut es ging geholfen,\nDonnerwetter.", italian="... abbiamo cercato di dare il meglio per\naiutarci a vicenda, ohibò.", spanish="Pero lo hemos hecho lo mejor que hemos\npodido."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="And we finally made it to base camp. I swear,\nthat had to be one of the happiest times in my\nlife, by golly.", french="Et on a fini par arriver au camp d'base.\nJ'le jure, ça a été un des moments les plus\nheureux d'ma vie, pour sûr.", german="Schließlich gelangten wir ins Basislager. Ich\nschwöre, das war einer der glücklichsten\nMomente meines Lebens, Menschenskind.", italian="E alla fine siamo arrivati al Campo Base.\nGiuro, questo rimarrà uno dei giorni più felici\ndella mia vita, ohibò.", spanish="Al final alcanzamos el campamento base.\nCompletar esa misión ha sido uno de los\nmomentos más felices de mi vida."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oof... If it wasn't for Team [team:], this\nexpedition wouldn't have been quite so fun...", french="Pfiou... Sans l'Equipe [team:], cette\nexpédition aurait pas été aussi rigolote...", german="Uuf... Wenn Team [team:] nicht gewesen\nwäre, wäre die Expedition nicht annähernd so\nlustig gewesen.", italian="Puff... Se non fosse stato per il Team\n[team:], questa spedizione non sarebbe\nstata così divertente...", spanish="Uf... Aunque si no llega a ser por el [CS:X]Equipo[CR]\n[team:], no habría sido tan divertido..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I surely have to thank that [hero] and\n[partner]!", french="Faudra que j'remercie [hero] et\n[partner]!", german="Dafür muss ich [hero] und\n[partner] danken!", italian="Devo tutto a [hero] e [partner]!", spanish="¡Menos mal que [hero] y [partner]\nvinieron conmigo!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 8 then
  -- @label_20 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 8: Camaraderie\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 8: Camaraderie\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 8: Kameradschaft\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 8: Solidarietà\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]8. Camaradería\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="There was sort of a scene today!", french="Il y a eu un d'ces cirques aujourd'hui!", german="Heute gab es eine Art Szene!", italian="Ho assistito a una scena, oggi!", spanish="¡Menuda escenita se ha montado hoy!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Those Team [team:] members were\ndenied dinner tonight. They went to bed hungry.", french="L'Equipe [team:] a été privée de dîner\nce soir. Au lit l'ventre vide, les pauvres!", german="Den Mitgliedern von Team [team:] wurde\nheute die Essensausgabe verwehrt. Sie mussten\nhungrig zu Bett gehen.", italian="Stasera non è stata data la cena a quelli del\nTeam [team:]. Sono andati a dormire\naffamati.", spanish="El [CS:X]Equipo[CR] [team:] se ha ido hoy a la\ncama sin cenar."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I reckon they goofed up something bad to be\npunished that way. Yup yup!", french="Ces deux-là ont dû gaffer sévère pour\ns'faire punir comme ça, pour sûr!", german="Sie haben bestimmt irgendetwas böse\nvermasselt, um eine derart harte Strafe zu\nkassieren. Jawollja!", italian="Suppongo che l'abbiano fatta grossa per\nmeritarsi una punizione del genere. Ohibò!", spanish="Vaya, si les han castigado así, seguro que\nserá por algo. ¡Sí, señor!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Still...going without dinner's a rotten thing.", french="Mais quand même... aller au lit sans dîner,\nc'est dur dur.", german="Wie dem auch sei, kein Essen zu bekommen, ist\neine echt miese Sache.", italian="Comunque... Andare a letto senza cena è una\ncosa tremenda.", spanish="Pero aun así, quedarse sin cenar es una\nfaena muy grande."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I know that I surely can't last a night without\na full belly. Yup yup!", french="Moi, j'sais que j'peux pas tenir la nuit si\nj'ai pas l'ventre plein, saperlipopette!", german="Ich weiß, dass ich keine Nacht ohne vollen\nBauch durchhalten würde. Jawollja!", italian="So che sicuramente non resisterei una notte\nsenza la pancia piena. Ohibò!", spanish="Yo sé que no aguantaría ni una sola noche sin\ntener la tripa llena, eso seguro."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="So I decided that I'd save a bit of my dinner so\nI could share it with them.", french="Alors j'me suis dit qu'j'allais leur mettre un\npetit quequ'chose de côté.", german="Also habe ich entschieden, einen Teil meiner\nEssensportion für sie aufzuheben, um das\nEssen mit ihnen zu teilen.", italian="Così ho deciso di mettere da parte un po' della\nmia cena per dividerla con loro.", spanish="Así que decidí echarles una mano y les guardé\nalgo de mi cena."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Turns out that everyone had the same idea!", french="Et au final, tout l'monde a eu la même idée!", german="Es stellte sich heraus, dass alle die gleiche\nIdee hatten!", italian="Alla fine hanno avuto tutti la stessa idea!", spanish="¡Resultó que todos los demás habían tenido\nla misma idea!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="We all saved a bit of our dinners, it seems.", french="On leur a tous gardé un peu d'not' dîner.", german="Offenbar haben wir alle einen Teil unserer\nEssensration aufgehoben.", italian="Sembra che ognuno di noi abbia tenuto da parte\nqualcosa per loro.", spanish="Todos les guardamos un poco."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="So we all met up that night, and we\ntalked it over. Yup yup.", french="On s'est retrouvés cette nuit-là et on a\nbavardé. Ouaip ouaip!", german="Wir haben uns also alle in jener Nacht\ngetroffen und darüber gesprochen. Jawollja.", italian="Così stasera ci siamo incontrati tutti,\ne ne abbiamo discusso. Ohibò.", spanish="Así que nos juntamos por la noche para decidir\nqué íbamos a hacer."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="And we decided we'll share our food with\nTeam [team:].", french="Et on s'est mis d'accord pour partager not'\ncasse-croûte avec l'Equipe [team:].", german="Und wir haben entschieden, unser Essen mit\nTeam [team:] zu teilen.", italian="E abbiamo deciso di dividere il nostro cibo\ncon il Team [team:].", spanish="Y llegamos a la conclusión de que lo mejor\nera compartir nuestra comida con el [CS:X]Equipo[CR]\n[team:]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="We reckon we'll sneak them the food tomorrow\nmorning after the morning briefing. Yup yup!", french="On compte essayer d'leur faire passer la\nbouffe en douce demain matin après la\nréunion. Ouaip!", german="Morgen in der Frühe, nach der morgendlichen\nUnterweisung, werden wir ihnen das Essen\nzukommen lassen. Jawollja!", italian="Abbiamo pensato di darglielo di nascosto\ndomani dopo le informazioni della mattina.\nOhibò!", spanish="¡Sí! Les llevaremos la comida sin que nadie\nse entere mañana por la mañana, después\nde la reunión diaria."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The older apprentices are usually really strict,\nbut it turns out they're awfully nice at heart...", french="Les apprentis les plus anciens sont très stricts\nen général, mais au fond, ils ont du cœur...", german="Die älteren Lehrlinge sind normalerweise recht\nstreng, aber wie sich herausgestellt hat, haben\nsie ein richtig gutes Herz.", italian="I compagni più vecchi solitamente sono molto\nligi alle regole, ma anche loro si sono rivelati\ndi buon cuore...", spanish="Los veteranos suelen ser siempre muy\nestrictos, pero resulta que en el fondo\ntienen buen corazón..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oof... This is making me all emotional, by golly.", french="Pfiou... Sapristi, c'est qu'j'en ai la larme\nà l'œil, moi.", german="Uuf... Das macht mich ganz emotional,\nMenschenskind.", italian="Sniff... Mi sto commuovendo, ohibò.", spanish="Si es que hasta se me saltan las lágrimas\nal recordarlo..."})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 7 then
  -- @label_21 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 7: Expedition!\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 7: Expédition!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 7: Expedition!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 7: Spedizione!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]7. Expedición\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The guild's going on an expedition soon!", french="La Guilde part bientôt en expédition!", german="Die Gilde begibt sich demnächst auf eine\nExpedition!", italian="Presto la Gilda partirà per una spedizione!", spanish="¡Se va a organizar una expedición del\n[CS:N]Pokégremio[CR] muy pronto!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It'll be my first expedition...[K] That's sure got\nmy heart racing, by golly.", french="Ce sera ma première expédition...[K] Rien que\nd'y penser, j'en ai l'cœur qui bat la chamade,\npardi.", german="Das wird meine erste Expedition.[K] Mein Herz\nrast schon, Menschenskind.", italian="Sarà la mia prima spedizione...[K] Ho il cuore in\ngola, ohibò.", spanish="Caramba, será mi primera expedición...[K]\nSeguro que no se me olvida nunca."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But will they think about choosing me?", french="Mais j'me demande s'ils penseront à moi pour\nfaire partie d'l'expédition!", german="Aber werden sie überhaupt in Erwägung ziehen,\nmich mitzunehmen?", italian="Ma mi sceglieranno?", spanish="¿Me seleccionarán para ir?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Compared to everyone else, I'm slow and\nklutzy...", french="Comparé aux autres, moi j'suis tout lent\net maladroit...", german="Verglichen mit den anderen bin ich langsam und\nschwerfällig.", italian="In confronto agli altri, sono così lento e\ngoffo...", spanish="Soy un poco lento y torpe..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Even Team [team:]'s rookies are getting\nbetter and better...", french="Même les novices de l'Equipe [team:]\ns'améliorent d'jour en jour...", german="Sogar die Neulinge von Team [team:]\nwerden besser und besser.", italian="Perfino le reclute del Team [team:]\nstanno andando meglio di me...", spanish="Hasta el novatillo [CS:X]Equipo[CR] [team:] es\ncada día mejor."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But I'm surely not giving up, by golly!", french="Mais j'abandonnerai pas, ah ça non, sapristi!", german="Aber ich gebe ganz gewiss nicht auf,\nMenschenskind!", italian="Ma non mollerò, ohibò!", spanish="Pero no me voy a rendir, ¡eso ni pensarlo!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I'll do the best I can to get picked for the\nexpedition, yup yup!", french="J'ferai d'mon mieux pour être choisi,\npour sûr!", german="Ich werde mein Bestes tun, um für die\nExpedition ausgewählt zu werden, jawollja!", italian="Darò tutto quello che posso e verrò scelto\nper la spedizione, ohibò!", spanish="Sí, voy a explorar lo mejor que pueda para\nque me seleccionen."})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 6 then
  -- @label_22 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 6: Gas Attack!\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 6: Le gaz nauséabond!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 6: Stinkbombe!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 6: Che puzza!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]6. Bomba fétida\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Something was sure a surprise the other day!", french="J'ai eu une sacrée surprise l'aut' jour!", german="Neulich geschah echt etwas Überraschendes!", italian="Sono davvero rimasto sorpreso l'altro giorno!", spanish="¡El otro día pasó algo un poco raro!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I was checking out the Outlaw Notice Board,\nwhen it suddenly stank like rotten sulfur!", french="J'consultais les Avis de Recherche quand\ntout d'un coup, ça s'est mis à puer l'fromage\npourri!", german="Als ich das Ganoven-Infobrett studierte, lag\nplötzlich ein mieser Schwefelgeruch in der\nLuft!", italian="Stavo controllando la Bacheca dei ricercati,\nquando all'improvviso sento una schifosa puzza\ndi zolfo!", spanish="Estaba leyendo el Tablón \"Se Busca\" cuando,\nde repente, ¡empezó a oler a huevo podrido!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But then everyone turned and looked at me like\nI had something to do with it, by golly!", french="Sapristi, tout l'monde s'est tourné vers moi\net m'a regardé comme si qu'c'était d'ma\nfaute!", german="Aber dann drehten sich alle zu mir um, als ob\nich etwas damit zu tun gehabt hätte,\nMenschenskind!", italian="Ma poi si sono girati tutti verso di me, e mi\nguardavano come se fossi stato io, ohibò!", spanish="Y, para colmo, todos se volvieron... ¡y me\nmiraron como si fuera culpa mía!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I swear! I really had nothing to do with that\nawful stink, by golly!", french="Mais, j'leur ai dit, c'était pas moi, c'te\npuanteur, sapristi!", german="Ich schwöre es! Ich hatte wirklich nichts mit\ndiesem schrecklichen Gestank zu tun,\nMenschenskind!", italian="Lo giuro! Non avevo nulla a che fare con quella\npuzza terribile, ohibò!", spanish="¡Juro que no tuve nada que ver con esa peste!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I know I've been guilty in the past, like that\ntime in my room once...", french="J'sais qu'une ou deux fois, c'était vraiment\nd'ma faute, comme l'autre fois dans mon\ndortoir...", german="Ich weiß, dass ich dann und wann in der\nVergangenheit schuld gewesen bin, so wie das\neine Mal in meinem Zimmer...", italian="So che qualche volta in passato è stata colpa\nmia, tipo una volta nella mia stanza...", spanish="Ya sé que ha sido culpa mía en alguna que otra\nocasión, como aquel día en mi dormitorio..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="then twice in the Mess Hall, and once in\nthe Guildmaster's quarters, but...", french="... Ah ouais, et puis deux fois au mess, et\naussi une fois dans la chambre du Maître\nd'la Guilde, mais bon...", german="Und auch die beiden Male in der Kantine, das\neine Mal in der Unterkunft des Gildenmeisters\nund...", italian="... poi altre due nella Sala mensa, una nella\nStanza del Capitano, ma...", spanish="Y aquellas dos veces en el comedor, ¡ah!, y\naquella vez en la Cámara del Gran Bluff..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="By golly, I surely am not guilty of anything\nthis time, I swear!", french="Sapristi, c'te fois-ci, j'y étais pour rien,\nils veulent jamais m'croire!", german="Menschenskind, dieses Mal bin ich aber wirklich\nunschuldig, das schwöre ich!", italian="Ohibò, questa volta non c'entro, lo giuro!", spanish="Pero caramba, no tuve nada que ver esta vez,\n¡lo juro!"})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  -- @label_23 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 5: Moves Are Awesome!\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 5: Vive les capacités!\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 5: Attacken sind klasse!\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 5: Evviva le mosse!\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]5. ¡Qué movimientos!\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Well, seems there's another thing I was\nclueless about!", french="Eh ben, on dirait qu'il y a encore autre chose\nque j'savais pas du tout!", german="Nun, offenbar gab es noch eine weitere Sache,\nvon der ich keine Ahnung hatte!", italian="Bene, sembra ci sia un'altra cosa di cui ero\nall'oscuro!", spanish="¡Parece que había otra cosilla sobre\nla que no tenía ni la más remota idea!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="When you use moves instead of regular attacks\nto defeat an enemy, you get more Exp. Points.\nDid everyone know that but me?", french="Quand on utilise des capacités au lieu\nd'l'attaque ordinaire, on gagne plus de\npoints Exp.", german="Wenn man Attacken anstatt regulärer Angriffe\nverwendet, um Gegner zu besiegen, bekommt\nman mehr EP. Wussten das alle außer mir?", italian="Quando usi le mosse anziché gli attacchi\nregolari per sconfiggere un nemico, guadagni\npiù Punti Esperienza. Solo io non lo sapevo?", spanish="Si usas movimientos en lugar de ataques\nconvencionales para derrotar a un enemigo,\nconsigues más Puntos de Experiencia."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I didn't know that! But there's more!", french="Ça, je l'savais pas! Mais c'est pas tout!", german="Ich wusste das nicht! Aber es geht noch\nweiter!", italian="Non lo sapevo! E c'è di più!", spanish="No tenía ni idea... ¡Pero eso no es todo!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="You need to hit the foe only once with a move.", french="Ça suffit d'frapper l'ennemi avec une\ncapacité une seule fois.", german="Man muss den Gegner nur ein einziges Mal mit\neiner Attacke treffen.", italian="Puoi colpire l'avversario anche solo una\nvolta con la mossa.", spanish="Solo hace falta alcanzar al rival una vez\ncon el movimiento."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Other than that one move, you can strike it\nwith regular attacks. And you still get the\nboosted Exp. Points. How about that, by golly?", french="Après ça, on peut utiliser son attaque\nordinaire, on gagne quand même plus de points\nExp. Ça vaut l'coup, moi j'dis!", german="Außer der einen Attacke kann man ihn mit\nregulären Angriffen traktieren und trotzdem\nerhöhte EP bekommen. Was haltet ihr davon?", italian="E dopo aver usato una mossa, puoi continuare\ncon gli attacchi regolari. E guadagni lo stesso\nPunti Esperienza in più. Chi lo sapeva, ohibò?", spanish="Cuando lo has hecho, aunque uses después\nsolo ataques convencionales sigues ganando\nmás Puntos de Experiencia. ¿A que mola?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Moves also have higher critical-hit rates than\nthe regular attack. So you're cheating yourself\nif you're not using moves!", french="Les capacités ont aussi un taux d'coups\ncritiques plus élevé. Alors, sachant ça,\nfaudrait être une buse pour pas s'en servir!", german="Attacken haben ferner eine höhere\nVolltrefferrate als reguläre Angriffe. Selbst\nSchuld, wenn ihr sie nicht verwendet!", italian="Le mosse hanno anche più probabilità degli\nattacchi regolari di diventare brutti colpi.\nQuindi se non le usi, ti penalizzi da solo!", spanish="Además, es más probable asestar un golpe\ncrítico con un movimiento que con un ataque\nconvencional, ¡así que ni me lo voy a pensar!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I'll be using more moves! Starting tomorrow!\nYup yup!", french="J'vais utiliser plus de capacités! Dès d'main,\npour sûr!", german="Von morgen an werde ich mehr Attacken\neinsetzen! Jawollja!", italian="Userò più mosse! Da domani! Ohibò!", spanish="¡A partir de mañana empezaré a usar más\nmovimientos! ¡Sí, señor!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="P.S. So... I did exactly what I promised I\nwould! I used lots of moves while exploring!", french="P.-S. Donc... j'ai tenu ma promesse! J'ai utilisé\ntout un tas d'capacités en exploration!", german="P.S.: Ich habe tatsächlich das getan, was ich\nversprochen habe, und reichlich Attacken auf\nmeinen Erkundungen eingesetzt!", italian="P.S. Dunque... Ho fatto esattamente quello che\navevo promesso! Ho usato molte mosse durante\nle esplorazioni!", spanish="P. D.: Hice tal y como prometí: comencé a\nusar muchos movimientos al explorar."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But I used my moves so often that I ran out\nof PP for my moves almost right away...", french="Mais j'les ai tellement utilisées qu'je m'suis\ntout d'suite retrouvé à court de PP...", german="Aber ich habe meine Attacken so häufig\neingesetzt, dass mir fast unmittelbar die AP\ndafür ausgegangen sind.", italian="Ma le ho usate così tanto che ho terminato\ni PP quasi subito...", spanish="Pero me pasé de la raya y los usé tantas\nveces que me quedé sin PP enseguida..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oof...[K] Exploring is never as easy as it looks,\nI reckon.", french="Pfiou...[K] L'exploration, c'est jamais aussi facile\nqu'ça en a l'air, on dirait.", german="Uuf...[K] Ich vermute, Erkunden ist niemals so\nleicht, wie es aussieht.", italian="Puff...[K] Esplorare non è poi così facile come\nsembra.", spanish="Uf...[K] Tengo que admitir que explorar no es\ntan sencillo como parece."})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- @label_24 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR]'s Yup Yup Journal\n[CN]Entry 4: Exploring with [CS:N]Sunflora[CR]\n[CN]OO Month XX Day, Sunny", french="[CN]Pour sûr! Journal de [CS:N]Keunotor[CR]\n[CN]Article 4: [CS:N]Héliatronc[CR]\n[CN]Jour: XX Mois: OO, Beau temps", german="[CN]Jawollja-Journal von [CS:N]Bidiza[CR]\n[CN]Eintrag 4: Erkunden mit [CS:N]Sonnflora[CR]\n[CN]Tag XX Monat OO, Sonnig", italian="[CN]Il Diario-ohibò di [CS:N]Bidoof[CR]\n[CN]Nota 4: Esplorando con [CS:N]Sunflora[CR]\n[CN]Giorno XX Mese OO, Sole", spanish="[CN]Diario \"Huyuyuy\" de [CS:N]Bidoof[CR]\n[CN]4. Explorando con [CS:N]Sunflora[CR]\n[CN]Día \"nosecuál\" del mes \"nimeacuerdo\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:N]Sunflora[CR] is some kind of awesome!", french="[CS:N]Héliatronc[CR], c'est une sacrée nana!", german="[CS:N]Sonnflora[CR] ist ziemlich toll!", italian="[CS:N]Sunflora[CR] è davvero fantastica!", spanish="¡[CS:N]Sunflora[CR] es impresionante!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Yup yup! I went exploring with [CS:N]Sunflora[CR] the\nother day.", french="J'suis parti en exploration avec [CS:N]Héliatronc[CR]\nl'aut' jour, sapristi.", german="Jawollja! Neulich bin ich mit [CS:N]Sonnflora[CR] auf\nErkundung gewesen.", italian="Ohibò! L'altro giorno sono andato a esplorare\ncon lei.", spanish="¡Sí! El otro día fui a explorar con ella."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It turns out [CS:N]Sunflora[CR]'s a real expert at\nfighting in dungeons.", french="J'ai découvert qu'[CS:N]Héliatronc[CR], ben c'est une\nvéritable experte des combats en donjon.", german="Wie sich herausstellte, ist [CS:N]Sonnflora[CR] eine\nrichtige Expertin, was Dungeonkämpfe\nanbelangt.", italian="[CS:N]Sunflora[CR] si è dimostrata una vera esperta\ndi lotte nei dungeon.", spanish="Resulta que [CS:N]Sunflora[CR] es un hacha en los\ncombates."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="When an enemy is just out of reach, she\ndoesn't move toward it! Instead she uses [M:B2] to\nlaunch her regular attack, striking at nothing!", french="Quand un ennemi est hors de portée, elle\ns'en approche pas! Elle lance son attaque\nordinaire avec [M:B2] et frappe dans l'vide!", german="Wenn ein Gegner außer Reichweite ist, bewegt\nsie sich nicht auf ihn zu, sondern drückt [M:B2]\nfür einen Angriff ins Leere!", italian="Quando un nemico è fuori portata, non si\nmuove verso di lui! Usa invece [M:B2] per\nlanciare attacchi regolari, contro il nulla!", spanish="Si un enemigo se encuentra lejos, ¡no va\nhacia él, sino que usa [M:B2] y lanza al aire\nsu ataque convencional!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Then the enemy usually spends that turn closing\nthe distance on her. And then, on her next turn,\nshe's the first one close enough to hit!", french="Alors l'ennemi passe l'tour suivant à\ns'approcher d'elle. Du coup, quand c'est son\ntour, elle est la première à frapper!", german="Dann überbrückt der Gegner die Distanz zu ihr\nin seiner Runde. In der Folgerunde ist sie dann\ndie Erste in Reichweite für einen Treffer.", italian="Poi il nemico, solitamente, in quel turno le si\navvicina. E così lei nel turno successivo\nè abbastanza vicina per colpire per prima!", spanish="Así, el enemigo pierde su turno acercándose.\n¡Y al final es ella la que, en el siguiente turno,\nestá tan cerca como para atacar!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Yup yup! She sure knows what she's doing,\nby golly!", french="Pour sûr! Elle sait c'qu'elle fait, sapristi!", german="Jawollja! Sie weiß echt, was sie tut,\nDonnerwetter!", italian="Ohibò! Sicuramente quella furbetta sa quello\nche fa! Sissignore!", spanish="¡Vaya! ¡Tiene las ideas muy claras!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Why, I wanted to whoop and holler when I saw\nher use that trick. So thrilling![K] Sigh...", french="J'ai bien failli l'acclamer quand elle a utilisé\nc'te ruse-là. Que d'émotions![K] Aaah...", german="Ich wollte schreien und brüllen, als ich sie\ndiesen Trick habe einsetzen sehen. So\naufregend war das![K] Seufz...", italian="Avrei voluto gridare a più non posso quando\nl'ho vista usare questa tecnica.\nÈ sensazionale![K] Sigh...", spanish="¡Huy, me emocioné un montón cuando vi cómo\nusaba ese truco![K] Uf..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="As for me, I always rush into a fight...[K]\nThat's why I end up being first to get hit!", french="Moi, j'fonce toujours dans l'tas...[K] C'est pour\nça que l'ennemi, il m'frappe en premier!", german="Was mich angeht, ich stürze mich immer in\neinen Kampf.[K] Daher bin ich auch immer der\nErste, der getroffen wird!", italian="Io invece corro sempre incontro ai nemici...[K]\nE vengo regolarmente colpito per primo...", spanish="Yo, por el contrario, me tiro de cabeza contra\nel enemigo...[K] ¡Por eso soy siempre el que\nrecibe el primer golpe!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But it's all right, I reckon. I know the way to\ndo it now and can explore better now. Yup yup!", french="Mais c'est pas bien grave, j'imagine. Maintenant\nque j'sais comment faire, j'vais m'améliorer,\npour sûr!", german="Aber ich schätze, das ist in Ordnung. Ich weiß,\nwie man es macht, und kann nun effektiver\nerkunden. Jawollja!", italian="Ma va bene, ne terrò conto. Ora so come fare\ne posso diventare un esploratore migliore,\nohibò!", spanish="Pero bueno, ya sé cómo se tienen que hacer\nlas cosas y a partir de ahora lo haré mejor."})
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  -- jump @label_25 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 2 then
  -- jump @label_26 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 1 then
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_57 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 88) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 88]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 25 -- $EVENT_LOCAL = 25 (ROM)
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 73) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 73]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 24 -- $EVENT_LOCAL = 24 (ROM)
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 67) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 67]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 23 -- $EVENT_LOCAL = 23 (ROM)
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 56) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 22 -- $EVENT_LOCAL = 22 (ROM)
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 53) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 53]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 21 -- $EVENT_LOCAL = 21 (ROM)
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 50) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 50]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 20 -- $EVENT_LOCAL = 20 (ROM)
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 44) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 44]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 19 -- $EVENT_LOCAL = 19 (ROM)
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 40) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 40]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 18 -- $EVENT_LOCAL = 18 (ROM)
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 6) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 6]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 17 -- $EVENT_LOCAL = 17 (ROM)
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 5]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 16 -- $EVENT_LOCAL = 16 (ROM)
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 1]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 15 -- $EVENT_LOCAL = 15 (ROM)
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(22, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [22, 3]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 14 -- $EVENT_LOCAL = 14 (ROM)
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [22, 2]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 13 -- $EVENT_LOCAL = 13 (ROM)
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 3]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 12 -- $EVENT_LOCAL = 12 (ROM)
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 5]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 11 -- $EVENT_LOCAL = 11 (ROM)
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 1]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 10 -- $EVENT_LOCAL = 10 (ROM)
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 1]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 9 -- $EVENT_LOCAL = 9 (ROM)
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 3]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 8 -- $EVENT_LOCAL = 8 (ROM)
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 1]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 7 -- $EVENT_LOCAL = 7 (ROM)
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 6) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 6]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 6 -- $EVENT_LOCAL = 6 (ROM)
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 1]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 5 -- $EVENT_LOCAL = 5 (ROM)
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(6, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [6, 1]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 4 -- $EVENT_LOCAL = 4 (ROM)
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(5, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [5, 5]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 3 -- $EVENT_LOCAL = 3 (ROM)
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 7]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 2 -- $EVENT_LOCAL = 2 (ROM)
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 3]
  -- @label_54 [étiquette de flux ExplorerScript]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 1 -- $EVENT_LOCAL = 1 (ROM)
  -- jump @label_56 [saut final de branche vers l'épilogue commun: flux naturel]
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
