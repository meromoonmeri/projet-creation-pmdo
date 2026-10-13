# WORKFLOW — Création de maps PMDO multicalques 4:3 (`768 × 576`)

Ce document synthétise le workflow de création, découpe multicalque, animation en boucle fermée, vérification d'accessibilité `16 × 16` et empaquetage PMDO `0.8.12.0`.

1. **Format et grille native** : `768 × 576 px` (`96 × 72` cases de `8 × 8 px`, `TexSize = 1`).
2. **Pile de calques** : `00_sol` (tapis complet `768 × 576`), `01_relief` (parois/arbres/falaises/colonnades), `02_couronnes` (éléments de décor pur sans artefact ni objet rapporté), `03_animation` (boucle fermée), + `04 Vos elements avant-plan (Top)` (`Layer = 4`).
3. **Marqueurs et BFS `16 × 16`** :
   - `entree_*` : `entrance` au sud et `donjon_seuil` au nord.
   - `fin_*` : `entrance` au sud, `boss` au centre de l'arène, `objectif` au nord (aucune sortie, aucun warp, aucun artefact).
