# ZCR1 — Zone Cristal : grotte de cristal D17P11A (4:3, PMDO 0.8.12)

Zone de donjon : grotte de cristal (album 908, preview D17P11A du port PMD-SKY-PMDO-PORT).
Arrivée au sud sur la glace, vaste arène de glace ronde au centre avec Flaques lumineuses,
cristaux et rocailles sur les côtés, grand cristal pâle sur son autel au nord, murs de roche
bleu-gris tout autour. Aucune sortie, aucun warp.

- **Référence** : `reference/d17p11a_port.png` (preview D17P11A, 600 × 480). Attention : le fichier
  `output/Previews/d10p41a.png` du dépôt contient un couloir marron, pas la grotte ; la vraie grotte
  de cristal est `d17p11a.png`.
- **Méthode** : rendu généré référencé, comme les lots 4:3 de la série. Le générateur a reçu la
  référence et a produit du premier coup le décor complet, le sol de glace et la planche VFX
  (`bruts/`, décor et sol 1200 × 896). Pas de témoin : segmentation directe du décor
  (couleurs + géométrie). Fidélité : paires de pixels vérifiées dans
  `renders/zone_cristal_v1/manifest.json` (seuil 35).
- **Scintillements** : 12 étincelles calculées (sprites S 12 × 12 et M 18 × 18 découpés dans
  `vfx.png`, seuil somme ≥ 60, alpha binaire) qui naissent, grandissent et meurent (16 phases
  visibles, décalage propre) sur le grand cristal, les cristaux et les flaques ; la boucle de
  4 s (48 × 5 ticks) est exacte.
- **Lueurs** : halos autour des flaques et du grand cristal, rampe de 8 bleus EXACTS du décor,
  qui « respirent » (décalage de ±2 crans, sinusoïde de période 48).
- **Calques, du bas vers le haut** : sol complet, glace, flaques, murs, cristaux, grand cristal,
  scintillements (48 phases), lueurs (48 phases), Top vide dans le Ground. La scène boucle en
  240 ticks (4 s).
- **Marqueurs** : `entrance` (glace sud), `boss` (centre de l'arène), `objectif` (devant le grand
  cristal). Repères d'édition 16 × 16 px uniquement ; aucun personnage, objet, warp ni sortie.

## Reproduire

```sh
.venv/bin/python source/zone_cristal_v1/build.py
.venv/bin/python -m unittest source.zone_cristal_v1.test_build -v
.venv/bin/python source/zone_cristal_v1/verify.py
.venv/bin/python source/zone_cristal_v1/package.py
```

## Livrables

- `renders/zone_cristal_v1/ZCR1_projet_pmdo_0812.zip` : projet Ground, banques `.tile`, index et installeur.
- `renders/zone_cristal_v1/ZCR1_calques_png_8px.zip` : calques, animations, poses, masques, ORA, manifeste, aperçu.
- `apercu_zone_cristal_v1.html` : aperçu web autonome animé à la racine.

## Limites et statut

- `art_approved: false` ; `runtime_tested: false`. Aucun test PMDO en jeu.
- Le terrain est généré à partir de la référence : ce ne sont pas des tuiles natives certifiées. La rampe
  des lueurs reprend des bleus exacts du décor ; les étincelles sont découpées dans la planche VFX générée.
- Le préfixe **ZCR1** est libre dans le dépôt ; le biome, le layout et le préfixe restent des choix de
  travail de l'agent.
