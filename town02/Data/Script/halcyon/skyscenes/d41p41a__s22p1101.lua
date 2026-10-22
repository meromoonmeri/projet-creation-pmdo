-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D41P41A/s22p1101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(69, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  SkyProg.set(29, 91) -- $SCENARIO_MAIN = scn[29,91] (ROM)
  -- back_SetGround(LEVEL_D41P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_RAIN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(90)
  pcall(function() GAME:MoveCamera(276, 196, 60, false) end) -- performer/caméra
  local npc_npc_kureseria = SkySceneKit.spawn_npc("cresselia", 280, 312, Direction.Up, "NPC_KURESERIA")
  GROUND:MoveToPosition(npc_npc_kureseria, 276, 188, false, 2)
  GROUND:MoveToPosition(partner, 260, 212, false, 2)
  GROUND:MoveToPosition(hero, 292, 212, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's a dead end.", french=" C'est un cul-de-sac.", german=" Das ist eine Sackgasse.", italian=" È un vicolo cieco.", spanish=" No hay salida."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's a dead end.", french=" C'est un cul-de-sac.", german=" Das ist eine Sackgasse.", italian=" È un vicolo cieco.", spanish=" No hay salida."})
  else
  SkySceneKit.say({english=" It's a dead end.", french=" C'est un cul-de-sac.", german=" Das ist eine Sackgasse.", italian=" È un vicolo cieco.", spanish=" No hay salida."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I guess this is the deepest we\ncan go...", french="On dirait qu'on a atteint\nle fond...", german="Ich vermute, tiefer kommen\nwir hier nicht...", italian="Non possiamo andare più\nin profondità...", spanish=" No se puede avanzar más..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This appears to be the deepest\nwe can go...", french="On dirait qu'on a atteint\nle fond...", german="Tiefer scheinen wir hier nicht\nzu kommen...", italian="Non possiamo andare più\nin profondità...", spanish=" No se puede avanzar más..."})
  else
  SkySceneKit.say({english="This looks like the deepest we\ncan go...", french="On dirait qu'on a atteint\nle fond...", german="Tiefer kann man hier wohl nicht\nmehr gehen...", italian="Non possiamo andare più\nin profondità...", spanish=" No se puede avanzar más..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But where's [CS:N]Darkrai[CR]...?", french=" Mais où se cache [CS:N]Darkrai[CR]...?", german=" Aber wo ist [CS:N]Darkrai[CR]?", italian=" Ma dov'è [CS:N]Darkrai[CR]...?", spanish=" ¿Pero dónde está [CS:N]Darkrai[CR]...?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But where's [CS:N]Darkrai[CR]...?", french=" Mais où se cache [CS:N]Darkrai[CR]...?", german=" Aber wo ist [CS:N]Darkrai[CR]?", italian=" Ma dov'è [CS:N]Darkrai[CR]...?", spanish=" ¿Pero dónde está [CS:N]Darkrai[CR]...?"})
  else
  SkySceneKit.say({english=" Where's [CS:N]Darkrai[CR], though...?", french=" Mais où se cache [CS:N]Darkrai[CR]...?", german=" Wo ist denn [CS:N]Darkrai[CR] bloß?", italian=" Ma dov'è [CS:N]Darkrai[CR]...?", spanish=" ¿Pero dónde está [CS:N]Darkrai[CR]...?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6925) — id SE NDS sans portage PMDO identifié
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeIn(30) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  GAME:WaitFrames(45)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_daakurai = SkySceneKit.spawn_npc("darkrai", 280, 152, Direction.Down, "NPC_DAAKURAI")
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end) -- message_SetActor(ACTOR_NPC_DAAKURAI)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" You've kept me waiting.", french=" Ha! Je vous attendais.", german=" Ihr habt mich warten lassen.", italian=" Mi avete fatto aspettare.", spanish=" Me habéis hecho esperar."})
  -- message_Close
  GAME:FadeIn(5) -- screen_FadeChange vers alpha 256 (éclaircissement, adaptation)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "shock", 1) end)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(8), 3, false) end) -- MovePositionOffset performer/caméra
  do local p=npc_npc_kureseria.Position; GROUND:MoveToPosition(npc_npc_kureseria, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_IN_THE_FUTURE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Darkrai[CR]!", french=" [CS:N]Darkrai[CR]!", german=" [CS:N]Darkrai[CR]!", italian=" [CS:N]Darkrai[CR]!", spanish=" ¡[CS:N]Darkrai[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Darkrai[CR]!", french=" [CS:N]Darkrai[CR]!", german=" [CS:N]Darkrai[CR]!", italian=" [CS:N]Darkrai[CR]!", spanish=" ¡[CS:N]Darkrai[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]Darkrai[CR]!", french=" [CS:N]Darkrai[CR]!", german=" [CS:N]Darkrai[CR]!", italian=" [CS:N]Darkrai[CR]!", spanish=" ¡[CS:N]Darkrai[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="Good of you to come,\n[partner] and [hero].", french="C'est très aimable à vous\nd'avoir accepté ce rendez-vous, [partner]\net [hero].", german="Wie nett von euch, dass ihr\nkommt, [partner] und [hero].", italian="Gentile da parte vostra venire\nqui, [partner] e [hero].", spanish="Me alegro de que hayáis venido,\n[partner] y [hero]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Why do you keep after us?![K]\nY-you don't even know us!", french="Pourquoi tu t'acharnes à vouloir\nnous nuire?![K] T-tu ne nous connais même pas!", german="Warum bist du hinter uns\nher?!?[K] D-du kennst uns nicht einmal!", italian="P-Perché ce l'hai con noi?![K]\nNon ci conosci nemmeno!", spanish="¿Por qué nos persigues?[K]\n¡Ni siquiera nos conoces!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Why do you keep after us?![K]\nY-you don't even know us!", french="Pourquoi tu t'acharnes à vouloir\nnous nuire?![K] T-tu ne nous connais même pas!", german="Warum bist du hinter uns\nher?!?[K] D-du kennst uns nicht einmal!", italian="P-Perché ce l'hai con noi?![K]\nNon ci conosci nemmeno!", spanish="¿Por qué nos persigues?[K]\n¡Ni siquiera nos conoces!"})
  else
  SkySceneKit.say({english="Why do you keep after us?![K]\nY-you don't even know us!", french="Pourquoi tu t'acharnes à vouloir\nnous nuire?![K] T-tu ne nous connais même pas!", german="Warum bist du hinter uns\nher?!?[K] D-du kennst uns nicht einmal!", italian="P-Perché ce l'hai con noi?![K]\nNon ci conosci nemmeno!", spanish="¿Por qué nos persigues?[K]\n¡Ni siquiera nos conoces!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" I know you all too well.", french="Détrompez-vous, je ne vous\nconnais que trop bien.", german=" Ich kenne euch nur zu gut.", italian=" Vi conosco fin troppo bene.", spanish=" Os conozco demasiado bien."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" You especially, [hero].", french=" Surtout toi, [hero].", german=" Besonders dich, [hero].", italian=" Soprattutto te, [hero].", spanish=" Sobre todo a ti, [hero]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Wh-what?!)", french="(Que... quoi?!)", german="(W-was?!?)", italian="(C-Cosa?!)", spanish="(¡¿Cómo?!)"})
  else
  SkySceneKit.say({english="(Wh-what?!)", french="(Que... quoi?!)", german="(W-was?!?)", italian="(C-Cosa?!)", spanish="(¡¿Cómo?!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="When you came to this world\nwith [CS:N]Grovyle[CR], [hero]...", french="Au cours de ton voyage dans le\ntemps avec [CS:N]Massko[CR], [hero]...", german="Als du mit [CS:N]Reptain[CR] in diese Welt\nkamst, [hero]...", italian="Mentre stavi viaggiando verso\nquesto mondo con [CS:N]Grovyle[CR], [hero]...", spanish="Cuando viniste a este mundo\ncon [CS:N]Grovyle[CR], [hero]..."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="You were caught up in an\naccident.", french="... tu as été victime d'un\naccident.", german="Da warst du in einen Unfall\nverwickelt.", italian=" Hai avuto un piccolo incidente.", spanish=" Tuviste un accidente."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...Accident...?)", french="(... Un accident...?)", german="(Unfall?)", italian="(Incidente...?)", spanish="(¿Un accidente?)"})
  else
  SkySceneKit.say({english="(...Accident...?)", french="(... Un accident...?)", german="(Unfall?)", italian="(Incidente...?)", spanish="(¿Un accidente?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Oh, that's right![K] [CS:N]Grovyle[CR] once explained it...)", french="(Ah oui, c'est vrai![K] [CS:N]Massko[CR] en a parlé\nà l'époque...)", german="(Oh, das stimmt![K] [CS:N]Reptain[CR] hat es mal erklärt.)", italian="(Oh, è vero![K] [CS:N]Grovyle[CR] me l'ha spiegato...)", spanish="(¡Es cierto![K] [CS:N]Grovyle[CR] me lo explicó...)"})
  else
  SkySceneKit.say({english="(Oh, that's right![K] [CS:N]Grovyle[CR] once explained it...)", french="(Ah oui, c'est vrai![K] [CS:N]Massko[CR] en a parlé\nà l'époque...)", german="(Oh, das stimmt![K] [CS:N]Reptain[CR] hat es mal erklärt.)", italian="(Oh, è vero![K] [CS:N]Grovyle[CR] me l'ha spiegato...)", spanish="(¡Es cierto![K] [CS:N]Grovyle[CR] me lo explicó...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(We had an accident traveling back in time...)", french="(On a eu un accident lors de notre voyage vers\nle passé...)", german="(Wir hatten einen Unfall, als wir durch die\nZeit zurückgereist sind.)", italian="(Abbiamo avuto un incidente mentre\nviaggiavamo nel tempo...)", spanish="(Tuvimos un accidente viajando en el tiempo...)"})
  else
  SkySceneKit.say({english="(We had an accident traveling back in time...)", french="(On a eu un accident lors de notre voyage vers\nle passé...)", german="(Wir hatten einen Unfall, als wir durch die\nZeit zurückgereist sind.)", italian="(Abbiamo avuto un incidente mentre\nviaggiavamo nel tempo...)", spanish="(Tuvimos un accidente viajando en el tiempo...)"})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
end
