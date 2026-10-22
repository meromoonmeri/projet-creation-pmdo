-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D25P11A/m23a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh! We didn't make it.", french=" Argh! On a échoué.", german=" Uff! Nicht geschafft.", italian=" Uff! Non ce l'abbiamo fatta.", spanish=" ¡Ay! Nos han dado la del pulpo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh! We didn't make it.", french=" Argh! On a échoué.", german=" Uff! Nicht geschafft.", italian=" Uff! Non ce l'abbiamo fatta.", spanish=" ¡Ay! Menuda zurra."})
  else
  SkySceneKit.say({english=" Ugh! That ended badly.", french=" Argh! On a échoué.", german=" Uff! Nicht geschafft.", italian=" Uff! È andata male.", spanish=" ¡Ay! Esto ha ido fatal."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D25P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_D25P11A, 'UM23') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 280, 248, Direction.Down, "NPC_PERAPPU")
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
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-where are we?", french=" Où... où sommes-nous?", german=" W-wo sind wir?", italian=" D-Dove siamo?", spanish=" ¿Pero dónde...?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-where are we?", french=" Où... où sommes-nous?", german=" W-wo sind wir?", italian=" D-Dove siamo?", spanish=" ¿Pero dónde...?"})
  else
  SkySceneKit.say({english=" Wh-where are we?", french=" Où... où sommes-nous?", german=" W-wo sind wir?", italian=" D-Dove siamo?", spanish=" ¿Pero dónde...?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" This is [CS:P]Brine Cave[CR]'s entrance.", french="Voici l'entrée de la [CS:P]Caverne\nSaline[CR].", german="Dies ist der Eingang zur\n[CS:P]Salzwasserhöhle[CR].", italian="Questo è l'ingresso della\n[CS:P]Grotta Salmastra[CR].", spanish="Esto es la entrada de\nla [CS:P]Cueva Aguamar[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" We got sent back.", french="Nous avons dû reculer...\npour mieux sauter.", german=" Wir wurden zurückgeschickt.", italian=" Ci hanno rispedito indietro.", spanish=" Hemos vuelto al principio."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But this is no time to feel sorry\nfor ourselves!", french="Mais ce n'est pas le moment de\nnous apitoyer sur notre sort!", german="Wir können jetzt nicht in\nSelbstmitleid versinken!", italian="Ma non c'è tempo per piangersi\naddosso!", spanish="¡Pero no es momento de\nlamentarse!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We'll get to the very depths of\nthis cave next time for certain!", french="La prochaine fois, nous\natteindrons les profondeurs de cette caverne!", german="Wir schaffen es nächstes Mal\nganz sicher bis zu den tiefsten Tiefen der\nHöhle!", italian="La prossima volta arriveremo\nsicuramente in fondo alla grotta!", spanish="¡Hay que llegar a lo más\nprofundo de esta cueva!"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
