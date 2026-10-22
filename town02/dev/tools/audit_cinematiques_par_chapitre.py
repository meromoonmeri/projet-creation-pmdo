# -*- coding: utf-8 -*-
"""Recense les cinematiques par chapitre et mesure leur mise en scene.

   Une CINEMATIQUE = une fonction Lua qui contient >= 6 boites de dialogue
   ET qui passe en CutsceneMode, ou qui est appelee par un flux de chapitre.
   Un echange de PNJ de 2 repliques n'est pas une cinematique.

   QUALITATIVE = la scene a une mise en scene reelle, mesuree sur les
   criteres du guide (section 5) : camera, deplacement, orientation,
   animation. Le seuil retenu : au moins 3 des 4 familles presentes.
"""
import os, re, sys, json, collections

ROOT = 'Data/Script/halcyon'

DIALOG = re.compile(r'WaitShowDialogue|StartConversation|WaitShowTimedDialogue'
                    r'|(?<![\w.])(?:say|think|crowd|narrate|line|voice)\(')
CAMERA = re.compile(r'MoveCamera|MoveScreen|GetCameraCenter')
MOVE   = re.compile(r'EightWayMove|MoveToPosition|AnimateToPosition|TeleportTo')
TURN   = re.compile(r'CharAnimateTurnTo|CharTurnToCharAnimated|CharAnimateTurn|TurnTowardsLocation|EntTurn')
ANIM   = re.compile(r'CharSetAnim|CharWaitAnim|CharSetEmote|SetEmotion|AnimateInDirection')
SOUND  = re.compile(r'PlayBGM|PlaySE|PlayBattleSE|FadeOutBGM|StopBGM')
WAIT   = re.compile(r'WaitFrames')
NARR_IN= re.compile(r'(?<![\w.])narrate\(|UI:SetCenter\(true\)')
CUTSC  = re.compile(r'CutsceneMode\(true\)')

def scenes_of(src):
    """Decoupe un fichier en fonctions Lua de premier niveau."""
    out=[]
    for m in re.finditer(r'\nfunction\s+([\w.:]+)\s*\(([^)]*)\)', src):
        name=m.group(1); start=m.end()
        depth=1; i=start
        tok=re.compile(r'\b(function|if|for|while|do|end)\b')
        for t in tok.finditer(src, start):
            w=t.group(1)
            if w in ('function','if','for','while'): 
                if w!='if' or True: depth+=1
            elif w=='end': depth-=1
            if depth==0: i=t.start(); break
        else: i=len(src)
        out.append((name, src[start:i]))
    return out

def chapter_of(path, body):
    m=re.search(r'_ch_(\d+)\.lua$', path)
    if m: return int(m.group(1))
    m=re.search(r'Chapter(\d+)|Chapitre\s*(\d+)', body)
    if m: return int(m.group(1) or m.group(2))
    return None

rows=[]
for dirpath,_,files in os.walk(ROOT):
    for fn in files:
        if not fn.endswith('.lua'): continue
        p=os.path.join(dirpath,fn)
        src=open(p,encoding='utf-8',errors='replace').read()
        fch=chapter_of(p,'')
        for name,body in scenes_of(src):
            nd=len(DIALOG.findall(body))
            if nd<6: continue
            ch=fch if fch else chapter_of(p,body)
            fam=sum(1 for r in (CAMERA,MOVE,TURN,ANIM) if r.search(body))
            rows.append(dict(file=p.replace(ROOT+'/',''), fn=name, ch=ch, dial=nd,
                cam=len(CAMERA.findall(body)), mov=len(MOVE.findall(body)),
                turn=len(TURN.findall(body)), anim=len(ANIM.findall(body)),
                snd=len(SOUND.findall(body)), wait=len(WAIT.findall(body)),
                narr=len(NARR_IN.findall(body)), fam=fam,
                cutscene=bool(CUTSC.search(body))))
json.dump(rows,open('/tmp/scenes.json','w'))
print("scenes >=6 boites :",len(rows))
