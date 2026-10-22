#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""red_compile_cinematics.py — compilateur cinématiques PMD Red EU → Lua
PMDO (modèle sky_compile_scenes.py, FAIL-CLOSED).

Sources canoniques (jamais approximées) :
  * Cinematics/dialogues/<ground>.json.gz — dialogue_ops décodés octet par
    octet de la ROM EU (69 stations), ordonnés par (script, command_index) :
    C'EST LE SEUL ORDRE PROUVÉ. Textes 5 langues ROM embarqués.
  * Cinematics/<ground>.cif.json — couche Audio/Effect/Camera/Animation.
    L'entrelacement exact avec les dialogues n'est PAS décodé : seule la
    piste BGM d'OUVERTURE (premier Audio SWITCH) est jouée, via la table
    STRICTE MUS_→ogg issue des extractions ROM (status PASS uniquement).
    Toutes les autres ops du cif sont comptées PARTIAL_OPS — jamais
    traduites en chorégraphie inventée, jamais ignorées silencieusement.

Règle fail-closed :
  * ground sans dialogue_ops → NOT_COMPILED_NO_DIALOGUE (pas de scène vide).
  * op de dialogue non-MSG inconnue → la scène reste compilée mais l'op est
    listée dans PARTIAL_OPS avec son opcode.
  * MUS_ hors table ROM → GAP tracé en commentaire, pas de piste substituée.

Sortie : Data/Script/halcyon/redscenes/<ground>__station.lua
         (signature function(hero, partner), kit partagé skyscenes.kit)
