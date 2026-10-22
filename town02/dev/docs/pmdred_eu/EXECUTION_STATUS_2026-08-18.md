# Exécution de la pipeline PMD Red EU — 2026-08-18

Ce relevé consigne les actions exécutées après l'audit d'onboarding. Il ne
remplace aucun rapport historique et ne transforme pas une gate échouée en
succès.

## 1. D1 — index des tilesets

### Préconditions vérifiées

- Les **438** destinations Ground/tile des 219 promotions archive-backed
  correspondent toujours byte par byte aux 219 `promotion_record.json`.
- Aucun `.rsground` ni `.tile` n'a été régénéré ou modifié.
- L'ancien `Content/Tile/index.idx` avait :
  - SHA-256 `d7ce516afb1ce0f6468796d2000a388692621df2c8b176f992c66ac0dbd49f9c` ;
  - 735 entrées ;
  - 23 577 900 octets.

### Action

Outil existant utilisé, sans méthode parallèle :

```bash
python3 tools/rebuild_tile_index.py
```

La génération lit tous les `.tile` présents et copie uniquement leur en-tête et
leur table native dans l'index. Comparaison avant/après :

- 735 anciens noms conservés ;
- 217 noms ajoutés ;
- aucun ancien nom supprimé ;
- une seule table existante corrigée : `t01p01_Base`, dont l'index historique
  ne correspondait déjà plus au `.tile` courant.

Nouvel index :

- SHA-256 `37593232fc7c0552b4b32cf9a74a0854869f03fd21f9c0156680f137c0687075` ;
- 952 entrées ;
- 57 069 229 octets ;
- 952/952 entrées exactes contre les fichiers `.tile`.

### Gate

```bash
python3 tools/verify_tile_index.py --quiet
```

Résultat : **PASS** — `952 tilesets dans index.idx, 952 .tile sur disque` et
aucune référence de carte absente.

**Statut D1 :** `VALIDATED_STATIC`. Aucun runtime PMDO global n'est déduit de
cette correction d'index seule.

## 2. D2 — restauration des dépendances exactes

La garde de branche de `tools/restore_pmdred_eu_validation_runtime.sh` refusait
la branche fixe actuelle. Elle a été étendue à
`arena/01a0159e-new-era-abyss-to-ascension-v4` sans retirer les branches
historiques.

La sortie historique attendait un log contenant un tiret cadratin, alors que le
`main.lua` courant est différent et possède le SHA-256
`8add81a133b5dbd5995c17cd98b9b5dc7aec8ce6c636d8e4d1a8dedcde31481d`. La garde
n'a pas été neutralisée : elle accepte désormais uniquement le couple exact
suivant pour cette variante source :

- SHA du log courant :
  `ba292fb1338fd8c41e24943f5ed66065d47e9ef26f45a38e5efa7be95a7f5fbb` ;
- SHA de `main.lua` : celui indiqué ci-dessus.

Le SHA historique `3df47e3be040b124c5768b076c89fb586ff4b807890f154b22387667069c8ab8`
reste accepté séparément et aucune preuve historique n'a été réécrite.

Restauration réussie avec les gates de hashes :

- ROM EU : SHA attendu validé ;
- PMDO 0.8.12 : SHA attendu validé ;
- DumpAsset : 11 485 fichiers, manifeste d'arbre validé ;
- extraction normalisée : 724 fichiers, manifeste validé ;
- candidats archive-backed : 219/219, 23 716 938 comparaisons, zéro échec ;
- environnement Python épinglé : Pillow 12.3.0, skytemple-files 1.8.5,
  lupa 2.8 ;
- `runtime_restoration_status.json` : `PASS`.

Le checkpoint officiel a ensuite été régénéré par
`tools/update_pmdred_eu_validation_progress.py --write`, puis vérifié avec
`--check` : **219 validés, 0 restant, checkpoint PASS**.

**Statut D2 :** `VALIDATED_ENVIRONMENT`. Cela ne certifie pas un nouveau run
complet des 219 Grounds avec le code courant.

## 3. Validations PMD Red indépendantes fraîches

Avec la ROM restaurée :

- `test_pmdred_eu_audit.py -v` : **12/12**, aucun skip ROM ;
- `test_pmdred_dungeon_ground.py -v` : **22/22**, aucun skip ROM ;
- `audit_pmdred_bma_auxiliary.py` : **201/201** BMA correspondants ;
- `validate_pmdred_dungeon_ground_bundle.py` : **27 relations, 204 streams,
  131 frames, 138 fichiers** ;
- `validate_pmdred_dungeon_ground_migration.py` : **27 Grounds, 176 fichiers,
  29 515 tuiles atlas**, régénération byte-identique ;
- audit scripts EU 27 : **27 graphes, 267 tableaux, 5 617 commandes,
  711 textes français**, verdict PASS ;
