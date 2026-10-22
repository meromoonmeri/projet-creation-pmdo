-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D06P11A/m08a0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 392, 256, Direction.DownLeft, "NPC_BIPPA")
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Oof... By gosh, we couldn't get\nthrough there...", french="Ouf... Sapristi, on s'est plantés\nen beauté...", german="Uff... Donnerwetter, wir sind\nnicht durchgekommen...", italian="Uff... Ohibò, non siamo riusciti a\npassare...", spanish=" Ay... No hemos podido pasar."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D06P11A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_D06P11A, 'UM08') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Craggy Coast.ogg", true) end)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(9) -- Unlock(9) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GROUND:EntTurn(npc_npc_bippa, Direction.Left)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I think we got cocky and\ncareless.", french="On a dû être un peu trop\nimprudents.", german="Ich glaube, wir haben uns\nüberschätzt und sind leichtsinnig geworden.", italian="Siamo stati troppo sicuri\ne spericolati.", spanish="Creo que nos hemos\nconfiado más de la cuenta."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I guess we got a little careless.", french="On a dû être un peu trop\nimprudents.", german="Ich glaube, wir waren etwas zu\nleichtsinnig.", italian="Siamo stati troppo sicuri\ne spericolati.", spanish=" Creo que nos hemos confiado."})
  else
  SkySceneKit.say({english=" Maybe we got a little careless.", french="On a dû être un peu trop\nimprudents.", german="Vielleicht waren wir etwas zu\nleichtsinnig.", italian="Siamo stati troppo sicuri\ne spericolati.", spanish=" Supongo que nos hemos confiado."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="It's because I'm not pulling my\nown weight here, isn't it...", french="C'est pasque j'ai pas fait mon\ntravail comme il faut, pour sûr...", german="Es liegt daran, dass ich euch\nzur Last falle, oder?", italian="È perché non mi sono impegnato\na sufficienza, vero?", spanish="Supongo que es porque yo no\nestoy a la altura..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="No, [CS:N]Bidoof[CR], it's not your fault.\nWe're a team, and that's what's important.", french="Mais non, [CS:N]Keunotor[CR], ce n'est pas\nta faute. Nous sommes une équipe et c'est ça\nqui compte.", german="Nein, [CS:N]Bidiza[CR], es liegt nicht an\ndir. Wir sind ein Team und das ist, was zählt.", italian="No, [CS:N]Bidoof[CR], non è colpa tua.\nSiamo una squadra ed è questo che conta.", spanish="No, [CS:N]Bidoof[CR], no es culpa tuya.\nSomos un equipo hasta el final."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="No, [CS:N]Bidoof[CR], it's not your fault.\nWe're a team, and that's what's important.", french="Mais non, [CS:N]Keunotor[CR], ce n'est pas\nta faute. Nous sommes une équipe et c'est ça\nqui compte.", german="Nein, [CS:N]Bidiza[CR], es liegt nicht an\ndir. Wir sind ein Team und das ist, was zählt.", italian="No, [CS:N]Bidoof[CR], non è colpa tua.\nSiamo una squadra ed è questo che conta.", spanish="No, [CS:N]Bidoof[CR], no es culpa tuya.\nSomos un equipo hasta el final."})
  else
  SkySceneKit.say({english="No, [CS:N]Bidoof[CR], it's not your fault.\nWe're a team, and that's what's important.", french="Mais non, [CS:N]Keunotor[CR], ce n'est pas\nta faute. Nous sommes une équipe et c'est ça\nqui compte.", german="Nein, [CS:N]Bidiza[CR], es liegt nicht an\ndir. Wir sind ein Team und das ist, was zählt.", italian="No, [CS:N]Bidoof[CR], non è colpa tua.\nSiamo una squadra ed è questo che conta.", spanish="No, [CS:N]Bidoof[CR], no es culpa tuya.\nSomos un equipo hasta el final."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We need to hurry so we can\nmeet up with the others at the base camp.", french="Nous devons nous dépêcher de\nrejoindre les autres au camp de base.", german="Wir müssen uns beeilen,\num die anderen am Basislager zu treffen.", italian="Dobbiamo affrettarci per\nincontrare gli altri al Campo Base.", spanish="Hay que darse prisa\npara encontrarnos con los demás\nen el campamento base."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We should hurry so we can\nlink up with the others at the base camp.", french="Nous devons nous dépêcher de\nrejoindre les autres au camp de base.", german="Wir sollten uns beeilen, damit\nwir die anderen am Basislager treffen können.", italian="Dobbiamo affrettarci per\nincontrare gli altri al Campo Base.", spanish="Debemos apresurarnos para\nreunirnos con los demás en el campamento\nbase."})
  else
  SkySceneKit.say({english="Let's hurry so we can join the\nothers at the base camp.", french="Nous devons nous dépêcher de\nrejoindre les autres au camp de base.", german="Beeilen wir uns, damit wir die\nanderen am Basislager treffen können.", italian="Dobbiamo affrettarci per\nincontrare gli altri al Campo Base.", spanish="Démonos prisa para reunirnos\ncon los demás en el campamento base."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's get it done!", french=" Finissons-en!", german=" Wir schaffen das!", italian=" Forza!", spanish=" ¡A por ello!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's get it done!", french=" Finissons-en!", german=" Wir schaffen das!", italian=" Forza!", spanish=" ¡Venga, vamos!"})
  else
  SkySceneKit.say({english=" Let's get it done!", french=" Finissons-en!", german=" Wir schaffen das!", italian=" Forza!", spanish=" ¡Adelante!"})
  end
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
