-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D41P21A/s22p1202.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D41P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_D41P21A, 'US22') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() SOUND:PlayBGM("Deep Dark Crater.ogg", true) end)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(9) -- Unlock(9) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  -- Turn2Direction ACTOR_NPC_JUPUTORU [acteur sans placement SSA zone: orientation non jouée]
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh...[K] That was brutal...", french=" Argh...[K] Quelle horreur...", german=" Uff...[K] Das war brutal...", italian=" Ah...[K] Che batosta...", spanish=" Uf...[K] Ha sido brutal..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh...[K] That was the worst...", french=" Argh...[K] Quelle horreur...", german="Uff...[K] So schlimm war es noch\nnie...", italian=" Ah...[K] Che batosta...", spanish=" Uf...[K] Ha sido brutal..."})
  else
  SkySceneKit.say({english=" Ugh...[K] That was awful...", french=" Argh...[K] Quelle horreur...", german=" Uff...[K] Das war furchtbar...", italian=" Ah...[K] Che batosta...", spanish=" Uf...[K] Ha sido horrible..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_kureseria = SkySceneKit.spawn_npc("cresselia", 232, 168, Direction.Down, "NPC_KURESERIA")
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" It certainly was close.", french=" Nous l'avons échappé belle.", german=" Es war in der Tat knapp.", italian=" C'è mancato davvero poco.", spanish=" Le ha faltado poco."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_kureseria, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kureseria, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" But...[K]we have to go back.", french=" Mais...[K] nous devons y retourner.", german=" Aber[K] wir müssen zurückgehen!", italian="Ma...[K] Dobbiamo tornare\nindietro.", spanish=" Pero...[K] tenemos que volver allí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You're right.[K] We have to stop\n[CS:N]Darkrai[CR] soon.", french="Tu as raison.[K] Il faut arrêter\n[CS:N]Darkrai[CR] au plus vite.", german="Du hast recht.[K] Wir müssen\n[CS:N]Darkrai[CR] so schnell wie möglich aufhalten.", italian="Hai ragione.[K] Dobbiamo\naffrettarci a fermare [CS:N]Darkrai[CR].", spanish="Tienes razón.[K] Hay que detener a\n[CS:N]Darkrai[CR] cuanto antes."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You're right.[K] [CS:N]Darkrai[CR] has to be\nstopped.", french="Tu as raison.[K] Il faut arrêter\n[CS:N]Darkrai[CR] au plus vite.", german="Du hast recht.[K] [CS:N]Darkrai[CR] muss\nso schnell wie möglich aufgehalten werden.", italian="Hai ragione.[K] Dobbiamo fermare\n[CS:N]Darkrai[CR].", spanish="Tienes razón.[K] Hay que detener a\n[CS:N]Darkrai[CR] cuanto antes."})
  else
  SkySceneKit.say({english="You're right.[K] We have to stop\n[CS:N]Darkrai[CR] soon.", french="Tu as raison.[K] Il faut arrêter\n[CS:N]Darkrai[CR] au plus vite.", german="Du hast recht.[K] Wir müssen\n[CS:N]Darkrai[CR] so schnell wie möglich aufhalten.", italian="Hai ragione.[K] Dobbiamo\naffrettarci a fermare [CS:N]Darkrai[CR].", spanish="Tienes razón.[K] Hay que detener a\n[CS:N]Darkrai[CR] cuanto antes."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If we don't, the world will\nbe covered by darkness.", french="Si on ne fait rien, l'ombre\ns'abattra sur le monde entier.", german="Wenn wir das nicht tun, wird\ndie Welt von Dunkelheit umhüllt sein.", italian="Se non lo facciamo, il mondo\nverrà avvolto dall'oscurità.", spanish="Si no, el mundo quedará sumido\nen la oscuridad."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If we don't, he'll engulf the\nworld in darkness.", french="Si on ne fait rien, l'ombre\ns'abattra sur le monde entier.", german="Wenn wir das nicht tun, wird es\ndie Welt in Dunkelheit hüllen.", italian="Se non lo facciamo, il mondo\nverrà avvolto dall'oscurità.", spanish="Si no, el mundo quedará sumido\nen la oscuridad."})
  else
  SkySceneKit.say({english="If we don't, he'll enshroud the\nworld in darkness.", french="Si on ne fait rien, l'ombre\ns'abattra sur le monde entier.", german="Wenn wir das nicht tun, wird\ndie Welt von Dunkelheit umhüllt sein.", italian="Se non lo facciamo, il mondo\nverrà avvolto dall'oscurità.", spanish="Si no, el mundo quedará sumido\nen la oscuridad."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="OK, [hero] and [CS:N]Cresselia[CR]!\nLet's go![K] Back to [CS:N]Darkrai[CR]!", french="D'accord, [hero]\net [CS:N]Cresselia[CR]! On y va![K] Sus à [CS:N]Darkrai[CR]!", german="Okay, [hero] und\n[CS:N]Cresselia[CR]! Gehen wir![K] Zurück zu [CS:N]Darkrai[CR]!", italian="Ok, [hero] e [CS:N]Cresselia[CR]!\nForza![K] Torniamo da [CS:N]Darkrai[CR]!", spanish="¡De acuerdo, [hero] y\n[CS:N]Cresselia[CR]! ¡Vamos![K]\n¡A por [CS:N]Darkrai[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="OK, [hero] and [CS:N]Cresselia[CR]!\nLet's go![K] Back to [CS:N]Darkrai[CR]!", french="D'accord, [hero]\net [CS:N]Cresselia[CR]! On y va![K] Sus à [CS:N]Darkrai[CR]!", german="Okay, [hero] und\n[CS:N]Cresselia[CR]! Gehen wir![K] Zurück zu [CS:N]Darkrai[CR]!", italian="Ok, [hero] e [CS:N]Cresselia[CR]!\nForza![K] Torniamo da [CS:N]Darkrai[CR]!", spanish="¡De acuerdo, [hero] y\n[CS:N]Cresselia[CR]! ¡Vamos![K]\n¡A por [CS:N]Darkrai[CR]!"})
  else
  SkySceneKit.say({english="OK, [hero] and [CS:N]Cresselia[CR]!\nLet's go![K] Back to [CS:N]Darkrai[CR]!", french="D'accord, [hero]\net [CS:N]Cresselia[CR]! On y va![K] Sus à [CS:N]Darkrai[CR]!", german="Okay, [hero] und\n[CS:N]Cresselia[CR]! Gehen wir![K] Zurück zu [CS:N]Darkrai[CR]!", italian="Ok, [hero] e [CS:N]Cresselia[CR]!\nForza![K] Torniamo da [CS:N]Darkrai[CR]!", spanish="¡De acuerdo, [hero] y\n[CS:N]Cresselia[CR]! ¡Vamos![K]\n¡A por [CS:N]Darkrai[CR]!"})
  end
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
