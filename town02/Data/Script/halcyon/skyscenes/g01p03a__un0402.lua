-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/un0402.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(43, 2) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [43, 2]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 520, 240, Direction.Down, "NPC_CHIRIIN")
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Oh! [CS:Y]Sunflora[CR]![K]\nHow are you?", french="Oh! [CS:Y]Héliatronc[CR]![K]\nComment ça va?", german="Oh! [CS:Y]Sonnflora[CR]![K]\nWie geht es dir?", italian="Oh! [CS:Y]Sunflora[CR]![K]\nCome stai?", spanish="¡Anda! ¡[CS:Y]Sunflora[CR]![K]\n¿Cómo estás?"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I just started running the\nAssembly, so there's still a lot I don't know...", french="J'ai juste commencé à m'occuper\ndu Rassemblement, alors il y a encore\nplein de trucs que je ne connais pas...", german="Ich habe gerade erst mit dem\nTreffpunkt angefangen, daher gibt es noch\nviel zu lernen...", italian="Ho appena iniziato a occuparmi\ndel Raduno, quindi ci sono ancora tante cose\nche non conosco...", spanish="Acabo de empezar a encargarme\ndel Registro, así que aún hay cosas que no sé..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="But it's just so fun and\nrewarding!", french="Mais quel pied, et comme\nc'est valorisant!", german="Aber es macht eine Menge Spaß\nund gibt mir so viel!", italian="Però è così spassoso\ne gratificante!", spanish="¡Pero es la mar de divertido\ny gratificante!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Let's both do our best!", french=" Faisons de notre mieux!", german=" Lass uns unser Bestes geben!", italian=" Diamoci dentro!", spanish=" ¡Hagámoslo lo mejor posible!"})
  -- message_Close
  -- @label_2 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif ((SV.SkyTalkBitFlags or {})[133] == 1) then -- elseif ROM: $SCENARIO_TALK_BIT_FLAG[133]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Let's both do our best!", french=" Faisons de notre mieux!", german=" Lass uns unser Bestes geben!", italian=" Facciamo del nostro meglio!", spanish=" ¡Vamos a darlo todo!"})
  -- message_Close
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[133] = 1 -- $SCENARIO_TALK_BIT_FLAG[133] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Oh! [CS:Y]Sunflora[CR]!", french=" Oh! [CS:Y]Héliatronc[CR]!", german=" Oh! [CS:Y]Sonnflora[CR]!", italian=" Oh! [CS:Y]Sunflora[CR]!", spanish=" ¡Anda, [CS:Y]Sunflora[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="So, [CS:N]Chatot[CR] called you to the\nGuildmaster's Chamber earlier...", french="Alors, [CS:N]Pijako[CR] t'a convoquée\ndans la salle du Maître de la Guilde,\ntout à l'heure?", german="[CS:N]Plaudagei[CR] hat dich also\nvorhin in die Kammer des Gildenmeisters\ngerufen...", italian="Allora, [CS:N]Chatot[CR] ti ha convocata\nnella Stanza del Capitano prima...", spanish="Antes, [CS:N]Chatot[CR] te ha enviado\na la Cámara del Gran Bluff..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Something happening?", french=" Il se passe quelque chose?", german=" Ist etwas passiert?", italian=" È successo qualcosa?", spanish=" ¿Ocurre algo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Yeah. [K]Truth is, Officer\n[CS:N]Magnezone[CR] has come here to discuss a job...", french="Ouais. [K]En fait, le shérif\n[CS:N]Magnézone[CR] est venu discuter d'une mission...", german="Jaaa.[K] Oberwachtmeister\n[CS:N]Magnezone[CR] ist gekommen, um einen Job\nzu besprechen...", italian="Beh, sì. [K]A dire la verità,\nil Commissario [CS:N]Magnezone[CR] è venuto a parlare\ndi una missione...", spanish="Sí.[K] La verdad es que el agente\n[CS:N]Magnezone[CR] ha venido a hablar de una misión..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="It seems like they want to\nentrust me with the job, so the Guildmaster\nhas asked me to do it.", french="Et ils veulent me la confier,\nle Maître de la Guilde m'a demandé de\nm'en occuper.", german="Anscheinend wollen sie mir den\nJob anvertrauen. Und daher hat mich der\nGildenmeister gebeten, den Job zu übernehmen.", italian="Pare che vogliano affidarla\na me, così il Capitano mi ha chiesto se volevo\naccettare.", spanish="Parece que quieren confiarme\nel trabajo, así que el Gran Bluff me ha\npedido que me ocupe yo de llevarla a cabo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Wow![K] Does that mean that\nyou've been selected as guild representative?", french="Waouh![K] Ça veut dire que tu as\nété sélectionnée pour représenter la Guilde?", german="Wow![K] Heißt das, dass sie dich\nzur Vertreterin der Gilde auserwählt haben?", italian="Wow![K] Significa che sei stata\nscelta come rappresentante della Gilda?", spanish="¡Anda![K] ¿Significa eso que\nte han elegido representante del [CS:N]Pokégremio[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" [CS:Y]Sunflora[CR]![K] Good luck!", french=" [CS:Y]Héliatronc[CR]![K] Bonne chance!", german=" [CS:Y]Sonnflora[CR]![K] Alles Gute!", italian="È grandioso, [CS:Y]Sunflora[CR]![K]\nBuona fortuna!", spanish="¡Buena suerte, [CS:Y]Sunflora[CR]![K]\n¡Yo te apoyo!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="That reminds me, starting\ntoday...", french="Ça me fait penser...\nA partir d'aujourd'hui...", german=" Das erinnert mich an etwas...", italian="Ora che ci penso, a partire\nda oggi...", spanish="Eso me recuerda que\na partir de hoy..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I've been assigned to a new job\naround the guild!", french="... on m'a confié un nouveau\ntravail à la Guilde.", german="Von heute an soll ich einen Job\nin der Gilde wahrnehmen!", italian="... comincia il mio nuovo\nincarico all'interno della Gilda!", spanish="¡Me han asignado una nueva\nmisión en el [CS:N]Pokégremio[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Really? [K]That's wonderful!", french=" Vraiment? [K]C'est génial!", german=" Wirklich?[K] Das ist ja wunderbar!", italian=" Davvero? [K]È fantastico!", spanish=" ¿De verdad?[K] ¡Qué fuerte!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Congratulations, [CS:N]Chimecho[CR]!", french=" Félicitations, [CS:N]Eoko[CR]!", german=" Glückwunsch, [CS:N]Palimpalim[CR]!", italian=" Congratulazioni, [CS:N]Chimecho[CR]!", spanish=" ¡Enhorabuena, [CS:N]Chimecho[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Yeah! [K]Let's both work hard!", french="Ouais! [K]Travaillons dur,\ntoutes les deux!", german=" Jaaa![K] Geben wir uns Mühe!", italian=" Sì! [K]Impegniamoci tutte e due!", spanish=" ¡Sí![K] ¡Tenemos que trabajar duro!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yeah!", french=" Ouais!", german=" Jaaa!", italian=" Certo!", spanish=" ¡Eso!"})
  -- message_Close
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
