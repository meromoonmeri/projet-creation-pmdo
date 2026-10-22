--[[ 
    vast_steppe_guardian_ch_5.lua
    Grande Steppe — Gardien : Absol
    Apparition silencieuse depuis la brume, corne en croissant luisante
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

vast_steppe_guardian_ch_5 = {}

function vast_steppe_guardian_ch_5.FirstPreBossScene()

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

  -- LOT 1 — l'equipe atterrit a ~64px sous le boss (y=288) apres sa marche de
  -- 60px : on la fait donc apparaitre 60px plus bas (y=348).
  GROUND:TeleportTo(hero, 200, 348, Direction.Up)
  GROUND:TeleportTo(partner, 168, 348, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 136, 364, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 232, 364, Direction.Up) end
  GAME:MoveCamera(184, 344, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Sky Peak Prairie.ogg', false)

  GAME:WaitFrames(40)
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(partner, Direction.Up, 60, false, 1)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:MoveInDirection(hero, Direction.Up, 60, false, 1)
  end)
  local coro2b = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    if t2 ~= nil then GROUND:MoveInDirection(t2, Direction.Up, 60, false, 1) end
  end)
  local coro2c = TASK:BranchCoroutine(function()
    GAME:WaitFrames(12)
    if t3 ~= nil then GROUND:MoveInDirection(t3, Direction.Up, 60, false, 1) end
  end)
  local coro3 = TASK:BranchCoroutine(function()
    -- La camera se cale ENTRE l'equipe (y=288) et le gardien (y=200).
    GAME:MoveCamera(184, 244, 90, false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro2b, coro2c, coro3})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_001']))
  -- "La brume est encore plus dense ici... C'est presque irréel."

  GAME:WaitFrames(30)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_002']))
  -- "C'est le cœur de la steppe. Il doit y avoir quelque chose qui protège cet endroit."

  GAME:WaitFrames(30)

  -- === VOIX → FLASH → EMERGENCE (BossFX standardise) ===
  SOUND:FadeOutBGM(60)
  GAME:WaitFrames(30)

  -- L'ABSOL EST CREE DES LE DEBUT (CACHE) POUR PARLER AVEC SON PORTRAIT
  -- AVANT D'APPARAITRE — meme patron que Magcargo (Creuset) et Tornadus
  -- (Mont Venteux) : le locuteur a besoin du GroundChar pour afficher
  -- son portrait. Sans cette creation precoce, ses avertissements
  -- passaient par le locuteur anonyme uE040 SANS portrait (la « Voix »).
  local absol = CharacterEssentials.MakeCharactersFromList({
    {'Absol', 184, 200, Direction.Down}
  })
  GROUND:Hide('Absol')

  -- Brume montante
  BossFX.Overlay("Fog", 0, 0, 20, 70, 25, DrawLayer.Bottom, -1, 0)

  -- LOT 8.3 — la plaine se tait ; le duo se prepare. Camera mobile entre eux.
  GAME:MoveCamera(184, 262, 40, false)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_028']))
  -- "Cette brume... J'ai l'impression que la steppe nous observe de tres pres..."
  GAME:WaitFrames(15)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['VSG_029']), "Normal")
  -- "(Une presence... Quelque chose de grand approche...)"
  GAME:WaitFrames(20)
  -- L'ABSOL PARLE (AVANT D'APPARAITRE) — son avertissement, sans son portrait
  -- car il est encore cache dans la brume.
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", 0)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_030']))
  -- "Tu peux encore faire demi-tour."
  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_031']))
  -- "Quoi ?! Qui est la ?! Montrez-vous !"
  GAME:WaitFrames(15)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['VSG_032']), "Determined")
  -- "Detends-toi. Regarde vers le nord, la brume s'ecarte !"
  GAME:WaitFrames(20)

  -- PANORAMIQUE : cadre commun equipe (y=288) + gardien (y=200).
  GAME:MoveCamera(184, 244, 60, false)
  GAME:WaitFrames(10)

  -- L'Absol se revele (BossFX.Voice devient un grondement, plus la Voix)
  BossFX.Voice('VSG_004')

  -- Flash blanc
  local center = GAME:GetCameraCenter()
  BossFX.Flash(center.X, center.Y, 3, 5, 15)

  -- LOT 2 — apparition standardisee : flash blanc simple
  BossFX.Rumble({hero, partner}, 2)
  SOUND:PlayBGM('Rising Fear.ogg', true)
  BossFX.Flash(184, 200, 3, 5, 20)
  GAME:WaitFrames(8)
  GROUND:Unhide('Absol')
  BossFX.Impact(9)
  GROUND:CharSetAnim(absol, "Charge", true)

  coro1 = TASK:BranchCoroutine(function()
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
    GeneralFunctions.EmoteAndPause(partner, "Shock", true)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
    GeneralFunctions.EmoteAndPause(hero, "Exclaim", false)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  if _DATA.Save.Settings.Language == "fr" then
    UI:WaitShowDialogue("Un...[pause=10] un Absol ?![pause=15] On dit qu'il surgit quand un désastre approche...")
    GAME:WaitFrames(15)
    GeneralFunctions.HeroDialogue(hero, "(Sa corne en croissant...[pause=10] elle est plus vieille que le sentier qu'on a pris...)", "Normal")
  else
    UI:WaitShowDialogue("An...[pause=10] an Absol?![pause=15] They say it appears when a disaster draws near...")
    GAME:WaitFrames(15)
    GeneralFunctions.HeroDialogue(hero, "(Its crescent horn...[pause=10] it's older than the path we took...)", "Normal")
  end
  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_003']))
  -- "Sa corne en croissant...[pause=10] elle luit !"

  GAME:WaitFrames(30)

  -- ================= LE VIEUX GARDIEN PARLE =================
  -- Avant ce lot il etait MUET : le duo commentait une silhouette. Or c'est
  -- le personnage le plus ancien du chapitre 5, et le seul en position de
  -- dire au joueur que le monde a change AVANT que l'histoire ne le montre.
  -- Il ne frappe pas d'abord : il AVERTIT, puis s'ecarte.
  GAME:MoveCamera(184, 218, 40, false)
  UI:SetSpeaker(absol)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_038']))
  -- "Vous etes revenus. Ils reviennent toujours."
  GAME:WaitFrames(15)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_038_b']))
  GAME:WaitFrames(15)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_039']))
  -- "Je me tiens dans cette brume depuis plus longtemps que votre ville n'a un nom."
  GAME:WaitFrames(18)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_040']))
  -- "Assez longtemps pour remarquer quand la brume a eu un mauvais gout."
  GAME:WaitFrames(20)
  -- Le point de bascule du discours : on resserre.
  GAME:MoveCamera(184, 210, 40, false)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_041']))
  -- "Quelque chose sous l'herbe a cesse de dormir. Il y a des annees deja."
  GAME:WaitFrames(22)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_041_b']))
  GAME:WaitFrames(22)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_042']))
  -- "Je ne peux pas le suivre. Cette plaine m'a fait. Elle me garde."
  GAME:WaitFrames(18)
  -- Cadre commun : il s'adresse enfin directement au duo.
  GAME:MoveCamera(184, 244, 40, false)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_043']))
  -- "Alors je m'ecarterai — une fois que vous aurez prouve que la route vous vaut."
  GAME:WaitFrames(22)

  -- L'ABSOL LANCE LE DUEL — ses mots, pas une voix exterieure.
  -- (BossFX.Voice devient un grondement du gardien.)
  BossFX.Voice('VSG_006')
  GAME:WaitFrames(20)
  UI:SetSpeaker(absol)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_007']))
  -- "Prouve ta valeur, voyageur..."

  GAME:WaitFrames(30)

  -- L'Absol frappe le sol, la terre tremble
  BossFX.ShakeScreen(4, 20)
  GAME:WaitFrames(20)

  coro1 = TASK:BranchCoroutine(function()
    GROUND:AnimateInDirection(partner, "None", partner.Direction, Direction.Down, 2, 1, 1)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(5)
    GROUND:AnimateInDirection(hero, "None", hero.Direction, Direction.Down, 2, 1, 1)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_008']))
  -- "C'est le dernier obstacle avant la sortie de la steppe ! On y va !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  SV.Chapter5.SteppeGuardianSeen = true
  PrintInfo("[NREPROBE][transition] vast_steppe_guardian_ch_5.lua ContinueDungeon('vast_steppe', 2)") GAME:ContinueDungeon("vast_steppe", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function vast_steppe_guardian_ch_5.SecondPreBossScene()

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
  local absol = CharacterEssentials.MakeCharactersFromList({
    {'Absol', 184, 200, Direction.Down}
  })

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()
  GROUND:CharSetAnim(absol, "Charge", true)

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
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_009']))
  -- "On revient à la charge. Cette fois, c'est la bonne !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  PrintInfo("[NREPROBE][transition] vast_steppe_guardian_ch_5.lua ContinueDungeon('vast_steppe', 2)") GAME:ContinueDungeon("vast_steppe", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

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
  local absol = CharacterEssentials.MakeCharactersFromList({
    {'Absol', 184, 200, Direction.Down}
  })
  GROUND:CharSetAnim(absol, "Charge", true)

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

  SOUND:PlayBGM('Sky Peak Prairie.ogg', false)

  GAME:WaitFrames(30)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Inspired")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_010']))
  -- "On a vaincu le gardien de la steppe !"

  GAME:WaitFrames(20)

  -- L'Absol s'effondre, sa corne cesse de luire
  local flash = RogueEssence.Content.FlashEmitter()
  flash.FadeInTime = 2
  flash.HoldTime = 2
  flash.FadeOutTime = 10
  flash.StartColor = Color(180, 220, 255, 0)
  flash.Layer = DrawLayer.Top
  flash.Anim = RogueEssence.Content.BGAnimData("White", 0)
  GROUND:PlayVFX(flash, absol.Position.X, absol.Position.Y)
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  -- LOT 2.3 — pas de PoseGroundAction/"Faint" : le gardien reste visible
  -- pendant les dialogues, puis disparait au flash blanc.
  GROUND:CharSetAnim(absol, "Idle", true)

  GAME:WaitFrames(60)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_011']))
  -- "La brume commence à se dissiper..."

  GAME:WaitFrames(20)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_012']))
  -- "Cette voix...[pause=15] Elle savait qu'il était là."

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['VSG_013']), "Normal")
  -- "On trouvera des réponses plus tard. Allons de l'avant."

  -- LOT 8.3 — le salut du gardien, lu par le duo. Camera sur lui puis sur eux.
  GAME:WaitFrames(15)
  GAME:MoveCamera(184, 226, 40, false)
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_033']))
  UI:SetCenter(false)
  GAME:WaitFrames(15)
  GAME:MoveCamera(184, 258, 40, false)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_034']))
  -- "Est-ce qu'il vient de... nous dire au revoir ?"
  GAME:WaitFrames(15)

  -- ================= IL PASSE LE RELAIS, ET AVERTIT =================
  -- Le salut muet (VSG_033) ne suffisait pas : le vieux avait annonce qu'il
  -- s'ecarterait, il doit le DIRE. Sa derniere phrase est la contrepartie
  -- de celle de l'Absol a la steppe : la brume ne lui a jamais parle.
  -- Deux temoins independants, aucun des deux n'entend la Voix.
  GAME:MoveCamera(184, 214, 40, false)
  UI:SetSpeaker(absol)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_044']))
  -- "Bien. Je suis fatigue, et vous ne l'etes pas."
  GAME:WaitFrames(15)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_044_b']))
  GAME:WaitFrames(15)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_045']))
  -- "Prenez la plaine. Prenez la fumee derriere."
  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_045_b']))
  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_046']))
  -- "Et toi, petit — la brume ne m'a jamais parle. Demande-toi pourquoi."
  GAME:WaitFrames(25)
  GAME:MoveCamera(184, 258, 40, false)

  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['VSG_035']), "Normal")
  -- "Je crois qu'il a dit 'avancez'. Ce n'est pas pareil."
  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Inspired")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_036']))
  -- "La brume se leve. Je vois enfin la ligne de crete."
  GAME:WaitFrames(15)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['VSG_037']), "Normal")
  -- "Et de la fumee derriere. C'est la qu'on va, pas vrai."
  GAME:WaitFrames(20)

  -- LOT 4 — la Voix designe l'etape suivante de l'expedition...
  GAME:WaitFrames(30)
  BossFX.Voice('VSG_026')
  -- "Tu as apaisé le veilleur des herbes. La montagne qui brûle jugera la suite."

  -- ...et le partenaire fait le lien avec le Tunnel Ardent, ou l'expedition campe.
  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_027']))
  -- "La montagne qui brûle... le Tunnel Ardent ! C'est là que l'expédition monte le camp !"

  -- LOT 2.2 — disparition sous flash blanc, apres les dialogues de victoire.
  GAME:WaitFrames(20)
  SOUND:FadeOutBGM(60)
  local flash = RogueEssence.Content.FlashEmitter()
  flash.FadeInTime = 2
  flash.HoldTime = 2
  flash.FadeOutTime = 20
  flash.StartColor = Color(255, 255, 255, 0)
  flash.Layer = DrawLayer.Top
  flash.Anim = RogueEssence.Content.BGAnimData("White", 0)
  GROUND:PlayVFX(flash, absol.Position.X, absol.Position.Y)
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  GAME:WaitFrames(16)
  GROUND:Hide('Absol')
  GAME:WaitFrames(30)

  -- MISE EN ROUTE : L'equipe se remet en marche vers le NORD, en direction du Tunnel Ardent.
  -- Cela rend la transition visuellement continue et comprehensible avant de quitter la zone.
  GAME:WaitFrames(15)
  local depart = {}
  depart[1] = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(hero, Direction.Up, 120, false, 1)
  end)
  depart[2] = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:MoveInDirection(partner, Direction.Up, 120, false, 1)
  end)
  if t2 ~= nil then
    depart[3] = TASK:BranchCoroutine(function()
      GAME:WaitFrames(12)
      GROUND:MoveInDirection(t2, Direction.Up, 120, false, 1)
    end)
  end
  if t3 ~= nil then
    depart[4] = TASK:BranchCoroutine(function()
      GAME:WaitFrames(18)
      GROUND:MoveInDirection(t3, Direction.Up, 120, false, 1)
    end)
  end
  local coro_cam_final = TASK:BranchCoroutine(function()
    GAME:MoveCamera(184, 140, 140, false)
  end)
  depart[#depart+1] = coro_cam_final
  TASK:JoinCoroutines(depart)
  GAME:WaitFrames(40)

  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
end

function vast_steppe_guardian_ch_5.DefeatedBoss()
  PrintInfo("[BossSeq][vast_steppe_guardian_ch_5] DefeatedBoss cutscene start")

  local ok, err = pcall(DefeatedBossBody)
  if not ok then
    PrintInfo("[BossSeq] DefeatedBoss ERREUR: "..tostring(err))
    pcall(function() GAME:FadeOut(false, 20) end)
  end

  -- Sortie garantie : la suite de l'expedition (Tunnel) doit TOUJOURS s'ouvrir.
  GAME:CutsceneMode(false)
  PrintInfo("[BossSeq][vast_steppe_guardian_ch_5] DefeatedBoss -> searing_tunnel_entrance")
  -- searing_tunnel_entrance appartient a master_zone (ground 47), pas a la zone
  -- vast_steppe : EnterGroundMap inter-zone provoque "Invalid Ground Map Name".
  -- La cinematique du premier camp se lance ensuite via searing_tunnel_entrance.PlotScripting.
  -- LOT 6.2 : display=true / fanfare=true -> l'ecran de resultats standard (butin,
  -- XP, etages) s'affiche AVANT que la cinematique du camp ne prenne le relais.
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, "master_zone", -1, 47, 0, true, true)
end

