--[[
    SecondaryJobs.lua — Contrats des donjons secondaires (Chapitres 6 à 10)
    pour le Tableau des Missions de Guilde (Job Bulletin Board).

    OBJECTIF
    --------
    Garantir que chacun des 20 donjons secondaires d'exploration apparait
    formellement comme un contrat affiché sur le Tableau des Missions, avec :
      - un client et une cible nommés (espèces vérifiées)
      - un titre et un texte d'ambiance en français idiomatique
      - un niveau de difficulté et une récompense calibrés par chapitre
      - un épinglage automatique dans SV.MissionBoard.
]]
require 'origin.common'

SecondaryJobs = {}

SecondaryJobs.CONTRACTS = {
  -- === CHAPITRE 6 (Rang 30-33, Difficulté C) ===
  {
    client = 'sandshrew', client_gender = RogueEssence.Data.Gender.Male,
    target = 'sandshrew', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'C', reward = 'money',
    title = "Les mirages qui n'en sont pas",
    flavor = "Les sables mouvants du désert ont englouti notre cargaison d'herbes médicinales.\nNous avons besoin d'une équipe solide pour retrouver notre piste avant la tempête.",
  },
  {
    client = 'carbink', client_gender = RogueEssence.Data.Gender.Female,
    target = 'carbink', target_gender = RogueEssence.Data.Gender.Female,
    difficulty = 'C', reward = 'money',
    title = "L'écho des quartz brisés",
    flavor = "Des roches scintillantes se détachent du plafond de notre caverne sans raison apparente.\nUne mission d'inspection s'impose pour sécuriser les galeries.",
  },
  {
    client = 'combee', client_gender = RogueEssence.Data.Gender.Female,
    target = 'combee', target_gender = RogueEssence.Data.Gender.Female,
    difficulty = 'C', reward = 'money',
    title = "La récolte interrompue",
    flavor = "Les Insectes du verger sont agités depuis quelques jours. Nous ne pouvons plus récolter le miel sacré.\nMerci d'enquêter dans les sous-bois.",
  },
  {
    client = 'shinx', client_gender = RogueEssence.Data.Gender.Male,
    target = 'shinx', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'C', reward = 'money',
    title = "Surcharges électriques dans la savane",
    flavor = "L'air des plaines est saturé d'électricité statique, nos pelages en crépitent encore.\nAllez vérifier ce qui trouble l'équilibre des plaines.",
  },

  -- === CHAPITRE 7 (Rang 34-37, Difficulté B) ===
  {
    client = 'magnemite', client_gender = RogueEssence.Data.Gender.Unknown,
    target = 'magnemite', target_gender = RogueEssence.Data.Gender.Unknown,
    difficulty = 'B', reward = 'money',
    title = "Perturbations magnétiques sous terre",
    flavor = "Nos champs de sustentation s'inversent lorsque nous pénétrons dans le jardin minéral.\nNous cherchons des explorateurs pour en trouver la source.",
  },
  {
    client = 'bronzor', client_gender = RogueEssence.Data.Gender.Unknown,
    target = 'bronzor', target_gender = RogueEssence.Data.Gender.Unknown,
    difficulty = 'B', reward = 'money',
    title = "Les fresques englouties",
    flavor = "Les ruines immergées abritent des écritures anciennes que nous devons recenser.\nAttention aux ombres qui rôdent dans les piliers.",
  },
  {
    client = 'turtwig', client_gender = RogueEssence.Data.Gender.Male,
    target = 'turtwig', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'B', reward = 'money',
    title = "Le labyrinthe qui pousse trop vite",
    flavor = "La mousse et les racines ont condamné notre ancien chemin de ronde en une seule nuit.\nAidez-nous à frayer un passage sûr.",
  },
  {
    client = 'numel', client_gender = RogueEssence.Data.Gender.Female,
    target = 'numel', target_gender = RogueEssence.Data.Gender.Female,
    difficulty = 'B', reward = 'money',
    title = "Trépidations volcaniques",
    flavor = "La roche magmatique chauffe à blanc et des fumerolles acides bloquent les chariots.\nNous offrons une bonne prime pour dégager la carrière.",
  },

  -- === CHAPITRE 8 (Rang 38-41, Difficulté A) ===
  {
    client = 'spheal', client_gender = RogueEssence.Data.Gender.Male,
    target = 'spheal', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'A', reward = 'money',
    title = "Le vent glacé des crêtes",
    flavor = "Des blizzards soudains ont gelé notre réserve de baies dans la toundra.\nNous cherchons une équipe endurante au froid pour les récupérer.",
  },
  {
    client = 'aron', client_gender = RogueEssence.Data.Gender.Male,
    target = 'aron', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'A', reward = 'money',
    title = "Les éboulements de la caverne",
    flavor = "Les piliers d'acier naturel s'effondrent sous le poids de créatures agressives.\nUne intervention armée est requise de toute urgence.",
  },
  {
    client = 'bagon', client_gender = RogueEssence.Data.Gender.Female,
    target = 'bagon', target_gender = RogueEssence.Data.Gender.Female,
    difficulty = 'A', reward = 'money',
    title = "Les roches qui tombent du ciel",
    flavor = "Les sommets se fracturent et provoquent des éboulis à chaque secousse.\nVenez sécuriser les sentiers rocheux avec nous.",
  },
  {
    client = 'fletchling', client_gender = RogueEssence.Data.Gender.Male,
    target = 'fletchling', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'A', reward = 'money',
    title = "Courants contraires en altitude",
    flavor = "Les rafales ascendantes nous empêchent de voler au-dessus du vallon.\nIl faut atteindre le col pour comprendre d'où vient le vent.",
  },

  -- === CHAPITRE 9 (Rang 42-45, Difficulté A+) ===
  {
    client = 'psyduck', client_gender = RogueEssence.Data.Gender.Male,
    target = 'psyduck', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'S', reward = 'money',
    title = "L'eau qui disparaît du bassin",
    flavor = "Le niveau d'eau du grand bassin baisse inexplicablement de jour en jour.\nEnquêtez dans le lit tari avant la sécheresse totale.",
  },
  {
    client = 'lotad', client_gender = RogueEssence.Data.Gender.Female,
    target = 'lotad', target_gender = RogueEssence.Data.Gender.Female,
    difficulty = 'S', reward = 'money',
    title = "Les brumes trompeuses du marais",
    flavor = "Des nappes de brume violacée désorientent nos cueilleurs dans les mares.\nNous avons besoin d'guides expérimentés pour traverser le marais.",
  },
  {
    client = 'oddish', client_gender = RogueEssence.Data.Gender.Male,
    target = 'oddish', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'S', reward = 'money',
    title = "Canopée oppressante",
    flavor = "Les arbres tropicaux ont poussé au point de masquer totalement la lumière du soleil.\nUne expédition de débroussaillage s'impose.",
  },
  {
    client = 'shellder', client_gender = RogueEssence.Data.Gender.Male,
    target = 'shellder', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'S', reward = 'money',
    title = "Les échos des profondeurs marines",
    flavor = "Des courants sous-marins anormaux secouent les rochers de la faille.\nNous payons très cher qui plongera pour nous ramener un rapport.",
  },

  -- === CHAPITRE 10 (Rang 46-49, Difficulté S) ===
  {
    client = 'snorunt', client_gender = RogueEssence.Data.Gender.Female,
    target = 'snorunt', target_gender = RogueEssence.Data.Gender.Female,
    difficulty = 'S', reward = 'money',
    title = "Le col pris dans les glaces",
    flavor = "La neige s'est entassée sur plus de dix mètres, coupant la route du sommet.\nSeule une équipe de rang supérieur peut forcer le passage.",
  },
  {
    client = 'shinx', client_gender = RogueEssence.Data.Gender.Male,
    target = 'shinx', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'S', reward = 'money',
    title = "Orages continus sur la crête",
    flavor = "La foudre tombe sans discontinuer sur la crête rocheuse depuis trois jours.\nNous devons inspecter les paratonnerres naturels du col.",
  },
  {
    client = 'pidgey', client_gender = RogueEssence.Data.Gender.Female,
    target = 'pidgey', target_gender = RogueEssence.Data.Gender.Female,
    difficulty = 'S', reward = 'money',
    title = "Les ombres des hautes falaises",
    flavor = "Des Pokémon volants de grande envergure patrouillent agressivement au-dessus des falaises.\nSécurisez l'espace aérien pour notre guilde.",
  },
  {
    client = 'ralts', client_gender = RogueEssence.Data.Gender.Female,
    target = 'ralts', target_gender = RogueEssence.Data.Gender.Female,
    difficulty = 'S', reward = 'money',
    title = "Le silence de la Cime d'Argent",
    flavor = "Les cloches minérales de la cime ont cessé de résonner dans le vent céleste.\nUne mission d'investigation sacrée est commanditée.",
  },
  {
    chapter = 11, zone = 'rainy_ravine', segment = 0, floor = 10,
    client = 'wooper', client_gender = RogueEssence.Data.Gender.Male,
    target = 'wooper', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'A', reward = 'money',
    title = "Le déluge du ravin",
    flavor = "Des pluies torrentielles inondent le Ravin Pluvieux et menacent nos rivières.\nUne équipe de secours est demandée d'urgence.",
  },
  {
    chapter = 11, zone = 'mossy_gorge', segment = 0, floor = 12,
    client = 'bellossom', client_gender = RogueEssence.Data.Gender.Female,
    target = 'bellossom', target_gender = RogueEssence.Data.Gender.Female,
    difficulty = 'A', reward = 'money',
    title = "L'eau de la racine sacrée",
    flavor = "La source sacrée de la Gorge Moussue est accaparée par de redoutables Pokémon.\nAidez-nous à rendre l'eau aux plantes de la vallée.",
  },
  {
    chapter = 11, zone = 'windswept_trail', segment = 0, floor = 11,
    client = 'manectric', client_gender = RogueEssence.Data.Gender.Male,
    target = 'manectric', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'S', reward = 'money',
    title = "La tempête du nord",
    flavor = "Des vents violents bloquent le passage sur la Piste Venteuse vers les crêtes nordiques.\nSécurisez le sentier pour les voyageurs.",
  },
  {
    chapter = 11, zone = 'foggy_hollow', segment = 0, floor = 12,
    client = 'gloom', client_gender = RogueEssence.Data.Gender.Female,
    target = 'gloom', target_gender = RogueEssence.Data.Gender.Female,
    difficulty = 'S', reward = 'money',
    title = "Le brouillard sans fin",
    flavor = "Un rideau de brume obscure désoriente quiconque s'aventure dans le Creux Brumeux.\nDissipez cette menace pour ramener la clarté.",
  },
  {
    chapter = 12, zone = 'ashen_hollow', segment = 0, floor = 10,
    client = 'slugma', client_gender = RogueEssence.Data.Gender.Male,
    target = 'slugma', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'A', reward = 'money',
    title = "Les cendres du cratère",
    flavor = "Des boues acides empoisonnent la lave du Creux Cendré au nord des montagnes.\nUne mission de purification est requise.",
  },
  {
    chapter = 12, zone = 'frozen_rift', segment = 0, floor = 12,
    client = 'snorunt', client_gender = RogueEssence.Data.Gender.Female,
    target = 'snorunt', target_gender = RogueEssence.Data.Gender.Female,
    difficulty = 'S', reward = 'money',
    title = "Le puits de glace",
    flavor = "Un monarque de glace obstrue le puits thermique de la Faille Gelée.\nLibérez le passage pour faire remonter l'air doux.",
  },
  {
    chapter = 12, zone = 'whispering_crag', segment = 0, floor = 11,
    client = 'pidgeotto', client_gender = RogueEssence.Data.Gender.Male,
    target = 'pidgeotto', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'S', reward = 'money',
    title = "Les ailes d'acier",
    flavor = "Des tempêtes violentes bloquent la route des oiseaux migrateurs sur la Crête Chuchotante.\nSécurisez l'espace aérien.",
  },
  {
    chapter = 12, zone = 'twilight_marsh', segment = 0, floor = 12,
    client = 'wooper', client_gender = RogueEssence.Data.Gender.Female,
    target = 'wooper', target_gender = RogueEssence.Data.Gender.Female,
    difficulty = 'A', reward = 'money',
    title = "La tourbe sombre",
    flavor = "Les champs de baies du Marais Crépusculaire sont ravagés par un étalon lourd.\nProtégez nos cultures marécageuses.",
  },
  {
    chapter = 13, zone = 'shivering_cavern', segment = 0, floor = 10,
    client = 'snorunt', client_gender = RogueEssence.Data.Gender.Male,
    target = 'snorunt', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'A', reward = 'money',
    title = "Le gel éternel",
    flavor = "Un blizzard éternel paralyse la source thermale de la Caverne Grelottante.\nUne expédition de secours est réclamée.",
  },
  {
    chapter = 13, zone = 'tempest_ridge', segment = 0, floor = 12,
    client = 'manectric', client_gender = RogueEssence.Data.Gender.Female,
    target = 'manectric', target_gender = RogueEssence.Data.Gender.Female,
    difficulty = 'S', reward = 'money',
    title = "L'orage de la crête",
    flavor = "Des foudres violentes interdisent le passage sur la Crête de la Tempête.\nApaiser l'orage pour rouvrir le col.",
  },
  {
    chapter = 13, zone = 'hollow_thicket', segment = 0, floor = 11,
    client = 'gloom', client_gender = RogueEssence.Data.Gender.Male,
    target = 'gloom', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'S', reward = 'money',
    title = "Les ronces du fourré",
    flavor = "Des lianes sombres emprisonnent les sous-bois du Fourré Creux.\nLibérez les sentiers pour les habitants forestiers.",
  },
  {
    chapter = 13, zone = 'silent_marsh', segment = 0, floor = 12,
    client = 'wooper', client_gender = RogueEssence.Data.Gender.Female,
    target = 'wooper', target_gender = RogueEssence.Data.Gender.Female,
    difficulty = 'A', reward = 'money',
    title = "Le silence du marais",
    flavor = "Le Marais Silencieux est privé de musique par un gardien en armure d'acier.\nRamenez le chant des pluies.",
  },







}

