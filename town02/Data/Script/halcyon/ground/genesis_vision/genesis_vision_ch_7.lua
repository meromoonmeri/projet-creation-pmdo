--[[
    genesis_vision_ch_7.lua
    LA GENESE — recit de Phileas, chapitre 7.

    ================================================================
    AUDIT DE LA VERSION PRECEDENTE : 4 BUGS BLOQUANTS
    ================================================================
    La cinematique mythologique centrale du jeu ne jouait presque rien.

    1. `ShowAct` recevait `camFn` et `spriteFn` en parametres et ne les
       APPELAIT JAMAIS. Consequence : aucun mouvement de camera de toute
       la scene, et surtout MEW N'APPARAISSAIT PAS. L'acte 2 — l'entree
       de la premiere vie dans le vide — se jouait sur un fond fixe et
       trois lignes de texte.

    2. AUCUNE MUSIQUE. Pas un seul `SOUND:PlayBGM` dans les 183 lignes.
       Quatre minutes de mythologie en silence total.

    3. Les 9 especes de l'acte 3 (`Bulbizarre`, `Salameche`...) N'EXISTENT
       PAS dans CharacterEssentials. `MakeCharactersFromList` aurait leve
       une erreur en indexant `characters[name].species` sur nil.

    4. Les sprites etaient poses SOUS un fond plein ecran. `WaitShowBG`
       dessine par-dessus la carte : Mew et les silhouettes auraient ete
       invisibles meme si le bug 1 avait ete corrige. La lecon etait deja
       ecrite dans VoiceVisions.lua ; elle n'avait pas ete appliquee ici.

    ================================================================
    CE QUE FAIT CETTE VERSION
    ================================================================
    Principe directeur, tire des grandes scenes d'Explorateurs du Ciel :
    UNE IMAGE PLEIN ECRAN NE SE PARTAGE PAS. On ne pose pas de sprites
    par-dessus une planche narrative — on fait vivre la planche
    elle-meme, et on laisse le SILENCE et le RYTHME porter l'emotion.

    Les cinq actes sont donc construits avec les outils qui fonctionnent
    reellement par-dessus un fond plein ecran :

      * la duree d'affichage      (WaitShowBG : le flipbook tourne)
      * le fondu                  (transitions entre actes)
      * la voix off               (WaitShowVoiceOver, sans boite)
      * les silences mesures      (WaitFrames entre les phrases)
      * les overlays plein ecran  (BossFX.Overlay, DrawLayer.Top)
      * le tremblement d'ecran    (BossFX.ShakeScreen)
      * le son et la musique      (montee, coupure, reprise)

    RYTHME (references : la revelation de Temporal Tower, le recit de
    la Genese chez Explorateurs) :
      Acte 1  le vide        lent, presque immobile, un seul son
      Acte 2  la premiere vie   la musique entre, l'ecran s'eclaire
      Acte 3  la multitude      tempo qui s'accelere, sons rapproches
      Acte 4  les Coeurs        gravite, la musique se retire
      Acte 5  le present        silence total, puis UNE phrase

    REGLES DU PROJET
      * Aucun nom interdit. Mew n'est jamais nommee dans le texte : le
        joueur reconnait, le heros non.
      * Le mot « prison » n'apparait pas.
      * Textes en .resx (cle GENV_*), jamais en dur.
      * Tout sous pcall, sortie garantie : une cinematique qui plante
        ne doit pas laisser le joueur sur un ecran noir.
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

genesis_vision_ch_7 = {}

--------------------------------------------------------------------
-- Briques de recit
--------------------------------------------------------------------

--Voix off : pas de boite, pas de locuteur. C'est le format des recits
--mythologiques de Ciel. `pause` = silence APRES la phrase, en frames.
local function tell(key, pause)
  local ok = pcall(function()
    UI:WaitShowVoiceOver(STRINGS:Format(STRINGS.MapStrings[key]), -1)
  end)
  if not ok then PrintInfo('[Genese] cle absente : '..tostring(key)) end
  GAME:WaitFrames(pause or 30)
end

--Un acte = une planche qui tourne + une narration cadencee.
--
--  bg      nom du fond (320x240, verifie par tools/verify_bg_format.py)
--  hold    duree d'affichage en frames — DOIT laisser le flipbook
--          tourner au moins une fois en entier
--  lines   { {cle, silence_apres}, ... }
--  onPlay  effet joue EN PARALLELE de la narration (coroutine)
local function act(bg, hold, lines, onPlay)
  local co = nil
  if onPlay ~= nil then
    co = TASK:BranchCoroutine(function() pcall(onPlay) end)
  end
  --WaitShowBG lance le flipbook et rend la main : la narration se
  --deroule pendant que l'image vit.
  pcall(function() UI:WaitShowBG(bg, hold, 20) end)
  for _, l in ipairs(lines or {}) do
    tell(l[1], l[2])
  end
  if co ~= nil then TASK:JoinCoroutines({co}) end
end

--------------------------------------------------------------------
-- LA GENESE
--------------------------------------------------------------------
function genesis_vision_ch_7.PlayGenesis()
  local partner = CH('Teammate1')

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end

    --Ecran noir complet AVANT la premiere planche. Sans cela, la carte
    --et les sprites du duo resteraient visibles derriere les fonds.
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    GAME:WaitFrames(90)          --un temps de noir : le recit commence

    ---------------------------------------------------------------
    -- ACTE 1 — LE VIDE
    -- Registre : vertige. Rien ne bouge, rien ne sonne. Le joueur doit
    -- ressentir l'absence AVANT qu'on lui parle de creation.
    ---------------------------------------------------------------
    act('Genesis_Void', 760, {
      {'GENV_001', 70},
      {'GENV_002', 60},
      {'GENV_003', 80},
    }, function()
      --Un seul son, tres bas, au bout de 4 secondes de rien.
      GAME:WaitFrames(240)
      pcall(function() SOUND:PlayBattleSE('EVT_Battle_Transition') end)
    end)

    GAME:WaitFrames(50)

    ---------------------------------------------------------------
    -- ACTE 2 — LA PREMIERE VIE
    -- Registre : emerveillement. La musique ENTRE ici, pas avant :
    -- c'est l'arrivee de la vie qui amene le son dans le monde.
    -- Le flash accompagne « elle a danse » — le seul geste de la scene.
    ---------------------------------------------------------------
    act('Genesis_Mew', 940, {
      {'GENV_004', 60},
      {'GENV_005', 50},
      {'GENV_006', 60},
      {'GENV_007', 70},
    }, function()
      SOUND:PlayBGM('Temporal Tower.ogg', true)
      GAME:WaitFrames(300)
      --La danse : une pulsation lumineuse plein ecran, pas un sprite.
      BossFX.Flash(160, 120, 30, 40, 60)
      GAME:WaitFrames(60)
      BossFX.Flash(160, 120, 20, 30, 50)
    end)

    GAME:WaitFrames(50)

    ---------------------------------------------------------------
    -- ACTE 3 — LA MULTITUDE
    -- Registre : foisonnement. Le tempo s'accelere : les silences
    -- raccourcissent, les sons se rapprochent. C'est le seul acte ou
    -- le rythme presse — la vie se repand plus vite qu'on ne la raconte.
    ---------------------------------------------------------------
    act('Genesis_Life', 1120, {
      {'GENV_008', 45},
      {'GENV_009', 40},
      {'GENV_010', 40},
      {'GENV_011', 55},
    }, function()
      --Sept eclats de plus en plus rapproches : la vie qui essaime.
      local d = 90
      for i = 1, 7 do
        GAME:WaitFrames(d)
        pcall(function() SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') end)
        BossFX.Flash(60 + i * 30, 90 + (i % 3) * 40, 8, 6, 26)
        d = math.max(26, d - 10)
      end
    end)

    GAME:WaitFrames(50)

    ---------------------------------------------------------------
    -- ACTE 4 — LES COEURS
    -- Registre : gravite. La musique se RETIRE progressivement : ce
    -- qu'on raconte ici n'est plus un emerveillement, c'est une decision
    -- dont les consequences durent encore. Le sol tremble une fois.
    ---------------------------------------------------------------
    act('Genesis_Cores', 940, {
      {'GENV_012', 60},
      {'GENV_013', 70},
      {'GENV_014', 60},
      {'GENV_015', 80},
    }, function()
      GAME:WaitFrames(200)
      BossFX.ShakeScreen(5, 40)
      pcall(function() SOUND:PlayBattleSE('DUN_Power_Gem') end)
      GAME:WaitFrames(180)
      SOUND:FadeOutBGM(240)          --le recit se vide de sa musique
    end)

    GAME:WaitFrames(60)

    ---------------------------------------------------------------
    -- ACTE 5 — LE PRESENT
    -- Registre : inquietude. Aucune musique, aucun effet, aucun
    -- mouvement. Le silence est l'effet. Puis une seule phrase, apres
    -- un temps assez long pour que le joueur croie la scene finie.
    ---------------------------------------------------------------
    act('Genesis_Fade', 680, {
      {'GENV_016', 70},
      {'GENV_017', 70},
      {'GENV_018', 90},
    }, nil)

    --Le silence marque. C'est la respiration la plus longue de la scene :
    --deux secondes et demie ou il ne se passe absolument rien.
    GAME:WaitFrames(150)

    --La derniere phrase. Elle arrive apres le silence, pas dedans.
    tell('GENV_019', 90)
  end)

  if not ok then PrintInfo('[Genese] scene ecourtee : '..tostring(err)) end

  --Sortie GARANTIE, hors du pcall : une cinematique qui echoue ne doit
  --jamais laisser le joueur sur un ecran noir sans sortie.
  pcall(function()
    UI:ResetSpeaker()
    GAME:FadeOut(false, 120)
    GAME:WaitFrames(120)
    SV.Chapter7.HeardGenesisTale = true
    GAME:CutsceneMode(false)
  end)
  GAME:EnterGroundMap('guild_third_floor_lobby', 'Main_Entrance_Marker')
end

return genesis_vision_ch_7
