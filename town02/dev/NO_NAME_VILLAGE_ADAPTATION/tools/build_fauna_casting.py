import json, io, gzip, subprocess, hashlib, os

FEAT = json.load(io.open('Data/Misc/MonsterFeature.json', encoding='utf-8-sig'))['Object']['FeatureData']
OCC = json.load(open('NO_NAME_VILLAGE_ADAPTATION/reports/fauna-fix/fauna-occurrences.json'))
INV = json.load(gzip.open('NO_NAME_VILLAGE_ADAPTATION/reports/environment-inventory.json.gz'))
BY = {o['name']: o for o in INV['object_contracts']}

# (espece, comportement, niveau, justification visuelle+GML)
CAST = {
 # --- ambiance pure (objbgmob : pas de hp, pas de dmg, pas de collision) ---
 'objbutterfly1': ('vivillon',   'ambient_flying', 1,  'sprite sbutterfly1 16x16 : papillon bleu 2 ailes, vol libre, spd=0 z=fz. Aucun hp/dmg dans le GML : decor vivant.'),
 'objbug0':       ('cutiefly',   'ambient_flying', 1,  'sprite sbug0 4x4 : point volant minuscule, parent objbgmob, z=0. Le plus petit insecte disponible.'),
 'objfirefly':    ('volbeat',    'ambient_night',  1,  'sprite sfire1shad + sfire10..12 : lueur qui clignote, z=64 (en l air). Volbeat = luciole canonique.'),
 'objbird0':      ('fletchling', 'ambient_flying', 3,  'sprite sbird0 40x48 : petit oiseau rouge/gris perche, sbird0f1 en vol. Fletchling = passereau rouge.'),
 'objfrog':       ('croagunk',   'ambient_ground', 3,  'sprite sfrog00 28x20 vert, 6 frames de saut. Batracien vert, aucune attaque en GML.'),

 # --- faune active saison ete (objmob) ---
 'objmobsm0':  ('jumpluff',  'timid',        6,  'smobsm0i0 64x60 : boule cyan duveteuse posee au sol, smobsm0j0 = saut. maxhp=3 level=2.'),
 'objmobsm1':  ('illumise',  'timid',        5,  'smobsm1i0 68x56 : insecte sombre a ailes claires et bulbe lumineux (smobsm1bulb). maxhp=2 dmg=0.5.'),
 'objmobsm2':  ('wooper',    'timid',        6,  'smobsm2i1 : silhouette basse dans l eau + smobsm2ball bleu. maxhp=5 level=2.'),
 'objmobsm3':  ('wingull',   'timid',        6,  'smobsm3f1 200x176 : grand oiseau blanc/bleu en vol (flyup). maxhp=3 level=2.'),
 'objmobsm40': ('bellsprout','ambient_ground',4, 'ssmbplant001 192x576 : tige verte a bulbe rouge ancree au sol, 4 frames. Plante mobile.'),
 'objmobsm5':  ('magikarp',  'timid',        5,  'chaine smobsm501..510 : amas laiteux qui grossit avec hp. objmobsm5 se transforme en objmob0 a 10%. Aquatique.'),
 'objmobsm501':('magikarp',  'timid',        5,  'meme sprite/chaine que objmobsm5 : ces objets sont des etats de ponte, pas des especes distinctes.'),
 'objmobsm502':('magikarp',  'timid',        5,  'idem, hp=2.'),
 'objmobsm503':('magikarp',  'timid',        5,  'idem, hp=3.'),
 'objmobsm504':('magikarp',  'timid',        5,  'idem, hp=4.'),
 'objmobsm505':('magikarp',  'timid',        5,  'idem, hp=5.'),
 'objmobsm506':('magikarp',  'timid',        5,  'idem, hp=6.'),
 'objmobsm507':('magikarp',  'timid',        5,  'idem, hp=7.'),
 'objmobsm508':('magikarp',  'timid',        5,  'idem, hp=8.'),
 'objmobsm509':('magikarp',  'timid',        5,  'idem, hp=9.'),
 'objmobsm510':('magikarp',  'timid',        5,  'idem, hp=10 : le plus gros amas.'),

 # --- faune generique ---
 'objmob0':  ('barboach',  'timid',       4,  'smob0i0 60x32 : forme sombre allongee dans une flaque bleue (smob0puddle). Poisson de mare.'),
 'objmob1':  ('sandshrew', 'timid',       4,  'smob1i0 52x60 : boule brun-orange a ecailles, smob1d1 = creuse. hp=1, GML dig.'),
 'objmob2':  ('cradily',   'territorial', 12, 'smob2i0 208x108 : couronne de petales/tentacules vert sombre fixee au sol, smob2d0 = repli. hp=4, mord.'),

 # --- automne ---
 'objmobau0': ('ledyba',   'timid',       6,  'smobau0e0 60x60 : coccinelle rouge/jaune, smobau0m0 en marche. maxhp=4 dmg=3 level=1.'),
 'objmobau1': ('ledian',   'territorial', 12, 'smobau1i0 84x112 : meme insecte rouge/jaune mais elance sur pattes. Evolution visuelle de au0. maxhp=6 level=3.'),
 'objmobau2': ('dwebble',  'territorial', 10, 'smobau2i0 180x148 : carapace/coquille beige posee au sol. maxhp=6 dmg=1.5, GML shell + water.'),
 'objmobau3': ('chinchou', 'timid',       12, 'smobau3shad : masse dans l eau, GML water+fish+shock+spark (sparks smobau3spark0..2). maxhp=20.'),
 'objmobau4': ('swanna',   'territorial', 14, 'smobau4e2 216x216 : grand echassier bleu-gris a long cou, smobau4b0 88x352 debout. maxhp=6 dmg=1.5.'),
 'objmobau5': ('lotad',    'timid',       6,  'smobau5i2 76x56 : disque vert flottant type nenuphar. maxhp=4 dmg=2, GML water+jump.'),

 # --- hiver ---
 'objmobwn0':     ('swinub',    'timid',       10, 'smobwn0i2 160x112 : boule de fourrure creme a sabots, smobwn0r0 132x140 dresse. maxhp=8 level=5, GML snow.'),
 'objmobwn0_old': ('swinub',    'timid',       10, 'meme sprite smobwn0i0 : variante obsolete du meme objet (maxhp=40 non utilise).'),
 'objmobwn1':     ('swanna',    'territorial', 14, 'smobwn1i0 92x232 : oiseau blanc/bleu debout, long cou, meme famille visuelle que au4. maxhp=8 level=4.'),
 'objmobwn2':     ('skorupi',   'territorial', 14, 'smobwn2i0 116x84 : arthropode bleu-violet trapu vu de face, pinces laterales rouges. maxhp=15 level=5.'),
 'objmobwn4':     ('piloswine', 'territorial', 20, 'smobwn4c/b 240x240 : masque de collision seul (spahbox) + trainees blanches smobwn4trail0*. maxhp=35, GML dig+bite, collision=false : creature qui charge sous la neige.'),
 'objmobwn5':     ('murkrow',   'timid',       10, 'smobwn5i0 44x56 : petit oiseau noir compact, zmax=256, GML fly+flap+wing. maxhp=3.'),
}

