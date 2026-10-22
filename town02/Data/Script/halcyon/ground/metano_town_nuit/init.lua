--[[
    metano_town_nuit/init.lua
    BOURG METANO — NUIT

    ================================================================
    METHODE : celle d'EoSO, verifiee dans son depot
    ================================================================
    EoSO ne pose pas un filtre sombre sur la carte de jour : il a de
    VRAIES cartes separees. Verifie dans ExplorersOfSkyOrigins :

        guild_outside.rsground        -> tileset GuildOutside
        guild_outside_dusk.rsground   -> tileset GuildOutsideDusk
        guild_outside_night.rsground  -> GuildOutsideNight + ...NightGate

    Meme geometrie (480x408 pour les trois), AssetName distinct,
    tilesets differents. Et leurs scripts de nuit sont quasi VIDES :
    tout le travail est dans la carte.

    Ici : metano_town_nuit.rsground est un clone au pixel pres de
    metano_town (1512x1512, obstacles identiques verifies), dont les
    14 feuilles de tuiles pointent vers les versions _Night generees
    par tools/tile_night.py.

    ================================================================
    CE QUE CE SCRIPT FAIT, LUI
    ================================================================
    La carte apporte le decor. Le script apporte la VIE :

      * les 12 commercants de jour sont retires — ils sont rentres ;
      * les portes de commerce refusent l'entree avec une replique,
        jamais avec un mur invisible : on ne bloque pas le joueur
        sans le lui dire ;
      * les PNJ nocturnes apparaissent (module TownNight).

    Le joueur SE DEPLACE LIBREMENT. Preuve dans le projet :
    ledian_dojo/init.lua:35 pose GROUND:AddMapStatus("darkness") dans
    Init et le joueur y circule sans CutsceneMode.

    ================================================================
    REGLES DU PROJET
    ================================================================
    * Textes en francais, litteraux (patron des modules globaux).
    * Aucun nom interdit, la Voix ne parle pas en ville.
    * Tout sous pcall : une carte d'exploration ne doit jamais pouvoir
      pieger le joueur.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.TownNight'
require 'halcyon.SideQuests'
require 'halcyon.TownNightScenes'
require 'halcyon.TownRaid'

local metano_town_nuit = {}

--Les 12 commercants presents sur la carte de jour, herites par le clone.
--La nuit, ils sont chez eux : on les retire de la carte.
local MARCHANDS = {
  'Shop_Owner', 'Bank_Owner', 'Storage_Owner', 'Musician', 'Swap_Owner',
  'Red_Merchant', 'Green_Merchant', 'Appraisal', 'Tutor_Owner',
  'Growlithe', 'TM_Owner', 'Legend_Merchant',
}

function metano_town_nuit.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo('=>> Init_metano_town_nuit <<=')
  COMMON.RespawnAllies()
  PartnerEssentials.InitializePartnerSpawn()

  --La ville dort : personne derriere les comptoirs.
  for _, n in ipairs(MARCHANDS) do
    pcall(function() GROUND:Hide(n) end)
  end

  if SV.ChapterProgression.Chapter < 6 then
    pcall(function() GROUND:Hide('Legend_Stand') end)
  else
    pcall(function() GROUND:Unhide('Legend_Stand') end)
  end

  --Les habitants de la nuit prennent la place.
  pcall(function() TownNight.Populate() end)
end

function metano_town_nuit.Enter(map)
  DEBUG.EnableDbgCoro()

  --------------------------------------------------------------------
  -- CHAPITRE 11 — la fuite (correctif 2026-08-02)
  --
  -- Scene 10a : la traversee de la ville sous l'averse, de la guilde a
  -- la sortie sud. Elle passe AVANT tout le reste — ni arrivee nocturne
  -- ordinaire, ni tirage de raid : cette nuit-la, la ville n'est pas
  -- endormie, elle est hostile.
  --
  -- Le FadeIn habituel est retire de ce chemin : Scene10a_Ville pose sa
  -- propre meteo et sa propre musique, et un FadeIn premature ferait
  -- voir la carte nue avant la mise en place.
  --------------------------------------------------------------------
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 11 then
    local a = SV.AccusationArc
    if a ~= nil and a.PartnerChose and a.Scene == 9 then
      require 'halcyon.AccusationArc'
      AccusationArc.Play(AccusationArc.Scene10a_Ville, 'Scene10a_Ville')
      --Le trajet s'acheve a la sortie sud : on enchaine sur la halte du
      --carrefour, ou se joue la derniere parole (scene 10b).
      pcall(function()
        GAME:FadeOut(false, 45)
        GAME:WaitFrames(30)
        GAME:EnterGroundMap("carrefour_nord", "Main_Entrance_Marker")
      end)
      return
    end
  end

  GAME:FadeIn(30)

  --RETOUR DE COMBAT. Si on revient d'une arene de raid, on ne rejoue pas
  --l'arrivee : on enchaine sur la consequence. SV.TownRaid.Pending est
  --pose par TownRaid.Begin() et retombe a false dans Victory/Defeat.
  local s = TownRaid.Ensure()
  if s.Pending then
    pcall(function() TownRaid.Victory() end)
    return
  end

  pcall(function() TownNight.Arrival() end)

  --LA VILLE EST ATTAQUEE. Le tirage a lieu APRES l'arrivee : le joueur a
  --le temps de voir la ville endormie avant qu'elle ne bascule.
  if TownRaid.ShouldTrigger() then
    pcall(function() TownRaid.Begin() end)
  end
end

function metano_town_nuit.Exit(map) end
function metano_town_nuit.Update(map, time) end

function metano_town_nuit.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function metano_town_nuit.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  GAME:FadeIn(20)
end

--------------------------------------------------------------------
-- COMMERCES FERMES
--------------------------------------------------------------------
-- On ne bloque jamais le joueur en silence : chaque porte close a sa
-- phrase. C'est aussi une occasion de dire quelque chose de la ville.
local function ferme(txt)
  pcall(function()
    UI:ResetSpeaker(false)
    UI:SetCenter(true)
    UI:WaitShowDialogue(txt)
    UI:SetCenter(false)
    UI:ResetSpeaker()
  end)
end

function metano_town_nuit.Shop_Action(obj, activator)
  ferme("Le rideau est tire.[pause=20] Une pancarte : « De retour a l'aube. »")
end

function metano_town_nuit.Bank_Action(obj, activator)
  ferme("Le coffre est ferme pour la nuit.[pause=20] Vos economies dorment aussi.")
end

function metano_town_nuit.Storage_Action(obj, activator)
  ferme("L'entrepot est cadenasse.[pause=25] Quelqu'un a laisse une lanterne allumee au-dessus de la porte.")
end

function metano_town_nuit.Swap_Action(obj, activator)
  ferme("Ferme.[pause=20] Sur le comptoir, un objet oublie que personne n'est venu reclamer.")
end

function metano_town_nuit.TM_Action(obj, activator)
  ferme("Ferme.[pause=20] On entend ronfler a l'interieur.")
end

function metano_town_nuit.Tutor_Action(obj, activator)
  ferme("Le maitre dort.[pause=25] Meme les lecons ont besoin de repos.")
end

function metano_town_nuit.Appraisal_Action(obj, activator)
  ferme("Ferme.[pause=20] Les tresors attendront demain pour reveler leur nom.")
end

--Sortie de la nuit : on revient a la carte de jour, un jour plus tard.
function metano_town_nuit.Guild_Entrance_Touch(obj, activator)
  pcall(function() TownNight.GoHome() end)
end

--------------------------------------------------------------------
-- PORTES DES HABITATIONS
--------------------------------------------------------------------
-- La carte de nuit est un clone au pixel pres de metano_town : elle
-- herite donc de TOUS ses objets (43 GroundObjects verifies dans le
-- .rsground). Chaque objet dont le script n'expose pas le handler
-- correspondant est un objet MUET : le joueur le touche, rien ne se
-- passe, aucun retour. C'est exactement le genre de vide qui casse
-- l'illusion. On repond donc a chacun.
--
-- Les habitations sont fermees, mais jamais en silence : chaque porte
-- dit quelque chose de ceux qui dorment derriere.
local function porte(txt)
  ferme(txt)
end

function metano_town_nuit.Fire_Home_Entrance_Touch(obj, activator)
  porte("La porte est close.[pause=20] Par la fenêtre, une braise rougeoie encore dans l'âtre.")
end

function metano_town_nuit.Water_Home_Entrance_Touch(obj, activator)
  porte("Personne ne répond.[pause=25] On entend juste couler quelque chose, doucement, à l'intérieur.")
end

function metano_town_nuit.Grass_Home_Entrance_Touch(obj, activator)
  porte("Fermé.[pause=20] Les pots devant la porte ont été rentrés pour la nuit.")
end

function metano_town_nuit.Electric_Home_Entrance_Touch(obj, activator)
  porte("La porte vibre légèrement.[pause=25] Quelqu'un, là-dedans, ne dort pas non plus.")
end

function metano_town_nuit.Rock_Home_Entrance_Touch(obj, activator)
  porte("Le volet de pierre est baissé.[pause=20] Il ne se rouvrira pas avant l'aube.")
end

function metano_town_nuit.Normal_Home_Entrance_Touch(obj, activator)
  porte("Fermé.[pause=20] Une paire de chaussures a été laissée dehors, bien alignée.")
end

function metano_town_nuit.Cave_Entrance_Touch(obj, activator)
  porte("L'entrée de la grotte est noire.[pause=25] Y descendre maintenant serait déraisonnable.")
end

function metano_town_nuit.Dojo_Entrance_Touch(obj, activator)
  porte("Le dojo est éteint.[pause=25] Sur la porte, un mot : « L'entraînement reprend au lever du jour. »")
end

function metano_town_nuit.Post_Office_Entrance_Touch(obj, activator)
  porte("Fermé.[pause=20] Des lettres attendent dans la boîte, patiemment.")
end

function metano_town_nuit.Inn_Entrance_Touch(obj, activator)
  porte("L'auberge est pleine.[pause=25] Vous avez déjà un lit qui vous attend, de toute façon.")
end

function metano_town_nuit.Cafe_Entrance_Touch(obj, activator)
  porte("Les chaises sont retournées sur les tables.[pause=25] L'odeur de café, elle, reste.")
end

--------------------------------------------------------------------
-- SORTIES DE LA VILLE
--------------------------------------------------------------------
-- On ne part PAS en donjon la nuit : ce serait contredire le choix de
-- fin de journee, qui vient justement de refermer la journee. Mais on
-- ne bloque pas non plus en silence — le partenaire donne la raison,
-- ce qui vaut mieux qu'un mur.
local function trop_tard(txt)
  local partner = CH('Teammate1')
  if partner == nil then
    ferme(txt)
    return
  end
  pcall(function()
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion('Normal')
    UI:WaitShowDialogue(txt)
    UI:ResetSpeaker()
  end)
end

function metano_town_nuit.North_Exit_Touch(obj, activator)
  trop_tard("Pas maintenant.[pause=25] On ne part pas explorer à cette heure-ci.")
end

function metano_town_nuit.East_Exit_Touch(obj, activator)
  trop_tard("Les routes sont noires.[pause=25] On repartira demain, la tête claire.")
end

function metano_town_nuit.South_Exit_Touch(obj, activator)
  trop_tard("Restons dans la ville ce soir.[pause=25] Juste ce soir.")
end

--------------------------------------------------------------------
-- MOBILIER ET PANNEAUX
--------------------------------------------------------------------
function metano_town_nuit.Crossroads_Sign_Action(obj, activator)
  ferme("Le panneau est illisible dans le noir.[pause=25] De toute façon, vous connaissez le chemin.")
end

function metano_town_nuit.Dojo_Sign_Action(obj, activator)
  ferme("« Dojo » —[pause=20] les lettres luisent faiblement sous la lune.")
end

function metano_town_nuit.Wishing_Well_Sign_Action(obj, activator)
  ferme("« Faites un vœu. »[pause=25] La nuit, ça se lit autrement.")
end

function metano_town_nuit.Guild_Bridge_Sign_Action(obj, activator)
  ferme("Le pont de la guilde.[pause=25] Les planches craquent plus fort quand tout se tait.")
end

function metano_town_nuit.To_Dungeons_Sign_Action(obj, activator)
  ferme("La flèche pointe vers le noir.[pause=25] Demain.")
end

function metano_town_nuit.To_Spring_Sign_Action(obj, activator)
  ferme("La source, par là.[pause=25] On entend l'eau d'ici.")
end

function metano_town_nuit.Well_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  local s = TownNight.Ensure()

  --LA VOIX AU PUITS. C'est le seul endroit de Metano ou l'on se penche
  --vers le bas et ou l'on voit sa propre image ; la nuit, l'eau noire
  --renvoie aussi le ciel. La Voix ne parle pas en ville de JOUR — la
  --nuit, la ville est vide et le heros est seul, ce qui est la condition
  --meme du dispositif. Une seule fois par chapitre, a partir du ch7.
  --Si elle s'est exprimee, on ne propose pas la piece dans la foulee :
  --on ne jette pas un voeu juste apres ca.
  if TownNightScenes.WellVoice() then return end

  pcall(function()
    UI:ResetSpeaker(false)
    UI:SetCenter(true)
    UI:ChoiceMenuYesNo("Le puits est là, dans le noir.[pause=20] Y jeter une pièce ?", true)
    UI:WaitForChoice()
    local yes = UI:ChoiceResult()
    if yes then
      if GAME:GetPlayerMoney() < 1 then
        UI:WaitShowDialogue("Vos poches sont vides.[pause=25] Le vœu attendra.")
      else
        GAME:RemoveFromPlayerMoney(1)
        SOUND:PlayBattleSE("_UNK_DUN_Water_Drop")
        --La nuit, le puits ne renvoie pas la meme chose que le jour.
        if s.SawStars then
          UI:WaitShowDialogue("La pièce tombe longtemps.[pause=30] Dans l'eau noire, le ciel se reflète.")
          UI:WaitShowDialogue("Il y manque une étoile, là aussi.")
        else
          UI:WaitShowDialogue("La pièce tombe longtemps.[pause=30] Bien plus longtemps que le jour, on dirait.")
        end
      end
    end
    UI:SetCenter(false)
    UI:ResetSpeaker()
  end)
end

function metano_town_nuit.Postboard_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  --Le tableau des requetes reste consultable : le joueur doit toujours
  --pouvoir savoir ce qui lui manque, y compris a trois heures du matin.
  local ch = (SV.ChapterProgression and SV.ChapterProgression.Chapter) or 0
  if not pcall(function() SideQuests.Board(ch) end) then
    ferme("Le tableau est dans l'ombre.[pause=25] Impossible d'y lire quoi que ce soit.")
  end
end

function metano_town_nuit.Assembly_Action(obj, activator)
  ferme("La cloche de l'assemblée.[pause=25] La sonner maintenant réveillerait toute la ville.")
end

function metano_town_nuit.Legend_Stand_Action(obj, activator)
  ferme("L'étal est bâché.[pause=25] Ce qu'il vend ne se montre pas la nuit.")
end

function metano_town_nuit.Growlithe_Desk_Action(obj, activator)
  ferme("Le bureau est vide.[pause=25] Un registre reste ouvert, la plume posée en travers.")
end

--------------------------------------------------------------------
-- FILET DE SECURITE : LES MARCHANDS MASQUES
--------------------------------------------------------------------
-- Init appelle GROUND:Hide sur les 12 commercants herites de la carte
-- de jour. Je n'ai PAS de preuve dans ce depot que Hide desactive
-- aussi l'interaction — seulement qu'il rend invisible. Si le moteur
-- laisse malgre tout le declencheur actif, un joueur pourrait ouvrir
-- une boutique tenue par un vendeur invisible. Ces handlers rendent
-- ce cas inoffensif au lieu de parier dessus.
local function absent(txt)
  ferme(txt)
end

function metano_town_nuit.Shop_Owner_Action(c, a)      absent("Il n'y a personne derrière le comptoir.") end
function metano_town_nuit.Bank_Owner_Action(c, a)      absent("Le guichet est vide.[pause=20] Le registre a été rangé.") end
function metano_town_nuit.Storage_Owner_Action(c, a)   absent("Personne.[pause=20] L'entrepôt est verrouillé jusqu'à l'aube.") end
function metano_town_nuit.Musician_Action(c, a)        absent("L'estrade est vide.[pause=25] L'instrument est resté là, sous une bâche.") end
function metano_town_nuit.Swap_Owner_Action(c, a)      absent("Personne au comptoir des échanges.") end
function metano_town_nuit.Red_Merchant_Action(c, a)    absent("L'étal est plié.[pause=20] Il ne reste qu'une caisse vide.") end
function metano_town_nuit.Green_Merchant_Action(c, a)  absent("L'étal est plié pour la nuit.") end
function metano_town_nuit.Tutor_Owner_Action(c, a)     absent("Le maître n'est pas là.[pause=25] Les leçons attendront demain.") end
function metano_town_nuit.TM_Owner_Action(c, a)        absent("Personne.[pause=20] Les disques sont sous clé.") end
function metano_town_nuit.Growlithe_Action(c, a)       absent("La ronde est passée il y a peu.[pause=25] Le poste est désert.") end
function metano_town_nuit.Legend_Merchant_Action(c, a) absent("L'étal est bâché.[pause=25] Son propriétaire ne travaille pas de nuit.") end

--------------------------------------------------------------------
-- ZONES DE LIEU
--------------------------------------------------------------------
-- Ces 30 declencheurs (triggerType 3) ne font que memoriser ou se
-- trouve le joueur : PartnerEssentials s'en sert pour choisir les
-- repliques du partenaire (verifie, PartnerEssentials.lua:565, 913,
-- 1178). Sans eux, la valeur resterait figee sur le dernier lieu de
-- la carte de jour et le partenaire parlerait du mauvais endroit.
local function lieu(nom)
  DEBUG.EnableDbgCoro()
  if SV.metano_town ~= nil then SV.metano_town.Locale = nom end
end

function metano_town_nuit.Cafe_Locale_Touch(c, a)          lieu('Cafe') end
function metano_town_nuit.Exploration_Locale_Touch(c, a)   lieu('Exploration') end
function metano_town_nuit.Cave_Locale_Touch(c, a)          lieu('Cave') end
function metano_town_nuit.South_Houses_Locale_Touch(c, a)  lieu('South Houses') end
function metano_town_nuit.North_Houses_Locale_Touch(c, a)  lieu('North Houses') end
function metano_town_nuit.Merchants_Locale_Touch(c, a)     lieu('Merchants') end
function metano_town_nuit.Guild_Locale_Touch(c, a)         lieu('Guild') end
function metano_town_nuit.Market_Locale_Touch(c, a)        lieu('Market') end
function metano_town_nuit.Well_Locale_Touch(c, a)          lieu('Well') end
function metano_town_nuit.Post_Locale_Touch(c, a)          lieu('Post') end
function metano_town_nuit.Dojo_Locale_Touch(c, a)          lieu('Dojo') end

--Dialogue du partenaire, qui a lui aussi ses phrases nocturnes.
function metano_town_nuit.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if TownNight.PartnerTalk() then return end
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

--Handlers des PNJ nocturnes : delegues au module.
function metano_town_nuit.Nuit_Garde_Action(chara, activator)
  TownNight.Talk('Nuit_Garde')
end

function metano_town_nuit.Nuit_Etoiles_Action(chara, activator)
  TownNight.Talk('Nuit_Etoiles')
end

function metano_town_nuit.Nuit_Insomniaque_Action(chara, activator)
  TownNight.Talk('Nuit_Insomniaque')
end

function metano_town_nuit.Noctowl_Action(chara, activator)
  TownNight.Talk('Noctowl')
end

return metano_town_nuit
