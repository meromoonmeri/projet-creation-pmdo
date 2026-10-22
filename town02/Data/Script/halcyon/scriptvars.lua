--[[
    scriptvars.lua
      This file contains all the default values for the script variables. AKA on a new game this file is loaded!
      Script variables are stored in a table  that gets saved when the game is saved.
      Its meant to be used for scripters to add data to be saved and loaded during a playthrough.
      
      You can simply refer to the "SV" global table like any other table in any scripts!
      You don't need to write a default value in this lua script to add a new value.
      However its good practice to set a default value when you can!
      
    --Examples:
    SV.SomeVariable = "Smiles go for miles!"
    SV.AnotherVariable = 2526
    SV.AnotherVariable = { something={somethingelse={} } }
    SV.AnotherVariable = function() print('lmao') end
]]--
print('Loading default script variable values..')
-----------------------------------------------
-- Services Defaults
-----------------------------------------------
SV = {}

SV.Services =
{
  --Anything that applies to services should be put in here, or assigned to this or a subtable of this in the service's definition script
}

-----------------------------------------------
-- Settings Defaults
-----------------------------------------------
-- This needs to be nil to avoid PMDO's stray default loads
-- SV.Settings = {
-- 	  Starters = 0,
--    Nicknames = 0
-- }

-----------------------------------------------
-- General Defaults
-----------------------------------------------
SV.General =
{
  Rescue = nil,
  Starter = MonsterID("missingno", 0, "normal", Gender.Genderless)
  --Anything that applies to more than a single level, and that is too small to make a sub-table for, should be put in here ideally, or a sub-table of this
}

SV.checkpoint = 
{
  Zone    = "master_zone", Structure  = -1,
  Map  = 1, Entry  = 0,
}

--Used for flags relevant for the current dungeon run. Currently just houses whether or not you've stolen from shopkeeps this dungeon run.
SV.adventure = 
{
  Thief    = false
}

SV.partner = 
{
	Spawn = 'Default',
	Dialogue = 'Default',
	LoadPositionX = -1,
	LoadPositionY = -1,
	LoadDirection = -1

}
SV.DestinationFloorNotified = false
SV.MonsterHouseMessageNotified = false
SV.OutlawDefeated = false
SV.OutlawGoonsDefeated = false
SV.MapTurnCounter = -1



--empty string or a -1 indicates that there's nothing there currently.
--board of jobs you've actually taken.
SV.TakenBoard =
{
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = "",
		BackReference = -1
	},
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = "",
		BackReference = -1
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = "",
		BackReference = -1
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = "",
		BackReference = -1
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = "",
		BackReference = -1
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = "",
		BackReference = -1
	},
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = "",
		BackReference = -1
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = "",
		BackReference = -1
	}

}

--jobs on the mission board.
SV.MissionBoard =
{
		{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	}

}

--Jobs on the outlaw board.
SV.OutlawBoard =
{
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = 1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	}
}
		
	



-------------------------------------------------
-- Temporary Flags - Flags that reset at the end of the day or on screen transition are saved here
-------------------------------------------------
--todo, move existing daily flags here
--These flags are to be reset to their initial values at the end of the day.
SV.DailyFlags = 
{
  RedMerchantItem = "",
  RedMerchantBought = false,
  GreenMerchantItem = "",
  GreenMerchantBought = false,
  
  GreenKecleonRefreshedStock = false,
  GreenKecleonStock = {},
  PurpleKecleonRefreshedStock = false,
  PurpleKecleonStock = {}

}

--Generic use flags 
SV.TemporaryFlags = 
{
	OldDirection = Direction.None,--Used for remembering which way an NPC was facing before turning to speak to you
	Dinnertime = false,--used to indicate whether generic dinner cutscene should be played on entering dining room
	Bedtime = false,--used to indicate whether to do a generic bedtime cutscene or not 
	MorningWakeup = false,--used to indicate whether to do a generic morning wakeup call or not when entering the heros room
	MorningAddress = false,--used to indicate whether to do a generic morning address
	JustWokeUp = false,--Did the duo JUST wake up on a new day?
	LastDungeonEntered = '',--Used to mark what dungeon the player was in last. Dojo dungeons don't count.This variable is set by init scripts for relevant zones.
	MissionCompleted = false,--used to mark if there are any pending missions to hand in.
	PostJobsGround = '',--used to mark the ground to go to after handing in randomly generated missions if the default choice of generic dinnertime is not wanted.
	PriorMapSetting = nil,--Used to mark what the player had their minimap setting whenever the game needs to temporarily change it to something else.
	AudinoSummonCount = 0--How many times have you made poor Rin run out for your assembly needs that day?
}


-----------------------------------------------
-- Level Specific Defaults
-----------------------------------------------

--todo: cleanup a lot of these
SV.metano_town = 
{
  Locale = 'Guild',--Where are we on the metano town map? Used for partner dialogue. Defaults to guild
  LastMarker = '',--which locale marker was touched last? we need to unhide it when another is touched.
  Song = 'Treasure Town.ogg'--song being played by the musician
  --LuxioIntro = false,
  --AggronGuided = false,
  --KecIntro = false
}

SV.metano_cafe =
{
  CafeSpecial = "",
  BoughtSpecial = false,
  FermentedItem = "", 
  ItemFinishedFermenting = false,
  NewDrinkUnlocked = false, --set to true when a new drink is unlocked so Dion knows to let the player know
  LastDailyCutsceneDay = -1
}


SV.Dojo = 
{
	LessonCompletedGeneric = false,--Player just completed a lesson, should we play a generic cutscene after?
	TrainingCompletedGeneric = false,--Player just completed a training, should we play a generic cutscene after?
	TrialCompletedGeneric = false,--Player just completed a trial, should we play a generic cutscene after?
	
	LessonFailedGeneric = false,--Player just failed a lesson, should we play a generic cutscene after?
	TrainingFailedGeneric = false,--Player just failed a training, should we play a generic cutscene after?
	TrialFailedGeneric = false,--Player just failed a trial, should we play a generic cutscene after?
	
	NewMazeUnlocked = false,--Was a new maze unlocked since the player last spoke to Ledian? If so have her mention that there are new mazes.
	NewLessonUnlocked = false,--Was a new lesson unlocked since the player last spoke to Ledian? If so have her mention that there are new lessons.
	NewTrialUnlocked = false,--Was a new trial unlocked since the player last spoke to Ledian? If so have her mention that there are new trials.
	
	SkippedTutorialNotifiedTeamMode = false,--If the player skips the tutorial, there should be a pop up in normal maze 1F that tells them about team mode. Only tell them about it once, though.
	LastZone = "master_zone"--Which dojo dungeon did the player just come out of?
}


-----------------------------------------------------------------------------
-- Chapter / Cutscenes flags. Flags that control the state of the story are stored here
----------------------------------------------------------------------------


