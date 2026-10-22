-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D79P41A/s02p0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D79P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yukimenoko = SkySceneKit.spawn_npc("froslass", 304, 192, Direction.Down, "NPC_YUKIMENOKO")
  -- SetAnimation(11) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukimenoko, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_yukimenoko) end)
  SkySceneKit.say({english=" Eeeeek!", french=" Hiiiii...", german=" Ieeeek...", italian=" Eeeeek!", spanish=" Aaaah..."})
  -- me_Play(11) [ME vent/ambiance NDS sans fanfare équivalente - documenté]
  -- GAP: SetEffect 648 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(30)
  GAME:FadeOut(true, 60) -- screen_WhiteOutAll
  -- message_CloseEnforce
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(120)
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  -- GAP: se_Play(7956) — id SE NDS sans portage PMDO identifié
  -- Destroy() [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D79P41A1_92) [routine d'objet NDS non simulée - documenté]
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(3) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  GAME:WaitFrames(90)
  local npc_npc_hassamu = SkySceneKit.spawn_npc("scizor", 304, 168, Direction.Down, "NPC_HASSAMU")
  do local p=npc_npc_hassamu.Position; GROUND:MoveToPosition(npc_npc_hassamu, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_hassamu.Position; GROUND:MoveToPosition(npc_npc_hassamu, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_hassamu.Position; GROUND:MoveToPosition(npc_npc_hassamu, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_hassamu.Position; GROUND:MoveToPosition(npc_npc_hassamu, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english=" Ur...[K] Urf...", french=" Argh...[K] Aaargh...", german=" Uh...[K] Uff...", italian=" Er...[K] Urf...", spanish=" Eh...[K] Uf..."})
  do local p=npc_npc_hassamu.Position; GROUND:MoveToPosition(npc_npc_hassamu, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_hassamu.Position; GROUND:MoveToPosition(npc_npc_hassamu, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_hassamu.Position; GROUND:MoveToPosition(npc_npc_hassamu, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_hassamu.Position; GROUND:MoveToPosition(npc_npc_hassamu, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english=" Wh-where...?", french=" Où... où suis-je...?", german=" W-wo?", italian=" D-Dove...?", spanish=" ¿Por dónde...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  GROUND:EntTurn(npc_npc_hassamu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english="Ah, yes. I recall now. I had been exploring\nwhen I was set upon by that beastly [CS:N]Froslass[CR]...", french="Ah, en effet. Il m'en souvient à présent.\nJ'explorais ce lieu lorsque je fus capturé par\ncet abominable [CS:N]Momartik[CR]...", german="Ah ja. Ich erinnere mich. Ich war bei einer\nErkundung, als mich dieses garstige [CS:N]Frosdedje[CR]\nanfiel.", italian="Ah, sì. Adesso mi ricordo. Stavo\nesplorando, quando tutto ad un tratto sono\nstato assalito da [CS:N]Froslass[CR]...", spanish="Ah, sí, ya me acuerdo. Estaba explorando y\nentonces me atacó la bestia de [CS:N]Froslass[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_hassamu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_hassamu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english=" Oh!", french=" Oh!", german=" Oh!", italian=" Oh!", spanish=" ¡Oh!"})
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english=" You're rescuing me, I presume?", french="Vous venez afin de me porter secours,\nje présume?", german=" Ihr seid meine Retter, nehme ich an?", italian="Immagino che voi siate qui per\nsalvarmi...", spanish=" Supongo que venís a rescatarme."})
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english="Forgive me for my lapse in etiquette.\nMy name is [CS:N]Scizor[CR].[K] I am an explorer.", french="Veuillez pardonner mon manque de civilité.\nJe me nomme [CS:N]Cizayox[CR].[K] Je suis un explorateur.", german="Vergebt mir meine fehlende Etikette.\nMein Name ist [CS:N]Scherox[CR].[K] Ich bin ein Erkunder.", italian="Scusate le mie maniere. Mi chiamo\n[CS:N]Scizor[CR],[K] e sono un esploratore.", spanish="Perdonad que no me haya presentado.\nMe llamo [CS:N]Scizor[CR].[K] Soy explorador."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
end
