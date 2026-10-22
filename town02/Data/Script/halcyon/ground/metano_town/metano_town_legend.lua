--[[
    metano_town_legend.lua
    Le stand de Grodoudou — vente des zones de recrutement legendaires.

    ------------------------------------------------------------------
    SUR QUOI CE CODE S'APPUIE (aucune mecanique nouvelle)
    ------------------------------------------------------------------
    La boutique reprend exactement le squelette de metano_town.Shop_Action
    (Kecleon, init.lua:717) : boucle `while state > -1`, UI:BeginChoiceMenu,
    UI:ChoiceMenuYesNo, GAME:GetPlayerMoney / GAME:RemoveFromPlayerMoney,
    SOUND:PlayBattleSE("DUN_Money"). Seul le catalogue change : on vend des
    acces a des lieux, pas des objets, donc UI:ShopMenu (qui attend des
    InvItem) ne convient pas et on utilise UI:BeginChoiceMenu.

    Le flash blanc de validation reprend le motif exact de
    COMMON.BossTransition (common.lua:513-535), verifie present :
        RogueEssence.Content.FlashEmitter()
        emitter.Anim = RogueEssence.Content.BGAnimData("White", 0)
        GROUND:PlayVFX(emitter, center.X, center.Y)
        SOUND:PlayBattleSE("EVT_Battle_Flash")
    "White" est un BG du jeu de base, deja utilise par 20 sites d'appel du
    projet. On passe par BossFX.Flash, qui encapsule ce meme motif.

    Le voyage vers la zone reprend GAME:EnterDungeon, comme le menu de
    destination de la ville (init.lua:457).
]]--

require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.LegendZones'
require 'halcyon.BossFX'

local metano_town_legend = {}

--------------------------------------------------------------------
-- Mise en scene
--------------------------------------------------------------------

--Grodoudou se tourne vers l'equipe, heros et partenaire se tournent vers elle.
local function FaceUp(chara, hero, partner)
    chara.IsInteracting = true
    if partner ~= nil then partner.IsInteracting = true end
    GROUND:CharSetAnim(hero, 'None', true)
    if partner ~= nil then GROUND:CharSetAnim(partner, 'None', true) end
    GROUND:CharSetAnim(chara, 'None', true)
    GROUND:CharTurnToChar(hero, chara)
    if partner ~= nil then
        TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
    end
    UI:SetSpeaker(chara)
end

--Le flash blanc de validation d'achat.
--Grodoudou frappe dans ses mains, l'ecran blanchit, et le nom du lieu
--"existe" desormais. C'est la seule chose que l'achat produit : une
--connaissance, pas une capture.
local function PurchaseFlash(chara)
    local center = GAME:GetCameraCenter()
    GROUND:CharSetEmote(chara, "glowing", 1)
    SOUND:PlayBattleSE("DUN_Money")
    GAME:WaitFrames(14)
    -- BossFX.Flash encapsule FlashEmitter + BGAnimData("White", 0)
    -- + SOUND:PlayBattleSE("EVT_Battle_Flash").
    BossFX.Flash(center.X, center.Y, 2, 6, 26)
    GAME:WaitFrames(30)
    GROUND:CharSetEmote(chara, "", 0)
end

--------------------------------------------------------------------
-- Sous-menus
--------------------------------------------------------------------

