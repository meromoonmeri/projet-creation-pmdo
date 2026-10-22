--[[ Déchire-Nuages, Veilleur du Ciel Fracturé — cinematique de Veilleur (Reseau des Anciens Chemins).
     Ground pmd-red importe 1:1 ; geometrie intouchee, dialogues New Era.
     Grammaire : signal -> irruption -> recul -> reveal -> titre -> echange
     -> BossTransition -> arene. Rematch : intro raccourcie.
     
     INTÉGRATION DE L'HISTOIRE (CHAPITRE 10 - RELAIS) :
     Pendant l'histoire principale, cette zone sert de relais d'altitude (palier_celeste)
     au milieu de la Tour Céleste. Elle dispose d'une sauvegarde et d'un accès sécurisé au segment 2.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.BossMusic'

local palier_celeste = {}

function palier_celeste.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_palier_celeste")
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function palier_celeste.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)

  -- LIAISON DE L'HISTOIRE DE LA TOUR CÉLESTE (CHAPITRE 10)
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 10 then
    palier_celeste.PlayStoryRelay(hero, partner)
    return
  end

  -- Duo cote a cote (32 px d'ecart), ~80 px sous le Veilleur.
  GROUND:TeleportTo(hero, 240, 296, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 208, 296, Direction.Up) end
  local dechire = CharacterEssentials.MakeCharactersFromList({{'DechireNuages', 224, 216, Direction.Down}})
  GROUND:Hide('DechireNuages')
  -- Camera entre le duo et le Veilleur.
  GAME:MoveCamera(224, 256, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if SV.Reseau ~= nil and SV.Reseau.Veilleurs ~= nil and SV.Reseau.Veilleurs['new_era_zone_17'] then
    -- REMATCH : le Veilleur connait deja l'equipe, pas de ceremonie.
    GROUND:Unhide('DechireNuages')
    UI:SetSpeaker(dechire)
    UI:WaitShowDialogue("Tu redescends du ciel ?[pause=20] Recommence donc.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("sky_tower", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voie parle avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("LE PALIER TREMBLE.[pause=20] QUELQUE CHOSE DESCEND DE LA FRACTURE.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre a ce Veilleur).
  BossFX.DescendSky(dechire, 224, 216, 150)
  GAME:WaitFrames(20)

  -- 3. Le recul du duo.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4. Reveal.
  GROUND:Unhide('DechireNuages')
  GAME:WaitFrames(18)

  -- 5. Titre + theme.
  BossMusic.Play('palier_celeste')
  UI:WaitShowTitle("Déchire-Nuages, Veilleur du Ciel Fracturé", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 6. L'echange : le Veilleur tient la porte, il teste, il ne hait pas.
  UI:SetSpeaker(dechire)
  UI:WaitShowDialogue("Le ciel n'est pas un chemin.[pause=20] C'est un privilège.")
  UI:SetSpeaker(dechire)
  UI:WaitShowDialogue("Les bâtisseurs m'ont laissé la dernière marche.[pause=20] Franchis-la, si tu peux.")

  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue("Il est descendu d'un seul battement d'ailes...[pause=20] On est si haut.")
  end
  GeneralFunctions.HeroDialogue(hero, "La dernière marche est encore une marche.", "Determined")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("sky_tower", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

-- ============================================================
-- MODE RELAIS DE L'HISTOIRE (TOUR CÉLESTE)
-- ============================================================
function palier_celeste.PlayStoryRelay(hero, partner)
  GROUND:TeleportTo(hero, 224, 296, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 192, 296, Direction.Up) end
  GAME:MoveCamera(208, 250, 1, false)
  
  GAME:FadeIn(30)
  GAME:CutsceneMode(false) -- Permettre le mouvement pour sauvegarder ou monter
end

function palier_celeste.Dungeon_Entrance_Touch(obj, activator)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:ChoiceMenuYesNo("Continuer l'ascension de la Tour Céleste ?", true)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  UI:SetCenter(false)
  if res then
    GAME:FadeOut(false, 40)
    -- Envoie le joueur au segment 2 (Mer de Nuages) de la Tour Céleste
    GAME:ContinueDungeon("sky_tower", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end

function palier_celeste.Kangaskhan_Rock_Action(obj, activator)
  local chara = CH('PLAYER')
  local partner = CH('Teammate1')
  GROUND:CharTurnToChar(chara, partner)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:ChoiceMenuYesNo("Sauvegarder la partie ?", true)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  UI:SetCenter(false)
  if res then
    GAME:SaveDungeonDay()
    UI:ResetSpeaker(false)
    UI:SetCenter(true)
    UI:WaitShowDialogue("La partie a été sauvegardée.")
    UI:SetCenter(false)
  end
end

function palier_celeste.Update(map, time) end
function palier_celeste.GameSave(map) end
function palier_celeste.GameLoad(map) end

return palier_celeste
