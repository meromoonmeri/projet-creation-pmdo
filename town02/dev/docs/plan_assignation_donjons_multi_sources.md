# [ARCHIVE — fusionné dans DOCUMENT_MAITRE_donjons_externes.md le 2026-07-27]
# Ne plus mettre à jour ce fichier ; il est conservé comme trace historique.

# Plan d'assignation — Réutilisation totale de donjons (toutes sources)

Date : 2026-07-26
Réponse à la « Prochaine étape » (§12) du mega-prompt : vérification du budget de chapitres réellement occupé, puis assignation de chaque donjon retenu.

---

## 1. RÉALITÉ DU DÉPÔT vs PRÉMISSES DU PROMPT — à trancher avant tout

Deux écarts majeurs entre le mega-prompt et l'état réel du dépôt. **Le plan ci-dessous est calé sur le dépôt réel**, avec une réserve pour l'expansion.

### 1.1 Le jeu actuel s'arrête au chapitre 10, pas 32

`scriptvars.lua` déclare `SV.Chapter1` à `SV.Chapter10` — rien au-delà. Le dernier contenu est le Pic Céleste (Lugia, vision Necrozma). Le barème du prompt (paliers 1-8 sur 32 chapitres) est donc un **plan d'expansion**, pas une description de l'existant.

### 1.2 Les niveaux réels ne suivent pas le barème du prompt

Niveaux **mesurés dans les .rsmap du dépôt** :

| Chapitre | Boss | Niveau réel | Barème prompt (palier) | Écart |
|---|---|---|---|---|
| 3 | Luxio & co | 9-10 | ~15 (P1) | ok |
| 5 | mini-boss/gardiens | 16-22 | ~25 (P2) | ok |
| 6 | Zarude | **42** | ~25 (P2) | **+17** |
| 7 | Regigigas | **45** | ~25 (P2) | **+20** |
| 8 | Diancie | **40** | ~25 (P2) | **+15** |
| 9 | Laggron | **42** | ~35 (P3) | **+7** |
| 10 | Lugia | **48** | ~35 (P3) | **+13** |

