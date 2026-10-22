-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P04P01C/m10a1206.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_TIME_GEAR non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_P04P01C) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_yukushii = SkySceneKit.spawn_npc("uxie", 160, 352, Direction.Up, "NPC_YUKUSHII")
  GROUND:EntTurn(npc_npc_yukushii, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="Others before you have tried\nto trespass here.", french="D'autres ont essayé de\ns'introduire ici avant vous.", german="Vor euch haben schon andere\nversucht, hierherzukommen.", italian="Prima di voi, altri hanno cercato\ndi giungere fino a qui...", spanish="Muchos han intentado llegar\nhasta aquí antes."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="But I used my [CS:N]Groudon[CR] illusion\nto chase most of them off.", french="Mais je me suis servi de\nmon illusion de [CS:N]Groudon[CR] pour les chasser.", german="Aber ich habe die meisten mit\nmeiner Illusion von [CS:N]Groudon[CR] verscheucht.", italian="Ma quasi tutti si danno alla\nfuga quando si trovano al cospetto del mio\n[CS:N]Groudon[CR] illusorio.", spanish="Pero logré espantarlos con\nla ilusión de [CS:N]Groudon[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Groudon[CR]? [K]How'd you do that?", french=" [CS:N]Groudon[CR]?[K] Comment fais-tu ça?", german="[CS:N]Groudon[CR]? [K]Wie hast du das\ngemacht?", italian="[CS:N]Groudon[CR], già![K] Ma come hai\nfatto a crearlo?", spanish=" ¿[CS:N]Groudon[CR]?[K] ¿Cómo lo hiciste?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Groudon[CR]? [K]How'd you do that?", french=" [CS:N]Groudon[CR]?[K] Comment fais-tu ça?", german="[CS:N]Groudon[CR]? [K]Wie hast du das\ngemacht?", italian="[CS:N]Groudon[CR]...[K] Ma come hai fatto a\ncrearlo?", spanish=" ¿[CS:N]Groudon[CR]?[K] ¿Cómo lo hiciste?"})
  else
  SkySceneKit.say({english=" [CS:N]Groudon[CR]? [K]How'd you do that?", french=" [CS:N]Groudon[CR]?[K] Comment fais-tu ça?", german="[CS:N]Groudon[CR]? [K]Wie hast du das\ngemacht?", italian="[CS:N]Groudon[CR]...[K] Ma come hai fatto a\ncrearlo?", spanish=" ¿[CS:N]Groudon[CR]?[K] ¿Cómo lo hiciste?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="That is something I create using\nmy psychic abilities.", french="Je me sers de mes facultés\npsychiques.", german="Ich erschaffe es mithilfe\nmeiner psychischen Fähigkeiten.", italian="Posso creare delle illusioni\ngrazie ai miei poteri psichici.", spanish="Se trataba de una imagen creada\ncon mis habilidades psíquicas."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english=" Like so...", french=" Comme ceci...", german=" So in etwa...", italian=" Come questa...", spanish=" Así..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6921) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  -- GAP: se_Play(6922) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(10)
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Left)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GAME:MoveCamera(156, 396, 60, false) end) -- performer/caméra
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(partner, 180, 412, false, 2) -- Slide2PositionMark (glissement)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(hero, 208, 380, false, 2) -- Slide2PositionMark (glissement)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waah!", french=" Ouaah!", german=" Waah!", italian=" Waah!", spanish=" ¡Aaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah!", french=" Ouaah!", german=" Waah!", italian=" Waah!", spanish=" ¡Aaah!"})
  else
  SkySceneKit.say({english=" Waah!", french=" Ouaah!", german=" Waah!", italian=" Aaah!", spanish=" ¡Aaah!"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english=" There is no need to be startled.", french=" N'ayez crainte.", german="Es besteht kein Grund,\nzu erschrecken.", italian=" Non c'è niente da temere.", spanish=" No hay por qué alarmarse."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english=" As I've said, it's just an illusion.", french="Comme je vous l'ai dit, il s'agit\nd'une simple illusion.", german="Wie gesagt, es ist nur eine\nIllusion.", italian="Come dicevo, si tratta solo di\nun'illusione.", spanish="Tal y como he dicho, solo es\nuna ilusión."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="What you fought was no more\nthan that.", french=" Rien de plus.", german="Was ihr bekämpft habt, war\nnichts weiter als das.", italian="Anche quella contro la quale\navete lottato prima non era che\nun'illusione.", spanish=" Combatisteis contra algo irreal."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="There have been others before\nwho defeated my [CS:N]Groudon[CR] illusion.", french="D'autres avant vous sont\nparvenus à vaincre cette illusion de [CS:N]Groudon[CR].", german="Es hat schon andere gegeben,\ndie meine Illusion von [CS:N]Groudon[CR] besiegt haben.", italian="Non siete i primi ad aver\nsconfitto il mio [CS:N]Groudon[CR] illusorio.", spanish="No sois los únicos que habéis\nderrotado la ilusión de [CS:N]Groudon[CR].\nAlgunos más lo han logrado también."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="They managed to make their way\nto this spot.", french=" Et ils ont pu arriver jusqu'ici.", german="Sie haben es geschafft, an\ndiesen Punkt zu gelangen.", italian="Altri, prima di voi, sono giunti\nfino a qui.", spanish="Consiguieron llegar hasta donde\nestáis."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="But they were trespassers![K]\nSo I took away their memories...", french="Mais c'étaient des intrus![K]\nAlors j'ai effacé tous leurs souvenirs...", german="Aber es waren Eindringlinge![K]\nAlso habe ich ihnen das Gedächtnis genommen...", italian="Non avrebbero mai dovuto\nfarlo![K] Ho dovuto cancellare i\nloro ricordi...", spanish="¡Pero eran intrusos![K] Por eso les\narrebaté sus recuerdos..."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english=" And, thus, protected the lake.", french=" De manière à protéger le lac.", german="Und so habe ich den See\ngeschützt.", italian="... per proteggere il segreto del\nlago.", spanish=" Así protegí el lago."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yukushii, 4) end)
  GROUND:MoveToPosition(partner, 156, 396, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yukushii, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() SOUND:FadeOutBGM(180) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Took away their memories...?", french=" Effacé leurs souvenirs...?", german=" Das Gedächtnis genommen?", italian=" Cancellare i loro ricordi...?", spanish=" ¿Les arrebataste sus recuerdos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Took away their memories...?", french=" Effacé leurs souvenirs...?", german=" Das Gedächtnis genommen?", italian=" Cancellare i loro ricordi...?", spanish=" ¿Les arrebataste sus recuerdos?"})
  else
  SkySceneKit.say({english=" Took away their memories...?", french=" Effacé leurs souvenirs...?", german=" Das Gedächtnis genommen?", italian=" Cancellare i loro ricordi...?", spanish=" ¿Les arrebataste sus recuerdos?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="...Oh, right![K] We need to ask you\nsomething, [CS:N]Uxie[CR]!", french="... Oh, à ce propos![K] On a\nquelque chose à te demander, [CS:N]Créhelf[CR]!", german="...Oh, richtig![K] Wir müssen dich\netwas fragen, [CS:N]Selfe[CR]!", italian="Giusto![K] Dobbiamo chiederti una\ncosa, [CS:N]Uxie[CR]!", spanish="¡Ah, es cierto![K] [CS:N]Uxie[CR], tenemos\nque preguntarte algo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="...Oh, that's right![K] We hope to\nask you something, [CS:N]Uxie[CR]!", french="... Oh, à ce propos![K] On a\nquelque chose à te demander, [CS:N]Créhelf[CR]!", german="...Ach ja, richtig![K] Wir hoffen,\ndich etwas fragen zu können, [CS:N]Selfe[CR]!", italian="Quasi dimenticavo![K] Abbiamo una\ndomanda per te, [CS:N]Uxie[CR]!", spanish="¡Ah, es cierto![K] [CS:N]Uxie[CR], queríamos\npreguntarte algo."})
  else
  SkySceneKit.say({english="...Oh, I almost forgot![K] We hope\nto ask you something, [CS:N]Uxie[CR]!", french="... Oh, à ce propos![K] On a\nquelque chose à te demander, [CS:N]Créhelf[CR]!", german="...Ach ja, fast hätte ich es\nvergessen![K] Wir wollen dich etwas fragen,\n[CS:N]Selfe[CR]!", italian="Quasi dimenticavo![K] Abbiamo una\ndomanda per te, [CS:N]Uxie[CR]!", spanish="¡Ah, casi me olvido![K] [CS:N]Uxie[CR], nos\ngustaría preguntarte algo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Meet my partner, [hero]!", french=" Voici mon acolyte, [hero]!", german="Das ist mein Partner,\n[hero]!", italian=" Ecco, si tratta di [hero]!", spanish="Este es mi acompañante,\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Meet my partner, [hero]!", french=" Voici mon acolyte, [hero]!", german="Das ist mein Partner,\n[hero]!", italian=" Ecco, si tratta di [hero]!", spanish="Este es mi acompañante,\n[hero]."})
  else
  SkySceneKit.say({english="Let me introduce my partner,\n[hero]!", french=" Voici mon acolyte, [hero]!", german="Dies ist mein Partner,\n[hero]!", italian=" Ecco, si tratta di [hero]!", spanish="Este es mi acompañante,\n[hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="At present, a Pokémon! At one\ntime, a human!", french="Aujourd'hui Pokémon, autrefois\nêtre humain!", german="Mein Partner ist jetzt ein\nPokémon, war aber früher ein Mensch!", italian="Ora è un Pokémon, ma una volta\nera un essere umano!", spanish="Aquí donde le ves, este Pokémon\nera humano."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="At present, a Pokémon! At one\ntime, a human!", french="Aujourd'hui Pokémon, autrefois\nêtre humain!", german="Mein Partner ist jetzt ein\nPokémon, war aber früher ein Mensch!", italian="Come vedi, adesso è un\nPokémon, ma devi sapere che prima\nera un essere umano!", spanish="Aquí donde le ves, este Pokémon\nera humano."})
  else
  SkySceneKit.say({english="At present, a Pokémon! At one\ntime, a human!", french="Aujourd'hui Pokémon, autrefois\nêtre humain!", german="Mein Partner ist jetzt ein\nPokémon, war aber früher ein Mensch!", italian="Come vedi, adesso è un\nPokémon, ma devi sapere che prima\nera un essere umano!", spanish="Aquí donde le ves, este Pokémon\nera humano."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukushii, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english=" Oh, really?[K] A human?", french=" Ah, vraiment?[K] Un être humain?", german=" Oh, wirklich?[K] Ein Mensch?", italian=" Davvero?[K] Un essere umano?", spanish=" ¿En serio?[K] ¿Humano?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yep! But [hero] has lost\nall memory of being a human.", french="Oui! Mais [hero] n'a aucun\nsouvenir de sa vie humaine.", german="Ja! Aber [hero] hat jede\nErinnerung an das Dasein als Mensch verloren.", italian="Già! Ma [hero] non\nricorda più nulla di quando era un essere\numano!", spanish="Sí, pero [hero] ha perdido\nlos recuerdos de cuando era humano."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yes! But [hero] has lost\nall memory of being a human.", french="Oui! Mais [hero] n'a aucun\nsouvenir de sa vie humaine.", german="Ja! Aber [hero] hat jede\nErinnerung an das Dasein als Mensch verloren.", italian="È così! Ma adesso [hero]\nnon ricorda più nulla di quando era un essere\numano!", spanish="Sí, pero [hero] ha perdido\nlos recuerdos de cuando era humano."})
  else
  SkySceneKit.say({english="Oh, yes! But [hero] has\nlost all memory of being a human.", french="Oui! Mais [hero] n'a aucun\nsouvenir de sa vie humaine.", german="Ja! Aber [hero] hat jede\nErinnerung an das Dasein als Mensch verloren.", italian="È così! Ma adesso [hero]\nnon ricorda più nulla di quando era un essere\numano!", spanish="Sí, pero [hero] ha perdido\nlos recuerdos de cuando era humano."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So, we just gotta wonder...[K]have\nyou met [hero] here before, [CS:N]Uxie[CR]?", french="Alors on se demandait...[K] Est-ce\nque tu as déjà vu [hero] dans le coin,\n[CS:N]Créhelf[CR]?", german="Und darum fragen wir uns...[K]\nWar [hero] schon einmal hier, [CS:N]Selfe[CR]?", italian="La domanda è questa, [CS:N]Uxie[CR]...[K]\nNon è che per caso tu e [hero] vi siete\ngià incontrati?", spanish="Por eso tenemos una\npregunta...[K] ¿Habías visto antes\na [hero], [CS:N]Uxie[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So, we're wondering...[K]have you\nmaybe met [hero] here before, [CS:N]Uxie[CR]?", french="Alors on se demandait...[K] Est-ce\nque tu as déjà vu [hero] dans le coin,\n[CS:N]Créhelf[CR]?", german="Also fragen wir uns...[K]\nHast du [hero] schon einmal hier\ngesehen, [CS:N]Selfe[CR]?", italian="Siamo venuti qui per chiederti\nquesto...[K] [CS:N]Uxie[CR], tu e [hero] vi siete già\nincontrati?", spanish="Por eso nos preguntábamos...[K]\nsi habías visto antes a [hero], [CS:N]Uxie[CR]."})
  else
  SkySceneKit.say({english="So, if we may ask...[K]have you\nmet [hero] here before, [CS:N]Uxie[CR]?", french="Alors on se demandait...[K] Est-ce\nque tu as déjà vu [hero] dans le coin,\n[CS:N]Créhelf[CR]?", german="Also würden wir gerne\nwissen...[K] War [hero] schon einmal hier,\n[CS:N]Selfe[CR]?", italian="La domanda è questa, [CS:N]Uxie[CR]...[K]\nTu e [hero] vi siete già incontrati?", spanish="Por eso nos preguntábamos...[K]\nsi habías visto antes a [hero], [CS:N]Uxie[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And did you wipe [hero]'s\nmemory clean?", french="Et est-ce que tu n'aurais pas\neffacé sa mémoire, par hasard?", german="Und hast du das Gedächtnis\nvon [hero] gelöscht?", italian="Non avrai per caso cancellato la\nmemoria di [hero]?", spanish="¿Podrías haberle borrado\nla memoria a [hero] anteriormente?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And did you take away\n[hero]'s memory?", french="Et est-ce que tu n'aurais pas\neffacé sa mémoire, par hasard?", german="Und hast du [hero] das\nGedächtnis genommen?", italian="Hai cancellato tu la memoria\ndi [hero]?", spanish="¿Podrías haberle borrado\nla memoria a [hero] anteriormente?"})
  else
  SkySceneKit.say({english="And did you maybe take away\n[hero]'s memory?", french="Et est-ce que tu n'aurais pas\neffacé sa mémoire, par hasard?", german="Und hast du vielleicht das\nGedächtnis von [hero] gelöscht?", italian="Hai cancellato tu la memoria\ndi [hero]?", spanish="¿Podrías haberle borrado\nla memoria a [hero] anteriormente?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Did that happen?[K] Ever see a\nhuman here before?", french="Ça s'est déjà produit?[K] Tu as\ndéjà vu un être humain ici?", german="War das so?[K] Hast du hier schon\neinmal einen Menschen getroffen?", italian="È andata così?[K] È mai venuto\nqui un umano?", spanish="¿Recuerdas algo que pudiera\nestar relacionado?[K] ¿Habías visto antes\na algún humano por aquí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Has that ever happened?[K]\nDid a human ever come here?", french="Ça s'est déjà produit?[K] Tu as\ndéjà vu un être humain ici?", german="Ist das passiert?[K]\nIst jemals ein Mensch hierhergekommen?", italian="È andata così?[K] È mai venuto\nqui un umano?", spanish="¿Recuerdas algo que pudiera\nestar relacionado?[K] ¿Habías visto antes\na algún humano por aquí?"})
  else
  SkySceneKit.say({english="C-could that have happened?[K]\nHas a human ever come here?", french="Ça s'est déjà produit?[K] Tu as\ndéjà vu un être humain ici?", german="W-wäre das möglich?[K]\nIst jemals ein Mensch hierhergekommen?", italian="È andata così?[K] È mai venuto\nqui un umano?", spanish="¿Recuerdas algo que pudiera\nestar relacionado?[K] ¿Habías visto antes\na algún humano por aquí?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Remember anything like that\nhappening, [CS:N]Uxie[CR]?", french="Ça te dit quelque chose,\n[CS:N]Créhelf[CR]?", german="Erinnerst du dich an so etwas,\n[CS:N]Selfe[CR]?", italian=" Ricordi se è mai successo, [CS:N]Uxie[CR]?", spanish="¿Recuerdas que pasara algo así,\n[CS:N]Uxie[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Do you remember anything like\nthat ever happening, [CS:N]Uxie[CR]?", french="Ça te dit quelque chose,\n[CS:N]Créhelf[CR]?", german="Erinnerst du dich, ob so etwas\ngeschehen ist, [CS:N]Selfe[CR]?", italian=" Ricordi se è mai successo, [CS:N]Uxie[CR]?", spanish="¿Recuerdas que pasara algo así,\n[CS:N]Uxie[CR]?"})
  else
  SkySceneKit.say({english="Do you recall that ever\nhappening, [CS:N]Uxie[CR]?", french="Ça te dit quelque chose,\n[CS:N]Créhelf[CR]?", german="Erinnerst du dich, ob so etwas\ngeschehen ist, [CS:N]Selfe[CR]?", italian=" Ricordi se è mai successo, [CS:N]Uxie[CR]?", spanish="¿Recuerdas que sucediera algo\nasí, [CS:N]Uxie[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="The answer is...[K]no.[K] No human\nhas ever come here.", french="La réponse est...[K] non.[K] Jamais\naucun être humain n'est arrivé jusqu'ici.", german="Die Antwort lautet...[K] Nein.[K]\nKein Mensch war jemals hier.", italian="La risposta è...[K] No.[K] Nessun\numano è mai stato qui.", spanish="La verdad es que...[K] no.[K]\nNingún humano ha estado aquí."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="I should explain further...[K]\nI erase only memories of [CS:P]Fogbound Lake[CR].", french="Je vous dois quelques\nexplications...[K] Je n'efface que les souvenirs\ndu [CS:P]Lac des Brumes[CR].", german="Was ihr auch wissen solltet...[K]\nIch lösche nur die Erinnerung an den [CS:P]Nebelsee[CR].", italian="Mi spiegherò meglio...[K]\nIo cancello solo i ricordi che riguardano\nil [CS:P]Lago Foschia[CR].", spanish="Me explicaré mejor.[K] Solo borro los\nrecuerdos del [CS:P]Lago Velado[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="I cannot fully erase all\nmemories from living beings.", french="Je ne peux pas effacer\ncomplètement la mémoire des êtres vivants.", german="Ich kann keinem Lebewesen das\ngesamte Gedächtnis nehmen.", italian="Non ho il potere di annullare\ntutti i ricordi di un essere vivente.", spanish="No puedo eliminar todos los recuerdos\nde los seres vivos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yukushii, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="I had nothing to do with your\nfriend's memory loss.", french="Je n'ai rien à voir avec\nl'amnésie de ton acolyte.", german="Ich habe nichts mit dem\nGedächtnisverlust deines Partners zu tun.", italian="La perdita dei suoi ricordi non è\nopera mia.", spanish="No he tenido nada que ver con la\namnesia de tu acompañante."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yukushii, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="Nor anything to do with your\nfriend's transformation into a Pokémon.", french="Ni avec sa transformation\nen Pokémon, d'ailleurs.", german="Und auch nichts mit der\nVerwandlung in ein Pokémon.", italian="E non ho niente a che vedere con\nla sua trasformazione in Pokémon.", spanish=" Ni con su transformación en Pokémon."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english=" The cause lies elsewhere.", french=" Je n'en connais pas la cause.", german="Den Grund dafür müsst ihr\nanderswo suchen.", italian="La causa di tutto questo deve\nrisiedere altrove.", spanish="Tendréis que buscar la causa en otro\nlugar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, well...OK.", french=" Ah bon... d'accord.", german=" Oh, tja. Okay.", italian=" Mmm... Ok.", spanish=" Vaya... Bueno, de acuerdo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, well...that's OK.", french=" Ah bon... d'accord.", german=" Oh, tja. In Ordnung.", italian=" Ah... Ho capito.", spanish=" Vaya... Bueno, no importa."})
  else
  SkySceneKit.say({english=" Oh, well...thanks anyway.", french=" Ah bon... d'accord.", german=" Oh, tja. Trotzdem danke.", italian=" Ah... Ho capito.", spanish=" Vaya... Gracias de todas formas."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownLeft)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So it doesn't look like you've\nbeen here before, [hero].", french="Donc, on dirait que c'est\nla première fois que tu mets les pieds ici,\n[hero].", german="Wie es aussieht, warst du\nalso noch nie hier, [hero].", italian="A quanto pare, abbiamo preso un\ngranchio, [hero].", spanish="Entonces no tiene pinta de que\nhayas estado aquí antes, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So it doesn't seem like you've\nbeen here after all, [hero].", french="Donc, on dirait que c'est\nla première fois que tu mets les pieds ici,\n[hero].", german="Anscheinend warst du also\ndoch noch nie hier, [hero].", italian="A quanto pare, la risposta alle\nnostre domande non è qui, [hero].", spanish="Entonces no parece que hayas\nestado aquí antes, [hero]."})
  else
  SkySceneKit.say({english="So I guess that you haven't been\nhere after all, [hero]!", french="Donc, on dirait que c'est\nla première fois que tu mets les pieds ici,\n[hero].", german="Wie es aussieht, warst du also\ndoch noch nie hier, [hero]!", italian="A quanto pare, la risposta alle\nnostre domande non è qui, [hero].", spanish="Entonces supongo que no has\nestado aquí antes, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Uxie[CR], we wanted to meet you to\nlearn more about my partner...[K]\nUh, what's that?!", french="[CS:N]Créhelf[CR], on voulait te voir\npour en savoir plus sur mon acolyte...[K]\nHein? Qu'est-ce que c'est que ça?!", german="[CS:N]Selfe[CR], wir wollten dich treffen,\num mehr über meinen Partner zu erfahren...[K]\nÄh, was ist das?!?", italian="Sai, [CS:N]Uxie[CR], speravamo di scoprire\nqualcosa di più e...[K]\nEhi, che succede?", spanish="[CS:N]Uxie[CR], vinimos aquí esperando\ndescubrir algo más sobre mi acompañante.[K]\n¿Eh? ¡¿Qué es eso?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Uxie[CR], we hoped to meet you to\nlearn more about my partner...[K]\nUh, what's that?!", french="[CS:N]Créhelf[CR], on voulait te voir\npour en savoir plus sur mon acolyte...[K]\nHein? Qu'est-ce que c'est que ça?!", german="[CS:N]Selfe[CR], wir hatten gehofft,\nvon dir mehr über meinen Partner zu\nerfahren...[K] Äh, was ist das?!?", italian="Speravamo che potessi aiutarci,\n[CS:N]Uxie[CR], ma purtroppo...[K]\nEhi, che succede?", spanish="[CS:N]Uxie[CR], vinimos aquí esperando\ndescubrir algo más sobre mi acompañante.[K]\n¿Eh? ¡¿Qué es eso?!"})
  else
  SkySceneKit.say({english="[CS:N]Uxie[CR], we wanted to meet you to\nlearn more about my partner...[K]\nUh, what's that?!", french="[CS:N]Créhelf[CR], on voulait te voir\npour en savoir plus sur mon acolyte...[K]\nHein? Qu'est-ce que c'est que ça?!", german="[CS:N]Selfe[CR], wir wollten dich treffen,\num mehr über meinen Partner zu erfahren...[K]\nÄh, was ist das?!?", italian="Speravamo che potessi aiutarci,\n[CS:N]Uxie[CR], ma purtroppo...[K]\nEhi, che succede?", spanish="[CS:N]Uxie[CR], vinimos aquí esperando\ndescubrir algo más sobre mi acompañante.[K]\n¿Eh? ¡¿Qué es eso?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(2) [neutre/état moteur]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="A Time Gear! A Time Gear![K]\nWell, too bad!", french="Un Rouage du Temps! Un Rouage du Temps!\nOh, quel dommage!", german="Ein Zahnrad der Zeit!\nEin Zahnrad der Zeit![K]\nTja, zu schade!", italian="Un Ingranaggio del Tempo! ♪[K]\nUn Ingranaggio del Tempo! ♪", spanish="¡Un Engranaje del Tiempo!\n¡Un Engranaje del Tiempo![K] ¡Qué mala pata!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukushii, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.Down)
  pcall(function() GAME:MoveCamera(156, 484, 60, false) end) -- performer/caméra
  GAME:WaitFrames(30)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 160, 536, Direction.Up, "NPC_PUKURIN")
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(0), p.Y+(-40), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" We can't take a Time Gear.", french="On ne peut pas faire main basse\nsur un Rouage du Temps.", german="Wir können kein Zahnrad der\nZeit mitnehmen.", italian="È veramente un Ingranaggio del\nTempo! ♪", spanish="No podemos llevarnos\nun Engranaje del Tiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]W-Wigglytuff[CR]!", french=" [CS:N]G-Grodoudou[CR]!", german=" [CS:N]K-Knuddeluff[CR]!", italian=" [CS:N]W-Wigglytuff[CR]!", spanish=" ¡[CS:N]Wi[CR]... [CS:N]Wigglytuff[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]W-Wigglytuff[CR]!", french=" [CS:N]G-Grodoudou[CR]!", german=" [CS:N]K-Knuddeluff[CR]!", italian=" [CS:N]W-Wigglytuff[CR]!", spanish=" ¡[CS:N]Wi[CR]... [CS:N]Wigglytuff[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]W-Wigglytuff[CR]!", french=" [CS:N]G-Grodoudou[CR]!", german=" [CS:N]K-Knuddeluff[CR]!", italian=" [CS:N]W-Wigglytuff[CR]!", spanish=" ¡[CS:N]Wi[CR]... [CS:N]Wigglytuff[CR]!"})
  end
  -- message_Close
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  pcall(function() GAME:MoveCamera(156, 396, 60, false) end) -- performer/caméra
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(0), p.Y+(-40), false, 2) end
  GROUND:MoveToPosition(npc_npc_pukurin, 184, 396, false, 2)
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:MoveToPosition(npc_npc_pukurin, 184, 356, false, 2)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_yukushii, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Wow! Fantastic!", french=" Waouh! Fantastique!", german=" Wow! Fantastisch!", italian=" Wow! Fantastico! ♪", spanish=" ¡Vaya! ¡Fantástico!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english=" And who might this be?", french=" Mais qui est-ce?", german=" Und wer mag das sein?", italian=" Con chi ho l'onore...?", spanish=" ¿Y este quién es?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Our Guildmaster!", french=" Le Maître de notre Guilde!", german=" Unser Gildenmeister!", italian=" È il nostro Capitano!", spanish=" ¡Es el Gran Bluff!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That's our Guildmaster!", french=" Le Maître de notre Guilde!", german=" Das ist unser Gildenmeister!", italian="Ti presento il capo della nostra\nGilda!", spanish=" ¡Es el Gran Bluff!"})
  else
  SkySceneKit.say({english=" Oh, meet our Guildmaster!", french=" Le Maître de notre Guilde!", german="Oh, darf ich vorstellen?\nUnser Gildenmeister!", italian="Ti presento il capo della nostra\nGilda!", spanish=" ¡Ah, este es el Gran Bluff!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(npc_npc_pukurin, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Glad to meet you, friend! ♪\nFriend! ♪ Friend! ♪ Friend! ♪", french="Heureux de te connaître, mon\nami! ♪ Ami! ♪ Ami! ♪ Ami! ♪", german="Hocherfreut, mein Freund! ♪\nFreund! ♪ Freund! ♪ Freund! ♪", italian="Piacere di conoscerti, amico! ♪\nAmico! ♪ Amici! ♪ Amicissimiiii! ♪", spanish="¡Encantado de conocerte, amigo! ♪\n¡Amigo! ♪ ¡Amigo! ♪ ¡Amigo! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_pukurin, 140, 380, false, 2)
  GROUND:EntTurn(npc_npc_yukushii, Direction.DownLeft)
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Glad to greet you, friend! ♪\nFriend! ♪ Amazing! ♪ Friend! ♪", french="Heureux de te connaître aussi,\nmon ami! Incroyable ami! ♪ Ami de moi! ♪", german="Hocherfreut, mein Freund! ♪\nFreund! ♪ Erstaunlich! ♪ Freund! ♪", italian="Piacere di conoscere anche\nte! ♪ Amicissimo! ♪ Amico! ♪", spanish="¡Encantado de saludarte, amigo! ♪\n¡Amigo! ♪ ¡Amigo! ♪ ¡Amigo! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(20), p.Y+(0), false, 2) end
  GROUND:EntTurn(npc_npc_yukushii, Direction.Right)
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:MoveToPosition(npc_npc_pukurin, 184, 356, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_pukurin, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Gaze upon this amazing view!", french="Regardez-moi cette vue\nmagnifique!", german="Seht euch diese umwerfende\nAussicht an!", italian="E guardate! ♪\nC'è una vista spettacolare!", spanish=" ¡Qué vista tan maravillosa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  GROUND:EntTurn(npc_npc_yukushii, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I'm delighted we came!\nLa-dee-la! ♪ Dee-la-dee! ♪", french="Je suis enchanté qu'on soit\nvenus! La la la! ♪ Ti ti ti li ti! ♪", german="Ich bin froh, dass wir\nhergekommen sind! La-di-la! ♪ Di-la-di! ♪", italian="Sono così contento che siamo\nvenuti quiiii! Ullalà! ♪ Zum-pappà! ♪", spanish="¡Qué alegría haber venido!\n¡Larilá! ♪ ¡Larilá! ♪"})
  -- SetAnimation(4) [anim idle native]
  -- message_Close
  GAME:WaitFrames(15)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
end
