# Pack PMDO 0.8.12 — `cliffdaytest_nuit` & `cliffnordouesttest1_nuit` (Nuages 3 Plans + Mer 8 Phases + Cascades Animés)

## Animations natives PMDO 0.8.12 configurées (zéro script Lua requis)
1. **Nuages nocturnes animés en défilement continu à 3 plans de parallaxe (`RogueEssence.Dungeon.LayeredBG` + `Content/BG/*.dir`)** :
   - **Plan d'horizon (`CLIFF_NUIT_NUAGES_HORIZON.dir`, `1440 × 64 px`)** : cumulus posés pile sur la ligne d'horizon marin (`RepeatX = true`, `BGMovement = (-5, 0)`).
   - **Plan médian (`CLIFF_NUIT_NUAGES_MILIEU.dir`, `1440 × 96 px`)** : cumulus de moyenne altitude (`RepeatX = true`, `BGMovement = (-9, 0)`).
   - **Plan haut (`CLIFF_NUIT_NUAGES_HAUT.dir`, `1440 × 96 px`)** : cumulus éclairés par la lune en haute altitude (`RepeatX = true`, `BGMovement = (-14, 0)`).
2. **Mer nocturne animée 8 phases (`TileLayer.Frames`, `FrameLength = 10` à 60 Hz = `166,67 ms/phase`, boucle `1,333 s`)** :
   - Cycle complet des **8 phases** Chunsoft (`0..7`) en bleu nuit profond continu du haut en bas + reflets d'écume lunaire argent-azur nettement visibles à `1×`.
3. **Cascades, étang et fleurs animés 4 phases (`FrameLength = 10`)** :
   - Étang, cours d'eau et fleurs animés sur `cliffdaytest_nuit.rsground`.
   - Grande cascade `64 × 80 px` (`80` tuiles) animée en 4 frames sur `cliffnordouesttest1_nuit.rsground`.

## Installation recommandée dans PMDO 0.8.12
```bash
python MOD_CLIFF_NORD_NUIT_PMDO/INSTALLER.py "CHEMIN/VERS/PMDO/MODS/votre_mod" --dry-run
python MOD_CLIFF_NORD_NUIT_PMDO/INSTALLER.py "CHEMIN/VERS/PMDO/MODS/votre_mod"
```

## Crédits & Statut
- **Crédits artistiques** : **Palikadude** (`Halcyon`), **Chunsoft / Spike Chunsoft** (PMD Explorers), **meromoonmeri** (`town02` / `projet-pmdo`).
- **Statuts de validation** : `art_approved: false`, `runtime_tested: false`.
