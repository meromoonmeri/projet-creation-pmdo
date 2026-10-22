"""Construction complète — Lot V2 : Grandes Structures Treehouses Monumentales de Guilde (PMDO 8px + HD RGBA).

- Zéro motif Spinda : 100 % architecture sylvestre de Guilde d'Exploration (POV PMD ~55° top-down).
- 7 grandes structures multi-étages (3 à 4 niveaux lisibles : racines, escaliers hélicoïdaux, chalets perchés,
  ponts suspendus, galeries, belvédères de cime) + 2 annexes organiques de village = 9 structures complètes.
- Feuillage ciselé grappe par grappe (6 valeurs étagées d'ombres profondes jusqu'aux pointes ensoleillées).
- 100 % sans fond véritable (`alpha ∈ {0, 255}`, `0 px` de halo/frange magenta sur 100 % des PNG exportés).
- Banques natives `.tile` (`GT2A`..`GT2I`) + descripteurs Tiled `.tsj` + variantes Jour/Nuit + calques Under/Over.
- Galerie autonome `apercu_treehouses_guilde_monumentales_v2.html` utilisant exclusivement de vraies balises `<img>`
  RGBA (`0` `<canvas>`, `0` damier peint) sur fond neutre chaud `#3a3028`.
"""
from __future__ import annotations 

import base64 
import hashlib 
import io 
import json 
import math 
import struct 
import zipfile 
from pathlib import Path 
from typing import Any 

import numpy as np 
from PIL import Image 
from scipy import ndimage as nd 

HERE =Path (__file__ ).resolve ().parent 
R =HERE .parents [1 ]
BRUTS =HERE /'bruts'
REFS =HERE /'references'
OUT_DIR =R /'livrables_treehouses_guilde_pmdo'
OUT_1X =OUT_DIR /'1x_PMDO_8px_sans_fond'
OUT_HD =OUT_DIR /'HD_sans_fond'
OUT_MOD_TILE =OUT_DIR /'Mod_PMDO_Tile_Pret_A_Importer'/'Content'/'Tile'
OUT_SPRITES =R /'sprites'/'guilde_treehouses_pmdo_v2'
OUT_HTML =R /'apercu_treehouses_guilde_monumentales_v2.html'

NN =Image .Resampling .NEAREST 

# (slug, pfx, title, category, floors_count, raw_relpath, comp_rank_1based, target_pmdo_max_wh, split_ratio_y)
STRUCTURES_SPEC =[
(
'01_citadelle_qg_guilde',
'GT2A',
'Grande Citadelle-Arbre QG de la Guilde (4 Étages & Passerelle)',
'Citadelle QG Monumentale',
4 ,
'grand_01c_citadelle_qg_monumentale.png',
1 ,
(368 ,368 ),
0.74 ,
),
(
'02_manoir_branches_pont_suspendu',
'GT2B',
'Grand Manoir Sylvestre — Double Fourche, Chalets Perchés & Pont Suspendu',
'Manoir Panoramique Multi-Branches',
3 ,
'grand_03_manoir_branches_dortoirs_3_etages.png',
1 ,
(448 ,248 ),
0.72 ,
),
(
'03_grand_chene_auberge_terrasses',
'GT2C',
'Grand Chêne-Auberge — Salle du Banquet & Terrasses à Pergola',
'Grand Chêne Réfectoire & Terrasses',
3 ,
'grand_04_auberge_refectoire_3_etages.png',
1 ,
(336 ,352 ),
0.75 ,
),
(
'04_sanctuaire_archives_poulie',
'GT2D',
'Arbre-Sanctuaire des Archives, Rosace Ambrée & Atelier à Poulie',
'Sanctuaire Bibliothèque & Grue',
3 ,
'grand_05b_sanctuaire_archives_3_etages.png',
1 ,
(272 ,312 ),
0.74 ,
),
(
'05_tour_observatoire_spirale',
'GT2E',
'Grande Tour-Observatoire — Escalier Hélicoïdal & Vigie de Cime',
'Tour de Vigie & Cartographie',
4 ,
'grand_02_tour_observatoire_3_etages.png',
1 ,
(216 ,328 ),
0.76 ,
),
(
'06_beffroi_guet_lanternes',
'GT2F',
'Beffroi de Guet des Éclaireurs — Galeries Superposées & Lanternes',
'Beffroi Sylvestre 4 Niveaux',
4 ,
'grand_02_tour_observatoire_3_etages.png',
2 ,
(176 ,328 ),
0.76 ,
),
(
'07_tour_phare_cime_doree',
'GT2G',
'Tour-Phare Sylvestre — Cime Ensoleillée, Balcons & Lanterne Phare',
'Tour-Phare d’Orientation',
4 ,
'grand_02_tour_observatoire_3_etages.png',
3 ,
(192 ,328 ),
0.76 ,
),
(
'08_hutte_souche_herboristerie',
'GT2H',
'Hutte-Souche d’Herboristerie & Infirmerie Sylvestre',
'Annexe Organique de Guilde',
2 ,
'ecartes/raw_08e_hutte_souche_herboristerie.png',
1 ,
(160 ,176 ),
0.68 ,
),
(
'09_hutte_racines_atelier_treuil',
'GT2I',
'Hutte-Racines d’Atelier, Coffres & Treuil de Guilde',
'Annexe Artisanale de Guilde',
2 ,
'ecartes/raw_08f_hutte_racines_atelier.png',
1 ,
(160 ,176 ),
0.68 ,
),
]


