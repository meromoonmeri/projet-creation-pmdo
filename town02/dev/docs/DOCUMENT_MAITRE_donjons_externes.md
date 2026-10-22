# DOCUMENT MAÎTRE — Reprise de donjons externes pour New Era

**Version vivante — fichier unique.** Ce document remplace et fusionne : le MEGA-PROMPT
multi-sources, `plan_assignation_donjons_multi_sources.md` (conservé comme annexe
historique), `11_curation_ressources_externes.md`, et les addendums dispersés.
À partir de maintenant, ce chantier est mis à jour ICI, jamais dupliqué.

Dernière mise à jour : 2026-07-27 — après audit des 9 points ouverts (Partie 8).

---

## PRINCIPE DIRECTEUR (directive utilisateur du 2026-07-27)

> **RAJOUT de donjons et de contenu à l'histoire. Ce n'est PAS un remplacement de
> l'existant, mais un AJOUT INTELLIGENT, intégré à ce qui a déjà été fait, avec un
> AUDIT à la fin de chaque vague.**

Conséquences concrètes :
- Rien de ce qui est déjà branché (ch1-10, vague 1, relais officiels, Autel des Cieux)
  n'est retiré ou écrasé par ce chantier.
- Chaque nouveau donjon vient COMBLER un manque (secondaires ch1-10) ou PRÉPARER
  l'expansion (ch11-32), jamais concurrencer un donjon existant au même chapitre.
- Chaque vague se termine par la boucle d'audit complète : fiche §7 de la directive
  multi-sources + `integration_tracker.md` + audit spatial §11 + audit narratif §10
  (`narrative_audit_log.md`) avant commit.

---

## PARTIE 0 — Documentation de référence

- RogueEssence : https://github.com/RogueCollab/RogueEssence — RogueElements :
  https://github.com/rogueessence/RogueElements — PMDC : https://github.com/PMDCollab/PMDC
- PMDODump : https://github.com/audinowho/PMDODump — DumpAsset :
  https://github.com/audinowho/DumpAsset
- Wiki PMDO : Scripting Cheat Sheet / Text Guide / Script Reference / Floor Generation
  Overview — https://wiki.pmdo.pmdcollab.org/
- Sources externes minées : RaoKurai/ZMDO, Logical321/ProjectEoN, Deeshura/Mega_Stones,
  DoubleTrio/dungeon-pack, Minemaker0430/ExplorersOfSkyOrigins, pret/pmd-red,
  Friend Area (Drive), Resource Dungeon Pack (Imbion) + Knightcore (bloqué, abandonné).

---

## PARTIE 1 — Méthodologie

**Filtre à 3 questions** sur chaque élément retenu : (1) où ça va dans New Era,
(2) quelle adaptation avant d'entrer, (3) quelle règle du projet ça respecte.
Réponse vide/faible = rejet.

**Exigence renforcée** pour le contenu très reconnaissable (EoSOrigins, pmd-red) :
si un joueur du jeu source reconnaîtrait le lieu même renommé → rejet automatique —
SAUF pmd-red, où la consigne explicite est de conserver layout/boss/cinématique à
l'identique (Partie 6) ; seul le casting change.

**Transformation standard** (toutes sources sauf pmd-red) :
1. Renommage français original
2. Étages selon barème Partie 2
3. Difficulté calée sur le palier de niveau
4. Cinématique d'entrée créée/adaptée (Voix → Flash → Émergence pour les boss)
5. Boss d'origine → mini-boss New Era, dialogues réécrits FR, animation typée
6. Légendaire de zone de boss uniquement si justifié narrativement

**pmd-red** (règle inverse) : layout, positions d'entités, triggers ET boss conservés
1:1 ; seuls changent le nom de zone et les personnages des cinématiques.

---

## PARTIE 2 — Barème global par palier

| Palier | Chapitres | Niv. équipe | Niv. boss | Niv. légendaire | Ét. secondaire | Ét. principal | Ét. défi |
|---|---|---|---|---|---|---|---|
| 1 | 1-4 | 5-15 | ~15 | — | 10-12 | 12-15 | — |
| 2 | 5-8 | 15-25 | ~25 | — | 12-16 | 16-20 | — |
| 3 | 9-12 | 25-35 | ~35 | — | 16-20 | 20-25 | — |
| 4 | 13-16 | 35-45 | ~45 | — | 20-25 | 25-30 | 30-35 |
| 5 | 17-20 | 45-55 | ~55 | ~60-65 | 22-28 | 28-35 | 35-40 |
| 6 | 21-24 | 55-65 | ~65 | ~70-75 | 25-30 | 32-40 | 40-50 |
| 7 | 25-28 | 65-75 | ~75 | ~80 | 28-35 | 38-45 | 50-60 |
| 8 | 29-32 | 75-85 | ~85 | ~90 | 30-40 | 45-55 | 60-70 |

