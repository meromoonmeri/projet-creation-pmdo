# Scènes fixes : Ground de fin, arène, midpoint

Règle verrouillée dans le schéma, dans l'export et dans les tests
(`tests/test_dungeon_builder.py::TestBossSceneRules`).

## 1. Combat final

| Cas | `boss.mode` | Ce que le Builder exige | Ce qu'il interdit |
|---|---|---|---|
| Le donjon possède un Ground de fin canonique exploitable | `canonical_ground` | `boss.ground` (ou `fixed_grounds.end`) doit exister dans `Data/Ground` ; si un `.rsmap` de scène est déclaré, il doit exister dans `Data/Map` | — |
| Aucun Ground de fin exploitable | `arena_rsmap` | `boss.map` doit exister dans `Data/Map` **avant** conversion en Ground | Interdit dès qu'un Ground de fin canonique est détecté |

La détection n'est pas déclarative : `grounds.find_canonical_end_grounds()`
**scanne** `Data/Ground` en croisant l'`id` du donjon et ses `aliases` avec les
suffixes de fin utilisés par le projet (`clearing`, `end`, `fond`, `summit`,
`sommet`, `profondeurs`, `altar`, `den`, `crucible`, `boss`…). Un futur donjon
ne peut donc pas se fabriquer une arène artificielle « par habitude » : le
contrôle échoue avec le nom du Ground canonique qu'il aurait dû utiliser.

Trois validations bloquent en amont, à la lecture de la définition :

* `boss.mode` hors des deux valeurs → erreur de définition ;
* `canonical_ground` sans `ground` ni `fixed_grounds.end` → erreur ;
* `arena_rsmap` déclaré en même temps qu'un `fixed_grounds.end` → erreur.

### Sinister Woods

`aliases: ["sinister_woods"]` → le scan trouve `sinister_woods_clearing`
(D04P02, clairière finale canonique). Le mode est donc `canonical_ground` et le
combat contre Team Dazzling s'y déroule directement. Aucune arène séparée n'est
créée, et une tentative de passer ce donjon en `arena_rsmap` est rejetée par le
test `test_arena_is_forbidden_when_a_canonical_end_ground_exists`.

## 2. Midpoint

Le midpoint n'est **jamais** procédural. `tools/dungeon_builder/ground_pipeline.py`
produit le Ground du donjon à partir du template validé :

```bash
python3 tools/dungeon_builder.py ground sinister_woods --role midpoint \
        --sheet SinisterWoodsB41 --preview
```

Ce que fait le pipeline :

1. lit le template (`Data/Ground/<template>.rsground`, JSON RogueEssence) ;
2. conserve **à l'identique** la géométrie 69×54, les collisions, les marqueurs,
   le spawner et les `GroundObjects` — dont la **Statue Kangourex**
   (`Kangaskhan_Rock`) et les sorties `North_Exit` / `South_Exit` ; l'absence
   d'un objet requis fait échouer la construction ;
3. **retexture** chaque tuile : les deux planches `.tile` sont décodées, chaque
   tuile source reçoit une signature structurelle 4×4 (mosaïque de moyennes
   RGBA) et est appariée à la tuile la plus proche de la planche du donjon.
   Aucun échange de planche « à l'aveugle », aucune transition peinte à la main ;
4. écrit `Data/Ground/<id>_midpoint.rsground` et l'enregistre dans
   `Data/Ground/index.idx` ;
5. `--preview` rend un PNG (`.runtime-cache/<id>.png`) pour vérification visuelle.

Résultat pour Sinister Woods : `gloomy_forest_midpoint.rsground`, 4 455 tuiles
retexturées depuis 1 738 tuiles sources distinctes, entités du template
préservées (2 marqueurs, 1 spawner, 3 ground objects). Le rendu montre bien une
clairière forestière avec l'aire de repos centrale ouverte et les masses
d'arbres en bordure ; un passage artistique manuel reste possible, le pipeline
étant rejouable avec une autre planche via `--sheet`.

## 3. Inventaire canonique des scènes (source d'autorité)

`tools/dungeon_builder/scenes.py` lit
`docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md` — l'inventaire des 245 Grounds PMD
Red convertis, qui donne pour chaque donjon GBA son Ground d'ENTRÉE, de RELAIS
et de FIN/ARÈNE. Chaque nom est ensuite localisé :

