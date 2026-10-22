# Journal d'audit narratif global (directive §10)

## Audit du 2026-07-26

```
Date de l'audit : 2026-07-26
Chapitres couverts : 1 à 10 (focus 5, 7, 8, 9, 10)
Ressources vérifiées (réf. docs/integration_tracker.md) :
  - Relais ch5 (vast_steppe_midpoint, searing_tunnel_midpoint, mount_windswept_midpoint)
  - Chaîne complète ch7 (cloven_ruins_entrance/midpoint/boss + rsmaps)
  - Chaînes ch8-10 (entrées, relais, arènes Diancie/Laggron/Lugia/Escouade Fulgur)
  - gloomy_forest_exit_witness (ProjectEoN, déjà validé)
  - mount_windswept_guardian (DumpAsset, déjà validé)

Incohérences trouvées :
  1. [10.1 origine invisible] Aucun identifiant, flag ou nom de fichier ProjectEoN résiduel
     détecté dans les grounds/scripts touchés (grep IDs/flags : néant). RAS.
  2. [10.2 continuité] Les zones ch8-10 étaient déclarées dans les menus de Metano
     mais physiquement inaccessibles (mappings 52/53/54 → gloomy_forest_boss/testmap/
     test_grounds ; grounds absents de master_zone ; .rsmap des segments LoadGen
     inexistants). Un joueur déverrouillant ces donjons aurait constaté l'incohérence.
     → CORRIGÉ (voir docs/audit_spatial_relais_boss_2026-07-26.md).
  3. [10.2 continuité] cloven_ruins (ch7) référencé par les scripts de zone mais absent
     du menu de destinations → donjon d'histoire injoignable depuis la ville. CORRIGÉ.
  4. [10.3 règles internes] Les relais ch8-10 ne respectaient pas le patron canonique
     Statue Kangourex (pas de sauvegarde, pas de stockage, pas de sortie retour,
     marker décoratif dans un mur). Uniformisé sur le patron searing_tunnel_midpoint —
     mêmes conventions SV.ChapterX.*, même musique de relais (Spring Cave.ogg).
  5. [10.3 règles internes] Escouade Fulgur : les scripts utilisaient les entrées
     génériques Luxray (PNJ « Rulux » de Metano) → collision d'identité de PNJ.
     Instances dédiées Fulgur_* créées (Voltra/Aegis/Solaire).
  6. [10.2 continuité — OUVERT] ch9 : la trame annonce Mega-Blastoise, l'arène utilise
     Laggron (Swampert). Choix conservateur documenté dans le tracker ; à trancher.
  7. [10.2 continuité — OUVERT] Aucun déclencheur ne fait passer Chapter 6→7→8→9→10
     (aucun `SV.ChapterProgression.Chapter = 7/8/9/10` hors debug, sauf le passage
     5→6 existant). Les chapitres 7-10 restent du contenu préparé, non câblé dans la
     progression. C'est le prochain chantier scénario, hors périmètre spatial du jour.

Actions correctives : items 2-5 corrigés dans ce commit ; items 6-7 ouverts et tracés.

Verdict global : le joueur peut-il sentir le patchwork ? NON pour les chapitres 1-6
(jouables, cohérents, aucun résidu de mod source). Pour 7-10 : les coutures techniques
sont refermées (zones atteignables, relais uniformes, boss justifiés par le lore Anima),
mais le contenu n'est pas encore raccordé à la progression — il est invisible pour le
joueur tant que l'item 7 n'est pas traité, donc aucune « salade de fruits » exposée.
```

## Audit du 2026-07-26 (bis) — conversion des relais en grounds officiels

