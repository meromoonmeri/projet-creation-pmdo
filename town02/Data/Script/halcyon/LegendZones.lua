--[[
    LegendZones.lua
    Zones de recrutement des Pokemon fabuleux et legendaires.

    ------------------------------------------------------------------
    REGLE NARRATIVE (lecture 1, retenue et confirmee)
    ------------------------------------------------------------------
    La regle du projet reste intacte : un legendaire n'apparait JAMAIS en
    rencontre aleatoire. Acheter une zone chez Grodoudou ne fait pas
    apparaitre le legendaire dans la nature et ne le donne pas non plus.

    Elle ouvre une seule chose : le droit de RETOURNER l'affronter, dans
    son propre lieu, une fois que l'histoire l'a deja presente.
    Trois verrous en serie, dans cet ordre :

       1. verrou d'histoire  -> le legendaire doit avoir ete rencontre
                                dans le scenario (champ `flag`).
                                C'est ce qui met la zone EN VENTE.
       2. verrou marchand    -> la zone doit avoir ete achetee
       3. verrou de combat   -> il faut aller le vaincre sur place

    Tant que le verrou 1 n'est pas leve, la zone n'est meme pas proposee :
    Grodoudou n'a "pas encore entendu parler" du lieu. C'est la regle
    demandee : chaque fois qu'on rencontre un legendaire dans l'histoire,
    sa zone devient achetable.

    ------------------------------------------------------------------
    STRUCTURE D'UNE ENTREE
    ------------------------------------------------------------------
      key      identifiant interne, cle dans SV.LegendZones.*
      species  espece PMDO. Les 25 especes listees ici ont ete verifiees
               presentes dans Data/Misc/MonsterFeature.json (1011 entrees).
      name     cle .resx du nom de la zone (EN + FR)
      blurb    cle .resx du boniment de Grodoudou pour cette zone
      sight    cle .resx de la description du lieu (ce qu'on y voit)
      price    prix en Poke (monnaie standard : GAME:GetPlayerMoney)
      flag     fonction -> true si l'histoire a deja presente ce
               legendaire. C'est le verrou 1.
      zone     identifiant de donjon a rejoindre
      segment  segment de ce donjon contenant l'arene de revanche
      roam     true  = le legendaire se deplace dans sa zone une fois
                       vaincu et recrute (comportement errant)
               false = il attend sur place
      ready    true  = la chaine complete existe et est jouable
               false = le chapitre correspondant n'est pas encore ecrit ;
                       l'entree est un contrat pour plus tard et n'est
                       JAMAIS listee en boutique.

    Ne jamais passer `ready = true` sans avoir verifie les trois points :
      (a) le segment existe dans Data/Zone/<zone>.json
      (b) la .rsmap de l'arene existe et son occupant n'est PAS Unrecruitable
      (c) ExitSegment de zone/<zone>/init.lua gere ce numero de segment
]]--

require 'origin.common'

LegendZones = {}

LegendZones.LIST = {
    ------------------------------------------------------------------
    -- JOUABLES AUJOURD'HUI (restaures le 2026-08-06 : la purge de la
    -- reduction les avait emportes par erreur).
    ------------------------------------------------------------------
    {
        key = 'verdant_oath', species = 'zeraora',
        name = 'LZ_Name_Verdant_Oath', blurb = 'LZ_Blurb_Verdant_Oath',
        sight = 'LZ_Sight_Verdant_Oath', price = 15000,
        -- Pose par zone/gloomy_forest/init.lua (segment 4, victoire).
        flag = function() return SV.Chapter6 ~= nil and SV.Chapter6.DefeatedGloomyBoss == true end,
        zone = 'gloomy_forest', segment = 5, roam = true, ready = true
    },
    {
        key = 'colossus_quarry', species = 'regigigas',
        name = 'LZ_Name_Colossus_Quarry', blurb = 'LZ_Blurb_Colossus_Quarry',
        sight = 'LZ_Sight_Colossus_Quarry', price = 22000,
        -- Segment 7 = Sanctuaire des Titans (Regigigas). CORRIGE : la
        -- version d'origine pointait le segment 5 (arene de Registeel).
        flag = function() return SV.Chapter5 ~= nil and SV.Chapter5.SawAnimaCoreCorruption == true end,
        zone = 'cloven_ruins', segment = 7, roam = false, ready = true
    },
    ------------------------------------------------------------------
    -- JOUABLE AUJOURD'HUI
    ------------------------------------------------------------------
}

--------------------------------------------------------------------
-- Etat de sauvegarde
--------------------------------------------------------------------
-- SV.LegendZones est declare dans scriptvars.lua. Ce garde-fou couvre les
-- sauvegardes creees AVANT l'ajout du systeme : sans lui, toute partie
-- existante planterait a la premiere interaction avec le stand.
function LegendZones.EnsureSV()
    if SV.LegendZones == nil then
        SV.LegendZones = { Purchased = {}, Defeated = {}, MetMerchant = false }
    end
    if SV.LegendZones.Purchased == nil then SV.LegendZones.Purchased = {} end
    if SV.LegendZones.Defeated  == nil then SV.LegendZones.Defeated  = {} end
end

function LegendZones.IsPurchased(key)
    LegendZones.EnsureSV()
    return SV.LegendZones.Purchased[key] == true
end

function LegendZones.SetPurchased(key)
    LegendZones.EnsureSV()
    SV.LegendZones.Purchased[key] = true
end

--Le legendaire a-t-il ete vaincu dans sa zone ?
function LegendZones.IsDefeated(key)
    LegendZones.EnsureSV()
    return SV.LegendZones.Defeated[key] == true
end

function LegendZones.SetDefeated(key)
    LegendZones.EnsureSV()
    SV.LegendZones.Defeated[key] = true
end

function LegendZones.Get(key)
    for _, entry in ipairs(LegendZones.LIST) do
        if entry.key == key then return entry end
    end
    return nil
end

--Verrou 1 : l'histoire a-t-elle deja presente ce legendaire ?
--pcall protege des flags dont la table SV n'existe pas encore.
function LegendZones.StoryUnlocked(entry)
    if entry.ready ~= true then return false end
    local ok, result = pcall(entry.flag)
    return ok and result == true
end

--Zones que Grodoudou peut proposer aujourd'hui.
function LegendZones.GetAvailable()
    local out = {}
    for _, entry in ipairs(LegendZones.LIST) do
        if LegendZones.StoryUnlocked(entry) and not LegendZones.IsPurchased(entry.key) then
            table.insert(out, entry)
        end
    end
    return out
end

--Zones deja achetees : Grodoudou peut y conduire l'equipe.
function LegendZones.GetOwned()
    local out = {}
    for _, entry in ipairs(LegendZones.LIST) do
        if LegendZones.IsPurchased(entry.key) and entry.ready then
            table.insert(out, entry)
        end
    end
    return out
end

function LegendZones.ZoneName(entry)
    return STRINGS:Format(STRINGS.MapStrings[entry.name])
end

--Nom colore de l'espece, tel que le jeu l'affiche partout ailleurs.
function LegendZones.SpeciesName(entry)
    return _DATA:GetMonster(entry.species):GetColoredName()
end

return LegendZones
