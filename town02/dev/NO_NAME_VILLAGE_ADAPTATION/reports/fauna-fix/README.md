# Correctif — faune source jamais peinte en décor

## Le bug

Vous aviez raison : des oiseaux étaient visibles sur les rendus. Ce n'était pas
un cas isolé.

Le convertisseur excluait la faune avec ce filtre :

```python
if object_name.startswith(("objmob", "objbmob")) or object_name in {...}:
    continue
```

Seul le préfixe `objmob` était reconnu. Tout ce qui ne le portait pas passait au
travers et était **peint dans le Ground comme une tuile décorative**.

L'inventaire, lui, les avait bien signalés `REVIEW_REQUIRED` avec
`import_policy: manual_semantic_review` et
`reason: insufficient_semantic_evidence; never auto-promote`. **Le convertisseur
ne lisait tout simplement pas ce statut.**

## Ampleur réelle — bien au-delà des oiseaux

Une recherche exhaustive sur les 727 objets source, par jetons sémantiques
(`mob`, `bird`, `butterfly`, `bug`, `firefly`, `frog`) et non par préfixe
supposé, donne :

| Objet | Instances peintes | Statut inventaire |
|---|---:|---|
| `objbutterfly1` | **478** | `REVIEW_REQUIRED` |
| `objbug0` | **369** | `REVIEW_REQUIRED` |
| `objfirefly` | **326** | `REVIEW_REQUIRED` |
| `objbird0` | **185** | `REVIEW_REQUIRED` |
| `objfrog` | **125** | `REVIEW_REQUIRED` |
| **Total** | **1 483** | sur **45 rooms** |

Les 663 occurrences que j'avais annoncées ne couvraient que oiseaux et
papillons ; le vrai total est **1 483**. Les `objmob*` (536 instances) étaient
correctement exclus.

## Correction

Une règle centrale, unique source de vérité :

```python
FAUNA_PREFIXES = ("objmob", "objbmob", "objbfmob", "objbgmob", "objbird", "objbutterfly")
FAUNA_EXACT = {"objbug0", "objfirefly", "objfrog", "objbutterfly0", "objbutterfly1", "objbird0"}

def is_fauna(object_name: str) -> bool:
    return object_name.startswith(FAUNA_PREFIXES) or object_name in FAUNA_EXACT
```

Appliquée aux **deux** endroits : l'exclusion du rendu et l'enregistrement des
occurrences. Les préfixes `objbfmob` / `objbgmob`, absents du filtre d'origine,
sont désormais couverts.

## Validation automatique

`NO_NAME_VILLAGE_ADAPTATION/test_no_baked_fauna.py`, trois gardes :

1. **Familles couvertes** — vérifie que des noms représentatifs *et des
   variantes* (`objbird9`, `objbutterfly7`, `objmobsm999`) sont bien reconnus.
2. **Découverte indépendante** — rescanne l'inventaire par jetons sémantiques ;
   échoue si un objet faune placé n'est pas exclu par le convertisseur.
3. **Artefacts** — vérifie qu'aucun manifest ne déclare de faune rendue.

Les règles sont **lues dans le code du convertisseur** (parsing statique, sans
dépendre de Pillow) : le test suit automatiquement toute évolution.

**Efficacité prouvée** : j'ai réintroduit le bug (retrait de `objbird`/
`objbutterfly` des préfixes) et le test a échoué —
`fauna families no longer covered: ['objbird9', 'objbutterfly7']`. Ma première
version du test ne détectait pas cette régression ; je l'ai renforcée.

## Données de faune conservées

`fauna-occurrences.json` : **2 019 occurrences**, 36 objets, 45 rooms. Pour
chacune : room, objet source, `instance_id`, position source, statut, et
`was_baked_as_decor`.

## Cohérence NNVLife — vérifiée

| | Source | `NNVLife.lua` | |
|---|---:|---:|---|
| `objbird0` dans `rmvillage` | 12 | `source_birds` = 12 | **concorde** |
| `objbutterfly1` dans `rmvillage` | 19 | `source_butterflies` = 19 | **concorde** |

Le casting était donc déjà anticipé côté vie, mais jamais branché — pendant que
le terrain les peignait en dur en parallèle.

**Aucune espèce Pokémon n'est choisie ici**, aucun comportement décidé.

## Reconversion — EXÉCUTÉE ET POUSSÉE

**34 rooms reconverties** avec le filtre corrigé.

| Résultat | Valeur |
|---|---:|
| Rooms reconverties | **34 / 34** |
| Occurrences attendues | **1 483** |
| Occurrences exclues du rendu | **1 483** |
| **Écarts** | **0** |

| Objet | Exclues |
|---|---:|
| `objbutterfly1` | 478 |
| `objbug0` | 369 |
| `objfirefly` | 326 |
| `objbird0` | 185 |
| `objfrog` | 125 |

Chaque instance apparaît comme blocker
`wildlife role <id>:<objet> requires native Pokemon encounter mapping` : elle est
**enregistrée comme donnée**, jamais dessinée.

### Livraison par tranches

Deux réinitialisations du sandbox ayant déjà détruit des heures de travail en
vol, la reconversion commite et pousse **toutes les 10 rooms** :

| Checkpoint | Occurrences | Écarts |
|---|---:|---:|
| 10 / 34 | 493 / 493 | 0 |
| 20 / 34 | 892 / 892 | 0 |
| 30 / 34 | 1 239 / 1 239 | 0 |
| **34 / 34** | **1 483 / 1 483** | **0** |

### Précision sur « 45 rooms »

Le recensement comptait 45 rooms contenant de la faune ; **34 seulement** en
avaient de *baked*. Les 11 autres ne portent que des `objmob*`, déjà exclus par
l'ancien filtre. Les 1 483 occurrences sont toutes traitées.

### Performance — 8,4×

Le profilage a montré que `_premultiply` consommait **836 s sur 1 127 s (74 %)**,
appelé 322 529 fois : `add_image()` ne dédupliquait qu'**après** l'encodage PNG.
La déduplication se fait désormais sur les pixels bruts.

| | Avant | Après |
|---|---:|---:|
| Par room | 11 min 30 | **1 min 23** |
| 34 rooms | ~3 h 30 | **~45 min** |

Sortie vérifiée **byte-identique** : `.rsground`, `.tile`, hash de manifest,
blockers et métriques de collision inchangés.

### Cohérence NNVLife

`rmvillage` : **12 `objbird0`** = `source_birds` 12, **19 `objbutterfly1`** =
`source_butterflies` 19. **Aucune espèce ni comportement décidé.**

## Statut

`RECONVERSION_COMPLETE_0_BAKED_FAUNA`.
