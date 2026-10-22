-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D17P45A/m15b1001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D17P45A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_agunomu = SkySceneKit.spawn_npc("azelf", 352, 256, Direction.Down, "NPC_AGUNOMU")
  -- SetAnimation(24) [anim idle native]
  GAME:FadeIn(30)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 352, 160, Direction.Down, "NPC_JUPUTORU")
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  pcall(function() GAME:MoveCamera(348, 228, 60, false) end) -- performer/caméra
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GROUND:MoveToPosition(partner, 348, 228, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(3)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GROUND:MoveToPosition(hero, 392, 212, false, 2) -- SlidePositionMark (glissement)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 284, 212, false, 2) -- Slide2PositionMark (glissement) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 248, 196, false, 2) -- Slide2PositionMark (glissement) end end
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(68) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(68) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Urgh...)", french="(Argh...)", german="(Urgh...)", italian="(Urgh...)", spanish="(¡Ay!)"})
  else
  SkySceneKit.say({english="(Urgh...)", french="(Argh...)", german="(Urgh...)", italian="(Urgh...)", spanish="(¡Ay!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urrrggh...", french=" Aaaaarggh...", german=" Urrrggh...", italian=" Aaargh...", spanish=" ¡Ay!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urrrggh...", french=" Aaaaarggh...", german=" Urrrggh...", italian=" Aaargh...", spanish=" ¡Ay!"})
  else
  SkySceneKit.say({english=" Urrrggh...", french=" Aaaaarggh...", german=" Urrrggh...", italian=" Aaargh...", spanish=" ¡Ay!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_juputoru, 348, 184, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Get out of the way!", french=" Hors de ma vue!", german=" Geh mir aus dem Weg!", italian=" Fuori dai piedi!", spanish=" ¡Aparta!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" (I...I can't talk...)", french="(Je... je n'arrive plus\nà parler...)", german=" (Ich... Ich kann nicht reden.)", italian=" (Non... riesco a parlare...)", spanish=" (No... no puedo hablar.)"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" (I...I can't talk...)", french="(Je... je n'arrive plus\nà parler...)", german=" (Ich... Ich kann nicht reden.)", italian=" (Non... riesco a parlare...)", spanish=" (No... no puedo hablar.)"})
  else
  SkySceneKit.say({english=" (I...I can't talk...)", french="(Je... je n'arrive plus\nà parler...)", german=" (Ich... Ich kann nicht reden.)", italian=" (Non... riesco a parlare...)", spanish=" (No... no puedo hablar.)"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=".......................................\n(But...[K]I won't step aside!)", french=".......................................\n(Mais...[K] je ne m'écarterai pas!)", german=".......................................\n(Aber...[K] Ich rühre mich nicht vom Fleck!)", italian=".......................................\n(Ma...[K] non passerai!)", spanish=" (Pero...[K] ¡no pienso apartarme!)"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=".......................................\n(But...[K]I won't step aside!)", french=".......................................\n(Mais...[K] je ne m'écarterai pas!)", german=".......................................\n(Aber...[K] Ich rühre mich nicht vom Fleck!)", italian=".......................................\n(Ma...[K] non passerai!)", spanish=" (Pero...[K] ¡no pienso apartarme!)"})
  else
  SkySceneKit.say({english=".......................................\n(But...[K]I won't step aside! Ever!)", french=".......................................\n(Mais...[K] je ne m'écarterai pas!)", german=".......................................\n(Aber...[K] Ich rühre mich nicht vom Fleck!)", italian=".......................................\n(Ma...[K] non passerai!)", spanish=" (Pero...[K] ¡no pienso apartarme!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" You refuse?!", french=" Vous résistez?!", german=" Du weigerst dich?!?", italian="E così, ancora non volete\narrendervi?", spanish=" ¿Así que te niegas?"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Then you leave me no choice!", french="Alors vous ne me laissez pas\nle choix!", german=" Dann habe ich keine Wahl!", italian="Allora, non mi lasciate davvero\naltra scelta...", spanish=" Entonces no me dejas elección."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5124) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(N-no!)", french="(N-non!)", german="(N-nein!)", italian="(N-No!)", spanish="(¡No!)"})
  else
  SkySceneKit.say({english="(N-no!)", french="(N-non!)", german="(N-nein!)", italian="(N-No!)", spanish="(¡No!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner]'s in serious trouble!)", french="([partner] est en grave danger!)", german="([partner] ist in Gefahr!)", italian="([partner] è nei guai!)", spanish="(¡[partner] corre peligro!)"})
  else
  SkySceneKit.say({english="([partner]'s in serious trouble!)", french="([partner] est en grave danger!)", german="([partner] ist in Gefahr!)", italian="([partner] è nei guai!)", spanish="(¡[partner] corre peligro!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(B-but...I can't move...)", french="(Mais... je ne peux pas bouger...)", german="(A-aber... Ich kann mich nicht bewegen.)", italian="(M-Ma... n-non riesco a muovermi...)", spanish="(Pero... no puedo moverme.)"})
  else
  SkySceneKit.say({english="(B-but...I can't move...)", french="(Mais... je ne peux pas bouger...)", german="(A-aber... Ich kann mich nicht bewegen.)", italian="(M-Ma... n-non riesco a muovermi...)", spanish="(Pero... no puedo moverme...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" .................. (Urk...)", french=" .................. (Argh...)", german=" .................. (Urk...)", italian="..................\n(Ooh...)", spanish=" (¡Ay!)"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" .................. (Urk...)", french=" .................. (Argh...)", german=" .................. (Urk...)", italian="..................\n(Ooh...)", spanish=" (¡Ay!)"})
  else
  SkySceneKit.say({english=" .................. (Urk...)", french=" .................. (Argh...)", german=" .................. (Urk...)", italian="..................\n(Ooh...)", spanish=" (¡Ay!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" This is all for the Time Gear!", french="Tout ça, c'est à cause du Rouage\ndu Temps!", german="Ich tue das nur für das Zahnrad\nder Zeit!", italian="Devo farlo... per l'Ingranaggio\ndel Tempo!", spanish="Tengo que hacer todo esto por\nel Engranaje del Tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Forgive me!", french=" Pardonnez-moi!", german=" Vergib mir!", italian=" Perdonatemi!", spanish=" Lo siento."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ..................! (WAAAAAAAAAH!)", french=" ..................! (OUAAAAAAAAAH!)", german=" .................. (WAAAAAAAAAH!)", italian="..................!\n(WAAAAAAAAAH!)", spanish=" (¡AAAAAAH!)"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ..................! (WAAAAAAAAAH!)", french=" ..................! (OUAAAAAAAAAH!)", german=" .................. (WAAAAAAAAAH!)", italian="..................!\n(WAAAAAAAAAH!)", spanish=" (¡AAAAAAH!)"})
  else
  SkySceneKit.say({english=" ..................! (WAAAAAAAAAH!)", french=" ..................! (OUAAAAAAAAAH!)", german=" .................. (WAAAAAAAAAH!)", italian="..................!\n(WAAAAAAAAAH!)", spanish=" (¡AAAAAAH!)"})
  end
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(15)
  -- GAP: se_Play(7690) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 5) -- screen_WhiteOut
  GAME:WaitFrames(15)
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]Stop!", french="[CN]Halte-là!", german="[CN]Stopp!", italian="[CN]Fermati!", spanish="[CN]¡Alto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  SkySceneKit.offset_pos(npc_npc_juputoru, 0, -8)
  GAME:FadeIn(1)
  -- GAP: se_Play(7180) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Gah!", french=" Argh!", german=" Gah!", italian=" Ah!", spanish=" ¡Uf!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" (Oh! [CS:N]Dusknoir[CR]!)", french=" (Oh! [CS:N]Noctunoir[CR]!)", german=" (Oh! [CS:N]Zwirrfinst[CR]!)", italian=" (Oh! È [CS:N]Dusknoir[CR]!)", spanish=" (¡[CS:N]Dusknoir[CR]!)"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" (Oh! [CS:N]Dusknoir[CR]!)", french=" (Oh! [CS:N]Noctunoir[CR]!)", german=" (Oh! [CS:N]Zwirrfinst[CR]!)", italian=" (Oh! È [CS:N]Dusknoir[CR]!)", spanish=" (¡[CS:N]Dusknoir[CR]!)"})
  else
  SkySceneKit.say({english=" (Oh! [CS:N]Dusknoir[CR]!)", french=" (Oh! [CS:N]Noctunoir[CR]!)", german=" (Oh! [CS:N]Zwirrfinst[CR]!)", italian=" (Oh! È [CS:N]Dusknoir[CR]!)", spanish=" (¡[CS:N]Dusknoir[CR]!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 352, 208, Direction.Up, "NPC_YONOWAARU")
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Are you all right, [partner]?", french="Te portes-tu bien,\n[partner]?", german=" Alles in Ordnung, [partner]?", italian="State tutti bene? E tu,\n[partner], tutto bene?", spanish=" ¿Estás bien, [partner]?"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Please! Let me handle this!", french=" Laissez-moi m'occuper de cela!", german=" Bitte! Lasst mich das erledigen!", italian="Indietro! Lasciate che me ne\noccupi io!", spanish="Por favor, permitid que me\nocupe de esto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  pcall(function() GAME:MoveCamera(348, 208, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_juputoru, 348, 148, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(29) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Rrrroh!", french=" Rrrroh!", german=" Rrrroahhrrr!", italian=" Grrrroh!", spanish=" ¡Aaah!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(31) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Y-you?!", french=" T-toi?!", german=" D-du?!?", italian=" T-Tu?!", spanish=" ¡¿Tú?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yonowaaru.Position; GROUND:MoveToPosition(npc_npc_yonowaaru, p.X+(0), p.Y+(-8), false, 1) end
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" It's been too long!", french=" Cela faisait une éternité!", german=" Es ist viel Zeit vergangen!", italian=" È tanto che non ci si vede, eh?", spanish="¡Cuánto tiempo sin vernos\nlas caras!"})
  -- message_KeyWait
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="It wasn't easy finding you,\n[CS:N]Grovyle[CR]!", french="J'ai eu bien du mal à te trouver,\n[CS:N]Massko[CR]!", german="Es war nicht leicht, dich zu\nfinden, [CS:N]Reptain[CR]!", italian="Non è stato facile trovarti,\n[CS:N]Grovyle[CR]!", spanish="No ha sido nada fácil dar\ncontigo, [CS:N]Grovyle[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" (Huh? What was that?!)", french="(Hein? Qu'est-ce que ça veut\ndire?!)", german=" (Äh? Wie war das?!?)", italian=" (Eeeh? Ma cosa...)", spanish=" (¿Cómo? ¿He oído bien?)"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" (What...what was that?!)", french="(Hein? Qu'est-ce que ça veut\ndire?!)", german=" (Wie war das?!?)", italian=" (Eeeh? Ma cosa...)", spanish=" (¿Cómo? ¿He oído bien?)"})
  else
  SkySceneKit.say({english=" (What...what was that?!)", french="(Hein? Qu'est-ce que ça veut\ndire?!)", german=" (Wie war das?!?)", italian=" (Eeeh? Ma cosa...)", spanish=" (¿Cómo? ¿He oído bien?)"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=".................................\n(The great [CS:N]Dusknoir[CR] knows [CS:N]Grovyle[CR]?!)", french=".................................\n(Le grand [CS:N]Noctunoir[CR] connaît [CS:N]Massko[CR]?!)", german=".................................\n(Der große [CS:N]Zwirrfinst[CR] kennt [CS:N]Reptain[CR]?!?)", italian=".................................\n(Il signor [CS:N]Dusknoir[CR] conosce [CS:N]Grovyle[CR]?!)", spanish="(¡¿El gran [CS:N]Dusknoir[CR] conoce a\n[CS:N]Grovyle[CR]?!)"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=".................................\n(The great [CS:N]Dusknoir[CR] knows [CS:N]Grovyle[CR]?!)", french=".................................\n(Le grand [CS:N]Noctunoir[CR] connaît [CS:N]Massko[CR]?!)", german=".................................\n(Der große [CS:N]Zwirrfinst[CR] kennt [CS:N]Reptain[CR]?!?)", italian=".................................\n(Il signor [CS:N]Dusknoir[CR] conosce [CS:N]Grovyle[CR]?!)", spanish="(¡¿El gran [CS:N]Dusknoir[CR] conoce a\n[CS:N]Grovyle[CR]?!)"})
  else
  SkySceneKit.say({english=".................................\n(The great [CS:N]Dusknoir[CR] knows [CS:N]Grovyle[CR]?!)", french=".................................\n(Le grand [CS:N]Noctunoir[CR] connaît [CS:N]Massko[CR]?!)", german=".................................\n(Der große [CS:N]Zwirrfinst[CR] kennt [CS:N]Reptain[CR]?!?)", italian=".................................\n(Il signor [CS:N]Dusknoir[CR] conosce [CS:N]Grovyle[CR]?!)", spanish="(¡¿El gran [CS:N]Dusknoir[CR] conoce a\n[CS:N]Grovyle[CR]?!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Gah!", french=" Argh!", german=" Gah!", italian=" Aah!", spanish=" ¡Ah!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Even here...[K]you chased me\neven here!", french="Jusqu'ici...[K] tu m'as suivi\njusqu'ici!", german="Sogar hier![K] Sogar hier hast\ndu mich gefunden!", italian="Fino a qui...[K] Mi hai seguito fino\na qui!", spanish="Hasta aquí...[K] ¿Has sido capaz de\nvenir a perseguirme incluso hasta aquí?"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="You're tenacious, all right! You\ncling to me beyond expectation!", french="Tu es tenace, pas de doute!\nTu me colles au train sans relâche!", german="Du bist wirklich hartnäckig!\nDu klebst an mir wie eine Klette!", italian="Sei davvero testardo! Non vuoi\nproprio lasciarmi in pace, eh?", spanish="No te rindes. Irías a donde fuera\nnecesario con tal de atraparme, ¿verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CS:N]Grovyle[CR]! You're not getting away\nthis time!", french="[CS:N]Massko[CR]! Tu ne m'échapperas\npoint cette fois!", german="[CS:N]Reptain[CR]! Diesmal kommst du mir\nnicht davon!", italian="[CS:N]Grovyle[CR]! Questa volta non mi\nsfuggirai!", spanish="[CS:N]Grovyle[CR], ¡esta vez no podrás\nescaparte!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR]...", french=" [CS:N]Noctunoir[CR]...", german=" [CS:N]Zwirrfinst[CR]...", italian=" [CS:N]Dusknoir[CR]...", spanish=" [CS:N]Dusknoir[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I'm surprised to see you in\nthis world...", french="Je suis surpris de te voir\ndans ce monde...", german="Ich bin überrascht, dich in\ndieser Welt zu sehen.", italian="È davvero una brutta\nsorpresa trovarti qui...", spanish="Me sorprende verte en este\nmundo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" But I'm ready!", french=" Mais je suis prêt!", german=" Aber ich bin bereit!", italian="Ma così sia! Sono pronto allo\nscontro!", spanish=" ¡Pero estoy preparado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  -- GAP: se_Play(5124) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" So you'll fight.[K] Then so be it.", french=" Alors tu comptes te battre.[K] Soit.", german="Also wirst du kämpfen.[K]\nSo sei es.", italian="Vuoi lottare, allora.[K]\nD'accordo. Anch'io sono pronto!", spanish="Así que quieres luchar.[K]\nPues que así sea."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7179) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" But can you win?[K] Against ME?", french="Mais as-tu la moindre chance\nde l'emporter?[K] Face à MOI?", german="Aber kannst du gewinnen?[K]\nGegen MICH?", italian="Pensi davvero di avere qualche\nsperanza?[K] Contro il sottoscritto?", spanish="Pero esta vez, ¿puedes ganar?[K]\n¿Estás seguro de que puedes derrotarme?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7690) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(12) [anim idle native]
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(15)
  GAME:FadeOut(true, 1) -- screen_WhiteOut
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(45)
  -- SetAnimation(2) [anim idle native]
  do local p=npc_npc_yonowaaru.Position; GROUND:MoveToPosition(npc_npc_yonowaaru, p.X+(0), p.Y+(-8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeIn(1)
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ([CS:N]Grovyle[CR] vanished?!)", french=" ([CS:N]Massko[CR] a disparu?!)", german=" ([CS:N]Reptain[CR] ist verschwunden?!?)", italian=" ([CS:N]Grovyle[CR] è scomparso?!)", spanish=" (¡¿[CS:N]Grovyle[CR] ha desaparecido?!)"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ([CS:N]Grovyle[CR] vanished?!)", french=" ([CS:N]Massko[CR] a disparu?!)", german=" ([CS:N]Reptain[CR] ist verschwunden?!?)", italian=" ([CS:N]Grovyle[CR] è scomparso?!)", spanish=" (¡¿[CS:N]Grovyle[CR] ha desaparecido?!)"})
  else
  SkySceneKit.say({english=" ([CS:N]Grovyle[CR] vanished?!)", french=" ([CS:N]Massko[CR] a disparu?!)", german=" ([CS:N]Reptain[CR] ist verschwunden?!?)", italian=" ([CS:N]Grovyle[CR] è scomparso?!)", spanish=" (¡¿[CS:N]Grovyle[CR] ha desaparecido?!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="That blasted [CS:N]Grovyle[CR]![K] He never\nintended to fight me at all!", french="Diantre, ce [CS:N]Massko[CR]![K] Il n'a jamais\neu l'intention de m'affronter!", german="Dieses Schlitzohr [CS:N]Reptain[CR]![K]\nEr hatte nie vor, gegen mich zu kämpfen!", italian="Quel maledetto [CS:N]Grovyle[CR]![K] Non ha\nmai avuto intenzione di lottare veramente!", spanish="¡Lo sabía! Dichoso [CS:N]Grovyle[CR].[K] ¡No\ntenía ninguna intención de luchar conmigo!"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" There's no escaping ME!", french=" On ne m'échappe pas, à MOI!", german=" Vor MIR gibt es kein Entkommen!", italian=" Ma non riuscirà a sfuggirmi!", spanish=" Pero es imposible evitarme."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7181) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=".................................\n(The great [CS:N]Dusknoir[CR] vanished too?!)", french=".................................\n(Le grand [CS:N]Noctunoir[CR] a disparu, lui aussi?!)", german=".................................\n(Der große [CS:N]Zwirrfinst[CR] ist auch\nverschwunden?!?)", italian=".................................\n(Anche [CS:N]Dusknoir[CR] è sparito, adesso?!)", spanish="(¿Eh? ¿El gran [CS:N]Dusknoir[CR] también\nha desaparecido?)"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=".................................\n(The great [CS:N]Dusknoir[CR] vanished too?!)", french=".................................\n(Le grand [CS:N]Noctunoir[CR] a disparu, lui aussi?!)", german=".................................\n(Der große [CS:N]Zwirrfinst[CR] ist auch\nverschwunden?!?)", italian=".................................\n(Anche [CS:N]Dusknoir[CR] è sparito, adesso?!)", spanish="(¿Eh? ¿El gran [CS:N]Dusknoir[CR] también\nha desaparecido?)"})
  else
  SkySceneKit.say({english=".................................\n(The great [CS:N]Dusknoir[CR] vanished too?!)", french=".................................\n(Le grand [CS:N]Noctunoir[CR] a disparu, lui aussi?!)", german=".................................\n(Der große [CS:N]Zwirrfinst[CR] ist auch\nverschwunden?!?)", italian=".................................\n(Anche [CS:N]Dusknoir[CR] è sparito, adesso?!)", spanish="(¿Eh? ¿El gran [CS:N]Dusknoir[CR] también\nha desaparecido?)"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=".................................\n(What just happened?! I don't understand!)", french=".................................\n(Qu'est-ce qui s'est passé?! J'y comprends\nrien!)", german=".................................\n(Was ist geschehen?!? Ich begreife das nicht!)", italian=".................................\n(Ma cosa sta succedendo? Davvero non\ncapisco!)", spanish="(¡¿Qué es lo que ha pasado?!\n¡No lo entiendo!)"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=".................................\n(What just happened?! I don't understand!)", french=".................................\n(Qu'est-ce qui s'est passé?! J'y comprends\nrien!)", german=".................................\n(Was ist geschehen?!? Ich begreife das nicht!)", italian=".................................\n(Ma cosa sta succedendo? Davvero non\ncapisco!)", spanish="(¡¿Qué es lo que ha pasado?!\n¡No lo entiendo!)"})
  else
  SkySceneKit.say({english=".................................\n(What just happened?! I don't understand!)", french=".................................\n(Qu'est-ce qui s'est passé?! J'y comprends\nrien!)", german=".................................\n(Was ist geschehen?!? Ich begreife das nicht!)", italian=".................................\n(Ma cosa sta succedendo? Davvero non\ncapisco!)", spanish="(¡¿Qué es lo que ha pasado?!\n¡No lo entiendo!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=".................................\n(Urgh... Trying to move, but I can't...)", french=".................................\n(Argh... J'ai beau essayer, impossible\nde bouger...)", german=".................................\n(Urgh... Ich kann mich nicht bewegen...)", italian=".................................\n(Urgh... Ancora non riesco a muovermi...)", spanish="(¡Uf! Por mucho que quiera, no\npuedo moverme.)"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=".................................\n(Urgh... Trying to move, but I can't...)", french=".................................\n(Argh... J'ai beau essayer, impossible\nde bouger...)", german=".................................\n(Urgh... Ich kann mich nicht bewegen...)", italian=".................................\n(Urgh... Ancora non riesco a muovermi...)", spanish="(¡Uf! Por mucho que quiera, no\npuedo moverme.)"})
  else
  SkySceneKit.say({english=".................................\n(Urgh... Trying to move, but I can't...)", french=".................................\n(Argh... J'ai beau essayer, impossible\nde bouger...)", german=".................................\n(Urgh... Ich kann mich nicht bewegen...)", italian=".................................\n(Urgh... Ancora non riesco a muovermi...)", spanish="(¡Uf! Por mucho que quiera, no\npuedo moverme.)"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=".................................\n(I can't...[K] Feeling faint...)", french=".................................\n(Je ne peux pas...[K] Je me sens faible...)", german=".................................\n(Ich kann nicht...[K] Mir ist schwindelig...)", italian=".................................\n(Mi sento...[K] venire meno...)", spanish=" (No puedo...[K] No puedo aguantar.)"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=".................................\n(I can't...[K] Feeling faint...)", french=".................................\n(Je ne peux pas...[K] Je me sens faible...)", german=".................................\n(Ich kann nicht...[K] Mir ist schwindelig...)", italian=".................................\n(Mi sento...[K] venire meno...)", spanish=" (No puedo...[K] No puedo aguantar.)"})
  else
  SkySceneKit.say({english=".................................\n(I can't...[K] Feeling faint...)", french=".................................\n(Je ne peux pas...[K] Je me sens faible...)", german=".................................\n(Ich kann nicht...[K] Mir ist schwindelig...)", italian=".................................\n(Mi sento...[K] venire meno...)", spanish=" (No puedo...[K] No puedo aguantar.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(72) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 288, 352, Direction.Up, "NPC_KIMAWARI")
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end) -- message_SetActor(ACTOR_NPC_KIMAWARI)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Eek! There! There they are!", french=" Hiii! Là-bas! Les voilà!", german=" Ieek! Da! Da sind sie!", italian=" Shock! Guardate! Eccoli laggiù!", spanish=" ¡Ay, ay! ¡Allí, están allí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 320, 384, Direction.Up, "NPC_HEIGANI")
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end) -- message_SetActor(ACTOR_NPC_HEIGANI)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! Come on, hurry!", french="Eh dis donc, vite, il faut\nse dépêcher!", german=" Hey, hey! Kommt, beeilt euch!", italian=" Ehi, ehi! Sbrigatevi, gente!", spanish=" ¡Oye, oye! ¡Vamos, rápido!"})
  -- message_Close
  pcall(function() GAME:MoveCamera(348, 288, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_kimawari, 288, 284, false, 2)
  GROUND:MoveToPosition(npc_npc_heigani, 316, 276, false, 2)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 368, 368, Direction.Up, "NPC_BIPPA")
  GROUND:MoveToPosition(npc_npc_bippa, 376, 292, false, 2)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 352, 392, Direction.Up, "NPC_DAGUTORIO")
  GROUND:MoveToPosition(npc_npc_dagutorio, 348, 300, false, 2)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 400, 376, Direction.Up, "NPC_DOGOOMU")
  GROUND:MoveToPosition(npc_npc_dogoomu, 400, 276, false, 2)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpRight)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Oh, golly! They're down!", french="Oh sapristi! Tout l'monde est\nK.O.!", german="Mannomann! Sie liegen am\nBoden!", italian="Ohibò! Sembrano avere qualche\nproblema...", spanish="¡Huy, huy! ¡Les han dejado fuera\nde combate!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! Are you all right?", french=" Eh dis donc, vous allez bien?", german=" Hey, hey! Ist alles in Ordnung?", italian=" Ehi, ehi! State bene?", spanish=" ¡Oye, oye! ¿Estáis bien?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" They're badly hurt!", french="Vous êtes vraiment mal\nen point!", german=" Sie sind schwer verletzt!", italian=" Stanno male!", spanish=" Están muy mal."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Hurry! We need to get them\nback to the guild for treatment!", french="Vite! Il faut les ramener à\nla Guilde pour les soigner!", german="Schnell! Wir müssen sie zur\nBehandlung in die Gilde bringen!", italian="Forza! Dobbiamo tornare\nimmediatamente alla Gilda!", spanish="¡Rápido! ¡Hay que llevarles\nal [CS:N]Pokégremio[CR] para que les atiendan!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" All right!", french=" D'accord!", german=" Okay!", italian=" Andiamo!", spanish=" ¡De acuerdo!"})
  -- message_Close
  do local p=npc_npc_heigani.Position; GROUND:MoveToPosition(npc_npc_heigani, p.X+(0), p.Y+(-48), false, 2) end
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(npc_npc_kimawari, 320, 252, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 376, 236, false, 2)
  GROUND:MoveToPosition(npc_npc_dagutorio, 348, 268, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 400, 228, false, 2)
  GROUND:MoveToPosition(npc_npc_heigani, 332, 228, false, 2)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- worldmap_SetMode(3) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetLevel(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_ChangeLevel(5) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetCamera(26) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="[CN]The clouds parted over\n[CN][CS:P]Crystal Crossing[CR] and the\n[CN]vicinities of the [CS:P]Forest Area[CR]!", french="[CN]Les nuages se sont dissipés au-dessus\n[CN]du [CS:P]Croisement Cristal[CR] et dans les environs\n[CN]de la [CS:P]Région Forestière[CR]!", german="[CN]Die Wolken über der [CS:P]Kristallstraße[CR]\n[CN]und dem [CS:P]Waldgebiet[CR] haben sich verzogen!", italian="[CN]Le nuvole si sollevano dal [CS:P]Bivio di Cristallo[CR]\n[CN]e dalle altre aree della [CS:P]Zona delle Foreste[CR]!", spanish="[CN]Las nubes que cubrían\n[CN]la [CS:P]Vía Cristalina[CR] y las inmediaciones\n[CN]de la [CS:P]zona boscosa[CR] se disiparon."})
  -- message_Close
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 1 -- $SCENARIO_MAIN_BIT_FLAG[8] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.COMPULSORY_SAVE_POINT = 13 -- $COMPULSORY_SAVE_POINT = 13 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
