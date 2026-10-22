# -*- coding: utf-8 -*-
"""Audit de positionnement des cinematiques.

   Verifie, pour chaque position ecrite en dur dans une scene :
     1. COLLISION   la case est-elle franchissable (Tags == 0) ?
     2. HORS CARTE  la position tient-elle dans la grille ?
     3. HORS CHAMP  l'entite est-elle dans le cadre camera du beat ?
     4. CHEVAUCHEMENT deux entites au meme endroit au meme moment ?
     5. TRAJECTOIRE un MoveToPosition traverse-t-il un mur ou une autre
                    entite immobile ?

   Le cadre camera de RogueEssence fait 320x240 px (ScreenWidth x Height
   du moteur). Une entite est consideree hors champ si son centre sort
   de ce rectangle centre sur la camera, avec une marge de 16 px pour
   tolerer les sprites de grande taille.
"""
import json, re, io, os, sys, collections

CAM_W, CAM_H = 320, 240
MARGE = 16

def load_map(name):
    p = f"work/gr/{name}.rsground"
    if not os.path.exists(p): return None
    o = json.loads(io.open(p, encoding='utf-8-sig').read())["Object"]
    ob = o["obstacles"]
    W, H = len(ob), len(ob[0])
    def free(x, y):
        cx, cy = x // 8, y // 8
        if not (0 <= cx < W and 0 <= cy < H): return None   # hors carte
        return ob[cx][cy].get("Tags", 0) == 0
    ents = {}
    for g in o.get("Entities", []):
        for k in ("MapChars", "GroundObjects", "Markers"):
            for e in (g.get(k) or []):
                nm = e.get("EntName")
                if not nm: continue
                loc = e.get("serializationLoc") or e.get("Collider") or {}
                ents[nm] = (loc.get("X"), loc.get("Y"))
    return dict(W=W, H=H, free=free, ents=ents, px=(W*8, H*8))

def bresenham(a, b):
    """Cases traversees entre deux points, en cellules de 8 px."""
    x0, y0 = a[0]//8, a[1]//8
    x1, y1 = b[0]//8, b[1]//8
    pts, dx, dy = [], abs(x1-x0), abs(y1-y0)
    sx = 1 if x0 < x1 else -1
    sy = 1 if y0 < y1 else -1
    err = dx - dy
    while True:
        pts.append((x0, y0))
        if x0 == x1 and y0 == y1: break
        e2 = 2*err
        if e2 > -dy: err -= dy; x0 += sx
        if e2 < dx:  err += dx; y0 += sy
    return pts

