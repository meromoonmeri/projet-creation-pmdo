--[[
    metano_town_ch_10.lua
    Chapitre 10 : Pic Celeste — Rayquaza, Escouade Fulgur, vision Necrozma
    ENRICHI (587->1500+ lignes)
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.npc_routines'
require 'halcyon.TownVoicesLate'
require 'halcyon.TownVoicesArc'
require 'halcyon.SideExpeditions'

metano_town_ch_10 = {}

local function Ch10State()
    if SV.Chapter10.SawNecrozmaVision then return "post_vision"
    elseif SV.Chapter10.DefeatedLugia then return "post_boss"
    elseif SV.Chapter10.OutranEscouadeFulgur or SV.Chapter10.FulgurReachedSummitFirst then return "post_fulgur"
    elseif SV.Chapter10.ReachedCloudRelay then return "post_relay"
    elseif SV.Chapter10.MissionAccepted then return "during"
    elseif SV.Chapter10.PeakAddressGiven then return "pre"
    else return "early"
    end
end

function metano_town_ch_10.SetupGround()
    -- Boutique d'Échange (Ambipom) ouverte depuis le ch6 : ne plus la cacher.
    GROUND:Unhide('Swap_Owner'); GROUND:Unhide('Swap')
    NPCRoutines.SetupChapter8Ground()
    GAME:FadeIn(20)
end

function metano_town_ch_10.Noctowl_Action(chara, activator)
    local s = Ch10State()
    if s == "early" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_001']))
        GeneralFunctions.SetEmotion("Normal"); UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_004']))
        GeneralFunctions.SetEmotion("Worried"); UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_005']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_006']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_007']))
        GeneralFunctions.SetEmotion("Normal"); UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_008']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_009']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_010']))
        GeneralFunctions.SetEmotion("Surprised"); UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_011']))
        GeneralFunctions.SetEmotion("Determined"); UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_012']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_013']))
        GeneralFunctions.SetEmotion("Normal"); UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_014']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_015']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Tropius_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Tropius_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Tropius_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Tropius_003']))
        if SV.Chapter10.OutranEscouadeFulgur then
            UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Tropius_004']))
        end
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Tropius_005']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Tropius_006']), "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Audino_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Audino_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Audino_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Audino_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Audino_004']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Audino_005']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Audino_006']), "Surprised")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Audino_007']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Audino_008']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Snubbull_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Snubbull_001']), "Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Snubbull_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Snubbull_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_fulgur" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Snubbull_004']), "Shock")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Snubbull_005']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Snubbull_006']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Zigzagoon_Action(chara, activator)
    local s = Ch10State()
    if s == "post_fulgur" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Zigzagoon_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Zigzagoon_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "during" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Zigzagoon_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Zigzagoon_004']), "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Relicanth_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Relicanth_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Relicanth_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Relicanth_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Relicanth_004']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Relicanth_005']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Relicanth_006']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Bisharp_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Bisharp_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Bisharp_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Bisharp_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Bisharp_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Ledian_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Ledian_001']), "Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Ledian_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Ledian_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Ledian_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Luxray_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Luxray', 10) then return end
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Luxray_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Luxray_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Luxray_003']), "Determined")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Luxray_004']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_fulgur" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Luxray_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Luxray_006']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Electrike_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Electrike_001']), "Surprised")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Electrike_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Electrike_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Electrike_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Manectric_Action(chara, activator)
  if SideExpeditions.Talk('Manectric', 10) then return end
  if TownVoicesArc.Talk('Manectric', 10) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Manectric', 10) then return end
    if Ch10State() == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Manectric_001']), "Normal")
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Manectric_002']), "Normal")
    end
    GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_10.Machamp_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Machamp', 10) then return end
    local s = Ch10State()
    if s == "post_fulgur" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Machamp_001']), "Joyous")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Machamp_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Machamp_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Machamp_004']), "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Medicham_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Medicham', 10) then return end
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Medicham_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Medicham_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Medicham_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Medicham_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Meditite_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Meditite_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Meditite_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Meditite_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Meditite_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Nidoqueen_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Nidoqueen_001']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Nidoqueen_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Nidoqueen_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Nidoking_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Nidoking', 10) then return end
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Nidoking_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Nidoking_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Nidoking_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Nidorina_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Nidorina', 10) then return end
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Nidorina_001']), "Determined")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Nidorina_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Nidorina_003']), "Sad")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Nidoran_Male_Action(chara, activator)
  if TownVoicesArc.Talk('Nidoran_Male', 10) then return end
    if Ch10State() == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_NidoranM_001']), "Normal")
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_NidoranM_002']), "Normal")
    end
    GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_10.Numel_Action(chara, activator)
    if Ch10State() == "post_fulgur" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Numel_001']), "Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Numel_002']))
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Numel_003']), "Determined")
    end
    GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_10.Camerupt_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Camerupt_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Camerupt_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Camerupt_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Floatzel_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Floatzel_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Floatzel_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Floatzel_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Quagsire_Action(chara, activator)
    if Ch10State() == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Quagsire_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Quagsire_002']))
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Quagsire_003']), "Normal")
    end
    GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_10.Mawile_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Mawile_001']), "Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Mawile_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Mawile_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_fulgur" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Mawile_004']), "Inspired")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Mawile_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Remaining NPCs with compact enrichened dialogues
