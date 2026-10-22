--[[
    Example Service
    
    This is an example to demonstrate how to use the BaseService class to implement a game service.
    
    **NOTE:** After declaring you service, you have to include your package inside the main.lua file!
]]--
require 'origin.common'
require 'origin.services.baseservice'
require 'halcyon.mission_gen'
require 'origin.recruit_list'

--Declare class DebugTools
local DebugTools = Class('DebugTools', BaseService)

--[[---------------------------------------------------------------
    DebugTools:initialize()
      DebugTools class constructor
---------------------------------------------------------------]]
function DebugTools:initialize()
  BaseService.initialize(self)
  PrintInfo('DebugTools:initialize()')
end

--[[---------------------------------------------------------------
    DebugTools:__gc()
      DebugTools class gc method
      Essentially called when the garbage collector collects the service.
  ---------------------------------------------------------------]]
--function DebugTools:__gc()
--  PrintInfo('*****************DebugTools:__gc()')
--end

--[[---------------------------------------------------------------
    DebugTools:OnInit()
      Called on initialization of the script engine by the game!
---------------------------------------------------------------]]
function DebugTools:OnInit()
  assert(self, 'DebugTools:OnInit() : self is null!')
	PrintInfo("\n<!> DebugTools: Init..")
end

--[[---------------------------------------------------------------
    DebugTools:OnDeinit()
      Called on de-initialization of the script engine by the game!
---------------------------------------------------------------]]
function DebugTools:OnDeinit()
  assert(self, 'DebugTools:OnDeinit() : self is null!')
  PrintInfo("\n<!> DebugTools: Deinit..")
end


--[[---------------------------------------------------------------
    DebugTools:OnNewGame()
      When a debug save file is loaded this is called!
---------------------------------------------------------------]]
function DebugTools:OnNewGame()
  assert(self, 'DebugTools:OnNewGame() : self is null!')
  
  if _DATA.Save.ActiveTeam.Players.Count > 0 then
     local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("HeroInteract")
    _DATA.Save.ActiveTeam.Players[0].ActionEvents:Add(talk_evt)
	-- Register the exact MonsterID (species, form, skin, gender). The string
	-- overload only registers form 0 and emits a PMDO 0.8.12 warning.
	_DATA.Save:RegisterMonster(_DATA.Save.ActiveTeam.Players[0].BaseForm)
	
	_DATA.Save.ActiveTeam:SetRank("normal")
	if not GAME:InRogueMode() then
      _DATA.Save.ActiveTeam.Bank = 1000
	end
  else	
		PrintInfo("\n<!> ExampleSvc: Preparing debug save file")
	  _DATA.Save.ActiveTeam:SetRank("none")
	  _DATA.Save.ActiveTeam.Name = "Valiant"
	  _DATA.Save.ActiveTeam.Money = 1000
	  _DATA.Save.ActiveTeam.Bank = 999999
	  _DATA.Save.NoSwitching = true--switching is not allowed

	  
	  local mon_id = RogueEssence.Dungeon.MonsterID("turtwig", 0, "normal", Gender.Male)
	  local p = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 20, "", 0)
	  local tbl = LTBL(p)
	  tbl.Importance = 'Hero'
	  p.IsFounder = true
	  p.IsPartner = true
	  --p.Nickname = 'Palika'
	  p.Nickname = 'BIG_AF_NAME'
	  _DATA.Save.ActiveTeam.Players:Add(p)
	  
	  mon_id = RogueEssence.Dungeon.MonsterID("piplup", 0, "normal", Gender.Male)
	  p = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 20, "", 0)
	  tbl = LTBL(p)
	  tbl.Importance = 'Partner'
	  p.IsFounder = true
	  p.IsPartner = true
	  --p.Nickname = 'Genshi'
	  p.Nickname = 'LONG_NAME!!'
	  _DATA.Save.ActiveTeam.Players:Add(p)
	  
	  _DATA.Save.ActiveTeam:SetRank("bronze")

	  talk_evt = RogueEssence.Dungeon.BattleScriptEvent("HeroInteract")
	  _DATA.Save.ActiveTeam.Players[0].ActionEvents:Add(talk_evt)
	  talk_evt = RogueEssence.Dungeon.BattleScriptEvent("PartnerInteract")
	  _DATA.Save.ActiveTeam.Players[1].ActionEvents:Add(talk_evt)
	  
	  mon_id = RogueEssence.Dungeon.MonsterID("growlithe", 0, "normal", Gender.Male)
	  _DATA.Save.ActiveTeam.Players:Add(_DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 100, "", 0))
	  _DATA.Save.ActiveTeam.Players[2].Nickname = 'Hyko'
	  
	  --This is a scrapped feature where you would have started with some bonuses to your stats.
		--_DATA.Save.ActiveTeam.Players[0].MaxHPBonus = 3
		--_DATA.Save.ActiveTeam.Players[0].AtkBonus = 1
		--_DATA.Save.ActiveTeam.Players[0].DefBonus = 1
		--_DATA.Save.ActiveTeam.Players[0].MAtkBonus = 1
		--_DATA.Save.ActiveTeam.Players[0].MDefBonus = 1
		--_DATA.Save.ActiveTeam.Players[0].SpeedBonus = 1

		--_DATA.Save.ActiveTeam.Players[1].MaxHPBonus = 3
		--_DATA.Save.ActiveTeam.Players[1].AtkBonus = 1
		--_DATA.Save.ActiveTeam.Players[1].DefBonus = 1
		--_DATA.Save.ActiveTeam.Players[1].MAtkBonus = 1
		--_DATA.Save.ActiveTeam.Players[1].MDefBonus = 1
		--_DATA.Save.ActiveTeam.Players[1].SpeedBonus = 1
		
	  --audino 
	  mon_id = RogueEssence.Dungeon.MonsterID("zigzagoon", 0, "normal", Gender.Female)
	  _DATA.Save.ActiveTeam.Players:Add(_DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id,100, "", 0))
	  _DATA.Save.ActiveTeam.Players[3].Nickname = 'Almotz'
	 
	    _DATA.Save.ActiveTeam:SetRank("bronze")
	    _DATA.Save:UpdateTeamProfile(true)
		SV.ChapterProgression.UnlockedAssembly = true
		SV.ChapterProgression.Chapter = 5
		
		--GAME:GivePlayerItem('seed_reviver')	  
		--GAME:GivePlayerItem('seed_reviver')	  
		--GAME:GivePlayerItem('seed_reviver')	  
		
		
        -- MOD DEV : ne jamais déverrouiller aveuglément toutes les entrées
        -- de l'index Zone. `master_zone` est un hub de Grounds, et les zones
        -- CountedFloors=0 ne sont pas des destinations de donjon valides.
        -- Les ajouter à la liste de destination provoque un crash lorsque le
        -- menu essaie de construire leur résumé.
        local zone_index = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]
        local dungeon_keys = zone_index:GetOrderedKeys(false)
        for ii = 0, dungeon_keys.Count - 1, 1 do
          local zone_id = dungeon_keys[ii]
          local ok, err = pcall(function()
            local summary = zone_index:Get(zone_id)
            if zone_id ~= 'master_zone' and summary ~= nil
               and summary.Released == true
               and summary.CountedFloors ~= nil and summary.CountedFloors > 0 then
              GAME:UnlockDungeon(zone_id)
            else
              PrintInfo('[DevUnlock] exclu: ' .. tostring(zone_id))
            end
          end)
          if not ok then
            -- Une zone mal formée ne doit pas empêcher la création de toute
            -- la sauvegarde Dev. Elle reste verrouillée et l'erreur est loguée.
            PrintInfo('[DevUnlock] échec ' .. tostring(zone_id) .. ': ' .. tostring(err))
          end
        end
	  
	  SV.base_camp.ExpositionComplete = true
	  SV.base_camp.IntroComplete = true
	end 
