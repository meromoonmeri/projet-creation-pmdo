# Audit & Plan d'Intégration Narrative : Accès à Treasure Town via Loaklass

Ce document constitue la référence de conception et de spécification technique pour l'intégration de **Treasure Town** (*Bourg du Comptoir*, ID : `bourg_comptoir`) et du personnage de **Loaklass** (Lapras) au sein du projet *New Era: Abyss to Ascension*. 

---

## 1. Analyse Géographique et Alignement du Lore

### A. Positionnement de Metano Town et de Treasure Town
Dans la géographie canonique de *New Era*, Metano Town et Treasure Town sont situées sur deux continents séparés par un océan vaste et instable. 
* **Metano Town** : Bourg de départ, adossé à des structures volcaniques (Mine Magma, Creuset) et montagneuses (Mont Venteux). C'est le carrefour commercial et logistique local, abritant la Guilde d'exploration locale.
* **Treasure Town** (*Bourg du Comptoir*) : Métropole historique et portuaire de l'exploration, haut lieu de prestige abritant des structures d'envergure nationale (Docteur Ossatueur, le Café de Spinda, de grands commerces).

### B. Le Rôle de Loaklass (Lapras)
**Loaklass** n'est pas un simple PNJ de transition fonctionnelle. C'est une figure maritime légendaire, gardienne du passage caché sous la cascade de la rivière de Metano Town. Elle est une amie de très longue date du doyen de la Guilde, **Penticus** (Tropius). Leur complicité s'exprime par une familiarité respectueuse et des anecdotes communes.
* **Clin d'œil scénaristique (Foreshadowing & Nostalgie)** : Lors de sa rencontre avec le groupe, Loaklass évoque avec une tendre nostalgie avoir transporté « deux célèbres explorateurs » environ quinze ans plus tôt, faisant référence de manière cryptique aux héros d'*Explorers of Sky*, sans jamais mentionner de noms propres.
* **Continuité temporelle** : Ce jalon est consigné à **15 ans dans le passé** de *New Era*, se distinguant de l'adaptation de *Rescue Team* fixée à **30 ans dans le passé**. Les deux chronologies sont suivies séparément dans le registre de continuité pour éviter toute confusion lors de la rédaction de scènes futures.

---

## 2. Découpage Beat-by-Beat : La Traversée Maritime

### Acte 1 — Visite au Doyen de Metano Town
* **Lieu** : `guild_guildmasters_room` (Bureau de Penticus).
* **OST** : Thème de conseil de la Guilde, calme et chaleureux.

* **Beat 1.1 — Arrivée chez le Doyen** : Le héros et le partenaire entrent dans la pièce. Penticus est occupé à examiner de vieilles cartes maritimes mais lève la tête et sourit chaleureusement à leur entrée.
* **Beat 1.2 — Motif de la Visite** : Le partenaire demande si Penticus a des pistes pour étendre l'influence et les recherches de l'équipe au-delà du continent. Penticus soupire et admet que les perturbations perturbent les courants, mais qu'une opportunité se présente aujourd'hui même.
* **Beat 1.3 — Le Signal de la Cascade** : Un grondement sourd de clapotis d'eau résonne depuis la paroi arrière du bureau, qui donne sur la cascade dissimulée. L'équipe sursaute et regarde en direction de l'ouverture.
* **Beat 1.4 — Réaction du Doyen** : Penticus rit doucement. *« Elle est à l'heure, comme toujours. Venez, je vais vous présenter une voyageuse d'exception. »*

---

### Acte 2 — Discussion avec Loaklass
* **Lieu** : Esplanade rocheuse de la cascade de Metano Town.
* **OST** : Thème de Loaklass, marin, ample et empreint de nostalgie.

* **Beat 2.1 — Apparition de Loaklass** : Loaklass émerge lentement de l'écume derrière le rideau d'eau de la cascade. Ses yeux sont doux et bienveillants, sa stature imposante est baignée par la lumière brumeuse.
* **Beat 2.2 — Présentations** : Penticus s'avance et tapote affectueusement la tempe de Loaklass. *« Je vous présente Loaklass. C'est elle qui m'a sorti des pires tempêtes océaniques à l'époque où mes ailes ne tenaient plus le vent. »*
* **Beat 2.3 — Salutations chaleureuses** : Loaklass baisse l'encolure en signe de respect et salue le groupe de sa voix chantante.
* **Beat 2.4 — Explication de la Traversée** : Elle explique qu'elle connaît les routes invisibles de l'océan menant à Treasure Town, de l'autre côté de l'horizon, là où Metano Town n'est plus qu'un lointain souvenir.
* **Beat 2.5 — Le Clin d'œil au Passé (Sans Portrait avant apparition)** :
  > **Loaklass** : *« Vos regards... Ils me rappellent un duo d'explorateurs que j'ai transporté il y a quinze ans. Ils avaient la même étincelle dans les yeux... avant de sauver le temps lui-même. »*
* **Beat 2.6 — Réaction du Héros** :
  > **Héros (Pensée)** : *« (Deux aventuriers qui ont sauvé le temps... Elle ne cite aucun nom, mais son regard semble s'attarder sur l'horizon avec une profonde affection.) »*
* **Beat 2.7 — La Proposition** : Loaklass propose officiellement ses services d'expédition maritime : *« Si vous avez le cœur de voir de nouvelles terres, mon dos est à vous. »*

---

### Acte 3 — La Grande Traversée (Transition)
* **OST** : Motif orchestral ascendant, évoquant le départ à l'aventure.

