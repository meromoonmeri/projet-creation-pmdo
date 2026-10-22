-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P04A/s30a0304.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_SPINDAS_CAFE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_P01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_patchiiru = SkySceneKit.spawn_npc("spinda", 352, 176, Direction.Down, "NPC_PATCHIIRU")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, "happy", 1) end)
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="Use the recycled items to\nexplore the world!", french="Utilisez les objets échangés pour\nexplorer le monde!", german="Verwendet die\nwiederverwerteten Items, um die Welt\nzu erkunden!", italian="Usate gli strumenti riciclati\nper esplorare il mondo!", spanish="¡Usad los objetos reciclados\npara ver mundo!"})
  -- message_KeyWait
  -- SetAnimation(26) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="Don't you think it's a magnificent\nproject, full of hopes and dreams?", french="N'est-ce pas là un projet\nprodigieux, apte à réaliser les rêves\nde tout un chacun?", german="Ist es nicht ein wundervolles\nProjekt voller Hoffnungen und Träume?", italian="Non pensate che sia un progetto\nmagnifico, pieno di sogni e di speranze?", spanish="¿No os parece que es un\nproyecto magnífico y totalmente de ensueño?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(20)
  -- message_FacePositionOffset(3, 3) [neutre/état moteur]
  local npc_npc_bariyaado = SkySceneKit.spawn_npc("mr_mime", 384, 208, Direction.Up, "NPC_BARIYAADO")
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english=" Whoa! This is genius!", french=" Ouah! Quel génie!", german=" Wow! Das ist genial!", italian=" Wow! È geniale!", spanish=" ¡Guau! ¡Menuda genialidad!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_pachirisu = SkySceneKit.spawn_npc("pachirisu", 304, 232, Direction.UpRight, "NPC_PACHIRISU")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pachirisu) end)
  SkySceneKit.say({english=" It seems so economical!", french=" Il fallait y penser!", german=" Das klingt so wirtschaftlich!", italian=" Sembra così vantaggioso!", spanish=" ¡Parece la mar de económico!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="We've already sent out an\nexploration team to find unexplored areas!", french="Nous avons déjà déployé une\néquipe d'exploration chargée de découvrir de\nnouveaux territoires!", german="Wir haben bereits ein\nErkundungsteam losgeschickt, um nach\nunentdeckten Gebieten zu forschen!", italian="Abbiamo già incaricato una\nsquadra d'esplorazione di trovare luoghi\nsconosciuti!", spanish="Ya hemos enviado a un equipo\nexplorador para hallar zonas desconocidas."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="There should be new discoveries\nbefore long!", french="De nouvelles découvertes\nne devraient pas tarder!", german="Wir erwarten schon in Kürze\nerste Entdeckungen!", italian="Tra non molto dovremmo avere\nqualche novità!", spanish="¡Seguro que muy pronto se\nproducirán descubrimientos increíbles!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="So, everyone!\nPlease keep recycling,\nmore and more every day!", french="Alors, mes amis!\nEchangez, échangez, ne faiblissez pas!\nEncore et toujours plus!", german="Deswegen, alle miteinander,\nnutzt die Wiederverwertung jeden Tag ein\nbisschen mehr. Alle haben etwas davon!", italian="Quindi ricordate tutti!\nContinuate a riciclare, ogni giorno\nsempre di più!", spanish="Por eso os pido a todos que\nsigáis reciclando, cada día un poquito más."})
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="Let's all work together and find\nunexplored areas!", french="Unissons nos efforts pour\ndécouvrir de nouvelles régions inexplorées!", german="Lasst uns alle zusammenarbeiten\nund unentdeckte Gebiete finden!", italian="Lavoriamo tutti insieme per\nscoprire nuovi posti sconosciuti!", spanish="¡Trabajemos juntos para hallar\nzonas inexploradas!"})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5138) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_pachirisu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bariyaado, "happy", 1) end)
  local npc_npc_nyorotono = SkySceneKit.spawn_npc("politoed", 432, 240, Direction.UpLeft, "NPC_NYOROTONO")
  pcall(function() GROUND:CharSetEmote(npc_npc_nyorotono, "happy", 1) end)
  local npc_npc_togepii = SkySceneKit.spawn_npc("togepi", 424, 216, Direction.UpLeft, "NPC_TOGEPII")
  pcall(function() GROUND:CharSetEmote(npc_npc_togepii, "happy", 1) end)
  local npc_npc_sandopan = SkySceneKit.spawn_npc("sandslash", 272, 192, Direction.UpRight, "NPC_SANDOPAN")
  pcall(function() GROUND:CharSetEmote(npc_npc_sandopan, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, "happy", 1) end)
  local npc_npc_okutan = SkySceneKit.spawn_npc("octillery", 416, 192, Direction.UpLeft, "NPC_OKUTAN")
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  local npc_npc_jiguzaguma = SkySceneKit.spawn_npc("zigzagoon", 352, 200, Direction.Up, "NPC_JIGUZAGUMA")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_herakurosu = SkySceneKit.spawn_npc("heracross", 312, 208, Direction.Up, "NPC_HERAKUROSU")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_sutoraiku = SkySceneKit.spawn_npc("scyther", 272, 232, Direction.UpRight, "NPC_SUTORAIKU")
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(26) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: URRÀ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- se_FadeOut(5138, 90) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(60)
  GROUND:EntTurn(npc_npc_jiguzaguma, Direction.Right)
  GROUND:EntTurn(npc_npc_bariyaado, Direction.Left)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_okutan, Direction.Down)
  GROUND:EntTurn(npc_npc_togepii, Direction.Up)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_sandopan, Direction.Down)
  local npc_npc_zanguusu = SkySceneKit.spawn_npc("zangoose", 256, 216, Direction.UpRight, "NPC_ZANGUUSU")
  GROUND:EntTurn(npc_npc_zanguusu, Direction.Right)
  GROUND:EntTurn(npc_npc_sutoraiku, Direction.Up)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_herakurosu, Direction.Down)
  GROUND:EntTurn(npc_npc_pachirisu, Direction.Up)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_nyorotono, Direction.Left)
  local npc_npc_rediba = SkySceneKit.spawn_npc("ledyba", 408, 240, Direction.UpLeft, "NPC_REDIBA")
  GROUND:EntTurn(npc_npc_rediba, Direction.Right)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(16), 32, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wow! So cool!", french=" Ouah! Quelle classe!", german=" Wow! Spitze!", italian=" Wow! Forte!", spanish=" ¡Jo, qué guay!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wow! So amazing!", french=" Ouah! Quelle classe!", german=" Wow! Wie grandios!", italian=" Wow! Che bello!", spanish=" ¡Guau, es increíble!"})
  else
  SkySceneKit.say({english=" Amazing! So cool!", french=" Ouah! Quelle classe!", german=" Klasse! Wie cool!", italian=" Com'è emozionante!", spanish=" ¡Es increíble! ¡Mola!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Recycling leftover items, trading\nthem around... They're bound to turn into\nunbelievable treasures!", french="Echanger des objets superflus\ncontre de meilleurs objets... Au final, on\ndoit pouvoir obtenir des trésors fabuleux!", german="Überflüssige Items\nwiederverwerten... Sie tauschen, damit\nsie zu unglaublichen Schätzen werden!", italian="Riciclare strumenti inutilizzati,\nscambiarli in giro... potremmo ritrovarci\nin mano dei veri e propri tesori!", spanish="Al reciclar objetos sobrantes\ne intercambiarlos... ¡lograremos\ntesoros increíbles!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Recycling leftover items, trading\nthem around... They're bound to turn into\nunbelievable treasures!", french="Echanger des objets superflus\ncontre de meilleurs objets... Au final, on\ndoit pouvoir obtenir des trésors fabuleux!", german="Überflüssige Items\nwiederverwerten... Sie tauschen, damit\nsie zu unglaublichen Schätzen werden!", italian="Riciclare strumenti inutilizzati,\nscambiarli in giro... potremmo ritrovarci\nin mano dei veri e propri tesori!", spanish="Al reciclar objetos sobrantes\ne intercambiarlos... ¡lograremos\ntesoros increíbles!"})
  else
  SkySceneKit.say({english="Recycling leftover items, trading\nthem around... They're bound to turn into\nunbelievable treasures!", french="Echanger des objets superflus\ncontre de meilleurs objets... Au final, on\ndoit pouvoir obtenir des trésors fabuleux!", german="Überflüssige Items\nwiederverwerten... Sie tauschen, damit\nsie zu unglaublichen Schätzen werden!", italian="Riciclare strumenti inutilizzati,\nscambiarli in giro... potremmo ritrovarci\nin mano dei veri e propri tesori!", spanish="Al reciclar objetos sobrantes\ne intercambiarlos... ¡lograremos\ntesoros increíbles!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And being able to go to\nunexplored places!", french="Et que dire de la possibilité de\npartir explorer de nouveaux territoires!", german="Und dabei zu helfen, unentdeckte\nOrte zu finden!", italian="E non dimentichiamo\nla possibilità di visitare luoghi inesplorati!", spanish="¡Y exploraremos lugares\nrecónditos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And being able to explore\nunexplored areas!", french="Et que dire de la possibilité de\npartir explorer de nouveaux territoires!", german="Und dabei zu helfen, unentdeckte\nGebiete zu erforschen!", italian="E non dimentichiamo\nla possibilità di visitare luoghi inesplorati!", spanish="¡Y podremos explorar\nlugares recónditos!"})
  else
  SkySceneKit.say({english="And being able to explore the\nunexplored!", french="Et que dire de la possibilité de\npartir explorer de nouveaux territoires!", german="Und dazu noch das Unentdeckte\nzu erforschen!", italian="E non dimentichiamo\nla possibilità di visitare luoghi inesplorati!", spanish="¡Y alcanzaremos\nlugares recónditos!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yowza! I'm so excited!", french="Youhou! Je suis au comble\nde l'excitation!", german=" Oh wow! Ich bin so aufgeregt!", italian=" Yuppi! Sono troppo emozionato!", spanish=" ¡Yuju! ¡Ya estoy de los nervios!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wahoo! I'm so excited!", french="Youhou! Je suis au comble\nde l'excitation!", german=" Oh ja! Ich bin so aufgeregt!", italian=" Yuhuuu! Che emozione!", spanish=" ¡Yupi! ¡Qué nervios tengo ya!"})
  else
  SkySceneKit.say({english=" Ooh! I'm so excited!", french="Youhou! Je suis au comble\nde l'excitation!", german=" Oooh! Ich bin so aufgeregt!", italian=" Oooh! Mi batte forte il cuore!", spanish=" ¡Jo, qué emoción!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's recycle a bunch, OK?", french="Il faut qu'on essaye d'échanger\nle plus d'objets possible, d'accord?", german="Lass uns so viel wie möglich\nwiederverwerten, in Ordnung?", italian="Diamoci sotto e ricicliamo\na più non posso, ok?", spanish="Vamos a reciclar un montón,\n¿vale?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We should recycle more!", french="Il faut qu'on essaye d'échanger\nle plus d'objets possible, d'accord?", german="Wir sollten noch mehr\nwiederverwerten!", italian=" Dobbiamo riciclare di più!", spanish=" ¡Tenemos que reciclar más!"})
  else
  SkySceneKit.say({english=" We should recycle more!", french="Il faut qu'on essaye d'échanger\nle plus d'objets possible, d'accord?", german="Wir sollten noch mehr\nwiederverwerten!", italian=" Dobbiamo riciclare di più!", spanish=" ¡Deberíamos reciclar más!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  -- SetAnimation(4) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, nil, 0) end) -- EFFECT_NONE
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  GROUND:TeleportTo(hero, 364, 236, Direction.Down)
  GROUND:TeleportTo(partner, 332, 236, Direction.Down)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(30)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_P01P04A, 'UM07') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(65) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(11) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(12) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(13) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:FadeIn(30)
  SkySceneKit.cleanup_npcs()
end
