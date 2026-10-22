--[[ Station de la Foudre Basse — Station-Relais de new_era_zone_05 (add-on).
     Terminal de Sauvegarde (Kangourex) + réserve, patron canonique. ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.RelayScenes'

local new_era_zone_05_relais = {}

function new_era_zone_05_relais.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function new_era_zone_05_relais.Enter(map)
  if SV.Reseau == nil then SV.Reseau = { Veilleurs = {} } end
  if SV.Reseau.StationIntros == nil then SV.Reseau.StationIntros = {} end
  if not SV.Reseau.StationIntros['new_era_zone_05'] then
    SV.Reseau.StationIntros['new_era_zone_05'] = true
    RelayScenes.DuoArrival({
      hero = {236, 368}, partner = {204, 368}, camera = {220, 300},
      walk = 48, title = true, music = 'Rising Fear.ogg',
      lines = {
        { spk='partner', emo='Normal', txt="Tu sens tes poils se dresser ?[pause=0] Tout ce plateau est chargé d'électricité statique...[pause=10] et pourtant,[pause=10] ici,[pause=10] plus rien.", wait=10 },
        { spk='partner', emo='Normal', txt="« Station de la Foudre Basse »...[pause=0] Les anciens relayeurs ont gravé le nom dans le socle du Terminal.[pause=10] Ce poste détournait la foudre pour protéger les convois." },
        { spk='hero', emo='Normal', txt="(Des siècles ont passé,[pause=10] et le paratonnerre fonctionne toujours.[pause=0] Ceux qui ont bâti ce réseau construisaient pour durer.)", wait=10 },
        { spk='partner', emo='Determined', txt="L'Antenne continue de gronder au-dessus de nous.[pause=0] Sauvegardons ici —[pause=10] la haute tour ne pardonne pas les imprudents." },
      },
    })
  else
    GAME:FadeIn(20)
  end
end

function new_era_zone_05_relais.Update(map) end

function new_era_zone_05_relais.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function new_era_zone_05_relais.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  GAME:FadeIn(20)
end

-- Sortie Nord : reprendre l'ascension (segment cime).
function new_era_zone_05_relais.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:ChoiceMenuYesNo("Reprendre l'ascension ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    GAME:FadeOut(false, 60)
    GAME:EnterDungeon("new_era_zone_05", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end

-- Sortie Sud : redescendre (fin de run propre, retour Metano).
function new_era_zone_05_relais.South_Exit_Touch(obj, activator)
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
function new_era_zone_05_relais.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function new_era_zone_05_relais.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return new_era_zone_05_relais