end




--Reset most variables to their default if they don't exist
--This needs to be upkept whenever I add new variables to the game.
--Yanderedev ftw
function DebugTools:OnUpgrade()
  assert(self, 'DebugTools:OnUpgrade() : self is null!')
  
  PrintInfo("=>> Loading version")

--daily flags
 if SV.DailyFlags.RedMerchantItem == nil then SV.DailyFlags.RedMerchantItem = "" end
 if SV.DailyFlags.RedMerchantBought == nil then SV.DailyFlags.RedMerchantBought = false end
 if SV.DailyFlags.GreenMerchantItem == nil then SV.DailyFlags.GreenMerchantItem = "" end
 if SV.DailyFlags.GreenMerchantBought == nil then SV.DailyFlags.GreenMerchantBought = false end
 if SV.DailyFlags.GreenKecleonRefreshedStock == nil then SV.DailyFlags.GreenKecleonRefreshedStock = false end
 if SV.DailyFlags.GreenKecleonStock == nil then SV.DailyFlags.GreenKecleonStock = {} end
 if SV.DailyFlags.PurpleKecleonRefreshedStock == nil then SV.DailyFlags.PurpleKecleonRefreshedStock = false end
 if SV.DailyFlags.PurpleKecleonStock == nil then SV.DailyFlags.PurpleKecleonStock = {} end

--temporary flags
 if SV.TemporaryFlags.OldDirection == nil then SV.TemporaryFlags.OldDirection = Direction.None end
 if SV.TemporaryFlags.Dinnertime == nil then SV.TemporaryFlags.Dinnertime = false end 
 if SV.TemporaryFlags.Bedtime == nil then SV.TemporaryFlags.Bedtime = false end
 if SV.TemporaryFlags.MorningWakeup == nil then SV.TemporaryFlags.MorningWakeup = false end
 if SV.TemporaryFlags.MorningAddress == nil then SV.TemporaryFlags.MorningAddress = false end 
 if SV.TemporaryFlags.JustWokeUp == nil then SV.TemporaryFlags.JustWokeUp = false end 
 if SV.TemporaryFlags.LastDungeonEntered == nil then SV.TemporaryFlags.LastDungeonEntered = '' end
 if SV.TemporaryFlags.MissionCompleted == nil then SV.TemporaryFlags.MissionCompleted = false end
 if SV.TemporaryFlags.PostJobsGround == nil then SV.TemporaryFlags.PostJobsGround = '' end
 if SV.TemporaryFlags.AudinoSummonCount == nil then SV.TemporaryFlags.AudinoSummonCount = 0 end
 
 
 if SV.adventure == nil then SV.adventure = {} end
 if SV.adventure.Thief == nil then SV.adventure.Thief = false end
  

 if SV.metano_cafe.CafeSpecial == nil then SV.metano_cafe.CafeSpecial = "" end
 if SV.metano_cafe.BoughtSpecial == nil then SV.metano_cafe.BoughtSpecial = false end
 if SV.metano_cafe.FermentedItem == nil then SV.metano_cafe.FermentedItem = "" end
 if SV.metano_cafe.ItemFinishedFermenting == nil then SV.metano_cafe.ItemFinishedFermenting = false end
 if SV.metano_cafe.NewDrinkUnlocked == nil then SV.metano_cafe.NewDrinkUnlocked = false end
  
  
 if SV.Dojo.LessonCompletedGeneric == nil then SV.Dojo.LessonCompletedGeneric = false end
 if SV.Dojo.TrainingCompletedGeneric == nil then SV.Dojo.TrainingCompletedGeneric = false end
 if SV.Dojo.TrialCompletedGeneric == nil then SV.Dojo.TrialCompletedGeneric = false end
 if SV.Dojo.LessonFailedGeneric == nil then SV.Dojo.LessonFailedGeneric = false end
 if SV.Dojo.TrainingFailedGeneric == nil then SV.Dojo.TrainingFailedGeneric = false end
 if SV.Dojo.TrialFailedGeneric == nil then SV.Dojo.TrialFailedGeneric = false end
 if SV.Dojo.NewMazeUnlocked == nil then SV.Dojo.NewMazeUnlocked = false end
 if SV.Dojo.NewLessonUnlocked == nil then SV.Dojo.NewLessonUnlocked = false end
 if SV.Dojo.NewTrialUnlocked == nil then SV.Dojo.NewTrialUnlocked = false end
 if SV.Dojo.SkippedTutorialNotifiedTeamMode == nil then SV.Dojo.SkippedTutorialNotifiedTeamMode = false end
 if SV.Dojo.LastZone == nil then SV.Dojo.LastZone = "master_zone" end
  
  
 if SV.ChapterProgression.DaysPassed == nil then SV.ChapterProgression.DaysPassed = 0 end 
 if SV.ChapterProgression.DaysToReach == nil then SV.ChapterProgression.DaysToReach = -1 end 
 if SV.ChapterProgression.Chapter == nil then SV.ChapterProgression.Chapter = 1 end 
 if SV.ChapterProgression.CurrentStoryDungeon == nil then SV.ChapterProgression.CurrentStoryDungeon = "" end 
 if SV.ChapterProgression.UnlockedAssembly == nil then SV.ChapterProgression.UnlockedAssembly = false end 
 
 --A flag that should have been included when chapter 2 was made, for flagging if you viewed the first wakeup scene with audino.
 if SV.Chapter2.FinishedFirstWakeup == nil then SV.Chapter2.FinishedFirstWakeup = false end 
 
 --if this is a pre-chapter 3 save, need to initialize chapter 3 in the first place.
 if SV.Chapter3 == nil then SV.Chapter3 = {} end
 
 if SV.Chapter3.ShowedTitleCard == nil then SV.Chapter3.ShowedTitleCard = false end
 if SV.Chapter3.FinishedOutlawIntro == nil then SV.Chapter3.FinishedOutlawIntro = false end
 if SV.Chapter3.MetTeamStyle == nil then SV.Chapter3.MetTeamStyle = false end
 if SV.Chapter3.FinishedCafeCutscene == nil then SV.Chapter3.FinishedCafeCutscene = false end
 if SV.Chapter3.EnteredCavern == nil then SV.Chapter3.EnteredCavern = false end
 if SV.Chapter3.FailedCavern == nil then SV.Chapter3.FailedCavern = false end
 if SV.Chapter3.EncounteredBoss == nil then SV.Chapter3.EncounteredBoss = false end
 if SV.Chapter3.LostToBoss == nil then SV.Chapter3.LostToBoss = false end
 if SV.Chapter3.EscapedBoss == nil then SV.Chapter3.EscapedBoss = false end
 if SV.Chapter3.DefeatedBoss == nil then SV.Chapter3.DefeatedBoss = false end
 if SV.Chapter3.RootSceneTransition == nil then SV.Chapter3.RootSceneTransition = false end
 if SV.Chapter3.FinishedRootScene == nil then SV.Chapter3.FinishedRootScene = false end
 if SV.Chapter3.FinishedMerchantIntro == nil then SV.Chapter3.FinishedMerchantIntro = false end
