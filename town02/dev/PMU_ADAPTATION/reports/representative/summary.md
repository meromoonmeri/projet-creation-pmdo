# PMU → PMDO — groupe représentatif réel

- **Maps :** 11
- **Grounds :** {'GROUND_GENERATED': 9, 'BLOCKED': 2}
- **Runtime PMDO 0.8.12 :** {'RUNTIME_TESTED': 9, 'NOT_RUN': 2}
- **Revue visuelle :** {'FAIL': 8, 'PASS': 1, 'NOT_APPLICABLE_BLOCKED': 2}
- **Validation finale :** {'BLOCKED': 10, 'RUNTIME_TESTED': 1}
- **Généralisation autorisée :** `False`

## Décision

La méthode a produit de vrais `.rsground` et `.tile`, puis les a chargés dans PMDO 0.8.12 par l’overlay headless d’Agent A avec probes de déplacement libre/bloqué et terminaison bornée. Cependant la revue visuelle a rejeté le vocabulaire automatique sur la majorité des maps : aucune généralisation aux 2 000 maps n’est autorisée tant que les compositions ne préservent pas correctement bâtiments, plans d’eau, relief, hiérarchie et identité spatiale.

Un JSON valide, un Ground chargé et des probes runtime réussies ne suffisent donc pas à produire `VALIDATED`.

## Statuts

| Map | Nom | TexSize | Ground | Runtime | Visuel | Validation | Blockers |
|---|---|---:|---|---|---|---|---:|
| `s10` | Exbel Grasslands | 2 | `GROUND_GENERATED` | `RUNTIME_TESTED` | `FAIL` | `BLOCKED` | 4 |
| `s41` | Destiny Cavern | 1 | `GROUND_GENERATED` | `RUNTIME_TESTED` | `PASS` | `RUNTIME_TESTED` | 2 |
| `s63` | Winden Cliffside | 2 | `GROUND_GENERATED` | `RUNTIME_TESTED` | `FAIL` | `BLOCKED` | 1 |
| `s98` | Archford Coast | 2 | `GROUND_GENERATED` | `RUNTIME_TESTED` | `FAIL` | `BLOCKED` | 2 |
| `s167` | Exbel Underground Network | 1 | `GROUND_GENERATED` | `RUNTIME_TESTED` | `FAIL` | `BLOCKED` | 1 |
| `s301` | Tanren Ruins | 2 | `GROUND_GENERATED` | `RUNTIME_TESTED` | `FAIL` | `BLOCKED` | 3 |
| `s737` | Exbel, Grassroot Town | 1 | `GROUND_GENERATED` | `RUNTIME_TESTED` | `FAIL` | `BLOCKED` | 5 |
| `s1191` | Woodland Entrance (Remake) | 4 | `GROUND_GENERATED` | `RUNTIME_TESTED` | `FAIL` | `BLOCKED` | 1 |
| `s1991` | Winden, Snowbasin Town | 1 | `GROUND_GENERATED` | `RUNTIME_TESTED` | `FAIL` | `BLOCKED` | 3 |
| `s1034` | Frigid Cave | 4 | `BLOCKED` | `NOT_RUN` | `NOT_APPLICABLE_BLOCKED` | `BLOCKED` | 1 |
| `s1810` | Exbel, Grassroot Town | 2 | `BLOCKED` | `NOT_RUN` | `NOT_APPLICABLE_BLOCKED` | `BLOCKED` | 1 |

## Artefacts

- Bundle déterministe : `/home/user/new-era-abyss-to-ascension-V4/PMU_ADAPTATION/reports/representative/representative-candidates.zip`
- SHA-256 : `c2eb97769bb0cfabb1bd0172c495c0465eacab4945cbb0a9cdcca05a390dd943`
- Les PNG du bundle proviennent uniquement du renderer PMDO runtime ; aucun PNG phase 1 n’est une texture ou un layer.
