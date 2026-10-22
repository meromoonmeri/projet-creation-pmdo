--[[ Fusible, Veilleur du Réacteur Rouge — cinematique de Veilleur (Reseau des Anciens Chemins).
     Ground pmd-red importe 1:1 ; geometrie intouchee, dialogues New Era.
     Grammaire : signal -> irruption -> recul -> reveal -> titre -> echange
     -> BossTransition -> arene. Rematch : intro raccourcie.
     
     INTÉGRATION DE L'ARC FUGITIF (CHAPITRE 12) :
     Si le joueur traverse cette zone en tant que fugitif, le script joue la cinématique
     d'exil nostalgique et émotionnelle au coin du feu, mettant en scène le héros et son partenaire.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.BossMusic'

local mont_cendre_pied = {}

function mont_cendre_pied.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_mont_cendre_pied")
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function mont_cendre_pied.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)

  -- LIAISON DE L'ARC FUGITIF (CHAPITRE 12 - EXIL)
  if SV.ChapterProgression ~= nil and (SV.ChapterProgression.Chapter == 11 or SV.ChapterProgression.Chapter == 12) then
    mont_cendre_pied.PlayFugitiveScene(hero, partner)
    return
  end

  -- Duo cote a cote (32 px d'ecart), ~72 px sous le Veilleur.
  GROUND:TeleportTo(hero, 192, 256, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 160, 256, Direction.Up) end
  local fusible = CharacterEssentials.MakeCharactersFromList({{'Fusible', 176, 184, Direction.Down}})
  GROUND:Hide('Fusible')
  -- Camera entre le duo et le Veilleur.
  GAME:MoveCamera(176, 220, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if SV.Reseau ~= nil and SV.Reseau.Veilleurs ~= nil and SV.Reseau.Veilleurs['new_era_zone_09'] then
    -- REMATCH : le Veilleur connait deja l'equipe, pas de ceremonie.
    GROUND:Unhide('Fusible')
    UI:SetSpeaker(fusible)
    UI:WaitShowDialogue("Encore toi ![pause=20] Approche, le feu est chaud.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("new_era_zone_09", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voie parle avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("LA CHEMINÉE TIRE ENCORE.[pause=20] QUI VIENT CHERCHER LA CHALEUR ?")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre a ce Veilleur).
  BossFX.EmergeFire(fusible, 176, 184)
  GAME:WaitFrames(20)

  -- 3. Le recul du duo.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4. Reveal.
  GROUND:Unhide('Fusible')
  GAME:WaitFrames(18)

  -- 5. Titre + theme.
  BossMusic.Play('mont_cendre_pied')
  UI:WaitShowTitle("Fusible, Veilleur du Réacteur Rouge", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 6. L'echange : le Veilleur tient la porte, il teste, il ne hait pas.
  UI:SetSpeaker(fusible)
  UI:WaitShowDialogue("Ha ![pause=15] De la visite, enfin.[pause=20] Ça faisait des siècles.")
  UI:SetSpeaker(fusible)
  UI:WaitShowDialogue("J'entretiens le feu pour ceux qui viendront.[pause=20] Montre-moi que c'est toi.")

  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue("Il rit ?[pause=20] Il garde une fournaise depuis des siècles et il RIT !")
  end
  GeneralFunctions.HeroDialogue(hero, "Il ne nous déteste pas. Il s'ennuie.", "Determined")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("new_era_zone_09", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

-- ============================================================
-- CINÉMATIQUE DE LA ROUTE DE CENDRE (ARC FUGITIF)
-- ============================================================
function mont_cendre_pied.PlayFugitiveScene(hero, partner)
  -- Positionnement près de la faille de lave chaude
  GROUND:TeleportTo(hero, 192, 230, Direction.Up)
  GROUND:TeleportTo(partner, 160, 230, Direction.Up)
  GAME:MoveCamera(176, 210, 1, false)
  
  GAME:FadeIn(60)
  GAME:WaitFrames(30)
  
  -- Le partenaire soupire de fatigue
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Sigh")
  UI:WaitShowDialogue("Ouf...[pause=20] Mes jambes n'en peuvent plus...[pause=15] Cette montée de lave est étouffante.")
  
  -- Son ventre gargouille (SE de faim comique ou pause)
  SOUND:PlaySE("DUN_Burp") -- Équivalent son ventre gargouille
  pcall(function() GROUND:CharSetEmote(partner, "sweat", 1) end)
  GAME:WaitFrames(25)
  
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue("Et j'ai l'estomac complètement vide...[pause=20] Crois-tu que toute la ville est à nos trousses ?")
  UI:WaitShowDialogue("Alakazam...[pause=15] la Fédération...[pause=15] Ectoplasma qui a monté tout le monde contre nous...")
  
  -- Le héros se tourne vers lui pour le réconforter
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(15)
  
  GeneralFunctions.HeroDialogue(hero, "On finira par prouver notre innocence. Notre lien est plus fort que leurs mensonges.", "Normal")
  
  -- Le partenaire est réconforté et sourit
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue("Tu as raison ![pause=20] On a déjà accompli tant de miracles ensemble.")
  UI:WaitShowDialogue("Tant qu'on est tous les deux, je n'ai pas peur.[pause=20] Reposons-nous un peu, puis nous gravirons ce volcan !")
  
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  
  -- Redonner le contrôle et lancer le donjon du Mont Brasier
  GAME:CutsceneMode(false)
  GAME:EnterDungeon("mount_blaze", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
end

function mont_cendre_pied.Update(map, time) end
function mont_cendre_pied.GameSave(map) end
function mont_cendre_pied.GameLoad(map) end

return mont_cendre_pied
