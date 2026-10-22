--[[
    init.lua
    Mount Windswept Midpoint — checkpoint entre la première moitie et la seconde.
    Miroir de searing_tunnel_midpoint/init.lua.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.ground.mount_windswept_midpoint.mount_windswept_midpoint_ch_5'

-- [NREPROBE] sonde locale (audit runtime).
local function nre_snap(tag)
  local ok, msg = pcall(function()
    local zone = tostring(_ZONE.CurrentZoneID)
    local seg = tostring(_ZONE.CurrentMapID.Segment)
    local save_n = _DATA.Save.ActiveTeam.Players.Count
    return string.format('[NREPROBE][%s] zone=%s seg=%s Save.Team=%d', tag, zone, seg, save_n)
  end)
  PrintInfo(ok and msg or ('[NREPROBE]['..tag..'] snapshot FAILED: '..tostring(msg)))
end

local mount_windswept_midpoint = {}

function mount_windswept_midpoint.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_mount_windswept_midpoint <<= [build 2026-08-03-N]')
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

-- Un callback de GroundMap qui échoue après avoir armé CutsceneMode laisse le
-- moteur sous le fondu noir et le joueur sans reprise de contrôle. Le moteur
-- journalise l'erreur du ScriptEvent, mais ne peut pas restaurer l'état Lua de
-- la scène. On conserve donc la cause dans le log et on garantit ici la sortie.
local function PlotScriptingSafely()
  local ok, err = pcall(function()
    mount_windswept_midpoint.PlotScripting()
  end)
  if not ok then
    PrintInfo('[MOUNTAIN_MIDPOINT][ERROR] PlotScripting interrompu : '..tostring(err))
    pcall(function() GAME:CutsceneMode(false) end)
    pcall(function() GAME:MoveCamera(0, 0, 1, true) end)
    pcall(function() GAME:FadeIn(1) end)
  end
end

function mount_windswept_midpoint.Enter(map)
  nre_snap('mount_windswept_midpoint.Enter')
  if SV.Chapter5.PlayedMountMidpointIntro == nil then SV.Chapter5.PlayedMountMidpointIntro = false end
  if SV.Chapter5.WindsweptMidReturn == nil then SV.Chapter5.WindsweptMidReturn = false end
  PlotScriptingSafely()
end

function mount_windswept_midpoint.Update(map)
end

function mount_windswept_midpoint.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

-- Reprise d'une sauvegarde faite AU relais (rocher de Kangourex,
-- « Sauvegarder et quitter »). C'est l'autre moitie du cas « sortie a
-- l'amiable » : le joueur revient sur ce palier sans y avoir echoue.
-- On arme donc l'etat RepeatArrival, sauf si l'intro n'a jamais tourne
-- (le joueur doit d'abord decouvrir le lieu) ou si un reveil apres KO
-- est deja en attente.
function mount_windswept_midpoint.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  if SV.ChapterProgression.Chapter == 5
     and SV.Chapter5.PlayedMountMidpointIntro
     and SV.Chapter5.WindsweptMidState ~= 'DeathArrival' then
    SV.Chapter5.WindsweptMidReturn = true
  end
  PlotScriptingSafely()
end

-- ROUTEUR DU POINT MEDIAN — meme ordre de branches que le Tunnel
-- Incandescent (searing_tunnel_midpoint/init.lua:159-166), qui sert de
-- reference au template. Les 4 etats sont :
--   DeathArrival  : KO au-dela du checkpoint  -> reveil au sol
--   FirstArrival  : premiere venue            -> decouverte + titre
--   RepeatArrival : retour a l'amiable        -> reprise sobre
--   (defaut)      : relais connu              -> SetupGround + fondu
function mount_windswept_midpoint.PlotScripting()
  if SV.Chapter5.WindsweptMidState == 'DeathArrival' then
    SV.Chapter5.WindsweptMidState = nil
    --Le reveil consomme aussi le drapeau de retour a l'amiable : on ne
    --veut pas enchainer les deux cinematiques au meme chargement.
    SV.Chapter5.WindsweptMidReturn = false
    mount_windswept_midpoint_ch_5.WipedCutscene()
    return
  end
  if SV.ChapterProgression.Chapter == 5 then
    if not SV.Chapter5.PlayedMountMidpointIntro then
      mount_windswept_midpoint_ch_5.FirstArrival()
    elseif SV.Chapter5.WindsweptMidReturn
       and not mount_windswept_midpoint_ch_5.HasPendingScene() then
      --Retour a l'amiable (repli volontaire ou sauvegarde reprise ici).
      --Drapeau consomme immediatement : la scene ne joue qu'une fois
      --par retour, pas a chaque rechargement de la carte.
      --La garde HasPendingScene evite d'ecraser une cinematique de
      --progression (Fragment, derniere veillee) qui, elle, prime.
      SV.Chapter5.WindsweptMidReturn = false
      mount_windswept_midpoint_ch_5.RepeatArrival()
    else
      mount_windswept_midpoint_ch_5.SetupGround()
    end
  else
    GAME:FadeIn(20)
  end
end

-- North exit : mini-boss d'abord (s'il n'est pas battu), sinon segment 2.
-- Fix audit : même correction que la Grande Steppe — l'arène du mini-boss
-- était orpheline, le relais sautait directement au segment 2.
function mount_windswept_midpoint.North_Exit_Touch(obj, activator)
  nre_snap('mount_windswept_midpoint.North_Exit_Touch')
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Souhaitez-vous continuer l'ascension ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    -- MINI-BOSS RETIRE (demande utilisateur : « supprime les mini boss, le
    -- donjon doit avoir qu'un boss final c'est tornadus »).
    --
    -- Le relais envoyait vers l'arene de Gligar + Skarmory (segment 1) tant
    -- que SV.Chapter5.MountMiniBossCleared etait faux. Ce detour est
    -- supprime : depuis le relais, l'ascension mene DIRECTEMENT aux Cretes
    -- (segment 2), puis au sommet et a Tornadus, seul boss du donjon.
    --
    -- On garde la distinction session active / nouvelle session : c'etait le
    -- correctif de la cause racine du NRE IsGameOver (meme fix que la Grande
    -- Steppe), il n'a rien a voir avec le mini-boss et doit survivre.
    if _ZONE.CurrentZoneID == 'mount_windswept' then
      PrintInfo("[BossSeq][windswept] midpoint(zone) -> seg1 (ContinueDungeon)")
      GAME:ContinueDungeon("mount_windswept", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    else
      PrintInfo("[BossSeq][windswept] midpoint(master) -> seg1 (EnterDungeon)")
      GAME:EnterDungeon("mount_windswept", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    end
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

-- South exit : return to Mount Windswept entrance
function mount_windswept_midpoint.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("mount_windswept")
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Souhaitez-vous redescendre\nà l'entrée de " .. zone:GetColoredName() .. " ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SV.adventure.Thief = false
    --Repli VOLONTAIRE : c'est une sortie a l'amiable. On arme le retour
    --sobre du template pour la prochaine venue au relais, afin que
    --remonter au camp ne soit pas un simple fondu muet.
    SV.Chapter5.WindsweptMidReturn = true
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    GAME:WaitFrames(60)
    GAME:EnterGroundMap("mount_windswept_entrance", "Main_Entrance_Marker")
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

-- Kangaskhan Rock: save + storage
function mount_windswept_midpoint.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function mount_windswept_midpoint.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression.Chapter == 5 then
    mount_windswept_midpoint_ch_5.Partner_Action(chara, activator)
  else
    PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
  end
end

function mount_windswept_midpoint.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression.Chapter == 5 then
    mount_windswept_midpoint_ch_5.Ganlon_Action(chara, activator)
  else
    GeneralFunctions.GroundInteract(activator, chara)
  end
end

function mount_windswept_midpoint.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression.Chapter == 5 then
    mount_windswept_midpoint_ch_5.Shuca_Action(chara, activator)
  else
    GeneralFunctions.GroundInteract(activator, chara)
  end
end

function mount_windswept_midpoint.Wooper_Boy_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  local partner = CH('Teammate1')
  
  GeneralFunctions.StartConversation(chara, "Ah, la montagne...[pause=10] C'est chouette, mais j'ai croisé un drôle de Rondoudou tout en colère un peu plus tôt !", "Worried")
  UI:WaitShowDialogue("Elle hurlait des chansons et m'a bousculé...[pause=10] Qu'est-ce qui a bien pu lui piquer son ballon ?")
  
  if partner ~= nil then
    pcall(function()
      GROUND:CharSetEmote(partner, "sweatdrop", 1)
      GROUND:CharTurnToCharAnimated(partner, CH('PLAYER'), 4)
    end)
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Sigh")
    UI:WaitShowDialogue("(Houla...[pause=15] Un Rondoudou colérique qui hurle des chansons...[pause=10] Je crois qu'il s'agit bien de Plum...)")
  end
  
  GeneralFunctions.EndConversation(chara)
end

return mount_windswept_midpoint
