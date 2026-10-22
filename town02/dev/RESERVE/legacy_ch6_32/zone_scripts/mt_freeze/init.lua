-- Mt. Freeze canonique : 15F -> D11P02 -> Peak 5F -> D11P03/Ninetales.
require 'origin.common'
require 'halcyon.GeneralFunctions'
local mt_freeze = {}
function mt_freeze.Init(zone) DEBUG.EnableDbgCoro(); SV.TemporaryFlags.LastDungeonEntered='mt_freeze' end
function mt_freeze.EnterSegment(zone,rescuing,segmentID,mapID)
  if rescuing~=true then COMMON.BeginDungeon(zone.ID,segmentID,mapID) end
  GAME:SetRescueAllowed(true)
end
function mt_freeze.Rescued(zone,name,mail) COMMON.Rescued(zone,name,mail) end
function mt_freeze.ExitSegment(zone,result,rescue,segmentID,mapID)
  if COMMON.ExitDungeonMissionCheck(result,rescue,zone.ID,segmentID) then return end
  SV.adventure.Thief=false; SV.CanonicalDungeons=SV.CanonicalDungeons or {}
  if result~=RogueEssence.Data.GameProgress.ResultType.Cleared then
    GeneralFunctions.EndDungeonRun(result,'master_zone',-1,1,0,true,true); return
  end
  if segmentID==0 then
    SV.CanonicalDungeons.Pending='mt_freeze_mid'; GAME:EnterGroundMap('mt_freeze_midpoint','Main_Entrance_Marker')
  else
    SV.CanonicalDungeons.Pending='mt_freeze_summit'; GAME:EnterGroundMap('d11p03','Main_Entrance_Marker')
  end
end
return mt_freeze
