-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D21P41A/m18b1101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(31, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  SkyProg.set(19, 4) -- $SCENARIO_MAIN = scn[19,4] (ROM)
  -- back_SetGround(LEVEL_D21P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 384, 200, Direction.Down, "NPC_JUPUTORU")
  -- SetAnimation(29) [anim idle native]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  -- GAP: BGM BGM_STATIC_NOISE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(partner, 296, 220, false, 2)
  GROUND:MoveToPosition(hero, 272, 244, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey![K] There's [CS:N]Grovyle[CR]!", french=" Eh![K] Voilà [CS:N]Massko[CR]!", german=" Hey![K] Da ist [CS:N]Reptain[CR]!", italian=" Ehi![K] C'è [CS:N]Grovyle[CR]!", spanish=" ¡Eh![K] ¡Ahí está [CS:N]Grovyle[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey![K] There's [CS:N]Grovyle[CR]!", french=" Eh![K] Voilà [CS:N]Massko[CR]!", german=" Hey![K] Da ist [CS:N]Reptain[CR]!", italian=" Ehi![K] C'è [CS:N]Grovyle[CR]!", spanish=" ¡Eh![K] ¡Ahí está [CS:N]Grovyle[CR]!"})
  else
  SkySceneKit.say({english=" Oh![K] There's [CS:N]Grovyle[CR]!", french=" Eh![K] Voilà [CS:N]Massko[CR]!", german=" Oh![K] Da ist [CS:N]Reptain[CR]!", italian=" Oh![K] C'è [CS:N]Grovyle[CR]!", spanish=" ¡Oh![K] ¡Ahí está [CS:N]Grovyle[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Urggh...[K] You two...", french=" Arggh...[K] Vous deux...", german=" Urggh...[K] Ihr beide...", italian=" Urggh...[K] Voi due...", spanish=" Aaah...[K] No os..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]G-Grovyle[CR]! Are you all right?!", french=" [CS:N]M-Massko[CR]! Ça va?!", german=" [CS:N]R-Reptain[CR]! Alles in Ordnung?!?", italian=" [CS:N]G-Grovyle[CR]! Stai bene?!", spanish=" ¡[CS:N]Grovyle[CR]! ¡¿Estás bien?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]G-Grovyle[CR]! Are you all right?!", french=" [CS:N]M-Massko[CR]! Ça va?!", german=" [CS:N]R-Reptain[CR]! Alles in Ordnung?!?", italian=" [CS:N]G-Grovyle[CR]! Stai bene?!", spanish=" ¡[CS:N]Grovyle[CR]! ¡¿Estás bien?!"})
  else
  SkySceneKit.say({english=" [CS:N]G-Grovyle[CR]! Are you OK?!", french=" [CS:N]M-Massko[CR]! Ça va?!", german=" [CS:N]R-Reptain[CR]! Alles in Ordnung?!?", italian=" [CS:N]G-Grovyle[CR]! Stai bene?!", spanish=" ¡[CS:N]Grovyle[CR]! ¡¿Estás bien?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(28), p.Y+(0), false, 2) end
  GAME:WaitFrames(5)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(24), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" S-stay back!", french=" A-arrière!", german=" K-kommt nicht näher!", italian=" S-State indietro!", spanish=" ¡No... no os acerquéis!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?[K] Wh-why?!", french=" Hein?[K] Mais pourquoi?!", german=" Aber...[K] W-warum?!?", italian=" Eh?[K] P-Perché?!", spanish=" ¿Eh?[K] ¡¿Pero por qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?[K] Wh-why?!", french=" Hein?[K] Mais pourquoi?!", german=" Was?[K] W-warum?!?", italian=" Cosa?[K] P-Perché?!", spanish=" ¿Eh?[K] ¡¿Pero por qué?!"})
  else
  SkySceneKit.say({english=" What?[K] Wh-why?!", french=" Hein?[K] Mais pourquoi?!", german=" Was?[K] W-warum?!?", italian=" Cosa?[K] P-Perché?!", spanish=" ¿Eh?[K] ¡¿Pero por qué?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Careful![K] An enemy lurks nearby!", french="Attention![K] Il y a un ennemi tapi\npas loin!", german="Vorsicht![K] Ein Feind lauert hier\nin der Nähe!", italian="Fate attenzione![K] C'è un nemico\nnascosto!", spanish="¡Cuidado![K]\n¡Hay un enemigo cerca!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?![K] Wh-where?", french=" Quoi?![K] Où ça?", german=" Was?!?[K] W-wo?", italian=" Cosa?![K] D-Dove?", spanish=" ¡¿Qué?![K] ¿Dónde?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?![K] Wh-where?", french=" Quoi?![K] Où ça?", german=" Was?!?[K] W-wo?", italian=" Cosa?![K] D-Dove?", spanish=" ¡¿Qué?![K] ¿Dónde?"})
  else
  SkySceneKit.say({english=" What?![K] Wh-where?", french=" Quoi?![K] Où ça?", german=" Was?!?[K] W-wo?", italian=" Cosa?![K] D-Dove?", spanish=" ¡¿Qué?![K] ¿Dónde?"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" It's right...[K]beside you!", french=" Juste...[K] à côté de toi!", german=" Er ist[K] direkt neben dir!", italian=" È proprio...[K] accanto a te!", spanish=" Está justo...[K] ¡a tu lado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Next to me...?", french=" A côté de moi...?", german=" Neben mir?", italian=" Accanto a me...?", spanish=" ¿A mi lado?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Next to me...?", french=" A côté de moi...?", german=" Neben mir?", italian=" Accanto a me...?", spanish=" ¿A mi lado?"})
  else
  SkySceneKit.say({english=" Next to me...?", french=" A côté de moi...?", german=" Neben mir?", italian=" Accanto a me...?", spanish=" ¿A mi lado?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It can't be this...", french=" Ce n'est pas ce...", german=" Er kann nicht...", italian=" Non può essere...", spanish=" No te referirás a esto..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It can't be this...", french=" Ce n'est pas ce...", german=" Er kann nicht...", italian=" Non può essere...", spanish=" No te referirás a esto..."})
  else
  SkySceneKit.say({english=" It can't be this...", french=" Ce n'est pas ce...", german=" Er kann nicht...", italian=" Non può essere...", spanish=" No te referirás a esto..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  -- GAP: se_Play(7426) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D21P41A2_64) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(15)
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(8), 3, false) end) -- MovePositionOffset performer/caméra
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(32), false, 2) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaah!", french=" Ouaaah!", german=" Waaah!", italian=" Aaaah!", spanish=" ¡Aaaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaah!", french=" Ouaaah!", german=" Waaah!", italian=" Aaaah!", spanish=" ¡Aaaah!"})
  else
  SkySceneKit.say({english=" Waaah!", french=" Ouaaah!", german=" Waaah!", italian=" Aaaah!", spanish=" ¡Aaaah!"})
  end
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  -- GAP: BGM BGM_PLANETS_PARALYSIS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  local npc_npc_mikaruge = SkySceneKit.spawn_npc("spiritomb", 328, 200, Direction.Down, "NPC_MIKARUGE")
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end) -- message_SetActor(ACTOR_NPC_MIKARUGE)
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english=" HEE-hee...HEE-hee...", french=" HEE hee... HEE hee...", german=" HEE-hee... HEE-hee...", italian=" EEH-eeh... EEH-eeh...", spanish=" ¡Ji, ji, ji...! ¡Ji, ji, ji...!"})
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english="All those who TRESPASS upon\nthis land...", french="De tous ceux qui PROFANENT\nces lieux...", german="Für jene, die diesen Boden\nUNERLAUBT betreten...", italian="Chiunque SCONFINI in questa\nterra...", spanish="Cualquier intruso que se adentre\naquí sin permiso..."})
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english=" None shall be FORGIVEN! None!", french=" Aucun ne sera PARDONNE! Aucun!", german="Für jene wird es keine\nVERGEBUNG geben! Niemals!", italian="... non sarà PERDONATO!\nNessuno!", spanish="¡Será castigado! ¡No perdonamos\nninguna intrusión!"})
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english=" Not least of all...YOU!", french=" Et surtout pas... VOUS!", german=" Am allerwenigsten für EUCH!", italian=" Nemmeno... VOI!", spanish=" Y menos aún... ¡la vuestra!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Who is that?![K] Who are you?!", french=" Qui va là?![K] Qui êtes-vous?!", german=" Wer ist das?!?[K] Wer bist du?!?", italian=" Chi c'è?![K] Chi siete?!", spanish=" ¡¿Qué es eso?![K] ¡¿Quién eres?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Who is that?![K] Who are you?!", french=" Qui va là?![K] Qui êtes-vous?!", german=" Wer ist das?!?[K] Wer bist du?!?", italian=" Chi c'è?![K] Chi siete?!", spanish=" ¡¿Qué es eso?![K] ¡¿Quién eres?!"})
  else
  SkySceneKit.say({english=" Who is that?![K] Who are you?!", french=" Qui va là?![K] Qui êtes-vous?!", german=" Wer ist das?!?[K] Wer bist du?!?", italian=" Chi c'è?![K] Chi siete?!", spanish=" ¡¿Qué es eso?![K] ¡¿Quién eres?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end) -- message_SetActor(ACTOR_NPC_MIKARUGE)
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english=" You ask that of US?", french="Vous nous posez la question,\nà NOUS?", german=" Du fragst UNS?", italian=" Volete sapere chi SIAMO?", spanish=" ¿Nos preguntas a nosotros?"})
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english=" Our name is...[K][CS:N]SPIRITOMB[CR].", french=" Notre nom est...[K] [CS:N]SPIRITOMB[CR].", german=" Unser Name ist... [K][CS:N]KRYPPUK[CR].", italian=" Noi siamo...[K] [CS:N]SPIRITOMB[CR].", spanish=" Nos llamamos...[K] [CS:N]Spiritomb[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english="We are the manifestation of a\nFUSION of spirits...", french="Nous sommes l'incarnation\nd'une LEGION d'esprits...", german="Wir sind eine Manifestation von\nVERSCHMOLZENEN Geistern...", italian="Siamo la manifestazione di una\nFUSIONE di spiriti...", spanish="Somos la manifestación de\nuna fusión de espíritus..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7427) — id SE NDS sans portage PMDO identifié
  -- Destroy() [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english=" One hundred and EIGHT of them!", french="Préparez-vous à affronter\ncent HUIT spectres!", german="Von einhundert und ACHT\nGeistern!", italian=" Cento e OTTO di loro!", spanish=" ¡DE CIENTO OCHO!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Be careful, you two![K]\nThat Pokémon is strong!", french="Prudence, vous autres![K]\nCe Pokémon est très fort!", german="Seid vorsichtig, ihr zwei![K]\nDieses Pokémon hat große Kraft!", italian="Fate attenzione, voi due![K]\nQuel Pokémon è forte!", spanish="¡Id con mucho cuidado![K]\n¡Ese Pokémon es muy fuerte!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english="HEE-hee...HEE-hee... PREPARE to\ntake your punishment!", french="HEE hee... HEE hee...\nPREPAREZ-VOUS à subir votre châtiment!", german="HEE-hee... HEE-hee... Macht euch\nBEREIT für eure Strafe!", italian="EEH-eeh... EEH-eeh...\nPREPARATEVI a una sonora punizione!", spanish="Ji, ji, ji... Ji, ji, ji...\n¡Preparaos para vuestro castigo!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(31, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