```
Date de l'audit : 2026-07-26 (2e passage)
Chapitres couverts : 3, 5, 6, 7, 8, 9, 10 (tous les relais)
Ressources vérifiées : 8 relais convertis depuis DumpAsset (voir docs/relais_grounds_officiels_2026-07-26.md)

Incohérences trouvées :
  1. [10.1 origine invisible] Tous les MapChars des camps officiels supprimés (Rival,
     NPC_*, Snorlax, Xatu, Wigglytuff...), objets de gameplay du jeu de base retirés
     (Assembly, Storage, boutiques, Ferry, gates). Noms/AssetName/Comment réécrits.
     Aucun flag SV du jeu de base réutilisé (guildmaster_summit -> corniche neutre).
  2. [10.3 règles internes] Les 8 relais suivent désormais le même patron :
     Kangaskhan_Rock (Action) + exits (Touch) + TEAMMATE_1..3 + Main_Entrance_Marker.
     gloomy_forest_midpoint garde sa règle spécifique ch6 : sortie unique en avant.
  3. [10.2 continuité] Musiques réassignées par biome (Cliff/Canyon/Cave/Snow/Summit),
     cohérentes avec la progression des chapitres.

Actions correctives : aucune restante sur ce périmètre.

Verdict global : le joueur peut-il sentir le patchwork ? NON — les relais sont
désormais des cartes de qualité officielle, dépouillées de toute identité du jeu
de base, avec le même vocabulaire d'interaction New Era partout. Réserve : test
en jeu encore requis (rendu visuel + déclenchement des cinématiques recalées).
```

## Audit du 2026-07-26 (ter) — plan d'assignation multi-sources + drapeau fin d'histoire

```
Date de l'audit : 2026-07-26 (3e passage)
Chapitres couverts : 1-10 (état réel) + cadrage 11-32 (expansion)
Ressources vérifiées : aucune nouvelle map importée dans ce passage — travail de
  planification (docs/plan_assignation_donjons_multi_sources.md) + 1 flag de code.

Incohérences trouvées :
  1. [10.2] Le mega-prompt suppose 32 chapitres et un barème de niveaux P1-P8 ;
     le dépôt réel s'arrête au ch10 avec des boss L40-48 (Zarude 42, Regigigas 45,
     Diancie 40, Laggron 42, Lugia 48) — incompatible avec le barème (~25-35).
     DÉCISION OUVERTE ET BLOQUANTE : reniveler ch6-10 (option a, recommandée)
     ou décaler le barème (option b). Documentée §1.2 du plan.
  2. [10.3] Le script cliff_camp du mod Mega_Stones référence
     SV.guildmaster_summit.GameComplete, non déclaré chez nous -> crash potentiel
     si branché tel quel. Remplacé dans le plan par le nouveau drapeau canonique
     SV.ChapterProgression.StoryCompleted (déclaré + posé à la victoire Lugia +
     garde-fou OnUpgrade debug_tools pour les sauvegardes existantes).
  3. [10.1] Deux doublons d'assets repérés AVANT import (prévention) :
     end_treacherous_mountain déjà = mount_windswept_guardian ;
     end_moonlit_temple déjà = cloven_ruins_midpoint. Les donjons PMDODump
     correspondants devront changer d'arène/de section s'ils sont repris.
  4. [10.2] Chapitres 1-10 : règle « 2-3 secondaires/chapitre » non tenue
     (quasi aucun secondaire hors Imbion). Le plan comble avec 27 secondaires
     assignés ch1-10 avant toute expansion ch11+.

Actions correctives : plan écrit ; StoryCompleted implémenté ; le reste attend
  la décision §1.2 (renivelage) avant toute vague d'import.

Verdict global : le joueur peut-il sentir le patchwork ? NON en l'état (rien
d'importé ce passage). Risque principal identifié pour la suite : la courbe de
niveaux ch6-10 actuelle, qui trahirait l'ajout tardif de contenu intermédiaire
si elle n'est pas renivelée avant les imports de secondaires.
```

## Audit du 2026-07-26 (quater) — vague 1 + renivelage option (a)

