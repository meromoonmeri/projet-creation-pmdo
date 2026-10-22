-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D12P41A/m12a0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(19, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  SkyProg.set(13, 4) -- $SCENARIO_MAIN = scn[13,4] (ROM)
  -- back_SetGround(LEVEL_D12P41A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 3) -- screen_WhiteOut
  GAME:WaitFrames(3)
  GAME:FadeIn(3)
  GAME:WaitFrames(90)
  -- GAP: se_Play(6424) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(60)
  GROUND:MoveToPosition(partner, 260, 268, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(hero, 292, 268, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 276, 300, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 308, 300, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk! This is a scary place!", french="Argh, cet endroit ne me dit rien\nqui vaille!", german=" Urk! Dieser Ort ist unheimlich!", italian="Wow! Questo posto mette i\nbrividi, non credi?", spanish=" ¡Huy! ¡Qué lugar tan siniestro!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk! What a menacing place!", french="Argh, cet endroit ne me dit rien\nqui vaille!", german="Urk! Was für ein bedrohlicher\nOrt!", italian="Ooh! Questo posto è veramente\nspaventoso, non credi?", spanish=" ¡Huy! ¡Qué lugar tan siniestro!"})
  else
  SkySceneKit.say({english=" Urk! What an intimidating place!", french="Argh, cet endroit ne me dit rien\nqui vaille!", german="Urk! Dieser Ort macht mir\nAngst!", italian="Ooh! Questo posto è veramente\nspaventoso, non credi?", spanish="¡Huy! ¡Qué lugar tan\namenazador!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 3) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(3)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waah!", french=" Ouaaah!", german=" Waah!", italian=" Aaah!", spanish=" ¡Aaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah!", french=" Ouaaah!", german=" Waah!", italian=" Aaah!", spanish=" ¡Aaah!"})
  else
  SkySceneKit.say({english=" Waah!", french=" Ouaaah!", german=" Waah!", italian=" Aaah!", spanish=" ¡Aaah!"})
  end
  GAME:WaitFrames(60)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6424) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(60)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's incredible! It looks like\nlightning can strike this place anytime!", french="C'est dément! On dirait que\nla foudre peut frapper cet endroit\nà tout instant!", german="Das ist unglaublich! An diesem\nOrt scheint jederzeit der Blitz einschlagen zu\nkönnen!", italian="Hai visto? Sembra che cadano\nfulmini di continuo qui!", spanish="¡Qué miedo! ¡Da la sensación de\nque en cualquier momento te va a caer un\nrayo encima!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's incredible! It looks like\nlightning can strike this place anytime!", french="C'est dément! On dirait que\nla foudre peut frapper cet endroit\nà tout instant!", german="Das ist unglaublich! Es sieht so\naus, als wenn hier jederzeit der Blitz\neinschlagen kann!", italian="Hai visto? Sembra che cadano\nfulmini di continuo qui!", spanish="¡Qué miedo! ¡Da la sensación de\nque en cualquier momento te va a caer un\nrayo encima!"})
  else
  SkySceneKit.say({english="How frightening! It seems like\nlightning can strike here anytime!", french="C'est dément! On dirait que\nla foudre peut frapper cet endroit\nà tout instant!", german="Wie beängstigend! Es sieht so\naus, als wenn hier jederzeit der Blitz\neinschlagen kann!", italian="Hai visto? Sembra che cadano\nfulmini di continuo qui!", spanish="¡Qué miedo! ¡Da la sensación de\nque en cualquier momento te va a caer un\nrayo encima!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We should get away from a\nplace this harsh as fast as...[K] Huh?", french="On ferait mieux de quitter\ncet endroit aussi vite que...[K] Hein?", german="Am besten verlassen wir diesen\ngefährlichen Ort so schnell wie...[K] Huch?", italian="Da un posto come questo\ndovremmo andarcene veloci come...[K] Uh?", spanish="Deberíamos alejarnos de este\nsitio lo antes...[K] ¿Eh?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We should get away from a\nplace this scary as fast as...[K] Huh?", french="On ferait mieux de quitter\ncet endroit aussi vite que...[K] Hein?", german="Am besten verlassen wir diesen\ngefährlichen Ort so schnell wie...[K] Huch?", italian="Da un posto come questo\ndovremmo andarcene veloci come...[K] Uh?", spanish="Deberíamos alejarnos de este\nsitio lo antes...[K] ¿Eh?"})
  else
  SkySceneKit.say({english="We should get away from a\nplace this scary as fast as...[K] Huh?", french="On ferait mieux de quitter\ncet endroit aussi vite que...[K] Hein?", german="Am besten verlassen wir diesen\ngefährlichen Ort so schnell wie...[K] Huch?", italian="Da un posto come questo\ndovremmo andarcene di corsa...[K] Uh?", spanish="Deberíamos alejarnos de este\nsitio lo antes...[K] ¿Eh?"})
  end
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Over there!", french=" Là-bas!", german=" Dort drüben!", italian=" Laggiù! Guarda!", spanish=" ¡Mira allí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Over there!", french=" Là-bas!", german=" Dort drüben!", italian=" Laggiù! Guarda!", spanish=" ¡Mira allí!"})
  else
  SkySceneKit.say({english=" Over there!", french=" Là-bas!", german=" Dort drüben!", italian=" Laggiù! Guarda!", spanish=" ¡Mira allí!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-80), 80, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(60)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(80), 80, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Is that the [CS:Z]Water Float[CR],\n[hero]?", french="Ce ne serait pas l'[CS:Z]Hydroflotteur[CR],\n[hero]?", german="Ist das der [CS:Z]Schwimmreif[CR],\n[hero]?", italian="[hero]? Non è l'[CS:Z]Acquaboa[CR]\nquella?", spanish="¿Es ese el [CS:Z]Flotarill[CR],\n[hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Is that it, [hero]?\nThe [CS:Z]Water Float[CR]?", french="Ce ne serait pas l'[CS:Z]Hydroflotteur[CR],\n[hero]?", german="Ist er das, [hero]?\nDer [CS:Z]Schwimmreif[CR]?", italian="La vedi anche tu, [hero]?\nÈ l'[CS:Z]Acquaboa[CR], vero?", spanish="¿Es ese el [CS:Z]Flotarill[CR],\n[hero]?"})
  else
  SkySceneKit.say({english="Could that be the [CS:Z]Water Float[CR],\n[hero]?", french="Ce ne serait pas l'[CS:Z]Hydroflotteur[CR],\n[hero]?", german="Könnte das der [CS:Z]Schwimmreif[CR]\nsein, [hero]?", italian="La vedi anche tu, [hero]?\nÈ l'[CS:Z]Acquaboa[CR], vero?", spanish="¿Es ese el [CS:Z]Flotarill[CR],\n[hero]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's get a closer look.", french=" Allons voir ça de plus près.", german=" Sehen wir uns das genauer an.", italian="Andiamo a dare un'occhiata da\nvicino.", spanish=" Acerquémonos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's get a closer look.", french=" Allons voir ça de plus près.", german=" Sehen wir uns das genauer an.", italian="Andiamo a dare un'occhiata da\nvicino.", spanish=" Acerquémonos."})
  else
  SkySceneKit.say({english=" Let's get a closer look.", french=" Allons voir ça de plus près.", german=" Sehen wir uns das genauer an.", italian="Andiamo a dare un'occhiata da\nvicino.", spanish=" Acerquémonos."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-16), false, 2) end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-16), false, 2) end
  GAME:WaitFrames(2)
  do local p=SkySceneKit.team_member(1).Position; GROUND:MoveToPosition(SkySceneKit.team_member(1), p.X+(0), p.Y+(-16), false, 2) end
  GAME:WaitFrames(3)
  do local p=SkySceneKit.team_member(2).Position; GROUND:MoveToPosition(SkySceneKit.team_member(2), p.X+(0), p.Y+(-16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6925) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 5) -- screen_FadeChange vers alpha 128 (assombrissement, adaptation)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(16), 6, false) end) -- MovePositionOffset performer/caméra
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(28), false, 2) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(28), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  -- SetAnimation(5) [anim idle native]
  do local p=SkySceneKit.team_member(1).Position; GROUND:MoveToPosition(SkySceneKit.team_member(1), p.X+(0), p.Y+(28), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2)
  -- SetAnimation(5) [anim idle native]
  do local p=SkySceneKit.team_member(2).Position; GROUND:MoveToPosition(SkySceneKit.team_member(2), p.X+(0), p.Y+(28), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wa-waah!", french=" Ouaaah!", german=" Wa-haah!", italian=" Aaaaaah!!!", spanish=" ¡Aaaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wa-waah!", french=" Ouaaah!", german=" Wa-haah!", italian=" Aaaaaah!!!", spanish=" ¡Aaaah!"})
  else
  SkySceneKit.say({english=" Wa-waah!", french=" Ouaaah!", german=" Wa-haah!", italian=" Aaaaaah!!!", spanish=" ¡Aaaah!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Why did you come here?!", french=" Qu'est-ce que vous faites ici?!", german=" Weshalb seid ihr hergekommen?!?", italian=" Cosa fate qui?", spanish=" ¡¿Por qué habéis venido aquí?!"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" This is our territory!", french=" Ceci est notre territoire!", german=" Dies ist unser Revier!", italian=" Questo è il nostro territorio!", spanish=" ¡Este es nuestro territorio!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Someone's here![K]\nHide, [hero]!", french="Il y a quelqu'un ici![K]\nCachons-nous, [hero]!", german="Hier ist jemand![K]\nVerstecken wir uns, [hero]!", italian="C'è qualcuno![K]\nNascondiamoci, [hero]!", spanish="¡Hay alguien aquí![K]\n¡Escondámonos, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There's someone here![K]\nHide, [hero]!", french="Il y a quelqu'un ici![K]\nCachons-nous, [hero]!", german="Hier ist jemand![K]\nVerstecken wir uns, [hero]!", italian="C'è qualcuno![K]\nNascondiamoci, [hero]!", spanish="¡Hay alguien aquí![K]\n¡Escondámonos, [hero]!"})
  else
  SkySceneKit.say({english="There's someone here![K]\nLet's hide, [hero]!", french="Il y a quelqu'un ici![K]\nCachons-nous, [hero]!", german="Hier ist jemand![K]\nVerstecken wir uns, [hero]!", italian="C'è qualcuno![K]\nNascondiamoci, [hero]!", spanish="¡Hay alguien aquí![K]\n¡Escondámonos, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 324, 268, false, 2)
  GROUND:MoveToPosition(partner, 304, 268, false, 2)
  GAME:WaitFrames(3)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 316, 292, false, 2) end end
  GAME:WaitFrames(2)
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 340, 292, false, 2) end end
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(5) -- screen_FadeChange vers alpha 256 (éclaircissement, adaptation)
  GAME:WaitFrames(2)
  GAME:FadeOut(false, 5) -- screen_FadeChange vers alpha 128 (assombrissement, adaptation)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(5) -- screen_FadeChange vers alpha 256 (éclaircissement, adaptation)
  GAME:WaitFrames(2)
  GAME:FadeOut(false, 5) -- screen_FadeChange vers alpha 128 (assombrissement, adaptation)
  GAME:WaitFrames(2) -- join WaitSe
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="Hee hee hee. So you're going to hide\nlike that?[K] That's kind of cute...", french="Hin hin hin. Alors vous comptez vous\ncacher longtemps comme ça?[K]\nComme c'est attendrissant...", german="Hehehe. Ihr wollt euch also\nverstecken?[K] Wie niedlich...", italian="Eh eh eh! Allora avete intenzione di\nnascondervi?[K] Divertente...", spanish="Ji, ji, ji. ¿Así que os vais a\nesconder?[K] Qué monadas..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="All right. [K]We'd actually be grateful\nif you kept doing that.", french="Très bien. [K]En fait, on vous en serait\nmême reconnaissants, si vous pouviez\ncontinuer à vous cacher.", german="Schon gut. [K]Um ehrlich zu sein, wären wir\neigentlich recht dankbar, wenn ihr so\nweitermachen würdet.", italian=" E va bene.[K] Per noi è anche meglio.", spanish="Está bien.[K] En realidad os agradeceríamos\nque siguierais haciéndolo."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="We'll sneak quietly to get as close\nas we can...", french="On va se rapprocher le plus près possible,\nà pas feutrés...", german="Wir schleichen uns leise so nah wie\nmöglich heran...", italian="Ci muoveremo furtivamente\nper avvicinarci il più possibile...", spanish="Vamos a acercarnos sigilosamente\ntodo lo que podamos..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" All right... [K]Let's take them out!", french=" Très bien... [K]Occupons-nous-en!", german=" Alles klar... [K]Machen wir sie fertig!", italian=" Ok...[K] Andiamo a prenderli!", spanish="Muy bien...[K] ¡Vamos a darles\nun escarmiento!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(5) -- screen_FadeChange vers alpha 256 (éclaircissement, adaptation)
  GAME:WaitFrames(2)
  GAME:FadeOut(false, 5) -- screen_FadeChange vers alpha 128 (assombrissement, adaptation)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(5) -- screen_FadeChange vers alpha 256 (éclaircissement, adaptation)
  GAME:WaitFrames(2)
  GAME:FadeOut(false, 5) -- screen_FadeChange vers alpha 128 (assombrissement, adaptation)
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Argh! [K]No way![K]\nWe'll be taken out if we stay here!", french="Argh! [K]Mauvaise idée![K] On va\npasser un sale quart d'heure si on reste ici!", german="Argh! [K]Keine Chance![K]\nSie machen uns fertig, wenn wir hierbleiben!", italian="Argh![K] Oh no![K]\nSe rimaniamo qui ce la vedremo brutta!", spanish="¡Ah![K] ¡No puede ser![K]\n¡Será el fin si nos quedamos aquí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Ugh... [K]Not like this![K]\nIf we stay here, it's over!", french="Argh! [K]Mauvaise idée![K] On va\npasser un sale quart d'heure si on reste ici!", german="Uff... [K]Nicht so![K]\nWenn wir hierbleiben, ist es vorbei!", italian="Ugh...[K] No![K]\nSe restiamo qui, è finita!", spanish="Uf...[K] ¡Así no![K]\n¡Si nos quedamos, se acabó!"})
  else
  SkySceneKit.say({english="Oh...[K]this is not good![K]\nWe'll surely be defeated if we stay here!", french="Argh! [K]Mauvaise idée![K] On va\npasser un sale quart d'heure si on reste ici!", german="Oh... [K]Das ist nicht gut![K]\nWenn wir hierbleiben, war es das für uns!", italian="Oh...[K] Non va bene per niente![K]\nSe rimaniamo qui ci batteranno di sicuro!", spanish="Vaya...[K] ¡Esto no funciona![K]\n¡Nos van a vencer si nos quedamos aquí!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 260, 268, false, 2)
  GROUND:MoveToPosition(hero, 292, 268, false, 2)
  GAME:WaitFrames(3)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 276, 292, false, 2) end end
  GAME:WaitFrames(2)
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 308, 292, false, 2) end end
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(hero, Direction.Up)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Who are you?![K] Come out!", french=" Qui es-tu?![K] Montre-toi!", german=" Wer bist du?!?[K] Komm raus!", italian=" Chi sei?[K] Vieni fuori!", spanish=" ¡¿Quién eres?![K] ¡No te escondas!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Who are you?![K] Show yourself!", french=" Qui es-tu?![K] Montre-toi!", german=" Wer bist du?!?[K] Zeig dich!", italian=" Chi sei?[K] Vieni fuori!", spanish=" ¡¿Quién eres?![K] ¡Déjate ver!"})
  else
  SkySceneKit.say({english=" Who are you?![K] Show yourself!", french=" Qui es-tu?![K] Montre-toi!", german=" Wer bist du?!?[K] Zeig dich!", italian=" Chi sei?[K] Vieni fuori!", spanish=" ¡¿Quién eres?![K] ¡Déjate ver!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Ha ha ha!", french=" Ha ha ha!", german=" Hahaha!", italian=" Ah ah ah!", spanish=" ¡Ja, ja, ja!"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" My name is [CS:N]Manectric[CR]!", french=" Je m'appelle [CS:N]Elecsprint[CR]!", german=" Mein Name ist [CS:N]Voltenso[CR]!", italian=" Mi chiamo [CS:N]Manectric[CR]!", spanish=" Me llamo [CS:N]Manectric[CR]."})
  local npc_npc_raiboruto = SkySceneKit.spawn_npc("manectric", 280, 224, Direction.Down, "NPC_RAIBORUTO")
  pcall(function() UI:SetSpeaker(npc_npc_raiboruto) end) -- message_SetActor(ACTOR_NPC_RAIBORUTO)
  pcall(function() UI:SetSpeaker(npc_npc_raiboruto) end)
  SkySceneKit.say({english="I am...[K]\nI am the leader of these [CS:N]Electrike[CR]!", french="Je suis...[K]\nJe suis le chef de ces [CS:N]Dynavolt[CR]!", german="Ich bin...[K]\nIch bin der Anführer dieser [CS:N]Frizelbliz[CR]!", italian="Sono...[K]\nSono il leader di questi [CS:N]Electrike[CR]!", spanish="Soy...[K] ¡Soy el líder de\nestos [CS:N]Electrike[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(0) -- screen_FadeChange vers alpha 256 (éclaircissement, adaptation)
  GAME:FadeOut(true, 3) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(3)
  GAME:FadeOut(false, 5) -- screen_FadeChange vers alpha 0 (assombrissement, adaptation)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(10)
  GAME:FadeIn(5) -- screen_FadeChange vers alpha 256 (éclaircissement, adaptation)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaaah!", french=" Ouaaah!", german=" Waaaah!", italian=" Aaaah!", spanish=" ¡Aaaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaaah!", french=" Ouaaah!", german=" Waaaah!", italian=" Aaaah!", spanish=" ¡Aaaah!"})
  else
  SkySceneKit.say({english=" Waaaah!", french=" Ouaaah!", german=" Waaaah!", italian=" Aaaah!", spanish=" ¡Aaaah!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_raiboruto) end)
  SkySceneKit.say({english=" Now, prepare to fight!", french=" Préparez-vous à combattre!", german="Nun macht euch bereit, zu\nkämpfen!", italian=" E ora, preparatevi a lottare!", spanish=" Ahora, ¡preparaos para luchar!"})
  -- message_Close
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
  -- main_EnterDungeon(19, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
