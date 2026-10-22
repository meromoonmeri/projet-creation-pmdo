--[[
    SideExpeditions.lua

    LES EXPEDITIONS — requetes secondaires QUI ENVOIENT DANS UN DONJON
    ================================================================
    CONSTAT MESURE
    ------------------------------------------------------------------
    SideQuests.lua tient 15 requetes (3 par chapitre, ch6 a ch10). Elles
    sont bien ecrites, mais toutes du meme type : on parle au demandeur,
    on parle a la cible, on revient. Releve : aucune n'appelle
    EnterDungeon ni EnterZone. Le contenu optionnel du jeu est donc
    entierement conversationnel.

    En face, 161 zones du dossier Data/Zone ne sont citees par AUCUN
    script : elles sont generables, Released=true, avec de vrais etages,
    et personne n'y va jamais. Parmi elles, quinze portent l'en-tete
    « Vague 2 — donjon secondaire (job board) » : libres de tout usage
    narratif, contrairement aux « Donjon-Ancrage » reserves au Livre II.

    CE QUE FAIT CE MODULE
    ------------------------------------------------------------------
    Six expeditions, deux par chapitre (ch8, ch9, ch10), batie chacune
    sur une de ces zones inedites. Le cycle a une etape de plus que les
    requetes de conversation :

        demande  ->  DONJON  ->  retour  ->  rapport

    Ces donjons n'ont PAS d'entrance dediee et n'en ont pas besoin : on
    y entre depuis la ville par GAME:EnterDungeon, comme le fait deja le
    comptoir de missions. Leur ExitSegment renvoie a Metano (master_zone
    ground 1), ce qui referme la boucle sans code supplementaire.

    POURQUOI CES ZONES-LA
    ------------------------------------------------------------------
    Chaque expedition est choisie pour que le LIEU dise quelque chose
    du chapitre :
      ch8  cristal      -> Carriere de Cuivre, Bassin Tari
      ch9  eau troublee -> Marais Errants, Bois des Ronces
      ch10 ciel deregle -> Col de la Foudre, Falaises de l'Envol

    L'UNDERTOW, PRINCIPE REPRIS DE SideQuests
    ------------------------------------------------------------------
    Chaque expedition est un service rendu, concret et modeste. Mais
    chacune rapporte de la-bas une observation qui ne s'explique pas :
    une eau qui coule a l'envers, un filon qui a cesse de chanter, un
    vent qui monte au lieu de descendre. Le joueur attentif recolle les
    morceaux ; les autres ont juste rendu service.

    REGLES DU PROJET
      * Jamais « Necrozma », « Eternatus », « l'Abime », « prison ».
      * La Voix ne parle JAMAIS dans une requete.
      * Module global -> texte litteral, pas de .resx.
      * 1 a 2 phrases par boite, < 150 caracteres hors [pause=N].
      * Tout sous pcall, sortie garantie.
      * Les requetes de SideQuests ne sont ni modifiees ni remplacees :
        ce module vit a cote et se declare aupres d'elles.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

SideExpeditions = {}

--------------------------------------------------------------------
-- ETAT
--------------------------------------------------------------------
-- Taken[id]   la demande est acceptee
-- Cleared[id] le donjon a ete termine (pose par OnDungeonCleared)
-- Done[id]    le rapport a ete rendu au demandeur
--------------------------------------------------------------------
function SideExpeditions.Ensure()
  if SV.SideExpeditions == nil then SV.SideExpeditions = {} end
  local s = SV.SideExpeditions
  if s.Taken == nil then s.Taken = {} end
  if s.Cleared == nil then s.Cleared = {} end
  if s.Done == nil then s.Done = {} end
  return s
end


--------------------------------------------------------------------
-- LES EXPEDITIONS
--------------------------------------------------------------------
-- zone     identifiant de zone (Data/Zone/<zone>.json), verifie present
--          et Released dans index.idx
-- lieu     nom affiche au joueur
-- ask      ce que dit le demandeur quand on l'aborde
-- accept   sa reaction si on accepte
-- refuse   sa reaction si on refuse (jamais vexante)
-- pending  ce qu'il dit tant qu'on n'est pas parti / revenu
-- back     ce que l'equipe constate au retour, avant le rapport
-- done     le rapport et le remerciement
-- undertow la seconde couche
--------------------------------------------------------------------
SideExpeditions.LIST = {

  ---------------------------------------------------------------
  -- CHAPITRE 8 — le cristal fascine
  ---------------------------------------------------------------
  {
    id = 'x8_filon', ch = 8, giver = 'Bisharp',
    zone = 'carriere_cuivre', lieu = "la Carrière de Cuivre",
    titre = "Le filon qui s'est tu",
    ask = {
      {'Bisharp', 'Normal',  "Vous savez reconnaître un bon filon au bruit ?[pause=25] Moi oui."},
      {'Bisharp', 'Worried', "La vieille carrière au nord chantait quand on la frappait.[pause=25] Elle ne chante plus."},
      {'Bisharp', 'Normal',  "Descendez-y. Frappez la paroi du fond.[pause=20] Dites-moi ce que vous entendez."},
    },
    accept  = {'Bisharp', 'Determined', "Prenez de quoi vous éclairer.[pause=20] En bas, il fait noir comme dans un four."},
    refuse  = {'Bisharp', 'Normal',     "Comme vous voudrez.[pause=25] Le filon attendra. Il a le temps, lui."},
    pending = {'Bisharp', 'Worried',    "Alors ?[pause=20] Vous êtes descendus ?"},
    back    = {'Bisharp', 'Normal',     "Vous en revenez.[pause=25] Ça se voit à la poussière. Racontez."},
    done = {
      {'Bisharp', 'Surprised', "Un son mat ?[pause=25] Vous êtes sûrs ? Pas un son clair, mat ?"},
      {'Bisharp', 'Worried',   "Une paroi qui sonne mat, c'est une paroi vide derrière.[pause=25] Ou pleine d'autre chose."},
      {'Bisharp', 'Determined',"Je n'y redescendrai pas seul.[pause=20] Merci d'y être allés à ma place."},
    },
    undertow = "quelque chose s'est loge derriere la roche",
  },

  {
    id = 'x8_bassin', ch = 8, giver = 'Quagsire',
    zone = 'bassin_tari', lieu = "le Bassin Tari",
    titre = "Le bassin qui ne se remplit plus",
    ask = {
      {'Quagsire', 'Worried', "Le grand bassin de l'est s'est vidé.[pause=25] En une nuit."},
      {'Quagsire', 'Sad',     "Un bassin ne se vide pas en une nuit.[pause=20] Ça met des saisons."},
      {'Quagsire', 'Normal',  "Allez voir où l'eau est partie.[pause=25] Moi je nage mal sur la terre sèche."},
    },
    accept  = {'Quagsire', 'Normal', "Suivez le lit à sec.[pause=20] L'eau laisse toujours sa trace."},
    refuse  = {'Quagsire', 'Sigh',   "Bon.[pause=25] J'irai barboter ailleurs en attendant."},
    pending = {'Quagsire', 'Worried',"Vous avez trouvé où elle est passée ?"},
    back    = {'Quagsire', 'Normal', "Vous voilà.[pause=25] Dites-moi que ce n'est pas ce que je crois."},
    done = {
      {'Quagsire', 'Surprised', "Elle s'écoule vers le BAS ?[pause=25] Mais il n'y a rien, en bas."},
      {'Quagsire', 'Worried',   "Enfin...[pause=25] il n'y avait rien, en bas."},
      {'Quagsire', 'Normal',    "Merci.[pause=20] Je préfère savoir, même si je dors moins bien."},
    },
    undertow = "l'eau descend vers quelque chose de neuf",
  },

  ---------------------------------------------------------------
  -- CHAPITRE 9 — l'eau tourne
  ---------------------------------------------------------------
  {
    id = 'x9_marais', ch = 9, giver = 'Ledian',
    zone = 'marais_errants', lieu = "les Marais Errants",
    titre = "Les balises du marais",
    ask = {
      {'Ledian', 'Worried', "Nous posons des balises dans les marais depuis vingt ans.[pause=25] Pour que personne ne s'y perde."},
      {'Ledian', 'Sad',     "Trois d'entre elles ont bougé.[pause=25] Des balises ne bougent pas toutes seules."},
      {'Ledian', 'Normal',  "Traversez et vérifiez la dernière, au fond.[pause=20] C'est la plus importante."},
    },
    accept  = {'Ledian', 'Determined', "Comptez vos pas.[pause=25] Là-bas, on ne se fie pas à ses yeux."},
    refuse  = {'Ledian', 'Sad',        "Je comprends.[pause=20] J'irai moi-même. Un jour."},
    pending = {'Ledian', 'Worried',    "La balise du fond.[pause=20] Vous l'avez vue ?"},
    back    = {'Ledian', 'Normal',     "Vous êtes trempés.[pause=25] Donc vous y êtes allés. Alors ?"},
    done = {
      {'Ledian', 'Surprised', "Debout, mais tournée ?[pause=25] Tournée vers où ?"},
      {'Ledian', 'Worried',   "Vers l'intérieur du marais...[pause=30] Elle indique le contraire de la sortie."},
      {'Ledian', 'Determined',"Je vais toutes les revérifier.[pause=25] Et je ne les poserai plus jamais seul."},
    },
    undertow = "les reperes se retournent contre ceux qui les suivent",
  },

  {
    id = 'x9_ronces', ch = 9, giver = 'Roselia',
    zone = 'bois_ronces', lieu = "le Bois des Ronces",
    titre = "La coupe de printemps",
    ask = {
      {'Roselia', 'Normal',  "Chaque année je coupe les ronces du bois de l'est.[pause=25] Sinon elles étouffent le reste."},
      {'Roselia', 'Worried', "Cette année elles ont repoussé en trois semaines.[pause=25] Trois."},
      {'Roselia', 'Sad',     "Je n'y arriverai pas seule.[pause=20] Vous voulez bien m'ouvrir un passage ?"},
    },
    accept  = {'Roselia', 'Happy',  "Merci.[pause=25] Coupez au ras. Elles détestent ça."},
    refuse  = {'Roselia', 'Sigh',   "Tant pis.[pause=20] Le bois se débrouillera sans moi."},
    pending = {'Roselia', 'Worried',"Le passage est ouvert ?"},
    back    = {'Roselia', 'Normal', "Vous avez des égratignures partout.[pause=25] Ça veut dire oui."},
    done = {
      {'Roselia', 'Surprised', "Elles poussaient vers le nord ?[pause=25] Toutes dans le même sens ?"},
      {'Roselia', 'Worried',   "Une ronce pousse vers la lumière.[pause=25] Pas vers un point précis."},
      {'Roselia', 'Determined',"J'irai voir ce qu'il y a au nord.[pause=20] Pas seule, promis."},
    },
    undertow = "meme les plantes se tournent vers le meme point",
  },

  ---------------------------------------------------------------
  -- CHAPITRE 10 — le ciel se deregle
  ---------------------------------------------------------------
  {
    id = 'x10_col', ch = 10, giver = 'Manectric',
    zone = 'col_foudre', lieu = "le Col de la Foudre",
    titre = "Compter les impacts",
    ask = {
      {'Manectric', 'Worried', "Le col au nord prend la foudre depuis toujours.[pause=25] C'est sa nature."},
      {'Manectric', 'Normal',  "Mon grand-père comptait douze impacts par saison.[pause=20] Moi, dix. Ça se tenait."},
      {'Manectric', 'Sad',     "Montez-y et comptez les traces fraîches.[pause=25] J'ai besoin d'un chiffre, pas d'une impression."},
    },
    accept  = {'Manectric', 'Determined', "Ne touchez pas la roche noire.[pause=20] Elle garde la charge des jours entiers."},
    refuse  = {'Manectric', 'Sigh',       "Je comprends.[pause=25] Ce n'est pas un endroit où l'on monte de gaieté de cœur."},
    pending = {'Manectric', 'Worried',    "Vous avez votre chiffre ?"},
    back    = {'Manectric', 'Normal',     "Votre fourrure crépite encore.[pause=25] Combien ?"},
    done = {
      {'Manectric', 'Shock',   "Quarante et un ?![pause=25] En une seule saison ?"},
      {'Manectric', 'Worried', "Et toutes au même endroit, dites-vous.[pause=25] Pas dispersées. Au même endroit."},
      {'Manectric', 'Sad',     "Ce n'est plus un col qui prend la foudre.[pause=25] C'est quelque chose qui l'appelle."},
    },
    undertow = "le ciel vise, desormais",
  },

  {
    id = 'x10_falaises', ch = 10, giver = 'Bagon',
    zone = 'falaises_envol', lieu = "les Falaises de l'Envol",
    titre = "Le premier envol",
    ask = {
      {'Bagon', 'Determined', "Les Falaises de l'Envol.[pause=25] C'est là que ceux qui volent font leur premier saut."},
      {'Bagon', 'Sad',        "Je ne vole pas. Pas encore.[pause=25] Mais je veux voir à quoi ça ressemble."},
      {'Bagon', 'Worried',    "Montez-y pour moi.[pause=25] Et dites-moi s'ils sont toujours là-haut."},
    },
    accept  = {'Bagon', 'Happy', "Regardez bien ![pause=20] Je veux tous les détails !"},
    refuse  = {'Bagon', 'Sad',   "...D'accord.[pause=25] J'irai quand j'aurai des ailes."},
    pending = {'Bagon', 'Determined', "Alors ?[pause=20] Ils volent toujours ?"},
    back    = {'Bagon', 'Happy', "Vous en revenez ![pause=20] Racontez, racontez !"},
    done = {
      {'Bagon', 'Surprised', "Plus personne ?[pause=25] Les falaises sont vides ?"},
      {'Bagon', 'Sad',       "Ils sont partis vers le sud, tous ensemble.[pause=25] Sans faire de bruit."},
      {'Bagon', 'Determined',"Alors je m'entraînerai deux fois plus.[pause=25] Quelqu'un devra bien y retourner."},
    },
    undertow = "ceux qui volent ont fui les hauteurs",
  },
}


--------------------------------------------------------------------
-- ACCES
--------------------------------------------------------------------
function SideExpeditions.OfChapter(ch)
  local out = {}
  for _, x in ipairs(SideExpeditions.LIST) do
    if x.ch == ch then table.insert(out, x) end
  end
  return out
end

function SideExpeditions.Remaining(ch)
  local s = SideExpeditions.Ensure()
  local n = 0
  for _, x in ipairs(SideExpeditions.OfChapter(ch)) do
    if not s.Done[x.id] then n = n + 1 end
  end
  return n
end

function SideExpeditions.AllDone(ch)
  return SideExpeditions.Remaining(ch) == 0
end

--Zone attendue pour une expedition acceptee mais pas encore faite.
function SideExpeditions.PendingZone()
  local s = SideExpeditions.Ensure()
  for _, x in ipairs(SideExpeditions.LIST) do
    if s.Taken[x.id] and not s.Cleared[x.id] then return x.zone, x.id end
  end
  return nil
end

local function line(t)
  if t == nil then return end
  local chara = CH(t[1])
  if chara == nil then return end
  UI:SetSpeaker(chara)
  GeneralFunctions.SetEmotion(t[2] or 'Normal')
  UI:WaitShowDialogue(t[3])
end


--------------------------------------------------------------------
-- LE DEMANDEUR
--
-- Renvoie true si le PNJ avait quelque chose a dire. L'appelant
-- enchaine sinon sur son dialogue habituel : aucune replique de base
-- n'est perdue.
--------------------------------------------------------------------
function SideExpeditions.Talk(inst, ch)
  local s = SideExpeditions.Ensure()

  for _, x in ipairs(SideExpeditions.OfChapter(ch)) do
    if x.giver == inst and not s.Done[x.id] then
      local chara = CH(inst)
      if chara == nil then return false end

      local ok = pcall(function()
        --RAPPORT : le donjon est fait, on rend compte.
        if s.Cleared[x.id] then
          line(x.back)
          GAME:WaitFrames(10)
          for _, t in ipairs(x.done) do line(t) end
          s.Done[x.id] = true
          UI:ResetSpeaker(false)
          UI:SetCenter(true)
          UI:WaitShowDialogue("Expédition accomplie :[pause=10] « " .. x.titre .. " ».")
          local r = SideExpeditions.Remaining(ch)
          if r > 0 then
            UI:WaitShowDialogue("Il reste " .. tostring(r) .. " expédition(s) en cours.")
          end
          UI:SetCenter(false)
          return
        end

        --EN COURS : on a accepte mais on n'y est pas encore alle.
        if s.Taken[x.id] then
          line(x.pending)
          UI:ResetSpeaker(false)
          UI:SetCenter(true)
          UI:WaitShowDialogue("Destination :[pause=10] " .. x.lieu .. ".")
          UI:SetCenter(false)
          return
        end

        --PROPOSITION.
        for _, t in ipairs(x.ask) do line(t) end
        UI:ChoiceMenuYesNo("Partir pour " .. x.lieu .. " ?", true)
        UI:WaitForChoice()
        if UI:ChoiceResult() then
          s.Taken[x.id] = true
          line(x.accept)
          UI:ResetSpeaker(false)
          UI:SetCenter(true)
          UI:WaitShowDialogue("Expédition acceptée :[pause=10] « " .. x.titre .. " ».")
          UI:WaitShowDialogue("Rendez-vous à " .. x.lieu .. ".")
          UI:SetCenter(false)
        else
          line(x.refuse)
        end
      end)

      pcall(function() UI:ResetSpeaker() end)
      return ok
    end
  end
  return false
end


--------------------------------------------------------------------
-- RETOUR DE DONJON
--
-- A appeler depuis le ExitSegment de la zone concernee. On ne marque
-- l'expedition faite QUE si le donjon a ete termine (Cleared) : une
-- fuite ou un KO laisse la demande en cours, et le demandeur redit sa
-- ligne d'attente.
--------------------------------------------------------------------
function SideExpeditions.OnDungeonCleared(zoneId, result)
  local s = SideExpeditions.Ensure()
  local cleared = false
  pcall(function()
    cleared = (result == RogueEssence.Data.GameProgress.ResultType.Cleared)
  end)
  if not cleared then return false end

  local touche = false
  for _, x in ipairs(SideExpeditions.LIST) do
    if x.zone == zoneId and s.Taken[x.id] and not s.Cleared[x.id] then
      s.Cleared[x.id] = true
      touche = true
      pcall(function()
        UI:ResetSpeaker(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue("Vous avez ce que vous étiez venus chercher.[pause=20] Il faut en rendre compte.")
        UI:SetCenter(false)
      end)
    end
  end
  return touche
end


--Compte des boites de dialogue, pour le controle de quota.
function SideExpeditions.Count()
  local n = 0
  for _, x in ipairs(SideExpeditions.LIST) do
    for _, k in ipairs({'ask', 'done'}) do
      for _ in ipairs(x[k] or {}) do n = n + 1 end
    end
    for _, k in ipairs({'accept', 'refuse', 'pending', 'back'}) do
      if x[k] ~= nil then n = n + 1 end
    end
  end
  return n
end

return SideExpeditions
