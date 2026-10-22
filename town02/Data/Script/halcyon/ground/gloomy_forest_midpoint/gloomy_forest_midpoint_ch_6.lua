-- [dungeon_builder] recâblage : station de mi-parcours de gloomy_forest : elle rend la main au segment 1 du même donjon
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.MidpointTemplate'

gloomy_forest_midpoint_ch_6 = {}

------------------------------------------------------------------
-- IMPORTANT: every GROUND:TeleportTo / MoveToPosition / MoveCamera
-- coordinate below is a PLACEHOLDER. The gloomy_forest_midpoint ground map
-- layout must be authored in the PMDO Ground Map Editor (forest biome — see
-- docs/authoring_crooked_cavern_midpoint.md for the model). Tune these to the
-- real tile layout once the map exists. Named entities assumed on the map:
--   "Main_Entrance_Marker", "North_Exit", and a "Kangaskhan_Rock" object.
------------------------------------------------------------------

-- Quiet resting arrangement when arriving freely (not a cutscene).
--------------------------------------------------------------------
-- HABILLAGE DU POINT MEDIAN — Foret Lugubre (forest_camp, 912x720)
--
-- STRUCTURE : halcyon.MidpointTemplate, identique a tous les relais.
-- HABILLAGE : propre a ce biome, et a lui seul.
--
--   Biome     : clairiere sous canopee epaisse. Le calme y vient du
--               couvert vegetal, la ou le Mont le tient d'un canyon
--               coupe-vent et le Tunnel d'une poche de vapeur.
--   Ambiance  : 'autumn_leaves' — feuilles qui tombent en continu.
--               Ni 'blowing_wind' (Mont) ni 'steam' (Tunnel) : chaque
--               relais a son propre statut, jamais recopie.
--   Musique   : 'Mystifying Forest.ogg', theme de la carte elle-meme.
--   Lumiere   : sous-bois tamise, aucun 'darkness' de jour.
--
-- Positions verifiees marchables (tools/nea_map.py).
--------------------------------------------------------------------
gloomy_forest_midpoint_ch_6.SKIN = {
  music     = 'Mystifying Forest.ogg',
  wakeMusic = 'Heartwarming.ogg',
  status    = 'autumn_leaves',
  hero      = {292, 272},
  partner   = {260, 272},
  camera    = {276, 200},
  walk      = 56,
  wake = {
    hero        = {276, 180}, heroFace    = Direction.Left,
    partner     = {308, 180}, partnerFace = Direction.Right,
    camera      = {292, 176},
  },
}

--------------------------------------------------------------------
-- ETAT « RepeatArrival » DU TEMPLATE — retour a l'amiable.
-- Le relais existait avec cet etat en NOM (GloomyMidpointState vaut
-- 'RepeatArrival') mais aucune scene ne lui etait associee : on
-- retombait sur SetupGround + fondu muet. Meme fonction que sur le
-- Tunnel et le Mont, habillage de sous-bois.
--------------------------------------------------------------------
function gloomy_forest_midpoint_ch_6.RepeatArrival()
  local partner = CH('Teammate1')
  MidpointTemplate.RepeatArrival({
    skin = gloomy_forest_midpoint_ch_6.SKIN,
    lines = {
      { who = partner, spk = 'partner', emo = 'Normal',
        txt = "La clairière n'a pas bougé.[pause=0] Même les feuilles tombent au même rythme.", wait = 10 },
      { who = partner, spk = 'partner', emo = 'Normal',
        txt = "Le rocher de Kangourex est toujours là.[pause=0] Reprenons des forces avant les profondeurs." },
    },
  })
end

