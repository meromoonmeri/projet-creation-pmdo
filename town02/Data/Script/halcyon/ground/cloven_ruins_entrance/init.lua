--[[
    init.lua — Aegis Cave Entrance
    Entree des Aegis Cave — Chapitre 5, climax de l'expedition
    ---------------------------------------------------------------
    Apres la victoire sur Tornadus, l'expedition etablit un campement
    devant l'entree (briefing strategique autour du feu, nuit, reve de
    Gardevoir, puis matin et entree dans le donjon final du ch5).
    La cinematique vit dans cloven_ruins_entrance_ch_5.lua (4 actes,
    gabarit valide du campement du Mont Venteux).
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.cloven_ruins_entrance.cloven_ruins_entrance_ch_5'
require 'halcyon.RuinesZarbi'
require 'halcyon.RuinesRenforts'
local TeamDazzlingAegis = require 'halcyon.TeamDazzlingAegis'

local cloven_ruins_entrance = {}

function cloven_ruins_entrance.Init(map)
  pcall(function() GAME:FadeOut(false, 1) end)
  pcall(function() GAME:CutsceneMode(true) end)
  COMMON.RespawnAllies()
  pcall(function() PartnerEssentials.InitializePartnerSpawn() end)
  -- Si aucune cinematique n'est a venir, on libere la main des
  -- maintenant (sinon le joueur resterait fige sur une carte montee).
  pcall(function()
    -- Le test doit etre le MIROIR EXACT de PlotScripting, sinon Init
    -- relache CutsceneMode juste avant qu'ArrivalCutscene ne le repose
    -- (main rendue une fraction de seconde en pleine mise en place).
    -- Il ne peut donc pas exiger Chapter == 5 : depuis un warp du mode
    -- dev le chapitre vaut 1 (DebugWarp -> startCleanSave -> defauts de
    -- scriptvars.lua). Voir le commentaire long dans PlotScripting.
    local sceneAVenir = false
    local c5 = SV.Chapter5
    if c5 ~= nil then
      local ch = SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter or nil
      local apresRuines = (ch ~= nil and ch >= 6)
      sceneAVenir = c5.PlayTempRuinsScene
                 or ((not c5.RuinsCampDone) and not apresRuines)
    end
    if not sceneAVenir then GAME:CutsceneMode(false) end
  end)
end

function cloven_ruins_entrance.Enter(map)
  cloven_ruins_entrance.PlotScripting()
end

function cloven_ruins_entrance.Update(map) end

function cloven_ruins_entrance.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function cloven_ruins_entrance.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  cloven_ruins_entrance.PlotScripting()
end

function cloven_ruins_entrance.PlotScripting()
  local c5 = SV.Chapter5

  -- ================================================================
  -- WARP DU MODE DEV — LE CHAPITRE N'EST PAS CELUI QU'ON CROIT
  -- ================================================================
  -- Le bouton « Enter Ground » de l'onglet Travel appelle
  -- GameManager.DebugWarp (Scene/GameManager.cs:1072), qui commence par
  -- startCleanSave (l.1061). Si aucune sauvegarde n'est chargee, ce
  -- dernier appelle NewGamePlus -> LuaEngine.OnNewGame -> rechargement
  -- des valeurs par defaut de scriptvars.lua. Or le defaut est
  -- SV.ChapterProgression.Chapter = 1 (scriptvars.lua:697).
  --
  -- Le garde `Chapter ~= 5` renvoyait donc TOUJOURS vrai depuis un warp
  -- a froid, et la fonction sortait ligne 60 sur SetupGround() — appele
  -- SANS ARGUMENT, donc includeRecon = nil (falsy) : les six membres de
  -- la base logistique sont spawnes, Kino et Reinier non, et FadeIn(20)
  -- rend la main. C'est EXACTEMENT le symptome : des membres de la
  -- Guilde deja en place, et aucune arrivee du heros.
  --
  -- Mon correctif precedent (condition RuinsCampDone) portait sur la
  -- branche l.117, qui n'etait jamais atteinte depuis un warp : le
  -- garde de chapitre sortait 57 lignes plus tot. Il etait juste, mais
  -- inoperant sur ce chemin.
  --
  -- Regle retenue : le chapitre ne sert plus de garde d'ENTREE, mais de
  -- garde de SORTIE. Tant que la scene du camp n'a pas ete jouee
  -- (RuinsCampDone faux) et qu'on n'est pas explicitement APRES le ch5,
  -- l'arrivee est la bonne reponse. Un chapitre >= 6 signifie que
  -- l'histoire a depasse les Ruines : on retombe alors sur l'entree
  -- simple de rejouabilite.
  local ch = SV.ChapterProgression.Chapter
  local apresRuines = (ch ~= nil and ch >= 6)

  -- SORTIE D'AEGIS CAVE — la revelation, une seule fois.
  -- Le sanctuaire vient de se refermer (RuinesRenforts.Effondrement a
  -- laisse l'ecran au noir). C'est ici que le noir se leve : l'equipe
  -- est dehors, et la pierre a decouvert autre chose en se refermant.
  -- Equivalent du monument qui ouvre les Ruines Cachees dans EoS.
  if SV.Ruines ~= nil and SV.Ruines.VaincuRegigigas and not SV.Ruines.TourRevelee then
    cloven_ruins_entrance_ch_5.SetupGround(true)
    pcall(function() RuinesRenforts.Revelation() end)
    -- Après la fermeture d'Aegis Cave seulement : Team Dazzling prend le
    -- relais narratif et amorce Sinister Woods. Aucun membre de Team Charm
    -- n'est réutilisé dans la distribution présente de New Era.
    pcall(function() TeamDazzlingAegis.Aftermath() end)
    return
  end

  if apresRuines then
    --Rejouabilite assumee : l'histoire est passee, camp au repos.
    --SetupGround(false) EXPLICITE — l'ancien appel sans argument
    --laissait includeRecon a nil, ce qui marchait par accident.
    cloven_ruins_entrance_ch_5.SetupGround(false)
    GAME:FadeIn(20)
    return
  end

  if c5 == nil then
    --Table absente (sauvegarde tres ancienne) : on ne peut rien lire,
    --on ouvre la carte sans scene plutot que de planter.
    PrintInfo("[cloven_ruins_entrance] SV.Chapter5 absente — entree simple.")
    cloven_ruins_entrance_ch_5.SetupGround(false)
    GAME:FadeIn(20)
    return
  end

  if ch ~= 5 then
    PrintInfo("[cloven_ruins_entrance] chapitre courant = " .. tostring(ch)
              .. " (attendu 5). Scene du camp jouee quand meme : warp du mode "
              .. "dev ou sauvegarde hors-sequence.")
  end

  -- RETOUR DU REVE — la veillee est terminee, le reve a ete bascule
  -- vers hero_dream qui renvoie ici (DreamReturn). On rejoue le matin.
  if c5.RuinsCampNightDone and not c5.RuinsCampDone then
    cloven_ruins_entrance_ch_5.ResumeAfterDream()
    return
  end

  -- RETOUR APRES KO / ABANDON DANS LES RUINES — le camp joue la
  -- cinematique de reveil (KODefeatCutscene) ou de repli
  -- (RetreatReturnCutscene). Passe AVANT l'arrivee : on ne rejoue pas
  -- le briefing, on se releve au camp.
  --  - KO : SetupGround(true) — Kino/Reinier sont la, ce sont EUX qui
  --    ont ramene l'equipe vaincue depuis les Ruines.
  --  - Abandon : SetupGround(false) — Kino/Reinier sont restes dans
  --    les Ruines (reconnaissance), seuls ceux du camp accueillent.
  if c5.PlayTempRuinsScene then
    if c5.RuinsLastExitReason == 'Retreated' then
      cloven_ruins_entrance_ch_5.SetupGround(false)
      cloven_ruins_entrance_ch_5.RetreatReturnCutscene()
    else
      cloven_ruins_entrance_ch_5.SetupGround(true)
      cloven_ruins_entrance_ch_5.KODefeatCutscene()
    end
    return
  end

  -- ARRIVEE AU CAMP — la cinematique d'entree (briefing + nuit + reve).
  -- Kino/Reinier sont presents (ils sont arrives la veille).
  --
  -- CORRECTIF (bug constate manette en main) : la condition exigeait
  -- RuinsCampPending, drapeau pose a UN SEUL endroit du mod
  -- (mount_windswept_guardian_ch_5.lua:858, apres Tornadus). Toute
  -- arrivee qui ne passe pas par cette victoire — warp du mode dev,
  -- sauvegarde chargee sur la carte, EnterGroundMap de secours —
  -- tombait dans la branche « camp deja visite » : la carte s'ouvrait
  -- avec les membres de la Guilde deja en place et AUCUNE cinematique.
  -- C'est exactement le symptome signale.
  --
  -- Le drapeau d'etat qui fait foi est RuinsCampDone : il n'est pose
  -- qu'a la toute fin de la scene du matin (ch_5.lua:1775). Tant qu'il
  -- est faux au chapitre 5, l'arrivee N'A PAS ete jouee, donc elle doit
  -- se jouer. RuinsCampPending est conserve en trace de progression
  -- (il reste ecrit apres Tornadus) mais n'est plus une condition
  -- bloquante. La rejouabilite est intacte : une fois RuinsCampDone
  -- pose, la scene ne repart jamais.
  if not c5.RuinsCampDone then
    if not c5.RuinsCampPending then
      PrintInfo("[cloven_ruins_entrance] arrivee au camp jouee sans RuinsCampPending "
                .. "(entree hors victoire Tornadus : warp dev / chargement).")
    end
    cloven_ruins_entrance_ch_5.SetupGround(true)
    -- SORTIE GARANTIE (regle projet). ArrivalCutscene etait appelee A NU.
    -- C'est exactement le defaut qui a produit l'ecran noir de la Foret
    -- Lugubre : la fonction ne contient qu'UN SEUL GAME:FadeIn et pose
    -- CutsceneMode(true) sans jamais le relacher elle-meme. Si elle leve
    -- avant son FadeIn, le joueur reste sur un ecran noir, manette
    -- inerte, sans aucun moyen de s'en sortir.
    -- 30 appels moteur y sont non proteges (TeleportTo, MoveToPosition,
    -- MakeCharactersFromList, 95 lectures de MapStrings). Les 95 cles
    -- existent bien dans les deux .resx (verifie), donc le risque est
    -- faible — mais « faible » ne suffit pas pour un ecran noir.
    local ok, err = pcall(cloven_ruins_entrance_ch_5.ArrivalCutscene)
    if not ok then
      PrintInfo('[cloven_ruins_entrance] ArrivalCutscene interrompue : ' .. tostring(err))
      -- On ne rejoue pas une scene a moitie jouee : on la marque faite,
      -- on repose le camp au repos, et on rend la main au joueur.
      pcall(function() SV.Chapter5.RuinsCampDone = true end)
      pcall(function() SV.Chapter5.RuinsCampPending = false end)
      pcall(function() cloven_ruins_entrance_ch_5.SetupGround(false) end)
      pcall(function() GAME:CutsceneMode(false) end)
      pcall(function() GAME:FadeIn(20) end)
    end
    return
  end

  -- SCENE PENTICUS/PHILEAS POST-1ER-REGI (2026-08-04) : la cinematique
  -- qui se jouait avant l'entree du donjon est deplacee ici, apres la
  -- victoire sur le premier Regi. On coupe au camp pendant que le duo est
  -- au fond : Penticus et Phileas, toujours a l'entrance des Ruines,
  -- discutent — Plum s'incruste, ils changent de sujet. Une seule fois
  -- (RuinsEntryTalkDone). Puis fondu, et retour a la suite : le joueur
  -- reprend la main, libre de poursuivre les Regis suivants.
  if c5 ~= nil and not c5.RuinsEntryTalkDone
     and SV.Ruines ~= nil and SV.Ruines.VaincuRegice then
    cloven_ruins_entrance_ch_5.SetupGround(true)
    cloven_ruins_entrance_ch_5.EntryTalk()
    return
  end

  -- SCENE POST-REGISTEEL (2026-08-04) : apres avoir vaincu Registeel,
  -- Penticus et Phileas s'inquietent que le duo soit descendu dans le
  -- Puits et decident de rentrer a la guilde ramener des renforts. Une
  -- seule fois (RegisteelDepartDone) — c'est ce qui rend coherente leur
  -- arrivee face a Regigigas avec le reste de la guilde.
  if c5 ~= nil and not c5.RegisteelDepartDone
     and SV.Ruines ~= nil and SV.Ruines.VaincuRegisteel then
    cloven_ruins_entrance_ch_5.SetupGround(true)
    cloven_ruins_entrance_ch_5.RegisteelDepart()
    return
  end

  -- ETAT DE CAMP — le joueur est libre (apres la cinematique).
  -- Kino/Reinier sont partis en reconnaissance : seule la base
  -- logistique reste (Penticus, Phileas, Rin, Coco, Hyko, Almotz).
  cloven_ruins_entrance_ch_5.SetupGround(false)
  GAME:FadeIn(20)
end

-- ENTREE DANS LES AEGIS CAVE (donjon final du ch5).
function cloven_ruins_entrance.Dungeon_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("cloven_ruins")
  UI:ResetSpeaker()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Voulez-vous entrer dans les Aegis Cave ?", true)
  UI:WaitForChoice()
  local yesnoResult = UI:ChoiceResult()
  if yesnoResult then
    -- Plus AUCUNE cinematique ici : la scene Penticus/Phileas/Plum s'est
    -- deplacee APRES la victoire sur le premier Regi (voir PlotScripting,
    -- branche RuinsEntryTalkDone). On entre directement dans le donjon.
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    if SV.ChapterProgression.Chapter == 5 and SV.Chapter5 ~= nil then
      SV.Chapter5.RuinsEntered = true
      --Le donjon final du ch5 doit etre debloque des l'entree depuis le
      --camp : Aegis Cave doit être déverrouillée pendant le chapitre 5.
      pcall(function() GAME:UnlockDungeon("cloven_ruins") end)
    end
    SV.partner.Spawn = "Default"
    -- AEGIS CAVE : on ne repart pas toujours du premier labyrinthe.
    -- Le secteur actif est celui dont le mot n'est pas encore epele
    -- (Glace -> Roche -> Acier), puis le Puits une fois les trois faits.
    -- C'est ce qui donne la boucle du donjon d'origine : tant qu'il
    -- manque une pierre, on redescend le MEME labyrinthe.
    local seg = 0
    pcall(function()
      local actif = RuinesZarbi.SecteurActif()
      if actif ~= nil then
        seg = actif
      elseif SV.Ruines ~= nil and SV.Ruines.VaincuRegisteel then
        seg = 6   -- Le Puits
      end
    end)
    PrintInfo('[Ruines] entree du donjon -> segment ' .. tostring(seg))
    GAME:EnterDungeon("cloven_ruins", seg, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

-- LA STÈLE DE ZARBI (Aegis Cave) : posee au camp, pres de l'entree du
-- donjon. On la touche apres avoir ramasse les pierres de lettres ; elle
-- montre le mot, propose de « fermer les yeux », et une fois le mot
-- complet, un escalier apparait vers l'arene du Regi. Patron Aegis Cave.
function cloven_ruins_entrance.Tablette_Zarbi_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.RuinsCampDone then
    RuinesZarbi.LireTablette()
  else
    GeneralFunctions.StartConversation(chara, "La tablette est froide.[pause=15] Ses cavités attendent des pierres de lettres.", "Normal")
    GeneralFunctions.EndConversation(chara)
  end
end

-- ROCHER DE KANGOUREX RETIRE du camp des Ruines (demande utilisateur
-- 2026-08-03). Deux statues apparaissaient a l'ecran : l'objet lui-meme,
-- Actions des membres du camp (interactifs apres la cinematique).
function cloven_ruins_entrance.Teammate1_Action(chara, activator)
  --Apres le camp (briefing + nuit + reve), le partenaire a un mot
  --personnel : il se souvient de la soiree et de ce qui l'attend.
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.RuinsCampDone then
    GeneralFunctions.StartConversation(chara, "Cette nuit,[pause=10] autour du feu...[pause=15] Je crois que c'est la première fois que toute l'expédition s'est vraiment parlé.[pause=0] Pas juste des ordres,[pause=10] des craintes,[pause=10] des espoirs.[pause=10] Tout ça.[pause=15] Ça compte,[pause=10] tu sais.", "Normal")
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue("Et ce rêve...[pause=15] Peu importe ce qu'il voulait dire.[pause=10] On est là,[pause=10] maintenant.[pause=0] Et on entre dans les Aegis Cave.[pause=10] Ensemble.[pause=10] Comme toujours.")
    GeneralFunctions.SetEmotion("Happy")
    UI:WaitShowDialogue("Regarde le camp.[pause=10] Chacun fait sa part :[pause=0] Hyko veille,[pause=10] Rin prépare,[pause=10] Coco nourrit tout le monde,[pause=10] et Kino et Reinier balisent déjà la route.[pause=15] On n'est pas seuls,[pause=10] {0}.[pause=0] On ne l'a jamais été.", chara:GetDisplayName())
    GeneralFunctions.EndConversation(chara)
    return
  end
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function cloven_ruins_entrance.Tropius_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  --Apres la nuit : reference au briefing et a la decision.
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.RuinsCampDone then
    GeneralFunctions.StartConversation(chara, "La nuit a porté conseil,[pause=10] comme toujours.[pause=15] Ce que nous avons dit autour du feu,[pause=10] chaque membre l'emporte avec lui.[pause=0] C'est ça,[pause=10] une expédition :[pause=10] on part avec tout le monde,[pause=10] ou on ne part pas.", "Normal")
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue("Entrez quand vous serez prêts.[pause=10] Nous serons là,[pause=10] devant les Ruines,[pause=10] à vous attendre.")
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Kino et Reinier sont déjà à l'intérieur.[pause=15] Si quelque chose tourne mal,[pause=10] ce sont eux qui le verront les premiers.[pause=0] Et ils reviendront nous le dire avant d'y toucher.")
  else
    GeneralFunctions.StartConversation(chara, "Le camp est prêt.[pause=10] Et nous aussi.[pause=0] Les Aegis Cave nous attendent depuis trop longtemps.", "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance.Noctowl_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.RuinsCampDone then
    GeneralFunctions.StartConversation(chara, "Vous avez bien fait de relier les veines de Tornadus à la chaleur du Creuset.[pause=15] C'est la première fois que toutes les pièces s'alignent ainsi.[pause=0] Les anciens appelaient ça «[pause=5] entendre la terre[pause=5] ».[pause=10] Vous l'avez entendue,[pause=10] cette nuit.", "Normal")
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue("Et la remarque de Ganlon sur les pierres chaudes...[pause=15] elle ne me quitte pas.[pause=0] J'aimerais avoir tort,[pause=10] mais je ne crois pas.")
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("J'ai confié une copie de mes notes à Reinier avant son départ.[pause=15] S'il trouve quelque chose d'anormal,[pause=10] il saura où regarder.[pause=0] Un érudit se doit de préparer ses successeurs.")
    -- Le lien avec le reve : Phileas a entendu le heros se redresser la
    -- nuit derniere. Il ne nomme rien, mais il a compris.
    if SV.Chapter5 ~= nil and SV.Chapter5.RuinsDreamSeen then
      GeneralFunctions.SetEmotion("Worried")
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_PHILEAS_REVE']))
      GeneralFunctions.SetEmotion("Normal")
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_PHILEAS_REVE2']))
    end
  else
    GeneralFunctions.StartConversation(chara, "J'ai passé la nuit à relire mes notes.[pause=10] Les veines,[pause=10] la chaleur,[pause=10] l'orage...[pause=0] Tout converge ici.[pause=10] Ce n'est pas un hasard.", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance.Breloom_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.RuinsCampDone then
    GeneralFunctions.StartConversation(chara, "Je n'ai pas beaucoup dormi,[pause=10] entre nous.[pause=15] Repenser à ce qu'on a dit autour du feu,[pause=10] à ce qui pulse sous la pierre...[pause=0] La dernière fois que j'ai senti ça,[pause=10] c'était la première fois que j'entrais.[pause=10] Et je n'en suis ressorti qu'au matin.", "Worried")
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue("Mais cette fois,[pause=10] vous êtes avec moi.[pause=0] Et c'est tout ce qui change.")
  else
    GeneralFunctions.StartConversation(chara, "Ces ruines,[pause=10] je les connais par cœur.[pause=0] Et je n'y comprends toujours rien.[pause=10] Peut-être que vous,[pause=10] vous verrez ce que nous,[pause=10] on a manqué.", "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance.Girafarig_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.RuinsCampDone then
    GeneralFunctions.StartConversation(chara, "Mon arrière-tête n'a pas dormi de la nuit.[pause=15] Il n'arrête pas de tourner autour de ce que vous avez dit :[pause=0] «[pause=5] une forme sous le monde[pause=5] ».[pause=15] Il pense que vous avez visé juste.[pause=0] Et ça,[pause=10] ça ne lui arrive presque jamais.", "Worried")
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Gardez les yeux ouverts,[pause=10] là-dedans.[pause=0] Et si quelque chose bouge dans les murs...[pause=10] ne supposez pas que c'est un écho.")
  else
    GeneralFunctions.StartConversation(chara, "Mon arrière-tête n'aime pas ces ruines.[pause=10] Il dit qu'elles ont été creusées autour de quelque chose.[pause=0] Et que ça,[pause=10] ça n'a jamais été ouvert.[pause=10] Jusqu'à maintenant.", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance.Snubbull_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.RuinsCampDone then
    GeneralFunctions.StartConversation(chara, "J'ai pas fermé l'œil,[pause=10] moi non plus.[pause=15] Entre le briefing de Phileas et Ganlon qui ronflait,[pause=10] c'était une sacrée soirée.[pause=0] Mais je vais vous dire :[pause=10] je crois qu'on tient quelque chose,[pause=10] cette fois.[pause=10] Je le sens.", "Normal")
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue("Alors allez-y.[pause=10] Et ramenez-nous une bonne raison de fêter ça,[pause=10] au retour.")
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Moi je tiens le ravitaillement.[pause=10] Personne ne part en expédition sans avoir mangé,[pause=10] c'est la règle.[pause=0] Hyko garde,[pause=10] Rin soigne,[pause=10] et moi je remplis les gamelles.[pause=10] Chacun son poste.")
  else
    GeneralFunctions.StartConversation(chara, "Des ruines de plus.[pause=10] Celle-ci a intérêt à valoir le déplacement,[pause=0] après tout ce chemin.", "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance.Audino_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.RuinsCampDone then
    GeneralFunctions.StartConversation(chara, "J'ai refait les sacs de tout le monde ce matin.[pause=15] Baies,[pause=10] bandages,[pause=10] un peu d'herbe amère pour le mal des ruines.[pause=0] On ne sait jamais ce qu'on trouvera au fond.[pause=10] Mais on y ira prêts.", "Normal")
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue("Revenez-moi entiers,[pause=10] tous les deux.[pause=0] C'est tout ce que je demande.[pause=10] Et si la pierre vous blesse,[pause=10] je serai là,[pause=10] au camp,[pause=10] avec de quoi soigner.")
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Kino a insisté pour emporter des bandages de secours.[pause=15] Il connaît les ruines :[pause=10] il sait qu'on y saigne.[pause=0] J'espère ne pas en avoir besoin pour lui.[pause=10] Ni pour vous.")
    -- La légende de Mew n'est plus racontée ici : Phileas la confie au
    -- duo à la porte du donjon, dans la cinématique d'entrée (EntryTalk).
  else
    GeneralFunctions.StartConversation(chara, "J'ai préparé des baies pour tout le monde.[pause=10] On ne sait jamais,[pause=0] là-dedans.[pause=10] Revenez-moi entiers,[pause=10] c'est tout ce que je demande.", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance.Growlithe_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.RuinsCampDone then
    GeneralFunctions.StartConversation(chara, "Ronde du matin effectuée,[pause=10] wouf.[pause=15] Les ruines n'ont pas bougé d'un pouce depuis hier soir.[pause=0] Mais je vous jure que je les ai entendues respirer,[pause=10] une fois.[pause=10] Peut-être,[pause=10] le vent.[pause=0] Peut-être pas.", "Normal")
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue("Je garde le camp.[pause=10] Comptez sur moi.[pause=0] Et revenez-nous entiers,[pause=10] wouf.")
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("J'ai relevé le périmètre trois fois depuis l'aube.[pause=15] Rien à signaler,[pause=10] à part les ruines qui... respirent.[pause=0] Je le mets sur le compte du vent.[pause=10] Pour l'instant.")
  else
    GeneralFunctions.StartConversation(chara, "J'ai relevé les gardes trois fois cette nuit,[pause=10] wouf.[pause=0] Les ruines n'ont pas bougé.[pause=10] Elles attendent,[pause=10] comme nous.", "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance.Zigzagoon_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.RuinsCampDone then
    GeneralFunctions.StartConversation(chara, "J'ai écrit à ma mère,[pause=10] cette nuit,[pause=15] avec un bout de charbon du feu.[pause=0] «[pause=5] Les ruines bougent,[pause=10] mais on est ensemble.[pause=5] »[pause=15] Elle va se demander ce que ça veut dire.[pause=10] Moi aussi,[pause=10] un peu.", "Happy")
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue("Mais on le saura bientôt,[pause=10] pas vrai ?[pause=0] Allez.[pause=10] Et rapportez-moi une histoire qui vaut le détour.")
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Si Reinier et Kino reviennent avant vous,[pause=10] je leur ferai du thé.[pause=15] Et si vous revenez avant eux,[pause=10] je vous ferai du thé aussi.[pause=0] Tout le monde gagne.[pause=10] C'est ma philosophie.")
  else
    GeneralFunctions.StartConversation(chara, "Ma mère m'a dit : «[pause=5] Ne reviens pas sans une bonne histoire.[pause=5] »[pause=10] Les Aegis Cave,[pause=10] ça fera largement l'affaire.", "Happy")
  end
  GeneralFunctions.EndConversation(chara)
end

-- Ganlon / Shuca : via l'IA d'equipe (talkToTeammate par espece).
--PLUM (Jigglypuff) — cuisiniere incrustee depuis le Mont Venteux.
--Elle est interactive des qu'elle est au camp (PlumAtMountCamp).
--Le running gag continue : elle se croit membre de l'expedition.
function cloven_ruins_entrance.Jigglypuff_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.RuinsCampDone then
    GeneralFunctions.StartConversation(chara, "Alors,[pause=10] prêts à entrer dans les Ruines ?[pause=15] Moi,[pause=10] j'ai déjà repéré mon camp de devant :[pause=0] là où je poserai les marmites quand vous reviendrez.", "Joyous")
    GeneralFunctions.SetEmotion("Happy")
    UI:WaitShowDialogue("Et ne vous inquiétez pas pour le ragoût,[pause=10] il se garde très bien.[pause=15] Je l'ai déjà fait voyager de la guilde jusqu'au Mont.[pause=0] Jusqu'ici,[pause=10] zéro dégât.[pause=10] Presque.")
    GeneralFunctions.EndConversation(chara)
    return
  end
  GeneralFunctions.StartConversation(chara, "Vous êtes tombés sur le bon camp,[pause=10] les amis ![pause=15] Le ragoût de la guilde est arrivé avant vous.[pause=0] Comme quoi,[pause=10] l'intendance,[pause=10] c'est un métier.", "Joyous")
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  local who = nil
  pcall(function() who = LTBL(chara).Importance end)
  if who == nil or who == '' then
    pcall(function() who = chara.CurrentForm.Species end)
    if who == 'cranidos' then who = 'Cranidos'
    elseif who == 'mareep' then who = 'Mareep' end
  end
  if who == 'Cranidos' then
    GeneralFunctions.StartConversation(chara, "Mouais.[pause=10] Des ruines pleines de veines qui pulsent.[pause=0] On a connu mieux comme dernier camp,[pause=10] mais on est là.[pause=10] Alors on y va.", "Normal")
    GeneralFunctions.EndConversation(chara)
  else
    COMMON.GroundInteract(activator, chara, true)
  end
end

function cloven_ruins_entrance.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  local who = nil
  pcall(function() who = LTBL(chara).Importance end)
  if who == nil or who == '' then
    pcall(function() who = chara.CurrentForm.Species end)
    if who == 'cranidos' then who = 'Cranidos'
    elseif who == 'mareep' then who = 'Mareep' end
  end
  if who == 'Mareep' then
    GeneralFunctions.StartConversation(chara, "Regarde la lumière sur la pierre,[pause=10] le matin ![pause=0] On dirait que les ruines se réveillent avec nous.[pause=10] C'est bon signe,[pause=10] j'en suis sûre.", "Happy")
    GeneralFunctions.EndConversation(chara)
  else
    COMMON.GroundInteract(activator, chara, true)
  end
end

return cloven_ruins_entrance