--Keeps track of overall game progression flags (chapter number, important overarching flags, etc)
--Zones de recrutement des legendaires (stand de Grodoudou, Metano Town).
--Purchased[key]  : la zone a ete achetee -> on peut s'y rendre
--Defeated[key]   : le legendaire y a ete vaincu au moins une fois
--MetMerchant     : Grodoudou s'est deja presentee
--Voir Data/Script/halcyon/LegendZones.lua pour le catalogue.
SV.LegendZones =
{
	Purchased = {},
	Defeated = {},
	MetMerchant = false,
	ArrivalScenePlayed = false--cinematique d'installation du stand (retour d'expedition)
}


--ÉTAT DES ANCRAGES ET DU RÉSEAU DES VEILLEURS (scripts d’arc retirés tant qu’aucun flux runtime ne les consomme)
--
--Ces deux tables etaient lues 219 et 184 fois SANS etre declarees ici. Le
--code s'en sortait grace a des gardes dispersees (43 pour Anchors, 28 pour
--Reseau) du type « if SV.Anchors == nil then SV.Anchors = {} end » posees
--dans chaque fonction, plus un rattrapage dans debug_tools:589 pour Reseau.
--
--Deux raisons de les declarer malgre tout :
--  1. Le rattrapage de debug_tools vit dans OnUpgrade, qui n'est publie que
--     si Save.IsOldVersion() est vrai (TopMenu.cs:244, GameProgress.cs:1008).
--     Une partie neuve sur la version courante ne le declenche jamais.
--  2. Lire un champ d'une table ABSENTE crashe ; lire un champ absent d'une
--     table existante rend nil. Declarer supprime la classe d'erreur entiere
--     au lieu de compter sur l'exhaustivite des gardes.
--Les gardes existantes restent en place : elles sont idempotentes.
SV.Anchors =
{
	Adieux = {},    --[key] = true : l'adieu du gardien a deja ete joue
	Stabilized = {} --[key] = true : l'ancrage est stabilise
}

SV.Reseau =
{
	Veilleurs = {},     --[zone] = true : le veilleur de cette station est acquis
	Adieux = {},        --[key] = true : scene d'adieu jouee
	StationIntros = {}, --[station] = true : cinematique d'arrivee jouee une fois
	VoiesOuvertes = false--premiere victoire : ouvre le reseau
}


SV.ChapterProgression = 
{
	UnlockedDungeons = {},
	DaysPassed = 0,--total number of in game days played in the game
	DaysToReach = -1, --Used to figure out what day needs to be reached to continue the story
	Chapter = 1,
	CurrentStoryDungeon = "",--Used by the Destination Menu when leaving town to the right to know if it needs to set you somewhere else first before going to the dungeon (i.e. for a cutscene outside the dungeon). If the selected dungeon matches this value, then it will try to put you on the relevant ground that is that dungeon's entrance. Note: Relic Forest 1 and Illuminant Riverbed are handled by other objects, and thus aren't ever set to the current story dungeon.
	
	UnlockedAssembly = false,--this is set to true when player is allowed to recruit team members, unhides assembly objects
	StoryCompleted = false--MAIN STORY COMPLETION FLAG. Set when the final story dungeon is cleared (currently: Lugia defeated at Celestial Peak, chapter 10). End-game unlocks (e.g. Mega Stones shop) must check THIS flag, never a chapter-specific one. When chapters 11+ are added, move the assignment point to the new true ending — the flag name and consumers stay unchanged.
}


SV.Chapter1 = 
{
	PlayedIntroCutscene = false,
	PartnerEnteredForest = false,--Did partner go into the forest yet?
	PartnerCompletedForest = false,--Did partner complete solo run of first dungeon?
	PartnerMetHero = false,--Finished partner meeting hero cutscene in the relic forest?
	TeamCompletedForest = false, --completed backtrack to town?
	TeamJoinedGuild = false,--team officially joined guild? this flag lets you walk around guild without triggering cutscenes to talk to different guildmates

	--these flags mark whether you've talked to your new guild buddies yet. Need to talk to them all to go to sleep and end the chapter.
	MetSnubbull = false,--talked to snubbull?
	MetZigzagoon = false,
	MetCranidosMareep = false,
	MetBreloomGirafarig = false,
	MetAudino = false,
	
	--partner dialogue flag on second floor
	PartnerSecondFloorDialogue = 0,
	TutorialProgression = 0
}

SV.Chapter2 = 
{
	FinishedFirstWakeup = false,--Viewed first wake up cutscene?
	FirstMorningMeetingDone = false,--completed the first morning cutscene with the guild?
	StartedTraining = false,--started the training at ledian dojo?
	SkippedTutorial = false,--chose to do the training maze instead of the tutorial?
	FinishedTraining = false,--finished the preliminary training at ledian dojo?
	FinishedDojoCutscenes = false,--finished the last chapter 2 cutscene in ledian dojo that plays after finishing first maze/lesson?
	FinishedMarketIntro = false,--partner showed the hero the market?
	FinishedNumelTantrum = false,--watched numel's tantrum?
	FinishedFirstDay = false,--finished first day of chapter 2?
	FinishedCameruptRequestScene = false,--finished second morning address cutscene with the guild? (this only plays once, even if you die on the second day)
	
	EnteredRiver = false,--has player and partner attempted the dungeon of the chapter yet? used for a few npcs to mark that a day has passed since the initial request (i.e. you failed at least once)
	FinishedRiver = false,--player and partner have finished the dungeon and made it to Numel?
	
	TropiusGaveReviver = false,--did tropius give the free one off reviver seed?
	WooperIntro = false--talked to the wooper siblings? if not play their little cutscene
}

SV.Chapter3 = 
{
	ShowedTitleCard = false,--Did the generic wakeup for the first day? Need a variable for this due to chapter 3 title card.
	FinishedOutlawIntro = false,--did shuca and ganlon teach you about outlaws?
	MetTeamStyle = false,--did you meet team style?
	FinishedCafeCutscene = false,--did partner point out the cafe's open?
	EnteredCavern = false,--did duo enter the dungeon?
	FailedCavern = false,--did duo die in cavern to either dungeon or the boss?
	EncounteredBoss = false,--did duo find team style in the dungeon yet?
	LostToBoss = false,--did duo die to boss?
	EscapedBoss = false,--due team use an escape orb to escape boss?
	DefeatedBoss = false, --did duo defeat team style?
	RootSceneTransition = false, --Used to remember where in the root scene we are after transitioning away to show the root 
	FinishedRootScene = false, --Showed root scene? This is used to mark the first half of chapter 3 (the non filler portion) as having been completed or not
	FinishedMerchantIntro = false, --Did merchant intro cutscene?
	--DemoThankYou = false,--Showed demo thank you? Not needed for future versions.

	TropiusGaveWand = false,--did tropius give some wands to help the duo?
	BreloomGirafarigConvo = false, --talked to breloom/girafarig about their expedition?
	PostBossSpokeToCranidos = false -- Talked to cranidos in town after beating boss? Used to flag the partner to mention not being able to impress cranidos.
}

