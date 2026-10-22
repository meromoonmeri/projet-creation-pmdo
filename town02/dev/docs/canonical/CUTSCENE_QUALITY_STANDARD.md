# Prompt — Cutscenes & Cinématiques façon Pokémon Donjon Mystère : guide exhaustif pour ce nouvel agent

## À qui s'adresse ce document

Tu prends en charge la conception et l'implémentation des **cutscenes et cinématiques** de New Era: Abyss to Ascension. Ce document rassemble, en un seul endroit, l'intégralité des règles déjà établies sur ce sujet précis dans le projet. Il ne les résume pas superficiellement : il te donne le niveau de détail nécessaire pour produire directement un contenu conforme, sans avoir à deviner ce qui est attendu. Lis-le en entier avant d'écrire la moindre ligne de cinématique.

**Principe qui prime sur tout le reste** : rien n'est présumé acquis. Une cinématique qui semble bien écrite sur le papier peut être défaillante dans son implémentation (positions incohérentes, collisions cassées, orientation figée). Chaque cinématique doit être auditée réellement avant d'être considérée terminée — jamais validée par simple impression.

---

## 1. Objectif de qualité

Chaque cinématique doit pouvoir être confondue avec une cinématique officielle de *Pokémon Donjon Mystère : Explorateurs du Temps/Ciel* — dans l'écriture, la mise en scène, le langage corporel des personnages, le comportement de la caméra et le niveau de finition général. Ce n'est pas une ambition vague : c'est le critère concret de validation de tout contenu produit. Les cinématiques déjà écrites des chapitres 1 à 5 du projet (jusqu'à l'entrance du Mont Windsep) constituent le repère qualité déjà atteint — toute nouvelle cinématique doit s'y comparer directement.

L'objectif n'est pas seulement que la scène « fonctionne » : elle doit provoquer immersion, émotion, curiosité et attachement aux personnages. Le moteur est un outil au service de la mise en scène, jamais une contrainte qui la limite — chercher systématiquement l'usage le plus intelligent de ses capacités avant d'implémenter une solution.

---

## 2. Documentation moteur à maîtriser avant d'écrire un script

**Moteur et systèmes**
- RogueEssence : https://github.com/RogueCollab/RogueEssence
- Documentation Lua : https://github.com/RogueCollab/RogueEssence/tree/master/RogueEssence/Lua
- RogueElements : https://github.com/audinowho/RogueElements
- PMDC : https://github.com/PMDCollab/PMDC

**Tutoriels essentiels aux cutscenes**
- PMDOTutorial, Lesson 2 — Ground Maps In-Depth (positions X/Y, entités, triggers) : https://github.com/audinowho/PMDOTutorial/releases/tag/v0.2
- PMDOTutorial, Lesson 6 — Cutscenes (MapScene, Cutscene, Coroutine, déplacements forcés) : https://github.com/audinowho/PMDOTutorial/releases/tag/v0.6
- PMDOTutorial, Lesson 7 — Boss Battle : https://github.com/audinowho/PMDOTutorial/releases/tag/v0.7
- PMDOTutorial, toutes releases : https://github.com/audinowho/PMDOTutorial/releases
- Text Guide : https://wiki.pmdo.pmdcollab.org/Text_Guide
- Scripting Cheat Sheet : https://wiki.pmdo.pmdcollab.org/Scripting_Cheat_Sheet
- Script Reference : https://wiki.pmdo.pmdcollab.org/Script_Reference

Vérifier spécifiquement dans cette documentation le fonctionnement des **MapScene**, **Cutscene**, **Coroutine**, des **déplacements forcés d'entités**, des **triggers d'arrivée**, des **animations**, des **changements de direction**, et des **transitions entre maps** — ce sont les briques techniques de toute cinématique de ce projet.

**Mods de référence pour comparer à des implémentations déjà validées** : PMDO-Explorers-Maps, ExplorersOfSkyOrigins, ProjectEoN, Halcyon, ZMDO (dépôts déjà listés dans les autres prompts du projet).

