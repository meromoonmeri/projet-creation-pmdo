#!/usr/bin/env python3
"""Gardes du chantier écosystème. Doivent échouer si une régression apparaît.

Couvre :
  1. exclusions Metano / Guilde / légendaires ;
  2. intégrité du roster d'espèces (profils, objets source, couverture) ;
  3. légalité écologique de CHAQUE individu placé (aucun dans un arbre, un
     mur, un rocher, l'eau pour un terrestre, etc.) ;
  4. densité : aucune room saturée, des espaces vides subsistent ;
  5. anti-végétatif : tout profil non sessile a un déplacement, tout profil
     sessile a des états d'immobilité nommés ;
  6. cohérence des relations inter-espèces ;
  7. preuves de duel : pixel_identical sur toutes les fenêtres générées.

Usage : python3 NO_NAME_VILLAGE_ADAPTATION/test_fauna_ecology.py
"""
from __future__ import annotations
import glob
import gzip
import json
import os
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
NNV = ROOT / 'NO_NAME_VILLAGE_ADAPTATION'
ECO = NNV / 'reports/fauna-ecology'

FORBIDDEN_TERRAIN = {0, 5, 6, 7}          # blocked, tree, rock, cliff
WALKABLE = {1, 2, 4, 8, 9}
T_WATER = 3

failures: list[str] = []
checks = 0


def check(cond, msg):
    global checks
    checks += 1
    if not cond:
        failures.append(msg)
    return cond


# ---------------------------------------------------------------- exclusions
def metano_guild_species():
    sp = set()
    pats = ['Data/Ground/metano*.rsground', 'Data/Ground/guild*.rsground',
            'Data/Ground/sky_wigglytuff*.rsground']
    for pat in pats:
        for f in glob.glob(str(ROOT / pat)):
            txt = open(f, encoding='utf-8-sig', errors='replace').read()
            sp |= set(re.findall(r'"Species":\s*"([a-z0-9_]+)"', txt))
    sp.discard('')

    ce = ROOT / 'Data/Script/halcyon/CharacterEssentials.lua'
    if ce.exists():
        t = open(ce, encoding='utf-8').read()
        blk = t[t.index('local characters = {'):]
        name2sp = dict(re.findall(r'(\w+)\s*=\s*\{\s*species\s*=\s*"([a-z0-9_]+)"', blk))
        files = [f for f in glob.glob(str(ROOT / 'Data/Script/halcyon/**/*.lua'),
                                      recursive=True)
                 if re.search(r'/(metano|guild)', f)
                 or re.search(r'(TownLife|TownPlace|TownNight|NightWatch|TownRaid|SideQuests)\.lua$', f)]
        for f in files:
            txt = open(f, encoding='utf-8', errors='replace').read()
            for n, s in name2sp.items():
                if re.search(r'[\'"]%s[\'"]' % re.escape(n), txt):
                    sp.add(s)
    return sp


LEGENDARY = {
    'articuno', 'zapdos', 'moltres', 'mewtwo', 'mew', 'raikou', 'entei',
    'suicune', 'lugia', 'ho_oh', 'celebi', 'regirock', 'regice', 'registeel',
    'latias', 'latios', 'kyogre', 'groudon', 'rayquaza', 'jirachi', 'deoxys',
    'uxie', 'mesprit', 'azelf', 'dialga', 'palkia', 'heatran', 'regigigas',
    'giratina', 'cresselia', 'phione', 'manaphy', 'darkrai', 'shaymin',
    'arceus', 'victini', 'cobalion', 'terrakion', 'virizion', 'tornadus',
    'thundurus', 'reshiram', 'zekrom', 'landorus', 'kyurem', 'keldeo',
    'meloetta', 'genesect', 'xerneas', 'yveltal', 'zygarde', 'diancie',
    'hoopa', 'volcanion', 'tapu_koko', 'tapu_lele', 'tapu_bulu', 'tapu_fini',
    'cosmog', 'cosmoem', 'solgaleo', 'lunala', 'necrozma', 'magearna',
    'marshadow', 'zeraora', 'meltan', 'melmetal', 'nihilego', 'buzzwole',
    'pheromosa', 'xurkitree', 'celesteela', 'kartana', 'guzzlord', 'poipole',
    'naganadel', 'stakataka', 'blacephalon', 'type_null', 'silvally',
    'eternatus', 'missingno',
}