SV.Chapter4 = 
{
	ShowedTitleCard = false,--Did the generic wakeup for the first day? Need a variable for this due to chapter 4 title card.
	FinishedFirstAddress = false,--Did you get the address regarding your mission for the chapter and the expedition?
	FinishedAssemblyIntro = false,--did audino teach you about her assembly?
	FinishedSignpostCutscene = false,--Did audino show you her signpost for the assembly by the cafe?
	EnteredGrove = false,--has player set foot at all into the grove yet?
	BacktrackedOutGroveYet = false,--has player ever backtracked out the entrance of the grove yet? if not, give them a cutscene explaining what just happened
	ReachedGlade = false, --has player reached the glade yet?
	FinishedGrove = false,--has player finished the grove for good?
	FinishedBedtimeCutscene = false,--has player watched the bedtime cutscene? this is the last cutscene of this chapter
	
	TropiusGaveAdvice = false,--did you speak with Tropius day one?
	SpokeToRelicanthDayOne = false,--did you speak with relicanth day one?
	HeardRelicanthStory = false,--did you hear with relicanth's story? (TO BE USED ONCE STORY IS CREATED)
	MedichamMachampArgument = false,--did you see machamp and medicham arguing over their mailbox?
	CranidosBlush = false,--did Cranidos accidentally spill the beans on being a softy towards mareep?
	WoopersMedititeConvo = false,--did you see woopers and meditite talk to each other?
	DemoThankYou = false--Showed demo thank you?

}



