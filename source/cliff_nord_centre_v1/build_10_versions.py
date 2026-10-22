#!/usr/bin/env python3
"""Construit les 10 versions de Falaise Côtière au Premier Plan (`01` à `10`, Jour & Nuit = 20 `.rsground`)
COMME `cliffdaytest` MAIS CENTRÉES, PLATEAU 100 % NU, SANS PAROI ROCHEUSE, AVEC **100 % DE TEXTURES CANONIQUES MÉTANO** :
  - Falaise herbeuse **au premier plan** (`Grass Métano` occupant tout l'avant-plan Sud à l'arrivée du joueur)
  - **Zéro paroi rocheuse verticale** (`0` pixel de roche tombante) : **uniquement la bordure nordique canonique**
    (`Metano_Town_Cliffs.tile` lignes `18..34, 518..534` & `164..180, 456..472`) donnant directement sur la mer animée & le ciel
  - 3 calques de terrain canoniques séparés par carte (`generated_terrain_rgb_pixels == 0`) :
      * `01_Herbe_Metano_Native`       (`L01_herbe_native.png`)       : `Metano_Town_Base.tile` `(0, 640, 128, 768)`
      * `02_Brins_Metano_Natifs`       (`L02_brins_natifs.png`)       : `Metano_Town_Base.tile` `(16, 776, 32, 792)` & `(48, 792, 64, 808)`
      * `03_Bordure_Nord_Metano_Native`(`L03_bordure_nord_native.png`): `Metano_Town_Cliffs.tile` lèvre de crête côtière native
  - Filtre Nuit exact `Abyss V4` (`source/cote_v4_abyss/night.py`), prouvé 100 % bit-identique aux 3 planches `Metano_Town_*_Night.tile`
  - Contrôle mathématique indépendant `verify_canonique.py` (`60 / 60` calques reconstruits bit-à-bit, `0` pixel généré).
"""
from __future__ import annotations 

import copy 
import hashlib 
import io 
import json 
import shutil 
import sys 
import uuid 
import zipfile 
from pathlib import Path 
from typing import Callable ,Dict ,List ,Tuple 

import numpy as np 
from PIL import Image 
from scipy .spatial import cKDTree 

ROOT =Path ("/home/user/projet-creation-pmdo")
ABYSS_DIR =ROOT /"source/cote_v4_abyss"
NATIFS_V4 =ABYSS_DIR /"natifs"
INSTALLER_SRC =ROOT /"source/pmdo_cote/INSTALLER.py"

OUT_DIR =ROOT /"livrables_cliff_nord_centre_pmdo"
WEB_DIR =OUT_DIR /"viewer_layers_1x"
PNG_DIR =OUT_DIR /"png_1x"
ANIM_DIR =OUT_DIR /"animations_1x"
PROV_DIR =OUT_DIR /"provenance_canonique"
STAGE_DIR =Path ("/tmp/stage_10_cliffs_premier_plan_pmdo")

sys .path .insert (0 ,str (ABYSS_DIR ))
from sample import decode as decode_abyss 
from night import night as abyss_night 
import tile_night_reference as abyss_ref 

sys .path .insert (0 ,str (ROOT /"source/cliff_nord_centre_v1"))
from build import (
W ,
H ,
GW ,
GH ,
HORIZON_Y ,
CompactTileBank ,
build_ocean_8phases ,
build_sky_and_clouds ,
encode_layer_from_frames ,
load_template_ground ,
make_empty_layer ,
make_map_bg ,
make_obstacles_grid ,
render_scene_frame ,
write_dir_sheet ,
write_tile_index_idx ,
)

PLANE_SPECS :List [Tuple [str ,str ]]=[
("01_Herbe_Metano_Native","L01_herbe_native.png"),
("02_Brins_Metano_Natifs","L02_brins_natifs.png"),
("03_Bordure_Nord_Metano_Native","L03_bordure_nord_native.png"),
]
PLANE_FILES =[pf for _ ,pf in PLANE_SPECS ]

MODULES :Dict [str ,Tuple [str ,Tuple [int ,int ,int ,int ]]]={
"herbe":("Base",(0 ,640 ,128 ,768 )),
"brin1":("Base",(16 ,776 ,32 ,792 )),
"brin2":("Base",(48 ,792 ,64 ,808 )),
"bordure_nord_a":("Cliffs",(518 ,18 ,534 ,34 )),
"bordure_nord_b":("Cliffs",(456 ,164 ,472 ,180 )),
}


def curve_01 (xs :np .ndarray )->np .ndarray :
    u =(xs -W /2.0 )/(W /2.0 )
    return (
    366.0 
    +322.0 *(np .abs (u )**2.15 )
    +10.5 *np .sin (xs *0.017 +0.6 )
    +6.0 *np .sin (xs *0.043 +1.9 )
    +2.4 *np .cos (xs *0.088 +0.4 )
    )


