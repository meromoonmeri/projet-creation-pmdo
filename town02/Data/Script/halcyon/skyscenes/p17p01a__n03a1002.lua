-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P17P01A/n03a1002.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Heartwarming.ogg", true) end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_P17P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- supervision_Acting(1) [neutre/état moteur]
  -- GAP: se_Play(9729) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P17P01A1_397) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P17P01A1_397) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(20)
  -- supervision_Acting(2) [neutre/état moteur]
  local npc_npc_pukurin_mama = SkySceneKit.spawn_npc("wigglytuff", 160, 120, Direction.Down, "NPC_PUKURIN_MAMA")
  -- SetAnimation(2) [anim idle native]
  do local p=npc_npc_pukurin_mama.Position; GROUND:MoveToPosition(npc_npc_pukurin_mama, p.X+(0), p.Y+(10), false, 2) end
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  local npc_npc_subomii = SkySceneKit.spawn_npc("budew", 160, 184, Direction.Up, "NPC_SUBOMII")
  pcall(function() GROUND:CharSetEmote(npc_npc_subomii, "exclaim", 1) end)
  GAME:WaitFrames(4)
  local npc_npc_muchuuru = SkySceneKit.spawn_npc("smoochum", 184, 168, Direction.UpLeft, "NPC_MUCHUURU")
  pcall(function() GROUND:CharSetEmote(npc_npc_muchuuru, "exclaim", 1) end)
  GAME:WaitFrames(4)
  local npc_npc_upaa = SkySceneKit.spawn_npc("wooper", 136, 168, Direction.UpRight, "NPC_UPAA")
  pcall(function() GROUND:CharSetEmote(npc_npc_upaa, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_subomii) end)
  SkySceneKit.say({english=" Oh![K] It's [CS:Y]Igglybuff[CR]'s [CS:N]Mama[CR]!", french=" Oh![K] La [CS:N]Maman[CR] de [CS:Y]Toudoudou[CR]!", german=" Oh![K] Die [CS:N]Mama[CR] von [CS:Y]Fluffeluff[CR]!", italian=" Oh![K] È la [CS:N]mamma[CR] di [CS:Y]Igglybuff[CR]!", spanish=" ¡Anda![K] ¡Es la [CS:N]mamá[CR] de [CS:Y]Igglybuff[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_pukurin_mama, 140, 144, false, 2)
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.Down)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english="I'm sorry.[K] [CS:Y]Igglybuff[CR] isn't here\ntoday, either.", french="Désolée, les enfants.[K] [CS:Y]Toudoudou[CR]\nn'est pas à la maison aujourd'hui non plus.", german="Es tut mir leid.[K] [CS:Y]Fluffeluff[CR] ist\nheute wieder nicht da.", italian="Mi spiace.[K] [CS:Y]Igglybuff[CR] non c'è\nnemmeno oggi.", spanish=" Lo siento...[K] [CS:Y]Igglybuff[CR] tampoco está hoy."})
  -- supervision_Acting(3) [neutre/état moteur]
  local npc_npc_pukurin_papa = SkySceneKit.spawn_npc("wigglytuff", 160, 120, Direction.Down, "NPC_PUKURIN_PAPA")
  -- SetAnimation(2) [anim idle native]
  do local p=npc_npc_pukurin_papa.Position; GROUND:MoveToPosition(npc_npc_pukurin_papa, p.X+(0), p.Y+(8), false, 2) end -- Move2PositionOffset
  GROUND:MoveToPosition(npc_npc_pukurin_papa, 176, 136, false, 2)
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.Down)
  -- GAP: se_Play(9730) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P17P01A1_397) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english="You're always inviting him to\njoin you. It's not very nice of him to\nalways be too busy.", french="Vous l'invitez toujours à venir\njouer avec vous, ce n'est pas très gentil de\nsa part de toujours s'affairer ailleurs.", german="Ihr ladet ihn immer ein, mit euch\nzu spielen. Es ist nicht sehr nett von ihm, dass\ner dafür immer zu beschäftigt ist.", italian="Siete così gentili a venire qui\nper invitarlo a giocare con voi. Non è\ncarino da parte sua andare sempre via.", spanish="Siempre lo invitáis a jugar. No es\nmuy considerado por su parte estar siempre\ntan ocupado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.UpLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_upaa, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english=" By the way, [CS:Y]Igglybuff[CR]'s [CS:N]Mama[CR].", french=" Au fait, madame...", german="Übrigens, [CS:N]Mama[CR] von\n[CS:Y]Fluffeluff[CR]...", italian="A proposito, [CS:N]mamma[CR] di\n[CS:Y]Igglybuff[CR]!", spanish=" Por cierto, [CS:N]mamá[CR] de [CS:Y]Igglybuff[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.DownRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_upaa, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_subomii, Direction.UpRight)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" What is it, [CS:N]Smoochum[CR]?", french=" Qu'y a-t-il, [CS:N]Lippouti[CR]?", german=" Worum geht es, [CS:N]Kussilla[CR]?", italian=" Dimmi, [CS:N]Smoochum[CR]...", spanish=" Dime, [CS:N]Smoochum[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english="Is it true that [CS:Y]Igglybuff[CR] goes to\nplay in [CS:P]Murky Forest[CR] every day?", french="C'est vrai que [CS:Y]Toudoudou[CR] va\njouer dans la [CS:P]Forêt Glauque[CR] tous les jours?", german="Stimmt es, dass [CS:Y]Fluffeluff[CR] jeden\nTag in den [CS:P]Trübwald[CR] geht, um dort zu spielen?", italian="È vero che [CS:Y]Igglybuff[CR] va\na giocare nella [CS:P]Foresta Tenebrosa[CR]\nogni giorno?", spanish="¿Es cierto que [CS:Y]Igglybuff[CR] va cada\ndía a jugar al [CS:P]Bosque Oscuro[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_mama, "exclaim", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_papa, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" Whaaaat?![K] In [CS:P]Murky Forest[CR]?!", french=" Quoiiii?![K] Dans la [CS:P]Forêt Glauque[CR]?!", german=" Waaaas?!?[K] In den [CS:P]Trübwald[CR]?!?", italian="Cooosaaa?![K] La [CS:P]Foresta[CR]\n[CS:P]Tenebrosa[CR]?!", spanish=" ¡¿Quéee?![K] ¡¿Al [CS:P]Bosque Oscuro[CR], dices?!"})
  -- message_KeyWait
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_mama, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" I-is that true, [CS:N]Smoochum[CR]?", french=" Tu es sûre, [CS:N]Lippouti[CR]?", german=" I-ist das wahr, [CS:N]Kussilla[CR]?", italian=" È-È vero, [CS:N]Smoochum[CR]?", spanish=" ¿Es... Es eso cierto, [CS:N]Smoochum[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Growing Anxiety.ogg", true) end)
  GROUND:EntTurn(npc_npc_upaa, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_subomii, Direction.UpRight)
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english="We don't really know...[K] But\nthat's what we heard.", french="On ne sait pas trop...[K]\nMais c'est ce qu'on a entendu.", german="Wir wissen es nicht genau...[K]\nAber das ist das, was wir gehört haben.", italian="Non lo sappiamo con certezza...[K]\nMa è quello che abbiamo sentito.", spanish="Pues no lo sabemos...[K] Pero eso\nhemos oído."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_muchuuru, Direction.DownLeft)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_subomii, Direction.Up)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_upaa, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_upaa) end)
  SkySceneKit.say({english="It looks like his [CS:N]Mama[CR] doesn't\nknow, either.", french="On dirait que vous ne savez\npas non plus...", german="Anscheinend weiß es seine\n[CS:N]Mama[CR] aber auch nicht.", italian="Sembra che nemmeno la sua\n[CS:N]mamma[CR] lo sappia.", spanish="Parece que su [CS:N]mamá[CR] tampoco\nlo sabe."})
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.DownLeft)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_subomii) end)
  SkySceneKit.say({english=" If it's true...", french=" Si c'est vrai...", german=" Wenn es stimmt...", italian=" Se è così...", spanish=" Si es cierto..."})
  pcall(function() UI:SetSpeaker(npc_npc_subomii) end)
  SkySceneKit.say({english="I wonder if [CS:Y]Igglybuff[CR]'s OK...[K]\nGoing to that place to play all the time...", french="Je me demande si [CS:Y]Toudoudou[CR]\nva bien...[K] Aller jouer dans cet endroit\ntout le temps...", german="Hoffentlich geht es [CS:Y]Fluffeluff[CR]\ngut...[K] Immer an einem solchen Ort zu spielen...", italian="Mi chiedo se [CS:Y]Igglybuff[CR] stia\nbene...[K] Andare sempre in quel postaccio\na giocare...", spanish="Me pregunto si [CS:Y]Igglybuff[CR] estará\nbien...[K] ¡No es normal que juegue en un sitio así!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  -- supervision_Acting(4) [neutre/état moteur]
  local npc_npc_jupetta = SkySceneKit.spawn_npc("banette", 312, 152, Direction.Down, "NPC_JUPETTA")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_sukorupi = SkySceneKit.spawn_npc("skorupi", 336, 168, Direction.Down, "NPC_SUKORUPI")
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_upaa, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_upaa) end)
  SkySceneKit.say({english=" Hey, [CS:N]Banette[CR]!", french=" Hé, [CS:N]Branette[CR]!", german=" Hey, [CS:N]Banette[CR]!", italian=" Ehi, [CS:N]Banette[CR]!", spanish=" ¡Hola, [CS:N]Banette[CR]!"})
  GAME:WaitFrames(8)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_subomii, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.Right)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_jupetta, 208, 152, false, 2)
  GAME:WaitFrames(7)
  GROUND:MoveToPosition(npc_npc_sukorupi, 236, 168, false, 2)
  GAME:WaitFrames(5)
  pcall(function() GAME:MoveCamera(180, 164, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_muchuuru, Direction.UpRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_upaa, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_subomii, Direction.UpRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english="Hey, [CS:N]Banette[CR].[K] Have you seen\n[CS:Y]Igglybuff[CR]?", french="Hé, [CS:N]Branette[CR].[K] Tu as vu\n[CS:Y]Toudoudou[CR]?", german="Hey, [CS:N]Banette[CR].[K]\nHast du [CS:Y]Fluffeluff[CR] gesehen?", italian="[CS:N]Banette[CR].[K] Hai visto\n[CS:Y]Igglybuff[CR]?", spanish="Eh, [CS:N]Banette[CR].[K] ¿Has visto a\n[CS:Y]Igglybuff[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_jupetta, Direction.DownLeft)
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" [CS:Y]Igglybuff[CR]?", french=" [CS:Y]Toudoudou[CR]?", german=" [CS:Y]Fluffeluff[CR]?", italian=" [CS:Y]Igglybuff[CR]?", spanish=" ¿A [CS:Y]Igglybuff[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="Oh. Isn't [CS:Y]Igglybuff[CR] still going to\n[CS:P]Murky Forest[CR]?", french="Oh, [CS:Y]Toudoudou[CR]. Il est à la\n[CS:P]Forêt Glauque[CR] comme d'hab, non?", german="Ach. Geht [CS:Y]Fluffeluff[CR] nicht\nweiter täglich in den [CS:P]Trübwald[CR]?", italian="Oh. Ma [CS:Y]Igglybuff[CR] non continua\nad andare nella [CS:P]Foresta Tenebrosa[CR]?", spanish="Ah, pero si [CS:Y]Igglybuff[CR] sigue yendo\nal [CS:P]Bosque Oscuro[CR], ¿no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_papa, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_upaa, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_subomii, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: WHAAAAAAAAT?!", french="[CS:N]Tous[CR]: QUOIIIIIII?!", german="[CS:N]Alle[CR]: Waaaaaas?!?", italian="[CS:N]Tutti[CR]: COOOSAAAAAA?!", spanish="[CS:N]Todos[CR]: ¡¿Quéeeeee?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_jupetta, Direction.DownRight)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.UpLeft)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_upaa, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_subomii, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english="We've seen him go in there\nseveral times.", french="On l'a vu aller là-bas\nplusieurs fois.", german="Wir haben ihn dort dutzende\nMale hingehen sehen.", italian="Lo abbiamo visto entrare\nlì dentro un sacco di volte.", spanish=" Le hemos visto ir varias veces."})
  -- message_KeyWait
  GROUND:EntTurn(npc_npc_sukorupi, Direction.Left)
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english=" To be going to that scary place...", french="Aller dans un endroit\naussi effrayant...", german="Dass er immer wieder an einen\nsolch gruseligen Ort zurückkehrt...", italian="Andare in un posto così\nsinistro...", spanish=" ¿Cómo puede ir a un sitio así?"})
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english="Honestly, I don't really get him.\n[CS:Y]Igglybuff[CR], I mean.", french="Franchement, je le comprends\npas. [CS:Y]Toudoudou[CR], je veux dire.", german="Ganz im Ernst, ich versteh ihn\nnicht. Wundersamer [CS:Y]Fluffeluff[CR]...", italian="Sinceramente non lo capisco\naffatto. [CS:Y]Igglybuff[CR], intendo.", spanish="La verdad es que no lo entiendo.\nA [CS:Y]Igglybuff[CR], quiero decir."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_jupetta, Direction.DownLeft)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.UpRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_upaa, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_subomii, Direction.UpRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="Oh...[K] I just saw him\na little while ago...", french="Oh...[K] Je l'ai vu il y a\npas longtemps...", german="Wobei...[K] Ich habe ihn vor einer\nWeile gesehen...", italian=" Oh...[K] L'ho visto proprio poco fa...", spanish=" Ah...[K] Hace un rato vi a ese tipo..."})
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="That scary-looking guy deep in\nthe forest...[K] [CS:Y]Igglybuff[CR] seems to have made\nfriends with him or something?", french="Ce type à l'air affreux qui vit\nau cœur de la forêt...[K] On dirait que [CS:Y]Toudoudou[CR]\net lui sont devenus copains, non?", german="Dieser finster aussehende Typ\nda aus dem Wald...[K] [CS:Y]Fluffeluff[CR] hat sich\nwohl mit ihm angefreundet oder so...", italian="Quel tipo dall'aria terrificante\nche vive nelle profondità della foresta...[K] Pare\nche lui e [CS:Y]Igglybuff[CR] siano diventati amici...", spanish="Ese tan chungo que vive en el\ncorazón del bosque...[K] Parece que [CS:Y]Igglybuff[CR]\nse ha hecho amigo de él, ¿no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_mama, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_upaa, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_muchuuru, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: WHAAAAAAAAAAAAAAAAT?!", french="[CS:N]Tous[CR]: QUOIIIIIIIIIIIIIIIII?!", german="[CS:N]Alle[CR]: Waaaaaaaaaaaaaaaaaaaaaaaaaaas?!?", italian="[CS:N]Tutti[CR]: COOOOOOMEEEEEEEEEEEE?!", spanish="[CS:N]Todos[CR]: ¡¿Quéeeeeeee?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_jupetta, Direction.DownLeft)
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="I wonder if he's all right.[K]\nBeing with that scary guy, I mean.", french="Je me demande s'il va bien.[K]\nEn compagnie de ce drôle de type...", german="Hoffentlich geht es ihm gut.[K]\nIch meine, weil er sich immer mit diesem\ngruseligen Typen trifft.", italian="Chissà se sta bene...[K] Insomma,\nandarsene in giro con un tipo così losco.", spanish="Me pregunto si estará bien...[K]\nCon el tipo ese tan chungo, me refiero."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_pukurin_mama.Position; GROUND:MoveToPosition(npc_npc_pukurin_mama, p.X+(12), p.Y+(0), false, 2) end
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.UpRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_mama, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GROUND:EntTurn(npc_npc_upaa, Direction.UpRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.UpLeft)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_jupetta, Direction.Left)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_subomii, Direction.Up)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" [CS:N]P[CR]-[CS:N]Papa[CR]...[K][CS:N] Papa[CR]...", french=" [CS:N]P[CR]-[CS:N]Papa[CR]...[K][CS:N] Papa[CR]...", german=" [CS:N]P-papa[CR]...[K] [CS:N]Papa[CR]...", italian=" [CS:N]P-Papà[CR]...[K] [CS:N]Papà[CR]...", spanish=" Ca...[K] cariño..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(40)
  -- supervision_Acting(5) [neutre/état moteur]
  local npc_npc_nidokingu = SkySceneKit.spawn_npc("nidoking", 184, 296, Direction.Up, "NPC_NIDOKINGU")
  -- SetAnimation(2) [anim idle native]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" Can I talk to you for a moment?", french=" Je peux vous parler un moment?", german=" Darf ich euch für einen Moment stören?", italian=" Posso disturbarvi un attimo?", spanish=" ¿Puedo hablar con vosotros un momento?"})
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_papa, "exclaim", 1) end)
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.Down)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_muchuuru, "exclaim", 1) end)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.Down)
  GAME:WaitFrames(4)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.Down)
  GAME:WaitFrames(4)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GROUND:EntTurn(npc_npc_subomii, Direction.Down)
  GAME:WaitFrames(4)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GROUND:EntTurn(npc_npc_jupetta, Direction.Down)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_upaa, "exclaim", 1) end)
  GROUND:EntTurn(npc_npc_upaa, Direction.Down)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, "exclaim", 1) end)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.Down)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_nidokingu, 180, 204, false, 2)
  GAME:WaitFrames(20)
  pcall(function() GAME:MoveCamera(180, 196, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_nidokingu) end)
  SkySceneKit.say({english="Your conversation...[K] Can you tell me a bit\nmore about it, please?", french="Votre conversation...[K] Vous pouvez m'en\ndire un peu plus, s'il vous plaît?", german="Worüber ihr da redet...[K] Könntet ihr mir\netwas genauer berichten, worum es geht?", italian="Quello di cui stavate parlando...[K] Potreste\ndirmi cos'altro sapete, per favore?", spanish="No he podido evitar oír lo que estabais\ndiciendo...[K] ¿Podéis contarme más, por favor?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_nidokingu, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_nidokingu) end)
  SkySceneKit.say({english=" Hey, you.", french=" Hé, toi.", german=" Hey, du.", italian=" Ehi, tu.", spanish=" Dime, chaval."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GROUND:EntTurn(npc_npc_sukorupi, Direction.UpLeft)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.UpRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.DownRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_subomii, Direction.UpRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_upaa, Direction.Right)
  GAME:WaitFrames(20)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_jupetta, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" M-me?", french=" M-moi?", german=" I-ich?", italian=" I-Io?", spanish=" ¿Quién... yo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_nidokingu) end)
  SkySceneKit.say({english="The part where you said there's a\nscary-looking guy living deep in the forest...", french="Qu'est-ce que tu disais à propos de ce\ndrôle de type au cœur de la forêt...?", german="Du hast doch gerade gesagt, da würde ein\nfinster aussehender Typ im Wald leben...", italian="Hai detto di aver visto un tipo dall'aria\nterrificante che vive nelle profondità della\nforesta...", spanish="Has dicho que hay un tipo chungo\nque vive en el corazón del bosque..."})
  pcall(function() UI:SetSpeaker(npc_npc_nidokingu) end)
  SkySceneKit.say({english=" What's he look like?", french=" A quoi ressemble-t-il?", german=" Wie sieht er denn aus?", italian=" Che aspetto ha?", spanish=" ¿Qué aspecto tiene?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_jupetta, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" H-he looks like...", french=" Il... il ressemble à...", german=" E-er... Er hat...", italian=" S-Sembra un...", spanish=" Pues... su aspecto..."})
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="He's got big claws...[K]and a shell\nthat looks like armor...", french="Il a de grandes griffes...[K] et une\ncarapace, on dirait une armure...", german="Er hat große Greifer...[K]\nUnd eine Schale wie ein harter Panzer...", italian="Ha dei grossi artigli...[K]\nE un guscio che sembra un'armatura...", spanish="Tiene grandes garras...[K] y\nun caparazón que parece una armadura..."})
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="I don't know, but he just looks\nreally scary, you know?", french=" Il fiche la trouille.", german="Ich weiß auch nicht, aber er\nsieht einfach total furchterregend aus...", italian="Non so altro, ma a guardarlo\nmette una gran paura...", spanish="No sé decir bien por qué, pero\ntiene una pinta que da mucho miedo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_nidokingu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_nidokingu) end)
  SkySceneKit.say({english=" ...[K]I'll bet it's him. It's gotta be.", french="...[K] Je parie que c'est lui.\nÇa ne peut être que lui.", german=" ...Ich wette, er ist es.[K] Er muss es sein.", italian="...[K] Scommetto che si tratta di lui.\nNe sono certo.", spanish=" Hum...[K] Seguro que es él. Tiene que serlo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_pukurin_papa.Position; GROUND:MoveToPosition(npc_npc_pukurin_papa, p.X+(0), p.Y+(8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.DownLeft)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_upaa, Direction.DownRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_jupetta, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_subomii, Direction.DownRight)
  -- message_FacePositionOffset(1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english=" Um...[K] Who are you?", french=" Heu...[K] qui êtes-vous?", german=" Ähm...[K] Und wer sind Sie?", italian=" Uhm...[K] Tu chi sei?", spanish=" Perdona,[K] ¿quién eres?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nidokingu, Direction.Up)
  pcall(function() UI:SetSpeaker(npc_npc_nidokingu) end)
  SkySceneKit.say({english=" My apologies for not introducing myself.", french="Toutes mes excuses, je ne me suis\npas présenté.", german="Entschuldigt, dass ich vergaß, mich\nvorzustellen.", italian=" Chiedo scusa per non essermi presentato.", spanish=" Ah, siento no haberme presentado antes."})
  pcall(function() UI:SetSpeaker(npc_npc_nidokingu) end)
  SkySceneKit.say({english=" I am [CS:N]Nidoking[CR].[K] I'm an explorer.", french=" Je m'appelle [CS:N]Nidoking[CR].[K] Je suis explorateur.", german=" Ich bin [CS:N]Nidoking[CR].[K] Ich bin ein Erkunder.", italian=" Mi chiamo [CS:N]Nidoking[CR].[K] Sono un esploratore.", spanish=" Soy [CS:N]Nidoking[CR].[K] Un explorador."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english=" An explorer?", french=" Explorateur?", german=" Ein Erkunder?", italian=" Un esploratore?", spanish=" ¿Un explorador?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_nidokingu) end)
  SkySceneKit.say({english=" Yes.", french=" Oui.", german=" Genau.", italian=" Sì.", spanish=" Eso es."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_nidokingu, Direction.UpLeft)
  GAME:WaitFrames(40)
  GROUND:EntTurn(npc_npc_nidokingu, Direction.UpRight)
  GAME:WaitFrames(40)
  GROUND:EntTurn(npc_npc_nidokingu, Direction.Up)
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_nidokingu) end)
  SkySceneKit.say({english="I should introduce\nmyself properly.", french="Je devrais me présenter\ncorrectement.", german="Ich sollte mich gebührend\nvorstellen.", italian="Forse è meglio se vi spiego tutto\ndall'inizio.", spanish=" Debería presentarme como es debido."})
  pcall(function() UI:SetSpeaker(npc_npc_nidokingu) end)
  SkySceneKit.say({english=" The truth is, I am...", french=" En vérité, je suis...", german=" In Wahrheit bin ich...", italian=" La verità è che io sono...", spanish=" En realidad, yo soy..."})
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(110)
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_subomii, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_mama, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_muchuuru, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_jupetta, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_nidokingu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: WHAAAAAAAAAAAAAAAAAT?!", french="[CS:N]Tous[CR]: QUOIIIIIIIIIIIIIIII?!", german="[CS:N]Alle[CR]: Waaaaaaaaaaas?!?", italian="[CS:N]Tutti[CR]: COOOSAAAAAAAAA?!", spanish="[CS:N]Todos[CR]: ¡¿Quéeeeeeeeeee?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_upaa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_upaa) end)
  SkySceneKit.say({english=" R-really?!", french=" V-vraiment?!", german=" W-wirklich?!?", italian=" S-Sul serio?!", spanish=" ¡¿De... De verdad?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english=" We... We've got a problem!!", french=" On... on a un problème!!", german=" Das riecht nach Ärger!!!", italian=" È... È un bel problema!!!", spanish=" Pues... ¡¡tenemos un problema!!"})
  -- message_Close
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 60)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
