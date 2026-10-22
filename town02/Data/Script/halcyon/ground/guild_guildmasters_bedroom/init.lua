--[[
    init.lua
    LA CHAMBRE OU DORT PENTICUS

    ================================================================
    POURQUOI CETTE PIECE EXISTE
    ------------------------------------------------------------------
    Verification faite avant de la construire : Penticus n'avait NULLE
    PART ou dormir. Balayage des 229 cartes du depot, il n'apparaissait
    que sur trois d'entre elles — le refectoire, le hall du 3e etage et
    son BUREAU (guild_guildmasters_room, dont le nom interne est
    litteralement « Guildmaster's Office »).

    Et le couloir des chambres est sature : ses six portes sont toutes
    attribuees (Mareep+Cranidos, Audino+Snubbull, Breloom+Girafarig,
    Zigzagoon, la chambre du heros, et le retour vers le lobby).

    Cette carte est donc un clone de guild_top_right_bedroom, choisie
    parce que c'est la SEULE a posseder deja des marqueurs de lit. Les
    deux ont ete renommes, la geometrie n'a pas bouge d'un pixel :

        Audino_Bed  (252,148) -> Penticus_Bed
        Snubbull_Bed (84,180) -> Phileas_Bed

    ------------------------------------------------------------------
    DEUX LITS, ET CE QUE CA RACONTE
    ------------------------------------------------------------------
    La carte source en avait deux, et c'est une chance : plutot que
    d'en supprimer un, on s'en sert. Penticus et Phileas partagent la
    piece, comme toutes les paires de la guilde.

    Ce detail dit quelque chose qu'aucun dialogue n'aurait a expliquer :
    le maitre de guilde ne dort pas seul dans une suite. Il dort dans
    la meme chambre que son savant, avec le meme mobilier que ses
    recrues. C'est la fondation d'origine qui continue.

    ------------------------------------------------------------------
    L'ACCES
    ------------------------------------------------------------------
    Par une porte au fond du BUREAU, pas par le couloir des chambres.
    Il dort la ou il travaille : c'est plus juste pour lui, et ca evite
    de toucher a un couloir deja plein.

    La sortie renvoie donc au bureau, et non au couloir — c'est le seul
    ecart avec le script de la carte source.

    ------------------------------------------------------------------
    REGLES DU PROJET
    ------------------------------------------------------------------
    * Jamais « Necrozma », « Eternatus », « l'Abime », « prison ».
    * La Voix ne parle pas ici.
    * Texte litteral francais.
    * 1 a 2 phrases par boite, < 150 caracteres hors [pause=N].
    * Tout sous pcall : une piece privee ne doit jamais pieger le joueur.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

local guild_guildmasters_bedroom = {}

-------------------------------
-- Map Callbacks
-------------------------------
function guild_guildmasters_bedroom.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo('=>> Init_guild_guildmasters_bedroom <<=')
  COMMON.RespawnAllies()
  PartnerEssentials.InitializePartnerSpawn()
end

function guild_guildmasters_bedroom.Enter(map)
  DEBUG.EnableDbgCoro()
  guild_guildmasters_bedroom.PlotScripting()
end

function guild_guildmasters_bedroom.Exit(map) end
function guild_guildmasters_bedroom.Update(map, time) end

function guild_guildmasters_bedroom.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function guild_guildmasters_bedroom.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  guild_guildmasters_bedroom.PlotScripting()
end

--------------------------------------------------------------------
-- ARRIVEE
--------------------------------------------------------------------
-- La premiere fois, le partenaire dit le malaise d'entrer chez
-- quelqu'un. C'est la meme grammaire que les autres chambres de la
-- guilde (PartnerEssentials : « J'espere que nous ne serions pas
-- intrusifs si nous entrions »), sauf qu'ici il s'agit du maitre.
function guild_guildmasters_bedroom.PlotScripting()
  local s = guild_guildmasters_bedroom.Ensure()

  pcall(function() GAME:FadeIn(20) end)

  if s.Visited then return end
  s.Visited = true

  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end
    GAME:WaitFrames(20)

    UI:ResetSpeaker(false)
    UI:SetCenter(true)
    UI:WaitShowDialogue("Deux lits.[pause=30] Vous vous attendiez a en trouver un seul.")
    UI:SetCenter(false)
    UI:ResetSpeaker()
    GAME:WaitFrames(15)

    if partner ~= nil then
      UI:SetSpeaker(partner)
      GeneralFunctions.SetEmotion('Surprised')
      UI:WaitShowDialogue("Le maitre de guilde partage sa chambre ?[pause=30] Comme nous ?")
      GeneralFunctions.SetEmotion('Normal')
      UI:WaitShowDialogue("Et le mobilier est le meme que le notre.[pause=25] Exactement le meme.")
      UI:ResetSpeaker()
      GAME:WaitFrames(10)
    end

    GeneralFunctions.HeroDialogue(hero,
      "(Il aurait pu prendre la plus grande piece.[pause=25] Il a pris celle-ci.)", 'Normal')
  end)

  pcall(function()
    UI:ResetSpeaker()
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', CH('PLAYER'), partner.Position)
    end
    GAME:CutsceneMode(false)
  end)
end

--------------------------------------------------------------------
-- QUI EST LA, ET POURQUOI
--------------------------------------------------------------------
-- LA QUESTION : faut-il montrer Penticus et Phileas endormis ?
--
-- Reponse apres verification dans le depot : NON, et la logique
-- l'interdit. Trois faits mesures, pas supposes :
--
--  1. LE JOUEUR NE MARCHE JAMAIS DANS LA GUILDE LA NUIT.
--     Poser SV.TemporaryFlags.Bedtime declenche toujours un retour a la
--     chambre du heros (carte 2 de master_zone), et
--     guild_heros_room_helper.Bedtime teleporte aussitot le duo dans son
--     lit (lignes 26-27). Il n'existe aucun chemin ou le joueur se
--     promene librement dans les couloirs pendant la nuit.
--     => si le joueur est ICI et peut bouger, il fait JOUR.
--
--  2. PENTICUS EST DEJA DANS SON BUREAU, EN PERMANENCE.
--     Il est un MapChar de guild_guildmasters_room, et aucun script du
--     dossier ne l'appelle jamais avec GROUND:Hide (0 occurrence).
--     Le montrer endormi ici le placerait a DEUX endroits a la fois,
--     dans deux pieces separees par une seule porte.
--
--  3. LA CHAMBRE EST ATTENANTE AU BUREAU.
--     On y entre par une porte du fond. Le joueur vient litteralement de
--     passer devant Penticus. Le trouver endormi trois metres plus loin
--     serait absurde.
--
-- CONCLUSION : la piece reste VIDE, et c'est le choix juste. Ce qu'on
-- montre a la place, ce sont les TRACES de ceux qui y dorment — un lit
-- fait au carre, un lit couvert de notes. Une chambre vide en dit plus
-- long sur ses occupants qu'un occupant endormi.
--
-- Le seul cas ou quelqu'un serait present : une scene d'histoire qui
-- l'exige explicitement. Ce crochet est prevu ci-dessous et n'est
-- utilise par aucun chapitre pour l'instant.

--Renvoie true si une scene imposee veut quelqu'un dans la chambre.
--Aucun chapitre ne s'en sert aujourd'hui : la fonction existe pour que
--le jour ou l'un d'eux doit y etre, on n'ait pas a rouvrir la logique.
function guild_guildmasters_bedroom.SceneRequiresOccupant()
  return false
end

--------------------------------------------------------------------
-- ETAT
--------------------------------------------------------------------
function guild_guildmasters_bedroom.Ensure()
  if SV.GuildmasterBedroom == nil then SV.GuildmasterBedroom = {} end
  local s = SV.GuildmasterBedroom
  if s.Visited == nil then s.Visited = false end
  if s.ReadPenticusBed == nil then s.ReadPenticusBed = false end
  if s.ReadPhileasBed == nil then s.ReadPhileasBed = false end
  return s
end

-------------------------------
-- Entities Callbacks
-------------------------------
-- CORRECTION. Les lits n'etaient au depart que des MARQUEURS, herites de
-- la carte source. Un marqueur n'a pas de triggerType : le moteur ne
-- l'active jamais, et ces deux fonctions n'auraient JAMAIS pu se
-- declencher. De vrais GroundObjects (triggerType 1, Passable) ont donc
-- ete poses aux memes coordonnees : Penticus_Bed_Obj et Phileas_Bed_Obj.
-- LE LIT DE PENTICUS. Il est vide, et il doit l'etre : son occupant est
-- dans la piece d'a cote, en train de travailler (voir la note sur la
-- presence, plus haut). Ce sont donc les TRACES qu'on decrit.
--
-- Le lit change selon l'avancement du chapitre 6 : c'est la seule facon
-- de faire vivre une piece ou personne ne se tient jamais.
function guild_guildmasters_bedroom.Penticus_Bed_Obj_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  local s = guild_guildmasters_bedroom.Ensure()
  local c6 = SV.Chapter6 or {}
  local txt

  if not s.ReadPenticusBed then
    s.ReadPenticusBed = true
    txt = "Un lit trop court pour lui.[pause=30] Il doit dormir en travers depuis des annees."
  elseif c6.DefeatedGloomyBoss then
    txt = "Les draps n'ont pas ete defaits.[pause=30] Il n'est pas venu se coucher cette nuit."
  elseif c6.MissionAccepted then
    txt = "Une carte de la foret est posee sur l'oreiller.[pause=25] Annotee, raturee, reprise."
  else
    txt = "Le grand lit du fond.[pause=25] Les draps sont tires au carre, comme a l'armee."
  end

  pcall(function()
    UI:ResetSpeaker(false); UI:SetCenter(true)
    UI:WaitShowDialogue(txt)
    UI:SetCenter(false); UI:ResetSpeaker()
  end)
end

-- LE LIT DE PHILEAS. Meme principe : vide, et parlant par ce qu'on y
-- laisse. Lui ne dort quasiment pas — c'est deja ce que dit son role
-- dans tout le mod, et le lit le confirme sans un mot de dialogue.
function guild_guildmasters_bedroom.Phileas_Bed_Obj_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  local s = guild_guildmasters_bedroom.Ensure()
  local c6 = SV.Chapter6 or {}
  local txt

  if not s.ReadPhileasBed then
    s.ReadPhileasBed = true
    txt = "Ce lit-la n'a pas servi cette nuit.[pause=30] Il y a des notes posees dessus, en pile nette."
  elseif c6.DefeatedGloomyBoss then
    txt = "La pile de notes a double.[pause=30] Il devra bien dormir un jour."
  else
    txt = "Le lit de gauche.[pause=25] Des feuillets s'empilent sur le rebord, tries par date."
  end

  pcall(function()
    UI:ResetSpeaker(false); UI:SetCenter(true)
    UI:WaitShowDialogue(txt)
    UI:SetCenter(false); UI:ResetSpeaker()
  end)
end

function guild_guildmasters_bedroom.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  local partner = CH('Teammate1')
  if partner == nil then return end
  pcall(function()
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion('Worried')
    UI:WaitShowDialogue("On ne devrait pas trainer ici.[pause=30] C'est chez lui, quand meme.")
    UI:ResetSpeaker()
  end)
end

---------------------------
-- Map Transitions
---------------------------
-- SEUL ECART avec la carte source : on ressort dans le BUREAU, pas dans
-- le couloir des chambres. La chambre est attenante au bureau.
function guild_guildmasters_bedroom.Bedroom_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("guild_guildmasters_room", "Main_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end

return guild_guildmasters_bedroom
