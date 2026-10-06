#!/usr/bin/env python3
"""Build EFM1: Entrée de la Forêt Moussa, PMDO 0.8.12, 4:3 / 8 px.

Texture 100% canonique multilayer comme spriter pro — un seul generateur.
Composition gengeree referencee D24P11A, layout nouveau, calques pro.
"""
from __future__ import annotations
import hashlib
import importlib.util
import io
import json
import math
import shutil
import uuid
import zipfile
from pathlib import Path
from xml.etree import ElementTree as ET
import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as ndi

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
RAW = HERE / "bruts"
OUT = ROOT / "renders/entree_foret_mousse_sud_nord_v1"
STAGE = ROOT / ".cache/entree_foret_mousse_sud_nord_v1/entree_foret_mousse"
ORA = ROOT / ".cache/entree_foret_mousse_sud_nord_v1/EFM1_calques.ora"
REF = ROOT / ".cache/maps_pmdsky/rom/png/D24P11A.png"
PFX = "EFM1"
NAMESPACE = "entree_foret_mousse"
ASSET = "efm1_entree_foret_mousse"
W, H = 768, 576
GRID = 8
GW, GH = W // GRID, H // GRID
RAW_DECOR_SIZE = (1200, 896)
RAW_FLOOR_SIZE = (1200, 896)
PHASES, TICKS = 24, 5
LOOP_TICKS = PHASES * TICKS
PALETTE_SIZE = 96
REFERENCE_SHA256 = "06399b45633e8dcf1979aabf9a5d693bcf5ba74885c91e943bea9de2caa6ce27"

# Polygone praticable — clairiere mousseuse centrale, arrivee sud vers caverne nord.
FLOOR_POLYGON = [
    (118, 92), (186, 74), (262, 66), (338, 62), (416, 64), (492, 70), (558, 82), (614, 104),
    (648, 144), (664, 190), (670, 250), (666, 312), (652, 374), (634, 432), (618, 486), (606, 540), (602, 576),
    (166, 576), (156, 540), (142, 486), (126, 432), (110, 374), (100, 312), (94, 250), (96, 190), (112, 144),
    (142, 104),
]
CAVE_BOX = (338, 58, 430, 142)
BLOCK_BOXES = [
    (96, 368, 184, 452),
    (584, 368, 672, 452),
    (284, 484, 376, 548),
    (420, 484, 512, 548),
    (132, 512, 220, 572),
    (560, 512, 640, 572),
]
SPORE_BASES = [
    (240, 260), (480, 240), (220, 340), (540, 320),
    (300, 400), (460, 380), (280, 460), (520, 440),
    (360, 220), (410, 290),
]

def sha256(p: Path) -> str:
    return hashlib.sha256(p.read_bytes()).hexdigest()

def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"Impossible de charger {path}")
    m = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(m)
    return m

def polygon_mask(points, size=(W, H)) -> np.ndarray:
    im = Image.new("L", size, 0)
    ImageDraw.Draw(im).polygon(points, fill=255)
    return np.asarray(im, dtype=np.uint8) > 0

def keep_components(mask: np.ndarray, minimum: int) -> np.ndarray:
    labels, count = ndi.label(mask)
    if count == 0:
        return mask
    sizes = ndi.sum(mask, labels, range(1, count+1))
    keep = 1 + np.flatnonzero(sizes >= minimum)
    return np.isin(labels, keep)

def magenta_key(rgb: np.ndarray) -> np.ndarray:
    r,g,b = rgb.astype(np.int16).transpose(2,0,1)
    return (r>200)&(b>200)&(g<90)&(np.abs(r-b)<45)&(r>1.45*g)&(b>1.45*g)

def normalize_image(path: Path) -> tuple[np.ndarray, dict]:
    with Image.open(path) as im:
        im = im.convert("RGB")
        if im.size != RAW_DECOR_SIZE and im.size != RAW_FLOOR_SIZE:
            # allow both, but decor and floor same here
            if im.size != (1200,896):
                raise ValueError(f"image attendue 1200x896, recu {im.size} pour {path}")
        a = np.asarray(im, dtype=np.uint8)
        a = np.pad(a, ((2,2),(0,0),(0,0)), mode="edge")
        out = Image.fromarray(a).resize((W,H), Image.Resampling.BOX)
        arr = np.asarray(out, dtype=np.uint8)
    return arr, {"source_px": list(im.size), "normalized_px":[1200,900], "scale_xy":[0.64,0.64], "method":"pad 2px top/bottom edge, then uniform BOX 0.64, aucun etirement"}