SV.Chapter5 = 
{
	ShowedTitleCard = false,--Did the generic wakeup for the first day? Need a variable for this due to chapter 5 title card.
	TalkedToSnubbull = false,--Did player talk to Snubbull at the Kec Shop?
	SawZigzagoonFamilyCutscene = false,--Did Almotz's family see him off?
	GotFreeCafeItem = false,--Did Dion give you the free cafe drink?
	FinishedExpeditionAddress = false,--Did the address about the expedition starting today?
	ReadyForExpedition = false,--Talked to Penticus to ready up for the expedition?
	
	FinishedSteppeIntro = false,--Did the player see the intro cutscene for Vast Steppe?
	EnteredSteppe = false,--did player enter the steppe?
	LostSteppe = false,--did player die in steppe?
	EscapedSteppe = false,--Do we need to play the escaped from dungeon scene when loading this map?
	DiedSteppe = false,--Do we need to play the died in dungeon scene when loading this map?
	SpokeToTropiusSteppe = false,--Did you talk to tropius outside the steppe and get his foreshadowing/deferral?
	PlayedSteppeMidpointIntro = false,--Did the midpoint rest stop intro play?
	
	FinishedTunnelIntro = false,--Did the player see the nighttime+intro cutscene for Searing Tunnel?
	EnteredTunnel = false,--did player enter the tunnel?
	LostTunnel = false,--did player die in the tunnel or to the boss?
	TunnelLastExitReason = '',--Why did the player exit the tunnel to the entrance? Should be Died, Escaped, or Retreated
	PlayTempTunnelScene = false,--Do we need to play a one time scene outside the tunnel for having died/escaped/retreated?
	PlayedMidpointIntro = false,--Did you do the first "Let's go forward!" cutscene for the midpoint?
	TunnelMidpointState = 'FirstArrival',--What scene needs to play, and how do we handle midpoint respawning for almotz and hyko? can be FirstArrival, RepeatArrival, DeathArrival.
	EncounteredBoss = false, --Did the player encounter the slugmas?
	DefeatedBoss = false, --Did the player defeat the slugmas?
	DiedToBoss = false,--Did the player lose to the boss ever?
	JustDiedToBoss = false,--Did the player JUST die to the boss? This is a temporary flag that gets cleared after the boss death cutscene plays.
	SpokeToNoctowlTunnel = false,--Did you get some extra info about Hyko and Penticus's relation from Phileas?
	SpokeToCranidosTunnel = false,--Did you get to see Ganlon trying to be protective of Shuca?
	GrowlitheTropiusBossInterrupt = false,--did Hyko stop you from telling Penticus about the boss?
	
	FinishedMountWindsweptIntro = false,--Did the player see the intro cutscene for Mt. Windswept?
	--LE REVE DU HEROS se joue sur sa propre carte (hero_dream). Ce drapeau
	--encadre l'aller-retour : pose par CampNightfall juste avant le
	--depart, consomme par MorningAfterDream au retour. Sans lui,
	--PlotScripting relancerait ArrivalCutscene et toute la soiree se
	--rejouerait en boucle.
	CampNightWatchDone = false,
	DreamSceneSeen = false,--Le reve du Mont Venteux a-t-il ete vu ?
	--Garde anti-boucle du rattrapage de reve. Si on revient au camp avec
	--la veillee finie mais le reve jamais joue, PlotScripting retente la
	--bascule UNE fois ; ce drapeau interdit toute tentative ulterieure,
	--pour qu'un echec repete degrade la nuit au lieu de boucler.
	DreamRetryDone = false,
	MountLastExitReason = '',--Why did the player exit Mt. Windswept back to the entrance? Should be Died or Retreated.
	PlayTempMountScene = false,--Do we need to play a one time scene outside Mt. Windswept for having died/escaped/given up in the first stretch?
	EnteredMountain = false,--did player enter Mt. Windswept?
	LostMountain = false,--did player die in Mt. Windswept?
	DiedToWind = false,--did player's last run die to the time limit?
	EscapedMountain = false,--Do we need to play the escaped from dungeon scene when loading this map?
	DiedMountain = false,--Do we need to play the died in dungeon scene when loading this map?
	PlayedMountMidpointIntro = false,--Did the midpoint rest stop intro play?
	
	NeedGiveSupplies = false,--does penticus/phileas need to give supplies out?
	FinishedExpedition = false,
	RuinsExpeditionDone                = false,--l'expedition des Ruines est-elle bouclee ?
	RuinsBilanDone                     = false,--le bilan a la guilde a-t-il ete joue ?--chapter 5 clear boundary; no chapter 5 scene is changed by this flag
	FinishedBedtimeCutscene = false,--has player watched the post-expedition bedtime cutscene?

	--Cinematiques de mini-boss / gardiens : memorise la premiere rencontre pour
	--jouer la scene courte (SecondPreBossScene) aux tentatives suivantes.
	SteppeMiniBossSeen = false,

	--Scenes de vie aux relais (Prompt Maitre : respirations comiques/contemplatives)
	PlumSceneSeen = false,--Plum la Rondoudou a-t-elle chante au relais de la steppe ?
	--PLUM AU CAMP DU MONT VENTEUX. Arme par son irruption pendant le repas
	--(mount_windswept_entrance_ch_5.CampNightfall, section 4bis) et relu par
	--TOUT ce qui recompose le bivouac ensuite : deploiement des couchages
	--(sa paillasse n'existe que si elle est la), retour du reve, matin,
	--rassemblement, depart des cordees. C'est le drapeau qui garantit qu'elle
	--ne disparait pas silencieusement entre deux beats de la meme soiree.
	PlumAtMountCamp = false,
	--A-t-elle deja fait ses adieux au matin ? Empeche de rejouer la scene
	--si le joueur repasse par le camp apres l'intro.
	PlumLeftMountCamp = false,
	--L'echange avec Shuca et Ganlon devant la porte du donjon (beat 4.10
	--du plan) : joue UNE SEULE FOIS, au premier passage apres l'intro.
	--Sans ce drapeau il se rejouerait a chaque aller-retour du joueur
	MountDoorTalkDone = false,
	FragmentSceneSeen = false,--Le Fragment (Meteno) est-il tombe pres du relais du Mont ?
	SteppeNightSceneSeen = false,--La veillee du camp (Hyko x Almotz) a-t-elle ete jouee ?
	MountVigilSceneSeen = false,--La derniere veillee avant le sommet a-t-elle ete jouee ?

	--Legendes racontees par les aines (mentions de legendaires, jamais de rencontre)
	LegendTitansHeard = false,--Rubble (cafe) : les Trois Serviteurs et le Colosse (Regi + Regigigas)
	LegendLakeHeard = false,--Relicanth (etang) : les Trois Lacs (Crehelf/Crefollet/Crefadet)
	LegendSkyHeard = false,--Aubergiste Nidoqueen : les deux Gardiens du ciel (Ho-Oh/Lugia)
	LegendFurnaceHeard = false,--Phileas (camp du Tunnel) : le Fourneau et les Coeurs (Heatran)
	LegendEarthHeard = false,--Dotra (maison feu) : Celui qui Dort sous les Volcans (Groudon)
	SteppeMidState = nil,--vague 8 : 'DeathArrival' si mort au-dela du checkpoint
	TunnelMidState = nil,
	WindsweptMidState = nil,--vague 8 : 'DeathArrival' si mort au-dela du checkpoint
	--Retour A L'AMIABLE au relais du Mont (repli volontaire par la sortie
	--sud, ou reprise d'une sauvegarde faite au rocher de Kangourex).
	--Declenche l'etat RepeatArrival du template de point median, distinct
	--du reveil apres KO porte par WindsweptMidState.
	WindsweptMidReturn = false,
	LegendHeroesHeard = false,--Grodoudou : les Heros d'Autrefois (meteorite, temps arrete, 25 ans de calme)
	LegendSkyArbiterHeard = false,--Reinier (camp du Mont) : l'Arbitre du Ciel (Rayquaza)

	--Cinematiques d'enjeu de l'expedition
	SkyTremorSceneSeen = false,--Le premier pulse du sommet vu depuis le camp de la steppe
	HadFirstDream = false,--Premier reve du heros (memoire du gardien du sceau) — nuit post-expedition
	WindSecretSceneSeen = false,--Le secret Hyko x Penticus surpris de nuit au camp du Mont
	SteppeGuardianSeen = false,
	TunnelMiniBossSeen = false,
	MountMiniBossSeen = false,
	MountGuardianSeen = false,

	--Flags de routage post-combat (poses par zone ExitSegment, lus par ground map Enter).
	--Doivent etre remis a false APRES la scene de victoire/defaite.
	SteppeMiniBossDefeated = false,
	SteppeMiniBossLost = false,
	SteppeGuardianDefeated = false,
	SteppeGuardianLost = false,
	TunnelMiniBossDefeated = false,--arene du clan de lave (seg 2 du Tunnel Ardent)
	TunnelMiniBossLost = false,
	MountMiniBossDefeated = false,
	MountMiniBossLost = false,
	MountGuardianDefeated = false,
	MountGuardianLost = false,

	--Flags PERSISTANTS de victoire mini-boss (audit IsGameOver) : contrairement
	--aux flags de routage ci-dessus (remis a false apres la scene), ceux-ci
	--restent true pour toujours — le relais les lit pour savoir s'il faut
	--rejouer la rencontre du mini-boss ou passer directement au segment suivant.
	SteppeMiniBossCleared = false,
	TunnelMiniBossCleared = false,
	MountMiniBossCleared = false,

	-- ============ AEGIS CAVE (climax du ch5, option 2 validee) ============
	--Apres la victoire sur Tornadus, l'expedition etablit un campement
	--devant l'entree des Aegis Cave (cloven_ruins_entrance) au lieu
	--de rentrer a Metano : respiration narrative avant le donjon final.
	--  RuinsCampPending    : on arrive au camp et la cinematique d'arrivee
	--                        (briefing autour du feu) doit se jouer.
	--  RuinsCampDone       : l'arrivee + le briefing du soir sont joues.
	--  RuinsCampNightDone  : la veillee est terminee, le reve a ete
	--                        bascule (encadre l'aller-retour hero_dream).
	--  RuinsDreamSeen      : le reve (Gardevoir) a ete vu (pose par
	--                        hero_dream/init.lua quand DreamReturn==Ruines).
	--  RuinsEntered        : le joueur a franchi l'entree des Ruines.
	--  RuinsExpeditionDone : les Aegis Cave sont terminees — le ch5
	--                        se clot et le retour a Metano peut avoir lieu.
	RuinsCampPending = false,
	RuinsCampDone = false,
	RuinsCampNightDone = false,
	RuinsDreamSeen = false,
	RuinsEntered = false,
	--RuinsEntryTalkDone : la petite scene Penticus/Phileas juste avant
	--l'entree dans le donjon n'est jouee qu'une seule fois. (Depuis
	--2026-08-04 : la scene se joue apres la victoire sur le 1er Regi.)
	RuinsEntryTalkDone = false,
	--RegisteelDepartDone : apres avoir vaincu Registeel, Penticus et
	--Phileas s'inquietent pour le duo parti dans le Puits et decident de
	--rentrer a la guilde ramener des renforts (ce qui rend coherente leur
	--intervention face a Regigigas avec le reste de la guilde). Une seule
	--fois.
	RegisteelDepartDone = false,
	--Routage de retour au camp apres une sortie de donjon (KO/abandon).
	--  PlayTempRuinsScene  : le camp doit jouer la cinematique de retour
	--                        (pose par zone ExitSegment / ground boss).
	--  RuinsLastExitReason : 'Died' (KO) ou 'Retreated' (abandon volontaire).
	PlayTempRuinsScene = false,
	RuinsLastExitReason = '',
	RuinsRespawnArena = nil,
	RuinsMidState = nil,
	RuinsMidpointState = 'FirstArrival',
	RuinsMidReturn = false,
	RuinsMiniBossSeen = false,
	RuinsMiniBossDefeated = false,
	RuinsMiniBossLost = false,
	LostRuins = false,
	LostDepths = false,
	DefeatedRuinsBoss = false,
	DiedToRuinsBoss = false,
	SawAnimaCoreCorruption = false,
	RuinsExpeditionDone = false
}


