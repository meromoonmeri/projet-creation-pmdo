"""Serveur d'aperçus pour la session Arena (bibliothèque standard seulement).

    python3 source/serveur_apercus/serve.py            # 0.0.0.0:8000
    python3 source/serveur_apercus/serve.py --port 8080

Sert la racine du dépôt en lecture seule. La page « / » présente les compositions complètes
FVF1/EVF1/ETT2 lorsqu'elles sont bâties, avec accès distinct aux bruts restaurés et aux calques.
Les gabarits `viewer_template.html` ne sont pas présentés comme des aperçus exécutables. Les
scènes générées restent distinguées des ressources natives ; l'index est recalculé à chaque visite.
Liens relatifs seulement (le navigateur passe par le proxy de prévisualisation, pas par localhost).
"""
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import quote
import argparse, html, re, subprocess, time

R = Path(__file__).resolve().parents[2]
SERVE_PORT = 8000

# Les bruts restaurés du commit 934a1b4 restent la source de vérité ; les scènes composées
# sont montrées à part et l'art généré n'est jamais attribué aux pixels natifs.
RESTORED_MAPS = [
    {
        'code': 'FVF1 · FIN DE DONJON',
        'title': 'Vallon Fleuri — Sanctuaire de la Clairière Fleurie',
        'note': ('Composition complète reconstruite depuis les deux bruts restaurés. Eau animée à partir des quatre phases River natives de Métano, réassemblées sur le masque généré (disposition non canonique) ; scintillements natifs séparés. Animation officielle Sky Peak en attente de 2cwdrrs469f61.gif ou des quatre frames ; les fleurs générées restent intactes et statiques, sans substitut synthétique. Art généré, art_approved=false, runtime_tested=false.'),
        'complete': ('Composition complète animée · FVF1 · boucle 4 s · eau Metano Town River',
                     'renders/fin_vallon_fleuri_sanctuaire_v1/review/FVF1_scene_animee.webp'),
        'art': ('Brut restauré du décor généré · FVF1',
                'source/fin_vallon_fleuri_sanctuaire_v1/bruts/decor_magenta.png'),
        'materials': [
            ('Brut restauré du sol complet · FVF1',
             'source/fin_vallon_fleuri_sanctuaire_v1/bruts/sol_complet.png'),
            ('Zoom eau Métano native adaptée · FVF1',
             'renders/fin_vallon_fleuri_sanctuaire_v1/review/FVF1_zoom_eau_metano.png'),
        ],
        'links': [
            ('Ouvrir le viewer multicalque · FVF1', 'apercu_vallons_fleuris_v1.html?map=FVF1'),
            ('Télécharger l’ORA multicalque · FVF1', 'renders/fin_vallon_fleuri_sanctuaire_v1/FVF1_fin_vallon_fleuri_sanctuaire_v1_calques.ora'),
            ('Manifest de build · FVF1', 'renders/fin_vallon_fleuri_sanctuaire_v1/manifest.json'),
            ('Build reproductible', 'source/vallons_fleuris_v1/build.py'),
            ('Note de récupération', 'source/fin_vallon_fleuri_sanctuaire_v1/RECUPERATION.md'),
        ],
    },
    {
        'code': 'EVF1 · ENTRÉE SUD → NORD',
        'title': 'Entrée Vallon Fleuri',
        'note': ('Composition complète reconstruite depuis les deux bruts restaurés. Eau animée à partir des quatre phases River natives de Métano, réassemblées sur le masque généré (disposition non canonique) ; scintillements natifs séparés. Animation officielle Sky Peak en attente de 2cwdrrs469f61.gif ou des quatre frames ; les fleurs générées restent intactes et statiques, sans substitut synthétique. Art généré, art_approved=false, runtime_tested=false.'),
        'complete': ('Composition complète animée · EVF1 · boucle 4 s · eau Metano Town River',
                     'renders/entree_vallon_fleuri_sud_nord_v1/review/EVF1_scene_animee.webp'),
        'art': ('Brut restauré du décor généré · EVF1',
                'source/entree_vallon_fleuri_sud_nord_v1/bruts/decor_magenta.png'),
        'materials': [
            ('Brut restauré du sol complet · EVF1',
             'source/entree_vallon_fleuri_sud_nord_v1/bruts/sol_complet.png'),
            ('Zoom eau Métano native adaptée · EVF1',
             'renders/entree_vallon_fleuri_sud_nord_v1/review/EVF1_zoom_eau_metano.png'),
        ],
        'links': [
            ('Ouvrir le viewer multicalque · EVF1', 'apercu_vallons_fleuris_v1.html?map=EVF1'),
            ('Télécharger l’ORA multicalque · EVF1', 'renders/entree_vallon_fleuri_sud_nord_v1/EVF1_entree_vallon_fleuri_sud_nord_v1_calques.ora'),
            ('Manifest de build · EVF1', 'renders/entree_vallon_fleuri_sud_nord_v1/manifest.json'),
            ('Build reproductible', 'source/vallons_fleuris_v1/build.py'),
            ('Note de récupération', 'source/entree_vallon_fleuri_sud_nord_v1/RECUPERATION.md'),
        ],
    },
    {
        'code': 'ETT2 · ENTRÉE SUD → NORD · V2',
        'title': 'Entrée de la Tour Temporelle',
        'note': ('Scène reconstruite avec le build ETT2 et le décor noir-or exact retrouvé : '
                 'ciel rouge-noir, nuages animés, reflets arc-en-ciel, circuits d’or, rochers flottants '
                 'et brèches hors du chemin. Les références ROM annoncées sont absentes ; art_approved reste false.'),
        'complete': ('Scène complète animée · build.py · ciel rouge-noir, nuages, prisme, or et brèches · boucle 4 s',
                     'renders/entree_tour_temporelle_sud_nord_v2/review/ETT2_scene_animee.webp'),
        'art': ('Décor brut noir-or · entrée ETT2',
                'source/entree_tour_temporelle_sud_nord_v2/bruts/decor_magenta.png'),
        'materials': [
            ('Décor brut noir-or sur magenta · ETT2',
             'source/entree_tour_temporelle_sud_nord_v2/bruts/decor_magenta.png'),
            ('Nuages bruts rouge/noir sur magenta · ETT2',
             'source/entree_tour_temporelle_sud_nord_v2/bruts/nuages_magenta.png'),
            ('Sol brut séparé · ardoise · ETT2',
             'source/entree_tour_temporelle_sud_nord_v2/bruts/sol_complet.png'),
            ('Génération alternative 2 · archive',
             'source/entree_tour_temporelle_sud_nord_v2/bruts/alternatives/decor_magenta_alternative_2.png'),
            ('Génération alternative 3 · veines rouges · archive',
             'source/entree_tour_temporelle_sud_nord_v2/bruts/alternatives/decor_magenta_alternative_3_veines_rouges.png'),
        ],
        'links': [
            ('Ouvrir l’aperçu interactif complet · calques + animations', 'apercu_entree_tour_temporelle_sud_nord_v2.html'),
            ('Note de récupération', 'source/entree_tour_temporelle_sud_nord_v2/RECUPERATION.md'),
            ('Notice du pack', 'source/entree_tour_temporelle_sud_nord_v2/README_PACK.md'),
        ],
    },
    {
        'code': 'FTN2 · FIN DE DONJON · V2',
        'title': 'Fin de la Tour Temporelle V2 — Sommet Noir & Or, Trou Noir Indépendant & Nébuleuses Spatiales en 10 Frames',
        'note': ('Fin de donjon appairée à ETT2 : même chemin en basalte noir et esplanade octogonale ouverte sans piliers, '
                 'veines d’or aux reflets arc-en-ciel (11_circuits_or + 12_reflets_arc_en_ciel), et deux couches de fond '
                 'animées 100 % indépendantes en 10 frames (10 × 12 = 120 ticks) derrière le cadran : '
                 '01_nuages_orage_rouges (nébuleuses spatiales cosmiques multi-plans avec onde d’ionisation chromatique, voile de gaz stellaire en parallaxe et étoiles scintillantes) et '
                 '02_trou_noir_spirale (Trou Noir et vortex spiralé RGBA indépendant en rotation continue + accrétion). '
                 'Art généré, art_approved=false, runtime_tested=false.'),
        'complete': ('Scène complète animée · FTN2 · Trou Noir indépendant + nébuleuses spatiales · boucle 4 s',
                     'renders/fin_tour_temporelle_noire_or_v2/review/FTN2_scene_animee.webp'),
        'art': ('Décor brut sommet noir-or + veines arc-en-ciel · FTN2',
                'source/fin_tour_temporelle_noire_or_v2/bruts/decor_magenta.png'),
        'materials': [
            ('Planche comparative : Couche 01 (nébuleuses spatiales) / Couche 02 (Trou Noir RGBA) / Composite · FTN2',
             'renders/fin_tour_temporelle_noire_or_v2/review/FTN2_planche_couches_fond_independantes.png'),
            ('Couche 01 seule : Nébuleuses spatiales cosmiques animées (10 frames WebP) · FTN2',
             'renders/fin_tour_temporelle_noire_or_v2/FTN2_nuages_orage_rouges_10frames.webp'),
            ('Couche 02 seule : Trou Noir & vortex spiralé indépendant RGBA (10 frames WebP) · FTN2',
             'renders/fin_tour_temporelle_noire_or_v2/FTN2_trou_noir_seul_10frames.webp'),
            ('Planche 2×5 des 10 frames du fond combiné (01 + 02) · FTN2',
             'renders/fin_tour_temporelle_noire_or_v2/review/FTN2_planche_10_frames_trou_noir.png'),
            ('Zoom ×2 Trou Noir, anneau d’accrétion pixel-art, reliquaire & cadran · FTN2',
             'renders/fin_tour_temporelle_noire_or_v2/review/FTN2_zoom_reliquaire_cadran.png'),
        ],
        'links': [
            ('Ouvrir l’aperçu interactif complet · calques + animations · FTN2', 'apercu_fin_tour_temporelle_noire_or_v2.html'),
            ('Télécharger l’ORA multicalque · FTN2', 'renders/fin_tour_temporelle_noire_or_v2/FTN2_fin_tour_temporelle_noire_or_v2_calques.ora'),
            ('Manifest de build · FTN2', 'renders/fin_tour_temporelle_noire_or_v2/manifest.json'),
            ('Note de récupération', 'source/fin_tour_temporelle_noire_or_v2/RECUPERATION.md'),
            ('Notice du pack', 'source/fin_tour_temporelle_noire_or_v2/README_PACK.md'),
        ],
    },
    {
        'code': 'FCV4 · FIN DE DONJON · V1',
        'title': 'Fin du Couloir Violet — Sanctuaire de la Stèle V1 (FCV4)',
        'note': ('Fin de donjon appairée à ECV1 (référence canonique ROM S05P03A.png) : vaste chambre souterraine octogonale '
                 'au sol mauve marbré, alcôve nord abritant la Stèle ancienne aux runes lilas-violet pulsantes (09_lueurs_stele), '
                 'chutes de gravillons aux pixels et couleurs exacts du rip (10_eboulis) et nuages de poussière générés (11_poussiere). '
                 'Fidélité au rip : 5,5 à 8,6 (< 35). Art généré, art_approved=false, runtime_tested=false.'),
        'complete': ('Scène complète animée · FCV4 · stèle, éboulis exacts du rip & poussière · boucle 2 s',
                     'renders/fin_couloir_violet_sanctuaire_v1/review/FCV4_scene_animee.webp'),
        'art': ('Décor brut sur magenta · FCV4',
                'source/fin_couloir_violet_sanctuaire_v1/bruts/decor_magenta.png'),
        'materials': [
            ('Référence canonique ROM S05P03A.png · FCV4',
             'source/fin_couloir_violet_sanctuaire_v1/reference/S05P03A.png'),
            ('Collisions & marqueurs (entrance / boss / objectif) · FCV4',
             'renders/fin_couloir_violet_sanctuaire_v1/review/FCV4_collisions_marqueurs.png'),
            ('Planche des gravillons exacts du rip & poses de poussière · FCV4',
             'renders/fin_couloir_violet_sanctuaire_v1/review/FCV4_planche_poses.png'),
        ],
        'links': [
            ('Ouvrir l’aperçu interactif complet · calques + animations · FCV4', 'apercu_fin_couloir_violet_sanctuaire_v1.html'),
            ('Télécharger l’ORA multicalque · FCV4', 'renders/fin_couloir_violet_sanctuaire_v1/FCV4_fin_couloir_violet_calques.ora'),
            ('Manifest de build · FCV4', 'renders/fin_couloir_violet_sanctuaire_v1/manifest.json'),
            ('Build reproductible · FCV4', 'source/fin_couloir_violet_sanctuaire_v1/build.py'),
            ('Notice du pack · FCV4', 'source/fin_couloir_violet_sanctuaire_v1/README_PACK.md'),
        ],
    },
    {
        'code': 'FMT3 · FIN DE DONJON · V1',
        'title': 'Fin de Mt. Thunder — Sommet Foudroyant V1 (FMT3)',
        'note': ('Fin de donjon appairée à EMT1 (référence canonique GBA mt_thunder.png) : arène finale du sommet de sable '
                 'jaune pâle au-dessus de la mer de nuages d’orage, couronnée au nord par les grands pitons rocheux foudroyés '
                 '(05_piton_foudre), avec les 4 éclairs et l’arc Flash copiés au pixel près de la planche GBA (08_lueurs + 09_eclairs) '
                 'et pulsation électrique sur les crêtes du piton (10_lueur_piton). Fidélité au rip : 2,9 à 10,5 (< 35). '
                 'Art généré, art_approved=false, runtime_tested=false.'),
        'complete': ('Scène complète animée · FMT3 · éclairs & arcs Flash exacts GBA · boucle 4 s',
                     'renders/fin_mt_thunder_sommet_v1/review/FMT3_scene_animee.webp'),
        'art': ('Décor brut du sommet · FMT3',
                'source/fin_mt_thunder_sommet_v1/bruts/decor.png'),
        'materials': [
            ('Référence canonique GBA mt_thunder.png · FMT3',
             'source/fin_mt_thunder_sommet_v1/reference/mt_thunder.png'),
            ('Collisions & marqueurs (entrance / boss / piton_foudre) · FMT3',
             'renders/fin_mt_thunder_sommet_v1/review/FMT3_collisions_marqueurs.png'),
            ('Planche des 4 éclairs & arcs Flash exacts du rip · FMT3',
             'renders/fin_mt_thunder_sommet_v1/review/FMT3_planche_poses.png'),
        ],
        'links': [
            ('Ouvrir l’aperçu interactif complet · calques + animations · FMT3', 'apercu_fin_mt_thunder_sommet_v1.html'),
            ('Télécharger l’ORA multicalque · FMT3', 'renders/fin_mt_thunder_sommet_v1/FMT3_fin_mt_thunder_calques.ora'),
            ('Manifest de build · FMT3', 'renders/fin_mt_thunder_sommet_v1/manifest.json'),
            ('Build reproductible · FMT3', 'source/fin_mt_thunder_sommet_v1/build.py'),
            ('Notice du pack · FMT3', 'source/fin_mt_thunder_sommet_v1/README_PACK.md'),
        ],
    },
    {
        'code': 'FJS4 · FIN DE DONJON · V1',
        'title': 'Fin du Jardin Secret — Sanctuaire de Celebi V1 (FJS4)',
        'note': ('Fin de donjon appairée à EJS1 et EJS2 (référence canonique secretgarden.png) : clairière sanctuaire intérieure '
                 'entourée de haies buissonneuses, de 4 grands arbres feuillus, de rochers beiges et de parterres fleuris, '
                 'dominée au nord par la grande souche dorée portant l’autel de pierre et l’emblème lumineux de Celebi '
                 '(12_embleme) sous le faisceau vertical de lumière verte (13_rayon) et 10 lucioles montantes (14_lucioles) '
                 'sur la rampe exacte des 22 verts du rip. Fidélité au rip : 4,3 à 19,3 (< 35). '
                 'Art généré, art_approved=false, runtime_tested=false.'),
        'complete': ('Scène complète animée · FJS4 · emblème, rayon & lucioles sur la rampe exacte du rip · boucle 2 s',
                     'renders/fin_jardin_secret_sanctuaire_v1/review/FJS4_scene_animee.webp'),
        'art': ('Décor brut du sanctuaire · FJS4',
                'source/fin_jardin_secret_sanctuaire_v1/bruts/decor.png'),
        'materials': [
            ('Référence canonique secretgarden.png · FJS4',
             'source/fin_jardin_secret_sanctuaire_v1/reference/secretgarden.png'),
            ('Collisions & marqueurs (entrance / boss / autel_celebi) · FJS4',
             'renders/fin_jardin_secret_sanctuaire_v1/review/FJS4_collisions_marqueurs.png'),
            ('Rampe des 22 verts du rip & poses des lucioles · FJS4',
             'renders/fin_jardin_secret_sanctuaire_v1/review/FJS4_planche_poses.png'),
        ],
        'links': [
            ('Ouvrir l’aperçu interactif complet · calques + animations · FJS4', 'apercu_fin_jardin_secret_sanctuaire_v1.html'),
            ('Télécharger l’ORA multicalque · FJS4', 'renders/fin_jardin_secret_sanctuaire_v1/FJS4_fin_jardin_secret_calques.ora'),
            ('Manifest de build · FJS4', 'renders/fin_jardin_secret_sanctuaire_v1/manifest.json'),
            ('Build reproductible · FJS4', 'source/fin_jardin_secret_sanctuaire_v1/build.py'),
            ('Notice du pack · FJS4', 'source/fin_jardin_secret_sanctuaire_v1/README_PACK.md'),
        ],
    },
    {
        'code': 'FMF3 · FIN DE DONJON · V1',
        'title': 'Fin Mystifying Forest — Clairière de la Source Lumineuse',
        'note': ('Fin de donjon appairée à EMF1, référencée sur les maps ROM canoniques D31P31A, D31P11A et D31P41A : '
                 'clairière d’herbe émeraude encadrée par les grands arbres à racines tordues et rochers moussus, '
                 'Source Lumineuse nord-centre animée aux 8 tons dorés NDS 5 bits exacts de D31P41A (12 × 20 ticks), '
                 'deux mares latérales façon rivière Métano sans liseré clair + scintillements natifs (4 × 10 ticks), '
                 'feuilles tombantes et lucioles dorées (48 × 5 ticks). Art généré, art_approved=false, runtime_tested=false.'),
        'complete': ('Scène complète animée · FMF3 · Source Lumineuse, mares Métano, feuilles & lucioles · boucle 4 s',
                     'renders/fin_mystifying_forest_clairiere_v1/review/FMF3_scene_animee.webp'),
        'art': ('Décor brut sur magenta · FMF3',
                'source/fin_mystifying_forest_clairiere_v1/bruts/decor_magenta.png'),
        'materials': [
            ('Sol complet d’herbe émeraude · FMF3',
             'source/fin_mystifying_forest_clairiere_v1/bruts/sol_complet.png'),
            ('Planche des poses réduites (feuilles et lucioles) · FMF3',
             'renders/fin_mystifying_forest_clairiere_v1/review/FMF3_planche_poses.png'),
            ('Collisions 8×8 et marqueurs (entrance, boss, objectif) · FMF3',
             'renders/fin_mystifying_forest_clairiere_v1/review/FMF3_collisions_marqueurs.png'),
        ],
        'links': [
            ('Ouvrir l’aperçu interactif complet · calques + animations · FMF3', 'apercu_fin_mystifying_forest_clairiere_v1.html'),
            ('Télécharger l’ORA multicalque · FMF3', 'renders/fin_mystifying_forest_clairiere_v1/FMF3_fin_mystifying_forest_calques.ora'),
            ('Manifest de build · FMF3', 'renders/fin_mystifying_forest_clairiere_v1/manifest.json'),
            ('Notice du pack', 'source/fin_mystifying_forest_clairiere_v1/README_PACK.md'),
        ],
    },
    {
        'code': 'FUL2 · FIN DE DONJON · V1',
        'title': 'Fin Underground Lake — Sanctuaire Bioluminescent',
        'note': ('Fin de donjon appairée à EUL1, référencée sur la map ROM canonique D15P41A (Underground Lake) : '
                 'promontoire central de sable jaune pâle entre parois bosselées olive-kaki, vaste lac souterrain '
                 'aux 3 couleurs d’eau exactes du rip sans liseré clair (4 × 10 ticks), lueur bioluminescente '
                 'aux 9 couleurs cyan-turquoise exactes du rip (12 × 10 ticks), scintillements Métano natifs, '
                 'piliers rocheux, stalagmites, gouttes d’eau et ronds d’onde (24 × 5 ticks). Art généré, art_approved=false, runtime_tested=false.'),
        'complete': ('Scène complète animée · FUL2 · lac souterrain, lueur cyan-turquoise, scintillements & gouttes · boucle 2 s',
                     'renders/fin_underground_lake_sanctuaire_v1/review/FUL2_scene_animee.webp'),
        'art': ('Décor brut sur magenta · FUL2',
                'source/fin_underground_lake_sanctuaire_v1/bruts/decor_magenta.png'),
        'materials': [
            ('Sol complet et témoin des parois · FUL2',
             'source/fin_underground_lake_sanctuaire_v1/bruts/sol_complet.png'),
            ('Planche des poses réduites (gouttes et ronds d’onde) · FUL2',
             'renders/fin_underground_lake_sanctuaire_v1/review/FUL2_planche_poses.png'),
            ('Collisions 8×8 et marqueurs (entrance, boss, objectif) · FUL2',
             'renders/fin_underground_lake_sanctuaire_v1/review/FUL2_collisions_marqueurs.png'),
        ],
        'links': [
            ('Ouvrir l’aperçu interactif complet · calques + animations · FUL2', 'apercu_fin_underground_lake_sanctuaire_v1.html'),
            ('Télécharger l’ORA multicalque · FUL2', 'renders/fin_underground_lake_sanctuaire_v1/FUL2_fin_underground_lake_calques.ora'),
            ('Manifest de build · FUL2', 'renders/fin_underground_lake_sanctuaire_v1/manifest.json'),
            ('Notice du pack', 'source/fin_underground_lake_sanctuaire_v1/README_PACK.md'),
        ],
    },
    {
        'code': 'EBC1 · ENTRÉE SUD → NORD',
        'title': 'Entrée Caverne Saline — Couloir du Brine Cave',
        'note': ('Entrée de donjon appairée à FBC1, canonique sur le rip D26P31A (Brine Cave, pret/pmd-sky) : '\
                 'couloir sablonneux de galets sud vers nord bordé de calcaire brun-rouge strié, crêtes claires en saillie, '\
                 'flaques turquoise et ombres de paroi. 6 calques statiques 8 px, 15 549 tuiles. '\
                 'Fidélité brute au rip (seuil 35) : sol 3.3, roche sombre 5.0, eau 3.5, vide 2.5, roche 17.0. '\
                 'Art généré, art_approved=false, runtime_tested=false.'),
        'complete': ('Scène complète · EBC1 · t000',
                     'renders/entree_caverne_saline_sud_nord_v1/review/EBC1_scene_t000.png'),
        'art': ('Décor brut · EBC1',
                'source/entree_caverne_saline_sud_nord_v1/bruts/decor.png'),
        'materials': [
            ('Sol complet · EBC1', 'source/entree_caverne_saline_sud_nord_v1/bruts/sol_complet.png'),
            ('Rip canonique D26P31A (référence) · EBC1', 'source/entree_caverne_saline_sud_nord_v1/reference/D26P31A.png'),
            ('Collisions 8×8 et marqueurs (entrance, boss, donjon_seuil) · EBC1',
             'renders/entree_caverne_saline_sud_nord_v1/review/EBC1_collisions_marqueurs.png'),
        ],
        'links': [
            ('Ouvrir l’aperçu interactif complet · calques + animations · EBC1', 'apercu_entree_caverne_saline_sud_nord_v1.html'),
            ('Télécharger l’ORA multicalque · EBC1', 'renders/entree_caverne_saline_sud_nord_v1/EBC1_entree_caverne_saline_calques.ora'),
            ('Télécharger le pack PMDO 0.8.12 · EBC1', 'renders/entree_caverne_saline_sud_nord_v1/EBC1_projet_pmdo_0812.zip'),
            ('Manifest de build · EBC1', 'renders/entree_caverne_saline_sud_nord_v1/manifest.json'),
            ('Notice du pack', 'source/entree_caverne_saline_sud_nord_v1/README_PACK.md'),
        ],
    },
    {
        'code': 'FBC1 · FIN DE DONJON',
        'title': 'Fin Caverne Saline — Sanctuaire de l’Arène',
        'note': ('Fin de donjon appairée à EBC1, canonique sur le rip D26P43A (Brine Cave, pret/pmd-sky) : '\
                 'arène sablonneuse entourée de calcaire, arche de pierre nord vers le sanctuaire, amas de blocs à l’entrée sud, '\
                 'flaques turquoise. 6 calques statiques 8 px, 16 070 tuiles. '\
                 'Fidélité brute au rip (seuil 35) : sol 3.5, roche 8.3, eau 3.2, vide 3.0. '\
                 'Art généré, art_approved=false, runtime_tested=false.'),
        'complete': ('Scène complète · FBC1 · t000',
                     'renders/fin_caverne_saline_sanctuaire_v1/review/FBC1_scene_t000.png'),
        'art': ('Décor brut · FBC1',
                'source/fin_caverne_saline_sanctuaire_v1/bruts/decor.png'),
        'materials': [
            ('Sol complet · FBC1', 'source/fin_caverne_saline_sanctuaire_v1/bruts/sol_complet.png'),
            ('Rip canonique D26P43A (référence) · FBC1', 'source/fin_caverne_saline_sanctuaire_v1/reference/D26P43A.png'),
            ('Collisions 8×8 et marqueurs (entrance, boss, reliquaire) · FBC1',
             'renders/fin_caverne_saline_sanctuaire_v1/review/FBC1_collisions_marqueurs.png'),
        ],
        'links': [
            ('Ouvrir l’aperçu interactif complet · calques + animations · FBC1', 'apercu_fin_caverne_saline_sanctuaire_v1.html'),
            ('Télécharger l’ORA multicalque · FBC1', 'renders/fin_caverne_saline_sanctuaire_v1/FBC1_fin_caverne_saline_calques.ora'),
            ('Télécharger le pack PMDO 0.8.12 · FBC1', 'renders/fin_caverne_saline_sanctuaire_v1/FBC1_projet_pmdo_0812.zip'),
            ('Manifest de build · FBC1', 'renders/fin_caverne_saline_sanctuaire_v1/manifest.json'),
            ('Notice du pack', 'source/fin_caverne_saline_sanctuaire_v1/README_PACK.md'),
        ],
    },
    {
        'code': 'EGE1 · ENTRÉE SUD → NORD',
        'title': 'Entrée Grotte Étoile — Voûte Cristalline',
        'note': ('Entrée de donjon appairée à FGE1, canonique sur la moitié droite du rip D42P31A (Star Cave, pret/pmd-sky) : '\
                 'plancher de pierre bleue lisse, voûte de roches sombres crêpelées, grappes de cristaux verts scintillants, '\
                 'tunnel de départ au nord (objectif seuil_tunnel). 5 calques statiques 8 px, 14 720 tuiles. '\
                 'Fidélité brute au rip (seuil 35) : sol 6.6, paroi 1.9, fond 1.3. '\
                 'Art généré, art_approved=false, runtime_tested=false.'),
        'complete': ('Scène complète · EGE1 · t000',
                     'renders/entree_grotte_etoile_sud_nord_v1/review/EGE1_scene_t000.png'),
        'art': ('Décor brut · EGE1',
                'source/entree_grotte_etoile_sud_nord_v1/bruts/decor.png'),
        'materials': [
            ('Sol complet · EGE1', 'source/entree_grotte_etoile_sud_nord_v1/bruts/sol_complet.png'),
            ('Rip canonique D42P31A moitié droite (référence) · EGE1', 'source/entree_grotte_etoile_sud_nord_v1/reference/D42P31A.png'),
            ('Collisions 8×8 et marqueurs (entrance, boss, seuil_tunnel) · EGE1',
             'renders/entree_grotte_etoile_sud_nord_v1/review/EGE1_collisions_marqueurs.png'),
        ],
        'links': [
            ('Ouvrir l’aperçu interactif complet · calques + animations · EGE1', 'apercu_entree_grotte_etoile_sud_nord_v1.html'),
            ('Télécharger l’ORA multicalque · EGE1', 'renders/entree_grotte_etoile_sud_nord_v1/EGE1_entree_grotte_etoile_calques.ora'),
            ('Télécharger le pack PMDO 0.8.12 · EGE1', 'renders/entree_grotte_etoile_sud_nord_v1/EGE1_projet_pmdo_0812.zip'),
            ('Manifest de build · EGE1', 'renders/entree_grotte_etoile_sud_nord_v1/manifest.json'),
            ('Notice du pack', 'source/entree_grotte_etoile_sud_nord_v1/README_PACK.md'),
        ],
    },
    {
        'code': 'FGE1 · FIN DE DONJON',
        'title': 'Fin Grotte Étoile — Sanctuaire de l’Étoile',
        'note': ('Fin de donjon appairée à EGE1, canonique sur le rip D42P42A (Star Cave, pret/pmd-sky) : '\
                 'arène circulaire de pierre bleue, emblème étoile centrale à lueur verte-blanchâtre (recolorisé du brut '\
                 'pour rejoindre la teinte du rip, distance 20.4), grappes de cristaux, voie de pierre de l’entrée sud '\
                 '(objectif autel_jirachi). 5 calques statiques 8 px, 15 128 tuiles. '\
                 'Fidélité brute au rip (seuil 35) : sol 11.0, étoile 20.4, paroi 4.5, fond 2.8. '\
                 'Art généré, art_approved=false, runtime_tested=false.'),
        'complete': ('Scène complète · FGE1 · t000',
                     'renders/fin_grotte_etoile_sanctuaire_v1/review/FGE1_scene_t000.png'),
        'art': ('Décor brut (étoile recolorisée) · FGE1',
                'source/fin_grotte_etoile_sanctuaire_v1/bruts/decor.png'),
        'materials': [
            ('Sol complet · FGE1', 'source/fin_grotte_etoile_sanctuaire_v1/bruts/sol_complet.png'),
            ('Rip canonique D42P42A (référence) · FGE1', 'source/fin_grotte_etoile_sanctuaire_v1/reference/D42P42A.png'),
            ('Collisions 8×8 et marqueurs (entrance, boss, autel_jirachi) · FGE1',
             'renders/fin_grotte_etoile_sanctuaire_v1/review/FGE1_collisions_marqueurs.png'),
        ],
        'links': [
            ('Ouvrir l’aperçu interactif complet · calques + animations · FGE1', 'apercu_fin_grotte_etoile_sanctuaire_v1.html'),
            ('Télécharger l’ORA multicalque · FGE1', 'renders/fin_grotte_etoile_sanctuaire_v1/FGE1_fin_grotte_etoile_calques.ora'),
            ('Télécharger le pack PMDO 0.8.12 · FGE1', 'renders/fin_grotte_etoile_sanctuaire_v1/FGE1_projet_pmdo_0812.zip'),
            ('Manifest de build · FGE1', 'renders/fin_grotte_etoile_sanctuaire_v1/manifest.json'),
            ('Notice du pack', 'source/fin_grotte_etoile_sanctuaire_v1/README_PACK.md'),
        ],
    },
]