**Outil interne à utiliser en continu** : `outil_previsualisation_ground_logique_spatiale.md` — pour vérifier avant intégration que toute map utilisée par une cinématique respecte la logique spatiale obligatoire (section 8 ci-dessous).

---

## 3. Philosophie générale — carte blanche encadrée

Tu as **carte blanche sur le comment** (mise en scène précise, rythme, découpage, effets, composition) mais **aucune liberté sur le si** — les contraintes suivantes sont non négociables et s'appliquent à toute cutscene, actuelle ou future, sans exception :

1. **Cadrage** : aucune entité active de la scène ne doit se retrouver hors champ à un moment où elle est censée être visible ou agir.
2. **Positionnement esthétique** : le placement de chaque personnage est composé visuellement, jamais posé au hasard.
3. **Réactivité systématique** : chaque Pokémon présent réagit aux événements de la scène — aucun figurant passif qui attend simplement son tour de dialogue.
4. **Dialogues cohérents avec la personnalité** : chaque réplique correspond au caractère, au registre de langage et à l'état de connaissance du personnage qui la prononce.
5. **Déplacements logiques et sans collision** : les personnages ne se traversent jamais, chaque trajet a une justification narrative.
6. **Règle spécifique aux séquences de rêve** : voir section 7.

L'objectif de chaque cinématique est de donner l'impression que les personnages vivent réellement dans leur monde. Aucune scène ne doit sembler artificielle ou exister uniquement pour faire avancer le scénario.

---

## 4. Format de narration

- **Aucune boîte de narration à l'intérieur d'une scène jouée.** La narration textuelle ne sert qu'à clôturer un acte, ouvrir un nouvel acte, ou introduire un nouveau chapitre — toujours accompagnée d'un fondu au noir, jamais ailleurs. Le texte doit toujours être réécrit pour le contexte, jamais recopié d'une autre scène.
- **Le héros ne parle jamais à voix haute.** Ses réactions passent exclusivement par : des pensées entre parenthèses `(pensée héros : ...)`, brèves et ponctuelles (un seul aparté par moment, jamais une liste de ce que le joueur voit déjà), des emotes, et des idles dirigés vers son partenaire. Ses pensées ne doivent jamais résumer une action déjà visible à l'écran — elles expriment ressenti, étonnement, interrogation ou humour.
- **Ce sont les personnages qui portent la narration**, via les dialogues, les animations, les déplacements, les regards, les réactions, les silences. Si le repas est prêt, c'est un personnage qui l'annonce naturellement — jamais un texte qui l'indique à sa place.

---

## 5. Mise en scène — les règles non négociables

### 5.1 Personnages toujours actifs
Aucun personnage ne reste figé en attendant son tour de parole. Chaque dialogue s'accompagne de déplacements, changements de direction, regards, animations d'émotion, pauses, réactions, mouvements de caméra.

### 5.2 Orientation et regard — selon la position réelle, pas un interrupteur uniforme
Un personnage qui parle tourne la tête vers son interlocuteur. Quand un nouveau personnage intervient, les autres se tournent vers lui. Tout bruit ou événement déclenche un regard vers la source avant toute réaction.

**Précision cruciale** : chaque personnage se réoriente selon **sa propre position géométrique** par rapport à la source d'attention — pas une rotation identique appliquée à tout le groupe. Un personnage derrière pivote pour regarder par-dessus l'épaule ou se décale ; un personnage sur le côté pivote latéralement selon l'angle réel ; un personnage déjà face au locuteur peut se contenter d'un ajustement discret (inclinaison de tête). Aucun personnage ne doit rester figé dans une direction qui ne correspond plus au foyer d'attention réel de la scène.

### 5.3 Déplacements crédibles, sans collision, sans détour gratuit
- Un personnage marche jusqu'à son interlocuteur, s'arrête à une distance naturelle, puis parle — jamais de téléportation d'état.
- **Aucune collision entre entités** : deux personnages ne se croisent, ne se chevauchent ou ne traversent jamais l'espace d'un autre. Pour les convergences de groupe, les trajectoires sont pensées ensemble (décalage de timing/angle).
- **Trajectoire logique, sans détour gratuit** : le chemin le plus cohérent avec la position de départ, sauf justification (obstacle réel, personnalité qui explique une hésitation comme Galon qui traîne).
- Position et orientation finale cohérentes une fois arrivé ; continuité de position d'un beat à l'autre.

