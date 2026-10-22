# Fiches Boss — Système d'animation d'entrée à 3 couches (Addendum A)

Outil de suivi anti-répétition. Chaque boss majeur a sa combinaison **biome + détail signature** unique.
Bibliothèque technique : `Data/Script/halcyon/BossFX.lua` (toutes les particules/BG vérifiées existantes).

## Grammaire générique (couche 1 — commune à tous)

1. Voix de l'Abysse (`BossFX.Voice`) — toujours AVANT l'apparition.
2. Irruption selon le biome (couche 2).
3. Recul du groupe (`BossFX.PushBack` — AnimateInDirection "Hurt" en direction opposée).
4. **Flash blanc** (`BossFX.Flash`) — caméra recadrée pendant la coupure (`MoveCamera` avant le flash).
5. Reveal : boss en pose d'intro (`CharSetAnim "Attack"` figé puis `"Idle"`).
6. Titre (`UI:WaitShowTitle`) + fanfare/thème.
7. Ligne de dialogue courte — jamais un pavé.

## Catalogue des boss implémentés

| Boss | Ch. | Biome | Type d'irruption | Détail signature | VFX/SE principaux | Statut |
|---|---|---|---|---|---|---|
| Luxio & co | 3 | caverne | embuscade (existant) | meute coordonnée | — (script ch3 existant) | Fait (legacy) |
| Mini-boss/gardiens ch5 | 5 | steppe/tunnel/mont | scripts `_ch_5` existants | — | — | Fait (legacy) |
| Zarude | 6 | forêt sombre | surgit des lianes | ombres + lianes qui s'écartent | `EmergeShadow` : Ominous_Wind, Dark_Pulse, Leaf_Storm | Fait |
| Regigigas | 7 | ruines | **activation** (pas de surgissement) : les veines dorées s'animent | éboulement + tremblement, veines qui pulsent | `RockFall`, `Rumble`, Overlay White | Fait |
| Diancie | 8 | sanctuaire cristal | **activation** : les gemmes résonnent et s'illuminent | éclats de gemmes en suspension autour d'elle | `AwakenCrystal` : Power_Gem_Charge/Hit, Flash_Cannon_Sparkle, Captivate_Sparkles | Fait (2026-07-26) |
| Laggron | 9 | marais/eau | jaillit de la vase (séquence A.3 complète) | amorce de Telluriforce figée (pose Attack) | `EmergeWater` : Wave_Circle (signal discret ×2), Water_Spout_Up/Splash/Drop, Bubbles ; SE DUN_Water_Sport → DUN_Surf | Fait (2026-07-26) |
| Escouade Fulgur | 10 | crête venteuse | déjà en position (course, pas une embuscade) | trio aligné qui défie | — (dialogue direct, voulu sec) | Fait |
| Lugia | 10 | sommet/ciel | descente réelle depuis les nuages | déploie ses ailes (pose Attack) avant de juger | `DescendSky` : Gust_Wind, Feather ×2, Rock_Slide_Front, Flash, Impact ; recul du groupe | Fait (2026-07-26) |

## Réservations (boss futurs — à remplir AVANT implémentation)

