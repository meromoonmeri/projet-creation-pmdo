--[[ Cresselia et Darkrai, les Deux Visages de la Lune — cinématique d'Ancrage (Livre II, ch23).
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

local mont_lune_vue = {}

function mont_lune_vue.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function mont_lune_vue.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 192, 328, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 168, 328, Direction.Up) end
  local cresselia = CharacterEssentials.MakeCharactersFromList({{'Cresselia', 172, 192, Direction.Down}})
  GROUND:Hide('Cresselia')
  local darkrai = CharacterEssentials.MakeCharactersFromList({{'Darkrai', 212, 192, Direction.Down}})
  GROUND:Hide('Darkrai')
  GAME:MoveCamera(192, 184, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('soft_sleep') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Cresselia')
    GROUND:Unhide('Darkrai')
    UI:SetSpeaker(cresselia)
    UI:WaitShowDialogue("Il est mon ombre. Je suis son excuse.[pause=20] L'Ancrage nous a liés :[pause=10] affrontez-nous ENSEMBLE, ou pas du tout.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("cour_clair_lune", 5, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("TOUTE LUMIÈRE A SON OMBRE.[pause=20] CE SOIR, LA LUNE MONTRE SES DEUX VISAGES.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.AwakenCrystal(cresselia, 172, 192)
  GAME:WaitFrames(25)
  BossFX.AwakenCrystal(darkrai, 212, 192)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Cresselia')
  GROUND:CharSetAnim(cresselia, "Attack", false)
  GROUND:Unhide('Darkrai')
  GROUND:CharSetAnim(darkrai, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(cresselia, "Idle", true)
  GROUND:CharSetAnim(darkrai, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('mont_lune_vue')
  UI:WaitShowTitle("Cresselia et Darkrai, les Deux Visages de la Lune", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("Deux présences ![pause=20] Une qui apaise...[pause=10] une qui GLACE.[pause=20] Et elles ne se battent PAS entre elles ?!", hero:GetDisplayName()))
  UI:SetSpeaker(cresselia)
  UI:WaitShowDialogue("Il est mon ombre. Je suis son excuse.[pause=20] L'Ancrage nous a liés :[pause=10] affrontez-nous ENSEMBLE, ou pas du tout.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("cour_clair_lune", 5, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function mont_lune_vue.Update(map, time) end
function mont_lune_vue.GameSave(map) end
function mont_lune_vue.GameLoad(map) end

return mont_lune_vue
