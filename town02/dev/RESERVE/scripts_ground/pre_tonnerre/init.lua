--[[ Zeraora, le Courant Sauvage — cinématique d'Ancrage (Livre II, ch25).
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

local pre_tonnerre = {}

-- ORAGE DE FOND — les nuees qui bordent l'arene s'illuminent.
-- MapStatus 'thunderclouds' (voile bleu-blanc, Layer 4, FadeIn 2 /
-- FadeOut 8). L'eclair n'est pas une animation en boucle : on AJOUTE
-- puis on RETIRE le statut, et ce sont ses fondus qui font le flash.
-- Deux coups rapproches puis un silence : c'est le rythme d'un vrai
-- orage, pas un clignotant regulier.
local function Eclair(court)
  pcall(function() GROUND:AddMapStatus("thunderclouds") end)
  GAME:WaitFrames(court and 4 or 7)
  pcall(function() GROUND:RemoveMapStatus("thunderclouds") end)
end

function pre_tonnerre.CoupDeTonnerre(avecSon)
  local ok = pcall(function()
    Eclair(true)
    GAME:WaitFrames(5)
    Eclair(false)
    if avecSon then SOUND:PlayBattleSE("DUN_Shock_Wave") end
  end)
  if not ok then PrintInfo("[pre_tonnerre] eclair ignore") end
end

function pre_tonnerre.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function pre_tonnerre.Enter(map)
  DEBUG.EnableDbgCoro()
  -- SORTIE GARANTIE : sans ce pcall, une scene qui leve avant son FadeIn
  -- laisse le joueur sur un ecran noir, manette inerte.
  local ok, err = pcall(pre_tonnerre.ArrivalBody)
  if not ok then
    PrintInfo('[pre_tonnerre] scene interrompue : ' .. tostring(err))
    pcall(function() GAME:CutsceneMode(false) end)
    pcall(function() GAME:FadeIn(20) end)
  end
end

function pre_tonnerre.ArrivalBody()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  -- ================================================================
  -- POSITIONS — CORRECTIF 2026-08-04
  -- ================================================================
  -- L'arene a ete repeinte avec « Arene Zeraora.png » : elle est passee
  -- de 456x336 a 360x312 px. Les coordonnees du script sont restees sur
  -- l'ANCIENNE carte. Mesure faite sur le .rsground courant :
  --     hero    (224,328) -> y=328 > 312 : HORS CARTE
  --     partner (200,328) -> HORS CARTE
  -- Les deux etaient teleportes en dehors du monde. C'est la raison pour
  -- laquelle cette arene n'a jamais ete vue en jeu malgre deux envois du
  -- decor : le decor etait bon, les acteurs n'y etaient pas.
  --
  -- Nouvelles positions verifiees libres case par case (les 4 cases de
  -- 8 px de chaque boite 16x16) contre obstacles[] :
  --     plateau praticable  x 0..344   y 120..296
  --     duo au depart       (184,272) et (160,272)  bas du plateau
  --     point de halte      (176,240)               mi-pente
  --     Zeraora             (176,176)               haut, sous la roche
  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  GROUND:TeleportTo(hero, 184, 272, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 160, 272, Direction.Up) end
  local zeraora = CharacterEssentials.MakeCharactersFromList({{'Zeraora', 176, 176, Direction.Down}})
  GROUND:Hide('Zeraora')
  GAME:MoveCamera(176, 250, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('wild_current') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Zeraora')
    pre_tonnerre.CoupDeTonnerre(true)
    UI:SetSpeaker(zeraora)
    UI:WaitShowDialogue("Enfin des concurrents ![pause=20] Règle unique :[pause=10] le premier à terre a perdu !")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("piste_fulgurante", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- ================================================================
  -- 0. LA MONTEE ET LA HALTE — demande explicite de l'auteur :
  --    « le partenaire et le heros passe au nord, s'arretent, une voix
  --      d'une source inconnue les arrete »
  -- ================================================================
  -- Le duo remonte le plateau vers le nord. Ils marchent VRAIMENT (pas
  -- de teleportation) et la camera glisse avec eux : le joueur doit
  -- sentir la montee avant l'interruption.
  local montee = {}
  montee[1] = TASK:BranchCoroutine(function()
    pcall(function() GROUND:MoveToPosition(hero, 184, 240, false, 1) end)
  end)
  montee[2] = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    if partner ~= nil then
      pcall(function() GROUND:MoveToPosition(partner, 160, 244, false, 1) end)
    end
  end)
  montee[3] = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    pcall(function() GAME:MoveCamera(176, 228, 90, false) end)
  end)
  pcall(function() TASK:JoinCoroutines(montee) end)
  GAME:WaitFrames(10)

  -- LA VOIX ARRETE LA MARCHE. Elle vient d'on ne sait ou : locuteur
  -- vide, texte centre. Ce n'est PAS la Voix du heros (\uE040), qui
  -- reste reservee et anonyme — c'est Zeraora, hors champ, qui parle.
  -- On ne le sait pas encore : il n'a ni portrait ni nom a cet instant.
  SOUND:PlayBattleSE("EVT_Emote_Exclaim")
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("Hé.[pause=20] Halte-là,[pause=10] vous deux.")
  UI:SetCenter(false)
  GAME:WaitFrames(8)

  -- Ils se figent net. Emotes DIFFERENTES : le partenaire sursaute,
  -- le heros cherche d'ou vient le son.
  local sursaut = {}
  sursaut[1] = TASK:BranchCoroutine(function()
    pcall(function() GeneralFunctions.EmoteAndPause(hero, "Shock", true) end)
  end)
  sursaut[2] = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    if partner ~= nil then
      pcall(function() GeneralFunctions.EmoteAndPause(partner, "Exclaim", true) end)
    end
  end)
  pcall(function() TASK:JoinCoroutines(sursaut) end)
  GAME:WaitFrames(12)

  -- Ils cherchent la source. Le regard balaie : personne.
  pcall(function()
    GROUND:CharAnimateTurnTo(hero, Direction.Left, 5)
    if partner ~= nil then GROUND:CharAnimateTurnTo(partner, Direction.Right, 5) end
  end)
  GAME:WaitFrames(20)
  pcall(function()
    GROUND:CharAnimateTurnTo(hero, Direction.Up, 5)
    if partner ~= nil then GROUND:CharAnimateTurnTo(partner, Direction.Up, 5) end
  end)
  GAME:WaitFrames(10)

  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue("Qui a dit ça ?[pause=20] Il n'y a personne...")
    GAME:WaitFrames(8)
  end
  -- Le heros ne parle jamais a voix haute : pensee entre parentheses.
  GeneralFunctions.HeroDialogue(hero, "(Ça venait d'en haut.[pause=15] Du sommet.)", "Normal")
  GAME:WaitFrames(10)

  -- Le silence, puis la camera monte SEULE vers le sommet : le joueur
  -- voit avant les personnages.
  pcall(function() GAME:MoveCamera(176, 190, 70, false) end)
  GAME:WaitFrames(20)

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("IL A DISTANCÉ L'ORAGE QUI L'A CRÉÉ.[pause=20] DEPUIS, IL CHERCHE UNE COURSE DIGNE.")
  UI:SetCenter(false)
  -- L'orage repond a la phrase : un eclair lointain, sans tonnerre —
  -- le son viendra avec l'irruption. Le decalage se voit.
  pre_tonnerre.CoupDeTonnerre(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption — ELECTRIQUE : vitesse pure, la decharge precede le corps.
  --    Avant ce lot : un BossFX.Flash generique, identique a 10 autres
  --    arenes. Toutes les particules employees sont attestees.
  BossFX.StrikeThunder(zeraora, 176, 176)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Zeraora')
  -- Le ciel repond a l'apparition : cette fois avec le tonnerre.
  pre_tonnerre.CoupDeTonnerre(true)
  GROUND:CharSetAnim(zeraora, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(zeraora, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('pre_tonnerre')
  UI:WaitShowTitle("Zeraora, le Courant Sauvage", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format("Cette trace d'herbe brûlée...[pause=10] UN SEUL trait, du pied de la piste jusqu'ici ![pause=20] Il nous a devancés en s'AMUSANT.", hero:GetDisplayName()))
  UI:SetSpeaker(zeraora)
  UI:WaitShowDialogue("Enfin des concurrents ![pause=20] Règle unique :[pause=10] le premier à terre a perdu !")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("piste_fulgurante", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function pre_tonnerre.Update(map, time) end
function pre_tonnerre.GameSave(map) end
function pre_tonnerre.GameLoad(map) end

return pre_tonnerre
