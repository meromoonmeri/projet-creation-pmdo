#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sky_music_mid_map.py — table PROUVÉE mid (mappa floor music) -> piste.

AUTORITÉS (fail-closed, contre-épreuves intégrées) :
 1. overlay10 EU MUSIC_ID_TABLE @0x22C5EB4 (170 u16) et
    RANDOM_MUSIC_ID_TABLE @0x22C5B54 (30 groupes x 4 u16) — symboles
    pmdsky-debug, dumpés dans Tables/MUSIC_ID_TABLES.json.
 2. music_id -> NOM DE PISTE : liste BackgroundMusicIDs skytemple
    (music_id == index fichier SOUND/BGM/bgmNNNN), PROUVÉE par l'usage
    ROM réel des donjons à identité connue :
      d123 Star Cave       mid 72 -> music_id 141 (bgm0141 B_DUN_P3_HOSHI_)
      d124 Deep Star Cave  mid 73 -> music_id 142 (bgm0142 B_DUN_P3_HOSHI_)
      d128 Murky Forest    mid 75 -> music_id  94 (bgm0094 B_DUN_P3_P1_CHI)
      d130 Fortune Ravine  mid 77 -> music_id 146 (bgm0146 B_DUN_P3_ZAIHO_)
      d133 Barren Valley   mid 79 -> music_id 148 (bgm0148 B_DUN_P3_KOKATS)
      d136 Dark Wasteland  mid 81 -> music_id 149 (bgm0149 B_DUN_P3_KURAGA)
    L'enum music_id de pmdsky-debug DIVERGE de +1 au-delà de 138
    (ONE_FOR_ALL/_ALL_FOR_ONE comptés séparément) : il n'est PAS
    utilisable pour la plage 139+ — c'est la cause des identités
    erronées de la session précédente (mid 71 -> « Star Cave » au lieu
    de Deep Star Cave, RDT3 extrait de bgm0146=Fortune Ravine au lieu
    de bgm0145).
 3. Groupes RANDOM : music_id 145 (Random Dungeon Theme 3) apparaît
    dans le groupe 28 et JAMAIS comme piste fixe d'un donjon ; 146/147
    sont les pistes fixes de Fortune Ravine (d130/d131) et n'apparaissent
    dans AUCUN groupe RANDOM. 55 (groupe 20) et 45 (groupe 19) idem.

Sortie : Tables/MUSIC_MID_MAP.json
  { mid: {"music_id": N, "name": "...", "ogg": "X.ogg"}          (piste fixe)
    mid: {"random_group": G, "tracks": [4 x {music_id,name,ogg}]} (groupe) }