def commit_dates():
    """Date (epoch) du premier commit qui a ajouté chaque apercu_*.html de la racine."""
    try:
        out = subprocess.run(['git', '-C', str(R), 'log', '--diff-filter=A', '--name-only', '--format=@%ct', '--',
                              'apercu_*.html'], capture_output=True, text=True, timeout=20).stdout
    except Exception:
        return {}
    dates, t = {}, 0
    for line in out.splitlines():
        if line.startswith('@'):
            t = int(line[1:])
        elif line.strip():
            dates[line.strip()] = t          # log du plus récent au plus ancien : on garde le plus ancien ajout
    return dates


def title_of(p):
    m = re.search(r'<title>(.*?)</title>', p.read_text(errors='ignore')[:4000], re.S)
    return html.unescape(m.group(1).strip()) if m else p.stem


def available_previews():
    """Pages de revue existantes, sans templates ni index de redirection en doublon."""
    paths = set(R.glob('apercu_*.html'))
    paths.update(R.glob('source/**/viewer.html'))
    paths.update(R.glob('renders/**/review/index.html'))
    for p in R.glob('renders/**/index.html'):
        if not (p.parent / 'review' / 'index.html').is_file():
            paths.add(p)
    return sorted((p for p in paths if p.is_file()), key=lambda p: (title_of(p).casefold(), p.as_posix()))