function gloomy_forest_midpoint_ch_6.SetupGround()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  -- Ground officiel forest_camp (912x720) : coords recalees (+104 px en X vs ancienne carte), toutes verifiees walkables.
  if SV.Chapter6.GloomyMidpointState == 'DeathArrival' then
    GROUND:TeleportTo(hero, 292, 176, Direction.Left)
    GROUND:TeleportTo(partner, 260, 176, Direction.Right)
  else -- FirstArrival / RepeatArrival
    GROUND:TeleportTo(hero, 292, 256, Direction.Up)
    GROUND:TeleportTo(partner, 260, 256, Direction.Up)
  end

  if os.getenv('PMDO_SINISTER_ROUTE_VALIDATOR') == '1' then
    RogueEssence.GameManager.Instance:SetFade(false, false)
    PrintInfo('[SINISTER_ROUTE] midpoint SetupGround visual fade completed headless')
  else
    GAME:FadeIn(20)
  end
end


------------------------------------------------------------------
-- L'EPREUVE DES TROIS — accroche au relais.
------------------------------------------------------------------
-- Une fois Zeraora ecarte, la Team Dazzling attend au campement. Le duel
-- est ENTIEREMENT FACULTATIF : on peut l'ignorer, le refuser, y revenir.
-- Il ne fait avancer aucun drapeau d'histoire.
--
-- Ancrages : campement du relais (912x720, ancrages officiels
-- entrance_center 292,270 et Campfire 352,360). Les trois se tiennent a
-- l'est du foyer, en triangle, sur des cases verifiees libres dans les
-- obstacles : la paroi rocheuse commence a x=440 environ a cette hauteur.
function gloomy_forest_midpoint_ch_6.SetupDazzlingTrial()
  if not SV.Chapter6.DazzlingTrialOffered then return end
  if SV.Chapter6.DazzlingTrialCleared then return end

  CharacterEssentials.MakeCharactersFromList({
    {'Adagio', 404, 306, Direction.Left},
    {'Aria',   412, 338, Direction.Left},
    {'Sonata', 412, 274, Direction.Left}
  })
end

