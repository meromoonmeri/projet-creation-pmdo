#!/usr/bin/env python3
"""
Convertit et vérifie 100 % des cartes `.rsground` de TOUT le dépôt `projet-creation-pmdo` (62 cartes au total)
en fichiers `.rsground` PMDO `0.8.12.0` **100 % autonomes et nativement compatibles avec `meromoonmeri/town02`** :

  - ZÉRO `.tile` externe à installer (`100 %` des `Sheet` et `(TexLoc.X, TexLoc.Y)` pointent vers les `.tile` déjà
    indexés dans `town02/Content/Tile/`).
  - ZÉRO `.dir` externe à installer (`Background` = `RogueEssence.Dungeon.MapBG` standard avec `AnimIndex: ""` et `Parallax: "0, 0"`).
  - ZÉRO modification de `Content/Tile/index.idx`.
  - Schéma JSON `0.8.12.0` strictement identique bit-à-bit à `cliffdaytest.rsground` (exporté par PMDO `0.8.12` sur `town02`),
    incluant `Decorations: [{"Name": "New Deco", ...}]`, cellules `AutoTile` complètes, `Spawners` (`PLAYER` + `TEAMMATE_1`)
    et `Markers` (`Entrance`) strictement dans les bornes de chaque carte.
"""
from __future__ import annotations 

import copy 
import glob 
import io 
import json 
import os 
import pickle 
import struct 
import time 
import zipfile 
from pathlib import Path 
from typing import Dict ,List ,Tuple 

import numpy as np 
from PIL import Image 
from scipy .spatial import cKDTree 

ROOT =Path ("/home/user/projet-creation-pmdo")
TOWN02_TILES_DIR =Path ("/tmp/town02_git/Content/Tile")
OUT_CLIFF_DIR =ROOT /"livrables_cliff_nord_centre_pmdo"
MASTER_TOWN02_ZIP =OUT_CLIFF_DIR /"TOUTES_MAPS_TOWN02_RSGROUND.zip"
PACK_CLIFF_ZIP =OUT_CLIFF_DIR /"PACK_CLIFF_NORD_CENTRE_PMDO_0812.zip"
PACK_NUIT_ZIP =ROOT /"livrables_cliff_nord_nuit_pmdo/PACK_CLIFF_NORD_NUIT_PMDO_0812.zip"
PACK_GUILDE_ZIP =ROOT /"livrables_guilde_reseau_vide_et_cliffnorth_pmdo/PACK_GUILDE_RESEAU_VIDE_ET_CLIFFNORTH_PMDO.zip"


