--[[
    metano_town_ch_7.lua
    Chapitre 7 : Dialogues PNJ — post-expedition, Aegis Cave, Genese, Reve Necrozma
    ~50 fonctions, 6 paliers Ch7State(), 37 cles MT7_077-113 + cles nommees
    Densite alignee sur Ch6 (815 lignes, 51 fonctions)
]]

require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.TownVoicesLate'

metano_town_ch_7 = {}

-- ============================================================
-- Helper : 6 paliers de progression Chapitre 7
-- ============================================================
local function Ch7State()
    if SV.Chapter7.HadFirstDream then return "post_dream"
    elseif SV.Chapter7.HeardGenesisTale then return "post_genesis"
    elseif SV.Chapter7.DefeatedRuinsBoss then return "post_boss"
    elseif SV.Chapter7.EnteredRuins then return "during"
    elseif SV.Chapter7.RuinsAddressGiven then return "pre"
    else return "early"
    end
end

-- ============================================================
-- PNJ PRINCIPAUX — Guilde (enrichis)
-- ============================================================

-- Phileas (Noctowl) : raconte la Genese si le joueur a vu le Coeur corrompu
function metano_town_ch_7.Noctowl_Action(chara, activator)
    if SV.Chapter7.SawAnimaCoreCorruption and not SV.Chapter7.HeardGenesisTale then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Noctowl_001']))
        GeneralFunctions.SetEmotion("Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Noctowl_002']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Noctowl_003']))
        GeneralFunctions.EndConversation(chara)
        GAME:EnterGroundMap('genesis_vision', 'Main_Entrance_Marker')
    elseif SV.Chapter7.HeardGenesisTale and not SV.Chapter7.HadFirstDream then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Noctowl_004']))
        GeneralFunctions.SetEmotion("Sad")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Noctowl_005']))
        GeneralFunctions.EndConversation(chara)
    elseif SV.Chapter7.DefeatedRuinsBoss then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Noctowl_006']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Noctowl_007']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Noctowl_008']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Penticus (Tropius) : reaction a l'expedition terminee
function metano_town_ch_7.Tropius_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" or s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Tropius_001']))
        GeneralFunctions.SetEmotion("Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Tropius_002']))
        GeneralFunctions.SetEmotion("Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Tropius_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Tropius_004']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Tropius_005']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Tropius_006']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Rin (Audino) : s'inquiete pour l'equipe
function metano_town_ch_7.Audino_Action(chara, activator)
    local s = Ch7State()
    if s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_109']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_095']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Audino_001']))
        GeneralFunctions.SetEmotion("Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Audino_002']))
        GeneralFunctions.SetEmotion("Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Audino_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Audino_004']))
        GeneralFunctions.SetEmotion("Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Audino_005']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Audino_006']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Coco (Snubbull) : rumeurs sur les Ruines
function metano_town_ch_7.Snubbull_Action(chara, activator)
    local s = Ch7State()
    if s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_111']), "Shock")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Snubbull_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_101']), "Surprised")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_096']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Snubbull_001']))
        GeneralFunctions.SetEmotion("Surprised")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Snubbull_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Snubbull_003']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Snubbull_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Snubbull_005']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Almotz (Zigzagoon) : fier de l'equipe
function metano_town_ch_7.Zigzagoon_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" or s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Zigzagoon_001']))
        GeneralFunctions.SetEmotion("Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Zigzagoon_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Zigzagoon_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- PNJ SECONDAIRES — Village (enrichis)
-- ============================================================

-- Relicanth (Erleuchtet) : sagesse ancienne sur les Coeurs
function metano_town_ch_7.Relicanth_Action(chara, activator)
    local s = Ch7State()
    if s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_106']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Relicanth_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Relicanth_001']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Relicanth_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Relicanth_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Relicanth_004']))
        GeneralFunctions.SetEmotion("Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Relicanth_005']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Relicanth_006']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Zhayn (Bisharp) : le chef de la police s'interesse aux ruines
function metano_town_ch_7.Bisharp_Action(chara, activator)
    local s = Ch7State()
    if s == "post_genesis" or s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_104']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Bisharp_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Bisharp_001']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Bisharp_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Bisharp_003']))
        GeneralFunctions.SetEmotion("Determined")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Bisharp_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Bisharp_005']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Lotus (Ledian) : entrainement avance
function metano_town_ch_7.Ledian_Action(chara, activator)
    local s = Ch7State()
    if s == "post_genesis" or s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_102']), "Surprised")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Ledian_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Ledian_001']))
        GeneralFunctions.SetEmotion("Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Ledian_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Ledian_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- PNJ MINEURS — Enrichis avec les nouveaux paliers
-- ============================================================

-- Vileplume (Bogen) : fleuriste, s'inquiete pour ses plantes
function metano_town_ch_7.Vileplume_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Vileplume', 7) then return end
    local s = Ch7State()
    if s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_112']), "Worried")
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_090']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Vileplume_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Vileplume_001']))
        GeneralFunctions.SetEmotion("Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Vileplume_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Vileplume_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Gulpin (Boosmu) : toujours affame, commente les rumeurs
function metano_town_ch_7.Gulpin_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Gulpin', 7) then return end
    local s = Ch7State()
    if s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_100']), "Surprised")
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Gulpin_001']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_081']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Gulpin_002']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Lickitung (Urgil) : gourmet, interesse par le cafe
function metano_town_ch_7.Lickitung_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Lickitung', 7) then return end
    local s = Ch7State()
    if s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_113']), "Worried")
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_101']), "Normal")
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_096']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Lickitung_001']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Nidoqueen (Monna) : protege son foyer
function metano_town_ch_7.Nidoqueen_Action(chara, activator)
    local s = Ch7State()
    if s == "post_genesis" or s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_104']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Nidoqueen_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Nidoqueen_001']))
        GeneralFunctions.SetEmotion("Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Nidoqueen_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Nidoqueen_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Mawile (Bria) : commere du village
function metano_town_ch_7.Mawile_Action(chara, activator)
    local s = Ch7State()
    if s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_110']), "Worried")
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Mawile_001']))
        GeneralFunctions.SetEmotion("Surprised")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Mawile_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_107']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Mawile_003']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Mawile_004']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Floatzel (Tweed) : pecheur, a vu des choses etranges
