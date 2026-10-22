# Planches de sélection — choisissez un building par parcelle

Quatre planches, une par parcelle. Chacune montre les **48 candidats
`AUTONOMOUS_CONFIRMED`** posés à leur **taille native** sur le **terrain NNV
réel** de cette parcelle, avec l'identifiant, les dimensions et l'archive source
sous chaque vignette.

| Parcelle | Planche |
|---|---|
| `objplayerhouse` | `SELECTION_objplayerhouse.png` |
| `objloggerhouse` | `SELECTION_objloggerhouse.png` |
| `objhunterhouse` | `SELECTION_objhunterhouse.png` |
| `objcarpenterhouse` | `SELECTION_objcarpenterhouse.png` |

## Verrouillage preview / intégration

**Étage actuel : `PREVIEW_ONLY`.** `rmvillage` n'est pas modifié, aucun fichier
de `Data/` n'est écrit, aucun `.rsground` ni `.tile` n'est produit.

L'état de sélection fait foi dans
`PMU_ADAPTATION/config/nnv-building-selection.json` :

- les quatre parcelles sont `AWAITING_OWNER_SELECTION`, `building: null`,
  `owner_validated: false` ;
- `integration_allowed: false`, déverrouillé uniquement quand les quatre
  parcelles portent `owner_validated: true` ;
- `tiles0_0357` est enregistré comme **préférence exprimée**, pas comme choix :
  il ne devient un choix que lorsque vous l'affectez explicitement à une
  parcelle nommée ;
- `tiles9_0554` et `tiles9_0510` sont marqués **propositions de l'agent, sans
  valeur de décision** ;
- `tiles0_0637` reste `INVALID_REFERENCE`, `tiles8_0055` reste
  `REVIEW_REQUIRED` — aucun des deux n'est utilisable.

Les quatre rendus produits précédemment dans `../` sont des **aperçus**. Ils ne
valent pas sélection.

## Règle appliquée (verrouillée)

```
terrain NNV intact
+ ancienne structure NNV retirée virtuellement
+ porte/entrée NNV retirée virtuellement
+ building PMU autonome posé à taille native
= aperçu
```

Aucun upscale, aucun recolor, aucune interpolation, aucun terrain PMU, aucun
environnement PMU. Le terrain libre autour du building reste du terrain NNV,
volontairement.

## Provenance conservée

`PMU.zip` (SHA-256 `6262927e…`, archive GLS activée) est **l'autorité
canonique**. Une source publique ne la remplace jamais ; elle sert uniquement de
voie de vérification là où les hashes coïncident.

| Archive | Statut | Sélectionnable |
|---|---|---|
| `Tiles0.tile` | `VALIDATED_AGAINST_PMU_ZIP` (hash identique) | oui — 5 structures |
| `Tiles9.tile` | `VALIDATED_AGAINST_PMU_ZIP` (hash identique) | oui — 43 structures |
| `Tiles8.tile` | `REVIEW_REQUIRED` (hash divergent) | non — `PMU.zip` fait autorité |

Les 48 candidats proposés viennent donc exclusivement d'archives byte-identiques
à ce que déclare `PMU.zip`.

## Comment me donner vos choix

Indiquez simplement une association par parcelle, par exemple :

```
objplayerhouse    = tiles0_0357
objloggerhouse    = tiles9_0367
objhunterhouse    = tiles9_0554
objcarpenterhouse = tiles9_0528
```

Pour comparer un candidat en grand avant de trancher :

```bash
cd NO_NAME_VILLAGE_ADAPTATION/tools
python3 place_pmu_building_on_plot.py --plot objloggerhouse --building tiles9_0528 --anchor door
```

## Après validation

Rien de tout cela n'est engagé tant que vos quatre choix ne sont pas explicites.
Une fois verrouillés, dans l'ordre : intégration réelle, puis re-dérivation de la
collision depuis le building retenu, puis association des intérieurs (source
`PMU.zip`), puis runtime PMDO 0.8.12, puis revue visuelle.

## Reproduire

```bash
cd NO_NAME_VILLAGE_ADAPTATION/tools
python3 build_building_selection_board.py --season summer
```
