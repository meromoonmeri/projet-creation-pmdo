--[[
    init.lua
    Aegis Cave (Aegis Cave) — portage d'Aegis Cave

    HUIT SEGMENTS, quatre labyrinthes et quatre arenes :
      0 GLACE B1-B3      1 arene de Regice     (crystal_cave_1)
      2 ROCHE B1-B3      3 arene de Regirock   (rock_maze)
      4 ACIER B1-B4      5 arene de Registeel  (steel_aegis_cave)
      6 LE PUITS B1-B5   7 Sanctuaire des Titans / Regigigas (concealed_ruins)

    ARCHITECTURE 1:1 NDS (corrigé 2026-08-09) :
      - Labyrinthes 0/2/4/6 (boucle tant que le mot est incomplet) ; mot
        épelé -> GROUND NDS de la chambre (cloven_ruin_*_chamber_sky,
        source MAP_BG D55P41A/D57P44A/D59P41A/D61P41A, comme Sky).
      - Le ground joue l'éveil (ClovenCanonicalChamber) puis lance le
        combat via EnterDungeon vers le segment 1/3/5/7 (fixed floors
        .rsmap). Retour au ground pour le serment / recrutement.
      - Puits (6) franchi -> GROUND NDS Regigigas Chamber (D32P44A).
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.ReplayEnding'
require 'halcyon.LegendZones'
require 'halcyon.RuinesArenes'

local cloven_ruins = {}

--------------------------------------------------------------------
-- INDEX DES GROUNDS DE master_zone — resolus PAR NOM
--
-- Correctif du 2026-08-02. Les sorties de ce fichier ciblaient des
-- index ecrits en dur qui ne correspondaient pas aux cartes voulues :
--
--   ecrit 65 (« cloven_ruins_entrance » selon le commentaire d'origine)
--     -> master_zone.GroundMaps[65] = vast_steppe_midpoint
--   ecrit 66 (relais des Ruines attendu)
--     -> master_zone.GroundMaps[66] = mount_windswept_midpoint
--
-- Consequence en jeu : apres un KO ou un abandon dans les Ruines, le
-- joueur etait depose au relais de la Grande Steppe. La cinematique du
-- Camp des Ruines ne se lancait donc jamais — non parce que ses flags
-- etaient faux (SV.Chapter5.PlayTempRuinsScene etait bien pose), mais
-- parce que le joueur n'arrivait pas sur la carte qui les lit.
--
-- Les vrais index sont 67 (entrance) et 69 (midpoint). Plutot que de
-- corriger deux nombres qui rederiveront au prochain ajout de ground,
-- on les resout par NOM a l'execution. GROUND_IDX rend l'index reel ou
-- une valeur de repli sure (la ville) si le nom disparait.
--------------------------------------------------------------------
local MASTER_FALLBACK = 1  -- metano_town

local function GROUND_IDX(name)
  local ok, idx = pcall(function()
    local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("master_zone")
    for ii = 0, zone.Grounds.Count - 1, 1 do
      if zone.Grounds[ii] == name then return ii end
    end
    return -1
  end)
  if not ok or idx == nil or idx < 0 then
    PrintInfo("[cloven_ruins] ground introuvable dans master_zone : " .. tostring(name)
              .. " — repli sur " .. tostring(MASTER_FALLBACK))
    return MASTER_FALLBACK
  end
  return idx
end

function cloven_ruins.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_cloven_ruins")
  SV.TemporaryFlags.LastDungeonEntered = 'cloven_ruins'
end

function cloven_ruins.EnterSegment(zone, rescuing, segmentID, mapID)
    GeneralFunctions.CheckAllowSetRescue(zone.ID)
    if rescuing ~= true then
        COMMON.BeginDungeon(zone.ID, segmentID, mapID)
    end
end

function cloven_ruins.Rescued(zone, name, mail)
    COMMON.Rescued(zone, name, mail)
end

--LES RUINES FENDUES se jouent au ch5 (climax de l'expedition,
--restructuration validee) et, pour les sauvegardes existantes, encore
--au chapitre 5 comme donjon final de l'expedition. En rejouabilite,
--la zone terminee reste accessible sans rejouer la progression principale.
local function ruinsActive()
  if SV.ChapterProgression ~= nil then
    local ch = SV.ChapterProgression.Chapter
    -- Aegis Cave est le donjon FINAL du chapitre 5. L'ancien routage
    -- chapitre 7 était une dérive documentaire et ne doit plus réactiver
    -- le flux principal. Après le chapitre 5, seule la revanche le permet.
    if ch == 5 then return true end
  end
  return ReplayEnding.IsCleared('cloven_ruins')
end

function cloven_ruins.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_cloven_ruins result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then
      return
  end
  -- ==================================================================
  -- OSSATURE AEGIS CAVE — 8 secteurs (Lot 1)
  --   0 GLACE B1-B3      1 Chambre de Regice
  --   2 ROCHE B1-B3      3 Chambre de Regirock
  --   4 ACIER B1-B4      5 Chambre de Registeel
  --   6 LE PUITS B1-B5   7 Chambre de Regigigas
  --
  -- MECANIQUE CENTRALE, fidele a Explorers of Sky : un labyrinthe ne
  -- debouche PAS sur la chambre. Il BOUCLE : arrive au bout, l'equipe se
  -- retrouve a l'entree. La chambre ne s'ouvre que lorsque le mot du
  -- secteur est epele avec les pierres de Zarbi (systeme du Lot 2).
  -- Tant que RuinesMot[n] est faux, on reboucle sur le camp d'entree.
  -- ==================================================================
  local MOTS = { [0] = 'Glace', [2] = 'Roche', [4] = 'Acier' }

  -- Le mot du secteur est-il complet ? (pose par le Lot 2 ; par defaut
  -- faux, donc le secteur boucle — comportement d'origine du donjon.)
  local function motComplet(seg)
    local cle = MOTS[seg]
    if cle == nil then return true end
    local ok = false
    pcall(function()
      ok = (SV.Ruines ~= nil) and (SV.Ruines['Mot' .. cle] == true)
    end)
    return ok
  end

  -- CHECKPOINT DE RESPAWN (2026-08-04) : apres avoir vaincu un Regi, la
  -- salle de STELE du segment suivant (l'entree du labyrinthe, ou est posee
  -- la stele « fermer les yeux ») devient le point de respawn. Si le joueur
  -- perd dans le labyrinthe suivant, il reapparait dans la salle de stele
  -- de ce segment au lieu de retourner au camp. Tant qu'aucun Regi n'est
  -- vaincu (ou face a un Regi), on respawn a l'entrance du camp.
  local function respawnCheckpoint(result, cp)
    SV.Chapter5 = SV.Chapter5 or {}
    SV.Chapter5.RuinsRespawnArena = cp
    PrintInfo("[Ruines] defaite entre deux segments -> respawn salle de stele segment "..tostring(cp))
    GAME:WaitFrames(20)
    GAME:EndDungeonRun(result, "master_zone", -1, GROUND_IDX('cloven_ruins_entrance'), 0, false, false)
    GAME:WaitFrames(10)
    GAME:EnterDungeon("cloven_ruins", cp, 0, 0,
      RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end

  -- La salle de stele du segment : c'est l'entree du labyrinthe courant,
  -- la ou est posee la stele « fermer les yeux ». Le Puits (6) n'a pas de
  -- stele mais sert de salle de repli. Retourne nil pour le segment 0
  -- (avant le premier Regi : aucun checkpoint, on revient au camp).
  local function steleRoom()
    if segmentID == 0 then return nil end
    return segmentID
  end

  -- Retour au camp d'entree : boucle de secteur OU echec.
  --
  -- CORRECTIF (rapport joueur 2026-08-03 : « je finis l'etage 4 et j'ai le
  -- message de victoire au lieu de la suite prevue »).
  -- La BOUCLE n'est pas une fin de donjon : le joueur ressort bredouille
  -- parce que le mot n'est pas epele, ce n'est ni un succes ni un echec.
  -- On passait pourtant display=true / fanfare=true a EndDungeonRun, d'ou
  -- l'ecran de resultats et la fanfare de victoire.
  -- Desormais : pas de bilan ni de fanfare sur une boucle ; on ne les
  -- garde que pour une vraie sortie (KO ou abandon).
  local function retourCamp(result, motif)
    GAME:WaitFrames(20)
    local boucle = (motif == nil)
    if not boucle then SV.Chapter5.LostRuins = true end
    -- CINEMATIQUE DE RETOUR AU CAMP (correctif audit cloven_ruins) :
    -- PlayTempRuinsScene n'etait jamais pose, le ground d'entree ne
    -- jouait ni le reveil apres KO ni le repli apres abandon. Le camp
    -- lit ces deux flags (cloven_ruins_entrance/init.lua PlotScripting).
    if not boucle then
      SV.Chapter5.PlayTempRuinsScene = true
      if result == RogueEssence.Data.GameProgress.ResultType.Escaped then
        SV.Chapter5.RuinsLastExitReason = 'Retreated'
      else
        SV.Chapter5.RuinsLastExitReason = 'Died'
      end
    end
    if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped
       and motif == 'echec' then
      GAME:EndDungeonRun(result, "master_zone", -1, GROUND_IDX('cloven_ruins_entrance'), 0, true, true)
      GAME:WaitFrames(20)
      GAME:EnterZone("master_zone", -1, GROUND_IDX('cloven_ruins_entrance'), 0)
    else
      GeneralFunctions.EndDungeonRun(result, "master_zone", -1,
        GROUND_IDX('cloven_ruins_entrance'), 0, not boucle, not boucle)
    end
  end

  -- --- LABYRINTHES : 0 (Glace), 2 (Roche), 4 (Acier) -----------------
  if segmentID == 0 or segmentID == 2 or segmentID == 4 then
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and ruinsActive() then
          if motComplet(segmentID) then
              -- Le mot est epele : l'escalier vers la chambre s'ouvre.
              -- Le mot est epele : on passe par le ground de cinematique du
              -- gardien, qui joue l'eveil PUIS lance le combat. Une apparition
              -- instantanee est interdite par les regles du projet.
              -- L'escalier descend DIRECTEMENT dans l'arene du gardien.
              -- Plus aucun ground intermediaire : l'eveil se joue dans
              -- l'etage lui-meme, sur OnMapStarts (RuinesArenes.Eveil),
              -- avec le biome du labyrinthe qu'on vient de traverser.
              -- CHAMBRE = GROUND NDS (D32P31A/32A/33A -> cloven_ruin_*_chamber_sky).
              -- Le ground joue la cinematique d'eveil (ClovenCanonicalChamber)
              -- puis lance le combat via EnterDungeon vers le segment 1/3/5.
              local CHAMBRE = {
                [0] = 'cloven_ruin_regice_chamber_sky',
                [2] = 'cloven_ruin_regirock_chamber_sky',
                [4] = 'cloven_ruin_registeel_chamber_sky'
              }
              PrintInfo("[Ruines] secteur "..tostring(segmentID)
                        .." : mot complet -> Ground NDS "..tostring(CHAMBRE[segmentID]))
              GAME:EnterGroundMap(CHAMBRE[segmentID], 'Main_Entrance_Marker')
          else
              -- Mot incomplet : le donjon boucle, comme dans EoS.
              PrintInfo("[Ruines] secteur "..tostring(segmentID).." : mot incomplet -> retour au camp")
              SV.Ruines = SV.Ruines or {}
              SV.Ruines.BoucleSecteur = segmentID
              retourCamp(result, nil)
          end
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          -- Respawn checkpoint : on se reveille dans la salle de stele du
          -- segment courant (l'entree du labyrinthe) ; pour le segment 0
          -- (avant le premier Regi), retour a l'entrance du camp.
          local cp = steleRoom()
          if cp ~= nil then
              respawnCheckpoint(result, cp)
          else
              retourCamp(result, 'echec')
          end
      end

  -- --- CHAMBRES DES REGI : 1, 3, 5 -----------------------------------
  elseif segmentID == 1 or segmentID == 3 or segmentID == 5 then
      local NOM = { [1] = 'Regice', [3] = 'Regirock', [5] = 'Registeel' }
      local qui = NOM[segmentID]
      SV.Ruines = SV.Ruines or {}

      if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
          -- La scene d'apres-combat a DEJA ete jouee dans l'arene, avant le
          -- fondu (RuinesArenesClear -> RuinesArenes.Victoire). Le gardien y
          -- est redevenu statue sous les yeux du joueur. Il ne reste qu'a
          -- ramener l'equipe au camp : le scelle est brise, le secteur est
          -- fini, on ne reboucle plus dessus.
          SV.Ruines['Vaincu' .. qui] = true
          -- Retour au GROUND NDS de la chambre : le gardien y prononce le
          -- serment (ClovenCanonicalChamber, branche `defeated`), puis on
          -- enchaîne sur le labyrinthe suivant (c.next).
          local RETOUR = { [1]='cloven_ruin_regice_chamber_sky', [3]='cloven_ruin_regirock_chamber_sky', [5]='cloven_ruin_registeel_chamber_sky' }
          PrintInfo("[Ruines] " .. qui .. " vaincu -> retour Ground NDS chambre")
          GAME:EnterGroundMap(RETOUR[segmentID], 'Main_Entrance_Marker')
      else
          -- Defaite : il ne poursuit pas, il reprend son poste. Sa derniere
          -- phrase accompagne la sortie (RuinesArenes.CleDefaite), puis on
          -- revient au camp. Le scelle reste entier : le joueur pourra
          -- redescendre, le mot du secteur etant deja epele.
          SV.Ruines['Perdu' .. qui] = true
          SV.Chapter5.PlayTempRuinsScene = true
          if result == RogueEssence.Data.GameProgress.ResultType.Escaped then
            SV.Chapter5.RuinsLastExitReason = 'Retreated'
          else
            SV.Chapter5.RuinsLastExitReason = 'Died'
          end
          PrintInfo("[Ruines] defaite contre " .. qui)
          GAME:WaitFrames(20)
          pcall(function()
            local cle = RuinesArenes.CleDefaite(segmentID)
            if cle ~= nil then
              UI:ResetSpeaker(false)
              UI:SetCenter(true)
              UI:WaitShowDialogue(STRINGS:FormatKey(cle))
              UI:SetCenter(false)
              UI:ResetSpeaker()
            end
          end)
          GeneralFunctions.EndDungeonRun(result, "master_zone", -1,
            GROUND_IDX('cloven_ruins_entrance'), 0, true, true)
      end

  -- --- LE PUITS : 6 (5 etages, aucun puzzle) -------------------------
  elseif segmentID == 6 then
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and ruinsActive() then
          -- Le fond du Puits ouvre DIRECTEMENT sur le Sanctuaire des Titans
          -- (segment 7). L'eveil de Regigigas, ses huit gardes et les
          -- renforts de la guilde se jouent dans l'arene elle-meme.
          PrintInfo("[Ruines] Puits franchi -> Ground NDS Regigigas Chamber")
          GAME:EnterGroundMap('cloven_ruin_regigigas_chamber_sky', 'Main_Entrance_Marker')
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          -- Perdu dans le Puits (seg6) : on se reveille dans la salle de
          -- stele du segment (le Puits sert de salle de repli).
          GAME:WaitFrames(20)
          SV.Chapter5.LostDepths = true
          local cp = steleRoom()
          if cp ~= nil then
              respawnCheckpoint(result, cp)
          elseif result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              SV.Chapter5.RuinsMidState = 'DeathArrival'
              GAME:EndDungeonRun(result, "master_zone", -1, GROUND_IDX('cloven_ruins_midpoint'), 0, true, true)
              GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1), "Le puits...[pause=0] il n'en finissait pas...", "Pain")
              GAME:WaitFrames(20)
              GAME:EnterZone("master_zone", -1, GROUND_IDX('cloven_ruins_midpoint'), 0)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, GROUND_IDX('cloven_ruins_midpoint'), 0, true, true)
          end
      end

  -- --- REGIGIGAS : 7 (boss final) ------------------------------------
  elseif segmentID == 7 then
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
          SV.Chapter5.DefeatedRuinsBoss = true
          -- Marque la victoire pour la scene de revelation jouee au camp
          -- (sortie d'Aegis Cave : la Tour des Reliques s'ouvre).
          SV.Ruines = SV.Ruines or {}
          SV.Ruines.VaincuRegigigas = true
          LegendZones.SetDefeated('colossus_quarry')
      else
          SV.Chapter5.DiedToRuinsBoss = true
      end

      -- Revanche achetee chez Grodoudou : l'histoire du ch5 est deja faite,
      -- on ne rejoue pas la cinematique, on ressort en ville.
      if SV.Chapter5 ~= nil and SV.Chapter5.SawAnimaCoreCorruption == true
         and SV.ChapterProgression.Chapter ~= 5 then
          GAME:WaitFrames(20)
          GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
          return
      end

      -- Tout s'est joue dans l'arene : le renversement, la question de
      -- Regigigas, sa mise en statue, l'effondrement et la fuite
      -- (RuinesTitan). On ressort au camp, ou le ground d'entree joue la
      -- revelation de la Tour des Reliques en lisant SV.Ruines.VaincuRegigigas.
      -- Defaite (ou abandon) : on arme la cinematique de reveil au camp.
      if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
        SV.Chapter5.PlayTempRuinsScene = true
        if result == RogueEssence.Data.GameProgress.ResultType.Escaped then
          SV.Chapter5.RuinsLastExitReason = 'Retreated'
        else
          SV.Chapter5.RuinsLastExitReason = 'Died'
        end
      end
      GAME:WaitFrames(20)
      GeneralFunctions.EndDungeonRun(result, "master_zone", -1,
        GROUND_IDX('cloven_ruins_entrance'), 0, false, false)
  end
end

return cloven_ruins
