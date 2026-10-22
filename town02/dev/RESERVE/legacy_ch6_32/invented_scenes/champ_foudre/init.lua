--[[ La Voie du Champ des Cent Éclairs — scene "ouverture de la voie" (Reseau des Anciens Chemins).
     Ground pmd-red importe 1:1 ; geometrie intouchee, dialogues New Era.
     Jouee UNE SEULE FOIS a la premiere victoire (SV.Reseau.VoiesOuvertes).
     Sortie garantie en fin de scene ET en cas de rejeu : jamais de blocage. ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

local champ_foudre = {}

local function sortie()
  GAME:FadeOut(false, 40)
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, "master_zone", -1, 1, 0, true, true)
end

function champ_foudre.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_champ_foudre")
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function champ_foudre.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 192, 144, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 160, 144, Direction.Up) end
  GAME:MoveCamera(176, 128, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue("Cent éclairs à la minute...[pause=20] et pas un seul ne tombe sur nous.")
  end
  GAME:WaitFrames(12)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("La foudre frappe toujours aux mêmes endroits, à intervalles réguliers.")
  UI:SetCenter(false)
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Surprised")
    UI:WaitShowDialogue("Ils tombent en cadence ![pause=20] Ce n'est pas un orage, c'est une horloge !")
  end
  GAME:WaitFrames(12)
  -- Le mecanisme des batisseurs se rallume.
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  BossFX.Flash(176, 128, 4, 6, 24)
  GAME:WaitFrames(24)
  GAME:WaitFrames(12)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("Au centre du champ, un mât noirci encaisse un éclair et se met à luire.")
  UI:SetCenter(false)
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Le mât les attire tous.[pause=20] Il protège le passage depuis des siècles.")
  end
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue("S'il tombait un jour, plus personne ne traverserait ce champ.")
  end
  GAME:WaitFrames(12)
  GeneralFunctions.HeroDialogue(hero, "Alors il tiendra. Comme les autres.", "Normal")
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Inspired")
    UI:WaitShowDialogue("Une voie de plus rouverte.[pause=20] Et celle-là fait du bruit !")
  end
  GAME:WaitFrames(12)
  GAME:WaitFrames(20)
  GAME:CutsceneMode(false)
  sortie()
end

function champ_foudre.Update(map, time) end
function champ_foudre.GameSave(map) end
function champ_foudre.GameLoad(map) end

return champ_foudre