| État | Signification | Conséquence |
|---|---|---|
| `ACTIVE_GROUND` | présent dans `Data/Ground` | `canonical_ground`, prêt |
| `ACTIVE_RSMAP` | présent dans `Data/Map` | ce `.rsmap` **devient** ce Ground (pas une seconde arène) → `REQUIRES_INTEGRATION` |
| `ARCHIVED` | présent dans `RESERVE/…` | scène à restaurer telle quelle → `REQUIRES_INTEGRATION` |
| `NONE` | absente partout | et seulement alors : `arena_rsmap` autorisé |

Les sous-donjons de cime/fosse héritent de la scène de leur lieu parent
(`Mt. Blaze Peak` → `d09p03`, `Frosty Grotto` → `d10p03`,
`Magma Cavern Pit` → `fosse_ardente`, `Sky Tower Summit` →
`arc_tour_ciel_sommet`) : la cinématique du légendaire et son combat s'y
déroulent, aucune arène n'est fabriquée.

### Invariant vérifié par les tests

Pour toute définition : `scenes.cinematic_ground == scenes.battle_ground ==
scenes.canonical_end_ground`. Le schéma refuse une définition qui séparerait la
cinématique du combat, et refuse `arena_rsmap` dès que l'inventaire nomme une
scène — **même archivée**.

Résultat du scan exhaustif : sur les 9 arènes que l'étape 6 croyait devoir
créer, **6 possédaient déjà un Ground canonique actif** (`abime_tempetes`
Kyogre, `fosse_argentee` Lugia, `champ_braises`, `champ_vent_boreal`,
`sommet_aurore` Ho-Oh, `antre_occident` Mewtwo, `cretes_boreales` Latios,
`bois_des_plaintes` Suicune) et 2 une scène archivée (`champ_foudre` Raikou,
`caverne_trouble_fond`). Il ne reste que **3 arènes réellement à créer** :
Buried Relic (Regis), Meteor Cave (Deoxys), Purity Forest (Celebi).

## 4. Ce qui reste à produire pour un nouveau donjon

