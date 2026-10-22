-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V24P02A/m24a0202.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- bgm2_PlayFadeIn(BGM_OCEAN1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- back_SetGround(LEVEL_V24P02A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 208, 176, Direction.UpLeft, "NPC_JUPUTORU")
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [CS:N]Lapras[CR].", french=" Dis, [CS:N]Lokhlass[CR].", german=" Hey, [CS:N]Lapras[CR].", italian=" Ehi, [CS:N]Lapras[CR].", spanish=" Oye, [CS:N]Lapras[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey, [CS:N]Lapras[CR].", french=" Dis, [CS:N]Lokhlass[CR].", german=" Hey, [CS:N]Lapras[CR].", italian=" Ehi, [CS:N]Lapras[CR].", spanish=" Oye, [CS:N]Lapras[CR]..."})
  else
  SkySceneKit.say({english=" Say, [CS:N]Lapras[CR].", french=" Dis, [CS:N]Lokhlass[CR].", german=" Sag mal, [CS:N]Lapras[CR].", italian=" Senti, [CS:N]Lapras[CR].", spanish=" Oye, [CS:N]Lapras[CR]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker("Lapras", true, "lapras", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_RAPURASU) voix hors champ (espèce ROM)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Yes?", french=" Oui?", german=" Ja?", italian=" Sì?", spanish=" ¿Sí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You've been swimming a long\ntime. Are you doing OK?", french="Ça fait un moment que tu nages.\nÇa va aller?", german="Du schwimmst schon seit einiger\nZeit. Geht es dir gut?", italian="Stai nuotando da tanto tempo.\nVa tutto bene?", spanish="Llevas mucho tiempo nadando.\n¿Cómo vas?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You've been swimming a long\ntime. Are you doing OK?", french="Ça fait un moment que tu nages.\nÇa va aller?", german="Du schwimmst schon seit einiger\nZeit. Geht es dir gut?", italian="Stai nuotando da tanto tempo.\nVa tutto bene?", spanish="Llevas mucho tiempo nadando.\n¿Cómo vas?"})
  else
  SkySceneKit.say({english="You've been swimming a long\ntime. Are you doing OK?", french="Ça fait un moment que tu nages.\nÇa va aller?", german="Du schwimmst schon seit einiger\nZeit. Geht es dir gut?", italian="Stai nuotando da tanto tempo.\nSei stanco?", spanish="Llevas mucho tiempo nadando.\n¿Cómo vas?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Lapras", true, "lapras", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_RAPURASU) voix hors champ (espèce ROM)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" I'm fine, [partner].", french=" Tout va bien, [partner].", german=" Ja, kein Problem, [partner].", italian=" Sto bene, [partner].", spanish=" No te preocupes, [partner]."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="No need for concern.[K] Because\nwe're almost there.", french="Pas d'inquiétude à avoir.[K]\nNous y sommes presque.", german="Kein Grund zur Sorge.[K] Wir sind\nnämlich gleich da.", italian="Non preoccuparti.[K] Ci siamo\nquasi.", spanish="Estoy bien...[K]\nYa casi hemos llegado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(1) [anim idle native]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" See![K] It's coming into view!", french=" Regardez![K] Terre en vue!", german=" Da![K] Man kann es schon sehen!", italian=" Guarda![K] Si inizia a intravedere!", spanish=" ¡Mirad![K] ¡Ya casi se puede ver!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?", french=" Quoi?", german=" Wo?", italian=" Eh?", spanish=" ¿Qué?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?", french=" Quoi?", german=" Wo?", italian=" Cosa?", spanish=" ¿Qué?"})
  else
  SkySceneKit.say({english=" What?", french=" Quoi?", german=" Wo?", italian=" Cosa?", spanish=" ¿Qué?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Lapras", true, "lapras", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_RAPURASU) voix hors champ (espèce ROM)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="On the far horizon. Do you see\nwhere the sea looks a little different?", french="Là-bas, à l'horizon! Vous voyez\nl'endroit où la mer semble un peu différente?", german="Am fernen Horizont. Seht ihr?\nDa, wo das Meer ein bisschen anders aussieht?", italian="All'orizzonte. Vedete dove il\nmare sembra un po' diverso?", spanish="En el horizonte, allí delante.\n¿Veis ese lugar donde el mar parece\ncambiar ligeramente?"})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
