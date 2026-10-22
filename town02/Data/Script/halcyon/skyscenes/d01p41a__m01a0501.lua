-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P41A/m01a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(2, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D01P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 248, 160, Direction.Up, "NPC_ZUBATTO")
  -- SetAnimation(5) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(partner, 212, 204, false, 2)
  GROUND:MoveToPosition(hero, 244, 204, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?", french=" Oh... quoi?", german=" Wie?", italian=" Eh?", spanish="¿Cómo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?", french=" Oh... quoi?", german=" Was?", italian=" Cosa?", spanish=" ¿Qué?"})
  else
  SkySceneKit.say({english=" Oh... What?", french=" Oh... quoi?", german=" Oh... Was?", italian=" Oh... Cosa?", spanish=" Oh... ¿Qué?"})
  end
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 216, 160, Direction.Up, "NPC_DOGAASU")
  pcall(function() GROUND:CharSetEmote(npc_npc_dogaasu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_zubatto, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Down)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Why are you still here?", french=" Pourquoi vous êtes encore là?", german=" Warum seid ihr immer noch da?", italian=" Cosa ci fate ancora qui?", spanish=" ¿Cómo es que seguís aquí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What are you still doing here?", french=" Pourquoi vous êtes encore là?", german=" Was macht ihr immer noch hier?", italian=" Cosa ci fate ancora qui?", spanish=" ¿Qué hacéis aquí todavía?"})
  else
  SkySceneKit.say({english=" Why are you still here?", french=" Pourquoi vous êtes encore là?", german=" Warum seid ihr immer noch da?", italian=" Cosa ci fate ancora qui?", spanish=" ¿Por qué seguís aquí?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I figured you would be long gone\nand far away by now.", french="Je pensais que vous seriez\npartis depuis longtemps.", german="Ich dachte, ihr wärt schon\nlängst über alle Berge.", italian="Pensavo che ormai foste\nlontano da qui.", spanish="Me figuraba que a estas alturas\nya estaríais muy lejos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I thought you would have gotten\nfar away by now.", french="Je pensais que vous seriez\npartis depuis longtemps.", german="Ich dachte, ihr wärt schon über\nalle Berge.", italian="Pensavo che ormai foste\nlontano da qui.", spanish="Creía que a estas alturas ya\nestaríais muy lejos."})
  else
  SkySceneKit.say({english="I expected you to have gotten\nfar away by now.", french="Je ne pensais pas vous revoir\nde sitôt.", german="Ich hatte erwartet, dass ihr\nschon über alle Berge seid.", italian="Pensavo che ormai foste\nlontano da qui.", spanish="Suponía que ya os habríais\nmarchado."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogaasu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Y-you...[K] Shut up!", french=" T-toi...[K] Tais-toi!", german=" D-du...[K] Halt den Mund!", italian=" T-Tu...[K] Chiudi quella boccaccia!", spanish=" Tú...[K] ¡Cierra el pico!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="We can't find our way out of\nthis place!", french="On sait pas comment sortir\nde cet endroit!", german="Wir finden hier nicht mehr\nheraus!", italian=" Non riusciamo a trovare l'uscita!", spanish=" ¡No sabemos cómo salir de aquí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="Whoa-ho-ho![K] But there's nothing\nto fear, is there? It's only you!", french="Mouarf![K] Mais on a pas de quoi\navoir peur, hein? Y'a que vous ici!", german="Whoahoho![K] Aber wir machen uns\nkeine Sorgen! Es seid ja nur ihr hier!", italian="Ah ah![K] Ma non c'è d'avere\npaura, giusto? Sei solo tu!", spanish="¡Jo, jo, jo![K] En fin... No hay nada\nque temer, ¿verdad? ¡Solo eres tú!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Heh-heh-heh! Once a pushover,\nalways a pushover!", french="Hin hin hin! Comme on dit,\nmauviette un jour, mauviette toujours!", german="Hehehe! Einmal Verlierer,\nimmer Verlierer!", italian="Eh-eh-eh! Debole eri e debole\nrimani!", spanish="¡Jue, jue, jue! El que es pelele,\n¡no deja de serlo nunca!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="We'll show you what a wimp you\nare all over again![K] You ready?", french="Si ta première leçon t'a pas\nsuffi... On va te prouver que t'es qu'une poule\nmouillée![K] Prépare-toi!", german="Wir zeigen euch noch mal, was\nfür Schwächlinge ihr seid![K] Bereit?", italian="Ti daremo un'altra bella\nlezione![K] Capito?", spanish="¡Y nosotros te vamos a recordar\nlo pelele que eres![K] ¿Empezamos?"})
  -- message_Close
  pcall(function() SOUND:StopBGM() end)
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
  -- main_EnterDungeon(2, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
