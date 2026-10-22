# ARCHIVE OBSOLÈTE — ancienne attribution erronée des Friend Areas

> **Décision autoritative 2026-08-07 : cette vague est annulée.** Les Friend Areas sont exclusivement des zones d’accueil vendues par Grodoudou, comme dans Rescue Team. Elles ne sont jamais des arènes de boss. Le tableau ci-dessous est conservé uniquement comme preuve de la dérive corrigée et ne doit plus être exécuté. Voir `MANIFESTE_FRIEND_AREAS_RED.md` et `tools/audit_friend_areas.py`.

# Vague 6 — 57 Friend Areas pmd-red anciennement importées comme arènes (ANNULÉ)

Réponse à la directive : « toutes les OST et Friend Areas utilisables comme
zones de battle boss pour les légendaires absents de PMD Rescue Team de base ».

- **57/57 Friend Areas** du code source (`map_files_table.c`, H01P01→H29P04)
  converties 1:1 (rendu identity-mapped + collision d'origine, tuiles 8 px).
  Y compris les 2 Chambres des Âges au BPC partagé (H21c) géré.
- **OST : déjà toutes récupérées** au fil des vagues — 133 pistes dans
  Content/Music (dont les 3 thèmes Friend Area Cave/Forest/Swamp, Rainbow Peak,
  Sky Tower, et ~90 pistes DumpAsset importées vagues 1-5). Chaque .rsground
  référence une musique présente (vérifié 57/57).
- Chaque ground a Main_Entrance_Marker (bord bas walkable), **Boss_Marker au
  centre** de la zone jouable, TEAMMATE_1..3, init.lua squelette.
- Audit flood-fill 57/57 : les écarts (ex. mer_sereine 1457/1527) sont des
  poches décoratives d'origine sans entité — géométrie 1:1 conservée.

## Assignations aux légendaires ABSENTS de Rescue Team (gén. 4-9)

| Friend Area (origine) | Ground New Era | Boss assigné |
|---|---|---|
| H01P01 | recif_genereux (Récif Généreux) | arène Manaphy/Phione ch16 (Berceau des Mers) |
| H01P02 | mer_tresors (Mer aux Trésors) | réserve arène marine |
| H01P03 | mer_sereine (Mer Sereine) | réserve cinématique marine |
| H02P01 | plancher_abysses (Plancher des Abysses) | arène Kyogre ch12 (alt. cinématique) |
| H02P02 | courant_profond (Courant Profond) | réserve marine |
| H02P03 | grotte_benthique (Grotte Benthique) | réserve marine |
| H03P01 | greve_claire (Grève Claire) | réserve cinématique plage |
| H04P01 | mont_vertprofond (Mont Vert-Profond) | réserve montagne |
| H04P02 | mont_crevasse (Mont de la Crevasse) | réserve montagne |
| H05P01 | mont_lune_vue (Mont Vue-de-Lune) | arène Cresselia ch23 (Cour du Clair de Lune) |
| H05P02 | pic_arc_en_ciel (Pic Arc-en-Ciel) | arène Ho-Oh ch18 (alt.) — écho visuel arène Lugia ch10 |
| H06P01 | plaines_sauvages (Plaines Sauvages) | réserve plaine |
| H06P02 | belles_plaines (Belles Plaines) | réserve plaine |
| H06P03 | plaines_azur (Plaines d'Azur) | réserve plaine |
| H06P04 | reserve_safari (Réserve Safari) | réserve |
| H06P05 | plaines_brulees (Plaines Brûlées) | arène Entei ch22 (alt. cinématique) |
| H06P06 | champ_sacre (Champ Sacré) | arène Shaymin ch15 (Jardin de la Gratitude) |
| H07P01 | foret_brumeleve (Forêt de Brume-Levée) | réserve forêt |
| H07P02 | foret_envolee (Forêt de l'Envolée) | réserve forêt |
| H07P03 | foret_envahie (Forêt Envahie) | arène Zarude (revanche alt.) |
| H07P04 | foret_vibrante (Forêt Vibrante) | réserve forêt |
| H07P05 | foret_champignons (Forêt aux Champignons) | réserve forêt |
| H07P06 | foret_guerison (Forêt de Guérison) | arène Celebi ch20 (Bois d'Antan) |
| H07P07 | foret_mue (Forêt de la Mue) | arène Mew ch26 (alt. Ditto lore) |
| H07P08 | foret_secrete (Forêt Secrète) | arène Marshadow ch26 (Creux des Ombres) |
| H08P01 | riviere_lavoir (Rivière du Lavoir) | réserve rivière |
| H09P01 | mare_tetards (Mare aux Têtards) | réserve |
| H09P02 | etang_carapace (Étang Carapace) | réserve |
| H10P01 | lac_mystique (Lac Mystique) | arène trio des lacs ch13 (Créhelf/Créfollet/Créfadet) |
| H10P02 | lac_cascade (Lac de la Cascade) | arène Keldeo ch18 (alt.) |
| H11P01 | marecage_cacahuete (Marécage Brun) | réserve marais (déjà FA_Peanut tileset) |
| H12P01 | marais_poison (Marais Poison) | réserve marais toxique |
| H13P01 | grotte_echos (Grotte des Échos) | arène Meloetta ch20 (alt. acoustique) |
| H13P02 | grotte_cryptique (Grotte Cryptique) | arène Giratina ch29 (Labyrinthe des Perdus) |
| H13P03 | antre_dragon (Antre du Dragon) | arène Zygarde ch30 (Ciel Suspendu) / dragons |
| H13P04 | grotte_rocheuse (Grotte Rocheuse) | réserve grotte |
| H14P01 | jungle_luxuriante (Jungle Luxuriante) | arène Hoopa ch26 (Cache du Porteur d'Anneaux) |
| H15P01 | labo_decrepit (Laboratoire Décrépit) | arène Genesect ch22 (Réacteur Enfoui) + Mewtwo lore |
| H16P01 | mont_discipline (Mont de la Discipline) | arène Keldeo/Kubfu (dojo) — réserve |
| H17P01 | pre_tonnerre (Pré du Tonnerre) | arène Zeraora ch25 (Piste Fulgurante) |
| H18P01 | centrale_energie (Centrale d'Énergie) | arène Regieleki (futur) / Genesect alt. |
| H19P01 | cratere_fumant (Cratère Fumant) | arène Heatran (réservé fiches_boss — SON arène attitrée) |
| H20P01 | desert_fournaise (Désert de la Fournaise) | réserve désert (tileset FA déjà là) |
| H21P01 | chambre_agee_an (Chambre des Âges I) | arène Registeel/Unown — réserve reliques |
| H21P02 | chambre_agee_o (Chambre des Âges II) | réserve reliques |
| H22P01 | relique_ancienne (Relique Ancienne) | arène Dialga ch28 (Tour des Reliques) — cinématique |
| H23P01 | crete_tenebres (Crête des Ténèbres) | arène Darkrai ch23 (Cour du Clair de Lune) |
| H24P01 | caverne_frigide (Caverne Frigide) | arène Glastrier/Calyrex (futur) — réserve glace |
| H25P01 | greve_banquise (Grève de la Banquise) | réserve glace |
| H26P01 | fosse_volcanique (Fosse Volcanique) | arène Volcanion ch23 (Forge de Vapeur) |
| H27P01 | vigie_stratos (Vigie du Stratos) | arène Rayquaza ch27 (alt.) / Escouade Fulgur ch10 |
| H28P01 | champ_ravage (Champ Ravagé) | arène Yveltal ch29 (Cocon de la Ruine) — cinématique |
| H28P02 | carriere_magnetique (Carrière Magnétique) | arène Magearna ch24 (alt.) / Melmetal |
| H29P01 | ile_legendaire (Île Légendaire) | arène Solgaleo ch31 (Le Conte Sans Fin) |
| H29P02 | ile_australe (Île Australe) | arène Lunala ch31 (Chapelle de la Nuit) — cinématique |
| H29P03 | ile_close (Île Close) | arène Necrozma ch32 (Sentier Éteint) — cinématique |
| H29P04 | ile_finale (Île Finale) | arène Eternatus/Arceus ch32 — cinématique finale |

## Points forts de la passe « salle de boss » (2e lecture demandée de longue date)

- **Lac Mystique** → le trio des lacs (Créhelf/Créfollet/Créfadet) a enfin son
  plan d'eau canonique en plus des 3 lacs de cristal Explorers.
- **Cratère Fumant** → **Heatran** : son arène attitrée (réservation
  fiches_boss honorée — la légende du Fourneau de Phileas ch5 pointe ici).
- **Mont Vue-de-Lune / Crête des Ténèbres** → Cresselia / Darkrai ch23.
- **Laboratoire Décrépit** → Genesect ch22 (+ écho lore Mewtwo).
- **Centrale d'Énergie** → Regieleki (futur), **Caverne Frigide** →
  Glastrier/Calyrex (futurs), **Chambres des Âges** → Registeel/Unown.
- **Îles** (Légendaire/Australe/Close/Finale) → cinématiques Solgaleo, Lunala,
  Necrozma, Eternatus/Arceus ch31-32.
- **Vigie du Stratos** et **Pic Arc-en-Ciel** : les deux assignations
  historiques du document maître (arène Fulgur / écho arène Lugia) enfin
  disponibles en grounds complets.
