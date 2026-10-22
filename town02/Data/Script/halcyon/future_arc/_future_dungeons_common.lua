--[[
    Sortie commune des six donjons natifs de l'arc temporel.

    Ordre obligatoire : contrôle des missions, notification du contrôleur,
    puis EndDungeonRun vers le Ground enregistré avant l'entrée. Le résultat
    moteur est transmis sans le convertir : seul ResultType.Cleared progresse.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.future_arc.FutureArc'

FutureDungeonCommon = {}

function FutureDungeonCommon.GroundIdx(name)
  local ok, idx = pcall(function()
    local zones = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]
    local master = zones:Get('master_zone')
    for ii = 0, master.Grounds.Count - 1, 1 do
      if master.Grounds[ii] == name then return ii end
    end
    return -1
  end)
  if ok then return idx end
  return -1
end

function FutureDungeonCommon.HandleExit(result, rescue, zone, segmentID, fallbackGround)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()

  -- COMMON peut prendre entièrement en charge une sortie de mission/secours.
  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false
  if exited == true then return true end

  FutureArc.OnDungeonExit(zone.ID, result)
  local returnGround = FutureArc.GetDungeonReturnGround(fallbackGround)
  local groundIdx = FutureDungeonCommon.GroundIdx(returnGround)
  if groundIdx < 0 then
    PrintInfo('[FutureDungeonCommon] Ground de retour absent : ' .. tostring(returnGround))
    returnGround = fallbackGround or 'bourg_comptoir'
    groundIdx = FutureDungeonCommon.GroundIdx(returnGround)
  end

  GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, groundIdx, 0, false, false)
  return true
end

-- Compatibilité transitoire pour d'anciens appels ; ne contourne pas le
-- contrôleur et conserve donc la sémantique succès/échec.
function FutureDungeonCommon.ExitToGround(result, zoneId, groundName)
  FutureArc.OnDungeonExit(zoneId, result)
  local target = FutureArc.GetDungeonReturnGround(groundName)
  GeneralFunctions.EndDungeonRun(result, 'master_zone', -1,
    FutureDungeonCommon.GroundIdx(target), 0, false, false)
end

return FutureDungeonCommon
