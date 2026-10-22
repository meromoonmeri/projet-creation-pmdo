require 'origin.common'

local function FirstToUpper(str)
	return (str:gsub("^%l", string.upper))
end

local function AdjustNickname(name, characters)
	local nickname = characters[name].nickname
	if not CONFIG.UseNicknames() then

		-- Skip Crum
		if nickname == "Crum" then
			return nickname
		end

		local species = characters[name].species
		if species == "nidoran_m" then -- Format Nidoran
			nickname = "Nidoran"
		elseif species == "farfetchd" then -- Format Farfetch'd
			nickname = "Farfetch'd"
		else
			nickname = FirstToUpper(species)
		end
	end
	return nickname
end

CharacterEssentials = {}

local characters = {
		Moltres = {
			species = "moltres",
			nickname = 'Sulfura',
			instance = 'Moltres',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Articuno = {
			species = "articuno",
			nickname = 'Artikodin',
			instance = 'Articuno',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Ninetales = {
			species = "ninetales",
			nickname = 'Feunard',
			instance = 'Ninetales',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		--the guild
		Tropius = {
			species = "tropius",
			nickname = 'Penticus',
			instance = 'Tropius',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Noctowl = {
			species = "noctowl", 
			nickname = 'Phileas',
			instance = 'Noctowl',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Zigzagoon = {
			species = "zigzagoon", 
			nickname = 'Almotz',
			instance = 'Zigzagoon',
			gender = Gender.Male,
			form = 0, 
			skin = "normal"
		},
		Growlithe = {
			species = "growlithe",
			nickname = 'Hyko',
			instance = 'Growlithe',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Mareep = {
			species = "mareep",
			nickname = 'Shuca',
			instance = 'Mareep',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Cranidos = {
			species = "cranidos",
			nickname = 'Ganlon',
			instance = 'Cranidos',
			gender = Gender.Male,
			form = 0,
			skin = "normal"	
		},
		
		Snubbull = {
			species = "snubbull",
			nickname = 'Coco',
			instance = 'Snubbull',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		Audino = {
			species = "audino",
			nickname = 'Rin',
			instance = 'Audino',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Breloom = {
			species = "breloom",
			nickname = 'Kino',
			instance = 'Breloom',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Girafarig = {
			species = "girafarig",
			nickname = 'Reinier',
			instance = 'Girafarig',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Tail = {--girafarig's tail
			species = "girafarig",
			nickname = 'Crum',
			instance = 'Tail',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		
	--Dojo characters
		Ledian = {
			species = "ledian",
			nickname = 'Lotus',
			instance = 'Ledian',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
	
		--can refer to Lotus as either Ledian or Sensei to grab her
		Sensei = {
			species = "ledian",
			nickname = 'Lotus',
			instance = 'Sensei',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Gible = {
			species = "gible",
			nickname = 'Totor',
			instance = 'Gible',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		
	--Team Style
		Luxio = {
			species = "luxio",
			nickname = 'Suilux',
			instance = 'Luxio',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
			},
		Glameow = {
			species = "glameow",
			nickname = 'Priscilla',
			instance = 'Glameow',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		Cacnea = {
			species = "cacnea",
			nickname = 'Lummsy',
			instance = 'Cacnea',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		
		
	--Team Round (names are one letter off words that mean fat or round)
		Spheal = { 
			species = "spheal",
			nickname = 'Chumby',
			instance = 'Spheal',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
			},
		Marill = { 
			species = "marill",
			nickname = 'Rolund',
			instance = 'Marill',
			gender = Gender.Male,
			form = 0,
			skin = "normal"	
		},
		Jigglypuff = { 
			species = "jigglypuff",
			nickname = 'Plum',
			instance = 'Jigglypuff',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
	--Team Starlight
		Cleffa = {
			species = "cleffa",
			nickname = 'Primonna',
			instance = 'Cleffa',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},		
		Aggron = {
			species = "aggron",
			nickname = 'Rubble',
			instance = 'Aggron',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		
	--Team Rivals
		Zangoose = {
			species = "zangoose",
			nickname = 'Devian',
			instance = 'Zangoose',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},	
		
		Seviper = {
			species = "seviper",
			nickname = 'Zular',
			instance = 'Seviper',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
	--Team Cadence (their names are corruptions of types of dances)
		Spinda = {
			species = "spinda",
			nickname = 'Ceili',
			instance = 'Spinda',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Ludicolo = {
			species = "ludicolo",
			nickname = 'Mirich',
			instance = 'Ludicolo',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},

		--Goinfrex, l'estomac sur pattes du Cafe Spinda.
		--Utilise par les scenes quotidiennes du Cafe (metano_cafe.PlayDailyCutscene,
		--indices 0 et 6). Il etait appele SANS etre declare ici : chaque appel
		--plantait dans MakeCharactersFromList (index d'un nil), et le pcall
		--enveloppant avalait l'erreur — la scene du jour ne se jouait jamais.
		Goinfrex = {
			species = "munchlax",
			nickname = 'Goinfrex',
			instance = 'Goinfrex',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Roselia = {
			species = "roselia",
			nickname = 'Bequa',
			instance = 'Roselia',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
	--Team Flight
		Doduo = {
			species = "doduo",
			nickname = 'Rok',
			instance = 'Doduo',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
	
		Bagon = {
			species = "bagon",
			nickname = 'Tyra',
			instance = 'Bagon',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
	--Team Flutter
		Silcoon = {
			species = 'silcoon',
			nickname = 'Chressa',
			instance = 'Silcoon',
			gender = Gender.Female,
			form = 0,
			skin = 'normal'
		},
		
		Metapod = {
			species = 'metapod',
			nickname = 'Solis',
			instance = 'Metapod',
			gender = Gender.Male,
			form = 0,
			skin = 'normal'
		},
		
	--Team Dazzling
		-- Their public codenames are deliberately stored as nicknames.  The
		-- French species name Lockpin belongs to Lopunny in the base data; it
		-- is not a second character and is therefore not duplicated here.
		Adagio = {
			species = "tsareena",
			nickname = 'Adagio',
			instance = 'Adagio',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		Aria = {
			species = "lopunny",
			nickname = 'Aria',
			instance = 'Aria',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		Sonata = {
			species = "mismagius",
			nickname = 'Sonata',
			instance = 'Sonata',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		--Chapitre 5 : mini-boss et gardiens des donjons de l'expedition
		Mudbray = {
			species = "mudbray",
			nickname = 'Tiboudet',
			instance = 'Mudbray',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Stantler = {
			species = "stantler",
			nickname = 'Cerfrousse',
			instance = 'Stantler',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		--Gardien de la Grande Steppe (chapitre 5) : presage de desastre,
		--solitaire, ne surgit que quand quelque chose se prepare.
		Absol = {
			species = "absol",
			nickname = 'Absol',
			instance = 'Absol',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Torkoal = {
			species = "torkoal",
			nickname = 'Chartor',
			instance = 'Torkoal',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Magmar = {
			species = "magmar",
			nickname = 'Magmar',
			instance = 'Magmar',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Gligar = {
			species = "gligar",
			nickname = 'Scorplane',
			instance = 'Gligar',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		Skarmory = {
			species = "skarmory",
			nickname = 'Airmure',
			instance = 'Skarmory',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Aerodactyl = {
			species = "aerodactyl",
			nickname = 'Ptéra',
			instance = 'Aerodactyl',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		--TORNADUS, gardien du sommet du Mont Venteux (ch5), SEUL boss du
		--donjon depuis le retrait du mini-boss. Type VOL PUR : verifie dans
		--Data/Misc/Index.json (Element1 flying, Element2 none, 2 formes).
		--Aucune fiche locale dans Data/Monster n'est necessaire — meme cas
		--que Zeraora, Lugia, Diancie, Regigigas et Terrakion, deja employes
		--comme boss dans ce mod : PathMod retombe sur le jeu de base.
		--Forme 0 = Avatar (la forme humanoide, celle qui peut soutenir un
		--dialogue de plusieurs minutes face au duo).
		Tornadus = {
			species = "tornadus",
			nickname = 'Tornadus',
			instance = 'Tornadus',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		--Chapitres 6 a 9 : gardiens mini-boss (conception_donjons_segmentes.md).
		--Duos anonymes assortis au biome de leur donjon, pattern Chartor + Magmar.
		Shiftry = {
			species = "shiftry",
			nickname = 'Tengalice',
			instance = 'Shiftry',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		--Cornebre, sbire de la Meute de Corboss.
		--Renomme en Cornebre_Boss : une SECONDE fiche `Murkrow` existait
		--plus bas (Varko, PNJ nocturne) et ecrasait silencieusement
		--celle-ci, Lua ne gardant que la derniere definition d'une meme
		--cle. Le mini-boss de la Foret Lugubre invoquait donc Varko en
		--croyant invoquer Cornebre.
		--Corboss, chef de la Meute (PLAN_DIRECTEUR_EXPANSION_CH8_10, section 2).
		--Pilleur opportuniste des ch8 a ch10. Il n'etait declare nulle part :
		--le fil recurrent demande par le plan n'avait donc aucun chef.
		--ESPECE : le plan ecrit « Honchkrow », mais honchkrow n'apparait NULLE
		--PART dans le projet — ni dans Data/Monster, ni dans la liste de spawns
		--de mission_gen.lua (461 especes, alphabetique : rien entre honedge et
		--hoppip). L'utiliser reviendrait a inventer un asset. On prend mandibuzz,
		--atteste dans cette liste : grand rapace charognard, ce qui colle mieux
		--au role de chef de bande que l'evolution d'un Cornebre.
		Corboss = {
			species = "mandibuzz",
			nickname = 'Corboss',
			instance = 'Corboss',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},

		Cornebre_Boss = {
			species = "murkrow",
			nickname = 'Cornèbre',
			instance = 'Cornebre_Boss',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Claydol = {
			species = "claydol",
			nickname = 'Kaorine',
			instance = 'Claydol',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Golurk = {
			species = "golurk",
			nickname = 'Golemastoc',
			instance = 'Golurk',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Carbink = {
			species = "carbink",
			nickname = 'Strassie',
			instance = 'Carbink',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Froslass = {
			species = "froslass",
			nickname = 'Momartik',
			instance = 'Froslass',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		Swalot = {
			species = "swalot",
			nickname = 'Avaltout',
			instance = 'Swalot',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Toxicroak = {
			species = "toxicroak",
			nickname = 'Coatox',
			instance = 'Toxicroak',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Butterfree = {
			species = "butterfree",
			nickname = 'Papilusion',
			instance = 'Butterfree',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		Venipede = {
			species = "venipede",
			nickname = 'Chenipent',
			instance = 'Venipede',
			gender = Gender.Unknown,
			form = 0,
			skin = "normal"
		},
		--Chapitre 5 : rencontres de vie aux relais (Prompt Maitre §3.2/B.2)
		Meteno = {
			species = "minior",
			nickname = 'Météno',
			instance = 'Meteno',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		--Livre II : gardiens d'Ancrage (cinematiques vague 7)
		--Chapitre 5 : sbires du clan de lave (Tunnel Ardent)
		Limagma1 = {
			species = "slugma",
			nickname = 'Limagma',
			instance = 'Limagma1',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Limagma2 = {
			species = "slugma",
			nickname = 'Limagma',
			instance = 'Limagma2',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Limagma3 = {
			species = "slugma",
			nickname = 'Limagma',
			instance = 'Limagma3',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Limagma4 = {
			species = "slugma",
			nickname = 'Limagma',
			instance = 'Limagma4',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Limagma5 = {
			species = "slugma",
			nickname = 'Limagma',
			instance = 'Limagma5',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		--Livre II : Veilleurs du Reseau des Anciens Chemins (grounds pmd-red)
		Rempart = {
			species = "bastiodon",
			nickname = 'Rempart',
			instance = 'Rempart',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		CableVif = {
			species = "eelektross",
			nickname = 'Câble-Vif',
			instance = 'CableVif',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Fusible = {
			species = "magmortar",
			nickname = 'Fusible',
			instance = 'Fusible',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		BlizzardSentinelle = {
			species = "abomasnow",
			nickname = 'Blizzard-Sentinelle',
			instance = 'BlizzardSentinelle',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		VoileBlanc = {
			species = "froslass",
			nickname = 'Voile-Blanc',
			instance = 'VoileBlanc',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		MasqueGel = {
			species = "glalie",
			nickname = 'Masque-Gel',
			instance = 'MasqueGel',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		SoleilDeCendre = {
			species = "volcarona",
			nickname = 'Soleil-de-Cendre',
			instance = 'SoleilDeCendre',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		DechireNuages = {
			species = "salamence",
			nickname = 'Déchire-Nuages',
			instance = 'DechireNuages',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		LameDeFond = {
			species = "gyarados",
			nickname = 'Lame-de-Fond',
			instance = 'LameDeFond',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		LanterneNoyee = {
			species = "jellicent",
			nickname = 'Lanterne-Noyée',
			instance = 'LanterneNoyee',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		AncreMorte = {
			species = "dhelmise",
			nickname = 'Ancre-Morte',
			instance = 'AncreMorte',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		PortierDuVide = {
			species = "dusknoir",
			nickname = 'Portier-du-Vide',
			instance = 'PortierDuVide',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Groudon = {
			species = "groudon",
			nickname = 'Groudon',
			instance = 'Groudon',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Kyogre = {
			species = "kyogre",
			nickname = 'Kyogre',
			instance = 'Kyogre',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Crehelf = {
			species = "uxie",
			nickname = 'Créhelf',
			instance = 'Crehelf',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Crefollet = {
			species = "mesprit",
			nickname = 'Créfollet',
			instance = 'Crefollet',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Crefadet = {
			species = "azelf",
			nickname = 'Créfadet',
			instance = 'Crefadet',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Sulfura = {
			species = "moltres",
			nickname = 'Sulfura',
			instance = 'Sulfura',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Raikou = {
			species = "raikou",
			nickname = 'Raikou',
			instance = 'Raikou',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Artikodin = {
			species = "articuno",
			nickname = 'Artikodin',
			instance = 'Artikodin',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Electhor = {
			species = "zapdos",
			nickname = 'Électhor',
			instance = 'Electhor',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		HoOh = {
			species = "ho_oh",
			nickname = 'Ho-Oh',
			instance = 'HoOh',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Celebi = {
			species = "celebi",
			nickname = 'Celebi',
			instance = 'Celebi',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Mewtwo = {
			species = "mewtwo",
			nickname = 'Mewtwo',
			instance = 'Mewtwo',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Entei = {
			species = "entei",
			nickname = 'Entei',
			instance = 'Entei',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Victini = {
			species = "victini",
			nickname = 'Victini',
			instance = 'Victini',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Cresselia = {
			species = "cresselia",
			nickname = 'Cresselia',
			instance = 'Cresselia',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		Darkrai = {
			species = "darkrai",
			nickname = 'Darkrai',
			instance = 'Darkrai',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Latios = {
			species = "latios",
			nickname = 'Latios',
			instance = 'Latios',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Latias = {
			species = "latias",
			nickname = 'Latias',
			instance = 'Latias',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		Suicune = {
			species = "suicune",
			nickname = 'Suicune',
			instance = 'Suicune',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Mew = {
			species = "mew",
			nickname = 'Mew',
			instance = 'Mew',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Hoopa = {
			species = "hoopa",
			nickname = 'Hoopa',
			instance = 'Hoopa',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Marshadow = {
			species = "marshadow",
			nickname = 'Marshadow',
			instance = 'Marshadow',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Rayquaza = {
			species = "rayquaza",
			nickname = 'Rayquaza',
			instance = 'Rayquaza',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Dialga = {
			species = "dialga",
			nickname = 'Dialga',
			instance = 'Dialga',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Palkia = {
			species = "palkia",
			nickname = 'Palkia',
			instance = 'Palkia',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Giratina = {
			species = "giratina",
			nickname = 'Giratina',
			instance = 'Giratina',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Yveltal = {
			species = "yveltal",
			nickname = 'Yveltal',
			instance = 'Yveltal',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Zygarde = {
			species = "zygarde",
			nickname = 'Zygarde',
			instance = 'Zygarde',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Xerneas = {
			species = "xerneas",
			nickname = 'Xerneas',
			instance = 'Xerneas',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Solgaleo = {
			species = "solgaleo",
			nickname = 'Solgaleo',
			instance = 'Solgaleo',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Lunala = {
			species = "lunala",
			nickname = 'Lunala',
			instance = 'Lunala',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		Jirachi = {
			species = "jirachi",
			nickname = 'Jirachi',
			instance = 'Jirachi',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Necrozma = {
			species = "necrozma",
			nickname = 'Necrozma',
			instance = 'Necrozma',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Eternatus = {
			species = "eternatus",
			nickname = 'Eternatus',
			instance = 'Eternatus',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Arceus = {
			species = "arceus",
			nickname = 'Arceus',
			instance = 'Arceus',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Shaymin = {
			species = "shaymin",
			nickname = 'Shaymin',
			instance = 'Shaymin',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},

		--------------------------------------------------------------
		-- LE VILLAGE DES SHAYMIN (quete q8_shaymin, organisee par Ceili)
		--
		-- Trois habitants nommes, distincts de l'Ancrage `Shaymin`
		-- ci-dessus (« La ou Fleurit le Merci », ch15). Meme espece,
		-- identites differentes : ce sont des villageois, pas le
		-- gardien legendaire. Cles et instances distinctes pour que
		-- CH() et les handlers ne puissent jamais viser l'un pour
		-- l'autre — meme precaution que Canyon_Xatu / Bourg_Xatu.
		--------------------------------------------------------------
		Shaymin_Doyenne = {
			species = "shaymin",
			nickname = 'Gratiane',
			instance = 'Shaymin_Doyenne',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},

		Shaymin_Eclaireur = {
			species = "shaymin",
			nickname = 'Brindille',
			instance = 'Shaymin_Eclaireur',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},

		Shaymin_Cadet = {
			species = "shaymin",
			nickname = 'Pissenlit',
			instance = 'Shaymin_Cadet',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},

		Manaphy = {
			species = "manaphy",
			nickname = 'Manaphy',
			instance = 'Manaphy',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Phione = {
			species = "phione",
			nickname = 'Phione',
			instance = 'Phione',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Keldeo = {
			species = "keldeo",
			nickname = 'Keldeo',
			instance = 'Keldeo',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Meloetta = {
			species = "meloetta",
			nickname = 'Meloetta',
			instance = 'Meloetta',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		Genesect = {
			species = "genesect",
			nickname = 'Genesect',
			instance = 'Genesect',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Volcanion = {
			species = "volcanion",
			nickname = 'Volcanion',
			instance = 'Volcanion',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Magearna = {
			species = "magearna",
			nickname = 'Magearna',
			instance = 'Magearna',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Zeraora = {
			species = "zeraora",
			nickname = 'Zeraora',
			instance = 'Zeraora',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Melmetal = {
			species = "melmetal",
			nickname = 'Melmetal',
			instance = 'Melmetal',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Meltan = {
			species = "meltan",
			nickname = 'Meltan',
			instance = 'Meltan',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Deoxys = {
			species = "deoxys",
			nickname = 'Deoxys',
			instance = 'Deoxys',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		--Chapitre 7 : les trois gardiens scelles des Aegis Cave
		Regirock = {
			species = "regirock",
			nickname = 'Regirock',
			instance = 'Regirock',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Regice = {
			species = "regice",
			nickname = 'Regice',
			instance = 'Regice',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Registeel = {
			species = "registeel",
			nickname = 'Registeel',
			instance = 'Registeel',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		--Zarbi de l'enigme des Aegis Cave (formes R E G I S)
		Zarbi_R = {
			species = "unown",
			nickname = 'Zarbi',
			instance = 'Zarbi_R',
			gender = Gender.Genderless,
			form = 17,
			skin = "normal"
		},
		Zarbi_E = {
			species = "unown",
			nickname = 'Zarbi',
			instance = 'Zarbi_E',
			gender = Gender.Genderless,
			form = 4,
			skin = "normal"
		},
		Zarbi_G = {
			species = "unown",
			nickname = 'Zarbi',
			instance = 'Zarbi_G',
			gender = Gender.Genderless,
			form = 6,
			skin = "normal"
		},
		Zarbi_I = {
			species = "unown",
			nickname = 'Zarbi',
			instance = 'Zarbi_I',
			gender = Gender.Genderless,
			form = 8,
			skin = "normal"
		},
		Zarbi_S = {
			species = "unown",
			nickname = 'Zarbi',
			instance = 'Zarbi_S',
			gender = Gender.Genderless,
			form = 18,
			skin = "normal"
		},
		--Chapitre 7 : Aegis Cave — boss Regigigas
		Regigigas = {
			species = "regigigas",
			nickname = 'Regigigas',
			instance = 'Regigigas',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		--Aegis Cave — les huit statues qui gardent Regigigas
		--(portage Aegis Cave : 4 Hitmonlee + 4 Bronzong). Instances
		--distinctes : elles s'eveillent en cascade, chacune doit etre
		--adressable separement.
		Hitmonlee_1 = {
			species = "hitmonlee",
			nickname = 'Hitmonlee',
			instance = 'Hitmonlee_1',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Hitmonlee_2 = {
			species = "hitmonlee",
			nickname = 'Hitmonlee',
			instance = 'Hitmonlee_2',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Hitmonlee_3 = {
			species = "hitmonlee",
			nickname = 'Hitmonlee',
			instance = 'Hitmonlee_3',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Hitmonlee_4 = {
			species = "hitmonlee",
			nickname = 'Hitmonlee',
			instance = 'Hitmonlee_4',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Bronzong_1 = {
			species = "bronzong",
			nickname = 'Bronzong',
			instance = 'Bronzong_1',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Bronzong_2 = {
			species = "bronzong",
			nickname = 'Bronzong',
			instance = 'Bronzong_2',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Bronzong_3 = {
			species = "bronzong",
			nickname = 'Bronzong',
			instance = 'Bronzong_3',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Bronzong_4 = {
			species = "bronzong",
			nickname = 'Bronzong',
			instance = 'Bronzong_4',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		--Chapitre 8 : Sanctuaire de Cristal — boss Diancie
		Diancie = {
			species = "diancie",
			nickname = 'Diancie',
			instance = 'Diancie',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		--Chapitre 9 : Marais de l'Oubli — gardien Laggron
		Swampert = {
			species = "swampert",
			nickname = 'Laggron',
			instance = 'Swampert',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		--Chapitre 10 : Pic Celeste — boss Lugia
		Lugia = {
			species = "lugia",
			nickname = 'Lugia',
			instance = 'Lugia',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		--Arc 2 : le Cercle du Suaire (voleurs de fragments de Coeur)
		--Xatu, le Veilleur du Canyon des Voix Eteintes.
		--Dans les jeux d'origine, un Xatu se tient au bout du Grand Canyon : il
		--voit, mais ne dit presque rien. On garde cette fonction — un devin qui
		--se tait — et on la relie a NOTRE lore : il est le seul temoin exterieur
		--a avoir compris ce que le heros porte, et il refuse de le nommer.
		--PNJ nocturnes de Metano (metano_town_nuit). Ils n'existent QUE la
		--nuit : ce ne sont pas des PNJ de jour deplaces a une autre heure.
		Lapras = {
			species = "lapras",
			nickname = 'Loaklass',
			instance = 'Lapras',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		Alakazam = {
			species = "alakazam",
			nickname = 'Alakazam',
			instance = 'Alakazam',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Tyranitar = {
			species = "tyranitar",
			nickname = 'Tyranitar',
			instance = 'Tyranitar',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Charizard = {
			species = "charizard",
			nickname = 'Charizard',
			instance = 'Charizard',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Nuit_Garde = {
			species = "granbull",
			nickname = 'Veilleur de Nuit',
			instance = 'Nuit_Garde',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Nuit_Etoiles = {
			species = "murkrow",
			nickname = 'Compteuse d\'Étoiles',
			instance = 'Nuit_Etoiles',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		Nuit_Insomniaque = {
			species = "noctowl",
			nickname = 'Plume-Grise',
			instance = 'Nuit_Insomniaque',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Canyon_Xatu = {
			species = "xatu",
			nickname = 'Veilleur',
			instance = 'Canyon_Xatu',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Suaire_Banette = {
			species = "banette",
			nickname = 'Suaire',
			instance = 'Suaire_Banette',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Suaire_Gengar = {
			species = "gengar",
			nickname = 'Linceul',
			instance = 'Suaire_Gengar',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Suaire_Noivern = {
			species = "noivern",
			nickname = 'Litanie',
			instance = 'Suaire_Noivern',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		--Chapitre 10 : Escouade Fulgur (rivaux de la course au sommet)
		Fulgur_Luxray = {
			species = "luxray",
			nickname = 'Voltra',
			instance = 'Fulgur_Luxray',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		Fulgur_Lucario = {
			species = "lucario",
			nickname = 'Aegis',
			instance = 'Fulgur_Lucario',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Fulgur_Heliolisk = {
			species = "heliolisk",
			nickname = 'Solaire',
			instance = 'Fulgur_Heliolisk',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},

	--Aire des Dragons (Tour Celeste, segment 3). Trio qui garde la voie
	--directe vers le Sommet Sacre. Remplace l'Escouade Fulgur electrique,
	--qui reste par ailleurs une equipe rivale du recit (SuaireArc).
		Wyrm_Dragonite = {
			species = "dragonite",
			nickname = 'Vertevire',
			instance = 'Wyrm_Dragonite',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Wyrm_Salamence = {
			species = "salamence",
			nickname = 'Bregonde',
			instance = 'Wyrm_Salamence',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		Wyrm_Altaria = {
			species = "altaria",
			nickname = 'Nubila',
			instance = 'Wyrm_Altaria',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},

	--Vendor/Shop NPCs
		Kangaskhan = {
			species = "kangaskhan",
			nickname = 'Auntie Kanga',
			instance = 'Kangaskhan',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},

	--------------------------------------------------------------
	-- BOURG DU COMPTOIR (Treasure Town) — habitants
	--
	-- Le heros et le partenaire decouvrent le Bourg au chapitre 11,
	-- soit une dizaine d'annees apres l'epoque ou la ville a connu
	-- son heure de gloire. Les habitants ont vieilli et, pour la
	-- plupart, evolue. Les noms des jeux d'origine ne sont jamais
	-- employes : chaque habitant recoit un nom propre a New Era.
	--
	-- Les especes sont celles d'apres evolution. Les entites des
	-- .rsground portent le meme nom que la cle ci-dessous.
	--------------------------------------------------------------
		Bibarel = {
			species = "bibarel",
			nickname = 'Barnabe',
			instance = 'Bibarel',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},

		Azumarill = {
			species = "azumarill",
			nickname = 'Ondine',
			instance = 'Azumarill',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},

		Marill_Jeune = {
			species = "marill",
			nickname = 'Goutelette',
			instance = 'Marill_Jeune',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},

		Hypno = {
			species = "hypno",
			nickname = 'Morphee',
			instance = 'Hypno',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},

		Dusclops = {
			species = "dusclops",
			nickname = 'Sombreveille',
			instance = 'Dusclops',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},

		Banette = {
			species = "banette",
			nickname = 'Guenille',
			instance = 'Banette',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},

		Beautifly = {
			species = "beautifly",
			nickname = 'Elytre',
			instance = 'Beautifly',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},

		Nuzleaf = {
			species = "nuzleaf",
			nickname = 'Brindille',
			instance = 'Nuzleaf',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},

		Pidgeot = {
			species = "pidgeot",
			nickname = 'Bourrasque',
			instance = 'Pidgeot',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},

		Crawdaunt = {
			species = "crawdaunt",
			nickname = 'Pinceur',
			instance = 'Crawdaunt',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},

		Slaking = {
			species = "slaking",
			nickname = 'Bourrelet',
			instance = 'Slaking',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},

		Swellow = {
			species = "swellow",
			nickname = 'Fileclair',
			instance = 'Swellow',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},

		Electivire = {
			species = "electivire",
			nickname = 'Dynamo',
			instance = 'Electivire',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},

		Xatu = {
			species = "xatu",
			nickname = 'Oracle',
			instance = 'Xatu',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},

		PurpleKecleon = {
			species = "kecleon",
			nickname = 'Violette',
			instance = 'PurpleKecleon',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},

		Marowak = {
			species = "marowak",
			nickname = 'Maitre Ossovan',
			instance = 'Marowak',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Murkrow = {
			species = "murkrow",
			nickname = 'Varko',
			instance = 'Murkrow',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
	
		Slowpoke = {
			species = "slowpoke",
			nickname = 'Ezalor',
			instance = 'Slowpoke',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Ambipom = {
			species = "ambipom",
			nickname = 'Swigoi',
			instance = 'Ambipom',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Sneasel = {
			species = "sneasel",
			nickname = 'Katrine',
			instance = 'Sneasel',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Kecleon = {
			species = "kecleon",
			nickname = 'Lars',
			instance = 'Kecleon',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Kecleon_Purple = {
			species = "kecleon",
			nickname = 'Zigs',
			instance = 'Kecleon_Purple',
			gender = Gender.Male,
			form = 1,
			skin = "normal"
		},
		
		Chatot = {
			species = "chatot",
			nickname = 'Falo',
			instance = 'Chatot',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
	
		Shuckle = {
			species = "shuckle",
			nickname = 'Dion',
			instance = 'Shuckle',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},		
		
		Farfetchd = {
			species = "farfetchd",
			nickname = 'Mido',
			instance = "Farfetch'd",
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},	

		Stunky = {
			species = "stunky",
			nickname = 'Rhizo',
			instance = 'Stunky',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Pelipper_Rescue = {
			species = "pelipper",
			nickname = 'Mael',
			instance = 'Pelipper_Rescue',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Pelipper_Connect = {
			species = "pelipper",
			nickname = 'Anlin',
			instance = 'Pelipper_Connect',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
	
	
	--Town NPCs - Families
		Furret = {
			species = "furret",
			nickname = 'Jak',
			instance = 'Furret',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Linoone = {
			species = "linoone", 
			nickname = 'Lebiure',
			instance = 'Linoone',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
	
		Sentret = {
			species = "sentret", 
			nickname = 'Timmi',
			instance = 'Sentret',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
	
		
		
		Luxray = {
			species = "luxray",
			nickname = 'Rulux',
			instance = 'Luxray',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
	
		Manectric = {
			species = "manectric",
			nickname = 'Camentra',
			instance = 'Manectric',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Electrike = {
			species = "electrike",
			nickname = 'Trilec',
			instance = 'Electrike',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		
		
		Floatzel = {
			species = "floatzel",
			nickname = 'Tweed',
			instance = 'Floatzel',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Quagsire = {
			species = "quagsire",
			nickname = 'Maris',
			instance = 'Quagsire',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Wooper_Girl = {
			species = "wooper",
			nickname = 'Dee',
			instance = 'Wooper_Girl',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
	
		Wooper_Boy = {
			species = "wooper",
			nickname = 'Dun',
			instance = 'Wooper_Boy',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		
		
		Camerupt = {
			species = "camerupt",
			nickname = 'Dotra',
			instance = 'Camerupt',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Numel = {
			species = "numel",
			nickname = 'Nubbor',
			instance = 'Numel',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		
		
		Machamp = {
			species = "machamp",
			nickname = 'Savran',
			instance = 'Machamp',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
			
		Medicham = {
			species = "medicham",
			nickname = 'Nama',
			instance = 'Medicham',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Meditite = {
			species = "meditite",
			nickname = 'Stei',
			instance = 'Meditite',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		
		--begonia flower 
		Vileplume = {
			species = "vileplume",
			nickname = 'Bogen',
			instance = 'Vileplume',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		--Chrysanthemum
		Bellossom = {
			species = "bellossom",
			nickname = 'Chrysi',
			instance = 'Bellossom',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		--Lavender
		Gloom = {
			species = "gloom", 
			nickname = 'Lavena',
			instance = 'Gloom',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		--White Lilac
		Oddish = {
			species = "oddish",
			nickname = 'Calil',
			instance = 'Oddish',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		
		
		Nidoking = {
			species = "nidoking",
			nickname = 'Pawpa',
			instance = 'Nidoking',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Nidoqueen = {
			species = "nidoqueen",
			nickname = 'Monna',
			instance = 'Nidoqueen',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Nidorina = {
			species = "nidorina",
			nickname = 'Dottir',
			instance = 'Nidorina',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Nidoran_M = {
			species = "nidoran_m",
			nickname = 'Junior',
			instance = 'Nidoran_M',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
	
	
	--Town NPCs - Other
		Sunflora = {
			species = "sunflora",
			nickname = 'Ciel',
			instance = 'Sunflora',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Azumarill = {
			species = "azumarill",
			nickname = 'Loaf',
			instance = 'Azumarill',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Mawile = {
			species = "mawile",
			nickname = 'Bria',
			instance = 'Mawile',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
	
		Relicanth = {
			species = "relicanth",
			nickname = 'Erleuchtet',
			instance = 'Relicanth',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		--Head of Police
		Bisharp = {
			species = "bisharp",
			nickname = 'Zhayn',
			instance = 'Bisharp',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		--The cops, their actual names shouldn't show up. They're just used for some cutscenes.
		Pawniard_Boy = {
			species = "pawniard",
			nickname = 'Copper',
			instance = 'Pawniard_Boy',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Pawniard_Girl = {
			species = "pawniard",
			nickname = 'Patty',
			instance = 'Pawniard_Girl',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Gulpin = {
			species = "gulpin",
			nickname = 'Boosmu',
			instance = 'Gulpin',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Lickitung = {
			species = "lickitung",
			nickname = 'Urgil',
			instance = 'Lickitung',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		--Other Plot Relevant NPCs
		--
		Sandile = {
			species = "sandile",
			nickname = 'Thwait',
			instance = 'Sandile',
			gender = Gender.Male,
			form = 1,--he is scarfed
			skin = "normal"
		},	

		Magcargo = {
			species = "magcargo",
			nickname = 'Morkot',--tzhaar words mishmashed togehter
			instance = 'Magcargo',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Arcanine = {
			species = 'Arcanine',
			nickname = 'Devina', --she was dev all along...
			instance = 'Arcanine',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		--Inn Passersby
		Makuhita = {
			species = "makuhita",
			nickname = 'Passerby',
			instance = 'Passerby_1',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		--Inn Passersby
		Smeargle = {
			species = "smeargle",
			nickname = 'Passerby',
			instance = 'Passerby_1',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		--Inn Passersby
		Skorupi = {
			species = "skorupi",
			nickname = 'Passerby',
			instance = 'Passerby_1',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},		
		
		--Inn Passersby
		Corvisquire = {
			species = "corvisquire",
			nickname = 'Passerby',
			instance = 'Passerby_1',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},		
		
		--Inn Passerby
		Ribombee = {
			species = "ribombee",
			nickname = 'Passerby',
			instance = 'Passerby_1',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		}
			
	}


--creates character from stored data and returns them
function CharacterEssentials.MakeCharactersFromList(list, retTable)
	retTable = retTable or false--return a table of chars rather than multiple chars if this is true
	local charTable = {}
	local chara = 0
	local length = 0
	for i = 1, #list, 1 do
		local name = list[i][1]
		length = #list[i]
		local nickname = AdjustNickname(name, characters)
		if length == 1 then--this case is so we can reference characters that aren't on the map. Put them at 0, 0 and hide them
			local monster = RogueEssence.Dungeon.MonsterID(characters[name].species,
															characters[name].form,
															characters[name].skin,
															characters[name].gender)
			chara = RogueEssence.Ground.GroundChar(monster, RogueElements.Loc(0, 0), Direction.Down, nickname, characters[name].instance)
			chara:ReloadEvents()
			GAME:GetCurrentGround():AddTempChar(chara)
			GROUND:Hide(chara.EntName)
			
		elseif length == 2 then --may be inefficient to do a length lookup so often...
			local marker = MRKR(list[i][2])
			local monster = RogueEssence.Dungeon.MonsterID(characters[name].species,
															characters[name].form,
															characters[name].skin,
															characters[name].gender)
			chara = RogueEssence.Ground.GroundChar(monster, RogueElements.Loc(marker.Position.X, marker.Position.Y), marker.Direction, nickname, characters[name].instance)
			chara:ReloadEvents()
			GAME:GetCurrentGround():AddTempChar(chara)
		else
			local x = list[i][2]
			local y = list[i][3]
			local direction = list[i][4]
			local monster = RogueEssence.Dungeon.MonsterID(characters[name].species,
															characters[name].form,
															characters[name].skin,
															characters[name].gender)
			chara = RogueEssence.Ground.GroundChar(monster, RogueElements.Loc(x, y), direction, nickname, characters[name].instance)
			chara:ReloadEvents()
			GAME:GetCurrentGround():AddTempChar(chara)

		end
		chara:OnMapInit()
		local result = RogueEssence.Script.TriggerResult()
		TASK:WaitTask(chara:RunEvent(RogueEssence.Script.LuaEngine.EEntLuaEventTypes.EntSpawned, result, chara))
		charTable[i] = chara
	end
	if retTable then 
		return charTable 
	else
		return table.unpack(charTable)
	end
end




--get a character's name without having to create them
function CharacterEssentials.GetCharacterName(name, no_color)
	local nickname = AdjustNickname(name, characters)
	if no_color then
		return nickname
	else
		return "[color=#00FFFF]" .. nickname .. "[color]"
	end
end



--[[
function CharacterEssentials.MakeCharacterAtMarker(charName, markerName)
	local marker = MRKR(markerName)
	local p = CharacterEssentials.GetCharacter(charName, marker.Position.X, marker.Position.Y, marker.Direction)
	GAME:GetCurrentGround():AddTempChar(p)
	return chara
end
--get a character whose data is stored in this script
--can give either species name (if they're the only one) or actual name
function CharacterEssentials.GetCharacter(name, x, y, direction)
	
	if x == nil then x = 0 end 
	if y == nil then y = 0 end
	--if dir == nil then dir = Direction.Down end--down is a good default direction
	
	local species = "missingno"
	local nickname = "default"
	local instance = "default"
	local gender = Gender.Genderless
	local form = 0--formes 
	local skin = "normal"--shiny?
	
	
	
	species = characters[name].species
	nickname = characters[name].nickname
	instance = characters[name].instance
	gender = characters[name].gender
	form = characters[name].form
	skin = characters[name].skin
	local monster = RogueEssence.Dungeon.MonsterID(species, form, skin, gender)
	local chara = RogueEssence.Ground.GroundChar(monster, RogueElements.Loc(x, y), direction, nickname, instance)
	return chara
--TASK:BranchCoroutine(function() CharacterEssentials.MakeCharacter('Spheal', 'Generic_Spawn_1') end)
end
]]--
