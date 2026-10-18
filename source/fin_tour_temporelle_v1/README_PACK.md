# FTT1 — Fin de la Tour Temporelle : sommet et arène de boss

**Interprétation de travail** de la demande qui suit ETT2 : une zone de fin pour la Tour Temporelle. Le lot est une proposition de l’agent, pas une désignation explicitement donnée par l’utilisateur. Format 4:3 vaste, **768 × 576 px**, grille **96 × 72** cases de 8 px, projet cible **PMDO 0.8.12**.

## Direction et composition

- Plateforme suspendue en obsidienne/ardoise, bordure brisée, accès unique au sud, grande arène dégagée au centre, autel temporel fermé au nord, colonnes rompues et mer de nuages rouge-noir.
- Le décor est **généré et référencé** : un échantillon de style extrait du brut ETT2 informe la palette et le traitement des pixels ; la composition FTT1 est nouvelle. Le sol a un brut dédié. Les références MAP_BG D29P11A et D30P34A ont été rendues et consultées visuellement, mais **leur nom de lieu n’est pas vérifié** dans l’index du dépôt et elles n’ont pas été envoyées au générateur.
- Ce n’est ni un relayout natif ni un rip de tuiles PMD. **Aucune tuile native/canonique certifiée n’est revendiquée.**
- Le boss est interprété comme Dialga d’après le contexte de la Tour Temporelle. `boss_dialga` est un simple marqueur d’édition : aucun sprite, acteur ou événement de boss n’est placé.

## Calques (du bas vers le haut)

| Calque | Contenu | Boucle |
|---|---|---:|
| `FTT1_00_CIEL_ABYSSE` | Fond sombre rouge-noir, poussières discrètes | fixe |
| `FTT1_01_SOL_COMPLET` | Dalle ardoise générée, limitée à la surface principale | fixe |
| `FTT1_02_NUAGES_ROUGE_NOIR` | Nuages du décor FTT1, pulsation diagonale douce | 24 × 10 ticks = 240 |
| `FTT1_03_DECOR_SOMMET` | Autel, portail, colonnes, roches, reliefs et lignes d’or | fixe |
| `FTT1_04_CIRCUITS_TEMPORELS` | Onde lumineuse sur les tracés d’or | 24 × 10 = 240 |
| `FTT1_05_CRISTAL_TEMPOREL` | Halo cyan pulsé et éclat en orbite courte autour du cristal nord | 16 × 15 = 240 |
| `FTT1_06_POUSSIERES_TEMPORELLES` | Éclats pixelisés en montée courte | 48 × 5 = 240 |
| `Top` | Calque PMDO vide réservé à l’édition | — |

Une boucle complète vaut **240 ticks (4 s)**. Les PNG par phase sont fournis dans le ZIP de calques ; les scènes de revue servent à contrôler le rendu, pas le moteur PMDO.

## Contrôles et limites

- La segmentation magenta, les dimensions, les masques, les calques et les archives sont testés par `test_build.py`.
- Collision indicative au format 8 px ; passage 16 × 16 vérifié entre `entrance` au sud et `boss_dialga` au centre. Cela ne remplace pas un test dans PMDO.
- `art_approved: false` et `runtime_tested: false`. Le résultat demande une validation artistique et une vérification dans le moteur.
- D29P11A et D30P34A sont identifiés seulement par leurs codes de ressource ; aucune équivalence canonique avec le sommet de la Tour Temporelle n’est affirmée.

## Reproduire et livrables

Depuis la racine du dépôt, avec Pillow, NumPy et SciPy installés dans `.venv` :

```bash
.venv/bin/python source/fin_tour_temporelle_v1/build.py
.venv/bin/python -m unittest source.fin_tour_temporelle_v1.test_build -v
.venv/bin/python source/fin_tour_temporelle_v1/package.py
```

Livrables sous `renders/fin_tour_temporelle_v1/` : `FTT1_projet_pmdo_0812.zip`, `FTT1_calques_png_8px.zip`, ORA, manifeste, masques et revue. L’aperçu interactif est `apercu_fin_tour_temporelle_v1.html`.

Le statut vérifié, les commandes et les réserves sont récapitulés dans [`STATUS.md`](STATUS.md). Le projet Ground PMDO est un **projet d’édition**, pas une aventure jouable. Il n’ajoute ni warp ni acteur. Pour l’installer dans un mod PMDO 0.8.12 existant :

```bash
python3 INSTALLER.py /chemin/vers/le/mod
```

L’installateur cible le dossier qui contient `Mod.xml`, fusionne l’index de tuiles et ne remplace pas les entrées existantes.
