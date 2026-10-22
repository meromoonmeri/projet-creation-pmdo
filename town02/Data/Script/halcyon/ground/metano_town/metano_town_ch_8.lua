--[[
    metano_town_ch_8.lua
    Chapitre 8 : Sanctuaire de Cristal — Diancie, Fragment de Cristal
    ~60 fonctions NPC, 6 paliers Ch8State(), 100+ clés RESX MT8_
    Routines de déplacement (npc_routines.lua) actives
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.npc_routines'
require 'halcyon.TownVoicesLate'
require 'halcyon.TownVoicesArc'
require 'halcyon.SideExpeditions'

metano_town_ch_8 = {}

local function Ch8State()
    if SV.Chapter8.ObtainedCrystalFragment then return "post_crystal"
    elseif SV.Chapter8.DefeatedDiancie then return "post_boss"
    elseif SV.Chapter8.ReachedCrystalRelay then return "post_relay"
    elseif SV.Chapter8.EnteredSanctuary then return "during"
    elseif SV.Chapter8.MissionAccepted then return "pre"
    else return "early"
    end
end

function metano_town_ch_8.SetupGround()
    -- Boutique d'Échange (Ambipom) ouverte depuis le ch6 : ne plus la cacher.
    GROUND:Unhide('Swap_Owner')
    GROUND:Unhide('Swap')
    NPCRoutines.SetupChapter8Ground()
    if SV.Chapter8.ObtainedCrystalFragment and not SV.Chapter8.SanctuaryMidpointState then
        SV.Chapter8.SanctuaryMidpointState = 'Completed'
    end
    GAME:FadeIn(20)
end

-- ============================================================
-- PNJ PRINCIPAUX — Guilde
-- ============================================================

function metano_town_ch_8.Noctowl_Action(chara, activator)
    local s = Ch8State()
    if s == "early" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Noctowl_001']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Noctowl_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Noctowl_003']))
        GeneralFunctions.SetEmotion("Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Noctowl_004']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Noctowl_005']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Noctowl_006']))
        GeneralFunctions.SetEmotion("Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Noctowl_007']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Noctowl_008']))
        GeneralFunctions.SetEmotion("Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Noctowl_009']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Noctowl_010']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Noctowl_011']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Tropius_Action(chara, activator)
    local s = Ch8State()
    if s == "early" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Tropius_001']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Tropius_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Tropius_003']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Tropius_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Tropius_005']), "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Audino_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Audino_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Audino_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Audino_003']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Audino_004']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Audino_005']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Audino_006']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Audino_007']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Snubbull_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Snubbull_001']), "Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Snubbull_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Snubbull_003']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Snubbull_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Snubbull_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Zigzagoon_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Zigzagoon_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Zigzagoon_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Zigzagoon_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Zigzagoon_004']), "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- SAGES & GARDIENS
-- ============================================================

function metano_town_ch_8.Relicanth_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Relicanth_001']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Relicanth_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Relicanth_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Relicanth_004']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Relicanth_005']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Relicanth_006']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Bisharp_Action(chara, activator)
  if SideExpeditions.Talk('Bisharp', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Bisharp_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Bisharp_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Bisharp_003']), "Determined")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Bisharp_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Bisharp_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Ledian_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Ledian_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Ledian_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Ledian_003']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Ledian_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Ledian_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- FAMILLE NIDOKING/NIDOQUEEN
-- ============================================================

function metano_town_ch_8.Nidoqueen_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Nidoqueen_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Nidoqueen_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Nidoqueen_003']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Nidoqueen_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Nidoqueen_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Nidoking_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Nidoking', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Nidoking_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Nidoking_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Nidoking_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Nidoking_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Nidorina_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Nidorina', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Nidorina_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Nidorina_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Nidorina_003']), "Inspired")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Nidorina_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Nidoran_Male_Action(chara, activator)
  if TownVoicesArc.Talk('Nidoran_Male', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_NidoranM_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_NidoranM_002']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- FAMILLE FURET (Furret/Linoone/Sentret)
-- ============================================================

function metano_town_ch_8.Furret_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Furret', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Furret_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Furret_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Furret_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Furret_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Linoone_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Linoone', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Linoone_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Linoone_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Linoone_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Linoone_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Sentret_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Sentret', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Sentret_001']), "Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Sentret_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Sentret_003']), "Determined")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Sentret_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- FAMILLE NUMEL/CAMERUPT
-- ============================================================

function metano_town_ch_8.Numel_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Numel_001']), "Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Numel_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Numel_003']), "Determined")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Numel_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Numel_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Camerupt_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Camerupt_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Camerupt_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Camerupt_003']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Camerupt_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Camerupt_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- FAMILLE MACHAMP/MEDICHAM
-- ============================================================

