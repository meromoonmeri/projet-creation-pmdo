--[[
    BossMusic.lua

    DIRECTION MUSICALE DES COMBATS DE BOSS
    ================================================================
    CONSTAT DE L'AUDIT
    ------------------------------------------------------------------
    48 arenes de gardiens sur 49 jouaient EXACTEMENT le meme theme :
    `Boss Battle!.ogg`, une boucle de 46 secondes. Arceus, Rayquaza,
    Dialga, Lugia, les dix Veilleurs et les 42 gardiens d'Ancrage
    partageaient la meme bande-son.

    Pendant ce temps, 14 pistes deja embarquees n'etaient JAMAIS jouees,
    dont plusieurs taillees pour un affrontement majeur :

        Dialga's Fight To the Finish!   2 min 15   1 usage
        Battle Against Dusknoir         1 min 40   0 usage
        In the Future                   2 min 00   0 usage
        Time Restored                   1 min 17   0 usage
        Aegis Cave                      1 min 21   0 usage
        Monster House!                  0 min 55   0 usage

    Le probleme n'etait pas le manque de musique — le mod en embarque
    133 pistes, 216 minutes — mais leur ATTRIBUTION.

    ------------------------------------------------------------------
    PRINCIPE : LA MUSIQUE DIT QUI EST LE BOSS
    ------------------------------------------------------------------
    Chaque famille recoit une couleur sonore, et a l'interieur d'une
    famille les pieces majeures ont leur theme propre. Un joueur doit
    pouvoir reconnaitre A L'OREILLE, avant meme de voir le sprite, s'il
    affronte une machine oubliee, un gardien du ciel ou une entite qui
    precede le monde.

    AUCUN FICHIER AJOUTE. Aucune question de licence : toutes les pistes
    citees ici sont deja dans Content/Music et deja creditees dans
    CREDITS.md. C'est une redistribution, pas un import.

    ------------------------------------------------------------------
    LES SEPT REGISTRES
    ------------------------------------------------------------------
      COSMIQUE     Ce qui precede le monde : origine, temps, espace.
                   -> Dialga's Fight To the Finish! / Temporal Tower
                   Le theme le plus long et le plus dense du repertoire,
                   reserve aux quatre entites qui n'ont pas d'age.

      CIEL         Les gardiens des hauteurs. Registre ample, aerien.
                   -> Sky Tower / Rainbow Peak

      OMBRE        Ce qui vient d'en dessous ou d'a cote. Registre
                   sourd, oppressant. -> The Power of Darkness /
                   Battle Against Dusknoir

      NATURE       Les gardiens du vivant : lacs, forets, saisons.
                   Registre plus clair, moins martial. -> Hidden Land

      TELLURIQUE   Ce qui dort dans la roche et le feu.
                   -> Deep Dark Crater / Enraged Caldera

      MACHINE      Les Veilleurs du Reseau : ce ne sont pas des dieux,
                   ce sont des postes de garde qu'on a oublie de relever.
                   Registre froid, mecanique. -> Aegis Cave / In the Future

      EPREUVE      Mini-boss et rivaux : l'enjeu est sportif, pas cosmique.
                   -> Boss Battle! garde ce role, et REDEVIENT
                   l'exception au lieu d'etre la regle.

    ------------------------------------------------------------------
    USAGE
    ------------------------------------------------------------------
      require 'halcyon.BossMusic'
      BossMusic.Play('escalier_origine')   -- joue le theme de l'arene

    Repli sur 'Boss Battle!.ogg' si l'arene n'est pas dans la table :
    aucune scene ne peut se retrouver muette a cause de ce module.
]]
require 'origin.common'

BossMusic = {}

--Toutes ces pistes sont presentes dans Content/Music (verifie).
local T = {
  COSMIQUE   = "Dialga's Fight To the Finish!.ogg",
  COSMIQUE_2 = 'Temporal Tower.ogg',
  CIEL       = 'Sky Tower.ogg',
  CIEL_2     = 'Rainbow Peak.ogg',
  OMBRE      = 'The Power of Darkness.ogg',
  OMBRE_2    = 'Battle Against Dusknoir.ogg',
  NATURE     = 'Hidden Land.ogg',
  TELLURIQUE = 'Deep Dark Crater.ogg',
  TELLUR_2   = 'Enraged Caldera.ogg',
  MACHINE    = 'Aegis Cave.ogg',
  MACHINE_2  = 'In the Future.ogg',
  EPREUVE    = 'Boss Battle!.ogg',
  MYTHE      = 'Time Restored.ogg',
}

