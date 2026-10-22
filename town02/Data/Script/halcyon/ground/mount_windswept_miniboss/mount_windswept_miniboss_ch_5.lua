--[[ 
    mount_windswept_miniboss_ch_5.lua
    Mont Venteux — Mini-Boss : Gligar + Skarmory
    Apparition : Gligar sort d'une crevasse, Skarmory fond du ciel en piqué
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

mount_windswept_miniboss_ch_5 = {}

function mount_windswept_miniboss_ch_5.FirstPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:FadeOutBGM(60)
  -- NOIR AVANT LA MISE EN PLACE (meme patron que searing_tunnel_miniboss :
  -- teleports et camera sous le fondu, plus de flash de la carte a l'arrivee).
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)

  -- LOT 1 — l'equipe atterrit a ~64px sous les boss (y=272) apres sa marche de
  -- 72px : on la fait donc apparaitre 72px plus bas (y=344).
  GROUND:TeleportTo(hero, 240, 344, Direction.Up)
  GROUND:TeleportTo(partner, 208, 344, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 176, 360, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 272, 360, Direction.Up) end
  GAME:MoveCamera(224, 340, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Mt. Travail.ogg', false)

  GAME:WaitFrames(30)
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(partner, Direction.Up, 72, false, 1)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:MoveInDirection(hero, Direction.Up, 72, false, 1)
  end)
  local coro2b = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    if t2 ~= nil then GROUND:MoveInDirection(t2, Direction.Up, 72, false, 1) end
  end)
  local coro2c = TASK:BranchCoroutine(function()
    GAME:WaitFrames(12)
    if t3 ~= nil then GROUND:MoveInDirection(t3, Direction.Up, 72, false, 1) end
  end)
  local coro3 = TASK:BranchCoroutine(function()
    -- La camera se cale ENTRE l'equipe (y=272) et les sentinelles (y=192-240).
    GAME:MoveCamera(224, 232, 90, false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro2b, coro2c, coro3})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_001']))
  -- "Ce vent est impitoyable... On doit être sacrément haut maintenant."

  GAME:WaitFrames(20)
  GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
  GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_002']))
  -- "Hé...[pause=10] tu as senti ça ? Le sol a tremblé."

  GAME:WaitFrames(30)

  -- === WIND INTENSIFIES, ROCKS START FALLING ===
  SOUND:FadeOutBGM(60)

  local windEmitter = RogueEssence.Content.FiniteOverlayEmitter()
  windEmitter.FadeIn = 30
  windEmitter.TotalTime = 90
  windEmitter.RepeatX = true
  windEmitter.Movement = RogueElements.Loc(-360, 0)
  windEmitter.Layer = DrawLayer.Back
  windEmitter.Anim = RogueEssence.Content.BGAnimData("Ominous_Wind", 0)
  GROUND:PlayVFX(windEmitter, 224, 160)

  SOUND:LoopSE("Heavy Earthquake")
  local continueShake = true
  coro1 = TASK:BranchCoroutine(function()
    while continueShake do
      GROUND:MoveScreen(RogueEssence.Content.ScreenMover(2, 4, 30))
      GAME:WaitFrames(30)
    end
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    GeneralFunctions.EmoteAndPause(partner, "Shock", true)
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Surprised")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_003']))
    -- "Un éboulement !"
    continueShake = false
  end)
  coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(26)
    GeneralFunctions.EmoteAndPause(hero, "Exclaim", false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro3})

  SOUND:FadeOutSE("Heavy Earthquake", 40)
  GAME:WaitFrames(20)

  -- SKARMORY EST CREE DES LE DEBUT (CACHE) POUR PARLER AVEC SON PORTRAIT
  -- AVANT D'APPARAITRE — meme patron que Magcargo, Tornadus et Absol :
  -- le locuteur a besoin du GroundChar pour afficher son portrait.
  local skarmory = CharacterEssentials.MakeCharactersFromList({
    {'Skarmory', 268, 192, Direction.DownLeft}
  })
  GROUND:Hide('Skarmory')

  -- LOT 8.3 — l'altitude, la tactique des sentinelles, la question sans reponse.
  GAME:MoveCamera(224, 250, 40, false)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Pain")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_029']))
  -- "L'air est rare ici."
  GAME:WaitFrames(15)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWM_030']), "Normal")
  -- "Un sur la roche, un dans le ciel. Ils ont deja fait ca."
  GAME:WaitFrames(20)

  BossFX.Voice('MWM_006')
  -- "Les Sentinelles du Pic..."
  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_031']))
  -- "Beaucoup ont grimpe. Peu ont ete autorises a finir."
  GAME:WaitFrames(15)
  GAME:MoveCamera(224, 244, 40, false)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_032']))
  -- "Autorises par qui, exactement ?"
  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWM_033']), "Worried")
  -- "...Elle ne repond jamais a celle-la."
  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_034']))
  -- "Alors on grimpera sans permission."
  GAME:WaitFrames(15)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWM_035']), "Determined")
  -- "Surveille celui du ciel, pas celui du sol."
  GAME:WaitFrames(20)
  -- SKARMORY POSE L'ENJEU — la sentinelle du ciel s'adresse au duo, pas un
  -- commentaire exterieur. Il est encore cache : portrait seul.
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, skarmory.CurrentForm.Species, skarmory.CurrentForm.Form, skarmory.CurrentForm.Skin, skarmory.CurrentForm.Gender)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_027']))
  -- "Le ciel a ses gardiens. Prouvez que vous méritez le sommet."
  GAME:WaitFrames(20)

  -- === PANORAMIQUE : cadre commun equipe (y=272) + sentinelles (y=192-240) ===
  GAME:MoveCamera(224, 232, 60, false)
  GAME:WaitFrames(10)

  -- === GLIGAR APPARAIT SOUS UN FLASH BLANC (LOT 2) ===
  local gligar = CharacterEssentials.MakeCharactersFromList({
    {'Gligar', 180, 240, Direction.DownRight}
  })
  GROUND:Hide('Gligar')
  SOUND:PlayBattleSE('_UNK_EVT_102')
  BossFX.Flash(180, 240, 3, 5, 20)
  GAME:WaitFrames(8)
  GROUND:Unhide('Gligar')
  BossFX.Impact(9)
  GROUND:CharSetAnim(gligar, "Idle", true)

  GAME:WaitFrames(20)
  coro1 = TASK:BranchCoroutine(function()
    GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
    GROUND:AnimateInDirection(partner, "None", partner.Direction, Direction.Right, 4, 1, 1)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_004']))
  -- "Un Gligar est sorti de la paroi !"

  GAME:WaitFrames(20)

  -- === SKARMORY DIVE-BOMBS FROM THE SKY ===
  -- Deja cree (et cache) en tete de scene pour parler avec son portrait
  -- avant d'apparaitre ; on ne le recree pas.

  -- === SKARMORY APPARAIT SOUS UN FLASH BLANC (LOT 2) ===
  GAME:WaitFrames(10)
  BossFX.Flash(268, 192, 3, 5, 20)
  GAME:WaitFrames(8)
  GROUND:Unhide('Skarmory')
  BossFX.Impact(9)
  GROUND:CharSetAnim(skarmory, "Idle", true)

  SOUND:PlayBGM('Rising Fear.ogg', true)

  GAME:WaitFrames(20)
  coro1 = TASK:BranchCoroutine(function()
    GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
    GeneralFunctions.EmoteAndPause(hero, "Exclaim", false)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(15)
  GROUND:CharSetEmote(partner, "shock", 1)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_005']))
  -- "Un Skarmory en piqué ! Ils sont deux !"

  GAME:WaitFrames(30)

  GAME:WaitFrames(20)
  coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.LookAround(partner, 2, 4, true, false, false, Direction.UpRight)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GeneralFunctions.LookAround(hero, 2, 4, false, false, false, Direction.UpLeft)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_007']))
  -- "Encore toi ! Qui es-tu ?!"

  GAME:WaitFrames(30)

  -- ================= LES SENTINELLES TIENNENT UN REGISTRE =================
  -- Elles etaient muettes avant ce lot. Registre choisi : ADMINISTRATIF.
  -- Elles ne menacent pas, elles COMPTENT — et c'est ce qui glace. Skarmory
  -- tient le registre, Gligar est celle qui a arrete de compter. Leur
  -- barrage n'est pas un caprice : le peage sert a filtrer ceux qui
  -- survivront au sommet. Cette logique prepare le gardien juste apres.
  GAME:MoveCamera(224, 214, 40, false)
  UI:SetSpeaker(skarmory)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_038']))
  -- "Deux grimpeurs. Non enregistres. Faites demi-tour."
  GAME:WaitFrames(15)
  UI:SetSpeaker(gligar)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_039']))
  -- "Ils ne le feront pas, tu sais. Ils ne le font jamais."
  GAME:WaitFrames(15)
  UI:SetSpeaker(skarmory)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_040']))
  -- "Quarante et un ont passe cette corniche depuis que le vent a change."
  GAME:WaitFrames(18)
  -- Le chiffre qui fait mal : camera serree sur Gligar.
  GAME:MoveCamera(224, 236, 40, false)
  UI:SetSpeaker(gligar)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_041']))
  -- "Neuf sont redescendus. J'ai arrete de compter apres ca."
  GAME:WaitFrames(22)
  UI:SetSpeaker(skarmory)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_042']))
  -- "Nous ne sommes pas la pour vous arreter. Nous sommes la pour que ca COUTE."
  GAME:WaitFrames(18)
  GAME:MoveCamera(224, 232, 40, false)
  UI:SetSpeaker(gligar)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_043']))
  -- "Ceux qui paient le prix ici survivent a ce qu'il y a plus haut."
  GAME:WaitFrames(22)

  -- LE PARTENAIRE ANALYSE — c'est au duo de lire le combat, pas a un
  -- narrateur exterieur. Mise en scene du Creuset : les protagonistes
  -- commentent la tactique ennemie.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_008']))
  -- "L'un maîtrise la terre, l'autre les cieux. Ensemble, ils sont presque invincibles."

  GAME:WaitFrames(20)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_009']))
  -- "Mais chaque sentinelle a sa faiblesse... Trouve-la."

  GAME:WaitFrames(30)

  -- Gligar snaps its claws, Skarmory screeches
  coro1 = TASK:BranchCoroutine(function()
    GROUND:CharSetAnim(gligar, "Idle", true)
    GeneralFunctions.Hop(gligar)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    GROUND:CharSetAnim(skarmory, "Idle", true)
    SOUND:PlayBattleSE('EVT_Emote_Exclaim_2')
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_010']))
  -- "On va leur montrer de quel bois on se chauffe ! À l'attaque !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  SV.Chapter5.MountMiniBossSeen = true
  PrintInfo("[NREPROBE][transition] mount_windswept_miniboss_ch_5.lua ContinueDungeon('mount_windswept', 1)") GAME:ContinueDungeon("mount_windswept", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function mount_windswept_miniboss_ch_5.SecondPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local gligar = CharacterEssentials.MakeCharactersFromList({
    {'Gligar', 180, 240, Direction.Down}
  })
  local skarmory = CharacterEssentials.MakeCharactersFromList({
    {'Skarmory', 268, 192, Direction.Down}
  })

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  GROUND:CharSetAnim(gligar, "Idle", true)
  GROUND:CharSetAnim(skarmory, "Idle", true)

  GROUND:TeleportTo(hero, 240, 272, Direction.Up)
  GROUND:TeleportTo(partner, 208, 272, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 176, 288, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 272, 288, Direction.Up) end
  GAME:MoveCamera(224, 232, 1, false)

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
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_011']))
  -- "On n'abandonne pas. Cette fois, on passe !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  PrintInfo("[NREPROBE][transition] mount_windswept_miniboss_ch_5.lua ContinueDungeon('mount_windswept', 1)") GAME:ContinueDungeon("mount_windswept", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
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
  local gligar = CharacterEssentials.MakeCharactersFromList({
    {'Gligar', 180, 240, Direction.Down}
  })
  local skarmory = CharacterEssentials.MakeCharactersFromList({
    {'Skarmory', 268, 192, Direction.Down}
  })

  -- LOT 2.3 — pas de PoseGroundAction/"Faint" : les sentinelles restent
  -- visibles pendant les dialogues, puis disparaissent au flash blanc.
  GROUND:CharSetAnim(gligar, "Idle", true)
  GROUND:CharSetAnim(skarmory, "Idle", true)

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  GROUND:TeleportTo(hero, 240, 272, Direction.Up)
  GROUND:TeleportTo(partner, 208, 272, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 176, 288, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 272, 288, Direction.Up) end
  GAME:MoveCamera(224, 232, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Mt. Travail.ogg', false)

  GAME:WaitFrames(30)
  UI:SetSpeaker(partner)
  GeneralFunctions.Hop(partner)
  GeneralFunctions.SetEmotion("Inspired")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_012']))
  -- "On a eu le dessus ! Ces deux-là ne nous arrêteront plus."

  GAME:WaitFrames(20)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_013']))
  -- "Cette voix...[pause=15] Elle nous a donné un indice, tu crois ?"

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWM_014']), "Worried")
  -- "Peut-être. Ou peut-être qu'elle veut juste nous voir réussir."

  -- LOT 8.3 — le retrait des sentinelles, choisi et non subi.
  GAME:WaitFrames(15)
  GAME:MoveCamera(224, 214, 40, false)
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_036']))
  UI:SetCenter(false)
  GAME:WaitFrames(15)
  -- ================= ELLES ENREGISTRENT LE DUO =================
  -- Paiement de la scene d'avant-combat : le peage a ete acquitte, donc
  -- elles inscrivent. La chute (« ecris cette partie deux fois ») dit le
  -- theme du chapitre 5 sans le commenter — ce qui compte, c'est ENSEMBLE.
  GAME:MoveCamera(224, 214, 40, false)
  UI:SetSpeaker(gligar)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_044']))
  -- "Paye. Integralement."
  GAME:WaitFrames(15)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_045']))
  -- "Enregistre-les, alors."
  GAME:WaitFrames(15)
  UI:SetSpeaker(skarmory)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_046']))
  -- "Deux grimpeurs. Noms inconnus. Montes ensemble."
  GAME:WaitFrames(18)
  UI:SetSpeaker(gligar)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_047']))
  -- "Ecris cette derniere partie deux fois. C'est celle qui compte."
  GAME:WaitFrames(25)

  GAME:MoveCamera(224, 246, 40, false)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWM_037']), "Normal")
  -- "Ils auraient pu continuer. Ils ont choisi que non."
  GAME:WaitFrames(20)

  -- LOT 4 — on nomme l'enjeu du sommet, juste avant le gardien final.
  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_028']))
  -- "Le sommet est proche. Ce qu'on a senti depuis le départ... c'est là-haut."

  GAME:WaitFrames(20)

  local fadeEmitter = RogueEssence.Content.FlashEmitter()
  fadeEmitter.FadeInTime = 2
  fadeEmitter.HoldTime = 2
  fadeEmitter.FadeOutTime = 20
  fadeEmitter.StartColor = Color(255, 255, 255, 0)
  fadeEmitter.Layer = DrawLayer.Top
  fadeEmitter.Anim = RogueEssence.Content.BGAnimData("White", 0)
  GROUND:PlayVFX(fadeEmitter, 224, 220)
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  GAME:WaitFrames(16)
  GROUND:Hide('Gligar')
  GROUND:Hide('Skarmory')
  GAME:WaitFrames(30)

  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)
end

function mount_windswept_miniboss_ch_5.DefeatedBoss()
  PrintInfo("[BossSeq][mount_windswept_miniboss_ch_5] DefeatedBoss cutscene start")
  SV.Chapter5.MountMiniBossCleared = true

  local ok, err = pcall(DefeatedBossBody)
  if not ok then
    PrintInfo("[BossSeq] DefeatedBoss ERREUR: "..tostring(err))
    pcall(function() GAME:FadeOut(false, 20) GAME:WaitFrames(20) end)
  end

  -- Sortie garantie, quoi qu'il arrive.
  GAME:CutsceneMode(false)
  PrintInfo("[BossSeq][mount_windswept_miniboss_ch_5] DefeatedBoss -> mount_windswept_midpoint")
  GAME:EnterGroundMap("mount_windswept_midpoint", "Main_Entrance_Marker")
end

-- Player died to the boss
-- Réécrite (audit IsGameOver) : l'ancienne version était un collage corrompu —
-- dialogues AVANT CutsceneMode/FadeIn (affichés hors cinématique), répliques de
-- VICTOIRE mélangées dans la défaite, héros/partenaire cachés en pleine scène.
-- Storyboard : fondu -> triomphe du boss -> la Voix -> le duo à terre -> retraite
-- du boss -> fondu noir -> retour à l'entrée.
function mount_windswept_miniboss_ch_5.DiedToBoss()
  PrintInfo("[BossSeq][mount_windswept_miniboss_ch_5] DiedToBoss cutscene start")
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  local gligar = CharacterEssentials.MakeCharactersFromList({
    {'Gligar', 180, 240, Direction.Down}
  })
  GROUND:CharSetAnim(gligar, "Idle", true)
  local skarmory = CharacterEssentials.MakeCharactersFromList({
    {'Skarmory', 268, 192, Direction.Down}
  })
  GROUND:CharSetAnim(skarmory, "Idle", true)

  -- L'équipe est au sol, vaincue.
  GROUND:TeleportTo(hero, 240, 272, Direction.Up)
  GROUND:TeleportTo(partner, 208, 272, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 176, 288, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 272, 288, Direction.Up) end
  GROUND:CharSetAnim(hero, "EventSleep", true)
  GROUND:CharSetAnim(partner, "EventSleep", true)
  GAME:MoveCamera(224, 232, 1, false)

  GAME:FadeIn(60)
  GAME:WaitFrames(40)

  -- La caméra monte sur le vainqueur.
  GAME:MoveCamera(224, 210, 40, false)
  GAME:WaitFrames(10)

  -- Le boss triomphe.
  GROUND:CharSetEmote(gligar, "happy", 1)
  GeneralFunctions.Hop(gligar)
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_018']))
  UI:SetCenter(false)
  GAME:WaitFrames(20)

  -- GLIGAR PARLE APRES LA DEFAIRE — le vainqueur commente SA victoire,
  -- comme Magcargo au Creuset. (Il vient de triompher : MWM_018.)
  UI:SetSpeaker(gligar)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_015']))
  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_016']))
  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_019']))
  GAME:WaitFrames(30)

  -- La caméra redescend sur le duo ; le partenaire se redresse à peine.
  GAME:MoveCamera(224, 250, 40, false)
  GROUND:CharEndAnim(partner)
  GeneralFunctions.DoAnimation(partner, 'Wake')
  GAME:WaitFrames(12)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Pain")
  UI:WaitShowDialogue("Le vent... il nous a littéralement balayés...[pause=20] Redescendons...")
  GAME:WaitFrames(20)

  -- Le boss se retire, victorieux.
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_020']))
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
  PrintInfo("[BossSeq][mount_windswept_miniboss_ch_5] DiedToBoss -> mount_windswept_entrance")
  GAME:EnterGroundMap("mount_windswept_entrance", "Main_Entrance_Marker")
end

return mount_windswept_miniboss_ch_5
