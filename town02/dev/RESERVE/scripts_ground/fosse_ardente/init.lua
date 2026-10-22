--[[ Soleil-de-Cendre, Veilleur de la Fournaise-Mère — cinematique de Veilleur (Reseau des Anciens Chemins).
     Ground pmd-red importe 1:1 ; geometrie intouchee, dialogues New Era.
     Grammaire : signal -> irruption -> recul -> reveal -> titre -> echange
     -> BossTransition -> arene. Rematch : intro raccourcie. ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.BossMusic'

local fosse_ardente = {}

function fosse_ardente.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_fosse_ardente")
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function fosse_ardente.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)

  -- Duo cote a cote (32 px d'ecart), ~80 px sous le Veilleur.
  GROUND:TeleportTo(hero, 288, 224, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 256, 224, Direction.Up) end
  local soleil = CharacterEssentials.MakeCharactersFromList({{'SoleilDeCendre', 272, 144, Direction.Down}})
  GROUND:Hide('SoleilDeCendre')
  -- Camera entre le duo et le Veilleur.
  GAME:MoveCamera(272, 184, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if SV.Reseau ~= nil and SV.Reseau.Veilleurs ~= nil and SV.Reseau.Veilleurs['new_era_zone_15'] then
    -- REMATCH : le Veilleur connait deja l'equipe, pas de ceremonie.
    GROUND:Unhide('SoleilDeCendre')
    UI:SetSpeaker(soleil)
    UI:WaitShowDialogue("Reviens dans la lumière.[pause=20] Encore une fois.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("new_era_zone_15", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voie parle avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("LA FOURNAISE-MÈRE LÈVE SES CENDRES.[pause=20] QUELQUE CHOSE Y BRÛLE ENCORE.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre a ce Veilleur).
  BossFX.Rumble({hero, partner}, 2)
  BossFX.EmergeFire(soleil, 272, 144)
  GAME:WaitFrames(20)

  -- 3. Le recul du duo.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4. Reveal.
  GROUND:Unhide('SoleilDeCendre')
  GAME:WaitFrames(18)

  -- 5. Titre + theme.
  BossMusic.Play('fosse_ardente')
  UI:WaitShowTitle("Soleil-de-Cendre, Veilleur de la Fournaise-Mère", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 6. L'echange : le Veilleur tient la porte, il teste, il ne hait pas.
  UI:SetSpeaker(soleil)
  UI:WaitShowDialogue("Je suis la lampe qu'on a laissée au fond.")
  UI:SetSpeaker(soleil)
  UI:WaitShowDialogue("Tant que je brûle, la voie existe.[pause=20] Mérite ma lumière.")

  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Inspired")
    UI:WaitShowDialogue("Ses ailes... elles éclairent toute la fosse.[pause=20] C'est presque beau.")
  end
  GeneralFunctions.HeroDialogue(hero, "C'est une lampe. Pas un bûcher.", "Determined")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("new_era_zone_15", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function fosse_ardente.Update(map, time) end
function fosse_ardente.GameSave(map) end
function fosse_ardente.GameLoad(map) end

return fosse_ardente
