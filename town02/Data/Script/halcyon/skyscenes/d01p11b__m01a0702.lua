-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11B/m01a0702.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V01P03B) [décor sub chargé: Sub_v01p03b]
  -- back_SetGround(LEVEL_D01P11B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 33, 9.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- bgm2_PlayFadeIn(BGM_OCEAN1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  SkySubScreen.Show("v01p03b", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(45)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Really, thank you!", french=" Merci du fond du cœur!", german=" Im Ernst, danke!", italian=" Davvero, ti sono riconoscente!", spanish=" ¡En serio, gracias!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Thank you! Seriously!", french=" Merci du fond du cœur!", german=" Ich bin dir wirklich dankbar!", italian=" Davvero, ti sono riconoscente!", spanish=" ¡De verdad, gracias!"})
  else
  SkySceneKit.say({english=" Thank you very much!", french=" Merci du fond du cœur!", german=" Vielen, vielen Dank!", italian=" Davvero, ti sono riconoscente!", spanish=" ¡Muchísimas gracias!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(............)", french="(............)", german="(............)", italian="(............)", spanish="(...)"})
  else
  SkySceneKit.say({english="(............)", french="(............)", german="(............)", italian="(............)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I only helped because I happened to be\nthere... Was that the right thing to do?)", french="(Je lui ai simplement donné un coup de main\nparce que j'étais là... Ai-je bien agi?)", german="(Ich habe nur geholfen, weil ich zufällig\ngerade da war. Ob das richtig war?)", italian="(Sono intervenuto solo perché mi trovavo lì...\nAvrò fatto la cosa giusta?)", spanish="(Solo he ayudado porque estaba por aquí.\nEspero haber hecho lo correcto.)"})
  else
  SkySceneKit.say({english="(I only helped because I happened to be\nthere... Was that the right thing to do?)", french="(Je lui ai simplement donné un coup de main\nparce que j'étais là... Ai-je bien agi?)", german="(Ich habe nur geholfen, weil ich zufällig\ngerade da war. Ob das richtig war?)", italian="(Sono intervenuta solo perché mi trovavo lì...\nAvrò fatto la cosa giusta?)", spanish="(Solo he ayudado porque estaba por aquí.\nEspero haber hecho lo correcto.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I guess so.[K] This Pokémon is clearly grateful.)", french="(J'imagine que oui.[K] Ce Pokémon m'est très\nreconnaissant.)", german="(Ich glaube schon.[K] Dieses Pokémon ist mir\nwirklich dankbar.)", italian="(Penso di sì.[K] Questo Pokémon mi è\ndavvero riconoscente.)", spanish="(Supongo que sí.[K] Sin duda este Pokémon\nse siente agradecido.)"})
  else
  SkySceneKit.say({english="(I guess so.[K] This Pokémon is clearly grateful.)", french="(J'imagine que oui.[K] Ce Pokémon m'est très\nreconnaissant.)", german="(Ich glaube schon.[K] Dieses Pokémon ist mir\nwirklich dankbar.)", italian="(Penso di sì.[K] Questo Pokémon mi è\ndavvero riconoscente.)", spanish="(Supongo que sí.[K] Sin duda este Pokémon\nse siente agradecido.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's nice to be appreciated.)", french="(C'est bien de se savoir apprécié.)", german="(Es ist schön, von jemandem geschätzt zu\nwerden.)", italian="(È bello sentirsi apprezzati.)", spanish="(Es agradable sentirse apreciado.)"})
  else
  SkySceneKit.say({english="(It's nice to be appreciated.)", french="(C'est bien de se savoir appréciée.)", german="(Es ist schön, von jemandem geschätzt zu\nwerden.)", italian="(È bello sentirsi apprezzati.)", spanish="(Es agradable sentirse apreciada.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(12), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(6410) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(15)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-12), p.Y+(0), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Here's what they stole.", french=" Voilà ce qu'ils avaient volé.", german=" Das haben sie gestohlen.", italian=" Ecco cosa mi avevano rubato.", spanish=" Aquí está lo que me quitaron."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Here's what they stole.", french=" Voilà ce qu'ils avaient volé.", german=" Das haben sie gestohlen.", italian=" Ecco cosa mi avevano rubato.", spanish=" Aquí está lo que me quitaron."})
  else
  SkySceneKit.say({english=" Here's what they stole.", french=" Voilà ce qu'ils avaient volé.", german=" Das haben sie gestohlen.", italian=" Ecco cosa mi avevano rubato.", spanish=" Aquí está lo que me quitaron."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This is a Relic Fragment.[K]\n...Well, at least, that's what I started\ncalling it...", french="C'est un Fragment de Relique.[K]\nEnfin, en tout cas, c'est le nom que je lui\nai donné.", german="Das ist ein Reliktfragment.[K]\n...Na ja, zumindest habe ich angefangen,\nes so zu nennen...", italian="Questo è un Frammento Antico.[K]\nO almeno è come lo chiamo io...", spanish="Esta es una Reliquia de Piedra.[K]\nBueno... Al menos así es como me ha dado por\nllamarla..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This is a Relic Fragment.[K]\n...Well, at least, that's what I started\ncalling it...", french="C'est un Fragment de Relique.[K]\nEnfin, en tout cas, c'est le nom que je lui\nai donné.", german="Das ist ein Reliktfragment.[K]\n...Na ja, zumindest habe ich angefangen,\nes so zu nennen...", italian="Questo è un Frammento Antico.[K]\nO almeno è come lo chiamo io...", spanish="Esta es una Reliquia de Piedra.[K]\nBueno... Al menos así es como la llamo yo..."})
  else
  SkySceneKit.say({english="This is a Relic Fragment.[K]\n...Well, at least, that's what I started\ncalling it...", french="C'est un Fragment de Relique.[K]\nEnfin, en tout cas, c'est le nom que je lui\nai donné.", german="Das ist ein Reliktfragment.[K]\n...Na ja, zumindest habe ich angefangen,\nes so zu nennen...", italian="Questo è un Frammento Antico.[K]\nO almeno è come lo chiamo io...", spanish="Esta es una Reliquia de Piedra.[K]\nBueno... Al menos así es como yo la llamo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But this Relic Fragment...[K]\nIt's my precious treasure.", french="Mais ce Fragment de Relique...[K]\nc'est mon précieux trésor.", german="Aber dieses Reliktfragment...[K]\nEs ist mein wertvollster Schatz.", italian="Ma questo Frammento Antico...[K]\nÈ il mio prezioso tesoro.", spanish="El caso es que esta\nReliquia de Piedra...[K]\nes mi tesoro más preciado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But this Relic Fragment...[K]\nIt's my precious treasure.", french="Mais ce Fragment de Relique...[K]\nc'est mon précieux trésor.", german="Aber dieses Reliktfragment...[K]\nEs ist mein wertvollster Schatz.", italian="Ma questo Frammento Antico...[K]\nÈ il mio prezioso tesoro.", spanish="El caso es que esta\nReliquia de Piedra...[K]\nes mi tesoro más valioso."})
  else
  SkySceneKit.say({english="But this Relic Fragment...[K]\nIt's my precious treasure.", french="Mais ce Fragment de Relique...[K]\nc'est mon précieux trésor.", german="Aber dieses Reliktfragment...[K]\nEs ist mein wertvollster Schatz.", italian="Ma questo Frammento Antico...[K]\nÈ il mio prezioso tesoro.", spanish="El caso es que esta\nReliquia de Piedra...[K] es\nmi tesoro adorado."})
  end
  -- message_KeyWait
  -- GAP: BGM BGM_ON_THE_BEACH_AT_DUSK non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You see, I've always liked\nlegends and lore...", french="Tu sais, j'ai toujours aimé\nles légendes et les mythes...", german="Weißt du, ich mochte schon\nimmer Legenden und Sagen...", italian="Vedi, le leggende e le tradizioni\nmi hanno sempre affascinato...", spanish="Siempre me han gustado\nlas viejas leyendas..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You see, I've always liked\nlegends and lore...", french="Tu sais, j'ai toujours aimé\nles légendes et les mythes...", german="Weißt du, ich mochte schon\nimmer Legenden und Sagen...", italian="Vedi, le leggende e le tradizioni\nmi hanno sempre affascinato...", spanish="Siempre me han gustado\nlas viejas leyendas..."})
  else
  SkySceneKit.say({english="You see, I've always liked\nlegends and lore...", french="Tu sais, j'ai toujours aimé\nles légendes et les mythes...", german="Weißt du, ich mochte schon\nimmer Legenden und Sagen...", italian="Vedi, le leggende e le tradizioni\nmi hanno sempre affascinata...", spanish="Siempre me han gustado\nlas viejas leyendas..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I always get so excited when I\nhear tales from the past!", french="Ce que j'adore par-dessus tout,\nce sont les récits et les contes du passé!", german="Ich finde Geschichten aus der\nVergangenheit so aufregend!", italian="È così emozionante sentire\nracconti del passato!", spanish="¡Me fascinan las historias\ndel pasado!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I always get so excited when I\nhear tales from the past!", french="Ce que j'adore par-dessus tout,\nce sont les récits et les contes du passé!", german="Ich finde Geschichten aus der\nVergangenheit so aufregend!", italian="È così emozionante sentire\nracconti del passato!", spanish="¡Me entusiasma oír historias\ndel pasado!"})
  else
  SkySceneKit.say({english="I always get so excited when I\nhear tales from the past!", french="Ce que j'adore par-dessus tout,\nce sont les récits et les contes du passé!", german="Ich finde Geschichten aus der\nVergangenheit so aufregend!", italian="È così emozionante sentire\nracconti del passato!", spanish="¡Me fascinan las historias\ndel pasado!"})
  end
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Don't you feel the same way?", french=" Toi aussi?", german=" Geht es dir nicht auch so?", italian=" Non ti pare?", spanish=" ¿A ti no?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Don't you feel the same way?", french=" Toi aussi?", german=" Geht es dir nicht auch so?", italian=" Non credi anche tu?", spanish=" ¿A ti no?"})
  else
  SkySceneKit.say({english=" Don't you feel the same way?", french=" Toi aussi?", german=" Geht es dir nicht auch so?", italian=" Non è così anche per te?", spanish=" ¿A ti no?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hidden troves full of treasure\nand strange relics...", french="Des coffres perdus, remplis\nde trésors et d'étranges reliques...", german="Versteckte Schatztruhen und\nseltsame Relikte...", italian="Forzieri nascosti strapieni di\ntesori...", spanish="Tesoros ocultos y extrañas\nreliquias..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hidden troves full of treasure\nand strange relics...", french="Des coffres perdus, remplis\nde trésors et d'étranges reliques...", german="Versteckte Schatztruhen und\nseltsame Relikte...", italian="Forzieri nascosti strapieni di\ntesori...", spanish="Tesoros ocultos y extrañas\nreliquias..."})
  else
  SkySceneKit.say({english="Hidden troves full of treasure\nand strange relics...", french="Des coffres perdus, remplis\nde trésors et d'étranges reliques...", german="Versteckte Schatztruhen und\nseltsame Relikte...", italian="Forzieri nascosti strapieni di\ntesori...", spanish="Tesoros ocultos y extrañas\nreliquias..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="...uncharted territories veiled\nin darkness...", french="... des contrées inconnues\net voilées par l'obscurité...", german="Unerforschte Orte, die von\nDunkelheit umgeben sind...", italian="... territori inesplorati avvolti\nnel mistero...", spanish="Territorios inexplorados\nsumidos en la oscuridad..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="...uncharted territories veiled\nin darkness...", french="... des contrées inconnues\net voilées par l'obscurité...", german="Unerforschte Orte, die von\nDunkelheit umgeben sind...", italian="... territori inesplorati avvolti\nnel mistero...", spanish="Territorios inexplorados\nsumidos en la oscuridad..."})
  else
  SkySceneKit.say({english="...uncharted territories veiled\nin darkness...", french="... des contrées inconnues\net voilées par l'obscurité...", german="Unerforschte Orte, die von\nDunkelheit umgeben sind...", italian="... territori inesplorati avvolti\nnel mistero...", spanish="Territorios inexplorados\nsumidos en la oscuridad..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="...and new lands just waiting to\nbe discovered!", french="... et de nouveaux territoires\nqu'il ne tient qu'à nous de découvrir!", german="Und fremde Länder, die darauf\nwarten, entdeckt zu werden!", italian="... e nuove terre che aspettano\nsolo di essere scoperte!", spanish="¡Y nuevas regiones esperando\na ser descubiertas!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="...and new lands just waiting to\nbe discovered!", french="... et de nouveaux territoires\nqu'il ne tient qu'à nous de découvrir!", german="Und fremde Länder, die darauf\nwarten, entdeckt zu werden!", italian="... e nuove terre che aspettano\nsolo di essere scoperte!", spanish="¡Y nuevas regiones esperando\na ser descubiertas!"})
  else
  SkySceneKit.say({english="...and new lands just waiting to\nbe discovered!", french="... et de nouveaux territoires\nqu'il ne tient qu'à nous de découvrir!", german="Und fremde Länder, die darauf\nwarten, entdeckt zu werden!", italian="... e nuove terre che aspettano\nsolo di essere scoperte!", spanish="¡Y nuevas regiones esperando\na ser descubiertas!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Such places must be full of gold\nand treasure!", french="Ces endroits doivent regorger\nd'or et de trésors!", german="Solche Orte müssen voller Gold\nund Schätze sein!", italian="Luoghi del genere devono essere\ncolmi di oro e tesori!", spanish="¡Esos lugares tienen que estar\nllenos de misterios y riquezas!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Such places must be full of\nunimaginable gold and treasure!", french="Ces endroits doivent regorger\nd'or et de trésors!", german="Solche Orte müssen voller Gold\nund Schätze sein!", italian="Luoghi del genere devono essere\ncolmi di oro e tesori!", spanish="¡Esos lugares tienen que estar\nllenos de misterios y riquezas!"})
  else
  SkySceneKit.say({english="Such places must be full of gold\nand treasure!", french="Ces endroits doivent regorger\nd'or et de trésors!", german="Solche Orte müssen voller Gold\nund Schätze sein!", italian="Luoghi del genere devono essere\ncolmi di oro e tesori!", spanish="¡Esos lugares tienen que estar\nllenos de misterios y riquezas!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And history! Wouldn't it be\namazing to make historic discoveries?", french="Et rentrer dans l'Histoire!\nCe serait fantastique de faire des découvertes\nhistoriques, n'est-ce pas?", german="Und Geschichte! Wäre es nicht\ntoll, geschichtliche Entdeckungen zu machen?", italian="Anche di storia, sai? Non\nsarebbe fantastico fare delle scoperte epocali?", spanish="¡Y luego está el renombre! ¿No\nsería tremendo hacer un descubrimiento\nhistórico?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And history! Wouldn't it be\namazing to make historic discoveries?", french="Et rentrer dans l'Histoire!\nCe serait fantastique de faire des découvertes\nhistoriques, n'est-ce pas?", german="Und Geschichte! Wäre es nicht\ntoll, geschichtliche Entdeckungen zu machen?", italian="Anche di storia, sai? Non\nsarebbe fantastico fare delle scoperte epocali?", spanish="¡Y qué me dices del renombre!\n¡Imagínate lo que sería hacer\nun descubrimiento histórico!"})
  else
  SkySceneKit.say({english="And history! Wouldn't it be\ndramatic to make historic discoveries?", french="Et rentrer dans l'Histoire!\nCe serait fantastique de faire des découvertes\nhistoriques, n'est-ce pas?", german="Und Geschichte! Wäre es nicht\nspannend, geschichtliche Entdeckungen zu\nmachen?", italian="Anche di storia, sai? Non\nsarebbe fantastico fare delle scoperte epocali?", spanish="¡Y la repercusión, claro!\n¿No sería maravilloso hacer descubrimientos\nhistóricos?"})
  end
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I always dream about that. It's\nall exciting to me.", french=" C'est mon plus grand rêve!", german="Ich träume die ganze Zeit davon.\nIch finde das wirklich aufregend.", italian="È il mio sogno. È così\nemozionante.", spanish="Es algo con lo que siempre\nhe soñado. Mi pasión."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's what I always dream of.\nIt's all exciting to me.", french=" C'est mon plus grand rêve!", german="Davon träume ich die ganze Zeit.\nIch finde das wirklich aufregend.", italian="È il mio sogno. È così\nemozionante.", spanish="Es algo con lo que siempre\nhe soñado. ¡Sería tan emocionante...!"})
  else
  SkySceneKit.say({english="That's what I always dream of.\nIt's all so exciting to me.", french=" C'est mon plus grand rêve!", german="Davon träume ich die ganze Zeit.\nIch finde das wirklich aufregend.", italian="È il mio sogno. È così\nemozionante.", spanish="Es algo con lo que siempre\nhe soñado. ¡Sería tan emocionante...!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So one day...[K]I happened to find\nsomething... My Relic Fragment.", french="Et un jour...[K] j'ai fait\nune découverte... mon Fragment de Relique.", german="Und eines Tages[K] fand ich dann\nzufällig dieses Reliktfragment.", italian="Un giorno...[K] ho trovato\nquesto... Il mio Frammento Antico.", spanish="No hace mucho...[K] encontré esta\nReliquia de Piedra."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So one day...[K]I happened to come\nacross my Relic Fragment.", french="Et un jour...[K] j'ai fait\nune découverte... mon Fragment de Relique.", german="Und eines Tages[K] gelangte ich\ndann zufällig an dieses Reliktfragment.", italian="Un giorno...[K] ho trovato\nquesto... Il mio Frammento Antico.", spanish="No hace mucho...[K] encontré esta\nReliquia de Piedra."})
  else
  SkySceneKit.say({english="And it just so happened...[K]that I\nfound this Relic Fragment.", french="Et un jour...[K] j'ai fait\nune découverte... mon Fragment de Relique.", german="Eines Tages passierte es dann...[K]\nIch fand dieses Reliktfragment.", italian="Un giorno...[K] ho trovato\nquesto... Il mio Frammento Antico.", spanish="No hace mucho...[K] encontré esta\nReliquia de Piedra."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Sure, it looks like junk, but take\na closer look...", french="C'est vrai, ça ressemble un peu\nà de la camelote, mais à y regarder de plus\nprès...", german="Klar, auf den ersten Blick sieht\nes wie ein nutzloser Stein aus, aber wenn man\ngenauer hinsieht...", italian="Sulle prime non sembra\nniente di speciale, ma dai un'occhiata più\nda vicino...", spanish="Ya sé que parece un pedrusco,\npero si miras más de cerca..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I admit that it looks like junk,\nbut take a closer look.", french="C'est vrai, ça ressemble un peu\nà de la camelote, mais à y regarder de plus\nprès...", german="Zugegeben, es sieht nicht so\nwertvoll aus. Aber sieh genauer hin.", italian="Sulle prime non sembra\nniente di speciale, ma dai un'occhiata più\nda vicino...", spanish="Ya sé que parece un pedrusco,\npero si miras más de cerca..."})
  else
  SkySceneKit.say({english="Sure, it does look like junk, but\ntake a closer look.", french="C'est vrai, ça ressemble un peu\nà de la camelote, mais à y regarder de plus\nprès...", german="Sicher, es sieht wie ein\nnutzloser Stein aus. Aber sieh genauer hin.", italian="Sulle prime non sembra\nniente di speciale, ma dai un'occhiata più\nda vicino...", spanish="Ya sé que parece un pedrusco,\npero si miras más de cerca..."})
  end
  -- message_Close
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(4), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-4), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetGround(V01P06B) [décor sub chargé: Sub_v01p06b]
  -- camera2_SetPositionMark(Position<'m1', 21, 15>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v01p06b", 15, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="See?[K] See that strange pattern\ninscribed on it?", french="Tu vois?[K] Tu vois ce motif\nétrange gravé dessus?", german="Siehst du?[K] Kannst du das Muster\nsehen?", italian="Vedi?[K] C'è uno strano disegno\ninciso sulla superficie.", spanish="¿Lo ves?[K] ¿Ves ese extraño\ndibujo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="See?[K] That inscription forms a\nstrange pattern, doesn't it?", french="Tu vois?[K] Tu vois ce motif\nétrange gravé dessus?", german="Siehst du?[K] Auf dem Stein ist ein\nmerkwürdiges Muster, nicht wahr?", italian="Vedi?[K] C'è uno strano disegno\ninciso sulla superficie.", spanish="¿Ves esto?[K] ¿Ves el extraño\ndibujo que tiene grabado?"})
  else
  SkySceneKit.say({english="Look there.[K] See that strange\npattern inscribed on it?", french="Tu vois?[K] Tu vois ce motif\nétrange gravé dessus?", german="Sieh mal.[K] Siehst du das\nmerkwürdige Muster auf dem Stein?", italian="Guarda qui.[K] C'è uno strano\ndisegno inciso sulla superficie.", spanish="¿Ves esto?[K] ¿Ves ese extraño\nsímbolo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's true. There is a strange inscription.)", french="(C'est vrai. Il y a un symbole un peu bizarre.)", german="(Stimmt. Da ist ein merkwürdiges Muster.)", italian="(È vero. C'è una strana incisione.)", spanish="(Es cierto. Tiene un extraño símbolo grabado.)"})
  else
  SkySceneKit.say({english="(It's true. There is a strange inscription.)", french="(C'est vrai. Il y a un symbole un peu bizarre.)", german="(Stimmt. Da ist ein merkwürdiges Muster.)", italian="(È vero. C'è una strana incisione.)", spanish="(Es cierto. Tiene un extraño símbolo grabado.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I've never seen a pattern like this.)", french="(Je n'avais encore jamais vu de motif de\nce genre.)", german="(So ein Muster habe ich noch nie gesehen.)", italian="(Non ho mai visto un disegno del genere.)", spanish="(Nunca había visto nada así.)"})
  else
  SkySceneKit.say({english="(I've never seen a pattern like this.)", french="(Je n'avais encore jamais vu de motif de\nce genre.)", german="(So ein Muster habe ich noch nie gesehen.)", italian="(Non ho mai visto un disegno del genere.)", spanish="(Nunca había visto nada así.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This pattern must have some\nmeaning to it. I'm sure of it.", french="Ce motif doit avoir une\nsignification. J'en suis sûr.", german="Dieses Muster muss irgendetwas\nbedeuten. Ganz sicher!", italian="Questo disegno ha sicuramente\nun significato, ne sono strasicuro.", spanish="Ese símbolo debe de tener algún\nsignificado. Estoy convencido de ello."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There must be some significance\nto this pattern.", french="Ce motif doit avoir une\nsignification. J'en suis sûr.", german="Dieses Muster muss eine\nbesondere Bedeutung haben.", italian="Questo disegno deve avere un\nsignificato, ne sono sicuro.", spanish="Ese símbolo debe de tener algún\nsignificado. Estoy convencido de ello."})
  else
  SkySceneKit.say({english="There must be some meaning to\nthis pattern.", french="Ce motif doit avoir une\nsignification. J'en suis sûre.", german="Dieses Muster muss irgendetwas\nbedeuten.", italian="Questo disegno deve avere un\nsignificato, ne sono sicura.", spanish="Ese símbolo debe de tener algún\nsignificado. Estoy convencida de ello."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This Relic Fragment must be the\nkey to legendary places! To areas where\nprecious treasure lies!", french="Ce Fragment de Relique doit être\nune clé menant à des contrées légendaires!\nDes lieux où reposent de merveilleux trésors!", german="Dieses Reliktfragment muss ein\nSchlüssel zu sagenhaften Orten sein! Zu Orten,\nan denen kostbare Schätze liegen!", italian="Il Frammento Antico deve essere\nla chiave per raggiungere luoghi leggendari!\nPosti pieni di tesori preziosissimi!", spanish="¡Esta Reliquia de Piedra tiene\nque ser la llave a lugares legendarios con\nvaliosos tesoros!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This Relic Fragment must be the\nkey to legendary places! To areas where\nprecious treasure lies!", french="Ce Fragment de Relique doit être\nune clé menant à des contrées légendaires!\nDes lieux où reposent de merveilleux trésors!", german="Dieses Reliktfragment muss ein\nSchlüssel zu sagenhaften Orten sein! Zu Orten,\nan denen kostbare Schätze liegen!", italian="Il Frammento Antico deve essere\nla chiave per raggiungere luoghi leggendari!\nPosti pieni di tesori preziosissimi!", spanish="¡Esta Reliquia de Piedra tiene\nque ser la clave para acceder a lugares\nlegendarios con valiosos tesoros!"})
  else
  SkySceneKit.say({english="This Relic Fragment must be the\nkey to legendary places! To areas where\nprecious treasure lies!", french="Ce Fragment de Relique doit être\nune clé menant à des contrées légendaires!\nDes lieux où reposent de merveilleux trésors!", german="Dieses Reliktfragment muss ein\nSchlüssel zu sagenhaften Orten sein! Zu Orten,\nan denen kostbare Schätze liegen!", italian="Il Frammento Antico deve essere\nla chiave per raggiungere luoghi leggendari!\nPosti pieni di tesori preziosissimi!", spanish="¡Esta Reliquia de Piedra sin duda\nes la llave para acceder a lugares legendarios\ncon tesoros de valor incalculable!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" At least that's the feeling I get.", french=" C'est du moins ce que je pense.", german="Das sagt mir jedenfalls mein\nGefühl.", italian=" Me lo sento.", spanish=" Al menos tengo esa sensación."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" At least that's the feeling I get.", french=" C'est du moins ce que je pense.", german="Das sagt mir jedenfalls mein\nGefühl.", italian=" Me lo sento.", spanish=" Al menos tengo esa sensación."})
  else
  SkySceneKit.say({english=" At least that's the feeling I get.", french=" C'est du moins ce que je pense.", german="Das sagt mir jedenfalls mein\nGefühl.", italian=" Me lo sento.", spanish=" Al menos eso es lo que creo."})
  end
  -- message_Close
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetGround(V01P03B) [décor sub chargé: Sub_v01p03b]
  -- camera2_SetPositionMark(Position<'m2', 33, 9.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v01p03b", 15, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's why I want to join an\nexploration team.", french="C'est pour ça que je veux\nrejoindre une équipe d'exploration.", german="Darum will ich einem\nErkundungsteam beitreten.", italian="Per questo voglio unirmi a una\nsquadra d'esplorazione.", spanish="Por eso tengo que unirme\na un equipo explorador."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's why I want to join an\nexploration team.", french="C'est pour ça que je veux\nrejoindre une équipe d'exploration.", german="Darum will ich einem\nErkundungsteam beitreten.", italian="Per questo voglio unirmi a una\nsquadra d'esplorazione.", spanish="Por eso quiero unirme\na un equipo explorador."})
  else
  SkySceneKit.say({english="That's why I want to join an\nexploration team.", french="C'est pour ça que je veux\nrejoindre une équipe d'exploration.", german="Darum will ich einem\nErkundungsteam beitreten.", italian="Per questo voglio unirmi a una\nsquadra d'esplorazione.", spanish="Por eso me gustaría unirme\na un equipo explorador."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This fragment must fit into\nsomething...somewhere! I want to discover\nwhere that is.", french="Il doit être possible d'encastrer\nce fragment dans quelque chose... quelque part!\nEt je veux découvrir où!", german="Dieses Fragment muss irgendwo\nhineinpassen! Wo genau, das will ich\nherausfinden.", italian="Questo frammento deve essere\nla chiave di qualche mistero! Voglio scoprire\nquale.", spanish="¡Este fragmento tiene que\nencajar en alguna parte! Y quiero descubrir\ndónde."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This fragment must fit into\nsomething...somewhere! I want to discover\nwhere that is.", french="Il doit être possible d'encastrer\nce fragment dans quelque chose... quelque part!\nEt je veux découvrir où!", german="Dieses Fragment muss irgendwo\nhineinpassen! Wo genau, das will ich\nherausfinden.", italian="Questo frammento deve essere\nla chiave di qualche mistero! Voglio scoprire\nquale.", spanish="Sé que este fragmento tiene que\nencajar en alguna parte, así que quiero\ndescubrir dónde."})
  else
  SkySceneKit.say({english="This fragment must fit into\nsomething...somewhere! I want to discover\nwhere that is.", french="Il doit être possible d'encastrer\nce fragment dans quelque chose... quelque part!\nEt je veux découvrir où!", german="Dieses Fragment muss irgendwo\nhineinpassen! Wo genau, das will ich\nherausfinden.", italian="Questo frammento deve essere\nla chiave di qualche mistero! Voglio scoprire\nquale.", spanish="¡Estoy convencida de que este\nfragmento ha de encajar en algún sitio!\nY quiero descubrir dónde."})
  end
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I want to solve the mystery of\nmy Relic Fragment!", french="Je veux résoudre le mystère\nde mon Fragment de Relique!", german="Ich will das Rätsel um mein\nReliktfragment lösen!", italian="Voglio risolvere il mistero del\nFrammento Antico!", spanish="¡Quiero resolver el misterio\nde mi Reliquia de Piedra!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I want to solve the mystery of\nmy Relic Fragment!", french="Je veux résoudre le mystère\nde mon Fragment de Relique!", german="Ich will das Rätsel um mein\nReliktfragment lösen!", italian="Voglio risolvere il mistero del\nFrammento Antico!", spanish="¡Tengo que resolver el misterio\nde mi Reliquia de Piedra!"})
  else
  SkySceneKit.say({english="I want to solve the mystery of\nmy Relic Fragment!", french="Je veux résoudre le mystère\nde mon Fragment de Relique!", german="Ich will das Rätsel um mein\nReliktfragment lösen!", italian="Voglio risolvere il mistero del\nFrammento Antico!", spanish="¡Necesito resolver el misterio\nde mi Reliquia de Piedra!"})
  end
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So earlier, I tried joining an\nexploration team as an apprentice...", french="C'est pour ça qu'aujourd'hui, j'ai\nessayé de rejoindre une équipe d'exploration\ncomme apprenti...", german="Daher wollte ich mich schon\nfrüher bei einem Erkundungsteam bewerben.", italian="Quindi, prima ho cercato di\nunirmi a una squadra d'esplorazione come\napprendista...", spanish="Por eso, hace un rato, intenté\nunirme a un equipo explorador como aprendiz..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So earlier, I tried joining an\nexploration team as an apprentice...", french="C'est pour ça qu'aujourd'hui, j'ai\nessayé de rejoindre une équipe d'exploration\ncomme apprenti...", german="Daher wollte ich mich schon\nfrüher bei einem Erkundungsteam bewerben.", italian="Quindi, prima ho cercato di\nunirmi a una squadra d'esplorazione come\napprendista...", spanish="Por eso, hace un rato, traté\nde unirme a un equipo explorador\ncomo aprendiz..."})
  else
  SkySceneKit.say({english="So earlier, I tried joining an\nexploration team as an apprentice...", french="C'est pour ça qu'aujourd'hui, j'ai\nessayé de rejoindre une équipe d'exploration\ncomme apprentie...", german="Daher wollte ich mich schon\nfrüher bei einem Erkundungsteam bewerben.", italian="Quindi, prima ho cercato di\nunirmi a una squadra d'esplorazione come\napprendista...", spanish="Por eso, antes, traté de unirme\na un equipo explorador como aprendiz..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.spin(partner, 4, 1, 3)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But...[K]I chickened out.", french=" Mais...[K] je me suis dégonflé.", german="Aber...[K] Ich habe einen\nRückzieher gemacht.", italian="... ma poi...[K] ho avuto troppa\npaura.", spanish=" Pero...[K] no me atreví."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But...[K]I chickened out.", french=" Mais...[K] je me suis dégonflé.", german="Aber...[K] Ich habe einen\nRückzieher gemacht.", italian="... ma poi...[K] ho avuto troppa\npaura.", spanish=" Pero...[K] no tuve valor."})
  else
  SkySceneKit.say({english=" But...[K]I was too cowardly...", french=" Mais...[K] je me suis dégonflée.", german=" Aber...[K] Ich war zu feige.", italian="... ma poi...[K] ho avuto troppa\npaura.", spanish=" Pero...[K] no me atreví."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What about you, [hero]?\nWhat are you going to do now?", french="Et toi, [hero]? Qu'est-ce\nque tu vas faire maintenant?", german="Was ist mit dir, [hero]?\nWas wirst du jetzt machen?", italian="E tu, [hero]?\nCosa farai adesso?", spanish="¿Y ahora, [hero]?\n¿Qué es lo que vas a hacer?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What about you, [hero]?\nWhat are you going to do now?", french="Et toi, [hero]? Qu'est-ce\nque tu vas faire maintenant?", german="Was ist mit dir, [hero]?\nWas wirst du jetzt machen?", italian="E tu, [hero]?\nCosa farai adesso?", spanish="¿Y ahora qué piensas hacer,\n[hero]?"})
  else
  SkySceneKit.say({english="What about you, [hero]?\nWhat are you going to do now?", french="Et toi, [hero]? Qu'est-ce\nque tu vas faire maintenant?", german="Was ist mit dir, [hero]?\nWas wirst du jetzt machen?", italian="E tu, [hero]?\nCosa farai adesso?", spanish="Oye, [hero]... ¿Ahora\nqué vas a hacer?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You lost your memory. And you\nsomehow transformed into a Pokémon...", french="Tu as perdu la mémoire. Et pour\nune raison que j'ignore, tu es maintenant\nun Pokémon...", german="Du hast dein Gedächtnis\nverloren. Und du hast dich irgendwie in ein\nPokémon verwandelt.", italian="Hai perso la memoria. E adesso\nsei un Pokémon...", spanish="Has perdido la memoria. Y te\nhas convertido en un Pokémon..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You lost your memory. And you\nsomehow transformed into a Pokémon...", french="Tu as perdu la mémoire. Et pour\nune raison que j'ignore, tu es maintenant\nun Pokémon...", german="Du hast dein Gedächtnis\nverloren. Und du hast dich irgendwie in ein\nPokémon verwandelt.", italian="Hai perso la memoria. E adesso\nsei un Pokémon...", spanish="Has perdido la memoria. Y te\nhas convertido en un Pokémon..."})
  else
  SkySceneKit.say({english="You lost your memory. And you\nsomehow transformed into a Pokémon...", french="Tu as perdu la mémoire. Et pour\nune raison que j'ignore, tu es maintenant\nun Pokémon...", german="Du hast dein Gedächtnis\nverloren. Und du hast dich irgendwie in ein\nPokémon verwandelt.", italian="Hai perso la memoria. E adesso\nsei un Pokémon...", spanish="Has perdido la memoria. Y te\nhas convertido en un Pokémon..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Do you have anywhere to go and\nstay after this?", french="As-tu un endroit où aller, où\nrester?", german="Weißt du, wo du jetzt hingehen\nwirst?", italian=" Hai un posto dove andare?", spanish="¿Tienes algún sitio donde pasar\nla noche?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Do you have anywhere to go and\nstay after this?", french="As-tu un endroit où aller, où\nrester?", german="Weißt du, wo du jetzt hingehen\nwirst?", italian=" Hai un posto dove andare?", spanish="¿Tienes algún sitio donde pasar\nla noche?"})
  else
  SkySceneKit.say({english="Do you have anyplace where\nyou can stay?", french="As-tu un endroit où aller, où\nrester?", german="Weißt du, wie es jetzt\nweitergeht?", italian=" Hai un posto dove andare?", spanish="¿Tienes algún sitio donde\nquedarte?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(............)", french="(............)", german="(............)", italian="(............)", spanish="(...)"})
  else
  SkySceneKit.say({english="(............)", french="(............)", german="(............)", italian="(............)", spanish="(...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" If not, can I ask a big favor?", french="Non? Est-ce que je peux\nte demander un énorme service?", german="Falls nicht, kann ich dich dann\num einen großen Gefallen bitten?", italian="In caso contrario, posso\nchiederti un grande favore?", spanish="Si no es así, ¿puedo pedirte\nun gran favor?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" If not, can I ask a big favor?", french="Non? Est-ce que je peux\nte demander un énorme service?", german="Falls nicht, kann ich dich dann\num einen großen Gefallen bitten?", italian="In caso contrario, posso\nchiederti un grande favore?", spanish="Si no, ¿puedo pedirte un gran\nfavor?"})
  else
  SkySceneKit.say({english=" If not, can I ask a big favor?", french="Non? Est-ce que je peux\nte demander un énorme service?", german="Falls nicht, kann ich dich dann\num einen großen Gefallen bitten?", italian="In caso contrario, posso\nchiederti un grande favore?", spanish="Si no es así, ¿puedo pedirte\nun gran favor?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Would you join me to make an\nexploration team?", french="Veux-tu former une équipe\nd'exploration avec moi?", german="Würdest du mit mir ein\nErkundungsteam gründen?", italian="Vuoi formare una squadra\nd'esplorazione insieme a me?", spanish="¿Qué te parece si formamos\njuntos un equipo explorador?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Would you be willing to form an\nexploration team with me?", french="Veux-tu former une équipe\nd'exploration avec moi?", german="Könntest du dir vorstellen, mit\nmir ein Erkundungsteam zu gründen?", italian="Vuoi formare una squadra\nd'esplorazione insieme a me?", spanish="¿Te interesaría formar\nun equipo explorador conmigo?"})
  else
  SkySceneKit.say({english="Would you form an exploration\nteam with me?", french="Veux-tu former une équipe\nd'exploration avec moi?", german="Würdest du mit mir ein\nErkundungsteam gründen?", italian="Vuoi formare una squadra\nd'esplorazione insieme a me?", spanish="¿Quieres formar un equipo\nexplorador conmigo?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I think you and I would make a\ngood exploration team, [hero].", french="Je pense que, toi et moi, nous\nformerions une bonne équipe d'exploration,\n[hero].", german="Ich glaube, du und ich würden\nein gutes Erkundungsteam abgeben,\n[hero].", italian="Io e te saremmo un'ottima\nsquadra d'esplorazione, [hero].", spanish="Creo que los dos haríamos un\nequipo estupendo, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm convinced that I can form an\neffective exploration team with you,\n[hero].", french="Je pense que, toi et moi, nous\nformerions une bonne équipe d'exploration,\n[hero].", german="Ich bin mir sicher, dass wir ein\ngutes Erkundungsteam bilden können,\n[hero].", italian="Io e te saremmo un'ottima\nsquadra d'esplorazione, [hero].", spanish="Estoy convencido de que juntos\nharíamos un equipo estupendo, [hero]."})
  else
  SkySceneKit.say({english="I think we could make a good\nexploration team together, [hero].", french="Je pense que, toi et moi, nous\nformerions une bonne équipe d'exploration,\n[hero].", german="Ich glaube, wir beide wären ein\ngutes Erkundungsteam, [hero].", italian="Io e te saremmo un'ottima\nsquadra d'esplorazione, [hero].", spanish="Creo que formaríamos\nun equipo estupendo, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So, how about it?[K]\nCome on, please?", french="Alors, tu en penses quoi?[K]\nAllez, s'il te plaît?", german="Also, wie wäre es?[K]\nKomm schon, bitte!", italian="Allora, cosa ne dici?[K]\nDai, di' di sì!", spanish="Así que... ¿qué me dices?[K]\n¿Te apuntas?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So will you?[K] Please?", french="Alors, tu en penses quoi?[K]\nAllez, s'il te plaît?", german=" Was sagst du?[K] Bitte!", italian="Allora, cosa ne dici?[K]\nDai, di' di sì!", spanish="Así que... ¿qué me dices?[K]\n¿Lo hacemos?"})
  else
  SkySceneKit.say({english="So will you do that with me?[K]\nPlease?", french="Alors, tu en penses quoi?[K]\nAllez, s'il te plaît?", german=" Also, hast du Lust?[K] Bitte!", italian="Allora, cosa ne dici?[K]\nDai, di' di sì!", spanish="Así que... ¿qué me dices?[K]\n¿Te animas?"})
  end
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Whoa! What should I do?[K] I'm getting\nrecruited out of the blue!)", french="(Ouah! Qu'est-ce que je fais?[K] Je débarque\nà peine, et voilà qu'on veut déjà me recruter!)", german="(Wah! Was soll ich tun?[K] Dieses Angebot\nkommt aus heiterem Himmel!)", italian="(Whoa! E ora che faccio?[K] Questa proposta\nmi coglie impreparato!)", spanish="(¡Vaya! ¿Qué hago?[K] Quiere que me apunte,\n¡así por las buenas!)"})
  else
  SkySceneKit.say({english="(Wah! What should I do?[K] I'm getting\nrecruited out of the blue!)", french="(Ouah! Qu'est-ce que je fais?[K] Je débarque\nà peine, et voilà qu'on veut déjà me recruter!)", german="(Wah! Was soll ich tun?[K] Dieses Angebot\nkommt aus heiterem Himmel!)", italian="(Whoa! E ora che faccio?[K] Questa proposta\nmi coglie impreparata!)", spanish="(¡Vaya! ¿Qué hago?[K] Quiere que me apunte,\n¡así por las buenas!)"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I don't know what an exploration team is...)", french="(Je ne sais même pas ce qu'est une équipe\nd'exploration...)", german="(Ich weiß nicht einmal, was ein\nErkundungsteam ist...)", italian="(Non so neanche cosa sia una squadra\nd'esplorazione...)", spanish="(Ni siquiera sé lo que es un equipo\nexplorador...)"})
  else
  SkySceneKit.say({english="(I don't know what an exploration team is...)", french="(Je ne sais même pas ce qu'est une équipe\nd'exploration...)", german="(Ich weiß nicht einmal, was ein\nErkundungsteam ist...)", italian="(Non so neanche cosa sia una squadra\nd'esplorazione...)", spanish="(Ni siquiera sé lo que es un equipo\nexplorador...)"})
  end
  pcall(function() UI:SetSpeaker(hero) end) -- message_SetActor(ACTOR_PLAYER)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What should I do?[K] Should I join this Pokémon\nand form an exploration team?)", french="(Que faire?[K] Dois-je rejoindre ce Pokémon\net former une équipe d'exploration avec lui?)", german="(Was soll ich tun?[K] Soll ich mit diesem\nPokémon ein Erkundungsteam gründen?)", italian="(Cosa devo fare?[K] Devo unirmi a questo\nPokémon e formare una squadra\nd'esplorazione?)", spanish="(¿Qué hago?[K] ¿Debería formar un equipo\nexplorador con este Pokémon?)"})
  else
  SkySceneKit.say({english="(What should I do?[K] Should I join this Pokémon\nand form an exploration team?)", french="(Que faire?[K] Dois-je rejoindre ce Pokémon\net former une équipe d'exploration avec lui?)", german="(Was soll ich tun?[K] Soll ich mit diesem\nPokémon ein Erkundungsteam bilden?)", italian="(Cosa devo fare?[K] Devo unirmi a questo\nPokémon e formare una squadra\nd'esplorazione?)", spanish="(¿Qué hago?[K] ¿Debería formar un equipo\nexplorador con este Pokémon?)"})
  end
  -- @label_3 [étiquette de flux ExplorerScript]
  -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
  do local __choice = SkySceneKit.ask({{english="Form a team", french="Former une équipe", german="Ein Team bilden", italian="Forma una squadra", spanish="Formar un equipo"}, {english="Say no", french="Refuser", german="Ablehnen", italian="Rifiuta", spanish="Mejor no"}, {english="Are you...?", french="Tu es...?", german="Willst du...", italian="Ti va di...?", spanish="¿Eres...?"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- break_loop [contrôle de boucle forever NDS: une itération compilée]
  elseif __choice == 3 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? [K]Am I what?", french=" Hein? [K]Je suis quoi?", german=" Äh? [K]Was will ich?", italian=" Eh?[K] Mi va di... cosa?", spanish=" ¿Eh?[K] ¿Que si soy qué?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh? [K]Am I what?", french=" Hein? [K]Je suis quoi?", german=" Äh? [K]Was will ich?", italian=" Eh?[K] Mi va di... cosa?", spanish=" ¿Cómo?[K] ¿Que si soy qué?"})
  else
  SkySceneKit.say({english=" Huh? [K]Am I what?", french=" Hein? [K]Je suis quoi?", german=" Äh? [K]Was will ich?", italian=" Eh?[K] Mi va di... cosa?", spanish=" ¿Qué?[K] ¿Que si soy qué?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What do you mean, [K]\\\"Are you...?\\\"", french=" Que veux-tu dire par [K]\\\"Tu es...?\\\"", german="Was meinst du damit, [K]\n[F:S2]Willst du...[F:E2]?", italian=" Che intendi con[K] \\\"Ti va di...\\\"?", spanish="¿Qué quieres decir?[K]\nNo te sigo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What do you mean, [K]\\\"Are you...?\\\"", french=" Que veux-tu dire par [K]\\\"Tu es...?\\\"", german="Was meinst du damit, [K]\n[F:S2]Willst du...[F:E2]?", italian=" Che intendi con[K] \\\"Ti va di...\\\"?", spanish="¿Qué quieres decir?[K]\nAcaba la frase..."})
  else
  SkySceneKit.say({english=" What do you mean, [K]\\\"Are you...?\\\"", french=" Que veux-tu dire par [K]\\\"Tu es...?\\\"", german="Was meinst du damit, [K]\n[F:S2]Willst du...[F:E2]?", italian=" Che intendi con[K] \\\"Ti va di...\\\"?", spanish="¿Qué quieres decir?[K]\nNo has acabado la frase..."})
  end
  do local __choice = SkySceneKit.ask({{english="You're trying to talk me into it?", french="Tu essaies de me convaincre?", german="Willst du mich überreden?", italian="Stai cercando di convincermi?", spanish="¿Estás intentando convencerme?"}}) -- message_SwitchMenu(0, 1) ROM
  if true then -- default
  end
  end
  -- @label_4 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?! [K]Talk you into it?!", french=" Quoi?! [K]Te convaincre?!", german=" Was?!? [K]Dich überreden?!?", italian=" Come?![K] Convincerti?!", spanish=" ¡¿Quéee?![K] ¡¿Convencerte, yo?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?! [K]Talk you into it?!", french=" Quoi?! [K]Te convaincre?!", german=" Was?!? [K]Dich überreden?!?", italian=" Come?![K] Convincerti?!", spanish="¡¿Cómo?![K] ¡¿Que si\nintento convencerte?!"})
  else
  SkySceneKit.say({english=" What?! [K]Talk you into it?!", french=" Quoi?! [K]Te convaincre?!", german=" Was?!? [K]Dich überreden?!?", italian=" Come?![K] Convincerti?!", spanish="¡¿Cómo?![K] ¡¿Intentar\nconvencerte, yo?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I wasn't trying to do anything!", french=" Loin de moi cette idée!", german=" Ich habe gar nichts versucht!", italian=" Non cercavo di fare niente!", spanish=" ¡Soy inocente como un bebé!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I didn't even think of it!", french=" Loin de moi cette idée!", german=" Das hatte ich nicht vor!", italian=" Non ci ho nemmeno pensato!", spanish="¡Ni se me ha pasado por la\ncabeza, de verdad!"})
  else
  SkySceneKit.say({english="The thought never crossed\nmy mind!", french=" Loin de moi cette idée!", german=" Der Gedanke kam mir gar nicht!", italian="Non mi è nemmeno passato per\nla mente!", spanish="¡Ni se me había ocurrido,\nen serio!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Well, I'm a complete coward...[K]\nHonestly...", french="En fait, je suis vraiment lâche\ncomme tout...[K]\nHonnêtement...", german="Nun, ich bin ein echter\nFeigling...[K] Ehrlich...", italian="Beh, ad essere onesti...[K]\nIo sono un vero fifone...", spanish="Soy de lo más cobardica...[K]\nEn serio..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well, I'm a complete coward...[K]\nHonestly...", french="En fait, je suis vraiment lâche\ncomme tout...[K]\nHonnêtement...", german="Nun, ich bin ein echter\nFeigling...[K] Ehrlich...", italian="Beh, ad essere onesti...[K]\nIo sono un vero fifone...", spanish="Soy de lo más cobardica...[K]\nEn serio..."})
  else
  SkySceneKit.say({english="Well, I'm a complete coward...[K]\nHonestly...", french="En fait, je suis vraiment lâche\ncomme tout...[K]\nHonnêtement...", german="Nun, ich bin ein echter\nFeigling...[K] Ehrlich...", italian="Beh, parlando onestamente...[K]\nIo sono una vera fifona...", spanish="Soy de lo más cobardica...[K]\nEn serio..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I mean, yes, I thought I could\ndepend on you, [hero]...", french="Je veux dire... Oui, je pensais\npouvoir compter sur toi, [hero]...", german="Ich meine, ja, ich dachte, ich sei\nauf dich angewiesen, [hero]...", italian="Sì, insomma, pensavo di\ndipendere completamente da te, [hero]...", spanish="Me refiero a que pensaba que\npodía contar contigo, [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I mean, yes, I thought I could\ndepend on you, [hero]...", french="Je veux dire... Oui, je pensais\npouvoir compter sur toi, [hero]...", german="Ich meine, ja, ich dachte, ich sei\nauf dich angewiesen, [hero]...", italian="Sì, insomma, pensavo di\ndipendere completamente da te, [hero]...", spanish="Me refiero a que pensaba que\npodía contar contigo, [hero]..."})
  else
  SkySceneKit.say({english="I mean, yes, I thought I could\ndepend on you, [hero]...", french="Je veux dire... Oui, je pensais\npouvoir compter sur toi, [hero]...", german="Ich meine, ja, ich dachte, ich sei\nauf dich angewiesen, [hero]...", italian="Sì, insomma, pensavo di\ndipendere completamente da te, [hero]...", spanish="Me refiero a que pensaba que\npodía contar contigo, [hero]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But during that fight with\n[CS:N]Koffing[CR] earlier...", french="Mais pendant ce combat contre\n[CS:N]Smogo[CR] tout à l'heure...", german="Aber während des Kampfes mit\n[CS:N]Smogon[CR] vorhin...", italian="Ma prima, durante la lotta con\n[CS:N]Koffing[CR]...", spanish="Pero durante ese combate con\n[CS:N]Koffing[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But during that fight with\n[CS:N]Koffing[CR] earlier...", french="Mais pendant ce combat contre\n[CS:N]Smogo[CR] tout à l'heure...", german="Aber während des Kampfes mit\n[CS:N]Smogon[CR] vorhin...", italian="Ma prima, durante la lotta con\n[CS:N]Koffing[CR]...", spanish="Pero durante ese combate con\n[CS:N]Koffing[CR]..."})
  else
  SkySceneKit.say({english="But during that fight with\n[CS:N]Koffing[CR] earlier...", french="Mais pendant ce combat contre\n[CS:N]Smogo[CR] tout à l'heure...", german="Aber während des Kampfes mit\n[CS:N]Smogon[CR] vorhin...", italian="Ma prima, durante la lotta con\n[CS:N]Koffing[CR]...", spanish="Pero durante ese combate con\n[CS:N]Koffing[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Having you there with me, I felt\nreally brave.", french="... avec toi à mes côtés, je me\nsuis vraiment senti courageux.", german="Da hat es mich sehr ermutigt,\ndich dabeizuhaben.", italian="Il fatto di averti al mio fianco\nmi dava un gran coraggio.", spanish="Al tenerte a mi lado me sentí\nmuy valiente."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Having you there with me, I felt\nreally brave.", french="... avec toi à mes côtés, je me\nsuis vraiment senti courageux.", german="Da hat es mich sehr ermutigt,\ndich dabeizuhaben.", italian="Il fatto di averti al mio fianco\nmi dava un gran coraggio.", spanish="Al tenerte a mi lado me sentí\nmuy valiente."})
  else
  SkySceneKit.say({english="Having you there with me, I felt\nreally brave.", french="... avec toi à mes côtés, je me\nsuis vraiment sentie courageuse.", german="Da hat es mich sehr ermutigt,\ndich dabeizuhaben.", italian="Il fatto di averti al mio fianco\nmi dava un gran coraggio.", spanish="Al tenerte a mi lado me sentí\nmuy valiente."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I think I could do anything as\nlong as you're helping me, [hero].", french="Je crois que je pourrais\naccomplir des miracles\navec ton aide, [hero].", german="Ich traue mir alles zu, solange\ndu nur bei mir bist, [hero].", italian="Penso che potrei fare qualsiasi\ncosa se tu mi aiutassi, [hero].", spanish="Creo que soy capaz de todo\nmientras cuente con tu ayuda, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I think I could do anything as\nlong as you're helping me, [hero].", french="Je crois que je pourrais\naccomplir des miracles\navec ton aide, [hero].", german="Ich traue mir alles zu, solange\ndu nur bei mir bist, [hero].", italian="Penso che potrei fare qualsiasi\ncosa se tu mi aiutassi, [hero].", spanish="Creo que soy capaz de todo\nmientras cuente con tu ayuda, [hero]."})
  else
  SkySceneKit.say({english="I think I could do anything as\nlong as you're helping me, [hero].", french="Je crois que je pourrais\naccomplir des miracles\navec ton aide, [hero].", german="Ich traue mir alles zu, solange\ndu nur bei mir bist, [hero].", italian="Penso che potrei fare qualsiasi\ncosa se tu mi aiutassi, [hero].", spanish="Creo que soy capaz de todo\nmientras cuente con tu ayuda, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So come on, I'm begging you.[K]\nLet's form an exploration team, you and me.", french="Allez, je t'en prie.[K] Formons\nune équipe d'exploration, toi et moi. D'accord?", german="Also, komm schon! Ich flehe dich\nan.[K] Lass uns ein Erkundungsteam bilden.\nDu und ich.", italian="Quindi, ti prego![K]\nFormiamo una squadra d'esplorazione.", spanish="Por eso te pido que te animes.[K]\nFormemos un equipo explorador tú y yo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So come on, I'm begging you.[K]\nLet's form an exploration team, you and me.", french="Allez, je t'en prie.[K] Formons\nune équipe d'exploration, toi et moi. D'accord?", german="Also, komm schon! Ich flehe dich\nan.[K] Lass uns ein Erkundungsteam bilden.\nDu und ich.", italian="Quindi, ti prego![K]\nFormiamo una squadra d'esplorazione.", spanish="Por eso te pido que te animes.[K]\nFormemos un equipo explorador tú y yo."})
  else
  SkySceneKit.say({english="So come on, I'm begging you.[K]\nLet's form an exploration team, you and me.", french="Allez, je t'en prie.[K] Formons\nune équipe d'exploration, toi et moi. D'accord?", german="Also, komm schon! Ich flehe dich\nan.[K] Lass uns ein Erkundungsteam bilden.\nDu und ich.", italian="Quindi, ti prego![K]\nFormiamo una squadra d'esplorazione.", spanish="Por eso te pido que te animes.[K]\nFormemos un equipo explorador tú y yo."})
  end
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? Oh, come on!", french=" Quoi?! Allez, s'il te plaît!", german=" Häh? Ach, komm schon!", italian=" Eh? Oh, dai!", spanish=" ¿Qué? ¡Vamos, anímate!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?! Oh, but...", french=" Quoi?! Allez, s'il te plaît!", german=" Was?!? Oh, aber...", italian=" Cosa?! Ma...", spanish=" ¡¿Qué?! Pero si..."})
  else
  SkySceneKit.say({english=" What?! Oh, please!", french=" Quoi?! Allez, s'il te plaît!", german=" Was?!? Ach, bitte!", italian=" Cosa?! Oh, ti prego!", spanish=" ¡¿Qué?! ¡Di que sí, por favor!"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But I'm braver when I'm with\nyou, [hero]...", french="Je suis beaucoup plus courageux\nquand je suis avec toi, [hero]...", german="Aber ich habe weniger Angst,\nwenn du bei mir bist, [hero]...", italian="Quando sono insieme a te\ndivento più coraggioso, [hero]...", spanish="Soy muchísimo más valiente\ncuando estoy contigo, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But I'm braver when I'm with\nyou, [hero]...", french="Je suis beaucoup plus courageux\nquand je suis avec toi, [hero]...", german="Aber ich habe weniger Angst,\nwenn du bei mir bist, [hero]...", italian="Quando sono insieme a te\ndivento più coraggioso, [hero]...", spanish="Soy más valiente cuando\nme acompañas, [hero]."})
  else
  SkySceneKit.say({english="But I'm braver when I'm with\nyou, [hero]...", french="Je suis beaucoup plus\ncourageuse quand je suis avec toi,\n[hero]...", german="Aber ich habe weniger Angst,\nwenn du bei mir bist, [hero]...", italian="Quando sono insieme a te\ndivento più coraggiosa, [hero]...", spanish="Soy mucho más valiente\ncuando me acompañas, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And you were awesome when we\nbeat [CS:N]Koffing[CR] and his buddy.", french="Et tout à l'heure, tu as été\ngrandiose quand on a vaincu [CS:N]Smogo[CR] et\nson acolyte.", german="Und du warst großartig, als wir\n[CS:N]Smogon[CR] und seinen Freund geschlagen haben!", italian="Hai dato proprio una bella\nlezione a [CS:N]Koffing[CR] e al suo compare.", spanish="Y fue tremendo cómo\npusimos en su sitio a [CS:N]Koffing[CR] y a su compinche."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You were so fantastic when\nwe confronted [CS:N]Koffing[CR] and his sidekick.", french="Et tout à l'heure, tu as été\ngrandiose quand on a vaincu [CS:N]Smogo[CR] et\nson acolyte.", german="Und du warst echt fantastisch,\nals wir gegen [CS:N]Smogon[CR] und sein Anhängsel\ngekämpft haben.", italian="Hai dato proprio una bella\nlezione a [CS:N]Koffing[CR] e al suo compare.", spanish="¡Y estuviste genial cuando les\nplantamos cara a [CS:N]Koffing[CR] y a su compinche!"})
  else
  SkySceneKit.say({english="And you were fantastic when\nwe faced [CS:N]Koffing[CR] and his sidekick.", french="Et tout à l'heure, tu as été\ngrandiose quand on a vaincu [CS:N]Smogo[CR] et\nson acolyte.", german="Und du warst fantastisch, als\nwir gegen [CS:N]Smogon[CR] und sein Anhängsel\ngekämpft haben.", italian="Hai dato proprio una bella\nlezione a [CS:N]Koffing[CR] e al suo compare.", spanish="¡Y estuviste genial cuando les\nplantamos cara a [CS:N]Koffing[CR] y a su compinche!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="When I saw that, I realized\nyou're no ordinary Pokémon, [hero]!", french="En voyant ça, j'ai compris\nque tu n'étais pas un Pokémon ordinaire,\n[hero]!", german="Da war mir klar, dass du kein\ngewöhnliches Pokémon bist, [hero]!", italian="Quando ho visto cosa sei in\ngrado di fare, ho capito che non sei un\nPokémon qualunque, [hero]!", spanish="¡Al verlo, supe que no eras\nun Pokémon cualquiera, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="When I saw that, I realized\nyou're no ordinary Pokémon, [hero]!", french="En voyant ça, j'ai compris\nque tu n'étais pas un Pokémon ordinaire,\n[hero]!", german="Da war mir klar, dass du kein\ngewöhnliches Pokémon bist, [hero]!", italian="Quando ho visto cosa sei in\ngrado di fare, ho capito che non sei un\nPokémon qualunque, [hero]!", spanish="¡Al verlo, supe que no eras\nun Pokémon corriente, [hero]!"})
  else
  SkySceneKit.say({english="When I saw that, I realized\nyou're no ordinary Pokémon, [hero]!", french="En voyant ça, j'ai compris\nque tu n'étais pas un Pokémon ordinaire,\n[hero]!", german="Da war mir klar, dass du kein\ngewöhnliches Pokémon bist, [hero]!", italian="Quando ho visto cosa sei in\ngrado di fare, ho capito che non sei un\nPokémon qualunque, [hero]!", spanish="¡Al verlo, supe que no eras\nun Pokémon como los demás, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I thought that you'd make a\nfirst-class explorer, [hero].", french="Je me suis dit que tu pourrais\nfaire partie des plus grands explorateurs,\n[hero].", german="Und ich dachte mir, dass du ein\nerstklassiger Erkunder wärst, [hero].", italian="Ho subito pensato che hai\nl'esplorazione nel sangue, [hero].", spanish="Entonces supe que explorar se\nte daría como a nadie, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I became convinced that you'd\nmake a first-class explorer, [hero].", french="Je me suis dit que tu pourrais\nfaire partie des plus grands explorateurs,\n[hero].", german="Ich bin überzeugt, dass du ein\nerstklassiger Erkunder wärst, [hero].", italian="Ho subito pensato che hai\nl'esplorazione nel sangue, [hero].", spanish="Entonces supe que explorar se\nte daría como a nadie, [hero]."})
  else
  SkySceneKit.say({english="I thought that you could be a\nfirst-class explorer, [hero].", french="Je me suis dit que tu pourrais\nfaire partie des plus grands explorateurs,\n[hero].", german="Und ich dachte mir, dass du ein\nerstklassiger Erkunder wärst, [hero].", italian="Ho subito pensato che hai\nl'esplorazione nel sangue, [hero].", spanish="Entonces supe que explorar se\nte daría como a nadie, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So come on, I'm begging you.[K]\nLet's form an exploration team, you and me.", french="Allez, je t'en prie.[K] Formons\nune équipe d'exploration, toi et moi. D'accord?", german="Also, komm schon! Ich flehe dich\nan.[K] Lass uns ein Erkundungsteam bilden.\nDu und ich.", italian="Quindi, ti prego![K]\nFormiamo una squadra d'esplorazione.", spanish="Por eso te pido que te animes.[K]\nFormemos un equipo explorador tú y yo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So come on now.[K] Let's form an\nexploration team together.", french="Allez, je t'en prie.[K] Formons\nune équipe d'exploration, toi et moi. D'accord?", german="Also, komm schon.[K] Lass uns\nzusammen ein Erkundungsteam bilden.", italian="Quindi, ti prego![K]\nFormiamo una squadra d'esplorazione.", spanish="Así que por eso te lo ruego...[K]\nFormemos un equipo explorador tú y yo."})
  else
  SkySceneKit.say({english="So, please?[K] Will you please form\nan exploration team with me?", french="Allez, je t'en prie.[K] Formons\nune équipe d'exploration, toi et moi. D'accord?", german="Also, was sagst du?[K] Willst du\nnicht mit mir ein Erkundungsteam bilden?", italian="Quindi, ti prego![K]\nFormiamo una squadra d'esplorazione.", spanish="Por eso te lo pido por favor...[K]\nFormemos un equipo explorador tú y yo."})
  end
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  end
  end
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's true, I do have nowhere to go...)", french="(C'est vrai, je n'ai nulle part où aller...)", german="(Es stimmt, ich habe wirklich keine Ahnung,\nwohin ich gehen sollte...)", italian="(Devo ammettere che non so dove andare...)", spanish="(Lo cierto es que no tengo dónde ir...)"})
  else
  SkySceneKit.say({english="(It's true, I do have nowhere to go...)", french="(C'est vrai, je n'ai nulle part où aller...)", german="(Es stimmt, ich habe wirklich keine Ahnung,\nwohin ich gehen sollte...)", italian="(Devo ammettere che non so dove andare...)", spanish="(Lo cierto es que no tengo dónde ir...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I don't have any clue what I should do next.)", french="(Je ne sais vraiment pas quoi faire.)", german="(Ich weiß nicht, wie es weitergehen soll.)", italian="(... e non ho proprio idea di cosa fare adesso.)", spanish="(No tengo ni idea de lo que puedo hacer ahora.)"})
  else
  SkySceneKit.say({english="(I don't have any clue what I should do next.)", french="(Je ne sais vraiment pas quoi faire.)", german="(Ich weiß nicht, wie es weitergehen soll.)", italian="(... e non ho proprio idea di cosa fare adesso.)", spanish="(No tengo ni idea de lo que puedo hacer ahora.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I guess it wouldn't hurt to team up with\n[partner] for now.)", french="(Il n'y a aucun mal à former une équipe\navec [partner] pour le moment, je pense.)", german="(Es kann wohl nicht schaden, wenn ich mich\nfürs Erste mit [partner] zusammentue.)", italian="(Immagino che non avrei niente da perdere\nse mi unissi a [partner] per un po'.)", spanish="(Supongo que no tendrá nada de malo que\nme asocie con [partner] por el momento.)"})
  else
  SkySceneKit.say({english="(I guess it wouldn't hurt to team up with\n[partner] for now.)", french="(Il n'y a aucun mal à former une équipe\navec [partner] pour le moment, je pense.)", german="(Es kann wohl nicht schaden, wenn ich mich\nfürs Erste mit [partner] zusammentue.)", italian="(Immagino che non avrei niente da perdere\nse mi unissi a [partner] per un po'.)", spanish="(Supongo que no pasará nada si de momento\nme uno a [partner].)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Maybe I'll eventually discover who or what\nI am by hanging out with this Pokémon.)", french="(Peut-être qu'en restant avec ce Pokémon,\nje finirai par découvrir qui je suis ou\nce que je suis.)", german="(Vielleicht erfahre ich irgendwann, wer oder\nwas ich bin, wenn ich bei diesem Pokémon\nbleibe.)", italian="(Forse potrei riuscire a scoprire chi sono\nse rimango un po' con questo Pokémon.)", spanish="(Tal vez si sigo con este Pokémon\nacabe descubriendo quién soy.)"})
  else
  SkySceneKit.say({english="(Maybe I'll eventually discover who or what\nI am by hanging out with this Pokémon.)", french="(Peut-être qu'en restant avec ce Pokémon,\nje finirai par découvrir qui je suis ou\nce que je suis.)", german="(Vielleicht erfahre ich irgendwann, wer oder\nwas ich bin, wenn ich bei diesem Pokémon\nbleibe.)", italian="(Forse potrei riuscire a scoprire chi sono\nse rimango un po' con questo Pokémon.)", spanish="(Tal vez si sigo con este Pokémon\nacabe descubriendo quién soy.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(OK! That's settled!)", french="(D'accord! C'est décidé!)", german="(Okay! Abgemacht!)", italian="(Ok! È deciso!)", spanish="(¡De acuerdo! Está decidido.)"})
  else
  SkySceneKit.say({english="(OK! That's settled!)", french="(D'accord! C'est décidé!)", german="(Okay! Abgemacht!)", italian="(Ok! È deciso!)", spanish="(¡De acuerdo! Está decidido.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yeah?[K] Really?!", french=" Oui?[K] Vraiment?!", german=" Ja?[K] Wirklich?!?", italian=" Sì?[K] Davvero?!", spanish=" ¿Sí?[K] ¡¿En serio?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes?[K] Really?!", french=" Oui?[K] Vraiment?!", german=" Ja?[K] Wirklich?!?", italian=" Sì?[K] Davvero?!", spanish=" ¿Sí?[K] ¡¿De verdad?!"})
  else
  SkySceneKit.say({english=" Oh?[K] Really?!", french=" Oui?[K] Vraiment?!", german=" Oh![K] Wirklich?!?", italian=" Sì?[K] Davvero?!", spanish=" ¡Oh![K] ¡¿En serio?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You'll form an exploration team\nwith me?", french="Tu veux bien former une équipe\nd'exploration avec moi?", german="Du willst mit mir ein\nErkundungsteam gründen?", italian="Formerai una squadra\nd'esplorazione con me?", spanish="¿Vas a formar un equipo\nexplorador conmigo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You'll form an exploration team\nwith me?", french="Tu veux bien former une équipe\nd'exploration avec moi?", german="Du willst mit mir ein\nErkundungsteam gründen?", italian="Formerai una squadra\nd'esplorazione con me?", spanish="¿Quieres formar un equipo\nexplorador conmigo?"})
  else
  SkySceneKit.say({english="You'll really form an exploration\nteam with me?", french="Tu veux bien former une équipe\nd'exploration avec moi?", german="Du willst wirklich mit mir ein\nErkundungsteam gründen?", italian="Formerai davvero una squadra\nd'esplorazione con me?", spanish="¿Entonces vas a formar\nun equipo explorador conmigo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yahoo! Thanks!", french=" Oui! Merci!", german=" Juchhu! Danke!", italian=" Yuu-huu! Grazie!", spanish=" ¡Bien! ¡Gracias!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes! Thank you!", french=" Oui! Merci!", german=" Ja! Vielen Dank!", italian=" Sì! Grazie!", spanish=" ¡Genial! ¡Gracias!"})
  else
  SkySceneKit.say({english=" Yay! Thank you!", french=" Oui! Merci!", german=" Hurra! Vielen Dank!", italian=" Sì! Grazie!", spanish=" ¡Estupendo! ¡Gracias!"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We're going to make a great\ncombination! Let's make this work!", french="On va former une super équipe!\nTu vas voir!", german="Wir werden ein großartiges Duo\nabgeben! Du wirst sehen, wir schaffen das!", italian="Saremo una coppia perfetta!\nAndrà tutto bene!", spanish="¡Vamos a ser un gran equipo!\n¡Ya verás cómo nos entendemos tú y yo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We're going to be a great\ncombination! Let's make this work!", french="On va former une super équipe!\nTu vas voir!", german="Wir werden ein großartiges Duo\nabgeben! Du wirst sehen, wir schaffen das!", italian="Saremo una coppia perfetta!\nAndrà tutto bene!", spanish="¡Sin duda seremos un gran\nequipo! ¡Ya verás cómo nos entendemos!"})
  else
  SkySceneKit.say({english="We're going to be a great\ncombination! Let's make this work!", french="On va former une super équipe!\nTu vas voir!", german="Wir werden ein großartiges Duo\nabgeben! Du wirst sehen, wir schaffen das!", italian="Saremo una coppia perfetta!\nAndrà tutto bene!", spanish="¡Vamos a ser un gran equipo!\n¡Nos vamos a complementar muy bien!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="First, let's go to [CS:N]Wigglytuff[CR]'s\nplace and sign up as apprentices.", french="D'abord, nous devons aller\nà la Guilde de [CS:N]Grodoudou[CR] et nous inscrire\ncomme apprentis.", german="Lass uns als Erstes zu\n[CS:N]Knuddeluff[CR] gehen und uns bei ihm als Lehrlinge\nanmelden.", italian="Come prima cosa, andiamo da\n[CS:N]Wigglytuff[CR] e iscriviamoci come apprendisti.", spanish="Lo primero, entonces, es ir a\nver a [CS:N]Wigglytuff[CR] y apuntarnos como\naprendices."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="First, we should go to\n[CS:N]Wigglytuff[CR]'s place and sign up as apprentices.", french="D'abord, nous devons aller\nà la Guilde de [CS:N]Grodoudou[CR] et nous inscrire\ncomme apprentis.", german="Lass uns als Erstes zu\n[CS:N]Knuddeluff[CR] gehen und uns bei ihm als Lehrlinge\nanmelden.", italian="Come prima cosa, andiamo da\n[CS:N]Wigglytuff[CR] e iscriviamoci come apprendisti.", spanish="Lo primero, entonces, es ir a\nver a [CS:N]Wigglytuff[CR] y apuntarnos como\naprendices."})
  else
  SkySceneKit.say({english="First, we need to go to\n[CS:N]Wigglytuff[CR]'s place and sign up as apprentices.", french="D'abord, nous devons aller\nà la Guilde de [CS:N]Grodoudou[CR] et nous inscrire\npour faire partie des apprentis.", german="Als Erstes müssen wir zu\n[CS:N]Knuddeluff[CR] und uns als Lehrlinge anmelden.", italian="Come prima cosa, andiamo da\n[CS:N]Wigglytuff[CR] e iscriviamoci come\nPokémon apprendisti.", spanish="Lo primero, entonces, es ir a\nver a [CS:N]Wigglytuff[CR] y apuntarnos como\naprendices."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's where we can train to\nbecome a proper exploration team.", french="C'est là qu'on peut s'entraîner\npour devenir une équipe d'exploration\ndigne de ce nom.", german="Dort können wir trainieren, um\nein richtiges Erkundungsteam zu werden.", italian="Lì potremo allenarci per\ndiventare una vera e propria squadra\nd'esplorazione.", spanish="En su [CS:N]Pokégremio[CR] podremos\nentrenarnos para convertirnos en un\nauténtico equipo explorador."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's where we need to train to\nbecome a first-rate exploration team.", french="C'est là qu'on peut s'entraîner\npour devenir une équipe d'exploration\ndigne de ce nom.", german="Dort müssen wir trainieren, um\nein erstklassiges Erkundungsteam zu werden.", italian="Lì potremo allenarci per\ndiventare una vera e propria squadra\nd'esplorazione.", spanish="En su [CS:N]Pokégremio[CR] podremos\nentrenarnos para convertirnos en un\nauténtico equipo explorador."})
  else
  SkySceneKit.say({english="That's where we can get the\ntraining to become a proper exploration team.", french="C'est là qu'on peut s'entraîner\npour devenir une équipe d'exploration\ndigne de ce nom.", german="Dort bekommen wir das nötige\nTraining, um ein richtiges Erkundungsteam zu\nwerden.", italian="Lì potremo allenarci per\ndiventare una vera e propria squadra\nd'esplorazione.", spanish="En su [CS:N]Pokégremio[CR] nos formarán\nadecuadamente para convertirnos\nen un auténtico equipo explorador."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I think the training will be\nreally tough...", french="A mon avis, l'entraînement sera\ntrès dur...", german="Ich glaube, das Training wird\nrichtig hart...", italian="Penso che l'addestramento sarà\nmolto duro...", spanish="Creo que el entrenamiento será\nrealmente duro..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm sure the training will be\nvery tough...", french="A mon avis, l'entraînement sera\ntrès dur...", german="Das Training wird mit Sicherheit\nsehr hart...", italian="Penso che l'addestramento sarà\nmolto duro...", spanish="Sin duda el entrenamiento será\nbastante duro..."})
  else
  SkySceneKit.say({english="I think the training will be very\ntough...", french="A mon avis, l'entraînement sera\ntrès dur...", german="Ich glaube, das Training wird\nsehr hart...", italian="Penso che l'addestramento sarà\nmolto duro...", spanish="Creo que el entrenamiento será\nmuy duro..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But let's give it our best,\n[hero]!", french="Il faudra que nous fassions\nde notre mieux, [hero]!", german="Aber lass uns unser Bestes\ngeben, [hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish="¡Pero nos vamos a esforzar,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But let's give it our best,\n[hero]!", french="Il faudra que nous fassions\nde notre mieux, [hero]!", german="Aber lass uns unser Bestes\ngeben, [hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish="¡Pero tendremos que\nesforzarnos, [hero]!"})
  else
  SkySceneKit.say({english="So let's give it our best,\n[hero]!", french="Il faudra que nous fassions\nde notre mieux, [hero]!", german="Aber lass uns unser Bestes\ngeben, [hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish="¡Así que vamos a esforzarnos,\n[hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- SetAnimation(66) [anim idle native]
  -- SetAnimation(66) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(80)
  pcall(function() SOUND:FadeOutBGM(180) end)
  SkySubScreen.Hide(90) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 90)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:WaitFrames(100)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]And so...", french="[CN]C'est ainsi...", german="[CN]Und so kam es,", italian="[CN]E così...", spanish="[CN]Y así..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN][partner] and [hero]...", french="[CN]... que [partner] et [hero]...", german="[CN]dass [partner] und [hero]", italian="[CN]... [partner] e [hero]...", spanish="[CN][partner] y [hero]..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]formed an exploration team.", french="[CN]... formèrent une équipe d'exploration.", german="[CN]ein Erkundungsteam gründeten.", italian="[CN]... formano una squadra d'esplorazione.", spanish="[CN]formaron un equipo explorador."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]This turned out to be...", french="[CN]Ce n'était là que le tout début...", german="[CN]Wie sich herausstellen wird,", italian="[CN]Questo è...", spanish="[CN]Este sería su primer paso..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]their very first step into...", french="[CN]... leurs premiers pas...", german="[CN]war dies der erste Schritt", italian="[CN]... il loro primo passo...", spanish="[CN]para adentrarse en un mundo..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]many fantastic realms of adventure\n[CN]that awaited their arrival.", french="[CN]... car bientôt, de fantastiques aventures\n[CN]les attendraient.", german="[CN]zu vielen fantastischen Abenteuern,\n[CN]die sie noch erwarten.", italian="[CN]... in una fantastica avventura.", spanish="[CN]lleno de aventuras apasionantes..."})
  -- message_Close
  GAME:WaitFrames(60)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
