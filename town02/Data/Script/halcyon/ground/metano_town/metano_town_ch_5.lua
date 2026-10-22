--[[
    metano_town_ch_5.lua
    Chapitre 5 : L'Expedition — 25 fonctions, 6 paliers
]]
require 'origin.common'; require 'halcyon.PartnerEssentials'; require 'halcyon.GeneralFunctions'; require 'halcyon.CharacterEssentials'
metano_town_ch_5 = {}
local function Ch5State()
    if SV.Chapter5.FinishedExpedition then return "post_expedition"
    elseif SV.Chapter5.FinishedMountWindsweptIntro then return "mount_windswept"
    elseif SV.Chapter5.FinishedTunnelIntro then return "searing_tunnel"
    elseif SV.Chapter5.FinishedSteppeIntro then return "vast_steppe"
    elseif SV.Chapter5.ReadyForExpedition then return "ready"
    elseif SV.Chapter5.FinishedExpeditionAddress then return "pre_expedition"
    else return "early" end
end
function metano_town_ch_5.SetupGround()
    GROUND:Hide('Swap_Owner');GROUND:Hide('Swap');GROUND:Hide('Red_Merchant');GROUND:Hide('Green_Merchant');GROUND:Hide('Cave_Entrance');GAME:FadeIn(20)
end
function metano_town_ch_5.Noctowl_Action(chara, activator)
    local s = Ch5State()
    if s=="early" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Noctowl_001']));GeneralFunctions.SetEmotion("Normal");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Noctowl_002']));GeneralFunctions.EndConversation(chara)
    elseif s=="pre_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Noctowl_003']));GeneralFunctions.SetEmotion("Worried");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Noctowl_004']));GeneralFunctions.SetEmotion("Normal");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Noctowl_005']));GeneralFunctions.EndConversation(chara)
    elseif s=="ready" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Noctowl_006']));GeneralFunctions.SetEmotion("Determined");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Noctowl_007']));GeneralFunctions.EndConversation(chara)
    elseif s=="vast_steppe" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Noctowl_008']));GeneralFunctions.SetEmotion("Normal");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Noctowl_009']));GeneralFunctions.EndConversation(chara)
    elseif s=="searing_tunnel" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Noctowl_010']));GeneralFunctions.SetEmotion("Worried");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Noctowl_011']));GeneralFunctions.EndConversation(chara)
    elseif s=="mount_windswept" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Noctowl_012']));GeneralFunctions.SetEmotion("Determined");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Noctowl_013']));GeneralFunctions.EndConversation(chara)
    else GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Noctowl_014']),"Happy");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Noctowl_015']))
        --Foreshadowing du twist Necrozma (arcs 3-5) : Phileas a analyse les pulses.
        --« Tenir fermé » — la verite enoncee 20 chapitres avant sa revelation.
        if SV.Chapter5.SkyTremorSceneSeen then
            GAME:WaitFrames(20)
            GeneralFunctions.SetEmotion("Worried")
            UI:WaitShowDialogue("Hou...[pause=0] Une dernière chose.[pause=0] J'ai reporté les pulses de la montagne sur un registre.[pause=0] Heure par heure,[pause=10] depuis la steppe.")
            UI:WaitShowDialogue("Ils ne sont pas réguliers.[pause=0] Ils FAIBLISSENT.[pause=0] Chaque pulse un peu plus espacé,[pause=10] un peu plus court que le précédent.")
            UI:WaitShowDialogue("Or une chose qui appelle crie de plus en plus fort.[pause=0] Une chose qui attaque frappe de plus en plus vite.[pause=0] Mais une chose qui faiblit ainsi...")
            GAME:WaitFrames(30)
            GROUND:CharSetEmote(chara, "sweating", 1)
            UI:WaitShowDialogue("...c'est une chose qui LUTTE.[pause=0] Qui s'épuise à tenir quelque chose fermé.[pause=0] Hou.[pause=0][br]Et je n'ose pas écrire dans mon registre ce qui arrivera le jour où elle lâchera.")
        end
        GeneralFunctions.EndConversation(chara)
    end
end
function metano_town_ch_5.Tropius_Action(chara, activator)
    local s = Ch5State()
    if s=="early" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Tropius_001']),"Inspired");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Tropius_002']));GeneralFunctions.EndConversation(chara)
    elseif s=="post_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Tropius_003']),"Happy");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Tropius_004']));UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Tropius_005']));GeneralFunctions.EndConversation(chara)
    else GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Tropius_006']),"Determined");GeneralFunctions.EndConversation(chara) end
