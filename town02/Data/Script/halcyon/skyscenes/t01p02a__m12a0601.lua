-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/m12a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_T01P02A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Meanwhile, back at Treasure Town...", french="[CN]Pendant ce temps à Bourg-Trésor...", german="[CN]Währenddessen in Schatzstadt...", italian="[CN]Nel frattempo, a Borgo Tesoro...", spanish="[CN]Mientras tanto, en Aldea Tesoro..."})
  -- message_Close
  GAME:WaitFrames(2) -- join WaitBgm
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_kakureon1 = SkySceneKit.spawn_npc("kecleon", 328, 168, Direction.Down, "NPC_KAKUREON1")
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="Ah, I see! That's what happened\nto your [CS:Z]Water Float[CR]!", french="Ah je vois! C'est donc pour ça\nque votre [CS:Z]Hydroflotteur[CR] a disparu!", german="Ah, verstehe! Das ist also mit\neurem [CS:Z]Schwimmreif[CR] passiert!", italian="Mmm... Allora è finita così con\nla vostra [CS:Z]Acquaboa[CR]!", spanish="¡Ah, ya veo! Así que eso es lo\nque ha pasado con el [CS:Z]Flotarill[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" What a mean thing to do!", french=" Comme c'est méchant!", german=" Was für eine Gemeinheit!", italian=" Che razza di mascalzoni!", spanish=" ¡Qué mezquindad!"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="So, [hero]'s team is on\nthe way there right now, yes?", french="Donc, l'équipe de [hero]\nest en route pour le récupérer, n'est-ce pas?", german="Das Team von [hero] ist\nalso auf dem Weg dorthin, ja?", italian="E così la squadra di\n[hero] si sta dirigendo lì, eh?", spanish="Entonces, el equipo de\n[hero] ya va de camino hacia allí, ¿no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_ruriri = SkySceneKit.spawn_npc("azurill", 320, 200, Direction.Up, "NPC_RURIRI")
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" Yep!", french=" Ouaip!", german=" Ja!", italian=" Sì!", spanish=" ¡Sí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_mariru = SkySceneKit.spawn_npc("marill", 352, 200, Direction.Up, "NPC_MARIRU")
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="They said they would go get it\nfor us!", french=" Elle va le récupérer pour nous!", german="Sie haben gesagt, sie wollen ihn\nfür uns holen!", italian="Hanno detto che l'avrebbero\nritrovata!", spanish="Nos prometieron que lo\nrecuperarían."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="Good for you! You can rest easy\nknowing Team [team:] is on the case!", french="Je suis content pour vous!\nVous pouvez être tranquilles maintenant que\nl'Equipe [team:] est sur le coup!", german="Das freut mich für euch!\nIhr könnt beruhigt sein. Immerhin kümmert\nsich jetzt Team [team:] darum!", italian="Buon per voi! Con il Team\n[team:] non avete niente da temere!", spanish="Me alegro. Si el [CS:X]Equipo[CR]\n[team:] se encarga de esto, no hay\nnada que temer."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Yes. That's true!", french=" Ça c'est bien vrai!", german=" Ja. Das stimmt!", italian=" Già! Hai proprio ragione!", spanish=" Sí, es verdad."})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="They once saved [CS:N]Azurill[CR] too.\nWe're so grateful for their help!", french="Ces Pokémon ont déjà sauvé\n[CS:N]Azurill[CR] une fois. On leur est si reconnaissants!", german="Sie haben auch einmal [CS:N]Azurill[CR]\ngerettet. Wir sind so dankbar, dass sie uns\nhelfen!", italian="Una volta hanno anche salvato\n[CS:N]Azurill[CR]! Gli siamo davvero riconoscenti!", spanish="Ya salvaron a [CS:N]Azurill[CR] en una\nocasión. ¡Cómo agradecemos su ayuda!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(1)
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 496, 208, Direction.Left, "NPC_YONOWAARU")
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end) -- message_SetActor(ACTOR_NPC_YONOWAARU)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Good day to you all. Is something\nthe matter?", french="Bonjour à tous. Y aurait-il\nquelque problème?", german="Guten Tag allerseits.\nWorum geht es denn?", italian="Buongiorno, signori. È forse\nsuccesso qualcosa?", spanish="Buenos días a todos.\n¿Algún problema?"})
  GROUND:MoveToPosition(npc_npc_yonowaaru, 408, 208, false, 2)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  GROUND:EntTurn(npc_npc_ruriri, Direction.Right)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_mariru, Direction.Right)
  GROUND:EntTurn(npc_npc_kakureon1, Direction.Right)
  GAME:WaitFrames(5)
  local npc_npc_kakureon2 = SkySceneKit.spawn_npc("kecleon", 352, 168, Direction.Down, "NPC_KAKUREON2")
  GROUND:EntTurn(npc_npc_kakureon2, Direction.Right)
  GROUND:MoveToPosition(npc_npc_yonowaaru, 368, 208, false, 2)
  GROUND:MoveToPosition(npc_npc_mariru, 320, 212, false, 2)
  GROUND:EntTurn(npc_npc_kakureon1, Direction.DownRight)
  GROUND:EntTurn(npc_npc_kakureon2, Direction.DownRight)
  GROUND:EntTurn(npc_npc_mariru, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon1, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="Hello, [CS:N]Dusknoir[CR], sir! We're\ntalking about [CS:N]Marill[CR]'s lost item.", french="Bonjour, messire [CS:N]Noctunoir[CR]!\nNous parlions de l'objet qu'a égaré [CS:N]Marill[CR].", german="Hallo, [CS:N]Zwirrfinst[CR]! Wir\nsprechen über das verlorene Item von [CS:N]Marill[CR].", italian="Buongiorno signor [CS:N]Dusknoir[CR]!\nStavamo parlando dello strumento perduto da\nquesti giovanotti.", spanish="¡Buenos días, señor [CS:N]Dusknoir[CR]!\nEstábamos hablando del objeto que perdió\n[CS:N]Marill[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="Do you remember? We discussed\nthat very same thing here not long ago.", french="Vous vous en souvenez?\nNous en avons déjà parlé ici même\nl'autre fois.", german="Erinnerst du dich? Wir haben\nuns erst kürzlich darüber unterhalten.", italian="Ricorda? Ne parlammo poco\ntempo fa.", spanish="¿Lo recuerda?\nHablamos de ello no hace mucho."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru, npc_npc_kakureon1, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Of course.[K] I believe you're\nreferring to the [CS:Z]Water Float[CR]?", french="Bien entendu.[K] J'imagine que\nvous faites allusion à l'[CS:Z]Hydroflotteur[CR]?", german="Natürlich.[K] Ich glaube, du\nmeinst den [CS:Z]Schwimmreif[CR], oder?", italian="Certamente.[K] Sono sicuro che vi\nriferite all'[CS:Z]Acquaboa[CR], non è così?", spanish="Por supuesto.[K] Os referís al\n[CS:Z]Flotarill[CR], ¿verdad?"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I seem to recall you'd heard that\nit was on the beach.", french="Il me semble que vous aviez\nentendu dire qu'il se trouvait à la plage.", german="Du hattest gehört, dass er am\nStrand liegt, wenn ich mich recht erinnere.", italian="Allora, se non ricordo male,\ndiceste che si trovava sulla spiaggia.", spanish="Creo recordar que alguien\nlo había visto en la playa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="Exactly! Exactly![K] But now there\nis more to the story...", french="C'est exact![K] Mais il y a eu\nrécemment de nouveaux rebondissements\ndans cette affaire...", german="Genau! Genau![K] Aber jetzt\ngibt es Neuigkeiten...", italian=" Proprio così![K] Ma c'è di più!", spanish="Precisamente.[K]\nPero la historia se ha complicado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="[CN][CS:N]Kecleon[CR] explained to [CS:N]Dusknoir[CR]\n[CN]what had taken place.", french="[CN][CS:N]Kecleon[CR] explique ce qui\n[CN]s'est passé à [CS:N]Noctunoir[CR].", german="[CN][CS:N]Kecleon[CR] erklärt [CS:N]Zwirrfinst[CR]\n[CN]das Geschehene.", italian="[CN][CS:N]Kecleon[CR] racconta a [CS:N]Dusknoir[CR]\n[CN]i fatti avvenuti in precedenza.", spanish="[CN][CS:N]Kecleon[CR] le explicó a [CS:N]Dusknoir[CR]\n[CN]lo que había ocurrido."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" I see. That is terrible indeed.", french=" Je vois. C'est terrible en effet.", german="Ich verstehe. Das ist wirklich\nschrecklich.", italian="Ho capito. Si tratta di una cosa\nterribile.", spanish=" Ya veo. Es terrible."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="It's hard to imagine why anyone\nwould do something so wretched.", french="Difficile d'imaginer ce qui peut\nbien motiver un tel forfait.", german="Es ist schwer vorstellbar, dass\njemand so hinterhältig sein kann.", italian="È difficile immaginare le ragioni\nche possano portare a compiere azioni del\ngenere.", spanish="Cuesta imaginar que alguien\npueda hacer una cosa tan infame."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="It must take some pathetic thugs\nto stoop so low.", french="Seul un pendard de la pire\nespèce pourrait se rendre coupable d'une telle\nbassesse.", german="Wer so tief sinkt, muss schon\nein erbärmlicher Lump sein.", italian="Solo dei miserabili furfanti\npotrebbero cadere così in basso.", spanish="Tiene que tratarse de un granuja\nbastante patético para caer tan bajo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8970) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="I just couldn't agree more![K]\nTo be so mean spirited to children! And to\nchildren so young as these brothers!", french="Tout à fait d'accord![K]\nS'en prendre à des enfants! Si jeunes, qui plus\nest!", german="Ganz meine Meinung![K] Kindern\ngegenüber so gemein zu sein! Und dann noch\nzu so kleinen Kindern wie diesen Brüdern!", italian="Non posso che darle ragione![K]\nCome si può essere così crudeli verso degli\nesseri indifesi come questi due fratellini?", spanish="No podría estar más de acuerdo.[K]\n¡Cómo se les ocurre tratar mal a unos\nPokémon tan jóvenes y simpáticos!"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" It's utterly unforgivable!", french="C'est tout bonnement\nimpardonnable!", german=" Das ist absolut unentschuldbar!", italian=" È davvero imperdonabile!", spanish=" Es algo imperdonable."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="One more thing...[K] Where has\nTeam [team:] gone?", french="Autre chose...[K] Où est passée\nl'Equipe [team:]?", german="Noch eine Sache...[K]\nWohin ist Team [team:] gegangen?", italian="Un'ultima cosa...[K] Dov'è diretto\nil Team [team:]?", spanish="Una cosa más...[K]\n¿Adónde ha ido el [CS:X]Equipo[CR] [team:]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" They went to [CS:P]Amp Plains[CR].", french=" Partie pour les [CS:P]Plaines Elek[CR].", german="Sie sind zur [CS:P]Ampere-Ebene[CR]\ngegangen.", italian="Si stanno dirigendo alle\n[CS:P]Pianure Saetta[CR].", spanish=" Han ido a la [CS:P]Pradera Destello[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Left)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Pardon?[K] Did you say [CS:P]Amp\nPlains[CR]?", french="Pardon?[K] Les [CS:P]Plaines Elek[CR],\ndites-vous?", german="Wie bitte?[K] Sagtest du\nzur [CS:P]Ampere-Ebene[CR]?", italian=" Come?[K] Le [CS:P]Pianure Saetta[CR], dici?", spanish="¿Cómo?[K] ¿Has dicho que han ido\na la [CS:P]Pradera Destello[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="But in [CS:P]Amp Plains[CR], at this time\nof year...[K] It's the season for...", french="Mais à cette époque de l'année\ndans les [CS:P]Plaines Elek[CR]...[K] c'est la saison de...", german="Aber in der [CS:P]Ampere-Ebene[CR]\nist zu dieser Jahreszeit[K] die Saison der...", italian="Ma nelle [CS:P]Pianure Saetta[CR], in\nquesto periodo dell'anno...[K] è la stagione dei...", spanish="Pero en la [CS:P]Pradera Destello[CR],\nen esta época del año...[K] Es la estación de..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" No! This is ruinous!", french="Malédiction! Quel grand\nmalheur!", german=" Nein! Das ist fatal!", italian=" No! È terribile!", spanish=" ¡No! ¡Qué calamidad!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru, npc_npc_kakureon1, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Team [team:] is in grave\ndanger!", french="L'Equipe [team:] court\nun grave danger!", german="Team [team:] schwebt in\nernster Gefahr!", italian="Il Team [team:] si trova in\ngrave pericolo!", spanish="¡El [CS:X]Equipo[CR] [team:] corre\nun grave peligro!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon2, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_mariru, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I must leave for [CS:P]Amp Plains[CR]\nimmediately!", french="Il me faut partir pour les\n[CS:P]Plaines Elek[CR] séance tenante!", german="Ich muss sofort zur\n[CS:P]Ampere-Ebene[CR]!", italian="Devo recarmi alle [CS:P]Pianure Saetta[CR]\nimmediatamente!", spanish="¡Tengo que partir hacia\nla [CS:P]Pradera Destello[CR] inmediatamente!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yonowaaru.Position; GROUND:MoveToPosition(npc_npc_yonowaaru, p.X+(160), p.Y+(0), false, 2) end
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon1, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" What?! Wait!", french=" Quoi?! Mais attendez!", german=" Was?!? Warte!", italian=" Cosa?! Aspetti!", spanish=" ¡¿Qué?! ¡Espere!"})
  -- message_Close
  GAME:FadeOut(false,  60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- main_EnterDungeon(18, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