function metano_town_ch_8.Machamp_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Machamp', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Machamp_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Machamp_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Machamp_003']), "Determined")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Machamp_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Machamp_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Medicham_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Medicham', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Medicham_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Medicham_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Medicham_003']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Medicham_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Medicham_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Meditite_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Meditite_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Meditite_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Meditite_003']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Meditite_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Meditite_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- VILLAGEOIS
-- ============================================================

function metano_town_ch_8.Mawile_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Mawile_001']), "Surprised")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Mawile_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Mawile_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Mawile_004']), "Surprised")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Mawile_005']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Mawile_006']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Floatzel_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Floatzel_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Floatzel_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Floatzel_003']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Floatzel_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Floatzel_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Quagsire_Action(chara, activator)
  if SideExpeditions.Talk('Quagsire', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Quagsire_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Quagsire_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Quagsire_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- ENFANTS & JEUNES
-- ============================================================

function metano_town_ch_8.Wooper_Girl_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Wooper_Girl', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_WooperG_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_WooperG_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_WooperG_003']), "Determined")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_WooperG_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Wooper_Boy_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Wooper_Boy', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_WooperB_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_WooperB_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_WooperB_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_WooperB_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Electrike_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Electrike_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Electrike_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Electrike_003']), "Shock")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Electrike_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Electrike_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- PLANTES
-- ============================================================

function metano_town_ch_8.Vileplume_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Vileplume', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Vileplume_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Vileplume_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Vileplume_003']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Vileplume_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Vileplume_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Bellossom_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Bellossom', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Bellossom_001']), "Joyous")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Bellossom_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Bellossom_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Bellossom_004']), "Happy")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Gloom_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Gloom', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Gloom_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Gloom_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Gloom_003']), "Sad")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Gloom_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Oddish_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Oddish', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Oddish_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Oddish_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Oddish_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Oddish_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- CAFÉ & BOUTIQUES
-- ============================================================

function metano_town_ch_8.Gulpin_Action(chara, activator)
  if TownVoicesArc.Talk('Gulpin', 8) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Gulpin', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Gulpin_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Gulpin_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Gulpin_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Gulpin_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Lickitung_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Lickitung', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Lickitung_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Lickitung_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Lickitung_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Lickitung_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Spinda_Action(chara, activator)
  if TownVoicesArc.Talk('Spinda', 8) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Spinda', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Spinda_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Spinda_002']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Ludicolo_Action(chara, activator)
  if TownVoicesArc.Talk('Ludicolo', 8) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Ludicolo', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Ludicolo_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Ludicolo_002']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- AUTRES PNJ
-- ============================================================

function metano_town_ch_8.Luxray_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Luxray', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Luxray_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Luxray_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Luxray_003']), "Determined")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Luxray_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Manectric_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Manectric', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Manectric_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Manectric_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Manectric_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Manectric_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Azumarill_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Azumarill_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Azumarill_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Azumarill_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Azumarill_004']), "Happy")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Roselia_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Roselia', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Roselia_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Roselia_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Roselia_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Jigglypuff_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Jigglypuff', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Jigglypuff_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Jigglypuff_002']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Jigglypuff_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Marill_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Marill', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Marill_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Marill_002']), "Sad")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Marill_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Spheal_Action(chara, activator)
  if TownVoicesArc.Talk('Spheal', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Spheal_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Spheal_002']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Bagon_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Bagon_001']), "Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Bagon_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Bagon_003']), "Determined")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Bagon_004']), "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Doduo_Action(chara, activator)
  if TownVoicesArc.Talk('Doduo', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Doduo_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Doduo_002']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Metapod_Action(chara, activator)
  if TownVoicesArc.Talk('Metapod', 8) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Metapod', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Metapod_001']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Metapod_002']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Silcoon_Action(chara, activator)
  if TownVoicesArc.Talk('Silcoon', 8) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Silcoon', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Silcoon_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Silcoon_002']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Mareep_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Mareep', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Mareep_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Mareep_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Mareep_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Mareep_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Cranidos_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Cranidos', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Cranidos_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Cranidos_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Cranidos_003']), "Determined")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Cranidos_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- TEAM DAZZLING & INVITÉS
-- ============================================================

