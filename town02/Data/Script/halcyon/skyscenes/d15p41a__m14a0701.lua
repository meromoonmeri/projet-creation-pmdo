-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D15P41A/m14a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(23, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D15P41A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  local npc_npc_emuritto = SkySceneKit.spawn_npc("mesprit", 304, 160, Direction.Down, "NPC_EMURITTO")
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english=" You're back?!", french=" Encore vous?!", german=" Ihr seid zurück?!?", italian=" Ancora voi?", spanish=" ¡¿Habéis vuelto?!"})
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="You can come back all you like,\nbut you'll never get the Time Gear from me!", french="Vous aurez beau revenir, jamais\nvous ne mettrez la main sur le Rouage\ndu Temps!", german="Ihr könnt so oft kommen, wie\nihr wollt, ich werde euch das Zahnrad der Zeit\nniemals überlassen!", italian="È tutto inutile! Non riuscirete\nmai a prendere l'Ingranaggio del Tempo!", spanish="Podéis regresar las veces\nque queráis, ¡pero nunca conseguiréis\narrebatarme el Engranaje del Tiempo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You're wrong! We didn't come\nhere to steal the Time Gear!", french="C'est un malentendu! On n'est pas\nlà pour voler le Rouage du Temps!", german="Du irrst dich! Wir sind nicht\nhier, um das Zahnrad der Zeit zu stehlen!", italian="Ma non capisci! Non siamo qui\nper rubare l'Ingranaggio del Tempo!", spanish="¡Te equivocas! ¡No hemos venido\na robar el Engranaje del Tiempo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You're wrong! We didn't come\nhere to steal the Time Gear!", french="C'est un malentendu! On n'est pas\nlà pour voler le Rouage du Temps!", german="Du irrst dich! Wir sind nicht\nhier, um das Zahnrad der Zeit zu stehlen!", italian="Ti sbagli! Non siamo qui\nper rubare l'Ingranaggio del Tempo!", spanish="¡Te equivocas! ¡No hemos venido\na robar el Engranaje del Tiempo!"})
  else
  SkySceneKit.say({english="You're mistaken! We didn't come\nhere to steal the Time Gear!", french="C'est un malentendu! On n'est pas\nlà pour voler le Rouage du Temps!", german="Du verstehst das falsch! Wir\nsind nicht hier, um das Zahnrad der Zeit zu\nstehlen!", italian="Ti sbagli! Non siamo qui\nper rubare l'Ingranaggio del Tempo!", spanish="¡Te equivocas! ¡No hemos venido\na robar el Engranaje del Tiempo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="You say that...[K] But you can't be\ntrusted!", french="C'est ce que vous dites...[K]\nMais vous n'êtes pas dignes de confiance!", german="Das sagst du...[K]\nAber ich traue dir nicht!", italian="Come osate...[K] prendervi gioco\ndi me!", spanish="Eso decís...[K] ¡pero no puedo\nfiarme de vuestras intenciones!"})
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english=" Get ready!", french=" En garde!", german=" Macht euch bereit!", italian=" In guardia!", spanish=" ¡Preparaos!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(23, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
