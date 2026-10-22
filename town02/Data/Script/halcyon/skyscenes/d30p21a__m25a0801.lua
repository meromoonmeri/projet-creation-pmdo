-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D30P21A/m25a0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(26, 4) -- $SCENARIO_MAIN = scn[26,4] (ROM)
  -- back_SetGround(LEVEL_D30P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_TEMPORAL_SPIRE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(partner, 208, 284, false, 2)
  GROUND:MoveToPosition(hero, 248, 284, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We've climbed pretty far up.", french=" Ça fait un moment qu'on grimpe.", german="Wir sind ziemlich weit\nnach oben gestiegen.", italian="Abbiamo già fatto un bel po' di\nstrada.", spanish=" Ya hemos subido bastante."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We've climbed a long ways up.", french=" Ça fait un moment qu'on grimpe.", german="Wir sind ganz schön hoch\ngeklettert.", italian="Abbiamo già fatto un bel po' di\nstrada.", spanish=" Ya hemos subido bastante."})
  else
  SkySceneKit.say({english=" We've come up a long way.", french=" Ça fait un moment qu'on grimpe.", german=" Wir sind sehr weit gekommen.", italian="Abbiamo già fatto un bel po' di\nstrada.", spanish=" Ya hemos subido bastante."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I wonder how much more we\nhave to go to the top...?", french="Je me demande si le sommet est\nencore loin...", german="Ich frage mich, wie weit es noch\nbis ganz oben ist...", italian="Quanto mancherà per arrivare in\ncima...?", spanish="Me pregunto cuánto quedará\npara alcanzar la cima."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="How much farther is it to the\ntop...?", french="Je me demande si le sommet est\nencore loin...", german="Wie weit ist es noch\nbis ganz oben?", italian="Quanto mancherà per arrivare in\ncima...?", spanish="Me pregunto cuánto quedará\npara alcanzar la cima."})
  else
  SkySceneKit.say({english="I wonder how much more we\nhave to climb to reach the top...?", french="Je me demande si le sommet est\nencore loin...", german="Ich frage mich, wie weit wir\nnoch bis ganz oben gehen müssen...", italian="Quanto mancherà per arrivare in\ncima...?", spanish="Me pregunto cuánto quedará\npara alcanzar la cima."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5130) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '2', '0')
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa![K] Another quake!", french=" Ouaaah![K] Encore une secousse!", german=" Aaaah![K] Noch ein Beben!", italian=" Ah-aaah![K] Un'altra scossa!", spanish=" ¡Vaya![K] ¡Otro temblor!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wa-waah![K] Another tremor!", french=" Ouaaah![K] Encore une secousse!", german="W-waah![K] Noch eine\nErschütterung!", italian=" Ah-aaah![K] Un'altra scossa!", spanish=" ¡Vaya![K] ¡Otro temblor!"})
  else
  SkySceneKit.say({english=" Wa-waah![K] Another tremor!", french=" Ouaaah![K] Encore une secousse!", german="W-waah![K] Noch eine\nErschütterung!", italian=" Ah-aaah![K] Un'altra scossa!", spanish=" ¡Vaya![K] ¡Otro temblor!"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  -- se_FadeOut(5130, 90) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(60)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...[K]That quake was really strong.", french="...[K] Celle-là était encore plus\nforte que la précédente.", german="...[K]Dieses Beben war ziemlich\nheftig.", italian="...[K] Questa scossa è stata\ndavvero forte.", spanish="Uf...[K] Este terremoto ha sido\naún más fuerte."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...[K]That tremor was powerful.", french="...[K] Celle-là était encore plus\nforte que la précédente.", german="...[K]Diese Erschütterung war\nsehr intensiv.", italian="...[K] Questo tremore è stato\npiù potente.", spanish="Uf...[K] Este terremoto ha sido\naún más fuerte."})
  else
  SkySceneKit.say({english=" ...[K]That tremor was really strong.", french="...[K] Celle-là était encore plus\nforte que la précédente.", german="...[K]Diese Erschütterung war\nwirklich heftig.", italian="...[K] Questa scossa è stata\ndavvero forte.", spanish="Uf...[K] Este terremoto ha sido\naún más fuerte."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It must be getting worse...", french=" Ça doit empirer...", german=" Es wird wohl noch schlimmer...", italian=" La situazione sta peggiorando...", spanish="La situación parece empeorarse\npor momentos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It must be getting worse...", french=" Ça doit empirer...", german=" Es wird wohl noch schlimmer...", italian=" La situazione sta peggiorando...", spanish="La situación parece empeorarse\npor momentos."})
  else
  SkySceneKit.say({english=" It must be getting worse...", french=" Ça doit empirer...", german=" Es wird wohl noch schlimmer...", italian=" La situazione sta peggiorando...", spanish="La situación parece empeorarse\npor momentos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The tower must be falling apart\nfaster...", french="L'écroulement de la tour\ns'accélère...", german="Der Turm scheint immer\nschneller zusammenzufallen.", italian=" La torre crollerà in fretta...", spanish="¡La torre debe de estar a punto\nde derrumbarse!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The tower must be falling apart\nfaster...", french="L'écroulement de la tour\ns'accélère...", german="Der Turm scheint immer\nschneller zusammenzufallen.", italian=" La torre crollerà in fretta...", spanish="¡La torre debe de estar a punto\nde derrumbarse!"})
  else
  SkySceneKit.say({english="The tower must be breaking up\nfaster...", french="L'écroulement de la tour\ns'accélère...", german="Der Turm bricht anscheinend\nimmer schneller auseinander.", italian=" La torre crollerà in fretta...", spanish="¡La torre debe de estar a punto\nde derrumbarse!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I'm not sure it's true, but...", french="Je ne sais pas si c'est le cas,\nmais...", german="Ich weiß nicht, ob das stimmt,\naber...", italian=" Non so se è vero, ma...", spanish=" No sé si será verdad, pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I'm not sure it's true, but...", french="Je ne sais pas si c'est le cas,\nmais...", german="Ich weiß nicht, ob das stimmt,\naber...", italian=" Non so se è vero, ma...", spanish=" No sé si será verdad, pero..."})
  else
  SkySceneKit.say({english=" I'm not sure it's true, but...", french="Je ne sais pas si c'est le cas,\nmais...", german="Ich weiß nicht, ob das stimmt,\naber...", italian=" Non so se è vero, ma...", spanish=" No sé si será verdad, pero..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If [CS:P]Temporal Tower[CR] controls\ntime like [CS:N]Lapras[CR] said...", french="... si la [CS:P]Tour du Temps[CR] régule\nle cours du temps comme l'a dit [CS:N]Lokhlass[CR]...", german="Wenn der [CS:P]Zeitturm[CR] die Zeit so\nkontrolliert, wie [CS:N]Lapras[CR] es sagte...", italian="Se la [CS:P]Torre del Tempo[CR] controlla\nil flusso del tempo come ha detto [CS:N]Lapras[CR]...", spanish="Si la [CS:P]Torre del Tiempo[CR] controla\nel tiempo, tal y como dijo [CS:N]Lapras[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If [CS:P]Temporal Tower[CR] regulates\ntime like [CS:N]Lapras[CR] said...", french="... si la [CS:P]Tour du Temps[CR] régule\nle cours du temps comme l'a dit [CS:N]Lokhlass[CR]...", german="Wenn der [CS:P]Zeitturm[CR] die Zeit so\nreguliert, wie [CS:N]Lapras[CR] es sagte...", italian="Se la [CS:P]Torre del Tempo[CR] controlla\nil flusso del tempo come ha detto [CS:N]Lapras[CR]...", spanish="Si la [CS:P]Torre del Tiempo[CR] controla\nel tiempo, tal y como dijo [CS:N]Lapras[CR]..."})
  else
  SkySceneKit.say({english="If [CS:P]Temporal Tower[CR] regulates\ntime like [CS:N]Lapras[CR] said...", french="... si la [CS:P]Tour du Temps[CR] régule\nle cours du temps comme l'a dit [CS:N]Lokhlass[CR]...", german="Wenn der [CS:P]Zeitturm[CR] die Zeit so\nreguliert, wie [CS:N]Lapras[CR] es sagte...", italian="Se la [CS:P]Torre del Tempo[CR] controlla\nil flusso del tempo come ha detto [CS:N]Lapras[CR]...", spanish="Si la [CS:P]Torre del Tiempo[CR] controla\nel tiempo, tal y como dijo [CS:N]Lapras[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Then, if the tower collapses...", french="... alors dès qu'elle se sera\neffondrée...", german="Dann wird, sobald der Turm\nkollabiert...", italian=" ... allora, se crolla...", spanish=" Y se derrumba..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Then, if the tower collapses...", french="... alors dès qu'elle se sera\neffondrée...", german="Dann wird, sobald der Turm\nkollabiert...", italian=" ... allora, se crolla...", spanish=" Y se derrumba..."})
  else
  SkySceneKit.say({english=" Then, if the tower collapses...", french="... alors dès qu'elle se sera\neffondrée...", german="Dann wird, sobald der Turm\nkollabiert...", italian=" ... allora, se crolla...", spanish=" Y se derrumba..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Our planet's paralysis will begin.", french=" ... la planète sera paralysée.", german="Dann wird die Lähmung des\nPlaneten einsetzen!", italian="... avrà inizio la paralisi del\nnostro pianeta.", spanish="Nuestro planeta empezará a\nparalizarse."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Our planet's paralysis will begin.", french=" ... la planète sera paralysée.", german="Dann wird die Lähmung des\nPlaneten einsetzen!", italian="... avrà inizio la paralisi del\nnostro pianeta.", spanish="Nuestro planeta empezará a\nparalizarse."})
  else
  SkySceneKit.say({english=" Our planet's paralysis will begin.", french=" ... la planète sera paralysée.", german="Dann wird die Lähmung des\nPlaneten einsetzen!", italian="... avrà inizio la paralisi del\nnostro pianeta.", spanish="Nuestro planeta empezará a\nparalizarse."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5131) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- se_FadeOut(5131, 90) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(45)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So let's move it, [hero]!", french="Pas de temps à perdre,\n[hero]!", german="Also, setzen wir uns in\nBewegung, [hero]!", italian="Quindi muoviamoci,\n[hero]!", spanish="¡Así que démonos prisa,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So let's hustle, [hero]!", french="Pas de temps à perdre,\n[hero]!", german="Also, legen wir besser los,\n[hero]!", italian="Quindi sbrighiamoci,\n[hero]!", spanish="¡Así que démonos prisa,\n[hero]!"})
  else
  SkySceneKit.say({english=" So let's hurry, [hero]!", french="Pas de temps à perdre,\n[hero]!", german="Also, beeilen wir uns,\n[hero]!", italian="Quindi facciamo in fretta,\n[hero]!", spanish="¡Así que démonos prisa,\n[hero]!"})
  end
  -- message_Close
end
