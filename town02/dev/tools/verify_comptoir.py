# -*- coding: utf-8 -*-
"""Verifie le lot Bourg du Comptoir :
   1. chaque handler <Nom>_Action/_Touch a une entite du meme nom sur la carte
   2. chaque entite interactive (trig 1 ou 2) a un handler
   3. chaque EnterGroundMap vise une carte + un marqueur qui existent
   4. tout marqueur cible est sur une case franchissable
"""
import json,re,os,glob

GR="work/gr"; SC="w2/Data/Script/halcyon/ground"
LOT=["bourg_comptoir","carrefour_assemblee","carrefour_sud","cap_dents_mer",
     "dojo_ossatueur","guilde_parvis","plage_lucioles"]

def load(n):
    o=json.loads(open(f"{GR}/{n}.rsground",encoding='utf-8-sig').read())["Object"]
    ob=o["obstacles"];W=len(ob);H=len(ob[0])
    L=o["Entities"][0]
    ents={}; marks={}
    for k in ("MapChars","GroundObjects","Markers"):
        for e in (L.get(k) or []):
            nm=e.get("EntName")
            if not nm: continue
            if k=="Markers":
                c=e["Collider"]; marks[nm]=(c["X"],c["Y"])
            else:
                ents[nm]=e.get("triggerType",0)
    free=lambda x,y:0<=x//8<W and 0<=y//8<H and ob[x//8][y//8].get("Tags",0)==0
    return ents,marks,free

def src(n):
    p=f"{SC}/{n}/init.lua"
    return open(p,encoding='utf-8').read() if os.path.exists(p) else ""

def src_all(n):
    """init.lua + tous les fichiers de chapitre du meme ground."""
    return "".join(open(f,encoding='utf-8').read()
                   for f in sorted(glob.glob(f"{SC}/{n}/*.lua")))

def main():
    maps={n:load(n) for n in LOT}
    pb=[]
    for n in LOT:
        ents,marks,free=maps[n]
        s=src(n)
        # handlers explicites
        # forme 1 : function mod.Nom_Action(...)
        h=set(re.findall(r'function\s+\w+\.(\w+)_(?:Action|Touch)\s*\(',s))
        # forme 2 : mod.Nom_Action = <expression>  (panneaux, fabriques)
        h|=set(re.findall(r'^\s*\w+\.(\w+)_(?:Action|Touch)\s*=',s,re.M))
        # forme 3 : mod[nom .. '_Action'] = ... alimente par une liste
        # handlers generes par boucle (liste HABITANTS)
        m=re.search(r"local HABITANTS = \{(.*?)\}",s,re.S)
        if m: h|=set(re.findall(r"'([^']+)'",m.group(1)))
        for nm,trig in ents.items():
            if trig in (1,2) and nm not in h:
                pb.append(f"{n}: entite interactive SANS handler -> {nm} (trig {trig})")
        # Entites creees a l'execution par MakeCharactersFromList : elles
        # n'existent pas dans le .rsground, c'est normal.
        runtime=set(re.findall(r"MakeCharactersFromList\(\{\s*\{'(\w+)'",src_all(n)))
        for nm in h:
            if nm not in ents and nm not in runtime:
                pb.append(f"{n}: handler SANS entite -> {nm}")
        # transitions
        for dest,mark in re.findall(r'EnterGroundMap\("([^"]+)",\s*"([^"]+)"\)',s):
            if dest in maps:
                _,dm,dfree=maps[dest]
                if mark not in dm:
                    pb.append(f"{n}: -> {dest} marqueur INEXISTANT '{mark}'")
                elif not dfree(*dm[mark]):
                    pb.append(f"{n}: -> {dest}@{mark} marqueur BLOQUE {dm[mark]}")
                else:
                    print(f"  ROAD ok  {n:20} -> {dest:20} @ {mark}")
            else:
                print(f"  ROAD ext {n:20} -> {dest:20} @ {mark}  (hors lot, non verifie)")
    print()
    if pb:
        print(f"{len(pb)} ANOMALIES :")
        for x in pb: print("   -",x)
    else:
        print("aucune anomalie")
main()
