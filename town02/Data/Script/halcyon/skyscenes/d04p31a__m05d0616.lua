-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D04P31A/m05d0616.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D04P31A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  -- SetAnimation(67) [anim idle native]
  GAME:FadeIn(5)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But that was...!)", french="(Mais c'est...!)", german="(Aber das war...)", italian="(Ma era...!)", spanish="(¡Pero si ese era...!)"})
  else
  SkySceneKit.say({english="(But that was...!)", french="(Mais c'est...!)", german="(Aber das war...)", italian="(Ma era...!)", spanish="(¡Pero si ese era...!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(67) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urrrrrrgh![K] Urrrrrrgh!", french=" Aaargh! [K]Aaaaargh!", german=" Urrrrrrgh![K] Urrrrrrgh!", italian=" Urrrrrrgh![K] Urrrrrrgh!", spanish=" ¡Aaah![K] ¡Uuuuf!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urrrrrrgh![K] Urrrrrrgh!", french=" Aaargh! [K]Aaaaargh!", german=" Urrrrrrgh![K] Urrrrrrgh!", italian=" Urrrrrrgh![K] Urrrrrrgh!", spanish=" ¡Aaah![K] ¡Uuuuf!"})
  else
  SkySceneKit.say({english=" Urrrrrrgh![K] Urrrrrrgh!", french=" Aaargh! [K]Aaaaargh!", german=" Urrrrrrgh![K] Urrrrrrgh!", italian=" Urrrrrrgh![K] Urrrrrrgh!", spanish=" ¡Aaah![K] ¡Uuuuf!"})
  end
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I can't get it out...", french="Impossible de la sortir de là...\nDécidément, ça ne sert à rien.", german=" Ich kriege ihn nicht raus...", italian=" Non riesco a spostarla...", spanish=" No puedo sacarla..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's no good. I can't pull it out...", french="Impossible de la sortir de là...\nDécidément, ça ne sert à rien.", german="Es bringt nichts. Ich kann ihn\nnicht herausziehen.", italian=" Non riesco a spostarla...", spanish="No sirve de nada.\nNo consigo sacarla..."})
  else
  SkySceneKit.say({english=" N-no. It just won't come out...", french="Impossible de la sortir de là...\nDécidément, ça ne sert à rien.", german="N-nein, er gibt einfach nicht\nnach.", italian=" Non riesco a spostarla...", spanish="Imposible. No hay forma\nde sacarla..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN][partner] just happened\n[CN]to push the gigantic gem!", french="[CN][partner] pousse la gemme\n[CN]géante à tout hasard!", german="[CN]Durch Zufall drückt [partner]\n[CN]gegen den riesigen Edelstein!", italian="[CN][partner] spinge senza volerlo\n[CN]la gemma gigante!", spanish="[CN]Casualmente, en ese momento [partner]\n[CN]empujó la gema gigantesca."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6658) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Aaaack! That's...)", french="(Aaah! C'est...)", german="(Aaaargh! Das ist...)", italian="(Aaaack! È...)", spanish="(¡Aaaah! Eso es...)"})
  else
  SkySceneKit.say({english="(Aaaack! That's...)", french="(Aaah! C'est...)", german="(Aaaargh! Das ist...)", italian="(Aaaack! È...)", spanish="(¡Aaaah! Eso es...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(60)
  -- GAP: se_Play(5131) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1')
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? What's going on?", french=" Quoi? Que se passe-t-il?", german=" Ähem? Was passiert jetzt?", italian=" Eh? Cosa sta succedendo?", spanish=" ¿Eh? ¿Qué pasa?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh? What's going on?", french=" Quoi? Que se passe-t-il?", german=" Ähem? Was passiert jetzt?", italian=" Eh? Cosa sta succedendo?", spanish=" ¿Eh? ¿Qué pasa?"})
  else
  SkySceneKit.say({english=" Huh? What's happening?", french=" Quoi? Que se passe-t-il?", german=" Ähem? Was passiert jetzt?", italian=" Eh? Cosa sta succedendo?", spanish=" ¿Eh? ¿Qué pasa?"})
  end
  -- message_Close
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5130) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 6, 30)) end) -- camera_SetEffect('2', '3', '1')
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Right) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Right) end end
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaah! It's a flood!", french=" Wouaaah! Une vague déferlante!", german=" Waaah! Es ist eine Flutwelle!", italian=" Waaah! Un'inondazione!", spanish=" ¡Aaah! ¡Es una riada!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaah! It's a flood!", french=" Wouaaah! Une vague déferlante!", german=" Waaah! Es ist eine Flutwelle!", italian=" Waaah! Un'inondazione!", spanish=" ¡Aaah! ¡Es una riada!"})
  else
  SkySceneKit.say({english=" Waaah! It's a flood!", french=" Wouaaah! Une vague déferlante!", german=" Waaah! Es ist eine Flutwelle!", italian=" Waaah! Un'inondazione!", spanish=" ¡Aaah! ¡Se está inundando todo!"})
  end
  -- message_Close
  -- GAP: BGM BGM_STORMY_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- supervision_SpecialActing(7, 0, 0) [cadrage NDS]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-80), p.Y+(0), false, 2) end
  do local p=SkySceneKit.team_member(2).Position; GROUND:MoveToPosition(SkySceneKit.team_member(2), p.X+(-96), p.Y+(0), false, 2) end
  GAME:WaitFrames(10)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-40), p.Y+(0), false, 2) end
  GAME:WaitFrames(20)
  do local p=SkySceneKit.team_member(1).Position; GROUND:MoveToPosition(SkySceneKit.team_member(1), p.X+(-40), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  -- SetAnimation(11) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-180), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=SkySceneKit.team_member(2).Position; GROUND:MoveToPosition(SkySceneKit.team_member(2), p.X+(-180), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  -- SetAnimation(11) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-180), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=SkySceneKit.team_member(1).Position; GROUND:MoveToPosition(SkySceneKit.team_member(1), p.X+(-180), p.Y+(0), false, 2) end -- SlidePositionOffset
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaaaaaah!", french=" Wouaaaaaaah!", german=" Waaaaaaah!", italian=" Aaaaaaaah!", spanish=" ¡Aaaaaaaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaaaaaah!", french=" Wouaaaaaaah!", german=" Waaaaaaah!", italian=" Aaaaaaaah!", spanish=" ¡Aaaaaaaah!"})
  else
  SkySceneKit.say({english=" Waaaaaaah!", french=" Wouaaaaaaah!", german=" Waaaaaaah!", italian=" Aaaaaaaah!", spanish=" ¡Aaaaaaaah!"})
  end
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  -- supervision_SpecialActing(3, 0, 0) [cadrage NDS]
  GAME:WaitFrames(60)
  -- se_FadeOut(5130, 120) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
