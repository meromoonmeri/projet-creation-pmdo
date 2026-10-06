# VIL2 — Village Pokémon : place du marché, style Treasure Town (4:3, PMDO 0.8.12)

Second village demandé comme « nouveau layout, découpage fin : halle, maisons, tentes,
structures ». Chemin d'arrivée au sud, place du marché à l'est avec étals à auvents, grande
halle de guilde à tapis rouge au nord-est, deux maisonnettes à l'ouest, tente de cirque,
tipis et dôme de pierre autour, mare à l'ouest, arbres ronds, barrières, falaises et forêt
en bordure. Aucune sortie, aucun warp.

- **Référence** : T00P02/T00P03 canoniques (Treasure Town, *Explorers of Sky*) : rendus de vérité ROM
  pret/pmd-sky (`reference/t00p02_t00.png`, `reference/t00p03_t00.png` ; quelques tuiles invalides
  remplacées par du noir, exclues des mesures).
- **Méthode** : rendu généré référencé, comme les lots 4:3 de la série. Le générateur a reçu les deux
  vérités ROM en référence et a produit le décor complet (mare magenta), le témoin sans maisons
  (recalé (0, 0), jamais exporté), le sol d'herbe et l'eau de mare (`bruts/`, 1200 × 896). L'eau est
  calibrée en palette sur l'eau T00 (offset additif + épaule douce) : aucun pixel ROM dans les
  calques. Fidélité : distances RGB par matière dans `renders/village_pokemon_v2/manifest.json`
  (seuil 35).
- **Eau** : texture générée calibrée à vaguelettes, animée par dérive latérale de ±4 px + onde
  progressive (3 longueurs d'onde de 64 px par boucle) ; boucle de 4 s (48 × 5 ticks) exacte.
- **Pétales** : 12 pétales calculés blancs et roses (losanges 3 × 3) qui dérivent sur la place
  (40 phases puis 8 cachées) ; boucle exacte.
- **Calques, du bas vers le haut** : sol complet, herbe, place, tapis, halle, maisons
  (maisonnettes, dôme, deux étals), tentes (cirque, tipis, deux étals fusionnés au cirque),
  arbres, structures (boutique, barrières, tonneaux, bancs), falaises, eau (48 phases),
  pétales (48 phases), Top vide dans le Ground (pas de couche rochers : pierres menues et
  marchables). Tout le bâti bloque ; la scène boucle en 240 ticks (4 s).
- **Marqueurs** : `entrance` (chemin sud), `boss` (place centrale), `objectif` (devant la porte
  de la halle). Repères d'édition 16 × 16 px uniquement ; aucun personnage, objet, warp ni sortie.

## Reproduire

```sh
.venv/bin/python source/village_pokemon_v2/build.py
.venv/bin/python -m unittest source.village_pokemon_v2.test_build -v
.venv/bin/python source/village_pokemon_v2/verify.py
.venv/bin/python source/village_pokemon_v2/package.py
```

## Livrables

- `renders/village_pokemon_v2/VIL2_projet_pmdo_0812.zip` : projet Ground, banques `.tile`, index et installeur.
- `renders/village_pokemon_v2/VIL2_calques_png_8px.zip` : calques, animations, poses, masques, ORA, manifeste, aperçu.
- `apercu_village_pokemon_v2.html` : aperçu web autonome animé à la racine.

## Limites et statut

- `art_approved: false` ; `runtime_tested: false`. Aucun test PMDO en jeu.
- Le terrain et l'eau sont générés : ce ne sont pas des tuiles natives certifiées. Seule la palette de
  l'eau est calibrée sur T00 ; les pétales sont calculés.
- Le préfixe **VIL2** poursuit la série V des villages ; le biome, le layout et le préfixe restent des
  choix de travail de l'agent.
