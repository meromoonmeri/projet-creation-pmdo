# Migration directe des Grounds de donjon — PMD Rouge EU

Cette étape met en réserve 27 candidats PMDO reconstruits depuis les octets de la ROM européenne. Elle **ne remplace aucun Ground actif** : les entrées, événements, musiques et chorégraphies doivent encore être validés directement contre les scripts EU avant promotion.

- ROM : `0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd`
- Descripteurs utilisés : **13,467**
- Descripteurs liés à CANM : **2,666**
- États de tuples PAL bruts (borne exploratoire) : **31,002**
- États visuels GBA exacts avant déduplication inter-descripteur : **30,211**
- Images 8×8 uniques intégrées aux atlas `.tile` : **29,515**
- BMAs comparés à SkyTemple : **201 / 201**

Le planificateur conserve le tick zéro PAL brut, les expirations indépendantes de chaque record CANM et la cadence GBA rationnelle. Les 31 002 tuples de couleurs source se réduisent à 30 211 états réellement affichables après la conversion couleur 5 bits du GBA; cette correction mesurée évite d'encoder des doublons invisibles. Les cellules sont groupées par descripteur et une texture n'est remplacée que lorsque sa clé visuelle change. Les blocs BMA inconnus sont archivés séparément de la collision.

| Ground | Donjon français | Grille | Descripteurs | CANM | PAL brut | États GBA | Atlas | Solides | Données BMA |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| `d01p02` | Petit Bois | 45×42 | 80 | 0 | 80 | 80 | 80 | 1503 | 0 |
| `d02p02` | Grotte Eclair | 45×42 | 127 | 44 | 560 | 530 | 530 | 1440 | 42 |
| `d03p02` | Mt Acier | 57×69 | 1030 | 0 | 1030 | 1030 | 970 | 3456 | 0 |
| `d04p02` | Bois Sinistre | 69×72 | 199 | 0 | 199 | 199 | 197 | 4210 | 0 |
| `d05p02` | Val Silencieux | 45×51 | 109 | 0 | 109 | 109 | 109 | 1539 | 0 |
| `d06p02` | Mt Foudre | 57×57 | 185 | 55 | 1314 | 1231 | 1231 | 2592 | 60 |
| `d06p03` | Mt Foudre-Pic | 57×57 | 879 | 167 | 1321 | 1321 | 1169 | 2613 | 0 |
| `d09p02` | Mt Ardent | 57×57 | 150 | 39 | 419 | 419 | 419 | 2592 | 60 |
| `d09p03` | Mt Ardent-Pic | 69×69 | 972 | 151 | 1335 | 1335 | 1222 | 3022 | 0 |
| `d10p02` | Forêt Givrée | 57×57 | 172 | 54 | 666 | 612 | 612 | 2592 | 60 |
| `d10p03` | Sous-Bois Givré | 66×63 | 825 | 0 | 825 | 825 | 820 | 3478 | 0 |
| `d11p02` | Mt Glacial | 57×57 | 162 | 47 | 290 | 246 | 246 | 2592 | 60 |
| `d11p03` | Mt Glacial-Pic | 63×63 | 1017 | 8 | 1093 | 1093 | 1067 | 3353 | 0 |
| `d12p02` | Mine Magma | 57×57 | 157 | 157 | 2111 | 2039 | 2039 | 2592 | 60 |
| `d12p04` | Mine Magma-Fond | 63×63 | 862 | 364 | 3387 | 3387 | 3376 | 3319 | 0 |
| `d13p02` | Tour Céleste | 57×57 | 171 | 61 | 612 | 503 | 503 | 2592 | 60 |
| `d13p03` | Tour Céleste-Sommet | 69×75 | 989 | 346 | 2797 | 2797 | 2679 | 4425 | 0 |
| `d14p01` | Mer Houleuse | 66×63 | 1250 | 297 | 2792 | 2792 | 2723 | 3290 | 0 |
| `d15p01` | Fosse d'Argent | 69×75 | 1202 | 274 | 4726 | 4726 | 4632 | 828 | 0 |
| `d16p01` | Terres de Feu | 45×45 | 199 | 117 | 675 | 593 | 593 | 1431 | 36 |
| `d17p01` | Terres de Foudre | 48×45 | 197 | 39 | 695 | 672 | 672 | 1503 | 44 |
| `d18p01` | Terres Blizzard | 45×42 | 198 | 47 | 312 | 312 | 312 | 1512 | 99 |
| `d19p01` | Pic Inaccessible | 66×63 | 971 | 0 | 971 | 971 | 936 | 3302 | 0 |
| `d20p01` | Grotte Ouest | 45×42 | 49 | 0 | 49 | 49 | 49 | 810 | 0 |
| `d21p01` | Mts Septentrion | 63×60 | 1035 | 216 | 1035 | 1035 | 1024 | 702 | 120 |
| `d23p01` | Grotte des Voeux | 45×42 | 97 | 0 | 97 | 97 | 97 | 1188 | 0 |
| `d25p01` | Bois Hurlement | 45×42 | 183 | 183 | 1502 | 1208 | 1208 | 1272 | 54 |

## Barrière de promotion

Les candidats sont marqués `Released: false`, sans marqueur central inventé et sans musique supposée. La promotion devra fusionner `animation_callbacks.lua` dans les scripts existants plutôt que les remplacer, puis prouver entrées/sorties, événements, musique, réentrée et nettoyage.