-- Parler a Adagio lance le duel (apres confirmation).
function gloomy_forest_midpoint_ch_6.Adagio_Action(chara, activator)
  if SV.Chapter6.DazzlingTrialCleared then
    GeneralFunctions.StartConversation(chara,
      "Nous rentrons.[pause=20] Reposez-vous : vous l'avez merite plus que nous.", "Normal")
    GeneralFunctions.EndConversation(chara)
    return
  end

  GeneralFunctions.StartConversation(chara,
    "Vous voila.[pause=25] Nous vous avons suivis depuis l'entree.", "Normal")
  UI:WaitShowDialogue("Je veux un combat.[pause=25] Maintenant, pendant que vous etes vides.")
  GeneralFunctions.SetEmotion("Sigh")
  UI:WaitShowDialogue("Rien a gagner, rien a perdre.[pause=20] Refusez et nous partons sans un mot.")
  UI:ChoiceMenuYesNo("Accepter le defi de la Team Dazzling ?", false)
  UI:WaitForChoice()
  local accepted = UI:ChoiceResult()
  GeneralFunctions.EndConversation(chara)

  if not accepted then
    UI:SetSpeaker(chara)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Sage.[pause=25] Nous serons la quand vous serez frais.")
    UI:ResetSpeaker()
    return
  end

  SOUND:FadeOutBGM(40)
  GAME:FadeOut(false, 40)
  -- Le duel facultatif du relais est le segment 7. Le segment 4 est
  -- l'arène canonique de Zeraora et ne doit jamais être relancé par cette
  -- interaction de la Team Dazzling.
  GAME:ContinueDungeon('gloomy_forest', 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function gloomy_forest_midpoint_ch_6.Aria_Action(chara, activator)
  GeneralFunctions.StartConversation(chara,
    "On vous a regardes tout du long.[pause=20] Vous encaissez bien, pour des debutants.", "Happy")
  GeneralFunctions.EndConversation(chara)
end

function gloomy_forest_midpoint_ch_6.Sonata_Action(chara, activator)
  GeneralFunctions.StartConversation(chara,
    "Adagio ne demande jamais de combat.[pause=25] Jamais.[pause=20] Vous devriez etre flattes.", "Normal")
  GeneralFunctions.EndConversation(chara)
end


-- Talking to the partner at the relay.
function gloomy_forest_midpoint_ch_6.Partner_Action(chara, activator)
  if SV.Chapter6.GloomyMidpointState == 'DeathArrival' then
    GeneralFunctions.StartConversation(chara, "Nous sommes revenus à la clairière...[pause=0] il ne faut pas abandonner, Chenipent compte sur nous.", "Worried")
  elseif SV.Chapter6.GloomyMidpointState == 'FirstArrival' then
    GeneralFunctions.StartConversation(chara, "Le rocher de Kangourex permet de sauvegarder et de stocker nos objets.[pause=0] Reposons-nous avant les profondeurs.")
  else -- RepeatArrival
    GeneralFunctions.StartConversation(chara, "Reposons-nous un instant avant de continuer.")
  end
  GeneralFunctions.EndConversation(chara)
end


-- Leaving the relay forward into segment 1 (depth floors).
function gloomy_forest_midpoint_ch_6.ContinueScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GROUND:Hide('North_Exit') -- TODO_MAP: ensure a "North_Exit" entity exists on the map.

  UI:ResetSpeaker()
  UI:SetSpeaker(partner)
  if SV.Chapter6.GloomyMidpointState == 'FirstArrival' then
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_010']))
  elseif SV.Chapter6.GloomyMidpointState == 'DeathArrival' then
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_011']))
  else
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_012']))
  end

  -- TODO_MAP: walk the duo toward the north exit, then fade out.
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
    GROUND:MoveInDirection(partner, Direction.Up, 72, false, 1) end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
    GROUND:MoveInDirection(hero, Direction.Up, 72, false, 1) end)
  local coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(28)
    GAME:FadeOut(false, 40) end)
  TASK:JoinCoroutines({coro1, coro2, coro3})

  -- Continue the same adventure into canonical floors 7-12. PP/belly and the
  -- runtime seed chain are preserved; this is not a new dungeon run.
  GAME:ContinueDungeon("gloomy_forest", 1, 0, 0,
    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end


-- First time the duo reaches the relay: brief calm intro, then free control.
function gloomy_forest_midpoint_ch_6.FirstArrival()

	--LE NOIR AVANT TOUT APPEL MOTEUR (correctif d'arrivee, 2026-07-30).
	--Cette scene se joue sous le noir laisse par la carte precedente et ne
	--rallume qu'a son FadeIn final. Mais GAME:FadeOut est BLOQUANT
	--(ScriptGame.cs:1590) et rend la main au moteur : tout appel place
	--avant le premier fondu laisse passer des frames RENDUES, sur une
	--carte chargee mais NON MONTEE (joueur au marqueur par defaut, camera
	--non recadree, decor absent). D'ou l'eclair de zone nue signale en
	--jeu. FadeOut(false,1) sur ecran deja noir = no-op (FadeEffect.cs:63).
	pcall(function() GAME:FadeOut(false, 1) end)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  AI:DisableCharacterAI(partner)

  -- TODO_MAP: entry positions on the real map.
  GROUND:TeleportTo(hero, 292, 272, Direction.Up)
  GROUND:TeleportTo(partner, 260, 272, Direction.Up)
  GAME:MoveCamera(276, 200, 1, false)

  GAME:FadeIn(40)
  SOUND:PlayBGM('Sky Peak Forest.ogg', true) -- calm forest theme (tunable)
  GAME:WaitFrames(20)

  -- TODO_MAP: walk forward to the resting spot near the statue.
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveToPosition(hero, 292, 200, false, 1)
    GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GROUND:MoveToPosition(partner, 260, 200, false, 1)
    GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end)
  TASK:JoinCoroutines({coro1, coro2})
  GAME:WaitFrames(10)

  UI:SetSpeaker(partner)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_001']))
  GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_002']))
  GAME:WaitFrames(10)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_003']))
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_004']))

  -- Fil rouge Dazzling : elles ont atteint le relais avant nous, mais ont
  -- déjà repris la route. Indice court, sans transformer le checkpoint en scène longue.
  if SV.Chapter6.DazzlingEntranceSeen and not SV.Chapter6.DazzlingRelayClueSeen then
    GeneralFunctions.SetEmotion('Worried')
    UI:WaitShowDialogue("Il y a trois séries de traces près du feu...[pause=15] et un morceau de ruban violet accroché à l'écorce.")
    UI:WaitShowDialogue("La Team Dazzling est passée par ici.[pause=15] Elles continuent vers les profondeurs.")
    SV.Chapter6.DazzlingRelayClueSeen = true
    SV.Chapter6.DazzlingPresenceStage = 2
  end

  SV.Chapter6.GloomyPlayedMidpointIntro = true
  GeneralFunctions.PanCamera()
  AI:EnableCharacterAI(partner)
  AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
  GAME:CutsceneMode(false)
end


-- Returned after fainting past the checkpoint (depth floors or Zeraora).
function gloomy_forest_midpoint_ch_6.WipedCutscene()

	--LE NOIR AVANT TOUTE MISE EN PLACE (correctif de retour de boss,
	--2026-07-30). Cette scene est jouee juste apres un EndSegment /
	--EnterZone : le moteur a pose le noir, mais rien ne le REPOSE ici.
	--Elle enchaine pourtant plusieurs appels moteur (creation de PNJ,
	--TeleportTo, MoveCamera, StopBGM) avant son FadeIn. GAME:FadeOut
	--etant bloquant (ScriptGame.cs:1590) et FadeInternal rendant la
	--main a chaque frame (FadeEffect.cs:30-42), ces appels laissent
	--passer des frames RENDUES sur une carte en cours de montage —
	--c'est l'apercu de zone signale en jeu. FadeOut(false,1) sur un
	--ecran deja noir est un no-op (FadeEffect.cs:63) : gratuit si le
	--noir a tenu, salvateur sinon.
	pcall(function() GAME:FadeOut(false, 1) end)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  AI:DisableCharacterAI(partner)

  -- TODO_MAP: positions where the duo "wakes up" on the real map.
  GROUND:TeleportTo(hero, 292, 176, Direction.Left)
  GROUND:TeleportTo(partner, 260, 176, Direction.Right)

  GROUND:CharSetAnim(partner, "EventSleep", true)
  GROUND:CharSetAnim(hero, "EventSleep", true)
  GAME:MoveCamera(276, 176, 1, false)

  GAME:FadeIn(40)
  SOUND:PlayBGM('Sky Peak Forest.ogg', true)
  GAME:WaitFrames(100)

  local coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.DoAnimation(hero, 'Wake')
    GAME:WaitFrames(12)
    GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    GeneralFunctions.DoAnimation(partner, 'Wake')
    GAME:WaitFrames(12)
    GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end)
  TASK:JoinCoroutines({coro1, coro2})
  GAME:WaitFrames(30)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Pain")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_020']))
  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_021']))

  -- GloomyBossEncountered distinguishes a Zeraora wipe (true) from a depth-floors wipe (false).
  -- Unlike Crooked's LostToBoss, it must NOT be cleared here: gloomy_forest_boss uses it to
  -- pick the retry scene on the next visit.
  if SV.Chapter6.GloomyBossEncountered then
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_022']))
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_023']))
  else
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_024']))
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_025']))
  end

  -- Reset the death flag now that the wake-up scene has played.
  SV.GloomyForest.DiedPastCheckpoint = false
  GeneralFunctions.PanCamera()
  AI:EnableCharacterAI(partner)
  AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
  GAME:CutsceneMode(false)
end