def curve_02 (xs :np .ndarray )->np .ndarray :
    u =(xs -W /2.0 )/(W /2.0 )
    return (
    344.0 
    +406.0 *(np .abs (u )**1.48 )
    +9.5 *np .sin (xs *0.021 +1.4 )
    +5.2 *np .cos (xs *0.051 +0.7 )
    +2.2 *np .sin (xs *0.095 +2.1 )
    )


def curve_03 (xs :np .ndarray )->np .ndarray :
    u =(xs -W /2.0 )/(W /2.0 )
    return (
    370.0 
    +278.0 *(np .abs (u )**3.65 )
    +7.5 *np .sin (xs *0.014 +2.2 )
    +5.0 *np .sin (xs *0.039 +0.5 )
    +2.2 *np .cos (xs *0.083 +1.1 )
    )


def curve_04 (xs :np .ndarray )->np .ndarray :
    u =(xs -W /2.0 )/(W /2.0 )
    cove =74.0 *np .exp (-((u /0.24 )**2 ))
    return (
    362.0 
    +cove 
    +338.0 *(np .abs (u )**2.55 )
    +8.0 *np .sin (xs *0.019 +0.9 )
    +4.5 *np .cos (xs *0.049 +2.4 )
    )


def curve_05 (xs :np .ndarray )->np .ndarray :
    u =(xs -W /2.0 )/(W /2.0 )
    dome =-148.0 *np .exp (-((u /0.46 )**4 ))
    return (
    508.0 
    +dome 
    +272.0 *(np .abs (u )**2.10 )
    +8.5 *np .sin (xs *0.018 +2.7 )
    +4.8 *np .sin (xs *0.047 +1.3 )
    )


def curve_06 (xs :np .ndarray )->np .ndarray :
    u =(xs -W /2.0 )/(W /2.0 )
    return (
    382.0 
    +146.0 *(u **2 )
    +11.5 *np .sin (xs *0.015 +0.3 )
    +5.5 *np .cos (xs *0.041 +1.8 )
    +2.3 *np .sin (xs *0.086 +0.9 )
    )


def curve_07 (xs :np .ndarray )->np .ndarray :
    u =(xs -515.0 )/620.0 
    asym =np .where (xs <515.0 ,365.0 *(np .abs (u )**1.95 ),315.0 *(np .abs (u )**2.35 ))
    shelf =-28.0 *np .exp (-(((xs -845.0 )/145.0 )**2 ))
    return (
    360.0 
    +asym 
    +shelf 
    +9.5 *np .sin (xs *0.018 +1.1 )
    +5.0 *np .cos (xs *0.046 +2.6 )
    )


def curve_08 (xs :np .ndarray )->np .ndarray :
    u =(xs -685.0 )/620.0 
    asym =np .where (xs >685.0 ,365.0 *(np .abs (u )**1.95 ),315.0 *(np .abs (u )**2.35 ))
    shelf =-28.0 *np .exp (-(((xs -355.0 )/145.0 )**2 ))
    return (
    360.0 
    +asym 
    +shelf 
    +9.5 *np .sin (xs *0.017 +2.3 )
    +5.0 *np .cos (xs *0.045 +0.8 )
    )


def curve_09 (xs :np .ndarray )->np .ndarray :
    a =np .abs (xs -W /2.0 )
    t1 =112.0 /(1.0 +np .exp (-(a -165.0 )/26.0 ))
    t2 =128.0 /(1.0 +np .exp (-(a -335.0 )/30.0 ))
    t3 =132.0 /(1.0 +np .exp (-(a -495.0 )/34.0 ))
    return (
    356.0 
    +t1 
    +t2 
    +t3 
    +6.5 *np .sin (xs *0.020 +0.5 )
    +3.6 *np .cos (xs *0.052 +1.7 )
    )


def curve_10 (xs :np .ndarray )->np .ndarray :
    u =(xs -W /2.0 )/(W /2.0 )
    head =-245.0 *np .exp (-((np .abs (u )/0.34 )**2.6 ))
    return (
    652.0 
    +head 
    +138.0 *(u **2 )
    +8.5 *np .sin (xs *0.019 +1.6 )
    +4.5 *np .cos (xs *0.048 +0.3 )
    )


