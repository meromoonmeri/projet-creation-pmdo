-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D28P44A/m25a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(26, 1) -- $SCENARIO_MAIN = scn[26,1] (ROM)
  -- back_SetGround(LEVEL_D28P44A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 256, 200, Direction.Down, "NPC_YONOWAARU")
  -- SetAnimation(36) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Gwoh...[K] Gwwwooh...[K]\nGwwwwwoooooohhhhh!", french="Gwoh...[K] Gwwwooh...[K]\nGwwwwwoooooohhhhh!", german="Gwoh...[K] Gwwwooh...[K]\nGwwwwwoooooohhhhh!", italian="Oooh...[K] Ooooooh...[K]\nOoooooooooooohhhhh!", spanish="Ah...[K] Aaaah...[K]\n¡Aaaaaaaaah!"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" I...[K] I...[K] I...", french=" Je...[K] je...[K] non, je...", german=" Ich...[K] Ich...[K] Ich...", italian=" Io...[K] io...[K] io...", spanish=" Uf...[K] No...[K] No..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(34) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 280, 208, Direction.Left, "NPC_JUPUTORU")
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(2), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(partner, Direction.UpRight)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-2), p.Y+(2), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(npc_npc_juputoru, Direction.UpLeft)
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(2), p.Y+(2), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" I...[K]refuse to lose!", french=" Je...[K] refuse de perdre!", german="Ich...[K] Ich weigere mich zu\nverlieren!", italian=" Io...[K] mi rifiuto di perdere!", spanish=" Me...[K] ¡Me niego a perder!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  local npc_npc_yamirami3 = SkySceneKit.spawn_npc("sableye", 184, 208, Direction.Right, "NPC_YAMIRAMI3")
  GROUND:EntTurn(npc_npc_yamirami3, Direction.DownRight)
  local npc_npc_yamirami4 = SkySceneKit.spawn_npc("sableye", 336, 208, Direction.Left, "NPC_YAMIRAMI4")
  GROUND:EntTurn(npc_npc_yamirami4, Direction.DownLeft)
  local npc_npc_yamirami5 = SkySceneKit.spawn_npc("sableye", 192, 240, Direction.UpRight, "NPC_YAMIRAMI5")
  GROUND:EntTurn(npc_npc_yamirami5, Direction.DownRight)
  local npc_npc_yamirami6 = SkySceneKit.spawn_npc("sableye", 328, 240, Direction.UpLeft, "NPC_YAMIRAMI6")
  GROUND:EntTurn(npc_npc_yamirami6, Direction.DownLeft)
  pcall(function() GAME:MoveCamera(256, 260, 60, false) end) -- performer/caméra
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GROUND:MoveToPosition(partner, 220, 276, false, 2) -- Slide2PositionMark (glissement)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GROUND:MoveToPosition(hero, 252, 276, false, 2) -- Slide2PositionMark (glissement)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  GROUND:MoveToPosition(npc_npc_juputoru, 284, 276, false, 2) -- Slide2PositionMark (glissement)
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(68) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(68) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(29) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Gwah!", french=" Gwah!", german=" Gwah!", italian=" Aaah!", spanish=" ¡Ah!"})
  -- SetAnimation(2) [anim idle native]
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
  GROUND:EntTurn(partner, Direction.UpRight)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urf...", french=" Argh...", german=" Uff...", italian=" Uff...", spanish=" Aaah..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urf...", french=" Argh...", german=" Uff...", italian=" Uff...", spanish=" Aaah..."})
  else
  SkySceneKit.say({english=" Urf...", french=" Argh...", german=" Uff...", italian=" Uff...", spanish=" Aaah..."})
  end
  -- GAP: BGM BGM_THE_POWER_OF_DARKNESS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(15)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(5)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_juputoru, Direction.UpLeft)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Humph. So foolhardy.", french=" Pfff! Pauvres fous.", german=" Grmpf. So töricht.", italian=" Bah. Troppo avventati.", spanish=" Ja. Qué insensatos."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" You dared to challenge me?", french=" Vous osez me défier?", german="Ihr habt es gewagt, mich\nherauszufordern?", italian=" Osate sfidarmi?", spanish=" ¿Queríais desafiarme?"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" For all the effort in the world...", french=" Vous auriez beau faire...", german=" Ihr hattet keine Chance...", italian="Anche con tutto l'impegno del\nmondo...", spanish=" Por mucho que os esforcéis..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="with your puny power...[K]you had\nno chance of winning from the start!", french="... vos forces cumulées sont\ninsignifiantes...[K] Vous avez perdu d'avance!", german="Die vereinten Mühen dieser Welt\ngepaart mit eurer mickrigen Kraft...[K] Das\nErgebnis stand bereits vor Kampfbeginn fest!", italian="Con la vostra patetica forza...[K]\nnon avrete mai alcuna possibilità di battermi!", spanish="Sois unos endebles...[K]\n¡No teníais ni la menor oportunidad!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh...[K] [CS:N]Dusknoir[CR] is truly tough.", french="Argh...[K] [CS:N]Noctunoir[CR] est vraiment\ncoriace.", german="Uff...[K] [CS:N]Zwirrfinst[CR] ist echt ein\nharter Brocken.", italian="Uff...[K] [CS:N]Dusknoir[CR] è veramente\nforte.", spanish=" Uf...[K] [CS:N]Dusknoir[CR] es realmente duro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh...[K] [CS:N]Dusknoir[CR] is truly tough.", french="Argh...[K] [CS:N]Noctunoir[CR] est vraiment\ncoriace.", german="Uff...[K] [CS:N]Zwirrfinst[CR] ist echt ein\nharter Brocken.", italian="Uff...[K] [CS:N]Dusknoir[CR] è veramente\nforte.", spanish=" Uf...[K] [CS:N]Dusknoir[CR] es realmente duro."})
  else
  SkySceneKit.say({english=" Ugh...[K] [CS:N]Dusknoir[CR] is truly tough.", french="Argh...[K] [CS:N]Noctunoir[CR] est vraiment\ncoriace.", german="Uff...[K] [CS:N]Zwirrfinst[CR] ist echt ein\nharter Brocken.", italian="Uff...[K] [CS:N]Dusknoir[CR] è veramente\nforte.", spanish=" Uf...[K] [CS:N]Dusknoir[CR] es realmente duro."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Don't give up![K] There's a way out\nof this!", french="Reprenez courage![K] Il doit y avoir\nun moyen de s'en sortir!", german="Nicht aufgeben![K] Es gibt einen\nAusweg!", italian="Non molliamo![K] Ci sarà un modo\nper batterlo!", spanish="¡No os rindáis![K]\n¡Hay una forma de salir de esto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That's easy for you to say...", french=" C'est facile à dire pour toi...", german=" Das sagst du so einfach...", italian=" Facile dirlo...", spanish=" Eso se dice muy pronto..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That's easy for you to say...", french=" C'est facile à dire pour toi...", german=" Das sagst du so einfach...", italian=" Facile dirlo...", spanish=" Eso se dice muy pronto..."})
  else
  SkySceneKit.say({english=" That's easy for you to say...", french=" C'est facile à dire pour toi...", german=" Das sagst du so einfach...", italian=" Facile dirlo...", spanish=" Eso se dice muy pronto..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_yonowaaru, 252, 204, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Humph.[K] You've done admirably\nwell for those as pitiful as you...", french="Pfff![K] Vous vous êtes\nadmirablement défendus pour des avortons\nde votre espèce...", german="Grmpf.[K] Für ein paar\nSchwächlinge schlagt ihr euch erstaunlich gut...", italian="Bah.[K] La vostra tecnica è\nmediocre, ma ve la siete cavata\ndignitosamente...", spanish="¡Ja![K] No lo habéis hecho tan mal\nteniendo en cuenta lo patéticos que sois."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" But it's all over now.", french=" Mais tout est terminé à présent.", german=" Aber das ist jetzt alles vorbei.", italian=" Ma ora è finita.", spanish=" Pero se acabó lo que se daba."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7194) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(31) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" This is...[K]the end!", french="Vous qui vous trouvez ici...[K]\nabandonnez tout espoir!", german=" Das ist...[K] das Ende!", italian=" Questa è...[K] la fine!", spanish=" Ha llegado...[K] ¡vuestra hora!"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The mouth on his stomach!\nIt opened up!", french="La bouche sur son ventre!\nElle s'est ouverte!", german="Der Mund auf seinem Bauch!\nEr ist aufgegangen!", italian="La bocca sulla sua pancia!\nSi è aperta!", spanish="¡Se le acaba de abrir una boca\nen la barriga!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The mouth on his stomach!\nIt opened up!", french="La bouche sur son ventre!\nElle s'est ouverte!", german="Der Mund auf seinem Bauch!\nEr ist aufgegangen!", italian="La bocca sulla sua pancia!\nSi è aperta!", spanish="¡Se le acaba de abrir una boca\nen la barriga!"})
  else
  SkySceneKit.say({english="The mouth on his stomach!\nIt opened up!", french="La bouche sur son ventre!\nElle s'est ouverte!", german="Der Mund auf seinem Bauch!\nEr ist aufgegangen!", italian="La bocca sulla sua pancia!\nSi è aperta!", spanish="¡Se le acaba de abrir una boca\nen la barriga!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" H-he's going to do something!", french=" Il prépare quelque chose!", german=" E-er macht irgendetwas!", italian=" S-Sta per fare qualcosa!", spanish=" ¡Va a atacarnos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Is he going to unleash a move on us?!)", french="(Est-ce qu'il va déclencher une capacité?!)", german="(Wird er gleich eine Attacke auf uns\nstarten?!?)", italian="(Sta per usare una mossa su di noi?!)", spanish="(¿Va a usar un movimiento contra nosotros?)"})
  else
  SkySceneKit.say({english="(Is he going to unleash a move on us?!)", french="(Est-ce qu'il va déclencher une capacité?!)", german="(Wird er gleich eine Attacke auf uns\nstarten?!?)", italian="(Sta per usare una mossa su di noi?!)", spanish="(¿Va a usar un movimiento contra nosotros?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(From that mouth on his stomach?!)", french="(Avec la bouche sur son ventre?!)", german="(Von diesem Mund auf seinem Bauch aus?!?)", italian="(Dalla bocca sulla sua pancia?!)", spanish="(¿Con la boca de la barriga?)"})
  else
  SkySceneKit.say({english="(From that mouth on his stomach?!)", french="(Avec la bouche sur son ventre?!)", german="(Von diesem Mund auf seinem Bauch aus?!?)", italian="(Dalla bocca sulla sua pancia?!)", spanish="(¿Con la boca de la barriga?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Wait a second...[K] The mouth on his stomach?!)", french="(Une seconde...[K] La bouche sur son ventre?!)", german="(Einen Moment...[K] Der Mund auf seinem\nBauch...)", italian="(Aspetta un attimo...[K] La bocca sulla sua\npancia?!)", spanish="(¡Eso es![K] ¡La boca!)"})
  else
  SkySceneKit.say({english="(Wait a second...[K] The mouth on his stomach?!)", french="(Une seconde...[K] La bouche sur son ventre?!)", german="(Einen Moment...[K] Der Mund auf seinem\nBauch...)", italian="(Aspetta un attimo...[K] La bocca sulla sua\npancia?!)", spanish="(¡Eso es![K] ¡La boca!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Th-that's it![K] This could work!)", french="(Mais oui, c'est ça![K] Ça pourrait marcher!)", german="(D-das ist es![K] Das könnte funktionieren!)", italian="(C-Certo![K] Può funzionare!)", spanish="(¡Ya lo tengo![K] Igual funciona.)"})
  else
  SkySceneKit.say({english="(Th-that's it![K] This could work!)", french="(Mais oui, c'est ça![K] Ça pourrait marcher!)", german="(D-das ist es![K] Das könnte funktionieren!)", italian="(C-Certo![K] Può funzionare!)", spanish="(¡Ya lo tengo![K] Igual funciona.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(180) end)
  -- GAP: se_Play(7681) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_juputoru, 4) end)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "exclaim", 1) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" What is it, [hero]?!", french="Qu'est-ce qui se passe,\n[hero]?!", german=" Was ist los, [hero]?", italian=" Cosa c'è, [hero]?!", spanish=" ¿Qué pasa, [hero]?"})
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D28P34A1_74) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-what?!", french=" Hein, quoi?!", german=" W-was?", italian=" C-Cosa?!", spanish=" ¡¿Qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-what?!", french=" Hein, quoi?!", german=" W-was?", italian=" C-Cosa?!", spanish=" ¡¿Qué?!"})
  else
  SkySceneKit.say({english=" Wh-what?!", french=" Hein, quoi?!", german=" W-was?", italian=" C-Cosa?!", spanish=" ¡¿Qué?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Force our combined moves down\nhis stomach?!", french="Unir nos forces et viser\nson ventre avec nos capacités?!", german="Wir sollen unsere kombinierten\nAttacken auf seinen Bauch richten?!?", italian="Dirigere le nostre mosse\ncombinate nel suo stomaco?!", spanish="¡¿Que le ataquemos a la barriga\nlos tres a la vez?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Is that possible?!", french=" C'est faisable, ça?!", german=" Ist das möglich?!?", italian=" È possibile?!", spanish=" ¡¿Podemos hacer eso?!"})
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_juputoru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="There's no time! It's our only\nshot, [CS:N]Grovyle[CR]!", french="Pas de temps à perdre! C'est\nnotre seule chance, [CS:N]Massko[CR]!", german="Wir haben keine Zeit! Das ist\nunser einziger Versuch, [CS:N]Reptain[CR]!", italian="Non c'è tempo! È la nostra unica\npossibilità, [CS:N]Grovyle[CR]!", spanish="¡No hay tiempo que perder!\n¡Es nuestra única oportunidad, [CS:N]Grovyle[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There's no time! It's our one\nshot, [CS:N]Grovyle[CR]!", french="Pas de temps à perdre! C'est\nnotre seule chance, [CS:N]Massko[CR]!", german="Wir haben keine Zeit! Das ist\nunser einziger Versuch, [CS:N]Reptain[CR]!", italian="Non c'è tempo! È la nostra unica\npossibilità, [CS:N]Grovyle[CR]!", spanish="¡No hay tiempo que perder!\n¡Es nuestra única oportunidad, [CS:N]Grovyle[CR]!"})
  else
  SkySceneKit.say({english="There's no time! It's our one\nshot, [CS:N]Grovyle[CR]!", french="Pas de temps à perdre! C'est\nnotre seule chance, [CS:N]Massko[CR]!", german="Wir haben keine Zeit! Das ist\nunser einziger Versuch, [CS:N]Reptain[CR]!", italian="Non c'è tempo! È la nostra unica\npossibilità, [CS:N]Grovyle[CR]!", spanish="¡No hay tiempo que perder!\n¡Es nuestra única oportunidad, [CS:N]Grovyle[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_juputoru, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" TAKE THIS!", french=" PRENEZ ÇA!", german=" NEHMT DAS!", italian=" PRENDETE QUESTO!", spanish=" ¡TOMAD ESTO!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- se_Stop(7681) [SE one-shot PMDO déjà terminé: arrêt sans objet, canal SE V2]
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6924) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(31) [anim idle native]
  -- MovePositionOffset<object OBJECT_D28P34A1_74> [prop décor NDS, géré par le rendu du ground]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Now! Go!", french=" Tous ensemble, c'est parti!", german=" Jetzt! Los!", italian=" Ora! Via!", spanish=" ¡Ahora!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Now! Go!", french=" Tous ensemble, c'est parti!", german=" Jetzt! Los!", italian=" Ora! Via!", spanish=" ¡Ya!"})
  else
  SkySceneKit.say({english=" Now! Go!", french=" Tous ensemble, c'est parti!", german=" Jetzt! Los!", italian=" Ora! Via!", spanish=" ¡Ahora!"})
  end
  GAME:WaitFrames(10)
  -- SetAnimation(13) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(13) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  -- GAP: se_Play(7682) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '2', '0')
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  -- MovePositionOffset<object OBJECT_D28P34A1_74> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GROUND:EntTurn(npc_npc_yamirami3, Direction.Right)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.Left)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.UpRight)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "shock", 1) end)
  -- SetAnimation(44) [anim idle native]
  -- GAP: se_Play(7683) — id SE NDS sans portage PMDO identifié
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 90) -- screen_WhiteOutAll
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" GWAAAAAAAAAAH!", french=" GWAAAAAAAAAAH!", german=" GWAAAAAAAAAAH!", italian=" AAAAAAAAAAAAH!", spanish=" ¡AAAAAAAAAAH!"})
  GAME:WaitFrames(60)
  -- message_CloseEnforce
  GAME:WaitFrames(60)
  GAME:WaitFrames(2) -- join WaitSe
  -- camera_SetEffect(0): arrêt d'effet caméra
  SkySceneKit.cleanup_npcs()
end
