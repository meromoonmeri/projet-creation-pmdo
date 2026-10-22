-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P09C/n04a2605.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P09C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(44) [anim idle native]
  -- bgm2_PlayFadeIn(BGM_OCEAN2) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 216, 288, Direction.Up, "NPC_CHIRIIN")
  GROUND:MoveToPosition(npc_npc_chiriin, 216, 172, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_chiriin, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Greetings, [CS:Y]Sunflora[CR]!", french=" Salut, [CS:Y]Héliatronc[CR]!", german=" Ich grüße dich, [CS:Y]Sonnflora[CR]!", italian=" Ciao, [CS:Y]Sunflora[CR]!", spanish=" ¡Hola, [CS:Y]Sunflora[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Everyone's telling scary stories\nin the next room!", french="On se raconte des histoires\nqui font peur dans la pièce d'à côté!", german="Alle sind nebenan und erzählen\nGruselgeschichten!", italian="Nell'altra stanza ci stiamo\nraccontando delle storie di paura!", spanish="¡En la sala de al lado están\ncontando historias de miedo!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="[c_name:NPC_HERO_FIRST] and [c_name:NPC_PARTNER_FIRST]\nare there too!", french="[c_name:NPC_HERO_FIRST] et [c_name:NPC_PARTNER_FIRST]\nsont là aussi!", german="[c_name:NPC_HERO_FIRST] und [c_name:NPC_PARTNER_FIRST]\nsind auch dort!", italian="Ci sono anche [c_name:NPC_HERO_FIRST]\ne [c_name:NPC_PARTNER_FIRST]!", spanish="¡Están hasta [c_name:NPC_HERO_FIRST] y\n[c_name:NPC_PARTNER_FIRST]!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Do you want to join\nus, [CS:Y]Sunflora[CR]?", french="Tu veux nous rejoindre,\n[CS:Y]Héliatronc[CR]?", german="Willst du nicht auch mitmachen,\n[CS:Y]Sonnflora[CR]?", italian=" Vuoi unirti a noi, [CS:Y]Sunflora[CR]?", spanish=" ¿Te vienes, [CS:Y]Sunflora[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="No, thank you.[K] Right now\nI'm writing in my diary...", french="Non, merci.[K] Je suis en train\nd'écrire mon journal, là...", german="Nein, danke.[K] Ich schreibe gerade\netwas in mein Tagebuch...", italian="No, grazie.[K] Adesso sto scrivendo\nil mio diario...", spanish="No, gracias.[K] Estoy escribiendo\nen mi diario..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Oh, I see.[K] OK, come over when\nyou're done, [CS:Y]Sunflora[CR]!", french="O.K.[K] Rejoins-nous quand\ntu auras fini, [CS:Y]Héliatronc[CR]!", german="Oh, verstehe.[K] Na gut, komm doch\nrüber, sobald du fertig bist, [CS:Y]Sonnflora[CR]!", italian="Oh, capisco.[K] Ok, raggiungici\nquando hai finito, [CS:Y]Sunflora[CR]!", spanish="Ah, bueno.[K] Pues nada, vente\ncuando acabes, [CS:Y]Sunflora[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="[CS:N]Croagunk[CR] had a REALLY\nscary story!", french="[CS:N]Cradopaud[CR] raconte une histoire\nVRAIMENT terrifiante!", german="[CS:N]Glibunkel[CR] hat gerade eine\nUNGEHEUER gruselige Geschichte erzählt!", italian="[CS:N]Croagunk[CR] sta raccontando\nuna storia DAVVERO spaventosa!", spanish="¡[CS:N]Croagunk[CR] tenía una\nhistoria espeluznante de verdad!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yeah.[K] I've got it.", french=" Oui.[K] Entendu.", german=" Okay.[K] Verstanden.", italian=" Sì.[K] Va bene.", spanish=" Vale, vale.[K] Tiene buena pinta."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I'll be there shortly.", french=" Je vous rejoins dans une minute.", german=" Ich komme gleich nach.", italian=" Tra poco arrivo.", spanish=" Voy en un ratito."})
  -- message_Close
  do local p=npc_npc_chiriin.Position; GROUND:MoveToPosition(npc_npc_chiriin, p.X+(0), p.Y+(24), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Oh, [CS:N]Chimecho[CR].", french=" Oh, [CS:N]Eoko[CR].", german=" Oh, [CS:N]Palimpalim[CR]...", italian=" Oh, [CS:N]Chimecho[CR].", spanish=" Ah, [CS:N]Chimecho[CR]."})
  -- message_Close
  GROUND:EntTurn(npc_npc_chiriin, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_chiriin.Position; GROUND:MoveToPosition(npc_npc_chiriin, p.X+(0), p.Y+(-16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Yes?", french=" Oui?", german=" Ja?", italian=" Sì?", spanish=" Dime."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Has [CS:N]Loudred[CR] returned to his\nroom yet?", french="Est-ce que [CS:N]Ramboum[CR] est déjà\nrevenu dans sa chambre?", german="Ist [CS:N]Krakeelo[CR] bereits in sein\nZimmer zurückgekehrt?", italian=" [CS:N]Loudred[CR] è tornato?", spanish="¿Ha vuelto ya [CS:N]Loudred[CR]\na su habitación?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Indeed, no.[K] Not yet, it seems.", french="En fait, non.[K] Pas encore,\non dirait.", german="Soweit ich weiß, nicht.[K]\nEr wird wohl noch unterwegs sein.", italian=" No.[K] Non ancora, a quanto pare.", spanish=" No, qué va.[K] Por lo visto aún no."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I see...", french=" Je vois...", german=" Verstehe...", italian=" Capisco...", spanish=" Pues vaya..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" See you!", french=" A plus!", german=" Bis dann!", italian=" A dopo!", spanish=" ¡Hasta luego!"})
  -- message_Close
  GROUND:EntTurn(npc_npc_chiriin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I have to hear the rest of\nthe story!", french="Je veux entendre la fin\nde l'histoire!", german="Ich möchte den Rest der\nGeschichte nicht verpassen!", italian="Devo sentire il resto\ndella storia!", spanish="¡No quiero perderme el final\nde la historia!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Just remembering it...[K]\nEek! Scary!", french="Rien que d'y penser...[K]\nBouh! J'en tremble de partout!", german="Allein wenn ich daran denke...[K]\nIiek! Gruselig!", italian="Solo a pensarci...[K]\nIiih! Che paura!", spanish="Solo con pensarlo...[K]\n¡Se me ponen los pelos como escarpias!"})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  do local p=npc_npc_chiriin.Position; GROUND:MoveToPosition(npc_npc_chiriin, p.X+(0), p.Y+(88), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:WaitFrames(60)
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" .........", french=" .........", german=" ..........", italian=" ..........", spanish=" ..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="... (I wonder if he's still\ngathering Perfect Apples...)", french="... (Je me demande s'il est\nencore en train de ramasser\ndes Pommes Parfaites...)", german="...(Ich frage mich, ob er immer\nnoch Perfekte Äpfel sammelt...)", italian="... (Chissà se sta ancora\nraccogliendo le Mele Perfette...)", spanish="Hum... (Me pregunto si seguirá\nrecogiendo Manzanas Perfectas...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- SetAnimation(44) [anim idle native]
  GAME:WaitFrames(45)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN][CS:N]Loudred[CR]...[K]I really need to apologize\n[CN]and to thank you.", french="[CN][CS:N]Ramboum[CR]...[K] Il faut vraiment que je te fasse\n[CN]mes excuses et que je te remercie.", german="[CN][CS:N]Krakeelo[CR]...[K] Ich muss mich wirklich\n[CN]entschuldigen und dir danken.", italian="[CN][CS:N]Loudred[CR]...[K] Devo assolutamente\n[CN]scusarmi e ringraziarti.", spanish="[CN][CS:N]Loudred[CR]...[K] Tengo que disculparme\n[CN]y darte las gracias."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Before, I...[K]I didn't want to go to dungeons with\n[CN]you at all![K]\n[CN]...I'm afraid I kinda blurted out things like that.", french="[CN]Je t'avais dit...[K] que je ne voulais plus\n[CN]partir en exploration avec toi!\n[CN]Je n'avais pas mâché mes mots.", german="[CN]Ich wollte eigentlich...[K] nicht mehr mit dir\n[CN]in Dungeons gehen![K] Leider habe ich mich dir\n[CN]gegenüber entsprechend abweisend verhalten.", italian="[CN]Prima io...[K] non volevo affatto\n[CN]esplorare i dungeon insieme a te![K]\n[CN]... E so di avertelo fatto pesare.", spanish="[CN]Antes...[K] no quería ni pisar un territorio\n[CN]contigo.[K] Me temo que he metido la pata\n[CN]hasta el fondo..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Oh my gosh! I'm really sorry for what I said![K]\n[CN]I wish I could take all that back!", french="[CN]Ben mince alors! Je suis vraiment désolée\n[CN]d'avoir dit ça![K] Si seulement je pouvais\n[CN]revenir en arrière!", german="[CN]Auweia! Es tut mir so leid! Wie abweisend ich\n[CN]gewesen bin![K] Ich wünschte, ich könnte das\n[CN]alles zurücknehmen!", italian="[CN]Shock! Sono così dispiaciuta per quello che\n[CN]ho detto![K] Se potessi, mi rimangerei tutto!", spanish="[CN]¡Jo, no es justo! Siento mucho lo que dije.[K]\n[CN]¡Ojalá pudiera retirarlo!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]I wonder if you'll go to dungeons\n[CN]with me in the future.", french="[CN]Je me demande si tu accepteras de\n[CN]m'accompagner dans les donjons à l'avenir.", german="[CN]Ob du wohl in Zukunft noch einmal\n[CN]mit mir Dungeons erkunden wirst?", italian="[CN]Chissà se in futuro vorrai ritornare\n[CN]nei dungeon con me...", spanish="[CN]Me pregunto si querrás ir\n[CN]de exploración conmigo alguna vez."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]I wonder if we...[K]\n[CN]Can we be friends again?", french="[CN]Je me demande si...[K]\n[CN]on peut redevenir amis?", german="[CN]Ob wir wohl...[K]\n[CN]wieder Freunde werden können?", italian="[CN]Chissà se...[K]\n[CN]saremo di nuovo amici...", spanish="[CN]Me pregunto si...[K] podremos\n[CN]volver a ser amigos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" .........", french=" .........", german=" ..........", italian=" ..........", spanish=" ..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Anyway...", french=" De toute façon...", german=" Wie auch immer...", italian=" Comunque...", spanish=" En fin..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="As soon as [CS:N]Loudred[CR]'s back, I'm\ngoing straight to him to apologize...", french="Dès que [CS:N]Ramboum[CR] revient,\nje file lui présenter mes excuses...", german="Sobald [CS:N]Krakeelo[CR] zurückkommt,\nwerde ich mich direkt bei ihm entschuldigen...", italian="Non appena [CS:N]Loudred[CR] sarà\ntornato, andrò subito a scusarmi...", spanish="En cuanto vuelva [CS:N]Loudred[CR],\niré derechita a disculparme..."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(150) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]I've got to tell him...", french="[CN]Je dois lui dire...", german="[CN]Ich muss es ihm sagen...", italian="[CN]E gli dirò...", spanish="[CN]Tengo que decirle..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]What I couldn't say then...", french="[CN]... ce que j'aurais dû lui dire aujourd'hui...", german="[CN]Das, was ich damals nicht sagen konnte...", italian="[CN]Quello che non sono riuscita\n[CN]a dirgli in quel momento...", spanish="[CN]Lo que no pude decirle antes..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]\\\"Thank you.\\\"", french="[CN]\\\"Merci\\\".", german="[CN][F:S2]Danke schön.[F:E2]", italian="[CN]\\\"Grazie\\\".", spanish="[CN]\\\"Gracias\\\"."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
