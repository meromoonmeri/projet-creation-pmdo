#!/usr/bin/env python3
"""Vague 4 — Import TOTAL des 82 grounds slothplaysnecro/PMDO-Explorers-Maps.

Directive : « Je les veux tous » — chaque ground est importé, renommé FR,
au format canonique New Era, et ASSOCIÉ à un donjon/boss (ou réserve motivée).
Format source = déjà RogueEssence (.rsground) -> import direct + fixes.

Méthode :
- AssetName/Name renommés FR (mapping ci-dessous), fichier -> Data/Ground/<fr_id>.rsground
- format canonique ($values orphelins, Layers[0].Front, rand.s) corrigé à la volée
- musiques : refs "NNN - Titre.ogg" normalisées vers nos fichiers quand ils existent,
  sinon la musique est copiée sous son nom normalisé
- tilesets référencés copiés tels quels (noms non visibles joueur)
- init.lua squelette par ground + entrée de traçabilité
"""
import json, io, os, re, glob, shutil

SL = '/tmp/sloth'
REPO = '.'

# ---------------------------------------------------------------------------
# MAPPING : ground source -> (fr_id, Nom EN, Nom FR, assignation)
# ---------------------------------------------------------------------------
M = {
 # --- arènes de boss légendaires (cinématiques d'Ancrage) ---
 'groudon_boss_arena':      ('arene_trone_magma', 'Molten Throne Arena', 'Arène du Trône de Magma', 'ch11 Groudon — cinématique Caldeira Endormie'),
 'groudon_statue':          ('statue_colosse_magma', 'Magma Colossus Statue', 'Statue du Colosse de Magma', 'ch11 Groudon — antichambre'),
 'dark_crater_entrance':    ('porte_cratere_obscur', 'Dark Crater Gate', 'Porte du Cratère Obscur', 'ch11 Groudon — entrée alt.'),
 'darkrai_boss_arena':      ('arene_cauchemar', 'Nightmare Arena', 'Arène du Cauchemar', 'ch23 Darkrai — cinématique Cour du Clair de Lune'),
 'deep_aegis_cave_regigigas_boss_arena': ('sanctuaire_titans_parvis', 'Titans Sanctum Hall', 'Parvis du Sanctuaire des Titans', 'ch7 Regigigas — ground de cinématique (complète sanctuaire_titans.rsmap)'),
 'aegis_cave_entrance':     ('sanctuaire_titans_entree', 'Titans Sanctum Gate', 'Entrée du Sanctuaire des Titans', 'ch7 Regigigas — entrée'),
 'far_amp_plains_boss_arena': ('arene_hautes_plaines', 'High Plains Arena', 'Arène des Hautes Plaines', 'ch16 Raikou — cinématique Crête Voilée'),
 'amp_plains_entrance':     ('porte_plaines_foudre', 'Thunderplains Gate', 'Porte des Plaines de Foudre', 'ch17 Électhor — entrée Mont Grondant'),
 'dusknoir_boss_arena':     ('arene_emissaire_ombre', 'Shadow Emissary Arena', "Arène de l'Émissaire de l'Ombre", 'RÉSERVE arc Cercle du Suaire (Accusation ch14-15)'),
 'mystifying_forest_guild_boss_arena': ('arene_clairiere_secrete', 'Secret Glade Arena', 'Arène de la Clairière Secrète', 'ch26 Mew — cinématique Bois Enchevêtrés'),
 # --- trio des lacs : PARFAIT pour ch13 ---
 'crystal_lake_1':          ('lac_savoir', 'Lake of Wisdom', 'Lac du Savoir', 'ch13 Créhelf — cinématique Sentier du Savoir'),
 'crystal_lake_2':          ('lac_espoir', 'Lake of Hope', "Lac de l'Espoir", 'ch13 Créfollet — cinématique Sentier de l\'Espoir'),
 'crystal_lake_3':          ('lac_courage', 'Lake of Bravery', 'Lac du Courage', 'ch13 Créfadet — cinématique Sentier du Courage'),
 # --- Dialga / temporel : ch28 ---
 'temporal_tower_entrance': ('tour_reliques_porte', 'Relic Tower Gate', 'Porte de la Tour des Reliques', 'ch28 Dialga — entrée Tour des Reliques'),
 'temporal_spire_red_sky':  ('fleche_reliques_courroux', 'Relic Spire (Wrath)', 'Flèche des Reliques — Courroux', 'ch28 Dialga — cinématique pré-boss'),
 'temporal_spire_crumbling_normal_sky': ('fleche_reliques_ruine', 'Relic Spire (Ruin)', 'Flèche des Reliques — Ruine', 'ch28 Dialga — variante effondrement'),
 'temporal_spire_restored': ('fleche_reliques_apaisee', 'Relic Spire (Calm)', 'Flèche des Reliques — Apaisée', 'ch28 Dialga — post-victoire'),
 # --- Volcanion / vapeur : ch23 ---
 'steam_cave_entrance':     ('forge_vapeur_porte', 'Steam Forge Gate', 'Porte de la Forge de Vapeur', 'ch23 Volcanion — entrée'),
 'upper_steam_cave_entrance': ('forge_vapeur_haut', 'Upper Steam Forge', 'Haut de la Forge de Vapeur', 'ch23 Volcanion — accès sommet (tileset source absent, décor à refaire)'),
 # --- Keldeo / brine : ch18 ---
 'brine_cave_entrance':     ('gue_poulain_porte', 'Colt Ford Gate', 'Porte du Gué du Poulain', 'ch18 Keldeo — entrée'),
 'brine_cave_pit':          ('gue_poulain_fosse', 'Colt Ford Pit', 'Fosse du Gué du Poulain', 'ch18 Keldeo — mi-parcours'),
 'brine_cave_boss':         ('gue_poulain_autel', 'Colt Ford Altar', 'Autel du Gué du Poulain', 'ch18 Keldeo — cinématique pré-boss'),
 # --- Celebi : ch20 ---
 'apple_woods_entrance':    ('bois_antan_oree', 'Yesteryear Edge', "Orée du Bois d'Antan", 'ch20 Celebi — entrée'),
 'apple_woods_end':         ('bois_antan_verger', 'Yesteryear Orchard', "Verger du Bois d'Antan", 'ch20 Celebi — cinématique'),
 # --- Mew / jungle : ch26 ---
 'mystifying_forest_entrance': ('bois_enchevetres_oree', 'Tangled Edge', 'Orée des Bois Enchevêtrés', 'ch26 Mew — entrée'),
 'mystifying_forest_pit':   ('bois_enchevetres_fosse', 'Tangled Pit', 'Fosse des Bois Enchevêtrés', 'ch26 Mew — mi-parcours'),
 # --- Marshadow / ombre : ch26 ---
 'sealed_ruin_entrance':    ('creux_ombres_porte', 'Shadow Hollow Gate', 'Porte du Creux des Ombres', 'ch26 Marshadow — entrée'),
 'sealed_ruin_pit':         ('creux_ombres_scelle', 'Sealed Shadow Pit', 'Fosse Scellée des Ombres', 'ch26 Marshadow — cinématique'),
 'dusk_forest_entrance':    ('oree_crepuscule', 'Dusk Edge', 'Orée du Crépuscule', 'ch32 Necrozma — entrée Sentier Éteint'),
 'deep_dusk_forest_entrance': ('coeur_crepuscule', 'Dusk Heart', 'Cœur du Crépuscule', 'ch32 Necrozma — mi-parcours'),
 'dark_hill_entrance':      ('colline_sans_lumiere', 'Lightless Hill', 'Colline Sans Lumière', 'ch32 Necrozma — approche'),
 # --- fin de partie / Eternatus-Zygarde-Arceus ---
 'legendary_hallway':       ('couloir_legendes', 'Hall of Legends', 'Couloir des Légendes', 'ch32 Eternatus — antichambre Nervure du Monde'),
 'hidden_land_entrance':    ('terres_tues_porte', 'Silent Lands Gate', 'Porte des Terres Tues', 'ch30 Zygarde — entrée Ciel Suspendu'),
 'old_ruins_stairs':        ('escalier_origine', 'Origin Stairs', "Escalier de l'Origine", 'ch32 Arceus — approche Tour de l\'Origine'),
 'rainbow_stoneship_east':  ('nef_prisme_est', 'Prism Ark East', 'Nef du Prisme — Est', 'ch30 Xerneas — cinématique Îles Prismatiques'),
 'rainbow_stoneship_on_ground': ('nef_prisme_sol', 'Prism Ark Grounded', 'Nef du Prisme — Échouée', 'ch30 Xerneas — cinématique 2'),
 # --- cristal : ch8 Diancie / ch20 Meloetta ---
 'crystal_cave_entrance':   ('sanctuaire_cristal_porche', 'Crystal Porch', 'Porche du Sanctuaire de Cristal', 'ch8 Diancie — entrée alt.'),
 'crystal_cave_4':          ('galerie_cristal_4', 'Crystal Gallery IV', 'Galerie de Cristal IV', 'ch8 Diancie — salle interne'),
 'crystal_cave_5':          ('galerie_cristal_5', 'Crystal Gallery V', 'Galerie de Cristal V', 'ch8 Diancie — salle interne 2'),
 'crystal_cave_puzzle_unsolved': ('enigme_cristal', 'Crystal Riddle', 'Énigme de Cristal', 'ch8 Diancie — salle-énigme (event optionnel)'),
 'crystal_crossing_entrance': ('croisee_cristal_porte', 'Crystal Crossing Gate', 'Porte de la Croisée de Cristal', 'ch20 Meloetta — entrée Amphithéâtre'),
 # --- montagnes / oiseaux / Zeraora ---
 'mt_travail_entrance':     ('piste_fulgurante_pied', 'Fulgurant Foothill', 'Pied de la Piste Fulgurante', 'ch25 Zeraora — entrée'),
 'mt_travail_peak':         ('piste_fulgurante_cime', 'Fulgurant Peak', 'Cime de la Piste Fulgurante', 'ch25 Zeraora — cinématique'),
 'mt_horn_entrance':        ('corne_pierre_pied', 'Stonehorn Foothill', 'Pied de la Corne de Pierre', 'RÉSERVE entrée montagne (secondaires ch11+)'),
 'mt_bristle_entrance':     ('pic_herisse_pied', 'Bristlepeak Foothill', 'Pied du Pic Hérissé', 'RÉSERVE entrée montagne'),
 'mt_bristle_peak':         ('pic_herisse_cime', 'Bristlepeak Summit', 'Cime du Pic Hérissé', 'RÉSERVE arène mini-boss'),
 # --- déserts / divers donjons ---
 'quicksand_cave_entrance': ('antre_sables_porte', 'Sinksand Gate', 'Porte de l\'Antre des Sables', 'RÉSERVE donjon désert (Furnace_Desert FA)'),
 'quicksand_cave_exterior': ('antre_sables_dehors', 'Sinksand Outside', 'Abords de l\'Antre des Sables', 'RÉSERVE donjon désert'),
 'northern_desert_entrance': ('desert_boreal_porte', 'Boreal Desert Gate', 'Porte du Désert Boréal', 'RÉSERVE donjon désert 2'),
 'chasm_cave_entrance':     ('gouffre_beant_porte', 'Yawning Chasm Gate', 'Porte du Gouffre Béant', 'RÉSERVE'),
 'foggy_forest_entrance':   ('foret_brumes_oree', 'Mistwood Edge', 'Orée de la Forêt des Brumes', 'RÉSERVE (arc Accusation — brume/clandestinité)'),
 'waterfall_cave_entrance': ('antre_cascade_porte', 'Cascade Den Gate', "Porte de l'Antre de la Cascade", 'RÉSERVE ch7 secondaire (plan EoSO)'),
 'waterfall_cave_outside':  ('antre_cascade_dehors', 'Cascade Den Outside', "Abords de l'Antre de la Cascade", 'RÉSERVE'),
 'drenched_bluff_entrance': ('falaise_trempee_porte', 'Soaked Bluff Gate', 'Porte de la Falaise Trempée', 'RÉSERVE côte'),
 'drenched_bluff_end':      ('falaise_trempee_fond', 'Soaked Bluff End', 'Fond de la Falaise Trempée', 'RÉSERVE côte'),
 'beach_cave_pit':          ('grotte_plage_fond', 'Beach Cave Pit', 'Fond de la Grotte de la Plage', 'RÉSERVE côte'),
 # --- lieux de vie / cinématiques générales ---
 'beach':                   ('plage_lucioles', 'Firefly Beach', 'Plage des Lucioles', 'RÉSERVE cinématique majeure (écho On the Beach at Dusk)'),
 'dusk_beach':              ('plage_crepuscule', 'Dusk Beach', 'Plage du Crépuscule', 'RÉSERVE cinématique'),
 'hot_spring':              ('source_chaude', 'Hot Spring', 'Source Chaude', 'RÉSERVE lieu de détente (post-ch10)'),
 'habitat_sharpedo_bluff_day': ('cap_dents_mer', 'Seafang Cape', 'Cap des Dents de Mer', 'RÉSERVE repaire côtier'),
 'treasure_town':           ('bourg_comptoir', 'Trading Burg', 'Bourg du Comptoir', 'RÉSERVE ville 2 (expansion ch11+)'),
 'spinda_cafe':             ('cafe_toupie', 'Spinning Café', 'Café de la Toupie', 'RÉSERVE annexe café Metano'),
 'crossroads':              ('carrefour_nord', 'North Crossroads', 'Carrefour Nord', 'RÉSERVE carrefour monde'),
 'crossroads_south':        ('carrefour_sud', 'South Crossroads', 'Carrefour Sud', 'RÉSERVE'),
 'crossroads_assembly':     ('carrefour_assemblee', 'Assembly Crossroads', "Carrefour de l'Assemblée", 'RÉSERVE'),
 'marowak_dojo':            ('dojo_ossatueur', 'Bonekeeper Dojo', "Dojo de l'Ossatueur", 'RÉSERVE extension dojo Ledian'),
 'marowak_dojo_final_maze': ('dojo_ossatueur_final', 'Bonekeeper Final Maze', "Dédale Final de l'Ossatueur", 'RÉSERVE maze final dojo'),
 'guild_basement':          ('guilde_sous_sol', 'Guild Basement', 'Sous-sol de la Guilde', 'RÉSERVE extension guilde Metano'),
 'guild_basement_night':    ('guilde_sous_sol_nuit', 'Guild Basement (Night)', 'Sous-sol de la Guilde — Nuit', 'RÉSERVE'),
 'guild_outside':           ('guilde_parvis', 'Guild Forecourt', 'Parvis de la Guilde', 'RÉSERVE'),
 'guild_outside_dusk':      ('guilde_parvis_soir', 'Guild Forecourt (Dusk)', 'Parvis de la Guilde — Soir', 'RÉSERVE'),
 'guild_outside_night':     ('guilde_parvis_nuit', 'Guild Forecourt (Night)', 'Parvis de la Guilde — Nuit', 'RÉSERVE'),
 'personality_test':        ('rite_ame', 'Soul Rite', "Rite de l'Âme", 'RÉSERVE variante intro'),
 'intro_cutscene':          ('vision_ouverture', 'Opening Vision', "Vision d'Ouverture", 'RÉSERVE cinématique intro alt.'),
 'storm_cutscene_a':        ('tempete_vision_a', 'Storm Vision A', 'Vision de Tempête A', 'ch12 Kyogre — cinématique tempête'),
 'storm_cutscene_b':        ('tempete_vision_b', 'Storm Vision B', 'Vision de Tempête B', 'ch12 Kyogre — cinématique 2'),
 'storm_cutscene_c':        ('tempete_vision_c', 'Storm Vision C', 'Vision de Tempête C', 'ch12 Kyogre — cinématique 3'),
 'chapter_card':            ('carte_chapitre_v2', 'Chapter Card II', 'Carte de Chapitre II', 'RÉSERVE outil narratif (cartes de chapitre Livre II)'),
 'title_catch':             ('ecran_titre_v2', 'Title Screen II', 'Écran Titre II', 'RÉSERVE'),
}


