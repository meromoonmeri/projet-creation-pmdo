-- Frosty Forest canonique : 9F -> D10P02 -> Grotto 5F -> D10P03/Articuno.
require 'origin.common'
require 'halcyon.GeneralFunctions'
local frosty_forest = {}
function frosty_forest.Init(zone) DEBUG.EnableDbgCoro(); SV.TemporaryFlags.LastDungeonEntered='frosty_forest' end
function frosty_forest.EnterSegment(zone,rescuing,segmentID,mapID)
  if rescuing~=true then COMMON.BeginDungeon(zone.ID,segmentID,mapID) end
  GAME:SetRescueAllowed(segmentID<2)
end
function frosty_forest.Rescued(zone,name,mail) COMMON.Rescued(zone,name,mail) end
function frosty_forest.ExitSegment(zone,result,rescue,segmentID,mapID)
  if COMMON.ExitDungeonMissionCheck(result,rescue,zone.ID,segmentID) then return end
  SV.adventure.Thief=false; SV.CanonicalDungeons=SV.CanonicalDungeons or {}
  if result~=RogueEssence.Data.GameProgress.ResultType.Cleared then
    GeneralFunctions.EndDungeonRun(result,'master_zone',-1,1,0,true,true); return
  end
  if segmentID==0 then
    SV.CanonicalDungeons.Pending='frosty_forest_mid'; GAME:EnterGroundMap('frosty_forest_midpoint','Main_Entrance_Marker')
  elseif segmentID==1 then
    SV.CanonicalDungeons.Pending='frosty_forest_summit'; GAME:EnterGroundMap('d10p03','Main_Entrance_Marker')
  else
    SV.CanonicalDungeons.FrostyForestCleared=true
    GeneralFunctions.EndDungeonRun(result,'master_zone',-1,1,0,true,true)
  end
end
return frosty_forest
