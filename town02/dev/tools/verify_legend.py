#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Verification bout-en-bout du stand de Grodoudou.
Regle de preuve : (1) le fichier existe, (2) il est reellement appele par le
jeu, chaine tracee sans saut d'etape, (3) ce qu'il appelle existe (resx EN+FR,
cartes, segments, especes).
"""
import json, os, re, io, sys, glob
import xml.etree.ElementTree as ET

R = sys.argv[1] if len(sys.argv) > 1 else '/home/user/fresh'
ok = True
def chk(cond, label, detail=''):
    global ok
    if not cond: ok = False
    print('%s %-58s %s' % ('OK  ' if cond else 'ECHEC', label, detail))

def read(p): return io.open(os.path.join(R, p), encoding='utf-8').read()

print('=' * 92)
print('1. LA CARTE DECLARE LES ENTITES')
print('=' * 92)
g = json.loads(io.open(os.path.join(R,'Data/Ground/metano_town.rsground'),
                       encoding='utf-8-sig').read())['Object']
ent = g['Entities'][0]
chars = {c['EntName']: c for c in ent['MapChars']}
objs  = {o['EntName']: o for o in ent['GroundObjects']}
mks   = {m['EntName']: m for m in ent['Markers']}

chk('Legend_Merchant' in chars, 'MapChar Legend_Merchant')
if 'Legend_Merchant' in chars:
    c = chars['Legend_Merchant']
    sp = c['Data'].get('CurrentForm', {}).get('Species')
    chk(sp == 'wigglytuff', '  espece = wigglytuff', sp)
    chk(c['triggerType'] == 1, '  triggerType = 1 (Action)', c['triggerType'])
    chk(c['EntEnabled'] is True, '  EntEnabled')
chk('Legend_Stand' in objs, 'GroundObject Legend_Stand')
chk('Legend_Stand_Marker' in mks, 'Marker Legend_Stand_Marker')

# collisions
obg = g['obstacles']
def blocked(x,y,w,h):
    for cx in range(x//8,(x+w+7)//8):
        for cy in range(y//8,(y+h+7)//8):
            if obg[cx][cy]['Tags']!=0: return True
    return False
if 'Legend_Merchant' in chars:
    L=chars['Legend_Merchant']['serializationLoc']
    chk(not blocked(L['X'],L['Y'],16,16), 'Grodoudou sur une case marchable', (L['X'],L['Y']))
if 'Legend_Stand_Marker' in mks:
    C=mks['Legend_Stand_Marker']['Collider']
    chk(not blocked(C['X'],C['Y'],16,16), 'marqueur sur une case marchable', (C['X'],C['Y']))

# chevauchement avec l'existant
boxes=[]
for n,c in chars.items():
    if n!='Legend_Merchant': boxes.append((n,c['serializationLoc']['X'],c['serializationLoc']['Y'],16,16))
for n,o in objs.items():
    if n!='Legend_Stand' and o.get('triggerType')!=3:
        cc=o['Collider']; boxes.append((n,cc['X'],cc['Y'],cc['Width'],cc['Height']))
def overlap(x,y,w,h):
    for (n,ox,oy,ow,oh) in boxes:
        if x<ox+ow and ox<x+w and y<oy+oh and oy<y+h: return n
    return None
if 'Legend_Merchant' in chars:
    L=chars['Legend_Merchant']['serializationLoc']
    chk(overlap(L['X'],L['Y'],16,16) is None, 'Grodoudou ne recouvre aucune entite', overlap(L['X'],L['Y'],16,16) or '')
if 'Legend_Stand' in objs:
    C=objs['Legend_Stand']['Collider']
    chk(overlap(C['X'],C['Y'],C['Width'],C['Height']) is None, 'etal ne recouvre aucune entite',
        overlap(C['X'],C['Y'],C['Width'],C['Height']) or '')

print()
print('=' * 92)
print("2. CHAINE D'APPEL : entite -> init.lua -> module -> LegendZones")
print('=' * 92)
init = read('Data/Script/halcyon/ground/metano_town/init.lua')
# RogueEssence appelle <map>.<EntName>_Action
chk('function metano_town.Legend_Merchant_Action' in init,
    'init.lua definit metano_town.Legend_Merchant_Action')
chk('function metano_town.Legend_Stand_Action' in init,
    'init.lua definit metano_town.Legend_Stand_Action')
chk("require 'halcyon.ground.metano_town.metano_town_legend'" in init,
    'init.lua require le module legend')
chk('metano_town_legend.Legend_Merchant_Action' in init,
    'init.lua delegue au module')

mod_p = 'Data/Script/halcyon/ground/metano_town/metano_town_legend.lua'
chk(os.path.exists(os.path.join(R, mod_p)), 'le module existe')
mod = read(mod_p)
chk('function metano_town_legend.Legend_Merchant_Action' in mod,
    'le module definit la fonction appelee')
chk("require 'halcyon.LegendZones'" in mod, 'le module require LegendZones')
chk("require 'halcyon.BossFX'" in mod, 'le module require BossFX (flash)')
chk(os.path.exists(os.path.join(R,'Data/Script/halcyon/LegendZones.lua')), 'LegendZones.lua existe')

print()
print('=' * 92)
print('3. LE FLASH BLANC')
print('=' * 92)
fx = read('Data/Script/halcyon/BossFX.lua')
chk('function BossFX.Flash' in fx, 'BossFX.Flash est defini')
chk('FlashEmitter()' in fx, '  utilise RogueEssence.Content.FlashEmitter')
chk('BGAnimData("White", 0)' in fx, '  utilise BGAnimData("White", 0)')
chk('EVT_Battle_Flash' in fx, '  joue EVT_Battle_Flash')
chk('BossFX.Flash(' in mod, 'le module appelle bien BossFX.Flash')
# "White" doit exister comme BG : absent du mod -> vient du jeu de base.
# Preuve qu'on peut s'y fier : 20 sites d'appel pre-existants l'utilisent deja.
n_white = sum(len(re.findall(r'BGAnimData\("White"', read(p[len(R)+1:])))
              for p in glob.glob(os.path.join(R,'Data/Script/**/*.lua'), recursive=True))
chk(n_white >= 5, 'BGAnimData("White") deja utilise par le projet', '%d sites' % n_white)

print()
print('=' * 92)
print('4. LES CLES DE TEXTE (EN + FR)')
print('=' * 92)
def keys(p):
    t = ET.parse(os.path.join(R, p)); r = t.getroot()
    return {d.get('name') for d in r.findall('data')}
KEN = keys('Data/Script/halcyon/ground/metano_town/strings.resx')
KFR = keys('Data/Script/halcyon/ground/metano_town/strings.fr.resx')

used = set(re.findall(r"MapStrings\['(LZ_[A-Za-z0-9_]+)'\]", mod))
lz = read('Data/Script/halcyon/LegendZones.lua')
for f in ('name','blurb','sight'):
    used |= set(re.findall(r"%s\s*=\s*'(LZ_[A-Za-z0-9_]+)'" % f, lz))

print('cles LZ_ referencees par le code : %d' % len(used))
miss_en = sorted(k for k in used if k not in KEN)
miss_fr = sorted(k for k in used if k not in KFR)
chk(not miss_en, 'toutes presentes en EN', ','.join(miss_en[:5]))
chk(not miss_fr, 'toutes presentes en FR', ','.join(miss_fr[:5]))

# une cle par entree du catalogue
entries = re.findall(r"key\s*=\s*'([a-z_]+)'", lz)
print('entrees du catalogue : %d' % len(entries))
for f in ('name','blurb','sight'):
    got = re.findall(r"%s\s*=\s*'(LZ_[A-Za-z0-9_]+)'" % f, lz)
    chk(len(got) == len(entries), 'chaque entree a un champ %-6s' % f,
        '%d/%d' % (len(got), len(entries)))

# valeurs non vides
tfr = ET.parse(os.path.join(R,'Data/Script/halcyon/ground/metano_town/strings.fr.resx')).getroot()
vals = {d.get('name'): (d.find('value').text or '') for d in tfr.findall('data')}
empty = [k for k in used if not vals.get(k, '').strip()]
chk(not empty, 'aucune valeur FR vide', ','.join(empty[:5]))

print()
print('=' * 92)
print('5. LA DESTINATION DU VOYAGE EXISTE VRAIMENT')
print('=' * 92)
# especes
mf = json.loads(io.open(os.path.join(R,'Data/Misc/MonsterFeature.json'),
                        encoding='utf-8-sig').read())['Object']['FeatureData']
species = re.findall(r"species\s*=\s*'([a-z_0-9]+)'", lz)
bad_sp = [s for s in species if s not in mf]
chk(not bad_sp, 'les %d especes existent dans MonsterFeature' % len(species), ','.join(bad_sp))

# entrees ready = true : la chaine doit etre complete
blocks = re.findall(r"\{\s*key = '([a-z_]+)'.*?ready = (true|false)\s*\}", lz, re.S)
ready = [k for k, r in blocks if r == 'true']
print('entrees jouables (ready=true) : %s' % (', '.join(ready) or 'aucune'))
for k in ready:
    m = re.search(r"key = '%s'.*?zone = '([a-z_]*)', segment = (-?\d+)" % k, lz, re.S)
    zone, seg = m.group(1), int(m.group(2))
    zp = os.path.join(R, 'Data/Zone/%s.json' % zone)
    chk(os.path.exists(zp), '  [%s] la zone %s existe' % (k, zone))
    if os.path.exists(zp):
        zd = json.loads(io.open(zp, encoding='utf-8-sig').read())['Object']
        chk(0 <= seg < len(zd['Segments']),
            '  [%s] segment %d present' % (k, seg), '%d segments' % len(zd['Segments']))
        if 0 <= seg < len(zd['Segments']):
            st = zd['Segments'][seg]['Floors'][0]['GenSteps'][0]['Value']
            mid = st['MapID']
            mp = os.path.join(R, 'Data/Map/%s.rsmap' % mid)
            chk(os.path.exists(mp), '  [%s] la carte %s.rsmap existe' % (k, mid))
            if os.path.exists(mp):
                md = json.loads(io.open(mp, encoding='utf-8-sig').read())['Object']
                unrec = [p['Unrecruitable'] for t in md['MapTeams'] for p in t['Players']]
                chk(unrec and not any(unrec),
                    '  [%s] l occupant est RECRUTABLE' % k, str(unrec))
                sp_map = [p['BaseForm']['Species'] for t in md['MapTeams'] for p in t['Players']]
                want = re.search(r"key = '%s',\s*species = '([a-z_0-9]+)'" % k, lz).group(1)
                chk(want in sp_map, '  [%s] l espece sur la carte est %s' % (k, want), str(sp_map))
    # ExitSegment doit gerer ce segment
    zi = read('Data/Script/halcyon/zone/%s/init.lua' % zone)
    chk('segmentID == %d' % seg in zi,
        '  [%s] ExitSegment gere le segment %d' % (k, seg))
    chk('LegendZones' in zi, '  [%s] zone/init.lua require LegendZones' % k)
    chk("SetDefeated('%s')" % k in zi, '  [%s] la victoire est enregistree' % k)

# les entrees non pretes ne doivent jamais etre listees
not_ready = [k for k, r in blocks if r == 'false']
chk('if entry.ready ~= true then return false end' in lz,
    'les %d entrees non pretes sont filtrees' % len(not_ready))

print()
print('=' * 92)
print('6. LA SAUVEGARDE')
print('=' * 92)
sv = read('Data/Script/halcyon/scriptvars.lua')
chk('SV.LegendZones' in sv, 'SV.LegendZones declare dans scriptvars.lua')
for f in ('Purchased', 'Defeated', 'MetMerchant'):
    chk(f in sv.split('SV.LegendZones')[1][:200], '  champ %s' % f)
chk('function LegendZones.EnsureSV' in lz, 'garde-fou EnsureSV pour vieilles sauvegardes')
chk('LegendZones.EnsureSV()' in mod, '  appele a l ouverture du stand')

print()
print('=' * 92)
print('RESULTAT : %s' % ('TOUT EST VERIFIE' if ok else 'DES POINTS ONT ECHOUE'))
print('=' * 92)
sys.exit(0 if ok else 1)
