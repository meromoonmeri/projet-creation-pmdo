-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m13a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  SkyProg.set(14, 2) -- $SCENARIO_MAIN = scn[14,2] (ROM)
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 352, 216, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Now, I see everyone's with us!", french="Bien, je vois que tout le monde\nest là!", german=" Wie ich sehe, sind jetzt alle da!", italian=" Bene. Vedo che ci sono tutti!", spanish=" Veo que ya estamos todos."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="First and foremost![K] This should\ngo without saying...", french=" Avant tout![K] Il va sans dire que...", german="Eine Sache vorweg![K] Das sollte\neigentlich selbstverständlich sein...", italian=" Cominciamo![K] Ecco la situazione.", spanish="Lo primero de todo...[K]\nY algo muy obvio es que..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Grovyle[CR] appears wherever\nTime Gears are located.", french="... [CS:N]Massko[CR] frappe partout\noù il y a un Rouage du Temps.", german="[CS:N]Reptain[CR] taucht überall auf,\nwo sich ein Zahnrad der Zeit befindet.", italian="[CS:N]Grovyle[CR] fa la sua comparsa\novunque si trovi un Ingranaggio del Tempo.", spanish="[CS:N]Grovyle[CR] aparece en los lugares\ndonde hay Engranajes del Tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" But where are the Time Gears?", french="Mais où sont les Rouages\ndu Temps?", german=" Aber wo befinden sie sich alle?", italian="Ma dove si trovano gli\nIngranaggi del Tempo?", spanish=" Pero, ¿dónde se encuentran?"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="That is the question! But we\nhave no answer.", french="Telle est la question! Question à\nlaquelle nous n'avons pas de réponse, d'ailleurs.", german="Das ist die Frage! Aber wir\nhaben keine Antwort darauf.", italian="Questa è la prima domanda che\ndobbiamo porci.", spanish="¡Esa es la cuestión!\nAunque no tenemos la respuesta."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And, therefore, we have relied\nupon the great [CS:N]Dusknoir[CR] for ideas.", french="C'est pourquoi nous avons\nconsulté le grand [CS:N]Noctunoir[CR].", german="Und deshalb vertrauen wir auf\nden Einfallsreichtum des großen [CS:N]Zwirrfinst[CR].", italian="Ci siamo affidati al grande\n[CS:N]Dusknoir[CR] per scoprirlo.", spanish="Por eso hemos tenido que\nrecurrir al gran [CS:N]Dusknoir[CR] para que\nnos diera alguna idea."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Together, we've identified\nseveral locations where the Time Gears may\nbe found.", french="Ensemble, nous avons identifié\nplusieurs endroits susceptibles d'abriter\ndes Rouages du Temps.", german="Gemeinsam haben wir mehrere\nOrte identifiziert, an denen sich ein Zahnrad\nder Zeit befinden könnte.", italian="Insieme, abbiamo individuato la\npossibile ubicazione dei restanti Ingranaggi\ndel Tempo.", spanish="Juntos hemos conseguido\nidentificar algunos sitios donde podría\nhaber Engranajes del Tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We ask that everyone split into\ngroups and investigate each of these\npotential sites.", french="Nous comptons sur vous pour\nformer des équipes et mener l'enquête\nsur place.", german="Wir wollen, dass ihr euch in\nGruppen aufteilt und diese potenziellen\nStandorte erkundet.", italian="Il piano consiste nel formare dei\ngruppi che si rechino in esplorazione in questi\nluoghi.", spanish="Tenemos que pediros que os\ndividáis en grupos para ir a investigar\ncada uno de estos posibles emplazamientos."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="First, [CS:N]Loudred[CR] and [CS:N]Corphish[CR]!\nI'm assigning you to the Eastern Forest.", french="D'abord, [CS:N]Ramboum[CR] et [CS:N]Ecrapince[CR]!\nVous êtes assignés à la Forêt de l'Est.", german="Als Erstes [CS:N]Krakeelo[CR] und\n[CS:N]Krebscorps[CR]! Ihr übernehmt die Östlichen\nWälder.", italian="[CS:N]Loudred[CR] e [CS:N]Corphish[CR]! Voi andrete\nalla Foresta Orientale.", spanish="Primero, [CS:N]Loudred[CR] y [CS:N]Corphish[CR].\nOs voy a enviar al Bosque del Este."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="That's the huge forest far to the\neast, of course.", french="C'est cette énorme forêt qui\nse trouve à l'est, bien entendu.", german="Das ist natürlich der riesige\nWald ganz im Osten.", italian="Si tratta, ovviamente della\nvastissima foresta che si trova ad est di qui.", spanish="Evidentemente, se trata del\nenorme bosque que hay al este."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 296, 240, Direction.UpRight, "NPC_DOGOOMU")
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Got it!", french=" Pigé!", german=" Alles klar!", italian=" Ricevuto!", spanish=" ¡Entendido!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 352, 248, Direction.Up, "NPC_HEIGANI")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! We'll do our best!", french="Eh dis donc, on va faire de notre\nmieux!", german="Hey, hey! Wir werden unser\nBestes geben!", italian="Ehi, ehi! Faremo del nostro\nmeglio!", spanish="¡Oye, oye!\n¡Haremos lo que podamos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Next, [CS:N]Bidoof[CR], [CS:N]Dugtrio[CR], and\n[CS:N]Sunflora[CR]! We'd like you to search\n[CS:P]Crystal Cave[CR].", french="Ensuite, [CS:N]Keunotor[CR], [CS:N]Triopikeur[CR] et\n[CS:N]Héliatronc[CR]! On voudrait que vous inspectiez\nla [CS:P]Caverne Cristal[CR].", german="Als Nächstes [CS:N]Bidiza[CR], [CS:N]Digdri[CR] und\n[CS:N]Sonnflora[CR]! Ihr untersucht die [CS:P]Kristallhöhle[CR].", italian="Poi! [CS:N]Bidoof[CR], [CS:N]Dugtrio[CR] e [CS:N]Sunflora[CR]!\nVoi setaccerete la [CS:P]Grotta di Cristallo[CR].", spanish="A continuación, [CS:N]Bidoof[CR], [CS:N]Dugtrio[CR]\ny [CS:N]Sunflora[CR]. Queremos que exploréis la\n[CS:P]Cueva Cristal[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 376, 272, Direction.UpLeft, "NPC_BIPPA")
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Yup yup! Will do!", french=" Hardi petit, sapristi!", german=" Jawollja! Das werden wir!", italian=" Sissignore! Sarà fatto!", spanish=" ¡Sí, señor! ¡Allá vamos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 408, 264, Direction.UpLeft, "NPC_DAGUTORIO")
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Understood.", french=" Compris.", german=" Verstanden.", italian=" Afferrato.", spanish=" Entendido."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 352, 272, Direction.Up, "NPC_KIMAWARI")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Oh my gosh! I'll search hard!", french="Ben mince alors! Comptez sur\nnous! On la fouillera de fond en comble!", german="Auweia! Ich werde mich\nanstrengen!", italian=" Agli ordini! Diamoci dentro!", spanish="¡Qué bien! O sea, voy a explorar\nmejor que nunca."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And, finally, [hero] and\n[partner]! You two are assigned to the\n[CS:P]Northern Desert[CR].", french="Et pour finir, [hero] et\n[partner]! Vous irez dans le [CS:P]Désert\ndu Nord[CR].", german="Und als Letztes [hero]\nund [partner]! Ihr übernehmt die\n[CS:P]Nordwüste[CR].", italian="E infine, [hero] e\n[partner]! Voi due esplorerete il\n[CS:P]Deserto del Nord[CR].", spanish="Por último, [hero] y\n[partner]. Vuestro equipo tendrá que ir\nal [CS:P]Desierto Norte[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 312, 216, Direction.DownRight, "NPC_YONOWAARU")
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" The [CS:P]Northern Desert[CR]?", french=" Le [CS:P]Désert du Nord[CR]?", german=" Die [CS:P]Nordwüste[CR]?", italian=" Il [CS:P]Deserto del Nord[CR]?", spanish=" ¿El [CS:P]Desierto Norte[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" The [CS:P]Northern Desert[CR]?", french=" Le [CS:P]Désert du Nord[CR]?", german=" Die [CS:P]Nordwüste[CR]?", italian=" Il [CS:P]Deserto del Nord[CR]?", spanish=" ¿El [CS:P]Desierto Norte[CR]?"})
  else
  SkySceneKit.say({english=" The [CS:P]Northern Desert[CR]?", french=" Le [CS:P]Désert du Nord[CR]?", german=" Die [CS:P]Nordwüste[CR]?", italian=" Il [CS:P]Deserto del Nord[CR]?", spanish=" ¿El [CS:P]Desierto Norte[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Correct.[K] Open your Wonder Map.", french="Exact.[K] Ouvrez votre Carte\nMiracle.", german="Richtig.[K] Schlagt eure\nWunderkarte auf.", italian="Esattamente.[K] Vi prego di aprire\nla vostra Mappa delle meraviglie.", spanish="Correcto.[K]\nAbrid vuestro Mapa Mágico."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" OK.", french=" D'accord.", german=" Okay.", italian=" Ok.", spanish=" Vale."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK.", french=" D'accord.", german=" Okay.", italian=" Va bene.", spanish=" Vale."})
  else
  SkySceneKit.say({english=" OK.", french=" D'accord.", german=" Okay.", italian=" Va bene.", spanish=" Vale."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN][partner] opened\n[CN]the Wonder Map.", french="[CN][partner] ouvre\n[CN]la Carte Miracle.", german="[CN][partner] öffnet\n[CN]die Wunderkarte.", italian="[CN][partner] apre\n[CN]la Mappa delle meraviglie.", spanish="[CN][partner] abrió\n[CN]el Mapa Mágico."})
  -- message_Close
  -- GAP: se_Play(6667) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 15)
  SkySceneKit.cleanup_npcs()
end
