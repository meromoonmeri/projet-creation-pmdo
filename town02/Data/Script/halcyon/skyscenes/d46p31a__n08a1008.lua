-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D46P31A/n08a1008.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(135, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D46P31A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 184, 232, Direction.DownRight, "NPC_YAMIRAMI")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_yamirami2 = SkySceneKit.spawn_npc("sableye", 280, 232, Direction.DownLeft, "NPC_YAMIRAMI2")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_yamirami3 = SkySceneKit.spawn_npc("sableye", 184, 312, Direction.UpRight, "NPC_YAMIRAMI3")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_yamirami4 = SkySceneKit.spawn_npc("sableye", 280, 312, Direction.UpLeft, "NPC_YAMIRAMI4")
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(1)
  GROUND:MoveToPosition(hero, 228, 292, false, 2)
  -- GAP: BGM BGM_OH_NO non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Seems you're having a tough\nbattle, [CS:N]Dusknoir[CR].", french="On dirait que ça se corse pour\ntoi, [CS:N]Noctunoir[CR].", german="Sieht nach einem harten\nKampf aus, [CS:N]Zwirrfinst[CR].", italian="Sembra che te la stia passando\nmale, [CS:N]Dusknoir[CR].", spanish="Parece que estás librando\nuna batalla muy dura, [CS:N]Dusknoir[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_yonowaaru_n8 = SkySceneKit.spawn_npc("dusknoir", 232, 264, Direction.Up, "NPC_YONOWAARU_N8")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru_n8, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Alas![K] If not held back by these\ninjuries from fighting you, I could thrash\nthese [CS:N]Sableye[CR]!", french="Oui![K] Si tu ne m'avais pas blessé\nauparavant, je ne ferais qu'une bouchée de\nces [CS:N]Ténéfix[CR]!", german="Leider![K] Ohne diese Verletzungen\naus unserem Kampf könnte ich diese [CS:N]Zobiris[CR]\nohne Probleme zerschmettern!", italian="Ahimè![K] Se non fossi ancora\ndebole per le ferite subite lottando contro\ndi te, mi sbarazzerei subito di questi [CS:N]Sableye[CR]!", spanish="¡Qué pena![K] Si no me hubieras\nhecho tanto daño en nuestra pelea, ¡ahora\nacabaría con estos [CS:N]Sableye[CR] sin problemas!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(8), p.Y+(8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.Down)
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-8), false, 1) end -- SlidePositionOffset
  do local p=npc_npc_yamirami4.Position; GROUND:MoveToPosition(npc_npc_yamirami4, p.X+(-8), p.Y+(-8), false, 1) end -- Move2PositionOffset
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Up)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_yonowaaru_n8.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n8, p.X+(0), p.Y+(8), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  -- SetAnimation(2) [anim idle native]
  do local p=npc_npc_yamirami3.Position; GROUND:MoveToPosition(npc_npc_yamirami3, p.X+(8), p.Y+(-8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami2.Position; GROUND:MoveToPosition(npc_npc_yamirami2, p.X+(-8), p.Y+(8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Don't get distracted![K]\nHere they come!", french="Reste concentré![K]\nIls arrivent!", german="Aufgepasst![K]\nDa sind sie wieder!", italian="Lascia perdere ora![K]\nStanno arrivando!", spanish="¡No bajes la guardia![K]\n¡Aquí vienen!"})
  -- message_Close
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:N]Sableye[CR]: Wheh-heh-heh!", french="[CS:N]Ténéfix[CR]: Whé hé hé!", german="[CS:N]Zobiris[CR]: Wähähäh!", italian="[CS:N]Sableye[CR]: Meh-eh-eh!", spanish="[CS:N]Sableye[CR]: ¡Je, je, je!"})
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- message_CloseEnforce
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(135, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
