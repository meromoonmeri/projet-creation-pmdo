# MANIFESTE D'ARCHITECTURE ET D'IDENTITÉ DES DONJONS (Ch6 à Ch32)

**Date d'exécution** : 2026-08-04  
**Périmètre** : Tous les donjons et affrontements de boss de *New Era : Abyss to Ascension*, de **Tornadus (Chapitre 6)** jusqu'au **Boss Final du Chapitre 32**.  
**Rôle du document** : Charte de conception non négociable s'imposant à toute création, intégration ou audit de donjon dans le mod.

---

## 1. RÈGLE D'OR — ZÉRO GROUND INDÉPENDANT POUR LES BOSS (Ch6–32)

> **Directive absolue** : Chaque affrontement de boss doit se dérouler dans une **véritable salle de confrontation** ou un **autel dédié**, directement intégré au donjon en tant qu'étage d'arène (`LayeredSegment` / `SingularSegment` pointant vers une carte `.rsmap`).  
> Les anciens grounds indépendants de boss (`.rsground` isolés de cinématique) sont supprimés et interdits au profit d'arènes de combat en donjon.

### A. Intégration et Séquence Canonique en Donjon
- **Fermeture de l'arc en donjon** : Le boss est le point culminant du labyrinthe. Le joueur passe du dernier étage d'exploration à la salle de confrontation par un escalier ou une transition de segment (`ExitSegment`).
- **Séquence de mise en scène sur la `.rsmap`** :
  1. `OnMapStarts` déclenche l'événement d'introduction du boss (`LuaBeginBattleEvent` / `BossFX`).
  2. Dialogue d'introduction, apparition sous flash blanc ou émergence environnementale.
  3. Rétablissement de la caméra et déclenchement immédiat de la bataille sur la carte de combat.
- **Règles d'échelle** : La salle d'arène respecte rigoureusement la grille PMDO (`24 × 24 px` pour la tuile de combat, `8 × 8 px` pour les obstacles et la rugosité).

