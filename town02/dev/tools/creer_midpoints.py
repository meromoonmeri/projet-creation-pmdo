#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
creer_midpoints.py — Midpoints des donjons canoniques PMD Red (méthode new_era_sky).

Méthode (identique au générateur du Réseau du Ciel, tools/gen_addon_sky_network.py) :
  - REPREND EXACTEMENT la zone relais canonique (searing_tunnel_midpoint :
    Main_Entrance_Marker, TEAMMATE_1..3, South_Exit/North_Exit, Kangaskhan_Rock,
    décorations, obstacles) ;
  - change UNIQUEMENT les AutoTiles (floor/secondary/wall) vers le triplet du
    donjon cible (celui référencé dans Data/Zone/<donjon>.json) ;
  - change AssetName, Nom FR, Comment (traçabilité), Musique ;
  - crée le script ground/<id>/init.lua (patron RELAY_INIT_LUA).

Midpoints créés :
  mt_thunder_midpoint   -> lightning_field_*       (Rising Fear.ogg)
  mt_blaze_midpoint     -> magma_cavern_*          (Deep Dark Crater.ogg)
  frosty_forest_midpoint-> frosty_forest_*         (Snow Camp.ogg)
  mt_freeze_midpoint    -> mt_freeze_*             (Summit.ogg)

Usage : python3 tools/creer_midpoints.py [--apply]
"""
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---
import io
import json
import os
import sys

ROOT = '.'
APPLY = '--apply' in sys.argv

TEMPLATE = 'Data/Ground/searing_tunnel_midpoint.rsground'

# (id, nom FR, triplet autotiles [floor, secondary, wall], musique, donjon)
MIDPOINTS = [
    ('mt_thunder_midpoint', 'Station du Mont Grondant',
     ['lightning_field_floor', 'lightning_field_secondary', 'lightning_field_wall'],
     'Rising Fear.ogg', 'mt_thunder'),
    ('mt_blaze_midpoint', 'Station du Mont Cendré',
     ['magma_cavern_floor', 'lightning_field_secondary', 'magma_cavern_wall'],
     'Deep Dark Crater.ogg', 'mt_blaze'),
    ('frosty_forest_midpoint', 'Station de la Forêt Givrée',
     ['frosty_forest_floor', 'frosty_forest_secondary', 'frosty_forest_wall'],
     'Snow Camp.ogg', 'frosty_forest'),
    ('mt_freeze_midpoint', 'Station du Mont Gelé',
     ['mt_freeze_floor', 'lightning_field_secondary', 'mt_freeze_wall'],
     'Summit.ogg', 'mt_freeze'),
]

# triplet source dans le template
SRC_TRIPLET = ['magma_cavern_2_floor', 'magma_cavern_2_secondary', 'magma_cavern_2_wall']

RELAY_INIT_LUA = '''--[[ {nfr_relay} — midpoint de {zid} (route canonique PMD Red).
     Patron new_era_sky : clone exact de la station-relais (Terminal Kangourex
     + réserve, sortie Nord = suite, sortie Sud = retour Metano). ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'

local {rid} = {{}}

function {rid}.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function {rid}.Enter(map)
  GAME:FadeIn(20)
end

function {rid}.Update(map) end

function {rid}.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function {rid}.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  GAME:FadeIn(20)
end

-- Sortie Nord : reprendre l'ascension (segment cime).
function {rid}.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:ChoiceMenuYesNo("Reprendre l'ascension ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    GAME:FadeOut(false, 60)
    GAME:EnterDungeon("{zid}", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end

-- Sortie Sud : redescendre (fin de run propre, retour Metano).
function {rid}.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:ChoiceMenuYesNo("Redescendre et rentrer ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SV.adventure.Thief = false
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, "master_zone", -1, 1, 0, true, true)
  end
end

-- Terminal de Sauvegarde (statue Kangourex) : sauvegarde + réserve natives.
function {rid}.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function {rid}.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return {rid}
'''


def load(p):
    return json.load(io.open(p, encoding='utf-8-sig'))


def save(p, d):
    with io.open(p, 'w', encoding='utf-8-sig') as f:
        json.dump(d, f, ensure_ascii=False, indent=2)


def remap_tiles(tiles, src, dst):
    """Remplace les AutoTileset du triplet source par le triplet cible."""
    mapping = dict(zip(src, dst))
    n = 0
    for row in tiles:
        for t in row:
            a = t.get('AutoTileset')
            if a in mapping:
                t['AutoTileset'] = mapping[a]
                n += 1
    return n


def main():
    if not os.path.exists(TEMPLATE):
        print('Template introuvable : %s' % TEMPLATE)
        return 1

    tpl = load(TEMPLATE)
    print('Template : %s (%d tuiles)' % (TEMPLATE,
          len(tpl['Object']['Layers'][0]['Tiles']) * len(tpl['Object']['Layers'][0]['Tiles'][0])))

    for mid, nfr, triplet, music, zid in MIDPOINTS:
        out = 'Data/Ground/%s.rsground' % mid
        if os.path.exists(out):
            print('  ! existe déjà : %s' % out)
            continue
        if not APPLY:
            print('  [dry-run] créerait %s (%s, %s)' % (mid, nfr, triplet))
            continue

        d = json.loads(json.dumps(tpl))  # copie profonde
        o = d['Object']
        o['AssetName'] = mid
        o['Name'] = {'DefaultText': 'Relay Station', 'LocalTexts': {'fr': nfr}}
        o['Comment'] = ('Midpoint de %s (route canonique PMD Red). Patron new_era_sky : '
                        'clone exact de searing_tunnel_midpoint, autotiles %s/%s/%s. '
                        'Terminal Kangourex + réserve, sortie Nord = suite, Sud = retour.'
                        % (zid, *triplet))
        o['Music'] = music
        tiles = o['Layers'][0]['Tiles']
        n = remap_tiles(tiles, SRC_TRIPLET, triplet)
        save(out, d)
        print('  créé %s (%d tuiles remappées %s)' % (out, n, triplet))

        # script
        sdir = 'Data/Script/halcyon/ground/%s' % mid
        os.makedirs(sdir, exist_ok=True)
        lua = RELAY_INIT_LUA.format(rid=mid, zid=zid, nfr_relay=nfr)
        with io.open(os.path.join(sdir, 'init.lua'), 'w', encoding='utf-8') as f:
            f.write(lua)
        print('  script %s/init.lua créé' % sdir)

    if not APPLY:
        print('\n(dry-run — relancer avec --apply)')
    return 0


if __name__ == '__main__':
    sys.exit(main())
