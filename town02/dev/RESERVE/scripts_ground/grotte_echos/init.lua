--[[ Meloetta, le Dernier Rappel — cinématique d'Ancrage (Livre II, ch20).
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

local grotte_echos = {}

function grotte_echos.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function grotte_echos.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 240, 352, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 216, 352, Direction.Up) end
  local meloetta = CharacterEssentials.MakeCharactersFromList({{'Meloetta', 240, 232, Direction.Down}})
  GROUND:Hide('Meloetta')
  GAME:MoveCamera(240, 224, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('last_encore') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Meloetta')
    UI:SetSpeaker(meloetta)
    UI:WaitShowDialogue("Vous êtes mon premier public depuis mille ans.[pause=30] Le prix du billet, c'est un duel.[pause=10] En mesure !")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("amphitheatre_oublie", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("LE CHANT S'EST TU IL Y A DES SIÈCLES.[pause=30] LA SALLE ATTEND ENCORE D'APPLAUDIR.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  SOUND:FadeOutBGM(40)
  GAME:WaitFrames(50)
  BossFX.EmergeMist(meloetta, 240, 232)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Meloetta')
  GROUND:CharSetAnim(meloetta, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(meloetta, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('grotte_echos')
  UI:WaitShowTitle("Meloetta, le Dernier Rappel", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format("Cette mélodie...[pause=10] l'écho la TERMINE tout seul ![pause=20] Quelqu'un chante avec la grotte, {0}.", hero:GetDisplayName()))
  UI:SetSpeaker(meloetta)
  UI:WaitShowDialogue("Vous êtes mon premier public depuis mille ans.[pause=30] Le prix du billet, c'est un duel.[pause=10] En mesure !")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("amphitheatre_oublie", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function grotte_echos.Update(map, time) end
function grotte_echos.GameSave(map) end
function grotte_echos.GameLoad(map) end

return grotte_echos
