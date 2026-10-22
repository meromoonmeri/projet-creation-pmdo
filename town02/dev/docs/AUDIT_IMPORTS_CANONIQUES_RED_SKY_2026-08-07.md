# Audit des imports canoniques Red / Sky — 2026-08-07

## Sources de vérité lues

- `docs/MANIFESTE_CONVERSION_SKY.md`
- `docs/pmdred_extraction_tracabilite.md`
- `docs/INVENTAIRE_AEGIS_CAVE_VS_RUINES.md`
- `docs/INVENTAIRE_SKY_TOWER_VS_CH10.md`
- réserves `RESERVE/sky_grounds`, `RESERVE/sky_tiles`, `RESERVE/red_grounds`, `RESERVE/red_tiles`

## Inventaire physique

- 467 grounds Sky convertis en réserve ;
- 245 grounds Red convertis en réserve ;
- 51 grounds actifs ou catalogués portent explicitement une provenance Red/Sky dans leurs métadonnées.

## Conforme

### Aegis Cave

- identifiant technique `cloven_ruins` conservé pour les sauvegardes ;
- nom public `Aegis Cave` ;
- donjon final du chapitre 5 ;
- 8 segments dans l’ordre canonique : Ice → Regice → Rock → Regirock → Steel → Registeel → Pit → Regigigas ;
- arènes présentes : `cloven_ruins_regice`, `cloven_ruins_regirock`, `cloven_ruins_registeel`, `sanctuaire_titans` ;
- puzzle Zarbi et pierres présent ;
- musique Aegis Cave sur les secteurs.

### Sky Tower

- triptyque Red D13P01/D13P02/D13P03 présent sous :
  - `parvis_celeste` ;
  - `palier_celeste` ;
  - `tour_ciel_sommet` ;
- grounds et `.rsmap` déclarés dans `sky_tower` ;
- boss final Rayquaza.

## Non conforme

### 1. Wish Cave détournée vers Diancie — bloquant

`sanctuaire_voeu` provient de PMD Red D23P01, Wish Cave/Jirachi. Le manifeste le réserve explicitement à la salle finale de Wish Cave.

Il est pourtant branché dans `waterfall_pond`, le Sanctuaire de Cristal de Diancie :

- comme `GroundMaps` ;
- comme `.rsmap` de boss ;
- comme relais narratif utilisé à plusieurs étapes.

Ce branchement détruit simultanément l’identité de Wish Cave et celle du Sanctuaire de Cristal. Il faut créer/restaurer des assets propres à Diancie, migrer tous les appels, puis rendre `sanctuaire_voeu` à Wish Cave/Jirachi.

### 2. Treasure Town complète non restituée

Le manifeste impose de remplacer `bourg_comptoir`, copie partielle 144×63, par l’import complet Sky `sky_t01p01a` 84×63.

Les fichiers sont présents :

- `RESERVE/sky_grounds/sky_t01p01a.rsground` ;
- `RESERVE/sky_tiles/sky_t01p01a_Base.tile`.

Le remplacement ne peut pas être un simple écrasement : l’import ne possède qu’un marqueur d’entrée, tandis que la carte actuelle porte PNJ, boutiques et connexions vers Cap Sharpedo, Dojo Ossatueur et Carrefour. Les entités doivent être replacées sur des cellules marchables de la géométrie canonique, puis les scripts Ch11 doivent être testés.

## Garde-fou ajouté

`tools/audit_imports_canoniques.py` contrôle désormais :

- identité publique et ordre des arènes d’Aegis Cave ;
- triptyque canonique de Sky Tower ;
- présence de Treasure Town complète dans la réserve ;
- absence de détournement de Wish Cave/Jirachi.

État initial : **1 erreur bloquante, 1 avertissement**.

## Portée confirmée par l’auteur

À partir de la fin du chapitre 5 et du début du chapitre 6, l’architecture entière doit suivre le principe de paquet canonique : Ground(s) et donjon JSON correspondant, avec leurs salles, tables, mécaniques, boss, musique et connexions. Les imports ne sont pas une banque de décors.

L’auditeur automatique classe désormais quatre croisements comme erreurs :

1. Wish Cave/Jirachi → `waterfall_pond`/Diancie ;
2. Sinister Woods D04P01 → `gloomy_forest`/Zeraora ;
3. Northwind Field/Articuno D18P01 → Mont Venteux/Tornadus ;
4. Poison Swamp Friend Area H12P01 → `poisonous_forest`.

## Ordre de réparation

1. Libérer `sanctuaire_voeu` du chapitre 8 et créer une vraie arène Diancie.
2. Séparer Sinister Woods de `gloomy_forest` et restaurer le donjon canonique associé.
3. Rendre Northwind Field à Articuno et créer/restaurer une arène propre à Tornadus.
4. Rendre Poison Swamp à son rôle canonique et créer une identité propre au marais New Era.
5. Restituer Treasure Town complète en recalant les entités et connexions.
6. Auditer chaque autre Ground actif contre son lieu source avant branchement.
7. Ne jamais brancher automatiquement les 712 cartes de réserve.
