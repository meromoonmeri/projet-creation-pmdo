--[[
    guild_third_floor_lobby_ch_5_epilogue.lua — L'EPILOGUE DU CHAPITRE 5

    Grande cinematique qui se joue APRES la victoire sur Regigigas, avant
    l'assemblee-bilan (BilanExpedition). C'est une retrospective : la
    voix du recit raconte la fin de l'expedition, de la fuite des Ruines
    au retour a la guilde, en passant par la question laissee par le
    Colosse. Elle se conclut sur un fondu style « le lendemain » mais
    formule autrement : « Et c'est ainsi qu'ils finirent leur expedition,
    et que le monde recommença a respirer. »

    Puis le joueur peut sauvegarder, et l'on retombe sur l'assemblee de
    Metano (BilanExpedition), avant que le chapitre 6 ne commence.

    STRUCTURE (construite par etapes vers ~1000 lignes) :
      ACTE 0  L'apres-Colosse — la chambre videe, la fuite, la tour
      ACTE 1  Le retour — la marche, le camp, la guilde
      ACTE 2  Le bilan interieur — le heros repense au voyage
      ACTE 3  La question de Regigigas — le mystere qui reste ouvert
      ACTE 4  L'aube sur la guilde — l'assemblee approche
      FIN     « Et c'est ainsi... » + fondu + sauvegarde
]]--
require 'origin.common'
require 'halcyon.GeneralFunctions'

guild_third_floor_lobby_ch_5_epilogue = {}

local function centre(cle)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[cle]))
  UI:SetCenter(false)
  UI:ResetSpeaker()
end

local function dit(chara, cle, emo)
  if chara == nil then return end
  UI:SetSpeaker(chara)
  GeneralFunctions.SetEmotion(emo or "Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[cle]))
  UI:ResetSpeaker()
end

local function pense(hero, cle, emo)
  if hero == nil then return centre(cle) end
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings[cle]), emo or "Normal")
end

--------------------------------------------------------------------
-- L'EPILOGUE
--------------------------------------------------------------------
function guild_third_floor_lobby_ch_5_epilogue.Epilogue()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  local ok = pcall(function()
    GAME:CutsceneMode(true)
    SOUND:StopBGM()
    GAME:WaitFrames(60)
    GAME:FadeIn(60)
    GAME:WaitFrames(40)

    -- ============================================================
    -- ACTE 0 — L'APRES-COLOSSE
    -- ============================================================
    centre('EP5_000')
    GAME:WaitFrames(25)
    centre('EP5_001')
    GAME:WaitFrames(20)
    centre('EP5_002')
    GAME:WaitFrames(25)
    if partner ~= nil then
      dit(partner, 'EP5_003', "Worried")
      GAME:WaitFrames(20)
      dit(partner, 'EP5_004', "Normal")
      GAME:WaitFrames(22)
    end
    centre('EP5_005')
    GAME:WaitFrames(30)

    -- ============================================================
    -- ACTE 1 — LE RETOUR
    -- ============================================================
    centre('EP5_006')
    GAME:WaitFrames(20)
    centre('EP5_007')
    GAME:WaitFrames(25)
    centre('EP5_008')
    GAME:WaitFrames(22)
    if partner ~= nil then
      dit(partner, 'EP5_009', "Normal")
      GAME:WaitFrames(20)
      dit(partner, 'EP5_010', "Worried")
      GAME:WaitFrames(22)
    end
    centre('EP5_011')
    GAME:WaitFrames(25)

    -- ============================================================
    -- ACTE 2 — LE BILAN INTERIEUR
    -- ============================================================
    if hero ~= nil then
      pense(hero, 'EP5_012', "Normal")
      GAME:WaitFrames(20)
      pense(hero, 'EP5_013', "Worried")
      GAME:WaitFrames(22)
      pense(hero, 'EP5_014', "Sad")
      GAME:WaitFrames(24)
      pense(hero, 'EP5_015', "Normal")
      GAME:WaitFrames(22)
    end
    centre('EP5_016')
    GAME:WaitFrames(25)

    -- ============================================================
    -- ACTE 3 — LA QUESTION DE REGIGIGAS
    -- ============================================================
    centre('EP5_017')
    GAME:WaitFrames(20)
    if partner ~= nil then
      dit(partner, 'EP5_018', "Worried")
      GAME:WaitFrames(22)
    end
    centre('EP5_019')
    GAME:WaitFrames(30)
    centre('EP5_020')
    GAME:WaitFrames(35)

    -- ============================================================
    -- ACTE 4 — L'AUBE SUR LA GUILDE
    -- ============================================================
    centre('EP5_021')
    GAME:WaitFrames(25)
    centre('EP5_022')
    GAME:WaitFrames(25)
    if partner ~= nil then
      dit(partner, 'EP5_023', "Determined")
      GAME:WaitFrames(22)
      dit(partner, 'EP5_024', "Happy")
      GAME:WaitFrames(24)
    end

    -- ============================================================
    -- FIN — « ET C'EST AINSI... »
    -- ============================================================
    SOUND:FadeOutBGM(90)
    GAME:WaitFrames(40)
    centre('EP5_025')
    GAME:WaitFrames(30)
    centre('EP5_026')
    GAME:WaitFrames(45)
    -- Le carton de la fin, a la place du « lendemain ».
    centre('EP5_027')
    GAME:WaitFrames(60)
    GAME:FadeOut(false, 70)
    GAME:WaitFrames(50)
  end)

  if not ok then
    PrintInfo('[EP5] epilogue interrompu : ' .. tostring(err))
  end

  -- Sortie garantie hors pcall.
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() GAME:CutsceneMode(false) end)

  -- Le joueur peut sauvegarder avant l'assemblee.
  pcall(function() GAME:FadeIn(30) end)
end

return guild_third_floor_lobby_ch_5_epilogue
