--[[ Colline des Anciens — le Veilleur Xatu.

     ------------------------------------------------------------------
     PLACEMENT (corrige le 2026-08-02)
     ------------------------------------------------------------------
     Dans les jeux d'origine, Xatu ne se tient PAS a l'entree du Grand
     Canyon : il reside sur la Colline des Anciens, une zone distincte
     au sommet du donjon, atteinte apres la traversee complete, et
     accessible uniquement par evenement scripte.

     Cette regle est respectee ici :
       * la Porte du Grand Canyon (grand_canyon_porte) est une simple
         entree de donjon, sans Xatu ;
       * cette Ground n'est jamais atteignable librement. Le seul appel
         qui y mene est zone/new_era_zone_07/init.lua:38, dans
         ExitSegment, a la PREMIERE victoire seulement
         (SV.Reseau.VoiesOuvertes['new_era_zone_07']).

     ------------------------------------------------------------------
     GEOMETRIE (verifiee case par case)
     ------------------------------------------------------------------
     Carte 30x20 tuiles = 240x160 px. Deux composantes libres :
       * le plateau, 252 cases, ou se tiennent le heros et le partenaire ;
       * un eperon rocheux ISOLE de 19 cases (x10..18, y1..3), inaccessible
         a pied, ou se tient Xatu.
     Cette separation est voulue : le script dit « sur l'eperon rocheux,
     en face ». Xatu n'est pas approchable — il est vu, pas rejoint.

     Positions validees (les 4 cases de 8 px de chaque entite 16x16 sont
     libres et dans la bonne composante) :
       heros    (120, 88)  plateau, bord nord
       partenaire (96, 88) plateau, a sa gauche
       Xatu     (112, 16)  eperon, en surplomb
     Le joueur arrive par Main_Entrance_Marker (112,144), face au nord :
     il remonte donc le plateau vers l'eperon, dans l'axe du regard.

     ------------------------------------------------------------------
     FONCTION DRAMATIQUE
     ------------------------------------------------------------------
     On reprend la FONCTION canonique — un devin qui fixe le soleil et
     voit ce que nul autre ne voit — et le MECANISME de la transe. Le
     CONTENU de la vision est propre a New Era : il fait progresser le
     fil rouge des perturbations sans nommer ce qui doit rester tu.

     Ce que Xatu revele : la source des secousses est un titan de magma
     agi par une force exterieure. C'est deja etabli au ch7 par la Team
     Alakazam ; Xatu le CONFIRME et donne la direction.
     Ce que Xatu ne revele PAS : ni l'Abime, ni la meteorite, ni
     Rayquaza, ni la nature de la Voix du heros. Il bute dessus et se
     tait — ce silence est le point de la scene.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.VoiceVisions'
require 'halcyon.BossFX'

local colline_anciens = {}

-- Positions verifiees contre obstacles[] (cf. en-tete).
local HERO_X, HERO_Y = 120, 88
local MATE_X, MATE_Y = 96, 88
local XATU_X, XATU_Y = 112, 16

local function sortie()
  SV.Chapter7.VisitedXatu = true
  GAME:FadeOut(false, 40)
  GAME:EnterGroundMap("metano_town", "Main_Entrance_Marker")
end

function colline_anciens.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_colline_anciens")
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

local function Scene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  -- Fondu pose EN PREMIERE INSTRUCTION : correctif d'arrivee generalise
  -- le 2026-07-30 a 22 scenes. Sans lui, le joueur voit la carte nue se
  -- composer pendant que la mise en place s'execute.
  GAME:FadeOut(false, 1)
  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  GROUND:TeleportTo(hero, HERO_X, HERO_Y, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, MATE_X, MATE_Y, Direction.Up) end

  -- Cadrage sur le plateau, l'eperon hors champ : Xatu ne doit pas etre
  -- visible avant que le texte ne le designe.
  GAME:MoveCamera(112, 96, 1, false)
  SOUND:PlayBGM("Sky Peak Prairie.ogg", true)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  local function say(emo, txt)
    if partner == nil then return end
    UI:SetSpeaker(partner); GeneralFunctions.SetEmotion(emo)
    UI:WaitShowDialogue(txt); GAME:WaitFrames(10)
  end
  local function narrate(txt)
    UI:ResetSpeaker(false); UI:SetCenter(true)
    UI:WaitShowDialogue(txt); UI:SetCenter(false); GAME:WaitFrames(10)
  end
  local function think(emo, txt)
    GeneralFunctions.HeroDialogue(hero, txt, emo); GAME:WaitFrames(10)
  end

  -- ACTE I — le silence du canyon, deja pose par la scene d'entree.
  say("Normal", "On voit tout le canyon d'ici.[pause=20] Tout le chemin qu'on a fait.")
  -- Le vent sans echo etait raconte par une boite de narration. Le guide
  -- des cutscenes l'interdit en cours de scene (section 4) : on le FAIT
  -- ENTENDRE, et c'est le partenaire qui met un mot dessus.
  SOUND:PlayBattleSE("DUN_Wind")
  GAME:WaitFrames(30)
  if partner ~= nil then
    pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  end
  GAME:WaitFrames(20)
  say("Worried", "Tu entends ?[pause=25] Non — justement. On n'entend rien revenir.")
  say("Worried", "Un canyon pareil devrait renvoyer chaque mot.")
  think("Worried", "(J'ai crié, en grimpant.[pause=25] Je ne me suis même pas entendu.)")
  GAME:WaitFrames(15)

  -- ACTE II — la camera revele l'eperon. Xatu apparait par le cadrage,
  -- pas par un effet : il etait la depuis le debut.
  -- Le partenaire repere le premier : il se tourne vers l'eperon AVANT
  -- que la camera n'y monte. On regarde ou il regarde.
  if partner ~= nil then
    pcall(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 6) end)
    pcall(function() GROUND:CharSetEmote(partner, "notice", 1) end)
  end
  GAME:WaitFrames(18)
  say("Surprised", "Là-haut.[pause=25] Sur l'éperon, en face.[pause=20] Quelque chose ne bouge pas.")

  GAME:MoveCamera(112, 56, 60, false)
  local xatu = CharacterEssentials.MakeCharactersFromList({{'Canyon_Xatu', XATU_X, XATU_Y, Direction.Down}})
  pcall(function() GROUND:CharSetAnim(xatu, "Idle", true) end)
  GAME:WaitFrames(40)

  -- Le heros suit le regard du partenaire, avec un temps de retard.
  pcall(function() GROUND:CharAnimateTurnTo(hero, Direction.Up, 6) end)
  GAME:WaitFrames(22)
  say("Surprised", "Un Xatu...[pause=20] le bec levé vers le soleil couchant.")
  GAME:WaitFrames(12)
  think("Worried", "(Il n'a pas bougé d'un pouce.[pause=25] On ne l'avait pas vu.)")
  GAME:WaitFrames(15)

  -- ACTE III — il parle sans se retourner.
  UI:SetSpeaker(xatu); GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Le canyon ne mange pas vos voix.[pause=30] C'est moi.")
  GAME:WaitFrames(15)
  UI:WaitShowDialogue("Je les écoute depuis si longtemps que je les garde toutes.[pause=20] Y compris celles qu'on ne devrait pas entendre.")
  GAME:WaitFrames(20)
  think("Worried", "(Celles qu'on ne devrait pas entendre.[pause=25] Il parle de la mienne ?)")
  GAME:WaitFrames(15)

  UI:SetSpeaker(xatu); GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Vous cherchez d'où viennent les secousses.[pause=25] Approchez.[pause=15] Non — restez où vous êtes.")
  GAME:WaitFrames(12)
  UI:WaitShowDialogue("Personne ne monte ici.[pause=20] On y regarde, c'est tout.")
  GAME:WaitFrames(15)
  say("Normal", "La Team Alakazam nous a parlé de vous.[pause=20] Ils disent que vous voyez ce qui a été et ce qui vient.")
  GAME:WaitFrames(15)

  -- ACTE IV — la transe.
  UI:SetSpeaker(xatu)
  UI:WaitShowDialogue("Ce qui a été.[pause=15] Ce qui vient.[pause=25] En ce moment, les deux se mélangent.[br]Laissez-moi regarder.")
  GAME:WaitFrames(20)

  SOUND:PlayBattleSE("EVT_Title_Intro")
  pcall(function() GROUND:CharSetAnim(xatu, "Charge", true) end)
  BossFX.ShakeScreen(3, 40)
  GAME:FadeOut(true, 10)
  GAME:WaitFrames(20)
  GAME:FadeIn(10)
  GAME:WaitFrames(25)

  SOUND:PlayBattleSE("EVT_Battle_Flash")
  GAME:FadeOut(true, 5)
  GAME:FadeIn(5)
  GAME:WaitFrames(30)

  UI:SetSpeaker(xatu); GeneralFunctions.SetEmotion("Pain")
  UI:WaitShowDialogue("...Une faille.[pause=20] Sous la terre.[pause=20] Elle respire.")
  GAME:WaitFrames(15)

  SOUND:PlayBattleSE("EVT_Battle_Flash")
  GAME:FadeOut(true, 5)
  GAME:FadeIn(5)
  GAME:WaitFrames(30)

  UI:WaitShowDialogue("La lave monte.[pause=20] Quelque chose de très vieux se lève dans sa caldeira.")
  GAME:WaitFrames(15)

  SOUND:PlayBattleSE("EVT_Battle_Flash")
  BossFX.ShakeScreen(4, 30)
  GAME:FadeOut(true, 5)
  GAME:FadeIn(5)
  GAME:WaitFrames(30)

  GeneralFunctions.SetEmotion("Shouting")
  UI:WaitShowDialogue("Un titan de magma ![pause=25] Il gronde —[pause=15] et il n'est pas en colère contre vous.")
  GAME:WaitFrames(20)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue("Quelque chose le pousse.[pause=25] Quelque chose que je ne vois pas.[br]Et je vois tout, d'habitude.")
  GAME:WaitFrames(30)

  -- FIN DE TRANSE
  SOUND:PlayBattleSE("EVT_Emote_Startled_2")
  pcall(function() GROUND:CharEndAnim(xatu) end)
  pcall(function() GROUND:CharSetAnim(xatu, "Idle", true) end)
  GAME:WaitFrames(40)

  say("Surprised", "Pas en colère contre nous...[pause=25] Alors contre quoi ?")
  GAME:WaitFrames(15)

  -- ACTE V — ce qu'il refuse de dire. Le coeur de la scene.
  UI:SetSpeaker(xatu); GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Je l'ignore.[pause=25] C'est la première fois depuis longtemps que je dis cela.")
  GAME:WaitFrames(18)
  UI:WaitShowDialogue("Il y a une ombre derrière ce que je regarde.[pause=25] Quand j'essaie de la fixer,[pause=15] elle recule.")
  GAME:WaitFrames(20)

  -- Il percoit la Voix du heros sans la nommer : premier temoin exterieur.
  UI:SetSpeaker(xatu); GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Toi.[pause=30] Tu portes une voix qui n'est pas la tienne.")
  GAME:WaitFrames(20)
  think("Surprised", "(Il l'entend.[pause=30] Quelqu'un d'autre l'entend.)")
  GAME:WaitFrames(15)
  say("Surprised", "Qu'est-ce que...[pause=20] De quoi parlez-vous ?")
  GAME:WaitFrames(12)
  UI:SetSpeaker(xatu); GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Ce n'est pas à moi de le dire.[pause=30] Et il est trop tôt.")
  GAME:WaitFrames(18)
  UI:WaitShowDialogue("Ne demandez pas ce que c'est.[pause=25] Demandez depuis quand.")
  GAME:WaitFrames(25)

  -- ACTE VI — depart. Il ne s'en va pas : il cesse d'etre visible.
  UI:SetSpeaker(xatu)
  UI:WaitShowDialogue("Allez voir le feu.[pause=25] Et revenez me dire ce que vous y aurez entendu.")
  GAME:WaitFrames(20)

  SOUND:PlayBattleSE("EVT_Battle_Flash")
  BossFX.Flash(XATU_X, XATU_Y, 3, 5, 20)
  pcall(function() GROUND:Hide('Canyon_Xatu') end)
  GAME:WaitFrames(25)
  -- La disparition etait expliquee par une narration. C'est Xatu qui la
  -- commente, du hors-champ : il n'est pas parti, donc il peut encore
  -- parler. La replique fait ce que la narration faisait, en mieux.
  UI:SetSpeaker(xatu)
  UI:WaitShowDialogue("Je ne suis pas parti.[pause=25] J'ai seulement cessé d'être visible.")
  GAME:WaitFrames(12)
  if partner ~= nil then
    pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  end
  GAME:WaitFrames(18)

  -- Retour de camera sur les heros : on redescend du mystere vers eux.
  GAME:MoveCamera(112, 96, 45, false)
  GAME:WaitFrames(20)
  if partner ~= nil then GROUND:CharTurnToCharAnimated(partner, hero, 4) end
  GAME:WaitFrames(10)

  think("Normal", "(Depuis quand.[pause=25] Pas ce que c'est.[pause=20] Depuis quand.)")
  GAME:WaitFrames(15)
  say("Determined", "Un titan de magma, et quelque chose derrière lui.[pause=25] C'est plus que ce qu'on avait en montant.")
  GAME:WaitFrames(12)
  say("Normal", "Rentrons.[pause=20] Le Maître de Guilde doit entendre ça de notre bouche.")
  GAME:WaitFrames(20)
end

function colline_anciens.Enter(map)
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(Scene)
  if not ok then PrintInfo('[colline_anciens] scene ecourtee : '..tostring(err)) end
  -- Restauration garantie meme si la scene a echoue : une scene qui casse
  -- ne doit jamais laisser le joueur en mode cinematique.
  pcall(function()
    UI:ResetSpeaker()
    UI:SetCenter(false)
    local partner = CH('Teammate1')
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', CH('PLAYER'), partner.Position)
    end
    GAME:CutsceneMode(false)
  end)
  sortie()
end

function colline_anciens.Update(map, time) end
function colline_anciens.GameSave(map) end
function colline_anciens.GameLoad(map)
  -- Sauvegarde reprise ici : la carte n'est qu'un couloir de cinematique,
  -- on renvoie le joueur vers la ville plutot que de le laisser bloque.
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  sortie()
end

return colline_anciens
