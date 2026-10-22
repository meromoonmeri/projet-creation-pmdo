# Nova V2.0 — inventaire et candidats Ground PMDO

## Source

- archive Git LFS : `Nova/NovaV2.0.zip` ;
- taille : 284 771 731 octets ;
- SHA-256 : `d564158bae3cf34dd7e0d00b0377ff7059f91d91bb374a23ece4eff7ddfa94cb` ;
- commit BIBLIOTHEQUE : `6963878956ec4c53833c03f26aa6a9aafd17800f` ;
- 167 Maps et 21 Tilesets utilisés ;
- aucun code source exécuté.

## Contrat de dimensions

Nova déclare une viewport source **960×540** (16:9) avec des tuiles de 32 px.
La cible New Era est **320×240** (4:3), collision 8 px. Le candidat conserve le
pixel art et la géométrie par une échelle entière 1/2 : tuile 16 px,
`TexSize=2`, `EdgeView=Clamp`.

La vue source devient 480×270 et ne peut donc pas tenir sans distorsion dans la
vue cible 320×240. Toute Map reste honnêtement `ADAPTATION_REQUIRED` jusqu'au
choix de cadrage/caméra New Era ; aucune déformation non entière n'est appliquée.

## Résultat

| Élément | Nombre |
|---|---:|
| Maps inventoriées | 167 |
| Grounds dans le ZIP déterministe | 167 |
| Atlas partagés | 21 |
| Previews et sidecars | 167 + 167 |
| Maps exactement 320×240 | 24 |
| `ADAPTATION_REQUIRED` | 167 |
| Rendus source complets | 103 |
| Rendus diagnostiques (tuiles non résolues) | 64 |
| Collisions directionnelles partielles | 68 |
| Panoramas matérialisés | 10 |
| Fogs matérialisés | 47 |

Les 64 Maps diagnostiques ne sont pas promouvables : les marqueurs de diagnostic
restent cantonnés aux candidats. Les masques directionnels exacts sont conservés
dans les sidecars et représentés par un blocage Ground conservateur.

## Entités, VFX et cinématiques

- 167 timelines de Map et 9 Common Events expurgés ;
- 14 assets environnementaux : 10 panoramas et 4 fogs ;
- 1 animation RGSS utilisée, 24 frames composées à 20 FPS (50 ms) ;
- 40 feuilles de props/VFX validées par hash, 387 contextes de page ;
- 329 entités représentatives matérialisées sur 84 Maps ;
- 185 feuilles humaines/Pokémon/casting exclues sans copie de pixels ;
- 0 Picture narrative référencée par les Maps ;
- dialogues, corps de scripts et audio exclus.

Les animations de charset utilisent l'autorité Nova
`pattern_time = pattern_update_speed / 4` en secondes. Les mouvements, pages,
conditions, orientations, patterns, opacités, blend et collisions restent dans
les sidecars anonymisés.

## Validation runtime PMDO 0.8.12

- Map003 « Ultra Megalopolis » : chargement, mouvement libre, blocage, rendu et
  viewport 320×240 PASS ;
- Map051 « Ultra Ruin » : mêmes probes avec fog `forest`, PASS ;
- delta environnemental maximal ≤ 1 canal ;
- acteurs de fixture expurgés des preuves suivies.

## Planches et catalogue

- planche cible globale 1120×5712 et 4 pages ;
- catalogue de 167 zones sous `games/nova/zones/` ;
- catalogue de 21 Tilesets sous `games/nova/tilesets/` ;
- manifeste encyclopédique `games/nova/manifests/pmdo_catalog.json` ;
- aucune écriture dans les destinations runtime New Era.
