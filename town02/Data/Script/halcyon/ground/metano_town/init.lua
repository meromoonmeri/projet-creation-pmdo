require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
require 'halcyon.CharacterEssentials'
require 'halcyon.AudinoAssembly'
require 'halcyon.ReplayEnding'
require 'halcyon.ground.metano_town.metano_town_ch_1'
require 'halcyon.ground.metano_town.metano_town_ch_2'
require 'halcyon.ground.metano_town.metano_town_ch_3'
require 'halcyon.ground.metano_town.metano_town_ch_4'
require 'halcyon.ground.metano_town.metano_town_ch_5'
require 'halcyon.ground.metano_town.metano_town_ch_7'
require 'halcyon.ground.metano_town.metano_town_ch_6'
require 'halcyon.ground.metano_town.metano_town_legend'
require 'halcyon.menu.single_deal_menu'
require 'origin.menu.skill.SkillTutorMenu'
require 'halcyon.SideQuests'
require 'halcyon.TownPlunder'
require 'halcyon.Seasons'
require 'halcyon.LivingWorld'
require 'halcyon.TownVoicesNight'
require 'halcyon.TownReward'
require 'halcyon.TownLife'




local metano_town = {}


function metano_town.Init(map)
	DEBUG.EnableDbgCoro()
	print('=>> Init_metano_town <<=')

	COMMON.RespawnAllies()
	PartnerEssentials.InitializePartnerSpawn()
	--Protege : GetMapStatus (DataManager.cs:1302) AVALE l'exception et
	--renvoie null, puis MapStatus.LoadFromData (Maps/MapStatus.cs:44)
	--dereference entry.StatusStates -> NullReferenceException qui tue la
	--fonction appelante AVANT son FadeIn. C'est la cause de l'ecran noir
	--constate en jeu. Le MapStatus existe desormais, le pcall reste en
	--garde-fou : un ID absent ne doit jamais pouvoir noircir l'ecran.
	pcall(function() GROUND:AddMapStatus("clouds_overhead") end)

	--SAISON DU BOURG (Seasons.lua). Le decor suit l'avancement du recit :
	--petales au printemps, feuilles en automne, neige en hiver, rien en ete.
	--Pose ICI et pas dans Enter, comme clouds_overhead juste au-dessus :
	--Init s'execute carte chargee, avant que le joueur ne la voie.
	--Apply() retire d'abord les trois statuts saisonniers — un MapStatus
	--persiste (cf. guild_heros_room_ch_1.lua:162), donc sans ce nettoyage
	--deux saisons finiraient par se superposer.
	pcall(function() Seasons.Setup() end)
	pcall(function() LivingWorld.SyncStory() end)

	--Remove nicknames from characters if the nickname mod is enabled.
	if CONFIG.UseNicknames() then
		metano_town.SetMerchantNicknames()
	else
		metano_town.RemoveMerchantNicknames()
	end

	if SOUND:GetCurrentSong() ~= SV.metano_town.Song then
      SOUND:PlayBGM(SV.metano_town.Song, true)
    end

	--Musician must wiggle as long as he's playing a song!
	if SV.metano_town.Song ~= 'Treasure Town.ogg' then
	   GROUND:CharSetAnim(CH('Musician'), "Wiggle", true)
	end

	if not SV.ChapterProgression.UnlockedAssembly then
		GROUND:Hide('Assembly')
	end

	-- Grodoudou (Legend_Merchant) et son stand de Zones Légendaires : cachés avant le chapitre 6
	-- (l'arrivée officielle se joue après le retour d'expédition via ArrivalScene).
	if SV.ChapterProgression.Chapter < 6 then
		GROUND:Hide('Legend_Merchant')
		GROUND:Hide('Legend_Stand')
	else
		GROUND:Unhide('Legend_Merchant')
		GROUND:Unhide('Legend_Stand')
	end

end



function metano_town.Enter(map)
	DEBUG.EnableDbgCoro()
	print('Enter_metano_town')
	if SV.TemporaryFlags and SV.TemporaryFlags.RewardCutsceneQuest then
		local q_id = SV.TemporaryFlags.RewardCutsceneQuest
		SV.TemporaryFlags.RewardCutsceneQuest = nil
		if SideQuests and SideQuests.PlayRewardCutscene(q_id) then
			return
		end
	end
	metano_town.PlotScripting()

	--La premiere fois qu'une saison s'installe, le partenaire la remarque.
	--Une seule fois par saison, deux boites. Appele APRES PlotScripting :
	--une scene d'histoire garde toujours la priorite sur un commentaire
	--de decor.
	pcall(function() Seasons.Remark() end)

	-- Une courte interaction sociale par journée, uniquement après que la
	-- rivalité Dazzling a installé la vie publique du chapitre 6. Les scènes
	-- de scénario et récompenses gardent la priorité.
	pcall(function()
		local t=SV.TemporaryFlags or {}
		if SV.ChapterProgression.Chapter>=6
		   and SV.Chapter6 and SV.Chapter6.DazzlingIntroPlayed
		   and not t.MissionCompleted and not t.RewardCutsceneQuest then
			TownLife.PlayDailySocial()
		end
	end)
end

function metano_town.Update(map, time)

end

function metano_town.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	metano_town.PlotScripting()
end

function metano_town.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end



function metano_town.PlotScripting()
	--LES FELICITATIONS DU LENDEMAIN (TownReward). Jouees quand la nuit
	--precedente a ete gagnee, AVANT le scripting de chapitre : c'est une
	--breve reaction de la ville, pas une scene d'histoire. Elle se
	--desarme d'elle-meme (Pending) et ne se joue donc qu'une fois.
	--
	--Placee ici et non dans Enter : PlotScripting est le point ou les
	--scenes de ville se declenchent deja, on suit l'usage du fichier.
	pcall(function() TownReward.Congratulations() end)

	--plot scripting
	if SV.ChapterProgression.Chapter == 1 then
		if not SV.Chapter1.PartnerCompletedForest then
			metano_town_ch_1.PartnerLongingCutscene()
		elseif SV.Chapter1.TeamCompletedForest then
			metano_town_ch_1.EnterGuild()
		end
	elseif SV.ChapterProgression.Chapter == 2 then
		metano_town_ch_2.SetupGround()
		if SV.Chapter2.FinishedTraining and not SV.Chapter2.FinishedMarketIntro then
			metano_town_ch_2.MarketIntro()
		end
	elseif SV.ChapterProgression.Chapter == 3 then
		metano_town_ch_3.SetupGround()
		if SV.Chapter3.FinishedOutlawIntro and not SV.Chapter3.MetTeamStyle then
			metano_town_ch_3.MeetTeamStyle()
		elseif SV.Chapter3.DefeatedBoss and not SV.Chapter3.FinishedMerchantIntro then
			metano_town_ch_3.MerchantIntro()
		end
	elseif SV.ChapterProgression.Chapter == 4 then
		metano_town_ch_4.SetupGround()
	elseif SV.ChapterProgression.Chapter == 5 then
		metano_town_ch_5.SetupGround()
	elseif SV.ChapterProgression.Chapter == 6 then
		metano_town_ch_6.SetupGround()
		if SV.Chapter6.MissionComplete and not SV.Chapter6.PostMissionScenePlayed then
			metano_town_ch_6.PostMissionCutscene()
		elseif SV.Chapter6.DefeatedByZeraora and not SV.Chapter6.PostDefeatScenePlayed then
			metano_town_ch_6.PostDefeatCutscene()
		end
	elseif SV.ChapterProgression.Chapter == 7 then
		--------------------------------------------------------------
		-- ARC GROUDON — chaine de declenchement (correctif 2026-08-02)
		--
		-- metano_town_ch_7.GreatReunion etait DEFINIE (153 lignes, 17
		-- boites) mais appelee NULLE PART : la seule occurrence du nom
		-- dans tout le depot etait sa propre declaration. Toute la
		-- chaine aval etait donc morte :
		--   * la grande reunion (Alakazam raconte les evenements d'il y
		--     a trente ans) ne se jouait jamais ;
		--   * colline_sans_lumiere, ou le partenaire fait promettre au
		--     heros de taire son identite, n'etait jamais atteinte —
		--     son unique appelant est la fin de GreatReunion ;
		--   * SV.Chapter7.GreatReunionPlayed et FinishedIntimateTalk
		--     restaient a false pour toujours.
		--
		-- Ordre narratif retabli :
		--   1. AlakazamScene     — la Team Alakazam suggere d'aller voir
		--                          le Veilleur du Grand Canyon
		--   2. (donjon)          — new_era_zone_07, puis colline_anciens
		--                          ou Xatu entre en transe et designe le
		--                          titan de magma. Pose VisitedXatu.
		--   3. GreatReunion      — retour en ville : la grande reunion.
		--                          C'est VisitedXatu qui l'ouvre.
		--   4. colline_sans_lumiere — la scene intime, enchainee par la
		--                          fin de GreatReunion elle-meme.
		--------------------------------------------------------------
		if SV.Chapter7.AlakazamScenePlayed == nil then SV.Chapter7.AlakazamScenePlayed = false end
		if SV.Chapter7.VisitedXatu == nil then SV.Chapter7.VisitedXatu = false end
		if SV.Chapter7.GreatReunionPlayed == nil then SV.Chapter7.GreatReunionPlayed = false end
		if not SV.Chapter7.AlakazamScenePlayed then
			metano_town_ch_7.AlakazamScene()
		elseif SV.Chapter7.VisitedXatu and not SV.Chapter7.GreatReunionPlayed then
			--Le duo redescend du Canyon avec ce que le Veilleur a vu.
			--C'est ce qui declenche la reunion, pas le simple fait
			--d'entrer en ville.
			metano_town_ch_7.GreatReunion()
		else
			GAME:FadeIn(20)
		end
	elseif SV.ChapterProgression.Chapter == 8 then
		require 'halcyon.ground.metano_town.metano_town_ch_8'
		metano_town_ch_8.SetupGround()
	elseif SV.ChapterProgression.Chapter == 9 then
		require 'halcyon.ground.metano_town.metano_town_ch_9'
		metano_town_ch_9.SetupGround()
	elseif SV.ChapterProgression.Chapter == 10 then
		require 'halcyon.ground.metano_town.metano_town_ch_10'
		metano_town_ch_10.SetupGround()
	elseif SV.ChapterProgression.Chapter == 11 then
		--------------------------------------------------------------
		-- CHAPITRE 11 — « Ceux que l'on accuse » (correctif 2026-08-02)
		--
		-- La ville n'avait AUCUN etat pour le ch11 : le `else` final
		-- attrapait le chapitre et se contentait d'un FadeIn. Or c'est
		-- precisement le chapitre ou Metano se retourne contre le
		-- heros — six des dix scenes de l'arc s'y jouent.
		--
		-- AccusationArc n'etait par ailleurs require'd nulle part : le
		-- module n'existait pas a l'execution. Il est charge ici et
		-- dans guild_heros_room_ch_11.
		--
		-- Ordre des scenes exterieures, pilote par SV.AccusationArc :
		--   2 la rumeur        apres le retour au sol (scene 1, chambre)
		--   3 le discours      le Cercle du Suaire sur la place
		--   4 Plum             la seule voix qui refuse
		--   6 le boycott       les echoppes ferment
		--   7 la manifestation de nuit, devant la guilde
		-- Les scenes 5 (la guilde ferme ses portes) et 8 (le conseil)
		-- se jouent a l'interieur de la guilde ; 1, 9 et 10 dans la
		-- chambre puis sur la route.
		--------------------------------------------------------------
		require 'halcyon.AccusationArc'
		local s = SV.AccusationArc
		if s == nil then SV.AccusationArc = { Scene = 0 }; s = SV.AccusationArc end

		if s.Scene == 1 then
			AccusationArc.Play(AccusationArc.Scene2_Rumeur, 'Scene2_Rumeur')
		elseif s.Scene == 2 then
			AccusationArc.Play(AccusationArc.Scene3_Discours, 'Scene3_Discours')
		elseif s.HeardAccusation and not s.PlumDefended then
			AccusationArc.Play(AccusationArc.Scene4_Plum, 'Scene4_Plum')
		elseif s.PlumDefended and not s.ShopsClosed then
			AccusationArc.Play(AccusationArc.Scene6_Boycott, 'Scene6_Boycott')
		elseif s.Scene == 5 and not s.SawProtest then
			--La manifestation vient APRES que la guilde a ferme ses portes
			--(scene 5), pas apres le conseil : c'est justement parce que
			--les portes sont closes que la foule attend dehors.
			AccusationArc.Play(AccusationArc.Scene7_Manifestation, 'Scene7_Manifestation')
		else
			GAME:FadeIn(20)
		end
	else
		GAME:FadeIn(20)
	end
end


--------------------------------------------------
-- Map Begin Functions
--------------------------------------------------
function metano_town.CreateWalkArea(chara, x, y, w, h)


  --Set the area to wander in
  AI:SetCharacterAI(chara,                                      --[[Entity that will use the AI]]--
                    "halcyon.ai.ground_default",                         --[[Class path to the AI class to use]]--
                    RogueElements.Loc(x, y), --[[Top left corner pos of the allowed idle wander area]]--
                    RogueElements.Loc(w, h), --[[Width and Height of the allowed idle wander area]]--
                    1,                                         --[[Wandering speed]]--
                    16,                                          --[[Min move distance for a single wander]]--
                    32,                                          --[[Max move distance for a single wander]]--
                    40,                                         --[[Min delay between idle actions]]--
                    180)                                        --[[Max delay between idle actions]]--
end







----------------------
-- Map Transitions
----------------------

--Main_Entrance_Marker is the default entrance marker for a map, every map
--has that marker, but it's kinda arbitrary which one I choose to be the "main" one.
--Other markers may need to be specified if a map has more than once entrance point.

