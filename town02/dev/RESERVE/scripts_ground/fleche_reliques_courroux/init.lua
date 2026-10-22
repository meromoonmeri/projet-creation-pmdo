--[[ Dialga, l'Heure qui Traîne — cinématique d'Ancrage (Livre II, ch28).
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

local fleche_reliques_courroux = {}

function fleche_reliques_courroux.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function fleche_reliques_courroux.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 272, 568, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 248, 568, Direction.Up) end
  local dialga = CharacterEssentials.MakeCharactersFromList({{'Dialga', 272, 256, Direction.Down}})
  GROUND:Hide('Dialga')
  GAME:MoveCamera(272, 248, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('hour_that_lags') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Dialga')
    UI:SetSpeaker(dialga)
    UI:WaitShowDialogue("Le temps saigne ici depuis trop longtemps.[pause=20] Soignez-le, ou devenez une seconde de plus dans ma collection.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("tour_reliques", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("CHAQUE SECONDE QUE VOUS AVEZ VÉCUE M'APPARTIENT.[pause=20] VOUS VENEZ ME RENDRE LES VÔTRES ?")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.AwakenCrystal(dialga, 272, 256)
  BossFX.ShakeScreen(4, 40)
  GAME:WaitFrames(10)
  BossFX.ShakeScreen(2, 20)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Dialga')
  GROUND:CharSetAnim(dialga, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(dialga, "Idle", true)
  -- 6. Titre + thème.
  SOUND:PlayBGM("Dialga's Fight To the Finish!.ogg", true)
  -- Theme propre a cette arene (cf. BossMusic.lua).
  BossMusic.Play('fleche_reliques_courroux')
  UI:WaitShowTitle("Dialga, l'Heure qui Traîne", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("Le ciel est devenu ROUGE d'un coup ![pause=20] Et nos pas...[pause=10] l'écho arrive AVANT le pas, {0} !", hero:GetDisplayName()))
  UI:SetSpeaker(dialga)
  UI:WaitShowDialogue("Le temps saigne ici depuis trop longtemps.[pause=20] Soignez-le, ou devenez une seconde de plus dans ma collection.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("tour_reliques", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function fleche_reliques_courroux.Update(map, time) end
function fleche_reliques_courroux.GameSave(map) end
function fleche_reliques_courroux.GameLoad(map) end

return fleche_reliques_courroux
