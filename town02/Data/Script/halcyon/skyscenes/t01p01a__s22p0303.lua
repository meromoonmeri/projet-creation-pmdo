-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/s22p0303.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_WELCOME_TO_THE_WORLD_OF_POKEMON non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_T01P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Then the next time we met, it was in [CS:N]Palkia[CR]'s\nnightmare.)", french="(Notre deuxième rencontre a eu lieu dans\nle cauchemar de [CS:N]Palkia[CR].)", german="(Beim nächsten Aufeinandertreffen war ich in\ndem Albtraum von [CS:N]Palkia[CR].)", italian="(La volta dopo, l'ho incontrata nell'incubo di\n[CS:N]Palkia[CR].)", spanish="(Después nos volvimos a encontrar en la\npesadilla de [CS:N]Palkia[CR].)"})
  else
  SkySceneKit.say({english="(Then the next time we met, it was in [CS:N]Palkia[CR]'s\nnightmare.)", french="(Notre deuxième rencontre a eu lieu dans\nle cauchemar de [CS:N]Palkia[CR].)", german="(Beim nächsten Aufeinandertreffen war ich in\ndem Albtraum von [CS:N]Palkia[CR].)", italian="(La volta dopo, l'ho incontrata nell'incubo di\n[CS:N]Palkia[CR].)", spanish="(Después nos volvimos a encontrar en la\npesadilla de [CS:N]Palkia[CR].)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That first [CS:N]Cresselia[CR]...[K] We encountered her\nonly in dreams!)", french="(La première [CS:N]Cresselia[CR]...[K] on ne l'a rencontrée\nqu'en rêve!)", german="(Der falschen [CS:N]Cresselia[CR]...[K] Ihr sind wir nur in\nTräumen begegnet!)", italian="(Quella prima [CS:N]Cresselia[CR]...[K] L'abbiamo\nincontrata solo nei sogni!)", spanish="(A aquella [CS:N]Cresselia[CR]...[K] ¡Solo la vimos en\nsueños!)"})
  else
  SkySceneKit.say({english="(That first [CS:N]Cresselia[CR]...[K] We encountered her\nonly in dreams!)", french="(La première [CS:N]Cresselia[CR]...[K] on ne l'a rencontrée\nqu'en rêve!)", german="(Der falschen [CS:N]Cresselia[CR]...[K] Ihr sind wir nur in\nTräumen begegnet!)", italian="(Quella prima [CS:N]Cresselia[CR]...[K] L'abbiamo\nincontrata solo nei sogni!)", spanish="(A aquella [CS:N]Cresselia[CR]...[K] ¡Solo la vimos en\nsueños!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(180) end)
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  local npc_npc_kureseria = SkySceneKit.spawn_npc("cresselia", 384, 176, Direction.DownLeft, "NPC_KURESERIA")
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[CS:N]Darkrai[CR] has the power to create\nrealistic illusions.", french="[CS:N]Darkrai[CR] possède un incroyable\ntalent pour créer des illusions très réalistes.", german="[CS:N]Darkrai[CR] hat die Macht,\nrealistische Trugbilder zu erschaffen.", italian="[CS:N]Darkrai[CR] è in grado di creare\nillusioni realistiche.", spanish="[CS:N]Darkrai[CR] puede crear ilusiones\nque parecen muy reales."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="What [CS:N]Darkrai[CR] was doing...[K]\nwas using his illusions to make you think you\nwere seeing me.", french="En fait, il se servait d'illusions\ncréées de toutes pièces...[K] pour vous faire\ncroire que j'étais là.", german="Was [CS:N]Darkrai[CR] getan hat, war...[K]\nNun, es setzte seine Trugbilder ein, um euch\nglauben zu machen, ihr würdet mich sehen.", italian="Ciò che [CS:N]Darkrai[CR] stava\nfacendo...[K] era usare le sue illusioni\nper farvi credere di vedere me.", spanish="Lo que [CS:N]Darkrai[CR] hacía...[K] era\nusar sus ilusiones para que pensarais que\nestabais viéndome a mí."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="It was all an elaborate ruse to\nget at you, [hero] and [partner]...", french="Tout ça faisait partie d'un\nstratagème savamment orchestré pour vous\natteindre, [hero] et [partner]...", german="Es war eine ausgeklügelte List,\num euch zu schaden, [hero] und\n[partner].", italian="Era un elaborato stratagemma\nper arrivare a voi, [hero] e\n[partner]...", spanish="Todo era un ardid. Solo quería\nencontraros, [hero] y [partner]..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="So that your whole existence\ncould be eliminated.", french="... de manière à effacer toute\ntrace de votre existence.", german="All das geschah, um euch\nendgültig aus dem Weg zu räumen.", italian="In modo da poter eliminare\nla vostra intera esistenza.", spanish=" Para poder eliminaros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 352, 176, Direction.Right, "NPC_PERAPPU")
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 296, 208, Direction.UpRight, "NPC_DOGOOMU")
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "shock", 1) end)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 304, 232, Direction.UpRight, "NPC_BIPPA")
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 376, 248, Direction.Up, "NPC_KIMAWARI")
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "shock", 1) end)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 408, 192, Direction.UpLeft, "NPC_HEIGANI")
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Whaaat?!", french=" Heiiin?!", german=" Waaas?!?", italian=" Cooosa?!", spanish=" ¡¿Quéee?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="To eliminate [hero] and\n[partner]...[K]from this world?", french="Pour éliminer [hero] et\n[partner]...[K] de ce monde?", german="Um [hero] und\n[partner]...[K] von dieser Welt zu entfernen?", italian="Per eliminare [hero] e\n[partner]...[K] da questo mondo?", spanish="¿Cómo?[K] ¿Para eliminar a\n[hero] y [partner] de este mundo?"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" E-eliminate?![K] Those two?!", french="Les... les éliminer?![K] Ces\ndeux-là?!", german=" E-entfernen?!?[K] Diese beiden?!?", italian=" E-Eliminare?![K] Loro due?!", spanish=" ¡¿Eliminar?![K] ¡¿He oído bien?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  local npc_npc_suriipu = SkySceneKit.spawn_npc("drowzee", 400, 232, Direction.Up, "NPC_SURIIPU")
  pcall(function() GROUND:CharSetEmote(npc_npc_suriipu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="Well, it's shocking that he\nwanted to get rid of you...", french="Eh bien, je suis choqué qu'il ait\ncherché à vous éliminer...", german="Es ist schockierend genug, dass\nes euch loswerden wollte...", italian="Beh, è sconvolgente che\nvolesse sbarazzarsi di voi...", spanish="Sé que puede resultar un tanto\nsorprendente..."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="But why would [CS:N]Darkrai[CR] plot\nsomething so complicated?", french="... mais pourquoi [CS:N]Darkrai[CR] est-il\nallé imaginer un plan aussi compliqué?", german="Aber warum heckt [CS:N]Darkrai[CR] dazu\nso einen komplizierten Plan aus?", italian="Ma perché [CS:N]Darkrai[CR] avrebbe\nideato un piano così complesso?", spanish="Pero si no, ¿para qué tramaría\n[CS:N]Darkrai[CR] un plan tan complicado?"})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="Why go to all the trouble of\nusing a [CS:N]Cresselia[CR] impostor?", french="Pourquoi s'embêter à créer\nun double de [CS:N]Cresselia[CR]?", german="Warum der ganze Aufwand mit\neiner [CS:N]Cresselia[CR]-Imitation?", italian="Perché usare una finta\n[CS:N]Cresselia[CR]?", spanish="¿Para qué usar a una [CS:N]Cresselia[CR]\nfalsa?"})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="Wouldn't it be faster to confront\nthem directly in battle?", french="Ça n'aurait pas été plus\nexpéditif de les affronter directement\nen combat?", german="Wäre es nicht einfacher\ngewesen, den offenen Kampf mit ihnen zu\nsuchen?", italian="Non sarebbe stato più veloce\nrisolvere il problema con una lotta?", spanish="¿No habría sido más fácil para\nél enfrentarse en una batalla?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kureseria, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="I would guess...[K]that it was all\nout of fear of [hero] and [partner].", french="J'imagine...[K] que [hero]\net [partner] lui faisaient peur, tout\nsimplement.", german="Ich nehme an,[K] dass es die\nAngst vor [hero] und [partner] dazu\ntrieb.", italian="Immagino...[K] che avesse paura\ndi [hero] e [partner].", spanish="Supongo...[K] que tenía miedo de\n[hero] y [partner]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Darkrai[CR] was afraid...[K]of me and\n[hero]?", french="[CS:N]Darkrai[CR] avait peur...[K]\nde [hero] et moi?", german="[CS:N]Darkrai[CR] hatte Angst...[K]\nVor mir und [hero]?", italian="[CS:N]Darkrai[CR] aveva paura...[K] di me e\ndi [hero]?", spanish="¿[CS:N]Darkrai[CR] tenía miedo...[K] de mí y\nde [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Darkrai[CR] was afraid...[K]of me and\n[hero]?", french="[CS:N]Darkrai[CR] avait peur...[K]\nde [hero] et moi?", german="[CS:N]Darkrai[CR] hatte Angst...[K]\nVor mir und [hero]?", italian="[CS:N]Darkrai[CR] aveva paura...[K] di me e\ndi [hero]?", spanish="¿[CS:N]Darkrai[CR] tenía miedo...[K] de mí y\nde [hero]?"})
  else
  SkySceneKit.say({english="[CS:N]Darkrai[CR] was afraid...[K]of me and\n[hero]?", french="[CS:N]Darkrai[CR] avait peur...[K]\nde [hero] et moi?", german="[CS:N]Darkrai[CR] hatte Angst...[K]\nVor mir und [hero]?", italian="[CS:N]Darkrai[CR] aveva paura...[K] di me e\ndi [hero]?", spanish="¿[CS:N]Darkrai[CR] tenía miedo...[K] de mí y\nde [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kureseria, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Yes.[K] Because [hero] and\n[partner] saved the world once before.", french="Oui.[K] Parce que [hero] et\n[partner] ont déjà sauvé le monde\nune fois...", german="Ja.[K] Weil [hero] und\n[partner] vorher schon einmal die Welt\ngerettet hatten.", italian="Sì.[K] Perché [hero] e\n[partner] avevano già salvato il mondo\nuna volta.", spanish="Sí.[K] Porque [hero] y\n[partner] ya habían salvado el mundo antes."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="That was when they prevented\nthe collapse of [CS:P]Temporal Tower[CR].", french="... en empêchant que la [CS:P]Tour\ndu Temps[CR] ne s'effondre.", german="Damals verhinderten sie den\nZusammenbruch des [CS:P]Zeitturms[CR].", italian="È stato quando hanno impedito il\ncrollo della [CS:P]Torre del Tempo[CR].", spanish="Cuando evitaron la destrucción\nde la [CS:P]Torre del Tiempo[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="But who was really the one that\nput the ruin of [CS:P]Temporal Tower[CR] in motion?", french="Mais qui donc était à l'origine\nde la destruction de la [CS:P]Tour du Temps[CR]?", german="Aber wer war es wirklich, der\ndie Zerstörung des [CS:P]Zeitturms[CR] in Bewegung\ngesetzt hat?", italian="Ma chi ha dato davvero avvio\nalla distruzione della [CS:P]Torre del Tempo[CR]?", spanish="¿Pero quién planeó en realidad\nla destrucción de la [CS:P]Torre del Tiempo[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Who was it that really sought to\nput the planet into paralysis?", french="Qui cherchait à paralyser\nla planète?", german="Wer wollte wirklich den\nPlaneten in Lähmung versetzen?", italian="Chi desiderava davvero\nparalizzare il pianeta?", spanish="¿Quién quería paralizar el\nplaneta?"})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" It was none other than [CS:N]Darkrai[CR].", french=" Nul autre que [CS:N]Darkrai[CR].", german=" Es war kein anderer als [CS:N]Darkrai[CR].", italian=" Era proprio [CS:N]Darkrai[CR].", spanish="No se trataba de otro que\n[CS:N]Darkrai[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]D-Darkrai[CR] was behind the\ntrouble at [CS:P]Temporal Tower[CR]?!", french="C'était... c'était [CS:N]Darkrai[CR],\nl'instigateur de la catastrophe de la [CS:P]Tour\ndu Temps[CR]?!", german="[CS:N]D-Darkrai[CR] steckt hinter den\nSchwierigkeiten beim [CS:P]Zeitturm[CR]?!?", italian="C'era [CS:N]D-Darkrai[CR] dietro il\ntentativo di distruggere la [CS:P]Torre del Tempo[CR]?!", spanish="¡¿[CS:N]Da[CR]... [CS:N]Darkrai[CR] estaba detrás\ndel problema en la [CS:P]Torre del Tiempo[CR]?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]D-Darkrai[CR] was behind the crisis\nat [CS:P]Temporal Tower[CR]?!", french="C'était... c'était [CS:N]Darkrai[CR],\nl'instigateur de la catastrophe de la [CS:P]Tour\ndu Temps[CR]?!", german="[CS:N]D-Darkrai[CR] steckt hinter der\nkritischen Situation beim [CS:P]Zeitturm[CR]?!?", italian="C'era [CS:N]D-Darkrai[CR] dietro il\ntentativo di distruggere la [CS:P]Torre del Tempo[CR]?!", spanish="¡¿[CS:N]Da[CR]... [CS:N]Darkrai[CR] estaba detrás\ndel problema en la [CS:P]Torre del Tiempo[CR]?!"})
  else
  SkySceneKit.say({english="[CS:N]D-Darkrai[CR] was behind the crisis\nat [CS:P]Temporal Tower[CR]?!", french="C'était... c'était [CS:N]Darkrai[CR],\nl'instigateur de la catastrophe de la [CS:P]Tour\ndu Temps[CR]?!", german="[CS:N]D-Darkrai[CR] steckt hinter der\nkritischen Situation beim [CS:P]Zeitturm[CR]?!?", italian="C'era [CS:N]D-Darkrai[CR] dietro il\ntentativo di distruggere la [CS:P]Torre del Tempo[CR]?!", spanish="¡¿[CS:N]Da[CR]... [CS:N]Darkrai[CR] estaba detrás\ndel problema en la [CS:P]Torre del Tiempo[CR]?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[CS:N]Darkrai[CR] intends to enshroud the\nworld in darkness.", french="[CS:N]Darkrai[CR] a l'intention de plonger\nle monde dans l'ombre.", german="[CS:N]Darkrai[CR] plant, die Welt\nin Dunkelheit zu hüllen.", italian="[CS:N]Darkrai[CR] vuole avvolgere il\nmondo nell'oscurità.", spanish="[CS:N]Darkrai[CR] quería sumir al mundo\nen la oscuridad absoluta."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[CS:N]Darkrai[CR] failed to do that with\nthe destruction of [CS:P]Temporal Tower[CR].", french="Il a échoué dans sa tentative\nde détruire la [CS:P]Tour du Temps[CR].", german="[CS:N]Darkrai[CR] versagte bei der\nZerstörung des [CS:P]Zeitturms[CR].", italian="Non è riuscito a distruggere\nla [CS:P]Torre del Tempo[CR].", spanish="Como fracasó en la destrucción\nde la [CS:P]Torre del Tiempo[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="After that failure, he turned his\nattention to the distortion of space itself.", french="Après cet échec, son attention\ns'est tournée vers la distorsion de l'espace.", german="Nach seinem Scheitern wandte\nes seine Aufmerksamkeit der Verzerrung des\nRaumes zu.", italian="Allora si è concentrato sulla\ndistorsione dello spazio.", spanish="Se centró en la deformación del\nespacio."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="If the distortion of space were\nto grow, [CS:N]Darkrai[CR]'s power to create nightmares\nwould also grow.", french="Si la distorsion de l'espace\nprenait de l'ampleur, sa faculté à créer des\ncauchemars aussi.", german="Wäre die Verzerrung des\nRaumes gewachsen, wäre auch die Macht von\n[CS:N]Darkrai[CR], Albträume zu erschaffen, gewachsen.", italian="Se la distorsione si allargasse,\ncrescerebbe anche la capacità di [CS:N]Darkrai[CR] di\ncreare incubi.", spanish="De haber seguido aumentando,\n[CS:N]Darkrai[CR] habría podido crear pesadillas más\nintensas."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="What he sought to do was\nenvelop all Pokémon in a nightmare.", french="En fait, il cherchait à engloutir\ntous les Pokémon dans un cauchemar.", german="Es trachtete danach, alle\nPokémon in einen Albtraum zu hüllen.", italian="Il suo obiettivo era imprigionare\ntutti i Pokémon in un incubo.", spanish="Su objetivo era atrapar a todos\nlos Pokémon en una pesadilla."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="It was all [CS:N]Darkrai[CR]'s doing...[K]\nHe was making the distortion of space expand.", french="Tout était la faute\nde [CS:N]Darkrai[CR]...[K] Il faisait en sorte que\nla distorsion de l'espace s'aggrave.", german="Es war alles das Schaffen von\n[CS:N]Darkrai[CR]...[K] Es ließ zu, dass die Verzerrung\ndes Raumes sich ausbreitete.", italian="È stata tutta opera di\n[CS:N]Darkrai[CR]...[K] Stava cercando di far espandere\nla distorsione dello spazio.", spanish="Todo ha sido obra de [CS:N]Darkrai[CR]...[K]\nÉl era quien estaba aumentando la distorsión\ndel espacio."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Darkrai[CR] was doing that?", french=" Vraiment?", german=" [CS:N]Darkrai[CR] hat das getan?", italian=" Era opera di [CS:N]Darkrai[CR]?", spanish="¿Que [CS:N]Darkrai[CR] estaba haciendo\nqué?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Darkrai[CR] was doing that?", french=" Vraiment?", german=" [CS:N]Darkrai[CR] hat das getan?", italian=" Era opera di [CS:N]Darkrai[CR]?", spanish="¿Que [CS:N]Darkrai[CR] estaba haciendo\nqué?"})
  else
  SkySceneKit.say({english=" [CS:N]Darkrai[CR] was doing that?", french=" Vraiment?", german=" [CS:N]Darkrai[CR] hat das getan?", italian=" Era opera di [CS:N]Darkrai[CR]?", spanish="¿Que [CS:N]Darkrai[CR] estaba haciendo\nqué?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Isn't the space distortion\nexpanding because of our existence?", french="Je croyais que la distorsion de\nl'espace s'aggravait à cause de notre existence.", german="Dehnt sich die Verzerrung des\nRaumes nicht wegen unserer Existenz aus?", italian="Ma la distorsione dello spazio\nnon si sta espandendo a causa della nostra\nesistenza?", spanish="Pero, ¿no se estaba deformando\nel espacio por culpa nuestra?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Isn't the space distortion\nexpanding because of our existence?", french="Je croyais que la distorsion de\nl'espace s'aggravait à cause de notre existence.", german="Dehnt sich die Verzerrung des\nRaumes nicht wegen unserer Existenz aus?", italian="Ma la distorsione dello spazio\nnon si sta espandendo a causa della nostra\nesistenza?", spanish="Pero, ¿no se estaba deformando\nel espacio por culpa nuestra?"})
  else
  SkySceneKit.say({english="Isn't the space distortion\nexpanding because of our existence?", french="Je croyais que la distorsion de\nl'espace s'aggravait à cause de notre existence.", german="Dehnt sich die Verzerrung des\nRaumes nicht wegen unserer Existenz aus?", italian="Ma la distorsione dello spazio\nnon si sta espandendo a causa della nostra\nesistenza?", spanish="Pero, ¿no se estaba deformando\nel espacio por culpa nuestra?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="It is true that your existence is\ncausing space distortion...", french="C'est vrai, votre existence\nengendre une distorsion de l'espace...", german="Es stimmt, dass eure Existenz\nVerzerrungen im Raum verursacht...", italian="È vero che la vostra esistenza\nsta causando la distorsione dello spazio...", spanish="Es verdad que vuestra existencia\nestá deformando el espacio..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="But the distortion you cause is\nextremely small.", french="... mais cette distorsion-là est\ninfime.", german="Aber diese Verzerrungen sind\nextrem klein.", italian="Tuttavia, la distorsione causata\nda voi è estremamente limitata.", spanish=" Pero de una manera ínfima."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Furthermore, your distortion of\nspace won't expand on its own.", french="Qui plus est, elle ne s'aggravera\npas toute seule.", german="Außerdem würde sich die auf\neuch zurückführbare Raumverzerrung nicht\nvon selbst ausdehnen.", italian="Inoltre, la distorsione\nda voi causata non si espande da sola.", spanish="Además, la deformación del\nespacio no aumenta por sí sola."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Th-then...", french=" A-alors...", german=" D-dann...", italian=" A-Allora...", spanish=" Pero entonces..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Th-then...", french=" A-alors...", german=" D-dann...", italian=" A-Allora...", spanish=" Pero entonces..."})
  else
  SkySceneKit.say({english=" Th-then...", french=" A-alors...", german=" D-dann...", italian=" A-Allora...", spanish=" Pero entonces..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Yes.[K] The expanding distortion of\nspace has nothing to do with you.", french="Oui.[K] Le fait que la distorsion de\nl'espace s'étende n'a rien à voir avec vous.", german="Ja.[K] Die um sich greifende\nRaumverzerrung hat nichts mit euch zu tun.", italian="Sì.[K] L'espansione della\ndistorsione dello spazio non ha niente a che\nfare con voi.", spanish="Sí.[K] Que hubiera cada vez más\nespacio distorsionado no es culpa vuestra."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="It was blamed on you, however,\nso that you would be eliminated.", french="Néanmoins, il a cherché à vous\nfaire endosser cette faute de manière à vous\nfaire éliminer.", german="Euch wurde die Schuld gegeben.\nAls Anlass, euch zu entfernen.", italian="Vi è stata addossata la colpa\nper potervi eliminare.", spanish="Os culpó con la intención de\npoder quitaros de en medio."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="It was all part of [CS:N]Darkrai[CR]'s\nelaborate deception.", french="Encore une ruse machiavélique\nde [CS:N]Darkrai[CR].", german="Es war alles Teil der\nausgeklügelten Täuschung von [CS:N]Darkrai[CR].", italian="Faceva tutto parte del piano di\n[CS:N]Darkrai[CR].", spanish="Todo formaba parte del engaño\nurdido por [CS:N]Darkrai[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_IN_THE_HANDS_OF_FATE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, [hero]!", french=" Oh, [hero]!", german=" Oh, [hero]!", italian=" Oh, [hero]!", spanish=" ¡Oh, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, [hero]!", french=" Oh, [hero]!", german=" Oh, [hero]!", italian=" Oh, [hero]!", spanish=" ¡Oh, [hero]!"})
  else
  SkySceneKit.say({english=" Oh, [hero]!", french=" Oh, [hero]!", german=" Oh, [hero]!", italian=" Oh, [hero]!", spanish=" ¡Oh, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, partner, 4) end)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 312, 184, Direction.Right, "NPC_PUKURIN")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, partner, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, partner, 4) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 336, 248, Direction.Up, "NPC_CHIRIIN")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, partner, 4) end)
  GAME:WaitFrames(5)
  local npc_npc_ruriri = SkySceneKit.spawn_npc("azurill", 376, 224, Direction.Up, "NPC_RURIRI")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_ruriri, partner, 4) end)
  local npc_npc_mariru = SkySceneKit.spawn_npc("marill", 376, 208, Direction.Up, "NPC_MARIRU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_suriipu, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I... I...[K] I'm so glad...", french=" Je...[K] je suis si content...", german=" Ich... Ich...[K] Ich bin so froh...", italian=" Sono... Sono...[K] così felice...", spanish=" Me...[K] Me alegro tanto..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I... I...[K] I'm so glad...", french=" Je...[K] je suis si content...", german=" Ich... Ich...[K] Ich bin so froh...", italian=" Sono... Sono...[K] così felice...", spanish=" Me...[K] Me alegro tanto..."})
  else
  SkySceneKit.say({english=" I... I...[K] I'm so glad...", french=" Je...[K] je suis si contente...", german=" Ich... Ich...[K] Ich bin so froh...", italian=" Sono... Sono...[K] così felice...", spanish=" Me...[K] Me alegro tanto..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We're not...[K]beings that must\nnot exist...", french="Tout compte fait...[K] nous ne\nsommes pas des anomalies de la nature...", german="Wir sind keine...[K] Wesen, die\nnicht existieren dürfen...", italian="Non è vero...[K] che non dobbiamo\nesistere.", spanish="No tenemos...[K] por qué dejar de\nexistir..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We're not...[K]beings that must\nnot exist...", french="Tout compte fait...[K] nous ne\nsommes pas des anomalies de la nature...", german="Wir sind keine...[K] Wesen, die\nnicht existieren dürfen...", italian="Non è vero...[K] che non dobbiamo\nesistere.", spanish="No tenemos...[K] por qué dejar de\nexistir..."})
  else
  SkySceneKit.say({english="We're not...[K]beings that must\nnot exist...", french="Tout compte fait...[K] nous ne\nsommes pas des anomalies de la nature...", german="Wir sind keine...[K] Wesen, die\nnicht existieren dürfen...", italian="Non è vero...[K] che non dobbiamo\nesistere.", spanish="No tenemos...[K] por qué dejar de\nexistir..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's OK for us to live in this\nworld...[K] We're not unwanted...", french="On a le droit de continuer\nà vivre dans ce monde...[K] On n'est pas\ndes indésirables...", german="Wir dürfen in dieser Welt\nleben...[K] Wir sind nicht unerwünscht...", italian="Possiamo rimanere in questo\nmondo...[K] Non dobbiamo sparire.", spanish="Podemos vivir en este mundo...[K]\nsin problemas..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's OK for us to live in this\nworld...[K] We're not unwanted...", french="On a le droit de continuer\nà vivre dans ce monde...[K] On n'est pas\ndes indésirables...", german="Wir dürfen in dieser Welt\nleben...[K] Wir sind nicht unerwünscht...", italian="Possiamo rimanere in questo\nmondo...[K] Non dobbiamo sparire.", spanish="Podemos vivir en este mundo...[K]\nsin problemas..."})
  else
  SkySceneKit.say({english="It's OK for us to live in this\nworld...[K] We're not unwanted...", french="On a le droit de continuer\nà vivre dans ce monde...[K] On n'est pas\ndes indésirables...", german="Wir dürfen in dieser Welt\nleben...[K] Wir sind nicht unerwünscht...", italian="Possiamo rimanere in questo\nmondo...[K] Non dobbiamo sparire.", spanish="Podemos vivir en este mundo...[K]\nsin problemas..."})
  end
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urf...", french=" Ah...", german=" Uff...", italian=" Aah...", spanish=" Uf..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urf...", french=" Ah...", german=" Uff...", italian=" Aah...", spanish=" Uf..."})
  else
  SkySceneKit.say({english=" Urf...", french=" Ah...", german=" Uff...", italian=" Aah...", spanish=" Uf..."})
  end
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner]...)", french="([partner]...)", german="([partner]...)", italian="([partner]...)", spanish="([partner]...)"})
  else
  SkySceneKit.say({english="([partner]...)", french="([partner]...)", german="([partner]...)", italian="([partner]...)", spanish="([partner]...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(4), p.Y+(4), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I don't know what you two went\nthrough...[K] But...", french="Je ne prétends pas savoir\nce que vous avez subi...[K] mais...", german="Ich habe keine Ahnung, was ihr\ndurchmachen musstet...[K] Aber...", italian="Non so cosa abbiate passato...[K]\nMa...", spanish="No sé por lo que habréis\npasado...[K] pero..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kureseria, npc_npc_pukurin, 4) end)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_ruriri, Direction.UpLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_suriipu, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="It's just not possible...[K]for either\nof you, [partner] and [hero], to be\nunwanted in this world.", french="... c'est tout bonnement\nimpensable![K] [partner] et [hero],\nvous êtes tout sauf des indésirables ici.", german="Es ist einfach unmöglich...[K] für\neuch, [partner] und [hero], in dieser\nWelt unerwünscht zu sein.", italian="Ma è impossibile...[K] che tu,\n[partner] e tu, [hero], dobbiate\nsparire da questo mondo.", spanish="[partner] y [hero]...[K]\n¡Claro que podéis formar parte de este\nmundo!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="If either of you went\naway, [partner] or [hero]...[K] It would\nmake me sad.", french="Si vous deviez nous quitter,\n[partner] ou [hero]...[K] je serais très\ntriste.", german="Wenn einer von euch fortginge,\n[partner] oder [hero]...[K] Dann\nwürde mich das traurig stimmen.", italian="Se doveste sparire,\n[partner] e [hero]...[K] mi sentirei\nmolto triste.", spanish="Si os marcharais...[K] me daría\nuna pena terrible."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I think everyone at the guild\nwould be sad too.", french="Et je pense que ce serait aussi\nle cas de tout le monde à la Guilde.", german="Und ich denke, alle anderen in\nder Gilde wären auch traurig.", italian="Penso che lo stesso valga per\ntutti gli altri membri della Gilda.", spanish="Creo que a los miembros del\n[CS:N]Pokégremio[CR] también les daría mucha pena."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="It makes us happy that you're\nwith us, [partner] and [hero]! ♪", french="Nous sommes si contents\nde vous avoir avec nous, [partner] et\n[hero]! ♪", german="Wir sind glücklich, dass ihr bei\nuns seid, [partner] und [hero]! ♪", italian="Siamo felici di avervi con noi,\n[partner] e [hero]! ♪", spanish="¡Nos encanta que viváis aquí,\n[partner] y [hero]! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="That's reason enough...[K]to keep\nexisting!", french="C'est une raison suffisante...[K]\npour continuer à exister!", german="Das ist Grund genug,[K] um weiter\nzu existieren!", italian="Questo è un motivo\nsufficiente...[K] per continuare a esistere!", spanish="Y esa es razón suficiente...[K]\n¡para que os quedéis aquí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(3, 2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]W-Wigglytuff[CR]...", french=" [CS:N]G-Grodoudou[CR]...", german=" [CS:N]K-Knuddeluff[CR]...", italian=" [CS:N]W-Wigglytuff[CR]...", spanish=" [CS:N]Wigglytuff[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]W-Wigglytuff[CR]...", french=" [CS:N]G-Grodoudou[CR]...", german=" [CS:N]K-Knuddeluff[CR]...", italian=" [CS:N]W-Wigglytuff[CR]...", spanish=" [CS:N]Wigglytuff[CR]..."})
  else
  SkySceneKit.say({english=" [CS:N]W-Wigglytuff[CR]...", french=" [CS:N]G-Grodoudou[CR]...", german=" [CS:N]K-Knuddeluff[CR]...", italian=" [CS:N]W-Wigglytuff[CR]...", spanish=" [CS:N]Wigglytuff[CR]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="More than that...[K]it's not just\n[partner] or [hero]...", french="Plus généralement...[K] il ne s'agit\npas que de [partner] ou de [hero]...", german="Mehr noch![K] Es geht nicht nur um\n[partner] oder [hero]...", italian="Ma...[K] non si tratta solo di\n[partner] o [hero].", spanish="Y no solo...[K] [partner] y\n[hero]..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Everyone here...", french=" ... tout le monde ici...", german=" Alle hier...", italian=" Tutti...", spanish=" Todos..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" All the Pokémon in the world...", french=" ... tous les Pokémon du monde...", german=" Alle Pokémon in der Welt...", italian="La vita di tutti i Pokémon del\nmondo...", spanish=" Todos los Pokémon del mundo..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Not one of their lives is without\nmeaning!", french=" ... chaque vie a un sens!", german="Keines ihrer Leben ist\nbedeutungslos!", italian=" ... è importante!", spanish=" ¡Cada uno de ellos cuenta!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="So never think that you're not\nwanted ever again.", french="Alors n'allez plus vous imaginer\nque vous êtes indésirables.", german="Also denkt niemals wieder, dass\nihr unerwünscht sein könntet.", italian="Quindi non dovete pensare mai\npiù che noi non vi vogliamo!", spanish="No penséis nunca que no tenéis\nsitio en el mundo."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Stay full of cheer![K] All right? ♪", french="Gardez le sourire![K] C'est\nd'accord? ♪", german=" Seid fröhlich![K] Alles klar? ♪", italian="Cercate di essere sempre\nfelici![K] Va bene? ♪", spanish=" ¡Vivid con alegría![K] ¿Vale? ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(3, 2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urf...[K] Thanks, [CS:N]Wigglytuff[CR]...", french=" Ah...[K] Merci, [CS:N]Grodoudou[CR]...", german=" Uff...[K] Danke, [CS:N]Knuddeluff[CR]...", italian=" Oh...[K] Grazie, [CS:N]Wigglytuff[CR].", spanish=" Uf...[K] Gracias, [CS:N]Wigglytuff[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urf...[K] Thank you, [CS:N]Wigglytuff[CR]...", french=" Ah...[K] Merci, [CS:N]Grodoudou[CR]...", german=" Uff...[K] Danke, [CS:N]Knuddeluff[CR]...", italian=" Oh...[K] Grazie, [CS:N]Wigglytuff[CR].", spanish=" Uf...[K] Gracias, [CS:N]Wigglytuff[CR]..."})
  else
  SkySceneKit.say({english=" Urf...[K] Thank you, [CS:N]Wigglytuff[CR]...", french=" Ah...[K] Merci, [CS:N]Grodoudou[CR]...", german=" Uff...[K] Danke, [CS:N]Knuddeluff[CR]...", italian=" Oh...[K] Grazie, [CS:N]Wigglytuff[CR].", spanish=" Uf...[K] Gracias, [CS:N]Wigglytuff[CR]..."})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(160) end)
  GAME:WaitFrames(160)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! But talk about dirty\nand dishonest! That [CS:N]Darkrai[CR]'s a piece of work!", french="Eh dis donc, en parlant de\nméchanceté et de malhonnêteté, ce [CS:N]Darkrai[CR],\nc'est le summum!", german="Hey, hey! Aber was für ein\nunehrlicher und schmutziger Fiesling [CS:N]Darkrai[CR]\nist!", italian="Ehi, ehi! Ma a proposito di\nPokémon cattivi e disonesti! Quel [CS:N]Darkrai[CR] è\nproprio un tipaccio!", spanish="¡Oye, oye! ¡Ese [CS:N]Darkrai[CR] solo\nsabe jugar sucio!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kureseria, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="He never comes out in the open.\nHe does his nefarious work from the shadows.", french="Il ne se montre jamais au grand\njour. Il passe son temps à intriguer en restant\nà couvert.", german="Es zeigt sich niemals im Licht.\nEs verrichtet sein unheilvolles Werk aus dem\nSchatten.", italian="Non esce mai allo scoperto.\nRimane a tramare nell'oscurità.", spanish="Nunca sale a la luz. Se mueve\nen las sombras."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_kureseria, 4) end)
  GROUND:EntTurn(partner, Direction.UpRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_kureseria, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_kureseria, 4) end)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_kureseria, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_kureseria, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_kureseria, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_ruriri, npc_npc_kureseria, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, npc_npc_kureseria, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_suriipu, npc_npc_kureseria, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_kureseria, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="If you confront him, he will\nalways flee...", french="Il fuit toujours les\naffrontements directs...", german=" Stellt man es, dann flieht es.", italian="Se lo si affronta,\nscappa sempre...", spanish="Si le plantas cara, seguro que\nhuye..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="That is how [CS:N]Darkrai[CR] has always\ndone things.", french="[CS:N]Darkrai[CR] s'est toujours comporté\nde la sorte.", german="So hat [CS:N]Darkrai[CR] schon\nimmer gehandelt.", italian="È così che [CS:N]Darkrai[CR] ha sempre\nagito.", spanish=" Así ha sido siempre [CS:N]Darkrai[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="But [CS:N]Darkrai[CR] is doing something\nso unlike him right now...", french="Mais il a fait quelque chose\nqui ne lui ressemble guère...", german="Aber [CS:N]Darkrai[CR] verhält sich\nauf einmal so untypisch...", italian="Ma [CS:N]Darkrai[CR] si sta comportando\nin un modo molto diverso adesso.", spanish="Pero [CS:N]Darkrai[CR] ha hecho algo muy\nimpropio de él en esta ocasión..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="He has invited [partner] and\n[hero] to confront him...", french="Il a invité [partner] et\n[hero] à venir l'affronter...", german="Es hat [partner] und\n[hero] eingeladen, sich ihm\nentgegenzustellen...", italian="Ha invitato [partner] e\n[hero] a battersi con lui.", spanish="Ha invitado a [partner] y a\n[hero] a enfrentarse con él..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...It's true.)", french="(... C'est vrai.)", german="(Das stimmt.)", italian="(È vero.)", spanish="(Es verdad.)"})
  else
  SkySceneKit.say({english="(...It's true.)", french="(... C'est vrai.)", german="(Das stimmt.)", italian="(È vero.)", spanish="(Es verdad.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:N]Darkrai[CR] left these parting words...)", french="(C'est la dernière chose que [CS:N]Darkrai[CR] ait dite...)", german="([CS:N]Darkrai[CR] ging mit diesen Worten.)", italian="([CS:N]Darkrai[CR] è scomparso con queste parole...)", spanish="([CS:N]Darkrai[CR] se fue con esas palabras...)"})
  else
  SkySceneKit.say({english="([CS:N]Darkrai[CR] left these parting words...)", french="(C'est la dernière chose que [CS:N]Darkrai[CR] ait dite...)", german="([CS:N]Darkrai[CR] ging mit diesen Worten.)", italian="([CS:N]Darkrai[CR] è scomparso con queste parole...)", spanish="([CS:N]Darkrai[CR] se fue con esas palabras...)"})
  end
  -- message_Close
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