SV.Chapter6 = 
{
	-- Chapter 6 starts only after the chapter boundary sets ChapterProgression.Chapter to 6.
	DazzlingAegisAftermath = false,--teaser joué après Regigigas, jamais avant/dans Aegis Cave
	DazzlingIntroPlayed = false,
	MissionAvailable = false,
	MissionAccepted = false,
	EnteredGloomyForest = false,
	--D04P01 approche sobre, distincte de la confrontation D04P02 recastée.
	SinisterApproachSeen = false,
	FinishedGloomyForestIntro = false,
	GloomyBossEncountered = false,
	DefeatedGloomyBoss = false,
	DiedToGloomyBoss = false,
	ChenipentFound = false,
	MissionComplete = false,
	PostMissionScenePlayed = false,
	DefeatedByZeraora = false,
	DazzlingTownVisit = 0,
	ShowedTitleCard = false,--Has the Chapter 6 title card been shown?
	PostDefeatScenePlayed = false,
	--Relais de mi-donjon. Ces deux champs etaient lus par
	--ground/gloomy_forest_midpoint et ecrits par zone/gloomy_forest, mais
	--n'etaient declares NULLE PART : seul le rattrapage OnUpgrade de
	--debug_tools les creait. Une partie NEUVE arrivait donc au relais avec
	--GloomyPlayedMidpointIntro == nil.
	GloomyPlayedMidpointIntro = false,
	GloomyMidpointState = 'FirstArrival',
	--Retour A L'AMIABLE au relais de la Foret (reprise d'une sauvegarde
	--faite sur place : ce relais n'a pas de sortie arriere). Declenche
	--l'etat RepeatArrival du template de point median.
	GloomyMidReturn = false,
	--Apres-boss de Zeraora (DazzlingArc.GloomyVictory). Le chapitre 6 etait
	--le seul chapitre a boss sans scene de consequence.
	PlayedVictoryScene = false,
	--Duel amical contre la Team Dazzling (segment 7 de gloomy_forest).
	--Jusqu'ici elles narguaient le joueur sans l'avoir jamais affronte.
	DazzlingTrialOffered = false,
	DazzlingTrialStarted = false,
	--Gardiens du coeur (mini-boss segment 2 : Tengalice + Cornèbre). Meme
	--dispatch que le ch5 : Seen (cinematique vue), Defeated (victoire, un
	--passage), Lost (defaite, un passage). Lus par ground/gloomy_forest_miniboss,
	--ecrits par zone/gloomy_forest (segment 2).
	GloomyMiniBossSeen = false,
	GloomyMiniBossDefeated = false,
	GloomyMiniBossLost = false,
	DazzlingTrialCleared = false,
	PlayedTrialVictory = false,
	PlayedTrialDefeat = false,
	--LA CONFRONTATION DE LA PLACE (DazzlingPlaza.lua). Premiere vraie
	--rencontre avec la Team Dazzling, jouee au centre de Metano.
	--  PlazaMet     : la rencontre a eu lieu. Verrou d'unicite : elle
	--                 ne peut plus jamais etre rejouee.
	--  PlazaOutcome : 'win' ou 'loss'. Lu par les dialogues des temoins
	--                 (DazzlingPlaza.Temoin) et par la suite du recit.
	--  PlazaPending : issue du combat en attente de mise en scene, posee
	--                 par zone/gloomy_forest (segment 7) et consommee au
	--                 retour sur metano_town. false = rien en attente.
	PlazaMet = false,
	PlazaOutcome = nil,
	PlazaPending = false,
	--Le chevet a la guilde attend d'etre joue (consomme par
	--guild_heros_room.PlotScripting a l'arrivee dans la chambre).
	PlazaBedsidePending = false,
	--LA CHAMBRE DU MAITRE. Jusqu'ici sa porte (guild_third_floor_lobby,
	--Door_Exit_Touch) etait ouverte en permanence des le ch2 : on pouvait
	--entrer chez Penticus a n'importe quel moment et n'y trouver personne
	--a qui parler. Elle se merite desormais, et s'ouvre au retour de
	--l'expedition, par une audience.
	GuildmasterRoomUnlocked = false,--la porte est-elle franchissable ?
	PlayedGuildmasterAudience = false--l'audience de retour a-t-elle eu lieu ?
}



--LA NUIT A METANO (TownNight, TownNightScenes).
--Declare ICI et pas seulement a l'usage : le bug des champs
--GloomyPlayedMidpointIntro / GloomyMidpointState, jamais declares, a deja
--coute une partie neuve qui arrivait avec nil. TownNight.Ensure() reste en
--place pour les sauvegardes anterieures, mais une partie neuve doit trouver
--la table complete.
SV.TownNight =
{
	Visits = 0,          --nombre de nuits explorees
	Met = {},            --[instance PNJ] = nombre de conversations
	SawStars = false,    --la Compteuse d'Etoiles a livre sa revelation
	Seen = {},           --['ChN'] = scene d'arrivee du chapitre N deja jouee
	VoiceHeard = {}      --['ChN'] = la Voix a parle au puits au chapitre N
}

--LES PILLARDS DE METANO (TownRaid).
--Raids nocturnes : le joueur defend la ville contre des rodeurs spectres.
SV.TownRaid =
{
	Repelled = 0,        --raids repousses
	Lost = 0,            --raids perdus
	Pending = false,     --un raid est en cours (pose avant le combat)
	Wave = 0,            --palier du dernier raid (1 a 3)
	LastDay = -1,        --DaysPassed du dernier raid, pour l'espacement
	Told = {}            --reactions de la ville deja vues
}

--LE TOUR DE GUET (NightWatch).
--La guilde inscrit les equipes au registre des veilles : c'est la raison
--narrative pour laquelle le heros est dehors la nuit.
SV.NightWatch =
{
	Explained = false,   --la regle du registre a ete enseignee (1er tour)
	Tours = 0,           --tours de garde effectues
	LastTour = -1,       --DaysPassed du dernier tour, pour l'espacement
	Assigned = false     --un tour est impose ce soir
}

--LE PRIX D'UNE NUIT PERDUE (TownPlunder).
--Ce que les pillards emportent quand le raid est perdu.
SV.TownPlunder =
{
	ShopsEmpty = false,  --les etals sont vides aujourd'hui
	LastStolen = 0,      --argent pris a la banque la derniere fois
	LastItems = {},      --noms des objets pris dans le sac
	TotalRaids = 0       --nuits perdues au total
}

--CE QUE LA VILLE DONNE (TownReward).
--Recompenses d'un raid repousse, et felicitations du lendemain.
SV.TownReward =
{
	Pending = false,     --felicitations publiques a jouer au prochain passage
	LastWave = 0,        --vague repoussee la derniere fois (1 a 3)
	LastItems = {},      --noms des objets recus
	LastMoney = 0,       --argent recu
	Total = 0            --defenses reussies au total
}