| Boss pressenti | Biome | Irruption réservée | Signature réservée |
|---|---|---|---|
| Jirachi (Grotte du Vœu, P7) | grotte astrale | activation (étoile qui s'éveille) — NE PAS réutiliser le motif cristal de Diancie | vœu murmuré avant le combat |
| Uxie (Sentier du Savoir, P5) | lac | émergence brume (`EmergeMist`) | ouvre les yeux une seule fois |
| Cresselia (Temple du Clair de Lune, P6) | temple | activation lumière lunaire | croissant lumineux |
| Giratina (Faille Primordiale, P7) | distorsion | Overlay `Distortion` + inversion écran | traverse un mur "impossible" |
| Yveltal (Vallée de l'Oubli, P6) | vallée morte | descente ciel — variante SOMBRE de Lugia (obligation de différencier : ciel rouge, silence au lieu de fanfare) | aspiration de lumière |

Règle : deux boss ne partagent jamais le même couple (irruption, signature). Toute nouvelle fiche se vérifie contre ce tableau.

## Maisons de monstre & donjons vivants (Addendum B) — état

- Les Monster House sont gérées nativement par le moteur (PMDC) dans les zones procédurales.
- Mise en scène dédiée (caméra panoramique, musique danger) : **à implémenter** — chantier scripté commun (`SINGLE_CHAR_SCRIPT` sur OnMapStarts), prévu avec la vague 2.
- PNJ inoffensifs en donjon : le moteur du dépôt a déjà `SpawnRandomTutor` purgé des zones importées (SV manquant) — un équivalent New Era (`SV.adventure.Tutors` déclaré chez nous) est le bon véhicule. À traiter avec la vague 2.
- Dosage cible par donjon 10+ étages : 1-2 monster houses mises en scène, 1-3 rencontres de vie, 0-1 mini-cinématique.

---

## RÉVISION Regigigas (ch7) — 2026-07-27

Directive utilisateur : Aegis Cave (PMD Sky) importée 1:1, trio Regi inclus.
- Arène : `sanctuaire_titans.rsmap` (« Sanctuaire des Titans »), 25×27 tuiles
  24px, visuel d'origine intact (tileset `Titans_Arena_Base`, identity-mapped).
- Combat : Regigigas 28 (12,7) + Regirock 26 (7,10) + Regice 26 (17,10) +
  Registeel 26 (12,12) — `clear_body`, movesets thématiques, mysterious_force.
- Branchement : `cloven_ruins` seg3 → `sanctuaire_titans` (l'ancienne
  `cloven_ruins_boss.rsmap` reste en secours, non référencée).
- Écho narratif : légende « Les Trois Serviteurs et le Colosse » (ch5, Rubble).
  L'intro 3 couches du ground `cloven_ruins_boss` reste valable : le trio
  n'apparaît qu'au combat — les Serviteurs répondent à l'éveil du Colosse.

---

## VAGUE 7 (2026-07-27) — 42 cinématiques d'Ancrage (catalogue anti-répétition)

Grammaire Rescue Team conservée (signal → irruption → recul → flash → reveal → titre → ligne courte),
narration à la Explorers (voix du gardien AVANT l'image, partenaire qui verbalise le détail signature).
Rematch : intro raccourcie (respect du temps du joueur). Voyage Grodoudou → cinématique (champ cine).

| Ground | Boss | Ch | Biome | Irruption | Signature |
|---|---|---|---|---|---|
| arene_trone_magma | Groudon | 11 | caldeira | émersion tellurique + éboulements | la terre "respire" avant lui |
| abime_tempetes | Kyogre | 12 | mer démontée | jaillit au centre exact de la tempête | les vagues tournent en cercle parfait |
| lac_savoir | Créhelf | 13 | lac | émergence brume (réservation honorée) | n'ouvre les yeux qu'une fois |
| lac_espoir | Créfollet | 13 | lac | jaillit de l'eau | le lac reflète des visages sans expression |
| lac_courage | Créfadet | 13 | lac | flash — il était DÉJÀ là | n'attend pas : teste l'audace |
| champ_braises | Sulfura | 14 | champ de feu | émersion de flammes | ses flammes éclairent au lieu de brûler |
| arene_hautes_plaines | Raikou | 16 | hautes plaines | flash (l'éclair avant le tonnerre) | le tonnerre claque APRÈS lui |
| champ_vent_boreal | Artikodin | 17 | champ boréal | descente ciel SILENCIEUSE (variante sombre assumée vs Lugia) | AUCUNE voix — le silence est le signal ; il neige vers le haut |
| porte_plaines_foudre | Électhor | 17 | plaines de foudre | flash + impact | l'air entier se charge — il EST la foudre |
| sommet_aurore | Ho-Oh | 18 | sommet | descente ciel | arc-en-ciel nocturne |
| fosse_argentee | Lugia (écho) | 19 | abysse | jaillit des eaux | même chant qu'au ch10, plus ancien et plus triste — il pèse au lieu de juger |
| bois_antan_verger | Celebi | 20 | verger | brume | les pommes mûrissent/pourrissent en boucle |
| antre_occident | Mewtwo | 21 | forteresse | SILENCE + long noir + flash | l'Ancrage artificiel ; il demande de l'AIDE en défiant |
| plaines_brulees | Entei + Victini | 22 | plaines brûlées | double émersion de feu | le volcan qui marche + l'étincelle qui danse |
| mont_lune_vue | Cresselia + Darkrai | 23 | mont lunaire | activation lumière lunaire (réservation honorée) | les DEUX visages refusent de se battre entre eux |
| cretes_boreales | Latios + Latias | 24 | crêtes | double descente ciel croisée | deux sillages qui ne se touchent jamais |
| bois_des_plaintes | Suicune | 25 | forêt hurlante | brume | l'eau devient parfaitement claire |
| arene_clairiere_secrete | Mew + Hoopa | 26 | clairière | double flash espiègle | l'anneau avale le sac du partenaire |
| creux_ombres_scelle | Marshadow | 26 | fosse scellée | ombre | l'ombre du héros se lève toute seule ; boss quasi muet |
| vigie_stratos | Rayquaza | 27 | stratosphère | descente ciel | la ligne verte du monde ; paie la légende de Reinier (ch5) |
| fleche_reliques_courroux | Dialga | 28 | flèche temporelle | activation cristal + double secousse | l'écho arrive AVANT le pas ; OST dédiée |
| chambre_agee_o | Palkia | 28 | chambre spatiale | triple flash désynchronisé | la salle plus grande à l'intérieur |
| grotte_cryptique | Giratina | 29 | grotte inversée | ombre + secousse (réservation "traverse un mur" honorée) | traverse le mur PLEIN |
| vallon_malsain_fond | Yveltal | 29 | bois flétri | descente ciel sombre (réservation variante sombre honorée) | les arbres sont VIDÉS, pas pourris |
| terres_tues_porte | Zygarde | 30 | terres tues | assemblage tellurique | les cellules s'additionnent en direct |
| nef_prisme_est | Xerneas | 30 | nef prismatique | éveil cristal | tout fleurit sur son passage |
| ile_legendaire | Solgaleo | 31 | île du conte | flash solaire long | l'aube en plein midi |
| ile_australe | Lunala | 31 | île nocturne | nuit tombée + ombre | un ciel étoilé "rangé exprès" |
| sanctuaire_voeu | Jirachi | 31 | sanctuaire | éveil de l'étoile (réservation honorée : PAS le motif cristal) | le vœu d'il y a 25 ans (paie l'arc Fil du Destin) |
| ile_close | Necrozma | 32 | île close | ÉCLIPSE : noir + flash long | recontextualise tout : "qui est le voleur ?" |
| couloir_legendes | Eternatus | 32 | couloir final | cataclysme tellurique | le couloir pulse en pourpre — le twist rendu visible |
| escalier_origine | Arceus | 32 | escalier | lumière lente | les marches n'existent qu'une fois montées |
| champ_sacre | Shaymin | 15 | champ fleuri | brume florale | les fleurs s'ouvrent sous les pas |
| recif_genereux | Manaphy + Phione | 16 | récif | double jaillissement | le récif fredonne leur berceuse |
| gue_poulain_autel | Keldeo | 18 | gué | jaillissement | l'eau tient tête au courant |
| grotte_echos | Meloetta | 20 | grotte acoustique | fondu musical + brume | l'écho termine les mélodies seul |
| labo_decrepit | Genesect | 22 | laboratoire | impact machine + flash | protocole d'évaluation par le combat |
| fosse_volcanique | Volcanion | 23 | fosse geysers | eau PUIS feu | les geysers-soufflets |
| carriere_magnetique | Magearna | 24 | carrière | impact machine + flash | les engrenages tournent vers elle |
| pre_tonnerre | Zeraora | 25 | pré | flash | une seule trace d'herbe brûlée |
| grotte_rocheuse | Melmetal + Meltan | 27 | fonderie | émersion tellurique + impact | le poing-cloche ; Meltan fait coucou |
| vallon_perdu | Deoxys | 21 | cratère | chute de météore + flash | le cratère creusé par LUI |

Vérifié : 0 doublon de couple (irruption, signature) ; les 5 réservations historiques (Jirachi étoile, Uxie brume, Cresselia lune, Giratina mur, Yveltal ciel sombre) honorées.
