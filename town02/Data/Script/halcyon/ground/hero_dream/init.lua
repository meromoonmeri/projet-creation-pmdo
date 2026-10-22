--[[
    init.lua
    Carte : hero_dream — LE REVE DU HEROS (chapitre 5, nuit du Mont Venteux)
    ------------------------------------------------------------------
    CARTE DEDIEE, et voici pourquoi.

    Le reve se jouait auparavant SUR la carte du camp, en superposant un
    overlay au bivouac endormi. Deux problemes structurels, tous deux
    constates en jeu :

      1. L'overlay etait cull par le moteur. OverlayEmitter.cs:83 cree
         son OverlayAnim avec omnipresent = false ; GetDrawSize() rend
         alors Loc(TileSize) = 24x24, et BaseScene.IterateRelevantDraw ne
         dessine que si ce rectangle touche le ViewRect. Un overlay pose
         en (0,0) alors que la camera cadre le camp disparait purement et
         simplement du rendu.
      2. Meme visible, il fallait masquer douze dormeurs, un feu, onze
         paillasses et une falaise. On empilait des couches pour cacher
         un decor qui n'avait rien a faire la.

    Sur une carte dediee, le decor onirique n'est plus un overlay : c'est
    le FOND DE CARTE (Background.Layers de type LayeredBG). C'est
    exactement ce que fait le test de personnalite du jeu d'origine,
    Data/Ground/personality_test.rsground, dont ce .rsground est une
    copie structurelle : deux planches Dream_Back (alpha 255, derive
    +30) et Dream_Front (alpha 128, derive -30) qui glissent en sens
    CONTRAIRES. Le croisement des deux derives EST la profondeur
    onirique que le joueur reconnait.

    Le moteur dessine ce fond avant tout le reste, sans condition de
    culling. Il ne peut donc pas disparaitre.

    Carte de 320x240 px : un ecran pile. Sol entierement libre (Tags=0
    partout) — dans un reve, rien ne bloque. Marqueur unique au centre
    exact (152,112).
]]--
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

local hero_dream = {}

