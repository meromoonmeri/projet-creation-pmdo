# Pixel artiste « grounds » — recrutement + méthode de production de qualité

Date : 2026-08-04 — Projet **New Era : Abyss to Ascension V4** (mod PMDO / moteur Rogue Essence)

> **Mise à jour (après examen du dernier commit de `main` — `55860b9 "Devtool"`)**
> Ce commit ajoute le launcher du dev tool (`dev.bat` = `PMDO.exe -dev`),
> la config rapide de l'éditeur (`devConfig` : ZoneChoice/GroundChoice/
> StructChoice/FloorChoice) et les **symboles de debug** du moteur
> RogueEssence + de **RogueEssence.Editor.Avalonia**. Il ne contient pas
> l'exécutable de l'éditeur.
> ⚠️ **Limite d'environnement** : je travaille dans un sandbox Linux sans
> affichage, sans runtime .NET/mono ni libgdiplus — je ne peux pas lancer
> `PMDO.exe -dev` (Windows/GUI Avalonia) ici. En revanche j'opère la
> **même chaîne de fichiers** que cet éditeur : `.rsground` (JSON
> serialisé), planches `.tile`, `index.idx`. La preuve : j'ai rendu
> `belles_plaines` (60×42 cellules, 480×336 px) avec
> `tools/render_ground.py`, et je peux mesurer la qualité de n'importe
> quelle planche avec `tools/mesurer_redondance.py`. Tout ce que je
> produis est donc ouvrable/éditable directement dans RogueEssence Editor
> sur votre machine.

Demande initiale : *« je recherche un pixel artiste capable de se servir du dev tool de PMDO (Rogue Essence) et me fournir des grounds de qualité »*.

Deux sujets à démêler, parce qu'ils n'exigent pas la même chose :

1. **Une personne** qui maîtrise le dev tool (RogueEssence Editor) et produit des grounds de qualité.
2. **Un moyen fiable de produire** ces grounds de qualité dans ce mod — *avec ou sans* cette personne.

Je ne peux pas embaucher un humain à votre place. En revanche je peux (a) vous donner une **annonce de recrutement prête à poster**, (b) vous donner la **méthode de production de qualité** déjà éprouvée dans ce dépôt, et (c) fournir une **planche conceptuelle** pour cadrer la direction artistique.

---

## 1. Le point technique non négociable (à connaître avant de recruter)

Un ground Rogue Essence **n'est pas une image**. C'est une grille de cases, chaque case portant une pile de calques `(planche, coordonnée)`.

- **Taille de tuile** : 24 px (donjon) ; les grounds de surface utilisent un pas de grille de **8 px** (`TexSize`).
- **Une planche `.tile` est une table dédupliquée** : les cases identiques partagent le même offset. C'est *là* que se mesure la vraie qualité (un tileset authentique tourne à ~40–50 % de déduplication), pas dans le nombre de tuiles.
- **L'alpha des planches est prémultiplié** : un PNG standard mal importé produit des halos clairs.
- **Toute planche doit être référencée dans `Content/Tile/index.idx`**, sinon tuile d'erreur affichée.
- Une carte, c'est une **composition de tuiles réutilisées**, pas un tableau peint : sol en 3–4 variantes alternées (rythme visible), bordures/coins/raccords d'autotile, accidents de terrain (rochers, touffes, eau).

La métrique de contrôle est dans `tools/mesurer_redondance.py` (déduplication réelle de la planche). Le rendu de contrôle est dans `tools/render_ground.py`.

**Conclusion documentée du projet** (`docs/CORRECTION_DIAGNOSTIC_TILESET_2026-08-04.md`) : la génération de pixel art PMD authentique échoue — ni en peignant une image entière (rendu volumétrique, ~0 % de déduplication), ni en composant algorithmiquement (damier). Le pixel art PMD authentique est un métier ; c'est précisément pourquoi vous cherchez un artiste.

---

## 2. Annonce de recrutement prête à poster (français)

