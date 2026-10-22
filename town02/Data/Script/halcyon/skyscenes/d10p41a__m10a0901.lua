-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D10P41A/m10a0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(16, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D10P41A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GROUND:MoveToPosition(partner, 304, 228, false, 2)
  GROUND:MoveToPosition(hero, 344, 228, false, 2)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We've climbed way up!", french=" On a bien avancé jusqu'ici!", german="Wir sind sehr weit nach oben\ngestiegen!", italian=" Sì! Ce l'abbiamo fatta!", spanish=" Ya casi estamos en la cima."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We've climbed far up!", french=" On a bien avancé jusqu'ici!", german="Wir sind ganz nach oben\ngestiegen!", italian=" Siamo arrivati!", spanish=" Ya casi estamos en la cima."})
  else
  SkySceneKit.say({english=" We've climbed far up!", french=" On a bien avancé jusqu'ici!", german="Wir sind ganz nach oben\ngestiegen!", italian=" Ci siamo!", spanish=" Ya casi estamos en la cima."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This place...[K] It feels...[K] It feels\nstrange somehow...", french="Cet endroit...[K] j'ai un\nsentiment...[K] étrange, d'une certaine\nmanière...", german="Dieser Ort...[K] Er fühlt sich...[K]\nEr fühlt sich irgendwie seltsam an...", italian="Questo posto...[K] mmm...[K] mi dà\nuna strana sensazione...", spanish="Este lugar...[K] resulta...[K]\nresulta un tanto extraño..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This place...[K] It feels...[K] It feels\nstrange somehow...", french="Cet endroit...[K] j'ai un\nsentiment...[K] étrange, d'une certaine\nmanière...", german="Dieser Ort...[K] Er fühlt sich...[K]\nEr fühlt sich irgendwie seltsam an...", italian="Questo posto...[K] sembra...[K]\nsembra un po' strano, non credi?", spanish="Este lugar...[K] resulta...[K]\nresulta un tanto extraño..."})
  else
  SkySceneKit.say({english="This place...[K] It feels...[K] It feels\nstrange somehow...", french="Cet endroit...[K] j'ai un\nsentiment...[K] étrange, d'une certaine\nmanière...", german="Dieser Ort...[K] Er fühlt sich...[K]\nEr fühlt sich irgendwie seltsam an...", italian="Questo posto...[K] sembra...[K]\nsembra un po' strano, non credi?", spanish="Este lugar...[K] resulta...[K]\nresulta un tanto extraño..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" The air is full of tension!", french="Je sens une énorme tension\ndans l'air!", german=" Die Luft ist voller Spannung!", italian="Avverto un bel po' di tensione\nqui!", spanish="Se respira tensión en el\nambiente."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The very air is charged\nwith tension!", french="Je sens une énorme tension\ndans l'air!", german="Es liegt eine Spannung in der\nLuft!", italian="Avverto una forte tensione\nnell'aria!", spanish="Se respira tensión en el\nambiente."})
  else
  SkySceneKit.say({english="The very air is charged\nwith tension!", french="Je sens une énorme tension\ndans l'air!", german="Es liegt eine Spannung in der\nLuft!", italian="Avverto una forte tensione\nnell'aria!", spanish="Se respira tensión en el\nambiente."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's making my skin crawl...[K]\nall over...", french="J'en ai la chair de poule...[K]\ntout partout...", german="Meine Haut kribbelt...[K]\nÜberall...", italian="Mmm... Mi stanno venendo i\nbrividi...[K] Ma che...", spanish="Se me está poniendo la piel\nde gallina.[K] En serio."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's making my skin crawl...[K]\nall over...", french="J'en ai la chair de poule...[K]\ntout partout...", german="Meine Haut kribbelt...[K]\nÜberall...", italian=" Mi vengono...[K] i brividi...", spanish="Se me está poniendo la piel\nde gallina.[K] En serio."})
  else
  SkySceneKit.say({english="It's making my skin crawl...[K]\nall over...", french="J'en ai la chair de poule...[K]\ntout partout...", german="Meine Haut kribbelt...[K]\nÜberall...", italian=" Mi vengono...[K] i brividi...", spanish="Se me está poniendo la piel\nde gallina.[K] En serio."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I feel like I'm being crushed...[K]\nby a terrible sense of danger...", french="J'ai un horrible pressentiment...\ncomme si un terrible danger nous guettait...", german="Es fühlt sich an, als würde mich\netwas erdrücken...[K] Irgendeine\nschreckliche Gefahr...", italian="Mi sento schiacciare...[K]\nda un forte senso di pericolo...", spanish="Tengo una sensación extraña.[K]\nComo si estuviera en peligro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I feel like I'm being crushed...[K]\nby a terrible sense of danger...", french="J'ai un horrible pressentiment...\ncomme si un terrible danger nous guettait...", german="Es fühlt sich an, als würde mich\netwas erdrücken...[K] Irgendeine\nschreckliche Gefahr...", italian="Mi sento schiacciare...[K]\nda un forte senso di pericolo...", spanish="Tengo una sensación extraña.[K]\nComo si estuviera en peligro."})
  else
  SkySceneKit.say({english="I feel like I'm being crushed...[K]\nby a terrible sense of danger...", french="J'ai un horrible pressentiment...\ncomme si un terrible danger nous guettait...", german="Es fühlt sich an, als würde mich\netwas erdrücken...[K] Irgendeine\nschreckliche Gefahr...", italian="Mi sento schiacciare...[K]\nda un forte senso di pericolo...", spanish="Tengo una sensación extraña.[K]\nComo si estuviera en peligro."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  SkySceneKit.say({english="GRROOOOOOH...GRROOOOOOH...!", french="GRROOOOOOH... GRROOOOOOH...!", german="GRROOOOOOH... GRROOOOOOH!", italian="GRROOOOOOH... GRROOOOOOH...!", spanish="¡GRRRRRRRR! ¡GRRRRRRRR!"}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Eep!", french=" Brrr!", german=" Argh!", italian=" Ehi!", spanish=" ¡Aaay!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Eep!", french=" Brrr!", german=" Argh!", italian=" Ehi!", spanish=" ¡Aaay!"})
  else
  SkySceneKit.say({english=" Eep!", french=" Brrr!", german=" Argh!", italian=" Ehi!", spanish=" ¡Aaay!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's that sound we heard earlier,\n[hero]!", french="C'est le même bruit que\ntout à l'heure, [hero]!", german="Das ist das Geräusch von\nvorhin, [hero]!", italian="È quel suono di prima,\n[hero]!", spanish="¡Es el mismo ruido de antes,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's that sound we heard earlier,\n[hero]!", french="C'est le même bruit que\ntout à l'heure, [hero]!", german="Das ist das Geräusch von\nvorhin, [hero]!", italian="È lo stesso suono di prima,\n[hero]!", spanish="¡Es el mismo ruido de antes,\n[hero]!"})
  else
  SkySceneKit.say({english="It's that sound we heard earlier,\n[hero]!", french="C'est le même bruit que\ntout à l'heure, [hero]!", german="Das ist das Geräusch von\nvorhin, [hero]!", italian="È lo stesso suono di prima,\n[hero]!", spanish="¡Es el mismo ruido de antes,\n[hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I knew it![K] It was roaring!", french="Je le savais![K] C'est bel et bien\nun rugissement!", german="Ich wusste es![K] Es war ein\nBrüllen!", italian="È come dicevo io![K] È un\nruggito!", spanish=" ¡Lo sabía![K] ¡Era un rugido!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Just as I thought![K] It was the\nsound of roaring!", french="Je le savais![K] C'est bel et bien\nun rugissement!", german="Genau, wie ich mir gedacht\nhabe![K] Es war ein lautes Brüllen!", italian="È proprio come pensavo![K] Si\ntratta di un ruggito!", spanish="¡Lo sabía![K]\n¡Lo que oí era un rugido!"})
  else
  SkySceneKit.say({english="I thought it might...[K]be roaring!\nAnd it is!", french="Je le savais![K] C'est bel et bien\nun rugissement!", german="Ich wusste es.[K] Es war ein\nBrüllen! Ich hatte recht!", italian="È proprio come pensavo![K] Si\ntratta di un ruggito!", spanish="Sabía que podía ser un rugido.[K]\n¡Y lo es!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  SkySceneKit.say({english="GRROOOOOOH...!", french="GRROOOOOOH...!", german="GRROOOOOOH!", italian="GRROOOOOOH...!", spanish="¡GRRRRRRRRRR!"}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  GAME:WaitFrames(30)
  -- GAP: se_Play(6915) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '2', '0')
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  -- MoveHeight(2, 5) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(2, 5) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(60)
  -- GAP: se_Play(6915) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '2', '0')
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  -- MoveHeight(2, 5) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(2, 5) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" S-s-something is...", french=" Quelque chose...", german=" I-i-irgendetwas...", italian=" Q-Q-Qualcosa...", spanish=" Al... algo se..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" S-s-something is...", french=" Quelque chose...", german=" I-i-irgendetwas...", italian=" Q-Q-Qualcosa...", spanish=" Al... algo se..."})
  else
  SkySceneKit.say({english=" S-s-something is...", french=" Quelque chose...", german=" I-i-irgendetwas...", italian=" Q-Q-Qualcosa...", spanish=" Al... algo se..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...is...[K]coming!", french=" ... quelque chose...[K] se rapproche!", german=" Irgendetwas[K] kommt auf uns zu!", italian=" ... sta...[K] arrivando!", spanish=" Algo...[K] ¡se acerca!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...is...[K]coming!", french=" ... quelque chose...[K] se rapproche!", german=" Irgendetwas[K] kommt auf uns zu!", italian=" ... sta...[K] arrivando!", spanish=" Algo...[K] ¡se acerca!"})
  else
  SkySceneKit.say({english=" ...is...[K]coming!", french=" ... quelque chose...[K] se rapproche!", german=" Irgendetwas[K] kommt auf uns zu!", italian=" ... sta...[K] arrivando!", spanish=" Algo...[K] ¡se acerca!"})
  end
  -- message_Close
  GAME:FadeOut(false, 15)
end
