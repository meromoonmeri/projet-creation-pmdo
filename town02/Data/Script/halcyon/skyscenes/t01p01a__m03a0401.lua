-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/m03a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  SkyProg.set(4, 3) -- $SCENARIO_MAIN = scn[4,3] (ROM)
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! What's that about?", french="Hé! Qu'est-ce qui se passe\nlà-bas?", german=" Hey! Was ist denn da los?", italian=" Ehi! Cosa succede?", spanish=" ¡Eh! ¿Qué está pasando allí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh![K] What's going on there?", french="Hé! Qu'est-ce qui se passe\nlà-bas?", german=" Oh![K] Was ist denn da los?", italian=" Ehi![K] Cosa succede?", spanish=" ¡Eh![K] ¿Qué está pasando allí?"})
  else
  SkySceneKit.say({english=" Say![K] What are they up to?", french="Hé! Qu'est-ce qui se passe\nlà-bas?", german="Na so was![K] Was machen die\ndenn?", italian=" Ehi![K] Cosa succede?", spanish=" ¡Oye![K] ¿Qué está pasando allí?"})
  end
  -- message_Close
  -- SetPositionLives(0) [cible objet/id de décor NDS non simulée - trace]
  -- camera_SetMyself() [neutre/état moteur]
  -- Move2PositionMark 0 [cible sans placement SSA zone: mouvement non joué]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  local npc_npc_ruriri = SkySceneKit.spawn_npc("azurill", 376, 144, Direction.Left, "NPC_RURIRI")
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "happy", 1) end)
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" Yaaaay!", french=" Youpi!", german=" Jippieee!", italian=" Yaaaay!", spanish=" ¡Síiii!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, nil, 0) end) -- EFFECT_NONE
  local npc_npc_mariru = SkySceneKit.spawn_npc("marill", 376, 168, Direction.Left, "NPC_MARIRU")
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Thank you!", french=" Merci!", german=" Vielen Dank!", italian=" Grazie!", spanish=" ¡Gracias!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_suriipu = SkySceneKit.spawn_npc("drowzee", 344, 152, Direction.Right, "NPC_SURIIPU")
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Please! It's nothing.", french=" De rien! Ce n'est rien.", german=" Bitte! Nicht der Rede wert.", italian=" Non c'è di che.", spanish=" ¡No hay de qué!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(48), p.Y+(0), false, 2) end
  GAME:WaitFrames(10)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(48), p.Y+(0), false, 2) end
  GROUND:MoveToPosition(hero, 376, 188, false, 2)
  GROUND:MoveToPosition(partner, 344, 188, false, 2)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What's going on?", french=" Il y a un problème?", german=" Was geht hier vor?", italian=" Cosa succede?", spanish=" ¿Qué pasa aquí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What's going on?", french=" Il y a un problème?", german=" Was geht hier vor?", italian=" Cosa succede?", spanish=" ¿Qué ocurre?"})
  else
  SkySceneKit.say({english=" What's happening?", french=" Il y a un problème?", german="Was gibt es bei euch\nInteressantes?", italian=" Cosa succede?", spanish=" ¿Qué sucede?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_ruriri, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_suriipu, partner, 4) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" Oh! Hi!", french=" Oh! Bonjour!", german=" Oh! Hallo!", italian=" Oh! Salve!", spanish=" ¡Ah! ¡Hola!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="Some time ago, we lost an item\nthat's pretty important to us...", french="Il y a quelque temps, on a perdu\nun objet auquel on tient beaucoup...", german="Vor einiger Zeit haben wir ein\nItem verloren, das uns sehr wichtig ist.", italian="Qualche tempo fa, abbiamo perso\nuno strumento che ci sta molto a cuore...", spanish="Hace tiempo que perdimos un\nobjeto muy importante..."})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="We've been looking all over...[K]\nBut we haven't found it yet!", french="On l'a cherché partout...[K]\nMais on ne l'a pas encore trouvé!", german="Wir haben schon überall\ngesucht...[K] Aber wir haben es noch nicht\ngefunden!", italian="Lo abbiamo cercato\ndappertutto...[K] ma non lo abbiamo\nancora trovato!", spanish="Lo hemos estado buscando\npor todas partes...[K] pero aún no hemos\npodido encontrarlo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, npc_npc_suriipu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_ruriri, npc_npc_suriipu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Then Mr. [CS:N]Drowzee[CR] came along...", french=" Puis M. [CS:N]Soporifik[CR] est venu...", german=" Dann kam Herr [CS:N]Traumato[CR]...", italian="Poi è arrivato il signor\n[CS:N]Drowzee[CR]...", spanish=" Entonces apareció el Sr. [CS:N]Drowzee[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="And he says he may have seen\nour lost item somewhere!", french="Et il nous a dit qu'il avait vu\nnotre objet quelque part!", german="Er sagt, er habe unser\nverlorenes Item wahrscheinlich irgendwo\ngesehen!", italian="Ci ha detto che potrebbe\naverlo visto da qualche parte!", spanish="¡Y dice que ha visto nuestro objeto\nen alguna parte!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_ruriri, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="He even offered to help us look\nfor it.", french="Il nous a même proposé son aide\npour le trouver.", german="Er hat sogar angeboten, uns bei\nder Suche zu helfen.", italian="Si è anche offerto di aiutarci a\ncercarlo.", spanish="Hasta se ha ofrecido a ayudarnos\na buscarlo."})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" We're so happy about this!", french=" On est tellement contents!", german=" Wir sind ja so froh darüber!", italian=" Siamo così contenti!", spanish=" ¡Estamos tan contentos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Awesome! That's great for you!", french=" Génial! C'est super!", german=" Super! Das ist ja toll!", italian="Fantastico! È un'ottima notizia\nper voi!", spanish="¡Genial! ¡Me alegro\npor vosotros!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yeah! That's great for you!", french=" Génial! C'est super!", german=" Toll! Das freut mich für euch!", italian="Fantastico! È un'ottima notizia\nper voi!", spanish="¡Muy bien! ¡Me alegro\npor vosotros!"})
  else
  SkySceneKit.say({english=" Is that right? How nice for you!", french=" Génial! C'est super!", german=" Wirklich? Das ist ja toll!", italian="Fantastico! È un'ottima notizia\nper voi!", spanish=" ¿Ah, sí? ¡Eso es estupendo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_ruriri, npc_npc_suriipu, 4) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, npc_npc_suriipu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_suriipu, npc_npc_ruriri, 4) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" Thank you, Mr. [CS:N]Drowzee[CR]!", french=" Merci, M. [CS:N]Soporifik[CR]!", german=" Vielen Dank, Herr [CS:N]Traumato[CR]!", italian=" Grazie, signor [CS:N]Drowzee[CR]!", spanish=" ¡Gracias, Sr. [CS:N]Drowzee[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Oh, please...", french=" Oh, de rien...", german=" Aber bitte...", italian=" Non c'è di che...", spanish=" No es nada..."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="I'd have to have a cold heart to\nignore kids in need! I can't turn a blind eye!", french="Il faudrait avoir un cœur de\npierre pour ne pas aider ces enfants dans\nle besoin! Je ne peux pas fermer les yeux!", german="Ich müsste ein Herz aus Stein\nhaben, armen Kindern nicht zu helfen! Da kann\nich einfach nicht wegsehen.", italian="Dovrei proprio essere senza\ncuore per non aiutare dei ragazzi come voi!\nNon posso far finta di niente!", spanish="¡Tendría que ser un desalmado\npara no ayudaros, chiquillos!"})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="Let us be on our way to begin\nour search!", french=" Commençons nos recherches!", german="Lasst uns aufbrechen und mit\nder Suche beginnen!", italian="Forza, partiamo e andiamo a\ncercare lo strumento!", spanish=" ¡Vamos a buscar ese objeto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Yup!", french=" Ouais!", german=" Ja!", italian=" Sì!", spanish=" ¡Sí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" Yup!", french=" Ouais!", german=" Ja!", italian=" Sì!", spanish=" ¡Sí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_mariru, 536, 220, false, 2)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(partner, Direction.Right)
  -- ResetHitAttribute(31) [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_ruriri, 536, 196, false, 2)
  GAME:WaitFrames(10)
  -- ResetHitAttribute(31) [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_suriipu, 400, 196, false, 2)
  GAME:WaitFrames(45)
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(6414) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(4), p.Y+(0), false, 2) end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-4), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_suriipu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Whoops![K] Excuse me.", french=" Oh![K] Pardon.", german=" Hoppla![K] Entschuldigung.", italian=" Ops![K] Scusa.", spanish=" ¡Vaya![K] Perdón."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_suriipu, 520, 196, false, 2)
  GAME:WaitFrames(30)
  -- GAP: se_Play(5133) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Urk...[K] Wh-what is this...?)", french="(Argh...[K] Mais qu'est-ce que...?)", german="(Urks...[K] W-was ist das?)", italian="(Urk...[K] C-C-Cosa...?)", spanish="(¡Ay!...[K] ¿Qué... qué está pasando?)"})
  else
  SkySceneKit.say({english="(Urk...[K] Wh-what is this...?)", french="(Argh...[K] Mais qu'est-ce que...?)", german="(Urks...[K] W-was ist das?)", italian="(Urk...[K] C-C-Cosa...?)", spanish="(¡Ay!...[K] ¿Qué... qué está pasando?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That [CS:N]Drowzee[CR] is sure a nice\nPokémon.[K] You've got to admire that.", french="Ce [CS:N]Soporifik[CR] est vraiment\nserviable.[K] Un exemple à suivre.", german="Dieser [CS:N]Traumato[CR] ist aber ein\nnettes Pokémon.[K] Wirklich bewundernswert.", italian="Quel [CS:N]Drowzee[CR] è davvero un\nPokémon in gamba.[K] Veramente ammirevole.", spanish="Ese [CS:N]Drowzee[CR] es un Pokémon\nmuy amable.[K] Resulta digno de admiración."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That [CS:N]Drowzee[CR] sure is a nice\nPokémon, isn't he?[K] I'm impressed.", french="Ce [CS:N]Soporifik[CR] est vraiment\nserviable.[K] Un exemple à suivre.", german="Dieser [CS:N]Traumato[CR] ist aber ein\nnettes Pokémon, oder?[K] Ich bin beeindruckt.", italian="Quel [CS:N]Drowzee[CR] è davvero un\nPokémon gentile.[K] Da ammirare!", spanish="Ese [CS:N]Drowzee[CR] es un Pokémon\nmuy amable, ¿verdad?[K] Estoy impresionado."})
  else
  SkySceneKit.say({english="That [CS:N]Drowzee[CR] sure is nice.[K]\nYou've got to admire that!", french="Ce [CS:N]Soporifik[CR] est vraiment\nserviable.[K] Un exemple à suivre.", german="Dieser [CS:N]Traumato[CR] ist aber ein\nnettes Pokémon.[K] Wirklich bewundernswert!", italian="Quel [CS:N]Drowzee[CR] è davvero un\nPokémon gentile.[K] Veramente di buon cuore!", spanish="Ese [CS:N]Drowzee[CR] les está\nhaciendo un gran favor.[K] ¡Es admirable!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="With more and more bad\nPokémon around...[K]it's hard to do good deeds.", french="Avec le nombre croissant de\nméchants Pokémon aux alentours...[K] les actes\nde pure bienveillance se font rares.", german="Jetzt, wo es immer mehr böse\nPokémon gibt,[K] findet man gute Taten nur noch\nselten.", italian="Con tutti i Pokémon cattivi che\nci sono in giro...[K] è difficile fare buone azioni.", spanish="Con tantos Pokémon malvados\npor ahí sueltos...[K] ya no es frecuente\ndar con alguien honrado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="With more and more bad\nPokémon around...[K]it's hard to do good deeds.", french="Avec le nombre croissant de\nméchants Pokémon aux alentours...[K] les actes\nde pure bienveillance se font rares.", german="Jetzt, wo es immer mehr böse\nPokémon gibt,[K] findet man gute Taten nur noch\nselten.", italian="Con tutti i Pokémon cattivi che\nci sono in giro...[K] è difficile fare buone azioni.", spanish="Con tantos Pokémon malvados\npor ahí sueltos...[K] ya no es frecuente\ndar con alguien honrado."})
  else
  SkySceneKit.say({english="With more and more bad\nPokémon around...[K]it's hard to do good deeds.", french="Avec le nombre croissant de\nméchants Pokémon aux alentours...[K] les actes\nde pure bienveillance se font rares.", german="Jetzt, wo es immer mehr böse\nPokémon gibt,[K] findet man gute Taten nur noch\nselten.", italian="Con tutti i Pokémon cattivi che\nci sono in giro...[K] è difficile fare buone azioni.", spanish="Con tantos Pokémon malvados\npor ahí sueltos...[K] ya no es frecuente\ndar con alguien honrado."})
  end
  -- message_Close
  -- GAP: se_Play(5133) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's happening again...)", french="(Ça recommence...)", german="(Es passiert schon wieder.)", italian="(Sta succedendo di nuovo...)", spanish="(Me está volviendo a pasar...)"})
  else
  SkySceneKit.say({english="(It's happening again...)", french="(Ça recommence...)", german="(Es passiert schon wieder.)", italian="(Sta succedendo di nuovo...)", spanish="(Me está volviendo a pasar...)"})
  end
  -- message_Close
  -- GAP: se_Play(5133) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Another dizzy spell...)", french="(Mes vertiges recommencent...)", german="(Noch ein Schwindelanfall...)", italian="(Un altro capogiro...)", spanish="(Otra vez ese mareo...)"})
  else
  SkySceneKit.say({english="(Another dizzy spell...)", french="(Mes vertiges recommencent...)", german="(Noch ein Schwindelanfall...)", italian="(Un altro capogiro...)", spanish="(Otra vez ese mareo...)"})
  end
  -- message_Close
  GAME:FadeOut(false,  5)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