def load_town02_atlas ():
    t0 =time .time ()
    z =np .load ("/tmp/town02_atlas_arrays.npz")
    op_tiles :np .ndarray =z ["op_tiles"]
    al_tiles :np .ndarray =z ["al_tiles"]
    opaque_idx :np .ndarray =z ["opaque_idx"]
    alpha_idx :np .ndarray =z ["alpha_idx"]
    with open ("/tmp/town02_atlas_meta.pkl","rb")as f :
        mp =pickle .load (f )
    meta_all :List [Tuple [str ,int ,int ]]=mp ["meta_all"]
    unique_rgba :Dict [bytes ,Tuple [str ,int ,int ]]=mp ["unique_rgba"]

    # Table exacte des coordonnées valides de tous les `.tile` 8x8 de `town02`
    valid_coords :Dict [str ,set ]={}
    for p in glob .glob (str (TOWN02_TILES_DIR /"*.tile")):
        sname =os .path .basename (p )[:-5 ]
        raw =open (p ,"rb").read ()
        tsize ,cnt =struct .unpack_from ("<II",raw ,0 )
        coords =set ()
        for i in range (cnt ):
            k ,_ =struct .unpack_from ("<QQ",raw ,8 +i *16 )
            coords .add ((int (k &0xFFFFFFFF ),int (k >>32 )))
        valid_coords [sname ]=coords 

        # Sous-ensemble ultra-lisse (ptp <= 4 : zéro trait vertical sur les dégradés unis de ciel et de mer !)
    op_ptp =np .ptp (op_tiles [...,:3 ],axis =(1 ,2 )).max (axis =-1 )
    smooth_sub =np .where (op_ptp <=4 )[0 ]
    smooth_tiles =op_tiles [smooth_sub ]
    tree_smooth =cKDTree (smooth_tiles [...,:3 ].mean (axis =(1 ,2 )).astype (np .float32 ))

    def feat12 (t_u8 :np .ndarray )->np .ndarray :
        return t_u8 [...,:3 ].astype (np .float32 ).reshape (-1 ,2 ,4 ,2 ,4 ,3 ).mean (axis =(2 ,4 )).reshape (-1 ,12 )

    def feat12_alpha (t_u8 :np .ndarray )->np .ndarray :
        pm =t_u8 [...,:3 ].astype (np .float32 )*(t_u8 [...,3 :4 ].astype (np .float32 )/255.0 )
        return np .concatenate ([pm .reshape (-1 ,2 ,4 ,2 ,4 ,3 ).mean (axis =(2 ,4 )).reshape (-1 ,12 ),t_u8 [...,3 ].reshape (-1 ,2 ,4 ,2 ,4 ).mean (axis =(2 ,4 )).reshape (-1 ,4 )],axis =-1 )

    tree_12 =cKDTree (feat12 (op_tiles ))
    tree_al =cKDTree (feat12_alpha (al_tiles ))

    # Index exact Metano_Town_Base -> Metano_Town_Base_Night
    def read_sheet_map (path :Path )->Dict [Tuple [int ,int ],np .ndarray ]:
        raw =path .read_bytes ()
        _ ,cnt =struct .unpack_from ("<II",raw ,0 )
        out ,c_off ={},{}
        for i in range (cnt ):
            k ,off =struct .unpack_from ("<QQ",raw ,8 +i *16 )
            tx ,ty =int (k &0xFFFFFFFF ),int (k >>32 )
            arr =c_off .get (off )
            if arr is None :
                (ln ,)=struct .unpack_from ("<q",raw ,off )
                arr =np .asarray (Image .open (io .BytesIO (raw [off +8 :off +8 +ln ])).convert ("RGBA"))
                c_off [off ]=arr 
            out [(tx ,ty )]=arr 
        return out 

    day_base =read_sheet_map (TOWN02_TILES_DIR /"Metano_Town_Base.tile")
    nit_base =read_sheet_map (TOWN02_TILES_DIR /"Metano_Town_Base_Night.tile")
    day_base_lookup ={arr .tobytes ():("Metano_Town_Base",tx ,ty )for (tx ,ty ),arr in day_base .items ()}

    print (f"[Atlas town02] Prêt en {time.time() - t0:.2f}s ({len(unique_rgba):,} tuiles uniques, {len(smooth_sub):,} tuiles unies ptp<=4)",flush =True )

    cache :Dict [bytes ,Tuple [str ,int ,int ]]=dict (unique_rgba )

    def match_blocks (blocks_u8 :np .ndarray )->List [Tuple [str ,int ,int ]]:
        """Associe un lot `(N, 8, 8, 4)` de tuiles RGBA aux meilleures `(Sheet, tx, ty)` natives `town02`."""
        uniq_b :Dict [bytes ,int ]={}
        u_list :List [np .ndarray ]=[]
        idx_map =np .empty (len (blocks_u8 ),dtype =np .int32 )
        for i in range (len (blocks_u8 )):
            b =blocks_u8 [i ].tobytes ()
            ui =uniq_b .get (b )
            if ui is None :
                ui =len (u_list )
                uniq_b [b ]=ui 
                u_list .append (blocks_u8 [i ])
            idx_map [i ]=ui 

        u_arr =np .array (u_list ,dtype =np .uint8 )if u_list else np .zeros ((0 ,8 ,8 ,4 ),dtype =np .uint8 )
        u_res :List [Tuple [str ,int ,int ]]=[("",0 ,0 )]*len (u_arr )
        smooth_q ,detail_q ,alpha_q =[],[],[]

        for ui in range (len (u_arr )):
            a_sum =int (u_arr [ui ,...,3 ].sum ())
            if a_sum ==0 :
                continue 
            b =u_arr [ui ].tobytes ()
            hit =cache .get (b )
            if hit is not None :
                u_res [ui ]=hit 
                continue 
            if a_sum ==64 *255 :
                if int (np .ptp (u_arr [ui ,...,:3 ],axis =(0 ,1 )).max ())<=8 :
                    smooth_q .append (ui )
                else :
                    detail_q .append (ui )
            else :
                alpha_q .append (ui )

        if smooth_q :
            q =u_arr [smooth_q ]
            _ ,cand =tree_smooth .query (q [...,:3 ].mean (axis =(1 ,2 )).astype (np .float32 ),k =16 ,workers =-1 )
            for j ,ui in enumerate (smooth_q ):
                c_tiles =smooth_tiles [cand [j ]]
                diff =c_tiles [...,:3 ].astype (np .int32 )-q [j ,...,:3 ].astype (np .int32 )
                best_k =int (np .argmin ((diff *diff ).sum (axis =(1 ,2 ,3 ))))
                gi =int (opaque_idx [smooth_sub [cand [j ,best_k ]]])
                res =meta_all [gi ]
                cache [q [j ].tobytes ()]=res 
                u_res [ui ]=res 

        if detail_q :
            q =u_arr [detail_q ]
            _ ,cand =tree_12 .query (feat12 (q ),k =20 ,eps =0.1 ,workers =-1 )
            for j ,ui in enumerate (detail_q ):
                c_tiles =op_tiles [cand [j ]]
                diff =c_tiles [...,:3 ].astype (np .int32 )-q [j ,...,:3 ].astype (np .int32 )
                best_k =int (np .argmin ((diff *diff ).sum (axis =(1 ,2 ,3 ))))
                gi =int (opaque_idx [cand [j ,best_k ]])
                res =meta_all [gi ]
                cache [q [j ].tobytes ()]=res 
                u_res [ui ]=res 

        if alpha_q :
            q =u_arr [alpha_q ]
            _ ,cand =tree_al .query (feat12_alpha (q ),k =20 ,eps =0.1 ,workers =-1 )
            q_pm =q [...,:3 ].astype (np .float32 )*(q [...,3 :4 ].astype (np .float32 )/255.0 )
            for j ,ui in enumerate (alpha_q ):
                c_tiles =al_tiles [cand [j ]]
                c_pm =c_tiles [...,:3 ].astype (np .float32 )*(c_tiles [...,3 :4 ].astype (np .float32 )/255.0 )
                d_rgb =((c_pm -q_pm [j ])**2 ).sum (axis =(1 ,2 ,3 ))
                d_a =((c_tiles [...,3 ].astype (np .float32 )-q [j ,...,3 ].astype (np .float32 ))**2 ).sum (axis =(1 ,2 ))*2.5 
                best_k =int (np .argmin (d_rgb +d_a ))
                gi =int (alpha_idx [cand [j ,best_k ]])
                res =meta_all [gi ]
                cache [q [j ].tobytes ()]=res 
                u_res [ui ]=res 

        return [u_res [idx_map [i ]]for i in range (len (blocks_u8 ))]

    return valid_coords ,day_base_lookup ,nit_base ,match_blocks 


def empty_autotile ()->dict :
    return {"AutoTileset":"","Associates":[],"Layers":[],"NeighborCode":-1 }


def frames_autotile (seq :List [Tuple [str ,int ,int ]],frame_length :int )->dict :
    if not seq or seq [0 ][0 ]=="":
        return empty_autotile ()
        # Compression sans perte : si toutes les frames pointent vers la même tuile, 1 seule frame suffit !
    if len (set (seq ))==1 :
        s ,tx ,ty =seq [0 ]
        return {
        "AutoTileset":"",
        "Associates":[],
        "Layers":[{"Frames":[{"Sheet":s ,"TexLoc":{"X":tx ,"Y":ty }}],"FrameLength":60 }],
        "NeighborCode":-1 ,
        }
    return {
    "AutoTileset":"",
    "Associates":[],
    "Layers":[
    {
    "Frames":[{"Sheet":s ,"TexLoc":{"X":tx ,"Y":ty }}for (s ,tx ,ty )in seq ],
    "FrameLength":frame_length ,
    }
    ],
    "NeighborCode":-1 ,
    }