```
Date de l'audit : 2026-07-26 (4e passage)
Chapitres couverts : 1-10
Ressources vérifiées : 7 donjons secondaires vague 1 (réf. tracker), 7 combats
  de boss renivelés, 11 cartes génériques + 12 musiques officielles importées.

Incohérences trouvées :
  1. [10.1] Scripts des mods sources purgés des 7 zones (Tutorial/ZMDO,
     Mysteriosity, SpawnRandomTutor, CastawayCave*, ShopkeeperInteract) —
     38 occurrences supprimées, 0 résiduelle (vérifié par motif). Cartes de fin
     renommées en IDs New Era. Aucun SV étranger référencé.
  2. [10.2] Courbe de niveaux réparée : boss ch6-10 renivelés 27→35 (option a
     choisie par l'utilisateur). Les futurs paliers P3+ (ch11-32) ont maintenant
     l'espace 35-85. Spawns gloomy (L21-24) cohérents avec Zarude L27.
  3. [10.2] Les niveaux des donjons vague 1 (5→15) s'insèrent correctement
     entre riverbed (8) et vast_steppe (16) sur le job board.
  4. [10.3] Conventions respectées : patron zone secondaire (retour Metano),
     mission_gen (difficulté+niveau), déblocages par chapitre + rétroactifs.

Actions correctives : aucune requise.

Verdict global : le joueur peut-il sentir le patchwork ? NON — les 7 donjons
sont des biomes génériques renommés en français, purgés de toute mécanique
des mods sources, insérés dans la même boucle job board que les donjons
existants. Réserve habituelle : test en jeu requis (génération procédurale
des 7 zones + équilibrage post-renivelage).
```

## Audit du 2026-07-26 (quinquies) — Prompt Maître scénariste : cadrage + correctifs immédiats

```
Date de l'audit : 2026-07-26 (5e passage)
Chapitres couverts : 1-10
Ressources vérifiées : boutiques Metano, intros de boss ch8-10, couverture missions.

Incohérences trouvées et corrigées :
  1. [Prompt Maître §8] La Boutique d'Échange (Ambipom, « Swap ») restait CACHÉE
     à tous les chapitres (Hide dans ch2/3/4/5/6/8/9/10) alors qu'elle devait
     ouvrir au retour de l'expédition (ch6) — c'était le dernier commerce
     indisponible prévu par Palika. CORRIGÉ : Unhide ch6/8/9/10 (le handler
     Swap_Action et ses 14 clés FR existaient déjà, prêts à servir).
  2. [Addendum C.1 couverture] Les donjons principaux ch7-10 n'alimentaient pas
     le job board une fois terminés (missions « de rappel » exigées). CORRIGÉ :
     ajoutés à DUNGEON_LIST avec difficultés S/S/S/STAR_1 et niveaux attendus
     26/28/30/33 (post-renivelage). Le filtre moteur (Completed) garantit
     qu'ils n'apparaissent qu'après avoir été finis.
  3. [Addendum A] Les intros de boss ch8-10 n'appliquaient pas le système
     3 couches (flash générique seul, pas de couche biome ni signature).
     CORRIGÉ : BossFX étendu (EmergeWater — séquence A.3 Laggron complète,
     AwakenCrystal — activation cristalline, PushBack — recul du groupe) ;
     intros réécrites : Diancie (activation gemmes), Laggron (jaillit de la
     vase + amorce Telluriforce), Lugia (descente du ciel + déploiement
     d'ailes + jugement). Toutes particules/SE vérifiées existantes.
  4. [Prompt Maître §6] Absence de bible de continuité. CRÉÉE
     (docs/bible_continuite.md) : PNJ + statuts, boutiques par chapitre,
     quêtes ouvertes, écarts assumés (quota 7000 lignes = production long
     terme ; heure intra-journée = chantier moteur).
  5. [Addendum D] Absence de fichier de fiches boss. CRÉÉ (docs/fiches_boss.md)
     avec catalogue anti-répétition et réservations pour les boss futurs
     (Jirachi, Uxie, Cresselia, Giratina, Yveltal).

Actions restantes (chantiers désignés, non bloquants) :
  - Écriture des chapitres au quota 7000 lignes (sessions dédiées).
  - Mise en scène des Monster Houses + PNJ inoffensifs en donjon (vague 2).
  - Cinématique comique Rondoudou (candidate : Plum la Jigglypuff, déjà
    dans CharacterEssentials).
  - Donjons inventés C.2 (mécaniques mapgen dédiées).

Verdict global : le joueur peut-il sentir le patchwork ? NON. Les correctifs
de ce passage réduisent au contraire deux coutures visibles (boutique
fantôme, boss ch8-10 aux intros interchangeables).
```

