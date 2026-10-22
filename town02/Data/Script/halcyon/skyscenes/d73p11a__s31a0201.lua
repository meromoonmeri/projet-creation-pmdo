-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P11A/s31a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_NPC_KINOGASSA
    local npc_npc_kinogassa = SkySceneKit.spawn_npc("breloom", 280, 232, Direction.Down, "NPC_KINOGASSA")
    -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
    -- SetAnimation(2) [anim idle native]
    -- @label_3 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    GROUND:EntTurn(npc_npc_kinogassa, Direction.Down)
    pcall(function() GROUND:CharSetEmote(npc_npc_kinogassa, "happy", 1) end)
    GAME:WaitFrames(math.random(90, 180))
    pcall(function() GROUND:CharSetEmote(npc_npc_kinogassa, nil, 0) end) -- EFFECT_NONE
    GROUND:EntTurn(npc_npc_kinogassa, Direction.DownRight)
    -- SetAnimation(4) [anim idle native]
    GAME:WaitFrames(math.random(120, 180))
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
  end)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 10) -- $SCENARIO_MAIN = scn[29,10] (ROM)
  -- back_SetGround(LEVEL_D73P11A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_D73P11A, 'US31') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(20) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(47) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(7) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_sheimi = SkySceneKit.spawn_npc("shaymin", 304, 264, Direction.UpLeft, "NPC_SHEIMI")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_kuchiito = SkySceneKit.spawn_npc("mawile", 280, 264, Direction.Up, "NPC_KUCHIITO")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(180), g.ViewCenter.Y+(0), 360, false) end) -- MovePositionOffset performer/caméra
  -- GAP: BGM BGM_SHAYMIN_VILLAGE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(270)
  GAME:FadeOut(false, 30)
  pcall(function() GAME:MoveCamera(324, 332, 1, false) end) -- SetPositionMark performer/caméra
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 344, 340, false, 2)
  GROUND:MoveToPosition(partner, 308, 340, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So this is the\n[CS:P]Shaymin Village[CR], huh?", french="Alors c'est ici,\nle [CS:P]Village Shaymin[CR]?", german=" Das ist also [CS:P]Shaymin-Dorf[CR].", italian="Così questo è\nil [CS:P]Villaggio Shaymin[CR], eh?", spanish="Así que esta es\n[CS:P]Aldea Shaymin[CR], ¿eh?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So this is the [CS:P]Shaymin Village[CR]?", french="Alors c'est ici,\nle [CS:P]Village Shaymin[CR]?", german=" Das ist also [CS:P]Shaymin-Dorf[CR].", italian="Così è questo\nil [CS:P]Villaggio Shaymin[CR]...", spanish=" ¿Así que esta es [CS:P]Aldea Shaymin[CR]?"})
  else
  SkySceneKit.say({english=" So this is the [CS:P]Shaymin Village[CR]?", french="Alors c'est ici,\nle [CS:P]Village Shaymin[CR]?", german=" Das ist also [CS:P]Shaymin-Dorf[CR].", italian="Così è questo\nil [CS:P]Villaggio Shaymin[CR]...", spanish=" Así que esta es [CS:P]Aldea Shaymin[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Pretty peaceful.", french=" C'est un endroit plutôt calme.", german=" Ziemlich friedlich...", italian=" È molto tranquillo.", spanish=" Es tranquilita."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's pretty peaceful...", french=" C'est un endroit plutôt calme.", german=" Es ist ziemlich friedlich...", italian=" Com'è tranquillo...", spanish=" Es bastante tranquila..."})
  else
  SkySceneKit.say({english=" It's so peaceful...", french=" C'est un endroit plutôt calme.", german=" Es ist so friedlich...", italian=" Che pace...", spanish=" Es de lo más tranquila."})
  end
  -- message_Close
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_sheimi, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_sheimi, 324, 308, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Welcome to the [CS:P]Shaymin Village[CR].", french=" Bienvenue au [CS:P]Village Shaymin[CR].", german=" Willkommen in [CS:P]Shaymin-Dorf[CR].", italian="Vi do il benvenuto\nal [CS:P]Villaggio Shaymin[CR].", spanish=" Os doy la bienvenida a [CS:P]Aldea Shaymin[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="It's nice to meet you.\nMy name is [CS:N]Shaymin[CR].[K]\nI live here in this village.", french="C'est une joie de vous\nrencontrer. Mon nom est [CS:N]Shaymin[CR].[K]\nJe vis ici, dans ce village.", german="Es freut mich, euch zu treffen.\nMein Name ist [CS:N]Shaymin[CR].[K]\nIch lebe in diesem Dorf.", italian="Piacere di conoscervi.\nIl mio nome è [CS:N]Shaymin[CR].[K]\nVivo in questo villaggio.", spanish="Encantada de conoceros. Me llamo\n[CS:N]Shaymin[CR].[K] Y vivo en esta aldea."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Then again, all the residents\nof this village are [CS:N]Shaymin[CR]...[K]\nThat makes it hard to tell us apart, doesn't it?", french="A vrai dire, tous les habitants\nde ce village sont des [CS:N]Shaymin[CR]...[K] et\nil est un peu dur de nous différencier.", german="Andererseits heißen alle\nEinwohner dieses Ortes [CS:N]Shaymin[CR]...[K] Das macht\nes schwierig, uns auseinanderzuhalten, oder?", italian="A essere sinceri, tutti coloro\nche vivono in questo villaggio sono [CS:N]Shaymin[CR]...[K]\nImmagino che non sia facile distinguerci, eh?", spanish="Pero ahora que lo pienso, todos\nlos habitantes de esta aldea somos [CS:N]Shaymin[CR]...[K]\nSupongo que será difícil distinguirnos, ¿no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ha ha ha!", french=" Ha ha ha!", german=" Hahaha!", italian=" Ah ah ah!", spanish=" ¡Ja, ja, ja!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ha ha ha!", french=" Ha ha ha!", german=" Hahaha!", italian=" Ah ah ah!", spanish=" ¡Ja, ja, ja!"})
  else
  SkySceneKit.say({english=" Ha ha ha!", french=" Ha ha ha!", german=" Hahaha!", italian=" Ah ah ah!", spanish=" ¡Ja, ja, ja!"})
  end
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Nice to meet you!\nWe're Team [team:]!", french="Ravi de te rencontrer!\nNous sommes l'Equipe [team:]!", german="Schön, dich kennenzulernen!\nWir sind Team [team:]!", italian="Piacere di conoscerti!\nNoi siamo il Team [team:]!", spanish="Es un placer conocerte.\nSomos el [CS:X]Equipo[CR] [team:]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Nice to meet you!\nWe're Team [team:]!", french="Ravi de te rencontrer!\nNous sommes l'Equipe [team:]!", german="Schön, dich kennenzulernen!\nWir sind Team [team:]!", italian="Piacere di conoscerti!\nNoi siamo il Team [team:]!", spanish="Es un placer conocerte.\nSomos el [CS:X]Equipo[CR] [team:]."})
  else
  SkySceneKit.say({english="Nice to meet you!\nWe're Team [team:]!", french="Ravie de te rencontrer!\nNous sommes l'Equipe [team:]!", german="Schön, dich kennenzulernen!\nWir sind Team [team:]!", italian="Piacere di conoscerti!\nNoi siamo il Team [team:]!", spanish="Es un placer conocerte.\nSomos el [CS:X]Equipo[CR] [team:]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Did you come to climb\n[CS:P]Sky Peak[CR] too, Team [team:]?", french="Vous êtes ici pour gravir le\n[CS:P]Pic Céleste[CR] vous aussi, Equipe [team:]?", german="Wollt ihr auch den [CS:P]Himmelsgipfel[CR]\nbesteigen, Team [team:]?", italian="Anche voi siete qui per scalare\nil [CS:P]Picco del Cielo[CR], Team [team:]?", spanish="¿También venís a escalar la\n[CS:P]Cumbre del Cielo[CR], [CS:X]Equipo[CR] [team:]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yep. That's it.", french=" Oui, en effet.", german=" Ja. Genau.", italian=" Già, proprio così.", spanish=" Sí, eso mismo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yeah, that's right.", french=" Oui, en effet.", german=" Ja, stimmt genau.", italian=" Sì, esatto.", spanish=" Sí, eso es."})
  else
  SkySceneKit.say({english=" Yes, that's correct.", french=" Oui, en effet.", german=" Ja, genau so ist es.", italian=" Sì, infatti.", spanish=" Sí, exacto."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So I bet you know this\nmountain pretty well?", french="Alors, j'imagine que tu\nconnais cette montagne comme ta poche?", german="Also kennt ihr euch recht\ngut mit diesem Berg aus?", italian="Scommetto che conosci\npiuttosto bene questa montagna, eh?", spanish="Seguro que conoces esta\nmontaña como la palma de tu mano, ¿no?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I take it you know this\nmountain well?", french="Alors, j'imagine que tu\nconnais cette montagne comme ta poche?", german="Also nehme ich an, ihr kennt\neuch ganz gut mit diesem Berg aus?", italian="Immagino che tu conosca bene\nquesta montagna...", spanish="Me imagino que conocerás bien\nesta montaña, ¿verdad?"})
  else
  SkySceneKit.say({english="I would assume that you know\nthis mountain very well?", french="Alors, j'imagine que tu\nconnais cette montagne comme ta poche?", german="Ich nehme daher an, dass ihr\ndiesen Berg recht gut kennt?", italian="Suppongo che tu conosca bene\nquesta montagna...", spanish="Supongo que conocerás muy bien\nesta montaña, ¿me equivoco?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="That's right. We've lived here\nfor a very long time...", french="Effectivement. Notre installation\nici remonte à bien longtemps...", german="Das stimmt. Wir leben hier\nschon sehr lange Zeit...", italian="Esatto. Viviamo qui\nda lungo tempo...", spanish="Así es. Hace muchísimo tiempo\nque vivimos aquí..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We're here to guide travelers up\nthe mountain.", french="Nous sommes là pour guider les\nvoyageurs dans leur ascension\nde la montagne.", german="Wir sind hier, um Reisende\nauf den Berg zu führen.", italian="Il nostro compito è fare\nda guida ai viaggiatori che vogliono\nscalare la montagna.", spanish="Estamos aquí para guiar a los\nviajeros en su ascenso a la montaña."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="But we haven't actually done that\nin quite some time.", french="Mais cela fait un moment\nque nous n'avons plus eu l'occasion de le faire.", german="Aber um ehrlich zu sein...\nWir haben das schon sehr lange nicht\nmehr gemacht.", italian="Ma è da tanto tempo che non\nci capita.", spanish="Aunque lo cierto es que hace\nbastante que no llevamos a cabo esta labor."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="That is, the earthquake that\nhappened here some time ago destroyed\nthe mountain path that led here...", french="En effet, il y a quelque temps,\nun tremblement de terre a détruit le sentier\nde montagne qui menait jusqu'ici...", german="Vor einiger Zeit zerstörte ein\nErdbeben nämlich den Gebirgspfad,\nder hierherführte...", italian="E tutto a causa del terremoto\nche tempo fa distrusse il sentiero che\nconduceva al nostro villaggio...", spanish="Resulta que el terremoto que\nhubo hace un tiempo destruyó el sendero\nalpino que conducía a la aldea..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="So explorers from outside\ncouldn't get here very easily, and they\nstopped coming.", french="Du coup, les explorateurs\nont eu plus de mal à trouver le chemin\net ils ont cessé de venir.", german="Das hat es Erkundern von\naußerhalb erschwert, hierherzukommen,\nund sie blieben fern.", italian="Per gli esploratori diventò\nsempre più difficile raggiungere questo\nposto, così alla fine smisero di venire.", spanish="Por lo que los exploradores de\nfuera no podían acceder con facilidad a la\naldea y dejaron de venir."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We were pretty surprised\nwhen the survey team walked into our\nlittle village.", french="Ça a été une vraie surprise\nle jour où l'équipe de reconnaissance est\nentrée dans notre petit village.", german="Wir waren sehr erstaunt, das\nVermessungsteam in unser kleines Dorf\nspazieren zu sehen.", italian="Quindi siamo rimasti di stucco\nquando la squadra di indagine è entrata\nnel nostro piccolo villaggio.", spanish="Nos sorprendimos bastante\ncuando el equipo de reconocimiento llegó a\nnuestra pequeña aldea."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Really? I see.", french=" Vraiment? Je vois.", german=" Wirklich? Verstehe.", italian=" Davvero? Capisco.", spanish=" ¿En serio?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Really? I see.", french=" Vraiment? Je vois.", german=" Wirklich? Verstehe.", italian=" Davvero? Capisco.", spanish=" ¿De verdad?"})
  else
  SkySceneKit.say({english=" Really? I see.", french=" Vraiment? Je vois.", german=" Wirklich? Verstehe.", italian=" Davvero? Capisco.", spanish=" ¿En serio?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That explains why this place has\nonly been talked about in legends, and nobody's\ncome to visit.", french="Alors c'est pour ça qu'on ne\nparlait de cet endroit que dans les légendes\net que plus personne n'y venait.", german="Das erklärt, warum über diesen\nOrt nur in Legenden berichtet wurde und\nniemand ihn jemals zu Gesicht bekommen hat.", italian="Ora si spiega come mai questo\nposto è avvolto nella leggenda e nessuno\nci si avventurava.", spanish="Eso explica por qué solo\nlas leyendas hablaban de este lugar\ny nadie había venido a visitarlo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That explains why this place has\nonly been talked about in legends, and nobody's\ncome to visit.", french="Alors c'est pour ça qu'on ne\nparlait de cet endroit que dans les légendes\net que plus personne n'y venait.", german="Das erklärt, warum über diesen\nOrt nur in Legenden berichtet wurde und\nniemand ihn jemals zu Gesicht bekommen hat.", italian="Ora si spiega come mai questo\nposto è avvolto nella leggenda e nessuno\nci si avventurava.", spanish="Eso explica por qué solo\nlas leyendas hablaban de este lugar\ny nadie había venido a visitarlo."})
  else
  SkySceneKit.say({english="That explains why this place has\nonly been talked about in legends, and nobody's\ncome to visit.", french="Alors c'est pour ça qu'on ne\nparlait de cet endroit que dans les légendes\net que plus personne n'y venait.", german="Das erklärt, warum über diesen\nOrt nur in Legenden berichtet wurde und\nniemand ihn jemals zu Gesicht bekommen hat.", italian="Ora si spiega come mai questo\nposto è avvolto nella leggenda e nessuno\nci si avventurava.", spanish="Eso explica por qué solo\nlas leyendas hablaban de este lugar\ny nadie había venido a visitarlo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, yeah! Speaking of legends...", french=" Ah, oui! A propos de légendes...", german=" Oh, genau! Apropos Legenden...", italian=" Oh, sì! A proposito di leggende...", spanish=" ¡Ah, sí! Hablando de leyendas..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, yeah! Speaking of legends...", french=" Ah, oui! A propos de légendes...", german=" Oh, genau! Apropos Legenden...", italian=" Oh, sì! A proposito di leggende...", spanish="Por cierto, hablando\nde leyendas..."})
  else
  SkySceneKit.say({english=" Oh, yeah! Speaking of legends...", french=" Ah, oui! A propos de légendes...", german=" Oh, genau! Apropos Legenden...", italian=" Oh, sì! A proposito di leggende...", spanish="¡Ah, sí! Ya que hablamos\nde leyendas..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Is it true that there's an\nincredible treasure hidden here, one that\nrivals all other treasures?", french="C'est vrai qu'il y a un trésor\nextraordinaire caché ici, qui surpasserait\nles plus beaux trésors?", german="Stimmt es, dass hier ein\nlegendärer Schatz versteckt liegt? Einer, der\nprächtiger ist als alle anderen?", italian="È vero che da queste parti\nsi nasconde un tesoro talmente favoloso\nda far impallidire tutti gli altri?", spanish="¿Es cierto que hay un tesoro\nincreíble escondido aquí, y que no puede\ncompararse con ningún otro?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Is it true that there's an\nincredible treasure hidden here, one that\nrivals all other treasures?", french="C'est vrai qu'il y a un trésor\nextraordinaire caché ici, qui surpasserait\nles plus beaux trésors?", german="Stimmt es, dass hier ein\nlegendärer Schatz versteckt liegt? Einer, der\nprächtiger ist als alle anderen?", italian="È vero che da queste parti\nsi nasconde un tesoro talmente favoloso\nda far impallidire tutti gli altri?", spanish="¿Es cierto que hay un tesoro\nincreíble escondido aquí, uno sin parangón\nalguno?"})
  else
  SkySceneKit.say({english="Is it true that there's an\nincredible treasure hidden here, one that\nrivals all other treasures?", french="C'est vrai qu'il y a un trésor\nextraordinaire caché ici, qui surpasserait\nles plus beaux trésors?", german="Stimmt es, dass hier ein\nlegendärer Schatz versteckt liegt? Einer, der\nprächtiger ist als alle anderen?", italian="È vero che da queste parti\nsi nasconde un tesoro talmente favoloso\nda far impallidire tutti gli altri?", spanish="¿Es verdad que hay un tesoro\nincreíble escondido aquí, uno que no puede\ncompararse con ningún otro?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Hee hee hee...\nWhat do you think?", french="Hi hi hi...\nD'après vous?", german="Hihihi...\nWas glaubst du?", italian="Ih ih ih...\nVoi che ne dite?", spanish=" Ji, ji, ji... ¿Tú qué crees?"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Our job is not limited to simply\nacting as your guides.", french="Notre travail ne se limite pas\nsimplement à vous servir de guide.", german="Unser Job beschränkt sich nicht\ndarauf, euer Bergführer zu sein.", italian="Il nostro compito non si limita\na fare da guida a voi esploratori.", spanish="Nuestra labor no se limita solo\na guiaros."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="But in the end, those climbing\nthe mountain must discover some things\nfor themselves.", french="Ceux qui gravissent cette\nmontagne doivent découvrir quelque\nchose par eux-mêmes.", german="Aber letzten Endes müssen die,\ndie den Berg erklimmen, bestimmte Dinge auf\neigene Faust entdecken.", italian="Ma è pur vero che coloro\nche scalano la montagna devono scoprire\ndeterminate cose per conto proprio.", spanish="Pero, al final, los que ascienden\nla montaña deben descubrir ciertas cosas\npor sí mismos."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We are merely assigned to\nassist in those discoveries.", french="Notre rôle consiste juste à vous\naider à faire cette découverte.", german="Wir haben bloß die Weisung,\neuch bei diesen Entdeckungen zu unterstützen.", italian="Noi possiamo solo offrirvi il\nnostro aiuto affinché riusciate a compiere\ntali scoperte.", spanish="Nosotros solo podemos prestar\nnuestra ayuda en tales descubrimientos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Really? I'm not sure I get it, but\nI think there's more to it than just that.", french="Vraiment? Je ne suis pas sûr\nde bien comprendre, mais je parie que votre\nrôle ne se résume pas juste à ça.", german="Wirklich? Ich bin mir nicht\nsicher, ob ich alles mitbekomme. Aber\nvielleicht ist das noch nicht alles.", italian="Davvero? Non sono sicuro di\naver afferrato tutto, eppure ho l'impressione\nche ci sia sotto qualcos'altro.", spanish="¿En serio? No tengo claro si lo\nhe entendido, pero creo que hay más que eso."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Really? I'm not sure I fully\nunderstand, but I think there's a little more to\nit than that.", french="Vraiment? Je ne suis pas sûr\nde bien comprendre, mais je parie que votre\nrôle ne se résume pas juste à ça.", german="Wirklich? Ich weiß nicht, ob ich\nalles verstehe, aber vielleicht ist das noch\nnicht alles.", italian="Davvero? Non sono sicuro di\naver capito fino in fondo, eppure ho\nl'impressione che ci sia dell'altro.", spanish="¿En serio? No sé si lo he\nentendido, pero creo que hay algo más que eso."})
  else
  SkySceneKit.say({english="Really? I'm not sure I fully\nunderstand, but I think there's a little more to\nit than that.", french="Vraiment? Je ne suis pas sûre\nde bien comprendre, mais je parie que votre\nrôle ne se résume pas juste à ça.", german="Wirklich? Ich weiß nicht, ob ich\nalles verstehe, aber vielleicht ist das noch\nnicht alles.", italian="Davvero? Non sono sicura di\naver capito fino in fondo, eppure ho\nl'impressione che ci sia qualcos'altro.", spanish="¿En serio? No tengo claro si lo\nhe entendido del todo, pero creo que\nhay más que eso."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" That's right.", french=" Effectivement.", german=" Stimmt schon.", italian=" Esatto.", spanish=" Así es."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="By the way...[K]\nNow that we've discussed all this...", french="Au fait...[K]\nMaintenant qu'on a parlé de tout ça...", german="Übrigens...[K]\nDa wir das jetzt besprochen haben...", italian="A proposito...[K]\nVisto che ne abbiamo parlato...", spanish="Por cierto...[K] Ahora que ya hemos\nhablado de esto..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="If you're interested, I could be\nyour guide. What do you think?", french="... si ça vous intéresse, je peux\nvous servir de guide. Qu'en pensez-vous?", german="Was haltet ihr davon, wenn\nich als euer Bergführer arbeite?", italian="Se vi interessa, potrei farvi\nda guida... Che ne dite?", spanish="Si os interesa puedo ser\nvuestra guía. ¿Qué os parece?"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="For some reason, while talking\nto you, Team [team:], I've begun to really\nwant to climb the mountain with you.", french="Bizarrement, le fait de parler de\nla montagne avec vous, Equipe [team:],\nça m'a donné envie de la gravir à vos côtés.", german="Irgendwie habe ich während des\nGesprächs Lust bekommen, mit euch zusammen\nden Berg zu besteigen, Team [team:].", italian="Per qualche motivo, parlando\ncon voi, Team [team:], mi è venuta una\ngran voglia di scalare la montagna.", spanish="Por alguna razón, mientras os\nhablaba, [CS:X]Equipo[CR] [team:], me han entrado\nmuchas ganas de subir a la montaña."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Really? That's nice of you\nto offer.", french="Vraiment? C'est une offre\ngénéreuse. Je pensais à la même chose.", german="Wirklich? Wie nett von dir, uns\ndas anzubieten.", italian="Davvero? Beh, sei stata gentile\na offrirti.", spanish=" ¿De verdad? Caray, qué maja."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Really? That's a nice offer.\nI was thinking the same thing.", french="Vraiment? C'est une offre\ngénéreuse. Je pensais à la même chose.", german="Wirklich? Ein nettes Angebot.\nIch habe auch schon daran gedacht.", italian="Davvero? Grazie di esserti\nofferta. È quello a cui stavo pensando\nanch'io.", spanish="¿En serio? Pues es buena\nidea, yo estaba pensando lo mismo."})
  else
  SkySceneKit.say({english="Really? Why, thank you!\nI was thinking that too.", french="Vraiment? C'est une offre\ngénéreuse. Je pensais à la même chose.", german="Wirklich? Hey, vielen Dank!\nIch habe auch schon daran gedacht.", italian="Davvero? Grazie mille!\nAnch'io pensavo che sarebbe stato bello\naverti con noi.", spanish="¿En serio? ¡Anda, pues gracias!\nYo estaba pensando lo mismo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, [hero]?\nWhat do you think? Should we let [CS:N]Shaymin[CR]\njoin us?", french="Hé, [hero]?\nQu'en penses-tu? Es-tu d'accord pour que\n[CS:N]Shaymin[CR] se joigne à nous?", german="Hey, [hero]?\nWas meinst du? Sollen wir [CS:N]Shaymin[CR]\nmit uns gehen lassen?", italian="Ehi, [hero]! Che ne pensi?\n[CS:N]Shaymin[CR] può unirsi a noi?", spanish="Oye, [hero], ¿qué te\nparece? ¿Dejamos que [CS:N]Shaymin[CR]\nforme parte de nuestro equipo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hey, [hero]?\nWhat do you think? Should we let [CS:N]Shaymin[CR]\njoin us?", french="Hé, [hero]?\nQu'en penses-tu? Es-tu d'accord pour que\n[CS:N]Shaymin[CR] se joigne à nous?", german="Hey, [hero]?\nWas meinst du? Sollen wir [CS:N]Shaymin[CR]\nmit uns gehen lassen?", italian="Ehi, [hero]! Che ne pensi?\n[CS:N]Shaymin[CR] può unirsi a noi?", spanish="Oye, [hero], ¿tú qué\nopinas? ¿Dejamos que [CS:N]Shaymin[CR]\nse una a nuestro equipo?"})
  else
  SkySceneKit.say({english="Hey, [hero]?\nWhat do you think? Should we let [CS:N]Shaymin[CR]\njoin us?", french="Hé, [hero]?\nQu'en penses-tu? Es-tu d'accord pour que\n[CS:N]Shaymin[CR] se joigne à nous?", german="Hey, [hero]?\nWas meinst du? Sollen wir [CS:N]Shaymin[CR]\nmit uns gehen lassen?", italian="Ehi, [hero]! Che ne pensi?\n[CS:N]Shaymin[CR] può unirsi a noi?", spanish="Oye, [hero], ¿qué opinas?\n¿Dejamos que [CS:N]Shaymin[CR]\nforme parte de nuestro equipo?"})
  end
  -- @label_2 [étiquette de flux ExplorerScript]
  -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- break_loop [contrôle de boucle forever NDS: une itération compilée]
  else -- default/annulation
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whaat?! Really?!", french=" Quoii?! Sérieusement?!", german=" Waaaas?!? Im Ernst?!?", italian=" Cooosa?! Sul serio?!", spanish=" ¡¿Quéee?! ¡¿En serio?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Whaat?! Really?!", french=" Quoii?! Sérieusement?!", german=" Waaaas?!? Im Ernst?!?", italian=" Cooosa?! Sul serio?!", spanish=" ¡¿Cómo?! ¡¿De verdad?!"})
  else
  SkySceneKit.say({english=" Whaat?! Really?!", french=" Quoii?! Sérieusement?!", german=" Waaaas?!? Im Ernst?!?", italian=" Cooosa?! Sul serio?!", spanish=" ¡¿Cómo?! ¡¿En serio?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Don't you think it would\ndefinitely be better if we had a guide?", french="Tu ne penses pas que la\nprésence d'un guide à nos côtés\nserait un atout précieux?", german="Glaubst du nicht, wir sollten\nlieber einen Bergführer mitnehmen?", italian="Non pensi che sarebbe meglio\navere una guida con noi?", spanish="¿No crees que nos iría mejor\nsi tuviéramos una guía?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Don't you think it would\nbe better if we had a guide?", french="Tu ne penses pas que la\nprésence d'un guide à nos côtés\nserait un atout précieux?", german="Glaubst du nicht, wir sollten\nlieber einen Bergführer mitnehmen?", italian="Non pensi che sarebbe meglio\navere una guida con noi?", spanish="¿No crees que sería mejor\nsi contáramos con una guía?"})
  else
  SkySceneKit.say({english="Don't you think it would\nbe better if we had a guide?", french="Tu ne penses pas que la\nprésence d'un guide à nos côtés\nserait un atout précieux?", german="Glaubst du nicht, wir sollten\nlieber einen Bergführer mitnehmen?", italian="Non pensi che sarebbe meglio\navere una guida con noi?", spanish="¿No te parece que sería mejor\nsi contáramos con una guía?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We should ask [CS:N]Shaymin[CR]\nto guide us, OK?", french="Acceptons l'offre de [CS:N]Shaymin[CR] de\nnous servir de guide, d'accord?", german="Wir sollten das Angebot von\n[CS:N]Shaymin[CR] annehmen. In Ordnung?", italian="Dovremmo proprio accettare\nl'offerta di [CS:N]Shaymin[CR], sai?", spanish="Deberíamos dejar que [CS:N]Shaymin[CR]\nnos guiara, ¿vale?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I really think we should ask\n[CS:N]Shaymin[CR] to guide us. OK?", french="Acceptons l'offre de [CS:N]Shaymin[CR] de\nnous servir de guide, d'accord?", german="Ich denke wirklich, wir sollten\ndas Angebot von [CS:N]Shaymin[CR] annehmen. Okay?", italian="Dovremmo proprio accettare\nl'offerta di [CS:N]Shaymin[CR], sai?", spanish="Creo que deberíamos dejar que\n[CS:N]Shaymin[CR] nos guiara, ¿no?"})
  else
  SkySceneKit.say({english="I really think we should ask\n[CS:N]Shaymin[CR] to guide us. OK?", french="Acceptons l'offre de [CS:N]Shaymin[CR] de\nnous servir de guide, d'accord?", german="Ich denke wirklich, wir sollten\ndas Angebot von [CS:N]Shaymin[CR] annehmen. Okay?", italian="Dovremmo proprio accettare\nl'offerta di [CS:N]Shaymin[CR], sai?", spanish="Creo que deberíamos dejar que\n[CS:N]Shaymin[CR] nos guiara, ¿no crees?"})
  end
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  end
  end
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Hee hee hee. Yay!", french=" Hi hi hi. Youpi!", german=" Hihihi. Juchhu!", italian=" Ih ih ih. Evviva!", spanish=" Ji, ji, ji. ¡Yupi!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="OK, I'll be waiting at the\nmountain-path entrance for you.", french="Très bien, je vous attendrai au\ndébut du sentier de montagne.", german="Gut, ich werde am Eingang des\nGebirgspfades auf euch warten.", italian="Bene, vi aspetto all'inizio\ndel sentiero che conduce alla montagna.", spanish="Bueno, pues os espero donde\nempieza el sendero alpino."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="The mountain path is straight\nahead from here.", french=" C'est juste là, devant vous.", german="Der Gebirgspfad liegt von hier\nschnurstracks geradeaus.", italian="Il sentiero è proprio dritto\ndavanti a voi.", spanish="Encontraréis el sendero alpino\nsi vais todo recto."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Please come once you've finished\nyour preparations.", french="Retrouvez-moi là-bas une fois\nque vous aurez terminé vos préparatifs.", german="Kommt dorthin, wenn ihr mit\nden Vorbereitungen fertig seid.", italian="Quando avete finito\ndi prepararvi, venite pure da me.", spanish="Pasaos por allí cuando hayáis\nterminado de prepararos."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" See you later!", french=" A plus tard!", german=" Bis später!", italian=" A più tardi!", spanish=" ¡Hasta luego!"})
  -- message_Close
  do local p=npc_npc_sheimi.Position; GROUND:MoveToPosition(npc_npc_sheimi, p.X+(0), p.Y+(-88), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeOut(false, 60)
  GROUND:TeleportTo(npc_npc_sheimi, 360, 132, Direction.Down)
  GROUND:EntTurn(npc_npc_sheimi, Direction.Down)
  pcall(function() GROUND:CharSetEmote(npc_npc_kinogassa, nil, 0) end) -- EFFECT_NONE
  local npc_npc_okutan = SkySceneKit.spawn_npc("octillery", 416, 320, Direction.Down, "NPC_OKUTAN")
  pcall(function() GROUND:CharSetEmote(npc_npc_okutan, nil, 0) end) -- EFFECT_NONE
  local npc_npc_bariyaado = SkySceneKit.spawn_npc("mr_mime", 416, 352, Direction.Up, "NPC_BARIYAADO")
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_kinogassa, Direction.Down)
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  GAME:WaitFrames(30)
  GAME:FadeIn(30)
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
