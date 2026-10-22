--[[ Groudon, le Trône de Magma — cinématique d'Ancrage (Livre II, ch11).
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

local arene_trone_magma = {}

function arene_trone_magma.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function arene_trone_magma.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 320, 616, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 296, 616, Direction.Up) end
  local groudon = CharacterEssentials.MakeCharactersFromList({{'Groudon', 320, 280, Direction.Down}})
  GROUND:Hide('Groudon')
  GAME:MoveCamera(320, 272, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('molten_throne') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Groudon')
    UI:SetSpeaker(groudon)
    UI:WaitShowDialogue("La terre ne ment jamais.[pause=20] Montre-moi ce que pèsent tes pas.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("magma_cavern", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("CELUI QUI MARCHE SUR MA TERRE...[pause=20] PORTE-T-IL LE POIDS DU MONDE, OU SEULEMENT LE SIEN ?")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.Rumble({hero, partner}, 3)
  BossFX.EmergeGround(groudon, 320, 280)
  BossFX.RockFall(320 - 40, 280 - 24)
  BossFX.RockFall(320 + 44, 280 - 16)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Groudon')
  GROUND:CharSetAnim(groudon, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(groudon, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('arene_trone_magma')
  UI:WaitShowTitle("Groudon, le Trône de Magma", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("Le sol...[pause=10] le sol RESPIRE, {0} ![pause=20] Tout l'Ancrage s'est réveillé d'un coup !", hero:GetDisplayName()))
  UI:SetSpeaker(groudon)
  UI:WaitShowDialogue("La terre ne ment jamais.[pause=20] Montre-moi ce que pèsent tes pas.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("magma_cavern", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function arene_trone_magma.Update(map, time) end
function arene_trone_magma.GameSave(map) end
function arene_trone_magma.GameLoad(map) end

return arene_trone_magma
