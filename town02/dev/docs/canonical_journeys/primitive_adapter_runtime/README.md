# Validation runtime — adaptateurs primitifs PMD Red

**Verdict : `PASS_EXACT_PMDO_0_8_12`.**

Cette preuve charge le module de production dormant
`Data/Script/halcyon/pmdred_eu/CanonicalPrimitiveAdapters.lua` dans
l'exécutable PMDO 0.8.12 verrouillé (SHA-256
`faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327`).
Elle exécute uniquement les cinq primitives dont l'équivalence a été établie
par le registre sémantique :

- `WAIT` dans une coroutine Ground gérée par PMDO ;
- `BGM_FADEOUT` avec conservation de l'opérande en frames ;
- `SET_DIR_WAIT` pour les huit directions, avec remappage symbolique explicite,
  et conservation de la direction pour la valeur source `-1` ;
- `ROTATE_TO` pour les quatre politiques réellement présentes dans le corpus :
  rotation forcée droite/gauche, chemin le plus court par pas d'une direction
  et chemin le plus court par pas de deux directions ;
- `CMD_UNK_92`, désormais identifié, pour ses trois formes canoniques : cible
  relative à deux directions vers la droite/gauche et demi-tour.

Le test confirme aussi le refus fail-closed d'une direction numérique, d'un
opcode non adapté, d'un acteur manquant et d'une politique de rotation non
certifiée. Le `tick_delta` du journal est une
observation du cycle update/draw headless, pas une nouvelle unité de temps ni
un substitut à la preuve 60 Hz issue des deux exécuteurs verrouillés.

## Isolation

Le harness est construit avec le générateur runtime/headless existant d'Agent
A. Il entre seulement dans `pmdred_eu_validation_sink`, Ground synthétique et
ignoré créé par la fixture pour fournir une coroutine moteur. Le candidat de
base nécessaire au constructeur est indexé mais jamais chargé.

Ainsi :

- aucun des 219 Grounds certifiés n'est revalidé ;
- aucun Ground ou Zone de production n'est modifié ;
- aucune route n'est écrite ;
- aucune scène ni aucun parcours n'est déclaré runtime-ready.

## Reproduction

```bash
bash tools/restore_pmdred_eu_validation_runtime.sh

tools/run_pmdred_primitive_adapter_runtime.sh \
  .runtime-cache/pmdred-primitive-adapter-runtime-repro
```

Le runner reconstruit la fixture en create-only, lance l'index PMDO, exécute le
harness dans le runtime exact, attend son événement terminal puis appelle
`tools/validate_pmdred_primitive_adapter_runtime.py`.

## Preuves

- `fixture_manifest.json` — isolation, commits et hashes des scripts injectés ;
- `index.log` — chargement des scripts lors de l'index exact PMDO ;
- `events.jsonl` — séquence structurée des assertions runtime ;
- `runtime.log` — log moteur complet du passage ;
- `validation.json` — verdict machine et périmètre négatif explicite ;
- `evidence_hashes.sha256` — hashes de l'ensemble ci-dessus.