function metano_town.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
  UI:ResetSpeaker()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Voulez-vous entrer dans " .. zone:GetColoredName() .. " ?", true)
  UI:WaitForChoice()
  local yesnoResult = UI:ChoiceResult()
  if yesnoResult then
	SOUND:FadeOutBGM(60)
	GAME:FadeOut(false, 60)
	partner.IsInteracting = false
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	SV.partner.Spawn = "Default"--default partner spawn, since it could be a bunch of things before this, but it should be default for wherever we end up after the dungeon.
	GAME:EnterDungeon("illuminant_riverbed", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

function metano_town.East_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  --Rejouabilite : rouvre au voyage les donjons d'histoire deja termines.
  --Les 7 donjons ch5-ch10 n'etaient jamais passes a UnlockDungeon, donc ils
  --n'apparaissaient pas dans la liste ci-dessous meme une fois boucles.
  --Idempotent et garde par pcall : n'empeche jamais l'ouverture du menu.
  ReplayEnding.SyncUnlocks()
  GeneralFunctions.StartPartnerConversation("Où devrions-nous aller,[pause=10]" .. CH('PLAYER'):GetDisplayName() .. " ?", "Normal", false)
  GAME:WaitFrames(20)
  local dungeons = {"relic_forest", "illuminant_riverbed", "crooked_cavern", "apricorn_grove", "vast_steppe", "searing_tunnel", "mount_windswept", "gloomy_forest", "cloven_ruins", "waterfall_pond", "poisonous_forest", "petit_tunnel", "bosquet_voile", "grotte_mystere", "vallee_fertile", "antre_enigme", "carriere_cuivre", "grotte_echoue"}--this needs to be updated when more dungeons come out.
  -- Luluby Town (Waves of Nostalgia) est une destination Ground, pas un
  -- faux donjon. Les trois éclairages sont proposés pour valider et jouer
  -- matin, soirée et nuit pendant l'arc du Tournoi Multiguilde.
  local grounds = {
    {Zone="master_zone", GroundName="luluby_town_morning", Flag=true, Entry=0},
    {Zone="master_zone", GroundName="luluby_town_evening", Flag=true, Entry=0},
    {Zone="master_zone", GroundName="luluby_town_night", Flag=true, Entry=0}
  }
  metano_town.ShowDestinationMenu(dungeons, grounds)
end

function metano_town.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_altere_transition", "Main_Entrance_Marker", true)
  SV.partner.Spawn = 'Default'
end

function metano_town.Guild_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  if SV.metano_town.Song ~= "Wigglytuff's Guild.ogg" then SOUND:FadeOutBGM(20) end--map transition may result in a music change depending on song Falo is playing
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("guild_first_floor", "Main_Entrance_Marker", SV.metano_town.Song == "Wigglytuff's Guild.ogg")
  SV.partner.Spawn = 'Default'
end

function metano_town.Cafe_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  if SV.metano_town.Song ~= "Spinda's Cafe.ogg" then SOUND:FadeOutBGM(20) end--map transition may result in a music change depending on song Falo is playing
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_cafe", "Main_Entrance_Marker", SV.metano_town.Song == "Spinda's Cafe.ogg")
  SV.partner.Spawn = 'Default'
end

function metano_town.Fire_Home_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_fire_home", "Main_Entrance_Marker", true)
  SV.partner.Spawn = 'Default'
end

function metano_town.Rock_Home_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_rock_home", "Main_Entrance_Marker", true)
  SV.partner.Spawn = 'Default'
end

function metano_town.Water_Home_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_water_home", "Main_Entrance_Marker", true)
  SV.partner.Spawn = 'Default'
end

function metano_town.Grass_Home_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_grass_home", "Main_Entrance_Marker", true)
  SV.partner.Spawn = 'Default'
end

function metano_town.Electric_Home_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_electric_home", "Main_Entrance_Marker", true)
  SV.partner.Spawn = 'Default'
end

function metano_town.Normal_Home_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_normal_home", "Main_Entrance_Marker", true)
  SV.partner.Spawn = 'Default'
end

function metano_town.Cave_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_cave", "Main_Entrance_Marker", true)
  SV.partner.Spawn = 'Default'
end

function metano_town.Dojo_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  if SV.metano_town.Song ~= "Wigglytuff's Guild Remix.ogg" then SOUND:FadeOutBGM(20) end--map transition may result in a music change depending on song Falo is playing
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("ledian_dojo", "Main_Entrance_Marker", SV.metano_town.Song == "Wigglytuff's Guild Remix.ogg")
  SV.partner.Spawn = 'Default'
end

function metano_town.Post_Office_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("post_office", "Main_Entrance_Marker", true)
  SV.partner.Spawn = 'Default'
end

function metano_town.Inn_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_inn", "Main_Entrance_Marker", true)
  SV.partner.Spawn = 'Default'
end




-----------------------
-- Partner scripting
-----------------------

function metano_town.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

--locales mark the zone of the town we're in for partner dialogue
function metano_town.Cafe_Locale_Touch(chara, activator)
	DEBUG.EnableDbgCoro()
	SV.metano_town.Locale = 'Cafe'
end

function metano_town.Exploration_Locale_Touch(chara, activator)
	DEBUG.EnableDbgCoro()
	SV.metano_town.Locale = 'Exploration'
end

function metano_town.Cave_Locale_Touch(chara, activator)
	DEBUG.EnableDbgCoro()
	SV.metano_town.Locale = 'Cave'
end

function metano_town.South_Houses_Locale_Touch(chara, activator)
	DEBUG.EnableDbgCoro()
	SV.metano_town.Locale = 'South Houses'
end

function metano_town.North_Houses_Locale_Touch(chara, activator)
	DEBUG.EnableDbgCoro()
	SV.metano_town.Locale = 'North Houses'
end

function metano_town.Merchants_Locale_Touch(chara, activator)
	DEBUG.EnableDbgCoro()
	SV.metano_town.Locale = 'Merchants'
end

function metano_town.Guild_Locale_Touch(chara, activator)
	DEBUG.EnableDbgCoro()
	SV.metano_town.Locale = 'Guild'
end

function metano_town.Market_Locale_Touch(chara, activator)
	DEBUG.EnableDbgCoro()
	SV.metano_town.Locale = 'Market'
end

function metano_town.Well_Locale_Touch(chara, activator)
	DEBUG.EnableDbgCoro()
	SV.metano_town.Locale = 'Well'
end

function metano_town.Post_Locale_Touch(chara, activator)
	DEBUG.EnableDbgCoro()
	SV.metano_town.Locale = 'Post'
end

function metano_town.Dojo_Locale_Touch(chara, activator)
	DEBUG.EnableDbgCoro()
	SV.metano_town.Locale = 'Dojo'
end


-----------------------
-- Helper Functions
-----------------------
--Reimplemented, modified version of common's showdestination menu.
--This is a bit messy since the original showdestination menu had a bunch of stuff updated from it, so be aware if things break in the future with it.
function metano_town.ShowDestinationMenu(dungeon_entrances,ground_entrances)

  --Story dungeons and their corresponding "entrance ground" used for story cutscenes during the relevant chapter.
  --Illuminant Riverbed and Relic Forest 1 are story dungeons not accessed via this menu and thus the flag doesn't track them.
  -- Les imports Sky/Red font évoluer GroundMaps : aucune destination ne doit
  -- dépendre d'un index numérique. Les zones sans véritable ground d'entrée
  -- (waterfall_pond actuellement) entrent directement dans le donjon au lieu
  -- de détourner un asset canonique de réserve tel que sanctuaire_voeu/Jirachi.
  local dungeon_entrance_mapping = {
    illuminant_riverbed = "illuminant_riverbed_entrance",
    crooked_cavern = "crooked_cavern_entrance",
    apricorn_grove = "apricorn_grove_entrance",
    vast_steppe = "vast_steppe_entrance",
    searing_tunnel = "searing_tunnel_entrance",
    mount_windswept = "mount_windswept_entrance",
    gloomy_forest = "gloomy_forest_entrance",
    cloven_ruins = "cloven_ruins_entrance",
    poisonous_forest = "poisonous_forest_entrance"
  }

  local function master_ground_idx(name)
    local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("master_zone")
    for ii = 0, zone.Grounds.Count - 1 do
      if zone.Grounds[ii] == name then return ii end
    end
    return nil
  end


	local mission_dests = {}
	for ii = 1, 8 do
		local zone = SV.TakenBoard[ii].Zone;
		if zone ~= "" and SV.TakenBoard[ii].Taken then
			mission_dests[zone] = true
		end
	end

	--check for unlock of dungeons
  local open_dests = {}
  for ii = 1,#dungeon_entrances,1 do
    if GAME:DungeonUnlocked(dungeon_entrances[ii]) then
	  local zone_summary = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(dungeon_entrances[ii])
	  local zone_name = ""
	  if _DATA.Save:GetDungeonUnlock(dungeon_entrances[ii]) == RogueEssence.Data.GameProgress.UnlockState.Completed then
		zone_name = zone_summary:GetColoredName()
	  else
	    zone_name = "[color=#00FFFF]"..zone_summary.Name:ToLocal().."[color]"
	  end

		local zone_title = zone_name
	  if dungeon_entrances[ii] == SV.ChapterProgression.CurrentStoryDungeon then
	      zone_name = STRINGS:Format('\\uE111 ') .. zone_name --exclamation symbol
	  elseif mission_dests[dungeon_entrances[ii]] then
	      zone_name = STRINGS:Format("\\uE10F ") .. zone_name --open letter
      end
      table.insert(open_dests, { Name=zone_name, Title=zone_title, Dest=RogueEssence.Dungeon.ZoneLoc(dungeon_entrances[ii], 0, 0, 0) })
	end
  end

  --check for unlock of grounds
  for ii = 1,#ground_entrances,1 do
    if ground_entrances[ii].Flag then
	  local ground_id = ground_entrances[ii].Zone
	  local zone = _DATA:GetZone(ground_id)
      local ground_idx = ground_entrances[ii].ID
      if ground_idx == nil and ground_entrances[ii].GroundName ~= nil then
        if ground_id ~= "master_zone" then error("GroundName dynamique seulement supporté dans master_zone") end
        ground_idx = master_ground_idx(ground_entrances[ii].GroundName)
      end
      if ground_idx == nil then error("Ground destination absente: "..tostring(ground_entrances[ii].GroundName)) end
	  local ground = _DATA:GetGround(zone.GroundMaps[ground_idx])
	  local ground_name = ground:GetColoredName()
      table.insert(open_dests, { Name=ground_name, Title=ground_name, Dest=RogueEssence.Dungeon.ZoneLoc(ground_id, -1, ground_idx, ground_entrances[ii].Entry or 0) })
	end
  end

  local dest = RogueEssence.Dungeon.ZoneLoc.Invalid
  local choice = 1
  local confirm = false
  local ask_dest

  --overhauled this quite a bit from original ShowDestinationMenu.
  --TODO (potentially)!!!: Needs to be adapted to handle overworld grounds and 1 ground / 1 dungeon scenarios potentially in the future.
  --For how to do that, check audino's version. I basically removed most of that functionality since I didn't envision myself needing to use it...
  if #open_dests >= 1 then
    SOUND:PlaySE("Menu/Skip")
	while true do
      UI:ResetSpeaker()
      UI:DestinationMenu(open_dests, choice)
	  UI:WaitForChoice()
	  choice = UI:ChoiceResult()

	  --stop showing the menu if cancel was pressed
	  if choice == nil then
		break
	  end

	  ask_dest = open_dests[choice].Dest

	  -- Confirmation commune aux donjons et aux Grounds. L'ancienne branche
      -- ignorait entièrement les destinations Segment=-1 : elles figuraient
      -- au menu mais ne pouvaient jamais être sélectionnées.
      UI:ResetSpeaker(false)
      UI:SetAutoFinish(true)
      UI:SetCenter(true)
      local dest_name = open_dests[choice].Title or open_dests[choice].Name
      UI:ChoiceMenuYesNo(dest_name .. " est la destination.\nEst-ce exact ?")
      UI:WaitForChoice()
      local confirmed = UI:ChoiceResult()
      UI:SetCenter(false)
      UI:SetAutoFinish(false)
      UI:ResetSpeaker()
      if confirmed then
        dest = ask_dest
        break
      end
	end
  else
    PrintInfo("No valid destinations found!")
  end


  if dest:IsValid() then
	SOUND:FadeOutBGM(60)
	GAME:FadeOut(false, 60)
	GeneralFunctions.EndConversation(CH('Teammate1'))--end the conversation that was started with the partner before we enter the dungeon.
	if dest.StructID.Segment > -1 then
	  if SV.ChapterProgression.CurrentStoryDungeon == dest.ID and dungeon_entrance_mapping[dest.ID] ~= nil then
        -- Le donjon d'histoire passe par son vrai ground d'approche, résolu par nom.
        GAME:WaitFrames(120)
        SV.partner.Spawn = "Default"
        local ground_idx = master_ground_idx(dungeon_entrance_mapping[dest.ID])
        if ground_idx == nil then
          error("Ground d'entrée absent de master_zone: " .. tostring(dungeon_entrance_mapping[dest.ID]))
        end
        GAME:EnterZone("master_zone", -1, ground_idx, 0)
	  else
	    SV.partner.Spawn = "Default"--default partner spawn, since it could be a bunch of things before this, but it should be default for wherever we end up after the dungeon.
	    GAME:EnterDungeon(dest.ID, dest.StructID.Segment, dest.StructID.ID, dest.EntryPoint, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
      end
    else
	  GAME:EnterZone(dest.ID, dest.StructID.Segment, dest.StructID.ID, dest.EntryPoint)
    end
  else
	--end the conversation that was started before the menu was opened. Need to do it like this with the else statements or it causes a backend error as it would try to run this function AFTER entering the dungeon (for some reason).
	GeneralFunctions.EndConversation(CH('Teammate1'))
  end

end


-----------------------
-- Shop/Useful NPCs
-----------------------

function metano_town.GenerateGreenKecleonStock(generate_random_item)
	--generate random stock of items for green kec. Items generated are based on story progression (better items will crop up later in the story)
	--Start with predefined list of weighted items, then generate a stock of several items from those lists
	--Stocks are separated based on category (food, medicine, hold item, etc).
	--Kec stock isn't totally random, it pulls a gauranteed number from each stock  (i.e. always 1 hold item a day, but which it is is random)

	local stock = {}

	--This parameter determines whether to generate a random item or to actually refresh the stock.
	--The parameter should be true if we want to generate and return a single kec item (useful for red merchant)
	--This is a bit of a lazy/poor way of doing it, but it should work fine for how often it's used.
	if generate_random_item == nil then generate_random_item = false end

	--TODO: Add more types of stock progressions later on
	--Basic Stock, early game

	--total weight = 200
	local food_stock = {
		{"food_apple", 182}, --Apple
		{"gummi_blue", 1}, --Blue Gummi
		{"gummi_black", 1}, --Black Gummi
		{"gummi_clear", 1}, --Clear Gummi
		{"gummi_grass", 1}, --Grass Gummi
		{"gummi_green", 1}, --Green Gummi
		{"gummi_brown", 1}, --Brown Gummi
		{"gummi_orange", 1}, --Orange Gummi
		{"gummi_gold", 1}, --Gold Gummi
		{"gummi_pink", 1}, --Pink Gummi
		{"gummi_purple", 1}, --Purple Gummi
		{"gummi_red", 1}, --Red Gummi
		{"gummi_royal", 1}, --Royal Gummi
		{"gummi_silver", 1}, --Silver Gummi
		{"gummi_white", 1}, --White Gummi
		{"gummi_yellow", 1}, --Yellow Gummi
		{"gummi_sky", 1}, --Sky Gummi
		{"gummi_gray", 1}, --Gray Gummi
		{"gummi_magenta", 1}	--Magenta Gummi
	}

	--total weight = 126
	local medicine_stock = {
		{"seed_reviver", 10},--Reviver seed
		{"seed_warp", 6}, --Warp Seed
		{"seed_sleep", 6}, --Sleep seed
		{"seed_vile", 2}, --Vile seed
		{"seed_decoy", 6}, --decoy seed
		{"seed_blast", 8}, --Blast seed
		{"seed_quick", 6}, --Quick seed

		{"berry_leppa", 25}, --Leppa berry


		{"berry_oran", 32}, --Oran berry
		{"berry_lum", 2}, --Lum berry
		{"berry_cheri", 6}, -- Cheri berry
		{"berry_chesto", 4}, -- Chesto berry
		{"berry_pecha", 8}, -- Pecha berry
		{"berry_aspear", 3}, -- Aspear berry
		{"berry_rawst", 4}, -- Rawst berry
		{"berry_persim", 6} -- Persim berry
	}


	local ammo_stock =
	{
		{"ammo_geo_pebble", 50}, --Geo pebble
		{"ammo_gravelerock", 50}, --Geo pebble
		{"ammo_stick", 50},--stick
		{"ammo_iron_thorn", 50}--iron thorn
	}


	local held_stock = {
		{"held_power_band", 10}, -- power band
		{"held_special_band", 10}, --special band
		{"held_defense_scarf", 10}, --defense scarf
		{"held_zinc_band", 10}, --Zinc band

		{"held_pecha_scarf", 10}, --Pecha Scarf
		{"held_cheri_scarf", 10}, --Cheri scarf
		{"held_rawst_scarf", 10}, --Rawst scarf
		{"held_aspear_scarf", 10}, --Aspear Scarf
		{"held_insomniascope", 10}, --Insomnia scope
		{"held_persim_band", 10}, --Persim Band

		{"held_reunion_cape", 2} --Reunion cape

	}

	--replaces a medicine roll starting with chapter 4. Before then, isn't used.
	local apricorn_stock = {
		{"apricorn_plain", 10},
		{"apricorn_black", 5},
		{"apricorn_blue", 5},
		{"apricorn_brown", 5},
		{"apricorn_green", 5},
		{"apricorn_purple", 5},
		{"apricorn_red", 5},
		{"apricorn_white", 5},
		{"apricorn_yellow", 5}
	}



	--Apricorns become available once Chapter 4 starts
	if SV.ChapterProgression.Chapter == 4 then
		table.insert(stock, GeneralFunctions.WeightedRandom(held_stock))
		table.insert(stock, GeneralFunctions.WeightedRandom(ammo_stock))
		table.insert(stock, GeneralFunctions.WeightedRandom(apricorn_stock))
		table.insert(stock, GeneralFunctions.WeightedRandom(food_stock))
		table.insert(stock, GeneralFunctions.WeightedRandom(food_stock))
		table.insert(stock, GeneralFunctions.WeightedRandom(medicine_stock))
		table.insert(stock, GeneralFunctions.WeightedRandom(medicine_stock))
		table.insert(stock, GeneralFunctions.WeightedRandom(medicine_stock))

	else
		table.insert(stock, GeneralFunctions.WeightedRandom(held_stock))
		table.insert(stock, GeneralFunctions.WeightedRandom(ammo_stock))
		table.insert(stock, GeneralFunctions.WeightedRandom(food_stock))
		table.insert(stock, GeneralFunctions.WeightedRandom(food_stock))
		table.insert(stock, GeneralFunctions.WeightedRandom(medicine_stock))
		table.insert(stock, GeneralFunctions.WeightedRandom(medicine_stock))
		table.insert(stock, GeneralFunctions.WeightedRandom(medicine_stock))
		table.insert(stock, GeneralFunctions.WeightedRandom(medicine_stock))
	end

	if not generate_random_item then
		--set stock to randomized assortment and flag that the stock was refreshed for the day
		SV.DailyFlags.GreenKecleonRefreshedStock = true
		SV.DailyFlags.GreenKecleonStock = stock
	else
		return stock[math.random(1, #stock)]
	end

end

function metano_town.GeneratePurpleKecleonStock(generate_random_item)
	--generate random stock of items for green kec. Items generated are based on story progression (better items will crop up later in the story)
	--Start with predefined list of weighted items, then generate a stock of several items from those lists
	--Stocks are separated based on category (food, medicine, hold item, etc).
	--Kec stock isn't totally random, it pulls a gauranteed number from each stock  (i.e. always 1 hold item a day, but which it is is random)

	local stock = {}

	--This parameter determines whether to generate a random item or to actually refresh the stock.
	--The parameter should be true if we want to generate and return a single kec item (useful for red merchant)
	--This is a bit of a lazy/poor way of doing it, but it should work fine for how often it's used.
	if generate_random_item == nil then generate_random_item = false end


	--TODO: Add more types of stock progressions later on
	--Basic Stock, early game

	--total weight =
	--mostly meh TMs for early game
	local tm_stock = {
		{"tm_secret_power", 10},--secret power
		{"tm_embargo", 10},--embargo
		{"tm_echoed_voice", 10},--echoed voice
		{"tm_protect", 5},--protect
		{"tm_roar", 10},--roar
		{"tm_swagger", 10},--swagger
		{"tm_facade", 10}, --facade
		{"tm_payback", 10}, --payback
		{"tm_dig", 2}, --dig
		{"tm_safeguard", 10},--safeguard
		{"tm_venoshock", 5}, --venoshock
		{"tm_work_up", 5},--workup
		{"tm_thunder_wave", 5}, --thunder wave
		{"tm_return", 5},--return
		{"tm_pluck", 5},--pluck
		{"tm_frustration", 5},--frustration
		{"tm_thief", 10},--thief
		{"tm_water_pulse", 2},--water pulse
		{"tm_shock_wave", 2},--shock wave
		{"tm_incinerate", 2},--incinerate
		{"tm_rock_tomb", 4},--rock tomb
		{"tm_attract", 10},--attract
		{"tm_hidden_power", 8},--hidden power
		{"tm_taunt", 10},--taunt
		{"tm_grass_knot", 4},--grass knot
		{"tm_brick_break", 2},--brick break
		{"tm_rest", 5},--rest
	}

	--total weight =
	local wand_stock = {
		{"wand_path", 10},--path wand
		{"wand_pounce", 10},--pounce wand
		{"wand_whirlwind", 10},--whirlwind wand
		{"wand_switcher", 10},--switcher wand
		{"wand_lure", 10},--lure wand
		{"wand_slow", 10},--slow wand
		{"wand_fear", 10},--fear wand
		{"wand_topsy_turvy", 5},--topsy turvy wand
		{"wand_warp", 5},--warp wand
		{"wand_purge", 5},--purge wand
		{"wand_lob", 10}, --lob wand
		{"wand_totter", 10} --totter wand
	}


	local orb_stock =
	{
		{"orb_escape", 50},--escape orb
		{"orb_cleanse", 10},--cleanse orb

		{"orb_petrify", 10},--petrify orb
		{"orb_slumber", 10},--slumber orb
		{"orb_totter", 10},--totter orb
		{"orb_scanner", 10},--scanner orb
		{"orb_luminous", 10},--luminous orb
		{"orb_spurn", 10},--spurn orb
		{"orb_foe_hold", 10},--foe hold orb
		{"orb_foe_seal", 10},--foe seal orb
		{"orb_rollcall", 15},--rollcall orb
		{"orb_trawl", 5}, --trawl orb
		{"orb_all_aim", 10},--all aim orb
		{"orb_slow", 10},--slow orb
		{"orb_invert", 5}, --invert orb
		{"orb_fill_in", 5} --fill in orb
	}


	table.insert(stock, GeneralFunctions.WeightedRandom(tm_stock))
	table.insert(stock, GeneralFunctions.WeightedRandom(orb_stock))
	table.insert(stock, GeneralFunctions.WeightedRandom(orb_stock))
	table.insert(stock, GeneralFunctions.WeightedRandom(orb_stock))
	table.insert(stock, GeneralFunctions.WeightedRandom(wand_stock))
	table.insert(stock, GeneralFunctions.WeightedRandom(wand_stock))



	if not generate_random_item then
		--set stock to randomized assortment and flag that the stock was refreshed for the day
		SV.DailyFlags.PurpleKecleonRefreshedStock = true
		SV.DailyFlags.PurpleKecleonStock = stock
	else
		return stock[math.random(1, #stock)]
	end

end

function metano_town.Shop_Action(obj, activator)
  --LA VILLE PARLE DE LA NUIT. Si un raid a eu lieu, ce commercant en
  --dit un mot AVANT d'ouvrir boutique. Une seule fois par journee, et
  --rend la main aussitot : aucun dialogue existant n'est perdu.
  if TownVoicesNight.Talk('Shop_Owner') then return end
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine

  --ETALS PILLES. Si les rodeurs ont vide la boutique cette nuit, le
  --marchand le DIT au lieu d'ouvrir un catalogue vide : un menu sans
  --article passerait pour un bug d'affichage. Voir TownPlunder.lua.
  if TownPlunder.ShopExcuse() then return end

  local state = 0
  local repeated = false
  local cart = {}
  local catalog = { }

  --generate stock if it hasn't been for the day
  if not SV.DailyFlags.GreenKecleonRefreshedStock then
	metano_town.GenerateGreenKecleonStock()
  end

  --populate the catalog of items to buy using the generated stock. Item and hidden (amount of items in the stack typically) are grabbed from the item's predefined values in the item editor
  for ii = 1, #SV.DailyFlags.GreenKecleonStock, 1 do
  	local itemEntry = RogueEssence.Data.DataManager.Instance:GetItem(SV.DailyFlags.GreenKecleonStock[ii])
	local item = RogueEssence.Dungeon.InvItem(SV.DailyFlags.GreenKecleonStock[ii], false, itemEntry.MaxStack)

	--item price is 5 times the sell value.
	local item_data = { Item = item, Price = item:GetSellValue() * 5 }
	table.insert(catalog, item_data)
  end


  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local chara = CH('Shop_Owner')
  chara.IsInteracting = true
  partner.IsInteracting = true
  UI:SetSpeaker(chara)

  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  --put kec in first frame of walk to simulate explorers behavior
  GROUND:CharSetAction(chara, RogueEssence.Ground.FrameGroundAction(chara.Position, chara.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Walk"), 0))

  GROUND:CharTurnToChar(hero, chara)
  local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)


	while state > -1 do
		if state == 0 then
			local msg = STRINGS:Format(STRINGS.MapStrings['Shop_Intro'])
			if repeated then
				msg = STRINGS:Format(STRINGS.MapStrings['Shop_Intro_Return'])
			end
			local shop_choices = {STRINGS:Format(STRINGS.MapStrings['Shop_Option_Buy']), STRINGS:Format(STRINGS.MapStrings['Shop_Option_Sell']),
			STRINGS:FormatKey("MENU_INFO"),
			STRINGS:FormatKey("MENU_EXIT")}
			UI:BeginChoiceMenu(msg, shop_choices, 1, 4)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			repeated = true
			if result == 1 then
				if #catalog > 0 then
					--TODO: use the enum instead of a hardcoded number
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Buy'], STRINGS:LocalKeyString(26)))
					state = 1
				else
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Buy_Empty']))
				end
			elseif result == 2 then
				local bag_count = GAME:GetPlayerBagCount()
				if bag_count > 0 then
					--TODO: use the enum instead of a hardcoded number
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Sell'], STRINGS:LocalKeyString(26)))
					state = 3
				else
					GeneralFunctions.SetEmotion("Angry")
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Bag_Empty']))
					GeneralFunctions.SetEmotion("Normal")
				end
			elseif result == 3 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Info_001']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Info_002']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Info_003']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Info_004']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Info_005']))
			else
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Goodbye']))
				state = -1
			end
		elseif state == 1 then
			UI:ShopMenu(catalog)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if #result > 0 then
				local bag_count = GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount()
				local bag_cap = GAME:GetPlayerBagLimit()
				if bag_count == bag_cap then
					GeneralFunctions.SetEmotion("Angry")
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Bag_Full']))
					GeneralFunctions.SetEmotion("Normal")
				else
					cart = result
					state = 2
				end
			else
				state = 0
			end
		elseif state == 2 then
			local total = 0
			for ii = 1, #cart, 1 do
				total = total + catalog[cart[ii]].Price
			end
			local msg
			if total > GAME:GetPlayerMoney() then
				GeneralFunctions.SetEmotion("Angry")
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Buy_No_Money']))
				GeneralFunctions.SetEmotion("Normal")
				state = 1
			else
				if #cart == 1 then
					local name = catalog[cart[1]].Item:GetDisplayName()
					msg = STRINGS:Format(STRINGS.MapStrings['Shop_Buy_One'], total, name)
				else
					msg = STRINGS:Format(STRINGS.MapStrings['Shop_Buy_Multi'], total)
				end
				UI:ChoiceMenuYesNo(msg, false)
				UI:WaitForChoice()
				result = UI:ChoiceResult()

				if result then
					GAME:RemoveFromPlayerMoney(total)
					for ii = 1, #cart, 1 do
						local item = catalog[cart[ii]].Item
						GAME:GivePlayerItem(item.ID, item.Amount)
					end
					for ii = #cart, 1, -1 do
						table.remove(catalog, cart[ii])
						table.remove(SV.DailyFlags.GreenKecleonStock, cart[ii])
					end

					cart = {}
					SOUND:PlayBattleSE("DUN_Money")
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Buy_Complete']))
					state = 0
				else
					state = 1
				end
			end
		elseif state == 3 then
			UI:SellMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()

			if #result > 0 then
				cart = result
				state = 4
			else
				state = 0
			end
		elseif state == 4 then
			local total = 0
			for ii = 1, #cart, 1 do
				local item
				if cart[ii].IsEquipped then
					item = GAME:GetPlayerEquippedItem(cart[ii].Slot)
				else
					item = GAME:GetPlayerBagItem(cart[ii].Slot)
				end
				total = total + item:GetSellValue()
			end
			local msg
			if #cart == 1 then
				local item
				if cart[1].IsEquipped then
					item = GAME:GetPlayerEquippedItem(cart[1].Slot)
				else
					item = GAME:GetPlayerBagItem(cart[1].Slot)
				end
				msg = STRINGS:Format(STRINGS.MapStrings['Shop_Sell_One'], total, item:GetDisplayName())
			else
				msg = STRINGS:Format(STRINGS.MapStrings['Shop_Sell_Multi'], total)
			end
			UI:ChoiceMenuYesNo(msg, false)
			UI:WaitForChoice()
			result = UI:ChoiceResult()

			if result then
				for ii = #cart, 1, -1 do
					if cart[ii].IsEquipped then
						GAME:TakePlayerEquippedItem(cart[ii].Slot, true)
					else
						GAME:TakePlayerBagItem(cart[ii].Slot, true)
					end
				end
				SOUND:PlayBattleSE("DUN_Money")
				GAME:AddToPlayerMoney(total)
				cart = {}
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Sell_Complete']))
				state = 0
			else
				state = 3
			end
		end
	end
	TASK:JoinCoroutines({coro1})
	partner.IsInteracting = false
	chara.IsInteracting = false

	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(chara)
end





function metano_town.TM_Action(obj, activator)
  --LA VILLE PARLE DE LA NUIT. Si un raid a eu lieu, ce commercant en
  --dit un mot AVANT d'ouvrir boutique. Une seule fois par journee, et
  --rend la main aussitot : aucun dialogue existant n'est perdu.
  if TownVoicesNight.Talk('TM_Owner') then return end
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine

  local state = 0
  local repeated = false
  local cart = {}
  local catalog = { }

  --generate stock if it hasn't been for the day
  if not SV.DailyFlags.PurpleKecleonRefreshedStock then
	metano_town.GeneratePurpleKecleonStock()
  end

  --populate the catalog of items to buy using the generated stock. Item and hidden (amount of items in the stack typically) are grabbed from the item's predefined values in the item editor
  for ii = 1, #SV.DailyFlags.PurpleKecleonStock, 1 do
  	local itemEntry = RogueEssence.Data.DataManager.Instance:GetItem(SV.DailyFlags.PurpleKecleonStock[ii])
	local item = RogueEssence.Dungeon.InvItem(SV.DailyFlags.PurpleKecleonStock[ii], false, math.min(4, itemEntry.MaxStack))--only give 4 wands.

	--item price is 5 times the sell value.
	local item_data = { Item = item, Price = item:GetSellValue() * 5 }
	table.insert(catalog, item_data)
  end


  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local chara = CH('TM_Owner')
  chara.IsInteracting = true
  partner.IsInteracting = true
  UI:SetSpeaker(chara)

  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  --put kec in first frame of walk to simulate explorers behavior
  GROUND:CharSetAction(chara, RogueEssence.Ground.FrameGroundAction(chara.Position, chara.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Walk"), 0))

  GROUND:CharTurnToChar(hero, chara)
  local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)


	while state > -1 do
		if state == 0 then
			local msg = STRINGS:Format(STRINGS.MapStrings['TM_Shop_Intro'])
			if repeated then
				msg = STRINGS:Format(STRINGS.MapStrings['TM_Shop_Intro_Return'])
			end
			local TM_Shop_choices = {STRINGS:Format(STRINGS.MapStrings['TM_Shop_Option_Buy']), STRINGS:Format(STRINGS.MapStrings['TM_Shop_Option_Sell']),
			STRINGS:FormatKey("MENU_INFO"),
			STRINGS:FormatKey("MENU_EXIT")}
			UI:BeginChoiceMenu(msg, TM_Shop_choices, 1, 4)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			repeated = true
			if result == 1 then
				if #catalog > 0 then
					--TODO: use the enum instead of a hardcoded number
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TM_Shop_Buy'], STRINGS:LocalKeyString(26)))
					state = 1
				else
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TM_Shop_Buy_Empty']))
				end
			elseif result == 2 then
				local bag_count = GAME:GetPlayerBagCount()
				if bag_count > 0 then
					--TODO: use the enum instead of a hardcoded number
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TM_Shop_Sell'], STRINGS:LocalKeyString(26)))
					state = 3
				else
					GeneralFunctions.SetEmotion("Angry")
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TM_Shop_Bag_Empty']))
					GeneralFunctions.SetEmotion("Normal")
				end
			elseif result == 3 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TM_Shop_Info_001']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TM_Shop_Info_002']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TM_Shop_Info_003']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TM_Shop_Info_004']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TM_Shop_Info_005']))
			else
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TM_Shop_Goodbye']))
				state = -1
			end
		elseif state == 1 then
			UI:ShopMenu(catalog)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if #result > 0 then
				local bag_count = GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount()
				local bag_cap = GAME:GetPlayerBagLimit()
				if bag_count == bag_cap then
					GeneralFunctions.SetEmotion("Angry")
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TM_Shop_Bag_Full']))
					GeneralFunctions.SetEmotion("Normal")
				else
					cart = result
					state = 2
				end
			else
				state = 0
			end
		elseif state == 2 then
			local total = 0
			for ii = 1, #cart, 1 do
				total = total + catalog[cart[ii]].Price
			end
			local msg
			if total > GAME:GetPlayerMoney() then
				GeneralFunctions.SetEmotion("Angry")
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TM_Shop_Buy_No_Money']))
				GeneralFunctions.SetEmotion("Normal")
				state = 1
			else
				if #cart == 1 then
					local name = catalog[cart[1]].Item:GetDisplayName()
					msg = STRINGS:Format(STRINGS.MapStrings['TM_Shop_Buy_One'], total, name)
				else
					msg = STRINGS:Format(STRINGS.MapStrings['TM_Shop_Buy_Multi'], total)
				end
				UI:ChoiceMenuYesNo(msg, false)
				UI:WaitForChoice()
				result = UI:ChoiceResult()

				if result then
					GAME:RemoveFromPlayerMoney(total)
					for ii = 1, #cart, 1 do
						local item = catalog[cart[ii]].Item
						GAME:GivePlayerItem(item.ID, item.Amount)
					end
					for ii = #cart, 1, -1 do
						table.remove(catalog, cart[ii])
						table.remove(SV.DailyFlags.PurpleKecleonStock, cart[ii])
					end

					cart = {}
					SOUND:PlayBattleSE("DUN_Money")
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TM_Shop_Buy_Complete']))
					state = 0
				else
					state = 1
				end
			end
		elseif state == 3 then
			UI:SellMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()

			if #result > 0 then
				cart = result
				state = 4
			else
				state = 0
			end
		elseif state == 4 then
			local total = 0
			for ii = 1, #cart, 1 do
				local item
				if cart[ii].IsEquipped then
					item = GAME:GetPlayerEquippedItem(cart[ii].Slot)
				else
					item = GAME:GetPlayerBagItem(cart[ii].Slot)
				end
				total = total + item:GetSellValue()
			end
			local msg
			if #cart == 1 then
				local item
				if cart[1].IsEquipped then
					item = GAME:GetPlayerEquippedItem(cart[1].Slot)
				else
					item = GAME:GetPlayerBagItem(cart[1].Slot)
				end
				msg = STRINGS:Format(STRINGS.MapStrings['TM_Shop_Sell_One'], total, item:GetDisplayName())
			else
				msg = STRINGS:Format(STRINGS.MapStrings['TM_Shop_Sell_Multi'], total)
			end
			UI:ChoiceMenuYesNo(msg, false)
			UI:WaitForChoice()
			result = UI:ChoiceResult()

			if result then
				for ii = #cart, 1, -1 do
					if cart[ii].IsEquipped then
						GAME:TakePlayerEquippedItem(cart[ii].Slot, true)
					else
						GAME:TakePlayerBagItem(cart[ii].Slot, true)
					end
				end
				SOUND:PlayBattleSE("DUN_Money")
				GAME:AddToPlayerMoney(total)
				cart = {}
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TM_Shop_Sell_Complete']))
				state = 0
			else
				state = 3
			end
		end
	end

	--reimplementing parts of endconversation
	TASK:JoinCoroutines({coro1})
	partner.IsInteracting = false
	chara.IsInteracting = false

	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(chara)
end






--todo: Tidy this up at some point?
function metano_town.Musician_Action(obj, activator)
  --LA VILLE PARLE DE LA NUIT. Si un raid a eu lieu, ce commercant en
  --dit un mot AVANT d'ouvrir boutique. Une seule fois par journee, et
  --rend la main aussitot : aucun dialogue existant n'est perdu.
  if TownVoicesNight.Talk('Musician') then return end
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  local chara = CH('Musician')
  local old_song = SOUND:GetCurrentSong()
  local default_song = 'Treasure Town.ogg'--default song
  UI:SetSpeaker(chara)


  --keep playing the metronome animation if it's playing (song is not treasure town)
  if SOUND:GetCurrentSong() == default_song or SOUND:GetCurrentSong() == '' then
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['Music_Intro']), 'Normal', false)
  else
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['Music_Intro']), 'Normal', false, false)
  end


  --Figure out list of songs to not display in music menu.
  --For now, simply block Anima Core from showing up if the player hasn't gotten to the Anima Core cutscene yet.
  local spoilers = {}

  if not SV.Chapter3.FinishedRootScene then
    table.insert(spoilers, 'Anima Core.ogg')
  end

  UI:ShowMusicMenu(false, spoilers)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result ~= nil then
	SV.metano_town.Song = result
  end


  --Set a metronome animation if we're playing a song that isn't the default or no music. Otherise turn it off.
  if (SOUND:GetCurrentSong() == default_song or SOUND:GetCurrentSong() == '') and (old_song == default_song or old_song == '') then
  	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Music_End']))
	GeneralFunctions.EndConversation(chara)
  elseif (SOUND:GetCurrentSong() == default_song or SOUND:GetCurrentSong() == '') and (old_song ~= default_song and old_song ~= '') then
	GROUND:CharSetAnim(chara, "None", true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Music_End']))
	GeneralFunctions.EndConversation(chara)
  elseif (SOUND:GetCurrentSong() ~= default_song and SOUND:GetCurrentSong() ~= '') and (old_song == default_song or old_song == '') then
  	GROUND:CharSetAnim(chara, "Wiggle", true)
  	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Music_End']))
	GeneralFunctions.EndConversation(chara, false)
  else
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Music_End']))
	GeneralFunctions.EndConversation(chara, false)
  end
end




function metano_town.Storage_Action(obj, activator)
  --LA VILLE PARLE DE LA NUIT. Si un raid a eu lieu, ce commercant en
  --dit un mot AVANT d'ouvrir boutique. Une seule fois par journee, et
  --rend la main aussitot : aucun dialogue existant n'est perdu.
  if TownVoicesNight.Talk('Storage_Owner') then return end
	DEBUG.EnableDbgCoro()

	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local chara = CH('Storage_Owner')
	chara.IsInteracting = true
	partner.IsInteracting = true
	UI:SetSpeaker(chara)
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(chara, 'None', true)

	GROUND:CharTurnToChar(hero, chara)
	local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
	GeneralFunctions.SetEmotion('Happy')

	local state = 0
	local repeated = false

	while state > -1 do
		local has_items = GAME:GetPlayerBagCount() > 0
		local has_equipment = GAME:GetPlayerEquippedCount() > 0
		local has_storage = GAME:GetPlayerStorageCount() > 0

		local item_count = GAME:GetPlayerBagCount()

		local storage_choices = { { STRINGS:FormatKey('MENU_STORAGE_STORE'), has_items or has_equipment},
		{ STRINGS:FormatKey('MENU_STORAGE_TAKE_ITEM'), has_storage},
		{ STRINGS:FormatKey('MENU_STORAGE_STORE_ALL'), has_items},
		{ STRINGS:FormatKey('MENU_INFO'), true},
		{ STRINGS:FormatKey("MENU_CANCEL"), true}}

		local msg = STRINGS:Format(STRINGS.MapStrings['Storage_Intro'])
		if repeated then
			msg = STRINGS:Format(STRINGS.MapStrings['Storage_Intro_Return'])
			GeneralFunctions.SetEmotion('Normal')
		end

		UI:BeginChoiceMenu(msg, storage_choices, 1, 5)
		UI:WaitForChoice()
		local result = UI:ChoiceResult()
		GeneralFunctions.SetEmotion('Normal')


		if result == 1 then
			repeated = true
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Storage_Store'], STRINGS:LocalKeyString(26)))
			UI:StorageMenu()
			UI:WaitForChoice()
			if item_count ~= GAME:GetPlayerBagCount() then
				GeneralFunctions.SetEmotion('Happy')
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Storage_Stored_Items']))
			end
		elseif result == 2 then
			repeated = true
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Storage_Withdraw'], STRINGS:LocalKeyString(26)))
			UI:WithdrawMenu()
			UI:WaitForChoice()
			if item_count ~= GAME:GetPlayerBagCount() then
				GeneralFunctions.SetEmotion('Happy')
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Storage_Withdrew_Items']))
			end
		elseif result == 3 then
			repeated = true
			GeneralFunctions.SendInvToStorage(true, false, true)
			GeneralFunctions.SetEmotion('Happy')
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Storage_Stored_All_Items']))
		elseif result == 4 then
			repeated = true
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Storage_Info_1']))
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Storage_Info_2']))
			GeneralFunctions.SetEmotion('Happy')
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Storage_Info_3']))
			GeneralFunctions.SetEmotion('Normal')
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Storage_Info_4']))
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Storage_Info_5']))
		else
			GeneralFunctions.SetEmotion('Happy')
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Storage_Goodbye']))
			state = -1
		end
	end
	--reimplementing parts of endconversation
	TASK:JoinCoroutines({coro1})
	partner.IsInteracting = false
	chara.IsInteracting = false

	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(chara)
end












function metano_town.Bank_Action(obj, activator)
  --LA VILLE PARLE DE LA NUIT. Si un raid a eu lieu, ce commercant en
  --dit un mot AVANT d'ouvrir boutique. Une seule fois par journee, et
  --rend la main aussitot : aucun dialogue existant n'est perdu.
  if TownVoicesNight.Talk('Bank_Owner') then return end
	DEBUG.EnableDbgCoro()

    local hero = CH('PLAYER')
    local partner = CH('Teammate1')
    local chara = CH('Bank_Owner')
    chara.IsInteracting = true
    partner.IsInteracting = true
    UI:SetSpeaker(chara)
    GROUND:CharSetAnim(partner, 'None', true)
    GROUND:CharSetAnim(hero, 'None', true)
    GROUND:CharSetAnim(chara, 'None', true)

    GROUND:CharTurnToChar(hero, chara)
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)

	local state = 0
	local repeated = false

	while state > -1 do

		local player_money = GAME:GetPlayerMoney()
		local bank_choices = { { STRINGS:FormatKey('MENU_STORAGE_MONEY'), true},
		{ STRINGS:FormatKey('MENU_INFO'), true},
		{ STRINGS:FormatKey("MENU_CANCEL"), true}}

		local msg = STRINGS:Format(STRINGS.MapStrings['Bank_Intro'], GAME:GetPlayerMoneyBank())
		if repeated then msg = STRINGS:Format(STRINGS.MapStrings['Bank_Intro_Return']) end

		UI:BeginChoiceMenu(msg, bank_choices, 1, 3)
		UI:WaitForChoice()
		local result = UI:ChoiceResult()

		if result == 1 then
			repeated = true
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Bank_Interact']))
			UI:BankMenu()
			UI:WaitForChoice()
			local difference = math.abs(player_money - GAME:GetPlayerMoney())
			if player_money > GAME:GetPlayerMoney() then --deposited money
				GeneralFunctions.SetEmotion('Inspired')
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Bank_Stored_Money'], difference))
			elseif player_money < GAME:GetPlayerMoney() then --Withdrew money
				GeneralFunctions.SetEmotion('Sad')
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Bank_Withdrew_Money'], difference))
			else
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Bank_Canceled']))
			end
			GeneralFunctions.SetEmotion('Normal')
		elseif result == 2 then
			repeated = true
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Bank_Info_1']))
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Bank_Info_2']))
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Bank_Info_3']))
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Bank_Info_4']))
		else
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Bank_Goodbye']))
			state = -1
		end
	end
	--reimplementing parts of endconversation
	TASK:JoinCoroutines({coro1})
	partner.IsInteracting = false
	chara.IsInteracting = false

	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(chara)
