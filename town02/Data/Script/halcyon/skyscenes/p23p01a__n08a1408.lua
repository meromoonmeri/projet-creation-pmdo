-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P23P01A/n08a1408.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_P23P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_FUTURE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() GAME:MoveCamera(224, 272, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 48, 288, Direction.Right, "NPC_YAMIRAMI")
  GROUND:MoveToPosition(npc_npc_yamirami, 224, 284, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english="Wheh-heh-heh![K]\nLooks like [CS:Y]Grovyle[CR] hasn't arrived yet...", french="Whé hé hé![K]\nOn dirait que [CS:Y]Massko[CR] n'est pas encore là...", german="Wähähäh![K] Anscheinend\nist [CS:Y]Reptain[CR] noch nicht angekommen...", italian="Meh-eh-eh![K]\nSembra che [CS:Y]Grovyle[CR] non sia ancora arrivato...", spanish="¡Je, je, je![K] Parece que [CS:Y]Grovyle[CR]\ntodavía no ha llegado..."})
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english="I'll run and report to\nMaster [CS:N]Dialga[CR].", french=" Je cours le dire à Maître [CS:N]Dialga[CR].", german="Auf, auf! Das muss ich sofort\nMeister [CS:N]Dialga[CR] berichten.", italian="Andrò a fare rapporto\nal Maestro [CS:N]Dialga[CR].", spanish=" Iré corriendo a informar a [CS:N]Dialga[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7192) — id SE NDS sans portage PMDO identifié
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(-8), p.Y+(0), false, 1) end
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  -- GAP: SetEffect EFFECT_ROCKS_HITTING — VFX sans émote PMDO équivalente
  -- SetAnimation(28) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "shock", 1) end)
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(8), p.Y+(0), false, 2) end -- SlidePositionOffset
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(8), g.ViewCenter.Y+(0), 3, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(12)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" [CS:Y]Gr-[K]Grovyle[CR]!", french=" [CS:Y]Ma... [K]Massko[CR]!!", german=" [CS:Y]R-[CR][K][CS:Y]Reptain[CR]!!!", italian=" [CS:Y]Gr-[CR][K][CS:Y]Grovyle[CR]!!!", spanish=" [CS:Y]Gro[CR]...[K] ¡¡[CS:Y]Grovyle[CR]!!"})
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Wheh-heh-heh!", french=" Whé hé hé!", german=" Wähähäh!", italian=" Meh-eh-eh!", spanish=" ¡Je, je, je!"})
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(16), p.Y+(0), false, 1) end -- SlidePositionOffset
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- message_CloseEnforce
  local npc_npc_yonowaaru_n8 = SkySceneKit.spawn_npc("dusknoir", 384, 288, Direction.Left, "NPC_YONOWAARU_N8")
  GROUND:MoveToPosition(npc_npc_yonowaaru_n8, 284, 284, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami, 284, 284, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(-48), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(5)
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" M-Master [CS:N]Dusknoir[CR]!", french=" M-Maître [CS:N]Noctunoir[CR]!", german=" M-meister [CS:N]Zwirrfinst[CR]!", italian=" M-Maestro [CS:N]Dusknoir[CR]!", spanish=" ¡[CS:N]Dusknoir[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(16), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "shock", 1) end)
  GROUND:EntTurn(npc_npc_yamirami, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(8), p.Y+(0), false, 2) end -- SlidePositionOffset
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" There's something I want to ask.", french=" J'ai une question à te poser.", german=" Ich habe da eine Frage.", italian=" Ho una domanda da farti.", spanish=" Me gustaría preguntarte algo."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Sorry, but you have to come\nwith me.", french="Désolé, mais il va falloir\nme suivre.", german="Entschuldigung, aber du musst\njetzt mit mir kommen.", italian="Mi dispiace, ma devi venire\ncon noi.", spanish="Y para ello tienes que venir\ncon nosotros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(9) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Wheh-heh-heh!", french=" Whé hé hé!", german=" Wähähäh!", italian=" Meh-eh-eh!", spanish=" Je, je..."})
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(16), p.Y+(0), false, 1) end
  GAME:WaitFrames(8)
  do local p=npc_npc_yonowaaru_n8.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n8, p.X+(-16), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Right)
  do local p=npc_npc_yonowaaru_n8.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n8, p.X+(180), p.Y+(0), false, 1) end
  GAME:WaitFrames(12)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(36), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(4)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(24), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(20)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(24), p.Y+(0), false, 2) end
  GAME:WaitFrames(12)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(20), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(15)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(28), p.Y+(0), false, 2) end
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(24), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_yamirami, Direction.Right)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(8)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(180), p.Y+(0), false, 2) end
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(180), p.Y+(0), false, 2) end
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 60)
  SkySceneKit.cleanup_npcs()
end
