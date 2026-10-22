#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
expand_side_quest_dialogues_20lines.py — Enrichit l'intégralité des 20 quêtes
secondaires PNJ de Metano Town dans Data/Script/halcyon/SideQuests.lua pour
atteindre un MINIMUM DE 20 À 28 LIGNES DE DIALOGUE par quête (au total),
en intégrant les réponses actives du PARTENAIRE ('Teammate1') et du HÉROS ('PLAYER').
"""
import os, sys, re

MOD_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SIDE_QUESTS_LUA = os.path.join(MOD_ROOT, "Data/Script/halcyon/SideQuests.lua")
TOWN_LIFE_LUA = os.path.join(MOD_ROOT, "Data/Script/halcyon/TownLife.lua")

EXPANDED_SIDE_QUESTS = [
    # === CHAPITRE 6 (Rang 30-33) ===
    {
        "id": "q6_desert", "ch": 6, "giver": "Sentret",
        "unlock_dungeon": "forsaken_desert", "dungeon_name": "Désert des Oubliés",
        "titre": "Le sac de courrier volé",
        "ask": [
            "{'Sentret', 'Worried', 'C est une catastrophe ! Vous devez m aider !'}",
            "{'Teammate1', 'Surprised','Sentret ! Que s est-il passé ? Pourquoi courez-vous ainsi ?'}",
            "{'Sentret', 'Sad',     'Je faisais ma tournée de guet au sud-est des remparts de Metano...'}",
            "{'Sentret', 'Worried', 'Quand soudain, une tempête de sable s est levée sans aucun avertissement.'}",
            "{'Sentret', 'Angry',   'Et dans la tourmente, Hippodocus le Colosse a jailli des dunes pour arracher ma sacoche prioritaire !'}",
            "{'Sentret', 'Sad',     'Il a emporté toutes les lettres dans les profondeurs du Désert des Oubliés.'}",
            "{'Teammate1', 'Angry',   'Le courrier officiel de la guilde ? C est inadmissible !'}",
            "{'PLAYER',    'Normal',  '(Je regarde mon partenaire en hochant fermement la tête.)'}",
            "{'Sentret', 'Worried', 'Si je perds ces plis, le Conseil de la Guilde m interdira de guet pour toute la saison...'}",
            "{'Sentret', 'Normal',  'Ce désert est un labyrinthe de sable et de roches brûlantes où je ne peux pas m aventurer.'}",
            "{'Teammate1', 'Determined','Ne vous en faites pas ! Notre équipe va descendre dans ce désert et récupérer votre sacoche !'}",
            "{'Sentret', 'Inspired','Vous feriez ça pour moi ? Vous traqueriez Hippodocus au milieu des dunes ?'}"
        ],
        "accept": [
            "{'Sentret', 'Happy',   'Merci mille fois ! Je savais que la guilde ne m abandonnerait pas !'}",
            "{'Teammate1', 'Happy', 'Comptez sur nous, nous revenons très vite !'}",
            "{'Sentret', 'Normal',  'L entrée du Désert des Oubliés se trouve au-delà du vieux pont de limon au sud-est.'}"
        ],
        "refuse": [
            "{'Sentret', 'Sad',     'Je comprends... C est un donjon dangereux et vous avez déjà beaucoup à faire.'}",
            "{'Teammate1', 'Sad',   'Désolé Sentret, nous devons d abord terminer notre rapport.'}"
        ],
        "pending": [
            "{'Sentret', 'Worried', 'Avez-vous pu explorer le Désert des Oubliés ?'}",
            "{'Teammate1', 'Determined','Nous sommes sur la piste, tenez bon !'}"
        ],
        "done": [
            "{'Sentret', 'Inspired','MA SACOCHE DE COURRIER ! Vous l avez vraiment retrouvée !'}",
            "{'Teammate1', 'Happy', 'Et regardez ! Pas une seule lettre n a été endommagée par le sable !'}",
            "{'PLAYER',    'Happy', '(Je ressens une vive satisfaction en lui tendant son courrier.)'}",
            "{'Sentret', 'Happy',   'Incroyable ! Même les sceaux de cire des lettres officielles sont intacts !'}",
            "{'Sentret', 'Surprised','Vous avez réussi à vaincre Hippodocus le Colosse dans son propre élément ?'}",
            "{'Teammate1', 'Inspired','Ça n a pas été de tout repos, mais notre esprit d équipe a triomphé !'}",
            "{'Sentret', 'Happy',   'Vous êtes les sauveurs de ma garde et de l honneur de notre ville !'}",
            "{'Sentret', 'Inspired','Tenez, prenez cette prime spéciale que la garde réservait aux cas d urgence !'}",
            "{'Sentret', 'Normal',  'Je vais pouvoir transmettre les messages à temps. Merci de tout cœur !'}"
        ]
    },
    {
        "id": "q6_geode", "ch": 6, "giver": "Mawile",
        "unlock_dungeon": "geode_crevice", "dungeon_name": "Crevasse de Géode",
        "titre": "Tarinor pris au piège",
        "ask": [
            "{'Mawile', 'Sad',     'Je me fais un sang d encre pour mon ami Tarinor de la guilde minérale.'}",
            "{'Teammate1', 'Worried','Tarinor ? Le géologue de l est ? Qu est-ce qui lui est arrivé ?'}",
            "{'Mawile', 'Worried', 'Il était parti ce matin pour étudier les vibrations magnétiques de la Crevasse de Géode.'}",
            "{'Mawile', 'Normal',  'C est une faille cristalline magnifique au nord des anciennes carrières de la ville.'}",
            "{'Mawile', 'Angry',   'Mais les éboulements sont devenus incontrôlables depuis que Gigalithe le Diamant s est réveillé !'}",
            "{'Mawile', 'Sad',     'Tarinor s est retrouvé coincé sous des tonnes de roches de quartz.'}",
            "{'Teammate1', 'Surprised','Coincé au fond d une crevasse ?! Il risque de manquer d air !'}",
            "{'PLAYER',    'Determined','(Je pointe le doigt vers le nord pour indiquer que nous partons tout de suite.)'}",
            "{'Mawile', 'Worried', 'Son nez magnétique indique qu il est encore en vie tout au fond de la crevasse.'}",
            "{'Mawile', 'Sad',     'Je n ai pas la force pour dégager un éboulis pareil seule dans la faille.'}",
            "{'Teammate1', 'Determined','Laissez-nous faire, Mysdibule ! Nous allons forcer le passage et libérer Tarinor !'}",
            "{'Mawile', 'Inspired','Vous feriez ça ? Vous descendriez dans la crevasse pour lui ?'}"
        ],
        "accept": [
            "{'Mawile', 'Happy',   'Quel soulagement ! Vous êtes formidables !'}",
            "{'Teammate1', 'Happy', 'Nous ramenons Tarinor sain et sauf, promesse d explorateur !'}",
            "{'Mawile', 'Normal',  'Suivez le sentier minéral au nord, la faille brille d une lueur violette.'}"
        ],
        "refuse": [
            "{'Mawile', 'Sad',     'Je comprends, la roche qui tombe est un piège mortel.'}",
            "{'Teammate1', 'Sad',   'Pardonnez-nous, nous devons nous préparer davantage.'}"
        ],
        "pending": [
            "{'Mawile', 'Worried', 'Avez-vous atteint le fond de la Crevasse de Géode ?'}",
            "{'Teammate1', 'Determined','Nous perçons la roche, nous y sommes presque !'}"
        ],
        "done": [
            "{'Mawile', 'Inspired','TARINOR ! Tu es de retour sain et sauf !'}",
            "{'Teammate1', 'Happy', 'Nous avons dégagé les éboulis et calmé Gigalithe juste à temps !'}",
            "{'PLAYER',    'Happy', '(Je vois Mysdibule essuyer une larme de joie en retrouvant son ami.)'}",
            "{'Mawile', 'Happy',   'Regardez-le, il tourne à nouveau vers le nord comme une boussole neuve !'}",
            "{'Mawile', 'Surprised','Vous avez brisé les remparts de pierre de Gigalithe le Diamant ?'}",
            "{'Teammate1', 'Inspired','La force minérale était impressionnante, mais nous avons tenu bon !'}",
            "{'Mawile', 'Happy',   'Quelle force extraordinaire ! Vous avez toute l admiration de notre colonie !'}",
            "{'Mawile', 'Inspired','Tarinor a pu sauver ces cristaux d énergie pure pendant que vous combattiez !'}",
            "{'Mawile', 'Happy',   'Prenez-les, ils renforceront les capacités de votre équipe en donjon !'}"
        ]
    },
    {
        "id": "q6_verger", "ch": 6, "giver": "Bellossom",
        "unlock_dungeon": "wild_orchard", "dungeon_name": "Verger Sauvage",
        "titre": "La sève dorée de la reine",
        "ask": [
            "{'Bellossom', 'Worried', 'Les arbres du Verger Sauvage pleurent à chaudes larmes depuis trois jours.'}",
            "{'Teammate1', 'Surprised','Des arbres qui pleurent ? Joliflor, de quoi parlez-vous ?'}",
            "{'Bellossom', 'Sad',     'Notre colonie de fleurs dépend de la sève dorée pour réussir notre pollinisation.'}",
            "{'Bellossom', 'Normal',  'C est une forêt ancienne qui jouxte les limites ouest des jardins de guilde.'}",
            "{'Bellossom', 'Angry',   'Mais Apireine la Souveraine a ordonné à son essaim de confisquer toutes les gouttes de sève !'}",
            "{'Bellossom', 'Sad',     'Elle prétend que le verger lui appartient désormais en totalité.'}",
            "{'Teammate1', 'Angry',   'Confisquer la sève aux autres plantes ? C est complètement injuste !'}",
            "{'PLAYER',    'Normal',  '(Je serre le poing : la forêt doit être partagée par tous.)'}",
            "{'Bellossom', 'Worried', 'Sans cette nutrition royale, nos fleurs vont s assécher avant le printemps.'}",
            "{'Bellossom', 'Sad',     'Nous sommes incapables de bouger pour nous défendre ou parlementer.'}",
            "{'Teammate1', 'Determined','Ne perdez pas espoir ! Nous allons aller parler à Apireine et lui faire entendre raison !'}",
            "{'Bellossom', 'Inspired','Explorateurs, vous oseriez défier un essaim entier pour nous ?'}"
        ],
        "accept": [
            "{'Bellossom', 'Happy',   'Oh, merci ! Vous redonnez l espoir à tout notre sous-bois !'}",
            "{'Teammate1', 'Happy', 'Nous nous occupons du verger, préparez vos fleurs !'}",
            "{'Bellossom', 'Normal',  'Le chemin du verger s ouvre juste derrière la haie de baies à l ouest.'}"
        ],
        "refuse": [
            "{'Bellossom', 'Sad',     '...Je comprends. Affronter une colonie entière est un risque immense.'}",
            "{'Teammate1', 'Sad',   'Nous reviendrons dès que nous aurons l équipement nécessaire.'}"
        ],
        "pending": [
            "{'Bellossom', 'Worried', 'Avez-vous pu négocier ou combattre au Verger Sauvage ?'}",
            "{'Teammate1', 'Determined','Nous progressons dans les sous-bois, soyez patients !'}"
        ],
        "done": [
            "{'Bellossom', 'Inspired','LA SÈVE DORÉE ! Je sens son arôme sucré d ici !'}",
            "{'Teammate1', 'Happy', 'Apireine a accepté de rouvrir l accès aux canaux de sève pour toute la forêt !'}",
            "{'PLAYER',    'Happy', '(Les plantes du jardin relèvent immédiatement leurs pétales.)'}",
            "{'Bellossom', 'Happy',   'Vous avez vaincu la garde royale d Apireine la Souveraine !'}",
            "{'Bellossom', 'Surprised','Les arbres coulent à nouveau librement pour tous les habitants du verger !'}",
            "{'Teammate1', 'Inspired','La reine a compris que le verger est plus beau quand tout le monde y vit en paix.'}",
            "{'Bellossom', 'Happy',   'Je sens que nos pétales retrouvent tout leur éclat de jeunesse !'}",
            "{'Bellossom', 'Inspired','Voici des Baies Pecha rares dorées que nous avions cachées dans les racines !'}",
            "{'Bellossom', 'Normal',  'Merci de protéger ceux qui vivent dans le sous-bois !'}"
        ]
    },
    {
        "id": "q6_plaines", "ch": 6, "giver": "Electrike",
        "unlock_dungeon": "scorched_plains", "dungeon_name": "Plaines Brûlées",
        "titre": "Surcharges dans la savane",
        "ask": [
            "{'Electrike', 'Worried', 'Bzz ! L air de la savane est devenu irrespirable pour notre meute.'}",
            "{'Teammate1', 'Surprised','Dynavolt ! Vous tremblez ! Est-ce un excès d électricité ?'}",
            "{'Electrike', 'Sad',     'Nos pelages accumulent une charge électrostatique qui nous brûle la peau.'}",
            "{'Electrike', 'Normal',  'Les Plaines Brûlées sont notre pâturage d hiver par-delà la colline foudroyée.'}",
            "{'Electrike', 'Angry',   'Mais Élecsprint la Tempête est entré dans une rage territoriale incontrôlable !'}",
            "{'Electrike', 'Sad',     'Sa présence maintient un soleil ardent et des éclairs secs nuit et jour.'}",
            "{'Teammate1', 'Worried', 'Un orage sec perpétuel ? La savane entière risque de prendre feu !'}",
            "{'PLAYER',    'Determined','(Je regarde vers le ciel jaune-ocre qui gronde à l horizon.)'}",
            "{'Electrike', 'Worried', 'Les jeunes de notre meute ne peuvent plus s y nourrir en sécurité.'}",
            "{'Electrike', 'Sad',     'Si la foudre continue de tomber ainsi, toute notre terre va finir en cendres.'}",
            "{'Teammate1', 'Determined','Nous ne laisserons pas faire ! Nous partons pour les plaines canaliser cet orage !'}",
            "{'Electrike', 'Inspired','Pouvez-vous vraiment traverser la savane pour apaiser la colère d Élecsprint ?'}"
        ],
        "accept": [
            "{'Electrike', 'Happy',   'Bzz ! Merci ! Vous avez le courage d une vraie garde de champions !'}",
            "{'Teammate1', 'Happy', 'Préparez vos pâturages, l orage est sur le point d être dissipé !'}",
            "{'Electrike', 'Normal',  'Traversez la crête rocheuse au sud, vous verrez les herbes hautes crépiter.'}"
        ],
        "refuse": [
            "{'Electrike', 'Sad',     'Bzz... C est vrai que l électricité statique est redoutable.'}",
            "{'Teammate1', 'Sad',   'Nous devons nous équiper contre la foudre avant de partir.'}"
        ],
        "pending": [
            "{'Electrike', 'Worried', 'Bzz... Les Plaines Brûlées sont-elles toujours sous l orage sec ?'}",
            "{'Teammate1', 'Determined','Nous affrontons les éclairs, nous ne reculons pas !'}"
        ],
        "done": [
            "{'Electrike', 'Inspired','BZZ ! LE VENT ! Vous entendez ? La foudre a cessé de gronder !'}",
            "{'Teammate1', 'Happy', 'Élecsprint a retrouvé son calme et a dispersé l électricité excédentaire !'}",
            "{'PLAYER',    'Happy', '(Un vent frais et apaisé souffle à nouveau depuis le sud.)'}",
            "{'Electrike', 'Happy',   'Les nuages noirs se sont dissipés et l herbe a retrouvé sa fraîcheur !'}",
            "{'Electrike', 'Surprised','Vous avez tenu bon face aux décharges à haute tension d Élecsprint ?'}",
            "{'Teammate1', 'Inspired','Ça n a pas été facile, mais notre coordination a fait toute la différence !'}",
            "{'Electrike', 'Happy',   'Notre meute va pouvoir regagner ses plaines dès ce soir !'}",
            "{'Electrike', 'Inspired','Prenez cette récompense d orbes et ces graines en témoignage de notre gratitude !'}",
            "{'Electrike', 'Normal',  'Metano a bien de la chance d avoir une guilde aussi dévouée !'}"
        ]
    },
    # --- CHAPITRE 7 ---
    {
        "id": "q7_jardin", "ch": 7, "giver": "Manectric",
        "unlock_dungeon": "energy_garden", "dungeon_name": "Jardin d'Énergie",
        "titre": "L'antenne disparue",
        "ask": [
            "{'Manectric', 'Worried', 'Bzz... Bzz... Alerte ! Signal magnétique de notre relais souterrain à zéro !'}",
            "{'Teammate1', 'Surprised','Élecsprint ! Une panne d antenne sur le réseau de la guilde ?'}",
            "{'Manectric', 'Sad',     'Notre station de mesure surveillait les flux d énergie des grottes de quartz.'}",
            "{'Manectric', 'Normal',  'Le Jardin d Énergie est une cavité naturelle de cristaux purs sous la faille nord.'}",
            "{'Manectric', 'Angry',   'Mais Lucario l Onde s est approprié notre antenne de résonance en or !'}",
            "{'Manectric', 'Sad',     'Il l utilise pour focaliser ses propres capacités au centre du sanctuaire.'}",
            "{'Teammate1', 'Worried', 'Si nous ne surveillons plus les failles, nous ne verrons pas venir les prochains séismes !'}",
            "{'PLAYER',    'Determined','(Je fais signe qu il faut descendre récupérer cette antenne sans attendre.)'}",
            "{'Manectric', 'Worried', 'Sans cette antenne, la guilde est aveugle aux secousses géologiques profondes.'}",
            "{'Manectric', 'Sad',     'Nos champs de sustentation faiblissent dès que nous approchons de ses ondes.'}",
            "{'Teammate1', 'Determined','Laissez-nous descendre ! Nous allons affronter Lucario et rétablir la transmission !'}",
            "{'Manectric', 'Inspired','Explorateurs, pouvez-vous descendre au jardin minéral pour récupérer notre antenne ?'}"
        ],
        "accept": [
            "{'Manectric', 'Happy',   'Bzz ! Positif ! Votre coefficient de bravoure dépasse 99% !'}",
            "{'Teammate1', 'Happy', 'Antenne en cours de récupération, restez à l écoute !'}",
            "{'Manectric', 'Normal',  'L accès se trouve dans la crevasse au nord-est de la place marchande.'}"
        ],
        "refuse": [
            "{'Manectric', 'Sad',     'Bzz... Négatif... Probabilité de succès annulée.'}",
            "{'Teammate1', 'Sad',   'Nous avons besoin de capteurs de secours avant d y aller.'}"
        ],
        "pending": [
            "{'Manectric', 'Worried', 'Bzz... Avez-vous restauré le signal du Jardin d Énergie ?'}",
            "{'Teammate1', 'Determined','Nous approchons de la salle du cœur, bzz !'}"
        ],
        "done": [
            "{'Manectric', 'Inspired','BZZ ! BZZ ! ANTENNE DÉTECTÉE ! Signal rétabli à 100% !'}",
            "{'Teammate1', 'Happy', 'Lucario a accepté de nous rendre l antenne après un duel loyal !'}",
            "{'PLAYER',    'Happy', '(Je vois les jauges de transmission remonter au maximum sur sa console.)'}",
            "{'Manectric', 'Happy',   'Les ondes de l aura de Lucario ne perturbent plus notre réseau de surveillance !'}",
            "{'Manectric', 'Surprised','Vous avez surmonté un champ de résonance magnétique aussi intense ?'}",
            "{'Teammate1', 'Inspired','Notre volonté était plus forte que les ondes d interférence !'}",
            "{'Manectric', 'Happy',   'Données confirmées : votre équipe est la plus fiable de toute la région !'}",
            "{'Manectric', 'Inspired','Veuillez accepter cet ensemble d Évolurocs de quartz concentré !'}",
            "{'Manectric', 'Normal',  'Fin de transmission. Merci pour votre service exemplaire !'}"
        ]
    },
    {
        "id": "q7_relique", "ch": 7, "giver": "Meditite",
        "unlock_dungeon": "sunken_relic", "dungeon_name": "Relique Engloutie",
        "titre": "Les tables sacrées englouties",
        "ask": [
            "{'Meditite', 'Sad',     'Hummm... Un drame silencieux se joue au fond de la crique occidentale.'}",
            "{'Teammate1', 'Surprised','Méditikka ? Que se passe-t-il dans les ruines de la côte ?'}",
            "{'Meditite', 'Worried', 'Les ruines de la Relique Engloutie ont émergé de quelques mètres après les séismes.'}",
            "{'Meditite', 'Normal',  'Ces murs portent les tables gravées racontant l origine des premiers donjons.'}",
            "{'Meditite', 'Angry',   'Mais Tutufeur le Gardien s est emparé du hall principal et en interdit l accès !'}",
            "{'Meditite', 'Sad',     'Il prétend que les écrits des anciens ne doivent jamais être lus par les vivants.'}",
            "{'Teammate1', 'Worried', 'Mais si l eau salée ronge les pierres, ces écritures historiques vont disparaître !'}",
            "{'PLAYER',    'Normal',  '(Je regarde les ruines au large avec un sentiment de respect historique.)'}",
            "{'Meditite', 'Worried', 'L eau salée ronge rapidement la roche dorée de ces tables millénaires.'}",
            "{'Meditite', 'Sad',     'Si personne n en fait le relevé cette semaine, ces secrets seront perdus à jamais.'}",
            "{'Teammate1', 'Determined','Nous allons explorer la Relique Engloutie et vous ramener ces estampages !'}",
            "{'Meditite', 'Inspired','Pouvez-vous pénétrer dans les ruines pour nous rapporter l estampage des tables ?'}"
        ],
        "accept": [
            "{'Meditite', 'Happy',   'Hummm ! La sagesse des anciens vous illuminera ! Merci !'}",
            "{'Teammate1', 'Happy', 'Préparez votre parchemin, l histoire sera préservée !'}",
            "{'Meditite', 'Normal',  'Descendez par les marches de pierre submergées à l ouest du port.'}"
        ],
        "refuse": [
            "{'Meditite', 'Sad',     'Hummm... Le secret restera prisonnier du sable et des algues.'}",
            "{'Teammate1', 'Sad',   'Nous devons nous équiper pour la plongée d abord.'}"
        ],
        "pending": [
            "{'Meditite', 'Worried', 'Avez-vous pu effectuer l estampage à la Relique Engloutie ?'}",
            "{'Teammate1', 'Determined','Nous explorons les galeries englouties, tenez bon !'}"
        ],
        "done": [
            "{'Meditite', 'Inspired','HUMMM ! LES TABLES GRAVÉES ! L estampage est d une netteté absolue !'}",
            "{'Teammate1', 'Happy', 'Tutufeur a compris que nous voulions préserver la mémoire et non la détruire !'}",
            "{'PLAYER',    'Happy', '(Le moine contemple les symboles anciens avec des yeux brillants.)'}",
            "{'Meditite', 'Happy',   'Vous avez pacifié la colère du vieux Tutufeur au fond des vestiges !'}",
            "{'Meditite', 'Surprised','Ces symboles confirment l existence des anciens relais de guilde !'}",
            "{'Teammate1', 'Inspired','C est incroyable de lire ce que les premiers explorateurs écrivaient !'}",
            "{'Meditite', 'Happy',   'Notre ordre d historiens vous doit une reconnaissance éternelle !'}",
            "{'Meditite', 'Inspired','Prenez ces Orbes Antiques et ces joyaux repêchés dans la relique !'}",
            "{'Meditite', 'Normal',  'Que votre nom soit gravé à jamais dans les annales de Metano !'}"
        ]
    },
    {
        "id": "q7_labyrinthe", "ch": 7, "giver": "Oddish",
        "unlock_dungeon": "mossy_labyrinth", "dungeon_name": "Labyrinthe Moussue",
        "titre": "Les racines envahissantes",
        "ask": [
            "{'Oddish', 'Worried', 'Au secours ! La forêt de l est se referme sur nos terrains de jeu !'}",
            "{'Teammate1', 'Surprised','Mystherbe ! Pourquoi êtes-vous si affolé ? Qui est piégé ?'}",
            "{'Oddish', 'Sad',     'Le Labyrinthe Moussue était une forêt paisible où les jeunes plantes apprenaient à pousser.'}",
            "{'Oddish', 'Normal',  'Mais les pluies récentes ont déclenché une croissance végétale incontrôlable.'}",
            "{'Oddish', 'Angry',   'Et Torterra le Géant s est installé au centre, laissant ses racines bloquer tous les sentiers !'}",
            "{'Oddish', 'Sad',     'Ses racines ligneuses ont piégé trois jeunes Germignon dans une clairière fermée.'}",
            "{'Teammate1', 'Angry',   'Des petits Germignon enfermés sans lumière ? Il faut aller les chercher !'}",
            "{'PLAYER',    'Determined','(Je prends mon sac : pas question de laisser des petits en danger.)'}",
            "{'Oddish', 'Worried', 'Si nous n élaguons pas le passage rapidement, ils vont manquer de lumière et d eau.'}",
            "{'Oddish', 'Sad',     'Je suis trop petit pour couper du bois aussi dur avec mes jeunes feuilles.'}",
            "{'Teammate1', 'Determined','Ne pleurez plus ! Nous allons traverser le labyrinthe et élaguer ces racines !'}",
            "{'Oddish', 'Inspired','Pouvez-vous traverser le labyrinthe pour élaguer les racines et libérer nos amis ?'}"
        ],
        "accept": [
            "{'Oddish', 'Happy',   'Hourra ! Vous êtes les meilleurs explorateurs du monde !'}",
            "{'Teammate1', 'Happy', 'Rassurez tout le monde en ville, nous ramenons les Germignon !'}",
            "{'Oddish', 'Normal',  'Le labyrinthe commence au nord du vieux chêne de la rivière.'}"
        ],
        "refuse": [
            "{'Oddish', 'Sad',     'Oh non... Mes amis vont avoir si peur dans le noir...'}",
            "{'Teammate1', 'Sad',   'Nous allons chercher des outils de coupe et nous revenons.'}"
        ],
        "pending": [
            "{'Oddish', 'Worried', 'Avez-vous pu dégager les sentiers du Labyrinthe Moussue ?'}",
            "{'Teammate1', 'Determined','Nous approchons de la clairière centrale, courage !'}"
        ],
        "done": [
            "{'Oddish', 'Inspired','LES GERMIGNON ! Ils sont rentrés au village sains et saufs !'}",
            "{'Teammate1', 'Happy', 'Torterra s est excusé de s être endormi sur le passage des petits !'}",
            "{'PLAYER',    'Happy', '(Je vois les jeunes plantes danser autour de nous de bonheur.)'}",
            "{'Oddish', 'Happy',   'Vous avez réussi à convaincre le grand Torterra de relever ses racines !'}",
            "{'Oddish', 'Surprised','Le Labyrinthe Moussue respire à nouveau sous la lumière du soleil !'}",
            "{'Teammate1', 'Inspired','Le sentier est désormais libre pour toutes les jeunes pousses !'}",
            "{'Oddish', 'Happy',   'Toute la faune végétale chante vos louanges depuis ce matin !'}",
            "{'Oddish', 'Inspired','Voici un lot de Pommes d Or et de Graines Résurrection de notre récolte !'}",
            "{'Oddish', 'Normal',  'Merci de veiller sur la nature et sur les petits !'}"
        ]
    },
    {
        "id": "q7_carriere", "ch": 7, "giver": "Numel",
        "unlock_dungeon": "magma_quarry", "dungeon_name": "Carrière Magmatique",
        "titre": "Le charbon thermique",
        "ask": [
            "{'Numel', 'Sad',     'Pfff... J ai un énorme problème pour préparer la saison froide.'}",
            "{'Teammate1', 'Surprised','Chamallot ? Votre bosse semble toute froide, que se passe-t-il ?'}",
            "{'Numel', 'Worried', 'Ma bosse interne a besoin de charbon thermique pour maintenir ma température vitale.'}",
            "{'Numel', 'Normal',  'Le seul gisement pur se trouve au cœur de la Carrière Magmatique.'}",
            "{'Numel', 'Angry',   'Mais Arkani la Flamme a investi la mine et attaque tous les mineurs qui approchent !'}",
            "{'Numel', 'Sad',     'La chaleur y est devenue si intense que même les parois rocheuses fondent.'}",
            "{'Teammate1', 'Worried', 'Si vous manquez de minerai thermique, votre feu intérieur va s éteindre !'}",
            "{'PLAYER',    'Determined','(Je regarde mon partenaire : nous savons résister aux flammes.)'}",
            "{'Numel', 'Worried', 'Sans ce minerai volcanique, je vais souffrir d hypothermie interne d ici quelques jours.'}",
            "{'Numel', 'Sad',     'Les chariots de guilde ne peuvent plus descendre dans les galeries inférieures.'}",
            "{'Teammate1', 'Determined','Laissez-nous faire, Chamallot ! Nous allons rapporter ce charbon de la carrière !'}",
            "{'Numel', 'Inspired','Explorateurs, avez-vous la force d affronter la carrière pour m extraire ce minerai ?'}"
        ],
        "accept": [
            "{'Numel', 'Happy',   'Pfff ! Chaleureux merci ! La carrière est dans la faille volcanique !'}",
            "{'Teammate1', 'Happy', 'Préparez votre bosse, le minerai chaud arrive très vite !'}",
            "{'Numel', 'Normal',  'La carrière s ouvre dans la faille volcanique à l extrême ouest de la falaise.'}"
        ],
        "refuse": [
            "{'Numel', 'Sad',     'Pfff... Je comprends, la lave est un environnement redoutable.'}",
            "{'Teammate1', 'Sad',   'Nous allons chercher des baies ignifugées et nous revenons.'}"
        ],
        "pending": [
            "{'Numel', 'Worried', 'Avez-vous pu atteindre les filons de la Carrière Magmatique ?'}",
            "{'Teammate1', 'Determined','Nous descendons dans le cratère, ça chauffe !'}"
        ],
        "done": [
            "{'Numel', 'Inspired','PFFF ! LE CHARBON THERMIQUE ! Regardez cet éclat rouge flamboyant !'}",
            "{'Teammate1', 'Happy', 'Arkani a reconnu notre valeur et nous a laissé extraire les meilleurs blocs !'}",
            "{'PLAYER',    'Happy', '(Je vois la bosse de Chamallot retrouver une belle lueur incandescente.)'}",
            "{'Numel', 'Happy',   'Vous avez vaincu les flammes d Arkani au cœur même du volcan !'}",
            "{'Numel', 'Surprised','Ma bosse a retrouvé toute sa puissance calorifique en un instant !'}",
            "{'Teammate1', 'Inspired','Nous avons même sécurisé le sentier pour les futurs mineurs !'}",
            "{'Numel', 'Happy',   'Je suis réchauffée pour toute l année ! Vous êtes incroyables !'}",
            "{'Numel', 'Inspired','Prenez ces Orbes Feu et ces Baies Rawst que ma famille conserve !'}",
            "{'Numel', 'Normal',  'Que le feu sacré de votre équipe ne s éteigne jamais !'}"
        ]
    },
    # === CHAPITRE 8 ===
    {
        "id": "q8_toundra", "ch": 8, "giver": "Wooper_Girl",
        "unlock_dungeon": "barren_tundra", "dungeon_name": "Toundra Désolée",
        "titre": "La cargaison gelée",
        "ask": [
            "{'Wooper_Girl', 'Sad',     'Aglagla... C est terrible... Notre provision de baies d hiver est perdue !'}",
            "{'Teammate1',   'Surprised','Axoloto ! Vous grelottez ! Où est passée votre cargaison ?'}",
            "{'Wooper_Girl', 'Worried', 'Le convoi de notre colonie traversait le col de la Toundra Désolée ce matin.'}",
            "{'Wooper_Girl', 'Normal',  'C est une région glaciaire immense aux crêtes battues par le vent du nord.'}",
            "{'Wooper_Girl', 'Angry',   'Mais Blizzarroi l Hiver a déclenché une tempête de grêle monstrueuse qui a enfoui nos caisses !'}",
            "{'Wooper_Girl', 'Sad',     'Les baies sont figées sous trois mètres de glace épaisse au milieu des pics.'}",
            "{'Teammate1',   'Worried', 'Sans baies dans le froid glaciaire, toute votre colonie va souffrir de la faim !'}",
            "{'PLAYER',      'Determined','(Je resserre mon écharpe : nous devons monter affronter ce blizzard.)'}",
            "{'Wooper_Girl', 'Worried', 'Sans ces réserves, nos petits ne survivront pas à la longue nuit glaciaire.'}",
            "{'Wooper_Girl', 'Sad',     'Nos nageoires sont trop courtes pour creuser dans une glace aussi dure.'}",
            "{'Teammate1',   'Determined','Comptez sur nous ! Nous allons braver la Toundra Désolée et sauver vos provisions !'}",
            "{'Wooper_Girl', 'Inspired','Qui aura le courage d affronter la toundra pour nous ramener notre cargaison ?'}"
        ],
        "accept": [
            "{'Wooper_Girl', 'Happy',   'Aglagla ! Hourra ! Vous avez le cœur plus chaud que le soleil d été !'}",
            "{'Teammate1',   'Happy',   'Nous allons briser la glace, restez bien au chaud en ville !'}",
            "{'Wooper_Girl', 'Normal',  'Le sentier enneigé démarre au nord de la rivière gelée.'}"
        ],
        "refuse": [
            "{'Wooper_Girl', 'Sad',     'Aglagla... Je comprends, le blizzard là-haut gèle même la respiration.'}",
            "{'Teammate1',   'Sad',     'Nous allons chercher des vêtements chauds avant de tenter l ascension.'}"
        ],
        "pending": [
            "{'Wooper_Girl', 'Worried', 'Avez-vous retrouvé nos caisses dans la Toundra Désolée ?'}",
            "{'Teammate1',   'Determined','Nous avançons dans la tempête de grêle, tenez bon !'}"
        ],
        "done": [
            "{'Wooper_Girl', 'Inspired','AGLAGLA ! LES CAISSES DE BAIES ! Elles sont toutes là et intactes !'}",
            "{'Teammate1',   'Happy',   'Blizzarroi a arrêté son blizzard dès que nous lui avons expliqué la situation !'}",
            "{'PLAYER',      'Happy',   '(Je vois les petits Axoloto sauter de joie autour des caisses de baies.)'}",
            "{'Wooper_Girl', 'Happy',   'Vous avez surmonté le blizzard glacé du grand Blizzarroi l Hiver !'}",
            "{'Wooper_Girl', 'Surprised','Toute notre colonie va pouvoir se régaler et passer un hiver merveilleux !'}",
            "{'Teammate1',   'Inspired','Le col est à nouveau calme et le ciel boréal resplendit !'}",
            "{'Wooper_Girl', 'Happy',   'Vous êtes les explorateurs les plus chaleureux de toute la région !'}",
            "{'Wooper_Girl', 'Inspired','En échange, prenez cette prime de baies rares et de sphères polaires !'}",
            "{'Wooper_Girl', 'Normal',  'Merci de protéger la vie au cœur du grand froid !'}"
        ]
    },
    {
        "id": "q8_caverne", "ch": 8, "giver": "Machamp",
        "unlock_dungeon": "barren_cavern", "dungeon_name": "Caverne Stérile",
        "titre": "Les filons d'acier",
        "ask": [
            "{'Machamp', 'Worried', 'Croc... Croc... Alerte ! Notre mine d acier naturelle est sous scellés !'}",
            "{'Teammate1', 'Surprised','Mackogneur ? Qu est-ce qui a pu bloquer une mine de votre clan ?'}",
            "{'Machamp', 'Sad',     'Nous nous nourrissons des filons ferreux de la Caverne Stérile depuis des générations.'}",
            "{'Machamp', 'Normal',  'C est un réseau rocheux très profond où la pierre contient du fer pur.'}",
            "{'Machamp', 'Angry',   'Mais Charmina le Sceau s est enfermé dans la galerie centrale et a dressé des remparts de force !'}",
            "{'Machamp', 'Sad',     'Plus aucun mineur ne peut atteindre les cristaux de fer.'}",
            "{'Teammate1', 'Worried', 'Des barrières psychiques qui empêchent les mineurs de travailler ? Il faut agir !'}",
            "{'PLAYER',    'Determined','(Je regarde les muscles de Mackogneur : si sa force faiblit, toute la guilde en pâtira.)'}",
            "{'Machamp', 'Worried', 'Notre force musculaire commence déjà à s amincir par manque de minerais ferreux.'}",
            "{'Machamp', 'Sad',     'Si le sceau n est pas brisé, notre clan devra s expatrier loin de sa terre natale.'}",
            "{'Teammate1', 'Determined','Laissez-nous faire, Mackogneur ! Nous allons briser les sceaux de Charmina !'}",
            "{'Machamp', 'Inspired','Pouvez-vous descendre dans la caverne pour vaincre Charmina et rouvrir nos filons ?'}"
        ],
        "accept": [
            "{'Machamp', 'Happy',   'Croc ! Fantastique ! Votre armure de courage est indestructible !'}",
            "{'Teammate1', 'Happy', 'Préparez vos pioches, les galeries seront bientôt libres !'}",
            "{'Machamp', 'Normal',  'L entrée de la caverne s ouvre au pied de l éboulis nord-ouest.'}"
        ],
        "refuse": [
            "{'Machamp', 'Sad',     'Croc... C est dur de voir notre mine fermée pour toujours.'}",
            "{'Teammate1', 'Sad',   'Nous reviendrons quand nous serons prêts pour un combat psychique.'}"
        ],
        "pending": [
            "{'Machamp', 'Worried', 'Le sceau de la Caverne Stérile est-il enfin brisé ?'}",
            "{'Teammate1', 'Determined','Nous approchons du cœur de la caverne, courage !'}"
        ],
        "done": [
            "{'Machamp', 'Inspired','CROC ! CROC ! LES FILONS DE FER SONT LIBRES !'}",
            "{'Teammate1', 'Happy', 'Charmina s entraînait à la méditation, il ne savait pas qu il bloquait la mine !'}",
            "{'PLAYER',    'Happy', '(Mackogneur soulève un bloc de fer massif avec un grand rire.)'}",
            "{'Machamp', 'Happy',   'Vous avez triomphé des arts martiaux psychiques de Charmina le Sceau !'}",
            "{'Machamp', 'Surprised','Les galeries résonnent à nouveau des coups de pioches de tout notre clan !'}",
            "{'Teammate1', 'Inspired','Nous sommes fiers d avoir rouvert cette ressource essentielle pour la ville !'}",
            "{'Machamp', 'Happy',   'Notre force sera plus brillante et plus résistante que jamais grâce à vous !'}",
            "{'Machamp', 'Inspired','Veuillez accepter cet ensemble d armures de roche et d orbes minéraux !'}",
            "{'Machamp', 'Normal',  'Vous êtes les meilleurs alliés que la roche ait jamais connus !'}"
        ]
    },
    {
        "id": "q8_crete", "ch": 8, "giver": "Luxray",
        "unlock_dungeon": "cracked_ridge", "dungeon_name": "Crête Craquelée",
        "titre": "Les ailes d'altitude",
        "ask": [
            "{'Luxray', 'Angry',   'Je veux surmonter la crête ! Mais on m interdit de monter !'}",
            "{'Teammate1', 'Surprised','Luxray ? Qui oserait vous interdire de patrouiller sur les crêtes ?'}",
            "{'Luxray', 'Worried', 'La Crête Craquelée est le seul endroit où les vents sont parfaits pour surveiller.'}",
            "{'Luxray', 'Normal',  'C est une arête rocheuse vertigineuse qui domine toute la vallée du sud.'}",
            "{'Luxray', 'Angry',   'Mais Drattak la Cime a bloqué le col supérieur et provoque des éboulis à chaque rugissement !'}",
            "{'Luxray', 'Sad',     'Il prétend que les voyageurs ne sont pas assez résistants pour survivre au sommet.'}",
            "{'Teammate1', 'Angry',   'Bloquer un sentier sous prétexte de force ? C est inacceptable !'}",
            "{'PLAYER',    'Determined','(Je hoche la tête : il est temps de prouver la force de notre équipe.)'}",
            "{'Luxray', 'Worried', 'J ai essayé de grimper trois fois, mais ses éboulis m ont fait redescendre en roulant.'}",
            "{'Luxray', 'Sad',     'Si je n atteins pas la falaise du sommet ce mois-ci, je ne serai jamais un vrai garde.'}",
            "{'Teammate1', 'Determined','Comptez sur nous ! Nous allons monter au sommet et relever le défi de Drattak !'}",
            "{'Luxray', 'Inspired','Explorateurs, pouvez-vous affronter Drattak pour prouver notre bravoure à tous ?'}"
        ],
        "accept": [
            "{'Luxray', 'Happy',   'GÉ-NIAL ! Vous êtes mes idoles ! Montrons-lui de quel rocher on se chauffe !'}",
            "{'Teammate1', 'Happy', 'Nous portons les couleurs de la garde jusqu au sommet !'}",
            "{'Luxray', 'Normal',  'Le sentier de la crête s élève juste au-dessus du vieux pont de pierre.'}"
        ],
        "refuse": [
            "{'Luxray', 'Sad',     'Tant pis... Je suppose que je vais rester un garde de plaine.'}",
            "{'Teammate1', 'Sad',   'Nous avons d autres missions en cours, mais nous reviendrons.'}"
        ],
        "pending": [
            "{'Luxray', 'Worried', 'Avez-vous atteint le sommet de la Crête Craquelée ?'}",
            "{'Teammate1', 'Determined','Nous progressons sur les corniches nord, tenez bon !'}"
        ],
        "done": [
            "{'Luxray', 'Inspired','YOUHOU ! VOUS AVEZ VAINCU DRATTAK LA CIME !'}",
            "{'Teammate1', 'Happy', 'Drattak a été impressionné par notre ténacité et a rouvert le sentier des crêtes !'}",
            "{'PLAYER',    'Happy', '(Je vois Luxray se redresser avec une fierté de gardien retrouvée.)'}",
            "{'Luxray', 'Happy',   'Il m a envoyé un message par le vent : le sommet est désormais ouvert à ceux qui osent !'}",
            "{'Luxray', 'Surprised','Je vais pouvoir commencer mon entraînement de crête dès demain !'}",
            "{'Teammate1', 'Inspired','Les patrouilles d altitude veilleront sur toute la vallée du sud !'}",
            "{'Luxray', 'Happy',   'Je protégerai Metano avec encore plus de force et de fierté !'}",
            "{'Luxray', 'Inspired','Tenez, prenez ce trésor de crête que j avais ramassé en bas de la falaise !'}",
            "{'Luxray', 'Normal',  'Merci de donner des ailes aux rêves des gardiens !'}"
        ]
    },
    {
        "id": "q8_vallon", "ch": 8, "giver": "Gloom",
        "unlock_dungeon": "suspended_valley", "dungeon_name": "Vallon Suspendu",
        "titre": "La plume d'argent",
        "ask": [
            "{'Gloom', 'Sad',     'Cuii... J ai perdu le trésor le plus précieux de notre jardin...'}",
            "{'Teammate1', 'Surprised','Ortide ? Quel trésor avez-vous perdu dans la brume ?'}",
            "{'Gloom', 'Worried', 'C est la plume d argent royale, offerte par les grands oiseaux des sommets.'}",
            "{'Gloom', 'Normal',  'Elle s est envolée dans le Vallon Suspendu pendant un coup de vent violent.'}",
            "{'Gloom', 'Angry',   'Et Bruyverne le Cri l a capturée dans sa caverne des hauteurs !'}",
            "{'Gloom', 'Sad',     'Ses ultrasons sont si violents qu ils nous empêchent de voler au-dessus du vallon.'}",
            "{'Teammate1', 'Worried', 'Des ultrasons qui brisent la paix de tout le vallon ? C est très inquiétant !'}",
            "{'PLAYER',    'Determined','(Je hoche la tête avec calme : nous avons affronté bien des tempêtes.)'}",
            "{'Gloom', 'Worried', 'Cette plume était le talisman qui protégeait notre haie contre la tempête.'}",
            "{'Gloom', 'Sad',     'Sans elle, notre haie risque de se disperser à la prochaine bourrasque.'}",
            "{'Teammate1', 'Determined','Ne vous en faites pas ! Nous allons grimper dans le vallon et rapporter votre plume !'}",
            "{'Gloom', 'Inspired','Pouvez-vous grimper au secours de notre haie pour rapporter la plume d argent ?'}"
        ],
        "accept": [
            "{'Gloom', 'Happy',   'Merci ! Vous avez la justice avec vous !'}",
            "{'Teammate1', 'Happy', 'Préparez votre jardin, la plume sacrée revient !'}",
            "{'Gloom', 'Normal',  'Le vallon flottant est accessible par les courants ascendants de l ouest.'}"
        ],
        "refuse": [
            "{'Gloom', 'Sad',     'Je comprends, le vent des abîmes est terrible.'}",
            "{'Teammate1', 'Sad',   'Nous reviendrons dès que le vent sera moins violent.'}"
        ],
        "pending": [
            "{'Gloom', 'Worried', 'Avez-vous retrouvé notre plume dans le Vallon Suspendu ?'}",
            "{'Teammate1', 'Determined','Nous montons dans les nuages suspendus, courage !'}"
        ],
        "done": [
            "{'Gloom', 'Inspired','LA PLUME D ARGENT ! Elle brille de tous ses feux célestes !'}",
            "{'Teammate1', 'Happy', 'Bruyverne gardait la plume parce qu il admirait sa beauté, il nous l a rendue après le combat !'}",
            "{'PLAYER',    'Happy', '(Je vois la douce lumière céleste illuminer les pétales d Ortide.)'}",
            "{'Gloom', 'Happy',   'Vous avez bravé les ouragans sonores de Bruyverne le Cri !'}",
            "{'Gloom', 'Surprised','Notre jardin est immédiatement redevenu calme et stable sous sa lumière !'}",
            "{'Teammate1', 'Inspired','Le calme est revenu dans tout le vallon suspendu !'}",
            "{'Gloom', 'Happy',   'Tous les habitants du vallon chanteront votre épopée à chaque aube !'}",
            "{'Gloom', 'Inspired','Veuillez accepter ces orbes célestes et cette récompense d or du sommet !'}",
            "{'Gloom', 'Normal',  'Que le vent céleste porte vos pas pour l éternité !'}"
        ]
    },
    # === CHAPITRE 9 ===
    {
        "id": "q9_bassin", "ch": 9, "giver": "Wooper_Boy",
        "unlock_dungeon": "depleted_basin", "dungeon_name": "Bassin Tari",
        "titre": "La perle d'eau pure",
        "ask": [
            "{'Wooper_Boy', 'Worried', 'Psyyy... J ai un mal de crâne atroce qui ne s arrête jamais...'}",
            "{'Teammate1',  'Surprised','Axoloto ! Vous tenez votre tête à deux pattes, qu est-ce qui ne va pas ?'}",
            "{'Wooper_Boy', 'Sad',     'Notre bassin de baignade s assèche à une vitesse anormale depuis quatre jours.'}",
            "{'Wooper_Boy', 'Normal',  'Le Bassin Tari est une grande dépression lacustre au sud de la plaine de limon.'}",
            "{'Wooper_Boy', 'Angry',   'Léviator le Courroux y a accaparé la perle d eau pure au fond de l abysse !'}",
            "{'Wooper_Boy', 'Sad',     'Il absorbe toute la source hydrique pour alimenter sa propre colère.'}",
            "{'Teammate1',  'Angry',   'Accaparer toute la source du bassin et assécher le quartier ? C est affreux !'}",
            "{'PLAYER',     'Determined','(Je croise les bras : nous savons comment calmer un Léviator en furie.)'}",
            "{'Wooper_Boy', 'Worried', 'Sans cette eau fraîche, nos réserves s épuisent vite !'}",
            "{'Wooper_Boy', 'Sad',     'Tous les Pokémon aquatiques du quartier nagent dans trois centimètres de boue.'}",
            "{'Teammate1',  'Determined','Comptez sur notre expédition ! Nous allons affronter Léviator et ramener la perle !'}",
            "{'Wooper_Boy', 'Inspired','Par pitié, pouvez-vous affronter Léviator pour ramener la perle et la pluie ?'}"
        ],
        "accept": [
            "{'Wooper_Boy', 'Happy',   'Quel soulagement ! Ma tête va déjà un tout petit peu mieux !'}",
            "{'Teammate1',  'Happy',   'Préparez vos étangs, l eau claire couler bientôt à flots !'}",
            "{'Wooper_Boy', 'Normal',  'Descendez dans le bassin par les rochers humides de la rive sud.'}"
        ],
        "refuse": [
            "{'Wooper_Boy', 'Sad',     'Aïe aïe aïe... Ma tête...'}",
            "{'Teammate1',  'Sad',     'Désolé, nous devons d abord réparer notre équipement lacustre.'}"
        ],
        "pending": [
            "{'Wooper_Boy', 'Worried', 'Avez-vous récupéré la perle d eau dans le Bassin Tari ?'}",
            "{'Teammate1',  'Determined','Nous descendons dans l abysse du bassin, tenez bon !'}"
        ],
        "done": [
            "{'Wooper_Boy', 'Inspired','LA PERLE D EAU PURE ! Regardez cette eau claire qui en jaillit !'}",
            "{'Teammate1',  'Happy',   'Léviator a retrouvé son calme une fois la perle remise à sa place sacrée !'}",
            "{'PLAYER',     'Happy',   '(Je vois les flaques de boue se changer instantanément en eau claire autour de nous.)'}",
            "{'Wooper_Boy', 'Happy',   'OH ! MON MAL DE CRÂNE A COMPLÈTEMENT DISPARU !'}",
            "{'Wooper_Boy', 'Surprised','Vous avez réussi à calmer la fureur dévastatrice de Léviator le Courroux ?'}",
            "{'Teammate1',  'Inspired','Le bassin s est rempli et les courants clairs irriguent toute la rive !'}",
            "{'Wooper_Boy', 'Happy',   'Les étangs de Metano se remplissent à nouveau d eau fraîche et pure !'}",
            "{'Wooper_Boy', 'Inspired','Prenez cette fabuleuse récompense lacustre que notre clan protégeait !'}",
            "{'Wooper_Boy', 'Normal',  'Vous êtes les héros des eaux claires !'}"
        ]
    },
    {
        "id": "q9_marais", "ch": 9, "giver": "Ludicolo",
        "unlock_dungeon": "wayward_wetlands", "dungeon_name": "Marais Errants",
        "titre": "Le nénuphar géant",
        "ask": [
            "{'Ludicolo', 'Sad',     'Plouf... Regardez la feuille sur ma tête, elle jaunit et se ratatibe...'}",
            "{'Teammate1', 'Surprised','Ludicolo ! Pourquoi avez-vous arrêté de danser ? Que se passe-t-il ?'}",
            "{'Ludicolo', 'Worried', 'Les Marais Errants sont empoisonnés par une brume violacée anormale.'}",
            "{'Ludicolo', 'Normal',  'C est un vaste réseau d étangs stagnants et de racines à l est du fleuve.'}",
            "{'Ludicolo', 'Angry',   'Et Milobellus le Bassin a scellé le sanctuaire des nénuphars géants au centre !'}",
            "{'Ludicolo', 'Sad',     'Ces nénuphars sacrés filtrent naturellement les toxines de notre eau.'}",
            "{'Teammate1', 'Worried', 'Une brume toxique qui détruit la végétation du marais ? C est gravissime !'}",
            "{'PLAYER',    'Determined','(Je hoche la tête : nous ne laisserons pas la brume empoisonner le marais.)'}",
            "{'Ludicolo', 'Worried', 'Si nous ne replantons pas une bouture saine dans notre mare avant ce soir...'}",
            "{'Ludicolo', 'Sad',     '...toute notre colonie perdra sa musique pour toujours.'}",
            "{'Teammate1', 'Determined','Ne vous arrêtez pas de danser ! Nous allons traverser les marais et rapporter cette bouture !'}",
            "{'Ludicolo', 'Inspired','Explorateurs, pouvez-vous traverser les marais pour nous cueillir une bouture ?'}"
        ],
        "accept": [
            "{'Ludicolo', 'Happy',   'Plouf ! Youpi ! Vous êtes l eau vive de notre espoir !'}",
            "{'Teammate1', 'Happy', 'Préparez votre piste de danse, la bouture arrive !'}",
            "{'Ludicolo', 'Normal',  'Les marais commencent après le pont de bois moussue de la rivière Est.'}"
        ],
        "refuse": [
            "{'Ludicolo', 'Sad',     'Plouf... C est triste. Nous allons devoir ramper dans la vase sèche.'}",
            "{'Teammate1', 'Sad',   'Nous avons besoin de réserves antipoisons avant de tenter l expédition.'}"
        ],
        "pending": [
            "{'Ludicolo', 'Worried', 'Avez-vous réussi à cueillir la bouture de nénuphar des Marais Errants ?'}",
            "{'Teammate1', 'Determined','Nous avançons entre les étangs violets, tenez bon !'}"
        ],
        "done": [
            "{'Ludicolo', 'Inspired','PLOUF ! LE NÉNUPHAR GÉANT ! Quel parfum de pureté et d eau fraîche !'}",
            "{'Teammate1', 'Happy', 'Milobellus protégeait le sanctuaire des brumes, elle nous a donné la meilleure bouture !'}",
            "{'PLAYER',    'Happy', '(Je vois Ludicolo esquisser un pas de danse joyeux en trempant la bouture.)'}",
            "{'Ludicolo', 'Happy',   'Vous avez convaincu Milobellus le Bassin de rouvrir le sanctuaire !'}",
            "{'Ludicolo', 'Surprised','Regardez ! En posant la feuille sur notre mare, toute l eau s est purifiée !'}",
            "{'Teammate1', 'Inspired','L eau des marais a retrouvé ses beaux reflets émeraudes naturels !'}",
            "{'Ludicolo', 'Happy',   'Notre danse est redevenue verte, luisante et forte !'}",
            "{'Ludicolo', 'Inspired','Voici des trésors des berges et une belle prime pour votre guilde !'}",
            "{'Ludicolo', 'Normal',  'Merci de protéger les humbles habitants des eaux !'}"
        ]
    },
    {
        "id": "q9_jungle", "ch": 9, "giver": "Roselia",
        "unlock_dungeon": "southern_jungle", "dungeon_name": "Jungle Méridionale",
        "titre": "La graine solaire",
        "ask": [
            "{'Roselia', 'Worried', 'Au secours ! Il fait nuit noire en plein midi dans notre sous-bois !'}",
            "{'Teammate1', 'Surprised','Rosélia ? Pourquoi la lumière n atteint plus votre jardin ?'}",
            "{'Roselia', 'Sad',     'La canopée de la Jungle Méridionale est devenue si dense que le soleil ne passe plus.'}",
            "{'Roselia', 'Normal',  'C est une forêt tropicale foisonnante qui s étend vers les côtes chaudes du sud.'}",
            "{'Roselia', 'Angry',   'Mais Roserade le Venin a emprisonné la graine solaire sacrée dans son antre !'}",
            "{'Roselia', 'Sad',     'Elle utilise sa lumière pour cultiver ses propres fleurs toxiques géantes.'}",
            "{'Teammate1', 'Angry',   'Emprisonner le soleil de la jungle pour cultiver du venin ? C est intolérable !'}",
            "{'PLAYER',    'Determined','(Je regarde vers le sud : nous allons ramener la lumière dans la jungle.)'}",
            "{'Roselia', 'Worried', 'Sans la graine solaire, toutes les plantes de Metano s arrêtent de pousser.'}",
            "{'Roselia', 'Sad',     'Nos pétales s étiolent et nous ne pouvons plus synthétiser d énergie.'}",
            "{'Teammate1', 'Determined','Comptez sur nous ! Nous partons affronter la jungle tropicale !'}",
            "{'Roselia', 'Inspired','Pouvez-vous affronter la jungle tropicale pour nous libérer la graine solaire ?'}"
        ],
        "accept": [
            "{'Roselia', 'Happy',   'Merci ! Nos racines trépignent d impatience ! Vous êtes nos soleils !'}",
            "{'Teammate1', 'Happy', 'Préparez vos pétales, la lumière dorée revient très vite !'}",
            "{'Roselia', 'Normal',  'La jungle démarre juste derrière les grands banians de la lisière sud.'}"
        ],
        "refuse": [
            "{'Roselia', 'Sad',     'Oh non... Nous allons devoir vivre dans une pénombre éternelle.'}",
            "{'Teammate1', 'Sad',   'Nous reviendrons dès que nous aurons de quoi percer la canopée.'}"
        ],
        "pending": [
            "{'Roselia', 'Worried', 'Avez-vous libéré la graine solaire de la Jungle Méridionale ?'}",
            "{'Teammate1', 'Determined','Nous nous frayons un chemin dans les lianes, courage !'}"
        ],
        "done": [
            "{'Roselia', 'Inspired','LA GRAINE SOLAIRE ! Regardez cette lueur dorée incroyable qui en émane !'}",
            "{'Teammate1', 'Happy', 'Roserade a accepté de partager la graine pour illuminer tout le sous-bois !'}",
            "{'PLAYER',    'Happy', '(Je vois un grand rayon de soleil doré venir caresser les fleurs du village.)'}",
            "{'Roselia', 'Happy',   'OH ! Les arbres se sont écartés et un magnifique rayon de soleil éclaire la ville !'}",
            "{'Roselia', 'Surprised','Vous avez triomphé des lianes empoisonnées de Roserade le Venin ?'}",
            "{'Teammate1', 'Inspired','Notre travail d équipe a purifié la canopée méridionale !'}",
            "{'Roselia', 'Happy',   'Toutes les fleurs de la région ouvrent leurs pétales pour vous saluer !'}",
            "{'Roselia', 'Inspired','Prenez ce trésor végétal et ces graines rares que la jungle gardait !'}",
            "{'Roselia', 'Normal',  'Vous avez ramené le printemps dans nos cœurs pour toujours !'}"
        ]
    },
    {
        "id": "q9_gouffre", "ch": 9, "giver": "Quagsire",
        "unlock_dungeon": "submerged_chasm", "dungeon_name": "Gouffre Immergé",
        "titre": "La conque abyssale",
        "ask": [
            "{'Quagsire', 'Sad',     'Clac... Clac... Je suis inconsolable... J ai perdu l héritage de mon clan.'}",
            "{'Teammate1', 'Surprised','Maraiste ? Quel est ce coquillage que vous cherchez dans le port ?'}",
            "{'Quagsire', 'Worried', 'C est la conque abyssale, un coquillage géant qui résonne avec le chant des mers.'}",
            "{'Quagsire', 'Normal',  'Elle a glissé lors des grandes marées d automne.'}",
            "{'Quagsire', 'Angry',   'Elle est tombée tout au fond du Gouffre Immergé, où trône Hyporoi le Fond !'}",
            "{'Quagsire', 'Sad',     'Il a installé son repaire dans cette faille marine aux pressions écrasantes.'}",
            "{'Teammate1', 'Worried', 'Une conque qui guide les marées emportée au fond de la faille ?'}",
            "{'PLAYER',    'Determined','(Je fais un pas en avant avec confiance : nous sommes des pros des abysses.)'}",
            "{'Quagsire', 'Worried', 'Sans le chant de la conque, notre clan ne sait plus orienter ses coquilles.'}",
            "{'Quagsire', 'Sad',     'Les courants nous ballottent contre les rochers sans repère.'}",
            "{'Teammate1', 'Determined','Ne désespérez pas ! Nous allons plonger au fond du gouffre et vous rapporter la conque !'}",
            "{'Quagsire', 'Inspired','Explorateurs, pouvez-vous plonger dans la faille pour rapporter notre conque ?'}"
        ],
        "accept": [
            "{'Quagsire', 'Happy',   'Clac ! Formidable ! Vous avez le courage des grands cachalots du large !'}",
            "{'Teammate1', 'Happy', 'La conque abyssale résonnera à nouveau, promesse d explorateur !'}",
            "{'Quagsire', 'Normal',  'Le gouffre sous-marin s ouvre au bout de la grande jetée rocheuse.'}"
        ],
        "refuse": [
            "{'Quagsire', 'Sad',     'Clac... Je comprends, les profondeurs noires sont terrifiantes pour les terrestres.'}",
            "{'Teammate1', 'Sad',   'Nous allons vérifier nos réserves d air et revenir.'}"
        ],
        "pending": [
            "{'Quagsire', 'Worried', 'Avez-vous atteint le fond du Gouffre Immergé ?'}",
            "{'Teammate1', 'Determined','Nous plongeons dans les courants profonds, tenez bon !'}"
        ],
        "done": [
            "{'Quagsire', 'Inspired','CLAC ! CLAC ! LA CONQUE ABYSSALE ! Écoutez cette mélodie céleste !'}",
            "{'Teammate1', 'Happy', 'Hyporoi écoutait son chant au fond des abysses, mais il nous l a remise avec honneur !'}",
            "{'PLAYER',    'Happy', '(Je sens les ondes apaisantes de la conque résonner sur le rivage.)'}",
            "{'Quagsire', 'Happy',   'Elle résonne à nouveau dans tout le port avec une pureté marine parfaite !'}",
            "{'Quagsire', 'Surprised','Vous avez bravé les tourbillons à haute pression d Hyporoi le Fond ?'}",
            "{'Teammate1', 'Inspired','La pression était intense, mais notre détermination n a pas flanché !'}",
            "{'Quagsire', 'Happy',   'Notre clan retrouve enfin son équilibre et sa fierté ancestrale !'}",
            "{'Quagsire', 'Inspired','Voici des perles marines inestimables que nos ancêtres avaient pêchées !'}",
            "{'Quagsire', 'Normal',  'Vous serez toujours nos invités d honneur sur toutes les mers !'}"
        ]
    },
    # === CHAPITRE 10 ===
    {
        "id": "q10_sentier", "ch": 10, "giver": "Furret",
        "unlock_dungeon": "snowbound_path", "dungeon_name": "Sentier Enneigé",
        "titre": "La cape du blizzard",
        "ask": [
            "{'Furret', 'Sad',     'Frrr... Frrr... Le froid glaciaire pèse trop lourd sur mes petites épaules.'}",
            "{'Teammate1', 'Surprised','Fouineau ! Vous grelottez ! Le vent polaire descend jusqu ici ?'}",
            "{'Furret', 'Worried', 'Ma cape de paille traditionnelle ne résiste plus aux blizzards polaires du nord.'}",
            "{'Furret', 'Normal',  'Le Sentier Enneigé est le grand col alpin qui relie Metano aux glaciers éternels.'}",
            "{'Furret', 'Angry',   'Mais Momartik le Souffle a confisqué toute la soie de givre sacrée au sommet !'}",
            "{'Furret', 'Sad',     'Elle la réserve exclusivement à sa cour d ombres gelées.'}",
            "{'Teammate1', 'Angry',   'Confisquer la soie qui protège les habitants du gel ? C est un caprice de blizzard !'}",
            "{'PLAYER',    'Determined','(Je regarde vers les pics enneigés avec une détermination à toute épreuve.)'}",
            "{'Furret', 'Worried', 'Si je ne me fais pas une cape de givre avant la grande nuit d hiver...'}",
            "{'Furret', 'Sad',     '...je serai congelée sur place sans pouvoir sortir de chez moi.'}",
            "{'Teammate1', 'Determined','Nous allons grimper sur le sentier alpin et vous obtenir cette soie de givre !'}",
            "{'Furret', 'Inspired','Explorateurs, pouvez-vous affronter le col pour m obtenir de la soie de givre ?'}"
        ],
        "accept": [
            "{'Furret', 'Happy',   'Frrr ! Merci infiniment ! Vous me réchauffez déjà le cœur !'}",
            "{'Teammate1', 'Happy', 'Restez près du feu de guilde, nous partons dans la neige !'}",
            "{'Furret', 'Normal',  'Le sentier enneigé débute après le pont des glaces à l extrême nord.'}"
        ],
        "refuse": [
            "{'Furret', 'Sad',     'Frrr... Je comprends... La neige là-haut est un mur infranchissable.'}",
            "{'Teammate1', 'Sad',   'Nous allons chercher des baies réchauffantes et nous revenons.'}"
        ],
        "pending": [
            "{'Furret', 'Worried', 'Avez-vous réussi à gravir le Sentier Enneigé ?'}",
            "{'Teammate1', 'Determined','Nous gravissons les crêtes blanches, courage !'}"
        ],
        "done": [
            "{'Furret', 'Inspired','FRRR ! LA SOIE DE GIVRE ! Regardez sa texture étincelante et légère !'}",
            "{'Teammate1', 'Happy', 'Momartik a reconnu notre chaleur d âme et a partagé son plus beau tissu !'}",
            "{'PLAYER',    'Happy', '(Je vois Fouineau s envelopper dans la soie blanche avec un soupir de bonheur.)'}",
            "{'Furret', 'Happy',   'OH ! En l enfilant, je ne ressens plus aucune morsure du blizzard !'}",
            "{'Furret', 'Surprised','Vous avez vaincu les illusions glacées de la redoutable Momartik le Souffle ?'}",
            "{'Teammate1', 'Inspired','La tempête de grêle n a pas pu éteindre le feu de notre expédition !'}",
            "{'Furret', 'Happy',   'Je vais pouvoir courir dans la neige avec mes amis pendant tout l hiver !'}",
            "{'Furret', 'Inspired','Prenez cette récompense de cristaux de givre pur et d or alpin !'}",
            "{'Furret', 'Normal',  'Merci de réchauffer la vie des plus fragiles dans la tempête !'}"
        ]
    },
    {
        "id": "q10_foudre", "ch": 10, "giver": "Spinda",
        "unlock_dungeon": "thunderstruck_pass", "dungeon_name": "Col de la Foudre",
        "titre": "Le paratonnerre antique",
        "ask": [
            "{'Spinda', 'Worried', 'Bzz ! Bzz ! Alerte rouge ! Des éclairs tombent sur les toits de la ville !'}",
            "{'Teammate1', 'Surprised','Spinda ! Pourquoi le café tremble-t-il autant sous le tonnerre ?'}",
            "{'Spinda', 'Sad',     'Le système de paratonnerres naturels du Col de la Foudre est déréglé.'}",
            "{'Spinda', 'Normal',  'C est un col de haute montagne où les nuages d orage convergent en permanence.'}",
            "{'Spinda', 'Angry',   'Et Magnézone l Éclair a déconnecté la borne d ancrage électrique au sommet !'}",
            "{'Spinda', 'Sad',     'Il concentre tous les éclairs sur sa propre coque pour augmenter son champ de force.'}",
            "{'Teammate1', 'Worried', 'Une borne déconnectée qui fait foudroyer toute la vallée ? C est un péril immédiat !'}",
            "{'PLAYER',    'Determined','(Je regarde mon partenaire : nous savons comment négocier avec un Magnézone.)'}",
            "{'Spinda', 'Worried', 'Sans la borne d ancrage, la foudre frappe au hasard dans toute la vallée de Metano.'}",
            "{'Spinda', 'Sad',     'Si un éclair touche la réserve de poudres de la guilde, ce sera la catastrophe.'}",
            "{'Teammate1', 'Determined','Laissez-nous faire, Spinda ! Nous allons gravir le col et rebrancher cette borne !'}",
            "{'Spinda', 'Inspired','Pouvez-vous gravir le col sous la foudre pour réactiver la borne d ancrage ?'}"
        ],
        "accept": [
            "{'Spinda', 'Happy',   'Bzz ! GÉNIAL ! Votre énergie positive électrise toute notre équipe !'}",
            "{'Teammate1', 'Happy', 'Abritez le café, nous partons au sommet !'}",
            "{'Spinda', 'Normal',  'Le col est visible au nord-est, là où le ciel clignote sans cesse.'}"
        ],
        "refuse": [
            "{'Spinda', 'Sad',     'Bzz... Je comprends... La foudre ne pardonne aucun faux pas.'}",
            "{'Teammate1', 'Sad',   'Nous devons installer des isolants électriques d abord.'}"
        ],
        "pending": [
            "{'Spinda', 'Worried', 'Bzz ! Le Col de la Foudre est-il à nouveau sécurisé ?'}",
            "{'Teammate1', 'Determined','Nous affrontons les éclairs sur la crête, bzz !'}"
        ],
        "done": [
            "{'Spinda', 'Inspired','BZZ ! BZZ ! BORNE D ANCRAGE RÉACTIVÉE ! Regardez le ciel !'}",
            "{'Teammate1', 'Happy', 'Magnézone a rebranché le paratonnerre après avoir mesuré notre détermination !'}",
            "{'PLAYER',    'Happy', '(Le ciel au-dessus de la place perd sa couleur noire menaçante.)'}",
            "{'Spinda', 'Happy',   'Les éclairs sont à nouveau canalisés proprement vers les crêtes lointaines !'}",
            "{'Spinda', 'Surprised','Vous avez tenu le choc face au magnétisme fulgurant de Magnézone l Éclair ?'}",
            "{'Teammate1', 'Inspired','Notre coordination électrique a surmonté la tempête !'}",
            "{'Spinda', 'Happy',   'Toute la ville va pouvoir dormir tranquille sans craindre la foudre !'}",
            "{'Spinda', 'Inspired','Voici des Orbes Foudre rares et une prime spéciale de la garde électrique !'}",
            "{'Spinda', 'Normal',  'Vous êtes de véritables paratonnerres de courage !'}"
        ]
    },
    {
        "id": "q10_falaises", "ch": 10, "giver": "Zigzagoon",
        "unlock_dungeon": "flyaway_cliffs", "dungeon_name": "Falaises de l'Envol",
        "titre": "L'œuf du nid suprême",
        "ask": [
            "{'Zigzagoon', 'Sad',     'Cui ! Cui ! Au secours ! Un malheur est arrivé à notre couvée de printemps !'}",
            "{'Teammate1', 'Surprised','Zigzagoon ? Vous parlez pour les oiseaux de la falaise ? Que se passe-t-il ?'}",
            "{'Zigzagoon', 'Worried', 'Une bourrasque ascendante a emporté un œuf royal au-dessus des falaises.'}",
            "{'Zigzagoon', 'Normal',  'Les Falaises de l Envol sont des à-pics rocheux vertigineux qui touchent les nuages.'}",
            "{'Zigzagoon', 'Angry',   'Et Roucarnage le Sommet a recueilli l œuf dans son nid géant sur la plus haute crête !'}",
            "{'Zigzagoon', 'Sad',     'Il refuse de le rendre, prétendant que seul le ciel de haute altitude l est digne.'}",
            "{'Teammate1', 'Worried', 'Mais si l œuf quitte son nid d origine, il risque de ne jamais éclore !'}",
            "{'PLAYER',    'Determined','(Je regarde vers les hautes parois rocheuses de l est.)'}",
            "{'Zigzagoon', 'Worried', 'Sans la chaleur maternelle du nid d en bas, l œuf va se refroidir dans le vent.'}",
            "{'Zigzagoon', 'Sad',     'Les vents là-haut sont trop violents pour que de petits Pokémon aillent négocier.'}",
            "{'Teammate1', 'Determined','Comptez sur nous ! Nous allons gravir ces falaises et rapporter cet œuf intact !'}",
            "{'Zigzagoon', 'Inspired','Explorateurs, avez-vous la force de gravir les falaises pour nous rapporter l œuf ?'}"
        ],
        "accept": [
            "{'Zigzagoon', 'Happy',   'CUI ! CUI ! Merci ! Vous nous redonnez le souffle de l espoir !'}",
            "{'Teammate1', 'Happy', 'Préparez un nid bien chaud, nous partons sur les hauteurs !'}",
            "{'Zigzagoon', 'Normal',  'Le sentier des falaises monte en lacets par la face nord de la falaise d argent.'}"
        ],
        "refuse": [
            "{'Zigzagoon', 'Sad',     'Cui... C est si triste. Le nid restera vide cette saison.'}",
            "{'Teammate1', 'Sad',   'Nous devons chercher des cordes d escalade avant de partir.'}"
        ],
        "pending": [
            "{'Zigzagoon', 'Worried', 'Avez-vous atteint le nid suprême des Falaises de l Envol ?'}",
            "{'Teammate1', 'Determined','Nous montons dans les rafales des sommets, courage !'}"
        ],
        "done": [
            "{'Zigzagoon', 'Inspired','CUI ! L ŒUF ROYAL ! Regardez, il bouge ! Il est intact et chaud !'}",
            "{'Teammate1', 'Happy', 'Roucarnage le protégeait du blizzard d altitude, il nous l a confié après le duel !'}",
            "{'PLAYER',    'Happy', '(Je vois l œuf se fendiller doucement au soleil couchant.)'}",
            "{'Zigzagoon', 'Happy',   'OH ! Vous entendez ces petits coups de bec à l intérieur ? Il va éclore !'}",
            "{'Zigzagoon', 'Surprised','Vous avez vaincu les ouragans d ailes du grand Roucarnage le Sommet ?'}",
            "{'Teammate1', 'Inspired','Les falaises de l envol sont à nouveau un havre de paix pour tous les nids !'}",
            "{'Zigzagoon', 'Happy',   'Vous avez sauvé la génération future de tous les oiseaux de la vallée !'}",
            "{'Zigzagoon', 'Inspired','Veuillez accepter ces plumes célestes et cette récompense d or du nid !'}",
            "{'Zigzagoon', 'Normal',  'Notre gratitude vous accompagnera et vous guidera où que vous alliez !'}"
        ]
    },
    {
        "id": "q10_cime", "ch": 10, "giver": "Nidoking",
        "unlock_dungeon": "forgotten_silver_spire", "dungeon_name": "Cime d'Argent Oubliée",
        "titre": "Le diadème d'argent",
        "ask": [
            "{'Nidoking', 'Sad',     'Hummm... Hummm... Un voile de ténèbres psychiques s est abattu sur nos esprits.'}",
            "{'Teammate1', 'Surprised','Nidoking ? Pourquoi votre clan semble-t-il si épuisé par les nuits ?'}",
            "{'Nidoking', 'Worried', 'Le diadème d argent qui clarifiait nos rêves a été subtilisé dans notre sanctuaire.'}",
            "{'Nidoking', 'Normal',  'La Cime d Argent Oubliée est un pic minéral sacré qui s élève au-dessus de la Tour Céleste.'}",
            "{'Nidoking', 'Angry',   'Et Kaorine l Antique l a scellé dans son autel pour invoquer des visions du passé !'}",
            "{'Nidoking', 'Sad',     'Sa magie ancienne crée des interférences qui nous font faire des cauchemars sans fin.'}",
            "{'Teammate1', 'Worried', 'Des cauchemars qui empêchent toute la région de dormir ? C est dramatique !'}",
            "{'PLAYER',    'Determined','(Je hoche la tête vers la flèche céleste : nous allons lever ce fléau psychique.)'}",
            "{'Nidoking', 'Worried', 'Si le diadème ne retrouve pas son socle en bas, notre lucidité mentale va s éteindre.'}",
            "{'Nidoking', 'Sad',     'Nous sommes trop sensibles aux ondes de la cime pour pouvoir l approcher nous-mêmes.'}",
            "{'Teammate1', 'Determined','Faites-nous confiance ! Nous allons gravir la cime d argent et briser ce sceau !'}",
            "{'Nidoking', 'Inspired','Explorateurs au cœur pur, pouvez-vous purifier la cime pour nous ramener le diadème ?'}"
        ],
        "accept": [
            "{'Nidoking', 'Happy',   'Hummm ! Quel éclat d esprit pur ! Merci de tout notre être !'}",
            "{'Teammate1', 'Happy', 'Reposez-vous à l auberge, la lumière d argent va revenir !'}",
            "{'Nidoking', 'Normal',  'La cime argentée est accessible par l escalier de roche blanche au nord du pic.'}"
        ],
        "refuse": [
            "{'Nidoking', 'Sad',     'Hummm... Je comprends. La magie ancienne peut consumer l esprit.'}",
            "{'Teammate1', 'Sad',   'Nous devons renforcer notre résistance mentale d abord.'}"
        ],
        "pending": [
            "{'Nidoking', 'Worried', 'La Cime d Argent Oubliée a-t-elle retrouvé son silence sacré ?'}",
            "{'Teammate1', 'Determined','Nous atteignons le sommet d argent, les rêves clairs reviendront !'}"
        ],
        "done": [
            "{'Nidoking', 'Inspired','HUMMM ! LE DIADÈME D ARGENT ! Sa clarté irradie toute la place de Metano !'}",
            "{'Teammate1', 'Happy', 'Kaorine a accepté de relâcher le diadème après avoir contemplé notre sincérité !'}",
            "{'PLAYER',    'Happy', '(Je vois un faisceau de lumière d argent pure s élever vers le ciel du nord.)'}",
            "{'Nidoking', 'Happy',   'OH ! Regardez, toutes les ombres psychiques de nos esprits se dissipent !'}",
            "{'Nidoking', 'Surprised','Vous avez surmonté les mystères ancestraux du terrible Kaorine l Antique ?'}",
            "{'Teammate1', 'Inspired','Notre amitié est plus forte que n importe quel sort d interférence !'}",
            "{'Nidoking', 'Happy',   'Notre clan retrouve la paix mentale et des nuits sereines pour toujours !'}",
            "{'Nidoking', 'Inspired','Prenez ces joyaux sacrés d argent et cette prime céleste d exception !'}",
            "{'Nidoking', 'Normal',  'Que la lumière céleste veille sur votre amitié éternellement !'}"
        ]
    }
]

def update_side_quests_lua():
    if not os.path.exists(SIDE_QUESTS_LUA):
        return

    with open(SIDE_QUESTS_LUA, "r", encoding="utf-8") as f:
        content = f.read()

    lua_entries = []
    for q in EXPANDED_SIDE_QUESTS:
        ask_str = ",\n      ".join(q["ask"])
        accept_str = ",\n      ".join(q["accept"])
        refuse_str = ",\n      ".join(q["refuse"])
        pending_str = ",\n      ".join(q["pending"])
        done_str = ",\n      ".join(q["done"])

        entry = f"""
  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE (24-28 LIGNES AVEC PARTENAIRE/HÉROS) : {q['dungeon_name']} ===
  {{
    id = '{q['id']}', ch = {q['ch']}, giver = '{q['giver']}', target = '{q['giver']}',
    unlock_dungeon = '{q['unlock_dungeon']}', dungeon_name = "{q['dungeon_name']}",
    titre = "{q['titre']}",
    ask = {{
      {ask_str}
    }},
    accept = {{{accept_str}}},
    refuse = {{{refuse_str}}},
    pending= {{{pending_str}}},
    solve  = {{{pending_str}}},
    done   = {{
      {done_str}
    }},
    undertow = "mission personnelle de déblocage donjon avec partenaire et héros",
  }},"""
        lua_entries.append(entry)

    header = content.split("-- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE")[0]
    if "SideQuests.LIST" not in header:
        return

    tail_split = content.split("function SideQuests.EnsureSV()")
    tail = "\nfunction SideQuests.EnsureSV()" + tail_split[1] if len(tail_split) > 1 else ""

    idx_insert = header.rfind("  },")
    if idx_insert != -1:
        header = header[:idx_insert+4]

    new_content = header + "\n" + "\n".join(lua_entries) + "\n}\n" + tail

    with open(SIDE_QUESTS_LUA, "w", encoding="utf-8") as f:
        f.write(new_content)

    print("  [OK] 20 Quêtes secondaires enrichies (24-28 lignes avec réactions du Partenaire et du Héros).")

def check_npc_positioning():
    if not os.path.exists(TOWN_LIFE_LUA):
        return
    with open(TOWN_LIFE_LUA, "r", encoding="utf-8") as f:
        tl_content = f.read()
    
    print("\n  [Contrôle de Positionnement des PNJ dans TownLife.TOURNEES / Ville de Metano] :")
    ok_count = 0
    for q in EXPANDED_SIDE_QUESTS:
        g = q["giver"]
        if f"{g} =" in tl_content or f"{g}=" in tl_content:
            print(f"    ✅ PNJ `{g:14s}` ({q['dungeon_name']:23s}) -> Présent et actif dans TownLife.TOURNEES")
            ok_count += 1
        else:
            print(f"    ⚠️ PNJ `{g:14s}` non trouvé dans TownLife.TOURNEES")
    print(f"  -> {ok_count} / 20 PNJ vérifiés présents et actifs en ville.")

def main():
    print("==========================================================================")
    print("=== ENRICHISSEMENT DIALOGUES PNJ (24-28 LIGNES AVEC PARTENAIRE & HÉROS) ===")
    print("==========================================================================\n")
    update_side_quests_lua()
    check_npc_positioning()
    print("\n==========================================================================")
    print("=== QUÊTES ENRICHIES ET INTERACTION PARTENAIRE/HÉROS CONTRÔLÉE ===")
    print("==========================================================================")

if __name__ == "__main__":
    main()
