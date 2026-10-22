# Quest PMDO 0.8.12 — Édition Intégrale Sans Git LFS (3639 Cartes — Toutes Branches + Lots 4:3)

Dépôt complet **100 % sans Git LFS (`0` pointeur LFS)** prêt à l'emploi pour **`PMDO 0.8.12`**, réunissant **`3639` cartes Ground** (`2,567` feuilles `.tile`, `219` décors `.dir`, `53,948,419` références de frames vérifiées, `0` feuille manquante, `0` `TexLoc` hors bornes) :

- **Nouveaux ajouts Biome `D17` (*Traversée Cristal*)** :
  - `etx1_entree_traversee_cristal.rsground` — *Entrée Traversée Cristal* (`768 × 576`, `96 × 72` tuiles `8 px`, cycle BPL `19 × 4 = 76` ticks)
  - `ftx1_fin_traversee_cristal.rsground` — *Fin Traversée Cristal — Lac Cristallin* (`768 × 576`, `96 × 72` tuiles `8 px`, cycle BPA polymétrique `12 × 10 = 120` ticks, cul-de-sac nord `20` rangées)
- **Lots précédents inclus** :
  - `40` cartes `cliff_centre_01..10` (*Scène du Réveil* — `Nuit Pleine Lune`, `Aube`, `Crépuscule`, `Jour`, 3 plans de nuages en perspective + eau animée `8` phases + promontoires `Grass Métano`)
  - `cliff_nord` (`cliff_north` + `cliff_north_night`) et l'ensemble des cartes `town02` et des 18 branches.

## Installation rapide dans PMDO 0.8.12

```bash
git clone --depth 1 --branch town02-quest-pmdo-0812-complete https://github.com/meromoonmeri/projet-creation-pmdo.git town02-quest-pmdo
```

Copiez `town02` et `town02_tiles_pack_a..d` dans `PMDO/MODS/` (ou lancez `python3 fusionner_en_un_seul_dossier.py` pour fusionner tous les `Content/Tile` dans `town02/`).