-- Player died to the boss
-- Réécrite (audit IsGameOver) : l'ancienne version était un collage corrompu —
-- dialogues AVANT CutsceneMode/FadeIn (affichés hors cinématique), répliques de
-- VICTOIRE mélangées dans la défaite, héros/partenaire cachés en pleine scène.
-- Storyboard : fondu -> triomphe du boss -> la Voix -> le duo à terre -> retraite
-- du boss -> fondu noir -> retour à l'entrée.
function vast_steppe_guardian_ch_5.DiedToBoss()
  PrintInfo("[BossSeq][vast_steppe_guardian_ch_5] DiedToBoss cutscene start")
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  local absol = CharacterEssentials.MakeCharactersFromList({
    {'Absol', 184, 200, Direction.Down}
  })
  GROUND:CharSetAnim(absol, "Idle", true)

  -- L'équipe est au sol, vaincue.
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

  -- La caméra monte sur le vainqueur.
  GAME:MoveCamera(184, 205, 40, false)
  GAME:WaitFrames(10)

  -- Le boss triomphe.
  GROUND:CharSetAnim(absol, "Charge", true)
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_016']))
  UI:SetCenter(false)
  GAME:WaitFrames(20)

  -- L'ABSOL PARLE LUI-MEME APRES LA DEFAIRE — comme Magcargo au Creuset
  -- et Tornadus au Mont : le vainqueur commente SA victoire.
  UI:SetSpeaker(absol)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_014']))
  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_015']))
  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_018']))
  GAME:WaitFrames(30)

  -- La caméra redescend sur le duo ; le partenaire se redresse à peine.
  GAME:MoveCamera(184, 266, 40, false)
  GROUND:CharEndAnim(partner)
  GeneralFunctions.DoAnimation(partner, 'Wake')
  GAME:WaitFrames(12)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Pain")
  UI:WaitShowDialogue("Sa corne... cette lumière...[pause=20] On n'était pas prêts...")
  GAME:WaitFrames(20)

  -- Le boss se retire, victorieux.
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_019']))
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
  PrintInfo("[BossSeq][vast_steppe_guardian_ch_5] DiedToBoss -> vast_steppe_entrance")
  GAME:EnterGroundMap("vast_steppe_entrance", "Main_Entrance_Marker")
end

return vast_steppe_guardian_ch_5
