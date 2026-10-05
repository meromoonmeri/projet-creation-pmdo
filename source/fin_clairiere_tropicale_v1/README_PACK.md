# Fin Clairière tropicale — jour et nuit — PMDO 0.8.12

Projet d'édition de fin de donjon tropicale, livré comme **deux cartes Ground autonomes** : jour et nuit (« Mystic Forest »). Chacune mesure **768 × 576 px**, au ratio 4:3, soit **96 × 72 cases de 8 px**. L'arrivée est au sud, l'arène reste ouverte au centre et le sanctuaire est placé au nord. C'est une base d'édition, pas une aventure raccordée à un donjon.

## Provenance et génération d'image

Les deux illustrations complètes ont été générées avec le générateur d'image en donnant le rip canonique PMD Explorers of Sky **Southern Jungle — D54P32A** comme référence visuelle de texture et de palette. La nuit est une illustration générée séparément, alignée sur le layout jour ; ce n'est pas un simple filtre appliqué au jour. Les deux sous-sols complets ont également été générés séparément avec le rip en référence. Sources, empreintes, tailles, références d'entrée, sélection et normalisation figurent dans `manifest.json` et `source/fin_clairiere_tropicale_v1/generation/`.

Le pipeline segmente ensuite les cartes générées en matières avant leur réduction uniforme à **96 × 72 cases**, quantifie les palettes par matière et encode les calques en banques PMDO de 8 px. La partition géométrique jour est réutilisée pour découper la nuit afin d'aligner exactement les deux layouts ; les couleurs nocturnes viennent bien du brut nuit généré. Les lumières nuit sont un calque d'animation translucide séparé, plafonné à **55/255 d'alpha (21,6 %)**.

**Les pixels, textures, plantes et pierres des cartes ne sont pas des pixels ni des tuiles natifs extraits du jeu.** « Natif PMDO » décrit uniquement le projet technique livré — Grounds sérialisés, banques `.tile`, index fusionnable et installateur — et non la provenance de l'art. Les pierres du jour sont neutralisées en gris chaud sans dominante verte ; celles de nuit en gris-bleu, également sans dominante verte.

## Contenu

- `Data/Ground/fct2_fin_clairiere_tropicale.rsground` : Ground de jour, PMDO 0.8.12.0, `TexSize = 1`.
- `Data/Ground/fct2_fin_clairiere_tropicale_nuit.rsground` : Ground de nuit séparé, `TexSize = 1`.
- `Content/Tile/FCT2_*.tile` et `Content/Tile/FCT2N_*.tile` : **17 banques** de tuiles 8 × 8 pour les deux cartes.
- `Mod.xml` : en-tête de mod modèle, si tu crées un mod dédié.
- `INSTALLER.py` : installateur standard-library-only ; il fusionne les tilesets dans l'index du mod cible et sauvegarde l'ancien index s'il change.
- `manifest.json`, `verification.json` : provenance, structure, mesures, résultats et limites.
- `README.md` : cette notice.

L'archive **ne contient pas** d'`index.idx` autonome : un index partiel pourrait masquer les autres tilesets d'un mod. L'installateur reconstruit l'index en fusionnant les `.tile` livrés avec celui déjà présent.

## Installation dans un mod existant

1. Fermer PMDO et sauvegarder le mod.
2. Extraire toute l'archive dans un dossier temporaire.
3. Simuler l'installation puis l'exécuter (Python 3 standard suffit) :

   ```sh
   python INSTALLER.py "CHEMIN/PMDO/MODS/mon_mod" --dry-run
   python INSTALLER.py "CHEMIN/PMDO/MODS/mon_mod"
   ```

   Sous Windows, `py` peut remplacer `python`. La cible doit contenir le `Mod.xml` du mod ; **ne pas** viser la racine du jeu. L'installateur refuse les fichiers déjà modifiés au lieu de les écraser, fusionne l'index des tilesets et en conserve une sauvegarde si celui-ci change. Il ne remplace pas le `Mod.xml` du mod existant.

4. Relancer PMDO en mode développement, activer le mod, puis ouvrir l'un ou l'autre de ces assets dans l'éditeur Ground : `fct2_fin_clairiere_tropicale` (jour) ou `fct2_fin_clairiere_tropicale_nuit` (nuit).

Pour créer un mod dédié, utilise le `Mod.xml` fourni comme modèle dans son propre dossier, puis extrais le reste de l'archive à côté et lance l'installateur en donnant le chemin du dossier qui contient ce `Mod.xml`.

## Calques et fonctionnement

