--[[ Colline Sans Lumière — le dialogue intime entre le héros et le partenaire (Chapitre 7)
     Ground importé (format RogueEssence natif, vague 4).
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

local colline_sans_lumiere = {}

function colline_sans_lumiere.Init(map)
  pcall(function() GAME:FadeOut(false, 1) end)
  pcall(function() GAME:CutsceneMode(true) end)
  COMMON.RespawnAllies()
  pcall(function() PartnerEssentials.InitializePartnerSpawn() end)
  
  pcall(function()
    local sceneAVenir = false
    if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 7 then
      sceneAVenir = SV.Chapter7.GreatReunionPlayed and not SV.Chapter7.FinishedIntimateTalk
    end
    if not sceneAVenir then GAME:CutsceneMode(false) end
  end)
end

function colline_sans_lumiere.Enter(map)
  colline_sans_lumiere.PlotScripting()
end

function colline_sans_lumiere.Update(map, time)
end

function colline_sans_lumiere.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function colline_sans_lumiere.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  colline_sans_lumiere.PlotScripting()
end

function colline_sans_lumiere.PlotScripting()
  if SV.ChapterProgression.Chapter == 7 then
    if SV.Chapter7.GreatReunionPlayed and not SV.Chapter7.FinishedIntimateTalk then
      colline_sans_lumiere.IntimateTalk()
    else
      colline_sans_lumiere.SetupGround()
    end
  else
    GAME:FadeIn(20)
  end
end

function colline_sans_lumiere.SetupGround()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GROUND:TeleportTo(hero, 150, 160, Direction.Left)
  if partner ~= nil then GROUND:TeleportTo(partner, 120, 160, Direction.Right) end
  GAME:MoveCamera(135, 150, 1, false)
  GAME:FadeIn(20)
end

-- ============================================================
-- SCÈNE INTIME : Le secret partagé (Colline sans Lumière)
-- ============================================================
function colline_sans_lumiere.IntimateTalk()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  -- Coucher de soleil magnifique sur les hauteurs de la colline
  GROUND:AddMapStatus("dusk")
  GROUND:TeleportTo(hero, 150, 160, Direction.Left)
  if partner ~= nil then GROUND:TeleportTo(partner, 120, 160, Direction.Right) end
  GAME:MoveCamera(135, 150, 1, false)

  GAME:FadeIn(60)
  SOUND:PlayBGM('At the End of the Day.ogg', true)
  GAME:WaitFrames(40)

  -- Le partenaire regarde l'horizon, puis se tourne vers le héros
  GROUND:CharTurnToCharAnimated(partner, hero, 4)
  GAME:WaitFrames(15)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(string.format("%s...[pause=15] Ce qu'a dit Alakazam sur la place tout à l'heure...", hero:GetDisplayName()))
  UI:WaitShowDialogue("À propos de la légende de l'humain transformé en Pokémon...[pause=20] Je n'ai pas pu m'empêcher d'y penser.")
  GAME:WaitFrames(15)

  -- Le héros se tourne vers lui
  GROUND:CharTurnToCharAnimated(hero, partner, 4)
  GAME:WaitFrames(15)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  UI:WaitShowDialogue("Je sais que tu as perdu la mémoire...[pause=10] et si jamais... si jamais tu étais toi aussi un humain transformé en Pokémon...")
  UI:WaitShowDialogue("S'il te plaît, promets-moi de ne jamais, au grand jamais, révéler ta véritable identité à qui que ce soit à la Guilde.")
  GAME:WaitFrames(15)

  GeneralFunctions.HeroDialogue(hero, "(...La Guilde... et les autres... ?)", "Surprised")
  GAME:WaitFrames(15)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Sad")
  UI:WaitShowDialogue("J'ai peur...[pause=15] Si les autres l'apprenaient, ils pourraient te regarder différemment, t'isoler...")
  UI:WaitShowDialogue("Ou pire...[pause=15] rejeter toute la responsabilité de ces dérèglements sur toi, comme ils l'ont fait il y a trente ans pour ce héros légendaire.")
  GAME:WaitFrames(15)

  pcall(function() GROUND:CharSetEmote(partner, "determined", 1) end)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue("Pour moi, tu es mon meilleur ami, peu importe d'où tu viens.[pause=20] Je tiens trop à toi pour risquer de te perdre.")
  UI:WaitShowDialogue("Promets-moi... qu'on gardera ce secret ensemble.[pause=15] Quoi qu'il arrive, on affrontera la suite en équipe. D'accord ?")
  GAME:WaitFrames(25)

  -- Le héros acquiesce (Nod)
  GeneralFunctions.DoAnimation(hero, 'Nod')
  GAME:WaitFrames(15)

  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue("Merci, {0}.[pause=15] Savoir que je peux compter sur toi me donne toute la force dont j'ai besoin.", hero:GetDisplayName())
  UI:WaitShowDialogue("La nuit tombe...[pause=10] Rentrons dormir à la Guilde. Demain est une nouvelle journée d'entraînement.")
  GAME:WaitFrames(20)

  -- Fin de la cinématique
  SV.Chapter7.FinishedIntimateTalk = true
  
  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)

  pcall(function()
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', CH('PLAYER'), partner.Position)
    end
    GAME:CutsceneMode(false)
  end)

  -- Retour à la chambre
  GAME:EnterGroundMap("guild_heros_room", "Main_Entrance_Marker")
end

return colline_sans_lumiere
