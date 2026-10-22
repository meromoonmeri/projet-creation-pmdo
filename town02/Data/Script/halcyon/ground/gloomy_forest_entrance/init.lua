require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.gloomy_forest_entrance.gloomy_forest_entrance_ch_6'

local gloomy_forest_entrance = {}

function gloomy_forest_entrance.Init(map)
	DEBUG.EnableDbgCoro()
	print('=>> Init_gloomy_forest_entrance <<=')
	COMMON.RespawnAllies()
	PartnerEssentials.InitializePartnerSpawn()
end

function gloomy_forest_entrance.Enter(map)
	gloomy_forest_entrance.PlotScripting()
end

function gloomy_forest_entrance.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	gloomy_forest_entrance.PlotScripting()
end

function gloomy_forest_entrance.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function gloomy_forest_entrance.PlotScripting()
	--SORTIE GARANTIE (regle projet : toute scene sous pcall).
	--ArrivalCutscene etait appelee A NU. Son GAME:FadeIn est a la ligne 56
	--de gloomy_forest_entrance_ch_6.lua, APRES un AddMapStatus qui levait
	--une NullReferenceException (MapStatus inexistant). L'erreur remontait
	--donc sans que l'ecran soit jamais rallume : ecran noir definitif,
	--exactement le symptome constate en jeu.
	--Le MapStatus a ete cree, mais la protection reste : aucune scene ne
	--doit pouvoir laisser le joueur devant un ecran noir.
	if SV.ChapterProgression.Chapter == 6 and not SV.Chapter6.SinisterApproachSeen then
		local ok, err = pcall(function()
			gloomy_forest_entrance_ch_6.ApproachCutscene()
			gloomy_forest_entrance_ch_6.DazzlingEntranceBlockade()
		end)
		if not ok then
			PrintInfo('[gloomy_forest_entrance] ApproachCutscene interrompue : '..tostring(err))
			--On ne rejoue pas une scene a moitie jouee : on la marque faite,
			--on rend la main, et le joueur peut continuer.
			pcall(function() SV.Chapter6.SinisterApproachSeen = true end)
			pcall(function() gloomy_forest_entrance_ch_6.SetupGround() end)
			pcall(function() GAME:CutsceneMode(false) end)
			pcall(function() GAME:FadeIn(20) end)
		end
	else
		gloomy_forest_entrance_ch_6.SetupGround()
		GAME:FadeIn(20)
		-- Rattrapage save/load : l'approche peut être vue alors que le barrage
		-- Dazzling ne l'est pas encore. Le flag indépendant évite tout doublon.
		if SV.ChapterProgression.Chapter == 6 and not SV.Chapter6.DazzlingEntranceSeen then
			pcall(gloomy_forest_entrance_ch_6.DazzlingEntranceBlockade)
		end
	end
end

function gloomy_forest_entrance.Teammate1_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function gloomy_forest_entrance.Butterfree_Action(obj, activator)
	DEBUG.EnableDbgCoro()
	gloomy_forest_entrance_ch_6.Butterfree_Action(obj, activator)
end

function gloomy_forest_entrance.Kangaskhan_Rock_Action(obj, activator)
	GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function gloomy_forest_entrance.Dungeon_Entrance_Touch(obj, activator)
	if SV.Chapter6.MissionAccepted and not SV.Chapter6.MissionComplete then
		SV.Chapter6.EnteredGloomyForest = true
		SOUND:FadeOutBGM(40)
		GAME:FadeOut(false, 40)
		GAME:EnterDungeon("gloomy_forest", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
	end
end

return gloomy_forest_entrance
