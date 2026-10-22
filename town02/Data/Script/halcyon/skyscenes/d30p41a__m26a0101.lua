-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D30P41A/m26a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(27, 0) -- $SCENARIO_MAIN = scn[27,0] (ROM)
  -- back_SetGround(LEVEL_D30P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_dark_diaruga = SkySceneKit.spawn_npc("dialga", 272, 288, Direction.Down, "NPC_DARK_DIARUGA")
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- bgm2_PlayFadeIn(BGM_HEAVY_FEELING) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GRRR-OOOOOO...OOOOOH!", french=" GRRR-OOOOOO... OOOOOH!", german=" GRRR-OOOOOO...OOOOOH!", italian=" GRRR-OOOOOO... OOOOOH!", spanish=" ¡GRRRRRRR!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5126) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(50)
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
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We...[K]did it...", french=" On...[K] on a réussi...", german=" Wir...[K] Wir haben es geschafft...", italian=" Ce...[K] l'abbiamo fatta...", spanish=" Lo...[K] conseguimos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We...[K]did it...", french=" On...[K] on a réussi...", german=" Wir...[K] Wir haben es geschafft...", italian=" Ce l'abbiamo...[K] fatta...", spanish=" Lo...[K] conseguimos."})
  else
  SkySceneKit.say({english=" We...[K]did it...", french=" On...[K] on a réussi...", german=" Wir...[K] Wir haben es geschafft...", italian=" Ce l'abbiamo...[K] fatta...", spanish=" Lo...[K] conseguimos."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(25) [anim idle native]
  do local p=npc_npc_dark_diaruga.Position; GROUND:MoveToPosition(npc_npc_dark_diaruga, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_dark_diaruga.Position; GROUND:MoveToPosition(npc_npc_dark_diaruga, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_dark_diaruga.Position; GROUND:MoveToPosition(npc_npc_dark_diaruga, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_dark_diaruga.Position; GROUND:MoveToPosition(npc_npc_dark_diaruga, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GRR...[K] GRRRRRR...", french=" GRR...[K] GRRRRRR...", german=" GRR...[K] GRRRRRR...", italian=" GRR...[K] GRRRRRR...", spanish=" GRRRRRR...[K] GRR..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" OK, [hero]![K] It's time!", french="Allez, [hero]![K] C'est\nle moment ou jamais!", german=" Okay, [hero]![K] Es ist Zeit!", italian="Ok, [hero]![K]\nÈ il momento!", spanish="¡Vamos allá, [hero]![K]\n¡Es el momento!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK, [hero]![K] It's time!", french="Allez, [hero]![K] C'est\nle moment ou jamais!", german=" Okay, [hero]![K] Es ist Zeit!", italian="Ok, [hero]![K]\nÈ il momento!", spanish="¡Vamos allá, [hero]![K]\n¡Es el momento!"})
  else
  SkySceneKit.say({english=" OK, [hero]![K] It's time!", french="Allez, [hero]![K] C'est\nle moment ou jamais!", german=" Okay, [hero]![K] Es ist Zeit!", italian="Ok, [hero]![K]\nÈ il momento!", spanish="¡Vamos allá, [hero]![K]\n¡Es el momento!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="While [CS:N]Dialga[CR] is down, I'll go put\nin the Time Gears.", french="Je vais remettre les Rouages du\nTemps en place tant que [CS:N]Dialga[CR] est à terre.", german="Während [CS:N]Dialga[CR] am Boden liegt,\nsetze ich die Zahnräder der Zeit ein.", italian="Mentre [CS:N]Dialga[CR] è a terra, vado\na posizionare gli Ingranaggi del Tempo.", spanish="Aprovecharé que [CS:N]Dialga[CR]\nestá fuera de combate para colocar\nlos Engranajes del Tiempo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="While [CS:N]Dialga[CR] is still down, I'll go\nput in the Time Gears.", french="Je vais remettre les Rouages du\nTemps en place tant que [CS:N]Dialga[CR] est à terre.", german="Während [CS:N]Dialga[CR] noch am Boden\nliegt, setze ich die Zahnräder der Zeit ein.", italian="Mentre [CS:N]Dialga[CR] è a terra, vado\na posizionare gli Ingranaggi del Tempo.", spanish="Aprovecharé que [CS:N]Dialga[CR]\nestá fuera de combate para colocar\nlos Engranajes del Tiempo."})
  else
  SkySceneKit.say({english="While [CS:N]Dialga[CR] is down, I'll go put\nin the Time Gears.", french="Je vais remettre les Rouages du\nTemps en place tant que [CS:N]Dialga[CR] est à terre.", german="Während [CS:N]Dialga[CR] am Boden liegt,\nsetze ich die Zahnräder der Zeit ein.", italian="Mentre [CS:N]Dialga[CR] è a terra, vado\na posizionare gli Ingranaggi del Tempo.", spanish="Aprovecharé que [CS:N]Dialga[CR]\nestá fuera de combate para colocar\nlos Engranajes del Tiempo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 244, 316, false, 2)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_EARTHQUAKE2 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wa-waah!", french=" Ouaaaah!", german=" W-waah!", italian=" Ah-aaah!", spanish=" ¡Aaaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wa-waah!", french=" Ouaaaah!", german=" W-waah!", italian=" Ah-aaah!", spanish=" ¡Aaaah!"})
  else
  SkySceneKit.say({english=" Wa-waah!", french=" Ouaaaah!", german=" W-waah!", italian=" Ah-aaah!", spanish=" ¡Aaaah!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(20)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V25P03A) [décor sub chargé: Sub_v25p03a]
  -- camera2_SetPositionMark(Position<'m1', 19.5, 13.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v25p03a", 5, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  -- GAP: se_Play(7691) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Th-this...", french=" Cette...", german=" D-das...", italian=" Q-Questa...", spanish=" Este..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Th-this...", french=" Cette...", german=" D-das...", italian=" Q-Questo...", spanish=" Este..."})
  else
  SkySceneKit.say({english=" Th-this...", french=" Cette...", german=" D-das...", italian=" Q-Questo...", spanish=" Este..."})
  end
  GROUND:EntTurn(hero, Direction.Up)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This quake is worse than\nbefore!", french="Cette secousse est de loin\nla plus puissante!", german="Das Beben ist schlimmer als\nvorher!", italian="Questa scossa è stata peggiore\ndelle precedenti!", spanish="¡Este terremoto es mucho peor\nque los anteriores!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This tremor is the worst\nit's been!", french="Cette secousse est de loin\nla plus puissante!", german="Das Beben ist das\nschlimmste bisher!", italian="Questo tremore è stato il\npeggiore!", spanish="¡Este terremoto es mucho peor\nque los anteriores!"})
  else
  SkySceneKit.say({english="This tremor is the strongest\nso far!", french="Cette secousse est de loin\nla plus puissante!", german="Das Beben ist das\nstärkste, das es bis jetzt gab!", italian="Questo tremore è stato di gran\nlunga il più forte!", spanish="¡Este terremoto es mucho peor\nque los anteriores!"})
  end
  -- message_Close
  -- se_FadeOut(7691, 45) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:P]T-Temporal Tower[CR] is...)", french="(La... la [CS:P]Tour du Temps[CR] est...)", german="(D-der [CS:P]Zeitturm[CR] ist...)", italian="(La [CS:P]T-Torre del Tempo[CR] sta...)", spanish="(La [CS:P]Torre del Tiempo[CR]...)"})
  else
  SkySceneKit.say({english="([CS:P]T-Temporal Tower[CR] is...)", french="(La... la [CS:P]Tour du Temps[CR] est...)", german="(D-der [CS:P]Zeitturm[CR] ist...)", italian="(La [CS:P]T-Torre del Tempo[CR] sta...)", spanish="(La [CS:P]Torre del Tiempo[CR]...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:P]Temporal Tower[CR] must be nearing total\ncollapse...)", french="(La [CS:P]Tour du Temps[CR] va bientôt s'effondrer\npour de bon...)", german="(Der [CS:P]Zeitturm[CR] muss vor dem totalen\nZusammenbruch stehen...)", italian="(La [CS:P]Torre del Tempo[CR] sta per crollare\ndefinitivamente...)", spanish="(La [CS:P]Torre del Tiempo[CR] debe de estar\na punto de derrumbarse...)"})
  else
  SkySceneKit.say({english="([CS:P]Temporal Tower[CR] must be nearing total\ncollapse...)", french="(La [CS:P]Tour du Temps[CR] va bientôt s'effondrer\npour de bon...)", german="(Der [CS:P]Zeitturm[CR] muss vor dem totalen\nZusammenbruch stehen...)", italian="(La [CS:P]Torre del Tempo[CR] sta per crollare\ndefinitivamente...)", spanish="(La [CS:P]Torre del Tiempo[CR] debe de estar\na punto de derrumbarse...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(If...[K] If that were to happen...)", french="(Si...[K] si ça devait arriver...)", german="(Wenn...[K] Wenn das passieren würde...)", italian="(Se...[K] Se succedesse...)", spanish="(Si...[K] Si eso sucediera...)"})
  else
  SkySceneKit.say({english="(If...[K] If that were to happen...)", french="(Si...[K] si ça devait arriver...)", german="(Wenn...[K] Wenn das passieren würde...)", italian="(Se...[K] Se succedesse...)", spanish="(Si...[K] Si eso sucediera...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The destruction will accelerate...[K]until the\nplanet is fully paralyzed!)", french="(... la destruction du temps s'accélérerait...[K]\njusqu'à ce que la planète soit complètement\nparalysée!)", german="(Die Zerstörung der Zeit würde sich\nbeschleunigen...[K] So lange, bis der Planet völlig\ngelähmt ist!)", italian="(... la distruzione si farebbe più rapida...[K]\nfinché il pianeta non sarà completamente\nparalizzato!)", spanish="(El tiempo se destruiría...[K] ¡y el planeta\nse paralizaría completamente!)"})
  else
  SkySceneKit.say({english="(The destruction will accelerate...[K]until the\nplanet is fully paralyzed!)", french="(... la destruction du temps s'accélérerait...[K]\njusqu'à ce que la planète soit complètement\nparalysée!)", german="(Die Zerstörung der Zeit würde sich\nbeschleunigen...[K] So lange, bis der Planet völlig\ngelähmt ist!)", italian="(... la distruzione si farebbe più rapida...[K]\nfinché il pianeta non rimarrà completamente\nparalizzato!)", spanish="(El tiempo se destruiría...[K] ¡y el planeta\nse paralizaría completamente!)"})
  end
  -- message_Close
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('1', '1', '1', '0')
  GAME:WaitFrames(15)
  -- GAP: se_Play(8455) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 1) -- screen_WhiteOut
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
