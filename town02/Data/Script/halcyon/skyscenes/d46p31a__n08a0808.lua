-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D46P31A/n08a0808.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=47, sub=3} -- $SCENARIO_SIDE = scn[47,3] (ROM)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(135, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D46P31A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GROUND:MoveToPosition(hero, 228, 236, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I think I'm almost through.", french=" J'ai bien avancé.", german=" Ich glaube, ich bin fast durch.", italian="Dovrei essere arrivato alla fine\ndi questo dungeon.", spanish=" Creo que ya queda menos."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But it's still a ways to\n[CS:P]Temporal Tower[CR].[K] Mustn't lose any time.", french="Mais il reste un bout de chemin\njusqu'à la [CS:P]Tour du Temps[CR].[K] Dépêchons!", german="Aber bis zum [CS:P]Zeitturm[CR] ist es\nnoch ein gutes Stück.[K] Nur keine Zeit verlieren.", italian="Però manca ancora molto\nalla [CS:P]Torre del Tempo[CR].[K] Devo sbrigarmi.", spanish="Aunque aún queda lo suyo para llegar\na la [CS:P]Torre del Tiempo[CR].[K] No puedo pararme."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_YONOWAARU) voix hors champ (espèce ROM)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:Y]Grovyle[CR]!", french=" [CS:Y]Massko[CR]!", german=" [CS:Y]Reptain[CR]!", italian=" [CS:Y]Grovyle[CR]!", spanish=" ¡[CS:Y]Grovyle[CR]!"})
  -- GAP: BGM BGM_PLANETS_PARALYSIS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  local npc_npc_yonowaaru_n8 = SkySceneKit.spawn_npc("dusknoir", 232, 392, Direction.Up, "NPC_YONOWAARU_N8")
  GROUND:MoveToPosition(npc_npc_yonowaaru_n8, 228, 292, false, 2)
  GAME:WaitFrames(30)
  pcall(function() GAME:MoveCamera(228, 276, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I was positive you'd come\nafter me...[K][CS:N]Dusknoir[CR]. So, hello.", french="Tiens, tiens... [K][CS:N]Noctunoir[CR].\nJ'étais sûr que tu me suivrais...", german="Ich wusste, dass du mir folgen\nwürdest...[K] Hallo, [CS:N]Zwirrfinst[CR].", italian="Ero sicuro che mi avresti\nseguito...[K][CS:N]Dusknoir[CR]. Ci rivediamo, eh?", spanish="Sabía que me perseguirías,[K]\n[CS:N]Dusknoir[CR]. Pues aquí me tienes."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Do you seriously intend to fight?\nIn the condition you're in?", french="Tu veux vraiment te battre?\nMalgré ton état?", german="Möchtest du wirklich kämpfen?\nIn deiner Verfassung?", italian="Hai davvero intenzione\ndi lottare nelle condizioni in cui ti trovi?", spanish="¿De verdad quieres luchar?\nSi no tienes fuerzas ni para andar..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Ah.[K] You're injured too.", french=" Ah.[K] Toi aussi, tu es blessé.", german="Immerhin bist du\nauch angeschlagen.", italian=" Ah![K] Anche tu sei ferito.", spanish="Bueno...[K] Tú tampoco estás\nmuy bien que digamos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 232, 152, Direction.Down, "NPC_YAMIRAMI")
  GROUND:MoveToPosition(npc_npc_yamirami, 228, 196, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" [CS:Y]Gro-Grovyle[CR]!", french=" [CS:Y]Ma-Massko[CR]!", german=" [CS:Y]R-Reptain[CR]!", italian=" [CS:Y]Gro-Grovyle[CR]!", spanish=" [CS:Y]Gro[CR]... ¡[CS:Y]Grovyle[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-16), 16, false) end) -- MovePositionOffset performer/caméra
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yamirami, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yamirami, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" There he is![K] Over there!", french=" Le voilà![K] Il est là-bas!", german=" Da ist er![K] Hier drüben!", italian=" Ehi![K] È qui!", spanish=" ¡Ahí está![K] ¡Venid!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english="[CS:N]Sableye[CR]: Wheh-heh-heh!", french="[CS:N]Ténéfix[CR]: Whé hé hé!", german="[CS:N]Zobiris[CR]: Wähähäh!", italian="[CS:N]Sableye[CR]: Meh-eh-eh!", spanish="[CS:N]Sableye[CR]: ¡Je, je, je!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6420) — id SE NDS sans portage PMDO identifié
  GROUND:MoveToPosition(npc_npc_yamirami, 180, 228, false, 2)
  local npc_npc_yamirami2 = SkySceneKit.spawn_npc("sableye", 232, 128, Direction.Down, "NPC_YAMIRAMI2")
  GROUND:MoveToPosition(npc_npc_yamirami2, 204, 204, false, 2)
  GAME:WaitFrames(20)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(16), 32, false) end) -- MovePositionOffset performer/caméra
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  local npc_npc_yamirami3 = SkySceneKit.spawn_npc("sableye", 232, 128, Direction.Down, "NPC_YAMIRAMI3")
  GROUND:MoveToPosition(npc_npc_yamirami3, 276, 228, false, 2)
  GAME:WaitFrames(20)
  local npc_npc_yamirami4 = SkySceneKit.spawn_npc("sableye", 224, 128, Direction.Down, "NPC_YAMIRAMI4")
  GROUND:MoveToPosition(npc_npc_yamirami4, 252, 204, false, 2)
  GROUND:EntTurn(npc_npc_yamirami, Direction.DownRight)
  GROUND:EntTurn(npc_npc_yamirami2, Direction.Down)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.Down)
  -- se_FadeOut(6420, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GROUND:EntTurn(npc_npc_yamirami3, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Ha hah hah ha...[K] Ha heh heh heh!", french=" Ha ha ha...[K] Ho ho ho!", german=" Hahahaha...[K] Hahehehe!", italian=" Ah ah ah ah...[K] Eh eh eh eh!", spanish=" Ja, ja, ja...[K] ¡Jua, jua, jua, jua!"})
  -- SetAnimation(39) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- message_KeyWait
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="[CS:Y]Grovyle[CR]![K] I regret to inform you\nthat the situation has changed!", french="[CS:Y]Massko[CR]![K] J'ai le regret\nde t'informer que la situation a changé!", german="[CS:Y]Reptain[CR]![K] Es tut mir leid, dir\nmitteilen zu müssen, dass sich die Situation\ngrundlegend geändert hat!", italian="[CS:Y]Grovyle[CR]![K] Mi spiace informarti\nche la situazione è cambiata!", spanish="[CS:Y]Grovyle[CR]...[K] lamento informarte\nde que han cambiado las tornas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.UpLeft)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.UpRight)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Up)
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="[CS:N]Sableye[CR]! Your arrival is\nadmirably timed!", french="[CS:N]Ténéfix[CR]! Vous arrivez\nà point nommé!", german="[CS:N]Zobiris[CR]! Ihr seid wirklich im\nrichtigen Augenblick hier angekommen!", italian="[CS:N]Sableye[CR]! Non potevate arrivare\nin un momento migliore!", spanish="¡[CS:N]Sableye[CR]! ¡Vuestra llegada\nno podría ser más oportuna!"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Be so good as to\nknock out [CS:Y]Grovyle[CR]!", french="Veuillez régler son compte à\n[CS:Y]Massko[CR]!", german="Seid doch bitte so gut,\n[CS:Y]Reptain[CR] auszuschalten!", italian="Forza, date il colpo di grazia\na [CS:Y]Grovyle[CR]!", spanish="¡Hacedme el favor de darle\nsu merecido a [CS:Y]Grovyle[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="[CS:N]Sableye[CR]: Wheh-heh-heh!", french="[CS:N]Ténéfix[CR]: Whé hé hé!", german="[CS:N]Zobiris[CR]: Wähähähäh!", italian="[CS:N]Sableye[CR]: Meh-eh-eh!", spanish="[CS:N]Sableye[CR]: ¡Je, je, je!"})
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7188) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitSe
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(10499) — id SE NDS sans portage PMDO identifié
  GROUND:EntTurn(npc_npc_yamirami2, Direction.DownRight)
  -- SetAnimation(23) [anim idle native]
  GROUND:MoveToPosition(npc_npc_yamirami2, 276, 260, false, 2) -- Slide2PositionMark (glissement)
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Wheh-heh-heh!", french=" Whé hé hé!", german=" Wähähäh!", italian=" Meh-eh-eh!", spanish=" ¡Je, je, je!"})
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-32), p.Y+(32), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(32), p.Y+(-32), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yamirami2, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  -- message_CloseEnforce
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.UpRight)
  -- GAP: se_Play(10499) — id SE NDS sans portage PMDO identifié
  GROUND:EntTurn(npc_npc_yamirami4, Direction.DownLeft)
  -- SetAnimation(23) [anim idle native]
  GROUND:MoveToPosition(npc_npc_yamirami4, 180, 260, false, 2) -- Slide2PositionMark (glissement)
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-32), p.Y+(-32), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(32), p.Y+(32), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yamirami4, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Agh!", french=" Argh!", german=" Argh!", italian=" Argh!", spanish=" ¡Ay!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yamirami2, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yamirami4, Direction.DownRight)
  GROUND:EntTurn(hero, Direction.Down)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n8, "exclaim", 1) end)
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(16), 6, false) end) -- MovePositionOffset performer/caméra
  -- GAP: se_Play(10499) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(23) [anim idle native]
  GROUND:MoveToPosition(npc_npc_yamirami2, 180, 308, false, 2) -- Slide2PositionMark (glissement)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_yonowaaru_n8.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n8, p.X+(32), p.Y+(32), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_yonowaaru_n8.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n8, p.X+(-32), p.Y+(-32), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n8, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  GROUND:EntTurn(npc_npc_yamirami2, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, -5) [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Wh...[K] What do you think\nyou are doing?!", french=" Que...[K] que crois-tu faire ainsi?!", german=" W-[K]was soll das?!?", italian="Che...[K] Che cosa vi salta\nin mente?!", spanish="Pero...[K] ¡¿qué os pensáis que\nestáis haciendo?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(10499) — id SE NDS sans portage PMDO identifié
  GROUND:EntTurn(npc_npc_yamirami4, Direction.DownRight)
  -- SetAnimation(23) [anim idle native]
  GROUND:MoveToPosition(npc_npc_yamirami4, 276, 308, false, 2) -- Slide2PositionMark (glissement)
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Wheh-heh-heh!", french=" Whé hé hé!", german=" Wähähäh!", italian=" Meh-eh-eh!", spanish=" ¡Je, je, je!"})
  -- GAP: se_Play(5126) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  do local p=npc_npc_yonowaaru_n8.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n8, p.X+(8), p.Y+(0), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_yonowaaru_n8.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n8, p.X+(-8), p.Y+(0), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Down)
  -- message_CloseEnforce
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  GROUND:EntTurn(npc_npc_yamirami4, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n8, "shock", 1) end)
  -- message_FacePositionOffset(0, -4) [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Gah! [K]Wh-what is the\nmeaning of this?!", french=" Argh! [K]Que signifie cela?", german="Gah![K]\nW-was soll das bedeuten?!?", italian="Gah![K] C-Cosa significa tutto\nquesto?!", spanish="¡Pero bueno![K] ¿Qué...?\n¿A qué viene todo esto?"})
  -- message_KeyWait
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Right)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Why...[K] What do you mean by\nsuddenly attacking me?!", french="Pourquoi...[K] pourquoi vous\nen prendre à moi de la sorte?!", german="Warum...[K] Was denkt ihr euch\ndabei, mich plötzlich anzugreifen?!?", italian="Perché...[K] mi avete\nimprovvisamente attaccato?!", spanish="¿Por qué...?[K] ¿Qué pensáis\nlograr atacándome a mí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Don't ask why! Just fight back!\n[CS:N]Dusknoir[CR]!", french="Ne pose pas de questions!\nContente-toi de riposter, [CS:N]Noctunoir[CR]!", german="Keine dummen Fragen!\nWehr dich, [CS:N]Zwirrfinst[CR]!", italian="Basta con le domande, [CS:N]Dusknoir[CR]!\nPreparati a lottare, piuttosto!", spanish="¡[CS:N]Dusknoir[CR], mejor defiéndete\ny no preguntes!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru_n8, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n8, "shock", 1) end)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Don't you get it?!", french=" Tu ne comprends donc pas?!", german=" Blickst du's nicht?!?", italian=" Non hai capito?!", spanish=" ¡¿No lo entiendes?!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="These guys...[K]\nI'm not the only one they're aiming at anymore!", french="Ces sbires...[K]\nCe n'est plus à moi seul qu'ils s'en prennent!", german="Diese Biester...[K]\nSie sind nicht mehr nur auf mich aus!", italian="Questi tizi...[K] Non sono più il loro\nunico obiettivo!", spanish=" Ahora...[K] ¡Ya no soy su único objetivo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" What are you saying?!", french=" Qu'entends-tu par là?!", german=" Was sagst du da?!?", italian=" Ma cosa stai dicendo?!", spanish=" ¡¿Pero qué dices?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(8), p.Y+(8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.Up)
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 1) end -- SlidePositionOffset
  do local p=npc_npc_yamirami4.Position; GROUND:MoveToPosition(npc_npc_yamirami4, p.X+(-8), p.Y+(-8), false, 1) end -- Move2PositionOffset
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Down)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_yonowaaru_n8.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n8, p.X+(0), p.Y+(-8), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  -- SetAnimation(2) [anim idle native]
  do local p=npc_npc_yamirami3.Position; GROUND:MoveToPosition(npc_npc_yamirami3, p.X+(-8), p.Y+(8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami2.Position; GROUND:MoveToPosition(npc_npc_yamirami2, p.X+(8), p.Y+(-8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Why...[K] Why me...", french=" Pourquoi...[K] pourquoi moi...", german=" Warum...[K] Warum ich...", italian=" Perché...[K] Perché io...", spanish="¿Y por qué...?[K] ¿Por qué iban\na atacarme a mí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I don't know either!", french=" Aucune idée!", german=" Weiß ich auch nicht!", italian=" Non lo so!", spanish=" ¡Y yo qué sé!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Believe me...[K]if this goes on...", french=" Crois-moi...[K] si ça continue...", german="Glaub mir...[K]\nWenn das so weitergeht...", italian=" Credimi...[K] se va avanti così...", spanish="Pero una cosa está clara...[K] Si no\nles paramos los pies..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(8), p.Y+(8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.Up)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(4), false, 1) end -- SlidePositionOffset
  do local p=npc_npc_yamirami4.Position; GROUND:MoveToPosition(npc_npc_yamirami4, p.X+(-8), p.Y+(-8), false, 1) end -- Move2PositionOffset
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Down)
  do local p=npc_npc_yonowaaru_n8.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n8, p.X+(0), p.Y+(-4), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yamirami3.Position; GROUND:MoveToPosition(npc_npc_yamirami3, p.X+(-8), p.Y+(8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami2.Position; GROUND:MoveToPosition(npc_npc_yamirami2, p.X+(8), p.Y+(-8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="We'll...[K] Both of us will get\nknocked out!", french="... nous...[K] nous allons tomber\nK.O. tous les deux!", german="Wir werden...[K] Wir sollen beide\nausgeschaltet werden!", italian="Noi...[K] verremo entrambi\nsconfitti!", spanish="Los dos...[K] ¡¡vamos a acabar\ndebilitados!!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:N]Sableye[CR]: Wheh-heh-heh!", french="[CS:N]Ténéfix[CR]: Whé hé hé!", german="[CS:N]Zobiris[CR]: Wähähäh!", italian="[CS:N]Sableye[CR]: Meh-eh-eh!", spanish="[CS:N]Sableye[CR]: ¡Je, je, je!"})
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- message_CloseEnforce
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(135, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