function metano_town_ch_7.Floatzel_Action(chara, activator)
    local s = Ch7State()
    if s == "post_genesis" or s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_108']), "Determined")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_098']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_098']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Floatzel_001']))
        GeneralFunctions.SetEmotion("Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Floatzel_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Floatzel_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Quagsire (Maris) : calme, rassurante
function metano_town_ch_7.Quagsire_Action(chara, activator)
    local s = Ch7State()
    if s == "post_genesis" or s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_103']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_108']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_093']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Quagsire_001']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Nidorina (Dottir) : jeune, admire l'equipe
function metano_town_ch_7.Nidorina_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Nidorina', 7) then return end
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" or s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Nidorina_001']))
        GeneralFunctions.SetEmotion("Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Nidorina_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Nidorina_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Electrike (Trilec) : sensible aux energies
function metano_town_ch_7.Electrike_Action(chara, activator)
    local s = Ch7State()
    if s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_112']), "Shock")
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_106']), "Surprised")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Electrike_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_077']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Electrike_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Electrike_001']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Electrike_002']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Machamp (Savran) : fier de la releve
function metano_town_ch_7.Machamp_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Machamp', 7) then return end
    local s = Ch7State()
    if s == "post_genesis" or s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_105']), "Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Machamp_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Machamp_001']))
        GeneralFunctions.SetEmotion("Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Machamp_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Machamp_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- Team Dazzling (enrichis)
-- ============================================================
function metano_town_ch_7.Adagio_Action(chara, activator)
    local s = Ch7State()
    if s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_111']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_099']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_104']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Adagio_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Adagio_001']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Adagio_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Adagio_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_7.Aria_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Aria_001']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Aria_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_109']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Aria_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Aria_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_7.Sonata_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Sonata_001']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Sonata_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_110']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Sonata_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- NOUVEAUX PNJ — 30 fonctions additionnelles utilisant MT7_077-113
-- ============================================================

-- Butterfree (Papilusion) : reaction de la guilde
function metano_town_ch_7.Butterfree_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_094']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_089']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_082']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_085']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "L'expedition vous attend.[pause=15] Allez voir Phileas.", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Venipede (Chenipent) : le petit sauve de la foret
function metano_town_ch_7.Venipede_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_091']), "Inspired")
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_113']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Vous allez encore sauver quelqu'un ?[pause=20] Vous etes mes heros !", "Happy")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Luxray
function metano_town_ch_7.Luxray_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Luxray', 7) then return end
    local s = Ch7State()
    if s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_101']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_106']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_099']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Je sens quelque chose.[pause=20] Une ombre.[pause=30] Restez sur vos gardes.", "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Manectric
function metano_town_ch_7.Manectric_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Manectric', 7) then return end
    local s = Ch7State()
    if s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_092']), "Surprised")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_097']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_087']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Electrike est nerveux.[pause=25] Il sent toujours les choses avant moi.", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Bellossom
function metano_town_ch_7.Bellossom_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Bellossom', 7) then return end
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_090']), "Joyous")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_078']), "Sad")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "La saison est magnifique ![pause=10] Profitons-en tant que ca dure.", "Happy")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Gloom
function metano_town_ch_7.Gloom_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Gloom', 7) then return end
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_089']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_078']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Je bave quand je suis stresse...[pause=30] Et la,[pause=10] je bave beaucoup.", "Sad")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Oddish
function metano_town_ch_7.Oddish_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Oddish', 7) then return end
    local s = Ch7State()
    if s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_091']), "Inspired")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_081']), "Surprised")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "On raconte des choses bizarres sur les ruines.[pause=25] Ca fait peur.", "Worried")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Numel
function metano_town_ch_7.Numel_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_091']), "Inspired")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_085']), "Angry")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Pourquoi c'est toujours les memes qui se battent ?[pause=20] C'est pas juste !", "Angry")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Camerupt
function metano_town_ch_7.Camerupt_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_097']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_098']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_087']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Numel est impatient.[pause=20] Il admire les equipes d'aventuriers.", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Meditite
function metano_town_ch_7.Meditite_Action(chara, activator)
    local s = Ch7State()
    if s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_110']), "Worried")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_084']), "Shock")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "La meditation apaise l'esprit.[pause=25] Mais certains reves...[pause=30] resistent.", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Medicham
function metano_town_ch_7.Medicham_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Medicham', 7) then return end
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_099']), "Normal")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_080']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "L'entrainement est la cle.[pause=25] Surtout avant l'inconnu.", "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Furret
function metano_town_ch_7.Furret_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Furret', 7) then return end
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_098']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_083']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "La ville est calme aujourd'hui.[pause=25] Un peu trop calme.", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Linoone
function metano_town_ch_7.Linoone_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Linoone', 7) then return end
    local s = Ch7State()
    if s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_097']), "Normal")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_083']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "J'ai couru jusqu'aux ruines hier.[pause=20] Enfin,[pause=10] presque.", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Sentret
function metano_town_ch_7.Sentret_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Sentret', 7) then return end
    local s = Ch7State()
    if s == "post_genesis" or s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_100']), "Surprised")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_102']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_091']), "Inspired")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Je surveille les alentours ![pause=15] On ne sait jamais.", "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Wooper_Girl (Dun)
