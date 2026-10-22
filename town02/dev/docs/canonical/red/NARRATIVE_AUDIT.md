# Audit narratif — intégration PMD Red dans New Era

**Statut : audit préalable, aucune cinématique modifiée par ce commit.**

Zones canoniques actives auditées : **9**. Erreurs structurelles : **0**.

## Règles de continuité
- same canonical geography and Ground
- original cinematic positions/choreography retained where source exists
- New Era cast substitutes narrative roles without erasing original historical cast
- legendary stays in canonical dungeon
- Friend Areas are residential unlocks only
- battle rsmap visually matches cinematic Ground
- historical events are memories/testimony, not contradictory present-day replays

## Matrice des chapitres

| Zone | Canon | Chapitre | Segments | Grounds | Fonctions cinématiques détectées |
|---|---|---:|---:|---:|---:|
| `gloomy_forest` | Sinister Woods | 6 | 11 | 4 | 29 |
| `magma_cavern` | Magma Cavern | 7 | 3 | 3 | 5 |
| `waterfall_pond` | Waterfall Pond / Crystal Sanctuary | 8 | 6 | 0 | 0 |
| `sky_tower` | Sky Tower | 10 | 6 | 3 | 10 |
| `wish_cave` | Wish Cave | 12 | 2 | 1 | 5 |
| `mt_blaze` | Mt. Blaze | 12 | 3 | 4 | 9 |
| `frosty_forest` | Frosty Forest | 12 | 3 | 4 | 9 |
| `mt_freeze` | Mt. Freeze | 12 | 2 | 4 | 9 |
| `lapis_cave` | Lapis Cave | 12 | 1 | 2 | 5 |

## Contrats scène par scène

### Chapitre 6 — Sinister Woods
- Conserver D04P01 comme approche et D04P02 comme clairière de confrontation.
- Team Dazzling occupe les rôles dramatiques de Team Meanies; elle ne change ni le lieu ni la géographie.
- Le sauvetage, le mini-boss, la confrontation et les conséquences à Metano doivent former une chaîne sans saut.

### Chapitre 7 — Magma Cavern
- Team ACT est l’équipe originale, vieillie de trente ans.
- Entrée, cœur, fosse et Groudon restent une seule progression.
- La victoire ne doit pas réécrire le climax Aegis Cave du chapitre 5.

### Chapitre 8
- Crystal Sanctuary reste l’arc New Era. Waterfall Pond canonique doit demeurer disponible séparément dans le postgame.

### Chapitres 9–11
- Les arcs Suaire, Lugia/Necrozma et Accusation restent inchangés.
- Sky Tower distingue explicitement le présent New Era de la mémoire du météore/Rayquaza.

### Après le chapitre 11
- Les donjons Red sont ouverts en vagues parallèles; aucun ordre fictif n’est imposé entre les arcs indépendants.
- Moltres, Articuno, Ninetales, Groudon, Rayquaza et Jirachi restent liés à leurs lieux canoniques.

## Lacunes avant implémentation
- Les destinations postgame enregistrées sans ZoneData ne peuvent pas recevoir de cinématique exécutable avant création de leur zone.
- Chaque nouvelle scène doit avoir quatre états : première arrivée, nouvelle tentative, victoire, défaite/repli.
- Chaque boss doit retourner sur le même Ground après le combat et utiliser un `.rsmap` visuellement identique.
- Les 27 Grounds dungeon-backed doivent utiliser les reconstructions ROM corrigées, jamais les anciens placeholders.

## Audit exhaustif PMD Red EU

Ce document historique couvre uniquement les 9 zones actives ci-dessus et ne constitue pas une preuve d’exhaustivité narrative. L’audit intégral des **133 scènes Ground EU**, des **26 modules de cinématique de donjon**, des **219 Grounds certifiés** et des **27 relations dungeon-backed** est publié dans [`docs/pmdred_eu/narrative_audit/README.md`](../../pmdred_eu/narrative_audit/README.md). Il préserve le présent audit et remplace seulement son usage comme verdict global.
