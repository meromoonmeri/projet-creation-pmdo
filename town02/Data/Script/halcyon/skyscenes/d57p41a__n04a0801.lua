-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D57P41A/n04a0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=43, sub=3} -- $SCENARIO_SIDE = scn[43,3] (ROM)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(159, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D57P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_goosuto = SkySceneKit.spawn_npc("haunter", 232, 192, Direction.Down, "NPC_GOOSUTO")
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(1) [anim idle native]
  -- bgm2_PlayFadeIn(BGM_HEAVY_WIND2) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 228, 228, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" .........", french=" .........", german=" ..........", italian=" ..........", spanish=" ..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I've come quite far...[K] Now\nwhere's [CS:N]Haunter[CR]?", french="J'ai bien progressé...[K]\nEt maintenant, il est où ce [CS:N]Spectrum[CR]?", german="Ich bin ein gutes Stück weit\ngekommen...[K] Wo steckt dieser [CS:N]Alpollo[CR] nur?", italian="Ho fatto parecchia strada...[K]\nDove sarà [CS:N]Haunter[CR]?", spanish="He avanzado bastante...[K] Bueno,\n¿dónde está [CS:N]Haunter[CR]?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Did he flee deeper into\nthe cave?", french="Il se serait enfui plus loin\ndans la grotte?", german="Ist er noch tiefer in\ndie Höhle geflohen?", italian="Che sia fuggito in un punto\npiù profondo della grotta?", spanish="¿Se habrá adentrado más\nen la cueva?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Hey![K] You!", french=" Hé![K] Toi!", german=" Hey![K] Du!", italian=" Ehi![K] Tu!", spanish=" ¡Eh![K] ¡Tú!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" You! What did you just say?!", french=" Oui, toi! Qu'est-ce que tu as dit?!", german=" Du! Was hast du da gerade gesagt?!?", italian=" Sì, tu! Che cosa hai appena detto?!", spanish=" ¡Oye! ¡¿Qué es lo que acabas de decir?!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Don't tell me...[K] You're looking for me?!", french=" Ne me dis pas...[K] que tu me cherches, moi?!", german=" Sag bloß...[K] Du suchst mich?!?", italian=" ...[K] Stai cercando me, per caso?!", spanish=" No me digas...[K] ¡¿que me estás buscando?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  pcall(function() SOUND:PlayBGM("Growing Anxiety.ogg", true) end)
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Wh-who is that?![K] I can hear\nyou, but I can't see you...", french="Qui... qui est là?![K] Je t'entends\nmais je ne te vois pas...", german="W-wer ist das?!?[K] Ich höre\ndich, aber ich kann dich nicht sehen...", italian="C-Chi sei?![K] Sento la tua voce,\nma non riesco a vederti...", spanish="¡¿Quién... anda ahí?![K] Te oigo,\npero no te veo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Heh heh heh![K] You can't see me?", french=" Hé hé hé![K] Tu ne me vois pas?", german=" Hehehe![K] Du siehst mich nicht?", italian=" Eh eh eh![K] Non riesci a vedermi?", spanish=" ¡Je, je, je![K] ¿No me ves?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" If that's the case, then I'll show myself!", french=" Dans ce cas, je vais me montrer!", german=" Wenn das so ist, werde ich mich zeigen!", italian=" Beh, se è così allora... Oplà!", spanish=" Siendo así, me mostraré."})
  -- message_Close
  -- GAP: se_Play(9986) — id SE NDS sans portage PMDO identifié
  -- SetOutputAttribute(64) [neutre/état moteur]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  GAME:WaitFrames(60) -- back_SetEffect(11, 60) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  GAME:WaitFrames(2) -- WaitBackEffect (join)
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(16), 6, false) end) -- MovePositionOffset performer/caméra
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Oh my gosh![K]\nY-you surprised me!", french="Ben mince alors![K]\nT-tu m'as fichu la frousse!", german="Auweia![K]\nD-du hast mich erschreckt!", italian="Shock![K]\nM-Mi hai spaventata!", spanish=" ¡Aaayyy![K] ¡Jo, qué susto me has dado!"})
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_goosuto, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" Gah ha ha ha ha ha ha![K] I'm [CS:N]Haunter[CR]!", french=" Ouah ha ha ha ha ha ha![K] Je suis [CS:N]Spectrum[CR]!", german=" Gahahahahahaha![K] Ich bin [CS:N]Alpollo[CR]!", italian=" Gah ah ah ah ah ah ah![K] Io sono [CS:N]Haunter[CR]!", spanish=" ¡Jua, ja, ja, ja, ja, ja, ja![K] Soy [CS:N]Haunter[CR]."})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_goosuto, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="If you're looking for me...[K] Then\nyou must be an explorer!", french="Si tu es à ma recherche...[K] alors,\ntu dois être exploratrice!", german="Wenn du nach mir suchst...[K]\nDann musst du ein Erkunder sein!", italian="Se mi stavi cercando...[K] allora\nsignifica che tu sei un'esploratrice!", spanish="Si me andas buscando...[K] será\nque eres una exploradora."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Th-that's right!", french=" T-tout juste!", german=" G-ganz genau!", italian=" E-Esatto!", spanish=" E... eso mismo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="My name is [CS:Y]Sunflora[CR]![K]\nI've come to apprehend you!", french="Je m'appelle [CS:Y]Héliatronc[CR]![K]\nJe suis venue t'arrêter!", german="Mein Name ist [CS:Y]Sonnflora[CR]![K]\nIch bin gekommen, um dich festzunehmen!", italian="Il mio nome è [CS:Y]Sunflora[CR]![K]\nSono qui per catturarti!", spanish="Me llamo [CS:Y]Sunflora[CR].[K]\n¡He venido a capturarte!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" Apprehend?", french=" M'arrêter?", german=" Mich festnehmen?", italian=" Catturarmi?", spanish=" ¿A capturarme, dices?"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_goosuto, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="GAH HA HA HA HA HA![K]\nGAH HA HA HA HA HA HA HA HA!!", french="OUAH HA HA HA HA HA HA![K]\nOUAH HA HA HA HA HA HA HA HA!!", german="GAHAHAHAHAHAHAHAHA![K]\nGAHAHAHAHAHAHAHAHAHAHAHAHA!!!", italian="GAH AH AH AH AH AH AH AH AH![K]\nGAH AH AH AH AH AH AH AH AH AH AH AH!!!", spanish="¡Jua, ja, ja, ja, ja, ja![K]\n¡¡Juaaa, ja, ja, ja, ja, ja, ja, ja!!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_goosuto, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" You're funny!", french=" Tu es une comique, toi!", german=" Das hört sich ja interessant an!", italian=" Che spasso!", spanish=" ¡Eres la monda!"})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" Hey, [CS:Y]Sunflora[CR]!", french=" Hé, [CS:Y]Héliatronc[CR]!", german=" Hey, [CS:Y]Sonnflora[CR]!", italian=" Ehi, [CS:Y]Sunflora[CR]!", spanish=" Dime, [CS:Y]Sunflora[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="Why do you think an outlaw like\nme appeared in front of you?", french="A ton avis, pourquoi un\nhors-la-loi comme moi peut se trouver\ndevant toi en ce moment?", german="Warum glaubst du, taucht ein\nGanove wie ich genau vor deiner Nase auf?", italian="Secondo te perché un ricercato\ncome me ha deciso di uscire allo scoperto?", spanish="¿Por qué crees que un malhechor\ncomo yo iba a aparecer ante ti?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" .........!!", french=" .........!!", german=" ..........", italian=" ..........!!!", spanish=" Esto... ¿Para saludarme?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="That's because...[K] I've never been\ncaught yet!", french="C'est parce que...[K] personne ne\npeut m'attraper!", german="Vielleicht...[K] weil ich noch nicht\ngefangen worden bin!", italian="Perché...[K] non sono mai stato\ncatturato!", spanish="Te lo diré...[K] ¡Porque nunca\nhan conseguido atraparme!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="All the explorers who have tried\nto catch me...", french="Tous les explorateurs qui ont\ntenté de le faire...", german="Alle Erkunder, die es je probiert\nhaben...", italian="Tutti gli esploratori che ci hanno\nprovato...", spanish="Todos los exploradores que han\nintentado capturarme..."})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="Have become discouraged...[K] Lost\ntheir confidence...", french="... ont fini par perdre courage...[K]\net perdre confiance...", german="Sie haben aufgegeben...[K]\n...Und ihr Selbstvertrauen verloren...", italian="Hanno perso il loro coraggio...[K]\nla fiducia in se stessi...", spanish="Se han dado por vencidos...[K] Han\nperdido la confianza en sí mismos..."})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="That kind of disappointment...[K]\nI'll be happy to show you how it feels...", french="Le genre de sentiment de\ndésespoir...[K] que je me ferai un plaisir\nde te faire ressentir...", german="Diese Form der Enttäuschung...[K]\nIch erteile dir gerne eine Lektion, wie sich das\nso anfühlt...", italian="E se anche tu vuoi assaporare\nquesta sensazione...[K] sarò ben felice\ndi aiutarti...", spanish="Si no sabes lo que es perder así\nla confianza...[K] estaré encantado\nde enseñártelo."})
  -- message_Close
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
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" Let's go!", french=" En garde!", german=" Nur zu!", italian=" Fatti sotto!", spanish=" ¡Vamos allá!"})
  -- message_Close
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(159, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
