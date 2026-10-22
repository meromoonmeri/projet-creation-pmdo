# -*- coding: utf-8 -*-
"""Verifie les regles de redaction sur les TEXTES AFFICHES uniquement.

   Un scan naif du fichier entier produit des faux positifs : les
   commentaires d'en-tete citent justement les mots interdits pour
   rappeler la regle. On n'inspecte donc que les chaines effectivement
   passees a une fonction d'affichage.
"""
import re,sys,json

VALID_EMOTION={'Normal','Happy','Pain','Angry','Worried','Sad','Crying','Shouting',
 'Teary-Eyed','Determined','Joyous','Inspired','Surprised','Dizzy','Sigh','Stunned',
 'Special0','Special1','Special2','Special3','Special4'}
VALID_EMOTE={'happy','sweating','glowing','exclaim','shock','notice','sweatdrop',
 'eating','angry','question'}
FORBIDDEN=["Abîme","Abime","Necrozma","Eternatus"]

def strip_comments(src):
    src=re.sub(r'--\[\[.*?\]\]','',src,flags=re.S)
    return "\n".join(re.sub(r'--.*$','',l) for l in src.splitlines())

def displayed(src):
    """Chaines affichees au joueur : say/think/narrate/crowd/WaitShowDialogue."""
    out=[]
    for pat in (r'WaitShowDialogue\(\s*"((?:[^"\\]|\\.)*)"',
                r'(?:say|think)\([^,]+,\s*(?:nil|\'[^\']*\'),\s*"((?:[^"\\]|\\.)*)"',
                r'(?:narrate|crowd)\(\s*"((?:[^"\\]|\\.)*)"'):
        out+=re.findall(pat,src)
    return out

def check(path):
    raw=open(path,encoding='utf-8').read()
    code=strip_comments(raw)
    pb=[]
    for e in re.findall(r"(?:say|think)\([^,]+,\s*'([^']+)'",code):
        if e not in VALID_EMOTION: pb.append(f"emotion de portrait invalide : '{e}'")
    for e in re.findall(r'CharSetEmote\([^,]+,\s*"([^"]+)"',code):
        if e and e not in VALID_EMOTE: pb.append(f"emote de bulle invalide : '{e}'")
    for e in re.findall(r'murmur\([^,]+,\s*"([^"]+)"',code):
        if e not in VALID_EMOTE: pb.append(f"emote de bulle invalide (murmur) : '{e}'")
    txts=displayed(code)
    for t in txts:
        net=re.sub(r'\[pause=\d+\]','',t)
        if len(net)>150: pb.append(f"replique {len(net)} car. : {net[:60]}...")
        for w in FORBIDDEN:
            if re.search(rf'\b{w}\b',t): pb.append(f"mot interdit '{w}' dans : {net[:60]}")
    return len(txts),pb

if __name__=="__main__":
    total=0; bad=0
    for p in sys.argv[1:]:
        n,pb=check(p); total+=n
        print(f"{p}  ({n} repliques affichees)")
        for x in pb: print("   ANOMALIE:",x); 
        bad+=len(pb)
        if not pb: print("   conforme")
    print(f"\n{total} repliques verifiees, {bad} anomalies")
