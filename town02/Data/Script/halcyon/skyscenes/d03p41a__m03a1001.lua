-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D03P41A/m03a1001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(4, 7) -- $SCENARIO_MAIN = scn[4,7] (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.REQUEST_CLEAR_COUNT = 0 -- $REQUEST_CLEAR_COUNT = 0 (ROM)
  -- back_SetGround(LEVEL_D03P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_suriipu = SkySceneKit.spawn_npc("drowzee", 352, 256, Direction.Down, "NPC_SURIIPU")
  -- SetAnimation(14) [anim idle native]
  local npc_npc_ruriri = SkySceneKit.spawn_npc("azurill", 352, 152, Direction.Down, "NPC_RURIRI")
  -- SetAnimation(9) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Rrrrawrrr!", french=" Aaaaargh!", german=" Rrrrooaarrr!", italian=" Rrrrawrrr!", spanish=" ¡Grr!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6417) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_suriipu, "shock", 1) end)
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(90)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GAME:MoveCamera(348, 164, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 368, 180, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(partner, 328, 180, false, 2)
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "exclaim", 1) end)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We came to rescue you.", french=" On vient pour te sauver.", german="Wir sind gekommen, um dich zu\nretten.", italian=" Siamo qui per salvarti.", spanish=" Hemos venido a rescatarte."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We came to rescue you.", french=" On vient pour te sauver.", german="Wir sind gekommen, um dich zu\nretten.", italian=" Siamo qui per salvarti.", spanish=" Hemos venido a rescatarte."})
  else
  SkySceneKit.say({english=" We're here to rescue you.", french=" On vient pour te sauver.", german="Wir sind gekommen, um dich zu\nretten.", italian=" Siamo qui per salvarti.", spanish=" Hemos venido a rescatarte."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Are you all right? You're not\nhurt, are you?", french="Tout va bien? Tu n'es pas\nblessé?", german="Alles okay? Du bist nicht\nverletzt, oder?", italian=" Stai bene? Non sei ferito, vero?", spanish="¿Estás bien? ¿Te ha hecho\ndaño?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Are you all right? You're not\nhurt, are you?", french="Tout va bien? Tu n'es pas\nblessé?", german="Bist du in Ordnung? Du bist nicht\nverletzt, oder?", italian=" Stai bene? Non sei ferito, vero?", spanish=" ¿Estás bien? ¿Estás herido?"})
  else
  SkySceneKit.say({english="Are you OK? You're not hurt,\nare you?", french="Tout va bien? Tu n'es pas\nblessé?", german="Alles in Ordnung? Du bist nicht\nverletzt, oder?", italian=" Stai bene? Non sei ferito, vero?", spanish="¿Estás bien? No te ha\nhecho daño, ¿no?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" I'm OK.", french=" Ça va.", german=" Es geht mir gut.", italian=" Sto bene.", spanish=" Estoy bien."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Awesome! That's a big relief!", french=" Tant mieux! Quel soulagement!", german="Wie schön! Da sind wir\nerleichtert!", italian=" Meno male! Che sollievo!", spanish=" ¡Genial! ¡Qué alivio!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Great! What a relief!", french=" Tant mieux! Quel soulagement!", german=" Gut! Da sind wir erleichtert!", italian=" Meno male! Che sollievo!", spanish=" ¡Estupendo! ¡Qué alivio!"})
  else
  SkySceneKit.say({english=" Great! What a relief!", french=" Tant mieux! Quel soulagement!", german=" Gut! Da sind wir erleichtert!", italian=" Meno male! Che sollievo!", spanish=" ¡Menos mal! ¡Qué alivio!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Your big brother's waiting.\nLet's get you home!", french="Ton grand frère t'attend.\nRentrons à la maison!", german="Dein großer Bruder wartet auf\ndich. Gehen wir nach Hause!", italian="Tuo fratello ci aspetta.\nAndiamo a casa!", spanish="Tu hermano mayor te espera.\n¡Volvamos a casa!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Your big brother is waiting.\nLet's go home!", french="Ton grand frère t'attend.\nRentrons à la maison!", german="Dein großer Bruder wartet auf\ndich. Gehen wir nach Hause!", italian="Tuo fratello ci aspetta.\nAndiamo a casa!", spanish="Tu hermano mayor te espera.\n¡Volvamos a casa!"})
  else
  SkySceneKit.say({english="Your big brother's waiting.\nLet's go home!", french="Ton grand frère t'attend.\nRentrons à la maison!", german="Dein großer Bruder wartet auf\ndich. Gehen wir nach Hause!", italian="Tuo fratello ci aspetta.\nAndiamo a casa!", spanish="Tu hermano mayor te espera.\n¡Volvamos a casa!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" OK.", french=" D'accord.", german=" Okay.", italian=" Ok.", spanish=" Vale."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  SkySceneKit.cleanup_npcs()
end
