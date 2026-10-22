-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D53P41B/n09a2201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D53P41B) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- supervision_Acting(3) [neutre/état moteur]
  -- supervision_Acting(4) [neutre/état moteur]
  -- supervision_Acting(7) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  local npc_npc_dark_diaruga = SkySceneKit.spawn_npc("dialga", 256, 184, Direction.Down, "NPC_DARK_DIARUGA")
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(10)
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(10)
  local npc_npc_serebii = SkySceneKit.spawn_npc("celebi", 296, 240, Direction.Up, "NPC_SEREBII")
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(10)
  local npc_npc_yonowaaru_n9 = SkySceneKit.spawn_npc("dusknoir", 216, 240, Direction.Up, "NPC_YONOWAARU_N9")
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  -- SetAnimation(48) [anim idle native]
  -- bgm2_PlayFadeIn(BGM_HEAVY_WIND1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  do local p=npc_npc_dark_diaruga.Position; GROUND:MoveToPosition(npc_npc_dark_diaruga, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_dark_diaruga.Position; GROUND:MoveToPosition(npc_npc_dark_diaruga, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_dark_diaruga.Position; GROUND:MoveToPosition(npc_npc_dark_diaruga, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_dark_diaruga.Position; GROUND:MoveToPosition(npc_npc_dark_diaruga, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GIGI![K] GIGIGIGIGIGIGIGIGIGI!", french=" GRR![K] GRRRRRRRRRRRRRRRRRR!", german=" GIGI![K] GIGIGIGIGIGIGIGIGIGI!", italian=" GIGI![K] GIGIGIGIGIGIGIGIGIGI!", spanish=" ¡GUIGUI![K] ¡GUIGUIGUIGUIGUIGUI!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
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
  -- SetAnimation(29) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GRRR-OOOOOO...OOOOOH!", french=" GRRROOOOOO... OOOOOH!", german=" GRRR-OOOOOO...OOOOOH!", italian=" GRRR-OOOOOO... OOOOOH!", spanish=" ¡GRRRRRRRRRRRR!"})
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
  -- SetAnimation(2) [anim idle native]
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(140)
  -- GAP: se_Play(6918) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(20)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(30)
  -- SetAnimation(40) [anim idle native]
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(10)
  -- SetAnimation(31) [anim idle native]
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Down)
  GAME:WaitFrames(5)
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(5) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(5) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(5) [anim idle native]
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" GUHGUHH!", french=" GUHGUHH!", german=" GUHGUH!", italian=" GUHGUHH!", spanish=" ¡Ay!"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" M-my body...[K] My body's heavy!", french=" Mon corps...[K] Il se fait lourd!", german="M-mein Körper...[K]\nMein Körper fühlt sich so schwer an!", italian="I-Il mio corpo...[K] Lo sento così\npesante!", spanish=" El cuerpo...[K] ¡cómo me pesa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" B-but...[K] We did it...", french=" Mais...[K] nous avons réussi...", german="A-aber...[K]\nWir haben es geschafft...", italian=" M-Ma...[K] ce l'abbiamo fatta...", spanish=" Pero...[K] lo hemos conseguido..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yeah...", french=" Ouais...", german=" Ja, das haben wir...", italian=" Sì...", spanish=" Sí..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="We've finally defeated\nPrimal [CS:N]Dialga[CR]...", french="Nous avons enfin vaincu\n[CS:N]Dialga[CR] Primal...", german="Wir haben [CS:N]Schatten-Dialga[CR]\nendlich besiegt.", italian="Finalmente abbiamo sconfitto\n[CS:N]Dialga[CR] Oscuro...", spanish="Al fin hemos derrotado al\n[CS:N]Dialga Primario[CR]..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Daybreak is near...[K] Now...[K]\nNow we can only wait...", french="Le jour va bientôt se lever...[K]\nAdmirez la beauté du jour...", german="Der Tagesanbruch steht kurz\nbevor...[K] Jetzt...[K] Jetzt bleibt uns nichts anderes\nübrig, als zu warten...", italian="Il sole sta per sorgere...[K] Ora...[K]\nnon ci resta che aspettare...", spanish="Se acerca el amanecer.[K]\nAhora...[K] solo nos queda esperar..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Here...[K]\nFor the end to come...", french="Il ne reste qu'à attendre...[K]\nla fin...", german="Lasst uns einfach...[K]\nauf unser Verschwinden warten...", italian=" ... la fine...", spanish="Aguardar aquí...[K] hasta que llegue\nel final."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8454) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="The end is coming...[K]\nWe're fading...", french="Notre fin est proche...[K]\nNous disparaissons...", german="Unsere gemeinsame Reise geht\nzu Ende...[K] Wir werden blasser...", italian="La fine è vicina...[K] stiamo\nscomparendo...", spanish="Se acerca el final...[K]\nNos estamos desvaneciendo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(11536) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GARU...[K] GARURU...", french=" GARU...[K] GARURU...", german=" GARU...[K] GARURU...", italian=" GARU...[K] GARURU...", spanish=" GRUUU...[K] GRUGRUGRUUU..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "exclaim", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(6) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GROOH...[K] GROOOOOH...", french=" GROOH...[K] GROOOOOH...", german=" GROOH...[K] GROOOOOH...", italian=" GROOH...[K] GROOOOOH...", spanish=" GRRRR...[K] GRRRRRR..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- se_FadeOut(11536, 20) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  -- SetOutputAttribute(64) [neutre/état moteur]
  GAME:WaitFrames(60) -- back_SetEffect(12, 60) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  GAME:WaitFrames(20)
  -- GAP: se_Play(8459) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- WaitBackEffect (join)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D01P11B2_12) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "shock", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]D-[K]Dialga[CR]...!", french=" [CS:N]D-[K]Dialga[CR]...!", german=" [CS:N]D-[CR][K][CS:N]Dialga[CR]...", italian=" [CS:N]D-[CR][K][CS:N]Dialga[CR]...!", spanish=" [CS:N]Di[CR]...[K] ¡[CS:N]Dialga[CR]...!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "shock", 1) end)
  -- SetAnimation(37) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" GWAH!", french=" AAARGH!", german=" GWAH!", italian=" GUAH!", spanish=" ¡¡Ah!!"})
  -- GAP: se_Play(11534) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(41) [anim idle native]
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  -- message_Close
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR]!", french=" [CS:N]Noctunoir[CR]!", german=" [CS:N]Zwirrfinst[CR]!", italian=" [CS:N]Dusknoir[CR]!", spanish=" ¡[CS:N]Dusknoir[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" Oooohh...", french=" Oooohh...", german=" Ooooh...", italian=" Ooohhh...", spanish=" Ooooh..."})
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(npc_npc_serebii, Direction.Down)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(11534) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(45)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]C-Celebi[CR] too!", french=" [CS:N]C-Celebi[CR] aussi!", german=" Auch [CS:N]C-Celebi[CR]!", italian=" [CS:N]C-Celebi[CR]! Anche tu!", spanish=" [CS:N]Ce[CR]... ¡[CS:N]Celebi[CR] también!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" GUUUuuuhhhh...[K] [CS:Y]Grovyle[CR]...", french=" Aaaargh...[K] [CS:Y]Massko[CR]...", german=" GUUUuuuh...[K] [CS:Y]Reptain[CR]...", italian=" GUUUuuuhhhh...[K] [CS:Y]Grovyle[CR]...", spanish=" Aaaaaah...[K] [CS:Y]Grovyle[CR]..."})
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_IN_THE_MORNING_SUN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" [CS:Y]Grovyle[CR]...[K] Please tell me...", french=" [CS:Y]Massko[CR]...[K] Dis-moi...", german=" [CS:Y]Reptain[CR]...[K] Bitte sage mir...", italian=" [CS:Y]Grovyle[CR]...[K] Per favore, dimmi...", spanish=" [CS:Y]Grovyle[CR]...[K] Dime una cosa..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" My...[K]my life...", french=" Ma...[K] ma vie...", german=" Meine...[K] Meine Taten...", italian=" La...[K] La mia esistenza...", spanish=" Mi...[K] recuerdo..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Did it shine...?", french=" Se souviendra-t-on de moi...?", german=" Sprechen sie für sich?", italian=" ... ha avuto un valore...?", spanish=" ¿Perdurará?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yes.[K] Extraordinarily.", french=" Oui.[K] Pour toujours.", german=" Ja.[K] Ohne Zweifel.", italian=" Sì.[K] Senza dubbio.", spanish=" Sí.[K] De una forma extraordinaria."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" ...[K]I am glad...", french=" ...[K] Alors, je suis content...", german=" ...[K]Dann war es mir das wert...", italian=" ...[K] Ne sono lieto...", spanish=" Ah...[K] Me alegro..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" I-I am...", french=" Je suis...", german=" I-ich bin...", italian=" I-Io...", spanish=" Estoy..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I am, up to the very end...[K]not\nwavering...[K] Honestly...", french="Jusqu'à la fin...[K] j'ai tenu bon...[K]\nEn toute honnêteté...", german="Ich habe nicht gezaudert...[K]\nBis zum Schluss nicht...[K] Ganz ehrlich...", italian="Ora che è giunta la fine...[K] posso\ndirlo senza esitazioni...[K] e in tutta sincerità...", spanish="Aquí estoy, hasta el último minuto...[K]\nSin flaquear.[K] Sin volver la cara."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" I lived...", french=" J'ai vécu...", german=" Ich habe einfach gehandelt.", italian=" La vita è meravigliosa...", spanish=" He vivido..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Because of you, [CS:Y]Grovyle[CR]...[K]\nThanks to you...", french="Grâce à toi, [CS:Y]Massko[CR]...[K]\nGrâce à toi...", german="[CS:Y]Reptain[CR]...[K] Du hast mir gezeigt,\ndass Taten für sich sprechen...", italian="È merito tuo, [CS:Y]Grovyle[CR]...[K]\nGrazie a te...", spanish="Y ha sido por ti, [CS:Y]Grovyle[CR]...[K]\nGracias a ti..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Thanks to you...[K]I...", french=" Grâce à toi...[K] je...", german=" Dank dir...[K] habe ich...", italian=" Grazie a te...[K] io...", spanish=" Gracias a ti...[K] yo..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" I have no regrets...", french=" ... je n'ai aucun regret...", german="Es gibt für mich nichts\nzu bedauern...", italian=" Io non ho rimpianti...", spanish=" No me arrepiento de nada..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(11536) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(6) [anim idle native]
  GAME:WaitFrames(120)
  -- se_FadeOut(11536, 20) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  -- SetOutputAttribute(64) [neutre/état moteur]
  GAME:WaitFrames(60) -- back_SetEffect(12, 60) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  GAME:WaitFrames(20)
  -- GAP: se_Play(8459) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- WaitBackEffect (join)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D01P11B2_15) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(90)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR]...", french=" [CS:N]Noctunoir[CR]...", german=" [CS:N]Zwirrfinst[CR]...", italian=" [CS:N]Dusknoir[CR]...", spanish=" [CS:N]Dusknoir[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(40) [anim idle native]
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" GUUuhh!", french=" Aaargh!", german=" GUUuh!", italian=" GUUuhh!", spanish=" ¡Aaaah!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(11534) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(41) [anim idle native]
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...![K] The end...!", french=" ...![K] C'est la fin...!", german=" ...[K]Vorbei...", italian=" ...![K] È la fine...!", spanish=" Esto...[K] ¡Esto es el fin!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...[K]Me too...[K] Me too... So slowly...", french=" ...[K] Moi aussi...[K] Lentement...", german="...[K]Auch ich...[K] Auch ich...\nSo langsam...", italian="...[K] Anch'io...[K] lentamente...\nAnch'io...", spanish="Sí...[K] Yo también...[K] Lo estoy notando\nlentamente..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]C-[K]Celebi[CR]...", french=" [CS:N]C-[K]Celebi[CR]...", german=" [CS:N]C-[CR][K][CS:N]Celebi[CR]...", italian=" [CS:N]C-[CR][K][CS:N]Celebi[CR]...", spanish=" [CS:N]Ce[CR]...[K] [CS:N]Celebi[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(43) [anim idle native]
  pcall(function() GAME:MoveCamera(292, 228, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 296, 236, false, 1) -- SlidePositionMark (glissement)
  -- MovePositionMark OBJECT_D01P11B2_13 [cible sans placement SSA zone: mouvement non joué]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(26) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]Celebi[CR]...[K] Are you all right?", french=" [CS:N]Celebi[CR]...[K] Tu vas bien?", german=" [CS:N]Celebi[CR]...[K] Geht es dir gut?", italian=" [CS:N]Celebi[CR]...[K] Va tutto bene?", spanish=" [CS:N]Celebi[CR]...[K] ¿Estás bien?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" Yes...[K] I'm fine...", french=" Oui...[K] Ça va...", german=" Ja...[K] Ich bin in Ordnung...", italian=" Sì...[K] Sto bene...", spanish=" Sí...[K] Estoy bien..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back_SetBackEffect(3) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  GAME:WaitFrames(90)
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Th-this is...", french=" C'est...", german=" D-das ist...", italian=" Q-Questa è...", spanish=" Eso es..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Oh...[K] It's the morning sun...[K]\nThe sun is up...", french=" Oh...[K] Le soleil s'est levé...", german="Oh...[K] Die Morgensonne...[K]\nSie ist aufgegangen...", italian="Oh...[K] È la luce del sole...[K]\nIl sole sta sorgendo...", spanish="Oh...[K] Es el sol del amanecer.[K]\nEl sol está saliendo..."})
  -- message_Close
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V38P06A) [décor sub chargé: Sub_v38p06a]
  -- camera2_SetPositionMark(Position<'m3', 20, 18.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- back2_SetBackEffect(3) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  -- supervision_Acting(5) [neutre/état moteur]
  -- SetOutputAttribute(64) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  -- back2_SetEffect(13, 0) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  SkySubScreen.Show("v38p06a", 30, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V38P06A1_450) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(200)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Can you see it, [CS:N]Celebi[CR]?[K]\nIt's the morning sun.", french="Tu vois, [CS:N]Celebi[CR]?[K]\nLe soleil!", german="Siehst du sie, [CS:N]Celebi[CR]?[K]\nEs ist die Morgensonne.", italian="Riesci a vederlo, [CS:N]Celebi[CR]?[K]\nÈ il sole del mattino.", spanish="¿Lo ves, [CS:N]Celebi[CR]?[K]\nEl sol del amanecer."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" This...[K]this is...", french=" C'est...[K] ça...", german=" Das...[K] Das ist...", italian=" Questo...[K] Questo è...", spanish=" Sí...[K] ¿Lo es?"})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" Is this...[K]the morning sun...?", french=" C'est ça...[K] le soleil?", german=" Das ist also...[K] die Morgensonne?", italian=" È il sole...[K] del mattino...?", spanish=" ¿Lo es realmente...?[K] ¿Es el sol?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" I...[K]I had no idea...", french=" Je n'avais...[K] aucune idée...", german=" Ich...[K] Ich hatte ja keine Ahnung...", italian=" Non...[K] ne avevo idea...", spanish=" Yo...[K] no tenía ni idea..."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="A world in which the sun rises...[K]\nIt is so beautiful...", french="Un monde où le soleil se lève...[K]\nC'est si beau...", german="Eine Welt, in der die Sonne\naufgeht...[K] Wie schön das ist...", italian="Un mondo in cui sorge il sole...[K]\nÈ meraviglioso...", spanish="Un mundo en el que sale el sol...[K]\nEs tan hermoso..."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="The sun...[K] I had no idea that it\ncould be this warm.", french="Le soleil...[K] Il en émane\nune douce chaleur.", german="Die Sonne...[K] Ich wusste nicht,\ndass sie so warm sein würde.", italian="Il sole...[K] Non pensavo che\npotesse essere così caldo.", spanish="El sol...[K] No tenía ni idea de que podía\ncalentar así."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(6) [anim idle native]
  GAME:WaitFrames(60)
  -- GAP: se_Play(5131) — id SE NDS sans portage PMDO identifié
  -- camera2_SetEffect(2, 1, 1.0) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="I...[K] Being able to see the sun\nbefore the end...", french="Je...[K] Assister à un lever\nde soleil avant de disparaître...", german="Ich...[K] Dass ich die Sonne noch\neinmal sehen darf...", italian="Riuscire...[K] a vedere il sole prima\ndi scomparire...", spanish="Poder...[K] Poder ver el sol antes\nde que todo acabe..."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="And...[K] Being able to\nsee it with you...", french="Et...[K] y assister\nen ta compagnie...", german="Und...[K] Dass ich sie gemeinsam\nmit dir sehen darf...", italian=" E...[K] vederlo insieme a te...", spanish=" Y...[K] poder verlo contigo..."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" I am really glad...", french=" Rien que pour ça...", german=" Das macht mich so froh...", italian=" Sono davvero contenta...", spanish=" Realmente me alegro..."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="That I am alive...[K] I am\nreally glad...", french="... la vie...[K] valait la peine d'être\nvécue...", german="Dass ich mit dir hier sein\ndarf...[K] Das macht mich so froh...", italian="... di poter vivere tutto questo...[K]\nSono veramente felice...", spanish=" Me alegro...[K] de haber existido..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I am too.", french=" Je suis bien d'accord.", german=" Oh, mich auch.", italian=" Anch'io lo sono.", spanish=" Yo también."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" Good-bye, [CS:Y]Grovyle[CR]...[K] I...", french=" Au revoir, [CS:Y]Massko[CR]...[K] Je...", german=" Auf Wiedersehen, [CS:Y]Reptain[CR].[K] Ich...", italian=" Addio, [CS:Y]Grovyle[CR]...[K] Io...", spanish=" Adiós, [CS:Y]Grovyle[CR]...[K] Yo..."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" I...[K] (I am so happy...)", french=" Je...[K] (Je suis comblée...)", german=" Ich...[K] (Ich bin so froh...)", italian=" Io...[K] (Io sono così felice...)", spanish=" Yo...[K] (Estoy tan feliz...)"})
  -- message_Close
  -- SetAnimation(3) [anim idle native]
  GAME:WaitFrames(30)
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(30)
  -- SetAnimation(6) [anim idle native]
  -- bgm2_PlayFadeIn(BGM_EARTHQUAKE3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('1', '1', '1', '0')
  GAME:WaitFrames(90)
  pcall(function() SOUND:FadeOutBGM(210) end)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- camera2_SetEffect(0, 0, 0) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetEffect(0): arrêt d'effet caméra
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
