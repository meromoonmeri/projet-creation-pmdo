--[[
    npc_routines.lua
    Système de routines quotidiennes pour les PNJ non-marchands de Metano Town
    Utilise SV.ChapterProgression.DaysPassed (incrémenté par GeneralFunctions.EndOfDay)
    Pattern: AI:SetCharacterAI existant + GROUND:MoveToPosition pour déplacement visible
    Base technique: init.lua:114-120 (CreateWalkArea), Ch6 SetupGround (MakeCharactersFromList + AI)
]]
require 'origin.common'
require 'halcyon.CharacterEssentials'

NPCRoutines = {}

-- Points de la carte Metano Town (coordonnées approximatives, tileset 8px)
local ROUTE_POINTS = {
    -- Zone Guilde
    GUILD_BRIDGE    = { x = 568, y = 1160 },
    GUILD_ENTRANCE  = { x = 728, y = 576 },
    -- Zone Marché
    MARKET_CENTER   = { x = 952, y = 864 },
    MARKET_STALL    = { x = 704, y = 928 },
    -- Zone Fontaine/Puits
    WELL            = { x = 672, y = 200 },
    FOUNTAIN        = { x = 744, y = 432 },
    -- Zone Café
    CAFE_ENTRANCE   = { x = 1144, y = 592 },
    CAFE_TERRASSE   = { x = 1112, y = 616 },
    -- Zone Rivière
    RIVER_NORTH     = { x = 312, y = 560 },
    RIVER_SOUTH     = { x = 360, y = 640 },
    RIVER_BANK      = { x = 288, y = 600 },
    -- Zone Étang
    POND_EDGE       = { x = 992, y = 392 },
    POND_SHORE      = { x = 640, y = 1040 },
    -- Zone Dojo
    DOJO_ENTRANCE   = { x = 920, y = 1160 },
    DOJO_LADDER     = { x = 940, y = 1120 },
    -- Zone Habitations
    HOUSES_NORTH    = { x = 680, y = 584 },
    HOUSES_SOUTH    = { x = 480, y = 1200 },
    -- Zone Tentes
    TENT_AREA       = { x = 784, y = 1120 },
    TENT_MAWILE     = { x = 752, y = 1000 },
    -- Zone Entrée Donjons
    DUNGEON_PATH    = { x = 160, y = 880 },
    -- Zone Pâturage
    FIELD_EDGE      = { x = 400, y = 1040 },
}

-- Jour modulo 7 (semaine) pour varier les routines
local function DayOfWeek()
    return (SV.ChapterProgression.DaysPassed % 7)
end

-- Phase du jour: 0=matin, 1=journée, 2=soir
-- Déterminé par les flags TemporaryFlags
local function TimeOfDay()
    if SV.TemporaryFlags.MorningWakeup and not SV.TemporaryFlags.MorningAddress then
        return 0 -- matin
    elseif SV.TemporaryFlags.Dinnertime then
        return 2 -- soir
    else
        return 1 -- journée
    end
end

-- Applique une routine de déplacement à un PNJ
-- movePath: liste de {x, y} ou nil pour rester sur place
function NPCRoutines.ApplyRoutine(chara, movePath, wanderArea, speed)
    if not chara then return end
    speed = speed or 1
    wanderArea = wanderArea or { x = 0, y = 0, w = 32, h = 32 }

    if movePath and #movePath > 0 then
        local target = movePath[1]
        GROUND:MoveToPosition(chara, target.x, target.y, false, speed)
    end

    AI:SetCharacterAI(chara, "halcyon.ai.ground_default",
        RogueElements.Loc(wanderArea.x, wanderArea.y),
        RogueElements.Loc(wanderArea.w, wanderArea.h),
        speed, 16, 32, 40, 180)
end

-- Routines individuelles par PNJ
-- Retourne {movePath, wanderArea} selon le jour et l'heure

function NPCRoutines.GetNumelRoutine()
    local dow = DayOfWeek()
    local tod = TimeOfDay()
    if tod == 0 then
        return { ROUTE_POINTS.HOUSES_NORTH }, { x = 520, y = 1080, w = 64, h = 64 }
    elseif tod == 1 then
        if dow % 2 == 0 then
            return { ROUTE_POINTS.FIELD_EDGE }, { x = 360, y = 1000, w = 64, h = 64 }
        else
            return { ROUTE_POINTS.MARKET_CENTER }, { x = 600, y = 840, w = 64, h = 64 }
        end
    else
        return { ROUTE_POINTS.HOUSES_NORTH }, { x = 520, y = 1080, w = 48, h = 48 }
    end
end

