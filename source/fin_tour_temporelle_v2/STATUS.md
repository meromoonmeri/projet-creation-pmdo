# Statut du chantier `fin_tour_temporelle_v2` (`FTT2`)

- **Lot** : `fin_tour_temporelle_v2`, fin de donjon prolongeant l'entrée `ETT2` (intacte).
  `FTT1` existe sur la branche sœur non fusionnée `arena/52e6a9de` (`exports/`) : rien n'en est
  repris, d'où le préfixe `FTT2`, vérifié libre sur les 10 branches de ce dépôt le 17/10/2026
  (arborescences GitHub, aucun fetch).
- **Préfixe `.tile`** : `FTT2` · **Format** : `4:3` vaste (`768 × 576 px` = `96 × 72` cases de
  `8 × 8 px`, `TexSize = 1`), une seule ambiance.
- **Bruts** : décor nouveau généré avec le décor ETT2 en référence (3 essais, 2 écartés archivés
  dans `bruts/ecartes/`, jamais lus) ; `sol_complet.png` et `nuages_magenta.png` copies
  byte-identiques d'ETT2 (SHA-256 testés). Lois d'animation identiques à ETT2 (constantes
  comparées par test au module ETT2).
- **Fidélité aux cibles Noir & Or / Rouge-Noir (`seuil < 35`)** : dalles `7.4`, muraille `6.9`,
  roche `16.1`, circuits or `18.3`, nuages `1.3`, sol complet `10.1`.
- **Brèches de réalité** : `10` brèches (`5` nuages + `5` rochers), `0 px` sur le chemin praticable.
- **Marqueurs d'une fin** : `entrance = [384, 560]` (sud) → `boss = [384, 280]` (centre d'arène)
  → `objectif = [384, 184]` (au pied du prisme) ; chemins `16 × 16` vérifiés ; aucune sortie
  (praticable limité au bord sud), aucun warp, pas de `donjon_seuil`.
- **Calques / banques** : 13 calques + `Top` vide (`Layer=4`), 13 banques `FTT2_*`, scène 240 ticks.
- **Tests Python** : `14/14` vérifications PASS (`test_build.py` / `verify.py`) ; 4 mutations
  détectées (brèche sur l'arène, circuit non-or, magenta résiduel, boss déplacé au manifeste) ;
  **rebuild byte-identique** sur 183 fichiers (hors ORA/ZIP, horodatages). Dans ce dépôt
  d'extraction, les PNG/WebP/ZIP de `renders/` ne sont pas versionnés (`.gitignore`) ; manifest
  et ORA le sont, et le build régénère le reste.
- **Références ROM** `D29P11A` / `D30P34A` : toujours absentes du checkout, signalées sans
  substitution ; la fidélité ROM n'est donc pas vérifiée.
- **`art_approved`** : `false` · **`runtime_tested`** : `false` (PMDO non lancé ; aperçu servi et
  contrôlé en HTTP, JS vérifié avec Node, pas de navigateur interactif).
