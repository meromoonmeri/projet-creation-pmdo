#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sky_compile_hub_npcs.py — NPC RÉSIDENTS des hubs Sky + interactions.

Source canonique : enter.sse de chaque level MAP porté (placements SSA :
acteur, entid→espèce, position, direction, script_id) + enterNN.ssb
(dialogue d'interaction du NPC, textes 5 langues ROM).

Généré : Data/Script/halcyon/skyscenes/hubnpc_<ground>.lua
  return { {species, x, y, dir, name, talk=function(hero,partner)...}, }
Le harnais (mode skyhub:) spawne les NPC (SkySceneKit.spawn_npc — même
mécanique native que le cast des scènes) puis JOUE l'interaction de
chaque NPC (talk) — dialogue ROM réel, pas un sprite statique.

FAIL-CLOSED : NPC sans script enterNN.ssb compilable = spawn seul, listé
'talk_missing' au rapport (jamais de dialogue inventé). Le dialogue
d'interaction utilise le même SceneCompiler que les cinématiques (branche
default des switch de progression = état de fin de partie documenté).
Sortie rapport : PMD_SKY_EXPLORERS/Docs/HUB_NPC_REPORT.json
"""
import glob
import gzip
import importlib.util
import json
import os
import re
import sys
from collections import OrderedDict

REPO = os.path.dirname(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CAMP = os.path.join(REPO, 'dev', 'CAMPAIGNS', 'PMD_SKY_EXPLORERS')
RS = os.path.join(CAMP, 'Cinematics', 'rom_scripts')
OUT_DIR = os.path.join(REPO, 'Data', 'Script', 'halcyon', 'skyscenes')
REPORT = os.path.join(CAMP, 'Docs', 'HUB_NPC_REPORT.json')

# réutiliser le compilateur de scènes (traductions op par op, fail-closed)
spec = importlib.util.spec_from_file_location(
    'scs', os.path.join(REPO, 'dev', 'tools', 'sky_compile_scenes.py'))
scs = importlib.util.module_from_spec(spec)
spec.loader.exec_module(scs)


def main():
    cl = json.load(open(os.path.join(
        CAMP, 'Docs', 'GROUND_CLASSIFICATION.json')))['grounds']
    have = {f[:-9] for f in os.listdir(os.path.join(REPO, 'Data', 'Ground'))
            if f.endswith('.rsground')}
    report = OrderedDict()
    n_npc = n_talk = n_missing = 0
    for g, e in sorted(cl.items()):
        if e['category'] != 'MAP':
            continue
        # collision Red/Sky (t00p01/t01p02a): le contenu Sky vit sous
        # <g>_sky — il PRIME (le fichier <g> homonyme est le Red GBA)
        pkg_gid = (g + '_sky') if (g + '_sky') in have else (
            g if g in have else None)
        if pkg_gid is None:
            continue
        zone = g.upper()
        p = os.path.join(RS, zone + '.json.gz')
        if not os.path.exists(p):
            continue
        z = json.load(gzip.open(p, 'rt'))
        ee = z['scripts'].get('enter.sse')
        if not ee or not ee.get('ssa'):
            continue
        npcs = []
        seen = set()
        for layer in ee['ssa']['layers']:
            for a in layer.get('actors', []):
                nm = a['actor_name']
                if not nm.startswith('NPC_') or nm in seen:
                    continue
                seen.add(nm)
                sp = scs.ENTID2SPECIES.get(a['entid']) or \
                    scs.ENTID2SPECIES.get(a['entid'] % 600)
                if not sp:
                    continue
                pos = a['pos']
                x = pos['x_relative'] * 8 + pos.get('x_offset', 0) * 4
                y = pos['y_relative'] * 8 + pos.get('y_offset', 0) * 4
                d = 'Direction.' + (pos.get('direction') or 'Down')
                sid = a.get('script_id', -1)
                npcs.append((nm, sp, x, y, d, sid))
        if not npcs:
            continue
        lua_npcs = []
        talks = []
        for nm, sp, x, y, d, sid in npcs:
            n_npc += 1
            talk_body = None
            if sid is not None and sid >= 0:
                sname = f'enter{sid:02d}.ssb'
                s = z['scripts'].get(sname)
                if s and s.get('explorerscript'):
                    comp = scs.SceneCompiler(zone, sname,
                                             s['explorerscript'], {})
                    defs = scs.parse_defs(s['explorerscript'])
                    d0 = next((dd for dd in defs if dd[0] == '0'), None)
                    if d0 is not None:
                        comp.compile_def0(d0[3])
                        if comp.dialogues > 0:
                            talk_body = '\n'.join(
                                '    ' + ln for ln in comp.lines
                                if 'SkySceneKit.say' in ln
                                or 'UI:SetSpeaker' in ln
                                or 'UI:ResetSpeaker' in ln)
            if talk_body:
                n_talk += 1
                talks.append((nm, talk_body))
                tfn = f'talk_{nm.lower()}'
            else:
                n_missing += 1
                tfn = 'nil'
            lua_npcs.append(
                f"  {{species={scs.lua_str(sp)}, x={x}, y={y}, dir={d}, "
                f"name={scs.lua_str(nm)}, talk={tfn}}},")
        lines = ['-- GÉNÉRÉ par dev/tools/sky_compile_hub_npcs.py — NE '
                 'PAS ÉDITER À LA MAIN.',
                 f'-- NPC résidents canoniques du hub {g} (enter.sse ROM '
                 f'Sky EU: placements SSA exacts,',
                 '-- dialogues enterNN.ssb 5 langues; talk=nil = script '
                 'ROM sans dialogue compilable, tracé).',
                 "local SkySceneKit = require 'halcyon.skyscenes.kit'"]
        for nm, body in talks:
            lines.append(f'local function talk_{nm.lower()}(hero, partner)')
            lines.append(body)
            lines.append('end')
        lines.append('return {')
        lines.extend(lua_npcs)
        lines.append('}')
        fn = f'hubnpc_{pkg_gid}'
        open(os.path.join(OUT_DIR, fn + '.lua'), 'w',
             encoding='utf-8').write('\n'.join(lines) + '\n')
        report[g] = {'package_ground': pkg_gid, 'file': fn + '.lua',
                     'npcs': len(npcs),
                     'with_talk': sum(1 for nm, _ in talks),
                     'talk_missing': [nm for nm, sp, x, y, d, sid in npcs
                                      if nm not in {t[0] for t in talks}]}
    doc = OrderedDict(
        schema='sky-hub-npc/1',
        authority='enter.sse (placements SSA ROM) + enterNN.ssb '
                  '(dialogues 5 langues ROM) par level MAP porté',
        rule='FAIL-CLOSED: pas de dialogue compilable = talk nil tracé, '
             'jamais inventé',
        totals={'hubs': len(report), 'npcs': n_npc, 'with_talk': n_talk,
                'talk_missing': n_missing},
        hubs=report)
    json.dump(doc, open(REPORT, 'w', encoding='utf-8'), ensure_ascii=False,
              indent=1)
    print(f'hubs: {len(report)}, NPC: {n_npc}, avec dialogue: {n_talk}, '
          f'sans: {n_missing}')


if __name__ == '__main__':
    main()