**Décision requise (bloquante pour l'équilibrage)** : soit (a) on renivelle les boss ch6-10 vers le barème (Zarude ~25, Regigigas ~28, Diancie ~30, Laggron ~32, Lugia ~35) pour laisser de la marge aux 22 chapitres suivants — recommandé si les 32 chapitres sont confirmés ; soit (b) on garde les niveaux actuels et le barème est décalé (+15 partout). **Le plan ci-dessous suppose (a).**

### 1.3 Budget déjà occupé (vérifié dans le dépôt)

| Ch. | Donjons principaux existants | Secondaires existants |
|---|---|---|
| 1 | Forêt Relique | mazes dojo (déblocage progressif) |
| 2 | Rivière Illuminée | — |
| 3 | Caverne Tortueuse | — |
| 4 | Bosquet Apricorn | — |
| 5 | Grande Steppe + Tunnel Incandescent + Mont Venteux | — |
| 6 | Forêt Lugubre | zone légendaire Zarude (verdant_oath) |
| 7 | Aegis Cave (Regigigas) | — |
| 8 | Sanctuaire de Cristal (Diancie) | — |
| 9 | Marais de l'Oubli (Laggron) | — |
| 10 | Pic Céleste (Lugia + Escouade Fulgur) | — |
| hors histoire | — | 7 donjons Imbion (job board), 8 mazes dojo |

Constat : les chapitres 1-10 sont **saturés en principaux** (le ch5 en a même 3) mais **pauvres en secondaires** (règle « 2-3 secondaires par chapitre » non tenue). Priorité n°1 du plan : combler les secondaires 1-10 avant d'ouvrir le ch11+.

---

## 2. ASSIGNATION — chapitres 1-10 (comblement des secondaires)

Filtre à 3 questions appliqué ; sources courtes et à faible risque de reconnaissance en premier.

| Donjon source | Rename FR | Source | Ch. | Étages | Rôle narratif (Q1) / adaptation (Q2) / règle (Q3) |
|---|---|---|---|---|---|
| mystery_cave (ZMDO) | Grotte du Mystère | ZMDO | 2 | 10 | Première rumeur de « cristaux qui chantent » — préfigure le Sanctuaire ch8 / re-génération en RangeDictSegment (actuellement séquence fixe) / patron zone secondaire |
| mystery_grove (ZMDO) | Bosquet Voilé | ZMDO | 1 | 10 | Zone d'entraînement post-tutoriel près de Metano / re-génération + spawns palier 1 / secondaire |
| mystery_dungeon (ZMDO) | Antre de l'Énigme | ZMDO | 3 | 10-12 | Mission de guilde « disparitions » parallèle à la Caverne / re-génération / secondaire |
| Tiny_Tunnel | Petit Tunnel | PMDODump | 1 | 10 | Première mission job board / renivelage P1 / secondaire |
| Fertile_Valley | Vallée Fertile | PMDODump | 2 | 10-12 | Escorte fermiers Zigzaton / renivelage / secondaire |
| Cave_Of_Solace | Grotte du Repos | PMDODump | 2 | 10-12 | Sauvetage simple / renivelage / secondaire |
| Copper_Quarry | Carrière de Cuivre | PMDODump | 3 | 12 | Livraison minerai — lien PNJ Roche de Metano / renivelage / secondaire |
| Muddy_Valley | Vallée Boueuse | PMDODump | 3 | 10-12 | Mission boue/pluie / renivelage / secondaire |
| Royal_Garden | Jardin Royal | PMDODump | 4 | 12 | Réception guilde — cadre « civilisé » avant l'expédition ch5 / renivelage / secondaire |
| Castaway_Cave | Grotte de l'Échoué | PMDODump | 4 | 12 | Naufragé à secourir sur la côte / renivelage / secondaire |
| Secret_Garden | Jardin Secret | PMDODump | 4 | 12-14 | Zone cachée, teaser Anima végétale / renivelage / secondaire |
| Ambush_Forest | Forêt de l'Embuscade | PMDODump | 5 | 13-14 | Bandits sur la route de l'expédition / renivelage / secondaire |
| Trickster_Woods | Bois du Filou | PMDODump | 5 | 13-14 | Voleur d'objets du camp / renivelage / secondaire |
| Steam Cave (EoSO) | Grotte Fumante | EoSO | 5 | 14 | Variante géothermique près du Tunnel Incandescent / **restructuration layout** + tileset OK / exigence renforcée EoSO validée (biome générique) |
| Forsaken_Desert | Désert des Oubliés | PMDODump | 6 | 14-16 | Piste des Anima asséchés / renivelage / secondaire |
| Geode_Crevice | Crevasse de Géode | PMDODump | 6 | 14-16 | Minerais résonnant avec les Cœurs / renivelage / secondaire |
| Apple Woods (EoSO) | Verger Sauvage | EoSO | 6 | 14 | Ravitaillement guilde / retravail faible (biome générique) / secondaire |
| Waterfall Cave (EoSO) | Antre de la Cascade | EoSO | 7 | 16 | Passage caché vers les Ruines / retravail faible / secondaire |
| Energy_Garden | Jardin d'Énergie | PMDODump | 7 | 16 | Concentration d'Anima vivante — écho au Cœur des Ruines / renivelage / secondaire |
| Crystal Cave (EoSO) | Grotte de Cristal | EoSO | 8 | 16-18 | Antichambre naturelle du Sanctuaire (distincte du tileset ZMDO ch2) / restructuration modérée / secondaire |
| Glacial_Path | Sentier Glaciaire | PMDODump | 8 | 16 | Route gelée vers le Sanctuaire / renivelage / secondaire |
| Wayward_Wetlands | Marais Errants | PMDODump | 9 | 18 | Approche du Marais de l'Oubli / renivelage / secondaire |
| Depleted_Basin | Bassin Tari | PMDODump | 9 | 16-18 | Bassin vidé de son Anima — indice avant le boss / renivelage / secondaire |
| Amp Plains (EoSO) | Plaines Battues | EoSO | 9 | 18 | Orages permanents, Cercle du Suaire rôdant / restructuration modérée / secondaire |
| Thunderstruck_Pass | Col de la Foudre | PMDODump | 10 | 18-20 | Territoire de l'Escouade Fulgur / renivelage / secondaire |
| Flyaway_Cliffs | Falaises de l'Envol | PMDODump | 10 | 18-20 | Contreforts du Pic / renivelage / secondaire |
| Snowbound_Path | Sentier Enneigé | PMDODump | 10 | 18 | Approche enneigée du Pic / renivelage / secondaire |

Barème étages recalé : ch1-4 = 10-12(-14), ch5-7 = 13-16, ch8-10 = 16-20 (secondaires). Cohérent avec l'existant (Steppe 14, Tunnel 15+arène, Mont 13).

---

## 3. RÉSERVE — chapitres 11+ (expansion vers 32)

Non assignés à un chapitre précis tant que la trame 11-32 n'est pas écrite. Classés par palier prompt, rangés par thème :

- **P3-4 (ch11-16)** : Barren_Tundra, Veiled_Ridge, Deserted_Fortress, Magnetic_Quarry, Exotic_Wilds, Sleeping_Caldera, Lava_Floe_Island, Illusory_Ridge, Clouded_Road, Trickster_Maze, Overgrown_Wilds, Sea_Current_Maze, Treacherous_Mountain*, Mont Rocaille (fusion Bristle/Horn/Travail, EoSO), Désert Boréal (EoSO), Forêt des Ombres Sèches (EoSO), Forêt Trompeuse (EoSO), Grotte des Embruns (EoSO).
  - *Treacherous_Mountain : ⚠ son ground final `end_treacherous_mountain` est **déjà utilisé** comme `mount_windswept_guardian` (ch5). Si le donjon est repris, il lui faut une autre arène — sinon doublon visuel visible.
- **P5 (ch17-20)** : Moonlit_Courtyard*, Relic_Tower, Abyssal_Island, Eon_Island Grotte/Côte, Wisdom/Hope/Bravery Road (voir §5).
  - *Moonlit_Courtyard : ⚠ `end_moonlit_temple` est **déjà utilisé** comme `cloven_ruins_midpoint` (relais ch7). Prendre le courtyard sans le temple final, ou changer l'arène.
- **P6 (ch21-24)** : Eon_Island Plaine/Cime (Latios & Latias), Temple du Clair de Lune (Cresselia), Hauteurs de l'Étoile Filante (Solgaleo), Vallée de l'Oubli (Yveltal), Grotte des Embruns si pas prise plus tôt.
- **P7 (ch25-28)** : Faille Primordiale (Giratina), Le Ciel Suspendu (Zygarde), Profondeurs de Braise-Givre (dungeon-pack), Grotte du Vœu (Jirachi — **origine des Anima**, la plus forte justification narrative du lot ; à caler sur l'arc final).
- **P8 (ch29-32 / fin de contenu)** : Sentier du Champion, Pic de l'Aventurier (dungeon-pack, gauntlet).

Chaque légendaire de cette réserve reste soumis à la règle §5 de la directive : pas de fiche narrative validée → pas d'intégration, même si la map est prête.

## 4. Tilesets/à-côtés (pas des donjons)

- ProjectEoN (6 tilesets curatés) : DrenchedBluffEnd→côte future, CrumblingCanyon→canyon post-ch10, ForestDark→variante Forêt Lugubre, Cloudless*→variantes Pic Céleste, GuildMesshall/GuildmasterRoomNight→guilde Metano. Import à la demande, via ré-indexation hash (procédure gloomy_forest_exit_witness).
- Friend Area : Volcanic_Pit→Crucible, Peanut/Poison_Swamp→Marais, Rainbow_Peak→arène Lugia, Stratos_Lookout→arène Fulgur, Ancient_Relic→Aegis Cave, Frigid_Cavern/Furnace_Desert→réserve glace/désert. NB : `FA_Rainbow_Peak_RTRB.tile` est déjà dans le dépôt.
- Checkpoints dungeon-pack (blaze/cove/elemental/forest/frost/rocky) : à mapper sur le patron Kangourex existant pour tout donjon 15+ étages de la réserve. Les scripts `source_duns_imbi/ground/{base,canyon,cliff,forest}_camp` déjà présents serviront de pont.
- EoSO objets/particules (86+18) : tri séparé, VFX génériques présumés sûrs — inventaire à faire avant import.

## 5. Points « à trancher » (§11 du prompt) — recommandations

1. **Trio du lac (Wisdom/Hope/Bravery Road)** : GARDER les trois donjons, mais **un seul** avec légendaire (Uxie, gardien de la mémoire des Anima — le plus raccord avec le lore). Mesprit/Azelf deviennent des présences évoquées (statues, fresques) pour éviter l'inflation de légendaires. Palier 5.
2. **Champion_Road** : boss **narratif dédié** plutôt qu'un légendaire — recommandation : le rival de la guilde au sommet de sa forme (ou un écho corrompu du héros). Aucun asset légendaire requis.
3. **Knightcore** : abandonné (repo privé), conforme au prompt.
4. **EoSO exclusions** confirmées et définitives : Guilde, Treasure Town/Spinda, Temporal Tower/Spire, Hidden Land/Old Ruins/Rainbow Stoneship, Aegis Cave (doublon Regigigas ch7), antre Groudon, antre Darkrai.

## 6. Mega_Stones — réponse à la demande de confirmation

**Question : quelle variable marque « histoire terminée » ?**

Vérifié dans le dépôt :
- Il n'existe **aucun** drapeau global de fin d'histoire. Les candidats existants sont partiels : `SV.Chapter10.DefeatedLugia` / `SV.Chapter10.CelestialPeakComplete` (fin du contenu actuel) ; `SV.guildmaster_summit.GameComplete` est référencé par le script `cliff_camp` du mod Mega_Stones importé **mais n'est pas déclaré** dans notre `scriptvars.lua` (qui n'a que `ExpositionComplete`/`BattleComplete`) — s'appuyer dessus crasherait.
- **Décision implémentée** : création de `SV.ChapterProgression.StoryCompleted` (défaut `false`), posé à la victoire contre Lugia (fin de contenu actuelle), avec garde-fou `OnUpgrade` pour les sauvegardes existantes. Quand les chapitres 11-32 existeront, **déplacer uniquement le point d'allumage** vers la vraie fin — la condition de déblocage des Méga-Pierres, elle, ne changera pas (`SV.ChapterProgression.StoryCompleted == true`).

**Conflits post-game vérifiés** : le seul contenu post-game existant est `LegendZones` (zones de revanche Grodoudou). Pas de conflit — les deux systèmes sont complémentaires (revanches légendaires = source naturelle d'« Éclats d'Âme » en post-game). Aucun autre déblocage de fin de jeu trouvé.

**État d'intégration Mega_Stones dans le dépôt** : les scripts `Data/Script/megastones/` + `shady_shop.rsground/.tile/.json` sont présents mais **non branchés** (ni `main.lua` ni `event.lua` de halcyon ne les chargent ; `Data/Item/` ne contient aucune `mega_*.json` — 0 pierre importée). L'écriture du dialogue FR de Saphir et le branchement complet restent à faire **après** validation de ce plan ; le crochet de déblocage est prêt.

## 7. Ordre d'exécution proposé

1. ~~Drapeau `StoryCompleted`~~ — fait dans ce commit.
2. Trancher §1.2 (renivelage des boss ch6-10) — bloquant pour tout import équilibré.
3. Vague 1 : les 3 donjons ZMDO (petits, sûrs) + 4 donjons PMDODump palier 1 → comble les secondaires ch1-4.
4. Vague 2 : secondaires ch5-10 (PMDODump + les 4 EoSO à retravail faible/modéré).
5. Vague 3 : checkpoints dungeon-pack adaptés au patron Kangourex pour les donjons 15+.
6. Mega_Stones : import des 49 items, branchement scripts, dialogue Saphir FR, boutique verrouillée jusqu'à `StoryCompleted`.
7. Réserve ch11+ : uniquement quand la trame 11-32 est écrite.

Chaque vague suit la boucle complète : fiche §7 de la directive + tableau de suivi + audit spatial §11 + audit narratif §10 avant commit.