### 5.4 Positionnement et espacement
Les PNJ ne se superposent jamais, ne se bloquent pas mutuellement, ne sortent pas du champ pendant une scène importante. Espacement naturel dans les déplacements de groupe (référence négative connue : chevauchements de sprite détectés au camp des Ruines Tordues, à ne jamais reproduire).

### 5.5 Absence de mouvement inutile (idle parasite)
Être vivant ne signifie pas bouger en permanence. Un personnage sans raison narrative de bouger reste dans une pose d'attente crédible. Un tic ajouté juste pour « remplir » visuellement la scène distrait du foyer d'attention réel plutôt que de renforcer l'immersion.

### 5.6 Dosage des réactions et des émotions
Ne pas sur-jouer systématiquement chaque ligne. Réserver les réactions marquées (surprise appuyée, grande émotion, gag) aux moments qui le méritent réellement ; garder les échanges ordinaires sobres. C'est ce contraste entre moments calmes et moments marqués qui donne l'impression d'un monde vivant, pas une succession de réactions uniformément exagérées.

### 5.7 Mouvement de caméra justifié
Un mouvement de caméra n'est légitime que s'il sert un besoin réel (suivre un déplacement, révéler une direction, souligner une composition/émotion). Si un cadrage fixe suffit, ne pas ajouter de mouvement pour « dynamiser » artificiellement.

### 5.8 Mise en valeur proportionnée de chaque entité présente
Tout personnage présent — central, secondaire ou figurant — reçoit un minimum de traitement individuel, proportionné à son rôle :
- **Personnages centraux** : ligne de dialogue, réaction jouée, insert caméra dédié.
- **Secondaires récurrents** : au minimum une réaction visible ou une posture propre à leur personnalité, même sans réplique.
- **Figurants/arrière-plan** : visibles, occupés de façon cohérente avec le lieu, participant au moins une fois à un mouvement/réaction collective plutôt que figés en fond de plan.

### 5.9 Micro-mouvements et vivacité
Même hors du foyer d'attention, un personnage montre des signes de vie : mouvements de tête vers ce qui capte son attention, regard qui suit un déplacement, transfert de poids du corps, respiration du groupe (tout le monde ne réagit pas à la même vitesse dans un plan collectif).

### 5.10 Causalité narrative — rien d'introduit n'est mis en retrait
Tout élément nouveau introduit dans une cinématique (personnage qui rejoint la scène, objet, information) devient partie intégrante de la réalité de cette scène. Il ne peut plus être ignoré dans tout ce qui suit à l'intérieur de la même séquence. Méthode de vérification : lister les éléments introduits, vérifier leur présence/prise en compte à chaque moment suivant où elle serait logique ; si un élément disparaît sans explication, la scène n'est pas terminée.

### 5.11 Rappel d'exhaustivité et de logique
Avant de considérer un beat ou un acte terminé, vérifier : tous les personnages censés être présents le sont-ils, chacun réagit-il conformément à sa personnalité et son état établis, aucun élément introduit n'est-il abandonné sans suite, l'enchaînement reste-t-il logique d'un beat à l'autre (position, humeur, musique, lumière).

---

## 6. Transitions et gestion des OST

