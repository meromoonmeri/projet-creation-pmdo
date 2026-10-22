-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D41P41A/s22p1301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(69, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D41P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_DOWN_A_DARK_PATH non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  local npc_npc_daakurai = SkySceneKit.spawn_npc("darkrai", 280, 168, Direction.Down, "NPC_DAAKURAI")
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" Ah, this time...", french=" Ah, cette fois-ci...", german=" Ah, dieses Mal...", italian=" Ah, questa volta...", spanish=" Esta vez..."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="This time there will be no\nmistake. I will rid myself of you at last.", french="Cette fois-ci, le doute n'est plus\npermis. Je vais enfin me débarrasser de vous.\nA tout jamais...", german="Diesmal gibt es keinen Zweifel.\nIch werde euch endlich aus dem Weg räumen.", italian="... non farò errori. Mi libererò\ndi voi, finalmente!", spanish="Esta vez no habrá errores. Aquí\nse acabará vuestra aventura."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5133) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 15)
  GAME:WaitFrames(15)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  local npc_npc_kureseria = SkySceneKit.spawn_npc("cresselia", 296, 224, Direction.Up, "NPC_KURESERIA")
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "shock", 1) end)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(7)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" And with you out of the way...", french=" Et quand vous aurez disparu...", german="Und wenn ihr mir nicht mehr im\nWeg steht...", italian=" E quando voi non ci sarete più...", spanish=" Y después..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" I can transform this world...", french="... je pourrai faire de\nce monde...", german="Dann kann ich diese Welt\numgestalten...", italian=" ... potrò trasformare il mondo.", spanish=" Podré transformar el mundo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" into a realm of darkness!", french=" ... un royaume de l'ombre!", german=" In ein Reich der Dunkelheit!", italian="Il mondo sarà il regno\ndell'oscurità!", spanish=" ¡En un reino de oscuridad!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" H-here they come!", french=" Ils... ils arrivent!", german=" H-hier kommen sie!", italian=" E-Ecco che arrivano!", spanish=" ¡Aquí vienen!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" H-here they come!", french=" Ils... ils arrivent!", german=" H-hier kommen sie!", italian=" E-Ecco che arrivano!", spanish=" ¡Aquí vienen!"})
  else
  SkySceneKit.say({english=" H-here they come!", french=" Ils... ils arrivent!", german=" H-hier kommen sie!", italian=" E-Ecco che arrivano!", spanish=" ¡Aquí vienen!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Be careful!", french=" Prudence!", german=" Seid vorsichtig!", italian=" Attenzione!", spanish=" ¡Cuidado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I won't let the world be covered in\ndarkness!)", french="(Je ne laisserai pas l'ombre engloutir\nle monde!)", german="(Ich werde nicht zulassen, dass die Welt in\nDunkelheit gehüllt wird!)", italian="(Non lascerò che il mondo venga\navvolto dall'oscurità!)", spanish="(¡No permitiré que reine la oscuridad en\nel mundo!)"})
  else
  SkySceneKit.say({english="(I won't let the world be covered in\ndarkness!)", french="(Je ne laisserai pas l'ombre engloutir\nle monde!)", german="(Ich werde nicht zulassen, dass die Welt in\nDunkelheit gehüllt wird!)", italian="(Non lascerò che il mondo venga\navvolto dall'oscurità!)", spanish="(¡No permitiré que reine la oscuridad en\nel mundo!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It will never happen!)", french="(Jamais ça n'arrivera!)", german="(Das wird niemals geschehen!)", italian="(Non deve succedere!)", spanish="(¡Nunca!)"})
  else
  SkySceneKit.say({english="(It will never happen!)", french="(Jamais ça n'arrivera!)", german="(Das wird niemals geschehen!)", italian="(Non deve succedere!)", spanish="(¡Nunca!)"})
  end
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" This is it![K] Attack!", french=" A l'attaque![K] Maintenant!", german="Jetzt ist es so weit![K]\nAngriff!", italian=" Basta parlare![K] All'attacco!", spanish=" ¡Se acabó![K] ¡Al ataque!"})
  -- message_Close
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:StopBGM() end)
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
  -- GAP: se_Play(5136) — id SE NDS sans portage PMDO identifié
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
