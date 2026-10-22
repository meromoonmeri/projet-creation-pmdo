-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V03P06A/m20a0707.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  -- back_SetGround(LEVEL_V03P06B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetOutputAttribute(64) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  -- back_SetEffect(11, 0) [transition couches décor NDS immédiate]
  GAME:FadeIn(30)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 200, 320, Direction.Up, "NPC_JUPUTORU")
  GROUND:MoveToPosition(npc_npc_juputoru, 200, 180, false, 2)
  GROUND:MoveToPosition(partner, 184, 212, false, 2)
  GROUND:MoveToPosition(hero, 216, 212, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But what's this?", french=" Mais qu'est-ce que c'est que ça?", german=" Aber was ist das?", italian=" Ma questo cos'è?", spanish=" Pero, ¿qué es eso?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But what's this?", french=" Mais qu'est-ce que c'est que ça?", german=" Aber was ist das?", italian=" Ma questo cos'è?", spanish=" Pero, ¿qué es eso?"})
  else
  SkySceneKit.say({english=" But what's this?", french=" Mais qu'est-ce que c'est que ça?", german=" Aber was ist das?", italian=" Ma questo cos'è?", spanish=" Pero, ¿qué es eso?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="It's a Time Gear.[K] There's no\nmistaking it.", french="C'est un Rouage du Temps.[K]\nImpossible de s'y tromper.", german="Es ist ein Zahnrad der Zeit.[K] Da\ngibt es kein Vertun.", italian="È un Ingranaggio del Tempo.[K]\nNon c'è dubbio.", spanish="Eso es un Engranaje del Tiempo.[K]\nNo hay confusión posible."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But...", french=" Pourtant...", german=" Aber...", italian=" Ma...", spanish=" Pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But...", french=" Pourtant...", german=" Aber...", italian=" Ma...", spanish=" Pero..."})
  else
  SkySceneKit.say({english=" But...", french=" Pourtant...", german=" Aber...", italian=" Ma...", spanish=" Pero..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Time here seems to be stopped.", french="... le temps semble être à\nl'arrêt ici.", german="Die Zeit hier scheint angehalten\nzu haben.", italian=" Il tempo qui sembra fermo.", spanish="El tiempo parece haberse\ndetenido."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Time here seems to be stopped.", french="... le temps semble être à\nl'arrêt ici.", german="Die Zeit hier scheint angehalten\nzu haben.", italian=" Il tempo qui sembra fermo.", spanish="El tiempo parece haberse\ndetenido."})
  else
  SkySceneKit.say({english=" Time here seems to be stopped.", french="... le temps semble être à\nl'arrêt ici.", german="Die Zeit hier scheint angehalten\nzu haben.", italian=" Il tempo qui sembra fermo.", spanish="El tiempo parece haberse\ndetenido."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" There's no wind...", french="Il n'y a pas le moindre courant\nd'air...", german=" Es weht kein Wind...", italian=" Non c'è vento...", spanish=" No sopla el viento..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" No wind is blowing...", french="Il n'y a pas le moindre courant\nd'air...", german=" Hier bläst kein Wind...", italian=" Il vento non soffia...", spanish=" No sopla el viento..."})
  else
  SkySceneKit.say({english=" There isn't even a breeze...", french="Il n'y a pas le moindre courant\nd'air...", german=" Noch nicht einmal eine Brise...", italian=" Non c'è un filo di vento...", spanish=" No hay ni la menor brisa..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 148, 188, false, 2)
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="See? Those leaves are fixed\nin place.", french="Regardez! Ces feuilles sont\ncomplètement immobiles.", german="Seht ihr? Diese Blätter sind\nwie erstarrt.", italian="Vedi? Quelle foglie sono\nimmobili.", spanish=" ¿Ves? Esas hojas están tiesas."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="See? Those leaves are fixed\nin place.", french="Regardez! Ces feuilles sont\ncomplètement immobiles.", german="Seht ihr? Diese Blätter sind\nwie erstarrt.", italian="Vedi? Quelle foglie sono\nimmobili.", spanish=" ¿Ves? Esas hojas están tiesas."})
  else
  SkySceneKit.say({english="See? Those leaves are fixed\nin place.", french="Regardez! Ces feuilles sont\ncomplètement immobiles.", german="Seht ihr? Diese Blätter sind\nwie erstarrt.", italian="Vedi? Quelle foglie sono\nimmobili.", spanish=" ¿Ves? Esas hojas están tiesas."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Time really is stopped here!", french=" Le temps est bel et bien figé ici!", german="Die Zeit ist hier wirklich\nstehen geblieben!", italian="Il tempo qui si è davvero\nfermato!", spanish=" ¡Aquí el tiempo se ha parado!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Time is stopped here!", french=" Le temps est bel et bien figé ici!", german=" Hier hat die Zeit angehalten!", italian=" Il tempo qui si è fermato!", spanish=" ¡Aquí el tiempo se ha parado!"})
  else
  SkySceneKit.say({english=" Time has really stopped here!", french=" Le temps est bel et bien figé ici!", german=" Hier hat die Zeit angehalten!", italian="Il tempo qui si è davvero\nfermato!", spanish=" ¡Aquí el tiempo se ha parado!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But the Time Gear is back where\nit should be...[K] Why is this happening?!", french="Et pourtant, le Rouage du Temps\na repris sa place...[K] Mais qu'est-ce qui\nse passe?!", german="Aber das Zahnrad der Zeit ist\nda, wo es hingehört...[K] Warum ist das so?", italian="Ma l'Ingranaggio del Tempo è di\nnuovo al suo posto...[K] Perché allora?", spanish="Pero el Engranaje del Tiempo\nestá donde le corresponde...[K]\n¡¿Por qué está ocurriendo esto?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But the Time Gear has been\nreturned to its rightful place...[K] Why is this\nhappening?!", french="Et pourtant, le Rouage du Temps\na repris sa place...[K] Mais qu'est-ce qui\nse passe?!", german="Aber das Zahnrad der Zeit ist\nda, wo es hingehört...[K] Warum ist das so?", italian="Ma l'Ingranaggio del Tempo è di\nnuovo al suo posto...[K] Perché sta succedendo\nquesto?!", spanish="Pero el Engranaje del Tiempo\nestá donde le corresponde...[K]\n¡¿Por qué está ocurriendo esto?!"})
  else
  SkySceneKit.say({english="But the Time Gear is back where\nit should be...[K] Why is this happening?!", french="Et pourtant, le Rouage du Temps\na repris sa place...[K] Mais qu'est-ce qui\nse passe?!", german="Aber das Zahnrad der Zeit ist\nda, wo es hingehört...[K] Warum ist das so?", italian="Ma l'Ingranaggio del Tempo è di\nnuovo dove dovrebbe essere...[K] Perché sta\nsuccedendo questo?!", spanish="Pero el Engranaje del Tiempo\nestá donde le corresponde...[K]\n¡¿Por qué está ocurriendo esto?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" ........................", french=" ........................", german=" ........................", italian=" ........................", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(0), p.Y+(-20), false, 1) end
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- SetAnimation(3) [anim idle native]
  -- MoveHeight(2, 15) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- Destroy() [neutre/état moteur]
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="[CN][CS:N]Grovyle[CR] took\n[CN]the Time Gear!", french="[CN][CS:N]Massko[CR] prend\n[CN]le Rouage du Temps!", german="[CN][CS:N]Reptain[CR] nimmt\n[CN]das Zahnrad der Zeit!", italian="[CN][CS:N]Grovyle[CR] prende\n[CN]l'Ingranaggio del Tempo!", spanish="[CN]¡[CS:N]Grovyle[CR] cogió\n[CN]el Engranaje del Tiempo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(0), p.Y+(24), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- GAP: se_Play(7440) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(60) -- back_SetEffect(12, 60) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  GAME:WaitFrames(2) -- WaitBackEffect (join)
  -- Destroy() [neutre/état moteur]
  GAME:FadeIn(120) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  GAME:WaitFrames(10)
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! What are you doing?!", french=" Eh! Qu'est-ce que tu as fait?!", german=" Hey! Was hast du getan?!?", italian=" Ehi! Cosa hai fatto?!", spanish=" ¡¿Pero qué has hecho?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! What are you doing?!", french=" Eh! Qu'est-ce que tu as fait?!", german=" Hey! Was hast du getan?!?", italian=" Ehi! Cosa hai fatto?!", spanish=" ¡¿Pero qué has hecho?!"})
  else
  SkySceneKit.say({english=" Hey! What are you doing?!", french=" Eh! Qu'est-ce que tu as fait?!", german=" Hey! Was hast du getan?!?", italian=" Ehi! Cosa hai fatto?!", spanish=" ¡¿Pero qué has hecho?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Time has already stopped here.", french=" Le temps est déjà figé ici.", german="Die Zeit hat hier schon\nangehalten.", italian=" Qui il tempo è già fermo.", spanish="El tiempo ya se ha detenido en\neste lugar."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="It won't make any difference if\nI take the Time Gear now.", french="Ça ne changera rien que\nje prenne le Rouage du Temps ou pas.", german="Es macht deswegen keinen\nUnterschied, wenn ich das Zahnrad der Zeit\njetzt mitnehme.", italian="Non cambierà nulla se prendo\nl'Ingranaggio del Tempo.", spanish=" Da igual que lo coja o no."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="There's also...[K]something that's\nmore worrying.", french="Et il y a quelque chose...[K]\nd'encore plus inquiétant.", german="Außerdem...[K] Etwas anderes ist\nviel beunruhigender.", italian="C'è anche...[K] qualcosa di più\npreoccupante.", spanish="En realidad hay una cosa...[K]\nque resulta mucho más preocupante."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" M-more worrying?", french=" Encore plus inquiétant?", german=" V-viel beunruhigender?", italian=" P-Più preoccupante?", spanish=" ¿Más preocupante aún?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" M-more worrying?", french=" Encore plus inquiétant?", german=" V-viel beunruhigender?", italian=" P-Più preoccupante?", spanish=" ¿Más preocupante aún?"})
  else
  SkySceneKit.say({english=" M-more worrying?", french=" Encore plus inquiétant?", german=" V-viel beunruhigender?", italian=" P-Più preoccupante?", spanish=" ¿Más preocupante aún?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Forget it.[K] Let's leave.", french=" Laissez tomber.[K] Partons.", german="Vergesst es.[K] Gehen wir von hier\nweg.", italian=" Lascia perdere.[K] Andiamocene.", spanish=" Olvidadlo.[K] Vámonos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Also, [partner]...[K] There's\nsomething I'd like you to do.", french="Au fait, [partner]...[K]\nj'ai une mission à te confier.", german="Übrigens, [partner]...[K] Es gibt\netwas, das du für mich tun könntest.", italian="E poi, [partner]...[K] C'è una\ncosa che vorrei che facessi.", spanish="Por cierto, [partner]...[K]\nMe gustaría que hicieras una cosa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What is it?", french=" Quoi donc?", german=" Was denn?", italian=" Di cosa si tratta?", spanish=" ¿De qué se trata?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What is it?", french=" Quoi donc?", german=" Was denn?", italian=" Di cosa si tratta?", spanish=" ¿De qué se trata?"})
  else
  SkySceneKit.say({english=" What is it?", french=" Quoi donc?", german=" Was denn?", italian=" Di cosa si tratta?", spanish=" ¿De qué se trata?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Before you go back to Sharpedo\nBluff...", french="Avant de regagner la Falaise\nSharpedo...", german="Bevor du zurück zur\nTohaido-Klippe gehst...", italian="Prima di tornare al Promontorio\nSharpedo, dovresti fare una cosa.", spanish="Antes de que vuelvas al\nRisco Sharpedo..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I'd like you to gather some\ninformation in Treasure Town.", french="... je voudrais que tu recueilles\ndes informations à Bourg-Trésor.", german="Ich hätte gerne, dass du vorher\nin Schatzstadt ein paar Informationen\nsammelst.", italian="Vorrei che raccogliessi alcune\ninformazioni a Borgo Tesoro.", spanish="Me gustaría que consiguieras\ncierta información en Aldea Tesoro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" In Treasure Town?", french=" A Bourg-Trésor?", german=" In Schatzstadt?", italian=" A Borgo Tesoro?", spanish=" ¿En Aldea Tesoro?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" In Treasure Town?", french=" A Bourg-Trésor?", german=" In Schatzstadt?", italian=" A Borgo Tesoro?", spanish=" ¿En Aldea Tesoro?"})
  else
  SkySceneKit.say({english=" In Treasure Town?", french=" A Bourg-Trésor?", german=" In Schatzstadt?", italian=" A Borgo Tesoro?", spanish=" ¿En Aldea Tesoro?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Yes, here's what I want you to\nfind out.", french=" Oui, laisse-moi t'expliquer.", german="Ja, und Folgendes sollst du für\nmich herausfinden.", italian="Sì, vorrei che cercassi\ndi scoprire qualcosa.", spanish="Sí. Esto es lo que quiero que\naverigües..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Learn everything you can about\nwhat's happening in this world right now.", french="Réunis un maximum de\nrenseignements sur ce qui se passe\ndans ce monde en ce moment.", german="Versuch alles herauszufinden,\nwas gerade in dieser Welt passiert.", italian="Scopri tutto quello che puoi su\nciò che sta accadendo adesso qui.", spanish="Tienes que enterarte de todo\nlo que está pasando últimamente."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Gotcha. I'll go find out.", french=" Compris. J'y vais de ce pas.", german="Verstanden. Ich werde es\nherausfinden.", italian="Capito. Lo scoprirò.", spanish=" Entendido. Iré a averiguarlo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK. I'll go find out.", french=" Compris. J'y vais de ce pas.", german="Okay. Ich werde es\nherausfinden.", italian=" Ok. Lo scoprirò.", spanish=" Entendido. Iré a averiguarlo."})
  else
  SkySceneKit.say({english=" Sure thing. I'll go find out.", french=" Compris. J'y vais de ce pas.", german="Klare Sache. Ich werde es\nherausfinden.", italian=" Certo. Lo scoprirò.", spanish=" Entendido. Iré a averiguarlo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Everyone thinks that you've gone\nto the future.[K] Therefore...", french="Tout le monde vous croit encore\ndans le futur.[K] Par conséquent...", german="Jeder glaubt, dass ihr in die\nZukunft gegangen seid.[K] Daher...", italian="Pensano tutti che tu sia ancora\nnel futuro.[K] Quindi...", spanish="Todos creen que estáis\nen el futuro.[K] Por tanto..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yup, I know.[K] If they found out\nI'm back, there would be an uproar. I'll keep\nlow and get some news.", french="Oui, je sais.[K] Si on découvre que\nnous sommes de retour, ça va être la panique.\nJe me ferai discret tout en glanant des infos.", german="Ja, schon klar.[K] Wüsste man,\ndass wir zurück sind, gäbe es einen Aufruhr.\nIch verhalte mich ruhig und höre mich um.", italian="Già, lo so.[K] Se scoprono che\nsono tornato, scoppierà un putiferio. Cercherò\ndi non farmi notare e di scoprire qualcosa.", spanish="Sí, ya lo sé.[K] Si alguien se entera\nde que hemos vuelto, sería un escándalo.\nIntentaré no llamar la atención."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yes, I understand.[K] If they found\nout I'm back, there would be an uproar. I'll\nkeep low and get some news.", french="Oui, je sais.[K] Si on découvre que\nnous sommes de retour, ça va être la panique.\nJe me ferai discret tout en glanant des infos.", german="Ja, schon klar.[K] Wüsste man,\ndass wir zurück sind, gäbe es einen Aufruhr.\nIch verhalte mich ruhig und höre mich um.", italian="Sì, capisco.[K] Se scoprono che\nsono tornato, ci sarà un po' di caos. Cercherò\ndi non farmi notare e di scoprire qualcosa.", spanish="Sí, ya lo sé.[K] Si alguien se entera\nde que hemos vuelto, sería un escándalo.\nIntentaré no llamar la atención."})
  else
  SkySceneKit.say({english="I know.[K] If they found out I'm\nback, there would be an uproar. I'll keep low\nand get some news.", french="Oui, je sais.[K] Si on découvre que\nnous sommes de retour, ça va être la panique.\nJe me ferai discrète tout en glanant des infos.", german="Ja, schon klar.[K] Wüsste man,\ndass wir zurück sind, gäbe es einen Aufruhr.\nIch verhalte mich ruhig und höre mich um.", italian="Lo so.[K] Se scoprono che sono\ntornata, chissà che caos! Cercherò di\nnon farmi notare e di scoprire qualcosa.", spanish="Sí, ya lo sé.[K] Si alguien se entera\nde que hemos vuelto, sería un escándalo.\nIntentaré no llamar la atención."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" I'm counting on you.", french=" Je compte sur toi.", german=" Ich zähle auf dich.", italian=" Conto su di te.", spanish=" Cuento contigo."})
  -- message_Close
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(0), p.Y+(160), false, 2) end
  GAME:WaitFrames(10)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(160), false, 2) end
  GAME:WaitFrames(10)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(36), p.Y+(160), false, 2) end
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  SkySceneKit.cleanup_npcs()
end
