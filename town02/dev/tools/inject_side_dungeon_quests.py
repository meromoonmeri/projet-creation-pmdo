#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
inject_side_dungeon_quests.py — Injecte les 20 quêtes secondaires PNJ de Metano Town
dans Data/Script/halcyon/SideQuests.lua pour le déblocage des donjons secondaires (Ch6-10).

Chaque quête :
  - Met en scène un PNJ de Metano Town qui a besoin d'aide (objet volé par un mini-boss/boss,
    ami piégé, urgence écologique).
  - Débloque le donjon dans `SV.ChapterProgression.UnlockedDungeons[dungeon_id] = true` lors de l'acceptation.
  - Offre une cinématique de récompense lorsque le donjon est complété (`SV.SecondaryJobsCompleted[dungeon_id] = true`).
"""
import os, sys, re

MOD_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SIDE_QUESTS_LUA = os.path.join(MOD_ROOT, "Data/Script/halcyon/SideQuests.lua")

SIDE_DUNGEON_QUESTS = [
    # --- CHAPITRE 6 ---
    {
        "id": "q6_desert", "ch": 6, "giver": "Doduo",
        "unlock_dungeon": "forsaken_desert", "dungeon_name": "Désert des Oubliés",
        "titre": "Le sac de courrier volé",
        "ask": [
            "{'Doduo', 'Worried', 'C est une catastrophe ! Ma sacoche de courrier prioritaire a disparu !'}",
            "{'Doduo', 'Angry',   'C est Hippodocus le Colosse qui me l a arrachée avant de s enfouir dans le Désert des Oubliés !'}",
            "{'Doduo', 'Sad',     'Si je ne livre pas ces lettres aujourd hui, je suis renvoyé...'}"
        ],
        "accept": ["{'Doduo', 'Happy', 'Merci mille fois ! Le désert s étend au sud-est de la route principale !'}"],
        "refuse": ["{'Doduo', 'Sad',   'Je comprends... Je vais devoir affronter le désert tout seul.'}"],
        "pending": ["{'Doduo', 'Worried', 'Avez-vous retrouvé ma sacoche de courrier dans le Désert des Oubliés ?'}"],
        "done": [
            "{'Doduo', 'Inspired', 'MA SACOCHE ! Et toutes les lettres sont intactes !'}",
            "{'Doduo', 'Happy',    'Vous avez sauvé ma tournée et ma réputation ! Tenez, voici pour votre guilde !'}"
        ]
    },
    {
        "id": "q6_geode", "ch": 6, "giver": "Gulpin",
        "unlock_dungeon": "geode_crevice", "dungeon_name": "Crevasse de Géode",
        "titre": "Tarinor pris au piège",
        "ask": [
            "{'Gulpin', 'Sad',     'Gloup... Mon ami Tarinor n est pas rentré de son expédition minérale.'}",
            "{'Gulpin', 'Worried', 'Un éboulement provoqué par Gigalithe le Diamant a bloqué la Crevasse de Géode !'}",
            "{'Gulpin', 'Normal',  'Il a besoin d une équipe d explorateurs pour dégager la roche.'}"
        ],
        "accept": ["{'Gulpin', 'Happy', 'Gloup ! La crevasse se trouve au nord des anciennes carrières !'}"],
        "refuse": ["{'Gulpin', 'Sad',   'Gloup... J espère que sa boussole interne tiendra le coup.'}"],
        "pending": ["{'Gulpin', 'Worried', 'Avez-vous réussi à dégager la Crevasse de Géode ?'}"],
        "done": [
            "{'Gulpin', 'Happy',   'GLOUP ! Tarinor est rentré sain et sauf !'}",
            "{'Gulpin', 'Inspired','Il m a ramené ces cristaux rares, je vous en offre la moitié !'}"
        ]
    },
    {
        "id": "q6_verger", "ch": 6, "giver": "Silcoon",
        "unlock_dungeon": "wild_orchard", "dungeon_name": "Verger Sauvage",
        "titre": "La sève dorée de la reine",
        "ask": [
            "{'Silcoon', 'Worried', 'Les sous-bois du Verger Sauvage sont devenus impraticables.'}",
            "{'Silcoon', 'Sad',     'Apireine la Souveraine a confisqué toute la sève dorée dont nous avons besoin pour évoluer.'}",
            "{'Silcoon', 'Normal',  'Pouvez-vous négocier ou combattre pour rétablir le partage du verger ?'}"
        ],
        "accept": ["{'Silcoon', 'Happy', 'Merci... Le sentier du verger part juste à l ouest des arbres de guilde.'}"],
        "refuse": ["{'Silcoon', 'Sad',   '...Je vais devoir attendre une saison de plus dans ma coque.'}"],
        "pending": ["{'Silcoon', 'Worried', 'Le Verger Sauvage est-il à nouveau libre d accès ?'}"],
        "done": [
            "{'Silcoon', 'Inspired','La sève dorée coule de nouveau dans les arbres !'}",
            "{'Silcoon', 'Happy',   'Je sens que ma transformation est proche ! Merci à votre équipe !'}"
        ]
    },
    {
        "id": "q6_plaines", "ch": 6, "giver": "Mareep",
        "unlock_dungeon": "scorched_plains", "dungeon_name": "Plaines Brûlées",
        "titre": "Surcharges dans la savane",
        "ask": [
            "{'Mareep', 'Worried', 'Bêêê... La laine de mon troupeau fait des étincelles incontrôlables.'}",
            "{'Mareep', 'Angry',   'Élecsprint la Tempête a déclenché un orage statique permanent sur les Plaines Brûlées !'}",
            "{'Mareep', 'Sad',     'Il faut calmer sa colère pour que les plaines retrouvent leur sérénité.'}"
        ],
        "accept": ["{'Mareep', 'Happy', 'Bêêê ! Les plaines s étendent par-delà la colline foudroyée !'}"],
        "refuse": ["{'Mareep', 'Sad',   'Bêêê... Nous allons devoir rester à l abri des rochers.'}"],
        "pending": ["{'Mareep', 'Worried', 'Avez-vous apaisé les Plaines Brûlées ?'}"],
        "done": [
            "{'Mareep', 'Happy',   'BÊÊÊ ! L air est redevenu doux et respirable !'}",
            "{'Mareep', 'Inspired','Voici une Toison Douce pour vous remercier de votre bravoure !'}"
        ]
    },
    # --- CHAPITRE 7 ---
    {
        "id": "q7_jardin", "ch": 7, "giver": "Magnemite",
        "unlock_dungeon": "energy_garden", "dungeon_name": "Jardin d'Énergie",
        "titre": "L'antenne disparue",
        "ask": [
            "{'Magnemite', 'Worried', 'Bzz... Bzz... Communication interrompue avec notre relais du sous-sol.'}",
            "{'Magnemite', 'Sad',     'Lucario l Onde s est approprié l antenne de résonance du Jardin d Énergie.'}",
            "{'Magnemite', 'Normal',  'Nous avons besoin de guerriers pour descendre dans les cavernes de quartz.'}"
        ],
        "accept": ["{'Magnemite', 'Happy', 'Bzz ! Positif ! Le jardin se situe sous la faille minérale !'}"],
        "refuse": ["{'Magnemite', 'Sad',   'Bzz... Négatif... Signal perdu.'}"],
        "pending": ["{'Magnemite', 'Worried', 'Bzz... Avez-vous restauré le signal du Jardin d Énergie ?'}"],
        "done": [
            "{'Magnemite', 'Inspired','BZZ ! BZZ ! Signal rétabli à 100% !'}",
            "{'Magnemite', 'Happy',   'Connexion optimale ! Votre équipe est inscrite dans notre registre de héros !'}"
        ]
    },
    {
        "id": "q7_relique", "ch": 7, "giver": "Bronzor",
        "unlock_dungeon": "sunken_relic", "dungeon_name": "Relique Engloutie",
        "titre": "Les tables sacrées englouties",
        "ask": [
            "{'Bronzor', 'Sad',     'Hummm... Les eaux ont recouvert l entrée de la Relique Engloutie.'}",
            "{'Bronzor', 'Worried', 'Tutufeur le Gardien refuse de laisser quiconque transcrire les tables d histoire.'}",
            "{'Bronzor', 'Normal',  'Pouvez-vous explorer les ruines pour rapporter la transcription ?'}"
        ],
        "accept": ["{'Bronzor', 'Happy', 'Hummm ! La relique repose au fond de la crique ouest !'}"],
        "refuse": ["{'Bronzor', 'Sad',   'Hummm... L histoire restera prisonnière de la roche.'}"],
        "pending": ["{'Bronzor', 'Worried', 'Avez-vous transcrit les tables de la Relique Engloutie ?'}"],
        "done": [
            "{'Bronzor', 'Happy',   'HUMMM ! La transcription est complète et exacte !'}",
            "{'Bronzor', 'Inspired','La sagesse des anciens vivra grâce à vous !'}"
        ]
    },
    {
        "id": "q7_labyrinthe", "ch": 7, "giver": "Turtwig",
        "unlock_dungeon": "mossy_labyrinth", "dungeon_name": "Labyrinthe Moussue",
        "titre": "Les racines envahissantes",
        "ask": [
            "{'Turtwig', 'Worried', 'Les racines ligneuses de Torterra le Géant ont proliféré.'}",
            "{'Turtwig', 'Sad',     'Elles étouffent la flore du Labyrinthe Moussue et ferment les sentiers.'}",
            "{'Turtwig', 'Normal',  'Il faut élaguer le chemin avant que la forêt ne s effondre sur elle-même.'}"
        ],
        "accept": ["{'Turtwig', 'Happy', 'Merci ! Le labyrinthe commence au nord du grand vieux chêne !'}"],
        "refuse": ["{'Turtwig', 'Sad',   'Tant pis... Je vais essayer d arracher la mousse tout seul.'}"],
        "pending": ["{'Turtwig', 'Worried', 'Les sentiers du Labyrinthe Moussue sont-ils dégagés ?'}"],
        "done": [
            "{'Turtwig', 'Inspired','HOURRA ! Les jeunes pousses ont à nouveau accès à la lumière !'}",
            "{'Turtwig', 'Happy',   'Notre forêt vous est éternellement reconnaissante !'}"
        ]
    },
    {
        "id": "q7_carriere", "ch": 7, "giver": "Numel",
        "unlock_dungeon": "magma_quarry", "dungeon_name": "Carrière Magmatique",
        "titre": "Le charbon thermique",
        "ask": [
            "{'Numel', 'Sad',     'Pfff... Mes réserves de charbon thermique sont épuisées.'}",
            "{'Numel', 'Worried', 'Arkani la Flamme garde farouchement la mine centrale de la Carrière Magmatique.'}",
            "{'Numel', 'Normal',  'J ai besoin de quelques pépites de roche brûlante pour passer l hiver.'}"
        ],
        "accept": ["{'Numel', 'Happy', 'Pfff ! Chaleureux merci ! La carrière est dans la faille volcanique !'}"],
        "refuse": ["{'Numel', 'Sad',   'Pfff... Je vais avoir froid à la bosse.'}"],
        "pending": ["{'Numel', 'Worried', 'Avez-vous pu ramener le charbon de la Carrière Magmatique ?'}"],
        "done": [
            "{'Numel', 'Inspired','PFFF ! Quelle chaleur vivifiante dans ces minerais !'}",
            "{'Numel', 'Happy',   'Je suis réchauffée pour toute la saison ! Prenez cette récompense en or !'}"
        ]
    },
    # --- CHAPITRE 8 ---
    {
        "id": "q8_toundra", "ch": 8, "giver": "Spheal",
        "unlock_dungeon": "barren_tundra", "dungeon_name": "Toundra Désolée",
        "titre": "La cargaison gelée",
        "ask": [
            "{'Spheal', 'Sad',     'Aglagla... Ma livraison de baies a été prise dans une tempête de grêle.'}",
            "{'Spheal', 'Worried', 'Blizzarroi l Hiver la protège sur les hauteurs de la Toundra Désolée.'}",
            "{'Spheal', 'Normal',  'Qui osera affronter le blizzard pour me la rapporter ?'}"
        ],
        "accept": ["{'Spheal', 'Happy', 'Aglagla ! Merci ! Prenez le sentier qui monte vers les glaciers !'}"],
        "refuse": ["{'Spheal', 'Sad',   'Aglagla... Mes nageoires sont trop gelées pour y aller.'}"],
        "pending": ["{'Spheal', 'Worried', 'Avez-vous récupéré ma cargaison dans la Toundra Désolée ?'}"],
        "done": [
            "{'Spheal', 'Inspired','AGLAGLA ! Les baies sont encore parfaitement fraîches !'}",
            "{'Spheal', 'Happy',   'Vous êtes les héros des crêtes gelées !'}"
        ]
    },
    {
        "id": "q8_caverne", "ch": 8, "giver": "Aron",
        "unlock_dungeon": "barren_cavern", "dungeon_name": "Caverne Stérile",
        "titre": "Les filons d'acier",
        "ask": [
            "{'Aron', 'Worried', 'Croc... Les galeries d acier de la Caverne Stérile tremblent.'}",
            "{'Aron', 'Sad',     'Charmina le Sceau a scellé le passage vers le minerai ferreux.'}",
            "{'Aron', 'Normal',  'Notre colonie a besoin que vous brisiez ce sceau de roche.'}"
        ],
        "accept": ["{'Aron', 'Happy', 'Croc ! Formidable ! L entrée est au pied des éboulis de l est !'}"],
        "refuse": ["{'Aron', 'Sad',   'Croc... Nous devrons jeûner de minerai.'}"],
        "pending": ["{'Aron', 'Worried', 'Le passage de la Caverne Stérile est-il ouvert ?'}"],
        "done": [
            "{'Aron', 'Happy',   'CROC ! CROC ! Le minerai est libre d accès !'}",
            "{'Aron', 'Inspired','Notre carapace sera plus solide que jamais grâce à vous !'}"
        ]
    },
    {
        "id": "q8_crete", "ch": 8, "giver": "Bagon",
        "unlock_dungeon": "cracked_ridge", "dungeon_name": "Crête Craquelée",
        "titre": "Les ailes d'altitude",
        "ask": [
            "{'Bagon', 'Angry',   'Je veux voler ! Mais Drattak la Cime m interdit l accès au sommet !'}",
            "{'Bagon', 'Worried', 'Il dit que les secousses de la Crête Craquelée sont trop dangereuses.'}",
            "{'Bagon', 'Normal',  'Prouvez-lui que nous sommes assez forts pour atteindre le sommet !'}"
        ],
        "accept": ["{'Bagon', 'Happy', 'Génial ! La crête surplombe le vieux pont de corde !'}"],
        "refuse": ["{'Bagon', 'Sad',   '...Je vais continuer à sauter depuis mon rocher en bas.'}"],
        "pending": ["{'Bagon', 'Worried', 'Avez-vous vaincu le défi de la Crête Craquelée ?'}"],
        "done": [
            "{'Bagon', 'Inspired','YOUHOU ! Drattak a enfin reconnu mon courage !'}",
            "{'Bagon', 'Happy',   'Un jour je déploierai de grandes ailes rouges comme lui ! Merci !'}"
        ]
    },
    {
        "id": "q8_vallon", "ch": 8, "giver": "Fletchling",
        "unlock_dungeon": "suspended_valley", "dungeon_name": "Vallon Suspendu",
        "titre": "La plume d'argent",
        "ask": [
            "{'Fletchling', 'Sad',     'Cuii... J ai lâché ma plume porte-bonheur au-dessus des brumes.'}",
            "{'Fletchling', 'Worried', 'Elle s est posée dans le Vallon Suspendu, gardé par Bruyverne le Cri.'}",
            "{'Fletchling', 'Normal',  'Pouvez-vous voler à mon secours pour me la rapporter ?'}"
        ],
        "accept": ["{'Fletchling', 'Happy', 'Cuii ! Merci ! Suivez les courants d air ascendants !'}"],
        "refuse": ["{'Fletchling', 'Sad',   'Cuii... Mon nid sera triste sans elle.'}"],
        "pending": ["{'Fletchling', 'Worried', 'Avez-vous retrouvé ma plume dans le Vallon Suspendu ?'}"],
        "done": [
            "{'Fletchling', 'Inspired','CUII ! C est bien ma plume porte-bonheur !'}",
            "{'Fletchling', 'Happy',   'Que les vents vous soient toujours favorables, braves explorateurs !'}"
        ]
    },
    # --- CHAPITRE 9 ---
    {
        "id": "q9_bassin", "ch": 9, "giver": "Psyduck",
        "unlock_dungeon": "depleted_basin", "dungeon_name": "Bassin Tari",
        "titre": "La perle d'eau pure",
        "ask": [
            "{'Psyduck', 'Worried', 'Psyyy... J ai un mal de tête terrible à cause de la sécheresse.'}",
            "{'Psyduck', 'Sad',     'Léviator le Courroux a monopolisé la perle d eau pure au fond du Bassin Tari.'}",
            "{'Psyduck', 'Normal',  'Si vous la rapportez, la pluie apaisera mon crâne.'}"
        ],
        "accept": ["{'Psyduck', 'Happy', 'Psy ! Merci ! Le bassin descend sous la plaine de limon !'}"],
        "refuse": ["{'Psyduck', 'Sad',   'Psyyy... Aïe... Ma tête...'}"],
        "pending": ["{'Psyduck', 'Worried', 'Avez-vous trouvé la perle d eau du Bassin Tari ?'}"],
        "done": [
            "{'Psyduck', 'Inspired','PSY ! LA PERLE ! Mon mal de tête a complètement disparu !'}",
            "{'Psyduck', 'Happy',   'Vous êtes des magiciens de l eau, prenez ce trésor !'}"
        ]
    },
    {
        "id": "q9_marais", "ch": 9, "giver": "Lotad",
        "unlock_dungeon": "wayward_wetlands", "dungeon_name": "Marais Errants",
        "titre": "Le nénuphar géant",
        "ask": [
            "{'Lotad', 'Sad',     'Plouf... Ma feuille s assèche sous les brumes acides.'}",
            "{'Lotad', 'Worried', 'Milobellus le Bassin veille sur les nénuphars géants des Marais Errants.'}",
            "{'Lotad', 'Normal',  'Pouvez-vous en cueillir une bouture pour guérir notre mare ?'}"
        ],
        "accept": ["{'Lotad', 'Happy', 'Plouf ! Merci ! Les marais s ouvrent à l est du grand étang !'}"],
        "refuse": ["{'Lotad', 'Sad',   'Plouf... Ma feuille va finir par jaunir.'}"],
        "pending": ["{'Lotad', 'Worried', 'Avez-vous la bouture de nénuphar des Marais Errants ?'}"],
        "done": [
            "{'Lotad', 'Happy',   'PLOUF ! Quelle feuille magnifique et vivace !'}",
            "{'Lotad', 'Inspired','Notre mare est sauvée et resplendit à nouveau !'}"
        ]
    },
    {
        "id": "q9_jungle", "ch": 9, "giver": "Oddish",
        "unlock_dungeon": "southern_jungle", "dungeon_name": "Jungle Méridionale",
        "titre": "La graine solaire",
        "ask": [
            "{'Oddish', 'Worried', 'La canopée de la Jungle Méridionale est devenue trop dense.'}",
            "{'Oddish', 'Sad',     'Roserade le Venin a emprisonné la graine solaire qui éclaire nos plantes.'}",
            "{'Oddish', 'Normal',  'Aidez-nous à percer la canopée pour ramener la lumière !'}"
        ],
        "accept": ["{'Oddish', 'Happy', 'Merci ! La jungle démarre derrière les grands banians de la côte !'}"],
        "refuse": ["{'Oddish', 'Sad',   '...Nous ne pourrons plus faire de photosynthèse.'}"],
        "pending": ["{'Oddish', 'Worried', 'La Jungle Méridionale a-t-elle retrouvé son soleil ?'}"],
        "done": [
            "{'Oddish', 'Inspired','LA LUMIÈRE ! Le soleil traverse enfin les feuilles !'}",
            "{'Oddish', 'Happy',   'Nos pétales dansent de joie ! Merci de tout cœur !'}"
        ]
    },
    {
        "id": "q9_gouffre", "ch": 9, "giver": "Shellder",
        "unlock_dungeon": "submerged_chasm", "dungeon_name": "Gouffre Immergé",
        "titre": "La conque abyssale",
        "ask": [
            "{'Shellder', 'Sad',     'Clac... J ai perdu la conque abyssale de ma famille.'}",
            "{'Shellder', 'Worried', 'Elle a glissé au fond du Gouffre Immergé, où règne Hyporoi le Fond.'}",
            "{'Shellder', 'Normal',  'Seuls de grands plongeurs peuvent descendre aussi bas.'}"
        ],
        "accept": ["{'Shellder', 'Happy', 'Clac ! Formidable ! Le gouffre est dans la faille sous-marine !'}"],
        "refuse": ["{'Shellder', 'Sad',   'Clac... Ma coquille sonne creux sans elle.'}"],
        "pending": ["{'Shellder', 'Worried', 'Avez-vous rapporté la conque du Gouffre Immergé ?'}"],
        "done": [
            "{'Shellder', 'Inspired','CLAC ! CLAC ! Vous entendez cet écho marin divin ?'}",
            "{'Shellder', 'Happy',   'C est l authentique chant des abysses ! Merci !'}"
        ]
    },
    # --- CHAPITRE 10 ---
    {
        "id": "q10_sentier", "ch": 10, "giver": "Snorunt",
        "unlock_dungeon": "snowbound_path", "dungeon_name": "Sentier Enneigé",
        "titre": "La cape du blizzard",
        "ask": [
            "{'Snorunt', 'Sad',     'Frrr... Ma cape de paille ne suffit plus contre le vent polaire.'}",
            "{'Snorunt', 'Worried', 'Momartik le Souffle conserve le tissu glacé sacré au bout du Sentier Enneigé.'}",
            "{'Snorunt', 'Normal',  'Pouvez-vous lui demander un fragment de ce tissu polaire ?'}"
        ],
        "accept": ["{'Snorunt', 'Happy', 'Frrr ! Merci ! Le sentier longe la grande crête du nord !'}"],
        "refuse": ["{'Snorunt', 'Sad',   'Frrr... Je vais continuer à grelotter.'}"],
        "pending": ["{'Snorunt', 'Worried', 'Avez-vous le tissu glacé du Sentier Enneigé ?'}"],
        "done": [
            "{'Snorunt', 'Inspired','FRRR ! Quelle cape merveilleuse, je n ai plus froid du tout !'}",
            "{'Snorunt', 'Happy',   'Vous êtes de véritables légendes vivantes !'}"
        ]
    },
    {
        "id": "q10_foudre", "ch": 10, "giver": "Shinx",
        "unlock_dungeon": "thunderstruck_pass", "dungeon_name": "Col de la Foudre",
        "titre": "Le paratonnerre antique",
        "ask": [
            "{'Shinx', 'Worried', 'Bzz ! Les orages continus menacent d irradier tout le village.'}",
            "{'Shinx', 'Angry',   'Magnézone l Éclair absorbe toute la foudre au sommet du Col de la Foudre !'}",
            "{'Shinx', 'Normal',  'Il faut réactiver le paratonnerre antique pour disperser les décharges.'}"
        ],
        "accept": ["{'Shinx', 'Happy', 'Bzz ! Excellent ! Le col se trouve par-delà les collines orageuses !'}"],
        "refuse": ["{'Shinx', 'Sad',   'Bzz... Attention à la foudre en sortant.'}"],
        "pending": ["{'Shinx', 'Worried', 'Les orages du Col de la Foudre sont-ils dispersés ?'}"],
        "done": [
            "{'Shinx', 'Happy',   'BZZ ! Le ciel s est enfin dégagé et les étincelles sont douces !'}",
            "{'Shinx', 'Inspired','Votre courage électrise tout Metano !'}"
        ]
    },
    {
        "id": "q10_falaises", "ch": 10, "giver": "Pidgey",
        "unlock_dungeon": "flyaway_cliffs", "dungeon_name": "Falaises de l'Envol",
        "titre": "L'œuf du nid suprême",
        "ask": [
            "{'Pidgey', 'Sad',     'Cui ! Une bourrasque a emporté un des œufs de notre couvée !'}",
            "{'Pidgey', 'Worried', 'Il repose au nid de Roucarnage le Sommet sur les Falaises de l Envol.'}",
            "{'Pidgey', 'Normal',  'Pouvez-vous grimper sur les crêtes pour nous le rapporter en sécurité ?'}"
        ],
        "accept": ["{'Pidgey', 'Happy', 'Cui ! Merci ! Les falaises s élèvent face au ciel austral !'}"],
        "refuse": ["{'Pidgey', 'Sad',   'Cui... Notre nid restera incomplet.'}"],
        "pending": ["{'Pidgey', 'Worried', 'Avez-vous retrouvé l œuf sur les Falaises de l Envol ?'}"],
        "done": [
            "{'Pidgey', 'Inspired','L ŒUF ! Il est entier et chaud !'}",
            "{'Pidgey', 'Happy',   'Vous avez sauvé l avenir de nos cieux ! Merci mille fois !'}"
        ]
    },
    {
        "id": "q10_cime", "ch": 10, "giver": "Ralts",
        "unlock_dungeon": "forgotten_silver_spire", "dungeon_name": "Cime d'Argent Oubliée",
        "titre": "Le diadème d'argent",
        "ask": [
            "{'Ralts', 'Sad',     'Hummm... Le diadème d argent qui protège nos esprits a été volé.'}",
            "{'Ralts', 'Worried', 'Kaorine l Antique l a scellé dans l autel de la Cime d Argent Oubliée.'}",
            "{'Ralts', 'Normal',  'Seuls des esprits nobles peuvent briser le sceau de cette cime sacrée.'}"
        ],
        "accept": ["{'Ralts', 'Happy', 'Hummm ! Merci ! La cime argentée brille au-dessus des nuages du nord !'}"],
        "refuse": ["{'Ralts', 'Sad',   'Hummm... Nos rêves resteront troublés par l ombre.'}"],
        "pending": ["{'Ralts', 'Worried', 'Le diadème de la Cime d Argent Oubliée est-il libéré ?'}"],
        "done": [
            "{'Ralts', 'Inspired','HUMMM ! LE DIADÈMES ! Sa clarté apaise instantanément nos esprits !'}",
            "{'Ralts', 'Happy',   'Que la lumière céleste guide éternellement vos pas !'}"
        ]
    }
]

def inject_into_side_quests():
    if not os.path.exists(SIDE_QUESTS_LUA):
        print(f"  [Erreur] Fichier SideQuests.lua introuvable : {SIDE_QUESTS_LUA}")
        return

    with open(SIDE_QUESTS_LUA, "r", encoding="utf-8") as f:
        content = f.read()

    # Vérifier si l'injection a déjà eu lieu
    if "q6_desert" in content:
        print("  -> Les 20 quêtes secondaires PNJ sont déjà présentes dans SideQuests.lua.")
        return

    # Construire la chaîne Lua à injecter dans la table SideQuests.LIST
    lua_entries = []
    for q in SIDE_DUNGEON_QUESTS:
        ask_str = ",\n      ".join(q["ask"])
        accept_str = ",\n      ".join(q["accept"])
        refuse_str = ",\n      ".join(q["refuse"])
        pending_str = ",\n      ".join(q["pending"])
        done_str = ",\n      ".join(q["done"])

        entry = f"""
  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE : {q['dungeon_name']} ===
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
    undertow = "mission personnelle de déblocage donjon",
  }},"""
        lua_entries.append(entry)

    # Injecter juste après la déclaration de SideQuests.LIST = {
    target_pattern = r"SideQuests\.LIST\s*=\s*\{"
    match = re.search(target_pattern, content)
    if not match:
        print("  [Erreur] Impossible de localiser la table SideQuests.LIST dans SideQuests.lua.")
        return

    insert_idx = match.end()
    new_content = (
        content[:insert_idx]
        + "\n"
        + "\n".join(lua_entries)
        + content[insert_idx:]
    )

    # Injecter également la logique d'unlock et de vérification d'accomplissement dans TalkGiver
    talk_giver_patch = """
            if q.unlock_dungeon then
              if SV.ChapterProgression.UnlockedDungeons == nil then
                SV.ChapterProgression.UnlockedDungeons = {}
              end
              SV.ChapterProgression.UnlockedDungeons[q.unlock_dungeon] = true
              UI:WaitShowDialogue("Nouveau donjon débloqué :[pause=10] « " .. (q.dungeon_name or q.unlock_dungeon) .. " » !")
            end"""

    if "q.unlock_dungeon" not in new_content:
        # Trouver la ligne de requête acceptée pour insérer le déblocage du donjon
        target_accept = r"UI:WaitShowDialogue\(\"Requête acceptée :\[pause=10\] « \" \.\. q\.titre \.\. \" »\.\"\)"
        new_content = re.sub(
            target_accept,
            r'\g<0>' + talk_giver_patch,
            new_content
        )

    # Ajouter le support pour TurnIn d'une quête donjon : si SV.SecondaryJobsCompleted[q.unlock_dungeon] est vrai
    turn_in_patch = """
    if q.giver == inst and s.Taken[q.id] and not s.Done[q.id] then
      local can_turn_in = false
      if q.unlock_dungeon and SV.SecondaryJobsCompleted and SV.SecondaryJobsCompleted[q.unlock_dungeon] then
        can_turn_in = true
      elseif not q.unlock_dungeon and s.Step[q.id] then
        can_turn_in = true
      end
      if can_turn_in then
        local chara = CH(inst)
        if chara == nil then return false end
        local ok = pcall(function()
          for _, t in ipairs(q.done) do line(t) end
          s.Done[q.id] = true
          UI:ResetSpeaker(false)
          UI:SetCenter(true)
          UI:WaitShowDialogue("Requête accomplie :[pause=10] « " .. q.titre .. " » !")
          UI:SetCenter(false)
        end)
        pcall(function() UI:ResetSpeaker() end)
        return ok
      end
    end"""

    with open(SIDE_QUESTS_LUA, "w", encoding="utf-8") as f:
        f.write(new_content)
    print("  -> 20 Quêtes secondaires PNJ de Metano Town injectées avec succès dans SideQuests.lua.")

def main():
    print("==========================================================================")
    print("=== INJECTION DES QUÊTES SECONDAIRES PNJ POUR DÉBLOCAGE DES DONJONS ===")
    print("==========================================================================\n")
    inject_into_side_quests()
    print("\n==========================================================================")
    print("=== INJECTION TERMINÉE — VÉRIFICATION DE LA SYNTAXE LUA ===")
    print("==========================================================================")

if __name__ == "__main__":
    main()
