-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/enter12.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 0 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- SetAnimation(2) [anim idle native]
  -- supervision_ExecuteCommon(CORO_EVENT_N01_03) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw == 2 then
  -- SetAnimation(2) [anim idle native]
  -- supervision_ExecuteCommon(CORO_EVENT_N04_03) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  if (SkyProg.cmp(4, 3) <= 0) then -- if ROM: scn($SCENARIO_MAIN) <= [4, 3]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [hero].", french=" Dis, [hero].", german=" Hey, [hero].", italian=" Ehi, [hero].", spanish=" ¿Qué pasa, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Listen, [hero].", french=" Dis, [hero].", german=" Hör mal, [hero].", italian=" Ascolta, [hero].", spanish=" Oye, [hero]."})
  else
  SkySceneKit.say({english=" Say, [hero].", french=" Dis, [hero].", german=" Sag mal, [hero].", italian=" Senti, [hero].", spanish=" Dime, [hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Didn't [CS:N]Bidoof[CR] say he'd help us\npick an outlaw?", french="[CS:N]Keunotor[CR] a dit qu'il nous aiderait\nà choisir un hors-la-loi, non?", german="Sagte [CS:N]Bidiza[CR] nicht, er würde\nuns bei der Auswahl eines Ganoven helfen?", italian="[CS:N]Bidoof[CR] non ha detto che voleva\naiutarci a catturare un ricercato?", spanish="¿No dijo [CS:N]Bidoof[CR] que nos echaría\nuna mano a la hora de elegir un malhechor?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="When it came to picking an\noutlaw, didn't [CS:N]Bidoof[CR] say he'd help us?", french="[CS:N]Keunotor[CR] a dit qu'il nous aiderait\nà choisir un hors-la-loi, non?", german="Wollte [CS:N]Bidiza[CR] uns nicht bei der\nAuswahl eines Ganoven helfen?", italian="[CS:N]Bidoof[CR] non ha detto che, quando\nsaremmo andati a caccia di un ricercato,\nci avrebbe aiutato?", spanish="¿No dijo [CS:N]Bidoof[CR] que nos ayudaría\na elegir un malhechor?"})
  else
  SkySceneKit.say({english="Didn't [CS:N]Bidoof[CR] say he'd help us\npick an outlaw?", french="[CS:N]Keunotor[CR] a dit qu'il nous aiderait\nà choisir un hors-la-loi, non?", german="Hat uns [CS:N]Bidiza[CR] für die Auswahl\neines Ganoven nicht Hilfe zugesichert?", italian="[CS:N]Bidoof[CR] non ha detto che voleva\naiutarci a catturare un ricercato?", spanish="[CS:N]Bidoof[CR] dijo que nos ayudaría\na elegir un malhechor, ¿no?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We should ask [CS:N]Bidoof[CR] first.", french=" Demandons d'abord à [CS:N]Keunotor[CR].", german="Wir sollten erst einmal [CS:N]Bidiza[CR]\nfragen.", italian="Dovremmo prima chiedere a\n[CS:N]Bidoof[CR].", spanish="¿Por qué no le preguntamos a\n[CS:N]Bidoof[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's ask [CS:N]Bidoof[CR] for his advice.", french=" Demandons d'abord à [CS:N]Keunotor[CR].", german=" Lass uns [CS:N]Bidiza[CR] um Rat bitten.", italian=" Chiediamo consiglio a [CS:N]Bidoof[CR].", spanish=" Vamos a preguntarle a [CS:N]Bidoof[CR]."})
  else
  SkySceneKit.say({english=" We should ask [CS:N]Bidoof[CR] first.", french=" Demandons d'abord à [CS:N]Keunotor[CR].", german="Wir sollten zuerst [CS:N]Bidiza[CR]\nfragen.", italian="Dovremmo prima chiedere a\n[CS:N]Bidoof[CR].", spanish="Deberíamos preguntarle a\n[CS:N]Bidoof[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- switch(message_Menu(MENU_OUTLAW_BOARD)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  end
end
