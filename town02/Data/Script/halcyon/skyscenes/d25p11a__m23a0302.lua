-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D25P11A/m23a0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh! We blew that attempt.", french=" Argh! Ça s'est mal terminé.", german=" Uff! Das war nichts.", italian=" Uff! Abbiamo fallito.", spanish=" ¡Ay! ¡Qué mal ha salido!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh! We couldn't break through.", french=" Argh! Ça s'est mal terminé.", german=" Uff! Wir kamen nicht durch.", italian=" Uff! Non ce l'abbiamo fatta.", spanish=" ¡Vaya! No hemos logrado pasar."})
  else
  SkySceneKit.say({english=" Ugh! That wasn't so good.", french=" Argh! Ça s'est mal terminé.", german=" Uff! Das war nicht so gut.", italian=" Uff! Non è andata bene.", spanish=" ¡Ay! Vaya faena."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D25P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_D25P11A, 'UM23') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 256, 192, Direction.Down, "NPC_PERAPPU")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 288, 224, Direction.UpLeft, "NPC_BIPPA")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 248, 256, Direction.Up, "NPC_DIGUDA")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 312, 248, Direction.UpLeft, "NPC_DAGUTORIO")
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Brine Cave.ogg", true) end)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh! This is pretty rough going.", french=" Argh! Ça n'est pas évident.", german=" Uff! Ziemlich raue Gangart.", italian=" Oh! È piuttosto impegnativo.", spanish=" ¡Pero qué difícil!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh! This is pretty difficult.", french=" Argh! Ça n'est pas évident.", german=" Uff! Das ist recht schwierig.", italian=" Oh! È piuttosto difficile.", spanish=" Esto no es tan sencillo..."})
  else
  SkySceneKit.say({english=" Ugh! This is kind of rough.", french=" Argh! Ça n'est pas évident.", german=" Uff! Das ist echt brutal.", italian=" Oh! È piuttosto impegnativo.", spanish=" Esto no es nada fácil."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But I'm worried about [CS:N]Chatot[CR].[K]\nWe can't waste any time.", french="Mais je m'inquiète pour [CS:N]Pijako[CR].[K]\nPas de temps à perdre.", german="Aber ich mache mir Sorgen um\n[CS:N]Plaudagei[CR].[K] Wir dürfen keine Zeit verlieren.", italian="Ma sono preoccupato per\n[CS:N]Chatot[CR].[K] Non possiamo perdere tempo.", spanish="Pero me preocupa [CS:N]Chatot[CR].[K]\nNo podemos perder el tiempo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But I'm worried about [CS:N]Chatot[CR].[K]\nWe have to hurry.", french="Mais je m'inquiète pour [CS:N]Pijako[CR].[K]\nPas de temps à perdre.", german="Aber ich mache mir Sorgen um\n[CS:N]Plaudagei[CR].[K] Wir müssen uns beeilen.", italian="Ma sono preoccupato per\n[CS:N]Chatot[CR].[K] Non possiamo perdere tempo.", spanish="Pero me preocupa [CS:N]Chatot[CR].[K]\nHay que darse prisa."})
  else
  SkySceneKit.say({english="But I'm worried about [CS:N]Chatot[CR].[K]\nWe've got to hurry.", french="Mais je m'inquiète pour [CS:N]Pijako[CR].[K]\nPas de temps à perdre.", german="Aber ich mache mir Sorgen um\n[CS:N]Plaudagei[CR].[K] Für uns ist Eile geboten.", italian="Ma sono preoccupata per\n[CS:N]Chatot[CR].[K] Non possiamo perdere tempo.", spanish="Pero me preocupa [CS:N]Chatot[CR].[K]\nHay que darse prisa."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" There's no giving up!", french=" On ne peut pas baisser les bras!", german=" Aufgegeben wird nicht!", italian=" Non possiamo mollare!", spanish=" ¡No podemos rendirnos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" There's no giving up!", french=" On ne peut pas baisser les bras!", german=" Aufgegeben wird nicht!", italian=" Non possiamo mollare!", spanish=" ¡No podemos rendirnos!"})
  else
  SkySceneKit.say({english=" There's no giving up!", french=" On ne peut pas baisser les bras!", german=" Aufgegeben wird nicht!", italian=" Non possiamo mollare!", spanish=" ¡No podemos rendirnos!"})
  end
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
