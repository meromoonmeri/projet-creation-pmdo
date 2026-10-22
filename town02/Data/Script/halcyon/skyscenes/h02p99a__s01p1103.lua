-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/s01p1103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Since we can't use our old room\nat the guild anymore...", french="Puisque nous ne pouvons plus\nutiliser notre dortoir à la Guilde...", german="Nun, da wir unser Zimmer in der\nGilde nicht mehr in Anspruch nehmen können...", italian="Dal momento che non possiamo\npiù usare la nostra vecchia stanza alla Gilda...", spanish="Como ya no podemos seguir\nusando nuestra habitación del [CS:N]Pokégremio[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Since we can't use our old room\nat the guild anymore...", french="Puisque nous ne pouvons plus\nutiliser notre dortoir à la Guilde...", german="Nun, da wir unser altes Zimmer\nin der Gilde nicht mehr in Anspruch nehmen\nkönnen...", italian="Dal momento che non possiamo\npiù usare la nostra vecchia stanza alla Gilda...", spanish="Como ya no podemos seguir\nusando nuestra habitación del [CS:N]Pokégremio[CR]..."})
  else
  SkySceneKit.say({english="Since we can't use our old room\nat the guild anymore...", french="Puisque nous ne pouvons plus\nutiliser notre dortoir à la Guilde...", german="Nun, da wir unser altes Zimmer\nin der Gilde nicht mehr in Anspruch nehmen\nkönnen...", italian="Dal momento che non possiamo\npiù usare la nostra vecchia stanza alla Gilda...", spanish="Como ya no podemos seguir\nusando nuestra habitación del [CS:N]Pokégremio[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's live here from now on.", french=" ... nous vivrons ici désormais.", german="Ich würde sagen, wir wohnen ab\njetzt einfach hier!", italian="... d'ora in poi possiamo\nstare qui.", spanish="Viviremos aquí a partir de\nahora."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's live here from now on.", french=" ... nous vivrons ici désormais.", german="Ich würde sagen, wir wohnen ab\njetzt einfach hier!", italian="... d'ora in poi possiamo\nstare qui.", spanish="Viviremos aquí a partir de\nahora."})
  else
  SkySceneKit.say({english=" Let's live here from now on.", french=" ... nous vivrons ici désormais.", german="Ich würde sagen, wir wohnen ab\njetzt einfach hier!", italian="... d'ora in poi possiamo\nstare qui.", spanish="Viviremos aquí a partir de\nahora."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I don't get this whole idea of\ngraduating much yet...", french="Je n'ai pas encore réalisé que\nnous avons obtenu notre diplôme...", german="Ich habe den Sinn hinter dem\nGildenabschluss noch nicht ganz verstanden...", italian="Non ho ancora capito molto\nbene cosa significhi aver passato l'esame...", spanish="Aún me cuesta asimilar que\nha terminado nuestro entrenamiento..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This whole idea of graduating\nhasn't sunk in much yet...", french="Je n'ai pas encore réalisé que\nnous avons obtenu notre diplôme...", german="Der Sinn des Gildenabschlusses\nerschließt sich mir noch nicht so ganz...", italian="Non ho ancora capito molto\nbene cosa significhi aver passato l'esame...", spanish="Aún me cuesta asimilar que ya\nha concluido nuestro periodo de formación..."})
  else
  SkySceneKit.say({english="I don't get this whole idea of\ngraduating much yet...", french="Je n'ai pas encore réalisé que\nnous avons obtenu notre diplôme...", german="Der Sinn des Gildenabschlusses\nerschließt sich mir noch nicht so ganz...", italian="Non ho ancora capito molto\nbene cosa significhi aver passato l'esame...", spanish="Aún me cuesta asimilar que\nha terminado nuestro periodo de formación..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But let's keep working as an\nexploration team like we've always done.", french="Mais continuons notre travail\nd'exploration comme nous l'avons toujours fait.", german="Aber lass uns einfach weiter\nwie bisher als Erkundungsteam arbeiten.", italian="Comunque, possiamo continuare\na fare il nostro dovere di squadra\nd'esplorazione come prima.", spanish="Espero que sigamos trabajando\ncomo equipo explorador igual que siempre."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But let's keep going on as an\nexploration team like we always have.", french="Mais continuons notre travail\nd'exploration comme nous l'avons toujours fait.", german="Machen wir einfach als\nErkundungsteam weiter wie bisher.", italian="Comunque, possiamo continuare\na fare il nostro dovere di squadra\nd'esplorazione come prima.", spanish="Espero que sigamos trabajando\ncomo equipo explorador igual que siempre."})
  else
  SkySceneKit.say({english="But let's keep going on as an\nexploration team like we always have.", french="Mais continuons notre travail\nd'exploration comme nous l'avons toujours fait.", german="Machen wir einfach als\nErkundungsteam weiter wie bisher.", italian="Comunque, possiamo continuare\na fare il nostro dovere di squadra\nd'esplorazione come prima.", spanish="Espero que sigamos trabajando\ncomo equipo explorador igual que siempre."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" From now on...", french=" Désormais...", german=" Ich würde sagen...", italian=" Da oggi in avanti...", spanish=" A partir de ahora..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" From now on...", french=" Désormais...", german=" Ich würde sagen...", italian=" Da oggi in avanti...", spanish=" A partir de ahora..."})
  else
  SkySceneKit.say({english=" From now on...", french=" Désormais...", german=" Ich würde sagen...", italian=" Da oggi in avanti...", spanish=" A partir de ahora..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This is Team [team:]'s new\nexploration base!", french="... ceci est la nouvelle base\nde l'Equipe [team:]!", german="Von jetzt an ist dies die neue\nErkundungsbasis von Team [team:]!", italian="... questa sarà la nuova\nbase del Team [team:]!", spanish="¡Esta es la nueva base del [CS:X]Equipo[CR]\n[team:]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This is Team [team:]'s new\nexploration base!", french="... ceci est la nouvelle base\nde l'Equipe [team:]!", german="Von jetzt an ist dies die neue\nErkundungsbasis von Team [team:]!", italian="... questa sarà la nuova\nbase del Team [team:]!", spanish="¡Esta es la nueva base del [CS:X]Equipo[CR]\n[team:]!"})
  else
  SkySceneKit.say({english="This is Team [team:]'s new\nexploration base!", french="... ceci est la nouvelle base\nde l'Equipe [team:]!", german="Von jetzt an ist dies die neue\nErkundungsbasis von Team [team:]!", italian="... questa sarà la nuova\nbase del Team [team:]!", spanish="¡Esta es la nueva base del [CS:X]Equipo[CR]\n[team:]!"})
  end
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's head to the guild and check\nout the Job Bulletin Board and the Outlaw\nNotice Board for jobs!", french="Retournons à la Guilde et\nconsultons le Tableau des Missions et les\nAvis de Recherche pour trouver des missions.", german="Lass uns zur Gilde eilen und\nnach Jobs vom Job-Infobrett und\nGanoven-Infobrett schauen!", italian="Andiamo alla Gilda e diamo\nun'occhiata alla Bacheca dei ricercati\ne a quella delle missioni!", spanish="¡Vamos al Pokégremio a buscar\nmisiones en el Tablón de Anuncios y en el\nTablón \"Se Busca\"!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's head to the guild and check\nout the Job Bulletin Board and the Outlaw\nNotice Board for jobs!", french="Retournons à la Guilde et\nconsultons le Tableau des Missions et les\nAvis de Recherche pour trouver des missions.", german="Lass uns zur Gilde eilen und\nnach Jobs vom Job-Infobrett und\nGanoven-Infobrett schauen!", italian="Andiamo alla Gilda e controlliamo\nla Bacheca dei ricercati e quella delle missioni!", spanish="¡Vamos al Pokégremio a buscar\nmisiones en el Tablón de Anuncios y en el\nTablón \"Se Busca\"!"})
  else
  SkySceneKit.say({english="Let's head to the guild and check\nout the Job Bulletin Board and the Outlaw\nNotice Board for jobs!", french="Retournons à la Guilde et\nconsultons le Tableau des Missions et les\nAvis de Recherche pour trouver des missions.", german="Lass uns zur Gilde eilen und\nnach Jobs vom Job-Infobrett und\nGanoven-Infobrett schauen!", italian="Andiamo alla Gilda e controlliamo\nla Bacheca dei ricercati e quella delle missioni!", spanish="¡Vamos al Pokégremio a buscar\nmisiones en el Tablón de Anuncios y en el\nTablón \"Se Busca\"!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's a new beginning for us,\n[hero]!", french="C'est un nouveau départ pour\nnous, [hero]!", german="Das ist ein neuer Anfang für\nuns, [hero]!", italian="È un nuovo inizio per noi,\n[hero]!", spanish="¡Será como empezar de nuevo,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's a new beginning for us,\n[hero]!", french="C'est un nouveau départ pour\nnous, [hero]!", german="Das ist ein neuer Anfang für\nuns, [hero]!", italian="È un nuovo inizio per noi,\n[hero]!", spanish="¡Será como empezar de nuevo,\n[hero]!"})
  else
  SkySceneKit.say({english="It's a new beginning for us,\n[hero]!", french="C'est un nouveau départ pour\nnous, [hero]!", german="Das ist ein neuer Anfang für\nuns, [hero]!", italian="È un nuovo inizio per noi,\n[hero]!", spanish="¡Será como empezar de nuevo,\n[hero]!"})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayFanfare("Fanfare/Note") end) -- me_Play(7) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]Exploration Team\n[CN]Quick Advice[W:30]", french="[CN]Petit conseil à l'attention\n[CN]des équipes d'exploration[W:30]", german="[CN]Tipp für\n[CN]Erkundungsteams[W:30]", italian="[CN]Consiglio rapido\n[CN]per le squadre d'esplorazione.[W:30]", spanish="[CN]Consejo para\n[CN]equipos de exploración:[W:30]"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]Because you've graduated from the guild,\n[CN]you may from now on save a record of\n[CN]your progress using your bed here.", french="[CN]Comme vous avez obtenu le diplôme de\n[CN]la Guilde, vous pouvez maintenant sauvegarder\n[CN]votre aventure en utilisant ce lit.", german="[CN]Weil ihr die Gildenprüfung absolviert habt,\n[CN]könnt ihr euren Spielstand ab jetzt speichern,\n[CN]indem ihr hier euer Bett verwendet.", italian="[CN]Dal momento che avete superato l'esame della\n[CN]Gilda, d'ora in poi sarà possibile salvare\n[CN]l'avventura usando questo letto.", spanish="[CN]Como habéis superado el reto,\n[CN]a partir de ahora podéis guardar\n[CN]vuestro progreso en esta cama."})
  -- message_Close
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: BGM BGM_DO_YOUR_BEST_AS_ALWAYS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[177] = 3 -- dungeon_mode(177) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[178] = 3 -- dungeon_mode(178) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[99] = 3 -- dungeon_mode(99) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[100] = 3 -- dungeon_mode(100) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[101] = 3 -- dungeon_mode(101) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[102] = 3 -- dungeon_mode(102) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[6] = 1 -- $PERFORMANCE_PROGRESS_LIST[6] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[7] = 1 -- $PERFORMANCE_PROGRESS_LIST[7] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[20] = 1 -- $PERFORMANCE_PROGRESS_LIST[20] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SCENARIO_BALANCE_FLAG = 6 -- $SCENARIO_BALANCE_FLAG = 6 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SPECIAL_EPISODE_OPEN = SV.SkyVars.SPECIAL_EPISODE_OPEN or {}; SV.SkyVars.SPECIAL_EPISODE_OPEN[4] = 1 -- $SPECIAL_EPISODE_OPEN[4] = 1 (ROM)
end
