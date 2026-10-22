# Relict — conversion Ground exhaustive 16 px

Le pilote Map012 validé antérieurement reste intact et sert de référence. Le lot
exhaustif séparé est produit sous `games/relict/conversion/pmdo_candidates/`.

## Contrat New Era

- source RMXP : tuile 32 px ;
- cible RogueEssence : tuile 16 px, `TexSize=2` ;
- viewport logique : 320×240 ;
- collision native : cellules 8 px ;
- bords : `EdgeView=Clamp` ;
- autotiles Relict : 250 ms, soit `FrameLength=15` à 60 ticks/s.

## Résultat

| Élément | Nombre |
|---|---:|
| Maps canoniques | 28 |
| Grounds dans le ZIP déterministe | 28 |
| Atlas mutualisés | 8 |
| Previews et sidecars | 28 + 28 |
| `PMDO_CONVERTED` | 25 |
| `ADAPTATION_REQUIRED` | 3 |
| Maps exactement 320×240 | 6 |

Maps 002, 007 et 014 conservent un masque directionnel partiel `7` dans leur
sidecar et utilisent un blocage Ground conservateur. Aucun masque n'est perdu.
Les six variantes divergentes restent documentées et rendues séparément, mais
ne remplacent pas automatiquement leur Map canonique dans le lot Ground.

La passe d'assemblage restaure les panoramas, fogs et overlays événementiels de
13 Maps. Les Maps 003, 004, 010 et 015 restent des contrôleurs sans layout ;
les vides des Maps 013, 019, 025 et 027 sont intentionnels et conservés. La
Map001 reçoit désormais son overlay de scène au lieu d'un écran entièrement
noir.

Le viewport est choisi par rôle : caméra locale suiveuse avec `Clamp` pour les
grandes zones, cadrage original pour les scènes compactes, aucun viewport
artificiel pour les contrôleurs. Aucun dézoom global n'est appliqué.

## Validation runtime exacte

- Map012 : chargement, mouvement libre, mouvement bloqué et rendu PASS ;
- Map002 : même preuve sur un cas de collision directionnelle adaptée ;
- PMDO 0.8.12 exact ;
- viewport 320×240 ;
- delta environnemental maximal ≤ 1 canal ;
- aucun acteur de fixture dans les preuves suivies.

Aucune destination runtime New Era, aucun Ground certifié et aucun chapitre
historique n'a été modifié.
