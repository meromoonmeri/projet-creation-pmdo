-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D21P41A/m18b1301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D21P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 376, 176, Direction.Left, "NPC_JUPUTORU")
  -- SetAnimation(29) [anim idle native]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  local npc_npc_mikaruge = SkySceneKit.spawn_npc("spiritomb", 328, 232, Direction.Down, "NPC_MIKARUGE")
  -- SetAnimation(44) [anim idle native]
  -- GAP: BGM BGM_STATIC_NOISE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english=" UGGGH...OOOOH...ARRGH!", french=" ARGGGH... OOOOH... ARRGH!", german=" UGGGH... UUUUH... ARRGH!", italian=" UGGGH... OOOOH... ARRGH!", spanish=" ¡AAAH! ¡OOOOH...! ¡AAAH!"})
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english=" OOOOH...ARRGH! ...[K]GWAAAAAAH!", french=" OOOOH... ARRGH! ...[K] AAAAAAH!", german=" UUUUH... ARRGH! ...[K]GWAAAAAAH!", italian=" OOOOH... ARRGH![K] AAAAAAAAH!", spanish=" ¡AAAH! ¡OOOOH...![K] ¡AAAH!"})
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
  GAME:WaitFrames(2) -- join WaitSe
  -- bgm2_PlayFadeIn(BGM_EARTHQUAKE1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa! Wh-what's happening?", french=" Ouah! Qu'est-ce qui se passe?", german=" Boah! W-was passiert hier?", italian=" Wow! C-Cosa sta succedendo?", spanish=" ¡Vaya! ¿Qué... qué ocurre?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah! Wh-what's happening?", french=" Ouah! Qu'est-ce qui se passe?", german=" Waah! W-was passiert hier?", italian=" Aaah! C-Cosa sta succedendo?", spanish=" ¡Vaya! ¿Qué... qué ocurre?"})
  else
  SkySceneKit.say({english=" Waah! Wh-what's happening?", french=" Ouah! Qu'est-ce qui se passe?", german=" Waah! W-was passiert hier?", italian=" Aaah! C-Cosa sta succedendo?", spanish=" ¡Vaya! ¿Qué... qué ocurre?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english="UGWAAAAAAAAAAH![K]\nGAAAAAAAAH!", french="AAAAAAAAAAH![K]\nGAAAAAAAAH!", german="UGWAAAAAAAAAAH![K]\nGAAAAAAAAH!", italian=" AAAAAAAAAAAAH![K] AAAAAAAAH!", spanish=" ¡UAAAAAAH![K] ¡AAAAAAAH!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- GAP: se_Play(7429) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(26) [anim idle native]
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(60)
  -- MoveHeight(2, 8) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(1)
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end) -- message_SetActor(ACTOR_NPC_MIKARUGE)
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english=" Eeep!", french=" Hiiii!", german=" Ieep!", italian=" Eeeh!", spanish=" ¡No!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7428) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D21P41A1_61) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(19) [anim idle native]
  -- Slide2PositionMark<object OBJECT_D21P41A1_61> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D21P41A1_61) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitSe
  GAME:WaitFrames(60)
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- MoveHeight(2, 8) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(1)
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end) -- message_SetActor(ACTOR_NPC_MIKARUGE)
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english=" Eeep!", french=" Hiiii!", german=" Ieep!", italian=" Eeeh!", spanish=" ¡Aaaah!"})
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english=" R-r-run away!", french=" F-f-fuyons!", german=" L-l-lauft weg!", italian=" C-C-Corriamo via!", spanish=" ¡Va... vámonos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7447) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(47) [anim idle native]
  -- SetAnimation(1024) [anim idle native]
  GROUND:MoveToPosition(npc_npc_mikaruge, 136, 228, false, 2)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitSe
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Wh-what was that...?[K]\nWhat was all that about?", french="Qu'est-ce que...?[K]\nQu'est-ce que c'était que ça?", german="W-was war das?[K]\nWas hatte das alles zu bedeuten?", italian="C-Cosa era...?[K]\nDi cosa si trattava?", spanish="¿Pero qué...?[K]\n¿Qué acaba de pasar aquí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Wh-what was that...?[K]\nWhat was all that about?", french="Qu'est-ce que...?[K]\nQu'est-ce que c'était que ça?", german="W-was war das?[K]\nWas hatte das alles zu bedeuten?", italian="C-Cosa era...?[K]\nDi cosa si trattava?", spanish="¿Pero qué...?[K]\n¿Qué acaba de pasar aquí?"})
  else
  SkySceneKit.say({english="Wh-what was that...?[K]\nWhat was all that about?", french="Qu'est-ce que...?[K]\nQu'est-ce que c'était que ça?", german="W-was war das?[K]\nWas hatte das alles zu bedeuten?", italian="C-Cosa era...?[K]\nDi cosa si trattava?", spanish="¿Pero qué...?[K]\n¿Qué acaba de pasar aquí?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" They got spooked and ran.", french=" Il a pris peur et s'est enfui.", german=" Sie sind vor Angst weggelaufen.", italian=" Si è spaventato ed è corso via.", spanish=" Se asustaron y han escapado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Grovyle[CR]!", french=" [CS:N]Massko[CR]!", german=" [CS:N]Reptain[CR]!", italian=" [CS:N]Grovyle[CR]!", spanish=" ¡[CS:N]Grovyle[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Grovyle[CR]!", french=" [CS:N]Massko[CR]!", german=" [CS:N]Reptain[CR]!", italian=" [CS:N]Grovyle[CR]!", spanish=" ¡[CS:N]Grovyle[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]Grovyle[CR]!", french=" [CS:N]Massko[CR]!", german=" [CS:N]Reptain[CR]!", italian=" [CS:N]Grovyle[CR]!", spanish=" ¡[CS:N]Grovyle[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(372, 192, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 372, 196, false, 2)
  GROUND:MoveToPosition(partner, 336, 172, false, 2)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Are you all right?", french=" Tu vas bien?", german=" Ist alles okay?", italian=" Sei tutto intero?", spanish=" ¿Estás bien?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Are you all right?", french=" Tu vas bien?", german=" Ist alles okay?", italian=" Stai bene?", spanish=" ¿Estás bien?"})
  else
  SkySceneKit.say({english=" Are you all right?", french=" Tu vas bien?", german=" Ist alles okay?", italian=" Stai bene?", spanish=" ¿Estás bien?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Yeah... I'll be fine...", french=" Ouais... ça va aller...", german=" Ja, es geht schon...", italian=" Sì... Non è niente di grave...", spanish=" Sí... No os preocupéis..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Can you get up?", french=" Tu peux te relever?", german=" Kannst du aufstehen?", italian=" Riesci ad alzarti?", spanish=" ¿Puedes levantarte?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Can you get up?", french=" Tu peux te relever?", german=" Kannst du aufstehen?", italian=" Riesci ad alzarti?", spanish=" ¿Puedes levantarte?"})
  else
  SkySceneKit.say({english=" Can you get up?", french=" Tu peux te relever?", german=" Kannst du aufstehen?", italian=" Riesci ad alzarti?", spanish=" ¿Puedes levantarte?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Somehow...[K] Urk!", french=" Il le faut...[K] argh!", german=" Irgendwie...[K] Urk!", italian=" In qualche modo...[K] Ah!", spanish=" Más o menos...[K] ¡Ay!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(31) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" That Pokémon...[K] It was cunning.", french="Ce Pokémon...[K] était sacrément\nrusé.", german="Dieses Pokémon...[K]\nEs war unheimlich gerissen.", italian=" Quel Pokémon...[K] era scaltro.", spanish=" Ese Pokémon...[K] era muy astuto."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="It went up my nose and took\ncontrol of my body...", french="Il a pris possession de\nmon corps en passant par mon nez...", german="Es schlüpfte in meine Nase und\nriss die Kontrolle über meinen Körper an\nsich...", italian="Mi ha preso alla sprovvista e ha\npreso il controllo del mio corpo...", spanish="Se introdujo en mí y tomó\ncontrol de mi cuerpo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So that was a bad Pokémon.", french="C'était donc un méchant\nPokémon.", german="Also war es ein bösartiges\nPokémon.", italian=" Allora era un Pokémon cattivo.", spanish="Así que se trataba de un\nPokémon malvado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So that was a bad Pokémon.", french="C'était donc un méchant\nPokémon.", german="Also war es ein bösartiges\nPokémon.", italian=" Allora era un Pokémon cattivo.", spanish="Así que se trataba de un\nPokémon malvado."})
  else
  SkySceneKit.say({english=" So that was a bad Pokémon.", french="C'était donc un méchant\nPokémon.", german="Also war es ein bösartiges\nPokémon.", italian=" Allora era un Pokémon cattivo.", spanish="Así que se trataba de un\nPokémon malvado."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" No. That's not true.", french=" Non, c'est faux.", german=" Nein. Das ist nicht wahr.", italian=" No. Non è così.", spanish=" No. Eso no es verdad."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="That [CS:N]Spiritomb[CR] was probably\nupset over us trespassing in its space.", french="[CS:N]Spiritomb[CR] était probablement\nfurieux que nous nous soyons introduits\nsur son territoire.", german="Dieses [CS:N]Kryppuk[CR] war\nwahrscheinlich nur wütend, weil wir in sein\nRevier eingedrungen sind.", italian="Quello [CS:N]Spiritomb[CR] probabilmente\nera agitato perché avevamo invaso il suo\nspazio.", spanish="Ese [CS:N]Spiritomb[CR] estaba enfadado,\nprobablemente, porque invadimos su territorio."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="It was frightening...because it\nbecame so angry that it lost control of itself.", french="C'était épouvantable... il était\ndans une rage telle qu'il a perdu le contrôle\nde lui-même.", german="Es war erschreckend, weil es\nvor Wut die Selbstbeherrschung verloren hat.", italian="È stato spaventoso... perché era\ntalmente arrabbiato che ha perso il controllo.", spanish="Se encolerizó tanto que perdió\nel control de sí mismo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="But you saw what happened when\nthe situation turned sour. It fled.", french="Mais vous avez vu ce qui s'est\npassé quand la situation a tourné au vinaigre.\nIl a fui.", german="Aber ihr habt gesehen, was\npassiert ist, als seine Lage kritisch wurde.\nEs ist geflohen.", italian="Ma avete visto cos'è successo\nquando la situazione si è fatta critica?\nÈ scappato.", spanish="Pero ya veis lo que pasó en\ncuanto la situación se le fue de las manos...\nSalió huyendo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" It's normally a timid Pokémon.", french="D'habitude, c'est un Pokémon\ntimide.", german="Normalerweise ist es ein\nscheues Pokémon.", italian="Generalmente è un Pokémon\ntimoroso.", spanish="Por naturaleza, es un Pokémon\nque no suele meterse en peleas."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="There are many such Pokémon\nhere in your future.", french="Il y a beaucoup de Pokémon\nde ce genre ici, dans le futur.", german="Es gibt in eurer Zukunft viele\nsolche Pokémon.", italian="Nel futuro ci sono molti\nPokémon così.", spanish="Esto mismo sucede con otros\nPokémon del futuro."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="They are Pokémon who should be\ngood...", french="Ce sont des Pokémon qui\ndevraient être bons en temps normal...", german="Es gibt viele Pokémon, die\nnormalerweise gut wären...", italian="Sono Pokémon che dovrebbero\nessere buoni...", spanish="Hay muchos que tendrían que ser\nbondadosos..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="But they have become bitter and\ntwisted because of this world's perpetual\ndarkness.", french="Mais ils sont aigris et\ncorrompus à cause de l'ombre perpétuelle\nqui s'est emparée de ce monde.", german="Wegen der ewigen Dunkelheit in\ndieser Welt sind sie jedoch verbittert und\nverrückt geworden.", italian="Ma sono diventati tristi e\nalterati a causa della perpetua oscurità\ndel mondo.", spanish="Pero han acabado amargados y\ncorruptos por culpa de esta perpetua oscuridad."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I see...", french=" Je vois...", german=" Ich verstehe...", italian=" Capisco...", spanish=" Ya entiendo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I see...", french=" Je vois...", german=" Ich verstehe...", italian=" Capisco...", spanish=" Ya entiendo..."})
  else
  SkySceneKit.say({english=" I see...", french=" Je vois...", german=" Ich verstehe...", italian=" Capisco...", spanish=" Ya entiendo..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownLeft)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Good Pokémon going bad because\nof this world...", french="Des bons Pokémon qui\ndeviennent méchants à cause du monde\ndans lequel ils vivent...", german="Dass diese Welt gute Pokémon\nverdirbt...", italian="Questo mondo rende cattivi i\nPokémon buoni...", spanish="Pokémon buenos que se echan\na perder por culpa de la situación de\neste mundo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Good Pokémon going bad because\nof this world...", french="Des bons Pokémon qui\ndeviennent méchants à cause du monde\ndans lequel ils vivent...", german="Dass diese Welt gute Pokémon\nverdirbt...", italian="Questo mondo rende cattivi i\nPokémon buoni...", spanish="Pokémon buenos que se echan\na perder por culpa de la situación de\neste mundo..."})
  else
  SkySceneKit.say({english="Good Pokémon going bad because\nof this world...", french="Des bons Pokémon qui\ndeviennent méchants à cause du monde\ndans lequel ils vivent...", german="Dass diese Welt gute Pokémon\nverdirbt...", italian="Questo mondo rende cattivi i\nPokémon buoni...", spanish="Pokémon buenos que se echan\na perder por culpa de la situación de\neste mundo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That makes me sad.", french=" Comme c'est triste.", german=" Das macht mich traurig.", italian=" Che tristezza.", spanish=" Eso me entristece."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That makes me sad.", french=" Comme c'est triste.", german=" Das macht mich traurig.", italian=" Che tristezza.", spanish=" Eso me entristece."})
  else
  SkySceneKit.say({english=" That makes me sad.", french=" Comme c'est triste.", german=" Das macht mich traurig.", italian=" Che tristezza.", spanish=" Eso me entristece."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Hey![K] You two!", french=" Eh![K] Vous autres!", german=" Hey![K] Ihr zwei!", italian=" Ehi![K] Voi due!", spanish=" ¡Por cierto![K] Decidme..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_juputoru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Now will you finally trust me?", french="Ça y est, vous vous décidez\nenfin à me croire?", german=" Vertraut ihr mir jetzt endlich?", italian=" Ora mi credete, finalmente?", spanish=" ¿Vais a confiar ya en mí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ummm...[K]somewhat?", french=" Hum...[K] en quelque sorte.", german=" Ähhh...[K] Ein bisschen?", italian=" Mmm...[K] Un po' di più.", spanish=" Hum...[K] ¿un poquito?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ummm...[K]somewhat?", french=" Hum...[K] en quelque sorte.", german=" Ähhh...[K] Ein bisschen?", italian=" Mmm...[K] Un po' di più.", spanish=" Hum...[K] ¿un poquito?"})
  else
  SkySceneKit.say({english=" Ummm...[K]somewhat?", french=" Hum...[K] en quelque sorte.", german=" Ähhh...[K] Ein bisschen?", italian=" Mmm...[K] Un po' di più.", spanish=" Hum...[K] ¿un poquito?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="To be honest, I don't really trust\nyou, but...", french="En toute honnêteté, je n'ai pas\nune totale confiance en toi, mais...", german="Ehrlich gesagt vertraue ich\ndir nicht wirklich, aber...", italian="A essere onesto, non mi fido\nmolto, ma...", spanish="Tengo que confesar que no\nconfío en ti, pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'll admit it. I don't really trust\nyou, but...", french="En toute honnêteté, je n'ai pas\nune totale confiance en toi, mais...", german="Zugegeben, ich vertraue dir\nnicht wirklich, aber...", italian="Lo ammetto, non mi fido molto,\nma...", spanish="Tengo que confesar que no\nconfío en ti, pero..."})
  else
  SkySceneKit.say({english="To be honest, I don't really trust\nyou, but...", french="En toute honnêteté, je n'ai pas\nune totale confiance en toi, mais...", german="Ehrlich gesagt vertraue ich\ndir nicht wirklich, aber...", italian="A essere onesta, non mi fido\nmolto, ma...", spanish="Tengo que confesar que no\nconfío en ti, pero..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Humph![K] I've told you before.", french=" Pff![K] Je te l'ai déjà dit.", german="Hrmpf![K] Ich habe es euch schon\neinmal gesagt.", italian=" Uff![K] Ve l'ho già detto.", spanish=" ¡Ja![K] Ya os lo he dicho..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="There's no point in continuing\ntogether if there's no trust between us.", french="C'est inutile de continuer\nensemble si la confiance ne règne pas\nentre nous.", german="Es hat keinen Sinn\nzusammenzubleiben, wenn es zwischen uns kein\nVertrauen gibt.", italian="Non ha senso continuare insieme\nse tra noi non c'è fiducia.", spanish="No tiene sentido que continuemos\njuntos si no hay confianza entre nosotros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" I'm leaving.", french=" Je m'en vais.", german=" Ich gehe.", italian=" Io me ne vado.", spanish=" Me marcho."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(32), p.Y+(32), false, 1) end
  GAME:WaitFrames(15)
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(15)
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, wait!", french=" Oh, attends!", german=" Oh, warte!", italian=" Oh, aspetta!", spanish=" ¡Espera!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, wait!", french=" Oh, attends!", german=" Oh, warte!", italian=" Oh, aspetta!", spanish=" ¡Espera!"})
  else
  SkySceneKit.say({english=" Oh, wait!", french=" Oh, attends!", german=" Oh, warte!", italian=" Oh, aspetta!", spanish=" ¡Espera!"})
  end
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I didn't say I don't believe you!", french="Je n'ai pas dit que je ne te\ncroyais pas!", german="Ich habe nicht gesagt, dass ich\ndir nicht glaube!", italian=" Non ho detto che non ti credo!", spanish="¡Yo no he dicho que no te\ncreyera!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I didn't say I don't believe you!", french="Je n'ai pas dit que je ne te\ncroyais pas!", german="Ich habe nicht gesagt, dass ich\ndir nicht glaube!", italian=" Non ho detto che non ti credo!", spanish="¡Yo no he dicho que no te\ncreyera!"})
  else
  SkySceneKit.say({english=" I didn't say I don't believe you!", french="Je n'ai pas dit que je ne te\ncroyais pas!", german="Ich habe nicht gesagt, dass ich\ndir nicht glaube!", italian=" Non ho detto che non ti credo!", spanish="¡Yo no he dicho que no te\ncreyera!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" To be perfectly honest...", french=" Pour être honnête...", german=" Um ganz ehrlich zu sein...", italian=" A essere davvero onesto...", spanish=" Para serte sincero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" To be perfectly honest...", french=" Pour être honnête...", german=" Um ganz ehrlich zu sein...", italian=" A essere davvero onesto...", spanish=" Para serte sincero..."})
  else
  SkySceneKit.say({english=" To be perfectly honest...", french=" Pour être honnête...", german=" Um ganz ehrlich zu sein...", italian=" A essere davvero onesta...", spanish=" Para serte sincera..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We don't know what's what\nanymore.", french="... on ne sait plus ce qu'on doit\ncroire.", german="Wir wissen nicht mehr,\nwas richtig ist.", italian="Ecco, noi non sappiamo più cosa\nfare.", spanish="No entendemos nada de lo que\nestá pasando."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We don't know what's what\nanymore.", french="... on ne sait plus ce qu'on doit\ncroire.", german="Wir wissen nicht mehr,\nwas richtig ist.", italian="Ecco, noi non sappiamo più cosa\nfare.", spanish="No entendemos nada de lo que\nestá pasando."})
  else
  SkySceneKit.say({english="We don't know what's what\nanymore.", french="... on ne sait plus ce qu'on doit\ncroire.", german="Wir wissen nicht mehr,\nwas richtig ist.", italian="Ecco, noi non sappiamo più cosa\nfare.", spanish="No entendemos nada de lo que\nestá pasando."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's why we want to know as\nmuch as we can learn.", french="C'est pour cette raison qu'on\ncherche à en apprendre le plus possible.", german="Darum wollen wir so viel wie\nmöglich erfahren.", italian="È per questo che vogliamo\nsapere il più possibile.", spanish="Por eso querríamos saber cuanto\nmás, mejor."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's why we want to know as\nmuch as we can learn.", french="C'est pour cette raison qu'on\ncherche à en apprendre le plus possible.", german="Darum wollen wir so viel wie\nmöglich erfahren.", italian="È per questo che vogliamo\nsapere il più possibile.", spanish="Por eso querríamos saber todo\nlo posible."})
  else
  SkySceneKit.say({english="That's why we want to know as\nmuch as we can learn.", french="C'est pour cette raison qu'on\ncherche à en apprendre le plus possible.", german="Darum wollen wir so viel wie\nmöglich erfahren.", italian="È per questo che vogliamo\nsapere il più possibile.", spanish="Por eso te agradeceríamos que\nnos contaras todo lo que sabes."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" And...", french=" Et...", german=" Und...", italian=" E...", spanish=" Y..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" And...", french=" Et...", german=" Und...", italian=" E...", spanish=" Y..."})
  else
  SkySceneKit.say({english=" And...", french=" Et...", german=" Und...", italian=" E...", spanish=" Y..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yeah, I still don't completely\ntrust you, [CS:N]Grovyle[CR], but...", french="... oui, c'est vrai, je n'ai pas\nencore totalement confiance en toi, [CS:N]Massko[CR],\nmais...", german="Ja, ich vertraue dir noch immer\nnicht ganz, [CS:N]Reptain[CR], aber...", italian="Insomma, non mi fido ancora\ncompletamente di te, [CS:N]Grovyle[CR].", spanish="Vale, aún no confío mucho en ti,\n[CS:N]Grovyle[CR], pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's true I still don't completely\ntrust you, [CS:N]Grovyle[CR], but...", french="... oui, c'est vrai, je n'ai pas\nencore totalement confiance en toi, [CS:N]Massko[CR],\nmais...", german="Ich vertraue dir wirklich noch\nimmer nicht ganz, [CS:N]Reptain[CR], aber...", italian="Insomma, non mi fido ancora\ncompletamente di te, [CS:N]Grovyle[CR].", spanish="Es cierto que aún no confío\nmucho en ti, [CS:N]Grovyle[CR], pero..."})
  else
  SkySceneKit.say({english="Yes, I still don't completely\ntrust you, [CS:N]Grovyle[CR], but...", french="... oui, c'est vrai, je n'ai pas\nencore totalement confiance en toi, [CS:N]Massko[CR],\nmais...", german="Ja, ich vertraue dir noch immer\nnicht ganz, [CS:N]Reptain[CR], aber...", italian="Insomma, non mi fido ancora\ncompletamente di te, [CS:N]Grovyle[CR].", spanish="Es cierto que aún no confío\nmucho en ti, [CS:N]Grovyle[CR], pero..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But what you said does make\nsome sense...", french=" ... ton histoire tient debout...", german="Was du gesagt hast, ergibt\nirgendwie Sinn.", italian="Però quello che ci hai\nraccontato sembra essere vero.", spanish="Lo que nos contaste parece tener\nalgo de sentido..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But what you said does make\nsome sense...", french=" ... ton histoire tient debout...", german="Was du gesagt hast, ergibt\nirgendwie Sinn.", italian="Però quello che ci hai\nraccontato sembra essere vero.", spanish="Lo que nos contaste parece tener\nalgo de sentido..."})
  else
  SkySceneKit.say({english="But what you said does make\nsome sense...", french=" ... ton histoire tient debout...", german="Was du gesagt hast, ergibt\nirgendwie Sinn.", italian="Però quello che ci hai\nraccontato sembra essere vero.", spanish="Lo que nos dijiste parece tener\nalgo de sentido..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It just seems to be logical.", french=" Ça m'a l'air logique.", german=" Es erscheint mir logisch.", italian=" Sembra avere una logica.", spanish=" Todo concuerda."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It just seems to be logical.", french=" Ça m'a l'air logique.", german=" Es erscheint mir logisch.", italian=" Sembra avere una logica.", spanish=" Todo concuerda."})
  else
  SkySceneKit.say({english=" It just seems to be logical.", french=" Ça m'a l'air logique.", german=" Es erscheint mir logisch.", italian=" Sembra avere una logica.", spanish=" Todo concuerda."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So, please?[K] [CS:N]Grovyle[CR], please tell\nus what you know.", french="Alors, [K][CS:N]Massko[CR], dis-nous tout\nce que tu sais, s'il te plaît.", german="Bitte, [K][CS:N]Reptain[CR], sag uns,\nwas du weißt.", italian="Quindi, per favore,[K] [CS:N]Grovyle[CR],\ndicci quello che sai.", spanish="Por eso te pedimos...[K] que nos\ncuentes todo lo que sepas."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So, please?[K] [CS:N]Grovyle[CR], please tell\nus what you know.", french="Alors, [K][CS:N]Massko[CR], dis-nous tout\nce que tu sais, s'il te plaît.", german="Bitte, [K][CS:N]Reptain[CR], sag uns,\nwas du weißt.", italian="Quindi, per favore,[K] [CS:N]Grovyle[CR],\ndicci quello che sai.", spanish="Por eso te pedimos...[K] que nos\ncuentes todo lo que sepas."})
  else
  SkySceneKit.say({english="So, please?[K] [CS:N]Grovyle[CR], please tell\nus what you know.", french="Alors, [K][CS:N]Massko[CR], dis-nous tout\nce que tu sais, s'il te plaît.", german="Bitte, [K][CS:N]Reptain[CR], sag uns,\nwas du weißt.", italian="Quindi, per favore,[K] [CS:N]Grovyle[CR],\ndicci quello che sai.", spanish="Por eso te pedimos...[K] que nos\ncuentes todo lo que sepas."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Tell us about this future...", french=" Dis-nous tout sur ce futur...", german=" Erzähle uns von der Zukunft.", italian=" Parlaci di questo futuro...", spanish=" Háblanos de este futuro..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Tell us about this future...", french=" Dis-nous tout sur ce futur...", german=" Erzähle uns von der Zukunft.", italian=" Parlaci di questo futuro...", spanish=" Háblanos de este futuro..."})
  else
  SkySceneKit.say({english=" Tell us about this future...", french=" Dis-nous tout sur ce futur...", german=" Erzähle uns von der Zukunft.", italian=" Parlaci di questo futuro...", spanish=" Háblanos de este futuro..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="and why you came to our world,\n[CS:N]Grovyle[CR]!", french="... et sur la raison de ta venue\ndans notre monde!", german="Und warum du in unsere Welt\ngekommen bist, [CS:N]Reptain[CR]!", italian="Spiegaci perché sei venuto nel\nnostro mondo, [CS:N]Grovyle[CR]!", spanish="Y de por qué viniste a nuestro\nmundo, [CS:N]Grovyle[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="and why you came to our world,\n[CS:N]Grovyle[CR]!", french="... et sur la raison de ta venue\ndans notre monde!", german="Und warum du in unsere Welt\ngekommen bist, [CS:N]Reptain[CR]!", italian="Spiegaci perché sei venuto nel\nnostro mondo, [CS:N]Grovyle[CR]!", spanish="Y de por qué viniste a nuestro\nmundo, [CS:N]Grovyle[CR]."})
  else
  SkySceneKit.say({english="and why you came to our world,\n[CS:N]Grovyle[CR]!", french="... et sur la raison de ta venue\ndans notre monde!", german="Und warum du in unsere Welt\ngekommen bist, [CS:N]Reptain[CR]!", italian="Spiegaci perché sei venuto nel\nnostro mondo, [CS:N]Grovyle[CR]!", spanish="Y de por qué viniste a nuestro\nmundo, [CS:N]Grovyle[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="So, what if everything I say is\na pack of lies?", french="Et si tout ce que je dis n'était\nqu'un tissu de mensonges?", german="Und wenn alles, was ich sage,\nein Haufen Lügen ist?", italian="E se vi dicessi solo una serie di\nfalsità?", spanish="¿Y qué pasa si todo lo que digo\nes solo un montón de mentiras?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's all right.[K] I won't accept\neverything you say as the truth right away.", french="C'est bon.[K] Je n'avalerai pas en\nbloc tout ce que tu racontes.", german="Schon in Ordnung.[K] Ich werde\nnicht alles, was du sagst, sofort für bare\nMünze nehmen.", italian="Va bene.[K] Non prenderò per\nvero tutto ciò che ci dirai.", spanish="Tú mismo.[K] No voy a aceptar lo\nque digas sin pensar antes en ello."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's all right.[K] I won't accept\neverything you say at face value right away.", french="C'est bon.[K] Je n'avalerai pas en\nbloc tout ce que tu racontes.", german="Schon in Ordnung.[K] Ich werde\nnicht alles, was du sagst, sofort für bare\nMünze nehmen.", italian="Va bene.[K] Non prenderò per\nvero tutto ciò che ci dirai.", spanish="Bueno...[K] No voy a creer todo\nlo que digas sin pensar siquiera en ello."})
  else
  SkySceneKit.say({english="It's all right.[K] I won't accept\neverything you say as the truth right away.", french="C'est bon.[K] Je n'avalerai pas en\nbloc tout ce que tu racontes.", german="Schon in Ordnung.[K] Ich werde\nnicht alles, was du sagst, sofort für bare\nMünze nehmen.", italian="Va bene.[K] Non prenderò per\nvero tutto ciò che ci dirai.", spanish="Bueno...[K] No voy a creer a pies\njuntillas todo lo que digas sin reflexionar\nantes."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I'll listen, then decide.", french="Je t'écouterai, et ensuite\nje me ferai mon opinion.", german="Ich werde zuhören und dann\nentscheiden.", italian="Ascolterò, poi prenderò una\ndecisione.", spanish="Primero voy a escucharte y,\nluego, ya decidiré."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I'll listen, then decide.", french="Je t'écouterai, et ensuite\nje me ferai mon opinion.", german="Ich werde zuhören und dann\nentscheiden.", italian="Ascolterò, poi prenderò una\ndecisione.", spanish="Primero voy a escucharte y,\nluego, ya decidiré."})
  else
  SkySceneKit.say({english=" I'll listen, then decide.", french="Je t'écouterai, et ensuite\nje me ferai mon opinion.", german="Ich werde zuhören und dann\nentscheiden.", italian="Ascolterò, poi prenderò una\ndecisione.", spanish="Primero voy a escucharte y,\nluego, ya decidiré."})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Well...[K]fine.[K] Follow me.", french=" Bon...[K] très bien.[K] Suivez-moi.", german=" Nun...[K] Okay.[K] Kommt mit.", italian=" Beh...[K] Va bene.[K] Seguitemi.", spanish=" Vale...[K] Está bien.[K] Seguidme."})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_juputoru, 456, 244, false, 2)
  GAME:WaitFrames(30)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(48), p.Y+(48), false, 2) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(64), p.Y+(64), false, 2) end
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(80), p.Y+(0), false, 2) end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(80), p.Y+(0), false, 2) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(80), p.Y+(0), false, 2) end
  GAME:WaitFrames(15)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 1 -- $SCENARIO_MAIN_BIT_FLAG[8] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.COMPULSORY_SAVE_POINT = 15 -- $COMPULSORY_SAVE_POINT = 15 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
