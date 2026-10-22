--[[
    SuaireJobs.lua — Contrats de l'arc 2 « Ce que la brume emporte »

    PROBLEME RESOLU
    ---------------
    Les 5 actes de SuaireArc.lua se declenchaient a la SORTIE du donjon, sans
    qu'aucune mission ne les annonce. Le joueur n'avait donc aucun moyen de
    savoir que ces 5 donjons portaient une intrigue : il tombait dessus par
    hasard, ou jamais.

    Ce module pose de VRAIS contrats sur le tableau des missions de la guilde :
    un client nomme, un texte d'ambiance ecrit, une recompense, un rang de
    difficulte. Le contrat de l'acte N n'apparait que quand l'acte N-1 est fait,
    et disparait une fois l'acte joue.

    COMMENT IL S'INTEGRE (aucune mecanique nouvelle)
    ------------------------------------------------
    Il reutilise TEL QUEL le format de job de mission_gen.lua : les memes
    champs que SV.MissionBoard[i] (Client, Target, Flavor, Title, Zone,
    Segment, Floor, Reward, Type, Completion, Taken, Difficulty, Item,
    Special, ClientGender, TargetGender, BonusReward). Le moteur les affiche
    donc sans savoir qu'ils sont scriptes.

    Le contrat est EPINGLE : GenerateBoard() remplit les slots au hasard a
    chaque nouveau jour, on ecrase ensuite le slot 1 avec le contrat d'arc.
    C'est volontaire — la quete d'histoire doit toujours etre visible en haut
    du tableau, pas noyee dans le hasard.

    REGLES : francais idiomatique, jamais « Necrozma / Eternatus / l'Abime »,
    le Suaire n'est jamais nomme dans un contrat officiel de la guilde (les
    clients decrivent ce qu'ils ont vu, pas ce que c'est).
]]
require 'origin.common'

SuaireJobs = {}

--------------------------------------------------------------------
-- Les 5 contrats, dans l'ordre des actes.
-- client/target : especes reelles (verifiees presentes dans le jeu).
-- floor : etage ou la scene a du sens ; l'acte se joue de toute facon a la
--         sortie, le champ sert a l'affichage et au reperage du joueur.
--------------------------------------------------------------------
SuaireJobs.CONTRACTS = {
  {
    act = 1, zone = 'bosquet_voile', segment = 0, floor = 3,
    client = 'sunflora', client_gender = RogueEssence.Data.Gender.Female,
    target = 'sunflora', target_gender = RogueEssence.Data.Gender.Female,
    difficulty = 'E', reward = 'money',
    title = "Les fleurs qui se fanent d'un seul côté",
    flavor = "Mon bosquet meurt par le bas, et seulement par le bas.\nLes racines gèlent alors qu'il fait doux. Venez voir, je vous en prie.",
  },
  {
    act = 2, zone = 'grotte_mystere', segment = 0, floor = 5,
    client = 'kadabra', client_gender = RogueEssence.Data.Gender.Male,
    target = 'kadabra', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'D', reward = 'money',
    title = "Relevé d'une paroi taillée",
    flavor = "J'ai trouvé des rainures régulières au fond de la grotte. Trop régulières.\nJe paie qui saura me dire si c'est l'œuvre de quelqu'un — et de qui.",
  },
  {
    act = 3, zone = 'jardin_secret', segment = 0, floor = 6,
    client = 'roselia', client_gender = RogueEssence.Data.Gender.Female,
    target = 'roselia', target_gender = RogueEssence.Data.Gender.Female,
    difficulty = 'C', reward = 'money',
    title = "Le jardin que personne n'entretient",
    flavor = "Rien n'y meurt jamais, et pourtant personne n'y va.\nDepuis peu, ça sent l'encens froid. Je n'ose plus m'en approcher seule.",
  },
  {
    act = 4, zone = 'col_foudre', segment = 0, floor = 8,
    client = 'ampharos', client_gender = RogueEssence.Data.Gender.Male,
    target = 'ampharos', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'B', reward = 'money',
    title = "Inspection du Cœur du col",
    flavor = "La pierre du col a perdu des éclats. Trois, exactement.\nUne autre équipe est déjà partie. Allez-y aussi : je veux deux rapports.",
  },
  {
    act = 5, zone = 'antre_enigme', segment = 0, floor = 7,
    client = 'xatu', client_gender = RogueEssence.Data.Gender.Male,
    target = 'xatu', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'B', reward = 'money',
    title = "La salle aux niches vides",
    flavor = "J'ai vu cet endroit en rêve avant de le trouver. Des centaines de niches, toutes vides.\nQuelqu'un les a vidées une par une. Je veux savoir jusqu'où ça va.",
  },
}

