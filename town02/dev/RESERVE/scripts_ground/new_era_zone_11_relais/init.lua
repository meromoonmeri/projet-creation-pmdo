--[[ Station du Point de Rosée — Station-Relais de new_era_zone_11 (add-on).
     Terminal de Sauvegarde (Kangourex) + réserve, patron canonique. ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.RelayScenes'

local new_era_zone_11_relais = {}

function new_era_zone_11_relais.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function new_era_zone_11_relais.Enter(map)
  if SV.Reseau == nil then SV.Reseau = { Veilleurs = {} } end
  if SV.Reseau.StationIntros == nil then SV.Reseau.StationIntros = {} end
  if not SV.Reseau.StationIntros['new_era_zone_11'] then
    SV.Reseau.StationIntros['new_era_zone_11'] = true
    RelayScenes.DuoArrival({
      hero = {236, 368}, partner = {204, 368}, camera = {220, 300},
      walk = 48, title = true, music = 'Snow Camp.ogg',
      lines = {
        { spk='partner', emo='Normal', txt="Oh...[pause=20] Il neige à peine, ici.[pause=0] Les flocons restent suspendus,[pause=10] comme s'ils hésitaient à toucher le sol.", wait=10 },
        { spk='partner', emo='Normal', txt="« Point de Rosée ».[pause=0] C'est l'endroit exact où le froid de la forêt bascule en givre éternel.[pause=10] Les relayeurs mesuraient ça,[pause=10] jadis,[pause=10] avec ces aiguilles de cuivre plantées dans la souche." },
        { spk='hero', emo='Normal', txt="(Tout est si silencieux.[pause=0] Même nos pas semblent gelés avant de faire du bruit.)", wait=10 },
        { spk='partner', emo='Worried', txt="Passé cette clairière,[pause=10] les arbres sont pris dans la glace jusqu'aux racines.[pause=0] Couvre-toi bien...[pause=10] et sauvegardons tant que nos pattes répondent encore." },
      },
    })
  else
    GAME:FadeIn(20)
  end
end

function new_era_zone_11_relais.Update(map) end

function new_era_zone_11_relais.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function new_era_zone_11_relais.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  GAME:FadeIn(20)
end

-- Sortie Nord : reprendre l'ascension (segment cime).
function new_era_zone_11_relais.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:ChoiceMenuYesNo("Reprendre l'ascension ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    GAME:FadeOut(false, 60)
    GAME:EnterDungeon("new_era_zone_11", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end

-- Sortie Sud : redescendre (fin de run propre, retour Metano).
function new_era_zone_11_relais.South_Exit_Touch(obj, activator)
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
function new_era_zone_11_relais.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function new_era_zone_11_relais.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return new_era_zone_11_relais