* **Beat 3.1 — Embarquement** : Le héros et le partenaire montent sur la carapace de Loaklass sous les encouragements de Penticus.
* **Beat 3.2 — Le Noir Scénarisé** : L'écran fait un fondu au noir prolongé (`GAME:FadeOut(false, 60)`). Une boîte de dialogue de narration centrée, sans portrait, s'affiche lentement pour souligner l'immensité de la mer :
  > *« Portés par les vagues calmes et le souffle régulier de Loaklass... nous avons vu les montagnes de Metano s'effacer sous l'horizon, cédant la place à l'immensité bleutée de l'océan. »*
* **Beat 3.3 — Lever du Fondu** : Le fondu se lève uniquement lorsque la carte de Treasure Town est intégralement chargée et la caméra en position stable.

---

### Acte 4 — Arrivée à Treasure Town
* **Lieu** : Plage de Treasure Town (`plage_lucioles` ou `plage_crepuscule` servant de ponton naturel).
* **OST** : Le thème entraînant et nostalgique de Treasure Town.

* **Beat 4.1 — Révélation de la Plage** : Plan panoramique sur la célèbre plage de sable fin de Treasure Town, avec ses falaises et ses bulles d'eau flottant doucement.
* **Beat 4.2 — Émerveillement** : Le partenaire descend de la carapace de Loaklass, regarde autour de lui les yeux écarquillés : *« C'est... c'est magnifique ! L'odeur du sel, cette lumière... On y est vraiment ! »*
* **Beat 4.3 — Adieux et Disponibilité de Loaklass** : Loaklass sourit et annonce qu'elle restera ancrée près du récif de la plage : *« Je ne repars pas tout de suite. Quand vous aurez fini d'explorer cette superbe cité, faites-moi signe pour rentrer à Metano Town. »*
* **Beat 4.4 — Premier Aperçu de la Ville** : En remontant la plage vers la colline, l'équipe croise ses premiers PNJ (Krabby qui bullent, marchands de passage), donnant l'impression immédiate d'une ville dynamique et grouillante de vie.
* **Beat 4.5 — Clôture de la Révélation** :
  > **Héros (Pensée)** : *« (Alors voilà à quoi ressemble l'autre capitale du monde de l'exploration... Un nouveau départ commence ici.) »*
* **Beat 4.6 — Reprise de Contrôle** : La caméra se replace derrière le héros et le joueur récupère les commandes de déplacement libre.

---

## 3. Charte de Monde Vivant et de Parité (Treasure Town)

Pour garantir une immersion et une cohérence absolue à Treasure Town (*Bourg du Comptoir*), les spécifications techniques suivantes sont appliquées sans exception, en stricte parité avec Metano Town :

### A. Densité et Densité de Dialogues des PNJ
* **Effectif minimum** : La ville compte au moins 15 PNJ uniques répartis de manière cohérente (la Place, les commerces, les falaises, la plage).
* **Variété de Propos** : Les PNJ principaux (le gérant du Café Spinda, les marchands) disposent d'un ensemble de **10 variantes de dialogues** alternant en boucle déterministe selon le compteur de jours (`SV.ChapterProgression.DaysPassed`) pour éviter toute redondance pénible pour le joueur.
* **Réactivité** : Tous les dialogues de la ville sont réécrits de manière dynamique lors des événements majeurs de la trame.

### B. Fonctionnalité Technique du Tableau des Missions (Job Board)
* Le Tableau des Missions de Treasure Town est **entièrement fonctionnel** (génération d'avis de recherche et de sauvetage au même titre que celui de Metano).
* **Spécificité de l'Arc Fugitif** : Si le joueur se rend à Treasure Town alors que l'arc de fuite du Chapitre 10 est actif, le statut de « recherché » de l'équipe s'applique également aux PNJ locaux. Les commerces se méfient, les gardes patrouillent, et certaines missions de sauvetage officielles sont bloquées, forçant le joueur à négocier ou à trouver des contrats clandestins via le réseau parallèle.

### C. Logique Spatiale de la Carte (`bourg_comptoir.rsground`)
* La carte convertie depuis *ProjectEoN* est rigoureusement soumise à l'outil d'audit de collision (`tools/verify_ground_registration.py`).
* **Zéro walkability par défaut** : Les murs des maisons, les bords des falaises de Sharpedo, la mer et les rochers décoratifs possèdent des masques de collision (`Tags: 1`) réels, empêchant le héros ou tout PNJ de marcher sur des obstacles visuels.

---

## 4. Planification du Calendrier de Chapitres

Le positionnement de Treasure Town dans l'histoire générale de *New Era* a été méticuleusement choisi après évaluation des critères scénaristiques :

* **Emplacement retenu : Chapitre 11 (Arc de l'Expansion et de la Clôture de l'Expédition)**.
* **Justification** : Après le dénouement intense de la Tour Céleste au Chapitre 10 et le début de l'arc fugitif, l'accès à un nouveau continent devient un impératif de survie géographique pour l'équipe traquée de Metano Town. Loaklass intervient alors comme l'alliée providentielle qui exfiltre le groupe vers l'autre continent, ouvrant Treasure Town comme leur nouvelle base d'opérations clandestine.
* Cela préserve l'équilibre narratif des chapitres 1 à 10 centrés sur la guilde de Metano Town et l'expédition, tout en offrant au Chapitre 11 un renouveau de décors et de gameplay spectaculaire pour le joueur !