--------------------------------------------------------------------
-- ATTRIBUTION — une ligne par arene, avec la RAISON du choix.
--------------------------------------------------------------------
BossMusic.LIST = {

  ---------------- LES TROIS SCELLES DES RUINES ----------------------
  -- Portage d'Aegis Cave. Les trois gardiens partagent le theme du
  -- donjon d'origine (MACHINE) : ce sont des mecanismes, pas des
  -- creatures, et le meme motif qui les a scelles les anime tous.
  -- Regigigas, lui, garde EPREUVE : il n'est pas un rouage, il est ce
  -- que les rouages gardaient.
  cloven_ruins_regice      = T.MACHINE,
  cloven_ruins_regirock    = T.MACHINE,
  cloven_ruins_registeel   = T.MACHINE,

  ---------------- COSMIQUE : ce qui precede le monde ----------------
  -- Le theme le plus dense du repertoire (2 min 15). Quatre arenes
  -- seulement y ont droit : celles ou l'adversaire est anterieur au
  -- monde lui-meme. La rarete fait l'evenement.
  escalier_origine         = T.COSMIQUE,    -- le Premier Souffle
  fleche_reliques_courroux = T.COSMIQUE,    -- l'Heure qui Traine
  chambre_agee_o           = T.COSMIQUE_2,  -- la Colline Spatiale
  couloir_legendes         = T.COSMIQUE_2,  -- la Spirale Eternelle

  ---------------- CIEL : les gardiens des hauteurs ----------------
  vigie_stratos      = T.CIEL,     -- le Neuvieme Sommet
  autel_celeste      = T.CIEL,     -- l'Autel, fin du chapitre 10
  --Rayquaza deplace au sommet de la Tour Celeste le 2026-08-04.
  --Meme theme : c'est le meme boss, la meme fin de chapitre.
  tour_ciel_sommet   = T.CIEL,     -- Sky Tower Summit, climax Rayquaza
  sky_tower_boss= T.CIEL,     -- le Sommet Sacre
  sommet_aurore      = T.CIEL_2,   -- le Bucher de l'Aurore
  ile_legendaire     = T.CIEL_2,   -- la Premiere Lumiere
  palier_celeste     = T.CIEL_2,   -- le Ciel Fracture (Veilleur aerien)
  -- TORNADUS, gardien du sommet du Mont Venteux (ch5). Registre CIEL
  -- par definition : c'est le seul boss du donjon, il regne sur les
  -- vents de haute montagne. Sky Tower plutot que Rainbow Peak — le
  -- registre ample et tendu convient a un gardien qui juge, pas a une
  -- ascension contemplative.
  mount_windswept_guardian = 'Mt. Travail.ogg', -- sommet venteux : musique du donjon (cutscene + rsmap identiques)

  ---------------- OMBRE : ce qui vient d'a cote ----------------
  grotte_cryptique    = T.OMBRE,   -- le Versant Inverse
  vallon_malsain_fond = T.OMBRE,   -- le Cocon de la Ruine
  creux_ombres_scelle = T.OMBRE,   -- la Seule Ombre
  ile_australe        = T.OMBRE_2, -- l'Autre Lumiere
  ile_close           = T.OMBRE_2, -- la Lumiere Empruntee
  mont_lune_vue       = T.OMBRE_2, -- les Deux Visages du sommeil
  antre_occident      = T.OMBRE_2, -- le Silence Occidental
  waterfall_pond_boss = T.OMBRE, -- Diancie : le doute, pas le combat

  ---------------- NATURE : les gardiens du vivant ----------------
  lac_savoir       = T.NATURE,
  lac_espoir       = T.NATURE,
  lac_courage      = T.NATURE,
  purity_forest_verger= T.NATURE,
  bois_des_plaintes= T.NATURE,
  champ_sacre      = T.NATURE,
  gue_poulain_autel= T.NATURE,
  recif_genereux   = T.NATURE,
  nef_prisme_est   = T.NATURE,
  grotte_echos     = T.NATURE,
  sanctuaire_voeu  = T.NATURE,
  cretes_boreales  = T.NATURE,
  arene_clairiere_secrete = T.NATURE,  -- le jeu, pas la guerre

  ---------------- TELLURIQUE : la roche et le feu ----------------
  arene_trone_magma = T.TELLURIQUE,
  champ_braises     = T.TELLUR_2,
  fosse_volcanique  = T.TELLUR_2,
  plaines_brulees   = T.TELLUR_2,
  terres_tues_porte = T.TELLURIQUE,
  grotte_rocheuse   = T.TELLURIQUE,
  vallon_perdu      = T.TELLURIQUE,   -- le Visiteur Tombe
  abime_tempetes    = T.TELLURIQUE,
  fosse_argentee    = T.TELLURIQUE,

  ---------------- MACHINE : les Veilleurs du Reseau ----------------
  -- Ce ne sont pas des dieux : ce sont des postes de garde qu'on a
  -- oublie de relever. Registre froid, repetitif, mecanique.
  pic_ferreux_pied   = T.MACHINE,
  mt_thunder_pied = T.MACHINE,
  mont_cendre_pied   = T.MACHINE,
  foret_givree_oree  = T.MACHINE_2,
  mont_gele_pied     = T.MACHINE_2,
  fosse_ardente      = T.MACHINE_2,
  carriere_magnetique= T.MACHINE,    -- Magearna : un coeur construit
  labo_decrepit      = T.MACHINE,    -- Genesect : un vieux reacteur

  ---------------- ELECTRIQUE / VIVACITE ----------------
  arene_hautes_plaines = T.EPREUVE,
  porte_plaines_foudre = T.EPREUVE,
  champ_vent_boreal    = T.CIEL_2,

  ---------------- EPREUVE : rivaux et mini-boss ----------------
  sky_tower_fulgur = T.EPREUVE,   -- l'Escouade Fulgur : une course
  gloomy_forest_boss    = T.EPREUVE,   -- Zeraora (musique posee ailleurs)
}

--------------------------------------------------------------------
-- BossMusic.Play(arene)
--------------------------------------------------------------------
-- Lance le theme de l'arene. Repli garanti : une arene absente de la
-- table joue le theme generique plutot que de rester muette.
function BossMusic.Play(arene, loop)
  local m = BossMusic.LIST[arene] or T.EPREUVE
  pcall(function() SOUND:PlayBGM(m, loop ~= false) end)
  return m
end

--Theme d'une arene sans le jouer (utile pour EmptyArena / rejouabilite).
function BossMusic.Get(arene)
  return BossMusic.LIST[arene] or T.EPREUVE
end

return BossMusic
