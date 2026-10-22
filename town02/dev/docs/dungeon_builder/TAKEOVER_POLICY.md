# Reprise des donjons (takeover) — remplacement des anciennes implémentations

Dès qu'un donjon entre dans le périmètre de ce Builder, l'implémentation
précédente cesse d'être la référence. Ce document décrit la procédure appliquée,
outillée par `tools/dungeon_builder/takeover.py`
(`python3 tools/dungeon_builder.py takeover [<donjon>] --report --verbose`).

## 1. Classement des artefacts

| Action | Signification | Peut être supprimé ? |
|---|---|---|
| `HARVEST` | donnée canonique réutilisée telle quelle (Ground de scène, `.rsmap`, géométrie, collisions, marqueurs) | jamais |
| `TRANSFER` | contenu narratif ou scène archivée qui **suit** le donjon : cutscenes de Ground, script de zone, cinématiques PMD Red (`.cif.json`) | jamais |
| `REPLACE` | ancienne zone concurrente du donjon, produite par un agent précédent | oui, après reconstruction |
| `REVIEW` | ancien générateur/patcher qui écrivait cette zone | jamais automatiquement — décision humaine |
| `CURRENT` | zone déjà produite par ce Builder | rien à faire |
| `PROTECT` | donjon hors périmètre | intouchable |

## 2. Garde-fous avant suppression

`--apply` refuse de supprimer tant que **les trois** conditions ne sont pas
réunies (`takeover.can_apply`) :

1. le donjon est dans le périmètre du Builder ;
2. son statut de readiness est `READY_FOR_GENERATION` ;
3. la nouvelle zone existe **et** `narrative.transferred` est vrai dans la
   définition (le contenu narratif a été raccordé).

Les outils (`REVIEW`) ne sont jamais supprimés automatiquement : beaucoup
portent aussi de la logique narrative ou d'audit à conserver.

## 3. Contenu narratif : rien ne se perd

Chaque définition embarque désormais un bloc `narrative` :

```json
"narrative": {
  "transferred": false,
  "cutscenes": [{"scene": "d09p03", "state": "active",
                 "path": "Data/Script/halcyon/ground/d09p03"}],
  "zone_script": "Data/Script/halcyon/zone/mt_blaze",
  "red_cinematics": ["RESERVE/red_cinematics/d09p03.cif.json"],
  "rule": "…rejouées sur le Ground canonique (cinématique = combat = fin)."
}
```

Total inventorié sur les 51 donjons : **65 dossiers de cutscene** et
**60 cinématiques PMD Red** (`.cif.json` : audio, caméra, dialogues, déclencheur
de combat). Un test vérifie que chaque chemin référencé existe réellement, et
l'audit signale tout donjon dont le narratif n'est pas encore marqué transféré.

## 4. Chaîne complète auditée par donjon

`entrée → progression → scène narrative → boss/fin → cinématique → combat → sortie`

* **entrée** : Ground d'entrée canonique (`fixed_grounds.entrance`) quand il existe ;
* **progression** : étages procéduraux RogueElements générés par le Builder ;
* **scène / boss / cinématique / combat** : un **seul** espace —
  `scenes.cinematic_ground == scenes.battle_ground == scenes.canonical_end_ground` ;
* **sortie** : gérée par le script de zone transféré.

## 5. Statut de reprise dans l'audit

`ALREADY_IMPLEMENTED` a été **supprimé** du vocabulaire : une ancienne
implémentation dans le périmètre devient `TAKEOVER_PENDING` (à reconstruire puis
à supprimer), et non une excuse pour conserver l'existant. Seuls les donjons
hors périmètre restent `OWNED_BY_OTHER_AGENT`.

État courant : **7 donjons `TAKEOVER_PENDING`** — `mt_blaze`, `mt_freeze`,
`frosty_forest`, `lapis_cave`, `wish_cave` (zones héritées présentes) et
`sky_tower`, `sky_tower_summit` (arc ch.10 importé par un agent précédent).

## 6. Exemple vérifié — `mt_blaze`

```
REPLACE   Data/Zone/mt_blaze.json
HARVEST   Data/Ground/mont_cendre_pied.rsground      (entrée canonique)
HARVEST   Data/Ground/d09p02.rsground                (relais canonique)
HARVEST   Data/Ground/d09p03.rsground                (scène Sulfura : cinématique = combat)
TRANSFER  Data/Script/halcyon/ground/{mont_cendre_pied,d09p02,d09p03}
TRANSFER  Data/Script/halcyon/zone/mt_blaze + RESERVE/scripts_zone/mt_blaze
TRANSFER  RESERVE/red_cinematics/{d09p01,d09p02,d09p03}.cif.json
REVIEW    tools/…                                    (anciens générateurs)
```

