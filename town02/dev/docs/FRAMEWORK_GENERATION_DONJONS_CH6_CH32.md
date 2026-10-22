# FRAMEWORK DE GÉNÉRATION DES DONJONS (Chapitres 6 à 32)

**Projet** : *New Era : Abyss to Ascension* (moteur RogueEssence / PMDO)  
**Date d'exécution** : 2026-08-04  
**Rôle du document** : Constitution technique et méthodologique régissant la création de tous les donjons des chapitres 6 à 32 du mod.

---

## RÈGLE ABSOLUE
Avant de générer le moindre donjon, connaître par cœur la documentation du moteur (*Floor Generation Overview*, *Script Reference*, *RogueElements*) et l'état réel du dépôt. Aucune structure de donjon, aucun roster d'espèces, aucun nom de fichier n'est deviné — tout est vérifié contre ce que le moteur et le projet supportent réellement.  
Étant donné l'ampleur de cette tâche (plus de 200 donjons sur 27 chapitres), **ne jamais générer en un seul bloc non vérifié** : traiter **chapitre par chapitre, donjon par donjon**, avec validation intermédiaire avant de passer au suivant.

---

## 1. PORTÉE ET STRUCTURE GÉNÉRALE
- **Chapitres concernés** : 6 à 32.
- **Par chapitre** : 1 donjon principal (scénarisé) + jusqu'à **10 donjons secondaires**.
- **Étages par donjon** : 22 à 25 étages pour les donjons secondaires (+2 à 5 étages par rapport aux 20) / jusqu'à 60 pour les grands donjons d'histoire.
- **Segments** : Chaque tranche de **10 étages** constitue un segment avec **changement de biome** (`RangeDictSegment` / `LayeredSegment`).
- **Règle absolue des Camps et Grounds de Cinématique** :
  - **Les camps (`*_camp.rsground` / `*_relay.rsground`) et les grounds de cinématique sont STRICTEMENT RÉSERVÉS AUX DONJONS D'HISTOIRE.**
  - **Les donjons secondaires n'ont AUCUN camp de bivouac ni ground de cinématique** : ils proposent une pure expérience d'exploration procédurale sur 22 à 25 étages, rythmée par 3 **Arènes d'Étage (`.rsmap`)** intégrées dans le donjon pour affronter les mini-boss (ex. Ét. 7, Ét. 14) et le boss (ex. Ét. 22/25).
- **Mini-boss** : 3 par donjon, combattus sur leur Arène d'Étage (`.rsmap`) propre, chacun avec un nom propre et une musique dédiée (`Content/Music/`).
- **Salle de boss dédiée par légendaire** : Si un donjon comporte une rencontre légendaire, sa salle est conçue spécifiquement pour lui (échelle `24 px`, décor et biome adaptés), jamais une arène générique réutilisée.
- **Numérotation d'histoire** : Rang narratif de 30 à 99 pour le Chapitre 32, consigné dans `docs/inventaire_donjons.md`.

---

## 2. DIVERSITÉ GÉOMÉTRIQUE DES ÉTAGES (Section 1.5)
- **Chaque étage d'un donjon a une géométrie spatiale différente** des autres étages du même donjon (longs couloirs sinueux, grandes salles ouvertes, enchevêtrements, étages vastes vs compacts). La variation est structurelle (`GenSteps`, taille de grille, densité de salles), pas seulement cosmétique.
- **Unité de DA par segment** : Toute cette variété géométrique est habillée par le **même tileset** sur l'ensemble d'un segment de 10 étages. La diversité est dans la forme de l'étage, jamais dans un changement incohérent de décor.

---

## 3. GARDE-FOU NARRATIF SUR LES LÉGENDAIRES (Section 2)
- **Légendaire réservé à un enjeu narratif fort, jamais gratuit.**
- Les rencontres légendaires s'appuient en priorité sur le système de lieu de revanche (`LegendZones.lua`, modèle Zarude / `verdant_oath`).
- Si un donjon secondaire n'a pas besoin de légendaire pour être réussi, **le signaler explicitement** plutôt que d'en inventer un artificiellement pour remplir un quota.

---

## 4. NOMMAGE ORIGINAL, MUSIQUE ET INVENTAIRE CENTRAL (Section 3 & Convention)
- **Convention de nommage — distinction obligatoire** :
  - **Lieux canoniques hérités de Rescue Team / Explorers of Sky** : leur nom officiel est conservé afin d’assurer la reconnaissance et la continuité trente ans plus tard (`Sky Tower`, `Mt. Thunder`, `Temporal Tower`, `Buried Relic`, etc.). Un qualificatif temporel descriptif peut être ajouté, mais aucun renommage complet ne doit effacer l’identité historique du lieu.
  - **Lieux entièrement nouveaux de New Era** : chaque nom suit la structure originale **`[Nom commun de lieu/biome] + [Qualificatif]`** (ex. *Désert des Oubliés*, *Crevasse de Géode*, *Verger Sauvage*, *Plaines Brûlées*). Un nouveau lieu ne doit pas emprunter artificiellement un nom canonique.
  - **Règle de variété des lieux nouveaux** : ne pas réutiliser le même nom de lieu plus de 2-3 fois sur les 27 chapitres sans un qualificatif très distinct.
  - **Banque de qualificatifs** : À choisir en cohérence avec le biome réel et le lore (sans spawner de spoil avant le payoff) parmi les catégories Sensoriel/atmosphérique, Géographique/descriptif, Émotionnel/narratif et Lié à l'Anima.
