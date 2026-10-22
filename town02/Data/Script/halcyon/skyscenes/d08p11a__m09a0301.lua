-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D08P11A/m09a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  SkyProg.set(10, 3) -- $SCENARIO_MAIN = scn[10,3] (ROM)
  -- back_SetGround(LEVEL_D08P11A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_D08P11A, 'UM09') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 304, 520, Direction.Up, "NPC_PERAPPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Foggy Forest.ogg", true) end)
  GROUND:MoveToPosition(partner, 280, 388, false, 2)
  GROUND:MoveToPosition(hero, 320, 388, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? This is...", french=" Hein? Mais c'est...", german=" Äh? Das ist...", italian=" Eh? Questo è...", spanish=" ¿Qué...? Esto es..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What? This is...", french=" Hein? Mais c'est...", german=" Was? Das ist...", italian=" Cosa? Questo è...", spanish=" ¿Qué...? Esto es..."})
  else
  SkySceneKit.say({english=" What? This is...", french=" Hein? Mais c'est...", german=" Was? Das ist...", italian=" Cosa? Questo è...", spanish=" ¿Qué...? Esto es..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:MoveToPosition(npc_npc_perappu, 300, 428, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Welcome back! ♪", french=" Ah, vous revoilà! ♪", german=" Willkommen zurück! ♪", italian=" Ah, siete di ritorno! ♪", spanish=" Vaya, ya estáis de vuelta. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But this is the base camp!", french=" Mais c'est le camp de base!", german=" Das ist ja das Basislager!", italian=" Ma questo è il Campo Base!", spanish="¡Pero si esto es el campamento\nbase!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But this is the base camp!", french=" Mais c'est le camp de base!", german=" Das ist ja das Basislager!", italian=" Ma questo è il Campo Base!", spanish="¡Pero si esto es el campamento\nbase!"})
  else
  SkySceneKit.say({english=" But this is the base camp!", french=" Mais c'est le camp de base!", german=" Das ist ja das Basislager!", italian=" Ma questo è il Campo Base!", spanish="¡Pero si esto es el campamento\nbase!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Precisely! ♪ You're back at the\nbase camp! ♪", french="Exactement! ♪ Vous êtes de\nretour au camp de base! ♪", german="Genau! ♪ Ihr seid wieder\nam Basislager! ♪", italian="Esatto! ♪ Avete fatto ritorno\nal Campo Base! ♪", spanish="Exacto. ♪ ¡Habéis regresado\nal campamento base! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="So how did it go? Have you\nanything to report?", french="Comment ça s'est passé?\nVous avez quelque chose à signaler?", german="Wie lief es? Habt ihr etwas zu\nberichten?", italian="Allora, come è andata? Avete\nqualcosa da segnalare?", spanish="Entonces, ¿qué tal ha ido?\n¿Tenéis algo de lo que informarme?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Uh... No, nothing.", french=" Euh... non, rien.", german=" Äh... Nein, nichts.", italian=" Eh... No, niente.", spanish=" Esto... No, nada."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Uh... No, nothing.", french=" Euh... non, rien.", german=" Äh... Nein, nichts.", italian=" Eh... No, niente.", spanish=" Esto... No, nada."})
  else
  SkySceneKit.say({english=" Uh... No, nothing.", french=" Euh... non, rien.", german=" Äh... Nein, nichts.", italian=" Eh... No, niente.", spanish=" Esto... No, nada."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Oh?! Nothing?!", french=" Comment?! Rien du tout?!", german=" Oh?!? Nichts?!?", italian=" Oh?! Niente?!", spanish=" ¿Y eso? ¿Nada de nada?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="What is this?! You had my\nhopes up!", french="Mais qu'est-ce que ça veut\ndire? En voilà une déception!", german="Was soll das?!? Ihr habt mir\nHoffnungen gemacht!", italian="Com'è possibile?! Speravo\nche avreste trovato qualcosa!", spanish="Vaya, ¡y yo que me estaba\nhaciendo ilusiones!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Get going!", french=" Repartez immédiatement!", german=" Geht!", italian=" Datevi una mossa!", spanish=" ¡Seguid explorando!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Gulp... Let's get going,\n[hero].", french="Gloups... Allons-y,\n[hero].", german="Schluck... Gehen wir,\n[hero].", italian="Gulp... Andiamo,\n[hero].", spanish=" Glup... Vamos allá, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Gulp... Let's get going,\n[hero].", french="Gloups... Allons-y,\n[hero].", german="Schluck... Gehen wir,\n[hero].", italian="Gulp... Andiamo,\n[hero].", spanish=" Glup... Vamos allá, [hero]."})
  else
  SkySceneKit.say({english="Gulp... Let's get going,\n[hero].", french="Gloups... Allons-y,\n[hero].", german="Schluck... Gehen wir,\n[hero].", italian="Gulp... Andiamo,\n[hero].", spanish=" Glup... Vamos allá, [hero]."})
  end
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