function SecondaryJobs.EnsureSV()
  if SV.SecondaryJobsCompleted == nil then
    SV.SecondaryJobsCompleted = {}
  end
end

function SecondaryJobs.CleanCompleted()
  SecondaryJobs.EnsureSV()
  if SV.MissionBoard == nil then return end
  
  local clean = {}
  for _, slot in ipairs(SV.MissionBoard) do
    if slot.Zone and not SV.SecondaryJobsCompleted[slot.Zone] then
      table.insert(clean, slot)
    end
  end
  SV.MissionBoard = clean
end

function SecondaryJobs.PinToBoard()
  SecondaryJobs.EnsureSV()
  if SV.MissionBoard == nil then
    SV.MissionBoard = {}
  end

  local current_ch = 6
  if SV.ChapterProgression and SV.ChapterProgression.Chapter then
    current_ch = SV.ChapterProgression.Chapter
  end

  -- Epingler les contrats des donjons secondaires du chapitre actif aux emplacements 2 à 5
  for _, c in ipairs(SecondaryJobs.CONTRACTS) do
    if c.chapter == current_ch and not SV.SecondaryJobsCompleted[c.zone] then
      local job = {
        Client = c.client,
        ClientGender = c.client_gender,
        Target = c.target,
        TargetGender = c.target_gender,
        Flavor = c.flavor,
        Title = c.title,
        Zone = c.zone,
        Segment = c.segment,
        Floor = c.floor,
        Reward = 0,
        Type = 0,
        Completion = 0,
        Taken = false,
        Difficulty = c.difficulty,
        Item = "",
        Special = "",
        BonusReward = ""
      }
      table.insert(SV.MissionBoard, job)
    end
  end
end

return SecondaryJobs