def attested(sp):
    r = subprocess.run(['grep','-rlF','"%s"'%sp,'Data/Map','Data/Zone','Data/Ground'], capture_output=True, text=True)
    files=[f for f in r.stdout.strip().split('\n') if f]
    return files[:3]

rows=[]
missing=[]
for obj,count in OCC['per_object'].items():
    if obj not in CAST:
        missing.append(obj); continue
    sp,beh,lvl,why = CAST[obj]
    f = FEAT.get(sp,{}).get('0')
    if not f:
        missing.append(obj+':'+sp); continue
    c = BY.get(obj) or {}
    rows.append({
      'source_object': obj,
      'occurrences': count,
      'source_sprite': (c.get('sprite') or {}).get('name'),
      'source_parent': (c.get('parent') or {}).get('name'),
      'species': sp,
      'behavior': beh,
      'level': lvl,
      'element1': f['Element1'], 'element2': f['Element2'],
      'stage': f['Stage'], 'family': f['Family'],
      'attested_in_repo': attested(sp),
      'evidence': why,
    })

rows.sort(key=lambda r:-r['occurrences'])
total=sum(r['occurrences'] for r in rows)
out={
 'schema':'nnv-fauna-casting-v1',
 'status':'PROPOSAL_AWAITING_VALIDATION',
 'rule':'aucune espece n est ecrite dans un Ground tant que ce tableau n est pas valide',
 'generations_allowed':'1-7 (contrainte utilisateur)',
 'scale':'toutes les entites restent 16x16 px, echelle PMDO, aucun asset redimensionne',
 'totals':{'occurrences_cast':total,'source_total':OCC['totals']['occurrences'],'distinct_objects':len(rows),'distinct_species':len(set(r['species'] for r in rows))},
 'unmapped':missing,
 'cast':rows,
}
os.makedirs('NO_NAME_VILLAGE_ADAPTATION/reports/fauna-casting',exist_ok=True)
p='NO_NAME_VILLAGE_ADAPTATION/reports/fauna-casting/fauna-casting.json'
open(p,'w').write(json.dumps(out,indent=1,ensure_ascii=False)+'\n')
print('total cast',total,'/',OCC['totals']['occurrences'],'unmapped',missing)
for r in rows: print('%-14s %4d -> %-11s %-15s lvl%-3d %s' % (r['source_object'],r['occurrences'],r['species'],r['behavior'],r['level'],'ATTESTE' if r['attested_in_repo'] else 'nouveau'))
