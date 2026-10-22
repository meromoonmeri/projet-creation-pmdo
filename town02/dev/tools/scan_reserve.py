# -*- coding: utf-8 -*-
"""Scan .rsground depuis GitHub : dimensions reelles, coherence TexSize,
   collisions, connexite du walkable, entites (spawners/markers/objets)."""
import urllib.request,json,sys,os,collections,concurrent.futures as cf
T=os.environ["GHT"]
BASE="https://raw.githubusercontent.com/meromoonmeri/new-era-abyss-to-ascension-V4/new-era-1-9/Data/Ground/"
def get(n):
    return urllib.request.urlopen(urllib.request.Request(BASE+n+".rsground",
        headers={"Authorization":"token "+T}),timeout=180).read()

def largest_component(ob,ow,oh):
    """ob[x][y] ; libre = Tags==0. Retourne (taille plus grande zone, nb zones, nb libres)."""
    free=[[ob[x][y].get("Tags",0)==0 for y in range(oh)] for x in range(ow)]
    seen=[[False]*oh for _ in range(ow)]
    best=0;comps=0;tot=0
    for x in range(ow):
        for y in range(oh):
            if free[x][y]: tot+=1
            if free[x][y] and not seen[x][y]:
                comps+=1;n=0;st=[(x,y)];seen[x][y]=True
                while st:
                    cx,cy=st.pop();n+=1
                    for dx,dy in((1,0),(-1,0),(0,1),(0,-1)):
                        nx,ny=cx+dx,cy+dy
                        if 0<=nx<ow and 0<=ny<oh and free[nx][ny] and not seen[nx][ny]:
                            seen[nx][ny]=True;st.append((nx,ny))
                best=max(best,n)
    return best,comps,tot

def analyse(n):
    raw=get(n); o=json.loads(raw.decode("utf-8-sig"))["Object"]
    tex=o.get("TexSize",1)
    L=o.get("Layers",[]);tw=th=0;tilesets=collections.Counter();drawn=0
    for l in L:
        t=l.get("Tiles") or []
        tw=max(tw,len(t)); th=max(th,len(t[0]) if t else 0)
        for col in t:
            for c in col:
                for lay in (c.get("Layers") or []):
                    for fr in (lay.get("Frames") or []):
                        sh=fr.get("Sheet")
                        if sh: tilesets[sh]+=1; drawn+=1
    ob=o.get("obstacles",[]);ow=len(ob);oh=len(ob[0]) if ow else 0
    best,comps,free=largest_component(ob,ow,oh) if ow else (0,0,0)
    ents=collections.Counter();names=[]
    for g in o.get("Entities",[]):
        for k in("MapChars","GroundObjects","Spawners","Markers"):
            v=g.get(k) or []
            ents[k]+=len(v)
            for e in v:
                names.append((k,e.get("EntName") or e.get("NPCName") or "?"))
    return dict(name=n,bytes=len(raw),texsize=tex,
        tile_w=tw,tile_h=th,ob_w=ow,ob_h=oh,
        px_w=ow*8,px_h=oh*8,
        coherent=(ow==tw*tex and oh==th*tex),
        free=free,cells=ow*oh,pct_free=round(100*free/(ow*oh),1) if ow*oh else None,
        main_zone=best,zones=comps,
        isolated=free-best,
        drawn=drawn,n_tilesets=len(tilesets),tilesets=[k for k,_ in tilesets.most_common(5)],
        music=o.get("Music"),released=o.get("Released"),
        ents=dict(ents),ent_names=names[:20],
        comment=(o.get("Comment") or "")[:160])
def _safe(n):
    try: return analyse(n)
    except Exception as e: return dict(name=n,error=repr(e)[:200])
if __name__=="__main__":
    names=[l.strip() for l in open(sys.argv[1]) if l.strip()]
    with cf.ThreadPoolExecutor(8) as ex: out=list(ex.map(_safe,names))
    json.dump(out,open(sys.argv[2],"w"),ensure_ascii=False,indent=1)
    print("ok",sum(1 for x in out if 'error' not in x),"/",len(out))