def scan(path, mapping):
    """mapping : {nom_fonction: nom_de_carte}"""
    src = io.open(path, encoding='utf-8').read()
    code = "\n".join(re.sub(r'--.*$', '', l)
                     for l in re.sub(r'--\[\[.*?\]\]', '', src, flags=re.S).splitlines())
    out = []
    for m in re.finditer(r'function\s+[\w.]*?(\w+)\s*\(.*?\n(.*?)\n(?:end|  \}\))', code, re.S):
        fn, body = m.group(1), m.group(2)
        gmap = mapping.get(fn)
        if not gmap: continue
        M = load_map(gmap)
        if M is None:
            out.append((fn, gmap, [("CARTE ABSENTE", gmap, None)])); continue
        pb = []
        # positions litterales : TeleportTo / MoveToPosition / MakeCharacters
        pos = []
        for mm in re.finditer(r"TeleportTo\(\s*(\w+),\s*(\d+),\s*(\d+)", body):
            pos.append(('teleport', mm.group(1), int(mm.group(2)), int(mm.group(3))))
        for mm in re.finditer(r"MoveToPosition\(\s*(\w+),\s*(\d+),\s*(\d+)", body):
            pos.append(('move', mm.group(1), int(mm.group(2)), int(mm.group(3))))
        for mm in re.finditer(r"\{'(\w+)',\s*(\d+),\s*(\d+),\s*Direction", body):
            pos.append(('spawn', mm.group(1), int(mm.group(2)), int(mm.group(3))))
        for mm in re.finditer(r"MoveCamera\(\s*(\d+),\s*(\d+)", body):
            pos.append(('camera', 'CAM', int(mm.group(1)), int(mm.group(2))))
        # 1+2 collision / hors carte
        for kind, who, x, y in pos:
            if kind == 'camera': continue
            f = M['free'](x, y)
            if f is None: pb.append(("HORS CARTE", f"{who} ({x},{y})", M['px']))
            elif not f:   pb.append(("CASE BLOQUEE", f"{who} ({x},{y})", None))
        # 4 chevauchement : memes coords pour deux entites differentes
        seen = collections.defaultdict(list)
        for kind, who, x, y in pos:
            if kind == 'camera': continue
            seen[(x, y)].append(who)
        for (x, y), whos in seen.items():
            u = sorted(set(whos))
            if len(u) > 1: pb.append(("CHEVAUCHEMENT", f"{u} en ({x},{y})", None))
        # 3 hors champ : chaque position vs la derniere camera posee avant
        cams = [(i, p) for i, p in enumerate(pos) if p[0] == 'camera']
        for i, (kind, who, x, y) in enumerate(pos):
            if kind == 'camera': continue
            prev = [c for j, c in cams if j < i]
            if not prev: continue
            _, _, cx, cy = prev[-1]
            if abs(x-cx) > CAM_W//2 + MARGE or abs(y-cy) > CAM_H//2 + MARGE:
                pb.append(("HORS CHAMP", f"{who} ({x},{y}) vs cam ({cx},{cy})", None))
        # 5 trajectoire
        statiques = {(x, y): who for kind, who, x, y in pos if kind == 'spawn'}
        for kind, who, x, y in pos:
            if kind != 'move': continue
            dep = None
            for k2, w2, x2, y2 in pos:
                if w2 == who and k2 in ('teleport', 'spawn'): dep = (x2, y2)
            if dep is None: continue
            for cx, cy in bresenham(dep, (x, y)):
                if M['free'](cx*8, cy*8) is False:
                    pb.append(("TRAJET DANS UN MUR", f"{who} {dep}->({x},{y}) case ({cx*8},{cy*8})", None))
                    break
        out.append((fn, gmap, pb))
    return out

if __name__ == "__main__":
    CIBLES = {
      'w2/Data/Script/halcyon/ChapterAftermath.lua': {
          'MarshVictory': 'forgotten_marsh_boss',
          'PeakVictory':  'autel_celeste',
      },
      'w2/Data/Script/halcyon/AccusationArc.lua': {
          'Scene1_Retour': 'metano_town', 'Scene2_Rumeur': 'metano_town',
          'Scene3_Discours': 'metano_town', 'Scene4_Plum': 'metano_town',
          'Scene5_GuildeProtege': 'metano_town', 'Scene6_Boycott': 'metano_town',
          'Scene7_Manifestation': 'metano_town', 'Scene9_Decision': 'metano_town',
          'Scene10a_Ville': 'metano_town_nuit', 'Scene10b_Carrefour': 'carrefour_nord',
      },
      'w2/Data/Script/halcyon/ground/bourg_comptoir/bourg_comptoir_ch_11.lua': {
          'ArrivalCutscene': 'bourg_comptoir', 'SetupGround': 'bourg_comptoir',
      },
      'w2/Data/Script/halcyon/ground/colline_anciens/init.lua': {
          'Scene': 'colline_anciens',
      },
    }
    total = 0
    for path, mapping in CIBLES.items():
        if not os.path.exists(path):
            print(f"!! {path} absent"); continue
        print(f"\n===== {path.split('/')[-1]}")
        for fn, gmap, pb in scan(path, mapping):
            if not pb:
                print(f"  OK   {fn:22} [{gmap}]")
            else:
                print(f"  !!   {fn:22} [{gmap}]")
                for t, d, extra in pb:
                    print(f"         {t:20} {d}" + (f"  carte {extra}" if extra else ""))
                    total += 1
    print(f"\n{total} anomalies de positionnement")
