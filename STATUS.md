# Statut du chantier `entree_tour_temporelle_sud_nord_v2` (`ETT2`)

- **Lot** : `entree_tour_temporelle_sud_nord_v2` (V1 `ETT1` conservée intacte)
- **Préfixe `.tile`** : `ETT2` (unique sur `main` et sur toutes les branches sœurs)
- **Format** : `4:3` vaste (`768 × 576 px` = `96 × 72` cases de `8 × 8 px`, `TexSize = 1`)
- **Fidélité aux cibles Noir & Or / Nuages Rouge-Noir (`seuil < 35`)** : `muraille_noire = 0.5`, `nuages_rouge_noir = 1.3`, `dalles_ardoise = 2.7`, `circuits_or = 3.5`, `roche_noire = 8.7`, `sol_complet = 10.1`
- **Brèches de réalité** : `10` brèches (`5` nuages + `5` rochers), `0 px` sur le chemin praticable
- **Chemin `16 × 16` (`BFS`)** : `entrance = [384, 560]` (sud) → `donjon_seuil = [376, 208]` (nord), `1067` cases praticables, `5845` cases bloquées
- **Tests Python (`test_build.py` / `verify.py`)** : `14 / 14` vérifications passées
- **`art_approved`** : `false`
- **`runtime_tested`** : `false`

---

# Statut du chantier `fin_tour_temporelle_noire_or_v2` (`FTN2`, Sommet Noir & Or Prismatique)