def clean_magenta_and_despill (raw_rgb :np .ndarray ,comp_rank :int =1 )->Image .Image :
    """Extrait la composante `comp_rank` avec alpha binaire {0, 255} et 0 px de frange magenta."""
    r =raw_rgb [:,:,0 ].astype (np .int32 )
    g =raw_rgb [:,:,1 ].astype (np .int32 )
    b =raw_rgb [:,:,2 ].astype (np .int32 )

    # 1. Masque du fond magenta pur + anti-aliasing rose/violet vers #FF00FF
    is_mag =(
    ((r >165 )&(b >165 )&(g <95 )&((r -g )>95 )&((b -g )>95 ))
    |((r >120 )&(b >120 )&((r -g )>52 )&((b -g )>52 )&(b >r *0.78 ))
    )
    fg =~is_mag 

    # Sélection de la composante connexe principale (ou rang demandé)
    lbl ,n =nd .label (fg ,structure =np .ones ((3 ,3 ),dtype =int ))
    sizes =sorted ([(int ((lbl ==i ).sum ()),i )for i in range (1 ,n +1 )],reverse =True )
    if comp_rank >len (sizes ):
        raise ValueError (f'Composante #{comp_rank} introuvable (total={len(sizes)})')
    main_idx =sizes [comp_rank -1 ][1 ]
    keep =lbl ==main_idx 

    # Recadrage serré autour de la composante
    ys ,xs =np .where (keep )
    x0 ,y0 ,x1 ,y1 =int (xs .min ()),int (ys .min ()),int (xs .max ())+1 ,int (ys .max ())+1 
    crop_rgb =raw_rgb [y0 :y1 ,x0 :x1 ].copy ()
    mask =keep [y0 :y1 ,x0 :x1 ].copy ()

    # Suppression d'une éventuelle frange résiduelle en bordure immédiate de transparence
    for _ in range (2 ):
        border_to_bg =mask &nd .binary_dilation (~mask ,iterations =1 )
        cr =crop_rgb [:,:,0 ].astype (np .int32 )
        cg =crop_rgb [:,:,1 ].astype (np .int32 )
        cb =crop_rgb [:,:,2 ].astype (np .int32 )
        fringe =border_to_bg &(cr >cg +22 )&(cb >cg +22 )&(cb >55 )
        if not np .any (fringe ):
            break 
        mask [fringe ]=False 

        # Nettoyage des micro-poussières détachées après érosion des franges
    lbl2 ,n2 =nd .label (mask ,structure =np .ones ((3 ,3 ),dtype =int ))
    if n2 >1 :
        counts2 =np .bincount (lbl2 .ravel ())
        valid2 =counts2 >=36 
        valid2 [0 ]=False 
        mask =valid2 [lbl2 ]

        # Dé-contamination chromatique intégrale : aucun pixel opaque ne peut conserver (R > G+16 et B > G+16 et B > 60)
    cr =crop_rgb [:,:,0 ].astype (np .int32 )
    cg =crop_rgb [:,:,1 ].astype (np .int32 )
    cb =crop_rgb [:,:,2 ].astype (np .int32 )
    spill =mask &(cr >cg +16 )&(cb >cg +16 )&(cb >60 )
    donor_pool =mask &~spill 
    if np .any (spill )and np .any (donor_pool ):
        _ ,indices =nd .distance_transform_edt (~donor_pool ,return_indices =True )
        crop_rgb [spill ]=crop_rgb [indices [0 ][spill ],indices [1 ][spill ]]

        # Recadrage final exact + quantification sans tramage 256 couleurs (PNG 4× plus léger, 100% net)
    ys2 ,xs2 =np .where (mask )
    fx0 ,fy0 ,fx1 ,fy1 =int (xs2 .min ()),int (ys2 .min ()),int (xs2 .max ())+1 ,int (ys2 .max ())+1 
    sub_mask =mask [fy0 :fy1 ,fx0 :fx1 ]
    q_hd =np .array (
    Image .fromarray (crop_rgb [fy0 :fy1 ,fx0 :fx1 ],'RGB').quantize (
    colors =256 ,method =Image .Quantize .FASTOCTREE ,dither =Image .Dither .NONE 
    ).convert ('RGB')
    )
    qr ,qg ,qb =q_hd [:,:,0 ].astype (np .int32 ),q_hd [:,:,1 ].astype (np .int32 ),q_hd [:,:,2 ].astype (np .int32 )
    sp2 =sub_mask &(qr >qg +16 )&(qb >qg +16 )&(qb >60 )
    dn2 =sub_mask &~sp2 
    if np .any (sp2 )and np .any (dn2 ):
        _ ,idx2 =nd .distance_transform_edt (~dn2 ,return_indices =True )
        q_hd [sp2 ]=q_hd [idx2 [0 ][sp2 ],idx2 [1 ][sp2 ]]
    out =np .zeros ((fy1 -fy0 ,fx1 -fx0 ,4 ),dtype =np .uint8 )
    out [sub_mask ,:3 ]=q_hd [sub_mask ]
    out [sub_mask ,3 ]=255 
    return Image .fromarray (out ,'RGBA')


def assert_zero_magenta_fringe (im :Image .Image ,label_name :str )->None :
    arr =np .array (im )
    alpha =arr [:,:,3 ]
    unique_a =set (np .unique (alpha ).tolist ())
    if not unique_a .issubset ({0 ,255 }):
        raise AssertionError (f'{label_name}: alpha non binaire détecté: {sorted(unique_a)[:10]}')
    opaque =alpha ==255 
    r =arr [:,:,0 ].astype (np .int32 )
    g =arr [:,:,1 ].astype (np .int32 )
    b =arr [:,:,2 ].astype (np .int32 )
    bad =opaque &(r >g +18 )&(b >g +18 )&(b >65 )
    if np .any (bad ):
        raise AssertionError (f'{label_name}: {int(bad.sum())} pixels magenta/pourpres résiduels!')


