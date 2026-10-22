--[[ Voile-Blanc et Masque-Gel, Veilleurs du Zéro — cinematique de Veilleur (Reseau des Anciens Chemins).
     Ground pmd-red importe 1:1 ; geometrie intouchee, dialogues New Era.
     Grammaire : signal -> irruption -> recul -> reveal -> titre -> echange
     -> BossTransition -> arene. Rematch : intro raccourcie.
     
     INTÉGRATION DE L'ARC FUGITIF (CHAPITRE 12) :
     Si le joueur traverse cette zone en tant que fugitif, le script joue la cinématique
     d'exil glaciale et épique au milieu du blizzard, mettant en scène le héros et son partenaire.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.BossMusic'

local mont_gele_pied = {}

function mont_gele_pied.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_mont_gele_pied")
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function mont_gele_pied.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)

  -- LIAISON DE L'ARC FUGITIF (CHAPITRE 12 - EXIL)
  if SV.ChapterProgression ~= nil and (SV.ChapterProgression.Chapter == 11 or SV.ChapterProgression.Chapter == 12) then
    mont_gele_pied.PlayFugitiveScene(hero, partner)
    return
  end

  -- Duo cote a cote (32 px d'ecart), ~72 px sous le Veilleur.
  GROUND:TeleportTo(hero, 144, 224, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 112, 224, Direction.Up) end
  local voile = CharacterEssentials.MakeCharactersFromList({{'VoileBlanc', 104, 152, Direction.Down}})
  GROUND:Hide('VoileBlanc')
  local masque = CharacterEssentials.MakeCharactersFromList({{'MasqueGel', 152, 152, Direction.Down}})
  GROUND:Hide('MasqueGel')
  -- Camera entre le duo et le Veilleur.
  GAME:MoveCamera(128, 188, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if SV.Reseau ~= nil and SV.Reseau.Veilleurs ~= nil and SV.Reseau.Veilleurs['new_era_zone_13'] then
    -- REMATCH : le Veilleur connait deja l'equipe, pas de ceremonie.
    GROUND:Unhide('VoileBlanc')
    GROUND:Unhide('MasqueGel')
    UI:SetSpeaker(voile)
    UI:WaitShowDialogue("Encore eux...[pause=15] et encore nous.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("new_era_zone_13", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voie parle avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("DEUX SOUFFLES DANS L'AIGUILLE.[pause=20] ILS N'EN FONT QU'UN.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre a ce Veilleur).
  BossFX.EmergeMist(voile, 104, 152)
  GAME:WaitFrames(12)
  BossFX.EmergeShadow(masque, 152, 152)
  GAME:WaitFrames(20)

  -- 3. Le recul du duo.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4. Reveal.
  GROUND:Unhide('VoileBlanc')
  GROUND:Unhide('MasqueGel')
  GAME:WaitFrames(18)

  -- 5. Titre + theme.
  BossMusic.Play('mont_gele_pied')
  UI:WaitShowTitle("Voile-Blanc et Masque-Gel, Veilleurs du Zéro", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 6. L'echange : le Veilleur tient la porte, il teste, il ne hait pas.
  UI:SetSpeaker(voile)
  UI:WaitShowDialogue("Deux gardent mieux qu'un...")
  UI:SetSpeaker(masque)
  UI:WaitShowDialogue("...et personne ne passe entre nous deux.")

  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Surprised")
    UI:WaitShowDialogue("Ils finissent les phrases l'un de l'autre...[pause=20] C'est glaçant.")
  end
  GeneralFunctions.HeroDialogue(hero, "Alors on répondra aux deux à la fois.", "Determined")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("new_era_zone_13", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

-- ============================================================
-- CINÉMATIQUE DE LA ROUTE DE NEIGE (ARC FUGITIF)
-- ============================================================
function mont_gele_pied.PlayFugitiveScene(hero, partner)
  -- Positionnement sous le blizzard permanent
  GROUND:TeleportTo(hero, 144, 200, Direction.Up)
  GROUND:TeleportTo(partner, 112, 200, Direction.Up)
  GAME:MoveCamera(128, 180, 1, false)
  pcall(function() GROUND:AddMapStatus("winter_snow") end)
  
  GAME:FadeIn(60)
  GAME:WaitFrames(30)
  
  -- Le partenaire grelotte de froid
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Pain")
  UI:WaitShowDialogue("Gg...[pause=10] Gl...[pause=15] Gg... Gla-Glacial...[pause=20] Mes doigts de pieds sont complètement gelés...")
  UI:WaitShowDialogue("Le vent souffle si fort ici...[pause=25] On est arrivés au bout du monde, n'est-ce pas ?")
  
  -- Sursaut de vent froid (VFX ou Screen shake doux)
  SOUND:PlayBattleSE("DUN_Wind")
  GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30))
  pcall(function() GROUND:CharSetEmote(partner, "sweat", 1) end)
  GAME:WaitFrames(25)
  
  -- Le héros se rapproche pour le réchauffer
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(15)
  
  GeneralFunctions.HeroDialogue(hero, "Tiens bon. Feunard est au sommet de ce mont gelé. Il détient la clé de la vérité, j'en suis sûr.", "Determined")
  
  -- Le partenaire reprend espoir
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue("Oui ![pause=20] Ninetales saura leur dire que tu n'as rien à voir avec cette malédiction antique.")
  UI:WaitShowDialogue("Nous sommes allés si loin...[pause=15] Ce n'est pas un peu de neige qui nous arrêtera !")
  UI:WaitShowDialogue("En route vers le Mont Gel, ensemble !")
  
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  
  -- Lancer le donjon du Mont Gel
  GAME:CutsceneMode(false)
  GAME:EnterDungeon("mount_freeze", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
end

function mont_gele_pied.Update(map, time) end
function mont_gele_pied.GameSave(map) end
function mont_gele_pied.GameLoad(map) end

return mont_gele_pied