--Achat d'une zone. Renvoie true si une vente a eu lieu.
local function BuyMenu(chara)
    local offers = LegendZones.GetAvailable()

    if #offers == 0 then
        GeneralFunctions.SetEmotion("Sad")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Nothing_001']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Nothing_002']))
        GeneralFunctions.SetEmotion("Normal")
        return false
    end

    local choices = {}
    for _, e in ipairs(offers) do
        table.insert(choices, STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Entry'],
            LegendZones.ZoneName(e), STRINGS:FormatKey("MONEY_AMOUNT", e.price)))
    end
    table.insert(choices, STRINGS:FormatKey("MENU_EXIT"))

    UI:BeginChoiceMenu(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Buy_Prompt']),
                       choices, 1, #choices)
    UI:WaitForChoice()
    local pick = UI:ChoiceResult()

    if pick > #offers then return false end
    local entry = offers[pick]

    -- Le boniment propre a cette zone, puis ce qu'on y verrait.
    GeneralFunctions.SetEmotion("Inspired")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[entry.blurb]))
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[entry.sight]))

    -- Rappel explicite : on achete un chemin, pas un Pokemon.
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Disclaimer'],
        LegendZones.SpeciesName(entry)))

    UI:ChoiceMenuYesNo(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Confirm'],
        LegendZones.ZoneName(entry), STRINGS:FormatKey("MONEY_AMOUNT", entry.price)), false)
    UI:WaitForChoice()
    if not UI:ChoiceResult() then
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Declined']))
        return false
    end

    if entry.price > GAME:GetPlayerMoney() then
        GeneralFunctions.SetEmotion("Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_No_Money']))
        GeneralFunctions.SetEmotion("Normal")
        return false
    end

    GAME:RemoveFromPlayerMoney(entry.price)
    LegendZones.SetPurchased(entry.key)

    -- === CINEMATIQUE D'ACHAT : FLASH BLANC ===
    PurchaseFlash(chara)

    -- Retour a la boutique, confirmation de la zone debloquee.
    UI:SetSpeaker(chara)
    GeneralFunctions.SetEmotion("Joyous")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Bought_001'],
        LegendZones.ZoneName(entry)))
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Bought_002']))
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Bought_003'],
        LegendZones.SpeciesName(entry)))
    return true
end

