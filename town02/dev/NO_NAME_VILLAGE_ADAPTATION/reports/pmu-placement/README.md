# Placement de buildings PMU sur les parcelles NNV — taille native

Aperçus de placement. Règle appliquée, sans exception :

```
CONSERVÉ : terrain NNV (ground / groundtex / grass0 / grass1)
CONSERVÉ : arbres, chemins, rochers, falaises, plantes, décor, espaces vides
RETIRÉ   : ancienne structure NNV + porte/entrée NNV + collision associée
PLACÉ    : building PMU choisi, à sa TAILLE NATIVE
```

**Le nouveau bâtiment n'a pas à avoir la taille de l'ancien.** Le terrain libre
autour du building est du terrain NNV volontairement conservé, pas un défaut.
Aucun upscale, aucun rescale, aucune interpolation, aucun recolor n'est appliqué
à l'asset PMU.

## Provenance — `PMU.zip` reste l'autorité canonique

`PMU.zip` (SHA-256 `6262927e…`, archive GLS activée) est la **source de
référence** pour les données PMU. Le client public épinglé ne le remplace pas :
il sert uniquement de voie de vérification là où les hashes **coïncident**.

| Archive | Manifeste `PMU.zip` | Client public épinglé | Statut |
|---|---|---|---|
| `Tiles0.tile` | `fba3a3fe47cdce1b…` | `fba3a3fe47cdce1b…` | **identique** — provenance `PMU.zip` vérifiée |
| `Tiles9.tile` | `cece0930de0edc98…` | `cece0930de0edc98…` | **identique** — provenance `PMU.zip` vérifiée |
| `Tiles8.tile` | `25ac58ccd8caef66…` | `e63a982d86279f3d…` | **divergent** — `PMU.zip` fait autorité, assets `REVIEW_REQUIRED` |

Les 48 structures `AUTONOMOUS_CONFIRMED` proviennent donc exclusivement
d'archives dont le contenu est **byte-identique à ce que déclare `PMU.zip`**.
Ce n'est pas une substitution de provenance.

Les 95 candidats issus de `Tiles8.tile` restent `REVIEW_REQUIRED` : non pas
invalides, simplement non vérifiables tant que `PMU.zip` n'est pas lisible. Sa
version restera l'autorité quand l'archive sera accessible. Idem pour les
intérieurs et les `.dat` : ils viendront de `PMU.zip`, pas d'une source publique
de substitution.

## Placements réalisés

| Parcelle | Building | Taille native | Provenance | Position |
|---|---|---:|---|---|
| `objplayerhouse` | `tiles0_0357` | 88×112 | `Tiles0` ✔ `PMU.zip` | (928, 3248) |
| `objloggerhouse` | `tiles0_0367` | 145×170 | `Tiles0` ✔ `PMU.zip` | (1056, 1846) |
| `objhunterhouse` | `tiles9_0554` | 196×230 | `Tiles9` ✔ `PMU.zip` | (3846, 1914) |
| `objcarpenterhouse` | `tiles9_0510` | 212×198 | `Tiles9` ✔ `PMU.zip` | (2126, 474) |

Une structure **différente** par parcelle. Ancrage `door` : le bâtiment est posé
là où le chemin du village menait déjà, la façade alignée sur l'ancienne entrée.

## Choix refusés (garde-fous actifs)

- `tiles0_0637` → **`INVALID_REFERENCE`**. Cet identifiant n'existe pas ; la
  bibliothèque ne contient que 5 structures `Tiles0` (`0357`, `0367`, `0370`,
  `0373`, `0492`). Aucun remplacement arbitraire n'a été fait.
- `tiles8_0055` (190×108) → **`REFUSED / REVIEW_REQUIRED`**, divergence de
  provenance `Tiles8`. Réutilisable dès que `PMU.zip` sera lisible.

L'outil refuse par construction tout candidat non `AUTONOMOUS_CONFIRMED`.

## Portée

- Intérieurs : **hors périmètre**, comme demandé. L'association
  `building → intérieur` sera traitée après votre sélection définitive.
- Collision : non régénérée dans cet aperçu. Elle devra être re-dérivée depuis
  le building retenu, jamais héritée de l'ancienne maison.
- Rien n'est appliqué à la map : aucun fichier de `Data/` écrit, aucun Ground
  suivi modifié. `rmvillage` reste byte-identique.

## Reproduire / essayer un autre asset

```bash
cd NO_NAME_VILLAGE_ADAPTATION/tools
python3 place_pmu_building_on_plot.py --plot objloggerhouse --building tiles0_0370 --anchor door
python3 place_pmu_building_on_plot.py --plot objloggerhouse --building tiles9_0528 --anchor center
```

`--plot` : `objplayerhouse`, `objloggerhouse`, `objhunterhouse`,
`objcarpenterhouse`. `--anchor` : `door` (sur l'ancienne entrée) ou `center`.

## Statut

`NATIVE_PLACEMENT_PREVIEW`. Non appliqué, non certifié, réversible.
