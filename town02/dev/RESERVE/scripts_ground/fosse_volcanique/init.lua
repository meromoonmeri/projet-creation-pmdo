--[[ Volcanion, le Cœur de Vapeur — cinématique d'Ancrage (Livre II, ch23).
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

local fosse_volcanique = {}

function fosse_volcanique.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function fosse_volcanique.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 232, 304, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 208, 304, Direction.Up) end
  local volcanion = CharacterEssentials.MakeCharactersFromList({{'Volcanion', 232, 176, Direction.Down}})
  GROUND:Hide('Volcanion')
  GAME:MoveCamera(232, 168, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('steam_heart') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Volcanion')
    UI:SetSpeaker(volcanion)
    UI:WaitShowDialogue("Ne bouchez jamais mes évents.[pause=20] Dernier avertissement gratuit.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("forge_vapeur", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("EAU ET FEU NE S'AIMENT PAS.[pause=20] JE SUIS LEUR RÉCONCILIATION.[pause=10] FORCÉE.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.EmergeWater(volcanion, 232, 176)
  BossFX.EmergeFire(volcanion, 232, 176)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Volcanion')
  GROUND:CharSetAnim(volcanion, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(volcanion, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('fosse_volcanique')
  UI:WaitShowTitle("Volcanion, le Cœur de Vapeur", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("Les geysers respirent comme des soufflets de forge ![pause=20] Toute la fosse est SA machine !", hero:GetDisplayName()))
  UI:SetSpeaker(volcanion)
  UI:WaitShowDialogue("Ne bouchez jamais mes évents.[pause=20] Dernier avertissement gratuit.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("forge_vapeur", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function fosse_volcanique.Update(map, time) end
function fosse_volcanique.GameSave(map) end
function fosse_volcanique.GameLoad(map) end

return fosse_volcanique
