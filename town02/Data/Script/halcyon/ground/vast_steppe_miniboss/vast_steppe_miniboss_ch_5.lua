--[[ 
    vast_steppe_miniboss_ch_5.lua
    Grande Steppe — Mini-Boss : Stantler + Mudbray
    Apparition : Mudbray surgit du sol, Stantler émerge de la brume
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

vast_steppe_miniboss_ch_5 = {}

function vast_steppe_miniboss_ch_5.FirstPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:FadeOutBGM(60)
  -- NOIR AVANT LA MISE EN PLACE (patron searing_tunnel_miniboss : teleports
  -- et camera sous le fondu, plus de flash de la carte a l'arrivee).
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)

  -- Position the team entering the deep steppe
  -- LOT 1 — l'equipe atterrit a ~64px sous le boss (y=288) apres sa marche de
  -- 80px : on la fait donc apparaitre 80px plus bas (y=368).
  GROUND:TeleportTo(hero, 200, 368, Direction.Up)
  GROUND:TeleportTo(partner, 168, 368, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 136, 384, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 232, 384, Direction.Up) end
  GAME:MoveCamera(184, 364, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Sky Peak Prairie.ogg', false)

  -- Party walks forward into the misty steppe
  GAME:WaitFrames(30)
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(partner, Direction.Up, 80, false, 1)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:MoveInDirection(hero, Direction.Up, 80, false, 1)
  end)
  local coro2b = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    if t2 ~= nil then GROUND:MoveInDirection(t2, Direction.Up, 80, false, 1) end
  end)
  local coro2c = TASK:BranchCoroutine(function()
    GAME:WaitFrames(12)
    if t3 ~= nil then GROUND:MoveInDirection(t3, Direction.Up, 80, false, 1) end
  end)
  local coro3 = TASK:BranchCoroutine(function()
    -- La camera suit le duo et se cale ENTRE l'equipe (y=288) et le boss (y=200-232).
    GAME:MoveCamera(184, 244, 90, false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro2b, coro2c, coro3})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_001']))
  -- "Cette brume est de plus en plus épaisse... On n'y voit presque rien."

  GAME:WaitFrames(20)
  GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
  GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_002'], hero:GetDisplayName()))
  -- "Hé, [hero]... Tu as l'impression qu'on est observés ?"

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['VSM_003']), "Worried")
  -- "...Oui. Depuis un moment déjà."

  GAME:WaitFrames(40)

  -- === SOUND: distant rumbling, the ground begins to shake ===
  SOUND:FadeOutBGM(60)
  SOUND:PlayBattleSE('_UNK_EVT_102')
  local continueShake = true
  coro1 = TASK:BranchCoroutine(function()
    while continueShake do
      GROUND:MoveScreen(RogueEssence.Content.ScreenMover(2, 4, 30))
      GAME:WaitFrames(30)
    end
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    GeneralFunctions.EmoteAndPause(partner, "Shock", true)
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Surprised")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_004']))
    -- "Qu'est-ce que...?!
    continueShake = false
  end)
  coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(16)
    GeneralFunctions.EmoteAndPause(hero, "Exclaim", false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro3})

  GAME:WaitFrames(20)

  -- === VOICE OF THE ABYSS SPEAKS FIRST ===
  -- The tremors stop. An eerie silence falls.
  GAME:WaitFrames(30)

  SOUND:PlayBattleSE('EVT_Emote_Shock_2')
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_007']))
  -- "La harde protège son territoire..."

  GAME:WaitFrames(20)
  coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.LookAround(partner, 2, 4, true, true, false, Direction.Down)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GeneralFunctions.LookAround(hero, 2, 4, false, false, false, Direction.Left)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(10)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  GROUND:CharSetEmote(partner, "shock", 1)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_008']))
  -- "Qui... qui a dit ça ?!"

  GAME:WaitFrames(30)

  -- === PANORAMIQUE VERS LE HAUT — les boss vont surgir vers y=200-232 ===
  -- Cadre commun : boss (y≈200-232) ET duo (y≈320) tiennent à l'écran.
  GAME:MoveCamera(184, 230, 60, false)
  GAME:WaitFrames(10)

  -- === WHITE FLASH ===
  local center = GAME:GetCameraCenter()
  BossFX.Flash(center.X, center.Y, 3, 4, 10)
  GAME:WaitFrames(20)

  -- === MUDBRAY ERUPTS FROM THE EARTH (BossFX type Sol) ===
  local mudbray = CharacterEssentials.MakeCharactersFromList({
    {'Mudbray', 184, 232, Direction.Down}
  })
  GROUND:Hide('Mudbray')

  -- LOT 2 — apparition standardisee : flash blanc simple (plus d'emergence fragile)
  BossFX.Rumble({hero, partner}, 3)
  BossFX.Flash(184, 232, 3, 5, 20)
  GAME:WaitFrames(8)
  GROUND:Unhide('Mudbray')
  BossFX.Impact(9)
  GROUND:CharSetAnim(mudbray, "Idle", true)
  GAME:WaitFrames(10)

  GeneralFunctions.EmoteAndPause(partner, "Shock", true)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_005']))
  -- "Un Pokémon a surgi du sol !"

  GAME:WaitFrames(20)

  -- === SECOND WHITE FLASH — STANTLER EMERGES FROM THE MIST ===
  BossFX.Flash(center.X, center.Y, 2, 4, 18)

  local stantler = CharacterEssentials.MakeCharactersFromList({
    {'Stantler', 152, 200, Direction.DownRight}
  })
  GROUND:Hide('Stantler')

  -- LOT 2 — apparition standardisee : flash blanc simple
  SOUND:PlayBGM('Rising Fear.ogg', true)
  GAME:WaitFrames(10)
  BossFX.Flash(152, 200, 3, 5, 20)
  GAME:WaitFrames(8)
  GROUND:Unhide('Stantler')
  BossFX.Impact(9)
  GROUND:CharSetAnim(stantler, "Charge", true)

  -- Stantler steps forward through the mist
  GAME:WaitFrames(15)
  coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(stantler, Direction.Down, 28, false, 1)
    GROUND:CharAnimateTurnTo(stantler, Direction.Down, 4)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(15)
    GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
  end)
  coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro3})

  GAME:WaitFrames(20)
  GROUND:CharSetEmote(partner, "sweating", 1)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_006']))
  -- "Et celui-là... il nous attendait."

  GAME:WaitFrames(30)

  -- LOT 8.3 — le duo observe la harde : caracterisation avant l'affrontement.
  -- Camera : petit panoramique sur les boss pendant qu'on les decrit.
  GAME:MoveCamera(184, 226, 40, false)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_032']))
  -- "Leurs yeux... ils n'ont rien de sauvage. Ils sont organises."
  GAME:WaitFrames(15)
  GROUND:CharTurnToChar(hero, stantler)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['VSM_033']), "Normal")
  -- "Le grand n'a pas bouge. Il laisse l'autre nous jauger."
  GAME:WaitFrames(20)

  -- STANTLER PARLE — le gardien de la harde s'adresse au duo, pas un
  -- commentaire exterieur.
  UI:SetSpeaker(stantler)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_034']))
  -- "Vous etes sur notre terre. Nous ne vous devons rien."
  GAME:WaitFrames(20)
  -- Camera : on redescend sur le duo qui repond.
  GAME:MoveCamera(184, 258, 40, false)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_035']))
  -- "Alors on demandera le passage. Poliment, si on peut."
  GAME:WaitFrames(15)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['VSM_036']), "Worried")
  -- "La politesse ne marchera pas ici. Regarde-les."
  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Sad")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_037']))
  -- "...Je sais. Reste derriere moi."
  GAME:WaitFrames(15)
  GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['VSM_038']), "Determined")
  -- "Non. A cote de toi."
  GAME:WaitFrames(20)
  -- Camera englobante : la harde s'ebranle, on cadre boss + duo.
  GAME:MoveCamera(184, 244, 40, false)
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_039']))
  UI:SetCenter(false)
  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Pain")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_040']))
  -- "J'ai les pattes qui tremblent. Je ne vais pas faire semblant."
  GAME:WaitFrames(15)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['VSM_041']), "Determined")
  -- "Les miennes aussi. On y va quand meme."
  GAME:WaitFrames(20)

  -- ================= LA HARDE PREND LA PAROLE =================
  -- Manque le plus grave de cette scene avant ce lot : les deux boss ne
  -- disaient PAS UN MOT. Torkoal et Magmar parlent 11 fois au Tunnel ; ici
  -- le duo commentait deux silhouettes muettes. On leur donne une voix, et
  -- surtout une FONCTION : la harde ne hait pas, elle JUGE.
  --   Mudbray  = le jeune impulsif, il veut disperser.
  --   Stantler = le vieux qui tranche, il pose la question de la route.
  -- Camera remontee sur eux pendant qu'ils parlent, comme au Tunnel.
  GAME:MoveCamera(184, 222, 40, false)
  UI:SetSpeaker(stantler)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_046']))
  -- "Halte. Vous sentez la fumee et la pierre. Pas l'herbe."
  GAME:WaitFrames(15)
  GeneralFunctions.Hop(mudbray)
  UI:SetSpeaker(mudbray)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_047']))
  -- "Ils sont deux, l'ancien. Des petits. Je les disperse ?"
  GAME:WaitFrames(15)
  UI:SetSpeaker(stantler)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_048']))
  -- "Non. Des petits qui marchent ensemble, ce n'est pas du gibier."
  GAME:WaitFrames(18)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_049']))
  -- "La harde a laisse passer trois groupes cette saison..."
  GAME:WaitFrames(15)
  -- Camera englobante : la question s'adresse au duo, on cadre les deux camps.
  GAME:MoveCamera(184, 244, 40, false)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_050']))
  -- "Alors nous posons la question de la route. Savez-vous tenir ?"
  GAME:WaitFrames(20)

  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_009']))
  -- "Peu importe qui je suis. Ces créatures ne te laisseront pas passer sans combattre."

  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_010']))
  -- "Montre-leur ta détermination... ou péris."

  -- LOT 4 — la Voix pose l'enjeu du chapitre : le LIEN du duo est mis a l'epreuve.
  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_029']))
  -- "Montrez-moi ce que vaut votre lien, petits porteurs de braise."

  GAME:WaitFrames(40)

  -- === Mudbray stomps, Stantler roars ===
  coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.Hop(mudbray)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    SOUND:PlayBattleSE('EVT_Emote_Exclaim_2')
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_011'], hero:GetDisplayName()))
  -- "Pas le choix ! [hero], on se bat !"

  -- === BOSS TRANSITION ===
  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  SV.Chapter5.SteppeMiniBossSeen = true
  PrintInfo("[NREPROBE][transition] vast_steppe_miniboss_ch_5.lua ContinueDungeon('vast_steppe', 1)") GAME:ContinueDungeon("vast_steppe", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

-- Second encounter (if player died and returns)
function vast_steppe_miniboss_ch_5.SecondPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  local mudbray = CharacterEssentials.MakeCharactersFromList({
    {'Mudbray', 184, 232, Direction.Down}
  })
  local stantler = CharacterEssentials.MakeCharactersFromList({
    {'Stantler', 152, 200, Direction.Down}
  })

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  GROUND:CharSetAnim(mudbray, "Idle", true)
  GROUND:CharSetAnim(stantler, "Charge", true)

  GROUND:TeleportTo(hero, 200, 288, Direction.Up)
  GROUND:TeleportTo(partner, 168, 288, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 136, 304, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 232, 304, Direction.Up) end
  GAME:MoveCamera(184, 244, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Rising Fear.ogg', false)

  GAME:WaitFrames(30)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_012']))
  -- "Ils sont encore là... Cette fois, on ne perd pas !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  PrintInfo("[NREPROBE][transition] vast_steppe_miniboss_ch_5.lua ContinueDungeon('vast_steppe', 1)") GAME:ContinueDungeon("vast_steppe", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

-- Player defeated the mini-boss
-- Corps de la cinématique, appelé sous pcall par DefeatedBoss() : toute erreur
-- Lua ici ne doit JAMAIS laisser le joueur sur un écran noir définitif.
local function DefeatedBossBody()

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

  local mudbray = CharacterEssentials.MakeCharactersFromList({
    {'Mudbray', 184, 232, Direction.Down}
  })
  local stantler = CharacterEssentials.MakeCharactersFromList({
    {'Stantler', 152, 200, Direction.Down}
  })

  -- LOT 2.3 — pas de PoseGroundAction/"Faint" (source d'ecran noir) :
  -- les boss restent visibles pendant les dialogues, puis disparaissent au flash.
  GROUND:CharSetAnim(mudbray, "Idle", true)
  GROUND:CharSetAnim(stantler, "Charge", true)

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  GROUND:TeleportTo(hero, 200, 288, Direction.Up)
  GROUND:TeleportTo(partner, 168, 288, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 136, 304, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 232, 304, Direction.Up) end
  GAME:MoveCamera(184, 244, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  SOUND:PlayBGM('In the Depths of the Pit.ogg', false)

  GAME:WaitFrames(30)
  UI:SetSpeaker(partner)
  GeneralFunctions.Hop(partner)
  GeneralFunctions.SetEmotion("Inspired")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_013']))
  -- "On a réussi ! Ces deux-là étaient coriaces..."

  GAME:WaitFrames(20)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_014']))
  -- "Mais cette voix... Qui était-ce ?"

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['VSM_015']), "Worried")
  -- "Je ne sais pas. Continuons d'avancer."

  -- LOT 8.3 — lecture du retrait de la harde, avant l'analyse de la Voix.
  -- Camera : on remonte sur les boss qui se retirent.
  GAME:WaitFrames(15)
  GAME:MoveCamera(184, 228, 40, false)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_042']))
  -- "Ils reculent... pas en fuyant. En se retirant."
  GAME:WaitFrames(15)

  -- ================= LA HARDE TRANCHE, ET TRANSMET =================
  -- Patron du Tunnel : les vaincus ne s'evaporent pas sans rien laisser.
  -- Ici Stantler valide le passage, puis lache l'information qui compte —
  -- la Voix, personne d'autre ne l'entend. Premiere confirmation exterieure
  -- pour le joueur, et le heros ne relevera pas.
  GAME:MoveCamera(184, 222, 40, false)
  UI:SetSpeaker(stantler)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_051']))
  -- "Assez. Vous avez tenu."
  GAME:WaitFrames(15)
  UI:SetSpeaker(mudbray)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_052']))
  -- "L'ancien, ils tiennent a peine—"
  GAME:WaitFrames(12)
  UI:SetSpeaker(stantler)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_053']))
  -- "Ils tiennent encore debout. C'etait la question."
  GAME:WaitFrames(18)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_054']))
  -- "Alors avancez. L'herbe ne vous combattra plus."
  GAME:WaitFrames(20)
  -- La phrase qui reste. Camera serree sur le vieux.
  GAME:MoveCamera(184, 214, 40, false)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_055']))
  -- "Une chose, petits. Ce qui vous parle ici — nous, nous ne l'entendons pas."
  GAME:WaitFrames(25)
  GAME:MoveCamera(184, 258, 40, false)

  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['VSM_043']), "Normal")
  -- "On ne les a pas vaincus. Ils ont decide qu'on meritait la route."
  GAME:WaitFrames(15)
  -- Camera : retour sur le duo pour l'echange final.
  GAME:MoveCamera(184, 258, 40, false)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_044']))
  -- "Il y a une difference ?"
  GAME:WaitFrames(15)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['VSM_045']), "Determined")
  -- "Ici ? Toute la difference du monde."
  GAME:WaitFrames(20)

  -- LOT 4 — le duo formule l'idee d'une mise a l'epreuve, puis fixe le cap.
  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_030']))
  -- "Cette voix... elle nous observait. Elle nous TESTAIT."

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['VSM_031']), "Determined")
  -- "Alors montrons-lui la suite. Direction le cœur de la steppe."

  GAME:WaitFrames(30)
  -- Mudbray and Stantler fade/disappear into the mist
  SOUND:FadeOutBGM(60)
  local emitter = RogueEssence.Content.FlashEmitter()
  emitter.FadeInTime = 2
  emitter.HoldTime = 2
  emitter.FadeOutTime = 20
  emitter.StartColor = Color(255, 255, 255, 0)
  emitter.Layer = DrawLayer.Top
  emitter.Anim = RogueEssence.Content.BGAnimData("White", 0)
  GROUND:PlayVFX(emitter, mudbray.Position.X, mudbray.Position.Y)
  GROUND:PlayVFX(emitter, stantler.Position.X, stantler.Position.Y)
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  GAME:WaitFrames(16)
  GROUND:Hide('Mudbray')
  GROUND:Hide('Stantler')
  GAME:WaitFrames(40)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_016']))
  -- "Ils ont disparu... Allez, on continue la mission."

  GAME:WaitFrames(60)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)