def normalize_music(name):
    m = re.match(r'^\d{3} - (.+)$', name)
    return m.group(1) if m else name


def fix_orphans(x):
    if isinstance(x, dict):
        for k, v in list(x.items()):
            if isinstance(v, dict) and '$values' in v and '$type' not in v:
                x[k] = v['$values']
                fix_orphans(x[k])
            else:
                fix_orphans(v)
    elif isinstance(x, list):
        for it in x:
            fix_orphans(it)


RAND_OK = {"$type": "RogueElements.ReRandom, RogueElements", "FirstSeed": 0,
           "s": [16294208416658607535, 7960286522194355700,
                 4876170194715417726, 12554865158188930543]}

if __name__ == '__main__':
    have_music = set(os.listdir('Content/Music'))
    have_tiles = set(os.listdir('Content/Tile'))
    copied_mus, copied_tiles, done = 0, 0, []
    for src, (fid, nen, nfr, assign) in M.items():
        p = f'{SL}/Data/Ground/'
        # nom de fichier reel (casse variable)
        cand = [f for f in os.listdir(p) if f.lower() == (src + '.rsground').lower()]
        if not cand:
            print('!! introuvable:', src)
            continue
        d = json.load(open(p + cand[0], encoding='utf-8-sig'))
        o = d['Object']
        o['AssetName'] = fid
        o['Name'] = {'DefaultText': nen, 'LocalTexts': {'fr': nfr}}
        o['Comment'] = (f'New Era — {nfr}. Imported from a converted Explorers ground set '
                        f'(RogueEssence format). Assignment: {assign}.')
        fix_orphans(o)
        L = o.get('Layers', [])
        for lay in L:
            if 'Front' in lay and 'Layer' not in lay:
                lay['Layer'] = 0
                del lay['Front']
        if o.get('rand', {}).get('s') == [0, 0, 0, 0]:
            o['rand'] = dict(RAND_OK)
        # musique : normaliser
        mus = o.get('Music', '')
        if mus:
            nm = normalize_music(mus)
            if nm in have_music:
                o['Music'] = nm
            elif mus in have_music:
                pass
            else:
                # copier depuis sloth sous le nom normalise
                srcm = f'{SL}/Content/Music/{mus}'
                if os.path.exists(srcm):
                    shutil.copy(srcm, f'Content/Music/{nm}')
                    have_music.add(nm)
                    copied_mus += 1
                    o['Music'] = nm
                else:
                    o['Music'] = ''
        # tilesets requis
        raw = json.dumps(o)
        for sheet in set(re.findall(r'"Sheet":\s*"([^"]+)"', raw)) - {''}:
            tf = sheet + '.tile'
            if tf not in have_tiles:
                srct = f'{SL}/Content/Tile/{tf}'
                if os.path.exists(srct):
                    shutil.copy(srct, f'Content/Tile/{tf}')
                    have_tiles.add(tf)
                    copied_tiles += 1
        with io.open(f'Data/Ground/{fid}.rsground', 'w', encoding='utf-8-sig') as f:
            json.dump(d, f, ensure_ascii=False, indent=1)
        done.append((src, fid, nfr, assign))
    print(f'{len(done)} grounds importés, {copied_tiles} tilesets copiés, {copied_mus} musiques copiées')
    json.dump(done, open('/tmp/wave4_done.json', 'w'))
