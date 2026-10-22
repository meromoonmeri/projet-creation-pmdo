--[[
    TownVoicesNight.lua

    LA VILLE PARLE DE LA NUIT — TOUS LES HABITANTS, SANS EXCEPTION
    ================================================================
    LA DIRECTIVE
    ------------------------------------------------------------------
    « Le monde doit etre vivant : il faut des dialogues pour tous les
    cas de figure, aucun PNJ ne doit etre delaisse. »

    Un raid nocturne concerne TOUTE la ville. Si seuls trois habitants
    y reagissent, les autres deviennent des decors qui n'ont rien vu —
    et le joueur comprend tres vite que l'evenement n'existait que pour
    lui. Ce module comble ce trou : les 38 PNJ de Metano ont chacun
    leur mot sur la nuit passee.

    ------------------------------------------------------------------
    DEUX ETATS, PAS UN
    ------------------------------------------------------------------
      'defendue'  la nuit a ete gagnee. La ville ne sait pas toujours
                  QUI l'a defendue — beaucoup n'ont rien vu, et c'est
                  precisement ce qui rend la scene juste.
      'pillee'    la nuit a ete perdue. Chacun compte ce qu'il a perdu,
                  et personne n'accuse le heros : c'est pire.

    L'etat vient de TownReward.CityMood(), qui lit SV.TownPlunder et
    SV.TownRaid. Un seul point de verite, pas de duplication.

    ------------------------------------------------------------------
    PRINCIPE D'ECRITURE : CHACUN PARLE DE SON METIER
    ------------------------------------------------------------------
    Un marchand compte son stock. Un enfant repete ce qu'il a entendu
    a travers la cloison. Un garde s'excuse. Un ancien compare. Personne
    ne dit « bravo pour cette nuit » : chacun dit ce que SA nuit a ete.
    C'est la seule facon d'avoir 38 repliques qui ne se ressemblent pas.

    ------------------------------------------------------------------
    COMMENT CE MODULE S'INSERE
    ------------------------------------------------------------------
    Il se branche EN AMONT de TownVoices, exactement comme TownVoices se
    branche en amont des dialogues de chapitre :

        TownVoicesNight.Talk(inst)   -- la nuit, si elle a eu lieu
          -> TownVoices.Talk(inst, ch)  -- l'avancement du chapitre
            -> dialogue de chapitre d'origine

    Il ne SUPPRIME rien. Si un PNJ n'a pas de fiche ici, ou si la nuit
    n'a rien donne, il rend false et la chaine continue normalement.
    Une seule reaction par PNJ et par nuit : on ne radote pas.

    ------------------------------------------------------------------
    REGLES DU PROJET
    ------------------------------------------------------------------
    * Jamais « Necrozma », « Eternatus », « l'Abime », « prison ».
    * La Voix ne parle jamais en ville.
    * Ne nomme aucun personnage des jeux d'origine.
    * Texte litteral francais (module global).
    * 1 a 2 phrases par boite, < 150 caracteres hors [pause=N].
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.TownReward'

TownVoicesNight = {}

--------------------------------------------------------------------
-- ETAT
--------------------------------------------------------------------
function TownVoicesNight.Ensure()
  if SV.TownVoicesNight == nil then SV.TownVoicesNight = {} end
  local s = SV.TownVoicesNight
  if s.Said == nil then s.Said = {} end    --[inst] = jour ou il a deja parle
  return s
end

--------------------------------------------------------------------
-- LES FICHES — 38 habitants, deux humeurs chacun
--------------------------------------------------------------------
-- [Instance] = { emo, defendue, pillee }
TownVoicesNight.LINES = {

  ---- LES DOUZE COMMERCANTS (MapChars de la carte) ----
  Shop_Owner = { emo = 'Happy',
    defendue = "J'ai ouvert sans rien vérifier ce matin.[pause=30] Première fois depuis longtemps.",
    pillee   = "Tout est parti.[pause=25] Les rayons, la réserve, jusqu'aux cageots vides." },

  Bank_Owner = { emo = 'Normal',
    defendue = "Le coffre n'a pas bougé.[pause=25] Je l'ai ouvert trois fois pour m'en assurer.",
    pillee   = "Ils savaient où frapper.[pause=30] Ça, ça m'inquiète plus que la somme." },

  Storage_Owner = { emo = 'Worried',
    defendue = "Rien ne manque au dépôt.[pause=25] J'ai recompté deux fois. Deux.",
    pillee   = "Des caisses éventrées.[pause=30] Ils n'ont même pas pris le temps de choisir." },

  Musician = { emo = 'Normal',
    defendue = "J'ai joué doux ce matin.[pause=25] Ça se sentait, que les gens avaient dormi.",
    pillee   = "Personne n'écoute aujourd'hui.[pause=30] Alors je joue pour moi. C'est déjà ça." },

  Swap_Owner = { emo = 'Happy',
    defendue = "Mon comptoir est intact.[pause=25] Venez échanger, j'ai le cœur généreux ce matin.",
    pillee   = "Ils ont fouillé mes bacs.[pause=30] Ce qu'ils ont pris n'avait aucune valeur. Ça m'agace." },

  Red_Merchant = { emo = 'Normal',
    defendue = "J'ai dormi sous mon étal, comme toujours.[pause=25] Cette nuit, j'ai bien dormi.",
    pillee   = "J'ai tout vu.[pause=30] Je n'ai pas bougé. Je n'en suis pas fier." },

  Green_Merchant = { emo = 'Worried',
    defendue = "On m'avait dit de plier boutique.[pause=25] J'ai bien fait de rester.",
    pillee   = "Je remballe.[pause=30] Quelques jours. Le temps que ça se calme." },

  Appraisal = { emo = 'Normal',
    defendue = "Une nuit calme rend les objets plus lisibles.[pause=25] Ne me demandez pas pourquoi.",
    pillee   = "Ils ont pris des boîtes sans savoir ce qu'il y avait dedans.[pause=30] Des amateurs." },

  Tutor_Owner = { emo = 'Normal',
    defendue = "Mes élèves sont tous venus ce matin.[pause=30] Tous. C'est rare.",
    pillee   = "La leçon d'aujourd'hui est annulée.[pause=25] Personne n'a la tête à ça." },

  Growlithe = { emo = 'Sad',
    defendue = "Rien à signaler sur mon secteur.[pause=25] Pour une fois, ça veut dire quelque chose.",
    pillee   = "J'étais de repos.[pause=30] Wouf... J'aurais dû être dehors." },

  TM_Owner = { emo = 'Normal',
    defendue = "Mes disques sont tous là.[pause=25] Chacun dans sa case.",
    pillee   = "Ils ont pris au hasard.[pause=30] Trois disques dont ils ne sauront rien faire." },

  Legend_Merchant = { emo = 'Worried',
    defendue = "J'ai gardé l'étal bâché toute la nuit.[pause=30] Prudence de vieux marchand.",
    pillee   = "Ils ont tiré sur ma bâche.[pause=25] Ils n'ont pas trouvé l'ouverture. Tant mieux pour eux." },

  ---- LES HABITANTS DU MARCHE ET DES MAISONS ----
  Gulpin = { emo = 'Happy',
    defendue = "Le marché est ouvert, donc je mange.[pause=25] La logique est implacable.",
    pillee   = "Plus rien à goûter nulle part.[pause=30] C'est une catastrophe. Une vraie." },

  Lickitung = { emo = 'Normal',
    defendue = "J'ai préparé double portion ce matin.[pause=25] Je ne sais pas pour qui. Ça viendra.",
    pillee   = "Ma réserve est vide.[pause=30] Je cuisinerai avec ce qui reste. On mangera quand même." },

  Bellossom = { emo = 'Sad',
    defendue = "Mes fleurs n'ont pas été piétinées.[pause=25] J'avais si peur en descendant.",
    pillee   = "Ils ont marché dans mes bacs.[pause=30] Ça repoussera. Ça repousse toujours." },

  Roselia = { emo = 'Worried',
    defendue = "J'ai entendu du bruit, puis plus rien.[pause=30] Le « plus rien » m'a rassurée.",
    pillee   = "Je n'irai pas cueillir aujourd'hui.[pause=25] Pas seule, en tout cas." },

  Wooper_Boy = { emo = 'Happy',
    defendue = "Maman dit qu'il s'est rien passé ![pause=25] Mais j'ai entendu, moi !",
    pillee   = "Y a des grands qui pleurent au marché.[pause=30] J'aime pas quand les grands pleurent." },

  Wooper_Girl = { emo = 'Worried',
    defendue = "J'ai fait un cauchemar.[pause=25] Après, c'était fini. Quelqu'un l'a chassé.",
    pillee   = "On a dormi tous ensemble dans la même pièce.[pause=30] Papa a poussé l'armoire." },

  Marill = { emo = 'Normal',
    defendue = "Le petit a dormi d'une traite.[pause=30] Vous ne pouvez pas savoir ce que ça vaut.",
    pillee   = "Je n'ai pas fermé l'œil.[pause=25] Je comptais les bruits." },

  Azumarill = { emo = 'Worried',
    defendue = "Ma porte tient encore.[pause=25] Je l'avais bloquée avec une chaise. Pour rien.",
    pillee   = "Ils ont essayé chez moi.[pause=30] La chaise a tenu. La chaise." },

  Nidoking = { emo = 'Normal',
    defendue = "Je suis sorti sur le pas de ma porte.[pause=25] C'était déjà réglé.",
    pillee   = "Je suis sorti trop tard.[pause=30] Cinq secondes plus tôt et je les avais." },

  Nidoqueen = { emo = 'Worried',
    defendue = "Les petits n'ont rien su.[pause=25] C'est tout ce que je demandais.",
    pillee   = "J'ai menti aux petits ce matin.[pause=30] J'ai dit que c'était le vent." },

  Nidorina = { emo = 'Happy',
    defendue = "On peut rejouer dehors ![pause=25] Maman a dit oui !",
    pillee   = "Interdiction de sortir aujourd'hui.[pause=30] Même dans la cour." },

  Nidoran_Male = { emo = 'Normal',
    defendue = "J'ai rien vu, j'ai rien entendu, j'ai super bien dormi.",
    pillee   = "J'ai tout entendu.[pause=25] Je faisais semblant de dormir." },

  Medicham = { emo = 'Normal',
    defendue = "J'ai médité jusqu'à l'aube.[pause=30] L'air était clair. Vraiment clair.",
    pillee   = "Impossible de me concentrer ce matin.[pause=25] La ville a les nerfs à vif." },

  Meditite = { emo = 'Worried',
    defendue = "Mon maître dit que le calme se mérite.[pause=30] Je crois que je comprends mieux.",
    pillee   = "On s'entraîne deux fois plus aujourd'hui.[pause=25] Ordre du maître." },

  Machamp = { emo = 'Happy',
    defendue = "Personne n'a eu besoin de mes bras cette nuit.[pause=30] C'est le meilleur des compliments.",
    pillee   = "Donnez-moi un nom et une direction.[pause=25] Je m'occupe du reste." },

  Manectric = { emo = 'Normal',
    defendue = "J'ai fait le tour du quartier au matin.[pause=25] Pas une trace. Rien.",
    pillee   = "Je suis leur piste depuis l'aube.[pause=30] Elle s'arrête à la rivière. Toujours." },

  Luxray = { emo = 'Worried',
    defendue = "Je vois bien dans le noir.[pause=30] Cette nuit, il n'y avait rien à voir.",
    pillee   = "J'ai vu leurs yeux.[pause=25] Ils ne clignaient pas. Pas une fois." },

  Electrike = { emo = 'Happy',
    defendue = "J'ai aboyé une fois, et puis plus rien ![pause=25] Ça a marché !",
    pillee   = "J'ai aboyé toute la nuit.[pause=30] Personne n'est venu. Je suis fatigué." },

  Spinda = { emo = 'Normal',
    defendue = "Je me suis endormi dehors.[pause=25] Il paraît que j'ai eu de la chance.",
    pillee   = "Je me suis endormi dehors.[pause=30] Ils m'ont enjambé. Enjambé !" },

  Ludicolo = { emo = 'Happy',
    defendue = "La musique reprend ce soir ![pause=25] On a une bonne raison de danser.",
    pillee   = "Pas de musique aujourd'hui.[pause=30] Ce serait indécent." },

  Jigglypuff = { emo = 'Normal',
    defendue = "J'ai chanté une berceuse par la fenêtre.[pause=30] Peut-être que ça a aidé.",
    pillee   = "Ma voix n'a servi à rien cette nuit.[pause=25] Ça ne m'était jamais arrivé." },

  Vileplume = { emo = 'Worried',
    defendue = "Mon parfum éloigne beaucoup de choses.[pause=30] Pas tout, mais beaucoup.",
    pillee   = "Ils sont passés à travers mon parfum.[pause=25] Ça veut dire qu'ils ne respirent pas." },

  Gloom = { emo = 'Sad',
    defendue = "J'ai eu peur pour rien.[pause=30] C'est la meilleure sorte de peur.",
    pillee   = "J'ai eu raison d'avoir peur.[pause=25] Ça ne me console pas du tout." },

  Oddish = { emo = 'Worried',
    defendue = "Je me suis enterré jusqu'aux feuilles.[pause=30] Je ressors seulement maintenant.",
    pillee   = "Je suis resté sous terre toute la nuit.[pause=25] Je les ai sentis passer au-dessus." },

  Furret = { emo = 'Normal',
    defendue = "J'ai vérifié tous les terriers du quartier.[pause=25] Tout le monde est là.",
    pillee   = "Je fais le tour des terriers.[pause=30] Pour l'instant, tout le monde répond." },

  Linoone = { emo = 'Happy',
    defendue = "J'ai couru jusqu'au pont et retour.[pause=25] Rien à signaler. Deux fois rien.",
    pillee   = "J'ai couru après eux.[pause=30] Je cours vite. Pas assez, visiblement." },

  Sentret = { emo = 'Worried',
    defendue = "J'étais debout sur ma queue toute la nuit.[pause=30] Ça sert, finalement.",
    pillee   = "J'ai crié pour prévenir.[pause=25] Ma voix ne porte pas assez loin." },

  Butterfree = { emo = 'Normal',
    defendue = "Le ciel était dégagé cette nuit.[pause=25] Rien ne volait. Rien du tout.",
    pillee   = "Quelque chose volait au-dessus des toits.[pause=30] Ce n'était pas un oiseau." },

  Camerupt = { emo = 'Worried',
    defendue = "Le petit a dormi contre moi.[pause=30] Il n'a rien senti.",
    pillee   = "Le petit a tout vu.[pause=25] Je n'ai pas pu lui cacher." },

  Numel = { emo = 'Sad',
    defendue = "Je voulais sortir me battre ![pause=25] Maman a dit non. Elle avait raison.",
    pillee   = "J'aurais pu les brûler.[pause=30] Maman m'a retenu. Je lui en veux un peu." },

  Quagsire = { emo = 'Normal',
    defendue = "La rivière était calme.[pause=30] Elle est toujours calme, remarquez.",
    pillee   = "J'ai retrouvé des affaires à nous dans l'eau.[pause=25] Ils ont jeté ce qui ne servait pas." },

  Floatzel = { emo = 'Happy',
    defendue = "J'ai patrouillé la berge jusqu'au matin.[pause=25] Personne n'est passé par l'eau.",
    pillee   = "Ils sont partis par la rivière.[pause=30] Je n'ai vu que les remous." },

  Mawile = { emo = 'Normal',
    defendue = "Ma porte est renforcée.[pause=25] Mais c'est bien de ne pas avoir eu à le vérifier.",
    pillee   = "Ils ont essayé ma porte en dernier.[pause=30] Ils ont vite compris." },

  Doduo = { emo = 'Worried',
    defendue = "Une tête dormait, l'autre veillait.[pause=30] Comme toujours. Cette fois ça allait.",
    pillee   = "Mes deux têtes ont crié en même temps.[pause=25] Ça n'a servi à rien." },

  Spheal = { emo = 'Happy',
    defendue = "J'ai roulé jusqu'à la place ce matin ![pause=25] Tout était en ordre !",
    pillee   = "Le marché est tout cassé.[pause=30] J'aime pas quand c'est cassé." },

  Venipede = { emo = 'Worried',
    defendue = "Je dors sous les planches.[pause=25] J'entends tout. Cette nuit : rien.",
    pillee   = "Ils ont marché juste au-dessus de moi.[pause=30] J'ai compté leurs pas. Ils étaient nombreux." },

  Bagon = { emo = 'Happy',
    defendue = "Zut, j'ai raté ça ![pause=25] La prochaine fois, réveillez-moi !",
    pillee   = "Personne ne m'a réveillé ![pause=30] J'aurais pu aider, moi !" },

  Metapod = { emo = 'Normal',
    defendue = "Je n'ai pas bougé de la nuit.[pause=30] Comme toutes les nuits. Mais bien dormi.",
    pillee   = "Je n'ai pas pu bouger.[pause=25] Vous savez ce que c'est, de ne pas pouvoir bouger ?" },

  Silcoon = { emo = 'Worried',
    defendue = "On était deux à ne pas pouvoir fuir.[pause=30] On a eu de la chance.",
    pillee   = "On s'est serrés l'un contre l'autre.[pause=25] C'est tout ce qu'on savait faire." },

  Cranidos = { emo = 'Happy',
    defendue = "La guilde a bien travaillé cette nuit ![pause=25] Je le dirai au rapport !",
    pillee   = "On a échoué.[pause=30] Ça arrive. On s'entraîne, et on recommence." },

  Mareep = { emo = 'Normal',
    defendue = "J'ai laissé ma laine briller un peu, dans la fenêtre.[pause=30] Comme une veilleuse.",
    pillee   = "J'ai éteint ma laine pour qu'ils ne me voient pas.[pause=25] Je n'en suis pas fière." },

  Snubbull = { emo = 'Worried',
    defendue = "J'ai fait ma ronde deux fois cette nuit.[pause=25] Deux fois rien à signaler.",
    pillee   = "J'étais du mauvais côté de la ville.[pause=30] Toujours du mauvais côté." },

  Zigzagoon = { emo = 'Happy',
    defendue = "J'ai trouvé trois pièces par terre ce matin ![pause=25] Personne ne les réclame !",
    pillee   = "J'ai suivi leur trace en zigzag.[pause=30] Forcément, en zigzag c'est plus long." },

  Audino = { emo = 'Normal',
    defendue = "Aucun blessé cette nuit.[pause=30] Je n'ai eu personne à soigner. Quel bonheur.",
    pillee   = "J'ai soigné six personnes ce matin.[pause=25] Des égratignures. Surtout de la peur." },

  ---- LES TROIS DE PASSAGE ----
  -- Elles ne vivent pas ici : elles jugent en professionnelles, ce qui
  -- donne un troisieme regard, ni reconnaissant ni effraye.
  Adagio = { emo = 'Normal',
    defendue = "On a entendu du bruit depuis l'auberge.[pause=30] On n'est pas descendues. Ce n'était pas notre ville.",
    pillee   = "Une ville qui se fait piller pendant que la guilde dort.[pause=25] Ça se saura." },

  Aria = { emo = 'Happy',
    defendue = "Alors comme ça on travaille la nuit ?[pause=25] Pas mal. Vraiment pas mal.",
    pillee   = "Ne faites pas cette tête.[pause=30] Tout le monde perd, un jour. Même nous." },

  Sonata = { emo = 'Worried',
    defendue = "J'ai regardé par la fenêtre.[pause=30] Vous étiez deux contre je ne sais combien.",
    pillee   = "J'aurais pu descendre vous aider.[pause=25] Adagio a dit non. Je n'ai pas insisté." },
}

--------------------------------------------------------------------
-- LA PAROLE
--------------------------------------------------------------------
-- Une seule reaction par PNJ et par journee : on ne radote pas. Le jour
-- sert de cle, donc la reaction se reactive apres la nuit suivante.
function TownVoicesNight.Talk(inst)
  local mood = TownReward.CityMood()
  if mood == nil then return false end

  local fiche = TownVoicesNight.LINES[inst]
  if fiche == nil then return false end

  local chara = CH(inst)
  if chara == nil then return false end

  local s = TownVoicesNight.Ensure()
  local today = (SV.ChapterProgression and SV.ChapterProgression.DaysPassed) or 0
  if s.Said[inst] == today then return false end

  local txt = fiche[mood]
  if txt == nil then return false end
  s.Said[inst] = today

  local ok = pcall(function()
    GeneralFunctions.StartConversation(chara, txt, fiche.emo or 'Normal')
    GeneralFunctions.EndConversation(chara)
  end)
  return ok
end

--Combien d'habitants ce module fait-il parler ?
function TownVoicesNight.Count()
  local n = 0
  for _ in pairs(TownVoicesNight.LINES) do n = n + 1 end
  return n
end

return TownVoicesNight