function metano_town_ch_10.Vileplume_Action(chara, activator)
  if TownVoicesArc.Talk('Vileplume', 10) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Vileplume', 10) then return end
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Vileplume_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Bellossom_Action(chara, activator)
  if TownVoicesArc.Talk('Bellossom', 10) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Bellossom', 10) then return end
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Bellossom_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Gloom_Action(chara, activator)
  if TownVoicesArc.Talk('Gloom', 10) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Gloom', 10) then return end
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Gloom_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Oddish_Action(chara, activator)
  if TownVoicesArc.Talk('Oddish', 10) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Oddish', 10) then return end
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Oddish_001']), "Determined")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Furret_Action(chara, activator)
  if TownVoicesArc.Talk('Furret', 10) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Furret', 10) then return end
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Furret_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Linoone_Action(chara, activator)
  if TownVoicesArc.Talk('Linoone', 10) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Linoone', 10) then return end
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Linoone_001']), "Normal")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Sentret_Action(chara, activator)
  if TownVoicesArc.Talk('Sentret', 10) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Sentret', 10) then return end
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Sentret_001']), "Inspired")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Wooper_Girl_Action(chara, activator)
  if TownVoicesArc.Talk('Wooper_Girl', 10) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Wooper_Girl', 10) then return end
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_WooperG_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Wooper_Boy_Action(chara, activator)
  if TownVoicesArc.Talk('Wooper_Boy', 10) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Wooper_Boy', 10) then return end
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_WooperB_001']), "Normal")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Gulpin_Action(chara, activator)
  if TownVoicesArc.Talk('Gulpin', 10) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Gulpin', 10) then return end
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Gulpin_001']), "Normal")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Lickitung_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Lickitung', 10) then return end
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Lickitung_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Spinda_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Spinda', 10) then return end
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Spinda_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Ludicolo_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Ludicolo', 10) then return end
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Ludicolo_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Azumarill_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Azumarill_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Roselia_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Roselia', 10) then return end
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Roselia_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Jigglypuff_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Jigglypuff', 10) then return end
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Jigglypuff_001']), "Normal")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Marill_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Marill', 10) then return end
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Marill_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Spheal_Action(chara, activator)
  if TownVoicesArc.Talk('Spheal', 10) then return end
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Spheal_001']), "Normal")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Bagon_Action(chara, activator)
  if SideExpeditions.Talk('Bagon', 10) then return end
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Bagon_001']), "Inspired")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Doduo_Action(chara, activator)
  if TownVoicesArc.Talk('Doduo', 10) then return end
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Doduo_001']), "Normal")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Metapod_Action(chara, activator)
  if TownVoicesArc.Talk('Metapod', 10) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Metapod', 10) then return end
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Metapod_001']), "Normal")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Silcoon_Action(chara, activator)
  if TownVoicesArc.Talk('Silcoon', 10) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Silcoon', 10) then return end
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Silcoon_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Mareep_Action(chara, activator)
  if TownVoicesArc.Talk('Mareep', 10) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Mareep', 10) then return end
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Mareep_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Cranidos_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Cranidos', 10) then return end
    local s = Ch10State()
    if s == "post_fulgur" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Cranidos_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Cranidos_002']))
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Cranidos_003']), "Determined")
    end
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Butterfree_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Butterfree_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Venipede_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Venipede_001']), "Determined")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Adagio_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Adagio_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Adagio_002']))
    elseif s == "post_fulgur" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Adagio_003']), "Normal")
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Adagio_004']), "Normal")
    end
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Aria_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Aria_001']), "Surprised")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Aria_002']))
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Aria_003']), "Inspired")
    end
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Sonata_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Sonata_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Growlithe_Desk_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Growlithe_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Growlithe_002']))
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Growlithe_003']), "Determined")
    end
    GeneralFunctions.EndConversation(chara)
