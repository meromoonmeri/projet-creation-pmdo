--[[ Rayquaza, le Neuvième Sommet — cinématique d'Ancrage (Livre II, ch27).
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

local vigie_stratos = {}

function vigie_stratos.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function vigie_stratos.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 232, 304, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 208, 304, Direction.Up) end
  local rayquaza = CharacterEssentials.MakeCharactersFromList({{'Rayquaza', 232, 184, Direction.Down}})
  GROUND:Hide('Rayquaza')
  GAME:MoveCamera(232, 176, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('ninth_summit') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Rayquaza')
    UI:SetSpeaker(rayquaza)
    UI:WaitShowDialogue("Vous avez franchi la ligne verte du monde.[pause=20] Nul ne redescend sans mon accord.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("hauteurs_etoile", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("HUIT SOMMETS PORTENT LE CIEL.[pause=20] LE NEUVIÈME, C'EST MOI.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.DescendSky(rayquaza, 232, 184, 160)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Rayquaza')
  GROUND:CharSetAnim(rayquaza, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(rayquaza, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('vigie_stratos')
  UI:WaitShowTitle("Rayquaza, le Neuvième Sommet", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("L'Arbitre du Ciel...[pause=20] La légende de Reinier disait vrai :[pause=10] il ne bouge que si on franchit SON ciel.[pause=20] Et on vient de le faire.", hero:GetDisplayName()))
  UI:SetSpeaker(rayquaza)
  UI:WaitShowDialogue("Vous avez franchi la ligne verte du monde.[pause=20] Nul ne redescend sans mon accord.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("hauteurs_etoile", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function vigie_stratos.Update(map, time) end
function vigie_stratos.GameSave(map) end
function vigie_stratos.GameLoad(map) end

return vigie_stratos
