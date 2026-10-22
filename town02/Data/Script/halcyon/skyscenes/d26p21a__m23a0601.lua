-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D26P21A/m23a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk! That was no good!", french=" Argh! Quel échec!", german=" Umpf! Das war nicht gut!", italian=" Uff! È andata male!", spanish=" ¡Qué desastre!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk! We didn't do so well!", french=" Argh! Quel échec!", german=" Umpf! Das lief nicht gut!", italian=" Uh! Non è andata molto bene!", spanish=" ¡No damos una!"})
  else
  SkySceneKit.say({english=" Urk! That wasn't so good.", french=" Argh! Quel échec!", german=" Umpf! Das war nicht so gut.", italian=" Uff! È andata male!", spanish=" ¡Tenemos que hacerlo mejor!"})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D26P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitLockLives
  GAME:FadeIn(30)
  -- GAP: BGM BGM_LOWER_BRINE_CAVE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
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
  SkySceneKit.say({english=" Ugh! This is pretty rough.", french=" Argh! Ça se corse.", german=" Uff! Das ist echt brutal.", italian=" Uh! È piuttosto dura.", spanish=" Esto es muy complicado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh! This is pretty difficult!", french=" Argh! Ça se corse.", german=" Uff! Das ist echt schwierig!", italian=" Uh! È piuttosto difficile.", spanish=" Esto resulta muy difícil."})
  else
  SkySceneKit.say({english=" Ugh! This is kind of rough!", french=" Argh! Ça se corse.", german=" Uff! Das ist ganz schön rau!", italian=" Uh! È piuttosto difficile.", spanish=" Esto no es nada fácil."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But I'm worried about [CS:N]Chatot[CR].\nWe can't waste any time.", french="Mais je me fais un sang d'encre\npour [CS:N]Pijako[CR]. Il n'y a pas une minute à perdre.", german="Aber ich mache mir Sorgen um\n[CS:N]Plaudagei[CR]. Wir dürfen keine Zeit verlieren.", italian="Ma sono preoccupato per [CS:N]Chatot[CR].\nNon possiamo perdere tempo.", spanish="Pero me preocupa [CS:N]Chatot[CR].\nNo podemos perder el tiempo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But I'm worried about [CS:N]Chatot[CR].\nWe have to hurry.", french="Mais je me fais un sang d'encre\npour [CS:N]Pijako[CR]. Il n'y a pas une minute à perdre.", german="Aber ich mache mir Sorgen um\n[CS:N]Plaudagei[CR]. Wir müssen uns beeilen.", italian="Ma sono preoccupato per [CS:N]Chatot[CR].\nDobbiamo sbrigarci.", spanish="Pero me preocupa [CS:N]Chatot[CR].\nNo podemos perder el tiempo."})
  else
  SkySceneKit.say({english="But I'm worried about [CS:N]Chatot[CR].\nWe've got to hurry.", french="Mais je me fais un sang d'encre\npour [CS:N]Pijako[CR]. Il n'y a pas une minute à perdre.", german="Aber ich mache mir Sorgen um\n[CS:N]Plaudagei[CR]. Jetzt ist Eile geboten.", italian="Ma sono preoccupata per [CS:N]Chatot[CR].\nDobbiamo sbrigarci.", spanish="Pero me preocupa [CS:N]Chatot[CR].\nNo podemos perder el tiempo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" There's no giving up!", french=" On ne peut pas baisser les bras!", german=" Aufgegeben wird nicht!", italian=" Diamoci dentro!", spanish=" ¡No podemos rendirnos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" There's no giving up!", french=" On ne peut pas baisser les bras!", german=" Aufgegeben wird nicht!", italian=" Diamoci dentro!", spanish=" ¡No podemos rendirnos!"})
  else
  SkySceneKit.say({english=" There's no giving up!", french=" On ne peut pas baisser les bras!", german=" Aufgegeben wird nicht!", italian=" Diamoci dentro!", spanish=" ¡No podemos rendirnos!"})
  end
  -- message_Close
end
