--[[ Station de Contrôle du Noyau — Station-Relais de new_era_zone_15 (add-on).
     Terminal de Sauvegarde (Kangourex) + réserve, patron canonique. ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.RelayScenes'

local new_era_zone_15_relais = {}

function new_era_zone_15_relais.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function new_era_zone_15_relais.Enter(map)
  if SV.Reseau == nil then SV.Reseau = { Veilleurs = {} } end
  if SV.Reseau.StationIntros == nil then SV.Reseau.StationIntros = {} end
  if not SV.Reseau.StationIntros['new_era_zone_15'] then
    SV.Reseau.StationIntros['new_era_zone_15'] = true
    RelayScenes.DuoArrival({
      hero = {236, 368}, partner = {204, 368}, camera = {220, 300},
      walk = 48, title = true, music = 'Deep Dark Crater.ogg',
      lines = {
        { spk='partner', emo='Normal', txt="Alors c'est elle...[pause=20] la Station de Contrôle du Noyau.[pause=0] La salle dont parlent tous les registres du Réseau.", wait=10 },
        { spk='partner', emo='Normal', txt="D'ici,[pause=10] les anciens relayeurs surveillaient la Fournaise-Mère elle-même.[pause=0] Ces cadrans fondus,[pause=10] ces leviers figés...[pause=10] Ils sont restés à leur poste jusqu'au bout." },
        { spk='hero', emo='Worried', txt="(Sous nos pieds,[pause=10] la Fosse.[pause=0] Le magma y coule depuis toujours,[pause=10] indifférent à ceux qui l'observent.)", wait=10 },
        { spk='partner', emo='Worried', txt="Le sol vibre...[pause=0] Tu le sens ?[pause=10] Un battement lent,[pause=10] régulier.[pause=0] Comme un cœur." },
        { spk='partner', emo='Determined', txt="Sauvegarde.[pause=0] Vérifie tout,[pause=10] deux fois.[pause=0] Ce qui vit en bas n'a jamais laissé personne redescendre à moitié préparé." },
      },
    })
  else
    GAME:FadeIn(20)
  end
end

function new_era_zone_15_relais.Update(map) end

function new_era_zone_15_relais.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function new_era_zone_15_relais.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  GAME:FadeIn(20)
end

-- Sortie Nord : reprendre l'ascension (segment cime).
function new_era_zone_15_relais.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:ChoiceMenuYesNo("Reprendre l'ascension ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    GAME:FadeOut(false, 60)
    GAME:EnterDungeon("new_era_zone_15", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end

-- Sortie Sud : redescendre (fin de run propre, retour Metano).
function new_era_zone_15_relais.South_Exit_Touch(obj, activator)
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
function new_era_zone_15_relais.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function new_era_zone_15_relais.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return new_era_zone_15_relais
