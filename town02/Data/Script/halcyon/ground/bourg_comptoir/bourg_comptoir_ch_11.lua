--[[
    bourg_comptoir_ch_11.lua
    Bourg du Comptoir — chapitre 11 : premiere arrivee.

    Suite directe de altere_pond_ch_11.ArrivalCutscene : Loaklass a
    porte le duo jusqu'a l'autre continent. La scene s'ouvre sur la
    grande allee ouest du Bourg, cote mer.

    Toutes les coordonnees ont ete relevees sur la grille de collision
    du .rsground (144x63 cellules de 8 px) et verifiees franchissables.
    L'allee y = 200 est libre de x = 16 a x >= 200.

    Regles : le heros ne parle jamais a voix haute ; aucune boite de
    narration a l'interieur de la scene jouee ; chaque personnage se
    reoriente selon sa propre position.
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

bourg_comptoir_ch_11 = {}

--------------------------------------------------------------------
-- Positions de la scene (toutes verifiees libres)
--------------------------------------------------------------------
local LOAKLASS_X, LOAKLASS_Y = 32,  216   -- au ras de l'eau, ouest
local HERO_X,     HERO_Y     = 56,  200
local PARTNER_X,  PARTNER_Y  = 56,  216
local HERO_FIN_X, HERO_FIN_Y = 160, 200
local PART_FIN_X, PART_FIN_Y = 160, 216

function bourg_comptoir_ch_11.ArrivalCutscene()
  local ok = pcall(function()
    GAME:FadeOut(false, 1)

    local hero    = CH('PLAYER')
    local partner = CH('Teammate1')

    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end
    SOUND:StopBGM()

    -- Loaklass reste dans l'eau, tournee vers la rive.
    local lapras = CharacterEssentials.MakeCharactersFromList({
      {'Lapras', LOAKLASS_X, LOAKLASS_Y, Direction.Right}
    })
    if lapras ~= nil then GROUND:CharSetAnim(lapras, "Idle", true) end

    GROUND:TeleportTo(hero, HERO_X, HERO_Y, Direction.Right)
    if partner ~= nil then
      GROUND:TeleportTo(partner, PARTNER_X, PARTNER_Y, Direction.Right)
    end
    GAME:MoveCamera(96, 208, 1, false)

    -- Ouverture : la lumiere revient sur le Bourg.
    GAME:FadeIn(60)
    SOUND:PlayBGM('Treasure Town.ogg', true)
    GAME:WaitFrames(50)

    -- Le partenaire decouvre la ville. Le heros regarde ailleurs :
    -- chacun s'oriente depuis sa propre place.
    if partner ~= nil then
      GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
      pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
    end
    GAME:WaitFrames(20)

    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Joyous")
    UI:WaitShowDialogue("Regarde la taille de ce port ![pause=15] On dirait que la ville n'en finit pas.")
    GAME:WaitFrames(15)

    GeneralFunctions.HeroDialogue(hero,
      "(Tant de monde...[pause=15] et personne ne nous connait ici.)", "Surprised")
    GAME:WaitFrames(20)

    -- Loaklass se tourne vers eux avant de prendre conge.
    if lapras ~= nil and partner ~= nil then
      GROUND:CharTurnToCharAnimated(lapras, partner, 4)
    end
    GAME:WaitFrames(10)

    UI:SetSpeaker(lapras)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Voici le Bourg du Comptoir.[pause=15] Il a connu des jours plus bruyants.")
    UI:WaitShowDialogue("Je reste amarree pres du recif.[pause=15] Faites-moi signe quand vous voudrez rentrer.")
    GAME:WaitFrames(15)

    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Happy")
    UI:WaitShowDialogue("Merci, Loaklass ![pause=10] On ne s'eloignera pas trop.")
    GAME:WaitFrames(20)

    -- Le duo remonte l'allee. Le partenaire ouvre la marche, le heros
    -- suit avec un temps de retard ; la camera accompagne sans devancer.
    local c1 = TASK:BranchCoroutine(function()
      if partner ~= nil then
        GROUND:MoveToPosition(partner, PART_FIN_X, PART_FIN_Y, false, 1)
        GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
      end
    end)
    local c2 = TASK:BranchCoroutine(function()
      GAME:WaitFrames(12)
      GROUND:MoveToPosition(hero, HERO_FIN_X, HERO_FIN_Y, false, 1)
      GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
    end)
    local c3 = TASK:BranchCoroutine(function()
      GAME:MoveCamera(180, 208, 90, false)
    end)
    TASK:JoinCoroutines({c1, c2, c3})
    GAME:WaitFrames(20)

    GeneralFunctions.HeroDialogue(hero,
      "(Un nouveau continent.[pause=15] Autant repartir de zero.)", "Determined")
    GAME:WaitFrames(20)

    SV.Chapter11.FinishedTreasureTownIntro = true
    SV.Chapter11.TreasureTownArrivalVersion = 1
  end)

  -- Sortie garantie, quoi qu'il arrive au-dessus.
  pcall(function()
    local partner = CH('Teammate1')
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', CH('PLAYER'), partner.Position)
    end
    GAME:CutsceneMode(false)
    GAME:FadeIn(20)
  end)

  if not ok then
    PrintInfo("[bourg_comptoir_ch_11] ArrivalCutscene interrompue — main rendue au joueur")
  end
end

--------------------------------------------------------------------
-- Entrees suivantes : pas de scene, on replace simplement le decor.
--------------------------------------------------------------------
function bourg_comptoir_ch_11.SetupGround()
  pcall(function()
    local lapras = CH('Lapras')
    if lapras == nil then
      lapras = CharacterEssentials.MakeCharactersFromList({
        {'Lapras', LOAKLASS_X, LOAKLASS_Y, Direction.Right}
      })
    end
    if lapras ~= nil then GROUND:CharSetAnim(lapras, "Idle", true) end
  end)
  GAME:FadeIn(20)
end

return bourg_comptoir_ch_11