-- if SV.Chapter3.DemoThankYou == nil then SV.Chapter3.DemoThankYou = false end
 if SV.Chapter3.TropiusGaveWand == nil then SV.Chapter3.TropiusGaveWand = false end
 if SV.Chapter3.BreloomGirafarigConvo == nil then SV.Chapter3.BreloomGirafarigConvo = false end
 if SV.Chapter3.PostBossSpokeToCranidos == nil then SV.Chapter3.PostBossSpokeToCranidos = false end
 -- Crooked Cavern mid-dungeon checkpoint (mirrors Chapter5.TunnelMidpointState)
 if SV.Chapter3.CrookedPlayedMidpointIntro == nil then SV.Chapter3.CrookedPlayedMidpointIntro = false end
 if SV.Chapter3.CrookedMidpointState == nil then SV.Chapter3.CrookedMidpointState = 'FirstArrival' end
 
 
 --for pre-chapter 4 saves
 if SV.Chapter4 == nil then SV.Chapter4 = {} end

 if SV.Chapter4.ShowedTitleCard == nil then SV.Chapter4.ShowedTitleCard = false end
 if SV.Chapter4.FinishedFirstAddress == nil then SV.Chapter4.FinishedFirstAddress = false end
 if SV.Chapter4.FinishedAssemblyIntro == nil then SV.Chapter4.FinishedAssemblyIntro = false end
 if SV.Chapter4.FinishedSignpostCutscene == nil then SV.Chapter4.FinishedSignpostCutscene = false end
 if SV.Chapter4.EnteredGrove == nil then SV.Chapter4.EnteredGrove = false end
 if SV.Chapter4.BacktrackedOutGroveYet == nil then SV.Chapter4.BacktrackedOutGroveYet = false end
 if SV.Chapter4.ReachedGlade == nil then SV.Chapter4.ReachedGlade = false end
 if SV.Chapter4.FinishedGrove == nil then SV.Chapter4.FinishedGrove = false end
 if SV.Chapter4.FinishedFirstAddress == nil then SV.Chapter4.FinishedFirstAddress = false end
 if SV.Chapter4.FinishedBedtimeCutscene == nil then SV.Chapter4.FinishedBedtimeCutscene = false end
 if SV.Chapter4.TropiusGaveAdvice == nil then SV.Chapter4.TropiusGaveAdvice = false end
 if SV.Chapter4.SpokeToRelicanthDayOne == nil then SV.Chapter4.SpokeToRelicanthDayOne = false end
 if SV.Chapter4.HeardRelicanthStory == nil then SV.Chapter4.HeardRelicanthStory = false end
 if SV.Chapter4.MedichamMachampArgument == nil then SV.Chapter4.MedichamMachampArgument = false end
 if SV.Chapter4.CranidosBlush == nil then SV.Chapter4.CranidosBlush = false end
 if SV.Chapter4.WoopersMedititeConvo == nil then SV.Chapter4.WoopersMedititeConvo = false end
 if SV.Chapter4.DemoThankYou == nil then SV.Chapter4.DemoThankYou = false end

 if SV.ApricornGrove == nil then SV.ApricornGrove = {} end
 
 if SV.ApricornGrove.InDungeon == nil then SV.ApricornGrove.InDungeon = false end
 
 
 --for pre chapter 5 saves
 if SV.Chapter5 == nil then SV.Chapter5 = {} end
 
 if SV.Chapter5.ShowedTitleCard == nil then SV.Chapter5.ShowedTitleCard = false end
 if SV.Chapter5.FinishedExpeditionAddress == nil then SV.Chapter5.FinishedExpeditionAddress = false end
 if SV.Chapter5.ReadyForExpedition == nil then SV.Chapter5.ReadyForExpedition = false end
 if SV.Chapter5.FinishedSteppeIntro == nil then SV.Chapter5.FinishedSteppeIntro = false end
 if SV.Chapter5.EnteredSteppe == nil then SV.Chapter5.EnteredSteppe = false end
 if SV.Chapter5.LostSteppe == nil then SV.Chapter5.LostSteppe = false end
 if SV.Chapter5.EscapedSteppe == nil then SV.Chapter5.EscapedSteppe = false end
 if SV.Chapter5.DiedSteppe == nil then SV.Chapter5.DiedSteppe = false end
 if SV.Chapter5.SpokeToTropiusSteppe == nil then SV.Chapter5.SpokeToTropiusSteppe = false end
 if SV.Chapter5.FinishedTunnelIntro == nil then SV.Chapter5.FinishedTunnelIntro = false end
 if SV.Chapter5.EnteredTunnel == nil then SV.Chapter5.EnteredTunnel = false end
 if SV.Chapter5.LostTunnel == nil then SV.Chapter5.LostTunnel = false end
 if SV.Chapter5.TunnelLastExitReason == nil then SV.Chapter5.TunnelLastExitReason = '' end
 if SV.Chapter5.PlayTempTunnelScene == nil then SV.Chapter5.PlayTempTunnelScene = false end
 if SV.Chapter5.PlayedMidpointIntro == nil then SV.Chapter5.PlayedMidpointIntro = false end
 if SV.Chapter5.TunnelMidpointState == nil then SV.Chapter5.TunnelMidpointState = 'FirstArrival' end
 if SV.Chapter5.EncounteredBoss == nil then SV.Chapter5.EncounteredBoss = false end
 if SV.Chapter5.DefeatedBoss == nil then SV.Chapter5.DefeatedBoss = false end
 if SV.Chapter5.DiedToBoss == nil then SV.Chapter5.DiedToBoss = false end
 if SV.Chapter5.JustDiedToBoss == nil then SV.Chapter5.JustDiedToBoss = false end
 if SV.Chapter5.SpokeToNoctowlTunnel == nil then SV.Chapter5.SpokeToNoctowlTunnel = false end
 if SV.Chapter5.FinishedMountWindsweptIntro == nil then SV.Chapter5.FinishedMountWindsweptIntro = false end
 if SV.Chapter5.EnteredMountain == nil then SV.Chapter5.EnteredMountain = false end
 if SV.Chapter5.LostMountain == nil then SV.Chapter5.LostMountain = false end
 if SV.Chapter5.DiedToWind == nil then SV.Chapter5.DiedToWind = false end
 if SV.Chapter5.EscapedMountain == nil then SV.Chapter5.EscapedMountain = false end
 if SV.Chapter5.DiedMountain == nil then SV.Chapter5.DiedMountain = false end
 if SV.Chapter5.NeedGiveSupplies == nil then SV.Chapter5.NeedGiveSupplies = false end
 
 --Aegis Cave (climax du ch5) : flags du campement devant l'entree.
 --Les memes valeurs que dans scriptvars.lua — indispensables pour les
 --sauvegardes existantes qui n'ont pas le bloc Ruins* dans SV.Chapter5.
 if SV.Chapter5.RuinsCampPending == nil then SV.Chapter5.RuinsCampPending = false end
 if SV.Chapter5.RuinsCampDone == nil then SV.Chapter5.RuinsCampDone = false end
 if SV.Chapter5.RuinsCampNightDone == nil then SV.Chapter5.RuinsCampNightDone = false end
 if SV.Chapter5.RuinsDreamSeen == nil then SV.Chapter5.RuinsDreamSeen = false end
 if SV.Chapter5.RuinsEntered == nil then SV.Chapter5.RuinsEntered = false end
 if SV.Chapter5.PlayTempRuinsScene == nil then SV.Chapter5.PlayTempRuinsScene = false end
 if SV.Chapter5.RuinsLastExitReason == nil then SV.Chapter5.RuinsLastExitReason = '' end
 if SV.Chapter5.RuinsExpeditionDone == nil then SV.Chapter5.RuinsExpeditionDone = false end

 --Sinister Woods D04P01/D04P02 : séparation approche / clairière pour les sauvegardes existantes.
 if SV.Chapter6 == nil then SV.Chapter6 = {} end
 if SV.Chapter6.SinisterApproachSeen == nil then
   SV.Chapter6.SinisterApproachSeen = (SV.Chapter6.FinishedGloomyForestIntro == true)
 end
 
 

 --for terrakion's dungeon boulder variable timer
 if SV.ClovenRuins == nil then SV.ClovenRuins = {} end
 
 if SV.ClovenRuins.BoulderCountdown == nil then SV.ClovenRuins.BoulderCountdown = -1 end
 
 --For Searing Tunnel's boss fight
 if SV.SearingTunnel == nil then SV.SearingTunnel = {} end
 
 if SV.SearingTunnel.DiedPastCheckpoint == nil then SV.SearingTunnel.DiedPastCheckpoint = false end
 if SV.SearingTunnel.LavaFlowDirection == nil then SV.SearingTunnel.LavaFlowDirection = 'TopStraight' end
 if SV.SearingTunnel.LavaCountdown == nil then SV.SearingTunnel.LavaCountdown = -1 end
 
 --For Crooked Cavern's mid-dungeon checkpoint (mirrors SearingTunnel)
 if SV.CrookedCavern == nil then SV.CrookedCavern = {} end
 
 if SV.CrookedCavern.DiedPastCheckpoint == nil then SV.CrookedCavern.DiedPastCheckpoint = false end
 
 --For Gloomy Forest's mid-dungeon checkpoint (mirrors SearingTunnel/CrookedCavern)
 if SV.GloomyForest == nil then SV.GloomyForest = {} end
 
 if SV.GloomyForest.DiedPastCheckpoint == nil then SV.GloomyForest.DiedPastCheckpoint = false end
 
 --Main story completion flag (end-game unlocks: Mega Stones shop, etc.)
 if SV.ChapterProgression.StoryCompleted == nil then SV.ChapterProgression.StoryCompleted = false end
 
 --Vague 1 multi-sources : deblocage retroactif des secondaires ch1-4 pour les vieilles sauvegardes
 if SV.ChapterProgression.Chapter >= 1 and not GAME:DungeonUnlocked("petit_tunnel") then
	GAME:UnlockDungeon("petit_tunnel")
	GAME:UnlockDungeon("bosquet_voile")
	GAME:UnlockDungeon("grotte_mystere")
	GAME:UnlockDungeon("vallee_fertile")
 end
 if SV.ChapterProgression.Chapter >= 3 and not GAME:DungeonUnlocked("antre_enigme") then
	GAME:UnlockDungeon("antre_enigme")
	GAME:UnlockDungeon("carriere_cuivre")
 end
 if SV.ChapterProgression.Chapter >= 4 and not GAME:DungeonUnlocked("grotte_echoue") then
	GAME:UnlockDungeon("grotte_echoue")
 end
 --ZONE DE TEST : arene Tornadus (validation en jeu, 2026-08-05) — a retirer avant release
 --Add-on Reseau des Anciens Chemins : deblocage a partir du Livre II (ch11+) ou fin d'histoire
 if (SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 11) or SV.ChapterProgression.StoryCompleted == true then
 end
 --Rattrapage des sauvegardes bloquees en fin de chapitre 6.
 --La progression s'arretait la : aucun declencheur ne portait Chapter de 6 a 7,
 --et cloven_ruins n'etait UnlockDungeon nulle part. Une partie ayant deja vu la
 --scene de retour du chapitre 6 resterait donc coincee meme apres cette mise a
 --jour, car DaysToReach n'avait jamais ete arme pour le palier suivant.
 --On l'arme ici (le declencheur de guild_heros_room fera le reste a la
 --prochaine nuit). Idempotent : ne s'applique qu'une fois, tant qu'on est au
 --chapitre 6 avec la mission bouclee.
 if SV.ChapterProgression.Chapter == 6 and SV.Chapter6 ~= nil
    and SV.Chapter6.PostMissionScenePlayed == true
    and (SV.ChapterProgression.DaysToReach == nil or SV.ChapterProgression.DaysToReach < 0) then
	SV.ChapterProgression.DaysToReach = SV.ChapterProgression.DaysPassed
 end

 --Rejouabilite des donjons d'histoire : un donjon dont la conclusion a ete vue
 --reste joignable depuis le comptoir de Metano, comme dans les PMD officiels.
 --Les 7 donjons ch5-ch10 n'etaient jamais passes a UnlockDungeon : ils
 --disparaissaient de la liste des destinations une fois le chapitre fini.
 --Rattrapage retroactif ici pour les sauvegardes en cours ; le comptoir
 --(metano_town.East_Exit_Touch) refait le meme balayage a chaque ouverture.
 require 'halcyon.ReplayEnding'
 ReplayEnding.SyncUnlocks()

 --Scenes d'apres-boss des chapitres 8, 9 et 10 (ChapterAftermath.lua).
 --Marquees comme vues si le boss est deja vaincu : une partie qui a passe ces
 --combats avant cette mise a jour ne rejouera pas la scene hors contexte.
 if SV.Chapter8 ~= nil and SV.Chapter8.PlayedVictoryScene == nil then
	SV.Chapter8.PlayedVictoryScene = (SV.Chapter8.DefeatedDiancie == true)
 end
 if SV.Chapter9 ~= nil and SV.Chapter9.PlayedVictoryScene == nil then
	SV.Chapter9.PlayedVictoryScene = (SV.Chapter9.DefeatedMegaBlastoise == true)
 end
 if SV.Chapter10 ~= nil and SV.Chapter10.PlayedVictoryScene == nil then
	SV.Chapter10.PlayedVictoryScene = (SV.Chapter10.DefeatedLugia == true)
 end

 --Scenes d'arrivee des chapitres 8, 9 et 10 (ChapterScenes.lua).
 if SV.Chapter8 ~= nil and SV.Chapter8.PlayedArrivalScene == nil then
	SV.Chapter8.PlayedArrivalScene = (SV.Chapter8.EnteredSanctuary == true)
 end
 if SV.Chapter9 ~= nil and SV.Chapter9.PlayedArrivalScene == nil then
	SV.Chapter9.PlayedArrivalScene = (SV.Chapter9.EnteredMarsh == true)
 end
 if SV.Chapter10 ~= nil and SV.Chapter10.PlayedArrivalScene == nil then
	SV.Chapter10.PlayedArrivalScene = (SV.Chapter10.EnteredPeak == true)
 end

 --Visions du passe du heros : etat cree retroactivement pour les parties
 --en cours. Aucune vision n'est marquee comme vue, donc une sauvegarde
 --existante les decouvrira normalement a partir de son chapitre courant.
 if SV.Visions == nil then SV.Visions = {} end
 if SV.Visions.Seen == nil then SV.Visions.Seen = {} end
 if SV.Visions.Count == nil then SV.Visions.Count = 0 end

 --Arc 2 « Ce que la brume emporte » : 5 quetes secondaires liees a l'intrigue.
 --Disponible des le ch6 (apres l'expedition), retroactif pour les parties en cours.
 if SV.SuaireArc == nil then SV.SuaireArc = {} end
 if SV.SuaireArc.CurrentAct == nil then SV.SuaireArc.CurrentAct = 0 end
 if SV.SuaireArc.ShardsRecovered == nil then SV.SuaireArc.ShardsRecovered = 0 end
 if SV.SuaireArc.DreamFragments == nil then SV.SuaireArc.DreamFragments = 0 end

 --Chapitre 11 « Ceux que l'on accuse » : rattrapage pour les parties en
 --cours, sinon les scenes de l'arc lisent des champs nil.
 --Climax ch10 scinde en deux actes (correctif 2026-08-02) : sans ce
 --rattrapage, une partie en cours arrive sur autel_celeste avec
 --PlayedLugiaTalk a nil et l'acte 2 ne se declenche jamais.
 if SV.Chapter10 ~= nil and SV.Chapter10.PlayedLugiaTalk == nil then
   SV.Chapter10.PlayedLugiaTalk = (SV.Chapter10.PlayedVictoryScene == true)
 end

 if SV.AccusationArc == nil then SV.AccusationArc = {} end
 if SV.AccusationArc.Scene == nil then SV.AccusationArc.Scene = 0 end
 if SV.AccusationArc.HeardAccusation == nil then SV.AccusationArc.HeardAccusation = false end
 if SV.AccusationArc.PlumDefended == nil then SV.AccusationArc.PlumDefended = false end
 if SV.AccusationArc.ShopsClosed == nil then SV.AccusationArc.ShopsClosed = false end
 if SV.AccusationArc.SawProtest == nil then SV.AccusationArc.SawProtest = false end
 if SV.AccusationArc.GuildCouncil == nil then SV.AccusationArc.GuildCouncil = false end
 if SV.AccusationArc.PartnerChose == nil then SV.AccusationArc.PartnerChose = false end
 if SV.Chapter11 ~= nil and SV.Chapter11.FledGuild == nil then SV.Chapter11.FledGuild = false end
 if (SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 6)
    or SV.ChapterProgression.StoryCompleted == true then
	if not SV.SuaireArc.Unlocked then
		SV.SuaireArc.Unlocked = true
		if SV.SuaireArc.CurrentAct == 0 then SV.SuaireArc.CurrentAct = 1 end
	end
	--les 5 donjons de l'arc doivent etre accessibles des que l'arc s'ouvre
	if not GAME:DungeonUnlocked("bosquet_voile") then GAME:UnlockDungeon("bosquet_voile") end
	if not GAME:DungeonUnlocked("grotte_mystere") then GAME:UnlockDungeon("grotte_mystere") end
	if not GAME:DungeonUnlocked("jardin_secret") then GAME:UnlockDungeon("jardin_secret") end
	if not GAME:DungeonUnlocked("col_foudre") then GAME:UnlockDungeon("col_foudre") end
	if not GAME:DungeonUnlocked("antre_enigme") then GAME:UnlockDungeon("antre_enigme") end
 end
 --Add-on « Reseau du Ciel » (Explorateurs du Ciel) — 3 paliers.
 if (SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 11) or SV.ChapterProgression.StoryCompleted == true then
 end
 if (SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 20) or SV.ChapterProgression.StoryCompleted == true then
 end
 if SV.ChapterProgression.StoryCompleted == true then
 end
 --Add-on v2 : donjons post-game du jeu d'origine (Relique des Glyphes, Tour de
 --la Joie Premiere, Mer du Lointain, Foret de l'Epure, Ile des Vestiges, Mer des
 --Merveilles, Detroit des Chimeres) : reserves a l'apres-histoire.
 if SV.ChapterProgression.StoryCompleted == true then
 end
 --Vague 8 : etats de checkpoint (reveil au relais)
 --Audit IsGameOver : flags persistants de mini-boss pour les parties existantes.
 --Retroactif : si le joueur a deja vu/vaincu le mini-boss (Seen pose puis
 --SecondPreBossScene disponible), on considere Cleared si le chapitre est passe.
 if SV.Chapter5 ~= nil then
	if SV.Chapter5.SteppeMiniBossCleared == nil then
		SV.Chapter5.SteppeMiniBossCleared = (SV.ChapterProgression.Chapter > 5) or (SV.Chapter5.SteppeMiniBossSeen == true and SV.Chapter5.SteppeGuardianDefeated == true)
	end
	if SV.Chapter5.TunnelMiniBossCleared == nil then
		SV.Chapter5.TunnelMiniBossCleared = (SV.ChapterProgression.Chapter > 5) or (SV.Chapter5.TunnelMiniBossSeen == true and SV.Chapter5.DefeatedBoss == true)
	end
	if SV.Chapter5.MountMiniBossCleared == nil then
		SV.Chapter5.MountMiniBossCleared = (SV.ChapterProgression.Chapter > 5) or (SV.Chapter5.MountMiniBossSeen == true and SV.Chapter5.MountGuardianDefeated == true)
	end
 end
 --ATTENTION (2026-07-30) : la zone searing_tunnel a gagne un segment (arene du
 --clan de lave inseree en seg 2). La numerotation a donc glisse :
 --   avant : 0=etages 1=profondeurs 2=Crucible      3=annexe
 --   apres : 0=etages 1=profondeurs 2=ARENE 3=Crucible 4=annexe
 --Une sauvegarde faite A L'INTERIEUR du Tunnel (le moteur stocke segment+etage
 --dans le ZoneLoc) peut donc pointer sur un segment qui a change de sens.
 --On ne peut pas corriger un ZoneLoc depuis Lua : le filet est de renvoyer le
 --joueur au relais si on le detecte dans le Tunnel avec un etat incoherent.
 if SV.Chapter5 ~= nil and SV.Chapter5.TunnelSegmentsShiftedFix == nil then
	SV.Chapter5.TunnelSegmentsShiftedFix = true
	--Le joueur reprendra au relais (Terminal de Sauvegarde) plutot qu'au milieu
	--d'un segment renumerote. Sans effet s'il n'est pas dans le Tunnel.
	if SV.Chapter5.TunnelMidState == nil then SV.Chapter5.TunnelMidState = nil end
 end
 if SV.Chapter7 ~= nil and SV.Chapter7.RuinsMidState == nil then SV.Chapter7.RuinsMidState = nil end
 if SV.Chapter8 ~= nil and SV.Chapter8.SanctuaryMidState == nil then SV.Chapter8.SanctuaryMidState = nil end
 if SV.Chapter9 ~= nil and SV.Chapter9.MarshMidState == nil then SV.Chapter9.MarshMidState = nil end
 if SV.Chapter10 ~= nil and SV.Chapter10.PeakMidState == nil then SV.Chapter10.PeakMidState = nil end
 --Cinematiques d'arrivee aux relais ch8-10 : retroactif (deja vus = deja joues)
 if SV.Chapter8 ~= nil and SV.Chapter8.PlayedSanctuaryRelayIntro == nil then
	SV.Chapter8.PlayedSanctuaryRelayIntro = (SV.Chapter8.ReachedCrystalRelay == true)
 end
 if SV.Chapter9 ~= nil and SV.Chapter9.PlayedMarshRelayIntro == nil then
	SV.Chapter9.PlayedMarshRelayIntro = (SV.Chapter9.ReachedMarshRelay == true)
 end
 if SV.Chapter10 ~= nil and SV.Chapter10.PlayedPeakRelayIntro == nil then
	SV.Chapter10.PlayedPeakRelayIntro = (SV.Chapter10.ReachedCloudRelay == true)
 end
 --Rejouabilite du Pic Celeste : jalon interne au parcours rejoue.
 if SV.Chapter10 ~= nil and SV.Chapter10.ReplayPastFulgur == nil then
	SV.Chapter10.ReplayPastFulgur = false
 end
 --Stations-Relais du Reseau : cinematique d'arrivee jouee une fois par station
 if SV.Reseau == nil then SV.Reseau = { Veilleurs = {} } end
 if SV.Reseau.StationIntros == nil then SV.Reseau.StationIntros = {} end
 --Vague 2 multi-sources : deblocage retroactif des secondaires ch2-10
 if SV.ChapterProgression.Chapter >= 2 and not GAME:DungeonUnlocked("grotte_repos") then
	GAME:UnlockDungeon("grotte_repos")
 end
 if SV.ChapterProgression.Chapter >= 3 and not GAME:DungeonUnlocked("bois_ronces") then
	GAME:UnlockDungeon("bois_ronces")
 end
 if SV.ChapterProgression.Chapter >= 4 and not GAME:DungeonUnlocked("halles_royales") then
	GAME:UnlockDungeon("halles_royales")
	GAME:UnlockDungeon("jardin_secret")
 end
 if SV.ChapterProgression.Chapter >= 5 and not GAME:DungeonUnlocked("foret_embuscade") then
	GAME:UnlockDungeon("foret_embuscade")
	GAME:UnlockDungeon("bois_filou")
 end
 if SV.ChapterProgression.Chapter >= 6 and not GAME:DungeonUnlocked("desert_oublies") then
	GAME:UnlockDungeon("desert_oublies")
	GAME:UnlockDungeon("crevasse_geode")
 end
 if SV.ChapterProgression.Chapter >= 7 and not GAME:DungeonUnlocked("jardin_energie") then
	GAME:UnlockDungeon("jardin_energie")
 end
 if SV.ChapterProgression.Chapter >= 8 and not GAME:DungeonUnlocked("toundra_desolee") then
	GAME:UnlockDungeon("toundra_desolee")
 end
 if SV.ChapterProgression.Chapter >= 9 and not GAME:DungeonUnlocked("bassin_tari") then
	GAME:UnlockDungeon("bassin_tari")
	GAME:UnlockDungeon("marais_errants")
 end
 if SV.ChapterProgression.Chapter >= 10 and not GAME:DungeonUnlocked("col_foudre") then
	GAME:UnlockDungeon("col_foudre")
	GAME:UnlockDungeon("falaises_envol")
	GAME:UnlockDungeon("sentier_enneige")
 end
 
 --Gloomy Forest midpoint flags (ch6)
 if SV.Chapter6 == nil then SV.Chapter6 = {} end
 if SV.Chapter6.GloomyPlayedMidpointIntro == nil then SV.Chapter6.GloomyPlayedMidpointIntro = false end
 if SV.Chapter6.GloomyMidpointState == nil then SV.Chapter6.GloomyMidpointState = 'FirstArrival' end

 --Apres-boss de Zeraora et Epreuve des Trois (DazzlingArc.lua).
 --Une partie deja au-dela du chapitre 6 n'a jamais vu ces scenes : on ne
 --les rejoue pas de force, mais on ouvre le duel a qui a battu Zeraora,
 --puisqu'il ne depend d'aucun etat de donjon.
 if SV.Chapter6.PlayedVictoryScene == nil then
	SV.Chapter6.PlayedVictoryScene = (SV.Chapter6.DefeatedGloomyBoss == true)
 end
 if SV.Chapter6.DazzlingTrialCleared == nil then SV.Chapter6.DazzlingTrialCleared = false end
 if SV.Chapter6.DazzlingTrialStarted == nil then SV.Chapter6.DazzlingTrialStarted = false end
 if SV.Chapter6.PlayedTrialVictory == nil then SV.Chapter6.PlayedTrialVictory = false end
 if SV.Chapter6.PlayedTrialDefeat == nil then SV.Chapter6.PlayedTrialDefeat = false end
 if SV.Chapter6.DazzlingTrialOffered == nil then
	SV.Chapter6.DazzlingTrialOffered = (SV.Chapter6.DefeatedGloomyBoss == true)
 end
 --LA CONFRONTATION DE LA PLACE (DazzlingPlaza). Rattrapage pour les
 --sauvegardes anterieures a son ajout : si la presentation des rivales
 --a deja ete vue, la confrontation est reputee avoir eu lieu, sinon on
 --la rejouerait alors que le recit l'a deja depassee.
 if SV.Chapter6.PlazaMet == nil then
	SV.Chapter6.PlazaMet = (SV.Chapter6.DazzlingIntroPlayed == true)
 end
 if SV.Chapter6.PlazaPending == nil then SV.Chapter6.PlazaPending = false end
 
 --LA NUIT A METANO (TownNight / TownNightScenes). Rattrapage pour les
 --sauvegardes anterieures a l'ajout de la nuit : sans ca, une partie en
 --cours arriverait avec SV.TownNight == nil.
 if SV.TownNight == nil then SV.TownNight = {} end
 if SV.TownNight.Visits == nil then SV.TownNight.Visits = 0 end
 if SV.TownNight.Met == nil then SV.TownNight.Met = {} end
 if SV.TownNight.SawStars == nil then SV.TownNight.SawStars = false end
 if SV.TownNight.Seen == nil then SV.TownNight.Seen = {} end
 if SV.TownNight.VoiceHeard == nil then SV.TownNight.VoiceHeard = {} end

 --LES PILLARDS DE METANO (TownRaid).
 if SV.TownRaid == nil then SV.TownRaid = {} end
 if SV.TownRaid.Repelled == nil then SV.TownRaid.Repelled = 0 end
 if SV.TownRaid.Lost == nil then SV.TownRaid.Lost = 0 end
 if SV.TownRaid.Pending == nil then SV.TownRaid.Pending = false end
 if SV.TownRaid.Wave == nil then SV.TownRaid.Wave = 0 end
 if SV.TownRaid.LastDay == nil then SV.TownRaid.LastDay = -1 end
 if SV.TownRaid.Told == nil then SV.TownRaid.Told = {} end

 --LE TOUR DE GUET (NightWatch). Rattrapage pour les sauvegardes
 --anterieures : sans ca, une partie en cours arriverait avec nil.
 if SV.NightWatch == nil then SV.NightWatch = {} end
 if SV.NightWatch.Explained == nil then SV.NightWatch.Explained = false end
 if SV.NightWatch.Tours == nil then SV.NightWatch.Tours = 0 end
 if SV.NightWatch.LastTour == nil then SV.NightWatch.LastTour = -1 end
 if SV.NightWatch.Assigned == nil then SV.NightWatch.Assigned = false end

 --LE PRIX D'UNE NUIT PERDUE (TownPlunder).
 if SV.TownPlunder == nil then SV.TownPlunder = {} end
 if SV.TownPlunder.ShopsEmpty == nil then SV.TownPlunder.ShopsEmpty = false end
 if SV.TownPlunder.LastStolen == nil then SV.TownPlunder.LastStolen = 0 end
 if SV.TownPlunder.LastItems == nil then SV.TownPlunder.LastItems = {} end
 if SV.TownPlunder.TotalRaids == nil then SV.TownPlunder.TotalRaids = 0 end

 --CE QUE LA VILLE DONNE (TownReward). Rattrapage sauvegardes anterieures.
 if SV.TownReward == nil then SV.TownReward = {} end
 if SV.TownReward.Pending == nil then SV.TownReward.Pending = false end
 if SV.TownReward.LastWave == nil then SV.TownReward.LastWave = 0 end
 if SV.TownReward.LastItems == nil then SV.TownReward.LastItems = {} end
 if SV.TownReward.LastMoney == nil then SV.TownReward.LastMoney = 0 end
 if SV.TownReward.Total == nil then SV.TownReward.Total = 0 end

 --LA VILLE PARLE DE LA NUIT (TownVoicesNight).
 if SV.TownVoicesNight == nil then SV.TownVoicesNight = {} end
 if SV.TownVoicesNight.Said == nil then SV.TownVoicesNight.Said = {} end

 --LES SAISONS DE METANO (Seasons.lua). Rattrapage sauvegardes anterieures.
 if SV.Seasons == nil then SV.Seasons = {} end
 if SV.Seasons.Echelle == nil then SV.Seasons.Echelle = 'court' end
 if SV.Seasons.Courante == nil then SV.Seasons.Courante = '' end
 if SV.Seasons.Vues == nil then SV.Seasons.Vues = {} end
 if SV.Seasons.Actif == nil then SV.Seasons.Actif = true end

 --JALONS DE FIN DE DONJON ch8/9/10. Ecrits par les zones et lus par
 --ReplayEnding + guild_heros_room, mais ils n'etaient declares nulle part.
 --Sur une partie DEJA commencee, on les deduit de l'etat reel du chapitre
 --plutot que de les forcer a false : un joueur ayant deja battu Diancie
 --ne doit pas perdre l'acces au donjon suivant.
 if SV.Chapter8.CrystalSanctuaryComplete == nil then
	SV.Chapter8.CrystalSanctuaryComplete = (SV.Chapter8.DefeatedDiancie == true)
 end
 if SV.Chapter9.ForgottenMarshComplete == nil then
	SV.Chapter9.ForgottenMarshComplete = (SV.Chapter9.DefeatedMegaBlastoise == true)
 end
 if SV.Chapter10.CelestialPeakComplete == nil then
	SV.Chapter10.CelestialPeakComplete = (SV.Chapter10.DefeatedLugia == true)
 end

 --Quizz de Kirlia (Epreuve II, ch8). Contrairement aux jalons ci-dessus,
 --nil est ici l'etat INITIAL VALIDE : il signifie "quizz jamais passe" et
 --declenche la proposition. On ne le force donc pas a false ; on se contente
 --de garantir que la table Chapter8 existe sur une vieille sauvegarde.
 if SV.Chapter8 == nil then SV.Chapter8 = {} end

 --LA CHAMBRE DU MAITRE (ch6). Pour une sauvegarde deja lancee, on deduit
 --l'etat de la porte plutot que de la refermer au nez du joueur : celui
 --qui a deja depasse le ch6 l'a forcement meritee.
 if SV.Chapter6.GuildmasterRoomUnlocked == nil then
	SV.Chapter6.GuildmasterRoomUnlocked =
		((SV.ChapterProgression.Chapter or 1) > 6)
 end
 if SV.Chapter6.PlayedGuildmasterAudience == nil then
	SV.Chapter6.PlayedGuildmasterAudience = SV.Chapter6.GuildmasterRoomUnlocked
 end

 --LA CHAMBRE DU MAITRE (carte neuve). Rattrapage sauvegardes anterieures.
 if SV.GuildmasterBedroom == nil then SV.GuildmasterBedroom = {} end
 if SV.GuildmasterBedroom.Visited == nil then SV.GuildmasterBedroom.Visited = false end
 if SV.GuildmasterBedroom.ReadPenticusBed == nil then SV.GuildmasterBedroom.ReadPenticusBed = false end
 if SV.GuildmasterBedroom.ReadPhileasBed == nil then SV.GuildmasterBedroom.ReadPhileasBed = false end

 if SV.GuildSidequests == nil then SV.GuildSidequests = {} end
 
 if SV.GuildSidequests.ZigzagoonLevel == nil then SV.GuildSidequests.ZigzagoonLevel = 19 end 
 if SV.GuildSidequests.GrowlitheLevel == nil then SV.GuildSidequests.GrowlitheLevel = 16 end 
 if SV.GuildSidequests.SnubbullLevel == nil then SV.GuildSidequests.SnubbullLevel = 17 end 
 if SV.GuildSidequests.AudinoLevel == nil then SV.GuildSidequests.AudinoLevel = 16 end 
 if SV.GuildSidequests.MareepLevel == nil then SV.GuildSidequests.MareepLevel = 19 end 
 if SV.GuildSidequests.CranidosLevel == nil then SV.GuildSidequests.CranidosLevel = 20 end 
 --if SV.GuildSidequests.BreloomLevel == nil then SV.GuildSidequests.BreloomLevel = 33 end 
 --if SV.GuildSidequests.GirafarigLevel == nil then SV.GuildSidequests.GirafarigLevel = 32 end 
 
 
 if SV.adventure == nil then SV.adventure = {} end 
 if SV.adventure.Thief == nil then SV.adventure.Thief = false end
 
  --Fix old chapter 2 and before saves that have bad cafe variables
 --Curse you sunkern
 if type(SV.metano_cafe.CafeSpecial) == "number" then SV.metano_cafe.CafeSpecial = "" SV.metano_cafe.BoughtSpecial = false end
 if type(SV.metano_cafe.FermentedItem) == "number" then SV.metano_cafe.FermentedItem = "" SV.metano_cafe.ItemFinishedFermenting = false end
 
 if SV.DungeonFlags.GenericEnding == nil then SV.DungeonFlags.GenericEnding = false end
 
 
 --dungeon unlocks that didnt exist for old versions
 if SV.ChapterProgression.Chapter >= 3 and not GAME:DungeonUnlocked("crooked_cavern") then
	GAME:UnlockDungeon("grass_maze")--unlock new mazes at ledian dojo
	GAME:UnlockDungeon("fire_maze")--unlock new mazes at ledian dojo
	GAME:UnlockDungeon("water_maze")--unlock new mazes at ledian dojo
	GAME:UnlockDungeon("crooked_cavern")--unlock chapter 3 dungeon
	SV.Dojo.NewMazeUnlocked = true
