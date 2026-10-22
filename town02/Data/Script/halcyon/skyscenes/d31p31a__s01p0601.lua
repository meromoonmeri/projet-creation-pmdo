-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D31P31A/s01p0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(45, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  SkyProg.set(29, 4) -- $SCENARIO_MAIN = scn[29,4] (ROM)
  -- back_SetGround(LEVEL_D31P31A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(partner, 212, 308, false, 2)
  GROUND:MoveToPosition(hero, 244, 308, false, 2)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I guess we're in pretty deep.", french="On a déjà bien avancé dans\ncette forêt.", german="Ich schätze, wir sind ganz\nschön tief drin.", italian="Credo che siamo abbastanza\nall'interno.", spanish="Supongo que ya nos hemos\nadentrado bastante."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I think we've come quite deep.", french="On a déjà bien avancé dans\ncette forêt.", german="Ich glaube, wir sind recht tief\nvorgedrungen.", italian="Penso che siamo abbastanza\nall'interno.", spanish="Creo que nos hemos adentrado\nbastante."})
  else
  SkySceneKit.say({english="We've come a long ways into\nthe forest.", french="On a déjà bien avancé dans\ncette forêt.", german="Wir sind sehr tief in den Wald\nvorgedrungen.", italian="Penso che siamo abbastanza\nall'interno.", spanish="Nos hemos adentrado mucho en\nel bosque."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:P]Luminous Spring[CR] must be\nup ahead.", french="La [CS:P]Source Lumineuse[CR] ne doit\nplus être très loin.", german="Die [CS:P]Glitzerquelle[CR] muss\nvor uns liegen.", italian="La [CS:P]Sorgente Luccichio[CR] deve\nessere poco più avanti.", spanish="El [CS:P]Manantial Luminoso[CR] no puede\nestar muy lejos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:P]Luminous Spring[CR] can't be too\nmuch farther.", french="La [CS:P]Source Lumineuse[CR] ne doit\nplus être très loin.", german="Die [CS:P]Glitzerquelle[CR] kann nicht mehr\nsehr weit sein.", italian="La [CS:P]Sorgente Luccichio[CR] deve\nessere poco più avanti.", spanish="El [CS:P]Manantial Luminoso[CR] no puede\nandar muy lejos."})
  else
  SkySceneKit.say({english="[CS:P]Luminous Spring[CR] must be\ncoming up.", french="La [CS:P]Source Lumineuse[CR] ne doit\nplus être très loin.", german="Die [CS:P]Glitzerquelle[CR] muss hier\ngleich sein.", italian="La [CS:P]Sorgente Luccichio[CR] deve\nessere poco più avanti.", spanish="El [CS:P]Manantial Luminoso[CR] no debe\nquedar muy lejos."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_himeguma = SkySceneKit.spawn_npc("teddiursa", 216, 440, Direction.Up, "NPC_HIMEGUMA")
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end) -- message_SetActor(ACTOR_NPC_HIMEGUMA)
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" Oh! [partner]! [hero]!", french=" Oh! [partner]! [hero]!", german=" Oh! [partner]! [hero]!", italian=" Oh! [partner]! [hero]!", spanish="¡Oh! ¡[partner]!\n¡[hero]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Down)
  GROUND:EntTurn(hero, Direction.Down)
  pcall(function() GAME:MoveCamera(228, 340, 60, false) end) -- performer/caméra
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  GROUND:MoveToPosition(npc_npc_himeguma, 212, 348, false, 2)
  local npc_npc_ringuma = SkySceneKit.spawn_npc("ursaring", 248, 456, Direction.Up, "NPC_RINGUMA")
  GROUND:MoveToPosition(npc_npc_ringuma, 244, 348, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! [CS:N]Teddiursa[CR] and [CS:N]Ursaring[CR]!", french=" Tiens! [CS:N]Teddiursa[CR] et [CS:N]Ursaring[CR]!", german=" Hey! [CS:N]Teddiursa[CR] und [CS:N]Ursaring[CR]!", italian=" Ehi! Sono [CS:N]Teddiursa[CR] e [CS:N]Ursaring[CR]!", spanish=" Mira, ¡[CS:N]Teddiursa[CR] y [CS:N]Ursaring[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! [CS:N]Teddiursa[CR] and [CS:N]Ursaring[CR]!", french=" Tiens! [CS:N]Teddiursa[CR] et [CS:N]Ursaring[CR]!", german=" Hey! [CS:N]Teddiursa[CR] und [CS:N]Ursaring[CR]!", italian=" Ehi! Sono [CS:N]Teddiursa[CR] e [CS:N]Ursaring[CR]!", spanish=" Mira, ¡[CS:N]Teddiursa[CR] y [CS:N]Ursaring[CR]!"})
  else
  SkySceneKit.say({english=" Hi! [CS:N]Teddiursa[CR] and [CS:N]Ursaring[CR]!", french=" Tiens! [CS:N]Teddiursa[CR] et [CS:N]Ursaring[CR]!", german=" Hi! [CS:N]Teddiursa[CR] und [CS:N]Ursaring[CR]!", italian=" Ehi! Sono [CS:N]Teddiursa[CR] e [CS:N]Ursaring[CR]!", spanish=" Mira, ¡[CS:N]Teddiursa[CR] y [CS:N]Ursaring[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" You're here too!", french=" Vous êtes là aussi!", german=" Ihr seid auch hier!", italian=" Siete qui anche voi!", spanish=" ¡También estáis aquí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You're here too!", french=" Vous êtes là aussi!", german=" Ihr seid auch hier!", italian=" Siete qui anche voi!", spanish=" ¡También estáis aquí!"})
  else
  SkySceneKit.say({english=" You're here too!", french=" Vous êtes là aussi!", german=" Ihr seid auch hier!", italian=" Siete qui anche voi!", spanish=" ¡También estáis aquí!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" Yup.", french=" Oui.", german=" Jep.", italian=" Sì.", spanish=" Sí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_ringuma, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" We often come play here.", french=" On vient souvent jouer ici.", german="Wir kommen oft zum Spielen\nhierher.", italian=" Veniamo spesso a giocare qui.", spanish="Solemos venir a jugar a este\nsitio."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="So, how's it going?[K] Did you see\nyour grand master of all things bad?", french="Alors, comment ça se passe?[K]\nVous l'avez rencontré, votre grand maître\nde tous les maux?", german="Also, wie läuft es denn so?[K] Seid\nihr eurem Großmeister allen Übels begegnet?", italian="Allora, come va?[K] Avete visto\nSua Malvagità?", spanish="Bueno, ¿y qué tal?[K] ¿Habéis visto\nal gran malo requetemalo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="No.[K] We haven't seen anything\nlike that.", french=" Non.[K] Nous ne l'avons pas vu.", german="Nein.[K] Wir haben nichts\ndergleichen gesehen.", italian="No.[K] Non abbiamo incontrato\nnessuno.", spanish="No.[K] No hemos visto nada\nextraño."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" No.[K] Nothing like that.", french=" Non.[K] Nous ne l'avons pas vu.", german=" Nein.[K] Nichts dergleichen.", italian="No.[K] Non abbiamo incontrato\nnessuno.", spanish="Pues no.[K] No hemos visto nada\nparecido."})
  else
  SkySceneKit.say({english=" No.[K] Nothing like that.", french=" Non.[K] Nous ne l'avons pas vu.", german=" Nein.[K] Nichts dergleichen.", italian="No.[K] Non abbiamo incontrato\nnessuno.", spanish="No.[K] No hemos visto nada\nextraño."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="See?[K] I told you that you only\nheard a rumor.", french="Vous voyez?[K] Je vous avais bien\ndit que ce n'était qu'une rumeur.", german="Seht ihr?[K] Ich habe euch gesagt,\nihr seid einem Gerücht aufgesessen.", italian="Visto?[K] Vi avevo detto che\nerano solo dicerie.", spanish="¿Lo veis?[K] Ya os dije que tenía\nque ser un rumor."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" Why are you two here?", french="Pourquoi est-ce que vous êtes\nlà?", german=" Was macht ihr zwei denn hier?", italian=" Cosa ci fate qui?", spanish=" ¿Y qué hacéis aquí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownLeft)
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="Are you in search of that\ngrand master?", french="C'est ce grand maître que vous\ncherchez?", german="Sucht ihr nach diesem\nGroßmeister?", italian=" State cercando Sua Malvagità?", spanish="¿Seguís buscando a ese tal malo\ntan malo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" No, we're not.", french=" Oh non! Pas du tout.", german=" Nein, tun wir nicht.", italian=" No. Niente del genere.", spanish=" ¿Eh? No."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" No, we're not.", french=" Oh non! Pas du tout.", german=" Nein, tun wir nicht.", italian=" No. Niente del genere.", spanish=" No, no, qué va."})
  else
  SkySceneKit.say({english=" No, we're not.", french=" Oh non! Pas du tout.", german=" Nein, tun wir nicht.", italian=" No, niente del genere.", spanish=" Qué va, no."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We're looking for\n[CS:P]Luminous Spring[CR].", french="Nous cherchons la [CS:P]Source\nLumineuse[CR].", german="Wir suchen nach der\n[CS:P]Glitzerquelle[CR].", italian="Stiamo cercando\nla [CS:P]Sorgente Luccichio[CR].", spanish="Estamos buscando el [CS:P]Manantial[CR]\n[CS:P]Luminoso[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We're searching for\n[CS:P]Luminous Spring[CR].", french="Nous cherchons la [CS:P]Source\nLumineuse[CR].", german="Wir halten nach der\n[CS:P]Glitzerquelle[CR] Ausschau.", italian="Stiamo cercando\nla [CS:P]Sorgente Luccichio[CR].", spanish="Estamos buscando el [CS:P]Manantial[CR]\n[CS:P]Luminoso[CR]."})
  else
  SkySceneKit.say({english="We're trying to find\n[CS:P]Luminous Spring[CR].", french="Nous cherchons la [CS:P]Source\nLumineuse[CR].", german="Wir versuchen die [CS:P]Glitzerquelle[CR]\nzu finden.", italian="Stiamo cercando\nla [CS:P]Sorgente Luccichio[CR].", spanish="Estamos intentando encontrar el\n[CS:P]Manantial Luminoso[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_himeguma, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" Oh, [CS:P]Luminous Spring[CR]?", french=" Oh, la [CS:P]Source Lumineuse[CR]?", german=" Oh, die [CS:P]Glitzerquelle[CR]?", italian=" Oh, la [CS:P]Sorgente Luccichio[CR]?", spanish=" Ah, ¿el [CS:P]Manantial Luminoso[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" That's just up ahead here.", french=" Elle est à deux pas d'ici.", german=" Die liegt gleich da vorne.", italian=" Si trova poco più avanti.", spanish="Está justo ahí, un poco más\nadelante."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?[K] Really?", french=" Hein?[K] Vraiment?", german=" Echt?[K] Tatsächlich?", italian=" Eh?[K] Davvero?", spanish=" ¿Cómo?[K] ¿En serio?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?[K] Really?", french=" Hein?[K] Vraiment?", german=" Was?[K] Wirklich?", italian=" Eh?[K] Davvero?", spanish=" ¿Qué?[K] ¿En serio?"})
  else
  SkySceneKit.say({english=" Oh?[K] Really?", french=" Hein?[K] Vraiment?", german=" Oh?[K] Wirklich?", italian=" Eh?[K] Davvero?", spanish=" ¿Cómo?[K] ¿En serio?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="In fact, we were on our\nway there.", french="Ça tombe bien, c'est là-bas que\nnous allons nous aussi.", german="Um ehrlich zu sein, waren wir\nauf dem Weg dorthin.", italian="A dire la verità, ci stiamo\nandando anche noi.", spanish="De hecho, nosotros íbamos de\ncamino allí."})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" Want to come with us?", french=" Vous venez avec nous?", german=" Möchtet ihr mit uns gehen?", italian=" Volete venire con noi?", spanish=" ¿Queréis venir con nosotros?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" Yeah, come with us if you want.", french="Oui, vous pouvez nous\naccompagner si vous voulez.", german="Ja, kommt mit uns mit, wenn ihr\nwollt.", italian="Sì, se volete potete venire con\nnoi.", spanish="Sí, podéis acompañarnos si\nqueréis."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_ringuma, 268, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_himeguma, 188, 188, false, 2)
  GAME:WaitFrames(20)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's go with them,\n[hero]!", french="Allons avec eux,\n[hero]!", german="Gehen wir mit ihnen,\n[hero]!", italian="Andiamo con loro,\n[hero]!", spanish="¡Vamos con ellos,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's go with them,\n[hero]!", french="Allons avec eux,\n[hero]!", german="Gehen wir mit ihnen,\n[hero]!", italian="Andiamo con loro,\n[hero]!", spanish="¡Vamos con ellos,\n[hero]!"})
  else
  SkySceneKit.say({english="Let's go with them,\n[hero]!", french="Allons avec eux,\n[hero]!", german="Gehen wir mit ihnen,\n[hero]!", italian="Andiamo con loro,\n[hero]!", spanish="¡Vamos con ellos,\n[hero]!"})
  end
  -- message_Close
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-40), 40, false) end) -- MovePositionOffset performer/caméra
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-40), false, 2) end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-40), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(7937) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D31P31A1_81) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:FadeOut(false, 5)
  -- GAP: se_Play(7938) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaaaah!", french=" Ouaaah!", german=" Aaaaaah!", italian=" Aaaaaah!", spanish=" ¡Aaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaaaah!", french=" Ouaaah!", german=" Aaaaaah!", italian=" Aaaaaah!", spanish=" ¡Aaah!"})
  else
  SkySceneKit.say({english=" Waaaaah!", french=" Ouaaah!", german=" Aaaaaah!", italian=" Aaaaaah!", spanish=" ¡Aaah!"})
  end
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  SkySceneKit.cleanup_npcs()
end
