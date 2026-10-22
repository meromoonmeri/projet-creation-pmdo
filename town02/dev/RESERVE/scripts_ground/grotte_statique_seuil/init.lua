--[[ La Voie de la Grotte Statique — scene "ouverture de la voie" (Reseau des Anciens Chemins).
     Ground pmd-red importe 1:1 ; geometrie intouchee, dialogues New Era.
     Jouee UNE SEULE FOIS a la premiere victoire (SV.Reseau.VoiesOuvertes).
     Sortie garantie en fin de scene ET en cas de rejeu : jamais de blocage. ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

local grotte_statique_seuil = {}

local function sortie()
  GAME:FadeOut(false, 40)
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, "master_zone", -1, 1, 0, true, true)
end

function grotte_statique_seuil.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_grotte_statique_seuil")
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function grotte_statique_seuil.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 200, 144, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 168, 144, Direction.Up) end
  GAME:MoveCamera(184, 128, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue("Mes poils se dressent...[pause=20] Tout le boyau grésille encore.")
  end
  GAME:WaitFrames(12)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("De petites décharges courent le long des parois, sans jamais toucher le sol.")
  UI:SetCenter(false)
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Elles suivent toutes le même trajet.[pause=20] Comme si un fil invisible les guidait.")
  end
  GAME:WaitFrames(12)
  -- Le mecanisme des batisseurs se rallume.
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  BossFX.Flash(184, 128, 4, 6, 24)
  GAME:WaitFrames(24)
  GAME:WaitFrames(12)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("Au fond du boyau, un anneau de métal terni s'allume et avale les étincelles.")
  UI:SetCenter(false)
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Surprised")
    UI:WaitShowDialogue("Il les absorbe ![pause=20] Ce n'était pas de l'électricité perdue... c'était du courant !")
  end
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Le Réseau se réalimente tout seul, maintenant qu'on l'a réveillé.")
  end
  GAME:WaitFrames(12)
  GeneralFunctions.HeroDialogue(hero, "Ce n'est pas une grotte. C'est un conduit.", "Normal")
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Inspired")
    UI:WaitShowDialogue("Une voie de plus qui respire.[pause=20] Allez, on rentre.")
  end
  GAME:WaitFrames(12)
  GAME:WaitFrames(20)
  GAME:CutsceneMode(false)
  sortie()
end

function grotte_statique_seuil.Update(map, time) end
function grotte_statique_seuil.GameSave(map) end
function grotte_statique_seuil.GameLoad(map) end

return grotte_statique_seuil
