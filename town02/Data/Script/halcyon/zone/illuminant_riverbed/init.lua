require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.TownNight'

local illuminant_riverbed = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function illuminant_riverbed.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_illuminant_riverbed")
  --Mark this as the last dungeon entered.
  SV.TemporaryFlags.LastDungeonEntered = 'illuminant_riverbed'
  
end

function illuminant_riverbed.EnterSegment(zone, rescuing, segmentID, mapID)
	GeneralFunctions.CheckAllowSetRescue(zone.ID)
	if rescuing ~= true then
		COMMON.BeginDungeon(zone.ID, segmentID, mapID)
	end
end

function illuminant_riverbed.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end


function illuminant_riverbed.ExitSegment(zone, result, rescue, segmentID, mapID)
	GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> ExitSegment_illuminant_riverbed (Illuminant Riverbed) result "..tostring(result).." segment "..tostring(segmentID))
  	
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
	local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)

  if exited == true then
    --do nothing
	elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then


		GAME:WaitFrames(20)
		
		--set generic flags for generic end of day / start of next day.
		SV.TemporaryFlags.Dinnertime = true 
		--CHOIX DE FIN DE JOURNEE, variante a epilogue : la sauvegarde reste
		--l'avant-dernier acte et la replique de defaite s'affiche APRES l'ecran
		--de resultats, comme le voulait le code d'origine.
		TownNight.EndDayWithEpilogue(result, function()
			if not SV.Chapter2.FinishedRiver and result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then --team died before making it to the end for the first time. 
				GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1), "Argh...[pause=0] Ça ne s'est pas très bien passé...", "Pain")--set partner as speaker
				GAME:WaitFrames(20)
			end
		end)

	
	else 
		--dont set generic end flags if it's chapter 2 (i.e. you're rescuing numel)
		if SV.ChapterProgression.Chapter ~= 2 then 
			--set generic flags for generic end of day / start of next day.
			SV.TemporaryFlags.Dinnertime = true 
			SV.TemporaryFlags.Bedtime = true
			SV.TemporaryFlags.MorningWakeup = true 
			SV.TemporaryFlags.MorningAddress = true 
		
			GAME:EnterGroundMap('luminous_spring', 'Main_Entrance_Marker') --Go to Luminous Spring, end dungeon run in the ground rather than here 

		else--for chapter 2, dont show results and dont set generic end flags
			GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 20, 0, false, false) --Go to Luminous Spring 
		end
	end
end

return illuminant_riverbed