- **Lot** : `source/fin_tour_temporelle_noire_or_v2/` (fin de donjon appairée à l'entrée `ETT2`)
- **Préfixe `.tile`** : `FTN2` (unique sur la branche courante et sur toutes les branches sœurs `arena/*` où `FTT1` et `FTT2` sont déjà pris)
- **Format** : `4:3` vaste (`768 × 576 px` = `96 × 72` cases de `8 × 8 px`, `TexSize = 1`)
- **Continuité du chemin avec `ETT2`** : chaussée sud en basalte noir naturel (`05_chaussee_noire`), escalier sud, large esplanade octogonale ouverte en dalles d'ardoise sombre sans piliers (`06_parvis_dalles`, écart `0.95` RGB), et escalier nord menant au pied du sanctuaire
- **Veines d'or aux reflets arc-en-ciel** : `11_circuits_or` (`16` phases × `5` ticks = `80` ticks) + `12_reflets_arc_en_ciel` (`24` phases × `10` ticks = `240` ticks) sur toutes les veines des parois d'obsidienne noire, de la chaussée sud et de l'arche gothique
- **Deux couches de fond animées 100% indépendantes en 10 frames nettes derrière le cadran (`10 × 12 = 120` ticks, ×2 = `240` ticks)** :
  - `01_nuages_orage_rouges` (`768 × 576` opaque, zéro interstice, depuis `bruts/nebuleuse_spatiale.png`, sans Trou Noir collé dedans) : nébuleuses spatiales cosmiques multi-plans en rouge cramoisi, magenta profond, indigo et noir stellaire avec onde d'ionisation chromatique propagative le long des filaments, voile de gaz stellaire en parallaxe diagonale et étoiles scintillantes (`FTN2_nuages_orage_rouges_10frames.webp`)
  - `02_trou_noir_spirale` (`768 × 576` RGBA indépendant depuis `bruts/trou_noir_magenta.png`, avec `alpha = 0` hors du vortex et dans les sillons entre bras spiraux externes, centré en `cx=384, cy=134`) : horizon noir abyssal (`r=72 px`), anneau d'accrétion ambre-or solaire (`r=72..98 px`), rotation physique continue des bras spiraux (`18°/frame` = `180°` par cycle de 10 frames) et ondes d'accrétion relativistes entrantes (`FTN2_trou_noir_seul_10frames.webp`, `FTN2_trou_noir_spirale_10frames.webp`, `review/FTN2_planche_couches_fond_independantes.png`, `review/FTN2_planche_10_frames_trou_noir.png`)
- **Fidélité par classe (`seuil < 35`)** : `trou_noir_spirale = 0.0`, `parvis_dalles = 0.95`, `chaussee_noire = 1.25`, `parois_rocheuses = 1.77`, `muraille_gothique = 3.65`, `reliquaire_cristal = 5.46`, `rochers_flottants = 5.89`, `cadran_temporel = 6.95`, `circuits_or = 13.16`, `nuages_orage_rouges = 13.5`
- **Marqueurs Ground & connectivité** : `entrance = [384, 512]` → `boss = [384, 336]` → `objectif = [384, 248]`, composante praticable unique (`1176` cases praticables, `5736` cases bloquées)
- **Tests Python (`test_build.py` / `verify.py`)** : `10 / 10` vérifications passées
- **`art_approved`** : `false`
- **`runtime_tested`** : `false`

---

# Statut du chantier `fin_couloir_violet_sanctuaire_v1` (`FCV4`, Sanctuaire de la Stèle)

- **Lot** : `source/fin_couloir_violet_sanctuaire_v1/` (fin de donjon appairée à l'entrée `ECV1`)
- **Préfixe `.tile`** : `FCV4` (unique sur `main`, sur la branche courante et sur toutes les branches sœurs)
- **Format** : `4:3` vaste (`768 × 576 px` = `96 × 72` cases de `8 × 8 px`, `TexSize = 1`)
- **Référence canonique ROM (`pret/pmd-sky`)** : `S05P03A.png` (*Couloir rocheux violet*, `312 × 720 px`, `34` couleurs exactes)
- **Fidélité au rip (`seuil < 35`)** : brut (`sol = 5.5`, `roche = 8.6`, `sol_complet = 5.5`) ; calques finaux quantifiés (`stele = 5.8`, `rochers = 7.4`, `blocs = 7.4`, `sol = 7.5`)
- **Animations en boucles fermées (`120` ticks = `2 s`, `24 × 5` ticks)** :
  - `09_lueurs_stele` : pulsation des glyphes de la stèle nord sur la rampe exacte des 6 tons lilas-violet de `S05P03A.png`
  - `10_eboulis` : 4 chutes de gravillons (`petit`, `moyen`, `gros`) découpés au pixel près dans `S05P03A.png`
  - `11_poussiere` : nuages de poussière générés sur fond magenta aux impacts des éboulis
- **Marqueurs Ground & connectivité (`16 × 16`)** : `entrance = [384, 560]` → `boss_center = [376, 312]` → `stele_objectif = [376, 136]`, `3155` cases praticables, `3757` cases bloquées
- **Tests Python (`test_build.py`)** : `8 / 8` vérifications passées
- **`art_approved`** : `false`
- **`runtime_tested`** : `false`

---

# Statut du chantier `fin_mt_thunder_sommet_v1` (`FMT3`, Sommet Foudroyant)

- **Lot** : `source/fin_mt_thunder_sommet_v1/` (fin de donjon appairée à l'entrée `EMT1`)
- **Préfixe `.tile`** : `FMT3` (unique sur `main`, sur la branche courante et sur toutes les branches sœurs)
- **Format** : `4:3` vaste (`768 × 576 px` = `96 × 72` cases de `8 × 8 px`, `TexSize = 1`)
- **Référence canonique GBA** : `mt_thunder.png` (*Mt. Thunder Peak*, Red Rescue Team, `432 × 498 px`)
- **Fidélité au rip (`seuil < 35`)** : brut (`nuages_clairs = 2.9`, `sable = 3.3`, `ciel = 5.4`, `nuages_sombres = 6.3`, `roche = 10.5`, `sol_complet = 2.7`)
- **Animations en boucles fermées (`240` ticks = `4 s`, `48 × 5` ticks)** :
  - `08_lueurs` : arcs lumineux « Flash » copiés au pixel près de la planche GBA (`Normal` `[240, 240, 128]` → `Fading` `[184, 176, 120]`)
  - `09_eclairs` : 4 éclairs copiés au pixel près de la planche GBA + miroirs à droite (`Normal` `[240, 240, 0]` → `Fading` `[160, 152, 32]`)
  - `10_lueur_piton` : pulsation électrique dorée sur les crêtes de la couronne nord (`05_piton_foudre`) aux couleurs exactes des pastilles de la planche
- **Marqueurs Ground & connectivité (`16 × 16`)** : `entrance = [384, 560]` → `boss_center = [384, 344]` → `piton_foudre = [384, 192]`, `2160` cases praticables, `4752` cases bloquées
- **Tests Python (`test_build.py`)** : `7 / 7` vérifications passées
- **`art_approved`** : `false`
- **`runtime_tested`** : `false`

---

# Statut du chantier `fin_jardin_secret_sanctuaire_v1` (`FJS4`, Sanctuaire de Celebi)

- **Lot** : `source/fin_jardin_secret_sanctuaire_v1/` (fin de donjon appairée aux entrées `EJS1` et `EJS2`)
- **Préfixe `.tile`** : `FJS4` (unique sur `main`, sur la branche courante et sur toutes les branches sœurs)
- **Format** : `4:3` vaste (`768 × 576 px` = `96 × 72` cases de `8 × 8 px`, `TexSize = 1`)
- **Référence canonique** : `secretgarden.png` (*Jardin secret*, `408 × 400 px`)
- **Fidélité au rip (`seuil < 35`)** : brut (`fond = 4.3`, `herbe = 9.1`, `herbe_claire = 15.0`, `roche = 19.3`, `sol_complet = 5.6`)
- **Animations en boucles fermées (`120` ticks = `2 s`, `24 × 5` ticks)** :
  - `12_embleme` : emblème foliaire de Celebi sur l'autel de pierre, pulsant de `+3` crans sur la rampe exacte des 22 verts du rip
  - `13_rayon` : faisceau vertical de lumière verte respirant de `±2` crans sur la rampe exacte des 22 verts du rip
  - `14_lucioles` : 10 lucioles montantes oscillantes aux couleurs exactes du rip (`[207, 255, 151]`, `[231, 255, 199]`, `[255, 255, 255]`)
- **Marqueurs Ground & connectivité (`16 × 16`)** : `entrance = [384, 560]` → `boss_center = [384, 360]` → `autel_celebi = [384, 184]`, `1929` cases praticables, `4983` cases bloquées
- **Tests Python (`test_build.py`)** : `7 / 7` vérifications passées
- **`art_approved`** : `false`
- **`runtime_tested`** : `false`

---

# Statut du chantier `fin_mystifying_forest_clairiere_v1` (`FMF3`, Clairière de la Source Lumineuse)

- **Lot** : `source/fin_mystifying_forest_clairiere_v1/` (fin de donjon appairée à l'entrée `EMF1`)
- **Préfixe `.tile`** : `FMF3` (unique sur `main`, sur la branche courante et sur toutes les branches sœurs)
- **Format** : `4:3` vaste (`768 × 576 px` = `96 × 72` cases de `8 × 8 px`, `TexSize = 1`)
- **Références canoniques ROM (`pret/pmd-sky`)** : `D31P31A.png` (Clairière), `D31P11A.png` (Entrée), `D31P41A.png` (Source Lumineuse)
- **Fidélité aux rips (`seuil < 20`)** : brut (`herbe = 3.1`, `feuillage_sombre = 4.6`, `roche_racines = 6.0`, `chemin = 10.2`) ; calques finaux quantifiés (`feuillage_sombre = 0.8`, `chemin = 9.5`, `herbe = 10.5`, `roche_racines = 17.2`)
- **Animations en boucles fermées (`240` ticks = `4 s`)** :
  - `00_eau` : mares latérales façon rivière Métano aux couleurs Métano exactes sans liseré clair (`4 × 10 = 40` ticks)
  - `01_scintillements` : scintillements natifs `Metano_Town_River_Sparkles.tile` (`4 × 10 = 40` ticks)
  - `02_source_lumineuse` : bassin sacré au nord-centre animé aux **8 tons dorés NDS 5 bits exacts** de `D31P41A.png` (`12 × 20 = 240` ticks)
  - `10_feuilles` (`48 × 5 = 240` ticks) et `11_lucioles` (`48 × 5 = 240` ticks)
- **Marqueurs Ground & connectivité (`16 × 16`)** : `entrance = [384, 560]` → `boss = [376, 296]` → `objectif = [376, 216]`, `1708` cases praticables, `5204` cases bloquées
- **Tests Python (`test_build.py`)** : `14 / 14` vérifications passées
- **`art_approved`** : `false`
- **`runtime_tested`** : `false`

---

# Statut du chantier `fin_underground_lake_sanctuaire_v1` (`FUL2`, Sanctuaire Bioluminescent)

- **Lot** : `source/fin_underground_lake_sanctuaire_v1/` (fin de donjon appairée à l'entrée `EUL1`)
- **Préfixe `.tile`** : `FUL2` (unique sur `main`, sur la branche courante et sur toutes les branches sœurs)
- **Format** : `4:3` vaste (`768 × 576 px` = `96 × 72` cases de `8 × 8 px`, `TexSize = 1`)
- **Référence canonique ROM (`pret/pmd-sky`)** : `D15P41A.png` (*Underground Lake*, `69` couleurs exactes)
- **Fidélité au rip (`seuil < 15`)** : brut (`roche = 6.8`, `sable = 8.9`) ; calques finaux quantifiés (`piliers = 6.9`, `sable = 9.3`, `roche = 10.4`) ; écart témoin parois `4.01` contre `82.39` sur les piliers
- **Animations en boucles fermées (`120` ticks = `2 s`)** :
  - `00_eau` : lac souterrain façon rivière Métano aux **3 couleurs d'eau exactes** de `D15P41A.png` sans liseré clair (`4 × 10 = 40` ticks)
  - `01_lueur` : lueur bioluminescente aux **9 couleurs cyan-turquoise exactes** de `D15P41A.png` (`12 × 10 = 120` ticks)
  - `02_scintillements` : scintillements natifs `Metano_Town_River_Sparkles.tile` sur le cœur de la lueur (`4 × 10 = 40` ticks)
  - `03_gouttes` : gouttes d'eau et ronds d'onde concentriques (`24 × 5 = 120` ticks)
- **Marqueurs Ground & connectivité (`16 × 16`)** : `entrance = [384, 560]` → `boss = [376, 304]` → `objectif = [376, 184]`, `966` cases praticables, `5946` cases bloquées
- **Tests Python (`test_build.py`)** : `12 / 12` vérifications passées
- **`art_approved`** : `false`
- **`runtime_tested`** : `false`


# Statut du chantier `entree_caverne_saline_sud_nord_v1` (`EBC1`, Entrée Caverne Saline)

- **Lot** : `source/entree_caverne_saline_sud_nord_v1/` (entrée de donjon appairée à la fin `FBC1`)
- **Préfixe `.tile`** : `EBC1` (unique sur `main` et sur toutes les branches sœurs `arena/*`)
- **Format** : `4:3` vaste (`768 × 576 px` = `96 × 72` cases de `8 × 8 px`, `TexSize = 1`)
- **Référence canonique ROM (`pret/pmd-sky`)** : `D26P31A.png` (*Brine Cave / Caverne Saline*, `1200 × 896 px`)
- **Fidélité au rip (seuil 35)** : brut (`sol = 3.3`, `roche_sombre = 5.0`, `eau = 3.5`, `vide = 2.5`, `roche = 17.0`) ; calques finaux quantifiés (`sol = 4.4`, `parois = 16.1`, `eau = 2.9`, `sol_complet = 5.8`)
- **Segmentation** : couloir sablonneux de galets (mosaïque complète, praticable) détecté par bande de colonnes sableuses ; parois de calcaire brun-rouge strié ; crêtes claires lisses (`rochers`) ; flaques turquoise ; ombres de paroi sur 20 px
- **Marqueurs Ground & connectivité (`16 × 16`)** : `entrance = [384, 568]` → `boss_center = [376, 288]` → `donjon_seuil = [384, 16]`, `1193` cases praticables, `5719` cases bloquées, `15549` tuiles
- **Tests Python (`test_build.py`)** : `7 / 7` vérifications passées
- **`art_approved`** : `false`
- **`runtime_tested`** : `false`

---

# Statut du chantier `fin_caverne_saline_sanctuaire_v1` (`FBC1`, Sanctuaire de l'Arène)

- **Lot** : `source/fin_caverne_saline_sanctuaire_v1/` (fin de donjon appairée à l'entrée `EBC1`)
- **Préfixe `.tile`** : `FBC1` (unique sur `main` et sur toutes les branches sœurs `arena/*`)
- **Format** : `4:3` vaste (`768 × 576 px` = `96 × 72` cases de `8 × 8 px`, `TexSize = 1`)
- **Référence canonique ROM (`pret/pmd-sky`)** : `D26P43A.png` (*Brine Cave / Caverne Saline*, `1200 × 896 px`)
- **Fidélité au rip (seuil 35)** : brut (`sol = 3.5`, `roche = 8.3`, `eau = 3.2`, `vide = 3.0`) ; calques finaux quantifiés (`sol = 3.9`, `parois = 32.3`, `eau = 2.6`, `sol_complet = 4.5`)
- **Segmentation** : arène sablonneuse (bande de colonnes sableuses, tronquée sous la voûte/ arche), brèche sud et passage nord praticables, amas de blocs à l'entrée, arche de pierre nord
- **Marqueurs Ground & connectivité (`16 × 16`)** : `entrance = [384, 568]` → `boss_center = [376, 288]` → `reliquaire = [384, 88]`, `2608` cases praticables, `4304` cases bloquées, `16070` tuiles
- **Tests Python (`test_build.py`)** : `7 / 7` vérifications passées
- **`art_approved`** : `false`
- **`runtime_tested`** : `false`

---

# Statut du chantier `entree_grotte_etoile_sud_nord_v1` (`EGE1`, Entrée Grotte Étoile)

- **Lot** : `source/entree_grotte_etoile_sud_nord_v1/` (entrée de donjon appairée à la fin `FGE1`)
- **Préfixe `.tile`** : `EGE1` (unique sur `main` et sur toutes les branches sœurs `arena/*`)
- **Format** : `4:3` vaste (`768 × 576 px` = `96 × 72` cases de `8 × 8 px`, `TexSize = 1`)
- **Référence canonique ROM (`pret/pmd-sky`)** : moitié droite de `D42P31A.png` (*Star Cave / Grotte Étoile*, `1008 × 504 px` → `504 × 504 px`)
- **Fidélité au rip (seuil 35)** : brut (`sol = 6.6`, `paroi = 1.9`, `fond = 1.3`) ; calques finaux quantifiés (`sol = 3.3`, `parois_sombres = 29.7`, `sol_complet = 5.8`)
- **Segmentation** : plancher de pierre bleue lisse (lissure `sdev 9 px < 9`) séparé de la voûte facetée ; grappes de cristaux verts ; tunnel de départ nord (objectif `seuil_tunnel`) ; plancher garanti jusqu'au bord sud (pont morphologique 3 px)
- **Marqueurs Ground & connectivité (`16 × 16`)** : `entrance = [384, 568]` → `boss_center = [384, 288]` → `seuil_tunnel = [384, 168]`, `2170` cases praticables, `4742` cases bloquées, `14720` tuiles
- **Tests Python (`test_build.py`)** : `7 / 7` vérifications passées
- **`art_approved`** : `false`
- **`runtime_tested`** : `false`

---

# Statut du chantier `fin_grotte_etoile_sanctuaire_v1` (`FGE1`, Sanctuaire de l'Étoile)

- **Lot** : `source/fin_grotte_etoile_sanctuaire_v1/` (fin de donjon appairée à l'entrée `EGE1`)
- **Préfixe `.tile`** : `FGE1` (unique sur `main` et sur toutes les branches sœurs `arena/*`)
- **Format** : `4:3` vaste (`768 × 576 px` = `96 × 72` cases de `8 × 8 px`, `TexSize = 1`)
- **Référence canonique ROM (`pret/pmd-sky`)** : `D42P42A.png` (*Star Cave / Grotte Étoile*, `1200 × 896 px`)
- **Fidélité au rip (seuil 35)** : brut (`sol = 11.0`, `etoile = 20.4`, `paroi = 4.5`, `fond = 2.8`) ; calques finaux quantifiés (`sol = 6.2`, `parois_sombres = 14.1`, `etoile = 22.8`, `sol_complet = 16.8`)
- **Étoile centrale** : le brut généré présentait une étoile cyan trop brillante ; recolorisation déterministe de la zone étoile (rayon 170 px) — compression de luminance et rotation de teinte vers le vert-blanc du rip — pour ramener la distance matière à `20.4`
- **Segmentation** : arène circulaire de pierre bleue lisse ; emblème étoile (teinte verte-blanchâtre dans l'ellipse centrale) ; grappes de cristaux ; voie de pierre d'entrée sud praticable jusqu'au bord (épaules sombres rebouchées)
- **Marqueurs Ground & connectivité (`16 × 16`)** : `entrance = [384, 568]` → `boss_center = [384, 288]` → `autel_jirachi = [384, 168]`, `1341` cases praticables, `5571` cases bloquées, `15128` tuiles
- **Tests Python (`test_build.py`)** : `7 / 7` vérifications passées
- **`art_approved`** : `false`
- **`runtime_tested`** : `false`

---

# Statut du chantier `entree_grotte_givre_sud_nord_v1` (`EGI1`, Entrée Grotte de Givre)

- **Lot** : `source/entree_grotte_givre_sud_nord_v1/` (entrée de donjon appairée à la fin `FGI1`)
- **Préfixe `.tile`** : `EGI1` (unique sur `main` et sur toutes les branches sœurs `arena/*`)
- **Format** : `4:3` vaste (`768 × 576 px` = `96 × 72` cases de `8 × 8 px`, `TexSize = 1`)
- **Référence canonique ROM (`pret/pmd-sky`)** : `D53P11B.png` (*Icicle Cavern / Grotte de Givre*, « iceroad », `1200 × 896 px`)
- **Fidélité au rip (seuil 35)** : brut (`sol = 9.3`, `roche = 5.8`, `ciel = 8.2`) ; calques finaux quantifiés (`sol = 6.7`, `rochers = 6.8`, `sol_complet = 5.1`)
- **Segmentation** : plaine de glace lisse et chaussée sud → nord (praticables), croupes de blocs de glace et crête de montagnes (roc), fissures et retraits sur la glace, arche sombre de roc givré au nord (objectif `seuil_arche`), bande de ciel bleu profond ; glace praticable garantie jusqu'au bord sud (bande d'entrée)
- **Marqueurs Ground & connectivité (`16 × 16`)** : `entrance = [384, 568]` → `boss_center = [384, 296]` → `seuil_arche = [400, 232]`, `1178` cases praticables, `18963` tuiles
- **Tests Python (`test_build.py`)** : `7 / 7` vérifications passées
- **`art_approved`** : `false`
- **`runtime_tested`** : `false`

---

# Statut du chantier `fin_grotte_givre_sanctuaire_v1` (`FGI1`, Sanctuaire de la Glacière)

- **Lot** : `source/fin_grotte_givre_sanctuaire_v1/` (fin de donjon appairée à l'entrée `EGI1`)
- **Préfixe `.tile`** : `FGI1` (unique sur `main` et sur toutes les branches sœurs `arena/*`)
- **Format** : `4:3` vaste (`768 × 576 px` = `96 × 72` cases de `8 × 8 px`, `TexSize = 1`)
- **Référence canonique ROM (`pret/pmd-sky`)** : `D53P41C.png` (*Icicle Cavern / Grotte de Givre*, sommet glaciaire, `1200 × 896 px`)
- **Fidélité au rip (seuil 35)** : brut (`plateau = 16.2`, `roc = 6.2`, `ciel = 2.0`) ; calques finaux quantifiés (`plateau = 17.4`, `roc_givre = 11.1`, `sol_complet = 11.2`)
- **Recolorisation canonique** : les bruts générés étaient trop froids/bleus ; décalages déterministes zone par zone (fond → blanc chaud du rip, roc → teinte du rip, plateau → gris-bleu pâle du rip) appliqués à `decor.png` et `sol_complet.png` pour rester sous le seuil de fidélité
- **Segmentation** : plateau sommital de glace claire (praticable, composante connectée depuis le centre, le fond clair est coupé du plateau par le sanctuaire), strates en gradins du flanc sud (praticables jusqu'au bord, ombres entre marches incluses), versants texturés et silhouettes de montagnes, sanctuaire de cristal (objectif `autel_glaciere`), fond clair lisse
- **Marqueurs Ground & connectivité (`16 × 16`)** : `entrance = [384, 568]` → `boss_center = [384, 288]` → `autel_glaciere = [384, 240]`, `1752` cases praticables, `17127` tuiles
- **Tests Python (`test_build.py`)** : `7 / 7` vérifications passées
- **`art_approved`** : `false`
- **`runtime_tested`** : `false`
