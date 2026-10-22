--[[
    ComptoirVoices.lua
    Bourg du Comptoir — voix des habitants (chapitre 11 et au-dela).

    CONTEXTE NARRATIF
    -----------------
    Le heros et le partenaire arrivent au Bourg du Comptoir une dizaine
    d'annees apres l'age d'or de la ville. Les habitants ont vieilli et,
    pour la plupart, evolue : le castor maladroit du marche est devenu un
    commercant pose, la petite du bord de mer a grandi, le guetteur du
    carrefour a pris du galon.

    Aucun nom des jeux d'origine n'est employe. Les habitants sont nommes
    dans CharacterEssentials (Barnabe, Ondine, Oracle...). Le duo
    d'explorateurs d'il y a quinze ans n'est jamais nomme : on n'y fait
    allusion que par des formules indirectes, dans la continuite de
    Loaklass (altere_pond_ch_11.lua).

    REGLES APPLIQUEES
    -----------------
    * repliques de 1 a 2 phrases, < 150 caracteres hors [pause=N]
    * le heros ne parle jamais a voix haute : pensees entre parentheses
    * aucune boite de narration hors ouverture/cloture d'acte
    * toute prise de parole passe par GeneralFunctions.StartConversation
      puis EndConversation (orientation du PNJ geree par le moteur)
    * variantes en boucle deterministe sur SV.ChapterProgression.DaysPassed
]]

require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

ComptoirVoices = {}

