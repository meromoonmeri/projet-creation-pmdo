import re,glob,os,collections
MOD=os.environ.get('MOD_ROOT', os.path.dirname(os.path.dirname(os.path.abspath(__file__)))); os.chdir(MOD)
# build global function bodies index across whole mod
bodies={}
for f in glob.glob('Data/Script/**/*.lua',recursive=True):
    t=open(f,encoding='utf-8',errors='replace').read()
    t=re.sub(r'--\[\[.*?\]\]','',t,flags=re.S); t=re.sub(r'--[^\n]*','',t)
    for m in re.finditer(r'function\s+([\w\.:]+)\s*\([^)]*\)(.*?)\n(?:end)\b',t,re.S):
        bodies.setdefault(m.group(1),[]).append((os.path.relpath(f,MOD),m.group(2)))
def resolves(fn,depth=0,seen=None):
    seen=seen or set()
    if fn in seen or depth>5: return False
    seen.add(fn)
    for _,b in bodies.get(fn,[]):
        if re.search(r'CutsceneMode\(\s*false\s*\)',b): return True
        if re.search(r'EnterGroundMap|EnterDungeon|EnterZone|ContinueDungeon|EndDungeonRun|RestartToTitle',b): return True
        for m in re.finditer(r'\b([\w]+)\.(\w+)\s*\(',b):
            c=m.group(1)+'.'+m.group(2)
            if c in bodies and resolves(c,depth+1,seen): return True
    return False
bad=[]
for fn,lst in bodies.items():
    for path,b in lst:
        if re.search(r'CutsceneMode\(\s*true\s*\)',b) and not re.search(r'CutsceneMode\(\s*false\s*\)',b):
            if re.search(r'EnterGroundMap|EnterDungeon|EnterZone|ContinueDungeon|EndDungeonRun|RestartToTitle',b): continue
            # follow calls
            ok=False
            for m in re.finditer(r'\b([\w]+)\.(\w+)\s*\(',b):
                c=m.group(1)+'.'+m.group(2)
                if c in bodies and resolves(c,1,{fn}): ok=True;break
            if not ok: bad.append((path,fn))
print("### K1(affine). CutsceneMode(true) sans desarmement atteignable (suivi d'appels prof. 5)")
print(f"   {len(bad)} fonctions\n")
for p,f in sorted(bad): print(f"   {p} :: {f}")
