--[[ 
    searing_tunnel_miniboss_ch_5.lua
    Tunnel Incandescent — Mini-Boss : Torkoal + Magmar
    Apparition : Torkoal émerge de la vapeur, Magmar tombe du plafond en flammes
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

searing_tunnel_miniboss_ch_5 = {}

function searing_tunnel_miniboss_ch_5.FirstPreBossScene()

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

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  -- LOT 1 — l'equipe atterrit a ~64px sous les boss (y=280) apres sa marche de
  -- 64px : on la fait donc apparaitre 64px plus bas (y=344).
  GROUND:TeleportTo(hero, 240, 344, Direction.Up)
  GROUND:TeleportTo(partner, 272, 344, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 208, 360, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 304, 360, Direction.Up) end
  GAME:MoveCamera(256, 340, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Spring Cave.ogg', false)

  -- Team walks through the tunnel
  GAME:WaitFrames(30)
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(partner, Direction.Up, 64, false, 1)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:MoveInDirection(hero, Direction.Up, 64, false, 1)
  end)
  local coro2b = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    if t2 ~= nil then GROUND:MoveInDirection(t2, Direction.Up, 64, false, 1) end
  end)
  local coro2c = TASK:BranchCoroutine(function()
    GAME:WaitFrames(12)
    if t3 ~= nil then GROUND:MoveInDirection(t3, Direction.Up, 64, false, 1) end
  end)
  local coro3 = TASK:BranchCoroutine(function()
    -- La camera se cale ENTRE l'equipe (y=280) et le clan de lave (y=208-232).
    GAME:MoveCamera(256, 240, 90, false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro2b, coro2c, coro3})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_001']))
  -- "Cette chaleur devient étouffante... On doit approcher d'une poche de magma."

  GAME:WaitFrames(20)
  GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
  GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_002'], hero:GetDisplayName()))
  -- "Tu entends ça, [hero] ? On dirait... de la vapeur sous pression."

  GAME:WaitFrames(30)

  -- === STEAM BEGINS TO FILL THE CHAMBER ===
  SOUND:FadeOutBGM(40)
  SOUND:LoopSE("Light Earthquake")

  -- BUG BRUME : cet overlay etait EMIS EN UN POINT (256,200) sur une carte de
  -- 416x544 px, d'ou une salle couverte en partie seulement. La couverture
  -- integrale est desormais assuree par GROUND:AddMapStatus("steam") pose dans
  -- Init (cf. init.lua). On garde ici un voile mobile PURE DECORATION, repete
  -- sur la largeur de la salle pour epaissir l'air pendant la montee en tension.
  for _, vx in ipairs({96, 208, 320}) do
    local steamEmitter = RogueEssence.Content.FiniteOverlayEmitter()
    steamEmitter.FadeIn = 40
    steamEmitter.TotalTime = 120
    steamEmitter.RepeatX = true
    steamEmitter.Layer = DrawLayer.Back
    steamEmitter.Anim = RogueEssence.Content.BGAnimData("Steam", 2)
    GROUND:PlayVFX(steamEmitter, vx, 200)
  end

  local continueSteam = true
  coro1 = TASK:BranchCoroutine(function()
    while continueSteam do
      GROUND:MoveScreen(RogueEssence.Content.ScreenMover(1, 3, 30))
      GAME:WaitFrames(30)
    end
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_003']))
    -- "De la vapeur ! Elle vient de partout !"
    continueSteam = false
  end)
  coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(26)
    GeneralFunctions.EmoteAndPause(hero, "Sweatdrop", false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro3})

  SOUND:FadeOutSE("Light Earthquake", 30)
  GAME:WaitFrames(30)

  -- === LA VOIX DE L'ABYSSE PARLE EN PREMIER ===
  -- Ordre impose : Voix -> Flash -> Emergence thematique.
  -- LOT 8.3 — la chaleur et le statut d'intrus, avant que la Voix ne tranche.
  GAME:MoveCamera(256, 258, 40, false)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Pain")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_029']))
  -- "La roche est brulante sous mes pattes."
  GAME:WaitFrames(15)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['STM_030']), "Normal")
  -- "Ces deux-la ne gardent pas un passage. Ils gardent un foyer."
  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Sad")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_031']))
  -- "Alors c'est nous, les intrus."
  GAME:WaitFrames(15)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['STM_032']), "Normal")
  -- "Tout voyageur l'est, jusqu'a preuve du contraire."
  GAME:WaitFrames(20)

  BossFX.Voice('STM_006')
  GAME:WaitFrames(20)
  -- LOT 4 — la Voix relie l'epreuve du feu a celle de la steppe deja franchie.
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_027']))
  -- "Le feu éprouve ceux que l'herbe a laissés passer."
  GAME:WaitFrames(20)

  -- === PANORAMIQUE : cadre commun equipe (y=280) + clan de lave (y=208-232) ===
  GAME:MoveCamera(256, 240, 60, false)
  GAME:WaitFrames(10)

  -- === TORKOAL APPARAIT SOUS UN FLASH BLANC (LOT 2) ===
  local torkoal = CharacterEssentials.MakeCharactersFromList({
    {'Torkoal', 220, 232, Direction.DownRight}
  })
  GROUND:Hide('Torkoal')
  SOUND:PlayBattleSE('_UNK_EVT_102')
  BossFX.Flash(220, 232, 3, 5, 20)
  GAME:WaitFrames(8)
  GROUND:Unhide('Torkoal')
  BossFX.Impact(9)

  GAME:WaitFrames(20)

  coro1 = TASK:BranchCoroutine(function()
    GROUND:AnimateInDirection(partner, "None", partner.Direction, Direction.Down, 4, 1, 1)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GROUND:AnimateInDirection(hero, "None", hero.Direction, Direction.Left, 4, 1, 1)
    GeneralFunctions.EmoteAndPause(hero, "Exclaim", false)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_004']))
  -- "Un Torkoal ! Il nous barre la route !"

  GAME:WaitFrames(20)

  -- === MAGMAR TOMBE DU PLAFOND EN FLAMMES (signature FEU) ===
  local magmar = CharacterEssentials.MakeCharactersFromList({
    {'Magmar', 292, 208, Direction.DownLeft}
  })
  -- === MAGMAR APPARAIT SOUS UN FLASH BLANC (LOT 2) ===
  GROUND:Hide('Magmar')
  SOUND:PlayBattleSE('DUN_Fire_Spin')
  GAME:WaitFrames(10)
  BossFX.Flash(292, 208, 3, 5, 20)
  GAME:WaitFrames(8)
  GROUND:Unhide('Magmar')
  BossFX.Impact(9)
  GROUND:CharSetAnim(magmar, "Idle", true)

  GAME:WaitFrames(20)
  coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.LookAround(partner, 2, 4, true, false, false, Direction.Down)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GeneralFunctions.LookAround(hero, 2, 4, false, false, false, Direction.Right)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  GROUND:CharSetEmote(partner, "shock", 1)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_007']))
  -- "Cette voix, encore !"

  GAME:WaitFrames(30)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_008']))
  -- "Ils gardent les fournaises depuis des siècles. Leur chaleur te consumera."

  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_009']))
  -- "À moins que tu ne prouves ta propre flamme..."

  GAME:WaitFrames(30)

  -- Torkoal releases smoke, Magmar crackles with fire
  coro1 = TASK:BranchCoroutine(function()
    GROUND:CharSetAnim(torkoal, "Idle", true)
    local smoke = RogueEssence.Content.FiniteOverlayEmitter()
    smoke.FadeIn = 10
    smoke.TotalTime = 50
    smoke.Layer = DrawLayer.Front
    smoke.Anim = RogueEssence.Content.BGAnimData("Fog", 0)
    GROUND:PlayVFX(smoke, torkoal.Position.X, torkoal.Position.Y - 16)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    BossFX.Particle("Ember", magmar.Position.X, magmar.Position.Y, 4)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  -- ================= ENCERCLEMENT PAR LES LIMAGMA =================
  -- Role narratif tranche : Torkoal et Magmar ne TESTENT pas (c'etait la harde
  -- de la steppe). Ils PROTEGENT : la fournaise s'est dereglee sous ce sol, ils
  -- tiennent le dernier anneau sur lequel on survit. Leur barrage est un
  -- avertissement, pas un defi — et c'est ce qui rend leur defaite utile :
  -- vaincus, ils livrent la regle des secousses qui sert au Crucible.
  GAME:WaitFrames(20)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_040']))
  UI:SetCenter(false)
  GAME:WaitFrames(15)

  -- Cinq sbires se hissent du sol et referment le cercle autour du duo (y=280).
  local sbires = CharacterEssentials.MakeCharactersFromList({
    {'Limagma1', 200, 264, Direction.Right},
    {'Limagma2', 312, 264, Direction.Left},
    {'Limagma3', 208, 320, Direction.UpRight},
    {'Limagma4', 304, 320, Direction.UpLeft},
    {'Limagma5', 256, 336, Direction.Up}
  })
  for i = 1, 5 do GROUND:Hide('Limagma'..i) end
  local pts = {{200,264},{312,264},{208,320},{304,320},{256,336}}
  for i = 1, 5 do
    BossFX.Particle("Ember", pts[i][1], pts[i][2], 3)
    GROUND:Unhide('Limagma'..i)
    GAME:WaitFrames(6)
  end
  BossFX.Impact(7)
  -- Camera : on recule sur le cercle entier plutot que sur un seul acteur.
  GAME:MoveCamera(256, 272, 40, false)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_041']))
  UI:SetCenter(false)
  GAME:WaitFrames(15)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_042']))
  GAME:WaitFrames(12)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['STM_043']), "Determined")
  GAME:WaitFrames(18)

  -- Le clan s'explique. Camera remontee sur Torkoal et Magmar.
  GAME:MoveCamera(256, 244, 40, false)
  UI:SetSpeaker(torkoal)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_044']))
  GAME:WaitFrames(12)
  UI:SetSpeaker(magmar)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_045']))
  GAME:WaitFrames(12)
  UI:SetSpeaker(torkoal)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_046']))
  GAME:WaitFrames(12)
  GROUND:CharSetEmote(magmar, "sweating", 1)
  UI:SetSpeaker(magmar)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_047']))
  GAME:WaitFrames(20)

  -- Le duo comprend, et fait le lien avec la Grande Steppe.
  GAME:MoveCamera(256, 268, 40, false)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Sad")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_048']))
  GAME:WaitFrames(12)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['STM_049']), "Normal")
  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_050']))
  GAME:WaitFrames(12)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['STM_051']), "Determined")
  GAME:WaitFrames(20)

  -- Le clan cede sur le fond, mais exige la preuve.
  GAME:MoveCamera(256, 244, 40, false)
  UI:SetSpeaker(torkoal)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_052']))
  GAME:WaitFrames(15)
  GeneralFunctions.Hop(magmar)
  UI:SetSpeaker(magmar)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_053']))
  GAME:WaitFrames(12)
  UI:SetSpeaker(torkoal)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_054']))
  GAME:WaitFrames(20)

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_010'], hero:GetDisplayName()))
  -- "On n'a pas fait tout ce chemin pour rien ! [hero], en avant !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  SV.Chapter5.TunnelMiniBossSeen = true
  -- Le mini-boss se joue desormais APRES les profondeurs (seg 1) : le combat doit
  -- donc lancer l'arene du clan de lave, pas relancer le segment 1 deja franchi.
  PrintInfo("[NREPROBE][transition] searing_tunnel_miniboss_ch_5.lua ContinueDungeon('searing_tunnel', 2)") GAME:ContinueDungeon("searing_tunnel", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function searing_tunnel_miniboss_ch_5.SecondPreBossScene()

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
  local torkoal = CharacterEssentials.MakeCharactersFromList({
    {'Torkoal', 220, 232, Direction.Down}
  })
  local magmar = CharacterEssentials.MakeCharactersFromList({
    {'Magmar', 292, 208, Direction.Down}
  })

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()
  GROUND:CharSetAnim(torkoal, "Idle", true)
  GROUND:CharSetAnim(magmar, "Idle", true)

  GROUND:TeleportTo(hero, 240, 280, Direction.Up)
  GROUND:TeleportTo(partner, 272, 280, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 208, 296, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 304, 296, Direction.Up) end
  GAME:MoveCamera(256, 240, 1, false)

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
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_011']))
  -- "De retour. Cette fois, on est prêts !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  -- Le mini-boss se joue desormais APRES les profondeurs (seg 1) : le combat doit
  -- donc lancer l'arene du clan de lave, pas relancer le segment 1 deja franchi.
  PrintInfo("[NREPROBE][transition] searing_tunnel_miniboss_ch_5.lua ContinueDungeon('searing_tunnel', 2)") GAME:ContinueDungeon("searing_tunnel", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

-- Corps de la cinematique, appele sous pcall par DefeatedBoss() : toute erreur
-- Lua ici ne doit JAMAIS laisser le joueur sur un ecran noir definitif.
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
  local torkoal = CharacterEssentials.MakeCharactersFromList({
    {'Torkoal', 220, 232, Direction.Down}
  })
  local magmar = CharacterEssentials.MakeCharactersFromList({
    {'Magmar', 292, 208, Direction.Down}
  })

  -- LOT 2.3 — pas de PoseGroundAction/"Faint" : le clan reste visible pendant
  -- les dialogues, puis disparait au flash blanc.
  GROUND:CharSetAnim(torkoal, "Idle", true)
  GROUND:CharSetAnim(magmar, "Idle", true)

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  GROUND:TeleportTo(hero, 240, 280, Direction.Up)
  GROUND:TeleportTo(partner, 272, 280, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 208, 296, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 304, 296, Direction.Up) end
  GAME:MoveCamera(256, 240, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Spring Cave.ogg', false)

  GAME:WaitFrames(30)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Inspired")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_012']))
  -- "On a survécu à la fournaise !"

  GAME:WaitFrames(20)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_013']))
  -- "Cette voix...[pause=15] Elle semble tout savoir de ce donjon."

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['STM_014']), "Normal")
  -- "C'est comme si elle nous testait. Continuons."

  -- ===== APRES VICTOIRE : le clan cede et TRANSMET (payoff narratif) =====
  -- Ils ne disparaissent pas sans rien laisser : ils donnent la regle des
  -- secousses (qui sert litteralement au Crucible juste apres) et l'indice
  -- que la Voix precede le dereglement du tunnel.
  GAME:WaitFrames(15)
  GAME:MoveCamera(256, 272, 40, false)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_055']))
  UI:SetCenter(false)
  GAME:WaitFrames(12)
  GAME:MoveCamera(256, 244, 40, false)
  UI:SetSpeaker(torkoal)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_056']))
  GAME:WaitFrames(12)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_057']))
  GAME:WaitFrames(12)
  UI:SetSpeaker(magmar)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_058']))
  GAME:WaitFrames(15)
  UI:SetSpeaker(torkoal)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_059']))
  GAME:WaitFrames(18)
  GAME:MoveCamera(256, 268, 40, false)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['STM_060']), "Worried")
  GAME:WaitFrames(15)
  UI:SetSpeaker(magmar)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_061']))
  GAME:WaitFrames(12)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_062']))
  GAME:WaitFrames(20)

  -- LOT 8.3 — le retrait du clan, lu comme un accord et non comme une victoire.
  GAME:WaitFrames(15)
  GAME:MoveCamera(256, 224, 40, false)
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_035']))
  UI:SetCenter(false)
  GAME:WaitFrames(15)
  GAME:MoveCamera(256, 254, 40, false)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Sad")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_036']))
  -- "Pas de cris de joie cette fois."
  GAME:WaitFrames(15)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['STM_037']), "Normal")
  -- "Ca n'en est pas une. C'est un accord."
  GAME:WaitFrames(20)

  -- LOT 4 — le clan libere le passage : cap sur le relais.
  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_028']))
  -- "Le clan de lave nous laisse passer... le relais ne doit plus être loin."

  GAME:WaitFrames(20)

  -- Torkoal and Magmar fade into steam
  local fadeSteam = RogueEssence.Content.FlashEmitter()
  fadeSteam.FadeInTime = 2
  fadeSteam.HoldTime = 2
  fadeSteam.FadeOutTime = 20
  fadeSteam.StartColor = Color(255, 255, 255, 0)
  fadeSteam.Layer = DrawLayer.Top
  fadeSteam.Anim = RogueEssence.Content.BGAnimData("White", 0)
  GROUND:PlayVFX(fadeSteam, 256, 220)
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  GAME:WaitFrames(16)
  GROUND:Hide('Torkoal')
  GROUND:Hide('Magmar')
  for i = 1, 5 do pcall(function() GROUND:Hide('Limagma'..i) end) end
  GAME:WaitFrames(30)

  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)
