--[[ Station du Dernier Palier — Station-Relais de new_era_zone_17 (add-on).
     Terminal de Sauvegarde (Kangourex) + réserve, patron canonique. ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.RelayScenes'

local new_era_zone_17_relais = {}

function new_era_zone_17_relais.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function new_era_zone_17_relais.Enter(map)
  if SV.Reseau == nil then SV.Reseau = { Veilleurs = {} } end
  if SV.Reseau.StationIntros == nil then SV.Reseau.StationIntros = {} end
  if not SV.Reseau.StationIntros['new_era_zone_17'] then
    SV.Reseau.StationIntros['new_era_zone_17'] = true
    RelayScenes.DuoArrival({
      hero = {236, 368}, partner = {204, 368}, camera = {220, 300},
      walk = 48, title = true, music = 'Sky Tower.ogg',
      lines = {
        { spk='partner', emo='Normal', txt="On marche sur les nuages...[pause=20] littéralement.[pause=0] La passerelle flotte,[pause=10] et pourtant elle ne cède pas d'un pouce.", wait=10 },
        { spk='partner', emo='Normal', txt="« Station du Dernier Palier ».[pause=0] Après elle,[pause=10] plus aucun relais,[pause=10] plus aucun secours.[pause=0] Seulement la Tour,[pause=10] et ce qui veille à son sommet." },
        { spk='hero', emo='Normal', txt="(Le vent porte un chant très ancien.[pause=0] Ni menaçant,[pause=10] ni accueillant.[pause=10] Il attend.)", wait=10 },
        { spk='partner', emo='Determined', txt="C'est le bout du Réseau,[pause=10] et peut-être le bout du ciel.[pause=0] Grave bien ce moment,[pause=10] sauvegarde...[pause=10] et allons voir ce qui nous attend tout là-haut." },
      },
    })
  else
    GAME:FadeIn(20)
  end
end

function new_era_zone_17_relais.Update(map) end

function new_era_zone_17_relais.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function new_era_zone_17_relais.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  GAME:FadeIn(20)
end

-- Sortie Nord : reprendre l'ascension (segment cime).
function new_era_zone_17_relais.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:ChoiceMenuYesNo("Reprendre l'ascension ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    GAME:FadeOut(false, 60)
    GAME:EnterDungeon("new_era_zone_17", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end

-- Sortie Sud : redescendre (fin de run propre, retour Metano).
function new_era_zone_17_relais.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:ChoiceMenuYesNo("Redescendre et rentrer ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SV.adventure.Thief = false
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, "master_zone", -1, 1, 0, true, true)
  end
end

-- Terminal de Sauvegarde (statue Kangourex) : sauvegarde + réserve natives.
function new_era_zone_17_relais.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function new_era_zone_17_relais.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return new_era_zone_17_relais
