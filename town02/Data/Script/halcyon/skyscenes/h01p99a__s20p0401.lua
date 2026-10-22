-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99A/s20p0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_H01P99A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 472, 192, Direction.Left, "NPC_BIPPA")
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end) -- message_SetActor(ACTOR_NPC_BIPPA)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Hello! Hold up![K] There's big\ntrouble, by golly!", french="Hep! Attendez![K] Y'a\nun gros problème, sapristi!", german="Hallo! Wartet mal![K]\nEs gibt großen Ärger, Menschenskind!", italian="Ciao! Aspettate![K] Abbiamo un\nbel problema, ohibò!", spanish="¡Hola! ¡Esperad![K] ¡Tenemos\nproblemas! ¡Sí, señor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_bippa, 336, 188, false, 2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(16), p.Y+(0), false, 2) end
  GAME:WaitFrames(15)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(16), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I'm glad I caught you![K] I reckoned\nyou were about ready to go out for the day.\nHuff-puff...", french="J'suis hyper content, j'suis pas\narrivé trop tard![K] J'étais sûr qu'vous alliez\npartir pour la journée. Pff, pff...", german="Ich bin froh, euch noch erwischt\nzu haben![K] Ich schätze mal, ihr wolltet gerade\neurem Tagewerk nachgehen. Schnauf, keuch...", italian="Sono felice di avervi\nraggiunto![K] Pensavo di non trovarvi\npiù. Uff-uff...", spanish="¡Menos mal que os he\nencontrado![K] Supongo que estabais a\npunto de marcharos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What's up, [CS:N]Bidoof[CR]?[K] What's the\nbig hurry?", french="Qu'est-ce qu'il y a, [CS:N]Keunotor[CR]?[K]\nPourquoi tu es si pressé?", german="Was gibt es, [CS:N]Bidiza[CR]?[K] Warum\ndie große Eile?", italian="Cosa succede, [CS:N]Bidoof[CR]?[K] Come\nmai tanta fretta?", spanish="¿Qué pasa, [CS:N]Bidoof[CR]?[K] ¿A qué\ntanta prisa?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What's wrong, [CS:N]Bidoof[CR]?[K] Why are\nyou in such a hurry?", french="Qu'est-ce qu'il y a, [CS:N]Keunotor[CR]?[K]\nPourquoi tu es si pressé?", german="Was stimmt nicht, [CS:N]Bidiza[CR]?[K]\nWarum die große Eile?", italian="Cosa succede, [CS:N]Bidoof[CR]?[K] Come\nmai tanta fretta?", spanish="¿Qué pasa, [CS:N]Bidoof[CR]?[K] ¿A qué\ntanta prisa?"})
  else
  SkySceneKit.say({english="What's the matter, [CS:N]Bidoof[CR]?[K]\nWhat's the big hurry?", french="Qu'est-ce qu'il y a, [CS:N]Keunotor[CR]?[K]\nPourquoi tu es si pressé?", german="Was liegt an, [CS:N]Bidiza[CR]?[K] Warum\ndie große Eile?", italian="Cosa succede, [CS:N]Bidoof[CR]?[K] Come\nmai tanta fretta?", spanish="¿Qué pasa, [CS:N]Bidoof[CR]?[K] ¿A qué\ntanta prisa?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Th-there's trouble afoot!", french=" On... on a un problème!", german=" D-da ist Ärger im Anmarsch!", italian="C-Ci sono grossi problemi\nin vista!", spanish=" ¡Tenemos problemas!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Little [CS:N]Azurill[CR]...[K] The little\n[CS:N]Azurill[CR] is in trouble!", french="C'est le p'tit [CS:N]Azurill[CR]...[K] Le p'tit\n[CS:N]Azurill[CR], il a des ennuis!", german="Der kleine [CS:N]Azurill[CR]...[K] Der kleine\n[CS:N]Azurill[CR] ist in Schwierigkeiten!", italian="Il piccolo [CS:N]Azurill[CR]...[K] Il piccolo\n[CS:N]Azurill[CR] è nei guai!", spanish="[CS:N]Azurill[CR]...[K]\n¡[CS:N]Azurill[CR] está en apuros!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?[K] [CS:N]Azurill[CR] is in trouble?!", french=" Hein?[K] [CS:N]Azurill[CR] a des ennuis?!", german="Wie war das?[K] [CS:N]Azurill[CR] ist in\nSchwierigkeiten?!?", italian=" Eh?[K] [CS:N]Azurill[CR] è nei guai?!", spanish=" ¿Qué?[K] ¿[CS:N]Azurill[CR] en apuros?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?[K] [CS:N]Azurill[CR] is in trouble?!", french=" Hein?[K] [CS:N]Azurill[CR] a des ennuis?!", german="Was?[K] [CS:N]Azurill[CR] ist in\nSchwierigkeiten?!?", italian=" Eh?[K] [CS:N]Azurill[CR] è nei guai?!", spanish=" ¿Qué?[K] ¿[CS:N]Azurill[CR] en apuros?"})
  else
  SkySceneKit.say({english=" Pardon?[K] [CS:N]Azurill[CR] is in trouble?!", french=" Hein?[K] [CS:N]Azurill[CR] a des ennuis?!", german="Bitte?[K] [CS:N]Azurill[CR] ist in\nSchwierigkeiten?!?", italian=" Eh?[K] [CS:N]Azurill[CR] è nei guai?!", spanish=" ¿Cómo?[K] ¿[CS:N]Azurill[CR] en apuros?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="They brought the little feller to\nthe guild!", french="Le p'tit gars, il a été ramené\nà la Guilde!", german="Sie haben das kleine Kerlchen in\ndie Gilde gebracht!", italian=" Lo hanno portato alla Gilda!", spanish=" ¡Lo han llevado al [CS:N]Pokégremio[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We've got to hurry,\n[hero]!", french=" Dépêchons-nous, [hero]!", german="Wir müssen uns beeilen,\n[hero]!", italian="Dobbiamo sbrigarci,\n[hero]!", spanish=" ¡Deprisa, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's hurry, [hero]!", french=" Dépêchons-nous, [hero]!", german=" Beeilen wir uns, [hero]!", italian="Dobbiamo sbrigarci,\n[hero]!", spanish=" ¡Deprisa, [hero]!"})
  else
  SkySceneKit.say({english=" Let's hurry, [hero]!", french=" Dépêchons-nous, [hero]!", german=" Beeilen wir uns, [hero]!", italian="Dobbiamo sbrigarci,\n[hero]!", spanish=" ¡Deprisa, [hero]!"})
  end
  -- message_Close
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(120), p.Y+(0), false, 2) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(120), p.Y+(0), false, 2) end
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(120), p.Y+(0), false, 2) end
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
end