def make_night_glowing (im :Image .Image )->Image .Image :
    """Ambiance nocturne PMD bleutée tout en illuminant chaleureusement les fenêtres & lanternes dorées."""
    arr =np .array (im ).copy ()
    opaque =arr [:,:,3 ]==255 
    r =arr [:,:,0 ].astype (np .float32 )
    g =arr [:,:,1 ].astype (np .float32 )
    b =arr [:,:,2 ].astype (np .float32 )

    # Détection des vitres & lanternes chaudes (ambre / or lumineux)
    is_warm_lamp =opaque &(r >188 )&(g >125 )&(b <145 )&((r -b )>62 )
    warm_halo =nd .binary_dilation (is_warm_lamp ,iterations =2 )&opaque &~is_warm_lamp 

    # Base nocturne clair de lune sylvestre (bleu-ardoise / cyan doux PMD, jamais violacé)
    nr_c =np .clip (r *0.42 +6.0 ,0 ,255 )
    ng_c =np .clip (g *0.58 +16.0 ,0 ,255 )
    nb_c =np .clip (b *0.78 +26.0 ,0 ,255 )

    # Halo chaud sur les boiseries adjacentes aux fenêtres/lanternes (ambre pur : R > G >= B)
    nr_c [warm_halo ]=np .clip (r [warm_halo ]*0.82 +28.0 ,0 ,255 )
    ng_c [warm_halo ]=np .clip (g [warm_halo ]*0.72 +16.0 ,0 ,255 )
    nb_c [warm_halo ]=np .minimum (ng_c [warm_halo ],np .clip (b [warm_halo ]*0.50 +8.0 ,0 ,255 ))

    # Sur les surfaces refroidies par la lune (hors lampes/halos), jamais de dérive pourpre (R <= G + 12)
    cool_mask =opaque &~(is_warm_lamp |warm_halo )
    nr_c [cool_mask ]=np .minimum (nr_c [cool_mask ],ng_c [cool_mask ]+12.0 )

    # Fenêtres et lanternes allumées à pleine lueur ambrée
    nr_c [is_warm_lamp ]=np .clip (r [is_warm_lamp ]*1.06 +14.0 ,0 ,255 )
    ng_c [is_warm_lamp ]=np .clip (g [is_warm_lamp ]*1.02 +8.0 ,0 ,255 )
    nb_c [is_warm_lamp ]=np .clip (b [is_warm_lamp ]*0.88 +6.0 ,0 ,255 )

    out =np .zeros_like (arr )
    out [opaque ,0 ]=nr_c [opaque ].astype (np .uint8 )
    out [opaque ,1 ]=ng_c [opaque ].astype (np .uint8 )
    out [opaque ,2 ]=nb_c [opaque ].astype (np .uint8 )
    out [opaque ,3 ]=255 
    return Image .fromarray (out ,'RGBA')


def downsample_pmdo_grid (hd_im :Image .Image ,max_wh :tuple [int ,int ])->Image .Image :
    """Réduit sans flou à l'échelle pixel-art cible, quantifie en 128 couleurs franches et cadre sur grille 8×8."""
    scale =min (max_wh [0 ]/hd_im .width ,max_wh [1 ]/hd_im .height )
    sw =max (8 ,round (hd_im .width *scale ))
    sh =max (8 ,round (hd_im .height *scale ))
    resized =hd_im .resize ((sw ,sh ),NN )

    # Quantification sans tramage sur fond neutre uniquement sur les pixels opaques
    arr =np .array (resized )
    opaque =arr [:,:,3 ]>=128 
    rgb_im =Image .fromarray (arr [:,:,:3 ],'RGB').quantize (
    colors =128 ,method =Image .Quantize .FASTOCTREE ,dither =Image .Dither .NONE 
    ).convert ('RGB')
    q_rgb =np .array (rgb_im )

    # Suppression des micro-isolats 1-2 px post-réduction
    lbl ,n =nd .label (opaque ,structure =np .ones ((3 ,3 ),dtype =int ))
    if n >1 :
        cnt =np .bincount (lbl .ravel ())
        keep =cnt >=3 
        keep [0 ]=False 
        opaque =keep [lbl ]

        # Dé-contamination chromatique post-quantification au cas où
    r =q_rgb [:,:,0 ].astype (np .int32 )
    g =q_rgb [:,:,1 ].astype (np .int32 )
    b =q_rgb [:,:,2 ].astype (np .int32 )
    spill =opaque &(r >g +16 )&(b >g +16 )&(b >60 )
    donor =opaque &~spill 
    if np .any (spill )and np .any (donor ):
        _ ,idx =nd .distance_transform_edt (~donor ,return_indices =True )
        q_rgb [spill ]=q_rgb [idx [0 ][spill ],idx [1 ][spill ]]

        # Cadrage centré sur dimensions multiples stricts de 8 px (marge 8 px en haut et ligne de pose à H - 8)
    cw =int (math .ceil ((sw +8 )/8.0 ))*8 
    ch =int (math .ceil ((sh +16 )/8.0 ))*8 
    canvas =np .zeros ((ch ,cw ,4 ),dtype =np .uint8 )
    ox =(cw -sw )//2 
    oy =ch -8 -sh 
    sub =np .zeros ((sh ,sw ,4 ),dtype =np .uint8 )
    sub [opaque ,:3 ]=q_rgb [opaque ]
    sub [opaque ,3 ]=255 
    canvas [oy :oy +sh ,ox :ox +sw ]=sub 
    return Image .fromarray (canvas ,'RGBA')


