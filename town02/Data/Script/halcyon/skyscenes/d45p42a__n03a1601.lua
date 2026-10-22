-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D45P42A/n03a1601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(132, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  local npc_npc_aamarudo = SkySceneKit.spawn_npc("armaldo", 272, 232, Direction.Down, "NPC_AAMARUDO")
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="When we came here before, it\nseemed like this was the deepest point of the\ncave, but...", french="Quand on est arrivés ici,\non pensait que c'était le point le plus\nprofond de la caverne, mais...", german="Als wir hier vorhin ankamen,\nsah es aus, als sei dies der tiefste Punkt\ndes Dungeons...", italian="Quando prima siamo arrivati qui,\neravamo convinti che questo fosse il punto\npiù profondo della grotta, ma...", spanish="Cuando estuvimos aquí antes,\neste parecía ser el lugar más profundo\nde la cueva, pero..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="It's so dark, I can't see\na thing. ♪", french="C'est tout sombre ici,\nj'y vois rien. ♪", german="Es ist so dunkel, dass ich gar\nnichts erkennen kann. ♪", italian="È così buio che non riesco\na vedere a un palmo dal naso. ♪", spanish="Está oscurísimo, no veo\nnada. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Be careful!", french=" Sois prudent!", german=" Sei vorsichtig!", italian=" Fai attenzione!", spanish=" ¡Ten cuidado!"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="This time, let's be careful not to\nfall into the pit agai--", french="Cette fois, avançons\nprudemment pour ne plus tomber dans ce trou\nenco...", german="Lass uns diesmal aufpassen,\nnicht erneut in die Gru--", italian="Questa volta non dobbiamo\nfinire di nuovo nella fos...", spanish="Esta vez hay que tener cuidado\nde no volver a caer en la si..."})
  -- GAP: se_Play(9732) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  GAME:WaitFrames(30)
  -- GAP: se_Play(7170) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" UWAAAAAaaaaaaahhhhhh!", french=" Yaaaaaaaaaaaaaaaaaaah!", german=" UWAAAAAaaaaaaah!", italian=" UAAAAAAaaaaaaaaahhhhhh!", spanish=" ¡Uaaaaaaaaaaaaaaaaaah!"})
  GAME:WaitFrames(2) -- join WaitSe
  GAME:WaitFrames(30)
  -- message_CloseEnforce
  -- GAP: se_Play(7939) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Ow ow ow ow ow...[K] Oh, my\naching back...", french="Ouille ouille ouille ouille...[K]\nOh, mon pauvre dos...", german="Auauauauauauau...[K] Oh, mein\nschmerzender Rücken...", italian="Ohi ohi ohi ohi...[K] Oh,\nla mia povera schiena...", spanish="Ay, ay, ay, ay, ay...[K] Mi espalda,\nqué pupita..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(9474) — id SE NDS sans portage PMDO identifié
  SkySceneKit.say({english="[CS:N]???[CR]: GARURURURURURURURURURURU...", french="[CS:N]???[CR]: GROAOUROUROUROUROUROUROUUUUH...", german="[CS:N]???[CR]: GARURURURURURURURURURURU...", italian="[CS:N]???[CR]: GRRRRRRRRRRRROOOARRRRRRRRR...", spanish="[CS:N](?)[CR]: Grooooooooooooaaaaar..."}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  -- GAP: se_Play(9738) — id SE NDS sans portage PMDO identifié
  SkySceneKit.say({english="[CN]\n[CN]ZAZA... ZAZA...", french="[CN]\n[CN]GZZZ... GZZZ...", german="[CN]\n[CN]ZAZA... ZAZA...", italian="[CN]\n[CN]ZAZA... ZAZA...", spanish="[CN]\n[CN]Zaza... Zaza..."}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  GAME:WaitFrames(20)
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  SkySceneKit.say({english="[CS:N]???[CR]: GWWWOOOOOOAAAaaaaaAAAAAHHHH!!!", french="[CS:N]???[CR]: GRRRRRROUAAAAAAAAAAAAAAAOUH!!!", german="[CS:N]???[CR]: GWWWOOOOOOAAAaaaaaAAAAAH!!!", italian="[CS:N]???[CR]: GRRROOOOOOAAAaaaaaAAAAAHHHH!!!", spanish="[CS:N](?)[CR]: ¡¡¡Groooaaa!!!"}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(45)
  GAME:FadeOut(true, 30) -- screen_WhiteOutAll
  -- message_CloseEnforce
  GAME:WaitFrames(30)
  -- back_SetGround(LEVEL_D45P42A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(15)
  GAME:FadeIn(15)
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_aamarudo.Position; GROUND:MoveToPosition(npc_npc_aamarudo, p.X+(-4), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_aamarudo, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Hey, Master.", french=" Hé, Maître.", german=" Oh, Meister.", italian=" Ehi, maestro.", spanish=" Oye, maestro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Wh-what is it? Can it wait?!", french="Quoi, qu'est-ce qu'il y a? Ça ne\npeut pas attendre?!", german="W-was ist denn?\nKann das nicht warten?!?", italian=" C-Che c'è? Di cos'hai bisogno?!", spanish="¿Qué... Qué pasa?\n¡¿No puede esperar?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" We fell in the pit again...", french="On est de nouveau tombés\ndans ce trou...", german="Wir sind schon wieder\nin die Grube gefallen...", italian="Siamo di nuovo caduti\nnella fossa...", spanish=" Hemos vuelto a caer en la sima..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="It seems you really like pits,\nMaster.", french="Vous avez vraiment l'air d'aimer\ntomber dans les trous, Maître.", german="Du scheinst Gruben wirklich\nzu mögen, Meister.", italian="Sembra che ti piacciano molto\nle buche, maestro.", spanish="Parece que te encantan\nlas simas, maestro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_aamarudo, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "angry", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="I...[K] No, they really bring\nme down!", french="Je...[K] Pas vraiment, je n'aime\npas trop être au fond du trou!", german="Ich...[K] Nein, die machen mich\nwirklich fertig!", italian="Io...[K] No, a dire il vero mi\nbuttano molto giù!", spanish="Qué...[K] ¡Qué va, pero si me\ndeprimen un montón!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, nil, 0) end) -- EFFECT_NONE
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Anyway, eyes front![K]\nHere they come!", french="Peu importe, ouvre l'œil![K]\nLes voilà!", german="Wie dem auch sei, aufgepasst![K]\nDa sind sie auch schon!", italian="Occhi aperti, adesso![K]\nStanno arrivando!", spanish="En fin, mira al frente.[K]\n¡Aquí llegan!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" We'll get through this time! ♪", french=" On va y arriver, cette fois! ♪", german=" Diesmal kommen wir durch! ♪", italian=" Questa volta ce la faremo! ♪", spanish=" ¡Esta vez lo conseguiremos! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" That's what I expected!", french="C'est bien à ça que je\nm'attendais!", german=" Das habe ich erwartet!", italian=" Così mi piaci!", spanish=" ¡Eso es lo que esperaba oír!"})
  -- message_Close
  pcall(function() SOUND:StopBGM() end)
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
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(132, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
