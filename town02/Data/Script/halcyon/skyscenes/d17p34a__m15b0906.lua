-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D17P34A/m15b0906.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_OH_NO non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_D17P34A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_agunomu = SkySceneKit.spawn_npc("azelf", 352, 216, Direction.Down, "NPC_AGUNOMU")
  GROUND:EntTurn(npc_npc_agunomu, Direction.DownRight)
  -- SetAnimation(42) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 352, 144, Direction.Up, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Now, sunk down there...[K] That is\nthe Time Gear, isn't it!", french="Alors, il est là, sous les eaux...[K]\nMon Rouage du Temps.", german="Hier unten im See...[K] Hier liegt\ndas Zahnrad der Zeit, nicht wahr?", italian="Quello laggiù...[K] è l'Ingranaggio\ndel Tempo, non è vero?", spanish="Eso que está hundido ahí...[K]\nEs el Engranaje del Tiempo, ¿verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, npc_npc_agunomu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Fine, then. [CS:N]Azelf[CR], wasn't it?", french=" Soit. [CS:N]Créfadet[CR], c'est bien ça?", german="Na gut. [CS:N]Tobutz[CR] ist dein Name,\nrichtig?", italian="Bene. Allora, [CS:N]Azelf[CR], ti chiami\ncosì, giusto?", spanish="Estupendo.\nTe llamabas [CS:N]Azelf[CR], ¿no?"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I must apologize. But I must\ntake that Time Gear.", french="Toutes mes excuses, mais\nje dois te prendre le Rouage du Temps.", german="Entschuldige bitte, aber ich muss\ndieses Zahnrad der Zeit mitnehmen.", italian="Ti chiedo scusa, ma devo\nprendermi l'Ingranaggio del Tempo.", spanish="Debo disculparme. Pero tengo\nque llevarme ese Engranaje del Tiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english=" Ugh...[K]w-wait...", french=" Argh...[K] attends...", german=" Ugh...[K] W-warte...", italian=" Argh...[K] A-Aspetta...", spanish=" ¡Ay![K] Espera."})
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english=" Hold it... [CS:N]Grovyle[CR]...", french=" Attends... [CS:N]Massko[CR]...", german=" Warte... [CS:N]Reptain[CR]...", italian=" Non muoverti... [CS:N]Grovyle[CR]...", spanish=" Espera... [CS:N]Grovyle[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" You know...[K]my name?", french=" Tu connais...[K] mon nom?", german=" Du kennst...[K] meinen Namen?", italian=" Conosci...[K] il mio nome?", spanish="¿Cómo sabes...?[K] ¿Cómo sabes\nmi nombre?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english=" [CS:N]Grovyle[CR] the thief...", french=" [CS:N]Massko[CR] le voleur...", german=" Der Dieb [CS:N]Reptain[CR]...", italian=" [CS:N]Grovyle[CR] il ladro...", spanish=" [CS:N]Grovyle[CR], el ladrón..."})
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english="I heard from [CS:N]Uxie[CR] and [CS:N]Mesprit[CR]\nthat you were coming.", french="[CS:N]Créhelf[CR] et [CS:N]Créfollet[CR]\nm'ont informé de ta venue.", german="[CS:N]Selfe[CR] und [CS:N]Vesprit[CR] haben mir\ngesagt, dass du kommen würdest.", italian="[CS:N]Uxie[CR] e [CS:N]Mesprit[CR] mi avevano\nannunciato il tuo arrivo.", spanish="[CS:N]Uxie[CR] y [CS:N]Mesprit[CR] me dijeron\nque vendrías."})
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english="It would have been better if I\njust knocked you out directly...", french="J'aurais préféré te mettre K.O.\nd'entrée...", german="Es wäre besser gewesen, ich\nhätte dich sofort angegriffen und aus dem\nWeg geräumt...", italian="Avrei preferito non ricorrere a\nquesto.", spanish="Tendría que haberte atacado\nen cuanto llegaste aquí..."})
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english="But I also thought that I could\npossibly lose...", french="Mais j'ai aussi envisagé le cas\noù je perdrais...", german="Aber ich habe befürchtet, dass\nich vielleicht verlieren könnte...", italian="Ma avendo considerato la\npossibilità di perdere contro di te...", spanish="Pero me di cuenta de que podría\nperder la pelea..."})
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english=" So I set up a fail-safe system.", french="Alors j'ai mis au point\nun système infaillible.", german="Also habe ich einen\nnarrensicheren Plan ausgetüftelt.", italian="... ho escogitato un piano\nd'emergenza.", spanish="Así que preparé un mecanismo\nde defensa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, npc_npc_agunomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_agunomu, Direction.Down)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  -- GAP: se_Play(7178) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitSe
  -- bgm2_PlayFadeIn(BGM_EARTHQUAKE2) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" What did you do?!", french=" Qu'est-ce que tu as fait?!", german=" Was hast du gemacht?!?", italian=" Cos'hai fatto!?", spanish=" ¡¿Qué has hecho?!"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(180), 60, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(15)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:FadeOut(false, 15)
  -- camera_SetEffect(0): arrêt d'effet caméra
  SkySceneKit.cleanup_npcs()
end
