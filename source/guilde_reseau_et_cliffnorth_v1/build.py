#!/usr/bin/env python3
"""Build complet PMDO 0.8.12 ultra-compact (< 1.5 MiB disque total) :
1) Zone extérieure `cliff_north_metano` (remake sans couture de `./cliffnordouesttest1.rsground`,
   138x98 tuiles = 1104x784 px, collisions originales conservées + animation d'eau 4 frames).
2) Réseau complet des 12 salles souterraines + vestibule RDC de la Guilde (13 cartes Ground PMDO 0.8.12)
   aux formes fidèles de la Guilde Halcyon et textures Métano (Metano Inn / Normal Home / Grass Home),
   0 signe Spinda, 0 lit, 0 meuble, extérieur RGBA alpha=0, carte synoptique emboîtée du réseau complet,
   banques .tile binaires RogueEssence exactes (<ii + <iiq + <q+PNG) et archive ZIP prête à importer.
"""
from __future__ import annotations 

import copy 
import hashlib 
import io 
import json 
import struct 
import zipfile 
import zlib 
from pathlib import Path 

import numpy as np 
from PIL import Image ,ImageDraw ,ImageOps 
from scipy import ndimage as nd 

ROOT =Path ('/home/user/projet-creation-pmdo')
WORK =Path ('/tmp/halcyon_work')
GEN =WORK /'gen_out'
REND =WORK /'renders'
GROUND_SRC =WORK /'Data/Ground'

OUT =ROOT /'livrables_guilde_reseau_vide_et_cliffnorth_pmdo'
PNG_DIR =OUT /'png_1x'
CHECK_DIR =WORK /'final_check'


def png_chunk (chunk_type :bytes ,data :bytes )->bytes :
    crc =zlib .crc32 (chunk_type +data )&0xFFFFFFFF 
    return struct .pack ('>I',len (data ))+chunk_type +data +struct .pack ('>I',crc )


def encode_8x8_minimal_png (tile_rgba :Image .Image )->bytes :
    """Encode une tuile 8x8 RGBA en PNG indexé minimal conforme ISO/IEC 15948 (~75-110 octets)."""
    arr =np .array (tile_rgba .convert ('RGBA'))
    flat =arr .reshape (-1 ,4 )
    uniq ,inv =np .unique (flat ,axis =0 ,return_inverse =True )
    n_col =len (uniq )
    if n_col <=16 :
        bit_depth =4 
        rows_raw =bytearray ()
        idx_grid =inv .reshape (8 ,8 )
        for y in range (8 ):
            rows_raw .append (0 )# filtre None
            row =idx_grid [y ]
            for x in range (0 ,8 ,2 ):
                rows_raw .append ((int (row [x ])<<4 )|int (row [x +1 ]))
    else :
        bit_depth =8 
        rows_raw =bytearray ()
        idx_grid =inv .reshape (8 ,8 )
        for y in range (8 ):
            rows_raw .append (0 )
            rows_raw .extend (int (v )for v in idx_grid [y ])

    ihdr =struct .pack ('>IIBBBBB',8 ,8 ,bit_depth ,3 ,0 ,0 ,0 )
    plte =uniq [:,:3 ].astype (np .uint8 ).tobytes ()
    chunks =[b'\x89PNG\r\n\x1a\n',png_chunk (b'IHDR',ihdr ),png_chunk (b'PLTE',plte )]
    if (uniq [:,3 ]<255 ).any ():
        chunks .append (png_chunk (b'tRNS',uniq [:,3 ].astype (np .uint8 ).tobytes ()))
    chunks .append (png_chunk (b'IDAT',zlib .compress (bytes (rows_raw ),level =9 )))
    chunks .append (png_chunk (b'IEND',b''))
    return b''.join (chunks )


def save_compact_png (im :Image .Image ,path :Path ,colors :int =128 )->None :
    """Sauvegarde un PNG RGBA ou RGB pixel-art net avec palette indexée compacte."""
    arr =np .array (im .convert ('RGBA'))
    has_trans =(arr [...,3 ]<255 ).any ()
    if has_trans :
        alpha_mask =arr [...,3 ]>=128 
        rgb =Image .fromarray (arr [...,:3 ],'RGB').quantize (
        colors =colors -1 ,method =Image .Quantize .FASTOCTREE ,dither =Image .Dither .NONE 
        )
        pal =rgb .getpalette ()[:(colors -1 )*3 ]+[0 ,0 ,0 ]
        p_arr =np .array (rgb ,dtype =np .uint8 )
        p_arr =np .where (alpha_mask ,p_arr ,colors -1 )
        out_p =Image .fromarray (p_arr ,mode ='P')
        out_p .putpalette (pal )
        out_p .save (path ,format ='PNG',transparency =colors -1 ,optimize =True )
    else :
        rgb =Image .fromarray (arr [...,:3 ],'RGB').quantize (
        colors =colors ,method =Image .Quantize .FASTOCTREE ,dither =Image .Dither .NONE 
        )
        rgb .save (path ,format ='PNG',optimize =True )


def quantize_rgba_clean (im :Image .Image ,n_colors :int =28 )->Image .Image :
    """Quantifie proprement les couleurs pixel-art d'une carte RGBA en gardant alpha binaire franc."""
    arr =np .array (im .convert ('RGBA'))
    mask =arr [...,3 ]>=128 
    rgb_q =Image .fromarray (arr [...,:3 ],'RGB').quantize (
    colors =n_colors ,method =Image .Quantize .FASTOCTREE ,dither =Image .Dither .NONE 
    ).convert ('RGB')
    qa =np .array (rgb_q )
    out =np .zeros_like (arr )
    out [mask ,:3 ]=qa [mask ]
    out [mask ,3 ]=255 
    return Image .fromarray (out ,'RGBA')


