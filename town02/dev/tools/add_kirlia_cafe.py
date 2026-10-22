#!/usr/bin/env python3
"""Place le PNJ Kirlia (erudite de la Guilde, Quizz du Grand Tournoi ch8)
dans le Cafe Spinda (metano_cafe.rsground).

Methode imposee par le projet :
  - lecture en utf-8-sig, re-ecriture avec BOM ;
  - format JSON prouve par round-trip AVANT ecriture (metano_cafe = indent 0) ;
  - patch minimal : on ajoute UN objet a MapChars, rien d autre ne bouge ;
  - position validee au prealable par tools/_probe_cafe.py :
    libre (Tags==0), dans la composante accessible depuis Main_Entrance_Marker,
    sans chevauchement (marge 8 px) avec un collider existant.

Idempotent : ne fait rien si Kirlia est deja presente.
"""
import json
import sys

PATH = 'Data/Ground/metano_cafe.rsground'
NAME = 'Kirlia'
X, Y = 96, 168          # salon gauche, valide par la sonde
DIR = 6                 # Dir8.Right : tournee vers la salle, pas vers le mur


def build(model):
    """Construit l entite a partir d un MapChar existant, pour heriter
    exactement du schema serialise de cette version du moteur."""
    e = json.loads(json.dumps(model))
    e['EntName'] = NAME
    e['Direction'] = DIR
    e['serializationDir'] = DIR
    e['serializationLoc'] = {'X': X, 'Y': Y}
    e['Collider'] = {'X': X, 'Y': Y,
                     'Width': model['Collider']['Width'],
                     'Height': model['Collider']['Height']}
    e['EntEnabled'] = True
    e['AIEnabled'] = False
    e['IsInteracting'] = False
    d = e['Data']
    d['Nickname'] = ''                      # nom d espece affiche
    d['BaseForm'] = {'Species': 'kirlia', 'Form': 0,
                     'Skin': 'normal', 'Gender': 1}   # Gender.Female = 1
    d['Level'] = 1
    return e


def main():
    raw = open(PATH, encoding='utf-8-sig').read()
    doc = json.loads(raw)

    # 1. preuve du format avant toute ecriture
    if json.dumps(doc, ensure_ascii=False, indent=0) != raw:
        sys.exit('ABANDON : round-trip indent=0 non conforme sur %s' % PATH)

    layer = doc['Object']['Entities'][0]
    chars = layer['MapChars']

    if any(c['EntName'] == NAME for c in chars):
        print('Kirlia deja presente, rien a faire.')
        return

    model = next(c for c in chars if c['EntName'] == 'Cafe_Owner')
    chars.append(build(model))

    out = json.dumps(doc, ensure_ascii=False, indent=0)
    with open(PATH, 'w', encoding='utf-8') as f:
        f.write('\ufeff' + out)

    # 2. verification post-ecriture : relecture + diff structurel
    doc2 = json.loads(open(PATH, encoding='utf-8-sig').read())
    chars2 = doc2['Object']['Entities'][0]['MapChars']
    assert len(chars2) == len(chars), 'perte d entite a la re-lecture'
    assert any(c['EntName'] == NAME for c in chars2), 'Kirlia absente apres ecriture'
    delta = len(open(PATH, encoding='utf-8-sig').read().split('\n')) - len(raw.split('\n'))
    print('Kirlia ajoutee en (%d,%d), Dir=%d. MapChars : %d -> %d. Lignes ajoutees : %d'
          % (X, Y, DIR, len(chars) - 1, len(chars2), delta))


if __name__ == '__main__':
    main()