end
function metano_town_ch_5.Audino_Action(chara, activator)
    local s = Ch5State()
    if s=="early" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Audino_001']),"Worried");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Audino_002']));GeneralFunctions.EndConversation(chara)
    elseif s=="pre_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Audino_003']),"Determined");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Audino_004']));UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Audino_005']));GeneralFunctions.EndConversation(chara)
    elseif s=="post_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Audino_006']),"Happy");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Audino_007']));GeneralFunctions.EndConversation(chara)
    else GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Audino_008']),"Worried");GeneralFunctions.EndConversation(chara) end
end
function metano_town_ch_5.Snubbull_Action(chara, activator)
    local s = Ch5State()
    if s=="pre_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Snubbull_001']));GeneralFunctions.SetEmotion("Happy");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Snubbull_002']));GeneralFunctions.SetEmotion("Normal");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Snubbull_003']));GeneralFunctions.EndConversation(chara)
    elseif s=="post_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Snubbull_004']),"Inspired");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Snubbull_005']));GeneralFunctions.EndConversation(chara)
    else GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Snubbull_006']),"Normal");GeneralFunctions.EndConversation(chara) end
end
function metano_town_ch_5.Growlithe_Desk_Action(chara, activator)
    local s = Ch5State()
    if s=="pre_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Growlithe_001']),"Normal");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Growlithe_002']));UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Growlithe_003']));GeneralFunctions.EndConversation(chara)
    elseif s=="post_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Growlithe_004']),"Happy");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Growlithe_005']));GeneralFunctions.EndConversation(chara)
    else GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Growlithe_006']),"Normal");GeneralFunctions.EndConversation(chara) end
end
function metano_town_ch_5.Mawile_Action(chara, activator)
    local s = Ch5State()
    if s=="post_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Mawile_001']),"Inspired");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Mawile_002']));GeneralFunctions.EndConversation(chara)
    elseif s=="pre_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Mawile_003']),"Surprised");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Mawile_004']));GeneralFunctions.EndConversation(chara)
    else GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Mawile_005']),"Normal");GeneralFunctions.EndConversation(chara) end
end
function metano_town_ch_5.Electrike_Action(chara, activator)
    local s = Ch5State()
    if s=="post_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Electrike_001']),"Normal");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Electrike_002']));GeneralFunctions.EndConversation(chara)
    elseif s=="pre_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Electrike_003']),"Worried");GeneralFunctions.EndConversation(chara)
    else GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Electrike_004']),"Normal");GeneralFunctions.EndConversation(chara) end
