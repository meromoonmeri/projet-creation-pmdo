#!/usr/bin/env python3
"""Vague 6 — Import 1:1 des 57 Friend Areas pmd-red comme ARÈNES DE BOSS.

Directive : les Friend Areas servent de zones de combat/cinématique pour les
légendaires ABSENTS de PMD Rescue Team de base (gén. 4-9 : Dialga, Palkia,
Giratina, Cresselia, Darkrai, Shaymin, Manaphy, trio lacs, Yveltal, Xerneas,
Zygarde, Solgaleo, Lunala, Necrozma, Eternatus, Arceus, Marshadow, etc.).

Pipeline identique aux lots pmd-red (pmdred_lib) : rendu identity-mapped,
collision d'origine, .tile + .rsground canoniques. Renommage FR, marqueurs
standard (Main_Entrance_Marker + Boss_Marker au centre + TEAMMATE_1..3).
"""
import io, json, os, re, struct, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__))))
from pmdred_lib import render, get_collision
from convert_pmdred_batch import write_tile_file, mk_marker, mk_spawner, make_rsground, flood_stats

BASE = '/tmp/pmd-red/data/map_bg'

# src H## -> (asset, EN, FR, musique, assignation boss)
FA = {
 'H01P01': ('recif_genereux','Bountiful Reef','Récif Généreux','Water Cave.ogg','arène Manaphy/Phione ch16 (Berceau des Mers)'),
 'H01P02': ('mer_tresors','Treasure Sea','Mer aux Trésors','Water Cave.ogg','réserve arène marine'),
 'H01P03': ('mer_sereine','Serene Sea','Mer Sereine','On the Beach at Dusk.ogg','réserve cinématique marine'),
 'H02P01': ('plancher_abysses','Abyssal Floor','Plancher des Abysses','Water Cave.ogg','arène Kyogre ch12 (alt. cinématique)'),
 'H02P02': ('courant_profond','Deep Current','Courant Profond','Water Cave.ogg','réserve marine'),
 'H02P03': ('grotte_benthique','Benthic Cave','Grotte Benthique','Lower Spring Cave.ogg','réserve marine'),
 'H03P01': ('greve_claire','Clearwater Shore','Grève Claire','On the Beach at Dusk.ogg','réserve cinématique plage'),
 'H04P01': ('mont_vertprofond','Deepgreen Mount','Mont Vert-Profond','Mt. Travail.ogg','réserve montagne'),
 'H04P02': ('mont_crevasse','Cleft Mount','Mont de la Crevasse','Mt. Travail.ogg','réserve montagne'),
 'H05P01': ('mont_lune_vue','Moonview Mount','Mont Vue-de-Lune','Sky Peak Cave.ogg','arène Cresselia ch23 (Cour du Clair de Lune)'),
 'H05P02': ('pic_arc_en_ciel','Rainbow Summit','Pic Arc-en-Ciel','Rainbow Peak.ogg','arène Ho-Oh ch18 (alt.) — écho visuel arène Lugia ch10'),
 'H06P01': ('plaines_sauvages','Wild Plains','Plaines Sauvages','Sky Peak Prairie.ogg','réserve plaine'),
 'H06P02': ('belles_plaines','Beau Plains','Belles Plaines','Sky Peak Prairie.ogg','réserve plaine'),
 'H06P03': ('plaines_azur','Sky Blue Plains','Plaines d\'Azur','Sky Peak Prairie.ogg','réserve plaine'),
 'H06P04': ('reserve_safari','Safari Reach','Réserve Safari','Sky Peak Prairie.ogg','réserve'),
 'H06P05': ('plaines_brulees','Scorched Plains','Plaines Brûlées','Deep Dark Crater.ogg','arène Entei ch22 (alt. cinématique)'),
 'H06P06': ('champ_sacre','Sacred Field','Champ Sacré','Luminous Spring.ogg','arène Shaymin ch15 (Jardin de la Gratitude)'),
 'H07P01': ('foret_brumeleve','Mistrise Forest','Forêt de Brume-Levée','Mystifying Forest.ogg','réserve forêt'),
 'H07P02': ('foret_envolee','Flyaway Forest','Forêt de l\'Envolée','Treeshroud Forest.ogg','réserve forêt'),
 'H07P03': ('foret_envahie','Overgrown Grove','Forêt Envahie','Treeshroud Forest.ogg','arène Zarude (revanche alt.)'),
 'H07P04': ('foret_vibrante','Energetic Forest','Forêt Vibrante','Treeshroud Forest.ogg','réserve forêt'),
 'H07P05': ('foret_champignons','Mushroom Forest','Forêt aux Champignons','Mystifying Forest.ogg','réserve forêt'),
 'H07P06': ('foret_guerison','Healing Forest','Forêt de Guérison','Healing Forest.ogg','arène Celebi ch20 (Bois d\'Antan)'),
 'H07P07': ('foret_mue','Transform Forest','Forêt de la Mue','Mystifying Forest.ogg','arène Mew ch26 (alt. Ditto lore)'),
 'H07P08': ('foret_secrete','Secretive Forest','Forêt Secrète','Mystifying Forest.ogg','arène Marshadow ch26 (Creux des Ombres)'),
 'H08P01': ('riviere_lavoir','Rub-a-Dub River','Rivière du Lavoir','Water Cave.ogg','réserve rivière'),
 'H09P01': ('mare_tetards','Tadpole Pond','Mare aux Têtards','Spring Cave.ogg','réserve'),
 'H09P02': ('etang_carapace','Turtleshell Pond','Étang Carapace','Spring Cave.ogg','réserve'),
 'H10P01': ('lac_mystique','Mystic Lake','Lac Mystique','Star Cave.ogg','arène trio des lacs ch13 (Créhelf/Créfollet/Créfadet)'),
 'H10P02': ('lac_cascade','Waterfall Lake','Lac de la Cascade','Spring Cave.ogg','arène Keldeo ch18 (alt.)'),
 'H11P01': ('marecage_cacahuete','Peanut Swamp','Marécage Brun','Friend Area Swamp.ogg','réserve marais (déjà FA_Peanut tileset)'),
 'H12P01': ('marais_poison','Poison Swamp','Marais Poison','Friend Area Swamp.ogg','réserve marais toxique'),
 'H13P01': ('grotte_echos','Echo Cave','Grotte des Échos','Friend Area Cave.ogg','arène Meloetta ch20 (alt. acoustique)'),
 'H13P02': ('grotte_cryptique','Cryptic Cave','Grotte Cryptique','Mysterious Passage.ogg','arène Giratina ch29 (Labyrinthe des Perdus)'),
 'H13P03': ('antre_dragon','Dragon Den','Antre du Dragon','Mt. Travail.ogg','arène Zygarde ch30 (Ciel Suspendu) / dragons'),
 'H13P04': ('grotte_rocheuse','Boulder Cave','Grotte Rocheuse','Boulder Quarry.ogg','réserve grotte'),
 'H14P01': ('jungle_luxuriante','Lush Jungle','Jungle Luxuriante','Gourmet Jungle.ogg','arène Hoopa ch26 (Cache du Porteur d\'Anneaux)'),
 'H15P01': ('labo_decrepit','Decrepit Lab','Laboratoire Décrépit','Growing Anxiety.ogg','arène Genesect ch22 (Réacteur Enfoui) + Mewtwo lore'),
 'H16P01': ('mont_discipline','Mount Discipline','Mont de la Discipline','Marowak Dojo.ogg','arène Keldeo/Kubfu (dojo) — réserve'),
 'H17P01': ('pre_tonnerre','Thunder Meadow','Pré du Tonnerre','Rising Fear.ogg','arène Zeraora ch25 (Piste Fulgurante)'),
 'H18P01': ('centrale_energie','Power Plant','Centrale d\'Énergie','Rising Fear.ogg','arène Regieleki (futur) / Genesect alt.'),
 'H19P01': ('cratere_fumant','Smoking Crater','Cratère Fumant','Deep Dark Crater.ogg','arène Heatran (réservé fiches_boss — SON arène attitrée)'),
 'H20P01': ('desert_fournaise','Furnace Desert','Désert de la Fournaise','Forsaken Desert.ogg','réserve désert (tileset FA déjà là)'),
 'H21P01': ('chambre_agee_an','Aged Chamber AN','Chambre des Âges I','Boulder Quarry.ogg','arène Registeel/Unown — réserve reliques'),
 'H21P02': ('chambre_agee_o','Aged Chamber O!','Chambre des Âges II','Boulder Quarry.ogg','réserve reliques'),
 'H22P01': ('relique_ancienne','Ancient Relic','Relique Ancienne','Boulder Quarry.ogg','arène Dialga ch28 (Tour des Reliques) — cinématique'),
 'H23P01': ('crete_tenebres','Darkness Ridge','Crête des Ténèbres','I Saw Something Again....ogg','arène Darkrai ch23 (Cour du Clair de Lune)'),
 'H24P01': ('caverne_frigide','Frigid Cavern','Caverne Frigide','Snow Camp.ogg','arène Glastrier/Calyrex (futur) — réserve glace'),
 'H25P01': ('greve_banquise','Ice Floe Shore','Grève de la Banquise','Snow Camp.ogg','réserve glace'),
 'H26P01': ('fosse_volcanique','Volcanic Pit','Fosse Volcanique','In the Depths of the Pit.ogg','arène Volcanion ch23 (Forge de Vapeur)'),
 'H27P01': ('vigie_stratos','Stratos Lookout','Vigie du Stratos','Sky Tower.ogg','arène Rayquaza ch27 (alt.) / Escouade Fulgur ch10'),
 'H28P01': ('champ_ravage','Ravaged Field','Champ Ravagé','Growing Anxiety.ogg','arène Yveltal ch29 (Cocon de la Ruine) — cinématique'),
 'H28P02': ('carriere_magnetique','Magnetic Quarry','Carrière Magnétique','Boulder Quarry.ogg','arène Magearna ch24 (alt.) / Melmetal'),
 'H29P01': ('ile_legendaire','Legendary Isle','Île Légendaire','Welcome to the World of Pokémon!.ogg','arène Solgaleo ch31 (Le Conte Sans Fin)'),
 'H29P02': ('ile_australe','Southern Isle','Île Australe','On the Beach at Dusk.ogg','arène Lunala ch31 (Chapelle de la Nuit) — cinématique'),
 'H29P03': ('ile_close','Enclosed Isle','Île Close','Growing Anxiety.ogg','arène Necrozma ch32 (Sentier Éteint) — cinématique'),
 'H29P04': ('ile_finale','Final Isle','Île Finale','In the Depths of the Pit.ogg','arène Eternatus/Arceus ch32 — cinématique finale'),
}