end

function searing_tunnel_miniboss_ch_5.DefeatedBoss()
  PrintInfo("[BossSeq][searing_tunnel_miniboss_ch_5] DefeatedBoss cutscene start")
  SV.Chapter5.TunnelMiniBossCleared = true

  local ok, err = pcall(DefeatedBossBody)
  if not ok then
    PrintInfo("[BossSeq] DefeatedBoss ERREUR: "..tostring(err))
    -- Le WaitFrames complete le fondu AVANT la bascule (sinon la carte
    -- sortante reste dessinee 20 frames — fuite signalee par audit_fade_leaks).
    pcall(function() GAME:FadeOut(false, 20) GAME:WaitFrames(20) end)
  end

  -- Sortie garantie, quoi qu'il arrive.
  GAME:CutsceneMode(false)
  -- Le clan s'ecarte : la voie du Crucible s'ouvre. searing_crucible est un
  -- ground de CETTE zone (GroundMaps), donc EnterGroundMap est legal ici.
  PrintInfo("[BossSeq][searing_tunnel_miniboss_ch_5] DefeatedBoss -> searing_crucible")
  GAME:EnterGroundMap('searing_crucible', 'Main_Entrance_Marker')
end

-- Player died to the boss
-- Réécrite (audit IsGameOver) : l'ancienne version était un collage corrompu —
-- dialogues AVANT CutsceneMode/FadeIn (affichés hors cinématique), répliques de
-- VICTOIRE mélangées dans la défaite, héros/partenaire cachés en pleine scène.
-- Storyboard : fondu -> triomphe du boss -> la Voix -> le duo à terre -> retraite
-- du boss -> fondu noir -> retour à l'entrée.
function searing_tunnel_miniboss_ch_5.DiedToBoss()
  PrintInfo("[BossSeq][searing_tunnel_miniboss_ch_5] DiedToBoss cutscene start")
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  local torkoal = CharacterEssentials.MakeCharactersFromList({
    {'Torkoal', 220, 232, Direction.Down}
  })
  GROUND:CharSetAnim(torkoal, "Idle", true)
  local magmar = CharacterEssentials.MakeCharactersFromList({
    {'Magmar', 292, 208, Direction.Down}
  })
  GROUND:CharSetAnim(magmar, "Idle", true)

  -- L'équipe est au sol, vaincue.
  GROUND:TeleportTo(hero, 240, 280, Direction.Up)
  GROUND:TeleportTo(partner, 272, 280, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 208, 296, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 304, 296, Direction.Up) end
  GROUND:CharSetAnim(hero, "EventSleep", true)
  GROUND:CharSetAnim(partner, "EventSleep", true)
  GAME:MoveCamera(256, 240, 1, false)

  GAME:FadeIn(60)
  GAME:WaitFrames(40)

  -- La caméra monte sur le vainqueur.
  GAME:MoveCamera(256, 215, 40, false)
  GAME:WaitFrames(10)

  -- Le boss triomphe.
  GROUND:CharSetEmote(torkoal, "happy", 1)
  GeneralFunctions.Hop(torkoal)
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_018']))
  UI:SetCenter(false)
  GAME:WaitFrames(20)

  -- TORKOAL PARLE APRES LA DEFAIRE — le vainqueur commente SA victoire,
  -- comme Magcargo au Creuset. (Il vient de triompher : STM_018.)
  UI:SetSpeaker(torkoal)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_015']))
  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_016']))
  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_019']))
  GAME:WaitFrames(30)

  -- La caméra redescend sur le duo ; le partenaire se redresse à peine.
  GAME:MoveCamera(256, 258, 40, false)
  GROUND:CharEndAnim(partner)
  GeneralFunctions.DoAnimation(partner, 'Wake')
  GAME:WaitFrames(12)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Pain")
  UI:WaitShowDialogue("Trop... trop chaud...[pause=20] On ne passera pas cette fois...")
  GAME:WaitFrames(20)

  -- Le boss se retire, victorieux.
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_020']))
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
  PrintInfo("[BossSeq][searing_tunnel_miniboss_ch_5] DiedToBoss -> searing_tunnel_entrance")
  GAME:EnterGroundMap("searing_tunnel_entrance", "Main_Entrance_Marker")
end

return searing_tunnel_miniboss_ch_5