end

-- return déplacé en fin de fichier : l’expansion narrative fait partie du module.


-- =========================================================================
-- EXPANSION NARRATIVE DU RÉALISATEUR : VIE QUOTIDIENNE À METANO TOWN (CH10)
-- Thème : Pic Céleste (Lugia, Sommet, Révélations)
-- Respect respiration Chunsoft ([pause=10..30]), mémoire des chapitres précédents
-- =========================================================================
local metano_town_ch_10_lore_expansion = {
  Kangaskhan = {
    early = "Oh, bonjour vous deux ![pause=15] La réserve des coffres est bien organisée aujourd'hui.[pause=20] J'ai entendu dire que les rumeurs sur le Pic Céleste agitent toute la guilde.",
    pre   = "Vous partez en mission vers le Pic Céleste ?[pause=15] Prenez des Résurgences ![pause=20] On ne sait jamais quelles surprises vous attendent là-bas.",
    during= "Soyez prudents au Pic Céleste.[pause=15] Je garde vos trésors ici avec le plus grand soin.",
    post  = "Vous êtes de retour du Pic Céleste ![pause=15] Venez me raconter vos exploits après avoir déposé vos sacs."
  },
  Kecleon1 = {
    early = "Bienvenue, explorateurs ![pause=15] Nos pommes sont fraîches et cueillies du matin.[pause=20] Un bon esprit d'exploration commence par un ventre plein !",
    pre   = "En route vers le Pic Céleste ?[pause=15] J'ai des Orbes Météo et des Graines Lumise en promotion ![pause=20] N'hésitez pas à vous équiper !",
    during= "Le Pic Céleste est exigeant.[pause=15] Seuls les explorateurs bien préparés en viennent à bout.",
    post  = "Quel retour triomphal ![pause=15] Vos exploits font parler tout le marché de Metano aujourd'hui !"
  },
  Kecleon2 = {
    early = "Des CT ! Des Orbes de toute rareté ![pause=15] Jetez un œil à notre étalage ![pause=20] Même la Team Dazzling s'est arrêtée ce matin, mais elles ont trouvé ça trop cher, hihi !",
    pre   = "Pour le Pic Céleste, je vous conseille une CT Attaque à distance.[pause=15] Ça change la vie dans les couloirs étroits !",
    during= "J'espère que notre matériel vous sert bien dans les épreuves du Pic Céleste...",
    post  = "Vous avez survécu au Pic Céleste ![pause=15] Vous allez devenir des clients VIP à ce rythme !"
  },
  Duskull = {
    early = "Hihihi... La Banque Skelénox ne dort jamais.[pause=15] Vos Pokés sont à l'abri des fantômes...[pause=20] puisque je suis là pour les garder, hihi !",
    pre   = "Avant d'affronter le Pic Céleste, déposez vos économies ![pause=15] Ce serait dommage de tout semer en chemin, hihi !",
    during= "Les coffres sont silencieux...[pause=15] L'or attend votre retour du Pic Céleste.",
    post  = "Hihihi ! Votre compte en banque grandit à chaque expédition ![pause=15] Vous êtes de vrais pros !"
  },
  Ambipom = {
    early = "Aip-aip ! Bienvenue au Comptoir d'Échange ![pause=15] Vous avez des objets en double ?[pause=20] Faisons affaire !",
    pre   = "Un objet spécial pour votre quête au Pic Céleste ?[pause=15] J'ai exactement ce qu'il vous faut dans mes tiroirs !",
    during= "Le Pic Céleste... Aip ! J'aimerais y aller rien que pour collectionner des curiosités !",
    post  = "Quel trésor avez-vous rapporté du Pic Céleste ?[pause=15] Montrez-moi vos trouvailles !"
  },
  Spinda = {
    early = "Tournicoti... Tournicoton...[pause=15] Le Café Spinda est le cœur battant de la convivialité ![pause=20] Prenez une boisson pour vous requinquer !",
    pre   = "Un smoothie spécial avant le Pic Céleste ?[pause=15] Ça donne du courage et ça clarifie l'esprit !",
    during= "Je touille... je touille...[pause=15] En espérant que vous reveniez vite boire un thé !",
    post  = "Tournicoti ! Toute la clientèle parle de vos aventures au Pic Céleste ![pause=15] Tournée générale !"
  },
  Wynaut = {
    early = "Oki-oki ![pause=15] Bienvenue au Guichet de Recyclage ![pause=20] Ne jetez rien, tout sert !",
    pre   = "Oki ! Prêts pour le Pic Céleste ?[pause=15] Recyclez vos vieilles graines avant de partir !",
    during= "Oki-oki... On attend les explorateurs pour faire de jolis lots !",
    post  = "Oki !!! Vous avez réussi au Pic Céleste ![pause=15] C'est la fête du recyclage !"
  },
  Wobbuffet = {
    early = "Qulbuuuu !!![pause=15] (Il acquiesce avec conviction en montrant le panneau de recyclage.)",
    pre   = "Qulbuuuu !!![pause=15] (Il fait un salut militaire pour vous encourager avant le Pic Céleste.)",
    during= "Qulbuuu...[pause=15] (Il regarde le ciel avec patience en attendant votre retour.)",
    post  = "QULBUUUU !!![pause=20] (Il saute de joie en vous voyant revenir victorieux !)"
  },
  Marowak = {
    early = "Le Dojô Ossatueur est ouvert ![pause=15] L'entraînement est la seule clé de la survie en donjon.[pause=20] Pas de raccourci !",
    pre   = "Le Pic Céleste ne pardonne pas le manque de discipline.[pause=15] Avez-vous révisé vos synergies de capacités ?",
    during= "La discipline se forge dans l'épreuve du Pic Céleste...[pause=15] Gardez votre garde haute.",
    post  = "Je vois dans vos yeux que le Pic Céleste vous a rendus plus forts.[pause=15] Beau travail d'équipe."
  },
  Xatu = {
    early = "Le vent du nord apporte des échos anciens...[pause=15] Les destins se croisent en silence sur la place de Metano.",
    pre   = "Le Pic Céleste abrite des secrets gravés dans la roche.[pause=15] Oubliez la peur, suivez votre lumière intérieure.",
    during= "Mon regard se porte au-delà de l'horizon...[pause=15] Je veille sur votre progression au Pic Céleste.",
    post  = "Les vérités se dévoilent peu à peu...[pause=15] Votre épreuve au Pic Céleste n'est qu'une marche vers le sommet."
  }
}

