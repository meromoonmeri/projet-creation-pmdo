import re,glob,os,collections
import xml.etree.ElementTree as ET
MOD=os.environ.get('MOD_ROOT', os.path.dirname(os.path.dirname(os.path.abspath(__file__)))); os.chdir(MOD)
KNOWN=re.compile(r'\[(?:pause=\d+|sound=[^\]]*|color=#[0-9a-fA-F]{6}|color|br|scroll|script=\d+|speed=[+-]?[\d.]+|emote=[\w\-]*|male|female|neutral|a/an|el/la|los/las|der/die/das|ein/eine/einen|ein/eine/ein|il/la|i/le|uno/una|은/는|을/를|이/가|와/과|으/로|이/라면)\]',re.I)
def unknown_tags(s):
    s2=KNOWN.sub('',s)
    return re.findall(r'\[[^\]\[]{1,20}\]',s2)
rows=[]
for p in glob.glob('Data/Script/**/strings*.resx',recursive=True):
    try: r=ET.parse(p).getroot()
    except: continue
    for n in r.findall('data'):
        v=n.findtext('value') or ''
        u=unknown_tags(v)
        if u: rows.append((os.path.relpath(p,MOD),n.get('name'),u,v[:70]))
lit=[]
for f in glob.glob('Data/Script/**/*.lua',recursive=True):
    t=open(f,encoding='utf-8',errors='replace').read()
    t=re.sub(r'--\[\[.*?\]\]','',t,flags=re.S); t=re.sub(r'--[^\n]*','',t)
    for m in re.finditer(r'(?:WaitShowDialogue|WaitShowVoiceOver|WaitShowTimedDialogue|StartConversation)\(\s*"((?:[^"\\]|\\.)*)"',t):
        u=unknown_tags(m.group(1))
        if u: lit.append((os.path.relpath(f,MOD),'(litteral)',u,m.group(1)[:70]))
allr=rows+lit
c=collections.Counter(t.lower() for r in allr for t in r[2])
print(f"### P. Balises non reconnues par Text.MsgTags/GrammarTags -> affichees telles quelles")
print(f"   {len(allr)} textes concernes, {len(c)} balises distinctes\n")
for k,v in c.most_common(20):
    ex=[r for r in allr if any(t.lower()==k for t in r[2])][0]
    print(f"   {k:22s} x{v:<4d}  ex {ex[0]} :: {ex[1]}")
    print(f"        « {ex[3]} »")