--LA VILLE PARLE DE LA NUIT (TownVoicesNight).
--Said[instance] = jour ou ce PNJ a deja reagi : une fois par journee.
SV.TownVoicesNight =
{
	Said = {}
}

--LES SAISONS DE METANO (Seasons.lua).
--Le decor de la ville suit l'avancement du recit. Declare ICI et pas
--seulement a l'usage : le bug des champs jamais declares a deja coute
--une partie neuve arrivant avec nil.
SV.Seasons =
{
	Echelle = 'court',  --'court' = 4 saisons sur les 10 chapitres joues
	                    --'long'  = decoupage sur 30 chapitres (7/15/22/30)
	Courante = '',      --derniere saison appliquee
	Vues = {},          --[saison] = le partenaire l'a deja commentee
	Actif = true        --interrupteur general
}

--LA CHAMBRE OU DORT PENTICUS (guild_guildmasters_bedroom).
--Carte neuve, clonee de guild_top_right_bedroom : c'etait la seule a
--posseder deja des marqueurs de lit (Audino_Bed / Snubbull_Bed), renommes
--Penticus_Bed / Phileas_Bed. Accessible par une porte au fond du bureau.
SV.GuildmasterBedroom =
{
	Visited = false,          --la premiere entree a-t-elle ete commentee ?
	ReadPenticusBed = false,  --le lit du maitre a-t-il ete examine ?
	ReadPhileasBed = false    --et celui du savant ?
}

--info related to guild member sidequests.
SV.GuildSidequests = 
{
	--Last known levels for guild members. These start being used on the expedition.
	--If you level them up more during the expedition, they'll keep more of their levels when you do stuff with them later.
	ZigzagoonLevel = 19,
	GrowlitheLevel = 16,
	SnubbullLevel = 17,
	AudinoLevel = 16,
	MareepLevel = 19,
	CranidosLevel = 20
--	BreloomLevel = 33,
--	GirafarigLevel = 32
}

----------------------------------
--Dungeon relevant flags 
----------------------------------
SV.DungeonFlags = 
{
	GenericEnding = false--do a generic ending for the end of a dungeon in the relevant zone/ground
}

--Routage des paquets canoniques Red restaurés (Ground cinématique -> segment).
SV.CanonicalDungeons =
{
	Pending = nil,
	MtBlazeCleared = false,
	FrostyForestCleared = false,
	MtFreezeCleared = false,
	LapisCaveCleared = false,
	MagmaCavernCleared = false,
	WishCaveCleared = false
}

SV.WishCave = { WishStone=false, PendingWish=false, WishGranted=false }
SV.FriendAreas = { Owned={}, Residents={} }

-- Campagne canonique Rescue Team après la trame New Era existante.
-- Les vagues sont parallèles : aucun ordre fictif n'est imposé entre les arcs
-- postgame du jeu original. Les extensions New Era restent des overlays.
SV.PostgameRed =
{
	Unlocked = false,
	Waves = {},
	Cleared = {},
	Bosses = {},
	Seen = {}
}

-- Donjons canoniques Explorers of Sky, trente ans plus tard.
SV.SkyCanon =
{
	Unlocked = {},
	Cleared = {},
	Bosses = {},
	Scenes = {},
	Restored = {}
}

--For dojo lessons
SV.Tutorial = 
{
	Lesson = "null",
	LastSpeech = "null",--remember which function for a dialogue set was spoken last.
	Progression = 0--a number value that corresponds to how many dialogues Ledian has said so far. Used to remember if ledian said anything already when the floor is reset so she doesn't repeat herself.
}

SV.ApricornGrove = 
{
	InDungeon = false--has character actually left the dungeon run yet? Used to determine what cutscenes to play inside the dungeon entrance/end
}

--Foret Lugubre : etat du relais de mi-donjon (chapitre 6).
--Ecrit par zone/gloomy_forest/init.lua en cas de defaite au-dela du checkpoint,
--et lu par ground/gloomy_forest_midpoint. Sans cette declaration, SV.GloomyForest
--vaut nil et la defaite provoque "attempt to index a nil value".
SV.ClovenRuins =
{
	BoulderCountdown = -1
}

SV.CrookedCavern =
{
	DiedPastCheckpoint = false
}

SV.GloomyForest =
{
	DiedPastCheckpoint = false--defaite dans les profondeurs ou contre Zeraora ?
}

SV.SearingTunnel = 
{
	LavaFlowDirection = "TopStraight",--TopStraight, BottomStraight, DiagonalDown, DiagonalUp, or None. Defaults to TopStraight as the boss fight starts with the lava spawned straight at the top.
	LavaCountdown = -1,--Used to determine how long until the lava flow changes?
	DiedPastCheckpoint = false--Used to flag whether you died in depths/crucible. Needed for cutscenes on wiping and waking up back in the checkpoint.
}

SV.Chapter7 = 
{
	-- Chapter 7
	EnteredRuins = false,
	LostRuins = false,
	LostDepths = false,
	DefeatedRuinsBoss = false,
	DiedToRuinsBoss = false,
	SawAnimaCoreCorruption = false,
	ShowedTitleCard = false,
	HeardGenesisTale = false,
	HadFirstDream = false,--Premier reve de Necrozma
	RuinsAddressGiven = false,--Adresse du matin Ch7 donnee
	MissionAccepted = false,--Mission Aegis Cave acceptee
	AlakazamScenePlayed = false,
	VisitedXatu = false,
	GreatReunionPlayed = false,
	FinishedIntimateTalk = false
}

SV.Chapter8 = 
{
	-- Chapter 8: Sanctuaire de Cristal — Diancie, Fragment de Cristal
	ShowedTitleCard = false,
	CrystalAddressGiven = false,
	MissionAccepted = false,
	EnteredSanctuary = false,
	ReachedCrystalRelay = false,
	LostCrystalGallery = false,
	ReachedDiancieChamber = false,
	LostGlyphHalls = false,
	DefeatedDiancie = false,
	DiedToDiancie = false,
	ObtainedCrystalFragment = false,
	SanctuaryMidpointState = 'FirstArrival',
	FinishedBedtimeCutscene = false,--veillee de fin de chapitre (guild_heros_room_ch_8)
	PlayedSanctuaryRelayIntro = false,
	--Relais du Sanctuaire : 'DeathArrival' si KO au-dela du checkpoint
	--(lu par ground/waterfall_pond_relay). SanctuaryMidReturn porte le
	--retour A L'AMIABLE (repli volontaire ou sauvegarde reprise sur place).
	SanctuaryMidState = nil,
	SanctuaryMidReturn = false,
	PlayedArrivalScene = false,--scene d'arrivee devant le donjon (ChapterScenes, ch8)
	PlayedVictoryScene = false,--scene d'apres-boss (ChapterAftermath, ch8)
	--Jalon de fin de donjon, ecrit par zone/waterfall_pond:95 et lu par
	--ReplayEnding + guild_heros_room. Il n'etait declare NULLE PART : une
	--partie neuve arrivait donc avec nil.
	CrystalSanctuaryComplete = false,
	--Heraut et spectre (mini-boss segment 3 : Strassie + Momartik).
	--Lus par ground/waterfall_pond_miniboss, ecrits par zone/waterfall_pond.
	CrystalMiniBossSeen = false,
	CrystalMiniBossDefeated = false,
	CrystalMiniBossLost = false,
	--Epreuve II du Grand Tournoi : Quizz de Kirlia (ground/metano_cafe).
	--nil = jamais passe ; sinon 'Perfect' | 'Pass' | 'Fail'.
	--nil est un etat valide et signifiant ici : il declenche la proposition
	--du quizz. Ne pas initialiser a false.
	QuizScore = nil
}

