# VIL1 — Village Pokémon : place à la mare, style Treasure Town (4:3, PMDO 0.8.12)

Grand layout de village demandé comme « village pokémon, textures canoniques, maisons style
T00P02/T00P03, en plusieurs layers ». Chemin d'arrivée au sud, place de sable ronde à la mare au
centre, grande halle de guilde à tapis rouge au nord, tentes roses et vertes et échoppes de bois
autour, arbres ronds, barrières et étals, falaises et forêt en bordure. Aucune sortie, aucun warp.

- **Référence** : T00P02/T00P03 canoniques (Treasure Town, *Explorers of Sky*) : rendus de vérité ROM
  pret/pmd-sky (`reference/t00p02_t00.png`, `reference/t00p03_t00.png` ; quelques tuiles invalides
  remplacées par du noir, exclues des mesures).
- **Méthode** : rendu généré référencé, comme les lots 4:3 de la série. Le générateur a reçu les deux
  vérités ROM en référence et a produit le décor complet (mare magenta), le témoin sans maisons
  (recalé (0, 0), jamais exporté), le sol d'herbe et l'eau de mare (`bruts/`, 1200 × 896). L'eau est
  calibrée en palette sur l'eau T00 (offset additif + épaule douce) : aucun pixel ROM dans les
  calques. Fidélité : distances RGB par matière dans `renders/village_pokemon_v1/manifest.json`
  (seuil 35).
- **Eau** : texture générée calibrée à vaguelettes, animée par dérive latérale de ±4 px + onde
  progressive (3 longueurs d'onde de 64 px par boucle) ; boucle de 4 s (48 × 5 ticks) exacte.
- **Pétales** : 12 pétales calculés blancs et roses (losanges 3 × 3) qui dérivent sur la place
  (40 phases puis 8 cachées) ; boucle exacte.
- **Calques, du bas vers le haut** : sol complet, herbe, place, tapis, maisons, arbres, bois
  (échoppes et barrières), falaises, eau (48 phases), pétales (48 phases), Top vide dans
  le Ground (pas de couche rochers : pierres menues et marchables). La scène boucle en
  240 ticks (4 s).
- **Marqueurs** : `entrance` (chemin sud), `boss` (place devant la mare), `objectif` (devant la porte
  de la halle). Repères d'édition 16 × 16 px uniquement ; aucun personnage, objet, warp ni sortie.

## Reproduire

```sh
.venv/bin/python source/village_pokemon_v1/build.py
.venv/bin/python -m unittest source.village_pokemon_v1.test_build -v
.venv/bin/python source/village_pokemon_v1/verify.py
.venv/bin/python source/village_pokemon_v1/package.py
```

## Livrables

- `renders/village_pokemon_v1/VIL1_projet_pmdo_0812.zip` : projet Ground, banques `.tile`, index et installeur.
- `renders/village_pokemon_v1/VIL1_calques_png_8px.zip` : calques, animations, poses, masques, ORA, manifeste, aperçu.
- `apercu_village_pokemon_v1.html` : aperçu web autonome animé à la racine.

## Limites et statut

- `art_approved: false` ; `runtime_tested: false`. Aucun test PMDO en jeu.
- Le terrain et l'eau sont générés : ce ne sont pas des tuiles natives certifiées. Seule la palette de
  l'eau est calibrée sur T00 ; les pétales sont calculés.
- Le préfixe **VIL1** ouvre la série V des villages ; le biome, le layout et le préfixe restent des
  choix de travail de l'agent.