function NPCRoutines.GetOddishRoutine()
    local dow = DayOfWeek()
    local tod = TimeOfDay()
    if tod == 0 then
        return { ROUTE_POINTS.HOUSES_SOUTH }, { x = 440, y = 1160, w = 48, h = 48 }
    elseif tod == 1 then
        if dow < 3 then
            return { ROUTE_POINTS.FIELD_EDGE }, { x = 360, y = 1000, w = 48, h = 48 }
        elseif dow < 5 then
            return { ROUTE_POINTS.MARKET_STALL }, { x = 680, y = 900, w = 48, h = 48 }
        else
            return { ROUTE_POINTS.WELL }, { x = 480, y = 760, w = 48, h = 48 }
        end
    else
        return { ROUTE_POINTS.HOUSES_SOUTH }, { x = 440, y = 1160, w = 48, h = 48 }
    end
end

function NPCRoutines.GetMedititeRoutine()
    local dow = DayOfWeek()
    local tod = TimeOfDay()
    if tod == 0 then
        return { ROUTE_POINTS.DOJO_ENTRANCE }, { x = 880, y = 1120, w = 48, h = 48 }
    elseif tod == 1 then
        if dow % 3 == 0 then
            return { ROUTE_POINTS.FOUNTAIN }, { x = 440, y = 720, w = 64, h = 64 }
        elseif dow % 3 == 1 then
            return { ROUTE_POINTS.DOJO_ENTRANCE }, { x = 880, y = 1120, w = 48, h = 48 }
        else
            return { ROUTE_POINTS.WELL }, { x = 480, y = 760, w = 48, h = 48 }
        end
    else
        return { ROUTE_POINTS.HOUSES_NORTH }, { x = 560, y = 1120, w = 48, h = 48 }
    end
end

function NPCRoutines.GetWooperGirlRoutine()
    local dow = DayOfWeek()
    local tod = TimeOfDay()
    if tod == 0 then
        return { ROUTE_POINTS.POND_EDGE }, { x = 560, y = 960, w = 48, h = 48 }
    elseif tod == 1 then
        local spots = { ROUTE_POINTS.WELL, ROUTE_POINTS.FOUNTAIN, ROUTE_POINTS.MARKET_STALL, ROUTE_POINTS.RIVER_BANK }
        return { spots[(dow % 4) + 1] }, { x = 400, y = 700, w = 80, h = 80 }
    else
        return { ROUTE_POINTS.POND_EDGE }, { x = 560, y = 960, w = 48, h = 48 }
    end
end

function NPCRoutines.GetWooperBoyRoutine()
    local dow = DayOfWeek()
    local tod = TimeOfDay()
    if tod == 0 then
        return { ROUTE_POINTS.POND_EDGE }, { x = 600, y = 980, w = 48, h = 48 }
    elseif tod == 1 then
        -- Cherche sa soeur, va aux endroits opposes
        local spots = { ROUTE_POINTS.FOUNTAIN, ROUTE_POINTS.WELL, ROUTE_POINTS.RIVER_BANK, ROUTE_POINTS.MARKET_CENTER }
        return { spots[((dow + 2) % 4) + 1] }, { x = 400, y = 700, w = 80, h = 80 }
    else
        return { ROUTE_POINTS.POND_EDGE }, { x = 600, y = 980, w = 48, h = 48 }
    end
end

function NPCRoutines.GetElectrikeRoutine()
    local dow = DayOfWeek()
    if dow % 2 == 0 then
        return { ROUTE_POINTS.DUNGEON_PATH }, { x = 120, y = 840, w = 64, h = 64 }
    else
        return { ROUTE_POINTS.GUILD_BRIDGE }, { x = 720, y = 600, w = 48, h = 48 }
    end
end

function NPCRoutines.GetFurretRoutine()
    local dow = DayOfWeek()
    local spots = { ROUTE_POINTS.FOUNTAIN, ROUTE_POINTS.WELL, ROUTE_POINTS.FIELD_EDGE, ROUTE_POINTS.MARKET_CENTER, ROUTE_POINTS.RIVER_BANK }
    return { spots[(dow % 5) + 1] }, { x = 360, y = 720, w = 96, h = 96 }
end

function NPCRoutines.GetLinooneRoutine()
    local dow = DayOfWeek()
    local tod = TimeOfDay()
    if tod == 0 then
        return { ROUTE_POINTS.MARKET_STALL }, { x = 640, y = 880, w = 48, h = 48 }
    elseif tod == 1 then
        if dow % 3 == 0 then
            return { ROUTE_POINTS.RIVER_BANK }, { x = 240, y = 560, w = 64, h = 64 }
        else
            return { ROUTE_POINTS.POND_SHORE }, { x = 600, y = 1000, w = 64, h = 64 }
        end
    else
        return { ROUTE_POINTS.HOUSES_NORTH }, { x = 520, y = 1080, w = 48, h = 48 }
    end
