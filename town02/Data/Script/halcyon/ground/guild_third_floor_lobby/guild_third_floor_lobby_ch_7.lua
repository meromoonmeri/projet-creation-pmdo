--[[
    guild_third_floor_lobby_ch_7.lua
    Chapter 7 — Aegis Cave morning address + Phileas dialogue
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

guild_third_floor_lobby_ch_7 = {}

-- Adresse du matin : Penticus annonce les perturbations
function guild_third_floor_lobby_ch_7.RuinsExpeditionAddress()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local tropius, noctowl, audino, snubbull, growlithe, zigzagoon, girafarig,
        breloom, mareep, cranidos = guild_third_floor_lobby_helper.SetupMorningAddress()

  -- Penticus annonce, puis passe a Phileas
  UI:SetSpeaker(tropius)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3F7_001']))
  -- "Mes amis, merci de vous etre rassembles. J'ai des nouvelles... preoccupantes."
  
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3F7_002']))
  -- "Les rapports affluent de toute la region. Quelque chose ne va pas."
  
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3F7_003']))
  -- "Les Pokemon sauvages sont plus agressifs. Les donjons semblent... s'etendre."
  
  GAME:WaitFrames(20)
  GROUND:CharTurnToChar(tropius, noctowl)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3F7_004']))
  -- "Et au coeur de tout ca, les anciennes Aegis Cave. Phileas ?"

  GAME:WaitFrames(20)
  UI:SetSpeaker(noctowl)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3F7_005']))
  -- "Merci, Penticus. Les ruines abritent un Coeur des Anima."

  GAME:WaitFrames(10)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3F7_006']))
  -- "Et d'apres mes lectures, ce Coeur... faiblit."

  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3F7_007']))
  -- "Si un Coeur s'eteint, la region qu'il soutient... meurt avec lui."

  GAME:WaitFrames(20)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3F7_008']))
  -- "Nous DEVONS enqueter. C'est notre responsabilite."

  GAME:WaitFrames(30)

  -- Penticus s'adresse au heros
  UI:SetSpeaker(tropius)
  GeneralFunctions.SetEmotion("Normal")
  GROUND:CharTurnToChar(tropius, hero)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3F7_009']))
  -- "Je sais que vous revenez a peine de l'expedition..."
  
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3F7_010']))
  -- "Mais vous etes la seule equipe en qui j'ai assez confiance pour cette mission."

  GAME:WaitFrames(20)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3F7_011']))
  -- "Allez voir Phileas au troisieme etage. Il vous expliquera tout."

  -- Standard guild dismissal
  GAME:WaitFrames(40)
  local coro1 = TASK:BranchCoroutine(function() guild_third_floor_lobby_helper.ApprenticeLeave(growlithe) end)
  local coro2 = TASK:BranchCoroutine(function() guild_third_floor_lobby_helper.ApprenticeLeaveBottom(zigzagoon) end)
  local coro3 = TASK:BranchCoroutine(function() guild_third_floor_lobby_helper.ApprenticeLeave(mareep) end)
  local coro4 = TASK:BranchCoroutine(function() guild_third_floor_lobby_helper.ApprenticeLeaveBottom(cranidos) end)
  local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) guild_third_floor_lobby_helper.ApprenticeLeaveFast(snubbull) end)
  local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) guild_third_floor_lobby_helper.ApprenticeLeaveBottomFast(audino) end)
  local coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) guild_third_floor_lobby_helper.ApprenticeLeaveFast(breloom) end)
  local coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) guild_third_floor_lobby_helper.ApprenticeLeaveBottomFast(girafarig) end)
  local coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(16) GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)
  local coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(26) GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)
  local coro12 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
      GROUND:CharAnimateTurnTo(tropius, Direction.Up, 4)
      GROUND:MoveInDirection(tropius, Direction.Up, 24, false, 1)
      GAME:GetCurrentGround():RemoveTempChar(tropius) end)
  TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10, coro12})

  SV.Chapter7.RuinsAddressGiven = true
  SV.TemporaryFlags.MorningAddress = false
  GeneralFunctions.PanCamera()
  GAME:CutsceneMode(false)
  AI:EnableCharacterAI(partner)
  AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
end

-- Phileas explique la mission au heros
function guild_third_floor_lobby_ch_7.Noctowl_Action(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  if SV.Chapter7.RuinsAddressGiven and not SV.Chapter7.EnteredRuins then
    GeneralFunctions.StartConversation(chara, 
      STRINGS:Format(STRINGS.MapStrings['MT7_Noctowl_006']))
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Les Aegis Cave se trouvent au nord de Metano.[pause=20] Ce sont les vestiges d'une civilisation ancienne.")
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue("C'est la que se trouve le Coeur des Anima de notre region.[pause=25] Et il est en train de mourir.")
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue("Allez-y.[pause=30] Et rapportez-moi ce que vous trouverez.")
    SV.Chapter7.MissionAccepted = true
    GeneralFunctions.EndConversation(chara)
  elseif SV.Chapter7.DefeatedRuinsBoss and not SV.Chapter7.HeardGenesisTale then
    GeneralFunctions.StartConversation(chara,
      "Vous avez vu le Coeur, n'est-ce pas ?[pause=25] Ce qu'il est devenu.[pause=30] Alors il est temps que je vous raconte... d'ou vient la vie.")
    GeneralFunctions.EndConversation(chara)
    GAME:EnterGroundMap('genesis_vision', 'Main_Entrance_Marker')
  elseif SV.Chapter7.HeardGenesisTale then
    GeneralFunctions.StartConversation(chara,
      "La Genese...[pause=20] Je n'aurais jamais cru la raconter un jour.[pause=30] Et pourtant.")
    GeneralFunctions.SetEmotion("Sad")
    UI:WaitShowDialogue("Ce qui est arrive a ce Coeur...[pause=25] ne doit plus jamais arriver.")
    GeneralFunctions.EndConversation(chara)
  else
    GeneralFunctions.StartConversation(chara,
      "Les textes anciens parlent de perturbations dans la region.[pause=20] Restez vigilants.")
    GeneralFunctions.EndConversation(chara)
  end
end

return guild_third_floor_lobby_ch_7
