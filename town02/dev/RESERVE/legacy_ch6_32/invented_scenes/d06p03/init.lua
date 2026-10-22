-- [dungeon_builder] script de Ground canonique généré — ne pas éditer à la main.
--[[ d06p03 — Ground final canonique de mt_thunder_peak.
     Ground canonique existant : la scène, le combat et la conclusion s'y
     déroulent au même endroit. Ce script assure uniquement la continuité du
     parcours ; les dialogues restent portés par la scène du Ground.
     Regénérer avec : python3 tools/dungeon_builder.py wire-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local d06p03 = {}

function d06p03.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d06p03.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons['mt_thunder_peak'] = true
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function d06p03.Update(map) end
function d06p03.GameSave(map) end
function d06p03.GameLoad(map)
  GAME:FadeIn(20)
end

return d06p03
