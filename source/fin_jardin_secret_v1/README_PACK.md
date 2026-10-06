# FJR1 — Fin Jardin secret : prairie d'arène sous le rayon (4:3, PMDO 0.8.12)

Zone de fin de donjon demandée comme « layout de fin logique : fin jardin avec des feuilles qui tombent etc ».
Arrivée au sud par une allée d'herbe entre les haies, vaste prairie d'arène ronde au centre avec massifs de fleurs,
rochers et arbres ronds sur les côtés, grande souche dorée à marches sous le rayon de lumière verte au nord.
Aucune sortie, aucun warp.

- **Référence** : `reference/secretgarden.png`, le même fichier que les entrées EJS1/EJS2 (jardin secret,
  *Explorers of Sky*). La souche garde ici sa forme classique, sans le temple miniature de Celebi qui appartient
  à l'entrée EJS2 : c'est un choix de l'agent, à confirmer.
- **Méthode** : rendu généré référencé, comme les lots 4:3 de la série. Le générateur a reçu le rip en référence
  et a produit du premier coup le décor complet, le témoin sans objets (recalé (0, 0), jamais exporté) et le sol
  d'herbe (`bruts/`, 1200 × 896). Fidélité au rip : distances RGB moyennes par matière dans
  `renders/fin_jardin_secret_v1/manifest.json` (seuil 35).
- **Feuilles** : 14 feuilles calculées tombent des arbres et des haies sur la prairie en se balançant (2 poses 6 × 4,
  3 tons du feuillage du décor), se posent 6 phases puis s'effacent ; chaque feuille refait la même chute, donc
  la boucle de 4 s (48 × 5 ticks) est exacte.
- **Rayon** : le rayon du rendu, recoloré avec la rampe de 22 couleurs EXACTES du rayon du rip ; il « respire »
  (décalage de ±2 crans, atténué vers les bords).
- **Lucioles** : 10 étincelles aux couleurs EXACTES du rayon du rip (point 1 px ou croix 3 × 3), qui montent de
  la souche dans le rayon et flottent au-dessus des massifs de fleurs.
- **Calques, du bas vers le haut** : sol complet, prairie, herbe, ombres, fleurs, feuilles (48 phases), rochers,
  arbres, souche, marches, profondeur (trou), haies, fond, rayon (48 phases), lucioles (48 phases), Top vide dans
  le Ground. La scène boucle en 240 ticks (4 s).
- **Marqueurs** : `entrance` (allée sud), `boss` (centre de la prairie), `objectif` (devant les marches de la
  souche). Repères d'édition 16 × 16 px uniquement ; aucun personnage, objet, warp ni sortie.

## Reproduire

```sh
.venv/bin/python source/fin_jardin_secret_v1/build.py
.venv/bin/python -m unittest source.fin_jardin_secret_v1.test_build -v
.venv/bin/python source/fin_jardin_secret_v1/verify.py
.venv/bin/python source/fin_jardin_secret_v1/package.py
```

## Livrables

- `renders/fin_jardin_secret_v1/FJR1_projet_pmdo_0812.zip` : projet Ground, banques `.tile`, index et installeur.
- `renders/fin_jardin_secret_v1/FJR1_calques_png_8px.zip` : calques, animations, poses, masques, ORA, manifeste, aperçu.
- `apercu_fin_jardin_secret_v1.html` : aperçu web autonome animé à la racine.

## Limites et statut

- `art_approved: false` ; `runtime_tested: false`. Aucun test PMDO en jeu.
- Le terrain est généré à partir du rip : ce ne sont pas des tuiles natives certifiées. Seules la rampe du rayon
  et les couleurs des lucioles sont des couleurs exactes du rip ; les feuilles sont calculées dans les tons du décor.
- Le préfixe **FJR1** évite FJS (pris par Fin Jungle Sud) et FJS3 (repère de la branche sœur `01a0eaca`) ; le biome,
  le layout et le préfixe restent des choix de travail de l'agent.