end
function metano_town_ch_5.Azumarill_Action(chara, activator)
    if Ch5State()=="pre_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Azumarill_001']),"Happy");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Azumarill_002']))
    elseif Ch5State()=="post_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Azumarill_003']),"Happy")
    else GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Azumarill_004']),"Normal") end
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_5.Doduo_Action(chara, activator)
    if Ch5State()=="post_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Doduo_001']),"Happy");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Doduo_002']))
        --Amorce Escouade Fulgur (trame arc 1 : « une équipe aux yeux d'or ») — le courrier voit tout.
        GeneralFunctions.SetEmotion("Worried")
        UI:WaitShowDialogue("Ah,[pause=10] et puisque vous êtes de la guilde...[pause=0] Sur la route de la côte,[pause=10] j'ai croisé une équipe que je ne connaissais pas.[pause=0][br]Trois Pokémon.[pause=0] Des yeux d'or,[pause=10] tous les trois.")
        UI:WaitShowDialogue("Polis,[pause=10] rapides,[pause=10] très bien équipés.[pause=0] Mais ils posaient des questions bizarres.[pause=0] Pas sur les chemins,[pause=10] non.[pause=0][br]Sur les SOURCES.[pause=0] Les sources chaudes,[pause=10] les clairières qui ne gèlent jamais...")
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue("Ma deuxième tête dit que ce sont des collectionneurs.[pause=0][br]Ma première tête dit qu'on n'interroge pas les facteurs sur les sources chaudes quand on collectionne des badges.[pause=0] Enfin.[pause=0] Ce ne sont pas mes affaires.")
    else GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Doduo_003']),"Normal") end
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_5.Bagon_Action(chara, activator)
    if Ch5State()=="post_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Bagon_001']),"Inspired")
    else GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Bagon_002']),"Determined") end
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_5.Metapod_Action(chara, activator)
    if Ch5State()=="post_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Metapod_001']),"Normal")
    else GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Metapod_002']),"Normal") end
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_5.Silcoon_Action(chara, activator)
    if Ch5State()=="post_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Silcoon_001']),"Happy")
    else GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Silcoon_002']),"Normal") end
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_5.Oddish_Action(chara, activator)
    if Ch5State()=="post_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Oddish_001']),"Happy")
    else GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Oddish_002']),"Normal") end
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_5.Numel_Action(chara, activator)
    if Ch5State()=="post_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Numel_001']),"Inspired");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Numel_002']))
    else GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Numel_003']),"Determined") end
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_5.Machamp_Action(chara, activator)
    if Ch5State()=="post_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Machamp_001']),"Happy");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Machamp_002']))
    elseif Ch5State()=="pre_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Machamp_003']),"Determined")
    else GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Machamp_004']),"Normal") end
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_5.Medicham_Action(chara, activator)
    if Ch5State()=="post_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Medicham_001']),"Normal")
    else GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Medicham_002']),"Normal") end
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_5.Spheal_Action(chara, activator)
    if Ch5State()=="post_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Spheal_001']),"Happy")
    else GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Spheal_002']),"Normal") end
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_5.Marill_Action(chara, activator)
    if Ch5State()=="post_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Marill_001']),"Happy")
    else GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Marill_002']),"Sad") end
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_5.Jigglypuff_Action(chara, activator)
    if Ch5State()=="post_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Jigglypuff_001']),"Happy")
    else GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Jigglypuff_002']),"Normal") end
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_5.Nidorina_Action(chara, activator)
    if Ch5State()=="post_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Nidorina_001']),"Inspired");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Nidorina_002']))
    else GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Nidorina_003']),"Normal") end
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_5.Gloom_Action(chara, activator)
    if Ch5State()=="post_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Gloom_001']),"Happy")
        --Amorce Cercle du Suaire (trame arc 2) : menace feutree, brume, vol d'eclats.
        GeneralFunctions.SetEmotion("Worried")
        UI:WaitShowDialogue("...Dites.[pause=0] Vous qui êtes de la guilde.[pause=0] C'est normal,[pause=10] la brume qui traîne près de la source chaude,[pause=10] ces derniers matins ?")
        UI:WaitShowDialogue("Mes fleurs fanent de ce côté-là.[pause=0] SEULEMENT de ce côté-là.[pause=0] Et avant-hier,[pause=10] à l'aube...[pause=10][br]j'ai cru voir trois silhouettes dedans.[pause=0] Immobiles.[pause=0] Comme si elles écoutaient le sol.")
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue("Quand j'ai cligné des yeux,[pause=10] plus rien.[pause=0] Juste la brume.[pause=0] Et une odeur...[pause=10] d'encens froid.[pause=0] Enfin.[pause=0] Je dors mal en ce moment,[pause=10] c'est sûrement ça.")
    else GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Gloom_002']),"Normal") end
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_5.Zigzagoon_Action(chara, activator)
    local s = Ch5State()
    if s=="pre_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Zigzagoon_001']));GeneralFunctions.SetEmotion("Determined");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Zigzagoon_002']));GeneralFunctions.SetEmotion("Happy");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Zigzagoon_003']));GeneralFunctions.EndConversation(chara)
    elseif s=="post_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Zigzagoon_004']),"Inspired");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Zigzagoon_005']));UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Zigzagoon_006']));GeneralFunctions.EndConversation(chara)
    else GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Zigzagoon_007']),"Normal");GeneralFunctions.EndConversation(chara) end
end
function metano_town_ch_5.Cranidos_Action(chara, activator)
    local s = Ch5State()
    if s=="pre_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Cranidos_001']),"Determined");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Cranidos_002']));GeneralFunctions.EndConversation(chara)
    elseif s=="post_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Cranidos_003']),"Normal");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Cranidos_004']));GeneralFunctions.EndConversation(chara)
    else GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Cranidos_005']),"Normal");GeneralFunctions.EndConversation(chara) end
end
function metano_town_ch_5.Mareep_Action(chara, activator)
    if Ch5State()=="post_expedition" then GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Mareep_001']),"Happy");UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_Mareep_002']))
    else GeneralFunctions.StartConversation(chara,STRINGS:Format(STRINGS.MapStrings['MT5_Mareep_003']),"Normal") end
    GeneralFunctions.EndConversation(chara)
end
return metano_town_ch_5
