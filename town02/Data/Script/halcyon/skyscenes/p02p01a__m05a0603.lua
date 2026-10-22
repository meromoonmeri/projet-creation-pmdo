-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P02P01A/m05a0603.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_P02P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  -- SetAnimation(69) [anim idle native]
  GAME:WaitFrames(5)
  -- SetAnimation(69) [anim idle native]
  -- ResetOutputAttribute(256) [neutre/état moteur]
  -- ResetOutputAttribute(256) [neutre/état moteur]
  local npc_npc_himeguma = SkySceneKit.spawn_npc("teddiursa", 224, 176, Direction.Down, "NPC_HIMEGUMA")
  -- ResetOutputAttribute(256) [neutre/état moteur]
  local npc_npc_ringuma = SkySceneKit.spawn_npc("ursaring", 304, 240, Direction.UpLeft, "NPC_RINGUMA")
  -- ResetOutputAttribute(256) [neutre/état moteur]
  local npc_npc_yarukimono = SkySceneKit.spawn_npc("vigoroth", 264, 248, Direction.Up, "NPC_YARUKIMONO")
  -- ResetOutputAttribute(256) [neutre/état moteur]
  local npc_npc_mankii = SkySceneKit.spawn_npc("mankey", 304, 184, Direction.DownLeft, "NPC_MANKII")
  -- ResetOutputAttribute(256) [neutre/état moteur]
  local npc_npc_okorizaru = SkySceneKit.spawn_npc("primeape", 208, 232, Direction.UpRight, "NPC_OKORIZARU")
  -- ResetOutputAttribute(256) [neutre/état moteur]
  -- GAP: SetEffect EFFECT_STUCK_IN_YELLOW_WATER — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_STUCK_IN_YELLOW_WATER — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_STUCK_IN_YELLOW_WATER — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_STUCK_IN_YELLOW_WATER_DEEP — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_STUCK_IN_YELLOW_WATER_MEDIUM — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_STUCK_IN_YELLOW_WATER_MEDIUM2 — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_STUCK_IN_YELLOW_WATER_DEEP2 — VFX sans émote PMDO équivalente
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  pcall(function() GAME:MoveCamera(260, 216, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? What...? Where are we?", french="Hein? Quoi...? Où est-ce\nqu'on est?", german=" Wie? Was? Wo sind wir?", italian=" Eh? Cosa...? Dove siamo?", spanish="¿Eh? ¿Qué ha pasado?\n¿Dónde estamos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh? What...? Where are we?", french="Hein? Quoi...? Où est-ce\nqu'on est?", german=" Wie? Was? Wo sind wir?", italian=" Eh? Cosa...? Dove siamo?", spanish="¿Eh? ¿Qué ha pasado?\n¿Dónde estamos?"})
  else
  SkySceneKit.say({english=" Huh? What...? Where are we?", french="Hein? Quoi...? Où est-ce\nqu'on est?", german=" Wie? Was? Wo sind wir?", italian=" Eh? Cosa...? Dove siamo?", spanish="¿Eh? ¿Qué ha pasado?\n¿Dónde estamos?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_himeguma, 220, 188, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_himeguma, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" Hi, hi! Are you two OK?", french=" Coucou! Ça va, vous deux?", german="Hallihallo! Seid ihr zwei in\nOrdnung?", italian=" Ehilà! Ehi, voi due! State bene?", spanish=" ¡Hola! ¿Estáis bien?"})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" You plopped down from nowhere!", french="Vous apparaissez de nulle part\ncomme ça!", german="Ihr seid aus heiterem Himmel\nheruntergeplumpst!", italian=" Da dove venite?", spanish="¡Menuda zambullida os habéis\npegado!"})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" Oh, you startled everyone!", french=" Vous nous avez fait peur!", german="Oh! Ihr habt uns ganz schön\nerschreckt!", italian=" Avete spaventato tutti!", spanish=" ¡Nos habéis dado un buen susto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(15)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(60)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_himeguma, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Where are we?", french=" Où sommes-nous?", german=" Wo sind wir?", italian=" Dove ci troviamo?", spanish=" ¿Dónde estamos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Where are we?", french=" Où sommes-nous?", german=" Wo sind wir?", italian=" Dove ci troviamo?", spanish=" ¿Dónde estamos?"})
  else
  SkySceneKit.say({english=" Where are we?", french=" Où sommes-nous?", german=" Wo sind wir?", italian=" Dove ci troviamo?", spanish=" ¿Dónde estamos?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_himeguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" This is the Hot Spring.", french=" A la Source Chaude.", german=" Dies ist die Heiße Quelle.", italian=" Questa è la Sorgente Termale.", spanish=" Esta es la Terma."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" H-Hot Spring?!", french=" La Source Chaude?!", german=" D-die Heiße Quelle?!?", italian=" S-Sorgente Termale?!", spanish=" ¿La... la Terma?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" H-Hot Spring?!", french=" La Source Chaude?!", german=" D-die Heiße Quelle?!?", italian=" S-Sorgente Termale?!", spanish=" ¿La... la Terma?"})
  else
  SkySceneKit.say({english=" H-Hot Spring?!", french=" La Source Chaude?!", german=" D-die Heiße Quelle?!?", italian=" S-Sorgente Termale?!", spanish=" ¿La... la Terma?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Heartwarming.ogg", true) end)
  local npc_npc_kootasu = SkySceneKit.spawn_npc("torkoal", 320, 136, Direction.DownLeft, "NPC_KOOTASU")
  do local p=npc_npc_kootasu.Position; GROUND:MoveToPosition(npc_npc_kootasu, p.X+(-56), p.Y+(0), false, 1) end
  GAME:WaitFrames(20)
  GROUND:EntTurn(npc_npc_mankii, Direction.UpLeft)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_himeguma, Direction.UpRight)
  GAME:WaitFrames(15)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:MoveToPosition(npc_npc_kootasu, 260, 148, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_kootasu, Direction.Down)
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" Indeed! This is the Hot Spring.", french=" Précisément.", german="In der Tat! Dies ist die\nHeiße Quelle.", italian="Esatto! Questa è la Sorgente\nTermale.", spanish=" Exacto. Estáis en la Terma."})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="The Hot Spring works wonders\non tired muscles and creaky joints. Many\nPokémon visit here.", french="Nombreux sont les Pokémon qui\nviennent à la Source Chaude, car elle soulage\nles vieux muscles et les articulations usées.", german="Die Heiße Quelle wirkt Wunder\nfür unsere müden Muskeln und steifen Gelenke.\nViele Pokémon kommen hierher.", italian="La Sorgente Termale è un vero\ntoccasana per i muscoli affaticati e le giunture\nscricchiolanti. Molti Pokémon vengono qui.", spanish="Este lugar hace maravillas con\nlos músculos cansados y las articulaciones\ndébiles. Muchos Pokémon suelen venir aquí."})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="Tell me, youngster, have you a\nmap?", french="Dites-moi, les jeunes, avez-vous\nune carte?", german="Sag, mein junges Pokémon, hast\ndu eine Karte dabei?", italian="Ditemi, giovani amici Pokémon,\navete una mappa?", spanish="Dime, joven, ¿por casualidad\nllevas un mapa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Map?[K] Oh, if you mean our\nWonder Map, sure we do.", french="Une carte?[K] Oh, tu veux dire une\nCarte Miracle? Bien sûr, oui.", german="Karte?[K] Oh, wenn du unsere\nWunderkarte meinst, natürlich.", italian="Mappa?[K] Oh, se intendi la\nMappa delle meraviglie, ce l'abbiamo.", spanish="¿Un mapa?[K] Ah, ¿te refieres\na nuestro Mapa Mágico? Por supuesto."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Map?[K] Oh, if you mean our\nWonder Map, yes, we have one.", french="Une carte?[K] Oh, tu veux dire une\nCarte Miracle? Bien sûr, oui.", german="Karte?[K] Oh, wenn du unsere\nWunderkarte meinst, die haben wir dabei.", italian="Mappa?[K] Oh, se intendi la\nMappa delle meraviglie, ce l'abbiamo.", spanish="¿Un mapa?[K] Ah, si te refieres\na un Mapa Mágico, sí que tenemos uno."})
  else
  SkySceneKit.say({english="Map?[K] Oh, our Wonder Map, you\nmean? We have one.", french="Une carte?[K] Oh, tu veux dire une\nCarte Miracle? Bien sûr, oui.", german="Karte?[K] Oh, unsere Wunderkarte\nmeinst du? Die haben wir dabei.", italian="Mappa?[K] Oh, se intendi la\nMappa delle meraviglie, ce l'abbiamo.", spanish="¿Un mapa?[K] ¿Quieres decir\nun Mapa Mágico? Sí, tenemos uno."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" Unfold it for me.", french=" Pourrais-tu la déplier?", german=" Falte sie für mich auf.", italian=" Apritela un attimo.", spanish=" Desplegadlo."})
  -- message_Close
  -- GAP: se_Play(6667) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