Renivelage des boss ch6-10 vers ce barème : **FAIT** (option (a) validée, commit 165d42f,
`tools/rebalance_bosses.py`) — Zarude 27 (rev. 30), Regigigas 28, Diancie 30,
Laggron 32, Fulgur 33, Lugia 35.

**Budget par chapitre** : 2-3 secondaires + 2-3 principaux, sur 30-32 chapitres.

### 2.1 Budget RÉELLEMENT occupé (vérifié dans le dépôt, 2026-07-27)

| Ch. | Principaux (existants) | Secondaires (branchés) |
|---|---|---|
| 1 | Forêt Relique | Petit Tunnel, Bosquet Voilé, Grotte du Mystère, Vallée Fertile (déblocage `guild_heros_room_ch_1.lua:137-140`) + mazes dojo |
| 2 | Rivière Illuminée | — |
| 3 | Caverne Tortueuse | Antre de l'Énigme, Carrière de Cuivre |
| 4 | Bosquet Apricorn | Grotte de l'Échoué |
| 5 | Grande Steppe + Tunnel Incandescent + Mont Venteux | — |
| 6 | Forêt Lugubre (Zarude) | zone légendaire verdant_oath |
| 7 | Aegis Cave (Regigigas) | — |
| 8 | Sanctuaire de Cristal (Diancie) | — |
| 9 | Marais de l'Oubli (Laggron) | — |
| 10 | Pic Céleste (Fulgur + Lugia / Autel des Cieux) | — |
| hors histoire | — | 7 donjons Imbion (job board), 8 mazes dojo |

Manque le plus criant : **secondaires ch2 et ch5-10** → priorité de la vague 2.

---

## PARTIE 3 — PMDODump (47 donjons)

*(✅ = déjà importé et branché ; les autres = réserve assignée)*

