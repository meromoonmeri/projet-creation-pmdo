-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D57P42A/n04a1301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(161, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D57P42A) [neutre/état moteur]
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
  SkySceneKit.say({english="Heh heh![K] No matter how many\ntimes you try, the result stays the same!", french="Hé hé![K] Tu as beau essayer,\nle résultat est toujours le même!", german="Hehe![K] Wie häufig du es auch\nprobierst, das Ergebnis wird dasselbe bleiben!", italian="Eh eh![K] Puoi provarci quante\nvolte vuoi, il risultato non cambierà!", spanish="¡Je, je![K] Da igual las veces que\nlo intentes, el resultado no va a cambiar."})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="I am invincible![K] You cannot\ndefeat me!", french="Je suis invincible![K]\nTu ne peux pas me battre!", german="Ich bin unbesiegbar![K] Du kannst\nmich nicht schlagen!", italian="Sono invincibile![K] Non puoi\nsconfiggermi!", spanish="¡Soy invencible![K] ¡No puedes\nderrotarme!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Invincibility...[K]doesn't exist!", french=" L'invincibilité...[K] ça n'existe pas!", german=" Unbesiegbarkeit...[K] gibt es nicht!", italian=" L'invincibilità...[K] non esiste!", spanish=" La invencibilidad...[K] ¡no existe!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I'm going to apprehend you\nthis time!", french=" Je vais t'attraper cette fois!", german=" Dieses Mal nehme ich dich fest!", italian=" Questa volta ti prenderò!", spanish=" ¡Esta vez pienso arrestarte!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" Heh heh! Persistent!", french=" Hé hé! Têtue, la petite!", german=" Hehe! Wie hartnäckig!", italian=" Eh eh! Che zuccona!", spanish=" ¡Je, je! Eres insistente."})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="Those who don't know when to\ngive up will be really disappointed when\nthey fail!", french="Ceux qui ne savent pas accepter\nla défaite risquent des déceptions encore plus\ngrandes!", german="Jene, die nicht wissen, wann es\nbesser ist, aufzugeben, werden an der großen\nEnttäuschung zerbrechen, sobald sie scheitern!", italian="Meglio lasciar perdere subito che\nsubire una sconfitta e dover fare i conti\ncon una cocente delusione!", spanish="Quien no sabe cuándo hay que\nabandonar se llevará una gran decepción\ncuando fracase."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="That anguish...[K] How do you like\nthe taste of it?", french="Cette angoisse...[K] J'espère que\ntu en apprécies la saveur.", german="Diese Pein...[K]\nSag, wie schmeckt sie dir?", italian="La senti questa sensazione\ndi angoscia?[K] Cosa si prova, eh?", spanish="Esa angustia...[K] Espero que\nte guste saborearla..."})
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
  SkySceneKit.say({english=" Let's go!", french=" En garde!", german=" Lass uns beginnen!", italian=" Preparati!", spanish=" ¡Vamos allá!"})
  -- message_Close
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(161, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
