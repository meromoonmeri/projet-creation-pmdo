-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/m03a0403.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_T01P01A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_T01P01A, 'UM03') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(5)
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBGM("Growing Anxiety.ogg", true) end)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What was that?!)", french="(C'était quoi?!)", german="(Was war das?!?)", italian="(Cosa è stato?!)", spanish="(¡¿Qué ha sido eso?!)"})
  else
  SkySceneKit.say({english="(What was that?!)", french="(C'était quoi?!)", german="(Was war das?!?)", italian="(Cosa è stato?!)", spanish="(¡¿Qué ha sido eso?!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I sure hope those kids find their\nitem soon.", french="Ce serait bien que ces deux\npetits gars retrouvent leur objet rapidement.", german="Ich hoffe, die Kleinen finden ihr\nItem bald wieder.", italian="Spero che quei ragazzi riescano\na trovare presto il loro strumento.", spanish="Espero que esos chiquillos\nencuentren pronto su objeto."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It would be nice if those little\nguys found their item soon.", french="Ce serait bien que ces deux\npetits gars retrouvent leur objet rapidement.", german="Es wäre schön, wenn die Kleinen\nihr Item bald finden würden.", italian="Spero che quei ragazzi riescano\na trovare presto il loro strumento.", spanish="Ojalá esos chiquillos encuentren\npronto su objeto."})
  else
  SkySceneKit.say({english="It would be nice if those cute\nlittle guys found their item soon.", french="Ce serait bien que ces deux\npetits gars retrouvent leur objet rapidement.", german="Es wäre schön, wenn diese\nputzigen Kleinen ihr Item bald finden würden.", italian="Spero che quei ragazzi riescano\na trovare presto il loro strumento.", spanish="A ver si esos chiquillos tan\nmonos encuentran pronto su objeto."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? What's up, [hero]?", french="Quoi? Qu'est-ce qu'il y a,\n[hero]?", german=" Häh? Was ist, [hero]?", italian=" Eh? Cosa c'è, [hero]?", spanish=" ¿Eh? ¿Qué pasa, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Huh? What's the matter,\n[hero]?", french="Quoi? Qu'est-ce qu'il y a,\n[hero]?", german="Häh? Was ist denn los,\n[hero]?", italian=" Eh? Cosa c'è, [hero]?", spanish=" ¿Eh? ¿Qué pasa, [hero]?"})
  else
  SkySceneKit.say({english="Huh? Is anything the matter,\n[hero]?", french="Quoi? Qu'est-ce qu'il y a,\n[hero]?", german="Häh? Stimmt etwas nicht,\n[hero]?", italian=" Eh? Cosa c'è, [hero]?", spanish=" ¿Te ocurre algo, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What's with that grim look?", french="Pourquoi tu fais une tête\npareille?", german="Was siehst du denn so\nfinster drein?", italian=" Perché quella faccia scura?", spanish=" ¿A qué viene esa mala cara?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You're looking awfully grim...", french="Pourquoi tu fais une tête\npareille?", german=" Du siehst aber finster drein.", italian=" Perché quella faccia scura?", spanish=" Has puesto muy mala cara."})
  else
  SkySceneKit.say({english=" Why are you looking so grim?", french="Pourquoi tu fais une tête\npareille?", german="Was siehst du denn so\nfinster drein?", italian=" Perché quella faccia scura?", spanish=" Te ha cambiado la cara."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="...Hmm?[K] You want to tell\nme something?", french="... Hein?[K] Tu veux me dire\nquelque chose?", german="...Hmm?[K] Was willst du mir\nsagen?", italian=" Eh?[K] Vuoi dirmi qualcosa?", spanish=" Hum...[K] ¿Quieres decirme algo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="...Hmm?[K] You want to tell\nme something?", french="... Hein?[K] Tu veux me dire\nquelque chose?", german="...Hmm?[K] Was willst du mir\nsagen?", italian=" Eh?[K] Vuoi dirmi qualcosa?", spanish=" ¿Sí...?[K] ¿Quieres decirme algo?"})
  else
  SkySceneKit.say({english="...Hmm?[K] You want to tell\nme something?", french="... Hein?[K] Tu veux me dire\nquelque chose?", german="...Hmm?[K] Was willst du mir\nsagen?", italian=" Eh?[K] Vuoi dirmi qualcosa?", spanish=" ¿Sí...?[K] ¿Quieres decirme algo?"})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false,  60)
  pcall(function() GAME:MoveCamera(520, 220, 1, false) end) -- SetPositionMark performer/caméra
  GROUND:TeleportTo(hero, 536, 220, Direction.Down)
  GROUND:TeleportTo(partner, 504, 220, Direction.Down)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(60)
  GAME:FadeIn(60)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What? You had a dizzy spell?", french=" Quoi? Tu as eu des vertiges?", german="Was? Du hattest einen\nSchwindelanfall?", italian=" Cosa? Hai avuto un capogiro?", spanish=" ¿Qué? ¿Te has mareado?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What? You had a dizzy spell?", french=" Quoi? Tu as eu des vertiges?", german="Was? Du hattest einen\nSchwindelanfall?", italian=" Cosa? Hai avuto un capogiro?", spanish=" ¿Qué? ¿Te has mareado?"})
  else
  SkySceneKit.say({english=" What? You had a dizzy spell?", french=" Quoi? Tu as eu des vertiges?", german="Was? Du hattest einen\nSchwindelanfall?", italian=" Cosa? Hai avuto un capogiro?", spanish=" ¿Qué? ¿Te has mareado?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Then you saw [CS:N]Azurill[CR] being\nthreatened by [CS:N]Drowzee[CR]?!", french="Puis tu as vu [CS:N]Soporifik[CR]\nqui menaçait [CS:N]Azurill[CR]?!", german="Und dann hast du gesehen, wie\n[CS:N]Azurill[CR] von [CS:N]Traumato[CR] bedroht wurde?!?", italian="E hai visto [CS:N]Drowzee[CR] minacciare\n[CS:N]Azurill[CR]?!", spanish="¡¿Y luego viste cómo [CS:N]Drowzee[CR]\namenazaba a [CS:N]Azurill[CR]?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Then you saw [CS:N]Azurill[CR] being\nthreatened by [CS:N]Drowzee[CR]?!", french="Puis tu as vu [CS:N]Soporifik[CR]\nqui menaçait [CS:N]Azurill[CR]?!", german="Und dann hast du gesehen, wie\n[CS:N]Azurill[CR] von [CS:N]Traumato[CR] bedroht wurde?!?", italian="E hai visto [CS:N]Drowzee[CR] minacciare\n[CS:N]Azurill[CR]?!", spanish="¡¿Y luego viste cómo [CS:N]Drowzee[CR]\namenazaba a [CS:N]Azurill[CR]?!"})
  else
  SkySceneKit.say({english="Then you saw [CS:N]Azurill[CR] being\nthreatened by [CS:N]Drowzee[CR]?!", french="Puis tu as vu [CS:N]Soporifik[CR]\nqui menaçait [CS:N]Azurill[CR]?!", german="Und dann hast du gesehen, wie\n[CS:N]Azurill[CR] von [CS:N]Traumato[CR] bedroht wurde?!?", italian="E hai visto [CS:N]Drowzee[CR] minacciare\n[CS:N]Azurill[CR]?!", spanish="¡¿Y luego viste cómo [CS:N]Drowzee[CR]\namenazaba a [CS:N]Azurill[CR]?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So you want to go rescue\n[CS:N]Azurill[CR] right away?", french="Tu veux qu'on aille sauver\n[CS:N]Azurill[CR] tout de suite?", german="Du willst dich also sofort auf\nden Weg machen, um [CS:N]Azurill[CR] zu retten?", italian="Quindi vuoi subito andare a\nsalvare [CS:N]Azurill[CR]?", spanish="¿Así que quieres ir a rescatar a\n[CS:N]Azurill[CR] inmediatamente?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So you want to go rescue\n[CS:N]Azurill[CR] right away?", french="Tu veux qu'on aille sauver\n[CS:N]Azurill[CR] tout de suite?", german="Du willst dich also sofort auf\nden Weg machen, um [CS:N]Azurill[CR] zu retten?", italian="Quindi vuoi subito andare a\nsalvare [CS:N]Azurill[CR]?", spanish="¿Así que quieres ir a rescatar a\n[CS:N]Azurill[CR] inmediatamente?"})
  else
  SkySceneKit.say({english="So you want to go rescue\n[CS:N]Azurill[CR] right away?", french="Tu veux qu'on aille sauver\n[CS:N]Azurill[CR] tout de suite?", german="Du willst dich also sofort auf\nden Weg machen, um [CS:N]Azurill[CR] zu retten?", italian="Quindi vuoi subito andare a\nsalvare [CS:N]Azurill[CR]?", spanish="¿Así que quieres ir a rescatar a\n[CS:N]Azurill[CR] inmediatamente?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's an...emergency?!", french=" C'est une... urgence?!", german=" Es ist ein Notfall?!?", italian=" È... un'emergenza?!", spanish=" ¿Es una... emergencia?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's an...emergency?!", french=" C'est une... urgence?!", german=" Es ist ein Notfall?!?", italian=" È... un'emergenza?!", spanish=" ¿Es una... emergencia?"})
  else
  SkySceneKit.say({english=" It's an...emergency?!", french=" C'est une... urgence?!", german=" Es ist ein Notfall?!?", italian=" È... un'emergenza?!", spanish=" ¿Es una... emergencia?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Well, what you describe does\nsound like an emergency, but...", french="D'après ce que tu racontes,\nc'est bien une urgence, mais...", german="Nun ja, das hört sich wirklich\nnach einem Notfall an, aber...", italian="Beh, in effetti quella che\ndescrivi sembra un'emergenza, ma...", spanish="Bueno, lo que describes parece\nuna emergencia, pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well, what you describe does\nsound like an emergency, but...", french="D'après ce que tu racontes,\nc'est bien une urgence, mais...", german="Nun ja, das hört sich wirklich\nnach einem Notfall an, aber...", italian="Beh, in effetti quella che\ndescrivi sembra un'emergenza, ma...", spanish="Bueno, lo que describes parece\nuna emergencia, pero..."})
  else
  SkySceneKit.say({english="Well, what you describe does\nsound like an emergency, but...", french="D'après ce que tu racontes,\nc'est bien une urgence, mais...", german="Nun ja, das hört sich wirklich\nnach einem Notfall an, aber...", italian="Beh, in effetti quella che\ndescrivi sembra un'emergenza, ma...", spanish="Bueno, lo que describes parece\nuna emergencia, pero..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Well, it's not like I don't trust\nyou, [hero], but...", french="Eh bien, ce n'est pas que je ne te\nfais pas confiance, [hero], mais...", german="Nicht, dass ich dir nicht\ntrauen würde, [hero], aber...", italian="Non è che non mi fidi,\n[hero], ma...", spanish="No es que no confíe en ti,\n[hero], pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well, it's not like I don't trust\nyou, [hero], but...", french="Eh bien, ce n'est pas que je ne te\nfais pas confiance, [hero], mais...", german="Nicht, dass ich dir nicht\ntrauen würde, [hero], aber...", italian="Non è che non mi fidi,\n[hero], ma...", spanish="No es que no confíe en ti,\n[hero], pero..."})
  else
  SkySceneKit.say({english="Well, it's not like I don't trust\nyou, [hero], but...", french="Eh bien, ce n'est pas que je ne te\nfais pas confiance, [hero], mais...", german="Nicht, dass ich dir nicht\ntrauen würde, [hero], aber...", italian="Non è che non mi fidi,\n[hero], ma...", spanish="No es que no confíe en ti,\n[hero], pero..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I just can't believe it!", french="... je n'arrive pas vraiment\nà y croire!", german="Ich kann das einfach nicht\nglauben!", italian=" ... non riesco proprio a crederci!", spanish=" ¡No puedo creerlo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I just can't believe it!", french="... je n'arrive pas vraiment\nà y croire!", german="Ich kann das einfach nicht\nglauben!", italian="... mi sembra davvero\nimpossibile!", spanish=" ¡No me lo puedo creer!"})
  else
  SkySceneKit.say({english=" I just can't believe it!", french="... je n'arrive pas vraiment\nà y croire!", german="Ich kann das einfach nicht\nglauben!", italian="... francamente non riesco\nproprio a crederci.", spanish=" ¡Es que resulta increíble!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I mean, [CS:N]Drowzee[CR] looked like an\nhonestly nice Pokémon, didn't he?", french="Après tout, [CS:N]Soporifik[CR] a l'air\nd'un Pokémon gentil et honnête, non?", german="Ich meine, [CS:N]Traumato[CR] sah doch\nwie ein freundliches Pokémon aus, oder nicht?", italian="Voglio dire, [CS:N]Drowzee[CR] sembrava\ngentile, no?", spanish="Quiero decir que [CS:N]Drowzee[CR]\nparecía un Pokémon honrado, ¿no crees?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="After all, [CS:N]Drowzee[CR] seemed to\nbe a sincerely nice Pokémon, didn't he?", french="Après tout, [CS:N]Soporifik[CR] a l'air\nd'un Pokémon gentil et honnête, non?", german="Schließlich sah [CS:N]Traumato[CR] wie\nein freundliches Pokémon aus, oder nicht?", italian="Voglio dire, [CS:N]Drowzee[CR] sembrava\ngentile, no?", spanish="Quiero decir que [CS:N]Drowzee[CR]\nparecía un Pokémon honrado, ¿no crees?"})
  else
  SkySceneKit.say({english="After all, [CS:N]Drowzee[CR] seemed to\nbe a sincerely nice Pokémon, didn't he?", french="Après tout, [CS:N]Soporifik[CR] a l'air\nd'un Pokémon gentil et honnête, non?", german="Schließlich sah [CS:N]Traumato[CR] wie\nein freundliches Pokémon aus, oder nicht?", italian="Voglio dire, [CS:N]Drowzee[CR] sembrava\ngentile, no?", spanish="Quiero decir que [CS:N]Drowzee[CR]\nparecía un Pokémon honrado, ¿no crees?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I watched the three of them go\noff earlier...", french="Je les ai regardés partir\nensemble tout à l'heure...", german="Ich habe die drei vorhin\nweggehen sehen...", italian="Mentre si allontanavano poco\nfa...", spanish="Antes les vi marcharse\na los tres..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I watched the three of them go\noff earlier...", french="Je les ai regardés partir\nensemble tout à l'heure...", german="Ich habe die drei vorhin\nweggehen sehen...", italian="Mentre si allontanavano poco\nfa...", spanish="Antes les vi marcharse\na los tres..."})
  else
  SkySceneKit.say({english="I saw the three of them go off\ntogether earlier...", french="Je les ai regardés partir\nensemble tout à l'heure...", german="Ich habe die drei zusammen\nweggehen sehen...", italian="Mentre si allontanavano poco\nfa...", spanish="Antes les vi marcharse\na los tres..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="They looked like they were\nhaving a good time, didn't they?", french="Ils avaient l'air de bien\ns'amuser.", german="Es sah doch so aus, als würden\nsie sich gut verstehen, oder?", italian="... sembrava che si stessero\ndivertendo, no?", spanish="Y parecían estar pasándoselo\nbien."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="They looked like they were\nhaving a good time, didn't they?", french="Ils avaient l'air de bien\ns'amuser.", german="Es sah doch so aus, als würden\nsie sich gut verstehen, oder?", italian="... sembrava che si stessero\ndivertendo, no?", spanish="Y parecían estar pasándoselo\nbien."})
  else
  SkySceneKit.say({english="They looked like they were\nhaving a good time, didn't they?", french="Ils avaient l'air de bien\ns'amuser.", german="Es sah doch so aus, als würden\nsie sich gut verstehen, oder?", italian="... sembrava che si stessero\ndivertendo, no?", spanish="Y parecían estar pasándoselo\nbien."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You're probably just tired,\n[hero].", french="Ça doit être la fatigue,\n[hero].", german="Du bist wahrscheinlich nur\nmüde, [hero].", italian="Sarà la stanchezza,\n[hero].", spanish="Probablemente es el cansancio,\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You're probably just tired,\n[hero].", french="Ça doit être la fatigue,\n[hero].", german="Du bist wahrscheinlich nur\nmüde, [hero].", italian="Sarà la stanchezza,\n[hero].", spanish="Probablemente es el cansancio,\n[hero]."})
  else
  SkySceneKit.say({english="You're probably just tired,\n[hero].", french="Ça doit être la fatigue,\n[hero].", german="Du bist wahrscheinlich nur\nmüde, [hero].", italian="Sarà la stanchezza,\n[hero].", spanish="Probablemente es el cansancio,\n[hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Maybe that's why you just had\nthat bad daydream.", french="C'est peut-être pour ça que\ntu as eu cette hallucination.", german="Vielleicht hattest du deswegen\ndiesen schlimmen Tagtraum.", italian="È stato solo un brutto sogno a\nocchi aperti!", spanish="Tal vez por eso has tenido\nesa alucinación."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Maybe that's why you just had\nthat bad daydream.", french="C'est peut-être pour ça que\ntu as eu cette hallucination.", german="Vielleicht hattest du deswegen\ndiesen schlimmen Tagtraum.", italian="Dev'essere per questo che hai\navuto un brutto sogno a occhi aperti.", spanish="Tal vez por eso has tenido\nesa alucinación."})
  else
  SkySceneKit.say({english="Maybe that's why you just had\nthat bad daydream.", french="C'est peut-être pour ça que\ntu as eu cette hallucination.", german="Vielleicht hattest du deswegen\ndiesen schlimmen Tagtraum.", italian="Devi aver avuto un brutto sogno\na occhi aperti.", spanish="Tal vez por eso has tenido\nesa alucinación."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Was that it...?[K] Just a bad daydream?)", french="(Vraiment...?[K] C'était seulement une\nhallucination?)", german="(War es das?[K] Nur ein Tagtraum?)", italian="(Sarà così...?[K] Un sogno a occhi aperti?)", spanish="(¿Sería entonces...?[K] ¿Solo una alucinación?)"})
  else
  SkySceneKit.say({english="(Was that it...?[K] Just a bad daydream?)", french="(Vraiment...?[K] C'était seulement une\nhallucination?)", german="(War es das?[K] Nur ein Tagtraum?)", italian="(Sarà così...?[K] Un sogno a occhi aperti?)", spanish="(¿Sería entonces...?[K] ¿Solo una alucinación?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But come to think of it...[K] That [CS:N]Drowzee[CR] didn't\nseem like a bad Pokémon.)", french="(Quand on y réfléchit...[K] ce [CS:N]Soporifik[CR] n'a\npas l'air d'être un méchant Pokémon.)", german="(Aber wenn ich darüber nachdenke...[K] Dieser\n[CS:N]Traumato[CR] kam mir wirklich nicht wie ein\nbösartiges Pokémon vor.)", italian="(Ma a pensarci...[K] quel [CS:N]Drowzee[CR] non\nsembrava un Pokémon cattivo.)", spanish="(Ahora que lo pienso...[K] Ese [CS:N]Drowzee[CR]\nno parecía un Pokémon malvado.)"})
  else
  SkySceneKit.say({english="(But come to think of it...[K] That [CS:N]Drowzee[CR] didn't\nseem like a bad Pokémon.)", french="(Quand on y réfléchit...[K] ce [CS:N]Soporifik[CR] n'a\npas l'air d'être un méchant Pokémon.)", german="(Aber wenn ich darüber nachdenke...[K] Dieser\n[CS:N]Traumato[CR] kam mir wirklich nicht wie ein\nbösartiges Pokémon vor.)", italian="(Ma a pensarci...[K] quel [CS:N]Drowzee[CR] non\nsembrava un Pokémon cattivo.)", spanish="(Ahora que lo pienso...[K] Ese [CS:N]Drowzee[CR]\nno parecía un Pokémon malvado.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Anyway, we're only apprentices.\nWe can't just go running off on our own.", french="De toute façon, on n'est que\ndes apprentis. On n'a pas le droit de partir\ncomme ça de notre côté.", german="Wir sind sowieso nur Lehrlinge.\nWir können nicht einfach auf eigene Faust\nlosziehen.", italian="In ogni caso, siamo delle\nsemplici reclute. Non possiamo prendere\nl'iniziativa.", spanish="De todos modos, solo somos\naprendices. No podemos salir a perseguir\na nadie así porque sí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Anyway, we're only apprentices.\nWe can't just go do whatever we want.", french="De toute façon, on n'est que\ndes apprentis. On n'a pas le droit de partir\ncomme ça de notre côté.", german="Wir sind sowieso nur Lehrlinge.\nWir können nicht einfach tun, was wir wollen.", italian="In ogni caso, siamo delle\nsemplici reclute. Non possiamo prendere\nl'iniziativa.", spanish="De todos modos, solo somos\naprendices. Tampoco tenemos la libertad\nde hacer lo que nos apetezca."})
  else
  SkySceneKit.say({english="Anyway, we're only apprentices.\nWe can't just go off on our own.", french="De toute façon, on fait partie\ndes apprentis. On n'a pas le droit de partir\ncomme ça de notre côté.", german="Wir sind sowieso nur Lehrlinge.\nWir können nicht einfach auf eigene Faust\nlosziehen.", italian="In ogni caso, siamo delle\nsemplici reclute. Non possiamo prendere\nl'iniziativa.", spanish="De todos modos, solo somos\naprendices. No podemos salir tras ellos\npor las buenas."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Sure, it's worrying, but...", french="C'est vrai que c'est inquiétant,\nmais...", german="Natürlich ist diese Sache\nbeunruhigend, aber...", italian="Certo, potrebbe rivelarsi una\ncosa seria, ma...", spanish=" Ya sé que es preocupante, pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Sure, it's worrying, but...", french="C'est vrai que c'est inquiétant,\nmais...", german="Natürlich ist diese Sache\nbeunruhigend, aber...", italian="Certo, potrebbe rivelarsi una\ncosa seria, ma...", spanish=" Ya sé que es preocupante, pero..."})
  else
  SkySceneKit.say({english=" Sure, it's a little odd, but...", french="C'est vrai que c'est inquiétant,\nmais...", german="Natürlich ist diese Sache\nirgendwie komisch, aber...", italian="Certo, potrebbe rivelarsi una\ncosa seria, ma...", spanish=" Ya sé que es preocupante, pero..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to focus on our guild\nwork for now.", french="... on doit se concentrer sur\nle travail à la Guilde pour l'instant.", german="Wir müssen uns jetzt erst mal\nauf unsere Arbeit in der Gilde konzentrieren.", italian="Per il momento dobbiamo\npensare a lavorare per la Gilda.", spanish="Por ahora tenemos que\ncentrarnos en el trabajo del [CS:N]Pokégremio[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to concentrate on our\nguild work for now.", french="... on doit se concentrer sur\nle travail à la Guilde pour l'instant.", german="Wir müssen uns jetzt erst mal\nauf unsere Arbeit in der Gilde konzentrieren.", italian="Per il momento dobbiamo\npensare a lavorare per la Gilda.", spanish="Por ahora tenemos que\nconcentrarnos en el trabajo del [CS:N]Pokégremio[CR]."})
  else
  SkySceneKit.say({english="We have to focus on our guild\nwork for now.", french="... on doit se concentrer sur\nle travail à la Guilde pour l'instant.", german="Wir müssen uns jetzt erst mal\nauf unsere Arbeit in der Gilde konzentrieren.", italian="Per il momento dobbiamo\npensare a lavorare per la Gilda.", spanish="Por ahora tenemos que\ncentrarnos en el trabajo del [CS:N]Pokégremio[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's get ready to explore, then\nmeet up with [CS:N]Bidoof[CR].", french="Préparons-nous pour\nl'exploration et allons voir [CS:N]Keunotor[CR].", german="Bereiten wir uns auf die\nErkundungstour vor und gehen zu [CS:N]Bidiza[CR].", italian="Finiamo i preparativi e poi\nandiamo da [CS:N]Bidoof[CR].", spanish="Vamos a prepararnos primero\npara explorar y después vamos a ver a [CS:N]Bidoof[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's get ourselves ready to\nexplore. Then we should find [CS:N]Bidoof[CR].", french="Préparons-nous pour\nl'exploration et allons voir [CS:N]Keunotor[CR].", german="Bereiten wir uns auf die\nErkundungstour vor. Dann sollten wir zu [CS:N]Bidiza[CR]\ngehen.", italian="Finiamo i preparativi e poi\nandiamo da [CS:N]Bidoof[CR].", spanish="Vamos a prepararnos primero\npara explorar y después vamos a ver a [CS:N]Bidoof[CR]."})
  else
  SkySceneKit.say({english="Let's get all set for exploring,\nthen go meet up with [CS:N]Bidoof[CR].", french="Préparons-nous pour\nl'exploration et allons voir [CS:N]Keunotor[CR].", german="Bereiten wir alles für die\nErkundungstour vor und gehen dann zu [CS:N]Bidiza[CR].", italian="Finiamo i preparativi e poi\nandiamo da [CS:N]Bidoof[CR].", spanish="Vamos a prepararnos para ir\nde exploración y vayamos luego a ver a [CS:N]Bidoof[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Bidoof[CR] said he'd be waiting for\nus on the guild's upper underground floor.", french="[CS:N]Keunotor[CR] a dit qu'il nous\nattendrait au premier sous-sol de la Guilde.", german="[CS:N]Bidiza[CR] sagte, er würde in\nder Unteren Gildenebene 1 sein.", italian="[CS:N]Bidoof[CR] ha detto che avrebbe\naspettato al Piano inferiore della Gilda 1.", spanish="[CS:N]Bidoof[CR] dijo que nos esperaría\nen la planta -1 del [CS:N]Pokégremio[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Bidoof[CR]'s supposed to be waiting\nfor us on the guild's upper underground floor.", french="[CS:N]Keunotor[CR] a dit qu'il nous\nattendrait au premier sous-sol de la Guilde.", german="[CS:N]Bidiza[CR] müsste in der Unteren\nGildenebene 1 auf uns warten.", italian="[CS:N]Bidoof[CR] ha detto che avrebbe\naspettato al Piano inferiore della Gilda 1.", spanish="[CS:N]Bidoof[CR] debe de estar\nesperándonos en la planta -1 del [CS:N]Pokégremio[CR]."})
  else
  SkySceneKit.say({english="[CS:N]Bidoof[CR] should be waiting for us\non the guild's upper underground floor.", french="[CS:N]Keunotor[CR] a dit qu'il nous\nattendrait au premier sous-sol de la Guilde.", german="[CS:N]Bidiza[CR] dürfte in der Unteren\nGildenebene 1 auf uns warten.", italian="[CS:N]Bidoof[CR] ha detto che avrebbe\naspettato al Piano inferiore della Gilda 1.", spanish="[CS:N]Bidoof[CR] nos iba a esperar\nen la planta -1 del [CS:N]Pokégremio[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's get to it, [hero]!", french=" C'est parti, [hero]!", german=" Packen wir es an, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡Vamos allá, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go, [hero]!", french=" C'est parti, [hero]!", german=" Lass uns gehen, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡Vámonos, [hero]!"})
  else
  SkySceneKit.say({english=" Let's go, [hero]!", french=" C'est parti, [hero]!", german=" Lass uns gehen, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡Vamos, [hero]!"})
  end
  -- message_Close
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
end
