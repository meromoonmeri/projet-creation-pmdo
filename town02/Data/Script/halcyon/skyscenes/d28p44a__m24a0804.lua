-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D28P44A/m24a0804.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_THE_POWER_OF_DARKNESS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_D28P44A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  pcall(function() GAME:MoveCamera(256, 236, 60, false) end) -- performer/caméra
  local npc_npc_yamirami4 = SkySceneKit.spawn_npc("sableye", 96, 240, Direction.Right, "NPC_YAMIRAMI4")
  GROUND:MoveToPosition(npc_npc_yamirami4, 120, 236, false, 2)
  local npc_npc_yamirami2 = SkySceneKit.spawn_npc("sableye", 72, 224, Direction.Right, "NPC_YAMIRAMI2")
  GROUND:MoveToPosition(npc_npc_yamirami2, 120, 220, false, 2)
  GROUND:MoveToPosition(partner, 120, 236, false, 2)
  local npc_npc_yamirami6 = SkySceneKit.spawn_npc("sableye", 72, 256, Direction.Right, "NPC_YAMIRAMI6")
  GROUND:MoveToPosition(npc_npc_yamirami6, 120, 252, false, 2)
  GROUND:MoveToPosition(hero, 120, 228, false, 2)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 48, 240, Direction.Left, "NPC_JUPUTORU")
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_juputoru, 120, 236, false, 2) -- SlidePositionMark (glissement)
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 48, 224, Direction.Right, "NPC_YAMIRAMI")
  GROUND:MoveToPosition(npc_npc_yamirami, 120, 220, false, 2)
  local npc_npc_yamirami5 = SkySceneKit.spawn_npc("sableye", 48, 256, Direction.Right, "NPC_YAMIRAMI5")
  GROUND:MoveToPosition(npc_npc_yamirami5, 120, 252, false, 2)
  local npc_npc_yamirami3 = SkySceneKit.spawn_npc("sableye", 24, 240, Direction.Right, "NPC_YAMIRAMI3")
  GROUND:MoveToPosition(npc_npc_yamirami3, 120, 236, false, 2)
  GAME:FadeIn(30)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_yamirami4.Position; GROUND:MoveToPosition(npc_npc_yamirami4, p.X+(18), p.Y+(8), false, 2) end -- Slide2PositionOffset
  GROUND:MoveToPosition(npc_npc_yamirami4, 288, 244, false, 2)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_yamirami2.Position; GROUND:MoveToPosition(npc_npc_yamirami2, p.X+(18), p.Y+(8), false, 2) end -- Slide2PositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(18), p.Y+(8), false, 2) end -- Slide2PositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_yamirami6.Position; GROUND:MoveToPosition(npc_npc_yamirami6, p.X+(18), p.Y+(8), false, 2) end -- Slide2PositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(18), p.Y+(8), false, 2) end -- Slide2PositionOffset
  GROUND:MoveToPosition(npc_npc_yamirami2, 264, 228, false, 2)
  GROUND:MoveToPosition(partner, 264, 244, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami6, 264, 260, false, 2)
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(18), p.Y+(8), false, 2) end -- Slide2PositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(18), p.Y+(8), false, 2) end -- Slide2PositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(18), p.Y+(8), false, 2) end -- Slide2PositionOffset
  GROUND:MoveToPosition(hero, 252, 236, false, 2)
  GROUND:MoveToPosition(npc_npc_juputoru, 240, 244, false, 2) -- SlidePositionMark (glissement)
  GROUND:MoveToPosition(npc_npc_yamirami, 240, 228, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami5, 240, 260, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_yamirami3.Position; GROUND:MoveToPosition(npc_npc_yamirami3, p.X+(18), p.Y+(8), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(npc_npc_yamirami3, 216, 244, false, 2)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_yamirami4, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_yamirami2, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_yamirami6, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami, Direction.Down)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Up)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 104, 224, Direction.Right, "NPC_YONOWAARU")
  GROUND:MoveToPosition(npc_npc_yonowaaru, 120, 220, false, 2)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  do local p=npc_npc_yonowaaru.Position; GROUND:MoveToPosition(npc_npc_yonowaaru, p.X+(18), p.Y+(8), false, 2) end -- Slide2PositionOffset
  GROUND:MoveToPosition(npc_npc_yonowaaru, 200, 196, false, 2)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey![K] There's the dimensional\nhole!", french="Regardez![K] C'est le gouffre\ndimensionnel!", german="Hey![K] Da ist ein dimensionales\nLoch!", italian=" Ehi![K] C'è il tunnel dimensionale!", spanish=" ¡Mirad![K] ¡El agujero dimensional!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hey![K] There's the dimensional\nhole!", french="Regardez![K] C'est le gouffre\ndimensionnel!", german="Hey![K] Da ist ein dimensionales\nLoch!", italian=" Ehi![K] C'è il tunnel dimensionale!", spanish=" ¡Mirad![K] ¡El agujero dimensional!"})
  else
  SkySceneKit.say({english="Hey![K] There's the dimensional\nhole!", french="Regardez![K] C'est le gouffre\ndimensionnel!", german="Hey![K] Da ist ein dimensionales\nLoch!", italian=" Ehi![K] C'è il tunnel dimensionale!", spanish=" ¡Mirad![K] ¡El agujero dimensional!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" [CS:N]Sableye[CR]!", french=" [CS:N]Ténéfix[CR]!", german=" [CS:N]Zobiris[CR]!", italian=" [CS:N]Sableye[CR]!", spanish=" ¡[CS:N]Sableye[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami2, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami3, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami4, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami5, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami6, npc_npc_yonowaaru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Into the dimensional hole with\nthem!", french="Allez, tous dans le gouffre\ndimensionnel!", german=" Ins dimensionale Loch mit ihnen!", italian="Entrate con loro nel tunnel\ndimensionale.", spanish=" ¡Al agujero con ellos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CS:N]Sableye[CR]: Wheh-heh-heh!", french="[CS:N]Ténéfix[CR]: Whé hé hé!", german="[CS:N]Zobiris[CR]: Wähähäh!", italian="[CS:N]Sableye[CR]: Meh-eh-eh-eh!", spanish="[CS:N]Sableye[CR]: ¡Je, je, je, je!"})
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- message_Close
  GROUND:EntTurn(npc_npc_yamirami, Direction.Down)
  GROUND:EntTurn(npc_npc_yamirami2, Direction.Down)
  GROUND:EntTurn(npc_npc_yamirami3, Direction.Right)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.Left)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Left)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Psst...[partner]...\nand [hero]...", french="Psst... [partner]...\net [hero]...", german="Psst... [partner]...\nund [hero]...", italian="Psss... [partner]...\ne [hero]...", spanish="Pss... [partner]...\n[hero]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...Yeah?", french=" ... Quoi?", german=" ...Ja?", italian=" ... Sì?", spanish=" ¿Sí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...Yes?", french=" ... Quoi?", german=" ...Ja?", italian=" ... Sì?", spanish=" ¿Sí?"})
  else
  SkySceneKit.say({english=" ...Yep?", french=" ... Quoi?", german=" ...Jep?", italian=" ... Sì?", spanish=" ¿Sí?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...I'm with you!)", french="(... Ça marche, je vous suis!)", german="(Ich bin dabei!)", italian="(Io sono con voi!)", spanish="(De acuerdo.)"})
  else
  SkySceneKit.say({english="(...I'm with you!)", french="(... Ça marche, je vous suis!)", german="(Ich bin dabei!)", italian="(Io sono con voi!)", spanish="(De acuerdo.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(13) [anim idle native]
  -- SetAnimation(13) [anim idle native]
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(10)
  -- GAP: se_Play(5126) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:N]Sableye[CR]: Gyaaaah!", french="[CS:N]Ténéfix[CR]: Gyaaaah!", german="[CS:N]Zobiris[CR]: Gyaaaah!", italian="[CS:N]Sableye[CR]: Aaaaah!", spanish="[CS:N]Sableye[CR]: ¡Yaaaa!"})
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(0), p.Y+(-40), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_yamirami2.Position; GROUND:MoveToPosition(npc_npc_yamirami2, p.X+(0), p.Y+(-40), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_yamirami3.Position; GROUND:MoveToPosition(npc_npc_yamirami3, p.X+(-40), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_yamirami4.Position; GROUND:MoveToPosition(npc_npc_yamirami4, p.X+(40), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(-16), p.Y+(24), false, 2) end -- Slide2PositionOffset
  do local p=npc_npc_yamirami6.Position; GROUND:MoveToPosition(npc_npc_yamirami6, p.X+(16), p.Y+(24), false, 2) end -- Slide2PositionOffset
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Well, well...[K] You display some\nfeeble resistance, knowing that it's futile?", french="Eh bien, eh bien...[K] C'est\npathétique! Ne comprenez-vous pas\nque toute résistance est inutile?", german="So, so...[K] Ihr entwickelt ein\nwenig kläglichen Widerstand, obwohl ihr wisst,\ndass das völlig vergeblich ist?", italian="Bene, bene...[K] Opponete una\ndebole resistenza, pur sapendo che è\ntutto inutile?", spanish="Bueno, bueno...[K]\n¿Es que no sabéis que es inútil resistirse?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" You expected anything less?", french=" Tu t'attendais à autre chose?", german=" Hast du was anderes erwartet?", italian=" Cosa ti aspettavi?", spanish=" ¿Esperabas menos de nosotros?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Humph.[K] You leave me no choice.", french="Pfff![K] Vous ne me laissez donc\npas le choix.", german="Grmpf.[K] Ihr lasst mir keine\nWahl.", italian="Bah.[K] Non mi lasciate altra\nscelta.", spanish=" Bah.[K] No me dejáis elección."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_yonowaaru, 252, 196, false, 2)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(-32), p.Y+(0), false, 2) end
  do local p=npc_npc_yamirami2.Position; GROUND:MoveToPosition(npc_npc_yamirami2, p.X+(32), p.Y+(0), false, 2) end
  GROUND:EntTurn(npc_npc_juputoru, Direction.Up)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami, Direction.DownRight)
  GROUND:EntTurn(npc_npc_yamirami2, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(partner, 280, 244, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_juputoru, 224, 244, false, 2)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_juputoru, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I'll simply defeat you here, then\ntake you to the future. It makes no difference\nto me.", french="Je m'en vais donc vous\nterrasser, après quoi je vous emmènerai dans\nle futur. Je n'y vois guère de différence.", german="Ich werde euch einfach hier\nbesiegen und mit in die Zukunft nehmen. Das\nmacht keinen Unterschied für mich.", italian="Vi sconfiggerò qui, e poi vi\nporterò nel futuro. Per me non cambia niente.", spanish="Os derrotaré aquí mismo y,\nluego, os llevaré al futuro. A mí, el orden\nme da exactamente lo mismo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Urgh...", french=" Argh...", german=" Umpf...", italian=" Uh...", spanish=" Grr..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="The odds are overwhelmingly\nstacked against you.", french="Rendez-vous, le combat est\nperdu d'avance.", german=" Ihr habt keine Chance!", italian=" Non avete alcuna possibilità.", spanish="Estáis en una situación de\nalarmante desventaja."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="How much resistance can you\neven serve up?", french="Voyons combien de temps vous\npourrez résister!", german="Wie viel Widerstand könnt ihr\nüberhaupt aufbringen?", italian=" Per quanto potrete resistere?", spanish="¿Cuánto más creéis que podéis\nresistir?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Show me!", french=" Montrez-moi ce que vous valez!", german=" Zeigt es mir!", italian=" Fatemi vedere cosa sapete fare!", spanish=" ¡Veámoslo!"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Swarm them!", french=" Encerclez-les!", german=" Umzingelt sie!", italian=" Tutti addosso!", spanish=" ¡A por ellos!"})
  -- message_Close
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(40, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