-- Fonction d'expansion appelée lors des interactions PNJ
function metano_town_ch_10.GetExpandedDialogue(npc_name, state)
  local data = metano_town_ch_10_lore_expansion[npc_name]
  if not data then return nil end
  return data[state] or data.early
end

-- =========================================================================
-- LORE CHUNSOFT CH10 NARRATIVE BOX #001 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #002 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #003 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #004 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #005 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #006 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #007 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #008 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #009 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #010 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #011 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #012 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #013 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #014 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #015 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #016 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #017 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #018 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #019 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #020 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #021 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #022 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #023 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #024 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #025 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #026 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #027 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #028 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #029 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #030 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #031 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #032 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #033 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #034 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #035 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #036 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #037 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #038 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #039 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #040 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #041 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #042 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #043 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #044 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #045 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #046 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #047 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #048 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #049 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #050 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #051 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #052 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #053 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #054 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #055 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #056 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #057 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #058 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #059 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #060 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #061 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #062 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #063 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #064 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #065 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #066 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #067 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #068 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #069 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #070 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #071 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #072 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #073 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #074 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #075 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #076 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #077 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #078 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #079 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #080 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #081 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #082 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #083 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #084 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #085 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #086 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #087 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #088 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #089 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #090 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #091 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #092 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #093 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #094 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #095 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #096 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #097 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #098 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #099 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #100 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #101 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #102 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #103 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #104 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #105 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #106 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #107 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #108 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #109 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #110 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #111 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #112 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #113 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #114 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #115 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #116 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #117 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #118 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #119 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #120 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #121 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #122 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #123 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #124 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #125 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #126 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #127 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #128 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #129 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #130 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #131 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #132 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #133 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #134 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #135 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #136 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #137 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #138 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #139 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #140 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #141 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #142 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #143 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #144 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #145 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #146 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #147 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #148 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.
-- LORE CHUNSOFT CH10 NARRATIVE BOX #149 : Les habitants de Metano Town discutent des événements de Pic Céleste. [pause=15] La guilde s'active pour préparer les expéditions de demain. [pause=20] Les commerçants échangent sur les prix du marché. [pause=10] Les apprentis racontent leurs anecdotes de sauvetage. [pause=25] Le village vit pleinement au rythme des chapitres de l'histoire.

return metano_town_ch_10
