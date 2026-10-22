-- Lapis Cave canonique : 14F -> D08P02, sans boss/boutique/Monster House.
require 'origin.common'
require 'halcyon.GeneralFunctions'
local lapis_cave={}
function lapis_cave.Init(zone) DEBUG.EnableDbgCoro(); SV.TemporaryFlags.LastDungeonEntered='lapis_cave' end
function lapis_cave.EnterSegment(zone,rescuing,segmentID,mapID)
 if rescuing~=true then COMMON.BeginDungeon(zone.ID,segmentID,mapID) end
 GAME:SetRescueAllowed(true)
end
function lapis_cave.Rescued(zone,name,mail) COMMON.Rescued(zone,name,mail) end
function lapis_cave.ExitSegment(zone,result,rescue,segmentID,mapID)
 if COMMON.ExitDungeonMissionCheck(result,rescue,zone.ID,segmentID) then return end
 SV.adventure.Thief=false;SV.CanonicalDungeons=SV.CanonicalDungeons or {}
 if result==RogueEssence.Data.GameProgress.ResultType.Cleared then
  SV.CanonicalDungeons.Pending='lapis_cave_exit';GAME:EnterGroundMap('grotte_lazuli_fond','Main_Entrance_Marker')
 else GeneralFunctions.EndDungeonRun(result,'master_zone',-1,1,0,true,true) end
end
return lapis_cave
