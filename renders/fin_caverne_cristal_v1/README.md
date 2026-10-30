# FKR1 — Fin Caverne Cristal : Salle des Trois Cristaux (4:3 vaste, 768 × 576, PMDO 0.8.12)

## Nature du livrable

- **Biome canonique** : *Caverne Cristal — Salle des Trois Cristaux* (*Crystal Cave — Three Crystals Chamber*, `D16P31A`, *Pokémon Donjon Mystère : Explorateurs du Ciel*, `pret/pmd-sky@c8073235`).
- **Méthode** : décor généré **référencé** sur la capture ROM `D16P31A.png` (ce ne sont **pas** des tuiles natives certifiées). Cul-de-sac souterrain fermé au nord et sur les flancs, sans sortie ni `Warp`.
- **Animations polymétriques fidèles à la ROM DS (`lcm(76, 116) = 2204 ticks = 36,73 s`)** :
  - `08 veines_cristal` (`19 × 4 ticks = 76 ticks`) : **table RVB exacte** de la **Palette 3** de `d16p31a.bpl` (respiration turquoise des cristaux de parois et de l'autel nord) ;
  - `09 trois_cristaux` (`29 × 4 ticks = 116 ticks`) : **tables RVB exactes** des **Palettes 4, 5 et 6** de `d16p31a.bpl` (cycle chromatique *cyan → indigo-violet → vermillon → chartreuse → cyan* déphasé `+0 / +10 / +19` poses sur les trois grands piliers de cristal facettés Ouest, Est et Centre) ;
  - `10 eclats` (`29 × 4 ticks = 116 ticks`) : 4 poses d'éclats cristallins générées sur `#FF00FF` et purgées de tout halo magenta/violet.
- **Statut honnête** : `art_approved = false`, `runtime_tested = false` (aucun test exécuté dans le moteur PMDO).

## Installation dans un mod PMDO 0.8.12

```bash
python3 INSTALLER.py /chemin/vers/PMDO/MODS/votre_mod
```

Carte Ground : `fkr1_fin_caverne_cristal` (`96 × 72` cases de `8 px`, `TexSize = 1`).
Marqueurs : `entrance` (couloir sud), `boss` (arène centrale) et `objectif` (devant l'autel cristallin nord).
