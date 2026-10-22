--[[ Genesect, le Vieux Réacteur — cinématique d'Ancrage (Livre II, ch22).
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

local labo_decrepit = {}

function labo_decrepit.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function labo_decrepit.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 232, 304, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 208, 304, Direction.Up) end
  local genesect = CharacterEssentials.MakeCharactersFromList({{'Genesect', 232, 144, Direction.Down}})
  GROUND:Hide('Genesect')
  GAME:MoveCamera(232, 136, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('old_reactor') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Genesect')
    UI:SetSpeaker(genesect)
    UI:WaitShowDialogue("Intrusion détectée.[pause=10] Protocole :[pause=10] évaluation par le combat.[pause=20] Commencer.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("reacteur_enfoui", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("SYSTÈME... EN LIGNE.[pause=20] DERNIER ORDRE REÇU :[pause=10] GARDER.[pause=20] DURÉE ÉCOULÉE : INCONNUE.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption — MACHINE : demarrage d'une arme qu'on avait laissee eteinte.
  --    Avant ce lot : un BossFX.Flash generique, identique a 10 autres
  --    arenes. Toutes les particules employees sont attestees.
  BossFX.BootMachine(genesect, 232, 144)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Genesect')
  GROUND:CharSetAnim(genesect, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(genesect, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('labo_decrepit')
  UI:WaitShowTitle("Genesect, le Vieux Réacteur", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("Ces machines ont des SIÈCLES...[pause=20] et il y en a une qui vient de rallumer ses yeux.", hero:GetDisplayName()))
  UI:SetSpeaker(genesect)
  UI:WaitShowDialogue("Intrusion détectée.[pause=10] Protocole :[pause=10] évaluation par le combat.[pause=20] Commencer.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("reacteur_enfoui", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function labo_decrepit.Update(map, time) end
function labo_decrepit.GameSave(map) end
function labo_decrepit.GameLoad(map) end

return labo_decrepit