### B. Adaptation Intégrale au Biome (Zéro Arène Générique)
- **Continuité géologique et visuelle** : L'arène du boss n'est jamais une salle neutre ou réutilisée (interdiction de cloner un gabarit unique comme `sanctuaire_titans` pour des boss différents).
- **Héritage du biome** : Chaque arène doit être construite avec :
  - Les **mêmes planches de tuiles (`.tile`)** et textures que le labyrinthe qui y mène (ou une version magnifiée/surélevée du même biome : autel au sommet, chœur au fond d'une nef, cœur du cratère).
  - La **météo ou le statut environnemental** propre à la zone (orage d'altitude, brume volcanique, lueur cristalline, obscurité sylvestre).
  - L'**ambiance sonore** en continuité avec la montée vers le boss.

---

## 2. L'IDENTITÉ FORTE ET IMMÉDIATEMENT RECONNAISSABLE DES DONJONS

> **Objectif d'évaluation** : Le joueur doit être capable d'identifier un donjon en **quelques secondes seulement**, grâce à son architecture, son ambiance, ses mécaniques et les Pokémon présents. Aucun donjon ne doit donner l'impression d'être une simple variation d'un autre.

### A. Les 5 Piliers d'Identité d'un Donjon New Era
1. **Architecture unique** :  
   Des proportions de salles, une densité de couloirs et une disposition géométrique distinctes (ex. grottes étroites en réseau vs immenses esplanades ouvertes vs ruines rectilignes à colonnades).
2. **Progression différente des autres donjons** :  
   Chaque donjon propose un rythme d'ascension ou de plongée qui lui est propre (étages de transition, changement de biome à mi-parcours, relais de bivouac marquant une rupture d'atmosphère).
3. **Labyrinthes et topologie propres** :  
   Des algorithmes de génération (`GenSteps` / RogueElements) calibrés sur le thème (dédales d'eau infranchissable, crevasses rocheuses, murs d'arbres denses, ponts suspendus).
4. **Gimmicks environnementaux pertinents** :  
   Intégration de mécaniques qui renforcent le récit ou le biome (pièges géologiques, zones d'ombre, courants marins, pluie persistante, brouillard électrostatique) uniquement là où le lore le justifie.
5. **Ambiance visuelle et sonore cohérente** :  
   Un couple exclusif tileset / musique de fond (`Music`) qui définit l'émotion du donjon (émerveillement, tension, oppression, mystère, sacralité).

---

## 3. L'ÉTALON DE RÉFÉRENCE — `illuminant_riverbed` (Rivière Illuminée)

Le donjon **`illuminant_riverbed` (Rivière Illuminée)** est désigné comme l'**exemple de référence qualitatif** pour le projet. Il illustre parfaitement comment un donjon réussit son identité mémorable sans jamais avoir besoin d'être copié :
- **Identité visuelle** : Contraste saisissant entre l'obscurité caverneuse et la bioluminescence de l'eau et des cristaux.
- **Topologie et structure** : Les cours d'eau guident naturellement l'exploration et imposent une progression organique le long du lit de la rivière.
- **Progression mémorable** : Le sentiment de descendre vers une source sacrée grandit à chaque étage, culminant dans une atmosphère de sanctuaire.
- **Règle d'usage** : Les créateurs de donjons doivent analyser l'exigence qualitative d'**`illuminant_riverbed`** (ainsi que les meilleures créations de **PMDO** et du **Dungeon Pack** de DoubleTrio), mais **cette inspiration ne doit jamais conduire à une simple copie** : chaque donjon de New Era doit conserver sa propre personnalité.

---

## 3 bis. CONTINUITÉ CANONIQUE — DEUX CATÉGORIES DE LIEUX

> **Principe fondateur** : *New Era: Abyss to Ascension* se déroule dans le même monde que *Pokémon Mystery Dungeon: Red/Blue Rescue Team* et *Explorers of Sky*, environ **trente ans après** leurs événements. Ce n’est ni un monde parallèle ni une simple inspiration stylistique.

La règle de nommage original ne s’applique donc pas uniformément.

### A. Lieux canoniques hérités de Rescue Team / Explorers of Sky

Pour Treasure Town, la ville ou le camp de l’Équipe de Secours, Sky Tower, Mt. Thunder, Mt. Blaze, Mt. Freeze, Temporal Tower, Spacial Rift, Buried Relic, Aegis Cave et les autres lieux canoniques :

- le **nom canonique est conservé et assumé** ;
- un qualificatif temporel peut être ajouté s’il décrit une transformation réelle, sans masquer le nom d’origine ;
- la géométrie, les collisions et les positions structurantes importées constituent une fondation **1:1** ;
- les trente années écoulées doivent ensuite être visibles : usure, réparations, végétation, extensions ou ruines ;
- le casting placé sur les cartes est celui de New Era, sauf apparition historique volontaire et documentée ;
- le statut du légendaire et des personnages historiques doit être décidé explicitement avant validation du lieu.

Importer et adapter ces lieux est la méthode de construction de la continuité du monde, pas un raccourci de production.

À compter du début du chapitre 6, l’import porte obligatoirement sur le **donjon complet**, jamais sur son Ground isolé. Le Ground, la zone JSON, les segments, la progression d’étages, les salles fixes `.rsmap`, les tables de spawn, les mécaniques, les musiques et le légendaire historiquement associé doivent décrire le même lieu canonique. Toute exception liée aux trente années écoulées doit être écrite comme un événement historique précis et ne permet pas de réutiliser l’architecture d’un autre lieu sous un nouveau nom.

### B. Lieux entièrement nouveaux de New Era

Pour les donjons secondaires Ch6–32 et les lieux propres à l’Abîme sans précédent canonique, la convention originale `[Lieu] + [Qualificatif]` reste obligatoire. Ils ne doivent pas emprunter abusivement le nom d’un lieu historique.

### C. Critères de validation d’un lieu hérité

- [ ] nom canonique conservé, avec qualificatif temporel éventuel ;
- [ ] provenance Red/Sky et pipeline d’extraction documentés ;
- [ ] géométrie/collision 1:1 vérifiées avant retouche ;
- [ ] passage de trente ans visible dans le décor ;
- [ ] statut des personnages historiques et du légendaire documenté ;
- [ ] casting d’origine non réutilisé par défaut ;
- [ ] transitions géographiques cohérentes avec les autres lieux canoniques.

Un lieu qui échoue à l’un de ces critères reste en cours de production.

---

## 4. TABLES DE POKÉMON SAUVAGES DÉDIÉES PAR DONJON

> **Règle absolue** : Chaque donjon de New Era doit disposer de sa **propre table d'apparitions de Pokémon sauvages** (`Spawns` / `MonsterTeam`).  
> Le copier-coller de pools de Pokémon d'un donjon à l'autre est formellement interdit, sauf justification scénaristique ou écologique explicite.

### A. Les 3 Critères de Curation d'un Pool Sauvage
1. **Cohérence écologique et biômique** :  
   Les espèces présentes doivent appartenir naturellement à l'habitat (Pokémon Roche/Acier dans les ruines minières, Insecte/Plante dans les sous-bois denses, Spectre/Ténèbres dans les abîmes et failles, Eau/Glace dans les gouffres gelés).
2. **Niveau et équilibrage par chapitre** :  
   Les niveaux (`Level`), capacités et tactiques (`Tactic`) des Pokémon sauvages s'alignent rigoureusement sur le barème de palier du chapitre en cours (Partie 2 du Document Maître), garantissant un défi croissant et équitable.
3. **Justification narrative / Corruption** :  
   Si une espèce inhabituelle ou un Pokémon d'un autre biome apparaît, sa présence doit s'expliquer par le scénario (ex. faunes déplacées par les anomalies de brume, créatures corrompues par l'Anima sombre, mercenaires ou gardiens antiques).

---

## 5. CHECK-LIST D'AUDIT AVANT VALIDATION D'UN DONJON (Ch6–32)

Avant d'intégrer ou de valider un donjon et son boss dans le dépôt, le développeur ou l'auditeur doit valider ces 5 points :

- [ ] **1. Salle de confrontation en donjon** : Le boss se combat-il sur une arène (`.rsmap`) intégrée à la fin du segment de zone, sans recourir à un ground indépendant ?
- [ ] **2. Unité de biome du boss** : L'arène du boss hérite-t-elle des tuiles, de l'élément géologique, de la météo et de la direction artistique du donjon qui y mène ?
- [ ] **3. Identité en quelques secondes** : Le donjon possède-t-il une architecture, un rythme de progression, un algorithme de labyrinthe et une ambiance musicale qui le distinguent instantanément de tous les autres ?
- [ ] **4. Table sauvage dédiée** : Le donjon dispose-t-il d'un pool d'espèces sauvages conçu sur mesure pour son écosystème, sans recyclage arbitraire ?
- [ ] **5. Originalité par rapport à l'étalon** : Le donjon apporte-t-il une expérience de jeu unique et personnelle, sans copier la structure d'`illuminant_riverbed`, de PMDO ou du Dungeon Pack ?

**Verdict** : Un donjon qui échoue à un seul de ces critères est jugé incomplet.
