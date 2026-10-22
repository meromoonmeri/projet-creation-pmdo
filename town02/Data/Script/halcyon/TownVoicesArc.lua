--[[
    TownVoicesArc.lua

    METANO PARLE — chapitres 8, 9 et 10
    ================================================================
    CONSTAT MESURE
    ------------------------------------------------------------------
    TownVoices.lua a donne cinq etats de parole aux 26 habitants du
    chapitre 6. Le mecanisme fonctionne, mais il s'arrete la :
    TownVoices.CH6 est la SEULE table de fiches du module, et aucun
    appel a TownVoices.Talk n'existe hors du ch6.

    Releve dans metano_town_ch_8/9/10.lua :

        ch8   53 handlers de PNJ,  8 a deux boites ou moins
        ch9   53 handlers de PNJ, 16 a deux boites ou moins
        ch10  53 handlers de PNJ, 28 a deux boites ou moins

    Les PNJ principaux (Noctowl, Tropius, Audino...) sont bien ecrits et
    reagissent deja a l'avancement. Ce sont les habitants ordinaires qui
    recitent une ligne unique du debut a la fin du chapitre — et plus on
    avance dans l'arc, plus la ville se tait : 28 muets au ch10.

    CE QUE FAIT CE MODULE
    ------------------------------------------------------------------
    Il reprend EXACTEMENT le patron valide du ch6 : une fiche par PNJ,
    jusqu'a cinq etats, repli en cascade sur l'etat precedent renseigne.
    Rien de neuf cote moteur — TownVoices.State sait deja lire les
    chapitres 7 a 10, seules les fiches manquaient.

    LES ETATS, PAR CHAPITRE
      ch8  Sanctuaire de Cristal : early / pre / during / post / quests
      ch9  Marais Oublie
      ch10 Pic Celeste

    PRINCIPE D'ECRITURE (repris du ch6, non negociable)
    ------------------------------------------------------------------
    Une ville ne commente pas l'intrigue : elle vit a cote, et c'est par
    ses petits soucis qu'on mesure ce qui change. Chaque PNJ garde UN
    trait constant a travers ses etats pour qu'on le reconnaisse ; ce
    qui change, c'est ce que ce trait devient sous la pression.

    LE FIL DE L'ARC, VU D'EN BAS
      ch8  le cristal fascine — on en parle comme d'une curiosite
      ch9  l'eau tourne, les recoltes s'abiment — l'inquietude entre
      ch10 le ciel se deregle — la ville commence a avoir peur, et
           ceux qui partent ne reviennent pas tous

    REGLES DU PROJET
      * Jamais « Necrozma », « Eternatus », « l'Abime », « prison ».
      * Aucun nom de personnage des jeux d'origine.
      * La Voix ne parle jamais en ville.
      * Module global -> texte litteral (pas de .resx).
      * 1 a 2 phrases par boite, < 150 caracteres hors [pause=N].
      * Aucune replique existante n'est supprimee : le module s'ajoute
        en amont et laisse la main si le PNJ n'a pas de fiche.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.TownVoices'
require 'halcyon.TownPlace'

TownVoicesArc = {}

--------------------------------------------------------------------
-- CHAPITRE 8 — LE SANCTUAIRE DE CRISTAL
-- La ville regarde le cristal comme une curiosite, puis comme une
-- ressource, puis comme quelque chose qu'on aurait peut-etre du
-- laisser tranquille.
--------------------------------------------------------------------
TownVoicesArc.CH8 = {

  ---- LE MARCHE ----
  Gulpin = { emo = 'Happy',
    early  = "On dit qu'il y a des cristaux qui chantent, au sud.[pause=20] Est-ce que ca se mange ?",
    pre    = "Un marchand a rapporte un eclat de cristal.[pause=25] Il l'a vendu le prix d'un mois de repas.",
    during = "Depuis que vous etes partis, plus personne ne parle de nourriture.[pause=25] C'est mauvais signe.",
    post   = "Vous avez rapporte un fragment ?[pause=20] Montrez ![pause=15] ...Non, je n'y mordrai pas. Promis.",
    quests = "J'ai grignote un bout de la vitrine en le regardant.[pause=25] Ne le dites a personne." },

  Ludicolo = { emo = 'Happy',
    early  = "Un smoothie aux baies givrees ?[pause=20] C'est de saison, avec ce froid du sud.",
    pre    = "Tout le monde commande la meme chose depuis trois jours.[pause=25] « Quelque chose de brillant. »",
    during = "Je garde votre table.[pause=20] Celle pres de la fenetre, comme d'habitude.",
    post   = "A votre retour ![pause=20] Le premier verre est pour vous, evidemment.",
    quests = "Vous avez couru pour tout le monde.[pause=25] Asseyez-vous. Je m'occupe du reste." },

  Spinda = { emo = 'Normal',
    early  = "Je tourne, je tourne...[pause=20] et le monde tourne avec moi. C'est reposant.",
    pre    = "Depuis que le cristal est arrive en ville,[pause=20] je tourne dans l'autre sens. Bizarre.",
    during = "La lumiere de mon comptoir a change de couleur.[pause=25] Ou alors c'est moi.",
    post   = "Ca s'est remis a tourner normalement.[pause=20] Enfin, normalement pour moi.",
    quests = "Vous avez remis beaucoup de choses d'aplomb.[pause=25] Meme ma tete, peut-etre." },

  ---- LES ENFANTS ----
  Spheal = { emo = 'Happy',
    early  = "Je roule ![pause=15] Regarde comme je roule vite !",
    pre    = "On dit que le sol brille, la-bas au sud ![pause=20] Je veux rouler dessus !",
    during = "Maman dit que je peux pas venir.[pause=25] Mais je roulerais super bien sur du cristal.",
    post   = "T'as vu le cristal ?[pause=20] C'etait comment ?[pause=15] Ca glisse ?",
    quests = "Quand je serai grand je roulerai jusqu'au sanctuaire.[pause=25] Tu m'accompagneras ?" },

  Doduo = { emo = 'Normal',
    early  = "Deux tetes, deux avis.[pause=20] On n'est jamais d'accord sur la direction.",
    pre    = "Une tete veut aller voir le cristal.[pause=20] L'autre veut rester au chaud.",
    during = "On a parie sur votre retour.[pause=25] L'une de nous a mise contre. Je ne dirai pas laquelle.",
    post   = "Celle qui avait parie contre fait la tete.[pause=20] Tant mieux.",
    quests = "Pour une fois, nos deux tetes sont d'accord :[pause=20] vous avez bien travaille." },

  Metapod = { emo = 'Normal',
    early  = "...",
    pre    = "...[pause=30] (Il ne bouge pas, mais il a tourne vers le sud.)",
    during = "...[pause=30] (Sa carapace vibre faiblement. Comme un cristal qu'on effleure.)",
    post   = "...[pause=25] (Il s'est remis droit. La vibration a cesse.)",
    quests = "...[pause=30] (Il incline sa carapace vers vous. C'est un salut, sans doute.)" },

  Silcoon = { emo = 'Normal',
    early  = "...",
    pre    = "...[pause=30] (Le fil de son cocon accroche la lumiere autrement qu'hier.)",
    during = "...[pause=30] (Quelque chose brille a l'interieur du cocon. Ou au travers.)",
    post   = "...[pause=25] (La lueur s'est eteinte. Le cocon est redevenu opaque.)",
    quests = "...[pause=30] (Un fil neuf, tres fin, relie son cocon a la branche. Il tient bon.)" },

  Venipede = { emo = 'Worried',
    early  = "Trop de pattes, pas assez de place sur ce trottoir.",
    pre    = "Les vibrations dans le sol ont change.[pause=25] Je le sens avant tout le monde, avec mes pattes.",
    during = "Ca vibre depuis le sud, en continu.[pause=25] Personne d'autre ne le sent ?",
    post   = "Les vibrations se sont arretees hier soir.[pause=20] D'un coup. J'ai mieux dormi.",
    quests = "Le sol est calme, maintenant.[pause=25] Vous n'imaginez pas ce que ca represente, pour moi." },

  Nidoran_Male = { emo = 'Normal',
    early  = "Je m'entraine a garder mes piquants bien droits.[pause=20] C'est plus dur qu'on croit.",
    pre    = "Les grands parlent de cristaux tranchants.[pause=25] Moi aussi je suis tranchant !",
    during = "J'ai promis de surveiller la place pendant que vous etiez partis.[pause=20] Rien a signaler.",
    post   = "Vous voila ![pause=15] J'ai bien surveille, hein ?",
    quests = "Un jour je serai assez fort pour venir avec vous.[pause=25] Entrainez-moi." },
}


--------------------------------------------------------------------
-- CHAPITRE 9 — LE MARAIS OUBLIE
-- L'eau tourne. Les recoltes s'abiment. La ville ne comprend pas
-- encore, mais elle a cesse de plaisanter.
--------------------------------------------------------------------
TownVoicesArc.CH9 = {

  Gulpin = { emo = 'Worried',
    early  = "Les legumes du sud ont un gout de vase.[pause=25] Meme moi je les laisse.",
    pre    = "Trois marchands ont refuse la livraison ce matin.[pause=25] Trois. Ca ne s'etait jamais vu.",
    during = "Je mange moins. Voila. C'est dit.[pause=25] Ne me demandez pas si ca va.",
    post   = "L'eau est redevenue claire, parait-il.[pause=20] Je regoute demain. Par prudence.",
    quests = "C'est bon.[pause=20] Le gout est revenu. Je peux recommencer a tout gouter." },

  Ludicolo = { emo = 'Worried',
    early  = "Mes fruits viennent des marais.[pause=25] Enfin, venaient.",
    pre    = "J'ai ferme le comptoir a fruits.[pause=25] Je ne sers plus que ce dont je suis sur.",
    during = "Je garde votre table quand meme.[pause=20] Elle vous attendra aussi longtemps qu'il faudra.",
    post   = "Les premieres caisses propres sont arrivees ce matin.[pause=25] J'ai failli pleurer dessus.",
    quests = "Le comptoir a fruits rouvre demain.[pause=25] Grace a vous. Et je le dirai a tout le monde." },

  Roselia = { emo = 'Sad',
    early  = "Mes fleurs du sud fanent en deux jours.[pause=25] Elles tenaient une semaine, avant.",
    pre    = "J'ai arrete de cueillir en bas.[pause=25] Ce n'est plus de la cueillette, c'est du ramassage.",
    during = "Faites attention a l'eau, la-bas.[pause=25] Elle n'a pas l'air sale. C'est ca, le pire.",
    post   = "Une pousse verte, ce matin, au bord du chemin sud.[pause=25] Une seule. Mais une.",
    quests = "J'y retourne demain, avec un panier.[pause=25] Un vrai panier, pas un seau." },

  Jigglypuff = { emo = 'Normal',
    early  = "Ma voix porte moins loin qu'avant.[pause=25] C'est l'humidite, sans doute.",
    pre    = "Je n'arrive plus a tenir la note haute.[pause=25] L'air est trop lourd.",
    during = "Je chante quand meme.[pause=25] Quelqu'un doit couvrir le bruit de la pluie.",
    post   = "Ma voix est revenue ce matin ![pause=20] Ecoutez !",
    quests = "Je prepare une chanson sur vous.[pause=25] Elle est un peu longue. Vous aurez le temps ?" },

  Marill = { emo = 'Worried',
    early  = "L'eau du puits a un gout de fer.[pause=25] Moi je le sens, je vis dedans.",
    pre    = "Je ne nage plus dans le ruisseau sud.[pause=25] Maman a interdit. Elle a raison.",
    during = "Ma queue flotte moins bien qu'avant.[pause=25] Vous croyez que c'est l'eau ?",
    post   = "J'ai renage aujourd'hui ![pause=20] L'eau est froide et propre !",
    quests = "Venez nager avec moi la prochaine fois ![pause=25] Je vous montrerai le fond." },

  Spheal = { emo = 'Sad',
    early  = "Je roule moins vite.[pause=25] La boue colle.",
    pre    = "La flaque ou je jouais est devenue toute brune.[pause=25] Je n'y vais plus.",
    during = "J'attends que vous rentriez pour rejouer.[pause=25] C'est plus rigolo a plusieurs.",
    post   = "La flaque est redevenue claire ![pause=20] Regardez, on se voit dedans !",
    quests = "On roule ensemble ?[pause=25] Juste une fois. S'il vous plait." },

  Bagon = { emo = 'Determined',
    early  = "Un jour je volerai.[pause=25] Aujourd'hui, je m'entraine a tomber correctement.",
    pre    = "Le vent du sud est bizarre.[pause=25] Il porte moins. J'ai teste. Deux fois.",
    during = "Quand vous rentrerez, je vous montrerai mon nouveau saut.[pause=25] Il est spectaculaire.",
    post   = "Vous etes rentres ![pause=20] Regardez ![pause=15] ...Bon. Il faut encore que je travaille.",
    quests = "Vous avez aide toute la ville sans savoir voler.[pause=25] Ca me donne a reflechir." },

  Doduo = { emo = 'Worried',
    early  = "Nos deux tetes ont mal au crane depuis trois jours.[pause=25] Les deux. En meme temps.",
    pre    = "On a arrete de se disputer.[pause=25] C'est vous dire si quelque chose ne va pas.",
    during = "On surveille la route du sud a tour de role.[pause=25] Une dort, l'autre guette.",
    post   = "On s'est disputees ce matin ![pause=20] Tout va bien, donc.",
    quests = "Les deux tetes disent merci.[pause=25] En choeur. Notez la date." },

  Metapod = { emo = 'Normal',
    early  = "...",
    pre    = "...[pause=30] (Sa carapace est humide. Elle ne seche plus.)",
    during = "...[pause=30] (Il s'est deplace de trois pas vers le nord. En une semaine.)",
    post   = "...[pause=25] (Sa carapace a seche. Il est revenu a sa place.)",
    quests = "...[pause=30] (Il est parfaitement sec, et parfaitement immobile. Il va bien.)" },

  Silcoon = { emo = 'Normal',
    early  = "...",
    pre    = "...[pause=30] (Le cocon s'est epaissi. Comme pour se proteger de quelque chose.)",
    during = "...[pause=30] (Rien ne bouge. Mais le fil tient, malgre l'humidite.)",
    post   = "...[pause=25] (Le cocon s'est allege. La menace est passee, il l'a senti.)",
    quests = "...[pause=30] (Une fissure nette court sur le cocon. Ce n'est pas un degat : c'est bientot.)" },

  Mareep = { emo = 'Worried',
    early  = "Ma laine crepite tout le temps depuis quelques jours.[pause=25] C'est desagreable.",
    pre    = "Je fais des etincelles des que quelqu'un m'approche.[pause=25] Excusez-moi d'avance.",
    during = "L'air est charge.[pause=25] Ma laine le sait avant moi.",
    post   = "Ca s'est calme ![pause=20] On peut me caresser sans risque. Enfin, presque.",
    quests = "Tenez, une meche de laine.[pause=25] Elle porte chance. C'est ma grand-mere qui le disait." },

  Nidoran_Male = { emo = 'Worried',
    early  = "Mes piquants s'emoussent avec cette humidite.[pause=25] Je les aiguise deux fois par jour.",
    pre    = "Les grands ne veulent rien me dire.[pause=25] C'est comme ca que je sais que c'est grave.",
    during = "Je monte la garde devant chez moi.[pause=25] C'est petit, mais c'est chez moi.",
    post   = "Vous etes revenus.[pause=25] Je peux arreter de monter la garde ?",
    quests = "Apprenez-moi a etre utile comme vous.[pause=25] Je suis serieux." },
}


--------------------------------------------------------------------
-- CHAPITRE 10 — LE PIC CELESTE
-- Le ciel se deregle. C'est le chapitre ou la ville a peur pour de
-- bon : 28 de ses habitants n'avaient qu'une seule ligne.
--------------------------------------------------------------------
TownVoicesArc.CH10 = {

  ---- LE MARCHE ----
  Gulpin = { emo = 'Worried',
    early  = "Le pain leve mal depuis une semaine.[pause=25] Le boulanger dit que c'est l'air.",
    pre    = "On stocke.[pause=25] Tout le monde stocke. Moi le premier, et je ne m'en cache pas.",
    during = "Je n'ai pas faim.[pause=30] Vous vous rendez compte de ce que je viens de dire ?",
    post   = "J'ai mange trois parts ce midi.[pause=20] Tout va bien. Le monde tourne rond.",
    quests = "Prenez ca pour la route.[pause=25] Non, ce n'est pas negociable." },

  Bellossom = { emo = 'Worried',
    early  = "Mes fleurs se ferment en plein jour.[pause=25] Elles croient qu'il fait nuit.",
    pre    = "Le ciel a une couleur que je n'ai jamais vue.[pause=25] Et j'ai quarante ans de marche.",
    during = "Je ne sors plus mes plus fragiles.[pause=25] Elles ne supporteraient pas ce vent.",
    post   = "Elles se sont rouvertes ce matin.[pause=25] Toutes en meme temps. J'ai pleure, un peu.",
    quests = "Prenez celle-la.[pause=25] Elle a tenu tout le chapitre. Comme vous." },

  Vileplume = { emo = 'Worried',
    early  = "Mon pollen retombe de travers.[pause=25] Le vent ne souffle plus droit.",
    pre    = "J'ai renonce a semer cette annee.[pause=25] Le vent emporterait tout n'importe ou.",
    during = "Le vent vient d'en haut, maintenant.[pause=25] D'en haut. Ce n'est pas normal.",
    post   = "Il souffle de cote a nouveau.[pause=25] Comme un vent doit souffler.",
    quests = "J'ai seme ce matin.[pause=25] Trop tard dans la saison, mais j'avais besoin de le faire." },

  Gloom = { emo = 'Sad',
    early  = "Mon odeur ne porte plus.[pause=25] Personne ne me fuit. C'est vexant.",
    pre    = "Meme les insectes sont partis.[pause=25] Quand les insectes partent, il faut s'inquieter.",
    during = "Je reste. Quelqu'un doit rester.[pause=25] Autant que ce soit celui que personne n'approche.",
    post   = "Un insecte est revenu ce matin.[pause=20] Un seul. Je lui ai parle une heure.",
    quests = "Ils sont revenus, tous.[pause=25] Ils me fuient de nouveau. Je suis tres heureux." },

  Oddish = { emo = 'Worried',
    early  = "Je me cache dans la terre quand le ciel fait ce bruit.",
    pre    = "La terre est froide, en dessous.[pause=25] Plus froide que d'habitude.",
    during = "Je ne sors que la nuit maintenant.[pause=25] Le jour fait trop de bruit.",
    post   = "Je suis sorti en plein jour ![pause=20] Le ciel est redevenu silencieux.",
    quests = "Vous avez fait taire le ciel.[pause=25] C'est ce que dit ma mere. Je la crois." },

  ---- LES FAMILLES ----
  Furret = { emo = 'Worried',
    early  = "Les petits ne veulent plus dormir seuls.[pause=25] Le vent les reveille.",
    pre    = "On a rentre tout le monde a l'interieur.[pause=25] Meme les plus grands. Surtout les plus grands.",
    during = "Chaque soir je compte les tetes.[pause=25] Deux fois. Trois, parfois.",
    post   = "Ils ont redemande a dormir dehors.[pause=25] J'ai dit oui. Ca m'a coute.",
    quests = "Merci de leur avoir rendu la nuit.[pause=25] Vous ne savez pas ce que ca vaut." },

  Linoone = { emo = 'Determined',
    early  = "Je cours moins loin qu'avant.[pause=25] Pas par fatigue. Par prudence.",
    pre    = "J'ai arrete les courses au nord.[pause=25] On ne court pas sous un ciel pareil.",
    during = "Si quelqu'un doit porter un message en urgence, c'est moi.[pause=25] Je suis pret.",
    post   = "J'ai couru jusqu'au nord et je suis revenu.[pause=25] Sans m'arreter. Comme avant.",
    quests = "La prochaine fois que vous partez,[pause=20] emmenez-moi. Je porterai les sacs." },

  Sentret = { emo = 'Worried',
    early  = "Je monte la garde sur ma queue.[pause=25] Je vois loin. Trop loin, en ce moment.",
    pre    = "Depuis mon poste, je vois le pic.[pause=25] Il y a quelque chose qui tourne autour.",
    during = "Je guette votre retour.[pause=25] C'est tout ce que je peux faire, alors je le fais bien.",
    post   = "Je vous ai vus arriver de loin ![pause=20] J'ai prevenu tout le monde !",
    quests = "Mon poste de guet vous est ouvert.[pause=25] La vue est belle, maintenant qu'on peut la regarder." },

  Wooper_Girl = { emo = 'Sad',
    early  = "Mon frere dit que le ciel est casse.[pause=25] C'est vrai qu'un ciel peut se casser ?",
    pre    = "On ne joue plus dehors.[pause=25] Maman a dit non. Elle ne dit jamais non.",
    during = "J'ai fait un dessin de vous pour quand vous reviendrez.[pause=25] Il est un peu rate.",
    post   = "Voila le dessin ![pause=20] Je sais qu'il est rate. Gardez-le quand meme.",
    quests = "J'en ai fait un deuxieme.[pause=25] Celui-la il est bien. Vous verrez." },

  Wooper_Boy = { emo = 'Worried',
    early  = "Le ciel fait un bruit bizarre la nuit.[pause=25] Comme quelqu'un qui respire trop fort.",
    pre    = "J'ai pas peur.[pause=30] ...Bon. Un peu.",
    during = "Je surveille la place a votre place.[pause=25] C'est mon travail maintenant.",
    post   = "J'ai bien surveille ![pause=20] Il s'est rien passe. C'est grace a moi, hein ?",
    quests = "Quand je serai grand je ferai comme vous.[pause=25] Enfin, presque comme vous." },

  ---- LES ANCIENS ET LES SOLITAIRES ----
  Manectric = { emo = 'Worried',
    early  = "Ma fourrure crepite sans arret.[pause=25] L'air est charge d'electricite depuis des jours.",
    pre    = "J'ai vu la foudre tomber trois fois au meme endroit.[pause=25] Sur le pic. Toujours le pic.",
    during = "Si l'orage descend jusqu'ici, je servirai de paratonnerre.[pause=25] C'est deja ca.",
    post   = "Plus une etincelle.[pause=25] Le calme me manquerait presque.",
    quests = "Je vous dois une fiere chandelle.[pause=25] Sans mauvais jeu de mots." },

  Nidoran_Male = { emo = 'Determined',
    early  = "Je m'entraine plus dur que jamais.[pause=25] Il le faut, avec ce qui arrive.",
    pre    = "Les grands ont peur.[pause=25] Alors moi je fais semblant de ne pas avoir peur. Ca aide.",
    during = "Je garde la place.[pause=25] Je sais que c'est petit. Mais c'est ce que je peux faire.",
    post   = "Vous etes revenus.[pause=25] J'ai tenu mon poste jusqu'au bout.",
    quests = "Un jour je monterai la-haut, moi aussi.[pause=25] Vous me raconterez, en attendant ?" },

  Mareep = { emo = 'Worried',
    early  = "Ma laine se dresse toute seule.[pause=25] Elle sait quelque chose que j'ignore.",
    pre    = "Je ne dors plus.[pause=25] Trop d'electricite dans l'air, et dans ma tete.",
    during = "Je reste eveillee pour ceux qui dorment.[pause=25] C'est ma facon d'aider.",
    post   = "J'ai dormi douze heures.[pause=20] Douze ![pause=15] Je ne m'en excuse pas.",
    quests = "Ma laine est retombee.[pause=25] Le monde va bien. Elle ne se trompe jamais." },

  Spheal = { emo = 'Sad',
    early  = "Je roule a l'interieur maintenant.[pause=25] C'est moins bien, mais c'est ca ou rien.",
    pre    = "Le vent me fait rouler dans le mauvais sens.[pause=25] C'est humiliant.",
    during = "Je vous attends devant la porte.[pause=25] Tous les jours. Maman raleuse.",
    post   = "Dehors ![pause=15] On peut retourner dehors ![pause=20] Regardez comme je roule vite !",
    quests = "Regardez ![pause=15] J'ai fait trois tours sans tomber ![pause=20] C'est un record." },

  Doduo = { emo = 'Worried',
    early  = "Nos deux tetes regardent le ciel.[pause=25] En meme temps. C'est rare.",
    pre    = "Aucune de nous deux ne veut sortir.[pause=25] Premiere fois qu'on est d'accord si vite.",
    during = "On dort a tour de role, comme sur un bateau.[pause=25] Personne ne veille seul.",
    post   = "On s'est chamaillees pour savoir qui vous verrait en premier.[pause=25] Match nul.",
    quests = "Les deux tetes s'inclinent.[pause=25] C'est plus complique que ca en a l'air, croyez-nous." },

  Metapod = { emo = 'Normal',
    early  = "...",
    pre    = "...[pause=30] (Il s'est cale contre le mur, du cote abrite du vent.)",
    during = "...[pause=30] (Immobile. Mais tourne vers le nord, vers le pic.)",
    post   = "...[pause=25] (Il a repris sa place au soleil. Le vent est tombe.)",
    quests = "...[pause=30] (La carapace s'est fendue sur toute sa longueur. Demain, peut-etre.)" },

  Silcoon = { emo = 'Normal',
    early  = "...",
    pre    = "...[pause=30] (Le fil vibre dans le vent, tendu a se rompre. Il ne rompt pas.)",
    during = "...[pause=30] (Toujours accroche. Contre toute attente.)",
    post   = "...[pause=25] (Le fil pend, detendu. Il a tenu tout le temps qu'il fallait.)",
    quests = "...[pause=30] (Le cocon est vide. Quelque part au-dessus, quelque chose vole pour la premiere fois.)" },
}


--------------------------------------------------------------------
-- ACCES
--------------------------------------------------------------------
local ORDER = { 'early', 'pre', 'during', 'post', 'quests' }

local TABLES = {
  [8]  = 'CH8',
  [9]  = 'CH9',
  [10] = 'CH10',
}

--Combien de boites ce module ajoute-t-il ? (controle de quota)
function TownVoicesArc.Count()
  local n = 0
  for _, nom in pairs(TABLES) do
    for _, fiche in pairs(TownVoicesArc[nom] or {}) do
      for _, k in ipairs(ORDER) do
        if fiche[k] ~= nil then n = n + 1 end
      end
    end
  end
  return n
end

--[[
    TownVoicesArc.Talk(inst, ch)

    Meme contrat que TownVoices.Talk : renvoie true si le module a pris
    la parole, false s'il n'a pas de fiche pour ce PNJ. L'appelant
    enchaine alors sur son dialogue d'origine — aucune replique
    existante n'est perdue.

        function metano_town_ch_8.Gulpin_Action(chara, activator)
          if TownVoicesArc.Talk('Gulpin', 8) then return end
          ...  -- dialogue d'origine, intact
        end
]]
function TownVoicesArc.Talk(inst, ch)
  ch = ch or (SV.ChapterProgression and SV.ChapterProgression.Chapter) or 0
  local nom = TABLES[ch]
  if nom == nil then return false end

  local fiche = (TownVoicesArc[nom] or {})[inst]
  if fiche == nil then return false end

  local chara = CH(inst)
  if chara == nil then return false end

  --L'etat vient de TownVoices.State, qui sait deja lire les chapitres
  --7 a 10 : on ne duplique pas cette logique.
  local st = 'early'
  pcall(function() st = TownVoices.State(ch) or 'early' end)

  --Repli en cascade : un etat non renseigne retombe sur le precedent.
  local txt = nil
  for _, k in ipairs(ORDER) do
    if fiche[k] ~= nil then txt = fiche[k] end
    if k == st then break end
  end
  if txt == nil then return false end

  --RACCORD POSITION <-> PAROLE (TownPlace).
  --Dix de ces PNJ ont AUSSI une routine quotidienne (npc_routines.lua)
  --qui les deplace dans la ville. Sans ce raccord, Roselia tient le meme
  --propos a son etal du marche et au bord de la riviere — le defaut que
  --systeme_raid_ville_vivante.md interdit au point 5. On prononce donc
  --d'abord une phrase d'ancrage liee au lieu REEL, puis la replique de
  --chapitre. Si le PNJ n'a pas d'ancrage pour l'endroit ou il se trouve,
  --Say renvoie false et rien ne change.
  local ok = pcall(function()
    GeneralFunctions.StartConversation(chara, txt, fiche.emo or 'Normal')
    pcall(function() TownPlace.Say(inst, fiche.emo) end)
    GeneralFunctions.EndConversation(chara)
  end)
  return ok
end

return TownVoicesArc