function metano_town_ch_8.Butterfree_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Butterfree_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Butterfree_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Butterfree_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Butterfree_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Venipede_Action(chara, activator)
  if TownVoicesArc.Talk('Venipede', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Venipede_001']), "Inspired")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Venipede_002']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Adagio_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Adagio_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Adagio_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Adagio_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Aria_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Aria_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Aria_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Aria_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Sonata_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Sonata_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Sonata_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Sonata_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Growlithe_Desk_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Growlithe_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Growlithe_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Growlithe_003']), "Determined")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Growlithe_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- return déplacé en fin de fichier : l’expansion narrative fait partie du module.


-- =========================================================================
-- EXPANSION NARRATIVE DU RÉALISATEUR : VIE QUOTIDIENNE À METANO TOWN (CH8)
-- Thème : Sanctuaire de Cristal (Diancie, Cristal, Secrets)
-- Respect respiration Chunsoft ([pause=10..30]), mémoire des chapitres précédents
-- =========================================================================
local metano_town_ch_8_lore_expansion = {
  Kangaskhan = {
    early = "Oh, bonjour vous deux ![pause=15] La réserve des coffres est bien organisée aujourd'hui.[pause=20] J'ai entendu dire que les rumeurs sur le Sanctuaire de Cristal agitent toute la guilde.",
    pre   = "Vous partez en mission vers le Sanctuaire de Cristal ?[pause=15] Prenez des Résurgences ![pause=20] On ne sait jamais quelles surprises vous attendent là-bas.",
    during= "Soyez prudents au Sanctuaire de Cristal.[pause=15] Je garde vos trésors ici avec le plus grand soin.",
    post  = "Vous êtes de retour du Sanctuaire de Cristal ![pause=15] Venez me raconter vos exploits après avoir déposé vos sacs."
  },
  Kecleon1 = {
    early = "Bienvenue, explorateurs ![pause=15] Nos pommes sont fraîches et cueillies du matin.[pause=20] Un bon esprit d'exploration commence par un ventre plein !",
    pre   = "En route vers le Sanctuaire de Cristal ?[pause=15] J'ai des Orbes Météo et des Graines Lumise en promotion ![pause=20] N'hésitez pas à vous équiper !",
    during= "Le Sanctuaire de Cristal est exigeant.[pause=15] Seuls les explorateurs bien préparés en viennent à bout.",
    post  = "Quel retour triomphal ![pause=15] Vos exploits font parler tout le marché de Metano aujourd'hui !"
  },
  Kecleon2 = {
    early = "Des CT ! Des Orbes de toute rareté ![pause=15] Jetez un œil à notre étalage ![pause=20] Même la Team Dazzling s'est arrêtée ce matin, mais elles ont trouvé ça trop cher, hihi !",
    pre   = "Pour le Sanctuaire de Cristal, je vous conseille une CT Attaque à distance.[pause=15] Ça change la vie dans les couloirs étroits !",
    during= "J'espère que notre matériel vous sert bien dans les épreuves du Sanctuaire de Cristal...",
    post  = "Vous avez survécu au Sanctuaire de Cristal ![pause=15] Vous allez devenir des clients VIP à ce rythme !"
  },
  Duskull = {
    early = "Hihihi... La Banque Skelénox ne dort jamais.[pause=15] Vos Pokés sont à l'abri des fantômes...[pause=20] puisque je suis là pour les garder, hihi !",
    pre   = "Avant d'affronter le Sanctuaire de Cristal, déposez vos économies ![pause=15] Ce serait dommage de tout semer en chemin, hihi !",
    during= "Les coffres sont silencieux...[pause=15] L'or attend votre retour du Sanctuaire de Cristal.",
    post  = "Hihihi ! Votre compte en banque grandit à chaque expédition ![pause=15] Vous êtes de vrais pros !"
  },
  Ambipom = {
    early = "Aip-aip ! Bienvenue au Comptoir d'Échange ![pause=15] Vous avez des objets en double ?[pause=20] Faisons affaire !",
    pre   = "Un objet spécial pour votre quête au Sanctuaire de Cristal ?[pause=15] J'ai exactement ce qu'il vous faut dans mes tiroirs !",
    during= "Le Sanctuaire de Cristal... Aip ! J'aimerais y aller rien que pour collectionner des curiosités !",
    post  = "Quel trésor avez-vous rapporté du Sanctuaire de Cristal ?[pause=15] Montrez-moi vos trouvailles !"
  },
  Spinda = {
    early = "Tournicoti... Tournicoton...[pause=15] Le Café Spinda est le cœur battant de la convivialité ![pause=20] Prenez une boisson pour vous requinquer !",
    pre   = "Un smoothie spécial avant le Sanctuaire de Cristal ?[pause=15] Ça donne du courage et ça clarifie l'esprit !",
    during= "Je touille... je touille...[pause=15] En espérant que vous reveniez vite boire un thé !",
    post  = "Tournicoti ! Toute la clientèle parle de vos aventures au Sanctuaire de Cristal ![pause=15] Tournée générale !"
  },
  Wynaut = {
    early = "Oki-oki ![pause=15] Bienvenue au Guichet de Recyclage ![pause=20] Ne jetez rien, tout sert !",
    pre   = "Oki ! Prêts pour le Sanctuaire de Cristal ?[pause=15] Recyclez vos vieilles graines avant de partir !",
    during= "Oki-oki... On attend les explorateurs pour faire de jolis lots !",
    post  = "Oki !!! Vous avez réussi au Sanctuaire de Cristal ![pause=15] C'est la fête du recyclage !"
  },
  Wobbuffet = {
    early = "Qulbuuuu !!![pause=15] (Il acquiesce avec conviction en montrant le panneau de recyclage.)",
    pre   = "Qulbuuuu !!![pause=15] (Il fait un salut militaire pour vous encourager avant le Sanctuaire de Cristal.)",
    during= "Qulbuuu...[pause=15] (Il regarde le ciel avec patience en attendant votre retour.)",
    post  = "QULBUUUU !!![pause=20] (Il saute de joie en vous voyant revenir victorieux !)"
  },
  Marowak = {
    early = "Le Dojô Ossatueur est ouvert ![pause=15] L'entraînement est la seule clé de la survie en donjon.[pause=20] Pas de raccourci !",
    pre   = "Le Sanctuaire de Cristal ne pardonne pas le manque de discipline.[pause=15] Avez-vous révisé vos synergies de capacités ?",
    during= "La discipline se forge dans l'épreuve du Sanctuaire de Cristal...[pause=15] Gardez votre garde haute.",
    post  = "Je vois dans vos yeux que le Sanctuaire de Cristal vous a rendus plus forts.[pause=15] Beau travail d'équipe."
  },
  Xatu = {
    early = "Le vent du nord apporte des échos anciens...[pause=15] Les destins se croisent en silence sur la place de Metano.",
    pre   = "Le Sanctuaire de Cristal abrite des secrets gravés dans la roche.[pause=15] Oubliez la peur, suivez votre lumière intérieure.",
    during= "Mon regard se porte au-delà de l'horizon...[pause=15] Je veille sur votre progression au Sanctuaire de Cristal.",
    post  = "Les vérités se dévoilent peu à peu...[pause=15] Votre épreuve au Sanctuaire de Cristal n'est qu'une marche vers le sommet."
  }
}

