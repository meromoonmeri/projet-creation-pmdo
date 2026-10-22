# Relict — rendus PNG finaux pour PMDO

**34 rendus générés : 28 Maps canoniques et 6 variantes divergentes.**

Chaque PNG assemble le panorama, les trois couches de Map, les événements-tuiles environnementaux visibles et un état représentatif maximal des overlays/fogs qualifiés. Les effets écran sont répétés sur la vue globale afin de montrer leur apparence sur toute la Map. Aucun acteur source ou New Era n’est rendu.

Planche globale : `games/relict/conversion/pmdo_renders/contact_sheet.png`.

| Rendu | Nom source | Dimensions | Panorama | VFX écran | Tuile-décor |
|---|---|---:|---:|---:|---:|
| `map_001.png` | Intro | 640×480 | 0 | 1 | 0 |
| `map_002.png` | Destiny Tower | 1120×1056 | 0 | 1 | 0 |
| `map_003.png` | Destiny Tower | 640×480 | 0 | 0 | 0 |
| `map_003_variant_mies_conflicted_copy_2025_12_18.png` (variante) | Destiny Tower | 640×480 | 0 | 0 | 0 |
| `map_003_variant_mies_conflicted_copy_2026_01_01.png` (variante) | Destiny Tower | 640×480 | 0 | 0 | 0 |
| `map_004.png` | Refresh | 640×480 | 0 | 0 | 0 |
| `map_005.png` | Respite | 1120×1056 | 0 | 0 | 0 |
| `map_005_variant_mies_conflicted_copy_2025_12_18.png` (variante) | Respite | 1120×1056 | 0 | 0 | 0 |
| `map_005_variant_mies_conflicted_copy_2026_01_01.png` (variante) | Respite | 1120×1056 | 0 | 0 | 0 |
| `map_006.png` | Boss Floor | 1120×1056 | 0 | 0 | 0 |
| `map_006_variant_mies_conflicted_copy_2025_12_18.png` (variante) | Boss Floor | 1120×1056 | 0 | 0 | 0 |
| `map_006_variant_mies_conflicted_copy_2026_01_01.png` (variante) | Boss Floor | 1120×1056 | 0 | 0 | 0 |
| `map_007.png` | Summit | 1120×1056 | 1 | 0 | 0 |
| `map_008.png` | Alabaster Icelands (Ending) | 896×736 | 0 | 0 | 0 |
| `map_009.png` | Events | 640×480 | 0 | 0 | 0 |
| `map_010.png` | Templates | 640×480 | 0 | 0 | 0 |
| `map_011.png` | Tulipanes | 1120×1056 | 0 | 0 | 0 |
| `map_012.png` | Playa | 1120×1056 | 0 | 0 | 0 |
| `map_013.png` | Estrellas | 1120×1056 | 0 | 0 | 0 |
| `map_014.png` | Common | 1120×1056 | 0 | 0 | 0 |
| `map_015.png` | Escenas | 640×480 | 0 | 0 | 0 |
| `map_016.png` | Mt.Coronet (Intro) | 672×960 | 1 | 2 | 0 |
| `map_017.png` | Ancient Retreat (Scene 1) | 960×960 | 0 | 2 | 1 |
| `map_018.png` | Mt.Coronet (Hermit's house) | 800×800 | 0 | 2 | 0 |
| `map_019.png` | Hermit's house (Scene 1) | 800×800 | 0 | 0 | 1 |
| `map_020.png` | Cobalt Coastlands | 960×704 | 0 | 1 | 0 |
| `map_021.png` | Alabaster Icelands (Hermit) | 960×800 | 0 | 2 | 0 |
| `map_022.png` | Alabaster Icelands (Flame Plate) | 960×896 | 0 | 2 | 0 |
| `map_023.png` | Mt.Coronet (Statues) | 1280×960 | 0 | 2 | 0 |
| `map_024.png` | Hermit's Resting Place | 800×800 | 0 | 2 | 0 |
| `map_025.png` | Hermit's house (Scene 2) | 800×800 | 0 | 0 | 0 |
| `map_026.png` | Ancient Retreat (Scene 2) | 960×960 | 0 | 2 | 0 |
| `map_027.png` | Hermit's house (Scene 3) | 800×800 | 0 | 0 | 0 |
| `map_028.png` | Mt.Coronet (Ending) | 672×960 | 1 | 0 | 0 |

## Lecture des labels

- `001` à `028` : Map canonique ;
- suffixe `A` : variante conflictuelle divergente 2025 ;
- suffixe `B` : variante conflictuelle divergente 2026.

## Validation

- résultat : `PMDO_FINAL_RENDER_PASS` ;
- 34/34 fichiers hashés et aux dimensions source ;
- Map 012 byte-identique au rendu environnemental PMDO runtime validé ;
- six tests dédiés PASS, dont une reconstruction byte-identique des 34 PNG ;
- cible visuelle : Ground PMDO `TexSize=4`, pas graphique de 32 px ;
- placements d’acteurs conservés uniquement dans les sidecars, sans pixels de casting.
