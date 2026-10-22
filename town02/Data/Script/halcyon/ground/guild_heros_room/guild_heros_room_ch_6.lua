--[[
    guild_heros_room_ch_6.lua
    Chapitre 6 : Scènes du dortoir (Réveil, Débats sur la Forêt Lugubre, Veillée).
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.ground.guild_heros_room.guild_heros_room_helper'

guild_heros_room_ch_6 = {}

function guild_heros_room_ch_6.ShowTitleCard()
  GAME:FadeOut(false, 1)
  GAME:CutsceneMode(true)
  AI:DisableCharacterAI(CH('Teammate1'))
  UI:ResetSpeaker()
  SOUND:StopBGM()
  GAME:WaitFrames(60)
  local coro1 = TASK:BranchCoroutine(function()
    UI:WaitShowTitle("Chapitre 6\n\nLa Forêt Lugubre\n", 20)
    GAME:WaitFrames(180)
    UI:WaitHideTitle(20)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(30)
    SOUND:PlaySE("Menu/Skip")
    GAME:WaitFrames(150)
  end)
  TASK:JoinCoroutines({coro1, coro2})
  GAME:CutsceneMode(false)
  GAME:FadeIn(30)
end

function guild_heros_room_ch_6.MorningBedtalk()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  if hero == nil or partner == nil then return end

  GAME:CutsceneMode(true)
  UI:SetSpeaker(partner)
  UI:WaitShowDialogue("Debout, [player] ! Le soleil éclaire déjà la fenêtre du dortoir !")
  UI:WaitShowDialogue("J'ai fait un rêve étrange cette nuit... Je voyais de grands arbres noirs qui murmuraient.")
  UI:WaitShowDialogue("La Forêt Lugubre se réveille, je le sens. Toute la guilde en parle depuis hier soir.")
  UI:WaitShowDialogue("Et l'arrivée de cette fameuse Team Dazzling n'a fait que rajouter de la nervosité.")
  UI:WaitShowDialogue("Ils se croient supérieurs à tout le monde avec leurs badges étincelants et leur grand air.")
  UI:WaitShowDialogue("Mais nous avons prouvé notre valeur au Tunnel Incandescent et sur le Mont Venteux !")
  UI:WaitShowDialogue("Allemons au rassemblement matinal, Noarfang et le Maître Grodoudou nous attendent !")
  GAME:CutsceneMode(false)
end

function guild_heros_room_ch_6.EveningBedtalk()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  if hero == nil or partner == nil then return end

  GAME:CutsceneMode(true)
  UI:SetSpeaker(partner)
  UI:WaitShowDialogue("Quelle journée intense... Mes pattes sont pleines de boue et de sève.")
  UI:WaitShowDialogue("Zeraora ne se battait pas par méchanceté, [player]. Il défendait sa forêt contre l'ombre.")
  UI:WaitShowDialogue("Quand il a parlé de la racine qui noircit sous terre, j'ai eu un frisson.")
  UI:WaitShowDialogue("Les Cœurs Anima résonnent entre eux. Ce que nous avons vu au Creuset n'était qu'un début.")
  UI:WaitShowDialogue("Reposons-nous maintenant. Demain, de nouveaux mystères nous attendent.")
  GAME:CutsceneMode(false)
end

return guild_heros_room_ch_6
