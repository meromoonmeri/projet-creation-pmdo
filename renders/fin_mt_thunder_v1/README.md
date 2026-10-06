# FMT2 — Fin Mt. Thunder : sommet dans la mer de nuages (4:3, PMDO 0.8.12)

Zone de fin de donjon demandée comme « layout de fin logique : sommet au milieu d'une mer de nuage électrique ».
Arrivée au sud sur la pointe d'une crête de sable qui émerge des nuages, immense arène sommitale ronde au centre,
petit piton rocheux à fente sombre au nord (objectif). Aucune sortie, aucun warp.

- **Référence** : `reference/mt_thunder_gba.png`, la planche GBA de la salle du sommet (`Red Rescue Team`), le même
  fichier que l'entrée EMT1 : plateau de sable jaune pâle, falaises de roche brune, pics, mer de nuages d'orage,
  plus 4 éclairs, l'arc « Flash » et les couleurs « Normal » / « Fading » en bas de planche.
- **Méthode** : rendu généré référencé, comme les lots 4:3 de la série. Le générateur a reçu le rip en référence et
  a produit du premier coup le décor complet et le sol de sable (`bruts/`, 1200 × 896). Fidélité au rip : distances
  RGB moyennes par matière dans `renders/fin_mt_thunder_v1/manifest.json` (seuil 35).
- **Retouche documentée** : deux pastilles noires de génération (42 × 71 px, coins hauts) rebouchées dans le build
  par miroir des colonnes voisines (`patch_corners`). Rien d'autre n'est repeint.
- **Éclairs** : les 4 éclairs et l'arc sont **copiés pixel par pixel de la planche**, avec ses couleurs exactes :
  2 phases « Normal », 2 phases « Fading », puis rien ; l'arc s'allume au pied de l'éclair. Six frappes par boucle
  de 4 s (48 × 5 ticks), placées sur les nuages. Le placement et la cadence sont créés : ce n'est pas l'animation
  officielle.
- **Calques, du bas vers le haut** : sol complet, sable, cailloux, pics, profondeur (fente), falaise, ciel, nuages,
  lueurs (48 phases), éclairs (48 phases), Top vide dans le Ground. La scène boucle en 240 ticks (4 s).
- **Marqueurs** : `entrance` (pointe sud de la crête), `boss` (centre de l'arène), `objectif` (devant la fente du
  piton). Repères d'édition 16 × 16 px uniquement ; aucun personnage, objet, warp ni sortie.

## Reproduire

```sh
.venv/bin/python source/fin_mt_thunder_v1/build.py
.venv/bin/python -m unittest source.fin_mt_thunder_v1.test_build -v
.venv/bin/python source/fin_mt_thunder_v1/verify.py
.venv/bin/python source/fin_mt_thunder_v1/package.py
```

## Livrables

- `renders/fin_mt_thunder_v1/FMT2_projet_pmdo_0812.zip` : projet Ground, banques `.tile`, index et installeur.
- `renders/fin_mt_thunder_v1/FMT2_calques_png_8px.zip` : calques, animations, poses, masques, ORA, manifeste, aperçu.
- `apercu_fin_mt_thunder_v1.html` : aperçu web autonome animé à la racine.

## Limites et statut

- `art_approved: false` ; `runtime_tested: false`. Aucun test PMDO en jeu.
- Le terrain est généré à partir du rip : ce ne sont pas des tuiles natives certifiées.
- Le préfixe **FMT2** évite FMT1, repère posé sur la branche sœur `01a0eaca` (non fusionnée) ; le biome, le layout
  et le préfixe restent des choix de travail de l'agent.
