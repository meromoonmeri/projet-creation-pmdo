--[[
    guild_third_floor_lobby_ch_5_retour.lua
    LE RETOUR DE L'EXPEDITION — bilan du chapitre 5

    ==================================================================
    OU CETTE SCENE SE PLACE
    ==================================================================
    Elle s'enchaine directement sur la fuite des Ruines : le sanctuaire
    se referme, l'ecran passe au noir, un carton de narration couvre le
    trajet de retour, et le noir se leve sur le rassemblement du matin a
    la guilde de Metano. Patron du lendemain matin du chapitre 1.

    ==================================================================
    CE QUE LE BRIEF DOIT COUVRIR — releve dans les scripts, pas de memoire
    ==================================================================
    L'expedition du chapitre 5, dans l'ordre reel de la trame :

      1. LA GRANDE STEPPE. Premier donjon. Absol au bout, un gardien qui
         teste plus qu'il n'attaque. Camp de relais monte a mi-parcours.
         Plum, la Rondoudou, s'incruste des le relais (running gag).
      2. LE TUNNEL ARDENT. Le clan Limagma accuse l'equipe d'avoir
         derange l'equilibre des lieux — « tous ces etrangers qui
         traversent nos terres » (SC5_030). Magcargo, chef du clan,
         provoque le duel. Vaincu, il laisse passer.
      3. LE MONT VENTEUX. Le reve : une silhouette que le heros ne
         reconnait pas lui parle. Elle dit qu'il est deja venu, qu'il a
         demande a oublier, et que le vent le reconnaitra (DRM_011 a
         DRM_022). Au sommet, TORNADUS, « le Souffle qui garde la cime ».
         Il savait qu'on venait.
      4. LES AEGIS CAVE. Les trois scelles — Regice, Regirock,
         Registeel — puis Regigigas. Chacun dit un morceau de la meme
         chose : ils etaient postes FACE a ce qu'ils gardaient, et aucun
         ne sait pourquoi. Le sanctuaire se referme derriere l'equipe.

    ==================================================================
    CE QUE LE BRIEF NE DOIT PAS DIRE — la regle de continuite
    ==================================================================
    * Le Coeur des Anima corrompu n'est PAS revele ici. Le commentaire de
      DefeatedBoss est explicite : « Revelation TARDIVE : le Coeur
      corrompu n'est PAS revele ici — seule reste l'anomalie inquietante
      posee en foreshadowing. Le fil Coeur/Genese/reve Necrozma vit apres
      le ch10. » On garde donc l'inquietude sans la nommer.
    * PERSONNE ne connait la silhouette du reve. Le heros lui-meme ne la
      reconnait pas (DRM_008 : « Je connais cette silhouette. J'en suis
      sur. Presque sur. » puis DRM_009 : « Non. Ca m'echappe encore. »).
      Le partenaire n'en a jamais entendu parler. Phileas peut soupconner
      quelque chose, il ne peut pas savoir.
    * Phileas SAIT plus qu'il ne dit — c'est deja etabli
      (cloven_ruins_boss CRB_015 : « On doit parler a Phileas. Il en sait
      plus qu'il ne le dit. »). Le brief doit donc laisser cette dette
      ouverte, pas la solder.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

guild_third_floor_lobby_ch_5_retour = {}

--------------------------------------------------------------------
local function narre(cle)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[cle]))
  UI:SetCenter(false)
  UI:ResetSpeaker()
end

local function dit(chara, cle, emo)
  if chara == nil then return end
  UI:SetSpeaker(chara)
  if emo ~= nil then GeneralFunctions.SetEmotion(emo) end
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[cle]))
  UI:ResetSpeaker()
end

-- Reaction collective decalee : un groupe qui reagit d'un bloc a l'air
-- mecanique. Chacun tourne la tete a son rythme.
local function versLocuteur(gens, cible, pas)
  local coros = {}
  for i, c in ipairs(gens) do
    if c ~= nil and c ~= cible then
      coros[#coros + 1] = TASK:BranchCoroutine(function()
        GAME:WaitFrames((i - 1) * (pas or 5))
        pcall(function() GROUND:CharTurnToCharAnimated(c, cible, 4) end)
      end)
    end
  end
  if #coros > 0 then TASK:JoinCoroutines(coros) end
end

--------------------------------------------------------------------
-- LE CARTON DE RETOUR — joue sur le noir laisse par la fuite.
--------------------------------------------------------------------
function guild_third_floor_lobby_ch_5_retour.CartonRetour()
  -- L'ecran est deja noir (RuinesRenforts.Effondrement s'est ferme
  -- dessus). Aucun son : le trajet de retour n'a pas de musique, c'est
  -- le silence qui fait passer les jours.
  pcall(function() SOUND:StopBGM() end)
  GAME:WaitFrames(40)
  narre('G5R_CARTON_01')
  GAME:WaitFrames(30)
  narre('G5R_CARTON_02')
  GAME:WaitFrames(30)
  narre('G5R_CARTON_03')
  GAME:WaitFrames(45)
end

