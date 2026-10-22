# AUDIT ARÈNES DE BOSS — positions, apparition, qualité cinématique

**Branche audité : `arena/019fd882-new-era-abyss-to-ascension-v4` (commits jusqu'au 2026-08-08 22:08).**
**Statut : audit 100 % lecture seule. Aucune modification, aucun commit.**
**Outil : `/tmp/audit_arenas2.py` + `/tmp/audit_bossform.py` (analyse JSON des 94 `.rsmap`).**

---

## 0. RAPPEL DES DIRECTIVES CINÉMATIQUE (à respecter pour toute création/retouche)

Source : `docs/canonical/CUTSCENE_QUALITY_STANDARD.md` + `docs/grammaire_cinematiques.md` (branche auditée).

1. **Rien n'est présumé acquis** : une cinématique doit être auditée réellement avant d'être considérée terminée (jamais validée par impression).
2. **Objectif qualité** : chaque cinématique doit pouvoir être confondue avec une cinématique officielle PMD Explorateurs — écriture, mise en scène, langage corporel, caméra, finition.
3. **Carte blanche sur le comment, aucune liberté sur le si** :
   - aucun personnage actif hors champ quand il doit être visible/agir ;
   - positionnement esthétique composé, jamais au hasard ;
   - réactivité systématique de chaque Pokémon (aucun figurant passif) ;
   - dialogues cohérents avec la personnalité et l'état de connaissance ;
   - déplacements logiques et sans collision (personnages ne se traversent jamais).
4. **Le héros ne parle jamais à voix haute** : pensées `(parenthèses)` brèves, emotes, idles dirigés.
5. **Orientation selon la position réelle** : chaque personnage se tourne vers son interlocuteur selon SA géométrie — jamais une rotation uniforme de groupe.
6. **Déplacements crédibles** : marche jusqu'à l'interlocuteur, distance naturelle, jamais de téléportation d'état, jamais de chevauchement.
7. **Pas d'idle parasite** : un personnage sans raison de bouger reste en pose d'attente crédible.
8. **Dosage des réactions** : moments calmes sobres, réactions marquées réservées aux vrais moments.
9. **Mouvement de caméra justifié** : uniquement s'il sert un besoin réel (suivre, révéler, souligner).
10. **Chaque entité reçoit un traitement proportionné** (central : dialogue + insert caméra ; secondaire : réaction visible ; figurant : occupé de façon cohérente).
11. **Causalité narrative** : tout élément introduit reste présent/prise en compte ensuite.
12. **Transitions** : fondu uniquement lors d'un changement de configuration majeur ; sinon continuité. Son suit la transition.
13. **OST** : chaque acte a son identité sonore ; le silence est un outil (réf. silence avant Tornadus).
14. **Rêves — modèle Rescue Team** : parallax coloré, héros centré, apparition jamais instantanée, ouverture silencieuse, bascule synchronisée.
15. **Logique spatiale obligatoire** : aucune zone walkable par défaut ; collision explicite avant toute cinématique ; aucun trajet ne traverse un obstacle ; aucune superposition d'entités.
16. **Boss** : aucun boss gratuit (qui/quoi/pourquoi/enjeu/après-combat) ; arène construite manuellement, distincte des autres boss ; **apparition jamais instantanée** (silence, signes annonciateurs progressifs, caméra qui met en valeur) ; la Voix (`\uE040`) est rare.
17. **Format de production** : plan de beats avant script final (tableau `# | Beat | Personnages/action | Caméra | Notes`) + tableau OST + auto-questionnement.
18. **Audit final obligatoire** : 14 points (réactions, positionnement, orientation réelle, animations, cohérence, caméra, espacement, entrées/sorties, collisions, continuité, réorientation, absence d'idle superflu, dosage, causalité).
19. **Test de crédibilité** : si un joueur peut se demander « pourquoi il ne réagit pas ? », « pourquoi personne ne regarde celui qui parle ? », « pourquoi ce fondu tombe là ? » — la scène n'est pas terminée.

---

## 1. MÉTHODE DE L'AUDIT

Pour chacune des **94 arènes** (`Data/Map/*.rsmap`) de la branche :
- équipes (`MapTeams` + `AllyTeams`) : espèces BaseForm vs CurrentForm, niveaux, positions (`serializationLoc`) ;
- `EntryPoints` (arrivée des protagonistes) ;
- grille de collision (`Tiles`, indexée `[X][Y]` — convention RogueEssence vérifiée dans le moteur) : walkable = `floor` ;
- distances boss ↔ arrivée, boss ↔ collision, arrivée ↔ collision.

**Convention de rendu vérifiée dans le moteur** (`RogueEssence/Dungeon/Characters/Character.cs:112-122`) :
`Appearance` = `ProxySprite` si valide, sinon **`CurrentForm`** → **le sprite affiché est le CurrentForm, PAS le BaseForm**.

Résultat : **73 arènes OK, 21 avec anomalies.**

---

## 2. ANOMALIES CRITIQUES — MAUVAIS SPRITE DE BOSS (CurrentForm ≠ BaseForm)

**20 joueurs dans 13 arènes** ont `BaseForm` ≠ `CurrentForm` → le joueur voit le **CurrentForm** au combat.

| Arène | Boss VOULU (Base) | Sprite AFFICHÉ (Current) | Niv | Impact |
|---|---|---|---|---|
| `tour_ciel_sommet` (sky_tower seg5) | **rayquaza** | **tsareena** | 40 | Rayquaza affiché en Tsareena |
| `frosty_forest_summit` (frosty_forest) | **articuno** | **zeraora** | 33 | Articuno affiché en Zeraora |
| `wish_cave_jirachi` (wish_cave) | **jirachi** | **zeraora** | 40 | Jirachi affiché en Zeraora |
| `crystal_sanctuary_boss` (ch8) | **diancie** | **tsareena** | 32 | Diancie affichée en Tsareena |
| `crystal_sanctuary_miniboss` | carbink + froslass | tsareena ×2 | 28 | 2 mini-boss affichés en Tsareena |
| `forgotten_marsh_boss` (ch9) | **swampert** (Laggron) | **tsareena** | 35 | Laggron affiché en Tsareena |
| `forgotten_marsh_miniboss` | swalot + toxicroak | tsareena ×2 | 31 | mini-boss affichés en Tsareena |
| `cloven_ruins_regice` | regice | **regigigas** | 30 | Regice affiché en Regigigas |
| `cloven_ruins_regirock` | regirock | **regigigas** | 32 | Regirock affiché en Regigigas |
| `cloven_ruins_registeel` | registeel | **regigigas** | 34 | Registeel affiché en Regigigas |
| `sanctuaire_titans` | regigigas (+gardiens) | regigigas + hitmonlee×4 + bronzong×4 | 36/31 | Les 8 « gardiens » affichés en Hitmonlee/Bronzong (Base=regigigas) |

**Origine probable (à confirmer en jeu)** : copie de template — les arènes de boss ont été dupliquées depuis un modèle (tsareena/zeraora/regigigas) et seul le `BaseForm` a été mis à jour, pas le `CurrentForm`. Le moteur rend `CurrentForm` → mauvais sprite.

**Vérification complémentaire faite** : aucun script de zone ne corrige le `CurrentForm` au runtime pour ces arènes (pas de `SetForm`/`CharSetForm` ciblant le boss de combat ; les scripts créent le boss pour la cinématique de *ground*, mais le *combat* se joue sur l'étage-arène avec son MapTeam).

⚠ **À corriger en priorité** : mettre le `CurrentForm` à l'identique du `BaseForm` dans ces 13 arènes (ou poser un `ProxySprite` correct). C'est le point qui casse le plus la « qualité cinématique » perçue (le joueur voit un Pokémon autre que le boss annoncé).

---

## 3. ANOMALIES DE POSITION — boss/entités NON walkable ou hors arène

| Arène | Entité | Position | Problème |
|---|---|---|---|
| `tour_ciel_sommet` | boss | (7,9) | tuile `unbreakable` (mur) — le boss est posé dans un mur |
| `frosty_forest_summit` | boss | (7,5) | tuile `unbreakable` |
| `gloomy_forest_boss` | zeraora | (7,5) | tuile `unbreakable` |
| `marais_errants_fond` | goodra | (7,3) | tuile `grass` (non `floor`) |
| `boss_artifact_water` | 4 boss | (2,2)(6,2)(2,6)(6,6) | tuile `water` |
| `forgotten_marsh_miniboss` | 2 mini-boss | (7,9) | **hors bornes** (map 7×7 !) |
| `metano_raid_1/2/3` | équipe ennemie | (5,8) etc. | tuile vide + collée à l'arrivée (dist=0/1) |
| `mount_windswept_guardian` (Tornadus) | alliés L5 | (1,8)(2,8)(11,9)(12,8) | tuile `unbreakable` |

**À vérifier en priorité** :
- `forgotten_marsh_miniboss` : les 2 mini-boss sont **hors de la carte** (7×7) — le combat est probablement cassé ou les boss invisibles ;
- les boss posés sur `unbreakable`/`grass`/`water` : ils apparaissent dans un mur ou dans l'eau — à confirmer en jeu (le moteur peut les décaler à l'apparition, mais la position déclarée est incohérente avec l'arène).

---

## 4. BOSS COLLÉS À L'ARRIVÉE (pas de distance de mise en scène)

| Arène | Entité | Boss | Arrivée | Distance |
|---|---|---|---|---|
| `metano_raid_1/2/3` | shuppet/gastly/mismagius… | ennemis | (5,8)/(6,8) | **0-1** (les ennemis apparaissent sur l'arrivée des protagonistes) |
| `sanctuaire_voeu` | mismagius | — | (7,7)/(8,7) | 1 |
| `metano_town_duel` | azumarill | — | (6,10)/(5,10) | 1 |

Les raids Metano (`metano_raid_*`) : les ennemis spawn **sur** la position d'arrivée des protagonistes → aucun temps de mise en scène, apparition instantanée dans le visage du joueur. À confirmer si c'est voulu (embuscade) ou si les positions d'arrivée/d'ennemis doivent être séparées (directive : apparition jamais instantanée).

---

## 5. ENTRYPOINTS NON WALKABLE

| Arène | EntryPoint | Problème |
|---|---|---|
| `special_grass_maze` | (8,15) | tuile `grass` (peut être volontaire : terrain traversable spécifique) |
| `metano_raid_2` | (6,8)/(5,8) | tuile vide |

---

## 6. SYNTHÈSE PAR OBJECTIF (directive utilisateur)

| Vérification demandée | Résultat |
|---|---|
| **Boss non décalés de leur arène** | ⚠ 9 arènes avec boss sur tuile non-walkable / hors bornes (`forgotten_marsh_miniboss` pire : hors carte) |
| **Arrivée des protagonistes visible dans le lieu** | ✅ EntryPoints présents dans 73/94 arènes ; ⚠ 21 arènes avec anomalies de collision autour |
| **Le boss apparaît devant eux** | ⚠ 20 joueurs au mauvais sprite (Current≠Base) ; raids Metano : ennemis collés à l'arrivée |
| **Cinématiques quali** | À évaluer par scène (voir §7) — la base de données est saine, mais le rendu du boss (sprite) et sa position d'apparition sont les points faibles |

---

## 7. PROCHAINE ÉTAPE (sur validation)

1. Corriger les 13 arènes `CurrentForm` ≠ `BaseForm` (sprite du boss) — 20 joueurs.
2. Corriger les positions non-walkable / hors bornes (dont `forgotten_marsh_miniboss` hors carte).
3. Séparer les positions d'apparition ennemie des EntryPoints dans les raids Metano.
4. Puis audit scène par scène des cinématiques (plan de beats vs script réel) sur les arènes à boss, selon les 19 directives §0.

**Aucune modification effectuée — en attente de validation.**