ZONES :List [Tuple [str ,str ,str ,Callable [[np .ndarray ],np .ndarray ]]]=[
(
"01_grand_cap_panoramique",
"01 — Le Grand Cap Panoramique (cliffdaytest Centré)",
"Falaise herbeuse au premier plan style cliffdaytest centré — zéro roche, bordure Nord canonique Métano",
curve_01 ,
),
(
"02_eperon_nord_effile",
"02 — La Pointe du Belvédère Nord",
"Large prairie au premier plan s’avançant en pointe centrale vers l’horizon marin — 100 % canonique Métano",
curve_02 ,
),
(
"03_double_terrasse_centrale",
"03 — La Grande Esplanade Village",
"Vaste plateau de premier plan à large corniche Nord pour village ou guilde — zéro roche, 100 % canonique",
curve_03 ,
),
(
"04_grande_esplanade_royale",
"04 — Le Double Belvédère à Anse Centrale",
"Deux avancées herbeuses symétriques encadrant une anse marine centrale — premier plan nu 100 % canonique",
curve_04 ,
),
(
"05_cap_anse_jumelle",
"05 — Le Promontoire en Dôme au Premier Plan",
"Cap arrondi central prolongeant la pelouse de premier plan face au grand large — zéro roche",
curve_05 ,
),
(
"06_presquile_isthme_etroit",
"06 — La Haute Corniche Panoramique Plein Nord",
"Grande crête côtière traversante d’Ouest en Est surplombant toute la mer animée — 100 % canonique Métano",
curve_06 ,
),
(
"07_cap_asymetrique_ouest",
"07 — Le Cap Brise d’Ouest",
"Courbe côtière asymétrique au premier plan culminant au Nord-Ouest avec épaulement doux à l’Est",
curve_07 ,
),
(
"08_cap_asymetrique_est",
"08 — Le Cap du Levant",
"Prairie côtière de premier plan montant vers un belvédère central-est face au croissant de lune",
curve_08 ,
),
(
"09_trois_paliers_sacres",
"09 — Le Promontoire à Triple Épaulement",
"Silhouette côtière à trois redans latéraux symétriques convergeant vers le sommet Nord — zéro roche",
curve_09 ,
),
(
"10_bastion_circulaire",
"10 — Le Belvédère Intime face à l’Océan",
"Avancée centrale épurée au premier plan ouvrant un immense panorama marin Nord-Ouest / Nord-Est",
curve_10 ,
),
]


def save_png_lossless (im :Image .Image ,path :Path )->None :
    path .parent .mkdir (parents =True ,exist_ok =True )
    rgba =im .convert ("RGBA")
    arr =np .asarray (rgba )
    uniq ,inv =np .unique (arr .reshape (-1 ,4 ),axis =0 ,return_inverse =True )
    if len (uniq )<=256 :
        pal =np .zeros ((256 ,3 ),dtype =np .uint8 )
        pal [:len (uniq )]=uniq [:,:3 ]
        p_im =Image .fromarray (inv .reshape (arr .shape [:2 ]).astype (np .uint8 ),mode ="P")
        p_im .putpalette (pal .ravel ().tolist ())
        p_im .save (path ,format ="PNG",transparency =uniq [:,3 ].astype (np .uint8 ).tobytes (),optimize =True ,compress_level =9 )
        assert np .array_equal (np .asarray (Image .open (path ).convert ("RGBA")),arr )
    else :
        rgba .save (path ,format ="PNG",optimize =True ,compress_level =9 )


def build_canonical_rim_lut (cliffs :np .ndarray )->np .ndarray :
    """Extrait telle quelle la table canonique `(32, 8, 4)` des lèvres de crête sans paroi rocheuse
    directement depuis `Metano_Town_Cliffs.tile` `(518..534, 18..34)` et `(456..472, 164..180)`."""
    clean_rows =np .concatenate ([cliffs [18 :34 ,518 :534 ],cliffs [164 :180 ,456 :472 ]],axis =0 )
    rim_lut =np .zeros ((32 ,8 ,4 ),dtype =np .uint8 )
    for s in range (32 ):
        xf =int (np .flatnonzero (clean_rows [s ,:,3 ]==255 )[0 ])
        for d in range (min (7 ,16 -xf )):
            px =clean_rows [s ,xf +d ]
            r ,g ,b ,a =int (px [0 ]),int (px [1 ]),int (px [2 ]),int (px [3 ])
            if a ==255 and not (g -r >=10 and g -b >=110 ):
                rim_lut [s ,d ]=px 
    return rim_lut 


