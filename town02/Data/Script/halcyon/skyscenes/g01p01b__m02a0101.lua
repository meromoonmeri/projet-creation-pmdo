-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P01B/m02a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetBanner2(LEVEL_G01P07C, 0, 148, 168, 2,) [bannière 2e écran NDS: information dupliquée du menu, hors canvas unique - documenté]
  GAME:FadeIn(45)
  GAME:WaitFrames(160)
  GAME:FadeOut(false, 45)
  GAME:WaitFrames(15)
  SkyProg.set(3, 1) -- $SCENARIO_MAIN = scn[3,1] (ROM)
  -- back2_SetMode(5) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_V01P08B) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-32), 64, false) end) -- MovePositionOffset performer/caméra
  -- GAP: BGM BGM_FIRE_CRACKLING_LOUDER non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- screen2_FadeIn(0, 30) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(30)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(180)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P01A) [décor sub chargé: Sub_v02p01a]
  -- back_SetGround(LEVEL_G01P01B2) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  SkySubScreen.Show("v02p01a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" This place is [CS:N]Wigglytuff[CR]'s Guild.", french=" Voici la Guilde de [CS:N]Grodoudou[CR].", german=" Hier ist die [CS:N]Knuddeluff-Gilde[CR].", italian=" Questa è la Gilda di [CS:N]Wigglytuff[CR].", spanish="Este es el [CS:N]Pokégremio de\nExploradores[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" This is [CS:N]Wigglytuff[CR]'s Guild.", french=" Voici la Guilde de [CS:N]Grodoudou[CR].", german=" Hier ist die [CS:N]Knuddeluff-Gilde[CR].", italian=" Questa è la Gilda di [CS:N]Wigglytuff[CR].", spanish="Este es el [CS:N]Pokégremio de\nExploradores[CR]."})
  else
  SkySceneKit.say({english=" This is [CS:N]Wigglytuff[CR]'s Guild.", french=" Voici la Guilde de [CS:N]Grodoudou[CR].", german=" Hier ist die [CS:N]Knuddeluff-Gilde[CR].", italian=" Questa è la Gilda di [CS:N]Wigglytuff[CR].", spanish="Este es el [CS:N]Pokégremio de\nExploradores[CR]."})
  end
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="To form an exploration team,\nyou need to register your team here.", french="Pour former une équipe\nd'exploration, c'est ici qu'il faut s'inscrire.", german="Wer ein Erkundungsteam bilden\nwill, muss das Team hier registrieren lassen.", italian="Per formare una squadra\nd'esplorazione, bisogna registrarsi qui.", spanish="Tenemos que registrarnos aquí\npara poder formar un equipo explorador."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="To form an exploration team,\nyou need to register your team here.", french="Pour former une équipe\nd'exploration, c'est ici qu'il faut s'inscrire.", german="Wer ein Erkundungsteam bilden\nwill, muss das Team hier registrieren lassen.", italian="Per formare una squadra\nd'esplorazione, bisogna registrarsi qui.", spanish="Tenemos que registrarnos aquí\npara poder formar un equipo explorador."})
  else
  SkySceneKit.say({english="To form an exploration team,\nyou need to register your team here.", french="Pour former une équipe\nd'exploration, c'est ici qu'il faut s'inscrire.", german="Wer ein Erkundungsteam bilden\nwill, muss das Team hier registrieren lassen.", italian="Per formare una squadra\nd'esplorazione, bisogna registrarsi qui.", spanish="Tenemos que registrarnos aquí\npara poder formar un equipo explorador."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Then you have to train until you\nbecome a first-rate exploration team.", french="Ensuite, il faut s'entraîner\npour devenir une équipe d'exploration\nde premier ordre.", german="Danach muss man trainieren, bis\nman zu einem erstklassigen Erkundungsteam\ngeworden ist.", italian="Poi bisogna allenarsi fino a\ndiventare un'ottima squadra d'esplorazione.", spanish="Luego tendremos que entrenarnos\nhasta convertirnos en un equipo explorador\nde primera."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Then you have to train until you\nbecome a first-rate exploration team.", french="Ensuite, il faut s'entraîner\npour devenir une équipe d'exploration\nde premier ordre.", german="Danach muss man trainieren, bis\nman zu einem erstklassigen Erkundungsteam\ngeworden ist.", italian="Poi bisogna allenarsi fino a\ndiventare un'ottima squadra d'esplorazione.", spanish="Luego habrá que entrenarse\nhasta que seamos un equipo explorador\nde primera categoría."})
  else
  SkySceneKit.say({english="Then you have to train until you\nbecome a first-rate exploration team.", french="Ensuite, il faut s'entraîner\npour devenir une équipe d'exploration\nde premier ordre.", german="Danach muss man trainieren, bis\nman zu einem erstklassigen Erkundungsteam\ngeworden ist.", italian="Poi bisogna allenarsi fino a\ndiventare un'ottima squadra d'esplorazione.", spanish="Luego tendremos que entrenarnos\npara convertirnos en un equipo explorador\nde primera clase."})
  end
  -- message_Close
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(20)
  -- SetAnimation(9) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Y-y-yikes!", french=" B-b-brrr!", german=" Oje!", italian=" G-G-Gulp!", spanish=" ¡Aaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Y-y-yikes!", french=" B-b-brrr!", german=" Oje!", italian=" G-G-Gulp!", spanish=" ¡Aaah!"})
  else
  SkySceneKit.say({english=" Y-y-yikes!", french=" B-b-brrr!", german=" Oje!", italian=" G-G-Gulp!", spanish=" ¡Aaah!"})
  end
  -- SetAnimation(2) [anim idle native]
  -- message_Close
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I still think this place is a\nbit weird. It just is!", french="Cet endroit est un peu étrange,\ntu ne trouves pas?", german="Ich finde diesen Ort immer noch\nirgendwie seltsam... Ja, er ist seltsam!", italian="Questo posto mi fa ancora un po'\npaura!", spanish="Sigo pensando que este sitio\nes un poco raro. ¡Es evidente!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Isn't there something just a\nlittle odd about this place?", french="Cet endroit est un peu étrange,\ntu ne trouves pas?", german="Irgendetwas an diesem Ort ist\nkomisch, findest du nicht?", italian="Questo posto mi fa ancora un po'\npaura!", spanish="¿No te parece que hay algo\nun poco raro en este sitio?"})
  else
  SkySceneKit.say({english="Isn't this place just a little bit\nodd? It just is!", french="Cet endroit est un peu étrange,\ntu ne trouves pas?", german="Irgendetwas an diesem Ort ist\nkomisch. Ganz eindeutig komisch!", italian="Questo posto mi fa ancora un po'\npaura!", spanish="¿No crees que este sitio es\nun poco raro? A mí me lo parece."})
  end
  -- message_Close
  GAME:WaitFrames(20)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="No...![K] I've got [hero] with\nme this time.", french="Non...![K] Cette fois, je suis\navec [hero].", german="Nein![K] Diesmal ist [hero]\nbei mir.", italian="No...![K] Questa volta c'è\n[hero] con me.", spanish="¡No![K] Esta vez [hero] está\nconmigo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="No...![K] I've got [hero] with\nme this time.", french="Non...![K] Cette fois, je suis\navec [hero].", german="Nein![K] Diesmal ist [hero]\nbei mir.", italian="No...![K] Questa volta c'è\n[hero] con me.", spanish="¡No![K] Esta vez [hero] me\nacompaña."})
  else
  SkySceneKit.say({english="No...![K] I've got [hero] with\nme this time.", french="Non...![K] Cette fois, je suis\navec [hero].", german="Nein![K] Diesmal ist [hero]\nbei mir.", italian="No...![K] Questa volta c'è\n[hero] con me.", spanish="¡No![K] Esta vez no estoy sola.\nTengo a [hero] a mi lado."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I have to be brave.", french=" Il faut que je sois courageux.", german=" Ich darf nicht feige sein.", italian=" Devo essere coraggioso.", spanish=" He de ser valiente."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I have to be brave.", french=" Il faut que je sois courageux.", german=" Ich darf nicht feige sein.", italian=" Devo essere coraggioso.", spanish=" Esta vez seré valiente."})
  else
  SkySceneKit.say({english=" I have to be brave.", french=" Il faut que je sois courageuse.", german=" Ich darf nicht feige sein.", italian=" Devo essere coraggiosa.", spanish=" He de ser valiente."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 240, 176, false, 2)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Pokémon detected![K] Pokémon detected!", french=" Pokémon détecté![K] Pokémon détecté!", german=" Pokémon entdeckt![K] Pokémon entdeckt!", italian=" Pokémon in arrivo![K] Pokémon in arrivo!", spanish=" ¡Pokémon detectado![K] ¡Pokémon detectado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Whose footprint?[K] Whose footprint?", french="A qui appartient l'empreinte?[K]\nA qui appartient l'empreinte?", german=" Wessen Fußabdruck?[K] Wessen Fußabdruck?", italian="A chi corrisponde la forma della zampa?[K]\nA chi corrisponde la forma della zampa?", spanish="¿De quién es la huella?[K]\n¿De quién es la huella?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="The footprint is [c_kind:ATTENDANT1]'s![K]\nThe footprint is [c_kind:ATTENDANT1]'s!", french="C'est l'empreinte de [c_kind:ATTENDANT1]![K]\nC'est l'empreinte de [c_kind:ATTENDANT1]!", german="Der Fußabdruck ist von [c_kind:ATTENDANT1]![K]\nDer Fußabdruck ist von [c_kind:ATTENDANT1]!", italian="È la zampa di [c_kind:ATTENDANT1]![K]\nÈ la zampa di [c_kind:ATTENDANT1]!", spanish="¡La huella es de [c_kind:ATTENDANT1]![K]\n¡La huella es de [c_kind:ATTENDANT1]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waah!", french=" Aaah!", german=" Waah!", italian=" Waah!", spanish=" ¡Aaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah!", french=" Aaah!", german=" Waah!", italian=" Aaah!", spanish=" ¡Aaah!"})
  else
  SkySceneKit.say({english=" Waah!", french=" Aaah!", german=" Waah!", italian=" Aaah!", spanish=" ¡Aaah!"})
  end
  -- message_Close
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(30)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" N-no. I have to tough it out...", french=" N-non. Il faut que je sois fort...", german="N-nein. Ich muss da jetzt\neinfach durch.", italian=" N-No. Devo farmi forza...", spanish=" No... Esta vez pienso resistir..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" N-no. I have to be strong...", french=" N-non. Il faut que je sois fort...", german="N-nein. Ich muss mich\nzusammenreißen.", italian=" N-No. Devo farmi coraggio...", spanish=" No... Esta vez seré fuerte..."})
  else
  SkySceneKit.say({english=" N-no. I can't lose it now...", french="N-non. Il faut que je\nsois forte...", german="N-nein. Ich kann jetzt nicht\naufgeben.", italian=" N-No. Devo essere coraggiosa...", spanish=" No... No debo perder el control..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" ...[K]You may ENTER!", french=" ...[K] Vous avez la permission d'ENTRER!", german=" ...[K]Du darfst EINTRETEN!", italian=" ...[K] Puoi ENTRARE!", spanish=" ...[K] ¡Puedes entrar!"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="Someone's with you![K] So get that stranger\nto stand up THERE!", french="Il y a quelqu'un avec vous![K] Faites-le\nvenir ICI!", german="Du hast jemanden mitgebracht![K] Der Fremde\nsoll seinen Fußabdruck zeigen! LOS!", italian="C'è qualcuno con te![K] Devi dire al Pokémon\nstraniero di mettersi LÌ!", spanish="¡Alguien te acompaña![K]\n¡Dile que dé un paso al frente!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(partner, 204, 176, false, 2)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(90)
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I think they're talking about you,\n[hero].", french="Je pense que c'est de toi qu'ils\nparlent, [hero].", german="Ich glaube, du bist gemeint,\n[hero].", italian="Penso che si riferiscano a te,\n[hero].", spanish="Creo que se refieren a ti,\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="They probably meant you,\n[hero].", french="Je pense que c'est de toi qu'ils\nparlent, [hero].", german="Du bist wahrscheinlich gemeint,\n[hero].", italian="Penso che si riferiscano a te,\n[hero].", spanish="Deben de referirse a ti,\n[hero]."})
  else
  SkySceneKit.say({english="I think they mean you,\n[hero].", french="Je pense que c'est de toi qu'ils\nparlent, [hero].", german="Ich glaube, das galt dir,\n[hero].", italian="Penso che si riferiscano a te,\n[hero].", spanish="Está claro que hablan de ti,\n[hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" They said to stand up here.", french=" Ils te disent de venir ici.", german="Du sollst deinen Fußabdruck\nzeigen.", italian="Hanno detto che devi\nmetterti qui.", spanish=" Dijeron que te pusieras aquí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" They said to stand up here.", french=" Ils te disent de venir ici.", german="Du sollst deinen Fußabdruck\nzeigen.", italian="Hanno detto che devi\nmetterti qui.", spanish=" Quieren que te pongas ahí."})
  else
  SkySceneKit.say({english=" They said to stand up here.", french=" Ils te disent de venir ici.", german="Du sollst deinen Fußabdruck\nzeigen.", italian="Hanno detto che devi\nmetterti qui.", spanish=" Tienes que ponerte ahí."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetGround(V02P02A) [décor sub chargé: Sub_v02p02a]
  -- camera2_SetPositionMark(Position<'m2', 19.5, 17.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v02p02a", 15, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(............)", french="(............)", german="(............)", italian="(............)", spanish="(...)"})
  else
  SkySceneKit.say({english="(............)", french="(............)", german="(............)", italian="(............)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(There's a grate covering the hole...)", french="(Une grille recouvre le trou...)", german="(Da ist ein Gitter über dem Loch.)", italian="(C'è una grata...)", spanish="(Una reja cubre el agujero.)"})
  else
  SkySceneKit.say({english="(There's a grate covering the hole...)", french="(Une grille recouvre le trou...)", german="(Da ist ein Gitter über dem Loch.)", italian="(C'è una grata...)", spanish="(Una reja cubre el agujero.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's made so that no one can fall through...)", french="(C'est fait de telle façon que personne ne peut\ntomber à travers...)", german="(Man kann offensichtlich nicht durchfallen.)", italian="(Grazie alla grata non si può cadere giù...)", spanish="(Supongo que para que nadie se caiga dentro.)"})
  else
  SkySceneKit.say({english="(It's made so that no one can fall through...)", french="(C'est fait de telle façon que personne ne peut\ntomber à travers...)", german="(Man kann offensichtlich nicht durchfallen.)", italian="(Grazie alla grata non si può cadere giù...)", spanish="(Supongo que para que nadie se caiga dentro.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Still, it's really strange...)", french="(C'est quand même très bizarre...)", german="(Trotzdem, sehr seltsam...)", italian="(Ma è comunque una cosa molto strana...)", spanish="(Aun así, es muy raro.)"})
  else
  SkySceneKit.say({english="(Still, it's really strange...)", french="(C'est quand même très bizarre...)", german="(Trotzdem, sehr seltsam...)", italian="(Ma è comunque una cosa molto strana...)", spanish="(Aun así, es muy raro.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It looks like it will tickle my feet or...)", french="(On dirait qu'ils vont me chatouiller les pieds\nou quelque chose comme ça...)", german="(Es sieht aus, als würde es einen am Fuß\nkitzeln oder...)", italian="(Potrebbe farmi il solletico ai piedi o...)", spanish="(Espero que no me vayan a hacer cosquillas...)"})
  else
  SkySceneKit.say({english="(It looks like it will tickle my feet or...)", french="(On dirait qu'ils vont me chatouiller les pieds\nou quelque chose comme ça...)", german="(Es sieht aus, als würde es einen am Fuß\nkitzeln oder...)", italian="(Potrebbe farmi il solletico ai piedi o...)", spanish="(Espero que no me vayan a hacer cosquillas...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetGround(V02P01A) [décor sub chargé: Sub_v02p01a]
  SkySubScreen.Show("v02p01a", 15, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(45)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Hey, you! Stranger![K] Get on the GRATE!", french=" Hé, toi! L'étranger![K] Va sur la GRILLE!", german="Hey, du! Fremder![K] Stell dich auf das\nGITTER!", italian="Ehi, tu! Pokémon straniero![K] Vai sulla\nGRATA!", spanish=" ¡Eh, tú![K] ¡Ponte sobre la reja!"})
  -- message_Close
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(hero, 240, 176, false, 2)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Pokémon detected![K] Pokémon detected!", french=" Pokémon détecté![K] Pokémon détecté!", german=" Pokémon entdeckt![K] Pokémon entdeckt!", italian=" Pokémon in arrivo![K] Pokémon in arrivo!", spanish=" ¡Pokémon detectado![K] ¡Pokémon detectado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Whose footprint?[K] Whose footprint?", french="A qui appartient l'empreinte?[K]\nA qui appartient l'empreinte?", german=" Wessen Fußabdruck?[K] Wessen Fußabdruck?", italian="A chi corrisponde la forma della zampa?[K]\nA chi corrisponde la forma della zampa?", spanish="¿De quién es la huella?[K]\n¿De quién es la huella?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" The footprint is...[K] The footprint is... Um...", french="C'est l'empreinte de...[K] euh...\nl'empreinte de... Hum...", german="Der Fußabdruck ist von...[K] Der Fußabdruck\nist von... Äh...", italian=" È la zampa di...[K] È la zampa di... Ehm...", spanish="¡La huella es de...! [K]\nLa huella es de... Esto..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" What's the matter?![K] Sentry![K] Sentry?!", french=" Quel est le problème?![K] Garde![K] GARDE?!", german=" Was ist los?!?[K] Wache![K] Wache?!?", italian=" Cosa succede?![K] Sentinella![K] Sentinella?!", spanish=" ¿Qué pasa?[K] ¡Centinela![K] ¿Centinela?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" What's wrong, sentry [CS:N]Diglett[CR]?", french="Qu'est-ce qui t'arrive, garde\n[CS:N]Taupiqueur[CR]?", german=" Was ist los, Wachposten [CS:N]Digda[CR]?", italian=" Cosa c'è, sentinella [CS:N]Diglett[CR]?", spanish=" ¿Qué pasa, centinela [CS:N]Diglett[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 200, 168, Direction.Down, "NPC_DIGUDA")
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end) -- message_SetActor(ACTOR_NPC_DIGUDA)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Umm... Er...", french=" Hmm... euh...", german=" Ähmmm... Äh...", italian=" Uhm... Ehm...", spanish=" Hum... Esto..."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