function metano_town_ch_7.Wooper_Girl_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Wooper_Girl', 7) then return end
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_093']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_088'], CH('PLAYER'):GetDisplayName()), "Inspired")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Dee dit que vous etes les plus forts ![pause=15] Moi aussi je le pense !", "Happy")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Wooper_Boy (Dee)
function metano_town_ch_7.Wooper_Boy_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Wooper_Boy', 7) then return end
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_089']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_077']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Je m'entraine tous les jours ![pause=15] Pour etre aussi fort que vous !", "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Nidoran_Male
function metano_town_ch_7.Nidoran_Male_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_091']), "Inspired")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Ma soeur dit que vous etes ses heros.[pause=20] Moi aussi je le pense.", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Nidoking
function metano_town_ch_7.Nidoking_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Nidoking', 7) then return end
    local s = Ch7State()
    if s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_092']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_097']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Protegez les votres.[pause=25] C'est tout ce qui compte.", "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Azumarill (Loaf)
function metano_town_ch_7.Azumarill_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_098']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_086']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Ma tente est toujours ouverte ![pause=15] Pour les voyageurs.", "Happy")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Roselia
function metano_town_ch_7.Roselia_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Roselia', 7) then return end
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_090']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_078']), "Sad")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Les roses sont fragiles.[pause=20] Comme la vie.", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Spinda (cafe)
function metano_town_ch_7.Spinda_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Spinda', 7) then return end
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_096']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_113']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Un jus de Baie Mepris pour vous donner du courage ?[pause=15] Il est offert !", "Happy")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Ludicolo
function metano_town_ch_7.Ludicolo_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Ludicolo', 7) then return end
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_089']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "La musique guerit l'ame ![pause=15] Dansez avec moi ?[pause=20] ...Non ?", "Happy")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Jigglypuff
function metano_town_ch_7.Jigglypuff_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Jigglypuff', 7) then return end
    local s = Ch7State()
    if s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_113']), "Sad")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_084']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Une berceuse ?[pause=15] Pour vous aider a dormir ?[pause=25] ...Non ?", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Marill
function metano_town_ch_7.Marill_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Marill', 7) then return end
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_098']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_086']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "J'aimerais pouvoir vous aider.[pause=25] Mais je suis trop petit.", "Sad")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Spheal
function metano_town_ch_7.Spheal_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_097']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Roulez, roulez ![pause=15] Enfin,[pause=10] pas moi. Vous.", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Bagon
function metano_town_ch_7.Bagon_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_091']), "Inspired")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Un jour, je volerai ![pause=15] Et je pourrai vous aider !", "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Doduo
function metano_town_ch_7.Doduo_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_099']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Courir, toujours courir.[pause=20] C'est comme ca qu'on avance.", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Metapod
function metano_town_ch_7.Metapod_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Metapod', 7) then return end
    local s = Ch7State()
    if s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_077']), "Normal")
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            "...[pause=30] (Metapod semble briller legerement.)", "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "...[pause=40] (Metapod vous fixe sans cligner.)", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Silcoon
function metano_town_ch_7.Silcoon_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Silcoon', 7) then return end
    local s = Ch7State()
    if s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_078']), "Sad")
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_089']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Papilusion est ma voisine.[pause=20] Elle parle souvent de vous.", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Mareep
function metano_town_ch_7.Mareep_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Mareep', 7) then return end
    local s = Ch7State()
    if s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_110']), "Shock")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_084']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Ma laine fait des etincelles aujourd'hui.[pause=25] C'est bizarre.", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Cranidos
function metano_town_ch_7.Cranidos_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Cranidos', 7) then return end
    local s = Ch7State()
    if s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_092']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Je vais m'entrainer plus fort ![pause=15] Vous allez voir !", "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Growlithe_Desk (accueil guilde)
function metano_town_ch_7.Growlithe_Desk_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_094']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_079']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "La guilde vous soutient.[pause=15] Toujours. N'oubliez jamais ca.", "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- SCENE : Grodoudou commente l'arrivee des Ruines dans son catalogue
-- ============================================================
function metano_town_ch_7.Legend_Merchant_Action(chara, activator)
    require 'halcyon.ground.metano_town.metano_town_legend'
    metano_town_legend.Legend_Merchant_Action(chara, activator)
end

