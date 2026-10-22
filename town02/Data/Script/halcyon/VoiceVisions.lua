--[[
    VoiceVisions.lua

    LA VOIX ET LES VISIONS DU HEROS
    ================================================================
    SOURCES RELUES (pas de memoire — fichiers ouverts et compares) :
      * Minemaker0430/ExplorersOfSkyOrigins, remake d'Explorateurs du Ciel
        dans CE moteur (PMDO). Fichiers etudies :
          Data/Script/eos/ground/storm_cutscene_a/init.lua
          Data/Script/eos/ground/chapter_card/init.lua
          Data/Script/eos/ground/guild_bedroom_night/init.lua
        On y reprend trois techniques concretes, listees plus bas.
      * pret/pmd-red, decompilation de Rouge : data/scripts/ (intro.inc,
        title.inc) — structure des cinematiques d'ouverture.

    CE QU'ON A REPRIS DE EoSO (et qui manquait a la v1 de ce module)
    ------------------------------------------------------------------
    1. LE FLASH D'ORAGE. storm_cutscene_a ne pose pas un FlashEmitter : il
       enchaine FadeOut(true,2) / WaitFrames(4) / FadeIn(2) / WaitFrames(4),
       deux fois de suite, avec un SE par eclair. Le `true` fade le DECOR en
       gardant l'interface — d'ou l'effet stroboscopique caracteristique.
       C'est net, court, et bien plus lisible qu'un voile colore.
    2. LA BASCULE DE FIN. Pour sortir d'une vision, EoSO joue en parallele
       (BranchCoroutine + JoinCoroutines) un FadeOutFront lent, une replique
       en WaitShowTimedDialogue calee sur la MEME duree, et un fondu du son
       ambiant. Les trois se terminent ensemble : la phrase s'efface avec
       l'image. On applique ce patron a la sortie de vision.
    3. LE SPEAKER INCONNU. EoSO a un helper dedie (SetSpeakerUnknown) appele
       une fois avant toute la scene, plutot qu'un SetSpeaker repete. On
       garde notre \uE040 (identique en effet) mais on le pose une seule
       fois en debut de sequence, comme eux.

    Reprend le dispositif des jeux officiels :

      * PMD Rouge/Bleu — le heros fait des reves ou une voix lui parle
        directement, sans que personne d'autre ne l'entende.
      * PMD Ciel — quand le heros touche un objet ou un lieu charge, il est
        pris d'un vertige et voit un fragment d'un autre temps. Le partenaire
        le voit vaciller mais ne voit RIEN de la vision.

    Deux briques, utilisables partout :

      VoiceVisions.Speak{...}   la Voix parle au heros SEUL, avec nausee.
      VoiceVisions.Play{...}    une vision du passe, en planches.

    ------------------------------------------------------------------
    REGLE NARRATIVE — le heros est le seul a entendre
    ------------------------------------------------------------------
    C'est le coeur du dispositif. A chaque fois que la Voix parle :

      1. le monde se fige (BGM coupee net, ecran qui se voile) ;
      2. le heros a un haut-le-coeur — recul, tremblement d'ecran, l'ecran
         tangue (ScreenMover), emote de choc ;
      3. la Voix parle, speaker ANONYME (\uE040), aucun nom, aucun portrait ;
      4. le monde revient, et le partenaire n'a rien entendu. Il a seulement
         vu son ami s'arreter net et blemir.

    La 4e etape est la plus importante : c'est elle qui rend le heros seul.
    Le parametre `witness` permet de faire reagir un temoin — il s'inquiete
    de la PALEUR du heros, jamais de ce qui a ete dit.

    ------------------------------------------------------------------
    REGLES DU PROJET RESPECTEES
    ------------------------------------------------------------------
    * La Voix reste ANONYME. Jamais de nom dans le speaker.
    * Aucun nom interdit dans les textes appelants (verifie par
      tools/verify_no_forbidden_names.py).
    * Les visions montrent le PASSE d'un autre monde. Le heros ne comprend
      pas ce qu'il voit — c'est au joueur de reconnaitre.
    * Tout est sous pcall : une vision qui casse ne doit jamais bloquer le
      joueur sur une carte sans sortie.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.BossFX'

VoiceVisions = {}

--------------------------------------------------------------------
-- Resolution d'un texte.
--------------------------------------------------------------------
-- Deux usages coexistent dans le projet :
--   * appel depuis UN ground -> on passe des cles resx (STRINGS.MapStrings) ;
--   * appel depuis un MODULE GLOBAL -> on passe le texte en clair, car
--     STRINGS.MapStrings ne contient que les cles du ground courant et une
--     cle definie ailleurs serait introuvable (patron de SuaireArc.lua).
-- `literal = true` bascule sur le second mode.
local function resolve(cfg, txt)
  if txt == nil then return nil end
  if cfg.literal then return STRINGS:Format(txt) end
  local ms = cfg.strings or STRINGS.MapStrings
  return STRINGS:Format(ms[txt])
end

--------------------------------------------------------------------
-- Ciel de reve — les deux couches Dream_Back / Dream_Front.
--------------------------------------------------------------------
-- Ces deux fonds dormaient INEXPLOITES dans Content/BG depuis le debut du
-- projet. Analyse de leur format :
--
--     PNG 1536x1920, frames de 192x240, 63 frames (grille 8x8)
--
-- 192 px de large, soit MOINS que le viewport (320). Ce ne sont donc pas des
-- fonds fixes — c'est pour cela qu'ils avaient ete ecartes de HeroVisions au
-- build -O, a juste titre pour un usage en fond plein ecran.
--
-- Mais leur vraie nature est ailleurs : deux couches (Back et Front) faites
-- pour DEFILER en boucle a des vitesses differentes. C'est la parallaxe du
-- ciel de reve d'Explorateurs du Ciel. On les rend donc a leur usage prevu,
-- via FiniteOverlayEmitter avec RepeatX et Movement — exactement ce que
-- BossFX.Overlay sait deja faire (cf. common.lua:498, effet de vitesse).
--
-- Back defile lentement (loin), Front plus vite (proche) : c'est ce
-- differentiel qui cree la profondeur.
function VoiceVisions.DreamSky(hold)
  hold = hold or 240
  pcall(function()
    -- couche lointaine, lente, sous la couche proche
    BossFX.Overlay('Dream_Back', 0, 0, 30, hold, 40, DrawLayer.Bottom, 24, 0)
    -- couche proche, plus rapide, par-dessus
    BossFX.Overlay('Dream_Front', 0, 0, 30, hold, 40, DrawLayer.Back, 56, 0)
  end)
end

--------------------------------------------------------------------
-- Voile de vertige — technique EoSO (CharacterActions.DizzyFade).
--------------------------------------------------------------------
-- C'est L'effet des Cris Temporels d'Explorateurs du Ciel : un voile noir
-- semi-transparent (alpha 128) qui monte et redescend sur tout l'ecran, en
-- RepeatX/RepeatY pour couvrir quelle que soit la taille de la carte.
--
-- Difference importante avec un FlashEmitter : l'overlay est FINI (TotalTime)
-- et repete, donc il couvre l'ecran entier sans dependre d'un point d'emission.
-- C'est ce qui manquait a la premiere version de ce module, qui posait un
-- FlashEmitter ponctuel — sur une grande carte, il ne couvrait qu'une partie.
function VoiceVisions.DizzyVeil()
  pcall(function()
    local anim = RogueEssence.Content.BGAnimData("White", 1, -1, -1, 128, Dir8.None)
    local em = RogueEssence.Content.FiniteOverlayEmitter()
    em.Anim = anim
    em.Layer = DrawLayer.Top
    em.TotalTime = 10
    em.FadeIn = 10
    em.FadeOut = 10
    em.RepeatX = true
    em.RepeatY = true
    em.Color = Color(0, 0, 0, 255)
    local c = GAME:GetCameraCenter()
    GROUND:PlayVFX(em, c.X, c.Y)
    GAME:WaitFrames(30)
  end)
end

--------------------------------------------------------------------
-- Flash d'orage — technique EoSO (storm_cutscene_a/init.lua).
--------------------------------------------------------------------
-- Enchaine des fondus tres courts sur le DECOR (FadeOut(true,...) garde
-- l'interface visible), ce qui donne l'eclair stroboscopique de Ciel.
-- `times` eclairs, avec un SE a chaque coup.
function VoiceVisions.Lightning(times, se)
  times = times or 2
  se = se or 'EVT_Battle_Flash'
  pcall(function()
    for _ = 1, times do
      SOUND:PlayBattleSE(se)
      GAME:FadeOut(true, 2)
      GAME:WaitFrames(4)
      GAME:FadeIn(2)
      GAME:WaitFrames(4)
    end
  end)
end

--------------------------------------------------------------------
-- Intensite de la nausee. 1 = gene passagere, 3 = le heros s'effondre.
--------------------------------------------------------------------
local NAUSEA = {
  [1] = { shake = 3,  frames = 20, fade = 15, recoil = false },
  [2] = { shake = 6,  frames = 34, fade = 25, recoil = true  },
  [3] = { shake = 10, frames = 50, fade = 40, recoil = true  },
}

--Le malaise physique. Extrait a part : les visions le reutilisent.
--`level` 1..3, `chara` le heros.
function VoiceVisions.Nausea(chara, level)
  local cfg = NAUSEA[level or 2] or NAUSEA[2]
  pcall(function()
    SOUND:PlayBattleSE('EVT_Emote_Startled')
    if chara ~= nil then
      GROUND:CharSetEmote(chara, "shock", 1)
      if cfg.recoil then
        GROUND:CharSetAnim(chara, "Hurt", true)
      end
    end
    --L'ecran tangue : c'est le vertige, pas un tremblement de terre.
    --Amplitude faible mais longue, contrairement a BossFX.ShakeScreen.
    GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, cfg.shake, cfg.frames))
    GAME:WaitFrames(cfg.frames)
  end)
  --Puis le voile des Cris Temporels. Hors du pcall precedent pour qu'il
  --s'affiche meme si l'animation du personnage a echoue.
  if (level or 2) >= 2 then VoiceVisions.DizzyVeil() end
end

--Retour au calme apres un malaise.
function VoiceVisions.Recover(chara)
  pcall(function()
    if chara ~= nil then
      GROUND:CharSetEmote(chara, "", 0)
      GROUND:CharSetAnim(chara, "Idle", true)
    end
  end)
end

--------------------------------------------------------------------
-- VoiceVisions.Speak — la Voix s'adresse au heros, lui seul l'entend.
--------------------------------------------------------------------
--  cfg = {
--    lines   = {'CLE_001', 'CLE_002'},  -- cles resx, dans l'ordre
--    strings = STRINGS.MapStrings,      -- table de cles (defaut MapStrings)
--    level   = 2,                       -- intensite de la nausee (1..3)
--    music   = true,                    -- couper puis rendre la BGM
--    witness = partner,                 -- temoin inquiet (optionnel)
--    witnessLines = {'CLE_003'},        -- ce que dit le temoin apres coup
--    heroLine = 'CLE_004',              -- pensee du heros apres coup
--  }
function VoiceVisions.Speak(cfg)
  local hero = CH('PLAYER')
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if cfg.witness ~= nil then AI:DisableCharacterAI(cfg.witness) end

    --1. Le monde se fige.
    if cfg.music ~= false then SOUND:FadeOutBGM(20) end
    GAME:WaitFrames(10)

    --2. Le haut-le-coeur.
    VoiceVisions.Nausea(hero, cfg.level)

    --Le monde clignote, comme sous l'orage de Ciel. Deux battements courts :
    --technique reprise de storm_cutscene_a (EoSO), plus lisible qu'un voile.
    VoiceVisions.Lightning(2)
    GAME:WaitFrames(10)

    --3. La Voix. Speaker anonyme : ni nom, ni espece, ni portrait.
    UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
    for _, key in ipairs(cfg.lines or {}) do
      UI:WaitShowDialogue(resolve(cfg, key))
      GAME:WaitFrames(10)
    end

    --4. Retour au monde.
    GAME:WaitFrames(20)
    VoiceVisions.Recover(hero)

    if cfg.heroLine ~= nil then
      GeneralFunctions.HeroDialogue(hero, resolve(cfg, cfg.heroLine), "Worried")
    end

    --Le temoin n'a RIEN entendu. Il a vu son ami blemir, c'est tout.
    if cfg.witness ~= nil and cfg.witnessLines ~= nil then
      UI:SetSpeaker(cfg.witness)
      GeneralFunctions.SetEmotion("Worried")
      for _, key in ipairs(cfg.witnessLines) do
        UI:WaitShowDialogue(resolve(cfg, key))
      end
    end
  end)

  if not ok then PrintInfo('[VoiceVisions.Speak] ecourte : '..tostring(err)) end

  --Sortie garantie hors du pcall.
  pcall(function()
    UI:ResetSpeaker()
    if cfg.witness ~= nil then
      AI:EnableCharacterAI(cfg.witness)
      AI:SetCharacterAI(cfg.witness, 'origin.ai.ground_partner', CH('PLAYER'), cfg.witness.Position)
    end
    GAME:CutsceneMode(false)
  end)
