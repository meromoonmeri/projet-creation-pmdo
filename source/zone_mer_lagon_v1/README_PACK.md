# ZME1 — Zone Mer lagon : île de sable au lagon (4:3, PMDO 0.8.12)

Zone de donjon demandée comme « poursuivre les zones », avec des VFX (lave, eau, etc.) GENERES en
s'appuyant sur l'album 908 des fonds animés comme référence, et l'eau animée canoniquement.
Plage d'arrivée au sud, île de sable ronde au centre, lagon tout autour, arche de basalte et cercle
de pierre au nord (décor, isolés par l'eau), jungle et falaises autour. Aucune sortie, aucun warp.

- **Référence** : S01P02A canonique (clairière et mer, *Explorers of Sky*) : `reference/s01p02a_port.png`
  (port PMD-SKY-PMDO-PORT) + vérité ROM pret/pmd-sky (boucle 1200 ticks, bandes de vagues
  horizontales en défilement latéral) + `reference/s01_mer.png` (6 crans témoins).
- **Méthode** : rendu généré référencé, comme les lots 4:3 de la série, avec VFX générés : le générateur
  a reçu le port en référence et a produit le décor complet (lagon magenta), la texture d'eau lagon turquoise à bandes
  de vagues et le sol de sable (`bruts/`, 1200 × 896). L'eau garde sa teinte plage à la luminance canonique (échelle uniforme),
  le sable est calibré sur le décor (offset additif + épaule douce) : aucun pixel du rip ni de la ROM dans
  les calques. Fidélité : distances RGB dans `renders/zone_mer_lagon_v1/manifest.json` (seuil 35).
- **Eau** : texture générée calibrée, animée par dérive latérale de ±8 px + onde progressive
  (3 longueurs d'onde de 96 px par boucle, vers la droite, façon S01) ; boucle de 4 s (48 × 5 ticks)
  exacte, de période 48 réelle (3 tours, impair).
- **Reflets** : 24 reflets calculés qui scintillent sur le lagon (point 1 px ou croix 3 × 3,
  cycle 16) ; boucle exacte.
- **Calques, du bas vers le haut** : sol complet, sable, jungle, rochers (falaises + rochers + troncs
  + arche), eau (48 phases), reflets (48 phases), Top vide dans le Ground. La scène boucle en
  240 ticks (4 s).
- **Marqueurs** : `entrance` (plage sud), `boss` (centre de l'île), `objectif` (nord de l'île, face à
  l'arche). Repères d'édition 16 × 16 px uniquement ; aucun personnage, objet, warp ni sortie.

## Reproduire

```sh
.venv/bin/python source/zone_mer_lagon_v1/build.py
.venv/bin/python -m unittest source.zone_mer_lagon_v1.test_build -v
.venv/bin/python source/zone_mer_lagon_v1/verify.py
.venv/bin/python source/zone_mer_lagon_v1/package.py
```

## Livrables

- `renders/zone_mer_lagon_v1/ZME1_projet_pmdo_0812.zip` : projet Ground, banques `.tile`, index et installeur.
- `renders/zone_mer_lagon_v1/ZME1_calques_png_8px.zip` : calques, animations, poses, masques, ORA, manifeste, aperçu.
- `apercu_zone_mer_lagon_v1.html` : aperçu web autonome animé à la racine.

## Limites et statut

- `art_approved: false` ; `runtime_tested: false`. Aucun test PMDO en jeu.
- Le terrain et l'eau sont générés : ce ne sont pas des tuiles natives certifiées. Seule la luminance de l'eau suit S01P02A (teinte plage demandée) ; les reflets sont calculés.
- Le préfixe **ZME1** continue la série Z des zones (sans collision avec ZCR1/ZPO1/ZMA1) ; le biome, le
  layout et le préfixe restent des choix de travail de l'agent.
