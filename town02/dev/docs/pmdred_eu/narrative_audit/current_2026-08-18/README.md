# Validation narrative PMD Red EU — checkout du 2026-08-18

Ce dossier est une **preuve fraîche de lecture/audit**, générée avec la ROM
EU authentifiée et les checkouts techniques restaurés dans `.runtime-cache/`.
Il ne remplace pas le bundle historique de `docs/pmdred_eu/narrative_audit/` et
n'effectue aucune modification in-game.

## Commandes exécutées

```bash
.runtime-cache/test-venv/bin/python tools/audit_pmdred_eu_all_ground_scripts.py \
  .runtime-cache/downloads/pmdred-eu.gba \
  --pret-root .runtime-cache/pmd-red-reference \
  --all-stations \
  --manifest docs/pmdred_eu/ground_manifest.json \
  --allow-technical-gaps \
  --report /tmp/pmdred-all-ground-scripts-current.json \
  --compact

.runtime-cache/test-venv/bin/python tools/audit_pmdred_eu_narrative_scope.py \
  --pret-root .runtime-cache/pmd-red-reference \
  --eu-script-report /tmp/pmdred-all-ground-scripts-current.json \
  --output /tmp/pmdred-narrative-scope-current
```

## Autorités verrouillées

- ROM EU SHA-256 : `0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd`;
- manifeste Ground : `docs/pmdred_eu/ground_manifest.json`, SHA-256
  `02a5d8699ceef50c8195fccedcd455694121983f23869070e5b42b6dfb4e9730`;
- `pret/pmd-red` : commit `bf0092d0e34fd8e49b859a0b5f96f00740faa42d`;
- rapport produit par `audit_pmdred_eu_all_ground_scripts.py` :
  `b027e796c2732673ee559f70e672595896d1c3b51109ef074094e21c0038da15`;
- `narrative_scope.json` :
  `a6713751c538381df58744bf75345177a95169e53c5650385b69d87075344546`;
- `source_action_index.json` :
  `ae6ff917f8e1d4dd6ff9005bafe7ae83a9e4b8bf377cf8c915066309ad0a64fc`;
- `matrix.csv` :
  `2282a6bdcd0203b7d44401b77dddf3a0c5eef751ae638a1cefbb09025839b461`.

## Résultat actuel

- stations demandées : **133** ;
- graphes EU décodés exactement : **69/133** ;
- graphes restants classés explicitement en dépendance technique : **64** ;
- tableaux de commandes : **1 280** ;
- commandes/records EU : **22 825** ;
- blocs texte français complets : **3 073/3 073** ;
- déclarations possédées : **267/267** ;
- racines EU non déclarées/non possédées : **0** ;
- verdict de l'audit narratif : `AUDIT_COMPLETE_NO_IN_GAME_CHANGE` ;
- scènes Ground inventoriées : **133** ;
- scènes narrativement certifiées comme portées : **0**.

Le résultat confirme la frontière déjà documentée : l'audit exhaustif et la
provenance sont à jour, mais les graphes dépendants ne sont pas transformés en
scripts PMDO jouables. Aucun statut `RUNTIME_TESTED`, `CERTIFIED` ou `PROMOTED`
n'est déduit de ce bundle.