"""
import json
import os
import re

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TABLES = os.path.join(REPO, 'dev', 'CAMPAIGNS', 'PMD_SKY_EXPLORERS', 'Tables')

# music_id -> nom de fichier Content/Music (conventions PMDO existantes).
# Couvre toutes les valeurs atteignables par les mids des tables mappa
# d00-d179 (pistes fixes + membres des groupes RANDOM).
OGG = {
    21: 'Beach Cave.ogg', 22: 'Drenched Bluff.ogg', 23: 'Mt. Bristle.ogg',
    24: 'Waterfall Cave.ogg', 25: 'Apple Woods.ogg', 26: 'Craggy Coast.ogg',
    27: 'Cave and Side Path.ogg', 28: 'Mt. Horn.ogg', 29: 'Foggy Forest.ogg',
    30: 'Steam Cave.ogg', 31: 'Upper Steam Cave.ogg', 32: 'Amp Plains.ogg',
    33: 'Far Amp Plains.ogg', 34: 'Northern Desert.ogg',
    35: 'Quicksand Cave.ogg', 36: 'Quicksand Pit.ogg', 37: 'Crystal Cave.ogg',
    38: 'Crystal Crossing.ogg', 39: 'Chasm Cave.ogg', 40: 'Dark Hill.ogg',
    41: 'Sealed Ruin.ogg', 42: 'Sealed Ruin Pit.ogg', 43: 'Dusk Forest.ogg',
    44: 'Deep Dusk Forest.ogg', 45: 'Random Dungeon Theme 2.ogg',
    46: 'Brine Cave.ogg', 47: 'Lower Brine Cave.ogg', 48: 'Hidden Land.ogg',
    49: 'Hidden Highland.ogg', 50: 'Temporal Tower.ogg',
    51: 'Temporal Spire.ogg', 52: 'Mystifying Forest.ogg',
    53: 'Blizzard Island Rescue Team Medley.ogg', 54: 'Surrounded Sea.ogg',
    55: 'Random Dungeon Theme 1.ogg', 56: 'Aegis Cave.ogg',
    57: 'Concealed Ruins.ogg', 58: 'Mt. Travail.ogg',
    59: 'In the Nightmare.ogg', 60: 'Miracle Sea.ogg',
    61: 'Treeshroud Forest.ogg', 62: 'Dark Crater.ogg',
    63: 'Deep Dark Crater.ogg',
    94: 'Murky Forest.ogg', 95: 'Sky Peak Cave.ogg',
    96: 'Southern Jungle.ogg', 97: 'Sky Peak Coast.ogg',
    98: 'Spring Cave.ogg', 99: 'Lower Spring Cave.ogg',
    108: 'Temporal Pinnacle.ogg',
    139: 'Boulder Quarry.ogg', 140: 'Spring Cave Depths.ogg',
    141: 'Star Cave.ogg', 142: 'Deep Star Cave.ogg',
    143: 'Limestone Cavern.ogg', 144: 'Deep Limestone Cavern.ogg',
    145: 'Random Dungeon Theme 3.ogg', 146: 'Fortune Ravine.ogg',
    147: 'Fortune Ravine Depths.ogg', 148: 'Barren Valley.ogg',
    149: 'Dark Wasteland.ogg', 150: 'Spacial Cliffs.ogg',
    151: 'Dark Ice Mountain.ogg', 152: 'Icicle Forest.ogg',
    153: 'Vast Ice Mountain.ogg', 154: 'Vast Ice Mountain Peak.ogg',
    155: 'Sky Peak Forest.ogg', 156: 'Sky Peak Prairie.ogg',
    157: 'Sky Peak Snowfield.ogg', 158: 'Sky Peak Final Pass.ogg',
}


def skytemple_names():
    p = os.path.join(REPO, '.runtime-cache', 'sky-venv', 'lib')
    xml = None
    for root, _dirs, files in os.walk(p):
        if 'pmd2scriptdata.xml' in files:
            xml = os.path.join(root, 'pmd2scriptdata.xml')
            break
    assert xml, 'pmd2scriptdata.xml introuvable (sky-venv requis)'
    txt = open(xml).read()
    m = re.search(r'<BackgroundMusicIDs>(.*?)</BackgroundMusicIDs>', txt, re.S)
    return re.findall(r'<Bgm[^>]*>([^<]+)</Bgm>', m.group(1))


def main():
    t = json.load(open(os.path.join(TABLES, 'MUSIC_ID_TABLES.json')))
    main_t, rand_t = t['music_id_table'], t['random_music_id_table']
    names = skytemple_names()

    # -------- CONTRE-ÉPREUVES (fail-closed) --------
    proofs = [(1, 'BeachCave'), (31, 'TemporalSpire'), (72, 'StarCave'),
              (73, 'DeepStarCave'), (75, 'MurkyForest'),
              (77, 'FortuneRavine'), (78, 'FortuneRavineDepths'),
              (79, 'BarrenValley'), (81, 'DarkWasteland')]
    for mid, expect in proofs:
        got = names[main_t[mid]]
        assert got == expect, f'contre-épreuve FAIL mid {mid}: {got} != {expect}'
    # RDT3=145 : présent dans un groupe RANDOM, jamais piste fixe ;
    # 146/147 pistes fixes Fortune Ravine, jamais dans un groupe.
    in_groups = {v for row in rand_t for v in row}
    assert 145 in in_groups and 146 not in in_groups and 147 not in in_groups
    # 145 (RDT3) n'est piste fixe que du mid 120, référencé par AUCUNE
    # table mappa d00-d179 ; 146/147 = Fortune Ravine (d130/d131).
    assert [i for i, v in enumerate(main_t) if v == 145] == [120]
    assert [i for i, v in enumerate(main_t) if v == 146] == [77]
    assert [i for i, v in enumerate(main_t) if v == 147] == [78]
    assert 55 in in_groups and 45 in in_groups

    def entry(music_id):
        return {'music_id': music_id, 'name': names[music_id],
                'ogg': OGG.get(music_id)}

    out = {}
    for mid, v in enumerate(main_t):
        if v == 999:
            out[str(mid)] = {'music_id': 999, 'name': 'NONE', 'ogg': None}
        elif v >= 0x8000:
            g = v & 0x7FFF
            out[str(mid)] = {'random_group': g,
                             'tracks': [entry(x) for x in rand_t[g]]}
        else:
            out[str(mid)] = entry(v)

    doc = {
        'schema': 'sky-music-mid-map/1',
        'authority': ('overlay10 EU MUSIC_ID_TABLE+RANDOM_MUSIC_ID_TABLE '
                      '(pmdsky-debug) x BackgroundMusicIDs skytemple '
                      '(music_id == index bgmNNNN), contre-épreuves usage '
                      'ROM d123/d124/d128/d130/d133/d136 PASS'),
        'note': ("l'enum music_id pmdsky-debug diverge de +1 au-delà de 138 "
                 "et ne doit PAS servir d'identité pour la plage 139+ ; "
                 "groupes RANDOM = 4 pistes canoniques nommées par groupe "
                 "(tirage aléatoire ROM par visite)"),
        'mids': out,
    }
    p = os.path.join(TABLES, 'MUSIC_MID_MAP.json')
    json.dump(doc, open(p, 'w'), indent=1, ensure_ascii=False)
    print('CONTRE-EPREUVES PASS —', p)


if __name__ == '__main__':
    main()