Nouvelle source de vérité après reprise : `DungeonDefs/canonical/mt_blaze.json`
(définition) + `Data/Zone/mt_blaze.json` régénéré par le Builder + les Grounds
canoniques conservés + les scripts transférés. Aucun doublon fonctionnel.


---

## 7. Exécution de la reprise (2026-08-23)

### 7.1 Reconstruction des 7 `TAKEOVER_PENDING`

| Donjon | Étages hérités | Étages canoniques reconstruits | Données récupérées |
|---|---|---|---|
| `mt_blaze` | 3 | **12** | musique `Mt. Blaze.ogg`, Grounds `mont_cendre_pied`/`d09p02`/`d09p03`, midpoint `mt_blaze_midpoint` |
| `mt_freeze` | 2 | **15** | `Mt. Freeze.ogg`, `mont_gele_pied`/`d11p02`/`d11p03`, midpoint |
| `frosty_forest` | 3 | **9** | `Frosty Forest.ogg`, `foret_givree_oree`/`d10p02`/`d10p03`, midpoint |
| `lapis_cave` | 1 | **14** | `Lapis Cave.ogg`, `grotte_lazuli_seuil`/`grotte_lazuli_fond` |
| `wish_cave` | 2 | **99** | `Wish Cave.ogg`, `sanctuaire_voeu` (+ `.rsmap` homonyme) |
| `sky_tower` | — | **25** | scènes `parvis_celeste`/`palier_celeste`/`arc_tour_ciel_sommet` |
| `sky_tower_summit` | — | **9** | même édifice, scène `arc_tour_ciel_sommet` |

Les anciennes implémentations étaient des ébauches (1 à 3 étages pour 9 à 99
étages canoniques) : leur structure d'étages est **abandonnée**, leurs données
utiles sont **conservées** (`harvested_from_legacy` dans chaque définition, lu
au besoin depuis le commit racine pour que la provenance ne disparaisse jamais).
Chaque zone régénérée porte l'empreinte `[built by tools/dungeon_builder from …]`
et un test refuse qu'une zone de notre périmètre en soit dépourvue.

### 7.2 Intégration des scènes archivées

`dungeon_builder integrate` a restauré **17 Grounds canoniques** et
**28 dossiers de cutscene** depuis `RESERVE/` vers les données actives, avec
enregistrement dans `Data/Ground/index.idx` :
`champ_foudre` (Raikou), `caverne_trouble_fond`/`_autel`, `d01p02`, `d02p02`,
`d03p02`, `d05p02`, `d06p02`, `d06p03` (Zapdos), `foret_tendre_oree`,
`grotte_statique_seuil`, `pic_ferreux_pied`, `gouffre_muet_bord`,
`mont_grondant_pied`, `grand_canyon_porte`, `bois_sombres_oree` (entrée
canonique de Sinister Woods) et `foret_guerison` (Celebi).

Les archives restent en place comme trace de provenance : rien n'est détruit
côté `RESERVE/`.

### 7.3 Narratif

`narrative.transferred` ne vaut `true` que si **tous** les dossiers de cutscene
du donjon sont vivants sous `Data/Script/halcyon/ground/` (et le script de zone
sous `zone/`). État : **33 définitions** avec narratif marqué transféré,
55 dossiers de cutscene et 62 cinématiques PMD Red inventoriés. Les cinématiques
`.cif.json` non encore portées en Lua sont listées dans
`narrative.pending_cinematics` — jamais silencieusement considérées comme faites.

### 7.4 Ce qui reste bloqué (et pourquoi)

| Donjon | Statut | Raison exacte |
|---|---|---|
| `buried_relic` | `BLOCKED_MISSING_ASSET` | aucune scène canonique confirmée ; candidats repérés et consignés dans `scene_candidates` (`relique_ancienne`, `tour_reliques_porte`, `fleche_reliques_courroux`, `sanctuaire_titans` déjà utilisé par `cloven_ruins`) → **arbitrage humain requis avant de créer une arène** |
| `meteor_cave` | `BLOCKED_MISSING_ASSET` | aucune scène canonique nulle part (actif ni archive) → arène `meteor_cave_arena.rsmap` à créer |
| `northwind_field` | `BLOCKED_MISSING_TILESET` | aucun triplet de plaine glacée disponible ; **aucun tileset n'a été emprunté pour faire disparaître le blocage** |

État global : **48 / 51 `READY_FOR_GENERATION`**.


---

## 8. Vérifications finales avant génération massive (2026-08-23)

### 8.1 `buried_relic` — enquête, pas de devinette