end

function metano_town.GenerateRedMerchantItem()
	if math.random(1,2) == 1 then
		return metano_town.GenerateGreenKecleonStock(true)
	else
		return metano_town.GeneratePurpleKecleonStock(true)
	end
end

function metano_town.Red_Merchant_Action(obj, activator)
  --LA VILLE PARLE DE LA NUIT. Si un raid a eu lieu, ce commercant en
  --dit un mot AVANT d'ouvrir boutique. Une seule fois par journee, et
  --rend la main aussitot : aucun dialogue existant n'est perdu.
  if TownVoicesNight.Talk('Red_Merchant') then return end
	DEBUG.EnableDbgCoro()
	local state = 0
	local repeated = false



	--Generate an item for the red merchant
	if SV.DailyFlags.RedMerchantItem == "" then
		SV.DailyFlags.RedMerchantItem = metano_town.GenerateRedMerchantItem()
	end

	local chara = CH('Red_Merchant')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	local farfetchd_name = CharacterEssentials.GetCharacterName("Farfetchd")
	local stunky_name = chara:GetDisplayName()

	local item = RogueEssence.Dungeon.InvItem(SV.DailyFlags.RedMerchantItem)
	local itemEntry = RogueEssence.Data.DataManager.Instance:GetItem(item.ID)
	item.Amount = itemEntry.MaxStack
	local itemName = item:GetDisplayName()
	local itemPrice = item:GetSellValue() --Item is 1/5 the normal price!

	local merchant_choices = {STRINGS:Format(STRINGS.MapStrings['Merchant_Option_Deal']), STRINGS:FormatKey('MENU_INFO'), STRINGS:FormatKey('MENU_EXIT')}
	UI:SetSpeaker(chara)
	local olddir = chara.Direction
	chara.IsInteracting = true
    partner.IsInteracting = true
    UI:SetSpeaker(chara)
    GROUND:CharSetAnim(partner, 'None', true)
    GROUND:CharSetAnim(hero, 'None', true)
    GROUND:CharSetAnim(chara, 'None', true)

    GROUND:CharTurnToChar(hero, chara)
	GROUND:CharTurnToChar(chara, hero)
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)


	while state > -1 do
		--merchant is angry and refuses to sell to you if you bought from the green merchant
		local angry = SV.DailyFlags.GreenMerchantBought
		--merchant is happy if you've bought from him, he can't sell you anything else though.
		local happy = SV.DailyFlags.RedMerchantBought

		GeneralFunctions.SetEmotion('Normal')
		local msg = STRINGS:Format(STRINGS.MapStrings['Red_Merchant_Intro'], stunky_name)


		if repeated then
			if happy then
				msg = STRINGS:Format(STRINGS.MapStrings['Red_Merchant_Intro_Return_Happy'])
				GeneralFunctions.SetEmotion('Happy')
			elseif angry then
				state = -1 --he won't loop back to the menu if he's angry, he's just done with you
				break
			else
				msg = STRINGS:Format(STRINGS.MapStrings['Red_Merchant_Intro_Return'])
			end
		elseif happy then
			GeneralFunctions.SetEmotion('Happy')
			msg = STRINGS:Format(STRINGS.MapStrings['Red_Merchant_Intro_Happy'], stunky_name)
		elseif angry then
			GeneralFunctions.SetEmotion('Determined')
			msg = STRINGS:Format(STRINGS.MapStrings['Red_Merchant_Intro_Angry'])
		end

		UI:BeginChoiceMenu(msg, merchant_choices, 1, 3)
		UI:WaitForChoice()
		local result = UI:ChoiceResult()
		repeated = true
		if result == 1 then
			if happy then
				GeneralFunctions.SetEmotion('Worried')
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Red_Merchant_No_Stock']))
			elseif angry then
				GeneralFunctions.SetEmotion('Angry')
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Red_Merchant_Refuse_Service'], farfetchd_name))
			else
				--UI:ChoiceMenuYesNo(STRINGS:Format(STRINGS.MapStrings['Red_Merchant_Daily_Item'], itemName, itemPrice, GeneralFunctions.GetItemArticle(item)))	--deprecated
				local SingleItemDealMenu = SingleItemDealMenu()
				local menu = SingleItemDealMenu:new(stunky_name.."'s Deal", item, itemPrice)
				UI:SetCustomMenu(menu.menu)
				UI:WaitForChoice()
				if menu.result then
					if itemPrice > GAME:GetPlayerMoney() then --With the new SingleItemDealMenu, this won't get hit anymore, but keep it anyway cause why not.
						GeneralFunctions.SetEmotion('Worried')
						UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Red_Merchant_No_Money']))
					elseif GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount() >= GAME:GetPlayerBagLimit() then
						GeneralFunctions.SetEmotion('Worried')
						UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Red_Merchant_Bag_Full']))
					else
						SV.DailyFlags.RedMerchantBought = true
						GAME:RemoveFromPlayerMoney(itemPrice)
						GAME:GivePlayerItem(item.ID, itemEntry.MaxStack)
						SOUND:PlayBattleSE("DUN_Money")
						GeneralFunctions.SetEmotion("Joyous")
						UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Red_Merchant_Purchase_Made'], itemName))
					end
				end
			end
		elseif result == 2 then
			if angry then
				GeneralFunctions.SetEmotion('Angry')
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Red_Merchant_Info_Angry'], farfetchd_name))
			elseif happy then
				GeneralFunctions.SetEmotion('Normal')
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Red_Merchant_Info_Happy_1']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Red_Merchant_Info_Happy_2']))
				GeneralFunctions.SetEmotion('Sad')
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Red_Merchant_Info_Happy_3']))
				GeneralFunctions.SetEmotion('Inspired')
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Red_Merchant_Info_Happy_4'], farfetchd_name))
				GeneralFunctions.SetEmotion('Normal')
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Red_Merchant_Info_Happy_5']))
			else
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Red_Merchant_Info_1'], stunky_name))
				GeneralFunctions.SetEmotion('Sad')
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Red_Merchant_Info_2']))
				GeneralFunctions.SetEmotion('Normal')
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Red_Merchant_Info_3']))
				GeneralFunctions.SetEmotion('Determined')
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Red_Merchant_Info_4'], farfetchd_name))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Red_Merchant_Info_5']))
				GeneralFunctions.SetEmotion('Normal')
			end
		else
			if angry then
				GeneralFunctions.SetEmotion('Determined')
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Red_Merchant_Goodbye_Angry']))
			elseif happy then
				GeneralFunctions.SetEmotion('Happy')
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Red_Merchant_Goodbye_Happy']))
			else
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Red_Merchant_Goodbye']))
			end
			state = -1
		end
	end

	--reimplementing parts of endconversation
	TASK:JoinCoroutines({coro1})
	partner.IsInteracting = false
	chara.IsInteracting = false

	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(chara)
	GROUND:EntTurn(chara, olddir)


