#!/usr/bin/env python3
"""Conversion 100 % fidèle Jour -> Nuit (ZÉRO génération IA) AVEC ANIMATION NATIVE NUAGES + MER + CASCADES
pour PMDO 0.8.12 (RogueEssence) sur les deux cartes existantes :
  1. ./cliffdaytest.rsground        ("CliffReverietownnordest", 123x99 tuiles = 984x792 px)
  2. ./cliffnordouesttest1.rsground ("Cliff Nord-Ouest",        138x98 tuiles = 1104x784 px)

Architecture native PMDO 0.8.12 (conforme à RogueEssence GroundMap / LayeredBG / TileLayer / DirSheet / TileIndex) :
  - Ciel sans bande + Lune/Étoiles + 3 plans de Nuages animés en défilement continu horizontal (RepeatX = True) :
      Object['Background'] = RogueEssence.Dungeon.LayeredBG avec 5 couches Content/BG/*.dir :
        1. *_CIEL              : dégradé nocturne velouté sans aucune bande, aligné sur l'horizon marin exact
        2. *_ASTRES            : croissant de lune + étoiles PMD2 opaques au-dessus de l'horizon
        3. CLIFF_NUIT_NUAGES_HORIZON : banc continu de cumulus posé pile sur la ligne d'horizon marin (BGMovement.X = -5)
        4. CLIFF_NUIT_NUAGES_MILIEU  : cumulus de moyenne altitude en défilement fluide (BGMovement.X = -9)
        5. CLIFF_NUIT_NUAGES_HAUT    : cumulus éclairés par la lune en haute altitude (BGMovement.X = -14)
      -> Parallaxe atmosphérique 3 vitesses fidèle à PMD2 Explorateurs du Ciel (Sharpedo Bluff) sans script Lua.
  - Mer nocturne animée 8 phases complètes (FrameLength = 10 @ 60 Hz = 166,67 ms/phase, boucle fluide de 1,333 s) :
      Basée 100 % sur nuit_mer_00..07.png + l'onde cyclique Chunsoft exacte de jour_mer_00..07.png rehaussée d'un reflet
      lunaire argent-azur continu (s_k = 0 -> 100 % nuit_mer profond du haut en bas ; crêtes lunaires nettes à 1x).
  - Cascades, étang et fleurs animés 4 phases (FrameLength = 10 @ 60 Hz, synchronisés sur les 8 phases de mer).
  - 100 % des collisions (obstacles), entités (Entities), bâtiments et arbres préservés au pixel près.
"""
from __future__ import annotations 

import copy 
import hashlib 
import io 
import json 
import shutil 
import struct 
import zipfile 
import zlib 
from pathlib import Path 
from typing import Dict ,List ,Tuple 

import numpy as np 
from PIL import Image 
from scipy .ndimage import gaussian_filter1d 
from scipy .spatial import cKDTree 

ROOT =Path ('/home/user/projet-creation-pmdo')
T02 =Path ('/tmp/t02/Content/Tile')
PPMDO =Path ('/tmp/ppmdo')
OUT_DIR =ROOT /'livrables_cliff_nord_nuit_pmdo'
PNG_DIR =OUT_DIR /'png_1x'
WEB_LAYERS_DIR =OUT_DIR /'viewer_layers_1x'
LAYERS_DIR =OUT_DIR /'calques_nuit_1x'
ANIM_DIR =OUT_DIR /'animations_1x'
MOD_DIR =OUT_DIR /'MOD_CLIFF_NORD_NUIT_PMDO'


def premult_rgba (im :Image .Image )->Image .Image :
    """Prémultiplication alpha conforme à RogueEssence ImportHelper (DirSheet & TileSheet)."""
    arr =np .array (im .convert ('RGBA'),dtype =np .uint16 )
    arr [...,:3 ]=(arr [...,:3 ]*arr [...,3 :4 ])//255 
    return Image .fromarray (arr .astype (np .uint8 ),'RGBA')