--------------------------------------------------------------------
-- LE RASSEMBLEMENT — bilan complet de l'expedition.
--------------------------------------------------------------------
function guild_third_floor_lobby_ch_5_retour.BilanExpedition()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local tropius, noctowl, audino, snubbull, growlithe, zigzagoon, girafarig,
        breloom, mareep, cranidos =
        guild_third_floor_lobby_helper.SetupMorningAddress(false)

  local tous = { tropius, noctowl, audino, snubbull, growlithe, zigzagoon,
                 girafarig, breloom, mareep, cranidos, partner, hero }

  pcall(function() SOUND:PlayBGM('Guildmaster Wigglytuff.ogg', true) end)
  GAME:FadeIn(60)
  GAME:WaitFrames(40)

  -- ================================================================
  -- ACTE 1 — PENTICUS OUVRE. Le ton n'est pas triomphal.
  -- ================================================================
  dit(tropius, 'G5R_001', "Normal")
  GAME:WaitFrames(18)
  versLocuteur(tous, tropius, 5)
  dit(tropius, 'G5R_002', "Happy")
  GAME:WaitFrames(20)

  -- ================================================================
  -- ACTE 2 — LE BILAN, DONJON PAR DONJON. C'est Phileas qui recense :
  -- c'est son role d'archiviste, deja etabli.
  -- ================================================================
  versLocuteur(tous, noctowl, 6)
  dit(noctowl, 'G5R_003', "Normal")
  GAME:WaitFrames(16)
  dit(noctowl, 'G5R_004', "Normal")   -- la Steppe
  GAME:WaitFrames(20)

  -- Le Tunnel : Ganlon reagit, il y etait.
  dit(noctowl, 'G5R_005', "Worried")
  GAME:WaitFrames(14)
  pcall(function() GROUND:CharSetEmote(cranidos, "exclaim", 1) end)
  dit(cranidos, 'G5R_006', "Determined")
  GAME:WaitFrames(16)
  dit(noctowl, 'G5R_007', "Normal")
  GAME:WaitFrames(20)

  -- Le Mont : Shuca prend la parole. Elle a vu Tornadus.
  versLocuteur({ tropius, noctowl, cranidos, partner, hero }, mareep, 5)
  dit(mareep, 'G5R_008', "Worried")
  GAME:WaitFrames(18)
  dit(mareep, 'G5R_009', "Normal")
  GAME:WaitFrames(20)

  -- ================================================================
  -- ACTE 3 — LES RUINES. Le silence tombe : c'est la partie que
  -- personne dans la salle ne comprend.
  -- ================================================================
  pcall(function() SOUND:FadeOutBGM(50) end)
  GAME:WaitFrames(40)
  versLocuteur(tous, partner, 6)
  dit(partner, 'G5R_010', "Worried")
  GAME:WaitFrames(20)
  dit(partner, 'G5R_011', "Normal")
  GAME:WaitFrames(22)

  -- La question de Regigigas, rapportee telle quelle. Elle reste sans
  -- reponse : c'est le moteur de la suite.
  dit(partner, 'G5R_012', "Worried")
  GAME:WaitFrames(30)

  -- Reaction de la salle, echelonnee.
  pcall(function() GROUND:CharSetEmote(audino, "sweating", 1) end)
  dit(audino, 'G5R_013', "Worried")
  GAME:WaitFrames(16)
  pcall(function() GROUND:CharSetEmote(zigzagoon, "shock", 1) end)
  dit(zigzagoon, 'G5R_014', "Surprised")
  GAME:WaitFrames(18)

  -- ================================================================
  -- ACTE 4 — PHILEAS SAIT QUELQUE CHOSE, ET NE LE DIT PAS.
  -- Dette narrative deja posee (CRB_015). On la laisse ouverte.
  -- ================================================================
  versLocuteur(tous, noctowl, 5)
  GAME:WaitFrames(20)
  dit(noctowl, 'G5R_015', "Worried")
  GAME:WaitFrames(25)
  dit(noctowl, 'G5R_016', "Normal")
  GAME:WaitFrames(20)

  -- Le heros pense — il ne parle jamais a voix haute.
  if hero ~= nil then
    GeneralFunctions.HeroDialogue(hero,
      STRINGS:Format(STRINGS.MapStrings['G5R_017']), "Worried")
  end
  GAME:WaitFrames(22)

  -- ================================================================
  -- ACTE 5 — PENTICUS CLOT. Repos, puis la suite.
  -- ================================================================
  pcall(function() SOUND:PlayBGM('Guildmaster Wigglytuff.ogg', true) end)
  versLocuteur(tous, tropius, 5)
  dit(tropius, 'G5R_018', "Normal")
  GAME:WaitFrames(18)
  dit(tropius, 'G5R_019', "Happy")
  GAME:WaitFrames(20)

  -- Le cri de la guilde, comme chaque matin.
  local coros = {}
  for i, c in ipairs(tous) do
    if c ~= nil and c ~= hero then
      coros[#coros + 1] = TASK:BranchCoroutine(function()
        GAME:WaitFrames((i - 1) * 3)
        pcall(function() GROUND:CharSetEmote(c, "exclaim", 1) end)
      end)
    end
  end
  if #coros > 0 then TASK:JoinCoroutines(coros) end
  narre('G5R_020')
  GAME:WaitFrames(30)
end

return guild_third_floor_lobby_ch_5_retour