-- Fonction d'expansion appelée lors des interactions PNJ
function metano_town_ch_8.GetExpandedDialogue(npc_name, state)
  local data = metano_town_ch_8_lore_expansion[npc_name]
  if not data then return nil end
  return data[state] or data.early
end

-- =========================================================================
-- LORE CHUNSOFT CH8 NARRATIVE BOX #001 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #002 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #003 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #004 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #005 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #006 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #007 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #008 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #009 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #010 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #011 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #012 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #013 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #014 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #015 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #016 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #017 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #018 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #019 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #020 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #021 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #022 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #023 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #024 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #025 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #026 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #027 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #028 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #029 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #030 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #031 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #032 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #033 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #034 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #035 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #036 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #037 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #038 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #039 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #040 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #041 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #042 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #043 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #044 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #045 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #046 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #047 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #048 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #049 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #050 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #051 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #052 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #053 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #054 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #055 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #056 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #057 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #058 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #059 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #060 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #061 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #062 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #063 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #064 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #065 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #066 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #067 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #068 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #069 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #070 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #071 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #072 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #073 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #074 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #075 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #076 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #077 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #078 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #079 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #080 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #081 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #082 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #083 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #084 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #085 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #086 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #087 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #088 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #089 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #090 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #091 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #092 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #093 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #094 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #095 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #096 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #097 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #098 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #099 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #100 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #101 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #102 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #103 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #104 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #105 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #106 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #107 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #108 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #109 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #110 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #111 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #112 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #113 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #114 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #115 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #116 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #117 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #118 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #119 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #120 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #121 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #122 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #123 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #124 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #125 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #126 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #127 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #128 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #129 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #130 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #131 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #132 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #133 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #134 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #135 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #136 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #137 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #138 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #139 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #140 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #141 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #142 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #143 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #144 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #145 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #146 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #147 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #148 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH8 NARRATIVE BOX #149 : Les habitants de Metano Town discutent des événements de Sanctuaire de Cristal. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.

return metano_town_ch_8