### 6.1 Transitions
- Une transition n'est jamais un simple effet posé entre deux blocs : elle fait partie de la mise en scène.
- **Critère de déclenchement du fondu à l'intérieur d'une cinématique** : un fondu ne se justifie que lors d'un **changement de configuration majeur** — redisposition complète des personnages, changement d'activité (ex. rassemblement debout → repas assis → coucher). L'arrivée d'un nouveau personnage dans une configuration déjà établie, une réaction collective, un dialogue qui s'enchaîne dans la même disposition : **aucun fondu**, rester en continu.
- Test rapide : les personnages seraient-ils positionnés et occupés différemment juste avant/après ce point ? Si oui, fondu justifié ; sinon, mettre en scène l'événement en continu.
- Le timing du fondu doit être calé sur la fin réelle de l'action, pas couper un mouvement ou une réplique en cours. À l'entrée du nouveau lieu, le fondu ne se lève qu'une fois tout en place (caméra, personnages, décor).
- Le son suit la logique de la transition (pas de musique de l'ancienne zone qui continue après le fondu, pas de coupure incohérente).

### 6.2 OST
- Chaque acte/segment a sa propre identité sonore — jamais une même piste du début à la fin d'une cinématique.
- Le silence est un outil de mise en scène à part entière, utilisé volontairement pour préparer un contraste (référence : le silence avant l'irruption de Plum au campement du Mont Windsep, ou le silence avant l'apparition de Tornadus).

---

## 7. Séquences de rêve — modèle Rescue Team obligatoire

Toutes les scènes de rêve du projet suivent la même structure technique, celle des séquences de rêve de *Rescue Team* :
- Un **parallax de couleur** en arrière-plan (fond qui défile avec une teinte dominante), jamais un décor de Ground classique.
- Le sprite du héros reste **centré à l'écran**, sans déplacement libre — il est le sujet de la scène, pas un acteur qui s'y déplace.
- Tout personnage qui y apparaît (ex. Gardevoir) est un sprite dans ce même espace, positionné pour dialoguer face au héros.
- **Ouverture silencieuse** : écran noir avec texte de transition, totalement silencieux (aucune musique, aucun bruitage) avant l'ouverture visuelle.
- **Bascule synchronisée** : parallax et musique démarrent ensemble, exactement au moment de la bascule.
- **Flottement/confusion du héros joué visuellement** avant toute intervention extérieure (posture interrogative, hésitation).
- **Apparition de tout personnage majeur** : jamais instantanée — silence temporaire, lumière étrange, clignotement, apparition progressive, effet spectral, caméra attirée vers lui.
- Pour l'adaptation Rescue Team → New Era (30 ans plus tard) : le contenu narratif du rêve peut évoquer les événements de Rescue Team réinterprétés avec ce recul temporel, jamais copiés tels quels — cf. `prompt_geometrie_rescue_team_chapitre6.md`.

---

## 8. Logique spatiale obligatoire (fondation technique de toute cinématique)

**Aucune zone n'est walkable par défaut.** Chaque élément visuel d'une map (bâtiment, rocher, eau, rive, tronc d'arbre, falaise) doit avoir sa collision explicitement décidée avant que la map serve de décor à une cinématique — jamais laissée à la valeur par défaut du moteur. Référence complète : `prompt_logique_spatiale_obligatoire.md`.

Avant de scripter une cinématique sur une map :
1. Vérifier que tous les éléments solides ont une collision fonctionnelle réelle.
2. Vérifier qu'aucune trajectoire scriptée ne traverse un obstacle.
3. Vérifier l'absence de superposition entre entités aux positions de la scène.
4. Utiliser `outil_previsualisation_ground_logique_spatiale.md` (ou l'audit manuel équivalent) avant intégration.

**Deux templates de référence à ne jamais confondre** (cf. `prompt_correction_fin_chapitre5_templates.md`) :
- **Positionnement, collisions, coordonnées** → le **camp du Tunnel**.
- **Narration, mise en scène, développement de personnages** → le **campement du Mont Windsep**.

Un contenu correctement produit résulte toujours de la fusion des deux registres — jamais l'un aux dépens de l'autre.

---

## 9. Boss et mini-boss dans les cutscenes

Référence complète : `boss_miniboss_narration_voix.md`, `arenes_boss_arc_tournoi.md`.

- **Aucun boss gratuit.** Avant d'écrire la scène : qui est-il, pourquoi est-il ici, que veut-il, quel est l'enjeu pour le héros, que devient-il après le combat (choisi consciemment, jamais un simple écran de victoire suivi de silence).
- **La Voix (`\uE040`) est rare.** Elle n'intervient que si elle est indispensable à la compréhension ou à la tension — si la scène fonctionne sans elle, elle ne doit pas apparaître.
- L'arène est construite manuellement, jamais générée procéduralement, cohérente avec le biome et la personnalité du légendaire. Chaque boss doit avoir une entrée, une composition d'arène et un ton de dialogue **visuellement et narrativement distincts** des autres boss déjà écrits du projet (ne jamais recopier le gabarit « boss légendaire qui plane et parle d'équilibre »).
- L'apparition d'un boss suit la même règle que celle des personnages majeurs en rêve : jamais instantanée, toujours construite (silence, signes annonciateurs progressifs, caméra qui la met en valeur).

---

## 10. Format de plan de cinématique — méthode de production

Toute cinématique complexe doit être découpée en un **plan de beats**, avant script final, sur ce modèle (déjà appliqué au campement du Mont Windsep, à Tornadus, aux Ruines Tordues) :

```
# | Beat | Personnages / action | Caméra | Notes
```

- Chaque acte a sa disposition d'ouverture explicite (qui est où, en train de faire quoi).
- Chaque table de beats précède un tableau OST dédié à la séquence.
- Les beats de dialogue long sont numérotés séparément (ex. D.1, D.2...) avec réplique, caméra, notes de personnalité.
- Le plan se termine toujours par un **auto-questionnement** propre à la scène, qui reprend les points spécifiques les plus à risque de cette cinématique précise.

Ce niveau de granularité n'est pas optionnel pour les cinématiques majeures (ouverture de sous-arc, révélation, confrontation de boss) : elles doivent durer plusieurs dizaines de minutes cumulées une fois développées en détail, avec une véritable psychologie de personnages, jamais une poignée de répliques expédiées. Les cinématiques mineures restent proportionnées à leur poids narratif.

---

## 11. Audit final obligatoire avant de considérer une cinématique terminée

Vérifier systématiquement (liste complète, cf. `prompt_mise_en_scene_optimise.md` section 2.5) :
1. Réactions de chaque personnage aux événements.
2. Positionnement et déplacements.
3. Orientation selon la position réelle.
4. Animations et expressions.
5. Cohérence dialogues/émotions.
6. Mouvements de caméra justifiés.
7. Distances/espacement naturel.
8. Entrées et sorties de scène.
9. Collisions et superpositions.
10. Continuité entre cinématiques et Grounds.
11. Réorientation selon position réelle (derrière/côté/devant) au foyer d'attention actuel.
12. Absence d'idle superflu.
13. Dosage des réactions.
14. Causalité narrative sur tout élément introduit.

**Test de crédibilité** : si un joueur peut se demander *« Pourquoi ce personnage ne réagit-il pas ? »*, *« Pourquoi personne ne regarde celui qui parle ? »*, *« Pourquoi ce fondu tombe-t-il là ? »* — la scène n'est pas terminée.

---

## 12. Exemples de référence déjà produits dans ce projet

À consulter comme modèles concrets de ce niveau d'exigence, chacun couvrant un cas différent :
- **Campement du Mont Windsep** — référence de structure narrative en actes/beats, développement de personnages, dosage.
- **`plan_cinematique_boss_tornadus.md`** — référence d'apparition de boss, dialogue long avant combat, gestion OST par phase.
- **`plan_cinematique_ruines_tordues_chapitre6.md`** — référence de séquence longue reliant camp, donjon, boss, retour, transition de chapitre.
- **`brief_cinematique_reve_gardevoir.md`** — référence du modèle de rêve Rescue Team.

---

## Auto-questionnement final avant de livrer une cinématique

- Chaque règle des sections 3 à 9 a-t-elle été appliquée, ou certaines ont-elles été oubliées en cours de production ?
- Le plan de beats a-t-il été produit avant le script final, avec sa propre table OST et son auto-questionnement ?
- La map utilisée a-t-elle été vérifiée sous l'angle de la logique spatiale (section 8) avant d'y placer la cinématique ?
- Si un boss est impliqué, sa justification narrative est-elle complète et son traitement visuellement distinct des autres boss du projet ?
- Cette cinématique, comparée aux exemples de référence de la section 12, atteint-elle un niveau de détail comparable ?
- Le test de crédibilité de la section 11 est-il passé sans réserve ?

> Si l'une de ces questions révèle une incohérence, la cinématique n'est pas terminée.
