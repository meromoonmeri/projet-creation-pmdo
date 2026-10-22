#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
audit_bugs.py — chasse aux bugs D'EXECUTION
===========================================
Les outils existants verifient la FORME (Lua compile, JSON valide,
positions dans la carte). Celui-ci cherche les erreurs qui ne se voient
qu'a l'execution : un appel a une fonction absente, un champ SV jamais
declare, un handler que la carte reclame et que le script n'expose pas.

Ce sont exactement les classes de bugs qui ont deja mordu ce projet :
  * GloomyPlayedMidpointIntro declare nulle part -> nil sur partie neuve
  * STRINGS.Format au lieu de STRINGS:Format -> plantage
  * Item_Give_Storage appelee mais absente -> boite vide
  * 37 objets muets sur la carte de nuit

CHAQUE CONTROLE EST CONSERVATEUR : en cas de doute, on se tait. Un
faux positif coute plus cher qu'un manque, parce qu'il fait perdre la
confiance dans l'outil.
"""
import json
import os
import re
import sys
from collections import defaultdict

ROOT = sys.argv[1] if len(sys.argv) > 1 else '.'
SCRIPT = os.path.join(ROOT, 'Data', 'Script')
GROUND = os.path.join(ROOT, 'Data', 'Ground')

problemes = defaultdict(list)


def lua_files():
    for dp, _, fns in os.walk(SCRIPT):
        for fn in fns:
            if fn.endswith('.lua'):
                yield os.path.join(dp, fn)


def read(p):
    return open(p, encoding='utf-8').read()


def strip_comments(src):
    """Retire commentaires --[[ ]] et -- ligne, pour ne pas analyser du texte mort."""
    src = re.sub(r'--\[\[.*?\]\]', '', src, flags=re.S)
    src = re.sub(r'--[^\n]*', '', src)
    return src


def strip_strings(src):
    """Retire le contenu des chaines : evite de prendre du dialogue pour du code."""
    src = re.sub(r'"(?:[^"\\]|\\.)*"', '""', src)
    src = re.sub(r"'(?:[^'\\]|\\.)*'", "''", src)
    return src


ALL = {p: read(p) for p in lua_files()}
# NOCOM = source sans commentaires, mais AVEC les chaines : les controles
# qui cherchent un nom de zone/carte/item ont besoin du contenu des chaines,
# mais pas du code mort en --[[ ]]. Sans ca, luminous_spring signalait
# 'base_camp_2' alors que l'appel est commente depuis toujours.
NOCOM = {p: strip_comments(s) for p, s in ALL.items()}
CODE = {p: strip_strings(strip_comments(s)) for p, s in ALL.items()}
FULL_CODE = '\n'.join(CODE.values())


# =====================================================================
# 1. STRINGS.Format au lieu de STRINGS:Format  (bug deja rencontre x8)
# =====================================================================
def check_strings_format():
    for p, s in CODE.items():
        for m in re.finditer(r'\bSTRINGS\.Format\b', s):
            ln = s[:m.start()].count('\n') + 1
            problemes['A. STRINGS.Format (point au lieu de deux-points)'].append(
                f"{os.path.relpath(p, ROOT)}:{ln}")


# =====================================================================
# 2. Modules globaux : fonction appelee mais jamais definie
# =====================================================================
def check_module_calls():
    # modules globaux du mod = fichiers Data/Script/halcyon/X.lua definissant X = {}
    mods = {}
    for p, s in CODE.items():
        base = os.path.basename(p)[:-4]
        parent = os.path.basename(os.path.dirname(p))
        if parent != 'halcyon':
            continue
        if re.search(r'^\s*%s\s*=\s*\{\}' % re.escape(base), s, re.M):
            defined = set(re.findall(
                r'^\s*function\s+%s\.([A-Za-z_]\w*)' % re.escape(base), s, re.M))
            mods[base] = defined

    for mod, defined in mods.items():
        called = set()
        for p, s in CODE.items():
            for m in re.finditer(r'\b%s\.([A-Za-z_]\w*)\s*\(' % re.escape(mod), s):
                called.add(m.group(1))
        # champs de donnees (tables) : pas des appels
        missing = {c for c in called - defined}
        for c in sorted(missing):
            # ou est-ce appele ?
            locs = []
            for p, s in CODE.items():
                for m in re.finditer(r'\b%s\.%s\s*\(' % (re.escape(mod), re.escape(c)), s):
                    locs.append(f"{os.path.relpath(p, ROOT)}:{s[:m.start()].count(chr(10))+1}")
            problemes['B. Fonction de module appelee mais jamais definie'].append(
                f"{mod}.{c}()  <- {locs[0]}" + (f" (+{len(locs)-1})" if len(locs) > 1 else ""))


# =====================================================================
# 3. Champs SV lus mais jamais declares
# =====================================================================
def check_sv_fields():
    # Le mod contient PLUSIEURS namespaces (halcyon, megastones,
    # source_duns_imbi...). Chacun a son propre scriptvars.lua. Ne lire que
    # celui de halcyon faisait passer SV.shady_shop pour non declare alors
    # qu'il l'est dans megastones/scriptvars.lua. On agrege donc TOUS les
    # scriptvars et tous les OnUpgrade du depot.
    sv_path = os.path.join(SCRIPT, 'halcyon', 'scriptvars.lua')
    dbg_path = os.path.join(SCRIPT, 'halcyon', 'services', 'debug_tools', 'init.lua')
    decl_files = set()
    for pp in ALL:
        base = os.path.basename(pp)
        if base == 'scriptvars.lua' or 'debug_tools' in pp or 'config_tools' in pp:
            decl_files.add(pp)
    decl_files.add(sv_path)
    decl_files.add(dbg_path)
    declared_src = ''
    for p in sorted(decl_files):
        if os.path.exists(p):
            declared_src += read(p)

    # tables de premier niveau declarees : SV.X = {
    top_declared = set(re.findall(r'SV\.([A-Za-z_]\w*)\s*=', declared_src))
    # champs declares n'importe ou dans les deux fichiers
    field_declared = set(re.findall(r'SV\.([A-Za-z_]\w*)\.([A-Za-z_]\w*)', declared_src))
    # champs declares dans un bloc table : "  Nom = valeur,"
    # Plusieurs champs peuvent tenir sur UNE ligne : "Map = 1, Entry = 0,".
    # Une regex ancree en debut de ligne ne voyait que le premier et faisait
    # passer SV.checkpoint.Entry pour non declare. On balaie donc toute la ligne.
    inline = set(re.findall(r'([A-Za-z_]\w*)\s*=', declared_src))

    # Modules qui creent leur table a la volee via Ensure() : on les tolere,
    # mais on verifie que la table de premier niveau est bien declaree.
    ensure_mods = set()
    for p, s in CODE.items():
        for m in re.finditer(r'if\s+SV\.([A-Za-z_]\w*)\s*==\s*nil\s+then\s+SV\.\1\s*=\s*\{\}', s):
            ensure_mods.add(m.group(1))

    used = defaultdict(set)
    for p, s in CODE.items():
        if p in decl_files:
            continue
        for m in re.finditer(r'SV\.([A-Za-z_]\w*)\.([A-Za-z_]\w*)', s):
            used[m.group(1)].add((m.group(2), os.path.relpath(p, ROOT),
                                  s[:m.start()].count('\n') + 1))

    for tbl, fields in sorted(used.items()):
        if tbl not in top_declared and tbl not in ensure_mods:
            problemes['C. Table SV utilisee mais jamais declaree'].append(
                f"SV.{tbl}  <- {sorted(fields)[0][1]}:{sorted(fields)[0][2]}")
            continue
        if tbl in ensure_mods:
            continue  # Ensure() cree les champs a la volee, verifie ailleurs
        for fld, f, ln in sorted(fields):
            if (tbl, fld) in field_declared or fld in inline:
                continue
            problemes['D. Champ SV lu mais jamais declare'].append(
                f"SV.{tbl}.{fld}  <- {f}:{ln}")


# =====================================================================
# 4. Handlers reclames par une carte .rsground et absents du script
# =====================================================================
TRIG = {1: '_Action', 2: '_Touch', 3: '_Touch'}


def check_ground_handlers():
    if not os.path.isdir(GROUND):
        return
    for fn in sorted(os.listdir(GROUND)):
        if not fn.endswith('.rsground'):
            continue
        name = fn[:-9]
        sp = os.path.join(SCRIPT, 'halcyon', 'ground', name, 'init.lua')
        if not os.path.exists(sp):
            continue
        try:
            d = json.load(open(os.path.join(GROUND, fn), encoding='utf-8-sig'))
        except Exception:
            continue
        o = d.get('Object', d)
        ents = o.get('Entities') or []
        if not ents:
            continue
        e = ents[0]
        e = e.get('Object', e)

        # triggerType 0 = DECORATIF : le moteur ne declenche jamais rien.
        # Preuve dans le depot : les 13 Food_* de guild_dining_room sont
        # tous a 0, n'ont aucun handler, et la salle fonctionne depuis
        # toujours. Les compter donnait 13 faux positifs a elle seule.
        need = set()
        for g in (e.get('GroundObjects') or []):
            n = g.get('EntName')
            t = g.get('triggerType')
            if n and t in TRIG:
                need.add(n + TRIG[t])
        for c in (e.get('MapChars') or []):
            n = c.get('EntName')
            t = c.get('triggerType')
            if n and t in TRIG:
                need.add(n + '_Action')

        src = read(sp)
        # Le nom du MODULE Lua ne suit pas toujours le nom du dossier :
        # ground/guild_top_left_bedroom/init.lua declare en realite
        # `guild_Top_Left_bedroom` (majuscules). Chercher le prefixe exact
        # faisait passer son Bedroom_Exit_Touch, pourtant present, pour
        # absent. On accepte donc n'importe quel prefixe de module.
        have = set(re.findall(r'^function\s+[A-Za-z_]\w*\.([A-Za-z_]\w*)',
                              src, re.M))
        # Fonctions créées par affectation (alias/factory), par exemple
        # `module.Sign_Action = Panneau(...)`.
        have |= set(re.findall(r'^[A-Za-z_]\w*\.([A-Za-z_]\w*)\s*=', src, re.M))
        # certains fichiers delegent tout : on considere le chapitre courant
        for ch_file in sorted(os.listdir(os.path.dirname(sp))):
            if ch_file.startswith(name + '_ch_') and ch_file.endswith('.lua'):
                cs = read(os.path.join(os.path.dirname(sp), ch_file))
                have |= set(re.findall(
                    r'^function\s+[A-Za-z_]\w*\.([A-Za-z_]\w*)', cs, re.M))

        # Handlers générés par boucle depuis une table de noms :
        #   for _, nom in ipairs(HABITANTS) do module[nom..'_Action'] = ...
        # Ils sont réels au runtime même s'ils ne prennent pas la forme
        # `function module.X_Action` recherchée ci-dessus.
        for table_name in re.findall(r'ipairs\(([A-Za-z_]\w*)\)', src):
            block = re.search(r'local\s+' + re.escape(table_name) + r'\s*=\s*\{(.*?)\}', src, re.S)
            if block and re.search(r"\[\s*nom\s*\.\.\s*['\"]_Action", src):
                have |= {name + '_Action' for name in re.findall(r"['\"]([A-Za-z_]\w*)['\"]", block.group(1))}

        missing = sorted(need - have)
        if name == 'testmap':
            missing = []  # carte de développement, objets volontairement muets
        if missing:
            problemes['E. Objet de carte sans handler (muet en jeu)'].append(
                f"{name}: {', '.join(missing[:8])}"
                + (f" (+{len(missing)-8})" if len(missing) > 8 else ""))


# =====================================================================
# 5. Zones referencees par EnterDungeon/EnterZone et absentes
# =====================================================================
def check_zone_refs():
    zdir = os.path.join(ROOT, 'Data', 'Zone')
    if not os.path.isdir(zdir):
        return
    have = {f[:-5] for f in os.listdir(zdir) if f.endswith('.json')}
    # Grounds canoniques extraits mais volontairement non branchés : leur
    # script de midpoint est conservé avec le paquet d'import et ne devient
    # exécutable qu'à la création de la zone correspondante.
    reserve_pending = {'frosty_forest', 'mt_blaze', 'mt_freeze', 'mt_thunder'}
    for p, s in NOCOM.items():
        for m in re.finditer(r'GAME:EnterDungeon\(\s*"([a-z0-9_]+)"', s):
            z = m.group(1)
            if z not in have and z not in reserve_pending:
                ln = s[:m.start()].count('\n') + 1
                problemes['F. Zone inexistante referencee'].append(
                    f'"{z}" <- {os.path.relpath(p, ROOT)}:{ln}')


# =====================================================================
# 6. GroundMap referencee par EnterGroundMap et absente du dossier
# =====================================================================
def check_groundmap_refs():
    if not os.path.isdir(GROUND):
        return
    have = {f[:-9] for f in os.listdir(GROUND) if f.endswith('.rsground')}
    seen = set()
    for p, s in NOCOM.items():
        for m in re.finditer(r"GAME:EnterGroundMap\(\s*['\"]([a-z0-9_]+)['\"]", s):
            g = m.group(1)
            if g not in have and g not in seen:
                seen.add(g)
                ln = s[:m.start()].count('\n') + 1
                problemes['G. GroundMap inexistante referencee'].append(
                    f'"{g}" <- {os.path.relpath(p, ROOT)}:{ln}')


# =====================================================================
# 7. MapStatus pose et absent de Data/MapStatus (hors statuts moteur)
# =====================================================================
MOTEUR = {'clouds_overhead', 'darkness', 'dusk', 'steam', 'blowing_wind',
          'blowing_wind_fast', 'mysterious_distortion', 'default_weather'}


def check_mapstatus():
    md = os.path.join(ROOT, 'Data', 'MapStatus')
    have = set()
    if os.path.isdir(md):
        have = {f[:-5] for f in os.listdir(md) if f.endswith('.json')}
    seen = set()
    for p, s in NOCOM.items():
        for m in re.finditer(r'GROUND:AddMapStatus\(\s*"([a-z0-9_]+)"', s):
            st = m.group(1)
            if st not in have and st not in MOTEUR and st not in seen:
                seen.add(st)
                ln = s[:m.start()].count('\n') + 1
                problemes['H. MapStatus inconnu'].append(
                    f'"{st}" <- {os.path.relpath(p, ROOT)}:{ln}')


# =====================================================================
# 8. Item donne et absent de Data/Item
# =====================================================================
def check_items():
    idir = os.path.join(ROOT, 'Data', 'Item')
    if not os.path.isdir(idir):
        return
    have = {f[:-5] for f in os.listdir(idir) if f.endswith('.json')}
    seen = set()
    for p, s in NOCOM.items():
        for m in re.finditer(
                r"GAME:GivePlayer(?:Item|StorageItem)\(\s*['\"]([a-z0-9_]+)['\"]", s):
            it = m.group(1)
            if it not in have and it not in seen:
                seen.add(it)
                ln = s[:m.start()].count('\n') + 1
                problemes['I. Item inexistant donne au joueur'].append(
                    f'"{it}" <- {os.path.relpath(p, ROOT)}:{ln}')


# =====================================================================
# 9. require d'un module halcyon inexistant
# =====================================================================
def check_requires():
    seen = set()
    for p, s in CODE.items():
        for m in re.finditer(r"require\s+'halcyon\.([A-Za-z0-9_.]+)'", s):
            mod = m.group(1)
            path = os.path.join(SCRIPT, 'halcyon', *mod.split('.')) + '.lua'
            alt = os.path.join(SCRIPT, 'halcyon', *mod.split('.'), 'init.lua')
            if not os.path.exists(path) and not os.path.exists(alt) and mod not in seen:
                seen.add(mod)
                ln = s[:m.start()].count('\n') + 1
                problemes['J. require vers un module absent'].append(
                    f"halcyon.{mod} <- {os.path.relpath(p, ROOT)}:{ln}")


# =====================================================================
# 10. Cycles de require entre modules globaux
# =====================================================================
def check_require_cycles():
    graph = {}
    hdir = os.path.join(SCRIPT, 'halcyon')
    for fn in os.listdir(hdir):
        if not fn.endswith('.lua'):
            continue
        mod = fn[:-4]
        s = CODE.get(os.path.join(hdir, fn), '')
        graph[mod] = set(re.findall(r"require\s+'halcyon\.([A-Za-z0-9_]+)'", s))

    seen_cycles = set()

    def dfs(node, stack):
        for nxt in graph.get(node, ()):
            if nxt in stack:
                cyc = stack[stack.index(nxt):] + [nxt]
                key = tuple(sorted(set(cyc)))
                if key not in seen_cycles:
                    seen_cycles.add(key)
                    problemes['K. Cycle de require'].append(' -> '.join(cyc))
            elif nxt in graph:
                dfs(nxt, stack + [nxt])

    for m in graph:
        dfs(m, [m])


# =====================================================================
# 11. Piege Lua : virgule avalee par un commentaire
# =====================================================================
def check_comma_comment():
    """Champ de table dont la virgule a ete avalee par un commentaire.

    Ne se declenche QUE si la ligne PRECEDENTE se termine par une virgule :
    c'est la signature d'une vraie liste de champs. Sans ce garde-fou on
    remontait des affectations locales successives dans du code normal
    (8 faux positifs mesures : GeneralFunctions.lua:243 etc.).
    """
    pat = re.compile(
        r'^[ \t]*[A-Za-z_]\w*\s*=\s*[^,\n{]+--[^\n]*\n'
        r'[ \t]*[A-Za-z_]\w*\s*=', re.M)
    for p, s in ALL.items():
        lines = s.split('\n')
        for m in pat.finditer(s):
            ln = s[:m.start()].count('\n') + 1
            prev = lines[ln - 2].strip() if ln >= 2 else ''
            if not (prev.endswith(',') or prev.endswith('{')):
                continue
            problemes['L. Champ de table sans virgule (commentaire colle)'].append(
                f"{os.path.relpath(p, ROOT)}:{ln}")


# =====================================================================
# 12. Zone Released=false (invisible en jeu)
# =====================================================================
def check_released():
    zdir = os.path.join(ROOT, 'Data', 'Zone')
    if not os.path.isdir(zdir):
        return
    for fn in sorted(os.listdir(zdir)):
        if not fn.endswith('.json'):
            continue
        try:
            d = json.load(open(os.path.join(zdir, fn), encoding='utf-8-sig'))
        except Exception:
            continue
        o = d.get('Object', d)
        if o.get('Released') is False:
            problemes['M. Zone Released=false'].append(fn[:-5])


# =====================================================================
if __name__ == '__main__':
    for fn in (check_strings_format, check_module_calls, check_sv_fields,
               check_ground_handlers, check_zone_refs, check_groundmap_refs,
               check_mapstatus, check_items, check_requires,
               check_require_cycles, check_comma_comment, check_released):
        try:
            fn()
        except Exception as ex:
            problemes['!! controle en echec'].append(f"{fn.__name__}: {ex}")

    print("=" * 78)
    print("AUDIT DES BUGS D'EXECUTION")
    print("=" * 78)
    total = 0
    for cat in sorted(problemes):
        items = problemes[cat]
        total += len(items)
        print(f"\n{cat}  [{len(items)}]")
        for it in items[:25]:
            print(f"    {it}")
        if len(items) > 25:
            print(f"    ... et {len(items)-25} autres")
    print("\n" + "=" * 78)
    print(f"TOTAL : {total} signalement(s)")
    print("=" * 78)
