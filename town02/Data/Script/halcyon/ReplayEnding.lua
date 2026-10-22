--[[
    ReplayEnding.lua

    Rejouabilite des donjons d'histoire.

    Une fois qu'un donjon d'histoire a ete termine (cinematiques vues, boss
    vaincu), il reste accessible depuis le menu de voyage de Metano. Le joueur
    peut le refaire en entier : etages, relais, profondeurs. Mais la salle du
    boss est VIDE — le gardien n'est plus la, l'evenement a deja eu lieu.
    Une courte scene le constate, puis l'ecran de resultats s'affiche et
    l'equipe rentre a la guilde (fin de journee normale).

    C'est le comportement des jeux PMD officiels, et c'est deja le patron
    utilise par `crooked_den.GenericEnding()`, `relic_forest.GenericEnding()`,
    `luminous_spring.GenericEnding()` et `apricorn_glade.GenericEnding()`.
    Ce module generalise ce patron aux 8 arenes qui en etaient depourvues.

    ------------------------------------------------------------------
    Utilisation

        require 'halcyon.ReplayEnding'

        ReplayEnding.EmptyArena({
          hero    = {200, 348},          -- position de depart du heros
          partner = {168, 348},          -- position de depart du partenaire
          camera  = {184, 344},          -- cadrage au fondu d'ouverture
          look    = {184, 244},          -- cadrage pendant le constat (option)
          walk    = 60,                  -- distance de marche vers le haut
          music   = 'Sky Peak Prairie.ogg',
          title   = true,                -- carton-titre du lieu
          lines   = {                    -- 4 a 6 boites, cles resx
            { spk='partner', emo='Normal',  key='VSG_R01' },
            { spk='hero',    emo='Worried', key='VSG_R02' },
            { spk='narrator',               key='VSG_R03' },
          },
        })

    Tout le corps est sous `pcall` : si une position, une animation ou une
    piste audio pose probleme, la scene est ecourtee mais la SORTIE reste
    garantie (sinon le joueur serait bloque sur une carte sans issue).
    C'est la meme precaution que celle prise sur les 7 `DefeatedBoss()`.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

ReplayEnding = {}

------------------------------------------------------------------
-- Etat « donjon d'histoire deja termine »
------------------------------------------------------------------
-- Un donjon est considere termine quand sa cinematique de conclusion a ete
-- vue. Ce ne sont PAS les drapeaux de routage (SteppeGuardianDefeated,
-- DefeatedRuinsBoss...) : ceux-la sont remis a false juste apres la scene.
-- Ce sont les drapeaux PERSISTANTS poses en fin de chapitre.
ReplayEnding.CLEARED = {
  relic_forest        = function() return SV.Chapter1  ~= nil and SV.Chapter1.TeamCompletedForest    == true end,
  illuminant_riverbed = function() return SV.Chapter2  ~= nil and SV.Chapter2.FinishedRiver          == true end,
  crooked_cavern      = function() return SV.Chapter3  ~= nil and SV.Chapter3.FinishedRootScene      == true end,
  apricorn_grove      = function() return SV.Chapter4  ~= nil and SV.Chapter4.FinishedGrove          == true end,
  --Les trois donjons de l'expedition se terminent ensemble : l'expedition est
  --bouclee au sommet du Mont Venteux, ce qui cloture aussi Steppe et Tunnel.
  vast_steppe         = function() return SV.Chapter5  ~= nil and SV.Chapter5.FinishedExpedition     == true end,
  searing_tunnel      = function() return SV.Chapter5  ~= nil and SV.Chapter5.FinishedExpedition     == true end,
  mount_windswept     = function() return SV.Chapter5  ~= nil and SV.Chapter5.FinishedExpedition     == true end,
  gloomy_forest       = function() return SV.Chapter6  ~= nil and SV.Chapter6.DefeatedGloomyBoss     == true end,
  --Ch7 : DefeatedRuinsBoss est un drapeau de routage remis a false. Le
  --drapeau durable est celui pose par la scene d'apres-combat.
  cloven_ruins        = function() return SV.Chapter5  ~= nil and SV.Chapter5.SawAnimaCoreCorruption == true end,
  waterfall_pond   = function() return SV.Chapter8  ~= nil and SV.Chapter8.CrystalSanctuaryComplete == true end,
  poisonous_forest     = function() return SV.Chapter9  ~= nil and SV.Chapter9.ForgottenMarshComplete == true end,
  sky_tower      = function() return SV.Chapter10 ~= nil and SV.Chapter10.CelestialPeakComplete == true end,
}

--Le donjon d'histoire `zoneID` a-t-il deja ete termine ?
function ReplayEnding.IsCleared(zoneID)
  local fn = ReplayEnding.CLEARED[zoneID]
  if fn == nil then return false end
  local ok, res = pcall(fn)
  return ok and res == true
end

--Le parcours complet du donjon (relais, profondeurs, salle du gardien) doit-il
--etre suivi ? Vrai pendant le chapitre concerne, et vrai a nouveau une fois le
--donjon termine — c'est la rejouabilite.
--Sert a remplacer les gardes `SV.ChapterProgression.Chapter == N` dans les
--ExitSegment, sans toucher a la logique de chapitre elle-meme.
function ReplayEnding.FollowsRoute(zoneID, chapter)
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == chapter then
    return true
  end
  return ReplayEnding.IsCleared(zoneID)
end

--Sommes-nous dans une visite de rejouabilite (donjon termine, chapitre passe) ?
--C'est cette fonction que les grounds d'arene interrogent pour savoir s'ils
--doivent jouer la salle vide plutot que la cinematique de boss.
function ReplayEnding.IsReplay(zoneID, chapter)
  -- Regle de base : le donjon doit avoir ete termine.
  --
  -- ATTENTION, piege verifie dans le depot : la progression de chapitre
  -- S'ARRETE A 6. `SV.ChapterProgression.Chapter` n'est jamais porte a 7, 8,
  -- 9, 10 ni 11 nulle part (seuls des `Chapter = 2..6` existent, dans
  -- guild_heros_room et mount_windswept). Un joueur reste donc bloque a 6, et
  -- apres la victoire sur Lugia il reste bloque a 10 s'il y est arrive par
  -- debug.
  --
  -- Consequence : on ne peut PAS se fier a « le chapitre a avance » pour
  -- decider qu'on est en rejouabilite. C'est le drapeau d'achevement du donjon
  -- lui-meme qui fait foi. Une fois la conclusion vue, l'arene est vide —
  -- que le chapitre ait avance ou non.
  --
  -- Sans cette regle : la Foret Lugubre (ch6, dernier chapitre atteignable)
  -- rejouait la cinematique ET le combat contre un Zeraora deja vaincu, et le
  -- Pic Celeste restait definitivement injouable apres la fin du jeu.
  return ReplayEnding.IsCleared(zoneID)
end

------------------------------------------------------------------
-- Ouverture au menu de voyage
------------------------------------------------------------------
-- Un donjon d'histoire termine doit rester joignable depuis le comptoir de
-- Metano. Or les 7 donjons ch5-ch10 n'etaient JAMAIS passes a UnlockDungeon :
-- seuls relic_forest, illuminant_riverbed, crooked_cavern, apricorn_grove et
-- gloomy_forest l'etaient (altere_pond_ch_1, guild_heros_room, etc.).
-- Sans ce balayage, ils n'apparaissent pas dans la liste des destinations,
-- meme une fois termines.
--
-- Idempotent : `DungeonUnlocked` garde chaque appel. Sur, donc, a executer
-- aussi souvent qu'on veut.
function ReplayEnding.SyncUnlocks()
  local ok, err = pcall(function()
    for zoneID, _ in pairs(ReplayEnding.CLEARED) do
      if ReplayEnding.IsCleared(zoneID) and not GAME:DungeonUnlocked(zoneID) then
        GAME:UnlockDungeon(zoneID)
        PrintInfo('[ReplayEnding] donjon rouvert au voyage : ' .. zoneID)
      end
    end
  end)
  if not ok then
    PrintInfo('[ReplayEnding] SyncUnlocks a echoue : ' .. tostring(err))
  end
end

--Fin de journee standard, identique aux 7 autres donjons de l'histoire :
--diner -> nuit -> lendemain, avec ecran de resultats et fanfare.
--Retour au refectoire (carte 6), ou au 2e etage (22) s'il reste une mission
--a rendre au tableau.
function ReplayEnding.EndDay(result)
  if result == nil then
    result = RogueEssence.Data.GameProgress.ResultType.Cleared
  end

  SV.TemporaryFlags.Dinnertime = true
  SV.TemporaryFlags.Bedtime = true
  SV.TemporaryFlags.MorningWakeup = true
  SV.TemporaryFlags.MorningAddress = true

  local exit_ground = 6
  if SV.TemporaryFlags.MissionCompleted then exit_ground = 22 end

  --display=true, fanfare=true : c'est `display` qui declenche le journal de
  --fin d'exploration (butin, experience, argent). Sans lui, le joueur voit
  --l'ecran noir puis se retrouve a la guilde sans bilan.
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
      "master_zone", -1, exit_ground, 0, true, true)
end

--Corps commun : l'equipe entre, trouve la salle vide, constate. Ne decide PAS
--de la suite — c'est l'appelant qui enchaine (fin d'exploration ou etage suivant).
function ReplayEnding.PlayEmptyScene(cfg)
  DEBUG.EnableDbgCoro()

  local ok, err = pcall(function()
    local hero = CH('PLAYER')
    local partner = CH('Teammate1')
    local t2 = CH('Teammate2')
    local t3 = CH('Teammate3')

    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end
    SOUND:StopBGM()

    --Mise en place.
    if hero ~= nil then
      GROUND:TeleportTo(hero, cfg.hero[1], cfg.hero[2], Direction.Up)
    end
    if partner ~= nil then
      GROUND:TeleportTo(partner, cfg.partner[1], cfg.partner[2], Direction.Up)
    end
    -- Les equipiers se placent en retrait, ECARTES sur les cotes : +16 px en Y
    -- et 32 px vers l'exterieur. C'est le placement des scenes de boss
    -- d'origine (vast_steppe_guardian_ch_5:28-29, mount_windswept:28).
    -- Un decalage de +32 en Y ferait sortir les equipiers de trois arenes
    -- (Steppe 528x368, Ruines 320x240, Mont 208x176), ou TeleportTo hors
    -- bornes laisse un allie invisible ou fige la scene.
    local ax = math.min(cfg.hero[1], cfg.partner[1]) - 32
    local bx = math.max(cfg.hero[1], cfg.partner[1]) + 32
    local ay = math.max(cfg.hero[2], cfg.partner[2]) + 16
    if t2 ~= nil then GROUND:TeleportTo(t2, ax, ay, Direction.Up) end
    if t3 ~= nil then GROUND:TeleportTo(t3, bx, ay, Direction.Up) end
    GAME:MoveCamera(cfg.camera[1], cfg.camera[2], 1, false)

    UI:ResetSpeaker()
    if cfg.title then
      UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
      GAME:WaitFrames(60)
      UI:WaitHideTitle(20)
    end
    GAME:FadeIn(40)
    if cfg.music ~= nil then SOUND:PlayBGM(cfg.music, true) end
    GAME:WaitFrames(20)

    --L'equipe avance de quelques pas dans la salle.
    local walk = cfg.walk or 48
    local coro1 = TASK:BranchCoroutine(function()
      if partner ~= nil then GROUND:MoveInDirection(partner, Direction.Up, walk, false, 1) end
    end)
    local coro2 = TASK:BranchCoroutine(function()
      GAME:WaitFrames(6)
      if hero ~= nil then GROUND:MoveInDirection(hero, Direction.Up, walk, false, 1) end
    end)
    local coro3 = TASK:BranchCoroutine(function()
      GAME:WaitFrames(10)
      if t2 ~= nil then GROUND:MoveInDirection(t2, Direction.Up, walk, false, 1) end
    end)
    local coro4 = TASK:BranchCoroutine(function()
      GAME:WaitFrames(14)
      if t3 ~= nil then GROUND:MoveInDirection(t3, Direction.Up, walk, false, 1) end
    end)
    local coro5 = TASK:BranchCoroutine(function()
      if cfg.look ~= nil then GAME:MoveCamera(cfg.look[1], cfg.look[2], 70, false) end
    end)
    TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
    GAME:WaitFrames(16)

    --Ils balaient la salle du regard. Personne.
    local look1 = TASK:BranchCoroutine(function()
      if partner ~= nil then
        GeneralFunctions.LookAround(partner, 3, 4, false, false, true, Direction.Up)
      end
    end)
    local look2 = TASK:BranchCoroutine(function()
      GAME:WaitFrames(10)
      if hero ~= nil then
        GeneralFunctions.LookAround(hero, 3, 4, false, false, true, Direction.Up)
      end
    end)
    TASK:JoinCoroutines({look1, look2})
    GAME:WaitFrames(16)

    --Le constat.
    for _, line in ipairs(cfg.lines) do
      local txt = STRINGS:Format(STRINGS.MapStrings[line.key])
      if line.spk == 'hero' then
        GeneralFunctions.HeroDialogue(hero, txt, line.emo or 'Normal')
      elseif line.spk == 'narrator' then
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue(txt)
        UI:SetCenter(false)
      else
        if partner ~= nil then
          UI:SetSpeaker(partner)
          GeneralFunctions.SetEmotion(line.emo or 'Normal')
          UI:WaitShowDialogue(txt)
        end
      end
      if line.wait ~= nil then GAME:WaitFrames(line.wait) end
    end

    GAME:WaitFrames(20)
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    GAME:WaitFrames(20)
  end)

  if not ok then
    PrintInfo('[ReplayEnding] scene ecourtee : ' .. tostring(err))
    --Filet de securite : on nettoie l'etat de cinematique avant de sortir.
    pcall(function() GAME:FadeOut(false, 20) end)
  end

  pcall(function() GAME:CutsceneMode(false) end)
end

--Salle vide en FIN de donjon : on constate, puis l'exploration se termine
--(ecran de resultats + fanfare) et l'equipe rentre dormir a la guilde.
function ReplayEnding.EmptyArena(cfg)
  ReplayEnding.PlayEmptyScene(cfg)
  --La sortie est HORS du pcall de PlayEmptyScene : quoi qu'il arrive dans la
  --mise en scene, l'exploration se termine proprement. Sans cela, une carte
  --d'arene n'a aucune issue et le joueur reste bloque dessus.
  ReplayEnding.EndDay(RogueEssence.Data.GameProgress.ResultType.Cleared)
end

return ReplayEnding
