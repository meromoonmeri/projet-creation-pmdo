--[[ Melmetal, le Métal Liquide — cinématique d'Ancrage (Livre II, ch27).
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

local grotte_rocheuse = {}

function grotte_rocheuse.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function grotte_rocheuse.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 240, 352, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 216, 352, Direction.Up) end
  local melmetal = CharacterEssentials.MakeCharactersFromList({{'Melmetal', 220, 208, Direction.Down}})
  GROUND:Hide('Melmetal')
  local meltan = CharacterEssentials.MakeCharactersFromList({{'Meltan', 260, 208, Direction.Down}})
  GROUND:Hide('Meltan')
  GAME:MoveCamera(240, 200, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('liquid_metal') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Melmetal')
    GROUND:Unhide('Meltan')
    UI:SetSpeaker(melmetal)
    UI:WaitShowDialogue("GLOONG.[pause=20] (Le colosse fait tinter son poing comme une cloche.[pause=10] C'est probablement une invitation.)")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("fonderie_hex", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("LE VIEUX MANGEUR D'ÉCROUS EST REVENU AVEC UN CORPS DE FER.[pause=20] IL SE SOUVIENT D'AVOIR ÉTÉ PETIT.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.Rumble({hero, partner}, 2)
  BossFX.EmergeGround(melmetal, 220, 208)
  BossFX.Impact(3, true)
  GAME:WaitFrames(25)
  BossFX.Rumble({hero, partner}, 2)
  BossFX.EmergeGround(meltan, 260, 208)
  BossFX.Impact(3, true)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Melmetal')
  GROUND:CharSetAnim(melmetal, "Attack", false)
  GROUND:Unhide('Meltan')
  GROUND:CharSetAnim(meltan, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(melmetal, "Idle", true)
  GROUND:CharSetAnim(meltan, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('grotte_rocheuse')
  UI:WaitShowTitle("Melmetal, le Métal Liquide", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("Les flaques de métal FRISSONNENT...[pause=20] et la petite goutte là-bas nous fait... coucou ?", hero:GetDisplayName()))
  UI:SetSpeaker(melmetal)
  UI:WaitShowDialogue("GLOONG.[pause=20] (Le colosse fait tinter son poing comme une cloche.[pause=10] C'est probablement une invitation.)")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("fonderie_hex", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function grotte_rocheuse.Update(map, time) end
function grotte_rocheuse.GameSave(map) end
function grotte_rocheuse.GameLoad(map) end

return grotte_rocheuse
