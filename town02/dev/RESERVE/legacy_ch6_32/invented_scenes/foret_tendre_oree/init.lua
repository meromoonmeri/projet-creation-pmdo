--[[ La Voie de la Forêt Tendre — scene "ouverture de la voie" (Reseau des Anciens Chemins).
     Ground pmd-red importe 1:1 ; geometrie intouchee, dialogues New Era.
     Jouee UNE SEULE FOIS a la premiere victoire (SV.Reseau.VoiesOuvertes).
     Sortie garantie en fin de scene ET en cas de rejeu : jamais de blocage. ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

local foret_tendre_oree = {}

local function sortie()
  GAME:FadeOut(false, 40)
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, "master_zone", -1, 1, 0, true, true)
end

function foret_tendre_oree.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_foret_tendre_oree")
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function foret_tendre_oree.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 216, 184, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 184, 184, Direction.Up) end
  GAME:MoveCamera(200, 168, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Regarde...[pause=20] la clairière s'est ouverte toute seule devant nous.")
  end
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Happy")
    UI:WaitShowDialogue("L'herbe est si douce ici.[pause=20] On dirait qu'elle n'a jamais été piétinée.")
  end
  GAME:WaitFrames(12)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("Sous la mousse, une dalle plate affleure — trop régulière pour être une pierre.")
  UI:SetCenter(false)
  GAME:WaitFrames(12)
  -- Le mecanisme des batisseurs se rallume.
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  BossFX.Flash(200, 168, 4, 6, 24)
  GAME:WaitFrames(24)
  GAME:WaitFrames(12)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("La dalle s'éclaire faiblement, puis émet un bourdonnement grave et régulier.")
  UI:SetCenter(false)
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Surprised")
    UI:WaitShowDialogue("Ça ronronne ![pause=20] Comme les Terminaux de Sauvegarde de la guilde !")
  end
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Alors c'est vrai...[pause=20] les vieilles voies se rallument une par une.")
  end
  GAME:WaitFrames(12)
  GeneralFunctions.HeroDialogue(hero, "Quelqu'un a construit tout ça. Et l'a laissé nous attendre.", "Normal")
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Inspired")
    UI:WaitShowDialogue("Une voie de plus rouverte.[pause=20] Rentrons le dire à la guilde !")
  end
  GAME:WaitFrames(12)
  GAME:WaitFrames(20)
  GAME:CutsceneMode(false)
  sortie()
end

function foret_tendre_oree.Update(map, time) end
function foret_tendre_oree.GameSave(map) end
function foret_tendre_oree.GameLoad(map) end

return foret_tendre_oree
