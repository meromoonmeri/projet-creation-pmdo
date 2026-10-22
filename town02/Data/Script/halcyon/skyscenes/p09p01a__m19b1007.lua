-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P09P01A/m19b1007.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Hidden Highland.ogg", true) end)
  -- back_SetGround(LEVEL_P09P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  -- GAP: SetEffect 640 — VFX sans émote PMDO équivalente
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 304, 368, Direction.Down, "NPC_YONOWAARU")
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="So that [hero] developed\namnesia...", french="Ainsi donc, [hero] souffre\nd'amnésie...", german="Dass [hero] das\nGedächtnis verlor...", italian="Così sapevo dell'amnesia che\nha colpito [hero]...", spanish="Me enteré de que [hero]\nhabía perdido la memoria..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="and was transformed into a\nPokémon...", french="... et a subi une\ntransformation... en Pokémon...", german="Und dann in ein Pokémon\nverwandelt wurde...", italian="E sapevo anche che aveva\nassunto le sembianze di un Pokémon.", spanish="Y se había convertido en\nun Pokémon..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="which must be because of the\naccident during your time travel...", french="... probablement à cause\nde l'accident qui s'est produit pendant\nvotre voyage dans le temps...", german="Das muss durch den Unfall\nwährend der Zeitreise geschehen sein.", italian="Probabilmente ciò è avvenuto in\nseguito all'incidente occorso durante il viaggio\nnel tempo...", spanish="Sin duda como consecuencia de\nalgún accidente en su viaje en el tiempo..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Well, [hero]'s memory\nloss was a lucky stroke for me!", french="L'amnésie de [hero]\nfut une aubaine pour moi!", german="Nun, dass [hero] das\nGedächtnis verlor, war ein Glücksfall für\nmich!", italian="Beh, la perdita della memoria di\n[hero] per me è stato un colpo di\nfortuna!", spanish="La amnesia de [hero] fue\ntodo un golpe de suerte para mí."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="After all, your partner failed to\nrecognize who I am.", french="Grâce à cela, ton inestimable\npartenaire ne m'a pas reconnu.", german="Schließlich konnte mich dein\nPartner nicht mehr erkennen.", italian="Grazie a questa amnesia, non mi\nha potuto riconoscere.", spanish="Para empezar, cuando me vio\nfue incapaz de reconocerme."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="It was quite easy to win over\nyour partner's trust.", french="Ce fut un jeu d'enfant de gagner\nsa confiance.", german="Es war recht einfach, das\nVertrauen deines Partners zu gewinnen.", italian="È stato piuttosto semplice\nottenere la sua fiducia.", spanish="Fue bastante fácil ganarme\nsu confianza."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="And it was also easy to drag\nthem to the future when the time came!", french="Et, le moment venu, ce fut tout\naussi aisé de l'entraîner avec son acolyte\ndans le futur!", german="Und es war auch einfach, ihn\nin die Zukunft zu holen, als die Zeit reif war!", italian="Così com'è stato semplice\ntrascinare voi due nel futuro quando\nè stata ora di farlo!", spanish="Y cuando llegó el momento, ¡no\nme costó nada traérmelo a rastras al futuro!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk...[K] [CS:N]Dusknoir[CR] really was lying!", french="Argh...[K] Alors finalement, c'est\n[CS:N]Noctunoir[CR] le traître!", german="Umpf...[K] [CS:N]Zwirrfinst[CR] hat wirklich\ngelogen!", italian="Ah...[K] [CS:N]Dusknoir[CR] mentiva\ndavvero!", spanish="Ay...[K] ¡Entonces [CS:N]Dusknoir[CR] nos\nmintió realmente!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk...[K] [CS:N]Dusknoir[CR] really was lying!", french="Argh...[K] Alors finalement, c'est\n[CS:N]Noctunoir[CR] le traître!", german="Umpf...[K] [CS:N]Zwirrfinst[CR] hat wirklich\ngelogen!", italian="Ah...[K] [CS:N]Dusknoir[CR] mentiva\ndavvero!", spanish="Ay...[K] ¡Entonces [CS:N]Dusknoir[CR] nos\nmintió realmente!"})
  else
  SkySceneKit.say({english=" Urk...[K] [CS:N]Dusknoir[CR] really was lying!", french="Argh...[K] Alors finalement, c'est\n[CS:N]Noctunoir[CR] le traître!", german="Umpf...[K] [CS:N]Zwirrfinst[CR] hat wirklich\ngelogen!", italian="Uh...[K] [CS:N]Dusknoir[CR] mentiva\ndavvero!", spanish="Ay...[K] ¡Entonces [CS:N]Dusknoir[CR] nos\nmintió realmente!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Which left you, [CS:N]Grovyle[CR]...[K]\nthe last part of the job to finish.", french="Et il ne me reste plus qu'à\nt'éliminer, toi, [CS:N]Massko[CR]...[K] Après quoi,\nma mission sera terminée.", german="Dann musstest du, [CS:N]Reptain[CR],[K]\neigentlich nur den Rest des Jobs erledigen.", italian="E quindi tu, [CS:N]Grovyle[CR]...[K] sei\nrimasto l'ultimo pezzo mancante per\ncompletare il mosaico.", spanish="Solo quedaba un eslabón suelto\npara terminar con éxito mi misión...[K] Tú,\n[CS:N]Grovyle[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, -2) [neutre/état moteur]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 312, 416, Direction.Up, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(180) end)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I was a human from the future...?)", french="(Alors, je suis un humain en provenance\ndu futur...?)", german="(Ich war ein Mensch aus der Zukunft?)", italian="(Ero un essere umano proveniente dal\nfuturo...?)", spanish="(¿Así que yo era un humano del futuro?)"})
  else
  SkySceneKit.say({english="(I was a human from the future...?)", french="(Alors, je suis une humaine en provenance\ndu futur...?)", german="(Ich war ein Mensch aus der Zukunft?)", italian="(Ero un essere umano proveniente dal\nfuturo...?)", spanish="(¿Así que yo era una humana del futuro?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(And I was [CS:N]Grovyle[CR]'s partner on a mission to\nprevent the planet's paralysis?)", french="(Et [CS:N]Massko[CR] et moi étions partenaires,\nen mission pour empêcher la Paralysie\nde la Planète?)", german="(Und ich war der Partner von [CS:N]Reptain[CR] bei\neiner Mission, die Lähmung des Planeten zu\nverhindern?)", italian="(E la mia missione era di prevenire la paralisi\ndel pianeta insieme al mio compagno [CS:N]Grovyle[CR]?)", spanish="(¿Y estaba intentando ayudar a [CS:N]Grovyle[CR] a\nimpedir la parálisis del planeta?)"})
  else
  SkySceneKit.say({english="(And I was [CS:N]Grovyle[CR]'s partner on a mission to\nprevent the planet's paralysis?)", french="(Et [CS:N]Massko[CR] et moi étions partenaires,\nen mission pour empêcher la Paralysie\nde la Planète?)", german="(Und ich war der Partner von [CS:N]Reptain[CR] bei\neiner Mission, die Lähmung des Planeten zu\nverhindern?)", italian="(E la mia missione era di prevenire la paralisi\ndel pianeta insieme al mio compagno [CS:N]Grovyle[CR]?)", spanish="(¿Y estaba intentando ayudar a [CS:N]Grovyle[CR] a\nimpedir la parálisis del planeta?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(And that's how I ended up in [partner]'s\nworld?)", french="(Et c'est comme ça que je me suis retrouvé\ndans le monde de [partner]?)", german="(Und so bin ich dann in der Welt von\n[partner] gelandet?)", italian="(E così sono finito nel mondo di\n[partner]?)", spanish="(¿Fue así como acabé en el mundo de\n[partner]?)"})
  else
  SkySceneKit.say({english="(And that's how I ended up in [partner]'s\nworld?)", french="(Et c'est comme ça que je me suis retrouvée\ndans le monde de [partner]?)", german="(Und so bin ich dann in der Welt von\n[partner] gelandet?)", italian="(E così sono finita nel mondo di\n[partner]?)", spanish="(¿Fue así como acabé en el mundo de\n[partner]?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CS:N]Grovyle[CR] and [hero]![K]\nWith the both of you here...", french="[CS:N]Massko[CR] et [hero]![K]\nEtant donné que vous êtes ici tous les deux...", german="[CS:N]Reptain[CR] und [hero]![K]\nJetzt, wo ihr beide hier seid...", italian="[CS:N]Grovyle[CR] e [hero]![K]\nDato che siete entrambi qua...", spanish="¡[CS:N]Grovyle[CR] y [hero]![K]\nDado que estáis los dos aquí..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Everything will end when we\nfinally dispose of you.", french="... tout sera terminé une fois\nque nous vous aurons anéantis.", german="Ich werde die Sache beenden,\nindem ich euch endlich loswerde.", italian="Non appena ci sbarazzeremo di\nvoi, tutto avrà fine.", spanish="Todo esto llegará a su fin en\ncuanto me libre de vosotros."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="That will finally put an end to\n[CS:N]Grovyle[CR]'s glimmer of hope!", french="Voilà qui va enfin mettre\nun terme à la dernière lueur d'espoir à laquelle\nse raccroche désespérément [CS:N]Massko[CR]!", german="Damit verflüchtigt sich dann\nauch das letzte Fünkchen Hoffnung von\n[CS:N]Reptain[CR]!", italian="Questo spegnerà ogni barlume di\nsperanza rimasto in [CS:N]Grovyle[CR]!", spanish="¡Así se esfumará el último rayo\nde esperanza de [CS:N]Grovyle[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Everything ends! Everything ends\nfor you![K] Ha-ha-hoo-hoo-ha!", french="Tout se termine ici! Votre fin\nest proche![K] Ha ha ha ha ha!", german="Alles geht zu Ende! Zu Ende für\neuch![K] Ha-ha-ho-ho-ha!", italian="È finita! Per voi è finita![K]\nAh-ah-ooh-ooh-ah!", spanish="¡Aquí se acaba todo!\n¡Ha llegado vuestra hora![K] ¡Jua, jua, jua!"})
  -- SetAnimation(49) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urgh! [CS:N]Dusknoir[CR]...[K]no...", french=" Argh! [CS:N]Noctunoir[CR]... [K]non...", german=" Umpf! [CS:N]Zwirrfinst[CR]...[K] Nein...", italian=" Ah! [CS:N]Dusknoir[CR]...[K] No...", spanish=" ¡Glup! [CS:N]Dusknoir[CR]...[K] No..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urgh! [CS:N]Dusknoir[CR]...[K]no...", french=" Argh! [CS:N]Noctunoir[CR]... [K]non...", german=" Umpf! [CS:N]Zwirrfinst[CR]...[K] Nein...", italian=" Ah! [CS:N]Dusknoir[CR]...[K] No...", spanish=" ¡Glup! [CS:N]Dusknoir[CR]...[K] No..."})
  else
  SkySceneKit.say({english=" Urgh! [CS:N]Dusknoir[CR]...[K]no...", french=" Argh! [CS:N]Noctunoir[CR]... [K]non...", german=" Umpf! [CS:N]Zwirrfinst[CR]...[K] Nein...", italian=" Ah! [CS:N]Dusknoir[CR]...[K] No...", spanish=" ¡Glup! [CS:N]Dusknoir[CR]...[K] No..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR]!", french=" [CS:N]Noctunoir[CR]!", german=" [CS:N]Zwirrfinst[CR]!", italian=" [CS:N]Dusknoir[CR]!", spanish=" ¡[CS:N]Dusknoir[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR]!", french=" [CS:N]Noctunoir[CR]!", german=" [CS:N]Zwirrfinst[CR]!", italian=" [CS:N]Dusknoir[CR]!", spanish=" ¡[CS:N]Dusknoir[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR]!", french=" [CS:N]Noctunoir[CR]!", german=" [CS:N]Zwirrfinst[CR]!", italian=" [CS:N]Dusknoir[CR]!", spanish=" ¡[CS:N]Dusknoir[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_PLANETS_PARALYSIS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Ha! Have you finally come to\nterms with your fate?", french="Ha! Vous êtes-vous enfin\nrésignés au sort qui vous attend?", german="Ha! Habt ihr euch endlich mit\neurem Schicksal abgefunden?", italian="Ah! Avete finalmente deciso di\naccettare il vostro destino?", spanish="¡Ja! Me alegro de que por fin\nhayáis aceptado vuestro destino."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]G-Grovyle[CR]!", french=" [CS:N]M-Massko[CR]!", german=" [CS:N]R-Reptain[CR]!", italian=" [CS:N]G-Grovyle[CR]!", spanish=" ¡[CS:N]Grovyle[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]G-Grovyle[CR]!", french=" [CS:N]M-Massko[CR]!", german=" [CS:N]R-Reptain[CR]!", italian=" [CS:N]G-Grovyle[CR]!", spanish=" ¡[CS:N]Grovyle[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]G-Grovyle[CR]!", french=" [CS:N]M-Massko[CR]!", german=" [CS:N]R-Reptain[CR]!", italian=" [CS:N]G-Grovyle[CR]!", spanish=" ¡[CS:N]Grovyle[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [hero]!", french=" [hero]!", german=" [hero]!", italian=" [hero]!", spanish=" ¡[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [hero]!", french=" [hero]!", german=" [hero]!", italian=" [hero]!", spanish=" ¡[hero]!"})
  else
  SkySceneKit.say({english=" [hero]!", french=" [hero]!", german=" [hero]!", italian=" [hero]!", spanish=" ¡[hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="We shall be rid of you for\nall time!", french="Nous serons débarrassés\nde vous pour toujours!", german="Wir werden euch für immer\nlos sein!", italian=" Ci libereremo per sempre di voi!", spanish="¡Ha llegado el momento de que\ndesaparezcáis de una vez!"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" This is the end...[K]for you!", french=" Voici venir la fin...[K] votre fin!", german=" Das ist das Ende...[K] für euch!", italian=" È la fine...[K] per voi!", spanish=" Este es...[K] ¡vuestro fin!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 232, 384, Direction.DownRight, "NPC_YAMIRAMI")
  -- SetAnimation(17) [anim idle native]
  local npc_npc_yamirami4 = SkySceneKit.spawn_npc("sableye", 384, 408, Direction.Left, "NPC_YAMIRAMI4")
  -- SetAnimation(17) [anim idle native]
  local npc_npc_yamirami5 = SkySceneKit.spawn_npc("sableye", 224, 440, Direction.Right, "NPC_YAMIRAMI5")
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(10)
  local npc_npc_yamirami2 = SkySceneKit.spawn_npc("sableye", 368, 384, Direction.DownLeft, "NPC_YAMIRAMI2")
  -- SetAnimation(17) [anim idle native]
  local npc_npc_yamirami3 = SkySceneKit.spawn_npc("sableye", 224, 408, Direction.Right, "NPC_YAMIRAMI3")
  -- SetAnimation(17) [anim idle native]
  local npc_npc_yamirami6 = SkySceneKit.spawn_npc("sableye", 376, 440, Direction.Left, "NPC_YAMIRAMI6")
  -- SetAnimation(17) [anim idle native]
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Wheh-heh-heh!", french=" Whé hé hé!", german=" Wähähäh!", italian=" Meh-eh-eh-eh!", spanish=" ¡Je, je, je, je!"})
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  GROUND:EntTurn(partner, Direction.Left)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(8), p.Y+(8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami2.Position; GROUND:MoveToPosition(npc_npc_yamirami2, p.X+(-8), p.Y+(8), false, 1) end -- Move2PositionOffset
  do local p=npc_npc_yamirami3.Position; GROUND:MoveToPosition(npc_npc_yamirami3, p.X+(8), p.Y+(8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami4.Position; GROUND:MoveToPosition(npc_npc_yamirami4, p.X+(-8), p.Y+(8), false, 1) end -- Move2PositionOffset
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(8), p.Y+(0), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami6.Position; GROUND:MoveToPosition(npc_npc_yamirami6, p.X+(-8), p.Y+(0), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk...", french=" Argh...", german=" Uff...", italian=" Ah...", spanish=" ¡Glup!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk...", french=" Argh...", german=" Uff...", italian=" Ah...", spanish=" ¡Glup!"})
  else
  SkySceneKit.say({english=" Urk...", french=" Argh...", german=" Uff...", italian=" Uh...", spanish=" ¡Glup!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, [hero]! [CS:N]Grovyle[CR]![K]\nYou can't give up!", french="Eh, [hero]! [CS:N]Massko[CR]![K]\nVous ne pouvez pas baisser les bras!", german="Hey, [hero]! [CS:N]Reptain[CR]![K]\nIhr könnt nicht aufgeben!", italian="Ehi, [hero]! [CS:N]Grovyle[CR]![K]\nNon potete mollare!", spanish="¡[hero]! ¡[CS:N]Grovyle[CR]![K]\n¡Escuchadme! ¡No podéis rendiros!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hey, [hero]! [CS:N]Grovyle[CR]![K]\nYou can't give up!", french="Eh, [hero]! [CS:N]Massko[CR]![K]\nVous ne pouvez pas baisser les bras!", german="Hey, [hero]! [CS:N]Reptain[CR]![K]\nIhr könnt nicht aufgeben!", italian="Ehi, [hero]! [CS:N]Grovyle[CR]![K]\nNon potete mollare!", spanish="¡[hero]! ¡[CS:N]Grovyle[CR]![K]\n¡Escuchadme! ¡No podéis rendiros!"})
  else
  SkySceneKit.say({english="Hey, [hero]! [CS:N]Grovyle[CR]![K]\nYou can't give up!", french="Eh, [hero]! [CS:N]Massko[CR]![K]\nVous ne pouvez pas baisser les bras!", german="Hey, [hero]! [CS:N]Reptain[CR]![K]\nIhr könnt nicht aufgeben!", italian="Ehi, [hero]! [CS:N]Grovyle[CR]![K]\nNon potete mollare!", spanish="¡[hero]! ¡[CS:N]Grovyle[CR]![K]\n¡Escuchadme! ¡No podéis rendiros!"})
  end
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Gah...[K] You say not to give up...?", french="Argh...[K] Tu nous encourages à\nfaire front...?", german=" Pah...[K] Nicht aufgeben, sagst du?", italian="Ah...[K] Dici che non dobbiamo\narrenderci...?", spanish="¿Cómo?[K] ¿Has dicho que no nos\nrindamos?"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="But what can we possibly do in\nthis bleak situation?", french="Mais qu'est-ce que tu veux\nqu'on fasse? La situation est désespérée!", german="Aber was können wir in dieser\ntrostlosen Situation denn tun?", italian="Ma cos'altro possiamo fare in\nquesta situazione disperata?", spanish="¿Pero qué podemos hacer en\nuna situación tan adversa como esta?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We have to think!", french=" Creusons-nous les méninges!", german=" Wir müssen nachdenken!", italian=" Dobbiamo pensare!", spanish=" ¡Hay que pensar en algo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We have to think!", french=" Creusons-nous les méninges!", german=" Wir müssen nachdenken!", italian=" Dobbiamo pensare!", spanish=" ¡Hay que pensar en algo!"})
  else
  SkySceneKit.say({english=" We have to think!", french=" Creusons-nous les méninges!", german=" Wir müssen nachdenken!", italian=" Dobbiamo pensare!", spanish=" ¡Hay que pensar en algo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(8), p.Y+(0), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.Left)
  do local p=npc_npc_yamirami2.Position; GROUND:MoveToPosition(npc_npc_yamirami2, p.X+(-8), p.Y+(0), false, 1) end -- Move2PositionOffset
  do local p=npc_npc_yamirami3.Position; GROUND:MoveToPosition(npc_npc_yamirami3, p.X+(8), p.Y+(0), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami4.Position; GROUND:MoveToPosition(npc_npc_yamirami4, p.X+(-8), p.Y+(0), false, 1) end -- Move2PositionOffset
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(8), p.Y+(0), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami6.Position; GROUND:MoveToPosition(npc_npc_yamirami6, p.X+(-8), p.Y+(0), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I know!", french=" J'y suis!", german=" Ich weiß!", italian=" Ecco!", spanish=" ¡Ya sé!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I know!", french=" J'y suis!", german=" Ich weiß!", italian=" Ecco!", spanish=" ¡Ya sé!"})
  else
  SkySceneKit.say({english=" I know!", french=" J'y suis!", german=" Ich weiß!", italian=" Ecco!", spanish=" ¡Ya sé!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Celebi[CR]![K] Can your time travel\nability transport us just the short distance into\nthe Passage of Time?", french="[CS:N]Celebi[CR]![K] Est-ce que tu serais\ncapable de nous téléporter jusqu'au Couloir du\nTemps?", german="[CS:N]Celebi[CR]![K] Kann deine\nZeitreise-Fähigkeit uns das kurze Stück bis\nin den Zeittunnel transportieren?", italian="[CS:N]Celebi[CR]![K] Sei in grado di portarci\ncon la tua abilità fino al Portale del Tempo?\nÈ una distanza breve!", spanish="¡[CS:N]Celebi[CR]![K] ¿Puedes usar tu\nhabilidad para cruzar la distancia que nos\nsepara del Pasaje del Tiempo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Celebi[CR]![K] Can your time travel\nability transport us just the short distance into\nthe Passage of Time?", french="[CS:N]Celebi[CR]![K] Est-ce que tu serais\ncapable de nous téléporter jusqu'au Couloir du\nTemps?", german="[CS:N]Celebi[CR]![K] Kann deine\nZeitreise-Fähigkeit uns das kurze Stück bis\nin den Zeittunnel transportieren?", italian="[CS:N]Celebi[CR]![K] Sei in grado di portarci\ncon la tua abilità fino al Portale del Tempo?\nÈ una distanza breve!", spanish="¡[CS:N]Celebi[CR]![K] ¿Puedes usar tu\nhabilidad para cruzar la distancia que nos\nsepara del Pasaje del Tiempo?"})
  else
  SkySceneKit.say({english="[CS:N]Celebi[CR]![K] Can your time travel\nability transport us just the short distance into\nthe Passage of Time?", french="[CS:N]Celebi[CR]![K] Est-ce que tu serais\ncapable de nous téléporter jusqu'au Couloir du\nTemps?", german="[CS:N]Celebi[CR]![K] Kann deine\nZeitreise-Fähigkeit uns das kurze Stück bis\nin den Zeittunnel transportieren?", italian="[CS:N]Celebi[CR]![K] Sei in grado di portarci\ncon la tua abilità fino al Portale del Tempo?\nÈ una distanza breve!", spanish="¡[CS:N]Celebi[CR]![K] ¿Puedes usar tu\nhabilidad para cruzar la distancia que nos\nsepara del Pasaje del Tiempo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_serebii = SkySceneKit.spawn_npc("celebi", 296, 424, Direction.Up, "NPC_SEREBII")
  GROUND:EntTurn(npc_npc_serebii, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="It won't be easy with [CS:N]Dialga[CR]\nhere!", french="Ce ne sera pas facile, avec\n[CS:N]Dialga[CR] dans les parages!", german="Das wird nicht einfach in der\nGegenwart von [CS:N]Dialga[CR]!", italian=" Non sarà facile con [CS:N]Dialga[CR] qui!", spanish="¡No va a ser fácil en presencia\nde [CS:N]Dialga[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="[CS:N]Dialga[CR] is the Temporal\nPokémon... It controls time itself!", french="[CS:N]Dialga[CR] est le Pokémon\ndu Temps... Il en contrôle le cours!", german="[CS:N]Dialga[CR] ist das Zeit-Pokémon!\nEs kontrolliert die Zeit als solches.", italian="[CS:N]Dialga[CR] è il Pokémon Tempo...\nHa il controllo del tempo stesso!", spanish="[CS:N]Dialga[CR] es el Pokémon Temporal...\n¡Controla el mismísimo tiempo!"})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="Even if I can make us travel in\ntime, he'll have no trouble exposing it!", french="Même si je peux nous faire\nvoyager dans le temps, il n'aura aucune\ndifficulté à nous démasquer!", german="Selbst wenn ich uns auf\nZeitreise schicken kann, wird es das ohne\nProbleme aufdecken können!", italian="Anche se viaggiamo nel tempo,\nnon farà nessuna fatica a trovarci!", spanish="Podría lograr dar un pequeño\nsalto en el tiempo, pero no le costará\ninterceptarnos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(8), p.Y+(0), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami2.Position; GROUND:MoveToPosition(npc_npc_yamirami2, p.X+(-8), p.Y+(0), false, 1) end -- Move2PositionOffset
  do local p=npc_npc_yamirami3.Position; GROUND:MoveToPosition(npc_npc_yamirami3, p.X+(8), p.Y+(0), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami4.Position; GROUND:MoveToPosition(npc_npc_yamirami4, p.X+(-8), p.Y+(0), false, 1) end -- Move2PositionOffset
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(8), p.Y+(0), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami6.Position; GROUND:MoveToPosition(npc_npc_yamirami6, p.X+(-8), p.Y+(0), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Even a little will do![K] Please!", french="Essaie quand même, juste une\nseconde![K] Je t'en prie!", german="Ein klein bisschen würde schon\nhelfen![K] Bitte!", italian="Può bastare anche per un breve\nistante![K] Ti prego!", spanish="¡Bastará con un instante![K]\n¡Por favor!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It just has to work for an\ninstant![K] Please!", french="Essaie quand même, juste une\nseconde![K] Je t'en prie!", german="Es muss nur für einen kurzen\nMoment funktionieren![K] Bitte!", italian="Anche solo per un istante![K]\nPer favore!", spanish="¡Bastará con un instante![K]\n¡Por favor!"})
  else
  SkySceneKit.say({english=" Even a little will do![K] Please!", french="Essaie quand même, juste une\nseconde![K] Je t'en prie!", german="Ein klein bisschen würde schon\nhelfen![K] Bitte!", italian="Può bastare anche per un breve\nistante![K] Ti prego!", spanish="¡Bastará con un instante![K]\n¡Por favor!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Attack!", french=" Chargez!", german=" Angriff!", italian=" All'attacco!", spanish=" ¡Atacad!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Wheh-heh-heh!", french=" Whé hé hé!", german=" Wähähäh!", italian=" Meh-eh-eh-eh!", spanish=" ¡Je, je, je, je!"})
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" Time to travel!", french=" En route!", german=" Zeit für die Reise!", italian=" È ora di viaggiare!", spanish=" ¡Hora de viajar!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(7435) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2)
  -- SetAnimation(12) [anim idle native]
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2)
  -- SetAnimation(12) [anim idle native]
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2)
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(4)
  GAME:FadeOut(true, 15) -- screen_WhiteOut
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(60)
  GAME:FadeIn(15)
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami2, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami3, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami5, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami6, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Wheh-heh...?", french=" Whé hé...?", german=" Wähä?", italian=" Eh-eh...?", spanish=" ¿Eh?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(7)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(3)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" They v-v-[K]vanished?", french=" Ils ont...[K] disparu?", german=" Sie s-sind[K] verschwunden?", italian=" Sono s-s-[K]scomparsi?", spanish=" ¿Eh?[K] ¿Han desaparecido?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Master [CS:N]Dialga[CR]!", french=" Maître [CS:N]Dialga[CR]!", german=" Meister [CS:N]Dialga[CR]!", italian=" Grande [CS:N]Dialga[CR]!", spanish=" ¡Poderoso [CS:N]Dialga[CR]!"})
  -- message_Close
  GAME:FadeOut(false, 15)
  GAME:WaitFrames(30)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V19P03A) [décor sub chargé: Sub_v19p03a]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 17.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  SkySubScreen.Show("v19p03a", 15, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  -- SetAnimation(20) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V19P02A1_281) [routine d'objet NDS non simulée - documenté]
  -- camera2_SetEffect(2, 1, 1.0) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- SetAnimation(3) [anim idle native]
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  SkySceneKit.say({english="GRRR-OOOOOO...OOOOOH!", french="GRRR-OOOOOO... OOOOOH!", german="GRRR-OOOOOO...OOOOOH!", italian="GRRR-OOOOOO... OOOOOH!", spanish="¡GRRRR! ¡GRRRRR! ¡GRRRRRR!"}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(2) -- join WaitSe
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- message_CloseEnforce
  -- camera2_SetEffect(0, 0, 0) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- back2_SetGround(V19P04A) [décor sub chargé: Sub_v19p04a]
  -- back2_SetEffect(7, 0) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  -- camera2_SetPositionMark(Position<'m1', 19.5, 18.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v19p04a", 15, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  -- GAP: se_Play(7437) — id SE NDS sans portage PMDO identifié
  -- camera2_SetPositionMark(Position<'m2', 58.5, 18.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(4)
  -- camera2_SetPositionMark(Position<'m3', 97.5, 18.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(180)
  -- se_FadeOut(7437, 60) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetGround(V19P05A) [décor sub chargé: Sub_v19p05a]
  -- back2_SetEffect(9, 0) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  -- camera2_SetPositionMark(Position<'m4', 19.5, 13.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetAnimation(9) [anim idle native]
  SkySubScreen.Show("v19p05a", 15, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  -- GAP: se_Play(7448) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(17) [anim idle native]
  -- back2_SetEffect(7, 60) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V19P05A1_284) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2) -- join WaitSe
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- back2_SetGround(V19P03A) [décor sub chargé: Sub_v19p03a]
  -- camera2_SetPositionMark(Position<'m5', 19.5, 17.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  -- SetOutputAttribute(2048) [neutre/état moteur]
  -- SetPositionMark OBJECT_V19P02A1_281 [cible sans placement SSA zone: placement non joué]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V19P02A1_281) [routine d'objet NDS non simulée - documenté]
  SkySubScreen.Show("v19p03a", 15, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V19P02A1_281) [routine d'objet NDS non simulée - documenté]
  -- camera2_SetEffect(2, 1, 1.0) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- SetAnimation(3) [anim idle native]
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  SkySceneKit.say({english="GRRR-OOOOOO...OOOOOH!", french="GRRR-OOOOOO... OOOOOH!", german="GRRR-OOOOOO...OOOOOH!", italian="GRRR-OOOOOO... OOOOOH!", spanish="¡GRRRR! ¡GRRRRR! ¡GRRRRRR!"}) -- message_ImitationSound (onomatopée)
  -- GAP: BGM BGM_STRONG_BLAST_NOISE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Hide(2) -- screen2_WhiteOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:WaitFrames(2)
  SkySubScreen.Show("v19p03a", 2, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  -- camera2_SetPositionMark(Position<'m7', 58.5, 17.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(2)
  -- camera2_SetPositionMark(Position<'m8', 97.5, 17.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(2)
  -- camera2_SetPositionMark(Position<'m9', 19.5, 47.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(2)
  -- camera2_SetPositionMark(Position<'m10', 58.5, 47.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(2)
  -- camera2_SetPositionMark(Position<'m11', 97.5, 47.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(2)
  -- camera2_SetPositionMark(Position<'m12', 19.5, 77.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(2)
  -- camera2_SetPositionMark(Position<'m13', 58.5, 77.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(2)
  -- camera2_SetPositionMark(Position<'m14', 97.5, 77.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(2)
  SkySubScreen.Hide(15) -- screen2_WhiteOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:WaitFrames(60)
  -- camera2_SetEffect(0, 0, 0) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false,  15)
  -- message_CloseEnforce
  GAME:FadeOut(false, 0)
  GAME:FadeIn(0)
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
