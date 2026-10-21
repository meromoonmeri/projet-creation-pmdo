# Pack PMDO 0.8.12 — Zone `Cliff North` (Métano) & Réseau Complet des Salles Vides de la Guilde

## Contenu du pack
1. **Zone extérieure `cliff_north_metano`** (`138 × 98` tuiles = `1104 × 784 px`)
   - Refonte intégrale sans couture de `./cliffnordouesttest1.rsground` avec la direction artistique Métano (`Metano Town` / `Metano-Altere Transition`).
   - Ciel azur de jour et nuages blancs, mer scintillante entourant le cap ouest et le pied de falaise sud, parois rocheuses continues, plateau herbeux fleuri, arbres Métano hors zone de marche, grand sentier/esplanade sableux est→ouest dégagé, et cascade sud animée sur **4 frames**.
   - Grille de collisions `138 × 98` (`obstacles`) de `cliffnordouesttest1.rsground` intégralement préservée sans modifier le fichier source.

2. **Réseau cohérent des 12 salles souterraines + vestibule RDC de la Guilde (`13` cartes Ground PMDO `0.8.12`)**
   - Silhouettes asymétriques fidèles aux salles de la Guilde Halcyon (`guild_*`), textures unifiées bois chaud / écorce sculptée / mousse / lianes vertes (`Metano Inn`, `Metano Normal Home`, `Metano Grass Home`).
   - **100 % vides** : `0` lit, `0` table, `0` tapis, `0` meuble.
   - **Sol parquet pur** : `0` signe Spinda / spirale.
   - Extérieur `RGBA alpha = 0` propre sans bloc noir ni résidu magenta.

## Crédits & Statut
- Crédits des layouts et références canoniques : **Palikadude / Halcyon** et artistes **Pokémon Mystery Dungeon** d'origine (les rendus générés constituent de nouveaux dessins référencés, distincts des tuiles natives certifiées).
- Statut : `art_approved: false`, `runtime_tested: false` (vérification binaire et structurelle effectuée hors moteur PMDO).
