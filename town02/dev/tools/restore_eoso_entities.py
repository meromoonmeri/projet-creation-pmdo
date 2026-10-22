# -*- coding: utf-8 -*-
"""Restaure dans les .rsground New Era les entites supprimees a l'import,
   en reprenant les coordonnees exactes des sources EoSO.

   - Preserve BOM / indentation par fichier (round-trip prouve avant ecriture).
   - N'ecrase JAMAIS une entite deja presente (compare par EntName).
   - Applique la table d'evolution 10/15 ans sur les MapChars.
   - Ne touche pas aux Layers ni aux obstacles : la geometrie reste intacte.
"""
import json,os,sys,copy

GR="work/gr"; SRC="work/src"

# ground NEA -> source EoSO
PAIRS={
 "bourg_comptoir":"treasure_town",
 "guilde_parvis":"guild_outside",
 "guilde_sous_sol":"guild_basement",
 "carrefour_assemblee":"crossroads_assembly",
 "carrefour_sud":"crossroads_south",
 "dojo_ossatueur":"marowak_dojo",
 "cap_dents_mer":"habitat_sharpedo_bluff_day",
 "plage_lucioles":"beach",
}

# 10/15 ans plus tard. None = inchange.
EVOLUTION={
 "bidoof":"bibarel", "azurill":"marill", "marill":"azumarill",
 "drowzee":"hypno", "duskull":"dusclops", "shuppet":"banette",
 "wurmple":"beautifly", "seedot":"nuzleaf", "pidgey":"pidgeot",
 "corphish":"crawdaunt", "vigoroth":"slaking",
 # murkrow -> honchkrow IMPOSSIBLE (espece absente du projet) : inchange.
}
# renommage d'entite induit par l'evolution (le nom d'entite sert de cle Lua)
RENAME={"Bidoof":"Bibarel","Azurill":"Marill_Jeune","Marill":"Azumarill",
        "Drowzee":"Hypno","Duskull":"Dusclops","Shuppet":"Banette",
        "Wurmple":"Beautifly","Seedot":"Nuzleaf","Pidgey":"Pidgeot",
        "Corphish":"Crawdaunt","Vigoroth":"Slaking"}

KINDS=("MapChars","GroundObjects","Spawners","Markers")

def read(path):
    b=open(path,'rb').read()
    bom = b[:3]==b'\xef\xbb\xbf'
    s=b.decode('utf-8-sig')
    o=json.loads(s)
    ind=None
    for i in (0,1,2,3,4):
        if json.dumps(o,ensure_ascii=False,indent=i)==s: ind=i;break
    if ind is None: raise SystemExit(f"{path}: round-trip impossible, ecriture interdite")
    return o,bom,ind

def write(path,o,bom,ind):
    s=json.dumps(o,ensure_ascii=False,indent=ind)
    open(path,'wb').write((('\ufeff' if bom else '')+s).encode('utf-8'))

def names(layer,kind):
    out=set()
    for e in (layer.get(kind) or []):
        n=e.get("EntName") or e.get("NPCName")
        if n: out.add(n)
    return out

def restore(ne,eo,apply_evo,report):
    dst,bom,ind=read(f"{GR}/{ne}.rsground")
    src,_,_    =read(f"{SRC}/{eo}.rsground")
    if not dst.get("Object",{}).get("Entities"):
        dst["Object"]["Entities"]=[{"Name":"New EntLayer","Visible":True,
            "MapChars":[],"GroundObjects":[],"Spawners":[],"Markers":[]}]
    D=dst["Object"]["Entities"][0]
    S=src["Object"]["Entities"][0]
    for k in KINDS: D.setdefault(k,[])
    added={k:[] for k in KINDS}; evolved=[]
    for k in KINDS:
        have=names(D,k)
        for e in (S.get(k) or []):
            nm=e.get("EntName") or e.get("NPCName")
            if not nm or nm in have: continue
            c=copy.deepcopy(e)
            if k=="MapChars" and apply_evo:
                sp=(c.get("Data") or {}).get("BaseForm",{}).get("Species")
                new=EVOLUTION.get(sp)
                if new:
                    c["Data"]["BaseForm"]["Species"]=new
                    old=c.get("EntName")
                    c["EntName"]=RENAME.get(old,old)
                    evolved.append(f"{old}({sp}) -> {c['EntName']}({new})")
            D[k].append(c); added[k].append(c.get("EntName") or c.get("NPCName"))
    tot=sum(len(v) for v in added.values())
    if tot:
        write(f"{GR}/{ne}.rsground",dst,bom,ind)
        # relecture de controle
        chk,_,_=read(f"{GR}/{ne}.rsground")
        C=chk["Object"]["Entities"][0]
        assert all(len(C.get(k,[]))==len(D[k]) for k in KINDS), "relecture incoherente"
        assert chk["Object"]["obstacles"]==dst["Object"]["obstacles"], "collisions modifiees !"
    report.append(dict(ground=ne,source=eo,added=added,total=tot,evolved=evolved))
    return tot

def main():
    rep=[]
    for ne,eo in PAIRS.items():
        if not os.path.exists(f"{SRC}/{eo}.rsground"):
            print(f"  -- {ne}: source absente, ignore");continue
        n=restore(ne,eo,ne=="bourg_comptoir",rep)
        print(f"  {ne:22} +{n:3} entites")
    json.dump(rep,open('/tmp/restore_report.json','w'),ensure_ascii=False,indent=1)
    for r in rep:
        if r['total']==0: continue
        print(f"\n== {r['ground']}")
        for k,v in r['added'].items():
            if v: print(f"   {k}: {v}")
        for e in r['evolved']: print(f"   EVOLUTION {e}")
main()