SV.Chapter9 = 
{
	-- Chapter 9: Marais de l'Oubli — Mega-Blastoise, Cercle du Suaire
	ShowedTitleCard = false,
	MarshAddressGiven = false,
	MissionAccepted = false,
	EnteredMarsh = false,
	ReachedMarshRelay = false,
	LostMarshBanks = false,
	ReachedMarshDepths = false,
	SawCercleDuSuaire = false,
	LostMarshDepths = false,
	DefeatedMegaBlastoise = false,
	DiedToMegaBlastoise = false,
	PurifiedMarshCore = false,
	FloatzelDisputeResolved = false,
	MarshMidpointState = 'FirstArrival',
	FinishedBedtimeCutscene = false,--veillee de fin de chapitre (guild_heros_room_ch_9)
	PlayedMarshRelayIntro = false,
	--Relais du Marais : 'DeathArrival' si KO au-dela du checkpoint.
	--MarshMidReturn porte le retour a l'amiable (template point median).
	MarshMidState = nil,
	MarshMidReturn = false,
	PlayedArrivalScene = false,--scene d'arrivee devant le donjon (ChapterScenes, ch9)
	PlayedVictoryScene = false,--scene d'apres-boss (ChapterAftermath, ch9)
	--Meme cas que ch8 : ecrit par zone/poisonous_forest:96, jamais declare.
	ForgottenMarshComplete = false,
	--Boue et venin (mini-boss segment 3 : Avaltout + Coatox).
	--Lus par ground/poisonous_forest_miniboss, ecrits par zone/poisonous_forest.
	MarshMiniBossSeen = false,
	MarshMiniBossDefeated = false,
	MarshMiniBossLost = false
}

SV.Visions =
{
	-- Visions du passe du heros (HeroVisions.lua). Le heros est le SEUL a
	-- entendre la Voix et le seul a voir ces fragments d'un autre temps :
	-- a chaque fois il est pris de nausee, et son partenaire ne voit que sa
	-- paleur. Seen[id] = true une fois la vision traversee.
	Seen = {},
	Count = 0
}

SV.SuaireArc =
{
	-- Arc 2 — « Ce que la brume emporte » : 5 quetes secondaires liees a
	-- l'intrigue globale (Cercle du Suaire + reves du heros + Escouade Fulgur).
	-- Progression : chaque acte pose Act<N>Done et debloque la quete suivante.
	Unlocked = false,          --pose au ch6+ : le tableau des missions propose l'acte I
	CurrentAct = 0,            --0 = pas commence, 1..5 = acte en cours
	Act1Done = false,          --Bosquet Voile : le premier eclat
	Act2Done = false,          --Grotte du Mystere : la marque des batisseurs
	Act3Done = false,          --Jardin Secret : le temoin
	Act4Done = false,          --Col de la Foudre : la course
	Act5Done = false,          --Antre de l'Enigme : ce que le Suaire protege
	ShardsRecovered = 0,       --eclats de Coeur repris au Suaire (0..5)
	SawSuaireFace = false,     --le joueur a vu un membre du Suaire de pres
	FulgurTruce = false,       --Fulgur accepte la treve (acte IV)
	DreamFragments = 0,        --fragments de memoire du gardien du sceau (0..5)
	HeardLitany = false        --la litanie du Suaire entendue en entier (acte V)
}

SV.Chapter10 = 
{
	-- Chapter 10: Pic Celeste — Lugia, Escouade Fulgur, vision Necrozma
	ShowedTitleCard = false,
	PeakAddressGiven = false,
	MissionAccepted = false,
	EnteredPeak = false,
	ReachedCloudRelay = false,
	LostFoothills = false,
	ReachedFulgurEncounter = false,
	LostCloudSea = false,
	OutranEscouadeFulgur = false,
	FulgurReachedSummitFirst = false,
	ReachedLugiaAltar = false,
	LostSummit = false,
	DefeatedLugia = false,
	DiedToLugia = false,
	SawNecrozmaVision = false,
	PeakMidpointState = 'FirstArrival',
	FinishedBedtimeCutscene = false,--veillee de fin de chapitre (guild_heros_room_ch_10)
	PlayedPeakRelayIntro = false,
	--Relais du Pic : 'DeathArrival' si KO au-dela du checkpoint.
	--PeakMidReturn porte le retour a l'amiable (template point median).
	PeakMidState = nil,
	PeakMidReturn = false,
	PlayedArrivalScene = false,--scene d'arrivee devant le donjon (ChapterScenes, ch10),
	--La Tour se devoile : plan plein ecran + travelling ascendant, joue au
	--ground d'entree juste avant de toucher l'entree du donjon
	--(ChapterScenes.PeakTowerReveal). Distinct de PlayedArrivalScene, qui
	--couvre l'arrivee sur le lieu : le duo peut ressortir et revenir sans
	--rejouer ni l'une ni l'autre.
	PlayedTowerReveal = false,
	PlayedVictoryScene = false,--scene d'apres-boss (ChapterAftermath, ch10)
	--Rejouabilite : jalon interne a un parcours rejoue. OutranEscouadeFulgur
	--reste vrai pour toujours et ne peut donc plus servir a savoir ou on en est
	--dans l'ascension. Remis a false a chaque entree dans le donjon.
	ReplayPastFulgur = false,
	--Meme cas que ch8/ch9 : ecrit par zone/celestial_peak:137, jamais declare.
	CelestialPeakComplete = false,
	--Acte 1 du climax : la longue discussion de Lugia apres sa defaite
	--(ChapterAftermath.PeakVictory). Distinct de PlayedVictoryScene, qui
	--marque l'acte 2 (meteorite + Rayquaza, autel_celeste). Les deux
	--partageaient le meme drapeau : l'acte 2 ne se jouait jamais.
	PlayedLugiaTalk = false
}