end

function metano_town.GenerateGreenMerchantItem()

	--todo: More dynamic item stocking based on game progression
	local stock = {
		{"held_black_belt", 10},
		{"held_black_glasses", 10},
		{"held_charcoal", 10},
		{"held_dragon_scale", 10},
		{"held_hard_stone", 10},
		{"held_magnet", 10},
		{"held_metal_coat", 10},
		{"held_miracle_seed", 10},
		{"held_mystic_water", 10},
		{"held_never_melt_ice", 10},
		{"held_pink_bow", 10},
		{"held_poison_barb", 10},
		{"held_sharp_beak", 10},
		{"held_silk_scarf", 10},
		{"held_silver_powder", 10},
		{"held_soft_sand", 10},
		{"held_spell_tag", 10},
		{"held_twisted_spoon", 10},

		--these are renamed as Guards externally
		{"held_blank_plate", 10},
		{"held_draco_plate", 10},
		{"held_dread_plate", 10},
		{"held_earth_plate", 10},
		{"held_fist_plate", 10},
		{"held_flame_plate", 10},
		{"held_icicle_plate", 10},
		{"held_insect_plate", 10},
		{"held_iron_plate", 10},
		{"held_meadow_plate", 10},
		{"held_mind_plate", 10},
		{"held_pixie_plate", 10},
		{"held_sky_plate", 10},
		{"held_splash_plate", 10},
		{"held_spooky_plate", 10},
		{"held_stone_plate", 10},
		{"held_toxic_plate", 10},
		{"held_zap_plate", 10},

		{"held_flame_orb", 10},
		{"held_toxic_orb", 10}
	}

	return GeneralFunctions.WeightedRandom(stock)
