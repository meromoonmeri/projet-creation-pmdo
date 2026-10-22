-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D10P41A/m10d0952.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- GAP: BGM BGM_MEMORIES_RETURNED non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_0 [étiquette de flux ExplorerScript]
  -- bgm2_PlayFadeIn(BGM_ON_THE_BEACH_AT_DUSK) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- @label_2 [étiquette de flux ExplorerScript]
  -- back_SetGround(LEVEL_D10P41A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  local npc_npc_guraadon = SkySceneKit.spawn_npc("groudon", 328, 168, Direction.Down, "NPC_GURAADON")
  do local p=npc_npc_guraadon.Position; GROUND:MoveToPosition(npc_npc_guraadon, p.X+(0), p.Y+(12), false, 1) end
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(15)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(15)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(15)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- SetAnimation(9) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_guraadon) end)
  SkySceneKit.say({english=" GRR...GRR...OOOOOOOOOH!", french=" GRROOOOOOH!", german=" GRR...GRR...OOOOOOOOOH!", italian=" GRR... GRR... OOOOOOOOOH!", spanish=" ¡GRRRRRRRR!"})
  GAME:WaitFrames(90)
  -- message_CloseEnforce
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk... Scary stuff!", french=" Argh... j'ai peur!", german=" Urk... Echt unheimlich!", italian=" Mmm... Brutta storia!", spanish=" ¡Ay, qué miedo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk... This is scary...", french=" Argh... j'ai peur!", german=" Urk... Das ist unheimlich...", italian=" Oh oh! Siamo nei guai!", spanish=" ¡Ay, qué miedo!"})
  else
  SkySceneKit.say({english=" Urk... I'm scared!", french=" Argh... j'ai peur!", german=" Urk... Ich habe Angst!", italian=" Aah... Ho paura!", spanish=" ¡Ay, estoy asustada!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But we gotta be brave!", french="Mais nous devons faire preuve\nde courage!", german=" Aber wir müssen mutig sein!", italian="Ma non dobbiamo farci\nintimorire!", spanish=" ¡Pero debemos ser valientes!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But we need to be brave!", french="Mais nous devons faire preuve\nde courage!", german=" Aber wir müssen mutig sein!", italian="Però è proprio questo il\nmomento in cui bisogna tirare fuori il coraggio!", spanish=" ¡Pero debemos ser valientes!"})
  else
  SkySceneKit.say({english=" But it's time to be brave!", french="Mais nous devons faire preuve\nde courage!", german="Aber es ist Zeit, all unseren Mut\nzusammenzunehmen!", italian=" Ma devo essere forte!", spanish=" ¡Pero debemos ser valientes!"})
  end
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" And I gotta face up to this!", french=" Et je dois faire face!", german="Ich muss mich dieser Sache\nstellen!", italian=" Possiamo farcela!", spanish=" ¡Tengo que sobreponerme!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" And I need to face up to this!", french=" Et je dois faire face!", german="Ich muss mich dieser Sache\nstellen!", italian=" Dobbiamo affrontarlo!", spanish=" ¡Tengo que sobreponerme!"})
  else
  SkySceneKit.say({english=" And I need to stand up to this!", french=" Et je dois faire face!", german="Ich muss mich dieser Sache\nstellen!", italian="Posso farcela! Possiamo\nfarcela!", spanish=" ¡Tengo que sobreponerme!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" No stopping now, [hero]!", french="Hors de question de baisser\nles bras maintenant, [hero]!", german="Es gibt jetzt kein Zurück,\n[hero]!", italian="Da qui non si torna indietro,\n[hero]!", spanish="¡No podemos rendirnos ahora,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There's no giving up now,\n[hero]!", french="Hors de question de baisser\nles bras maintenant, [hero]!", german="Wir können jetzt nicht aufgeben,\n[hero]!", italian="[hero]! Non possiamo\narrenderci proprio ora!", spanish="¡Ahora no podemos volvernos\natrás, [hero]!"})
  else
  SkySceneKit.say({english="We can't just run away now,\n[hero]!", french="Hors de question de baisser\nles bras maintenant, [hero]!", german="Wir können jetzt nicht\nweglaufen, [hero]!", italian="Insieme ce la possiamo fare,\n[hero]!", spanish="¡No podemos salir corriendo,\n[hero]!"})
  end
  -- message_Close
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  GAME:FadeOut(false, 30)
  -- @label_5 [étiquette de flux ExplorerScript]
  GAME:FadeIn(0) -- screen_FlushIn
  end
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
