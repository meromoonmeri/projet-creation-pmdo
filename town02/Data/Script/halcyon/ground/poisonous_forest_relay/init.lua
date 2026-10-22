--[[
    init.lua — poisonous_forest_relay
    Relais mi-donjon (patron searing_tunnel_midpoint) : Statue Kangourex,
    sortie avant vers le segment suivant, sortie arrière vers l'entrée.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.RelayScenes'
require 'halcyon.MidpointTemplate'

local poisonous_forest_relay = {}

--------------------------------------------------------------------
-- HABILLAGE DU POINT MEDIAN — Marais de l'Oubli (408x432)
--
-- STRUCTURE : halcyon.MidpointTemplate, commune a tous les relais.
-- HABILLAGE : propre a ce biome, jamais recopie tel quel ailleurs.
--
--   Biome     : ilot de terre ferme au milieu des eaux stagnantes. Le
--               palier se reconnait au sol qui cesse enfin de ceder.
--   Ambiance  : 'mysterious_distortion' — brume malsaine qui deforme l'air
--               au-dessus de l'eau. Partage le nom du statut avec les
--               Ruines, mais sur une musique et un decor differents :
--               la signature complete (musique + statut) reste unique.
--   Musique   : 'Cave Camp.ogg', deja utilisee par l'arrivee de ce relais.
--
-- Positions reprises de l'arrivee existante (deja verifiees).
--------------------------------------------------------------------
local RELAY_SKIN = {
  music     = 'Cave Camp.ogg',
  wakeMusic = 'Heartwarming.ogg',
  status    = 'mysterious_distortion',
  hero      = {212, 408},
  partner   = {180, 408},
  camera    = {196, 352},
  walk      = 56,
}

function poisonous_forest_relay.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_poisonous_forest_relay <<=')
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function poisonous_forest_relay.Enter(map)
  if SV.Chapter9.MarshMidState == 'DeathArrival' then
    SV.Chapter9.MarshMidState = nil
    poisonous_forest_relay.WipedCutscene()
    return
  end
  if not SV.Chapter9.PlayedMarshRelayIntro then
    SV.Chapter9.PlayedMarshRelayIntro = true
    if SV.ChapterProgression.Chapter == 9 then
      -- Première halte pendant l'expédition du chapitre 9 : arrivée jouée.
      RelayScenes.DuoArrival({
        hero = {212, 408}, partner = {180, 408}, camera = {196, 352},
        walk = 56, title = true, music = 'Cave Camp.ogg',
        lines = {
          { spk='partner', emo='Worried', txt="La brume...[pause=20] elle s'écarte.[pause=0] Depuis les berges,[pause=10] elle nous collait aux épaules,[pause=10] et ici elle n'ose même pas entrer.", wait=10 },
          { spk='partner', emo='Normal', txt="Un îlot de terre ferme,[pause=10] une statue de Kangourex qui émerge des eaux mortes...[pause=0] Même le marais respecte cet endroit." },
          { spk='hero', emo='Worried', txt="(Ces silhouettes encapuchonnées qu'on a aperçues entre les saules...[pause=0] Elles n'étaient pas là par hasard.)", wait=10 },
          { spk='partner', emo='Worried', txt="Tu penses au Cercle,[pause=10] toi aussi ?[pause=0] Ils marchaient dans la vase sans laisser une seule empreinte.[pause=10] Ça me glace." },
          { spk='partner', emo='Determined', txt="Raison de plus pour ne rien laisser au hasard.[pause=0] Sauvegarde,[pause=10] vérifie le sac...[pause=0] Passé cet îlot,[pause=10] les eaux deviennent profondes.[pause=0] Et je ne parle pas que de la vase." },
        },
      })
    else
      -- Visite libre : le marais est presque paisible.
      RelayScenes.DuoArrival({
        hero = {212, 408}, partner = {180, 408}, camera = {196, 352},
        walk = 56, title = true, music = 'Cave Camp.ogg',
        lines = {
          { spk='partner', emo='Normal', txt="L'îlot du relais...[pause=0] La brume s'écarte toujours autour de la statue,[pause=10] comme au premier jour." },
          { spk='partner', emo='Normal', txt="Le marais retient son souffle.[pause=0] Profitons de cette accalmie pour nous préparer." },
        },
      })
    end
  elseif SV.Chapter9.MarshMidReturn then
    --ETAT « RepeatArrival » DU TEMPLATE — retour a l'amiable
    --(repli volontaire, ou reprise d'une sauvegarde faite ici).
    --Ce relais ne connaissait que l'arrivee et le reveil apres KO :
    --revenir sur ses pas ne donnait qu'un fondu muet.
    SV.Chapter9.MarshMidReturn = false
    local partner = CH('Teammate1')
    MidpointTemplate.RepeatArrival({
      skin = RELAY_SKIN,
      lines = {
        { who = partner, spk = 'partner', emo = 'Normal',
          txt = "Terre ferme.[pause=0] Après des heures dans la vase,[pause=10] ça n'a pas de prix.", wait = 10 },
        { who = partner, spk = 'partner', emo = 'Normal',
          txt = "Le rocher tient bon sur cet îlot.[pause=0] Reprenons des forces avant de replonger." },
      },
    })
  else
    GAME:FadeIn(20)
  end
end

function poisonous_forest_relay.Update(map, time) end

function poisonous_forest_relay.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

-- Reprise d'une sauvegarde faite AU relais : sortie a l'amiable.
-- On arme le retour sobre du template plutot qu'un fondu muet.
function poisonous_forest_relay.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  if SV.Chapter9.PlayedMarshRelayIntro and SV.Chapter9.MarshMidState ~= 'DeathArrival' then
    SV.Chapter9.MarshMidReturn = true
  end
  poisonous_forest_relay.Enter(map)
end

function poisonous_forest_relay.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Souhaitez-vous continuer ?", true)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  UI:SetCenter(false)
  if res then
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    GAME:EnterDungeon("poisonous_forest", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

function poisonous_forest_relay.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("poisonous_forest")
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Souhaitez-vous revenir\nà l'entrée de " .. zone:GetColoredName() .. " ?", true)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  UI:SetCenter(false)
  if res then
    SV.adventure.Thief = false
    --Repli VOLONTAIRE : sortie a l'amiable, on arme le retour sobre
    --du template pour la prochaine venue au relais.
    SV.Chapter9.MarshMidReturn = true
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    GAME:WaitFrames(60)
    GAME:EnterGroundMap("poisonous_forest_entrance", "Main_Entrance_Marker")
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

function poisonous_forest_relay.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function poisonous_forest_relay.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function poisonous_forest_relay.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.GroundInteract(activator, chara)
end

function poisonous_forest_relay.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.GroundInteract(activator, chara)
end



--------------------------------------------------------------------
-- Réveil après une défaite au-delà du checkpoint (vague 8).
-- Le duo revient à lui près du Terminal, ranimé par ses réserves.
--------------------------------------------------------------------
function poisonous_forest_relay.WipedCutscene()

	--LE NOIR AVANT TOUTE MISE EN PLACE (correctif de retour de boss,
	--2026-07-30). Cette scene est jouee juste apres un EndSegment /
	--EnterZone : le moteur a pose le noir, mais rien ne le REPOSE ici.
	--Elle enchaine pourtant plusieurs appels moteur (creation de PNJ,
	--TeleportTo, MoveCamera, StopBGM) avant son FadeIn. GAME:FadeOut
	--etant bloquant (ScriptGame.cs:1590) et FadeInternal rendant la
	--main a chaque frame (FadeEffect.cs:30-42), ces appels laissent
	--passer des frames RENDUES sur une carte en cours de montage —
	--c'est l'apercu de zone signale en jeu. FadeOut(false,1) sur un
	--ecran deja noir est un no-op (FadeEffect.cs:63) : gratuit si le
	--noir a tenu, salvateur sinon.
	pcall(function() GAME:FadeOut(false, 1) end)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  if partner ~= nil then AI:DisableCharacterAI(partner) end

    -- Fix audit 2026-07-27 : l'ancienne position du partenaire chevauchait le
  -- collider du rocher Kangourex. Positions libres verifiees (flood-check).
  GROUND:TeleportTo(hero, 136, 224, Direction.Left)
  if partner ~= nil then GROUND:TeleportTo(partner, 168, 224, Direction.Right) end
  GROUND:CharSetAnim(hero, "EventSleep", true)
  if partner ~= nil then GROUND:CharSetAnim(partner, "EventSleep", true) end
  GAME:MoveCamera(152, 216, 1, false)

  GAME:FadeIn(60)
  SOUND:PlayBGM('Heartwarming.ogg', true)
  GAME:WaitFrames(110)

  local coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.DoAnimation(hero, 'Wake')
    GAME:WaitFrames(12)
    GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(14)
    if partner ~= nil then
      GeneralFunctions.DoAnimation(partner, 'Wake')
      GAME:WaitFrames(12)
      GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
    end end)
  TASK:JoinCoroutines({coro1, coro2})
  GAME:WaitFrames(30)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Pain")
  UI:WaitShowDialogue("Pouah...[pause=10] j'ai de la vase JUSQUE dans les oreilles.")
  GAME:WaitFrames(14)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue("Le marais nous a recrachés près du rocher.[pause=20] Comme si quelque chose, sous l'eau, avait décidé qu'on méritait une seconde chance.")
  GAME:WaitFrames(14)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue("On ne la gâchera pas.[pause=20] Cette fois, on teste CHAQUE flaque avant d'y mettre une patte.")
  GAME:WaitFrames(14)
  GAME:WaitFrames(20)
  if partner ~= nil then
    AI:EnableCharacterAI(partner)
    AI:SetCharacterAI(partner, 'origin.ai.ground_partner', hero, partner.Position)
    PartnerEssentials.SaveGamePartnerPosition(partner)
  end
  GAME:CutsceneMode(false)
  GAME:FadeIn(1)
end

return poisonous_forest_relay
