-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D53P41A/n09a1801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=48, sub=9} -- $SCENARIO_SIDE = scn[48,9] (ROM)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(148, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- bgm2_PlayFadeIn(BGM_HEAVY_WIND1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- GAP: se_Play(11533) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(90)
  -- se_FadeOut(11533, 60) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(70)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I knew it...[K] I knew you had\nalready reached the pinnacle!", french="Je le savais...[K] Je savais que\nvous aviez déjà atteint le pinacle!", german="Ich wusste es...[K] Ich wusste,\ndass du die Spitze schon erreicht hast!", italian="Lo sapevo...[K] Sapevo che avevi\ngià raggiunto la vetta!", spanish="Lo sabía...[K] ¡Sabía que ya habías\nllegado a la cúspide!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Primal [CS:N]Dialga[CR]!", french=" [CS:N]Dialga[CR] Primal!", german=" [CS:N]Schatten-Dialga[CR]!", italian=" [CS:N]Dialga[CR] Oscuro!", spanish=" ¡[CS:N]Dialga Primario[CR]!"})
  -- message_Close
  -- back_SetGround(LEVEL_D53P41A) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- supervision_Acting(3) [neutre/état moteur]
  -- supervision_Acting(4) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_ActingInvisible(6) [acting caché superviseur NDS]
  -- supervision_Acting(7) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(3) [anim idle native]
  local npc_npc_dark_diaruga = SkySceneKit.spawn_npc("dialga", 256, 184, Direction.Down, "NPC_DARK_DIARUGA")
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(1)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-16), false, 2) end
  local npc_npc_yonowaaru_n9 = SkySceneKit.spawn_npc("dusknoir", 216, 272, Direction.Up, "NPC_YONOWAARU_N9")
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(0), p.Y+(-32), false, 2) end
  local npc_npc_serebii = SkySceneKit.spawn_npc("celebi", 296, 264, Direction.Up, "NPC_SEREBII")
  do local p=npc_npc_serebii.Position; GROUND:MoveToPosition(npc_npc_serebii, p.X+(0), p.Y+(-24), false, 2) end
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GRRR-OOOOOO...OOOOOH!", french=" GRRROOOOOO... OOOOOH!", german=" GRRR-OOOOOO...OOOOOH!", italian=" GRRR-OOOOOO... OOOOOH!", spanish=" ¡¡GRRRRRRRRRR!!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- SetAnimation(2) [anim idle native]
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2)
  -- GAP: se_Play(6918) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(30)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitSe
  -- SetAnimation(48) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GIGI...[K] GIGIGIGI...", french=" GRR...[K] GRRRRRRRR...", german=" GIGI...[K] GIGIGIGI...", italian=" GIGI...[K] GIGIGIGI...", spanish=" GUIGUI...[K] GUIGUIGUIGUI..."})
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GI![K] GIGAGAGAGAGAGAGAGAGAGA!", french=" GRR![K] GRRRRRRRRRRRRRRRRRRR!", german=" GI![K] GIGAGAGAGAGAGAGAGAGAGA!", italian=" GI![K] GIGAGAGAGAGAGAGAGAGAGA!", spanish=" ¡GUI![K] ¡GUIGAGAGAGAGAGAGAGA!"})
  -- SetAnimation(29) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GRRR-OOOOOO...OOOOOH!", french=" GRRROOOOOO... OOOOOH!", german=" GRRR-OOOOOO...OOOOOH!", italian=" GRRR-OOOOOO... OOOOOH!", spanish=" ¡¡GRRRRRRRRRR!!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dark_diaruga, Direction.DownRight)
  -- SetAnimation(46) [anim idle native]
  GAME:WaitFrames(90)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GROUND:EntTurn(npc_npc_dark_diaruga, Direction.Right)
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dark_diaruga, Direction.Down)
  -- SetAnimation(4) [anim idle native]
  -- message_CloseEnforce
  -- GAP: se_Play(11532) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(5) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(60)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(8), 3, false) end) -- MovePositionOffset performer/caméra
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- SetAnimation(59) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "shock", 1) end)
  -- SetAnimation(55) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "shock", 1) end)
  -- SetAnimation(24) [anim idle native]
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_serebii.Position; GROUND:MoveToPosition(npc_npc_serebii, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D52P32A2_434) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(15)
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(30)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitSe
  -- SetAnimation(48) [anim idle native]
  -- SetAnimation(39) [anim idle native]
  -- SetAnimation(35) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "shock", 1) end)
  -- message_SetWaitMode(45, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" GWOOOoooh!", french=" Aaaaaahhh!", german=" GWOOOoooh!", italian=" GUOOOoooh!", spanish=" ¡¡¡AAAAAAH!!!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "shock", 1) end)
  -- message_SetWaitMode(60, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" GYAA!", french=" AAAARGH!", german=" GYAA!", italian=" GUAAAH!", spanish=" ¡¡AH!!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_SetWaitMode(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Guh...[K] A-are you all right?", french=" Gulp...[K] Tout va bien?", german=" Guh...[K] I-ist alles in Ordnung?", italian=" Guh...[K] T-Tutto bene?", spanish=" Oh...[K] ¿Estás bien?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" Yeah![K] But...", french=" Oui![K] Mais...", german=" Ja![K] Bis auf...", italian=" Sì![K] Però...", spanish=" ¡Sí![K] Pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="But [CS:N]Dialga[CR]...[K] He seems to be\nin pain...", french=" [CS:N]Dialga[CR]...[K] On dirait qu'il souffre...", german="Es sieht so aus, als ob sich\n[CS:N]Dialga[CR]...[K] vor Schmerzen krümmt...", italian="Però [CS:N]Dialga[CR]...[K] Sembra che stia\nsoffrendo...", spanish=" Pero [CS:N]Dialga[CR]...[K] parece estar sufriendo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5126) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GIGI...[K] GIGIGIGIGIGIGIGI...", french=" GRR...[K] GRRRRRRRR...", german=" GIGI...[K] GIGIGIGIGIGIGIGI...", italian=" GIGI...[K] GIGIGIGIGIGIGIGI...", spanish=" GUIGUI...[K] GUIGUIGUIGUIGUIGUI..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" The planet's moving again...", french="La planète a recommencé\nà se mouvoir...", german=" Der Planet bewegt sich wieder...", italian="Il pianeta ha ricominciato\na muoversi...", spanish=" El planeta vuelve a moverse..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="It seems to be hurting Master\n[CS:N]Dialga[CR]'s darkened heart!", french="Il semblerait que cela affecte\nle cœur assombri de Maître [CS:N]Dialga[CR]!", german="Dies fügt dem verdunkelten Herz\nvon Meister [CS:N]Dialga[CR] wohl Schaden zu!", italian="... e sembra che questo stia\ncausando un profondo dolore al cuore\noscuro di [CS:N]Dialga[CR]!", spanish="¡Eso parece estar dañando el\ncorazón de [CS:N]Dialga[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]Celebi[CR]![K] Look behind [CS:N]Dialga[CR]!", french=" [CS:N]Celebi[CR]![K] Regarde, derrière [CS:N]Dialga[CR]!", german=" [CS:N]Celebi[CR]![K] Dort, hinter [CS:N]Dialga[CR]!", italian=" [CS:N]Celebi[CR]![K] Guarda dietro [CS:N]Dialga[CR]!", spanish=" ¡[CS:N]Celebi[CR]![K] ¡Mira detrás de [CS:N]Dialga[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" Yeah![K] The Passage of Time!", french=" Je le vois![K] Le Couloir du Temps!", german=" Ja![K] Der Zeittunnel!", italian=" Sì![K] È il Portale del Tempo!", spanish=" ¡Sí![K] ¡El Pasaje del Tiempo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8454) — id SE NDS sans portage PMDO identifié
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-88), 59, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(90)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(88), 59, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(30)
  -- se_FadeOut(8454, 60) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GRRR-OOOOOO...OOOOOH!", french=" GRRROOOOOO... OOOOOH!", german=" GRRR-OOOOOO...OOOOOH!", italian=" GRRR-OOOOOO... OOOOOH!", spanish=" ¡¡GRRRRRRRRRR!!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dark_diaruga, Direction.DownRight)
  -- SetAnimation(46) [anim idle native]
  GAME:WaitFrames(2) -- join WaitSe
  -- camera_SetEffect(0): arrêt d'effet caméra
  GROUND:EntTurn(npc_npc_dark_diaruga, Direction.Right)
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dark_diaruga, Direction.Down)
  -- SetAnimation(4) [anim idle native]
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="It would be very dangerous if\nthe Passage of Time were to be damaged!", french="Ce serait catastrophique si\nle Couloir du Temps était endommagé!", german="Es könnte sehr gefährlich sein,\nwenn der Zeittunnel beschädigt wird!", italian="Sarebbe estremamente\npericoloso se il Portale del Tempo\nvenisse danneggiato!", spanish="¡Sería muy peligroso que\nel Pasaje del Tiempo resultase dañado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "exclaim", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Th-this area...[K] Just little by\nlittle, this area...", french=" Oh...[K] regardez...", german="D-dieses Gebiet...[K] Nach und nach\nverschwinden in ihm die Spuren\ndes Zeitstillstands...", italian="Q-Questa zona...[K] Poco a poco,\nquesta zona...", spanish=" Esta zona...[K] poco a poco..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" It's becoming brighter...", french="Oui, il y a de plus en plus\nde lumière...", german=" Es wird heller...", italian=" ... sta diventando più luminosa...", spanish=" Se vuelve resplandeciente..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(11533) — id SE NDS sans portage PMDO identifié
  -- SetupOutputAttributeAndAnimation<object OBJECT_D53P41A1_464> [prop décor NDS, rendu du ground]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D53P41A1_464) [routine d'objet NDS non simulée - documenté]
  -- se_FadeOut(11533, 60) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "shock", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" The wind is stronger!", french=" Et le vent souffle plus fort!", german=" Der Wind hat zugenommen!", italian=" Il vento è più forte!", spanish=" ¡El viento es más fuerte!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GIGIGIGIGIGI!", french=" GRRRRRRRRRRR!", german=" GIGIGIGIGIGI!", italian=" GIGIGIGIGIGI!", spanish=" ¡GUIGUIGUIGUIGUIGUI!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8454) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "exclaim", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="Oh![K] There's a light emanating\nfrom [CS:N]Dialga[CR]'s body?!", french="Oh![K] Le corps de [CS:N]Dialga[CR] émet\nune lueur étrange?!", german="Oh![K] Licht strömt aus dem\nKörper von [CS:N]Dialga[CR]?!?", italian="Oh![K] Il corpo di [CS:N]Dialga[CR] emana\nuna luce?!", spanish="¡Oh![K] ¡¿Una luz emana del cuerpo\nde [CS:N]Dialga[CR]?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(10)
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(10)
  -- supervision_Acting(4) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(45)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "exclaim", 1) end)
  GAME:WaitFrames(2)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Right)
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" Our...[K]our bodies too?!", french=" Et...[K] les nôtres aussi?!", german="Aus...[K] Aus unseren\nKörpern ebenso?!?", italian=" Anche...[K] Anche i nostri corpi?!", spanish=" Y...[K] ¡¿también del nuestro?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- se_FadeOut(8454, 120) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- GAP: BGM BGM_DIALGAS_FIGHT_TO_THE_FINISH non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" History is being distorted!", french="Le cours de l'histoire est en\ntrain de changer!", german=" Die Geschichte wird verzerrt!", italian=" La storia è stata distorta!", spanish=" ¡La historia está siendo alterada!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" History...distorted?!", french=" L'histoire... changée?!", german=" Geschichte... verzerrt?!?", italian=" La storia... distorta?!", spanish=" ¿Alterada? ¡¿En serio?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Our...[K] The end is coming...[K]\nIt's getting close!", french="Notre...[K] notre fin arrive...[K]\nElle approche!", german="Uns...[K] Uns läuft die Zeit davon...[K]\nDas Ende kommt immer näher und näher!", italian="La...[K] La nostra fine è vicina...[K]\nManca poco!", spanish="Eso parece...[K] El fin se aproxima...[K]\n¡Ya casi ha llegado la hora!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Wie bitte?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Until we disappear, we should do\neverything we can to bring Master [CS:N]Dialga[CR]\nback to his senses!", french="Avant de disparaître, faisons de\nnotre mieux pour que Maître [CS:N]Dialga[CR] retrouve\nla raison.", german="Bis zu unserem Verschwinden\nsollten wir alles uns Mögliche tun, um Meister\n[CS:N]Dialga[CR] wieder zur Vernunft zu bringen!", italian="Prima di sparire, dobbiamo fare\ntutto ciò che è in nostro potere per riportare\nil Maestro [CS:N]Dialga[CR] alla ragione!", spanish="Hasta que desaparezcamos,\ntenemos que hacer lo posible para que\n[CS:N]Dialga[CR] recupere la cordura."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_serebii, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Oh![K] For the future!", french=" Oh![K] Pour le futur!", german=" Genau![K] Im Namen der Zukunft!", italian=" Sì![K] Per il futuro!", spanish=" ¡Oh![K] ¡Por el futuro!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Our fight...[K] This is the final one!", french=" Ce combat...[K] est le dernier!", german="Dieser Kampf...[K]\nEs wird unser letzter sein!", italian=" Ci siamo...[K] È lo scontro finale!", spanish=" Este combate...[K] ¡es el definitivo!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="... ([c_name:NPC_HERO_FIRST]![K]\n[c_name:NPC_PARTNER_FIRST]!)", french="... ([c_name:NPC_HERO_FIRST]![K]\n[c_name:NPC_PARTNER_FIRST]!)", german="...([c_name:NPC_HERO_FIRST]![K]\n[c_name:NPC_PARTNER_FIRST]!)", italian="... ([c_name:NPC_HERO_FIRST]![K]\n[c_name:NPC_PARTNER_FIRST]!)", spanish=" Ah... (¡[c_name:NPC_HERO_FIRST]![K] ¡[c_name:NPC_PARTNER_FIRST]!)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(Please! Lend me your strength![K]\nOur final strength!)", french="(Prêtez-moi votre force![K]\nPour l'ultime bataille!)", german="(Bitte! Meine Kräfte...[K]\nSie dürfen mich jetzt nicht verlassen!)", italian="(Vi prego! Donatemi la vostra\nforza![K] Per la nostra ultima battaglia!)", spanish="(¡Os lo ruego! ¡Prestadme\nvuestra fuerza![K] ¡Será la última vez!)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Let's go!", french=" Allons-y!", german=" Auf geht's!", italian=" Andiamo!", spanish=" ¡Vamos allá!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GRRR-OOOOOO...OOOOOH!", french=" GRRROOOOOO... OOOOOH!", german=" GRRR-OOOOOO...OOOOOH!", italian=" GRRR-OOOOOO... OOOOOH!", spanish=" ¡¡GRRRRRRRRRR!!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dark_diaruga, Direction.DownRight)
  -- SetAnimation(46) [anim idle native]
  GAME:WaitFrames(2) -- join WaitSe
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- message_CloseEnforce
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(148, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