--Depart vers une zone deja achetee.
local function TravelMenu(chara)
    local owned = LegendZones.GetOwned()

    if #owned == 0 then
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_No_Zones']))
        return false
    end

    local choices = {}
    for _, e in ipairs(owned) do
        local label = LegendZones.ZoneName(e)
        if LegendZones.IsDefeated(e.key) then
            -- Deja vaincu une fois : on le signale sans fermer la porte,
            -- le joueur peut vouloir y retourner (recrutement rate, etc.).
            label = label .. STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Cleared_Tag'])
        end
        table.insert(choices, label)
    end
    table.insert(choices, STRINGS:FormatKey("MENU_EXIT"))

    UI:BeginChoiceMenu(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Travel_Prompt']),
                       choices, 1, #choices)
    UI:WaitForChoice()
    local pick = UI:ChoiceResult()
    if pick > #owned then return false end

    local entry = owned[pick]
    UI:ChoiceMenuYesNo(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Travel_Confirm'],
        LegendZones.ZoneName(entry)), false)
    UI:WaitForChoice()
    if not UI:ChoiceResult() then return false end

    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Travel_Go']))
    GeneralFunctions.SetEmotion("Normal")

    GeneralFunctions.EndConversation(CH('Teammate1'))
    SV.partner.Spawn = "Default"
    GAME:FadeOut(false, 30)
    -- Meme appel que le menu de destination de la ville (init.lua:457).
    if entry.cine ~= nil then
        -- Vague 7 : la revanche passe par la cinematique du gardien.
        GAME:EnterGroundMap(entry.cine, 'Main_Entrance_Marker')
        return true
    end
    GAME:EnterDungeon(entry.zone, entry.segment, 0, 0,
        RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return true
end

--Explications. Grodoudou dit clairement la regle du jeu.
local function InfoMenu()
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Info_001']))
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Info_002']))
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Info_003']))
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Info_004']))
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Info_005']))
end

--------------------------------------------------------------------
-- Point d'entree
--------------------------------------------------------------------

--------------------------------------------------------------------
-- CINEMATIQUE D'INSTALLATION DU STAND
-- Jouee UNE SEULE FOIS, au retour de l'expedition (ch5 termine), quand le
-- joueur s'approche du comptoir libre de la rangee marchande.
-- Grodoudou vient d'arriver en ville : elle deballe encore ses caisses.
--------------------------------------------------------------------
function metano_town_legend.ArrivalScene(activator)
    DEBUG.EnableDbgCoro()
    LegendZones.EnsureSV()

    -- Verrous : uniquement apres l'expedition, et une seule fois.
    if SV.LegendZones.ArrivalScenePlayed then return false end
    if not (SV.Chapter5 ~= nil and SV.Chapter5.FinishedExpedition) then return false end
    local merchant = CH('Legend_Merchant')
    if merchant == nil then return false end

    SV.LegendZones.ArrivalScenePlayed = true

    local hero = CH('PLAYER')
    local partner = CH('Teammate1')
    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end

    -- Camera sur le comptoir : le stand qui etait vide depuis toujours.
    GAME:MoveCamera(656, 1272, 40, false)
    GAME:WaitFrames(30)

    UI:ResetSpeaker(false)
    UI:SetCenter(true)
    UI:WaitShowDialogue("Le comptoir resté vide au bout de la rangée ne l'est plus.[pause=20] Des caisses, des tentures, et quelqu'un au milieu.")
    UI:SetCenter(false)
    GAME:WaitFrames(15)

    GROUND:CharSetEmote(merchant, "happy", 1)
    UI:SetSpeaker(merchant)
    GeneralFunctions.SetEmotion("Joyous")
    UI:WaitShowDialogue("Youpiii ![pause=20] Non, attendez.[pause=15] Je recommence, je n'ai pas fini d'installer.")
    GAME:WaitFrames(12)

    if partner ~= nil then
        GROUND:CharTurnToChar(partner, merchant)
        UI:SetSpeaker(partner)
        GeneralFunctions.SetEmotion("Surprised")
        UI:WaitShowDialogue("Il y a quelqu'un au vieux comptoir ![pause=20] Il était libre depuis qu'on est arrivés...")
    end

    GAME:WaitFrames(10)
    UI:SetSpeaker(merchant)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Libre, oui.[pause=20] Il m'attendait.[pause=15] Enfin, j'aime bien me le dire.")
    GeneralFunctions.SetEmotion("Joyous")
    UI:WaitShowDialogue("Grodoudou, pour vous servir ![pause=20] Je tenais une guilde, avant.[pause=15] Une vraie, avec un drapeau et tout.")
    GAME:WaitFrames(12)

    if partner ~= nil then
        UI:SetSpeaker(partner)
        GeneralFunctions.SetEmotion("Surprised")
        UI:WaitShowDialogue("Une guilde ?[pause=20] Ici, à Metano ?")
    end

    UI:SetSpeaker(merchant)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Loin d'ici.[pause=20] Et il y a longtemps.[pause=15] Les guildes ferment, vous savez.[pause=10] Les chemins, eux, restent.")
    GAME:WaitFrames(15)

    -- Le vrai sujet : elle vend des chemins, pas des objets.
    GeneralFunctions.SetEmotion("Inspired")
    UI:WaitShowDialogue("C'est ça que je vends.[pause=20] Pas des baies, pas des orbes.[pause=15] Des chemins.")
    GAME:WaitFrames(10)
    GeneralFunctions.HeroDialogue(hero, "Des chemins vers quoi ?", "Normal")
    GAME:WaitFrames(10)

    UI:SetSpeaker(merchant)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Vers les endroits où quelque chose vous attend encore.[pause=25] Vous en avez croisé un, là-haut sur le sommet.[pause=15] Ça se voit sur vous.")
    GAME:WaitFrames(12)

    if partner ~= nil then
        UI:SetSpeaker(partner)
        GeneralFunctions.SetEmotion("Worried")
        UI:WaitShowDialogue("Comment vous pouvez savoir ça ?")
    end

    UI:SetSpeaker(merchant)
    GeneralFunctions.SetEmotion("Joyous")
    UI:WaitShowDialogue("Parce que j'ai fait la même tête, autrefois ![pause=20] Youpiii !")
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Revenez me voir quand vous aurez de quoi payer.[pause=20] Et quand vous serez prêts.[pause=15] Les deux comptent.")
    GAME:WaitFrames(20)

    -- Grodoudou reprend son deballage : la ville continue.
    GROUND:CharSetEmote(merchant, "happy", 1)
    UI:ResetSpeaker(false)
    UI:SetCenter(true)
    UI:WaitShowDialogue("Elle retourne à ses caisses en fredonnant,[pause=15] comme si de rien n'était.")
    UI:SetCenter(false)

    GAME:WaitFrames(20)
    GAME:CutsceneMode(false)
    return true
end

function metano_town_legend.Legend_Merchant_Action(chara, activator)
    DEBUG.EnableDbgCoro()
    LegendZones.EnsureSV()

    local hero = CH('PLAYER')
    local partner = CH('Teammate1')
    local merchant = CH('Legend_Merchant')
    if merchant == nil then return end

    FaceUp(merchant, hero, partner)

    -- Premiere rencontre : Grodoudou se presente. Une seule fois.
    if not SV.LegendZones.MetMerchant then
        SV.LegendZones.MetMerchant = true
        GeneralFunctions.SetEmotion("Joyous")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Meet_001']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Meet_002']))
        GeneralFunctions.SetEmotion("Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Meet_003']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Meet_004']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Meet_005']))
    end

    -- GRANDE VEILLEE : les Heros d'Autrefois. Une seule fois, apres l'expedition.
    -- Grodoudou a connu l'age d'or des equipes de secours : elle raconte.
    if SV.Chapter5.FinishedExpedition and not SV.Chapter5.LegendHeroesHeard then
        UI:SetSpeaker(merchant)
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue("Alors c'est vous...[pause=0] l'équipe qui a vu la lumière du sommet.[pause=0] Youpiii...[pause=10] non,[pause=10] pardon.[pause=0] Ce n'est pas un jour à youpi.")
        UI:WaitShowDialogue("Approchez.[pause=0] Il est temps que quelqu'un vous raconte ce que les vieux de ce monde savent...[pause=10] et que les jeunes ont oublié.")
        UI:ResetSpeaker()
        UI:ChoiceMenuYesNo("Écouter les histoires des Héros d'Autrefois ?", true)
        UI:WaitForChoice()
        if UI:ChoiceResult() then
            metano_town_legend.TalesOfOldHeroes(merchant, hero, partner)
            return
        end
    end

    local state = 0
    local repeated = false

    while state > -1 do
        if state == 0 then
            local msg = STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Intro'])
            if repeated then
                msg = STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Intro_Return'])
            end
            repeated = true

            local choices = {
                STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Option_Buy']),
                STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Option_Travel']),
                STRINGS:FormatKey("MENU_INFO"),
                STRINGS:FormatKey("MENU_EXIT")
            }

            UI:BeginChoiceMenu(msg, choices, 1, #choices)
            UI:WaitForChoice()
            local result = UI:ChoiceResult()

            if result == 1 then
                state = 1
            elseif result == 2 then
                state = 2
            elseif result == 3 then
                InfoMenu()
            else
                GeneralFunctions.SetEmotion("Happy")
                UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Goodbye']))
                GeneralFunctions.SetEmotion("Normal")
                state = -1
            end

        elseif state == 1 then
            BuyMenu(merchant)
            state = 0

        elseif state == 2 then
            -- Si le voyage part, EnterDungeon a deja pris la main.
            if TravelMenu(merchant) then return end
            state = 0
        end
    end

    GeneralFunctions.EndConversation(partner)
    merchant.IsInteracting = false
end

--------------------------------------------------------------------
-- CINÉMATIQUE MAJEURE — « Les Héros d'Autrefois » (Grodoudou)
-- Hommage direct aux anciens Pokémon Donjon Mystère, raconté comme la
-- mémoire vivante du monde : la météorite (Rescue Team), le temps arrêté
-- et l'humain devenu Pokémon (Explorers of Sky), puis 25 ans de calme...
-- jusqu'à la lumière du sommet. C'est la charnière : l'expédition du
-- joueur devient l'héritière de ces légendes.
-- OST : Welcome to the World of Pokémon! -> Time Gear Remix ->
--       Growing Anxiety -> Guildmaster Wigglytuff (chute tendre).
--------------------------------------------------------------------
function metano_town_legend.TalesOfOldHeroes(merchant, hero, partner)
    GAME:CutsceneMode(true)
    AI:DisableCharacterAI(partner)
    SOUND:FadeOutBGM(60)
    GAME:WaitFrames(50)

    -- ACTE 1 : la meteorite (echo Rescue Team).
    SOUND:PlayBGM('Welcome to the World of Pokémon!.ogg', true)
    GAME:WaitFrames(40)

    UI:SetSpeaker(merchant)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Il y a bien des années...[pause=20] bien avant votre naissance...[pause=10] une étoile est tombée du ciel.")
    UI:WaitShowDialogue("Pas une étoile filante,[pause=10] non.[pause=0] Une MÉTÉORE.[pause=0] Si vaste qu'elle aurait effacé le monde entier en touchant le sol.")
    GAME:WaitFrames(20)
    GROUND:CharSetEmote(merchant, "glowing", 1)
    UI:WaitShowDialogue("Les catastrophes se multipliaient déjà partout :[pause=10] séismes,[pause=10] famines,[pause=10] Pokémon sauvages devenus fous...[pause=0][br]Le monde était détraqué,[pause=10] et personne ne savait pourquoi.")
    UI:WaitShowDialogue("Et au milieu de tout ça,[pause=10] une toute petite équipe de secours.[pause=0] Deux amis.[pause=0] On raconte que l'un des deux...[pause=20] n'était pas né Pokémon.")

    if partner ~= nil then
        GROUND:CharSetEmote(partner, "shock", 1)
        SOUND:PlayBattleSE("EVT_Emote_Shock_2")
        UI:SetSpeaker(partner)
        GeneralFunctions.SetEmotion("Surprised")
        UI:WaitShowDialogue("Pas né Pokémon ?[pause=0] Qu'est-ce que ça veut dire,[pause=10] «[pause=5] pas né Pokémon[pause=5] » ?")
    end

    UI:SetSpeaker(merchant)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Un HUMAIN,[pause=10] mon petit.[pause=0] Une créature d'un autre monde,[pause=10] réveillée un matin dans un corps de Pokémon,[pause=10] sans aucun souvenir.")
    UI:WaitShowDialogue("Avec son fidèle ami,[pause=10] ils ont secouru des centaines des nôtres.[pause=0] Ils ont gravi une montagne interdite.[pause=0] Ils ont parlé au maître du ciel lui-même.")
    UI:WaitShowDialogue("Et la météore...[pause=20] fut réduite en poussière à quelques instants de la fin.[pause=0][br]La pluie d'étoiles qui a suivi...[pause=10] les anciens en parlent encore les larmes aux yeux.")

    GAME:WaitFrames(30)
    GeneralFunctions.HeroDialogue(hero, "(Un humain...[pause=10] devenu Pokémon...[pause=0] Pourquoi est-ce que mon cœur bat si fort d'un coup ?)", "Surprised")

    -- ACTE 2 : le temps arrete (echo Explorers of Sky).
    SOUND:FadeOutBGM(40)
    GAME:WaitFrames(40)
    SOUND:PlayBGM('Time Gear Remix.ogg', true)
    GAME:WaitFrames(30)

    UI:SetSpeaker(merchant)
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue("Une autre fois...[pause=20] c'est le temps lui-même qui s'est arrêté.")
    UI:WaitShowDialogue("Pas partout d'un coup,[pause=10] non.[pause=0] Région par région.[pause=0] Les vagues figées en pleine écume.[pause=0][br]La pluie suspendue entre ciel et terre.[pause=0] Les Pokémon...[pause=10] immobiles,[pause=10] à jamais.")
    GAME:WaitFrames(20)
    UI:WaitShowDialogue("Et encore une fois...[pause=10] un humain réincarné en Pokémon.[pause=0] Venu du futur,[pause=10] disent certains.[pause=0] Un futur où tout était déjà perdu.")
    UI:WaitShowDialogue("Avec son fidèle ami,[pause=10] ils sont montés au sommet d'une tour qui touchait le ciel brisé.[pause=0] Et là-haut...[pause=20] ils ont rendu au monde son battement.")
    GAME:WaitFrames(20)
    GeneralFunctions.SetEmotion("Sad")
    UI:WaitShowDialogue("On raconte que le prix payé fut...[pause=20] immense.[pause=0] Que le héros s'est effacé avec le futur qu'il venait empêcher.")
    UI:WaitShowDialogue("Mais on raconte AUSSI...[pause=10] que le monde,[pause=10] reconnaissant,[pause=10] le lui a rendu.[pause=0] Je préfère cette fin-là.[pause=0] Je choisis toujours cette fin-là.")

    if partner ~= nil then
        GAME:WaitFrames(20)
        UI:SetSpeaker(partner)
        GeneralFunctions.SetEmotion("Teary-Eyed")
        UI:WaitShowDialogue("Moi aussi...[pause=10] je choisis cette fin-là.")
    end

    -- ACTE 3 : 25 ans de calme... et maintenant.
    SOUND:FadeOutBGM(40)
    GAME:WaitFrames(40)
    SOUND:PlayBGM('Growing Anxiety.ogg', true)
    GAME:WaitFrames(20)

    UI:SetSpeaker(merchant)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Il y a eu d'autres grands cataclysmes,[pause=10] d'autres héros.[pause=0] Les mers en furie.[pause=0][br]L'espace déchiré.[pause=0] Chaque génération a eu son épreuve...[pause=10] et son équipe de deux.")
    GAME:WaitFrames(20)
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue("Puis...[pause=20] plus rien.[pause=0] Vingt-cinq ans de calme.[pause=0] Vingt-cinq ans sans étoile qui tombe,[pause=10] sans temps qui bégaie,[pause=10] sans mer qui gronde.")
    UI:WaitShowDialogue("Les vieux comme moi ont fini par croire que le monde avait épuisé ses malheurs.[pause=0] Que les histoires de héros resteraient...[pause=10] des histoires.")
    GAME:WaitFrames(30)
    UI:WaitShowDialogue("Et voilà qu'une lumière tremble au sommet d'une montagne.[pause=0] Et voilà qu'une voix murmure dans les herbes.[pause=0] Et voilà que VOUS passez ma porte.")
    GAME:WaitFrames(20)
    UI:WaitShowDialogue("Vingt-cinq ans,[pause=10] mes petits.[pause=0] Le calme n'était pas la fin des histoires.[pause=0] C'était...[pause=20] une très longue inspiration.")

    GAME:WaitFrames(30)
    GeneralFunctions.HeroDialogue(hero, "(Chaque génération a eu son épreuve.[pause=0] Et son équipe de deux...)", "Worried")

    if partner ~= nil then
        UI:SetSpeaker(partner)
        GeneralFunctions.SetEmotion("Worried")
        UI:WaitShowDialogue("Grodoudou...[pause=0] vous êtes en train de dire que...[pause=10] que c'est NOTRE tour ?")
    end

    -- Chute tendre : Grodoudou redevient elle-meme.
    SOUND:FadeOutBGM(40)
    GAME:WaitFrames(40)
    SOUND:PlayBGM('Guildmaster Wigglytuff.ogg', true)
    GAME:WaitFrames(20)

    UI:SetSpeaker(merchant)
    GeneralFunctions.SetEmotion("Happy")
    UI:WaitShowDialogue("Ce que je dis,[pause=10] c'est que les héros d'autrefois avaient tous DEUX choses :[pause=10] un ami fidèle...[pause=10] et un très bon fournisseur d'équipement.")
    GAME:WaitFrames(15)
    GeneralFunctions.SetEmotion("Joyous")
    UI:WaitShowDialogue("L'ami,[pause=10] vous l'avez déjà ![pause=0] Et pour le reste...[pause=10] youpiii ![pause=0] Vous connaissez mon stand !")

    if partner ~= nil then
        GROUND:CharSetEmote(partner, "sweatdrop", 1)
        UI:SetSpeaker(partner)
        GeneralFunctions.SetEmotion("Stunned")
        UI:WaitShowDialogue("...Et voilà.[pause=0] Le moment était PRESQUE solennel.")
    end

    UI:SetSpeaker(merchant)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Le solennel,[pause=10] c'est pour les statues,[pause=10] mon petit.[pause=0] Les vivants,[pause=10] eux,[pause=10] doivent rire ET se préparer.[pause=0] Les deux.[pause=0] Toujours les deux.")
    GAME:WaitFrames(20)
    UI:WaitShowDialogue("Allez.[pause=0] Revenez me voir quand vous voulez.[pause=0] Et si un jour le ciel vous semble trop lourd...[pause=10][br]rappelez-vous :[pause=10] d'autres l'ont porté avant vous.[pause=0] À deux.[pause=0] Et ils ont tenu.")

    SV.Chapter5.LegendHeroesHeard = true
    GAME:WaitFrames(30)
    SOUND:FadeOutBGM(60)
    GAME:WaitFrames(30)
    GAME:CutsceneMode(false)
    AI:EnableCharacterAI(partner)
    AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
    if SV.metano_town.Song ~= nil and SV.metano_town.Song ~= "" then
        SOUND:PlayBGM(SV.metano_town.Song, true)
    end
end

return metano_town_legend