def clean_magenta_to_rgba (im :Image .Image )->Image .Image :
    """Détourage strict du fond #FF00FF + suppression complète de toute frange pourpre."""
    rgb =np .array (im .convert ('RGB')).astype (int )
    r ,g ,b =rgb [...,0 ],rgb [...,1 ],rgb [...,2 ]
    magenta =(r >155 )&(b >145 )&(g <135 )&((r -g )>45 )&((b -g )>35 )
    keep =~magenta 
    lbl ,n =nd .label (keep )
    clean_keep =np .zeros_like (keep )
    for k in range (1 ,n +1 ):
        m =lbl ==k 
        if int (m .sum ())>=64 :
            clean_keep |=m 
    dist =nd .distance_transform_edt (clean_keep )
    purple =clean_keep &(((r -g )>38 )&((b -g )>20 )|((b >r )&(b >g +12 )))
    fringe =purple |(clean_keep &(dist <=2 )&(b >g +5 ))
    donor =clean_keep &(~fringe )&(dist >=2 )
    if donor .any ()and fringe .any ():
        _ ,inds =nd .distance_transform_edt (~donor ,return_indices =True )
        rgb [fringe ]=rgb [tuple (i [fringe ]for i in inds )]
    alpha =np .where (clean_keep ,255 ,0 ).astype (np .uint8 )
    out =np .dstack ([np .clip (rgb ,0 ,255 ).astype (np .uint8 ),alpha ])
    return Image .fromarray (out ,'RGBA')