-- Map Callbacks
function hero_dream.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_hero_dream <<= [build 2026-08-03-N]')

  --L'ECRAN EST NOIR AVANT LE PREMIER RENDU.
  --Le moteur ne pose aucun fondu entre deux cartes : moveToZoneInit
  --commente explicitement « no fade; the script handles that itself ».
  --Ce que le script precedent a laisse a l'ecran y reste. Sans ce
  --FadeOut, le joueur verrait le ciel de reve apparaitre d'un coup,
  --avec la camera en train de sauter a sa place. Instantane et
  --idempotent : si l'ecran est deja noir, il ne se passe rien.
  pcall(function() GAME:FadeOut(false, 1) end)

  -- LE JOUEUR DOIT EXISTER SUR LA CARTE.
  -- Sous pcall, comme tout le reste de cet Init : cet appel s'execute
  -- DANS la coroutine de bascule (moveToZoneInit -> InitGround). S'il
  -- levait une erreur, la coroutine mourrait au milieu du changement
  -- de carte — casse prouvee : CurrentGround null + SceneOutcome null
  -- = NullReferenceException dans ProcessInput a chaque frame (trace
  -- relevee en jeu le 2026-07-30). En cas d'echec, DreamScene sait
  -- renoncer proprement (test hero == nil -> retour au camp garanti).
  pcall(function() COMMON.RespawnAllies() end)

  -- LE MODE CINEMATIQUE EST POSE DES L'INIT, PAS DANS LA SCENE.
  --     if (GameManager.Instance.SceneOutcome == null)
  --         yield return ... ZoneManager.Instance.CurrentGround.OnCheck();
  -- `CurrentGround` y est nul. Il l'est parce que la bascule de carte
  -- SetPlayerChar(null) puis SetCurrentMap(SegLoc.Invalid) — et
  -- SetCurrentMap appelle exitMap(), qui pose CurrentGround = null
  -- Ce que ProcessInput ne fait PAS quand le mode cinematique est actif :
  -- la garde `if (DataManager.Instance.Save.CutsceneMode) yield break;`
  -- n'atteigne OnCheck. Mode cinematique actif = aucun risque.
  -- Or DreamScene ne posait CutsceneMode(true) qu'apres son test
  -- `if hero == nil`, donc APRES Init et APRES le premier tour de boucle
  -- possible. Entre l'Init de cette carte et le Enter qui lance la
  -- scene, la boucle principale peut tourner (ScreenMainCoroutine
  -- l.505-507 appelle ProcessInput tant que SceneOutcome est nul), et
  -- elle tombe alors sur un CurrentGround en cours de remplacement.
  -- On le pose donc ICI, comme le fait la carte dont hero_dream est
  -- copie : personality_test/init.lua:86 ouvre CharacterSelect par
  -- GAME:CutsceneMode(true). C'est le patron atteste du depot.
  -- DreamScene le repose (idempotent, simple booleen de sauvegarde —
  pcall(function() GAME:CutsceneMode(true) end)
end

function hero_dream.Enter(map)
  --Trace d'entree : si cette ligne apparait dans le log, la bascule a
  --bien abouti et la scene demarre. Son absence, alors que le camp a
  --logue « bascule armee », signifierait un echec cote moteur.
  PrintInfo('[hero_dream] Enter — la scene du reve demarre')
  hero_dream.DreamScene()
end

function hero_dream.Exit(map) end
function hero_dream.Update(map) end
function hero_dream.GameSave(map) end

function hero_dream.GameLoad(map)
  --Sauvegarder PENDANT le reve ne devrait pas arriver (CutsceneMode est
  --actif du debut a la fin), mais si un joueur y parvient, on ne le
  --laisse pas coince dans un decor sans sortie : on rejoue la scene.
  hero_dream.DreamScene()
end

-- LA SCENE
-- Structure en huit temps, relevee dans pret/pmd-red
-- (src/data/ground/ground_data_a01p01_station.h, les reves successifs
-- du heros). L'ordre du jeu d'origine EST l'effet :
--   1. Trois boites de points de plus en plus longues. Personne ne
--      parle : c'est le dormeur qui remonte vers la surface.
--   2. La desorientation vient AVANT toute presence.
--   3. La boite se FERME. Un vrai silence, pas un blanc.
--   4. La presence est APERCUE avant d'etre entendue.
--   5. L'oubli est pose des le premier reve.
--   6. L'entite parle. Phrases courtes, beaucoup de suspension.
--   7. Le heros pose LA question : « pourquoi mes reves ? »
--   8. « Le jour se leve », puis le reveil et l'oubli.
-- MISE EN SCENE. Une cinematique de Donjon Mystere ne se joue pas en
-- enchainant des boites. Chaque replique de cette scene est portee par
-- au moins un element non textuel :
--   * le heros DORT au centre et ne se leve jamais — il reve ;
--   * la camera respire (derives de 6 a 12 px sur 90 a 180 frames), et
--     ne quitte JAMAIS le heros du cadre ;
--   * l'entite apparait par CLIGNOTEMENT (Absent -> Transparent ->
--     visible), jamais d'un coup ;
--   * les silences sont ecrits comme des repliques : WaitFrames longs,
--     boite fermee, rien a l'ecran que le ciel qui derive.

--Helper local : la Voix. Anonyme (\uE040), sans nom, sans portrait.
--Regle projet non negociable — c'est au joueur de reconnaitre, jamais
--au jeu de nommer.
local function voice(key)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[key]))
end

--Helper local : le dormeur. Voix off centree, jamais de portrait — il
--reve, il n'a pas de corps ici. C'est aussi ce que fait pmd-red
--(MSG_QUIET, jamais de portrait du heros pendant un reve).
local function dreamer(key)
  UI:SetCenter(true)
  UI:ResetSpeaker(false)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[key]))
  UI:SetCenter(false)
  UI:ResetSpeaker()
end

--Helper local : un silence. La boite se ferme et il ne reste que
--l'image. C'est le TEXTBOX_CLEAR + WAIT de pmd-red, et c'est ce qui
--manque le plus aux scenes qui « enchainent les dialogues ».
local function silence(frames)
  UI:SetCenter(false)
  UI:ResetSpeaker()
  GAME:WaitFrames(frames or 40)
end

-- Helper locals for ruins-specific dialogues to preserve narrative logic
local function ruins_voice(key)
  local return_map = "mount_windswept_entrance"
  pcall(function()
    if SV.TemporaryFlags ~= nil and SV.TemporaryFlags.DreamReturn ~= nil then
      return_map = SV.TemporaryFlags.DreamReturn
    end
  end)
  local k = key
  if return_map == 'cloven_ruins_entrance' then
    k = key .. '_RUINS'
  end
  voice(k)
end

local function ruins_dreamer(key)
  local return_map = "mount_windswept_entrance"
  pcall(function()
    if SV.TemporaryFlags ~= nil and SV.TemporaryFlags.DreamReturn ~= nil then
      return_map = SV.TemporaryFlags.DreamReturn
    end
  end)
  local k = key
  if return_map == 'cloven_ruins_entrance' then
    k = key .. '_RUINS'
  end
  dreamer(k)
