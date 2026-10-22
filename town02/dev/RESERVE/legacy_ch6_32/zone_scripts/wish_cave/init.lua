-- Wish Cave : 98 floors + 99F Jirachi, niveau 1, argent interdit.
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.LegendZones'
local wish_cave={}
function wish_cave.Init(zone)
 DEBUG.EnableDbgCoro();SV.TemporaryFlags.LastDungeonEntered='wish_cave';SV.WishCave=SV.WishCave or {};SV.WishCave.WishStone=true
end
function wish_cave.EnterSegment(zone,rescuing,segmentID,mapID)
 if rescuing~=true then COMMON.BeginDungeon(zone.ID,segmentID,mapID) end
 GAME:SetRescueAllowed(segmentID==0)
end
function wish_cave.Rescued(zone,name,mail) COMMON.Rescued(zone,name,mail) end
function wish_cave.ExitSegment(zone,result,rescue,segmentID,mapID)
 if COMMON.ExitDungeonMissionCheck(result,rescue,zone.ID,segmentID) then return end
 SV.adventure.Thief=false;SV.WishCave=SV.WishCave or {}
 if result~=RogueEssence.Data.GameProgress.ResultType.Cleared then GeneralFunctions.EndDungeonRun(result,'master_zone',-1,1,0,true,true);return end
 if segmentID==0 then GAME:EnterGroundMap('sanctuaire_voeu','Main_Entrance_Marker')
 else
  LegendZones.SetDefeated('unsaid_wishes');SV.WishCave.PendingWish=true
  SV.CanonicalDungeons=SV.CanonicalDungeons or {};SV.CanonicalDungeons.WishCaveCleared=true
  GAME:EnterGroundMap('sanctuaire_voeu','Main_Entrance_Marker')
 end
end
return wish_cave
