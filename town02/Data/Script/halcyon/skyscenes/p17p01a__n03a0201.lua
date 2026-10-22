-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P17P01A/n03a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  SV.SkyScenarioSide = {main=42, sub=1} -- $SCENARIO_SIDE = scn[42,1] (ROM)
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
  local npc_npc_subomii = SkySceneKit.spawn_npc("budew", 320, 128, Direction.Left, "NPC_SUBOMII")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_upaa = SkySceneKit.spawn_npc("wooper", 304, 152, Direction.Left, "NPC_UPAA")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_muchuuru = SkySceneKit.spawn_npc("smoochum", 336, 152, Direction.Left, "NPC_MUCHUURU")
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(npc_npc_upaa, 196, 148, false, 2)
  GROUND:MoveToPosition(npc_npc_subomii, 212, 128, false, 2)
  GROUND:MoveToPosition(npc_npc_muchuuru, 228, 152, false, 2)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P17P01A1_397) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P17P01A1_397) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(15)
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(24), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(9730) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P17P01A1_397) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_subomii, "exclaim", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_upaa, "exclaim", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_muchuuru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_subomii) end)
  SkySceneKit.say({english=" Oh! [CS:Y]Igglybuff[CR]!", french=" Oh! [CS:Y]Toudoudou[CR]!", german=" Oh! [CS:Y]Fluffeluff[CR]!", italian=" Oh! [CS:Y]Igglybuff[CR]!", spanish=" ¡Eh, [CS:Y]Igglybuff[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english="[CS:Y]Igglybuff[CR], I heard that you\nwent out exploring with the bullies...", french="[CS:Y]Toudoudou[CR], paraît que tu es\nparti en exploration avec la bande de brutes...", german="[CS:Y]Fluffeluff[CR], ich habe gehört, dass\ndu mit den Schlitzohren auf Erkundung warst...", italian="Ho sentito che hai fatto\nun'esplorazione con quei prepotenti...", spanish="[CS:Y]Igglybuff[CR], he oído que te fuiste\na explorar con esos abusones..."})
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english=" Was it all right?", french=" Ça s'est bien passé?", german=" Wie war es?", italian=" È andato tutto bene?", spanish=" ¿Fue todo bien?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yeah. ♪ I was fine. ♪", french="Voui, voui. ♪ Tout s'est\nbien passé. ♪", german=" Ja. ♪ Es war schön. ♪", italian=" Sì. ♪ Benissimo. ♪", spanish=" Sí. ♪ Todo bien. ♪"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Everyone went home in the\nmiddle of it. ♪", french="Tout le monde est retourné à la\nmaison à mi-chemin. ♪", german="Alle sind mittendrin nach\nHause gegangen. ♪", italian="Ma gli altri sono tornati a casa\nproprio sul più bello. ♪", spanish="Todos se fueron a casa antes\nde que acabáramos. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_upaa, Direction.UpRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_subomii, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  GROUND:EntTurn(npc_npc_upaa, Direction.Left)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_subomii, Direction.Left)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english=" Smooches! That's good!", french=" Smack! Ça, c'est bien!", german=" Knutsch! Gut so!", italian=" Smooches! Sono contenta!", spanish=" ¡Eso está bien, sí, sí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_subomii) end)
  SkySceneKit.say({english=" We were worried about you.", french=" On s'est fait du mouron pour toi.", german="Wir haben uns Sorgen\num dich gemacht.", italian=" Eravamo così preoccupati per te.", spanish=" Estábamos preocupados por ti."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_upaa) end)
  SkySceneKit.say({english="Hey, [CS:Y]Igglybuff[CR]![K]\nLet's play together today. ♪", french="Hé, [CS:Y]Toudoudou[CR]![K]\nOn joue ensemble aujourd'hui? ♪", german="Hey, [CS:Y]Fluffeluff[CR]![K]\nLass uns heute zusammen spielen. ♪", italian="Ehi, [CS:Y]Igglybuff[CR]![K]\nGiochiamo insieme oggi. ♪", spanish="¡Oye, [CS:Y]Igglybuff[CR]![K]\nVamos a jugar todos juntos. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Hmm...[K] Sorry.[K] I've already\ngot plans for today.", french="Mmh...[K] Désolé.[K] J'ai déjà quelque\nchose de prévu.", german="Hmm...[K] Tut mir leid.[K]\nIch habe heute bereits etwas vor.", italian="Mmmh...[K] Mi dispiace.[K] Ho già\nun impegno.", spanish="Hum...[K] No puedo.[K] Es que hoy ya\ntengo planes, lo siento."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_subomii, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_subomii) end)
  SkySceneKit.say({english=" Plans? Where are you going?", french="Quelque chose de prévu?\nOù tu vas?", german="Du hast etwas vor? Wohin willst\ndu denn?", italian=" Un impegno? E dove vai?", spanish=" ¿Que tienes planes? ¿Adónde vas?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:P]Murky Forest[CR]. ♪", french=" Dans la [CS:P]Forêt Glauque[CR]. ♪", german=" In den [CS:P]Trübwald[CR]. ♪", italian=" Nella [CS:P]Foresta Tenebrosa[CR]. ♪", spanish=" Al [CS:P]Bosque Oscuro[CR]. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_upaa, "shock", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_subomii, "exclaim", 1) end)
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english=" Whaaat?![K] [CS:P]Murky Forest[CR]?!", french=" Quoiiii?![K] La [CS:P]Forêt Glauque[CR]?!", german=" Waaas?!?[K] In den [CS:P]Trübwald[CR]?!?", italian=" Cooosa?![K] La [CS:P]Foresta Tenebrosa[CR]?!", spanish=" ¡¿Quéee?![K] ¿Al [CS:P]Bosque Oscuro[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yup. ♪[K] See you later! ♪", french=" Ben oui. ♪[K] A plus! ♪", german=" Genau. ♪[K] Bis später! ♪", italian=" Già. ♪[K] Ci vediamo! ♪", spanish=" Sí. ♪[K] ¡Hasta luego! ♪"})
  -- message_Close
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(180), p.Y+(0), false, 2) end
  GAME:WaitFrames(20)
  GROUND:EntTurn(npc_npc_upaa, Direction.Right)
  GAME:WaitFrames(8)
  GROUND:EntTurn(npc_npc_subomii, Direction.Right)
  GAME:WaitFrames(8)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