Rapport : PMD_RED_RESCUE_TEAM/Docs/RED_SCENE_COMPILER_REPORT.json
"""
import gzip
import json
import os
import re

ROOT = os.path.dirname(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CIN = os.path.join(ROOT, 'dev', 'CAMPAIGNS', 'PMD_RED_RESCUE_TEAM',
                   'Cinematics')
OUT_DIR = os.path.join(ROOT, 'Data', 'Script', 'halcyon', 'redscenes')
REPORT = os.path.join(ROOT, 'dev', 'CAMPAIGNS', 'PMD_RED_RESCUE_TEAM',
                      'Docs', 'RED_SCENE_COMPILER_REPORT.json')
AUDIO_DIR = os.path.join(ROOT, 'dev', 'docs', 'canonical', 'red', 'audio')
MUSIC_DIR = os.path.join(ROOT, 'Content', 'Music')

# table STRICTE MUS_ -> ogg : uniquement les extractions ROM PASS
MUS_MAP = {}
for f in ('pmdred_eu_music_extraction.json',
          'pmdred_eu_music_extraction_wave2.json',
           'pmdred_eu_music_extraction_wave3.json'):
    p = os.path.join(AUDIO_DIR, f)
    if not os.path.exists(p):
        continue
    for r in json.load(open(p))['results']:
        if r.get('status') == 'PASS' and r.get('output_ogg_name'):
            ogg = r['output_ogg_name'][:-4]
            if os.path.exists(os.path.join(MUSIC_DIR, ogg + '.ogg')):
                MUS_MAP[r['music_name']] = ogg

# opcodes dialogues (décodage EU) : D0/D1 = boîtes de message par variantes,
# D3 = question (menu oui/non NDS — rendu: dialogue simple, choix non
# simulé => compté PARTIAL), D9 = message standard.
# opcodes à texte vérifiés sur les blocs ROM décodés :
#   D0/D1/D9 = boîtes de message ; D3 = question (menu NDS)
#   32/33/39 = narration/panneau (préfixe #+) ; 34 = parole PNJ ;
#   37 = texte d'intro — tous portent des blocs 5 langues réels
MSG_OPS = {'0xD0', '0xD1', '0xD9', '0x32', '0x33', '0x34', '0x37', '0x39'}
QUESTION_OPS = {'0xD3'}


def _unmark(m):
    # ~XX = octet littéral échappé par l'extracteur : caractère imprimable
    # restitué tel quel (ex. ~27 = apostrophe) ; contrôles → espace.
    b = int(m.group(1), 16)
    return chr(b) if 0x20 <= b < 0x7F else ' '


def clean_text(s):
    if s is None:
        return None
    s = re.sub(r'~([0-9A-Fa-f]{2})', _unmark, s)
    # #W = pause GBA (wait), #C/#R = contrôles couleur/reset → retirés
    s = s.replace('#W', ' ').replace('#C', '').replace('#R', '')
    s = s.replace('#+', '')
    # $n0 = héros, $n1.. = interlocuteurs (résolution runtime kit) :
    # $n0 → [hero], autres → retirés (PARTIAL, noms de cast non résolus ici)
    s = s.replace('$n0', '[hero]')
    s = re.sub(r'\$[a-z][0-9]?', '', s)
    s = s.replace('\\n', ' ').replace('\n', ' ')
    s = re.sub(r'\s+', ' ', s).strip()
    return s


def lua_str(s):
    return '"' + (s or '').replace('\\', '\\\\').replace('"', '\\"') + '"'


# music_id ROM (op 0x44 arg1) -> ogg : PROUVÉ par les extractions ROM
# (pmdred_eu_music_extraction*.json, status PASS, mid inclus)
MUS_ID_MAP = {}
for _f in ('pmdred_eu_music_extraction.json',
           'pmdred_eu_music_extraction_wave2.json',
           'pmdred_eu_music_extraction_wave3.json'):
    _p = os.path.join(AUDIO_DIR, _f)
    if os.path.exists(_p):
        for _r in json.load(open(_p))['results']:
            if _r.get('status') == 'PASS' and _r.get('output_ogg_name'):
                _ogg = _r['output_ogg_name'][:-4]
                if os.path.exists(os.path.join(MUSIC_DIR, _ogg + '.ogg')):
                    MUS_ID_MAP[_r['music_id']] = _ogg


def compile_station_v2(gid, station, out_path):
    """Compile la SÉQUENCE ORDONNÉE des commands des scripts EU décodés
    (rapport all_stations) : dialogues (text_block 5 langues) + musique
    (0x44 music_id prouvé) + waits (0xE7 arg_short frames) dans l'ORDRE
    ROM exact (adresses croissantes par script). Ops sans équivalent =
    commentées avec opcode (fail-closed, comptées)."""
    lines = ['-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 '
             'séquence ROM) — NE PAS ÉDITER À LA MAIN.',
             f'-- Station canonique PMD Red EU : ground {gid} — ordre = '
             f'commands des scripts EU décodés (adresses ROM).',
             "local SkySceneKit = require 'halcyon.skyscenes.kit'",
             'return function(hero, partner)',
             '  pcall(function() UI:ResetSpeaker() end)']
    n_msgs = 0
    partial = []
    # text_block des commands = ADRESSE ; blocs réels dans
    # station['text_blocks'] (address -> languages 5 langues)
    blocks = {b['address']: b for b in station.get('text_blocks') or []}
    for s in station.get('scripts') or []:
        for cmd in s.get('commands', []):
            op = cmd['op_hex']
            tb = cmd.get('text_block')
            if isinstance(tb, str):
                tb = blocks.get(tb)
            if tb and isinstance(tb, dict):
                langs = tb.get('languages') or {}
                texts = {k: clean_text(v.get('text'))
                         for k, v in langs.items() if v.get('text')}
                if texts:
                    t = ('{english=' + lua_str(texts.get('en', ''))
                         + ', french=' + lua_str(texts.get('fr', ''))
                         + ', german=' + lua_str(texts.get('de', ''))
                         + ', italian=' + lua_str(texts.get('it', ''))
                         + ', spanish=' + lua_str(texts.get('es', ''))
                         + '}')
                    lines.append(f'  SkySceneKit.say({t})')
                    n_msgs += 1
                continue
            cats = cmd.get('categories') or []
            if 'music_or_fanfare' in cats and op == '0x44':
                mid = cmd['arg1']
                ogg = MUS_ID_MAP.get(mid)
                if ogg:
                    lines.append(f'  pcall(function() SOUND:PlayBGM('
                                 f"{lua_str(ogg + '.ogg')}, true) end) "
                                 f'-- 0x44 music_id {mid} (ROM)')
                else:
                    lines.append(f'  -- 0x44 music_id {mid}: GAP (pas '
                                 f'd\'ogg extrait ROM vérifié)')
                    partial.append(f'0x44:mid{mid}')
                continue
            if op == '0xE7':
                # wait n frames (arg_short) — observé jusque 60
                n = max(1, cmd.get('arg_short') or 1)
                lines.append(f'  GAME:WaitFrames({min(n, 300)}) -- 0xE7')
                continue
            if cats:
                partial.append(f'{op}:{"/".join(cats)}')
    lines.append('end')
    if n_msgs == 0:
        return None, partial
    open(out_path, 'w', encoding='utf-8').write('\n'.join(lines) + '\n')
    return n_msgs, partial


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    # V2: séquence ROM ordonnée depuis le rapport all_stations (130 PASS)
    all_p = os.path.join(ROOT, 'converter', 'rom_cache',
                         'eu_ground_scripts_all_stations.json')
    if os.path.exists(all_p):
        rep_all = json.load(open(all_p))
        cands = {c['asset']: c for c in rep_all['candidates']}
        report = {'schema': 'red_scene_compiler.v2',
                  'rule': ('ordre = commands des scripts EU décodés '
                           '(adresses ROM); texte=text_block 5 langues; '
                           'musique=0x44 music_id prouvé extractions ROM; '
                           'waits=0xE7; autres ops par catégorie = '
                           'PARTIAL comptées'),
                  'totals': {}, 'scenes': {}}
        n_comp = n_mute = 0
        for gid, st in sorted(cands.items()):
            outp = os.path.join(OUT_DIR, f'{gid}__station.lua')
            n_msgs, partial = compile_station_v2(gid, st, outp)
            if n_msgs:
                n_comp += 1
                report['scenes'][gid] = {
                    'status': 'COMPILED', 'messages': n_msgs,
                    'partial_ops': sorted(set(partial)) or None}
            else:
                n_mute += 1
                report['scenes'][gid] = {
                    'status': 'NOT_COMPILED_NO_DIALOGUE',
                    'evidence': '0 text_block dans les commands ROM'}
        report['totals'] = {'COMPILED': n_comp,
                            'NOT_COMPILED_NO_DIALOGUE': n_mute,
                            'stations': len(cands)}
        os.makedirs(os.path.dirname(REPORT), exist_ok=True)
        json.dump(report, open(REPORT, 'w', encoding='utf-8'),
                  ensure_ascii=False, indent=1)
        print(f"V2: COMPILED={n_comp} MUETTES={n_mute} "
              f"(sur {len(cands)} stations) ; musiques mid: "
              f"{len(MUS_ID_MAP)}")
        return
    grounds = sorted(f[:-8] for f in os.listdir(os.path.join(
        CIN, 'dialogues')) if f.endswith('.json.gz'))
    report = {'schema': 'red_scene_compiler.v1',
              'rule': ('FAIL-CLOSED: ordre = (script, command_index) ROM ; '
                       'ops cif non ordonnancées = PARTIAL_OPS, jamais '
                       'chorégraphie inventée ; MUS_ hors table ROM = GAP'),
              'mus_map_size': len(MUS_MAP),
              'totals': {}, 'scenes': {}}
    n_comp = n_skip = 0
    for gid in grounds:
        dp = os.path.join(CIN, 'dialogues', gid + '.json.gz')
        dj = json.load(gzip.open(dp))
        ops = dj.get('dialogue_ops') or []
        if not ops:
            report['scenes'][gid] = {'status': 'NOT_COMPILED_NO_DIALOGUE'}
            n_skip += 1
            continue
        # ordre prouvé : script puis command_index
        ops = sorted(ops, key=lambda o: (o['script'], o['command_index']))
        partial = []
        lines = []
        lines.append('-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py — '
                     'NE PAS ÉDITER À LA MAIN.')
        lines.append(f'-- Station canonique PMD Red EU : ground {gid} '
                     f'(dialogues ROM {dj.get("header_address")}).')
        lines.append('-- Ordre = (script, command_index) ROM. Textes 5 '
                     'langues ROM. Ops cif non ordonnancées: voir rapport.')
        lines.append("local SkySceneKit = require 'halcyon.skyscenes.kit'")
        lines.append('return function(hero, partner)')
        # BGM d'ouverture depuis le cif (table stricte)
        cifp = os.path.join(CIN, gid + '.cif.json')
        bgm_note = None
        cif_ops = []
        if os.path.exists(cifp):
            cif = json.load(open(cifp))
            cif_ops = cif.get('raw_sequence') or []
            first_sw = next((o for o in cif_ops
                             if o.get('type') == 'Audio'
                             and o.get('action') == 'SWITCH'), None)
            if first_sw:
                tr = first_sw.get('track')
                if tr in MUS_MAP:
                    lines.append('  pcall(function() SOUND:PlayBGM('
                                 + lua_str(MUS_MAP[tr] + '.ogg')
                                 + ', true) end)')
                    bgm_note = f'{tr} -> {MUS_MAP[tr]}.ogg (extraction ROM)'
                else:
                    bgm_note = f'GAP: {tr} hors table ROM stricte'
                    lines.append(f'  -- BGM {tr}: GAP (pas d\'ogg extrait '
                                 'ROM vérifié) — aucune piste substituée')
        lines.append('  pcall(function() UI:ResetSpeaker() end)')
        n_msgs = 0
        for o in ops:
            op = o.get('op')
            blk = o.get('block') or {}
            langs = blk.get('languages') or {}
            texts = {k: clean_text(v.get('text'))
                     for k, v in langs.items() if v.get('text')}
            if not texts:
                partial.append(f'{op}@{o.get("command_address")} sans texte')
                continue
            if op in MSG_OPS or op in QUESTION_OPS:
                t = ('{english=' + lua_str(texts.get('en', ''))
                     + ', french=' + lua_str(texts.get('fr', ''))
                     + ', german=' + lua_str(texts.get('de', ''))
                     + ', italian=' + lua_str(texts.get('it', ''))
                     + ', spanish=' + lua_str(texts.get('es', '')) + '}')
                lines.append(f'  SkySceneKit.say({t})')
                n_msgs += 1
                if op in QUESTION_OPS:
                    partial.append(
                        f'{op} question: menu oui/non NDS non simulé '
                        '(texte affiché, choix par défaut)')
            else:
                partial.append(f'{op} opcode dialogue non traduit')
        lines.append('end')
        # ops cif restantes = non ordonnancées
        for o in cif_ops:
            ty, ac = o.get('type'), o.get('action')
            if ty == 'Audio' and ac == 'SWITCH':
                continue  # première déjà traitée; suivantes ↓
            partial.append(f'cif {ty}:{ac or o.get("anim_id")} '
                           'non ordonnancée vs dialogues')
        if n_msgs == 0:
            report['scenes'][gid] = {'status': 'NOT_COMPILED_NO_TEXT'}
            n_skip += 1
            continue
        with open(os.path.join(OUT_DIR, f'{gid}__station.lua'), 'w',
                  encoding='utf-8') as f:
            f.write('\n'.join(lines) + '\n')
        report['scenes'][gid] = {
            'status': 'COMPILED',
            'messages': n_msgs,
            'bgm': bgm_note,
            'partial_ops': partial,
        }
        n_comp += 1
    report['totals'] = {'COMPILED': n_comp, 'SKIPPED': n_skip,
                        'grounds_with_dialogues': len(grounds)}
    os.makedirs(os.path.dirname(REPORT), exist_ok=True)
    with open(REPORT, 'w', encoding='utf-8') as f:
        json.dump(report, f, ensure_ascii=False, indent=1)
    print(f'COMPILED={n_comp} SKIPPED={n_skip} '
          f'(sur {len(grounds)} grounds à dialogues) ; '
          f'table MUS stricte: {len(MUS_MAP)} pistes')


if __name__ == '__main__':
    main()
