# Crédits et provenance — bibliothèque Ground

Filtre de provenance appliqué dépôt par dépôt (Étape 0 du PROMPT PMDO
Destiny). Aucun contenu n'a été copié sans lecture de sa provenance.

## Importé dans la bibliothèque

| Source | Auteur | Licence / statut | Commit | Contenu |
|---|---|---|---|---|
| `meromoonmeri/projet-pmdo` (ZIP livrés à la racine : `cote_metano_*`, `cotes_metano_abyss_0812`, `cotes_v2_0812`, `mod_metano_expeditions_0812`) | meromoonmeri | Contenu original de l'auteur (projet personnel, aucune licence déposée ; utilisé avec accord du demandeur = l'auteur) | `6cca4a09` | 126 maps `.rsground` + tilesets + scripts |
| `meromoonmeri/projet-creation-pmdo`, branches `arena/*` (exports `entree_*`/`fin_*`, `reseau_metano_normal_v1`, tests `cliffdaytest`/`cliffnordouesttest1`) | meromoonmeri | Idem — travaux d'origine des sessions de design | TIP le plus récent par fichier | 21 maps clampées |
| PMDO / **DumpAsset** (`spinda_cafe.rsground`, `guild_second_floor.rsground`, `luminous_spring.rsground`) | PMDCollab | DumpAsset = assets officiellement distribués pour le modding PMDO — source autorisée par défaut. Format `.rsground` natif PMDO (aucun contenu de ROM). **À confirmer** : ces copies proviennent des dossiers `references/` des sessions ; vérifier qu'elles correspondent bien au DumpAsset avant diffusion | — | 3 maps de référence |
| Mod **Halcyon** (`crooked_cavern_entrance.rsground`, copie `crooked.rsground`) | auteur Halcyon | Mod communautaire original — autorisé par défaut avec crédit ; **licence à confirmer auprès de l'auteur** avant toute redistribution | — | 1 map (2 copies) |
| Univers **Metano** (`metano_cafe.rsground`, `metano_normal_home.rsground`) | meromoonmeri | Contenu original de l'auteur | — | 2 maps |

## EXCLUS — non importés (signalés uniquement)

| Fichier | Motif |
|---|---|
| `source/cote_v5_expeditions/references/ExplorersOfSkyOrigins__Brine_Cave_Entrance.rsground` | **Exclusion ferme** : dérivé d'un remake de jeu commercial (ExplorersOfSkyOrigins) |
| `source/cote_v5_expeditions/references/ExplorersOfSkyOrigins__drenched_bluff_entrance.rsground` | Idem |
| `source/ledian_dojo_v1/references/ledian_dojo.rsground` | Mod communautaire d'auteur : licence non vérifiée → **accord de l'auteur requis** |
| `source/antre_harmonie_v3/references/altere_pond.rsground` | Origine non établie → à clarifier avant tout import |
| `source/amp_plains_fleurie_v1/references/vast_steppe_entrance.rsground` | Origine non établie (possible dérivé d'un remake) → à clarifier |

13 stubs de `renders/*/package/Data/Ground/*.rsground` sont des **liens
symboliques** vers `.cache/tiles/…` (cibles non versionnées) : non
matérialisés, listés dans `rapport_clamp.md`.

## Provenance des assets non résolus

195 noms de feuilles référencées sans fichier correspondant sont listés dans
`rapport_clamp.json` (par map). Catégories probables : tilesets de base PMDO
(fournis par DumpAsset au runtime), imports bruts de l'éditeur aux noms non
normalisés (« téléchargement (3) », UUID…), et feuilles jamais exportées des
projets `reseau_metano_normal_v1` / `destiny_cliff_tests`. Aucun de ces noms
n'a été inventé : ce sont les références écrites dans les maps sources.
