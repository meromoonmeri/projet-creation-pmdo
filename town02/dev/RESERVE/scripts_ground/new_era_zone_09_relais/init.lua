--[[ Station du Manteau Ardent — Station-Relais de new_era_zone_09 (add-on).
     Terminal de Sauvegarde (Kangourex) + réserve, patron canonique. ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.RelayScenes'

local new_era_zone_09_relais = {}

function new_era_zone_09_relais.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function new_era_zone_09_relais.Enter(map)
  if SV.Reseau == nil then SV.Reseau = { Veilleurs = {} } end
  if SV.Reseau.StationIntros == nil then SV.Reseau.StationIntros = {} end
  if not SV.Reseau.StationIntros['new_era_zone_09'] then
    SV.Reseau.StationIntros['new_era_zone_09'] = true
    RelayScenes.DuoArrival({
      hero = {236, 368}, partner = {204, 368}, camera = {220, 300},
      walk = 48, title = true, music = 'Deep Dark Crater.ogg',
      lines = {
        { spk='partner', emo='Pain', txt="Pfouh...[pause=20] On respire enfin.[pause=0] La roche était BRÛLANTE sur les derniers paliers,[pause=10] même à travers mes coussinets.", wait=10 },
        { spk='partner', emo='Normal', txt="Regarde ces conduits dans les murs :[pause=10] ils aspirent l'air chaud et le rejettent plus haut.[pause=0] Une station de refroidissement,[pause=10] en plein cœur du volcan..." },
        { spk='hero', emo='Worried', txt="(Le Manteau Ardent.[pause=0] Ce nom n'est pas une image :[pause=10] la montagne entière est une chaudière,[pause=10] et nous marchons dans sa cheminée.)", wait=10 },
        { spk='partner', emo='Determined', txt="Le Terminal est encore tiède,[pause=10] comme si quelqu'un venait de partir.[pause=0] Buvons,[pause=10] sauvegardons,[pause=10] et attaquons la fournaise du haut." },
      },
    })
  else
    GAME:FadeIn(20)
  end
end

function new_era_zone_09_relais.Update(map) end

function new_era_zone_09_relais.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function new_era_zone_09_relais.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  GAME:FadeIn(20)
end

-- Sortie Nord : reprendre l'ascension (segment cime).
function new_era_zone_09_relais.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:ChoiceMenuYesNo("Reprendre l'ascension ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    GAME:FadeOut(false, 60)
    GAME:EnterDungeon("new_era_zone_09", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end

-- Sortie Sud : redescendre (fin de run propre, retour Metano).
function new_era_zone_09_relais.South_Exit_Touch(obj, activator)
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
function new_era_zone_09_relais.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function new_era_zone_09_relais.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return new_era_zone_09_relais