---

## Audit §10 — 2026-07-27 : retiling arène Lugia (Rainbow_Peak)

- **Changement** : `celestial_peak_boss.rsmap` passe des autotiles
  `concealed_ruins_*` (ruines grises génériques, incohérentes après la
  cinématique céleste) au tileset `FA_Rainbow_Peak_RTRB` : sol = mer de
  nuages, murs = ciel bleu, 4 accents arc-en-ciel décoratifs hors zone jouable.
- **Cohérence de chaîne ch10** : sommet (segment 4) → Autel des Cieux
  (ground pmd-red 1:1, fond « Sky » animé) → combat Lugia désormais dans le
  même registre visuel céleste. La couture ruines/ciel disparaît.
- **Aucun texte modifié**, aucun nom de source visible (tileset renommé FA_*
  RTRB dès l'import initial). Positions, niveaux, entrées : inchangés.
- **Verdict** : le joueur peut-il sentir le patchwork ? NON — au contraire,
  cette passe supprime la dernière rupture visuelle du climax du ch10.

---

## Audit §10 — 2026-07-27 : vague 2 (15 secondaires ch2-10)

- Renommages FR originaux, zéro trace des mods sources dans les assets
  (2 renames de cartes internes en *_fond/*_secret ; tileset technique
  NorthernDesert1OwnWall conservé tel quel : nom générique du jeu de base).
- Substitutions assumées : muddy_valley→Bois des Ronces, royal_garden→Halles
  Royales, glacial_path→Toundra Désolée (zones absentes de la source, rôle
  narratif équivalent conservé).
- Cohérence de progression : chaque secondaire arrive au chapitre où son thème
  sert l'histoire (désert asséché/geode = indices Anima ch6, bassin tari =
  presage du Marais ch9, col de la Foudre = territoire Fulgur ch10).
- OST dédiés importés : chaque donjon garde son ambiance sonore propre au lieu
  de recycler les 68 pistes existantes.
- Verdict : le joueur peut-il sentir le patchwork ? NON — les 15 zones suivent
  le même patron (déblocage narratif, job board, retour Metano) que la vague 1
  déjà en place.

---

## Audit §10 — 2026-07-27 : vague 7 (42 cinématiques d'Ancrage)

- Templates des dépôts d'origine conservés 1:1 (grounds pmd-red/Explorers/
  Friend Areas) — SEULS les dialogues changent, comme demandé.
- Narration : voix du gardien avant l'image (Rescue Team), partenaire qui
  verbalise le détail signature (Explorers), lignes courtes, pauses dosées.
- Cohérence Livre I : Lugia ch19 se souvient du ch10 (« même chant, plus
  triste ») ; Rayquaza paie la légende de Reinier ch5 ; Jirachi paie le
  « tombé du ciel il y a 25 ans » (Fil du Destin) ; Necrozma recontextualise
  sans contredire la règle ch5 (jamais nommé avant l'heure) ; Eternatus rend
  le twist visible (couloir pourpre = ce que les Cœurs retenaient).
- Anti-doublon : 28 motifs FX distincts pour 42 scènes, aucun couple
  (irruption, signature) répété ; duos scénarisés (Cresselia/Darkrai liés par
  l'Ancrage, Latios/Latias duo de vol, Entei/Victini pari, Mew/Hoopa jeu).
- Rematch : dialogue dédié court — pas de re-cérémonie (respect du joueur).
- Verdict patchwork : NON — chaque gardien a une raison d'être là, une voix
  propre, et un lien au moins avec un élément posé aux ch1-10.
