-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P28A/s32a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D73P28A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(9) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_denryuu = SkySceneKit.spawn_npc("ampharos", 288, 232, Direction.UpRight, "NPC_DENRYUU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(5) [anim idle native]
  -- GAP: BGM BGM_FIRE_CRACKLING4 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(10)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(hero, 228, 268, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 252, 292, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 204, 292, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 228, 300, false, 2) end end
  GAME:WaitFrames(60)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(20)
  GROUND:EntTurn(npc_npc_denryuu, Direction.Right)
  GAME:WaitFrames(40)
  GROUND:EntTurn(npc_npc_denryuu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_denryuu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.UpRight) end end
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english=" Oh! It's Team [team:]!", french=" Oh! C'est l'Equipe [team:]!", german=" Oh! Es ist Team [team:]!", italian=" Oh! È il Team [team:]!", spanish="¡Anda, pero si es el [CS:X]Equipo[CR]\n[team:]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_denryuu, 228, 244, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  GROUND:EntTurn(npc_npc_denryuu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="I heard from [CS:N]Shaymin[CR] you were\nfinally able to reach the summit.\nCongratulations!", french="[CS:N]Shaymin[CR] m'a dit que vous aviez\nfinalement réussi à atteindre le sommet.\nFélicitations!", german="Ich habe von [CS:N]Shaymin[CR] gehört,\ndass ihr den Gipfel letztendlich erreicht habt.\nHerzlichen Glückwunsch!", italian="[CS:N]Shaymin[CR] mi ha raccontato tutto.\nAlla fine ce l'avete fatta a raggiungere\nla cima. Congratulazioni!", spanish="[CS:N]Shaymin[CR] me ha dicho\nque al fin llegasteis a la cima. ¡Os felicito!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_denryuu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="Huh? How is that [CS:N]Sneasel[CR] you\nhelped at the 7th Station Clearing doing?", french="Comment se porte [CS:N]Farfuret[CR]\ndepuis qu'il a été secouru à la trouée du\n7[F:E] Relais?", german="Bitte? Wie es [CS:N]Sniebel[CR] geht,\ndem ihr an der 7. Zwischenlagerlichtung\ngeholfen habt?", italian="Uh? Volete sapere come sta\n[CS:N]Sneasel[CR], quel Pokémon che avete soccorso\nal Bivacco 7?", spanish="¿Cómo? ¿Que cómo se encuentra\nel [CS:N]Sneasel[CR] al que ayudasteis\nen la Base del Séptimo Puerto?"})
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="Oh, him. The next day, while I\nwas out on my rounds patrolling the mountain,\nhe snuck off...", french="Le lendemain, il a profité de\nmon absence pendant que je patrouillais dans\nla montagne pour s'éclipser...", german="Oh... Er hat sich am nächsten\nTag davongeschlichen, als ich auf meiner\nBergwacht-Patrouille war...", italian="Oh, beh. Il giorno dopo, mentre\nstavo svolgendo il mio solito giro di controllo\ndella montagna, se l'è filata...", spanish="Ah, ese... Pues resulta que\nal día siguiente, mientras yo patrullaba por la\nmontaña, se escabulló..."})
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="Well, it seems like he recovered\nhis strength. You don't really need to worry.", french="Ça veut sans doute dire qu'il\na vite retrouvé ses forces. Inutile de\ns'inquiéter pour lui.", german="Nun, anscheinend hat er seine\nStärke zurückgewonnen. Ihr braucht euch\nkeine Sorgen mehr zu machen.", italian="Beh, pare che abbia recuperato\ntutte le forze. Non c'è più bisogno che ve\nne preoccupiate, davvero.", spanish="Por lo visto recuperó sus\nfuerzas, así que no hay de qué preocuparse."})
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="Oh, that reminds me. He left\nthis behind...", french="Oh, ça me fait penser...\nIl a laissé ça...", german="Oh, da fällt mir ein...\nEr hat das hier zurückgelassen.", italian="Oh, ora che ci penso...\nha lasciato questo...", spanish="Ah, eso me recuerda que\nse dejó esto..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_denryuu, 268, 212, false, 2)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.UpRight)
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.UpRight) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_denryuu, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- SetAnimation(5) [anim idle native]
  GAME:WaitFrames(50)
  -- SetAnimation(2) [anim idle native]
  -- GAP: se_Play(5124) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(npc_npc_denryuu, 228, 244, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  GROUND:EntTurn(npc_npc_denryuu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="I think it's a token of\nhis appreciation...", french="Je pense que c'est pour montrer\nsa gratitude...", german="Ich denke, es ist ein Zeichen\nseiner Dankbarkeit...", italian="Penso che sia il suo modo\ndi ringraziare...", spanish="Diría que es una muestra de\nagradecimiento..."})
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english=" You should take it.", french=" Vous devriez le prendre.", german=" Ihr solltet es nehmen.", italian=" Dovreste prenderlo voi.", spanish=" Deberíais quedároslo."})
  -- message_Close
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8710) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(30)
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_BAG_FULL"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_BAG_FULL, 0, 0)) [ProcessSpecial(PROCESS_SPECIAL_IS_BAG_FULL): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  -- @label_0 [étiquette de flux ExplorerScript]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[48] = 1 -- $SCENARIO_MAIN_BIT_FLAG[48] = 1 (ROM)
  -- item_SetTableData(0, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(ProcessSpecial(PROCESS_SPECIAL_ADD_TABLE_ITEM_TO_BAG, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="[CN]This is...", french="[CN]C'est...", german="[CN]Das ist...", italian="[CN]Questo è...", spanish="[CN]Es..."})
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="[CN][player] received\n[CN]a [CS:I]Sky Gift[CR]!", french="[CN][player] reçoit\n[CN]un [CS:I]Don du Ciel[CR].", german="[CN][player] erhält\n[CN]ein [CS:I]Himmelspräsent[CR].", italian="[CN][player] ha ricevuto\n[CN]un [CS:I]Dono Cielo[CR].", spanish="[CN]¡[player] ha obtenido\n[CN]un [CS:I]Regalo Cielo[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="[CN]You gently open the lid...", french="[CN]Vous ouvrez délicatement le couvercle...", german="[CN]Du öffnest behutsam den Deckel...", italian="[CN]Lo apri lentamente...", spanish="[CN]Abres la tapa con cuidado..."})
  -- message_Close
  -- GAP: se_Play(11021) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="[CN]Inside was the\n[CN][s_item:0]!", french="[CN]A l'intérieur se trouve\n[CN]l'objet [s_item:0]!", german="[CN]Darin war das Item\n[CN][s_item:0]!", italian="[CN]... e al suo interno trovi lo strumento\n[CN][s_item:0]!", spanish="[CN]¡Había un objeto\n[CN][s_item:0] dentro!"})
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="[CN]A warm and fuzzy feeling falls over you...", french="[CN]Que c'est agréable de recevoir un cadeau...", german="[CN]Ein warmes, angenehmes Kribbeln\n[CN]überkommt dich...", italian="[CN]Una dolce sensazione di calore ti investe...", spanish="[CN]Te invade una sensación de calidez..."})
  -- message_Close
  elseif true then -- default
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="Well, I thought so, but you\nseem to have too much already.", french="Enfin, malheureusement,\nil semblerait que vous transportiez déjà\ntrop d'objets.", german="Auf jeden Fall habe ich mir das\nso vorgestellt. Aber euer Beutel ist wohl voll.", italian="Mmmh, vedo che avete la Sacca\ngià piena.", spanish="O eso pensaba yo, pero ya veo\nque no tienes espacio ni para un alfiler."})
  -- message_Close
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="All right, I'll hold on to this\nfor you, then.", french="Très bien, je vous le garde\nau chaud, en attendant.", german="Na gut, ich werde es solange\nfür euch aufbewahren.", italian="Va bene, allora lo conserverò io\nper voi.", spanish="Bueno, pues entonces ya\nos lo guardo yo."})
  -- message_Close
  end
  end
  SkySceneKit.cleanup_npcs()
end
