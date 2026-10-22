-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D57P41A/n04a0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(159, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D57P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(1) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Growing Anxiety.ogg", true) end)
  GAME:WaitFrames(30)
  local npc_npc_goosuto = SkySceneKit.spawn_npc("haunter", 232, 192, Direction.Down, "NPC_GOOSUTO")
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="Heh heh heh! You've come back![K]\nYou don't learn, do you?!", french="Hé hé hé! Tu es revenue![K]\nMa petite leçon ne t'a pas suffi, pas vrai?!", german="Hehehe! Da bist du ja wieder![K]\nDu lernst auch nicht dazu, nicht wahr?!?", italian="Eh eh eh! Sei tornata![K]\nNon ti è bastata la lezione di prima, eh?!", spanish="¡Je, je, je! ¡Has vuelto![K]\nNo aprendes nunca, ¡¿verdad?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I'll apprehend you this time! I'll\nshow you!", french="Cette fois je t'arrêterai!\nTu vas voir!", german="Diesmal verhafte ich dich! Du\nwirst schon sehen!", italian="Questa volta ti catturerò!\nVedrai!", spanish="Esta vez te capturaré. ¡Vas a\nver lo que es bueno!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" I told you already!", french=" Je me répète peut-être...", german=" Das klingt bekannt!", italian=" Te l'ho già detto!", spanish=" ¡Eso ya lo he oído antes!"})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" No one has ever caught me!", french="... mais personne ne m'a\njamais attrapé!", german="Aber mich zu fangen\nhaben viele schon versucht!", italian="Nessuno è mai riuscito\na catturarmi!", spanish=" ¡Y aún no me han pillado nunca!"})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="The explorers who have tried to\ncatch me...", french="Les explorateurs qui ont\ntenté de le faire...", german="Die Erkunder, die es probiert\nhaben...", italian="Tutti gli esploratori che ci hanno\nprovato...", spanish="Los exploradores que\nhan intentado capturarme..."})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="All became discouraged...[K]\nLost their confidence...", french="... ont fini par perdre courage...[K]\net perdre confiance...", german="Alle haben aufgegeben...[K]\nUnd ihr Selbstvertrauen verloren...", italian="Hanno perso il loro coraggio...[K]\nla fiducia in se stessi...", spanish="Se dieron todos por vencidos...[K]\nPerdieron la confianza en sí mismos..."})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" That kind of disappointment...", french="Le genre de sentiment\nde désespoir...", german=" Diese Form der Enttäuschung...", italian="E se anche tu vuoi assaporare\nquesta sensazione...", spanish="Si no sabes lo que es perder así\nla confianza..."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="Heh heh heh! I'll be happy to\nshow you how it feels!", french="... que je me ferai un plaisir de\nte faire ressentir! Hé hé hé!", german="Hehehe! Ich zeige dir gerne, wie\nsie sich anfühlt!", italian="... sarò ben felice di pensarci io!\nEh eh eh!", spanish="Te lo demostraré\ncon mucho gusto. ¡Je, je, je!"})
  -- message_Close
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
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" Let's go!", french=" En garde!", german=" Los geht's!", italian=" Fatti sotto!", spanish=" ¡Vamos allá!"})
  -- message_Close
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(159, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