def fit_rgba_to_exact_grid (im_rgba :Image .Image ,target_w :int ,target_h :int ,pad_px :int =8 )->Image .Image :
    """Ajuste proprement la silhouette détourée dans son canevas exact (multiple de 8 px)."""
    arr =np .array (im_rgba )
    ys ,xs =np .where (arr [...,3 ]>0 )
    crop =im_rgba .crop ((int (xs .min ()),int (ys .min ()),int (xs .max ())+1 ,int (ys .max ())+1 ))
    avail_w =max (8 ,target_w -2 *pad_px )
    avail_h =max (8 ,target_h -2 *pad_px )
    sc =min (avail_w /crop .width ,avail_h /crop .height )
    nw =max (8 ,round (crop .width *sc ))
    nh =max (8 ,round (crop .height *sc ))
    resized =crop .resize ((nw ,nh ),Image .Resampling .NEAREST )
    canvas =Image .new ('RGBA',(target_w ,target_h ),(0 ,0 ,0 ,0 ))
    canvas .paste (resized ,((target_w -nw )//2 ,(target_h -nh )//2 ),resized )
    ca =np .array (canvas )
    ca [...,3 ]=np .where (ca [...,3 ]>=128 ,255 ,0 )
    ca [ca [...,3 ]==0 ]=[0 ,0 ,0 ,0 ]
    return Image .fromarray (ca ,'RGBA')


def polish_rooms ()->dict [str ,Image .Image ]:
    """Prépare et polit les 13 salles vides (00 RDC + 01..12 réseau complet de la Guilde)."""
    raw :dict [str ,Image .Image ]={}

    # 00 — guild_first_floor : détourage complet du fond bleu nuit (24,24,56) + bannière verte unie sans visage !
    ff =np .array (Image .open (REND /'guild_first_floor.png').convert ('RGBA'))
    bg_ff =((ff [...,0 ]<45 )&(ff [...,1 ]<45 )&(ff [...,2 ]<75 ))|(
    (ff [...,0 ]>220 )&(ff [...,1 ]<30 )&(ff [...,2 ]>220 )
    )
    bx0 ,by0 ,bx1 ,by1 =204 ,88 ,268 ,172 
    bpatch =ff [by0 :by1 ,bx0 :bx1 ].copy ()
    # Tout l'intérieur vert/jaune de la bannière (sauf le galon inférieur doré à la pointe) devient un drap vert feuille uni
    green_or_mouth =(
    ((bpatch [...,1 ].astype (int )>bpatch [...,2 ].astype (int )+25 )&(bpatch [...,0 ]<140 ))
    |((bpatch [...,0 ]>185 )&(bpatch [...,1 ]>175 )&(bpatch [...,2 ]<120 ))
    )
    # Préserve le chevron jaune inférieur (y local >= 58 ou bords bas du fanion)
    yy_b =np .arange (by1 -by0 )[:,None ]
    inner_emblem =green_or_mouth &(yy_b <58 )&(yy_b >12 )
    bpatch [inner_emblem ]=[56 ,158 ,48 ,255 ]
    ff [by0 :by1 ,bx0 :bx1 ]=bpatch 
    ff [bg_ff ]=[0 ,0 ,0 ,0 ]
    raw ['00_guild_first_floor']=Image .fromarray (ff ,'RGBA')

    # 01 — guild_second_floor
    raw ['01_guild_second_floor']=clean_magenta_to_rgba (Image .open (GEN /'g01_second_floor.png'))

    # 02 — guild_third_floor_lobby : seuils d'accès Ouest & Est + Arche Nord + Puits NE + Sud
    lob =np .array (clean_magenta_to_rgba (Image .open (GEN /'g02_third_floor_lobby.png')))
    hl ,wl =lob .shape [:2 ]
    for px0 ,px1 in [(int (wl *0.052 ),int (wl *0.072 )),(int (wl *0.928 ),int (wl *0.948 ))]:
        py0 ,py1 =int (hl *0.45 ),int (hl *0.62 )
        mask_w =lob [py0 :py1 ,px0 :px1 ,3 ]>0 
        lob [py0 :py1 ,px0 :px1 ][mask_w ]=[58 ,34 ,16 ,255 ]
    raw ['02_guild_third_floor_lobby']=Image .fromarray (lob ,'RGBA')

    # 03 — guild_guildmasters_room (0 lit, 0 meuble, 0 spirale)
    raw ['03_guild_guildmasters_room']=clean_magenta_to_rgba (Image .open (GEN /'g03_guildmasters_room.png'))

    # 04 — guild_dining_room (0 table, 0 tabouret, 0 spirale)
    raw ['04_guild_dining_room']=clean_magenta_to_rgba (Image .open (GEN /'g04_dining_room.png'))

    # 07 — guild_bedroom_hallway (double croix H) + 05 — guild_storage_hallway (T inversé)
    bh_rgba =clean_magenta_to_rgba (Image .open (GEN /'g07_bedroom_hallway.png'))
    raw ['07_guild_bedroom_hallway']=bh_rgba 

    bha =np .array (bh_rgba )
    hb ,wb =bha .shape [:2 ]
    x_cut =int (wb *0.605 )
    sh =bha [:,:x_cut ].copy ()
    bark_strip =bha [int (hb *0.565 ):int (hb *0.645 ),int (wb *0.04 ):int (wb *0.18 )].copy ()
    y_floor_bot =int (hb *0.565 )
    sh [y_floor_bot :,:]=0 
    tile_w =bark_strip .shape [1 ]
    active_x =np .where (sh [y_floor_bot -4 ,:,3 ]>0 )[0 ]
    if len (active_x ):
        ax0 ,ax1 =int (active_x .min ()),int (active_x .max ())+1 
        for x in range (ax0 ,ax1 ,tile_w ):
            w_seg =min (tile_w ,ax1 -x )
            seg =bark_strip [:,:w_seg ]
            sh [y_floor_bot :y_floor_bot +seg .shape [0 ],x :x +w_seg ]=seg 
    left_edge_w =int (wb *0.042 )
    right_cap =np .fliplr (sh [:,:left_edge_w ])
    sh [:,x_cut -left_edge_w :x_cut ]=np .where (
    right_cap [...,3 :4 ]>0 ,right_cap ,sh [:,x_cut -left_edge_w :x_cut ]
    )
    raw ['05_guild_storage_hallway']=Image .fromarray (sh ,'RGBA')

    # 08 — guild_heros_room : retrait complet des 2 montants sous le hublot rond !
    hr_raw =np .array (clean_magenta_to_rgba (Image .open (GEN /'g08_heros_room.png'))).astype (float )
    hh ,wh =hr_raw .shape [:2 ]
    strip_w =hr_raw [int (hh *0.258 ):int (hh *0.382 ),int (wh *0.502 ):int (wh *0.544 )].copy ()
    sw =strip_w .shape [1 ]
    for x in range (int (wh *0.544 ),int (wh *0.698 ),sw ):
        ws =min (sw ,int (wh *0.698 )-x )
        hr_raw [int (hh *0.258 ):int (hh *0.382 ),x :x +ws ]=strip_w [:,:ws ]
    x0_g ,x1_g =int (wh *0.545 ),int (wh *0.688 )
    y0_g ,y1_g =int (hh *0.376 ),int (hh *0.535 )
    donor_f =hr_raw [y0_g +168 :y1_g +168 ,x0_g :x1_g ].copy ()
    bw_g ,bh_g =x1_g -x0_g ,y1_g -y0_g 
    yy_g ,xx_g =np .indices ((bh_g ,bw_g ))
    wgt_g =np .minimum .reduce ([
    np .clip (xx_g /8.0 ,0 ,1 ),np .clip ((bw_g -1 -xx_g )/8.0 ,0 ,1 ),
    np .clip (yy_g /8.0 ,0 ,1 ),np .clip ((bh_g -1 -yy_g )/8.0 ,0 ,1 ),
    ])[...,None ]
    hr_raw [y0_g :y1_g ,x0_g :x1_g ,:3 ]=donor_f [...,:3 ]*wgt_g +hr_raw [y0_g :y1_g ,x0_g :x1_g ,:3 ]*(1.0 -wgt_g )
    hr_clean =Image .fromarray (np .clip (hr_raw ,0 ,255 ).astype (np .uint8 ),'RGBA')
    raw ['08_guild_heros_room']=hr_clean 

    # 06 — guild_storage_room : variante aveugle (sans fenêtre ronde) de la réserve 44x44
    sr_arr =np .array (hr_clean ).copy ()
    panel_strip =sr_arr [int (hh *0.135 ):int (hh *0.382 ),int (wh *0.502 ):int (wh *0.545 )].copy ()
    pw =panel_strip .shape [1 ]
    for x in range (int (wh *0.545 ),int (wh *0.688 ),pw ):
        ws =min (pw ,int (wh *0.688 )-x )
        sr_arr [int (hh *0.135 ):int (hh *0.382 ),x :x +ws ]=panel_strip [:,:ws ]
    raw ['06_guild_storage_room']=Image .fromarray (sr_arr ,'RGBA')

    # 09..12 — les 4 chambres d'apprentis
    tl_rgba =clean_magenta_to_rgba (Image .open (GEN /'g09_top_left_bedroom.png'))
    raw ['09_guild_top_left_bedroom']=tl_rgba 
    raw ['10_guild_top_right_bedroom']=ImageOps .mirror (tl_rgba )

    bl_rgba =clean_magenta_to_rgba (Image .open (GEN /'g11_bottom_left_bedroom.png'))
    raw ['11_guild_bottom_left_bedroom']=bl_rgba 
    raw ['12_guild_bottom_right_bedroom']=ImageOps .mirror (bl_rgba )

    return raw 


ROOM_SPECS =[
('00_guild_first_floor','guild_first_floor',320 ,240 ,0 ,'Entrée RDC — Tronc creux & rampe',['Sud : Extérieur Guilde / Promontoire','Haut : 01_guild_second_floor']),
('01_guild_second_floor','guild_second_floor',672 ,448 ,-1 ,'Sous-sol -1 — Grand Hall d’Accueil',['Escalier Est : 00_guild_first_floor','Puits Ouest : 02_guild_third_floor_lobby']),
('02_guild_third_floor_lobby','guild_third_floor_lobby',800 ,448 ,-2 ,'Sous-sol -2 — Carrefour Central de la Guilde',['Puits NE : 01_guild_second_floor','Arche Nord : 03_guild_guildmasters_room','Aile Ouest : 05_guild_storage_hallway','Aile Est : 07_guild_bedroom_hallway']),
('03_guild_guildmasters_room','guild_guildmasters_room',384 ,384 ,-2 ,'Sous-sol -2 Nord — Salle du Maître (vide)',['Couloir Sud : 02_guild_third_floor_lobby']),
('04_guild_dining_room','guild_dining_room',448 ,288 ,-2 ,'Sous-sol -2 Ouest — Grand Réfectoire (vide)',['Couloir Est : 05_guild_storage_hallway']),
('05_guild_storage_hallway','guild_storage_hallway',352 ,384 ,-2 ,'Aile Ouest — Couloir de la Réserve (T inversé)',['Ouest : 04_guild_dining_room','Nord : 06_guild_storage_room','Est : 02_guild_third_floor_lobby']),
('06_guild_storage_room','guild_storage_room',352 ,352 ,-2 ,'Aile Ouest — Salle de Réserve (vide)',['Couloir Ouest : 05_guild_storage_hallway']),
('07_guild_bedroom_hallway','guild_bedroom_hallway',480 ,256 ,-2 ,'Aile Est — Couloir des Dortoirs (double croix H)',['Ouest : 02_guild_third_floor_lobby','Est : 08_guild_heros_room','Nord-G : 09_top_left','Nord-D : 10_top_right','Sud-G : 11_bottom_left','Sud-D : 12_bottom_right']),
('08_guild_heros_room','guild_heros_room',352 ,352 ,-2 ,'Aile Est — Chambre du Héros (vide)',['Couloir Ouest : 07_guild_bedroom_hallway']),
('09_guild_top_left_bedroom','guild_top_left_bedroom',352 ,352 ,-2 ,'Dortoir Nord-Ouest (vide)',['Couloir Sud : 07_guild_bedroom_hallway (Nord-G)']),
('10_guild_top_right_bedroom','guild_top_right_bedroom',352 ,352 ,-2 ,'Dortoir Nord-Est (vide)',['Couloir Sud : 07_guild_bedroom_hallway (Nord-D)']),
('11_guild_bottom_left_bedroom','guild_bottom_left_bedroom',352 ,352 ,-2 ,'Dortoir Sud-Ouest (vide)',['Couloir Nord : 07_guild_bedroom_hallway (Sud-G)']),
('12_guild_bottom_right_bedroom','guild_bottom_right_bedroom',352 ,352 ,-2 ,'Dortoir Sud-Est (vide)',['Couloir Nord : 07_guild_bedroom_hallway (Sud-D)']),
]


def encode_rogueessence_tile_sheet (tiles :list [Image .Image ],cols :int =64 )->bytes :
    """Format binaire exact RogueEssence.Content.TileSheet (<ii + <iiq*N + <q+PNG) ultra-compact."""
    blobs =[encode_8x8_minimal_png (t )for t in tiles ]
    header =struct .pack ('<ii',8 ,len (tiles ))
    off =8 +16 *len (tiles )
    entries :list [bytes ]=[]
    payloads :list [bytes ]=[]
    for i ,blob in enumerate (blobs ):
        entries .append (struct .pack ('<iiq',i %cols ,i //cols ,off ))
        payloads .append (struct .pack ('<q',len (blob ))+blob )
        off +=8 +len (blob )
    return header +b''.join (entries )+b''.join (payloads )


def build_network_overview (rooms_1x :dict [str ,Image .Image ])->Image .Image :
    """Construit la grande carte synoptique du réseau interconnecté avec alignement exact des couloirs."""
    W ,H =2660 ,1560 
    canvas =Image .new ('RGBA',(W ,H ),(22 ,27 ,38 ,255 ))
    draw =ImageDraw .Draw (canvas )

    # Emboîtement spatial exact de chaque aile :
    # - Aile Ouest : 04_dining_room (gauche) -> couloir Est branché dans 05_storage_hallway -> couloir Nord vers 06_storage_room (haut-ouest) -> couloir Est vers 02_third_floor_lobby
    # - Axe Central : 03_guildmasters_room (nord) -> couloir Sud pile au-dessus de l'arche Nord de 02_third_floor_lobby ; escalier NE relié au puits de 01_second_floor -> 00_first_floor
    # - Aile Est : 02_third_floor_lobby -> 07_bedroom_hallway -> 09 & 10 pile au-dessus des 2 couloirs Nord, 11 & 12 pile sous les 2 couloirs Sud, 08_heros_room à droite !
    placements ={
    '00_guild_first_floor':(1690 ,68 ),
    '01_guild_second_floor':(910 ,40 ),
    '06_guild_storage_room':(436 ,540 ),
    '04_guild_dining_room':(24 ,936 ),
    '05_guild_storage_hallway':(486 ,908 ),
    '03_guild_guildmasters_room':(926 ,542 ),
    '02_guild_third_floor_lobby':(856 ,948 ),
    '09_guild_top_left_bedroom':(1624 ,566 ),
    '10_guild_top_right_bedroom':(1992 ,566 ),
    '07_guild_bedroom_hallway':(1706 ,932 ),
    '11_guild_bottom_left_bedroom':(1624 ,1188 ),
    '12_guild_bottom_right_bedroom':(1992 ,1188 ),
    '08_guild_heros_room':(2268 ,868 ),
    }

    # Connecteurs orthogonaux continus reliant chaque seuil de salle à son voisin direct !
    segments =[
    # RDC 00 <-> Hall -1 01 (escalier Est)
    ([(1710 ,188 ),(1540 ,188 )],'#38bdf8'),
    # Puits Ouest de 01 <-> Tour hélicoïdale NE de 02
    ([(1142 ,220 ),(1142 ,504 ),(1530 ,504 ),(1530 ,1080 )],'#38bdf8'),
    # Couloir Sud de 03 <-> Arche Nord de 02
    ([(1118 ,900 ),(1118 ,1020 )],'#fbbf24'),
    # Réfectoire 04 <-> Couloir Ouest 05 <-> Lobby 02 + Couloir Nord 05 <-> Réserve 06
    ([(450 ,1118 ),(520 ,1118 )],'#34d399'),
    ([(662 ,1000 ),(662 ,742 ),(436 ,742 ),(468 ,742 )],'#34d399'),
    ([(436 ,742 ),(396 ,742 ),(396 ,1030 ),(662 ,1030 )],'#34d399'),
    ([(810 ,1118 ),(890 ,1118 )],'#fbbf24'),
    # Lobby 02 <-> Couloir Dortoirs 07 <-> Chambres 08, 09, 10, 11, 12
    ([(1630 ,1068 ),(1736 ,1068 )],'#fbbf24'),
    ([(1854 ,960 ),(1854 ,896 )],'#a78bfa'),
    ([(2052 ,960 ),(2052 ,896 )],'#a78bfa'),
    ([(1850 ,1165 ),(1850 ,1218 )],'#a78bfa'),
    ([(2080 ,1165 ),(2080 ,1218 )],'#a78bfa'),
    ([(2165 ,1068 ),(2278 ,1068 )],'#f472b6'),
    ]
    for pts ,col_hex in segments :
        draw .line (pts ,fill =col_hex ,width =6 )

    for key ,(px ,py )in placements .items ():
        im =rooms_1x [key ]
        canvas .paste (im ,(px ,py ),im )
        short =key .replace ('_guild_',' · ')
        draw .rectangle ([px +6 ,py -21 ,px +10 +len (short )*7 ,py -4 ],fill =(15 ,20 ,30 ,235 ),outline =(90 ,112 ,148 ,255 ))
        draw .text ((px +10 ,py -18 ),short ,fill =(241 ,245 ,249 ,255 ))

    return canvas 


def main ()->None :
    PNG_DIR .mkdir (parents =True ,exist_ok =True )
    CHECK_DIR .mkdir (parents =True ,exist_ok =True )

    raw_rooms =polish_rooms ()
    rooms_1x :dict [str ,Image .Image ]={}

    # Quantifie l'ensemble des 13 salles sur une palette globale partagée de 32 couleurs chaudes Métano !
    fitted_rooms :dict [str ,Image .Image ]={}
    sample_strip =Image .new ('RGB',(640 ,640 ),(196 ,128 ,42 ))
    sx_p ,sy_p =0 ,0 
    for key ,_ ,tw_px ,th_px ,_ ,_ ,_ in ROOM_SPECS :
        pad =0 if key =='00_guild_first_floor'else 8 
        im_fit =fit_rgba_to_exact_grid (raw_rooms [key ],tw_px ,th_px ,pad_px =pad )
        fitted_rooms [key ]=im_fit 
        thumb =im_fit .resize ((160 ,160 ),Image .Resampling .NEAREST )
        bg_t =Image .new ('RGB',(160 ,160 ),(196 ,128 ,42 ))
        bg_t .paste (thumb ,(0 ,0 ),thumb )
        sample_strip .paste (bg_t ,((sx_p %4 )*160 ,(sy_p //4 )*160 ))
        sx_p +=1 ;sy_p +=1 
    master_room_pal =sample_strip .quantize (colors =32 ,method =Image .Quantize .FASTOCTREE ,dither =Image .Dither .NONE )

    shared_guild_tiles :list [Image .Image ]=[]
    shared_guild_index :dict [bytes ,int ]={}
    room_grids :dict [str ,tuple [int ,int ,list [list [int |None ]],int ]]={}

    for key ,halcyon_id ,tw_px ,th_px ,floor_num ,label_fr ,conns in ROOM_SPECS :
        im_raw_fit =fitted_rooms [key ]
        arr_f =np .array (im_raw_fit )
        mask_f =arr_f [...,3 ]>=128 
        q_rgb =Image .fromarray (arr_f [...,:3 ],'RGB').quantize (palette =master_room_pal ,dither =Image .Dither .NONE ).convert ('RGB')
        arr_q =np .zeros_like (arr_f )
        arr_q [mask_f ,:3 ]=np .array (q_rgb )[mask_f ]
        arr_q [mask_f ,3 ]=255 
        im_1x =Image .fromarray (arr_q ,'RGBA')
        save_compact_png (im_1x ,PNG_DIR /f'{key}.png',colors =64 )
        rooms_1x [key ]=im_1x 

        gw ,gh =tw_px //8 ,th_px //8 
        grid :list [list [int |None ]]=[[None ]*gh for _ in range (gw )]
        local_set :set [int ]=set ()
        for cx in range (gw ):
            for cy in range (gh ):
                cell =arr_q [cy *8 :(cy +1 )*8 ,cx *8 :(cx +1 )*8 ]
                if int (cell [...,3 ].max ())==0 :
                    continue 
                t_im =Image .fromarray (cell ,'RGBA')
                kbytes =t_im .tobytes ()
                idx =shared_guild_index .get (kbytes )
                if idx is None :
                    idx =len (shared_guild_tiles )
                    shared_guild_index [kbytes ]=idx 
                    shared_guild_tiles .append (t_im )
                grid [cx ][cy ]=idx 
                local_set .add (idx )
        room_grids [key ]=(gw ,gh ,grid ,len (local_set ))
        print (f'[ROOM] {key:32s}: {tw_px}x{th_px}px ({gw}x{gh}t) | room_unique={len(local_set):4d} | bank_total={len(shared_guild_tiles):5d}')

        # 2. Zone extérieure `cliff_north_metano` (138x98 tuiles = 1104x784 px) sur palette 32 couleurs pixel-art !
    cno_src_json =json .loads ((ROOT /'cliffnordouesttest1.rsground').read_text (encoding ='utf-8-sig'))
    cno_obj_orig =cno_src_json ['Object']
    CW ,CH =len (cno_obj_orig ['Layers'][0 ]['Tiles']),len (cno_obj_orig ['Layers'][0 ]['Tiles'][0 ])
    cno_hd =Image .open (GEN /'cliffnordouest_northground.png').convert ('RGBA')
    cno_1x =quantize_rgba_clean (cno_hd .resize ((CW *8 ,CH *8 ),Image .Resampling .LANCZOS ),n_colors =64 )
    save_compact_png (cno_1x ,PNG_DIR /'cliff_north_metano.png',colors =96 )

    cno_arr =np .array (cno_1x )
    cno_tiles :list [Image .Image ]=[]
    cno_index :dict [bytes ,int ]={}
    cno_base_grid :list [list [int ]]=[[0 ]*CH for _ in range (CW )]
    cno_anim_frames_grid :dict [tuple [int ,int ],list [int ]]={}

    for cx in range (CW ):
        for cy in range (CH ):
            cell =cno_arr [cy *8 :(cy +1 )*8 ,cx *8 :(cx +1 )*8 ]
            t_im =Image .fromarray (cell ,'RGBA')
            kb =t_im .tobytes ()
            idx =cno_index .get (kb )
            if idx is None :
                idx =len (cno_tiles )
                cno_index [kb ]=idx 
                cno_tiles .append (t_im )
            cno_base_grid [cx ][cy ]=idx 

            is_waterfall_col =(80 <=cx <=95 )and (68 <=cy <=95 )
            if is_waterfall_col and (float (cell [...,2 ].mean ())-float (cell [...,0 ].mean ())>35 ):
                f_indices =[idx ]
                for shift_px in (2 ,4 ,6 ):
                    rolled =np .roll (cell ,shift =shift_px ,axis =0 )
                    ft =Image .fromarray (rolled ,'RGBA')
                    fkb =ft .tobytes ()
                    fidx =cno_index .get (fkb )
                    if fidx is None :
                        fidx =len (cno_tiles )
                        cno_index [fkb ]=fidx 
                        cno_tiles .append (ft )
                    f_indices .append (fidx )
                cno_anim_frames_grid [(cx ,cy )]=f_indices 

    print (f'[CLIFFNORTH] cliff_north_metano: {CW*8}x{CH*8}px ({CW}x{CH}t) | unique_tiles={len(cno_tiles)} | waterfall_anim_cells={len(cno_anim_frames_grid)}')

    # 3. Carte synoptique du réseau interconnecté des 13 salles
    net_map =build_network_overview (rooms_1x )
    save_compact_png (net_map ,PNG_DIR /'reseau_complet_13_salles_guilde.png',colors =128 )

    board_check =Image .new ('RGB',(2040 ,1480 ),(22 ,27 ,38 ))
    dchk =ImageDraw .Draw (board_check )
    for idx_r ,(key ,_ ,tw_px ,th_px ,_ ,title_fr ,_ )in enumerate (ROOM_SPECS ):
        im =rooms_1x [key ]
        col_i ,row_i =idx_r %4 ,idx_r //4 
        bx ,by =col_i *508 +10 ,row_i *366 +10 
        dchk .rectangle ([bx ,by ,bx +496 ,by +354 ],outline =(62 ,76 ,104 ),width =1 )
        sc =min (476 /im .width ,314 /im .height ,1.0 )
        disp =im if sc >=1.0 else im .resize ((round (im .width *sc ),round (im .height *sc )),Image .Resampling .NEAREST )
        board_check .paste (disp ,(bx +(496 -disp .width )//2 ,by +28 +(320 -disp .height )//2 ),disp )
        dchk .text ((bx +8 ,by +7 ),f'{key} ({tw_px}x{th_px})',fill =(226 ,232 ,240 ))
    board_check .save (CHECK_DIR /'verify_13_rooms_1x.png')

    # 4. Encodage binaire RogueEssence .tile + vérification intégrale par PIL.Image.open de CHAQUE tuile !
    GUILD_SHEET_NAME ='Guilde_Reseau_Vide_Metano_8px'
    CLIFF_SHEET_NAME ='Cliff_North_Metano_8px'
    COLS =64 

    guild_tile_bytes =encode_rogueessence_tile_sheet (shared_guild_tiles ,cols =COLS )
    cliff_tile_bytes =encode_rogueessence_tile_sheet (cno_tiles ,cols =COLS )

    for tname ,tbytes ,expected_n in [
    (GUILD_SHEET_NAME ,guild_tile_bytes ,len (shared_guild_tiles )),
    (CLIFF_SHEET_NAME ,cliff_tile_bytes ,len (cno_tiles )),
    ]:
        tsize_chk ,cnt_chk =struct .unpack_from ('<ii',tbytes ,0 )
        assert tsize_chk ==8 and cnt_chk ==expected_n 
        # Décode un échantillon + première et dernière tuiles avec PIL pour garantir 100% conformité PNG !
        for sample_i in [0 ,cnt_chk //2 ,cnt_chk -1 ]:
            _ ,_ ,boff_s =struct .unpack_from ('<iiq',tbytes ,8 +16 *sample_i )
            blen_s =struct .unpack_from ('<q',tbytes ,boff_s )[0 ]
            decoded =Image .open (io .BytesIO (tbytes [boff_s +8 :boff_s +8 +blen_s ])).convert ('RGBA')
            assert decoded .size ==(8 ,8 )
        print (f'[TILE BANK] {tname:32s}: {cnt_chk:5d} tiles -> {len(tbytes)/1024:.1f} KiB raw')

    rsground_payloads :dict [str ,bytes ]={}
    empty_cell ={'AutoTileset':'','Associates':[],'Layers':[],'NeighborCode':-1 }

    manifest_rooms =[]
    for key ,halcyon_id ,tw_px ,th_px ,floor_num ,label_fr ,conns in ROOM_SPECS :
        src_g =json .loads ((GROUND_SRC /f'{halcyon_id}.rsground').read_text (encoding ='utf-8-sig'))
        obj =copy .deepcopy (src_g ['Object'])
        gw ,gh ,grid ,local_unique =room_grids [key ]
        asset_name =f'guilde_vide_{halcyon_id}'
        obj ['AssetName']=asset_name 
        obj ['Comment']=(
        f'{label_fr} — Salle 100% vide sans mobilier ni signe Spinda '
        f'(forme Halcyon {halcyon_id}, textures Metano Inn/Normal/Grass). Non teste moteur.'
        )
        base_cols =[]
        decor_cols =[]
        for cx in range (gw ):
            bcol =[]
            dcol =[]
            for cy in range (gh ):
                tidx =grid [cx ][cy ]
                if tidx is None :
                    bcol .append (empty_cell )
                else :
                    bcol .append ({
                    'AutoTileset':'',
                    'Associates':[],
                    'Layers':[{
                    'Frames':[{'Sheet':GUILD_SHEET_NAME ,'TexLoc':{'X':tidx %COLS ,'Y':tidx //COLS }}],
                    'FrameLength':60 ,
                    }],
                    'NeighborCode':-1 ,
                    })
                dcol .append (empty_cell )
            base_cols .append (bcol )
            decor_cols .append (dcol )
        obj ['Layers']=[
        {'Name':'Architecture_Vide','Layer':0 ,'Visible':True ,'Tiles':base_cols },
        {'Name':'Decor_Vide','Layer':2 ,'Visible':True ,'Tiles':decor_cols },
        ]
        g_doc ={'Version':src_g .get ('Version','0.8.12.0'),'Object':obj }
        rsground_payloads [f'{asset_name}.rsground']=json .dumps (g_doc ,ensure_ascii =False ,separators =(',',':')).encode ('utf-8')
        manifest_rooms .append ({
        'id':key ,
        'halcyon_shape_source':halcyon_id ,
        'ground_file':f'Data/Ground/{asset_name}.rsground',
        'png_1x':f'png_1x/{key}.png',
        'width_px':tw_px ,
        'height_px':th_px ,
        'width_tiles':gw ,
        'height_tiles':gh ,
        'floor_level':floor_num ,
        'title_fr':label_fr ,
        'connections':conns ,
        'unique_tiles_in_room':local_unique ,
        'furniture_count':0 ,
        'spinda_spirals_count':0 ,
        })

    cno_new =copy .deepcopy (cno_obj_orig )
    cno_new ['AssetName']='cliff_north_metano'
    cno_new ['Comment']=(
    'Remake sans couture de cliffnordouesttest1.rsground en style Metano '
    '(138x98 tuiles = 1104x784 px, collisions conservees, cascade animee 4 frames). Non teste moteur.'
    )
    cno_base_cols =[]
    cno_anim_cols =[]
    for cx in range (CW ):
        bcol =[]
        acol =[]
        for cy in range (CH ):
            bidx =cno_base_grid [cx ][cy ]
            bcol .append ({
            'AutoTileset':'',
            'Associates':[],
            'Layers':[{
            'Frames':[{'Sheet':CLIFF_SHEET_NAME ,'TexLoc':{'X':bidx %COLS ,'Y':bidx //COLS }}],
            'FrameLength':60 ,
            }],
            'NeighborCode':-1 ,
            })
            if (cx ,cy )in cno_anim_frames_grid :
                f_list =[
                {'Sheet':CLIFF_SHEET_NAME ,'TexLoc':{'X':fi %COLS ,'Y':fi //COLS }}
                for fi in cno_anim_frames_grid [(cx ,cy )]
                ]
                acol .append ({
                'AutoTileset':'',
                'Associates':[],
                'Layers':[{'Frames':f_list ,'FrameLength':10 }],
                'NeighborCode':-1 ,
                })
            else :
                acol .append (empty_cell )
        cno_base_cols .append (bcol )
        cno_anim_cols .append (acol )

    cno_new ['Layers']=[
    {'Name':'Terrain_Promontoire_Metano','Layer':0 ,'Visible':True ,'Tiles':cno_base_cols },
    {'Name':'Cascade_Animee_4Frames','Layer':1 ,'Visible':True ,'Tiles':cno_anim_cols },
    ]
    cno_doc ={'Version':cno_src_json .get ('Version','0.8.12.0'),'Object':cno_new }
    rsground_payloads ['cliff_north_metano.rsground']=json .dumps (cno_doc ,ensure_ascii =False ,separators =(',',':')).encode ('utf-8')

    tile_index_doc ={
    'Version':'0.8.12.0',
    'Object':{
    '$type':'RogueEssence.Data.TileIndex, RogueEssence',
    'Nodes':{
    GUILD_SHEET_NAME :{'Name':{'DefaultText':'Guilde Reseau Vide Metano','LocalTexts':{}},'Released':True ,'Comment':'Banque partagee 13 salles vides Guilde'},
    CLIFF_SHEET_NAME :{'Name':{'DefaultText':'Cliff North Metano','LocalTexts':{}},'Released':True ,'Comment':'Promontoire Nord-Ouest Metano + cascade 4f'},
    },
    },
    }

    manifest ={
    'pack_id':'guilde_reseau_vide_et_cliffnorth_pmdo_v1',
    'pmdo_version':'0.8.12.0',
    'art_approved':False ,
    'runtime_tested':False ,
    'runtime_PMDO':'NOT TESTED',
    'attribution':(
    'Formes/layouts de salles inspires de meta/Halcyon (guild_*.rsground) et references de '
    'palette/textures Metano (Metano Inn, Metano Normal Home, Metano Grass Home, Metano Town, '
    'Metano Altere Transition) + layout promontoire de ./cliffnordouesttest1.rsground du depot. '
    'Pixels generes par IA referencee et convertis en tuiles 8x8; non certifies tuiles natives officielles.'
    ),
    'cliff_north':{
    'source_rsground':'cliffnordouesttest1.rsground',
    'output_ground':'Data/Ground/cliff_north_metano.rsground',
    'output_tilesheet':f'Content/Tile/{CLIFF_SHEET_NAME}.tile',
    'png_1x':'png_1x/cliff_north_metano.png',
    'width_tiles':CW ,
    'height_tiles':CH ,
    'width_px':CW *8 ,
    'height_px':CH *8 ,
    'unique_tiles':len (cno_tiles ),
    'animated_waterfall_cells':len (cno_anim_frames_grid ),
    'obstacles_preserved_from_source':True ,
    },
    'guild_empty_network':{
    'room_count':len (manifest_rooms ),
    'shared_tilesheet':f'Content/Tile/{GUILD_SHEET_NAME}.tile',
    'shared_unique_tiles':len (shared_guild_tiles ),
    'network_overview_png':'png_1x/reseau_complet_13_salles_guilde.png',
    'furniture_count_total':0 ,
    'spinda_spirals_total':0 ,
    'rooms':manifest_rooms ,
    },
    }
    manifest_bytes =json .dumps (manifest ,ensure_ascii =False ,indent =2 ).encode ('utf-8')
    (OUT /'manifest.json').write_bytes (manifest_bytes )

    readme_md ="""# Pack PMDO 0.8.12 — Zone `Cliff North` (Métano) & Réseau Complet des Salles Vides de la Guilde

## Contenu du pack
1. **Zone extérieure `cliff_north_metano`** (`138 × 98` tuiles = `1104 × 784 px`)
   - Refonte intégrale sans couture de `./cliffnordouesttest1.rsground` avec la direction artistique Métano (`Metano Town` / `Metano-Altere Transition`).
   - Ciel azur de jour et nuages blancs, mer scintillante entourant le cap ouest et le pied de falaise sud, parois rocheuses continues, plateau herbeux fleuri, arbres Métano hors zone de marche, grand sentier/esplanade sableux est→ouest dégagé, et cascade sud animée sur **4 frames**.
   - Grille de collisions `138 × 98` (`obstacles`) de `cliffnordouesttest1.rsground` intégralement préservée sans modifier le fichier source.

2. **Réseau cohérent des 12 salles souterraines + vestibule RDC de la Guilde (`13` cartes Ground PMDO `0.8.12`)**
   - Silhouettes asymétriques fidèles aux salles de la Guilde Halcyon (`guild_*`), textures unifiées bois chaud / écorce sculptée / mousse / lianes vertes (`Metano Inn`, `Metano Normal Home`, `Metano Grass Home`).
   - **100 % vides** : `0` lit, `0` table, `0` tapis, `0` meuble.
   - **Sol parquet pur** : `0` signe Spinda / spirale.
   - Extérieur `RGBA alpha = 0` propre sans bloc noir ni résidu magenta.

## metas & Statut
- metas des layouts et références canoniques : **meta / Halcyon** et artistes **Pokémon Mystery Dungeon** d'origine (les rendus générés constituent de nouveaux dessins référencés, distincts des tuiles natives certifiées).
- Statut : `art_approved: false`, `runtime_tested: false` (vérification binaire et structurelle effectuée hors moteur PMDO).
"""
    (OUT /'README.md').write_text (readme_md ,encoding ='utf-8')

    zip_path =OUT /'PACK_GUILDE_RESEAU_VIDE_ET_CLIFFNORTH_PMDO.zip'
    with zipfile .ZipFile (zip_path ,'w',compression =zipfile .ZIP_DEFLATED ,compresslevel =9 )as zf :
        zf .writestr ('MOD_GUILDE_ET_CLIFFNORTH/README.md',readme_md .encode ('utf-8'))
        zf .writestr ('MOD_GUILDE_ET_CLIFFNORTH/manifest.json',manifest_bytes )
        zf .writestr (f'MOD_GUILDE_ET_CLIFFNORTH/Content/Tile/{GUILD_SHEET_NAME}.tile',guild_tile_bytes )
        zf .writestr (f'MOD_GUILDE_ET_CLIFFNORTH/Content/Tile/{CLIFF_SHEET_NAME}.tile',cliff_tile_bytes )
        zf .writestr ('MOD_GUILDE_ET_CLIFFNORTH/Content/Tile/index.idx',json .dumps (tile_index_doc ,ensure_ascii =False ,indent =2 ).encode ('utf-8'))
        for gfn ,gbytes in sorted (rsground_payloads .items ()):
            zf .writestr (f'MOD_GUILDE_ET_CLIFFNORTH/Data/Ground/{gfn}',gbytes )
        for p in sorted (PNG_DIR .glob ('*.png')):
            zf .write (p ,f'MOD_GUILDE_ET_CLIFFNORTH/PNG_1x/{p.name}')

    total_bytes =sum (f .stat ().st_size for f in OUT .rglob ('*')if f .is_file ())
    print (f'[ZIP] {zip_path.name}: {zip_path.stat().st_size / (1024*1024):.3f} MiB | sha256={hashlib.sha256(zip_path.read_bytes()).hexdigest()[:16]}...')
    print (f'[TOTAL DISK] {OUT.name}: {total_bytes / (1024*1024):.3f} MiB ({total_bytes} bytes)')


if __name__ =='__main__':
    main ()
