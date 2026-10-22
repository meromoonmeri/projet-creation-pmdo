# Grounds canoniques PMD Red — promotion

Vérification tuile à tuile des Grounds actifs du périmètre face à leurs ports de
la ROM (`RESERVE/red_grounds/` = port 1:1, `RESERVE/pmdred_direct/` = reconstruit
depuis les octets de la ROM EU, animations CANM comprises). Le nom de la planche
de tuiles est neutralisé dans la comparaison : seule la géométrie compte.

**Résultat de l'audit initial : 17 Grounds actifs divergeaient de leur port**
(dont `foret_givree_oree` en 42x40 au lieu de 42x33 et `mont_gele_pied` en 36x40
au lieu de 36x33 — décors retouchés, donc plus ceux de la ROM).

**32 Grounds ont été promus** : géométrie, collisions, décors et entités
proviennent désormais du port canonique ; 26 atlas de tuiles canoniques ont été
copiés dans `Content/Tile`. Les Grounds remplacés sont archivés sous
`RESERVE/legacy_ch6_32/replaced_grounds/`. Seuls le nom affiché et la musique du
mod sont conservés, l'`AssetName` reste celui attendu par les zones.

Régénérer : `python3 tools/promote_red_grounds.py --apply`

| Ground actif | ROM | État | Port utilisé |
|---|---|---|---|
| `abime_tempetes` | `D14P01` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `antre_occident` | `D20P01` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `arc_palier_celeste` | `D13P02` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `arc_parvis_celeste` | `D13P01` | déjà conforme | red_grounds (port 1:1) |
| `arc_tour_ciel_sommet` | `D13P03` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `bois_des_plaintes` | `D25P01` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `bois_sombres_oree` | `D04P01` | déjà conforme | red_grounds (port 1:1) |
| `caverne_trouble_autel` | `D24P02` | déjà conforme | red_grounds (port 1:1) |
| `caverne_trouble_fond` | `D24P01` | déjà conforme | red_grounds (port 1:1) |
| `champ_braises` | `D16P01` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `champ_foudre` | `D17P01` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `champ_vent_boreal` | `D18P01` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `cretes_boreales` | `D21P01` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `d01p02` | `D01P02` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `d02p02` | `D02P02` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `d03p02` | `D03P02` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `d05p02` | `D05P02` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `d06p02` | `D06P02` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `d06p03` | `D06P03` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `d07p02` | `D07P02` | PROMU depuis le port | red_grounds (port 1:1) |
| `d09p02` | `D09P02` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `d09p03` | `D09P03` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `d10p02` | `D10P02` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `d10p03` | `D10P03` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `d11p02` | `D11P02` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `d11p03` | `D11P03` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `foret_givree_oree` | `D10P01` | PROMU depuis le port | red_grounds (port 1:1) |
| `foret_tendre_oree` | `D01P01` | déjà conforme | red_grounds (port 1:1) |
| `fosse_ardente` | `D12P04` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `fosse_argentee` | `D15P01` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `gorge_ardente_coeur` | `D12P02` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `gorge_ardente_porte` | `D12P01` | PROMU depuis le port | red_grounds (port 1:1) |
| `gouffre_muet_bord` | `D05P01` | PROMU depuis le port | red_grounds (port 1:1) |
| `grand_canyon_porte` | `D07P01` | déjà conforme | red_grounds (port 1:1) |
| `grotte_lazuli_fond` | `D08P02` | déjà conforme | red_grounds (port 1:1) |
| `grotte_lazuli_seuil` | `D08P01` | déjà conforme | red_grounds (port 1:1) |
| `grotte_statique_seuil` | `D02P01` | déjà conforme | red_grounds (port 1:1) |
| `mont_cendre_pied` | `D09P01` | PROMU depuis le port | red_grounds (port 1:1) |
| `mont_gele_pied` | `D11P01` | PROMU depuis le port | red_grounds (port 1:1) |
| `mont_grondant_pied` | `D06P01` | déjà conforme | red_grounds (port 1:1) |
| `pic_ferreux_pied` | `D03P01` | déjà conforme | red_grounds (port 1:1) |
| `sanctuaire_voeu` | `D23P01` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `sommet_aurore` | `D19P01` | PROMU depuis le port | pmdred_direct (octets ROM EU) |
| `vallon_perdu` | `D22P01` | déjà conforme | red_grounds (port 1:1) |
