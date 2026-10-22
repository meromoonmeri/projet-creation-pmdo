--[[ Magearna, le Cœur d'Engrenages — cinématique d'Ancrage (Livre II, ch24).
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

local carriere_magnetique = {}

function carriere_magnetique.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function carriere_magnetique.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 232, 304, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 208, 304, Direction.Up) end
  local magearna = CharacterEssentials.MakeCharactersFromList({{'Magearna', 232, 184, Direction.Down}})
  GROUND:Hide('Magearna')
  GAME:MoveCamera(232, 176, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('gear_heart') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Magearna')
    UI:SetSpeaker(magearna)
    UI:WaitShowDialogue("Mon créateur dort depuis longtemps.[pause=20] Je protège son dernier atelier.[pause=10] En garde.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("atelier_coeur_mecanique", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("QUELQU'UN M'A CONSTRUIT UN CŒUR.[pause=30] JE ME SUIS CONSTRUIT UNE ÂME.[pause=20] LAQUELLE VOULEZ-VOUS TESTER ?")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption — MACHINE : elle ne surgit pas, elle S'ALLUME. Cliquetis puis tension.
  --    Avant ce lot : un BossFX.Flash generique, identique a 10 autres
  --    arenes. Toutes les particules employees sont attestees.
  BossFX.BootMachine(magearna, 232, 184)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Magearna')
  GROUND:CharSetAnim(magearna, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(magearna, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('carriere_magnetique')
  UI:WaitShowTitle("Magearna, le Cœur d'Engrenages", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format("Chaque engrenage de la carrière tourne vers ELLE...[pause=20] comme des tournesols vers le soleil.", hero:GetDisplayName()))
  UI:SetSpeaker(magearna)
  UI:WaitShowDialogue("Mon créateur dort depuis longtemps.[pause=20] Je protège son dernier atelier.[pause=10] En garde.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("atelier_coeur_mecanique", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function carriere_magnetique.Update(map, time) end
function carriere_magnetique.GameSave(map) end
function carriere_magnetique.GameLoad(map) end

return carriere_magnetique
