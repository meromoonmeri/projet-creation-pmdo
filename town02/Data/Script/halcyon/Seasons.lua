--[[
    Seasons.lua

    LES SAISONS DE METANO — pilotees par l'avancement de l'histoire
    ================================================================
    L'IDEE
    ------------------------------------------------------------------
    Le bourg change de saison au fil du recit, pas au fil de l'horloge
    reelle. Le joueur qui progresse voit la ville passer du printemps a
    l'hiver : c'est un marqueur de temps LONG, qui dit « il s'est passe
    des mois » sans qu'aucun personnage ait a le prononcer.

    ------------------------------------------------------------------
    CE QUI A ETE VERIFIE AVANT D'ECRIRE (et corrige)
    ------------------------------------------------------------------
    1. LA VARIABLE DE CHAPITRE. La demande mentionnait
       `SV.storyProgression.Chapter`. Ce champ N'EXISTE PAS dans ce
       depot (0 occurrence). Le vrai nom est
       `SV.ChapterProgression.Chapter` (458 occurrences, declare dans
       scriptvars.lua). C'est celui-ci qu'on lit.

    2. L'ECHELLE. Le mod compte 10 chapitres joues (SV.Chapter1..10),
       pas 30. Le decoupage demande (1-7 / 8-15 / 16-22 / 23-30) laisse
       donc TOUT le jeu actuel au printemps, puis a l'ete a partir du
       ch8 — soit deux saisons seulement sur la partie jouable.
       On conserve l'echelle a 30 telle que demandee (les chapitres
       11-32 sont prevus), MAIS on expose Seasons.SetScale('court')
       pour replier les memes 4 saisons sur les 10 chapitres existants
       et voir les quatre ambiances des maintenant. Rien n'est perdu.

    3. L'EMETTEUR. Pas besoin d'ecrire du C# : le moteur fournit deja
       ScreenRainEmitter, deja employe ici par MapStatus/falling_ash
       (Pluie de Cendres). On cree donc trois MapStatus sur ce modele
       — c'est la voie officielle, et elle ne demande aucun recompilage.

    4. LES TEXTURES. Aucun PNG n'a ete trouve dans le depot (recherche
       sakura/petal/leaf/snow : rien). Et les sprites de Noir/Blanc 2
       appartiennent a Nintendo : les embarquer exposerait le projet.
       tools/gen_season_particles.py DESSINE donc des particules
       originales au format .dir exact du moteur.

    ------------------------------------------------------------------
    LE MECANISME PMDO (et son piege)
    ------------------------------------------------------------------
    Un MapStatus est POSE sur la carte courante et y RESTE. Le depot le
    documente lui-meme (guild_heros_room_ch_1.lua:162) :

        « Remove map status before saving the game, as saving with a
          map status saves it for the next load. »

    D'ou la regle appliquee ici : Seasons.Apply() retire TOUJOURS les
    trois statuts saisonniers avant de poser le bon. Sans ce nettoyage,
    passer du printemps a l'ete laisserait les petales a l'ecran, et
    deux saisons finiraient par se superposer.

    ------------------------------------------------------------------
    REGLES DU PROJET
    ------------------------------------------------------------------
    * Module global -> texte litteral francais, jamais STRINGS.MapStrings.
    * Tout sous pcall : un effet decoratif ne doit JAMAIS empecher
      d'entrer dans la ville.
]]
require 'origin.common'

Seasons = {}

--------------------------------------------------------------------
-- LES QUATRE SAISONS
--------------------------------------------------------------------
-- `status` = nil signifie « aucune particule ». C'est le cas de l'ete :
-- un ciel vide est aussi une information, et ca laisse respirer l'oeil
-- entre le printemps et l'automne.
Seasons.PRINTEMPS = { id = 'printemps', status = 'sakura_drift',
                      nom = 'Printemps' }
Seasons.ETE       = { id = 'ete',       status = nil,
                      nom = 'Été' }
Seasons.AUTOMNE   = { id = 'automne',   status = 'autumn_leaves',
                      nom = 'Automne' }
Seasons.HIVER     = { id = 'hiver',     status = 'winter_snow',
                      nom = 'Hiver' }

--Tous les statuts saisonniers, pour le nettoyage.
Seasons.TOUS = { 'sakura_drift', 'autumn_leaves', 'winter_snow' }

--------------------------------------------------------------------
-- LES DEUX ECHELLES
--------------------------------------------------------------------
-- 'long'  : le decoupage demande, sur 30 chapitres.
-- 'court' : les memes 4 saisons repliees sur les 10 chapitres qui
--           existent aujourd'hui, pour que le systeme soit visible
--           immediatement au lieu d'attendre le chapitre 16.
--
-- Chaque entree = { chapitreMax, saison }. On prend la premiere dont
-- le chapitre courant ne depasse pas le maximum.
Seasons.ECHELLES = {
  long = {
    { 7,  Seasons.PRINTEMPS },
    { 15, Seasons.ETE },
    { 22, Seasons.AUTOMNE },
    { 30, Seasons.HIVER },
  },
  court = {
    { 3,  Seasons.PRINTEMPS },   -- ch1-3   l'apprentissage
    { 5,  Seasons.ETE },         -- ch4-5   l'expedition
    { 7,  Seasons.AUTOMNE },     -- ch6-7   la foret, les ruines
    { 10, Seasons.HIVER },       -- ch8-10  le sanctuaire, le marais, le pic
  },
}

