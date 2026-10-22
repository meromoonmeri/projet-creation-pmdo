# -*- coding: utf-8 -*-
"""Compare chaque ground importe de New Era avec sa source EoSO :
   geometrie, collisions, tilesets, entites. Prouve ce qui a ete perdu."""
import urllib.request,json,os,collections,concurrent.futures as cf,sys
T=os.environ["GHT"]
EO="https://raw.githubusercontent.com/Minemaker0430/ExplorersOfSkyOrigins/main/Data/Ground/"
NE="https://raw.githubusercontent.com/meromoonmeri/new-era-abyss-to-ascension-V4/new-era-1-9/Data/Ground/"

def load(base,name):
    d=urllib.request.urlopen(urllib.request.Request(base+name+".rsground",
        headers={"Authorization":"token "+T}),timeout=300).read()
    return json.loads(d.decode("utf-8-sig"))["Object"]

def profile(o):
    ob=o.get("obstacles",[]);W=len(ob);H=len(ob[0]) if W else 0
    blocked=sum(1 for c in ob for x in c if x.get("Tags",0))
    ts=collections.Counter();drawn=0
    for l in o.get("Layers",[]):
        for col in l.get("Tiles") or []:
            for c in col:
                for ly in c.get("Layers") or []:
                    for fr in ly.get("Frames") or []:
                        if fr.get("Sheet"): ts[fr["Sheet"]]+=1;drawn+=1
    ents=collections.Counter();names=collections.defaultdict(list)
    for g in o.get("Entities",[]):
        for k in ("MapChars","GroundObjects","Spawners","Markers"):
            for e in (g.get(k) or []):
                ents[k]+=1
                names[k].append(e.get("EntName") or e.get("NPCName"))
    return dict(W=W,H=H,tex=o.get("TexSize"),blocked=blocked,
        pct=round(100*blocked/(W*H),1) if W*H else None,
        drawn=drawn,tilesets=dict(ts),ents=dict(ents),
        names={k:sorted(v) for k,v in names.items()},
        music=o.get("Music"))

def compare(pair):
    ne,eo=pair
    try: A=profile(load(EO,eo))
    except Exception as e: return dict(ne=ne,eo=eo,error="source EoSO illisible: "+repr(e)[:80])
    try: B=profile(load(NE,ne))
    except Exception as e: return dict(ne=ne,eo=eo,error="ground NEA illisible: "+repr(e)[:80])
    d=[]
    if (A['W'],A['H'])!=(B['W'],B['H']): d.append(f"grille {A['W']}x{A['H']} -> {B['W']}x{B['H']}")
    if A['blocked']!=B['blocked']: d.append(f"collisions {A['blocked']} -> {B['blocked']}")
    if A['drawn']!=B['drawn']: d.append(f"tuiles {A['drawn']} -> {B['drawn']}")
    if set(A['tilesets'])!=set(B['tilesets']): d.append(f"tilesets {sorted(A['tilesets'])} -> {sorted(B['tilesets'])}")
    for k in ("MapChars","GroundObjects","Spawners","Markers"):
        a,b=A['ents'].get(k,0),B['ents'].get(k,0)
        if a!=b:
            perdus=sorted(set(A['names'].get(k,[]))-set(B['names'].get(k,[])))
            d.append(f"{k} {a} -> {b}"+(f" perdus={perdus}" if perdus else ""))
    return dict(ne=ne,eo=eo,src=A,dst=B,diffs=d)

if __name__=="__main__":
    pairs=json.load(open(sys.argv[1]))
    with cf.ThreadPoolExecutor(6) as ex: res=list(ex.map(compare,pairs))
    json.dump(res,open(sys.argv[2],'w'),ensure_ascii=False,indent=1)
    idem=0
    for r in res:
        if r.get("error"): print(f"!! {r['ne']:26} {r['error']}");continue
        if not r['diffs']: idem+=1;continue
        print(f"== {r['ne']:26} (source {r['eo']})")
        for x in r['diffs']: print("     -",x)
    print(f"\n{idem}/{len(res)} identiques a la source")