def split_under_over (im_1x :Image .Image ,split_ratio_y :float )->tuple [Image .Image ,Image .Image ,int ]:
    """Partitionne exactement (`arriere | avant == complet`, `arriere & avant == 0`) sur frontière multiple de 8 px."""
    arr =np .array (im_1x )
    h ,w ,_ =arr .shape 
    ys ,_ =np .where (arr [:,:,3 ]>0 )
    top_y ,bot_y =int (ys .min ()),int (ys .max ())+1 
    raw_cut =top_y +int ((bot_y -top_y )*split_ratio_y )
    cut_y =max (8 ,min (h -8 ,(raw_cut //8 )*8 ))

    under =np .zeros_like (arr )
    over =np .zeros_like (arr )
    under [cut_y :,:,:]=arr [cut_y :,:,:]
    over [:cut_y ,:,:]=arr [:cut_y ,:,:]
    return Image .fromarray (under ,'RGBA'),Image .fromarray (over ,'RGBA'),cut_y 


def write_pmdo_tile (im :Image .Image ,path :Path )->int :
    """Encode un `.tile` natif PMDO 8×8 dédupliqué compatible `nr.tiles(path)[1]`."""
    assert im .width %8 ==0 and im .height %8 ==0 
    cells =[
    (x ,y ,im .crop ((x *8 ,y *8 ,x *8 +8 ,y *8 +8 )))
    for y in range (im .height //8 )
    for x in range (im .width //8 )
    ]
    header =struct .pack ('<II',8 ,len (cells ))
    entries =[]
    payload =bytearray ()
    offsets :dict [bytes ,int ]={}
    for x ,y ,tile_im in cells :
        sig =tile_im .tobytes ()
        if sig not in offsets :
            offsets [sig ]=8 +16 *len (cells )+len (payload )
            buf =io .BytesIO ()
            tile_im .save (buf ,format ='PNG')
            raw =buf .getvalue ()
            payload .extend (struct .pack ('<q',len (raw ))+raw )
        entries .append (struct .pack ('<IIQ',x ,y ,offsets [sig ]))
    path .parent .mkdir (parents =True ,exist_ok =True )
    path .write_bytes (header +b''.join (entries )+payload )
    return len (offsets )


def write_tsj (png_name :str ,w :int ,h :int ,name :str ,path :Path )->None :
    doc ={
    'type':'tileset',
    'version':'1.10',
    'tiledversion':'1.10.2',
    'name':name ,
    'tilewidth':8 ,
    'tileheight':8 ,
    'tilecount':(w //8 )*(h //8 ),
    'columns':w //8 ,
    'margin':0 ,
    'spacing':0 ,
    'image':png_name ,
    'imagewidth':w ,
    'imageheight':h ,
    }
    path .write_text (json .dumps (doc ,indent =2 )+'\n')


def b64_png (path :Path )->str :
    return 'data:image/png;base64,'+base64 .b64encode (path .read_bytes ()).decode ('ascii')


def build_html_gallery (items :list [dict [str ,Any ]],zip_rel :str )->str :
    cards_html =[]
    js_entries =[]

    for item in items :
        sid =item ['slug']
        cw ,ch =item ['canvas_1x_px']
        hw ,hh =item ['size_hd_px']
        uris =item ['data_uris']
        dl =item ['downloads_rel']
        js_entries .append ({
        'slug':sid ,
        'w1x':cw ,
        'h1x':ch ,
        'whd':hw ,
        'hhd':hh ,
        'uris':uris ,
        'dl':dl ,
        })
        cards_html .append (f'''
        <article class="card" id="card-{sid}">
          <div class="card-head">
            <div>
              <span class="badge-pfx">{item["pfx"]}</span>
              <span class="badge-floors">{item["floors"]} étages</span>
              <span class="cat">{item["category"]}</span>
              <h2>{item["title"]}</h2>
            </div>
            <div class="dims">
              PMDO 8px : <strong>{cw} × {ch} px</strong> ({cw // 8} × {ch // 8} cases)<br>
              HD sans fond : <strong>{hw} × {hh} px</strong>
            </div>
          </div>
          <div class="stage" data-stage="{sid}">
            <img id="img-{sid}" class="sprite-img" src="{uris['1x_jour_complet']}"
                 alt="{item['title']}" width="{cw * 2}" height="{ch * 2}">
          </div>
          <div class="dl-row">
            <a class="dl-primary" id="dl-active-{sid}" href="{dl['1x_jour_complet']}" download>
              Télécharger l’image affichée (PNG RGBA sans fond)
            </a>
            <a href="{dl['1x_jour_complet']}" download>1× Jour ({cw}×{ch})</a>
            <a href="{dl['1x_nuit_complet']}" download>1× Nuit illuminée</a>
            <a href="{dl['1x_arriere']}" download>1× Base Under</a>
            <a href="{dl['1x_avant']}" download>1× Étages &amp; Feuillage Over</a>
            <a href="{dl['hd_jour']}" download>HD Jour ({hw}×{hh})</a>
            <a href="{dl['hd_nuit']}" download>HD Nuit ({hw}×{hh})</a>
            <a href="{dl['tile_jour']}" download>{item["pfx"]}_Jour.tile</a>
          </div>
        </article>''')

    payload_json =json .dumps (js_entries ,ensure_ascii =False )
    return f'''<!doctype html>
<html lang="fr">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Grandes Treehouses Monumentales de la Guilde — Collection PMDO Sans Fond</title>
<style>
  :root {{
    color-scheme: dark;
    --bg-page: #1b1815;
    --bg-card: #27221d;
    --stage-bg: #3a3028;
    --gold: #f0c96b;
    --accent: #7ec879;
    --text: #f3ece1;
    --muted: #BFB4A3;
    --line: #493e34;
  }}
  * {{ box-sizing: border-box; }}
  body {{
    margin: 0;
    background: var(--bg-page);
    color: var(--text);
    font: 15px/1.55 system-ui, -apple-system, Segoe UI, Roboto, sans-serif;
  }}
  main {{ max-width: 1440px; margin: 0 auto; padding: 28px 20px 64px; }}
  header {{
    background: #25201b;
    border: 1px solid var(--line);
    border-radius: 14px;
    padding: 24px 26px;
    margin-bottom: 20px;
  }}
  .eyebrow {{ color: var(--accent); font-weight: 700; letter-spacing: 2px; font-size: 12px; text-transform: uppercase; }}
  h1 {{ margin: 8px 0 10px; font-size: 32px; line-height: 1.18; color: #fff6e5; }}
  header p {{ margin: 6px 0; color: var(--muted); max-width: 980px; }}
  .hero-actions {{ display: flex; flex-wrap: wrap; gap: 12px; margin-top: 16px; }}
  .btn-pack {{
    display: inline-block;
    background: var(--gold);
    color: #1b1409;
    font-weight: 800;
    padding: 11px 18px;
    border-radius: 9px;
    text-decoration: none;
  }}
  .btn-secondary {{
    display: inline-block;
    background: #352e27;
    color: var(--gold);
    border: 1px solid var(--gold);
    font-weight: 700;
    padding: 10px 16px;
    border-radius: 9px;
    text-decoration: none;
  }}
  .toolbar {{
    position: sticky;
    top: 8px;
    z-index: 20;
    display: flex;
    flex-wrap: wrap;
    gap: 10px 18px;
    align-items: center;
    background: #2b241e;
    border: 1px solid #635343;
    border-radius: 12px;
    padding: 12px 16px;
    margin-bottom: 24px;
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.42);
  }}
  .group {{ display: flex; align-items: center; gap: 6px; flex-wrap: wrap; }}
  .group span {{ font-size: 12px; font-weight: 700; color: var(--gold); text-transform: uppercase; margin-right: 2px; }}
  button {{
    font: inherit;
    font-size: 13px;
    font-weight: 600;
    padding: 7px 12px;
    border-radius: 7px;
    border: 1px solid #5d4f42;
    background: #383028;
    color: var(--text);
    cursor: pointer;
  }}
  button.active {{
    background: var(--gold);
    color: #1c1408;
    border-color: var(--gold);
  }}
  .grid {{
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(580px, 1fr));
    gap: 22px;
  }}
  @media (max-width: 700px) {{
    .grid {{ grid-template-columns: 1fr; }}
  }}
  .card {{
    background: var(--bg-card);
    border: 1px solid var(--line);
    border-radius: 14px;
    overflow: hidden;
    display: flex;
    flex-direction: column;
  }}
  .card-head {{
    padding: 16px 20px 12px;
    display: flex;
    justify-content: space-between;
    gap: 16px;
    align-items: flex-start;
    border-bottom: 1px solid var(--line);
  }}
  .badge-pfx {{
    display: inline-block;
    background: #3d3328;
    color: var(--gold);
    font: 700 12px monospace;
    padding: 2px 8px;
    border-radius: 5px;
    border: 1px solid #6b5842;
  }}
  .badge-floors {{
    display: inline-block;
    background: #263c29;
    color: #a9e39e;
    font-size: 12px;
    font-weight: 700;
    padding: 2px 9px;
    border-radius: 5px;
    margin-left: 6px;
  }}
  .cat {{ color: var(--muted); font-size: 12px; margin-left: 8px; }}
  .card-head h2 {{ margin: 8px 0 0; font-size: 18px; color: #fff4df; }}
  .dims {{ font-size: 12px; color: var(--muted); text-align: right; white-space: nowrap; }}
  .stage {{
    background-color: var(--stage-bg);
    min-height: 420px;
    padding: 24px 16px;
    display: flex;
    align-items: flex-end;
    justify-content: center;
    overflow: auto;
  }}
  .sprite-img {{
    display: block;
    image-rendering: pixelated;
    image-rendering: crisp-edges;
    max-width: none;
  }}
  .dl-row {{
    padding: 14px 18px;
    background: #221d19;
    border-top: 1px solid var(--line);
    display: flex;
    flex-wrap: wrap;
    gap: 8px 10px;
    align-items: center;
  }}
  .dl-row a {{
    font-size: 12.5px;
    color: var(--gold);
    background: #312923;
    border: 1px solid #524438;
    padding: 6px 10px;
    border-radius: 6px;
    text-decoration: none;
  }}
  .dl-row a.dl-primary {{
    background: #355233;
    border-color: #6ca866;
    color: #efffec;
    font-weight: 700;
  }}
  .notice {{
    margin-top: 28px;
    padding: 18px 22px;
    background: #25201b;
    border-left: 4px solid var(--gold);
    border-radius: 8px;
    color: var(--muted);
    font-size: 13.5px;
  }}
</style>
</head>
<body>
<main>
  <header>
    <div class="eyebrow">Guilde d’Exploration Sylvestre · POV PMD / Métano · Zéro Damier · 100 % Vrai Alpha RGBA</div>
    <h1>Grandes Treehouses Monumentales à Étages &amp; Feuillage Ciselé</h1>
    <p>
      <strong>9 structures extérieures complètes pour la Guilde</strong> (aucun motif Spinda) :
      citadelle QG à <strong>4 étages</strong>, grand manoir sylvestre à double fourche et pont suspendu,
      grand chêne-auberge à terrasses, sanctuaire-bibliothèque à rosace et grue à poulie,
      trois tours-observatoires &amp; beffrois à escaliers hélicoïdaux (4 niveaux), et deux huttes annexes de village.
    </p>
    <p>
      <strong>100 % vrai sans fond (<code>alpha = 0</code>, <code>0 px</code> de frange magenta)</strong> :
      chaque image ci-dessous est une véritable balise <code>&lt;img&gt;</code> PNG RGBA transparente
      (clic droit → <em>Enregistrer l’image sous…</em> ou boutons directs).
    </p>
    <div class="hero-actions">
      <a class="btn-pack" href="{zip_rel}" download>
        Télécharger le Pack Complet ZIP (PNG 1× Grille 8px + HD RGBA + Banques .tile PMDO)
      </a>
      <a class="btn-secondary" href="telecharger_objets_cafe_pmdo.html">
        Voir aussi le Pack Intérieur &amp; Scène Café (16 objets sans fond)
      </a>
    </div>
  </header>

  <nav class="toolbar" aria-label="Contrôles d'affichage">
    <div class="group" data-group="time">
      <span>Ambiance :</span>
      <button type="button" class="active" data-val="jour">Jour ensoleillé</button>
      <button type="button" data-val="nuit">Nuit (fenêtres &amp; lanternes allumées)</button>
    </div>
    <div class="group" data-group="scale">
      <span>Échelle :</span>
      <button type="button" data-val="1x">1× Native PMDO (8px)</button>
      <button type="button" class="active" data-val="2x">2× Zoom Pixel</button>
      <button type="button" data-val="hd">HD Pleine Définition</button>
    </div>
    <div class="group" data-group="layer">
      <span>Calque PMDO :</span>
      <button type="button" class="active" data-val="complet">Structure complète</button>
      <button type="button" data-val="arriere">Base &amp; Racines (Under)</button>
      <button type="button" data-val="avant">Étages &amp; Feuillage (Over)</button>
    </div>
    <div class="group" data-group="bg">
      <span>Fond témoin uni :</span>
      <button type="button" class="active" data-val="#3a3028">Terre chaude (#3a3028)</button>
      <button type="button" data-val="#24352a">Forêt Métano (#24352a)</button>
      <button type="button" data-val="#161d26">Nuit profonde (#161d26)</button>
    </div>
  </nav>

  <section class="grid">
    {''.join(cards_html)}
  </section>

  <section class="notice">
    <strong>Note technique &amp; provenance honnête :</strong>
    Créations originales générées et nettoyées au pixel sur grille <code>8 × 8 px</code> PMDO (<code>TexSize = 1</code>),
    inspirées de la direction artistique bois/feuillage de <em>Pokémon Mystery Dungeon: Explorers of Sky</em> (Chunsoft)
    et <em>Halcyon / Metano Town</em> (<a href="https://github.com/meta/Halcyon" style="color:#f0c96b">meta/Halcyon</a>,
    metas exclusifs à leurs auteurs respectifs ; aucun pixel canonique revendiqué comme création originale).
    Statut : <code>art_approved: false</code> (propositions soumises à validation artistique),
    <code>runtime_tested: false</code> (format binaire <code>.tile</code> et partition <code>Under/Over</code> vérifiés par tests automatisés,
    collisions et warps à configurer dans l’éditeur PMDO).
  </section>
</main>
<script>
const ITEMS = {payload_json};
const state = {{ time: 'jour', scale: '2x', layer: 'complet', bg: '#3a3028' }};

function keyForState() {{
  if (state.scale === 'hd') {{
    return state.time === 'nuit' ? 'hd_nuit' : 'hd_jour';
  }}
  if (state.layer === 'arriere') return '1x_arriere';
  if (state.layer === 'avant') return '1x_avant';
  return state.time === 'nuit' ? '1x_nuit_complet' : '1x_jour_complet';
}}

function refresh() {{
  document.documentElement.style.setProperty('--stage-bg', state.bg);
  const k = keyForState();
  for (const it of ITEMS) {{
    const im = document.getElementById('img-' + it.slug);
    const a = document.getElementById('dl-active-' + it.slug);
    im.src = it.uris[k];
    if (state.scale === 'hd') {{
      const dispW = Math.min(it.whd, 620);
      const dispH = Math.round(it.hhd * (dispW / it.whd));
      im.width = dispW;
      im.height = dispH;
    }} else {{
      const mult = state.scale === '2x' ? 2 : 1;
      im.width = it.w1x * mult;
      im.height = it.h1x * mult;
    }}
    a.href = it.dl[k];
  }}
}}

document.querySelectorAll('.toolbar .group').forEach(grp => {{
  const gname = grp.dataset.group;
  grp.querySelectorAll('button').forEach(btn => {{
    btn.addEventListener('click', () => {{
      grp.querySelectorAll('button').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      state[gname] = btn.dataset.val;
      refresh();
    }});
  }});
}});
refresh();
</script>
</body>
</html>
'''


def main ()->None :
    OUT_1X .mkdir (parents =True ,exist_ok =True )
    OUT_HD .mkdir (parents =True ,exist_ok =True )
    OUT_MOD_TILE .mkdir (parents =True ,exist_ok =True )
    OUT_SPRITES .mkdir (parents =True ,exist_ok =True )

    manifest_entries :list [dict [str ,Any ]]=[]
    html_items :list [dict [str ,Any ]]=[]

    for slug ,pfx ,title ,category ,floors ,raw_rel ,comp_rank ,max_wh ,split_y in STRUCTURES_SPEC :
        raw_path =BRUTS /raw_rel 
        raw_np =np .array (Image .open (raw_path ).convert ('RGB'))

        # 1. Extraction HD propre sans aucun halo magenta
        hd_jour =clean_magenta_and_despill (raw_np ,comp_rank =comp_rank )
        assert_zero_magenta_fringe (hd_jour ,f'{slug}_HD_jour')
        hd_nuit =make_night_glowing (hd_jour )
        assert_zero_magenta_fringe (hd_nuit ,f'{slug}_HD_nuit')

        # 2. Réduction pixel-art 1x alignée sur grille 8×8 PMDO (préservation riche 128 couleurs)
        im_1x_jour =downsample_pmdo_grid (hd_jour ,max_wh =max_wh )
        assert_zero_magenta_fringe (im_1x_jour ,f'{slug}_1x_jour')
        im_1x_nuit =make_night_glowing (im_1x_jour )
        assert_zero_magenta_fringe (im_1x_nuit ,f'{slug}_1x_nuit')

        # 3. Partition exacte Under (arriere) / Over (avant) sur multiple de 8 px
        im_under ,im_over ,cut_y =split_under_over (im_1x_jour ,split_ratio_y =split_y )
        assert_zero_magenta_fringe (im_under ,f'{slug}_1x_arriere')
        assert_zero_magenta_fringe (im_over ,f'{slug}_1x_avant')

        # Sauvegarde des PNG 1x + HD sans fond
        p_1x_jour =OUT_1X /f'{slug}_1x_complet.png'
        p_1x_nuit =OUT_1X /f'{slug}_1x_nuit.png'
        p_1x_under =OUT_1X /f'{slug}_1x_arriere.png'
        p_1x_over =OUT_1X /f'{slug}_1x_avant.png'
        p_hd_jour =OUT_HD /f'{slug}_HD_jour.png'
        p_hd_nuit =OUT_HD /f'{slug}_HD_nuit.png'

        im_1x_jour .save (p_1x_jour ,optimize =True )
        im_1x_nuit .save (p_1x_nuit ,optimize =True )
        im_under .save (p_1x_under ,optimize =True )
        im_over .save (p_1x_over ,optimize =True )
        hd_jour .save (p_hd_jour ,optimize =True )
        hd_nuit .save (p_hd_nuit ,optimize =True )

        # Banques .tile natives PMDO + descripteurs Tiled .tsj
        tile_jour =OUT_MOD_TILE /f'{pfx}_{slug}_Jour.tile'
        tile_nuit =OUT_MOD_TILE /f'{pfx}_{slug}_Nuit.tile'
        tile_under =OUT_MOD_TILE /f'{pfx}_{slug}_Under.tile'
        tile_over =OUT_MOD_TILE /f'{pfx}_{slug}_Over.tile'
        uniq_j =write_pmdo_tile (im_1x_jour ,tile_jour )
        uniq_n =write_pmdo_tile (im_1x_nuit ,tile_nuit )
        write_pmdo_tile (im_under ,tile_under )
        write_pmdo_tile (im_over ,tile_over )

        # Copies miroir dans sprites/guilde_treehouses_pmdo_v2/
        im_1x_jour .save (OUT_SPRITES /f'{pfx}_{slug}_Jour.png')
        im_1x_nuit .save (OUT_SPRITES /f'{pfx}_{slug}_Nuit.png')
        write_pmdo_tile (im_1x_jour ,OUT_SPRITES /f'{pfx}_{slug}_Jour.tile')
        write_pmdo_tile (im_1x_nuit ,OUT_SPRITES /f'{pfx}_{slug}_Nuit.tile')
        write_tsj (
        f'{pfx}_{slug}_Jour.png',
        im_1x_jour .width ,
        im_1x_jour .height ,
        f'{pfx}_{slug}_Jour',
        OUT_SPRITES /f'{pfx}_{slug}_Jour.tsj',
        )
        write_tsj (
        f'{pfx}_{slug}_Nuit.png',
        im_1x_nuit .width ,
        im_1x_nuit .height ,
        f'{pfx}_{slug}_Nuit',
        OUT_SPRITES /f'{pfx}_{slug}_Nuit.tsj',
        )

        manifest_entries .append ({
        'slug':slug ,
        'pfx':pfx ,
        'title':title ,
        'category':category ,
        'visible_floors':floors ,
        'raw_source':f'source/guilde_treehouses_pmdo_v2/bruts/{raw_rel}',
        'raw_sha256':hashlib .sha256 (raw_path .read_bytes ()).hexdigest (),
        'component_rank':comp_rank ,
        'size_hd_px':[hd_jour .width ,hd_jour .height ],
        'canvas_1x_px':[im_1x_jour .width ,im_1x_jour .height ],
        'grid_cells_8px':[im_1x_jour .width //8 ,im_1x_jour .height //8 ],
        'under_over_split_y_px':cut_y ,
        'unique_8x8_tiles_jour':uniq_j ,
        'unique_8x8_tiles_nuit':uniq_n ,
        'files':{
        '1x_jour_complet':str (p_1x_jour .relative_to (R )),
        '1x_nuit_complet':str (p_1x_nuit .relative_to (R )),
        '1x_arriere':str (p_1x_under .relative_to (R )),
        '1x_avant':str (p_1x_over .relative_to (R )),
        'hd_jour':str (p_hd_jour .relative_to (R )),
        'hd_nuit':str (p_hd_nuit .relative_to (R )),
        'tile_jour':str (tile_jour .relative_to (R )),
        'tile_nuit':str (tile_nuit .relative_to (R )),
        'tile_under':str (tile_under .relative_to (R )),
        'tile_over':str (tile_over .relative_to (R )),
        },
        })

        html_items .append ({
        'slug':slug ,
        'pfx':pfx ,
        'title':title ,
        'category':category ,
        'floors':floors ,
        'size_hd_px':[hd_jour .width ,hd_jour .height ],
        'canvas_1x_px':[im_1x_jour .width ,im_1x_jour .height ],
        'data_uris':{
        '1x_jour_complet':b64_png (p_1x_jour ),
        '1x_nuit_complet':b64_png (p_1x_nuit ),
        '1x_arriere':b64_png (p_1x_under ),
        '1x_avant':b64_png (p_1x_over ),
        'hd_jour':str (p_hd_jour .relative_to (R )),
        'hd_nuit':str (p_hd_nuit .relative_to (R )),
        },
        'downloads_rel':{
        '1x_jour_complet':str (p_1x_jour .relative_to (R )),
        '1x_nuit_complet':str (p_1x_nuit .relative_to (R )),
        '1x_arriere':str (p_1x_under .relative_to (R )),
        '1x_avant':str (p_1x_over .relative_to (R )),
        'hd_jour':str (p_hd_jour .relative_to (R )),
        'hd_nuit':str (p_hd_nuit .relative_to (R )),
        'tile_jour':str (tile_jour .relative_to (R )),
        },
        })
        print (
        f'OK [{pfx}] {slug}: HD={hd_jour.width}x{hd_jour.height} -> '
        f'PMDO={im_1x_jour.width}x{im_1x_jour.height} ({im_1x_jour.width // 8}x{im_1x_jour.height // 8} tiles, {uniq_j} uniques)'
        )

        # README d'import PMDO clair et honnête
    readme_txt =(
    'PACK GRANDES STRUCTURES TREEHOUSES DE LA GUILDE — SANS FOND (RGBA ALPHA=0)\n'
    '==========================================================================\n\n'
    'Contenu du dossier :\n'
    '1. 1x_PMDO_8px_sans_fond/ : 9 structures complètes alignées sur grille 8×8 px PMDO\n'
    '   - *_1x_complet.png : structure complète de jour (alpha binaire 0/255, 0 px halo magenta)\n'
    '   - *_1x_nuit.png    : version nocturne avec fenêtres et lanternes ambrées illuminées\n'
    '   - *_1x_arriere.png : sous-couche basse (racines, tronc bas et seuil d’entrée — calque Under)\n'
    '   - *_1x_avant.png   : sur-couche haute (étages perchés, passerelles et feuillage — calque Over)\n'
    '2. HD_sans_fond/ : versions pleine résolution nettoyées RGBA (alpha=0) Jour + Nuit\n'
    '3. Mod_PMDO_Tile_Pret_A_Importer/Content/Tile/ : 36 banques natives `.tile` (GT2A..GT2I)\n\n'
    'Statut : art_approved=false, runtime_tested=false (collisions et warps à poser dans PMDO).\n'
    )
    (OUT_DIR /'LISEZ_MOI_IMPORT_TREEHOUSES_PMDO.txt').write_text (readme_txt )

    manifest ={
    'lot':'guilde_treehouses_pmdo_v2',
    'grid_px':8 ,
    'count':len (manifest_entries ),
    'spinda_motifs':False ,
    'alpha_policy':'strict binary {0, 255}, 0 magenta fringe pixels',
    'art_approved':False ,
    'runtime_tested':False ,
    'reference_metas':{
    'halcyon_repository':'https://github.com/meta/Halcyon',
    'note':'Style swatches from Halcyon / Metano Town & Guild Second Floor used strictly as reference; canonical assets belong to their original creators.',
    },
    'structures':manifest_entries ,
    }
    manifest_json_bytes =(json .dumps (manifest ,ensure_ascii =False ,indent =2 )+'\n').encode ('utf-8')
    (OUT_DIR /'manifest.json').write_bytes (manifest_json_bytes )
    (OUT_SPRITES /'manifest.json').write_bytes (manifest_json_bytes )

    zip_path =OUT_DIR /'PACK_TREEHOUSES_GUILDE_PMDO_SANS_FOND.zip'
    with zipfile .ZipFile (zip_path ,'w',compression =zipfile .ZIP_DEFLATED )as zf :
        for p in sorted (OUT_DIR .rglob ('*')):
            if p .is_file ()and p !=zip_path :
                zf .write (p ,p .relative_to (OUT_DIR ))

    html_content =build_html_gallery (html_items ,zip_rel =str (zip_path .relative_to (R )))
    OUT_HTML .write_text (html_content )
    print (f'Galerie écrite : {OUT_HTML} ({len(html_content) // 1024} Ko) | ZIP : {zip_path.stat().st_size // 1024} Ko')


if __name__ =='__main__':
    main ()
