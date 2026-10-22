# Reminiscencia — port Ground PMDO cohérent avec New Era

## Contrat

L'autorité PMDO 0.8.12 `Base/GFXParams.xml` fixe la viewport logique à
**320×240 px** et la collision Ground à **8 px**. Reminiscencia utilise
**640×480 px** et des tuiles de **32 px**. Le port applique donc l'échelle
exacte 1/2 : tuile 16 px, `TexSize=2`, collision 8 px, `EdgeView=Clamp`.
Une vraie zone 20×15 remplit exactement la viewport. Après interprétation de
`MapTemplates.dat`, 121 Maps autonomes satisfont ce cas ; les 339 conteneurs de
templates héritent du viewport de leur donjon et ne sont plus comptés comme de
fausses zones 20×15.

## Livrables

- 552 Grounds dans `conversion/pmdo_candidates/reminiscencia_grounds.zip` ;
- 31 atlas `.tile`, 552 sidecars, 552 previews, une planche et 12 pages ;
- timelines visuelles de 552 Maps et 50 Common Events ;
- 77 assets : 27 panoramas, 19 fogs, 31 Pictures environnementales ;
- 49 animations RGSS utilisées, 902 frames composées ;
- 44 feuilles de props/VFX, 704 frames, 205 contextes ;
- catalogue encyclopédique de 552 zones et 31 tilesets.

| Statut | Nombre |
|---|---:|
| `PMDO_CONVERTED` | 412 |
| `ADAPTATION_REQUIRED` | 139 |
| `UNSUPPORTED` | 1 |

Les adaptations se chevauchent : 69 Maps à passage directionnel partiel
(masque exact en sidecar, blocage conservateur Ground), 29 Maps à dépendances
absentes, 56 Maps à fog et 10 Maps à décor mobile/blend non normal. Map 463
reste expurgée car casting/UI est encodé dans son tileset.

## Visuels et animations

Les 14 panoramas par défaut restent distincts. La passe d'assemblage restaure
aussi les états pilotés par événement : au total, 95 Maps reçoivent désormais
au moins un panorama, fog ou overlay dynamique matérialisé. Les panoramas sont
placés avant les couches Map ; les fogs et overlays après celles-ci.
Les fogs de 56 Maps matérialisent pixels, zoom, opacité et frames après les
décors. `PetalosGIF` garde ses 20 frames de 130 ms, représentées à 8 ticks.
Défilement, blend additif et durée 7,8 ticks restent sidecar-autoritaires et
justifient `ADAPTATION_REQUIRED`.

Les 281 feuilles `Characters` référencées ont été revues par hash : 44 feuilles
de props/VFX sont incluses ; 237 feuilles de casting/Pokémon sont exclues.
171 entités représentatives sur 31 Maps deviennent des couches 16 px. Les 205
contextes gardent pages, orientation, pattern, opacité, blend et mouvement.
`step_anime` suit `anime_count > 18 - move_speed*3` à 60 FPS.

Les 218 affichages de Picture donnent 31 images environnementales ; 52 assets
casting/UI sont exclus sans copie de pixels. Ordre, mouvement et effacement
restent dans les timelines plutôt que d'être arbitrairement superposés à l'état
par défaut. Tons, flashes, shakes, météo, scrolls et attentes sont documentés.
Les 19 expressions visuelles scriptées sont réduites à des appels météo sûrs.
Aucun dialogue, corps de script ou audio n'est exporté.

Les autotiles utilisent `FrameLength=20` à 60 FPS (1/3 s). Les animations RGSS
avancent toutes les 2 frames graphiques, soit 33,333 ms. Chaque cellule garde
pattern, position, zoom, miroir, opacité et blend ; flashes/timings sont séparés.

## Runtime exact

Map 074 « Palmeral » valide le cas 320×240 : chargement, mouvement libre,
blocage et rendu passent dans PMDO 0.8.12 exact. Les quatre familles de fog ont
une preuve distincte : Map002 `Nubes`, Map213 `Submarino`, Map488 `Clouds`,
Map501 `PetalosGIF`. Tous les deltas environnementaux maximaux sont ≤ 1 canal,
l'arrondi admis pour l'alpha prémultiplié PMDO.

## Frontière

Aucune destination runtime, aucun Ground certifié, aucun chapitre 1–5 et aucun
routage historique n'est modifié. Les candidats restent sous
`games/reminiscencia/conversion/` jusqu'à une promotion explicitement séparée.