--------------------------------------------------------------------
-- Quel contrat doit etre visible maintenant ?
-- Renvoie la table du contrat, ou nil.
--------------------------------------------------------------------
function SuaireJobs.CurrentContract()
  if SV.SuaireArc == nil or not SV.SuaireArc.Unlocked then return nil end
  for _, c in ipairs(SuaireJobs.CONTRACTS) do
    local done = SV.SuaireArc['Act'..c.act..'Done']
    local prev_ok = (c.act == 1) or (SV.SuaireArc['Act'..(c.act - 1)..'Done'] == true)
    if not done and prev_ok then return c end
  end
  return nil
end

--------------------------------------------------------------------
-- Le contrat est-il deja pris (present sur le TakenBoard) ?
--------------------------------------------------------------------
local function already_taken(c)
  if SV.TakenBoard == nil then return false end
  for i = 1, #SV.TakenBoard do
    local j = SV.TakenBoard[i]
    if j ~= nil and j.Zone == c.zone and j.Special == 'SUAIRE_ARC' then
      return true
    end
  end
  return false
end

--------------------------------------------------------------------
-- Ecrit le contrat courant dans le slot 1 du tableau des missions.
-- Appele APRES MISSION_GEN.GenerateBoard, pour que le job scripte ne soit
-- pas ecrase par la generation aleatoire.
--------------------------------------------------------------------
function SuaireJobs.PinToBoard()
  local c = SuaireJobs.CurrentContract()
  if c == nil then return false end
  if SV.MissionBoard == nil or SV.MissionBoard[1] == nil then return false end
  if already_taken(c) then return false end

  local j = SV.MissionBoard[1]
  j.Client        = c.client
  j.Target        = c.target
  j.Flavor        = c.flavor
  j.Title         = c.title
  j.Zone          = c.zone
  j.Segment       = c.segment
  j.Floor         = c.floor
  j.Reward        = c.reward
  j.Type          = COMMON.MISSION_TYPE_EXPLORATION
  j.Completion    = MISSION_GEN.INCOMPLETE
  j.Taken         = false
  j.Difficulty    = c.difficulty
  j.Item          = ""
  --marqueur : permet de reconnaitre nos contrats parmi les jobs aleatoires
  j.Special       = 'SUAIRE_ARC'
  j.ClientGender  = c.client_gender
  j.TargetGender  = c.target_gender
  j.BonusReward   = ""
  PrintInfo("[SuaireJobs] contrat epingle : acte "..tostring(c.act).." — "..tostring(c.zone))
  return true
end

--------------------------------------------------------------------
-- Nettoyage : retire les contrats d'arc dont l'acte est deja joue.
-- Evite qu'un contrat obsolete traine sur le tableau des missions prises
-- si le joueur l'avait accepte puis termine le donjon.
--------------------------------------------------------------------
function SuaireJobs.CleanCompleted()
  if SV.TakenBoard == nil or SV.SuaireArc == nil then return 0 end
  local n = 0
  for i = 1, #SV.TakenBoard do
    local j = SV.TakenBoard[i]
    if j ~= nil and j.Special == 'SUAIRE_ARC' then
      for _, c in ipairs(SuaireJobs.CONTRACTS) do
        if c.zone == j.Zone and SV.SuaireArc['Act'..c.act..'Done'] then
          j.Completion = MISSION_GEN.COMPLETE
          n = n + 1
        end
      end
    end
  end
  return n
end

--------------------------------------------------------------------
-- Marque le contrat de CETTE zone comme accompli. Appele par SuaireArc
-- juste apres que l'acte a ete joue.
--------------------------------------------------------------------
function SuaireJobs.MarkDone(zoneID)
  if SV.TakenBoard == nil then return end
  for i = 1, #SV.TakenBoard do
    local j = SV.TakenBoard[i]
    if j ~= nil and j.Zone == zoneID and j.Special == 'SUAIRE_ARC' then
      j.Completion = MISSION_GEN.COMPLETE
      PrintInfo("[SuaireJobs] contrat accompli : "..tostring(zoneID))
    end
  end
end

return SuaireJobs
