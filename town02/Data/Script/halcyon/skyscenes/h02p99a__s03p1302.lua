-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/s03p1302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 280, 144, Direction.Down, "NPC_PERAPPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_manafi = SkySceneKit.spawn_npc("manaphy", 312, 184, Direction.Down, "NPC_MANAFI")
  -- SetAnimation(46) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Waterfall Cave.ogg", true) end)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh no...[K] Why is this happening?", french="Oh non...[K] Pourquoi est-ce que ça\nnous arrive?", german="Oh nein...[K] Wie konnte das nur\npassieren?", italian="Oh, no...[K] Ma che sta\nsuccedendo?", spanish=" Oh, no...[K] Pero, ¿por qué?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh no...[K] What should we do?", french="Oh non...[K] Pourquoi est-ce que ça\nnous arrive?", german=" Oh nein...[K] Was sollen wir tun?", italian="Oh, no...[K] Ma che sta\nsuccedendo?", spanish=" Oh, no...[K] ¿Qué hacemos?"})
  else
  SkySceneKit.say({english=" Oh no...[K] How could this happen?", french="Oh non...[K] Pourquoi est-ce que ça\nnous arrive?", german="Oh nein...[K] Wie konnte das nur\npassieren?", italian="Oh, no...[K] Ma che sta\nsuccedendo?", spanish=" Oh, no...[K] ¿Qué hacemos?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(8), false, 2) end
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" !!![K] You've found [CS:N]Manaphy[CR]!", french=" !!![K] Vous avez trouvé [CS:N]Manaphy[CR]!", german=" Ihr habt...[K] [CS:N]Manaphy[CR] gefunden!", italian="[K] Avete trovato [CS:N]Manaphy[CR]!", spanish="(!)[K] ¡Habéis encontrado a\n[CS:N]Manaphy[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Chatot[CR]![K] [CS:N]Manaphy[CR] is...[K]\n[CS:N]Manaphy[CR] is...", french="[CS:N]Pijako[CR]![K] [CS:N]Manaphy[CR] est...[K]\nIl est...", german="[CS:N]Plaudagei[CR]![K] [CS:N]Manaphy[CR] ist...[K]\n[CS:N]Manaphy[CR] ist...", italian="[CS:N]Chatot[CR]![K] [CS:N]Manaphy[CR] è...[K]\n[CS:N]Manaphy[CR] è...", spanish="¡[CS:N]Chatot[CR]![K] [CS:N]Manaphy[CR] está...[K]\n[CS:N]Manaphy[CR] está..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Chatot[CR]![K] [CS:N]Manaphy[CR] is...[K]\n[CS:N]Manaphy[CR] is...", french="[CS:N]Pijako[CR]![K] [CS:N]Manaphy[CR] est...[K]\nIl est...", german="[CS:N]Plaudagei[CR]![K] [CS:N]Manaphy[CR] ist...[K]\n[CS:N]Manaphy[CR] ist...", italian="[CS:N]Chatot[CR]![K] [CS:N]Manaphy[CR] è...[K]\n[CS:N]Manaphy[CR] è...", spanish="¡[CS:N]Chatot[CR]![K] [CS:N]Manaphy[CR] está...[K]\n[CS:N]Manaphy[CR] está..."})
  else
  SkySceneKit.say({english="[CS:N]Chatot[CR]![K] [CS:N]Manaphy[CR] is...[K]\n[CS:N]Manaphy[CR] is...", french="[CS:N]Pijako[CR]![K] [CS:N]Manaphy[CR] est...[K]\nIl est...", german="[CS:N]Plaudagei[CR]![K] [CS:N]Manaphy[CR] ist...[K]\n[CS:N]Manaphy[CR] ist...", italian="[CS:N]Chatot[CR]![K] [CS:N]Manaphy[CR] è...[K]\n[CS:N]Manaphy[CR] è...", spanish="¡[CS:N]Chatot[CR]![K] [CS:N]Manaphy[CR] está...[K]\n[CS:N]Manaphy[CR] está..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_perappu, 284, 180, false, 2)
  GROUND:EntTurn(npc_npc_perappu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" [CS:N]Ma-[CR][K][CS:N]Manaphy[CR]!", french=" [CS:N]Ma[CR]...[K] [CS:N]Manaphy[CR]!", german=" [CS:N]Ma-[CR][K][CS:N]Manaphy[CR]!", italian=" [CS:N]Ma-[CR][K][CS:N]Manaphy[CR]!", spanish=" [CS:N]Ma[CR]... [K]¡[CS:N]Manaphy[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="My goodness! He's running a\nfrightful fever!", french="Mes aïeux! Mais il a une fièvre\népouvantable!", german="Meine Güte! Es leidet unter\nextrem hohem Fieber!", italian=" Capperi! Ha la febbre altissima!", spanish=" ¡Vaya! ¡Tiene muchísima fiebre!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We know...[K] We found him\nstanding on the beach. Then he flopped over...", french="Oui...[K] au moment où on l'a\ntrouvé à la plage, il s'est écroulé...", german="Das wissen wir...[K] Wir haben es\nam Strand gefunden. Dann ist es umgekippt...", italian="Lo sappiamo...[K] Lo abbiamo\ntrovato in spiaggia. Poi si è accasciato...", spanish="Sí...[K] Tras encontrarlo en la playa\nse desmayó."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We know...[K] We found him\nstanding on the beach. Then he toppled over.", french="Oui...[K] au moment où on l'a\ntrouvé à la plage, il s'est écroulé...", german="Das wissen wir...[K] Wir haben es\nam Strand gefunden. Dann ist es umgefallen...", italian="Lo sappiamo...[K] Lo abbiamo\ntrovato in spiaggia. Poi si è accasciato...", spanish="Sí...[K] Tras encontrarlo en la playa\nse desmayó."})
  else
  SkySceneKit.say({english="Yes, we know.[K] We found him\nstanding on the beach. Then he flopped over.", french="Oui...[K] au moment où on l'a\ntrouvé à la plage, il s'est écroulé...", german="Das wissen wir...[K] Wir haben es\nam Strand gefunden. Dann ist es umgekippt...", italian="Lo sappiamo...[K] Lo abbiamo\ntrovato in spiaggia. Poi si è accasciato...", spanish="Sí...[K] Tras encontrarlo en la playa\nse desmayó."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="His illness must be caused by\nbeing in the wrong environment.", french="Son mal doit être causé par\nl'inadaptation de son environnement.", german="Seine Krankheit rührt wohl von\nder falschen Umgebung her.", italian="La sua malattia deve essere\nstata causata dall'ambiente non adatto.", spanish="Su enfermedad seguramente se\ndeba a que está fuera de su hábitat."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Just as I'd thought, [CS:N]Manaphy[CR] is a\nPokémon that needs to grow in the sea.", french="C'est bien ce que je pensais,\n[CS:N]Manaphy[CR] est un Pokémon qui\na besoin de grandir en milieu marin.", german="Es ist, wie ich es mir gedacht\nhabe. [CS:N]Manaphy[CR] ist ein Pokémon, das im Meer\naufwachsen muss.", italian="Come pensavo, [CS:N]Manaphy[CR] è un\nPokémon che deve crescere in mare.", spanish="Tal y como imaginaba, [CS:N]Manaphy[CR]\nes un Pokémon que necesita vivir en el mar."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Our environment is entirely\nunlike being in the sea.", french="Notre environnement est\nbeaucoup trop différent de la mer.", german="Unsere Umwelt ist völlig anders\nals das Meer.", italian="Il nostro ambiente è\ncompletamente diverso dal mare.", spanish="Este hábitat es muy perjudicial\npara él."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" That's why this infant is ill.", french="C'est pourquoi ce petit est\nmalade.", german=" Darum ist das Kleine krank.", italian="Ecco perché questo\ncucciolo è malato.", spanish=" Por eso está enfermo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Urk![K] So it's our fault that\n[CS:N]Manaphy[CR] is...", french="Argh![K] Alors c'est de notre faute\nsi [CS:N]Manaphy[CR] est...", german="Umpf![K] Also sind wir schuld\ndaran, dass [CS:N]Manaphy[CR]...", italian="Urk![K] Quindi è colpa nostra se\n[CS:N]Manaphy[CR] è...", spanish="¡Vaya![K] Así que por nuestra\nculpa [CS:N]Manaphy[CR] está..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Urk![K] So it's our fault that\n[CS:N]Manaphy[CR] is...", french="Argh![K] Alors c'est de notre faute\nsi [CS:N]Manaphy[CR] est...", german="Umpf![K] Also sind wir schuld\ndaran, dass [CS:N]Manaphy[CR]...", italian="Urk![K] Quindi è colpa nostra se\n[CS:N]Manaphy[CR] è...", spanish="¡Vaya![K] Así que por nuestra\nculpa [CS:N]Manaphy[CR] está..."})
  else
  SkySceneKit.say({english="Urk![K] So it's our fault that\n[CS:N]Manaphy[CR] is...", french="Argh![K] Alors c'est de notre faute\nsi [CS:N]Manaphy[CR] est...", german="Umpf![K] Also sind wir schuld\ndaran, dass [CS:N]Manaphy[CR]...", italian="Urk![K] Quindi è colpa nostra se\n[CS:N]Manaphy[CR] è...", spanish="¡Vaya![K] Así que por nuestra\nculpa [CS:N]Manaphy[CR] está..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Hmm...[K] Well, as things stand,\nremorse and regret won't help now.", french="Hum...[K] Au point où nous en\nsommes, les remords et les regrets sont\ninutiles.", german="Hmm...[K] Wie die Dinge stehen,\nhilft jetzt kein Jammern und Bedauern.", italian="Mmm...[K] Visto come stanno le\ncose, i rimorsi e i sensi di colpa non\nservono adesso.", spanish="Hum...[K] Ahora no sirve de nada\nlamentarse."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We need to focus solely on\ncuring [CS:N]Manaphy[CR]'s illness.", french="Nous devons nous concentrer\nuniquement sur la guérison de [CS:N]Manaphy[CR].", german="Wir müssen uns voll auf die\nHeilung der Krankheit von [CS:N]Manaphy[CR]\nkonzentrieren.", italian="Dobbiamo pensare a come\ncurare la malattia di [CS:N]Manaphy[CR].", spanish="Centrémonos en curar a\n[CS:N]Manaphy[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But how are we supposed to\ncure him?", french="Mais comment on peut\nle soigner?", german=" Aber wie sollen wir es heilen?", italian="Ma come possiamo farlo\nguarire?", spanish=" ¿Pero cómo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" How do we go about curing him?", french="Mais comment on peut\nle soigner?", german="Wie sollen wir vorgehen, um es\nzu heilen?", italian="Ma come possiamo farlo\nguarire?", spanish=" ¿Y cómo le curamos?"})
  else
  SkySceneKit.say({english=" How do we go about curing him?", french="Mais comment on peut\nle soigner?", german="Wie sollen wir vorgehen, um es\nzu heilen?", italian="Ma come possiamo farlo\nguarire?", spanish=" ¿Cómo le curamos?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Here's something I've heard...", french=" J'ai entendu dire ceci...", german=" Ich habe Folgendes gehört...", italian=" Ho sentito dire una cosa...", spanish=" He oído que..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="According to the Pokémon living\nin the sea, it seems that there is a cure-all\nitem known as Phione Dew.", french="Si l'on en croit les Pokémon qui\nvivent dans la mer, il existerait un remède\nuniversel appelé Rosée Phione.", german="Laut den im Meer lebenden\nPokémon existiert ein Allheilmittel\nnamens Phione-Tau.", italian="Secondo i Pokémon che vivono\nnel mare, pare che esista uno strumento, noto\ncome Brina Phione, che è una vera panacea.", spanish="Según los Pokémon que viven\nen el mar, parece que hay un objeto que\nlo cura todo conocido como Rocío Phione."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="That may be what it takes to\ncure [CS:N]Manaphy[CR]'s illness.", french="Cela pourrait peut-être suffire\nà guérir [CS:N]Manaphy[CR].", german="Das könnte genau das sein, was\nwir zur Heilung der Krankheit von [CS:N]Manaphy[CR]\nbenötigen.", italian="Forse potrebbe essere utile\nper curare [CS:N]Manaphy[CR].", spanish="Tal vez haya que recurrir a él\npara curar a [CS:N]Manaphy[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Phione Dew...[K] So that's what\nwe need.", french="La Rosée Phione...[K] C'est\nbien ce qu'il nous faut.", german="Phione-Tau...[K] Den brauchen wir\nalso.", italian="Brina Phione...[K] Ecco cosa ci\nserve.", spanish="Rocío Phione...[K] así que eso es lo\nque necesitamos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Phione Dew...[K] So that's what\nwe need.", french="La Rosée Phione...[K] C'est\nbien ce qu'il nous faut.", german="Phione-Tau...[K] Den brauchen wir\nalso.", italian="Brina Phione...[K] Ecco cosa ci\nserve.", spanish="Rocío Phione...[K] así que eso es lo\nque necesitamos."})
  else
  SkySceneKit.say({english="Phione Dew...[K] So that's what\nwe need.", french="La Rosée Phione...[K] C'est\nbien ce qu'il nous faut.", german="Phione-Tau...[K] Den brauchen wir\nalso.", italian="Brina Phione...[K] Ecco cosa ci\nserve.", spanish="Rocío Phione...[K] así que eso es lo\nque necesitamos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, [CS:N]Chatot[CR].[K]\nWhere do we find this Phione Dew stuff?", french="Hé, [CS:N]Pijako[CR].[K]\nSais-tu où on trouve cette Rosée Phione?", german="Hey, [CS:N]Plaudagei[CR].[K]\nWo finden wir dieses Phione-Tau-Zeug?", italian="Ehi, [CS:N]Chatot[CR].[K]\nDove possiamo trovare questa Brina Phione?", spanish="Eh, [CS:N]Chatot[CR].[K]\n¿Dónde se encuentra ese Rocío Phione?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hey, [CS:N]Chatot[CR].[K]\nCan you tell us where we can find Phione Dew?", french="Hé, [CS:N]Pijako[CR].[K]\nSais-tu où on trouve cette Rosée Phione?", german="Hey, [CS:N]Plaudagei[CR].[K]\nWeißt du, wo es diesen Phione-Tau gibt?", italian="Ehi, [CS:N]Chatot[CR].[K]\nSapresti dirci dove possiamo trovare\nla Brina Phione?", spanish="Oye, [CS:N]Chatot[CR].[K]\n¿Dónde podemos encontrar el Rocío Phione?"})
  else
  SkySceneKit.say({english="Say, [CS:N]Chatot[CR].[K]\nWhere can we find Phione Dew?", french="Hé, [CS:N]Pijako[CR].[K]\nSais-tu où on trouve cette Rosée Phione?", german="Sag mal, [CS:N]Plaudagei[CR],[K] wo können\nwir Phione-Tau finden?", italian="Dicci, [CS:N]Chatot[CR].[K]\nDove possiamo procurarci la Brina Phione?", spanish="Eh, [CS:N]Chatot[CR].[K]\n¿Dónde podríamos encontrar el Rocío Phione?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="There are Pokémon called [CS:N]Phione[CR]\nthat drift along the sea. They are said to\nproduce Phione Dew.", french="Il y a des Pokémon nommés\n[CS:N]Phione[CR] qui se laissent dériver en mer.\nOn dit qu'ils produisent la Rosée Phione.", german="Es gibt Pokémon, die über die\nMeere treiben. Sie heißen [CS:N]Phione[CR]. Man sagt,\ndass sie Phione-Tau herstellen.", italian="Esistono dei Pokémon di nome\n[CS:N]Phione[CR] che vivono in mare. A quanto si dice\nsono loro a produrre la Brina Phione.", spanish="En el mar hay unos Pokémon\nllamados [CS:N]Phione[CR]. De ellos se cuenta que\nproducen el Rocío Phione."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I believe the [CS:N]Phione[CR] live in an\narea to the west called the [CS:P]Miracle Sea[CR].", french="Je crois que les [CS:N]Phione[CR]\nvivent dans une région de l'ouest, appelée\n[CS:P]Mer Prodige[CR].", german="Soweit ich weiß, leben die\n[CS:N]Phione[CR] im Westen. In einer Gegend, die man\nauch das [CS:P]Mirakelmeer[CR] nennt.", italian="Se ricordo bene, questi Pokémon\nabitano in un luogo a ovest chiamato\n[CS:P]Mar dei Miracoli[CR].", spanish="Creo que los [CS:N]Phione[CR] viven en una\nzona que está al oeste llamada [CS:P]Mar Milagro[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Gotcha. The [CS:P]Miracle Sea[CR]!", french=" Compris. La [CS:P]Mer Prodige[CR]!", german=" Verstanden. Das [CS:P]Mirakelmeer[CR]!", italian=" Afferrato. Il [CS:P]Mar dei Miracoli[CR]!", spanish=" Ajá. [CS:P]Mar Milagro[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK. The [CS:P]Miracle Sea[CR]!", french=" Compris. La [CS:P]Mer Prodige[CR]!", german=" Okay. Das [CS:P]Mirakelmeer[CR]!", italian=" Ok. Il [CS:P]Mar dei Miracoli[CR]!", spanish=" Ajá. [CS:P]Mar Milagro[CR]."})
  else
  SkySceneKit.say({english=" OK. The [CS:P]Miracle Sea[CR] it is!", french=" Compris. La [CS:P]Mer Prodige[CR]!", german=" Okay. Das [CS:P]Mirakelmeer[CR]!", italian=" Ok. Il [CS:P]Mar dei Miracoli[CR]!", spanish=" Entendido. [CS:P]Mar Milagro[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to find the [CS:N]Phione[CR], no\nmatter what, [hero]! It's the only way\nwe can save [CS:N]Manaphy[CR]!", french="Nous devons trouver les [CS:N]Phione[CR]\ncoûte que coûte, [hero]! C'est le seul\nmoyen de sauver [CS:N]Manaphy[CR]!", german="Wir müssen um jeden Preis die\n[CS:N]Phione[CR] finden, [hero]! Es ist der\neinzige Weg, wie wir [CS:N]Manaphy[CR] retten können!", italian="Dobbiamo a tutti i costi trovare\ni [CS:N]Phione[CR], [hero]! È l'unico modo per\nsalvare [CS:N]Manaphy[CR]!", spanish="¡Tenemos que encontrarlos\ncomo sea, [hero]! ¡Es la única forma\nde salvar a [CS:N]Manaphy[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to find the [CS:N]Phione[CR], no\nmatter what, [hero]! It's the only way\nwe can save [CS:N]Manaphy[CR]!", french="Nous devons trouver les [CS:N]Phione[CR]\ncoûte que coûte, [hero]! C'est le seul\nmoyen de sauver [CS:N]Manaphy[CR]!", german="Wir müssen um jeden Preis die\n[CS:N]Phione[CR] finden, [hero]! Es ist der\neinzige Weg, wie wir [CS:N]Manaphy[CR] retten können!", italian="Dobbiamo a tutti i costi trovare\ni [CS:N]Phione[CR], [hero]! È l'unico modo per\nsalvare [CS:N]Manaphy[CR]!", spanish="¡Tenemos que encontrarlos\ncomo sea, [hero]! ¡Es la única forma\nde salvar a [CS:N]Manaphy[CR]!"})
  else
  SkySceneKit.say({english="We have to find the [CS:N]Phione[CR], no\nmatter what, [hero]! It's the only way\nwe can save [CS:N]Manaphy[CR]!", french="Nous devons trouver les [CS:N]Phione[CR]\ncoûte que coûte, [hero]! C'est le seul\nmoyen de sauver [CS:N]Manaphy[CR]!", german="Wir müssen um jeden Preis die\n[CS:N]Phione[CR] finden, [hero]! Es ist der\neinzige Weg, wie wir [CS:N]Manaphy[CR] retten können!", italian="Dobbiamo a tutti i costi trovare\ni [CS:N]Phione[CR], [hero]! È l'unico modo per\nsalvare [CS:N]Manaphy[CR]!", spanish="¡Tenemos que encontrarlos\ncomo sea, [hero]! ¡Es la única forma\nde salvar a [CS:N]Manaphy[CR]!"})
  end
  -- message_Close
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(30)
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetLevel(8) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetCamera(52) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_BlinkMark(52) [neutre/état moteur]
  -- worldmap_SetArrow(52) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  pcall(function() SOUND:PlayFanfare("Fanfare/NewArea") end) -- me_Play(6) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]You can now go to\n[CN]the [CS:P]Miracle Sea[CR]!", french="[CN]Désormais, vous avez accès\n[CN]à la [CS:P]Mer Prodige[CR]!", german="[CN]Du kannst jetzt zum\n[CN][CS:P]Mirakelmeer[CR] gehen!", italian="[CN]Adesso potete andare\n[CN]al [CS:P]Mar dei Miracoli[CR]!", spanish="[CN]¡Ahora puedes ir\n[CN]al [CS:P]Mar Milagro[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[51] = 1 -- dungeon_mode(51) = DMODE_OPEN (ROM)
  -- supervision_LoadStation(LEVEL_H02P99A, 'US03') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(16) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(20) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  SkySceneKit.cleanup_npcs()
end
