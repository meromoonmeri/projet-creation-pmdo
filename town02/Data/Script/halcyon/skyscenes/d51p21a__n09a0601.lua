-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D51P21A/n09a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D51P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru_n9 = SkySceneKit.spawn_npc("dusknoir", 256, 288, Direction.Down, "NPC_YONOWAARU_N9")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(29) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Down)
  GAME:FadeIn(30)
  -- GAP: BGM BGM_DARK_ICE_MOUNTAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  -- SetAnimation(31) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Right)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Y-you helped...", french=" Ton aide a été...", german=" D-du hast geholfen...", italian=" G-Grazie dell'aiuto...", spanish=" Me has ayudado..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yonowaaru_n9, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="If we had run any slower\nat all, we would have been hurt.", french="Si nous n'avions pas détalé,\nnous aurions été blessés.", german="Wären wir nur ein bisschen\nlangsamer gewesen, hätten wir\netwas abbekommen.", italian="Se non fossimo fuggiti così\nvelocemente, ce la saremmo vista brutta.", spanish="Si hubiéramos ido más despacio,\nahora estaríamos muy mal."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" That was close.", french=" C'était moins une.", german=" Das war knapp.", italian=" C'è mancato poco.", spanish=" Ha faltado poco."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "shock", 1) end)
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Down)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Gah!", french=" Argh!", german=" Gah!", italian=" Gah!", spanish=" ¡Ay!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Are you OK, [CS:N]Dusknoir[CR]?", french=" Tout va bien, [CS:N]Noctunoir[CR]?", german=" Geht es dir gut, [CS:N]Zwirrfinst[CR]?", italian=" Tutto bene, [CS:N]Dusknoir[CR]?", spanish=" ¿Estás bien, [CS:N]Dusknoir[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="My wounds hurt...[K]but it's\nnothing important.", french="Mes blessures me font\nsouffrir...[K] mais je m'en sortirai.", german="Die Wunden tun weh...[K]\nAber es ist nichts Ernstes.", italian="Mi fanno male le ferite...[K] ma non\nè niente di grave.", spanish="Me duele el cuerpo...[K] pero\nno es para tanto."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Aside from that...[K]\nWell, we need to make it through to the\nother side.", french="Par ailleurs...[K]\nil nous faut atteindre l'autre côté.", german="Und ganz nebenbei...[K] Nun,\nwir müssen es auf die andere Seite schaffen.", italian="Ora non c'è tempo...[K] Dobbiamo\ncercare di arrivare dall'altra parte.", spanish="Aparte de eso...[K] Bueno, tenemos\nque llegar al otro lado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Right)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yes.", french=" Bien dit.", german=" Ja.", italian=" Sì.", spanish=" Así es."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="... (It's bad to not make\nany progress in a place like this!)", french="... (Argh! Que c'est frustrant\nde faire du sur-place!)", german="...(Es ist schlecht, an einem\nOrt wie diesem keine Fortschritte zu machen!)", italian="... (Non sopporto l'idea di non\nriuscire ad andare avanti in questo posto!)", spanish="Vaya... (¡Muy mal que no\nlogremos avanzar en un sitio así!)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" (Next time, I definitely will!)", french="(Nous y arriverons\nla prochaine fois!)", german="(Nächstes Mal\nwird es bestimmt was!)", italian="(La prossima volta ci riuscirò\nsicuramente!)", spanish=" (La próxima vez lo lograremos.)"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