Les candidats repérés (`relique_ancienne`, `tour_reliques_porte`,
`fleche_reliques_courroux`, `sanctuaire_titans`) ont été **écartés avec preuve** :

* l'archive des Grounds PMD Red ne couvre que **D01–D25** (vérifié : codes
  présents dans `RESERVE/red_grounds` et `RESERVE/red_cinematics`) ; Buried
  Relic n'a donc **aucun Ground de scène dans la source** ;
* `pret/pmd-red/src/dungeon_boss_dialogue.c` contient
  `gRegirockPreFightDialogue`, `gRegicePreFightDialogue`,
  `gRegisteelPreFightDialogue` : le combat est **scripté en donjon**, pas sur un
  Ground de cinématique.

Conclusion canonique : l'implémentation correcte est une **salle fixe de
donjon** (`.rsmap` chargé en étage via `LoadGen`), pas un Ground inventé.
La définition porte désormais `boss.arena_kind = "in_dungeon_fixed_room"` et
`boss.canonical_evidence` (source + symboles). Le donjon reste
`BLOCKED_MISSING_ASSET` tant que la salle fixe n'est pas produite.

### 8.2 `meteor_cave` — même conclusion

`gDeoxysPreFightDialogue_1..4` : rencontre en donjon, aucune scène canonique
active ni archivée. La création de `meteor_cave_arena.rsmap` est donc légitime
et documentée comme exception, avec la même nature de salle fixe.

### 8.3 `northwind_field` — recherche exhaustive refaite

Scan de **tout** le dépôt (données actives, `RESERVE/`, index) : 74 triplets
complets, dont seulement trois de biome glacé — `frosty_forest`, `mt_freeze`,
`sky_peak_4th_pass` — tous déjà propriétaires. **Aucun emprunt effectué**, le
donjon reste `BLOCKED_MISSING_TILESET`. Un test échouera si un nouveau triplet
glacé apparaît, pour forcer la ré-évaluation.

### 8.4 `READY_FOR_GENERATION` ne veut plus dire « JSON valide »

L'audit exécute désormais, pour chaque donjon sans blocage :

* résolution DTEF (propriétaire ou emprunt justifié) ;
* Ground d'entrée / relais / scène finale réellement présents ;
* invariant `cinematic_ground == battle_ground == canonical_end_ground` ;
* narratif **transféré** (sinon `BLOCKED/NARRATIVE_NOT_TRANSFERRED`) ;
* tables Pokémon/objets non vides, features valides, boss cohérent ;
* **test de génération réel** : 5 variantes valides et structurellement
  distinctes sur 3 étages échantillonnés (1er, milieu, dernier), sinon
  `BLOCKED/GENERATION_FAILED`.

### 8.5 Échantillon de validation

`docs/dungeon_builder/SAMPLE_VALIDATION.md` — 8 donjons de biomes et profils
différents, 10 variantes chacun, aucun fichier de production écrit :

| Donjon | Profils | Rooms min/moy/max | Halls | Branches | Culs-de-sac | Boucles | Traversables |
|---|---|---|---|---|---|---|---|
| `gloomy_forest` F7 | looping/branching/large_rooms/mixed/ring | 4/11.4/23 | 14.2 | 3.6 | 2.3 | 1.8 | 10/10 |
| `magma_cavern` F12 | looping/lattice/mixed | 5/10.1/21 | 13.7 | 4.0 | 1.9 | 2.4 | 10/10 |
| `stormy_sea` F20 | ring/lattice/looping | 4/8.0/13 | 13.1 | 2.6 | 1.3 | 1.7 | 10/10 |
| `silver_trench` F50 | ring/lattice/looping | 5/8.7/11 | 15.0 | 4.0 | 1.8 | 2.6 | 10/10 |
| `great_canyon` F6 | twosides/branching/mixed | 6/9.5/14 | 11.1 | 2.5 | 2.8 | 0.9 | 10/10 |
| `murky_cave` F9 | branching/mixed/dense | 8/14.0/22 | 16.8 | 5.3 | 4.0 | 1.8 | 10/10 |
| `joyous_tower` F40 | lattice/looping/mixed | 8/11.8/23 | 15.5 | 4.7 | 3.4 | 2.0 | 10/10 |
| `desert_region` F10 | large_rooms/twosides/mixed | 6/9.6/19 | 11.3 | 2.4 | 2.1 | 1.2 | 10/10 |

10 signatures distinctes sur 10 pour chaque étage échantillonné, 100 % de
traversabilité, aires de salles hétérogènes (20 → 64 tuiles sur le seul
`murky_cave` F9). Les layouts ASCII sont inclus dans le document.

**Statut : 48 / 51 `READY_FOR_GENERATION`. `generate-all` reste non lancé, en
attente de validation de cet échantillon.**