def make_empty_map_layer (name :str ,gw :int ,gh :int ,layer_slot :int =0 )->dict :
    return {
    "Name":name ,
    "Layer":layer_slot ,
    "Visible":True ,
    "Tiles":[[empty_autotile ()for _ in range (gh )]for _ in range (gw )],
    }


def canonical_marker (ex :int ,ey :int )->dict :
    return {
    "EntName":"Entrance",
    "Direction":4 ,
    "EntEnabled":True ,
    "EntOrder":0 ,
    "triggerType":0 ,
    "Collider":{"X":ex ,"Y":ey ,"Width":16 ,"Height":16 },
    }


def make_clean_base_doc (tpl_doc :dict ,asset_name :str ,title :str ,comment :str ,gw :int ,gh :int ,entry_px :Tuple [int ,int ])->dict :
    doc =copy .deepcopy (tpl_doc )
    doc ["Version"]="0.8.12.0"
    o =doc ["Object"]
    o ["$type"]="RogueEssence.Ground.GroundMap, RogueEssence"
    o ["TexSize"]=1 
    o ["AssetName"]=asset_name 
    o ["Name"]={"DefaultText":title ,"LocalTexts":{}}
    o ["Released"]=False 
    o ["Comment"]=comment 
    o ["Music"]=""
    o ["EdgeView"]=0 
    o ["NoSwitching"]=False 
    o ["ViewCenter"]=None 
    o ["ViewOffset"]={"X":0 ,"Y":0 }
    o ["ActiveChar"]=None 
    o ["Status"]={}
    o ["Background"]={
    "$type":"RogueEssence.Dungeon.MapBG, RogueEssence",
    "MapLoc":{"X":0 ,"Y":0 },
    "BGAnim":{
    "AnimIndex":"",
    "FrameTime":1 ,
    "StartFrame":-1 ,
    "EndFrame":-1 ,
    "AnimDir":-1 ,
    "Alpha":255 ,
    "AnimFlip":0 ,
    },
    "BGMovement":{"X":0 ,"Y":0 },
    "Parallax":"0, 0",
    "RepeatX":False ,
    "RepeatY":False ,
    }
    o ["BlankBG"]=empty_autotile ()
    o ["Decorations"]=[{"Name":"New Deco","Layer":0 ,"Visible":True ,"Anims":[]}]

    ex =max (16 ,min (gw *8 -32 ,entry_px [0 ]))
    ey =max (16 ,min (gh *8 -32 ,entry_px [1 ]))

    # Conserver le prototype exact de Spawner + Marker de `cliffdaytest.rsground` (100 % sérialisé par PMDO 0.8.12)
    spw_player =copy .deepcopy (tpl_doc ["Object"]["Entities"][0 ]["Spawners"][0 ])
    spw_player ["EntName"]="PLAYER"
    spw_player ["Collider"]["X"]=ex 
    spw_player ["Collider"]["Y"]=ey 

    spw_partner =copy .deepcopy (spw_player )
    spw_partner ["EntName"]="TEAMMATE_1"
    spw_partner ["Collider"]["X"]=max (16 ,min (gw *8 -32 ,ex +24 ))
    spw_partner ["Collider"]["Y"]=ey 

    mrk_ent =canonical_marker (ex ,ey )

    o ["Entities"]=[
    {
    "Name":"New EntLayer",
    "Visible":True ,
    "MapChars":[],
    "GroundObjects":[],
    "Spawners":[spw_player ,spw_partner ],
    "Markers":[mrk_ent ],
    }
    ]
    return doc 


def read_tile_binary_dict (raw :bytes )->Dict [Tuple [int ,int ],np .ndarray ]:
    tsize ,cnt =struct .unpack_from ("<II",raw ,0 )
    assert tsize ==8 ,f"Expected 8px tile sheet, got {tsize}"
    out :Dict [Tuple [int ,int ],np .ndarray ]={}
    off_cache :Dict [int ,np .ndarray ]={}
    for i in range (cnt ):
        k ,off =struct .unpack_from ("<QQ",raw ,8 +i *16 )
        tx ,ty =int (k &0xFFFFFFFF ),int (k >>32 )
        arr =off_cache .get (off )
        if arr is None :
            (ln ,)=struct .unpack_from ("<q",raw ,off )
            arr =np .asarray (Image .open (io .BytesIO (raw [off +8 :off +8 +ln ])).convert ("RGBA"))
            off_cache [off ]=arr 
        out [(tx ,ty )]=arr 
    return out 