end

function NPCRoutines.GetSentretRoutine()
    local dow = DayOfWeek()
    local tod = TimeOfDay()
    if tod == 0 then
        return { ROUTE_POINTS.HOUSES_NORTH }, { x = 520, y = 1080, w = 48, h = 48 }
    elseif tod == 1 then
        local spots = { ROUTE_POINTS.WELL, ROUTE_POINTS.FOUNTAIN, ROUTE_POINTS.DOJO_ENTRANCE }
        return { spots[(dow % 3) + 1] }, { x = 400, y = 760, w = 80, h = 80 }
    else
        return { ROUTE_POINTS.HOUSES_NORTH }, { x = 520, y = 1080, w = 48, h = 48 }
    end
end

function NPCRoutines.GetMawileRoutine()
    local dow = DayOfWeek()
    local tod = TimeOfDay()
    if tod == 1 then
        local spots = { ROUTE_POINTS.MARKET_CENTER, ROUTE_POINTS.FOUNTAIN, ROUTE_POINTS.CAFE_TERRASSE }
        return { spots[(dow % 3) + 1] }, { x = 440, y = 760, w = 80, h = 80 }
    else
        return { ROUTE_POINTS.TENT_MAWILE }, { x = 720, y = 960, w = 48, h = 48 }
    end
end

function NPCRoutines.GetFloatzelRoutine()
    local dow = DayOfWeek()
    if dow % 3 == 0 then
        return { ROUTE_POINTS.RIVER_NORTH }, { x = 280, y = 520, w = 64, h = 64 }
    elseif dow % 3 == 1 then
        return { ROUTE_POINTS.RIVER_SOUTH }, { x = 320, y = 600, w = 64, h = 64 }
    else
        return { ROUTE_POINTS.WELL }, { x = 480, y = 760, w = 48, h = 48 }
    end
end

function NPCRoutines.GetNidorinaRoutine()
    local dow = DayOfWeek()
    if dow % 2 == 0 then
        return { ROUTE_POINTS.GUILD_ENTRANCE }, { x = 680, y = 560, w = 64, h = 64 }
    else
        return { ROUTE_POINTS.MARKET_CENTER }, { x = 600, y = 840, w = 64, h = 64 }
    end
end

function NPCRoutines.GetRoseliaRoutine()
    local dow = DayOfWeek()
    if dow % 2 == 0 then
        return { ROUTE_POINTS.FIELD_EDGE }, { x = 360, y = 1000, w = 64, h = 64 }
    else
        return { ROUTE_POINTS.MARKET_STALL }, { x = 680, y = 900, w = 48, h = 48 }
    end
end

function NPCRoutines.GetBagonRoutine()
    return { ROUTE_POINTS.DOJO_LADDER }, { x = 880, y = 1080, w = 64, h = 64 }
end

function NPCRoutines.GetGloomRoutine()
    local dow = DayOfWeek()
    if dow % 2 == 0 then
        return { ROUTE_POINTS.FIELD_EDGE }, { x = 360, y = 1040, w = 48, h = 48 }
    else
        return { ROUTE_POINTS.HOUSES_SOUTH }, { x = 440, y = 1160, w = 48, h = 48 }
    end
end

function NPCRoutines.GetBellossomRoutine()
    local dow = DayOfWeek()
    if dow % 3 == 0 then
        return { ROUTE_POINTS.FIELD_EDGE }, { x = 380, y = 1000, w = 48, h = 48 }
    else
        return { ROUTE_POINTS.FOUNTAIN }, { x = 440, y = 720, w = 48, h = 48 }
    end
end

