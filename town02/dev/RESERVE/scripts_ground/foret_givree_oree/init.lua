--[[ Blizzard-Sentinelle, Veilleur du Givre — cinematique de Veilleur (Reseau des Anciens Chemins).
     Ground pmd-red importe 1:1 ; geometrie intouchee, dialogues New Era.
     Grammaire : signal -> irruption -> recul -> reveal -> titre -> echange
     -> BossTransition -> arene. Rematch : intro raccourcie. ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.BossMusic'

local foret_givree_oree = {}

function foret_givree_oree.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_foret_givree_oree")
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function foret_givree_oree.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)

  -- Duo cote a cote (32 px d'ecart), ~72 px sous le Veilleur.
  GROUND:TeleportTo(hero, 152, 272, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 120, 272, Direction.Up) end
  local blizzard = CharacterEssentials.MakeCharactersFromList({{'BlizzardSentinelle', 136, 200, Direction.Down}})
  GROUND:Hide('BlizzardSentinelle')
  -- Camera entre le duo et le Veilleur.
  GAME:MoveCamera(136, 236, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if SV.Reseau ~= nil and SV.Reseau.Veilleurs ~= nil and SV.Reseau.Veilleurs['new_era_zone_11'] then
    -- REMATCH : le Veilleur connait deja l'equipe, pas de ceremonie.
    GROUND:Unhide('BlizzardSentinelle')
    UI:SetSpeaker(blizzard)
    UI:WaitShowDialogue("Encore.[pause=25] Bien.[pause=20] Recommençons.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("new_era_zone_11", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voie parle avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("LA FORÊT A CESSÉ DE BOUGER.[pause=20] ELLE ÉCOUTE.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre a ce Veilleur).
  BossFX.EmergeMist(blizzard, 136, 200)
  GAME:WaitFrames(20)

  -- 3. Le recul du duo.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4. Reveal.
  GROUND:Unhide('BlizzardSentinelle')
  GAME:WaitFrames(18)

  -- 5. Titre + theme.
  BossMusic.Play('foret_givree_oree')
  UI:WaitShowTitle("Blizzard-Sentinelle, Veilleur du Givre", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 6. L'echange : le Veilleur tient la porte, il teste, il ne hait pas.
  UI:SetSpeaker(blizzard)
  UI:WaitShowDialogue("Lentement.[pause=25] Tout ce qui dure va lentement.")
  UI:SetSpeaker(blizzard)
  UI:WaitShowDialogue("J'ai vu le gel prendre cette voie.[pause=25] Je verrai qui la rouvre.")

  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue("Le givre monte le long des arbres...[pause=20] et il parle si lentement.")
  end
  GeneralFunctions.HeroDialogue(hero, "Il a le temps. Nous, non.", "Determined")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("new_era_zone_11", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function foret_givree_oree.Update(map, time) end
function foret_givree_oree.GameSave(map) end
function foret_givree_oree.GameLoad(map) end

return foret_givree_oree
