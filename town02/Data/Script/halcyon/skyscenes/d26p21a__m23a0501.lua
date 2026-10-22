-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D26P21A/m23a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for object OBJECT_G01P01A1_93
    -- MoveHeight(2, 10) [élévation d'objet NDS non simulée - documenté]
    GAME:WaitFrames(1)
    -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
    GAME:WaitFrames(1) -- hold
  end)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(24, 2) -- $SCENARIO_MAIN = scn[24,2] (ROM)
  -- back_SetGround(LEVEL_D26P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_LOWER_BRINE_CAVE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 232, 432, Direction.Up, "NPC_PERAPPU")
  GROUND:MoveToPosition(npc_npc_perappu, 228, 292, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 244, 292, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 212, 300, false, 2)
  GROUND:MoveToPosition(npc_npc_perappu, 188, 260, false, 2)
  GROUND:MoveToPosition(hero, 244, 276, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We've gone pretty far down.", french="Ça fait déjà un bon moment\nqu'on avance.", german="Wir sind ziemlich weit ins\nInnere der Höhle vorgedrungen.", italian="Abbiamo già fatto un bel po' di\nstrada.", spanish=" Ya hemos avanzado bastante."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We've gone pretty far down.", french="Ça fait déjà un bon moment\nqu'on avance.", german="Wir sind ziemlich weit ins\nInnere der Höhle vorgedrungen.", italian="Abbiamo già fatto un bel po' di\nstrada.", spanish=" Ya hemos avanzado bastante."})
  else
  SkySceneKit.say({english=" We've gone pretty far down.", french="Ça fait déjà un bon moment\nqu'on avance.", german="Wir sind ziemlich weit ins\nInnere der Höhle vorgedrungen.", italian="Abbiamo già fatto un bel po' di\nstrada.", spanish=" Ya hemos avanzado bastante."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, [CS:N]Chatot[CR].[K] Are we getting\ncloser to where you saw that pattern?", french="Eh, [CS:N]Pijako[CR].[K] Est-ce qu'on arrive\nbientôt à l'endroit où tu as vu le symbole?", german="Hey, [CS:N]Plaudagei[CR].[K] Kommen wir\nnäher zu der Stelle, an der du dieses Muster\ngesehen hast?", italian="Ehi, [CS:N]Chatot[CR].[K] Siamo ancora\nlontani dal punto in cui hai visto il disegno?", spanish="Oye, [CS:N]Chatot[CR]...[K] ¿Falta mucho\npara llegar al sitio donde viste aquella\ninscripción?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hey, [CS:N]Chatot[CR].[K] Are we nearing\nthe place where you saw that pattern?", french="Eh, [CS:N]Pijako[CR].[K] Est-ce qu'on arrive\nbientôt à l'endroit où tu as vu le symbole?", german="Hey, [CS:N]Plaudagei[CR].[K] Kommen wir\nder Stelle näher, an der du dieses Muster\ngesehen hast?", italian="Ehi, [CS:N]Chatot[CR].[K] Siamo ancora\nlontani dal punto in cui hai visto il disegno?", spanish="Oye, [CS:N]Chatot[CR]...[K] ¿Estamos cerca\ndel sitio donde viste aquella inscripción?"})
  else
  SkySceneKit.say({english="Hey, [CS:N]Chatot[CR].[K] Are we almost at\nthe place where you saw that pattern?", french="Eh, [CS:N]Pijako[CR].[K] Est-ce qu'on arrive\nbientôt à l'endroit où tu as vu le symbole?", german="Hey, [CS:N]Plaudagei[CR].[K] Sind wir\nbald an der Stelle, wo du dieses Muster\ngesehen hast?", italian="Ehi, [CS:N]Chatot[CR].[K] Siamo ancora\nlontani dal punto in cui hai visto il disegno?", spanish="Oye, [CS:N]Chatot[CR]...[K] ¿Falta mucho\npara llegar al sitio donde viste aquella\ninscripción?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" We're nearly there.", french=" On y est presque.", german=" Wir sind fast da.", italian=" Ci siamo quasi.", spanish=" Ya casi hemos llegado."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We don't have far to go.[K]\nHowever...", french="On n'est plus très loin.[K]\nCependant...", german="Es ist nicht mehr weit.[K]\nAllerdings...", italian="Non manca più molto.[K]\nComunque...", spanish="No falta mucho.[K]\nSin embargo..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="As I've told you before...[K] Every\nstep also takes us closer to those vicious\nPokémon.", french="Comme je vous l'ai dit...[K]\nA chaque pas nous nous rapprochons du repaire\nde ces ignobles Pokémon.", german="Wie schon gesagt...[K] Jeder\nSchritt führt uns auch diesen boshaften\nPokémon entgegen.", italian="Come vi dicevo prima...[K] Ogni\npasso ci avvicina anche a quei Pokémon.", spanish="Tal y como os he dicho...[K]\nCada paso también nos acerca más a esos\nPokémon tan desalmados."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yup. We can't let our guard\ndown.", french=" Oui. Restons sur nos gardes.", german="Jep. Wir können uns keine\nSchwäche leisten.", italian="Già. Non dobbiamo abbassare la\nguardia.", spanish="Cierto. No podemos bajar\nla guardia."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yes, and we'll have to stay\ncareful and keep our eyes open.", french=" Oui. Restons sur nos gardes.", german="Ja, und wir müssen vorsichtig\nsein und die Augen offen halten.", italian="Sì, dobbiamo fare attenzione\ne tenere gli occhi aperti.", spanish="Cierto. Habrá que seguir con los\nojos bien abiertos."})
  else
  SkySceneKit.say({english=" Yep. We can't get careless.", french=" Oui. Restons sur nos gardes.", german="Jep. Wir können nicht sorglos\nsein.", italian="Già. Non dobbiamo abbassare la\nguardia.", spanish=" Sí... ¡No hay que descuidarse!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Anyway, it's not far now. Let's\nkeep it up, [hero]!", french="Enfin, on y est presque. Courage,\n[hero]!", german="Aber es ist nicht mehr weit.\nLass uns am Ball bleiben, [hero]!", italian="In ogni caso, non manca più\nmolto. Diamoci dentro, [hero]!", spanish="Ya no queda mucho.\n¡Ánimo, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Anyway, we don't have far to\ngo now. Let's keep it up, [hero]!", french="Enfin, on y est presque. Courage,\n[hero]!", german="Aber wir müssen nicht mehr\nweit gehen. Lass uns am Ball bleiben,\n[hero]!", italian="In ogni caso, non manca più\nmolto. Diamoci dentro, [hero]!", spanish="Ya no queda mucho.\n¡Ánimo, [hero]!"})
  else
  SkySceneKit.say({english="Anyway, it's not far now. Let's\nkeep it up, [hero]!", french="Enfin, on y est presque. Courage,\n[hero]!", german="Aber es ist nicht mehr weit.\nLass uns am Ball bleiben, [hero]!", italian="In ogni caso, non manca più\nmolto. Diamoci dentro, [hero]!", spanish="Ya no queda mucho.\n¡Ánimo, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  local npc_npc_sukatanku = SkySceneKit.spawn_npc("skuntank", 232, 456, Direction.Up, "NPC_SUKATANKU")
  GROUND:MoveToPosition(npc_npc_sukatanku, 228, 324, false, 2)
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 248, 440, Direction.Up, "NPC_DOGAASU")
  GROUND:MoveToPosition(npc_npc_dogaasu, 244, 308, false, 2)
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 216, 440, Direction.Up, "NPC_ZUBATTO")
  GROUND:MoveToPosition(npc_npc_zubatto, 212, 308, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  -- SetAnimation(12) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  GROUND:MoveToPosition(partner, 212, 260, false, 2) -- SlidePositionMark (glissement)
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- SetAnimation(68) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(hero, 236, 260, false, 2)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ow!", french=" Ouille!", german=" Aua!", italian=" Ahia!", spanish=" ¡Ay!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ow!", french=" Ouille!", german=" Aua!", italian=" Ahia!", spanish=" ¡Ay!"})
  else
  SkySceneKit.say({english=" Ouch!", french=" Ouille!", german=" Autsch!", italian=" Ahi!", spanish=" ¡Ay!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Whoops! Excuuuse me!", french=" Oups! Excusez-môaaa!", german=" Uuups! Entschuuuldigung!", italian=" Oooops! Scusami!", spanish=" ¡Vaya! ¡Mil perdones!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey!", french=" Eh!", german=" Hey!", italian=" Ehi!", spanish=" ¡Eh!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey!", french=" Eh!", german=" Hey!", italian=" Ehi!", spanish=" ¡Eh!"})
  else
  SkySceneKit.say({english=" Hey!", french=" Eh!", german=" Hey!", italian=" Ehi!", spanish=" ¡Eh!"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Team Skull.ogg", true) end)
  GAME:WaitFrames(2)
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Whoa-ho![K] Long time, weaklings!", french="Mouarf mouarf![K] Ça faisait\nun bail, bande de mauviettes!", german="Whoaho![K] Lange her,\nSchwächlinge!", italian="Uooh-oh![K] Quanto tempo,\nschiappe!", spanish="¡Jo, jo![K] ¡Cuánto tiempo sin\nveros, pandilla de enclenques!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Oh, you're that nice team...eh?", french="Oh, vous êtes cette aimable\néquipe... non?", german="Oh, ihr seid dieses nette Team,\nnicht wahr?", italian="Oh, siete quella squadra così\nsimpatica... vero?", spanish="Ah, sois aquel equipo tan\nsimpático... ¿Eh?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" This is it?[K] The Relic Fragment?", french="C'est ça?[K] Le Fragment\nde Relique?", german=" Ist es das?[K] Das Reliktfragment?", italian="È questo?[K] Il Frammento\nAntico?", spanish="¿Es esto?[K]\n¿Es la Reliquia de Piedra?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Th-that's...!", french=" C-c'est...!", german=" D-das ist...", italian=" Q-Quello è...!", spanish=" ¡Eso es mi...!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Th-that's...!", french=" C-c'est...!", german=" D-das ist...", italian=" Q-Quello è...!", spanish=" ¡Eso es mi...!"})
  else
  SkySceneKit.say({english=" Th-that's...!", french=" C-c'est...!", german=" D-das ist...", italian=" Q-Quello è...!", spanish=" ¡Eso es mi...!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_dogaasu, 260, 308, false, 2)
  GROUND:MoveToPosition(npc_npc_zubatto, 196, 308, false, 2)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Up)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Up)
  GROUND:MoveToPosition(npc_npc_sukatanku, 228, 300, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8710) — id SE NDS sans portage PMDO identifié
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" Chaw-haw-haw![K] I'll take this!", french="Gnark gnark gnark![K] Donne,\nje vais te le garder!", german="Cha-ha-ha![K] Ich nehme das an\nmich!", italian="Ahr-ahr-ahr![K] Questo lo prendo\nio!", spanish=" ¡Jua, jua, jua![K] ¡Yo te la guardo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey!", french=" Eh!", german=" Hey!", italian=" Ehi!", spanish=" ¡Oye!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey!", french=" Eh!", german=" Hey!", italian=" Ehi!", spanish=" ¡Oye!"})
  else
  SkySceneKit.say({english=" Hey!", french=" Eh!", german=" Hey!", italian=" Ehi!", spanish=" ¡Oye!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="Whoa-ho-ho![K] This is the\nsecond time you're getting mugged for this!", french="Mouarf mouarf mouarf![K] C'est\nla deuxième fois qu'on vous le pique!", german="Whoahoho![K] Jetzt wirst du\nschon zum zweiten Mal deshalb ausgeraubt!", italian="Uooh-oh-oh![K] È la seconda volta\nche te lo fai soffiare!", spanish="¡Jo, jo, jo![K] ¡Ya es la segunda\nvez que os la quitamos así!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Heh-heh-heh! You don't learn\nvery well, that's for sure!", french="Hin hin hin! Vous mettez du\ntemps à comprendre, en tout cas!", german="Hehehe! Du lernst es eben\nnicht, so viel steht fest!", italian="Eh-eh-eh! Non hai imparato la\nlezione, questo è sicuro!", spanish="¡Jue, jue, jue!\n¡Parece que no aprendéis!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="W-wait, wait, please![K] I'm afraid\nI'm not following what's going on here.", french="Attendez, attendez, je vous\nprie![K] J'ai peur de ne pas bien saisir ce qui\nse passe ici.", german="W-warte, warte, bitte![K] Ich\nfürchte, ich kann dem Ganzen hier nicht folgen.", italian="A-Aspettate, aspettate, per\nfavore![K] Non capisco cosa stia succedendo.", spanish="¡Eh, esperad un momento![K] Creo\nque no me he enterado bien de lo que está\npasando."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Why are you even here?", french="Qu'est-ce que vous faites là,\npour commencer?", german=" Warum seid ihr überhaupt hier?", italian=" Perché siete qui?", spanish=" ¿Qué estáis haciendo aquí?"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We haven't seen any of you\nfrom Team [CS:X]Skull[CR] since you suddenly\ndisappeared during the expedition.", french="On ne vous a plus revus depuis\nvotre soudaine disparition pendant l'expédition.", german="Wir haben keinen von Team\n[CS:X]Totenkopf[CR] gesehen, seit ihr bei der Expedition\nplötzlich verschwunden seid.", italian="Non vi abbiamo più visto da\nquando, voi del Team [CS:X]Teschio[CR], siete\nspariti durante la spedizione.", spanish="No habíamos tenido noticias del\n[CS:X]Equipo Calavera[CR] desde que os esfumasteis tras\naquella expedición del [CS:N]Pokégremio[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" I fretted for your well-being!", french="Je me suis fait du mauvais sang\npour vous!", german="Ich war um euer Wohlbefinden\nbesorgt!", italian=" Ero preoccupato per voi!", spanish="¡Me inquietaba que os hubiese\npodido pasar algo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" Worried, huh...?[K] Chaw-haw-haw!", french="Du mauvais sang, hein...?[K] Gnark\ngnark gnark!", german=" Besorgt, wie?[K] Cha-ha-ha!", italian="Preoccupato, eh...?[K]\nAhr-ahr-ahr!", spanish="Preocupado, ¿eh...?[K]\n¡Jua, jua, jua!"})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Your guild's full of gullible\nnincompoops just waiting to be fleeced.", french="Vous, à la Guilde, vous n'êtes\nqu'une bande de cornichons crédules qui ne\ndemandez qu'à vous faire plumer.", german="Eure Gilde ist voller\ngutgläubiger Trottel, die darauf warten,\ngeschröpft zu werden.", italian="La vostra Gilda è piena di\nmezze calzette credulone che aspettano\nsolo di essere imbrogliate.", spanish="Tu [CS:N]Pokégremio[CR] está lleno de\nmequetrefes crédulos esperando\na que alguien les desplume."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Oh-oh-oh?!", french=" Quoi quoi?!", german=" Oh-oh-oh?!?", italian=" Oh-oh-oh?!", spanish=" ¿Pero qué...? ¡¿Cómo?!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Your demeanor and language\nseem to be much coarser now!", french="Vous êtes bien grossiers\ntout à coup!", german="Dein Verhalten und deine Sprache\nsind auf einmal so ungehobelt!", italian="Il vostro comportamento e il\nvostro modo di parlare ora sembrano più\nrozzi!", spanish="¡Vuestra actitud y lenguaje es\nahora mucho más vulgar!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Chatot[CR]!", french=" [CS:N]Pijako[CR]!", german=" [CS:N]Plaudagei[CR]!", italian=" [CS:N]Chatot[CR]!", spanish=" ¡[CS:N]Chatot[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Chatot[CR]!", french=" [CS:N]Pijako[CR]!", german=" [CS:N]Plaudagei[CR]!", italian=" [CS:N]Chatot[CR]!", spanish=" ¡[CS:N]Chatot[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]Chatot[CR]!", french=" [CS:N]Pijako[CR]!", german=" [CS:N]Plaudagei[CR]!", italian=" [CS:N]Chatot[CR]!", spanish=" ¡[CS:N]Chatot[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="They were fooling the guild all\nthis time!", french="Ils se sont toujours moqués\nde la Guilde!", german="Sie haben die Gilde die ganze\nZeit hinters Licht geführt!", italian="Per tutto questo tempo hanno\npreso in giro la Gilda!", spanish="Han estado engañando al\n[CS:N]Pokégremio[CR] todo este tiempo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="They were deceiving the guild\nall this time!", french="Ils se sont toujours moqués\nde la Guilde!", german="Sie haben die Gilde die ganze\nZeit getäuscht!", italian="Per tutto questo tempo hanno\ntruffato la Gilda!", spanish="Han estado engañando al\n[CS:N]Pokégremio[CR] todo este tiempo."})
  else
  SkySceneKit.say({english="They were fooling the guild all\nthis time!", french="Ils se sont toujours moqués\nde la Guilde!", german="Sie haben die Gilde die ganze\nZeit hinters Licht geführt!", italian="Per tutto questo tempo hanno\npreso in giro la Gilda!", spanish="Han estado engañando al\n[CS:N]Pokégremio[CR] todo este tiempo."})
  end
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="They're a bad exploration team!\nTeam [CS:X]Skull[CR] is a bunch of crooks!", french="Ce sont de méchants Pokémon!\nL'Equipe [CS:X]Crâne[CR] n'est qu'une bande\nde canailles!", german="Sie sind ein schlechtes\nErkundungsteam! Team [CS:X]Totenkopf[CR] besteht aus\neinem Haufen krummer Hunde!", italian="Sono una pessima squadra\nd'esplorazione! Il Team [CS:X]Teschio[CR] è una banda\ndi canaglie!", spanish="¡Son un equipo explorador\nmalvado! ¡Los miembros del [CS:X]Equipo Calavera[CR]\nno son más que unos canallas!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="They're a bad exploration team!\nTeam [CS:X]Skull[CR] is a bunch of crooks!", french="Ce sont de méchants Pokémon!\nL'Equipe [CS:X]Crâne[CR] n'est qu'une bande\nde canailles!", german="Sie sind ein schlechtes\nErkundungsteam! Team [CS:X]Totenkopf[CR] besteht aus\neinem Haufen krummer Hunde!", italian="Sono una pessima squadra\nd'esplorazione! Il Team [CS:X]Teschio[CR] è una banda\ndi canaglie!", spanish="¡Son un equipo explorador\nmalvado! ¡Los miembros del [CS:X]Equipo Calavera[CR]\nno son más que unos canallas!"})
  else
  SkySceneKit.say({english="They're a bad exploration team!\nTeam [CS:X]Skull[CR] is a bunch of crooks!", french="Ce sont de méchants Pokémon!\nL'Equipe [CS:X]Crâne[CR] n'est qu'une bande\nde canailles!", german="Sie sind ein schlechtes\nErkundungsteam! Team [CS:X]Totenkopf[CR] besteht aus\neinem Haufen krummer Hunde!", italian="Sono una pessima squadra\nd'esplorazione! Il Team [CS:X]Teschio[CR] è una banda\ndi canaglie!", spanish="¡Son un equipo explorador\nmalvado! ¡Los miembros del [CS:X]Equipo Calavera[CR]\nno son más que unos canallas!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(20)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Wha-wha-what?![K] Is that true?!", french="Hein, comment ça?![K] Est-ce\nvrai?!", german=" Wa-wa-was?!?[K] Stimmt das?!?", italian=" Cosa cosa cosa?![K] Davvero?!", spanish="¿Pero qué decís?[K]\n¿Es cierto eso?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Whoa-ho! What else?", french=" Mouarf mouarf! Eh ouais!", german=" Whoaho! Was denn noch?", italian=" Uooh-oh! Che altro?", spanish=" ¡Jo, jo! ¿A ti qué te parece?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="You'd have to be naive beyond\nbelief to be fooled this long! Heh-heh!", french="C'est incroyable ce que vous\nêtes naïfs pour n'y avoir vu que du feu\npendant tout ce temps! Hin hin!", german="Man muss schon unbeschreiblich\nnaiv sein, sich so lange täuschen zu lassen!\nHehe!", italian="Devi essere proprio ingenuo, se\nti sei fatto fregare per così tanto tempo!\nEh-eh!", spanish="¡Seguro que a tu edad todavía\ncrees en los duendes! ¡Jue, jue!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Anyway, now we've got the Relic\nFragment.", french="Enfin bref, maintenant\nle Fragment de Relique est à nous.", german="Na ja, wir haben jetzt das\nReliktfragment.", italian="Ad ogni modo, ora abbiamo il\nFrammento Antico.", spanish="El caso es que ahora tenemos\nla Reliquia de Piedra."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Now we just have to go to the\n[CS:P]Hidden Land[CR].", french="Il ne nous reste plus qu'à aller\ndans les [CS:P]Terres Illusoires[CR].", german="Jetzt müssen wir nur noch zum\n[CS:P]Verborgenen Land[CR] gehen.", italian="E non ci resta che andare nella\n[CS:P]Terra Nascosta[CR].", spanish="Ya solo nos queda llegar a\nla [CS:P]Tierra Oculta[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Eat your heart out, nitwits!\nChaw-haw-haw!", french="Vous pouvez aller vous rhabiller,\nles nullos! Gnark gnark gnark!", german="Heult euch doch die Augen aus,\nihr Schwächlinge! Cha-ha-ha!", italian="Mangiatevi il cappello, schiappe!\nAhr-ahr-ahr!", spanish="¡Ahí os quedáis, pardillos!\n¡Jua, jua, jua!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(160) end)
  GROUND:MoveToPosition(npc_npc_sukatanku, 268, 268, false, 2)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_dogaasu, 268, 268, false, 2)
  GROUND:MoveToPosition(npc_npc_sukatanku, 268, 172, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_zubatto, 268, 268, false, 2)
  GROUND:EntTurn(npc_npc_perappu, Direction.Right)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:MoveToPosition(npc_npc_dogaasu, 268, 172, false, 2)
  GROUND:MoveToPosition(npc_npc_zubatto, 268, 172, false, 2)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_perappu, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(hero, Direction.Up)
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(60)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "angry", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Left)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Squawk![K] Sq-sq-squawk!", french=" Couac![K] C-Couac!", german=" Kreisch![K] K-k-kreisch!", italian=" Squack![K] Sq-Sq-Squack!", spanish=" ¡Cruac![K] ¡Cruaaac!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Those stinking scoundrels...[K]\nPlay me for a fool, will they!?", french="Misérables vermines...[K] Alors,\ncomme ça, ils me prennent pour un idiot!?", german="Diese miesen Schufte...[K]\nMich zum Narren zu halten!!!", italian="Quelle canaglie...[K]\nMi hanno preso per uno stupido!?", spanish="Esos malditos rufianes...[K]\n¡Me han tomado por tonto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Squawk! They won't get away\nwith this!", french="Couac! Ils ne s'en sortiront pas\nà si bon compte!", german="Kreisch! Damit werden sie nicht\ndurchkommen!", italian="Squack! Non se la caveranno\ncosì facilmente!", spanish="¡Cruac!\n¡No se saldrán con la suya!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I'll show them what it means to\ntrifle with me!", french="Je leur montrerai ce\nqu'on récolte quand on se joue de moi!", german="Ich werde ihnen zeigen, was es\nheißt, sich mit mir anzulegen!", italian="Gli farò vedere cosa vuol dire\nprendersi gioco di me!", spanish="¡Ya les enseñaré lo que es\nbuscarse un problema conmigo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_perappu, 188, 172, false, 2)
  GAME:WaitFrames(20)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Up)
  -- Destroy() [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-46), 31, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! Wait! [CS:N]Chatot[CR]!", french=" Eh, [CS:N]Pijako[CR]! Attends!", german=" Hey! Warte! [CS:N]Plaudagei[CR]!", italian=" Ehi! Aspetta! [CS:N]Chatot[CR]!", spanish=" ¡Oye! ¡Espera! ¡[CS:N]Chatot[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! Wait! [CS:N]Chatot[CR]!", french=" Eh, [CS:N]Pijako[CR]! Attends!", german=" Hey! Warte! [CS:N]Plaudagei[CR]!", italian=" Ehi! Aspetta! [CS:N]Chatot[CR]!", spanish=" ¡Oye! ¡Espera! ¡[CS:N]Chatot[CR]!"})
  else
  SkySceneKit.say({english=" Oh! Wait! [CS:N]Chatot[CR]!", french=" Eh, [CS:N]Pijako[CR]! Attends!", german=" Oh! Warte! [CS:N]Plaudagei[CR]!", italian=" Oh! Aspetta! [CS:N]Chatot[CR]!", spanish=" ¡Oye! ¡Espera! ¡[CS:N]Chatot[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" H-he's gone!", french=" Il... il est parti!", german=" E-er ist weg!", italian=" S-Se n'è andato!", spanish=" ¡Se ha ido!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" H-he's gone!", french=" Il... il est parti!", german=" E-er ist weg!", italian=" S-Se n'è andato!", spanish=" ¡Se ha ido!"})
  else
  SkySceneKit.say({english=" H-he's gone!", french=" Il... il est parti!", german=" E-er ist weg!", italian=" S-Se n'è andato!", spanish=" ¡Se ha ido!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Chatot[CR] was so angry. I hope that\nhe'll be OK!", french="[CS:N]Pijako[CR] était dans une colère\nnoire. Pourvu qu'il ne lui arrive rien!", german="[CS:N]Plaudagei[CR] war so aufgebracht.\nIch hoffe, ihm wird nichts zustoßen.", italian="[CS:N]Chatot[CR] era davvero arrabbiato.\nSpero che andrà tutto bene!", spanish="[CS:N]Chatot[CR] estaba realmente\nenfadado. ¡Espero que no le pase nada!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Chatot[CR] was sure furious. I hope\nhe'll be OK!", french="[CS:N]Pijako[CR] était dans une colère\nnoire. Pourvu qu'il ne lui arrive rien!", german="[CS:N]Plaudagei[CR] war so aufgebracht.\nIch hoffe, ihm wird nichts zustoßen.", italian="[CS:N]Chatot[CR] era davvero arrabbiato.\nSpero che andrà tutto bene!", spanish="[CS:N]Chatot[CR] estaba realmente\nenfadado. ¡Espero que no le pase nada!"})
  else
  SkySceneKit.say({english="[CS:N]Chatot[CR] was really upset. I hope\nhe'll be OK!", french="[CS:N]Pijako[CR] était dans une colère\nnoire. Pourvu qu'il ne lui arrive rien!", german="[CS:N]Plaudagei[CR] war so aufgebracht.\nIch hoffe, ihm wird nichts zustoßen.", italian="[CS:N]Chatot[CR] era davvero arrabbiato.\nSpero che andrà tutto bene!", spanish="[CS:N]Chatot[CR] estaba realmente\nenfadado. ¡Espero que no le pase nada!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I mean, there are those vicious\nPokémon he'd warned us about lurking\nsomewhere ahead.", french="C'est vrai, les horribles\nPokémon dont il nous a parlé ne doivent\npas être loin.", german="Ich meine, hier lauern überall\ndiese boshaften Pokémon, von denen er uns\nerzählt hat.", italian="Non dimentichiamoci di quei\nPokémon malvagi dai quali ci ha messo\nin guardia...", spanish="Supongo que no se olvidará\nde que por aquí cerca se encuentran esos\nPokémon tan despiadados."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="After all, there are those\nvicious Pokémon he'd warned us about\nlurking ahead.", french="C'est vrai, les horribles\nPokémon dont il nous a parlé ne doivent\npas être loin.", german="Ich meine, hier lauern überall\ndiese boshaften Pokémon, von denen er uns\nerzählt hat.", italian="Non dimentichiamoci di quei\nPokémon malvagi dai quali ci ha messo\nin guardia...", spanish="Supongo que no se olvidará\nde que por aquí cerca se encuentran esos\nPokémon tan despiadados."})
  else
  SkySceneKit.say({english="After all, there are those\nvicious Pokémon he'd warned us about\nlurking ahead.", french="C'est vrai, les horribles\nPokémon dont il nous a parlé ne doivent\npas être loin.", german="Ich meine, hier lauern überall\ndiese boshaften Pokémon, von denen er uns\nerzählt hat.", italian="Non dimentichiamoci di quei\nPokémon malvagi dai quali ci ha messo\nin guardia...", spanish="Supongo que no se olvidará\nde que por aquí cerca se encuentran esos\nPokémon tan despiadados."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And we still need to get my\nRelic Fragment back from [CS:N]Skuntank[CR].", french="Et il faut encore qu'on reprenne\nmon Fragment de Relique à [CS:N]Moufflair[CR].", german="Und wir müssen immer noch\nmein Reliktfragment von [CS:N]Skuntank[CR] zurückholen.", italian="E dobbiamo ancora recuperare\nil Frammento Antico da [CS:N]Skuntank[CR].", spanish="Nosotros tenemos que recuperar\nla Reliquia de Piedra que me ha quitado\n[CS:N]Skuntank[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Not just that, we still need to\nrecover my Relic Fragment from [CS:N]Skuntank[CR].", french="Et il faut encore qu'on reprenne\nmon Fragment de Relique à [CS:N]Moufflair[CR].", german="Nicht nur das, wir müssen auch\nmein Reliktfragment von [CS:N]Skuntank[CR] zurückholen.", italian="Non solo, dobbiamo ancora\nrecuperare il Frammento Antico da [CS:N]Skuntank[CR].", spanish="Nosotros tenemos que recuperar\nla Reliquia de Piedra que me ha quitado\n[CS:N]Skuntank[CR]."})
  else
  SkySceneKit.say({english="And we have to get my Relic\nFragment back from [CS:N]Skuntank[CR].", french="Et il faut encore qu'on reprenne\nmon Fragment de Relique à [CS:N]Moufflair[CR].", german="Und wir müssen immer noch\nmein Reliktfragment von [CS:N]Skuntank[CR] zurückholen.", italian="E dobbiamo ancora recuperare\nil Frammento Antico da [CS:N]Skuntank[CR].", spanish="Ahora tenemos que recuperar\nla Reliquia de Piedra que me ha quitado\n[CS:N]Skuntank[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We should hurry too!", french=" Il faut faire vite!", german=" Wir sollten uns auch beeilen!", italian=" Diamoci una mossa!", spanish=" ¡Y hay que darse prisa!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We should hurry too!", french=" Il faut faire vite!", german=" Wir sollten uns auch beeilen!", italian=" Dobbiamo affrettarci!", spanish=" ¡Y hay que darse prisa!"})
  else
  SkySceneKit.say({english=" We should hurry too!", french=" Il faut faire vite!", german=" Wir sollten uns auch beeilen!", italian=" Muoviamoci!", spanish=" ¡Y deprisa!"})
  end
  -- message_Close
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: BGM BGM_LOWER_BRINE_CAVE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[25] = 1 -- $PERFORMANCE_PROGRESS_LIST[25] = 1 (ROM)
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
