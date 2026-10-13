# WORKFLOW — Création de maps PMDO multicalques 4:3 (`768 × 576`)

Ce document synthétise le workflow de création, découpe multicalque, animation en boucle fermée, vérification d'accessibilité `16 × 16` et empaquetage PMDO `0.8.12.0`.

1. **Format et grille native** : `768 × 576 px` (`96 × 72` cases de `8 × 8 px`, `TexSize = 1`).
2. **Pile de calques** : `00_sol` (tapis complet `768 × 576`), `01_relief` (parois/arbres/falaises/colonnades), `02_couronnes` (éléments de décor pur sans artefact ni objet rapporté), `03_animation` (boucle fermée), + `04 Vos elements avant-plan (Top)` (`Layer = 4`).
3. **Marqueurs et BFS `16 × 16`** :
   - `entree_*` : `entrance` au sud et `donjon_seuil` au nord.
   - `fin_*` : `entrance` au sud, `boss` au centre de l'arène, `objectif` au nord (aucune sortie, aucun warp, aucun artefact).



## Lots 4:3 (`768 × 576`, `96 × 72` cases `8 px`) — Pur décor naturel/architectural sans artefact ni structure en fin de zone

Suite aux consignes utilisateur (« ne touche plus aux maps déjà faites », « passer aux prochains biomes : Ruine Légendaire, Glace, Apple Woods, Monde Inversé de Giratina, etc. », « pas d'artefact ni d'objet/structure en fin de donjon, seulement le décor ») :

| Lot | Préfixe | Biome / Référence | Type | Spécificités & Animations en boucle fermée |
|---|---|---|---|---|
| `entree_apple_woods_sud_nord_v1` | `EAW1` | Apple Woods (`Apple_Woods_entrance_TDS.png` / `D05P11A`) | Entrée (`entrance` → `donjon_seuil`) | Allée forestière sous pommiers, grand arbre creux au nord, papillons et feuillage animés (`16 × 5 = 80` ticks) |
| `fin_apple_woods_clairiere_pommier_v1` | `FAW1` | Apple Woods (`Apple_Woods_entrance_TDS.png` / `D05P31A`) | Fin de donjon (`entrance` → `boss` → `objectif`) | Clairière circulaire fermée par une couronne de pommiers, zéro panier ni objet, papillons animés (`80` ticks) |
| `entree_route_glace_sud_nord_v1` | `ERG1` | Route de Glace (`iceroadpmdsky.png` / `pmdskyicearena.png`) | Entrée (`entrance` → `donjon_seuil`) | Couloir de glace fissurée, stalagmites et arche polaire au nord, reflets cristallins animés (`80` ticks) |
| `fin_route_glace_cirque_polaire_v1` | `FRG1` | Cirque Polaire (`pmdskyicearena.png` / `iceroadpmdsky.png`) | Fin de donjon (`entrance` → `boss` → `objectif`) | Amphithéâtre glaciaire entouré de stalagmites et horizon polaire, zéro piédestal ni cristal (`80` ticks) |
| `entree_ruine_legendaire_sud_nord_v1` | `ERL1` | Ruine Légendaire (`D28P44A` / `D42P42A`) | Entrée (`entrance` → `donjon_seuil`) | Cour antique pavée de dalles grises, colonnades brisées et portique monumental au nord (`80` ticks) |
| `fin_ruine_legendaire_sanctuaire_v1` / `v2` | `FRL1` / `FRL2` | Ruine Légendaire (`D28P44A` / `Sealed_Ruin_pit_TDS.png`) | Fin de donjon (`entrance` → `boss` → `objectif`) | Cour intérieure de dalles grises fissurées et colonnades antiques, zéro sceau/stèle/artefact (`80` ticks) |
| `entree_monde_inverse_giratina_v1`..`v3` | `EMI1`..`EMI3` | Monde Inversé de Giratina (`D30P42A` / `D42P41A` / `finalisland.png`) | Entrée (`entrance` → `donjon_seuil`) | Néant bleu abyssal animé en background, îles flottantes renversées à 180°, chemins à l'envers et cascades inversées ascendantes (`dy < 0`, `80` ticks) |
| `fin_monde_inverse_giratina_v1`..`v3` | `FMI1`..`FMI3` | Monde Inversé de Giratina (`D30P42A` / `D42P41A` / `finalisland.png`) | Fin de donjon (`entrance` → `boss` → `objectif`) | Archipel flottant dans le néant bleu abyssal animé avec cascades inversées ascendantes, zéro structure ni artefact (`80` ticks) |
| `entree_amp_plains_sud_nord_v1` | `EAP1` | Plaines Électriques / Amp Plains (`Amp_Plains_entrance_TD.png` / `D08P11A`) | Entrée (`entrance` → `donjon_seuil`) | Savane dorée, arbres foudroyés, canyon rocheux gris au nord, arcs électriques et brise animés (`80` ticks) |
| `fin_amp_plains_savane_orageuse_v1` | `FAP1` | Plaines Électriques / Amp Plains (`Amp_Plains_entrance_TD.png` / `D08P11A`) | Fin de donjon (`entrance` → `boss` → `objectif`) | Plateau circulaire de savane dorée fermé par une couronne d'escarpements gris et d'arbres foudroyés, zéro objet/structure (`80` ticks) |
| `entree_foret_brumeuse_sud_nord_v1` | `EFB1` | Forêt Brumeuse / Foggy Forest (`Foggy_Forest_Base_Camp_TDS.png` / `D11P11A`) | Entrée (`entrance` → `donjon_seuil`) | Sentier sylvestre, clairière naturelle (sans tentes), souche-tunnel au nord et nappes de brume animées (`80` ticks) |
| `fin_foret_brumeuse_clairiere_v1` | `FFB1` | Forêt Brumeuse / Foggy Forest (`Foggy_Forest_Base_Camp_TDS.png` / `D11P11A`) | Fin de donjon (`entrance` → `boss` → `objectif`) | Grande clairière sylvestre fermée au nord par une futaie dense et nappes de brume animées, zéro tente/objet/artefact (`80` ticks) |
