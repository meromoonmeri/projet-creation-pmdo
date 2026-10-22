-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/s23p0103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(60)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  GAME:WaitFrames(30)
  local npc_npc_manafi = SkySceneKit.spawn_npc("manaphy", 280, 208, Direction.Down, "NPC_MANAFI")
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Wow...[K]I remember this place.", french="Waouh...[K] je me rappelle\ncet endroit.", german="Wow...[K] Ich erinnere mich an\ndiesen Ort.", italian="Wow...[K] Mi ricordo questo\nposto.", spanish=" ¡Vaya![K] Recuerdo este lugar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_manafi, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" I hatched here, didn't I?", french=" C'est ici que j'ai éclos, pas vrai?", german="Hier bin ich geschlüpft,\noder nicht?", italian="È qui che sono uscito\ndall'Uovo, vero?", spanish=" Aquí nací yo, ¿verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yes, you're right.[K] This is where\nwe came to know each other.", french="Oui, c'est vrai.[K] C'est ici que nous\nnous sommes connus.", german="Ja, du hast recht.[K] Hier haben\nwir uns kennengelernt.", italian="Sì, hai ragione.[K] È qui che ci\nsiamo incontrati.", spanish="Sí.[K] Aquí fue donde nos\nconocimos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yes, you're right.[K] This is where\nwe came to know each other.", french="Oui, c'est vrai.[K] C'est ici que nous\nnous sommes connus.", german="Ja, du hast recht.[K] Hier haben\nwir uns kennengelernt.", italian="Sì, hai ragione.[K] È qui che ci\nsiamo incontrati.", spanish="Sí.[K] Aquí fue donde nos\nconocimos."})
  else
  SkySceneKit.say({english="Yes, you're right.[K] This is where\nwe came to know each other.", french="Oui, c'est vrai.[K] C'est ici que nous\nnous sommes connus.", german="Ja, du hast recht.[K] Hier haben\nwir uns kennengelernt.", italian="Sì, hai ragione.[K] È qui che ci\nsiamo incontrati.", spanish="Sí.[K] Aquí fue donde nos\nconocimos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'm surprised you still\nremember that.", french="Je suis surpris que tu t'en\nsouviennes.", german="Ich bin überrascht, dass du das\nnoch weißt.", italian="Mi sorprende che te ne ricordi\nancora.", spanish="Me sorprende que todavía\nte acuerdes."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm surprised you still\nremember that.", french="Je suis surpris que tu t'en\nsouviennes.", german="Ich bin überrascht, dass du das\nnoch weißt.", italian="Mi sorprende che te ne ricordi\nancora.", spanish="Me sorprende que todavía\nte acuerdes."})
  else
  SkySceneKit.say({english="I'm surprised you can\nremember that.", french="Je suis surprise que tu t'en\nsouviennes.", german="Ich bin überrascht, dass du das\nnoch weißt.", italian="Mi sorprende che te ne ricordi\nancora.", spanish="Me sorprende que todavía\nte acuerdes."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english="We [CS:K]Manaphy[CR] have the ability to\nremember where we hatched. So I've been told.", french="On m'a raconté que nous,\nles [CS:K]Manaphy[CR], étions capables de nous souvenir\nde l'endroit où nous avons éclos.", german="Wir [CS:K]Manaphy[CR] haben die\nFähigkeit, uns daran zu erinnern, wo wir\ngeschlüpft sind. Das hat man mir gesagt.", italian="Noi [CS:K]Manaphy[CR] siamo in grado\ndi ricordarci dove siamo usciti dall'Uovo. Così\nmi hanno detto.", spanish="Los [CS:K]Manaphy[CR] podemos recordar\ndónde nacimos. Eso me han dicho."})
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english="After we grow up in the sea, we\ngo back to where we hatched by instinct.", french="Après avoir grandi dans la mer,\nnotre instinct nous ramène sur les lieux\nde notre éclosion.", german="Nachdem wir im Meer\naufgewachsen sind, gehen wir an den Ort\nunseres Schlüpfens zurück.", italian="Dopo essere cresciuti nel mare,\ntorniamo istintivamente nel luogo dove siamo\nusciti dall'Uovo.", spanish="Una vez que crecemos, el\ninstinto nos lleva de vuelta al lugar\ndonde nacimos."})
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Mr. [CS:N]Walrein[CR] taught me that.", french="C'est Monsieur [CS:N]Kaimorse[CR] qui me\nl'a dit.", german="Herr [CS:N]Walraisa[CR] hat mir das\nbeigebracht.", italian="Me lo ha insegnato il signor\n[CS:N]Walrein[CR].", spanish=" El Sr. [CS:N]Walrein[CR] me lo enseñó."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That's impressive!", french=" Impressionnant!", german=" Das ist beeindruckend!", italian=" È sorprendente!", spanish=" Impresionante."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That's impressive!", french=" Impressionnant!", german=" Das ist beeindruckend!", italian=" È sorprendente!", spanish=" Impresionante."})
  else
  SkySceneKit.say({english=" How impressive!", french=" Impressionnant!", german=" Wie beeindruckend!", italian=" È sorprendente!", spanish=" Impresionante."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" This is where I was hatched...", french=" C'est ici que j'ai éclos...", german="An dieser Stelle bin ich\ngeschlüpft...", italian=" È qui che sono uscito dall'Uovo...", spanish=" Este es el sitio donde nací..."})
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english="That's why I felt the urge to\ncome back here.", french="... ce qui explique mon envie\nirrépressible de revenir.", german="Deswegen fühlte ich das\nVerlangen, hierher zurückzukehren.", italian="Ecco perché ho sentito il\nbisogno di tornare qui.", spanish="Por eso sentía la necesidad de\nvolver aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 328, 192, Direction.DownLeft, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Well then...[K] Now that you've\nreturned, what will you do now, [CS:N]Manaphy[CR]?", french="Eh bien...[K] maintenant que tu es\nrevenu, que comptes-tu faire, [CS:N]Manaphy[CR]?", german="Nun gut...[K] Jetzt, wo du wieder\nhier bist, was hast du vor zu tun, [CS:N]Manaphy[CR]?", italian="Beh, allora...[K] Adesso che sei\ntornato, cosa farai, [CS:N]Manaphy[CR]?", spanish="Y...[K] ¿Qué vas a hacer ahora\nque has vuelto, [CS:N]Manaphy[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_manafi, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english="I was told that I have to decide\nthat on my own.", french="On m'a dit que cette décision\nm'appartenait.", german="Mir wurde gesagt, ich müsste\ndas allein entscheiden.", italian="Mi hanno detto che devo decidere\nda solo.", spanish="Me han dicho que eso tengo\nque decidirlo yo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_manafi, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english="Well, um... So, uh...[K] I thought\nreally hard about this and other things...", french="Bon, hmm... alors, euh...[K] j'y ai\nbeaucoup réfléchi, parmi tant d'autres\nchoses...", german="Nun, ähem... Also, öh...[K] Ich habe\nwirklich lange über das und auch über andere\nDinge nachgedacht...", italian="Quindi, ehm...[K] Ci ho pensato\nmolto.", spanish="Bueno, veréis...[K] He pensado\nmucho en esto y..."})
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english="I'd like to return the favor,\n[hero] and [partner]...", french="J'aimerais pouvoir vous rendre\nservice à mon tour, [hero]\net [partner]...", german="Ich möchte mich gerne bei euch\nrevanchieren, [hero] und [partner]...", italian="Vorrei restituirvi il favore,\n[hero] e [partner]...", spanish="Me gustaría devolveros\nel favor, [hero] y [partner]..."})
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english="Don't you travel and explore all\nover the world?", french="Il me semble que vous partez\nsouvent en exploration un peu partout dans\nle monde, non?", german="Reist ihr nicht herum und\nerkundet Orte überall auf der Welt?", italian="Voi viaggiate ed esplorate\ntutto il mondo, vero?", spanish="Viajáis por el mundo llevando\na cabo expediciones varias, ¿verdad?"})
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english="I really wish I could help you\nwhen you go out on your adventures...", french="J'aimerais tant pouvoir vous\nprêter main-forte quand vous partez\nà l'aventure...", german="Ich wünschte so sehr, ich\nkönnte euch auf euren Abenteuern helfen...", italian="Mi piacerebbe tantissimo potervi\naiutare durante le vostre avventure...", spanish="Me encantaría poder ayudaros\nen vuestras aventuras..."})
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english="So, um...[K] Uh...[K] May I please be a\nmember of Team [team:]...?", french="Alors, euh...[K] est-ce que\nvous m'accepteriez dans l'Equipe\n[team:]...?", german="So, ähem...[K] Öh...[K] Darf ich bitte\nein Mitglied von Team [team:] werden?", italian="Quindi, ehm...[K] ecco...[K] Posso\nunirmi al Team [team:]?", spanish="Así que...[K] Esto...[K] ¿Podría ser\nmiembro del [CS:X]Equipo[CR] [team:]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(180) end)
  GAME:WaitFrames(60)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  else
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english="D-don't worry![K] I'm grown up!\nI won't get sick like before...", french="Ne vous en faites pas![K] Je suis\nadulte maintenant! Je ne tomberai plus malade\ncomme avant...", german="K-keine Sorge![K] Ich bin groß\ngeworden! Mir wird nicht mehr so schnell\nschlecht wie früher...", italian="N-Non preoccupatevi![K] Sono\ncresciuto! Non mi ammalerò più...", spanish="¡No os preocupéis![K] ¡Ya soy\nmayor! No volveré a enfermar..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  else
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" ...[K]You don't...[K]want me?", french="......[K] Vous ne voulez...[K]\npas de moi?", german="...[K]Ihr...[K] Ihr wollt mich nicht\nhaben?", italian=" ...[K] Non...[K] mi volete?", spanish="Pero...[K] ¿no me...?[K] ¿No me\nqueréis?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_AT_THE_END_OF_THE_DAY non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Urk...[K] Of course we want you\nto stay with us![K] Right, [hero]?", french="Argh...[K] Bien sûr que si, on veut\nque tu restes avec nous![K] Pas vrai,\n[hero]?", german="Umpf...[K] Selbstverständlich\nwollen wir, dass du bei uns bleibst![K]\nRichtig, [hero]?", italian="Eddai...[K] Certo che ti vogliamo![K]\nNon è vero, [hero]?", spanish="¡Glup![K] ¡Claro que queremos\nque te quedes![K] ¿Verdad, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Urk...[K] Of course we want you\nto stay with us![K] Right, [hero]?", french="Argh...[K] Bien sûr que si, on veut\nque tu restes avec nous![K] Pas vrai,\n[hero]?", german="Umpf...[K] Selbstverständlich\nwollen wir, dass du bei uns bleibst![K]\nRichtig, [hero]?", italian="Oh...[K] Certo che ti vogliamo![K]\nNon è vero, [hero]?", spanish="¡Glup![K] ¡Claro que queremos\nque te quedes![K] ¿Verdad, [hero]?"})
  else
  SkySceneKit.say({english="Urk...[K] Of course we want you\nto stay with us![K] Right, [hero]?", french="Argh...[K] Bien sûr que si, on veut\nque tu restes avec nous![K] Pas vrai,\n[hero]?", german="Umpf...[K] Selbstverständlich\nwollen wir, dass du bei uns bleibst![K]\nRichtig, [hero]?", italian="Oh...[K] Certo che ti vogliamo![K]\nNon è vero, [hero]?", spanish="¡Glup![K] ¡Claro que queremos\nque te quedes![K] ¿Verdad, [hero]?"})
  end
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  -- @label_2 [étiquette de flux ExplorerScript]
  -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
  do local __choice = SkySceneKit.ask({{english="Of course!", french="Bien sûr!", german="Selbstverständlich!", italian="Certo!", spanish="¡Claro!"}, {english="No!", french="Non!", german="Nein!", italian="No!", spanish="¡No!"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- break_loop [contrôle de boucle forever NDS: une itération compilée]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What are you saying,\n[hero]?", french="Mais qu'est-ce que tu racontes,\n[hero]?", german="Was sagst du da,\n[hero]?!?", italian="Ma cosa dici,\n[hero]?", spanish=" ¿Qué dices, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What are you saying,\n[hero]?", french="Mais qu'est-ce que tu racontes,\n[hero]?", german="Was sagst du da,\n[hero]?!?", italian="Ma cosa dici,\n[hero]?", spanish=" ¿Qué dices, [hero]?"})
  else
  SkySceneKit.say({english="What are you saying,\n[hero]?", french="Mais qu'est-ce que tu racontes,\n[hero]?", german="Was sagst du da,\n[hero]?!?", italian="Ma cosa dici,\n[hero]?", spanish=" ¿Qué dices, [hero]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You must be all addled from\nbeing so happy! Snap out of it!", french="Ça doit être la joie qui te fait\ndire n'importe quoi! Reprends-toi!", german="Du bist ja ganz wirr vor Glück!\nReiß dich mal zusammen!", italian="Tutta questa felicità deve averti\nconfuso le idee! Cerca di riprenderti!", spanish="Creo que tanta felicidad te está\nobnubilando... ¡Espabila!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You must be all addled from\nbeing so happy! Snap out of it!", french="Ça doit être la joie qui te fait\ndire n'importe quoi! Reprends-toi!", german="Du bist ja ganz wirr vor Glück!\nReiß dich mal zusammen!", italian="Tutta questa felicità deve averti\nconfuso le idee! Cerca di riprenderti!", spanish="Creo que tanta felicidad te está\nobnubilando... ¡Espabila!"})
  else
  SkySceneKit.say({english="You must be all addled from\nbeing so happy! Snap out of it!", french="Ça doit être la joie qui te fait\ndire n'importe quoi! Reprends-toi!", german="Du bist ja ganz wirr vor Glück!\nReiß dich mal zusammen!", italian="Tutta questa felicità deve averti\nconfuso le idee! Cerca di riprenderti!", spanish="Creo que tanta felicidad te está\nobnubilando... ¡Espabila!"})
  end
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  end
  end
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Down)
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Really?[K] Really, I can?", french=" Vraiment?[K] Vous m'acceptez?", german=" Wirklich?[K] Darf ich wirklich?", italian=" Davvero?[K] Posso davvero?", spanish=" ¿De verdad?[K] ¿Puedo?"})
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Yay! I did it!", french=" Yahou, j'ai réussi!", german=" Juchhu! Ich hab es geschafft!", italian=" Sì! Ce l'ho fatta!", spanish=" ¡Sí! ¡Lo he conseguido!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "happy", 1) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_manafi, Direction.Down)
  GROUND:EntTurn(npc_npc_manafi, Direction.Up)
  GROUND:EntTurn(npc_npc_manafi, Direction.Down)
  GROUND:EntTurn(npc_npc_manafi, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english="I'll do my best to make you\nproud, [hero]!", french="Je ferai de mon mieux pour me\nmontrer digne de ton équipe, [hero]!", german="Ich werde mein Bestes geben,\num dich stolz zu machen, [hero]!", italian="Farò del mio meglio per\naiutarvi, [hero]!", spanish="¡Haré todo lo posible para que\nte enorgullezcas de mí, [hero]!"})
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english="If you need me, please call me\nat the Assembly!", french="Si vous avez besoin de moi,\nvenez me chercher au Rassemblement!", german="Falls ihr mich braucht, ruft mich\nbitte einfach am Treffpunkt!", italian="Quando avete bisogno di me,\nchiamatemi al Raduno!", spanish="Si me necesitáis, venid a\nbuscarme al Registro..."})
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" I'll come running!", french=" J'accourrai!", german=" Dann komme ich gerannt!", italian=" Verrò di corsa!", spanish=" ¡Y me presentaré enseguida!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(ProcessSpecial(PROCESS_SPECIAL_PREPARE_MENU_ACCEPT_TEAM_MEMBER, 16, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(message_Menu(MENU_ACCEPT_TEAM_MEMBER)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  pcall(function() SOUND:StopBGM() end)
  pcall(function() SOUND:PlayFanfare("Fanfare/JoinTeam") end) -- me_Play(5) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english="[CN][c_name:NPC_NEW_FRIEND] joined the team!", french="[CN][c_name:NPC_NEW_FRIEND] rejoint l'équipe!", german="[CN][c_name:NPC_NEW_FRIEND] gehört nun zum Team.", italian="[CN][c_name:NPC_NEW_FRIEND] si unisce alla squadra!", spanish="[CN]¡[c_name:NPC_NEW_FRIEND] se ha unido al equipo!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:FadeOut(false, 60)
  SkyProg.set(29, 95) -- $SCENARIO_MAIN = scn[29,95] (ROM)
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GROUND:TeleportTo(hero, 284, 196, Direction.Down)
  GROUND:TeleportTo(partner, 260, 196, Direction.Down)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  GAME:WaitFrames(60)
  GAME:FadeIn(30)
  -- GAP: BGM BGM_DO_YOUR_BEST_AS_ALWAYS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySceneKit.cleanup_npcs()
end
