#!/usr/bin/env python3
"""Construit le ground de retrouvailles « reveil_nuit » pour Destiny.

À partir du fichier complet ``Data/Ground/cliffdaytest_nuit.rsground`` (rétabli
par ``OUTILS/importer_cliffdaytest_nuit.py``), crée une variante narrative
complète et non découpée : mêmes terrains, calques animés, fonds nocturnes et
panorama de montagne. Seuls l'identifiant, le nom, les personnages de
présentation et trois marqueurs de scène sont ajustés. Les positions de héros,
partenaire et point de vue reprennent des emplacements valides de la map.

Sortie : ``quest_pmd_destiny/Data/Ground/reveil_nuit.rsground`` (JSON natif,
format complet). Scénario : ``Data/Script/destiny/ground/reveil_nuit/init.lua``.
Honnêteté : runtime_tested false.

Usage : .venv/bin/python OUTILS/construire_reveil_nuit_moteur.py
"""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GROUND = ROOT / 'quest_pmd_destiny' / 'Data' / 'Ground'

# Coordonnées et noms de marqueurs existants dans cliffdaytest_nuit.
# Le héros se réveille sur l'ancienne case walkable du personnage de la map;
# le partenaire rejoint le point de vue qui surplombe le paysage.
MARKERS = {
    'Main_Entrance_Marker': (632, 518),
    'WakeupLocation': (608, 476),
    'ScenicOverlook': (666, 516),
}


def main() -> int:
    src = GROUND / 'cliffdaytest_nuit.rsground'
    if not src.exists():
        print(f'(!) map absente : {src}')
        print('Lancer d’abord .venv/bin/python OUTILS/importer_cliffdaytest_nuit.py')
        return 1

    data = json.loads(src.read_text(encoding='utf-8-sig'))
    obj = data['Object']
    obj['AssetName'] = 'reveil_nuit'
    obj['Name'] = {
        'DefaultText': 'Clairière sous la montagne — Nuit',
        'LocalTexts': {'fr': 'Clairière sous la montagne — Nuit'},
    }
    obj['Comment'] = (
        'Ground narratif complet sur le panorama nocturne du cliffdaytest : '
        'réveil du héros, longue discussion sur la montagne au loin et rêve '
        'd’exploration, puis départ en duo pour Lost Wood.')
    obj['Music'] = 'Welcome to the World of Pokémon!.ogg'

    # Garder intacts les calques/terrains de la map ; supprimer seulement les
    # personnages de démonstration qui ne font pas partie de Destiny.
    for entity_layer in obj.get('Entities', []):
        entity_layer['MapChars'] = []
        entity_layer['GroundObjects'] = []
        entity_layer['Spawners'] = []
        markers = entity_layer.setdefault('Markers', [])
        by_name = {marker.get('EntName'): marker for marker in markers}
        for name, (x, y) in MARKERS.items():
            marker = by_name.get(name)
            if marker is None:
                marker = {
                    'EntName': name,
                    'Direction': 0,
                    'EntEnabled': True,
                    'EntOrder': 0,
                    'InteractOrder': 0,
                    'triggerType': 0,
                    'Collider': {'X': x, 'Y': y, 'Width': 16, 'Height': 16},
                }
                markers.append(marker)
            else:
                marker['Collider'] = {
                    'X': x, 'Y': y, 'Width': 16, 'Height': 16,
                }

    out = GROUND / 'reveil_nuit.rsground'
    out.write_text(json.dumps(data, ensure_ascii=False, indent=1),
                   encoding='utf-8-sig')
    print(f'{out} : {out.stat().st_size} octets; panorama et calques nuit conservés.')
    print('art_approved=false ; runtime_tested=false')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
