#!/usr/bin/env python3
"""Dialogues anglais réellement VISIBLES en jeu.

Corrige la faiblesse de l'audit initial : on retire d'abord les commentaires Lua
(-- ligne et --[[ bloc ]]), afin de ne pas signaler du code mort.
"""
import os, re, json

ROOT = '/home/user/new-era-abyss-to-ascension-V2'
SCRIPT = os.path.join(ROOT, 'Data/Script/halcyon')

EN = re.compile(r"\b(the|you|your|would|like|what|with|have|this|that|and|for|are|was|"
                r"were|they|them|their|there|here|from|into|about|going|want|need|should|"
                r"could|can't|don't|didn't|it's|i'm|we're|let's|thanks|thank|sorry|hello|"
                r"okay|yes|maybe|really|very|just|please|team|received|earned|saved|game|"
                r"rank|item|items|storage|dungeon|leave|continue|cancel|nothing|change|"
                r"defeat|rescue|escort|arrest|find|deliver|back|head|home|room|floor|"
                r"one|two|all|some|more|then|than|been|will|can|get|got|now|not|but)\b", re.I)
ACC = re.compile(r"[àâäéèêëîïôöùûüçœÀÂÄÉÈÊËÎÏÔÖÙÛÜÇŒ]")
FR = re.compile(r"\b(le|la|les|un|une|des|du|de|et|est|vous|nous|tu|je|il|elle|on|ça|que|"
                r"qui|pour|dans|avec|pas|plus|mais|tout|tous|toute|bien|très|donjon|équipe|"
                r"objet|rang|partie|sauvegarde|quitter|annuler|rien|changer|trouver|livrer|"
                r"escorter|arrêter|secourir|retour|maison|au|aux|ce|cette|son|sa|ses|nos)\b", re.I)


def strip_comments(src):
    """Retire commentaires Lua en préservant la numérotation des lignes."""
    out, inblock = [], False
    for line in src.split('\n'):
        if inblock:
            if ']]' in line:
                inblock = False
                line = line.split(']]', 1)[1]
            else:
                out.append(''); continue
        while '--[[' in line:
            before, after = line.split('--[[', 1)
            if ']]' in after:
                line = before + after.split(']]', 1)[1]
            else:
                line = before; inblock = True; break
        # -- ligne, en ignorant les -- à l'intérieur d'une chaîne
        res, i, q = [], 0, None
        while i < len(line):
            c = line[i]
            if q:
                if c == '\\':
                    res.append(line[i:i+2]); i += 2; continue
                if c == q:
                    q = None
                res.append(c); i += 1; continue
            if c in '"\'':
                q = c; res.append(c); i += 1; continue
            if c == '-' and i + 1 < len(line) and line[i+1] == '-':
                break
            res.append(c); i += 1
        out.append(''.join(res))
    return '\n'.join(out)


def english(s):
    st = s.strip()
    if len(st) < 8 or ACC.search(st) or FR.search(st):
        return False
    if re.fullmatch(r"[\W\d_\[\]=]+", st):
        return False
    return len(EN.findall(st)) >= 2


UI = re.compile(r"(UI:WaitShowDialogue|UI:ShowDialogue|UI:WaitShowTimedDialogue|"
                r"UI:BeginChoiceMenu|UI:ChoiceMenuYesNo|UI:WaitShowTitle|"
                r"UI:WaitShowVoiceOver|UI:SetSpeakerName|_MENU:SetDialogue)\s*\(")

hits = []
for dp, dn, fn in os.walk(SCRIPT):
    for f in sorted(fn):
        if not f.endswith('.lua'):
            continue
        p = os.path.join(dp, f)
        rel = os.path.relpath(p, ROOT)
        if '/test' in rel or 'testmap' in rel or 'debug_tools' in rel:
            continue
        clean = strip_comments(open(p, encoding='utf-8', errors='replace').read())
        for m in UI.finditer(clean):
            ln = clean.count('\n', 0, m.start()) + 1
            i, depth, buf = m.end(), 1, []
            while i < len(clean) and depth and len(buf) < 3000:
                c = clean[i]
                if c == '(':
                    depth += 1
                elif c == ')':
                    depth -= 1
                    if not depth:
                        break
                buf.append(c); i += 1
            for sm in re.finditer(r'"((?:[^"\\]|\\.)*)"', ''.join(buf)):
                if english(sm.group(1)):
                    hits.append((rel, ln, m.group(1), sm.group(1)))

print('=== Dialogues anglais VISIBLES (hors commentaires) : %d ===\n' % len(hits))
byfile = {}
for rel, ln, call, s in hits:
    byfile.setdefault(rel, []).append((ln, call, s))
for rel in sorted(byfile, key=lambda r: -len(byfile[r])):
    print('%s  (%d)' % (rel, len(byfile[rel])))
    for ln, call, s in byfile[rel]:
        print('   L%-5d %s' % (ln, s[:120]))
    print()
json.dump([{'file': r, 'line': l, 'call': c, 'text': s} for r, l, c, s in hits],
          open('/home/user/dialogues_todo.json', 'w', encoding='utf-8'),
          ensure_ascii=False, indent=1)
print('-> /home/user/dialogues_todo.json')