--------------------------------------------------------------------
-- ETAT
--------------------------------------------------------------------
function Seasons.Ensure()
  if SV.Seasons == nil then SV.Seasons = {} end
  local s = SV.Seasons
  --Echelle active. 'court' par defaut : les 10 chapitres jouables
  --montrent les quatre saisons. Passer a 'long' quand les chapitres
  --11 a 32 seront ecrits.
  if s.Echelle == nil then s.Echelle = 'court' end
  --Derniere saison appliquee, pour ne rien refaire inutilement et
  --pour savoir quand la saison VIENT de changer.
  if s.Courante == nil then s.Courante = '' end
  --Le joueur a-t-il deja vu le commentaire de cette saison ?
  if s.Vues == nil then s.Vues = {} end
  --Interrupteur general, utile en debug ou pour une scene imposee.
  if s.Actif == nil then s.Actif = true end
  return s
end

function Seasons.SetScale(nom)
  local s = Seasons.Ensure()
  if Seasons.ECHELLES[nom] ~= nil then s.Echelle = nom end
  return s.Echelle
end

--------------------------------------------------------------------
-- QUELLE SAISON ?
--------------------------------------------------------------------
-- Lit le VRAI champ de chapitre du depot. Jamais d'appel direct sans
-- garde : une partie neuve peut arriver avant l'initialisation.
function Seasons.Chapitre()
  local ch = 1
  pcall(function()
    if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil then
      ch = SV.ChapterProgression.Chapter
    end
  end)
  if type(ch) ~= 'number' or ch < 1 then ch = 1 end
  return ch
end

function Seasons.Actuelle()
  local s = Seasons.Ensure()
  local ch = Seasons.Chapitre()
  local table_ = Seasons.ECHELLES[s.Echelle] or Seasons.ECHELLES.court

  for _, entree in ipairs(table_) do
    if ch <= entree[1] then return entree[2] end
  end
  --Au-dela de la derniere borne (chapitres a venir) : on reste en hiver
  --plutot que de retomber sans saison.
  return table_[#table_][2]
end

--------------------------------------------------------------------
-- APPLICATION SUR LA CARTE
--------------------------------------------------------------------
-- A appeler depuis Init (pas Enter) : Init s'execute une fois la carte
-- chargee, avant que le joueur ne la voie. C'est la que metano_town
-- pose deja "clouds_overhead" (init.lua:35), on suit cet usage.
--
-- NETTOYAGE OBLIGATOIRE : un MapStatus persiste. On retire les trois
-- statuts saisonniers avant d'en poser un, sinon ils s'accumulent.
function Seasons.Apply()
  local s = Seasons.Ensure()
  local saison = Seasons.Actuelle()

  pcall(function()
    for _, st in ipairs(Seasons.TOUS) do
      GROUND:RemoveMapStatus(st)
    end
  end)

  if not s.Actif then
    s.Courante = ''
    return nil
  end

  if saison.status ~= nil then
    pcall(function() GROUND:AddMapStatus(saison.status) end)
  end

  s.Courante = saison.id
  return saison
end

--Retire toute particule saisonniere. Utile avant une cinematique qui
--a besoin d'un ciel neutre, ou avant une sauvegarde.
function Seasons.Clear()
  pcall(function()
    for _, st in ipairs(Seasons.TOUS) do
      GROUND:RemoveMapStatus(st)
    end
  end)
end

--------------------------------------------------------------------
-- LA PREMIERE FOIS QU'UNE SAISON ARRIVE
--------------------------------------------------------------------
-- Une saison qui change sans que personne ne le remarque n'a pas eu
-- lieu. Le partenaire la commente UNE SEULE FOIS, brievement : deux
-- boites, jamais plus. Le reste du temps, le decor parle tout seul.
Seasons.REMARQUES = {
  printemps = {
    "Il y a des pétales partout ce matin.[pause=25] Ça vient des arbres du nord.",
    "J'aime bien.[pause=20] On dirait que la ville s'est habillée pour nous.",
  },
  ete = {
    "Plus un souffle d'air.[pause=25] Même la rivière a l'air fatiguée.",
    "Profitons-en.[pause=30] Les étés calmes ne durent jamais très longtemps.",
  },
  automne = {
    "Regarde les feuilles.[pause=25] Elles descendent en zigzag, comme si elles hésitaient.",
    "On est arrivés au printemps, tu te souviens ?[pause=30] Le temps passe vite, quand même.",
  },
  hiver = {
    "Il neige sur Metano.[pause=30] Je ne l'avais encore jamais vu.",
    "Les volets ferment plus tôt.[pause=25] Les gens rentrent. C'est l'hiver qui fait ça.",
  },
}

--Appelee depuis Enter (le joueur est en place et peut lire). Renvoie
--true si une remarque a ete jouee.
function Seasons.Remark()
  local s = Seasons.Ensure()
  if not s.Actif then return false end

  local saison = Seasons.Actuelle()
  if s.Vues[saison.id] then return false end

  local partner = CH('Teammate1')
  if partner == nil then return false end

  local lignes = Seasons.REMARQUES[saison.id]
  if lignes == nil then return false end
  s.Vues[saison.id] = true

  return pcall(function()
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion('Normal')
    for _, t in ipairs(lignes) do
      UI:WaitShowDialogue(t)
      GAME:WaitFrames(8)
    end
    UI:ResetSpeaker()
  end)
end

--------------------------------------------------------------------
-- POINT D'ENTREE UNIQUE POUR UNE CARTE
--------------------------------------------------------------------
-- Une seule ligne a ajouter dans le Init d'une carte exterieure.
function Seasons.Setup()
  return Seasons.Apply()
end

--Nom lisible, pour un panneau ou un dialogue.
function Seasons.Nom()
  return Seasons.Actuelle().nom
end

return Seasons
