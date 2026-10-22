-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m11a0502.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P04A, 'UM11') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 464, 216, Direction.Down, "NPC_PERAPPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="What?![K] They have no plans to\nstock Perfect Apples?", french="Quoi?![K] Ils n'ont pas l'intention de\nvendre des Pommes Parfaites?", german="Was?!?[K] Sie haben nicht vor,\nPerfekte Äpfel zu verkaufen?", italian="Cosa?[K] Non hanno intenzione di\nvendere Mele Perfette?", spanish="¡¿Qué?![K] ¿No tienen previsto\nvender Manzanas Perfectas?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweatdrop", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Squawk! What am I supposed to\ndo now?!", french="Couac! Mais qu'est-ce que\nje vais faire maintenant?!", german="Kreisch! Was soll ich jetzt nur\ntun?!?", italian=" Squack! E ora cosa farò???", spanish=" ¡Cruac! ¡¿Y ahora qué hago?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Um...[K] We could maybe go get\nsome Perfect Apples at [CS:P]Apple Woods[CR]...", french="Hum...[K] On pourrait peut-être\naller cueillir des Pommes Parfaites au [CS:P]Bois\naux Pommes[CR]...", german="Äh...[K] Wir könnten ja ein paar\nPerfekte Äpfel aus dem [CS:P]Apfelwald[CR] holen...", italian="Beh...[K] Potremmo andare al\n[CS:P]Giardino dei Meli[CR] a prenderne un po'!", spanish="Esto...[K] Quizás podríamos ir\na buscar Manzanas Perfectas al [CS:P]Manzanar[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Um...[K] We could go get some\nPerfect Apples for you at [CS:P]Apple Woods[CR]...", french="Hum...[K] On pourrait peut-être\naller cueillir des Pommes Parfaites au [CS:P]Bois\naux Pommes[CR]...", german="Äh...[K] Wir könnten ein paar\nPerfekte Äpfel aus dem [CS:P]Apfelwald[CR] holen...", italian="Mmm...[K] Potremmo andare noi al\n[CS:P]Giardino dei Meli[CR] e prendere un po' di Mele\nPerfette!", spanish="Esto...[K] Quizás podríamos ir\na buscar Manzanas Perfectas al [CS:P]Manzanar[CR]."})
  else
  SkySceneKit.say({english="Um...[K] We could go get some\nPerfect Apples for you at [CS:P]Apple Woods[CR]...", french="Hum...[K] On pourrait peut-être\naller cueillir des Pommes Parfaites au [CS:P]Bois\naux Pommes[CR]...", german="Äh...[K] Wir könnten ein paar\nPerfekte Äpfel aus dem [CS:P]Apfelwald[CR] holen...", italian="Mmm...[K] Potremmo andare noi al\n[CS:P]Giardino dei Meli[CR] e prendere un po' di Mele\nPerfette!", spanish="Esto...[K] Quizás podríamos ir\na buscar Manzanas Perfectas al [CS:P]Manzanar[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" What?! You're joking!", french=" Quoi?! Vous plaisantez!", german=" Was?!? Soll das ein Witz sein?", italian=" Cosa? State scherzando?", spanish=" ¡¿Qué?! ¡Estarás de broma!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You've previously gone to\n[CS:P]Apple Woods[CR]...", french="Dois-je vous rappeler que\nvous avez déjà essayé d'en récolter au\n[CS:P]Bois aux Pommes[CR]...", german="Ihr wart bereits einmal im\n[CS:P]Apfelwald[CR]...", italian="Avete già fatto una spedizione al\n[CS:P]Giardino dei Meli[CR]...", spanish=" Ya fuisteis al [CS:P]Manzanar[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" You failed utterly!", french="... et que vous avez\nlamentablement échoué!", german=" Und ihr habt kläglich versagt!", italian=" È stata un fallimento!", spanish="¡Y fracasasteis\nestrepitosamente!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I just can't take that![K] I just can't\ngo through all that again!", french="Je n'en peux plus![K] Hors\nde question que je subisse ça à nouveau!", german="Ich ertrage das kein zweites\nMal![K] Ich kann das alles nicht schon wieder\ndurchmachen!", italian="Non posso rischiare che succeda\ndi nuovo![K] Non lo sopporterei!", spanish="¡Así que ni hablar![K] ¡No pienso\nvolver a quedar mal delante del Gran Bluff!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" ...[K]I'm sorry.", french=" ...[K] Je suis désolé.", german=" ...[K]Tut mir leid.", italian=" ...[K] Mi dispiace.", spanish=" Bueno...[K] Lo siento."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You two were outstanding on our\nrecent expedition. I recognize everything\nthat you've done for us.", french="Vous avez été remarquables\npendant l'expédition. Je suis reconnaissant\npour tout ce que vous avez fait pour nous.", german="Ihr zwei wart auf der letzten\nExpedition wirklich hervorragend. Ich weiß zu\nschätzen, was ihr für uns getan habt.", italian="Voi due avete raggiunto un\nrisultato eccellente nella nostra recente\nspedizione, di questo vi do atto.", spanish="La verdad es que hicisteis un gran\ntrabajo en la última expedición. Reconozco\ntodo lo que habéis hecho por el [CS:N]Pokégremio[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But the incident...[K]with the\nGuildmaster and the Perfect Apples...", french="Mais l'incident...[K] avec le Maître\net les Pommes Parfaites...", german="Aber dieser Vorfall[K] mit dem\nGildenmeister und den Perfekten Äpfeln...", italian="Ma...[K] lo sfortunato incidente\ncon il Capitano e le Mele Perfette...", spanish="Pero el incidente...[K] con el Gran\nBluff y las Manzanas Perfectas..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It was a slightly traumatic\nincident for me.", french=" Ça m'a un peu traumatisé.", german="Das war für mich\nein traumatisches Erlebnis.", italian="... è stato leggermente\ntraumatico per me.", spanish=" Me traumatizó un poquito."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweatdrop", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Squawk![K] I suppose I'll have to\nfind the Perfect Apples myself...", french="Couac![K] J'imagine que je vais\ndevoir trouver des Pommes Parfaites\nmoi-même...", german="Kreisch![K] Ich glaube, ich werde\ndie Perfekten Äpfel selbst finden müssen...", italian="Squack![K] Immagino che dovrò\npensare io a trovare le Mele Perfette...", spanish="¡Cruac![K] Supongo que tendré\nque traer las Manzanas Perfectas yo mismo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You two should just look over\nthe Job Bulletin Board and the Outlaw Notice\nBoard as usual.", french="Pour aujourd'hui, consultez\nle Tableau des Missions et les Avis\nde Recherche, comme d'habitude.", german="Ihr zwei solltet einfach die\nJob- und Ganoven-Infobretter durchlesen,\nwie immer.", italian="Voi due dovreste tornare a dare\nun'occhiata alla Bacheca delle missioni e a\nquella dei ricercati, come al solito.", spanish="Deberíais limitaros a mirar\nel Tablón de Anuncios y el Tablón\n\"Se Busca\", como de costumbre."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