end


function metano_town.Green_Merchant_Action(obj, activator)
  --LA VILLE PARLE DE LA NUIT. Si un raid a eu lieu, ce commercant en
  --dit un mot AVANT d'ouvrir boutique. Une seule fois par journee, et
  --rend la main aussitot : aucun dialogue existant n'est perdu.
  if TownVoicesNight.Talk('Green_Merchant') then return end
	DEBUG.EnableDbgCoro()
	local state = 0
	local repeated = false



	if SV.DailyFlags.GreenMerchantItem == "" then
		SV.DailyFlags.GreenMerchantItem = metano_town.GenerateGreenMerchantItem()
	end

	local chara = CH('Green_Merchant')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	local farfetchd_name = chara:GetDisplayName()
	local stunky_name = CharacterEssentials.GetCharacterName("Stunky")

	local item = RogueEssence.Dungeon.InvItem(SV.DailyFlags.GreenMerchantItem)
	local itemEntry = RogueEssence.Data.DataManager.Instance:GetItem(item.ID)
	item.Amount = itemEntry.MaxStack
	local itemName = item:GetDisplayName()
	local itemPrice = item:GetSellValue() * 5 --5x the sell price, like the kecs
	local merchant_choices = {STRINGS:Format(STRINGS.MapStrings['Merchant_Option_Deal']), STRINGS:FormatKey('MENU_INFO'), STRINGS:FormatKey('MENU_EXIT')}
	UI:SetSpeaker(chara)
	chara.IsInteracting = true
    partner.IsInteracting = true
    UI:SetSpeaker(chara)
	local olddir = chara.Direction
    GROUND:CharSetAnim(partner, 'None', true)
    GROUND:CharSetAnim(hero, 'None', true)
    GROUND:CharSetAnim(chara, 'None', true)

    GROUND:CharTurnToChar(hero, chara)
    GROUND:CharTurnToChar(chara, hero)
	local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)

	while state > -1 do
		--merchant is angry and refuses to sell to you if you bought from the red merchant
		local angry = SV.DailyFlags.RedMerchantBought
		--merchant is happy if you've bought from him, he can't sell you anything else though.
		local happy = SV.DailyFlags.GreenMerchantBought

		GeneralFunctions.SetEmotion('Normal')
		local msg = STRINGS:Format(STRINGS.MapStrings['Green_Merchant_Intro'], farfetchd_name)


		if repeated then
			if happy then
				msg = STRINGS:Format(STRINGS.MapStrings['Green_Merchant_Intro_Return_Happy'])
				GeneralFunctions.SetEmotion('Happy')
			elseif angry then
				state = -1 --he won't loop back to the menu if he's angry, he's just done with you
				break
			else
				msg = STRINGS:Format(STRINGS.MapStrings['Green_Merchant_Intro_Return'])
			end
		elseif happy then
			GeneralFunctions.SetEmotion('Happy')
			msg = STRINGS:Format(STRINGS.MapStrings['Green_Merchant_Intro_Happy'], farfetchd_name)
		elseif angry then
			GeneralFunctions.SetEmotion('Determined')
			msg = STRINGS:Format(STRINGS.MapStrings['Green_Merchant_Intro_Angry'])
		end

		UI:BeginChoiceMenu(msg, merchant_choices, 1, 3)
		UI:WaitForChoice()
		local result = UI:ChoiceResult()
		repeated = true
		if result == 1 then
			if happy then
				GeneralFunctions.SetEmotion('Worried')
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Green_Merchant_No_Stock']))
			elseif angry then
				GeneralFunctions.SetEmotion('Angry')
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Green_Merchant_Refuse_Service']))
			else
				--UI:ChoiceMenuYesNo(STRINGS:Format(STRINGS.MapStrings['Green_Merchant_Daily_Item'], itemName, itemPrice, GeneralFunctions.GetItemArticle(item))) -- deprecated
				local SingleItemDealMenu = SingleItemDealMenu()
				local menu = SingleItemDealMenu:new(farfetchd_name.."'s Deal", item, itemPrice)
				UI:SetCustomMenu(menu.menu)
				UI:WaitForChoice()
				if menu.result then
					if itemPrice > GAME:GetPlayerMoney() then --With the new SingleItemDealMenu, this won't get hit anymore, but keep it anyway cause why not.
						GeneralFunctions.SetEmotion('Worried')
						UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Green_Merchant_No_Money']))
					elseif GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount() >= GAME:GetPlayerBagLimit() then
						GeneralFunctions.SetEmotion('Worried')
						UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Green_Merchant_Bag_Full']))
					else
						SV.DailyFlags.GreenMerchantBought = true
						GAME:RemoveFromPlayerMoney(itemPrice)
						GAME:GivePlayerItem(item.ID, itemEntry.MaxStack)
						SOUND:PlayBattleSE("DUN_Money")
						GeneralFunctions.SetEmotion("Happy")
						UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Green_Merchant_Purchase_Made'], itemName))
					end
				end
			end
		elseif result == 2 then
			if angry then
				GeneralFunctions.SetEmotion('Angry')
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Green_Merchant_Info_Angry'], stunky_name))
			elseif happy then
				GeneralFunctions.SetEmotion('Normal')
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Green_Merchant_Info_Happy_1']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Green_Merchant_Info_Happy_2']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Green_Merchant_Info_Happy_3']))
				GeneralFunctions.SetEmotion('Happy')
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Green_Merchant_Info_Happy_4']))
				GeneralFunctions.SetEmotion('Normal')
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Green_Merchant_Info_Happy_5']))
			else
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Green_Merchant_Info_1'], farfetchd_name))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Green_Merchant_Info_2']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Green_Merchant_Info_3']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Green_Merchant_Info_4'], stunky_name))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Green_Merchant_Info_5']))
			end
		else
			if angry then
				GeneralFunctions.SetEmotion('Determined')
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Green_Merchant_Goodbye_Angry']))
			elseif happy then
				GeneralFunctions.SetEmotion('Happy')
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Green_Merchant_Goodbye_Happy']))
			else
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Green_Merchant_Goodbye']))
			end
			state = -1
		end
	end

	--reimplementing parts of endconversation
	TASK:JoinCoroutines({coro1})
	partner.IsInteracting = false
	chara.IsInteracting = false

	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(chara)
	GROUND:EntTurn(chara, olddir)


end