end	
 
 --set current story dungeon in case current one is not accurate
 if SV.ChapterProgression.Chapter == 3 and not SV.Chapter3.DefeatedBoss then
 	SV.ChapterProgression.CurrentStoryDungeon = "crooked_cavern" -- Crooked Cavern
 end 
 
 
 if SV.DestinationFloorNotified == nil then SV.DestinationFloorNotified = false end
 if SV.MonsterHouseMessageNotified == nil then SV.MonsterHouseMessageNotified = false end
 if SV.OutlawDefeated == nil then SV.OutlawDefeated = false end
 if SV.OutlawGoonsDefeated == nil then SV.OutlawGoonsDefeated = false end
 if SV.OutlawItemPickedUp == nil then SV.OutlawItemPickedUp = false end

 if SV.TakenBoard == nil then
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
	end 
	
	if SV.MissionBoard == nil then
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
	end
	
	if SV.OutlawBoard == nil then
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
	end
 
  PrintInfo("=>> Loaded version")
end

--[[---------------------------------------------------------------
    DebugTools:OnLossPenalty()
      Called when the player fails a dungeon in main progress
  ---------------------------------------------------------------]]
function DebugTools:OnLossPenalty(save) 
  assert(self, 'DebugTools:OnLossPenalty() : self is null!')
 
  --remove money. You'll keep 15-25% of what you had. Thieves keep nothing
  local remainder = math.random(1500, 2500) 
  if SV.adventure.Thief then remainder = 0 end
  save.ActiveTeam.Money = math.floor((save.ActiveTeam.Money * remainder) / 10000)
 

  local inv_count = save.ActiveTeam:GetInvCount() - 1
  --remove bag items
  for i = inv_count, 0, -1 do
    local entry = _DATA:GetItem(save.ActiveTeam:GetInv(i).ID)
    if not entry.CannotDrop then
		if math.random(1, 4) > 1 or SV.adventure.Thief then --1/4 chance an individual item will be kept. Thieves keep NOTHING
			save.ActiveTeam:RemoveFromInv(i)
		end
    end
  end
  
  --DO NOT remove equips unless the player was a thief
  
  if SV.adventure.Thief then
    local player_count = save.ActiveTeam.Players.Count
	for i = 0, player_count - 1, 1 do 
	  local player = save.ActiveTeam.Players[i]
	  if player.EquippedItem.ID ~= '' and player.EquippedItem.ID ~= nil then 
		local entry = _DATA:GetItem(player.EquippedItem.ID)
		if not entry.CannotDrop then
		  player:SilentDequipItem()
		end
	  end
    end
  end
  
