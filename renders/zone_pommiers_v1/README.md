# ZPO1 — Zone Pommiers : verger D05P11A (4:3, PMDO 0.8.12)

Zone de donjon : bois aux pommes (album 908, preview D05P11A du port PMD-SKY-PMDO-PORT).
Arrivée au sud sur le chemin de sable, clairière ronde au centre, pommiers chargés de pommes
rouges des deux côtés, rochers et massifs de fleurs dans l'herbe, arche de pierre au nord entre
deux grands pommiers. Aucune sortie, aucun warp.

- **Référence** : `reference/d05p11a_port.png` (preview D05P11A, 552 × 408).
- **Méthode** : rendu généré référencé, comme les lots 4:3 de la série. Le générateur a produit le
  décor complet du premier coup ; le sol d'herbe a demandé 4 essais (3 vides avec la référence,
  conforme sans référence) ; la planche VFX est conforme du premier coup (`bruts/`, décor et sol
  1200 × 896). Pas de témoin : segmentation directe du décor (couleurs + géométrie). Fidélité :
  paires de pixels vérifiées dans `renders/zone_pommiers_v1/manifest.json` (seuil 35).
- **Pommes** : 8 pommes calculées qui tombent des pommiers sur l'herbe en se balançant (2 poses
  8 × 8 découpées dans le décor, couleurs exactes), se posent 6 phases puis s'effacent ; chaque
  pomme refait la même chute, donc la boucle de 4 s (48 × 5 ticks) est exacte.
- **Pollen** : 12 grains calculés (8 points dorés qui montent, 4 pétales qui descendent en se
  balançant), sprites découpés dans `vfx.png` (seuil somme ≥ 60, alpha binaire).
- **Calques, du bas vers le haut** : sol complet, chemin, herbe, fleurs, rochers, pommiers, arche,
  pommes (48 phases), pollen (48 phases), Top vide dans le Ground. La scène boucle en 240 ticks (4 s).
- **Marqueurs** : `entrance` (chemin sud), `boss` (centre de la clairière), `objectif` (devant
  l'arche). Repères d'édition 16 × 16 px uniquement ; aucun personnage, objet, warp ni sortie.

## Reproduire

```sh
.venv/bin/python source/zone_pommiers_v1/build.py
.venv/bin/python -m unittest source.zone_pommiers_v1.test_build -v
.venv/bin/python source/zone_pommiers_v1/verify.py
.venv/bin/python source/zone_pommiers_v1/package.py
```

## Livrables

- `renders/zone_pommiers_v1/ZPO1_projet_pmdo_0812.zip` : projet Ground, banques `.tile`, index et installeur.
- `renders/zone_pommiers_v1/ZPO1_calques_png_8px.zip` : calques, animations, poses, masques, ORA, manifeste, aperçu.
- `apercu_zone_pommiers_v1.html` : aperçu web autonome animé à la racine.

## Limites et statut

- `art_approved: false` ; `runtime_tested: false`. Aucun test PMDO en jeu.
- Le terrain est généré à partir de la référence : ce ne sont pas des tuiles natives certifiées. Les pommes
  reprennent des couleurs exactes du décor ; le pollen est découpé dans la planche VFX générée.
- Le préfixe **ZPO1** est libre dans le dépôt ; le biome, le layout et le préfixe restent des choix de
  travail de l'agent.