- audit narratif frais 133 : **69 graphes exacts, 64 dépendances techniques,
  3 073 textes français**, sans modification in-game.

La preuve fraîche de l'audit narratif est conservée dans
`docs/pmdred_eu/narrative_audit/current_2026-08-18/`.

## 4. Runtime PMDO courant — pilotes et limite rencontrée

Deux pilotes ont été exécutés contre le code courant, l'index courant et les
candidats authentifiés :

| Pilote | Samples | Exact/opaque | Lifecycle | Verdict |
|---|---:|---:|---|---|
| archive-backed `a01p01` | 2 | 2/2 | normal exit 0, aucun signal, aucun résidu | PASS |
| archive-backed `a02p02` | 145 | 145/145 | normal exit 0, nettoyage PASS | PASS |
| dungeon-backed 27 Grounds | 131 | 131/131 | normal exit 0, nettoyage PASS | PASS |

La preuve complète des 27 Grounds est archivée dans
`docs/pmdred_eu/pmdo_validation/current_2026-08-18_direct/` avec son manifeste
`evidence_hashes.sha256`. Les deux pilotes archive-backed restent dans
`.runtime-cache/` comme preuves de contrôle courantes et ne sont pas présentés
comme certification de la matrice 219.

Un run exhaustif courant des 219 archive-backed a été lancé avec le fixture
natif existant. Il a atteint 24 389 captures et 74 509 événements, jusqu'à
`b11p02b` tick 1551, puis a franchi la limite de terminaison de 3 600 secondes.
La gate a donc correctement échoué :

- `terminal_seen = false` ;
- `requested_signal_sent = true` ;
- retour 143 ;
- aucune comparaison finale n'a été déclarée ;
- aucune certification nouvelle n'a été produite.

Ce run partiel a été supprimé de `.runtime-cache/` après consignation de son
échec. Il ne remplace pas les preuves historiques 219/219.

**Statut runtime courant des 219 :** pilotes PASS, matrice exhaustive courante
non terminée. Les 219 restent donc soumis à leur preuve historique et à cette
barrière si l'objectif est une certification spécifique du checkout actuel.

## 5. Prochaine étape produit vérifiée : Sinister Woods

Le garde-fou existant a été exécuté avec le `pret/pmd-red` restauré :

```bash
PMD_RED_SOURCE=.runtime-cache/pmd-red-reference \
  .runtime-cache/test-venv/bin/python tools/audit_gloomy_sinister_gba.py
```

Résultat : les **23 tables d'étages**, espèces/niveaux/probabilités et la musique
passent ; les deux barrières restent explicitement en échec :

- `no_relic_forest_dependency = false` ;
- `no_treeshroud_graphics_substitution = false`.

La séparation de câblage a maintenant été effectuée et auditée :
`Data/Zone/gloomy_forest.json` ne contient plus de `relic_forest_blob_*` ni de
`ReverseRelicForest`, tandis que `Data/Zone/relic_forest.json` conserve les
cinq `LoadBlobStep` et les six maps nécessaires. Les six `.rsmap`/`.tile` n'ont
pas été supprimés. La preuve structurelle et le runtime contrôlé sont dans
`docs/pmdred_eu/narrative_audit/SINISTER_WOODS_RELIC_FOREST_SEPARATION_2026-08-18.md`.
Le remplacement graphique b41 reste séparé et la route de production n'est
pas encore écrite.

## 6. État de promotion après exécution

- 219 archive-backed : preuves historiques graphiques/runtime conservées ;
  index courant maintenant validé statiquement ; aucune nouvelle promotion
  effectuée par cette session.
- 27 dungeon-backed :
  - reconstruction et différentiel indépendants : PASS ;
  - staging `RESERVE/pmdred_direct/` : PASS et régénération byte-identique ;
  - runtime PMDO courant : **27/27, 131/131 exacts**, lifecycle PASS ;
  - scripts EU, musique, entrées/sorties, événements et transitions : non
    migrés ;
  - statut final : **STAGED + GRAPHICS_VALIDATED + RUNTIME_TESTED**, mais pas
    `CERTIFIED` ni `PROMOTED` au sens produit complet.
- Narration : audit frais terminé ; les 133 scènes restent non migrées comme
  scènes complètes. Les 64 graphes en dépendance ne sont pas convertis par
  approximation.

Deux barrières restent séparées : la matrice runtime exhaustive courante des
219 doit encore être exécutée par lots bornés si l'on veut une certification
spécifique de ce checkout ; indépendamment, la prochaine étape produit est la
migration narrative explicite des chaînes PMD Red, en commençant par le gate
ciblé Sinister Woods enregistré dans
`docs/canonical_journeys/SINISTER_WOODS_GATE.json`, sans toucher aux Grounds
certifiés, aux chapitres 1–5 ni aux routes FugitiveArc protégées.
