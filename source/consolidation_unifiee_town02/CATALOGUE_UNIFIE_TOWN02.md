# PROJET PMD — Dépôt Unifié façon `Palikadude/Halcyon` & `meromoonmeri/town02`

Ce guide et le kit automatisé (`CREER_PROJET_PMD.sh` + `assembler_repo_unifie_town02.py`) assemblent en une seule commande le dépôt GitHub unique **`meromoonmeri/PROJET-PMD`** (`<Name>PROJET PMD</Name>` dans `Mod.xml`), basé sur **`meromoonmeri/town02`** et respectant **100 % du schéma de placement de `Palikadude/Halcyon`** (`PMDO 0.8.12.0`, `<Namespace>halcyon</Namespace>`).

---

## 1. Comment `Palikadude/Halcyon` et `meromoonmeri/town02` placent leurs maps

L'audit comparé de `Palikadude/Halcyon` (`master`) et `meromoonmeri/town02` (`main`) établit les **6 règles impératives** pour qu'une carte soit nativement reconnue, ouvrable dans l'éditeur et jouable sans aucun damier mauve :

| Emplacement dans `PROJET PMD` | Rôle dans `Halcyon` / `town02` (`PMDO 0.8.12.0`) | Ce que fait automatiquement `assembler_repo_unifie_town02.py` |
|---|---|---|
| `Mod.xml` | Déclare `<Name>PROJET PMD</Name>` tout en gardant `<Namespace>halcyon</Namespace>` et `<GameVersion>0.8.12</GameVersion>` | Met à jour `<Name>` & `<Description>` sans casser l'espace de noms `halcyon` utilisé par tous les scripts existants |
| `Content/Tile/<Sheet>.tile` + `Content/Tile/index.idx` | Stocke les planches de tuiles `8×8` PNG et leur table d'offsets binaire `RogueEssence.Content.TileGuide` triée alphabétiquement | Copie chaque nouvelle banque `.tile` (en déréférençant les symlinks `.cache/`) et ré-indexe `Content/Tile/index.idx` octet par octet |
| `Data/Ground/<ground_id>.rsground` | Toutes les scènes hors-donjon (villes, grottes narratives, arènes de boss, **12 salles de guilde**) résident à plat dans `Data/Ground/` avec BOM UTF-8 (`\ufeff`) et `Object.AssetName == "<ground_id>"` | Copie tous les `.rsground` sans écraser ceux de `town02` (alias `__custom_pmdo` si homonyme) et synchronise `Object.AssetName` |
| `Data/Script/halcyon/ground/<ground_id>/init.lua` | Dans `town02` (`0.8.12`), les callbacks Lua d'une carte Ground sont chargés depuis `Data/Script/halcyon/ground/<ground_id>/init.lua` (`require 'origin.common'`) | Relocalise automatiquement les scripts `Data/Script/<ns>/ground/<id>/*` vers `Data/Script/halcyon/ground/<id>/` et génère un `init.lua` valide (`GAME:FadeIn(20)`) pour les grounds sans script |
| `Data/Zone/master_zone.json` + `Data/Zone/index.idx` | `Halcyon` enregistre chaque GroundMap jouable dans `master_zone.json` (`Object.GroundMaps`, `391` entrées `0..390` dans `town02`) et son miroir `Data/Zone/index.idx` (`Object["master_zone"]["Grounds"]`) | Préserve l'ordre exact des indices `0..390` de `town02` et ajoute tous les nouveaux `<ground_id>` à la suite dans les deux fichiers |
| `Halcyon Mods/sources_projet_pmd/` | `Palikadude/Halcyon` garde la racine épurée (`Content/`, `Data/`, `Strings/`, `CONVERSION/`, `Halcyon Mods/`, `Mod.xml`) | Archive proprement tous les scripts `source/*/build.py`, le kit Guilde Treehouse (`salles/`, `calques/`, `fenetres_exterieur/`, `exterieur/`) et les aperçus HTML 60 FPS sous `Halcyon Mods/sources_projet_pmd/` |

---

## 2. Contenu réuni dans « PROJET PMD »

1. **Base `meromoonmeri/town02` (`main`)** :
   - **1 620** cartes `.rsground`, **131** `.rsmap`, **2 091** planches `.tile` natives Halcyon / Metano Town.
2. **Cartes `meromoonmeri/projet-creation-pmdo` (`arena/637b0828-projet-creation-pmdo`)** :
   - Les **33 cartes animées du Studio PMDO** (`KYE1` & `KYA1` Kyurem, `FAS1` Lugia Fosse d'Argent, `ZKE1`/`ZKA1` Zekrom, `RSE1`/`RSA1` Reshiram, `MLE1`/`MLS1` Mont Lointain Ho-Oh nuages 100 % fixes, `TCE1`/`TCS1` Tour Céleste Rayquaza, `SWEN`/`SWFN` Bois des Murmures Suicune, `GCE1`/`GCF1`, `TWE1`/`TWF1`, etc.) + les grounds compatibles `town02` (`cliff_centre_*`, `metano_gen_*`).
3. **Guilde Treehouse PMD (`meromoonmeri/guilde-treehouse-pmd` -> `guilde_treehouse_halcyon_v1`)** :
   - **12 salles modulaires** (`01_accueil`, `02_hall_missions`, `03_salle_commune`, `04_comptoir_services`, `05_dortoir_equipes`, `06_infirmerie`, `07_mess_cuisine`, `08_bibliotheque_cartes`, `09_reserve_equipement`, `10_poste_garde`, `11_atelier_reparation`, `12_salle_chef`) sur grille stricte `8 px`, avec **passages ouverts PMD** câblés par `GroundObjects` (`triggerType = 2`, `GAME:EnterGroundMap(...)`), **fenêtres transparentes** (`00_exterieur` sous les découpes vitrées) et **10_bordure_avant** en `Layer = 4 (Top)`.
   - **84 `.rsground` Halcyon prêts à jouer** : `12` salles canoniques (`guilde_th_01_accueil`..`guilde_th_12_salle_chef` suivant dynamiquement `SV.guilde_treehouse_ambiance`) + `72` variantes explicites couvrant les **6 ambiances** (`jour`, `nuit`, `crepuscule`, `aube`, `soir`, `orageux`), appuyées sur **35 banques `.tile` dédupliquées** (`max 10 103` tuiles/banque).

---

## 3. Commande unique pour créer et pousser `meromoonmeri/PROJET-PMD`

Depuis votre machine (avec `git`, `git-lfs`, `gh` connecté à votre compte `meromoonmeri`, et `python3` + `Pillow`) :

```bash
bash source/consolidation_unifiee_town02/CREER_PROJET_PMD.sh meromoonmeri/PROJET-PMD public
```

*(Note : GitHub remplace les espaces par un tiret dans l'URL du dépôt `meromoonmeri/PROJET-PMD`, tandis que `Mod.xml` porte bien le nom exact `<Name>PROJET PMD</Name>`.)*