def asset_figure(label, rel_path, class_name='asset'):
    """HTML pour une image source existante, liée à son PNG original."""
    path = R / rel_path
    if not path.is_file():
        return ''
    url = quote(rel_path, safe='/')
    safe_label = html.escape(label)
    safe_url = html.escape(url, quote=True)
    safe_path = html.escape(rel_path)
    return (f'<figure class="{class_name}"><a href="{safe_url}" target="_blank" rel="noopener">'
            f'<img loading="lazy" decoding="async" src="{safe_url}" alt="{safe_label}"></a>'
            f'<figcaption>{safe_label}<code>{safe_path}</code></figcaption></figure>')


def map_card(item):
    complete = item.get('complete')
    hero_data = complete if complete and (R / complete[1]).is_file() else item['art']
    hero = asset_figure(*hero_data, 'hero-asset')
    extra_assets = ''.join(asset_figure(label, path) for label, path in item['materials'])
    extras = f'<details><summary>Voir les autres bruts et variantes ({len(item["materials"])})</summary><div class="asset-grid">{extra_assets}</div></details>' if extra_assets else ''
    link_rows = []
    for label, path in item['links']:
        file_path, sep, query = path.partition('?')
        if (R / file_path).is_file():
            href = quote(file_path, safe='/') + (f'?{query}' if sep else '')
            link_rows.append(f'<a class="file-link" href="{html.escape(href, quote=True)}">{html.escape(label)}</a>')
    links = ''.join(link_rows)
    return f'''<article class="map-card">
      <div class="map-heading"><span class="eyebrow">{html.escape(item['code'])}</span><h3>{html.escape(item['title'])}</h3>
      <p>{html.escape(item['note'])}</p></div>
      <div class="hero-wrap">{hero}</div>{extras}<nav class="file-links" aria-label="Fichiers du lot">{links}</nav>
    </article>'''