function metano_town.Swap_Action(obj, activator)
  --LA VILLE PARLE DE LA NUIT. Si un raid a eu lieu, ce commercant en
  --dit un mot AVANT d'ouvrir boutique. Une seule fois par journee, et
  --rend la main aussitot : aucun dialogue existant n'est perdu.
  if TownVoicesNight.Talk('Swap_Owner') then return end
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine

  --silk/dust/gem/globes
  local catalog = {
	{ Item="xcl_element_bug_gem", ReqItem={"xcl_element_bug_silk","xcl_element_bug_dust"}},
	{ Item="xcl_element_bug_globe", ReqItem={"xcl_element_bug_silk", "xcl_element_bug_dust", "xcl_element_bug_gem"}},
	{ Item="xcl_element_dark_gem", ReqItem={"xcl_element_dark_silk","xcl_element_dark_dust"}},
	{ Item="xcl_element_dark_globe", ReqItem={"xcl_element_dark_silk", "xcl_element_dark_dust", "xcl_element_dark_gem"}},
	{ Item="xcl_element_dragon_gem", ReqItem={"xcl_element_dragon_silk","xcl_element_dragon_dust"}},
	{ Item="xcl_element_dragon_globe", ReqItem={"xcl_element_dragon_silk", "xcl_element_dragon_dust", "xcl_element_dragon_gem"}},
	{ Item="xcl_element_electric_gem", ReqItem={"xcl_element_electric_silk","xcl_element_electric_dust"}},
	{ Item="xcl_element_electric_globe", ReqItem={"xcl_element_electric_silk", "xcl_element_electric_dust", "xcl_element_electric_gem"}},
	{ Item="xcl_element_fairy_gem", ReqItem={"xcl_element_fairy_silk","xcl_element_fairy_dust"}},
	{ Item="xcl_element_fairy_globe", ReqItem={"xcl_element_fairy_silk", "xcl_element_fairy_dust", "xcl_element_fairy_gem"}},
	{ Item="xcl_element_fighting_gem", ReqItem={"xcl_element_fighting_silk","xcl_element_fighting_dust"}},
	{ Item="xcl_element_fighting_globe", ReqItem={"xcl_element_fighting_silk", "xcl_element_fighting_dust", "xcl_element_fighting_gem"}},
	{ Item="xcl_element_fire_gem", ReqItem={"xcl_element_fire_silk","xcl_element_fire_dust"}},
	{ Item="xcl_element_fire_globe", ReqItem={"xcl_element_fire_silk", "xcl_element_fire_dust", "xcl_element_fire_gem"}},
	{ Item="xcl_element_flying_gem", ReqItem={"xcl_element_flying_silk","xcl_element_flying_dust"}},
	{ Item="xcl_element_flying_globe", ReqItem={"xcl_element_flying_silk", "xcl_element_flying_dust", "xcl_element_flying_gem"}},
	{ Item="xcl_element_ghost_gem", ReqItem={"xcl_element_ghost_silk","xcl_element_ghost_dust"}},
	{ Item="xcl_element_ghost_globe", ReqItem={"xcl_element_ghost_silk", "xcl_element_ghost_dust", "xcl_element_ghost_gem"}},
	{ Item="xcl_element_grass_gem", ReqItem={"xcl_element_grass_silk","xcl_element_grass_dust"}},
	{ Item="xcl_element_grass_globe", ReqItem={"xcl_element_grass_silk", "xcl_element_grass_dust", "xcl_element_grass_gem"}},
	{ Item="xcl_element_ground_gem", ReqItem={"xcl_element_ground_silk","xcl_element_ground_dust"}},
	{ Item="xcl_element_ground_globe", ReqItem={"xcl_element_ground_silk", "xcl_element_ground_dust", "xcl_element_ground_gem"}},
	{ Item="xcl_element_ice_gem", ReqItem={"xcl_element_ice_silk","xcl_element_ice_dust"}},
	{ Item="xcl_element_ice_globe", ReqItem={"xcl_element_ice_silk", "xcl_element_ice_dust", "xcl_element_ice_gem"}},
	{ Item="xcl_element_normal_gem", ReqItem={"xcl_element_normal_silk","xcl_element_normal_dust"}},
	{ Item="xcl_element_normal_globe", ReqItem={"xcl_element_normal_silk", "xcl_element_normal_dust", "xcl_element_normal_gem"}},
	{ Item="xcl_element_poison_gem", ReqItem={"xcl_element_poison_silk","xcl_element_poison_dust"}},
	{ Item="xcl_element_poison_globe", ReqItem={"xcl_element_poison_silk", "xcl_element_poison_dust", "xcl_element_poison_gem"}},
	{ Item="xcl_element_psychic_gem", ReqItem={"xcl_element_psychic_silk","xcl_element_psychic_dust"}},
	{ Item="xcl_element_psychic_globe", ReqItem={"xcl_element_psychic_silk", "xcl_element_psychic_dust", "xcl_element_psychic_gem"}},
	{ Item="xcl_element_rock_gem", ReqItem={"xcl_element_rock_silk","xcl_element_rock_dust"}},
	{ Item="xcl_element_rock_globe", ReqItem={"xcl_element_rock_silk", "xcl_element_rock_dust", "xcl_element_rock_gem"}},
	{ Item="xcl_element_steel_gem", ReqItem={"xcl_element_steel_silk","xcl_element_steel_dust"}},
	{ Item="xcl_element_steel_globe", ReqItem={"xcl_element_steel_silk", "xcl_element_steel_dust", "xcl_element_steel_gem"}},
	{ Item="xcl_element_water_gem", ReqItem={"xcl_element_water_silk","xcl_element_water_dust"}},
	{ Item="xcl_element_water_globe", ReqItem={"xcl_element_water_silk", "xcl_element_water_dust", "xcl_element_water_gem"}}
}

  local state = 0
  local repeated = false
  local cart = {} --catalog element chosen to trade for
  local tribute = {} --item IDs chosen to trade in

  --normal trades
  for ii = 1, #COMMON_GEN.TRADES, 1 do
	local base_data = COMMON_GEN.TRADES[ii]
	table.insert(catalog, base_data)
  end

  --random trades
  for ii = 1, #SV.base_trades, 1 do
	local base_data = SV.base_trades[ii]
	table.insert(catalog, base_data)
  end

  local Prices = { 1000, 5000, 20000, 50000, 100000 }
  local player = CH('PLAYER')
  local partner = CH('Teammate1')
  local chara = CH('Swap_Owner')
  chara.IsInteracting = true
  partner.IsInteracting = true
  UI:SetSpeaker(chara)
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(player, 'None', true)
  GROUND:CharSetAnim(chara, 'None', true)

  GROUND:CharTurnToChar(player, chara)
  local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)

	while state > -1 do
		if state == 0 then
			local msg = STRINGS:Format(STRINGS.MapStrings['Swap_Intro'])
			if repeated == true then
				msg = STRINGS:Format(STRINGS.MapStrings['Swap_Intro_Return'])
			end
			local shop_choices = {STRINGS:Format(STRINGS.MapStrings['Swap_Option_Swap']),
			STRINGS:FormatKey("MENU_INFO"),
			STRINGS:FormatKey("MENU_EXIT")}
			UI:BeginChoiceMenu(msg, shop_choices, 1, 3)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			repeated = true
			if result == 1 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Swap_Choose']))
				state = 1
			elseif result == 2 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Swap_Info_001']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Swap_Info_002']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Swap_Info_003']))
			else
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Swap_Goodbye']))
				state = -1
			end
		elseif state == 1 then
			--only show the items that can be swapped for, checking inv, held, and storage
			--allow trade from storage, and find a way around multi-select for storage.
			UI:SwapMenu(catalog, Prices)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result > -1 then
				cart = result
				state = 2
			else
				state = 0
			end
		elseif state == 2 then
			local trade = catalog[cart]
			local receive_item = RogueEssence.Dungeon.InvItem(trade.Item)
			local free_slots = 0
			tribute = {}
			for ii = 1, #trade.ReqItem, 1 do
				if trade.ReqItem[ii] == "" then
					free_slots = free_slots + 1
				else
					table.insert(tribute, trade.ReqItem[ii])
				end
			end

			if free_slots > 0 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Swap_Give_Choose'], receive_item:GetDisplayName()))
				--tribute simply aggregates all items period
				--this means that choosing multiple of one item will be impossible
				--must choose all DIFFERENT specific items
				UI:TributeMenu(free_slots)
				UI:WaitForChoice()
				local result = UI:ChoiceResult()
				if #result > 0 then
					for ii = 1, #result, 1 do
						table.insert(tribute, result[ii])
					end
					state = 3
				else
					state = 0
				end
			else
				state = 3
			end
		elseif state == 3 then
			local trade = catalog[cart]
			local receive_item = RogueEssence.Dungeon.InvItem(trade.Item)
			local give_items = {}
			for ii = 1, #tribute, 1 do
				local give_item = RogueEssence.Dungeon.InvItem(tribute[ii])
				table.insert(give_items, give_item:GetDisplayName())
			end

			local itemEntry = RogueEssence.Data.DataManager.Instance:GetItem(trade.Item)
			local total = Prices[itemEntry.Rarity]

			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Swap_Confirm_001'], STRINGS:CreateList(give_items), receive_item:GetDisplayName()))
			UI:ChoiceMenuYesNo(STRINGS:Format(STRINGS.MapStrings['Swap_Confirm_002'], total), false)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()

			if result then
				for ii = #tribute, 1, -1 do
					local item_slot = GAME:FindPlayerItem(tribute[ii], true, true)
					if not item_slot:IsValid() then
						--it is a certainty that there is an item in storage, due to previous checks
						GAME:TakePlayerStorageItem(tribute[ii])
					elseif item_slot.IsEquipped then
						GAME:TakePlayerEquippedItem(item_slot.Slot, true)
					else
						GAME:TakePlayerBagItem(item_slot.Slot, true)
					end
				end
				SOUND:PlayBattleSE("DUN_Money")
				GAME:RemoveFromPlayerMoney(total)

				GeneralFunctions.SetEmotion("Angry")
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Swap_Complete_001']))
				GeneralFunctions.SetEmotion("Stunned")
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Swap_Complete_002']))
				GeneralFunctions.SetEmotion("Normal")

				UI:ResetSpeaker()
				SOUND:PlayFanfare("Fanfare/Treasure")
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Swap_Give'], player:GetDisplayName(), receive_item:GetDisplayName()))

				--local bag_count = GAME:GetPlayerBagCount()
				--local bag_cap = GAME:GetPlayerBagLimit()
				--if bag_count < bag_cap then
				--	GAME:GivePlayerItem(trade.Item, 1)
				--else--TODO: load universal strings alongside local strings
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Item_Give_Storage'], receive_item:GetDisplayName()))
				GAME:GivePlayerStorageItem(trade.Item, 1)
				--end

				UI:SetSpeaker(chara)
				tribute = {}
				cart = {}
				state = 0
			else
				state = 1
			end
		end
	end
	--reimplementing parts of endconversation
	TASK:JoinCoroutines({coro1})
	partner.IsInteracting = false
	chara.IsInteracting = false

	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(player)
	GROUND:CharEndAnim(chara)
end

function metano_town.Tutor_Sequence(member, moveEntry)
	--Does the animation + flash whenever slowpoke helps you remember/forget a move
	local chara = CH('Tutor_Owner')
	GAME:WaitFrames(10)
	GROUND:CharSetAnim(chara, "Strike", false)
	GAME:WaitFrames(15)
	local emitter = RogueEssence.Content.FlashEmitter()
	emitter.FadeInTime = 2
	emitter.HoldTime = 4
	emitter.FadeOutTime = 2
	emitter.StartColor = Color(0, 0, 0, 0)
	emitter.Layer = DrawLayer.Top
	emitter.Anim = RogueEssence.Content.BGAnimData("White", 0)
	GROUND:PlayVFX(emitter, chara.MapLoc.X, chara.MapLoc.Y)
	SOUND:PlayBattleSE("EVT_Battle_Flash")
	GAME:WaitFrames(10)
	GROUND:CharSetAnim(chara, "None", true)
	GAME:WaitFrames(30)
end