| Donjon d'origine | Rename FR | Palier | Légendaire | Statut |
|---|---|---|---|---|
| Tiny_Tunnel | Petit Tunnel | 1 | — | ✅ vague 1 (ch1) |
| Fertile_Valley | Vallée Fertile | 1 | — | ✅ vague 1 (ch1) |
| Copper_Quarry | Carrière de Cuivre | 1 | — | ✅ vague 1 (ch3) |
| Castaway_Cave | Grotte de l'Échoué | 1 | — | ✅ vague 1 (ch4) |
| Cave_Of_Solace | Grotte du Repos | 1 | — | ✅ vague 2 (ch2) |
| Royal_Garden | Jardin Royal | 1 | — | ✅ vague 2 (ch4, via royal_halls « Halles Royales ») |
| Muddy_Valley | Vallée Boueuse | 1 | — | ✅ vague 2 (ch3, via bramble_woods « Bois des Ronces ») |
| Secret_Garden | Jardin Secret | 1-2 | — | ✅ vague 2 (ch4) |
| Ambush_Forest | Forêt de l'Embuscade | 2 | — | ✅ vague 2 (ch5) — end_ambush_forest renommé foret_embuscade_fond, distinct du relay ch9 |
| Trickster_Woods | Bois du Filou | 2 | — | ✅ vague 2 (ch5) |
| Forsaken_Desert | Désert des Oubliés | 2 | — | ✅ vague 2 (ch6) |
| Barren_Tundra | Toundra Désolée | 2 | — | ✅ vague 2 (ch8, remplace glacial_path absent) |
| Glacial_Path | Sentier Glaciaire | 2 | — | ✖ absent de DumpAsset → couvert par Toundra Désolée |
| Geode_Crevice | Crevasse de Géode | 2 | — | ✅ vague 2 (ch6) |
| Depleted_Basin | Bassin Tari | 2 | — | ✅ vague 2 (ch9) |
| Energy_Garden | Jardin d'Énergie | 2 | — | ✅ vague 2 (ch7) |
| Snowbound_Path | Sentier Enneigé | 3 | — | ✅ vague 2 (ch10) |
| Thunderstruck_Pass | Col de la Foudre | 3 | — | ✅ vague 2 (ch10) |
| Veiled_Ridge | Crête Voilée | 3 | — | réserve ch11+ |
| Flyaway_Cliffs | Falaises de l'Envol | 3 | — | ✅ vague 2 (ch10) |
| Deserted_Fortress | Forteresse Abandonnée | 3 | — | réserve ch11+ |
| Magnetic_Quarry | Carrière Magnétique | 3 | — | réserve ch11+ |
| Wayward_Wetlands | Marais Errants | 3 | — | ✅ vague 2 (ch9) |
| Exotic_Wilds | Terres Exotiques | 3 | — | réserve ch11+ |
| Sleeping_Caldera | Caldeira Endormie | 4 | — | réserve ch13-16 |
| Lava_Floe_Island | Île de Lave Flottante | 4 | — | réserve ch13-16 |
| Illusory_Ridge | Crête de l'Illusion | 4 | — | réserve ch13-16 |
| Clouded_Road | Route Embrumée | 4 | — | réserve ch13-16 |
| Trickster_Maze | Labyrinthe du Filou | 4 | — | réserve ch13-16 |
| Overgrown_Wilds | Terres Envahies | 4 | — | réserve ch13-16 |
| Sea_Current_Maze | Labyrinthe des Courants | 4 | — | réserve ch13-16 |
| Treacherous_Mountain | Montagne Traîtresse | 4 | — | réserve ⚠ `end_treacherous_mountain` déjà utilisé (mount_windswept_guardian ch5) → autre arène obligatoire |
| Moonlit_Courtyard | Cour du Clair de Lune | 5 | — | réserve ⚠ `end_moonlit_temple` déjà utilisé (cloven_ruins_midpoint ch7) → courtyard sans le temple |
| Relic_Tower | Tour des Reliques | 5 | — | réserve ch17-20 |
| Abyssal_Island | Île Abyssale | 5 | — | réserve ch17-20 |
| Wisdom_Road | Sentier du Savoir | 5 | **Uxie** (tranché) | réserve ch17-20 |
| Hope_Road | Sentier de l'Espoir | 5 | — (Mesprit évoqué : fresques) | réserve ch17-20 |
| Bravery_Road | Sentier du Courage | 5 | — (Azelf évoqué : fresques) | réserve ch17-20 |
| Eon_Island_Cave/Coast | Île Éon — Grotte/Côte | 5 | — | réserve ch17-20 |
| Eon_Island_Field | Île Éon — Plaine | 6 | — | réserve ch21-24 |
| Eon_Island_Peak | Île Éon — Cime | 6 | Latios & Latias | réserve ch21-24 |
| Moonlit_Temple | Temple du Clair de Lune | 6 | Cresselia (réservée `fiches_boss.md`) | réserve ch21-24 |
| Starfall_Heights | Hauteurs de l'Étoile Filante | 6 | Solgaleo | réserve ch21-24 |
| Oblivion_Valley | Vallée de l'Oubli | 6 | Yveltal (réservé `fiches_boss.md`) | réserve ch21-24 |
| Primeval_Fissure | Faille Primordiale | 7 | Giratina (réservé `fiches_boss.md`) | réserve ch25-28 |
| The_Sky | Le Ciel Suspendu | 7 | Zygarde | réserve ch25-28 |
| Champion_Road | Sentier du Champion | 8 | **boss narratif dédié** (tranché) | réserve ch29-32 |

---

## PARTIE 4 — Autres sources fan-made

### dungeon-pack (DoubleTrio)

| Donjon | Rename FR | Palier | Légendaire | Note |
|---|---|---|---|---|
| emberfrost_depths | Profondeurs de Braise-Givre | 7 | — | Pool 14+ boss optionnels + autels d'évolution |
| wishmaker_cave | Grotte du Vœu | 7 | Jirachi | candidat retenu recommandé (voir Partie 8, point 3) |
| adventurers_peak | Pic de l'Aventurier | 8 | — | Gauntlet fin de contenu |

Checkpoints (blaze/cove/elemental/forest/frost/rocky) : relais façon Kangourex pour
tout donjon 15+ étages de la réserve — pont via `source_duns_imbi/ground/*_camp`.

### ZMDO — ✅ INTÉGRÉ (vague 1)

mystery_cave → Grotte du Mystère (ch1) ; mystery_dungeon → Antre de l'Énigme (ch3) ;
mystery_grove → Bosquet Voilé (ch1). Scripts sources purgés, re-génération faite.

### ProjectEoN — 6 tilesets curatés (import à la demande)

DrenchedBluffEnd (côte future), CrumblingCanyon (canyon post-ch10), ForestDark
(variante Forêt Lugubre), Cloudless* (variante Pic Céleste), GuildMesshallAnims +
GuildmasterRoomNight (Guilde de Metano). 62 autres rejetés.