-- ============================================================
-- SCENE : Arrivée et enquête de la légendaire Team Alakazam (Chapitre 7)
-- ============================================================
function metano_town_ch_7.AlakazamScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  -- Positionner l'équipe au sud de la place, face au nord
  GROUND:TeleportTo(hero, 540, 1040, Direction.UpRight)
  if partner ~= nil then GROUND:TeleportTo(partner, 500, 1040, Direction.UpRight) end
  GAME:MoveCamera(640, 980, 1, false)

  -- Spawner le Doyen (Tropius), Phileas (Noctowl) et la foule
  local tropius, noctowl, sentret, wooper = CharacterEssentials.MakeCharactersFromList({
    {'Tropius', 660, 930, Direction.Down},
    {'Noctowl', 610, 930, Direction.Down},
    {'Sentret', 580, 960, Direction.Right},
    {'Wooper_Boy', 700, 960, Direction.Left}
  })

  -- Spawner la légendaire Team Alakazam
  local alakazam, tyranitar, charizard = CharacterEssentials.MakeCharactersFromList({
    {'Alakazam', 640, 970, Direction.Down},
    {'Tyranitar', 600, 1000, Direction.Right},
    {'Charizard', 680, 1000, Direction.Left}
  })

  GROUND:CharSetAnim(alakazam, "Idle", true)
  GROUND:CharSetAnim(tyranitar, "Idle", true)
  GROUND:CharSetAnim(charizard, "Idle", true)

  -- L'écran s'éclaire sur le grand rassemblement de la place de Metano Town
  GAME:FadeIn(40)
  SOUND:PlayBGM('Mt. Travail.ogg', true)
  GAME:WaitFrames(40)

  -- Le duo avance vers la foule et s'arrête en retrait
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveToPosition(hero, 570, 1010, false, 1)
    GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    if partner ~= nil then
      GROUND:MoveToPosition(partner, 530, 1010, false, 1)
      GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
    end
  end)
  TASK:JoinCoroutines({coro1, coro2})
  GAME:WaitFrames(20)

  -- Dialogue d'introduction par Penticus
  UI:SetSpeaker(tropius)
  UI:WaitShowDialogue("...Voici l'état actuel de nos relevés, Doyen d'Alakazam.[pause=15] La fissure du nord s'accentue après chaque séisme.")
  GAME:WaitFrames(15)

  UI:SetSpeaker(alakazam)
  UI:WaitShowDialogue("Mmm...[pause=10] Je ressens les vibrations telluriques d'ici. L'énergie du noyau terrestre s'échappe par cette faille.")
  UI:WaitShowDialogue("Les flux d'énergie convergent tous vers les Aegis Cave. Quelque chose là-bas cherche à s'éveiller.")
  GAME:WaitFrames(15)

  -- Tyranocif intervient
  UI:SetSpeaker(tyranitar)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue("S'il le faut, je briserai la roche de mes propres mains ![pause=15] Groudon n'a pas à faire trembler nos continents.")
  GAME:WaitFrames(15)

  -- Dracaufeu approuve
  UI:SetSpeaker(charizard)
  UI:WaitShowDialogue("Et je réduirai en cendres toute obstruction.[pause=15] L'équilibre volcanique du Tunnel Ardent doit être restauré.")
  GAME:WaitFrames(15)

  -- Penticus remercie
  UI:SetSpeaker(tropius)
  UI:WaitShowDialogue("Votre assistance est inestimable, ô légendaire Team Alakazam. Nous préparons un Grand Tournoi de la Fédération ici-même pour évaluer et entraîner nos équipes locales.")
  UI:WaitShowDialogue("Nous devons être prêts pour l'expédition ultime.")
  GAME:WaitFrames(15)

  -- Alakazam se tourne vers le héros et le partenaire
  GROUND:CharAnimateTurnTo(alakazam, Direction.DownLeft, 4)
  GAME:WaitFrames(10)
  
  UI:SetSpeaker(alakazam)
  UI:WaitShowDialogue("Vous...[pause=20] Je ressens une double aura en toi, jeune héros.[pause=15] Une harmonie singulière qui n'appartient pas à ce monde.")
  GAME:WaitFrames(15)

  UI:SetSpeaker(partner)
  pcall(function()
    GROUND:CharSetEmote(partner, "shock", 1)
    GROUND:CharTurnToCharAnimated(partner, hero, 4)
  end)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue("(Une double aura ?! Comment est-ce qu'il peut ressentir cela ?!)")
  GAME:WaitFrames(15)

  GROUND:CharTurnToCharAnimated(partner, alakazam, 4)
  UI:SetSpeaker(alakazam)
  UI:WaitShowDialogue("Restez forts.[pause=15] Le chemin qui s'ouvre devant vous sera semé d'embûches, mais votre volonté peut surmonter le désastre.")
  UI:WaitShowDialogue("Nous partons vers le nord pour sécuriser le périmètre avant le début du tournoi.[pause=20] Bonne chance, petits.")
  GAME:WaitFrames(20)

  -- Team Alakazam se met en marche et s'en va vers le nord
  local depart1 = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(alakazam, Direction.Up, 150, false, 1)
    pcall(function() GAME:GetCurrentGround():RemoveTempChar(alakazam) end)
  end)
  local depart2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GROUND:MoveInDirection(tyranitar, Direction.Up, 150, false, 1)
    pcall(function() GAME:GetCurrentGround():RemoveTempChar(tyranitar) end)
  end)
  local depart3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(14)
    GROUND:MoveInDirection(charizard, Direction.Up, 150, false, 1)
    pcall(function() GAME:GetCurrentGround():RemoveTempChar(charizard) end)
  end)
  local camera_final = TASK:BranchCoroutine(function()
    GAME:MoveCamera(640, 920, 130, false)
  end)
  TASK:JoinCoroutines({depart1, depart2, depart3, camera_final})
  GAME:WaitFrames(20)

  -- Nettoyage des PNJ temporaires
  pcall(function()
    GAME:GetCurrentGround():RemoveTempChar(tropius)
    GAME:GetCurrentGround():RemoveTempChar(noctowl)
    GAME:GetCurrentGround():RemoveTempChar(sentret)
    GAME:GetCurrentGround():RemoveTempChar(wooper)
  end)

  -- Dialogue final de l'équipe
  UI:SetSpeaker(partner)
  pcall(function()
    GROUND:CharTurnToCharAnimated(partner, hero, 4)
    GROUND:CharTurnToCharAnimated(hero, partner, 4)
  end)
  GeneralFunctions.SetEmotion("Inspired")
  UI:WaitShowDialogue("Ouah...[pause=10] C'était la légendaire Team Alakazam en personne ! Ils sont tellement imposants !")
  UI:WaitShowDialogue("Et ce Grand Tournoi...[pause=15] Nous devons nous entraîner dur pour être dignes de leur faire face. C'est notre moment, {0} !", hero:GetDisplayName())
  GAME:WaitFrames(20)

  -- Sauvegarder l'état
  SV.Chapter7.AlakazamScenePlayed = true
  
  -- Fin de la cinématique
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(30)
  pcall(function()
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', CH('PLAYER'), partner.Position)
    end
    GAME:CutsceneMode(false)
  end)
  GAME:FadeIn(20)
