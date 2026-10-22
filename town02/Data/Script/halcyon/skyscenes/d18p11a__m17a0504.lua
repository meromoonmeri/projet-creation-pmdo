-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D18P11A/m17a0504.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- GAP: BGM BGM_IN_THE_FUTURE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkyProg.set(18, 3) -- $SCENARIO_MAIN = scn[18,3] (ROM)
  -- back_SetGround(LEVEL_D18P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" The planet's paralysis...", french=" La Paralysie de la Planète...", german=" Die Lähmung des Planeten...", italian=" La paralisi del pianeta...", spanish=" La parálisis del planeta..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" The planet's paralysis...", french=" La Paralysie de la Planète...", german=" Die Lähmung des Planeten...", italian=" La paralisi del pianeta...", spanish=" La parálisis del planeta..."})
  else
  SkySceneKit.say({english=" The planet's paralysis...", french=" La Paralysie de la Planète...", german=" Die Lähmung des Planeten...", italian=" La paralisi del pianeta...", spanish=" La parálisis del planeta..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's true that this place appears\njust like [CS:N]Dusknoir[CR] described it.", french="C'est vrai que cet endroit\ncorrespond parfaitement à la description\nqu'en a fait [CS:N]Noctunoir[CR].", german="Dieser Planet scheint tatsächlich\nso zu sein, wie [CS:N]Zwirrfinst[CR] es beschrieben hat.", italian="Questo posto è proprio come\nlo descriveva [CS:N]Dusknoir[CR].", spanish="Realmente este sitio es tal y\ncomo lo describió [CS:N]Dusknoir[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Sure, this place resembles\n[CS:N]Dusknoir[CR]'s description.", french="C'est vrai que cet endroit\ncorrespond parfaitement à la description\nqu'en a fait [CS:N]Noctunoir[CR].", german="Ja, dieser Ort passt auf die\nBeschreibung von [CS:N]Zwirrfinst[CR].", italian="Certo, questo posto sembra\nproprio quello che descriveva [CS:N]Dusknoir[CR].", spanish="Realmente este sitio es tal y\ncomo lo describió [CS:N]Dusknoir[CR]."})
  else
  SkySceneKit.say({english="It's true that this place appears\njust like [CS:N]Dusknoir[CR] described it.", french="C'est vrai que cet endroit\ncorrespond parfaitement à la description\nqu'en a fait [CS:N]Noctunoir[CR].", german="Dieser Planet scheint tatsächlich\nso zu sein, wie [CS:N]Zwirrfinst[CR] es beschrieben hat.", italian="Questo posto è proprio come\nlo descriveva [CS:N]Dusknoir[CR].", spanish="Realmente este sitio es tal y\ncomo lo describió [CS:N]Dusknoir[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But even then...", french=" Malgré tout...", german=" Aber trotzdem...", italian=" Tuttavia...", spanish=" Pero aun así..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But even then...", french=" Malgré tout...", german=" Aber trotzdem...", italian=" Tuttavia...", spanish=" Pero aun así..."})
  else
  SkySceneKit.say({english=" But even then...", french=" Malgré tout...", german=" Aber trotzdem...", italian=" Tuttavia...", spanish=" Pero aun así..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's hard to understand how the\nplanet has been paralyzed in the future.", french="... j'ai encore du mal à\ncomprendre comment on a pu en arriver\nlà dans le futur.", german="Es ist schwer zu begreifen, wie\nder Planet in der Zukunft gelähmt werden\nkonnte.", italian="Faccio fatica a comprendere\ncome mai il pianeta sia rimasto paralizzato nel\nfuturo.", spanish="No acabo de entender por qué\nel planeta ha acabado paralizado en el futuro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's hard to understand how the\nplanet has been paralyzed in the future.", french="... j'ai encore du mal à\ncomprendre comment on a pu en arriver\nlà dans le futur.", german="Es ist schwer zu begreifen, wie\nder Planet in der Zukunft gelähmt werden\nkonnte.", italian="Faccio fatica a comprendere\ncome mai il pianeta sia rimasto paralizzato nel\nfuturo.", spanish="No acabo de entender por qué\nel planeta ha acabado paralizado en el futuro."})
  else
  SkySceneKit.say({english="It's hard to understand how the\nplanet has been paralyzed in the future.", french="... j'ai encore du mal à\ncomprendre comment on a pu en arriver\nlà dans le futur.", german="Es ist schwer zu begreifen, wie\nder Planet in der Zukunft gelähmt werden\nkonnte.", italian="Faccio fatica a comprendere\ncome mai il pianeta sia rimasto paralizzato nel\nfuturo.", spanish="No acabo de entender por qué\nel planeta ha acabado paralizado en el futuro."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.DownRight)
  GROUND:EntTurn(partner, Direction.Right)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 368, 176, Direction.Left, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="You're free to believe...or\nreject...what I'm telling you.", french="Vous êtes libres de croire ce\nque je vous dis... ou pas.", german="Es steht euch frei, mir zu\nglauben... Oder eben nicht.", italian="Potete credere... o non credere...\na quello che vi dico.", spanish="Eres libre de creer o rechazar lo\nque te estoy contando."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Either way, I suggest you leave\nhere as soon as you can.", french="Quoi qu'il en soit, je vous\nsuggère de quitter cette cachette au plus\nvite.", german="So oder so rate ich euch,\nhier so bald wie möglich zu verschwinden.", italian="In ogni caso, vi suggerisco di\nandarvene da qui il prima possibile.", spanish="De cualquier modo, os sugiero\nque salgáis de aquí lo antes posible."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I'm going.[K] Don't let those [CS:N]Sableye[CR]\ncatch you.", french="Je vous laisse.[K] Rappelez-vous:\nles [CS:N]Ténéfix[CR] sont à nos trousses.", german="Ich gehe.[K] Lasst euch nicht von\nden [CS:N]Zobiris[CR] fangen.", italian="Io vado.[K] Non lasciatevi\nacciuffare da quei [CS:N]Sableye[CR].", spanish="Yo me marcho.[K] No dejéis que\nos cojan esos [CS:N]Sableye[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_juputoru, 388, 140, false, 2)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownLeft)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk... [hero].", french=" Argh... [hero].", german=" Urk... [hero].", italian=" Ah... [hero].", spanish=" Ay... [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk... [hero].", french=" Argh... [hero].", german=" Urk... [hero].", italian=" Ah... [hero].", spanish=" Ay... [hero]..."})
  else
  SkySceneKit.say({english=" Urk... [hero].", french=" Argh... [hero].", german=" Urk... [hero].", italian=" Ah... [hero].", spanish=" Ay... [hero]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I don't know what to think\nanymore.", french=" Je ne sais plus quoi penser.", german="Ich weiß nicht mehr, was ich\ndenken soll.", italian=" Non so più cosa pensare.", spanish=" Ya no sé qué creer."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I don't know what to think\nanymore.", french=" Je ne sais plus quoi penser.", german="Ich weiß nicht mehr, was ich\ndenken soll.", italian=" Non so più cosa pensare.", spanish=" Ya no sé qué creer."})
  else
  SkySceneKit.say({english="I don't know what to think\nanymore.", french=" Je ne sais plus quoi penser.", german="Ich weiß nicht mehr, was ich\ndenken soll.", italian=" Non so più cosa pensare.", spanish=" Ya no sé qué creer."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Wasn't the planet's paralysis\nsupposed to be caused by all those Time Gears\ngoing missing?", french="La Paralysie de la Planète\ndécoule bien de la disparition des Rouages\ndu Temps, ou je me trompe?", german="War es nicht so, dass die\nLähmung des Planeten durch die fehlenden\nZahnräder der Zeit ausgelöst werden sollte?", italian="La paralisi del pianeta non\ndoveva essere causata dalla sparizione\ndi tutti quegli Ingranaggi del Tempo?", spanish="¿No se suponía que la parálisis\ndel planeta sería la consecuencia del robo\nde los Engranajes del Tiempo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Wasn't the planet's paralysis\nsupposed to be caused by all those Time Gears\ngoing missing?", french="La Paralysie de la Planète\ndécoule bien de la disparition des Rouages\ndu Temps, ou je me trompe?", german="War es nicht so, dass die\nLähmung des Planeten durch die fehlenden\nZahnräder der Zeit ausgelöst werden sollte?", italian="La paralisi del pianeta non\ndoveva essere causata dalla sparizione\ndi tutti quegli Ingranaggi del Tempo?", spanish="¿No se suponía que la parálisis\ndel planeta sería la consecuencia del robo\nde los Engranajes del Tiempo?"})
  else
  SkySceneKit.say({english="Wasn't the planet's paralysis\nsupposed to be caused by all those Time Gears\ngoing missing?", french="La Paralysie de la Planète\ndécoule bien de la disparition des Rouages\ndu Temps, ou je me trompe?", german="War es nicht so, dass die\nLähmung des Planeten durch die fehlenden\nZahnräder der Zeit ausgelöst werden sollte?", italian="La paralisi del pianeta non\ndoveva essere causata dalla sparizione\ndi tutti quegli Ingranaggi del Tempo?", spanish="¿No se suponía que la parálisis\ndel planeta sería la consecuencia del robo\nde los Engranajes del Tiempo?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's why we all tried to stop\n[CS:N]Grovyle[CR] from stealing the Time Gears.", french="C'est pour cette raison qu'on a\nessayé d'arrêter [CS:N]Massko[CR].", german="Darum wollten wir [CS:N]Reptain[CR]\ndavon abhalten, sie zu stehlen.", italian="È per questo che cercavamo\ntutti quanti di impedire a [CS:N]Grovyle[CR] di rubare\ngli Ingranaggi del Tempo.", spanish="Por eso todos intentamos evitar\nque [CS:N]Grovyle[CR] los robase."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's why we all tried to stop\n[CS:N]Grovyle[CR] from stealing the Time Gears.", french="C'est pour cette raison qu'on a\nessayé d'arrêter [CS:N]Massko[CR].", german="Darum wollten wir [CS:N]Reptain[CR]\ndavon abhalten, sie zu stehlen.", italian="È per questo che cercavamo\ntutti quanti di impedire a [CS:N]Grovyle[CR] di rubare\ngli Ingranaggi del Tempo.", spanish="Por eso todos intentamos evitar\nque [CS:N]Grovyle[CR] los robase."})
  else
  SkySceneKit.say({english="That's why we all tried to stop\n[CS:N]Grovyle[CR] from stealing the Time Gears.", french="C'est pour cette raison qu'on a\nessayé d'arrêter [CS:N]Massko[CR].", german="Darum wollten wir [CS:N]Reptain[CR]\ndavon abhalten, sie zu stehlen.", italian="È per questo che cercavamo\ntutti quanti di impedire a [CS:N]Grovyle[CR] di rubare\ngli Ingranaggi del Tempo.", spanish="Por eso todos intentamos evitar\nque [CS:N]Grovyle[CR] los robase."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We did everything we were\nsupposed to, right?", french=" On a fait ce qu'il fallait, non?", german="Wir haben doch alles getan,\nwas zu tun war, oder?", italian="Abbiamo fatto tutto quello che\ndovevamo, no?", spanish="Hicimos lo que se suponía que\nteníamos que hacer, ¿no?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We did everything we were\nsupposed to, right?", french=" On a fait ce qu'il fallait, non?", german="Wir haben doch alles getan,\nwas zu tun war, oder?", italian="Abbiamo fatto tutto quello che\ndovevamo, no?", spanish="Hicimos lo que se suponía que\nteníamos que hacer, ¿no?"})
  else
  SkySceneKit.say({english="We did everything we were\nsupposed to, right?", french=" On a fait ce qu'il fallait, non?", german="Wir haben doch alles getan,\nwas zu tun war, oder?", italian="Abbiamo fatto tutto quello che\ndovevamo, no?", spanish="Hicimos lo que se suponía que\nteníamos que hacer, ¿no?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Uxie[CR] and the others said they'd\nreturn the Time Gears to their rightful places.", french="[CS:N]Créhelf[CR] et les autres ont dit\nqu'ils remettraient les Rouages du Temps\nà leur place.", german="[CS:N]Selfe[CR] und die anderen sagten,\nsie würden die Zahnräder der Zeit wieder\ndahin bringen, wo sie hingehören.", italian="[CS:N]Uxie[CR] e gli altri avevano detto\nche avrebbero rimesso gli Ingranaggi del\nTempo al loro posto.", spanish="[CS:N]Uxie[CR] y los demás iban a\ndevolver cada Engranaje del Tiempo a su lugar."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Uxie[CR] and the others said they\nwould return the recaptured Time Gears to\ntheir rightful places.", french="[CS:N]Créhelf[CR] et les autres ont dit\nqu'ils remettraient les Rouages du Temps\nà leur place.", german="[CS:N]Selfe[CR] und die anderen sagten,\nsie würden die Zahnräder der Zeit wieder\ndahin bringen, wo sie hingehören.", italian="[CS:N]Uxie[CR] e gli altri avevano detto\nche avrebbero rimesso gli Ingranaggi del\nTempo al loro posto.", spanish="[CS:N]Uxie[CR] y los demás iban a\ndevolver cada Engranaje del Tiempo a su lugar."})
  else
  SkySceneKit.say({english="[CS:N]Uxie[CR] and the others said they'd\nreturn the Time Gears to their rightful places.", french="[CS:N]Créhelf[CR] et les autres ont dit\nqu'ils remettraient les Rouages du Temps\nà leur place.", german="[CS:N]Selfe[CR] und die anderen sagten,\nsie würden die Zahnräder der Zeit wieder\ndahin bringen, wo sie hingehören.", italian="[CS:N]Uxie[CR] e gli altri avevano detto\nche avrebbero rimesso gli Ingranaggi del\nTempo al loro posto.", spanish="[CS:N]Uxie[CR] y los demás iban a\ndevolver cada Engranaje del Tiempo a su lugar."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That was supposed to prevent\nthe planet's paralysis!", french="Ça aurait dû suffire à éviter\nque la planète ne soit paralysée!", german="Das hätte die Lähmung des\nPlaneten verhindern sollen!", italian="Questo avrebbe dovuto evitare\nla paralisi del pianeta!", spanish="¡Eso tendría que haber evitado\nla parálisis del planeta!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That should have prevented the\nplanet's paralysis!", french="Ça aurait dû suffire à éviter\nque la planète ne soit paralysée!", german="Das hätte die Lähmung des\nPlaneten verhindern müssen!", italian="Questo avrebbe dovuto evitare\nla paralisi del pianeta!", spanish="¡Eso tendría que haber evitado\nla parálisis del planeta!"})
  else
  SkySceneKit.say({english="That should have prevented the\nplanet's paralysis!", french="Ça aurait dû suffire à éviter\nque la planète ne soit paralysée!", german="Das hätte die Lähmung des\nPlaneten verhindern sollen!", italian="Questo avrebbe dovuto evitare\nla paralisi del pianeta!", spanish="¡Eso tendría que haber evitado\nla parálisis del planeta!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But despite all our efforts...", french="Mais en dépit de tous\nnos efforts...", german="Aber es war anscheinend alles\numsonst...", italian="Ma nonostante tutti i nostri\nsforzi...", spanish="Pero a pesar de todos nuestros\nesfuerzos..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But despite all our efforts...", french="Mais en dépit de tous\nnos efforts...", german="Aber es war anscheinend alles\numsonst...", italian="Ma nonostante tutti i nostri\nsforzi...", spanish="Pero a pesar de todos nuestros\nesfuerzos..."})
  else
  SkySceneKit.say({english=" But despite all our efforts...", french="Mais en dépit de tous\nnos efforts...", german="Aber es war anscheinend alles\numsonst...", italian="Ma nonostante tutti i nostri\nsforzi...", spanish="Pero a pesar de todos nuestros\nesfuerzos..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Why is the planet still\nparalyzed...[K]in our future?", french="Comment ça se fait que la\nplanète soit quand même paralysée...[K]\ndans le futur?", german="Der Planet ist in unserer\nZukunft noch immer gelähmt.[K] Aber warum?", italian="Perché il pianeta è ancora\nparalizzato...[K] nel nostro futuro?", spanish="¿Por qué el planeta ha acabado\nparalizándose?[K] ¿Es ese nuestro futuro?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Why is the planet still\nparalyzed...[K]in our future?", french="Comment ça se fait que la\nplanète soit quand même paralysée...[K]\ndans le futur?", german="Der Planet ist in unserer\nZukunft noch immer gelähmt.[K] Aber warum?", italian="Perché il pianeta è ancora\nparalizzato...[K] nel nostro futuro?", spanish="¿Por qué el planeta ha acabado\nparalizándose?[K] ¿Es ese nuestro futuro?"})
  else
  SkySceneKit.say({english="Why is the planet still\nparalyzed...[K]in our future?", french="Comment ça se fait que la\nplanète soit quand même paralysée...[K]\ndans le futur?", german="Der Planet ist in unserer\nZukunft noch immer gelähmt.[K] Aber warum?", italian="Perché il pianeta è ancora\nparalizzato...[K] nel nostro futuro?", spanish="¿Por qué el planeta ha acabado\nparalizándose?[K] ¿Es ese nuestro futuro?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Arrgh! I don't know who or what\nto believe anymore!", french="Arrgh! Je ne sais plus du tout\nqui croire!", german="Arrgh! Ich weiß nicht mehr,\nwem oder was ich glauben soll!", italian="Arrgh! Non so più a chi e a cosa\ncredere!", spanish="¡Aj! ¡Ya no sé qué creer ni\na quién!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Arrgh! I don't know who or what\nto believe anymore!", french="Arrgh! Je ne sais plus du tout\nqui croire!", german="Arrgh! Ich weiß nicht mehr,\nwem oder was ich glauben soll!", italian="Arrgh! Non so più a chi e a cosa\ncredere!", spanish="¡Aj! ¡Ya no sé qué creer ni\na quién!"})
  else
  SkySceneKit.say({english="Arrgh! I don't know who or what\nto believe anymore!", french="Arrgh! Je ne sais plus du tout\nqui croire!", german="Arrgh! Ich weiß nicht mehr,\nwem oder was ich glauben soll!", italian="Arrgh! Non so più a chi e a cosa\ncredere!", spanish="¡Aj! ¡Ya no sé qué creer ni\na quién!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Wheh-heh-heh!", french=" Whé hé hé!", german=" Wähähäh!", italian=" Meh-eh-eh-eh!", spanish=" ¡Je, je, je, je!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(30) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waah! The [CS:N]Sableye[CR]!", french=" Ouaaah! Les [CS:N]Ténéfix[CR]!", german=" Waah! Die [CS:N]Zobiris[CR]!", italian=" Aaah! I [CS:N]Sableye[CR]!", spanish=" ¡Aaah! ¡Los [CS:N]Sableye[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah! The [CS:N]Sableye[CR]!", french=" Ouaaah! Les [CS:N]Ténéfix[CR]!", german=" Waah! Die [CS:N]Zobiris[CR]!", italian=" Aaah! I [CS:N]Sableye[CR]!", spanish=" ¡Aaah! ¡Los [CS:N]Sableye[CR]!"})
  else
  SkySceneKit.say({english=" Waah! The [CS:N]Sableye[CR]!", french=" Ouaaah! Les [CS:N]Ténéfix[CR]!", german=" Waah! Die [CS:N]Zobiris[CR]!", italian=" Aaah! I [CS:N]Sableye[CR]!", spanish=" ¡Aaah! ¡Los [CS:N]Sableye[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We can't stick around here,\n[hero]!", french="On ne peut pas rester là,\n[hero]!", german="Wir müssen weg von hier,\n[hero]!", italian="Non possiamo restare qui,\n[hero]!", spanish="¡No podemos quedarnos aquí,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We can't stay here,\n[hero]!", french="On ne peut pas rester là,\n[hero]!", german="Wir können hier nicht bleiben,\n[hero]!", italian="Non possiamo restare qui,\n[hero]!", spanish="¡No podemos quedarnos aquí,\n[hero]!"})
  else
  SkySceneKit.say({english="We can't stay here,\n[hero]!", french="On ne peut pas rester là,\n[hero]!", german="Wir können hier nicht bleiben,\n[hero]!", italian="Non possiamo restare qui,\n[hero]!", spanish="¡No podemos quedarnos aquí,\n[hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's get ready quickly so we\ncan get rolling!", french=" Préparons-nous vite et partons!", german="Machen wir uns schnell fertig\nund hauen ab!", italian="Prepariamoci velocemente e\nmuoviamoci!", spanish=" ¡Hay que salir pitando!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's get ready quickly so we\ncan get moving!", french=" Préparons-nous vite et partons!", german="Machen wir uns schnell fertig\nund verschwinden!", italian="Prepariamoci velocemente, così\nci rimettiamo in marcia!", spanish=" ¡Hay que salir pitando!"})
  else
  SkySceneKit.say({english="Let's get ready quickly so we\ncan get going again!", french=" Préparons-nous vite et partons!", german="Machen wir uns schnell fertig\nund verschwinden!", italian="Prepariamoci velocemente e\npartiamo!", spanish=" ¡Hay que salir pitando!"})
  end
  -- message_Close
  pcall(function() SOUND:PlayBGM("Chasm Cave.ogg", true) end)
  SkySceneKit.cleanup_npcs()
end