--------------------------------------------------------------------
-- Selection de variante : boucle deterministe sur le compteur de jours.
-- Renvoie toujours un index valide meme si le compteur est absent.
--------------------------------------------------------------------
function ComptoirVoices.Pick(list)
  if list == nil or #list == 0 then return "..." end
  local day = 0
  pcall(function()
    if SV.ChapterProgression ~= nil and SV.ChapterProgression.DaysPassed ~= nil then
      day = SV.ChapterProgression.DaysPassed
    end
  end)
  return list[(day % #list) + 1]
end

--------------------------------------------------------------------
-- Fiches des habitants.
--   lines   : variantes du propos courant (boucle sur les jours)
--   emotion : emotion de portrait (validee par SetEmotion)
--------------------------------------------------------------------
ComptoirVoices.NPC = {

  -- Le marchand du marche couvert. Jadis maladroit, aujourd'hui pose.
  Bibarel = {
    emotion = 'Happy',
    lines = {
      "Bienvenue au Bourg ! Vous avez la tete de ceux qui viennent de loin.",
      "J'ai tenu cet etal toute ma vie.[pause=15] On finit par reconnaitre les voyageurs.",
      "Prenez votre temps pour visiter.[pause=10] La ville ne se laisse pas lire en un jour.",
      "Quand j'etais jeune, je bafouillais devant les clients.[pause=15] Ca passe, avec les annees.",
      "Le port ne desemplit pas.[pause=10] C'est bon signe pour le commerce.",
    },
  },

  -- Grande soeur du bord de mer, devenue posee et maternelle.
  Azumarill = {
    emotion = 'Normal',
    lines = {
      "Ne vous eloignez pas trop du rivage.[pause=15] Les courants sont traitres par ici.",
      "Ma petite soeur me suit partout.[pause=10] Elle a grandi, mais l'habitude est restee.",
      "Vous venez du continent ?[pause=15] On voit ca a la facon dont vous regardez la mer.",
      "L'eau est claire ce matin.[pause=10] C'est rare, en cette saison.",
    },
  },

  -- La petite soeur. Vive, curieuse, un peu trop bavarde.
  Marill_Jeune = {
    emotion = 'Joyous',
    lines = {
      "Vous avez vu la grande plage ?[pause=10] C'est la que tout le monde se retrouve !",
      "Ma grande soeur dit que je parle trop.[pause=15] Je trouve pas, moi.",
      "Il parait qu'il y a un dojo par ici.[pause=10] J'ose pas y entrer.",
      "Vous etes des explorateurs ?[pause=15] Des vrais ?[pause=10] Trop bien !",
    },
  },

  -- L'ancien du bord de route. Voix grave, souvenirs longs.
  Hypno = {
    emotion = 'Normal',
    lines = {
      "Le Bourg a connu des jours plus bruyants.[pause=20] Aujourd'hui, il se repose.",
      "Je lis un peu dans les reves.[pause=15] Les votres sont encombres, jeunes gens.",
      "On ne quitte pas cette ville.[pause=10] On y revient, toujours.",
      "Mefiez-vous des raccourcis.[pause=15] Ici, ils menent rarement ou l'on croit.",
    },
  },

  -- Gardien du cimetiere marin. Sobre, presque silencieux.
  Dusclops = {
    emotion = 'Normal',
    lines = {
      "Je veille sur ce qui reste.[pause=20] C'est un travail tranquille.",
      "Les pierres du bord de falaise ont des noms.[pause=15] Personne ne les lit plus.",
      "Vous cherchez quelqu'un ?[pause=15] Ici, on ne trouve que des souvenirs.",
    },
  },

  -- Farceur de ruelle, ton railleur mais inoffensif.
  Banette = {
    emotion = 'Special0',
    lines = {
      "Vous vous etes perdus ?[pause=15] Tout le monde se perd, la premiere fois.",
      "Le passage derriere l'etal ?[pause=10] Il ne mene nulle part.[pause=15] Enfin, presque.",
      "Ne suivez pas les panneaux les yeux fermes.[pause=15] Ils datent d'avant moi.",
    },
  },

  -- Fleuriste du haut de la ville.
  Beautifly = {
    emotion = 'Happy',
    lines = {
      "Les fleurs tiennent bien, cette annee.[pause=15] Le sel ne les gene plus.",
      "J'ai passe mon enfance a ramper sur ces murs.[pause=15] On change, heureusement.",
      "Prenez l'allee du haut.[pause=10] La vue vaut le detour.",
    },
  },

  -- Guetteur du carrefour nord.
  Nuzleaf = {
    emotion = 'Normal',
    lines = {
      "Le carrefour mene partout.[pause=15] Encore faut-il savoir ou l'on va.",
      "Trois routes, trois humeurs.[pause=10] Choisissez celle qui vous ressemble.",
      "Je surveille les allees et venues.[pause=15] Par habitude, plus que par devoir.",
    },
  },

  -- Ancien messager, fier de son passe.
  Pidgeot = {
    emotion = 'Determined',
    lines = {
      "J'ai porte le courrier de cette ville pendant des annees.[pause=15] Sans jamais un retard.",
      "Le vent du large est capricieux.[pause=10] Il faut le connaitre pour le monter.",
      "Vous voyagez a pied ?[pause=15] Courageux.[pause=10] Moi, je prenais l'air.",
    },
  },

  -- Pecheur bourru du ponton.
  Crawdaunt = {
    emotion = 'Angry',
    lines = {
      "Ne restez pas plantes sur le ponton.[pause=15] Vous faites fuir le poisson.",
      "Trente ans que je pose mes casiers ici.[pause=15] Je sais ou ils mordent.",
      "La mer ne pardonne pas l'impatience.[pause=10] Retenez ca.",
    },
  },

  -- Colosse assoupi devant l'entrepot.
  Slaking = {
    emotion = 'Sigh',
    lines = {
      "Mmh...[pause=20] Vous voulez passer ?[pause=15] Contournez, c'est plus simple.",
      "Je garde l'entrepot.[pause=15] Assis.[pause=10] C'est plus efficace qu'on ne croit.",
      "Reveillez-moi s'il y a du grabuge.[pause=20] Sinon, laissez-moi.",
    },
  },

  -- Coursier rapide, phrases breves.
  Swellow = {
    emotion = 'Normal',
    lines = {
      "Pas le temps de bavarder.[pause=10] Deux livraisons en retard.",
      "Vous cherchez le carrefour ?[pause=10] Plein est, vous ne pouvez pas le rater.",
      "Si vous avez un pli a faire porter, c'est moi.[pause=15] Tarif honnete.",
    },
  },

  -- Tenancier de l'echoppe electrique.
  Electivire = {
    emotion = 'Normal',
    lines = {
      "L'echoppe est ouverte.[pause=15] Entrez, ou ne bloquez pas l'entree.",
      "Je repare ce qui se repare.[pause=10] Le reste, je le rachete.",
      "Le panneau dehors est a moi.[pause=15] Lisez-le, ca m'evitera de repeter.",
    },
  },

  -- L'oracle de la ville. Grave, jamais explicite.
  Xatu = {
    emotion = 'Normal',
    lines = {
      "Je regarde loin.[pause=20] Parfois trop loin pour le dire simplement.",
      "Vous portez quelque chose qui n'est pas a vous.[pause=20] Pas un objet.",
      "Le ciel a change de couleur, il y a des annees.[pause=20] Peu l'ont remarque.",
      "Ne me demandez pas ce qui vient.[pause=15] Demandez-vous ce que vous ferez.",
    },
  },

  -- Marchande ambulante, jumelle de l'autre etal.
  PurpleKecleon = {
    emotion = 'Happy',
    lines = {
      "Mon frere tient l'etal d'a cote.[pause=15] Nos prix ne sont pas les memes.",
      "Article rare aujourd'hui.[pause=10] Enfin, rare pour qui sait regarder.",
      "Vous revenez demain ?[pause=15] Le stock tourne vite.",
    },
  },

  -- Maitre du dojo, sec et direct.
  Marowak = {
    emotion = 'Determined',
    lines = {
      "Le dojo est ouvert aux equipes serieuses.[pause=15] Les autres perdent mon temps.",
      "On n'apprend pas a se battre en regardant.[pause=15] Entrez, ou passez votre chemin.",
      "J'ai forme des generations d'explorateurs.[pause=20] Peu s'en souviennent.",
    },
  },
}

--------------------------------------------------------------------
-- Prise de parole standard d'un habitant.
-- Sous pcall : une fiche absente ne doit jamais bloquer le joueur.
--------------------------------------------------------------------
function ComptoirVoices.Talk(chara, key)
  if chara == nil then return end
  local fiche = ComptoirVoices.NPC[key]
  if fiche == nil then
    -- Repli neutre : le PNJ existe sur la carte mais n'a pas de fiche.
    GeneralFunctions.StartConversation(chara, "...", 'Normal')
    GeneralFunctions.EndConversation(chara)
    return
  end
  local ok = pcall(function()
    GeneralFunctions.StartConversation(chara,
      ComptoirVoices.Pick(fiche.lines), fiche.emotion or 'Normal')
    GeneralFunctions.EndConversation(chara)
  end)
  if not ok then
    pcall(function() GeneralFunctions.EndConversation(chara) end)
  end
end

return ComptoirVoices