def build_foreground_overlook_zone (
curve_fn :Callable [[np .ndarray ],np .ndarray ],
seed :int ,
sheets :Dict [str ,np .ndarray ],
rim_lut :np .ndarray ,
)->Tuple [List [np .ndarray ],np .ndarray ,np .ndarray ,np .ndarray ,List [dict ]]:
    """Construit les 3 calques natifs d'une falaise herbeuse au premier plan style `cliffdaytest` :
      - `L01_herbe_native`        : `Metano_Town_Base.tile` `(0, 640, 128, 768)` sur tout `land`
      - `L02_brins_natifs`        : `Metano_Town_Base.tile` `(16, 776, 32, 792)` / `(48, 792, 64, 808)` sur grille `8 px`
      - `L03_bordure_nord_native` : `Metano_Town_Cliffs.tile` lèvre de crête côtière `(s_idx, d_idx)` sans aucune roche !
    """
    xs_dense =np .linspace (-24.0 ,W +24.0 ,4800 )
    ys_dense =curve_fn (xs_dense )
    arc_dense =np .concatenate ([[0.0 ],np .cumsum (np .hypot (np .diff (xs_dense ),np .diff (ys_dense )))])
    tree =cKDTree (np .column_stack ([xs_dense ,ys_dense ]))

    yy ,xx =np .mgrid [:H ,:W ]
    y_at_x =np .interp (np .arange (W ,dtype =np .float64 ),xs_dense ,ys_dense )
    inside =yy >=y_at_x [None ,:]

    band =np .abs (yy -y_at_x [None ,:])<=26.0 
    dists ,idxs =tree .query (np .column_stack ([xx [band ],yy [band ]]),workers =-1 )
    signed_band =np .where (inside [band ],dists ,-dists )
    s_vals =arc_dense [idxs ]+seed *5.0 
    eff_d =signed_band +0.45 *np .sin (s_vals *(2.0 *np .pi /23.0 ))

    land =inside .copy ()
    land [band ]=eff_d >=0.0 

    placements :List [dict ]=[]

    # Calque 0 : Plateau 100 % nu `Grass Métano` au premier plan (`Metano_Town_Base` 128x128 sur grille 8 px)
    l01 =np .zeros ((H ,W ,4 ),dtype =np .uint8 )
    base_tile =sheets ["Base"][640 :768 ,0 :128 ]
    for y in range (0 ,H ,128 ):
        for x in range (0 ,W ,128 ):
            r_ ,b_ =min (W ,x +128 ),min (H ,y +128 )
            sel =land [y :b_ ,x :r_ ]
            if sel .any ():
                l01 [y :b_ ,x :r_ ][sel ]=base_tile [:b_ -y ,:r_ -x ][sel ]
                placements .append ({"layer":0 ,"module":"herbe","dest":[x ,y ]})

                # Calque 1 : Brins d'herbe canoniques `Metano_Town_Base` sur grille 8 px (désactivables dans PMDO & Viewer)
    l02 =np .zeros ((H ,W ,4 ),dtype =np .uint8 )
    rng =np .random .default_rng (900 +seed )
    for _ in range (56 ):
        tx =int (rng .integers (2 ,W //8 -4 ))*8 
        ty =int (rng .integers (46 ,H //8 -3 ))*8 
        if land [max (0 ,ty -14 ):min (H ,ty +28 ),max (0 ,tx -14 ):min (W ,tx +28 )].all ():
            mod ="brin1"if rng .random ()<0.55 else "brin2"
            _ ,(sx ,sy ,ex ,ey )=MODULES [mod ]
            src =sheets ["Base"][sy :ey ,sx :ex ]
            sel =src [:,:,3 ]==255 
            l02 [ty :ty +16 ,tx :tx +16 ][sel ]=src [sel ]
            placements .append ({"layer":1 ,"module":mod ,"dest":[tx ,ty ]})

            # Calque 2 : Bordure Nord canonique `Metano_Town_Cliffs` (zéro paroi rocheuse, crête pure donnant sur la mer !)
    l03 =np .zeros ((H ,W ,4 ),dtype =np .uint8 )
    s_grid =np .zeros ((H ,W ),dtype =np .uint8 )
    d_grid =np .full ((H ,W ),255 ,dtype =np .uint8 )

    by ,bx =np .nonzero (band )
    in_b =eff_d >=0.0 
    d_int =np .floor (eff_d [in_b ]).astype (np .int32 )
    s_int =(np .floor (s_vals [in_b ]).astype (np .int32 ))%32 
    valid =(d_int >=0 )&(d_int <8 )
    cand =rim_lut [s_int [valid ],d_int [valid ]]
    keep =cand [:,3 ]==255 
    vy =by [in_b ][valid ][keep ]
    vx =bx [in_b ][valid ][keep ]
    l03 [vy ,vx ]=cand [keep ]
    s_grid [vy ,vx ]=s_int [valid ][keep ].astype (np .uint8 )
    d_grid [vy ,vx ]=d_int [valid ][keep ].astype (np .uint8 )

    return [l01 ,l02 ,l03 ],land ,s_grid ,d_grid ,placements 


def main ()->None :
    print ("1/5 Décodage et audit SHA/Nuit exact des 3 planches canoniques Halcyon Métano...",flush =True )
    sheets ={name :decode_abyss (NATIFS_V4 /f"Metano_Town_{name}.tile")for name in ("Base","Cliffs","Fringe")}
    colors =np .unique (np .concatenate ([v .reshape (-1 ,4 )for v in sheets .values ()]),axis =0 )
    swatch =Image .fromarray (colors .reshape (1 ,-1 ,4 ))
    buf =io .BytesIO ()
    swatch .save (buf ,format ="PNG")
    assert abyss_night (swatch ).tobytes ()==Image .open (io .BytesIO (abyss_ref .to_night (buf .getvalue ()))).convert ("RGBA").tobytes ()
    for name ,day in sheets .items ():
        actual_n =decode_abyss (NATIFS_V4 /f"Metano_Town_{name}_Night.tile")
        assert np .array_equal (np .array (abyss_night (Image .fromarray (day ))),actual_n ),name 

    canonical_rgb_set =set (map (tuple ,colors [colors [:,3 ]==255 ][:,:3 ]))
    rim_lut =build_canonical_rim_lut (sheets ["Cliffs"])
    tpl_doc =load_template_ground ()

    for d in (OUT_DIR ,WEB_DIR ,PNG_DIR ,ANIM_DIR ,PROV_DIR ,STAGE_DIR ):
        if d .exists ():
            shutil .rmtree (d )
        d .mkdir (parents =True ,exist_ok =True )

    mod_root =STAGE_DIR /"MOD_CLIFF_NORD_CENTRE_PMDO"
    bg_dir =mod_root /"Content/BG"
    tile_dir =mod_root /"Content/Tile"
    ground_dir =mod_root /"Data/Ground"
    for d in (bg_dir ,tile_dir ,ground_dir ):
        d .mkdir (parents =True ,exist_ok =True )

    print ("2/5 Construction Ciel Jour/Nuit + Astres + 3 plans de Nuages RepeatX + Mer 8 phases...",flush =True )
    skies ,astres_nuit ,clouds =build_sky_and_clouds ()
    ocean =build_ocean_8phases ()

    write_dir_sheet (bg_dir /"CLIFF_CENTRE_JOUR_CIEL.dir",skies ["jour"])
    write_dir_sheet (bg_dir /"CLIFF_CENTRE_NUIT_CIEL.dir",skies ["nuit"])
    write_dir_sheet (bg_dir /"CLIFF_CENTRE_NUIT_ASTRES.dir",astres_nuit )
    save_png_lossless (skies ["jour"],WEB_DIR /"jour_BG00_ciel.png")
    save_png_lossless (skies ["nuit"],WEB_DIR /"nuit_BG00_ciel.png")
    save_png_lossless (astres_nuit ,WEB_DIR /"nuit_BG01_astres.png")

    for mode in ("jour","nuit"):
        for tkey in ("horizon","milieu","haut"):
            dname =f"CLIFF_CENTRE_{mode.upper()}_NUAGES_{tkey.upper()}"
            write_dir_sheet (bg_dir /f"{dname}.dir",clouds [mode ][tkey ])
            save_png_lossless (clouds [mode ][tkey ],WEB_DIR /f"{mode}_nuages_{tkey}_1440.png")
        for k in range (8 ):
            save_png_lossless (ocean [mode ][k ],WEB_DIR /f"{mode}_L00_mer_{k:02d}.png")

    banks ={
    "jour":CompactTileBank ("CliffCentre10_Canon_Jour"),
    "nuit":CompactTileBank ("CliffCentre10_Canon_Nuit"),
    }
    shared_sea_layers ={
    mode :encode_layer_from_frames ("00_Mer_Animee_8Phases",0 ,ocean [mode ],banks [mode ],frame_length =10 )
    for mode in ("jour","nuit")
    }
    bg_layers_by_mode ={}
    for mode in ("jour","nuit"):
        bgs =[make_map_bg (f"CLIFF_CENTRE_{mode.upper()}_CIEL",y_offset =0 ,move_x =0 ,repeat_x =False )]
        if mode =="nuit":
            bgs .append (make_map_bg ("CLIFF_CENTRE_NUIT_ASTRES",y_offset =0 ,move_x =0 ,repeat_x =False ))
        for tkey ,yoff ,spd in [("horizon",HORIZON_Y -64 ,-3 ),("milieu",118 ,-5 ),("haut",18 ,-8 )]:
            bgs .append (make_map_bg (f"CLIFF_CENTRE_{mode.upper()}_NUAGES_{tkey.upper()}",y_offset =yoff ,move_x =spd ,repeat_x =True ))
        bg_layers_by_mode [mode ]=bgs 

    print ("3/5 Construction des 10 falaises au premier plan sans roche (3 calques canoniques x Jour/Nuit = 20 .rsground)...",flush =True )
    manifest_zones =[]

    for idx ,(slug ,title_fr ,subtitle_fr ,curve_fn )in enumerate (ZONES ,start =1 ):
        arrays_d ,land ,s_grid ,d_grid ,placements =build_foreground_overlook_zone (curve_fn ,idx ,sheets ,rim_lut )

        merged_d =Image .new ("RGBA",(W ,H ),(0 ,0 ,0 ,0 ))
        plane_ims :Dict [str ,List [Image .Image ]]={"jour":[],"nuit":[]}

        for arr_d ,(_lname ,pf )in zip (arrays_d ,PLANE_SPECS ):
            opaque_rgb =set (map (tuple ,arr_d [arr_d [...,3 ]==255 ][:,:3 ]))
            assert opaque_rgb <=canonical_rgb_set ,f"Non-canonical RGB in {slug}/{pf}: {opaque_rgb - canonical_rgb_set}"
            im_d =Image .fromarray (arr_d ,"RGBA")
            im_n =abyss_night (im_d )
            save_png_lossless (im_d ,WEB_DIR /f"{slug}_jour_{pf}")
            save_png_lossless (im_n ,WEB_DIR /f"{slug}_nuit_{pf}")
            plane_ims ["jour"].append (im_d )
            plane_ims ["nuit"].append (im_n )
            merged_d =Image .alpha_composite (merged_d ,im_d )

        assert np .array_equal (np .asarray (merged_d )[...,3 ]>0 ,land )
        terrain_sha =hashlib .sha256 (merged_d .tobytes ()).hexdigest ()

        Image .fromarray (land .astype (np .uint8 )*255 ,"L").save (PROV_DIR /f"{slug}_mask_land.png",optimize =True )
        Image .fromarray (s_grid ,"L").save (PROV_DIR /f"{slug}_rim_s.png",optimize =True )
        Image .fromarray (d_grid ,"L").save (PROV_DIR /f"{slug}_rim_d.png",optimize =True )
        (PROV_DIR /f"{slug}_placements.json").write_text (json .dumps (placements ,separators =(",",":")),encoding ="utf-8")

        obstacles =make_obstacles_grid (land )
        for mode in ("jour","nuit"):
            ast =astres_nuit if mode =="nuit"else None 
            asset_name =f"cliff_centre_{slug}_{mode}"
            layers_list =[copy .deepcopy (shared_sea_layers [mode ])]
            for p_idx ,(lname ,_pf )in enumerate (PLANE_SPECS ):
                layers_list .append (encode_layer_from_frames (lname ,0 ,[plane_ims [mode ][p_idx ]],banks [mode ]))
            layers_list .extend (
            [
            make_empty_layer ("04_Vos_Chemins_et_Sols",0 ),
            make_empty_layer ("05_Vos_Structures_Base",0 ),
            make_empty_layer ("06_Votre_Canopee_Avant_Plan",4 ),
            ]
            )

            doc =copy .deepcopy (tpl_doc )
            doc ["Version"]="0.8.12.0"
            obj =doc ["Object"]
            obj ["AssetName"]=asset_name 
            obj ["Name"]["DefaultText"]=f"{title_fr} ({mode.capitalize()})"
            obj ["Comment"]=(
            f"PMDO 0.8.12 — {title_fr} ({mode}) : falaise au premier plan style cliffdaytest sans roche, "
            f"100 % textures canoniques Halcyon Metano_Town_Base/Cliffs (generated_rgb_pixels=0) + Nuit Abyss V4 exacte."
            )
            obj ["Background"]={
            "$type":"RogueEssence.Dungeon.LayeredBG, RogueEssence",
            "Layers":copy .deepcopy (bg_layers_by_mode [mode ]),
            }
            obj ["Layers"]=layers_list 
            obj ["obstacles"]=obstacles 
            obj ["Decorations"]=[]
            if obj .get ("Entities")and obj ["Entities"][0 ].get ("Markers"):
                obj ["Entities"][0 ]["Markers"]=[obj ["Entities"][0 ]["Markers"][0 ]]
                obj ["Entities"][0 ]["Markers"][0 ]["Name"]="Entrance_Sud"
                obj ["Entities"][0 ]["Markers"][0 ]["Loc"]={"X":592 ,"Y":816 }
                obj ["Entities"][0 ]["Markers"][0 ]["Dir"]=4 

            out_rsg =ground_dir /f"{asset_name}.rsground"
            out_rsg .write_bytes (json .dumps (doc ,ensure_ascii =False ,separators =(",",":")).encode ("utf-8"))

            for ns_dir in (
            mod_root /f"Data/Script/ground/{asset_name}",
            mod_root /f"Data/Script/cliff_nord_centre_pmdo/ground/{asset_name}",
            ):
                ns_dir .mkdir (parents =True ,exist_ok =True )
                (ns_dir /"init.lua").write_text (
                f"-- {asset_name} : falaise au premier plan 100 % canonique Métano + animations PMDO 0.8.12\n"
                f"local {asset_name} = {{}}\nfunction {asset_name}.Init(map)\n  COMMON.RespawnAllies()\nend\n"
                f"return {asset_name}\n",
                encoding ="utf-8",
                )

            full_im =render_scene_frame (
            skies [mode ],
            ast ,
            clouds [mode ],
            ocean [mode ],
            plane_ims [mode ],
            None ,
            None ,
            frame_idx =0 ,
            total_frames =16 ,
            )
            save_png_lossless (full_im ,PNG_DIR /f"{asset_name}.png")

        manifest_zones .append (
        {
        "num":idx ,
        "id":slug ,
        "title":title_fr ,
        "subtitle":subtitle_fr ,
        "size_px":[W ,H ],
        "grid_tiles":[GW ,GH ],
        "foreground_overlook":True ,
        "vertical_rock_face_pixels":0 ,
        "generated_terrain_rgb_pixels":0 ,
        "native_module_placements":len (placements ),
        "terrain_sha256":terrain_sha ,
        "rsground_jour":f"Data/Ground/cliff_centre_{slug}_jour.rsground",
        "rsground_nuit":f"Data/Ground/cliff_centre_{slug}_nuit.rsground",
        "png_jour":f"png_1x/cliff_centre_{slug}_jour.png",
        "png_nuit":f"png_1x/cliff_centre_{slug}_nuit.png",
        "layers_jour":[f"viewer_layers_1x/{slug}_jour_{pf}"for pf in PLANE_FILES ],
        "layers_nuit":[f"viewer_layers_1x/{slug}_nuit_{pf}"for pf in PLANE_FILES ],
        }
        )
        print (f"  [{idx:02d}/10] PASS PREMIER PLAN SANS ROCHE {slug} ({len(placements)} tampons, 0 px roche, 0 px généré)",flush =True )

    print ("4/5 Écriture des banques `.tile` canoniques ultra-compactes, `index.idx`, `Mod.xml` & `INSTALLER.py`...",flush =True )
    tile_stats ,tile_paths =[],[]
    for mode in ("jour","nuit"):
        tp =tile_dir /f"{banks[mode].sheet_name}.tile"
        tile_stats .append (banks [mode ].write (tp ))
        tile_paths .append (tp )
    write_tile_index_idx (tile_dir /"index.idx",tile_paths )

    ident =uuid .uuid5 (uuid .NAMESPACE_URL ,"https://github.com/meromoonmeri/projet-creation-pmdo/cliff_nord_centre_10_premier_plan_canoniques")
    (mod_root /"Mod.xml").write_text (
    f"""<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>10 Falaises Premier Plan Sans Roche - Textures Canoniques Metano (0.8.12)</Name>
  <Author>meromoonmeri</Author>
  <Description>10 falaises cotieres centrees au premier plan style cliffdaytest a plateau nu Grass Metano sans paroi rocheuse (uniquement la bordure Nord canonique donnant sur la mer 8 phases et le ciel Jour/Nuit).</Description>
  <Namespace>cliff_nord_centre_pmdo</Namespace>
  <UUID>{ident}</UUID>
  <Version>4.0.0.0</Version>
  <GameVersion>0.8.12.0</GameVersion>
  <ModType>Quest</ModType>
  <Relationships />
</Header>
""",
    encoding ="utf-8",
    )

    inst_txt =INSTALLER_SRC .read_text (encoding ="utf-8")
    needle ="            relative = src.relative_to(source)\n"
    if needle in inst_txt :
        inst_txt =inst_txt .replace (
        needle ,
        needle +"            if relative.as_posix() == 'Content/Tile/index.idx':\n                continue\n",
        )
    (mod_root /"INSTALLER.py").write_text (inst_txt ,encoding ="utf-8")

    for mode in ("jour","nuit"):
        ast =astres_nuit if mode =="nuit"else None 
        p_ims =[Image .open (WEB_DIR /f"01_grand_cap_panoramique_{mode}_{pf}").convert ("RGBA")for pf in PLANE_FILES ]
        gframes =[]
        for fi in range (8 ):
            fr =render_scene_frame (skies [mode ],ast ,clouds [mode ],ocean [mode ],p_ims ,None ,None ,fi ,total_frames =8 )
            gframes .append (fr .convert ("RGB").quantize (colors =256 ,method =Image .Quantize .MEDIANCUT ))
        gframes [0 ].save (
        ANIM_DIR /f"cliff_nord_centre_{mode}_anime.gif",
        save_all =True ,
        append_images =gframes [1 :],
        duration =166 ,
        loop =0 ,
        optimize =True ,
        )

    manifest ={
    "title":"Pack 10 Falaises Nord Centrées au Premier Plan (Style cliffdaytest Sans Roche) — 100 % Textures Canoniques Métano Jour & Nuit (PMDO 0.8.12)",
    "pmdo_version":"0.8.12.0",
    "zones_count":10 ,
    "maps_rsground_count":20 ,
    "dimensions_px":[W ,H ],
    "grid_tiles_8px":[GW ,GH ],
    "foreground_cliff_overlook":True ,
    "vertical_rock_face_pixels":0 ,
    "generated_terrain_rgb_pixels":0 ,
    "canonical_metano_modules":MODULES ,
    "night_filter":"Exact Abyss V4 tools/tile_night.py (blob 438383f4), bit-identical to Metano_Town_{Base,Cliffs,Fringe}_Night.tile",
    "entire_base_cliffs_fringe_night_sheets_equal":True ,
    "sea_phases":8 ,
    "cloud_planes":3 ,
    "terrain_planes":PLANE_FILES ,
    "art_approved":False ,
    "runtime_tested":False ,
    "metas":[
    "meta & contributeurs (PMDO Halcyon — Metano_Town_Base.tile, Metano_Town_Cliffs.tile)",
    "meta (filtre nocturne exact Metano_Town_*_Night.tile)",
    "meta (Pokémon Mystery Dungeon: Explorers of Time / Darkness / Sky)",
    ],
    "tile_banks":tile_stats ,
    "zones":manifest_zones ,
    }
    (OUT_DIR /"manifest.json").write_text (json .dumps (manifest ,ensure_ascii =False ,indent =2 ),encoding ="utf-8")

    (OUT_DIR /"README.md").write_text (
    """# Pack 10 Falaises Nord Centrées au Premier Plan (Style `cliffdaytest` Sans Roche) — 100 % Textures Canoniques Métano (PMDO 0.8.12)

## Architecture demandée : Falaise au Premier Plan (`cliffdaytest` centré) · Zéro Paroi Rocheuse · 100 % Textures Canoniques
- **Falaise au premier plan à l’arrivée (`Entrance_Sud`)** : dans les 10 versions (`01` à `10`), le plateau herbeux nu **`Grass Métano`** occupe tout l’avant-plan Sud et s’avance vers le centre-Nord surplombant le paysage marin et céleste.
- **Aucune paroi rocheuse verticale (`vertical_rock_face_pixels = 0`)** : on ne voit **que la fine bordure nordique canonique** (`Metano_Town_Cliffs.tile` `(518..534, 18..34)` & `(456..472, 164..180)`) donnant directement sur la mer animée Chunsoft (8 phases) et le ciel Jour/Nuit à 3 plans de nuages `RepeatX`.
- **3 calques de terrain canoniques séparés (`generated_terrain_rgb_pixels == 0`)** :
  1. `01_Herbe_Metano_Native` (`L01_herbe_native.png`) — `Metano_Town_Base.tile` `(0,640,128,768)`
  2. `02_Brins_Metano_Natifs` (`L02_brins_natifs.png`) — `Metano_Town_Base.tile` `(16,776,32,792)` & `(48,792,64,808)`
  3. `03_Bordure_Nord_Metano_Native` (`L03_bordure_nord_native.png`) — `Metano_Town_Cliffs.tile` lèvre de crête côtière native
- **Audit mathématique indépendant** : `python3 source/cliff_nord_centre_v1/verify_canonique.py` reconstruit bit-à-bit les `60` calques (`30 Jour` + `30 Nuit`) depuis les planches officielles certifiées SHA-256.

## metas & Statut
- **meta** & contributeurs (*PMDO Halcyon*), **meta**, **meta**.
- Statut : `art_approved: false`, `runtime_tested: false`.
""",
    encoding ="utf-8",
    )

    print ("5/5 Création de l'archive `PACK_CLIFF_NORD_CENTRE_PMDO_0812.zip`...",flush =True )
    zip_path =OUT_DIR /"PACK_CLIFF_NORD_CENTRE_PMDO_0812.zip"
    with zipfile .ZipFile (zip_path ,"w",compression =zipfile .ZIP_DEFLATED ,compresslevel =9 )as zf :
        for p in sorted (STAGE_DIR .rglob ("*")):
            if p .is_file ():
                zf .write (p ,p .relative_to (STAGE_DIR ).as_posix ())
        zf .write (OUT_DIR /"README.md","README.md")
        zf .write (OUT_DIR /"manifest.json","manifest.json")
        for p in sorted (PROV_DIR .glob ("*")):
            zf .write (p ,f"provenance_canonique/{p.name}")

    print (
    f"SUCCÈS PREMIER PLAN CANONIQUE : {zip_path} ({zip_path.stat().st_size / 1048576:.2f} MiB) | stats={tile_stats}",
    flush =True ,
    )


if __name__ =="__main__":
    main ()