end

function vast_steppe_miniboss_ch_5.DefeatedBoss()
  PrintInfo("[BossSeq][vast_steppe_miniboss_ch_5] DefeatedBoss cutscene start")
  SV.Chapter5.SteppeMiniBossCleared = true

  local ok, err = pcall(DefeatedBossBody)
  if not ok then
    PrintInfo("[BossSeq] DefeatedBoss ERREUR: "..tostring(err))
    -- On sort proprement malgré l'erreur : jamais d'écran noir définitif.
    -- Le WaitFrames complete le fondu AVANT la bascule (sinon la carte
    -- sortante reste dessinee 20 frames — fuite signalee par audit_fade_leaks).
    pcall(function() GAME:FadeOut(false, 20) GAME:WaitFrames(20) end)
  end

  -- Sortie garantie, quoi qu'il arrive.
  GAME:CutsceneMode(false)
  PrintInfo("[BossSeq][vast_steppe_miniboss_ch_5] DefeatedBoss -> vast_steppe_midpoint")
  GAME:EnterGroundMap("vast_steppe_midpoint", "Main_Entrance_Marker")
end

-- Player died to the mini-boss
-- Réécrite (audit) : l'ancienne version était un collage corrompu — dialogues
-- AVANT CutsceneMode/FadeIn (affichés sur écran noir hors cinématique),
-- répliques de VICTOIRE (VSM_024/025/027/028) mélangées dans la défaite,
-- héros/partenaire cachés en plein milieu. Storyboard propre :
-- fondu -> la harde triomphe -> la Voix commente -> le partenaire plie ->
-- fondu noir -> retour à l'entrée.
function vast_steppe_miniboss_ch_5.DiedToBoss()
  PrintInfo("[BossSeq][steppe-miniboss] DiedToBoss cutscene start")
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  local mudbray = CharacterEssentials.MakeCharactersFromList({
    {'Mudbray', 184, 232, Direction.Down}
  })
  local stantler = CharacterEssentials.MakeCharactersFromList({
    {'Stantler', 152, 200, Direction.Down}
  })
  GROUND:CharSetAnim(mudbray, "Idle", true)
  GROUND:CharSetAnim(stantler, "Idle", true)

  -- L'équipe est au sol, vaincue, face à la harde.
  GROUND:TeleportTo(hero, 200, 288, Direction.Up)
  GROUND:TeleportTo(partner, 168, 288, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 136, 304, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 232, 304, Direction.Up) end
  GROUND:CharSetAnim(hero, "EventSleep", true)
  GROUND:CharSetAnim(partner, "EventSleep", true)
  GAME:MoveCamera(184, 244, 1, false)

  GAME:FadeIn(60)
  GAME:WaitFrames(40)

  -- La caméra monte d'abord sur les vainqueurs.
  GAME:MoveCamera(176, 210, 40, false)
  GAME:WaitFrames(10)

  -- Mudbray triomphe ; Stantler reste immobile, les bois chargés.
  GROUND:CharSetEmote(mudbray, "happy", 1)
  GeneralFunctions.Hop(mudbray)
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_020']))
  UI:SetCenter(false)
  GAME:WaitFrames(20)

  -- MUDRAY PARLE APRES LA DEFAIRE — le vainqueur commente SA victoire,
  -- comme Magcargo au Creuset. (Il vient de triompher : VSM_020.)
  UI:SetSpeaker(mudbray)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_017']))
  -- "Pas encore assez fort..."
  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_018']))
  -- "Mais tu te relèveras. Ils se relèvent toujours."
  GAME:WaitFrames(30)

  -- La caméra redescend sur le duo à terre ; le partenaire se redresse à peine.
  GAME:MoveCamera(184, 278, 40, false)
  GROUND:CharEndAnim(partner)
  GeneralFunctions.DoAnimation(partner, 'Wake')
  GAME:WaitFrames(12)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Pain")
  UI:WaitShowDialogue("On... on ne peut plus continuer...[pause=20] Replions-nous...")
  GAME:WaitFrames(20)

  -- La harde se retire dans la brume, victorieuse.
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_022']))
  UI:SetCenter(false)
  GAME:WaitFrames(10)

  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)

  SV.TemporaryFlags.Dinnertime = true
  SV.TemporaryFlags.Bedtime = true
  SV.TemporaryFlags.MorningWakeup = true
  SV.TemporaryFlags.MorningAddress = true

  GROUND:CharEndAnim(hero)
  GROUND:CharEndAnim(partner)
  GAME:CutsceneMode(false)
  PrintInfo("[BossSeq][steppe-miniboss] DiedToBoss -> vast_steppe_entrance")
  GAME:EnterGroundMap("vast_steppe_entrance", "Main_Entrance_Marker")
end

return vast_steppe_miniboss_ch_5
