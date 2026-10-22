--[[
    dungeon55_events.lua — adaptation sûre de D55 / Passage du Temps.

    D55 n'appartient pas au parcours m17–m19 du héros : ses n06a* proviennent
    de l'épisode spécial de l'Équipe Charme. Aucun Ground D55 n'existe dans les
    ressources actives et les scènes générées exigent des objets/acteurs Ground
    absents des étages procéduraux. Elles sont donc conservées comme sources,
    mais ne sont jamais exécutées dans un DungeonScene.

    L'adaptation jouable utilise trois segments natifs de trois étages,
    indépendamment validés dans le Passage du Temps. Leurs générateurs et
    contenus proviennent de l'import PMDODump/DumpAsset de la Carrière de
    Cuivre. Les introductions et retours se jouent sur le Ground officiel du
    Bourg ; le donjon reste entièrement natif.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

Dungeon55Events = {}
Dungeon55Events.VERSION = 2
Dungeon55Events.NATIVE_SEGMENTS = {
  [1] = 0,
  [2] = 1,
  [3] = 2,
}

-- Casse exacte des fichiers sur Linux. Inventaire conservé pour une future
-- restauration sur de vrais Grounds D55, sans mélanger ces scènes au héros.
Dungeon55Events.SOURCE_SEGMENTS = {
  [1] = {
    'D55P11A_enter00', 'D55P11A_enter03', 'D55P11A_enter04',
    'D55P11A_enter05', 'D55P11A_enter06', 'D55P11A_enter08',
    'D55P11A_n06a0701', 'D55P11A_n06a0801', 'D55P11A_n06a0901',
    'D55P11A_n06a1601', 'D55P11A_n06a3903', 'D55P11A_n06a3908',
  },
  [2] = {
    'D55P21A_enter00', 'D55P21A_enter01', 'D55P21A_enter02',
    'D55P21A_enter05', 'D55P21A_enter06', 'D55P21A_enter07',
    'D55P21A_n06a1001', 'D55P21A_n06a1101', 'D55P21A_n06a1201',
    'D55P21A_n06a1401', 'D55P21A_n06a1501',
  },
  [3] = {
    'D55P41A_n06a1301', 'D55P41A_n06a1701', 'D55P41A_n06a1801',
  },
}

Dungeon55Events.TITLES = {
  [1] = "Premier écho — Les exploratrices de la carrière",
  [2] = "Deuxième écho — Le passage défendu",
  [3] = "Troisième écho — Ce que gardait la pierre",
}

local function state()
  if SV.FutureSpecialEpisode == nil then SV.FutureSpecialEpisode = {} end
  local s = SV.FutureSpecialEpisode
  if s.Version == nil or s.Version < Dungeon55Events.VERSION then
    s.Version = Dungeon55Events.VERSION
    s.Unlocked = s.Unlocked == true
    s.Active = false
    s.CurrentSegment = tonumber(s.CurrentSegment) or 1
    s.PendingSegment = 0
    s.Segment1Done = s.Segment1Done == true
    s.Segment2Done = s.Segment2Done == true
    s.Segment3Done = s.Segment3Done == true
    s.Completed = s.Completed == true
    s.ReturnPending = false
    s.Attempts = tonumber(s.Attempts) or 0
    s.LastResult = ''
  end
  if s.CurrentSegment == nil or s.CurrentSegment < 1 then s.CurrentSegment = 1 end
  if s.CurrentSegment > 3 then s.CurrentSegment = 3 end
  if s.PendingSegment == nil then s.PendingSegment = 0 end
  if s.LastResult == nil then s.LastResult = '' end
  return s
end

local function groundIdx(name)
  local ok, idx = pcall(function()
    local zones = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]
    local master = zones:Get('master_zone')
    for ii = 0, master.Grounds.Count - 1, 1 do
      if master.Grounds[ii] == name then return ii end
    end
    return -1
  end)
  if ok then return idx end
  return -1
end

function Dungeon55Events.IsReturnPending()
  return state().ReturnPending == true
end

function Dungeon55Events.CanOffer()
  local s = state()
  return s.Unlocked == true and not s.Active and not s.Completed
    and not s.ReturnPending and s.CurrentSegment >= 1 and s.CurrentSegment <= 3
end

local function sayCentered(lines)
  UI:ResetSpeaker()
  UI:SetCenter(true)
  for _, line in ipairs(lines) do UI:WaitShowDialogue(line) end
  UI:SetCenter(false)
end

local function playIntro(segment, lapras)
  GAME:CutsceneMode(true)
  SOUND:FadeOutBGM(30)
  SOUND:PlayBGM('Star Cave.ogg', true)
  UI:SetSpeaker(lapras)

  if segment == 1 then
    UI:WaitShowDialogue("La grande résonance s'est tue, mais trois éclats plus modestes dérivent encore près du récif.")
    UI:WaitShowDialogue("Ils ne parlent ni de votre équipe, ni de l'avenir que vous venez de traverser.")
    UI:WaitShowDialogue("Ils gardent le souvenir de trois exploratrices : Lockpin, Gardevoir et Charmina.")
    UI:WaitShowDialogue("Leur équipe s'appelait l'Équipe Charme.[pause=15] Elles cherchaient un trésor dans une carrière parcourue d'eau.")
    sayCentered({
      "La pierre résonne sous leurs pas.[pause=15] D'autres explorateurs ont suivi la même rumeur.",
      "Arbok, Maganon, Drascore, Démolosse, Dimoret et Cacturne convoitent eux aussi le passage.",
      "L'écho ne demande pas de prendre leur place.[pause=15] Il demande de retrouver la route qu'ils ont laissée.",
      "Au-delà de trois seuils, le premier fragment attend.",
    })
  elseif segment == 2 then
    UI:WaitShowDialogue("Le premier éclat est stable.[pause=15] Le suivant se trouve plus profondément dans le même souvenir.")
    UI:WaitShowDialogue("L'Équipe Charme poursuit sa recherche malgré les détours, les rivaux et les fausses pistes.")
    sayCentered({
      "Lockpin avance la première, attentive au moindre changement dans la roche.",
      "Gardevoir écoute les pensées que la carrière renvoie.[pause=15] Charmina éprouve chaque passage avant les autres.",
      "Devant elles, une présence protège l'accès.[pause=15] La force seule ne suffira pas à comprendre son avertissement.",
      "Traversez le Passage du Temps une deuxième fois pour rejoindre leur trace.",
    })
  else
    UI:WaitShowDialogue("Il ne reste qu'un éclat.[pause=15] C'est aussi le plus instable.")
    UI:WaitShowDialogue("Galeking et les Galegon défendent le cœur de la carrière, tandis qu'un Métamorph brouille les apparences.")
    sayCentered({
      "Toutes les silhouettes ne disent pas qui elles sont.[pause=15] Tous les trésors ne veulent pas être emportés.",
      "L'Équipe Charme atteint le dernier seuil avec ses forces, ses défauts et la confiance gagnée en chemin.",
      "Ce fragment ne promet aucune récompense légendaire.[pause=15] Il conserve seulement la vérité de leur aventure.",
      "Traversez une dernière fois, puis ramenez le souvenir au présent.",
    })
  end

  UI:SetSpeaker(lapras)
  UI:WaitShowDialogue("Le donjon est réel tant que vous êtes dans l'écho.[pause=15] Une défaite vous ramènera ici sans valider le fragment.")
end

function Dungeon55Events.Offer(lapras)
  if not Dungeon55Events.CanOffer() then return false end
  local s = state()
  local segment = s.CurrentSegment
  UI:SetSpeaker(lapras)
  UI:WaitShowDialogue("Un fragment séparé de l'Équipe Charme est accessible :[br]« " .. Dungeon55Events.TITLES[segment] .. " ».")
  UI:ChoiceMenuYesNo("Explorer ce fragment spécial ?", false)
  UI:WaitForChoice()
  if not UI:ChoiceResult() then
    UI:WaitShowDialogue("Très bien.[pause=15] Ce souvenir restera distinct du vôtre et attendra votre décision.")
    return false
  end

  playIntro(segment, lapras)
  s.Active = true
  s.PendingSegment = segment
  s.ReturnPending = false
  s.LastResult = ''
  s.Attempts = (tonumber(s.Attempts) or 0) + 1

  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  if hero ~= nil then GROUND:CharEndAnim(hero) end
  if partner ~= nil then
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
  end
  GAME:CutsceneMode(false)
  GAME:FadeOut(false, 30)
  local nativeSegment = Dungeon55Events.NATIVE_SEGMENTS[segment]
  if nativeSegment == nil then
    s.Active = false
    s.PendingSegment = 0
    PrintInfo('[Dungeon55Events] fragment D55 invalide : ' .. tostring(segment))
    GAME:FadeIn(1)
    return false
  end
  GAME:EnterDungeon('passage_temps', nativeSegment, 0, 0,
    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  return true
end

-- Appelé par le hook natif ExitSegment. Le résultat reste un enum moteur et
-- l'identité du segment doit correspondre au fragment enregistré avant entrée.
function Dungeon55Events.OnDungeonExit(result, nativeSegment)
  local s = state()
  if not s.Active then return false end
  local segment = tonumber(s.PendingSegment) or 0
  local expectedNative = Dungeon55Events.NATIVE_SEGMENTS[segment]
  if expectedNative == nil or tonumber(nativeSegment) ~= expectedNative then
    s.Active = false
    s.ReturnPending = true
    s.LastResult = 'invalid_segment'
    PrintInfo('[Dungeon55Events] sortie D55 incohérente : fragment '
      .. tostring(segment) .. ', segment natif ' .. tostring(nativeSegment))
    return false
  end

  s.Active = false
  s.ReturnPending = true
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    s.LastResult = 'cleared'
    s['Segment' .. tostring(segment) .. 'Done'] = true
    if segment < 3 then
      s.CurrentSegment = segment + 1
    else
      s.Completed = true
      s.CurrentSegment = 3
    end
  else
    s.LastResult = 'failed'
    s.CurrentSegment = segment
  end
  return true
end

function Dungeon55Events.HandleExit(result, rescue, zone, segmentID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false
  if exited == true then return end

  Dungeon55Events.OnDungeonExit(result, segmentID)
  GeneralFunctions.EndDungeonRun(result, 'master_zone', -1,
    groundIdx('bourg_comptoir'), 0, false, false)
end

function Dungeon55Events.PlayReturn()
  local s = state()
  if not s.ReturnPending then return false end
  local segment = tonumber(s.PendingSegment) or 0
  if segment < 1 or segment > 3 then segment = s.CurrentSegment end
  s.ReturnPending = false
  s.PendingSegment = 0

  GAME:CutsceneMode(true)
  GAME:FadeIn(30)
  SOUND:PlayBGM('Treasure Town.ogg', true)
  if s.LastResult == 'cleared' then
    if segment == 1 then
      sayCentered({
        "Le premier éclat rejoint la surface.",
        "La rivalité n'a pas effacé l'entraide : sous les bravades, chaque équipe cherchait une raison de continuer.",
        "Le souvenir de Lockpin, Gardevoir et Charmina demeure intact.[pause=15] Un deuxième fragment répond plus loin.",
      })
    elseif segment == 2 then
      sayCentered({
        "Le deuxième éclat cesse de trembler.",
        "L'obstacle défendu n'était pas une invitation à frapper plus fort, mais à observer avant d'avancer.",
        "Deux fragments sont revenus au présent.[pause=15] Le dernier garde encore le cœur de la carrière.",
      })
    else
      sayCentered({
        "Le dernier éclat s'ouvre, puis se dissout dans la lumière du Bourg.",
        "Les apparences de Métamorph, la garde de Galeking et le tumulte des Galegon retrouvent leur place dans le récit.",
        "L'Équipe Charme n'a pas reçu un pouvoir gratuit.[pause=15] Elle a gagné la vérité de son voyage.",
        "Les trois fragments sont complets.[pause=20] L'épisode spécial peut désormais reposer sans se mêler à votre avenir.",
      })
    end
  else
    sayCentered({
      "Le fragment vous rejette sur le rivage avant de se refermer.",
      "Rien n'est perdu : ce seuil n'a simplement pas encore été validé.",
      "Préparez-vous, puis reparlez à Loaklass pour reprendre ce même fragment.",
    })
  end
  s.LastResult = ''
  GAME:CutsceneMode(false)
  return true
end

return Dungeon55Events
