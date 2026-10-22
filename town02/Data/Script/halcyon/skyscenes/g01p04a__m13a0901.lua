-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m13a0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Ahem![K] And that brings us back\nto today...", french="Hum![K] Et ça nous ramène\nà aujourd'hui...", german=" Ähem![K] Und da sind wir wieder...", italian="Ahem![K] E così, siamo di nuovo\nqui.", spanish="¡Ejem![K] Reconsideremos\nla situación actual..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Presently, the great [CS:N]Dusknoir[CR]\nand I are working out a new strategy.", french="En ce moment, [CS:N]Noctunoir[CR]\net moi-même mettons au point une nouvelle\nstratégie.", german="Im Moment arbeiten der große\n[CS:N]Zwirrfinst[CR] und ich an einer Lösung\ndes Problems.", italian="Al momento, il grande [CS:N]Dusknoir[CR]\ned io stiamo elaborando un nuovo piano da\nseguire.", spanish="Actualmente, [CS:N]Dusknoir[CR] y yo\nestamos elaborando una nueva\nestrategia."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" While we develop this strategy...", french=" Pendant ce temps...", german="Wir entwickeln unsere\nneue Strategie...", italian=" Nel frattempo...", spanish=" Mientras trabajamos en ello..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We ask you to search for the\nTime Gears on your own initiative.", french="Nous vous prions de bien vouloir\ncontinuer à chercher les Rouages du Temps\nde votre côté.", german="Und bis wir sie entwickelt\nhaben, möchten wir, dass ihr auf eigene Faust\nnach den Zahnrädern der Zeit sucht.", italian="... vi preghiamo di continuare le\nricerche degli Ingranaggi del Tempo per conto\nvostro.", spanish="Será mejor que busquéis los\nEngranajes del Tiempo por vuestra\ncuenta."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" That is all.", french=" C'est tout.", german=" Das ist alles.", italian=" Per ora è tutto.", spanish=" Eso es todo."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="All right, everyone! Work hard\nagain today! ♪", french="Très bien, tout le monde!\nTravaillez dur! ♪", german="In Ordnung, Pokémon! Heute\nheißt es wieder hart arbeiten! ♪", italian="D'accordo, gente? Diamo il\nmeglio anche oggi.", spanish="Muy bien, ¡y ahora todos a\ntrabajar como un día normal! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 360, 272, Direction.UpRight, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 424, 272, Direction.Up, "NPC_DOGOOMU")
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 392, 256, Direction.Up, "NPC_CHIRIIN")
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 456, 256, Direction.Up, "NPC_KIMAWARI")
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 392, 272, Direction.Up, "NPC_HEIGANI")
  -- SetAnimation(23) [anim idle native]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 424, 256, Direction.Up, "NPC_BIPPA")
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 456, 272, Direction.Up, "NPC_DIGUDA")
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  GROUND:EntTurn(partner, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: SÌÌÌÌÌ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
  -- message_Close
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Down)
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_diguda, Direction.Down)
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Left)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 424, 208, Direction.Down, "NPC_PUKURIN")
  GROUND:MoveToPosition(npc_npc_pukurin, 420, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 224, 252, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 188, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 240, 272, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 324, 188, false, 2)
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(-32), p.Y+(0), false, 2) end -- Move2PositionOffset
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  GROUND:MoveToPosition(npc_npc_kimawari, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 324, 132, false, 2)
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 384, 216, Direction.Down, "NPC_YONOWAARU")
  GROUND:MoveToPosition(npc_npc_yonowaaru, 432, 240, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.UpRight)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="They said to go search on our\nown today, [hero].", french="On nous a dit de poursuivre\nles recherches aujourd'hui, [hero].", german="Wir sollen heute auf eigene\nFaust suchen, [hero].", italian="Così oggi dobbiamo continuare\nle ricerche per conto nostro, giusto\n[hero]?", spanish="Nos han dicho que busquemos\npor nuestra cuenta, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We're supposed to search on our\nown today, [hero].", french="On nous a dit de poursuivre\nles recherches aujourd'hui, [hero].", german="Wir sollen heute auf eigene\nFaust suchen, [hero].", italian="Oggi dobbiamo continuare le\nricerche per conto nostro, [hero].", spanish="Hoy tenemos que buscar por\nnuestra cuenta, [hero]."})
  else
  SkySceneKit.say({english="We're supposed to go search on\nour own today, [hero].", french="On nous a dit de poursuivre\nles recherches aujourd'hui, [hero].", german="Wir sollen heute auf eigene\nFaust suchen, [hero].", italian="Oggi dobbiamo continuare le\nricerche per conto nostro, [hero].", spanish="Hoy tenemos que buscar por\nnuestra cuenta, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Well, where should we go?", french=" Bon, où est-ce qu'on va?", german=" Okay, wo sollen wir suchen?", italian=" Ma dove possiamo andare?", spanish=" Bueno, ¿adónde vamos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Where should we go?", french=" Bon, où est-ce qu'on va?", german=" Wo sollen wir suchen?", italian="Secondo te, dove dovremmo\nandare?", spanish=" ¿Adónde vamos?"})
  else
  SkySceneKit.say({english=" So where should we go?", french=" Bon, où est-ce qu'on va?", german=" Wo sollen wir denn suchen?", italian="Secondo te, dove dovremmo\nandare?", spanish=" Entonces, ¿adónde vamos?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Hmmm, I wonder...?)", french="(Hum, bonne question...)", german="(Hmm, ich frage mich...)", italian="(Mmm, chissà...)", spanish="(Buena pregunta.)"})
  else
  SkySceneKit.say({english="(Hmmm, I wonder...?)", french="(Hum, bonne question...)", german="(Hmm, ich frage mich...)", italian="(Mmm, chissà...)", spanish="(Buena pregunta.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(We can search all we want, but we don't\nhave a clue...)", french="(On peut s'amuser à chercher partout, on n'a\naucun indice...)", german="(Wir können zwar suchen, aber wir haben\nkeinen Schimmer, wo...)", italian="(Possiamo anche cercare tutto il giorno, ma\nsenza nemmeno un indizio...)", spanish="(Podemos buscar todo lo que queramos,\npero no tenemos ninguna pista.)"})
  else
  SkySceneKit.say({english="(We can search all we want, but we don't\nhave a clue...)", french="(On peut s'amuser à chercher partout, on n'a\naucun indice...)", german="(Wir können zwar suchen, aber wir haben\nkeinen Schimmer, wo...)", italian="(Possiamo anche cercare tutto il giorno, ma\nsenza nemmeno un indizio...)", spanish="(Podemos buscar todo lo que queramos,\npero no tenemos ninguna pista.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Oh![K] Wait a second!)", french="(Oh![K] Une seconde!)", german="(Oh![K] Moment mal!)", italian="(Ehi![K] Aspetta un momento!)", spanish="(¡Oh![K] ¡Espera un momento!)"})
  else
  SkySceneKit.say({english="(Oh![K] Wait a second!)", french="(Oh![K] Une seconde!)", german="(Oh![K] Moment mal!)", italian="(Ehi![K] Aspetta un momento!)", spanish="(¡Oh![K] ¡Espera un momento!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Yesterday...when we were out there...)", french="(Hier... quand on était là-bas...)", german="(Gestern... Als wir da draußen waren...)", italian="(Ieri... mentre eravamo...)", spanish="(Ayer, cuando estuvimos en el [CS:P]Desierto[CR]\n[CS:P]Norte[CR]...)"})
  else
  SkySceneKit.say({english="(Yesterday...when we were out there...)", french="(Hier... quand on était là-bas...)", german="(Gestern... Als wir da draußen waren...)", italian="(Ieri... mentre eravamo...)", spanish="(Ayer, cuando estuvimos en el [CS:P]Desierto[CR]\n[CS:P]Norte[CR]...)"})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