end

-- function DebugTools:OnDungeonMapInit(mapname, mapobj)
-- 	if GAME:GetPlayerPartyCount() > 1 and GeneralFunctions.TableContains(MISSION_GEN.DUNGEON_LIST, _ZONE.CurrentZoneID) then
-- 		local partner = GAME:GetPlayerPartyMember(1)
-- 		local tbl = LTBL(partner)
-- 		if tbl.MissionType == COMMON.MISSION_BOARD_OUTLAW then
-- 			local origin = _DATA.Save.ActiveTeam.Leader.CharLoc
-- 			local radius = 2
-- 			local mission_num = tbl.MissionNumber
-- 			SpawnOutlaw(origin, radius, mission_num)
-- 		end
-- 	end
-- end

---Summary
-- Subscribe to all channels this service wants callbacks from
function DebugTools:Subscribe(med)
  med:Subscribe("DebugTools", EngineServiceEvents.Init,                function() self.OnInit(self) end )
  med:Subscribe("DebugTools", EngineServiceEvents.Deinit,              function() self.OnDeinit(self) end )
  med:Subscribe("DebugTools", EngineServiceEvents.NewGame,        function() self.OnNewGame(self) end )
  med:Subscribe("DebugTools", EngineServiceEvents.UpgradeSave,        function() self.OnUpgrade(self) end )
  med:Subscribe("DebugTools", EngineServiceEvents.LossPenalty,        function(_, args) self.OnLossPenalty(self, args[0]) end )
	-- med:Subscribe("DebugTools", EngineServiceEvents.DungeonMapInit,        function(_, args) self.OnDungeonMapInit(self, args[0], args[1]) end )
  --  med:Subscribe("DebugTools", EngineServiceEvents.GraphicsUnload,      function() self.OnGraphicsUnload(self) end )
  --  med:Subscribe("DebugTools", EngineServiceEvents.Restart,             function() self.OnRestart(self) end )
end

---Summary
-- un-subscribe to all channels this service subscribed to
function DebugTools:UnSubscribe(med)
end

---Summary
-- The update method is run as a coroutine for each services.
function DebugTools:Update(gtime)
--  while(true)
--    coroutine.yield()
--  end
end

--Add our service
SCRIPT:AddService("DebugTools", DebugTools:new())
return DebugTools