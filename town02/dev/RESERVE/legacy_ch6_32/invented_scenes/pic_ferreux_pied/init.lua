-- [dungeon_builder] recâblage : Ground d'entrée de mt_steel : il ouvre le donjon reconstruit à son premier étage
--[[ Rempart, Veilleur du Vieux Fer — cinematique de Veilleur (Reseau des Anciens Chemins).
     Ground pmd-red importe 1:1 ; geometrie intouchee, dialogues New Era.
     Grammaire : signal -> irruption -> recul -> reveal -> titre -> echange
     -> BossTransition -> arene. Rematch : intro raccourcie. ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.BossMusic'

local pic_ferreux_pied = {}

function pic_ferreux_pied.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_pic_ferreux_pied")
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function pic_ferreux_pied.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)

  -- Duo cote a cote (32 px d'ecart), ~72 px sous le Veilleur.
  GROUND:TeleportTo(hero, 176, 184, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 144, 184, Direction.Up) end
  local rempart = CharacterEssentials.MakeCharactersFromList({{'Rempart', 160, 112, Direction.Down}})
  GROUND:Hide('Rempart')
  -- Camera entre le duo et le Veilleur.
  GAME:MoveCamera(160, 148, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if SV.Reseau ~= nil and SV.Reseau.Veilleurs ~= nil and SV.Reseau.Veilleurs['new_era_zone_02'] then
    -- REMATCH : le Veilleur connait deja l'equipe, pas de ceremonie.
    GROUND:Unhide('Rempart')
    UI:SetSpeaker(rempart)
    UI:WaitShowDialogue("Repasse.[pause=20] Le fer se souvient de toi.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("mt_steel", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voie parle avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("LE VIEUX FER SE SOUVIENT DU POIDS DES PAS.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre a ce Veilleur).
  BossFX.Rumble({hero, partner}, 3)
  BossFX.EmergeGround(rempart, 160, 112)
  GAME:WaitFrames(20)

  -- 3. Le recul du duo.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4. Reveal.
  GROUND:Unhide('Rempart')
  GAME:WaitFrames(18)

  -- 5. Titre + theme.
  BossMusic.Play('pic_ferreux_pied')
  UI:WaitShowTitle("Rempart, Veilleur du Vieux Fer", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 6. L'echange : le Veilleur tient la porte, il teste, il ne hait pas.
  UI:SetSpeaker(rempart)
  UI:WaitShowDialogue("Halte.[pause=20] Cette voie est tenue.")
  UI:SetSpeaker(rempart)
  UI:WaitShowDialogue("Les bâtisseurs m'ont posé ici.[pause=20] Je n'ai pas bougé depuis.")

  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue("Il est... encastré dans le pylône.[pause=20] Il fait partie de la structure !")
  end
  GeneralFunctions.HeroDialogue(hero, "Alors on lui demandera de s'écarter.", "Determined")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("mt_steel", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function pic_ferreux_pied.Update(map, time) end
function pic_ferreux_pied.GameSave(map) end
function pic_ferreux_pied.GameLoad(map) end

return pic_ferreux_pied