SV.FugitiveArc =
{
	Step = 0, -- étape courante de l'Arc Fugitif (0 = pas commencé)
	Started = false,
	Completed = false,
	NinetalesTestimony = false
}

SV.Chapter11 = 
{
	ShowedTitleCard = false,
	FinishedTreasureTownIntro = false,
	-- Migration de l'ancienne arrivée au Bourg : avant la réparation, la Mare
	-- posait FinishedTreasureTownIntro trop tôt et la scène d'arrivée était sautée.
	TreasureTownArrivalVersion = 0,
	--Arc de l'accusation : le duo quitte Metano avant de gagner l'autre
	--continent. Pose par AccusationArc.Scene9/10.
	FledGuild = false
}

-- Arc temporel principal. Le curseur global est la seule autorité de routage :
-- les Grounds et les scènes générées ne possèdent plus leurs transitions.
SV.FutureArc =
{
	Version = 3,
	Eligible = false,
	Offered = false,
	Active = false,
	Completed = false,
	PresentReturnPending = false,
	PresentReturnSeen = false,
	Cursor = 1,
	CurrentScene = "",
	PendingDungeon = "",
	DungeonState = "idle", -- idle / running / cleared / failed
	LastOutcome = "",
	ReturnGround = "bourg_comptoir",
	DungeonReturnGround = "",
	Attempts = {},
	LastError = "",
	-- Champs transitoires : permettent aux sauvegardes de l'ancien runner Step
	-- de reprendre depuis leur Ground sans réinitialiser tout le parcours.
	LegacyNeedsGround = false,
	LegacyStep = 1,
	LegacySpiritombDone = false
}

-- D55 appartient à l'épisode spécial de l'Équipe Charme, pas au parcours du
-- héros dans le futur. Ses trois fragments sont donc débloqués séparément.
SV.FutureSpecialEpisode =
{
	Version = 1,
	Unlocked = false,
	Active = false,
	CurrentSegment = 1,
	PendingSegment = 0,
	Segment1Done = false,
	Segment2Done = false,
	Segment3Done = false,
	Completed = false,
	ReturnPending = false,
	LastResult = "",
	Attempts = 0
}

--Chapitre 11 — « Ceux que l'on accuse ».
--Le Cercle du Suaire retourne la ville contre le heros en deformant la
--legende des voyageurs venus d'ailleurs. Etat de progression des dix
--scenes de l'arc (voir AccusationArc.lua).
SV.AccusationArc =
{
	Scene = 0,                --derniere scene jouee
	HeardAccusation = false,  --scene 3 : le discours sur la place
	PlumDefended = false,     --scene 4 : Plum refuse d'y croire
	ShopsClosed = false,      --scene 6 : les echoppes ferment
	SawProtest = false,       --scene 7 : la manifestation nocturne
	GuildCouncil = false,     --scene 8 : Penticus n'a plus les moyens
	PartnerChose = false      --scene 9 : le partenaire decide seul
}





--base game stuff
SV.test_grounds =
{
  SpokeToPooch = false,
  AcceptedPooch = false,
  Starter = { Species="pikachu", Form=0, Skin="normal", Gender=2 },
  Partner = { Species="eevee", Form=0, Skin="normal", Gender=1 },
  DemoComplete = false,
}

SV.missions =
{
  Missions = { },
  FinishedMissions = { },
}


SV.base_camp = 
{
  IntroComplete    = false,
  ExpositionComplete  = false,
  FirstTalkComplete  = false
}

SV.base_shop = {
	{ Index = "food_apple", Amount = 0, Price = 50},
	{ Index = "food_apple_big", Amount = 0, Price = 150},
	{ Index = "food_banana", Amount = 0, Price = 500},
	{ Index = "food_chestnut", Amount = 0, Price = 80},
	{ Index = "berry_leppa", Amount = 0, Price = 80}
}

SV.base_trades = {
	{ Item="xcl_family_bulbasaur_02", ReqItem={"",""}},
	{ Item="xcl_family_charmander_02", ReqItem={"",""}},
	{ Item="xcl_family_squirtle_02", ReqItem={"",""}}
}

SV.base_town = 
{
  Song    = "1 - Base Town.ogg"
}

SV.forest_camp = 
{
  ExpositionComplete  = false
}

SV.cliff_camp = 
{
  ExpositionComplete  = false,
  TeamRetreatIntro = false
}

SV.canyon_camp = 
{
  ExpositionComplete  = false
}

SV.rest_stop = 
{
  ExpositionComplete  = false
}

SV.final_stop = 
{
  ExpositionComplete  = false
}

SV.guildmaster_summit = 
{
  ExpositionComplete = false,
  BattleComplete = false,
  GameComplete = false
}

----------------------------------------------
-- AEGIS CAVE — portage d'Aegis Cave (Explorers of Sky)
----------------------------------------------
-- Structure fidele : 3 labyrinthes qui BOUCLENT tant que le mot du
-- secteur n'est pas epele avec les pierres de Zarbi, chacun suivi de la
-- chambre de son gardien, puis le Puits (5 etages, sans enigme) et
-- Regigigas.
--
-- MotGlace / MotRoche / MotAcier : le mot du secteur est-il complet ?
--   Tant qu'il est faux, zone/cloven_ruins renvoie l'equipe au camp
--   d'entree (comportement d'origine du donjon).
-- Pierres : inventaire des lettres deja obtenues, par secteur. Une
--   lettre n'est comptee qu'une fois, meme si plusieurs Zarbi la lachent.
-- BoucleSecteur : dernier secteur reboucle, lu par le camp pour que le
--   partenaire commente l'echec plutot que de rester muet.
SV.Ruines =
{
  MotGlace = false,
  MotRoche = false,
  MotAcier = false,

  PierresGlace = {},
  PierresRoche = {},
  PierresAcier = {},

  BoucleSecteur   = -1,
  TabletteVue     = false,

  VuRegice        = false,
  VuRegirock      = false,
  VuRegisteel     = false,

  VaincuRegice    = false,
  VaincuRegirock  = false,
  VaincuRegisteel = false,
  PerduRegice     = false,
  PerduRegirock   = false,
  PerduRegisteel  = false
}


----------------------------------------------
print('Script variables default values loaded! [build 2026-08-04-K]')

-----------------------------------------------
-- New Era & Future Arc Defaults
-----------------------------------------------
SV.NewEra = 
{
	DUNGEON_RESULT = 0,
	GROUND_START_MODE = 0
}

SV.Scenario = 
{
	Main = 0,
	Side = 0,
	CompulsorySavePoint = 0
}

SV.LulubyTown = 
{
	Period = 'morning',
	Visited = false
}

SV.TownLife = 
{
	SeenSocialDay = 0
}

SV.TreasureTown = 
{
	SpindaCafe = 
	{
		FirstVisit = false,
		RumorState = 0
	}
}

SV.WorldState = 
{
	Weather = { Current = 'normal' }
}

SV.RuntimeGroundAudit = 
{
	Active = false
}