end

-- ============================================================
-- SCENE : La Grande Réunion de la place (Chapitre 7)
-- ============================================================
function metano_town_ch_7.GreatReunion()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  -- Positionner l'équipe
  GROUND:TeleportTo(hero, 570, 1010, Direction.Right)
  if partner ~= nil then GROUND:TeleportTo(partner, 530, 1010, Direction.Right) end
  GAME:MoveCamera(640, 980, 1, false)

  -- Spawner la Guilde, Team Alakazam et Team Dazzling
  local tropius, noctowl, audino, snubbull, zigzagoon = CharacterEssentials.MakeCharactersFromList({
    {'Tropius', 660, 930, Direction.Down},
    {'Noctowl', 610, 930, Direction.Down},
    {'Audino', 610, 1040, Direction.Up},
    {'Snubbull', 640, 1040, Direction.Up},
    {'Zigzagoon', 670, 1040, Direction.Up}
  })

  local alakazam, tyranitar, charizard = CharacterEssentials.MakeCharactersFromList({
    {'Alakazam', 640, 970, Direction.Down},
    {'Tyranitar', 600, 1000, Direction.Right},
    {'Charizard', 680, 1000, Direction.Left}
  })

  local adagio, aria, sonata = CharacterEssentials.MakeCharactersFromList({
    {'Adagio', 700, 980, Direction.Left},
    {'Aria', 730, 980, Direction.Left},
    {'Sonata', 700, 1010, Direction.Left}
  })

  GROUND:CharSetAnim(alakazam, "Idle", true)
  GROUND:CharSetAnim(tyranitar, "Idle", true)
  GROUND:CharSetAnim(charizard, "Idle", true)
  GROUND:CharSetAnim(adagio, "Idle", true)
  GROUND:CharSetAnim(aria, "Idle", true)
  GROUND:CharSetAnim(sonata, "Idle", true)

  GAME:FadeIn(40)
  SOUND:PlayBGM('Mt. Travail.ogg', true)
  GAME:WaitFrames(40)

  -- Le partenaire fait son rapport
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Nous revenons de la Colline des Anciens ! Nous avons rencontré Xatu.")
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue("Il est entré en transe... et il a eu des visions d'un géant de magma s'éveillant sous la terre.[pause=15] Il a désigné Groudon comme étant au cœur des perturbations !")
  GAME:WaitFrames(20)

  -- Murmures dans la foule
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue("Des murmures d'inquiétude et de stupeur se propagent parmi les membres de la Guilde...")
  UI:SetCenter(false)
  GAME:WaitFrames(15)

  UI:SetSpeaker(adagio)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Groudon...[pause=10] Le légendaire créateur des terres. Cela dépasse de loin nos forces d'apprentis.")
  GAME:WaitFrames(15)

  UI:SetSpeaker(alakazam)
  UI:WaitShowDialogue("Mmm...[pause=15] Groudon. Cela confirme mes pires craintes. L'énergie tellurique résonne exactement comme il y a trente ans...")
  GAME:WaitFrames(15)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue("Il y a trente ans ? Que s'est-il passé à cette époque ?")
  GAME:WaitFrames(15)

  -- ALAKAZAM RACONTE L'HISTOIRE DE RESCUE TEAM (Lore légendaire)
  UI:SetSpeaker(alakazam)
  UI:WaitShowDialogue("Il y a trente ans, notre monde a traversé une crise climatique sans précédent. Des catastrophes naturelles éclataient partout... à cause d'une météorite géante approchant de notre planète.")
  UI:WaitShowDialogue("Les équipes de secours se sont mobilisées, mais la rumeur courait qu'un humain, transformé en Pokémon, était à l'origine de ce dérèglement selon la légende de Feunard...")
  GAME:WaitFrames(15)

  pcall(function()
    GROUND:CharSetEmote(partner, "shock", 1)
  end)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue("Un humain... transformé en Pokémon ?!")
  GAME:WaitFrames(15)

  UI:SetSpeaker(alakazam)
  UI:WaitShowDialogue("Oui. Ce héros a été injustement traqué comme un fugitif, fuyant à travers la Lapis Cave et le Mont Gelé pour sauver sa vie...")
  UI:WaitShowDialogue("Mais il a prouvé son innocence, a apaisé Groudon, et s'est élevé jusqu'à la Tour Céleste pour demander l'aide de Rayquaza et détruire la météorite, sauvant ainsi notre monde.")
  GAME:WaitFrames(20)

  -- Choc de la foule
  pcall(function()
    GROUND:CharSetEmote(noctowl, "shock", 1)
    GROUND:CharSetEmote(sonata, "shock", 1)
  end)
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue("Un silence pesant s'installe sur la place. Le partenaire regarde le héros avec une profonde inquiétude...")
  UI:SetCenter(false)
  GAME:WaitFrames(20)

  UI:SetSpeaker(tropius)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue("Cette légende...[pause=10] elle est donc réelle. Si les mêmes perturbations reviennent aujourd'hui, nous devons agir.")
  GAME:WaitFrames(15)

  UI:SetSpeaker(alakazam)
  UI:WaitShowDialogue("Exactement. Nous partons vers le nord pour sécuriser le périmètre de la Mine Magma.[pause=15] Préparez-vous pour le Grand Tournoi. Nous devons désigner les équipes les plus dignes pour faire face à ce cataclysme.")
  UI:WaitShowDialogue("D'ici là, restez unis.")
  GAME:WaitFrames(25)

  -- Fin de la réunion, disparition progressive
  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)

  pcall(function()
    GAME:GetCurrentGround():RemoveTempChar(tropius)
    GAME:GetCurrentGround():RemoveTempChar(noctowl)
    GAME:GetCurrentGround():RemoveTempChar(audino)
    GAME:GetCurrentGround():RemoveTempChar(snubbull)
    GAME:GetCurrentGround():RemoveTempChar(zigzagoon)
    GAME:GetCurrentGround():RemoveTempChar(alakazam)
    GAME:GetCurrentGround():RemoveTempChar(tyranitar)
    GAME:GetCurrentGround():RemoveTempChar(charizard)
    GAME:GetCurrentGround():RemoveTempChar(adagio)
    GAME:GetCurrentGround():RemoveTempChar(aria)
    GAME:GetCurrentGround():RemoveTempChar(sonata)
  end)

  -- Le partenaire emmène le héros à l'écart
  GROUND:TeleportTo(hero, 570, 1010, Direction.Left)
  GROUND:TeleportTo(partner, 530, 1010, Direction.Right)
  GAME:MoveCamera(550, 1010, 1, false)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue("{0}...[pause=15] Ce qu'a dit Alakazam...[pause=10] à propos de l'humain transformé en Pokémon...", hero:GetDisplayName())
  UI:WaitShowDialogue("Viens avec moi. On doit se parler discrètement, à l'écart du village...[pause=15] Allons sur la Colline sans Lumière.")
  GAME:WaitFrames(20)

  SV.Chapter7.GreatReunionPlayed = true

  GAME:FadeOut(false, 40)
  GAME:WaitFrames(40)

  -- Transition immédiate vers le coucher de soleil intime sur la Colline sans Lumière
  GAME:EnterGroundMap("colline_sans_lumiere", "Main_Entrance_Marker")
