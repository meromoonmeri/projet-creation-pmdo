--[[
    TownLife.lua
    LA VIE QUOTIDIENNE DE METANO TOWN.

    Ce que le joueur doit ressentir : la ville n'attend pas qu'on la
    traverse. D'un jour a l'autre, les habitants ne sont pas au meme
    endroit, ne font pas la meme chose, et n'ont pas la meme chose a dire.

    -------------------------------------------------------------------
    POURQUOI CE MODULE EXISTE
    -------------------------------------------------------------------
    Jusqu'ici les PNJ de Metano etaient places par des coordonnees ECRITES
    EN DUR dans metano_town_ch_N.SetupGround(). Consequence : un PNJ
    n'occupe qu'une seule position pour tout un chapitre, et ne bouge
    qu'au franchissement d'une etape d'histoire. Le joueur qui revient le
    lendemain retrouve exactement la meme ville, figee.

    Un module `npc_routines.lua` existait deja, mais :
      * il n'etait branche que sur les chapitres 8, 9 et 10 ;
      * ses points de passage ont ete verifies contre la grille de
        collision reelle (tools/nea_map.py) : 8 des 11 tombent DANS UN
        MUR. Les PNJ y marchaient donc vers des obstacles.

    TownLife repart d'une base sure : TOUS les postes utilises ici sont
    des positions ou un PNJ a DEJA ete place dans les chapitres 1 a 4,
    donc du contenu deja teste en jeu, et chacune a ete revalidee libre
    en boite 20x20 sur metano_town.rsground.

    -------------------------------------------------------------------
    PRINCIPE
    -------------------------------------------------------------------
    Chaque PNJ a une TOURNEE : une liste de postes attestes. Le poste du
    jour est choisi par `DaysPassed % nombre_de_postes`. C'est
    deterministe (deux visites le meme jour donnent la meme ville, pas de
    PNJ qui saute d'un endroit a l'autre pendant qu'on marche) et ca
    tourne vraiment (le cycle complet prend autant de jours qu'il y a de
    postes).

    La meme cle de jour selectionne la REPLIQUE du jour, de sorte que la
    position et le propos restent d'accord : un PNJ au marche parle du
    marche.
]]
require 'origin.common'
require 'halcyon.CharacterEssentials'
require 'halcyon.GeneralFunctions'

TownLife = {}

--------------------------------------------------------------------
-- Le jour courant. DaysPassed est incremente par GeneralFunctions
-- (l.205) a chaque fin de journee ; c'est le compteur deja utilise par
-- NightWatch, TownRaid et TownVoicesNight.
--------------------------------------------------------------------
function TownLife.Today()
  local d = 0
  pcall(function()
    d = (SV.ChapterProgression and SV.ChapterProgression.DaysPassed) or 0
  end)
  return d
end

--------------------------------------------------------------------
-- TOURNEES.
-- Chaque entree : { {x, y, Direction, zone}, ... }
-- `zone` sert a choisir la replique du jour : le PNJ parle de la ou il
-- se trouve.
--
-- Toutes ces coordonnees proviennent des chapitres 1 a 4 et ont ete
-- revalidees libres sur la carte. Ne pas en inventer de nouvelles sans
-- les passer par tools/nea_map.py.
--------------------------------------------------------------------
TownLife.TOURNEES = {
  Mawile = {
    { 320, 1208, Direction.Left,      'tentes'  },
    { 648, 1272, Direction.Down,      'sud'     },
    { 768,  600, Direction.Down,      'guilde'  },
    {1040, 1208, Direction.DownRight, 'est'     },
    {1204, 1156, Direction.Down,      'est'     },
  },
  Electrike = {
    { 232,  872, Direction.Left,      'ouest'   },
    { 272, 1056, Direction.Right,     'sud'     },
    { 288,  992, Direction.DownRight, 'ouest'   },
    { 344,  976, Direction.Down,      'ouest'   },
    { 400,  400, Direction.Right,     'nord'    },
  },
  Sentret = {
    { 388,  716, Direction.Right,     'centre'  },
    { 400,  424, Direction.DownRight, 'nord'    },
    { 416,  720, Direction.DownRight, 'centre'  },
    { 432,  432, Direction.Left,      'nord'    },
  },
  Manectric = {
    {1144,  904, Direction.Down,      'est'     },
    {1204, 1144, Direction.DownRight, 'est'     },
    {1256,  336, Direction.UpRight,   'nord'    },
    {1256,  360, Direction.DownLeft,  'nord'    },
  },
  Wooper_Girl = {
    { 306, 1036, Direction.DownLeft,  'sud'     },
    { 328, 1000, Direction.Right,     'ouest'   },
    { 352,  952, Direction.DownRight, 'ouest'   },
    { 392,  448, Direction.UpRight,   'nord'    },
  },
  Wooper_Boy = {
    { 306, 1076, Direction.UpLeft,    'sud'     },
    { 360, 1000, Direction.Left,      'ouest'   },
    { 440,  448, Direction.UpLeft,    'nord'    },
    { 744, 1144, Direction.Right,     'sud'     },
  },
  Meditite = {
    { 416,  416, Direction.Down,      'nord'    },
    { 440,  400, Direction.Left,      'nord'    },
    { 556,  216, Direction.Down,      'nord'    },
  },
  Machamp = {
    { 576,  704, Direction.Down,      'centre'  },
    { 760,  600, Direction.Down,      'guilde'  },
    {1264,  352, Direction.Down,      'nord'    },
  },
  Luxray = {
    { 304, 1024, Direction.Down,      'sud'     },
    { 320, 1016, Direction.UpRight,   'sud'     },
    { 624,  600, Direction.Down,      'centre'  },
  },
  Gloom = {
    { 512,  184, Direction.DownRight, 'nord'    },
    { 536,  208, Direction.UpLeft,    'nord'    },
    { 864,  360, Direction.Left,      'nord'    },
  },
  Oddish = {
    { 408,  396, Direction.DownLeft,  'nord'    },
    { 440,  424, Direction.DownLeft,  'nord'    },
  },
  Numel = {
    { 400,  432, Direction.Right,     'nord'    },
    { 420,  456, Direction.Up,        'nord'    },
  },
  Bellossom = {
    { 472,  608, Direction.UpLeft,    'centre'  },
    { 478,  686, Direction.Down,      'centre'  },
  },
  Zigzagoon = {
    { 200,  688, Direction.UpRight,   'ouest'   },
    {1232,  360, Direction.Up,        'nord'    },
  },
  Nidoking = {
    {1136,  896, Direction.Left,      'est'     },
    {1160,  912, Direction.Left,      'est'     },
  },
  Roselia = {
    {1204, 1128, Direction.Down,      'est'     },
    {1224, 1128, Direction.DownLeft,  'est'     },
  },
  Spinda = {
    {1184, 1160, Direction.UpRight,   'est'     },
    {1204, 1160, Direction.Up,        'est'     },
  },
  Ludicolo = {
    {1184, 1128, Direction.DownRight, 'est'     },
    {1224, 1160, Direction.UpLeft,    'est'     },
  },
}

--------------------------------------------------------------------
-- Poste du jour d'un PNJ. Rend nil si le PNJ n'a pas de tournee.
--------------------------------------------------------------------
function TownLife.PosteDuJour(nom)
  local t = TownLife.TOURNEES[nom]
  if t == nil or #t == 0 then return nil end
  local i = (TownLife.Today() % #t) + 1
  return t[i]
end

--------------------------------------------------------------------
-- Place un PNJ a son poste du jour et lui donne une aire d'errance
-- autour. L'aire est volontairement petite (48 px) : le PNJ vit sur
-- place, il ne traverse pas la ville en diagonale pendant que le joueur
-- lui parle.
--
-- Rend le poste applique, pour que l'appelant sache ou il est.
--------------------------------------------------------------------
function TownLife.Placer(chara, nom)
  if chara == nil then return nil end
  local poste = TownLife.PosteDuJour(nom)
  if poste == nil then return nil end

  pcall(function()
    GROUND:TeleportTo(chara, poste[1], poste[2], poste[3])
  end)
  --Errance locale : le PNJ bouge un peu autour de son poste. Meme
  --patron que metano_town.CreateWalkArea (init.lua:157-170), avec une
  --aire reduite pour qu'il reste identifiable a son poste.
  pcall(function()
    AI:SetCharacterAI(chara, "halcyon.ai.ground_default",
      RogueElements.Loc(poste[1] - 24, poste[2] - 24),
      RogueElements.Loc(48, 48),
      1, 16, 32, 40, 180)
  end)
  return poste
end

--------------------------------------------------------------------
-- REPLIQUES DU JOUR.
--
-- Trois axes se croisent pour qu'un PNJ ne se repete jamais a
-- l'identique deux jours de suite :
--   1. la ZONE ou il se trouve aujourd'hui (il parle de ce qu'il voit) ;
--   2. le JOUR (rotation dans les repliques de cette zone) ;
--   3. l'ETAT DE L'HISTOIRE (une ville qui vient de voir revenir une
--      expedition ne parle pas comme une ville ordinaire).
--
-- L'axe 3 prime : si un evenement marquant vient d'avoir lieu, tout le
-- monde en parle. C'est la regle « un PNJ ne doit jamais parler d'une
-- facon qui ignore ce qu'il devrait savoir a cet instant ».
--------------------------------------------------------------------
TownLife.PROPOS = {
  guilde = {
    "La guilde ne dort jamais vraiment.[pause=0] Il y a toujours une lampe allumée là-haut.",
    "J'ai vu passer une équipe ce matin,[pause=10] sacs pleins.[pause=0] Ça sentait le départ.",
    "On reconnaît les apprentis à leur façon de marcher.[pause=0] Trop vite,[pause=10] toujours.",
  },
  marche = {
    "Les Kecleon ont changé leur étal de place.[pause=0] Encore.",
    "Tout est plus cher qu'hier.[pause=20] Enfin,[pause=10] c'est ce que je dis tous les jours.",
    "Si tu cherches quelque chose de rare,[pause=10] reviens tôt le matin.",
  },
  centre = {
    "C'est le meilleur endroit pour voir qui entre et qui sort.",
    "Je me mets là pour le soleil.[pause=0] Demain je serai peut-être ailleurs.",
    "Il y a du monde aujourd'hui.[pause=0] Ou alors c'est moi qui remarque.",
  },
  nord = {
    "Le vent vient du nord ces temps-ci.[pause=0] Il ramène des odeurs de montagne.",
    "On voit les crêtes d'ici,[pause=10] quand le ciel est dégagé.",
    "Les fleurs du nord ouvrent plus tard que les autres.[pause=0] Elles attendent.",
  },
  sud = {
    "Au sud c'est plus calme.[pause=0] C'est pour ça que je viens.",
    "Les tentes du sud se remplissent dès qu'une équipe rentre.",
    "J'aime bien ce coin.[pause=0] On y entend la rivière.",
  },
  est = {
    "De ce côté, on entend le marché sans être dedans.[pause=0] Le bon compromis.",
    "Il paraît qu'ils vont agrandir par ici.[pause=20] Il paraît.",
    "J'ai mes habitudes à l'est.[pause=0] Enfin,[pause=10] certains jours.",
  },
  ouest = {
    "La route de l'ouest mène aux donjons.[pause=0] Je regarde partir les autres.",
    "On croise des têtes fatiguées par ici,[pause=10] le soir.",
    "L'ouest, c'est le côté des départs.[pause=0] Et des retours,[pause=10] parfois.",
  },
  tentes = {
    "Les tentes tiennent bon.[pause=0] C'est déjà ça.",
    "J'ai planté la mienne ici.[pause=0] Demain ?[pause=20] On verra bien.",
    "Dormir dehors, ça ne me dérange pas.[pause=0] C'est le bruit qui me réveille.",
  },
}

--Repliques qui PRIMENT sur la zone, selon l'etat de l'histoire.
--Elles repondent a l'evenement le plus recent que le PNJ peut connaitre.
TownLife.PROPOS_EVENEMENT = {
  {
    test = function()
      return SV.ChapterProgression.Chapter >= 6
         and SV.Chapter5 and SV.Chapter5.FinishedExpedition
    end,
    lignes = {
      "Tu étais de l'expédition, non ?[pause=0] Toute la ville en parle encore.",
      "On dit que la montagne s'est allumée.[pause=20] Moi je n'ai rien vu,[pause=10] je dormais.",
      "Ma voisine jure avoir senti le sol trembler cette nuit-là.[pause=0] Je la crois,[pause=10] figure-toi.",
    },
  },
  {
    test = function()
      return SV.ChapterProgression.Chapter >= 6
         and SV.Chapter6 and SV.Chapter6.DazzlingIntroPlayed
    end,
    lignes = {
      "Trois nouvelles têtes sur la place.[pause=0] Élégantes,[pause=10] et elles le savent.",
      "Une équipe de la côte, paraît-il.[pause=0] Elles n'ont pas l'air d'être là pour rien.",
    },
  },
}

--------------------------------------------------------------------
-- La replique du jour pour un PNJ, selon son poste et l'histoire.
--------------------------------------------------------------------
function TownLife.ProposDuJour(nom)
  local jour = TownLife.Today()

  --1. L'histoire prime : le dernier evenement marquant connu.
  for _, ev in ipairs(TownLife.PROPOS_EVENEMENT) do
    local ok, vrai = pcall(ev.test)
    if ok and vrai then
      --Une chance sur deux d'en parler, pour que la ville ne devienne
      --pas un choeur qui repete la meme chose. Deterministe par jour.
      if (jour + string.len(nom)) % 2 == 0 then
        local l = ev.lignes
        return l[((jour + string.len(nom)) % #l) + 1]
      end
      break
    end
  end

  --2. Sinon, le propos de la zone du jour.
  local poste = TownLife.PosteDuJour(nom)
  local zone = poste and poste[4] or 'centre'
  local l = TownLife.PROPOS[zone] or TownLife.PROPOS.centre
  return l[((jour + string.len(nom)) % #l) + 1]
end

--------------------------------------------------------------------
-- Interaction complete avec un habitant : il se tourne vers le heros,
-- dit son mot du jour, puis reprend son activite.
--
-- Passe par StartConversation/EndConversation, qui gerent deja le
-- retournement du partenaire et la restauration de la direction
-- d'origine (GeneralFunctions:1700 et :1731).
--------------------------------------------------------------------
function TownLife.Parler(chara, nom)
  if chara == nil then return false end
  local texte = TownLife.ProposDuJour(nom)
  if texte == nil then return false end
  GeneralFunctions.StartConversation(chara, texte, "Normal")
  GeneralFunctions.EndConversation(chara)
  return true
end

--------------------------------------------------------------------
-- Place d'un coup tous les PNJ d'une liste a leur poste du jour.
-- `liste` : { [nom] = personnage }
-- Rend le nombre de PNJ effectivement deplaces.
--------------------------------------------------------------------
function TownLife.PlacerTous(liste)
  local n = 0
  for nom, chara in pairs(liste or {}) do
    if TownLife.Placer(chara, nom) ~= nil then n = n + 1 end
  end
  return n
end

--------------------------------------------------------------------
-- MICRO-SCÈNES SOCIALES QUOTIDIENNES
--------------------------------------------------------------------
-- Une seule par journée et uniquement entre deux habitants réellement
-- présents dans la même zone de leur tournée. Aucun téléport visible :
-- ils se regardent depuis leur poste, parlent brièvement, puis reprennent
-- exactement leur IA. Une scène d'histoire garde toujours la priorité.
TownLife.SOCIAUX = {
  { 'Roselia','Spinda',
    {"Le café a encore reçu trois équipes avant midi.","Et deux rumeurs contradictoires avant le petit-déjeuner !"}},
  { 'Spinda','Ludicolo',
    {"Tu as déplacé les tables ?","Seulement celles qui gênaient ma nouvelle danse !"}},
  { 'Wooper_Girl','Wooper_Boy',
    {"Tu avais promis de ne pas aller près de la rivière.","J'ai promis de ne pas y TOMBER. Ce n'est pas pareil."}},
  { 'Machamp','Meditite',
    {"Cent flexions avant le déjeuner !","Cent respirations seraient déjà un progrès."}},
  { 'Mawile','Electrike',
    {"J'ai entendu une nouvelle au marché.","Tu entends surtout ce que les autres voulaient garder secret."}},
}

local function social_line(a,b,base)
  local ch=(SV.ChapterProgression and SV.ChapterProgression.Chapter) or 1
  if ch>=6 and SV.Chapter6 and SV.Chapter6.DazzlingChapterResolved then
    return "Les nouvelles de Gloomy Forest sont arrivées ce matin.",
           "Chenipent est sauf. C'est la seule partie du rapport qui compte."
  end
  if SV.WorldState and SV.WorldState.Weather and SV.WorldState.Weather.Current=='orage' then
    return "Les Bekipan restent au perchoir avec cet orage.",
           "Alors la ville devra inventer ses propres nouvelles aujourd'hui."
  end
  return base[1],base[2]
end

function TownLife.PlayDailySocial()
  SV.TownLife = SV.TownLife or {}
  local day=TownLife.Today()
  if SV.TownLife.SeenSocialDay==day then return false end
  local candidates={}
  for _,g in ipairs(TownLife.SOCIAUX) do
    local a,b=CH(g[1]),CH(g[2])
    local pa,pb=TownLife.PosteDuJour(g[1]),TownLife.PosteDuJour(g[2])
    if a~=nil and b~=nil and pa~=nil and pb~=nil and pa[4]==pb[4] then
      table.insert(candidates,{a=a,b=b,n1=g[1],n2=g[2],text=g[3]})
    end
  end
  if #candidates==0 then return false end
  local g=candidates[(day % #candidates)+1]
  SV.TownLife.SeenSocialDay=day
  local ok,err=pcall(function()
    GAME:CutsceneMode(true);AI:DisableCharacterAI(g.a);AI:DisableCharacterAI(g.b)
    local x=(g.a.Position.X+g.b.Position.X)//2;local y=(g.a.Position.Y+g.b.Position.Y)//2
    GAME:MoveCamera(x,y,35,false)
    GROUND:CharTurnToCharAnimated(g.a,g.b,4);GROUND:CharTurnToCharAnimated(g.b,g.a,4)
    GROUND:CharSetEmote(g.a,'notice',1);GAME:WaitFrames(15)
    local l1,l2=social_line(g.a,g.b,g.text)
    UI:SetSpeaker(g.a);GeneralFunctions.SetEmotion('Normal');UI:WaitShowDialogue(l1)
    GROUND:CharSetEmote(g.b,'happy',1);UI:SetSpeaker(g.b);GeneralFunctions.SetEmotion('Happy');UI:WaitShowDialogue(l2)
    GAME:WaitFrames(10);GeneralFunctions.PanCamera()
  end)
  pcall(function()
    AI:EnableCharacterAI(g.a);AI:EnableCharacterAI(g.b)
    TownLife.Placer(g.a,g.n1);TownLife.Placer(g.b,g.n2)
    GAME:CutsceneMode(false);UI:ResetSpeaker()
  end)
  if not ok then PrintInfo('[TownLife social] '..tostring(err)) end
  return ok
end

return TownLife