BasePowerType = luanet.import_type('RogueEssence.Dungeon.BasePowerState')
function metano_town.Tutor_Action(obj, activator)
  --LA VILLE PARLE DE LA NUIT. Si un raid a eu lieu, ce commercant en
  --dit un mot AVANT d'ouvrir boutique. Une seule fois par journee, et
  --rend la main aussitot : aucun dialogue existant n'est perdu.
  if TownVoicesNight.Talk('Tutor_Owner') then return end
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine

  local price = 0
  local state = 0
  local repeated = false
  local member = nil
  local move = ""
  local egg_moves = nil
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local chara = CH('Tutor_Owner')
  chara.IsInteracting = true
  partner.IsInteracting = true
  UI:SetSpeaker(chara)
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  GROUND:CharSetAnim(chara, 'None', true)

  GROUND:CharTurnToChar(hero, chara)
  local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
  UI:SetSpeaker(chara)

	while state > -1 do
		if state == 0 then
			local msg = STRINGS:Format(STRINGS.MapStrings['Tutor_Intro'])
			if repeated == true then
				msg = STRINGS:Format(STRINGS.MapStrings['Tutor_Intro_Return'])
			end

			local tutor_choices = {RogueEssence.StringKey("MENU_RECALL_SKILL"):ToLocal(),
			RogueEssence.StringKey("MENU_FORGET_SKILL"):ToLocal(),
			STRINGS:FormatKey("MENU_INFO"),
			STRINGS:FormatKey("MENU_EXIT")}

			--starting in chapter 6, slowpoke will be able to teach Egg moves for a fee.
			if SV.ChapterProgression.Chapter >= 6 then
				table.insert(tutor_choices, 3, STRINGS:Format(STRINGS.MapStrings['Tutor_Option_Tutor']))
			end

			UI:BeginChoiceMenu(msg, tutor_choices, 1, #tutor_choices)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			repeated = true
			if result == 1 then
				if price > GAME:GetPlayerMoney() then
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_No_Money']))
				else
					state = 1
				end
			elseif result == 2 then
				state = 4
			elseif result == 3 and SV.ChapterProgression.Chapter >= 6 then --egg move tutoring
				state = 6
			elseif result == #tutor_choices - 1 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_Info_001']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_Info_002']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_Info_003']))
				if SV.ChapterProgression.Chapter >= 6 then--chapter 6 and on, he now has the egg move tutor to explain.
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_Info_004']))
				end
			else
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_Goodbye']))
				state = -1
			end
		elseif state == 1 then
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_Remember_Who']))
			UI:TutorTeamMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result > -1 then
				state = 2
				member = GAME:GetPlayerPartyMember(result)
			else
				state = 0
			end
		elseif state == 2 then
			if not GAME:CanRelearn(member) then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_Cant_Remember'], member:GetDisplayName(false)))
				state = 1
			else
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_Remember_What'], member:GetDisplayName(false)))
				UI:RelearnMenu(member)
				UI:WaitForChoice()
				local result = UI:ChoiceResult()
				if result ~= '' then--no move was chosen if result is empty string
					move = result
					state = 3
				else
					state = 1
				end
			end
		elseif state == 3 then
			local moveEntry = RogueEssence.Data.DataManager.Instance:GetSkill(move)
			if GAME:CanLearn(member) then
				--SOUND:PlayBattleSE("DUN_Money") price was removed so no money sound
				GAME:RemoveFromPlayerMoney(price)
				GAME:LearnSkill(member, move)
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_Remember_Begin']))
				metano_town.Tutor_Sequence()
				SOUND:PlayBattleSE("DUN_TM")
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_Remember_Success'], member:GetDisplayName(false), moveEntry:GetColoredName()))				state = 0
			else
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_Remember_Replace'], member:GetDisplayName(false)))
				local result = UI:LearnMenu(member, move)
				UI:WaitForChoice()
				local result = UI:ChoiceResult()
				if result > -1 and result < 4 then
					--SOUND:PlayBattleSE("DUN_Money") price was removed so no money sound
					GAME:RemoveFromPlayerMoney(price)
					GAME:SetCharacterSkill(member, move, result)
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_Remember_Begin']))
					metano_town.Tutor_Sequence()
					SOUND:PlayBattleSE("DUN_TM")
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_Remember_Success'], member:GetDisplayName(false), moveEntry:GetColoredName()))					state = 0
				else
					state = 2
				end
			end
		elseif state == 4 then
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_Forget_Who']))
			UI:TutorTeamMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result > -1 then
				member = GAME:GetPlayerPartyMember(result)
				if not GAME:CanForget(member) then
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_Cant_Forget'], member:GetDisplayName(false)))
				else
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_Forget_What'], member:GetDisplayName(false)))
					state = 5
				end
			else
				state = 0
			end
		elseif state == 5 then
			local result = UI:ForgetMenu(member)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result > -1 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_Forget_Begin']))
				metano_town.Tutor_Sequence()
				move = GAME:GetCharacterSkill(member, result)
				local moveEntry = RogueEssence.Data.DataManager.Instance:GetSkill(move)
				GAME:ForgetSkill(member, result)
				SOUND:PlayBattleSE("DUN_TM")
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_Forget_Success'], member:GetDisplayName(false), moveEntry:GetColoredName()))
				state = 0
			else
				state = 4
			end
		elseif state == 6 then--egg move tutoring
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_Learn_Who']))
			UI:TutorTeamMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result > -1 then
				member = GAME:GetPlayerPartyMember(result)
				egg_moves = _DATA:GetMonster(member.BaseForm.Species).Forms[member.BaseForm.Form].SharedSkills
				print(egg_moves.Count)

				if egg_moves.Count <= 0 then
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_No_Egg_Moves'], member:GetDisplayName(false)))
				else
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_Learn_What'], member:GetDisplayName(false)))
					state = 7
				end
			else
				state = 0
			end
		elseif state == 7 then
			--Determine pricings for egg moves based on status/non status, and power of the move.
			--Pricing is: 4500 for status moves, 1500 + 50*BP for attacks, 5000 if move is variable power.
			local move_list = {}
			local chosen_move = ""
			local egg_move_price = 0
			for i = 0, egg_moves.Count - 1, 1 do
				local skill = _DATA:GetSkill(egg_moves[i].Skill)
				local power = skill.Data.SkillStates:Get(luanet.ctype(BasePowerType)).Power
				print(power)
				if skill.Data.Category ~= RogueEssence.Data.BattleData.SkillCategory.Physical and skill.Data.Category ~= RogueEssence.Data.BattleData.SkillCategory.Magical then
					egg_move_price = 4500
				else
					if power == nil then
						egg_move_price = 5000
					else
						egg_move_price = 1500 + (50 * power)
					end
				end
				move_list[egg_moves[i].Skill] = {Cost = egg_move_price, Currency = ""}
			end
			local result = SkillTutorMenu.runTutorMenu(move_list, "")
			if result ~= "" then
				move = result
				local moveEntry = RogueEssence.Data.DataManager.Instance:GetSkill(move)
				egg_move_price = move_list[move][1]
				print(egg_move_price)
				if egg_move_price > GAME:GetPlayerMoney() then
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_No_Money']))
				elseif GAME:CanLearn(member) then
					SOUND:PlayBattleSE("DUN_Money")
					GAME:RemoveFromPlayerMoney(egg_move_price)
					GAME:LearnSkill(member, move)
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_Learn_Begin']))
					metano_town.Tutor_Sequence()
					SOUND:PlayBattleSE("DUN_TM")
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_Learn_Success'], member:GetDisplayName(false), moveEntry:GetColoredName()))
					state = 0
				else
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_Learn_Replace'], member:GetDisplayName(false)))
					local result = UI:LearnMenu(member, move)
					UI:WaitForChoice()
					local result = UI:ChoiceResult()
					if result > -1 and result < 4 then
						SOUND:PlayBattleSE("DUN_Money")
						GAME:RemoveFromPlayerMoney(egg_move_price)
						GAME:SetCharacterSkill(member, move, result)
						UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_Learn_Begin']))
						metano_town.Tutor_Sequence()
						SOUND:PlayBattleSE("DUN_TM")
						UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Tutor_Learn_Success'], member:GetDisplayName(false), moveEntry:GetColoredName()))
						state = 0
					else
						state = 6
					end
				end
			else
				state = 6
			end
		end
	end
	--reimplementing parts of endconversation
	TASK:JoinCoroutines({coro1})
	partner.IsInteracting = false
	chara.IsInteracting = false

	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(chara)
end



function metano_town.Appraisal_Action(obj, activator)
  --LA VILLE PARLE DE LA NUIT. Si un raid a eu lieu, ce commercant en
  --dit un mot AVANT d'ouvrir boutique. Une seule fois par journee, et
  --rend la main aussitot : aucun dialogue existant n'est perdu.
  if TownVoicesNight.Talk('Appraisal') then return end
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine

  local state = 0
  local repeated = false
  local cart = {}
  local price = 150
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local chara = CH('Appraisal')
  chara.IsInteracting = true
  partner.IsInteracting = true
  UI:SetSpeaker(chara)
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  GROUND:CharSetAnim(chara, 'None', true)

  GROUND:CharTurnToChar(hero, chara)
  local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
  UI:SetSpeaker(chara)
	while state > -1 do
		if state == 0 then
			local msg = STRINGS:Format(STRINGS.MapStrings['Appraisal_Intro'], STRINGS:FormatKey("MONEY_AMOUNT", price))
			if repeated == true then
				msg = STRINGS:Format(STRINGS.MapStrings['Appraisal_Return'])
			end
			local shop_choices = {STRINGS:Format(STRINGS.MapStrings['Appraisal_Option_Open']),
			STRINGS:FormatKey("MENU_INFO"),
			STRINGS:FormatKey("MENU_EXIT")}
			UI:BeginChoiceMenu(msg, shop_choices, 1, 3)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			repeated = true
			if result == 1 then
				local bag_count = GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount()
				if bag_count > 0 then
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Appraisal_Choose'], STRINGS:LocalKeyString(26)))
					state = 1
				else
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Appraisal_Bag_Empty']))
				end
			elseif result == 2 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Appraisal_Info_001']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Appraisal_Info_002']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Appraisal_Info_003']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Appraisal_Info_004'], STRINGS:FormatKey("MONEY_AMOUNT", price)))
			else
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Appraisal_Goodbye']))
				state = -1
			end
		elseif state == 1 then
			UI:AppraiseMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()

			if #result > 0 then
				cart = result
				state = 2
			else
				state = 0
			end
		elseif state == 2 then
			local total = #cart * price

			if total > GAME:GetPlayerMoney() then
				GeneralFunctions.SetEmotion("Determined")
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Appraisal_No_Money']))
				GeneralFunctions.SetEmotion("Normal")
				state = 1
			else
				local msg
				if #cart == 1 then
					local item
					if cart[1].IsEquipped then
						item = GAME:GetPlayerEquippedItem(cart[1].Slot)
					else
						item = GAME:GetPlayerBagItem(cart[1].Slot)
					end
					msg = STRINGS:Format(STRINGS.MapStrings['Appraisal_Choose_One'], total, item:GetDisplayName())
				else
					msg = STRINGS:Format(STRINGS.MapStrings['Appraisal_Choose_Multi'], total)
				end
				UI:ChoiceMenuYesNo(msg, false)
				UI:WaitForChoice()
				result = UI:ChoiceResult()

				local treasure = {}
				if result then
					for ii = #cart, 1, -1 do
						local box = nil
						local stack = 0
						if cart[ii].IsEquipped then
							box = GAME:GetPlayerEquippedItem(cart[ii].Slot)
							GAME:TakePlayerEquippedItem(cart[ii].Slot, true)
						else
							box = GAME:GetPlayerBagItem(cart[ii].Slot)
							GAME:TakePlayerBagItem(cart[ii].Slot, true)
						end

						local treasure_item = box.HiddenValue
						--this is a safeguard to catch boxes without anything in them. Mostly useful for debugging.
						if treasure_item == nil or treasure_item == '' then treasure_item = 'food_apple' end
						local itemEntry = _DATA:GetItem(treasure_item)
						local treasure_choice = { Box = box, Item = RogueEssence.Dungeon.InvItem(treasure_item,false,itemEntry.MaxStack)}
						table.insert(treasure, treasure_choice)

						-- note high rarity items --this is PMDO vanilla code that unlocks family items in sableye's shop after you get it from a chest; not needed here (right now anyway).
						--if itemEntry.Rarity > 0 then
						--	SV.unlocked_trades[treasure_item] = true
						--end
					end
					SOUND:PlayBattleSE("DUN_Money")
					GAME:RemoveFromPlayerMoney(total)
					cart = {}
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Appraisal_Start']))

					--Sneasel should ready herself, then scratch once for each box he has to open
					GAME:WaitFrames(10)
					GROUND:CharAnimateTurnTo(chara, Direction.Up, 4)
					GAME:WaitFrames(10)
					GROUND:CharSetAnim(chara, 'Charge', true)
					GAME:WaitFrames(60)

					--Do a fury swipes for each box we gotta open
					for i=1,(total / price),1
					do
						SOUND:PlayBattleSE('DUN_Fury_Swipes')
						GeneralFunctions.DoAnimation(chara, 'MultiScratch')
					end
					GROUND:CharSetAnim(chara, "None", true)
					GAME:WaitFrames(20)

					GROUND:CharAnimateTurnTo(chara, Direction.Down, 4)
					GAME:WaitFrames(10)

					SOUND:PlayFanfare("Fanfare/Treasure")
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Appraisal_End']))
					UI:SpoilsMenu(treasure)
					UI:WaitForChoice()

					for ii = 1, #treasure, 1 do
						local item = treasure[ii].Item

						GAME:GivePlayerItem(item.ID, item.Amount, false, item.HiddenValue)
					end

					state = 0
				else
					state = 1
				end
			end
		end
	end
	--reimplementing parts of endconversation
	TASK:JoinCoroutines({coro1})
	partner.IsInteracting = false
	chara.IsInteracting = false

	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(chara)
end





---------------------------------
-- Event Trigger
-- These are temporary objects created by a script used to trigger events that only happen
-- at certain plot progressions, typically a cutscene of sorts for a particular chapter.

-- The same event trigger won't be used for two different purposes within the same chapter.
-- if Event Trigger 1 is used to block a specific exit, it won't ever be used for another purpose within that same chapter.
---------------------------------
function metano_town.Event_Trigger_1_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Event_Trigger_1_Touch(...,...)"), obj, activator))
end

function metano_town.Event_Trigger_2_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Event_Trigger_2_Touch(...,...)"), obj, activator))
end

function metano_town.Event_Trigger_3_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Event_Trigger_3_Touch(...,...)"), obj, activator))
end

function metano_town.Event_Trigger_4_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Event_Trigger_4_Touch(...,...)"), obj, activator))
end

function metano_town.Event_Trigger_5_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Event_Trigger_5_Touch(...,...)"), obj, activator))
end

function metano_town.Event_Trigger_6_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Event_Trigger_6_Touch(...,...)"), obj, activator))
end

function metano_town.Event_Trigger_7_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Event_Trigger_7_Touch(...,...)"), obj, activator))
end

function metano_town.Event_Trigger_8_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Event_Trigger_8_Touch(...,...)"), obj, activator))
end

function metano_town.Event_Trigger_9_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Event_Trigger_9_Touch(...,...)"), obj, activator))
end

--------------------
-- Town NPCs
--------------------

--[[
Generic town NPCs to be handled on a per chapter basis, as what they say and do will change between chapters.
The list of non-shop NPCs that live in the town are:

Floatzel (Tweed)
Quagsire
Wooper Boy (Dee)
Wooper Girl (Dun)

Luxray
Manetric
Electrike

Machamp
Medicham
Meditite

Camerupt (Single Mother)
Numel

Vileplume
Bellossom
Gloom
Oddish

Furret
Linoone
Sentret
(Zigzagoon)

Sunflora (Cave Hermit)

Azumarill (Loaf) lives in a tent

Mawile (Bria) lives in a tent

Lickitung ( Urgil  , cafe goer)
Gulpin ( Boosmu  , cafe goer)
???
???
???

]]--

function metano_town.Luxray_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Luxray_Action(...,...)"), obj, activator))
end

function metano_town.Electrike_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Electrike_Action(...,...)"), obj, activator))
end

function metano_town.Manectric_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Manectric_Action(...,...)"), obj, activator))
end

function metano_town.Bellossom_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Bellossom_Action(...,...)"), obj, activator))
end

function metano_town.Vileplume_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Vileplume_Action(...,...)"), obj, activator))
end

function metano_town.Gloom_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Gloom_Action(...,...)"), obj, activator))
end

function metano_town.Oddish_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Oddish_Action(...,...)"), obj, activator))
end

function metano_town.Numel_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Numel_Action(...,...)"), obj, activator))
end

function metano_town.Camerupt_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 GeneralFunctions.ChapterDispatch("metano_town_ch_", "Camerupt_Action", obj, activator,
    function(c)
      GeneralFunctions.StartConversation(c, "Les routes sont plus sures depuis que la guilde s'en mele.[pause=15] Merci pour ca.", "Normal")
      GeneralFunctions.EndConversation(c)
    end)
end

function metano_town.Machamp_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Machamp_Action(...,...)"), obj, activator))
end

function metano_town.Meditite_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Meditite_Action(...,...)"), obj, activator))
end

function metano_town.Medicham_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Medicham_Action(...,...)"), obj, activator))
end

function metano_town.Furret_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Furret_Action(...,...)"), obj, activator))
end

function metano_town.Linoone_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Linoone_Action(...,...)"), obj, activator))
end

function metano_town.Sentret_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Sentret_Action(...,...)"), obj, activator))
end

function metano_town.Wooper_Girl_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Wooper_Girl_Action(...,...)"), obj, activator))
end

function metano_town.Wooper_Boy_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Wooper_Boy_Action(...,...)"), obj, activator))
end

function metano_town.Floatzel_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Floatzel_Action(...,...)"), obj, activator))
end

function metano_town.Quagsire_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Quagsire_Action(...,...)"), obj, activator))
end

function metano_town.Nidorina_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Nidorina_Action(...,...)"), obj, activator))
end

function metano_town.Nidoran_Male_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Nidoran_Male_Action(...,...)"), obj, activator))
end

function metano_town.Nidoking_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Nidoking_Action(...,...)"), obj, activator))
end

function metano_town.Nidoqueen_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Nidoqueen_Action(...,...)"), obj, activator))
end

function metano_town.Mawile_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Mawile_Action(...,...)"), obj, activator))
end

function metano_town.Azumarill_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Azumarill_Action(...,...)"), obj, activator))
end



function metano_town.Gulpin_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Gulpin_Action(...,...)"), obj, activator))
end

function metano_town.Lickitung_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Lickitung_Action(...,...)"), obj, activator))
end


function metano_town.Roselia_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Roselia_Action(...,...)"), obj, activator))
end

function metano_town.Spinda_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Spinda_Action(...,...)"), obj, activator))
end

function metano_town.Ludicolo_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Ludicolo_Action(...,...)"), obj, activator))
end

function metano_town.Jigglypuff_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Jigglypuff_Action(...,...)"), obj, activator))
end

function metano_town.Marill_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Marill_Action(...,...)"), obj, activator))
end

function metano_town.Spheal_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Spheal_Action(...,...)"), obj, activator))
end

function metano_town.Bagon_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Bagon_Action(...,...)"), obj, activator))
end

function metano_town.Doduo_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Doduo_Action(...,...)"), obj, activator))
end

function metano_town.Metapod_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Metapod_Action(...,...)"), obj, activator))
end

function metano_town.Silcoon_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Silcoon_Action(...,...)"), obj, activator))
end




function metano_town.Mareep_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Mareep_Action(...,...)"), obj, activator))
end

function metano_town.Butterfree_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Butterfree_Action(...,...)"), obj, activator))
end

function metano_town.Venipede_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Venipede_Action(...,...)"), obj, activator))
end

function metano_town.Adagio_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Adagio_Action(...,...)"), obj, activator))
end

function metano_town.Aria_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Aria_Action(...,...)"), obj, activator))
end

function metano_town.Sonata_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Sonata_Action(...,...)"), obj, activator))
end

function metano_town.Cranidos_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Cranidos_Action(...,...)"), obj, activator))
end

function metano_town.Snubbull_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Snubbull_Action(...,...)"), obj, activator))
end

function metano_town.Audino_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 GeneralFunctions.ChapterDispatch("metano_town_ch_", "Audino_Action", obj, activator,
    function(c)
      GeneralFunctions.StartConversation(c, "Si vous avez besoin de soins,[pause=10] vous savez ou me trouver.", "Happy")
      GeneralFunctions.EndConversation(c)
    end)
end

function metano_town.Zigzagoon_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Zigzagoon_Action(...,...)"), obj, activator))
end

--Stand de Grodoudou : zones de recrutement des legendaires.
--La logique vit dans metano_town_legend.lua ; ce callback n'est que le relais
--appele par l'entite 'Legend_Merchant' de metano_town.rsground.
function metano_town.Legend_Merchant_Action(obj, activator)
  --LA VILLE PARLE DE LA NUIT. Si un raid a eu lieu, ce commercant en
  --dit un mot AVANT d'ouvrir boutique. Une seule fois par journee, et
  --rend la main aussitot : aucun dialogue existant n'est perdu.
  if TownVoicesNight.Talk('Legend_Merchant') then return end
  --Au retour de l'expedition, la premiere approche joue l'installation du
  --stand ; la boutique ne s'ouvre qu'ensuite (au clic suivant).
  if metano_town_legend.ArrivalScene(activator) then return end
  metano_town_legend.Legend_Merchant_Action(obj, activator)
end

