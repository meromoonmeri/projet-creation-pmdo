# Fin du Couloir Violet — Sanctuaire de la Stèle (`FCV4`) — Pack PMDO `0.8.12`

Projet d'édition de carte (fin de donjon sud → nord avec arène du boss et stèle nord, appairée à l'entrée `ECV1` `entree_couloir_violet_sud_nord_v1`) au format **4:3 vaste** (`768 × 576` px = `96 × 72` cases `8 × 8`, `TexSize = 1`).
Référence canonique ROM : `reference/S05P03A.png` (*Couloir rocheux violet* / *Épisode Spécial 5*, extraite depuis `pret/pmd-sky`).
**Ce n'est pas une aventure jouable** : aucun warp, aucun événement de boss n'est câblé.
**Statut honnête** : `art_approved = false`, `runtime_tested = false`.

## Installation dans PMDO `0.8.12`

```bash
python3 INSTALLER.py /chemin/vers/PMDO
```

Puis dans l'éditeur PMDO : **Ground Edit Mode** → ouvrir `fcv4_fin_couloir_violet`.

## Calques (`00` à `12`)

| # | Banque `.tile` | Rôle | Cadence |
|---|---|---|---|
| `00` | `FCV4_00_SOL` | Sol complet mauve marbré (fond plein de sécurité) | fixe |
| `01` | `FCV4_01_SOL` | Sol mauve marbré découpé | fixe |
| `02` | `FCV4_02_OMBRES` | Ombres de contact au pied des parois et blocs | fixe |
| `03` | `FCV4_03_GRAVILLONS` | Petits gravillons posés sur le sol | fixe |
| `04` | `FCV4_04_BLOCS` | Amas de rochers bleu-violet en bordure d'arène | fixe |
| `05` | `FCV4_05_ROCHERS` | Parois de rochers bleu-violet empilés | fixe |
| `06` | `FCV4_06_FALAISE` | Falaises externes striées bleu-indigo sombre | fixe |
| `07` | `FCV4_07_VIDE` | Vide souterrain noir-marine aux angles externes | fixe |
| `08` | `FCV4_08_STELE` | Monolithe / stèle sculptée au fond de l'alcôve nord | fixe |
| `09` | `FCV4_09_LUEURS` | Pulsation mystique lilas-violet sur la stèle nord (couleurs exactes de `S05P03A.png`) | `24 × 5` ticks |
| `10` | `FCV4_10_EBOULIS` | Chutes de 3 gravillons aux pixels et couleurs exacts de `S05P03A.png` | `24 × 5` ticks |
| `11` | `FCV4_11_POUSSIERE` | Nuages de poussière mauve à l'impact des gravillons (4 poses générées) | `24 × 5` ticks |
| `12` | *(Top vide)* | `Layer = 4` (au-dessus des personnages) | fixe |

## Marqueurs posés

- `entrance` : arrivée par le couloir sud (`16 × 16` px).
- `boss` : centre de la grande salle rocheuse (`16 × 16` px).
- `objectif` : parvis nord devant la stèle sculptée (`16 × 16` px).
