--[[ Station du Grand Blanc — Station-Relais de new_era_zone_13 (add-on).
     Terminal de Sauvegarde (Kangourex) + réserve, patron canonique. ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.RelayScenes'

local new_era_zone_13_relais = {}

function new_era_zone_13_relais.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function new_era_zone_13_relais.Enter(map)
  if SV.Reseau == nil then SV.Reseau = { Veilleurs = {} } end
  if SV.Reseau.StationIntros == nil then SV.Reseau.StationIntros = {} end
  if not SV.Reseau.StationIntros['new_era_zone_13'] then
    SV.Reseau.StationIntros['new_era_zone_13'] = true
    RelayScenes.DuoArrival({
      hero = {236, 368}, partner = {204, 368}, camera = {220, 300},
      walk = 48, title = true, music = 'Snow Camp.ogg',
      lines = {
        { spk='partner', emo='Worried', txt="Je ne vois plus le sommet...[pause=0] ni le pied de la montagne.[pause=10] Juste du blanc,[pause=10] partout.[pause=0] Comme si le monde s'arrêtait à dix pas.", wait=10 },
        { spk='partner', emo='Normal', txt="Cette cabane de pierre a résisté à des siècles de blizzard.[pause=0] « Station du Grand Blanc »...[pause=10] le dernier abri avant l'Aiguille." },
        { spk='hero', emo='Worried', txt="(Le froid,[pause=10] ici,[pause=10] n'est pas une température.[pause=0] C'est une présence.[pause=10] Et elle nous jauge.)", wait=10 },
        { spk='partner', emo='Determined', txt="Serre les dents.[pause=0] On dépose au Terminal ce qu'on ne peut pas se permettre de perdre,[pause=10] et on monte.[pause=0] Ensemble,[pause=10] comme toujours." },
      },
    })
  else
    GAME:FadeIn(20)
  end
end

function new_era_zone_13_relais.Update(map) end

function new_era_zone_13_relais.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function new_era_zone_13_relais.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  GAME:FadeIn(20)
end

-- Sortie Nord : reprendre l'ascension (segment cime).
function new_era_zone_13_relais.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:ChoiceMenuYesNo("Reprendre l'ascension ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    GAME:FadeOut(false, 60)
    GAME:EnterDungeon("new_era_zone_13", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end

-- Sortie Sud : redescendre (fin de run propre, retour Metano).
function new_era_zone_13_relais.South_Exit_Touch(obj, activator)
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
function new_era_zone_13_relais.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function new_era_zone_13_relais.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return new_era_zone_13_relais
