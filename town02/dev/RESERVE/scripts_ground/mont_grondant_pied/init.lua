--[[ Câble-Vif, Veilleur du Grand Orage — cinematique de Veilleur (Reseau des Anciens Chemins).
     Ground pmd-red importe 1:1 ; geometrie intouchee, dialogues New Era.
     Grammaire : signal -> irruption -> recul -> reveal -> titre -> echange
     -> BossTransition -> arene. Rematch : intro raccourcie. ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.BossMusic'

local mt_thunder_pied = {}

function mt_thunder_pied.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_mt_thunder_pied")
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function mt_thunder_pied.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)

  -- Duo cote a cote (32 px d'ecart), ~72 px sous le Veilleur.
  GROUND:TeleportTo(hero, 200, 248, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 168, 248, Direction.Up) end
  local cablevif = CharacterEssentials.MakeCharactersFromList({{'CableVif', 184, 176, Direction.Down}})
  GROUND:Hide('CableVif')
  -- Camera entre le duo et le Veilleur.
  GAME:MoveCamera(184, 212, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if SV.Reseau ~= nil and SV.Reseau.Veilleurs ~= nil and SV.Reseau.Veilleurs['new_era_zone_05'] then
    -- REMATCH : le Veilleur connait deja l'equipe, pas de ceremonie.
    GROUND:Unhide('CableVif')
    UI:SetSpeaker(cablevif)
    UI:WaitShowDialogue("Signal — connu.[pause=15] Recommence.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("new_era_zone_05", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voie parle avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("L'ANTENNE CRACHE.[pause=20] QUELQUE CHOSE REMONTE LE CÂBLE.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre a ce Veilleur).
  BossFX.Flash(184, 176, 3, 5, 20)
  GAME:WaitFrames(8)
  BossFX.Impact(10)
  GAME:WaitFrames(20)

  -- 3. Le recul du duo.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4. Reveal.
  GROUND:Unhide('CableVif')
  GAME:WaitFrames(18)

  -- 5. Titre + theme.
  BossMusic.Play('mt_thunder_pied')
  UI:WaitShowTitle("Câble-Vif, Veilleur du Grand Orage", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 6. L'echange : le Veilleur tient la porte, il teste, il ne hait pas.
  UI:SetSpeaker(cablevif)
  UI:WaitShowDialogue("Signal — reçu.[pause=15] Intrus — confirmé.")
  UI:SetSpeaker(cablevif)
  UI:WaitShowDialogue("Je tiens la ligne.[pause=15] Depuis toujours.[pause=15] Prouve que tu passes.")

  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Surprised")
    UI:WaitShowDialogue("Sa voix grésille comme un parasite...[pause=20] Elle sort des câbles eux-mêmes !")
  end
  GeneralFunctions.HeroDialogue(hero, "On ne coupera pas la ligne. On la traverse.", "Determined")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("new_era_zone_05", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function mt_thunder_pied.Update(map, time) end
function mt_thunder_pied.GameSave(map) end
function mt_thunder_pied.GameLoad(map) end

return mt_thunder_pied
