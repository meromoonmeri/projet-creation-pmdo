-- [dungeon_builder] recâblage : scène du gardien puis combat sur l'étage d'arène du segment 2 de mt_faraway : cinématique et combat au même endroit
--[[ Ho-Oh, le Bûcher de l'Aurore — cinématique d'Ancrage (Livre II, ch18).
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

local sommet_aurore = {}

function sommet_aurore.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function sommet_aurore.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 280, 256, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 256, 256, Direction.Up) end
  local hooh = CharacterEssentials.MakeCharactersFromList({{'HoOh', 280, 208, Direction.Down}})
  GROUND:Hide('HoOh')
  GAME:MoveCamera(280, 200, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('rainbow_ash') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('HoOh')
    UI:SetSpeaker(hooh)
    UI:WaitShowDialogue("J'ai promis de revenir quand les cœurs seraient purs.[pause=20] Montrez-moi que j'ai bien choisi ma date.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("mt_faraway", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("CEUX QUI GRIMPENT POUR ÊTRE VUS TOMBENT.[pause=20] CEUX QUI GRIMPENT POUR VOIR, PARFOIS, S'ENVOLENT.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.DescendSky(hooh, 280, 208, 160)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('HoOh')
  GROUND:CharSetAnim(hooh, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(hooh, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('sommet_aurore')
  UI:WaitShowTitle("Ho-Oh, le Bûcher de l'Aurore", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue(STRINGS:Format("Un arc-en-ciel...[pause=10] en pleine nuit ![pause=20] {0}, regarde — le ciel BRÛLE de couleurs !", hero:GetDisplayName()))
  UI:SetSpeaker(hooh)
  UI:WaitShowDialogue("J'ai promis de revenir quand les cœurs seraient purs.[pause=20] Montrez-moi que j'ai bien choisi ma date.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("mt_faraway", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function sommet_aurore.Update(map, time) end
function sommet_aurore.GameSave(map) end
function sommet_aurore.GameLoad(map) end

return sommet_aurore
