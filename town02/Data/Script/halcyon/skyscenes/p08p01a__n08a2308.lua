-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P08P01A/n08a2308.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=47, sub=10} -- $SCENARIO_SIDE = scn[47,10] (ROM)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(140, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_P08P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_FUTURE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 296, 308, false, 2)
  local npc_npc_yonowaaru_n8 = SkySceneKit.spawn_npc("dusknoir", 256, 544, Direction.Up, "NPC_YONOWAARU_N8")
  GROUND:MoveToPosition(npc_npc_yonowaaru_n8, 252, 340, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru_n8, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Is this it, [CS:Y]Grovyle[CR]?", french=" Est-ce ici, [CS:Y]Massko[CR]?", german=" Sind wir hier richtig, [CS:Y]Reptain[CR]?", italian=" È questo, [CS:Y]Grovyle[CR]?", spanish=" ¿Es aquí, [CS:Y]Grovyle[CR]?"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" The place you met [CS:N]Celebi[CR]?", french="L'endroit où se trouve [CS:N]Celebi[CR]\nd'ordinaire?", german="Ist dies der Ort, an dem du\n[CS:N]Celebi[CR] getroffen hast?", italian="Il luogo in cui ti incontravi\ncon [CS:N]Celebi[CR]?", spanish=" ¿Aquí era donde estaba [CS:N]Celebi[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yonowaaru_n8, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yeah, that's right.", french=" Oui, c'est bien ici.", german=" Ja, genau.", italian=" Sì, esatto.", spanish=" Así es."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" ...[K]It's quiet...", french=" ...[K] Quel calme...", german=" ...[K]Wie still es ist...", italian=" ...[K] Che silenzio...", spanish=" Vaya...[K] Qué silencio que hay aquí..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Was she already captured...[K]\nWas she already taken away...", french="Aurait-elle déjà été capturée...[K]\net emmenée...?", german="Haben sie es schon gefangen...[K]\nHaben sie es schon mitgenommen...", italian="Forse è già stata catturata...[K]\ne portata via...", spanish="¿La habrán capturado ya?[K]\n¿Se la habrán llevado?"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Or maybe she sensed danger and\nran away from here...", french="Ou peut-être s'est-elle enfuie\naprès avoir senti le danger imminent...", german="Oder hat es die Gefahr gespürt\nund ist weggelaufen...", italian="O forse ha avvertito il pericolo\ned è scappata...", spanish="O tal vez ha presentido el\npeligro y ha huido..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="It's possible she\noutwitted them...", french=" Il se peut qu'elle les ait semés...", german="Es ist möglich, dass es sie\nausgetrickst hat...", italian="È possibile che li abbia battuti\nin astuzia...", spanish="Es posible que haya sido más\nlista que ellos..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Maybe she's still hiding\nsomewhere nearby...", french="Ou alors, se cacherait-elle\nquelque part dans les parages...?", german="Vielleicht versteckt es sich\nnoch hier in der Nähe...", italian="Chissà, magari è nascosta\nancora qui, da qualche parte...", spanish="A lo mejor está escondida\npor aquí cerca..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Could be any one of those...", french=" Dans un de ces...", german=" Könnte überall sein...", italian=" Tutto è possibile...", spanish="Podría ser cualquiera de esas\ncosas..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="...[K] (There's something strange\nabout the air here...)", french="...[K] (Il y a quelque chose\nd'étrange, ici...)", german="...[K](Etwas Eigenartiges liegt\nhier in der Luft...)", italian="...[K] (In questo posto c'è\nuna strana atmosfera...)", spanish="Vaya...[K] (Se respira algo extraño\nen este lugar...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="([CS:N]Celebi[CR]...[K]\nShe probably left already...)", french="([CS:N]Celebi[CR]...[K]\nElle est probablement déjà partie...)", german="([CS:N]Celebi[CR]...[K]\nVielleicht ist es bereits fort...)", italian="([CS:N]Celebi[CR]...[K] Forse se n'è già\nandata...)", spanish=" ([CS:N]Celebi[CR]...[K] probablemente se ha ido ya.)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(30) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:N]Sableye[CR]: Wheh-heh-heh!", french="[CS:N]Ténéfix[CR]: Whé hé hé!", german="[CS:N]Zobiris[CR]: Wähähäh!", italian="[CS:N]Sableye[CR]: Meh-eh-eh!", spanish="[CS:N]Sableye[CR]: ¡Je, je, je!"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n8, "exclaim", 1) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Down)
  -- GAP: se_Play(6420) — id SE NDS sans portage PMDO identifié
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 240, 184, Direction.Down, "NPC_YAMIRAMI")
  GROUND:MoveToPosition(npc_npc_yamirami, 240, 276, false, 2)
  local npc_npc_yamirami2 = SkySceneKit.spawn_npc("sableye", 280, 160, Direction.Down, "NPC_YAMIRAMI2")
  GROUND:MoveToPosition(npc_npc_yamirami2, 276, 268, false, 2)
  local npc_npc_yamirami3 = SkySceneKit.spawn_npc("sableye", 320, 200, Direction.Down, "NPC_YAMIRAMI3")
  GROUND:MoveToPosition(npc_npc_yamirami3, 316, 276, false, 2)
  local npc_npc_yamirami4 = SkySceneKit.spawn_npc("sableye", 224, 464, Direction.Up, "NPC_YAMIRAMI4")
  GROUND:MoveToPosition(npc_npc_yamirami4, 224, 348, false, 2)
  local npc_npc_yamirami5 = SkySceneKit.spawn_npc("sableye", 280, 512, Direction.Up, "NPC_YAMIRAMI5")
  GROUND:MoveToPosition(npc_npc_yamirami5, 276, 372, false, 2)
  local npc_npc_yamirami6 = SkySceneKit.spawn_npc("sableye", 336, 488, Direction.Up, "NPC_YAMIRAMI6")
  GROUND:MoveToPosition(npc_npc_yamirami6, 332, 348, false, 2)
  GAME:WaitFrames(30)
  -- GAP: BGM BGM_OH_NO non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(hero, 276, 308, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(5)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_yonowaaru_n8, 276, 340, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Down)
  GROUND:EntTurn(npc_npc_yamirami3, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.UpRight)
  GROUND:EntTurn(npc_npc_yamirami, Direction.DownRight)
  -- se_FadeOut(6420, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GROUND:EntTurn(npc_npc_yamirami6, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_yamirami2, Direction.Down)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" I knew it...", french=" Je le savais...", german=" Ich wusste es...", italian=" Lo sapevo...", spanish=" Lo sabía..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="They brought me right into\ntheir trap!", french=" C'est un piège!", german="Sie haben uns geradewegs in\neine Falle gelockt!", italian="Siamo cascati dritti nella loro\ntrappola!", spanish="¡Nos han hecho caer de bruces\nen su trampa!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Humph. [CS:N]Dusknoir[CR]![K] [CS:N]Dialga[CR]'s\nnew henchman...", french="Pfff. [CS:N]Noctunoir[CR]![K] Le nouveau\nbras droit de [CS:N]Dialga[CR]...", german="Hmpf. [CS:N]Zwirrfinst[CR]![K]\nDer neue Gehilfe von [CS:N]Dialga[CR]...", italian="Bah... [CS:N]Dusknoir[CR]![K] Il nuovo\nservitore di [CS:N]Dialga[CR]...", spanish="Bah... ¡[CS:N]Dusknoir[CR]![K] La nueva\nmano derecha de [CS:N]Dialga[CR]..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Is just as crafty and\nwicked as you are!", french=" ... est aussi tordu que toi!", german="Er ist genauso clever und\nhinterhältig wie du!", italian="È subdolo e malvagio proprio\ncome te!", spanish="¡Ese tipo es tan maquiavélico\ny retorcido como tú!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I am Master [CS:N]Dialga[CR]'s\nonly henchman!", french="Je suis le seul et unique bras\ndroit de Maître [CS:N]Dialga[CR]!", german="Der einzig wahre Gehilfe von\nMeister [CS:N]Dialga[CR] bin ich!", italian="Io sono l'unico servitore\ndel Maestro [CS:N]Dialga[CR]!", spanish="¡Yo soy la única mano derecha\nde [CS:N]Dialga[CR]!"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I can't allow anyone to take\nmy place!", french="Je ne laisserai personne prendre\nma place!", german="Ich kann es nicht zulassen, dass\njemand meinen Platz einnimmt!", italian="Nessuno può prendere\nil mio posto!", spanish="¡No puedo permitir que nadie\nocupe mi lugar!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Here they come!", french=" Ils arrivent!", german=" Da kommen sie!", italian=" Eccoli che arrivano!", spanish=" ¡Aquí vienen!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(17) [anim idle native]
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
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- message_Close
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2)
  -- SetAnimation(12) [anim idle native]
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2)
  -- SetAnimation(12) [anim idle native]
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2)
  -- SetAnimation(12) [anim idle native]
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(140, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
