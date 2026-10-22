#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Construit Data/Ground/songe_source.rsground = clone de luminous_spring
adapte pour le rêve du chapitre 5 (voir docs/CONCEPTION_songe_source.md).

Garanties :
  - round-trip JSON prouve AVANT ecriture (un dump de la source relue est
    strictement identique au fichier d'origine) ;
  - le patch ne modifie QUE les champs listes dans MODIF ;
  - relecture + rapport champ par champ apres ecriture.
"""
import io, json, sys

SRC = 'Data/Ground/luminous_spring.rsground'
DST = 'Data/Ground/songe_source.rsground'
PERSO = 'Data/Ground/personality_test.rsground'


def load(p):
    with io.open(p, encoding='utf-8-sig') as f:
        return f.read()


def main():
    src_txt = load(SRC)
    perso_txt = load(PERSO)

    src = json.loads(src_txt)
    # --- preuve de round-trip : re-dump identique, sinon on ne touche a rien
    redump = json.dumps(src, ensure_ascii=False, indent=0)
    assert redump == src_txt, (
        'round-trip rompu sur luminous_spring : format inattendu, abandon')

    perso = json.loads(perso_txt)

    d = src
    obj = d['Object']

    modif = {}

    def patch(chemin, vieux, neuf):
        modif[chemin] = (vieux, neuf)

    # identite de la carte
    patch('Object.AssetName', obj['AssetName'], 'songe_source')
    obj['AssetName'] = 'songe_source'

    patch('Object.Name', obj['Name'], {
        'DefaultText': 'Dream Spring',
        'LocalTexts': {'fr': 'Source du Songe'},
    })
    obj['Name'] = {'DefaultText': 'Dream Spring',
                   'LocalTexts': {'fr': 'Source du Songe'}}

    patch('Object.Comment', obj.get('Comment', ''),
          "Le songe du heros (chap. 5) : la Source Lumiere revisitee en reve. "
          "Terrain clone de luminous_spring (verifie au pixel), ciel = parallaxe "
          "de reve du test de personnalite (verifie dans personality_test.rsground). "
          "Map purement cinematique : entree et sortie par EnterGroundMap.")
    obj['Comment'] = modif['Object.Comment'][1]

    patch('Object.Released', obj['Released'], False)
    obj['Released'] = False

    patch('Object.NoSwitching', obj['NoSwitching'], True)
    obj['NoSwitching'] = True

    # fond : dream parallax du test de personnalite, tel quel
    patch('Object.Background', obj['Background'], perso['Object']['Background'])
    obj['Background'] = perso['Object']['Background']

    # objets tactiles de la vraie source : aucun callback ici, on retire
    patch('Object.Entities[0].GroundObjects',
          [g.get('EntName') for g in obj['Entities'][0]['GroundObjects']], [])
    obj['Entities'][0]['GroundObjects'] = []

    out = json.dumps(d, ensure_ascii=False, indent=0)
    with io.open(DST, 'w', encoding='utf-8-sig') as f:
        f.write(out)

    # --- relecture et rapport
    relu = json.loads(load(DST))
    print(DST, 'ecrit.')
    print('modifications :')
    for k, (a, b) in modif.items():
        print('  ', k, ':', json.dumps(a, ensure_ascii=False)[:60],
              '->', json.dumps(b, ensure_ascii=False)[:60])
    # controle : tout le reste est identique a la source
    diff = []
    def cmp(pa, a, b):
        if a != b:
            diff.append(pa)
    for k in src:
        if k != 'Object':
            cmp(k, src[k], relu[k])
    for k in src['Object']:
        cmp('Object.' + k, src['Object'][k], relu['Object'][k])
    attendu = {'Object.AssetName', 'Object.Name', 'Object.Comment',
               'Object.Released', 'Object.NoSwitching', 'Object.Background',
               'Object.Entities'}
    inattendu = [x for x in diff if x not in attendu]
    if inattendu:
        print('CHAMPS MODIFIES NON PREVUS :', inattendu)
        sys.exit(1)
    print('controle champ par champ : OK (seuls les champs prevus different)')


if __name__ == '__main__':
    main()
