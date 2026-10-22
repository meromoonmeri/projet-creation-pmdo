-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D53P21A/n09a1501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=48, sub=7} -- $SCENARIO_SIDE = scn[48,7] (ROM)
  -- back_SetGround(LEVEL_D53P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru_n9 = SkySceneKit.spawn_npc("dusknoir", 256, 456, Direction.Up, "NPC_YONOWAARU_N9")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_serebii = SkySceneKit.spawn_npc("celebi", 216, 432, Direction.Right, "NPC_SEREBII")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_VAST_ICE_MOUNTAIN_PEAK non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 228, 264, false, 2)
  GROUND:MoveToPosition(npc_npc_serebii, 204, 288, false, 2)
  GROUND:MoveToPosition(npc_npc_yonowaaru_n9, 252, 300, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]Celebi[CR].", french=" [CS:N]Celebi[CR].", german=" [CS:N]Celebi[CR].", italian=" [CS:N]Celebi[CR].", spanish=" [CS:N]Celebi[CR]."})
  GROUND:EntTurn(npc_npc_serebii, Direction.UpRight)
  GAME:WaitFrames(6)
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="We've climbed pretty far...[K]\nWhere is this?", french="Ça fait un moment que nous\ngrimpons...[K] Où est-ce?", german="Wir sind schon ganz schön weit\ngekommen...[K] Wo sind wir?", italian="Abbiamo fatto parecchia strada...[K]\nDove siamo?", spanish="Ya hemos subido un buen trecho...[K]\n¿Dónde está?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Is it much farther to reach\nthe pinnacle?", french=" Le pinacle est encore loin?", german=" Ist es noch weit bis zur Spitze?", italian="Ci vuole ancora molto per\nraggiungere la vetta?", spanish=" ¿Queda mucho para la cúspide?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="No, not at all.[K] The pinnacle is\nonly a little farther.", french="Non, pas du tout.[K]\nC'est tout près.", german="Nein, überhaupt nicht.[K] Die Spitze\nist schon in greifbarer Nähe.", italian="No, per niente.[K] La vetta è poco\npiù avanti.", spanish="No, para nada.[K] La cúspide está\nsolo un poco más arriba."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I've been thinking about what\ncould have happened, since we haven't seen\nMaster [CS:N]Dialga[CR] so far...", french="J'ai bien réfléchi à ce qui a pu\nse passer depuis le départ de Maître [CS:N]Dialga[CR]...", german="Ich habe mir Gedanken gemacht,\nwas passiert sein könnte. Immerhin haben wir\nMeister [CS:N]Dialga[CR] bisher noch nicht gesehen...", italian="Stavo pensando a quello che\npotrebbe essere accaduto, visto che finora non\nabbiamo trovato traccia del Maestro [CS:N]Dialga[CR]...", spanish="Llevo un rato preguntándome\nlo que puede haber sucedido, dado que no\nhemos visto aún a [CS:N]Dialga[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(3)
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_serebii, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Right.[K] I think he may have\nreached the pinnacle already.", french="Eh bien...[K] il a probablement déjà\natteint le pinacle.", german="Stimmt.[K] Vielleicht ist das so,\nweil [CS:N]Dialga[CR] schon die Spitze erreicht hat.", italian="È vero.[K] Forse ha già raggiunto\nla vetta.", spanish="Cierto.[K] Temo que pueda haber llegado\nya a la cúspide."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Let's hurry.", french=" Dépêchons.", german=" Beeilen wir uns.", italian=" Sbrighiamoci.", spanish=" Démonos prisa."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
