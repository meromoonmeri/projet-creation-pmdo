# Quest PMDO 0.8.12 — banc d'essai de la bibliothèque de cartes

Squelette de mod **Quest** minimal et installable, dont la zone
`hub_bibliotheque` déclare chaque carte livrée par `../BIBLIOTHEQUE_MAPS/`
(toutes en `EdgeView=Clamp`, coordonnées bornées). Il sert à ouvrir, visiter
et valider les cartes dans PMDO 0.8.12 avant leur réemploi dans PMDO Destiny.

- `Mod.xml` : Namespace `destiny_bibliotheque`, UUID propre à ce banc d'essai.
  **Ne pas confondre avec le mod PMDO Destiny** : si ce squelette devient un jour
  la vraie quest, y reporter le Namespace/UUID du mod existant *avant* tout test
  partagé — et ne plus jamais les changer ensuite.
- `Data/Zone/hub_bibliotheque.json` : zone sans donjon (`Segments` vide) ;
  `GroundMaps` = cartes livrées, **ajouts en fin de tableau uniquement**.
- `Data/Ground/` : copies clampées (source de vérité : `../BIBLIOTHEQUE_MAPS/grounds/`).
- `Data/Script/destiny_bibliotheque/` : `scriptvars.lua` (toute `SV.*` y est
  déclarée), stubs `ground/<carte>/init.lua` + `strings*.resx` vides, stub de zone.
- `Content/Tile/` : **vide en v1** — voir « Tilesets » ci-dessous.

## Installation (à faire par l'utilisateur, PMDO fermé)

1. Copier le dossier `quest_pmdo_0812/` dans `PMDO/MODS/` (le renommer au besoin,
   `Mod.xml` doit rester à sa racine).
2. Déposer les `.tile` des cartes dans `Content/Tile/` (liste exacte des sheets
   attendues : `../BIBLIOTHEQUE_MAPS/manifest.json`). Les grosses sheets originales
   (`00_ciel`, `v2_promontoire_jour_03`, `terrain*`…) sont dans ton installation
   PMDO actuelle ; les sheets de référence Halcyon restent **en attente d'accord**
   (voir `../BIBLIOTHEQUE_MAPS/PROVENANCE.md`) — sans elles, les tuiles concernées
   s'afficheront en noir/vide, ce qui suffit pour valider le clamp et les bornes.
3. Reconstruire l'index des tilesets du mod :
   `python ../BIBLIOTHEQUE_MAPS/outils/construire_index_tiles.py Content/Tile`
   (ou via les outils développeur de PMDO). Ne jamais importer un `index.idx`
   partiel d'ailleurs.
4. Lancer PMDO 0.8.12 en mode développement, activer le mod, laisser l'éditeur
   réindexer les données (zones) si proposé.

## Premiers contrôles dans l'éditeur (tests en jeu à faire)

- [ ] Le mod apparaît dans la liste des quests, sans erreur de chargement.
- [ ] L'éditeur Ground ouvre `cliffdaytest` et `cliffnordouesttest1` ; vérifier la
      propriété **Edge View = Clamp** et les dimensions (123×99 et 138×98, TexSize 1).
- [ ] Si l'éditeur régénère les `strings.resx`, garder sa version et la reverser ici.
- [ ] Poser un marqueur d'entrée (sud) sur chaque carte, dessiner/vérifier les
      collisions (mer, falaises, structures), aucun personnage hors champ caméra.
- [ ] Entrer sur chaque carte en jeu : la caméra ne doit jamais montrer hors de la
      carte (effet du Clamp) ; marcher jusqu'aux quatre bords.
- [ ] Noter les sheets encore manquantes (tuiles noires) et compléter `Content/Tile`.

## Honnêteté d'état

Squelette **non testé dans le moteur** depuis ce dépôt (pas d'affichage disponible) :
les formats suivent les schémas prouvés du projet (le chargeur réel 0.8.12 a déjà
validé 20 Ground du même outillage — voir `../source/pmdo_runtime/README.md`), mais
l'ouverture en éditeur et le test en jeu restent à faire par l'utilisateur, comme
listé ci-dessus. Les `init.lua` sont inertes (aucune cinématique) : le câblage
narratif viendra carte par carte, avec `require` explicites et `SV.*` déclarées.