### ExplorersOfSkyOrigins — clusters retenus

Grotte des Embruns, Forêt des Ombres Sèches, Grotte de Cristal (variante), Plaines
Battues, Verger Sauvage, Désert Boréal, Grotte Fumante (candidat près Searing Tunnel),
Antre de la Cascade, Mont Rocaille (fusion Bristle/Horn/Travail), Forêt Trompeuse.
**Exclus définitivement** : Guilde, Treasure Town/Spinda, Temporal Tower/Spire,
Hidden Land/Old Ruins/Rainbow Stoneship, antre Groudon, antre Darkrai.
**RÉVISION 2026-07-27 (directive utilisateur)** : Aegis Cave SORT de la liste
d'exclusion — importée 1:1 comme arène Regigigas ch7 (« Sanctuaire des Titans »,
`sanctuaire_titans.rsmap`, tileset EoSO renommé `Titans_Arena_Base`), avec le
trio Regirock/Regice/Registeel niv 26 aux côtés de Regigigas 28. La légende ch5
« Les Trois Serviteurs et le Colosse » (LegendTitansHeard) l'annonçait déjà.
**Critère élargi** (même directive) : pour chaque boss, chercher un lieu
officiel associé dans N'IMPORTE QUEL jeu Pokémon (PMD ou jeux principaux),
pas seulement pmd-red/pmd-sky.

### Friend Area (Drive) — 8 tilesets importés (`Content/Tile/FA_*_RTRB.tile`)

| Tileset | Assignation | Statut vérifié 2026-07-27 |
|---|---|---|
| Volcanic_Pit | Searing Crucible | importé, non câblé |
| Peanut/Poison_Swamp | Forgotten Marsh | importés, non câblés |
| Rainbow_Peak | **arène de combat Lugia** (retiling `celestial_peak_boss.rsmap`) | voir Partie 8, point 4 — plus de conflit |
| Stratos_Lookout | Celestial Peak — arène Fulgur | importé, non câblé |
| Ancient_Relic | Aegis Cave | importé, non câblé |
| Frigid_Cavern | futur donjon glace | réserve |
| Furnace_Desert | futur donjon désert | réserve |

**Passe « salle de boss » demandée** : re-parcourir le dossier Friend Area entier avec
l'angle « arène » — ce qui était rejeté faute de zone peut resservir aux imports pmd-red.

### Resource Dungeon Pack (Imbion) — ✅ INTÉGRÉ

7 donjons job board (Géode Cendrée, Bosquet aux Baies, Grotte du Coven, Jungle Gourmet,
Pâturage Céréalier, Bazar Hanté, Atelier Sensible), fichiers non modifiés (CC BY-NC-ND).

### Mega_Stones (Deeshura) — mécanique end-game

49 Méga-Pierres, boutique « L'Échoppe de Saphir » à Metano, monnaie Éclats d'Âme.
Déblocage : `SV.ChapterProgression.StoryCompleted` (créé, posé à la victoire Lugia —
à déplacer vers la vraie fin quand ch11-32 existeront). Reste à faire : import des
items, branchement scripts, dialogue FR de Saphir écrit de zéro (`.fr.resx` source vide).

---

## PARTIE 5 — Engine PMDO de base (Guildmaster Island)

Mécaniques moteur héritées automatiquement, rien à récupérer. Contenu construit à
miner avec exigence de non-reconnaissance : Faded Trail, Bramble Woods/Thicket,
Thunderstruck Pass, Veiled Ridge, Forsaken Desert, Sleeping/Enraged Caldera,
Lava Floe Island, Snowbound Path, Treacherous Mountain, Ambush Forest, Trickster
Woods, Secret Garden, Guildmaster Trail, Moonlit Courtyard/Temple, Champion's Road,
distorsions mystérieuses. Boss (Team Dragon, 3 Guildmasters) = référence de difficulté
uniquement, jamais repris.

---

## PARTIE 6 — pmd-red (Rescue Team GBA) — conservation 1:1

Layout, positions, triggers ET boss conservés à l'identique ; seuls changent le nom
de zone et le casting des cinématiques.

### Pipeline (opérationnel, commit f9a2c46)

