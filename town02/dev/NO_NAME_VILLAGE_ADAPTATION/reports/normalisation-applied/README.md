# Normalisation NNV ×0,125 — APPLIQUÉE

Transformation réelle exécutée après GO explicite. **Non certifiée** : le
runtime PMDO 0.8.12 n'a pas pu être relancé (voir §9).

## Contrat respecté

```
NNV              → ×0,125   APPLIQUÉ
Pokémon PMDO     → ×1       inchangés
Assets PMU/PMDO  → ×1       inchangés (vérifié par hash)
Rééchantillonnage→ NEAREST  exclusivement, 0 couleur inventée
Level design     →          inchangé, aucun décor ajouté/supprimé
```

## Résultat géométrique

| Élément | Avant | Après | Attendu |
|---|---:|---:|---|
| Monde | 4992×4992 | **624×624** | ✔ |
| Cellule de tuile | 64 px | **8 px** | ✔ |
| `TexSize` | 8 | **1** | ✔ |
| Grille de collision | 624×624 | **78×78** | ✔ |
| Grille de tuiles | 78×78 | **78×78** | inchangée ✔ |

Loi PMDO `grille × TexSize == collision` : **78 × 1 = 78** ✔ sur les deux Grounds.

## Vérifications

**1. Intégrité** — 8 tilesets en cellule 8 px, toutes tuiles préservées
(12 197 / 12 213 / 11 634 / 10 178 + miroirs `living/`), dimensions `{(8,8)}`.

**2. Quatre saisons** — `tex_size: 1`, `dimensions_px: [624,624]`, 15 layers,
grille 78 pour spring / summer / autumn / winter.

**3. Variantes `living/`** — identiques : les 4 environnements + le Ground
`summer_living` sont alignés sur la même géométrie.

**4. Collisions** — 624→78 par règle **MAJORITÉ** sur blocs 8×8.
Surface bloquée 36,6 % → **37,6 %**, fidèle à la source. La règle ANY aurait
épaissi les murs à 44,5 % ; choix documenté et réversible.

**5. Coordonnées** — positions ÷8 exactes
(`Entry_North` 2496,64 → **312,8** ; `Entry_West` 64,2496 → **8,312**).
**Toutes les tailles de markers restent 16×16** — référentiel PMDO préservé.

**6. Assets PMU/PMDO** — `git status` sur `docs/`, `Content/`, `Data/` : **vide**.
Les 143 hashes PMU vérifiés identiques avant/après par le script lui-même, plus
4 vérificateurs indépendants au vert.

**7. Manifests** — 13 régénérés avec la nouvelle géométrie + 2 résumés.

**8. Runtime** — 5 rapports marqués `OBSOLETE_MUST_RETEST`.

**11. Animations** — 11 120 cellules animées, 147 614 frames,
`FrameLength` {1, 30} : cycles et timings **conservés**.

**12. Particules** — `winter/particles/` **hors périmètre, intact**.

## §9 — BLOCAGE : runtime PMDO non exécutable

Le harness `run_rmvillage_season_runtime.py` requiert :

```
.runtime-cache/pmdo-headless-bundle/PMDO      → ABSENT
.runtime-cache/test-venv/bin/python           → ABSENT
```

Ces artefacts sont gitignorés et n'ont jamais été régénérés dans cet
environnement. **Je me suis arrêté plutôt que de simuler un résultat.**

Conséquence : les points **9, 10 et 13** (runtime, déplacement/collision en jeu,
comparaison runtime) restent **non exécutés**. La transformation est
`APPLIED_NOT_CERTIFIED`.

## Incident signalé

Mon script de régénération des manifests a modifié
`winter/particles/manifest.json`, alors que les particules devaient rester hors
périmètre. **Détecté et restauré** via `git checkout`. Les assets
`particles/Content/Particle/` n'ont jamais été touchés. Vérifié : `git status`
sur ce dossier est vide.

## Rendu de contrôle

`AFTER_REAL_pokemon_nnv_pmu.png` — lu **depuis les fichiers transformés**
(TexSize 1, monde 624 px, cellule 8 px), avec building PMU natif ×1 et sprite
Pokémon PMDO natif ×1. Le résultat correspond au rendu de référence validé :
Pokémon, maison, arbres, rochers et chemins à la même échelle perceptible.

## Périmètre effectif

17 fichiers modifiés sous `NO_NAME_VILLAGE_ADAPTATION/generated/` uniquement.
Sauvegarde complète hors Git : `.runtime-cache/pre-normalisation-backup/`.

## Statut

`NORMALISATION_APPLIED_RUNTIME_PENDING`.

Prochaine étape requise avant certification : restaurer le bundle PMDO 0.8.12
headless, puis relancer les tests runtime sur les quatre saisons.