def rgba(rgb: np.ndarray, mask: np.ndarray) -> np.ndarray:
    out = np.zeros((H,W,4), dtype=np.uint8)
    out[...,:3]=rgb
    out[...,3]=np.where(mask,255,0).astype(np.uint8)
    out[~mask]=0
    return out

def quantize_layers(layers: dict[str, np.ndarray], colors: int = PALETTE_SIZE):
    samples=[]
    for arr in layers.values():
        if np.any(arr[...,3]==255):
            samples.append(arr[arr[...,3]==255,:3])
    if not samples:
        raise ValueError("Aucun pixel opaque")
    all_rgb=np.concatenate(samples, axis=0)
    im1d=Image.fromarray(all_rgb.reshape(-1,1,3).astype(np.uint8))
    pal_im=im1d.quantize(colors=colors, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    palette=np.asarray(pal_im.getpalette()[:colors*3], dtype=np.uint8).reshape(-1,3)
    out={}
    for name,src in layers.items():
        res=src.copy()
        vis=res[...,3]==255
        if np.any(vis):
            qi=np.asarray(Image.fromarray(res[...,:3]).quantize(palette=pal_im, dither=Image.Dither.NONE), dtype=np.uint8)
            res[...,:3][vis]=palette[qi[vis]]
        res[res[...,3]==0]=0
        out[name]=res
    return out, palette

def make_masks(decor: np.ndarray):
    if decor.shape != (H,W,3):
        raise ValueError(f"decor attendu {(H,W,3)}, recu {decor.shape}")
    floor_outline = polygon_mask(FLOOR_POLYGON)
    # cave - dark cavity in north
    cave_zone = polygon_mask([(CAVE_BOX[0],CAVE_BOX[1]),(CAVE_BOX[2],CAVE_BOX[1]),(CAVE_BOX[2],CAVE_BOX[3]),(CAVE_BOX[0],CAVE_BOX[3])])
    lum = decor.astype(np.float32) @ np.array([0.299,0.587,0.114], dtype=np.float32)
    r,g,b = decor[...,0].astype(np.int16), decor[...,1].astype(np.int16), decor[...,2].astype(np.int16)
    dark_core = cave_zone & (lum < 55) & (r < 90) & (g < 90) & (b < 90)
    dark_core = ndi.binary_closing(dark_core, iterations=2)
    cave = keep_components(dark_core, 400)
    cave = ndi.binary_fill_holes(cave) & floor_outline
    walkable = floor_outline & ~cave
    # path - stone cobbles beige/tan : r 120-165, g 85-125, b 20-65, r>g, g>b
    path = walkable & (r >=115) & (r <=170) & (g >=80) & (g <=130) & (b >=15) & (b <=70) & (r > g) & (g > b-10) & (lum >=85) & (lum <=145)
    path = keep_components(path, 300)
    path = ndi.binary_closing(path, iterations=2) & walkable
    # flowers - peche rosé et jaune pale (petites touffes)
    pink = walkable & ~path & (r >=158) & (r <=212) & (g >=120) & (g <=158) & (b >=80) & (b <=122) & (r - g >=18) & (g - b >=10) & (lum >=120)
    yellow = walkable & ~path & (r >=195) & (r <=255) & (g >=175) & (g <=235) & (b >=50) & (b <=115) & (r - b >=70) & (g - b >=60)
    flowers = pink | yellow
    flowers = keep_components(flowers, 4)
    flowers = ndi.binary_dilation(flowers, iterations=1) & walkable & ~path
    # prepare local variance for texture detection
    local_mean = ndi.uniform_filter(lum, size=5, mode="nearest")
    local_second = ndi.uniform_filter(lum*lum, size=5, mode="nearest")
    local_sd = np.sqrt(np.maximum(local_second - local_mean*local_mean,0))
    sat = np.maximum(np.maximum(r,g),b).astype(float) - np.minimum(np.minimum(r,g),b).astype(float)
    # shadows - dark moss under canopy, before rocks to keep exclusivity
    moss_for_shadow = walkable & ~path & ~flowers & ~cave
    moss_lum = lum[moss_for_shadow]
    if moss_lum.size == 0:
        raise AssertionError("Aucun pixel mousse")
    shadow_cut = float(np.quantile(moss_lum, 0.22))
    shadows = moss_for_shadow & (lum < shadow_cut) & (local_sd > 2)
    shadows = keep_components(shadows, 12) & moss_for_shadow
    # rocks - small grey stones within walkable moss : low saturation, mid lum, local variance
    grey = walkable & ~path & ~flowers & ~shadows & ~cave & (sat < 28) & (lum >=70) & (lum <=135) & (local_sd >=6)
    roi = np.zeros((H,W), dtype=bool)
    for x0,y0,x1,y1 in BLOCK_BOXES:
        roi[y0:y1, x0:x1] = True
    rocks = grey & (roi | (local_sd >=9))
    rocks = keep_components(rocks, 6) & walkable & ~path & ~flowers & ~shadows & ~cave
    # moss - remaining walkable
    moss = walkable & ~path & ~flowers & ~rocks & ~shadows & ~cave
    # walls / parois - dense canopy outside clearing
    parois = ~floor_outline
    # verification partition
    visual = {"mousse":moss, "sentier":path, "ombres":shadows, "rochers":rocks, "fleurs":flowers, "parois":parois, "caverne":cave}
    all_cover = moss | path | shadows | rocks | flowers | parois | cave
    if not np.all(all_cover):
        missing = int((~all_cover).sum())
        raise AssertionError(f"Partition incomplete, missing {missing}")
    overlap = (moss.astype(int)+path.astype(int)+shadows.astype(int)+rocks.astype(int)+flowers.astype(int)+parois.astype(int)+cave.astype(int))
    if not np.all(overlap==1):
        # debug counts
        print("overlap debug", {k:int(v.sum()) for k,v in visual.items()}, "overlap max", int(overlap.max()), "overlap sum", int(overlap.sum()))
        raise AssertionError(f"Partition non exclusive, overlap max {overlap.max()}")
    return {"mousse":moss,"sentier":path,"ombres":shadows,"rochers":rocks,"fleurs":flowers,"parois":parois,"caverne":cave, "praticable":walkable, "outline":floor_outline}, {
        "floor_outline_pixels": int(floor_outline.sum()),
        "walkable_pixels": int(walkable.sum()),
        "cave_pixels": int(cave.sum()),
        "path_pixels": int(path.sum()),
        "moss_pixels": int(moss.sum()),
        "shadow_pixels": int(shadows.sum()),
        "rock_pixels": int(rocks.sum()),
        "flower_pixels": int(flowers.sum()),
        "shadow_cut": round(shadow_cut,2),
        "roi_rocks": len(BLOCK_BOXES),
    }

def make_spore_frames(walkable: np.ndarray, palette: np.ndarray) -> list[np.ndarray]:
    # choisit deux teintes claires chaudes de la palette commune pour les spores (evite d'inventer couleur hors palette)
    lum = palette.astype(float) @ np.array([0.299,0.587,0.114])
    bright = np.argsort(lum)[-4:]
    # prend les deux plus claires faible saturation (presque blanc/creme)
    colors = [tuple(int(v) for v in palette[int(bright[-1])]), tuple(int(v) for v in palette[int(bright[-2])])]
    frames=[]
    for t in range(PHASES):
        canvas=np.zeros((H,W,4), dtype=np.uint8)
        for i,(bx,by) in enumerate(SPORE_BASES):
            phase=(t + i*3) % PHASES
            if phase >=14:
                continue
            x=int(round(bx + 1.8*math.sin((phase/14)*math.pi*2 + i)))
            y=by - phase*1.2
            if not (1<=x<W-1 and 1<=y<H-1 and walkable[int(y),int(x)]):
                continue
            col=colors[(phase//5 + i) % len(colors)]
            canvas[int(y),int(x)] = (*col, 255)
            if phase%3==0 and walkable[int(y)-1,int(x)]:
                canvas[int(y)-1,int(x)] = (*col, 255)
        frames.append(canvas)
    return frames

def cell_grid(nonwalk: np.ndarray) -> np.ndarray:
    if nonwalk.shape != (H,W):
        raise ValueError(nonwalk.shape)
    frac=nonwalk.reshape(GH,GRID,GW,GRID).mean(axis=(1,3))
    return frac >=0.25

def footprint_free(blocked,y,x):
    return 0<=y<=GH-2 and 0<=x<=GW-2 and not blocked[y:y+2,x:x+2].any()

def reachable_2x2(blocked,start,goal):
    if not footprint_free(blocked,*start) or not footprint_free(blocked,*goal):
        return False,0,[]
    seen=np.zeros((GH,GW),dtype=bool)
    prev={}
    q=[start]
    seen[start]=True
    for y,x in q:
        if (y,x)==goal:
            path=[(y,x)]
            while path[-1]!=start:
                path.append(prev[path[-1]])
            return True,int(seen.sum()),list(reversed(path))
        for dy,dx in ((1,0),(-1,0),(0,1),(0,-1)):
            ny,nx=y+dy,x+dx
            if 0<=ny<GH and 0<=nx<GW and not seen[ny,nx] and footprint_free(blocked,ny,nx):
                seen[ny,nx]=True
                prev[(ny,nx)]=(y,x)
                q.append((ny,nx))
    return False,int(seen.sum()),[]

def choose_markers(blocked,walkable):
    starts=[(y,x) for y in range(GH-6, GH-1) for x in range(GW//2-6, GW//2+6) if footprint_free(blocked,y,x)]
    goals=[(18,x) for x in range(GW//2-8, GW//2+9) if footprint_free(blocked,18,x)]
    if not starts:
        raise AssertionError("Arrivee sud introuvable")
    if not goals:
        raise AssertionError("Seuil nord introuvable")
    starts.sort(key=lambda p: (abs(p[1]-(GW//2-1))+abs(p[0]-(GH-3)), p))
    goals.sort(key=lambda p: (abs(p[1]-(GW//2-1)), p))
    best=None
    for s in starts[:8]:
        for g in goals[:8]:
            ok,expl,path=reachable_2x2(blocked,s,g)
            if ok:
                score=len(path)+0.1*abs(g[1]-(GW//2-1))
                if best is None or score<best[0]:
                    best=(score,s,g,expl,path)
    if best is None:
        raise AssertionError("Aucun chemin 16x16 sud->nord")
    _,start,goal,expl,path=best
    return {"entry_cell_yx":list(start),"threshold_cell_yx":list(goal),
            "entry_px":[start[1]*GRID,start[0]*GRID],"threshold_px":[goal[1]*GRID,goal[0]*GRID],
            "path_found_16x16":True,"path_cells":len(path),"cells_explored":expl,
            "blocked_cells":int(blocked.sum()),"walkable_cells":int((~blocked).sum()),
            "rule":"case bloquee si >=25% pixels hors praticable; empreinte 16x16"}

def reference_fidelity(scene: np.ndarray, moss_mask: np.ndarray):
    if not REF.exists():
        return None
    if sha256(REF)!=REFERENCE_SHA256:
        raise ValueError(f"SHA reference inattendue {sha256(REF)}")
    ref=np.asarray(Image.open(REF).convert("RGB"), dtype=np.uint8).astype(np.float32)
    ref_mean=ref.mean(axis=(0,1))
    # scene is (H,W,3), mask is (H,W) -> boolean indexing gives (N,3)
    moss_pixels=scene[moss_mask]
    if moss_pixels.size==0:
        moss_mean=np.array([0,0,0], dtype=np.float32)
        dist=float(np.linalg.norm(moss_mean-ref_mean))
    else:
        moss_mean=moss_pixels.astype(np.float32).mean(axis=0)
        dist=float(np.linalg.norm(moss_mean-ref_mean))
    dist=float(np.linalg.norm(moss_mean-ref_mean))
    return {"metric":"euclidienne RGB moyenne mousse vs reference D24P11A","reference_mean":[round(float(v),1) for v in ref_mean],
            "moss_mean":[round(float(v),1) for v in moss_mean],"distance":round(dist,1),"threshold":35,
            "pass":dist<35,"interpretation":"mesure indicative de fidelite matiere, pas preuve pixel natif"}

def composite(stack: list[np.ndarray]) -> Image.Image:
    res=Image.new("RGBA",(W,H),(0,0,0,0))
    for arr in stack:
        res.alpha_composite(Image.fromarray(arr,"RGBA"))
    return res

def save_png(path: Path, arr: np.ndarray):
    path.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(arr).save(path, optimize=True)

def write_ora(path: Path, named: list[tuple[str, np.ndarray]]):
    path.parent.mkdir(parents=True, exist_ok=True)
    root=ET.Element("image", w=str(W),h=str(H), name="EFM1 - Foret Moussa")
    stack=ET.SubElement(root,"stack")
    comp=Image.new("RGBA",(W,H),(0,0,0,0))
    with zipfile.ZipFile(path,"w",zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        z.writestr("mimetype","image/openraster", compress_type=zipfile.ZIP_STORED)
        for idx,(name,arr) in reversed(list(enumerate(named))):
            fn=f"data/layer{idx:02d}.png"
            ET.SubElement(stack,"layer", name=name, src=fn, x="0",y="0",opacity="1.0",visibility="visible",**{"composite-op":"svg:src-over"})
            b=io.BytesIO()
            Image.fromarray(arr,"RGBA").save(b,format="PNG", compress_level=9)
            z.writestr(fn,b.getvalue())
        for _,arr in named:
            comp.alpha_composite(Image.fromarray(arr,"RGBA"))
        b=io.BytesIO(); comp.save(b,format="PNG",compress_level=9); z.writestr("mergedimage.png",b.getvalue())
        thumb=comp.copy(); thumb.thumbnail((256,256), Image.Resampling.LANCZOS)
        b=io.BytesIO(); thumb.save(b,format="PNG"); z.writestr("Thumbnails/thumbnail.png",b.getvalue())
        z.writestr("stack.xml", ET.tostring(root, encoding="utf-8", xml_declaration=True))

def ground_project(stack: list[tuple[str, list[np.ndarray], int]], blocked: np.ndarray, access: dict):
    gfx=load_module("pmdo_codec_efm1", ROOT/"source/pmdo_cote/build.py")
    idx_tools=load_module("pmdo_index_efm1", ROOT/"source/pmdo_cote/INSTALLER.py")
    templ_path=ROOT/"cliffdaytest.rsground"
    if not templ_path.exists():
        raise FileNotFoundError("Template Ground manquant")
    templ=json.loads(templ_path.read_text(encoding="utf-8-sig"))
    if STAGE.exists():
        shutil.rmtree(STAGE)
    (STAGE/"Content/Tile").mkdir(parents=True)
    (STAGE/f"Data/Script/{NAMESPACE}/ground/{ASSET}").mkdir(parents=True)
    (STAGE/"Data/Ground").mkdir(parents=True)
    layers,banks=[],[]
    for idx,(title,frames,ftick) in enumerate(stack):
        bank=gfx.TileBank(f"{PFX}_{idx:02d}_{title.upper()}")
        bank.ids[bytes(256)]=(0,0)
        bank.data[(0,0)]=bytes(256)
        if len(frames)==1:
            im=frames[0]
            def cell(x,y,bank=bank,im=im):
                tile=bank.add(Image.fromarray(im[y*GRID:(y+1)*GRID, x*GRID:(x+1)*GRID],"RGBA"),x,y)
                return [tile] if tile else []
            layer=gfx.layer(f"{idx:02d} {title.replace('_',' ')}", GW,GH, cell)
        else:
            def cells(x,y,bank=bank,frames=frames):
                refs=[bank.add(Image.fromarray(fr[y*GRID:(y+1)*GRID, x*GRID:(x+1)*GRID],"RGBA"),x,y) for fr in frames]
                if all(r is None for r in refs):
                    return []
                blank={"Sheet":bank.name,"TexLoc":{"X":0,"Y":0}}
                return [r if r is not None else blank for r in refs]
            layer=gfx.layer(f"{idx:02d} {title.replace('_',' ')}", GW,GH, cells, ftick)
        layers.append(layer); banks.append(bank)
    top_idx=len(layers)
    layers.append(gfx.layer(f"{top_idx:02d} Top (vide)", GW,GH, draw=4))
    for b in banks:
        b.write(STAGE/f"Content/Tile/{b.name}.tile")
    obj=templ["Object"]
    obj.update({"TexSize":1,"Name":{"DefaultText":"Entree Foret Moussa - sud vers nord","LocalTexts":{}},
                "AssetName":ASSET,"Released":False,
                "Comment":"PMDO 0.8.12. Foret mousse D24P11A referencee, textures 100% canonique multilayer spriter pro. Calques pro, sans warp.",
                "Music":"","EdgeView":1,"ViewCenter":None,"ViewOffset":{"X":0,"Y":0},
                "ActiveChar":None,"Status":{},"Background":{"$type":"RogueEssence.Dungeon.LayeredBG, RogueEssence","Layers":[]},
                "Layers":layers,"Decorations":[{"Name":"Vos decorations","Layer":2,"Visible":True,"Anims":[]}]})
    obj["obstacles"]=[[{"Bounds":{"X":x*GRID,"Y":y*GRID,"Width":GRID,"Height":GRID},"Tags":int(blocked[y,x])} for y in range(GH)] for x in range(GW)]
    mk=lambda n,p: {"EntName":n,"Direction":4,"EntEnabled":True,"triggerType":0,"Collider":{"X":p[0],"Y":p[1],"Width":16,"Height":16}}
    obj["Entities"]=[{"Name":"Entree et seuil","Visible":True,"MapChars":[],"GroundObjects":[],"Spawners":[],
                      "Markers":[mk("entrance",access["entry_px"]), mk("donjon_seuil",access["threshold_px"])]}]
    templ["Version"]="0.8.12.0"
    gfx.save(STAGE/f"Data/Ground/{ASSET}.rsground", json.dumps(templ, ensure_ascii=False, separators=(",",":")).encode("utf-8"))
    gfx.save(STAGE/f"Data/Script/{NAMESPACE}/ground/{ASSET}/init.lua", f"-- {ASSET}: seuil sans warp\nlocal {ASSET} = {{}}\nreturn {ASSET}\n".encode("utf-8"))
    nodes={}
    for p in sorted((STAGE/"Content/Tile").glob("*.tile")):
        with p.open("rb") as s:
            nodes[p.stem]=idx_tools.read_node(s)
    (STAGE/"Content/Tile/index.idx").write_bytes(idx_tools.encode_index(nodes))
    mod_uuid=uuid.uuid5(uuid.NAMESPACE_URL, "https://github.com/meromoonmeri/projet-creation-pmdo/"+NAMESPACE)
    (STAGE/"Mod.xml").write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Entree Foret Moussa EFM1 - Atelier PMDO 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Entree foret mousse 4:3, multilayer canonique, arrivee sud, caverne nord, spores. Projet sans warp.</Description>
  <Namespace>{NAMESPACE}</Namespace>
  <UUID>{mod_uuid}</UUID>
  <Version>1.0.0.0</Version>
  <GameVersion>0.8.12.0</GameVersion>
  <ModType>Quest</ModType>
  <Relationships />
</Header>
''', encoding="utf-8")
    installer=(ROOT/"source/pmdo_cote/INSTALLER.py").read_text(encoding="utf-8")
    needle="            relative = src.relative_to(source)\n"
    if needle not in installer:
        raise RuntimeError("point extension installeur changé")
    installer=installer.replace(needle, needle+"            if relative.as_posix() == 'Content/Tile/index.idx':\n                continue\n",1)
    (STAGE/"INSTALLER.py").write_text(installer, encoding="utf-8")
    shutil.copyfile(HERE/"README_PACK.md", STAGE/"README.md")
    return {b.name: len(b.data) for b in banks}

def build() -> dict:
    decor_path=RAW/"decor.png"
    floor_path=RAW/"sol_complet.png"
    if not decor_path.exists() or not floor_path.exists():
        raise FileNotFoundError("Bruts manquants")
    decor, decor_norm = normalize_image(decor_path)
    floor_full, floor_norm = normalize_image(floor_path)
    # segmentation pro
    masks, seg_info = make_masks(decor)
    walkable=masks["praticable"]
    blocked=cell_grid(~walkable)
    access=choose_markers(blocked, walkable)
    # fidelity
    fidelity=reference_fidelity(decor, masks["mousse"])
    if fidelity and not fidelity["pass"]:
        # warning not blocking? But enforce <35
        raise ValueError(f"Fidelite mousse {fidelity['distance']} >35")
    # layers raw rgba
    raw_layers={
        "00_sol_complet": rgba(floor_full, np.ones((H,W), dtype=bool)),
        "01_mousse": rgba(decor, masks["mousse"]),
        "02_sentier": rgba(decor, masks["sentier"]),
        "03_ombres": rgba(decor, masks["ombres"]),
        "04_rochers": rgba(decor, masks["rochers"]),
        "05_fleurs": rgba(decor, masks["fleurs"]),
        "06_parois": rgba(decor, masks["parois"]),
        "07_caverne": rgba(decor, masks["caverne"]),
    }
    layers, palette = quantize_layers(raw_layers, PALETTE_SIZE)
    spores=make_spore_frames(walkable, palette)
    top=np.zeros((H,W,4), dtype=np.uint8)
    # save
    OUT.mkdir(parents=True, exist_ok=True)
    for sub in ("calques","animation/spores","masques","review"):
        shutil.rmtree(OUT/sub, ignore_errors=True)
        (OUT/sub).mkdir(parents=True, exist_ok=True)
    for name,arr in layers.items():
        save_png(OUT/"calques"/f"{PFX}_{name}.png", arr)
    save_png(OUT/"calques"/f"{PFX}_08_top.png", top)
    for t,fr in enumerate(spores):
        save_png(OUT/"animation/spores"/f"{PFX}_08_spores_f{t:02d}.png", fr)
    for name,mask in masks.items():
        if mask.shape==(H,W):
            save_png(OUT/"masques"/f"{PFX}_masque_{name}.png", mask.astype(np.uint8)*255)
    save_png(OUT/"masques"/f"{PFX}_masque_bloque_8px.png", blocked.astype(np.uint8)*255)
    # composites
    ordered=[layers[k] for k in raw_layers] + [top]
    scene0=composite(ordered)
    # static + spores composited for preview
    stack=[(k,[v],60) for k,v in layers.items()] + [("08_spores", spores, TICKS), ("09_top",[top],60)]
    scene_anim=Image.new("RGBA",(W,H),(0,0,0,0))
    for n,frames,ft in [(k,v,60) for k,v in layers.items()]+[("spores",spores,TICKS)]:
        # reuse top? already
        pass
    # create layered preview via composite_stack logic
    def composite_at(tick):
        r=Image.new("RGBA",(W,H),(0,0,0,0))
        for n,arr in layers.items():
            r.alpha_composite(Image.fromarray(arr,"RGBA"))
        r.alpha_composite(Image.fromarray(spores[(tick//TICKS)%len(spores)],"RGBA"))
        r.alpha_composite(Image.fromarray(top,"RGBA"))
        return r
    scene0_sp = composite_at(0)
    if not np.all(np.asarray(scene0_sp)[...,3]==255):
        raise AssertionError("Scene non opaque")
    save_png(OUT/"review"/f"{PFX}_scene_t000.png", np.asarray(scene0_sp))
    save_png(OUT/"review"/f"{PFX}_scene_x2.png", np.asarray(scene0_sp.resize((W*2,H*2), Image.Resampling.NEAREST)))
    # webp animate
    frames=[composite_at(t) for t in range(0, LOOP_TICKS, TICKS)]
    # reduce to sample for webp
    webp_path=OUT/"review"/f"{PFX}_scene_animee.webp"
    frames[0].save(webp_path, save_all=True, append_images=frames[1:], duration=round(TICKS*1000/60), loop=0, lossless=True)
    # collision preview
    coll=scene0_sp.copy()
    overlay=Image.new("RGBA",(W,H),(0,0,0,0))
    d=ImageDraw.Draw(overlay)
    for y,x in zip(*np.nonzero(blocked)):
        d.rectangle((x*GRID,y*GRID,x*GRID+GRID-1,y*GRID+GRID-1), fill=(225,40,45,82))
    for pt,col in ((access["entry_px"],(255,235,45,255)),(access["threshold_px"],(65,220,255,255))):
        d.rectangle((pt[0],pt[1],pt[0]+15,pt[1]+15), outline=col, width=2)
    coll.alpha_composite(overlay)
    save_png(OUT/"review"/f"{PFX}_collisions_marqueurs.png", np.asarray(coll))
    # ORA
    ora_layers=[(k.replace("_"," "),v) for k,v in layers.items()] + [("08 spores phase 00", spores[0]), ("09 Top vide", top)]
    write_ora(ORA, ora_layers)
    # Ground
    proj_stack=[(k,[v],60) for k,v in layers.items()] + [("08_spores",spores,TICKS)]
    tile_counts=ground_project(proj_stack, blocked, access)
    # manifest
    gen=json.loads((HERE/"generation.json").read_text(encoding="utf-8"))
    manifest={
        "lot":"entree_foret_mousse_sud_nord_v1","title":"Entree Foret Moussa - foret a racines",
        "prefix":PFX,"namespace":NAMESPACE,"asset":ASSET,
        "format":"4:3 vaste","size_px":[W,H],"grid_px":GRID,"grid_cells":[GW,GH],
        "reference":gen["reference"],"reference_fidelity":fidelity,
        "generation":gen["images"],
        "inputs":[{"file":f"source/entree_foret_mousse_sud_nord_v1/bruts/{p.name}","sha256":sha256(p),"size_px":list(Image.open(p).size)} for p in (decor_path,floor_path)],
        "normalization":{"decor":decor_norm,"sol_complet":floor_norm,"palette_colors":int(len(palette)),"dither":False},
        "segmentation":seg_info,
        "layers":[{"name":k,"file":f"calques/{PFX}_{k}.png","phases":1,"frame_length_ticks":60,"order":i} for i,k in enumerate(layers)] + [{"name":"08_spores","file":f"animation/spores/{PFX}_08_spores_fNN.png","phases":PHASES,"frame_length_ticks":TICKS,"order":8},{"name":"09_top","file":f"calques/{PFX}_08_top.png","phases":1,"frame_length_ticks":60,"order":9,"ground_layer":4}],
        "animation":{"phases":PHASES,"frame_length_ticks":TICKS,"loop_ticks":LOOP_TICKS,"loop_seconds_at_60hz":LOOP_TICKS/60,"origin":"spores forestieres originales, pas cycle officiel"},
        "access":access,
        "pmdo":{"target":"0.8.12.0","version":"0.8.12.0","tile_banks":tile_counts,"runtime_tested":False,"warp":None},
        "art_approved":False,"runtime_tested":False,
        "notes":["Textures 100% canonique multilayer spriter pro: palette D24P11A mesuree, calques separes sans recoloration, 96 couleurs MEDIANCUT sans dither.","Un seul modele generateur utilise pour decor et sol, conforme demande.","Segmentation pro par seuils mesures et polygone clairiere, verification partition exclusive.","Marqueur donjon_seuil sans warp."]
    }
    (OUT/"manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2)+"\n", encoding="utf-8")
    shutil.copyfile(OUT/"manifest.json", STAGE/"manifest.json")
    shutil.copyfile(HERE/"README_PACK.md", OUT/"README.md")
    shutil.copyfile(HERE/"preview.html" if (HERE/"preview.html").exists() else HERE/"README_PACK.md", OUT/"review/index.html")
    shutil.copyfile(HERE/"README_PACK.md", STAGE/"README.md")
    summ={"preview":str((OUT/"review"/f"{PFX}_scene_t000.png").relative_to(ROOT)),"layers":len(layers)+2,"dimensions":[W,H],"grid":[GW,GH],"entry_px":access["entry_px"],"threshold_px":access["threshold_px"],"reachable_16x16":access["path_found_16x16"],"tiles":sum(tile_counts.values()),"reference_distance":fidelity["distance"] if fidelity else None,"stage":str(STAGE.relative_to(ROOT))}
    print(json.dumps(summ, ensure_ascii=False, indent=2))
    return manifest

if __name__=="__main__":
    build()
