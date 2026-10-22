--[[ La Voie des Bois Sombres — scene "ouverture de la voie" (Reseau des Anciens Chemins).
     Ground pmd-red importe 1:1 ; geometrie intouchee, dialogues New Era.
     Jouee UNE SEULE FOIS a la premiere victoire (SV.Reseau.VoiesOuvertes).
     Sortie garantie en fin de scene ET en cas de rejeu : jamais de blocage. ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

local bois_sombres_oree = {}

local function sortie()
  GAME:FadeOut(false, 40)
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, "master_zone", -1, 1, 0, true, true)
end

function bois_sombres_oree.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_bois_sombres_oree")
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function bois_sombres_oree.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 224, 184, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 192, 184, Direction.Up) end
  GAME:MoveCamera(208, 168, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue("Il fait plus sombre ici qu'au fond du donjon...[pause=20] et pourtant on est à l'orée.")
  end
  GAME:WaitFrames(12)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("Les troncs sont alignés. Pas plantés au hasard : alignés.")
  UI:SetCenter(false)
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Surprised")
    UI:WaitShowDialogue("Tu as vu ?[pause=20] Ils forment une allée.[pause=15] Quelqu'un les a disposés ainsi.")
  end
  GAME:WaitFrames(12)
  -- Le mecanisme des batisseurs se rallume.
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  BossFX.Flash(208, 168, 4, 6, 24)
  GAME:WaitFrames(24)
  GAME:WaitFrames(12)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("Entre deux racines, une borne de pierre se met à luire d'une lumière pâle.")
  UI:SetCenter(false)
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Une borne...[pause=20] Elle marque le début du chemin, pas la fin.")
  end
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue("Les bâtisseurs voulaient qu'on puisse retrouver la sortie dans le noir.")
  end
  GAME:WaitFrames(12)
  GeneralFunctions.HeroDialogue(hero, "Ils pensaient à ceux qui viendraient après.", "Normal")
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Inspired")
    UI:WaitShowDialogue("Et nous voilà.[pause=20] Une voie de plus rouverte.")
  end
  GAME:WaitFrames(12)
  GAME:WaitFrames(20)
  GAME:CutsceneMode(false)
  sortie()
end

function bois_sombres_oree.Update(map, time) end
function bois_sombres_oree.GameSave(map) end
function bois_sombres_oree.GameLoad(map) end

return bois_sombres_oree