end







function metano_town_ch_7.Mawile_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Mawile_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Mawile_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Mawile_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Mawile_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Mawile_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Mawile_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Mawile_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Mawile_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Mawile_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Electrike_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Electrike_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Electrike_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Electrike_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Electrike_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Electrike_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Electrike_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Electrike_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Electrike_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Electrike_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Sentret_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Sentret_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Sentret_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Sentret_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Sentret_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Sentret_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Sentret_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Sentret_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Sentret_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Sentret_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Manectric_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Manectric_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Manectric_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Manectric_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Manectric_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Manectric_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Manectric_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Manectric_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Manectric_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Manectric_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Wooper_Girl_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Wooper_Girl_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Wooper_Girl_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Wooper_Girl_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Wooper_Girl_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Wooper_Girl_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Wooper_Girl_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Wooper_Girl_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Wooper_Girl_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Wooper_Girl_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Wooper_Boy_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Wooper_Boy_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Wooper_Boy_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Wooper_Boy_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Wooper_Boy_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Wooper_Boy_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Wooper_Boy_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Wooper_Boy_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Wooper_Boy_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Wooper_Boy_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Meditite_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Meditite_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Meditite_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Meditite_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Meditite_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Meditite_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Meditite_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Meditite_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Meditite_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Meditite_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Machamp_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Machamp_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Machamp_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Machamp_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Machamp_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Machamp_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Machamp_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Machamp_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Machamp_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Machamp_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Luxray_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Luxray_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Luxray_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Luxray_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Luxray_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Luxray_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Luxray_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Luxray_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Luxray_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Luxray_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Gloom_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Gloom_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Gloom_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Gloom_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Gloom_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Gloom_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Gloom_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Gloom_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Gloom_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Gloom_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Oddish_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Oddish_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Oddish_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Oddish_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Oddish_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Oddish_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Oddish_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Oddish_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Oddish_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Oddish_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Numel_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Numel_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Numel_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Numel_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Numel_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Numel_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Numel_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Numel_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Numel_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Numel_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Bellossom_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Bellossom_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Bellossom_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Bellossom_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Bellossom_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Bellossom_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Bellossom_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Bellossom_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Bellossom_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Bellossom_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Zigzagoon_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Zigzagoon_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Zigzagoon_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Zigzagoon_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Zigzagoon_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Zigzagoon_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Zigzagoon_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Zigzagoon_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Zigzagoon_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Zigzagoon_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Nidoking_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Nidoking_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Nidoking_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Nidoking_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Nidoking_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Nidoking_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Nidoking_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Nidoking_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Nidoking_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Nidoking_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Roselia_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Roselia_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Roselia_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Roselia_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Roselia_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Roselia_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Roselia_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Roselia_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Roselia_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Roselia_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Spinda_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Spinda_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Spinda_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Spinda_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Spinda_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Spinda_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Spinda_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Spinda_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Spinda_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Spinda_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Ludicolo_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Ludicolo_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Ludicolo_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Ludicolo_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Ludicolo_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Ludicolo_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Ludicolo_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Ludicolo_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Ludicolo_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Ludicolo_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Jigglypuff_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Jigglypuff_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Jigglypuff_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Jigglypuff_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Jigglypuff_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Jigglypuff_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Jigglypuff_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Jigglypuff_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Jigglypuff_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Jigglypuff_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Marill_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Marill_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Marill_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Marill_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Marill_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Marill_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Marill_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Marill_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Marill_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Marill_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Spheal_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Spheal_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Spheal_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Spheal_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Spheal_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Spheal_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Spheal_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Spheal_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Spheal_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Spheal_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Bagon_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Bagon_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Bagon_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Bagon_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Bagon_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Bagon_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Bagon_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Bagon_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Bagon_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Bagon_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Doduo_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Doduo_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Doduo_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Doduo_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Doduo_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Doduo_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Doduo_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Doduo_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Doduo_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Doduo_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Metapod_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Metapod_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Metapod_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Metapod_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Metapod_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Metapod_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Metapod_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Metapod_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Metapod_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Metapod_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Silcoon_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Silcoon_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Silcoon_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Silcoon_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Silcoon_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Silcoon_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Silcoon_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Silcoon_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Silcoon_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Silcoon_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Mareep_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Mareep_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Mareep_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Mareep_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Mareep_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Mareep_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Mareep_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Mareep_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Mareep_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Mareep_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Cranidos_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Cranidos_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Cranidos_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Cranidos_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Cranidos_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Cranidos_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Cranidos_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Cranidos_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Cranidos_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Cranidos_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Growlithe_Desk_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Growlithe_Desk_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Growlithe_Desk_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Growlithe_Desk_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Growlithe_Desk_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Growlithe_Desk_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Growlithe_Desk_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Growlithe_Desk_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Growlithe_Desk_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Growlithe_Desk_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Butterfree_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Butterfree_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Butterfree_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Butterfree_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Butterfree_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Butterfree_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Butterfree_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Butterfree_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Butterfree_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Butterfree_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Venipede_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Venipede_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Venipede_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Venipede_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Venipede_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Venipede_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Venipede_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Venipede_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Venipede_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Venipede_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Adagio_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Adagio_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Adagio_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Adagio_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Adagio_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Adagio_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Adagio_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Adagio_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Adagio_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Adagio_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Aria_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Aria_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Aria_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Aria_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Aria_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Aria_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Aria_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Aria_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Aria_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Aria_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Sonata_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est un plaisir de vous voir en cette belle journée du Chapitre 7.", "Normal")
  UI:WaitShowDialogue("Le monde est en train de vivre un grand tournant. Avez-vous entendu les rumeurs ?")
  UI:WaitShowDialogue("La Team Alakazam mène une enquête approfondie sur les secousses telluriques.")
  UI:WaitShowDialogue("On dit que tout converge vers le nord... là où la terre brûle d'un feu ancien.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Team Alakazam", "Le Grand Tournoi", "Les visions de Xatu", "La légende humaine"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Team Alakazam... Alakazam, Tyranocif et Dracaufeu sont incroyablement imposants.")
    UI:WaitShowDialogue("Ils sont venus de la lointaine Place Pokémon pour analyser les perturbations sismiques.")
    UI:WaitShowDialogue("Alakazam a une sagesse infinie, il ressent les auras et comprend les flux de la terre.")
    UI:WaitShowDialogue("Tyranocif et Dracaufeu sont prêts à déchaîner toute leur puissance si le volcan s'éveille.")
    UI:WaitShowDialogue("Leur présence montre à quel point la situation est critique pour notre continent.")
    UI:WaitShowDialogue("Coopérez avec eux, mes amis. Ils sont la voix de la sagesse et de l'expérience.")
  elseif choice == 2 then
    UI:WaitShowDialogue("Le Grand Tournoi d'Explorateurs de la Fédération... Quelle idée fantastique !")
    UI:WaitShowDialogue("Toutes les équipes s'entraînent jour et nuit sur la place pour se préparer.")
    UI:WaitShowDialogue("Le but est de désigner les plus dignes pour assister les gardiens face aux dérèglements.")
    UI:WaitShowDialogue("La Team Dazzling et même les équipes de secours y participeront.")
    UI:WaitShowDialogue("Ne relâchez pas votre entraînement. Nous comptons tous sur vous pour briller !")
    UI:WaitShowDialogue("Ce tournoi sera un événement inoubliable pour toute la ville de Metano !")
  elseif choice == 3 then
    UI:WaitShowDialogue("Xatu... le devin qui vit au sommet du Grand Canyon.")
    UI:WaitShowDialogue("Ses yeux fixent le soleil couchant, lisant le passé, le présent et l'avenir d'un seul regard.")
    UI:WaitShowDialogue("Lors de votre rencontre, il est entré en transe et a eu des visions terrifiantes.")
    UI:WaitShowDialogue("Il a vu Groudon, le Titan de la Terre, s'agiter au cœur de sa fosse ardente !")
    UI:WaitShowDialogue("Mais Xatu insiste : Groudon n'agit pas par malveillance. Une force obscure le pousse.")
    UI:WaitShowDialogue("Cette révélation change tout... Nous devons découvrir de quoi il s'agit.")
  elseif choice == 4 then
    UI:WaitShowDialogue("La légende de l'humain transformé en Pokémon... C'est la révélation d'Alakazam.")
    UI:WaitShowDialogue("Il y a trente ans, un humain maudit a été transformé en Pokémon pour sauver le monde d'un météore.")
    UI:WaitShowDialogue("Traqué comme fugitif, il a dû fuir à travers la Lapis Cave pour prouver son innocence.")
    UI:WaitShowDialogue("Et s'il y avait un autre humain parmi nous aujourd'hui ? Serait-il traqué de la même façon ?")
    UI:WaitShowDialogue("C'est lourd d'y penser. Si quelqu'un cachait sa véritable nature, il aurait bien raison...")
    UI:WaitShowDialogue("Gardons ce secret pour nous. L'essentiel est de protéger nos amis et notre monde.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Sonata_TournamentTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous commencé à vous préparer pour le Grand Tournoi ?", "Normal")
  UI:WaitShowDialogue("Toute l'arène est en effervescence, les plus grandes équipes de secours s'y rassemblent.")
  UI:WaitShowDialogue("Les duels seront d'une intensité phénoménale. Il faudra montrer toute votre tactique.")
  UI:WaitShowDialogue("Pensez à bien choisir vos capacités, vos écharpes et vos objets de soutien.")
  UI:WaitShowDialogue("Et n'oubliez pas : l'esprit d'équipe est ce qui fait la différence face aux plus forts !")
  UI:WaitShowDialogue("Je serai au premier rang pour vous encourager, mes petits héros !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Sonata_SeismicTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Je sens la terre qui gronde... de plus en plus souvent...", "Worried")
  UI:WaitShowDialogue("Ces secousses ne sont pas ordinaires. Elles font vibrer la surface du lac d'Altere.")
  UI:WaitShowDialogue("Alakazam dit que le noyau terrestre s'agite sous l'effet de la faille du nord.")
  UI:WaitShowDialogue("Même les Pokémon sauvages des donjons deviennent nerveux à cause de cela.")
  UI:WaitShowDialogue("S'il vous plaît, découvrez la cause de ce dérèglement avant qu'il ne soit trop tard.")
  UI:WaitShowDialogue("Nous mettons toutes nos espérances entre les mains de votre équipe !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Sonata_LegendTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les anciennes légendes recèlent toujours une part de vérité...", "Normal")
  UI:WaitShowDialogue("On dit que l'humain de la légende avait une Gardevoir protectrice à ses côtés.")
  UI:WaitShowDialogue("Le lien d'amitié a transcendé la malédiction de Feunard.")
  UI:WaitShowDialogue("Si l'histoire se répète, les liens que vous tissez aujourd'hui seront vos plus grandes armes.")
  UI:WaitShowDialogue("Prenez soin les uns des autres. C'est l'essentiel d'une équipe de secours.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Sonata_ReunionTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La grande réunion sur la place m'a glacé le sang...", "Worried")
  UI:WaitShowDialogue("Voir la guilde, la Team Alakazam et la Team Dazzling débattre ainsi...")
  UI:WaitShowDialogue("On sent que le destin de toute la région se joue dans les prochains jours.")
  UI:WaitShowDialogue("Chaque habitant du village retient son souffle en attendant l'expédition.")
  UI:WaitShowDialogue("S'il vous plaît, restez forts. Nous croyons tous en vous de tout notre cœur.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Sonata_AlakazamChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'aura d'Alakazam is d'une puissance incroyable...", "Normal")
  UI:WaitShowDialogue("On sent toute la sagesse et les combats de sa vie dans son simple regard.")
  UI:WaitShowDialogue("Et parmi les membres de son équipe, qui trouvez-vous le plus impressionnant ?")
  UI:BeginChoiceMenu("Le plus imposant :", {"Alakazam", "Tyranocif", "Dracaufeu", "Tous"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Alakazam possède une force mentale et une intelligence sans égales dans le monde.")
  elseif res == 2 then
    UI:WaitShowDialogue("Tyranocif est un titan absolu de puissance brute. Il peut briser des montagnes !")
  elseif res == 3 then
    UI:WaitShowDialogue("Dracaufeu fend les cieux avec une majesté et un feu légendaires !")
  else
    UI:WaitShowDialogue("Ils forment sans doute l'équipe de secours la plus équilibrée et glorieuse d'Origins !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Sonata_XatuChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Croyez-vous aux prédictions du devin Xatu ?", "Normal")
  UI:WaitShowDialogue("Ses yeux ne clignent jamais, fixés éternellement sur la lumière céleste.")
  UI:WaitShowDialogue("Certains craignent ses paroles, d'autres y cherchent un réconfort.")
  UI:BeginChoiceMenu("Votre opinion :", {"Je crois ses visions", "Il est trop mystérieux", "Je doute"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Vous avez raison. Xatu voit ce que nous ne pouvons pas encore concevoir.")
  elseif res == 2 then
    UI:WaitShowDialogue("Ses paroles ont toujours des doubles sens qu'il faut décrypter pas à pas.")
  else
    UI:WaitShowDialogue("Le doute est permis, mais la terre gronde bien comme il l'a annoncé...")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Sonata_XatuProphecyDetail(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La transe de Xatu à la Colline des Anciens était terrifiante...", "Worried")
  UI:WaitShowDialogue("Ces visions de lave, de séismes et de la caldeira de Groudon...")
  UI:WaitShowDialogue("On sent que le destin de tout le continent s'accélère d'un coup.")
  UI:WaitShowDialogue("Mais Xatu dit vrai : ce n'est pas la volonté de Groudon, une autre force l'agite.")
  UI:WaitShowDialogue("Quelle est cette force obscure cachée au fond de l'Abîme ?")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Sonata_GreatReunionDebate(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La révélation d'Alakazam sur l'humain de la légende fait trembler la ville...", "Worried")
  UI:WaitShowDialogue("Un humain maudit par un Feunard, transformé en Pokémon pour sauver le monde...")
  UI:WaitShowDialogue("Chacun se demande s'il n'y a pas un autre humain caché parmi nous aujourd'hui.")
  UI:WaitShowDialogue("Certains s'inquiètent, d'autres y voient un signe d'espoir.")
  UI:WaitShowDialogue("Quoi qu'il en soit, nous devons rester soudés face au danger de l'Abîme.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_7.Sonata_RayquazaTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les souvenirs de Rayquaza au sommet de la Tour Céleste me hantent...", "Normal")
  UI:WaitShowDialogue("C'était un affrontement d'une majesté et d'une force absolues.")
  UI:WaitShowDialogue("Savoir que des entités d'un tel calibre veillent sur nos cieux est rassurant.")
  UI:WaitShowDialogue("Et pourtant, le déséquilibre de la terre continue de les perturber.")
  UI:WaitShowDialogue("Nous devons à tout prix les aider à préserver l'harmonie de notre monde.")
  GeneralFunctions.EndConversation(chara)
end

return metano_town_ch_7