def preview_list(previews):
    if not previews:
        return '<p class="empty">Aucune page HTML d’aperçu exécutable trouvée ; les gabarits ne sont pas listés ici.</p>'
    rows = []
    for p in previews:
        rel = p.relative_to(R).as_posix()
        href = html.escape(quote(rel, safe='/'), quote=True)
        title = html.escape(title_of(p))
        rows.append(f'<li><a href="{href}">{title}</a><small>{html.escape(rel)}</small></li>')
    return '<ul class="preview-list">' + ''.join(rows) + '</ul>'


def index_page():
    dates = commit_dates()
    root_rows = []
    for p in R.glob('apercu_*.html'):
        d = dates.get(p.name)
        root_rows.append((d is None, d or p.stat().st_mtime, p))
    root_rows.sort(key=lambda r: (not r[0], -r[1]))
    serie = [r for r in root_rows if '_sud_nord_' in r[2].name]
    autres = [r for r in root_rows if '_sud_nord_' not in r[2].name]
    previews = available_previews()
    restored = ''.join(map_card(item) for item in RESTORED_MAPS)

    def li(r):
        new, t, p = r
        tag = '<span class="new">nouveau</span> ' if new else ''
        day = time.strftime('%d/%m/%Y', time.localtime(t))
        return (f'<li>{tag}<a href="{html.escape(quote(p.name), quote=True)}">{html.escape(title_of(p))}</a>'
                f' <small>{html.escape(p.name)} · {day}</small></li>')

    root_links = ''
    if root_rows:
        root_links = (f'<section class="legacy"><h2>Fiches d’aperçu à la racine ({len(root_rows)})</h2>'
                      f'<h3>Entrées sud → nord ({len(serie)})</h3><ul>{"".join(li(r) for r in serie)}</ul>'
                      f'<h3>Autres ({len(autres)})</h3><ul>{"".join(li(r) for r in autres)}</ul></section>')

    return f'''<!doctype html><html lang="fr"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>Aperçus des maps PMD — Guilde Treehouse</title>
<style>
:root{{--bg:#111713;--panel:#1b241e;--line:#35443a;--text:#f0f3ee;--muted:#aab8ad;--accent:#d8c47b;--link:#f2d887}}
*{{box-sizing:border-box}}body{{margin:0;background:radial-gradient(ellipse at 50% -10%,#29382c,var(--bg) 62%);color:var(--text);font:15px/1.55 system-ui,sans-serif}}
main{{width:min(1280px,calc(100% - 32px));margin:30px auto 60px}}h1{{font-size:clamp(1.9rem,4vw,3rem);line-height:1.1;margin:.35rem 0}}h2{{font-size:1.35rem;margin:32px 0 12px;border-bottom:1px solid var(--line);padding-bottom:8px}}h3{{margin:5px 0 8px;font-size:1.23rem}}
p{{color:var(--muted)}}.intro{{max-width:860px;margin:10px 0 24px}}.eyebrow{{display:block;color:var(--accent);font-size:.76rem;font-weight:750;letter-spacing:.13em;text-transform:uppercase}}
.notice{{border:1px solid #655a36;border-left:4px solid var(--accent);border-radius:9px;background:#28261b;padding:12px 15px;color:#e6dfc9;margin:16px 0 22px}}
.map-grid{{display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,360px),1fr));gap:16px;align-items:start}}.map-card{{border:1px solid var(--line);background:linear-gradient(150deg,#202b23,#161d18);border-radius:14px;padding:16px;box-shadow:0 14px 40px #0003;min-width:0}}
.map-heading p{{margin:8px 0 14px;min-height:3em}}figure{{margin:0}}figure img{{display:block;width:100%;height:auto;max-height:430px;object-fit:contain;border:1px solid #46534a;border-radius:8px;background:#171717}}figcaption{{font-size:.88rem;color:var(--muted);padding:7px 2px 10px;overflow-wrap:anywhere}}figcaption code{{display:block;color:#89988d;font-size:.76rem}}
.hero-wrap{{max-width:760px;margin:0 auto}}.asset-grid{{display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,240px),1fr));gap:12px;margin-top:12px}}.asset img{{max-height:300px}}details{{margin-top:14px;border-top:1px solid var(--line);padding-top:11px}}summary{{cursor:pointer;color:var(--link);font-weight:650}}.file-links{{display:flex;gap:12px;flex-wrap:wrap;margin-top:12px}}a{{color:var(--link)}}.file-link{{font-size:.88rem}}.preview-list{{list-style:none;padding:0;display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,330px),1fr));gap:8px}}
.preview-list li{{border:1px solid var(--line);border-radius:9px;background:#19221c;padding:10px 12px;overflow-wrap:anywhere}}.preview-list a{{font-weight:650;text-decoration:none}}.preview-list a:hover,.file-link:hover{{text-decoration:underline}}small{{display:block;color:#89988d;font-size:.78rem;margin-top:3px}}.empty{{padding:12px;border:1px dashed var(--line);border-radius:8px}}.legacy{{margin-top:28px}}
@media(max-width:640px){{main{{width:calc(100% - 20px);margin-top:18px}}.map-card{{padding:12px}}.map-heading p{{min-height:0}}}}
</style></head><body><main>
<span class="eyebrow">Prévisualisation locale · port {SERVE_PORT}</span>
<h1>Aperçus des maps PMD</h1>
<p class="intro">ETT2 est recomposée depuis son `build.py` et ses bruts correctement réattribués. FVF1 et EVF1 sont maintenant reconstruites depuis leurs bruts restaurés de décor <em>et</em> de sol, avec le calque d’eau Métano et les animations séparées.</p>
<div class="notice"><strong>Statut :</strong> ETT2 conserve son aperçu validé. Vallon Fleuri présente les cartes complètes en 768 × 576 px avec quatre phases de cellules natives Metano Town River réassemblées dans les masques d’eau générés (disposition non canonique) et les scintillements natifs séparés. L’animation florale officielle Sky Peak est bloquée : <code>2cwdrrs469f61.gif</code> et ses quatre frames manquent ; les fleurs d’origine restent intactes et statiques, sans substitut synthétique. L’art généré n’est pas revendiqué comme pixels natifs ; <code>art_approved</code> et <code>runtime_tested</code> restent false.</div>
<h2>Lots restaurés — aperçu direct ({len(RESTORED_MAPS)})</h2>
<div class="map-grid">{restored}</div>
<h2>Aperçus interactifs disponibles ({len(previews)})</h2>
{preview_list(previews)}
{root_links}
</main></body></html>'''


class Handler(SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path in ('/', '/index.html'):
            body = index_page().encode()
            self.send_response(200)
            self.send_header('Content-Type', 'text/html; charset=utf-8')
            self.send_header('Content-Length', str(len(body)))
            self.send_header('Cache-Control', 'no-store')
            self.end_headers()
            self.wfile.write(body)
            return
        if '/.git' in self.path or self.path.startswith('/.venv'):
            self.send_error(404)
            return
        super().do_GET()

    def log_message(self, fmt, *args):
        pass


class Server(ThreadingHTTPServer):
    daemon_threads = True

    def handle_error(self, request, client_address):
        import sys
        if isinstance(sys.exc_info()[1], (BrokenPipeError, ConnectionResetError)):
            return                                # le navigateur a coupé en cours de transfert : sans gravité
        super().handle_error(request, client_address)


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('--port', type=int, default=8000)
    ap.add_argument('--bind', default='0.0.0.0')
    a = ap.parse_args()
    SERVE_PORT = a.port
    srv = Server((a.bind, a.port), partial(Handler, directory=str(R)))
    print(f'Aperçus : http://{a.bind}:{a.port}/  (racine {R})', flush=True)
    srv.serve_forever()
