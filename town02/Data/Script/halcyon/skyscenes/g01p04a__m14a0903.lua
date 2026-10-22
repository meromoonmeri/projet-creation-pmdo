-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m14a0903.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(5)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That was...!)", french="(J'ai vu...!)", german="(Das war...)", italian="(Dunque...)", spanish="(He visto que...)"})
  else
  SkySceneKit.say({english="(That was...!)", french="(J'ai vu...!)", german="(Das war...)", italian="(Dunque...)", spanish="(He visto que...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:N]Grovyle[CR] was trying to steal a Time Gear!)", french="(J'ai vu [CS:N]Massko[CR] en train d'essayer\nde s'emparer d'un Rouage du Temps...)", german="(Das war [CS:N]Reptain[CR] beim Versuch, ein Zahnrad\nder Zeit zu stehlen!)", italian="([CS:N]Grovyle[CR] stava cercando di rubare un\nIngranaggio del Tempo...)", spanish="([CS:N]Grovyle[CR] intentaba robar un Engranaje del\nTiempo.)"})
  else
  SkySceneKit.say({english="([CS:N]Grovyle[CR] was trying to steal a Time Gear!)", french="(J'ai vu [CS:N]Massko[CR] en train d'essayer\nde s'emparer d'un Rouage du Temps...)", german="(Das war [CS:N]Reptain[CR] beim Versuch, ein Zahnrad\nder Zeit zu stehlen!)", italian="([CS:N]Grovyle[CR] stava cercando di rubare un\nIngranaggio del Tempo...)", spanish="([CS:N]Grovyle[CR] intentaba robar un Engranaje del\nTiempo.)"})
  end
  -- message_KeyWait
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(There was also another Pokémon...)", french="(Il y avait aussi un autre Pokémon...)", german="(Und da war noch ein anderes Pokémon.)", italian="(Ma c'era anche un altro Pokémon...)", spanish="(También había otro Pokémon...)"})
  else
  SkySceneKit.say({english="(There was also another Pokémon...)", french="(Il y avait aussi un autre Pokémon...)", german="(Und da war noch ein anderes Pokémon.)", italian="(Ma c'era anche un altro Pokémon...)", spanish="(También había otro Pokémon...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Was it [CS:N]Azelf[CR]?)", french="([CS:N]Créfadet[CR], peut-être?)", german="(War das [CS:N]Tobutz[CR]?)", italian="(Che fosse [CS:N]Azelf[CR]?)", spanish="(¿Se trataría de [CS:N]Azelf[CR]?)"})
  else
  SkySceneKit.say({english="(Was it [CS:N]Azelf[CR]?)", french="([CS:N]Créfadet[CR], peut-être?)", german="(War das [CS:N]Tobutz[CR]?)", italian="(Che fosse [CS:N]Azelf[CR]?)", spanish="(¿Se trataría de [CS:N]Azelf[CR]?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Anyway...)", french="(En tout cas...)", german="(Wie auch immer...)", italian="(Ad ogni modo...)", spanish="(En cualquier caso...)"})
  else
  SkySceneKit.say({english="(Anyway...)", french="(En tout cas...)", german="(Wie auch immer...)", italian="(Ad ogni modo...)", spanish="(En cualquier caso...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The crystal did trigger a vision...)", french="(... le Cri Dimensionnel s'est bel et bien\ndéclenché au contact de ce cristal...)", german="(Dieser Kristall hat eine Vision\nhervorgerufen.)", italian="(Visto che questo cristallo ha scatenato la\nvisione...)", spanish="(Ha sido este cristal el que ha provocado\nla visión.)"})
  else
  SkySceneKit.say({english="(The crystal did trigger a vision...)", french="(... le Cri Dimensionnel s'est bel et bien\ndéclenché au contact de ce cristal...)", german="(Dieser Kristall hat eine Vision\nhervorgerufen.)", italian="(Visto che questo cristallo ha scatenato la\nvisione...)", spanish="(Ha sido este cristal el que ha provocado\nla visión.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 4) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" See anything, [hero]?", french="Tu as vu quelque chose,\n[hero]?", german="Hast du etwas gesehen,\n[hero]?", italian=" Visto niente, [hero]?", spanish=" ¿Has visto algo, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Did you see anything,\n[hero]?", french="Tu as vu quelque chose,\n[hero]?", german="Hast du etwas gesehen,\n[hero]?", italian="Hai visto qualcosa,\n[hero]?", spanish=" ¿Has visto algo, [hero]?"})
  else
  SkySceneKit.say({english="Did you see anything,\n[hero]?", french="Tu as vu quelque chose,\n[hero]?", german="Hast du etwas gesehen,\n[hero]?", italian="Hai visto qualcosa,\n[hero]?", spanish=" ¿Has visto algo, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(45)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(45)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(45)
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN][hero] described the vision\n[CN]revealed by the Dimensional Scream.", french="[CN][hero] décrit la vision révélée\n[CN]par le Cri Dimensionnel.", german="[CN][hero] beschreibt die Vision,\n[CN]die der Dimensionale Schrei offenbart hat.", italian="[CN][hero] descrive ciò che ha visto\n[CN]grazie allo Squarcio Dimensionale.", spanish="[CN][hero] describió lo revelado\n[CN]por la Percepción de Cronos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 464, 232, Direction.DownRight, "NPC_BIPPA")
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 424, 272, Direction.Right, "NPC_DOGOOMU")
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 432, 216, Direction.DownRight, "NPC_PERAPPU")
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 360, 272, Direction.Right, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.Right, "NPC_GUREGGURU")
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 392, 256, Direction.Right, "NPC_CHIRIIN")
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 392, 272, Direction.Right, "NPC_HEIGANI")
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 448, 256, Direction.Right, "NPC_KIMAWARI")
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" WHAT?!", french=" PARDON?!", german=" WAS?!?", italian=" COSA?!", spanish=" ¡¿QUÉ?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You saw [CS:N]Grovyle[CR] knock out\na Pokémon?[K] One that you'd never seen before?", french="Tu as vu [CS:N]Massko[CR] mettre\nun autre Pokémon K.O.?[K] Un Pokémon\nque tu n'avais jamais vu auparavant?", german="Du hast gesehen, wie [CS:N]Reptain[CR]\nein Pokémon überwältigt hat?[K] Ein Pokémon,\ndas du noch nie gesehen hast?", italian="Hai visto [CS:N]Grovyle[CR] mettere KO\nun Pokémon?[K] Un Pokémon che non avevi\nmai visto prima?", spanish="¿Has visto a [CS:N]Grovyle[CR] derribar a\nun Pokémon?[K] ¿Uno que no habías visto antes?"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And then he tried to steal a\nTime Gear?!", french="Et ensuite il a essayé de voler\nun Rouage du Temps?!", german="Und dann hat er versucht, ein\nZahnrad der Zeit zu stehlen?!?", italian="E poi ha provato a rubare un\nIngranaggio del Tempo?!", spanish="¡¿Y luego intentó robar\nun Engranaje del Tiempo?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Oh my gosh! Your ability is\nthrilling!", french="J'hallucine! Il est trop cool,\nton pouvoir!", german="Auweia! Deine Fähigkeit ist\nwirklich spannend!", italian="Shock! Il tuo potere è\nincredibile!", spanish="¡Ay, que me da! ¡Tu habilidad\nes increíble!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="How did you get to see all that,\nby golly?", french="Comment t'as fait pour voir\ntous ces trucs-là, sapristi?", german="Donnerwetter! Wie hast du das\nnur alles gesehen?", italian="E come hai fatto, ohibò, a\nvedere tutte quelle cose?", spanish="¡Huy! ¿Cómo has podido ver\ntodo eso?"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="It's mighty hard for me\nto grasp!", french=" Moi, ça m'dépasse, pardi!", german="Ich kann mir das alles kaum\nvorstellen!", italian="È davvero difficile per me\ncapirlo, sissignore!", spanish=" No consigo entenderlo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey, [hero]!", french=" Eh dis donc, [hero]!", german=" Hey, hey, [hero]!", italian=" Ehi, ehi! [hero]!", spanish=" Oye, oye, [hero]."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="So that Pokémon you couldn't\nrecognize...do you think it might be [CS:N]Azelf[CR]?", french="Ce Pokémon inconnu... tu crois\nque c'était [CS:N]Créfadet[CR]?", german="War dieses Pokémon, das du\nnicht erkannt hast... vielleicht [CS:N]Tobutz[CR]?", italian="Pensi che il Pokémon che non sei\nriuscito a riconoscere... Pensi fosse [CS:N]Azelf[CR]?", spanish="Y ese Pokémon que no podías\nreconocer... ¿Crees que podría ser [CS:N]Azelf[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(2, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I...I have a question for\n[hero] too.", french="Moi... moi aussi j'ai une question\npour [hero].", german="Ich... Ich habe auch eine\nFrage an [hero].", italian="Anch'io ho una domanda per\n[hero].", spanish="A mí también me gustaría\npreguntarle algo a [hero]."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Did you see the past,\n[hero]?", french="Ta vision concernait-elle\nun événement passé, [hero]?", german="Hast du die Vergangenheit\ngesehen, [hero]?", italian="La tua visione, [hero], si\nriferiva al passato?", spanish="Lo que has visto, ¿ocurría en\nel pasado, [hero]?"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Or was that in the future?", french=" Ou à venir?", german="Oder ist es etwas, das in der\nZukunft geschehen wird?", italian="Oppure si tratta di qualcosa che\ndeve ancora accadere?", spanish="¿O se trata de algo que va a\nsuceder en el futuro?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Come to think of it...)", french="(Réflexion faite...)", german="(Wenn ich darüber nachdenke...)", italian="(Ora che ci penso...)", spanish="(Ahora que lo pienso...)"})
  else
  SkySceneKit.say({english="(Come to think of it...)", french="(Réflexion faite...)", german="(Wenn ich darüber nachdenke...)", italian="(Ora che ci penso...)", spanish="(Ahora que lo pienso...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Visions in the past...visions in the future...)", french="(Visions du passé... visions du futur...)", german="(Visionen aus der Vergangenheit...\nVisionen aus der Zukunft...)", italian="(Visioni del passato... del futuro...)", spanish="(Cuando veo algo del pasado o del futuro...)"})
  else
  SkySceneKit.say({english="(Visions in the past...visions in the future...)", french="(Visions du passé... visions du futur...)", german="(Visionen aus der Vergangenheit...\nVisionen aus der Zukunft...)", italian="(Visioni del passato... del futuro...)", spanish="(Cuando veo algo del pasado o del futuro...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's never clear when my visions take place!)", french="(Je ne sais jamais vraiment si mes visions\nconcernent l'un ou l'autre!)", german="(Es ist nie klar, was meine Visionen zeigen!)", italian="(Non è facile capire a cosa si riferiscano\nqueste visioni!)", spanish="(¡Nunca está muy claro cuándo tiene lugar!)"})
  else
  SkySceneKit.say({english="(It's never clear when my visions take place!)", french="(Je ne sais jamais vraiment si mes visions\nconcernent l'un ou l'autre!)", german="(Es ist nie klar, was meine Visionen zeigen!)", italian="(Non è facile capire a cosa si riferiscano\nqueste visioni!)", spanish="(¡Nunca está muy claro cuándo tiene lugar!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(2, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="So you're not sure if it's in the\npast or the future...", french="Alors tu ne sais pas trop si\nc'était le passé ou le futur...", german="Es ist also nicht sicher, ob du\ndie Vergangenheit oder die Zukunft gesehen\nhast...", italian="Non sai se si tratta del passato\no del futuro, vero?", spanish="Dices que no tienes muy claro\nsi se trata del pasado o del futuro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Well then...", french=" Bon, dans ce cas...", german=" Tja...", italian=" In tal caso...", spanish=" Entonces..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Since it is impossible to tell if\nthe vision is of the future or the past...", french="Puisqu'il est impossible\nde le savoir...", german="Man kann also unmöglich sagen,\nob die Vision die Zukunft oder die\nVergangenheit zeigt...", italian="Se non è possibile sapere se\nè una visione del futuro o del passato...", spanish="Dado que es imposible saber si la\nvisión tiene lugar en el pasado o en el futuro..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Then [hero]'s vision may\nwell be of a past event.", french="Alors imaginons que la vision\nde [hero] concernait un événement\npassé.", german="Die Vision von [hero]\nkann demnach durchaus auch aus der\nVergangenheit sein.", italian="... non dobbiamo dimenticare che\nallora la visione di [hero] potrebbe\nriferirsi a qualcosa che è già successo.", spanish="Lo que ha visto [hero]\npodría haber ocurrido ya."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" In that case...", french=" Dans ce cas...", german=" In diesem Fall...", italian=" E se fosse così...", spanish=" De ser así..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="The Time Gear may have already\nbeen stolen from there...", french="... le voleur s'est peut-être déjà\nenfui avec le Rouage du Temps...", german="In diesem Fall wurde das\nZahnrad der Zeit vielleicht schon gestohlen...", italian="... significherebbe che\nquell'Ingranaggio del Tempo è già stato\nrubato!", spanish="Puede que ya hayan robado el\nEngranaje del Tiempo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 448, 272, Direction.UpRight, "NPC_DIGUDA")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_perappu, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_perappu, 4) end)
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 392, 232, Direction.DownRight, "NPC_YONOWAARU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_perappu, 4) end)
  -- message_FacePositionOffset(2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Squawk?![K] You're saying we\nmay already be too late?!", french="Couac?![K] Tu insinues qu'il est\npeut-être déjà trop tard?!", german="Kreisch![K] Meinst du, dass wir\nwomöglich schon zu spät kommen?!?", italian="Squack?![K] È vero! Potrebbe già\nessere troppo tardi!", spanish="¡¿Cruac?![K] ¡¿Quieres decir que\nigual es demasiado tarde?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  GROUND:EntTurn(npc_npc_bippa, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_diguda, Direction.Left)
  GROUND:EntTurn(npc_npc_chiriin, Direction.DownLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_bippa, Direction.DownRight)
  GROUND:EntTurn(npc_npc_heigani, Direction.Left)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "sweating", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "sweating", 1) end)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "sweating", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "sweating", 1) end)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(3, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Everyone, please hold on!", french="Gardez votre calme,\ns'il vous plaît!", german=" Seid bitte alle kurz still!", italian="Prego, signori, manteniamo la\ncalma!", spanish=" Esperad, calmaos todos."})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_yonowaaru, 4) end)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_yonowaaru, 400, 228, false, 2)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpLeft)
  GAME:WaitFrames(45)
  -- message_FacePositionOffset(4, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Yes, it is true that it may have\nbeen a vision of the past.", french="En effet, il se peut qu'il s'agisse\nd'une vision appartenant au passé.", german="Ja, es ist wahr, dass die Vision\naus der Vergangenheit kommen könnte.", italian="SÌ, è vero, potrebbe anche\ntrattarsi di una visione del passato.", spanish="Sí, es cierto que podría ser\nuna visión del pasado."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="But it could have been a vision\nof the future.", french="Mais l'inverse est tout aussi\nplausible.", german="Aber es könnte auch eine Vision\naus der Zukunft sein.", italian="Ma non è ancora esclusa l'ipotesi\nche si tratti di una visione del futuro.", spanish="Pero también podría tratarse\nde una visión del futuro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="If you would be so kind, could\nyou remind us what [CS:N]Mesprit[CR] said,\n[partner]?", french="Peux-tu nous rappeler ce\nqu'a dit [CS:N]Créfollet[CR], [partner]?", german="Bist du so nett und erinnerst\nuns daran, was [CS:N]Vesprit[CR] gesagt hat,\n[partner]?", italian="[partner], potresti aiutarci a\nricordare cosa vi disse [CS:N]Mesprit[CR]?", spanish="Si eres tan amable, ¿podrías\nrecordarnos lo que dijo [CS:N]Mesprit[CR], [partner]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Who informed [CS:N]Mesprit[CR] via\ntelepathy that a Time Gear was stolen?", french="Qui donc a averti [CS:N]Créfollet[CR]\nde la disparition d'un Rouage du Temps\npar télépathie?", german="Wer hat [CS:N]Vesprit[CR] per Telepathie\nmitgeteilt, dass ein Zahnrad der Zeit gestohlen\nwurde?", italian="Chi informò telepaticamente\n[CS:N]Mesprit[CR] che un Ingranaggio del Tempo era\nstato rubato?", spanish="¿Quién informó a [CS:N]Mesprit[CR]\na través de telepatía de que habían\nrobado un Engranaje del Tiempo?"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="If I recall correctly, did you say\nthat it was [CS:N]Uxie[CR]?", french="Si mes souvenirs sont bons,\nil s'agissait de [CS:N]Créhelf[CR], n'est-ce pas?", german="Wenn ich mich recht erinnere,\nwar es [CS:N]Selfe[CR], nicht?", italian="Se ricordo bene, diceste che si\ntrattava di [CS:N]Uxie[CR]?", spanish="Si no recuerdo mal, dijiste\nque fue [CS:N]Uxie[CR], ¿verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hmm...", french=" Hum...", german=" Hmm...", italian=" Mmm...", spanish=" Hum."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hmm...", french=" Hum...", german=" Hmm...", italian=" Mmm...", spanish=" Hum."})
  else
  SkySceneKit.say({english=" Hmm...", french=" Hum...", german=" Hmm...", italian=" Mmm...", spanish=" Hum."})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
