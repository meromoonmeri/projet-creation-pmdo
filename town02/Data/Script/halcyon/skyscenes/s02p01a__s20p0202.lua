-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S02P01A/s20p0202.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_S02P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_WELCOME_TO_THE_WORLD_OF_POKEMON non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(60)
  GAME:WaitFrames(60)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="......", french="......", german="......", italian="......", spanish="..."})
  else
  SkySceneKit.say({english="......", french="......", german="......", italian="......", spanish="..."})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="............", french="............", german="............", italian="............", spanish="... ..."})
  else
  SkySceneKit.say({english="............", french="............", german="............", italian="............", spanish="... ..."})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="..................", french="..................", german="..................", italian="..................", spanish="... ... ..."})
  else
  SkySceneKit.say({english="..................", french="..................", german="..................", italian="..................", spanish="... ... ..."})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="This...", french="C'est...", german="Ist das...", italian="Questo...", spanish="Esto..."})
  else
  SkySceneKit.say({english="This...", french="C'est...", german="Ist das...", italian="Questo...", spanish="Esto..."})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="Is this...[K] Is this a dream...?", french="Est-ce que...[K] je rêve...?", german="Ist das...[K] Ist das ein Traum?", italian="Che questo...[K] sia un sogno...?", spanish="Es esto...[K] ¿un sueño?"})
  else
  SkySceneKit.say({english="Is this...[K] Is this a dream...?", french="Est-ce que...[K] je rêve...?", german="Ist das...[K] Ist das ein Traum?", italian="Che questo...[K] sia un sogno...?", spanish="Es esto...[K] ¿un sueño?"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="...Oh?[K] There's someone here.", french="... Oh![K] Il y a quelqu'un ici.", german="...Oh?[K] Da ist jemand hier.", italian="... Oh?[K] C'è qualcuno.", spanish="¿Eh?[K] Hay alguien ahí."})
  else
  SkySceneKit.say({english="...Oh?[K] There's someone here.", french="... Oh![K] Il y a quelqu'un ici.", german="...Oh?[K] Da ist jemand hier.", italian="... Oh?[K] C'è qualcuno.", spanish="¿Eh?[K] Hay alguien ahí."})
  end
  -- message_Close
  GAME:WaitFrames(60)
  -- GAP: se_Play(6922) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  local npc_npc_kureseria = SkySceneKit.spawn_npc("cresselia", 184, 104, Direction.Down, "NPC_KURESERIA")
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(80)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="Who is it...?", french="Qui es-tu...?", german="Wer ist das?", italian="Chi è?", spanish="¿Quién es?"})
  else
  SkySceneKit.say({english="Who is it...?", french="Qui es-tu...?", german="Wer ist das?", italian="Chi è?", spanish="¿Quién es?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...[K]I am...", french=" ...[K] Je suis...", german=" ...[K]Ich bin...", italian=" ...[K] Sono...", spanish=" Soy...[K] Soy..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I am [CS:N]Cresselia[CR].", french=" ... Je m'appelle [CS:N]Cresselia[CR].", german=" Ich bin [CS:N]Cresselia[CR].", italian=" Sono [CS:N]Cresselia[CR].", spanish=" Soy [CS:N]Cresselia[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[CS:N]C-Cresselia[CR]...?!", french="[CS:N]C-Cresselia[CR]...?!", german="[CS:N]C-Cresselia[CR]?!?", italian="[CS:N]C-Cresselia[CR]...?!", spanish="¡¿[CS:N]Cresselia[CR]?!"})
  else
  SkySceneKit.say({english="[CS:N]C-Cresselia[CR]...?!", french="[CS:N]C-Cresselia[CR]...?!", german="[CS:N]C-Cresselia[CR]?!?", italian="[CS:N]C-Cresselia[CR]...?!", spanish="¡¿[CS:N]Cresselia[CR]?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Your...[K]your very existence is...", french=" Ta...[K] ta simple existence...", german=" Deine...[K] bloße Existenz...", italian=" La tua...[K] La tua esistenza sta...", spanish=" Tu...[K] Tu mera existencia..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" pushing the world toward ruin.", french="... va mener le monde à sa\nperte.", german=" Sie treibt die Welt in den Ruin.", italian="... spingendo il mondo verso il\nbaratro.", spanish=" Está acabando con el mundo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="The world...[K]to ruin?[K] How am I doing that?!", french="Le monde...[K] à sa perte?[K] Comment ça?!", german="Die Welt...[K] in den Ruin?[K]\nWie sollte ich das tun?", italian="Il mondo...[K] verso il baratro?[K]\nCom'è possibile?!", spanish="Acabando...[K] ¿con el mundo?[K] ¡¿Pero por qué?!"})
  else
  SkySceneKit.say({english="The world...[K]to ruin?[K] How am I doing that?!", french="Le monde...[K] à sa perte?[K] Comment ça?!", german="Die Welt...[K] in den Ruin?[K]\nWie sollte ich das tun?", italian="Il mondo...[K] verso il baratro?[K]\nCom'è possibile?!", spanish="Acabando...[K] ¿con el mundo?[K] ¡¿Pero por qué?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Because you are in this world.", french="Simplement parce que tu es\ndans ce monde.", german=" Indem du in dieser Welt bist.", italian="Dipende dal fatto che\ntu ti trovi in questo mondo.", spanish="Porque estás aquí, en este\nmundo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 5) -- screen_WhiteOutAll
  GAME:WaitFrames(2)
  GAME:FadeIn(5)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Because you...[K]exist here...", french=" Parce que...[K] tu existes ici...", german=" Weil du hier...[K] existierst...", italian="A causa del fatto che...[K]\nesisti qui...", spanish=" Porque...[K] existes..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" If you remain...", french=" Si tu restes...", german=" Bleibst du bestehen...", italian=" Se rimani...", spanish=" Si te quedas..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 5) -- screen_WhiteOutAll
  GAME:WaitFrames(2)
  GAME:FadeIn(5)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" The world will be destroyed!", french=" ... le monde sera détruit!", german=" So wird die Welt zerstört!", italian="Se rimani, il mondo verrà\ndistrutto!", spanish=" El mundo será destruido."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 5) -- screen_WhiteOutAll
  GAME:WaitFrames(2)
  GAME:FadeIn(5)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 5) -- screen_WhiteOutAll
  GAME:WaitFrames(2)
  GAME:FadeIn(5)
  GAME:WaitFrames(15)
  -- GAP: se_Play(6403) — id SE NDS sans portage PMDO identifié
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="Waaaah!", french="Ouaaah!", german="Aaaaah!", italian="Waaaah!", spanish="¡Aaaaah!"})
  else
  SkySceneKit.say({english="Waaaah!", french="Ouaaah!", german="Aaaaah!", italian="Waaaah!", spanish="¡Aaaaah!"})
  end
  GAME:FadeOut(true, 30) -- screen_WhiteOutAll
  -- message_CloseEnforce
  GAME:FadeOut(true, 0) -- screen_WhiteOut
  GAME:FadeIn(0)
  SkySceneKit.cleanup_npcs()
end