end

--------------------------------------------------------------------
-- VoiceVisions.Play — une vision du passe, en planches.
--------------------------------------------------------------------
--  cfg = {
--    strings = STRINGS.MapStrings,
--    level   = 3,                    -- nausee d'entree
--    music   = 'Temporal Tower.ogg', -- musique de la vision (nil = silence)
--    witness = partner,
--    plates  = {                     -- les planches, dans l'ordre
--      { bg='Dream_Back', hold=200, lines={'CLE_010','CLE_011'} },
--      { bg='Dusknoir',   hold=180, lines={'CLE_012'}, shake=6 },
--    },
--    heroLine     = 'CLE_020',
--    witnessLines = {'CLE_021'},
--  }
--
--Les repliques d'une planche passent en VOIX OFF (WaitShowVoiceOver) : pas de
--boite de dialogue, pas de speaker. C'est le format des visions de Ciel, et ca
--evite d'attribuer la parole a un personnage que le joueur ne connait pas.
function VoiceVisions.Play(cfg)
  local hero = CH('PLAYER')
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if cfg.witness ~= nil then AI:DisableCharacterAI(cfg.witness) end

    --Le vertige, plus violent que pour une simple parole.
    SOUND:FadeOutBGM(30)
    VoiceVisions.Nausea(hero, cfg.level or 3)
    GAME:WaitFrames(10)

    --Bascule vers la vision. Patron storm_cutscene_a (EoSO) : une salve
    --d'eclairs sur le decor, puis le SE de transition, puis le noir complet.
    --
    --Le FadeOut(false, 40) ci-dessous est INDISPENSABLE avant les planches :
    --il noircit tout l'ecran, sprites du duo compris. Sans lui, les sprites
    --resteraient visibles PAR-DESSUS le fond plein ecran. EoSO resout le meme
    --probleme autrement (GROUND:Hide("PLAYER") en tete de scene) parce que ses
    --cinematiques ont leur propre carte ; nos visions se jouent sur la carte
    --courante, donc on passe par le noir.
    --
    --Rappel de format : un fond doit avoir des FRAMES de 320x240 (viewport
    --PMDO). Voir tools/verify_bg_format.py, qui echoue si ce n'est pas le cas.
    VoiceVisions.Lightning(3)
    GAME:WaitFrames(10)
    pcall(function() SOUND:PlayBattleSE('EVT_Battle_Transition') end)
    GAME:FadeOut(false, 40)
    GAME:WaitFrames(40)

    UI:ResetSpeaker()
    if cfg.music ~= nil then SOUND:PlayBGM(cfg.music, true) end

    --Les planches.
    for _, plate in ipairs(cfg.plates or {}) do
      --Une planche peut demander le ciel de reve : deux couches de nuages
      --qui defilent en parallaxe PAR-DESSOUS l'image fixe. Reserve aux
      --moments oniriques (cf. Dream_Back/Dream_Front, ciel de reve de Ciel).
      if plate.dreamSky then VoiceVisions.DreamSky((plate.hold or 180) + 40) end
      UI:WaitShowBG(plate.bg, plate.hold or 180, 20)
      if plate.shake ~= nil then
        pcall(function()
          GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, plate.shake, 20))
        end)
      end
      for _, key in ipairs(plate.lines or {}) do
        UI:WaitShowVoiceOver(resolve(cfg, key), -1)
        GAME:WaitFrames(16)
      end
      UI:WaitHideBG(20)
      GAME:WaitFrames(10)
    end

    --Retour au present. Patron EoSO : la derniere phrase de la vision, le
    --fondu de l'image et le fondu du son se terminent EXACTEMENT ensemble
    --(trois coroutines jointes), pour que la phrase s'efface avec l'image.
    if cfg.lastWord ~= nil then
      local c1 = TASK:BranchCoroutine(function() GAME:FadeOutFront(true, 120) end)
      local c2 = TASK:BranchCoroutine(function()
        UI:WaitShowTimedDialogue(resolve(cfg, cfg.lastWord), 120) end)
      local c3 = TASK:BranchCoroutine(function() SOUND:FadeOutBGM(120) end)
      TASK:JoinCoroutines({c1, c2, c3})
      GAME:WaitFrames(60)
      GAME:FadeInFront(60)
    else
      SOUND:FadeOutBGM(60)
      GAME:WaitFrames(40)
    end

    GAME:FadeIn(40)
    --Le reveil est aussi rude que le depart : le heros revient a lui d'un coup.
    VoiceVisions.Nausea(hero, 2)
    VoiceVisions.Recover(hero)
    GAME:WaitFrames(20)

    if cfg.heroLine ~= nil then
      GeneralFunctions.HeroDialogue(hero, resolve(cfg, cfg.heroLine), "Worried")
    end
    if cfg.witness ~= nil and cfg.witnessLines ~= nil then
      UI:SetSpeaker(cfg.witness)
      GeneralFunctions.SetEmotion("Worried")
      for _, key in ipairs(cfg.witnessLines) do
        UI:WaitShowDialogue(resolve(cfg, key))
      end
    end
  end)

  if not ok then
    PrintInfo('[VoiceVisions.Play] ecourte : '..tostring(err))
    --Filet : on ne laisse jamais le joueur dans le noir.
    pcall(function() UI:WaitHideBG(1) end)
    pcall(function() GAME:FadeIn(20) end)
  end

  pcall(function()
    UI:ResetSpeaker()
    if cfg.witness ~= nil then
      AI:EnableCharacterAI(cfg.witness)
      AI:SetCharacterAI(cfg.witness, 'origin.ai.ground_partner', CH('PLAYER'), cfg.witness.Position)
    end
    GAME:CutsceneMode(false)
  end)
end

--------------------------------------------------------------------
-- Suivi : combien de visions le heros a-t-il deja eues ?
--------------------------------------------------------------------
function VoiceVisions.EnsureSV()
  if SV.Visions == nil then SV.Visions = {} end
  if SV.Visions.Seen == nil then SV.Visions.Seen = {} end
  if SV.Visions.Count == nil then SV.Visions.Count = 0 end
end

--Joue une vision UNE SEULE FOIS, identifiee par `id`.
--Renvoie true si la vision a effectivement ete jouee.
function VoiceVisions.PlayOnce(id, cfg)
  VoiceVisions.EnsureSV()
  if SV.Visions.Seen[id] then return false end
  SV.Visions.Seen[id] = true
  SV.Visions.Count = SV.Visions.Count + 1
  VoiceVisions.Play(cfg)
  return true
end

function VoiceVisions.HasSeen(id)
  VoiceVisions.EnsureSV()
  return SV.Visions.Seen[id] == true
end

return VoiceVisions
