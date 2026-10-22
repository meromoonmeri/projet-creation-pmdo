import re,glob,os,json,collections
MOD=os.environ.get('MOD_ROOT', os.path.dirname(os.path.dirname(os.path.abspath(__file__)))); os.chdir(MOD)
static={}
for p in glob.glob('Data/Ground/*.rsground'):
    g=os.path.basename(p)[:-9]
    e=json.load(open(p,encoding='utf-8-sig'))['Object']['Entities'][0]
    s=set()
    for k in ('MapChars','GroundObjects'):
        for x in e.get(k,[]):
            if x.get('triggerType') in (1,2,3):
                n=x.get('EntName') or x.get('NPCName')
                if n: s.add(n+('_Action' if x['triggerType']==1 else '_Touch'))
    static[g]=s
rows=[]
for d in sorted(glob.glob('Data/Script/*/ground/*/')):
    g=os.path.basename(d.rstrip('/'))
    init=os.path.join(d,'init.lua')
    if not os.path.exists(init) or g not in static: continue
    t=open(init,encoding='utf-8',errors='replace').read()
    dyn={f for _,f in re.findall(r'load\("(\w+)_ch_"\s*\.\.\s*tostring\(SV\.ChapterProgression\.Chapter\)\s*\.\.\s*"\.(\w+)\(',t)}
    inter=sorted(dyn & static[g])
    if not inter: continue
    have={int(re.search(r'_ch_(\d+)\.lua$',p).group(1)) for p in glob.glob(d+f'{g}_ch_*.lua')}
    gaps=[c for c in range(1,11) if c not in have]
    if gaps: rows.append((g,sorted(have),gaps,inter))
print("### X2. PNJ/objet PERMANENT de la carte (.rsground, trigger 1/2/3) aiguille dynamiquement,")
print("        vers un fichier de chapitre INEXISTANT -> muet a ces chapitres\n")
for g,have,gaps,inter in rows:
    print(f"   {g:26s} ch presents {have}  MUET aux ch{gaps}")
    print(f"        entites concernees : {inter}")
print(f"\n   {len(rows)} cartes")
