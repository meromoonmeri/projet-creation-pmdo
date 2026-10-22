-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D57P43A/n04a2003.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_D57P43A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="You've been deceiving\nexploration team after exploration team that\nway, until now...", french="Vous avez berné toutes les\néquipes d'exploration, l'une après l'autre,\njusqu'à aujourd'hui...", german="So habt ihr ein Erkundungsteam\nnach dem anderen an der Nase herumgeführt.\nBis jetzt...", italian="Per tutto questo tempo avete\ningannato una squadra d'esplorazione dietro\nl'altra con questo trucco...", spanish="Así habéis ido engañando a\nun equipo explorador tras otro, hasta ahora..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" That's how you always escaped!", french="C'est pour ça que vous avez\ntoujours pu vous échapper!", german="Und deswegen seid ihr\nbisher immer davongekommen!", italian="Ecco perché riuscivate sempre\na fuggire!", spanish="¡Así es como habéis\nconseguido escapar siempre!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_goosuto = SkySceneKit.spawn_npc("haunter", 240, 216, Direction.Down, "NPC_GOOSUTO")
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" Heh!", french=" Hé!", german=" He!", italian=" Eh...", spanish=" ¡Je!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- MoveHeight(1, 2) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(1, 0) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2)
  -- MoveHeight(1, 2) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(1, 0) [élévation d'objet NDS non simulée - documenté]
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" Heh heh heh!", french=" Hé hé hé!", german=" Hehehe!", italian=" Eh eh eh!", spanish=" ¡Je, je, je!"})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" Looks like we're found out!", french="On dirait qu'on a percé notre\npetit secret!", german="Sieht fast so aus, als sei unser\nGeheimnis aufgeflogen!", italian="Pare che tu ci abbia\nsmascherati!", spanish=" ¡Parece que nos han calado!"})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="Now that our secret has been\ndiscovered...", french="Maintenant que tu connais\nla vérité...", german="Aber du weißt sicher, was das\nbedeutet, oder?", italian="Ora che il nostro segreto\nè stato scoperto...", spanish="Ahora que has desentrañado\nnuestro secreto..."})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" We can't let you return!", french="... on ne peut pas te\nlaisser repartir!", german="Wir können dich unmöglich\nwieder gehen lassen!", italian=" ... non possiamo lasciarti andare!", spanish=" ¡No podemos dejar que vuelvas!"})
  -- message_Close
  -- bgm2_PlayFadeIn(BGM_EARTHQUAKE1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Wha...", french=" Que...", german=" Wa...", italian=" Cos...", spanish=" ¿Qué...?"})
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 45) -- screen_FlushOut
  GAME:WaitFrames(5)
  GAME:FadeIn(45) -- screen_FlushIn
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 45) -- screen_FlushOut
  GAME:WaitFrames(5)
  GAME:FadeIn(45) -- screen_FlushIn
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: BGM BGM_EARTHQUAKE3 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('1', '1', '1', '0')
  GAME:WaitFrames(90)
  -- GAP: se_Play(9992) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(10)
  -- supervision_Acting(4) [neutre/état moteur]
  GAME:WaitFrames(15)
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(10)
  -- supervision_Acting(3) [neutre/état moteur]
  GAME:WaitFrames(60)
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
end
