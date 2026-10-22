-- Magma Cavern canonique : 23F -> D12P02 -> Pit 3F -> D12P04/Groudon.
require 'origin.common'
require 'halcyon.GeneralFunctions'
local magma_cavern={}
function magma_cavern.Init(zone) DEBUG.EnableDbgCoro();SV.TemporaryFlags.LastDungeonEntered='magma_cavern' end
function magma_cavern.EnterSegment(zone,rescuing,segmentID,mapID)
 if rescuing~=true then COMMON.BeginDungeon(zone.ID,segmentID,mapID) end
 GAME:SetRescueAllowed(segmentID<2)
end
function magma_cavern.Rescued(zone,name,mail) COMMON.Rescued(zone,name,mail) end
function magma_cavern.ExitSegment(zone,result,rescue,segmentID,mapID)
 if COMMON.ExitDungeonMissionCheck(result,rescue,zone.ID,segmentID) then return end
 SV.adventure.Thief=false;SV.CanonicalDungeons=SV.CanonicalDungeons or {}
 if result~=RogueEssence.Data.GameProgress.ResultType.Cleared then GeneralFunctions.EndDungeonRun(result,'master_zone',-1,1,0,true,true);return end
 if segmentID==0 then SV.CanonicalDungeons.Pending='magma_cavern_mid';GAME:EnterGroundMap('gorge_ardente_coeur','Main_Entrance_Marker')
 elseif segmentID==1 then SV.CanonicalDungeons.Pending='magma_cavern_pit';GAME:EnterGroundMap('fosse_ardente','Main_Entrance_Marker')
 else SV.CanonicalDungeons.MagmaCavernCleared=true;GeneralFunctions.EndDungeonRun(result,'master_zone',-1,1,0,true,true) end
end
return magma_cavern
