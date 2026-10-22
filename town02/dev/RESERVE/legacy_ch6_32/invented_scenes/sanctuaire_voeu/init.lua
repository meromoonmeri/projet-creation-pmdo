--[[ Jirachi, les Vœux Tus — cinématique d'Ancrage (Livre II, ch31).
     Ground template d'origine conservé 1:1 ; dialogues New Era.
     Grammaire Rescue Team : signal -> irruption -> recul -> flash -> reveal
     -> titre -> ligne courte. Rematch : intro raccourcie.

]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.LegendZones'
require 'halcyon.BossMusic'
require 'halcyon.WishSystem'

local sanctuaire_voeu = {}

function sanctuaire_voeu.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function sanctuaire_voeu.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)

  -- Retour après la victoire 99F : le vœu est accordé dans la même salle.
  if SV.WishCave and SV.WishCave.PendingWish then
    SV.WishCave.PendingWish=false
    GAME:FadeIn(30)
    WishSystem.Grant()
    GAME:CutsceneMode(false)
    GAME:FadeOut(false,30)
    GAME:EnterZone('master_zone',-1,1,0)
    return
  end

  GROUND:TeleportTo(hero, 160, 272, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 136, 272, Direction.Up) end
  local jirachi = CharacterEssentials.MakeCharactersFromList({{'Jirachi', 176, 136, Direction.Down}})
  GROUND:Hide('Jirachi')
  GAME:MoveCamera(176, 128, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('unsaid_wishes') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Jirachi')
    UI:SetSpeaker(jirachi)
    UI:WaitShowDialogue("Le vœu tient toujours.[pause=20] Et vous ?")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("wish_cave", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("MILLE ANS DE VŒUX MURMURES DORMENT ICI.[pause=30] LE VÔTRE EST DÉJÀ ÉCRIT.[pause=20] VOULEZ-VOUS LE LIRE ?")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien).
  BossFX.AwakenCrystal(jirachi, 176, 136)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Jirachi')
  GROUND:CharSetAnim(jirachi, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(jirachi, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('sanctuaire_voeu')
  UI:WaitShowTitle("Jirachi, les Vœux Tus", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format("L'étoile...[pause=10] elle s'ouvre ![pause=20] {0}, il ÉTAIT là depuis mille ans — il nous ATTENDAIT ?", hero:GetDisplayName()))
  UI:SetSpeaker(jirachi)
  UI:WaitShowDialogue("Il y a vingt-cinq ans, quelqu'un est tombé du ciel et a fait un vœu pour vous tous.[pause=30] Venez.[pause=10] Je vous montrerai lequel.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("wish_cave", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function sanctuaire_voeu.Update(map, time) end
function sanctuaire_voeu.GameSave(map) end
function sanctuaire_voeu.GameLoad(map) end

return sanctuaire_voeu