-- Retourne la liste des routines pour tous les PNJ éligibles
-- Appelé depuis metano_town_ch_N.SetupGround()
function NPCRoutines.SetupChapter8Ground()
    -- Appliquer routines aux PNJ secondaires
    -- Note: les PNJ principaux (Noctowl, Tropius, Audino, etc.) ne reçoivent PAS de routine
    -- Ils restent à leurs postes fixes

    -- Famille Machamp/Medicham
    local meditite = CH('Meditite')
    if meditite then
        local path, area = NPCRoutines.GetMedititeRoutine()
        NPCRoutines.ApplyRoutine(meditite, path, area)
    end

    -- Enfants
    local numel = CH('Numel')
    if numel then
        local path, area = NPCRoutines.GetNumelRoutine()
        NPCRoutines.ApplyRoutine(numel, path, area)
    end

    local oddish = CH('Oddish')
    if oddish then
        local path, area = NPCRoutines.GetOddishRoutine()
        NPCRoutines.ApplyRoutine(oddish, path, area)
    end

    -- Jumeaux
    local wooper_g = CH('Wooper_Girl')
    if wooper_g then
        local path, area = NPCRoutines.GetWooperGirlRoutine()
        NPCRoutines.ApplyRoutine(wooper_g, path, area)
    end

    local wooper_b = CH('Wooper_Boy')
    if wooper_b then
        local path, area = NPCRoutines.GetWooperBoyRoutine()
        NPCRoutines.ApplyRoutine(wooper_b, path, area)
    end

    -- Famille furet
    local furret = CH('Furret')
    if furret then
        local path, area = NPCRoutines.GetFurretRoutine()
        NPCRoutines.ApplyRoutine(furret, path, area, 1)
    end

    local linoone = CH('Linoone')
    if linoone then
        local path, area = NPCRoutines.GetLinooneRoutine()
        NPCRoutines.ApplyRoutine(linoone, path, area)
    end

    local sentret = CH('Sentret')
    if sentret then
        local path, area = NPCRoutines.GetSentretRoutine()
        NPCRoutines.ApplyRoutine(sentret, path, area)
    end

    -- Commère
    local mawile = CH('Mawile')
    if mawile then
        local path, area = NPCRoutines.GetMawileRoutine()
        NPCRoutines.ApplyRoutine(mawile, path, area)
    end

    -- Pêcheur
    local floatzel = CH('Floatzel')
    if floatzel then
        local path, area = NPCRoutines.GetFloatzelRoutine()
        NPCRoutines.ApplyRoutine(floatzel, path, area)
    end

    -- Autres
    local electrike = CH('Electrike')
    if electrike then
        local path, area = NPCRoutines.GetElectrikeRoutine()
        NPCRoutines.ApplyRoutine(electrike, path, area)
    end

    local nidorina = CH('Nidorina')
    if nidorina then
        local path, area = NPCRoutines.GetNidorinaRoutine()
        NPCRoutines.ApplyRoutine(nidorina, path, area)
    end

    local roselia = CH('Roselia')
    if roselia then
        local path, area = NPCRoutines.GetRoseliaRoutine()
        NPCRoutines.ApplyRoutine(roselia, path, area)
    end

    local bagon = CH('Bagon')
    if bagon then
        local path, area = NPCRoutines.GetBagonRoutine()
        NPCRoutines.ApplyRoutine(bagon, path, area)
    end

    local gloom = CH('Gloom')
    if gloom then
        local path, area = NPCRoutines.GetGloomRoutine()
        NPCRoutines.ApplyRoutine(gloom, path, area)
    end

    local bellossom = CH('Bellossom')
    if bellossom then
        local path, area = NPCRoutines.GetBellossomRoutine()
        NPCRoutines.ApplyRoutine(bellossom, path, area)
    end
end


-- Dispute observable entre Floatzel et Quagsire
-- Joue automatiquement quand le joueur revient du Marais apres purification
function NPCRoutines.TriggerFloatzelQuagsireDispute()
	local floatzel = CH('Floatzel')
	local quagsire = CH('Quagsire')
	if not floatzel or not quagsire then return end

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(floatzel)
	AI:DisableCharacterAI(quagsire)

	-- Floatzel arrive vers Quagsire
	GROUND:MoveToPosition(floatzel, 632, 1016, false, 1)
	GAME:WaitFrames(8)
	GROUND:CharAnimateTurnTo(floatzel, Direction.Up, 4)
	GROUND:CharAnimateTurnTo(quagsire, Direction.DownRight, 4)

	-- La dispute
	UI:SetSpeaker(floatzel)
	GeneralFunctions.SetEmotion("Angry")
	UI:WaitShowDialogue("Tu ne comprends pas ![pause=10] Je dois pêcher ![pause=15] C'est ce que je sais faire !")

	UI:SetSpeaker(quagsire)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue("...[pause=30] Tu n'es jamais là.[pause=25] L'étang est vide sans toi.")

	UI:SetSpeaker(floatzel)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue("Maris...[pause=25] Je... je ne savais pas.")

	UI:SetSpeaker(quagsire)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue("...[pause=30] Maintenant tu sais.[pause=25] Pêche.[pause=30] Mais reviens.")

	GROUND:CharSetEmote(floatzel, "sweatdrop", 1)
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(quagsire, "happy", 1)

	SV.Chapter9.FloatzelDisputeResolved = true
	GAME:WaitFrames(20)
	GAME:CutsceneMode(false)
	AI:SetCharacterAI(floatzel, "halcyon.ai.ground_default",
		RogueElements.Loc(600, 960), RogueElements.Loc(64, 64), 1, 16, 32, 40, 180)
	AI:SetCharacterAI(quagsire, "halcyon.ai.ground_default",
		RogueElements.Loc(624, 992), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
end

return NPCRoutines