def premult_over (dst :np .ndarray ,src_pm :np .ndarray ,x0 :int =0 ,y0 :int =0 )->None :
    """Fusion XNA/MonoGame exacte BlendState.AlphaBlend (One, InverseSourceAlpha) en place sur dst RGBA uint8."""
    sh ,sw =src_pm .shape [:2 ]
    dh ,dw =dst .shape [:2 ]
    cx0 ,cy0 =max (0 ,-x0 ),max (0 ,-y0 )
    cx1 ,cy1 =min (sw ,dw -x0 ),min (sh ,dh -y0 )
    if cx1 <=cx0 or cy1 <=cy0 :
        return 
    s =src_pm [cy0 :cy1 ,cx0 :cx1 ].astype (np .uint16 )
    d =dst [y0 +cy0 :y0 +cy1 ,x0 +cx0 :x0 +cx1 ].astype (np .uint16 )
    inv_a =255 -s [...,3 :4 ]
    out_rgb =np .minimum (255 ,s [...,:3 ]+(d [...,:3 ]*inv_a )//255 )
    out_a =np .minimum (255 ,s [...,3 :4 ]+(d [...,3 :4 ]*inv_a )//255 )
    dst [y0 +cy0 :y0 +cy1 ,x0 +cx0 :x0 +cx1 ,:3 ]=out_rgb .astype (np .uint8 )
    dst [y0 +cy0 :y0 +cy1 ,x0 +cx0 :x0 +cx1 ,3 :4 ]=out_a .astype (np .uint8 )


def _png_chunk (tag :bytes ,data :bytes )->bytes :
    return struct .pack ('>I',len (data ))+tag +data +struct .pack ('>I',zlib .crc32 (tag +data )&0xFFFFFFFF )


def encode_8x8_minimal_png (tile_rgba :Image .Image )->bytes :
    """Encode une tuile RGBA 8x8 prémultipliée en PNG minimal conforme ISO/IEC 15948 & RogueEssence."""
    arr =np .array (premult_rgba (tile_rgba ),dtype =np .uint8 )
    flat =arr .reshape (-1 ,4 )
    packed =(
    (flat [:,0 ].astype (np .uint32 )<<24 )
    |(flat [:,1 ].astype (np .uint32 )<<16 )
    |(flat [:,2 ].astype (np .uint32 )<<8 )
    |flat [:,3 ].astype (np .uint32 )
    )
    uniq ,inv =np .unique (packed ,return_inverse =True )
    n =len (uniq )
    if n <=16 :
        bit_depth =4 
        idx_rows =inv .reshape (8 ,8 ).astype (np .uint8 )
        packed_rows =(idx_rows [:,0 ::2 ]<<4 )|idx_rows [:,1 ::2 ]
        raw_scan =b''.join (b'\x00'+packed_rows [y ].tobytes ()for y in range (8 ))
    else :
        bit_depth =8 
        idx_rows =inv .reshape (8 ,8 ).astype (np .uint8 )
        raw_scan =b''.join (b'\x00'+idx_rows [y ].tobytes ()for y in range (8 ))

    r =((uniq >>24 )&0xFF ).astype (np .uint8 )
    g =((uniq >>16 )&0xFF ).astype (np .uint8 )
    b =((uniq >>8 )&0xFF ).astype (np .uint8 )
    a =(uniq &0xFF ).astype (np .uint8 )
    plte =np .stack ([r ,g ,b ],axis =1 ).tobytes ()

    ihdr =struct .pack ('>IIBBBBB',8 ,8 ,bit_depth ,3 ,0 ,0 ,0 )
    chunks =[b'\x89PNG\r\n\x1a\n',_png_chunk (b'IHDR',ihdr ),_png_chunk (b'PLTE',plte )]
    if np .any (a <255 ):
        chunks .append (_png_chunk (b'tRNS',a .tobytes ()))
    chunks .append (_png_chunk (b'IDAT',zlib .compress (raw_scan ,level =9 )))
    chunks .append (_png_chunk (b'IEND',b''))
    return b''.join (chunks )


def save_lossless_png (im :Image .Image ,path :Path )->None :
    path .parent .mkdir (parents =True ,exist_ok =True )
    im .convert ('RGBA').save (path ,format ='PNG',optimize =True ,compress_level =9 )


def write_dir_sheet (path :Path ,im :Image .Image )->dict :
    """Écrit un binaire RogueEssence Content/BG/*.dir conforme à DirSheet.cs."""
    path .parent .mkdir (parents =True ,exist_ok =True )
    pm =premult_rgba (im )
    buf =io .BytesIO ()
    pm .save (buf ,format ='PNG',optimize =True ,compress_level =9 )
    png_raw =buf .getvalue ()
    raw =struct .pack ('<q',len (png_raw ))+png_raw +struct .pack ('<4i',im .width ,im .height ,0 ,1 )
    path .write_bytes (raw )
    return {
    'name':path .stem ,
    'size':[im .width ,im .height ],
    'bytes':len (raw ),
    'sha256':hashlib .sha256 (raw ).hexdigest (),
    }


def make_map_bg (name :str ,y_offset :int =0 ,move_x :int =0 ,repeat_x :bool =False )->dict :
    """Construit un noeud RogueEssence.Dungeon.MapBG natif."""
    return {
    '$type':'RogueEssence.Dungeon.MapBG, RogueEssence',
    'MapLoc':{'X':0 ,'Y':y_offset },
    'BGAnim':{
    'AnimIndex':name ,
    'FrameTime':1 ,
    'StartFrame':-1 ,
    'EndFrame':-1 ,
    'AnimDir':-1 ,
    'Alpha':255 ,
    'AnimFlip':0 ,
    },
    'BGMovement':{'X':move_x ,'Y':0 },
    'Parallax':'1, 1',
    'RepeatX':repeat_x ,
    'RepeatY':False ,
    }


def write_dotnet_string (value :str )->bytes :
    raw =value .encode ('utf-8')
    size ,header =len (raw ),bytearray ()
    while size >=128 :
        header .append ((size &127 )|128 )
        size >>=7 
    return bytes (header )+bytes ([size ])+raw 


def write_tile_index_idx (path :Path ,tile_paths :List [Path ])->None :
    """Écrit un Content/Tile/index.idx binaire RogueEssence valide."""
    nodes :Dict [str ,bytes ]={}
    for tp in sorted (tile_paths ):
        raw =tp .read_bytes ()
        tsize ,count =struct .unpack_from ('<ii',raw ,0 )
        nodes [tp .stem ]=raw [:8 +count *16 ]
    payload =struct .pack ('<i',len (nodes ))+b''.join (
    write_dotnet_string (name )+nodes [name ]for name in sorted (nodes )
    )
    path .parent .mkdir (parents =True ,exist_ok =True )
    path .write_bytes (payload )


class CompactTileBank :
    """Banque RogueEssence .tile dédupliquant chaque bloc 8x8 RGBA."""

    def __init__ (self ,sheet_name :str ,cols :int =64 ):
        self .sheet_name =sheet_name 
        self .cols =cols 
        self ._dedup :Dict [bytes ,Tuple [int ,int ]]={}
        self ._entries :List [Tuple [int ,int ,bytes ]]=[]

    def add (self ,tile_im :Image .Image )->Tuple [int ,int ]:
        arr =np .array (premult_rgba (tile_im ),dtype =np .uint8 )
        if np .all (arr [...,3 ]==0 ):
            arr =np .zeros ((8 ,8 ,4 ),dtype =np .uint8 )
            tile_im =Image .fromarray (arr ,'RGBA')
        key =arr .tobytes ()
        loc =self ._dedup .get (key )
        if loc is not None :
            return loc 
        idx =len (self ._entries )
        tx ,ty =idx %self .cols ,idx //self .cols 
        png_bytes =encode_8x8_minimal_png (tile_im )
        self ._dedup [key ]=(tx ,ty )
        self ._entries .append ((tx ,ty ,png_bytes ))
        return (tx ,ty )

    def write (self ,path :Path )->dict :
        path .parent .mkdir (parents =True ,exist_ok =True )
        count =len (self ._entries )
        max_x =max ((x for x ,y ,_ in self ._entries ),default =0 )
        max_y =max ((y for x ,y ,_ in self ._entries ),default =0 )
        header =bytearray (struct .pack ('<ii',8 ,count ))
        blobs =bytearray ()
        cur_off =8 +count *16 
        for tx ,ty ,pbytes in self ._entries :
            header .extend (struct .pack ('<iiq',tx ,ty ,cur_off ))
            rec =struct .pack ('<q',len (pbytes ))+pbytes 
            blobs .extend (rec )
            cur_off +=len (rec )
        raw =bytes (header )+bytes (blobs )
        path .write_bytes (raw )
        return {
        'sheet':self .sheet_name ,
        'tile_count':count ,
        'grid':[max_x +1 ,max_y +1 ],
        'bytes':len (raw ),
        'sha256':hashlib .sha256 (raw ).hexdigest (),
        }


def load_tile_sheet (path :Path )->Image .Image :
    raw =path .read_bytes ()
    tsize ,cnt =struct .unpack_from ('<ii',raw ,0 )
    entries =[struct .unpack_from ('<iiq',raw ,8 +i *16 )for i in range (cnt )]
    max_x =max ((x for x ,y ,_ in entries ),default =0 )
    max_y =max ((y for x ,y ,_ in entries ),default =0 )
    im =Image .new ('RGBA',((max_x +1 )*tsize ,(max_y +1 )*tsize ),(0 ,0 ,0 ,0 ))
    for x ,y ,boff in entries :
        blen =struct .unpack_from ('<q',raw ,boff )[0 ]
        tile =Image .open (io .BytesIO (raw [boff +8 :boff +8 +blen ])).convert ('RGBA')
        im .paste (tile ,(x *tsize ,y *tsize ))
    return im 


def build_halcyon_night_lut ():
    """Construit la LUT exacte Jour -> Nuit à partir des 5 paires officielles Halcyon Metano_* / *_Night."""
    pairs_d ,pairs_n =[],[]
    for d_name ,n_name in [
    ('Metano_Town_Base.tile','Metano_Town_Base_Night.tile'),
    ('Metano_Town_Cliffs.tile','Metano_Town_Cliffs_Night.tile'),
    ('Metano_Town_Objects.tile','Metano_Town_Objects_Night.tile'),
    ('Metano_Town_Animation_Tileset.tile','Metano_Town_Animation_Tileset_Night.tile'),
    ('Metano_Town_Animated.tile','Metano_Town_Animated_Night.tile'),
    ]:
        im_d =np .array (load_tile_sheet (T02 /d_name ))
        im_n =np .array (load_tile_sheet (T02 /n_name ))
        h ,w =min (im_d .shape [0 ],im_n .shape [0 ]),min (im_d .shape [1 ],im_n .shape [1 ])
        m =(im_d [:h ,:w ,3 ]>200 )&(im_n [:h ,:w ,3 ]>200 )
        pairs_d .append (im_d [:h ,:w ,:3 ][m ])
        pairs_n .append (im_n [:h ,:w ,:3 ][m ])

    all_d =np .concatenate (pairs_d ,axis =0 )
    all_n =np .concatenate (pairs_n ,axis =0 )
    packed_d =(all_d [:,0 ].astype (np .int32 )<<16 )|(all_d [:,1 ].astype (np .int32 )<<8 )|all_d [:,2 ].astype (np .int32 )
    uniq_keys ,inv =np .unique (packed_d ,return_inverse =True )
    lut_d =np .stack ([(uniq_keys >>16 )&255 ,(uniq_keys >>8 )&255 ,uniq_keys &255 ],axis =1 ).astype (np .float32 )
    lut_n =np .zeros_like (lut_d )
    counts =np .bincount (inv )
    for ch in range (3 ):
        lut_n [:,ch ]=np .round (np .bincount (inv ,weights =all_n [:,ch ])/counts )
    tree =cKDTree (lut_d )

    def transform (im :Image .Image )->Image .Image :
        arr =np .array (im .convert ('RGBA'))
        out =arr .copy ()
        mask =arr [...,3 ]>0 
        if not mask .any ():
            return Image .fromarray (out ,'RGBA')
        rgb_masked =arr [...,:3 ][mask ]
        packed =(
        (rgb_masked [:,0 ].astype (np .int32 )<<16 )
        |(rgb_masked [:,1 ].astype (np .int32 )<<8 )
        |rgb_masked [:,2 ].astype (np .int32 )
        )
        ukeys ,uinv =np .unique (packed ,return_inverse =True )
        px =np .stack ([(ukeys >>16 )&255 ,(ukeys >>8 )&255 ,ukeys &255 ],axis =1 ).astype (np .float32 )
        dists ,idxs =tree .query (px ,k =4 )
        w =1.0 /np .maximum (dists ,0.25 )**2 
        w /=w .sum (axis =1 ,keepdims =True )
        matched_d =(lut_d [idxs ]*w [...,None ]).sum (axis =1 )
        matched_n =(lut_n [idxs ]*w [...,None ]).sum (axis =1 )
        mapped =matched_n +(px -matched_d )*np .array ([0.52 ,0.55 ,0.68 ],dtype =np .float32 )
        exact =dists [:,0 ]==0 
        mapped [exact ]=lut_n [idxs [exact ,0 ]]
        uout =np .clip (np .round (mapped ),0 ,255 ).astype (np .uint8 )
        out [...,:3 ][mask ]=uout [uinv ]
        return Image .fromarray (out ,'RGBA')

    return transform ,len (lut_d )


def build_moonlit_night_sea_8phases (sea_day_8 :List [Image .Image ],sea_night_raw_8 :List [Image .Image ])->List [Image .Image ]:
    """Construit les 8 phases de mer nocturne lunaire PMD2 sans AUCUNE rupture chromatique du haut en bas :
      - Partout où s_k(y,x) == 0 (eau calme & creux d'onde, sur toutes les profondeurs y=0..816) :
        100,000 % identique à nuit_mer_00..07.png canonique (bleu nuit profond continu de l'horizon jusqu'au bas !).
      - Sur l'onde cyclique Chunsoft (s_k(y,x) in ]0, 1]), ajoute un reflet d'écume lunaire argent-azur progressif
        parfaitement visible à 1x dans l'aperçu comme en jeu PMDO.
    """
    j_stack =np .stack ([np .array (im ,dtype =np .float32 )for im in sea_day_8 ],axis =0 )# (8, H, W, 4)
    n_stack =np .stack ([np .array (im ,dtype =np .float32 )for im in sea_night_raw_8 ],axis =0 )# (8, H, W, 4)
    j_min_g =j_stack [...,1 ].min (axis =0 ,keepdims =True )# (1, H, W)
    # Amplitude normalisée de l'onde de crête Chunsoft dans [0, 1] (vaut 0 sur 100 % des pixels statiques !)
    s =np .clip ((j_stack [...,1 ]-j_min_g )/80.0 ,0.0 ,1.0 )[...,None ]# (8, H, W, 1)

    moon_crest =np .array ([104.0 ,178.0 ,236.0 ],dtype =np .float32 )[None ,None ,None ,:]
    blend =0.58 *(s **1.15 )
    rgb =np .clip (np .round (n_stack [...,:3 ]*(1.0 -blend )+moon_crest *blend ),0 ,255 ).astype (np .uint8 )

    out_frames :List [Image .Image ]=[]
    for k in range (8 ):
        fk =np .zeros (n_stack .shape [1 :],dtype =np .uint8 )
        fk [...,:3 ]=rgb [k ]
        fk [...,3 ]=sea_night_raw_8 [k ].getchannel ('A')
        fk [fk [...,3 ]==0 ]=0 
        out_frames .append (Image .fromarray (fk ,'RGBA'))
    return out_frames 


def build_three_cloud_bands_day_and_night ()->Dict [str ,Dict [str ,Image .Image ]]:
    """Construit 3 bandes de cumulus 1440px sans couture (100 % sprites Chunsoft 1:1 non redimensionnés) :
      - 'horizon' (1440 x 64) : cumulus à base plate posés PILE sur la ligne d'horizon marin (comme cliffdaytest_jour_ref !)
      - 'milieu'  (1440 x 96) : cumulus de mi-hauteur bien garnis
      - 'haut'    (1440 x 96) : cumulus de haute altitude éclairés par le clair de lune
    Garantit alpha == 0 aux colonnes x=0..15 et x=1424..1439 -> raccord RepeatX=True 100 % invisible.
    """
    j_sheet =np .array (Image .open (PPMDO /'sprites/cote_dix_zones/fonds/jour_nuages.png').convert ('RGBA'))
    raw_boxes =[
    (32 ,40 ,152 ,48 ),# 0 : aile longue plate (121x20)
    (272 ,16 ,96 ,64 ),# 1 : dôme cumulus haut à base plate (79x38)
    (504 ,72 ,96 ,48 ),# 2 : cumulus moyen (81x21)
    (728 ,32 ,96 ,48 ),# 3 : petit cumulus doux (68x23)
    (920 ,80 ,120 ,56 ),# 4 : cumulus large à base plate (95x25)
    (1160 ,24 ,152 ,64 ),# 5 : grand cumulus majestueux à base plate (124x39)
    ]

    # Extrait serré (bbox exact des pixels opaques) de chacun des 6 nuages Chunsoft Jour
    tight_day :List [Image .Image ]=[]
    tight_night_bright :List [Image .Image ]=[]
    tight_night_mid :List [Image .Image ]=[]
    tight_night_far :List [Image .Image ]=[]

    def grade_cloud_moonlit (arr_rgba :np .ndarray ,rgb_gain :Tuple [float ,float ,float ],lift :Tuple [float ,float ,float ])->Image .Image :
        out =arr_rgba .copy ()
        m =out [...,3 ]>0 
        v =out [...,:3 ][m ].astype (np .float32 )
        lum =(v @np .array ([0.2126 ,0.7152 ,0.0722 ],dtype =np .float32 ))[:,None ]
        desat =lum *0.25 +v *0.75 
        mapped =np .clip (np .round (desat *np .array (rgb_gain ,dtype =np .float32 )+np .array (lift ,dtype =np .float32 )),0 ,255 ).astype (np .uint8 )
        out [...,:3 ][m ]=mapped 
        return Image .fromarray (out ,'RGBA')

    for dx ,dy ,bw ,bh in raw_boxes :
        sub =j_sheet [dy :dy +bh ,dx :dx +bw ]
        ys ,xs =np .where (sub [...,3 ]>0 )
        crop =sub [ys .min ():ys .max ()+1 ,xs .min ():xs .max ()+1 ]
        tight_day .append (Image .fromarray (crop ,'RGBA'))
        # Clair de lune PMD2 : haut des cumulus argent-lavande doux, ombres indigo veloutées
        tight_night_bright .append (grade_cloud_moonlit (crop ,(0.52 ,0.56 ,0.78 ),(10 ,14 ,28 )))
        tight_night_mid .append (grade_cloud_moonlit (crop ,(0.45 ,0.49 ,0.70 ),(8 ,12 ,25 )))
        tight_night_far .append (grade_cloud_moonlit (crop ,(0.39 ,0.43 ,0.63 ),(7 ,11 ,23 )))

    def compose_band (sprites :List [Image .Image ],height :int ,placements :List [Tuple [int ,int ,str ]])->Image .Image :
        band =Image .new ('RGBA',(1440 ,height ),(0 ,0 ,0 ,0 ))
        for sp_idx ,x_pos ,y_mode in placements :
            sp =sprites [sp_idx ]
            if y_mode =='bottom':
                y_pos =height -sp .height 
            else :
                y_pos =int (y_mode )
            assert 20 <=x_pos and x_pos +sp .width <=1420 ,f'Débordement couture: {x_pos}..{x_pos + sp.width}'
            band .alpha_composite (sp ,(x_pos ,y_pos ))
        arr =np .array (band )
        assert np .all (arr [:,:16 ,3 ]==0 )and np .all (arr [:,-16 :,3 ]==0 )
        return band 

        # Banc d'horizon (1440 x 64) : cumulus posés PILE sur l'horizon marin (y_mode == 'bottom')
    horizon_layout =[
    (0 ,28 ,'bottom'),
    (1 ,210 ,'bottom'),
    (5 ,360 ,'bottom'),
    (2 ,560 ,'bottom'),
    (4 ,716 ,'bottom'),
    (3 ,888 ,'bottom'),
    (5 ,1028 ,'bottom'),
    (0 ,1236 ,'bottom'),
    ]
    # Banc médian (1440 x 96) : beaux cumulus espacés à mi-ciel
    mid_layout =[
    (5 ,48 ,'24'),
    (2 ,300 ,'48'),
    (4 ,512 ,'14'),
    (1 ,760 ,'38'),
    (5 ,968 ,'18'),
    (3 ,1248 ,'44'),
    ]
    # Banc supérieur (1440 x 96) : cumulus hauts déphasés passant devant les étoiles et la lune
    high_layout =[
    (0 ,44 ,'34'),
    (5 ,292 ,'10'),
    (3 ,560 ,'42'),
    (4 ,792 ,'18'),
    (1 ,1052 ,'12'),
    (2 ,1268 ,'36'),
    ]

    return {
    'nuit':{
    'horizon':compose_band (tight_night_far ,64 ,horizon_layout ),
    'milieu':compose_band (tight_night_mid ,96 ,mid_layout ),
    'haut':compose_band (tight_night_bright ,96 ,high_layout ),
    },
    'jour':{
    'horizon':compose_band (tight_day ,64 ,horizon_layout ),
    'milieu':compose_band (tight_day ,96 ,mid_layout ),
    'haut':compose_band (tight_day ,96 ,high_layout ),
    },
    }


def make_sky_gradient (width_px :int ,height_px :int ,horizon_y_px :int ,mode :str )->Image .Image :
    """Construit un dégradé céleste PMD2 velouté 100 % SANS AUCUNE BANDE HORIZONTALE, aligné sur horizon_y_px."""
    src_name ='nuit_ciel.png'if mode =='nuit'else 'jour_ciel.png'
    ref_sky =np .array (Image .open (PPMDO /f'sprites/cote_dix_zones/fonds/{src_name}').convert ('RGBA'))
    # Moyenne horizontale + lissage gaussien vertical (sigma=5.0) pour supprimer toute marche de quantification source !
    raw_profile =ref_sky [:147 ,:,:3 ].mean (axis =1 ).astype (np .float32 )
    smooth_profile =gaussian_filter1d (raw_profile ,sigma =5.0 ,axis =0 ,mode ='nearest')

    sky =np .zeros ((height_px ,width_px ,4 ),dtype =np .uint8 )
    sky [...,3 ]=255 
    hy =max (horizon_y_px ,16 )
    ys =np .linspace (0 ,len (smooth_profile )-1 ,hy )
    idx0 =np .floor (ys ).astype (int )
    idx1 =np .minimum (idx0 +1 ,len (smooth_profile )-1 )
    frac =(ys -idx0 )[:,None ]
    ramp_float =smooth_profile [idx0 ]*(1.0 -frac )+smooth_profile [idx1 ]*frac 

    # Tramage ordonné Bayer 4x4 subtil (+/- 0.5 niveau) -> zéro banding 8-bit et zéro rayure
    bayer4 =(
    np .array (
    [[0 ,8 ,2 ,10 ],[12 ,4 ,14 ,6 ],[3 ,11 ,1 ,9 ],[15 ,7 ,13 ,5 ]],
    dtype =np .float32 ,
    )
    /16.0 
    -0.46875 
    )
    dither_map =np .tile (bayer4 ,(hy //4 +1 ,width_px //4 +1 ))[:hy ,:width_px ,None ]
    ramp_2d =np .clip (np .round (ramp_float [:,None ,:]+dither_map *0.95 ),0 ,255 ).astype (np .uint8 )

    sky [:hy ,:,:3 ]=ramp_2d 
    sky [hy :,:,:3 ]=ramp_2d [-1 :,:,:]
    return Image .fromarray (sky ,'RGBA')


def make_native_astres_layer (sky_bg :Image .Image ,horizon_y_px :int ,seed :int )->Image .Image :
    """Combine la lune native de cote_dix_zones/nuit_astres.png + étoiles PMD2 opaques (alpha binaire {0, 255})."""
    width_px ,height_px =sky_bg .size 
    sky_arr =np .array (sky_bg .convert ('RGBA'))
    src_astres =Image .open (PPMDO /'sprites/cote_dix_zones/fonds/nuit_astres.png').convert ('RGBA')
    layer =Image .new ('RGBA',(width_px ,height_px ),(0 ,0 ,0 ,0 ))
    moon_crop =src_astres .crop ((src_astres .width -480 ,0 ,src_astres .width ,140 ))
    layer .paste (moon_crop ,(max (0 ,width_px -460 ),10 ),moon_crop )
    for x in range (0 ,max (0 ,width_px -460 ),240 ):
        w_slice =min (240 ,max (0 ,width_px -460 -x ))
        if w_slice >0 :
            star_slice =src_astres .crop ((0 ,0 ,w_slice ,130 ))
            layer .paste (star_slice ,(x ,12 ),star_slice )

    arr =np .array (layer )
    partial =(arr [...,3 ]>0 )&(arr [...,3 ]<255 )
    if np .any (partial ):
        a =arr [...,3 ][partial ].astype (np .float32 )[:,None ]/255.0 
        blended =np .clip (
        np .round (arr [...,:3 ][partial ].astype (np .float32 )*a +sky_arr [...,:3 ][partial ].astype (np .float32 )*(1.0 -a )),
        0 ,255 ,
        ).astype (np .uint8 )
        arr [...,:3 ][partial ]=blended 
        arr [...,3 ][partial ]=255 

    rng =np .random .default_rng (seed )
    y_min =min (116 ,max (16 ,horizon_y_px //3 ))
    y_max =max (y_min +16 ,int (horizon_y_px *0.80 ))
    n_stars =int ((width_px *(y_max -y_min ))/3400 )
    for _ in range (n_stars ):
        sx =int (rng .integers (4 ,width_px -4 ))
        sy =int (rng .integers (y_min ,y_max ))
        if arr [sy ,sx ,3 ]==0 :
            fade =1.0 -0.55 *(sy /max (1 ,horizon_y_px ))
            t =float (np .clip (0.74 *fade *(0.55 +0.45 *float (rng .random ())),0.22 ,0.86 ))
            rgb =np .clip (
            np .round (sky_arr [sy ,sx ,:3 ].astype (np .float32 )*(1.0 -t )+np .array ([228.0 ,238.0 ,255.0 ])*t ),
            0 ,255 ,
            ).astype (np .uint8 )
            arr [sy ,sx ]=[int (rgb [0 ]),int (rgb [1 ]),int (rgb [2 ]),255 ]
    return Image .fromarray (arr ,'RGBA')


def render_clouds_band_on_canvas (canvas_size :Tuple [int ,int ],strip :Image .Image ,y_off :int ,scroll_left_px :int )->Image .Image :
    out =Image .new ('RGBA',canvas_size ,(0 ,0 ,0 ,0 ))
    off =scroll_left_px %strip .width 
    for x in range (-off ,canvas_size [0 ],strip .width ):
        out .alpha_composite (strip ,(x ,y_off ))
    return out 


def save_animated_gif (frames_rgba :List [Image .Image ],path :Path ,duration_ms :int =166 )->None :
    """Exporte un GIF animé 1x net à palette partagée 256 couleurs (0 scintillement inter-frame)."""
    path .parent .mkdir (parents =True ,exist_ok =True )
    w ,h =frames_rgba [0 ].size 
    sample_strip =Image .new ('RGB',(w ,h *min (4 ,len (frames_rgba ))))
    for idx ,im in enumerate (frames_rgba [:4 ]):
        sample_strip .paste (im .convert ('RGB'),(0 ,idx *h ))
    master_pal =sample_strip .quantize (colors =256 ,method =Image .Quantize .MEDIANCUT ,dither =Image .Dither .NONE )
    pal_frames =[
    im .convert ('RGB').quantize (palette =master_pal ,dither =Image .Dither .NONE )
    for im in frames_rgba 
    ]
    pal_frames [0 ].save (
    path ,
    format ='GIF',
    save_all =True ,
    append_images =pal_frames [1 :],
    duration =duration_ms ,
    loop =0 ,
    optimize =False ,
    )


def main ()->None :
    for d in (OUT_DIR ,PNG_DIR ,WEB_LAYERS_DIR ,LAYERS_DIR ,ANIM_DIR ):
        if d .exists ()and d !=OUT_DIR :
            shutil .rmtree (d )
        d .mkdir (parents =True ,exist_ok =True )
    if MOD_DIR .exists ():
        shutil .rmtree (MOD_DIR )

    halcyon_night ,n_lut_colors =build_halcyon_night_lut ()
    print (f'[LUT] Halcyon Metano Jour->Nuit initialisée ({n_lut_colors} couleurs canoniques exactes)')

    sea_day_8 =[
    Image .open (PPMDO /f'sprites/cote_dix_zones/fonds/jour_mer_{k:02d}.png').convert ('RGBA').crop ((0 ,0 ,1312 ,816 ))
    for k in range (8 )
    ]
    sea_night_raw_8 =[
    Image .open (PPMDO /f'sprites/cote_dix_zones/fonds/nuit_mer_{k:02d}.png').convert ('RGBA').crop ((0 ,0 ,1312 ,816 ))
    for k in range (8 )
    ]
    sea_night_8 =build_moonlit_night_sea_8phases (sea_day_8 ,sea_night_raw_8 )

    day_sheets :Dict [str ,Image .Image ]={
    '00_ciel':load_tile_sheet (T02 /'00_ciel.tile'),
    'v2_promontoire_jour_03':sea_day_8 [0 ],
    '01_long_cap_jour_02':Image .open (PPMDO /'sprites/cote_dix_zones/fonds/jour_nuages.png').convert ('RGBA'),
    '13_avancee_basse_gauche_terrain':Image .open (PPMDO /'renders/caps_terrasses_v4/13_avancee_basse_gauche_terrain.png').convert ('RGBA'),
    'INVERSEPATHWAY':load_tile_sheet (T02 /'INVERSEPATHWAY.tile'),
    'CLIFF MIROR-Photoroom':load_tile_sheet (T02 /'CLIFF MIROR-Photoroom.tile'),
    'terrain':Image .open (PPMDO /'renders/references_calques_v2/falaises/02/terrain.png').convert ('RGBA'),
    'terrain (2)':Image .open (PPMDO /'renders/references_calques_v2/falaises/04/terrain.png').convert ('RGBA'),
    'terrain (3)':Image .open (PPMDO /'renders/references_calques_v2/falaises/08/terrain.png').convert ('RGBA'),
    'terrain (4)':Image .open (PPMDO /'renders/references_calques_v2/falaises/08/terrain.png').convert ('RGBA'),
    'Metano_Altere_Transition_Base':load_tile_sheet (T02 /'Metano_Altere_Transition_Base.tile'),
    'Metano_Town_Cliffs':load_tile_sheet (T02 /'Metano_Town_Cliffs.tile'),
    'Metano_Town_Objects':load_tile_sheet (T02 /'Metano_Town_Objects.tile'),
    'Metano_Town_Animation_Tileset':load_tile_sheet (T02 /'Metano_Town_Animation_Tileset.tile'),
    'Metano_Town_Animated':load_tile_sheet (T02 /'Metano_Town_Animated.tile'),
    'Metano_Town_Trimmed':load_tile_sheet (T02 /'Metano_Town_Trimmed.tile'),
    'Metano_Inn_Objects':load_tile_sheet (T02 /'Metano_Inn_Objects.tile'),
    'Altere_Pond_Cliffs':load_tile_sheet (T02 /'Altere_Pond_Cliffs.tile'),
    'Altere_Pond_Objects':load_tile_sheet (T02 /'Altere_Pond_Objects.tile'),
    'Altere_Pond_Objects_Under':load_tile_sheet (T02 /'Altere_Pond_Objects_Under.tile'),
    'CanyonCamp':load_tile_sheet (T02 /'CanyonCamp.tile'),
    'P01P01A_layer1':load_tile_sheet (T02 /'P01P01A_layer1.tile'),
    }

    night_sheets :Dict [str ,Image .Image ]={
    'v2_promontoire_jour_03':sea_night_8 [0 ],
    '01_long_cap_jour_02':Image .open (PPMDO /'sprites/cote_dix_zones/fonds/nuit_nuages.png').convert ('RGBA'),
    '13_avancee_basse_gauche_terrain':Image .open (PPMDO /'renders/caps_terrasses_v4/13_avancee_basse_gauche_terrain_nuit.png').convert ('RGBA'),
    'Metano_Town_Cliffs':load_tile_sheet (T02 /'Metano_Town_Cliffs_Night.tile'),
    'Metano_Town_Objects':load_tile_sheet (T02 /'Metano_Town_Objects_Night.tile'),
    'Metano_Town_Animation_Tileset':load_tile_sheet (T02 /'Metano_Town_Animation_Tileset_Night.tile'),
    'Metano_Town_Animated':load_tile_sheet (T02 /'Metano_Town_Animated_Night.tile'),
    }
    for sname ,d_im in day_sheets .items ():
        if sname not in night_sheets and sname !='00_ciel':
            night_sheets [sname ]=halcyon_night (d_im )

            # 3 plans de nuages sans couture (Horizon posé sur l'eau + Milieu + Haut) en Nuit & Jour
    cloud_bands =build_three_cloud_bands_day_and_night ()
    dir_stats :List [dict ]=[]
    for tier_key ,dir_name in [
    ('horizon','CLIFF_NUIT_NUAGES_HORIZON'),
    ('milieu','CLIFF_NUIT_NUAGES_MILIEU'),
    ('haut','CLIFF_NUIT_NUAGES_HAUT'),
    ]:
        dir_stats .append (write_dir_sheet (MOD_DIR /'Content/BG'/f'{dir_name}.dir',cloud_bands ['nuit'][tier_key ]))
        save_lossless_png (cloud_bands ['nuit'][tier_key ],WEB_LAYERS_DIR /f'nuages_nuit_{tier_key}_1440.png')
        save_lossless_png (cloud_bands ['jour'][tier_key ],WEB_LAYERS_DIR /f'nuages_jour_{tier_key}_1440.png')

    anim_sheet_night_arr =np .array (night_sheets ['Metano_Town_Animation_Tileset'])
    anim_sheet_day_arr =np .array (day_sheets ['Metano_Town_Animation_Tileset'])

    map_specs =[
    {
    'src_rsground':ROOT /'cliffdaytest.rsground',
    'out_stem':'cliffdaytest_nuit',
    'day_ref_png':'cliffdaytest_jour_ref.png',
    'night_png':'cliffdaytest_nuit.png',
    'tile_bank_name':'CliffNE_Nuit',
    'bg_prefix':'CLIFF_NE_NUIT',
    'display_title':'CliffReverietownnordest (Nuit Animée)',
    'horizon_y_px':304 ,
    'cloud_haut_y':26 ,
    'cloud_milieu_y':134 ,
    'cloud_horizon_y':240 ,# 240 + 64 == 304 px : cumulus d'horizon posés PILE sur l'eau comme cliffdaytest_jour_ref !
    'sky_seed':20261021 ,
    'canopy_layer_idx':5 ,
    },
    {
    'src_rsground':ROOT /'cliffnordouesttest1.rsground',
    'out_stem':'cliffnordouesttest1_nuit',
    'day_ref_png':'cliffnordouesttest1_jour_ref.png',
    'night_png':'cliffnordouesttest1_nuit.png',
    'tile_bank_name':'CliffNW_Nuit',
    'bg_prefix':'CLIFF_NW_NUIT',
    'display_title':'Cliff Nord-Ouest (Nuit Animée)',
    'horizon_y_px':424 ,
    'cloud_haut_y':38 ,
    'cloud_milieu_y':198 ,
    'cloud_horizon_y':360 ,# 360 + 64 == 424 px : cumulus d'horizon posés PILE sur l'eau !
    'sky_seed':20261022 ,
    'canopy_layer_idx':None ,
    },
    ]

    manifest_maps =[]
    written_tile_paths :List [Path ]=[]

    for spec in map_specs :
        raw_doc =json .loads (spec ['src_rsground'].read_text (encoding ='utf-8-sig'))
        src_obj =raw_doc ['Object']
        w =len (src_obj ['Layers'][0 ]['Tiles'])
        h =len (src_obj ['Layers'][0 ]['Tiles'][0 ])
        wp ,hp =w *8 ,h *8 

        sky_nuit =make_sky_gradient (wp ,hp ,spec ['horizon_y_px'],'nuit')
        astres_nuit =make_native_astres_layer (sky_nuit ,spec ['horizon_y_px'],spec ['sky_seed'])
        sky_jour =make_sky_gradient (wp ,hp ,spec ['horizon_y_px'],'jour')

        sky_bg_name =f"{spec['bg_prefix']}_CIEL"
        astres_bg_name =f"{spec['bg_prefix']}_ASTRES"
        dir_stats .append (write_dir_sheet (MOD_DIR /'Content/BG'/f'{sky_bg_name}.dir',sky_nuit ))
        dir_stats .append (write_dir_sheet (MOD_DIR /'Content/BG'/f'{astres_bg_name}.dir',astres_nuit ))

        sky_nuit_merged =Image .alpha_composite (sky_nuit ,astres_nuit )
        save_lossless_png (sky_nuit_merged ,WEB_LAYERS_DIR /f"{spec['out_stem']}_sky.png")
        save_lossless_png (sky_jour ,WEB_LAYERS_DIR /f"{spec['out_stem']}_sky_jour.png")
        save_lossless_png (sky_nuit_merged ,LAYERS_DIR /f"{spec['out_stem']}_BG00_ciel_et_astres.png")

        clouds_t0_preview =Image .new ('RGBA',(wp ,hp ),(0 ,0 ,0 ,0 ))
        for tkey ,yoff in [
        ('horizon',spec ['cloud_horizon_y']),
        ('milieu',spec ['cloud_milieu_y']),
        ('haut',spec ['cloud_haut_y']),
        ]:
            clouds_t0_preview =Image .alpha_composite (
            clouds_t0_preview ,render_clouds_band_on_canvas ((wp ,hp ),cloud_bands ['nuit'][tkey ],yoff ,0 )
            )
        save_lossless_png (clouds_t0_preview ,LAYERS_DIR /f"{spec['out_stem']}_BG01_nuages_animes_wrap.png")

        bank =CompactTileBank (spec ['tile_bank_name'],cols =64 )
        night_doc =copy .deepcopy (raw_doc )
        night_obj =night_doc ['Object']
        night_obj ['AssetName']=spec ['out_stem']
        night_obj ['Name']['DefaultText']=spec ['display_title']
        night_obj ['Background']={
        '$type':'RogueEssence.Dungeon.LayeredBG, RogueEssence',
        'Layers':[
        {'BG':make_map_bg (sky_bg_name ,y_offset =0 ,move_x =0 ,repeat_x =False )},
        {'BG':make_map_bg (astres_bg_name ,y_offset =0 ,move_x =0 ,repeat_x =False )},
        {'BG':make_map_bg ('CLIFF_NUIT_NUAGES_HORIZON',y_offset =spec ['cloud_horizon_y'],move_x =-5 ,repeat_x =True )},
        {'BG':make_map_bg ('CLIFF_NUIT_NUAGES_MILIEU',y_offset =spec ['cloud_milieu_y'],move_x =-9 ,repeat_x =True )},
        {'BG':make_map_bg ('CLIFF_NUIT_NUAGES_HAUT',y_offset =spec ['cloud_haut_y'],move_x =-14 ,repeat_x =True )},
        ],
        }

        sea_nuit_layers_8 =[Image .new ('RGBA',(wp ,hp ),(0 ,0 ,0 ,0 ))for _ in range (8 )]
        sea_jour_layers_8 =[Image .new ('RGBA',(wp ,hp ),(0 ,0 ,0 ,0 ))for _ in range (8 )]
        terrain_nuit_layers_4 =[Image .new ('RGBA',(wp ,hp ),(0 ,0 ,0 ,0 ))for _ in range (4 )]
        terrain_jour_layers_4 =[Image .new ('RGBA',(wp ,hp ),(0 ,0 ,0 ,0 ))for _ in range (4 )]
        canopy_nuit_im =Image .new ('RGBA',(wp ,hp ),(0 ,0 ,0 ,0 ))
        canopy_jour_im =Image .new ('RGBA',(wp ,hp ),(0 ,0 ,0 ,0 ))
        day_orig_comp =Image .new ('RGBA',(wp ,hp ),(0 ,0 ,0 ,255 ))

        layer_png_relpaths =[
        f"calques_nuit_1x/{spec['out_stem']}_BG00_ciel_et_astres.png",
        f"calques_nuit_1x/{spec['out_stem']}_BG01_nuages_animes_wrap.png",
        ]
        sea_anim_cells =0 
        water_anim_cells =0 

        for li ,lay in enumerate (night_obj ['Layers']):
            src_lay =src_obj ['Layers'][li ]
            night_layer_f0 =Image .new ('RGBA',(wp ,hp ),(0 ,0 ,0 ,0 ))
            day_orig_layer =Image .new ('RGBA',(wp ,hp ),(0 ,0 ,0 ,0 ))

            is_canopy_layer =spec ['canopy_layer_idx']is not None and li ==spec ['canopy_layer_idx']
            if is_canopy_layer :
                lay ['Name']='Canopee_Avant_Plan'
                lay ['Layer']=4 

            for x in range (w ):
                for y in range (h ):
                    src_cell =src_lay ['Tiles'][x ][y ]
                    dst_cell =lay ['Tiles'][x ][y ]
                    src_subs =src_cell .get ('Layers',[])
                    new_subs =[]

                    for sub in src_subs :
                        frs =sub .get ('Frames',[])
                        if not frs :
                            continue 
                        fr0 =frs [0 ]
                        s0 =fr0 .get ('Sheet','')
                        if not s0 :
                            continue 
                        tx0 ,ty0 =fr0 ['TexLoc']['X'],fr0 ['TexLoc']['Y']

                        d0_tile =day_sheets [s0 ].crop ((tx0 *8 ,ty0 *8 ,(tx0 +1 )*8 ,(ty0 +1 )*8 ))
                        day_orig_layer .alpha_composite (d0_tile ,(x *8 ,y *8 ))

                        if s0 in ('00_ciel','01_long_cap_jour_02'):
                            continue 

                        if s0 =='v2_promontoire_jour_03':
                            n_frames_8 =[]
                            for pk in range (8 ):
                                nt =sea_night_8 [pk ].crop ((tx0 *8 ,ty0 *8 ,(tx0 +1 )*8 ,(ty0 +1 )*8 ))
                                dt =sea_day_8 [pk ].crop ((tx0 *8 ,ty0 *8 ,(tx0 +1 )*8 ,(ty0 +1 )*8 ))
                                ntx ,nty =bank .add (nt )
                                n_frames_8 .append ({'Sheet':spec ['tile_bank_name'],'TexLoc':{'X':ntx ,'Y':nty }})
                                sea_nuit_layers_8 [pk ].alpha_composite (nt ,(x *8 ,y *8 ))
                                sea_jour_layers_8 [pk ].alpha_composite (dt ,(x *8 ,y *8 ))
                                if pk ==0 :
                                    night_layer_f0 .alpha_composite (nt ,(x *8 ,y *8 ))
                            new_subs .append ({'Frames':n_frames_8 ,'FrameLength':10 })
                            sea_anim_cells +=1 
                            continue 

                        if len (frs )==1 and s0 =='Metano_Town_Animation_Tileset'and 1 <=tx0 <=8 :
                            y_px0 ,y_px1 =ty0 *8 ,(ty0 +1 )*8 
                            max_col_px =(tx0 +28 )*8 
                            if max_col_px <=anim_sheet_night_arr .shape [1 ]and y_px1 <=anim_sheet_night_arr .shape [0 ]:
                                blocks_n =[
                                anim_sheet_night_arr [y_px0 :y_px1 ,(tx0 +9 *k )*8 :(tx0 +9 *k +1 )*8 ]
                                for k in range (4 )
                                ]
                                if all ((b [...,3 ]>0 ).any ()for b in blocks_n )and any (
                                not np .array_equal (blocks_n [k ],blocks_n [0 ])for k in range (1 ,4 )
                                ):
                                    n_frames_4 =[]
                                    for k in range (4 ):
                                        nt =Image .fromarray (blocks_n [k ],'RGBA')
                                        dt =Image .fromarray (
                                        anim_sheet_day_arr [y_px0 :y_px1 ,(tx0 +9 *k )*8 :(tx0 +9 *k +1 )*8 ],
                                        'RGBA',
                                        )
                                        ntx ,nty =bank .add (nt )
                                        n_frames_4 .append ({'Sheet':spec ['tile_bank_name'],'TexLoc':{'X':ntx ,'Y':nty }})
                                        terrain_nuit_layers_4 [k ].alpha_composite (nt ,(x *8 ,y *8 ))
                                        terrain_jour_layers_4 [k ].alpha_composite (dt ,(x *8 ,y *8 ))
                                        if k ==0 :
                                            night_layer_f0 .alpha_composite (nt ,(x *8 ,y *8 ))
                                    new_subs .append ({'Frames':n_frames_4 ,'FrameLength':10 })
                                    water_anim_cells +=1 
                                    continue 

                        valid_frs =[
                        f for f in frs 
                        if f .get ('Sheet')and not (len (frs )>1 and f ['TexLoc']['X']==0 and f ['TexLoc']['Y']==0 )
                        ]
                        if not valid_frs :
                            continue 
                        n_frames_list =[]
                        resolved_n :List [Image .Image ]=[]
                        resolved_d :List [Image .Image ]=[]
                        for f in valid_frs :
                            sn =f ['Sheet']
                            fx ,fy =f ['TexLoc']['X'],f ['TexLoc']['Y']
                            nt =night_sheets [sn ].crop ((fx *8 ,fy *8 ,(fx +1 )*8 ,(fy +1 )*8 ))
                            dt =day_sheets [sn ].crop ((fx *8 ,fy *8 ,(fx +1 )*8 ,(fy +1 )*8 ))
                            ntx ,nty =bank .add (nt )
                            n_frames_list .append ({'Sheet':spec ['tile_bank_name'],'TexLoc':{'X':ntx ,'Y':nty }})
                            resolved_n .append (nt )
                            resolved_d .append (dt )

                        flen =10 if len (n_frames_list )>1 else sub .get ('FrameLength',60 )
                        if len (n_frames_list )>1 :
                            water_anim_cells +=1 
                        new_subs .append ({'Frames':n_frames_list ,'FrameLength':flen })

                        night_layer_f0 .alpha_composite (resolved_n [0 ],(x *8 ,y *8 ))
                        if is_canopy_layer :
                            canopy_nuit_im .alpha_composite (resolved_n [0 ],(x *8 ,y *8 ))
                            canopy_jour_im .alpha_composite (resolved_d [0 ],(x *8 ,y *8 ))
                        else :
                            for k in range (4 ):
                                terrain_nuit_layers_4 [k ].alpha_composite (resolved_n [k %len (resolved_n )],(x *8 ,y *8 ))
                                terrain_jour_layers_4 [k ].alpha_composite (resolved_d [k %len (resolved_d )],(x *8 ,y *8 ))

                    dst_cell ['Layers']=new_subs 
                    dst_cell ['NeighborCode']=0 if new_subs else -1 

            day_orig_comp =Image .alpha_composite (day_orig_comp ,day_orig_layer )
            safe_lname =lay ['Name'].lower ().replace ('/','_').replace (' ','_')
            lp =LAYERS_DIR /f"{spec['out_stem']}_L{li:02d}_{safe_lname}.png"
            save_lossless_png (night_layer_f0 ,lp )
            layer_png_relpaths .append (str (lp .relative_to (OUT_DIR )))

        tile_out =MOD_DIR /'Content/Tile'/f"{spec['tile_bank_name']}.tile"
        bank_stats =bank .write (tile_out )
        written_tile_paths .append (tile_out )

        rsground_out =MOD_DIR /'Data/Ground'/f"{spec['out_stem']}.rsground"
        rsground_out .parent .mkdir (parents =True ,exist_ok =True )
        rsground_out .write_text (json .dumps (night_doc ,separators =(',',':')),encoding ='utf-8')

        lua_out =MOD_DIR /'Data/Script/ground'/spec ['out_stem']/'init.lua'
        lua_out .parent .mkdir (parents =True ,exist_ok =True )
        lua_out .write_text (
        f"-- {spec['out_stem']} : mer 8 phases et 3 plans de nuages LayeredBG animés nativement par PMDO 0.8.12.\n"
        f"local {spec['out_stem']} = {{}}\nreturn {spec['out_stem']}\n",
        encoding ='utf-8',
        )

        for pk in range (8 ):
            save_lossless_png (sea_nuit_layers_8 [pk ],WEB_LAYERS_DIR /f"{spec['out_stem']}_sea_nuit_{pk}.png")
            save_lossless_png (sea_jour_layers_8 [pk ],WEB_LAYERS_DIR /f"{spec['out_stem']}_sea_jour_{pk}.png")
        for k in range (4 ):
            save_lossless_png (terrain_nuit_layers_4 [k ],WEB_LAYERS_DIR /f"{spec['out_stem']}_terrain_nuit_{k}.png")
            save_lossless_png (terrain_jour_layers_4 [k ],WEB_LAYERS_DIR /f"{spec['out_stem']}_terrain_jour_{k}.png")
        save_lossless_png (canopy_nuit_im ,WEB_LAYERS_DIR /f"{spec['out_stem']}_canopy_nuit.png")
        save_lossless_png (canopy_jour_im ,WEB_LAYERS_DIR /f"{spec['out_stem']}_canopy_jour.png")

        # Composition exacte XNA BlendState.AlphaBlend (bit-exacte 0 erreur avec le simulateur moteur PMDO !)
        def compose_frame_xna (t_step :int ,is_night :bool =True )->Image .Image :
            sky_base =sky_nuit_merged if is_night else sky_jour 
            pal_key ='nuit'if is_night else 'jour'
            sea_im =sea_nuit_layers_8 [t_step %8 ]if is_night else sea_jour_layers_8 [t_step %8 ]
            ter_im =terrain_nuit_layers_4 [t_step %4 ]if is_night else terrain_jour_layers_4 [t_step %4 ]
            can_im =canopy_nuit_im if is_night else canopy_jour_im 

            dst =np .array (premult_rgba (sky_base ),dtype =np .uint8 )
            for tkey ,yoff ,spd in [
            ('horizon',spec ['cloud_horizon_y'],2 ),
            ('milieu',spec ['cloud_milieu_y'],4 ),
            ('haut',spec ['cloud_haut_y'],6 ),
            ]:
                c_im =render_clouds_band_on_canvas ((wp ,hp ),cloud_bands [pal_key ][tkey ],yoff ,t_step *spd )
                premult_over (dst ,np .array (premult_rgba (c_im ),dtype =np .uint8 ))
            premult_over (dst ,np .array (premult_rgba (sea_im ),dtype =np .uint8 ))
            premult_over (dst ,np .array (premult_rgba (ter_im ),dtype =np .uint8 ))
            premult_over (dst ,np .array (premult_rgba (can_im ),dtype =np .uint8 ))
            return Image .fromarray (dst ,'RGBA')

        frame_t0 =compose_frame_xna (0 ,is_night =True )
        save_lossless_png (day_orig_comp ,PNG_DIR /spec ['day_ref_png'])
        save_lossless_png (frame_t0 ,PNG_DIR /spec ['night_png'])

        gif_frames_16 =[compose_frame_xna (step ,is_night =True )for step in range (16 )]
        gif_out =ANIM_DIR /f"{spec['out_stem']}_mer_et_nuages.gif"
        save_animated_gif (gif_frames_16 ,gif_out ,duration_ms =166 )

        manifest_maps .append ({
        'id':spec ['out_stem'],
        'source_rsground':spec ['src_rsground'].name ,
        'title':spec ['display_title'],
        'width_tiles':w ,
        'height_tiles':h ,
        'width_px':wp ,
        'height_px':hp ,
        'horizon_y_px':spec ['horizon_y_px'],
        'cloud_haut_y':spec ['cloud_haut_y'],
        'cloud_milieu_y':spec ['cloud_milieu_y'],
        'cloud_horizon_y':spec ['cloud_horizon_y'],
        'sea_phases':8 ,
        'sea_frame_length_ticks_60hz':10 ,
        'sea_animated_tiles':sea_anim_cells ,
        'water_pond_waterfall_animated_tiles':water_anim_cells ,
        'obstacles_preserved_100pct':night_obj ['obstacles']==src_obj ['obstacles'],
        'entities_preserved_100pct':night_obj ['Entities']==src_obj ['Entities'],
        'rsground_file':f"MOD_CLIFF_NORD_NUIT_PMDO/Data/Ground/{spec['out_stem']}.rsground",
        'tile_file':f"MOD_CLIFF_NORD_NUIT_PMDO/Content/Tile/{spec['tile_bank_name']}.tile",
        'tile_stats':bank_stats ,
        'day_ref_png':f"png_1x/{spec['day_ref_png']}",
        'night_png':f"png_1x/{spec['night_png']}",
        'animated_gif_1x':f"animations_1x/{gif_out.name}",
        'layer_pngs':layer_png_relpaths ,
        })
        print (
        f"[OK] {spec['out_stem']}: {wp}x{hp}px ({w}x{h}t) | mer_8phases={sea_anim_cells} cases | "
        f"cascades/etang_4phases={water_anim_cells} cases | tiles={bank_stats['tile_count']} ({bank_stats['bytes']/1024:.1f} KiB) | "
        f"gif={gif_out.stat().st_size/1024:.1f} KiB"
        )

    write_tile_index_idx (MOD_DIR /'Content/Tile/index.idx',written_tile_paths )
    shutil .copyfile (PPMDO /'source/pmdo_cote/INSTALLER.py',MOD_DIR /'INSTALLER.py')

    manifest ={
    'pack_id':'CLIFF_NORD_NUIT_ANIME_PMDO_0812',
    'pmdo_version':'0.8.12',
    'ai_generated_pixels':0 ,
    'generation_method':(
    'Conversion déterministe Jour -> Nuit sans génération IA + animation native PMDO 0.8.12 '
    '(LayeredBG Content/BG/*.dir à 3 plans parallaxe RepeatX=True pour les nuages + TileLayer 8 phases '
    'FrameLength=10 pour la mer lunaire Chunsoft + 4 phases FrameLength=10 pour cascades, étangs et fleurs)'
    ),
    'art_approved':False ,
    'runtime_tested':False ,
    'metas':[
    'meta — Halcyon (Metano_Town_*, Metano_Town_*_Night, Altere_Pond_*)',
    'Chunsoft / meta — Pokémon Mystery Dungeon: Explorers of Time/Darkness/Sky (mer 8 phases & nuages)',
    'meromoonmeri — Assemblage original des cartes cliffdaytest.rsground & cliffnordouesttest1.rsground (town02 / projet-pmdo)',
    ],
    'bg_dir_sheets':dir_stats ,
    'maps':manifest_maps ,
    }
    (OUT_DIR /'manifest.json').write_text (json .dumps (manifest ,ensure_ascii =False ,indent =2 ),encoding ='utf-8')

    readme ="""# Pack PMDO 0.8.12 — `cliffdaytest_nuit` & `cliffnordouesttest1_nuit` (Nuages 3 Plans + Mer 8 Phases + Cascades Animés)

## Animations natives PMDO 0.8.12 configurées (zéro script Lua requis)
1. **Nuages nocturnes animés en défilement continu à 3 plans de parallaxe (`RogueEssence.Dungeon.LayeredBG` + `Content/BG/*.dir`)** :
   - **Plan d'horizon (`CLIFF_NUIT_NUAGES_HORIZON.dir`, `1440 × 64 px`)** : cumulus posés pile sur la ligne d'horizon marin (`RepeatX = true`, `BGMovement = (-5, 0)`).
   - **Plan médian (`CLIFF_NUIT_NUAGES_MILIEU.dir`, `1440 × 96 px`)** : cumulus de moyenne altitude (`RepeatX = true`, `BGMovement = (-9, 0)`).
   - **Plan haut (`CLIFF_NUIT_NUAGES_HAUT.dir`, `1440 × 96 px`)** : cumulus éclairés par la lune en haute altitude (`RepeatX = true`, `BGMovement = (-14, 0)`).
2. **Mer nocturne animée 8 phases (`TileLayer.Frames`, `FrameLength = 10` à 60 Hz = `166,67 ms/phase`, boucle `1,333 s`)** :
   - Cycle complet des **8 phases** Chunsoft (`0..7`) en bleu nuit profond continu du haut en bas + reflets d'écume lunaire argent-azur nettement visibles à `1×`.
3. **Cascades, étang et fleurs animés 4 phases (`FrameLength = 10`)** :
   - Étang, cours d'eau et fleurs animés sur `cliffdaytest_nuit.rsground`.
   - Grande cascade `64 × 80 px` (`80` tuiles) animée en 4 frames sur `cliffnordouesttest1_nuit.rsground`.

## Installation recommandée dans PMDO 0.8.12
```bash
python MOD_CLIFF_NORD_NUIT_PMDO/INSTALLER.py "CHEMIN/VERS/PMDO/MODS/votre_mod" --dry-run
python MOD_CLIFF_NORD_NUIT_PMDO/INSTALLER.py "CHEMIN/VERS/PMDO/MODS/votre_mod"
```

## metas & Statut
- **metas artistiques** : **meta** (`Halcyon`), **Chunsoft / meta** (PMD Explorers), **meromoonmeri** (`town02` / `projet-pmdo`).
- **Statuts de validation** : `art_approved: false`, `runtime_tested: false`.
"""
    (OUT_DIR /'README.md').write_text (readme ,encoding ='utf-8')

    zip_path =OUT_DIR /'PACK_CLIFF_NORD_NUIT_PMDO_0812.zip'
    if zip_path .exists ():
        zip_path .unlink ()
    with zipfile .ZipFile (zip_path ,'w',compression =zipfile .ZIP_DEFLATED ,compresslevel =9 )as zf :
        for f in sorted (OUT_DIR .rglob ('*')):
            if f .is_file ()and f !=zip_path and WEB_LAYERS_DIR not in f .parents :
                zf .write (f ,arcname =str (f .relative_to (OUT_DIR )))
    print (f'[ZIP] {zip_path.name} généré : {zip_path.stat().st_size / (1024 * 1024):.3f} MiB')


if __name__ =='__main__':
    main ()
