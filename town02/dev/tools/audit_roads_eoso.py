# -*- coding: utf-8 -*-
"""Extrait le graphe de Roads canonique d'EoSO et verifie que chaque
   destination (map, marqueur) existe reellement dans les .rsground source."""
import re,os,json,glob,urllib.request,sys
REF="/home/user/reference/eoso"
CACHE="/tmp/eoso_ground_cache.json"
T=os.environ.get("GHT","")
RAW="https://raw.githubusercontent.com/Minemaker0430/ExplorersOfSkyOrigins/main/Data/Ground/"

def ground_markers(name, cache):
    """Retourne l'ensemble des noms d'entites (marqueurs+objets+PNJ) d'un ground."""
    if name in cache: return set(cache[name])
    try:
        d=urllib.request.urlopen(urllib.request.Request(RAW+name+".rsground",
            headers={"Authorization":"token "+T}),timeout=180).read().decode("utf-8-sig")
        o=json.loads(d)["Object"]
    except Exception:
        cache[name]=None; return None
    s=set()
    for g in o.get("Entities",[]):
        for k in ("MapChars","GroundObjects","Spawners","Markers"):
            for e in (g.get(k) or []):
                n=e.get("EntName") or e.get("NPCName")
                if n: s.add(n)
    cache[name]=sorted(s); return s

def main():
    cache=json.load(open(CACHE)) if os.path.exists(CACHE) else {}
    # noms de grounds reellement presents dans EoSO
    tree=json.load(open('/tmp/eoso_tree.json'))
    real={x.split('/')[-1].replace('.rsground','') for x in tree if x.startswith('Data/Ground/')}
    reall={r.lower():r for r in real}
    pat=re.compile(r'(?:GAME|GROUND):EnterGroundMap\(\s*([\'"])([^\'"]+)\1\s*(?:,\s*([\'"])([^\'"]+)\3)?\s*(?:,\s*([\'"])([^\'"]+)\5)?')
    roads=[]
    for f in sorted(glob.glob(REF+"/ground/*/init.lua")):
        src=os.path.basename(os.path.dirname(f))
        for i,line in enumerate(open(f,encoding='utf-8',errors='replace'),1):
            if line.lstrip().startswith('--'): continue
            m=pat.search(line)
            if not m: continue
            a,b,c=m.group(2),m.group(4),m.group(6)
            # forme zone,map,marker  ou  map,marker
            if c is not None: zone,dest,mark=a,b,c
            elif a in ("hub","cutscenes") and b: zone,dest,mark=a,b,None
            else: zone,dest,mark=None,a,b
            roads.append(dict(src=src,line=i,zone=zone,dest=dest,marker=mark))
    print(f"{len(roads)} transitions trouvees dans {len(set(r['src'] for r in roads))} grounds\n")
    prob=[]
    for r in roads:
        d=r['dest']; key=reall.get(d.lower())
        if key is None:
            r['status']="MAP INEXISTANTE"; prob.append(r); continue
        mk=ground_markers(key,cache)
        if mk is None: r['status']="illisible"; continue
        if r['marker'] and r['marker'] not in mk:
            r['status']="MARQUEUR ABSENT"; prob.append(r)
        else: r['status']="ok"
    json.dump(cache,open(CACHE,'w'))
    json.dump(roads,open('/tmp/eoso_roads.json','w'),indent=1)
    ok=sum(1 for r in roads if r['status']=="ok")
    print(f"valides {ok} | anomalies {len(prob)}\n")
    for r in prob:
        print(f"  {r['src']}:{r['line']:5} -> {r['dest']!r} marqueur={r['marker']!r} : {r['status']}")
main()
