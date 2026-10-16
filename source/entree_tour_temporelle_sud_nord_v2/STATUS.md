# Statut du chantier `entree_tour_temporelle_sud_nord_v2` (`ETT2`)

- **Lot** : `entree_tour_temporelle_sud_nord_v2` ; ETT1 est un lot distinct, absent du checkout et non modifié par ce build, mais sa conservation complète n’y est pas vérifiable.
- **Préfixe `.tile`** : `ETT2` (unique sur `main` et sur toutes les branches sœurs)
- **Format** : `4:3` vaste (`768 × 576 px` = `96 × 72` cases de `8 × 8 px`, `TexSize = 1`)
- **Fidélité aux cibles Noir & Or / Nuages Rouge-Noir (`seuil < 35`)** : `muraille_noire = 0.5`, `nuages_rouge_noir = 1.3`, `dalles_ardoise = 2.7`, `circuits_or = 3.5`, `roche_noire = 8.7`, `sol_complet = 10.1`
- **Brèches de réalité** : `10` brèches (`5` nuages + `5` rochers), `0 px` sur le chemin praticable
- **Chemin `16 × 16` (`BFS`)** : `entrance = [384, 560]` (sud) → `donjon_seuil = [376, 208]` (nord), `1067` cases praticables, `5845` cases bloquées
- **Tests Python (`test_build.py` / `verify.py`)** : 14 vérifications passent dans le checkout courant après mise à jour des préconditions manquantes ; ETT1 et les références ROM D29P11A/D30P34A restent explicitement signalés absents, donc cela ne valide ni leur conservation ni l’exactitude canonique.
- **Reconstruction locale (16/10/2026)** : `build.py` relancé avec les bruts ETT2 restaurés, puis `package.py` ; 14 calques, animations, ORA, Ground de staging, manifest et revue produits. Aperçu complet `apercu_entree_tour_temporelle_sud_nord_v2.html`, WebP 48 images, ciel rouge-noir, reflets arc-en-ciel et effets prévus.
- **Références absentes** : explicitement marquées indisponibles dans le manifest ; aucune substitution effectuée.
- **`art_approved`** : `false`
- **`runtime_tested`** : `false`