def main():
    spec_path = NNV / 'config/fauna-species.json'
    if not check(spec_path.exists(), 'config/fauna-species.json manquant'):
        return report()
    S = json.load(open(spec_path))
    species = S['species']
    profiles = S['behaviour_profiles']

    # 1. exclusions
    excl = metano_guild_species()
    feat = json.load(open(ROOT / 'Data/Misc/MonsterFeature.json',
                          encoding='utf-8-sig'))['Object']['FeatureData']
    for name in species:
        check(name not in excl,
              'espece %s deja presente a Metano/Guilde' % name)
        check(name not in LEGENDARY,
              'espece %s est legendaire/fabuleux' % name)
        check(name in feat,
              'espece %s absente de MonsterFeature.json' % name)

    # 2. roster
    occ = json.load(open(NNV / 'reports/fauna-fix/fauna-occurrences.json'))
    covered = {}
    for name, sp in species.items():
        check(sp['profile'] in profiles,
              '%s: profil inconnu %s' % (name, sp['profile']))
        check(bool(sp.get('evidence')), '%s: aucune preuve documentee' % name)
        for o in sp['source_objects']:
            check(o not in covered,
                  'objet %s reclame par %s et %s' % (o, covered.get(o), name))
            covered[o] = name
    for o in occ['per_object']:
        check(o in covered, 'objet source %s sans espece' % o)

    # 3+4. placement
    atlas_p = ECO / 'biome-atlas.json.gz'
    place_p = ECO / 'fauna-placement.json.gz'
    if check(atlas_p.exists(), 'biome-atlas.json.gz manquant') and \
       check(place_p.exists(), 'fauna-placement.json.gz manquant'):
        A = json.load(gzip.open(atlas_p))['rooms']
        P = json.load(gzip.open(place_p))
        total = 0
        for room, rd in P['rooms'].items():
            atlas = A.get(room)
            if not check(atlas is not None, 'room %s absente de l atlas' % room):
                continue
            terrain = atlas['terrain']
            seen = {}
            for col in rd['colonies']:
                sp = species.get(col['species'])
                if not check(sp is not None,
                             '%s: espece inconnue %s' % (room, col['species'])):
                    continue
                prof = profiles[sp['profile']]
                req = prof.get('requires')
                for m in col['members']:
                    x, y = m['cell']
                    t = terrain[y][x]
                    total += 1
                    if req == 'water':
                        check(t == T_WATER,
                              '%s/%s aquatique hors de l eau en (%d,%d) t=%d'
                              % (room, col['species'], x, y, t))
                    else:
                        check(t not in FORBIDDEN_TERRAIN,
                              '%s/%s dans un obstacle en (%d,%d) t=%d'
                              % (room, col['species'], x, y, t))
                    if req == 'near_water':
                        check(atlas['near_water'][y][x] <= 2,
                              '%s/%s cense etre au bord de l eau en (%d,%d)'
                              % (room, col['species'], x, y))
                    if req == 'near_tree':
                        check(atlas['near_tree'][y][x] <= 2,
                              '%s/%s cense etre sous couvert en (%d,%d)'
                              % (room, col['species'], x, y))
                    k = (x, y)
                    check(k not in seen,
                          '%s: cellule (%d,%d) partagee par %s et %s'
                          % (room, x, y, seen.get(k), col['species']))
                    seen[k] = col['species']

            # densité : jamais saturé, des vides subsistent
            expl = rd['exploitable_cells']
            if expl:
                occup = rd['individuals'] / expl
                check(occup < 0.10,
                      '%s: densite %0.3f trop elevee (map remplie artificiellement)'
                      % (room, occup))
        check(total > 0, 'aucun individu place')

    # 5. anti-végétatif
    for pname, p in profiles.items():
        states = p.get('states') if isinstance(p, dict) else None
        if pname == 'sessile':
            check(p['speed'] == 0,
                  'profil sessile devrait avoir speed 0')
        else:
            check(p.get('speed', 0) > 0,
                  'profil %s immobile sans etre sessile' % pname)
            check(p.get('pause_ratio', 1) < 1.0,
                  'profil %s en pause permanente' % pname)
            check(p.get('radius', 0) > 0,
                  'profil %s sans rayon de deplacement' % pname)

    # le Lua doit décrire un état nommé pour chaque profil
    lua = NNV / 'generated/fauna/NNVEcology.lua'
    if check(lua.exists(), 'NNVEcology.lua manquant'):
        txt = open(lua, encoding='utf-8').read()
        for pname in profiles:
            check(re.search(r'\b%s\s*=\s*\{' % re.escape(pname), txt) is not None,
                  'profil %s absent de NNVEcology.lua' % pname)
        for m in re.finditer(r"states=\{([^}]*)\}", txt):
            for st in re.findall(r"'([a-z_]+)'", m.group(1)):
                check(("  %s " % st) in txt or ("%s  " % st) in txt
                      or re.search(r'\b%s\s*=\s*"' % re.escape(st), txt) is not None,
                      'etat %s sans texte d observation' % st)

    # 6. relations
    if check(lua.exists(), ''):
        txt = open(lua, encoding='utf-8').read()
        blk = txt[txt.index('E.RELATIONS'):txt.index('E.DUEL_PAIRS')]
        for sname in re.findall(r'^\s{2}(\w+)\s*=\s*\{', blk, re.M):
            check(sname in species,
                  'relation declaree pour espece inconnue: %s' % sname)
        for target in set(re.findall(r'(\w+)=[\'"](\w+)[\'"]', blk)):
            key, verb = target
            if key in ('default',):
                continue
            check(key in species,
                  'relation vers espece inconnue: %s' % key)
            check(verb in ('ignore', 'curieux', 'evite', 'fuit', 'chasse',
                           'rivalise', 'grege'),
                  'verbe de relation inconnu: %s' % verb)

    # 6b. FAIL-CLOSED : aucune promotion sans preuve de terrain
    ev_p = ECO / 'evidence-classification.json'
    if check(ev_p.exists(), 'evidence-classification.json manquant'):
        ev = json.load(open(ev_p))
        for room, r in ev['rooms'].items():
            if r['evidence'] != 'PROVEN':
                check(r['promotable_individuals'] == 0,
                      'room %s (%s) promeut %d individus sans preuve'
                      % (room, r['evidence'], r['promotable_individuals']))
            else:
                check(r['has_render'] and r['has_collision'],
                      'room %s classee PROVEN sans les deux preuves' % room)
        # une espece en attente ne doit apparaitre dans aucune room promue
        A2 = json.load(gzip.open(ECO / 'biome-atlas.json.gz'))['rooms']
        P2 = json.load(gzip.open(ECO / 'fauna-placement.json.gz'))['rooms']
        for sname in ev['held_species']:
            for room, rd in P2.items():
                if ev['rooms'].get(room, {}).get('evidence') != 'PROVEN':
                    continue
                for col in rd['colonies']:
                    check(col['species'] != sname,
                          'espece en attente %s placee dans la room promue %s'
                          % (sname, room))
        # Cradily : jamais placé artificiellement
        check('cradily' in ev['held_species'],
              'cradily doit rester en attente tant que rmcave1_* n a pas de preuve')
        t = ev['totals']
        check(t['individuals_promotable'] + t['individuals_withheld']
              == t['individuals_placed'],
              'comptes de promotion incoherents')

    # 6c. AUCUN DOUBLE PILOTAGE
    # NNVLife et NNVEcology ne doivent jamais commander les memes individus.
    # Les 12 objbird0 et 19 objbutterfly1 de rmvillage appartiennent a NNVEcology.
    for life in glob.glob(str(NNV / 'generated/**/NNVLife.lua'), recursive=True):
        txt = open(life, encoding='utf-8').read()
        base = os.path.relpath(life, NNV)
        check(re.search(r'source_(birds|butterflies)\s*=', txt) is None,
              '%s: groupe source_birds/source_butterflies encore defini '
              '-> double pilotage avec NNVEcology' % base)
        check('GROUPS.source_' not in txt,
              '%s: usage residuel de GROUPS.source_*' % base)
        for ent in ('NNV_SourceBird_', 'NNV_SourceButterfly_'):
            check(ent not in txt,
                  '%s: entite %s encore pilotee par NNVLife' % (base, ent))
    # le generateur ne doit pas pouvoir les recreer
    gen = NNV / 'tools/build_rmvillage_life_patch.py'
    if gen.exists():
        g = open(gen, encoding='utf-8').read()
        check('EMIT_SOURCE_ANIMALS=False' in g.replace(' ', ''),
              'build_rmvillage_life_patch.py peut recreer les animaux source '
              '-> double pilotage a la prochaine regeneration')

    # 7. preuves de duel
    proofs = sorted(glob.glob(str(ECO / 'duel-maps/*_proof.json')))
    check(len(proofs) > 0, 'aucune preuve de duel generee')
    for p in proofs:
        d = json.load(open(p))
        check(d['pixel_identical'] is True,
              '%s: la .rsmap de duel n est pas pixel-identique' % os.path.basename(p))
        check(d['differing_pixels'] == 0,
              '%s: %d pixels divergents' % (os.path.basename(p),
                                            d['differing_pixels']))
        check(d['source_window_sha256'] == d['rebuilt_sha256'],
              '%s: sha256 divergents' % os.path.basename(p))
        w, h = d['window_px']
        check(w >= 480 and h >= 270,
              '%s: fenetre %dx%d plus petite qu un ecran' % (os.path.basename(p), w, h))

    return report()


def report():
    print('controles: %d' % checks)
    if failures:
        print('ECHECS: %d' % len(failures))
        for f in failures[:40]:
            print('  -', f)
        return 1
    print('TOUT EST VERIFIE')
    return 0


if __name__ == '__main__':
    sys.exit(main())