### Jour — `fct2_fin_clairiere_tropicale`

1. `00 Sol complet` — sous-sol généré, pleine toile.
2. `01 Clairière` — sol praticable extrait de l'illustration jour générée.
3. `02 Ombres` — bande d'ombres conservée séparément.
4. `03 Jungle` — bordure et plantes du décor généré.
5. `04 Roches` — rochers et galets, gris chaud neutralisé.
6. `05 Sanctuaire` — silhouette de pierre au nord, gris chaud neutralisé.
7. `06 Feuilles` — animation calculée en **24 phases**, 5 ticks par phase (120 ticks, soit 2 s à 60 Hz).
8. `07 Canopée avant` — végétation sombre d'avant-plan, dessinée sur `Top = 4`.
9. `08 Top (vide)` — calque d'édition libre.

### Nuit — `fct2_fin_clairiere_tropicale_nuit`

Les couleurs des calques viennent de l'illustration nuit générée séparément, dans une palette Mystic Forest bleu-vert. Le découpage reprend les masques jour pour rester aligné. Les pierres sont corrigées en gris-bleu neutre, sans dominante verte. Les feuilles animées sont générées depuis la végétation de cette image ; `07 Lumières` ajoute des lucioles et un halo doux en animation **24 phases**, à faible opacité. Cette couche distincte reste derrière `08 Canopée avant`. `09 Top (vide)` est le calque libre.

La nuit est une carte autonome, pas un cycle jour/nuit qui bascule automatiquement. Les animations de feuilles et lumières sont calculées pour ce lot, pas reprises d'une animation PMD officielle.

Les collisions de base des deux cartes sont calculées à partir des mêmes masques de clairière et d'ombres ; elles ne valent pas test de navigation dans le moteur. Trois marqueurs de 16 × 16 px sont fournis : arrivée sud, repère de boss au centre et objectif près du sanctuaire. Les contrôles de grille vérifient des passages libres de 2 × 2 cases entre eux. **Aucun warp, destination, événement, acteur, musique ni scénario de boss n'est raccordé.** Vérifier ou retoucher collisions et marqueurs dans PMDO avant d'en faire un niveau jouable.

Les fichiers d'édition sont aussi dans `renders/fin_clairiere_tropicale_v1/` : PNG transparents par calque, animations, masques, poses, documents ORA jour/nuit et aperçus. Ouvre `review/index.html` pour le viewer interactif ; il permet de basculer entre variantes, d'activer les calques, de parcourir les phases et de voir collisions et marqueurs. Les ORA montrent la phase 0 ; les images animées sont séparées dans `animation/feuilles/` et, pour la nuit, `nuit/animation/lumieres/`.

## Validation et limites

`verification.json` rapporte les contrôles exécutés pour **les deux Grounds** : lecture indépendante des en-têtes `.tile`, résolution des offsets et des PNG embarqués ; reconstruction pixel à pixel de chaque calque et des phases animées ; contrôle des dimensions, marqueurs, collisions, chemins calculés et intégrité des deux documents ORA ; essai en dossier temporaire de l'installation, de la fusion d'index, de l'idempotence et du refus de conflit. La fidélité matière jour est mesurée sur les bruts et les calques contre le rip canonique, au seuil strict `<35`. La nuit est volontairement générée dans une palette différente et n'est pas notée par cette mesure ; ses pixels et sa sérialisation sont tout de même vérifiés par reconstruction.

**PMDO/.NET n'est pas installé dans l'environnement de fabrication : aucune carte n'a été ouverte dans le moteur ni dans l'éditeur Ground.** Les vérifications Python ne valent pas un test moteur. Les collisions, le dessin final et les animations doivent encore être confirmés en jeu avant toute publication comme carte jouable.

## Reproduction

Depuis la racine du dépôt, après installation des dépendances (`Pillow`, `numpy`, `scipy`) :

```sh
.venv/bin/python source/fin_clairiere_tropicale_v1/build.py
.venv/bin/python source/fin_clairiere_tropicale_v1/package.py
```

Le second script reconstruit les deux variantes, vérifie le stage et l'archive, puis écrit `renders/fin_clairiere_tropicale_v1/FCT2_JN_fin_clairiere_tropicale_PMDO_0812.zip`. Les illustrations générées, aperçus, rapports et documents ORA se trouvent sous `source/fin_clairiere_tropicale_v1/generation/` et `renders/fin_clairiere_tropicale_v1/` ; le stage technique temporaire est sous `.cache/fin_clairiere_tropicale_v1/`.
