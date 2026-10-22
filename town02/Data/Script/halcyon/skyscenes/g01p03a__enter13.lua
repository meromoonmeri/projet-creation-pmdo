-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/enter13.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]All sorts of information is written here...", french="[CN]Toutes sortes d'infos sont inscrites ici...", german="[CN]Hier sind allerhand Informationen zu finden...", italian="[CN]Informazioni utili", spanish="[CN]Aquí hay todo tipo de información útil..."})
  -- message_Close
  -- message_ResetActor() [neutre/état moteur]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 8 -- $EVENT_LOCAL = 8 (ROM)
  do local __sw = ((SV.SkyMenuResults or {})["MENU_GUILD_F_A_Q_BOARD"] or 0) -- switch(message_Menu(MENU_GUILD_F_A_Q_BOARD)) [message_Menu(MENU_GUILD_F_A_Q_BOARD): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Q1: What's the Exploration Team Federation?", french="Q1: La Fédération des Equipes d'Exploration?", german="F1: Was ist der Erkundungsteamverband?", italian="D1. Cos'è la Fed. Squadre d'Esplorazione?", spanish="P1: ¿Qué es la Federación de Exploradores?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="A1: The Pokémon Exploration Team Federation\nis a mysterious organization to which all\nexcellent explorers belong.", french="R1: La Fédération des Equipes d'Exploration\nest une mystérieuse organisation dont font\npartie les meilleurs explorateurs.", german="A1: Der Pokémon-Erkundungsteamverband\nist eine mysteriöse Organisation, zu der alle\nherausragenden Erkunder gehören.", italian="R1. La Federazione Squadre d'Esplorazione è\nun'organizzazione misteriosa di cui fanno parte\ntutti i migliori esploratori.", spanish="R1: La Federación de Exploradores es una\nmisteriosa organización a la que pertenecen\nlos mejores exploradores."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The Federation collects dues from guilds\nnationwide for producing items and badges\nused by exploration teams.", french="La Fédération prélève les cotisations de toutes\nles guildes afin de fabriquer des objets et\ndes badges à l'intention des explorateurs.", german="Der Verband sammelt landesweit Beiträge\nvon Gilden für die Herstellung von Items und\nOrden zur Verwendung durch Erkundungsteams.", italian="La Federazione riceve quote dalle Gilde di\ntutta la nazione per produrre gli strumenti e\nle targhette usate dalle squadre d'esplorazione.", spanish="Recauda cuotas de los distintos Pokégremios\npara producir los objetos y las placas que\nutilizan los equipos de exploración."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The Federation also operates a number of\nservices for explorers. It's an indispensable\norganization for explorers!", french="La Fédération propose également toute\nune gamme de services pour les explorateurs,\nsi bien qu'elle leur est indispensable!", german="Der Verband stellt Erkundern ferner eine\nAnzahl von Diensten zur Verfügung. Er ist eine\nunentbehrliche Organisation für Entdecker!", italian="La Federazione gestisce anche molti servizi\nper gli esploratori. È un'organizzazione\nindispensabile!", spanish="La Federación también ofrece una serie\nde servicios a los exploradores. ¡Es una\norganización indispensable para ellos!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="To put it simply, it's an incredibly great\norganization!", french="Bref, c'est une organisation génialissime!", german="Um es einfach auszudrücken, er ist eine\nunglaublich tolle Organisation!", italian="Per farla breve, è un'organizzazione\nfantastica!", spanish="Resumiendo, ¡es una organización increíble!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="...That is all.", french="... C'est tout.", german="...Das ist alles.", italian="... È tutto.", spanish="Eso es todo."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw == 2 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Q2: What's written here?", french="Q2: Que trouve-t-on affiché ici?", german="F2: Was steht hier geschrieben?", italian="D2. Cosa c'è scritto qui?", spanish="P2: ¿Qué hay escrito aquí?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="A2: This spot is reserved for useful notices,\nhints, tips, advice, and so on.", french="R2: Cet emplacement est réservé aux infos\nutiles et propose également astuces, bons\nplans, conseils, etc.", german="A2: Dieser Platz ist für nützliche Notizen,\nHinweise, Tipps, Ratschläge usw. reserviert.", italian="R2. Qui si trovano avvisi utili, suggeri-\nmenti, indizi, consigli e via dicendo.", spanish="R2: Este lugar está reservado para anuncios,\nconsejos, mensajes de ayuda, etc."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="...That is all.", french="... C'est tout.", german="...Das ist alles.", italian="... È tutto.", spanish="Eso es todo."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw == 3 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Q3: How do I know what to do?", french="Q3: Comment savoir ce que je dois faire?", german="F3: Woher weiß ich, was zu tun ist?", italian="D3. Non so cosa fare! E adesso?", spanish="P3: ¿Cómo averiguo qué tengo que hacer?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="A3: If you're not sure what to do, try looking\nup some hints!", french="R3: Si vous ne savez pas trop quoi faire,\nutilisez l'aide pour obtenir des conseils!", german="A3: Wenn du dir nicht sicher bist, was du tun\nsollst, schlag ein paar Tipps nach!", italian="R3. Se non sai cosa fare, prova a\ndare un'occhiata ai consigli!", spanish="R3: Si no sabes muy bien qué hacer, echa\nun vistazo a los consejos."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="To get some hints, press [M:B4] to access the\nmenu, then find them under Others.", french="Pour obtenir de l'aide, appuyez sur le bouton [M:B4]\npour accéder au menu, puis sélectionnez\nAutres.", german="Um einige Tipps zu erhalten, drücke [M:B4],\num in das Menü zu gelangen. Du findest sie\ndann unter ANDERES.", italian="Per ricevere dei consigli, innanzitutto premi\n[M:B4] per accedere al menu,\npoi seleziona Altro.", spanish="Pulsa el Botón [M:B4] para acceder al menú y\ndirígete a la sección Otros. Los encontrarás\nallí."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The hints will give you all sorts of useful\ninformation for your explorations.", french="L'aide vous donnera toutes sortes\nd'informations utiles pour vos explorations.", german="Unter SPIELTIPPS findest du jede Menge\nInformationen für deine Erkundungen.", italian="Qui troverai tutte le informazioni di cui\nhai bisogno per le tue esplorazioni.", spanish="Los consejos te proporcionarán toda suerte\nde información útil para tus exploraciones."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="So if you're stuck, look up some hints!", french="Alors, en cas de souci, pensez à consulter\nles astuces et conseils de l'aide!", german="Wenn du also feststeckst, lass dir ein paar\nTipps geben!", italian="Perciò se ti blocchi, guarda i consigli!", spanish="Así que si te atascas, ¡consúltalos!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="...That is all.", french="... C'est tout.", german="...Das ist alles.", italian="... È tutto.", spanish="Eso es todo."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw == 4 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Q4: How do I start a job?", french="Q4: Comment commencer une mission?", german="F4: Wie geht man Jobs an?", italian="D4. Come faccio a cominciare una missione?", spanish="P4: ¿Cómo se empieza una misión?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="A4: If you've already put the job on your Job\nList, you must then use the Take Job option.", french="R4: Peut-être avez-vous oublié d'activer\nla mission en utilisant l'option Accepter?", german="A4: Falls du den Job bereits deiner Jobliste\nhinzugefügt hast, musst du ihn mit der\nOption AUSÜBEN aktivieren.", italian="R4. Se la missione è già nella lista delle\nmissioni, devi usare il comando Attiva.", spanish="R4: Si ya has añadido alguna misión a tu lista\nde misiones, solo tienes que activarla con la\nopción Aceptar."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="If you see a job on the Job Bulletin Board or\nthe Outlaw Notice Board that you want to do,\nyou have to do two things...", french="Si vous voulez accomplir une mission figurant\nau Tableau des Missions ou dans les Avis de\nRecherche, il y a deux choses à faire...", german="Wenn dich ein Job vom Job-Infobrett oder\nvom Ganoven-Infobrett interessiert, musst\ndu zwei Dinge tun...", italian="Per avventurarti in una missione della\nBacheca dei ricercati o di quella delle missioni,\ndevi fare due cose...", spanish="En otras palabras, para realizar una misión del\nTablón de Anuncios o del Tablón \"Se Busca\",\ntienes que hacer dos cosas..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="First, choose the job from a board to add it to\nyour Job List. Second, select it from your Job\nList, then use the Take Job option.", french="Choisissez d'abord une mission pour l'ajouter\nà votre Liste de Missions. Puis sélectionnez-la\ndans la liste et utilisez Accepter.", german="Wähle den Job erst auf einem Infobrett aus,\num ihn der Jobliste hinzuzufügen. Markiere ihn\ndann auf der Jobliste und wähle AUSÜBEN aus.", italian="Scegli una missione dalla Bacheca per metterla\nnella tua lista delle missioni. Se vuoi partire,\nselezionala e scegli il comando Attiva.", spanish="Elige la misión y añádela a la lista de misiones.\nSelecciónala después y pulsa Aceptar."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Exploration teams should take care of jobs\nthey've added to their list as soon as possible!", french="Les équipes d'exploration devraient toujours\ns'occuper en priorité des missions figurant\ndans leur Liste de Missions!", german="Erkundungsteams sollten ihrer Liste\nhinzugefügte Jobs so früh wie möglich\nin Angriff nehmen!", italian="Le squadre d'esplorazione devono svolgere\nle missioni scelte e messe in lista il prima\npossibile!", spanish="Los equipos de exploración deberían ocuparse\nde las misiones de su lista lo antes posible."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Now, go! Quit reading this and explore!", french="Et maintenant, du balai! Arrêtez de lire\nce panneau et retournez en exploration!", german="Und nun ist es Zeit! Hör auf zu lesen und begib\ndich auf Erkundung!", italian="Ora vai! Smetti di leggere ed esplora!", spanish="¡Así que venga! ¡Deja de leer esto y ponte a\nexplorar!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="...That is all.", french="... C'est tout.", german="...Das ist alles.", italian="... È tutto.", spanish="Eso es todo."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw == 5 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Q5: What's the Explorer Rank?", french="Q5: Que sont les Grades d'Explorateur?", german="F5: Was ist der Erkunderrang?", italian="D5. Cos'è il Rango Esploratore?", spanish="P5: ¿Qué son los rangos de los equipos?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="A5: The Explorer Rank indicates your\nstanding within the Pokémon Exploration Team\nFederation.", french="R5: Le Grade d'Explorateur indique votre rang\nau sein de la hiérarchie de la Fédération des\nEquipes d'Exploration.", german="A5: Der Erkunderrang zeigt deinen Status\ninnerhalb des Pokémon-\nErkundungsteamverbandes an.", italian="R5. Il rango della squadra d'esplorazione\nindica la sua posizione all'interno della\nFederazione Squadre d'Esplorazione.", spanish="R5: El rango del equipo indica el prestigio\nque tiene dentro de la Federación de\nExploradores Pokémon."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="An exploration team gains Rank Points for\ncompleting jobs. Upon earning set amounts\nof points, the team goes up in rank.", french="Une équipe gagne des points d'exploration en\naccomplissant des missions. Si elle atteint un\ncertain nombre de points, elle monte en grade.", german="Jedes Erkundungsteam erhält Rangpunkte für\nerfolgreiche Jobs. Bei einer bestimmten\nPunktzahl steigt der Rang des Teams.", italian="Una squadra d'esplorazione guadagna Punti\nEsplorazione completando le missioni. Guada-\ngnati un certo numero di punti, sale di rango.", spanish="Cada equipo adquiere puntos de rango al\ncompletar sus misiones y sube de rango tras\nadquirir un determinado número de puntos."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="A team gets a new Explorer Badge when it\ngoes up in rank. But that's not all. You'll\ndiscover more benefits as you rank up!", french="Une équipe montant en grade reçoit un nouveau\nBadge d'Explorateur. Mais pas seulement! Vous\npouvez également obtenir d'autres avantages!", german="Bei einem Rangaufstieg bekommt das Team\neinen neuen Erkunderorden. Aber du wirst noch\nweitere Vergünstigungen entdecken.", italian="Quando una squadra sale di rango, guadagna una\nnuova Targhetta dell'esploratore. Non solo,\nsalendo di rango, otterrà anche altri benefici!", spanish="Al subir de rango, se recibe una nueva Placa\nde Explorador entre otros beneficios..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Finally, you'll notice that there is a footprint\nimprinted on the back of the badge.", french="Enfin, vous remarquerez qu'une empreinte\nde pas est imprimée au dos du badge.", german="Dir wird auffallen, dass ein Fußabdruck in\ndie Ordensrückseite eingeprägt ist.", italian="Inoltre, il retro della Targhetta dell'esploratore\nporta incisa un'impronta.", spanish="Por último, notarás que, en la parte trasera\nde la placa, hay una huella impresa."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="That doubles as a security pass for the guild.\nIt lets you enter and exit the guild whenever\nyou want. Did you know that?", french="Il sert aussi de laissez-passer pour pouvoir\nentrer et sortir de la Guilde quand vous\nle souhaitez. Le saviez-vous?", german="Das zählt als Sicherheitspass für die Gilde.\nDamit kannst du jederzeit in die Gilde hinein-\nund wieder hinausgelangen. Wusstest du das?", italian="Serve da chiave d'accesso alla Gilda.\nTi permette di entrare e uscire dalla\nGilda quando vuoi. Lo sapevi?", spanish="Funciona como pase de seguridad para el\n[CS:N]Pokégremio[CR]. Permite entrar y salir de\naquí libremente. ¿Lo sabías?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Those who are first starting out should work\ntoward the Bronze Rank!", french="Pour les novices, le premier objectif à\natteindre est le Grade Bronze!", german="Diejenigen, die gerade mit dem Erkunden\nbegonnen haben, sollten auf den Bronze-Rang\nhinarbeiten!", italian="I principianti devono aspirare prima di tutto\nal Rango Bronzo!", spanish="¡Trabaja para alcanzar el Rango Bronce\nsi todavía estás empezando!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="...That is all.", french="... C'est tout.", german="...Das ist alles.", italian="... È tutto.", spanish="Eso es todo."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw == 6 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Q6: Is eating Gummis a good thing to do?", french="Q6: Est-il conseillé de manger des gelées?", german="F6: Lohnt es sich, Gummis zu essen?", italian="D6. Posso mangiare le Caramelle Gommose?", spanish="P6: ¿Es bueno comer gomis?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="A6: Yes! Of course you should eat Gummis!\nIt boosts your IQ!", french="R6: Oui! Il faut bien évidemment manger\ndes gelées! Grâce à elles, vous pouvez\naugmenter votre Q.I.!", german="A6: Ja! Natürlich solltest du Gummis essen!\nDas steigert deinen IQ!", italian="R6. Sì! Certo che puoi mangiare le Caramelle\nGommose. Aumentano il tuo QI!", spanish="R6: ¡Por supuesto! ¡Aumentan tu CI!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="When your IQ goes up, you'll gain IQ Skills\nthat help you while exploring.", french="Quand votre Q.I. augmente, vous gagnez\nde nouvelles aptitudes Q.I. qui vous seront\ntrès utiles au cours de vos aventures.", german="Wenn dein IQ steigt, erhältst du\nIQ-Fähigkeiten, die dir wiederum beim\nErkunden helfen.", italian="Quando il tuo QI aumenta, guadagni delle\nabilità QI che ti torneranno utili quando esplori.", spanish="Al subir tu CI, adquirirás habilidades CI que\nte serán de utilidad a la hora de explorar."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="That's why you shouldn't hesitate to eat\nGummis. Eat as much as you want!", french="N'hésitez donc pas à manger des gelées.\nMangez-en autant que possible!", german="Deshalb solltest du nicht zögern, Gummis zu\nessen. Iss, so viel du magst!", italian="Quindi non esitare, mangia pure Gomme\na sazietà!", spanish="Así que no dudes ni un segundo. ¡Come todas\nlas que quieras!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Specific types of Pokémon have a different\nfavorite Gummi. If a Pokémon eats its\nfavorite, its IQ goes up much faster!", french="Suivant son type, chaque Pokémon a une gelée\npréférée. S'il mange sa gelée favorite, un\nPokémon verra son Q.I. augmenter plus vite!", german="Bestimmte Pokémon-Typen haben jeweils\nbestimmte Lieblingsgummis. Beim Verzehr von\nLieblingsgummis steigt der IQ viel schneller!", italian="I diversi tipi di Pokémon hanno Gomme\npreferite differenti. Se mangiano le Gomme\npreferite, il loro QI cresce più velocemente!", spanish="Cada tipo de Pokémon tiene su gomi favorita.\nSu CI aumenta mucho más si come este tipo\nde gomi."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It's great to eat lots of Gummis! And it's best\nto eat lots of your favorite kind of Gummis!", french="C'est super de se goinfrer de gelées!\nEt c'est encore mieux de se goinfrer\nde sa gelée préférée!", german="Es ist gut, viele Gummis zu essen! Und es ist\nam besten, viele deiner Lieblingsgummis zu\nessen!", italian="Mangia un sacco di Gomme! Meglio ancora\nse sono del tuo tipo preferito!", spanish="Así que cuantas más gomis comas, ¡mejor!\n¡Y más aún si son de tu tipo favorito!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="...That is all.", french="... C'est tout.", german="...Das ist alles.", italian="... È tutto.", spanish="Eso es todo."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw == 7 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Q7: How do I talk to my partner?", french="Q7: Comment parler à mon partenaire?", german="F7: Wie spreche ich mit meinem Partner?", italian="D7. Come si parla con il compagno?", spanish="P7: ¿Cómo hablo con mi acompañante?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="A7: What?[K] Your partner is right next to you,\nbut you can't chat?", french="R7: Comment?[K] Mais votre partenaire est juste\nà côté de vous... Pourquoi ne pourriez-vous\npas discuter avec lui?", german="A7: Was?[K] Dein Partner befindet sich genau\nneben dir und du kannst nicht mit ihm\nsprechen?", italian="R7. Cosa?[K] Il tuo compagno è al tuo fianco,\nma non sai come parlargli?!?", spanish="R7: ¿Qué?[K] ¿Tu acompañante está a tu lado\npero no podéis charlar?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Just be brave and talk to your partner. Your\nfriend will understand what's on your mind.", french="Prenez votre courage à deux mains et\nparlez-lui! C'est votre ami, il saura\ndeviner vos pensées.", german="Sei einfach nur tapfer und sprich mit deinem\nPartner. Dein Freund wird schon verstehen,\nwas in deinem Kopf vorgeht.", italian="Coraggio! Parla con il tuo compagno. Lui capirà\ncos'hai in mente.", spanish="Sé valiente y habla con tu acompañante. Así\nentenderá lo que piensas."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Press [M:B7] to talk to your partner. Your partner\nwill never ignore you!", french="Appuyez sur le bouton [M:B7] pour parler\nà votre partenaire. Jamais il ne refusera\nde discuter avec vous!", german="Drücke [M:B7], um mit deinem Partner zu\nsprechen. Dein Partner wird dich niemals\nignorieren!", italian="Premi [M:B7] per parlare con il tuo\ncompagno. Sarà sempre disponibile!", spanish="Para hablar con tu acompañante pulsa el\nBotón [M:B7]. ¡Nunca te ignorará!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Talk to your partner especially if you're not\nsure what to do next. Press [M:B7] and strike up\na conversation!", french="Parlez à votre partenaire surtout quand\nvous ne savez pas quoi faire. Appuyez sur\nle bouton [M:B7] pour entamer une conversation!", german="Unterhalte dich besonders dann mit deinem\nPartner, wenn du dir nicht sicher bist, was zu\ntun ist. Drücke [M:B7] und sprich ihn an!", italian="Parla con il tuo compagno soprattutto quando\nnon sai cosa fare. Premi [M:B7] per cominciare\nuna conversazione!", spanish="Habla con tu acompañante si no sabes qué\nhacer. Pulsa el Botón [M:B7] y entabla una\nconversación."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Your partner is sure to have useful advice\nfor you!", french="Votre partenaire vous donnera des conseils\nutiles, sans aucun doute!", german="Dein Partner hat ganz bestimmt nützliche\nHinweise für dich!", italian="Il tuo compagno ti darà sicuramente dei\nsuggerimenti utili!", spanish="¡Seguro que tiene algún consejo útil que darte!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="...That is all.", french="... C'est tout.", german="...Das ist alles.", italian="... È tutto.", spanish="Eso es todo."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw == 8 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Q8: What are types?", french="Q8: Que sont les types?", german="F8: Was sind Typen?", italian="D8. Che cosa sono i tipi?", spanish="P8: ¿Qué son los tipos?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="A8: Pokémon are categorized by types such as\nFire, Water, and Grass. Many Pokémon even\nhave two types.", french="R8: Les Pokémon sont classés en fonction de\nleur type, comme Feu, Eau ou Plante. Qui plus\nest, beaucoup de Pokémon ont deux types.", german="A8: Pokémon sind in verschiedene Typen wie\nz. B. Feuer, Wasser und Pflanze unterteilt.\nManche Pokémon gehören sogar zu zwei Typen.", italian="R8. I Pokémon sono classificati per tipo,\ncome ad esempio Fuoco, Acqua ed Erba. Molti\nPokémon sono di due tipi.", spanish="R8: Los Pokémon son de distintos tipos:\nFuego, Agua, Planta, etc. Muchos Pokémon\nson de dos tipos a la vez."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The amount of damage that an attacking\nPokémon does with its move is related to the\nmove's type and the defending Pokémon's type.", french="Les dégâts infligés par la capacité d'un\nPokémon dépendent du type de la capacité\nutilisée et du type de la cible.", german="Der Schaden, den ein Pokémon mit seiner\nAttacke austeilt, hängt von seinem und dem\nTyp des sich verteidigenden Pokémon ab.", italian="I danni provocati dall'attacco di un Pokémon\ndipendono dal tipo della mossa e dal tipo del\nPokémon che si difende.", spanish="El daño que causa el ataque de un Pokémon va\nen función del tipo de movimiento usado y del\ntipo del Pokémon que está siendo atacado."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="For example, a Fire-type Pokémon is weak\nagainst Water-type moves.", french="Par exemple, un Pokémon de type Feu est\nvulnérable aux capacités de type Eau.", german="Beispielsweise ist ein Feuer-Pokémon anfällig\ngegenüber Wasser-Attacken.", italian="Per esempio, un Pokémon di tipo Fuoco è\ndebole contro le mosse di tipo Acqua.", spanish="Por ejemplo, un Pokémon de tipo Fuego es\ndébil frente a movimientos de tipo Agua."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="And a Water-type Pokémon will be weak to\nElectric-type moves.", french="Par ailleurs, un Pokémon de type Eau est\nvulnérable aux capacités de type Electrik.", german="Und ein Wasser-Pokémon ist anfällig\ngegenüber Elektro-Attacken.", italian="E un Pokémon di tipo Acqua è debole contro\nle mosse di tipo Elettro.", spanish="Y un Pokémon de tipo Agua es débil frente a\nmovimientos de tipo Eléctrico."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Learn how all types of Pokémon and moves\nmatch up, so you can battle effectively.[K]\nThat's you, the exploration team reading this!", french="Apprenez à connaître les rapports entre\nles types de Pokémon et de capacités, et\nvos attaques gagneront en efficacité!", german="Lerne, wie sich alle Pokémon-Typen und\nAttacken in Relation zueinander verhalten,\ndamit du effektiver kämpfst.[K] Ja, genau! Du!", italian="Impara come si abbinano tutti i tipi di\nPokémon e di mosse, in modo da poter\nlottare al meglio.[K] Ora tocca a te!", spanish="Aprende a combinar los tipos de Pokémon y\nsus movimientos.[K] Así lucharás mucho mejor\ny lograrás una clara ventaja para tu equipo."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="...That is all.", french="... C'est tout.", german="...Das ist alles.", italian="... È tutto.", spanish="Eso es todo."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
end