Décodeurs GBA maison (BPL/BPC/BMA) transcrits de `src/ground_bg.c` — skytemple-files ne
lit pas le BPC GBA. 245 map ids catalogués, 32 zones de cinématique croisées avec les
26 `dungeon_cutscene_*.c`. Unité 8px GBA = unité 8px RogueEssence, pas d'ajustement.
Outil : `tools/convert_pmdred_ground.py` ; traçabilité : `pmdred_extraction_tracabilite.md`.
⚠ `/tmp/pmd-red` est hors workspace : re-cloner `pret/pmd-red` si perdu.

### Lot 2 — ✅ 18 ZONES CONVERTIES (2026-07-27)

`tools/convert_pmdred_batch.py` (+ `tools/pmdred_lib.py` désormais dans le dépôt) :
D01P01, D02P01, D03P01, D04P01, D05P01, D06P01, D07P01, D08P01/02, D09P01,
D10P01, D11P01, D12P01, D13P01, D22P01, D23P01, D24P01/02 → 18 `.tile` +
`.rsground` + `init.lua`, positions d'entités extraites automatiquement des
`GroundLivesData` sources, audit flood-fill 18/18 connexes. Tableau complet :
`docs/pmdred_extraction_tracabilite.md` (lot 2). Statut : réserve non branchée ;
`sanctuaire_voeu` (D23P01) = salle finale Jirachi actée ; `foret_givree_oree` /
`mont_gele_pied` = candidates vague 2 (ch8/ch10).

### Lot 3 — ✅ 12 ARÈNES DE CINÉMATIQUE CONVERTIES (2026-07-27)

D12P02/04 (Groudon), D13P02, D14P01 (Kyogre), D15P01 (Lugia réserve), D16P01
(Moltres), D17P01 (Raikou), D18P01 (Articuno), D19P01 (Ho-Oh), D20P01 (Mewtwo),
D21P01 (Latios/Latias), D25P01 (Suicune). Material-layer comme le pilote —
compensation décor au branchement. Casting conservé ; fiches narratives §5
requises avant branchement. Détail : `pmdred_extraction_tracabilite.md` (lot 3).

### Zone pilote — ✅ CONVERTIE

**Sky Tower Summit (D13P03, arène Rayquaza) → « Autel des Cieux »**, cinématique
pré-boss Lugia du ch10. Géométrie 69×75, positions gs209 exactes, casting
Rayquaza→Lugia. Fond nuages GBA compensé par le Background « Sky » animé.

### Les 25 cinématiques confirmées (`dungeon_cutscene_*.c`)

Rayquaza (✅ converti), Groudon (Magma Cavern), Kyogre (Stormy Sea), Lugia (Silver
Trench — distinct de notre réassignation), Ho-Oh (Mt. Faraway), Zapdos, Moltres,
Articuno, Raikou, Entei, Suicune, Regis (Buried Relic), Latios/Latias, Mewtwo (Western
Cave), Deoxys (Meteor Cave), Celebi (Purity Forest), Jirachi (Wish Cave), Magma Cavern
(mise en scène), Medicham/Mankey/Smeargle/Skarmory (side-boss), Meanies/No_One_Here/
Empty_Summit (utilitaires). **Chaque association donjon↔cinématique doit être
re-vérifiée dans le code au moment de l'import — une zone à la fois, même rapport que
le pilote.**

### 98 donjons pmd-red (dungeon_data.json)

~55 donjons d'histoire (paliers 1→8), 17 labyrinthes élémentaires (voir Partie 8,
point 7), 4 duels rivaux (à traiter comme combats ponctuels avec NOS équipes rivales
existantes, pas un nouveau groupe). Exclusions système : BOSS_3/4/9, AUTOPILOT,
D50/51/54/61, OUT_ON_RESCUE, JOIN_LOCATION_*, POKEMON_SQUARE, RESCUE_TEAM_BASE,
AGB_SLOT, NORMAL_MAZE_2, RESCUE_TEAM_2/MAZE.

Ground maps non liées à une cinématique (677 fichiers `data/map_bg/`) : croiser avec
leur donjon AVANT tout renommage isolé.

---

## PARTIE 7 — Nouvel arc narratif : « l'Accusation »

Adaptation structurelle (pas copie) de l'arc « héros faussement accusé » de Rescue Team.

### Proposition concrète (à valider)

- **Orchestrateur : le Cercle du Suaire** (Banette/Ectoplasma/Nostenfer). Justification
  forte déjà en place : ce sont les descendants des gardiens du sceau (twist arc 6,
  `04_trame_arc1.md`), et le réseau de foreshadowing ch5 (commit a588b56) a déjà posé
  les rêves du héros = mémoire du dernier gardien. **Ils n'accusent pas par malice :
  ils croient sincèrement que le héros, « marqué » par ses rêves et présent à chaque
  pulse, est une menace pour le sceau.** L'accusation est un acte de protection
  dévoyé — ce qui rend leur rédemption/alliance de l'arc 6 crédible au lieu de la
  contredire.
