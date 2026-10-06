# ZMA1 — Zone Rives de magma : arène volcanique à lacs de lave (4:3, PMDO 0.8.12)

Zone de donjon demandée comme « poursuivre les zones », avec des VFX (lave, eau, etc.) GENERES en
s'appuyant sur l'album 908 des fonds animés comme référence. Arrivée au sud par un chemin
d'obsidienne, arène sombre au centre entre trois lacs de lave (gauche, droite, nord-centre), arche
de basalte à évent incandescent au nord. Aucune sortie, aucun warp.

- **Référence** : D41P41A canonique (fin volcanique, *Explorers of Sky*) : `reference/d41p41a_port.png`
  (port PMD-SKY-PMDO-PORT) + vérité ROM pret/pmd-sky (boucle 130 ticks, cellules jaune-orange
  pulsantes) + `reference/d41_lave.png` (6 crans témoins).
- **Méthode** : rendu généré référencé, comme les lots 4:3 de la série, avec VFX générés : le générateur
  a reçu le port en référence et a produit le décor complet (lacs magenta), la texture de lave et le sol
  d'obsidienne (`bruts/`, 1200 × 896). La lave est calibrée en palette sur la classe lave du port
  (offset additif + épaule douce, teintes froides interdites) : aucun pixel du rip ni de la ROM dans
  les calques. Fidélité : distances RGB dans `renders/zone_magma_rives_v1/manifest.json` (seuil 35).
- **Lave** : texture générée calibrée, animée par dérive circulaire de 6 px + pulsation ±4,5 %
  (plus harmonique spatiale) ; boucle de 4 s (48 × 5 ticks) exacte.
- **Braises** : 48 braises calculées qui montent de 32 px au-dessus des lacs en vacillant (point 1 px
  ou croix 3 × 3), 32 phases visibles puis 16 cachées ; boucle exacte.
- **Calques, du bas vers le haut** : sol complet, sol, rochers (basalte + liserés incandescents +
  évent), lave (48 phases), braises (48 phases), Top vide dans le Ground. La scène boucle en
  240 ticks (4 s).
- **Marqueurs** : `entrance` (chemin sud), `boss` (centre de l'arène), `objectif` (devant l'arche à
  évent). Repères d'édition 16 × 16 px uniquement ; aucun personnage, objet, warp ni sortie.

## Reproduire

```sh
.venv/bin/python source/zone_magma_rives_v1/build.py
.venv/bin/python -m unittest source.zone_magma_rives_v1.test_build -v
.venv/bin/python source/zone_magma_rives_v1/verify.py
.venv/bin/python source/zone_magma_rives_v1/package.py
```

## Livrables

- `renders/zone_magma_rives_v1/ZMA1_projet_pmdo_0812.zip` : projet Ground, banques `.tile`, index et installeur.
- `renders/zone_magma_rives_v1/ZMA1_calques_png_8px.zip` : calques, animations, poses, masques, ORA, manifeste, aperçu.
- `apercu_zone_magma_rives_v1.html` : aperçu web autonome animé à la racine.

## Limites et statut

- `art_approved: false` ; `runtime_tested: false`. Aucun test PMDO en jeu.
- Le terrain et la lave sont générés : ce ne sont pas des tuiles natives certifiées. Seule la palette
  de la lave est calibrée sur D41P41A ; les braises sont calculées.
- Le préfixe **ZMA1** ouvre la série Z des zones ; le biome, le layout et le préfixe restent des choix
  de travail de l'agent.
