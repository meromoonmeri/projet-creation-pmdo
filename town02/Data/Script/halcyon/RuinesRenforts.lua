--[[
    RuinesRenforts.lua — LA REVELATION DE LA TOUR

    Ce module ne contient plus qu'une scene : celle qui se joue DEHORS, au
    camp, quand l'equipe ressort des Ruines.

    HISTORIQUE. Il portait aussi les huit gardes de Regigigas, l'arrivee des
    renforts de la guilde, l'effondrement et la fuite. Tout cela vivait sur le
    ground cloven_ruins_boss. Ce ground est supprime : les gardes sont
    desormais des combattants poses dans MapTeams de l'etage-arene
    (sanctuaire_titans, segment 7), et l'effondrement comme la fuite se
    jouent en donjon dans RuinesTitan.lua.

    Ce qui reste ici est le seul morceau qui se passe reellement a la surface,
    et qui doit donc rester une scene de ground : le camp voit la falaise se
    refermer, et une tour apparaitre au-dessus des ruines.
]]--
require 'origin.common'
require 'halcyon.GeneralFunctions'

RuinesRenforts = {}

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

--------------------------------------------------------------------
-- DEHORS — ce que la pierre a laisse derriere elle.
--------------------------------------------------------------------
-- Equivalent du monument d'EoS qui ouvre les Ruines Cachees. Joue au
-- camp, apres le retour : la scene de fuite s'arrete sur un noir, et
-- c'est ici que le noir se leve.
function RuinesRenforts.Revelation()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  local ok = pcall(function()
    GAME:CutsceneMode(true)
    GAME:FadeIn(60)
    GAME:WaitFrames(40)
    centre('CRB_REVEL_01')
    GAME:WaitFrames(22)

    -- LE SEISME — la terre tremble, la tour monte d'elle-meme.
    -- Le sol encaisse d'abord, puis l'ecran bouge par-dessus la boite de
    -- dialogue : on ressent la secousse pendant qu'on lit.
    SOUND:PlayBattleSE('EVT_Tower_Quake')
    GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 5, 30))
    GAME:WaitFrames(18)
    if partner ~= nil then
      GROUND:CharSetEmote(partner, "shock", 1)
      dit(partner, 'CRB_REVEL_05', "Surprised")   -- « La terre tremble ! Qu'est-ce qui se passe !? »
    end
    -- Deuxieme secousse, plus forte, qui accompagne le heros.
    SOUND:PlayBattleSE('EVT_Tower_Quake')
    GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 7, 40))
    GAME:WaitFrames(20)
    if hero ~= nil then
      GeneralFunctions.HeroDialogue(hero,
        STRINGS:Format(STRINGS.MapStrings['CRB_REVEL_03']), "Worried")
    end
    -- La falaise s'entrouvre, le passage apparait.
    GAME:WaitFrames(20)
    if partner ~= nil then
      GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
      dit(partner, 'CRB_REVEL_02', "Surprised")
    end
    GAME:WaitFrames(18)
    centre('CRB_REVEL_04')
    GAME:WaitFrames(25)
  end)
  if not ok then
    PrintInfo('[Ruines] Revelation : echec, la progression continue.')
  end

  -- HORS du pcall : le deverrouillage a lieu quoi qu'il arrive.
  GAME:CutsceneMode(false)
  SV.Ruines = SV.Ruines or {}
  SV.Ruines.TourRevelee = true
  SV.Ruines.SceneS04P1902Pending = false
  SV.Ruines.SceneS04P1902Complete = true
  PrintInfo('[Cloven Ruin] s04p1902 complete; Concealed Ruins awakened')
  -- tour_reliques (ch28) retirée de la base : plus de déblocage ici.
  PrintInfo('[Ruines] Tour des Reliques deverrouillee')

  -- Retour de l'expédition des Ruines : boucle le chapitre 5 et transition vers ch 6.
  if SV.Chapter5 ~= nil then
    SV.Chapter5.RuinsExpeditionDone = true
    SV.Chapter5.FinishedExpedition = true
  end
  GAME:FadeOut(false, 60)
  GAME:EnterGroundMap("guild_third_floor_lobby", "Main_Entrance_Marker")
end

return RuinesRenforts
