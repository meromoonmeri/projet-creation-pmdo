# EKR1 — Entrée Caverne Cristal (format 4:3 vaste, 768 × 576, PMDO 0.8.12)

## Nature du livrable

- **Biome canonique** : *Caverne Cristal — Entrée* (*Crystal Cave Entrance*, `D16P11A`, *Pokémon Donjon Mystère : Explorateurs du Ciel*, extrait de `pret/pmd-sky@c8073235`).
- **Méthode** : décor généré **référencé** sur la capture ROM `D16P11A.png` (ce ne sont **pas** des tuiles natives certifiées).
- **Animations** :
  - `08 lueur_cristal` (`22 × 4 ticks = 88 ticks`) : **table RVB exacte** de la Palette 8 de `d16p11a.bpl` (ROM DS) appliquée aux facettes cristallines de la bouche et des falaises ;
  - `09 eboulis_poussiere` (`22 × 4 ticks = 88 ticks`) : **3 gravillons découpés dans `D16P11A.png`** + **4 nuages de poussière générés** (purgés de tout magenta/violet).
- **Statut honnête** : `art_approved = false`, `runtime_tested = false` (aucun test exécuté dans le moteur PMDO).

## Installation dans un mod PMDO 0.8.12

```bash
python3 INSTALLER.py /chemin/vers/PMDO/MODS/votre_mod
```

Carte Ground : `ekr1_entree_caverne_cristal` (`96 × 72` cases de `8 px`, `TexSize = 1`).
Marqueurs : `entrance` (arrivée sud) et `donjon_seuil` (devant la bouche nord, sans `Warp` automatique).
