--[[ La Voie du Gouffre Muet — scene "ouverture de la voie" (Reseau des Anciens Chemins).
     Ground pmd-red importe 1:1 ; geometrie intouchee, dialogues New Era.
     Jouee UNE SEULE FOIS a la premiere victoire (SV.Reseau.VoiesOuvertes).
     Sortie garantie en fin de scene ET en cas de rejeu : jamais de blocage. ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

local gouffre_muet_bord = {}

local function sortie()
  GAME:FadeOut(false, 40)
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, "master_zone", -1, 1, 0, true, true)
end

function gouffre_muet_bord.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_gouffre_muet_bord")
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function gouffre_muet_bord.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 240, 144, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 208, 144, Direction.Up) end
  GAME:MoveCamera(224, 128, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue("Écoute...[pause=25] Non. Justement.[pause=20] On n'entend rien du tout.")
  end
  GAME:WaitFrames(12)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("Le gouffre avale les sons. Même les pas ne portent pas.")
  UI:SetCenter(false)
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Surprised")
    UI:WaitShowDialogue("J'ai crié et je ne me suis pas entendu ![pause=20] C'est ce silence qui est anormal.")
  end
  GAME:WaitFrames(12)
  -- Le mecanisme des batisseurs se rallume.
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  BossFX.Flash(224, 128, 4, 6, 24)
  GAME:WaitFrames(24)
  GAME:WaitFrames(12)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("Une plaque gravée s'illumine au bord du vide, et un son grave revient enfin.")
  UI:SetCenter(false)
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Le son est... rendu ?[pause=20] Comme si le mécanisme le retenait jusqu'ici.")
  end
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue("Les bâtisseurs ont fait taire ce gouffre exprès.[pause=20] Pour protéger quoi ?")
  end
  GAME:WaitFrames(12)
  GeneralFunctions.HeroDialogue(hero, "Peut-être pour protéger ceux qui passaient.", "Normal")
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Inspired")
    UI:WaitShowDialogue("La voie est rouverte.[pause=20] Et elle a retrouvé sa voix.")
  end
  GAME:WaitFrames(12)
  GAME:WaitFrames(20)
  GAME:CutsceneMode(false)
  sortie()
end

function gouffre_muet_bord.Update(map, time) end
function gouffre_muet_bord.GameSave(map) end
function gouffre_muet_bord.GameLoad(map) end

return gouffre_muet_bord
