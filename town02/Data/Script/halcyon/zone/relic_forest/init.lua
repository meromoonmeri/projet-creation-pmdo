require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.TownNight'

local relic_forest = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function relic_forest.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_relic_forest")
   
  --Mark this as the last dungeon entered.
  SV.TemporaryFlags.LastDungeonEntered = 'relic_forest'

end

function relic_forest.Rescued(zone, name, mail)
	COMMON.Rescued(zone, name, mail)
end

function relic_forest.ExitSegment(zone, result, rescue, segmentID, mapID)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> ExitSegment_relic_forest (Relic Forest) result "..tostring(result).." segment "..tostring(segmentID))
  GAME:SetRescueAllowed(false)

	--[[Different dungeon result typeS (cleared, died, etc)
	       public enum ResultType
        {
            Unknown = -1,
            Downed,
            Failed,
            Cleared,
            Escaped,
            TimedOut,
            GaveUp,
            Rescue
        }
		]]--
	if SV.ChapterProgression.Chapter == 1 then 
		if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
			--todo: make zone numbering consistent and perhaps better ordered
			if SV.Chapter1.PartnerEnteredForest and not SV.Chapter1.PartnerCompletedForest then--partner died solo before clearing
				GAME:EndDungeonRun(result, "master_zone", -1, 9, 0, false, false)
				--set partner as speaker
				GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(0), "Ouf...[pause=0] C'est difficile...", "Pain")
	
				GAME:WaitFrames(20)
				
				GAME:EnterZone("master_zone", -1, 9, 0)

			elseif SV.Chapter1.PartnerCompletedForest then--the duo wiped before making it back to town
				GAME:EndDungeonRun(result, "master_zone", -1, 0, 0, false, false)
				--set partner as speaker
				GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1), "Ouf...[pause=0] C'est difficile...", "Pain")
				
				GAME:WaitFrames(20)

				GAME:EnterZone("master_zone", -1, 0, 0)			
			else --failsafe
				print("error in resulting relic forest completion")
			end
		else 
		
			if SV.Chapter1.PartnerEnteredForest and not SV.Chapter1.PartnerCompletedForest then--partner made it through solo
				SV.Chapter1.PartnerCompletedForest = true	
				GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 0, 0, false, false)				
				
			elseif SV.Chapter1.PartnerCompletedForest then--the duo made it back to town
				SV.Chapter1.TeamCompletedForest = true
				GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 9, 0, false, false)
			else--failsafe 
				print("error in resulting relic forest completion")
			end
		end
	else--generic case (no special cutscenes to be played)
		--set generic flags for generic end of day / start of next day.
		SV.TemporaryFlags.Dinnertime = true 
		SV.TemporaryFlags.Bedtime = true
		SV.TemporaryFlags.MorningWakeup = true 
		SV.TemporaryFlags.MorningAddress = true 
		
		if result == RogueEssence.Data.GameProgress.ResultType.Cleared then	
			GAME:EnterGroundMap('relic_forest', 'Main_Entrance_Marker') --Go to Relic Forest Sanctum, end dungeon run in the ground rather than here 
		else 
			--CHOIX DE FIN DE JOURNEE (TownNight.EndDay). Uniquement sur la branche
			--de defaite : la victoire part au Sanctum (EnterGroundMap ci-dessus) et
			--ne doit pas etre detournee vers la ville.
			TownNight.EndDay(result, true)
		end
	end
end
	

return relic_forest