> **Pixel artiste terrain (grounds) — mod Pokémon Mystery Dungeon Online (PMDO/Rogue Essence)**
>
> Le mod **New Era : Abyss to Ascension** (moteur Rogue Essence / PMDO, style *Explorateurs du Ciel*) recherche un pixel artiste pour produire et/ou adapter des **grounds de surface** de qualité (towns, entrées de donjon, arènes de boss).
>
> **Missions**
> - Construire ou adapter des grounds dans **RogueEssence Editor** (le dev tool de PMDO) : composition de tilesets, calques, collisions, objets et points d'entrée.
> - Créer et/ou adapter des **planches de tuiles** au format Rogue Essence (`.tile`, tuiles 24 px / grille 8 px, autotile, alpha prémultiplié, index `index.idx`).
> - Respecter la direction artistique PMD2 (biomes canoniques, palettes limitées, motifs de sol lisibles et répétés).
>
> **Compétences requises**
> - Maîtrise de **RogueEssence Editor** (grounds, autotiles, calques, collisions, entités).
> - Pixel art PMD/PMD2 : sols, bordures, raccords d'autotile, décor, eau animée.
> - Connaissance du format des planches Rogue Essence (`.tile`, `index.idx`).
>
> **À fournir en candidature** : 2–3 grounds finis jouables (rendu + `.rsground`), montrant transitions de sol, redondance de tuiles saine et collisions correctes. Mention de la version PMDO ciblée.
>
> *(Envoyez aussi le canal : Discord PMDO / RogueEssence, serveur de la communauté, ou formulaire de recrutement que vous souhaitez.)*

---

## 3. La voie fiable de qualité immédiate (sans attendre un recrutement)

Le dépôt a déjà recensé des sources de grounds **authentiques portés sous Rogue Essence**, adaptables puis habillés — c'est ce qui a donné l'arène Regigigas jugée « magnifique ».

| Dépôt | Grounds | Tilesets | Usage |
|---|---|---|---|
| `slothplaysnecro/PMDO-Explorers-Maps` | **82** | 135 | cartes EoS complètes, prêtes (jamais exploité ici) |
| `Minemaker0430/ExplorersOfSkyOrigins` | 95 | 145 | déjà utilisé partiellement |
| `PMDCollab/RawAsset` | — | nombreux | bibliothèque communautaire |
| `Logical321/ProjectEoN` | — | 68 | tilesets supplémentaires |

Workflow existant dans ce dépôt :

```bash
# Importer un ground officiel porté (déjà câblé : entités, index, index.idx)
python3 tools/importer_ground_officiel.py <source> <nom_ground> --apply

# Sinon : convertir un PNG en planche .tile + ground
python3 tools/png2tileset.py ground image.png Nom_Planche sortie.rsground \
        --grid 8 --sol 560,700 --apply

# Contrôler la qualité de la planche (déduplication réelle)
python3 tools/mesurer_redondance.py

# Rendu de contrôle
python3 tools/render_ground.py
```

Puis **habillage dans RogueEssence Editor** : géométrie, collisions, spawners, entités — le travail d'artiste/level-design que l'algorithme ne remplace pas.

---

## 4. Planche conceptuelle fournie

`docs/grounds/concept_tileset_plaine_pmd2.png` — une planche de sol de plaine tempérée (herbe, transitions herbe→terre, terre, décor : rochers, touffes, fleurs, eau/berge) pour cadrer la direction artistique.

⚠️ **Limite honnête** : c'est une **vision/concept**, pas un autotile jouable. L'image générée ne tombe pas sur la grille 24 px (taille mesurée 1774×887, non multiple de 24 ni de 8) et n'a pas les raccords d'autotile nécessaires. Elle sert de référence de palette/ambiance pour le briefing de l'artiste, pas d'asset à importer tel quel.

---

## 5. Ce que je peux faire d'autre

- **Recruter côté humain** : impossible pour moi — mais l'annonce ci-dessus est prête à poster sur le canal que vous voulez.
- **Améliorer un ground existant** : dites-moi *quel* `.rsground` (273 présents) et *quel* problème (sol répétitif, collisions, rendu, trop/peu de déduplication), je peux le diagnostiquer avec les outils du dépôt et proposer un plan de retravail.
- **Produire des assets** : je peux générer d'autres **concepts** de planches (autres biomes : eau, forêt sombre, volcan, désert, glace, grotte…) à partir de `docs/PMD_ART_DIRECTION_REFERENCE.md`, pour nourrir le brief.

Dites-moi si vous voulez que je rédige l'annonce pour un biome précis, que je génère d'autres planches-concept, ou que j'attaque le diagnostic d'un ground précis.
