# Pack 10 Falaises Nord Centrées Nues — Grass Métano · Multicalque · Mer 8 Phases · Jour & Nuit (PMDO 0.8.12)

## Les 10 Versions Incluses (`20` cartes `.rsground` = `10 Jour` + `10 Nuit`, `1200 × 880 px` = `150 × 110` tuiles)
1. **01 — Le Grand Cap Panoramique** (`cliff_centre_01_grand_cap_panoramique_jour` / `_nuit`)
2. **02 — L’Éperon Nord Effilé** (`cliff_centre_02_eperon_nord_effile_jour` / `_nuit`)
3. **03 — La Double Terrasse Centrale** (`cliff_centre_03_double_terrasse_centrale_jour` / `_nuit`)
4. **04 — La Grande Esplanade Royale** (`cliff_centre_04_grande_esplanade_royale_jour` / `_nuit`)
5. **05 — Le Cap aux Deux Ailes** (`cliff_centre_05_cap_anse_jumelle_jour` / `_nuit`)
6. **06 — La Presqu’île à Isthme Étroit** (`cliff_centre_06_presquile_isthme_etroit_jour` / `_nuit`)
7. **07 — Le Cap Vent d’Ouest** (`cliff_centre_07_cap_asymetrique_ouest_jour` / `_nuit`)
8. **08 — Le Cap du Levant** (`cliff_centre_08_cap_asymetrique_est_jour` / `_nuit`)
9. **09 — Les Trois Paliers Ascendants** (`cliff_centre_09_trois_paliers_sacres_jour` / `_nuit`)
10. **10 — Le Bastion Circulaire** (`cliff_centre_10_bastion_circulaire_jour` / `_nuit`)

## Architecture Multicalque
- `BG 00` : Ciel velouté sans bande (`Jour` / `Nuit`)
- `BG 01` : Lune croissante & étoiles (`Nuit`)
- `BG 02..04` : 3 plans de nuages animés en parallaxe continue (`RepeatX = true`)
- `L00` : Mer Chunsoft animée en 8 phases (`FrameLength = 10`)
- `L01` : Parois & piliers rocheux de falaise Métano (calque roche transparent séparé)
- `L02` : Plateau nu `Grass Métano` + liseré de falaise dentelé ocre-doré (calque herbe transparent séparé)
- `L03..05` : 3 calques vides prêts à éditer dans PMDO (`03_Vos_Chemins_Sols`, `04_Vos_Structures_Base`, `05_Votre_Canopee_Avant_Plan` `Draw.Top`)

## Crédits & Statut
- Références graphiques : **Spike Chunsoft** (*Pokémon Mystery Dungeon: Explorers*) & **Palikadude** (*PMDO Halcyon — Metano Town*).
- Statut : bordures et raccords sculptés au générateur spriter + intérieur `Metano_Town_Base`, `art_approved: false`, `runtime_tested: false`.
