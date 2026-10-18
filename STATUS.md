# Statut du chantier `entree_tour_temporelle_sud_nord_v2` (`ETT2`)

- **Lot** : Entrée Tour Temporelle V2 — Noir & Or prismatique ; ETT1 est distincte, absente du checkout et non modifiée par ce build, mais sa conservation complète n'est pas vérifiable ici.
- **Format** : `768 × 576 px`, grille de 8 px (`96 × 72` cases), `TexSize = 1`.
- **Méthode** : reconstruction multicalque depuis les bruts ETT2 sur magenta ; banques `.tile` générées depuis la composition, pas des tuiles PMD natives certifiées.
- **Contrôle de palette** (cibles RGB du brief, seuil `< 35`, pas une comparaison ROM) : `muraille_noire = 0.5`, `nuages_rouge_noir = 1.3`, `dalles_ardoise = 2.7`, `circuits_or = 3.5`, `roche_noire = 8.7`, `sol_complet = 10.1`.
- **Accès** : chemin 16 × 16 vérifié par BFS de `entrance = [384, 560]` (sud) à `donjon_seuil = [376, 208]` (nord) ; `1067` cases praticables et `5845` bloquées.
- **Brèches** : 10 (`5` nuages + `5` rochers), zéro pixel sur le chemin dans les phases contrôlées.
- **Sorties** : `ETT2_projet_pmdo_0812.zip`, `ETT2_calques_png_8px.zip`, ORA, manifest, revues et aperçu interactif `apercu_entree_tour_temporelle_sud_nord_v2.html`.
- **Tests (18/10/2026)** : 1 test `unittest` découvert, exécutant 14 contrôles de sortie ; `verify.py` passe aussi. Le packager rejoue ce test avant de créer les archives.
- **Références manquantes** : les sources ETT1 et les références ROM `D29P11A`/`D30P34A` ne sont pas présentes ; aucune substitution ni validation canonique n'est revendiquée.
- **`art_approved`** : `false` · **`runtime_tested`** : `false`.

## Suite — FTT1, fin de la Tour Temporelle

- Nouveau lot `source/fin_tour_temporelle_v1/`, choisi comme interprétation de « passer à une zone de fin » ; Dialga reste une hypothèse et un marqueur, sans sprite/acteur.
- Fond mis à jour selon la demande : espace noir, nébuleuse rouge-noir générée, pulsations diagonales/spiralées animées en profondeur. Build final réussi en `768 × 576`, masques à la taille cible, neuf calques d'image et cinq animations dans la boucle 240 ticks ; 11 tests passent. Projet Ground, ZIP de calques et aperçu autonome contrôlés par le packager.
- D29P11A/D30P34A consultées comme références visuelles ; noms de lieux non établis. Le générateur n'a reçu que l'échantillon de style ETT2. Pas de pixels natifs/canoniques certifiés.
- Détails et commandes : [`source/fin_tour_temporelle_v1/STATUS.md`](source/fin_tour_temporelle_v1/STATUS.md). `art_approved=false`, `runtime_tested=false`.
