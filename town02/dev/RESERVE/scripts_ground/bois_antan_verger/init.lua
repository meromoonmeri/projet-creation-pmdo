--[[ Celebi, les Heures Mortes — cinématique d'Ancrage (Livre II, ch20).
     Ground template d'origine conservé 1:1 ; dialogues New Era.
     Grammaire Rescue Team : signal -> irruption -> recul -> flash -> reveal
     -> titre -> ligne courte. Rematch : intro raccourcie. ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.LegendZones'
require 'halcyon.BossMusic'

local purity_forest_verger = {}

function purity_forest_verger.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function purity_forest_verger.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 272, 544, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 248, 544, Direction.Up) end
  local celebi = CharacterEssentials.MakeCharactersFromList({{'Celebi', 272, 248, Direction.Down}})
  GROUND:Hide('Celebi')
  GAME:MoveCamera(272, 240, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('dead_hours') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Celebi')
    UI:SetSpeaker(celebi)
    UI:WaitShowDialogue("Tu portes une mémoire qui n'est pas la tienne.[pause=20] Voyons si tu mérites de la garder.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("purity_forest", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("CE VERGER A CONNU MILLE PRINTEMPS.[pause=20] JE LES GARDE TOUS.[pause=10] MÊME CEUX QUI N'ONT PAS EU LIEU.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.EmergeMist(celebi, 272, 248)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Celebi')
  GROUND:CharSetAnim(celebi, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(celebi, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('purity_forest_verger')
  UI:WaitShowTitle("Celebi, les Heures Mortes", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("Les pommes...[pause=10] elles mûrissent et pourrissent en boucle ![pause=20] Le temps tourne en rond ici !", hero:GetDisplayName()))
  UI:SetSpeaker(celebi)
  UI:WaitShowDialogue("Tu portes une mémoire qui n'est pas la tienne.[pause=20] Voyons si tu mérites de la garder.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("purity_forest", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function purity_forest_verger.Update(map, time) end
function purity_forest_verger.GameSave(map) end
function purity_forest_verger.GameLoad(map) end

return purity_forest_verger
