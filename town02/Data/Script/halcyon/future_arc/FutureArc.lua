--[[
    FutureArc.lua — contrôleur persistant de l'arc temporel principal.

    Ce module est l'unique propriétaire des transitions. Le curseur sérialisé
    suit l'ordre canonique m17 -> m18 -> m19, y compris P06, P07 et les six
    donjons natifs. Une sortie de donjon ne progresse que sur ResultType.Cleared.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.future_arc.FutureCast'

FutureArc = {}
FutureArc.VERSION = 3

local function scene(ground, moduleName, spawnKey)
  return { kind='scene', ground=ground, module=moduleName, spawn=spawnKey or moduleName }
end

local function dungeon(ground, zone, retryModule, retrySpawn)
  return {
    kind='dungeon', ground=ground, zone=zone,
    retry=retryModule, retrySpawn=retrySpawn or retryModule
  }
end

-- Route reconstruite depuis le graphe SSB. Les scènes n06/n08/m26/m19d sont
-- des scénarios distincts et ne sont volontairement pas mêlées à ce parcours.
FutureArc.ROUTE = {
  scene('p05p01a', 'p05p01a_m17a0103', 'P05P01A_m17a0103'),

  scene('p05p02a', 'p05p02a_m17a0104', 'P05P02A_m17a0104'),
  scene('p05p02a', 'p05p02a_m17a0201', 'P05P02A_m17a0201'),
  scene('p05p02a', 'p05p02a_m17a0301', 'P05P02A_m17a0301'),
  scene('p05p03a', 'p05p03a_m17a0302', 'P05P03A_m17a0302'),
  scene('p05p04a', 'p05p04a_m17a0401', 'P05P04A_m17a0401'),
  scene('p05p04a', 'p05p04a_m17a0403', 'P05P04A_m17a0403'),

  scene('d18p11a', 'd18p11a_m17a0501', 'D18P11A_m17a0501'),
  scene('d18p11a', 'd18p11a_m17a0504', 'D18P11A_m17a0504'),
  scene('d18p11a', 'd18p11a_m17a0601', 'D18P11A_m17a0601'),
  dungeon('d18p11a', 'chasm_cave', 'd18p11a_m17a0701', 'D18P11A_m17a0701'),

  scene('d19p11a', 'd19p11a_m18a0101', 'D19P11A_m18a0101'),
  scene('d19p11a', 'd19p11a_m18a0201', 'D19P11A_m18a0201'),
  dungeon('d19p11a', 'dark_hill', 'd19p11a_m18a0301', 'D19P11A_m18a0301'),

  scene('p06p01a', 'p06p01a_m18a0401', 'P06P01A_m18a0401'),

  scene('d20p11a', 'd20p11a_m18b0501', 'D20P11A_m18b0501'),
  scene('d20p11a', 'd20p11a_m18b0601', 'D20P11A_m18b0601'),
  dungeon('d20p11a', 'sealed_ruin', 'd20p11a_m18b0701', 'D20P11A_m18b0701'),

  scene('d21p21a', 'd21p21a_m18b0801', 'D21P21A_m18b0801'),
  scene('d21p21a', 'd21p21a_m18b0901', 'D21P21A_m18b0901'),
  dungeon('d21p21a', 'sealed_ruin_pit', 'd21p21a_m18b1002', 'D21P21A_m18b1002'),

  scene('d21p41a', 'd21p41a_m18b0902', 'D21P41A_m18b0902'),
  scene('d21p41a', 'd21p41a_m18b1101', 'D21P41A_m18b1101'),
  scene('d21p41a', 'd21p41a_m18b1201', 'D21P41A_m18b1201'),
  dungeon('d21p41a', 'spiritomb_room', nil, nil),
  scene('d21p41a', 'd21p41a_m18b1301', 'D21P41A_m18b1301'),

  scene('p07p01a', 'p07p01a_m18b1401', 'P07P01A_m18b1401'),
  scene('p05p01a', 'p05p01a_m19a0102', 'P05P01A_m19a0102'),

  scene('d22p11a', 'd22p11a_m19a0201', 'D22P11A_m19a0201'),
  scene('d22p11a', 'd22p11a_m19a0301', 'D22P11A_m19a0301'),
  scene('d22p11a', 'd22p11a_m19a0401', 'D22P11A_m19a0401'),
  scene('d22p11a', 'd22p11a_m19a0403', 'D22P11A_m19a0403'),
  dungeon('d22p11a', 'dusk_forest', 'd22p11a_m19a0501', 'D22P11A_m19a0501'),

  scene('p08p01a', 'p08p01a_m19a0601', 'P08P01A_m19a0601'),
  scene('p09p01a', 'p09p01a_m19b1001', 'P09P01A_m19b1001'),
  scene('p09p01a', 'p09p01a_m19b1007', 'P09P01A_m19b1007'),
  scene('p09p01a', 'p09p01a_m19b1009', 'P09P01A_m19b1009'),
}

local function state()
  if SV.FutureArc == nil then SV.FutureArc = {} end
  local s = SV.FutureArc
  local previousVersion = tonumber(s.Version) or 0
  local legacyStep = tonumber(s.Step)
  local legacyStarted = legacyStep ~= nil and s.Completed ~= true

  -- Version 2 a remplacé le Step local (qui repartait à 1 à chaque Ground)
  -- par un curseur global. Une sauvegarde issue de l'ancien Begin ne possédait
  -- pas Active : la présence de Step est donc la preuve non ambiguë qu'elle se
  -- trouvait déjà dans l'arc. Le Ground courant permettra à Resume de choisir
  -- le checkpoint canonique le plus proche sans renvoyer le joueur au Bourg.
  if previousVersion < 2 then
    local wasCompleted = s.Completed == true
    local wasActive = s.Active == true
    s.Cursor = tonumber(s.Cursor) or 1
    s.Active = wasActive and not wasCompleted
    s.Completed = wasCompleted
    s.PresentReturnPending = s.PresentReturnPending == true
    s.PresentReturnSeen = s.PresentReturnSeen == true
    s.CurrentScene = ''
    s.PendingDungeon = ''
    s.DungeonState = 'idle'
    s.DungeonReturnGround = ''
    s.LastOutcome = ''
    s.ReturnGround = s.ReturnGround or 'bourg_comptoir'
    s.Attempts = s.Attempts or {}
    s.LastError = ''
  end

  if legacyStarted then
    s.Active = true
    s.LegacyNeedsGround = true
    s.LegacyStep = legacyStep
    s.LegacySpiritombDone = s.SpiritombBattleDone == true
  end
  -- Les anciens champs ne doivent pas redéclencher la migration à chaque load.
  s.Step = nil
  s.SpiritombBattleDone = nil

  -- Version 3 ajoute uniquement le checkpoint de migration ; elle conserve
  -- intégralement un run v2 en cours (donjon, résultat et Ground de retour).
  if previousVersion < 3 then
    s.Version = FutureArc.VERSION
    s.LegacyNeedsGround = s.LegacyNeedsGround == true
    s.LegacyStep = tonumber(s.LegacyStep) or 1
    s.LegacySpiritombDone = s.LegacySpiritombDone == true
  end

  if s.Cursor == nil or s.Cursor < 1 then s.Cursor = 1 end
  if s.Attempts == nil then s.Attempts = {} end
  if s.DungeonState == nil then s.DungeonState = 'idle' end
  if s.PendingDungeon == nil then s.PendingDungeon = '' end
  if s.DungeonReturnGround == nil then s.DungeonReturnGround = '' end
  if s.ReturnGround == nil or s.ReturnGround == '' then s.ReturnGround = 'bourg_comptoir' end
  if s.CurrentScene == nil then s.CurrentScene = '' end
  if s.LastError == nil then s.LastError = '' end
  return s
end

function FutureArc.EnsureState()
  return state()
end

function FutureArc.CanOffer()
  local s = state()
  local chapter = 0
  if SV.ChapterProgression ~= nil then chapter = tonumber(SV.ChapterProgression.Chapter) or 0 end
  local arrived = SV.Chapter11 ~= nil
    and SV.Chapter11.FinishedTreasureTownIntro == true
    and (tonumber(SV.Chapter11.TreasureTownArrivalVersion) or 0) >= 1
  s.Eligible = chapter >= 11 and arrived
  return s.Eligible and not s.Active and not s.Completed
end

function FutureArc.IsActive()
  return state().Active == true
end

function FutureArc.IsPresentReturnPending()
  return state().PresentReturnPending == true
end

local function unlockSpecialEpisode()
  if SV.FutureSpecialEpisode == nil then SV.FutureSpecialEpisode = {} end
  SV.FutureSpecialEpisode.Unlocked = true
end

local function migrateLegacyCheckpoint(currentGround)
  local s = state()
  if not s.LegacyNeedsGround then return end

  local target = nil
  if currentGround == 'd21p41a' and s.LegacySpiritombDone then
    -- L'ancien hook posait ce booléen uniquement après la victoire. Reprendre
    -- à la scène qui suit le donjon évite de faire rejouer un boss déjà vaincu.
    for index, action in ipairs(FutureArc.ROUTE) do
      if action.ground == currentGround and action.kind == 'dungeon' then
        target = index + 1
        break
      end
    end
  end
  if target == nil then
    for index, action in ipairs(FutureArc.ROUTE) do
      if action.ground == currentGround then
        target = index
        break
      end
    end
  end

  if target == nil then
    target = 1
    s.LastError = 'Ground legacy inconnu : ' .. tostring(currentGround)
  else
    s.LastError = ''
  end
  s.Cursor = target
  s.CurrentScene = ''
  s.PendingDungeon = ''
  s.DungeonReturnGround = ''
  s.DungeonState = 'idle'
  s.LegacyNeedsGround = false
  s.LegacySpiritombDone = false
  PrintInfo('[FutureArc] sauvegarde legacy reprise au curseur ' .. tostring(target)
    .. ' depuis ' .. tostring(currentGround))
end

local function runScene(action)
  local s = state()
  s.CurrentScene = action.module
  FutureCast.Spawn(action.spawn)
  local mod = require('halcyon.future_arc.scene.' .. action.module)
  if mod == nil or mod.Cutscene == nil then
    error('module de scène invalide : ' .. tostring(action.module))
  end
  local sceneResult, sceneErr = mod.Cutscene()
  if sceneResult == false then
    error('scène interrompue : ' .. tostring(action.module) .. ' — ' .. tostring(sceneErr))
  end
  s.CurrentScene = ''
  pcall(function() GAME:CutsceneMode(false) end)
  GAME:WaitFrames(5)
end

local function enterGround(ground)
  GAME:FadeOut(false, 30)
  GAME:EnterGroundMap(ground, 'Main_Entrance_Marker')
end

local function enterDungeon(action)
  local s = state()
  s.PendingDungeon = action.zone
  s.DungeonReturnGround = action.ground
  s.DungeonState = 'running'
  s.LastOutcome = ''
  s.Attempts[action.zone] = (tonumber(s.Attempts[action.zone]) or 0) + 1
  FutureCast.Cleanup()
  GAME:CutsceneMode(false)
  GAME:FadeOut(false, 30)
  GAME:EnterDungeon(action.zone, 0, 0, 0,
    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

local function spiritombRetry()
  GAME:CutsceneMode(true)
  GAME:FadeIn(20)
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue("La voix de Spiritomb ricane encore dans la pierre-clé...")
  UI:WaitShowDialogue("Le lien entre les cent huit esprits a vacillé, mais il n'a pas cédé.")
  UI:WaitShowDialogue("Massko se relève.[pause=15] Cette fois, personne ne restera isolé face à lui.")
  UI:WaitShowDialogue("Rassemblez vos forces, puis affrontez de nouveau Spiritomb.")
  UI:SetCenter(false)
  GAME:CutsceneMode(false)
end

local function retryDungeon(action)
  local s = state()
  if action.retry ~= nil then
    runScene({ kind='scene', ground=action.ground,
      module=action.retry, spawn=action.retrySpawn })
  else
    spiritombRetry()
  end
  s.DungeonState = 'idle'
  s.PendingDungeon = ''
  s.DungeonReturnGround = ''
  enterDungeon(action)
end

function FutureArc.Begin(returnGround)
  DEBUG.EnableDbgCoro()
  local s = state()
  if s.Completed or s.Active then return false end
  if not FutureArc.CanOffer() then return false end

  s.Offered = true
  s.Active = true
  s.Completed = false
  s.PresentReturnPending = false
  s.Cursor = 1
  s.CurrentScene = ''
  s.PendingDungeon = ''
  s.DungeonState = 'idle'
  s.LastOutcome = ''
  s.LastError = ''
  s.LegacyNeedsGround = false
  s.LegacySpiritombDone = false
  s.ReturnGround = returnGround or 'bourg_comptoir'
  s.DungeonReturnGround = ''
  enterGround(FutureArc.ROUTE[1].ground)
  return true
end

-- Appelé après COMMON.ExitDungeonMissionCheck et avant EndDungeonRun.
function FutureArc.OnDungeonExit(zoneId, result)
  local s = state()
  if not s.Active then return false end
  local action = FutureArc.ROUTE[s.Cursor]
  if action == nil or action.kind ~= 'dungeon' then
    s.LastError = 'sortie de donjon hors curseur : ' .. tostring(zoneId)
    return false
  end

  local actualZone = tostring(zoneId or '')
  if actualZone ~= action.zone or s.PendingDungeon ~= action.zone then
    s.LastError = 'donjon inattendu : ' .. actualZone .. ' / attendu ' .. action.zone
    s.DungeonState = 'failed'
    s.LastOutcome = tostring(result)
    return false
  end

  s.LastOutcome = tostring(result)
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    s.DungeonState = 'cleared'
  else
    s.DungeonState = 'failed'
  end
  return true
end

function FutureArc.GetDungeonReturnGround(fallback)
  local s = state()
  if s.Active and s.DungeonReturnGround ~= nil and s.DungeonReturnGround ~= '' then
    return s.DungeonReturnGround
  end
  return fallback or 'bourg_comptoir'
end

local function completeRoute()
  local s = state()
  FutureCast.Cleanup()
  s.Active = false
  s.Completed = true
  s.PresentReturnPending = true
  s.PresentReturnSeen = false
  s.CurrentScene = ''
  s.PendingDungeon = ''
  s.DungeonReturnGround = ''
  s.DungeonState = 'idle'
  s.LastOutcome = 'completed'
  s.LegacyNeedsGround = false
  s.LegacySpiritombDone = false
  unlockSpecialEpisode()
  enterGround(s.ReturnGround)
end

-- Point d'entrée unique de tous les Grounds P05–P09/D18–D22.
function FutureArc.Resume(currentGround)
  DEBUG.EnableDbgCoro()
  local s = state()
  if not s.Active then
    pcall(function() GAME:CutsceneMode(false) end)
    GAME:FadeIn(20)
    return
  end
  migrateLegacyCheckpoint(currentGround)

  local ok, err = pcall(function()
    while s.Active do
      local action = FutureArc.ROUTE[s.Cursor]
      if action == nil then
        completeRoute()
        return
      end

      if action.ground ~= currentGround then
        enterGround(action.ground)
        return
      end

      if action.kind == 'scene' then
        runScene(action)
        s.Cursor = s.Cursor + 1
      elseif action.kind == 'dungeon' then
        if s.DungeonState == 'cleared' and s.PendingDungeon == action.zone then
          s.PendingDungeon = ''
          s.DungeonReturnGround = ''
          s.DungeonState = 'idle'
          s.Cursor = s.Cursor + 1
        elseif s.DungeonState == 'failed' then
          retryDungeon(action)
          return
        elseif s.DungeonState == 'running' then
          -- Une sauvegarde/recharge sur le Ground pendant un run interrompu ne
          -- doit jamais avancer silencieusement.
          s.DungeonState = 'failed'
          retryDungeon(action)
          return
        else
          enterDungeon(action)
          return
        end
      else
        error('type d\'action inconnu : ' .. tostring(action.kind))
      end
    end
  end)

  if not ok then
    s.LastError = tostring(err)
    PrintInfo('[FutureArc] interruption au curseur ' .. tostring(s.Cursor) .. ' : ' .. tostring(err))
    pcall(function()
      FutureCast.Cleanup()
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end)
  end
end

-- Long échange d'activation, joué lors d'une interaction normale avec Loaklass.
-- Retourne true uniquement si l'arc a été lancé (le handler ne doit alors pas
-- proposer le voyage ordinaire vers Métano).
function FutureArc.Offer(lapras)
  if not FutureArc.CanOffer() then return false end
  local s = state()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if not s.Offered then
    s.Offered = true
    SOUND:FadeOutBGM(30)
    SOUND:PlayBGM('Star Cave.ogg', true)
    UI:SetSpeaker(lapras)
    UI:WaitShowDialogue("Un instant.[pause=20] Depuis notre traversée, quelque chose répond à votre présence sous les vagues.")
    UI:WaitShowDialogue("Ce n'est ni un courant, ni le chant d'un Pokémon marin.[pause=15] C'est une résonance du temps.")
    UI:WaitShowDialogue("Elle s'accroche à vos Cœurs de Vitalité comme une lumière reflétée dans une eau très ancienne.")
    GAME:WaitFrames(15)

    if partner ~= nil then
      UI:SetSpeaker(partner)
      GeneralFunctions.SetEmotion('Worried')
      UI:WaitShowDialogue("Une résonance... du temps ?[pause=15] Après tout ce qui s'est passé, ça ne me rassure pas vraiment.")
      UI:WaitShowDialogue("Est-ce que le Cercle du Suaire aurait laissé une autre trace derrière nous ?")
    end

    UI:SetSpeaker(lapras)
    GeneralFunctions.SetEmotion('Normal')
    UI:WaitShowDialogue("Non.[pause=15] Cette vibration est plus vieille que leurs mensonges, et beaucoup plus lointaine.")
    UI:WaitShowDialogue("Jadis, j'ai porté deux explorateurs jusqu'à une terre où le ciel lui-même semblait attendre.")
    UI:WaitShowDialogue("Ils poursuivaient un ami accusé d'avoir blessé l'histoire.[pause=20] Pourtant, c'est l'histoire qui avait été enchaînée.")
    UI:WaitShowDialogue("Leur voyage a laissé dans l'océan une cicatrice invisible.[pause=15] Ce soir, elle s'est rouverte.")
    GAME:WaitFrames(15)

    GeneralFunctions.HeroDialogue(hero,
      "(Une cicatrice temporelle...[pause=15] Elle bat au même rythme que mon Cœur.)", 'Worried')

    if partner ~= nil then
      UI:SetSpeaker(partner)
      GeneralFunctions.SetEmotion('Surprised')
      UI:WaitShowDialogue("{0}... toi aussi, tu l'as sentie, n'est-ce pas ?", hero:GetDisplayName())
      UI:WaitShowDialogue("Pendant une seconde, ton ombre allait dans une autre direction.")
    end

    UI:SetSpeaker(lapras)
    UI:WaitShowDialogue("La résonance ne vous demande pas de changer le passé.[pause=15] Elle veut être comprise.")
    UI:WaitShowDialogue("Elle montre un avenir pétrifié, privé de vent, où même les étoiles ont cessé de tourner.")
    UI:WaitShowDialogue("Vous y verrez des visages connus, mais pas nécessairement les êtres que vous connaissez aujourd'hui.")
    UI:WaitShowDialogue("Le temps assemble parfois des rôles semblables avec des âmes différentes.")
    GAME:WaitFrames(20)

    if partner ~= nil then
      UI:SetSpeaker(partner)
      GeneralFunctions.SetEmotion('Determined')
      UI:WaitShowDialogue("Alors ce ne sera pas une excursion.[pause=10] Ce sera un témoignage.")
      UI:WaitShowDialogue("Si quelqu'un a traversé cet avenir sans pouvoir raconter ce qu'il a vu, on peut au moins l'écouter.")
    end

    UI:SetSpeaker(lapras)
    UI:WaitShowDialogue("Exactement.[pause=15] Mais l'écho est dangereux.")
    UI:WaitShowDialogue("Dans ses donjons, la fatigue, les blessures et la peur seront réelles.")
    UI:WaitShowDialogue("Une défaite vous rejettera au dernier seuil stable.[pause=15] Elle n'effacera pas ce que vous aurez compris.")
    UI:WaitShowDialogue("Ne confondez jamais cette vision avec votre présent.[pause=15] Cherchez toujours la voix de votre compagnon.")
    GAME:WaitFrames(15)

    GeneralFunctions.HeroDialogue(hero,
      "(Ne pas réécrire.[pause=10] Ne pas détourner les yeux.[pause=15] Traverser, comprendre, puis revenir.)", 'Determined')

    if partner ~= nil then
      UI:SetSpeaker(partner)
      GeneralFunctions.SetEmotion('Happy')
      UI:WaitShowDialogue("Je resterai juste à côté.[pause=10] Même si le ciel s'arrête, je te rappellerai où est notre époque.")
    end

    UI:SetSpeaker(lapras)
    UI:WaitShowDialogue("Alors approchez.[pause=15] Quand vos deux Cœurs répondront ensemble, la mer ouvrira le premier souvenir.")
    UI:WaitShowDialogue("Vous pourrez encore refuser.[pause=15] Aucun avenir digne d'être sauvé ne naît d'un choix forcé.")
  else
    UI:SetSpeaker(lapras)
    UI:WaitShowDialogue("La résonance temporelle attend toujours sous les vagues.[pause=15] Voulez-vous l'écouter maintenant ?")
  end

  UI:SetSpeaker(lapras)
  UI:ChoiceMenuYesNo("Entrer dans la résonance temporelle ?", false)
  UI:WaitForChoice()
  local accepted = UI:ChoiceResult()
  if accepted then
    UI:WaitShowDialogue("Restez unis.[pause=15] Je garderai le chemin du retour ouvert depuis cette rive.")
    if hero ~= nil then GROUND:CharEndAnim(hero) end
    if partner ~= nil then
      partner.IsInteracting = false
      GROUND:CharEndAnim(partner)
    end
    GAME:CutsceneMode(false)
    return FutureArc.Begin('bourg_comptoir')
  end

  UI:WaitShowDialogue("Je comprends.[pause=15] L'écho attendra sans vous poursuivre.")
  SOUND:PlayBGM('Treasure Town.ogg', true)
  GAME:CutsceneMode(false)
  return false
end

function FutureArc.PlayPresentReturn()
  local s = state()
  if not s.PresentReturnPending then return false end
  s.PresentReturnPending = false
  s.PresentReturnSeen = true
  FutureCast.Cleanup()

  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local lapras = CH('Lapras')
  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  GAME:FadeIn(40)
  SOUND:PlayBGM('Treasure Town.ogg', true)
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue("Le grondement du futur se brise comme une vague contre le récif.")
  UI:WaitShowDialogue("La lumière revient.[pause=20] Le Bourg du Comptoir respire, vivant, autour de vous.")
  UI:SetCenter(false)

  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion('Joyous')
    UI:WaitShowDialogue("{0} ![pause=15] Le vent bouge ![pause=10] On est revenus !", hero:GetDisplayName())
    UI:WaitShowDialogue("Je n'oublierai pas cet avenir.[pause=15] Mais je refuse de le prendre pour une condamnation.")
  end
  if lapras ~= nil then
    UI:SetSpeaker(lapras)
    UI:WaitShowDialogue("Vos deux Cœurs ont retrouvé le même rivage.[pause=15] La résonance peut enfin se refermer.")
    UI:WaitShowDialogue("Ce que vous avez vu n'offre aucune créature légendaire, aucun pouvoir gratuit.[pause=15] Seulement un avertissement.")
  end
  GeneralFunctions.HeroDialogue(hero,
    "(Le futur n'est pas une route déjà pavée.[pause=15] C'est une responsabilité.)", 'Determined')
  unlockSpecialEpisode()
  GAME:CutsceneMode(false)
  return true
end

return FutureArc