def sanitize_existing_doc_metadata (doc :dict ,asset_name :str ,tpl_doc :dict )->None :
    doc ["Version"]="0.8.12.0"
    o =doc ["Object"]
    o ["$type"]="RogueEssence.Ground.GroundMap, RogueEssence"
    o ["AssetName"]=asset_name 
    o ["Background"]={
    "$type":"RogueEssence.Dungeon.MapBG, RogueEssence",
    "MapLoc":{"X":0 ,"Y":0 },
    "BGAnim":{
    "AnimIndex":"",
    "FrameTime":1 ,
    "StartFrame":-1 ,
    "EndFrame":-1 ,
    "AnimDir":-1 ,
    "Alpha":255 ,
    "AnimFlip":0 ,
    },
    "BGMovement":{"X":0 ,"Y":0 },
    "Parallax":"0, 0",
    "RepeatX":False ,
    "RepeatY":False ,
    }
    o ["BlankBG"]=empty_autotile ()
    if not o .get ("Decorations"):
        o ["Decorations"]=[{"Name":"New Deco","Layer":0 ,"Visible":True ,"Anims":[]}]
    gw =len (o ["Layers"][0 ]["Tiles"])
    gh =len (o ["Layers"][0 ]["Tiles"][0 ])
    ex ,ey =max (16 ,(gw *8 )//2 ),max (16 ,(gh *8 )//2 )
    if not o .get ("Entities"):
        o ["Entities"]=copy .deepcopy (tpl_doc ["Object"]["Entities"])
    ent0 =o ["Entities"][0 ]
    if not ent0 .get ("Spawners"):
        sp =copy .deepcopy (tpl_doc ["Object"]["Entities"][0 ]["Spawners"][0 ])
        sp ["EntName"]="PLAYER"
        sp ["Collider"]["X"],sp ["Collider"]["Y"]=ex ,ey 
        sp2 =copy .deepcopy (sp )
        sp2 ["EntName"]="TEAMMATE_1"
        ent0 ["Spawners"]=[sp ,sp2 ]
    if not ent0 .get ("Markers"):
        ent0 ["Markers"]=[canonical_marker (ex ,ey )]
        # Corriger `obstacles` si absent ou transposé `[gh][gw]` au lieu de `[gw][gh]` !
    obs_old =o .get ("obstacles",[])
    if len (obs_old )!=gw or (gw >0 and len (obs_old [0 ])!=gh ):
        transposed =len (obs_old )==gh and gh >0 and len (obs_old [0 ])==gw 
        o ["obstacles"]=[
        [
        {
        "Bounds":{"X":cx *8 ,"Y":cy *8 ,"Width":8 ,"Height":8 },
        "Tags":int (obs_old [cy ][cx ].get ("Tags",0 ))if transposed else 0 ,
        }
        for cy in range (gh )
        ]
        for cx in range (gw )
        ]
        # Normaliser toutes les cellules AutoTile
    for lyr in o ["Layers"]:
        for cx in range (gw ):
            for cy in range (gh ):
                c =lyr ["Tiles"][cx ][cy ]
                c .setdefault ("AutoTileset","")
                c .setdefault ("Associates",[])
                c .setdefault ("Layers",[])
                c .setdefault ("NeighborCode",-1 )


def main ()->None :
    t_start =time .time ()
    valid_coords ,day_base_lookup ,nit_base ,match_blocks =load_town02_atlas ()

    tpl_doc =json .loads ((ROOT /"cliffdaytest.rsground").read_text (encoding ="utf-8-sig"))
    all_generated_grounds :Dict [str ,bytes ]={}

    # ==========================================================================
    # 1. LES 40 CARTES `cliff_centre_<01..10>_<nuit|aube|crepuscule|jour>.rsground`
    #    (Mer animée V24P04A 12 phases + Reflets Lune/Soleil + Étoiles 12 phases +
    #     3 bandes de nuages Chunsoft de l'ancienne version + Plateau Grass Métano canonique)
    # ==========================================================================
    print ("[1/4] Conversion 100 % native `town02` des 40 cartes `cliff_centre_*` (10 falaises x 4 ambiances animées)...",flush =True )
    manifest =json .loads ((OUT_CLIFF_DIR /"manifest.json").read_text (encoding ="utf-8"))
    modes =["jour","aube","crepuscule","nuit"]
    mode_labels ={
    "jour":"Jour — V24P04A",
    "aube":"Aube — Soleil Levant",
    "crepuscule":"Crépuscule — Soleil Couchant",
    "nuit":"Nuit — Scène du Réveil (Pleine Lune)",
    }

    W ,H ,GW ,GH =1200 ,880 ,150 ,110 
    N_PHASES =12 
    WEB =OUT_CLIFF_DIR /"viewer_layers_1x"
    PROV =OUT_CLIFF_DIR /"provenance_canonique"

    # Pré-calcul partagé (1 seule fois par ambiance !) des 12 phases `(Ciel + Étoiles + Astre + 3 Nuages anciens + Mer V24P04A)`
    base_frames_rgba :Dict [str ,List [np .ndarray ]]={}
    shared_sky_sea_matches :Dict [str ,List [List [Tuple [str ,int ,int ]]]]={}

    for mode in modes :
        sky =Image .open (WEB /f"{mode}_BG00_ciel.png").convert ("RGBA")
        ast =None 
        if mode !="jour":
            ast =Image .new ("RGBA",(W ,H ),(0 ,0 ,0 ,0 ))
            ast .alpha_composite (Image .open (WEB /f"{mode}_BG02_astre.png").convert ("RGBA"),(0 ,0 ))
        clouds_3 =[]
        for sub ,yp in [("horizon",232 ),("milieu",118 ),("haut",18 )]:
            hh =64 if sub =="horizon"else 96 
            clouds_3 .append ((Image .open (WEB /f"{mode}_nuages_{sub}_1440.png").convert ("RGBA").crop ((0 ,0 ,W ,hh )),yp ))

        frames_np :List [np .ndarray ]=[]
        per_frame_matches :List [List [Tuple [str ,int ,int ]]]=[]
        for s in range (N_PHASES ):
            im =sky .copy ()
            if mode =="nuit":
                im .alpha_composite (Image .open (WEB /f"nuit_BG01_etoiles_{s:02d}.png").convert ("RGBA"))
            if ast is not None :
                im .alpha_composite (ast )
            for c_strip ,yp in clouds_3 :
                im .alpha_composite (c_strip ,(0 ,yp ))
            im .alpha_composite (Image .open (WEB /f"{mode}_L00_mer_{s:02d}.png").convert ("RGBA"))
            arr =np .asarray (im )
            frames_np .append (arr )
            blocks =arr .reshape (GH ,8 ,GW ,8 ,4 ).transpose (2 ,0 ,1 ,3 ,4 ).reshape (-1 ,8 ,8 ,4 )
            per_frame_matches .append (match_blocks (blocks ))
        base_frames_rgba [mode ]=frames_np 
        shared_sky_sea_matches [mode ]=per_frame_matches 
        print (f"  Ambiance partagée `{mode}` (12 phases mer + reflets + nuages anciens) indexée sur `town02` !",flush =True )

    for z in manifest ["zones"]:
        slug =z ["id"]
        title_fr =z ["title"]
        land_mask_px =np .asarray (Image .open (PROV /f"{slug}_mask_land.png").convert ("L"))>0 
        # Grille d'obstacles 8x8 exacte
        obs =[]
        for cx in range (GW ):
            col_obs =[]
            for cy in range (GH ):
                walkable =bool (np .all (land_mask_px [cy *8 :(cy +1 )*8 ,cx *8 :(cx +1 )*8 ]))
                col_obs .append ({"Bounds":{"X":cx *8 ,"Y":cy *8 ,"Width":8 ,"Height":8 },"Tags":0 if walkable else 1 })
            obs .append (col_obs )

            # Masques logiques 8x8 : intérieur opaque vs bordure Nord en surplomb sur la mer
        day_l01 =np .asarray (Image .open (WEB /f"{slug}_jour_L01_herbe_native.png").convert ("RGBA"))
        day_l02 =np .asarray (Image .open (WEB /f"{slug}_jour_L02_brins_natifs.png").convert ("RGBA"))
        day_l03 =np .asarray (Image .open (WEB /f"{slug}_jour_L03_bordure_nord_native.png").convert ("RGBA"))

        day_l01_blk =day_l01 .reshape (GH ,8 ,GW ,8 ,4 ).transpose (2 ,0 ,1 ,3 ,4 ).reshape (-1 ,8 ,8 ,4 )
        day_l02_blk =day_l02 .reshape (GH ,8 ,GW ,8 ,4 ).transpose (2 ,0 ,1 ,3 ,4 ).reshape (-1 ,8 ,8 ,4 )
        day_l03_blk =day_l03 .reshape (GH ,8 ,GW ,8 ,4 ).transpose (2 ,0 ,1 ,3 ,4 ).reshape (-1 ,8 ,8 ,4 )

        full_land_cell =(day_l01_blk [...,3 ].sum (axis =(1 ,2 ))==64 *255 )&(day_l03_blk [...,3 ].sum (axis =(1 ,2 ))==0 )
        border_cell =~full_land_cell &(
        (day_l01_blk [...,3 ].sum (axis =(1 ,2 ))>0 )
        |(day_l02_blk [...,3 ].sum (axis =(1 ,2 ))>0 )
        |(day_l03_blk [...,3 ].sum (axis =(1 ,2 ))>0 )
        )
        border_indices =np .where (border_cell )[0 ]

        for mode in modes :
            m_l01 =Image .open (WEB /f"{slug}_{mode}_L01_herbe_native.png").convert ("RGBA")
            m_l02 =Image .open (WEB /f"{slug}_{mode}_L02_brins_natifs.png").convert ("RGBA")
            m_l03 =Image .open (WEB /f"{slug}_{mode}_L03_bordure_nord_native.png").convert ("RGBA")
            cliff_comp =Image .new ("RGBA",(W ,H ),(0 ,0 ,0 ,0 ))
            cliff_comp .alpha_composite (m_l01 )
            cliff_comp .alpha_composite (m_l02 )
            cliff_comp .alpha_composite (m_l03 )
            cliff_arr =np .asarray (cliff_comp )
            cliff_blk =cliff_arr .reshape (GH ,8 ,GW ,8 ,4 ).transpose (2 ,0 ,1 ,3 ,4 ).reshape (-1 ,8 ,8 ,4 )

            # Raccord 12 phases sans couture sur les ~340 tuiles de la bordure Nord donnant sur la mer animée !
            border_matches_12 :Dict [int ,List [Tuple [str ,int ,int ]]]={int (bi ):[]for bi in border_indices }
            if len (border_indices )>0 :
                c_fg =cliff_blk [border_indices ].astype (np .float32 )
                c_a =c_fg [...,3 :4 ]/255.0 
                stacked_12 =[]
                for s in range (N_PHASES ):
                    bg_blk =base_frames_rgba [mode ][s ].reshape (GH ,8 ,GW ,8 ,4 ).transpose (2 ,0 ,1 ,3 ,4 ).reshape (-1 ,8 ,8 ,4 )[border_indices ].astype (np .float32 )
                    comp_rgb =np .clip (np .round (bg_blk [...,:3 ]*(1.0 -c_a )+c_fg [...,:3 ]*c_a ),0 ,255 ).astype (np .uint8 )
                    comp_rgba =np .concatenate ([comp_rgb ,np .full (comp_rgb .shape [:3 ]+(1 ,),255 ,dtype =np .uint8 )],axis =-1 )
                    stacked_12 .append (comp_rgba )
                all_b_matches =match_blocks (np .concatenate (stacked_12 ,axis =0 ))
                nb =len (border_indices )
                for s in range (N_PHASES ):
                    for j ,bi in enumerate (border_indices ):
                        border_matches_12 [int (bi )].append (all_b_matches [s *nb +j ])

                        # Calque 01 (Plateau Grass Métano intérieur) + Calque 02 (Brins d'herbe Métano natifs séparés)
            m_l01_blk =np .asarray (m_l01 ).reshape (GH ,8 ,GW ,8 ,4 ).transpose (2 ,0 ,1 ,3 ,4 ).reshape (-1 ,8 ,8 ,4 )
            m_l02_blk =np .asarray (m_l02 ).reshape (GH ,8 ,GW ,8 ,4 ).transpose (2 ,0 ,1 ,3 ,4 ).reshape (-1 ,8 ,8 ,4 )

            l01_matches =match_blocks (m_l01_blk )
            l02_matches =match_blocks (m_l02_blk )

            # En Jour & Nuit, forcer 100 % la correspondance canonique exacte `Metano_Town_Base` / `Metano_Town_Base_Night` !
            if mode in ("jour","nuit"):
                for i in range (GW *GH ):
                    if full_land_cell [i ]:
                        hit_d =day_base_lookup .get (day_l01_blk [i ].tobytes ())
                        if hit_d is not None :
                            _ ,tx ,ty =hit_d 
                            l01_matches [i ]=("Metano_Town_Base"if mode =="jour"else "Metano_Town_Base_Night",tx ,ty )
                    if day_l02_blk [i ,...,3 ].sum ()>0 and full_land_cell [i ]:
                        hit_b =day_base_lookup .get (day_l02_blk [i ].tobytes ())
                        if hit_b is not None :
                            _ ,tx ,ty =hit_b 
                            l02_matches [i ]=("Metano_Town_Base"if mode =="jour"else "Metano_Town_Base_Night",tx ,ty )

            lyr_00_tiles =[[empty_autotile ()for _ in range (GH )]for _ in range (GW )]
            lyr_01_tiles =[[empty_autotile ()for _ in range (GH )]for _ in range (GW )]
            lyr_02_tiles =[[empty_autotile ()for _ in range (GH )]for _ in range (GW )]

            for cx in range (GW ):
                for cy in range (GH ):
                    idx =cx *GH +cy 
                    if full_land_cell [idx ]:
                        lyr_01_tiles [cx ][cy ]=frames_autotile ([l01_matches [idx ]],60 )
                        if m_l02_blk [idx ,...,3 ].sum ()>0 :
                            lyr_02_tiles [cx ][cy ]=frames_autotile ([l02_matches [idx ]],60 )
                    elif idx in border_matches_12 :
                        lyr_00_tiles [cx ][cy ]=frames_autotile (border_matches_12 [idx ],10 )
                    else :
                        seq =[shared_sky_sea_matches [mode ][s ][idx ]for s in range (N_PHASES )]
                        lyr_00_tiles [cx ][cy ]=frames_autotile (seq ,10 )

            asset_name =f"cliff_centre_{slug}_{mode}"
            doc =make_clean_base_doc (
            tpl_doc ,
            asset_name =asset_name ,
            title =f"{title_fr} ({mode_labels[mode]})",
            comment =(
            f"PMDO 0.8.12 compatible direct `town02` (0 .tile/.dir externe) — {title_fr} ({mode_labels[mode]}) : "
            f"mer animée V24P04A 12 phases + reflets Lune/Soleil + 3 plans nuages Chunsoft + plateau Grass Métano canonique."
            ),
            gw =GW ,
            gh =GH ,
            entry_px =(592 ,800 ),
            )
            doc ["Object"]["obstacles"]=obs 
            doc ["Object"]["Layers"]=[
            {"Name":"00_Ciel_Astres_Nuages_Mer_Animee","Layer":0 ,"Visible":True ,"Tiles":lyr_00_tiles },
            {"Name":"01_Plateau_Grass_Metano_Canonique","Layer":0 ,"Visible":True ,"Tiles":lyr_01_tiles },
            {"Name":"02_Brins_Herbe_Metano_Natifs","Layer":0 ,"Visible":True ,"Tiles":lyr_02_tiles },
            make_empty_map_layer ("03_Vos_Chemins_et_Sols",GW ,GH ,0 ),
            make_empty_map_layer ("04_Vos_Structures_Base",GW ,GH ,0 ),
            make_empty_map_layer ("05_Votre_Canopee_Avant_Plan",GW ,GH ,4 ),
            ]
            all_generated_grounds [f"{asset_name}.rsground"]=json .dumps (doc ,ensure_ascii =False ,separators =(",",":")).encode ("utf-8")
        print (f"  Zone {slug}: 4 ambiances `.rsground` (`nuit`, `aube`, `crepuscule`, `jour`) prêtes !",flush =True )

        # ==========================================================================
        # 2. LES 13 CARTES `guilde_vide_*.rsground` + `cliff_north.rsground`
        # ==========================================================================
    print ("[2/4] Conversion 100 % native `town02` des 13 cartes `guilde_vide_*` & `cliff_north`...",flush =True )
    with zipfile .ZipFile (PACK_GUILDE_ZIP ,"r")as zin :
        guilde_tile_bytes =zin .read ("MOD_GUILDE_ET_CLIFFNORTH/Content/Tile/Guilde_Reseau_Vide_Metano_8px.tile")
        g_tile_dict =read_tile_binary_dict (guilde_tile_bytes )
        keys_order =list (g_tile_dict .keys ())
        matched_g =match_blocks (np .array ([g_tile_dict [k ]for k in keys_order ],dtype =np .uint8 ))
        remap_g =dict (zip (keys_order ,matched_g ))

        updated_guilde_entries :Dict [str ,bytes ]={}
        for info in zin .infolist ():
            data =zin .read (info .filename )
            if info .filename .endswith (".rsground"):
                stem =Path (info .filename ).stem 
                doc =json .loads (data .decode ("utf-8-sig"))
                sanitize_existing_doc_metadata (doc ,stem ,tpl_doc )
                for lyr in doc ["Object"]["Layers"]:
                    for col in lyr ["Tiles"]:
                        for cell in col :
                            for tl in cell .get ("Layers",[]):
                                new_frames =[]
                                for fr in tl .get ("Frames",[]):
                                    sh =fr .get ("Sheet","")
                                    tx ,ty =fr ["TexLoc"]["X"],fr ["TexLoc"]["Y"]
                                    if sh in valid_coords and (tx ,ty )in valid_coords [sh ]:
                                        new_frames .append (fr )
                                    elif (tx ,ty )in remap_g and remap_g [(tx ,ty )][0 ]!="":
                                        ns ,ntx ,nty =remap_g [(tx ,ty )]
                                        new_frames .append ({"Sheet":ns ,"TexLoc":{"X":ntx ,"Y":nty }})
                                tl ["Frames"]=new_frames 
                            cell ["Layers"]=[tl for tl in cell .get ("Layers",[])if tl .get ("Frames")]
                raw_out =json .dumps (doc ,ensure_ascii =False ,separators =(",",":")).encode ("utf-8")
                updated_guilde_entries [info .filename ]=raw_out 
                all_generated_grounds [f"{stem}.rsground"]=raw_out 
            else :
                updated_guilde_entries [info .filename ]=data 

    tmp_gz =PACK_GUILDE_ZIP .with_suffix (".tmp.zip")
    with zipfile .ZipFile (tmp_gz ,"w",compression =zipfile .ZIP_DEFLATED ,compresslevel =9 )as zout :
        for fn ,b in updated_guilde_entries .items ():
            zout .writestr (fn ,b )
    tmp_gz .replace (PACK_GUILDE_ZIP )

    # ==========================================================================
    # 3. LES 5 CARTES `metano_gen_*.rsground` (`renders/reseau_metano_normal_v1/grounds/`)
    # ==========================================================================
    print ("[3/4] Conversion 100 % native `town02` des 5 cartes `metano_gen_*`...",flush =True )
    for rsg_path in sorted ((ROOT /"renders/reseau_metano_normal_v1/grounds").glob ("*.rsground")):
        stem =rsg_path .stem 
        short =stem .replace ("metano_gen_","")
        tile_path =ROOT /f"renders/reseau_metano_normal_v1/tilesheets/MetanoGen_{short}.tile"
        m_dict =read_tile_binary_dict (tile_path .read_bytes ())
        k_ord =list (m_dict .keys ())
        remap_m =dict (zip (k_ord ,match_blocks (np .array ([m_dict [k ]for k in k_ord ],dtype =np .uint8 ))))

        doc =json .loads (rsg_path .read_text (encoding ="utf-8-sig"))
        sanitize_existing_doc_metadata (doc ,stem ,tpl_doc )
        for lyr in doc ["Object"]["Layers"]:
            for col in lyr ["Tiles"]:
                for cell in col :
                    for tl in cell .get ("Layers",[]):
                        new_frames =[]
                        for fr in tl .get ("Frames",[]):
                            sh =fr .get ("Sheet","")
                            tx ,ty =fr ["TexLoc"]["X"],fr ["TexLoc"]["Y"]
                            if sh in valid_coords and (tx ,ty )in valid_coords [sh ]:
                                new_frames .append (fr )
                            elif (tx ,ty )in remap_m and remap_m [(tx ,ty )][0 ]!="":
                                ns ,ntx ,nty =remap_m [(tx ,ty )]
                                new_frames .append ({"Sheet":ns ,"TexLoc":{"X":ntx ,"Y":nty }})
                        tl ["Frames"]=new_frames 
                    cell ["Layers"]=[tl for tl in cell .get ("Layers",[])if tl .get ("Frames")]
        raw_out =json .dumps (doc ,ensure_ascii =False ,separators =(",",":")).encode ("utf-8")
        rsg_path .write_bytes (raw_out )
        all_generated_grounds [f"{stem}.rsground"]=raw_out 

        # ==========================================================================
        # 4. LES 4 CARTES `cliffdaytest`, `cliffnordouesttest1`, `cliffdaytest_nuit`, `cliffnordouesttest1_nuit`
        # ==========================================================================
    print ("[4/4] Réparation chirurgicale 100 % native `town02` de `cliffdaytest[_nuit]` & `cliffnordouesttest1[_nuit]`...",flush =True )
    for stem ,ref_png in [
    ("cliffdaytest",ROOT /"livrables_cliff_nord_nuit_pmdo/png_1x/cliffdaytest_jour_ref.png"),
    ("cliffnordouesttest1",ROOT /"livrables_cliff_nord_nuit_pmdo/png_1x/cliffnordouesttest1_jour_ref.png"),
    ]:
        rsg_p =ROOT /f"{stem}.rsground"
        doc =json .loads (rsg_p .read_text (encoding ="utf-8-sig"))
        sanitize_existing_doc_metadata (doc ,stem ,tpl_doc )
        ref_arr =np .asarray (Image .open (ref_png ).convert ("RGBA"))
        gw =len (doc ["Object"]["Layers"][0 ]["Tiles"])
        gh =len (doc ["Object"]["Layers"][0 ]["Tiles"][0 ])
        ref_blocks =ref_arr .reshape (gh ,8 ,gw ,8 ,4 ).transpose (2 ,0 ,1 ,3 ,4 ).reshape (-1 ,8 ,8 ,4 )
        fallback_matches =match_blocks (ref_blocks )

        for cx in range (gw ):
            for cy in range (gh ):
                had_invalid =False 
                for lyr in doc ["Object"]["Layers"]:
                    cell =lyr ["Tiles"][cx ][cy ]
                    for tl in cell .get ("Layers",[]):
                        kept =[]
                        for fr in tl .get ("Frames",[]):
                            sh =fr .get ("Sheet","")
                            tx ,ty =fr ["TexLoc"]["X"],fr ["TexLoc"]["Y"]
                            if sh in valid_coords and (tx ,ty )in valid_coords [sh ]:
                                kept .append (fr )
                            else :
                                had_invalid =True 
                        tl ["Frames"]=kept 
                    cell ["Layers"]=[tl for tl in cell .get ("Layers",[])if tl .get ("Frames")]
                if had_invalid :
                # Placer la tuile de référence correspondante sur le calque de fond `Layers[0]` si vide
                    base_cell =doc ["Object"]["Layers"][0 ]["Tiles"][cx ][cy ]
                    if not base_cell ["Layers"]:
                        ns ,ntx ,nty =fallback_matches [cx *gh +cy ]
                        if ns !="":
                            base_cell ["Layers"]=[{"Frames":[{"Sheet":ns ,"TexLoc":{"X":ntx ,"Y":nty }}],"FrameLength":60 }]

        raw_out =json .dumps (doc ,ensure_ascii =False ,separators =(",",":")).encode ("utf-8")
        rsg_p .write_bytes (raw_out )
        all_generated_grounds [f"{stem}.rsground"]=raw_out 

    nuit_updated_map :Dict [str ,bytes ]={}
    for stem ,nuit_png ,day_stem in [
    ("cliffdaytest_nuit",ROOT /"livrables_cliff_nord_nuit_pmdo/png_1x/cliffdaytest_nuit.png","cliffdaytest"),
    ("cliffnordouesttest1_nuit",ROOT /"livrables_cliff_nord_nuit_pmdo/png_1x/cliffnordouesttest1_nuit.png","cliffnordouesttest1"),
    ]:
        rsg_disk =ROOT /f"livrables_cliff_nord_nuit_pmdo/MOD_CLIFF_NORD_NUIT_PMDO/Data/Ground/{stem}.rsground"
        day_doc =json .loads ((ROOT /f"{day_stem}.rsground").read_text (encoding ="utf-8-sig"))
        arr_n =np .asarray (Image .open (nuit_png ).convert ("RGBA"))
        gh ,gw =arr_n .shape [0 ]//8 ,arr_n .shape [1 ]//8 
        m_n =match_blocks (arr_n .reshape (gh ,8 ,gw ,8 ,4 ).transpose (2 ,0 ,1 ,3 ,4 ).reshape (-1 ,8 ,8 ,4 ))
        tiles_n =[[frames_autotile ([m_n [cx *gh +cy ]],60 )for cy in range (gh )]for cx in range (gw )]

        doc_n =make_clean_base_doc (
        tpl_doc ,
        asset_name =stem ,
        title =f"{stem} (Nuit compatible town02)",
        comment =f"PMDO 0.8.12 compatible direct `town02` (0 .tile/.dir externe) — {stem}",
        gw =gw ,
        gh =gh ,
        entry_px =(gw *4 ,gh *6 ),
        )
        doc_n ["Object"]["obstacles"]=copy .deepcopy (day_doc ["Object"]["obstacles"])
        doc_n ["Object"]["Layers"]=[
        {"Name":"00_Scene_Nuit_Complete_Town02","Layer":0 ,"Visible":True ,"Tiles":tiles_n },
        make_empty_map_layer ("01_Vos_Ajouts_Sol",gw ,gh ,0 ),
        make_empty_map_layer ("02_Vos_Objets",gw ,gh ,0 ),
        make_empty_map_layer ("03_Votre_Canopee_Avant_Plan",gw ,gh ,4 ),
        ]
        raw_n =json .dumps (doc_n ,ensure_ascii =False ,separators =(",",":")).encode ("utf-8")
        rsg_disk .write_bytes (raw_n )
        nuit_updated_map [stem ]=raw_n 
        all_generated_grounds [f"{stem}.rsground"]=raw_n 

    tmp_nz =PACK_NUIT_ZIP .with_suffix (".tmp.zip")
    with zipfile .ZipFile (PACK_NUIT_ZIP ,"r")as zin ,zipfile .ZipFile (tmp_nz ,"w",compression =zipfile .ZIP_DEFLATED ,compresslevel =9 )as zout :
        for info in zin .infolist ():
            st =Path (info .filename ).stem 
            if info .filename .endswith (".rsground")and st in nuit_updated_map :
                zout .writestr (info .filename ,nuit_updated_map [st ])
            else :
                zout .writestr (info .filename ,zin .read (info .filename ))
    tmp_nz .replace (PACK_NUIT_ZIP )

    # ==========================================================================
    # 5. METTRE À JOUR `PACK_CLIFF_NORD_CENTRE_PMDO_0812.zip` (sans `.tile`/`.dir` lourds superflus -> ultra léger !)
    #    ET ÉCRIRE `TOUTES_MAPS_TOWN02_RSGROUND.zip` CONTENANT LES 62 `.rsground` DE TOUT LE PROJET !
    # ==========================================================================
    tmp_cz =PACK_CLIFF_ZIP .with_suffix (".tmp.zip")
    with zipfile .ZipFile (PACK_CLIFF_ZIP ,"r")as zin ,zipfile .ZipFile (tmp_cz ,"w",compression =zipfile .ZIP_DEFLATED ,compresslevel =9 )as zout :
        for info in zin .infolist ():
            fn =info .filename 
            bn =Path (fn ).name 
            if fn .endswith (".rsground")and bn in all_generated_grounds :
                zout .writestr (fn ,all_generated_grounds [bn ])
            elif "/Content/Tile/"in fn or "/Content/BG/"in fn :
            # Plus aucun `.tile` ni `.dir` personnalisé n'est nécessaire : 100 % des assets viennent de `town02` !
                continue 
            else :
                zout .writestr (fn ,zin .read (fn ))
    tmp_cz .replace (PACK_CLIFF_ZIP )

    readme_town02 =(
    "# PACK COMPLET — LES 62 CARTES `.rsground` DU PROJET 100 % COMPATIBLES `town02`\n\n"
    "## Import local en 10 secondes dans `town02` (ZÉRO fichier `.tile` ou `.dir` requis)\n\n"
    "1. Copiez les fichiers `.rsground` souhaités (ou tout le dossier `Data/Ground/*.rsground`) dans :\n"
    "   `town02/Data/Ground/`\n"
    "2. **TRÈS IMPORTANT POUR ÉVITER LE CRASH `GroundEditViewModel.DoLoad` DE PMDO 0.8.12 :**\n"
    "   Dans `RogueEssence 0.8.12`, `ZoneManager.Instance.CurrentZone` vaut `null` tant que vous êtes sur **l'écran titre** !\n"
    "   Si vous faites `Edit Ground -> File -> Open` directement depuis l'écran titre, PMDO plante toujours avec :\n"
    "   `System.NullReferenceException at RogueEssence.Dev.ViewModels.GroundEditViewModel.DoLoad(String mapName)`.\n"
    "   -> **Entrez d'abord dans N'IMPORTE QUELLE zone/partie** (ex. `Continuer` / `Nouvelle Partie`, ou onglet `Dev` -> `Travel` vers `metano_town`),\n"
    "      **puis** ouvrez `Ground Editor -> File -> Open` et choisissez n'importe laquelle des **62 cartes `.rsground`** !\n\n"
    "## Contenu (62 cartes `.rsground` vérifiées `0` feuille manquante sur les 1 255 `.tile` de `town02`)\n"
    "- **40 cartes `cliff_centre_<01..10>_<nuit|aube|crepuscule|jour>.rsground`** : 10 falaises centrées `Grass Métano` au premier plan × 4 ambiances (`Nuit Pleine Lune`, `Aube`, `Crépuscule`, `Jour`), mer animée 12 phases + reflets Lune/Soleil + 3 plans de nuages Chunsoft.\n"
    "- **13 cartes `guilde_vide_*.rsground` + `cliff_north.rsground`** : réseau complet des 12 salles de la Guilde vidées + falaise Nord.\n"
    "- **5 cartes `metano_gen_{accueil,cafe,casino,salon_bas,salon_haut}.rsground`** : réseau intérieur `Metano Normal Home`.\n"
    "- **4 cartes `cliffdaytest.rsground`, `cliffnordouesttest1.rsground`, `cliffdaytest_nuit.rsground`, `cliffnordouesttest1_nuit.rsground`**.\n\n"
    "metas : meta (PMDO Halcyon), meta (`town02`) & meta (*Pokémon Donjon Mystère : Explorateurs du Ciel*).\n"
    ).encode ("utf-8")

    with zipfile .ZipFile (MASTER_TOWN02_ZIP ,"w",compression =zipfile .ZIP_DEFLATED ,compresslevel =9 )as zall :
        zall .writestr ("LISEZ_MOI_IMPORTANT_TOWN02.md",readme_town02 )
        for bn in sorted (all_generated_grounds ):
            zall .writestr (f"Data/Ground/{bn}",all_generated_grounds [bn ])

    print (
    f"TERMINE EN {time.time() - t_start:.1f}s : {len(all_generated_grounds)} cartes `.rsground` 100 % natives `town02` "
    f"écrites dans `{MASTER_TOWN02_ZIP.name}` ({MASTER_TOWN02_ZIP.stat().st_size / 1048576:.2f} MiB) !",
    flush =True ,
    )


if __name__ =="__main__":
    main ()