- **Déclencheur** : un Cœur d'Anima s'éteint dans un village (événement réel du plan
  d'Eternatus), et les indices matériels — déposés par le Cercle — désignent le héros,
  déjà vu « parlant seul » près des pulses (ses rêves éveillés).
- **Disculpation** : le registre des pulses de Phileas (posé ch5, session 6) fournit
  la preuve d'alibi — réutilisation d'un élément déjà planté, zéro deus ex machina.
- **Conséquences en jeu** : variantes PNJ « défiance » (le système à 4-6 états existe),
  job board restreint, un donjon de fuite dédié (candidat : Clouded_Road « Route
  Embrumée », palier 4 — brume = clandestinité), accès Metano surveillé.
- **Chapitre d'insertion : ch14-15** (palier 4) — assez tard pour que la réputation
  du héros ait de la valeur à détruire, assez tôt pour que la cicatrice avec le
  Cercle du Suaire mûrisse jusqu'à l'arc 6.
- **Contrainte respectée** : sous-arc de 2 chapitres max, l'intrigue Anima reste le fil.

---

## PARTIE 8 — AUDIT DES 9 POINTS OUVERTS (2026-07-27)

Chaque point vérifié dans le dépôt avec preuves. ✅ = tranché par les faits,
🔶 = recommandation à valider par l'utilisateur.

### 1. Trio du lac — ✅ TRANCHÉ (décision antérieure confirmée)
Les 3 Sentiers (Savoir/Espoir/Courage) sont gardés, **Uxie seul** en légendaire
(gardien de la mémoire des Anima). Mesprit/Azelf = présences évoquées (statues,
fresques). Réservation à inscrire dans `fiches_boss.md` au moment de l'import.

### 2. Boss de Champion_Road — ✅ TRANCHÉ (décision antérieure confirmée)
**Boss narratif dédié**, pas de légendaire. Candidat : le rival au sommet de sa forme
ou un écho corrompu du héros. À concevoir quand la trame ch29-32 sera écrite.

### 3. Jirachi (3 candidats) — ✅ TRANCHÉ 2026-07-27 : option de synthèse validée
- `wishmaker_cave` est un donjon complet jouable (mécaniques de vœu incluses), palier 7,
  et porte la plus forte justification narrative du lot (arc « Fil du Destin » §10.1bis :
  l'humain tombé du ciel il y a 25 ans — réservé arc Jirachi).
- Wish Cave / Mt. Faraway (pmd-red) ne fournissent que des grounds de cinématique 1:1
  avec Jirachi imposé comme boss (règle pmd-red) → redondant si wishmaker_cave est pris.
- **Option de synthèse** : garder wishmaker_cave comme donjon, et importer le ground
  de cinématique Wish Cave pmd-red comme SALLE FINALE (le casting reste Jirachi, donc
  compatible avec la règle 1:1). Un seul Jirachi, deux sources complémentaires.

### 4. Lugia Celestial Peak — ✅ RÉSOLU : pas de conflit réel, les deux plans coexistent
Vérifié dans le dépôt : `FA_Rainbow_Peak_RTRB.tile` est importé mais **référencé par
zéro carte** (grep sur tout `Data/` : 0 usage). L'assignation « Rainbow_Peak → arène
Lugia » n'a jamais été câblée — c'était du papier. État réel du ch10 :
- Cinématique pré-boss : `autel_celeste.rsground` (pmd-red 1:1) — **on garde**.
- Combat (segment 5) : `celestial_peak_boss.rsmap`, actuellement en autotiles
  `concealed_ruins_floor/wall` → **incohérence visuelle** cinématique ciel / arène ruines.
- **Ajout intelligent — ✅ FAIT 2026-07-27** : `celestial_peak_boss.rsmap` retilée
  avec `FA_Rainbow_Peak_RTRB` (sol = mer de nuages, murs = ciel, 4 accents
  arc-en-ciel décoratifs) via `tools/retile_lugia_arena.py`. Géométrie, entrées,
  boss, niveaux : inchangés. Audit flood-fill 104/104, boss atteignable.
  Rainbow_Peak trouve ainsi son usage prévu SANS toucher à l'import pmd-red.

### 5. Numérotation de segment Celestial Peak — ✅ VÉRIFIÉ : rien n'est cassé
`Data/Zone/celestial_peak.json` contient bien 6 segments :
[0] contreforts (RangeDict), [1] relais (Layered→`celestial_peak_relay`),
[2] nuages (RangeDict), [3] Fulgur (Layered→`celestial_peak_fulgur`),
[4] sommet (RangeDict), [5] boss (Layered→`celestial_peak_boss`).
Le « segment 4 » du rapport pmd-red désigne le hook `ExitSegment(segmentID==4)`
(`zone/celestial_peak/init.lua:96-102`) : après le sommet, on entre dans le ground
`autel_celeste`, qui relance `ContinueDungeon(..., 5, ...)` (`ground/autel_celeste/
init.lua:59`) vers le combat du segment 5. Les « [1]/[3]/[5] » de l'ancien audit
désignaient les segments Layered à cartes fixes. Les deux numérotations sont
cohérentes entre elles ; tous les cas 0-5 sont couverts dans `ExitSegment`.

### 6. « Légende de Dotra » — ✅ SOURCE RETROUVÉE : elle existe bel et bien
`Data/Script/halcyon/ground/metano_fire_home/metano_fire_home_ch_5.lua:42-75` :
légende « Celui qui Dort sous les Volcans » racontée par Dotra (Camerupt), flag
`SV.Chapter5.LegendEarthHeard` (`scriptvars.lua:820`), consignée dans
`bible_continuite.md`. Écrite en session 4 de la campagne ch5 (commits 31b7f94→a588b56).
La justification narrative d'un futur import Magma Cavern/Groudon (pmd-red) est donc
**valide et citable**. (Rappel : l'antre Groudon d'EoSO reste exclu — seul le ground
de cinématique pmd-red est candidat, casting Groudon conservé par la règle 1:1.)

### 7. 17 labyrinthes élémentaires pmd-red — ✅ DOUBLON PARTIEL CONFIRMÉ
Le dépôt contient déjà 8 mazes dojo : `bug/electric/fire/flying/grass/normal/rock/
water_maze.json`. Importer les 17 pmd-red créerait 8 doublons directs.
**Décision d'ajout intelligent** : ne PAS importer les mazes pmd-red (ce sont des
donjons procéduraux, pas des assets — rien à récupérer techniquement). À la place,
**compléter notre propre système dojo avec les 9 types manquants** (glace, combat,
sol, psy, poison, spectre, dragon, ténèbres, acier) en clonant le patron existant,
déblocage progressif job board avancé (palier 8 pour les derniers).
**✅ VALIDÉ par l'utilisateur le 2026-07-27** — à exécuter (étape 6 du plan).

### 8. Orchestrateur de l'Accusation — ✅ TRANCHÉ 2026-07-27 : Cercle du Suaire validé
Voir Partie 7. La motivation « protection du sceau dévoyée » transforme le sous-arc
en tremplin du twist arc 6 au lieu d'un détour. Team Dazzling = trop frontale,
équipe Luxray (Fulgur) = déjà utilisée comme rivaux→alliés ch6-10.

### 9. Knightcore — ✅ ABANDONNÉ (repo Codeberg privé), sauf accès manuel fourni.

---

## PARTIE 8bis — CRITÈRE ÉLARGI : lieux officiels par boss (directive 2026-07-27)

Règle : pour chaque boss, chercher un lieu associé dans N'IMPORTE QUEL jeu
Pokémon (PMD ou jeu principal) importable comme donjon/arène. Recherche
rouverte sur tous les dépôts fournis + décomps pret.

| Boss | Lieu officiel (tous jeux) | Source importable ? | Décision |
|---|---|---|---|
| **Regigigas (ch7)** | Aegis Cave (PMD Sky) ; Temple Frimapic (D/P) | ✅ EoSO (tilesets convertis PMDO) | **✅ FAIT** : `sanctuaire_titans.rsmap` (« Sanctuaire des Titans »), arène 1:1 25×27, Regigigas 28 + **trio Regirock/Regice/Registeel 26**, branchée cloven_ruins seg3. Ancienne arène gardée en secours. |
| Trio Regi seul | Ruines du Désert / Grotte Island / Tombeau Antique (Émeraude) | ✅ pret/pokeemerald (décomp dispo) | RÉSERVE — candidats donjons secondaires « Trois Serviteurs » ch11+ (nécessite pipeline gen 3, cf. ci-dessous) |
| **Diancie (ch8)** | Domaine Diamant = FILM uniquement ; en jeu : event de distribution, aucune carte | ❌ aucune carte n'existe dans aucun jeu | Arène New Era conservée (rien à importer — vérifié) |
| **Laggron (ch9)** | Aucun : Laggron est un starter, jamais de lieu dédié (boss inventé New Era, gardien du Marais) | ❌ | Arène New Era conservée |
| **Zarude (ch6)** | Forêt d'Okoya = FILM (Secrets de la Jungle) ; event SwSh sans zone dédiée | ❌ (Switch, pas de décomp 2D) | Arène New Era conservée ; option cosmétique : tilesets ForestDark/NightForest (ProjectEoN) pour une variante nocturne de la Forêt Lugubre |
| Escouade Fulgur (ch10) | Équipe originale New Era | — | Arène New Era |
| **Lugia (ch10)** | Sky Tower Summit + Silver Trench (pmd-red) ; Îles Tourbillon (Or/Argent/Cristal) ; Grotte Océane/Navel Rock (Émeraude) | ✅ pmd-red fait ; pokecrystal/pokeemerald dispo | **✅ FAIT** (autel_celeste) ; Îles Tourbillon/Navel Rock = réserve gen 2/3 |

### Inventaire des dépôts fournis (re-vérifié 2026-07-27)

- **EoSO (Minemaker0430)** : 146 tilesets convertis PMDO — dont les 4 Aegis
  (récupérés → `Titans_*`), le reste = réserve boss rooms (2e passe à faire).
- **minior-game-jam (CregALeg)** : 9 tilesets — `High Stardust Peak` /
  `Stardust Pinnacle` = candidats parfaits pour l'arc Minior/Météno (§10 VEIL-RAYQ).
- **ProjectEoN** : ForestDark / NightForest / uproarforest_edited confirmés présents.
- **pret/pmd-sky** : décomp NDS — formats BPC NDS lisibles par skytemple-files
  (contrairement au GBA) ; pipeline possible pour les grounds Sky si besoin.
- **pret/pokeemerald, pokecrystal, pokediamond** : décomps disponibles —
  ouvrent les lieux des jeux principaux (Îles Tourbillon, ruines des Regis,
  Temple Frimapic…). Nouveau pipeline à construire si validé.
- **« zorua »** : aucun dépôt zorua trouvé dans ce qui a été fourni ni sur
  GitHub — fournir le lien si ce mod existe.

## PARTIE 9 — PLAN D'EXÉCUTION

**Validations utilisateur du 2026-07-27** : point 3 = synthèse Jirachi (wishmaker_cave
+ ground Wish Cave pmd-red en salle finale), point 4 = retiling Rainbow_Peak (fait),
point 7 = les 9 mazes manquants (oui), point 8 = Cercle du Suaire (validé).

1. ~~Validation utilisateur~~ — faite (ci-dessus).
2. ~~Vague 2 — secondaires ch2-10~~ — **✅ FAIT 2026-07-27** : 15 donjons DumpAsset
   importés/câblés (`docs/vague2_donjons_secondaires.md`), avec 20 OST, 44 cartes,
   1 tileset, purge scripts sources, job board + déblocages + rétroactif.
   Substitutions : muddy_valley→bramble_woods, royal_garden→royal_halls,
   glacial_path→barren_tundra (absents de la source). Les 4 candidats EoSO
   (Grotte Fumante ch5, Verger Sauvage ch6, Antre de la Cascade ch7, Grotte de
   Cristal ch8) restent à faire dans une passe EoSO dédiée.
3. **Retiling arène Lugia** (`celestial_peak_boss.rsmap` → FA_Rainbow_Peak_RTRB) +
   audit spatial du segment 5.
4. **Passe Friend Area « salle de boss »** (2e lecture du dossier complet).
5. **pmd-red industrialisation** — une zone à la fois, même rapport que le pilote.
   Ordre candidat : Magma Cavern/Groudon (justifié point 6), puis selon besoins des
   arcs 11+.
6. **9 mazes dojo complémentaires** (types manquants).
7. **Mega_Stones** : import items + dialogue Saphir FR + branchement (verrou
   `StoryCompleted`).
8. **Réserve ch11+** : n'entre en jeu que quand la trame détaillée 11-32 est écrite ;
   l'arc de l'Accusation (ch14-15) sera le premier bloc rédigé.

**Après chaque vague : AUDIT FINAL** — spatial (§11 : bornes, collision, flood-fill
depuis Main_Entrance_Marker, Boss_Entrance), narratif (§10 : `narrative_audit_log.md`),
tracker (`integration_tracker.md`), fiches boss anti-répétition (`fiches_boss.md`),
puis commit + push.
