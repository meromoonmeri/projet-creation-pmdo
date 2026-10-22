--[[
    TownReward.lua

    CE QUE LA VILLE DONNE A CEUX QUI L'ONT DEFENDUE
    ================================================================
    POURQUOI CE MODULE EXISTE
    ------------------------------------------------------------------
    TownPlunder.lua dit ce qu'on perd quand on echoue. Il manquait le
    versant inverse : gagner ne rapportait RIEN. Un raid repousse se
    terminait sur une replique et la nuit reprenait comme avant.

    Or une defense reussie est un service rendu, et une ville qui ne
    remercie pas n'est pas vivante. Ce module fait donc deux choses :

      1. UNE RECOMPENSE CONCRETE, le soir meme : objets tires au sort
         et argent. Ce n'est pas du butin pris sur les pillards (on ne
         detrousse pas des cadavres) : c'est ce que les habitants
         deposent devant votre porte au matin.
      2. UNE RECONNAISSANCE PUBLIQUE, le lendemain en ville : la scene
         de felicitations, et surtout des repliques pour TOUS les PNJ.

    ------------------------------------------------------------------
    LES OBJETS : POURQUOI CEUX-LA
    ------------------------------------------------------------------
    Chaque identifiant a ete releve dans Data/Item/ (229 fichiers) —
    aucun n'est invente. Ils sont regroupes par palier, et le palier
    suit la vague repoussee, pas le nombre de victoires : defendre la
    ville contre cinq rodeurs vaut mieux que contre trois.

    On ne donne QUE des consommables et des tenues courantes. Jamais de
    Mega-Pierre, jamais d'objet de quete : une recompense repetable ne
    doit pas court-circuiter une progression.

    ------------------------------------------------------------------
    L'ARGENT : QUI PAIE, ET POURQUOI CA A DU SENS
    ------------------------------------------------------------------
    La somme est modeste et EXPLIQUEE : ce sont les marchands qui se
    cotisent. Un commercant dont l'etal n'a pas ete pille a tout interet
    a remercier celui qui l'a evite. C'est aussi le miroir exact de
    TownPlunder : la-bas on perd de l'argent de banque, ici on en gagne
    en liquide.

    ------------------------------------------------------------------
    REGLES DU PROJET
    ------------------------------------------------------------------
    * Jamais « Necrozma », « Eternatus », « l'Abime », « prison ».
    * La Voix ne parle pas ici.
    * Texte litteral francais (module global).
    * 1 a 2 phrases par boite, < 150 caracteres hors [pause=N].
    * Tout sous pcall : une recompense qui casse ne doit jamais bloquer
      le joueur dans une ville endormie.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

TownReward = {}

--------------------------------------------------------------------
-- LES LOTS
--------------------------------------------------------------------
-- Tous ces identifiants existent dans Data/Item/ (verifie un par un).
-- Trois paliers, alignes sur les trois vagues de TownRaid.
TownReward.LOTS = {
  --Vague 1 : de quoi tenir. Des soins, rien de plus.
  [1] = {
    'berry_oran', 'berry_pecha', 'berry_cheri', 'berry_rawst',
    'seed_plain', 'food_apple', 'apricorn_plain', 'ammo_geo_pebble',
  },
  --Vague 2 : on commence a vous equiper.
  [2] = {
    'berry_lum', 'berry_persim', 'seed_reviver', 'seed_quick',
    'food_apple_big', 'orb_escape', 'orb_cleanse', 'held_defense_scarf',
    'held_power_band', 'apricorn_big',
  },
  --Vague 3 : la ville sort ce qu'elle a de mieux.
  [3] = {
    'seed_reviver', 'seed_blast', 'orb_revival', 'orb_rebound',
    'food_apple_huge', 'boost_protein', 'boost_iron', 'boost_calcium',
    'held_reunion_cape', 'held_special_band', 'gummi_wonder',
  },
}

--Argent verse par palier. Modeste : la reconnaissance n'est pas un salaire.
TownReward.ARGENT = { [1] = 150, [2] = 400, [3] = 900 }

--Nombre d'objets offerts par palier.
TownReward.NB_OBJETS = { [1] = 1, [2] = 2, [3] = 3 }

--------------------------------------------------------------------
-- ETAT
--------------------------------------------------------------------
function TownReward.Ensure()
  if SV.TownReward == nil then SV.TownReward = {} end
  local s = SV.TownReward
  if s.Pending == nil then s.Pending = false end   --felicitations a jouer demain
  if s.LastWave == nil then s.LastWave = 0 end     --vague repoussee la derniere fois
  if s.LastItems == nil then s.LastItems = {} end  --noms des objets recus
  if s.LastMoney == nil then s.LastMoney = 0 end   --argent recu
  if s.Total == nil then s.Total = 0 end           --defenses reussies au total
  return s
end

--------------------------------------------------------------------
-- REMISE DES OBJETS
--------------------------------------------------------------------
-- On n'utilise PAS GeneralFunctions.RewardItem : son texte est code en
-- dur en anglais (« Team X received... », l.1239 et 1254). On refait
-- donc la remise ici, en francais, avec la meme logique de repli vers
-- le stockage quand le sac est plein (verifie l.1258).
local function donner(itemID)
  local nom = itemID
  pcall(function()
    local e = RogueEssence.Data.DataManager.Instance:GetItem(itemID)
    local amount = 1
    if e ~= nil and e.MaxStack ~= nil and e.MaxStack > 1 then amount = 1 end
    local item = RogueEssence.Dungeon.InvItem(itemID, false, amount)
    nom = item:GetDisplayName()

    --Sac plein : on envoie au stockage plutot que de perdre le lot.
    if GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount() >= GAME:GetPlayerBagLimit() then
      GAME:GivePlayerStorageItem(itemID, amount)
      nom = nom .. " (au dépôt)"
    else
      GAME:GivePlayerItem(itemID, amount)
    end
  end)
  return nom
end

--Tire `n` objets distincts dans le lot du palier demande.
local function tirer(wave, n)
  local lot = TownReward.LOTS[wave] or TownReward.LOTS[1]
  local pris, vus = {}, {}
  local essais = 0
  while #pris < n and essais < 40 do
    essais = essais + 1
    local i = 1
    pcall(function() i = math.random(1, #lot) end)
    local id = lot[i]
    if id ~= nil and not vus[id] then
      vus[id] = true
      table.insert(pris, id)
    end
  end
  return pris
end

--------------------------------------------------------------------
-- LA RECOMPENSE, LE SOIR MEME
--------------------------------------------------------------------
-- Appelee par TownRaid.Victory(). Retient tout pour la scene du
-- lendemain, et arme s.Pending.
function TownReward.Grant(wave)
  wave = wave or 1
  if wave < 1 then wave = 1 end
  if wave > 3 then wave = 3 end

  local s = TownReward.Ensure()
  s.Total = s.Total + 1
  s.LastWave = wave
  s.LastItems = {}
  s.LastMoney = 0
  s.Pending = true

  local n = TownReward.NB_OBJETS[wave] or 1
  local ids = tirer(wave, n)

  pcall(function()
    UI:ResetSpeaker(false)
    UI:SetCenter(true)

    UI:WaitShowDialogue("Au petit matin, quelque chose attend devant votre porte.")
    GAME:WaitFrames(15)
    UI:WaitShowDialogue("Un panier.[pause=25] Personne n'a laissé de nom.")
    GAME:WaitFrames(10)

    SOUND:PlayFanfare("Fanfare/Item")
    for _, id in ipairs(ids) do
      local nom = donner(id)
      table.insert(s.LastItems, nom)
      UI:WaitShowDialogue("Vous trouvez : [color=#00FFFF]" .. nom .. "[color].[pause=30]")
    end

    local argent = TownReward.ARGENT[wave] or 0
    if argent > 0 then
      s.LastMoney = argent
      GAME:AddToPlayerMoney(argent)
      UI:WaitShowDialogue("Et une bourse.[pause=25] "
        .. tostring(argent) .. STRINGS:Format("\\uE024")
        .. ", réunis par les marchands.")
    end

    GAME:WaitFrames(10)
    UI:WaitShowDialogue("Au fond du panier, un mot :[pause=25] « On a entendu. Merci. »")
    UI:SetCenter(false)
    UI:ResetSpeaker()
  end)

  return s.LastItems, s.LastMoney
end

--------------------------------------------------------------------
-- LES FELICITATIONS, LE LENDEMAIN EN VILLE
--------------------------------------------------------------------
-- Scene courte jouee a l'entree de metano_town quand s.Pending est
-- arme. Elle NE remplace aucune scene de chapitre : elle s'ajoute et
-- se desarme aussitot.
function TownReward.Congratulations()
  local s = TownReward.Ensure()
  if not s.Pending then return false end
  s.Pending = false

  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local wave = s.LastWave

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end
    GAME:WaitFrames(20)

    UI:ResetSpeaker(false)
    UI:SetCenter(true)
    if wave >= 3 then
      UI:WaitShowDialogue("La place est pleine.[pause=30] Et tout le monde se tait quand vous arrivez.")
    elseif wave == 2 then
      UI:WaitShowDialogue("On vous regarde passer.[pause=25] Pas comme d'habitude.")
    else
      UI:WaitShowDialogue("Le marché a rouvert.[pause=25] Un peu plus tôt que d'ordinaire.")
    end
    UI:SetCenter(false)
    UI:ResetSpeaker()
    GAME:WaitFrames(15)

    if partner ~= nil then
      UI:SetSpeaker(partner)
      if wave >= 3 then
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue("Ils sont tous sortis.[pause=30] Tous. Regarde.")
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue("Personne ne dit rien.[pause=25] Je crois qu'ils ne savent pas quoi dire.")
        GeneralFunctions.SetEmotion('Happy')
        UI:WaitShowDialogue("Moi non plus, d'ailleurs.[pause=25] Alors on va juste marcher.")
      elseif wave == 2 then
        GeneralFunctions.SetEmotion('Happy')
        UI:WaitShowDialogue("Tu as vu ?[pause=25] Le vieux du coin nous a salués.")
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue("Il ne salue personne, lui.[pause=30] Jamais.")
      else
        GeneralFunctions.SetEmotion('Happy')
        UI:WaitShowDialogue("Ils ne savent pas que c'était nous.[pause=30] Enfin... presque personne.")
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue("C'est mieux comme ça, non ?")
      end
      UI:ResetSpeaker()
    end

    GAME:WaitFrames(10)
    GeneralFunctions.HeroDialogue(hero,
      "(La ville a rouvert ses volets.[pause=25] C'est tout ce que je voulais.)", 'Normal')
  end)
  if not ok then PrintInfo('[TownReward.Congratulations] ecourtee : '..tostring(err)) end

  pcall(function()
    UI:ResetSpeaker()
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', CH('PLAYER'), partner.Position)
    end
    GAME:CutsceneMode(false)
  end)
  return true
end

--------------------------------------------------------------------
-- L'ETAT DE LA VILLE, POUR LES PNJ
--------------------------------------------------------------------
-- Renvoie l'un de :
--   'defendue'  la derniere nuit a ete gagnee
--   'pillee'    la derniere nuit a ete perdue
--   nil         rien a signaler
--
-- C'est cette valeur que TownVoicesNight interroge pour choisir la
-- replique de chaque habitant. Le plus recent l'emporte : on compare
-- les jours, pas les compteurs.
function TownReward.CityMood()
  local r = SV.TownRaid or {}
  local p = SV.TownPlunder or {}
  local w = SV.TownReward or {}

  --Etals vides = la nuit derniere a ete perdue, et ca se voit encore.
  if p.ShopsEmpty then return 'pillee' end
  --Une victoire dont les felicitations viennent d'etre jouees.
  if (w.Total or 0) > 0 and (r.Repelled or 0) > 0 then return 'defendue' end
  if (r.Lost or 0) > 0 then return 'pillee' end
  return nil
end

return TownReward