--L'etal lui-meme renvoie vers la marchande : cliquer sur le comptoir
--ou sur Grodoudou produit la meme scene.
function metano_town.Legend_Stand_Action(obj, activator)
  if metano_town_legend.ArrivalScene(activator) then return end
  metano_town_legend.Legend_Merchant_Action(CH('Legend_Merchant'), activator)
end

function metano_town.Growlithe_Desk_Action(obj, activator)
  --LA VILLE PARLE DE LA NUIT. Si un raid a eu lieu, ce commercant en
  --dit un mot AVANT d'ouvrir boutique. Une seule fois par journee, et
  --rend la main aussitot : aucun dialogue existant n'est perdu.
  if TownVoicesNight.Talk('Growlithe') then return end
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Growlithe_Desk_Action(...,...)"), obj, activator))
end






------------------------------
--Signposts, other objects
------------------------------


function metano_town.Guild_Bridge_Sign_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  UI:SetAutoFinish(true)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Sign_Guild_Bridge_1']))
  UI:SetAutoFinish(false)
  UI:SetCenter(false)
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end


function metano_town.Crossroads_Sign_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  UI:SetAutoFinish(true)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Sign_Crossroads_1']))
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Sign_Crossroads_2']))
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Sign_Crossroads_3']))
  UI:SetAutoFinish(false)
  UI:SetCenter(false)
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

function metano_town.Dojo_Sign_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  UI:SetAutoFinish(true)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Sign_Dojo_1']))
  UI:SetAutoFinish(false)
  UI:SetCenter(false)
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

function metano_town.To_Dungeons_Sign_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  UI:SetAutoFinish(true)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Sign_To_Dungeons_1']))
  UI:SetAutoFinish(false)
  UI:SetCenter(false)
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

function metano_town.Wishing_Well_Sign_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  UI:SetAutoFinish(true)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Sign_Wishing_Well_1']))
  UI:SetAutoFinish(false)
  UI:SetCenter(false)
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

function metano_town.To_Spring_Sign_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  UI:SetAutoFinish(true)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Sign_To_Spring_1']))
  UI:SetAutoFinish(false)
  UI:SetCenter(false)
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

function metano_town.Postboard_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  --[[This has been obsoleted by the main menu scripting changes. Down the road, this board can be used for something else instead, like rescues perhaps.
  if SV.Chapter3.DefeatedBoss then -- Only after unlocking missions should this board do anything. This board can be repurposed for something else once missions are added to the main esc menu.
     GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
     GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	  if SV.TakenBoard[1].Client == "" then --No missions taken! Don't display an empty taken board.
          UI:SetAutoFinish(true)
		  UI:SetCenter(true)
		  UI:WaitShowDialogue("You have no jobs currently!")
		  UI:SetAutoFinish(false)
		  UI:SetCenter(false)
	  else
		  local menu = BoardMenu:new("taken")
		  UI:SetCustomMenu(menu.menu)
		  UI:WaitForChoice()
	  end
  else
	  UI:SetAutoFinish(true)
	  UI:SetCenter(true)
	  UI:WaitShowDialogue("There's nothing here right now.\nCome back again another time!")
	  UI:SetAutoFinish(false)
	  UI:SetCenter(false)
  end
  ]]--
  --TABLEAU DES REQUETES. Ce panneau ne servait plus a rien (son code
  --d'origine est commente juste au-dessus). Il porte desormais les requetes
  --de Metano : le joueur doit TOUJOURS pouvoir savoir ce qui lui manque,
  --sinon une progression verrouillee devient une enigme frustrante.
  GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
  GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
  local ch = SV.ChapterProgression.Chapter or 0
  if #SideQuests.OfChapter(ch) > 0 then
    SideQuests.Board(ch)
  else
    UI:SetAutoFinish(true)
    UI:SetCenter(true)
    UI:WaitShowDialogue("Il n'y a rien ici pour le moment.\nRevenez une autre fois !")
    UI:SetAutoFinish(false)
    UI:SetCenter(false)
  end

  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

--Change this to a little cutscene like how chimecho comes out to see you? Whoever ends up running the assmebly should come out to see you
function metano_town.Assembly_Action(obj, activator)
    local hero = CH('PLAYER')
    local partner = CH('Teammate1')
    partner.IsInteracting = true
	AI:DisableCharacterAI(partner)
    GROUND:CharSetAnim(partner, 'None', true)
    GROUND:CharSetAnim(hero, 'None', true)
    GeneralFunctions.TurnTowardsLocation(hero, obj.Position.X + obj.Width // 2, obj.Position.Y + obj.Height // 2)
    GeneralFunctions.TurnTowardsLocation(partner, obj.Position.X + obj.Width // 2, obj.Position.Y + obj.Height // 2)

	--A note prevents use of assembly during Chapter 5's prep
	if SV.ChapterProgression.Chapter == 5 then
		UI:ResetSpeaker(false)
		UI:SetCenter(true)
		UI:WaitShowDialogue("Oh ?[pause=0]Il y a une note sur le panneau...")
		UI:WaitShowDialogue("\"L'assemblée est fermée pendant que la Guilde des Aventuriers est en expédition !\"")
		UI:WaitShowDialogue("\"Désolé pour tout inconvénient!\"[pause=30]-" .. CharacterEssentials.GetCharacterName("Audino"))
		UI:SetCenter(false)

	    partner.IsInteracting = false
	    AI:EnableCharacterAI(partner)
	    AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	    GROUND:CharEndAnim(partner)
	    GROUND:CharEndAnim(hero)

		return
	end


	UI:ResetSpeaker()
	UI:SetCenter(true)
	UI:SetAutoFinish(true)
	UI:ChoiceMenuYesNo("Sonner la cloche et invoquer " .. CharacterEssentials.GetCharacterName("Audino") .. " ?")
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	UI:SetCenter(false)
	UI:SetAutoFinish(false)

	if result then
		--Ring the bell and summon audino
		SOUND:PlayBattleSE('EVT_Assembly_Bell')
		GROUND:ObjectSetAnim(obj, 6, 0, 3, Direction.Down, 1)
		GAME:WaitFrames(24)
		GROUND:ObjectSetAnim(obj, 10, 0, 3, Direction.Down, 1)
		GROUND:ObjectSetDefaultAnim(obj, 'Assembly', 0, 0, 0, Direction.Down)

		--abuse the bell and it no longer works
		if SV.TemporaryFlags.AudinoSummonCount >= 10 then
			GAME:WaitFrames(60)
			UI:WaitShowDialogue("...Personne ne vient.[pause=0]Vous n'auriez peut-être pas dû abuser de la cloche...")
		else
			GAME:FadeOut(false, 40)
			GROUND:TeleportTo(hero, 1276, 608, Direction.Up)
			GROUND:TeleportTo(partner, 1244, 608, Direction.Up)
			local audino = CharacterEssentials.MakeCharactersFromList({{'Audino', 1260, 576, Direction.Down}})
			GROUND:CharSetAnim(audino, "None", true)
			audino.IsInteracting = true
			GAME:MoveCamera(1268, 600, 1, false)
			GAME:FadeIn(40)

			UI:SetSpeaker(audino)
			SV.TemporaryFlags.AudinoSummonCount = SV.TemporaryFlags.AudinoSummonCount + 1
			if SV.TemporaryFlags.AudinoSummonCount == 3 then
				UI:WaitShowDialogue("Ouf ![pause=0]Vous avez certainement besoin de beaucoup utiliser l'assemblage aujourd'hui !")
			elseif SV.TemporaryFlags.AudinoSummonCount == 6 then
				GeneralFunctions.SetEmotion("Pain")
				GROUND:CharSetEmote(audino, "sweating", 1)
				UI:WaitShowDialogue("Huff...[pause=0]Puff...[pause=0]O-tu m'as certainement fait beaucoup courir aujourd'hui,[pause=10] hein ?")
				GAME:WaitFrames(20)
				GeneralFunctions.ShakeHead(audino)
			elseif SV.TemporaryFlags.AudinoSummonCount == 9 then
				GeneralFunctions.SetEmotion("Dizzy")
				GROUND:CharSetEmote(audino, "sweating", 1)
				UI:WaitShowDialogue("Hurf...[pause=0]A-toutes ces r-courir, c'est trop...[pause=0]Je suis épuisé...")
				UI:WaitShowDialogue("P-s'il vous plaît...[pause=0]D-n'abusez pas de la clochette...")
				GAME:WaitFrames(40)
				GeneralFunctions.ShakeHead(audino)
			elseif SV.TemporaryFlags.AudinoSummonCount == 10 then
				GeneralFunctions.SetEmotion("Pain")
				GROUND:CharSetEmote(audino, "sweating", 1)
				UI:WaitShowDialogue("Huff...[pause=0] Puff...")
				GAME:WaitFrames(20)
				GeneralFunctions.Hop(audino)
				GROUND:CharSetAnim(audino, "None", true)
				GeneralFunctions.SetEmotion("Determined")
				UI:WaitShowDialogue("Je commence à croire que vous faites ça exprès !")
				UI:WaitShowDialogue("Eh bien, je ne craque plus ![pause=0]Si vous souhaitez continuer à utiliser l'assemblage aujourd'hui,[pause=10] venez me voir !")
				GAME:WaitFrames(10)
			else
				UI:WaitShowDialogue(hero:GetDisplayName() .. "! " .. partner:GetDisplayName() .. "! Vous avez sonné ?")
			end

			GeneralFunctions.SetEmotion("Normal")

			--she won't service you if you make her angry
			if SV.TemporaryFlags.AudinoSummonCount < 10 then
				GAME:WaitFrames(20)
				AudinoAssembly.Assembly(audino)
			end
			GAME:FadeOut(false, 40)
			GAME:GetCurrentGround():RemoveTempChar(audino)
			GAME:MoveCamera(0,0,1,true)
			GAME:FadeIn(40)
		end
	end

   UI:SetCenter(false)
   partner.IsInteracting = false
   AI:EnableCharacterAI(partner)
   AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
   GROUND:CharEndAnim(partner)
   GROUND:CharEndAnim(hero)

end

function metano_town.Well_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker()
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  GeneralFunctions.TurnTowardsLocation(hero, obj.Position.X + obj.Width // 2, obj.Position.Y + obj.Height // 2)
  GeneralFunctions.TurnTowardsLocation(partner, obj.Position.X + obj.Width // 2, obj.Position.Y + obj.Height // 2)

  UI:ChoiceMenuYesNo("Veux-tu lancer un " .. STRINGS:Format("\\uE024") .. " ?")
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result then
	  local money = GAME:GetPlayerMoney()
	  if money < 1 then
		UI:WaitShowDialogue("Vous n'avez pas d'argent !")
	  else
		GAME:RemoveFromPlayerMoney(1)
		SOUND:PlayBattleSE("_UNK_DUN_Water_Drop")
		UI:WaitShowDialogue("Vous avez lancé un " .. STRINGS:Format("\\uE024") .. " dans le puits !\nQue la chance vous sourie !")
	  end
   end
   UI:SetCenter(false)
   partner.IsInteracting = false
   GROUND:CharEndAnim(partner)
   GROUND:CharEndAnim(hero)
end

function metano_town.RemoveMerchantNicknames()
	local green_kec = CH('Shop_Owner')
	local purp_kec = CH('TM_Owner')
	local kanga = CH('Storage_Owner')
	local murkrow = CH('Bank_Owner')
	local sneasel = CH('Appraisal')
	local chatot = CH('Musician')
	local ambipom = CH('Swap_Owner')
	local slowpoke = CH('Tutor_Owner')
	local stunky = CH('Red_Merchant')
	local farfetchd = CH('Green_Merchant')
	local growlithe = CH('Growlithe')

	green_kec.Data.Nickname = 'Kecleon'
	purp_kec.Data.Nickname = 'Kecleon'
	kanga.Data.Nickname = 'Kangaskhan'
	murkrow.Data.Nickname = 'Murkrow'
	sneasel.Data.Nickname = 'Sneasel'
	chatot.Data.Nickname = 'Chatot'
	ambipom.Data.Nickname = 'Ambipom'
	slowpoke.Data.Nickname = 'Slowpoke'
	stunky.Data.Nickname = 'Stunky'
	farfetchd.Data.Nickname = "Farfetch'd"
	growlithe.Data.Nickname = 'Growlithe'

end

function metano_town.SetMerchantNicknames()
	local green_kec = CH('Shop_Owner')
	local purp_kec = CH('TM_Owner')
	local kanga = CH('Storage_Owner')
	local murkrow = CH('Bank_Owner')
	local sneasel = CH('Appraisal')
	local chatot = CH('Musician')
	local ambipom = CH('Swap_Owner')
	local slowpoke = CH('Tutor_Owner')
	local stunky = CH('Red_Merchant')
	local farfetchd = CH('Green_Merchant')
	local growlithe = CH('Growlithe')

	green_kec.Data.Nickname = CharacterEssentials.GetCharacterName('Kecleon')
	purp_kec.Data.Nickname = CharacterEssentials.GetCharacterName('Kecleon_Purple')
	kanga.Data.Nickname = CharacterEssentials.GetCharacterName('Kangaskhan')
	murkrow.Data.Nickname = CharacterEssentials.GetCharacterName('Murkrow')
	sneasel.Data.Nickname = CharacterEssentials.GetCharacterName('Sneasel')
	chatot.Data.Nickname = CharacterEssentials.GetCharacterName('Chatot')
	ambipom.Data.Nickname = CharacterEssentials.GetCharacterName('Ambipom')
	slowpoke.Data.Nickname = CharacterEssentials.GetCharacterName('Slowpoke')
	stunky.Data.Nickname = CharacterEssentials.GetCharacterName('Stunky')
	farfetchd.Data.Nickname = CharacterEssentials.GetCharacterName('Farfetchd')
	growlithe.Data.Nickname = CharacterEssentials.GetCharacterName('Growlithe')

end

--------------------------------------------------------------------
-- LES MARCHANDS REPONDENT QUAND ON LEUR PARLE
--------------------------------------------------------------------
-- Ces 7 PNJ sont poses sur la carte avec triggerType = 1 (interactif) et
-- toutes leurs cases voisines sont libres : le joueur PEUT donc marcher
-- jusqu'a eux et appuyer sur A. Mais aucun handler <Nom>_Action n'existait,
-- et le moteur ne trouvait rien a appeler : le marchand restait muet.
--
-- Verifie a la main sur metano_town.rsground : Shop_Owner 4 cases libres
-- sur 4, Bank_Owner 4/4, Storage_Owner 3/4, Swap_Owner 3/4, TM_Owner 3/4,
-- Tutor_Owner 2/4, Growlithe 2/4. Aucun n'est adosse a un mur.
--
-- On delegue simplement au comptoir voisin, qui porte deja toute la
-- logique de boutique : parler au vendeur ou toucher son etal doit faire
-- exactement la meme chose.
function metano_town.Shop_Owner_Action(chara, activator)
  metano_town.Shop_Action(chara, activator)
end

function metano_town.Bank_Owner_Action(chara, activator)
  metano_town.Bank_Action(chara, activator)
end

function metano_town.Storage_Owner_Action(chara, activator)
  metano_town.Storage_Action(chara, activator)
end

function metano_town.Swap_Owner_Action(chara, activator)
  metano_town.Swap_Action(chara, activator)
end

function metano_town.TM_Owner_Action(chara, activator)
  metano_town.TM_Action(chara, activator)
end

function metano_town.Tutor_Owner_Action(chara, activator)
  metano_town.Tutor_Action(chara, activator)
end

function metano_town.Growlithe_Action(chara, activator)
  metano_town.Growlithe_Desk_Action(chara, activator)
end

return metano_town