end

--Corps du reve. Scinde de DreamScene pour que la SORTIE soit garantie :
--une erreur au milieu de la scene laissait auparavant le joueur sur un
--ecran noir sans issue, exactement le symptome signale (« le moment du
--reve est toujours un crash black screen »). Le contenu est inchange.
local function DreamSceneBody()
  --LE MODE CINEMATIQUE D'ABORD, AVANT MEME DE LIRE LE JOUEUR.
  --Il est deja pose par Init ; on le repose ici car GameLoad appelle
  --aussi cette fonction sans repasser par Init. C'est un simple booleen
  --Il doit surtout preceder la sortie de secours ci-dessous : celle-ci
  --appelle EnterGroundMap, qui ARME la bascule de carte
  --et toute frame executee sans mode cinematique tombe sur
  --jeu au moment du coucher.
  pcall(function() GAME:CutsceneMode(true) end)

  local hero = CH('PLAYER')

  --SORTIE DE SECOURS. Si le joueur n'est pas sur la carte, on ne joue
  --RIEN et on renvoie immediatement au camp : mieux vaut sauter le reve
  --que bloquer la partie sur une carte vide et sans sortie.
  --On se contente de SORTIR DU CORPS : le retour au camp est desormais
  --assure par DreamScene, apres le pcall. Appeler EnterGroundMap ici
  --aurait arme la bascule une premiere fois, puis le wrapper une seconde
  --— deux SceneOutcome pour un seul changement de carte.
  if hero == nil then
    PrintInfo("[hero_dream] PLAYER introuvable — reve saute, retour au camp")
    return
  end

  SOUND:StopBGM()

  -- 0. L'ECRAN NOIR SILENCIEUX — « Cela faisait longtemps, »
  --
  -- Brief, section 3 : « Avant que le reve ne s'ouvre visuellement, la
  -- scene passe par un ECRAN NOIR AVEC DU TEXTE, dans le meme esprit
  -- qu'un texte de transition "le lendemain matin" — ici la ligne est
  -- "Cela faisait longtemps,". Ce moment doit etre TOTALEMENT
  -- SILENCIEUX : aucune musique, aucun bruitage, aucun son — le silence
  -- est un choix de mise en scene assume, pas un flottement technique.
  -- Ce n'est QU'APRES ce texte en ecran noir silencieux que l'on
  -- enchaine vers l'ouverture visuelle du reve : c'est a cet instant
  -- precis que le parallax et la musique demarrent ENSEMBLE. »
  --
  -- Ce beat manquait entierement : on passait du noir directement au
  -- FadeIn avec la musique. La bascule entre le silence et l'entree dans
  -- le reve n'existait donc pas.
  --
  -- Le silence est REEL, et pas seulement suppose :
  --   * StopBGM ci-dessus a coupe la musique du camp ;
  --   * FadeOutSE coupe l'ambiance de feu que la veillee laissait
  --     tourner en boucle (AMB_Fire_Loud, LoopSE dans CampNightfall) —
  --     sans lui, le « totalement silencieux » du brief etait faux, on
  --     aurait entendu le bivouac par-dessus l'ecran noir ;
  --   * aucun PlayBGM ne survient avant le FadeIn, plus bas.
  --
  -- L'ecran est deja noir (Init a pose FadeOut(false,1)) : la boite
  -- s'affiche donc bien SUR le noir, pas sur le decor.
  pcall(function() SOUND:FadeOutSE('AMB_Fire_Loud', 30) end)
  GAME:WaitFrames(50)

  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['DRM_000']))
  UI:SetCenter(false)
  UI:ResetSpeaker()
  GAME:WaitFrames(40)

  -- MISE EN PLACE, SOUS LE NOIR
  --LE HEROS REVE SEUL. RespawnAllies a pu faire apparaitre le
  --partenaire (il est dans l'equipe) : on le retire de la carte, il
  --n'a rien a faire dans ce reve. GROUND:Hide suffit — le supprimer
  --casserait sa restauration au retour.
  pcall(function()
    local partner = CH('Teammate1')
    if partner ~= nil then GROUND:Hide(partner.EntName) end
  end)

  --Le heros au centre exact de l'ecran (152,112), couche. « EventSleep »
  --est la pose de sommeil utilisee par tout le mod pour le heros
  --(searing_tunnel_entrance, mount_windswept_entrance).
  GROUND:TeleportTo(hero, 152, 112, Direction.Down)
  pcall(function() GROUND:CharSetAnim(hero, "EventSleep", true) end)

  --La camera est centree sur lui et NE LE QUITTERA PAS. Tous les
  --mouvements de cette scene sont des derives de quelques pixels
  --autour de ce point.
  GAME:MoveCamera(160, 120, 1, false)

  --L'ENTITE. Creee des maintenant, mais INVISIBLE (DrawEffect.Absent
  --met l'opacite a 0 — GroundAction.UpdateDrawEffects:79). Elle est
  --posee au nord du heros, legerement decalee : elle le domine sans
  --l'ecraser, et les deux tiennent dans le meme plan.
  --Le sprite est celui de Gardevoir (index national 282). PMDO fournit
  --nativement les sprites d'especes : Content/Chara/ d'un mod
  --ModType=Quest n'est qu'une SURCHARGE partielle, pas la liste des
  local entity = nil
  pcall(function()
    local id = RogueEssence.Dungeon.MonsterID("gardevoir", 0, "normal", Gender.Female)
    entity = RogueEssence.Ground.GroundChar(id, RogueElements.Loc(152, 48), Direction.Down, "DreamEntity", "DreamEntity")
    entity:ReloadEvents()
    GAME:GetCurrentGround():AddTempChar(entity)
    GROUND:CharSetDrawEffect(entity, DrawEffect.Absent)
  end)

  --Le ciel de reve tourne deja derriere le noir. On leve la lumiere
  --DESSUS : le joueur voit le noir s'ouvrir directement sur le ciel
  --onirique, sans jamais entrapercevoir le camp.
  --LA MEME MUSIQUE QUE LE TEST DE PERSONNALITE, A L'IDENTIQUE.
  --
  --Brief, section 3, option B (celle retenue) : « le parallax et la
  --musique de cette scene de reve NE SONT PAS une nouvelle creation
  --"dans l'esprit de" celle du test de personnalite — ce sont LES MEMES
  --ASSETS, REUTILISES A L'IDENTIQUE : meme parallax de couleur, meme
  --morceau de musique. Aucune variation ou nouvelle version ne doit etre
  --produite pour cette scene ; l'objectif est la reconnaissance
  --immediate par le joueur du meme langage visuel et sonore. »
  --
  --Le parallax etait deja conforme (Dream_Back, verifie identique au
  --champ Background de personality_test.rsground, octet pour octet).
  --La MUSIQUE, elle, ne l'etait pas : cette scene jouait
  --'I Saw Something Again....ogg', un morceau d'inquietude, alors que le
  --test de personnalite joue 'Welcome to the World of Pokémon!.ogg'
  --(personality_test/init.lua:141). Le joueur perdait donc exactement la
  --reconnaissance que le brief demande — moitie du dispositif seulement.
  SOUND:PlayBGM('Welcome to the World of Pokémon!.ogg', true)
  GAME:FadeIn(70)
  GAME:WaitFrames(60)

  -- 1. L'EMERGENCE — le dormeur remonte vers la surface
  --Trois respirations, de plus en plus longues, entrecoupees de
  --silences croissants. Rien ne bouge a l'ecran que le ciel : c'est
  --voulu, le joueur doit se sentir endormi avant qu'il se passe quoi
  --que ce soit.
  UI:SetCenter(true)
  UI:ResetSpeaker(false)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['DRM_001']))
  GAME:WaitFrames(25)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['DRM_002']))
  GAME:WaitFrames(35)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['DRM_003']))
  UI:SetCenter(false)
  UI:ResetSpeaker()
  GAME:WaitFrames(45)

  -- 2. LA DESORIENTATION — avant toute presence
  --La camera commence a deriver, tres lentement, vers le haut : le
  --regard du dormeur cherche quelque chose qui n'est pas encore la.
  --12 px sur 150 frames = un mouvement qu'on ressent sans le voir.
  local d1 = TASK:BranchCoroutine(function()
    GAME:MoveCamera(160, 108, 150, false)
  end)
  local d2 = TASK:BranchCoroutine(function()
    dreamer('DRM_004')
    GAME:WaitFrames(20)
    dreamer('DRM_005')
  end)
  TASK:JoinCoroutines({d1, d2})
  silence(35)
  dreamer('DRM_006')
  silence(50)

  -- 3. LA PRESENCE — elle apparait par clignotement
  --L'APPARITION. Trois paliers d'opacite, exactement comme les
  --apparitions des jeux officiels : rien -> fantome -> presence.
  --Le moteur n'expose que trois etats (UpdateDrawEffects:78-82) :
  --   DrawEffect.Absent      -> opacite 0
  --   DrawEffect.Transparent -> opacite 128
  --   aucun effet            -> opacite 255
  --On les enchaine en alternance pour obtenir un CLIGNOTEMENT : elle
  --vacille trois fois avant de se stabiliser, comme une image qui
  --peine a se former.
  local se_ok = pcall(function() SOUND:PlayBattleSE('_UNK_DUN_Water_Drop') end)
  GAME:WaitFrames(30)

  if entity ~= nil then
    local blink = TASK:BranchCoroutine(function()
      for i = 1, 3 do
        pcall(function()
          GROUND:CharEndDrawEffect(entity, DrawEffect.Absent)
          GROUND:CharSetDrawEffect(entity, DrawEffect.Transparent)
        end)
        GAME:WaitFrames(10 + i * 4)
        pcall(function()
          GROUND:CharEndDrawEffect(entity, DrawEffect.Transparent)
          GROUND:CharSetDrawEffect(entity, DrawEffect.Absent)
        end)
        GAME:WaitFrames(8)
      end
      --Elle se stabilise : d'abord fantome, puis pleinement la.
      pcall(function()
        GROUND:CharEndDrawEffect(entity, DrawEffect.Absent)
        GROUND:CharSetDrawEffect(entity, DrawEffect.Transparent)
      end)
      GAME:WaitFrames(50)
      pcall(function() GROUND:CharEndDrawEffect(entity, DrawEffect.Transparent) end)
    end)
    --Pendant qu'elle se forme, la camera glisse tres legerement vers
    --elle — 6 px : le dormeur tourne la tete, il ne se leve pas.
    local look = TASK:BranchCoroutine(function()
      GAME:WaitFrames(40)
      GAME:MoveCamera(160, 102, 120, false)
    end)
    TASK:JoinCoroutines({blink, look})
  end
  GAME:WaitFrames(30)

  --Le heros la remarque. Trois pensees separees par des silences : il
  --cherche, il croit reconnaitre, il abandonne.
  dreamer('DRM_007')
  silence(40)
  dreamer('DRM_008')
  silence(45)
  dreamer('DRM_009')
  silence(55)

  -- 4. ELLE PARLE — accueil, pas menace
  --
  -- SON CORPS PARLE AUSSI, ET C'EST UNE EXIGENCE DU BRIEF.
  -- « Ses mouvements doivent etre elegants — elle ne se comporte jamais
  --   comme un PNJ banal. »
  -- Elle etait jusqu'ici parfaitement immobile pendant les dix-sept
  -- repliques : bien apparue, puis plantee. Un sprite qui ne bouge plus
  -- redevient exactement le PNJ banal que le brief refuse.
  --
  -- Le vocabulaire gestuel est volontairement PAUVRE et LENT : elle ne
  -- gesticule pas, elle incline la tete et flotte de quelques pixels.
  -- Trois gestes seulement sur toute la scene, aux trois moments qui
  -- comptent — c'est la regle de dosage du fichier de methode : la
  -- rarete d'un effet fait son impact.
  --
  -- `hoverEntity` : une derive verticale de 4 px, aller-retour, sur une
  -- duree longue. Ce n'est pas un saut — Hop culmine et retombe sec.
  -- On passe par MoveToPosition en vitesse 1 (la plus lente attestee du
  -- depot) pour obtenir un glissement, jamais un pas.
  local function hoverEntity()
    if entity == nil then return end
    pcall(function()
      local x, y = entity.Position.X, entity.Position.Y
      GROUND:MoveToPosition(entity, x, y - 4, false, 1)
      GROUND:MoveToPosition(entity, x, y, false, 1)
    end)
  end

  --Elle s'adresse a lui : elle s'oriente vers le dormeur AVANT de
  --parler (le corps parle avant la bouche, regle du projet).
  if entity ~= nil then
    pcall(function() GROUND:CharTurnToCharAnimated(entity, hero, 8) end)
    GAME:WaitFrames(20)
  end

  --Sa premiere phrase tombe apres un long silence : c'est elle qui
  --rompt le vide, et cela suffit a la rendre presente.
  voice('DRM_010')
  GAME:WaitFrames(35)
  --Elle flotte doucement en disant « tu as fait tout ce chemin » : le
  --seul mouvement du plan, donc on le remarque.
  local h1 = TASK:BranchCoroutine(function() hoverEntity() end)
  local h2 = TASK:BranchCoroutine(function() ruins_voice('DRM_011') end)
  TASK:JoinCoroutines({h1, h2})
  silence(40)

  ruins_dreamer('DRM_012')
  GAME:WaitFrames(30)
  ruins_voice('DRM_013')
  silence(45)

  ruins_dreamer('DRM_014')
  --LE BATTEMENT LE PLUS LONG DE LA SCENE. « Pas encore. Et pourtant
  --si. » est la phrase qui doit rester au joueur : on la laisse
  --arriver dans le vide, et on la laisse resonner apres.
  silence(60)
  --DEUXIEME GESTE. Elle detourne le regard une seconde avant de
  --repondre — la seule fois de la scene ou elle ne le fixe pas. C'est
  --ce que fait quelqu'un qui en sait plus qu'il n'en dit, et ca prepare
  --« Et pourtant si. » sans qu'aucune ligne n'ait a l'expliquer.
  if entity ~= nil then
    pcall(function()
      GROUND:CharAnimateTurnTo(entity, Direction.DownRight, 8)
    end)
    GAME:WaitFrames(30)
    pcall(function() GROUND:CharTurnToCharAnimated(entity, hero, 8) end)
    GAME:WaitFrames(15)
  end
  ruins_voice('DRM_015')
  silence(70)

  -- 5. LA QUESTION PIVOT
  --Le heros pose enfin la question. La camera se recentre doucement
  --sur lui pendant qu'il parle : le plan revient a celui qui demande.
  local q1 = TASK:BranchCoroutine(function()
    GAME:MoveCamera(160, 116, 110, false)
  end)
  local q2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(15)
    dreamer('DRM_016')
  end)
  TASK:JoinCoroutines({q1, q2})
  silence(40)

  voice('DRM_017')
  GAME:WaitFrames(30)
  voice('DRM_018')
  silence(55)

  -- 5bis. LA QUESTION HUMAINE — uniquement si les reves precedents ont
  -- eu lieu (Mont Venteux + premier reve du heros). Sans eux, la
  -- question n'aurait aucun fondement pour le joueur. Le heros a entendu
  -- Phileas raconter qu'autrefois un humain vivait parmi l'equipe ; il
  -- rapproche ce souvenir de la silhouette du reve. Gardevoir esquive —
  -- un detournement de regard, le seul de la scene avec DRM_015 — puis
  -- repond sans confirmer ni nier : elle note sa perspicacite.
  if SV.Chapter5 ~= nil and SV.Chapter5.DreamSceneSeen and SV.Chapter5.HadFirstDream then
    ruins_dreamer('DRM_016b')
    silence(35)
    if entity ~= nil then
      pcall(function() GROUND:CharAnimateTurnTo(entity, Direction.DownRight, 8) end)
      GAME:WaitFrames(28)
      pcall(function() GROUND:CharTurnToCharAnimated(entity, hero, 8) end)
      GAME:WaitFrames(15)
    end
    ruins_voice('DRM_016c')
    silence(45)
  end

  -- 6. L'AVERTISSEMENT — demain, la montagne
  ruins_voice('DRM_019')
  GAME:WaitFrames(35)
  ruins_voice('DRM_020')

  --« Pas avec ce corps. » L'image vacille au moment ou le heros touche
  --ce qu'il ne doit pas encore comprendre. Tangage court et doux : on
  --est dans un reve, pas dans un combat.
  pcall(function()
    SOUND:PlayBattleSE('EVT_Emote_Startled')
    GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 34))
  end)
  GAME:WaitFrames(50)

  dreamer('DRM_021')
  silence(45)
  ruins_voice('DRM_022')
  silence(40)
  --La derniere consigne, celle qui arme le sommet du chapitre.
  voice('DRM_023')
  silence(65)

  -- 7. LA SEPARATION — elle s'efface pendant qu'elle parle
  voice('DRM_024')
  GAME:WaitFrames(25)

  --Le heros tend la main. Elle s'efface EN MEME TEMPS qu'elle repond :
  --le fondu de sa silhouette et sa derniere phrase se terminent
  --ensemble. C'est la seule facon de rendre un adieu qu'on ne choisit
  --pas.
  local f1 = TASK:BranchCoroutine(function()
    dreamer('DRM_025')
    GAME:WaitFrames(20)
    voice('DRM_026')
  end)
  local f2 = TASK:BranchCoroutine(function()
    --TROISIEME ET DERNIER GESTE. Elle s'eleve de 6 px pendant qu'elle
    --s'efface : elle ne PART pas (aucune sortie de champ, aucune
    --marche), elle se dissout en montant. C'est le geste qui distingue
    --une presence onirique d'un PNJ qui s'en va — et c'est le dernier
    --de la scene, donc celui qu'on retient.
    if entity ~= nil then
      pcall(function()
        local x, y = entity.Position.X, entity.Position.Y
        GROUND:MoveToPosition(entity, x, y - 6, false, 1)
      end)
    end
    GAME:WaitFrames(30)
    if entity ~= nil then
      pcall(function() GROUND:CharSetDrawEffect(entity, DrawEffect.Transparent) end)
      GAME:WaitFrames(70)
      pcall(function() GROUND:CharSetDrawEffect(entity, DrawEffect.Absent) end)
    end
  end)
  local f3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(40)
    SOUND:FadeOutBGM(120)
  end)
  TASK:JoinCoroutines({f1, f2, f3})
  silence(50)

  --Le ciel s'eteint. Tout part ensemble : l'image, la musique, le reve.
  GAME:FadeOut(false, 70)
  GAME:WaitFrames(40)

  -- 8. LE REVEIL — de l'autre cote, au camp
  --La scene ne se termine PAS ici : elle rend la main a la carte du
  --camp, qui joue le sursaut et l'oubli. Le drapeau dit au camp que le
  --reve a eu lieu.
  SV.Chapter5.DreamSceneSeen = true
  --Le reve est partage entre plusieurs camps du ch5 (Mont Venteux et
  --Aegis Cave) : on pose aussi le drapeau propre au camp qui a
  --appele, identifie par la carte de retour qu'il a posee. Le routeur
  --des Ruines (cloven_ruins_entrance) lit RuinsDreamSeen pour ne pas
  --rejouer la veillee en boucle.
  pcall(function()
    if SV.TemporaryFlags ~= nil and SV.TemporaryFlags.DreamReturn == 'cloven_ruins_entrance' then
      SV.Chapter5.RuinsDreamSeen = true
    end
  end)

  --Le heros ne doit pas rester couche sur la carte suivante.
  pcall(function() GROUND:CharEndAnim(hero) end)

  --On repart vers le camp, ecran noir conserve (3e argument =
  --preserveMusic : il n'y a plus de musique a preserver, mais il evite
  --que le moteur relance celle de la carte d'arrivee avant le reveil).
  --On NE relache PAS le mode cinematique ici : ResumeAfterDream le
  --reprend des l'arrivee, et le couper laisserait le joueur bouger sur
  --la carte du reve pendant que la bascule se prepare.
end

function hero_dream.DreamScene()
  --SORTIE GARANTIE.
  --Le corps est joue sous pcall : si une seule de ses instructions echoue,
  --le moteur avorte la coroutine (xpcall, LuaEngine.cs:895) et plus rien
  --ne s'execute — l'ecran reste noir et la partie est bloquee, sans
  --sortie ni message. C'est ce qui se passait.
  --
  --Desormais l'erreur est tracee, puis on repart vers le camp quoi qu'il
  --arrive. Un reve rate vaut mieux qu'une partie perdue.
  local ok, err = pcall(DreamSceneBody)
  if not ok then
    PrintInfo('[hero_dream] reve ecourte : '..tostring(err))
  end

  --Le drapeau est pose meme en cas d'echec : sans lui, PlotScripting du
  --camp rejouerait la veillee en boucle et on repartirait vers le reve.
  SV.Chapter5.DreamSceneSeen = true
  --Le reve est partage entre plusieurs camps du ch5 (Mont Venteux et
  --Aegis Cave) : on pose aussi le drapeau propre au camp qui a
  --appele, identifie par la carte de retour qu'il a posee. Le routeur
  --des Ruines (cloven_ruins_entrance) lit RuinsDreamSeen pour ne pas
  --rejouer la veillee en boucle.
  pcall(function()
    if SV.TemporaryFlags ~= nil and SV.TemporaryFlags.DreamReturn == 'cloven_ruins_entrance' then
      SV.Chapter5.RuinsDreamSeen = true
    end
  end)

  --Ecran noir avant la bascule, et mode cinematique conserve : la carte
  --d'arrivee (ResumeAfterDream) les reprend a son compte.
  pcall(function() GAME:CutsceneMode(true) end)
  pcall(function() GAME:FadeOut(false, 1) end)
  --BASCULE DE RETOUR. Mecanique (ScriptGame.cs) : EnterGroundMap est un
  --iterateur paresseux — rien ne s'execute a l'appel, le pcall est une
  --ceinture, pas une protection contre la bascule elle-meme.
  --PREFLIGHT COMPLET (meme niveau que l'aller, cote camp) : NOM enregistre
  --ET asset reellement chargeable. C'est le trou de l'ancienne version :
  --GroundValid seul ne voyait pas l'echec de CHARGEMENT du rsground.
  --DataManager.GetGround (DataManager.cs:1138) ne cache rien, logue
  --« Loading rsground file » / « Missing Data », avale l'exception reelle
  --et rend nil ; la bascule se plante alors dans MoveToGround sur
  --CurrentGround.GetEntryPointIdx (GameManager.cs:743) avec CurrentGround
  --deja nullifie — LA NullReferenceException ProcessInput en boucle qui
  --arrete le jeu (trace du 2026-07-30). On ne l'arme donc JAMAIS vers une
  --carte non chargeable : on degrade en CHAINE vers des cartes attestees
  --de master_zone, toutes avec Main_Entrance_Marker.
  --3e garde (meme correctif que l'aller, crash reel du 2026-07-30) : la
  --ZONE EN MEMOIRE doit connaitre la carte de destination — reproduction
  --exacte du test de MoveToGround (GameManager.cs:730-731). GroundValid ne
  --lit que le RESUME (index.idx) ; si le master_zone.json charge par le jeu
  --est plus vieux que l'index, GroundValid passe et la bascule echoue.
  --nil = indecidable (liaison absente) => on ne bloque pas.
  local function zoneConnait(nom)
    local okZ, resZ = pcall(function()
      local z = _ZONE.CurrentZone
      if z == nil then return nil end
      for i = 0, z.GroundMaps.Count - 1 do
        if tostring(z.GroundMaps[i]) == nom then return true end
      end
      return false
    end)
    if not okZ then return nil end
    return resZ
  end
  local function groundLoadable(nom)
    local okT, resT = pcall(function()
      local summary = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('master_zone')
      if not summary:GroundValid(nom) then return false end
      local reg = zoneConnait(nom)
      if reg == false then
        PrintInfo('[hero_dream] '..nom..' absente de la ZONE EN MEMOIRE (index.idx et master_zone.json desynchronises cote jeu) — carte non chargeable')
        return false
      end
      return _DATA:GetGround(nom) ~= nil
    end)
    if not okT then
      --Meme politique qu'a l'aller : si la liaison moteur elle-meme est
      --cassee, un faux negatif ne doit pas court-circuiter le retour.
      PrintInfo('[hero_dream] preflight '..nom..' indisponible ('..tostring(resT)..') — considere chargeable')
      return true
    end
    return resT == true
  end

  --CARTE DE RETOUR PARAMETRABLE. hero_dream est partage entre plusieurs
  --camps (Mont Venteux au ch5, Aegis Cave au ch5, ...) : la carte
  --vers laquelle renvoyer le joueur apres le reve est posee par
  --l'appelant (SV.TemporaryFlags.DreamReturn = nom de ground) juste
  --avant la bascule. Defaut : mount_windswept_entrance (comportement
  --historique du ch5 Mont Venteux).
  local function dreamReturnGround()
    local nom = nil
    pcall(function()
      if SV.TemporaryFlags ~= nil and SV.TemporaryFlags.DreamReturn ~= nil
         and SV.TemporaryFlags.DreamReturn ~= '' then
        nom = SV.TemporaryFlags.DreamReturn
      end
    end)
    if nom == nil then nom = 'mount_windswept_entrance' end
    return nom
  end
  local retour = dreamReturnGround()

  if groundLoadable(retour) then
    PrintInfo('[hero_dream] preflight retour OK — bascule vers le camp ('..retour..')')
    pcall(function() GAME:EnterGroundMap(retour, 'Main_Entrance_Marker', true) end)
  elseif groundLoadable('mount_windswept_entrance') then
    PrintInfo('[hero_dream] carte de retour non chargeable — repli mount_windswept_entrance')
    pcall(function() GAME:EnterGroundMap('mount_windswept_entrance', 'Main_Entrance_Marker', true) end)
  elseif groundLoadable('vast_steppe_midpoint') then
    PrintInfo('[hero_dream] camp non chargeable — repli vast_steppe_midpoint (scene du matin sautee)')
    pcall(function() GAME:EnterGroundMap('vast_steppe_midpoint', 'Main_Entrance_Marker', true) end)
  elseif groundLoadable('guild_guildmasters_bedroom') then
    PrintInfo('[hero_dream] camp et premier repli non chargeables — repli ultime guilde')
    pcall(function() GAME:EnterGroundMap('guild_guildmasters_bedroom', 'Main_Entrance_Marker', true) end)
  else
    --AUCUNE carte connue ne charge : installer est casse au-dela de cette
    --scene. Armer quand meme = bascule morte = NRE ProcessInput en boucle
    --= arret du jeu. On n'arme RIEN et on rend la main ici : un reve
    --termine sur place vaut mieux qu'une partie stoppee par le moteur.
    PrintInfo('[hero_dream] ALERTE — aucune carte de repli chargeable, bascule non armee, controle rendu')
    pcall(function() GAME:CutsceneMode(false) end)
    pcall(function() GAME:FadeIn(20) end)
  end
end

return hero_dream