- **Noms de Mini-boss** : Les 3 mini-boss reçoivent un **nom propre individuel** (ex. *Sablaireau l'Ancien*, *Cacturne le Veilleur*, *Hippodocus le Colosse*), semblable à un nom de personnage ou PNJ.
- **Tableau des Missions de Guilde (`SecondaryJobs.lua` / Job Board)** : Chacun des donjons secondaires est formellement rattaché au Tableau des Missions de la guilde (`Job Bulletin Board`) : chaque donjon offre un contrat épinglé avec client et cible nommés (espèces vérifiées dans `Content/Chara/`), un titre et un texte d'ambiance en français idiomatique, et une difficulté calibrée sur le chapitre.
- **Cinématique de Récompense Automatique (`SideQuests.OnDungeonClear`)** : À la complétion d'un donjon secondaire (`ResultType.Cleared`), le moteur téléporte automatiquement le joueur **face au PNJ commanditaire à Metano Town** ou **face au Job Board de Bekipan à la guilde (`guild_second_floor`)** pour exécuter la scène de remerciement et verser la prime.
- **Musique dédiée** : Vérifiée dans `Content/Music/` avant tout appel dans un script (`SOUND:PlayBGM`).
- **Fichier d'inventaire central (`docs/inventaire_donjons.md`)** : Source de vérité unique.

---

## 5. BESTIAIRE (20-50 ESPÈCES/DONJON), SCALING ÉVOLUTIF ET OBJETS (Sections 4, 4.5, 4.6)
- **Bestiaire et Quota d'Espèces** : Chaque donjon intègre de **20 à 50 espèces sauvages différentes**, vérifiées dans `Content/Chara/` et cohérentes avec le biome du segment.
- **Scaling Évolutif sur ~15 niveaux (`Lv 18-33`, etc.)** :
  - La progression d'un segment à l'autre est marquée par l'**évolution des espèces rencontrées**.
  - *Exemple* : Segment 1 (Étages 1 à 10) = faune au **Stade 1 non évolué** (Sabelette, Cacnea, Trapinch) ➔ Segment 2 (Étages 11 à 20) = faune au **Stade Évolué** (Sablaireau, Cacturne, Vibrava, Claydol, Hippodocus).
- **Spawn d'objets (`ItemSpawnZoneStep`)** : Chaque donjon fait apparaître des objets selon les patrons légitimes (`PMDODump` `DataAsset/Zone/*.out.txt`, `RangeDictSegment`).
- **Marchand Kecleon** : Spawn aléatoire obligatoire et modéré par étage, cohérent avec la difficulté du segment.

---

## 6. MÉCANIQUES, PIÈGES, DALLES MIRACLE ET ÉTAGES SPÉCIAUX (Sections 5, 6, 6.5)
- **Fairplay de génération** : Un escalier ou passage obligatoire n'est jamais placé dans une position désavantageant injustement une équipe (pas d'escalier bloqué par la lave sans chemin praticable alternatif).
- **Intégration des Mécaniques de Donjon (PMDODump, DoubleTrio `dungeon-pack`, ProjectEoN)** :
  - **Dosage avec parcimonie (sans abus)** : Les fonctions qui font la beauté et l'authenticité de *Donjon Mystère* sont intégrées selon la profondeur et la difficulté :
    - **Pièges (`TrapSpawnStep` / `TrapStep`)** : densifiés progressivement selon le segment (pièges légers en début de donjon ➔ pièges statut/sceau/torpeur en profondeur).
    - **Dalles Miracle (`WonderTileStep` / `tile_wonder`)** : disposées avec parcimonie (3 à 5 par étage sur les étages clés) pour permettre au joueur de soigner ses baisses de statistiques.
    - **Maisons de Monstres & Salles Trésor (`MonsterHouseStep` / `SecretRoomStep`)** : intégrées en tant qu'événements rares et gratifiants, calibrés sur le palier.
- **Météo en donjon** : Quelques étages ciblés par segment intègrent un statut météo actif (pluie, tempête de sable, brouillard) cohérent avec le biome.

---

## 7. CINÉMATIQUES INATTENDUES & SCALING (Sections 7, 8)
- **Donjons vivants** : Embuscades, visites et explorations surprises brèves avec des PNJ uniques créés pour l'occasion.
- **Scaling de difficulté** : Mini-boss toujours au-dessus du niveau et des stats des résidents du donjon. Évolutivité de la difficulté globale en fonction de l'avancement dans les chapitres 6 à 32.

---

## 8. MÉTHODE DE TRAITEMENT OBLIGATOIRE (Section 9)
1. Traiter **un chapitre à la fois**, jamais plusieurs en parallèle.
2. **Pour chaque chapitre** : lister d'abord les donjons secondaires prévus et **présenter cette liste avant de générer le contenu détaillé**.
3. Une fois un chapitre validé, passer au suivant en mettant à jour l'inventaire `docs/inventaire_donjons.md`.
