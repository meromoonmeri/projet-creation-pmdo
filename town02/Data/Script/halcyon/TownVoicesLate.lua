--[[
    TownVoicesLate.lua

    LA VILLE PARLE — CHAPITRES 7 A 10
    ================================================================
    POURQUOI CE MODULE
    ------------------------------------------------------------------
    TownVoices.lua ne couvrait que le chapitre 6 : 26 habitants qui
    reagissent a l'avancement. Passe le ch6, tous ces PNJ retombaient
    sur leur replique de chapitre, unique et figee.

    Mesure a l'appui (tools/count_dialogue.py) :
        ch5 : 1480 boites   ch6 : 297
        ch7 :  293          ch8 : 220
        ch9 :  199          ch10 : 152

    Les quatre derniers chapitres sont les plus pauvres du jeu, alors
    qu'ils portent la fin de l'histoire. Ce module y ajoute 26 habitants
    x 4 chapitres x 4 paliers.

    ------------------------------------------------------------------
    LES PALIERS VIENNENT DU CODE, PAS D'UNE INVENTION
    ------------------------------------------------------------------
    TownVoices.State() a ete etendu en lisant Ch7State..Ch10State dans
    les fichiers de chapitre. Les champs testes existent tous :

      ch7  RuinsAddressGiven / EnteredRuins / DefeatedRuinsBoss /
           HeardGenesisTale     -> les Ruines, puis le recit des origines
      ch8  CrystalAddressGiven / EnteredSanctuary / DefeatedDiancie /
           ObtainedCrystalFragment -> le Sanctuaire et son fragment
      ch9  MarshAddressGiven / EnteredMarsh / DefeatedMegaBlastoise /
           PurifiedMarshCore    -> le Marais et le Cercle
      ch10 PeakAddressGiven / EnteredPeak / DefeatedLugia /
           SawNecrozmaVision    -> le Pic, la fin

    ------------------------------------------------------------------
    PRINCIPE D'ECRITURE
    ------------------------------------------------------------------
    Chacun parle de SON metier et de SA vie. Un marchand compte son
    stock, un enfant repete ce qu'il a entendu, un ancien compare avec
    avant. Personne ne resume l'intrigue : la ville ne SAIT pas ce que
    fait le heros, elle en per�oit les effets. C'est ce decalage qui
    rend le monde vivant plutot que decoratif.

    Progression d'ensemble voulue sur les 4 chapitres : de l'inquietude
    diffuse (ch7) a la peur nommee (ch9), puis au calme etrange de ceux
    qui ignorent que tout se joue au-dessus d'eux (ch10).

    ------------------------------------------------------------------
    REGLES DU PROJET
    ------------------------------------------------------------------
    * Jamais « Necrozma », « Eternatus », « l'Abime », « prison ».
    * La Voix ne parle jamais en ville.
    * Ne nomme aucun personnage des jeux d'origine.
    * Module global -> texte litteral francais.
    * 1 a 2 phrases par boite, < 150 caracteres hors [pause=N].
    * Aucune replique existante n'est supprimee : ce module s'ajoute en
      amont et rend la main si le PNJ n'a pas de fiche.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.TownVoices'

TownVoicesLate = {}

--------------------------------------------------------------------
-- LES FICHES
--------------------------------------------------------------------
-- [chapitre][Instance] = { emo, pre, during, post, quests }
-- Un palier absent retombe sur le precedent renseigne.
TownVoicesLate.FICHES = {}

--====================================================================
-- CHAPITRE 7 — LES AEGIS CAVE, PUIS LE RECIT DES ORIGINES
--====================================================================
-- Registre : l'inquietude qu'on n'ose pas nommer. La ville sent que
-- quelque chose a change mais met ca sur le compte du temps, des
-- recoltes, de la fatigue. Personne ne fait le lien.
TownVoicesLate.FICHES[7] = {

  Gulpin = { emo = 'Happy',
    pre    = "On dit qu'il y a des ruines à l'est.[pause=25] Moi je dis qu'il y a surtout des baies.",
    during = "Vous partez fouiller de vieilles pierres ?[pause=30] Rapportez-moi quelque chose de comestible.",
    post   = "Vous êtes revenus entiers ![pause=25] Ça mérite un repas. Je m'occupe du repas.",
    quests = "Vous avez la tête de quelqu'un qui a appris une mauvaise nouvelle.[pause=30] Mangez d'abord." },

  Lickitung = { emo = 'Normal',
    pre    = "Les livraisons arrivent, mais moins vite qu'avant.[pause=25] Les routes fatiguent.",
    during = "J'ai gardé votre part au chaud.[pause=25] Comme toujours.",
    post   = "Asseyez-vous.[pause=30] Vous avez l'air d'avoir marché sur de la pierre toute la journée.",
    quests = "Vous ne mangez presque rien depuis hier.[pause=30] Ce n'est pas la faim qui manque, hein." },

  Bellossom = { emo = 'Worried',
    pre    = "Mes fleurs de l'est se fanent plus vite.[pause=25] Toujours celles de l'est.",
    during = "Le sol par là-bas ne veut plus rien donner.[pause=30] Ça date d'avant vous, rassurez-vous.",
    post   = "Elles ont repris un peu de couleur, ce matin.[pause=25] Un peu.",
    quests = "Ma grand-mère parlait d'un temps où rien ne poussait.[pause=30] Je croyais que c'était une histoire." },

  Roselia = { emo = 'Sad',
    pre    = "Je ne cueille plus près des ruines.[pause=25] Ce n'est pas interdit. C'est juste que je n'y vais plus.",
    during = "Faites attention aux pierres qui bougent.[pause=30] Elles bougent, là-bas. Je l'ai vu.",
    post   = "Vous y êtes allés, et vous êtes revenus.[pause=25] Ça change quelque chose, de savoir ça.",
    quests = "Vous avez appris quelque chose là-bas.[pause=30] Ça se voit à la façon dont vous regardez la ville." },

  Wooper_Boy = { emo = 'Happy',
    pre    = "On joue aux explorateurs de ruines ![pause=20] Moi je suis la statue !",
    during = "Papa dit que les vieilles pierres, ça porte malheur.[pause=25] Moi je trouve ça classe.",
    post   = "Vous avez vu des monstres de pierre ?![pause=25] DES VRAIS ?",
    quests = "Pourquoi vous parlez tout bas, les grands ?[pause=30] Depuis hier vous parlez tout bas." },

  Wooper_Girl = { emo = 'Worried',
    pre    = "J'ai fait un rêve bizarre.[pause=25] Y avait plus de couleurs nulle part.",
    during = "J'ai refait le même rêve.[pause=30] Deux fois, c'est beaucoup, non ?",
    post   = "Cette nuit j'ai bien dormi ![pause=25] Enfin.",
    quests = "Mon frère dit que les rêves ça veut rien dire.[pause=30] Mais lui aussi il en fait." },

  Marill = { emo = 'Normal',
    pre    = "L'eau de la rivière est plus froide que d'habitude.[pause=25] En cette saison, c'est étrange.",
    during = "J'ai remonté le courant jusqu'aux ruines.[pause=30] Je ne suis pas allée plus loin.",
    post   = "L'eau est redevenue normale.[pause=25] Ou alors je m'y suis habituée.",
    quests = "Vous savez ce qui se passe, vous.[pause=30] Ne me dites rien. Je préfère ne pas savoir." },

  Nidoking = { emo = 'Normal',
    pre    = "Des ruines ?[pause=25] J'ai passé ma jeunesse à en explorer. Elles étaient vides.",
    during = "Si vous y allez, allez-y à deux.[pause=30] Ce genre d'endroit, on n'y va jamais seul.",
    post   = "Vous en avez tiré quelque chose ?[pause=25] Moi je n'en ai jamais rien tiré.",
    quests = "Tout le monde a l'air ailleurs, ces jours-ci.[pause=30] Moi le premier." },

  Nidorina = { emo = 'Happy',
    pre    = "Papa raconte ses vieilles expéditions.[pause=25] Pour la centième fois.",
    during = "Il dit qu'il vous accompagnerait, s'il avait vingt ans de moins.",
    post   = "Il n'a rien dit quand vous êtes rentrés.[pause=30] Mais il a souri. Ça n'arrive jamais.",
    quests = "Papa a ressorti son vieux sac du grenier.[pause=25] Il ne veut pas dire pourquoi." },

  Medicham = { emo = 'Normal',
    pre    = "L'air est chargé, ces temps-ci.[pause=25] Je le sens en méditant.",
    during = "Vers l'est, la sensation est plus forte.[pause=30] Comme une note tenue trop longtemps.",
    post   = "C'est plus calme depuis hier.[pause=25] Merci. Je ne sais pas de quoi, mais merci.",
    quests = "Vous portez quelque chose de lourd.[pause=30] Pas dans votre sac. Ailleurs." },

  Machamp = { emo = 'Happy',
    pre    = "Besoin de bras pour déplacer des pierres ?[pause=25] Je suis là.",
    during = "Vous auriez dû m'emmener ![pause=30] J'aurais soulevé ce qu'il fallait soulever.",
    post   = "Alors, ces pierres ?[pause=25] Lourdes ? Plus lourdes que moi ?",
    quests = "Vous avez l'air fatigués d'une fatigue que je connais pas.[pause=30] La mienne se soigne en dormant." },

  Manectric = { emo = 'Worried',
    pre    = "Je ne patrouille plus jusqu'aux ruines.[pause=25] Ordre de la guilde.",
    during = "Bonne chance.[pause=30] Et si vous entendez quelque chose derrière vous, ne vous retournez pas pour vérifier.",
    post   = "Le secteur est calme.[pause=25] Je le note au registre depuis trois jours.",
    quests = "Trois jours de calme.[pause=30] D'habitude ça me rassure." },

  Luxray = { emo = 'Normal',
    pre    = "Je vois loin, la nuit.[pause=25] Vers l'est, je ne vois rien du tout. C'est ça qui cloche.",
    during = "Une zone sans lumière, ça existe.[pause=30] Une zone sans OMBRE, non.",
    post   = "Les ombres sont revenues à l'est.[pause=25] Vous n'imaginez pas comme ça soulage.",
    quests = "Vous avez vu quelque chose là-bas.[pause=30] Vos yeux ne mentent pas mieux que les miens." },

  Spinda = { emo = 'Normal',
    pre    = "J'ai la tête qui tourne.[pause=25] Bon, ça, c'est tous les jours.",
    during = "Ce matin elle tournait dans l'autre sens ![pause=30] Nouveauté.",
    post   = "Tout est redevenu normalement bizarre.[pause=25] C'est déjà ça.",
    quests = "Les gens me trouvent bizarre.[pause=30] Mais eux, ces jours-ci, ils sont pires que moi." },

  Ludicolo = { emo = 'Happy',
    pre    = "La musique porte moins loin qu'avant.[pause=25] L'air est plus épais, je crois.",
    during = "Je joue quand même ![pause=25] Il faut bien que quelqu'un fasse du bruit.",
    post   = "Ce soir, je joue fort ![pause=30] Vous êtes rentrés, c'est une raison suffisante.",
    quests = "Vous ne dansez pas.[pause=30] D'habitude vous ne dansez pas non plus, mais là c'est différent." },

  Jigglypuff = { emo = 'Normal',
    pre    = "Ma voix résonne mal en ce moment.[pause=25] Comme si quelque chose l'avalait.",
    during = "J'ai chanté vers l'est hier soir.[pause=30] Aucun écho. Aucun.",
    post   = "L'écho est revenu ![pause=25] Écoutez : il est revenu !",
    quests = "Je chante pour que les gens dorment mieux.[pause=30] En ce moment, j'ai beaucoup de travail." },

  Vileplume = { emo = 'Worried',
    pre    = "Mon parfum ne porte plus au-delà de la place.[pause=25] Avant, il allait jusqu'au pont.",
    during = "Quelque chose absorbe ce que j'envoie.[pause=30] Je n'aime pas ça du tout.",
    post   = "Il porte de nouveau jusqu'au pont.[pause=25] Tout va bien, alors.",
    quests = "Ce qui absorbait n'a pas disparu.[pause=30] Il s'est juste éloigné. Je le sens encore." },

  Gloom = { emo = 'Sad',
    pre    = "J'ai peur des ruines.[pause=25] J'ai peur de beaucoup de choses, remarquez.",
    during = "Vous y allez vraiment ?[pause=30] Vous êtes courageux. Ou alors vous n'avez pas le choix.",
    post   = "Vous voilà ![pause=25] J'ai eu peur pour vous. Ça change, d'avoir peur pour quelqu'un d'autre.",
    quests = "Depuis que vous êtes rentrés, tout le monde chuchote.[pause=30] Ça me fait plus peur que les ruines." },

  Oddish = { emo = 'Worried',
    pre    = "La terre est dure vers l'est.[pause=25] Je n'arrive plus à m'y enfouir.",
    during = "Dure comme de la pierre.[pause=30] Alors que c'est de la terre. Je sais faire la différence.",
    post   = "Elle est redevenue meuble.[pause=25] J'ai vérifié ce matin, deux fois.",
    quests = "La terre se souvient de ce qu'on lui fait.[pause=30] C'est ma grand-mère qui disait ça." },

  Furret = { emo = 'Normal',
    pre    = "Les terriers de l'est sont vides.[pause=25] Tout le monde a déménagé vers la rivière.",
    during = "Personne ne me dit pourquoi.[pause=30] Ils haussent les épaules et ils continuent de creuser ailleurs.",
    post   = "Deux familles sont rentrées chez elles.[pause=25] Deux, sur onze.",
    quests = "Les autres attendent.[pause=30] Ils disent qu'ils attendent d'être sûrs." },

  Linoone = { emo = 'Happy',
    pre    = "J'ai couru jusqu'aux ruines une fois ![pause=25] Je ne suis pas entré, hein.",
    during = "Je vous escorterais bien, mais je cours plus vite que je ne réfléchis.",
    post   = "Vous avez mis combien de temps ?[pause=25] Non, ne dites rien. Je serais vexé.",
    quests = "Je cours partout depuis ce matin.[pause=30] Ça m'empêche de penser. C'est fait exprès." },

  Sentret = { emo = 'Worried',
    pre    = "Je monte la garde sur ma queue.[pause=25] Vers l'est, surtout.",
    during = "Rien à signaler.[pause=30] Mais je regarde quand même. C'est mon rôle.",
    post   = "Toujours rien à signaler ![pause=25] Et pour une fois ça veut dire quelque chose.",
    quests = "Je surveille depuis des années.[pause=30] Je ne savais pas ce que je surveillais. Maintenant non plus." },

  Cranidos = { emo = 'Happy',
    pre    = "La guilde envoie une équipe aux ruines ![pause=25] J'ai demandé. On m'a dit non.",
    during = "Vous avez de la chance ![pause=30] Moi je reste à trier des rapports.",
    post   = "Racontez-moi tout ![pause=25] Non, attendez. Racontez au rapport d'abord.",
    quests = "Le maître de guilde a lu votre rapport deux fois.[pause=30] Deux fois. Il ne fait jamais ça." },

  Mareep = { emo = 'Normal',
    pre    = "Ma laine crépite plus que d'habitude.[pause=25] Il y a quelque chose dans l'air.",
    during = "Elle crépite surtout quand je regarde vers l'est.[pause=30] Ce n'est pas dans ma tête.",
    post   = "Plus rien.[pause=25] Ma laine est calme. Je peux enfin dormir contre un mur.",
    quests = "Ça reviendra, hein ?[pause=30] Ce genre de chose, ça revient toujours." },

  Metapod = { emo = 'Normal',
    pre    = "Je ne bouge pas.[pause=25] Mais j'entends. Et en ce moment, j'entends mal.",
    during = "Un bruit de fond, très bas.[pause=30] Depuis des jours. Personne d'autre ne l'entend.",
    post   = "Il s'est arrêté hier.[pause=25] Vers midi. J'ai noté l'heure. Enfin, j'ai retenu.",
    quests = "Il n'a pas disparu.[pause=30] Il s'est déplacé. Vers le nord, je crois." },

  Silcoon = { emo = 'Worried',
    pre    = "On est deux à ne pas pouvoir fuir.[pause=25] Ça rapproche.",
    during = "Si quelque chose arrive, on ne pourra rien faire.[pause=30] Alors on attend. Ensemble.",
    post   = "Vous êtes rentrés.[pause=25] On a arrêté de compter les heures.",
    quests = "Quand on ne peut pas bouger, on apprend à écouter.[pause=30] Et on entend beaucoup de choses." },
}

--====================================================================
-- CHAPITRE 8 — LE SANCTUAIRE DE CRISTAL
--====================================================================
-- Registre : la beaute qui met mal a l'aise. La ville voit des reflets,
-- des lumieres, une eau trop claire. Tout est plus beau, et c'est ca
-- qui inquiete.
TownVoicesLate.FICHES[8] = {

  Gulpin = { emo = 'Happy',
    pre    = "L'eau du puits a un goût de pierre.[pause=25] Un bon goût, remarquez.",
    during = "Vous partez dans une grotte qui brille ?[pause=30] Rapportez-moi un caillou qui brille.",
    post   = "Vous en avez rapporté un vrai ![pause=25] Je ne le mangerai pas. Promis.",
    quests = "Ce caillou-là, je ne le toucherais pas.[pause=30] Et pourtant je touche à tout." },

  Lickitung = { emo = 'Normal',
    pre    = "Les casseroles renvoient la lumière autrement, ce matin.[pause=25] Vous trouvez pas ?",
    during = "Tout brille trop dans ma cuisine.[pause=30] J'ai fermé les volets. Ça va mieux.",
    post   = "Vous rapportez de la lumière avec vous.[pause=25] Ce n'est pas une image, je le vois.",
    quests = "Posez ce que vous portez avant de manger.[pause=30] S'il vous plaît. Posez-le dehors." },

  Bellossom = { emo = 'Happy',
    pre    = "Mes fleurs se tournent vers le nord.[pause=25] Toutes. Alors que le soleil est à l'ouest.",
    during = "Elles se tournent toujours vers le nord.[pause=30] Je ne les force pas, hein.",
    post   = "Elles ont recommencé à suivre le soleil ![pause=25] Enfin des fleurs normales.",
    quests = "Une fleur qui cherche autre chose que le soleil...[pause=30] ça devrait pas exister." },

  Roselia = { emo = 'Worried',
    pre    = "Il y a des reflets sur les hauteurs, au nord.[pause=25] Toute la journée, pas seulement au couchant.",
    during = "J'ai monté un peu, hier.[pause=30] La lumière ne venait pas du ciel. Elle venait du sol.",
    post   = "Les reflets ont baissé.[pause=25] Pas disparu. Baissé.",
    quests = "Ce que vous portez fait la même lumière.[pause=30] La même exactement. Faites attention." },

  Wooper_Boy = { emo = 'Happy',
    pre    = "Y a des étoiles dans la montagne ![pause=20] Je les ai vues !",
    during = "Maman dit que c'est le soleil.[pause=25] Le soleil il fait pas ça la nuit !",
    post   = "Vous avez ramené une étoile ?![pause=25] Montrez ! Montrez !",
    quests = "Elle est jolie, votre étoile.[pause=30] Pourquoi vous faites cette tête, alors ?" },

  Wooper_Girl = { emo = 'Normal',
    pre    = "J'ai vu mon reflet dans la flaque.[pause=25] Il a bougé avant moi.",
    during = "J'ai regardé encore.[pause=30] Cette fois il a bougé après. C'est pire.",
    post   = "Les flaques sont redevenues des flaques ![pause=25] Ouf.",
    quests = "Je ne regarde plus dans l'eau.[pause=30] Ni dans les vitres. Ni nulle part." },

  Marill = { emo = 'Surprised',
    pre    = "La rivière est claire comme jamais.[pause=25] On voit le fond. TOUT le fond.",
    during = "Trop claire.[pause=30] Une rivière, ça doit garder un peu de mystère.",
    post   = "Elle est redevenue trouble.[pause=25] Ça m'a manqué, figurez-vous.",
    quests = "Quand l'eau devient un miroir,[pause=25] on n'y voit plus les poissons. On s'y voit soi." },

  Nidoking = { emo = 'Normal',
    pre    = "Un sanctuaire dans la montagne ?[pause=25] J'en ai entendu parler. Jamais trouvé.",
    during = "Si vous entrez, comptez vos pas.[pause=30] Dans ces endroits-là, on perd le compte.",
    post   = "Vous l'avez trouvé.[pause=25] Moi j'ai cherché douze ans. Bravo, sincèrement.",
    quests = "Ce que vous rapportez n'était pas fait pour sortir.[pause=30] Je le sais. Je ne sais pas comment, mais je le sais." },

  Nidorina = { emo = 'Happy',
    pre    = "Papa a ressorti ses vieilles cartes ![pause=25] Il cherche un sanctuaire.",
    during = "Il n'a pas dormi.[pause=30] Il compare vos itinéraires avec les siens.",
    post   = "Il a rangé les cartes ce matin.[pause=25] Sans rien dire. Je crois qu'il est content.",
    quests = "Il a dit une chose bizarre hier.[pause=30] « Certaines portes, on ferait mieux de les laisser fermées. »" },

  Medicham = { emo = 'Normal',
    pre    = "Le silence est plus dense au nord.[pause=25] Un silence qui a du poids.",
    during = "J'ai médité face à la montagne.[pause=30] Pour la première fois, je n'ai rien entendu du tout.",
    post   = "Le silence s'est allégé.[pause=25] Vous avez ouvert quelque chose, là-haut.",
    quests = "Ce que vous portez respire.[pause=30] Lentement. Mais ça respire." },

  Machamp = { emo = 'Happy',
    pre    = "Une grotte de cristal ?[pause=25] Un bon coup de poing et on saura ce qu'il y a dedans.",
    during = "Je plaisantais pour le coup de poing.[pause=30] À moitié.",
    post   = "Alors, c'était solide ?[pause=25] Plus solide que ma tête ?",
    quests = "Rangez ce truc.[pause=30] Il me donne mal au crâne, et j'ai un crâne très épais." },

  Manectric = { emo = 'Worried',
    pre    = "Ma fourrure se dresse quand je vais vers le nord.[pause=25] Statique, sûrement.",
    during = "Ce n'est pas de la statique.[pause=30] La statique, ça pique. Là, c'est autre chose.",
    post   = "Elle est retombée.[pause=25] Enfin je peux patrouiller sans ressembler à un buisson.",
    quests = "Elle se redresse quand vous passez, maintenant.[pause=30] Vous voyez le problème." },

  Luxray = { emo = 'Surprised',
    pre    = "Je vois à travers beaucoup de choses.[pause=25] Pas à travers ce qui brille au nord.",
    during = "Mon regard rebondit dessus.[pause=30] Ça ne m'était jamais arrivé.",
    post   = "Je vois de nouveau à travers la montagne.[pause=25] Enfin, à travers la roche.",
    quests = "Votre fragment, lui, je n'y vois rien.[pause=30] Absolument rien. Et pourtant je regarde." },

  Spinda = { emo = 'Happy',
    pre    = "Tout brille en double aujourd'hui ![pause=25] D'habitude c'est juste flou.",
    during = "En triple maintenant ![pause=30] Je progresse !",
    post   = "Retour au flou normal.[pause=25] C'était joli, le triple.",
    quests = "Vous avez un truc qui brille.[pause=30] Il brille pareil que je ferme les yeux ou pas." },

  Ludicolo = { emo = 'Happy',
    pre    = "Les notes résonnent plus longtemps, ces jours-ci ![pause=25] L'air porte mieux.",
    during = "J'ai joué toute la nuit sans me fatiguer.[pause=30] Ça n'a aucun sens.",
    post   = "L'air est redevenu normal.[pause=25] Je me fatigue de nouveau. Tant mieux.",
    quests = "Approchez votre caillou de mon instrument.[pause=30] ...Non. Non, en fait, ne faites pas ça." },

  Jigglypuff = { emo = 'Surprised',
    pre    = "Ma voix revient vers moi.[pause=25] Comme si quelqu'un me la renvoyait.",
    during = "J'ai chanté vers la montagne.[pause=30] La montagne a chanté après moi. Deux secondes après.",
    post   = "Plus d'écho bizarre.[pause=25] Je chante, ça s'arrête. Comme avant.",
    quests = "Chantez près de votre fragment.[pause=30] Vous verrez. Ou plutôt : vous entendrez." },

  Vileplume = { emo = 'Normal',
    pre    = "Mon parfum se dépose au lieu de flotter.[pause=25] Il tombe, en fait.",
    during = "Il forme des motifs au sol.[pause=30] Toujours les mêmes. Des cercles.",
    post   = "Il flotte de nouveau.[pause=25] Les cercles ont disparu.",
    quests = "Les cercles ressemblaient à ce que vous portez.[pause=30] En plus grand. Beaucoup plus grand." },

  Gloom = { emo = 'Worried',
    pre    = "Je préfère l'ombre.[pause=25] En ce moment il n'y a plus assez d'ombre.",
    during = "Tout est éclairé.[pause=30] Même la nuit. Je n'ai nulle part où me mettre.",
    post   = "L'ombre est revenue ![pause=25] Vous ne pouvez pas savoir ce que ça fait.",
    quests = "Votre fragment ne fait pas d'ombre.[pause=30] Regardez par terre. Il n'en fait pas." },

  Oddish = { emo = 'Normal',
    pre    = "La terre est tiède au nord.[pause=25] Pas chaude. Tiède. C'est différent.",
    during = "Tiède comme quelque chose de vivant.[pause=30] Voilà, je l'ai dit.",
    post   = "Elle a refroidi.[pause=25] La terre normale est froide. C'est rassurant, le froid.",
    quests = "Votre pierre est tiède aussi.[pause=30] Vous ne l'avez pas remarqué ? Vraiment ?" },

  Furret = { emo = 'Happy',
    pre    = "Les terriers du nord sont bien éclairés ![pause=25] Personne ne sait pourquoi.",
    during = "On y voit clair à trois mètres sous terre.[pause=30] Ça devrait pas être possible.",
    post   = "Il fait de nouveau noir sous terre.[pause=25] C'est mieux pour dormir.",
    quests = "Certains regrettent la lumière.[pause=30] Ils disent qu'on s'y habitue vite. Trop vite." },

  Linoone = { emo = 'Happy',
    pre    = "J'ai couru jusqu'aux contreforts ![pause=25] Beau, mais glissant.",
    during = "Ça brille tellement que j'ai raté un virage.[pause=30] Deux fois.",
    post   = "J'ai refait le trajet ce matin.[pause=25] Aucun problème. C'était donc bien la lumière.",
    quests = "Courez avec votre fragment, pour voir.[pause=30] Non ? Bon. Je demandais." },

  Sentret = { emo = 'Surprised',
    pre    = "Je vois des éclats depuis ma queue.[pause=25] Vers le nord, en permanence.",
    during = "Ils clignotent.[pause=30] Régulièrement. Comme un signal.",
    post   = "Ils ont cessé.[pause=25] Juste après votre retour. J'ai vérifié l'heure.",
    quests = "Un signal, ça a un destinataire.[pause=30] Je me demande qui écoutait." },

  Cranidos = { emo = 'Happy',
    pre    = "Un sanctuaire ![pause=25] La guilde n'avait pas envoyé d'équipe là-bas depuis vingt ans.",
    during = "Vingt ans ![pause=30] Et c'est vous qui y allez. J'espère que vous mesurez.",
    post   = "Votre rapport fait douze pages ![pause=25] Le mien en fait deux, d'habitude.",
    quests = "Le maître de guilde a mis votre rapport à part.[pause=30] Pas dans les archives. À part." },

  Mareep = { emo = 'Normal',
    pre    = "Ma laine brille toute seule depuis trois jours.[pause=25] Sans que je fasse rien.",
    during = "Je m'éclaire moi-même, la nuit.[pause=30] Pratique, mais inquiétant.",
    post   = "Elle a arrêté.[pause=25] J'ai ressorti ma lanterne. Tout va bien.",
    quests = "Elle recommence quand vous approchez.[pause=30] Doucement. Mais elle recommence." },

  Metapod = { emo = 'Normal',
    pre    = "Ma coque renvoie la lumière depuis hier.[pause=25] Je ne peux pas la nettoyer, alors je subis.",
    during = "Les gens me confondent avec une lanterne.[pause=30] On m'a posé un chapeau dessus.",
    post   = "Terne de nouveau ![pause=25] Je n'ai jamais été aussi heureux d'être terne.",
    quests = "Ce qui brille attire.[pause=30] Et ce qui attire finit par être trouvé." },

  Silcoon = { emo = 'Worried',
    pre    = "On voit la montagne d'ici.[pause=25] Elle scintille. C'est nouveau.",
    during = "On la regarde toute la journée.[pause=30] On n'a rien d'autre à faire, de toute façon.",
    post   = "Elle ne scintille plus.[pause=25] La journée est moins jolie, mais on dort mieux.",
    quests = "On a compris quelque chose, à force de regarder.[pause=30] Ce qui brille très fort finit par s'éteindre." },
}

--====================================================================
-- CHAPITRE 9 — LE MARAIS DE L'OUBLI
--====================================================================
-- Registre : la peur nommee. Ici la ville a compris qu'il y a quelqu'un
-- en face. On parle d'« eux » sans savoir qui ils sont. C'est le
-- chapitre ou les habitants commencent a fermer leur porte.
TownVoicesLate.FICHES[9] = {

  Gulpin = { emo = 'Worried',
    pre    = "Les livraisons du sud n'arrivent plus.[pause=25] Le marais bloque la route.",
    during = "Trois jours sans livraison.[pause=30] Je mange mes réserves. MES réserves.",
    post   = "La route est rouverte ![pause=25] Vous ne pouvez pas savoir ce que ça représente.",
    quests = "On m'a dit qu'il y avait des gens, là-bas.[pause=30] Des gens qui cherchaient la même chose que vous." },

  Lickitung = { emo = 'Sad',
    pre    = "L'eau a un goût de vase depuis une semaine.[pause=25] Je fais bouillir. Ça ne suffit pas.",
    during = "Je cuisine avec l'eau du puits, maintenant.[pause=30] Il baisse vite, le puits.",
    post   = "L'eau est redevenue potable ![pause=25] Je vous dois un repas. Plusieurs, même.",
    quests = "Vous avez croisé quelqu'un là-bas.[pause=30] Ça se voit. Vous surveillez la porte en mangeant." },

  Bellossom = { emo = 'Sad',
    pre    = "Mes fleurs du sud sont noires.[pause=25] Pas fanées. Noires.",
    during = "J'ai arraché tout le carré.[pause=30] Il fallait le faire. Ça ne m'a pas plu.",
    post   = "J'ai replanté ce matin.[pause=25] On verra bien. C'est tout ce qu'on peut faire.",
    quests = "Quelqu'un est venu me demander où poussaient mes fleurs noires.[pause=30] Je n'ai pas répondu." },

  Roselia = { emo = 'Worried',
    pre    = "Je ne descends plus au sud.[pause=25] Plus du tout. Même pour les meilleures cueillettes.",
    during = "L'odeur monte jusqu'ici certains soirs.[pause=30] Sucrée. Écœurante.",
    post   = "L'odeur a disparu.[pause=25] Je m'y étais habituée, c'est ça le pire.",
    quests = "Il y avait des traces de pas dans mon carré, hier.[pause=30] Pas les miennes." },

  Wooper_Boy = { emo = 'Worried',
    pre    = "On n'a plus le droit d'aller vers le sud.[pause=20] Même pas au pont !",
    during = "Y a des grands qui montent la garde au pont.[pause=25] Ils ont l'air sérieux.",
    post   = "On peut retourner au pont ![pause=25] Enfin, presque. Faut demander.",
    quests = "J'ai vu quelqu'un que je connais pas, hier soir.[pause=30] Il regardait les maisons." },

  Wooper_Girl = { emo = 'Sad',
    pre    = "Maman ferme les volets avant la nuit maintenant.[pause=25] Avant elle les laissait ouverts.",
    during = "Elle les ferme dès le goûter.[pause=30] Il fait tout noir dedans.",
    post   = "Elle les a rouverts ![pause=25] Un peu. Juste ceux de devant.",
    quests = "J'ai demandé pourquoi elle avait peur.[pause=30] Elle a dit qu'elle n'avait pas peur. Elle mentait." },

  Marill = { emo = 'Worried',
    pre    = "La rivière charrie des choses depuis le sud.[pause=25] Des choses que je ne reconnais pas.",
    during = "J'ai arrêté de nager.[pause=30] Moi. J'ai arrêté de nager.",
    post   = "J'ai remis un pied dans l'eau ce matin.[pause=25] Juste un pied. C'est un début.",
    quests = "Ce qui descendait la rivière venait de chez eux.[pause=30] Je ne sais pas qui, mais ça venait de chez quelqu'un." },

  Nidoking = { emo = 'Normal',
    pre    = "Un marais, c'est traître.[pause=25] Le danger n'y est jamais devant vous.",
    during = "Marchez sur les racines, jamais sur la mousse.[pause=30] Ça, c'est gratuit.",
    post   = "Vous avez suivi mon conseil ?[pause=25] Non ? Et vous êtes rentrés quand même. Bien.",
    quests = "Il y a d'autres équipes dehors.[pause=30] Pas de la guilde. J'ai fait le tour de la question." },

  Nidoqueen = { emo = 'Worried',
    pre    = "Je garde les petits à la maison.[pause=25] Ce n'est pas de la peur, c'est du bon sens.",
    during = "Ils s'ennuient.[pause=30] Je préfère qu'ils s'ennuient.",
    post   = "Ils sont ressortis jouer ![pause=25] Merci. Vraiment, merci.",
    quests = "Un inconnu a demandé combien d'enfants vivaient ici.[pause=30] Je n'ai pas aimé la question." },

  Nidorina = { emo = 'Sad',
    pre    = "On reste dedans.[pause=25] Maman a dit non, et quand elle dit non...",
    during = "J'ai fini tous mes jeux.[pause=30] Tous. Vous n'imaginez pas.",
    post   = "Dehors ![pause=25] Enfin dehors !",
    quests = "Maman regarde par la fenêtre tout le temps.[pause=30] Même maintenant. Regardez." },

  Medicham = { emo = 'Worried',
    pre    = "Il y a des présences au sud.[pause=25] Plusieurs. Organisées.",
    during = "Elles se déplacent ensemble.[pause=30] Ce n'est pas une bête. Les bêtes ne s'organisent pas comme ça.",
    post   = "Elles se sont dispersées.[pause=25] Dispersées, pas parties. La nuance compte.",
    quests = "L'une d'elles est passée près de la ville hier.[pause=30] Elle n'est pas entrée. Elle a regardé, et elle est repartie." },

  Machamp = { emo = 'Angry',
    pre    = "Qu'ils viennent.[pause=25] Qu'ils viennent, et on verra.",
    during = "Je monte la garde au pont sud.[pause=30] Volontaire. Personne ne me l'a demandé.",
    post   = "Trois nuits au pont, rien vu.[pause=25] Je suis presque déçu. Presque.",
    quests = "Ils sont passés ailleurs.[pause=30] Pendant que je gardais le pont, ils sont passés ailleurs." },

  Manectric = { emo = 'Worried',
    pre    = "J'ai relevé des traces au sud.[pause=25] Elles ne correspondent à aucune espèce d'ici.",
    during = "Elles vont par groupes de cinq.[pause=30] Toujours cinq. Toujours en ligne.",
    post   = "Les traces s'arrêtent au marais.[pause=25] Elles n'en sortent pas. Ni dans un sens ni dans l'autre.",
    quests = "J'ai retrouvé les mêmes traces au nord, ce matin.[pause=30] Le nord. Pas le sud." },

  Luxray = { emo = 'Worried',
    pre    = "J'ai vu des silhouettes au sud, la nuit.[pause=25] Elles se sont arrêtées quand je les ai fixées.",
    during = "Elles savaient que je les voyais.[pause=30] Elles ont attendu que je détourne les yeux.",
    post   = "Je ne les vois plus.[pause=25] Ça ne veut pas dire qu'elles ne sont plus là.",
    quests = "Vous les avez vues de près, vous.[pause=30] Alors dites-moi : est-ce qu'elles avaient un visage ?" },

  Spinda = { emo = 'Worried',
    pre    = "J'ai la tête qui tourne dans le mauvais sens.[pause=25] Vers le sud, précisément.",
    during = "Je me suis retrouvé face au marais trois fois aujourd'hui.[pause=30] Sans le vouloir.",
    post   = "Je tourne de nouveau n'importe comment ![pause=25] Le désordre, quel bonheur.",
    quests = "Quelque chose m'attirait vers le sud.[pause=30] Moi qui ne vais jamais nulle part exprès." },

  Ludicolo = { emo = 'Sad',
    pre    = "Personne ne danse plus.[pause=25] Je joue quand même, mais personne ne danse.",
    during = "J'ai arrêté hier soir.[pause=30] Jouer pour une place vide, c'est trop triste.",
    post   = "Deux personnes ont dansé ce matin ![pause=25] Deux. C'est reparti.",
    quests = "La musique éloigne certaines choses.[pause=30] C'est ce qu'on dit. Alors je vais rejouer plus fort." },

  Jigglypuff = { emo = 'Worried',
    pre    = "Je chante moins fort.[pause=25] On m'a demandé de chanter moins fort.",
    during = "« Ne les attire pas », qu'ils m'ont dit.[pause=30] Comme si ma voix pouvait attirer quelque chose.",
    post   = "Je peux rechanter normalement ![pause=25] Ma gorge me remercie.",
    quests = "Et si c'était vrai ?[pause=30] Et si ma voix les avait vraiment attirés ?" },

  Vileplume = { emo = 'Sad',
    pre    = "Une odeur remonte du sud.[pause=25] Sucrée. Elle couvre la mienne.",
    during = "Je n'arrive plus à sentir mon propre parfum.[pause=30] Vous savez ce que ça fait ?",
    post   = "Je me sens de nouveau ![pause=25] Ça paraît idiot, mais c'est important.",
    quests = "Cette odeur n'était pas naturelle.[pause=30] Elle était fabriquée. On fabrique une odeur pour cacher autre chose." },

  Gloom = { emo = 'Sad',
    pre    = "J'ai peur, et cette fois j'ai raison d'avoir peur.[pause=25] Ça ne me console pas.",
    during = "Tout le monde a peur maintenant.[pause=30] Je ne suis plus le seul. C'est pire, en fait.",
    post   = "Les gens respirent.[pause=25] Moi aussi, un peu.",
    quests = "Quand tout le monde a peur en même temps,[pause=25] ce n'est plus de la peur. C'est autre chose." },

  Oddish = { emo = 'Worried',
    pre    = "Je ne m'enfouis plus vers le sud.[pause=25] La terre y est molle. Trop molle.",
    during = "On s'enfonce sans pouvoir remonter.[pause=30] J'ai failli. J'ai vraiment failli.",
    post   = "La terre a repris.[pause=25] Elle porte de nouveau. J'ai vérifié partout.",
    quests = "Ce qui rend la terre molle,[pause=25] c'est ce qui pourrit dessous. Et il y avait beaucoup." },

  Furret = { emo = 'Worried',
    pre    = "Onze familles ont quitté le sud.[pause=25] Onze. Je les ai comptées.",
    during = "Elles s'entassent au nord.[pause=30] On dort à cinq dans des terriers pour deux.",
    post   = "Six sont reparties chez elles ![pause=25] Les autres attendent encore.",
    quests = "Certaines ne rentreront pas.[pause=30] Elles disent que le sud ne leur appartient plus." },

  Linoone = { emo = 'Worried',
    pre    = "Je ne cours plus vers le sud.[pause=25] Moi. Je ne cours plus quelque part.",
    during = "J'ai essayé hier.[pause=30] Je me suis arrêté tout seul avant le pont. Mes pattes ont décidé.",
    post   = "J'ai franchi le pont ce matin ![pause=25] Aller-retour. En courant.",
    quests = "Mes pattes savaient quelque chose que je ne savais pas.[pause=30] Je vais les écouter, à l'avenir." },

  Sentret = { emo = 'Worried',
    pre    = "Je surveille le sud jour et nuit.[pause=25] Je me relaie avec deux cousins.",
    during = "On a vu passer quelque chose avant-hier.[pause=30] On a crié. Rien ne s'est arrêté.",
    post   = "Trois nuits calmes.[pause=25] On continue de surveiller quand même.",
    quests = "Un guetteur qui ne voit rien,[pause=25] soit il fait mal son travail, soit on se cache bien de lui." },

  Cranidos = { emo = 'Determined',
    pre    = "La guilde a doublé les patrouilles au sud.[pause=25] C'est du sérieux, cette fois.",
    during = "Je suis de garde ce soir ![pause=30] Enfin quelque chose d'utile.",
    post   = "Patrouille terminée, rien à signaler.[pause=25] Grâce à vous, je suppose.",
    quests = "On nous a demandé de noter les visages inconnus.[pause=30] Les VISAGES. On n'avait jamais fait ça." },

  Mareep = { emo = 'Worried',
    pre    = "Je n'éclaire plus la nuit.[pause=25] On m'a demandé de me faire discrète.",
    during = "Je dors dans le noir complet.[pause=30] Moi qui suis une lampe. Vous imaginez ?",
    post   = "J'ai le droit de briller de nouveau ![pause=25] Un peu. Pas trop fort.",
    quests = "On se cache de quelque chose qui voit dans le noir.[pause=30] Alors se cacher dans le noir, franchement..." },

  Metapod = { emo = 'Worried',
    pre    = "J'entends des pas au sud.[pause=25] Réguliers. Ce ne sont pas des pas d'animal.",
    during = "Ils se sont rapprochés hier.[pause=30] Je ne peux pas bouger. Je vous laisse imaginer.",
    post   = "Ils se sont éloignés.[pause=25] J'ai recommencé à respirer. Façon de parler.",
    quests = "Des pas réguliers, ça veut dire qu'on compte.[pause=30] Et quand on compte, c'est qu'on prépare." },

  Silcoon = { emo = 'Sad',
    pre    = "On est deux, immobiles, face au sud.[pause=25] On voit tout et on ne peut rien faire.",
    during = "Quelque chose est passé devant nous.[pause=30] Ça nous a regardés. Ça a continué son chemin.",
    post   = "On respire.[pause=25] On n'a rien fait, mais on respire.",
    quests = "Ça nous a jugés inoffensifs.[pause=30] C'est vrai. Mais ça fait quelque chose de l'entendre dire." },
}

--====================================================================
-- CHAPITRE 10 — LE PIC CELESTE
--====================================================================
-- Registre : le calme de ceux qui ne savent pas. La ville va bien. Elle
-- se repare, elle rouvre, elle recommence a vivre — pendant que tout se
-- joue au-dessus d'elle. C'est ce contraste qui doit serrer le coeur.
TownVoicesLate.FICHES[10] = {

  Gulpin = { emo = 'Happy',
    pre    = "Les livraisons sont revenues à la normale ![pause=25] Enfin.",
    during = "Vous montez là-haut ?[pause=30] Prenez de quoi manger. On oublie toujours de manger en montagne.",
    post   = "Vous êtes redescendus ![pause=25] Je vous ai gardé une part. La plus grosse.",
    quests = "Vous ne mangez pas.[pause=30] Prenez-la quand même. Pour plus tard." },

  Lickitung = { emo = 'Normal',
    pre    = "Tout est calme.[pause=25] Je n'aime pas beaucoup quand tout est calme.",
    during = "Je cuisine pour votre retour.[pause=30] Je commence maintenant. Ça prendra le temps qu'il faudra.",
    post   = "C'est prêt depuis deux jours ![pause=25] Je réchauffe. Asseyez-vous.",
    quests = "Vous partirez encore, n'est-ce pas.[pause=30] Alors mangez double." },

  Bellossom = { emo = 'Happy',
    pre    = "Tout repousse ![pause=25] Même le carré que j'avais arraché.",
    during = "J'ai planté quelque chose pour votre retour.[pause=30] Ce n'est pas encore sorti. Ça sortira.",
    post   = "Ça a fleuri pendant que vous étiez là-haut ![pause=25] Venez voir. Venez voir tout de suite.",
    quests = "Une fleur qui pousse pendant qu'on regarde ailleurs,[pause=25] c'est la plus jolie de toutes." },

  Roselia = { emo = 'Normal',
    pre    = "Je remonte au nord demain.[pause=25] Première fois depuis des mois.",
    during = "Je vous ai vus partir vers le sommet.[pause=30] Je ne savais pas qu'on pouvait monter si haut.",
    post   = "Vous êtes allés plus haut que tout le monde.[pause=25] Et vous êtes redescendus. C'est ça qui compte.",
    quests = "Rapportez-moi une fleur de là-haut, un jour.[pause=30] S'il en pousse. J'aimerais savoir." },

  Wooper_Boy = { emo = 'Happy',
    pre    = "On rejoue partout ![pause=20] Même près du pont !",
    during = "Vous êtes montés jusqu'aux nuages ?![pause=25] AUX NUAGES ?",
    post   = "Quand je serai grand je monterai aussi ![pause=25] Vous m'emmènerez ?",
    quests = "Vous avez pas l'air content d'être revenus.[pause=30] Moi je serais super content." },

  Wooper_Girl = { emo = 'Happy',
    pre    = "Maman a rouvert tous les volets ![pause=25] Même ceux de derrière.",
    during = "Je regarde la montagne par la fenêtre.[pause=30] Je vous cherche. Je vous vois pas.",
    post   = "Je vous ai vus rentrer ![pause=25] J'ai crié. Personne m'a crue.",
    quests = "Vous allez repartir ?[pause=30] ...D'accord. Mais revenez encore, hein." },

  Marill = { emo = 'Happy',
    pre    = "Je nage de nouveau ![pause=25] Partout où je veux.",
    during = "L'eau descend de la montagne, vous savez.[pause=30] Alors d'une certaine façon, je vous accompagne.",
    post   = "L'eau est bonne aujourd'hui.[pause=25] Vraiment bonne. Venez nager, pour une fois.",
    quests = "Il y a une source tout en haut, paraît-il.[pause=30] Tout ce que je bois vient de là. C'est joli, comme idée." },

  Nidoking = { emo = 'Normal',
    pre    = "Le sommet.[pause=25] Personne n'y est monté de mon vivant.",
    during = "J'ai essayé, à votre âge.[pause=30] Je suis redescendu au tiers. Sans honte.",
    post   = "Vous l'avez fait.[pause=25] Je n'ai plus rien à vous apprendre. C'est un bon sentiment.",
    quests = "Il y a des endroits qu'on n'atteint qu'une fois.[pause=30] Gardez-le bien en mémoire." },

  Nidorina = { emo = 'Happy',
    pre    = "Papa dit que le sommet est infranchissable ![pause=25] Il dit ça de tout.",
    during = "Il a passé la journée à regarder la montagne.[pause=30] Il n'a pas dit un mot.",
    post   = "Il a dit « ils l'ont fait ».[pause=25] Juste ça. Puis il est allé se coucher.",
    quests = "Il m'a donné son vieux sac ce matin.[pause=30] Il a dit que je saurais quoi en faire." },

  Medicham = { emo = 'Normal',
    pre    = "Tout est apaisé, en bas.[pause=25] Tout est tendu, en haut.",
    during = "Je médite face au sommet chaque matin.[pause=30] C'est tout ce que je peux faire pour vous.",
    post   = "Quelque chose s'est dénoué là-haut.[pause=25] Je l'ai senti avant de vous voir rentrer.",
    quests = "La tension n'a pas disparu.[pause=30] Elle est montée plus haut. Beaucoup plus haut." },

  Machamp = { emo = 'Happy',
    pre    = "La ville est tranquille ![pause=25] Je m'ennuie. C'est un excellent signe.",
    during = "Si vous avez besoin de bras là-haut, criez fort.[pause=30] J'entends très bien.",
    post   = "Vous n'avez pas crié.[pause=25] Vous vous êtes débrouillés. Je suis vexé et fier.",
    quests = "La prochaine fois, emmenez-moi.[pause=30] Même si je ne sers à rien. Surtout si je ne sers à rien." },

  Manectric = { emo = 'Normal',
    pre    = "Plus une seule trace suspecte.[pause=25] Mon registre est vide depuis deux semaines.",
    during = "Je patrouille jusqu'aux contreforts.[pause=30] Pas plus haut. Ce n'est pas mon terrain.",
    post   = "Rien à signaler, encore.[pause=25] Je commence à croire que c'est vrai.",
    quests = "Le calme d'en bas ne dit rien du calme d'en haut.[pause=30] Vous le savez mieux que moi." },

  Luxray = { emo = 'Normal',
    pre    = "Je vois clair partout de nouveau.[pause=25] Sauf tout en haut. Là-haut, c'est blanc.",
    during = "Blanc comme un mur.[pause=30] Je ne sais pas si c'est de la lumière ou de la neige.",
    post   = "Toujours blanc.[pause=25] Vous, vous savez ce qu'il y a derrière. Moi non.",
    quests = "Ne me dites pas.[pause=30] Il faut bien qu'il reste un endroit que je ne vois pas." },

  Spinda = { emo = 'Happy',
    pre    = "Le monde tourne dans le bon sens ![pause=25] Enfin, dans mon sens.",
    during = "J'ai levé la tête vers le sommet.[pause=30] J'ai perdu l'équilibre. Comme d'habitude.",
    post   = "Vous êtes revenus ![pause=25] Ou alors je vois double. Les deux me vont.",
    quests = "Quand on regarde trop haut, on tombe.[pause=30] Je suis bien placé pour le savoir." },

  Ludicolo = { emo = 'Happy',
    pre    = "La place est pleine tous les soirs ![pause=25] On rattrape le temps perdu.",
    during = "J'ai composé un air pour votre retour.[pause=30] Il n'est pas très bon. Mais il existe.",
    post   = "Je l'ai joué ce matin ![pause=25] Tout le monde a trouvé ça affreux. Moi j'y tiens.",
    quests = "Il faudra bien que quelqu'un raconte ce que vous avez fait.[pause=30] Ce sera moi. En musique. Désolé d'avance." },

  Jigglypuff = { emo = 'Happy',
    pre    = "Je chante à pleine voix ![pause=25] Plus personne ne me demande de me taire.",
    during = "J'ai chanté vers le sommet hier soir.[pause=30] Au cas où vous entendriez. On ne sait jamais.",
    post   = "Vous m'avez entendue ?[pause=25] Non ? Tant pis. J'ai chanté quand même.",
    quests = "Je chanterai encore, quand vous repartirez.[pause=30] Pour que vous sachiez où est la maison." },

  Vileplume = { emo = 'Happy',
    pre    = "Mon parfum porte jusqu'au pont ![pause=25] Comme au bon vieux temps.",
    during = "J'en ai envoyé vers la montagne.[pause=30] Le vent l'a emporté. J'espère qu'il est monté haut.",
    post   = "Vous sentez bon la neige.[pause=25] Ça existe, l'odeur de la neige. Croyez-moi.",
    quests = "Les odeurs montent toujours.[pause=30] Ce qu'on envoie d'ici finit là-haut. C'est réconfortant." },

  Gloom = { emo = 'Happy',
    pre    = "Je n'ai peur de rien aujourd'hui ![pause=25] Enfin, de pas grand-chose.",
    during = "Je m'inquiète pour vous.[pause=30] Mais c'est une inquiétude normale. Ça fait du bien.",
    post   = "Vous êtes là ![pause=25] J'avais préparé tout un discours. Je l'ai oublié.",
    quests = "J'ai eu peur toute ma vie.[pause=30] Là, pour la première fois, j'ai peur pour quelqu'un d'autre que moi." },

  Oddish = { emo = 'Happy',
    pre    = "La terre est parfaite partout ![pause=25] Je m'enfouis où je veux.",
    during = "Je suis descendu très profond hier.[pause=30] Tout est calme, en bas. Vraiment calme.",
    post   = "En bas comme en haut, tout va.[pause=25] C'est rare que les deux aillent ensemble.",
    quests = "Les racines les plus profondes tiennent les arbres les plus hauts.[pause=30] Pensez-y en montant." },

  Furret = { emo = 'Happy',
    pre    = "Toutes les familles sont rentrées ![pause=25] Les onze. J'ai recompté.",
    during = "On a préparé un terrier pour vous.[pause=30] Vous êtes trop grands, mais l'intention est là.",
    post   = "On a fait une fête hier soir ![pause=25] Vous dormiez. On n'a pas voulu réveiller.",
    quests = "Un terrier vide, ça se remplit.[pause=30] Il suffit d'attendre. On a beaucoup attendu." },

  Linoone = { emo = 'Happy',
    pre    = "Je cours partout ![pause=25] Toutes les routes sont ouvertes.",
    during = "J'ai couru jusqu'au pied de la montagne.[pause=30] J'ai levé la tête. J'ai fait demi-tour.",
    post   = "Vous montez, moi je cours à plat.[pause=25] Chacun son domaine.",
    quests = "Je peux porter un message n'importe où en une journée.[pause=30] Si un jour vous en avez besoin. N'importe où." },

  Sentret = { emo = 'Happy',
    pre    = "Rien à signaler depuis deux semaines ![pause=25] Mon meilleur registre.",
    during = "Je surveille la montagne, maintenant.[pause=30] C'est plus loin, mais c'est plus important.",
    post   = "Je vous ai vus redescendre ![pause=25] Premier à vous voir. J'en suis assez fier.",
    quests = "Je continuerai de regarder là-haut.[pause=30] Quelqu'un doit le faire, non ?" },

  Cranidos = { emo = 'Determined',
    pre    = "La guilde prépare quelque chose de gros.[pause=25] On ne me dit pas quoi. Comme toujours.",
    during = "C'était vous, le truc gros.[pause=30] J'aurais dû m'en douter.",
    post   = "Votre rapport n'est pas encore écrit ![pause=25] Le maître de guilde attend. Tout le monde attend.",
    quests = "On m'a demandé de classer les anciens rapports.[pause=30] Tous. Comme si on préparait de la place pour la suite." },

  Mareep = { emo = 'Happy',
    pre    = "J'éclaire de nouveau la nuit ![pause=25] Plein feu.",
    during = "J'ai brillé fort hier soir, vers la montagne.[pause=30] Comme un phare. C'était ridicule et j'ai adoré.",
    post   = "Vous avez vu ma lumière ?[pause=25] Depuis là-haut ? Vraiment ?",
    quests = "Je brillerai chaque nuit où vous serez dehors.[pause=30] C'est décidé. Ne discutez pas." },

  Metapod = { emo = 'Normal',
    pre    = "Le silence est total.[pause=25] Le vrai silence, celui qui repose.",
    during = "J'entends le vent du sommet.[pause=30] Rien d'autre. Le vent, et c'est tout.",
    post   = "Vous avez rapporté du bruit avec vous ![pause=25] La ville est bruyante ce matin. Tant mieux.",
    quests = "J'ai passé ma vie immobile à écouter.[pause=30] Vous, vous êtes montés. On fait ce qu'on peut." },

  Silcoon = { emo = 'Happy',
    pre    = "On regarde le sommet toute la journée.[pause=25] C'est notre nouveau passe-temps.",
    during = "On a suivi votre progression ![pause=30] Enfin, on a suivi un point qui bougeait. C'était sûrement vous.",
    post   = "Le point est redescendu ![pause=25] On a applaudi. Avec ce qu'on a.",
    quests = "On ne bougera jamais d'ici.[pause=30] Mais on aura vu quelqu'un aller tout en haut. Ça compte." },
}

--------------------------------------------------------------------
-- LA PAROLE
--------------------------------------------------------------------
-- Meme cascade que TownVoices : un palier non renseigne retombe sur le
-- precedent. On n'ecrit que ce qui a une raison de changer.
local ORDER = { 'early', 'pre', 'during', 'post', 'quests' }

function TownVoicesLate.Talk(inst, ch)
  ch = ch or (SV.ChapterProgression and SV.ChapterProgression.Chapter) or 0
  local fiches = TownVoicesLate.FICHES[ch]
  if fiches == nil then return false end

  local fiche = fiches[inst]
  if fiche == nil then return false end

  local chara = CH(inst)
  if chara == nil then return false end

  local st = 'early'
  pcall(function() st = TownVoices.State(ch) end)

  local txt = nil
  for _, k in ipairs(ORDER) do
    if fiche[k] ~= nil then txt = fiche[k] end
    if k == st then break end
  end
  if txt == nil then return false end

  local ok = pcall(function()
    GeneralFunctions.StartConversation(chara, txt, fiche.emo or 'Normal')
    GeneralFunctions.EndConversation(chara)
  end)
  return ok
end

--Combien de repliques ce module ajoute-t-il ?
function TownVoicesLate.Count()
  local n = 0
  for _, fiches in pairs(TownVoicesLate.FICHES) do
    for _, f in pairs(fiches) do
      for _, k in ipairs(ORDER) do
        if f[k] ~= nil then n = n + 1 end
      end
    end
  end
  return n
end

return TownVoicesLate
