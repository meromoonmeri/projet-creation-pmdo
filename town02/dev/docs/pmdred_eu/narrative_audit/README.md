# PMD Red EU narrative scope audit

Audit read-only de la restitution narrative complète de PMD Red EU dans New Era. Chaque scène, domaine, module de donjon, asset et dépendance possède une classification principale unique ; les autres statuts sont explicitement secondaires.

## Livrables

- [`REPORT.md`](REPORT.md) — verdict et synthèse quantitative ;
- [`SCENE_MATRIX.md`](SCENE_MATRIX.md) / [`matrix.csv`](matrix.csv) — matrice des 133 scènes Ground ;
- [`DUNGEON_CUTSCENES.md`](DUNGEON_CUTSCENES.md) — 26 modules de cinématique de donjon ;
- [`DEPENDENCIES.md`](DEPENDENCIES.md) — Grounds, 27 relations dungeon-backed, systèmes et assets ;
- [`CONFLICTS.md`](CONFLICTS.md) — routes actives et chapitres 1–5 protégés ;
- [`MIGRATION_PLAN.md`](MIGRATION_PLAN.md) — plan ordonné avec gates ;
- [`narrative_scope.json`](narrative_scope.json) — inventaire machine complet ;
- [`source_action_index.json`](source_action_index.json) — actions source ordonnées, textes expurgés ;
- `HASHES.sha256` — intégrité du bundle.

## Reproduction

Préparer :

1. la ROM Europe `(En,Fr,De,Es,It)` SHA-256 `0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd` ;
2. `pret/pmd-red` au commit `bf0092d0e34fd8e49b859a0b5f96f00740faa42d` ;
3. `docs/pmdred_eu/ground_manifest.json`.

Puis :

```bash
python3 tools/audit_pmdred_eu_all_ground_scripts.py /path/to/pmdred-eu.gba \
  --pret-root /path/to/pmd-red \
  --all-stations \
  --manifest docs/pmdred_eu/ground_manifest.json \
  --allow-technical-gaps \
  --report /tmp/pmdred-eu-all-ground-scripts.json \
  --compact

python3 tools/audit_pmdred_eu_narrative_scope.py \
  --pret-root /path/to/pmd-red \
  --eu-script-report /tmp/pmdred-eu-all-ground-scripts.json \
  --output docs/pmdred_eu/narrative_audit
```

Le script ne modifie jamais `Data/`, `Content/`, `RESERVE/` ou `master_zone.json`.
