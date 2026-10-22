-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m00p0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  SkyProg.set(6, 3) -- $SCENARIO_MAIN = scn[6,3] (ROM)
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P03A, 'UM05') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(7) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 520, 240, Direction.Down, "NPC_CHIRIIN")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GROUND:EntTurn(npc_npc_chiriin, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end) -- message_SetActor(ACTOR_NPC_CHIRIIN)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Oh! [hero]! And\n[partner] too!", french="Oh! [hero]! Et\ntoi aussi, [partner]!", german="Oh! [hero]! Und\n[partner] ist auch da!", italian="Oh! [hero]! E anche\n[partner]!", spanish="¡[hero]! ¡[partner]!\n¡Venid aquí!"})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Huh?[K] What's [CS:N]Chimecho[CR]\nup to there?", french="Quoi?[K] Qu'est-ce qu'[CS:N]Eoko[CR]\nmijote là-bas?", german="Huch?[K] Was macht [CS:N]Palimpalim[CR]\ndenn da?", italian=" Eh?[K] Cosa ci fa [CS:N]Chimecho[CR] lì?", spanish=" ¡Oye![K] ¿Qué hace allí [CS:N]Chimecho[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Huh?[K] What's [CS:N]Chimecho[CR]\ndoing there?", french="Quoi?[K] Qu'est-ce qu'[CS:N]Eoko[CR]\nmijote là-bas?", german="Huch?[K] Was macht [CS:N]Palimpalim[CR]\ndenn da?", italian=" Eh?[K] Cosa ci fa [CS:N]Chimecho[CR] lì?", spanish=" ¿Eh?[K] ¿Qué hace allí [CS:N]Chimecho[CR]?"})
  else
  SkySceneKit.say({english="Oh?[K] What is [CS:N]Chimecho[CR]\ndoing there?", french="Quoi?[K] Qu'est-ce qu'[CS:N]Eoko[CR]\nmijote là-bas?", german="Huch?[K] Was macht [CS:N]Palimpalim[CR]\ndenn da?", italian=" Eh?[K] Cosa ci fa [CS:N]Chimecho[CR] lì?", spanish=" Oye...[K] ¿Qué hace allí [CS:N]Chimecho[CR]?"})
  end
  -- message_Close
  pcall(function() GAME:MoveCamera(516, 252, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 528, 268, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(partner, 504, 268, false, 2)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Down)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, what's going on over here?", french=" Salut! Que se passe-t-il ici?", german=" Hey, was ist denn hier los?", italian=" Ehi, cosa succede qui?", spanish=" Oye, ¿qué haces aquí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hello! What's going on here?", french=" Salut! Que se passe-t-il ici?", german=" Hallo! Was ist denn hier los?", italian=" Ciao! Cosa succede qui?", spanish=" ¡Hola! ¿Qué haces aquí?"})
  else
  SkySceneKit.say({english=" Hello! What's going on here?", french=" Salut! Que se passe-t-il ici?", german=" Hallo! Was ist denn hier los?", italian=" Ciao! Cosa succede qui?", spanish=" ¡Hola! ¿Qué haces?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I just started an Assembly here.\nToday, in fact.", french="Je viens de créer un\nRassemblement ici. D'ailleurs, c'est\naujourd'hui la grande ouverture.", german="Das hier ist ein Treffpunkt.\nIch habe ihn heute erst eröffnet!", italian=" Sto inaugurando il mio Raduno.", spanish=" Pues acabo de abrir un registro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Assembly?", french=" Un Rassemblement?", german=" Ein Treffpunkt?", italian=" Raduno?", spanish=" ¿Un registro?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Assembly?", french=" Un Rassemblement?", german=" Ein Treffpunkt?", italian=" Raduno?", spanish=" ¿Un registro?"})
  else
  SkySceneKit.say({english=" Assembly?", french=" Un Rassemblement?", german=" Ein Treffpunkt?", italian=" Raduno?", spanish=" ¿Un registro?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Yes![K] For assembling your team!\nHave you ever considered adding members,\n[partner]?", french="Oui![K] Afin de rassembler votre\néquipe! As-tu déjà envisagé de recruter\ndes coéquipiers, [partner]?", german="Ja.[K] Hast du schon mal daran\ngedacht, mehr Mitglieder ins Team\naufzunehmen, [partner]?", italian="Sì![K] Per organizzare la tua\nsquadra! Hai mai pensato di aggiungere\naltri membri, [partner]?", spanish="Así es.[K] A ver, ¿no os gustaría\nincluir a nuevos miembros en vuestro equipo,\n[partner]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Other members?[K] Well, sure!\nIt'd be cool to add other members!", french="Des coéquipiers?[K] Non, mais\nce serait génial de pouvoir recruter\nd'autres membres!", german="Mehr Mitglieder?[K] Na klar!\nEs wäre cool, neue Mitglieder aufzunehmen!", italian="Altri membri?[K] Perché no?\nSarebbe bello ampliare la squadra!", spanish="¿Nuevos miembros?[K]\n¡Pues no estaría nada mal!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Other members?[K] Well, sure!\nIt'd be cool to add other members!", french="Des coéquipiers?[K] Non, mais\nce serait génial de pouvoir recruter\nd'autres membres!", german="Mehr Mitglieder?[K] Na klar!\nEs wäre cool, neue Mitglieder aufzunehmen!", italian="Altri membri?[K] Perché no?\nSarebbe bello ampliare la squadra!", spanish="¿Nuevos miembros?[K] ¡Buena idea!\n¡Estaría bien que se nos unieran más Pokémon!"})
  else
  SkySceneKit.say({english="Other members?[K] Well, sure!\nIt'd be cool to add other members!", french="Des coéquipiers?[K] Non, mais\nce serait génial de pouvoir recruter\nd'autres membres!", german="Mehr Mitglieder?[K] Na klar!\nEs wäre cool, neue Mitglieder aufzunehmen!", italian="Altri membri?[K] Perché no?\nSarebbe bello ampliare la squadra!", spanish="¿Nuevos miembros?[K] ¡Buena idea!\n¡Nos encantaría contar con más Pokémon!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If there were more than just\nthe two of us...", french="Si notre équipe comptait plus de\nmembres et pas seulement nous deux...", german="Wenn wir nicht mehr nur zu\nzweit wären...", italian="Se ci fossero altri Pokémon\noltre noi due...", spanish="Ir con otros Pokémon que nos\nechen una mano..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If there were more than just\nthe two of us...", french="Si notre équipe comptait plus de\nmembres et pas seulement nous deux...", german="Wenn wir nicht mehr nur zu\nzweit wären...", italian="Se ci fossero altri Pokémon\noltre noi due...", spanish=" Si somos más en el equipo..."})
  else
  SkySceneKit.say({english="If there were more than just\nthe two of us...", french="Si notre équipe comptait plus de\nmembres et pas seulement nous deux...", german="Wenn wir nicht mehr nur zu\nzweit wären...", italian="Se ci fossero altri Pokémon\noltre noi due...", spanish="Ampliar el grupo con otros\nPokémon..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It sure would help when we\nexplore dungeons!", french="... ce serait plus facile pour\nexplorer les donjons!", german="Das wäre bestimmt hilfreich\nbeim Erkunden von Dungeons!", italian="... avremmo la vita più facile\nquando esploriamo i dungeon!", spanish="¡Nos vendrá muy bien cuando\nexploremos territorios!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It sure would help when we\nexplore dungeons!", french="... ce serait plus facile pour\nexplorer les donjons!", german="Das wäre bestimmt hilfreich\nbeim Erkunden von Dungeons!", italian="... avremmo la vita più facile\nquando esploriamo i dungeon!", spanish="¡Será mucho más fácil explorar\nlos territorios!"})
  else
  SkySceneKit.say({english="It sure would help when we\nexplore dungeons!", french="... ce serait plus facile pour\nexplorer les donjons!", german="Das wäre bestimmt hilfreich\nbeim Erkunden von Dungeons!", italian="... avremmo la vita più facile\nquando esploriamo i dungeon!", spanish="¡Sería de gran ayuda al explorar\nterritorios!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Well then![K] You need to start\nrecruiting new members!", french="Eh bien voilà![K] Vous devriez\ncommencer à recruter de nouveaux membres!", german="Na also![K] Dann solltet ihr neue\nMitglieder anwerben!", italian="Bene![K] Allora dovete iniziare a\nreclutare altri membri!", spanish="Eso me imaginaba.[K] Entonces,\ntendréis que empezar a reclutar nuevos\nmiembros..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yeah? How do we start?", french="D'accord! Comment doit-on\ns'y prendre?", german=" So? Und wie geht das?", italian=" Ah sì? Da dove iniziamo?", spanish=" ¿Sí? ¿Y cómo lo hacemos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh? How do we start?", french="D'accord! Comment doit-on\ns'y prendre?", german=" Oh! Wie geht das denn?", italian=" Ah sì? Da dove iniziamo?", spanish=" ¿Sí? ¿Y cómo lo hacemos?"})
  else
  SkySceneKit.say({english=" How do we start?", french="D'accord! Comment doit-on\ns'y prendre?", german=" Wie geht das denn?", italian=" Come facciamo?", spanish=" ¿Sí? ¿Y cómo lo hacemos?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I'll just ring the Friendship Bell\nfor you, Team [team:]!", french="Je vais faire sonner la Cloche\nde l'Amitié pour vous, Equipe [team:]!", german="Ich läute ganz einfach die\nFreundesglocke für euch, Team [team:]!", italian="Suonerò la Campana dell'Amicizia\nper voi, Team [team:]!", spanish="Antes de nada, tengo que hacer\nsonar la Campana Amistad en vuestro honor,\n[CS:X]Equipo[CR] [team:]."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Here goes![K] Hey-yah!", french=" C'est parti![K] Et hop là!", german=" Dann mal los![K] Hey-yah!", italian=" Ecco qui![K] Evviva!", spanish=" Pues...[K] ¡Allá voy!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(10) end)
  -- GAP: se_Play(5123) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="[CN][CS:N]Chimecho[CR] rang\n[CN]the Friendship Bell!", french="[CN][CS:N]Eoko[CR] fait sonner\n[CN]la Cloche de l'Amitié!", german="[CN][CS:N]Palimpalim[CR] läutet\n[CN]die Freundesglocke!", italian="[CN][CS:N]Chimecho[CR] suona\n[CN]la Campana dell'Amicizia!", spanish="[CN]¡[CS:N]Chimecho[CR] hizo sonar\n[CN]la Campana Amistad!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Now Team [team:] has the\npower to recruit new members!", french="Vous pouvez désormais recruter\nde nouveaux membres, Equipe [team:]!", german="Team [team:] ist nun in\nder Lage, neue Mitglieder anzuwerben!", italian="Adesso, il Team [team:]\npuò reclutare altri membri!", spanish="¡Ahora el [CS:X]Equipo[CR] [team:]\npuede reclutar nuevos miembros!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" R-really?", french=" V-vraiment?", german=" W-wirklich?", italian=" Sul serio?", spanish=" ¿En serio?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" R-really?", french=" V-vraiment?", german=" W-wirklich?", italian=" Dici davvero?", spanish=" ¿De verdad?"})
  else
  SkySceneKit.say({english=" R-really?", french=" V-vraiment?", german=" W-wirklich?", italian=" D-Davvero?", spanish=" ¿De... De verdad?"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Yes! From now on, while battling\nPokémon in dungeons...", french="Oui! Dorénavant, en affrontant\ncertains Pokémon dans des donjons...", german="Ja! Ihr bekämpft Pokémon in\nDungeons, nicht wahr?", italian="Sì! D'ora in poi, quando\naffrontate dei Pokémon nei dungeon...", spanish="¡Sí! Desde ahora, cuando luchéis\nahí fuera contra otros Pokémon..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="You may earn respect from\nsome of them...[K]and those Pokémon will then\nask to join Team [team:].", french="... vous pourrez gagner leur\nrespect![K] Ils vous demanderont alors\ns'ils peuvent rejoindre l'Equipe [team:].", german="Ab sofort kann es passieren,\ndass manche Pokémon aus Respekt vor\neuch...[K] Team [team:] beitreten wollen!", italian="... potreste guadagnarvi il\nrispetto di alcuni di loro...[K] Questi potrebbero\nchiedervi di unirsi al Team [team:].", spanish="Puede que os ganéis el respeto\nde algunos de ellos...[K] y que quieran unirse\nal [CS:X]Equipo[CR] [team:]."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Once you have recruited a\nPokémon, you can bring it along with you\non dungeon explorations.", french="Une fois que vous avez recruté\nun Pokémon, vous pouvez l'emmener avec\nvous pour explorer les donjons.", german="Habt ihr ein Pokémon einmal\nangeworben, könnt ihr es mit auf Erkundungen\nvon Dungeons nehmen.", italian="Una volta reclutato un Pokémon,\npotete portarlo con voi quando esplorate un\ndungeon.", spanish="Una vez reclutados, podrán\nacompañaros en vuestras exploraciones."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="To bring a Pokémon along, visit\nmy Assembly, then choose which members\nshould join your team for the exploration.", french="Pour emmener un Pokémon,\nvenez au Rassemblement afin de choisir quels\nmembres rejoignent l'équipe pour l'exploration.", german="Dazu kommt ihr dann zu meinem\nTreffpunkt und bestimmt, welche Mitglieder\nihr mit auf Erkundung nehmen wollt.", italian="Per portare con voi un Pokémon,\nvisitate il mio Raduno, poi scegliete quali\nmembri devono unirsi alla squadra.", spanish="Para ello, solo tenéis que visitar\nmi registro y escoger los miembros que\nqueráis que vayan de expedición."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Always see me when you want\nto assemble a team that includes recruits! ♪", french="Venez toujours me voir quand\nvous voulez inclure de nouvelles recrues\ndans votre équipe! ♪", german="Kommt also immer zu mir,\nwenn ihr Rekruten mitnehmen wollt! ♪", italian="Venite a trovarmi quando volete\ncambiare i componenti della squadra! ♪", spanish="¡Así que venid a verme siempre\nque queráis que os acompañe algún recluta! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Great! Thanks, [CS:N]Chimecho[CR]!", french=" Super! Merci, [CS:N]Eoko[CR]!", german=" Super! Vielen Dank, [CS:N]Palimpalim[CR]!", italian=" Grandioso! Grazie, [CS:N]Chimecho[CR]!", spanish=" ¡Genial! ¡Gracias, [CS:N]Chimecho[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, wow! Thanks, [CS:N]Chimecho[CR]!", french=" Super! Merci, [CS:N]Eoko[CR]!", german=" Wow! Danke, [CS:N]Palimpalim[CR]!", italian=" Oh, wow! Grazie, [CS:N]Chimecho[CR]!", spanish=" ¡Estupendo! ¡Gracias, [CS:N]Chimecho[CR]!"})
  else
  SkySceneKit.say({english=" Wow! Thank you, [CS:N]Chimecho[CR]!", french=" Super! Merci, [CS:N]Eoko[CR]!", german=" Wow! Danke, [CS:N]Palimpalim[CR]!", italian=" Bene! Grazie, [CS:N]Chimecho[CR]!", spanish=" ¡Qué bien! ¡Gracias, [CS:N]Chimecho[CR]!"})
  end
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[5] = 1 -- $PERFORMANCE_PROGRESS_LIST[5] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[29] = 1 -- $PERFORMANCE_PROGRESS_LIST[29] = 1 (ROM)
  SkySceneKit.cleanup_npcs()
end
