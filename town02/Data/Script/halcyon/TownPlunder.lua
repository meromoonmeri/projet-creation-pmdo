--[[
    TownPlunder.lua

    LE PRIX D'UNE NUIT PERDUE
    ================================================================
    POURQUOI CE MODULE EXISTE
    ------------------------------------------------------------------
    TownRaid faisait perdre le combat sans que rien ne change. Un echec
    sans consequence n'est pas un echec : c'est une formalite. Le joueur
    apprend tres vite qu'il peut se laisser battre, et le raid devient
    une interruption qu'on subit au lieu d'un enjeu qu'on defend.

    Ici, perdre coute quelque chose. Pas assez pour punir : assez pour
    qu'on ait envie de gagner la prochaine fois.

    ------------------------------------------------------------------
    CE QUE LES PILLARDS EMPORTENT (et les API qui le permettent)
    ------------------------------------------------------------------
    Toutes verifiees dans le depot avant usage, aucune inventee :

      1. LES ETALS SONT VIDES.
         Le magasin lit SV.DailyFlags.GreenKecleonStock pour remplir son
         catalogue (metano_town/init.lua:757). Si la liste est vide, le
         catalogue l'est aussi. On vide donc les deux stocks et on force
         RefreshedStock a true pour que le magasin ne les regenere pas
         (init.lua:752). C'est le mecanisme du jeu, pas un contournement.

      2. LA BANQUE EST ENTAMEE.
         GAME:GetPlayerMoneyBank() / GAME:RemoveFromPlayerMoneyBank(),
         utilisees par le guichet (init.lua:1350) et par
         GeneralFunctions.SendInvToStorage (l.1198). On prend 8 % du
         depot, plafonne — voir PILLAGE_BANQUE_MAX.

      3. LE SAC EST ALLEGE.
         GAME:GetPlayerBagCount() / GetPlayerBagItem / TakePlayerBagItem,
         employees telles quelles par SendInvToStorage (l.1203-1204).
         Deux objets au plus, JAMAIS l'equipement porte : perdre le
         collier d'un equipier au reveil serait vecu comme un vol du jeu,
         pas comme une consequence.

    ------------------------------------------------------------------
    LES GARDE-FOUS (le plus important de ce fichier)
    ------------------------------------------------------------------
    Une perte doit rester lisible et jamais catastrophique :

      * plancher : en dessous de PILLAGE_BANQUE_MIN a la banque, on ne
        prend RIEN. On ne vole pas un joueur qui n'a deja plus rien.
      * plafond  : jamais plus de PILLAGE_BANQUE_MAX en une nuit.
      * les objets cles ne sont jamais pris (IsRare / CantDrop verifies
        avant retrait), sinon un raid pourrait bloquer la progression.
      * tout est sous pcall : si une API se comporte autrement que prevu,
        le joueur perd moins que prevu — jamais plus.

    ------------------------------------------------------------------
    REGLES DU PROJET
    ------------------------------------------------------------------
    * Jamais « Necrozma », « Eternatus », « l'Abime », « prison ».
    * Texte litteral francais (module global).
    * 1 a 2 phrases par boite, < 150 caracteres hors [pause=N].
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

TownPlunder = {}

--Bornes du pillage. Regroupees ici pour etre reglables d'un coup.
local PILLAGE_BANQUE_TAUX = 8     --pourcentage du depot
local PILLAGE_BANQUE_MIN  = 300   --en dessous, on ne prend rien
local PILLAGE_BANQUE_MAX  = 2000  --jamais plus, meme pour un riche
local PILLAGE_OBJETS_MAX  = 2     --objets du sac au plus

--------------------------------------------------------------------
-- ETAT
--------------------------------------------------------------------
function TownPlunder.Ensure()
  if SV.TownPlunder == nil then SV.TownPlunder = {} end
  local s = SV.TownPlunder
  if s.ShopsEmpty == nil then s.ShopsEmpty = false end  --etals vides aujourd'hui
  if s.LastStolen == nil then s.LastStolen = 0 end      --argent pris la derniere fois
  if s.LastItems == nil then s.LastItems = {} end       --noms des objets pris
  if s.TotalRaids == nil then s.TotalRaids = 0 end      --nuits perdues au total
  return s
end

--------------------------------------------------------------------
-- 1. LES ETALS SONT VIDES
--------------------------------------------------------------------
-- On vide les deux stocks du jour ET on marque « deja rafraichi », sinon
-- Shop_Action les regenererait a la premiere visite (init.lua:752).
-- L'effet dure jusqu'au prochain UpdateDailyFlags, c'est-a-dire un jour.
function TownPlunder.EmptyShops()
  local s = TownPlunder.Ensure()
  pcall(function()
    if SV.DailyFlags == nil then return end
    SV.DailyFlags.GreenKecleonStock = {}
    SV.DailyFlags.PurpleKecleonStock = {}
    SV.DailyFlags.GreenKecleonRefreshedStock = true
    SV.DailyFlags.PurpleKecleonRefreshedStock = true
    --Les deux marchands ambulants n'ont plus rien non plus.
    SV.DailyFlags.RedMerchantItem = ""
    SV.DailyFlags.GreenMerchantItem = ""
    s.ShopsEmpty = true
  end)
end

--------------------------------------------------------------------
-- 2. LA BANQUE EST ENTAMEE
--------------------------------------------------------------------
-- Renvoie le montant reellement pris (0 si rien).
function TownPlunder.RaidBank()
  local pris = 0
  pcall(function()
    local depot = GAME:GetPlayerMoneyBank()
    if depot == nil or depot < PILLAGE_BANQUE_MIN then return end

    pris = math.floor(depot * PILLAGE_BANQUE_TAUX / 100)
    if pris > PILLAGE_BANQUE_MAX then pris = PILLAGE_BANQUE_MAX end
    if pris < 1 then pris = 0 return end

    GAME:RemoveFromPlayerMoneyBank(pris)
  end)
  return pris
end

--------------------------------------------------------------------
-- 3. LE SAC EST ALLEGE
--------------------------------------------------------------------
-- Renvoie la liste des noms d'objets pris. L'equipement PORTE n'est
-- jamais touche : GetPlayerEquippedItem n'est volontairement pas appele.
function TownPlunder.RaidBag()
  local pris = {}
  pcall(function()
    local n = GAME:GetPlayerBagCount()
    if n == nil or n <= 0 then return end

    --On ne depouille jamais completement : au moins un objet reste.
    local combien = PILLAGE_OBJETS_MAX
    if n - combien < 1 then combien = n - 1 end
    if combien < 1 then return end

    for _ = 1, combien do
      local total = GAME:GetPlayerBagCount()
      if total == nil or total <= 1 then break end

      --Un indice au hasard, pour ne pas toujours prendre le premier.
      local idx = 0
      pcall(function() idx = math.random(0, total - 1) end)

      local item = GAME:GetPlayerBagItem(idx)
      if item ~= nil then
        --Garde-fou : jamais un objet cle, sinon un raid pourrait
        --bloquer la progression de l'histoire. Les deux champs testes
        --sont les VRAIS noms du schema des .json d'items (verifie dans
        --Data/Item/*.json) : CannotDrop et Rarity. Un objet non
        --largable, ou de rarete elevee, reste dans le sac.
        local protege = false
        pcall(function()
          local e = RogueEssence.Data.DataManager.Instance:GetItem(item.ID)
          if e ~= nil then
            if e.CannotDrop == true then protege = true end
            if e.Rarity ~= nil and e.Rarity >= 4 then protege = true end
          end
        end)
        if not protege then
          local nom = tostring(item.ID)
          pcall(function() nom = item:GetDisplayName() end)
          GAME:TakePlayerBagItem(idx, true)
          table.insert(pris, nom)
        end
      end
    end
  end)
  return pris
end

--------------------------------------------------------------------
-- LE PILLAGE COMPLET
--------------------------------------------------------------------
-- Appelee par TownRaid.Defeat(). Applique les trois effets, retient ce
-- qui a ete perdu, et renvoie un resume pour la scene du lendemain.
function TownPlunder.Apply()
  local s = TownPlunder.Ensure()
  s.TotalRaids = s.TotalRaids + 1

  TownPlunder.EmptyShops()
  s.LastStolen = TownPlunder.RaidBank()
  s.LastItems = TownPlunder.RaidBag()

  return s.LastStolen, s.LastItems
end

--------------------------------------------------------------------
-- LE CONSTAT — affiche au reveil
--------------------------------------------------------------------
-- On DIT au joueur ce qu'il a perdu. Une perte silencieuse serait vecue
-- comme un bug, pas comme une consequence.
function TownPlunder.Report()
  local s = TownPlunder.Ensure()

  return pcall(function()
    UI:ResetSpeaker(false)
    UI:SetCenter(true)

    UI:WaitShowDialogue("Au matin, la ville fait ses comptes.")

    if s.LastStolen > 0 then
      UI:WaitShowDialogue("Le coffre de la banque a été forcé.[pause=25] "
        .. tostring(s.LastStolen) .. STRINGS:Format("\\uE024") .. " ont disparu.")
    end

    if #s.LastItems > 0 then
      if #s.LastItems == 1 then
        UI:WaitShowDialogue("Il manque quelque chose dans votre sac :[pause=20] "
          .. s.LastItems[1] .. ".")
      else
        UI:WaitShowDialogue("Votre sac a été fouillé.[pause=25] "
          .. s.LastItems[1] .. ", " .. s.LastItems[2] .. " —[pause=15] envolés.")
      end
    end

    if s.ShopsEmpty then
      UI:WaitShowDialogue("Les étals sont vides.[pause=30] Les marchands n'ont plus rien à vendre aujourd'hui.")
    end

    if s.LastStolen == 0 and #s.LastItems == 0 and not s.ShopsEmpty then
      UI:WaitShowDialogue("Rien n'a été emporté.[pause=25] Cette fois, la ville a eu de la chance.")
    end

    UI:SetCenter(false)
    UI:ResetSpeaker()
  end)
end

--------------------------------------------------------------------
-- CE QUE DISENT LES MARCHANDS QUAND ON LES ABORDE
--------------------------------------------------------------------
-- Branche dans Shop_Action / Bank_Action : le marchand explique
-- lui-meme pourquoi il n'a rien. Sans ca, un etal vide passerait pour
-- un bug d'affichage.
function TownPlunder.ShopExcuse()
  local s = TownPlunder.Ensure()
  if not s.ShopsEmpty then return false end
  pcall(function()
    UI:ResetSpeaker(false)
    UI:SetCenter(true)
    UI:WaitShowDialogue("« On nous a tout pris cette nuit.[pause=30] Revenez demain, j'aurai peut-être réassorti. »")
    UI:SetCenter(false)
    UI:ResetSpeaker()
  end)
  return true
end

--Remise a zero : appelee par le passage au jour suivant.
function TownPlunder.NewDay()
  local s = TownPlunder.Ensure()
  s.ShopsEmpty = false
  s.LastStolen = 0
  s.LastItems = {}
end

return TownPlunder