* si le donjon n'a pas de Ground de fin : créer le `.rsmap` d'arène, puis le
  convertir en Ground (le Builder refuse tant que le `.rsmap` n'existe pas) ;
* si le donjon a besoin d'un midpoint : disposer d'une planche de tuiles de son
  biome, puis lancer la commande `ground` ci-dessus.


## 5. Verrouillage définitif de la règle (implémentation)

La règle n'est plus seulement une contrainte de schéma sur les définitions :
elle est **appliquée par le câblage** et **vérifiée**.

* `python3 tools/dungeon_builder.py wire-scenes --apply` calcule, depuis les
  définitions, la sortie de chaque segment de chaque donjon et écrit :
  * `Data/Script/halcyon/zone/<id>/init.lua` — script de zone canonique généré
    (marqueur `-- [dungeon_builder] script de zone canonique généré`) ;
  * les scripts de Ground manquants sur le trajet (sinon la scène serait un
    cul-de-sac) ;
  * le recâblage de tout appel `EnterDungeon` / `ContinueDungeon` d'un Ground du
    périmètre qui visait une zone supprimée ou un segment disparu ;
  * le bloc `wiring` de la définition, qui rend le câblage inspectable.
* Chaîne canonique pied → cime (`CHAINS` dans `tools/dungeon_builder/wiring.py`) :
  `mt_blaze → mt_blaze_peak`, `mt_thunder → mt_thunder_peak`,
  `mt_freeze → mt_freeze_peak`, `frosty_forest → frosty_grotto`,
  `magma_cavern → magma_cavern_pit`, `sky_tower → sky_tower_summit`.
  Le donjon parent finit sur son **Ground de relais canonique** (D09P02, D06P02,
  D11P02, D10P02, `gorge_ardente_coeur`, `arc_palier_celeste`) qui enchaîne sur
  la cime ; la **cime** finit sur le **Ground final canonique** (D09P03, D06P03,
  D11P03, D10P03, `fosse_ardente`, `arc_tour_ciel_sommet`), où la scène se joue
  et où le run se termine — aucune arène séparée, aucune téléportation.
* Scènes de gardien New Era (`champ_braises`, `abime_tempetes`, `antre_occident`,
  `fosse_argentee`, `cretes_boreales`, `champ_vent_boreal`, `vallon_perdu`,
  `sommet_aurore`, `bois_des_plaintes`, `sanctuaire_voeu`) : la scène est jouée
  à la fin de l'avant-dernier segment puis rend la main au **même donjon** pour
  le combat sur son étage d'arène. Elles ne renvoient plus vers `mt_blaze`,
  `frosty_forest`, `new_era_zone_XX` ou `ile_eon`, vestiges de l'ancienne
  implémentation.
* **Boss internes** : `buried_relic` et `meteor_cave` n'ont ni Ground de fin ni
  Ground de scène. Leur combat se déroule dans la salle fixe
  `Data/Map/<id>_arena.rsmap` chargée en étage. Le contrôle `scene_rule` échoue
  si un Ground narratif leur est attribué.


## 6. Correction : retour aux cinématiques canoniques de la ROM (2026-08-23)

### Ce qui n'allait pas

Les Grounds PMD Red importés dans le mod avaient été récrits par des passes
antérieures avec des cinématiques **inventées** — « Veilleurs du Réseau des
Anciens Chemins » et « cinématiques d'Ancrage (Livre II) ». Conséquence
directe, mesurée : **8 combats de boss inventés se déclenchaient dans des
Grounds d'entrée ou de relais**, là où le canon n'en met aucun :

| Ground | Rôle canonique | Contenu inventé trouvé |
|---|---|---|
| `foret_tendre_oree` (D01P01) | entrée Tiny Woods | boss « Veilleur » |
| `grotte_statique_seuil` (D02P01) | entrée Thunderwave Cave | boss « Veilleur » |
| `pic_ferreux_pied` (D03P01) | entrée Mt. Steel | boss « Rempart, Veilleur du Vieux Fer » |
| `bois_sombres_oree` (D04P01) | entrée Sinister Woods | boss « Veilleur » |
| `gouffre_muet_bord` (D05P01) | entrée Silent Chasm | boss « Veilleur » |
| `mont_grondant_pied` (D06P01) | entrée Mt. Thunder | boss « Câble-Vif, Veilleur du Grand Orage » |
| `palier_celeste` (D13P02) | relais Sky Tower | boss « Déchire-Nuages » |
| `gloomy_forest_midpoint` | relais | scène de boss |

Dix autres Grounds d'arène portaient des dialogues inventés d'« Ancrage » à la
place du texte de la ROM.

### Pourquoi c'est arrivé

Le texte canonique des scènes existe pourtant dans le dépôt
(`Data/Script/halcyon/arc_fugitif/strings*.resx`, 4 186 clés `SCENE_*`), mais il
n'était **pas branché** : `Text.FormatKey` lit `Strings/strings*.resx`, que le
mod ne fournissait pas. Chaque `STRINGS:FormatKey("SCENE_D06P01_001")` renvoyait
donc la clé, et les passes précédentes ont écrit des dialogues à la place.

### Ce qui a été fait

1. `tools/import_red_scene_strings.py` : import des **930 répliques canoniques**
   des scènes de donjon D01–D25 dans `Strings/strings.fr.resx` et
   `Strings/strings.resx`.
2. `tools/dungeon_builder.py canon-scenes --apply` : régénération des **44
   Grounds canoniques** à partir des squelettes extraits de la ROM
   (`RESERVE/red_scene_reference/*.lua`) — musique, ordre et nombre de
   répliques. Le lecteur `halcyon.RedCanonScene` saute une réplique dont le
   texte n'est pas importé plutôt que d'en inventer une.
3. Les 18 cinématiques inventées sont archivées sous
   `RESERVE/legacy_ch6_32/invented_scenes/` (rien n'est détruit).
4. Rôles respectés : **entrée et relais ne contiennent aucun combat** ; les boss
   restent à la scène de fin canonique (D06P03 Zapdos, D09P03 Moltres, D10P03
   Articuno, D11P03 Feunard, D12P04 Groudon, D13P03 Rayquaza, D14–D25 arènes de
   post-game) ou dans le donjon (`fixed_floors` pour Buried Relic et Meteor
   Cave, comme `src/dungeon_boss_dialogue.c`).

Rapport : `docs/dungeon_builder/CANON_SCENES.md`.

### Vérifié par le moteur après correction

1 429 étages générés (0 échec), 54 liaisons zone → Ground chargées (0 problème),
aucun script Lua en erreur au chargement : `docs/dungeon_builder/runtime/MAPGEN_RUNTIME_CANON.md`.

### Ce qui reste à importer

13 pistes musicales citées par les scènes de la ROM n'existent pas dans
`Content/Music` (liste dans `CANON_SCENES.md`) : la scène se joue sans changer
la musique plutôt qu'avec un titre de remplacement inventé.
