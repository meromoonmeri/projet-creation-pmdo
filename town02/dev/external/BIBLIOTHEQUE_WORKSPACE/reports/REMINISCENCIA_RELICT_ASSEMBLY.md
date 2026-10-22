# Assemblage final Reminiscencia / Relict

## Cause des zones noires

### Reminiscencia

- 340 entrées `MapTemplates.dat` correspondent à 339 Maps sources.
- Le fichier RMXP les stocke dans un conteneur 20×15, mais le runtime ne lit que
  leur emprise déclarée `w×h`, puis fusionne les cellules non nulles dans une
  des 17 familles de donjon.
- L'ancien candidat exposait le conteneur complet comme une zone autonome : le
  vide hors emprise apparaissait donc en noir.
- 31 Maps sont entièrement vides. 14 sont des contrôleurs logiques ; 18 états
  cinématiques reçoivent un panorama/fog/overlay dynamiquement. Les autres
  scènes noires sont des contrôleurs de casting dont les pixels sont exclus.

### Relict

- Maps 003, 004, 010 et 015 : contrôleurs sans layout, laissés vides.
- Map001 : scène sans tuiles mais avec overlay événementiel, désormais
  matérialisé.
- Maps 013, 019, 025 et 027 : vide de scène intentionnel autour du décor,
  conservé sans remplissage.
- 13 Maps reçoivent maintenant leurs panoramas, fogs ou overlays événementiels.

## Corrections

- chaque MapTemplate utilise exactement son emprise `w×h` autoritative ;
- aucune cellule non nulle n'est supprimée et aucune bordure vide n'est remplie ;
- les Grounds composants ne sont pas présentés comme des zones explorables :
  leur viewport est hérité du donjon qui les assemble ;
- manifeste des 340 templates, de leurs patterns et de leurs familles ;
- manifeste des 17 donjons générés et de leur générateur source ;
- restauration des panoramas, fogs et overlays dynamiques dans l'ordre Ground ;
- previews recalculées depuis le Ground et le vrai atlas PMDO sérialisés ;
- transferts d'événements conservés dans les fiches d'assemblage ;
- contrôleurs logiques explicitement distingués des cartes visuelles.

Deux templates source restent sans appel direct : `QuemStone` et `CuFRoca`.
Ils sont conservés et documentés ; `CuFRoca` partage la Map 528 avec
`CuFRoca1`, effectivement appelée. Aucun contenu n'est supprimé.

## Viewport map par map

Aucune règle de zoom globale n'est appliquée.

| Rôle | Politique |
|---|---|
| composant MapTemplate | aucun viewport autonome ; hérite du donjon assemblé |
| contrôleur logique/cinématique | aucun viewport d'exploration artificiel |
| transition plein écran | scène fixe 320×240, sans dézoom |
| Map ≤ 20×15 | cadrage original à échelle entière et `Clamp` |
| grande zone | caméra locale suivant le joueur, `Clamp`, sans vue globale |
| vide de scène Relict | caméra source conservée, noir intentionnel préservé |

Metano Town n'est donc pas copié : seul son principe d'exploration locale,
caméra suiveuse et absence de dézoom global est repris pour les grandes zones.

## Validation

- 339 Maps composants : dimensions Ground et preview comparées à `w×h` ;
- 17 familles de donjon présentes ;
- 95 Maps Reminiscencia et 13 Maps Relict avec état dynamique matérialisé ;
- aucune Map noire à 100 % hors contrôleur ou vide intentionnel ;
- planches-contact régénérées ;
- runtime PMDO 0.8.12 : Reminiscencia Maps 002, 007, 074, 213 et Relict
  Maps 002, 007, 012 — chargement, déplacement libre, blocage et rendu PASS ;
- aucune destination Ground/Tile certifiée New Era modifiée.
