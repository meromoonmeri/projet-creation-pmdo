--[[ Kyogre, le Creux des Marées — cinématique d'Ancrage (Livre II, ch12).
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

local abime_tempetes = {}

function abime_tempetes.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function abime_tempetes.Enter(map)
  DEBUG.EnableDbgCoro()
  -- === RESEAU DES ANCIENS CHEMINS (new_era_zone_19) ===
  -- Ce ground sert AUSSI de cinematique d'Ancrage (chemin d'origine, plus bas,
  -- inchange). Quand on y arrive depuis la zone Reseau, c'est le Veilleur
  -- qu'on rencontre, pas le gardien d'Ancrage.
  if tostring(_ZONE.CurrentZoneID) == 'new_era_zone_19' then
    local hero = CH('PLAYER')
    local partner = CH('Teammate1')
    GAME:CutsceneMode(true)
    GROUND:TeleportTo(hero, 272, 240, Direction.Up)
    if partner ~= nil then GROUND:TeleportTo(partner, 248, 240, Direction.Up) end
    local lame = CharacterEssentials.MakeCharactersFromList({{'LameDeFond', 272, 200, Direction.Down}})
    GROUND:Hide('LameDeFond')
    GAME:MoveCamera(272, 220, 1, false)
    GAME:FadeIn(40)
    GAME:WaitFrames(30)

    if SV.Reseau ~= nil and SV.Reseau.Veilleurs ~= nil and SV.Reseau.Veilleurs['new_era_zone_19'] then
      GROUND:Unhide('LameDeFond')
      UI:SetSpeaker(lame)
      UI:WaitShowDialogue("Reviens dans la houle.[pause=20] Elle se souvient de toi.")
      COMMON.BossTransition()
      GAME:CutsceneMode(false)
      GAME:ContinueDungeon("new_era_zone_19", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
      return
    end

    UI:ResetSpeaker(false)
    UI:SetCenter(true)
    UI:WaitShowDialogue("LA MER NE S'EST JAMAIS CALMEE ICI.[pause=20] QUELQUE CHOSE LA REMUE.")
    UI:SetCenter(false)
    GAME:WaitFrames(30)

    BossFX.EmergeWater(lame, 272, 200)
    GAME:WaitFrames(20)
    BossFX.PushBack({hero, partner}, Direction.Down)
    GAME:WaitFrames(10)
      GROUND:Unhide('LameDeFond')
    GAME:WaitFrames(18)

    BossMusic.Play('abime_tempetes')
    UI:WaitShowTitle("Lame-de-Fond, Veilleur de la Mer sans Fin", 20)
    GAME:WaitFrames(50)
    UI:WaitHideTitle(20)

    UI:SetSpeaker(lame)
    UI:WaitShowDialogue("On ne traverse pas ma mer sans la saluer.")
    UI:SetSpeaker(lame)
    UI:WaitShowDialogue("Les bâtisseurs m'ont laissé la houle à garder.[pause=20] Tiens debout dedans.")

    if partner ~= nil then
      UI:SetSpeaker(partner)
      GeneralFunctions.SetEmotion("Worried")
      UI:WaitShowDialogue("Les vagues se dressent comme un mur...[pause=20] Il commande à toute la mer !")
    end
    GeneralFunctions.HeroDialogue(hero, "Alors on apprendra à nager droit.", "Determined")

    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("new_era_zone_19", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 272, 240, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 248, 240, Direction.Up) end
  local kyogre = CharacterEssentials.MakeCharactersFromList({{'Kyogre', 272, 200, Direction.Down}})
  GROUND:Hide('Kyogre')
  GAME:MoveCamera(272, 192, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('tide_hollow') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Kyogre')
    UI:SetSpeaker(kyogre)
    UI:WaitShowDialogue("Chaque marée est une question.[pause=20] Réponds, ou coule.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("stormy_sea", 32, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("LA PLUIE TOMBE DEPUIS AVANT LES NOMS.[pause=20] QUI OSE NAGER JUSQU'À SA SOURCE ?")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.EmergeWater(kyogre, 272, 200)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Kyogre')
  GROUND:CharSetAnim(kyogre, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(kyogre, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('abime_tempetes')
  UI:WaitShowTitle("Kyogre, le Creux des Marées", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("Les vagues tournent en cercle...[pause=20] On est au centre exact de la tempête !", hero:GetDisplayName()))
  UI:SetSpeaker(kyogre)
  UI:WaitShowDialogue("Chaque marée est une question.[pause=20] Réponds, ou coule.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("stormy_sea", 32, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function abime_tempetes.Update(map, time) end
function abime_tempetes.GameSave(map) end
function abime_tempetes.GameLoad(map) end

return abime_tempetes
