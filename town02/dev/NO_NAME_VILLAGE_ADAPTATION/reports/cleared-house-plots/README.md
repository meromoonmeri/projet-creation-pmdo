# Parcelles NNV libérées — prêtes pour un building PMU choisi manuellement

Rendu de contrôle en lecture seule. Règle appliquée, sans aucune exception :

```
RETIRÉ  : structure NNV + porte/entrée NNV associée + collision de la structure
CONSERVÉ: terrain NNV (ground / groundtex / grass0 / grass1)
CONSERVÉ: arbres, routes, rochers, falaises, plantes, décorations, espaces vides
AJOUTÉ  : rien
```

**Aucun building PMU n'est choisi ni placé.** Aucune porte n'est créée, aucune
tuile inventée, aucun espace vide comblé. La sélection des assets `building`
PMU se fera manuellement, plus tard, par le propriétaire du projet.

## Résultat

| Parcelle | Origine | Taille | Porte retirée | Cellules porte | Collision à libérer | Couverture après |
|---|---|---:|---|---:|---:|---:|
| `objplayerhouse` | (288, 2864) | 1200×984 | `Exit_Door_106508` | 3×3 | 10 752 | 100,000 % |
| `objloggerhouse` | (812, 1400) | 948×840 | `Exit_Door_106510` | 2×3 | 9 799 | 100,000 % |
| `objhunterhouse` | (3820, 1652) | 948×856 | `Exit_Door_106509` | 2×3 | 9 688 | 100,000 % |
| `objcarpenterhouse` | (1324, 52) | 1192×728 | `Exit_Door_106511` | 3×3 | 10 467 | 100,000 % |

Couverture 100,000 % sur chaque parcelle libérée : **aucun trou, aucune tuile
noire, aucun pixel transparent.** Le terrain NNV sous les maisons était déjà
complet et le reste.

## Rendus

- `CLEARED_PLOTS_OVERVIEW.png` — vue d'ensemble avant/après des quatre parcelles.
- `<structure>_before.png` — état actuel (structure + porte).
- `<structure>_cleared.png` — parcelle libérée, terrain NNV intact.

## Ce qui a été retiré exactement

**Structure** — layers `NNV HouseBelow` et `NNV sHouseBelow`, uniquement.

**Porte** — l'entité `Exit_Door_*` (collider 64×64) *et* ses pixels sur le layer
`NNV instances`. Point de vigilance corrigé pendant ce travail : la porte
**n'occupe pas une seule cellule** mais un bloc de 3×3 ou 2×3 cellules de 64 px.
Un premier rendu ne retirait que la cellule d'ancrage et laissait le panneau
visible ; l'emprise réelle a été relevée dans le layer, puis retirée en entier.
Les 118 cellules remplies de `NNV instances` ont été inspectées afin que seules
les cellules de porte soient touchées — aucun autre objet NNV n'est affecté.

**Collision** — les cases 8 px bloquées sous l'emprise de la structure sont
listées et comptées. Elles proviennent du masque solide de la maison actuelle ;
elles disparaissent avec elle et devront être re-dérivées depuis le futur
building PMU, jamais réutilisées telles quelles.

## Réversibilité

Aucun fichier de `Data/` n'est écrit, aucun Ground suivi n'est modifié.
`cleared-house-plots.json` liste, pour chaque parcelle, les layers, les
cellules, l'entité porte, son collider et le nombre de cases de collision
concernées. Le retrait réel peut donc être rejoué ou annulé exactement.

## Reproduire

```bash
cd NO_NAME_VILLAGE_ADAPTATION/tools
python3 render_cleared_house_plots.py --season summer
```

## Statut

`PLOT_CLEARED_READY_FOR_MANUAL_BUILDING_SELECTION`. Non appliqué à la map.
`rmvillage` reste byte-identique ; les quatre saisons, le 1:1 4992×4992, les
animations, particules et les PASS runtime PMDO 0.8.12 sont intacts.