if __name__ == '__main__':
    raise SystemExit('INTERDIT: les Friend Areas sont des zones d accueil vendues par Grodoudou, jamais des arenes de boss. Utiliser le pipeline FriendAreas.')

if False:  # ancien générateur conservé uniquement comme trace de conversion
    import re as _re
    t = open('/tmp/pmd-red/src/map_files_table.c').read()
    fa_files = dict((n[12:], (bpl, bma)) for n, bpl, bpc, bma in _re.findall(
        r'\[MAP_FILE_ID_(FRIEND_AREA_\w+)\]\s*=\s*\{\s*\.bplFileName = "(\w+)",\s*\.bpcFileName = "(\w+)",\s*\.bmaFileName = "(\w+)"', t))
    name_by_file = {}
    for fan, (bpl, bma) in fa_files.items():
        name_by_file[bpl] = (fan, bma)
    results = []
    from PIL import Image
    for src, (asset, nen, nfr, music, assign) in FA.items():
        fan, bma = name_by_file[src]
        img, W, H = render(src, None)
        bg = Image.new('RGBA', img.size, (0, 0, 0, 255))
        bg.alpha_composite(img)
        img = bg
        coll, cw, ch = get_collision(f'{BASE}/{bma}.bma')
        assert (cw, ch) == (W, H), src
        sheet = ''.join(p.capitalize() for p in asset.split('_')) + '_Base'
        n_ent, n_uniq = write_tile_file(img, f'Content/Tile/{sheet}.tile')
        # positions standard : centre des walkables = Boss_Marker ; entrée = bas
        walk = [(x, y) for x in range(W) for y in range(H) if not coll[y*W + x]]
        cx = sum(p[0] for p in walk)//len(walk)
        cy = sum(p[1] for p in walk)//len(walk)
        # entrée : walkable le plus bas proche du centre-x
        entry = max((p for p in walk), key=lambda p: (p[1], -abs(p[0]-cx)))
        T = 8
        markers = [mk_marker('Main_Entrance_Marker', entry[0]*T, entry[1]*T, 0),
                   mk_marker('Boss_Marker', cx*T, cy*T, 4)]
        spawners = [mk_spawner('TEAMMATE_1', max(0,(entry[0]-2))*T, entry[1]*T),
                    mk_spawner('TEAMMATE_2', min(W-1,(entry[0]+2))*T, entry[1]*T),
                    mk_spawner('TEAMMATE_3', entry[0]*T, min(H-1,(entry[1]+1))*T)]
        comment = (f'New Era — {nfr}. Friend Area imported 1:1 from pret/pmd-red '
                   f'({src}, {fan}). Geometry and collision preserved; boss arena '
                   f'ground. Assignment: {assign}.')
        make_rsground(asset, nen, nfr, comment, music, sheet, W, H, coll,
                      markers, spawners, f'Data/Ground/{asset}.rsground')
        reach, walk_n, on_walk = flood_stats(coll, W, H, entry[0], entry[1])
        results.append((src, asset, nfr, W, H, reach, walk_n, assign))
        print(f'{src} -> {asset:24s} {W}x{H} flood={reach}/{walk_n}')
    json.dump(results, open('/tmp/wave6_fa.json', 'w'))
    print(f'\n{len(results)} Friend Areas converties')
